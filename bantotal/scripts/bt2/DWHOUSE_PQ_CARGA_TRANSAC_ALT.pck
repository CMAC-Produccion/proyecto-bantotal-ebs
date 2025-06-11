create or replace package PQ_CARGA_TRANSAC is

  -- Author  : PVARGAS
  -- Created : 10/05/2018 12:25:53 p.m.
  -- Purpose : 
  
  -- Fecha  : 2022-10-07
  -- Autor  : Paola Vargas
  -- Cambio : Carga dimension perfiles de usuario SP_DM_PERFIL_USU
  
  -- Fecha  : 2024.10.26
  -- Autor  : Paola Vargas
  -- Cambio : Nuevo proceso SP_FACT_P51_ERRORES para reporte errores en P51  
  
  Procedure SP_JOB_TRX_ONLINE;
  Procedure SP_CARGA_DIMENSIONES;
  Procedure SP_CARGA_HECHOS(PD_FECHA In Date);
  
  Procedure SP_DM_OP_REGION ;
  Procedure SP_DM_ATM;
  Procedure SP_DM_DENODIN;
  Procedure SP_DM_TIPODIN; 
  
  Procedure sp_fact_op_billetaje (PD_FECHA In date);

  Procedure SP_DM_ESTILO_TARJETA;
  Procedure SP_DM_VIGENCIA_TARJETA;
  Procedure SP_DM_PIN_TARJETA;
  Procedure SP_DM_LIMITE_TARJETA;
  Procedure SP_DM_COM_TARJETA;
  Procedure SP_DM_MEM_TARJETA;  
  Procedure SP_DM_TIPO_TARJETA;
  Procedure SP_DM_MONEDA_ATM;
  Procedure SP_DM_EMPABA_ATM;
  Procedure SP_DM_RUTA_ATM;
  Procedure SP_DM_TEC_TARJETA;
  Procedure SP_DM_EMPRESA_SERV ;
  Procedure SP_DM_SERVICIO_AFIL;
  Procedure SP_JOBS_DM_TARJETA;--(PD_FECHA In Date); 
  Procedure sp_DM_TARJETA (PV_CODSUC In Varchar2);
  Procedure sp_FACT_OP_SERVAFIL (PD_FECHA In date);
  Procedure SP_DM_TIPOMOV;
  Procedure SP_DM_INGEGR;
  Procedure SP_DM_CANAL;
  Procedure SP_DM_DETCANAL;
  Procedure sp_job_fact_op_transaccion(PD_FECHA In date); 
  Procedure sp_fact_op_transaccion (PN_CODSUC In Number,PV_FECHA  In Varchar2);
  Procedure SP_DM_MOTCANCELA;
  Procedure SP_DM_MOTEXTORNO;
  Procedure SP_DM_SEGMENTO_CTA;
  Procedure SP_ACT_DM_CLASETRX_GAS;
  Procedure sp_fact_op_trxcom (PV_FECHA  In Varchar2);
  Procedure sp_fact_op_apertura_aho (PN_CODSUC In Number,PV_FECHA In Varchar2);
  Procedure SP_ELIMINA_TRX_DIA;
  PROCEDURE SP_DM_PAIS_ESTDPT;
  PROCEDURE SP_DM_COMERCIO_POS;
  Procedure SP_FACT_OP_CLITRX(PD_FECHA In Date);
  
  PROCEDURE SP_DM_PERFIL_USU;
  
  PROCEDURE SP_FACT_P51_ERRORES(PD_FECHA in date);
      
end PQ_CARGA_TRANSAC;
/
create or replace package body PQ_CARGA_TRANSAC is
---------------------------------------------------------------------------------------------
Procedure SP_CARGA_DIMENSIONES
Is
  -- Fecha : 2022-10-07
  -- Autor : Paola Vargas
  -- Cambio: Carga perfiles de usuario SP_DM_PERFIL_USU
Begin
  PQ_CARGA_TRANSAC.SP_DM_ATM;
  PQ_CARGA_TRANSAC.SP_DM_TIPODIN;
  PQ_CARGA_TRANSAC.SP_DM_DENODIN;
  PQ_CARGA_TRANSAC.SP_DM_MONEDA_ATM;
  PQ_CARGA_TRANSAC.SP_DM_EMPABA_ATM;
  PQ_CARGA_TRANSAC.SP_DM_RUTA_ATM;
  PQ_CARGA_TRANSAC.SP_JOBS_DM_TARJETA;
  
  PQ_CARGA_TRANSAC.SP_DM_OP_REGION;
  PQ_CARGA_TRANSAC.SP_DM_CANAL;
  PQ_CARGA_TRANSAC.SP_DM_DETCANAL;
  PQ_CARGA_TRANSAC.SP_ACT_DM_CLASETRX_GAS;
  
  PQ_CARGA_TRANSAC.SP_DM_PAIS_ESTDPT;
  PQ_CARGA_TRANSAC.SP_DM_COMERCIO_POS;
  
  PQ_CARGA_TRANSAC.SP_DM_PERFIL_USU;
  
End SP_CARGA_DIMENSIONES;
---------------------------------------------------------------------------------------------
Procedure SP_CARGA_HECHOS(PD_FECHA In Date)
Is
Begin
     PQ_CARGA_TRANSAC.sp_fact_op_billetaje(PD_FECHA);
     PQ_CARGA_TRANSAC.sp_job_fact_op_transaccion(PD_FECHA);
     PQ_CARGA_TRANSAC.sp_fact_op_trxcom(to_char(PD_FECHA,'rrrrmmdd'));
