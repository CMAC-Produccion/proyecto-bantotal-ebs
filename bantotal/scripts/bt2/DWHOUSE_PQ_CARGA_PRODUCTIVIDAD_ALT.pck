create or replace package dwhouse.PQ_CARGA_PRODUCTIVIDAD is

  -- Author  : PVARGAS
  -- Created : 16/07/2021 04:12:30 p.m.
  -- Purpose : 
  -- Modificaciones
  -- Fecha   : 15/04/2022 09:05:35 a.m.
  -- Autor   : Paola Vargas
  
  PROCEDURE SP_CARGA_PRODINC(PD_FECHA In Date);
  PROCEDURE SP_PRODINC_DIARIO(PD_FECHA In Date);
  PROCEDURE SP_PRODINC_RESMES(PD_FECHA In Date);
  PROCEDURE SP_PRODINC_RETENCION(PD_FECHA In date);
  Procedure SP_PRODINC_GERENNEGO(PD_FECHA In Date);
  Procedure fact_pasivos_proase (PD_FECHA In DAte);
  Procedure fact_pasivos_proase_v2 (PD_FECHA In DAte);
  
  ------
  PROCEDURE SP_PRODINC_RESMES_V2023(PD_FECHA In Date);
  PROCEDURE SP_CARGA_PRODINC_V2023(PD_FECHA In Date);
  ------
  
