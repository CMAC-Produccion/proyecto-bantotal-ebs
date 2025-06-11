create or replace package PQ_TMP_FSD_CREDINKA is

  -- Author  : LLATANPVARGAS
  -- Created : 3/01/2025 18:57:13
  -- Purpose : 
  
  Procedure SP_EJE_FSD_MENSUAL(PD_FECHA In Date);
  Procedure SP_DETALLE_CUENTAS_CLIE(PD_FECHA In Date);
  Procedure SP_COBERTURA_SLDOS(PD_FECHA Date);
  Procedure SP_SALDOS_PROMEDIO(PD_FECHA Date);
  Procedure SP_SALDOS_COBERTURADOS_CTA(PD_FECHA Date);
  Procedure SP_SALDOS_COBERTURADOS_CLIE(PD_FECHA Date);
  Procedure SP_ANEXO17A(PD_FECHA In Date);
  Procedure SP_CARGA_FSD_MENSUAL(PD_FECHA In Date);
     
end PQ_TMP_FSD_CREDINKA;
/
create or replace package body PQ_TMP_FSD_CREDINKA is

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure SP_EJE_FSD_MENSUAL(PD_FECHA In Date)
  Is
  Begin
    PQ_TMP_FSD_CREDINKA.SP_DETALLE_CUENTAS_CLIE(PD_FECHA);
    PQ_TMP_FSD_CREDINKA.SP_COBERTURA_SLDOS(PD_FECHA);
    PQ_TMP_FSD_CREDINKA.SP_ANEXO17A(PD_FECHA);
  End SP_EJE_FSD_MENSUAL;    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
  Procedure SP_CARGA_FSD_MENSUAL(PD_FECHA In Date)
  Is
    nTipPro Number(1) := 4;
  Begin
     DWHOUSE.PQ_CARGA_FACTS.sp_fsd_anexo17A_credinka(PD_FECHA,nTipPro);
     DWHOUSE.PQ_CARGA_FACTS.sp_fact_base_Anexo17A_credinka(PD_FECHA);
  End SP_CARGA_FSD_MENSUAL;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --        
  Procedure SP_DETALLE_CUENTAS_CLIE(PD_FECHA In Date)
  --- Carga base de datos de Credinka proporcionada por BI
  Is 
    ld_fecha   date := PD_FECHA; 
    ln_diasm   number(2) := to_number(to_char(ld_fecha,'dd'));  
    ln_tiempo  number(10);
    
  Begin
      
       Execute Immediate 'Truncate table TMP_FACT_FSDCLIE_CREDINKA';
       --- Actualiza cuentas contabls
       Begin
           Update tmp_fsd_rubros r set r.cod_rubro2 = substr(r.cod_rubro,1,8);
           Commit;
       Exception when Others Then
           Commit;
       End;
         
       Select tiempo_key Into ln_tiempo from dwhouse.dm_tiempo where fecha = ld_fecha;
       
       Begin
          Insert Into TMP_FACT_FSDCLIE_CREDINKA
                 (fecha,tiempo_key,pais,tdoc,ndoc,nom_cliente,cuentas_key,abr_segcta,
                  fec_apertura,num_titcta,dia_ape,num_dias,aomda,saldo_mo,intgen_mon,salgar_mo,
                  cod_rubro,--cod_mdes,
                  ind_colcaj,ind_tipdep,tip_natper,
                  p_impsaldo, p_impinter,p_impgaran,rubro)
           Select fecha,
                   ln_tiempo,
                   case when pais = 'PE' then 604 else 604 end pais,
                   case when tdoc = 'DNI' then 21
                        when tdoc = 'RUC' then 9
                        when tdoc = 'DOC PROV IDENTIDAD' then 15
                        when tdoc = 'CARNE DE EXTRANJERIA' then 2
                        when tdoc = 'PERMISO TEMP PERMANENCIA' then 13
                        when tdoc = 'CEDULA DE IDENTIDAD' then 10
                        when tdoc = 'PASAPORTE' then 5
                        when tdoc like 'NULL%' then 27  
                        when tdoc is null then 27
                   end tdoc,         
                   ndoc,
                   substr(trim(nom_cliente),1,200),
                   cuentas_key,
                   abr_segcta,fec_apertura,num_titcta,
                   ln_diasm,
                   ln_diasm,
                   decode(moneda,1,0,101),
                   nvl(saldo_mo,0),
                   nvl(intgen_mo,0),
                   nvl(salgar_mo,0),
                   substr(rubro,1,2)||0||substr(rubro,4,5),
                   --'C00',
                   decode(ind_empbco,0,'N','S'),
                   producto,
                   case when tdoc = 'RUC' then 'J' 
                        when abr_segcta = 'IF' then 'J'
                        when abr_segcta like 'PJ%' then 'J'  
                        else 'F' end,
                   nvl(saldo_mo,0),
                   nvl(intgen_mo,0),
                   nvl(salgar_mo,0),
                   rubro  
            from dwextra.EXT_FSD_CREDINKA
            where fecha = ld_fecha;
            
            Commit;
       Exception When Others Then
          Commit;
       End;              
  End SP_DETALLE_CUENTAS_CLIE;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure SP_COBERTURA_SLDOS(PD_FECHA Date)
  Is 
   ld_Fecha  date := PD_FECHA; 
  Begin
    
     PQ_TMP_FSD_CREDINKA.sp_saldos_promedio(ld_fecha);
     PQ_TMP_FSD_CREDINKA.SP_SALDOS_COBERTURADOS_CTA(ld_fecha);
     PQ_TMP_FSD_CREDINKA.SP_SALDOS_COBERTURADOS_CLIE(ld_fecha);
     
  End SP_COBERTURA_SLDOS;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure SP_SALDOS_PROMEDIO(PD_FECHA Date)
  Is 
    Cursor c_salpro (ld_fec in Date)
        is Select case when substr(cod_rubro,1,8) in ('21070401','21070402','21070409') 
                       then p_impsaldo-p_impgaran 
                       when substr(cod_rubro,1,8) not in ('21070401','21070402','21070409') 
                            and NVL(P_IMPGARAN,0) <> 0 
                       then p_impsaldo-p_impgaran       
                   else p_impsaldo
                   end p_impsaldo,
                   p_impinter,p_impgaran,
                   num_titcta,dia_ape,pais,tdoc,ndoc,aomda,cuentas_key,
                   y.key_segcta, y.tip_natper,y.abr_segcta,y.cod_cliente
             From TMP_FACT_FSDCLIE_CREDINKA y
            Where fecha = ld_fec
              and tiempo_key is not null
              and y.imp_tcam is null;
             
     cursor c_tipcli
         is  Select cl.fecha,cl.cod_cliente,max(cl.ind_tipcli) max_tipcli, 
                    count(distinct cl.ind_tipcli) cnttip
               From TMP_FACT_FSDCLIE_CREDINKA cl
             Group by cl.fecha,cl.cod_cliente   
             Having count(distinct cl.ind_tipcli)  > 1;
   
              
   ld_Fecha  date := PD_FECHA;  
   --ln_limfst number(12,2) := pq_tmp_carga_fsd.FN_LIMITE_FSD(ld_Fecha);  
   --ln_limfsd number(12,2);
   ln_tcam   number(7,3):= pq_tmp_carga_fsd.fn_tipo_cambio_fijo(ld_Fecha);    
   ln_psdo   number(13,3);
   ln_pint   number(13,3);
   ln_pgar   number(13,3);      
   ln_tsdo number(13,3);   
   ln_tint number(13,3);   
   ln_tgar number(13,3);  
   ln_tipcli Number(1);
   err varchar2(200);
   ln_mtcli  Number(3);
  Begin
     Begin
      -- Actualiza datos
      Update TMP_FACT_FSDCLIE_CREDINKA s
         set s.imp_tcam = null,
             s.sld_dtot = null,
             s.int_dtot = null,
             s.gar_dtot = null,
             s.ind_tipcli = null,
             s.cod_cliente = trim(s.pais||s.tdoc||trim(s.ndoc))
       where fecha = ld_Fecha 
         and tiempo_key is not null;
       Commit;
       exception When Others Then
         null;
       end;        
             
       --- Saldos Promedio: SE ELIMINA DESDE ENERO 2022 
       --- ENERO 2022 POCENTAJE DE SALDOS AL CIERRE DE CADA TITULAR
       For x In c_salpro(ld_Fecha) Loop
             ln_tipcli := 1;
             If x.aomda = 101 Then
                  ln_psdo := (nvl(x.p_impsaldo,0)*ln_tcam)/(x.num_titcta);  
                  ln_pint := (nvl(x.p_impinter,0)*ln_tcam)/(x.num_titcta);
                  ln_pgar := (nvl(x.p_impgaran,0)*ln_tcam)/(x.num_titcta);
             Else 
                  ln_psdo := nvl(x.p_impsaldo,0)/(x.num_titcta);  
                  ln_pint := nvl(x.p_impinter,0)/(x.num_titcta);
                  ln_pgar := nvl(x.p_impgaran,0)/(x.num_titcta);
             End If;
             
             ln_tsdo:=nvl(ln_psdo,0);
             ln_tint:=nvl(ln_pint,0);
             ln_tgar:=nvl(ln_pgar,0);
            
             If x.tdoc in (27,28) or (substr(x.abr_segcta,1,2) = 'PJ' and x.tip_natper = 'F') Then
                 ln_tipcli := 2;
             End If;  

          Begin
             Update TMP_FACT_FSDCLIE_CREDINKA s
                set s.imp_tcam = ln_tcam,
                    s.sld_dtot = ln_tsdo,
                    s.int_dtot = ln_tint,
                    s.gar_dtot = ln_tgar,
                    s.ind_tipcli = ln_tipcli
              Where s.cod_cliente = x.cod_cliente
                and s.cuentas_key = x.cuentas_key
                and s.fecha = ld_Fecha;  
                    
              Commit;
          Exception When Others Then
            err := substr(sqlerrm,1,200);
          End;       
       End Loop;  
       
       --> Unifica Tipo de cliente
       For x in c_tipcli Loop
           ln_mtcli := x.max_tipcli;
           Begin
           Select max(cl.ind_tipcli) max_tipcli
             Into ln_mtcli
               From TMP_FACT_FSDCLIE_CREDINKA cl
               Join tmp_fsd_rubros rb on rb.cod_rubro = cl.cod_rubro
               and cl.cod_cliente = x.cod_cliente;
           Exception When Others Then
             ln_mtcli := x.max_tipcli;
           End;      
               
           Update TMP_FACT_FSDCLIE_CREDINKA 
              set ind_tipcli = ln_mtcli
            Where cod_cliente = x.cod_cliente
              and fecha = x.fecha;
           Commit;
       End Loop;         

  End SP_SALDOS_PROMEDIO;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure SP_SALDOS_COBERTURADOS_CTA(PD_FECHA Date)
  --- Modificación
  -- Fecha : 2025.01.02
  -- Autor : Paola Vargas 
  ---------------------------------------------------------------------------------------
 Is 
    Cursor c_clie (ld_fec in Date)
        Is Select pais,tdoc,ndoc,cod_cliente,cuentas_key,
                  sum(nvl(b.sld_dtot,0)+nvl(b.int_dtot,0)+nvl(b.gar_dtot,0)) mtoacre
             From TMP_FACT_FSDCLIE_CREDINKA b
             Join tmp_fsd_rubros rb 
               on rb.cod_rubro2 = b.cod_rubro
            Where b.fecha = ld_fec
              and b.tiempo_key is not null
              and b.ind_tipcli = 2
            Group By pais,tdoc,ndoc,cod_cliente,cuentas_key;
 
    Cursor c_ctas(ln_pais in Number,ln_tdoc in Number, lc_ndoc in Char,ld_fec In Date, ln_cta In Number,lv_clie In Varchar2)
        Is Select * From (Select case when substr(x.cod_rubro,1,8) in ('21070401','21070402','21070409') and x.aomda = 0 then 1
                                      when substr(x.cod_rubro,1,8) in ('21070401','21070402','21070409') and x.aomda = 101 then 2
                                      when x.cod_rubro like '21020101%' and x.aomda = 0 then 5
                                      when x.cod_rubro like '21020101%' and x.aomda = 101 then 6
                                      When x.cod_rubro like '21020201%' and x.aomda = 0 then 7
                                      When x.cod_rubro like '21020201%' and x.aomda = 101 then 8
                                      When x.cod_rubro like '21030301%' and x.aomda = 0 then 9
                                      When x.cod_rubro like '21030301%' and x.aomda = 101 then 10
                                      
                                      When x.aomod = 156 and x.aomda = 0 then 11
                                      When x.aomod = 156 and x.aomda = 101 then 12
                                      
                                      When x.cod_rubro like '210305%' and x.aomda = 0 then 13
                                      When x.cod_rubro like '210305%' and x.aomda = 101 then 14
                                      When x.cod_rubro like '21011201%' and x.aomda = 0 then 15
                                      When x.cod_rubro like '21011201%' and x.aomda = 101 then 16
                                      When x.aomda = 0 then 17
                                      When x.aomda = 101 then 18
                                      else 19
                                  end n_orden,
                                  case when substr(x.cod_rubro,1,8) in ('21070401','21070402','21070409') then 'G' else 'S' end tipimp,
                                  x.sldt_fsd,x.intt_fsd,x.gart_fsd,
                                  --> 2023.05.31
                                  x.sld_dtot, 
                                  x.int_dtot,
                                  case when x.gar_dtot <> 0 and  x.cod_rubro not like '210704%' then 0 else x.gar_dtot end gar_dtot,
                                  --x.sld_dtot,x.int_dtot,x.gar_dtot,
                                  
                                  --< 2023.05.31
                                  
                                  x.p_impsaldo-x.p_impgaran p_impsaldo,
                                  x.p_impinter,x.p_impgaran,x.p_imp_fsd,x.p_int_fsd,x.p_gar_fsd,x.p_dii_fsd,
                                  x.dia_ape,x.num_titcta,x.cod_rubro,
                                  x.aomda,x.aomod,x.aocta,x.aoope,x.aosbo,x.aotop,x.key_segcta,x.tip_natper,
                                  ---20240306
                                  x.aosuc,x.cuentas_key,x.abr_segcta
                                  ---
                             From TMP_FACT_FSDCLIE_CREDINKA x 
                            where --x.pais=ln_pais and tdoc=ln_tdoc and x.ndoc=lc_ndoc
                                  x.cod_cliente = lv_clie
                              and x.fecha = ld_fec
                              and x.tiempo_key is not null
                              and x.cuentas_key = ln_cta
                                  UNION ALL
                           Select case when x.aomda=0 then 2 else 3 end n_orden, 'G',
                                  x.sldt_fsd,x.intt_fsd,x.gart_fsd,
                                  --> 2023.05.31
                                  case when x.gar_dtot <> 0 and  x.cod_rubro not like '210704%' then 0 else x.sld_dtot end sld_dtot, 
                                  case when x.gar_dtot <> 0 and  x.cod_rubro not like '210704%' then 0 else x.int_dtot end int_dtot,
                                  x.gar_dtot,
                                  --x.sld_dtot,x.int_dtot,x.gar_dtot,
                                  --< 2023.05.31
                                  x.p_impsaldo-x.p_impgaran p_impsaldo,x.p_impinter,x.p_impgaran,
                                  x.p_imp_fsd,x.p_int_fsd,x.p_gar_fsd,x.p_dii_fsd,
                                  x.dia_ape,x.num_titcta,x.cod_rubro,
                                  x.aomda,x.aomod,x.aocta,x.aoope,x.aosbo,x.aotop,x.key_segcta,x.tip_natper,
                                  ---20240306
                                  x.aosuc,x.cuentas_key,x.abr_segcta
                                  ---
                             From TMP_FACT_FSDCLIE_CREDINKA x 
                            where --x.pais=ln_pais and tdoc=ln_tdoc and x.ndoc=lc_ndoc
                                  x.cod_cliente = lv_clie
                              and x.fecha = ld_fec
                              and (substr(x.cod_rubro,1,8) not in ('21070401','21070402','21070409')
                                   --and x.salgar_mo <> 0
                                   and x.gar_dtot <> 0
                                   )
                              and x.tiempo_key is not null  
                              and x.cuentas_key = ln_cta   
                          )Order By n_orden;
                                                  
   ld_Fecha  date := PD_FECHA;  
   ln_limfst number(12,2) := pq_tmp_carga_fsd.FN_LIMITE_FSD(ld_Fecha);  
   ln_limfsd number(12,2);
   --ln_tcam   number(7,3):= pq_tmp_carga_fsd.fn_tipo_cambio_fijo(ld_Fecha);    
   ln_psdo   number(13,3);
   ln_pint   number(13,3);
   ln_pgar   number(13,3);      
   ln_psdo_fsd   number(13,3);
   ln_pint_fsd   number(13,3);
   ln_pgar_fsd   number(13,3);    
   ln_saldo  number(13,3);  
   ln_saldo_fsd  number(13,3);
   ln_impacu number(13,3); 
   ln_ima_fsd number(13,3); 
   --ln_isdo number(13,3); 
   --ln_iint number(13,3); 
   ----ln_igar number(13,3); 
   ln_tsdo number(13,3);   
   ln_tint number(13,3);   
   ln_tgar number(13,3);  
   ln_tsdo_fsd number(13,3);   
   ln_tint_fsd number(13,3);   
   ln_tgar_fsd number(13,3);    
   lv_mdes varchar2(5);
   --ln_estra number(3);
   lv_tipcar varchar2(1);
   lv_estado varchar2(1);
   ln_tipcli Number(1);
   ln_indcob Number(1);
   lv_colemp Varchar2(1);
   
   ln_scob number(13,3); ln_icob number(13,3); ln_gcob number(13,3);
   ln_snco number(13,3); ln_inco number(13,3); ln_gnco number(13,3); 
   
  Begin
     Begin 
      -- Actualiza datos
      Update TMP_FACT_FSDCLIE_CREDINKA s
                 set s.imp_lfsd = null,
                     s.sld_pdis = null,
                     s.int_pdis = null,
                     s.gar_pdis = null,
                     s.sld_pdnc = null,
                     s.int_pdnc = null,
                     s.gar_pdnc = null,
                     s.cod_mdes = null
       where fecha = ld_Fecha 
         and tiempo_key is not null
         and ind_tipcli = 2;
       Commit;
       exception When Others Then
         null;
       end;               
            
       -- Monto cobertura   
       For c In c_clie(ld_Fecha) Loop
           lv_mdes := 'C00';
           ln_tipcli := 1;
           ln_impacu := 0;
           ln_ima_fsd:= 0;
           ln_indcob := 0;
           ln_limfsd := ln_limfst;
           
           ----
           lv_tipcar := Null;
           lv_estado := Null;
           --lv_colemp := 'N';
           ----    
           If c.mtoacre < ln_limfst Then
              ln_limfsd := c.mtoacre;
              ln_indcob := 1;
           End If;   
           
           -- Buscar trabajadores del banco
           lv_colemp := 'N';
               
           --- Detalle de Cuentas
           For x In c_ctas(c.pais,c.tdoc,c.ndoc,ld_Fecha,c.cuentas_key,c.cod_cliente) Loop
               IF ln_indcob = 1 Then
                  ln_psdo := nvl(x.sld_dtot,0);
                  ln_pint := nvl(x.int_dtot,0);
                  ln_pgar := nvl(x.gar_dtot,0);
                  ln_tsdo := ln_psdo;
                  ln_tint := ln_pint;
                  ln_tgar := ln_pgar;
                  
                  -- REVISAR SI YA SE GRABO DATO ANTERIOR
                   ln_scob := 0; ln_icob:= 0; ln_gcob := 0;
                         ln_snco := 0; ln_inco:= 0; ln_gnco := 0;
                         Begin
                         Select nvl(sld_pdis,0),nvl(int_pdis,0),nvl(gar_pdis,0),
                                nvl(sld_pdnc,0),nvl(int_pdnc,0),nvl(gar_pdnc,0)
                           Into ln_scob, ln_icob, ln_gcob,
                                ln_snco, ln_inco, ln_gnco 
                           From TMP_FACT_FSDCLIE_CREDINKA 
                           Where cod_cliente = c.cod_cliente
                             and cuentas_key = x.cuentas_key
                             and fecha = ld_Fecha
                             and tiempo_key is not null;   
                         Exception When Others Then
                            ln_scob := 0; ln_icob:= 0; ln_gcob := 0;
                            ln_snco := 0; ln_inco:= 0; ln_gnco := 0;
                         End;    
                         
                         If ln_tsdo < ln_scob Then ln_tsdo := ln_tsdo; End If;
                         If ln_tint < ln_icob Then ln_tint := ln_tint; End If;
                         If ln_tgar < ln_gcob Then ln_tgar := ln_gcob; End If;
                         
                         ln_tsdo := ln_tsdo + ln_snco; 
                         ln_tint := ln_tint + ln_inco;
                         ln_tgar := ln_tgar + ln_gnco;
                         
                         ln_saldo  := ln_saldo + ln_scob+ln_icob+ln_gcob;
                         ln_psdo   := ln_psdo + ln_scob;
                         ln_pint   := ln_pint + ln_icob;
                         ln_pgar   := ln_pgar + ln_gcob;
                         
                  --->2023.05.31
                  If nvl(ln_psdo,0) + nvl(ln_pint,0) + nvl(ln_pgar,0) < 0 THEN
                    ln_psdo := 0;
                    ln_pint := 0;
                    ln_pgar := 0;
                    ln_tsdo := nvl(x.sld_dtot,0);
                    ln_tint := nvl(x.int_dtot,0);
                    ln_tgar := nvl(x.gar_dtot,0);
                  --< 2023.05.31
                  End If;       
                  
               ELSE   
                  ln_psdo := nvl(x.sld_dtot,0);
                  ln_pint := nvl(x.int_dtot,0);
                  ln_pgar := nvl(x.gar_dtot,0);
                  ln_tsdo:=nvl(ln_psdo,0);
                  ln_tint:=nvl(ln_pint,0);
                  ln_tgar:=nvl(ln_pgar,0);
                  
                  ln_psdo_fsd := nvl(x.sldt_fsd,0);
                  ln_pint_fsd := nvl(x.intt_fsd,0);
                  ln_pgar_fsd := nvl(x.gart_fsd,0);
                  ln_tsdo_fsd:=ln_psdo_fsd;
                  ln_tint_fsd:=ln_pint_fsd;
                  ln_tgar_fsd:=ln_pgar_fsd;
                  
                                    --->2023.05.31
                  If nvl(ln_psdo,0) + nvl(ln_pint,0) + nvl(ln_pint,0) < 0 THEN
                    ln_psdo := 0;
                    ln_pint := 0;
                    ln_pgar := 0;
                    ln_tsdo := nvl(x.sld_dtot,0);
                    ln_tint := nvl(x.int_dtot,0);
                    ln_tgar := nvl(x.gar_dtot,0);
                  End If;  
                  --< 2023.05.31
                  
                  If x.tipimp = 'G' and x.cod_rubro not like '210704%' Then
                     ln_saldo := ln_pgar + ln_pint;
                     ln_psdo  := 0;
                     ln_pint  := 0;
               
                     ln_saldo_fsd := ln_pgar_fsd + ln_pint_fsd;
                     ln_psdo_fsd  := 0;
                     ln_pint_fsd  := 0;
                  Else
                     ln_saldo := nvl(ln_pgar,0)+nvl(ln_psdo,0)+nvl(ln_pint,0);
                     ln_saldo_fsd := ln_pgar_fsd+ln_psdo_fsd+ln_pint_fsd;
                  End If;
            
                  --- Datamart
                  If (ln_impacu+ln_saldo) < ln_limfsd Then
                      ln_impacu := ln_impacu + ln_saldo;
                  Else 
                     If ln_impacu < ln_limfsd Then
                        ln_saldo  := ln_limfsd - ln_impacu;
                        ln_impacu := ln_impacu + ln_saldo;
                     
                        If ln_tgar <= ln_saldo Then
                           ln_pgar := ln_tgar;
                           ln_saldo:= ln_saldo - ln_pgar;
                        Else
                           ln_pgar := ln_saldo;
                           ln_saldo:= 0;
                        End If;   
                     
                        If ln_tsdo <= ln_saldo Then
                           ln_psdo := ln_tsdo;
                           ln_saldo:= ln_saldo - ln_psdo;
                        Else
                           ln_psdo := ln_saldo;
                           ln_saldo:= 0;
                        End If;
                     
                        If ln_tint <= ln_saldo Then
                           ln_pint := ln_tint;
                           ln_saldo:= ln_saldo - ln_tint;
                        Else
                           ln_pint := ln_saldo;
                           ln_saldo:= 0;
                        End If;
                     
                     Else    
                         ln_saldo  := 0;
                         ln_psdo   := 0;
                         ln_pint   := 0;
                         ln_pgar   := 0;
                         
                     End If;
                  End If;
                  
                  -- REVISAR SI YA SE GRABO DATO ANTERIOR
                         --> 2023.05.31
                         ln_scob := 0; ln_icob:= 0; ln_gcob := 0;
                         ln_snco := 0; ln_inco:= 0; ln_gnco := 0;
                         Begin
                         Select nvl(sld_pdis,0),nvl(int_pdis,0),nvl(gar_pdis,0),
                                nvl(sld_pdnc,0),nvl(int_pdnc,0),nvl(gar_pdnc,0)
                           Into ln_scob, ln_icob, ln_gcob,
                                ln_snco, ln_inco, ln_gnco 
                           From TMP_FACT_FSDCLIE_CREDINKA 
                           Where cod_cliente = c.cod_cliente
                             and cuentas_key = x.cuentas_key
                             and fecha = ld_Fecha
                             and tiempo_key is not null;   
                         Exception When Others Then
                            ln_scob := 0; ln_icob:= 0; ln_gcob := 0;
                            ln_snco := 0; ln_inco:= 0; ln_gnco := 0;
                         End;    
                         
                         If ln_tsdo < ln_scob Then ln_tsdo := ln_tsdo; End If;
                         If ln_tint < ln_icob Then ln_tint := ln_tint; End If;
                         If ln_tgar < ln_gcob Then ln_tgar := ln_gcob; End If;
                         
                         ln_tsdo := ln_tsdo + ln_snco; 
                         ln_tint := ln_tint + ln_inco;
                         ln_tgar := ln_tgar + ln_gnco;
                         
                         ln_saldo  := ln_saldo + ln_scob+ln_icob+ln_gcob;
                         ln_psdo   := ln_psdo + ln_scob;
                         ln_pint   := ln_pint + ln_icob;
                         ln_pgar   := ln_pgar + ln_gcob;
              END IF;
              
              If x.abr_segcta = 'IF' Then
                 lv_mdes := 'C10'; --Sist.Finan.
              ElsIf x.abr_segcta = 'PJ C/L' and x.tip_natper = 'J' Then      
                 lv_mdes := 'C60'; -- PJ Lucro
              Elsif(ln_tsdo-ln_psdo) + (ln_tint-ln_pint) + (ln_tgar-ln_pgar) > 0 Then
                 lv_mdes := 'C50';
              End If;
            
           
              Update TMP_FACT_FSDCLIE_CREDINKA s
                 set s.imp_lfsd = ln_limfst,
                     s.sld_pdis = ln_psdo,
                     s.int_pdis = ln_pint,
                     s.gar_pdis = ln_pgar,
                     s.sld_pdnc = (ln_tsdo-ln_psdo),
                     s.int_pdnc = (ln_tint-ln_pint),
                     s.gar_pdnc = (ln_tgar-ln_pgar),
                     s.cod_mdes = lv_mdes
               Where s.cod_cliente = c.cod_cliente
                 and s.cuentas_key = x.cuentas_key
                 and s.fecha = ld_Fecha
                 and s.tiempo_key is not null;      
             Commit;   
           End Loop;
        End Loop;
  End SP_SALDOS_COBERTURADOS_CTA;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  Procedure SP_SALDOS_COBERTURADOS_CLIE(PD_FECHA Date)
  --- Modificación
  --  Fecha : 2021.11.05
  --  Autor : Paola Vargar 
  --  Cambio: Obtener el cargo de la última fecha ingresada, se realiza este cambio por el
  --         continuo error de RRHH de no dar de baja el cargo en la fecha que corresonde
  ---------------------------------------------------------------------------------------
  -- Fecha : 2023.05.31
  -- Autor : Paola Vargas 
  -- Cambio: Se corrige la cobertura de CTS en garantía al superar el límite FSD
  ---------------------------------------------------------------------------------------
  Is 
    Cursor c_clie (ld_fec in Date)
        Is Select pais,tdoc,ndoc,cod_cliente,
                  sum(case when nvl(b.sld_dtot,0)+nvl(b.int_dtot,0)+nvl(b.gar_dtot,0) >= 0 
                           then nvl(b.sld_dtot,0)+nvl(b.int_dtot,0)+nvl(b.gar_dtot,0)
                           else 0
                       end       
                     ) mtoacre
             From TMP_FACT_FSDCLIE_CREDINKA b
             Join tmp_fsd_rubros rb 
               on rb.cod_rubro2 = b.cod_rubro
            Where b.fecha = ld_fec
              and b.tiempo_key is not null
              and b.ind_tipcli = 1
            Group By pais,tdoc,ndoc,cod_cliente;
            
    Cursor c_ctas(ln_pais in Number,ln_tdoc in Number, lc_ndoc in Char,ld_fec In Date, lv_clie in varchar2)
        Is Select * From (Select case when substr(x.cod_rubro,1,8) in ('21070401','21070402','21070409') and x.aomda = 0 then 1
                                      when substr(x.cod_rubro,1,8) in ('21070401','21070402','21070409') and x.aomda = 101 then 2
                                      when x.cod_rubro like '21020101%' and x.aomda = 0 then 5
                                      when x.cod_rubro like '21020101%' and x.aomda = 101 then 6
                                      When x.cod_rubro like '21020201%' and x.aomda = 0 then 7
                                      When x.cod_rubro like '21020201%' and x.aomda = 101 then 8
                                      When x.cod_rubro like '21030301%' and x.aomda = 0 then 9
                                      When x.cod_rubro like '21030301%' and x.aomda = 101 then 10
                                      
                                      When x.aomod = 156 and x.aomda = 0 then 11
                                      When x.aomod = 156 and x.aomda = 101 then 12
                                      
                                      When x.cod_rubro like '210305%' and x.aomda = 0 then 13
                                      When x.cod_rubro like '210305%' and x.aomda = 101 then 14
                                      When x.cod_rubro like '21011201%' and x.aomda = 0 then 15
                                      When x.cod_rubro like '21011201%' and x.aomda = 101 then 16
                                      When x.aomda = 0 then 17
                                      When x.aomda = 101 then 18
                                      else 19
                                  end n_orden,
                                  case when substr(x.cod_rubro,1,8) in ('21070401','21070402','21070409') 
                                       then 'G' else 'S' end tipimp,
                                  x.sldt_fsd,x.intt_fsd,x.gart_fsd,
                                  x.sld_dtot, 
                                  x.int_dtot,
                                  case when x.gar_dtot <> 0 and  x.cod_rubro not like '210704%' then 0 else x.gar_dtot end gar_dtot,
                                  x.p_impsaldo-x.p_impgaran p_impsaldo,
                                  x.p_impinter,x.p_impgaran,x.p_imp_fsd,x.p_int_fsd,x.p_gar_fsd,x.p_dii_fsd,
                                  x.dia_ape,x.num_titcta,x.cod_rubro,
                                  x.aomda,x.aomod,x.aocta,x.aoope,x.aosbo,x.aotop,x.key_segcta,x.tip_natper,
                                  x.cuentas_key,x.abr_segcta,x.cod_cliente,
                                  ---20240306
                                  x.aosuc
                                  ---
                             From TMP_FACT_FSDCLIE_CREDINKA x 
                            where x.cod_cliente = lv_clie
                              and x.fecha = ld_fec
                              and x.tiempo_key is not null
                                  UNION ALL
                           Select case when x.aomda=0 then 2 else 3 end n_orden, 'G',
                                  x.sldt_fsd,x.intt_fsd,x.gart_fsd,
                                  --> 2023.05.31
                                  case when x.gar_dtot <> 0 and  x.cod_rubro not like '210704%' then 0 else x.sld_dtot end sld_dtot, 
                                  case when x.gar_dtot <> 0 and  x.cod_rubro not like '210704%' then 0 else x.int_dtot end int_dtot,
                                  x.gar_dtot,
                                  --x.sld_dtot,x.int_dtot,x.gar_dtot,
                                  --< 2023.05.31
                                  x.p_impsaldo-x.p_impgaran p_impsaldo,x.p_impinter,x.p_impgaran,
                                  x.p_imp_fsd,x.p_int_fsd,x.p_gar_fsd,x.p_dii_fsd,
                                  x.dia_ape,x.num_titcta,x.cod_rubro,
                                  x.aomda,x.aomod,x.aocta,x.aoope,x.aosbo,x.aotop,x.key_segcta,x.tip_natper,
                                  x.cuentas_key,x.abr_segcta,x.cod_cliente,
                                  ---20240306
                                  x.aosuc
                                  ---
                             From TMP_FACT_FSDCLIE_CREDINKA x 
                            where --x.pais=ln_pais and tdoc=ln_tdoc and x.ndoc=lc_ndoc
                                  x.cod_cliente = lv_clie 
                              and x.fecha = ld_fec
                              and (substr(x.cod_rubro,1,8) not in ('21070401','21070402','21070409')
                                   --and x.salgar_mo <> 0
                                   and x.gar_dtot <> 0
                                   )
                              and x.tiempo_key is not null     
                          )Order By n_orden;
                                                  
   ld_Fecha  date := PD_FECHA;  
   ln_limfst number(12,2) := pq_tmp_carga_fsd.FN_LIMITE_FSD(ld_Fecha);  
   ln_limfsd number(12,2);
   --ln_tcam   number(7,3):= pq_tmp_carga_fsd.fn_tipo_cambio_fijo(ld_Fecha);    
   ln_psdo   number(13,3);
   ln_pint   number(13,3);
   ln_pgar   number(13,3);      
   ln_psdo_fsd   number(13,3);
   ln_pint_fsd   number(13,3);
   ln_pgar_fsd   number(13,3);    
   ln_saldo  number(13,3);  
   ln_saldo_fsd  number(13,3);
   ln_impacu number(13,3); 
   ln_ima_fsd number(13,3); 
   --ln_isdo number(13,3); 
   --ln_iint number(13,3); 
   --ln_igar number(13,3); 
   ln_tsdo number(13,3);   
   ln_tint number(13,3);   
   ln_tgar number(13,3);  
   --ln_tsdo_fsd number(13,3);   
   --ln_tint_fsd number(13,3);   
   --ln_tgar_fsd number(13,3);    
   lv_mdes varchar2(5);
   lv_tipcar varchar2(1);
   lv_estado varchar2(1);
   ln_tipcli Number(1);
   ln_indcob Number(1);
   lv_colemp Varchar2(1);
   
   ln_scob number(13,3); ln_icob number(13,3); ln_gcob number(13,3);
   ln_snco number(13,3); ln_inco number(13,3); ln_gnco number(13,3); 
   
  Begin
     Begin 
      -- Actualiza datos
      Update TMP_FACT_FSDCLIE_CREDINKA s
         set s.imp_lfsd = null,
             s.sld_pdis = null,
             s.int_pdis = null,
             s.gar_pdis = null,
             s.sld_pdnc = null,
             s.int_pdnc = null,
             s.gar_pdnc = null,
             s.cod_mdes = null
       where fecha = ld_Fecha 
         and tiempo_key is not null
         and ind_tipcli = 1;
       Commit;
       exception When Others Then
         null;
       end;               
            
       -- Monto cobertura   
       For c In c_clie(ld_Fecha) Loop
           lv_mdes := 'C00';
           ln_tipcli := 1;
           ln_impacu := 0;
           ln_ima_fsd:= 0;
           ln_indcob := 0;
           ln_limfsd := ln_limfst;
           
           ----
           lv_tipcar := Null;
           lv_estado := Null;
           lv_colemp := 'N';
           ----    
           If c.mtoacre < ln_limfst Then
              ln_limfsd := c.mtoacre;
              ln_indcob := 1;
              IF c.mtoacre < 0 Then 
                 ln_limfsd := 0;
              End IF;
           End If;   
           
           lv_colemp := 'N';
               
           --- Detalle de Cuentas
           For x In c_ctas(c.pais,c.tdoc,c.ndoc,ld_Fecha,c.cod_cliente) Loop
               IF ln_indcob = 1 Then
                  ln_saldo:= 0;
                  ln_psdo := nvl(x.sld_dtot,0);
                  ln_pint := nvl(x.int_dtot,0);
                  ln_pgar := nvl(x.gar_dtot,0);
                  ln_tsdo := ln_psdo;
                  ln_tint := ln_pint;
                  ln_tgar := ln_pgar;
                  
                  ----> REVISAR MTO TOT DE COBERTURA POR CLIENTE -----
                  IF c.mtoacre < 0 Then 
                     ln_tsdo := ln_psdo;
                     ln_tint := ln_pint;
                     ln_tgar := ln_pgar;
                     ln_psdo := 0;
                     ln_pint := 0;
                     ln_pgar := 0;
                  
                  
                  ----< REVISAR MTO TOT DE COBERTURA POR CLIENTE -----
                  ELSE
                      ----> REVISAR CADA CONCEPTO -----
                      IF ln_psdo < 0 Then
                         ln_tsdo := ln_psdo; 
                         ln_psdo := 0;
                      End If; 
                      
                      IF ln_pint < 0 Then
                         ln_tint := ln_pint; 
                         ln_pint := 0;
                      End If;
                      
                      IF ln_pgar < 0 Then
                         ln_tgar := ln_pgar;
                         ln_pgar := 0;
                      End If; 
                  End IF;
                  ln_saldo := nvl(ln_pgar,0)+nvl(ln_psdo,0)+nvl(ln_pint,0); 
                  ----< REVISAR CADA CONCEPTO -----
                  
                  
                  -- REVISAR SI YA SE GRABO DATO ANTERIOR
                   ln_scob := 0; ln_icob:= 0; ln_gcob := 0;
                         ln_snco := 0; ln_inco:= 0; ln_gnco := 0;
                         Begin
                         Select nvl(sld_pdis,0),nvl(int_pdis,0),nvl(gar_pdis,0),
                                nvl(sld_pdnc,0),nvl(int_pdnc,0),nvl(gar_pdnc,0)
                           Into ln_scob, ln_icob, ln_gcob,
                                ln_snco, ln_inco, ln_gnco 
                           From TMP_FACT_FSDCLIE_CREDINKA 
                           Where cod_cliente  = c.cod_cliente
                             and cuentas_key = x.cuentas_key
                             and fecha = ld_Fecha
                             and tiempo_key is not null;   
                         Exception When Others Then
                            ln_scob := 0; ln_icob:= 0; ln_gcob := 0;
                            ln_snco := 0; ln_inco:= 0; ln_gnco := 0;
                         End;    
                         
                         If ln_tsdo < ln_scob Then ln_tsdo := ln_tsdo; End If;
                         If ln_tint < ln_icob Then ln_tint := ln_tint; End If;
                         If ln_tgar < ln_gcob Then ln_tgar := ln_gcob; End If;
                         
                         ln_tsdo := ln_tsdo + ln_snco; 
                         ln_tint := ln_tint + ln_inco;
                         ln_tgar := ln_tgar + ln_gnco;
                         
                         ln_saldo  := ln_saldo + ln_scob+ln_icob+ln_gcob;
                         ln_psdo   := ln_psdo + ln_scob;
                         ln_pint   := ln_pint + ln_icob;
                         ln_pgar   := ln_pgar + ln_gcob;
                         
                  --->2023.05.31
                  If nvl(ln_psdo,0) + nvl(ln_pint,0) + nvl(ln_pgar,0) < 0 THEN
                    ln_psdo := 0;
                    ln_pint := 0;
                    ln_pgar := 0;
                    ln_tsdo := nvl(x.sld_dtot,0);
                    ln_tint := nvl(x.int_dtot,0);
                    ln_tgar := nvl(x.gar_dtot,0);
                  --< 2023.05.31
                  End If;       
                  
               ELSE   
                  ln_psdo := nvl(x.sld_dtot,0);
                  ln_pint := nvl(x.int_dtot,0);
                  ln_pgar := nvl(x.gar_dtot,0);
                  ln_tsdo:=nvl(ln_psdo,0);
                  ln_tint:=nvl(ln_pint,0);
                  ln_tgar:=nvl(ln_pgar,0);
                  
                  --->2023.05.31
                  If nvl(ln_psdo,0) + nvl(ln_pint,0) + nvl(ln_pint,0) < 0 THEN
                    ln_psdo := 0;
                    ln_pint := 0;
                    ln_pgar := 0;
                    ln_tsdo := nvl(x.sld_dtot,0);
                    ln_tint := nvl(x.int_dtot,0);
                    ln_tgar := nvl(x.gar_dtot,0);
                    
                  --< 2023.05.31
                  ELSE
                      ----> REVISAR CADA CONCEPTO -----
                      IF ln_psdo < 0 Then
                         ln_tsdo := ln_psdo; 
                         ln_psdo := 0;
                      End If; 
                      
                      IF ln_pint < 0 Then
                         ln_tint := ln_pint; 
                         ln_pint := 0;
                      End If;
                      
                      IF ln_pgar < 0 Then
                         ln_tgar := ln_pgar;
                         ln_pgar := 0;
                      End If; 
                  End If;
                  ----< REVISAR CADA CONCEPTO -----
                  
                  If x.tipimp = 'G' and x.cod_rubro not like '210704%' Then
                     ln_saldo := ln_pgar + ln_pint;
                     ln_psdo  := 0;
                     ln_pint  := 0;
               
                     ln_saldo_fsd := ln_pgar_fsd + ln_pint_fsd;
                     ln_psdo_fsd  := 0;
                     ln_pint_fsd  := 0;
                  Else
                     ln_saldo := nvl(ln_pgar,0)+nvl(ln_psdo,0)+nvl(ln_pint,0);
                     ln_saldo_fsd := ln_pgar_fsd+ln_psdo_fsd+ln_pint_fsd;
                  End If;
            
                  --- Datamart
                  If (ln_impacu+ln_saldo) < ln_limfsd Then
                      ln_impacu := ln_impacu + ln_saldo;
                  Else 
                     If ln_impacu < ln_limfsd Then
                        ln_saldo  := ln_limfsd - ln_impacu;
                        ln_impacu := ln_impacu + ln_saldo;
                     
                        If ln_tgar <= ln_saldo and ln_tgar >= 0 Then
                           ln_pgar := ln_tgar;
                           ln_saldo:= ln_saldo - ln_pgar;
                        Else
                           ln_pgar := ln_saldo;
                           ln_saldo:= 0;
                        End If;   
                     
                        If ln_tsdo <= ln_saldo and ln_tsdo >= 0 Then
                           ln_psdo := ln_tsdo;
                           ln_saldo:= ln_saldo - ln_psdo;
                        Else
                           ln_psdo := ln_saldo;
                           ln_saldo:= 0;
                        End If;
                     
                        If ln_tint <= ln_saldo and ln_tint >= 0 Then
                           ln_pint := ln_tint;
                           ln_saldo:= ln_saldo - ln_tint;
                        Else
                           ln_pint := ln_saldo;
                           ln_saldo:= 0;
                        End If;
                     
                     Else    
                         ln_saldo  := 0;
                         ln_psdo   := 0;
                         ln_pint   := 0;
                         ln_pgar   := 0;
                         
                     End If;
                  End If;
                  
                  -- REVISAR SI YA SE GRABO DATO ANTERIOR
                         --> 2023.05.31
                         ln_scob := 0; ln_icob:= 0; ln_gcob := 0;
                         ln_snco := 0; ln_inco:= 0; ln_gnco := 0;
                         Begin
                         Select nvl(sld_pdis,0),nvl(int_pdis,0),nvl(gar_pdis,0),
                                nvl(sld_pdnc,0),nvl(int_pdnc,0),nvl(gar_pdnc,0)
                           Into ln_scob, ln_icob, ln_gcob,
                                ln_snco, ln_inco, ln_gnco 
                           From TMP_FACT_FSDCLIE_CREDINKA 
                           Where cod_cliente  = c.cod_cliente
                             and cuentas_key  = x.cuentas_key
                             and fecha = ld_Fecha
                             and tiempo_key is not null;   
                         Exception When Others Then
                            ln_scob := 0; ln_icob:= 0; ln_gcob := 0;
                            ln_snco := 0; ln_inco:= 0; ln_gnco := 0;
                         End;    
                         
                         If ln_tsdo < ln_scob Then ln_tsdo := ln_tsdo; End If;
                         If ln_tint < ln_icob Then ln_tint := ln_tint; End If;
                         If ln_tgar < ln_gcob Then ln_tgar := ln_gcob; End If;
                         
                         ln_tsdo := ln_tsdo + ln_snco; 
                         ln_tint := ln_tint + ln_inco;
                         ln_tgar := ln_tgar + ln_gnco;
                         
                         ln_saldo  := ln_saldo + ln_scob+ln_icob+ln_gcob;
                         ln_psdo   := ln_psdo + ln_scob;
                         ln_pint   := ln_pint + ln_icob;
                         ln_pgar   := ln_pgar + ln_gcob;
              END IF;
              
              If x.abr_segcta = 'IF' Then
                 lv_mdes := 'C10'; --Sist.Finan.
              ElsIf x.abr_segcta = 'PJ C/L' and x.tip_natper = 'J' Then      
                 lv_mdes := 'C60'; -- PJ Lucro
              Elsif(ln_tsdo-ln_psdo) + (ln_tint-ln_pint) + (ln_tgar-ln_pgar) > 0 Then
                 lv_mdes := 'C50';
              End If;
                         
            
              Update TMP_FACT_FSDCLIE_CREDINKA s
                 set s.imp_lfsd = ln_limfst,
                     s.sld_pdis = ln_psdo,
                     s.int_pdis = ln_pint,
                     s.gar_pdis = ln_pgar,
                     s.sld_pdnc = (ln_tsdo-ln_psdo),
                     s.int_pdnc = (ln_tint-ln_pint),
                     s.gar_pdnc = (ln_tgar-ln_pgar),
                     s.cod_mdes = lv_mdes,
                     s.ind_colcaj = lv_colemp
               Where s.cod_cliente = c.cod_cliente
                 and s.cuentas_key = x.cuentas_key
                 and s.fecha = ld_Fecha
                 and s.tiempo_key is not null;
                -- and s.imp_lfsd is null;      
             Commit;   
           End Loop;
        End Loop;
  End SP_SALDOS_COBERTURADOS_CLIE;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Procedure SP_ANEXO17A(PD_FECHA In Date)
 -------------------------------------------
 -- Modificación
 -------------------------------------------
 -- Fecha : 2021.09.13
 -- Autor : Paola Vargas
 -- Cambio: Totales seccion B version 2022
 -----------------------------------------------------------------------------------
 -- Fecha : 2023.10.01
 -- Autor : Paola Vargas
 -- Cambio: Sección A (cod_anexo=1) excluir códigos (C20,C30,C40 - Excluidos)
 -----------------------------------------------------------------------------------
 Is 
      Cursor c_detanex (ld_fec in Date)
          Is select * from TMP_DM_FSD_CONANEX;
      
      ld_fecha      date := PD_FECHA; 
      ld_diaini     date := to_date(to_char(ld_fecha,'rrrrmm')||'01','rrrrmmdd');  
      ln_tcam number(7,3):= pq_tmp_carga_fsd.fn_tipo_cambio_fijo(ld_fecha); 
      ln_ord Number(5);
      ln_imptot Number(15,2);
      nTipPro Number(1) := 4; 
   Begin
     
        -- Elimina los registros cargados en procesos anteriores
        Begin
           Delete from TMP_FACT_FSD_ANEXOS f 
            where f.fecha=ld_fecha and nvl(f.ind_proceso,1) = nTipPro;
           Commit;
        Exception When Others Then
           Null;  
        End;
   

        For x in c_detanex (ld_fecha) Loop
            If (x.cod_anexo=1 and x.ind_sindat = 0) or (x.cod_anexo=2 and x.ind_sindat = 0) Then
               Insert Into TMP_FACT_FSD_ANEXOS(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                               imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,
                                               ind_proceso,imp_tcam)
                                        Values(ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,
                                               x.des_conane,0,0,0,0,0,nTipPro,ln_tcam);
            ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=6 Then
                  Insert Into TMP_FACT_FSD_ANEXOS(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                                  imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,
                                                  ind_proceso,imp_tcam)
                                           Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                                  sum(case when aomda=0 then sld_dtot else 0 end),
                                                  sum(case when aomda=101 then sld_dtot else 0 end),
                                                  count(distinct case when aomda=0 then cuentas_key end),
                                                  count(distinct case when aomda=101 then cuentas_key end),
                                                  count(distinct case when c.fec_apertura>=ld_diaini then cuentas_key end),
                                                  nTipPro,ln_tcam
                                             From TMP_FACT_FSDCLIE_CREDINKA c 
                                            Where c.cod_rubro like '21011201%' 
                                              and c.cod_mdes in ('C00','C50')
                                              and c.fecha = ld_fecha;
            ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=7 Then
                  Insert Into TMP_FACT_FSD_ANEXOS(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                                  imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,
                                                  ind_proceso,imp_tcam)
                                           Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                                  sum(case when aomda=0 then int_dtot else 0 end),
                                                  sum(case when aomda=101 then int_dtot else 0 end),
                                                  count(distinct case when aomda=0 then cuentas_key end),
                                                  count(distinct case when aomda=101 then cuentas_key end),
                                                  count(distinct case when c.fec_apertura>=ld_diaini then cuentas_key end),
                                                  nTipPro,ln_tcam
                                             From TMP_FACT_FSDCLIE_CREDINKA c 
                                            Where c.cod_mdes in ('C00','C50')
                                              and c.fecha = ld_fecha
                                              and (cod_rubro like '21011201%' or 
                                                   cod_rubro like '21020101%' or 
                                                   cod_rubro like '21030301%' or 
                                                   cod_rubro like '210305%' or 
                                                   cod_rubro like '21020201%' or 
                                                   cod_rubro like '21070401%' or
                                                   cod_rubro like '21070402%' or
                                                   cod_rubro like '21070409%' or
                                                   cod_rubro like '21080301%'
                                                  );
            ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=8 Then  
                  Insert Into TMP_FACT_FSD_ANEXOS(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                                  imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,
                                                  ind_proceso,imp_tcam)
                                           Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                                  sum(case when aomda=0 then sld_dtot else 0 end),
                                                  sum(case when aomda=101 then sld_dtot else 0 end),
                                                  count(distinct case when aomda=0 then cuentas_key end),
                                                  count(distinct case when aomda=101 then cuentas_key end),
                                                  count(distinct case when c.fec_apertura>=ld_diaini then cuentas_key end),
                                                  nTipPro,ln_tcam
                                             From TMP_FACT_FSDCLIE_CREDINKA c 
                                            Where c.cod_rubro like '21020101%' 
                                              and c.cod_mdes in ('C00','C50')
                                              and c.fecha = ld_fecha;
            ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=10 Then
                  Insert Into TMP_FACT_FSD_ANEXOS(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                                  imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,
                                                  ind_proceso,imp_tcam)
                                           Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                                  sum(case when aomda=0 then sld_dtot + nvl(gar_dtot,0) else 0 end),
                                                  sum(case when aomda=101 then sld_dtot + nvl(gar_dtot,0) else 0 end),
                                                  count(distinct case when aomda=0 then cuentas_key end),
                                                  count(distinct case when aomda=101 then cuentas_key end),
                                                  count(distinct case when c.fec_apertura>=ld_diaini then cuentas_key end),
                                                  nTipPro,ln_tcam
                                             From TMP_FACT_FSDCLIE_CREDINKA c 
                                            Where c.cod_mdes in ('C00','C50')
                                              and (c.cod_rubro like '21030301%')
                                              and c.fecha = ld_fecha;
            ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=12 Then
                  Insert Into TMP_FACT_FSD_ANEXOS(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                                  imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,
                                                  ind_proceso,imp_tcam)
                                           Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                                  sum(case when aomda=0 and substr(cod_rubro,1,8) in ('21070401','21070402','21070409')
                                                           then nvl(gar_dtot,0) + nvl(sld_dtot,0)
                                                           when aomda=0 and substr(cod_rubro,1,8) not in ('21070401','21070402','21070409')
                                                           then nvl(gar_dtot,0) 
                                                           else 0 
                                                      end),
                                                  sum(case when aomda=101 and substr(cod_rubro,1,8) in ('21070401','21070402','21070409')
                                                           then nvl(gar_dtot,0) + nvl(sld_dtot,0) 
                                                           when aomda=101 and substr(cod_rubro,1,8) not in ('21070401','21070402','21070409')
                                                           then nvl(gar_dtot,0) 
                                                           else 0 
                                                      end),
                                                  count(distinct case when aomda=0 then cuentas_key end),
                                                  count(distinct case when aomda=101 then cuentas_key end),
                                                  count(distinct case when c.fec_apertura>=ld_diaini then cuentas_key end),
                                                  nTipPro,ln_tcam
                                             From TMP_FACT_FSDCLIE_CREDINKA c 
                                            Where c.gar_dtot <> 0 
                                              and c.cod_mdes in ('C00','C50')
                                              and c.fecha = ld_fecha
                                              and (cod_rubro like '21011201%' or 
                                                   cod_rubro like '21020101%' or 
                                                   cod_rubro like '210305%'   or 
                                                   cod_rubro like '21020201%' or 
                                                   cod_rubro like '21070401%' or
                                                   cod_rubro like '21070402%' or
                                                   cod_rubro like '21070409%' --or
                                                  );
            ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=14 Then
                  Insert Into TMP_FACT_FSD_ANEXOS(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                                  imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,
                                                  ind_proceso,imp_tcam)
                                           Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                                  sum(case when aomda=0 then sld_dtot else 0 end),
                                                  sum(case when aomda=101 then sld_dtot else 0 end),
                                                  count(distinct case when aomda=0 then cuentas_key end),
                                                  count(distinct case when aomda=101 then cuentas_key end),
                                                  count(distinct case when c.fec_apertura>=ld_diaini then cuentas_key end),
                                                  nTipPro,ln_tcam
                                             From TMP_FACT_FSDCLIE_CREDINKA c 
                                            Where c.cod_rubro like '210305%' 
                                              and c.cod_mdes in ('C00','C50')
                                              and c.fecha = ld_fecha;
            ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=15 Then
                  Insert Into TMP_FACT_FSD_ANEXOS
                             (fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                              imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,
                              ind_proceso,imp_tcam) 
                       Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                              sum(case when aomda=0 then sld_dtot else 0 end),
                              sum(case when aomda=101 then sld_dtot else 0 end),
                              count(distinct case when aomda=0 then cuentas_key end),
                              count(distinct case when aomda=101 then cuentas_key end),
                              count(distinct case when c.fec_apertura>=ld_diaini then cuentas_key end),
                              nTipPro,ln_tcam
                         From TMP_FACT_FSDCLIE_CREDINKA c 
                        Where (c.cod_rubro like '21_70101%' or 
                               c.cod_rubro like '21_70201%' or
                               c.cod_rubro like '21_70301%' or
                               c.cod_rubro like '21_70901%'
                              ) 
                          and c.cod_mdes in ('C00','C50')
                          and c.fecha = ld_fecha;                                
                  --< 2024.02.05                                
            ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=16 Then
                  Insert Into TMP_FACT_FSD_ANEXOS(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                                  imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,
                                                  ind_proceso,imp_tcam)
                                           Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                                  sum(case when aomda=0 then sld_dtot else 0 end),
                                                  sum(case when aomda=101 then sld_dtot else 0 end),
                                                  count(distinct case when aomda=0 then cuentas_key end),
                                                  count(distinct case when aomda=101 then cuentas_key end),
                                                  count(distinct case when c.fec_apertura>=ld_diaini then cuentas_key end),
                                                  nTipPro,ln_tcam
                                             From TMP_FACT_FSDCLIE_CREDINKA c 
                                            Where c.cod_rubro like '21020201%' 
                                              and c.cod_mdes in ('C00','C50')
                                              and c.fecha = ld_fecha;
            ElsIf x.cod_anexo=31 and x.ind_sindat = 0 Then
                  Insert Into TMP_FACT_FSD_ANEXOS(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                                  imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso,imp_tcam)
                                           Values(ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                                  0,0,0,0,nTipPro,ln_tcam);
            ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=6 Then
                  Insert Into TMP_FACT_FSD_ANEXOS(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                                  imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso,
                                                  imp_tcam)
                                           Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                                  sum(case when aomda=0 then sld_pdis+nvl(c.int_pdis,0) else 0 end),
                                                  sum(case when aomda=101 then sld_pdis+nvl(c.int_pdis,0) else 0 end),
                                                  count(distinct case when aomda=0 then cuentas_key end),
                                                  count(distinct case when aomda=101 then cuentas_key end),
                                                  nTipPro,ln_tcam
                                             From TMP_FACT_FSDCLIE_CREDINKA c 
                                            Where c.cod_rubro like '21011201%' 
                                              and c.cod_mdes in ('C00','C50')
                                              and c.ind_tipcli = 1
                                              and c.fecha = ld_fecha;
            ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=7 Then
                  Insert Into TMP_FACT_FSD_ANEXOS(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                                  imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso,
                                                  imp_tcam)
                                           Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                                  sum(case when aomda=0 then sld_pdis+nvl(c.int_pdis,0) else 0 end),
                                                  sum(case when aomda=101 then sld_pdis+nvl(c.int_pdis,0) else 0 end),
                                                  count(distinct case when aomda=0 then cuentas_key end),
                                                  count(distinct case when aomda=101 then cuentas_key end),
                                                  nTipPro,ln_tcam
                                             From TMP_FACT_FSDCLIE_CREDINKA c 
                                            Where c.cod_rubro like '21020101%' 
                                              and c.cod_mdes in ('C00','C50')
                                              and c.ind_tipcli = 1
                                              and c.fecha = ld_fecha;
            ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=9 Then
                  Insert Into TMP_FACT_FSD_ANEXOS(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                                  imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso,
                                                  imp_tcam)
                                           Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                                  sum(case when aomda=0 then nvl(sld_pdis,0)+nvl(c.int_pdis,0)+nvl(c.gar_pdis,0) else 0 end),  --- suma interes
                                                  sum(case when aomda=101 then nvl(sld_pdis,0)+nvl(c.int_pdis,0)+nvl(c.gar_pdis,0) else 0 end),--- suma interes
                                                  count(distinct case when aomda=0 then cuentas_key end),
                                                  count(distinct case when aomda=101 then cuentas_key end),
                                                  nTipPro,ln_tcam            
                                             From TMP_FACT_FSDCLIE_CREDINKA c 
                                            Where (c.cod_rubro like '21030301%' or cod_rubro like '21080301%')  
                                              and c.cod_mdes in ('C00','C50')
                                              and c.ind_tipcli = 1
                                              and c.fecha = ld_fecha;
           ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=11 Then
                 Insert Into TMP_FACT_FSD_ANEXOS(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                                 imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso,imp_tcam)
                                          Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                                 sum(case when aomda=0 and substr(cod_rubro,1,8) in ('21070401','21070402','21070409')
                                                          then gar_pdis+nvl(c.int_pdis,0)+nvl(c.sld_pdis,0)
                                                          when aomda=0 and substr(cod_rubro,1,8) not in ('21070401','21070402','21070409')
                                                          then gar_pdis
                                                          else 0 
                                                     end),
                                                 sum(case when aomda=101 and substr(cod_rubro,1,8) in ('21070401','21070402','21070409')
                                                          then gar_pdis+nvl(c.int_pdis,0)+nvl(c.sld_pdis,0) 
                                                          when aomda=101 and substr(cod_rubro,1,8) not in ('21070401','21070402','21070409')
                                                          then gar_pdis
                                                          else 0 
                                                     end),
                                                 count(distinct case when aomda=0 then cuentas_key end),
                                                 count(distinct case when aomda=101 then cuentas_key end),
                                                 nTipPro,ln_tcam                                  
                                            From TMP_FACT_FSDCLIE_CREDINKA c 
                                           Where c.gar_pdis <> 0 
                                             and c.cod_mdes in ('C00','C50')
                                             and c.ind_tipcli = 1
                                             and c.fecha = ld_fecha
                                             and (cod_rubro like '21011201%' or 
                                                  cod_rubro like '21020101%' or 
                                                  cod_rubro like '210305%' or 
                                                  cod_rubro like '21020201%' or 
                                                  cod_rubro like '21070401%' or
                                                  cod_rubro like '21070402%' or
                                                  cod_rubro like '21070409%' 
                                                 );
           ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=13 Then
                 Insert Into TMP_FACT_FSD_ANEXOS(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                                 imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso,imp_tcam)
                                          Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                                 sum(case when aomda=0 then sld_pdis+nvl(c.int_pdis,0) else 0 end),
                                                 sum(case when aomda=101 then sld_pdis+nvl(c.int_pdis,0) else 0 end),
                                                 count(distinct case when aomda=0 then cuentas_key end),
                                                 count(distinct case when aomda=101 then cuentas_key end),
                                                 nTipPro,ln_tcam
                                            From TMP_FACT_FSDCLIE_CREDINKA c 
                                           Where c.cod_rubro like '210305%' 
                                             and c.cod_mdes in ('C00','C50')
                                             and c.ind_tipcli = 1
                                             and c.fecha = ld_fecha;
           -->2024.02.05
           ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=14 Then
                 Insert Into TMP_FACT_FSD_ANEXOS
                            (fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso,imp_tcam)
                      Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                             nvl(sum(case when aomda=0 then nvl(sld_pdis,0)+nvl(c.int_pdis,0)+nvl(c.gar_pdis,0) else 0 end),0),
                             nvl(sum(case when aomda=101 then nvl(sld_pdis,0)+nvl(c.int_pdis,0)+nvl(c.gar_pdis,0) else 0 end),0),                             
                             count(distinct case when aomda=0 then cuentas_key end),
                             count(distinct case when aomda=101 then cuentas_key end),
                             nTipPro,ln_tcam
                        From TMP_FACT_FSDCLIE_CREDINKA c 
                       Where (c.cod_rubro like '21_70101%' or 
                              c.cod_rubro like '21_70201%' or
                              c.cod_rubro like '21_70301%' or
                              c.cod_rubro like '21_70901%'
                             ) 
                         and c.cod_mdes in ('C00','C50')
                         and c.ind_tipcli = 1
                         and c.fecha = ld_fecha;    
           --<2024.02.05
           ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=15 Then
                 Insert Into TMP_FACT_FSD_ANEXOS(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                                 imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso,imp_tcam)
                                          Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                                 sum(case when aomda=0 then sld_pdis +nvl(c.int_pdis,0)else 0 end),
                                                 sum(case when aomda=101 then sld_pdis+nvl(c.int_pdis,0) else 0 end),
                                                 count(distinct case when aomda=0 then cuentas_key end),
                                                 count(distinct case when aomda=101 then cuentas_key end),
                                                 nTipPro,ln_tcam
                                            from TMP_FACT_FSDCLIE_CREDINKA c 
                                           Where c.cod_rubro like '21020201%' 
                                             and c.cod_mdes in ('C00','C50')
                                             and c.ind_tipcli = 1
                                             --and c.tdoc <> 27 
                                             and c.fecha = ld_fecha;
           ElsIf x.cod_anexo=32 and x.ind_sindat = 0 Then
                 Insert Into TMP_FACT_FSD_ANEXOS(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                                 imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso,imp_tcam)
                                          Values(ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                                 0,0,0,0,nTipPro,ln_tcam);
       ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=6 Then
             Insert Into TMP_FACT_FSD_ANEXOS(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso,imp_tcam)
                                      Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                             sum(case when aomda=0 then sld_pdis+nvl(c.int_pdis,0) else 0 end),
                                             sum(case when aomda=101 then sld_pdis+nvl(c.int_pdis,0) else 0 end),
                                             count(distinct case when aomda=0 then cuentas_key end),
                                             count(distinct case when aomda=101 then cuentas_key end),
                                             nTipPro,ln_tcam
                                        From TMP_FACT_FSDCLIE_CREDINKA c 
                                       Where c.cod_rubro like '21011201%' 
                                         and c.cod_mdes in ('C00','C50')
                                         and c.ind_tipcli = 2 
                                         and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=7 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso,imp_tcam)
                                     Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                            sum(case when aomda=0 then sld_pdis+nvl(c.int_pdis,0) else 0 end),
                                            sum(case when aomda=101 then sld_pdis+nvl(c.int_pdis,0) else 0 end),
                                            count(distinct case when aomda=0 then cuentas_key end),
                                            count(distinct case when aomda=101 then cuentas_key end),
                                            nTipPro,ln_tcam
                                       From TMP_FACT_FSDCLIE_CREDINKA c
                                      where c.cod_rubro like '21020101%' and c.cod_mdes in ('C00','C50')
                                       and c.ind_tipcli = 2
                                       and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=9 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso,imp_tcam)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then nvl(sld_pdis,0)+nvl(c.int_pdis,0)+nvl(c.gar_pdis,0) else 0 end),
                    sum(case when aomda=101 then nvl(sld_pdis,0)+nvl(c.int_pdis,0)+nvl(c.gar_pdis,0) else 0 end),
                    count(distinct case when aomda=0 then cuentas_key end),
                    count(distinct case when aomda=101 then cuentas_key end),
                    nTipPro,ln_tcam
               from TMP_FACT_FSDCLIE_CREDINKA c 
              where (c.cod_rubro like '21030301%' or cod_rubro like '21080301%')
               and c.cod_mdes in ('C00','C50')
               and c.ind_tipcli = 2
               and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=11 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso,imp_tcam)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 and substr(cod_rubro,1,8) in ('21070401','21070402','21070409')
                            then gar_pdis+nvl(c.int_pdis,0)+nvl(c.sld_pdis,0)
                            when aomda=0 and substr(cod_rubro,1,8) not in ('21070401','21070402','21070409')
                            then gar_pdis
                            else 0 
                       end),
                   sum(case when aomda=101 and substr(cod_rubro,1,8) in ('21070401','21070402','21070409')
                            then gar_pdis+nvl(c.int_pdis,0)+nvl(c.sld_pdis,0) 
                            when aomda=101 and substr(cod_rubro,1,8) not in ('21070401','21070402','21070409')
                            then gar_pdis
                            else 0 
                       end),
                    count(distinct case when aomda=0 then cuentas_key end),
                    count(distinct case when aomda=101 then cuentas_key end),
                    nTipPro,ln_tcam
               from TMP_FACT_FSDCLIE_CREDINKA c 
               where c.gar_pdis <> 0 
               and c.cod_mdes in ('C00','C50')
               and c.ind_tipcli = 2
               and c.fecha = ld_fecha
               and (cod_rubro like '21011201%' or 
                    cod_rubro like '21020101%' or 
                    cod_rubro like '210305%' or 
                    cod_rubro like '21020201%' or 
                    cod_rubro like '21070401%' or
                    cod_rubro like '21070402%' or
                    cod_rubro like '21070409%' or
                    ind_tipcli = 2
                   );
       ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=13 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso,imp_tcam)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then sld_pdis+nvl(c.int_pdis,0) else 0 end),
                    sum(case when aomda=101 then sld_pdis+nvl(c.int_pdis,0) else 0 end),
                    count(distinct case when aomda=0 then cuentas_key end),
                    count(distinct case when aomda=101 then cuentas_key end),
                    nTipPro,ln_tcam
               from TMP_FACT_FSDCLIE_CREDINKA c 
               where c.cod_rubro like '210305%' and c.cod_mdes in ('C00','C50')
               and c.ind_tipcli = 2
               and c.fecha = ld_fecha;
       -->2024.02.05
       ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=14 Then
                 Insert Into TMP_FACT_FSD_ANEXOS
                            (fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso,imp_tcam)
                      Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                             nvl(sum(case when aomda=0 then nvl(sld_pdis,0)+nvl(c.int_pdis,0)+nvl(c.gar_pdis,0) else 0 end),0),
                             nvl(sum(case when aomda=101 then nvl(sld_pdis,0)+nvl(c.int_pdis,0)+nvl(c.gar_pdis,0) else 0 end),0),
                             count(distinct case when aomda=0 then cuentas_key end),
                             count(distinct case when aomda=101 then cuentas_key end),
                             nTipPro,ln_tcam
                        From TMP_FACT_FSDCLIE_CREDINKA c 
                       Where (c.cod_rubro like '21_70101%' or 
                              c.cod_rubro like '21_70201%' or
                              c.cod_rubro like '21_70301%' or
                              c.cod_rubro like '21_70901%'
                             ) 
                         and c.cod_mdes in ('C00','C50')
                         and c.ind_tipcli = 2
                         and c.fecha = ld_fecha;    
       --<2024.02.05               
       ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=15 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso,imp_tcam)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then sld_pdis+nvl(c.int_pdis,0) else 0 end),
                    sum(case when aomda=101 then sld_pdis+nvl(c.int_pdis,0) else 0 end),
                    count(distinct case when aomda=0 then cuentas_key end),
                    count(distinct case when aomda=101 then cuentas_key end),
                    nTipPro,ln_tcam
               from TMP_FACT_FSDCLIE_CREDINKA c 
              where c.cod_rubro like '21020201%' and c.cod_mdes in ('C00','C50')
               and c.ind_tipcli = 2
               and c.fecha = ld_fecha;
       End If;      
       Commit;
   End Loop;
       
   -- SECCION D
   Begin   
       Insert into tmp_fact_fsd_anexos
                  (fecha,cod_anexo,ord_conane,rub_conane,des_conane,imp_soles,imp_dolar,
                   cta_soles,cta_dolar,cta_nueva,ind_proceso,imp_tcam)
       Select a.fecha,a.cod_anexo,1,'TOTAL D',Null,soles_a-soles_c,dolar_a-dolar_c,0,0,
              total,nTipPro,a.imp_tcam
        From (
             select fecha,4 cod_anexo, sum(imp_soles) soles_a,sum(imp_dolar) dolar_a, 
                    sum(imp_soles+imp_dolar) total,imp_tcam
               from tmp_fact_fsd_anexos 
              where cod_anexo=1 and ind_proceso=nTipPro and fecha=ld_fecha
              group by fecha,imp_tcam
             ) a,
             ( 
             select fecha,4 cod_anexo, sum(imp_soles) soles_c,sum(imp_dolar) dolar_c
               from tmp_fact_fsd_anexos where cod_anexo in (31,32) 
                and ind_proceso=nTipPro 
                and fecha=ld_fecha
              group by fecha
             ) c
       Where a.fecha = c.fecha
         and a.cod_anexo = c.cod_anexo; 
       Commit;
   Exception When Others Then
       Null;
   End;       
   --------------------
   -- TOTALES SECCION C
   ---------------------
   ln_imptot := 0;

   For x in c_detanex (ld_fecha) Loop
       If x.cod_anexo in (31,32) and x.ind_sindat = 1 Then
             If x.ord_conane < 7 Then
                ln_ord := x.ord_conane ;
             Else 
                ln_ord := x.ord_conane + 1;
             End If;
              
              Begin --IMPORTE TOTAL SECCION A
                Select sum(nvl(j.imp_soles,0)+nvl(j.imp_dolar,0))
                  Into ln_imptot
                  From tmp_fact_fsd_anexos j
                 Where j.fecha=ld_fecha
                   and j.cod_anexo = 1
                   and j.ord_conane = ln_ord
                   and j.ind_proceso = nTipPro; 
              Exception When Others Then
                 ln_imptot := 0;
              End;
        
              Update tmp_fact_fsd_anexos g
                 Set g.cta_nueva = ln_imptot
               Where g.fecha=ld_fecha
                 and g.cod_anexo = x.cod_anexo
                 and g.ord_conane= x.ord_conane
                 and g.ind_proceso=nTipPro;
              Commit;           
       End If;
   End Loop;
       
   --------------------------
   -- TOTALES SECCION B V2022
   --------------------------
   ln_imptot := 0;
   Begin --IMPORTE TOTAL SECCION A
          Select sum(nvl(j.imp_soles,0)+nvl(j.imp_dolar,0))
            Into ln_imptot
            From tmp_fact_fsd_anexos j
           Where j.fecha=ld_fecha
             and j.cod_anexo = 1
             and j.ind_proceso = nTipPro; 
   Exception When Others Then
           ln_imptot := 0;
   End;   
        
       Insert Into tmp_fact_fsd_anexos(fecha,COD_ANEXO,ORD_CONANE,DES_CONANE,
                                       IMP_SOLES ,IMP_DOLAR,CTA_SOLES,CTA_DOLAR,CTA_NUEVA,IND_PROCESO,
                                       imp_tcam)                                 
       select fecha,41,1,'Total (B1)',sum(imp_soles),sum(imp_dolar),
              sum(cta_soles),sum(cta_dolar), ln_imptot,--sum(cta_nueva),
              ind_proceso,max(imp_tcam)
      from tmp_fact_fsd_anexos 
     Where IND_PROCESO =nTipPro 
       and Fecha = ld_fecha
       and cod_anexo = 31                                    
      group by fecha,ind_proceso;
      Commit;
      
      
      Insert Into tmp_fact_fsd_anexos(fecha,COD_ANEXO,ORD_CONANE,DES_CONANE,
                                      IMP_SOLES ,IMP_DOLAR,CTA_SOLES,CTA_DOLAR,CTA_NUEVA,IND_PROCESO,
                                      imp_tcam)  
      select fecha,42,1,'Total (B2)',sum(imp_soles),sum(imp_dolar),
             sum(cta_soles),sum(cta_dolar), ln_imptot,--sum(cta_nueva),
             ind_proceso,max(imp_tcam)
        from tmp_fact_fsd_anexos 
       Where IND_PROCESO =nTipPro 
         and fecha = ld_fecha 
         and cod_anexo = 32                                    
       group by fecha,ind_proceso;
       Commit;
      
       Insert Into tmp_fact_fsd_anexos(FECHA,COD_ANEXO,ORD_CONANE,DES_CONANE,
                                       IMP_SOLES ,IMP_DOLAR,CTA_SOLES,CTA_DOLAR,
                                       CTA_NUEVA,IND_PROCESO,imp_tcam)                                 
       select fecha,43,1,'TOTAL B (B1 +B2)',sum(imp_soles),sum(imp_dolar),
              sum(cta_soles),sum(cta_dolar), ln_imptot,--sum(cta_nueva),
              ind_proceso,max(imp_tcam)
         from tmp_fact_fsd_anexos 
        Where IND_PROCESO =nTipPro 
          and fecha = ld_fecha 
          and cod_anexo in (32,31)                                    
      group by fecha,ind_proceso;
      Commit;
      
  End SP_ANEXO17A;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end PQ_TMP_FSD_CREDINKA;
/