End SP_CARGA_HECHOS;
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
Procedure SP_DM_OP_REGION   
  Is
    Begin
    execute immediate 'truncate table err$_DM_OP_REGION';
        MERGE INTO DM_OP_REGION T
           USING (Select key_region,cod_region,des_region From dwstage.tmp_DM_OP_REGION) b
              ON (t.key_region = b.KEY_REGION)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.cod_region = b.cod_region,
                              t.des_region = b.des_region
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_region,t.cod_region,t.des_region)
                       VALUES (b.key_region,b.cod_region,b.des_region)
      LOG ERRORS INTO err$_DM_OP_REGION('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_OP_REGION;  
  
-------------------------------------------------------------------------------------------------
  
Procedure SP_DM_ATM   
  Is
    Begin
    execute immediate 'truncate table err$_DM_ATM';
        MERGE INTO DM_ATM T
           USING (Select key_atm,nro_atm,des_atm,tip_atm,ubi_atm,cod_atm,geografia_key
                    From dwstage.tmp_DM_ATM) b
              ON (t.key_ATM = b.key_ATM)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.nro_atm = b.nro_atm,
                              t.des_atm = b.des_atm,
                              t.ubi_atm = b.ubi_atm,
                              t.cod_atm = b.cod_atm,
                              t.geografia_key = b.geografia_key
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_atm,t.nro_atm,t.des_atm,t.tip_atm,t.ubi_atm,t.cod_atm,t.geografia_key)
                       VALUES (b.key_atm,b.nro_atm,b.des_atm,b.tip_atm,b.ubi_atm,b.cod_atm,b.geografia_key)
      LOG ERRORS INTO err$_DM_ATM('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_ATM; 
  
-----------------------------------------------------------------------------------------------------  

Procedure SP_DM_DENODIN  
  Is
    Begin
    execute immediate 'truncate table err$_DM_DENODIN';
        MERGE INTO DM_DENODIN T
           USING (Select key_denodin,val_denodin From dwstage.tmp_DM_denodin) b
              ON (t.key_denodin = b.key_denodin)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.val_denodin = b.val_denodin
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_denodin,t.val_denodin)
                       VALUES (b.key_denodin,b.val_denodin)
      LOG ERRORS INTO err$_DM_DENODIN('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_DENODIN; 

-----------------------------------------------------------------------------------------------

Procedure SP_DM_TIPODIN  
  Is
    Begin
    execute immediate 'truncate table err$_DM_TIPODIN';
        MERGE INTO DM_TIPODIN T
           USING (Select key_tipodin,cod_tipodin,des_tipodin From dwstage.tmp_DM_tipodin) b
              ON (t.key_tipodin = b.key_tipodin)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.cod_tipodin = b.cod_tipodin,
                              t.des_tipodin = b.des_tipodin
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_tipodin,t.cod_tipodin,t.des_tipodin)
                       VALUES (b.key_tipodin,b.cod_tipodin,b.des_tipodin)
      LOG ERRORS INTO err$_DM_TIPODIN('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_TIPODIN; 

-----------------------------------------------------------------------------------------------
Procedure sp_fact_op_billetaje (PD_FECHA In date)
  -- Carga billetaje de ATMs
  Is
  Begin
       -- Elimina registros si existen
       Begin 
          Delete from FACT_OP_BILLETAJE 
                where tiempo_key = (select tiempo_key
                from dm_tiempo WHERE fecha = PD_FECHA);
                --(select tiempo_key 
                --from dm_tiempo where fecha 
          Commit;
       Exception When Others Then
          Null;
       End;
       
       -- Inserta registros
       Insert into FACT_OP_BILLETAJE
               (tiempo_key,key_atm,geografia_key,key_region,
               ubigeo_key,moneda_key,key_tipodin,key_denodin,
               cantidad,val_denodin,key_mda_atm,key_empa_atm,
               key_ruta_atm,ingreso,cantidad_ant,
               key_detcanal,usuario_key, cnt_bildet,cnt_bindet,
               nro_caja,val_hora)
               
        Select t.tiempo_key, b.key_atm,g.geografia_key,
               b.key_region,null,m.moneda_key,b.key_tipodin,b.key_denodin,
               b.cantidad, b.val_denodin, b.key_mda_atm, b.key_empa_atm,
               b.key_ruta_atm,nvl(b.cantidad,0)-nvl(b.ingreso,0),nvl(b.ingreso,0),
               b.key_detcanal,u.usuario_key,b.cnt_bildet,b.cnt_bindet,
               b.nro_caja,b.val_hora
          From dwstage.tmp_fact_op_billetaje b 
          Join dm_tiempo t on t.fecha = b.fecha  
          Join dm_geografia g on g.codigo_agencia = b.cod_agencia and g.tipo_region = 'R'
          Join dm_moneda m on m.codigo_moneda = to_char(b.moneda)
          Join dm_usuario u on u.codigo_usuario = nvl(b.codigo_usuario,'0')                                                                                                                         
         Where  b.fecha = PD_FECHA;
       COMMIT;
          
       -- Estadisticas de tabla
        DBMS_STATS.gather_table_stats(ownname          => 'DWHOUSE',
 				    											    tabname          => 'FACT_OP_BILLETAJE',
						    									    degree           => 5,
								    							    granularity      => 'ALL',
										    					    estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
                                                                   
 Exception When Others Then
      Null;
 End sp_fact_op_billetaje;   
   
 -----------------------------------------------------------------------------------------------  
Procedure SP_DM_estilo_TARJETA   
  Is
    Begin
    execute immediate 'truncate table err$_DM_estilo_TARJETA';
        MERGE INTO DM_estilo_TARJETA T
           USING (Select x.key_est_tarj,x.cod_est_tarj,x.des_est_tarj From dwstage.tmp_DM_estilo_tarjeta x) b
              ON (t.key_est_tarj = b.key_est_tarj)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.cod_est_tarj = b.cod_est_tarj,
                              t.des_est_tarj = b.des_est_tarj
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_est_tarj,t.cod_est_tarj,t.des_est_tarj)
                       VALUES (b.key_est_tarj,b.cod_est_tarj,b.des_est_tarj)
      LOG ERRORS INTO err$_DM_estilo_tarjeta('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_estilo_TARJETA; 

-------------------------------------------------------------------------------------------------------------

Procedure SP_DM_VIGENCIA_TARJETA   
  Is
    Begin
    execute immediate 'truncate table err$_DM_VIGENCIA_TARJETA';
        MERGE INTO DM_VIGENCIA_TARJETA T
           USING (Select x.key_vig_tarj,x.cod_vig_tarj,x.des_vig_tarj From dwstage.tmp_DM_vigencia_tarjeta x) b
              ON (t.key_vig_tarj = b.key_vig_tarj)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.cod_vig_tarj = b.cod_vig_tarj,
                              t.des_vig_tarj = b.des_vig_tarj
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_vig_tarj,t.cod_vig_tarj,t.des_vig_tarj)
                       VALUES (b.key_vig_tarj,b.cod_vig_tarj,b.des_vig_tarj)
      LOG ERRORS INTO err$_DM_vigencia_tarjeta('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_vigencia_TARJETA;  
-------------------------------------------------------------------------------------------------------
Procedure SP_DM_PIN_TARJETA   
  Is
    Begin
    execute immediate 'truncate table err$_DM_PIN_TARJETA';
        MERGE INTO DM_PIN_TARJETA T
           USING (Select x.key_pin_tarj,x.cod_pin_tarj,x.des_pin_tarj From dwstage.tmp_DM_pin_tarjeta x) b
              ON (t.key_pin_tarj = b.key_pin_tarj)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.cod_pin_tarj = b.cod_pin_tarj,
                              t.des_pin_tarj = b.des_pin_tarj
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_pin_tarj,t.cod_pin_tarj,t.des_pin_tarj)
                       VALUES (b.key_pin_tarj,b.cod_pin_tarj,b.des_pin_tarj)
      LOG ERRORS INTO err$_DM_pin_tarjeta('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_pin_TARJETA; 

-----------------------------------------------------------------------------------------------
Procedure SP_DM_LIMITE_TARJETA   
  Is
    Begin
    execute immediate 'truncate table err$_DM_LIMITE_TARJETA';
        MERGE INTO DM_LIMITE_TARJETA T
           USING (Select x.key_lim_tarj,x.cod_lim_tarj,x.des_lim_tarj,x.imp_lim_tarj From dwstage.tmp_DM_limite_tarjeta x) b
              ON (t.key_lim_tarj = b.key_lim_tarj)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.cod_lim_tarj = b.cod_lim_tarj,
                              t.des_lim_tarj = b.des_lim_tarj,
                              t.imp_lim_tarj = b.imp_lim_tarj
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_lim_tarj,t.cod_lim_tarj,t.des_lim_tarj,t.imp_lim_tarj)
                       VALUES (b.key_lim_tarj,b.cod_lim_tarj,b.des_lim_tarj,b.imp_lim_tarj)
      LOG ERRORS INTO err$_DM_limite_tarjeta('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_limite_TARJETA; 

---------------------------------------------------------------------------------------------------
Procedure SP_DM_COM_TARJETA   
  Is
    Begin
    execute immediate 'truncate table err$_DM_COM_TARJETA';
        MERGE INTO DM_COM_TARJETA T
           USING (Select x.key_com_tarj,x.cod_com_tarj,x.des_com_tarj From dwstage.tmp_DM_COM_tarjeta x) b
              ON (t.key_com_tarj = B.KEY_COM_TARJ)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.cod_com_tarj = b.cod_com_tarj,
                              t.des_com_tarj = b.des_com_tarj
                              
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_com_tarj,t.cod_com_tarj,t.des_com_tarj)
                       VALUES (b.key_com_tarj,b.cod_com_tarj,b.des_com_tarj)
      LOG ERRORS INTO err$_DM_COM_tarjeta('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_COM_TARJETA; 

-------------------------------------------------------------------------------------------------------------
Procedure SP_DM_MEM_TARJETA   
  Is
    Begin
    execute immediate 'truncate table err$_DM_MEM_TARJETA';
        MERGE INTO DM_MEM_TARJETA T
           USING (Select x.key_mem_tarj,x.cod_mem_tarj,x.des_mem_tarj From dwstage.tmp_DM_MEM_tarjeta x) b
              ON (t.key_mem_tarj = b.key_mem_tarj)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.cod_mem_tarj = b.cod_mem_tarj,
                              t.des_mem_tarj = b.des_mem_tarj
                              
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_mem_tarj,t.cod_mem_tarj,t.des_mem_tarj)
                       VALUES (b.key_mem_tarj,b.cod_mem_tarj,b.des_mem_tarj)
      LOG ERRORS INTO err$_DM_MEM_tarjeta('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_MEM_TARJETA; 

--------------------------------------------------------------------------------------------------
Procedure SP_DM_TIPO_TARJETA   
  Is
    Begin
    execute immediate 'truncate table err$_DM_TIPO_TARJETA';
        MERGE INTO DM_TIPO_TARJETA T
           USING (Select x.key_tipo_tarj,x.cod_tipo_tarj,x.des_tipo_tarj,x.bin_tipo_tarj From dwstage.tmp_DM_tipo_tarjeta x) b
              ON (t.key_tipo_tarj = B.KEY_TIPO_TARJ)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.cod_tipo_tarj = b.cod_tipo_tarj,
                              t.des_tipo_tarj = b.des_tipo_tarj,
                              t.bin_tipo_tarj = b.bin_tipo_tarj
                              
                              
      WHEN NOT MATCHED THEN
                       INSERT (T.KEY_TIPO_TARJ,T.DES_TIPO_TARJ,T.COD_TIPO_TARJ,T.BIN_TIPO_TARJ)
                       VALUES (B.KEY_TIPO_TARJ,B.DES_TIPO_TARJ,B.COD_TIPO_TARJ,B.BIN_TIPO_TARJ)
      LOG ERRORS INTO err$_DM_Tipo_tarjeta('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_TIPO_TARJETA;

----------------------------------------------------------------------------------------------
Procedure SP_DM_MONEDA_ATM
  Is
    Begin
    execute immediate 'truncate table err$_DM_MONEDA_ATM';
        MERGE INTO DM_MONEDA_ATM T
           USING (Select key_mda_atm, cod_mda_atm,des_mda_atm From dwstage.tmp_dm_moneda_atm) b
              ON (t.key_mda_atm = b.key_mda_atm)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.cod_mda_atm = b.cod_mda_atm,
                              t.des_mda_atm = b.des_mda_atm
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_mda_atm,t.cod_mda_atm,t.des_mda_atm)
                       VALUES (b.key_mda_atm,b.cod_mda_atm,b.des_mda_atm)
      LOG ERRORS INTO err$_DM_MONEDA_ATM('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_MONEDA_ATM; 
-------------------------------------------------------------------------------------------------------
Procedure SP_DM_EMPABA_ATM
  Is
    Begin
    execute immediate 'truncate table err$_DM_EMPABA_ATM';
        MERGE INTO DM_EMPABA_ATM T
           USING (Select key_empa_atm, cod_empa_atm, des_empa_atm From dwstage.tmp_dm_empaba_atm) b
              ON (t.key_empa_atm = b.key_empa_atm)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.cod_empa_atm = b.cod_empa_atm,
                              t.des_empa_atm = b.des_empa_atm
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_empa_atm,t.cod_empa_atm,t.des_empa_atm)
                       VALUES (b.key_empa_atm,b.cod_empa_atm,b.des_empa_atm)
      LOG ERRORS INTO err$_DM_EMPABA_ATM('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_EMPABA_ATM; 
----------------------------------------------------------------------------------------------------------------------
Procedure SP_DM_RUTA_ATM
  Is
    Begin
    --execute immediate 'truncate table err$_DM_RUTA_ATM';
        MERGE INTO DM_RUTA_ATM T
           USING (Select x.key_ruta_atm, x.cod_ruta_atm, x.des_ruta_atm From dwstage.tmp_dm_ruta_atm x) b
              ON (t.key_ruta_atm = b.key_ruta_atm)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.cod_ruta_atm = b.cod_ruta_atm,
                              t.des_ruta_atm = b.des_ruta_atm
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_ruta_atm,t.cod_ruta_atm,t.des_ruta_atm)
                       VALUES (b.key_ruta_atm,b.cod_ruta_atm,b.des_ruta_atm);
      --LOG ERRORS INTO err$_DM_RUTA_ATM('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      --REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_RUTA_ATM; 
-----------------------------------------------------------------------------------------------------

Procedure SP_DM_TEC_TARJETA  
  Is
    Begin
    execute immediate 'truncate table err$_DM_TEC_TARJETA';
        MERGE INTO DM_TEC_TARJETA T
           USING (Select key_tec_tarj,cod_tec_tarj,des_tec_tarj From dwstage.tmp_DM_tec_tarjeta) b
              ON (t.key_tec_tarj = b.key_tec_tarj)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.cod_tec_tarj = b.cod_tec_tarj,
                              t.des_tec_tarj = b.des_tec_tarj
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_tec_tarj,t.des_tec_tarj,t.cod_tec_tarj)
                       VALUES (b.key_tec_tarj,b.des_tec_tarj,b.cod_tec_tarj)
      LOG ERRORS INTO err$_DM_tec_tarjeta('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_TEC_TARJETA; 
---------------------------------------------------------------------------------------------

Procedure SP_DM_EMPRESA_SERV  
  Is
    Begin
    execute immediate 'truncate table err$_DM_EMPRESA_SERV';
        MERGE INTO DM_EMPRESA_SERV T
           USING (Select key_empser,cod_empser,des_empser,abr_empser From dwstage.tmp_dm_empser) b
              ON (t.key_empser = b.key_empser)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.cod_empser = b.cod_empser,
                              t.des_empser = b.des_empser,
                              t.abr_empser = b.abr_empser
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_empser,t.cod_empser,t.des_empser,t.abr_empser)
                       VALUES (b.key_empser,b.cod_empser,b.des_empser,b.abr_empser)
      LOG ERRORS INTO err$_DM_Empresa_serv('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_EMPRESA_SERV;
-----------------------------------------------------------------------------------------------------------
Procedure SP_DM_SERVICIO_AFIL
  Is
    Begin
    execute immediate 'truncate table err$_DM_SERVICIO_AFIL';
        MERGE INTO DM_SERVICIO_AFIL T
           USING (Select key_servafil,cod_servafil,des_servafil From dwstage.tmp_dm_servafil) b
              ON (t.key_servafi = B.KEY_SERVAFIL)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.cod_servafi = b.cod_servafil,
                              t.des_servafi = B.DES_SERVAFIL
                              
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_servafi,t.cod_servafi,t.des_servafi)
                       VALUES (b.key_servafil,b.cod_servafil,b.des_servafil)
      LOG ERRORS INTO err$_DM_SERVICIO_AFIL('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_SERVICIO_AFIL;
-----------------------------------------
 Procedure SP_JOBS_DM_TARJETA--(PD_FECHA In Date)
 Is
   Cursor c_codsuc
       IS Select codigo_agencia codsuc
            From dwstage.tmp_dm_geografia_activo Where tipo_Region='R';
   ln_njobs number(5);  
   lv_query varchar2(1000);
   ln_job   number(10) := 0;
          
 Begin
     For x in c_codsuc Loop
         lv_query := ' begin '||'pq_carga_transac.SP_DM_TARJETA('''||x.codsuc||'''); End; ';
         ln_job := ln_job +1;
              
         dbms_scheduler.create_job(
                        job_name=> 'DM_TARJETA_'||LPAD(TO_CHAR(ln_job),5,'0'),
                        job_type=> 'PLSQL_BLOCK',
                        job_action=> lv_query,
                        start_date => sysdate+1/(24*180),
                        enabled => true, 
                        auto_drop=> TRUE,
                        comments => 'Carga DM_TARJETA'
                        );
         Commit;
         
         -- CONTROLA MAXIMO 300 JOBS
         Loop
               select count(*) into ln_njobs from user_scheduler_jobs;
         Exit When ln_njobs <= 200;
         End Loop;
     End Loop; 
     
     -- Revisa Jobs Finalizaron
     Loop
         Select count(*) Into ln_njobs From User_Scheduler_Jobs
           Where Job_Name Like 'DM_TARJETA_%';
     Exit When ln_njobs = 0;
     End Loop;      
           
     -- Estadisticas de tabla
     DBMS_STATS.gather_table_stats(ownname          => 'DWHOUSE',
		    											     tabname          => 'dm_tarjeta',
				    									     degree           => 5,
						    							     granularity      => 'ALL',
								    					     estimate_percent => dbms_stats.auto_sample_size,
                                   cascade          => TRUE);
 End SP_JOBS_DM_TARJETA;
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Procedure SP_DM_TARJETA (PV_CODSUC In Varchar2)
  -- Carga billetaje de ATMs
  Is
  Begin
       -- Elimina registros si existen
       /*Begin 
          Delete from DM_TARJETA 
                where key_tiempo = (select key_tiempo
                from dm_tiempo WHERE fecha = PD_FECHA);
          Commit;
       Exception When Others Then
          Null;
       End;
       */
       Merge Into DM_TARJETA C
       Using (Select b.key_tarj,b.nro_tarj,b.nom_tarj,b.fec_vto,b.fec_alta,
                     b.fec_mod,b.fec_aut,b.fec_baja,b.key_tipo_tarj,b.key_vig_tarj,
                     b.key_est_tarj,b.key_pin_tarj,b.key_lim_tarj,b.key_com_tarj,
                     b.key_mem_tarj,b.key_tec_tarj,c.cliente_key,g.geografia_key,t.tiempo_key,
                     m.usuario_key usu_mod_key,a.usuario_key usu_aut_key,
                     b.ind_premium,b.ind_habapp,b.app_fecafi,b.app_horafi,b.app_fecuin,
                     b.app_horuin,b.app_correo,b.app_nulcel
                from dwstage.tmp_dm_tarjeta b
                join dm_tiempo t on t.fecha = b.fec_alta 
                join dm_cliente c on c.codigo_cliente = b.cod_cliente
                join dm_geografia g on b.cod_sucursal = g.codigo_agencia and g.tipo_region='R'
                join dm_usuario m on m.codigo_usuario = b.cod_usumod 
                join dm_usuario a on a.codigo_usuario = b.cod_usuaut
               Where b.cod_sucursal = PV_CODSUC
             ) T  
          On (c.key_tarjeta=t.key_tarj)   
       When Matched Then
            Update Set c.nom_tarj    = t.nom_tarj,
                       c.key_usu_mod = t.usu_mod_key,
                       c.key_usu_aut = t.usu_aut_key,
                       c.fec_vto     = t.fec_vto,
                       c.fec_baja    = t.fec_baja,
                       c.key_cliente = t.cliente_key,
                       c.ind_premium = t.ind_premium,
                       c.ind_habapp  = t.ind_habapp, 
                       c.app_fecafi  = t.app_fecafi, 
                       c.app_horafi  = t.app_horafi,  
                       c.app_fecuin  = t.app_fecuin,  
                       c.app_horuin  = t.app_horuin,  
                       c.app_correo  = t.app_correo,  
                       c.app_nulcel  = t.app_nulcel  
       When Not Matched Then
            Insert (key_tarjeta,nro_tarj,nom_tarj,fec_vto,fec_alta,fec_mod,
                    fec_aut,fec_baja,key_tipo_tarj,key_vig_tarj,KEY_EST_TARJ,
                    KEY_PIN_TARJ,KEY_LIM_TARJ,KEY_COM_TARJ,KEY_MEM_TARJ,key_tec_tarj,
                    key_cliente,key_geografia,key_tiempo,key_usu_mod,key_usu_aut,
                    ind_premium,ind_habapp,app_fecafi,app_horafi,
                    app_fecuin,app_horuin,app_correo,app_nulcel
                   )
            Values (t.key_tarj,t.nro_tarj,t.nom_tarj,t.fec_vto,t.fec_alta,
                    t.fec_mod ,t.fec_aut ,t.fec_baja,t.key_tipo_tarj,t.key_vig_tarj,
                    t.key_est_tarj,t.key_pin_tarj,t.key_lim_tarj,t.key_com_tarj,
                    t.key_mem_tarj,t.key_tec_tarj,t.cliente_key,t.geografia_key,t.tiempo_key,
                    t.usu_mod_key,t.usu_aut_key,
                    t.ind_premium,t.ind_habapp,t.app_fecafi,t.app_horafi,
                    t.app_fecuin,t.app_horuin,t.app_correo,t.app_nulcel
                   );      
       COMMIT;
 Exception When Others Then
      Null;
 End sp_DM_TARJETA;   
   

----------------------------------------------------------------------------------------------------------
Procedure sp_FACT_OP_SERVAFIL (PD_FECHA In date)
  -- Carga Fact op Servafil
  Is
  Begin
       -- Elimina registros si existen
       Begin 
          Delete from fact_op_servafil 
                where tiempo_key = (select tiempo_key
                from dm_tiempo WHERE fecha = PD_FECHA);
                --(select tiempo_key 
                --from dm_tiempo where fecha 
          Commit;
       Exception When Others Then
          Null;
       End;
       
       -- Inserta registros
       Insert into fact_op_servafil
               (fec_afilia,key_empser,key_servafi,cliente_key,key_tarjeta,
                cuentas_key,nro_contrato,usu_afilia_key,tiempo_key,usu_desafil_key,
                fec_desafil,est_afilia)
               
               Select t.fec_afilia,t.key_empser,t.key_servafi,k.cliente_key,x.key_tarjeta,
               c.cuentas_key,t.nro_contrato,ua.usuario_key,d.tiempo_key,ud.usuario_key,
               t.fec_desafil,t.est_afilia
      
               
                from dwstage.tmp_fact_op_servafil T
                join dm_tiempo d on d.fecha = T.FEC_AFILIA
                join dm_cuentas c on T.CODIGO_CUENTA = C.CODIGO_CUENTA AND
                                     T.CUENTA_UNICA  = C.CUENTA_UNICA
                join dm_usuario ua on ua.codigo_usuario = nvl(t.usu_afilia,'NOREGIS')
                join dm_usuario ud on ud.codigo_usuario = nvl(t.usu_desafil,'NOREGIS')
                join dm_cliente k on t.cod_cliente = k.codigo_cliente
                join dm_tarjeta x on x.key_tarjeta = t.key_tarjeta;
                                                                                                                                          
                --Where  t.fec_afilia = PD_FECHA;
       COMMIT;
          
       -- Estadisticas de tabla
        DBMS_STATS.gather_table_stats(ownname          => 'DWHOUSE',
 				    											    tabname          => 'fact_op_servafil',
						    									    degree           => 5,
								    							    granularity      => 'ALL',
										    					    estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
                                                                   
 Exception When Others Then
      Null;
 End sp_FACT_OP_SERVAFIL;  

---------------------------------------------------------------------------------------------------------------
Procedure SP_DM_TIPOMOV 
  Is
    Begin
    execute immediate 'truncate table err$_DM_TIPOMOV';
        MERGE INTO DM_TIPOMOV T
           USING (Select key_tipomov, des_tipomov From dwstage.tmp_dm_tipomov) b
              ON (t.key_tipomov = b.key_tipomov)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.des_tipomov = b.des_tipomov
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_tipomov,t.des_tipomov)
                       VALUES (b.key_tipomov,b.des_tipomov)
      LOG ERRORS INTO err$_DM_tipomov('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_TIPOMOV;

-----------------------------------------------------------------------------------
Procedure SP_DM_INGEGR
  Is
    Begin
    execute immediate 'truncate table err$_DM_INGEGR';
        MERGE INTO DM_INGEGR T
           USING (Select key_ingegr, des_ingegr From dwstage.tmp_dm_INGEGR) b
              ON (t.key_ingegr = b.key_ingegr)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              t.des_ingegr = b.des_ingegr
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_ingegr,t.des_ingegr)
                       VALUES (b.key_ingegr,b.des_ingegr)
      LOG ERRORS INTO err$_DM_INGEGR('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_INGEGR;

-----------------------------------------------------------------------------------------------------------------------
Procedure SP_DM_CANAL
  Is
    Begin
        Execute immediate 'truncate table err$_DM_CANAL';
        MERGE INTO DM_CANAL T 
         USING DWSTAGE.TMP_DM_CANAL S
           ON (T.KEY_CANAL = S.KEY_CANAL)
        WHEN MATCHED THEN
         UPDATE SET /*T.DES_CANAL = S.DES_CANAL,
                    T.ABR_CANAL = S.ABR_CANAL,
                    T.COD_TIPCAN= S.COD_TIPCAN,
                    T.DES_TIPCAN= S.DES_TIPCAN*/
                    t.des_detcan = s.det_candet,
                    t.abr_canal  = s.abr_canal,
                    t.cod_tipcan = s.cod_tipcan,
                    t.des_tipcan = s.des_tipcan,
                    t.cod_canal  = s.cod_canal,
                    t.des_canal  = s.des_canal
                    
        WHEN NOT MATCHED THEN
         --INSERT (T.KEY_CANAL,T.DES_CANAL,T.ABR_CANAL,T.COD_TIPCAN,T.DES_TIPCAN)
         --VALUES (S.KEY_CANAL,S.DES_CANAL,S.ABR_CANAL,S.COD_TIPCAN,S.DES_TIPCAN);
           INSERT (t.key_canal,t.des_detcan,t.cod_canal,t.des_canal,t.cod_tipcan,t.des_tipcan)
           VALUES(s.key_canal,s.det_candet,s.cod_canal,s.des_canal,s.cod_tipcan,s.des_tipcan);
    
    COMMIT;
Exception When Others then
      Null;                      
                                               
End SP_DM_CANAL;
-------------------------------------------------------------------------------------
Procedure SP_DM_DETCANAL
  Is
    Begin
        Execute immediate 'truncate table err$_DM_DETCANAL';
        MERGE INTO DM_DETCANAL T
             USING (Select d.*,g.geografia_key 
                      From dwstage.tmp_dm_DETCANAL d
                      Join dwhouse.dm_geografia_act g 
                        on g.codigo_agencia = d.codigo_agencia
                       and g.tipo_region    = d.tipo_region 
                    ) b
                ON (t.key_detcanal = b.key_detcanal)
        WHEN MATCHED THEN                                         
                     UPDATE SET T.DES_DETCANAL = b.des_detcanal,
                                t.abr_detcanal = b.abr_detcanal,
                                T.COD_DETCANAL = B.COD_DETCANAL,
                                T.KEY_CANAL    = B.KEY_CANAL,
                                t.ubigeo_key   = b.ubigeo_key,
                                t.lng_dcanal   = b.lng_dcanal,
                                t.lat_dcanal   = b.lat_dcanal,
                                t.geografia_key= b.geografia_key,
                                t.cod_tippun   = b.cod_tippun,
                                t.des_tippun   = b.des_tippun
                                
                              
       WHEN NOT MATCHED THEN
                INSERT (t.key_detcanal,T.COD_DETCANAL,T.DES_DETCANAL,T.ABR_DETCANAL,
                        T.KEY_CANAL,t.ubigeo_key,t.lng_dcanal,t.lat_dcanal,t.geografia_key,
                        t.cod_tippun, t.des_tippun)
                VALUES (B.KEY_DETCANAL,B.COD_DETCANAL,B.DES_DETCANAL,B.ABR_DETCANAL,
                        B.KEY_CANAL,b.ubigeo_key,b.lng_dcanal,b.lat_dcanal,b.geografia_key,
                        b.cod_tippun, b.des_tippun)
      LOG ERRORS INTO Err$_Dm_Detcanal('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_DETCANAL;
-----------------------------------------------------------------------------------------------------
Procedure sp_job_fact_op_transaccion(PD_FECHA In date)
Is
     Cursor c_sucurs
         Is Select to_number(k.codigo_agencia) codsuc 
              From dwstage.tmp_dm_geografia_activo k where k.tipo_region='R';
     
     lv_nproc  Varchar2(1000);
     ln_job    Number(10) := 0;
     ln_mmxjob Number(10);    
     lv_Fecha  Varchar2(10) := to_char(PD_FECHA,'rrrrmmdd'); 
     ln_existe Number(3);
     ln_tiempo Number(10);    
Begin
     
     -- Revisa si existe fecha en dm_tiempo
     SElect count(*) Into ln_existe From dm_tiempo Where FEcha = PD_FECHA;
     IF ln_existe = 0 Then
        sp_cargar_dm_tiempo(PD_FECHA);
     END IF;
     ln_tiempo := PQ_CARGA_FACTS.fn_tiempo_key(PD_FECHA); 
     -- Elimina registros si existen
     Begin 
          Delete from FACT_OP_transaccion 
                where tiempo_key = ln_tiempo;
          Commit;
       Exception When Others Then
          Null;
     End;
     
     For x in c_sucurs Loop
          lv_nproc := 'Begin '||'pq_carga_transac.sp_fact_op_transaccion('||x.codsuc||',''' 
                      ||lv_Fecha||'''); End; ';
          ln_job := ln_job +1;
              
          dbms_scheduler.create_job(job_name=> 'FACT_OP_TRANSAC_'||LPAD(TO_CHAR(ln_job),5,'0'),
                                    job_type=> 'PLSQL_BLOCK',
                                    job_action=> lv_nproc,
                                    start_date => sysdate+1/(24*180),
                                    enabled => true, 
                                    auto_drop=> TRUE,
                                    comments => 'CARGA FACT_OP_TRANSACCIONES'
                                   );
          
          --- Aperturas
          lv_nproc := 'Begin '||'pq_carga_transac.sp_fact_op_apertura_aho('||x.codsuc||',''' 
                      ||lv_Fecha||'''); End; ';
          dbms_scheduler.create_job(job_name=> 'FACT_OP_APERAHO_'||LPAD(TO_CHAR(ln_job),5,'0'),
                                    job_type=> 'PLSQL_BLOCK',
                                    job_action=> lv_nproc,
                                    start_date => sysdate+1/(24*180),
                                    enabled => true, 
                                    auto_drop=> TRUE,
                                    comments => 'CARGA FACT_OPE_APERTURA_AHORROS'
                                   );
          
          Commit;
          -- CONTROLA MAXIMO 200 JOBS
          Loop
               select count(*) into ln_mmxjob from user_scheduler_jobs;
          Exit When ln_mmxjob <= 200;
          End Loop;
     End Loop;
     --- Controla que finalicen Jobs para analizar particion
     Loop
         select count(*) into ln_mmxjob from user_scheduler_jobs Where job_name like 'FACT_OP_TRANSAC_%';
     Exit When ln_mmxjob = 0;
     End Loop;
     
     -- Actualiza flag de carga
     Update dm_tiempo Set IND_FECTRX=1 Where fecha = PD_FECHA;
     Commit;
     
     -- Cargas comisiones
     pq_carga_transac.sp_fact_op_trxcom(lv_Fecha);
     
     /*
     -- Estadisticas de tabla
     DBMS_STATS.gather_table_stats(ownname          => 'DWHOUSE',
          										     tabname          => 'FACT_OP_transaccion',
        									         degree           => 5,
    		    							         granularity      => 'ALL',
    				    					         estimate_percent => dbms_stats.auto_sample_size,
                                   cascade          => TRUE); */
End sp_job_fact_op_transaccion;
-----------------------------------------------------------------------------------------------------
Procedure sp_fact_op_transaccion (PN_CODSUC In Number,
                                  PV_FECHA  In Varchar2)
  -- Carga Transacciones
Is
  ld_Fecha date := to_Date(PV_FECHA,'rrrrmmdd');
Begin
       
       
       -- Inserta registros
       Insert into FACT_OP_TRANSACCION
               (importe_mo,importe_mn, tipo_cambio, key_detcanal,
               key_tipomov, key_ingegr, key_motext, key_motcan,num_reltrx,
               tiempo_key,transacc_key,moneda_key,key_usuario,
               key_geografia,key_geografia_trx,cliente_key,cnt_transacc
               ,key_atm,ind_estado, V_HORA, N_HORA, key_tarj,
               cod_rango,key_op_region,periodo,val_pagcom,
               cuentas_key,credito_key,key_prodpas_reg,geopas_key,
               key_prodact_reg,num_diapag,fecha,n_taspas,n_impcap,
               cnt_lisneg,key_pais,key_compos,key_perfil,
               -- D: datos de desembolso
               importe2,importe3,importe4,importe5,num_credito,
               agenciabn_key,ind_tipgar,key_geoafiliat,
               key_geo_opeact 
               -- D:
               )
               
        Select t.val_importe, t.val_importe_mn, t.tipo_cambio,t.key_detcanal,
               t.key_tipomov,t.key_ingegr,nvl(t.key_motext,0),nvl(t.key_motcan,0),t.hnrel,
               d.tiempo_key, x.transacc_key, m.moneda_key, u.usuario_key,
               b.geografia_key, g.geografia_key, c.cliente_key,t.cnt_transac,
               t.key_atm,t.ind_estado, T.HORA,
               TO_NUMBER(SUBSTR(T.HORA,1,2)||SUBSTR(T.HORA,4,2)||SUBSTR(T.HORA,7,2)),
               w.key_tarjeta,h.cod_rango,r.key_region, d.periodo,
               nvl(t.imp_porcom,0),ct.cuentas_key,nvl(cr.credito_key,0),pp.producto_key,
               gp.geografia_key,pa.producto_reg_key,t.diaatr_pag,d.fecha,
               t.n_taspas,t.n_impcap,0,t.key_pais,t.key_cpos,t.key_perfil,
               NVL(importe2,0),NVL(importe3,0),NVL(importe4,0),NVL(importe5,0),
               num_credito,NVL(agenciabn_key,1),nvl(ind_tipgar,0),t.key_geoafiliat,
               Gac.Geografia_Key
          from dwstage.tmp_fact_op_transaccion T 
                join dm_tiempo D on t.fecha = D.FECHA 
                join dm_transaccion X on T.HCMOD=X.MODULO AND T.HTRAN=X.TRANSACCION 
                join dm_moneda M on T.CODIGO_MONEDA = M.CODIGO_MONEDA
                left join dm_usuario U on TRIM(T.COD_USUARIO) = NVL(U.CODIGO_USUARIO,'0')
                left join dm_geografia B on NVL(T.COD_AGENCIA,0)=TO_NUMBER(NVL(B.CODIGO_AGENCIA,'0')) AND B.TIPO_REGION='R'
                left join dm_geografia G on T.HSUCOR=TO_NUMBER(NVL(G.CODIGO_AGENCIA,'0')) AND G.TIPO_REGION='R'
                left join dm_cliente C on T.CODIGO_CLIENTE = C.CODIGO_CLIENTE
                left join dm_tarjeta w on w.key_tarjeta = t.key_tarj
                left join dm_op_rnghora h on h.cod_rango = t.cod_ranhor
                join dm_op_region r on r.cod_region = t.cod_regope
                left join dm_cuentas ct on ct.codigo_cuenta = nvl(t.codigo_cuenta,'0') and ct.cuenta_unica = nvl(t.cuenta_unica,'0')
                left join dm_credito cr on cr.credito_unico = nvl(t.credito_unico,'0') and cr.codigo_credito = nvl(t.credito_unico,'0')
                left join dm_producto pp on pp.codigo_producto = decode(nvl(t.codpro_pas,'0'),'426','22',nvl(t.codpro_pas,'0')) and pp.codigo_subproducto=nvl(t.subpro_pas,'0')                                                                                                                  
                left join dm_geografia gp on gp.codigo_agencia = nvl(t.cod_succta,'0') and gp.tipo_region = 'R'
                left join dm_producto_reg pa on pa.producto_reg_pcod=nvl(t.codpro_act,0) and pa.producto_reg_scod=nvl(t.subpro_act,0)
                left join dm_geografia Gac on t.codsuc_act=NVL(Gac.CODIGO_AGENCIA,'0') AND Gac.TIPO_REGION='R'
                Where t.fecha = ld_Fecha
                  and t.hsucor= PN_CODSUC
          LOG ERRORS INTO Err$_FACT_OP_TRANSACCION ('INSERT-'||to_char(ld_Fecha,'yyyymmdd')) REJECT LIMIT UNLIMITED;                                 
                        
                  
       COMMIT;
 Exception When Others Then
      Null;
 End sp_fact_op_transaccion;   
-----------------------------------------------------------------------------------------------------------

Procedure SP_DM_MOTCANCELA
  Is
    Begin
    execute immediate 'truncate table err$_DM_MOTCANCELA';
        MERGE INTO DM_MOTCANCELA T
           USING (Select KEY_MOTCAN, DES_MOTCAN From dwstage.tmp_dm_MOTCANCELA) b
              ON (T.KEY_MOTCAN = B.KEY_MOTCAN)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              T.DES_MOTCAN = B.DES_MOTCAN
                              
      WHEN NOT MATCHED THEN
                       INSERT (T.KEY_MOTCAN,T.DES_MOTCAN)
                       VALUES (B.KEY_MOTCAN,B.DES_MOTCAN)
      LOG ERRORS INTO Err$_Dm_MOTCANCELA('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_MOTCANCELA;
-----------------------------------------------------------------------------------------------------
Procedure SP_DM_MOTEXTORNO
  Is
    Begin
    execute immediate 'truncate table err$_DM_MOTEXTORNO';
        MERGE INTO DM_MOTEXTORNO T
           USING (Select KEY_MOTEXT, DES_MOTEXT From dwstage.tmp_dm_MOTEXTORNO) b
              ON (T.KEY_MOTEXT = B.KEY_MOTEXT)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              T.DES_MOTEXT = B.DES_MOTEXT
                              
      WHEN NOT MATCHED THEN
                       INSERT (T.KEY_MOTEXT,T.DES_MOTEXT)
                       VALUES (B.KEY_MOTEXT,B.DES_MOTEXT)
      LOG ERRORS INTO Err$_Dm_MOTEXTORNO('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_MOTEXTORNO;
-----------------------------------------------------------------------------------------
Procedure SP_DM_SEGMENTO_CTA
  Is
    Begin
    execute immediate 'truncate table err$_DM_SEGMENTO_CTA';
        MERGE INTO DM_SEGMENTO_CTA T
           USING (Select KEY_SEG_CTA, DES_SEG_CTA, ABR_SEG_CTA From dwstage.tmp_dm_SEGMENTO_CTA ) b
              ON (t.key_seg_cta = B.KEY_SEG_CTA)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET 
                              T.DES_SEG_CTA = b.des_seg_cta,
                              T.abr_seg_cta = b.abr_seg_cta
                              
      WHEN NOT MATCHED THEN
                       INSERT (T.KEY_SEG_CTA,T.DES_SEG_CTA,T.ABR_SEG_CTA)
                       VALUES (B.KEY_SEG_CTA,B.DES_SEG_CTA,B.ABR_SEG_CTA)
      LOG ERRORS INTO Err$_Dm_SEGMENTO_CTA('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
End SP_DM_SEGMENTO_CTA;
--------------------------------------------------------------------------------------------
Procedure SP_ACT_DM_CLASETRX_GAS
  Is
    Begin
    
        MERGE INTO DM_TRANSACCION T
           USING (Select MODULO,CODTRA,COD_SUBCLA,DES_SUBCLA,
                         COD_CLASE,DES_CLASE,COD_GRUPO,DES_GRUPO
                    From dwstage.Tmp_Dm_Transaccion) b
              ON (T.MODULO=B.MODULO AND
                  T.TRANSACCION = B.CODTRA)
      WHEN MATCHED THEN                                         
           UPDATE SET T.COD_SUBCLA = NVL(B.COD_SUBCLA,0),
                      T.DES_SUBCLA = NVL(B.DES_SUBCLA,'N/D'),
                      T.COD_CLASE = NVL(B.COD_CLASE,0),
                      T.DES_CLASE = NVL(B.DES_CLASE,'N/D'),
                      T.COD_GRUPO = NVL(B.COD_GRUPO,0),
                      T.DES_GRUPO = NVL(B.DES_GRUPO,'N/D');
      COMMIT;
Exception When Others then
      Null;                      
End SP_ACT_DM_CLASETRX_GAS;
--------------------------------------------------------------------------------------------
Procedure sp_fact_op_trxcom (PV_FECHA  In Varchar2)
  -- Carga Transacciones
Is
  ld_Fecha date := to_Date(PV_FECHA,'rrrrmmdd');
  --ln_tipcam number(7,3);
  --ld_fecini date;
Begin
       
       -- Elimina registros si existen
     Begin 
          Delete from fact_op_trxcom 
                where tiempo_key = (select tiempo_key
                from dm_tiempo WHERE fecha = ld_Fecha);
                --and n_codcom like '52_208%';
          Commit;
       Exception When Others Then
          Null;
     End;
     
       
       -- Inserta registros
       Insert into fact_op_trxcom
               (importe_mo,importe_mn, tipo_cambio, key_detcanal,
               key_tipomov, key_ingegr, key_motext, key_motcan,num_reltrx,
               tiempo_key,transacc_key,moneda_key,key_usuario,
               key_geografia,key_geografia_trx,cliente_key,cnt_transacc
               ,key_atm,ind_estado, V_HORA, N_HORA, key_tarj,
               cod_rango,key_op_region,periodo,val_pagcom,rubro_key,
               cuentas_key,credito_key,n_codcom,num_ordinal,num_subord
               )
               
        Select t.val_importe, t.val_importe_mn, t.tipo_cambio,t.key_detcanal,
               t.key_tipomov,t.key_ingegr,t.key_motext,t.key_motcan,t.hnrel,
               d.tiempo_key, x.transacc_key, m.moneda_key, u.usuario_key,
               b.geografia_key, g.geografia_key, c.cliente_key,t.cnt_transac,
               t.key_atm,t.ind_estado, T.HORA,
               TO_NUMBER(SUBSTR(T.HORA,1,2)||SUBSTR(T.HORA,4,2)||SUBSTR(T.HORA,7,2)),
               w.key_tarjeta,h.cod_rango,r.key_region, d.periodo,
               nvl(t.imp_porcom,0),rb.rubro_key,ct.cuentas_key,cr.credito_key,
               nvl(t.cod_rubro,0),t.hcord,t.hcsubo
          from dwstage.tmp_fact_op_trxcom T 
                join dm_tiempo D on t.fecha = D.FECHA 
                join dm_transaccion X on T.HCMOD=X.MODULO AND T.HTRAN=X.TRANSACCION 
                join dm_moneda M on T.CODIGO_MONEDA = M.CODIGO_MONEDA
                join dm_usuario U on TRIM(T.COD_USUARIO) = U.CODIGO_USUARIO
                left join dm_geografia B on T.COD_AGENCIA=TO_NUMBER(B.CODIGO_AGENCIA) AND B.TIPO_REGION='R'
                left join dm_geografia G on T.HSUCOR=TO_NUMBER(G.CODIGO_AGENCIA) AND G.TIPO_REGION='R'
                left join dm_cliente C on T.CODIGO_CLIENTE = C.CODIGO_CLIENTE
                left join dm_tarjeta w on w.key_tarjeta = t.key_tarj
                left join dm_op_rnghora h on h.cod_rango = t.cod_ranhor
                join dm_op_region r on r.cod_region = t.cod_regope
                 left join dm_rubro rb on rb.codigo_rubro = to_char(t.cod_rubro) 
                left join dm_cuentas ct on ct.codigo_cuenta = t.codigo_cuenta and ct.cuenta_unica = t.cuenta_unica
                left join dm_credito cr
                  on cr.credito_unico = t.credito_unico and cr.codigo_credito=t.codigo_credito                                                                                                              
                Where t.fecha = ld_Fecha;             
                  
       COMMIT;
       
       -- Si es fin de mes:actualiza tipo de cambio
       /*IF ld_fecha = last_day(ld_fecha) Then
          ln_tipcam := dwstage.pq_tmp_carga_facts.fn_tipo_cambio_fijo(ld_fecha);
          ld_fecini := to_date(to_char(ld_fecha,'rrrrmm')||'01','rrrrmmdd');
          Update fact_op_trxcom d
             set d.tipo_cambio = ln_tipcam
           Where d.tiempo_key in (select tiempo_key
                                   from dm_tiempo Where 
                                   fecha between ld_fecini and ld_fecha);
           Commit;                         
       End If;*/
       
 Exception When Others Then
      Null;
 End sp_fact_op_trxcom;   
-----------------------------------------------------------------------------------------------------------
 Procedure SP_JOB_TRX_ONLINE
  -----------------------------------------------------------------------------------
  -- Author  : PVARGAS
  -- Created : 35/03/2020 
  -- Purpose : JOb para ETL de transaccion y saldos CTS en línea
  --           desde DS COVID 19 
  ----------------------------------------------------------------------------------- 
 Is
    lv_codusu Varchar2(20);
    ld_Fecha  Date := trunc(sysdate);
    ln_job    Number(5);
    lc_msgerr Varchar2(200);
    ln_nrotab Number(5);
    lv_nompro Varchar2(100);
 Begin
      -- EJEUCTA CUANDO NO HAYA JOBS DE ETL EN EJECUCION
      Loop
         select count(*) Into ln_job 
           from dwhouse.proceso_cargaincremental 
          where estado_proceso = 'P';
         If ln_job = 0 Then 
            select count(*) Into ln_job
              from dba_scheduler_jobs where owner in ('DWEXTRA','DWSTAGE','DWHOUSE')
               and schedule_type = 'ONCE' and enabled = 'TRUE';
         End If;   
      Exit When ln_job = 0;
      End Loop;      
      
      -- INICIA PROCESO
      Begin
         Select Usuario,codigo_fuente Into lv_codusu, ln_nrotab 
           From dwextra.extfuentes where nombre_fuente ='FSH015_16';
         
         -- Extracción de transacciones     
         dwextra.pq_tmp_extrae_online.sp_job_insert_fsh016(lv_codusu);
         Loop
            Select count(*) Into ln_job FRom dba_scheduler_jobs
             Where owner = 'DWEXTRA' and job_name like 'TAB_FSH015_16%';
         Exit When ln_job = 0 ;
         End Loop;
         -- Extracción saldos de CTS
         dwextra.pq_tmp_extrae_online.sp_saldos_cts;
         
         -- Transformación, al finalizar los jobs de extracción
         lv_nompro := 'pq_tmp_carga_transacc.sp_op_transacciones';
         dwstage.pq_tmp_carga_transacc.SP_JOB_OP_TRANSACCIONES(ld_fecha);
         --dwstage.pq_tmp_carga_transacc.sp_op_transacciones(1,1,to_char(ld_fecha,'rrrrmmdd'));
         Loop
             select count(*) Into ln_job
               from dba_scheduler_jobs where owner = 'DWSTAGE'
                and job_name like 'FACT_OP_TRANSACC_%';
          Exit When ln_job = 0;
          End Loop;      
      
         -- Carga
         lv_nompro := 'pq_carga_transac.sp_job_fact_op_transaccion';
         dwhouse.pq_carga_transac.sp_job_fact_op_transaccion(ld_Fecha); 
      Exception When Others Then
           lc_msgerr:= substr(sqlerrm,1,200);  
           Insert into DWEXTRA.LOG_ERREXTFUENTE (N_NROPRO,C_NOMFUE,C_INSTRU,C_DESERR,D_FECERR)
           Values (ln_nrotab,'FSH015_16','INSERT ONLINE',lc_msgerr, SYSDATE); 
           COMMIT;   
      End;
      --Null;
 Exception When Others Then
      lc_msgerr:= substr(sqlerrm,1,200); 
      Insert Into lista_errores(fecp_err,tipo_err,desc_err,nreg_err,proc_error)
      Values(ld_Fecha,'TRX ONLINE-'||to_char(ld_Fecha,'rrrrmmdd'),lc_msgerr,0,substr(lv_nompro,1,50));
      Commit;
 End SP_JOB_TRX_ONLINE;
-----------------------------------------------------------------------------------------------------------
Procedure sp_fact_op_apertura_aho (PN_CODSUC In Number,PV_FECHA In Varchar2)
Is
  ld_Fecha date := to_Date(PV_FECHA,'rrrrmmdd');
Begin
     -- Inserta registros
     Insert into FACT_OP_TRANSACCION
                (importe_mo,importe_mn, tipo_cambio, key_detcanal,
                 key_tipomov, key_ingegr, key_motext, key_motcan,num_reltrx,
                 tiempo_key,transacc_key,moneda_key,key_usuario,
                 key_geografia,key_geografia_trx,cliente_key,cnt_transacc
                 ,key_atm,ind_estado, V_HORA, N_HORA, 
                 cod_rango,key_op_region,periodo,val_pagcom,
                 cuentas_key,credito_key,key_prodpas_reg,geopas_key,
                 key_prodact_reg,num_diapag,fecha,n_taspas,n_impcap,
                 cnt_lisneg
                )
         Select t.val_importe, t.val_importe_mn, t.tipo_cambio,t.key_detcanal,
                t.key_tipomov,t.key_ingegr,nvl(t.key_motext,0),nvl(t.key_motcan,0),t.hnrel,
                d.tiempo_key, x.transacc_key, m.moneda_key, u.usuario_key,
                b.geografia_key, g.geografia_key, c.cliente_key,t.cnt_transac,
                t.key_atm,t.ind_estado, T.HORA,
                TO_NUMBER(SUBSTR(T.HORA,1,2)||SUBSTR(T.HORA,4,2)||SUBSTR(T.HORA,7,2)),
                h.cod_rango,r.key_region, d.periodo,
                nvl(t.imp_porcom,0),ct.cuentas_key,nvl(cr.credito_key,0),pp.producto_key,
                gp.geografia_key,pa.producto_reg_key,t.diaatr_pag,d.fecha,
                t.n_taspas,t.n_impcap,0
          From dwstage.tmp_fact_op_ape_ahorro t 
          join dm_tiempo d on t.fecha = d.fecha
          join dm_transaccion x on t.hcmod=x.modulo and t.htran=x.transaccion 
          join dm_moneda m on m.codigo_moneda = t.codigo_moneda
          join dm_op_region r on r.cod_region = t.cod_regope
          left join dm_usuario u on trim(t.cod_usuario) = nvl(u.codigo_usuario,'0')
          left join dm_geografia b on to_number(nvl(b.codigo_agencia,'0'))=nvl(t.cod_agencia,0) 
                                  and b.tipo_region='R'
          left join dm_geografia g on to_number(nvl(g.codigo_agencia,'0'))=t.hsucor
                                  and g.tipo_region='R'
          left join dm_cliente c on c.codigo_cliente = t.codigo_cliente
          left join dm_op_rnghora h on t.cod_ranhor = h.cod_rango
          left join dm_cuentas ct on ct.codigo_cuenta = nvl(t.codigo_cuenta,'0') 
                                 and ct.cuenta_unica = nvl(t.cuenta_unica,'0')
          left join dm_credito cr on cr.credito_unico = nvl(t.credito_unico,'0') 
                                 and cr.codigo_credito = nvl(t.credito_unico,'0')
          left join dm_producto pp on pp.codigo_producto = decode(nvl(t.codpro_pas,'0'),'426','22',nvl(t.codpro_pas,'0')) and pp.codigo_subproducto=nvl(t.subpro_pas,'0')                                                                                                                  
          left join dm_geografia gp on gp.codigo_agencia = nvl(t.cod_succta,'0') 
                                   and gp.tipo_region = 'R'
          left join dm_producto_reg pa on pa.producto_reg_pcod=nvl(t.codpro_act,0) 
                                      and pa.producto_reg_scod=nvl(t.subpro_act,0)
         Where t.fecha = ld_Fecha
           and t.hsucor= PN_CODSUC
         LOG ERRORS INTO Err$_FACT_OP_TRANSACCION ('INSERT-'||to_char(ld_Fecha,'yyyymmdd')) REJECT LIMIT UNLIMITED;                                 
       COMMIT;
 Exception When Others Then
      Null;
 End sp_fact_op_apertura_aho;   
-----------------------------------------------------------------------------------------------------------
 Procedure SP_ELIMINA_TRX_DIA
 Is
    ld_fecha date := trunc(sysdate);
    ln_tiempo number(10);
 Begin
     ln_tiempo := PQ_CARGA_FACTS.fn_tiempo_key(ld_fecha);
     If ln_tiempo Is Not Null Then 
         -- Elimina registros si existen
         Begin 
              Delete from FACT_OP_transaccion 
                    where tiempo_key = ln_tiempo;
              Commit;
              
              Delete from Fact_Op_Trxcom 
                    where tiempo_key = ln_tiempo;
              Commit;
              
           Exception When Others Then
              Null;
         End;
     End If;
 End SP_ELIMINA_TRX_DIA;   
-----------------------------------------------------------------------------------------------------------
  PROCEDURE SP_DM_PAIS_ESTDPT
  IS
  BEGIN
       MERGE INTO DM_PAIS_ESTDPT T
           USING (Select *
                    From dwstage.TMP_DM_PAIS_ESTDPT) b
              ON (t.key_estdep = b.key_estdep and
                  t.cod_pais   = b.cod_pais)
      WHEN MATCHED THEN                                         
             UPDATE SET t.des_estdep = b.des_estdep,
                        t.cod_pais_iso2 = b.cod_pais_iso2,
                        t.cod_pais_iso3 = b.cod_pais_iso3,  
                        t.des_pais = b.des_pais,
                        t.fec_insact = b.fec_insact      
      WHEN NOT MATCHED THEN
           INSERT (t.key_estdep,t.des_estdep,t.cod_pais,t.cod_pais_iso2,
                   t.cod_pais_iso3,t.des_pais,t.fec_insact)
           VALUES (b.key_estdep,b.des_estdep,b.cod_pais,b.cod_pais_iso2,
                   b.cod_pais_iso3,b.des_pais,b.fec_insact);
      COMMIT;
  Exception When Others then
      Null;                     
  END SP_DM_PAIS_ESTDPT;
-----------------------------------------------------------------------------------------------------------
  PROCEDURE SP_DM_COMERCIO_POS
  IS
  BEGIN
       MERGE INTO DM_COMERCIO_POS T
           USING (Select *
                    From dwstage.TMP_DM_COMERCIO_POS) b
              ON (t.key_compos = b.key_compos)
      WHEN MATCHED THEN                                         
             UPDATE SET t.des_compos = b.des_compos,
                        t.key_estdep = b.key_estdep,  
                        t.fec_insact = b.fec_insact     
      WHEN NOT MATCHED THEN
           INSERT (t.key_compos,t.des_compos,t.key_estdep,t.fec_insact)
           VALUES (b.key_compos,b.des_compos,b.key_estdep,b.fec_insact);
      COMMIT;
  Exception When Others then
      Null;                     
  END SP_DM_COMERCIO_POS;
-----------------------------------------------------------------------------------------------------------
Procedure SP_FACT_OP_CLITRX(PD_FECHA In Date)
-- Inserta clientes clasificados según transacciones realizadas
Is 
    lv_period varchar2(6) := to_char(add_months(PD_FECHA,-1),'rrrrmm');
    ln_period number(6) := to_number(lv_period);
    ln_existe number(3);
BEGIN    
    select count(*) Into ln_existe 
      from dba_tab_partitions t where table_name = 'FACT_OP_CLITRX' 
        and t.partition_name = 'FACT_OPCLITRX_'||lv_period;
    
    If ln_existe > 0 Then 
       Execute Immediate 'ALTER TABLE FACT_OP_CLITRX TRUNCATE PARTITION FACT_OPCLITRX_'||lv_period||' UPDATE INDEXES';
    Else
       Execute Immediate 'alter table FACT_OP_CLITRX add partition FACT_OPCLITRX_'||lv_period||' values ('||ln_period||')';
    End If;      
    
    --delete from FACT_OP_CLITRX where ind_tippro=2 and periodo = lv_period;
    
    Insert into FACT_OP_CLITRX(tiempo_key, cliente_key, ind_trxapp, ind_compos, 
                          ind_comint, ind_nueapp, ind_oc1app, ind_oc2app, ind_rc1app, ind_rc2app, imp_sldaho, 
                          cnt_ctaaho, fec_utxapp, fec_ucmpos, fec_ucmint, ubigeo_key, cnt_trxapp, cnt_compos, 
                          cnt_comint, cod_cliente, periodo, key_clacli_trx, des_mail, des_celular, ind_tippro,
                          ind_apedig,IMP_COMPOS,IMP_COMINT,IND_COLBCO
                         ) 
    Select tiempo_key, cliente_key, ind_trxapp, ind_compos, 
            ind_comint, ind_nueapp, ind_oc1app, ind_oc2app, ind_rc1app, ind_rc2app, imp_sldaho, 
            cnt_ctaaho, fec_utxapp, fec_ucmpos, fec_ucmint, ubigeo_key, cnt_trxapp, cnt_compos, 
            cnt_comint, cod_cliente, periodo, key_clacli_trx, des_mail, des_celular, ind_tippro,d.ind_apedig,
            IMP_COMPOS,IMP_COMINT,IND_COLBCO
    From dwstage.tmp_fact_op_clitrx d
    Where d.periodo = ln_period;
    --and ind_tippro=2;
    Commit;
End SP_FACT_OP_CLITRX;
-----------------------------------------------------------------------------------------------------------
  PROCEDURE SP_DM_PERFIL_USU
  -- Fecha: 2022-10-07
  -- Autor: Paola Vargas
  -- Uso  : Carga dimension perfiles de usuario
  IS
  BEGIN 
        Merge Into dm_perfil_usu i
        Using (select * from dwstage.tmp_dm_perfil_usu) e
           on (i.key_perfil = e.key_perfil and i.cod_perfil = e.cod_perfil)
         When matched Then
              Update set i.des_perfil = trim(e.des_perfil),
                         i.fec_carga  = sysdate
         When not matched Then
              Insert(key_perfil,cod_perfil,des_perfil,fec_carga)
              Values(e.key_perfil,e.cod_perfil,e.des_perfil,sysdate);
        COMMIT;
  EXCEPTION WHEN OTHERS THEN
      NULL;
  END SP_DM_PERFIL_USU;      
  -----------------------------------------------------------------------------------------------------------
  PROCEDURE SP_FACT_P51_ERRORES(PD_FECHA in date)
  IS  
  BEGIN
      Begin
          Delete from FACT_P51_ERRORES Where fecha = PD_FECHA;
          Commit;
      Exception when others then
          Null;
      End;        
      
      Begin
        Insert into FACT_P51_ERRORES
               (tiempo_key, tarjeta_key, fecha, hora, fechor, secuencia, codres, codtra, secres, canal, 
                descan, msgerr, numtar) 
        Select t.tiempo_key,
               nvl(j.key_tarjeta,319),e.fecha,e.hora,e.fechor,e.secuencia,e.codres,e.codtra,e.secres,
               e.canal,e.descan,e.msgerr,e.numtar
          From dwstage.TMP_FACT_P51_ERRORES e
          Join dwhouse.dm_tiempo t on t.fecha = e.fecha
          Left Join dwhouse.dm_tarjeta j on trim(j.nro_tarj) = e.numtar
        Where e.fecha = PD_FECHA;
        Commit;  
      Exception when others then
          Null;
      End;   
  End SP_FACT_P51_ERRORES; 
-----------------------------------------------------------------------------------------------------------
End PQ_CARGA_TRANSAC;
/