end PQ_CARGA_PRODUCTIVIDAD;
/
create or replace package body dwhouse.PQ_CARGA_PRODUCTIVIDAD is
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  PROCEDURE SP_CARGA_PRODINC(PD_FECHA In Date)
  IS
  Begin
      PQ_CARGA_PRODUCTIVIDAD.SP_PRODINC_DIARIO(PD_FECHA);
      PQ_CARGA_PRODUCTIVIDAD.SP_PRODINC_RESMES(PD_FECHA);
      PQ_CARGA_PRODUCTIVIDAD.SP_PRODINC_GERENNEGO(PD_FECHA);
  END SP_CARGA_PRODINC;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  PROCEDURE SP_PRODINC_DIARIO(PD_FECHA In Date)
  Is 
     ld_fecha date := to_date(to_char(PD_FECHA,'rrrrmm')||'01','rrrrmmdd');
     ln_tiempo number(10) := PQ_CARGA_FACTS.fn_tiempo_key(ld_fecha);
  BEGIN
     --- CARGA DETALLE
     --Select max(tiempo_key) Into ln_tiempo From dwstage.TMP_FACT_PASIVO_PRODINC;
     DELETE FROM dwhouse.FACT_PASIVO_PRODINC where tiempo_key = ln_tiempo;
     commit;
     
     Insert Into dwhouse.FACT_PASIVO_PRODINC(tiempo_key, cliente_key, producto_key, geografia_key, cuenta_key, 
                                        empleador_key, saldo_base_mn, tiempo_sld_key, saldo_avan_mn, 
                                        fec_proceso, ind_finmes, ind_tipinc, cod_ejeaho, cod_anacre, 
                                        analista_key, imp_tragob, cod_tipage, regionop_key, imp_meta_aho, 
                                        imp_meta_dpf, imp_meta_cts, ind_permet, cod_opeape, des_trxape, 
                                        geoape_key, geoape_desc, fec_aperen, ind_tipape, cod_usuage, 
                                        fec_regage, imp_desemb, des_tipana, ind_anainc, ageana_key, 
                                        imp_bonafp_mant, imp_desemb_mant,cod_producto,fec_saldo,
                                        cod_asecre,asecre_key,
                                        ind_numtit,ind_regcli,fec_regcli,cod_usureg,pais,tdoc,ndoc,cuenta)
    SELECT tiempo_key, cliente_key, producto_key, geografia_key, cuenta_key, 
          empleador_key, saldo_base_mn, tiempo_sld_key, saldo_avan_mn, 
          fec_proceso, ind_finmes, ind_tipinc, cod_ejeaho, cod_anacre, 
          analista_key, imp_tragob, cod_tipage, regionop_key, imp_meta_aho, 
          imp_meta_dpf, imp_meta_cts, ind_permet, cod_opeape, des_trxape, 
          geoape_key, geoape_desc, fec_aperen, ind_tipape, cod_usuage, 
          fec_regage, imp_desemb, nvl(des_tipana,'NO CLASIFICADO'), ind_anainc, ageana_key, 
          imp_bonafp_mant, imp_desemb_mant,
           (select w.codigo_producto from dwhouse.dm_producto w where w.producto_key =  y.producto_key ),
          fec_saldo,cod_asecre,asecre_key,
          ind_numtit,ind_regcli,fec_regcli,cod_usureg,pais,tdoc,ndoc,aocta
     FROM dwstage.TMP_FACT_PASIVO_PRODINC y
    where tiempo_key = ln_tiempo;
    Commit;
    ------------------
    --- CARGA RESUMEN
    ------------------
    delete from dwhouse.FACT_PASIVO_PRODINC_META where tiempo_key = ln_tiempo;
    commit;
    
    --- AGENCIAS
    Insert Into dwhouse.FACT_PASIVO_PRODINC_META(tiempo_key,codigo_producto,geografia_key,regionop_key,imp_meta,
                                                 cod_tipage,ind_tipmet,analista_key,des_tipana,fec_saldo,imp_sdometa,
                                                 imp_sdobaso,imp_sdoavao,imp_sdometat)
    select tiempo_key,u.codigo_producto,u.geografia_key,u.regionop_key,u.imp_meta,u.cod_tipage,u.ind_tipmet,
         '0','NO CLASIFICADO',u.fec_saldo,u.imp_sdometa,u.imp_sdobaso,u.imp_sdoavao,u.imp_sdometat
   from dwstage.tmp_fact_pasivo_prodinc_metas u where ind_tipmet = 1 and tiempo_key = ln_tiempo;
       
       /* SELECT TIEMPO_KEY,'21',GEOGRAFIA_KEY,REGIONOP_KEY,
                      max(nvl(P.IMP_META_AHO,0)),
                      p.cod_tipage,1 ind_tipmet,
                      0,'NO CLASIFICADO',p.fec_saldo
        FROM dwstage.TMP_FACT_PASIVO_PRODINC P
         Where p.ind_tipinc = 1  and tiempo_key = ln_tiempo
        Group by TIEMPO_KEY,GEOGRAFIA_KEY,REGIONOP_KEY ,p.cod_tipage,p.fec_saldo
        UNION ALL
      SELECT TIEMPO_KEY,'211',GEOGRAFIA_KEY,REGIONOP_KEY,
                    max(nvl(P.IMP_META_CTS,0)),
                    p.cod_tipage,1 ind_tipmet,
                    0,'NO CLASIFICADO',p.fec_saldo
      FROM dwstage.TMP_FACT_PASIVO_PRODINC P
       Where p.ind_tipinc = 1 and tiempo_key = ln_tiempo
      Group by TIEMPO_KEY,GEOGRAFIA_KEY,REGIONOP_KEY ,p.cod_tipage,p.fec_saldo
      UNION ALL
      SELECT TIEMPO_KEY,'22',GEOGRAFIA_KEY,REGIONOP_KEY,
                    max(nvl(P.IMP_META_DPF,0)),
                    p.cod_tipage,1 ind_tipmet,
                    0,'NO CLASIFICADO',p.fec_saldo
      FROM dwstage.TMP_FACT_PASIVO_PRODINC P
       Where p.ind_tipinc = 1 and tiempo_key = ln_tiempo
      Group by TIEMPO_KEY,GEOGRAFIA_KEY,REGIONOP_KEY ,p.cod_tipage,p.fec_saldo;
      */
      Commit;
      
      --- ANALISTAS
      delete from dwhouse.FACT_PASIVO_PRODINC_META where tiempo_key = ln_tiempo and IND_TIPMET=2; 
      commit;
      Insert Into FACT_PASIVO_PRODINC_META(TIEMPO_KEY,CODIGO_PRODUCTO,GEOGRAFIA_KEY,REGIONOP_KEY,IMP_META,IND_TIPMET,
               ANALISTA_KEY,DES_TIPANA,FEC_SALDO)                                                            
        select distinct tiempo_key,'21',ageana_key,REGIONOP_KEY,p.imp_meta_aho,
               2,analista_key,NVL(p.des_tipana,'NO CLASIFICADO'),fec_saldo
         FROM dwstage.TMP_FACT_PASIVO_PRODINC P
       Where p.ind_tipinc in (2,5) and tiempo_key = ln_tiempo
       UNION ALL  
        select distinct tiempo_key,'22',ageana_key,REGIONOP_KEY,p.imp_meta_dpf,
               2,analista_key,NVL(p.des_tipana,'NO CLASIFICADO'),fec_saldo
         FROM dwstage.TMP_FACT_PASIVO_PRODINC P
       Where p.ind_tipinc in (2,5) and tiempo_key = ln_tiempo ;     
      Commit;
      
      --- ANALISTAS
 
     /* Insert Into fact_pasivo_prodinc_res(tiempo_key,geografia_key,analista_key,des_tipana,
                                           fec_saldo,cod_producto,imp_capdep,ind_tipmet)
       Select tiempo_key,geografia_key,analista_key,des_tipana,
                                           fec_saldo,cod_producto,imp_capdep,ind_tipmet
       FROM dwstage.tmp_fact_pasivo_prodinc_res P
       Where p.ind_tipmet in (2,7) and tiempo_key = ln_tiempo ; 
       Commit;*/
      
  END SP_PRODINC_DIARIO;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --         
  PROCEDURE SP_PRODINC_RESMES(PD_FECHA In Date)
  Is 
     ld_fecha date := to_date(to_char(PD_FECHA,'rrrrmm')||'01','rrrrmmdd');
     ln_tiempo number(10) := PQ_CARGA_FACTS.fn_tiempo_key(ld_fecha);
  BEGIN       
      ----------------------------
      ----- RESULTADO MENSUAL/PAGO
      ----------------------------
      --Select max(tiempo_key) Into ln_tiempo From dwstage.tmp_fact_pasivo_prodinc_res;
      DELETE FROM fact_pasivo_prodinc_res where tiempo_key = ln_tiempo;
      commit;
     
      --Delete From fact_pasivo_prodinc_res Where tiempo_key = ln_tiempo;
      --Commit;
      
      Insert Into fact_pasivo_prodinc_res(tiempo_key, geografia_key, regionop_key, cod_tipage, ind_tipmet, analista_key, 
      des_tipana, fec_saldo, imp_metcts, imp_metaho, imp_metdpf, imp_bascts, imp_basaho, imp_basdpf, imp_avacts, 
      imp_avaaho, imp_avadpf, imp_logcts, imp_logaho, imp_logdpf, por_logcts, por_logaho, por_logdpf, ind_logtod, 
      ind_logpes, ind_logacu, por_pesaho, por_pesdpc, por_logacum, rnk_logage, por_imppago, des_motrnk, ageana_key,
      imp_pagomes,cod_producto,imp_capdep,imp_sdometaho,imp_sdometdpf,imp_sdometcts,
      cod_zona,des_zona,cod_region,des_region,imp_capret,ind_regcap,por_ahomes1,por_ahomes2,por_ahomes3,
      por_dpfmes1,por_dpfmes2,por_dpfmes3,por_ctsmes1,por_ctsmes2,por_ctsmes3
      )
      select tiempo_key, geografia_key, regionop_key, cod_tipage, ind_tipmet, analista_key, 
      des_tipana, fec_saldo, imp_metcts, imp_metaho, imp_metdpf, imp_bascts, imp_basaho, imp_basdpf, imp_avacts, 
      imp_avaaho, imp_avadpf, imp_logcts, imp_logaho, imp_logdpf, por_logcts, por_logaho, por_logdpf, ind_logtod, 
      ind_logpes, ind_logacu, por_pesaho, por_pesdpc, por_logacum, rnk_logage, por_imppago, des_motrnk, geografia_key,
      imp_pagmes,cod_producto,imp_capdep,imp_sdometaho,imp_sdometdpf,imp_sdometcts,
      cod_zona,des_zona,cod_region,des_region,imp_capret,nvl(ind_regcap,0),por_ahomes1,por_ahomes2,por_ahomes3,
      por_dpfmes1,por_dpfmes2,por_dpfmes3,por_ctsmes1,por_ctsmes2,por_ctsmes3
      From dwstage.tmp_fact_pasivo_prodinc_res u 
      Where tiempo_key = ln_tiempo;
      Commit;
    
                                
      Update fact_pasivo_prodinc_res y set des_motrnk = (case when y.ind_logtod = 1 Then 'Cumple Metas'
                                                          when y.ind_logtod = 0 and y.ind_logpes =1 Then 'Pesos Producto'
                                                          when y.ind_logtod = 0 and y.ind_logpes = 0 and y.por_logacum > 0 Then
                                                           'Saldos acumulados'
                                                          else ' ' 
                                                     end)     
      Where y.ind_tipmet = 1
      and tiempo_key = ln_tiempo;
      Commit;
      
      Update fact_pasivo_prodinc_res y set des_motrnk = (case when y.ind_logtod = 1 Then 'Cumple Metas'
                                                              when y.ind_logtod = 0 and y.por_logacum > 0 Then 'Saldos acumulados'
                                                              else ' ' 
                                                         end)     
      Where y.ind_tipmet = 2
      and tiempo_key = ln_tiempo;
      Commit;
  
      Update fact_pasivo_prodinc_res d set d.ageana_key = d.geografia_key 
      where ind_tipmet = 2 and tiempo_key = ln_tiempo;
      Commit;
      
  End SP_PRODINC_RESMES;    
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  PROCEDURE SP_PRODINC_RETENCION(PD_FECHA In date)
  Is
     ld_fecha date := to_date(to_char(add_months(PD_FECHA,-1),'rrrrmm')||'01','rrrrmmdd');
     ln_tiempo number(10) := PQ_CARGA_FACTS.fn_tiempo_key(ld_fecha);
  BEGIN
     --- CARGA DETALLE
     DELETE FROM dwhouse.FACT_PASIVO_PRODINC where tiempo_key = ln_tiempo and ind_tipinc in (2,7);
     commit;
     
     Insert Into dwhouse.FACT_PASIVO_PRODINC(tiempo_key, cliente_key, producto_key, geografia_key, cuenta_key, 
                                        empleador_key, saldo_base_mn, tiempo_sld_key, saldo_avan_mn, 
                                        fec_proceso, ind_finmes, ind_tipinc, cod_ejeaho, cod_anacre, 
                                        analista_key, imp_tragob, cod_tipage, regionop_key, imp_meta_aho, 
                                        imp_meta_dpf, imp_meta_cts, ind_permet, cod_opeape, des_trxape, 
                                        geoape_key, geoape_desc, fec_aperen, ind_tipape, cod_usuage, 
                                        fec_regage, imp_desemb, des_tipana, ind_anainc, ageana_key, 
                                        imp_bonafp_mant, imp_desemb_mant,cod_producto,fec_saldo,
                                        cod_asecre,asecre_key,
                                        ind_numtit,ind_regcli,fec_regcli,cod_usureg,pais,tdoc,ndoc,cuenta,
                                        saldo_reten_mn,fec_sldren)
        SELECT tiempo_key, nvl(cliente_key,1549761484), nvl(producto_key,37), 
               geografia_key, nvl(cuenta_key, 1404121192),
              empleador_key, saldo_base_mn, tiempo_sld_key, saldo_avan_mn, 
              fec_proceso, ind_finmes, ind_tipinc, cod_ejeaho, cod_anacre, 
              analista_key, imp_tragob, cod_tipage, regionop_key, imp_meta_aho, 
              imp_meta_dpf, imp_meta_cts, ind_permet, cod_opeape, des_trxape, 
              geoape_key, geoape_desc, fec_aperen, ind_tipape, cod_usuage, 
              fec_regage, imp_desemb, nvl(des_tipana,'NO CLASIFICADO'), ind_anainc, ageana_key, 
              imp_bonafp_mant, imp_desemb_mant,
               (select w.codigo_producto from dwhouse.dm_producto w where w.producto_key =  y.producto_key ),
              fec_saldo,cod_asecre,asecre_key,
              ind_numtit,ind_regcli,fec_regcli,cod_usureg,pais,tdoc,ndoc,aocta,saldo_reten_mn,fec_sldren
        FROM dwstage.TMP_FACT_PASIVO_PRODINC y
        where  tiempo_key = ln_tiempo and y.Ind_Tipinc in (2,7);
        Commit;
    ------------------
    --- CARGA RESUMEN
    ------------------
    delete from dwhouse.FACT_PASIVO_PRODINC_META  r where tiempo_key = ln_tiempo and r.ind_tipmet in (2,7);
    
    Insert Into FACT_PASIVO_PRODINC_META(TIEMPO_KEY,CODIGO_PRODUCTO,GEOGRAFIA_KEY,REGIONOP_KEY,IMP_META,IND_TIPMET,
               ANALISTA_KEY,DES_TIPANA,FEC_SALDO,fec_sldren)                                                            
        select distinct tiempo_key,'21',ageana_key,REGIONOP_KEY,p.imp_meta_aho,
               p.ind_tipinc,analista_key,NVL(p.des_tipana,'NO CLASIFICADO'),
               fec_saldo,fec_sldren
         FROM dwstage.TMP_FACT_PASIVO_PRODINC P
       Where p.ind_tipinc in (2,7) and tiempo_key = ln_tiempo
       UNION ALL  
        select distinct tiempo_key,'22',ageana_key,REGIONOP_KEY,p.imp_meta_dpf,
               ind_tipinc,analista_key,NVL(p.des_tipana,'NO CLASIFICADO'),fec_saldo,
               fec_sldren
         FROM dwstage.TMP_FACT_PASIVO_PRODINC P
       Where p.ind_tipinc in (2,7) and tiempo_key = ln_tiempo ;     
      Commit;
  
      ----------------------------
      ----- RESULTADO MENSUAL/PAGO
      ----------------------------
      DELETE FROM fact_pasivo_prodinc_res t where tiempo_key = ln_tiempo and t.ind_tipmet in (2,7);
      commit;

      Insert Into fact_pasivo_prodinc_res(tiempo_key, geografia_key, regionop_key, cod_tipage, ind_tipmet, analista_key, 
      des_tipana, fec_saldo, imp_metcts, imp_metaho, imp_metdpf, imp_bascts, imp_basaho, imp_basdpf, imp_avacts, 
      imp_avaaho, imp_avadpf, imp_logcts, imp_logaho, imp_logdpf, por_logcts, por_logaho, por_logdpf, ind_logtod, 
      ind_logpes, ind_logacu, por_pesaho, por_pesdpc, por_logacum, rnk_logage, por_imppago, des_motrnk, ageana_key,
      imp_pagomes,cod_producto,imp_capdep,imp_capret,fec_sldret,ind_regcap
      )
      select tiempo_key, geografia_key, regionop_key, cod_tipage, ind_tipmet, analista_key, 
      des_tipana, fec_saldo, imp_metcts, imp_metaho, imp_metdpf, imp_bascts, imp_basaho, imp_basdpf, imp_avacts, 
      imp_avaaho, imp_avadpf, imp_logcts, imp_logaho, imp_logdpf, por_logcts, por_logaho, por_logdpf, ind_logtod, 
      ind_logpes, ind_logacu, por_pesaho, por_pesdpc, por_logacum, rnk_logage, por_imppago, des_motrnk, geografia_key,
      imp_pagmes,cod_producto,imp_capdep,imp_capret,fec_sldren,nvl(ind_regcap,0)
      From dwstage.tmp_fact_pasivo_prodinc_res 
      Where tiempo_key = ln_tiempo and ind_tipmet in (2,7);
      Commit;
    
      Update fact_pasivo_prodinc_res d set d.ageana_key = d.geografia_key 
      where ind_tipmet = 2 and tiempo_key = ln_tiempo;
      Commit;
      
  End SP_PRODINC_RETENCION;
   
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
  Procedure SP_PRODINC_GERENNEGO(PD_FECHA In Date)
  -- Incentivos para gerencias de negocio (Gerentes de agencia, zonales y regionales)
  Is
     ld_fecha date := PD_FECHA;
     ln_tiempo number(10) := PQ_CARGA_FACTS.fn_tiempo_key(ld_fecha);
  Begin
     --- CARGA DETALLE
     DELETE FROM FACT_PASIVO_PRODINC where tiempo_key = ln_tiempo and ind_tipinc = 9; 
     commit;
     
     Insert Into FACT_PASIVO_PRODINC
                 (tiempo_key,cuenta_key,ind_tipinc,fec_aperen,imp_desemb,cuenta,saldo_reten_mn)
          Select tiempo_key,cuenta_key,ind_tipinc,fec_aperen,imp_desemb,aocta,saldo_reten_mn
            from dwstage.tmp_fact_pasivo_prodinc 
           where ind_tipinc = 9
             and tiempo_key = ln_tiempo;
     Commit;
     
     -- CARGA METAS
     DELETE FROM FACT_PASIVO_PRODINC_META where tiempo_key = ln_tiempo and ind_tipmet = 9; 
     commit;
    
     INSERT INTO FACT_PASIVO_PRODINC_META
                 (tiempo_key,codigo_producto,geografia_key,imp_meta,ind_tipmet,fec_saldo,
                  imp_sdometa,imp_sdorete,imp_apecta,imp_desemb)
           Select tiempo_key,codigo_producto,geografia_key,imp_meta,ind_tipmet,fec_saldo,
                  imp_sdobase,imp_sdoavan,imp_apecta,imp_desemb
             From dwstage.tmp_fact_pasivo_prodinc_metas 
            Where ind_tipmet = 9
              and tiempo_key = ln_tiempo;
     Commit;         
     -- CARGA RESULTADOS        
     DELETE FROM FACT_PASIVO_PRODINC_RES where tiempo_key = ln_tiempo and ind_tipmet in (90,91,92); 
     commit;
     
     INSERT INTO FACT_PASIVO_PRODINC_RES
                (tiempo_key,geografia_key,ind_tipmet,fec_saldo,imp_metaho,imp_basaho,imp_avacts,
                 imp_avaaho,imp_avadpf,ind_logtod,por_logaho,por_logdpf,imp_pagomes,
                 cod_zona,des_zona,cod_region,des_region,ageana_key)
          Select tiempo_key,geografia_key,ind_tipmet,fec_saldo,imp_metaho,imp_basaho,imp_avacts,
                 imp_avaaho,imp_avadpf,ind_logtod,por_logaho,por_logdpf,imp_pagmes,
                 cod_zona,des_zona,cod_region,des_region,geografia_key
            From dwstage.tmp_fact_pasivo_prodinc_res 
           Where tiempo_key = ln_tiempo
             and ind_tipmet in (90,91,92);
     commit;
  End SP_PRODINC_GERENNEGO;   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
  PROCEDURE SP_PRODINC_RESMES_V2023(PD_FECHA In Date)
  Is 
     ld_fecha date := to_date(to_char(PD_FECHA,'rrrrmm')||'01','rrrrmmdd');
     ln_tiempo number(10) := PQ_CARGA_FACTS.fn_tiempo_key(ld_fecha);
  BEGIN       
      ----------------------------
      ----- RESULTADO MENSUAL/PAGO
      ----------------------------
      DELETE FROM fact_pasivo_prodinc_res where tiempo_key = ln_tiempo;
      commit;
      
      Insert Into fact_pasivo_prodinc_res(tiempo_key, geografia_key, regionop_key, cod_tipage, ind_tipmet, analista_key, 
      des_tipana, fec_saldo, imp_metcts, imp_metaho, imp_metdpf, imp_bascts, imp_basaho, imp_basdpf, imp_avacts, 
      imp_avaaho, imp_avadpf, imp_logcts, imp_logaho, imp_logdpf, por_logcts, por_logaho, por_logdpf, ind_logtod, 
      ind_logpes, ind_logacu, por_pesaho, por_pesdpc, por_logacum, rnk_logage, por_imppago, des_motrnk, ageana_key,
      imp_pagomes,cod_producto,imp_capdep,imp_sdometaho,imp_sdometdpf,imp_sdometcts,
      cod_zona,des_zona,cod_region,des_region,imp_capret,ind_regcap,por_ahomes1,por_ahomes2,por_ahomes3,
      por_dpfmes1,por_dpfmes2,por_dpfmes3,por_ctsmes1,por_ctsmes2,por_ctsmes3
      )
      select tiempo_key, geografia_key, regionop_key, cod_tipage, ind_tipmet, analista_key, 
      des_tipana, fec_saldo, imp_metcts, imp_metaho, imp_metdpf, imp_bascts, imp_basaho, imp_basdpf, imp_avacts, 
      imp_avaaho, imp_avadpf, imp_logcts, imp_logaho, imp_logdpf, por_logcts, por_logaho, por_logdpf, ind_logtod, 
      ind_logpes, ind_logacu, por_pesaho, por_pesdpc, por_logacum, rnk_logage, por_imppago, des_motrnk, geografia_key,
      imp_pagmes,cod_producto,imp_capdep,imp_sdometaho,imp_sdometdpf,imp_sdometcts,
      cod_zona,des_zona,cod_region,des_region,imp_capret,nvl(ind_regcap,0),por_ahomes1,por_ahomes2,por_ahomes3,
      por_dpfmes1,por_dpfmes2,por_dpfmes3,por_ctsmes1,por_ctsmes2,por_ctsmes3
      From dwstage.tmp_fact_pasivo_prodinc_res u 
      Where tiempo_key = ln_tiempo;
      Commit;
    
      Update fact_pasivo_prodinc_res d set d.ageana_key = d.geografia_key 
      where ind_tipmet = 2 and tiempo_key = ln_tiempo;
      Commit;
      
  End SP_PRODINC_RESMES_V2023;    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  PROCEDURE SP_CARGA_PRODINC_V2023(PD_FECHA In Date)
  IS
  Begin
      PQ_CARGA_PRODUCTIVIDAD.SP_PRODINC_DIARIO(PD_FECHA);
      PQ_CARGA_PRODUCTIVIDAD.SP_PRODINC_RESMES_V2023(PD_FECHA);
      PQ_CARGA_PRODUCTIVIDAD.SP_PRODINC_GERENNEGO(PD_FECHA);
  END SP_CARGA_PRODINC_V2023;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure fact_pasivos_proase_v2 (PD_FECHA In DAte)
  Is 
    ld_fecha date := PD_FECHA;
  Begin
      Delete From fact_pasivos_proase where fecha_sld = ld_fecha and ind_version = 2;
      Commit;
    
      Insert Into dwhouse.fact_pasivos_proase
                 (fecha,tiempo_key, codigo_asesor, asesor_key, cliente_key, 
                  codigo_cliente, saldo, saldo_aho, saldo_dpf, fecha_sld, 
                  tiempo_sld_key, sldaho, slddpf, ind_nuevo, ind_mansld, 
                  ind_mancli, est_asesor, saldo_cts, sldcts, periodo, 
                  codsuc, tipase, toppro, ponpro, ponsld, 
                  poncli, metsld, metcli, impmcl, num_metren, 
                  imp_metren, num_logren, imp_logren, msldrn, 
                  mctsrn, ponren, ponre1, ponre2, tipreg, 
                  cuentas_key, cuentas_ren_key, ind_tipren, 
                  codigo_cuenta, codigo_cuenta_ren, imp_renmn, 
                  ind_ctaren, fec_vencta, ind_venmes, fec_cancela, 
                  cod_cuenta, imp_tipcam, val_rucemp, fec_actcta, 
                  cod_modcta, cod_topcta, poncre, metaho, ponaho, 
                  metdpf, pondpf, metcts, poncts, ponnue, 
                  metnue, regeje, sldbaho, sldbdpf, sldbcts, 
                  sldcaho, sldcdpf, sldccts,fec_heraut,ind_colcaj,
                  numdoc,fecha_apre,cod_aseasi,cod_ctacli,num_titcta,
                  ind_clirec,saldo_base,saldo_avance,saldo_captado,saldo_meta,saldo_logro,
                  por_logro,rnk_logro,imp_desbas,imp_desava,pagoprod,ind_Version,por_pagvar,
                  geografia_key,SALDO_DESFASE,
                  csucsec,dsucsec,nivase,
                  ind1_peso ,ind1_meta,ind1_logro,ind1_pago, 
                  ind2_peso ,ind2_meta,ind2_logro,ind2_pago, 
                  ind3_peso ,ind3_meta,ind3_logro,ind3_pago, 
                  ind4_peso ,ind4_meta,ind4_logro,ind4_pago, 
                  ind5_peso ,ind5_meta,ind5_logro,ind5_pago,
                  ind_titren,IMP_VENDPF  
                 )
          Select fecha, tiempo_key, codigo_asesor, asesor_key, cliente_key, 
                 codigo_cliente, saldo, saldo_aho, saldo_dpf, fecha_sld, 
                 tiempo_sld_key, sldaho, slddpf, ind_nuevo, ind_mansld, 
                 ind_mancli, est_asesor, saldo_cts, sldcts, periodo, 
                 codsuc, tipase, toppro, ponpro, ponsld, poncli, 
                 metsld, metcli, impmcl, num_metren, imp_metren, 
                 num_logren, imp_logren, msldrn, mctsrn, ponren, 
                 ponre1, ponre2, tipreg, cuentas_key, cuentas_ren_key, 
                 ind_tipren, codigo_cuenta, codigo_cuenta_ren, imp_renmn, 
                 ind_ctaren, fec_vencta, ind_venmes, fec_cancela, cod_cuenta, 
                 imp_tipcam, val_rucemp, fec_actcta, cod_modcta, cod_topcta, 
                 poncre, metaho, ponaho, metdpf, pondpf, metcts, 
                 poncts, ponnue, metnue, regeje, sldbaho, sldbdpf, 
                 sldbcts, sldcaho, sldcdpf, sldccts, fec_heraut, 
                 ind_colcaj,numdoc,fecha_apre,cod_aseasi,cod_ctacli,num_titcta,
                 ind_clirec,saldo_base,saldo_avance,saldo_captado,saldo_meta,saldo_logro,por_logro,rnk_logro,
                 imp_desbas,imp_desava,pagpro,ind_Version,por_pagvar,key_geografia,
                 nvl(SALDO_DESFASE,0),
                 sucsec,trim(ge.nombre_agencia),niveje,
                 ind1_peso ,ind1_meta,ind1_logro,ind1_pago, 
                 ind2_peso ,ind2_meta,ind2_logro,ind2_pago, 
                 ind3_peso ,ind3_meta,ind3_logro,ind3_pago, 
                 ind4_peso ,ind4_meta,ind4_logro,ind4_pago, 
                 ind5_peso ,ind5_meta,ind5_logro,ind5_pago,
                 pr.ind_titren, nvl(IMP_VENDPF,0) 
            From dwstage.TMP_FACT_PASIVOS_PROASE pr 
            Left Join dwhouse.dm_geografia ge on ge.cod_sucurs = pr.sucsec
                      and ge.tipo_region = 'R'   
           Where fecha_sld = ld_fecha and ind_Version = 2;
          Commit;
  Exception When Others Then
      Null;                                    
  End fact_pasivos_proase_v2;
  ------------------------------------------------------------------------------------------
  Procedure fact_pasivos_proase (PD_FECHA In DAte)
  Is 
    ld_fecha date := PD_FECHA;
  Begin
      Delete From fact_pasivos_proase where fecha_sld = ld_fecha and ind_version = 1;
      Commit;
    
      Insert Into dwhouse.fact_pasivos_proase(fecha,tiempo_key, codigo_asesor, asesor_key, cliente_key, 
                                     codigo_cliente, saldo, saldo_aho, saldo_dpf, fecha_sld, 
                                     tiempo_sld_key, sldaho, slddpf, ind_nuevo, ind_mansld, 
                                     ind_mancli, est_asesor, saldo_cts, sldcts, periodo, 
                                     codsuc, tipase, toppro, ponpro, ponsld, 
                                     poncli, metsld, metcli, impmcl, num_metren, 
                                     imp_metren, num_logren, imp_logren, msldrn, 
                                     mctsrn, ponren, ponre1, ponre2, tipreg, 
                                     cuentas_key, cuentas_ren_key, ind_tipren, 
                                     codigo_cuenta, codigo_cuenta_ren, imp_renmn, 
                                     ind_ctaren, fec_vencta, ind_venmes, fec_cancela, 
                                     cod_cuenta, imp_tipcam, val_rucemp, fec_actcta, 
                                     cod_modcta, cod_topcta, poncre, metaho, ponaho, 
                                     metdpf, pondpf, metcts, poncts, ponnue, 
                                     metnue, regeje, sldbaho, sldbdpf, sldbcts, 
                                     sldcaho, sldcdpf, sldccts,fec_heraut,ind_colcaj,
                                     numdoc,fecha_apre,cod_aseasi,ind_version
                                    )
      Select fecha, tiempo_key, codigo_asesor, asesor_key, cliente_key, 
             codigo_cliente, saldo, saldo_aho, saldo_dpf, fecha_sld, 
             tiempo_sld_key, sldaho, slddpf, ind_nuevo, ind_mansld, 
             ind_mancli, est_asesor, saldo_cts, sldcts, periodo, 
             codsuc, tipase, toppro, ponpro, ponsld, poncli, 
             metsld, metcli, impmcl, num_metren, imp_metren, 
             num_logren, imp_logren, msldrn, mctsrn, ponren, 
             ponre1, ponre2, tipreg, cuentas_key, cuentas_ren_key, 
             ind_tipren, codigo_cuenta, codigo_cuenta_ren, imp_renmn, 
             ind_ctaren, fec_vencta, ind_venmes, fec_cancela, cod_cuenta, 
             imp_tipcam, val_rucemp, fec_actcta, cod_modcta, cod_topcta, 
             poncre, metaho, ponaho, metdpf, pondpf, metcts, 
             poncts, ponnue, metnue, regeje, sldbaho, sldbdpf, 
             sldbcts, sldcaho, sldcdpf, sldccts, fec_heraut, 
             ind_colcaj,numdoc,fecha_apre,cod_aseasi,ind_version
        From dwstage.TMP_FACT_PASIVOS_PROASE 
       Where fecha_sld = ld_fecha and ind_version = 1;
      Commit;
  Exception When Others Then
      Null;                                    
  End fact_pasivos_proase;
  ----------------------------------------------------------------------------------------- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
end PQ_CARGA_PRODUCTIVIDAD;
/
