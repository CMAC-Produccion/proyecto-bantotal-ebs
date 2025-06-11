create or replace package dwhouse.PQ_CARGA_FACTS is

  -- Author  : PVARGAS
  -- Created : 16/07/2018 08:02:07 p.m.
  -- Purpose : 
  
  Function fn_tiempo_key(PD_FECHA In Date) Return Number;
  Function fn_valor_parametro(PV_CODIGO IN Varchar2)
  Return Varchar2;
  Function fn_geografia_key(PN_CODSUC In Number,PV_TIPREG In Varchar2)
  Return Number;
  
  Procedure sp_fact_pasivas_new(PN_CODSUC In Number,PN_TOPE In Number,
                               PN_AGETES In Number,PV_RUBRO In Varchar2,
                               PV_FECHA In Varchar2);

  Procedure sp_job_fact_activas(PD_FECHA in Date);
  Procedure sp_fact_activas(PN_CTAINI In Number,PN_CTAFIN In Number,PV_FECHA In Varchar2);
  Procedure sp_job_fact_pasivas(PD_FECHA in Date);
  Procedure sp_fact_pasivas(PN_CTAINI In Number,PN_CTAFIN In Number,
                            PN_AGETES In Number,PV_FECHA In Varchar2);
  Procedure sp_job_fact_saldos(PD_FECHA in Date);
  Procedure sp_fact_saldos(PN_CTAINI In Number,PN_CTAFIN In Number,
                            PN_AGETES In Number,PV_FECHA In Varchar2);                          
   
  Procedure sp_estadisticas(PD_FECHA In Date);
  Procedure sp_estadisticas_det (PD_FECHA In varchar2, pc_owner in varchar2, pc_tabla in varchar2, pn_degree in number );
  Procedure sp_fsd_anexo17A (PD_FECHA In Date);
  Procedure sp_fact_base_Anexo17A(PD_FECHA In Date);
  
  Procedure sp_saldos_his_fsd(PD_FECHA In Date);
  Procedure sp_fact_activas_cancelados(PD_FECHA In Date);
  Procedure sp_fact_analista(PD_FECHA in Date);
  Procedure sp_ins_fact_activo_cancelados(PD_FECHA In Date);
  
  Procedure sp_fsd_obligaciones(PD_FECHA In Date);
  Procedure sp_job_fact_fsd_diario(PD_FECHA in Date);
  Procedure sp_fact_fsd_diario(PN_CTAINI In Number,PN_CTAFIN In Number,PV_FECHA In Varchar2);
  
  Procedure SP_JOB_ACTIVAS_TMA(PD_FECHA In Date);
  Procedure SP_ACTIVAS_TMA(PN_REGINI In Number,PN_REGFIN In Number,PV_FECHA In Varchar2);
  
  Procedure fact_fsd_colabco(PD_FECHA In Date);
  Procedure sp_job_act_cosechas(PD_FECSDO In Date);
  Procedure sp_fact_act_cosechas(PN_PERIODO In Number, PV_FECSDO In Varchar2,PV_NOMBRE In Varchar2);
  
  Procedure SP_CARGA_DEPOSITOS_PN(PD_FECHA In Date);
  Procedure sp_fact_anx_numdep_pn (PD_FECHA In Date);
  Procedure FACT_PNOR_PNUMDEP_CR (PD_FECHA In Date);
  
  Procedure SP_CARGA_SALDOS_ICP(PD_FECHA in Date);
  Procedure SP_JOB_UPD_SALDOS_ICP(PD_FECHA in Date);
  Procedure SP_UPD_SALDOS_ICP(PN_CINI In Number,PN_CFIN In Number,PV_FECHA In Varchar2);
  Procedure SP_INS_SALDOS_ICP(PD_FECHA In Date);
  
  Procedure SP_FACT_DEPAFPBONO;
  
  Procedure sp_fact_base_Anexo17A_2022(PD_FECHA In Date);
  ----------------
  PROCEDURE sp_seg_captaciones(PD_FECHA In Date);
  ----------------
  PROCEDURE SP_7_ESTRUCT_ANEXO17A(PD_FECHA IN DATE);
  ----------------
  Procedure sp_fact_base_Anexo17A_new(PD_FECHA In Date);
  ----------------
  Function fn_limite_age(PN_CODSUC In Number)Return Number;
  -------------------------------------------------
  ------- FSD CREDINKA ----------------------------
  -------------------------------------------------
  Procedure sp_fsd_anexo17A_credinka (PD_FECHA In Date, PN_TIPPRO In Number);
  Procedure sp_fact_base_Anexo17A_credinka(PD_FECHA In Date);
  -------------------------------------------------
end PQ_CARGA_FACTS;
/
create or replace package body dwhouse.PQ_CARGA_FACTS is
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
 Function fn_tiempo_key(PD_FECHA In Date)
 Return Number
 Is
   ln_tiempo Number(10);
 Begin
      Begin  
          Select tiempo_key
            Into ln_tiempo
            From dm_tiempo
           Where fecha = PD_FECHA;
      Exception When Others Then
         ln_tiempo := Null;
      End;      
      Return ln_tiempo;
End fn_tiempo_key;      
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
Function fn_valor_parametro(PV_CODIGO IN Varchar2)
Return Varchar2
Is
  lv_valor Varchar2(100);
Begin
  Begin
      Select valor Into lv_valor
        From bi_parametro 
       where parametro_key = PV_CODIGO;
  Exception When Others Then
       lv_valor := Null;
  End;
  Return lv_valor;
End fn_valor_parametro;  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
 Function fn_geografia_key(PN_CODSUC In Number,PV_TIPREG In Varchar2)
 Return Number
 Is
   ln_geok Number(10);
 Begin
      Begin  
          Select geografia_key
            Into ln_geok
            From dm_geografia
           Where to_number(codigo_agencia) = PN_CODSUC
             and tipo_region = PV_TIPREG;
      Exception When Others Then
         ln_geok := Null;
      End;      
      Return ln_geok;
