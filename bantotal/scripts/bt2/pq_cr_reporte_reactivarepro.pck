create or replace package PQ_CR_REPORTE_REACTIVAREPRO is

  -- Author  : RMONTESR
  -- Created : 9/05/2022 18:30:38
  -- Purpose : Paquete con procedimientos para reporte reactiva Reprogramados
  
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
  procedure sp_cr_sch_reactivarepro_sinjob(pd_fecpro in date, pn_usuario in varchar2);
  ------------------------------------------------------------------
  procedure sp_cr_sch_reactivarepro2(pd_fecpro in date, pn_suc in number, pn_usuario in varchar2);
  -----------------------------------------------------------------------
  procedure sp_guardar_historico(pn_usuario char, pn_fcorte date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_sch_reactivarepro_ant(pd_fecpro  in date,
                               pn_usuario in varchar2
                               --,pn_flag out varchar2
                               );
  procedure sp_cr_sch_reactivarepro(pd_fecpro  in date,
                               pn_usuario in varchar2
                               --,pn_flag out varchar2
                               );

end PQ_CR_REPORTE_REACTIVAREPRO;
/

create or replace package body PQ_CR_REPORTE_REACTIVAREPRO is

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
        -- PAE MYPE
      
        pn_flag := 'S';
      
        --- Obtener el correlativo
        select nvl(max(t.aqpc351acor), 0) + 1 into pn_corr from aqpc351a t;
      
        --- Reporte PAE MYPE
        insert into aqpc351a
          (aqpc351acod,
           aqpc351afec,
           aqpc351acor,
           aqpc351aest,
           aqpc351ausr,
           aqpc351afcr,
           aqpc351ahcr)
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
        ---PAE MYPE
      
        pn_flag := 'S';
      
        --Actualización del detalle de la plantilla
        update aqpc351b t
           set t.aqpc351best  = pn_estado,
               t.aqpc351busu  = pn_usuario,
               t.aqpc351bfedi = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpc351bhedi = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpc351bcod = pn_pgcod
           and t.aqpc351bfec = pn_fecha
           and t.aqpc351bcor = pn_corr
           and t.aqpc351best <> 'D';
        commit;
      
        update aqpc351a t
           set t.aqpc351aest = pn_estado,
               t.aqpc351ausd = pn_usuario,
               t.aqpc351afed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpc351ahed = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpc351acod = pn_pgcod
           and t.aqpc351afec = pn_fecha
           and t.aqpc351acor = pn_corr;
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
        -- PAE MYPE
      
        pn_flag := 'S';
      
        --- Obtener el correlativo
        select nvl(max(t.aqpc351acor), 0) + 1 into pn_corr from aqpc351a t;
      
        --- Reporte pae mype
        insert into aqpc351a
          (aqpc351acod,
           aqpc351afec,
           aqpc351acor,
           aqpc351aest,
           aqpc351ausr,
           aqpc351afcr,
           aqpc351ahcr)
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
      
        update aqpc351a t
           set t.aqpc351aest = pn_estado,
               t.aqpc351ausd = pn_usuario,
               t.aqpc351afed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpc351ahed = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpc351acod = pn_pgcod
           and t.aqpc351afec = pn_fecha
           and t.aqpc351acor = pn_corr;
        commit;
      
    end case;
  
  end sp_actualizar_pauxiliar;
  ------------------------------------------------------------------
  procedure sp_cr_sch_reactivarepro_sinjob(pd_fecpro in date, pn_usuario in varchar2) is
  ld_fecha_rcc date;
  ln_nro_mes number;  
  ld_fecha date;                         
  begin
    begin
      delete from aqpc351 x
       where x.aqpc351usur = rpad(trim(pn_usuario), 10, ' ');
      commit;
    exception when others then null;  
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
      --vigentes
      insert into aqpc351(aqpc351usur,
                          aqpc351cta,
                          aqpc351oper,
                          aqpc351emp,
                          aqpc351mod,
                          aqpc351suc ,
                          aqpc351mda,
                          aqpc351pap,
                          aqpc351sbop,
                          aqpc351tope,
                          aqpc351fsub,
                          aqpc351nsub,
                          aqpc351ncer,
                          aqpc351cocob,
                          aqpc351nact ,
                          aqpc351frepo,
                          aqpc351tdocsbs,
                          aqpc351tdocco,
                          aqpc351ndocco,
                          aqpc351tdoc,
                          aqpc351ndoc,
                          aqpc351csbs,
                          aqpc351rzsc,
                          aqpc351ciiu,
                          aqpc351npre ,
                          aqpc351mone ,
                          aqpc351mto,
                          aqpc351prccob,
                          aqpc351mtocob ,
                          aqpc351sdo ,
                          aqpc351sdoin ,
                          aqpc351tear,
                          aqpc351plaz,
                          aqpc351pgra,
                          aqpc351finico,
                          aqpc351fini,
                          aqpc351ffin,
                          aqpc351tcre,
                          aqpc351fcsbs,
                          aqpc351snor,
                          aqpc351scpp,
                          aqpc351sdef,
                          aqpc351sdud,
                          aqpc351sper,
                          aqpc351vent,
                          aqpc351codhon,
                          aqpc351datr,
                          aqpc351moncof,
                          aqpc351placof,
                          aqpc351percof,
                          aqpc351estc,
                          aqpc351fcest,
                          aqpc351fcanc ,
                          aqpc351capcanc ,
                          aqpc351rgon,
                          aqpc351zona ,
                          aqpc351agen,
                          aqpc351anl,
                          aqpc351chon ,
                          aqpc351fhon,
                          aqpc351mhon,
                          aqpc351sdohon ,
                          aqpc351crehon ,
                          aqpc351tmor,
                          aqpc351tinto,
                          aqpc351fproc ,
                          aqpc351fcr ,
                          aqpc351hcr)
             select rpad(trim(pn_usuario), 10, ' '), --usuario
              t1.aocta,
              t1.aooper,
              t1.pgcod,
              t1.aomod,
              t1.aosuc,
              t1.aomda,
              t1.aopap,
              t1.aosbop,
              t1.aotope,
              t3.aqpc351bfsub,
              trim(t3.aqpc351bnsub),
              t3.aqpc351bncer,
              t3.aqpc351bcocob,
              t3.aqpc351bnact ,
              t3.aqpc351bfrepo,
              case when trim(t3.aqpc351btdoc) = 'DNI' then 1 else 6 end,--aqpc351tdocsbs,
              t3.aqpc351btdoc,
              TRIM(t3.aqpc351bndoc),
              case when t2.petdoc = 21 then 'DNI' else 'RUC' end,
              trim(t2.pendoc),
              trim(t16.v_csbs), --cod sbs
              nvl(trim(substr(t11.pjrazs,0,60)),substr(concat(trim(t10.pfape1), concat(' ', concat(trim(t10.pfape2), concat(' ',concat(trim(t10.pfnom1), concat(' ', t10.pfnom2)))))),1,60)), --razon social
              case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu
              concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 2, '0'),lpad(to_char(t1.aooper), 9, '0'))), --numero prestamo
              'PEN',
              t1.aoimp,
              t3.aqpc351bprccob,
              round(t5.v_saldo_inso * t3.aqpc351bprccob,2) / 100,
              t1.aoimp, -- monto desembolsado
              t5.v_saldo_inso, --saldo insoluto
              t31.v_tear,--aqpc351tear, 
              round((t25.v_fult-t3.aqpc351bfinire)/30),
              t25.v_peri,
              t3.aqpc351bfinire,
              t25.v_fech,
              t25.v_fult,
              case when t18.v_pcre = 2 then '10' when t18.v_pcre = 11 then '07'
                when t18.v_pcre = 12 then '08' when t18.v_pcre = 13 then '09'
                when t18.v_pcre = 5 then '06' when t18.v_pcre = 6 then '06'
                when t18.v_pcre = 7 then '06' when t18.v_pcre = 8 then '06'
                when t18.v_pcre = 9 then '06' when t18.v_pcre = 10 then '06' else '0' end,--tipo de crdito cofide
              ld_fecha_rcc,--aqpb763fcsbs,--fecha clasificacion sbs
              t16.v_calif0, --califiacion sbs normal
              t16.v_calif1, --califiacion sbs cpp
              t16.v_calif2, --califiacion sbs deficiente
              t16.v_calif3, --califiacion sbs dudoso
              t16.v_calif4, --califiacion sbs perdida
              t3.aqpc351bnven,--aqpc351vent,
              case when t25.v_flag = 'SI' then '2'else (case when t22.aqpb434fecr is null then '0' else '1' end) end, --codigo honra,--aqpc351codhon,
              t15.v_diatr, --dias de atraso
              t3.aqpc351bmoncof,
              t3.aqpc351bplacof,
              t3.aqpc351bpercof,
              t28.cenom,--estado del credito
              case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                                     (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )
                                     else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end )end , --fecha de cuando se realizo cambio de estado
              t1.aofe99,
              t4.v_saldo_canc,--aqpc351capcanc ,
              t8.regnom, --region
              t9.tp1desc, --zona
              t6.scnom, --agencia
              t27.v_ase, --analista
              case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)
              t22.aqpb434fecr, --fecha de honramiento
              t22.aqpb434mto, --monto honrado
              t24.v_saldo_honrado,-- SALDO HONRADO
              t4.v_saldo_actual +t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado
              t30.v_tmor,--aqpb763team, --tasa moratoria
              t1.aotasa,--aqpb763tea,  --tea
              pd_fecpro, --fecha proceso,
              to_char(sysdate, 'DD/MM/YYYY'),
                    to_char(sysdate, 'HH24:MI:SS')
                    
                    from aqpc351b t3                     
                    inner join fsd010 t1 on t3.aqpc351bcod = t1.pgcod and t3.aqpc351bcta = t1.aocta and t3.aqpc351bope = t1.aooper
                  --  left join fsd011 t26 on t26.pgcod = t1.pgcod  and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3,t1.aostat)) t5 on 1=1
                    left join fst001 t6 on t6.pgcod = t1.pgcod and t6.sucurs = t1.aosuc 
                    left join fst811 t7 on t7.pgcod = t1.pgcod and t7.oficod = t1.aosuc and t7.regcod < 100 and t7.regcod <> 0
                    left join fst810 t8 on t8.pgcod = t7.pgcod and t8.regcod = t7.regcod
                    left join fst198 t9 on t9.tp1cod = 1 and t9.tp1cod1 = 10872 and t9.tp1corr1 = 11 and t9.tp1nro2 = t7.regcod
                    left join fsd002 t10 on t10.pfpais = t2.pepais and t10.pftdoc = t2.petdoc and t10.pfndoc = t2.pendoc
                    left join fsd003 t11 on t11.pjpais = t2.pepais and t11.pjtdoc = t2.petdoc and t11.pjndoc = t2.pendoc
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_fechas_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t12 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fpagu)) t13 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_fvcuo_impaga(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t14 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1        
                    left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_acti_eco(t2.pepais,t2.petdoc,t2.pendoc)) t17 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tipo_credito_sbs_vig(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t18 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_mprepago(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1 
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_calf_caja(t1.aocta,pd_fecpro)) t21 on 1=1                      
                    left join aqpb434 t22 on t22.aqpb434cod = t1.pgcod and t22.aqpb434cta = t1.aocta and t22.aqpb434ope = t1.aooper and t22.aqpb434est = 'C' 
                  --  left join fst750 t23 on t23.actcod1 = t17.v_ciuu6 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_honrado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,9300082070000,pd_fecpro)) t24 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_repro_dato1(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t25 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_analista_credito(t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t27 on 1=1
                    left join fst026 t28 on t28.cecod = t1.aostat
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tea_repro(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t31 on 1=1
                    where t1.aomod =101
                    and t1.aomod in (select modulo
                     from fst111
                    where dscod = 50
                      and modulo not in (29, 120, 144))
                    and t1.aostat <>99
                    and t3.aqpc351best <> 'D'
                    and t1.aofval <= pd_fecpro ;     
                    commit;
                                    
        --cancelados 
        insert into aqpc351(aqpc351usur,
                          aqpc351cta,
                          aqpc351oper,
                          aqpc351emp,
                          aqpc351mod,
                          aqpc351suc ,
                          aqpc351mda,
                          aqpc351pap,
                          aqpc351sbop,
                          aqpc351tope,
                          aqpc351fsub,
                          aqpc351nsub,
                          aqpc351ncer,
                          aqpc351cocob,
                          aqpc351nact ,
                          aqpc351frepo,
                          aqpc351tdocsbs,
                          aqpc351tdocco,
                          aqpc351ndocco,
                          aqpc351tdoc,
                          aqpc351ndoc,
                          aqpc351csbs,
                          aqpc351rzsc,
                          aqpc351ciiu,
                          aqpc351npre ,
                          aqpc351mone ,
                          aqpc351mto,
                          aqpc351prccob,
                          aqpc351mtocob ,
                          aqpc351sdo ,
                          aqpc351sdoin ,
                          aqpc351tear,
                          aqpc351plaz,
                          aqpc351pgra,
                          aqpc351finico,
                          aqpc351fini,
                          aqpc351ffin,
                          aqpc351tcre,
                          aqpc351fcsbs,
                          aqpc351snor,
                          aqpc351scpp,
                          aqpc351sdef,
                          aqpc351sdud,
                          aqpc351sper,
                          aqpc351vent,
                          aqpc351codhon,
                          aqpc351datr,
                          aqpc351moncof,
                          aqpc351placof,
                          aqpc351percof,
                          aqpc351estc,
                          aqpc351fcest,
                          aqpc351fcanc ,
                          aqpc351capcanc ,
                          aqpc351rgon,
                          aqpc351zona ,
                          aqpc351agen,
                          aqpc351anl,
                          aqpc351chon ,
                          aqpc351fhon,
                          aqpc351mhon,
                          aqpc351sdohon ,
                          aqpc351crehon ,
                          aqpc351tmor,
                          aqpc351tinto,
                          aqpc351fproc ,
                          aqpc351fcr ,
                          aqpc351hcr)
             select rpad(trim(pn_usuario), 10, ' '), --usuario
              t1.aocta,
              t1.aooper,
              t1.pgcod,
              t1.aomod,
              t1.aosuc,
              t1.aomda,
              t1.aopap,
              t1.aosbop,
              t1.aotope,
              t3.aqpc351bfsub,
              trim(t3.aqpc351bnsub),
              t3.aqpc351bncer,
              t3.aqpc351bcocob,
              t3.aqpc351bnact ,
              t3.aqpc351bfrepo,
              case when trim(t3.aqpc351btdoc) = 'DNI' then 1 else 6 end,--aqpc351tdocsbs,
              t3.aqpc351btdoc,
              TRIM(t3.aqpc351bndoc),
              case when t2.petdoc = 21 then 'DNI' else 'RUC' end,
              trim(t2.pendoc),
              trim(t16.v_csbs), --cod sbs
              nvl(trim(substr(t11.pjrazs,0,60)),substr(concat(trim(t10.pfape1), concat(' ', concat(trim(t10.pfape2), concat(' ',concat(trim(t10.pfnom1), concat(' ', t10.pfnom2)))))),1,60)), --razon social
              case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu
              concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 2, '0'),lpad(to_char(t1.aooper), 9, '0'))), --numero prestamo
              'PEN',
              t1.aoimp,
              t3.aqpc351bprccob,
              round(t5.v_saldo_inso * t3.aqpc351bprccob,2) / 100,
              t1.aoimp, -- monto desembolsado
              t5.v_saldo_inso, --saldo insoluto
              t31.v_tear,--aqpc351tear, 
              round((t25.v_fult-t3.aqpc351bfinire)/30),
              t25.v_peri,
              t3.aqpc351bfinire,
              t25.v_fech,
              t25.v_fult,
              case when t18.v_pcre = 2 then '10' when t18.v_pcre = 11 then '07'
                when t18.v_pcre = 12 then '08' when t18.v_pcre = 13 then '09'
                when t18.v_pcre = 5 then '06' when t18.v_pcre = 6 then '06'
                when t18.v_pcre = 7 then '06' when t18.v_pcre = 8 then '06'
                when t18.v_pcre = 9 then '06' when t18.v_pcre = 10 then '06' else '0' end,--tipo de crdito cofide
              ld_fecha_rcc,--aqpb763fcsbs,--fecha clasificacion sbs
              t16.v_calif0, --califiacion sbs normal
              t16.v_calif1, --califiacion sbs cpp
              t16.v_calif2, --califiacion sbs deficiente
              t16.v_calif3, --califiacion sbs dudoso
              t16.v_calif4, --califiacion sbs perdida
              t3.aqpc351bnven,--aqpc351vent,
              case when t25.v_flag = 'SI' then '2'else (case when t22.aqpb434fecr is null then '0' else '1' end) end, --codigo honra,--aqpc351codhon,
              t15.v_diatr, --dias de atraso
              t3.aqpc351bmoncof,
              t3.aqpc351bplacof,
              t3.aqpc351bpercof,
              t28.cenom,--estado del credito
              case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                                     (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )
                                     else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end )end , --fecha de cuando se realizo cambio de estado
              t1.aofe99,
              t4.v_saldo_canc,--aqpc351capcanc ,
              t8.regnom, --region
              t9.tp1desc, --zona
              t6.scnom, --agencia
              t27.v_ase, --analista
              case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)
              t22.aqpb434fecr, --fecha de honramiento
              t22.aqpb434mto, --monto honrado
              t24.v_saldo_honrado,-- SALDO HONRADO
              t4.v_saldo_actual +t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado
              t30.v_tmor,--aqpb763team, --tasa moratoria
              t1.aotasa,--aqpb763tea,  --tea
              pd_fecpro, --fecha proceso,
              to_char(sysdate, 'DD/MM/YYYY'),
                    to_char(sysdate, 'HH24:MI:SS')
                    
                    from aqpc351b t3                     
                    inner join fsd010 t1 on t3.aqpc351bcod = t1.pgcod and t3.aqpc351bcta = t1.aocta and t3.aqpc351bope = t1.aooper
                  --  left join fsd011 t26 on t26.pgcod = t1.pgcod  and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3,t1.aostat)) t5 on 1=1
                    left join fst001 t6 on t6.pgcod = t1.pgcod and t6.sucurs = t1.aosuc 
                    left join fst811 t7 on t7.pgcod = t1.pgcod and t7.oficod = t1.aosuc and t7.regcod < 100 and t7.regcod <> 0
                    left join fst810 t8 on t8.pgcod = t7.pgcod and t8.regcod = t7.regcod
                    left join fst198 t9 on t9.tp1cod = 1 and t9.tp1cod1 = 10872 and t9.tp1corr1 = 11 and t9.tp1nro2 = t7.regcod
                    left join fsd002 t10 on t10.pfpais = t2.pepais and t10.pftdoc = t2.petdoc and t10.pfndoc = t2.pendoc
                    left join fsd003 t11 on t11.pjpais = t2.pepais and t11.pjtdoc = t2.petdoc and t11.pjndoc = t2.pendoc
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_fechas_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t12 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fpagu)) t13 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_fvcuo_impaga(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t14 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1        
                    left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_acti_eco(t2.pepais,t2.petdoc,t2.pendoc)) t17 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tipo_credito_sbs_vig(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t18 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_mprepago(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1 
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_calf_caja(t1.aocta,pd_fecpro)) t21 on 1=1                      
                    left join aqpb434 t22 on t22.aqpb434cod = t1.pgcod and t22.aqpb434cta = t1.aocta and t22.aqpb434ope = t1.aooper and t22.aqpb434est = 'C' 
                  --  left join fst750 t23 on t23.actcod1 = t17.v_ciuu6 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_honrado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,9300082070000,pd_fecpro)) t24 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_repro_dato1(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t25 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_analista_credito(t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t27 on 1=1
                    left join fst026 t28 on t28.cecod = t1.aostat
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tea_repro(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t31 on 1=1
                    where t1.aomod =101
                    and t1.aomod in (select modulo
                     from fst111
                    where dscod = 50
                      and modulo not in (29, 120, 144))                    
                    and t3.aqpc351best <> 'D'
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
                    
                     and t1.aofe99 =
                     (select max(h.aofe99)
                        from fsd010 h
                       where h.pgcod = t1.pgcod
                         and h.aomod = t1.aomod                            
                         and h.aomda = t1.aomda
                         and h.aopap = t1.aopap
                         and h.aocta = t1.aocta
                         and h.aooper = t1.aooper
                            --and r.scsbop = t.aosbop
                            --and h.aotope = t.aotope
                         and h.aofe99 <= pd_fecpro
                            --and h.aomod <> 419
                         and h.aomod in (select modulo
                                           from fst111
                                          where dscod = 50
                                            and modulo not in (29, 120, 144)))
                    and t1.aofval <= pd_fecpro; 
        commit;
        --- modulo 200 y 33
        --vigentes
      insert into aqpc351(aqpc351usur,
                          aqpc351cta,
                          aqpc351oper,
                          aqpc351emp,
                          aqpc351mod,
                          aqpc351suc ,
                          aqpc351mda,
                          aqpc351pap,
                          aqpc351sbop,
                          aqpc351tope,
                          aqpc351fsub,
                          aqpc351nsub,
                          aqpc351ncer,
                          aqpc351cocob,
                          aqpc351nact ,
                          aqpc351frepo,
                          aqpc351tdocsbs,
                          aqpc351tdocco,
                          aqpc351ndocco,
                          aqpc351tdoc,
                          aqpc351ndoc,
                          aqpc351csbs,
                          aqpc351rzsc,
                          aqpc351ciiu,
                          aqpc351npre ,
                          aqpc351mone ,
                          aqpc351mto,
                          aqpc351prccob,
                          aqpc351mtocob ,
                          aqpc351sdo ,
                          aqpc351sdoin ,
                          aqpc351tear,
                          aqpc351plaz,
                          aqpc351pgra,
                          aqpc351finico,
                          aqpc351fini,
                          aqpc351ffin,
                          aqpc351tcre,
                          aqpc351fcsbs,
                          aqpc351snor,
                          aqpc351scpp,
                          aqpc351sdef,
                          aqpc351sdud,
                          aqpc351sper,
                          aqpc351vent,
                          aqpc351codhon,
                          aqpc351datr,
                          aqpc351moncof,
                          aqpc351placof,
                          aqpc351percof,
                          aqpc351estc,
                          aqpc351fcest,
                          aqpc351fcanc ,
                          aqpc351capcanc ,
                          aqpc351rgon,
                          aqpc351zona ,
                          aqpc351agen,
                          aqpc351anl,
                          aqpc351chon ,
                          aqpc351fhon,
                          aqpc351mhon,
                          aqpc351sdohon ,
                          aqpc351crehon ,
                          aqpc351tmor,
                          aqpc351tinto,
                          aqpc351fproc ,
                          aqpc351fcr ,
                          aqpc351hcr)
             select rpad(trim(pn_usuario), 10, ' '), --usuario
              t1.aocta,
              t1.aooper,
              t1.pgcod,
              t1.aomod,
              t1.aosuc,
              t1.aomda,
              t1.aopap,
              t1.aosbop,
              t1.aotope,
              t3.aqpc351bfsub,
              trim(t3.aqpc351bnsub),
              t3.aqpc351bncer,
              t3.aqpc351bcocob,
              t3.aqpc351bnact ,
              t3.aqpc351bfrepo,
              case when trim(t3.aqpc351btdoc) = 'DNI' then 1 else 6 end,--aqpc351tdocsbs,
              t3.aqpc351btdoc,
              TRIM(t3.aqpc351bndoc),
              case when t2.petdoc = 21 then 'DNI' else 'RUC' end,
              trim(t2.pendoc),
              trim(t16.v_csbs), --cod sbs
              nvl(trim(substr(t11.pjrazs,0,60)),substr(concat(trim(t10.pfape1), concat(' ', concat(trim(t10.pfape2), concat(' ',concat(trim(t10.pfnom1), concat(' ', t10.pfnom2)))))),1,60)), --razon social
              case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu
              concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 2, '0'),lpad(to_char(t1.aooper), 9, '0'))), --numero prestamo
              'PEN',
              t1.aoimp,
              t3.aqpc351bprccob,
              round(t5.v_saldo_inso * t3.aqpc351bprccob,2) / 100,
              t1.aoimp, -- monto desembolsado
              t5.v_saldo_inso, --saldo insoluto
              t31.v_tear,--aqpc351tear, 
              round((t25.v_fult-t3.aqpc351bfinire)/30),
              t25.v_peri,
              t3.aqpc351bfinire,
              t25.v_fech,
              t25.v_fult,
              case when t18.v_pcre = 2 then '10' when t18.v_pcre = 11 then '07'
                when t18.v_pcre = 12 then '08' when t18.v_pcre = 13 then '09'
                when t18.v_pcre = 5 then '06' when t18.v_pcre = 6 then '06'
                when t18.v_pcre = 7 then '06' when t18.v_pcre = 8 then '06'
                when t18.v_pcre = 9 then '06' when t18.v_pcre = 10 then '06' else '0' end,--tipo de crdito cofide
              ld_fecha_rcc,--aqpb763fcsbs,--fecha clasificacion sbs
              t16.v_calif0, --califiacion sbs normal
              t16.v_calif1, --califiacion sbs cpp
              t16.v_calif2, --califiacion sbs deficiente
              t16.v_calif3, --califiacion sbs dudoso
              t16.v_calif4, --califiacion sbs perdida
              t3.aqpc351bnven,--aqpc351vent,
              case when t25.v_flag = 'SI' then '2'else (case when t22.aqpb434fecr is null then '0' else '1' end) end, --codigo honra,--aqpc351codhon,
              t15.v_diatr, --dias de atraso
              t3.aqpc351bmoncof,
              t3.aqpc351bplacof,
              t3.aqpc351bpercof,
              t28.cenom,--estado del credito
              case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                                     (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )
                                     else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end )end , --fecha de cuando se realizo cambio de estado
              t1.aofe99,
              t4.v_saldo_canc,--aqpc351capcanc ,
              t8.regnom, --region
              t9.tp1desc, --zona
              t6.scnom, --agencia
              t27.v_ase, --analista
              case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)
              t22.aqpb434fecr, --fecha de honramiento
              t22.aqpb434mto, --monto honrado
              t24.v_saldo_honrado,-- SALDO HONRADO
              t4.v_saldo_actual +t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado
              t30.v_tmor,--aqpb763team, --tasa moratoria
              t1.aotasa,--aqpb763tea,  --tea
              pd_fecpro, --fecha proceso,
              to_char(sysdate, 'DD/MM/YYYY'),
                    to_char(sysdate, 'HH24:MI:SS')
                    
                    from aqpc351b t3                     
                    inner join fsd010 t1 on t3.aqpc351bcod = t1.pgcod and t3.aqpc351bcta = t1.aocta and t3.aqpc351bope = t1.aooper
                  --  left join fsd011 t26 on t26.pgcod = t1.pgcod  and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3,t1.aostat)) t5 on 1=1
                    left join fst001 t6 on t6.pgcod = t1.pgcod and t6.sucurs = t1.aosuc 
                    left join fst811 t7 on t7.pgcod = t1.pgcod and t7.oficod = t1.aosuc and t7.regcod < 100 and t7.regcod <> 0
                    left join fst810 t8 on t8.pgcod = t7.pgcod and t8.regcod = t7.regcod
                    left join fst198 t9 on t9.tp1cod = 1 and t9.tp1cod1 = 10872 and t9.tp1corr1 = 11 and t9.tp1nro2 = t7.regcod
                    left join fsd002 t10 on t10.pfpais = t2.pepais and t10.pftdoc = t2.petdoc and t10.pfndoc = t2.pendoc
                    left join fsd003 t11 on t11.pjpais = t2.pepais and t11.pjtdoc = t2.petdoc and t11.pjndoc = t2.pendoc
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_fechas_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t12 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fpagu)) t13 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_fvcuo_impaga(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t14 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1        
                    left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_acti_eco(t2.pepais,t2.petdoc,t2.pendoc)) t17 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tipo_credito_sbs_vig(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t18 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_mprepago(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1 
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_calf_caja(t1.aocta,pd_fecpro)) t21 on 1=1                      
                    left join aqpb434 t22 on t22.aqpb434cod = t1.pgcod and t22.aqpb434cta = t1.aocta and t22.aqpb434ope = t1.aooper and t22.aqpb434est = 'C' 
                  --  left join fst750 t23 on t23.actcod1 = t17.v_ciuu6 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_honrado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,9300082070000,pd_fecpro)) t24 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_repro_dato1(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t25 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_analista_credito(t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t27 on 1=1
                    left join fst026 t28 on t28.cecod = t1.aostat
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tea_repro(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t31 on 1=1
                    where t1.aomod in (200,33)                    
                    and t1.aostat <>99
                    and t3.aqpc351best <> 'D'
                    and t1.aofval <= pd_fecpro;     
        
                    commit;
        --- modulo 200 y 33 cancelados
        insert into aqpc351(aqpc351usur,
                          aqpc351cta,
                          aqpc351oper,
                          aqpc351emp,
                          aqpc351mod,
                          aqpc351suc ,
                          aqpc351mda,
                          aqpc351pap,
                          aqpc351sbop,
                          aqpc351tope,
                          aqpc351fsub,
                          aqpc351nsub,
                          aqpc351ncer,
                          aqpc351cocob,
                          aqpc351nact ,
                          aqpc351frepo,
                          aqpc351tdocsbs,
                          aqpc351tdocco,
                          aqpc351ndocco,
                          aqpc351tdoc,
                          aqpc351ndoc,
                          aqpc351csbs,
                          aqpc351rzsc,
                          aqpc351ciiu,
                          aqpc351npre ,
                          aqpc351mone ,
                          aqpc351mto,
                          aqpc351prccob,
                          aqpc351mtocob ,
                          aqpc351sdo ,
                          aqpc351sdoin ,
                          aqpc351tear,
                          aqpc351plaz,
                          aqpc351pgra,
                          aqpc351finico,
                          aqpc351fini,
                          aqpc351ffin,
                          aqpc351tcre,
                          aqpc351fcsbs,
                          aqpc351snor,
                          aqpc351scpp,
                          aqpc351sdef,
                          aqpc351sdud,
                          aqpc351sper,
                          aqpc351vent,
                          aqpc351codhon,
                          aqpc351datr,
                          aqpc351moncof,
                          aqpc351placof,
                          aqpc351percof,
                          aqpc351estc,
                          aqpc351fcest,
                          aqpc351fcanc ,
                          aqpc351capcanc ,
                          aqpc351rgon,
                          aqpc351zona ,
                          aqpc351agen,
                          aqpc351anl,
                          aqpc351chon ,
                          aqpc351fhon,
                          aqpc351mhon,
                          aqpc351sdohon ,
                          aqpc351crehon ,
                          aqpc351tmor,
                          aqpc351tinto,
                          aqpc351fproc ,
                          aqpc351fcr ,
                          aqpc351hcr)
             select rpad(trim(pn_usuario), 10, ' '), --usuario
              t1.aocta,
              t1.aooper,
              t1.pgcod,
              t1.aomod,
              t1.aosuc,
              t1.aomda,
              t1.aopap,
              t1.aosbop,
              t1.aotope,
              t3.aqpc351bfsub,
              trim(t3.aqpc351bnsub),
              t3.aqpc351bncer,
              t3.aqpc351bcocob,
              t3.aqpc351bnact ,
              t3.aqpc351bfrepo,
              case when trim(t3.aqpc351btdoc) = 'DNI' then 1 else 6 end,--aqpc351tdocsbs,
              t3.aqpc351btdoc,
              TRIM(t3.aqpc351bndoc),
              case when t2.petdoc = 21 then 'DNI' else 'RUC' end,
              trim(t2.pendoc),
              trim(t16.v_csbs), --cod sbs
              nvl(trim(substr(t11.pjrazs,0,60)),substr(concat(trim(t10.pfape1), concat(' ', concat(trim(t10.pfape2), concat(' ',concat(trim(t10.pfnom1), concat(' ', t10.pfnom2)))))),1,60)), --razon social
              case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu
              concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 2, '0'),lpad(to_char(t1.aooper), 9, '0'))), --numero prestamo
              'PEN',
              t1.aoimp,
              t3.aqpc351bprccob,
              round(t5.v_saldo_inso * t3.aqpc351bprccob,2) / 100,
              t1.aoimp, -- monto desembolsado
              t5.v_saldo_inso, --saldo insoluto
              t31.v_tear,--aqpc351tear, 
              round((t25.v_fult-t3.aqpc351bfinire)/30),
              t25.v_peri,
              t3.aqpc351bfinire,
              t25.v_fech,
              t25.v_fult,
              case when t18.v_pcre = 2 then '10' when t18.v_pcre = 11 then '07'
                when t18.v_pcre = 12 then '08' when t18.v_pcre = 13 then '09'
                when t18.v_pcre = 5 then '06' when t18.v_pcre = 6 then '06'
                when t18.v_pcre = 7 then '06' when t18.v_pcre = 8 then '06'
                when t18.v_pcre = 9 then '06' when t18.v_pcre = 10 then '06' else '0' end,--tipo de crdito cofide
              ld_fecha_rcc,--aqpb763fcsbs,--fecha clasificacion sbs
              t16.v_calif0, --califiacion sbs normal
              t16.v_calif1, --califiacion sbs cpp
              t16.v_calif2, --califiacion sbs deficiente
              t16.v_calif3, --califiacion sbs dudoso
              t16.v_calif4, --califiacion sbs perdida
              t3.aqpc351bnven,--aqpc351vent,
              case when t25.v_flag = 'SI' then '2'else (case when t22.aqpb434fecr is null then '0' else '1' end) end, --codigo honra,--aqpc351codhon,
              t15.v_diatr, --dias de atraso
              t3.aqpc351bmoncof,
              t3.aqpc351bplacof,
              t3.aqpc351bpercof,
              t28.cenom,--estado del credito
              case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                                     (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )
                                     else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end )end , --fecha de cuando se realizo cambio de estado
              t1.aofe99,
              t4.v_saldo_canc,--aqpc351capcanc ,
              t8.regnom, --region
              t9.tp1desc, --zona
              t6.scnom, --agencia
              t27.v_ase, --analista
              case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)
              t22.aqpb434fecr, --fecha de honramiento
              t22.aqpb434mto, --monto honrado
              t24.v_saldo_honrado,-- SALDO HONRADO
              t4.v_saldo_actual +t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado
              t30.v_tmor,--aqpb763team, --tasa moratoria
              t1.aotasa,--aqpb763tea,  --tea
              pd_fecpro, --fecha proceso,
              to_char(sysdate, 'DD/MM/YYYY'),
                    to_char(sysdate, 'HH24:MI:SS')
                    
                    from aqpc351b t3                     
                    inner join fsd010 t1 on t3.aqpc351bcod = t1.pgcod and t3.aqpc351bcta = t1.aocta and t3.aqpc351bope = t1.aooper
                  --  left join fsd011 t26 on t26.pgcod = t1.pgcod  and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3,t1.aostat)) t5 on 1=1
                    left join fst001 t6 on t6.pgcod = t1.pgcod and t6.sucurs = t1.aosuc 
                    left join fst811 t7 on t7.pgcod = t1.pgcod and t7.oficod = t1.aosuc and t7.regcod < 100 and t7.regcod <> 0
                    left join fst810 t8 on t8.pgcod = t7.pgcod and t8.regcod = t7.regcod
                    left join fst198 t9 on t9.tp1cod = 1 and t9.tp1cod1 = 10872 and t9.tp1corr1 = 11 and t9.tp1nro2 = t7.regcod
                    left join fsd002 t10 on t10.pfpais = t2.pepais and t10.pftdoc = t2.petdoc and t10.pfndoc = t2.pendoc
                    left join fsd003 t11 on t11.pjpais = t2.pepais and t11.pjtdoc = t2.petdoc and t11.pjndoc = t2.pendoc
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_fechas_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t12 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fpagu)) t13 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_fvcuo_impaga(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t14 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1        
                    left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_acti_eco(t2.pepais,t2.petdoc,t2.pendoc)) t17 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tipo_credito_sbs_vig(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t18 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_mprepago(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1 
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_calf_caja(t1.aocta,pd_fecpro)) t21 on 1=1                      
                    left join aqpb434 t22 on t22.aqpb434cod = t1.pgcod and t22.aqpb434cta = t1.aocta and t22.aqpb434ope = t1.aooper and t22.aqpb434est = 'C' 
                  --  left join fst750 t23 on t23.actcod1 = t17.v_ciuu6 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_honrado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,9300082070000,pd_fecpro)) t24 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_repro_dato1(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t25 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_analista_credito(t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t27 on 1=1
                    left join fst026 t28 on t28.cecod = t1.aostat
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tea_repro(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t31 on 1=1
                    where t1.aomod in (200,33)                   
                    and t3.aqpc351best <> 'D'
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
                    
                     and t1.aofe99 =
                     (select max(h.aofe99)
                        from fsd010 h
                       where h.pgcod = t1.pgcod
                         and h.aomod = t1.aomod                            
                         and h.aomda = t1.aomda
                         and h.aopap = t1.aopap
                         and h.aocta = t1.aocta
                         and h.aooper = t1.aooper
                            --and r.scsbop = t.aosbop
                            --and h.aotope = t.aotope
                         and h.aofe99 <= pd_fecpro
                            --and h.aomod <> 419
                         and h.aomod in (select modulo
                                           from fst111
                                          where dscod = 50
                                            and modulo not in (29, 120, 144)))
                    and t1.aofval <= pd_fecpro   ; 
        commit;
    exception when others then null;  
    end;
    pq_cr_reporte_reactivarepro.sp_guardar_historico(pn_usuario, pd_fecpro);
  end sp_cr_sch_reactivarepro_sinjob;
  ------------------------------------------------------------------
  procedure sp_cr_sch_reactivarepro2(pd_fecpro in date, pn_suc in number, pn_usuario in varchar2) is
  ld_fecha_rcc date;
  ln_nro_mes number;  
  ld_fecha date;                         
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
  
    -- Fecha actual
    select t.pgfape into ld_fecha from fst017 t where t.pgcod = 1;
    begin
      --vigentes
      insert into aqpc351(aqpc351usur,
                          aqpc351cta,
                          aqpc351oper,
                          aqpc351emp,
                          aqpc351mod,
                          aqpc351suc ,
                          aqpc351mda,
                          aqpc351pap,
                          aqpc351sbop,
                          aqpc351tope,
                          aqpc351fsub,
                          aqpc351nsub,
                          aqpc351ncer,
                          aqpc351cocob,
                          aqpc351nact ,
                          aqpc351frepo,
                          aqpc351tdocsbs,
                          aqpc351tdocco,
                          aqpc351ndocco,
                          aqpc351tdoc,
                          aqpc351ndoc,
                          aqpc351csbs,
                          aqpc351rzsc,
                          aqpc351ciiu,
                          aqpc351npre ,
                          aqpc351mone ,
                          aqpc351mto,
                          aqpc351prccob,
                          aqpc351mtocob ,
                          aqpc351sdo ,
                          aqpc351sdoin ,
                          aqpc351tear,
                          aqpc351plaz,
                          aqpc351pgra,
                          aqpc351finico,
                          aqpc351fini,
                          aqpc351ffin,
                          aqpc351tcre,
                          aqpc351fcsbs,
                          aqpc351snor,
                          aqpc351scpp,
                          aqpc351sdef,
                          aqpc351sdud,
                          aqpc351sper,
                          aqpc351vent,
                          aqpc351codhon,
                          aqpc351datr,
                          aqpc351moncof,
                          aqpc351placof,
                          aqpc351percof,
                          aqpc351estc,
                          aqpc351fcest,
                          aqpc351fcanc ,
                          aqpc351capcanc ,
                          aqpc351rgon,
                          aqpc351zona ,
                          aqpc351agen,
                          aqpc351anl,
                          aqpc351chon ,
                          aqpc351fhon,
                          aqpc351mhon,
                          aqpc351sdohon ,
                          aqpc351crehon ,
                          aqpc351tmor,
                          aqpc351tinto,
                          aqpc351fproc ,
                          aqpc351fcr ,
                          aqpc351hcr)
             select rpad(trim(pn_usuario), 10, ' '), --usuario
              t1.aocta,
              t1.aooper,
              t1.pgcod,
              t1.aomod,
              t1.aosuc,
              t1.aomda,
              t1.aopap,
              t1.aosbop,
              t1.aotope,
              t3.aqpc351bfsub,
              trim(t3.aqpc351bnsub),
              t3.aqpc351bncer,
              t3.aqpc351bcocob,
              t3.aqpc351bnact ,
              t3.aqpc351bfrepo,
              case when trim(t3.aqpc351btdoc) = 'DNI' then 1 else 6 end,--aqpc351tdocsbs,
              t3.aqpc351btdoc,
              TRIM(t3.aqpc351bndoc),
              case when t2.petdoc = 21 then 'DNI' else 'RUC' end,
              trim(t2.pendoc),
              trim(t16.v_csbs), --cod sbs
              nvl(trim(substr(t11.pjrazs,0,60)),substr(concat(trim(t10.pfape1), concat(' ', concat(trim(t10.pfape2), concat(' ',concat(trim(t10.pfnom1), concat(' ', t10.pfnom2)))))),1,60)), --razon social
              case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu
              concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 2, '0'),lpad(to_char(t1.aooper), 9, '0'))), --numero prestamo
              'PEN',
              t1.aoimp,
              t3.aqpc351bprccob,
              round(t5.v_saldo_inso * t3.aqpc351bprccob,2) / 100,
              t1.aoimp, -- monto desembolsado
              t5.v_saldo_inso, --saldo insoluto
              t31.v_tear,--aqpc351tear, 
              round((t25.v_fult-t3.aqpc351bfinire)/30),
              t25.v_peri,
              t3.aqpc351bfinire,
              t25.v_fech,
              t25.v_fult,
              case when t18.v_pcre = 2 then '10' when t18.v_pcre = 11 then '07'
                when t18.v_pcre = 12 then '08' when t18.v_pcre = 13 then '09'
                when t18.v_pcre = 5 then '06' when t18.v_pcre = 6 then '06'
                when t18.v_pcre = 7 then '06' when t18.v_pcre = 8 then '06'
                when t18.v_pcre = 9 then '06' when t18.v_pcre = 10 then '06' else '0' end,--tipo de crdito cofide
              ld_fecha_rcc,--aqpb763fcsbs,--fecha clasificacion sbs
              t16.v_calif0, --califiacion sbs normal
              t16.v_calif1, --califiacion sbs cpp
              t16.v_calif2, --califiacion sbs deficiente
              t16.v_calif3, --califiacion sbs dudoso
              t16.v_calif4, --califiacion sbs perdida
              t3.aqpc351bnven,--aqpc351vent,
              case when t25.v_flag = 'SI' then '2'else (case when t22.aqpb434fecr is null then '0' else '1' end) end, --codigo honra,--aqpc351codhon,
              t15.v_diatr, --dias de atraso
              t3.aqpc351bmoncof,
              t3.aqpc351bplacof,
              t3.aqpc351bpercof,
              t28.cenom,--estado del credito
              case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                                     (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )
                                     else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end )end , --fecha de cuando se realizo cambio de estado
              t1.aofe99,
              t4.v_saldo_canc,--aqpc351capcanc ,
              t8.regnom, --region
              t9.tp1desc, --zona
              t6.scnom, --agencia
              t27.v_ase, --analista
              case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)
              t22.aqpb434fecr, --fecha de honramiento
              t22.aqpb434mto, --monto honrado
              t24.v_saldo_honrado,-- SALDO HONRADO
              t4.v_saldo_actual +t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado
              t30.v_tmor,--aqpb763team, --tasa moratoria
              t1.aotasa,--aqpb763tea,  --tea
              pd_fecpro, --fecha proceso,
              to_char(sysdate, 'DD/MM/YYYY'),
                    to_char(sysdate, 'HH24:MI:SS')
                    
                    from aqpc351b t3                     
                    inner join fsd010 t1 on t3.aqpc351bcod = t1.pgcod and t3.aqpc351bcta = t1.aocta and t3.aqpc351bope = t1.aooper
                  --  left join fsd011 t26 on t26.pgcod = t1.pgcod  and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3,t1.aostat)) t5 on 1=1
                    left join fst001 t6 on t6.pgcod = t1.pgcod and t6.sucurs = t1.aosuc 
                    left join fst811 t7 on t7.pgcod = t1.pgcod and t7.oficod = t1.aosuc and t7.regcod < 100 and t7.regcod <> 0
                    left join fst810 t8 on t8.pgcod = t7.pgcod and t8.regcod = t7.regcod
                    left join fst198 t9 on t9.tp1cod = 1 and t9.tp1cod1 = 10872 and t9.tp1corr1 = 11 and t9.tp1nro2 = t7.regcod
                    left join fsd002 t10 on t10.pfpais = t2.pepais and t10.pftdoc = t2.petdoc and t10.pfndoc = t2.pendoc
                    left join fsd003 t11 on t11.pjpais = t2.pepais and t11.pjtdoc = t2.petdoc and t11.pjndoc = t2.pendoc
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_fechas_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t12 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fpagu)) t13 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_fvcuo_impaga(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t14 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1        
                    left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_acti_eco(t2.pepais,t2.petdoc,t2.pendoc)) t17 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tipo_credito_sbs_vig(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t18 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_mprepago(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1 
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_calf_caja(t1.aocta,pd_fecpro)) t21 on 1=1                      
                    left join aqpb434 t22 on t22.aqpb434cod = t1.pgcod and t22.aqpb434cta = t1.aocta and t22.aqpb434ope = t1.aooper and t22.aqpb434est = 'C' 
                  --  left join fst750 t23 on t23.actcod1 = t17.v_ciuu6 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_honrado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,9300082070000,pd_fecpro)) t24 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_repro_dato1(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t25 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_analista_credito(t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t27 on 1=1
                    left join fst026 t28 on t28.cecod = t1.aostat
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tea_repro(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t31 on 1=1
                    where t1.aomod =101
                    and t1.aomod in (select modulo
                     from fst111
                    where dscod = 50
                      and modulo not in (29, 120, 144))
                    and t1.aostat <>99
                    and t3.aqpc351best <> 'D'
                    and t1.aofval <= pd_fecpro  
                    and t1.aosuc = pn_suc ;     
                    commit;
                                    
        --cancelados 
        insert into aqpc351(aqpc351usur,
                          aqpc351cta,
                          aqpc351oper,
                          aqpc351emp,
                          aqpc351mod,
                          aqpc351suc ,
                          aqpc351mda,
                          aqpc351pap,
                          aqpc351sbop,
                          aqpc351tope,
                          aqpc351fsub,
                          aqpc351nsub,
                          aqpc351ncer,
                          aqpc351cocob,
                          aqpc351nact ,
                          aqpc351frepo,
                          aqpc351tdocsbs,
                          aqpc351tdocco,
                          aqpc351ndocco,
                          aqpc351tdoc,
                          aqpc351ndoc,
                          aqpc351csbs,
                          aqpc351rzsc,
                          aqpc351ciiu,
                          aqpc351npre ,
                          aqpc351mone ,
                          aqpc351mto,
                          aqpc351prccob,
                          aqpc351mtocob ,
                          aqpc351sdo ,
                          aqpc351sdoin ,
                          aqpc351tear,
                          aqpc351plaz,
                          aqpc351pgra,
                          aqpc351finico,
                          aqpc351fini,
                          aqpc351ffin,
                          aqpc351tcre,
                          aqpc351fcsbs,
                          aqpc351snor,
                          aqpc351scpp,
                          aqpc351sdef,
                          aqpc351sdud,
                          aqpc351sper,
                          aqpc351vent,
                          aqpc351codhon,
                          aqpc351datr,
                          aqpc351moncof,
                          aqpc351placof,
                          aqpc351percof,
                          aqpc351estc,
                          aqpc351fcest,
                          aqpc351fcanc ,
                          aqpc351capcanc ,
                          aqpc351rgon,
                          aqpc351zona ,
                          aqpc351agen,
                          aqpc351anl,
                          aqpc351chon ,
                          aqpc351fhon,
                          aqpc351mhon,
                          aqpc351sdohon ,
                          aqpc351crehon ,
                          aqpc351tmor,
                          aqpc351tinto,
                          aqpc351fproc ,
                          aqpc351fcr ,
                          aqpc351hcr)
             select rpad(trim(pn_usuario), 10, ' '), --usuario
              t1.aocta,
              t1.aooper,
              t1.pgcod,
              t1.aomod,
              t1.aosuc,
              t1.aomda,
              t1.aopap,
              t1.aosbop,
              t1.aotope,
              t3.aqpc351bfsub,
              trim(t3.aqpc351bnsub),
              t3.aqpc351bncer,
              t3.aqpc351bcocob,
              t3.aqpc351bnact ,
              t3.aqpc351bfrepo,
              case when trim(t3.aqpc351btdoc) = 'DNI' then 1 else 6 end,--aqpc351tdocsbs,
              t3.aqpc351btdoc,
              TRIM(t3.aqpc351bndoc),
              case when t2.petdoc = 21 then 'DNI' else 'RUC' end,
              trim(t2.pendoc),
              trim(t16.v_csbs), --cod sbs
              nvl(trim(substr(t11.pjrazs,0,60)),substr(concat(trim(t10.pfape1), concat(' ', concat(trim(t10.pfape2), concat(' ',concat(trim(t10.pfnom1), concat(' ', t10.pfnom2)))))),1,60)), --razon social
              case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu
              concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 2, '0'),lpad(to_char(t1.aooper), 9, '0'))), --numero prestamo
              'PEN',
              t1.aoimp,
              t3.aqpc351bprccob,
              round(t5.v_saldo_inso * t3.aqpc351bprccob,2) / 100,
              t1.aoimp, -- monto desembolsado
              t5.v_saldo_inso, --saldo insoluto
              t31.v_tear,--aqpc351tear, 
              round((t25.v_fult-t3.aqpc351bfinire)/30),
              t25.v_peri,
              t3.aqpc351bfinire,
              t25.v_fech,
              t25.v_fult,
              case when t18.v_pcre = 2 then '10' when t18.v_pcre = 11 then '07'
                when t18.v_pcre = 12 then '08' when t18.v_pcre = 13 then '09'
                when t18.v_pcre = 5 then '06' when t18.v_pcre = 6 then '06'
                when t18.v_pcre = 7 then '06' when t18.v_pcre = 8 then '06'
                when t18.v_pcre = 9 then '06' when t18.v_pcre = 10 then '06' else '0' end,--tipo de crdito cofide
              ld_fecha_rcc,--aqpb763fcsbs,--fecha clasificacion sbs
              t16.v_calif0, --califiacion sbs normal
              t16.v_calif1, --califiacion sbs cpp
              t16.v_calif2, --califiacion sbs deficiente
              t16.v_calif3, --califiacion sbs dudoso
              t16.v_calif4, --califiacion sbs perdida
              t3.aqpc351bnven,--aqpc351vent,
              case when t25.v_flag = 'SI' then '2'else (case when t22.aqpb434fecr is null then '0' else '1' end) end, --codigo honra,--aqpc351codhon,
              t15.v_diatr, --dias de atraso
              t3.aqpc351bmoncof,
              t3.aqpc351bplacof,
              t3.aqpc351bpercof,
              t28.cenom,--estado del credito
              case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                                     (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )
                                     else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end )end , --fecha de cuando se realizo cambio de estado
              t1.aofe99,
              t4.v_saldo_canc,--aqpc351capcanc ,
              t8.regnom, --region
              t9.tp1desc, --zona
              t6.scnom, --agencia
              t27.v_ase, --analista
              case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)
              t22.aqpb434fecr, --fecha de honramiento
              t22.aqpb434mto, --monto honrado
              t24.v_saldo_honrado,-- SALDO HONRADO
              t4.v_saldo_actual +t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado
              t30.v_tmor,--aqpb763team, --tasa moratoria
              t1.aotasa,--aqpb763tea,  --tea
              pd_fecpro, --fecha proceso,
              to_char(sysdate, 'DD/MM/YYYY'),
                    to_char(sysdate, 'HH24:MI:SS')
                    
                    from aqpc351b t3                     
                    inner join fsd010 t1 on t3.aqpc351bcod = t1.pgcod and t3.aqpc351bcta = t1.aocta and t3.aqpc351bope = t1.aooper
                  --  left join fsd011 t26 on t26.pgcod = t1.pgcod  and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3,t1.aostat)) t5 on 1=1
                    left join fst001 t6 on t6.pgcod = t1.pgcod and t6.sucurs = t1.aosuc 
                    left join fst811 t7 on t7.pgcod = t1.pgcod and t7.oficod = t1.aosuc and t7.regcod < 100 and t7.regcod <> 0
                    left join fst810 t8 on t8.pgcod = t7.pgcod and t8.regcod = t7.regcod
                    left join fst198 t9 on t9.tp1cod = 1 and t9.tp1cod1 = 10872 and t9.tp1corr1 = 11 and t9.tp1nro2 = t7.regcod
                    left join fsd002 t10 on t10.pfpais = t2.pepais and t10.pftdoc = t2.petdoc and t10.pfndoc = t2.pendoc
                    left join fsd003 t11 on t11.pjpais = t2.pepais and t11.pjtdoc = t2.petdoc and t11.pjndoc = t2.pendoc
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_fechas_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t12 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fpagu)) t13 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_fvcuo_impaga(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t14 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1        
                    left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_acti_eco(t2.pepais,t2.petdoc,t2.pendoc)) t17 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tipo_credito_sbs_vig(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t18 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_mprepago(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1 
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_calf_caja(t1.aocta,pd_fecpro)) t21 on 1=1                      
                    left join aqpb434 t22 on t22.aqpb434cod = t1.pgcod and t22.aqpb434cta = t1.aocta and t22.aqpb434ope = t1.aooper and t22.aqpb434est = 'C' 
                  --  left join fst750 t23 on t23.actcod1 = t17.v_ciuu6 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_honrado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,9300082070000,pd_fecpro)) t24 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_repro_dato1(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t25 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_analista_credito(t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t27 on 1=1
                    left join fst026 t28 on t28.cecod = t1.aostat
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tea_repro(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t31 on 1=1
                    where t1.aomod =101
                    and t1.aomod in (select modulo
                     from fst111
                    where dscod = 50
                      and modulo not in (29, 120, 144))                    
                    and t3.aqpc351best <> 'D'
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
                    
                     and t1.aofe99 =
                     (select max(h.aofe99)
                        from fsd010 h
                       where h.pgcod = t1.pgcod
                         and h.aomod = t1.aomod                            
                         and h.aomda = t1.aomda
                         and h.aopap = t1.aopap
                         and h.aocta = t1.aocta
                         and h.aooper = t1.aooper
                            --and r.scsbop = t.aosbop
                            --and h.aotope = t.aotope
                         and h.aofe99 <= pd_fecpro
                            --and h.aomod <> 419
                         and h.aomod in (select modulo
                                           from fst111
                                          where dscod = 50
                                            and modulo not in (29, 120, 144)))
                    and t1.aofval <= pd_fecpro   
                    and t1.aosuc = pn_suc; 
        commit;
        --- modulo 200 y 33
        --vigentes
      insert into aqpc351(aqpc351usur,
                          aqpc351cta,
                          aqpc351oper,
                          aqpc351emp,
                          aqpc351mod,
                          aqpc351suc ,
                          aqpc351mda,
                          aqpc351pap,
                          aqpc351sbop,
                          aqpc351tope,
                          aqpc351fsub,
                          aqpc351nsub,
                          aqpc351ncer,
                          aqpc351cocob,
                          aqpc351nact ,
                          aqpc351frepo,
                          aqpc351tdocsbs,
                          aqpc351tdocco,
                          aqpc351ndocco,
                          aqpc351tdoc,
                          aqpc351ndoc,
                          aqpc351csbs,
                          aqpc351rzsc,
                          aqpc351ciiu,
                          aqpc351npre ,
                          aqpc351mone ,
                          aqpc351mto,
                          aqpc351prccob,
                          aqpc351mtocob ,
                          aqpc351sdo ,
                          aqpc351sdoin ,
                          aqpc351tear,
                          aqpc351plaz,
                          aqpc351pgra,
                          aqpc351finico,
                          aqpc351fini,
                          aqpc351ffin,
                          aqpc351tcre,
                          aqpc351fcsbs,
                          aqpc351snor,
                          aqpc351scpp,
                          aqpc351sdef,
                          aqpc351sdud,
                          aqpc351sper,
                          aqpc351vent,
                          aqpc351codhon,
                          aqpc351datr,
                          aqpc351moncof,
                          aqpc351placof,
                          aqpc351percof,
                          aqpc351estc,
                          aqpc351fcest,
                          aqpc351fcanc ,
                          aqpc351capcanc ,
                          aqpc351rgon,
                          aqpc351zona ,
                          aqpc351agen,
                          aqpc351anl,
                          aqpc351chon ,
                          aqpc351fhon,
                          aqpc351mhon,
                          aqpc351sdohon ,
                          aqpc351crehon ,
                          aqpc351tmor,
                          aqpc351tinto,
                          aqpc351fproc ,
                          aqpc351fcr ,
                          aqpc351hcr)
             select rpad(trim(pn_usuario), 10, ' '), --usuario
              t1.aocta,
              t1.aooper,
              t1.pgcod,
              t1.aomod,
              t1.aosuc,
              t1.aomda,
              t1.aopap,
              t1.aosbop,
              t1.aotope,
              t3.aqpc351bfsub,
              trim(t3.aqpc351bnsub),
              t3.aqpc351bncer,
              t3.aqpc351bcocob,
              t3.aqpc351bnact ,
              t3.aqpc351bfrepo,
              case when trim(t3.aqpc351btdoc) = 'DNI' then 1 else 6 end,--aqpc351tdocsbs,
              t3.aqpc351btdoc,
              TRIM(t3.aqpc351bndoc),
              case when t2.petdoc = 21 then 'DNI' else 'RUC' end,
              trim(t2.pendoc),
              trim(t16.v_csbs), --cod sbs
              nvl(trim(substr(t11.pjrazs,0,60)),substr(concat(trim(t10.pfape1), concat(' ', concat(trim(t10.pfape2), concat(' ',concat(trim(t10.pfnom1), concat(' ', t10.pfnom2)))))),1,60)), --razon social
              case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu
              concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 2, '0'),lpad(to_char(t1.aooper), 9, '0'))), --numero prestamo
              'PEN',
              t1.aoimp,
              t3.aqpc351bprccob,
              round(t5.v_saldo_inso * t3.aqpc351bprccob,2) / 100,
              t1.aoimp, -- monto desembolsado
              t5.v_saldo_inso, --saldo insoluto
              t31.v_tear,--aqpc351tear, 
              round((t25.v_fult-t3.aqpc351bfinire)/30),
              t25.v_peri,
              t3.aqpc351bfinire,
              t25.v_fech,
              t25.v_fult,
              case when t18.v_pcre = 2 then '10' when t18.v_pcre = 11 then '07'
                when t18.v_pcre = 12 then '08' when t18.v_pcre = 13 then '09'
                when t18.v_pcre = 5 then '06' when t18.v_pcre = 6 then '06'
                when t18.v_pcre = 7 then '06' when t18.v_pcre = 8 then '06'
                when t18.v_pcre = 9 then '06' when t18.v_pcre = 10 then '06' else '0' end,--tipo de crdito cofide
              ld_fecha_rcc,--aqpb763fcsbs,--fecha clasificacion sbs
              t16.v_calif0, --califiacion sbs normal
              t16.v_calif1, --califiacion sbs cpp
              t16.v_calif2, --califiacion sbs deficiente
              t16.v_calif3, --califiacion sbs dudoso
              t16.v_calif4, --califiacion sbs perdida
              t3.aqpc351bnven,--aqpc351vent,
              case when t25.v_flag = 'SI' then '2'else (case when t22.aqpb434fecr is null then '0' else '1' end) end, --codigo honra,--aqpc351codhon,
              t15.v_diatr, --dias de atraso
              t3.aqpc351bmoncof,
              t3.aqpc351bplacof,
              t3.aqpc351bpercof,
              t28.cenom,--estado del credito
              case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                                     (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )
                                     else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end )end , --fecha de cuando se realizo cambio de estado
              t1.aofe99,
              t4.v_saldo_canc,--aqpc351capcanc ,
              t8.regnom, --region
              t9.tp1desc, --zona
              t6.scnom, --agencia
              t27.v_ase, --analista
              case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)
              t22.aqpb434fecr, --fecha de honramiento
              t22.aqpb434mto, --monto honrado
              t24.v_saldo_honrado,-- SALDO HONRADO
              t4.v_saldo_actual +t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado
              t30.v_tmor,--aqpb763team, --tasa moratoria
              t1.aotasa,--aqpb763tea,  --tea
              pd_fecpro, --fecha proceso,
              to_char(sysdate, 'DD/MM/YYYY'),
                    to_char(sysdate, 'HH24:MI:SS')
                    
                    from aqpc351b t3                     
                    inner join fsd010 t1 on t3.aqpc351bcod = t1.pgcod and t3.aqpc351bcta = t1.aocta and t3.aqpc351bope = t1.aooper
                  --  left join fsd011 t26 on t26.pgcod = t1.pgcod  and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3,t1.aostat)) t5 on 1=1
                    left join fst001 t6 on t6.pgcod = t1.pgcod and t6.sucurs = t1.aosuc 
                    left join fst811 t7 on t7.pgcod = t1.pgcod and t7.oficod = t1.aosuc and t7.regcod < 100 and t7.regcod <> 0
                    left join fst810 t8 on t8.pgcod = t7.pgcod and t8.regcod = t7.regcod
                    left join fst198 t9 on t9.tp1cod = 1 and t9.tp1cod1 = 10872 and t9.tp1corr1 = 11 and t9.tp1nro2 = t7.regcod
                    left join fsd002 t10 on t10.pfpais = t2.pepais and t10.pftdoc = t2.petdoc and t10.pfndoc = t2.pendoc
                    left join fsd003 t11 on t11.pjpais = t2.pepais and t11.pjtdoc = t2.petdoc and t11.pjndoc = t2.pendoc
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_fechas_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t12 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fpagu)) t13 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_fvcuo_impaga(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t14 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1        
                    left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_acti_eco(t2.pepais,t2.petdoc,t2.pendoc)) t17 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tipo_credito_sbs_vig(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t18 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_mprepago(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1 
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_calf_caja(t1.aocta,pd_fecpro)) t21 on 1=1                      
                    left join aqpb434 t22 on t22.aqpb434cod = t1.pgcod and t22.aqpb434cta = t1.aocta and t22.aqpb434ope = t1.aooper and t22.aqpb434est = 'C' 
                  --  left join fst750 t23 on t23.actcod1 = t17.v_ciuu6 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_honrado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,9300082070000,pd_fecpro)) t24 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_repro_dato1(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t25 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_analista_credito(t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t27 on 1=1
                    left join fst026 t28 on t28.cecod = t1.aostat
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tea_repro(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t31 on 1=1
                    where t1.aomod in (200,33)                    
                    and t1.aostat <>99
                    and t3.aqpc351best <> 'D'
                    and t1.aofval <= pd_fecpro  
                    and t1.aosuc = pn_suc ;     
        
                    commit;
        --- modulo 200 y 33 cancelados
        insert into aqpc351(aqpc351usur,
                          aqpc351cta,
                          aqpc351oper,
                          aqpc351emp,
                          aqpc351mod,
                          aqpc351suc ,
                          aqpc351mda,
                          aqpc351pap,
                          aqpc351sbop,
                          aqpc351tope,
                          aqpc351fsub,
                          aqpc351nsub,
                          aqpc351ncer,
                          aqpc351cocob,
                          aqpc351nact ,
                          aqpc351frepo,
                          aqpc351tdocsbs,
                          aqpc351tdocco,
                          aqpc351ndocco,
                          aqpc351tdoc,
                          aqpc351ndoc,
                          aqpc351csbs,
                          aqpc351rzsc,
                          aqpc351ciiu,
                          aqpc351npre ,
                          aqpc351mone ,
                          aqpc351mto,
                          aqpc351prccob,
                          aqpc351mtocob ,
                          aqpc351sdo ,
                          aqpc351sdoin ,
                          aqpc351tear,
                          aqpc351plaz,
                          aqpc351pgra,
                          aqpc351finico,
                          aqpc351fini,
                          aqpc351ffin,
                          aqpc351tcre,
                          aqpc351fcsbs,
                          aqpc351snor,
                          aqpc351scpp,
                          aqpc351sdef,
                          aqpc351sdud,
                          aqpc351sper,
                          aqpc351vent,
                          aqpc351codhon,
                          aqpc351datr,
                          aqpc351moncof,
                          aqpc351placof,
                          aqpc351percof,
                          aqpc351estc,
                          aqpc351fcest,
                          aqpc351fcanc ,
                          aqpc351capcanc ,
                          aqpc351rgon,
                          aqpc351zona ,
                          aqpc351agen,
                          aqpc351anl,
                          aqpc351chon ,
                          aqpc351fhon,
                          aqpc351mhon,
                          aqpc351sdohon ,
                          aqpc351crehon ,
                          aqpc351tmor,
                          aqpc351tinto,
                          aqpc351fproc ,
                          aqpc351fcr ,
                          aqpc351hcr)
             select rpad(trim(pn_usuario), 10, ' '), --usuario
              t1.aocta,
              t1.aooper,
              t1.pgcod,
              t1.aomod,
              t1.aosuc,
              t1.aomda,
              t1.aopap,
              t1.aosbop,
              t1.aotope,
              t3.aqpc351bfsub,
              trim(t3.aqpc351bnsub),
              t3.aqpc351bncer,
              t3.aqpc351bcocob,
              t3.aqpc351bnact ,
              t3.aqpc351bfrepo,
              case when trim(t3.aqpc351btdoc) = 'DNI' then 1 else 6 end,--aqpc351tdocsbs,
              t3.aqpc351btdoc,
              TRIM(t3.aqpc351bndoc),
              case when t2.petdoc = 21 then 'DNI' else 'RUC' end,
              trim(t2.pendoc),
              trim(t16.v_csbs), --cod sbs
              nvl(trim(substr(t11.pjrazs,0,60)),substr(concat(trim(t10.pfape1), concat(' ', concat(trim(t10.pfape2), concat(' ',concat(trim(t10.pfnom1), concat(' ', t10.pfnom2)))))),1,60)), --razon social
              case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu
              concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 2, '0'),lpad(to_char(t1.aooper), 9, '0'))), --numero prestamo
              'PEN',
              t1.aoimp,
              t3.aqpc351bprccob,
              round(t5.v_saldo_inso * t3.aqpc351bprccob,2) / 100,
              t1.aoimp, -- monto desembolsado
              t5.v_saldo_inso, --saldo insoluto
              t31.v_tear,--aqpc351tear, 
              round((t25.v_fult-t3.aqpc351bfinire)/30),
              t25.v_peri,
              t3.aqpc351bfinire,
              t25.v_fech,
              t25.v_fult,
              case when t18.v_pcre = 2 then '10' when t18.v_pcre = 11 then '07'
                when t18.v_pcre = 12 then '08' when t18.v_pcre = 13 then '09'
                when t18.v_pcre = 5 then '06' when t18.v_pcre = 6 then '06'
                when t18.v_pcre = 7 then '06' when t18.v_pcre = 8 then '06'
                when t18.v_pcre = 9 then '06' when t18.v_pcre = 10 then '06' else '0' end,--tipo de crdito cofide
              ld_fecha_rcc,--aqpb763fcsbs,--fecha clasificacion sbs
              t16.v_calif0, --califiacion sbs normal
              t16.v_calif1, --califiacion sbs cpp
              t16.v_calif2, --califiacion sbs deficiente
              t16.v_calif3, --califiacion sbs dudoso
              t16.v_calif4, --califiacion sbs perdida
              t3.aqpc351bnven,--aqpc351vent,
              case when t25.v_flag = 'SI' then '2'else (case when t22.aqpb434fecr is null then '0' else '1' end) end, --codigo honra,--aqpc351codhon,
              t15.v_diatr, --dias de atraso
              t3.aqpc351bmoncof,
              t3.aqpc351bplacof,
              t3.aqpc351bpercof,
              t28.cenom,--estado del credito
              case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                                     (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )
                                     else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end )end , --fecha de cuando se realizo cambio de estado
              t1.aofe99,
              t4.v_saldo_canc,--aqpc351capcanc ,
              t8.regnom, --region
              t9.tp1desc, --zona
              t6.scnom, --agencia
              t27.v_ase, --analista
              case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)
              t22.aqpb434fecr, --fecha de honramiento
              t22.aqpb434mto, --monto honrado
              t24.v_saldo_honrado,-- SALDO HONRADO
              t4.v_saldo_actual +t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado
              t30.v_tmor,--aqpb763team, --tasa moratoria
              t1.aotasa,--aqpb763tea,  --tea
              pd_fecpro, --fecha proceso,
              to_char(sysdate, 'DD/MM/YYYY'),
                    to_char(sysdate, 'HH24:MI:SS')
                    
                    from aqpc351b t3                     
                    inner join fsd010 t1 on t3.aqpc351bcod = t1.pgcod and t3.aqpc351bcta = t1.aocta and t3.aqpc351bope = t1.aooper
                  --  left join fsd011 t26 on t26.pgcod = t1.pgcod  and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3,t1.aostat)) t5 on 1=1
                    left join fst001 t6 on t6.pgcod = t1.pgcod and t6.sucurs = t1.aosuc 
                    left join fst811 t7 on t7.pgcod = t1.pgcod and t7.oficod = t1.aosuc and t7.regcod < 100 and t7.regcod <> 0
                    left join fst810 t8 on t8.pgcod = t7.pgcod and t8.regcod = t7.regcod
                    left join fst198 t9 on t9.tp1cod = 1 and t9.tp1cod1 = 10872 and t9.tp1corr1 = 11 and t9.tp1nro2 = t7.regcod
                    left join fsd002 t10 on t10.pfpais = t2.pepais and t10.pftdoc = t2.petdoc and t10.pfndoc = t2.pendoc
                    left join fsd003 t11 on t11.pjpais = t2.pepais and t11.pjtdoc = t2.petdoc and t11.pjndoc = t2.pendoc
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_fechas_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t12 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fpagu)) t13 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_fvcuo_impaga(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t14 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1        
                    left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_acti_eco(t2.pepais,t2.petdoc,t2.pendoc)) t17 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tipo_credito_sbs_vig(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t18 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_mprepago(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1 
                  --  left join table(pq_cr_reporte_utilitarios.fn_get_calf_caja(t1.aocta,pd_fecpro)) t21 on 1=1                      
                    left join aqpb434 t22 on t22.aqpb434cod = t1.pgcod and t22.aqpb434cta = t1.aocta and t22.aqpb434ope = t1.aooper and t22.aqpb434est = 'C' 
                  --  left join fst750 t23 on t23.actcod1 = t17.v_ciuu6 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_honrado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,9300082070000,pd_fecpro)) t24 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_repro_dato1(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t25 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_analista_credito(t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t27 on 1=1
                    left join fst026 t28 on t28.cecod = t1.aostat
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tea_repro(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t31 on 1=1
                    where t1.aomod in (200,33)                   
                    and t3.aqpc351best <> 'D'
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
                    
                     and t1.aofe99 =
                     (select max(h.aofe99)
                        from fsd010 h
                       where h.pgcod = t1.pgcod
                         and h.aomod = t1.aomod                            
                         and h.aomda = t1.aomda
                         and h.aopap = t1.aopap
                         and h.aocta = t1.aocta
                         and h.aooper = t1.aooper
                            --and r.scsbop = t.aosbop
                            --and h.aotope = t.aotope
                         and h.aofe99 <= pd_fecpro
                            --and h.aomod <> 419
                         and h.aomod in (select modulo
                                           from fst111
                                          where dscod = 50
                                            and modulo not in (29, 120, 144)))
                    and t1.aofval <= pd_fecpro   
                    and t1.aosuc = pn_suc; 
        commit;
       exception when others then null;  
       end;
     
  end sp_cr_sch_reactivarepro2;
  -----------------------------------------------------------------------
  procedure sp_guardar_historico(pn_usuario char,
                                 pn_fcorte  date) is
  
    pn_fcarga date;
    lc_coderr char(100);
    lc_msgerr char(1000);
  
  begin
  
    select t.pgfape into pn_fcarga from fst017 t where t.pgcod = 1;
  
    
      
        delete from aqpc351h t
         where t.aqpc351husur = pn_usuario
           and t.aqpc351hfproc = pn_fcorte
           ;
        commit;
      
        begin
        
          insert into aqpc351h
          (aqpc351husur,
  aqpc351hcta,
  aqpc351hoper,
  aqpc351hemp,
  aqpc351hmod,
  aqpc351hsuc ,
  aqpc351hmda,
  aqpc351hpap,
  aqpc351hsbop,
  aqpc351htope,
  aqpc351hfsub,
  aqpc351hnsub,
  aqpc351hncer,
  aqpc351hcocob,
  aqpc351hnact ,
  aqpc351hfrepo,
  aqpc351htdocsbs,
  aqpc351htdocco,
  aqpc351hndocco,
  aqpc351htdoc,
  aqpc351hndoc,
  aqpc351hcsbs,
  aqpc351hrzsc,
  aqpc351hciiu,
  aqpc351hnpre ,
  aqpc351hmone ,
  aqpc351hmto,
  aqpc351hprccob,
  aqpc351hmtocob ,
  aqpc351hsdo ,
  aqpc351hsdoin ,
  aqpc351htear,
  aqpc351hplaz,
  aqpc351hpgra,
  aqpc351hfinico,
  aqpc351hfini,
  aqpc351hffin,
  aqpc351htcre,
  aqpc351hfcsbs,
  aqpc351hsnor,
  aqpc351hscpp,
  aqpc351hsdef,
  aqpc351hsdud,
  aqpc351hsper,
  aqpc351hvent,
  aqpc351hcodhon,
  aqpc351hdatr,
  aqpc351hmoncof,
  aqpc351hplacof,
  aqpc351hpercof,
  aqpc351hestc,
  aqpc351hfcest,
  aqpc351hfcanc ,
  aqpc351hcapcanc ,
  aqpc351hrgon,
  aqpc351hzona ,
  aqpc351hagen,
  aqpc351hanl,
  aqpc351hchon ,
  aqpc351hfhon,
  aqpc351hmhon,
  aqpc351hsdohon ,
  aqpc351hcrehon ,
  aqpc351htmor,
  aqpc351htinto,
  aqpc351hfproc ,
  aqpc351hfcr ,
  aqpc351hhcr)
          select aqpc351usur,
  aqpc351cta,
  aqpc351oper,
  aqpc351emp,
  aqpc351mod,
  aqpc351suc ,
  aqpc351mda,
  aqpc351pap,
  aqpc351sbop,
  aqpc351tope,
  aqpc351fsub,
  aqpc351nsub,
  aqpc351ncer,
  aqpc351cocob,
  aqpc351nact ,
  aqpc351frepo,
  aqpc351tdocsbs,
  aqpc351tdocco,
  aqpc351ndocco,
  aqpc351tdoc,
  aqpc351ndoc,
  aqpc351csbs,
  aqpc351rzsc,
  aqpc351ciiu,
  aqpc351npre ,
  aqpc351mone ,
  aqpc351mto,
  aqpc351prccob,
  aqpc351mtocob ,
  aqpc351sdo ,
  aqpc351sdoin ,
  aqpc351tear,
  aqpc351plaz,
  aqpc351pgra,
  aqpc351finico,
  aqpc351fini,
  aqpc351ffin,
  aqpc351tcre,
  aqpc351fcsbs,
  aqpc351snor,
  aqpc351scpp,
  aqpc351sdef,
  aqpc351sdud,
  aqpc351sper,
  aqpc351vent,
  aqpc351codhon,
  aqpc351datr,
  aqpc351moncof,
  aqpc351placof,
  aqpc351percof,
  aqpc351estc,
  aqpc351fcest,
  aqpc351fcanc ,
  aqpc351capcanc ,
  aqpc351rgon,
  aqpc351zona ,
  aqpc351agen,
  aqpc351anl,
  aqpc351chon ,
  aqpc351fhon,
  aqpc351mhon,
  aqpc351sdohon ,
  aqpc351crehon ,
  aqpc351tmor,
  aqpc351tinto,
  aqpc351fproc ,
  aqpc351fcr ,
  aqpc351hcr
 from aqpc351
where aqpc351usur = pn_usuario;

        commit;
        
        exception
          when others then
          
            lc_coderr := sqlcode;
            lc_msgerr := trim(sqlerrm);
          
        end;
 end sp_guardar_historico;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_sch_reactivarepro_ant(pd_fecpro  in date,
                               pn_usuario in varchar2
                               --,pn_flag out varchar2
                               ) is
  
    ln_ini      number;
    lc_variable varchar2(4000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    --ld_finmes   date;
    lc_hostname varchar2(64);
  
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
    lc_user       varchar(5);
    lc_prefijo    varchar(10);
    --lc_flag       varchar2(1);
    x             number;
    --lc_fecha      date;
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
      --or sucurs >= 900
      ;
  
  begin
  
    begin
      delete from aqpc351 x
       where x.aqpc351usur = rpad(trim(pn_usuario), 10, ' ');
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
    lc_prefijo    := 'REAC2' || lc_user;
    lc_paquete    := 'pq_cr_reporte_reactivarepro';
    lc_proceso    := 'sp_cr_sch_reactivarepro2';
    lc_pac_nombre := trim(lc_paquete) || '.' || trim(lc_proceso);
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    ---carga diaria
    for i in sucursal loop
      ln_ini := i.sucurs;
      ln_job := ln_job + 1;
      --lc_prefjob    := 'REA_REP_1';
      lc_prefjob    := lc_prefijo;
      pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
      lc_variable   := 'begin ' ||
                       '  pq_cr_reporte_reactivarepro.sp_cr_sch_reactivarepro2( TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),' || ln_ini ||
                       ',''' || pn_usuario || ''' );' || ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        
      
        dbms_job.submit(job_id,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
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
    pq_cr_reporte_reactivarepro.sp_guardar_historico(pn_usuario, pd_fecpro);
  
      
  
  end sp_cr_sch_reactivarepro_ant;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_sch_reactivarepro(pd_fecpro  in date,
                               pn_usuario in varchar2
                               --,pn_flag out varchar2
                               ) is
  
    
  
  begin
  
     
    pq_cr_reporte_reactivarepro.sp_cr_sch_reactivarepro_sinjob(pd_fecpro,pn_usuario);
  
      
  
  end sp_cr_sch_reactivarepro;
end PQ_CR_REPORTE_REACTIVAREPRO;
/