End fn_geografia_key;   
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Procedure sp_job_fact_activas(PD_FECHA in Date)
 Is
    ------
    ln_tiempo_key number(10);                                           
	  lv_valor      bi_parametro.valor%type;
    ln_existe     number(1) :=0;
    ln_flag       number(1);
    ------
    ln_max       number(10);
    ln_rango     number(10);
    x            number(10);
    ln_job       number(10);
    ln_ini       number(10);
    ln_fin       number(10);
    lv_nproc     varchar2(1000);
    lv_fecha     varchar2(10):=to_char(PD_FECHA,'rrrrmmdd');
    --ld_fecha     date := to_date(lv_fecpro,'dd-mm-yyyy');
    ln_mmxjob    number(10);
    NUM_JOB_PENDIENTES  number(10);
 Begin

      -------------------------------------
      -- REVISAR SI FINALIZARON DIMENSIONES
      -------------------------------------
      Loop 
          NUM_JOB_PENDIENTES := dwextra.FN_MG_VERIFICA_TAREA(pi_vc2_nomjob => 'DM_CREDITO',
                                                             pi_vc2_nomusr => user);
      Exit When NUM_JOB_PENDIENTES = 0;
      End loop;
      
      --
      Select TIEMPO_KEY into ln_tiempo_key from dm_tiempo where fecha = PD_FECHA;
      Begin	
	         Select valor Into lv_valor
			       From bi_parametro 
			      Where parametro_key = 5;
	    Exception When Others Then
		        lv_valor:= null;
	    End;	
      
      IF PD_FECHA <= to_date('20150331','rrrrmmdd') Then
         SELECT count(*) Into ln_existe
           FROM DBA_TAB_PARTITIONS 
          WHERE TABLE_OWNER='DWHOUSE' 
            and table_name='FACT_ACTIVO' 
            and partition_name = 'FACT_ACTIVAS_'||to_char(PD_FECHA,'rrrrmm');
         ln_flag := 1;             
             
         If ln_existe = 0 Then  
            SELECT count(*) Into ln_existe
               FROM DBA_TAB_PARTITIONS 
              WHERE TABLE_OWNER='DWHOUSE' 
                and table_name='FACT_ACTIVO' 
                and partition_name = 'FACT_ACTIVAS_'||to_char(PD_FECHA,'rrrrmmdd');
              ln_flag := 2;              
         End If;
     
         IF ln_existe > 0 and lv_valor='R' then
            If ln_flag = 1 Then
               Execute Immediate 'alter table fact_activo drop partition FACT_ACTIVAS_'||
                                 to_char(PD_FECHA,'rrrrmm')||' update global indexes parallel(degree 4)';
            Else
               Execute Immediate 'alter table fact_activo drop partition FACT_ACTIVAS_'||
                                 to_char(PD_FECHA,'rrrrmmdd')||' update global indexes parallel(degree 4)';
            End If;    
         End If;                     
     
         -- Consultar partición
         SELECT count(*) Into ln_existe
           FROM DBA_TAB_PARTITIONS 
          WHERE TABLE_OWNER='DWHOUSE' 
            and table_name='FACT_ACTIVO' 
            and partition_name = 'FACT_ACTIVAS_'||to_char(PD_FECHA,'rrrrmmdd');
     
         If ln_existe = 0 Then
            EXECUTE IMMEDIATE 'alter table FACT_ACTIVO add partition FACT_ACTIVAS_'||
                              to_char(PD_FECHA,'rrrrmmdd')||' values ('||ln_TIEMPO_KEY||') TABLESPACE DWHOUSE_B';   			 
         End If;
      ELSE  
           Begin
                SELECT 1 Into ln_existe
                  FROM DBA_TAB_PARTITIONS 
                 WHERE TABLE_OWNER='DWHOUSE' 
                   and table_name='FACT_ACTIVO' 
                   and partition_name = 'FACT_ACTIVAS_'||to_char(PD_FECHA,'rrrrmmdd');
           Exception When no_data_found then
                 ln_existe :=0;
           End; 
       
	         If lv_valor ='R' and ln_existe > 0 Then
              -- ELIMINA PARTICION  
		          Execute immediate 'ALTER TABLE FACT_ACTIVO DROP PARTITION FACT_ACTIVAS_'||to_char(PD_FECHA,'rrrrmmdd')||
                                ' update global indexes parallel(degree 4)';
	         End If;	      
	
	         If lv_valor in ('R','T') Then
	            -- CREA PARTICION 
              Begin
                   SELECT 1 Into ln_existe
                     FROM DBA_TAB_PARTITIONS 
                    WHERE TABLE_OWNER='DWHOUSE' 
                      and table_name='FACT_ACTIVO' 
                      and partition_name = 'FACT_ACTIVAS_'||to_char(PD_FECHA,'rrrrmmdd');
              Exception When no_data_found then
                    ln_existe :=0;
              End;      
              IF ln_existe = 0 then
                  EXECUTE IMMEDIATE 'alter table FACT_ACTIVO add partition FACT_ACTIVAS_'||
                                     to_char(PD_FECHA,'rrrrmmdd')||' values ('||ln_TIEMPO_KEY||') TABLESPACE DWHOUSE_B';   			 
              End if;
	         End If;
	    END IF;
      ----------------------------------
      -- Genera rangos para jobs
      ----------------------------------
      Begin 
           Select max(ctnro),trunc(max(ctnro)/300)   
             Into ln_max,ln_rango
             From dwextra.fsr008
            Where ctnro <> 999999999;
      Exception When no_data_found then
                ln_max := 0;
                ln_rango:=0;
      End;    
         
      x:=0;
      ln_job := 0;
      While x <= ln_max loop
              ln_ini := x+1;
              x:= x+ ln_rango;
              ln_fin := x;
              lv_nproc := ' begin '||'pq_carga_facts.sp_fact_activas('||ln_ini||','||ln_fin ||',''' 
                                   ||lv_Fecha||'''); End; ';
              ln_job := ln_job +1;
              
              dbms_scheduler.create_job(
                 job_name=> 'FACT_ACTIVAS_'||LPAD(TO_CHAR(ln_job),5,'0'),
                 job_type=> 'PLSQL_BLOCK',
                 job_action=> lv_nproc,
                 start_date => sysdate+1/(24*180),
                 enabled => true, 
                 auto_drop=> TRUE,
                 comments => 'Carga FACT ACTIVAS'
                 );
             Commit;
            -- CONTROLA MAXIMO 200 JOBS
            Loop
               select count(*) into ln_mmxjob from user_scheduler_jobs;
            Exit When ln_mmxjob <= 200;
            End Loop;
      End loop;
      
      --- Controla que finalicen Jobs para analizar particion
      Loop
          select count(*) into ln_mmxjob from user_scheduler_jobs Where job_name like 'FACT_ACTIVAS_%';
      Exit When ln_mmxjob = 0;
      End Loop;
      -- Actualiza flag de carga
      Update dm_tiempo Set actcar=1,fecfact=1 Where fecha = PD_FECHA;
      Commit;
 End sp_job_fact_activas;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_fact_activas(PN_CTAINI In Number,PN_CTAFIN In Number,PV_FECHA In Varchar2)
 Is
   -- 2018.10.02 -> Se agregó campo tipo_ana_key   
   ld_Fecha date := to_date(PV_FECHA,'RRRRMMDD');
 BEGIN	              
      INSERT INTO FACT_ACTIVO
            (ROW_ID,
             Tiempo_Key,
             Credito_Key,
             Rubro_Key,
             Producto_Key,
             Geografia_Key,
             Analista_Key,
             Campania_key,
             Tipo_Credito_Key,
             Cliente_Key,
             convenio_key,
             moneda_key,
             situacion_key,
             modalidad_key,
             AgenciaBN_Key,
             --Tiempo_Vencimiento_Actual,
             Frecuencia,
             Plazo,
             Dias_Atraso,
             Saldo_Capital_MN,
             Saldo_Capital_MO,
             Saldo_Capital_Mora_MN,
             Saldo_Capital_Mora_MO,
             Interes_pagado_MN,
             Interes_Pagado_MO,
             Interes_Pactado,
             Tipo_Cambio,
             Saldo_Interes_Diferido,
             Deuda_Total,
             Deuda_Amortizada,
             Factor_Tasa_Ponderada_MN,
             Factor_Tasa_Ponderada_MO,
             Rentabilidad,
             Tasa_Ponderada_MN,
             Tasa_Ponderada_MO,
             Porcentaje_Mora,
             Porcentaje_Mora_Contable,
             Num_Cliente,
             Num_cliente_Retenido,
             Num_Credito,
             Provision_Total,
             Provision_Obligatoria,
             Provision_Prociclica,
             Provision_Generica,
             Provision_Especifica,
             Cantidad_Cuota_Pagadas,
             Cantidad_Cuota_Impaga,
             Ranking_Cliente,
             Flag_Tipo_Garantia,
             Saldo_Garantia_inscrita,
             Codigo_Situacion, 
             fecha_vencimiento,
             categoria_key,
             saldo_vencido_mo,
             saldo_vencido_mn,
             tipo_cliente_key,
             actividad_economica_key,
             producto_reg_key,
             destino_key,
             total_linea_mo,
             total_linea_mn ,
             segmento_key,
             sectorsbs_key,
             fecha_vence_cuota,
             tasa_interes,
             imp_k_cuota,
             imp_i_cuota,
             deu_k_cuota,
             deu_i_cuota,
             imp_desemb,
             tipo_clicaj_key,
             ind_nuevo_mes,
             capital_pactado,
             inst_origen,
             imp_utilizado,
             comite_key,
             IMP_CASTIGO_MO,
             aomod,aocta,aoope,aosbo,aotop,
             segmer_key,segtcr_key,
             segtc_total_key,
             segtc_tottcr_key,
             segtc_totseg_key,
             segmer_cli_key,
             ind_casven,
             /*lllosa 2017/10/03 inicio*/
             cartera_heredada,
             nivel_venta,
             gastomn_periodo,
             gastomd_periodo,
             revermn_periodo,
             revermd_periodo,
             gastomn_cierrea,
             gastomd_cierrea,
             revermn_cierrea,
             revermd_cierrea,
             gastomn_anioant,
             gastomd_anioant,
             revermn_anioant,
             revermd_anioant,
             categoria_ana_key,
             /*lllosa 2017/10/03 fin*/
             -- Ini:Provision diaria:2018.07.15 (pvargas)
             catuni_dia_key,
             improv_dia,
             catuni_mes_key,
             improv_mes,
             -- Fin:Provision diaria:2018.07.15 (pvargas)
             tipo_ana_key,
             /*,dia_saldo
             ,estado_key
             ,saldo_mn_ma,saldo_mn_aa
             ,diaatr_ma, diaatr_aa
             ,situacion_ma_key,situacion_aa_key
             ,base_cont
             ,analista_act_key,geografia_act_key
             ,comite_act_key,tipana_act_key
             ,catana_act_key*/
             saldo_mn_ma,saldo_mn_aa,
             situacion_ma_key,situacion_aa_key,
             diaatr_ma,diaatr_aa,
             base_cont,dia_saldo,
             analista_act_key,geografia_act_key,comite_act_key,
             tipana_act_key,catana_act_key,estado_key,
             saldo_mo_ma,sldven_mo_ma,sldven_mn_ma, 
             tasa_int_ma,ind_nuevo_ma,tipcli_ma_key,
             base_ret_ma,
             saldo_mo_aa,sldven_mo_aa,sldven_mn_aa, 
             tasa_int_aa,ind_nuevo_aa,tipcli_aa_key,
             base_ret_aa,
             imp_ingreso_mn_ma,
             imp_ingccas_mn_ma,
             imp_comisio_mn_ma,
             imp_revpro_mn_ma,
             imp_proesp_mn_ma,
             imp_proobl_mn_ma,
             imp_propro_mn_ma,
             imp_provol_mn_ma,
             imp_progso_mn_ma,
             key_crever
            )
            Select SEQ_FACT_ACTIVO.nextval    ROW_ID,
                   b.Tiempo_Key,
                   c.Credito_Key,
                   d.Rubro_Key,
                   e.Producto_Key,
                   f.Geografia_Key,
                   g.Analista_Key,
                   h.Campania_key,
                   i.Tipo_Credito_Key,
                   j.Cliente_Key,
                   k.convenio_key,
                   l.moneda_key,
                   ll.situacion_key,
                   m.modalidad_key,
                   AgenciaBN_Key,
                   --ñ.Tiempo_Key               Tiempo_Vencimiento_Actual,
                   a.Frecuencia,
                   a.Plazo,
                   Dias_Atraso,
                   a.Saldo_Capital_MN,
                   a.Saldo_Capital_MO,
                   a.Saldo_Capital_Mora_MN,
                   a.Saldo_Capital_Mora_MO,
                   a.Interes_pagado_MN,
                   a.Interes_Pagado_MO,
                   a.Interes_Pactado,
                   a.Tipo_Cambio,
                   a.Saldo_Interes_Diferido,
                   a.Deuda_Total,
                   a.Deuda_Total_Amortizada,
                   a.Factor_Tasa_Ponderada_MN,
                   a.Factor_Tasa_Ponderada_MO,
                   a.Rentabilidad,
                   a.Tasa_Ponderada_MN,
                   a.Tasa_Ponderada_MO,
                   a.Porcentaje_Mora,
                   a.Porcentaje_Mora_Contable,
                   a.Num_Cliente,
                   a.Num_cliente_Retenido,
                   a.Num_Credito,
                   a.Provision_Total,
                   a.Provision_Obligartoria,
                   a.Provision_Prociclica,
                   a.Provision_Generica,
                   a.Provision_Especifica,
                   a.Cantidad_Cuota_Pagada,
                   a.Cantidad_Cuota_Impaga,
                   a.Ranking_Cliente,
                   a.Flag_Tipo_Garantia,
                   a.Saldo_Garantia_inscrita,
                   ll.Codigo_situacion,
                   a.fecha_vencimiento_actual,
                   ct.categoria_key,  
                   a.saldo_vencido_mo,
                   a.saldo_vencido_mn,
                   tc.tipo_cliente_key,
                   ae.actividad_economica_key,
                   pr.producto_reg_key,
                   dt.destino_key,
                   a.total_linea_mo,
                   a.total_linea_mn,
                   sg.segmento_key,
                   ss.sectorsbs_key,
                   a.fecha_vence_cuota,
                   a.tasai,
                   nvl(a.imp_k_cuota,0),
                   nvl(a.imp_i_cuota,0),
                   nvl(a.deu_k_cuota,0),
                   nvl(a.deu_i_cuota,0),
                   nvl(a.imp_desembolsado,0),
                   tj.tipo_cliente_key,
                   a.ind_nue_mes,
                   a.capital_pactado,
                   a.inst_ori,
                   a.imp_sdolin_uti,
                   cc.comite_key,
                   a.importe_castigo,
                   a.aomod,a.aocta,a.aoope,a.aosbo,a.aotop,
                   sm.segmer_key,
                   st.segtcr_key,
                   24,
                   (case when st.segtcr_key in (2,3,4,5) then 27
                         when st.segtcr_key in (7,8,9) then 26
                         else st.segtcr_key 
                    end) ,
                   (case when st.segtcr_key in (0,1) then 28
                         when st.segtcr_key in (2,3,4,5,6) then 25
                         when st.segtcr_key in (7,8,9,10) then 23
                         else st.segtcr_key  
                    end),
                    sc.segmer_key ,
                    a.ind_casven,
                    /*lllosa 2017/10/03 inicio*/
                    a.cartera_heredada,
                    a.nivel_venta,
                    a.gastomn_periodo,
                    a.gastomd_periodo,
                    a.revermn_periodo,
                    a.revermd_periodo,
                    a.gastomn_cierrea,
                    a.gastomd_cierrea,
                    a.revermn_cierrea,
                    a.revermd_cierrea,
                    a.gastomn_anioant,
                    a.gastomd_anioant,
                    a.revermn_anioant,
                    a.revermd_anioant,
                    cta.categoria_ana_key,
                    /*lllosa 2017/10/03 fin*/
                    cd.categoria_key,
                    nvl(a.imp_provis,0),
                    cm.categoria_key,
                    nvl(a.imp_prodia_mes,0),
                    -- Analista Actual
                    ta.tipo_ana_key,
                    a.saldo_mn_ma,a.saldo_mn_aa,
                    a.situacion_ma_key,a.situacion_aa_key,
                    a.diaatr_ma,a.diaatr_aa,
                    a.base_cont,a.dia_saldo,
                    g.analista_key,f.Geografia_Key,cc.comite_key,
                    ta.tipo_ana_key,cta.categoria_ana_key,a.estado_key,
                    a.saldo_mo_ma,a.sldven_mo_ma,a.sldven_mn_ma, 
                    a.tasa_int_ma,a.ind_nuevo_ma,a.tipcli_ma_key,
                    a.base_ret_ma,
                    a.saldo_mo_aa,a.sldven_mo_aa,a.sldven_mn_aa, 
                    a.tasa_int_aa,a.ind_nuevo_aa,a.tipcli_aa_key,
                    a.base_ret_aa,
                    ---
                    a.imp_ingreso_mn_ma,
                    a.imp_ingccas_mn_ma,
                    a.imp_comisio_mn_ma,
                    a.imp_revpro_mn_ma,
                    a.imp_proesp_mn_ma,
                    a.imp_proobl_mn_ma,
                    a.imp_propro_mn_ma,
                    a.imp_provol_mn_ma,
                    a.imp_progso_mn_ma,
                    nvl(a.key_crever,0)
              From DWSTAGE.tmp_fact_activo a
             inner join dm_tiempo b
                on a.fecha = b.fecha
             inner join dm_credito c
                on a.codigo_credito = c.codigo_credito
               and a.credito_unico  = c.credito_unico 
             inner join dm_rubro d
                on a.codigo_rubro = d.codigo_rubro
             inner join dm_producto e
                on nvl(a.codigo_subproducto, -1) = e.codigo_subproducto
               and nvl(a.codigo_producto, -1) = e.codigo_producto
             inner join dm_geografia f
                on f.codigo_agencia = a.codigo_agencia
               and f.tipo_region   = a.tipo_region
             inner join dm_analista g
                on a.codigo_analista = g.codigo_analista
             inner join dm_campania h
                on h.codigo_scampania = nvl(a.codigo_campania,0)
             inner join dm_tipo_credito i
                on a.codigo_tipo_credito_actual = i.codigo_tipo_credito
               and a.codigo_sector = i.codigo_sector
             inner join dm_cliente j
                on a.codigo_cliente = j.codigo_cliente
             join dm_convenio k
                on nvl(a.codigo_convenio,'0') = k.codigo_convenio
             inner join dm_moneda l
                on a.codigo_moneda = l.codigo_moneda
             inner join dm_situacion ll
                on a.codigo_situacion = ll.codigo_situacion
               and a.codigo_tipo_Situacion = ll.codigo_tipo_Situacion
             inner join dm_modalidad m
                on a.codigo_modalidad = m.codigo_modalidad
             inner join dm_agencia_bn n
                on nvl(a.codigo_agenciabn, -1) = n.codigo_agenciabn  
             inner join dm_categoria ct 
                on ct.codigo_categoria = a.codigo_categoria		   
             inner join dm_tipo_cliente tc
                on tc.tipo_cliente_codigo = a.tipo_cliente	
             inner join dm_actividad_economica ae
                on ae.codigo_actividad_economica = a.codigo_actividad_economica
             inner join dm_producto_reg pr
                on pr.producto_reg_pcod = a.producto_reg_pcod
               and pr.producto_reg_scod = a.producto_reg_scod
             inner join dm_destino dt
                on dt.destino_key = a.destino_cod   	
             inner join dm_segmento sg
                on sg.codigo_segmento = a.codigo_segmento
             inner join dm_sector_sbs ss
                on ss.sector_cod = a.codigo_sector_sbs   
             inner join dm_tipo_cliente tj
                on tj.tipo_cliente_codigo = a.tipo_clie_caja  
             inner join dm_comite_credito cc
                on cc.comite_cod = a.comite_cod
             inner join dm_segmento_mercado sm
                on sm.segmer_key = a.segmer_cod  
             inner join dm_segmento_tipo_cred st
                on st.tcri_cod = a.tcri_cod
             inner join dm_segmento_mercado sc
                on sc.segmer_key = nvl(a.segmer_cli,0) 
             inner join dm_categoria_ana cta 
                on cta.codigo_categoria_ana = nvl(a.codigo_categoria_ana,99)
             inner join dm_categoria cd
                on cd.codigo_categoria = nvl(a.codcat_ali,-1)   
             inner join dm_categoria cm
                on cm.codigo_categoria = nvl(a.codcat_ali_mes,-1)   
             inner join dm_tipo_ana ta
                on ta.codigo_tipo_ana  = nvl(a.codigo_tipo_ana,'0')   
             inner join dm_estado es 
                on es.codigo_estado = nvl(a.cod_estado,'0')  
             WHERE a.fecha = ld_fecha
               AND a.aocta Between PN_CTAINI and PN_CTAFIN
             LOG ERRORS INTO ERR$_FACT_ACTIVO ('INSERT-' || to_char(ld_fecha,'rrrrmmdd')) REJECT LIMIT UNLIMITED; 
             COMMIT;
 End sp_fact_activas; 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_estadisticas (PD_FECHA In Date)
 Is

 cursor estadi is
   select * from TBESTADI
   where ESTADO = 'S';
 lc_variable   varchar2(4000);
 ln_job        number:= 0;
 ln_ini number:=0;
 lc_fecha varchar2(12);
 NUM_JOB_PENDIENTES NUMBER(10);
    
 Begin
      null;
      lc_fecha := to_char(PD_FECHA,'rrrrmmdd');
      for i in estadi loop
         ln_ini := ln_ini + 1;  
         lc_variable := ' begin '||'  pq_carga_facts.sp_estadisticas_det('||''''  ||lc_fecha|| ''''||','||''''|| i.nowner||''''||','||''''|| i.ntabla||''''||','|| i.ndegree||');'|| ' End; ';
         ln_job := ln_job +1;
        -- dbms_output.put_line (lc_variable);
           
        dbms_scheduler.create_job(
           job_name=> 'ESTADI'||LPAD(TO_CHAR(ln_job),5,'0'),
           job_type=> 'PLSQL_BLOCK',
           job_action=> lc_variable,
           start_date => sysdate+1/(24*180),
           enabled => true, 
           auto_drop=> TRUE,
           comments => 'ESTADISTICA'
           );
       commit;
       
      
      
      end loop; 
      NUM_JOB_PENDIENTES := dwextra.FN_MG_VERIFICA_TAREA(pi_vc2_nomjob => 'ESTADI%',
                                                     pi_vc2_nomusr => user);

      WHILE NUM_JOB_PENDIENTES > 0 LOOP
    
        NUM_JOB_PENDIENTES := dwextra.FN_MG_VERIFICA_TAREA(pi_vc2_nomjob => 'ESTADI%',
                                                   pi_vc2_nomusr => user);
      end loop;
      --sp_fact_matriz_migracion(PD_FECHA);                                                          
                                                              
 Exception When Others Then
     Null;                                   
 End sp_estadisticas;
 
 Procedure sp_estadisticas_det (PD_FECHA In varchar2, pc_owner in varchar2, pc_tabla in varchar2, pn_degree in number )
 Is
 Begin
 
       -- Estadisticas
	  	DBMS_STATS.gather_table_stats(ownname          => pc_owner ,
                                    tabname          => pc_tabla, 
                                    degree           => pn_degree,
                                    partname         => pc_tabla||'_'||PD_FECHA,
                                    method_opt       => 'for all indexed columns size 1',
                                    granularity      => 'ALL',
                                    estimate_percent => 1,--dbms_stats.auto_sample_size,
                                    cascade          => true);--DBMS_STATS.AUTO_CASCADE);
      

            
 Exception When Others Then
     Null;                                   
 End sp_estadisticas_det;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_job_fact_pasivas(PD_FECHA in Date)
 /****************************************************************
  Fecha: 2018.07.22
  Autor: Paola Vargas
  Uso  : Generar Job para carga incremental de hechos de operaciones
         pasivas    
  *****************************************************************/
 Is
    ------
    ln_tiempo_key number(10);                                           
	  lv_tipvar  bi_parametro.valor%type;
    ln_existe     number(1) :=0;
    ln_agetes number(10);
    ------
    ln_max       number(10);
    ln_rango     number(10);
    x            number(10);
    ln_job       number(10);
    ln_ini       number(10);
    ln_fin       number(10);
    lv_nproc     varchar2(1000);
    lv_fecha     varchar2(10):=to_char(PD_FECHA,'rrrrmmdd');
    --ld_fecha     date := to_date(lv_fecpro,'dd-mm-yyyy');
    ln_mmxjob    number(10);
    NUM_JOB_PENDIENTES  number(10);
    
    Cursor c_sjob(ld_fec in date) is
      Select aosuc,aotop,codigo_rubro,count(*) cnt
        from dwstage.tmp_fact_pasivo
       where fecha = ld_fec 
        group by aosuc,aotop,codigo_rubro;
    
 BEGIN
      
      --> REVISAR QUE LA CARGA DE DIMENSIONES HAYA FINILIDADO
      Loop
          Select count(*) Into NUM_JOB_PENDIENTES
            From user_scheduler_jobs
           where job_name like 'CARGA_DM%'
             and job_name not like '%DM_CR_DITO%';
      Exit When NUM_JOB_PENDIENTES = 0;
      End loop;
      --<
      
      Select TIEMPO_KEY into ln_tiempo_key from dm_tiempo where fecha = PD_FECHA;
      
      Begin  
         select valor Into lv_tipvar
    			 from bi_parametro 
    			where parametro_key = 5;
    	Exception When Others Then
    		 lv_TipVar:= null;
    	End;	
      
      -- Consultar si existe partición
      Select count(*) Into ln_existe From User_Tab_Partitions 
      Where Table_Name='FACT_PASIVO' And Partition_Name='FACT_PASIVO_'||to_char(PD_FECHA,'rrrrmmdd');
      
      
    	If lv_TipVar='R' And ln_existe > 0 Then
         --- ELIMINA PARTICION  
    		 Execute Immediate 'ALTER TABLE FACT_PASIVO DROP PARTITION FACT_PASIVO_'||to_char(PD_FECHA,'rrrrmmdd')
                         ||' Update global indexes parallel(degree 4)';
         ln_existe := 0;                 
    	End If;	      
    	
    	If ln_existe = 0 Then
    	   --- CREA PARTICION 
         EXECUTE IMMEDIATE 'alter table FACT_PASIVO add partition FACT_PASIVO_'||
    	                     to_char(PD_FECHA,'rrrrmmdd')||' values ('||ln_tiempo_key||') TABLESPACE DWHOUSE_B';   			 
    	End If;
      
      -- Agencia Tesorería
      Begin
          select geografia_key Into ln_agetes
            from dm_geografia 
           where codigo_agencia='900' 
             and codigo_region ='900';
      Exception When Others Then
         ln_agetes := Null;
      End;     
      
      ----------------------------------
      -- Genera rangos para jobs
      ----------------------------------
      --> 2023.09.06
      /*Begin 
           Select max(ctnro),trunc(max(ctnro)/300)   
             Into ln_max,ln_rango
             From dwextra.fsr008
            Where ctnro <> 999999999;
      Exception When no_data_found then
                ln_max := 0;
                ln_rango:=0;
      End;    
         
      x:=-1;
      ln_job := 0;
      While x <= ln_max loop
              ln_ini := x+1;
              x:= x+ ln_rango;
              ln_fin := x;
              lv_nproc := ' begin '||'pq_carga_facts.sp_fact_pasivas('||ln_ini||','||ln_fin ||
                          ','||ln_agetes||','''||lv_Fecha||'''); End; ';
              ln_job := ln_job +1;
              
              dbms_scheduler.create_job(
                 job_name=> 'FACT_PASIVAS_'||LPAD(TO_CHAR(ln_job),5,'0'),
                 job_type=> 'PLSQL_BLOCK',
                 job_action=> lv_nproc,
                 start_date => sysdate+1/(24*180),
                 enabled => true, 
                 auto_drop=> TRUE,
                 comments => 'Carga FACT PASIVAS'
                 );
             Commit;
            -- CONTROLA MAXIMO 200 JOBS
            Loop
               select count(*) into ln_mmxjob from user_scheduler_jobs;
            Exit When ln_mmxjob <= 200;
            End Loop;
      End loop;
      */
      --< 2023.09.06
      
      Execute Immediate 'Truncate table log_jobs';
      
      ln_job := 0;
      For x In c_sjob(PD_FECHA) Loop
          
          lv_nproc := 'Begin '||'pq_carga_facts.sp_fact_pasivas_new('||x.aosuc||','||x.aotop||
                           ','||ln_agetes||','''||x.codigo_rubro||''','''||lv_Fecha||'''); End; ';
          ln_job := ln_job +1;
          
          Begin
          Insert into log_jobs(fecha,job_name,valor1,valor2,vvalor1)
          Values(PD_FECHA,'FACT_PASIVAS_'||LPAD(TO_CHAR(ln_job),5,'0'),x.aosuc,x.aotop,x.codigo_rubro);
          Commit;
          Exception When Others Then
              Null;
          End;  
              
          dbms_scheduler.create_job(
                 job_name=> 'FACT_PASIVAS_'||LPAD(TO_CHAR(ln_job),5,'0'),
                 job_type=> 'PLSQL_BLOCK',
                 job_action=> lv_nproc,
                 start_date => sysdate+1/(24*180),
                 enabled => true, 
                 auto_drop=> TRUE,
                 comments => 'Carga FACT PASIVAS'
                 );
          Commit;
          -- CONTROLA MAXIMO 200 JOBS
          Loop
             select count(*) into ln_mmxjob from user_scheduler_jobs;
          Exit When ln_mmxjob <= 200;
          End Loop;  
      End Loop;  
      
      --- Controla que finalicen Jobs para actualizar fecha de carga
      Loop
          select count(*) into ln_mmxjob from user_scheduler_jobs Where job_name like 'FACT_PASIVAS_%';
      Exit When ln_mmxjob = 0;
      End Loop;
      
      -- Actualiza flag de carga
      Update dm_tiempo Set pascar=1 Where fecha = PD_FECHA;
      Commit;
  
 End sp_job_fact_pasivas; 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_fact_pasivas_new(PN_CODSUC In Number,PN_TOPE In Number,
                               PN_AGETES In Number,PV_RUBRO In Varchar2,
                               PV_FECHA In Varchar2)
 -- 2023.09.06
 Is
   ld_Fecha date := to_date(PV_FECHA,'RRRRMMDD');
   lv_merr varchar2(500);
 BEGIN
     Begin
         Update log_jobs set fecini = sysdate
          Where valor1=PN_CODSUC and  valor2 = PN_TOPE and vvalor1 = PV_RUBRO
            and fecha = ld_fecha;
         Commit;
     Exception When Others Then
         Null;
     End;
     Begin    
       INSERT INTO FACT_PASIVO
        (
          tiempo_key      , cuentas_key , cliente_key, 
          geografia_key   , fecha_ultdep, rubro_key, 
          producto_key    , moneda_key  , tipo_tarifario_key, 
          tipo_tasa_key   , campania_key, empleador_key, 
          asesor_key      , estado_key  , menor_edad, 
          tasa            , plazo       , tipo_cambio, 
          segmento_cli_key, geografia_cli_key, tipo_cliente_key, 
          saldo_mn        , saldo_mo, 
          saldo_int_mn    , saldo_int_mo, 
          saldo_dis_mn    , saldo_dis_mo, 
          saldo_pro_mn    , saldo_pro_mo, 
          saldo_gar_mn    , saldo_gar_mo, 
          imp_ape_mn      , imp_ape_mo, 
          imp_ren_mn      , imp_ren_mo, 
          imp_blo_mn      , imp_blo_mo, 
          int_gen_mn      , int_gen_mo, 
          fac_tpo_mn      , fac_tpo_mo, 
          cli_retenido    , cli_retenido_aho, cli_retenido_cts, 
          cli_retenido_dpf, cli_retenido_bi,
          gasto_fin_mn    , gasto_fin_mo,
          geografia_pas_key,ind_empbco, ind_dosrub,
          imp_fsd, int_fsd, gar_fsd, dii_fsd,ind_fsd,
          key_seg_cta
          
        )
        Select t.tiempo_key    , c.cuentas_key          , cl.cliente_key,
               g.geografia_key , p.fecha_ultimo_deposito, r.rubro_key,
               s.producto_key  , m.moneda_key           , tt.tipo_tarifario_key,
               ta.tipo_tasa_key,                     0  , em.empleador_key,
               ej.asesor_key   , es.estado_key          , p.identificador_menor_edad,
               to_number(p.tasa_interes)  , to_number(p.plazo)     , to_number(p.tipo_cambio),
               sg.segmento_key , gc.geografia_key       , tc.tipo_cliente_key,
               nvl(p.saldo_mn,0), nvl(p.saldo_mo,0)             , 
               decode(p.aomda,0,nvl(p.saldo_intangible,0),nvl(p.saldo_intangible,0)*to_number(p.tipo_cambio)),
               nvl(p.saldo_intangible,0),
               decode(p.aomda,0,nvl(p.saldo_disponible,0),nvl(p.saldo_disponible,0)*to_number(p.tipo_cambio)),
               nvl(p.saldo_disponible,0),
               decode(p.aomda,0,nvl(p.saldo_promedio,0),nvl(p.saldo_promedio,0)*to_number(p.tipo_cambio)),
               nvl(p.saldo_promedio,0),
               decode(p.aomda,0,nvl(p.saldo_garantia,0),nvl(p.saldo_garantia,0)*to_number(p.tipo_cambio)),
               nvl(p.saldo_garantia,0),
               decode(p.aomda,0,nvl(p.imp_apertura,0),nvl(p.imp_apertura,0)*to_number(p.tipo_cambio)),
               nvl(p.imp_apertura,0),
               decode(p.aomda,0,nvl(p.imp_renovacion,0),nvl(p.imp_renovacion,0)*to_number(p.tipo_cambio)),
               nvl(p.imp_renovacion,0),
               decode(p.aomda,0,nvl(p.imp_bloqueado,0),nvl(p.imp_bloqueado,0)*to_number(p.tipo_cambio)),
               nvl(p.imp_bloqueado,0),
               decode(p.aomda,0,nvl(p.interes_generado,0),nvl(p.interes_generado,0)*to_number(p.tipo_cambio)),
               nvl(p.interes_generado,0),
               nvl(p.saldo_mn,0) * to_number(p.tasa_interes),
               nvl(p.saldo_mo,0) * to_number(p.tasa_interes),
               p.cliente_retenido    , p.cliente_retenido_aho, p.cliente_retenido_cts,
               p.cliente_retenido_dpf, p.cliente_retenido_bi,
               decode(p.aomda,0,nvl(p.gasto_financ,0),nvl(p.gasto_financ,0)*to_number(p.tipo_cambio)),
               p.gasto_financ,
               decode(p.tipo_region,'T',PN_AGETES,g.geografia_key),
               p.ind_empbco,p.ind_dosrub,
               nvl(p.imp_fsd,0), nvl(p.int_fsd,0), nvl(p.gar_fsd,0), nvl(p.dii_fsd,0), nvl(p.ind_fsd,0),
               p.key_seg_cta
          From dwstage.tmp_fact_pasivo p
          Join dwhouse.dm_tiempo t 
            On t.fecha = p.fecha 
          Join dwhouse.dm_cuentas c
            On c.codigo_cuenta = p.codigo_cuenta
           And c.cuenta_unica  = p.cuenta_unica   
          Join dwhouse.dm_cliente cl
            On cl.codigo_cliente = p.codigo_cliente 
          Join dwhouse.dm_geografia g
            On g.codigo_agencia = p.codigo_agencia
           And g.tipo_region = p.tipo_region
          Join dwhouse.dm_rubro r 
            On r.codigo_rubro = p.codigo_rubro  
          Join dwhouse.dm_producto s
            On s.codigo_producto    = p.codigo_producto
           And s.codigo_subproducto = p.codigo_subproducto  
          Join dwhouse.dm_tipo_tarifario tt 
            On tt.codigo_tipo_tarifario = p.codigo_tipo_tarifario
          Join dwhouse.dm_moneda m
            On m.codigo_moneda = p.codigo_moneda
          Join dwhouse.dm_tipo_tasa ta 
            On ta.codigo_tipo_tasa = p.codigo_tipo_tasa
          Join dwhouse.dm_empleador em
            On em.codigo_empleador = p.codigo_empleador   
          Join dwhouse.dm_asesor ej
            On ej.codigo_asesor = p.codigo_asesor 
          Join dwhouse.dm_estado es
            On es.codigo_estado = p.codigo_estado 
          Join dwhouse.dm_segmento sg
            On sg.codigo_segmento = nvl(p.segmento_clie,'0')
          Join dwhouse.dm_geografia gc
            On gc.codigo_agencia = nvl(p.agencia_clie,'11')
           And gc.tipo_region    = nvl(p.tipo_reg_clie,'R')  
          Join dwhouse.dm_tipo_cliente tc
            On tc.tipo_cliente_codigo = p.tipo_cliente     
         Where t.fecha = ld_fecha
           and p.aosuc = PN_CODSUC 
           and p.aotop = PN_TOPE
           and p.codigo_rubro = PV_RUBRO
           and not (p.codigo_producto in ('11','221') or 
                    (p.codigo_cuenta like '156%' and p.saldo_mn = 0) or
                    (r.codigo_rubro like '21_70201%')
                   )        
         LOG ERRORS INTO ERR$_FACT_PASIVO ('INSERT-' || to_char(ld_fecha,'rrrrmmdd')) REJECT LIMIT UNLIMITED;
         Commit;
     Exception When Others Then
         lv_merr := substr(sqlerrm,1,500);
         Insert into log_carga(fecha,feceje,tabla,msgerr,valor1,valor2,vvalor1)
         values(ld_fecha,sysdate,'FACT_PASIVO',lv_merr,PN_CODSUC,PN_TOPE,PV_RUBRO);
         commit;
     End;          
         
     Begin
         Update log_jobs set fecfin = sysdate
          Where valor1=PN_CODSUC and  valor2 = PN_TOPE and vvalor1 = PV_RUBRO
            and fecha = ld_fecha;
         Commit;
     Exception When Others Then
         Null;
     End;
         
 End sp_fact_pasivas_new;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_fact_pasivas(PN_CTAINI In Number,PN_CTAFIN In Number,
                           PN_AGETES In Number,PV_FECHA In Varchar2)
 Is
   ld_Fecha date := to_date(PV_FECHA,'RRRRMMDD');
 BEGIN
         INSERT INTO FACT_PASIVO
        (
          tiempo_key      , cuentas_key , cliente_key, 
          geografia_key   , fecha_ultdep, rubro_key, 
          producto_key    , moneda_key  , tipo_tarifario_key, 
          tipo_tasa_key   , campania_key, empleador_key, 
          asesor_key      , estado_key  , menor_edad, 
          tasa            , plazo       , tipo_cambio, 
          segmento_cli_key, geografia_cli_key, tipo_cliente_key, 
          saldo_mn        , saldo_mo, 
          saldo_int_mn    , saldo_int_mo, 
          saldo_dis_mn    , saldo_dis_mo, 
          saldo_pro_mn    , saldo_pro_mo, 
          saldo_gar_mn    , saldo_gar_mo, 
          imp_ape_mn      , imp_ape_mo, 
          imp_ren_mn      , imp_ren_mo, 
          imp_blo_mn      , imp_blo_mo, 
          int_gen_mn      , int_gen_mo, 
          fac_tpo_mn      , fac_tpo_mo, 
          cli_retenido    , cli_retenido_aho, cli_retenido_cts, 
          cli_retenido_dpf, cli_retenido_bi,
          gasto_fin_mn    , gasto_fin_mo,
          geografia_pas_key,ind_empbco, ind_dosrub,
          imp_fsd, int_fsd, gar_fsd, dii_fsd,ind_fsd,
          key_seg_cta
          
        )
        Select t.tiempo_key    , c.cuentas_key          , cl.cliente_key,
               g.geografia_key , p.fecha_ultimo_deposito, r.rubro_key,
               s.producto_key  , m.moneda_key           , tt.tipo_tarifario_key,
               ta.tipo_tasa_key,                     0  , em.empleador_key,
               ej.asesor_key   , es.estado_key          , p.identificador_menor_edad,
               to_number(p.tasa_interes)  , to_number(p.plazo)     , to_number(p.tipo_cambio),
               sg.segmento_key , gc.geografia_key       , tc.tipo_cliente_key,
               nvl(p.saldo_mn,0), nvl(p.saldo_mo,0)             , 
               decode(p.aomda,0,nvl(p.saldo_intangible,0),nvl(p.saldo_intangible,0)*to_number(p.tipo_cambio)),
               nvl(p.saldo_intangible,0),
               decode(p.aomda,0,nvl(p.saldo_disponible,0),nvl(p.saldo_disponible,0)*to_number(p.tipo_cambio)),
               nvl(p.saldo_disponible,0),
               decode(p.aomda,0,nvl(p.saldo_promedio,0),nvl(p.saldo_promedio,0)*to_number(p.tipo_cambio)),
               nvl(p.saldo_promedio,0),
               decode(p.aomda,0,nvl(p.saldo_garantia,0),nvl(p.saldo_garantia,0)*to_number(p.tipo_cambio)),
               nvl(p.saldo_garantia,0),
               decode(p.aomda,0,nvl(p.imp_apertura,0),nvl(p.imp_apertura,0)*to_number(p.tipo_cambio)),
               nvl(p.imp_apertura,0),
               decode(p.aomda,0,nvl(p.imp_renovacion,0),nvl(p.imp_renovacion,0)*to_number(p.tipo_cambio)),
               nvl(p.imp_renovacion,0),
               decode(p.aomda,0,nvl(p.imp_bloqueado,0),nvl(p.imp_bloqueado,0)*to_number(p.tipo_cambio)),
               nvl(p.imp_bloqueado,0),
               decode(p.aomda,0,nvl(p.interes_generado,0),nvl(p.interes_generado,0)*to_number(p.tipo_cambio)),
               nvl(p.interes_generado,0),
               nvl(p.saldo_mn,0) * to_number(p.tasa_interes),
               nvl(p.saldo_mo,0) * to_number(p.tasa_interes),
               p.cliente_retenido    , p.cliente_retenido_aho, p.cliente_retenido_cts,
               p.cliente_retenido_dpf, p.cliente_retenido_bi,
               decode(p.aomda,0,nvl(p.gasto_financ,0),nvl(p.gasto_financ,0)*to_number(p.tipo_cambio)),
               p.gasto_financ,
               decode(p.tipo_region,'T',PN_AGETES,g.geografia_key),
               p.ind_empbco,p.ind_dosrub,
               nvl(p.imp_fsd,0), nvl(p.int_fsd,0), nvl(p.gar_fsd,0), nvl(p.dii_fsd,0), nvl(p.ind_fsd,0),
               p.key_seg_cta
          From dwstage.tmp_fact_pasivo p
          Join dwhouse.dm_tiempo t 
            On t.fecha = p.fecha 
          Join dwhouse.dm_cuentas c
            On c.codigo_cuenta = p.codigo_cuenta
           And c.cuenta_unica  = p.cuenta_unica   
          Join dwhouse.dm_cliente cl
            On cl.codigo_cliente = p.codigo_cliente 
          Join dwhouse.dm_geografia g
            On g.codigo_agencia = p.codigo_agencia
           And g.tipo_region = p.tipo_region
          Join dwhouse.dm_rubro r 
            On r.codigo_rubro = p.codigo_rubro  
          Join dwhouse.dm_producto s
            On s.codigo_producto    = p.codigo_producto
           And s.codigo_subproducto = p.codigo_subproducto  
          Join dwhouse.dm_tipo_tarifario tt 
            On tt.codigo_tipo_tarifario = p.codigo_tipo_tarifario
          Join dwhouse.dm_moneda m
            On m.codigo_moneda = p.codigo_moneda
          Join dwhouse.dm_tipo_tasa ta 
            On ta.codigo_tipo_tasa = p.codigo_tipo_tasa
          Join dwhouse.dm_empleador em
            On em.codigo_empleador = p.codigo_empleador   
          Join dwhouse.dm_asesor ej
            On ej.codigo_asesor = p.codigo_asesor 
          Join dwhouse.dm_estado es
            On es.codigo_estado = p.codigo_estado 
          Join dwhouse.dm_segmento sg
            On sg.codigo_segmento = nvl(p.segmento_clie,'0')
          Join dwhouse.dm_geografia gc
            On gc.codigo_agencia = nvl(p.agencia_clie,'11')
           And gc.tipo_region    = nvl(p.tipo_reg_clie,'R')  
          Join dwhouse.dm_tipo_cliente tc
            On tc.tipo_cliente_codigo = p.tipo_cliente     
         Where t.fecha = ld_fecha
           and p.aocta Between PN_CTAINI and PN_CTAFIN
           and not (p.codigo_producto in ('11','221') or 
                    (p.codigo_cuenta like '156%' and p.saldo_mn = 0) or
                    (r.codigo_rubro like '21_70201%')
                   )
         LOG ERRORS INTO ERR$_FACT_PASIVO ('INSERT-' || to_char(ld_fecha,'rrrrmmdd')) REJECT LIMIT UNLIMITED;
         Commit;
            
 End sp_fact_pasivas;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Procedure sp_fsd_anexo17A (PD_FECHA In Date)
Is
Begin
     -- Elimina Registros
     Begin
         Delete from fact_fsd_anexos Where fecha = PD_FECHA;
         Commit;
     Exception When Others Then
        Null;
     End;
     
     -- Inserta Registros
     Insert Into fact_fsd_anexos(tiempo_key,fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                 imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,ind_proceso,tipo_cambio)  
      select t.tiempo_key,f.fecha,f.cod_anexo,f.ord_conane,f.rub_conane,f.des_conane,
             f.imp_soles,f.imp_dolar,f.cta_soles,f.cta_dolar,f.cta_nueva,f.ind_proceso,f.imp_tcam  
        from dwstage.tmp_fact_fsd_anexos f
        join dwhouse.dm_tiempo t on t.fecha=f.fecha
       where f.fecha = PD_FECHA;
     Commit;
Exception When Others Then
    Null;
End;           
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
Procedure sp_fact_base_Anexo17A(PD_FECHA In Date)
Is
Begin
    -- Elimina Registros
    Begin
       Delete From fact_fsd_ctasclie o Where o.fecha = PD_FECHA;
       Commit;
    Exception When Others Then
       Null;
    End;
    
    -- Carga Colaboradores
    Begin
    pq_carga_facts.fact_fsd_colabco(PD_FECHA);
    Exception When Others Then
       Null;
    End;
    
    -- Carga Datos 
    Insert /*+ APPEND PARALELL(5)*/
    into fact_fsd_ctasclie(cliente_key, fecha, tiempo_key, pais, tdoc, ndoc, 
                                  cod_cliente, nom_cliente, cuentas_key, 
                                  aomda, aomod, aocta, aoope, aosbo, aotop, 
                                  key_segcta, abr_segcta, fec_apertura, num_titcta, dia_ape, num_dias, 
                                  saldo_mo, intgen_mon, salgar_mo, p_impsaldo, p_impinter, p_impgaran, 
                                  p_imp_fsd, p_int_fsd, p_gar_fsd, p_dii_fsd, ind_empbco, ind_dosrub, ind_estado, 
                                  cod_rubro, imp_tcam, imp_lfsd, sld_pdis, int_pdis, gar_pdis, sld_pdnc, int_pdnc, 
                                  gar_pdnc, sld_dtot, int_dtot, gar_dtot, cod_mdes, 
                                  sldc_fsd, intc_fsd, garc_fsd, sldn_fsd, intn_fsd, 
                                  garn_fsd, sldt_fsd, intt_fsd, gart_fsd, sld_anxs, 
                                  cod_denanx, moneda_key,int_anxs,gar_anxs,
                                  sld_anxc,int_anxc,gar_anxc,sld_anxn,int_anxn,gar_anxn,ind_tipcli
                                  ,key_motdes,ind_colemp
                                 ) 

    Select l.cliente_key,f.fecha,t.tiempo_key,f.pais,f.tdoc,f.ndoc,
           f.cod_cliente, nom_cliente,nvl(cuentas_key,1404121192) cuentas_key, 
           aomda,aomod,aocta,aoope,aosbo,aotop, 
           nvl(key_segcta,1) key_segcta, abr_segcta,fec_apertura,num_titcta, 
           dia_ape,num_dias,saldo_mo,intgen_mon,salgar_mo, 
           p_impsaldo,p_impinter,p_impgaran,p_imp_fsd,p_int_fsd,p_gar_fsd,p_dii_fsd, 
           ind_empbco,ind_dosrub,ind_estado,cod_rubro,imp_tcam,imp_lfsd,sld_pdis,int_pdis, 
           gar_pdis,sld_pdnc,int_pdnc,gar_pdnc,sld_dtot,int_dtot,gar_dtot,nvl(cod_mdes,'C00') cod_mdes,
           sldc_fsd,intc_fsd,garc_fsd,sldn_fsd,intn_fsd,garn_fsd,sldt_fsd,intt_fsd,gart_fsd, 
           nvl(sld_anxs,0) sld_anxs, nvl(cod_denanx,0) cod_denanx,m.moneda_key,nvl(f.int_anxs,0),
           nvl(f.gar_anxs,0),nvl(f.sld_anxc,0),nvl(f.int_anxc,0),nvl(f.gar_anxc,0),
           nvl(f.sld_anxn,0),nvl(f.int_anxn,0),nvl(f.gar_anxn,0),f.ind_tipcli,
           d.key_motdes,f.ind_colcaj
     from dwstage.tmp_tfact_fsd_clie f
     left join dwhouse.dm_cliente l on l.codigo_cliente=f.cod_cliente
     left Join dwhouse.dm_tiempo t on nvl(t.fecha,PD_FECHA)= f.fecha
     left Join dwhouse.dm_moneda m on m.codigo_moneda = to_char(f.aomda)
     left join dwhouse.dm_fsd_motdes d on nvl(d.cod_motdes,'C99') = f.cod_mdes
    Where t.fecha = PD_FECHA;
    
    Commit;
Exception When Others Then
   Null;
End;            
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
Procedure sp_saldos_his_fsd(PD_FECHA In Date)
Is 
  cursor cursor_p (ld_fec In Date) 
      is select * from dwstage.tmp_fpasivo_fsd
           where fecha = ld_fec;
  lv_query varchar2(500);      
  ld_fecha date := PD_FECHA;   
Begin
    For T in cursor_p(ld_fecha) loop
        lv_query := 'update dwhouse.fact_pasivo partition(FACT_PASIVO_'||to_char(ld_fecha,'rrrrmmdd')||
                      ') set int_fsd=:1,'||
                            'imp_fsd=:2,';
        IF t.aomod=21 and t.aotop=2 THEN
           lv_query := lv_query||'int_gen_mo= :3,'||
                                    'gar_fsd= :4,'||
                                    'dii_fsd= :5,'||
                                   'ind_fsd = :6,'||
                               'key_seg_cta = :7,'||
                                'ind_dosrub = :8,'||
                                'ind_empbco = :9 '||
                          'where tiempo_key = :10 '||
                            'and cuentas_key= :11';
            Execute Immediate lv_query Using nvl(t.int_fsd,0),nvl(t.imp_fsd,0),nvl(t.int_gen_mo,0),
                                            nvl(t.gar_fsd,0),nvl(t.dii_fsd,0),t.ind_fsd,t.seg_key,
                                            nvl(t.ind_dosrub,1),nvl(t.ind_empbco,0),t.tiempo_key,t.cuentas_key;
        Else
          lv_query := lv_query||'gar_fsd=:3,'||
                                'dii_fsd=:4,'||
                               'ind_fsd= :5,'||
                              'key_seg_cta = :6,'||
                               'ind_dosrub = :7,'||
                               'ind_empbco = :8 '||
                         'where tiempo_key = :9 '||
                           'and cuentas_key= :10';
          Execute Immediate lv_query Using nvl(t.int_fsd,0),nvl(t.imp_fsd,0),nvl(t.gar_fsd,0),nvl(t.dii_fsd,0),
                                           t.ind_fsd,t.seg_key,
                                           nvl(t.ind_dosrub,1),nvl(t.ind_empbco,0),t.tiempo_key,t.cuentas_key;                 
       End If;
       Commit;
    End loop;
   
End sp_saldos_his_fsd;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Procedure sp_fsd_obligaciones(PD_FECHA In Date)
Is
   ln_tiempo number(10);
   lv_valor varchar2(5);
   ln_existe number(5);
   ln_TIEMPO_KEY number(10);
Begin
     Select tiempo_key Into ln_tiempo From dm_tiempo Where fecha = PD_FECHA;
     
     Begin	
	         Select valor Into lv_valor
			       From bi_parametro 
			      Where parametro_key = 5;
	   Exception When Others Then
		        lv_valor:= null;
	   End;	
     
     Begin
          SELECT 1 Into ln_existe
            FROM DBA_TAB_PARTITIONS 
           WHERE TABLE_OWNER='DWHOUSE' 
             and table_name='FACT_FSD_OBLIGAC' 
             and partition_name = 'FACT_FSDOBLIG_'||to_char(PD_FECHA,'rrrrmmdd');
     Exception When no_data_found then
           ln_existe :=0;
     End; 
       
     If lv_valor ='R' and ln_existe > 0 Then
        -- ELIMINA PARTICION  
       Execute immediate 'ALTER TABLE FACT_FSD_OBLIGAC DROP PARTITION FACT_FSDOBLIG_'||to_char(PD_FECHA,'rrrrmmdd')||
                          ' update global indexes parallel(degree 4)';
     End If;	      
	
	   If lv_valor in ('R','T') Then
        -- CREA PARTICION 
        Begin
             SELECT 1 Into ln_existe
               FROM DBA_TAB_PARTITIONS 
              WHERE TABLE_OWNER='DWHOUSE' 
                and table_name='FACT_FSD_OBLIGAC' 
                and partition_name = 'FACT_FSDOBLIG_'||to_char(PD_FECHA,'rrrrmmdd');
        Exception When no_data_found then
              ln_existe :=0;
        End;      
        
        IF ln_existe = 0 then
           EXECUTE IMMEDIATE 'alter table FACT_FSD_OBLIGAC add partition FACT_FSDOBLIG_'||
                             to_char(PD_FECHA,'rrrrmmdd')||' values ('||ln_TIEMPO_KEY||') TABLESPACE DWHOUSE_B';   			 
        End if;
	    End If;
	   
      Begin
  
     Insert Into fact_fsd_obligac
     Select a.tiempo_key,a.cliente_key,a.credito_key,a.situacion_key,a.producto_reg_key,a.tipo_credito_key,a.moneda_key,
            a.dias_atraso,a.saldo_capital_mn,a.saldo_capital_mo,a.tipo_cambio,a.aocta,a.aomod,a.aosbo,a.aotop,a.aoope
       From fact_activo  a  
       Join dm_situacion s on s.situacion_key = a.situacion_key
      where a.cliente_key in (
                              Select cliente_key
                                from fact_fsd_ctasclie  
                               Where fecha = PD_FECHA  
                                 and cod_mdes not in ('C10','C20','C30','C40','C60','C99')
                             )
        and estado_key = 1  
        and s.codigo_situacion in ('1401','1402','1404','1405','1406','7102','8103');
     Commit;
Exception When OThers Then
   Null;
   End;
End sp_fsd_obligaciones;            
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
Procedure sp_fact_activas_cancelados(PD_FECHA In Date)
Is
  /*cursor c_ct(ld_ini in date,ld_fin in date)
       is select credito_key,max(fecha) fecha 
            from fact_traslado_activas where fecha between ld_ini and ld_fin
          group by credito_key;*/
          
   cursor c_cman(ld_fec in date, ln_indcan in Number) is
   select y.tiempo_key,y.credito_key,l.tiempoultdiaanioant_key,
          c.fecha_cancelacion, 
          y.aomod,y.aocta,y.aoope,y.aotop,y.aosbo,decode(y.moneda_key,1,0,101) aomda,
          g.codigo_agencia,g.tipo_region
     from fact_activo_cancelados y join dm_tiempo l on l.tiempo_key=y.tiempo_key
     join dm_credito c on c.credito_key = y.credito_key
     join dm_geografia g on g.geografia_key = y.geografia_key
     where l.fecha = ld_fec
       and y.ind_per_cancela=ln_indcan;
  
   
            
   ld_fecha date := PD_FECHA;
   --ld_fiano date := to_Date(to_char(ld_fecha,'rrrr')||'0101','rrrrmmdd');  
   ln_aget number(10);
   ln_anat number(10);
   ln_sdo number(12,2);
   ln_tmp number(10);
   ln_tma number(10);
   --ln_tmpcan Number(10);
   --feccan date;
   lv_ageact Varchar2(10);
   lv_anaact Varchar2(10);
   ln_diaa   Number(5);
   lv_comact Varchar2(50);
   lv_catact Varchar2(5);
   lv_tipact Varchar2(5);
   ln_comc   Number(30);
   ln_cata   Number(10);
   ln_tipa   Number(10);
   ln_sdo_mo Number(12,2);
   ln_sve_mo Number(12,2);
   ln_sve_mn Number(12,2);
   ln_tasa   Number(8,3);
   ln_indn   Number(1);
   ln_tcli   Number(10);
   ld_fecma  Date;
Begin
      -- Fechas
      Select tiempo_key,tiempomesanterior_key,fechamesanterior
        Into ln_tmp,ln_tma,ld_fecma from dm_tiempo where fecha = ld_fecha;
      
      --- Elimina Registros
      Begin
           Delete From fact_activo_cancelados Where tiempo_key = ln_tmp;
           Commit;
      Exception When Others Then
           Null;
      End;
      
      -- Creditos cancelados mes anterior
      Insert Into FACT_ACTIVO_CANCELADOS (tiempo_key, credito_key, rubro_key, producto_key, geografia_key, 
                  analista_key, campania_key, tipo_credito_key, cliente_key, convenio_key, 
                  moneda_key, situacion_key, modalidad_key, agenciabn_key, tiempo_vencimiento_actual, 
                  rango_mora_key, rango_mora_rl_key, frecuencia, plazo, dias_atraso, saldo_capital_mn, 
                  saldo_capital_mo, saldo_capital_mora_mn, saldo_capital_mora_mo,interes_pagado_mn, 
                  interes_pagado_mo, interes_pactado, capital_pagado_mn, capital_pagado_mo, capital_pactado, 
                  tipo_cambio, saldo_interes_diferido, deuda_total, deuda_amortizada, factor_tasa_ponderada_mn, 
                  factor_tasa_ponderada_mo, rentabilidad, tasa_ponderada_mn, tasa_ponderada_mo, porcentaje_mora, 
                  porcentaje_mora_contable, num_cliente, num_cliente_retenido, num_credito, provision_total, 
                  provision_obligatoria, provision_prociclica, provision_generica, provision_especifica, 
                  cantidad_cuota_pagadas, cantidad_cuota_impaga, ranking_cliente, flag_tipo_garantia, 
                  saldo_garantia_inscrita, flag_1, flag_2, flag_3, codigo_situacion, fecha_vencimiento, 
                  categoria_key, saldo_vencido_mo, saldo_vencido_mn, tipo_cliente_key, actividad_economica_key, 
                  producto_reg_key, destino_key, total_linea_mo, total_linea_mn, segmento_key, sectorsbs_key, 
                  fecha_vence_cuota, tasa_interes, imp_k_cuota, imp_i_cuota, deu_k_cuota, deu_i_cuota,tipo_clicaj_key, 
                  imp_desemb, ind_nuevo_mes, inst_origen, imp_utilizado, comite_key, imp_castigo_mo, aomod, 
                  aocta, aoope, aosbo, aotop, segmento_antes_fmes, base_retenido, segmer_key, segtcr_key, 
                  segtc_totseg_key, segtc_tottcr_key, segtc_total_key, segtc_subto_key, segmer_cli_key, 
                  diast_atraso_ini, cartera_heredada, nivel_venta, gastomn_periodo, gastomd_periodo, 
                  revermn_periodo, revermd_periodo, gastomn_cierrea, gastomd_cierrea, revermn_cierrea, 
                  revermd_cierrea, gastomn_anioant, gastomd_anioant, revermn_anioant, revermd_anioant, 
                  categoria_ana_key, catuni_dia_key, improv_dia, catuni_mes_key, improv_mes, ind_casven, 
                  tipo_ana_key, nivelriesgo_key, saldo_mn_ma, saldo_mn_aa, ind_per_cancela,diaatr_ma,diaatr_aa,
                  saldo_mo_ma,Sldven_Mn_Ma,Sldven_Mo_Ma,Tasa_Ma,Ind_Nuevo_Ma,tipcli_ma_key,base_ret_ma,
                  Saldo_Mo_Aa,Sldven_Mn_Aa,Sldven_Mo_Aa,tasa_aa,Ind_Nuevo_Aa,Tipcli_Aa_Key,Base_Ret_Aa,
                  base_cont)
            Select t.tiempo_key ,l.credito_key, l.rubro_key, l.producto_key, l.geografia_key, l.analista_key, l.campania_key, 
                   l.tipo_credito_key, l.cliente_key, l.convenio_key, l.moneda_key, l.situacion_key, l.modalidad_key, l.agenciabn_key, 
                   l.tiempo_vencimiento_actual, l.rango_mora_key, l.rango_mora_rl_key, l.frecuencia, l.plazo, l.dias_atraso, 0 saldo_capital_mn, 
                   0 saldo_capital_mo, 0 saldo_capital_mora_mn, 0 saldo_capital_mora_mo, interes_pagado_mn, interes_pagado_mo, interes_pactado, 
                   capital_pagado_mn, capital_pagado_mo, capital_pactado, tipo_cambio, 0 saldo_interes_diferido, 0 deuda_total, deuda_amortizada, 
                   0 factor_tasa_ponderada_mn, 0 factor_tasa_ponderada_mo, rentabilidad, 0 tasa_ponderada_mn, 0 tasa_ponderada_mo, porcentaje_mora, 
                   porcentaje_mora_contable, 0 num_cliente, 0 num_cliente_retenido,0 num_credito, 0 provision_total, 0 provision_obligatoria, 
                   0 provision_prociclica, 0 provision_generica, 0 provision_especifica, 0 cantidad_cuota_pagadas, 0 cantidad_cuota_impaga, 
                   ranking_cliente, flag_tipo_garantia, 0 saldo_garantia_inscrita, flag_1, flag_2, flag_3, s.codigo_situacion, fecha_vencimiento, 
                   categoria_key, 0 saldo_vencido_mo, 0 saldo_vencido_mn, tipo_cliente_key, actividad_economica_key, producto_reg_key, 
                   destino_key, 0 total_linea_mo, 0 total_linea_mn, segmento_key, sectorsbs_key, fecha_vence_cuota, tasa_interes, imp_k_cuota, 
                   imp_i_cuota, 0 deu_k_cuota, 0 deu_i_cuota, tipo_clicaj_key, imp_desemb, ind_nuevo_mes, inst_origen, 0 imp_utilizado, comite_key, 
                   0 imp_castigo_mo, aomod, aocta, aoope, aosbo, aotop, segmento_antes_fmes, base_retenido, segmer_key, segtcr_key, 
                   segtc_totseg_key, segtc_tottcr_key, segtc_total_key, segtc_subto_key, segmer_cli_key, diast_atraso_ini, cartera_heredada, 
                   nivel_venta, gastomn_periodo, gastomd_periodo, revermn_periodo, revermd_periodo, gastomn_cierrea, gastomd_cierrea, 
                   revermn_cierrea, revermd_cierrea, gastomn_anioant, gastomd_anioant, revermn_anioant, revermd_anioant, categoria_ana_key, 
                   catuni_dia_key, improv_dia, catuni_mes_key, improv_mes, ind_casven, tipo_ana_key, nivelriesgo_key, 
                   l.saldo_capital_mn saldo_mn_ma,
                   0 saldo_mn_aa,
                   1, l.dias_atraso,0,
                   l.saldo_capital_mo,l.saldo_vencido_mn,l.saldo_vencido_mo,l.tasa_interes,l.ind_nuevo_mes,l.tipo_cliente_key,'N',
                   0,0,0,0,0,959,'N',
                   Case when to_char(last_day(ld_fecha),'dd') = '28' and l.dias_atraso between 3 and 30 Then 1
                        when to_char(last_day(ld_fecha),'dd') = '29' and l.dias_atraso between 2 and 30 Then 1
                        when to_char(last_day(ld_fecha),'dd') = '30' and l.dias_atraso between 1 and 30 Then 1 
                        when to_char(last_day(ld_fecha),'dd') = '31' and 
                             ((l.dias_atraso between 1 and 30) Or (l.fecha_vence_cuota = ld_fecma))
                        Then 1    
                        Else 0
                    End indcon  
               From fact_activo l
               Join dm_tiempo t on t.tiempomesanterior_key = l.tiempo_key
               Join dm_situacion s on s.situacion_key = l.situacion_key
             Where t.fecha = ld_fecha
               and not exists (select 1 from fact_activo o 
                                where o.credito_key = l.credito_key
                                  and o.tiempo_key = ln_tmp)
               and s.nombre_situacion not in ('Carta Fianza', 'Resp.Línea Crédito')
               and nvl(l.estado_key,0) <> 72;
            Commit;          

--- INSERTA CANCELADOS AÑO ANTERIOR
Insert Into FACT_ACTIVO_CANCELADOS (tiempo_key, credito_key, rubro_key, producto_key, geografia_key, 
                  analista_key, campania_key, tipo_credito_key, cliente_key, convenio_key, 
                  moneda_key, situacion_key, modalidad_key, agenciabn_key, tiempo_vencimiento_actual, 
                  rango_mora_key, rango_mora_rl_key, frecuencia, plazo, dias_atraso, saldo_capital_mn, 
                  saldo_capital_mo, saldo_capital_mora_mn, saldo_capital_mora_mo,interes_pagado_mn, 
                  interes_pagado_mo, interes_pactado, capital_pagado_mn, capital_pagado_mo, capital_pactado, 
                  tipo_cambio, saldo_interes_diferido, deuda_total, deuda_amortizada, factor_tasa_ponderada_mn, 
                  factor_tasa_ponderada_mo, rentabilidad, tasa_ponderada_mn, tasa_ponderada_mo, porcentaje_mora, 
                  porcentaje_mora_contable, num_cliente, num_cliente_retenido, num_credito, provision_total, 
                  provision_obligatoria, provision_prociclica, provision_generica, provision_especifica, 
                  cantidad_cuota_pagadas, cantidad_cuota_impaga, ranking_cliente, flag_tipo_garantia, 
                  saldo_garantia_inscrita, flag_1, flag_2, flag_3, codigo_situacion, fecha_vencimiento, 
                  categoria_key, saldo_vencido_mo, saldo_vencido_mn, tipo_cliente_key, actividad_economica_key, 
                  producto_reg_key, destino_key, total_linea_mo, total_linea_mn, segmento_key, sectorsbs_key, 
                  fecha_vence_cuota, tasa_interes, imp_k_cuota, imp_i_cuota, deu_k_cuota, deu_i_cuota,tipo_clicaj_key, 
                  imp_desemb, ind_nuevo_mes, inst_origen, imp_utilizado, comite_key, imp_castigo_mo, aomod, 
                  aocta, aoope, aosbo, aotop, segmento_antes_fmes, base_retenido, segmer_key, segtcr_key, 
                  segtc_totseg_key, segtc_tottcr_key, segtc_total_key, segtc_subto_key, segmer_cli_key, 
                  diast_atraso_ini, cartera_heredada, nivel_venta, gastomn_periodo, gastomd_periodo, 
                  revermn_periodo, revermd_periodo, gastomn_cierrea, gastomd_cierrea, revermn_cierrea, 
                  revermd_cierrea, gastomn_anioant, gastomd_anioant, revermn_anioant, revermd_anioant, 
                  categoria_ana_key, catuni_dia_key, improv_dia, catuni_mes_key, improv_mes, ind_casven, 
                  tipo_ana_key, nivelriesgo_key, saldo_mn_ma, saldo_mn_aa, ind_per_cancela,Diaatr_Ma,Diaatr_Aa,
                  base_cont,saldo_mo_ma,Sldven_Mn_Ma,Sldven_Mo_Ma,Tasa_Ma,Ind_Nuevo_Ma,tipcli_ma_key,base_ret_ma,
                  Saldo_Mo_Aa,Sldven_Mn_Aa,Sldven_Mo_Aa,tasa_aa,Ind_Nuevo_Aa,Tipcli_Aa_Key,Base_Ret_Aa)
          Select t.tiempo_key ,l.credito_key, l.rubro_key, l.producto_key, l.geografia_key, l.analista_key, l.campania_key, 
                 l.tipo_credito_key, l.cliente_key, l.convenio_key, l.moneda_key, l.situacion_key, l.modalidad_key, l.agenciabn_key, 
                 l.tiempo_vencimiento_actual, l.rango_mora_key, l.rango_mora_rl_key, l.frecuencia, l.plazo, l.dias_atraso, 0 saldo_capital_mn, 
                 0 saldo_capital_mo, 0 saldo_capital_mora_mn, 0 saldo_capital_mora_mo, interes_pagado_mn, interes_pagado_mo, interes_pactado, 
                 capital_pagado_mn, capital_pagado_mo, capital_pactado, tipo_cambio, 0 saldo_interes_diferido, 0 deuda_total, deuda_amortizada, 
                 0 factor_tasa_ponderada_mn, 0 factor_tasa_ponderada_mo, rentabilidad, 0 tasa_ponderada_mn, 0 tasa_ponderada_mo, porcentaje_mora, 
                 porcentaje_mora_contable, 0 num_cliente, 0 num_cliente_retenido,0 num_credito, 0 provision_total, 0 provision_obligatoria, 
                 0 provision_prociclica, 0 provision_generica, 0 provision_especifica, 0 cantidad_cuota_pagadas, 0 cantidad_cuota_impaga, 
                 ranking_cliente, flag_tipo_garantia, 0 saldo_garantia_inscrita, flag_1, flag_2, flag_3, s.codigo_situacion, fecha_vencimiento, 
                 categoria_key, 0 saldo_vencido_mo, 0 saldo_vencido_mn, tipo_cliente_key, actividad_economica_key, producto_reg_key, 
                 destino_key, 0 total_linea_mo, 0 total_linea_mn, segmento_key, sectorsbs_key, fecha_vence_cuota, tasa_interes, imp_k_cuota, 
                 imp_i_cuota, 0 deu_k_cuota, 0 deu_i_cuota, tipo_clicaj_key, imp_desemb, ind_nuevo_mes, inst_origen, 0 imp_utilizado, comite_key, 
                 0 imp_castigo_mo, aomod, aocta, aoope, aosbo, aotop, segmento_antes_fmes, base_retenido, segmer_key, segtcr_key, 
                 segtc_totseg_key, segtc_tottcr_key, segtc_total_key, segtc_subto_key, segmer_cli_key, diast_atraso_ini, cartera_heredada, 
                 nivel_venta, gastomn_periodo, gastomd_periodo, revermn_periodo, revermd_periodo, gastomn_cierrea, gastomd_cierrea, 
                 revermn_cierrea, revermd_cierrea, gastomn_anioant, gastomd_anioant, revermn_anioant, revermd_anioant, categoria_ana_key, 
                 catuni_dia_key, improv_dia, catuni_mes_key, improv_mes, ind_casven, tipo_ana_key, nivelriesgo_key, 
                 0 saldo_mn_ma, 
                 l.saldo_capital_mn saldo_mn_aa,
                 2,0,l.dias_atraso,
                 0,0,0,0,0,0,959,'N',
                 l.saldo_capital_mo,l.saldo_vencido_mn,l.saldo_vencido_mo,l.tasa_interes,l.ind_nuevo_mes,l.tipo_cliente_key,'N'
             From fact_activo l
             Join dm_tiempo t on t.tiempoultdiaanioant_key = l.tiempo_key
             Join dm_situacion s on s.situacion_key = l.situacion_key
           Where t.fecha = ld_fecha
             and not exists (select 1 from fact_activo o where o.credito_key = l.credito_key
                             and o.tiempo_key in (ln_tmp,ln_tma))
             and s.nombre_situacion not in ('Carta Fianza', 'Resp.Línea Crédito')
             and nvl(l.estado_key,0) <> 72;
          Commit;

   -- Analista y Agencia Actuales del mes anterior
   For x in c_cman(ld_fecha,1) Loop
       lv_ageact := nvl(dwstage.pq_tmp_carga_facts.fn_agencia_actual(x.aomod,x.aomda,0,x.aocta,x.aoope,x.aosbo,x.aotop),x.codigo_agencia);
       If x.aomod = 108 then
          lv_anaact := dwstage.pq_tmp_carga_facts.fn_tazador_cred_pren(x.aomod,lv_ageact,x.aomda,0,x.aocta,x.aoope,x.aosbo,x.aotop);
          --lv_anaact := '0';
       Else   
          lv_anaact := nvl(dwstage.pq_tmp_carga_facts.fn_analista_credito_facts(x.aomod,lv_ageact,x.aomda,0,x.aocta,x.aoope,x.aosbo,x.aotop,PD_FECHA,0),'0');                         
       End If;
       
       
       lv_comact := dwstage.pq_tmp_carga_facts.fn_comite_credito(lv_anaact,to_number(lv_ageact),ld_fecha);
       lv_catact := dwstage.pq_tmp_carga_facts.fn_cartegoria_ana(lv_anaact,ld_fecha);
       lv_tipact := dwstage.pq_tmp_carga_facts.fn_tipo_ana(lv_anaact,ld_fecha);                                          
                           
       Select geografia_key Into ln_aget From dm_geografia where codigo_agencia = lv_ageact and tipo_region=x.tipo_region;
       Select analista_key Into ln_anat From dm_analista where codigo_analista = lv_anaact;
       Select c.comite_key Into ln_comc From dm_comite_credito c Where c.comite_cod = lv_comact;
       Select k.categoria_ana_key Into ln_cata From dm_categoria_ana k Where k.codigo_categoria_ana = lv_catact;       
       Select t.tipo_ana_key Into ln_tipa from dm_tipo_ana t where t.codigo_tipo_ana = lv_tipact;
       
       
       Begin
           Select saldo_capital_mn,i.dias_atraso,
                  i.saldo_capital_mo,i.saldo_vencido_mo,i.saldo_vencido_mn,
                  i.tasa_interes,i.ind_nuevo_mes,i.tipo_cliente_key 
             Into ln_sdo, ln_diaa,
                  ln_sdo_mo, ln_sve_mo, ln_sve_mn, ln_tasa, ln_indn, ln_tcli
             From fact_activo i
            Where credito_key = x.credito_key
              and tiempo_key = x.tiempoultdiaanioant_key;
       Exception When Others Then
                 ln_sdo := 0;
                 ln_diaa:= 0;
                 ln_sdo_mo := 0; 
                 ln_sve_mo := 0;
                 ln_sve_mn := 0;
                 ln_tasa   := 0;
                 ln_indn   := 0;
                 ln_tcli   := 959;
       End;
               
       Update dwhouse.fact_activo_cancelados i
             set i.geografia_key = ln_aget,
                 i.analista_key  = ln_anat,
                 i.saldo_mn_aa   = ln_sdo,
                 i.diaatr_aa     = ln_diaa,
                 i.comite_key    = ln_comc,
                 i.categoria_ana_key = ln_cata,
                 i.tipo_ana_key  = ln_tipa,
                 i.saldo_mo_aa   = ln_sdo_mo,
                 i.sldven_mn_aa  = ln_sve_mn,
                 i.sldven_mo_aa  = ln_sve_mo,
                 i.tasa_aa       = ln_tasa  ,
                 i.ind_nuevo_aa  = ln_indn  ,
                 i.tipcli_aa_key = ln_tcli  
          Where i.tiempo_key = x.tiempo_key
           and i.credito_key = x.credito_key;
          Commit;
   End Loop;
   
   -- Analista y Agencia Actuales del año anterior
   For x in c_cman(ld_fecha,2) Loop
       lv_ageact := nvl(dwstage.pq_tmp_carga_facts.fn_agencia_actual(x.aomod,x.aomda,0,x.aocta,x.aoope,x.aosbo,x.aotop),x.codigo_agencia);
       If x.aomod = 108 then
           lv_anaact := dwstage.pq_tmp_carga_facts.fn_tazador_cred_pren(x.aomod,lv_ageact,x.aomda,0,x.aocta,x.aoope,x.aosbo,x.aotop);
           --lv_anaact := '0';
       Else   
          lv_anaact := nvl(dwstage.pq_tmp_carga_facts.fn_analista_credito_facts(x.aomod,lv_ageact,x.aomda,0,x.aocta,x.aoope,x.aosbo,x.aotop,PD_FECHA,0),'0');                         
       End If;
       
       
       lv_comact := dwstage.pq_tmp_carga_facts.fn_comite_credito(lv_anaact,to_number(lv_ageact),ld_fecha);
       lv_catact := dwstage.pq_tmp_carga_facts.fn_cartegoria_ana(lv_anaact,ld_fecha);
       lv_tipact := dwstage.pq_tmp_carga_facts.fn_tipo_ana(lv_anaact,ld_fecha);                                          
                           
       Select geografia_key Into ln_aget From dm_geografia where codigo_agencia = lv_ageact and tipo_region=x.tipo_region;
       Select analista_key Into ln_anat From dm_analista where codigo_analista = lv_anaact;
       Select c.comite_key Into ln_comc From dm_comite_credito c Where c.comite_cod = lv_comact;
       Select k.categoria_ana_key Into ln_cata From dm_categoria_ana k Where k.codigo_categoria_ana = lv_catact;       
       Select t.tipo_ana_key Into ln_tipa from dm_tipo_ana t where t.codigo_tipo_ana = lv_tipact;
               
       Update dwhouse.fact_activo_cancelados i
             set i.geografia_key = ln_aget,
                 i.analista_key  = ln_anat,
                 i.comite_key    = ln_comc,
                 i.categoria_ana_key = ln_cata,
                 i.tipo_ana_key  = ln_tipa
          Where i.tiempo_key = x.tiempo_key
           and i.credito_key = x.credito_key;
          Commit;
   End Loop;
   
End sp_fact_activas_cancelados;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Procedure sp_fact_analista(PD_FECHA in Date)
 Is
   ln_tiempo Number(10);
 Begin
      -- Tiempo
      Begin
         Select tiempo_key Into ln_tiempo
           From dm_tiempo Where fecha = PD_FECHA;
      Exception When Others Then
         Null;
      End;
      
      -- Elimina registros   
      Begin
         Delete from fact_analista Where tiempo_key = ln_tiempo;
         Commit;
      Exception When Others Then
         Null;
      End;   
      
      -- Inserta Datos
      Insert Into fact_analista(tiempo_key,analista_key,geografia_key,comite_key,
                                credito_key,tiempo_des_key,tipana_key,catana_key,tipo_credito_key)
                        select p.tiempo_key,p.analista_key,p.geografia_key,k.comite_key,
                               p.credito_key,p.tiempo_des_key,a.tipo_ana_key,c.categoria_ana_key,
                               p.tipo_credito_key    
                          from dwstage.tmp_fact_analista p
                          join dwhouse.dm_tipo_ana a
                            on a.codigo_tipo_ana = p.codigo_tipo_ana
                          join dwhouse.dm_categoria_ana c
                            on c.codigo_categoria_ana = p.codigo_categoria_ana
                          join dwhouse.dm_comite_credito k
                            on k.comite_cod = p.cod_comite  
                         where p.tiempo_key = ln_tiempo;
      Commit;
 Exception When Others Then
    Null;
 End sp_fact_analista;                        
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
Procedure sp_ins_fact_activo_cancelados(PD_FECHA In Date)
-- Modificación --------------------------------------------------
-- Fecha : 2019.11.20
-- Autor : Paola Vargas
-- Cambio: Inserta provisión, comisión, ingreso del mes anterior 
------------------------------------------------------------------
Is
   ln_tiempo Number(10);
   ln_job Number(5);
Begin
     Select tiempo_key Into ln_tiempo From dm_tiempo where Fecha = PD_FECHA;
     Delete from fact_activo where estado_key=72 and tiempo_key = ln_tiempo;
     
     -- Revisar si finalizo Job
     Loop
        Select count(*) Into ln_job 
          From dba_scheduler_jobs 
         Where owner = 'DWSTAGE' and job_name like 'FACT_ANAAGE_ACT_%';
     Exit When ln_job = 0;
     End Loop;    
     
     Insert Into fact_activo(row_id, tiempo_key, credito_key, rubro_key, producto_key, 
                             geografia_key, analista_key, campania_key, tipo_credito_key, 
                             cliente_key, convenio_key, moneda_key, situacion_key, 
                             modalidad_key, agenciabn_key, tiempo_vencimiento_actual, 
                             rango_mora_key, rango_mora_rl_key, frecuencia, plazo, dias_atraso, 
                             saldo_capital_mn, saldo_capital_mo, saldo_capital_mora_mn, 
                             saldo_capital_mora_mo, interes_pagado_mn, interes_pagado_mo, 
                             interes_pactado, capital_pagado_mn, capital_pagado_mo, capital_pactado, 
                             tipo_cambio, saldo_interes_diferido, deuda_total, deuda_amortizada, 
                             factor_tasa_ponderada_mn, factor_tasa_ponderada_mo, rentabilidad, 
                             tasa_ponderada_mn, tasa_ponderada_mo, porcentaje_mora, 
                             porcentaje_mora_contable, num_cliente, num_cliente_retenido, 
                             num_credito, provision_total, provision_obligatoria, provision_prociclica, 
                             provision_generica, provision_especifica, cantidad_cuota_pagadas, 
                             cantidad_cuota_impaga, ranking_cliente, flag_tipo_garantia, 
                             saldo_garantia_inscrita, flag_1, flag_2, flag_3, codigo_situacion, 
                             fecha_vencimiento, categoria_key, saldo_vencido_mo, saldo_vencido_mn, 
                             tipo_cliente_key, actividad_economica_key, producto_reg_key, 
                             destino_key, total_linea_mo, total_linea_mn, segmento_key, sectorsbs_key, 
                             fecha_vence_cuota, tasa_interes, imp_k_cuota, imp_i_cuota, deu_k_cuota, 
                             deu_i_cuota, tipo_clicaj_key,imp_desemb, ind_nuevo_mes, inst_origen, 
                             imp_utilizado, comite_key, imp_castigo_mo, aomod, aocta, aoope, aosbo, 
                             aotop, segmento_antes_fmes, base_retenido, segmer_key, segtcr_key, 
                             segtc_totseg_key, segtc_tottcr_key,segtc_total_key, segtc_subto_key, 
                             segmer_cli_key, diast_atraso_ini, cartera_heredada, nivel_venta, 
                             gastomn_periodo, gastomd_periodo, revermn_periodo, revermd_periodo, 
                             gastomn_cierrea, gastomd_cierrea, revermn_cierrea, revermd_cierrea, 
                             gastomn_anioant, gastomd_anioant, revermn_anioant, revermd_anioant, 
                             categoria_ana_key, catuni_dia_key, improv_dia, catuni_mes_key, 
                             improv_mes, ind_casven, tipo_ana_key, nivelriesgo_key, saldo_mn_ma, 
                             saldo_mn_aa, situacion_ma_key, situacion_aa_key, diaatr_ma, diaatr_aa, 
                             base_cont, dia_saldo, estado_key, analista_act_key, geografia_act_key, 
                             comite_act_key, tipana_act_key, catana_act_key, saldo_mo_ma, 
                             sldven_mn_ma, sldven_mo_ma, tasa_ma, ind_nuevo_ma, tipcli_ma_key, 
                             base_ret_ma, saldo_mo_aa, sldven_mn_aa,sldven_mo_aa, tasa_aa, 
                             ind_nuevo_aa, tipcli_aa_key,base_ret_aa, tasa_int_ma, tasa_int_aa,
                             -- M:2019.11.19
                             imp_ingreso_mn_ma, imp_comisio_mn_ma, imp_ingccas_mn_ma,
                             imp_proesp_mn_ma , imp_proobl_mn_ma , imp_propro_mn_ma, 
                             imp_provol_mn_ma , imp_progso_mn_ma ,imp_revpro_mn_ma
                             -- M:2019.11.19
                            )
                      SELECT dwhouse.seq_fact_activo.nextval, 
                             tiempo_key, credito_key, rubro_key, producto_key, geografia_key, 
                             analista_key, campania_key, tipo_credito_key, cliente_key, convenio_key, 
                             moneda_key, situacion_key, modalidad_key, agenciabn_key,tiempo_vencimiento_actual, 
                             rango_mora_key, rango_mora_rl_key, frecuencia, plazo, dias_atraso, 
                             saldo_capital_mn, saldo_capital_mo, saldo_capital_mora_mn, 
                             saldo_capital_mora_mo, interes_pagado_mn, interes_pagado_mo, 
                             interes_pactado, capital_pagado_mn, capital_pagado_mo, capital_pactado, 
                             tipo_cambio, saldo_interes_diferido, deuda_total, deuda_amortizada, 
                             factor_tasa_ponderada_mn, factor_tasa_ponderada_mo, rentabilidad, 
                             tasa_ponderada_mn, tasa_ponderada_mo, porcentaje_mora, porcentaje_mora_contable, 
                             num_cliente, num_cliente_retenido, num_credito, provision_total, 
                             provision_obligatoria, provision_prociclica, provision_generica, 
                             provision_especifica, cantidad_cuota_pagadas, cantidad_cuota_impaga, 
                             ranking_cliente, flag_tipo_garantia, saldo_garantia_inscrita, 
                             flag_1, flag_2, flag_3, codigo_situacion, fecha_vencimiento, 
                             categoria_key, saldo_vencido_mo, saldo_vencido_mn, tipo_cliente_key, 
                             actividad_economica_key, producto_reg_key, destino_key, total_linea_mo, 
                             total_linea_mn, segmento_key, sectorsbs_key, fecha_vence_cuota, 
                             tasa_interes, imp_k_cuota, imp_i_cuota, deu_k_cuota, deu_i_cuota, 
                             tipo_clicaj_key, imp_desemb, ind_nuevo_mes, inst_origen, 
                             imp_utilizado, comite_key, imp_castigo_mo, aomod, aocta, aoope, 
                             aosbo, aotop, segmento_antes_fmes, base_retenido, segmer_key, 
                             segtcr_key, segtc_totseg_key, segtc_tottcr_key, segtc_total_key, 
                             segtc_subto_key, segmer_cli_key, diast_atraso_ini, cartera_heredada, 
                             nivel_venta, gastomn_periodo, gastomd_periodo, revermn_periodo, 
                             revermd_periodo, gastomn_cierrea, gastomd_cierrea, revermn_cierrea, 
                             revermd_cierrea, gastomn_anioant, gastomd_anioant, revermn_anioant, 
                             revermd_anioant, categoria_ana_key, catuni_dia_key, improv_dia, 
                             catuni_mes_key, improv_mes, ind_casven, tipo_ana_key, nivelriesgo_key, 
                             saldo_mn_ma, saldo_mn_aa, situacion_ma_key, situacion_aa_key, 
                             diaatr_ma, diaatr_aa, base_cont, to_number(to_char(PD_FECHA,'DD')), 
                             estado_key, analista_act_key, geografia_act_key, comite_act_key, 
                             tipana_act_key, catana_act_key, saldo_mo_ma, sldven_mn_ma, 
                             sldven_mo_ma, tasa_ma, ind_nuevo_ma, tipcli_ma_key, base_ret_ma, 
                             saldo_mo_aa, sldven_mn_aa, sldven_mo_aa, tasa_aa, ind_nuevo_aa, 
                             tipcli_aa_key, base_ret_aa, y.tasa_ma, y.tasa_aa,
                             -- M:2019.11.19
                             imp_ingreso_mn, imp_comisio_mn, imp_ingccas_mn, imp_proesp_mn,
                             imp_proobl_mn , imp_propro_mn , imp_provol_mn , imp_progso_mn,
                             imp_revpro_mn
                             -- M:2019.11.19                
                        FROM dwstage.tmp_fact_activo_cancelados y
                       WHERE y.tiempo_key = ln_tiempo;
Commit;

Exception When Others Then
     Null;
End sp_ins_fact_activo_cancelados;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_job_fact_saldos(PD_FECHA in Date)
 /*************************************************************************
  Fecha: 2018.07.22
  Autor: Paola Vargas
  Uso  : Generar Job para carga incremental de hechos de saldos BIM y Bonos
  *************************************************************************/
 Is
    ------
    ln_tiempo_key number(10);                                           
	  lv_tipvar  bi_parametro.valor%type;
    ln_existe     number(1) :=0;
    ln_agetes number(10);
    ------
    ln_max       number(10);
    ln_rango     number(10);
    x            number(10);
    ln_job       number(10);
    ln_ini       number(10);
    ln_fin       number(10);
    lv_nproc     varchar2(1000);
    lv_fecha     varchar2(10):=to_char(PD_FECHA,'rrrrmmdd');
    ln_mmxjob    number(10);

 BEGIN

      Select TIEMPO_KEY into ln_tiempo_key from dm_tiempo where fecha = PD_FECHA;
      
      Begin  
         select valor Into lv_tipvar
    			 from bi_parametro 
    			where parametro_key = 5;
    	Exception When Others Then
    		 lv_TipVar:= null;
    	End;	
      
      -- Consultar si existe partición
      Select count(*) Into ln_existe From User_Tab_Partitions 
      Where Table_Name='FACT_SALDOS' And Partition_Name='FACT_SALDOS_'||to_char(PD_FECHA,'rrrrmmdd');
      
      
    	If lv_TipVar='R' And ln_existe > 0 Then
         --- ELIMINA PARTICION  
    		 Execute Immediate 'ALTER TABLE FACT_SALDOS DROP PARTITION FACT_SALDOS_'||to_char(PD_FECHA,'rrrrmmdd')
                         ||' Update global indexes parallel(degree 4)';
         ln_existe := 0;                 
    	End If;	      
    	
    	If ln_existe = 0 Then
    	   --- CREA PARTICION 
         EXECUTE IMMEDIATE 'alter table FACT_SALDOS add partition FACT_SALDOS_'||
    	                     to_char(PD_FECHA,'rrrrmmdd')||' values ('||ln_tiempo_key||') TABLESPACE DWHOUSE_B';   			 
    	End If;
      
      -- Agencia Tesorería
      Begin
          select geografia_key Into ln_agetes
            from dm_geografia 
           where codigo_agencia='900' 
             and codigo_region ='900';
      Exception When Others Then
         ln_agetes := Null;
      End;     
      
      ----------------------------------
      -- Genera rangos para jobs
      ----------------------------------
      Begin 
           Select max(ctnro),trunc(max(ctnro)/300)   
             Into ln_max,ln_rango
             From dwextra.fsr008
            Where ctnro <> 999999999;
      Exception When no_data_found then
                ln_max := 0;
                ln_rango:=0;
      End;    
         
      x:=0;
      ln_job := 0;
      While x <= ln_max loop
            if x = 0 then 
               ln_ini := x;
            else  
              ln_ini := x+1;
            end If;
              
              x:= x+ ln_rango;
              ln_fin := x;
              lv_nproc := ' begin '||'pq_carga_facts.sp_fact_saldos('||ln_ini||','||ln_fin ||
                          ','||ln_agetes||','''||lv_Fecha||'''); End; ';
              ln_job := ln_job +1;
              
              dbms_scheduler.create_job(
                 job_name=> 'FACT_SALDOS_'||LPAD(TO_CHAR(ln_job),5,'0'),
                 job_type=> 'PLSQL_BLOCK',
                 job_action=> lv_nproc,
                 start_date => sysdate+1/(24*180),
                 enabled => true, 
                 auto_drop=> TRUE,
                 comments => 'CARGA FACT SALDOS'
                 );
             Commit;
            -- CONTROLA MAXIMO 200 JOBS
            Loop
               select count(*) into ln_mmxjob from user_scheduler_jobs;
            Exit When ln_mmxjob <= 200;
            End Loop;
      End loop;
      
 End sp_job_fact_saldos;  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_fact_saldos(PN_CTAINI In Number,PN_CTAFIN In Number,
                           PN_AGETES In Number,PV_FECHA In Varchar2)
 Is
   ld_Fecha date := to_date(PV_FECHA,'RRRRMMDD');
 BEGIN
         INSERT INTO FACT_SALDOS
        (
          tiempo_key, cuentas_key,cliente_key, geografia_key, rubro_key, producto_key,moneda_key, 
          tipo_tarifario_key, tipo_tasa_key,estado_key,tasa,plazo,val_rubro, tipo_cambio, 
          segmento_cli_key, geografia_cli_key,tipo_cliente_key,saldo_mn,saldo_mo, 
          saldo_pro_mn,saldo_pro_mo,saldo_gar_mn,saldo_gar_mo, 
          imp_ape_mn, imp_ape_mo,imp_ren_mn, imp_ren_mo, 
          imp_blo_mn, imp_blo_mo,int_gen_mn, int_gen_mo, fac_tpo_mn, fac_tpo_mo,cli_retenido, 
          cli_retenido_bi, geografia_pas_key, 
          imp_fsd, int_fsd, gar_fsd, dii_fsd, ind_fsd, key_seg_cta, 
          ind_empbco,ind_dosrub/*, key_motdes,segcod, key_acteco_cli,key_ubidom_cli, 
          key_nacext, key_lispep, key_lispre, key_prodisoc, ind_tipreg, ind_pepexc*/
          
        )
        Select t.tiempo_key    , c.cuentas_key          , cl.cliente_key,
               g.geografia_key , r.rubro_key, s.producto_key  , m.moneda_key, 
               tt.tipo_tarifario_key,ta.tipo_tasa_key, es.estado_key,to_number(p.tasa_interes),
               to_number(p.plazo), to_number(p.codigo_rubro), to_number(p.tipo_cambio),
               sg.segmento_key , gc.geografia_key       , tc.tipo_cliente_key,
               nvl(p.saldo_mn,0), nvl(p.saldo_mo,0)             , 
               decode(p.aomda,0,nvl(p.saldo_promedio,0),nvl(p.saldo_promedio,0)*to_number(p.tipo_cambio)),
               nvl(p.saldo_promedio,0),
               decode(p.aomda,0,nvl(p.saldo_garantia,0),nvl(p.saldo_garantia,0)*to_number(p.tipo_cambio)),
               nvl(p.saldo_garantia,0),
               decode(p.aomda,0,nvl(p.imp_apertura,0),nvl(p.imp_apertura,0)*to_number(p.tipo_cambio)),
               nvl(p.imp_apertura,0),
               decode(p.aomda,0,nvl(p.imp_renovacion,0),nvl(p.imp_renovacion,0)*to_number(p.tipo_cambio)),
               nvl(p.imp_renovacion,0),
               decode(p.aomda,0,nvl(p.imp_bloqueado,0),nvl(p.imp_bloqueado,0)*to_number(p.tipo_cambio)),
               nvl(p.imp_bloqueado,0),
               decode(p.aomda,0,nvl(p.interes_generado,0),nvl(p.interes_generado,0)*to_number(p.tipo_cambio)),
               nvl(p.interes_generado,0),
               nvl(p.saldo_mn,0) * to_number(p.tasa_interes),
               nvl(p.saldo_mo,0) * to_number(p.tasa_interes),
               p.cliente_retenido, p.cliente_retenido_bi,
               decode(p.tipo_region,'T',PN_AGETES,g.geografia_key),
               nvl(p.imp_fsd,0), nvl(p.int_fsd,0), nvl(p.gar_fsd,0), nvl(p.dii_fsd,0), nvl(p.ind_fsd,0),
               p.key_seg_cta,p.ind_empbco,p.ind_dosrub
          From dwstage.tmp_fact_pasivo p
          Join dwhouse.dm_tiempo t 
            On t.fecha = p.fecha 
          Join dwhouse.dm_cuentas c
            On c.codigo_cuenta = p.codigo_cuenta
           And c.cuenta_unica  = p.cuenta_unica   
          Join dwhouse.dm_cliente cl
            On cl.codigo_cliente = p.codigo_cliente 
          Join dwhouse.dm_geografia g
            On g.codigo_agencia = p.codigo_agencia
           And g.tipo_region = p.tipo_region
          Join dwhouse.dm_rubro r 
            On r.codigo_rubro = p.codigo_rubro  
          Join dwhouse.dm_producto s
            On s.codigo_producto    = p.codigo_producto
           And s.codigo_subproducto = p.codigo_subproducto  
          Join dwhouse.dm_tipo_tarifario tt 
            On tt.codigo_tipo_tarifario = p.codigo_tipo_tarifario
          Join dwhouse.dm_moneda m
            On m.codigo_moneda = p.codigo_moneda
          Join dwhouse.dm_tipo_tasa ta 
            On ta.codigo_tipo_tasa = p.codigo_tipo_tasa
          Join dwhouse.dm_estado es
            On es.codigo_estado = p.codigo_estado 
          Join dwhouse.dm_segmento sg
            On sg.codigo_segmento = nvl(p.segmento_clie,'0')
          Join dwhouse.dm_geografia gc
            On gc.codigo_agencia = nvl(p.agencia_clie,'11')
           And gc.tipo_region    = nvl(p.tipo_reg_clie,'R')  
          Join dwhouse.dm_tipo_cliente tc
            On tc.tipo_cliente_codigo = p.tipo_cliente     
         Where t.fecha = ld_fecha
           and p.aocta Between PN_CTAINI and PN_CTAFIN
           and (p.codigo_producto in ('11','221') or 
                p.codigo_cuenta like '156-%' or
                p.codigo_cuenta like '125-%')
         LOG ERRORS INTO ERR$_FACT_PASIVO ('INSERT-' || to_char(ld_fecha,'rrrrmmdd')) REJECT LIMIT UNLIMITED;
         Commit;
            
 End sp_fact_saldos;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_job_fact_fsd_diario(PD_FECHA in Date)
 /****************************************************************
  Fecha: 2018.07.22
  Autor: Paola Vargas
  Uso  : Generar Job para carga incremental de hechos de operaciones
         pasivas, saldos diarios de FSD    
  *****************************************************************/
 Is
    ------
    ln_tiempo_key number(10);                                           
	  lv_tipvar  bi_parametro.valor%type;
    --ln_existe     number(1) :=0;
    --ln_agetes number(10);
    ------
    ln_max       number(10);
    ln_rango     number(10);
    x            number(10);
    ln_job       number(10);
    ln_ini       number(10);
    ln_fin       number(10);
    lv_nproc     varchar2(1000);
    lv_fecha     varchar2(10):=to_char(PD_FECHA,'rrrrmmdd');
    ln_mmxjob    number(10);

 BEGIN
      Begin  
         select valor Into lv_tipvar
    			 from bi_parametro 
    			where parametro_key = 7;
    	Exception When Others Then
    		 lv_TipVar:= null;
    	End;
      
      Begin
      Select TIEMPO_KEY into ln_tiempo_key from dm_tiempo where fecha = to_date(lv_tipvar,'dd-mm-rrrr');
      lv_fecha := to_char(to_date(lv_tipvar,'dd-mm-rrrr'),'rrrrmmdd');
      ----------------------------------
      -- Genera rangos para jobs
      ----------------------------------
      Begin 
           Select max(ctnro),trunc(max(ctnro)/300)   
             Into ln_max,ln_rango
             From dwextra.fsr008
            Where ctnro <> 999999999;
      Exception When no_data_found then
                ln_max := 0;
                ln_rango:=0;
      End;    
         
      x:=0;
      ln_job := 0;
      While x <= ln_max loop
              ln_ini := x+1;
              x:= x+ ln_rango;
              ln_fin := x;
              lv_nproc := ' begin '||'pq_carga_facts.sp_fact_fsd_diario('||ln_ini||','||ln_fin ||
                          ','''||lv_Fecha||'''); End; ';
              ln_job := ln_job +1;
              
              dbms_scheduler.create_job(
                 job_name=> 'FACT_FSD_DIA_'||LPAD(TO_CHAR(ln_job),5,'0'),
                 job_type=> 'PLSQL_BLOCK',
                 job_action=> lv_nproc,
                 start_date => sysdate+1/(24*180),
                 enabled => true, 
                 auto_drop=> TRUE,
                 comments => 'Carga FACT PASIVAS FSD DIARIO'
                 );
             Commit;
            -- CONTROLA MAXIMO 200 JOBS
            Loop
               select count(*) into ln_mmxjob from user_scheduler_jobs;
            Exit When ln_mmxjob <= 200;
            End Loop;
      End loop;
      
       --- Controla que finalicen Jobs para actualizar fecha de carga
      Loop
          Select count(*) into ln_mmxjob from user_scheduler_jobs 
           Where job_name like 'FACT_FSD_DIA_%';
      Exit When ln_mmxjob = 0;
      End Loop;
      
      -- Actualiza flag de carga
      Update dwhouse.dm_tiempo d set d.ind_fsddia=1 where fecha = to_date(lv_tipvar,'dd-mm-rrrr');
      Commit;
      Exception When Others Then
        Null;
      End;  
 End sp_job_fact_fsd_diario;  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_fact_fsd_diario(PN_CTAINI In Number,PN_CTAFIN In Number,
                              PV_FECHA In Varchar2)
 Is
   ld_Fecha date := to_date(PV_FECHA,'RRRRMMDD');
   cursor cursor_p (ld_fec in date, ln_cini in number, ln_cfin in number) 
       is select * from dwstage.tmp_fpasivo_fsd
           where fecha = ld_fec
             and aocta between ln_cini and ln_cfin;
   lv_query Varchar2(300);          
 BEGIN
      For T in cursor_p(ld_Fecha,PN_CTAINI,PN_CTAFIN) loop
       lv_query := 'update dwhouse.fact_pasivo partition(FACT_PASIVO_'||to_char(ld_fecha,'rrrrmmdd')||
                      ') set int_fsd=:1,'||
                            'imp_fsd=:2,'||
                            'gar_fsd=:3,'||
                            'dii_fsd=:4,'||
                            'ind_fsd= :5,'||
                            'ind_dosrub = :7,'||
                            'ind_empbco = :8 '||
                      'where tiempo_key = :9 '||
                        'and cuentas_key= :10';
          Execute Immediate lv_query 
            Using nvl(t.int_fsd,0),nvl(t.imp_fsd,0),nvl(t.gar_fsd,0),nvl(t.dii_fsd,0),
                  t.ind_fsd,nvl(t.ind_dosrub,1),nvl(t.ind_empbco,0),t.tiempo_key,
                  t.cuentas_key;                 
       Commit;
    End loop;
    
End sp_fact_fsd_diario;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Procedure SP_JOB_ACTIVAS_TMA(PD_FECHA In Date)
Is
   lv_fecha  varchar2(10) := to_char(PD_FECHA,'rrrrmmdd');
   ln_rango  number(10); 
   ln_ini    number(10);
   ln_fin    number(10);
   lv_ejepro varchar2(1000);
   --ln_job    number(5);
 Begin
      Execute Immediate 'Delete from dwhouse.fact_activo partition(fact_activas_'||lv_fecha||') '|| 
                        'Where estado_key=72 and ind_tma=1';
      Commit;
      Execute Immediate 'Update dwhouse.fact_activo partition(fact_activas_'||lv_fecha||') '||
                        'Set ind_tma = 0 '||
                        'Where estado_key=1';
      Commit;                  
      Select round(max(n_numreg)/300)
        Into ln_rango
        From dwstage.tmp_fact_activas_tma
       Where fecha_fin = PD_FECHA;
       
       ln_fin :=0;
       ln_ini :=0;
       ln_rango := ln_rango + 1;
       For x in 1 .. 300 Loop
           ln_ini := ln_fin + 1;
           ln_fin := ln_rango * x;
           lv_ejepro := 'Begin PQ_CARGA_FACTS.SP_ACTIVAS_TMA('||ln_ini||','||ln_fin||
                                                             ','''||lv_fecha||'''); End;';
           
           dbms_scheduler.create_job(job_name=> 'TMA_'||lv_fecha||'_'||to_char(x),
                                     job_type=> 'PLSQL_BLOCK',
                                     job_action=> lv_ejepro,
                                     start_date => sysdate+1/(24*180),
                                     enabled => true, 
                                     auto_drop=> TRUE,
                                     comments => 'TMA'
                                    ); 
       End Loop;
End SP_JOB_ACTIVAS_TMA;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Procedure SP_ACTIVAS_TMA(PN_REGINI In Number,PN_REGFIN In Number,PV_FECHA In Varchar2)
Is
   Cursor c_tma(ld_Fec In Date,ln_ini In Number,ln_fin In Number)
       is select tiempo_key_ini,tiempo_key_fin,credito_key,
                 saldomn_ini,saldomn_det,diaatr_det,fecha_det
            from dwstage.tmp_fact_activas_tma
           where fecha_fin = ld_Fec
             and n_numreg between ln_ini and ln_fin;
   NO_UPD_ROW exception;
   ld_fecha date := to_date(PV_FECHA,'rrrrmmdd');
       
Begin
  
  For x in c_tma(ld_fecha,PN_REGINI,PN_REGFIN) Loop
    Begin
      Update dwhouse.fact_activo a
         set a.saldomn_12m = nvl(x.saldomn_ini,0),
             a.saldomn_60d = nvl(x.saldomn_det,0),
             a.ind_tma = 1,
             a.det_fecha = x.fecha_det,
             a.det_diaatr= x.diaatr_det
      Where a.tiempo_key = x.tiempo_key_fin
        and a.credito_key = x.credito_key;
        
      If SQL%ROWCOUNT = 0 THEN
         RAISE NO_UPD_ROW;
      End If;   
    Exception WHEN NO_UPD_ROW Then
      begin
       INSERT INTO dwhouse.FACT_ACTIVO (row_id,tiempo_key,credito_key,rubro_key,producto_key,geografia_key,analista_key,campania_key,
              tipo_credito_key,cliente_key,convenio_key,moneda_key,situacion_key,modalidad_key,
              agenciabn_key,frecuencia,plazo, dias_atraso,saldo_capital_mn, saldo_capital_mo, saldo_capital_mora_mn,
              saldo_capital_mora_mo,interes_pagado_mn,interes_pagado_mo,interes_pactado,tipo_cambio,saldo_interes_diferido,
              deuda_total,deuda_amortizada,factor_tasa_ponderada_mn,factor_tasa_ponderada_mo,rentabilidad,tasa_ponderada_mn,
              tasa_ponderada_mo,porcentaje_mora,porcentaje_mora_contable,flag_tipo_garantia,saldo_garantia_inscrita,
              codigo_situacion,categoria_key,saldo_vencido_mo,saldo_vencido_mn,tipo_cliente_key,actividad_economica_key,
              producto_reg_key,destino_key,total_linea_mo,total_linea_mn,segmento_key,sectorsbs_key,tasa_interes,
              tipo_clicaj_key,imp_desemb,ind_nuevo_mes, inst_origen,imp_utilizado,comite_key,
              aomod,aocta,aoope,aosbo,aotop,
              segmer_key, segtcr_key,segtc_totseg_key,segtc_tottcr_key,segtc_total_key,segmer_cli_key,
              categoria_ana_key,catuni_dia_key,improv_dia,catuni_mes_key,improv_mes,ind_casven, estado_key,
              saldomn_12m,saldomn_60d,ind_tma,det_fecha,det_diaatr)
       Select Seq_Fact_Activo.Nextval,x.tiempo_key_fin,credito_key,rubro_key,producto_key,geografia_key,analista_key,campania_key,
              tipo_credito_key,cliente_key,convenio_key,moneda_key,0 situacion_key,modalidad_key,
              agenciabn_key,frecuencia,plazo, 0 dias_atraso, 0 saldo_capital_mn, 0 saldo_capital_mo, 0 saldo_capital_mora_mn,
              0 saldo_capital_mora_mo,0 interes_pagado_mn,0 interes_pagado_mo,0 interes_pactado,0 tipo_cambio,
              0 saldo_interes_diferido,0 deuda_total,0 deuda_amortizada,0 factor_tasa_ponderada_mn,0 factor_tasa_ponderada_mo,
              0 rentabilidad,0 tasa_ponderada_mn,0 tasa_ponderada_mo,0 porcentaje_mora,0 porcentaje_mora_contable,
              flag_tipo_garantia,0 saldo_garantia_inscrita,
              '0' codigo_situacion,categoria_key,0 saldo_vencido_mo,0 saldo_vencido_mn,
              tipo_cliente_key,actividad_economica_key,
              producto_reg_key,destino_key,0 total_linea_mo,0 total_linea_mn,segmento_key,sectorsbs_key,tasa_interes,
              tipo_clicaj_key,0 imp_desemb,ind_nuevo_mes, inst_origen,0 imp_utilizado,comite_key,
              aomod,aocta,aoope,aosbo,aotop,
              segmer_key, segtcr_key,segtc_totseg_key,segtc_tottcr_key,segtc_total_key,segmer_cli_key,
              categoria_ana_key,catuni_dia_key,0 improv_dia,catuni_mes_key,0 improv_mes,0 ind_casven, 72 estado_key,
              nvl(x.saldomn_ini,0),nvl(x.saldomn_det,0),1,x.fecha_det,x.diaatr_det  
          from dwhouse.fact_activo where tiempo_key = x.tiempo_key_ini and credito_key=x.credito_key; 
          Commit;
      exception when others then
         null;
      end;  
      Commit;          
    End;    
  End Loop;
End SP_ACTIVAS_TMA;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
Procedure fact_fsd_colabco(PD_FECHA In Date)
Is
  -- Carga colaboradores
Begin
       delete from fact_fsd_colabco where fecha = PD_FECHA;
       
       MERGE INTO fact_fsd_colabco c 
            USING (Select t.tiempo_key,c.fecha,d.tdoc_des t_doc,trim(c.pendoc) n_doc,
                          trim(nvl(k.nombre_cliente,upper(trim(v.no_apel_pate)||' '||trim(v.no_apel_mate)||' '||trim(v.no_trab)))) v_nombre,
                          c.v_tipcar,
                          decode(c.v_tipcar,'C','Confianza','D','Directivo',Null) v_descar,
                          c.v_estado,
                          decode(c.v_estado,'A','Activo','C','Cesado',Null) v_desest,
                          c.d_fecing,c.d_fecces,
                          upper(trim(v.de_pues_trab)) v_cargo,
                          decode(k.nombre_cliente,null,'N','S') c_exisdm,
                          k.cliente_key
                    From dwstage.tmp_dm_fsd_persexc c
                    Join dwhouse.dm_tiempo t
                      on t.fecha = c.fecha
                    Join dwhouse.dm_tipo_documento d
                      on d.tdoc_cod = c.petdoc
                    Join dwextra.v_anexo17a v
                      on trim(v.nu_docu_iden) = trim(c.pendoc)  
                     and to_date(trim(v.fe_ingr_emp),'rrrr.mm.dd') = c.d_fecing
                    Left Join dwhouse.dm_cliente k
                      on k.pais = c.pepais and to_number(k.tipo_documento) = c.petdoc 
                     and k.numero_documento = c.pendoc  
                   Where c.fecha = PD_FECHA
                 ) s
             ON (c.tiempo_key = s.tiempo_key and
                 c.des_tipdoc = s.t_doc      and
                 c.val_numdoc = s.n_doc      and
                 c.fec_ingcol = s.d_fecing
                )
       WHEN MATCHED THEN  
            UPDATE SET c.val_nomcol = s.v_nombre,
                       c.cod_tipcar = s.v_tipcar,
                       c.des_tipcar = s.v_descar,
                       c.cod_estcol = s.v_estado,
                       c.des_estcol = s.v_desest,
                       --c.fec_ingcol = s.d_fecing,
                       c.fec_cescol = s.d_fecces,
                       c.des_carcol = s.v_cargo,
                       c.ind_exisdm = s.c_exisdm,
                       c.fec_insreg = sysdate,
                       c.cliente_key= s.cliente_key
       WHEN NOT MATCHED THEN 
            INSERT (tiempo_key, fecha, des_tipdoc, val_numdoc, val_nomcol, 
                    cod_tipcar, des_tipcar, cod_estcol, des_estcol, fec_ingcol, 
                    fec_cescol, des_carcol, ind_exisdm, fec_insreg, cliente_key 
                   )
            VALUES(s.tiempo_key,s.fecha,s.t_doc,s.n_doc,s.v_nombre,
                   s.v_tipcar,s.v_descar,s.v_estado,s.v_desest,s.d_fecing,
                   s.d_fecces,s.v_cargo,s.c_exisdm, sysdate,s.cliente_key
                  );
       COMMIT;           
End fact_fsd_colabco; 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
Procedure sp_job_act_cosechas(PD_FECSDO In Date)
Is
    Cursor c_period(ld_Fec In Date)
        Is Select distinct n_periodo 
           From dwstage.tmp_fact_act_cosecha where d_fecsdo = ld_Fec;
           
    lv_nproc  Varchar2(500);     
    ln_mmxjob Number(5);
    ln_job    Number(5) := 0;
    lv_Fecha  Varchar2(10) := to_char(PD_FECSDO,'rrrrmmdd'); 
    lv_nombre Varchar2(100);
    ln_tiempo Number (10);
    ln_period Number(6);
    ln_jtra   Number(5);
    
    Function FN_PARTICION(LV_TIPAR In Char,LN_VALOR In Number,LV_NOMPAR In Varchar2)
    Return Varchar2
    Is
        lv_valor varchar2(10);
        lv_partn Varchar2(100);
        --ln_period Number(6);
        
        Cursor c_valpar
            is Select high_value, partition_name from dba_tab_partitions 
            where table_name = 'FACT_ACT_COSECHAS';
        Cursor c_valspa
            is Select high_value, subpartition_name from dba_tab_subpartitions 
            where table_name = 'FACT_ACT_COSECHAS' and partition_name = LV_NOMPAR;    
    Begin
       If LV_TIPAR = 'P' Then
          For x in c_valpar Loop
              lv_valor := x.high_value;
              If to_number(lv_valor) = LN_VALOR Then
                 lv_partn := x.partition_name;
                 Exit; 
              End If;
          End Loop; 
       ElsIf LV_TIPAR = 'S' Then
          For x in c_valspa Loop
              lv_valor := x.high_value;
              If to_number(lv_valor) = LN_VALOR Then
                 lv_partn := x.subpartition_name;
                 Exit; 
              End If;
          End Loop; 
       End If;
       
       Return lv_partn;
    End;
   
Begin
 IF TRIM(TO_CHAR(PD_FECSDO, 'DAY', 'NLS_DATE_LANGUAGE=SPANISH')) = 'DOMINGO' 
    OR PD_FECSDO = LAST_DAY(PD_FECSDO)
 THEN
     Loop
          select count(*) Into ln_jtra 
            from Dba_Scheduler_Jobs 
           where owner = 'DWSTAGE' AND JOB_NAME LIKE 'F_COSECHA_%';
     Exit When ln_jtra = 0;
     End Loop;
     
     -- Revisa si existe particion
     Select tiempo_key Into ln_tiempo From dm_tiempo Where fecha = PD_FECSDO;
     lv_nombre := FN_PARTICION('P',ln_tiempo,NULL);
  
     If lv_nombre Is Null Then
        -- Crear Partición
        Select Min(N_PERIODO) Into ln_period From dwstage.tmp_fact_act_cosecha Where D_FECSDO = PD_FECSDO;
        lv_nombre := 'FACT_COSDET_'||to_char(PD_FECSDO,'rrrrmmdd');
        Begin
           Execute Immediate 'Alter table FACT_ACT_COSECHAS ADD PARTITION '||lv_nombre||
                             ' VALUES('||ln_tiempo||') (SUBPARTITION FACT_S_COSDET_'||
                             to_char(PD_FECSDO,'rrrrmmdd')||'_'||TO_CHAR(ln_period)||' VALUES('||
                             ln_period||'))';
        Exception When Others Then
           Null;
        End;                    
     Else
         -- Truncar Particion   
         Begin
             Execute Immediate 'Alter table FACT_ACT_COSECHAS TRUNCATE PARTITION '||lv_nombre;
         Exception When Others Then
           Null;
         End;
     End If;
    
     For x In c_period(PD_FECSDO) Loop
         lv_nproc:='Begin '||'pq_carga_facts.sp_fact_act_cosechas('||x.n_periodo||','''||lv_Fecha||''','''||lv_nombre||'''); End;';
         ln_job := ln_job +1;
              
         dbms_scheduler.create_job(
                  job_name=> 'FACT_ACT_COSECHAS_'||LPAD(TO_CHAR(ln_job),5,'0'),
                  job_type=> 'PLSQL_BLOCK',
                  job_action=> lv_nproc,
                  start_date => sysdate+1/(24*180),
                  enabled => true, 
                  auto_drop=> TRUE,
                  comments => 'Carga FACT ACT COSECHAS'
                  );
         Commit;
        
         -- CONTROLA MAXIMO 200 JOBS
         Loop
            select count(*) into ln_mmxjob from user_scheduler_jobs;
         Exit When ln_mmxjob <= 200;
         End Loop;
     End Loop;
  
  END IF;

End sp_job_act_cosechas;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
Procedure sp_fact_act_cosechas(PN_PERIODO In Number, PV_FECSDO In Varchar2,PV_NOMBRE In Varchar2)
Is  
  --ln_tiempo Number(10);
  lv_nombre Varchar2(100) := PV_NOMBRE;
  --ln_period Number(6);
  lv_subpar Varchar2(100);
  ld_fecsdo Date := to_date(PV_FECSDO,'rrrrmmdd');
  /*Cursor c_period(ld_Fec In Date)
       Is Select distinct n_periodo 
           from dwstage.tmp_fact_act_cosecha where d_fecsdo = ld_Fec;*/

  Function FN_PARTICION(LV_TIPAR In Char,LN_VALOR In Number,LV_NOMPAR In Varchar2)
  Return Varchar2
  Is
    lv_valor varchar2(10);
    lv_partn Varchar2(100);
    --ln_period Number(6);
    Cursor c_valpar
        is Select high_value, partition_name from dba_tab_partitions 
        where table_name = 'FACT_ACT_COSECHAS';
    Cursor c_valspa
        is Select high_value, subpartition_name from dba_tab_subpartitions 
        where table_name = 'FACT_ACT_COSECHAS' and partition_name = LV_NOMPAR;    
  Begin
       If LV_TIPAR = 'P' Then
          For x in c_valpar Loop
              lv_valor := x.high_value;
              If to_number(lv_valor) = LN_VALOR Then
                 lv_partn := x.partition_name;
                 Exit; 
              End If;
          End Loop; 
       ElsIf LV_TIPAR = 'S' Then
          For x in c_valspa Loop
              lv_valor := x.high_value;
              If to_number(lv_valor) = LN_VALOR Then
                 lv_partn := x.subpartition_name;
                 Exit; 
              End If;
          End Loop; 
       End If;
       
       Return lv_partn;
   End;
 
Begin
 /*
  -- Revisa si existe particion
  Select tiempo_key Into ln_tiempo From dm_tiempo Where fecha = ld_fecsdo;
  lv_nombre := FN_PARTICION('P',ln_tiempo,NULL);
  
  If lv_nombre Is Null Then
     -- Crear Partición
     Select Min(N_PERIODO) Into ln_period From dwstage.tmp_fact_act_cosecha Where D_FECSDO = ld_fecsdo;
     lv_nombre := 'FACT_COSDET_'||to_char(ld_fecsdo,'rrrrmmdd');
     Execute Immediate 'Alter table FACT_ACT_COSECHAS ADD PARTITION '||lv_nombre||
                       ' VALUES('||ln_tiempo||') (SUBPARTITION FACT_S_COSDET_'||
                       to_char(ld_fecsdo,'rrrrmmdd')||'_'||TO_CHAR(ln_period)||' VALUES('||
                       ln_period||'))';
  Else
     -- Truncar Particion   
     Execute Immediate 'Alter table FACT_ACT_COSECHAS TRUNCATE PARTITION '||lv_nombre;
  End If;
  */
  
  -- Periodo de Desembolso
 
      lv_subpar := FN_PARTICION('S',PN_PERIODO,lv_nombre);
      If lv_subpar Is Null Then
         Execute Immediate 'Alter table FACT_ACT_COSECHAS MODIFY PARTITION '||lv_nombre||
                           ' ADD SUBPARTITION FACT_S_COSDET_'||to_char(ld_fecsdo,'rrrrmmdd')||
                           '_'||TO_CHAR(PN_PERIODO)||' VALUES('||PN_PERIODO||')';
                        
      Else
          Execute Immediate 'Alter table FACT_ACT_COSECHAS TRUNCATE SUBPARTITION '||lv_subpar;
      End If;
      
      Insert Into fact_act_cosechas
      Select o.tiempo_key,o.tiempo_des_key,o.n_periodo,
             o.credito_key,d.analista_key,d.campania_key,
             d.tipo_credito_key,d.cliente_key,d.situacion_key,
             d.convenio_key,d.moneda_key,d.geografia_key,d.agenciabn_key,
             (case when d.moneda_key=1 then d.importe_desembolso_mo else 
             d.importe_desembolso_mo * d.tipo_cambiof_mes end) imp_des,
             d.importe_desembolso_mo,
             d.rango_desembolso_key,d.rango_desembolso_mo_key,
             d.numero_trx,d.transacc_key,d.agencia_trx,d.tipo_cliente_key,
             d.actividad_economica_key,d.producto_reg_key,d.destino_key,
             d.flag_primer_desembolso,d.credito_unico,d.segmento_key,
             d.categoria_key,d.tipo_clie_caja_key,d.comite_key,d.sectorsbs_key,
             d.ind_nuevo_mes,d.segmento_antes_fmes,d.segtcr_key,d.enfinmes,
             d.segmer_cli_key,d.segmer_key,d.cargo_usu_key,d.ind_prides_prod,
             d.usuario_apro_key,d.categoria_ana_key,d.tipo_ana_key,d.mediodes_key,
             o.saldo_mn,o.diaatr,o.n_madurez,o.d_fecdes,o.d_fecsdo,
             (case when o.diaatr > 15 then o.saldo_mn else 0 end) Saldo15_Mn,
             (case when o.diaatr > 30 then o.saldo_mn else 0 end) Saldo30_Mn,
             (case when o.diaatr > 8 then o.saldo_mn else 0 end) Saldo8_Mn,
             o.n_sdoatr,o.ind_fmes,1 n_cntcre,
             case when o.cod_sit in ('1405','1406') then 1 else 0 end n_creatr,
             o.modalidad_key
       from dwstage.tmp_fact_act_cosecha o
       join fact_desembolso d 
         on d.credito_key = o.credito_key
        and d.tiempo_key = o.tiempo_des_key
        and d.transacc_key = o.transacc_key
        and d.agencia_trx = o.agencia_trx
        and d.numero_trx = o.numero_trx 
      where d_fecsdo = ld_fecsdo
      and n_periodo = PN_PERIODO
      and d.enfinmes = 1
      and d.TRANSACC_KEY in (10, 3, 1, 4, 11);
      Commit;
End sp_fact_act_cosechas;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Procedure SP_CARGA_DEPOSITOS_PN(PD_FECHA In Date)
-- Creación -----------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
-- Fecha: 2020.02.11
-- Autor: Paola Vargas
-- Uso: Carga detos del formato normativo numero depositantes personas naturales
-- Area: Ahorros
-- Frecuencia : Una vez al mes, dia 09
-----------------------------------------------------------------------------------------
Is
    ld_fecha date := last_day(add_months(PD_FECHA,-1));
    ln_jobs number(5);
Begin
    If to_char(PD_FECHA,'DD') = '09' Then
       -- Revisa Jobs de transformación finalizó
       Loop
           Select count(*) Into ln_jobs From dba_scheduler_jobs s
           Where s.owner = 'DWSTAGE' and s.job_name like 'ANX_NDEP_PN_%';
       Exit When ln_jobs = 0;
       End Loop;
       
       Pq_Carga_Facts.sp_fact_anx_numdep_pn(ld_fecha);
       Pq_Carga_Facts.FACT_PNOR_PNUMDEP_CR(ld_fecha);
    End If;    
End SP_CARGA_DEPOSITOS_PN;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
Procedure sp_fact_anx_numdep_pn (PD_FECHA In Date)
Is
  ln_tiempo number(10);
  ld_Fecha date := PD_FECHA;
  ln_existe number(3);
  ln_tieman number(10);
Begin
     -- Obtiene tiempo_key
     Select tiempo_key, tiempomesanterior_key 
       Into ln_tiempo,ln_tieman From dm_tiempo Where fecha = ld_Fecha;
        
     -- Revisa/Crea partición   
        SELECT count(*) Into ln_existe
           FROM DBA_TAB_PARTITIONS 
          WHERE TABLE_OWNER='DWHOUSE' 
            and table_name='FACT_PNOR_NUMDEP_PN' 
            and partition_name = 'FACT_PNOR_NUMDEP_PN_'||to_char(ld_Fecha,'rrrrmmdd');
     
     If ln_existe = 0 Then
        EXECUTE IMMEDIATE 'alter table FACT_PNOR_NUMDEP_PN add partition FACT_PNOR_NUMDEP_PN_'||
                           to_char(PD_FECHA,'rrrrmmdd')||' values ('||ln_tiempo||') TABLESPACE DWHOUSE_B';   			 
        
     Else
        EXECUTE IMMEDIATE 'ALTER TABLE FACT_PNOR_NUMDEP_PN TRUNCATE PARTITION FACT_PNOR_NUMDEP_PN_'||to_char(ld_Fecha,'rrrrmmdd')||
                          ' UPDATE INDEXES';
        -- Reinicia a "Cero" indicador clientes cancelados en mes posterior
        UPDATE FACT_PNOR_NUMDEP_PN t SET IND_CLICAN = 0 WHERE tiempo_key = ln_tieman
        AND t.ind_geodep = 1;
        Commit;                  
     End If;
     
     -- Actualiza a "Uno" indicador clientes cancelados en mes posterior
     UPDATE FACT_PNOR_NUMDEP_PN t SET IND_CLICAN = 1 WHERE tiempo_key = ln_tieman
     AND t.ind_geodep = 1
     AND NOT EXISTS (select 1 from dwstage.tmp_fact_nor_pnumdep_pn m
                      Where m.cliente_key = t.cliente_key
                        and m.tiempo_key = ln_tiempo
                        and m.ind_geodep = 1
                     );
     Commit;    
           
     -- Carga datos
     
     Insert Into FACT_PNOR_NUMDEP_PN(TIEMPO_KEY,CLIENTE_KEY,NATURALEZA,CUENTAS_KEY,NUM_TITCTA,
                                  SALDO_MO,FEC_APERTURA,GEOGRAFIA_KEY,PRODUCTO_KEY,ESTADO_KEY,
                                  IND_GEODEP,IND_DEPSUE,IND_DEPAHO,IND_DEPPLZ,IND_DEPCTS,
                                  IND_PRODEP,IND_CREACT,ind_clican,ind_clinue
                                 )
                                  
                          select TIEMPO_KEY,CLIENTE_KEY,NATURALEZA,CUENTAS_KEY,NUM_TITCTA,
                                 SALDO_MO,FEC_APERTURA,GEOGRAFIA_KEY,PRODUCTO_KEY,ESTADO_KEY,
                                 IND_GEODEP,IND_DEPSUE,IND_DEPAHO,IND_DEPPLZ,IND_DEPCTS,
                                 IND_PRODEP,IND_CREACT,ind_clican,ind_clinue
                            from dwstage.tmp_fact_nor_pnumdep_pn h
                           Where tiempo_key = ln_tiempo;
      Commit;    
End sp_fact_anx_numdep_pn;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Procedure FACT_PNOR_PNUMDEP_CR (PD_FECHA In Date)
-- Creación -----------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
-- Fecha: 2020.02.11
-- Autor: Paola Vargas
-- Uso: Detalle de creditos para formato normativo numero depositantes personas naturales
-- Area: Ahorros
-----------------------------------------------------------------------------------------
Is
  ln_tiempo number(10);
  ld_Fecha  date := PD_FECHA;
  ln_existe number(3);
Begin
     -- Obtiene tiempo_key
     Select tiempo_key Into ln_tiempo From dm_tiempo Where fecha = ld_Fecha;
        
     -- Revisa/Crea partición   
        SELECT count(*) Into ln_existe
           FROM DBA_TAB_PARTITIONS 
          WHERE TABLE_OWNER='DWHOUSE' 
            and table_name='FACT_PNOR_PNUMDEP_CR' 
            and partition_name = 'FACT_PNOR_PNUMDEP_CR_'||to_char(ld_Fecha,'rrrrmmdd');
     
     If ln_existe = 0 Then
        EXECUTE IMMEDIATE 'alter table FACT_PNOR_PNUMDEP_CR add partition FACT_PNOR_PNUMDEP_CR_'||
                           to_char(PD_FECHA,'rrrrmmdd')||' values ('||ln_tiempo||') TABLESPACE DWHOUSE_B';   			 
        
     Else
        EXECUTE IMMEDIATE 'ALTER TABLE FACT_PNOR_PNUMDEP_CR TRUNCATE PARTITION '||
                          'FACT_PNOR_PNUMDEP_CR_'||to_char(ld_Fecha,'rrrrmmdd')||
                          ' UPDATE INDEXES';
     End If;
     
     -- Carga Datos
     Insert Into FACT_PNOR_PNUMDEP_CR(tiempo_key, cliente_key, credito_key, moneda_key, 
                                      tipo_cambio, saldo_mo, aocta, aomod, aoope, aosbo, 
                                      aotop, ttcod, cttfir, producto_key, tipocr_key
                                     )
                                  
                          select c.tiempo_key,c.cliente_key,c.credito_key,c.moneda_key,
                                 c.tipo_cambio,c.saldo_mo, c.aocta,c.aomod,c.aoope,c.aosbo,
                                 c.aotop,c.ttcod,c.cttfir,c.producto_key,c.tipocr_key   
                            from dwstage.tmp_fact_nor_pnumdep_cr c
                           Where tiempo_key = ln_tiempo;
      Commit;    
 End FACT_PNOR_PNUMDEP_CR; 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 Procedure SP_CARGA_SALDOS_ICP(PD_FECHA in Date)
 -- Creación 
 -----------------------------------------------------------------------------------------
 -- Fecha: 2020.02.25
 -- Autor: Paola Vargas
 -- Uso  : Carga saldos ICP (Ingreso/comisión/provisión) en fact_activo
 -- Area : BI Negocios
 -----------------------------------------------------------------------------------------
 Is
 Begin
   PQ_CARGA_FACTS.SP_INS_SALDOS_ICP(PD_FECHA);
   PQ_CARGA_FACTS.SP_JOB_UPD_SALDOS_ICP(PD_FECHA);
 End SP_CARGA_SALDOS_ICP; 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Procedure SP_JOB_UPD_SALDOS_ICP(PD_FECHA in Date)
 -- Creación 
 -----------------------------------------------------------------------------------------
 -- Fecha: 2020.02.25
 -- Autor: Paola Vargas
 -- Uso  : Genera Jobs para actualizar saldos ICP (Ingreso/comisión/provisión) 
 -- Area : BI Negocios
 -----------------------------------------------------------------------------------------
 Is
    ln_max       number(10);
    ln_rango     number(10);
    x            number(10);
    ln_job       number(10);
    ln_ini       number(10);
    ln_fin       number(10);
    lv_nproc     varchar2(1000);
    lv_fecha     varchar2(10):=to_char(PD_FECHA,'rrrrmmdd');
    ln_mmxjob    number(10);
 Begin
      ----------------------------------
      -- Genera rangos para jobs
      ----------------------------------
      Begin 
           Select max(ctnro),trunc(max(ctnro)/300)   
             Into ln_max,ln_rango
             From dwextra.fsr008
            Where ctnro <> 999999999;
      Exception When no_data_found then
                ln_max := 0;
                ln_rango:=0;
      End;    
         
      x:=0;
      ln_job := 0;
      While x <= ln_max loop
              ln_ini := x+1;
              x:= x+ ln_rango;
              ln_fin := x;
              lv_nproc := ' begin '||'pq_carga_facts.SP_UPD_SALDOS_ICP('||ln_ini||','||ln_fin ||',''' 
                                   ||lv_Fecha||'''); End; ';
              ln_job := ln_job +1;
              
              dbms_scheduler.create_job(
                 job_name=> 'FACT_ACTIVAS_UPD_ICP_'||LPAD(TO_CHAR(ln_job),5,'0'),
                 job_type=> 'PLSQL_BLOCK',
                 job_action=> lv_nproc,
                 start_date => sysdate+1/(24*180),
                 enabled => true, 
                 auto_drop=> TRUE,
                 comments => 'ACTUALIZA SALDOS ICP EN FACT ACTIVAS'
                 );
             Commit;
            -- CONTROLA MAXIMO 200 JOBS
            Loop
               select count(*) into ln_mmxjob from user_scheduler_jobs;
            Exit When ln_mmxjob <= 200;
            End Loop;
      End loop;
 End SP_JOB_UPD_SALDOS_ICP;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
Procedure SP_UPD_SALDOS_ICP(PN_CINI In Number,PN_CFIN In Number,PV_FECHA In Varchar2)
IS
    Cursor c_ing(ld_fec In Date,ln_cini In Number, ln_cfin in Number)
        is Select tiempo_key, credito_key,geografia_key,nvl(imp_ingreso,0) imp_ingreso, nvl(imp_comision,0) imp_comision,
                 nvl(imp_ingccas,0) imp_ingccas , nvl(imp_revpro,0) imp_revpro,
                 nvl(imp_proesp,0) imp_proesp,nvl(imp_proobl,0) imp_proobl,nvl(imp_propro,0) imp_propro,
                 nvl(imp_provol,0) imp_provol,nvl(imp_progso,0) imp_progso,ind_actins
            From dwstage.tmp_fact_activo_com 
           Where ind_actins < 3 and fecha = ld_fec
             and aocta between ln_cini and ln_cfin;
    ld_fecha date := to_date(PV_FECHA,'RRRRMMDD');         
 Begin
     For x in c_ing(ld_fecha,PN_CINI,PN_CFIN) Loop
         Execute Immediate 'Update fact_activo partition (fact_activas_'||PV_FECHA||') '||
                              'Set imp_ingreso_mn = :1,'||
                                  'imp_comision_mn= :2,'||
                                  'imp_ingccas_mn = :3,'||
                                  'imp_revpro_mn  = :4,'||
                                  'imp_proesp_mn  = :5,'||
                                  'imp_propro_mn  = :6,'||
                                  'imp_proobl_mn  = :7,'||
                                  'imp_provol_mn  = :8,'||
                                  'imp_progso_mn  = :9,'||
                                  'ind_actins     = :10'||
                            'Where tiempo_key    = :11 '||
                              'and credito_key   = :12 '||
                              'and geografia_key = :13'
         Using x.imp_ingreso,x.imp_comision,x.imp_ingccas,
               x.imp_revpro,x.imp_proesp, x.imp_propro,
               x.imp_proobl,x.imp_provol,x.imp_progso,
               x.ind_actins,x.tiempo_key,x.credito_key,
               x.geografia_key;                    
         Commit;  
     End Loop;
 End SP_UPD_SALDOS_ICP;          
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Procedure SP_INS_SALDOS_ICP(PD_FECHA In Date)
 Is
    Cursor c_ing(ld_Fec In Date)
        is Select tiempo_key,credito_key,geografia_key,
                  aomda,aocta,aoope,estado_key,ind_actins,
                  AGENCIABN_KEY,ANALISTA_KEY,CAMPANIA_KEY,CLIENTE_KEY,
                  CONVENIO_KEY,MODALIDAD_KEY,MONEDA_KEY,PRODUCTO_KEY,
                  PRODUCTO_REG_KEY,SITUACION_KEY,TIPO_CREDITO_KEY,
                  nvl(imp_ingreso,0) imp_ingreso, nvl(imp_comision,0) imp_comision,
                  nvl(imp_ingccas,0) imp_ingccas , nvl(imp_revpro,0) imp_revpro,
                  nvl(imp_proesp,0) imp_proesp,nvl(imp_proobl,0) imp_proobl,nvl(imp_propro,0) imp_propro,
                  nvl(imp_provol,0) imp_provol,nvl(imp_progso,0) imp_progso,
                  nvl(imp_ingma,0) imp_ingma,nvl(imp_comma,0) imp_comma,nvl(imp_casma,0) imp_casma,
                  nvl(imp_revma,0) imp_revma,nvl(imp_pesma,0) imp_pesma,nvl(imp_pprma,0) imp_pprma,
                  nvl(imp_pobma,0) imp_pobma,nvl(imp_pvoma,0) imp_pvoma,nvl(imp_psbma,0) imp_psbma
            From dwstage.tmp_fact_activo_com 
           Where ind_actins = 3 
            --and credito_key <> 0
             and fecha = ld_Fec;
                 /*UNION ALL
          Select tiempo_key,credito_key,geografia_key,
                  0 aomda ,0 aocta,0 aoope,estado_key,ind_actins,
                  AGENCIABN_KEY,ANALISTA_KEY,CAMPANIA_KEY,CLIENTE_KEY,
                  CONVENIO_KEY,MODALIDAD_KEY,MONEDA_KEY,PRODUCTO_KEY,
                  PRODUCTO_REG_KEY,SITUACION_KEY,TIPO_CREDITO_KEY,
                  sum(nvl(imp_ingreso,0)) imp_ingreso, sum(nvl(imp_comision,0)) imp_comision,
                  sum(nvl(imp_ingccas,0)) imp_ingccas , sum(nvl(imp_revpro,0)) imp_revpro,
                  sum(nvl(imp_proesp,0)) imp_proesp,sum(nvl(imp_proobl,0)) imp_proobl,sum(nvl(imp_propro,0)) imp_propro,
                  sum(nvl(imp_provol,0)) imp_provol,sum(nvl(imp_progso,0)) imp_progso,
                  sum(nvl(imp_ingma,0)) imp_ingma,sum(nvl(imp_comma,0)) imp_comma,sum(nvl(imp_casma,0)) imp_casma,
                  sum(nvl(imp_revma,0)) imp_revma,sum(nvl(imp_pesma,0)) imp_pesma,sum(nvl(imp_pprma,0)) imp_pprma,
                  sum(nvl(imp_pobma,0)) imp_pobma,sum(nvl(imp_pvoma,0)) imp_pvoma,sum(nvl(imp_psbma,0)) imp_psbma
            From dwstage.tmp_fact_activo_com 
           Where ind_actins = 3
             and credito_key = 0 
             and fecha = ld_Fec
          group by  tiempo_key,credito_key,geografia_key,
                  estado_key,ind_actins,
                  AGENCIABN_KEY,ANALISTA_KEY,CAMPANIA_KEY,CLIENTE_KEY,
                  CONVENIO_KEY,MODALIDAD_KEY,MONEDA_KEY,PRODUCTO_KEY,
                  PRODUCTO_REG_KEY,SITUACION_KEY,TIPO_CREDITO_KEY  ;
                 */ 
     ln_tiempo Number(10) := pq_carga_facts.fn_tiempo_key(PD_FECHA);        
 Begin
     -- Elimina registros de partición
     Begin
        Execute Immediate 'Delete from fact_activo partition(Fact_activas_'||to_char(PD_FECHA,'rrrrmmdd')|| ') '||
                          'Where tiempo_key = :1 and estado_key = 72 and ind_actins = 3'
        Using ln_tiempo;
        Commit;
     Exception When Others Then
        Null;
     End;
     
     -- Inserta datos
     For x in c_ing(PD_FECHA) Loop
        Begin
         Insert Into fact_activo(tiempo_key,credito_key,geografia_key,aomod,aocta,aoope,aosbo,aotop,estado_key,ind_actins,
                                 AGENCIABN_KEY,ANALISTA_KEY,CAMPANIA_KEY,CLIENTE_KEY,
                                 CONVENIO_KEY,MODALIDAD_KEY,MONEDA_KEY,PRODUCTO_KEY,
                                 PRODUCTO_REG_KEY,SITUACION_KEY,TIPO_CREDITO_KEY,
                                 imp_ingreso_mn,imp_comision_mn,imp_ingccas_mn,imp_revpro_mn,
                                 imp_proesp_mn,imp_propro_mn,imp_proobl_mn,imp_provol_mn,imp_progso_mn,
                                 row_id,
                                 imp_ingreso_mn_ma,imp_comisio_mn_ma,imp_ingccas_mn_ma,
                                 imp_revpro_mn_ma,imp_proesp_mn_ma,imp_propro_mn_ma,
                                 imp_proobl_mn_ma,imp_provol_mn_ma,imp_progso_mn_ma
                                ) 
                         Values(x.tiempo_key,x.credito_key,x.geografia_key,0,x.aocta,x.aoope,0,0,x.estado_key,x.ind_actins,
                                Case When x.AGENCIABN_KEY = 0 Then 1 Else x.AGENCIABN_KEY End,
                                Case When x.ANALISTA_KEY = 0 Then 1316 Else x.ANALISTA_KEY End,
                                Case When x.CAMPANIA_KEY=0 Then 1 else x.CAMPANIA_KEY end,
                                Case When x.CLIENTE_KEY = 0 Then 1549761484 else x.CLIENTE_KEY end,
                                Case When x.CONVENIO_KEY = 0 Then 218 Else x.CONVENIO_KEY End,
                                x.MODALIDAD_KEY,
                                Case when x.MONEDA_KEY=0 and x.aomda=0 then 1  
                                     When x.MONEDA_KEY=0 and x.aomda=101 then 2 Else x.moneda_key End,
                                Case When x.PRODUCTO_KEY = 0 Then 37 Else x.PRODUCTO_KEY End,
                                x.PRODUCTO_REG_KEY,x.SITUACION_KEY,
                                Case When x.TIPO_CREDITO_KEY = 0 Then 19930 else x.TIPO_CREDITO_KEY End,     
                                x.imp_ingreso,x.imp_comision,x.imp_ingccas,x.imp_revpro,
                                x.imp_proesp,x.imp_propro,x.imp_proobl ,x.imp_provol,x.imp_progso,
                                seq_fact_activo.nextval,
                                x.imp_ingma,x.imp_comma,x.imp_casma,
                                x.imp_revma,x.imp_pesma,x.imp_pprma,
                                x.imp_pobma,x.imp_pvoma,x.imp_psbma
                               );      
           
     Commit;
        Exception When Others Then
            Null;
        End;
     End Loop;
 End SP_INS_SALDOS_ICP;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
Procedure SP_FACT_DEPAFPBONO
Is
Begin
     Execute Immediate 'truncate table fact_depAfpBono';
     Insert into fact_depAfpBono(des_nrodoc, des_nombre, cod_pgcod, cod_modcta, cod_succta, cod_mdacta, 
                   cod_papcta, cod_ctacte, cod_opecta, cod_sbocta, cod_topcta, cod_ccicta, 
                   des_nomafp, des_tipdep, ind_tipdep, fec_depuno, fec_depdos, fec_deptre, 
                   cnt_numdep, imp_totdep, des_estcta, fec_estcta, fec_finexo, imp_retdep, 
                   imp_disdep, fec_ultret, fec_ultcom, fec_insact)
      Select des_nrodoc, des_nombre, cod_pgcod, cod_modcta, cod_succta, cod_mdacta, 
                   cod_papcta, cod_ctacte, cod_opecta, cod_sbocta, cod_topcta, cod_ccicta, 
                   des_nomafp, des_tipdep, ind_tipdep, fec_depuno, fec_depdos, fec_deptre, 
                   cnt_numdep, imp_totdep, des_estcta, fec_estcta, fec_finexo, imp_retdep, 
                   imp_disdep, fec_ultret, fec_ultcom, fec_insact
      from dwstage.tmp_fact_depAfpBono;
      Commit;        
Exception When Others Then
   Null;
End SP_FACT_DEPAFPBONO;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Procedure sp_fact_base_Anexo17A_2022(PD_FECHA In Date)
Is
Begin
    -- Elimina Registros
    Begin
       Delete From fact_fsd_ctasclie o Where o.fecha = PD_FECHA;
       Commit;
    Exception When Others Then
       Null;
    End;
    
    -- Carga Colaboradores
    /*Begin
    pq_carga_facts.fact_fsd_colabco(PD_FECHA);
    Exception When Others Then
       Null;
    End;*/
    
    -- Carga Datos 
    Insert into fact_fsd_ctasclie(cliente_key, fecha, tiempo_key, pais, tdoc, ndoc, 
                                  cod_cliente, nom_cliente, cuentas_key, 
                                  aomda, aomod, aocta, aoope, aosbo, aotop, 
                                  key_segcta, abr_segcta, fec_apertura, num_titcta, dia_ape, num_dias, 
                                  saldo_mo, intgen_mon, salgar_mo, p_impsaldo, p_impinter, p_impgaran, 
                                  p_imp_fsd, p_int_fsd, p_gar_fsd, p_dii_fsd, ind_empbco, ind_dosrub, ind_estado, 
                                  cod_rubro, imp_tcam, imp_lfsd, sld_pdis, int_pdis, gar_pdis, sld_pdnc, int_pdnc, 
                                  gar_pdnc, sld_dtot, int_dtot, gar_dtot, cod_mdes, 
                                  sldc_fsd, intc_fsd, garc_fsd, sldn_fsd, intn_fsd, 
                                  garn_fsd, sldt_fsd, intt_fsd, gart_fsd, sld_anxs, 
                                  cod_denanx, moneda_key,int_anxs,gar_anxs,
                                  sld_anxc,int_anxc,gar_anxc,sld_anxn,int_anxn,gar_anxn,ind_tipcli
                                  ,key_motdes,ind_colemp
                                 ) 

    Select l.cliente_key,f.fecha,t.tiempo_key,f.pais,f.tdoc,f.ndoc,
           f.cod_cliente, nom_cliente,nvl(cuentas_key,1404121192) cuentas_key, 
           aomda,aomod,aocta,aoope,aosbo,aotop, 
           nvl(key_segcta,1) key_segcta, abr_segcta,fec_apertura,num_titcta, 
           dia_ape,num_dias,saldo_mo,intgen_mon,salgar_mo, 
           p_impsaldo,p_impinter,p_impgaran,p_imp_fsd,p_int_fsd,p_gar_fsd,p_dii_fsd, 
           ind_empbco,ind_dosrub,ind_estado,cod_rubro,imp_tcam,imp_lfsd,sld_pdis,int_pdis, 
           gar_pdis,sld_pdnc,int_pdnc,gar_pdnc,sld_dtot,int_dtot,gar_dtot,nvl(cod_mdes,'C00') cod_mdes,
           sldc_fsd,intc_fsd,garc_fsd,sldn_fsd,intn_fsd,garn_fsd,sldt_fsd,intt_fsd,gart_fsd, 
           nvl(sld_anxs,0) sld_anxs, nvl(cod_denanx,0) cod_denanx,m.moneda_key,nvl(f.int_anxs,0),
           nvl(f.gar_anxs,0),nvl(f.sld_anxc,0),nvl(f.int_anxc,0),nvl(f.gar_anxc,0),
           nvl(f.sld_anxn,0),nvl(f.int_anxn,0),nvl(f.gar_anxn,0),f.ind_tipcli,
           d.key_motdes,f.ind_colcaj
     from dwstage.tmp_tfact_fsd_clie f
     left join dwhouse.dm_cliente l on l.codigo_cliente=f.cod_cliente
     left Join dwhouse.dm_tiempo t on nvl(t.fecha,PD_FECHA)= f.fecha
     left Join dwhouse.dm_moneda m on m.codigo_moneda = to_char(f.aomda)
     left join dwhouse.dm_fsd_motdes d on nvl(d.cod_motdes,'C99') = f.cod_mdes
    Where t.fecha = PD_FECHA;
    
    Commit;
Exception When Others Then
   Null;
End sp_fact_base_Anexo17A_2022;            
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  PROCEDURE sp_seg_captaciones(PD_FECHA In Date)
  -----
  -- Fecha: 2021-10-31
  -- Autor: Paola Vargas
  -- Uso: detalle de aperturas y cancelaciones
  ------
  IS
     ld_fecha date := PD_FECHA;
     ln_exist number(10);
  BEGIN
        --- ELIMINA REGISTROS EXISTENTES
        Select count(*) Into ln_exist from dwhouse.FACT_PASIVO_APECAN where fecha = ld_fecha;
        IF ln_exist > 0 THEN
           DELETE from dwhouse.FACT_PASIVO_APECAN where fecha = ld_fecha;
           commit;
        End If;
        -- INSERTA
        BEGIN
            Insert into dwhouse.FACT_PASIVO_APECAN 
                       (fecha, tiempo_key, cuenta_key, cliente_key, producto_key, 
                        moneda_key, geografia_key, tipocli_key, estado_key, canal_key, usuario_key, empleador_key, 
                        saldo_mo, saldo_mn, ind_tipmov, ind_colcaj, ind_tiptit, ind_numtit, num_ctacte, cod_pais, 
                        cod_tdoc, cod_ndoc, val_tasa, val_plazo, cod_cuenta, cod_cueuni, fec_abrcta, fec_rencta, fec_cancta, 
                        imp_apecta, cod_producto, saldopos_mn, detcanal_key, key_tipseg
                       )
            Select fecha, tiempo_key, cuenta_key, cliente_key, producto_key, 
                   moneda_key, geografia_key, tipocli_key, estado_key, canal_key, usuario_key, empleador_key, 
                   saldo_mo, saldo_mn, ind_tipmov, ind_colcaj, ind_tiptit, ind_numtit, num_ctacte, cod_pais, 
                   cod_tdoc, cod_ndoc, val_tasa, val_plazo, cod_cuenta, cod_cueuni, fec_abrcta, fec_rencta, fec_cancta, 
                   imp_apecta, cod_producto, saldopos_mn, detcanal_key, key_tipseg
              from dwstage.TMP_FACT_PASIVO_APECAN 
             Where fecha = ld_fecha;   
            Commit;
         EXCEPTION WHEN OTHERS THEN
             Null;
         END;    
  END sp_seg_captaciones;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  PROCEDURE SP_7_ESTRUCT_ANEXO17A(PD_FECHA IN DATE)
  --- Fecha: 2022.05.12
  --- Autor: Paola Vargas
  --- Uso  : Siete estructuras de FSD Anexo17A - Normativa vigente 2022
  IS
    ld_fecha date := PD_FECHA;
    --lv_fecha varchar2(10) := to_char(ld_fecha,'rrrrmmdd');
    ln_perio number(8) := to_number(to_char(ld_fecha,'rrrrmm'));
    ln_exist number(5);
  BEGIN
      -- 1.Maestro de clientes
      select count(*) Into ln_exist 
        from dba_tab_partitions t 
        where t.table_name = 'DM_FSD_MAESTRO_CLIE' and t.partition_name = 'DM_FSD_MAESTRO_CLIE_'||ln_perio;
      If ln_exist > 0 Then
         Execute Immediate 'ALTER TABLE DM_FSD_MAESTRO_CLIE DROP PARTITION DM_FSD_MAESTRO_CLIE_'||ln_perio;
      End If;
      Execute Immediate 'ALTER TABLE DM_FSD_MAESTRO_CLIE ADD PARTITION DM_FSD_MAESTRO_CLIE_'||ln_perio||' values('||ln_perio||')';
      
      Insert Into DM_FSD_MAESTRO_CLIE(fecha,codigocliente,tipo_contraparte,
                                      fines_lucro,juridica_privada,tipo_cliente,replegal_apod,PERIODO)
      Select fecha,codigocliente,tipo_contraparte,fines_lucro,juridica_privada,
             tipo_cliente,replegal_apod,ln_perio
        From dwstage.tmp_DM_FSD_MAESTRO_CLIE Where fecha = ld_fecha;
      Commit;
      
      -- 2.Clientes excluidos
      select count(*) Into ln_exist 
        from dba_tab_partitions t 
        where t.table_name = 'DM_FSD_CLIENTES_EXC' and t.partition_name = 'DM_FSD_CLIENTES_EXC_'||ln_perio;
      If ln_exist > 0 Then
         Execute Immediate 'ALTER TABLE DM_FSD_CLIENTES_EXC DROP PARTITION DM_FSD_CLIENTES_EXC_'||ln_perio;
      End If;
      Execute Immediate 'ALTER TABLE DM_FSD_CLIENTES_EXC ADD PARTITION DM_FSD_CLIENTES_EXC_'||ln_perio||' values('||ln_perio||')';
      
      Insert INTO DM_FSD_CLIENTES_EXC(fecha,codigocliente,dir_ger_2anios,partic_por,
                                      colab_confianza,pers_vinculado,emp_miembro_fsd,PERIODO) 
      Select fecha,codigocliente,dir_ger_2anios,partic_por,colab_confianza,pers_vinculado,
             emp_miembro_fsd,ln_perio
        from dwstage.tmp_DM_FSD_CLIENTES_EXC Where fecha = ld_fecha; 
      Commit;
      
      -- 3.Maestro de Depositos
      select count(*) Into ln_exist 
        from dba_tab_partitions t 
        where t.table_name = 'DM_FSD_MAESTRO_DEP' and t.partition_name = 'DM_FSD_MAESTRO_DEP_'||ln_perio;
      If ln_exist > 0 Then
         Execute Immediate 'ALTER TABLE DM_FSD_MAESTRO_DEP DROP PARTITION DM_FSD_MAESTRO_DEP_'||ln_perio;
      End If;
      Execute Immediate 'ALTER TABLE DM_FSD_MAESTRO_DEP ADD PARTITION DM_FSD_MAESTRO_DEP_'||ln_perio||' values('||ln_perio||')';
      
      Insert INTO DM_FSD_MAESTRO_DEP(Fecha,Ctadeposito,Tipo_Cuenta,Num_Mancomunos,Tipo_Deposito,
                                     Moneda,Disposicion_Libre,Motivo_No_Dispo_Libre,PERIODO,cuentas_key)
      Select Fecha,Ctadeposito,Tipo_Cuenta,Num_Mancomunos,Tipo_Deposito,Moneda,Disposicion_Libre,
             Motivo_No_Dispo_Libre,ln_perio,cuentas_key
        from dwstage.tmp_DM_FSD_MAESTRO_DEP Where fecha = ld_fecha;
      Commit;
      
      -- 4.Saldos de Depositos
      select count(*) Into ln_exist 
        from dba_tab_partitions t 
        where t.table_name = 'DM_FSD_SALDOS_DEP' and t.partition_name = 'DM_FSD_SALDOS_DEP_'||ln_perio;
      If ln_exist > 0 Then
         Execute Immediate 'ALTER TABLE DM_FSD_SALDOS_DEP DROP PARTITION DM_FSD_SALDOS_DEP_'||ln_perio;
      End If;
      Execute Immediate 'ALTER TABLE DM_FSD_SALDOS_DEP ADD PARTITION DM_FSD_SALDOS_DEP_'||ln_perio||' values('||ln_perio||')';
      
      INSERT INTO DM_FSD_SALDOS_DEP(fecha,ctadeposito,mes,saldo,interes,rubro,cuentas_key,TIPCAM)
      select fecha,ctadeposito,mes,saldo,interes,rubro,cuentas_key,tipcam
      from dwstage.tmp_DM_FSD_SALDOS_DEP Where fecha = ld_fecha; 
      Commit;
      
      -- 5.Clientes - Depositos
      select count(*) Into ln_exist 
        from dba_tab_partitions t 
        where t.table_name = 'DM_FSD_CLIENTE_DEP' and t.partition_name = 'DM_FSD_CLIENTE_DEP_'||ln_perio;
      If ln_exist > 0 Then
         Execute Immediate 'ALTER TABLE DM_FSD_CLIENTE_DEP DROP PARTITION DM_FSD_CLIENTE_DEP_'||ln_perio;
      End If;
      Execute Immediate 'ALTER TABLE DM_FSD_CLIENTE_DEP ADD PARTITION DM_FSD_CLIENTE_DEP_'||ln_perio||' values('||ln_perio||')';
      
      INSERT INTO  DM_FSD_CLIENTE_DEP(fecha,codigo_cliente,ctadeposito,PERIODO,cuentas_key)
      Select fecha,codigo_cliente,ctadeposito,ln_perio,cuentas_key 
        From dwstage.tmp_DM_FSD_CLIENTE_DEP
      Where fecha = ld_fecha; 
      Commit;
      
      -- 6.Maestro de CTS
      select count(*) Into ln_exist 
        from dba_tab_partitions t 
        where t.table_name = 'DM_FSD_MAESTRO_CTS' and t.partition_name = 'DM_FSD_MAESTRO_CTS_'||ln_perio;
      If ln_exist > 0 Then
         Execute Immediate 'ALTER TABLE DM_FSD_MAESTRO_CTS DROP PARTITION DM_FSD_MAESTRO_CTS_'||ln_perio;
      End If;
      Execute Immediate 'ALTER TABLE DM_FSD_MAESTRO_CTS ADD PARTITION DM_FSD_MAESTRO_CTS_'||ln_perio||' values('||ln_perio||')';
      
      INSERT INTO  DM_FSD_MAESTRO_CTS(fecha,codigo_cliente,ctadeposito,moneda,bloqueo,
                                      detalle_bloqueo,fecha_apertura,empleador,PERIODO,cuentas_key) 
      Select fecha,codigo_cliente,ctadeposito,moneda,bloqueo,detalle_bloqueo,
             fecha_apertura,empleador,ln_perio,cuentas_key
        From dwstage.tmp_DM_FSD_MAESTRO_CTS
       Where fecha = ld_fecha;   
      Commit;
      
      -- 7.Saldos de CTS
      select count(*) Into ln_exist 
        from dba_tab_partitions t 
        where t.table_name = 'DM_FSD_SALDOS_CTS' and t.partition_name = 'DM_FSD_SALDOS_CTS_'||ln_perio;
      If ln_exist > 0 Then
         Execute Immediate 'ALTER TABLE DM_FSD_SALDOS_CTS DROP PARTITION DM_FSD_SALDOS_CTS_'||ln_perio;
      End If;
      Execute Immediate 'ALTER TABLE DM_FSD_SALDOS_CTS ADD PARTITION DM_FSD_SALDOS_CTS_'||ln_perio||' values('||ln_perio||')';
      
      INSERT INTO DM_FSD_SALDOS_CTS(fecha,ctadeposito,mes,saldo,interes,rubro,cuentas_key,TIPCAM)
      Select fecha,ctadeposito,mes,saldo,interes,rubro,cuentas_key,tipcam
        From dwstage.tmp_DM_FSD_SALDOS_CTS
       Where fecha = ld_fecha;   
      Commit;
  
  EXCEPTION WHEN OTHERS THEN
      NULL;      
  END SP_7_ESTRUCT_ANEXO17A;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  Procedure sp_fact_base_Anexo17A_new(PD_FECHA In Date)
  Is
    ln_timkey number(10) := pq_carga_facts.fn_tiempo_key(PD_FECHA);
    lv_fecha  varchar2(10) := to_char(PD_FECHA,'rrrrmmdd');
    ln_existe number(3);
    lv_exec   varchar2(1000);
  Begin
       -- REVISA PARTICION
       lv_exec := 'select count(*) from dba_tab_partitions where table_name = ''FACT_FSD_CTASCLIE'' and '||
                  ' partition_name = ''FACT_FSD_MES_'||lv_fecha||'''';

      Execute Immediate lv_exec Into ln_existe;
      
      If ln_existe = 0 then
         lv_exec := 'alter table FACT_FSD_CTASCLIE add partition FACT_FSD_MES_'||lv_fecha||
                     ' values('||ln_timkey||')';
          Execute Immediate lv_exec;
      Else
          Execute Immediate 'Alter table FACT_FSD_CTASCLIE TRUNCATE PARTITION FACT_FSD_MES_'||
                            lv_fecha||' UPDATE INDEXES';  
     End If;
     
      -- Carga Colaboradores
      Begin
      pq_carga_facts.fact_fsd_colabco(PD_FECHA);
      Exception When Others Then
         Null;
      End;
      
      -- Carga Datos 
      Insert /*+ APPEND PARALELL(5)*/
      Into FACT_FSD_CTASCLIE(cliente_key, fecha, tiempo_key, pais, tdoc, ndoc, 
                                  cod_cliente, nom_cliente, cuentas_key, 
                                  aomda, aomod, aocta, aoope, aosbo, aotop, 
                                  key_segcta, abr_segcta, fec_apertura, num_titcta, dia_ape, num_dias, 
                                  saldo_mo, intgen_mon, salgar_mo, p_impsaldo, p_impinter, p_impgaran, 
                                  p_imp_fsd, p_int_fsd, p_gar_fsd, p_dii_fsd, ind_empbco, ind_dosrub, ind_estado, 
                                  cod_rubro, imp_tcam, imp_lfsd, sld_pdis, int_pdis, gar_pdis, sld_pdnc, int_pdnc, 
                                  gar_pdnc, sld_dtot, int_dtot, gar_dtot, cod_mdes, 
                                  sldc_fsd, intc_fsd, garc_fsd, sldn_fsd, intn_fsd, 
                                  garn_fsd, sldt_fsd, intt_fsd, gart_fsd, sld_anxs, 
                                  cod_denanx, moneda_key,int_anxs,gar_anxs,
                                  sld_anxc,int_anxc,gar_anxc,sld_anxn,int_anxn,gar_anxn,ind_tipcli
                                  ,key_motdes,ind_colemp,fecha_cancela, ind_menore, ind_tiptit, 
                                  ind_titpri_sorfy, c_numcta,cod_cuenta, ind_tipdep
                                 ) 

          Select l.cliente_key,f.fecha,t.tiempo_key,f.pais,f.tdoc,f.ndoc,
                 f.cod_cliente, nom_cliente,nvl(cuentas_key,1404121192) cuentas_key, 
                 aomda,aomod,aocta,aoope,aosbo,aotop, 
                 nvl(key_segcta,1) key_segcta, abr_segcta,fec_apertura,num_titcta, 
                 dia_ape,num_dias,saldo_mo,intgen_mon,salgar_mo, 
                 p_impsaldo,p_impinter,p_impgaran,p_imp_fsd,p_int_fsd,p_gar_fsd,p_dii_fsd, 
                 ind_empbco,ind_dosrub,ind_estado,cod_rubro,imp_tcam,imp_lfsd,sld_pdis,int_pdis, 
                 gar_pdis,sld_pdnc,int_pdnc,gar_pdnc,sld_dtot,int_dtot,gar_dtot,nvl(cod_mdes,'C00') cod_mdes,
                 sldc_fsd,intc_fsd,garc_fsd,sldn_fsd,intn_fsd,garn_fsd,sldt_fsd,intt_fsd,gart_fsd, 
                 nvl(sld_anxs,0) sld_anxs, nvl(cod_denanx,0) cod_denanx,m.moneda_key,nvl(f.int_anxs,0),
                 nvl(f.gar_anxs,0),nvl(f.sld_anxc,0),nvl(f.int_anxc,0),nvl(f.gar_anxc,0),
                 nvl(f.sld_anxn,0),nvl(f.int_anxn,0),nvl(f.gar_anxn,0),f.ind_tipcli,
                 d.key_motdes,f.ind_colcaj,fecha_cancela, ind_menore, ind_tiptit, 
                 ind_titpri_sorfy, c_numcta,f.cod_cuenta,f.ind_tipdep
           from dwstage.tmp_tfact_fsd_clie f
           left join dwhouse.dm_cliente l on l.codigo_cliente=f.cod_cliente
           left Join dwhouse.dm_tiempo t on nvl(t.fecha,PD_FECHA)= f.fecha
           left Join dwhouse.dm_moneda m on m.codigo_moneda = to_char(f.aomda)
           left join dwhouse.dm_fsd_motdes d on nvl(d.cod_motdes,'C99') = f.cod_mdes
          Where t.fecha = PD_FECHA;
          Commit;
  Exception When Others Then
     Null;
  End sp_fact_base_Anexo17A_new;            
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_limite_age(PN_CODSUC In Number)
  Return Number
  -- 2023.09.13
  -- Retorna importe límite asegurado de agencia
  Is
    ln_limsuc number(12,2);
  Begin
    Begin  
       Select lim_asedol 
         Into ln_limsuc
         From dm_geografia 
        where cod_sucurs = PN_CODSUC 
          and tipo_region = 'R';
    Exception When Others Then
        ln_limsuc := 0;
    End;            
    Return ln_limsuc;
  End fn_limite_age;    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_fsd_anexo17A_credinka (PD_FECHA In Date, PN_TIPPRO In Number)
  Is
  Begin
     -- Elimina Registros
     Begin
         Delete from fact_fsd_anexos Where fecha = PD_FECHA and ind_proceso = PN_TIPPRO;
         Commit;
     Exception When Others Then
        Null;
     End;
     
     -- Inserta Registros
     Insert Into fact_fsd_anexos
                (tiempo_key,fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                 imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,ind_proceso,
                 tipo_cambio)  
      select t.tiempo_key,f.fecha,f.cod_anexo,f.ord_conane,f.rub_conane,f.des_conane,
             f.imp_soles,f.imp_dolar,f.cta_soles,f.cta_dolar,f.cta_nueva,f.ind_proceso,f.imp_tcam  
        from dwstage.tmp_fact_fsd_anexos f
        join dwhouse.dm_tiempo t on t.fecha=f.fecha
       where f.fecha = PD_FECHA
         and ind_proceso = PN_TIPPRO;
     Commit;
  Exception When Others Then
    Null;
  End sp_fsd_anexo17A_credinka;           
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  Procedure sp_fact_base_Anexo17A_credinka(PD_FECHA In Date)
  Is
    ln_timkey number(10)   := pq_carga_facts.fn_tiempo_key(PD_FECHA);
    lv_fecha  varchar2(10) := to_char(PD_FECHA,'rrrrmmdd');
    ln_existe number(3);
    lv_exec   varchar2(1000);
    nTipPro   Number(1) := 4;
    vErrMsg   Varchar2(250);
  Begin
       -- REVISA PARTICION
       lv_exec := 'select count(*) from dba_tab_partitions where table_name = ''FACT_FSD_CTASCLIE'' and '||
                  ' partition_name = ''FACT_FSD_MES_'||lv_fecha||'''';

      Execute Immediate lv_exec Into ln_existe;
      
      If ln_existe = 0 then
         lv_exec := 'alter table FACT_FSD_CTASCLIE add partition FACT_FSD_MES_'||lv_fecha||
                     ' values('||ln_timkey||')';
          Execute Immediate lv_exec;
      Else
          Execute Immediate 'DELETE FROM FACT_FSD_CTASCLIE PARTITION(FACT_FSD_MES_'||lv_fecha||') WHERE NVL(INDPRO,0) = 4';  
          Commit;
     End If;
     
      -- Carga Datos 
      Insert /*+ APPEND PARALELL(5)*/
      Into FACT_FSD_CTASCLIE(cliente_key, fecha, tiempo_key, pais, tdoc, ndoc, 
                                  cod_cliente, nom_cliente, cuentas_key, 
                                  aomda, aomod, aocta, aoope, aosbo, aotop, 
                                  key_segcta, abr_segcta, fec_apertura, num_titcta, dia_ape, num_dias, 
                                  saldo_mo, intgen_mon, salgar_mo, p_impsaldo, p_impinter, p_impgaran, 
                                  p_imp_fsd, p_int_fsd, p_gar_fsd, p_dii_fsd, ind_empbco, ind_dosrub, ind_estado, 
                                  cod_rubro, imp_tcam, imp_lfsd, sld_pdis, int_pdis, gar_pdis, sld_pdnc, int_pdnc, 
                                  gar_pdnc, sld_dtot, int_dtot, gar_dtot, cod_mdes, 
                                  sldc_fsd, intc_fsd, garc_fsd, sldn_fsd, intn_fsd, 
                                  garn_fsd, sldt_fsd, intt_fsd, gart_fsd, sld_anxs, 
                                  cod_denanx, moneda_key,int_anxs,gar_anxs,
                                  sld_anxc,int_anxc,gar_anxc,sld_anxn,int_anxn,gar_anxn,ind_tipcli
                                  ,key_motdes,ind_colemp,fecha_cancela, ind_menore, ind_tiptit, 
                                  ind_titpri_sorfy, c_numcta,cod_cuenta, ind_tipdep,
                                  Indpro,Rubro
                                 ) 

          Select nvl(c.cliente_key,1549761484),f.fecha,t.tiempo_key,f.pais,f.tdoc,f.ndoc,
                 f.cod_cliente, nom_cliente,nvl(cuentas_key,1404121192) cuentas_key, 
                 aomda,aomod,aocta,aoope,aosbo,aotop, 
                 nvl(key_segcta,1) key_segcta, abr_segcta,fec_apertura,num_titcta, 
                 dia_ape,num_dias,saldo_mo,intgen_mon,salgar_mo, 
                 p_impsaldo,p_impinter,p_impgaran,p_imp_fsd,p_int_fsd,p_gar_fsd,p_dii_fsd, 
                 ind_empbco,ind_dosrub,ind_estado,cod_rubro,imp_tcam,imp_lfsd,sld_pdis,int_pdis, 
                 gar_pdis,sld_pdnc,int_pdnc,gar_pdnc,sld_dtot,int_dtot,gar_dtot,nvl(cod_mdes,'C00') cod_mdes,
                 sldc_fsd,intc_fsd,garc_fsd,sldn_fsd,intn_fsd,garn_fsd,sldt_fsd,intt_fsd,gart_fsd, 
                 nvl(sld_anxs,0) sld_anxs, nvl(cod_denanx,0) cod_denanx,m.moneda_key,nvl(f.int_anxs,0),
                 nvl(f.gar_anxs,0),nvl(f.sld_anxc,0),nvl(f.int_anxc,0),nvl(f.gar_anxc,0),
                 nvl(f.sld_anxn,0),nvl(f.int_anxn,0),nvl(f.gar_anxn,0),f.ind_tipcli,
                 d.key_motdes,f.ind_colcaj,fecha_cancela, ind_menore, ind_tiptit, 
                 ind_titpri_sorfy, c_numcta,f.cod_cuenta,f.ind_tipdep,
                 nTipPro,rubro
           from dwstage.TMP_FACT_FSDCLIE_CREDINKA f
           left join dwhouse.dm_cliente c on c.codigo_cliente = f.cod_cliente
           left Join dwhouse.dm_tiempo t on nvl(t.fecha,PD_FECHA)= f.fecha
           left Join dwhouse.dm_moneda m on m.codigo_moneda = to_char(f.aomda)
           left join dwhouse.dm_fsd_motdes d on nvl(d.cod_motdes,'C99') = f.cod_mdes
          Where t.fecha = PD_FECHA;
          Commit;
  Exception When Others Then
     vErrMsg := substr(sqlerrm,1,200);
  End sp_fact_base_Anexo17A_credinka;            
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 


End PQ_CARGA_FACTS;
/
