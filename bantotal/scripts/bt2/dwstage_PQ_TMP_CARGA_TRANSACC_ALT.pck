create or replace package dwstage.PQ_TMP_CARGA_TRANSACC is

  -- Author  : PVARGAS
  -- Created : 07/05/2018 01:41:24 p.m.
  -- Purpose : Procesos de transformación y limpieza para DM Transacciones
  
  -- Autor   : Paola Vargas
  -- Fecha   : 2022-10-06
  -- Cambio  : Agrega las funciones fn_perfil_usuario y fn_key_perfil_usu
  
  -- Autor   : Paola Vargas
  -- Fecha   : 2024.10.25
  -- Cambio  : Nuevo proceso SP_P51_ERRORES para el repore errores en P51 
     
  
  Function SEQ_NEXTVAL(PV_NOMSEQ In Varchar2) Return Number;   
  Procedure SP_TMP_DIMENSIONES(PD_FECHA In Date);
  Procedure SP_TMP_HECHOS(PD_FECHA In Date);
  Procedure SP_BORRA_LOG_ERROR; 
  Procedure SP_TMP_DM_TIPO_TARJETA;
  Procedure SP_TMP_DM_ATM;
  --procedure SP_TMP_FACT_OP_BILLETAJE;
  procedure sp_tmp_dm_op_region;
  procedure sp_TMP_DM_DENODIN (P_FECHA in date);
  procedure sp_TMP_DM_TIPODIN; 
  Function fn_key_atm (pn_codatm in number) Return Number;
  Function fn_key_region (pn_codreg in number)Return Number;
  Function fn_key_tipodin (pv_codtdi in VARCHAR2)Return Number;
  Function fn_key_denodin (pn_valden in number)Return Number;
  Function fn_KEY_MDA_ATM (pc_mdaatm in char)Return Number;
  Function fn_KEY_EMPA_ATM (pc_empatm in number)Return Number;
  Function fn_key_ruta_atm (pn_codrut in number)Return Number;
  Function fn_ingreso (pn_codatm in number, pd_fecha in date,pc_tipom in char, pn_denom in number,pn_comon in number)Return Number;
  Function fn_key_tipo_tarj (pc_codtarj in char)Return Number;
  Function fn_key_vig_tarj (pc_codvig in number)Return Number;
  Function fn_key_est_tarj (pc_codest in char)Return Number;
  Function fn_key_Pin_tarj (pv_codpin in varchar2)Return Number;
  Function fn_key_lim_tarj (pn_codlim in number)Return Number;
  Function fn_key_com_tarj (pn_codcom in number)Return Number;
  Function fn_key_mem_tarj (pn_codmem in number)Return Number;   
  Function fn_key_tec_tarj (pc_codtec in char)Return Number;   
  Function fn_key_empser (PN_EMPSER in number)Return Number;
  Function fn_key_servafi (PN_SERAFI in number)Return Number;
  Function fn_key_tarjeta (PC_NROTAR in char)Return number;
  Function fn_ctauni (Pc_ctauni in char)Return varchar2;
  Function fn_codcta (Pc_codcta in char)Return varchar2;
  Function fn_NROTARJ_DEBAUT (PN_SCCTA IN NUMBER,PN_SCMDA IN NUMBER,PN_SCSBO IN NUMBER,PN_SCTOP IN NUMBER,PN_SCMOD IN NUMBER)Return varchar2;
  Function fn_TARJCOOR (PN_PAIS in NUMBER,PN_TDOC IN NUMBER,PC_NDOC IN CHAR,PD_FINI IN DATE,PD_FFIN IN DATE)Return varchar2;
  Function fn_TARJCOOR (PN_PAIS in NUMBER,PN_TDOC IN NUMBER,PC_NDOC IN CHAR,PD_FEST IN DATE,PC_ESTA IN CHAR)Return varchar2;
  Function fn_CODCLIENTE (Pn_codcta in number)Return varchar2;
  Function fn_fechafil (Pn_mod in number,pn_mon in number,pn_cta in number,pn_ope in number,pn_sub in number,pn_top in number)Return date;
  Function fn_EfectivoATM (pn_codEATM in number,pd_fecha in date,pn_ingregres in number,pn_codmon in number)Return Number;
  Procedure SP_CUENTA_COBRANZA (PD_FECHA  in date,pc_tipcar in varchar2 );
  Procedure sp_CARGA_BILLETAJE (PD_FECHA  in date, pc_tipcar in varchar2);
  Procedure SP_AFIL_DESAFIL_GUARDADITO (PD_FECHA  in date,pc_tipcar in varchar2);
  Procedure SP_Afil_Desafil_Tarjeta (PD_FECHA  in date,pc_tipcar in varchar2) ;  
  Procedure SP_TMP_DM_ESTILO_TARJETA;
  Procedure SP_TMP_DM_VIGENCIA_TARJETA;
  Procedure SP_TMP_DM_PIN_TARJETA;
  Procedure SP_TMP_DM_LIMITE_TARJETA;
  Procedure SP_TMP_DM_COM_TARJETA;
  Procedure SP_TMP_DM_MEM_TARJETA; 
  Procedure SP_TMP_DM_MONEDA_ATM;
  Procedure SP_TMP_DM_EMPABA_ATM;
  Procedure SP_TMP_DM_RUTA_ATM;
  Procedure SP_TMP_DM_TEC_TARJETA;
  Procedure SP_TMP_DM_EMPSER;
  Procedure SP_TMP_DM_SERVAFIL;    
  --Procedure sp_carga_tarjeta (PD_FECHA  in date,pc_tipcar in varchar2);
  Procedure SP_CARGA_TARJETA (PN_TARINI In Number,PN_TARFIN In Number,PV_FECPRO In Varchar2);--PD_FECHA  in date, --Fecha de proceso--pc_tipcar in varchar2 --Tipo de carga T:Total / E:Errores);
  Procedure SP_TARJETA_APP(PV_NUMTAR In Varchar2, -- Nro. Tarjeta 
                           PV_HABAPP Out Varchar2,-- Indicador de habilitada en APP 
                           PD_FAFAPP Out Date,    -- Fecha Afiliacion en APP
                           PV_HORAPP Out Varchar2,-- Hora  afiliacion en APP
                           PD_FACAPP Out Date,    -- Fecha ultimo acceso a APP
                           PV_HACAPP Out Varchar2,-- Hora ultimo acceso a APP
                           PV_CORREO Out Varchar2,-- Coreeo en APP 
                           PV_NUMCEL Out Varchar2 -- Celular en APP
                          );
  Procedure sp_operaciones_internet (PD_FECHA  in date, pc_tipcar in varchar2);
  Procedure sp_tarjeta_coordenadas (PD_FECHA  in date,pc_tipcar in varchar2);
  Procedure sp_deb_automatico_serv (PD_FECHA  in date,pc_tipcar in varchar2);
  Procedure sp_compras_extranjero (PD_FECHA  in date,pc_tipcar in varchar2);
  Procedure SP_TMP_DM_TIPOMOV;                             
  Procedure SP_TMP_DM_INGEGR;  
  Procedure SP_TMP_DM_CANAL; 
  Procedure SP_TMP_DM_detcanal; 
  Procedure SP_TMP_DM_MOTCANCELA;    
  Function fn_key_detcanal(PV_CODDET In Varchar2,PN_CCANAL In Number) Return Number;
  Function fn_cod_agente(PD_FECHA In Date,PN_CMOD In Number,PN_CSUC In Number,PN_CTRA In Number,PN_CREL In Number) Return Varchar2;
  Procedure sp_FSD_DIARIO (pn_ctaini in number, pn_ctafin in number,Pc_FECHA  in varchar2); 
  procedure sp_job_fsd_diario(pc_fecha in varchar2);
  Procedure sp_FSD_HIST (pn_ctaini in number, pn_ctafin in number,Pc_FECHA  in varchar2);
  procedure sp_job_fsd_HIST(pv_fecha in varchar2,pv_tipo in Varchar2);  
  
  --Procedure sp_op_transacciones (pn_ctaini in number, pn_ctafin in number,Pc_FECHA  in varchar2);
  PROCEDURE SP_JOB_OP_TRANSACCIONES(PD_FECHA In date);
  Procedure sp_op_transacciones( PN_CMOD  in number,
                                 PN_CTRX  in number,
                                 PV_HORA  in varchar2,
                                 PC_FECHA in varchar2
                                );
                                
  Procedure SP_TMP_DM_SEGMENTO_CTA; 
  Function fn_key_Segmento_cta (pn_seccod in number,pn_codrub in number,pv_cod_nat in varchar2)Return Number;
  Function fn_tarjeta_trx(PN_MODTRX in Number,PN_CODTRX in Number,PN_RELTRX in Number,PD_FECHA IN DATE)Return Number;
  Procedure SP_JOB_TMP_DM_TARJETA(pc_fecpro varchar2); 
  procedure sp_carga_serv_afil (PD_FECHA  in date,pc_tipcar in varchar2);
  Function fn_interes_cts(PD_FECHA In Date,PN_CODCTA In Number,PN_CODRUB In Number,PN_CODMDA In Number,PN_CODOPE In Number,PN_CODSBO In Number)Return Number;


  Procedure sp_Ctas_Vigentes (PD_FECHA in Date);
  Procedure sp_CTAS_SLDOS_MES (PD_FECHA in Date);
  Procedure sp_fsd_clie (PD_FECHA in Date);
  Procedure sp_Prorrat_Sald (PD_FECHA in Date);
  Procedure sp_Datos_Anex (PD_FECHA in Date);
  Procedure sp_Anxs_Bantotal (PD_FECHA in Date);
  Procedure sp_Prorrat_Bantot (PD_FECHA in Date);

  Function fn_ubigeo_detcan (PN_KCANAL In Number, PV_CODCAN In Varchar2)
  Return Number;
  Procedure sp_ubicacion_detcan;
  Procedure sp_act_clatrx_gas;

  Function fn_rango_hora(PV_HORA In Varchar2) Return Number;
  Function fn_cod_region_op(PN_CODAGE In Number,PD_FECHA  In Date) Return Number;

  Function fn_key_motext(PN_GCOD In Number,
                         PN_CSUC In Number,
                         PN_CMOD In Number,
                         PN_TRAN In Number,
                         PN_NREL In Number,
                         PD_FECH In Date
                        )
  Return Number;  

  Function fn_rango_importe(PN_IMPMN In Number)
  Return Number;

   Function fn_porcom_agente(PN_CODMOD In Number,
                             PN_NUMTRX In Number,
                             PN_RNGIMP In Number)
   Return Number;
   
  Procedure SP_GEOGRAFIA_DETCANAL; 
  Procedure sp_act_tipopunto;
  Procedure sp_op_comisiones (pn_ctaini in number, pn_ctafin in number,
                             Pc_FECHA  in varchar2);
      
      Function fn_atm_trx(PN_MODTRX in Number,
                          PN_CODTRX in Number,
                          PN_RELTRX in Number,
                          PD_FECHA IN DATE)
      Return Varchar2;                           
  
    Function fn_cliente_compraventa(PN_GCOD In Number,
                                    PN_CMOD In Number,
                                    PN_CTRX In Number,
                                    PN_CSUC In Number,
                                    PN_NREL In Number,
                                    PD_FECH In Date
                                   )   
    Return Varchar2;
    
    Procedure SP_OP_APE_AHORROS(PD_FECHA In Date);
    
    Function fn_key_region_op(PN_CODAGE In Number,
                          PD_FECHA  In Date) Return Number;
                          
    FUNCTION fn_key_pais_estdep(PD_FECHA In Date,
                       PN_MODTR In Number,
                       PN_CODTR In Number,
                       PN_NUMRL In Number,
                       PN_SUCTR In Number
                      ) Return Number ;
                      
    FUNCTION fn_key_comercio_pos(PD_FECHA In Date,
                       PN_MODTR In Number,
                       PN_CODTR In Number,
                       PN_NUMRL In Number,
                       PN_SUCTR In Number
                      )
    RETURN Number;
    
    Procedure SP_CLASIF_CLITRX(PD_FECHA In Date);
    Procedure SP_CLITRX_BASE(PD_FECHA In Date);
    Procedure SP_CLASIF_CLITRX_APP(PD_FECHA In Date);
    Procedure SP_CLISINTRX_APP(PD_FECHA In Date);
    Procedure SP_DATOS_CLISINTRX_APP(PD_FECHA In date);
    Procedure SP_CLASIF_CLITRX_COMPRAS(PD_FECHA In Date);
    
    FUNCTION fn_perfil_usuario(PV_CODUSU varchar2) Return Varchar2;
    FUNCTION fn_key_perfil_usu(PV_CODPER varchar2) Return Number;
    
    PROCEDURE SP_OP_DATOS_DESEMBOLSO(PD_FECHA In Date);
    PROCEDURE SP_CAM_DEVOLUCION(PD_FECINI In Date);
                                                        
    PROCEDURE SP_P51_ERRORES(PD_FECHA In Date);
    
END PQ_TMP_CARGA_TRANSACC;
/
create or replace package body dwstage.PQ_TMP_CARGA_TRANSACC is
  -----------------------------------------------------------------------------------------------------
  Function SEQ_NEXTVAL (PV_NOMSEQ In Varchar2)
  Return Number
  Is
      ln_valor Number;
  Begin
      Execute Immediate 'Select '||PV_NOMSEQ||'.nextval from dual'
      Into ln_valor;
      
      Return  ln_valor;
  End SEQ_NEXTVAL;
  -----------------------------------------------------------------------------------------------------
Procedure SP_TMP_DIMENSIONES(PD_FECHA In Date)
  -- Autor: Paola Vargas
  -- Fecha: 2022-10-06
  -- Cambio: agrega ejecucion proceso PQ_CARGA_DIMENSIONES_II.SP_TMP_DM_PERFIL_USU;  
Is
Begin
     pq_tmp_carga_transacc.SP_TMP_DM_ATM;
     pq_tmp_carga_transacc.SP_TMP_DM_CANAL;
     PQ_TMP_CARGA_TRANSACC.SP_TMP_DM_detcanal;
     PQ_TMP_CARGA_TRANSACC.sp_ubicacion_detcan;
     PQ_TMP_CARGA_TRANSACC.sp_act_tipopunto;
     PQ_TMP_CARGA_TRANSACC.SP_GEOGRAFIA_DETCANAL;
     PQ_TMP_CARGA_TRANSACC.sp_tmp_dm_op_region;
     pq_tmp_carga_transacc.sp_TMP_DM_TIPODIN;
     pq_tmp_carga_transacc.sp_TMP_DM_DENODIN(PD_FECHA);
     pq_tmp_carga_transacc.SP_TMP_DM_MONEDA_ATM;
     pq_tmp_carga_transacc.SP_TMP_DM_EMPABA_ATM;
     pq_tmp_carga_transacc.SP_TMP_DM_RUTA_ATM;
     PQ_CARGA_DIMENSIONES_II.SP_TMP_DM_PAIS_ESTDPT(PD_FECHA);
     PQ_CARGA_DIMENSIONES_II.SP_TMP_DM_COMERCIO_POS(PD_FECHA);
     PQ_CARGA_DIMENSIONES_II.SP_TMP_DM_PERFIL_USU;
     pq_tmp_carga_transacc.SP_JOB_TMP_DM_TARJETA(to_char(PD_FECHA,'rrrrmmdd'));
End SP_TMP_DIMENSIONES;
-----------------------------------------------------------------------------------------------------
Procedure SP_TMP_HECHOS(PD_FECHA In Date)
Is
  lv_errm varchar2(200);
Begin
     begin
           -- Call the procedure
           dwextra.pq_tmp_extrae_fuentes.sp_tb_re_indice_fsh015_16(p_n_codtab => 64,
                                                  p_c_tbspidx => 'DWEXTRA_IDX',
                                                  p_c_usuario => 'DWEXTRA');
     end;
   
     pq_tmp_carga_transacc.sp_CARGA_BILLETAJE(PD_FECHA,'T');
     pq_tmp_carga_transacc.SP_JOB_OP_TRANSACCIONES(PD_FECHA);
     pq_tmp_carga_transacc.SP_OP_APE_AHORROS(PD_FECHA);
     pq_tmp_carga_transacc.SP_OP_DATOS_DESEMBOLSO(PD_FECHA);
     pq_tmp_carga_transacc.sp_op_comisiones(1,1,to_char(PD_FECHA,'rrrrmmdd'));
     pq_tmp_carga_transacc.sp_job_fsd_diario(to_char(PD_FECHA,'rrrrmmdd'));
Exception When Others Then
    lv_errm := substr(sqlerrm,1,200);     
    Insert into dwstage.tmp_errores(fecha,nompro,msgerr)
    values(PD_FECHA,'SP_TMP_HECHOS',lv_errm);
    Commit;
End SP_TMP_HECHOS;
----------------------------------------------------------------------------------------------------
Procedure SP_BORRA_LOG_ERROR 
Is
Begin               
    execute immediate('truncate table err$_tmp_dm_atm');
    execute immediate('truncate table err$_tmp_dm_tipodin');
    execute immediate('truncate table err$_tmp_dm_denodin');
    execute immediate('truncate table err$_tmp_dm_moneda_atm');
    execute immediate('truncate table err$_tmp_dm_empaba_atm');
    execute immediate('truncate table err$_tmp_dm_ruta_atm');
    execute immediate('truncate table err$_tmp_dm_tarjeta');
Exception When Others Then
    Null;
End SP_BORRA_LOG_ERROR;
----------------------------------------------------------------------------------------------------      
Procedure SP_TMP_DM_TIPO_TARJETA  
  Is
  Begin
        MERGE INTO TMP_DM_TIPO_TARJETA T
           USING (Select x.z0e469cod,trim(x.z0e469dsc) z0e469dsc,x.z0e469bin From dwextra.z0e469 x) b
              ON (t.cod_TIPO_TARJ = b.z0e469cod)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET t.des_TIPO_TARJ = UPPER(b.z0e469dsc),
                              t.bin_tipo_tarj = b.z0e469bin
      WHEN NOT MATCHED THEN
                       INSERT (t.cod_TIPO_TARJ,t.des_TIPO_TARJ,T.KEY_TIPO_TARJ,t.bin_tipo_tarj)
                       VALUES(b.z0e469cod,UPPER(b.z0e469dsc),SQ_DM_TIPO_TARJETA.NEXTVAL,b.z0e469bin)
      LOG ERRORS INTO Err$_Tmp_Dm_Tipo_Tarjeta('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                                                               
  End SP_TMP_DM_TIPO_TARJETA; 
  
-----------------------------------------------------------------------------------------------------
  
Procedure SP_TMP_DM_ATM   
  Is
  Begin
        MERGE INTO TMP_DM_ATM T
           USING (Select x.z0e475cod,x.z0e475dsc,x.z0e475ubi,x.z0e475suc,
                         decode(x.z0e475tip,'P','FIJO','NEUTRO') z0e475tip
                  From dwextra.z0e475 x) b
              ON (t.cod_ATM = b.z0e475cod)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET t.des_ATM = b.z0e475dsc,
                              t.nro_atm = 'ATM'||to_number(b.z0e475cod),
                              t.ubi_atm = upper(trim(b.z0e475ubi)),
                              t.tip_atm = b.z0e475tip,
                              t.geografia_key = DWHOUSE.PQ_CARGA_FACTS.fn_geografia_key(z0e475suc,'R')
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.cod_ATM,t.des_ATM,T.KEY_ATM,t.nro_atm,t.ubi_atm,t.tip_atm,t.geografia_key)
                       VALUES(b.z0e475cod,b.z0e475dsc,SQ_DM_ATM.NEXTVAL,'ATM'||to_number(b.z0e475cod),
                              upper(trim(b.z0e475ubi)),b.z0e475tip,DWHOUSE.PQ_CARGA_FACTS.fn_geografia_key(z0e475suc,'R'))
      LOG ERRORS INTO err$_TMP_DM_ATM('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                      
                                               
  End SP_TMP_DM_ATM;  
  
---------------------------------------------------------------------------------------------------------------  

/*procedure SP_TMP_FACT_OP_BILLETAJE  
  Is
    Begin
      execute immediate 'truncate table tmp_fact_op_billetaje';
         INSERT INTO tmp_fact_op_billetaje (cod_atm,fecha, cod_denomin, moneda, 
                                            sucursal, cantidad)
         
         SELECT v.jaql504cousu,v.jaql504fepro,v.jaql504denom,
                v.jaql504comon,v.jaql504sucur,v.jaql504canti
         FROM DWEXTRA.JAQL504 v
         
      LOG ERRORS INTO err$_TMP_FACT_OP_BILLETAJE('INSERT-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                                                               
  End SP_TMP_FACT_OP_BILLETAJE;*/
------------------------------------------------------------------------------------------------
  Procedure sp_tmp_dm_op_region
  -- Fecha : 2022-10-08
  -- Autor : Paola Vargas
  -- Cambio: Lee regiones de guia especial de proceso fst198 11110 
  --         en lugar de tabla dwextra.ex_op_region  
  is
  begin
       merge into tmp_dm_op_region t
       using (--select JAQLRGCOD,UPPER(JAQLRGDES)JAQLRGDES from dwextra.jaqlreg
              select cod_region,upper(nom_region) nom_region from dwextra.ex_op_region 
              /*Select tp1corr3 cod_region,
                     trim(replace(replace(upper(tp1desc),'REGION',''),'REGIÓN','')) nom_region
                From fst198@produ
               Where tp1cod1 = 11110 
                 and tp1corr1 = 5
                 and tp1corr2 = 3*/
              union all
              select 0,'No Identificada' from dual)b
       on (t.cod_region = b.cod_region)
       
       when matched then
            update
            set t.des_region = nom_region
            
       when not matched then
            insert (/*t.key_region,*/t.cod_region,t.des_region)
            values (/*SQ_DM_OP_REGION.NEXTVAL,*/b.cod_region,b.nom_region) 
            
            LOG ERRORS INTO err$_TMP_DM_op_region('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null; 
      
  End sp_tmp_dm_op_region;         
-------------------------------------------------------------------------------------------------------
/*      
procedure sp_TMP_DM_DENODIN (P_FECHA in date)
   is
      begin
         merge into tmp_dm_denodin t
         using (select distinct jaql504denom  from dwextra.jaql504 WHERE JAQL504FEPRO = p_FECHA)b
         on (t.val_denodin = b.JAQL504DENOM)
            
         when not matched then
            insert (t.key_denodin,t.val_denodin)
            values (SQ_DM_DENODIN.NEXTVAL,b.jaql504denom) 
            
            LOG ERRORS INTO err$_TMP_DM_DENODIN('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null; 
      
      End sp_tmp_dm_DENODIN;  */
Procedure sp_TMP_DM_DENODIN (P_FECHA in date)
  is
      begin
         merge into tmp_dm_denodin t
         using (select distinct jaql504denom  from dwextra.jaql504 WHERE JAQL504FEPRO = p_FECHA
                Union All
                Select distinct m5.mbcdval from dwextra.mbc005 m5 where m5.mbccfch = p_FECHA
               )b
         on (t.val_denodin = b.JAQL504DENOM)
         
         when not matched then
            insert (t.key_denodin,t.val_denodin)
            values (SQ_DM_DENODIN.NEXTVAL,b.jaql504denom) 
            
            LOG ERRORS INTO err$_TMP_DM_DENODIN('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null; 
  End sp_tmp_dm_DENODIN;      
-----------------------------------------------------------------------------------------------------------------------
   
procedure sp_TMP_DM_TIPODIN
    IS
      begin
         merge into tmp_dm_tipodin t
         using (SELECT 'B' CODIGO,'BILLETE' DESCRIP FROM DUAL
                UNION ALL SELECT 'M' CODIGO,'MONEDA' DESCRIP FROM DUAL)b
         on (t.cod_tipodin = b.CODIGO)
         
          when matched then
            update
            set T.DES_TIPODIN = B.DESCRIP
            
         when not matched then
            insert (T.KEY_TIPODIN,T.COD_TIPODIN,T.DES_TIPODIN)
            values (SQ_DM_TIPODIN.NEXTVAL,b.CODIGO,b.DESCRIP) 
            
            LOG ERRORS INTO err$_TMP_DM_TIPODIN('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null; 
      
      End sp_tmp_dm_TIPODIN;             
                
----------------------------------------------------------------------------------------------------    
Function fn_key_atm (pn_codatm in number)
Return Number
Is 
  ln_keyatm tmp_dm_atm.key_atm%type; 
Begin
    
    Begin
         Select b.key_atm
           Into ln_keyatm
           From tmp_dm_atm b
          Where b.cod_atm= pn_codatm;
    Exception When Others Then
          ln_keyatm := Null;
    End;
    
    Return ln_keyatm;
End fn_key_atm;   
----------------------------------------------------------------------------------------------------           
Function fn_key_region (pn_codreg in number)
Return Number
Is 
  ln_keyreg tmp_dm_op_region.key_region%type; 
Begin
    
    Begin
         Select b.key_region
           Into ln_keyreg
           From tmp_dm_op_region b
          Where b.cod_region = pn_codreg;
    Exception When Others Then
          ln_keyreg := Null;
    End;
    
    Return ln_keyreg;
End fn_key_region;
-----------------------------------------------------------------------------------------------------
Function fn_key_tipodin (pv_codtdi in varchar2)
Return Number
Is 
  ln_keytipodin tmp_dm_tipodin.cod_tipodin%type; 
Begin
    
    Begin
         Select b.key_tipodin
           Into ln_keytipodin
           From tmp_dm_tipodin b
          Where b.cod_tipodin = pv_codtdi;
    Exception When Others Then
          ln_keytipodin := Null;
    End;
    
    Return ln_keytipodin;
End fn_key_tipodin;

------------------------------------------------------------------------------------------
Function fn_key_denodin (pn_valden in number)
Return Number
Is 
  ln_keydenodin tmp_dm_denodin.key_denodin%type; 
Begin
    
    Begin
         Select b.key_denodin
           Into ln_keydenodin
           From tmp_dm_denodin b
          Where b.val_denodin = pn_valden;
    Exception When Others Then
          ln_keydenodin := Null;
    End;
    
    Return ln_keydenodin;
End fn_key_denodin;

----------------------------------------------------------------------------------------
 /*Procedure sp_CARGA_BILLETAJE (PD_FECHA  in date, --Fecha de proceso
                               pc_tipcar in varchar2 --Tipo de carga T:Total / E:Errores
                               )
  --------------------------------------------------------------------------------------
  -- Creación:
  ---------------------------------------------------------------------------------------
  -- Fecha  : 
  -- Autor  : 
  -- Cambios: Transformación de datos de billetaje de ATM's
  ---------------------------------------------------------------------------------------
  IS
     lv_query varchar2(200);

     TYPE tc_billetaje IS REF CURSOR;
     c_billetaje tc_billetaje;
  
     -- Declaración de tipos de variable (todos los campos de tabla tmp_dm_billetaje)
     Type tp_fecha is table of tmp_fact_op_billetaje.fecha%type;
     Type tp_codatm is table of tmp_fact_op_billetaje.cod_atm%type;
     Type tp_keyatm is table of tmp_fact_op_billetaje.key_atm%type;
     Type tp_codagencia is table of tmp_fact_op_billetaje.cod_agencia%type;
     Type tp_codregion is table of tmp_fact_op_billetaje.cod_region%type;
     Type tp_keyregion is table of tmp_fact_op_billetaje.key_region%type;
     Type tp_codubigeo is table of tmp_fact_op_billetaje.cod_ubigeo%type;
     Type tp_moneda is table of tmp_fact_op_billetaje.moneda%type;
     Type tp_codmoneda is table of tmp_fact_op_billetaje.cod_moneda%type;
     Type tp_codtipodin is table of tmp_fact_op_billetaje.cod_tipodin%type;
     Type tp_keytipodin is table of tmp_fact_op_billetaje.key_tipodin%type;
     Type tp_valdenodin is table of tmp_fact_op_billetaje.val_denodin%type;
     Type tp_keydenodin is table of tmp_fact_op_billetaje.key_denodin%type;
     Type tp_coddenodin is table of tmp_fact_op_billetaje.cod_denomin%type;
     Type tp_cantidad is table of tmp_fact_op_billetaje.cantidad%type;
     TYpe tp_sucursal is table of tmp_fact_op_billetaje.sucursal%type;
     TYPE tp_keymdaatm is table of tmp_fact_op_billetaje.key_mda_atm%type;
     type tp_codmdaatm is table of tmp_fact_op_billetaje.cod_mda_atm%type;
     type tp_keyempaatm is table of tmp_fact_op_billetaje.key_empa_atm%type;
     type tp_codempaatm is table of tmp_fact_op_billetaje.cod_empa_atm%type;
     type tp_codrutatm is table of tmp_fact_op_billetaje.cod_ruta_atm%type;
     type tp_keyrutatm is table of tmp_fact_op_billetaje.key_ruta_atm%type;
     type tp_ingreso is table of tmp_fact_op_billetaje.ingreso%type;
     type tp_impingreso is table of tmp_fact_op_billetaje.imp_ingreso%type;
     type tp_impegreso is table of tmp_fact_op_billetaje.imp_egreso%type;
     
     -- Declaración de variables en base a tipos declarados 
     ld_fecha tp_fecha;
     ln_codatm tp_codatm;
     ln_keyatm tp_keyatm;
     lv_codagencia tp_codagencia;
     ln_codregion tp_codregion;
     ln_keyregion tp_keyregion;
     lv_codubigeo tp_codubigeo;
     ln_moneda tp_moneda;
     lv_codmoneda tp_codmoneda;
     lv_codtipodin tp_codtipodin;
     ln_keytipodin tp_keytipodin;
     ln_valdenodin tp_valdenodin;
     ln_keydenodin tp_keydenodin;
     ln_coddenodin tp_coddenodin;
     ln_cantidad tp_cantidad;
     ln_sucursal tp_sucursal;
     ln_keymdaatm tp_keymdaatm;
     ln_codmdaatm tp_codmdaatm;
     ln_keyempaatm tp_keyempaatm;
     ln_codempaatm tp_codempaatm;
     ln_codrutatm tp_codrutatm;
     ln_keyrutatm tp_keyrutatm;
     ln_ingreso tp_ingreso;
     ln_impingreso tp_impingreso;
     ln_impegreso tp_impegreso;
     
     -- Declaración de otras variables 
     lv_Fecha varchar2(8) := to_char(PD_FECHA,'RRRRMMDD');

  
  BEGIN
      -- Truncar table de billetaje y tabla de errores
      execute immediate 'truncate table tmp_fact_op_billetaje';
      execute immediate 'truncate table err$_TMP_FACT_OP_BILLETAJE';
      -- Cargar datos en cursor con sentencia select
      Open c_billetaje FOR
           -- Seleccionar tabla de billetaje con filtro de fecha (WHERE)
                
           Select N.JAQL504FEPRO,
                  N.JAQL504COUSU,
                  PQ_TMP_CARGA_TRANSACC.fn_key_atm(N.JAQL504COUSU),
                  N.JAQL504SUCUR,
                  R.JAQLRGREG,
                  PQ_TMP_CARGA_TRANSACC.fn_key_region(R.JAQLRGREG),
                  NULL,
                  N.JAQL504COMON,
                  N.JAQL504TIMON,
                  PQ_TMP_CARGA_TRANSACC.fn_key_tipodin(N.JAQL504TIMON),
                  N.JAQL504DENOM,
                  PQ_TMP_CARGA_TRANSACC.fn_key_denodin(N.JAQL504DENOM),
                  NULL,
                  N.JAQL504CANTI,
                  NULL,
                  b.jaqlabcod,
                  pq_tmp_carga_transacc.fn_KEY_EMPA_ATM(b.jaqlabcod),
                  b.jaqlmatmc,
                  pq_tmp_carga_transacc.fn_KEY_MDA_ATM(b.jaqlmatmc), b.jaqlrcod,
                  pq_tmp_carga_transacc.fn_key_ruta_atm(b.jaqlrcod),
                  pq_tmp_carga_transacc.fn_ingreso(n.jaql504cousu,n.jaql504fepro,
                                                   n.jaql504timon,n.jaql504denom,
                                                   n.jaql504comon),
                                                   
                    1,
                    2                               
                  --pq_tmp_carga_transacc.fn_EfectivoATM(JAQL504COUSU,JAQL504FEPRO,1,n.jaql504comon),
                  --pq_tmp_carga_transacc.fn_EfectivoATM(JAQL504COUSU,JAQL504FEPRO,2,n.jaql504comon)
                                                    
                                                   
                                                               
                  
              fROM DWEXTRA.JAQL504 N
              join DWEXTRA.JAQLRSU R
              ON R.JAQLRGSUC=N.JAQL504SUCUR
              left join dwextra.jaqltatm b
              on b.jaqlatmcd=n.jaql504cousu
              WHERE N.JAQL504FEPRO=PD_FECHA;
      
      -- Abrir cursor
      LOOP
           FETCH c_billetaje  BULK COLLECT INTO   
           -- Listar variables basadas en tip. En el mismo orden que se realizaron en la sentencia SELECT 
                  ld_fecha,
                  ln_codatm,
                  ln_keyatm,
                  lv_codagencia,
                  ln_codregion,
                  ln_keyregion,
                  lv_codubigeo,
                  ln_moneda,
                  --lv_codmoneda,
                  lv_codtipodin,
                  ln_keytipodin,
                  ln_valdenodin,
                  ln_keydenodin,
                  ln_coddenodin,
                  ln_cantidad,
                  ln_sucursal,
                  ln_codempaatm,
                  ln_keyempaatm, 
                  ln_codmdaatm, 
                  ln_keymdaatm,
                  ln_codrutatm,
                  ln_keyrutatm,
                  ln_ingreso,
                  ln_impingreso,
                  ln_impegreso
                 
    
    
      
     
           LIMIT 1000; 
           
           IF ld_Fecha.count > 0 THEN                         
              FORALL x IN ld_Fecha.FIRST .. ld_Fecha.LAST
                 INSERT INTO TMP_FACT_OP_BILLETAJE nologging 
                        (fecha,cod_atm,key_atm,cod_agencia,cod_region,key_region, 
                         cod_ubigeo,moneda,cod_tipodin,key_tipodin, 
                         val_denodin,key_denodin,cod_denomin,cantidad,sucursal,key_mda_atm,
                         cod_mda_atm,key_empa_atm,cod_empa_atm,key_ruta_atm,cod_ruta_atm,ingreso,
                         imp_ingreso,imp_egreso)
                         --campos de la tabla
                 VALUES (ld_Fecha(x),ln_codatm(x),ln_keyatm(x),lv_codagencia(x),
                         ln_codregion(x),ln_keyregion(x),lv_codubigeo(x),
                         ln_moneda(x),lv_codtipodin(x),ln_keytipodin(x),
                         ln_valdenodin(x),ln_keydenodin(x),ln_coddenodin(x),
                         ln_cantidad(x),ln_sucursal(x),ln_keymdaatm(x),ln_codmdaatm(x),ln_keyempaatm(x),
                         ln_codempaatm(x),ln_keyrutatm(x),ln_codrutatm(x),ln_ingreso(x),
                         ln_impingreso (x),
                         ln_impegreso(x)) 
                         --variables basada en tipo
              LOG ERRORS INTO Err$_Tmp_Fact_Op_Billetaje ('INSERT-'||lv_Fecha) REJECT LIMIT UNLIMITED;                                 
                commit;
           END IF;                        
           EXIT WHEN c_billetaje%notfound;
        END LOOP;    
        Commit;         
  End ;
*/
Procedure SP_CARGA_BILLETAJE (PD_FECHA  in date, --Fecha de proceso
                               pc_tipcar in varchar2 --Tipo de carga T:Total / E:Errores
                               )
  --------------------------------------------------------------------------------------
  -- Creación:
  ---------------------------------------------------------------------------------------
  -- Fecha  : 
  -- Autor  : 
  -- Cambios: Transformación de datos de billetaje de ATM's
  ---------------------------------------------------------------------------------------
  IS
     
     TYPE tc_billetaje IS REF CURSOR;
     c_billetaje tc_billetaje;
  
     -- Declaración de tipos de variable (todos los campos de tabla tmp_dm_billetaje)
     Type tp_fecha is table of tmp_fact_op_billetaje.fecha%type;
     Type tp_codatm is table of tmp_fact_op_billetaje.cod_atm%type;
     Type tp_keyatm is table of tmp_fact_op_billetaje.key_atm%type;
     Type tp_codagencia is table of tmp_fact_op_billetaje.cod_agencia%type;
     Type tp_codregion is table of tmp_fact_op_billetaje.cod_region%type;
     Type tp_keyregion is table of tmp_fact_op_billetaje.key_region%type;
     Type tp_codubigeo is table of tmp_fact_op_billetaje.cod_ubigeo%type;
     Type tp_moneda is table of tmp_fact_op_billetaje.moneda%type;
     --Type tp_codmoneda is table of tmp_fact_op_billetaje.cod_moneda%type;
     Type tp_codtipodin is table of tmp_fact_op_billetaje.cod_tipodin%type;
     Type tp_keytipodin is table of tmp_fact_op_billetaje.key_tipodin%type;
     Type tp_valdenodin is table of tmp_fact_op_billetaje.val_denodin%type;
     Type tp_keydenodin is table of tmp_fact_op_billetaje.key_denodin%type;
     Type tp_coddenodin is table of tmp_fact_op_billetaje.cod_denomin%type;
     Type tp_cantidad is table of tmp_fact_op_billetaje.cantidad%type;
     TYpe tp_sucursal is table of tmp_fact_op_billetaje.sucursal%type;
     TYPE tp_keymdaatm is table of tmp_fact_op_billetaje.key_mda_atm%type;
     type tp_codmdaatm is table of tmp_fact_op_billetaje.cod_mda_atm%type;
     type tp_keyempaatm is table of tmp_fact_op_billetaje.key_empa_atm%type;
     type tp_codempaatm is table of tmp_fact_op_billetaje.cod_empa_atm%type;
     type tp_codrutatm is table of tmp_fact_op_billetaje.cod_ruta_atm%type;
     type tp_keyrutatm is table of tmp_fact_op_billetaje.key_ruta_atm%type;
     type tp_ingreso is table of tmp_fact_op_billetaje.ingreso%type;
     type tp_impingreso is table of tmp_fact_op_billetaje.imp_ingreso%type;
     type tp_impegreso is table of tmp_fact_op_billetaje.imp_egreso%type;
     type tp_usuario   is table of tmp_fact_op_billetaje.codigo_usuario%type;
     type tp_keydetcan is table of tmp_fact_op_billetaje.key_detcanal%type;
     type tp_bildet    is table of tmp_fact_op_billetaje.cnt_bildet%type;
     type tp_bindet    is table of tmp_fact_op_billetaje.cnt_bindet%type;
     type tp_nrocaja   is table of tmp_fact_op_billetaje.nro_caja%type;
     type tp_hora      is table of tmp_fact_op_billetaje.val_hora%type;
     -- Declaración de variables en base a tipos declarados 
     ld_fecha tp_fecha;
     ln_codatm tp_codatm;
     ln_keyatm tp_keyatm;
     lv_codagencia tp_codagencia;
     ln_codregion tp_codregion;
     ln_keyregion tp_keyregion;
     lv_codubigeo tp_codubigeo;
     ln_moneda tp_moneda;
     lv_codtipodin tp_codtipodin;
     ln_keytipodin tp_keytipodin;
     ln_valdenodin tp_valdenodin;
     ln_keydenodin tp_keydenodin;
     ln_coddenodin tp_coddenodin;
     ln_cantidad tp_cantidad;
     ln_sucursal tp_sucursal;
     ln_keymdaatm tp_keymdaatm;
     ln_codmdaatm tp_codmdaatm;
     ln_keyempaatm tp_keyempaatm;
     ln_codempaatm tp_codempaatm;
     ln_codrutatm tp_codrutatm;
     ln_keyrutatm tp_keyrutatm;
     ln_ingreso tp_ingreso;
     ln_impingreso tp_impingreso;
     ln_impegreso tp_impegreso;
     
     lv_usuario tp_usuario  ;
     ln_detcan  tp_keydetcan;
     ln_bildet  tp_bildet   ;
     ln_bindet  tp_bindet   ;
     ln_nrocaja tp_nrocaja   ;
     lv_hora tp_hora;
     -- Declaración de otras variables 
     lv_Fecha varchar2(8) := to_char(PD_FECHA,'RRRRMMDD');
     lv_errm varchar2(200);
  
  BEGIN
      -- Truncar table de billetaje y tabla de errores
      execute immediate 'truncate table tmp_fact_op_billetaje';
      execute immediate 'truncate table err$_TMP_FACT_OP_BILLETAJE';
      -- Cargar datos en cursor con sentencia select
      Open c_billetaje FOR
           -- Seleccionar tabla de billetaje con filtro de fecha (WHERE)
                
           Select N.JAQL504FEPRO,
                  N.JAQL504COUSU,
                  PQ_TMP_CARGA_TRANSACC.fn_key_atm(N.JAQL504COUSU),
                  N.JAQL504SUCUR,
                  R.JAQLRGREG,
                  PQ_TMP_CARGA_TRANSACC.fn_key_region(R.JAQLRGREG),
                  NULL,
                  N.JAQL504COMON,
                  N.JAQL504TIMON,
                  PQ_TMP_CARGA_TRANSACC.fn_key_tipodin(N.JAQL504TIMON),
                  N.JAQL504DENOM,
                  PQ_TMP_CARGA_TRANSACC.fn_key_denodin(N.JAQL504DENOM),
                  NULL,
                  N.JAQL504CANTI,
                  NULL,
                  b.jaqlabcod,
                  pq_tmp_carga_transacc.fn_KEY_EMPA_ATM(b.jaqlabcod),
                  b.jaqlmatmc,
                  pq_tmp_carga_transacc.fn_KEY_MDA_ATM(b.jaqlmatmc), b.jaqlrcod,
                  pq_tmp_carga_transacc.fn_key_ruta_atm(b.jaqlrcod),
                  pq_tmp_carga_transacc.fn_ingreso(n.jaql504cousu,n.jaql504fepro,
                                                   n.jaql504timon,n.jaql504denom,
                                                   n.jaql504comon),
                                                   
                    1,
                    2,
                   pq_tmp_carga_transacc.fn_key_detcanal(N.JAQL504COUSU,2), 
                   'USRSWITCH',
                   0,
                   0,
                   0,
                   '23:00:00'                               
              FROM DWEXTRA.JAQL504 N
              join DWEXTRA.JAQLRSU R
                ON R.JAQLRGSUC=N.JAQL504SUCUR
              left join dwextra.jaqltatm b
                on b.jaqlatmcd=n.jaql504cousu
              WHERE N.JAQL504FEPRO=PD_FECHA
                    UNION ALL
                    --- AGENCIAS
              Select m5.mbccfch,
                     m5.mbccsuc cod_atm,
                     PQ_TMP_CARGA_TRANSACC.fn_key_atm(0),
                     m5.mbccsuc,
                     R.JAQLRGREG,
                     PQ_TMP_CARGA_TRANSACC.fn_key_region(R.JAQLRGREG),
                     Null,
                     m5.mbcdmda,
                     m5.mbcdtpo,
                     PQ_TMP_CARGA_TRANSACC.fn_key_tipodin(m5.mbcdtpo),
                     m5.mbcdval,
                     PQ_TMP_CARGA_TRANSACC.fn_key_denodin(m5.mbcdval),
                     Null,
                     nvl(m5.mbcdcant,0) + nvl(m5.mbcdcanti,0) cantidad,
                     Null,
                     10 cod_empa_atm,
                     pq_tmp_carga_transacc.fn_KEY_EMPA_ATM(10) key_empa_atm,
                     'N' cod_mda_atm,
                     pq_tmp_carga_transacc.fn_KEY_MDA_ATM('N') key_mda_atm,
                     0 cod_ruta_atm,
                     pq_tmp_carga_transacc.fn_key_ruta_atm(0) key_ruta_atm,
                     0    ingreso,
                     0    imp_ingreso,
                     0    imp_egreso,
                     pq_tmp_carga_transacc.fn_key_detcanal(m5.mbccsuc,1),
                     trim(m5.mbccusu),
                     m5.mbcdcant cnt_nodet, 
                     m5.mbcdcanti cnt_sidet,
                     m5.mbcccaj,
                     m5.mbcchra
                from dwextra.mbc005 m5 
                join (select mbccemp,mbccsuc,mbccusu,mbcccaj,mbccfch, max(mbcchra) mbcchra,nvl(trim(mbccest),'C') mbccest
                        from dwextra.mbc004 where nvl(trim(mbccest),'C') = 'C'    
                      group by mbccemp,mbccsuc,mbccusu,mbcccaj,mbccfch,mbccest) m4
                   on m4.mbccemp = m5.mbccemp 
                  and m4.mbccsuc = m5.mbccsuc
                  and m4.mbccusu = m5.mbccusu
                  and m4.mbcccaj = m5.mbcccaj
                  and m4.mbccfch = m5.mbccfch
                  and m4.mbcchra = m5.mbcchra
                join DWEXTRA.JAQLRSU R
                  ON R.JAQLRGSUC=m5.mbccsuc
              Where m5.mbccfch = PD_FECHA;
      
      -- Abrir cursor
      LOOP
           FETCH c_billetaje  BULK COLLECT INTO   
           -- Listar variables basadas en tip. En el mismo orden que se realizaron en la sentencia SELECT 
                  ld_fecha,
                  ln_codatm,
                  ln_keyatm,
                  lv_codagencia,
                  ln_codregion,
                  ln_keyregion,
                  lv_codubigeo,
                  ln_moneda,
                  --lv_codmoneda,
                  lv_codtipodin,
                  ln_keytipodin,
                  ln_valdenodin,
                  ln_keydenodin,
                  ln_coddenodin,
                  ln_cantidad,
                  ln_sucursal,
                  ln_codempaatm,
                  ln_keyempaatm, 
                  ln_codmdaatm, 
                  ln_keymdaatm,
                  ln_codrutatm,
                  ln_keyrutatm,
                  ln_ingreso,
                  ln_impingreso,
                  ln_impegreso,
                  ln_detcan,
                  lv_usuario, 
                  ln_bindet,
                  ln_bildet,
                  ln_nrocaja,
                  lv_hora
                 LIMIT 1000; 
           
           IF ld_Fecha.count > 0 THEN                         
              FORALL x IN ld_Fecha.FIRST .. ld_Fecha.LAST
                 INSERT INTO TMP_FACT_OP_BILLETAJE nologging 
                        (fecha,cod_atm,key_atm,cod_agencia,cod_region,key_region, 
                         cod_ubigeo,moneda,cod_tipodin,key_tipodin, 
                         val_denodin,key_denodin,cod_denomin,cantidad,sucursal,key_mda_atm,
                         cod_mda_atm,key_empa_atm,cod_empa_atm,key_ruta_atm,cod_ruta_atm,ingreso,
                         imp_ingreso,imp_egreso,key_detcanal,codigo_usuario,cnt_bildet,cnt_bindet,
                         nro_caja,val_hora)
                         --campos de la tabla
                 VALUES (ld_Fecha(x),ln_codatm(x),ln_keyatm(x),lv_codagencia(x),
                         ln_codregion(x),ln_keyregion(x),lv_codubigeo(x),
                         ln_moneda(x),lv_codtipodin(x),ln_keytipodin(x),
                         ln_valdenodin(x),ln_keydenodin(x),ln_coddenodin(x),
                         ln_cantidad(x),ln_sucursal(x),ln_keymdaatm(x),ln_codmdaatm(x),ln_keyempaatm(x),
                         ln_codempaatm(x),ln_keyrutatm(x),ln_codrutatm(x),ln_ingreso(x),
                         ln_impingreso (x),
                         ln_impegreso(x),ln_detcan(x),lv_usuario(x),ln_bildet(x),ln_bindet(x),
                         ln_nrocaja(x),lv_hora(x)) 
                         --variables basada en tipo
              LOG ERRORS INTO Err$_Tmp_Fact_Op_Billetaje ('INSERT-'||lv_Fecha) REJECT LIMIT UNLIMITED;                                 
                commit;
           END IF;                        
           EXIT WHEN c_billetaje%notfound;
        END LOOP;    
        Commit;         
  Exception When Others Then
     lv_errm := substr(sqlerrm,1,200);
     Insert into dwstage.tmp_errores(fecha,nompro,msgerr)
     values(PD_FECHA,'SP_CARGA_BILLETAJE',lv_errm);
     Commit;      
  End ;

---------------------------------------------------------------------------------------------------------------------------
Procedure SP_TMP_DM_ESTILO_TARJETA  
  Is
  Begin
        MERGE INTO TMP_DM_ESTILO_TARJETA E
           USING (Select x.z0e468cod,x.z0e468dsc From dwextra.z0e468 x) b
              ON (E.COD_EST_TARJ = b.z0e468cod)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET E.DES_EST_TARJ   = TRIM(B.Z0E468DSC)
      WHEN NOT MATCHED THEN
                       INSERT (E.COD_EST_TARJ,E.DES_EST_TARJ,E.KEY_EST_TARJ)
                       VALUES(B.Z0E468COD,TRIM(B.Z0E468DSC),SQ_DM_ESTILO_TARJETA.NEXTVAL)
      LOG ERRORS INTO Err$_Tmp_Dm_Estilo_Tarjeta('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                        
                                             
End SP_TMP_DM_ESTILO_TARJETA; 
  
----------------------------------------------------------------------------------------------
Procedure SP_TMP_DM_VIGENCIA_TARJETA  
  Is
  Begin
        MERGE INTO TMP_DM_VIGENCIA_TARJETA E
           USING (Select x.z0e462cod,x.z0e462dsc From dwextra.z0e462 x) b
              ON (E.COD_VIG_TARJ = b.z0e462cod)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET E.DES_VIG_TARJ = TRIM(B.Z0E462DSC)
      WHEN NOT MATCHED THEN
                       INSERT (E.COD_VIG_TARJ,E.DES_VIG_TARJ,E.KEY_VIG_TARJ)
                       VALUES(B.Z0E462COD,TRIM(B.Z0E462DSC),SQ_DM_VIGENCIA_TARJETA.NEXTVAL)
      LOG ERRORS INTO Err$_Tmp_Dm_VIGENCIA_Tarjeta('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                        
                                             
End SP_TMP_DM_VIGENCIA_TARJETA; 
---------------------------------------------------------------------------------------------------------
Procedure SP_TMP_DM_PIN_TARJETA  
  Is
  Begin
        MERGE INTO TMP_DM_PIN_TARJETA E
           USING (Select x.z0e461cod,x.z0e461dsc From dwextra.z0e461 x) b
              ON (E.COD_PIN_TARJ = b.z0e461cod)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET E.DES_PIN_TARJ = TRIM(B.Z0E461DSC)
      WHEN NOT MATCHED THEN
                       INSERT (E.COD_PIN_TARJ,E.DES_PIN_TARJ,E.KEY_PIN_TARJ)
                       VALUES(B.Z0E461COD,TRIM(B.Z0E461DSC),SQ_DM_PIN_TARJETA.NEXTVAL)
      LOG ERRORS INTO Err$_Tmp_Dm_Pin_Tarjeta('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                        
                                             
End SP_TMP_DM_PIN_TARJETA;
---------------------------------------------------------------------------------------------
Procedure SP_TMP_DM_LIMITE_TARJETA  
  Is
  Begin
        MERGE INTO TMP_DM_LIMITE_TARJETA E
           USING (Select x.z0e465cod,x.z0e465dsc,x.z0e465lim From dwextra.z0e465 x) b
              ON (E.COD_LIM_TARJ = b.z0e465cod)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET E.DES_LIM_TARJ = TRIM(B.Z0E465DSC),
                              E.IMP_LIM_TARJ = B.Z0E465LIM
      WHEN NOT MATCHED THEN
                       INSERT (E.COD_LIM_TARJ,E.DES_LIM_TARJ,E.KEY_LIM_TARJ,E.IMP_LIM_TARJ)
                       VALUES(B.Z0E465COD,TRIM(B.Z0E465DSC),SQ_DM_LIMITE_TARJETA.NEXTVAL,B.Z0E465LIM)
      LOG ERRORS INTO Err$_Tmp_Dm_Limite_Tarjeta('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                        
                                             
End SP_TMP_DM_LIMITE_TARJETA;
--------------------------------------------------------------------------------------------------------
Procedure SP_TMP_DM_COM_TARJETA  
  Is
  Begin
        MERGE INTO TMP_DM_COM_TARJETA E
           USING (Select x.z0e466cod,x.z0e466dsc From dwextra.Z0e466 x) b
              ON (E.COD_COM_TARJ = b.z0e466cod)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET E.DES_COM_TARJ = TRIM(B.Z0E466DSC)
                              
      WHEN NOT MATCHED THEN
                       INSERT (E.COD_COM_TARJ,E.DES_COM_TARJ,E.KEY_COM_TARJ)
                       VALUES(B.Z0E466COD,TRIM(B.Z0E466DSC),SQ_DM_COM_TARJETA.NEXTVAL)
      LOG ERRORS INTO Err$_Tmp_Dm_Com_Tarjeta('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                        
                                             
End SP_TMP_DM_COM_TARJETA;
-----------------------------------------------------------------------------------------------------------------------
Procedure SP_TMP_DM_MEM_TARJETA  
  Is
  Begin
        MERGE INTO TMP_DM_MEM_TARJETA E
           USING (Select x.z0e477cod,x.z0e477dsc From dwextra.Z0e477 x) b
              ON (E.COD_MEM_TARJ = B.Z0E477COD)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET E.DES_MEM_TARJ = TRIM(B.Z0E477DSC)
                              
      WHEN NOT MATCHED THEN
                       INSERT (E.COD_MEM_TARJ,E.DES_MEM_TARJ,E.KEY_MEM_TARJ)
                       VALUES(B.Z0E477COD,TRIM(B.Z0E477DSC),SQ_DM_MEM_TARJETA.NEXTVAL)
      LOG ERRORS INTO Err$_Tmp_Dm_Mem_Tarjeta('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                        
                                             
End SP_TMP_DM_MEM_TARJETA;
-----------------------------------------------------------------------------------------------------
/*Procedure SP_TMP_DM_MONEDA_ATM
  Is
  Begin
        MERGE INTO TMP_DM_MONEDA_ATM T
           USING (Select x.JAQLMATMC, x.JAQLMATMD From dwextra.Jaqlmatm x) b
              ON (t.cod_mda_atm = b.jaqlmatmc)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET t.des_mda_atm = b.jaqlmatmd
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_mda_atm,t.cod_mda_atm,t.des_mda_atm)
                       VALUES(sq_dm_mda_atm.nextval,b.jaqlmatmc,b.jaqlmatmd)
      LOG ERRORS INTO Err$_Tmp_Dm_MONEDA_ATM('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                                                               
  End SP_TMP_DM_MONEDA_ATM; 
*/
Procedure SP_TMP_DM_MONEDA_ATM
  Is
  Begin
        MERGE INTO TMP_DM_MONEDA_ATM T
           USING (Select x.JAQLMATMC, x.JAQLMATMD From dwextra.Jaqlmatm x
                  UNION ALL
                  Select 'N', 'No Definido' From dual
                 ) b
              ON (t.cod_mda_atm = b.jaqlmatmc)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET t.des_mda_atm = b.jaqlmatmd
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_mda_atm,t.cod_mda_atm,t.des_mda_atm)
                       VALUES(sq_dm_mda_atm.nextval,b.jaqlmatmc,b.jaqlmatmd)
      LOG ERRORS INTO Err$_Tmp_Dm_MONEDA_ATM('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                                                               
  End SP_TMP_DM_MONEDA_ATM;
-------------------------------------------------------------------------------------------------------------
Procedure SP_TMP_DM_EMPABA_ATM
  Is
  Begin
        MERGE INTO TMP_DM_EMPABA_ATM T
           USING (Select x.JAQLABCOD, x.JAQLABDES From dwextra.jaqlabas x) b
              ON (t.cod_empa_atm = b.jaqlabcod)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET t.des_empa_atm = b.jaqlabdes
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_empa_atm,t.cod_empa_atm,t.des_empa_atm)
                       VALUES(sq_dm_empaba_atm.nextval,b.jaqlabcod,b.jaqlabdes)
      LOG ERRORS INTO Err$_Tmp_Dm_EMPABA_ATM('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                                                               
  End SP_TMP_DM_EMPABA_ATM; 

--------------------------------------------------------------------------------------------------------------
Function fn_KEY_MDA_ATM (pc_mdaatm in char)
Return Number
Is 
  ln_keymdaatm tmp_dm_moneda_atm.key_mda_atm%type; 
Begin
    
    Begin
         Select b.key_mda_atm
           Into ln_keymdaatm
           From tmp_dm_moneda_atm b
          Where b.cod_mda_atm = pc_mdaatm;
    Exception When Others Then
          ln_keymdaatm := Null;
    End;
    
    Return ln_keymdaatm;
End fn_KEY_MDA_ATM; 

----------------------------------------------------------------------------------------------------
Function fn_KEY_EMPA_ATM (pc_empatm in number)
Return Number
Is 
  ln_keyempatm tmp_dm_empaba_atm.key_empa_atm%type; 
Begin
    
    Begin
         Select b.key_empa_atm
           Into ln_keyempatm
           From tmp_dm_empaba_atm b
          Where b.cod_empa_atm = pc_empatm;
    Exception When Others Then
          ln_keyempatm := Null;
    End;
    
    Return ln_keyempatm;
End fn_KEY_EMPA_ATM; 
---------------------------------------------------------------------------------------------------
Function fn_key_ruta_atm (pn_codrut in number)
Return Number
Is 
  ln_keyrut tmp_dm_ruta_atm.key_ruta_atm%type; 
Begin
    
    Begin
         Select b.key_ruta_atm
           Into ln_keyrut
           From tmp_dm_ruta_atm b
          Where b.cod_ruta_atm= pn_codrut;
    Exception When Others Then
          ln_keyrut := Null;
    End;
    
    Return ln_keyrut;
End fn_key_ruta_atm;  
--------------------------------------------------------------------------------------------------------
/*Procedure SP_TMP_DM_RUTA_ATM
  Is
  Begin
        MERGE INTO TMP_DM_RUTA_ATM T
           USING (Select x.JAQLRCOD, x.JAQLRDES From dwextra.Jaqlruta x) b
              ON (t.cod_ruta_atm = b.jaqlrcod)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET t.des_ruta_atm = b.jaqlrdes
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_ruta_atm,t.cod_ruta_atm,t.des_ruta_atm)
                       VALUES(sq_dm_ruta_atm.nextval,b.jaqlrcod,b.jaqlrdes)
      LOG ERRORS INTO Err$_Tmp_Dm_RUTA_ATM('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                                                               
  End SP_TMP_DM_RUTA_ATM; 
*/
Procedure SP_TMP_DM_RUTA_ATM
  Is
  Begin
        MERGE INTO TMP_DM_RUTA_ATM T
           USING (Select x.JAQLRCOD, x.JAQLRDES From dwextra.Jaqlruta x
                  Union All
                  Select 0,'NO REGISTRADA' From dual
                 ) b
              ON (t.cod_ruta_atm = b.jaqlrcod)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET t.des_ruta_atm = b.jaqlrdes
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_ruta_atm,t.cod_ruta_atm,t.des_ruta_atm)
                       VALUES(sq_dm_ruta_atm.nextval,b.jaqlrcod,b.jaqlrdes)
      LOG ERRORS INTO Err$_Tmp_Dm_RUTA_ATM('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                                                               
  End SP_TMP_DM_RUTA_ATM;
-----------------------------------------------------------------------------------------------------------
Function fn_ingreso (pn_codatm in number,
                     pd_fecha in date,
                     pc_tipom in char,
                     pn_denom in number,
                     pn_comon in number)
Return Number
Is 
  ln_cantidad tmp_fact_op_billetaje.ingreso%type;
  fech_ingreso date:= pd_fecha-1; 
Begin
    
    Begin
         Select b.jaql504canti
           Into ln_cantidad
           From dwextra.jaql504 b
          Where b.jaql504cousu = pn_codatm
          and b.jaql504fepro = fech_ingreso
          and b.jaql504timon = pc_tipom
          and b.jaql504denom = pn_denom
          and b.jaql504comon = pn_comon;
    Exception When Others Then
          ln_cantidad := Null;
    End;
    
    Return ln_cantidad;
End fn_ingreso; 
--------------------------------------------------------------------------------------
Function fn_EfectivoATM (pn_codEATM in number,
                      pd_fecha in date,
                      pn_ingregres in number,
                      pn_codmon in number)
                     
Return Number
Is 
  ln_imp_ingreso tmp_fact_op_billetaje.imp_ingreso%type;
  ln_Rubro number (16);
  
Begin
    IF pn_codmon = 0
       then ln_Rubro := 1111020000001;
    else ln_Rubro := 1121020000001;
    end if;
    Begin
         Select sum (b.hcimp1)
           Into ln_imp_ingreso
           From dwextra.fsh015_16 b
          Where b.hsubop = pn_codEATM
          and b.hfcon = pd_fecha
          and b.hcodmo = pn_ingregres
          and b.hrubro = ln_Rubro
          and hccorr <> 99;
    Exception When Others Then
          ln_imp_ingreso := Null;
    End;
    
    Return ln_imp_ingreso;
End fn_EfectivoATM; 

----------------------------------------------------------------------------------------------------------
Function fn_key_tipo_tarj (pc_codtarj in char)
Return Number
Is 
  ln_keytarj tmp_dm_tarjeta.key_tipo_tarj%type; 
Begin
    
    Begin
         Select b.key_tipo_tarj
           Into ln_keytarj
           From tmp_dm_tipo_tarjeta b
          Where b.cod_tipo_tarj= pc_codtarj;
    Exception When Others Then
          ln_keytarj := Null;
    End;
    
    Return ln_keytarj;
End fn_key_tipo_tarj;
----------------------------------------------------------------------------------------------------------
Function fn_key_vig_tarj (pc_codvig in number)
Return Number
Is 
  ln_keyvig tmp_dm_tarjeta.key_vig_tarj%type; 
Begin
    
    Begin
         Select b.key_vig_tarj
           Into ln_keyvig
           From tmp_dm_vigencia_tarjeta b
          Where b.cod_vig_tarj= pc_codvig;
    Exception When Others Then
          ln_keyvig := Null;
    End;
    
    Return ln_keyvig;
End fn_key_vig_tarj;
--------------------------------------------------------------------------------------------------
Function fn_key_est_tarj (pc_codest in char)
Return Number
Is 
  ln_keyest tmp_dm_tarjeta.key_est_tarj%type; 
Begin
    
    Begin
         Select b.key_est_tarj
           Into ln_keyest
           From tmp_dm_estilo_tarjeta b
          Where b.cod_est_tarj= pc_codest;
    Exception When Others Then
          ln_keyest := Null;
    End;
    
    Return ln_keyest;
End fn_key_est_tarj;
--------------------------------------------------------------------------------------
Function fn_key_Pin_tarj (pv_codpin in varchar2)
Return Number
Is 
  ln_keypin tmp_dm_tarjeta.key_pin_tarj%type; 
Begin
    
    Begin
         Select b.key_pin_tarj
           Into ln_keypin
           From tmp_dm_pin_tarjeta b
          Where b.cod_pin_tarj= pv_codpin;
    Exception When Others Then
          ln_keypin := Null;
    End;
    
    Return ln_keypin;
End fn_key_Pin_tarj;
-----------------------------------------------------------------------------
Function fn_key_lim_tarj (pn_codlim in number)
Return Number
Is 
  ln_keylim tmp_dm_tarjeta.key_lim_tarj%type; 
Begin
    
    Begin
         Select b.key_lim_tarj
           Into ln_keylim
           From tmp_dm_limite_tarjeta b
          Where b.cod_lim_tarj= pn_codlim;
    Exception When Others Then
          ln_keylim := Null;
    End;
    
    Return ln_keylim;
End fn_key_lim_tarj;
-------------------------------------------------------------------------------
Function fn_key_com_tarj (pn_codcom in number)
Return Number
Is 
  ln_keycom tmp_dm_tarjeta.key_com_tarj%type; 
Begin
    
    Begin
         Select b.key_com_tarj
           Into ln_keycom
           From tmp_dm_com_tarjeta b
          Where b.cod_com_tarj= pn_codcom;
    Exception When Others Then
          ln_keycom := Null;
    End;
    
    Return ln_keycom;
End fn_key_com_tarj;
----------------------------------------------------------------------------------------
Function fn_key_mem_tarj (pn_codmem in number)
Return Number
Is 
  ln_keymem tmp_dm_tarjeta.key_mem_tarj%type; 
Begin
    
    Begin
         Select b.key_mem_tarj
           Into ln_keymem
           From tmp_dm_mem_tarjeta b
          Where b.cod_mem_tarj= pn_codmem;
    Exception When Others Then
          ln_keymem := Null;
    End;
    
    Return ln_keymem;
End fn_key_mem_tarj;
------------------------------------------------------------------------------------------
Procedure SP_TMP_DM_TEC_TARJETA
  Is
  Begin
        MERGE INTO TMP_DM_TEC_TARJETA T
           USING (Select 'C' CODIGO, 'CHIP' DESCRI From DUAL
                  UNION ALL
                  SELECT 'B' CODIGO, 'BANDA' DESCRI From DUAL) b
              ON (t.cod_tec_tarj = b.codigo )
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET t.des_tec_tarj = b.descri
                              
      WHEN NOT MATCHED THEN
                       INSERT (t.key_tec_tarj,t.cod_tec_tarj,t.des_tec_tarj)
                       VALUES(sq_dm_tec_tarjeta.nextval,b.codigo,b.descri)
      LOG ERRORS INTO Err$_Tmp_Dm_tec_tarjeta('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                                                               
  End SP_TMP_DM_TEC_TARJETA; 


---------------------------------------------------------------------------------------------
Function fn_key_tec_tarj (pc_codtec in char)
Return Number
Is 
  ln_keytec tmp_dm_tec_tarjeta.key_tec_tarj%type; 
Begin
    
    Begin
         Select b.key_tec_tarj
           Into ln_keytec
           From tmp_dm_tec_tarjeta b
          Where b.cod_tec_tarj= pc_codtec;
    Exception When Others Then
          ln_keytec := Null;
    End;
    
    Return ln_keytec;
End fn_key_tec_tarj;

--------------------------------------------------------------------------------------------
Procedure SP_CARGA_TARJETA (PN_TARINI In Number,
                            PN_TARFIN In Number,
                            PV_FECPRO In Varchar2
                            --PD_FECHA  in date, --Fecha de proceso
                            --pc_tipcar in varchar2 --Tipo de carga T:Total / E:Errores
                           )
  --------------------------------------------------------------------------------------
  -- Creación:  
  ---------------------------------------------------------------------------------------
  -- Fecha  : 28 05 2018
  -- Autor  : Rafito
  -- Cambios: Transformación de datos de tarjetas
  ---------------------------------------------------------------------------------------
  IS
     lv_query varchar2(200);

     TYPE tc_Tarjeta IS REF CURSOR;
     c_tarjeta tc_tarjeta;
  
     -- Declaración de tipos de variable (todos los campos de tabla tmp_dm_billetaje)
     Type tp_ktipotarj is table of tmp_dm_tarjeta.key_tipo_tarj%type;
     type tp_Ctipotarj is table of tmp_dm_tarjeta.cod_tipo_tarj%type;
     type tp_kvigtarj is table of tmp_dm_tarjeta.key_vig_tarj%type;
     type tp_Cvigtarj is table of tmp_dm_tarjeta.cod_vig_tarj%type;
     type tp_kesttarj is table of tmp_dm_tarjeta.key_est_tarj%type;
     type tp_Cesttarj is table of tmp_dm_tarjeta.cod_est_tarj%type;
     type tp_kpintarj is table of tmp_dm_tarjeta.key_pin_tarj%type;
     type tp_Cpintarj is table of tmp_dm_tarjeta.cod_pin_tarj%type;
     type tp_Klimtarj is table of tmp_dm_tarjeta.key_lim_tarj%type;
     type tp_Climtarj is table of tmp_dm_tarjeta.cod_lim_tarj%type;
     type tp_Kcomtarj is table of tmp_dm_tarjeta.key_com_tarj%type;
     type tp_Ccomtarj is table of tmp_dm_tarjeta.cod_com_tarj%type;
     type tp_Kmemtarj is table of tmp_dm_tarjeta.key_mem_tarj%type;
     type tp_Cmemtarj is table of tmp_dm_tarjeta.cod_mem_tarj%type;
     type tp_nrotarj is table of tmp_dm_tarjeta.nro_tarj%type;
     type tp_nomtarj is table of tmp_dm_tarjeta.nom_tarj%type; 
     type tp_codpais  is table of tmp_dm_tarjeta.cod_pais%type;
     type tp_codtdoc is table of tmp_dm_tarjeta.cod_tdoc%type; 
     type tp_nrodoc is table of tmp_dm_tarjeta.nro_doc%type; 
     type tp_codclien is table of tmp_dm_tarjeta.cod_cliente%type;
     type tp_fecvto is table of tmp_dm_tarjeta.fec_vto%type; 
     type tp_fecalta  is table of tmp_dm_tarjeta.fec_alta%type;
     type tp_fecmod is table of tmp_dm_tarjeta.fec_mod%type;  
     type tp_fecaut is table of tmp_dm_tarjeta.fec_aut%type; 
     type tp_fecbaja is table of tmp_dm_tarjeta.fec_baja%type;
     type tp_codusumo is table of tmp_dm_tarjeta.cod_usumod%type;
     type tp_codusuaut  is table of tmp_dm_tarjeta.cod_usuaut%type;
     type tp_codsucursa is table of tmp_dm_tarjeta.cod_sucursal%type;
     type tp_Ctectar is table of tmp_dm_tarjeta.cod_tec_tarj%type;
     Type tp_nrotar is table of tmp_tarjetas.nro_tarj%type;
     type tp_indprem is table of tmp_dm_tarjeta.ind_premium%type;
     
     
     -- Declaración de variables en base a tipos declarados 
     
     ln_ktipotarj  tp_ktipotarj; 
     lc_Ctipotarj  tp_Ctipotarj; 
     ln_kvigtarj   tp_kvigtarj;
     ln_Cvigtarj   tp_Cvigtarj; 
     ln_kesttarj   tp_kesttarj; 
     lv_Cesttarj   tp_Cesttarj; 
     ln_kpintarj   tp_kpintarj;
     lv_Cpintarj   tp_Cpintarj; 
     ln_Klimtarj   tp_Klimtarj; 
     ln_Climtarj   tp_Climtarj; 
     ln_Kcomtarj   tp_Kcomtarj; 
     ln_Ccomtarj   tp_Ccomtarj; 
     ln_Kmemtarj   tp_Kmemtarj; 
     ln_Cmemtarj   tp_Cmemtarj;
     lc_nrotarj    tp_nrotarj;
     lv_nomtarj    tp_nomtarj;
     ln_codpais    tp_codpais; 
     ln_codtdoc    tp_codtdoc;
     lc_nrodoc     tp_nrodoc;  
     lv_codclien   tp_codclien; 
     ld_fecvto     tp_fecvto;  
     ld_fecalta    tp_fecalta;
     ld_fecmod     tp_fecmod; 
     ld_fecaut     tp_fecaut;  
     ld_fecbaja    tp_fecbaja; 
     lv_codusumo   tp_codusumo; 
     lv_codusuaut  tp_codusuaut; 
     lv_codsucursa tp_codsucursa;
     lc_Ctectar    tp_Ctectar;
     lc_nrotar     tp_nrotar;  
     ln_indprem    tp_indprem;
    
     -- Declaración de otras variables 
     lv_Fecha varchar2(8) := PV_FECPRO;--to_char(PD_FECHA,'RRRRMMDD');
     ln_nreg  Number(10) := 0; 
     -- APP
     vHABAPP Varchar2(3);
     dFAFAPP Date;
     vHORAPP Varchar2(10);
     dFACAPP Date;
     vHACAPP Varchar2(10);
     vCORREO Varchar2(300);
     vNUMCEL Varchar2(20);
  
  BEGIN
      -- Truncar table de billetaje y tabla de errores
      --execute immediate 'truncate table tmp_dm_tarjeta';
      --execute immediate 'truncate table err$_TMP_dm_tarjeta';
      -- Cargar datos en cursor con sentencia select
      --Open c_tarjeta FOR
           -- Seleccionar tabla de tarjeta con filtro de fecha (WHERE)
      
     Select t.N_TIPTAR,t.Z0E469COD,
            t.N_VIGTAR,t.Z0E462COD,
            t.N_ESTTAR,t.Z0E468COD,
            t.N_PINTAR,t.Z0E461COD,
            t.N_LIMTAR,t.Z0E465COD,
            t.N_COMTAR,t.Z0E466COD,
            t.N_MEMTAR,t.Z0E477COD,
            t.Z0E478NRO,x.nro_tarj,
            t.Z0E478NOM,t.Z0E478THP,t.Z0E478THT,t.Z0E478THD,
            t.V_CODCLI,
            t.Z0E478FVT,t.Z0E478FAL,t.Z0E478FMD,t.Z0E478FAU,t.Z0E478FBJ,
            t.Z0E478UMD,t.Z0E478UAU,t.Z0E478SUC,t.V_TCHIP, t.indprem
       Bulk Collect Into ln_ktipotarj,lc_Ctipotarj, 
                         ln_kvigtarj,ln_Cvigtarj,  
                         ln_kesttarj,lv_Cesttarj,  
                         ln_kpintarj,lv_Cpintarj,  
                         ln_Klimtarj,ln_Climtarj,  
                         ln_Kcomtarj,ln_Ccomtarj,  
                         ln_Kmemtarj,ln_Cmemtarj,  
                         lc_nrotarj,lc_nrotar,
                         lv_nomtarj,ln_codpais,ln_codtdoc,lc_nrodoc,    
                         lv_codclien,  
                         ld_fecvto,ld_fecalta,ld_fecmod,ld_fecaut,ld_fecbaja,   
                         lv_codusumo,lv_codusuaut, 
                         lv_codsucursa,lc_Ctectar,
                         ln_indprem
        From
            (          
              Select pq_tmp_carga_transacc.fn_key_tipo_tarj(n.z0e469cod) N_TIPTAR,N.Z0E469COD,
                     pq_tmp_carga_transacc.fn_key_vig_tarj(n.z0e462cod)  N_VIGTAR,N.Z0E462COD,
                     pq_tmp_carga_transacc.fn_key_est_tarj(n.z0e468cod)  N_ESTTAR,N.Z0E468COD,
                     pq_tmp_carga_transacc.fn_key_Pin_tarj(n.z0e461cod)  N_PINTAR,N.Z0E461COD,
                     pq_tmp_carga_transacc.fn_key_lim_tarj(n.z0e465cod)  N_LIMTAR,N.Z0E465COD,
                     pq_tmp_carga_transacc.fn_key_com_tarj(n.z0e466cod)  N_COMTAR,N.Z0E466COD,
                     pq_tmp_carga_transacc.fn_key_mem_tarj(n.z0e477cod)  N_MEMTAR,N.Z0E477COD,
                     N.Z0E478NRO,N.Z0E478NOM,N.Z0E478THP,N.Z0E478THT,N.Z0E478THD,
                     TRIM(N.Z0E478THP)||TRIM(N.Z0E478THT)||TRIM(N.Z0E478THD) V_CODCLI,
                     N.Z0E478FVT,N.Z0E478FAL,N.Z0E478FMD,N.Z0E478FAU,N.Z0E478FBJ,
                     TRIM(UPPER(N.Z0E478UMD)) Z0E478UMD,TRIM(UPPER(N.Z0E478UAU)) Z0E478UAU,
                     TO_CHAR(N.Z0E478SUC) Z0E478SUC,
                     CASE WHEN Z0E478FAL<TO_DATE('20141231','RRRRMMDD') THEN 'B' ELSE 'C' END V_TCHIP,
                     Case When substr(Z0E478NRO,1,8) = '42615346' Then 1 Else 0 End IndPrem -- Premium 
                FROM DWEXTRA.Z0e478 N
               --WHERE TO_NUMBER(N.Z0E478NRO) Between PN_TARINI AND PN_TARFIN
               WHERE N.Z0E478SUC=PN_TARINI
                ---WHERE N.Z0E478FAL>PD_FECHA
                     UNION ALL
              Select pq_tmp_carga_transacc.fn_key_tipo_tarj('DEB'),'DEB',
                     pq_tmp_carga_transacc.fn_key_vig_tarj(9),9,
                     pq_tmp_carga_transacc.fn_key_est_tarj('C'),'C',
                     pq_tmp_carga_transacc.fn_key_Pin_tarj('0'),'0',
                     pq_tmp_carga_transacc.fn_key_lim_tarj(10),10,
                     pq_tmp_carga_transacc.fn_key_com_tarj(1),1,
                     pq_tmp_carga_transacc.fn_key_mem_tarj(4),4,
                     '000','NO REGISTRADA',
                     null,null,null,null,
                     to_date('20180701','rrrrmmdd'),to_date('20180701','rrrrmmdd'),
                     to_date('20180701','rrrrmmdd'),to_date('20180701','rrrrmmdd'),
                     to_date('20180701','rrrrmmdd'),
                     'NOREGIS','NOREGIS','904','C',0
                FROM DUAL
            ) t
        Left Join tmp_tarjetas x
               On trim(x.nro_tarj) = trim(t.Z0E478NRO);              
      -- Abrir cursor
        For x in 1..lc_nrotarj.count Loop      
            IF lc_nrotar(x) Is Null Then
               --- Datos den APP
               PQ_TMP_CARGA_TRANSACC.SP_TARJETA_APP(lc_nrotarj(x),vHABAPP,
                                                     dFAFAPP,vHORAPP,
                                                     dFACAPP,vHACAPP,
                                                     vCORREO,vNUMCEL
                                                   );
               ---
               INSERT INTO TMP_DM_TARJETA nologging 
                        (key_tipo_tarj,cod_tipo_tarj,key_vig_tarj,
                         cod_vig_tarj,key_est_tarj,cod_est_tarj,
                         key_pin_tarj,cod_pin_tarj,key_lim_tarj,
                         cod_lim_tarj,key_com_tarj,cod_com_tarj,
                         key_mem_tarj,cod_mem_tarj,nro_tarj,
                         key_tarj, NOM_TARJ,COD_PAIS,COD_TDOC,
                         NRO_DOC,COD_CLIENTE,FEC_VTO,FEC_ALTA,
                         FEC_MOD,FEC_AUT,FEC_BAJA,COD_USUMOD, 
                         COD_USUAUT,COD_SUCURSAL,COD_TEC_TARJ,
                         KEY_TEC_TARJ,ind_premium,
                         -- APP
                         ind_habapp,app_fecafi,app_horafi,app_fecuin,
                         app_horuin,app_correo,app_nulcel
                        )
                         --campos de la tabla
                 VALUES (ln_ktipotarj(x),lc_Ctipotarj(x),ln_kvigtarj(x),
                        ln_Cvigtarj(x),ln_kesttarj(x),lv_Cesttarj(x),
                        ln_kpintarj(x),lv_Cpintarj(x),ln_Klimtarj(x),
                        ln_Climtarj(x),ln_Kcomtarj(x),ln_Ccomtarj(x),
                        ln_Kmemtarj(x),ln_Cmemtarj(x),lc_nrotarj(x),
                        --sq_dm_tarjeta.nextval,
                        PQ_TMP_CARGA_TRANSACC.SEQ_NEXTVAL('SQ_DM_TARJETA'),
                        lv_nomtarj(x),ln_codpais(x),
                        ln_codtdoc(x),
                        lc_nrodoc(x),lv_codclien(x),ld_fecvto(x),ld_fecalta(x),
                        ld_fecmod(x),ld_fecaut(x),ld_fecbaja(x),lv_codusumo(x),
                        lv_codusuaut(x),lv_codsucursa(x),lc_Ctectar(x),
                        pq_tmp_carga_transacc.fn_key_tec_tarj(lc_Ctectar(x)),
                        ln_indprem(x),
                        -- APP
                        vHABAPP,dFAFAPP,vHORAPP,dFACAPP,vHACAPP,vCORREO,vNUMCEL
                       ) 
                         --variables basada en tipo
                LOG ERRORS INTO Err$_Tmp_Dm_Tarjeta ('INSERT-'||lv_Fecha) REJECT LIMIT UNLIMITED;                                 
            ELSE
                Update tmp_dm_tarjeta k
                   set k.nom_tarj    = lv_nomtarj(x),
                       k.cod_pais    = ln_codpais(x),
                       k.cod_tdoc    = ln_codtdoc(x),
                       k.nro_doc     = lc_nrodoc(x),
                       k.cod_cliente = lv_codclien(x),
                       k.fec_vto     = ld_fecvto(x),
                       k.fec_mod     = ld_fecmod(x),
                       k.fec_aut     = ld_fecaut(x),
                       k.fec_baja    = ld_fecbaja(x),
                       k.cod_usumod  = lv_codusumo(x),
                       k.cod_usuaut  = lv_codusuaut(x),
                       k.cod_sucursal= lv_codsucursa(x),
                       k.ind_premium = ln_indprem(x),
                       ind_habapp    = vHABAPP,
                       app_fecafi    = dFAFAPP,
                       app_horafi    = vHORAPP,
                       app_fecuin    = dFACAPP,
                       app_horuin    = vHACAPP,
                       app_correo    = vCORREO,
                       app_nulcel    = vNUMCEL
                 Where k.nro_tarj    = lc_nrotarj(x)
                LOG ERRORS INTO Err$_Tmp_Dm_Tarjeta ('INSERT-'||lv_Fecha) REJECT LIMIT UNLIMITED;                                 
            END IF; 
            ln_nreg := ln_nreg + 1;
            If Mod(ln_nreg,1000) = 0 Then
              Commit;
              ln_nreg := 0;
            End If;                           
           --EXIT WHEN c_tarjeta%notfound;
        END LOOP;    
        Commit;         
  End ;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure SP_TARJETA_APP(PV_NUMTAR In Varchar2, -- Nro. Tarjeta 
                           PV_HABAPP Out Varchar2,-- Indicador de habilitada en APP 
                           PD_FAFAPP Out Date,    -- Fecha Afiliacion en APP
                           PV_HORAPP Out Varchar2,-- Hora  afiliacion en APP
                           PD_FACAPP Out Date,    -- Fecha ultimo acceso a APP
                           PV_HACAPP Out Varchar2,-- Hora ultimo acceso a APP
                           PV_CORREO Out Varchar2,-- Coreeo en APP 
                           PV_NUMCEL Out Varchar2 -- Celular en APP
                          )
  Is
  Begin  
       Select jaqz205habil,jaqz205feafi,jaqz205hoafi,
              jaqz205feult,jaqz205hoult,jaqz205email,
              jaqz205celul   
         Into PV_HABAPP,PD_FAFAPP,PV_HORAPP, 
              PD_FACAPP,PV_HACAPP,PV_CORREO,
              PV_NUMCEL    
         from dwextra.jaqz205
        where trim(jaqz205nutar) = trim(PV_NUMTAR);
  Exception When Others Then
      PV_HABAPP:=null; PD_FAFAPP:=null; PV_HORAPP:=null; 
      PD_FACAPP:=null; PV_HACAPP:=null; PV_CORREO:=null;
      PV_NUMCEL:=null;     
  End SP_TARJETA_APP;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Procedure SP_TMP_DM_EMPSER  
  Is
  Begin
        MERGE INTO TMP_DM_EMPSER E
           USING (Select x.JAQL508COENT,x.JAQL508NOENT,x.JAQL508ABENT From dwextra.jaql508 x
                  Union All
                  Select 999, 'CAJA AREQUIPA', 'CAJA AQP' from dual
                 ) b
              ON (E.COD_EMPSER = b.jaql508coent)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET E.DES_EMPSER = b.jaql508noent,
                              E.abr_empser = b.jaql508abent
      WHEN NOT MATCHED THEN
                       INSERT (E.KEY_EMPSER,e.cod_empser,e.des_empser,e.abr_empser)
                       VALUES(sq_dm_empser.nextval,b.jaql508coent,b.jaql508noent,b.jaql508abent)
      LOG ERRORS INTO Err$_Tmp_Dm_empser('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                        
                                             
End SP_TMP_DM_EMPSER;

------------------------------------------------------------------------------------------------------------
Procedure SP_TMP_DM_SERVAFIL 
  Is
  Begin
        MERGE INTO TMP_DM_SERVAFIL E
           USING (Select x.JAQL514COTSV,x.JAQL514DETSV From dwextra.jaql514 x
                  Union All
                  Select 990, 'OPE. POR INTERNET' from dual
                  Union All
                  Select 991, 'COMPRAS EN EXTRANJERO' from dual
                  Union All
                  Select 992, 'TARJETA DE CORDENADAS' from dual
                 ) b
              ON (E.COD_SERVAFIL = b.jaql514cotsv)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET E.DES_SERVAFIL = b.jaql514detsv
      WHEN NOT MATCHED THEN
                       INSERT (E.KEY_SERVAFIL,E.COD_SERVAFIL,E.DES_SERVAFIL)
                       VALUES(sq_dm_SERVAFIL.Nextval,B.JAQL514COTSV,B.JAQL514DETSV)
      LOG ERRORS INTO Err$_Tmp_Dm_SERVAFIL('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                        
                                             
End SP_TMP_DM_SERVAFIL;

----------------------------------------------------------------------------------------------
Function fn_key_empser (PN_EMPSER in number)
Return Number
Is 
  ln_keyempser tmp_dm_empser.key_empser%type; 
Begin
    
    Begin
         Select b.key_empser
           INTO ln_keyempser
           From tmp_dm_empser b
          Where b.cod_empser = PN_EMPSER;
    Exception When Others Then
          ln_keyempser := Null;
    End;
    
    Return ln_keyempser;
End fn_key_empser;
-----------------------------------------------------------------------------------
Function fn_key_servafi (PN_SERAFI in number)
Return Number
Is 
  ln_keyservafi tmp_dm_servafil.key_servafil%type; 
Begin
    
    Begin
         Select b.key_servafil
           Into ln_keyservafi
           From tmp_dm_servafil b
          Where b.cod_servafil = PN_SERAFI;
    Exception When Others Then
          ln_keyservafi := Null;
    End;
    
    Return ln_keyservafi;
End fn_key_servafi;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function fn_key_tarjeta (PC_NROTAR in char)
Return number
Is 
  ln_keytarj tmp_dm_tarjeta.key_tarj%type; 
Begin
    
    Begin
         Select b.key_tarj
           Into ln_keytarj
           From tmp_dm_tarjeta b
          Where b.nro_tarj = PC_NROTAR;
    Exception When Others Then
          ln_keytarj := Null;
    End;
    
    Return ln_keytarj;
End fn_key_tarjeta;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Procedure sp_Operaciones_internet (PD_FECHA  in date, --Fecha de proceso
                               pc_tipcar in varchar2 --Tipo de carga T:Total / E:Errores
                               )
  --------------------------------------------------------------------------------------
  -- Creación:Operaciones por Internet
  ---------------------------------------------------------------------------------------
  -- Fecha  : 04 Junio 2018
  -- Autor  : Rafael
  -- Cambios:
  ---------------------------------------------------------------------------------------
  IS
     lv_query varchar2(200);

     TYPE tc_servafil IS REF CURSOR;
     c_servafil tc_servafil;
  
     -- Declaración de tipos de variable (todos los campos de tabla tmp_dm_fact_op_servafil)
     Type tp_codempser is table of tmp_fact_op_servafil.cod_empser%type;
     Type tp_KEYEMPSER is table of tmp_fact_op_servafil.key_empser%type;
     Type tp_CODSERVAFI is table of tmp_fact_op_servafil.cod_servafi%type;
     Type tp_KEYSERVAFI is table of tmp_fact_op_servafil.key_servafi%type;
     Type tp_CODCLIENTE is table of tmp_fact_op_servafil.cod_cliente%type;
     Type tp_NROTARJETA is table of tmp_fact_op_servafil.nro_tarjeta%type;
     Type tp_KEYTARJETA is table of tmp_fact_op_servafil.key_tarjeta%type;
     Type tp_CODIGOCUENTA is table of tmp_fact_op_servafil.codigo_cuenta%type;
     Type tp_CUENTAUNICA is table of tmp_fact_op_servafil.cuenta_unica%type;
     Type tp_NROCONTRATO is table of tmp_fact_op_servafil.nro_contrato%type;
     Type tp_FECAFILIA is table of tmp_fact_op_servafil.fec_afilia%type;
     Type tp_USUAFILIA  is table of tmp_fact_op_servafil.usu_afilia%type;
     Type tp_FECDESAFIL is table of tmp_fact_op_servafil.fec_desafil%type;
     Type tp_USUDESAFIL is table of tmp_fact_op_servafil.usu_desafil%type;
     Type tp_ESTAFILIA is table of tmp_fact_op_servafil.est_afilia%type;

     
     
     -- Declaración de variables en base a tipos declarados 
     ln_codempser tp_codempser;
     ln_keyempser tp_KEYEMPSER;                              
     ln_CODSERVAFI tp_CODSERVAFI;                                      
     ln_KEYSERVAFI tp_KEYSERVAFI;                                        
     lv_CODCLIENTE tp_CODCLIENTE;                                        
     lc_NROTARJETA tp_NROTARJETA;
     ln_KEYTARJETA tp_KEYTARJETA;                                         
     lv_NROCONTRATO tp_NROCONTRATO;                                       
     ld_FECAFILIA tp_FECAFILIA;                                         
     lv_USUAFILIA tp_USUAFILIA;                                         
     ld_FECDESAFIL tp_FECDESAFIL;                                       
     lv_USUDESAFIL tp_USUDESAFIL;                                        
     ln_ESTAFILIA tp_ESTAFILIA;                                         
     lv_CODIGOCUENTA tp_CODIGOCUENTA;
     lv_CUENTAUNICA tp_CUENTAUNICA;      
     
     
  
     
     -- Declaración de otras variables 
     --lv_Fecha varchar2(8) := to_char(PD_FECHA,'RRRRMMDD');

  
  BEGIN
      -- Truncar table de billetaje y tabla de errores
      --execute immediate 'truncate table tmp_fact_op_servafil';
      --execute immediate 'truncate table err$_TMP_FACT_OP_servafil';
      -- Cargar datos en cursor con sentencia select
      Open c_servafil FOR
           -- Seleccionar tabla de billetaje con filtro de fecha (WHERE)
                
           Select 999,
                  PQ_TMP_CARGA_TRANSACC.fn_key_empser(999),
                  990,
                  PQ_TMP_CARGA_TRANSACC.fn_key_servafi(990),
                  TRIM(T.z0e478thp||T.z0e478tht||T.z0e478thd),
                  TRIM(x.jaqy259nutar),
                  PQ_TMP_CARGA_TRANSACC.fn_key_tarjeta(TRIM(JAQY259NUTAR)),
                  X.JAQY259NUTAR,
                  X.JAQY259FEAFI,
                  UPPER(TRIM(X.JAQY259USAFI)),
                  X.JAQY259FEDES,
                  UPPER(TRIM(X.JAQY259USDES)),
                  DECODE(NVL(X.JAQY259HABIL,'N'),'S',1,0),
                  PQ_TMP_CARGA_TRANSACC.fn_codcta(X.JAQY259NUTAR),
                  pq_tmp_carga_transacc.fn_ctauni(x.jaqy259nutar)
              
                  
                             
                  
              fROM DWEXTRA.JAQY259 X
              join DWEXTRA.Z0E478 T
              ON T.Z0E478NRO = X.JAQY259NUTAR;
              
      
      -- Abrir cursor
      LOOP
           FETCH c_servafil  BULK COLLECT INTO   
           -- Listar variables basadas en tip. En el mismo orden que se realizaron en la sentencia SELECT 
                 
            ln_codempser,
            ln_keyempser,
            ln_CODSERVAFI,
            ln_KEYSERVAFI,
            lv_CODCLIENTE,
            lc_NROTARJETA,
            ln_KEYTARJETA,
            lv_NROCONTRATO, 
            ld_FECAFILIA,
            lv_USUAFILIA,
            ld_FECDESAFIL,
            lv_USUDESAFIL,
            ln_ESTAFILIA,
            lv_CODIGOCUENTA,
            lv_CUENTAUNICA      
    
    
      
     
           LIMIT 1000; 
           
           IF ln_codempser.count > 0 THEN                         
              FORALL x IN ln_codempser.FIRST .. ln_codempser.LAST
                 INSERT INTO TMP_FACT_OP_SERVAFIL nologging 
                        (COD_EMPSER,KEY_EMPSER,COD_SERVAFI,KEY_SERVAFI,
                        COD_CLIENTE,NRO_TARJETA,KEY_TARJETA,NRO_CONTRATO,
                        FEC_AFILIA,USU_AFILIA,FEC_DESAFIL,USU_DESAFIL,
                        EST_AFILIA,CODIGO_CUENTA,CUENTA_UNICA)
                         --campos de la tabla
                 VALUES (ln_codempser(x),ln_keyempser(x),ln_CODSERVAFI(x),ln_KEYSERVAFI(x),
                        lv_CODCLIENTE(x),lc_NROTARJETA(x),ln_KEYTARJETA(x),lv_NROCONTRATO(x),
                        ld_FECAFILIA(x),lv_USUAFILIA(x),ld_FECDESAFIL(x),lv_USUDESAFIL(x),
                        ln_ESTAFILIA(x),lv_CODIGOCUENTA(X),lv_CUENTAUNICA(X)) 
                         --variables basada en tipo
              LOG ERRORS INTO Err$_Tmp_Fact_Op_Servafil ('INSERT-'||to_char(sysdate,'yyyymmdd')) REJECT LIMIT UNLIMITED;                                 
                commit;
           END IF;                        
           EXIT WHEN c_servafil%notfound;
        END LOOP;    
        Commit;         
  End ;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function fn_ctauni (Pc_ctauni in char)
                  Return varchar2
                      Is 
                      ln_ctauni varchar2 (30) ; 
                     Begin
    
                     Begin
                   Select case when z0e479mod=21 then 
                   z0e479mod||'-'||z0e479mon||'-'||z0e479cta||'-'||z0e479ope||'-'||z0e479sct||'-'||z0e479top
                  when z0e479mod=22 then
                        z0e479mod||'-'||z0e479mon||'-'||z0e479cta||'-'||z0e479ope
                     else null
                  end 

                  Into ln_ctauni
                  From z0e479@produ b
                  Where (b.z0e478nro) = Rpad(trim(PC_ctauni),19,' ')
                  and z0e480cod = 3;
            Exception When Others Then
                      ln_ctauni := Null;
                  End;
    
    Return ln_ctauni;
End FN_ctauni;
-----------------------------------------------------------------------------------------------------------------------------------------------------
Function fn_codcta (Pc_codcta in char)
Return varchar2
Is 
  ln_codcta varchar2 (30) ; 
Begin
    
    Begin
         Select  
         z0e479mod||'-'||z0e479mon||'-'||z0e479cta||'-'||z0e479ope||'-'||z0e479sct||'-'|| z0e479top
         
   

           Into ln_codcta
           From z0e479@produ b
          Where (b.z0e478NRO) = Rpad(trim(PC_codcta),19,' ')
          and z0e480cod = 3;
    Exception When Others Then
          ln_codcta := Null;
    End;
    
    Return ln_codcta;
End fn_codcta;
------------------------------------------------------------------------------------------------
Procedure sp_tarjeta_coordenadas (PD_FECHA  in date, --Fecha de proceso
                               pc_tipcar in varchar2 --Tipo de carga T:Total / E:Errores
                               )
  --------------------------------------------------------------------------------------
  -- Creación: Tarjeta de Coordenadas
  ---------------------------------------------------------------------------------------
  -- Fecha  : 04 Junio 2018
  -- Autor  : Rafael
  -- Cambios:
  ---------------------------------------------------------------------------------------
  IS
     lv_query varchar2(200);

     TYPE tc_servafil IS REF CURSOR;
     c_servafil tc_servafil;
  
     -- Declaración de tipos de variable (todos los campos de tabla tmp_dm_fact_op_servafil)
     Type tp_CODEMPSER is table of tmp_fact_op_servafil.cod_empser%type;
     Type tp_KEYEMPSER is table of tmp_fact_op_servafil.key_empser%type;
     Type tp_CODSERVAFI is table of tmp_fact_op_servafil.cod_servafi%type;
     Type tp_KEYSERVAFI is table of tmp_fact_op_servafil.key_servafi%type;
     Type tp_CODCLIENTE is table of tmp_fact_op_servafil.cod_cliente%type;
     Type tp_NROTARJETA is table of tmp_fact_op_servafil.nro_tarjeta%type;
     --Type tp_KEYTARJETA is table of tmp_fact_op_servafil.key_tarjeta%type;
     --Type tp_CODIGOCUENTA is table of tmp_fact_op_servafil.codigo_cuenta%type;
     --Type tp_CUENTAUNICA is table of tmp_fact_op_servafil.cuenta_unica%type;
     Type tp_NROCONTRATO is table of tmp_fact_op_servafil.nro_contrato%type;
     Type tp_FECAFILIA is table of tmp_fact_op_servafil.fec_afilia%type;
     Type tp_USUAFILIA is table of tmp_fact_op_servafil.usu_afilia%type;
     Type tp_FECDESAFIL is table of tmp_fact_op_servafil.fec_desafil%type;
     Type tp_USUDESAFIL is table of tmp_fact_op_servafil.usu_desafil%type;
     Type tp_ESTAFILIA is table of tmp_fact_op_servafil.est_afilia%type;

     
     
     -- Declaración de variables en base a tipos declarados 
     ln_codempser tp_codempser;           
     ln_keyempser tp_KEYEMPSER;                              
     ln_CODSERVAFI tp_CODSERVAFI;                                      
     ln_KEYSERVAFI tp_KEYSERVAFI;                                        
     lv_CODCLIENTE tp_CODCLIENTE;                                        
     lc_NROTARJETA tp_NROTARJETA;
     --ln_KEYTARJETA tp_KEYTARJETA;                                        
     --lv_CODIGOCUENTA tp_CODIGOCUENTA;                                      
     --lv_CUENTAUNICA tp_CUENTAUNICA;                                       
     lv_NROCONTRATO tp_NROCONTRATO;                                       
     ld_FECAFILIA tp_FECAFILIA;                                         
     lv_USUAFILIA tp_USUAFILIA;                                         
     ld_FECDESAFIL tp_FECDESAFIL;                                       
     lv_USUDESAFIL tp_USUDESAFIL;                                        
     ln_ESTAFILIA tp_ESTAFILIA;                                         
     
     
     
  
     
     -- Declaración de otras variables 
     --lv_Fecha varchar2(8) := to_char(PD_FECHA,'RRRRMMDD');

  
  BEGIN
      -- Truncar table de billetaje y tabla de errores
      --execute immediate 'truncate table tmp_fact_op_servafil';
      --execute immediate 'truncate table err$_TMP_FACT_OP_servafil';
      -- Cargar datos en cursor con sentencia select
      Open c_servafil FOR
           -- Seleccionar tabla de billetaje con filtro de fecha (WHERE)
                
           Select 999,
                  PQ_TMP_CARGA_TRANSACC.fn_key_empser(999),
                  992,
                  PQ_TMP_CARGA_TRANSACC.fn_key_servafi(992),
                  trim(cnl001pus||cnl001tus||cnl001dus),
                  
                  X.CNL150COD,
                  P.JAQL68FEEM,
                  P.JAQL68USER,
                  CASE WHEN X.CNL151STS = 'C' THEN X.CNL151FCH ELSE NULL END,
                  CASE WHEN X.CNL151STS = 'C' THEN P.JAQL68USER ELSE NULL END,
                 
                  DECODE(nvl(cnl151sts,'C'),'A',1,0),
                  pq_tmp_carga_transacc.fn_TARJCOOR(X.CNL001PUS,X.CNL001TUS,X.CNL001DUS,X.CNL151FCH,X.CNL151STS)
                             
                  
              fROM DWEXTRA.CNL151 X
              join JAQL068@PRODU P ON P.JAQL68TACO = X.CNL150COD;
              
              
             
              
      
      -- Abrir cursor
      LOOP
           FETCH c_servafil  BULK COLLECT INTO   
           -- Listar variables basadas en tip. En el mismo orden que se realizaron en la sentencia SELECT 
                 
            ln_codempser,
            ln_keyempser,
            ln_CODSERVAFI,
            ln_KEYSERVAFI,
            lv_CODCLIENTE,
            --ln_KEYTARJETA,
            --lv_CODIGOCUENTA,
            --lv_CUENTAUNICA, 
            lv_NROCONTRATO, 
            ld_FECAFILIA,
            lv_USUAFILIA,
            ld_FECDESAFIL,
            lv_USUDESAFIL,
            ln_ESTAFILIa,
            lc_NROTARJETA    
    
    
      
     
           LIMIT 1000; 
           
           IF ln_codempser.count > 0 THEN                         
              FORALL x IN ln_codempser.FIRST .. ln_codempser.LAST
                 INSERT INTO TMP_FACT_OP_SERVAFIL nologging 
                        (COD_EMPSER,KEY_EMPSER,COD_SERVAFI,KEY_SERVAFI,
                        COD_CLIENTE,NRO_CONTRATO,
                        FEC_AFILIA,USU_AFILIA,FEC_DESAFIL,USU_DESAFIL,
                        EST_AFILIA,NRO_TARJETA,KEY_TARJETA,CODIGO_CUENTA, CUENTA_UNICA)
                         --campos de la tabla
                 VALUES (ln_codempser(x),ln_keyempser(x),ln_CODSERVAFI(x),ln_KEYSERVAFI(x),
                        lv_CODCLIENTE(x),lv_NROCONTRATO(x),
                        ld_FECAFILIA(x),NVL(UPPER(TRIM(lv_USUAFILIA(x))),'NOREGIS'),ld_FECDESAFIL(x),
                        NVL(UPPER(TRIM(lv_USUDESAFIL(x))),'NOREGIS'),
                        ln_ESTAFILIA(x),lc_NROTARJETA(x),pq_tmp_carga_transacc.fn_key_tarjeta(lc_NROTARJETA(x)),
                        PQ_TMP_CARGA_TRANSACC.fn_codcta(lc_NROTARJETA(X)),
                        PQ_TMP_CARGA_TRANSACC.fn_ctauni(lc_NROTARJETA(X))) 
                         --variables basada en tipo
              LOG ERRORS INTO Err$_Tmp_Fact_Op_Servafil ('INSERT-'||to_char(sysdate,'yyyymmdd')) REJECT LIMIT UNLIMITED;                                 
                commit;
           END IF;                        
           EXIT WHEN c_servafil%notfound;
        END LOOP;    
        Commit;         
  End ;


-----------------------------------------------------------------------------------------------------------------------------------------
Procedure sp_deb_automatico_serv (PD_FECHA  in date, --Fecha de proceso
                               pc_tipcar in varchar2 --Tipo de carga T:Total / E:Errores
                               )
  --------------------------------------------------------------------------------------
  -- Creación:Operaciones por Internet
  ---------------------------------------------------------------------------------------
  -- Fecha  : 04 Junio 2018
  -- Autor  : Rafael
  -- Cambios:
  ---------------------------------------------------------------------------------------
  IS
     lv_query varchar2(200);

     TYPE tc_servafil IS REF CURSOR;
     c_servafil tc_servafil;
  
     -- Declaración de tipos de variable (todos los campos de tabla tmp_dm_fact_op_servafil)
     Type tp_codempser is table of tmp_fact_op_servafil.cod_empser%type;
     Type tp_KEYEMPSER is table of tmp_fact_op_servafil.key_empser%type;
     Type tp_CODSERVAFI is table of tmp_fact_op_servafil.cod_servafi%type;
     Type tp_KEYSERVAFI is table of tmp_fact_op_servafil.key_servafi%type;
     Type tp_CODCLIENTE is table of tmp_fact_op_servafil.cod_cliente%type;
     Type tp_NROTARJETA is table of tmp_fact_op_servafil.nro_tarjeta%type;
     --Type tp_KEYTARJETA is table of tmp_fact_op_servafil.key_tarjeta%type;
     Type tp_CODIGOCUENTA is table of tmp_fact_op_servafil.codigo_cuenta%type;
     Type tp_CUENTAUNICA is table of tmp_fact_op_servafil.cuenta_unica%type;
     Type tp_NROCONTRATO is table of tmp_fact_op_servafil.nro_contrato%type;
     Type tp_FECAFILIA is table of tmp_fact_op_servafil.fec_afilia%type;
     Type tp_USUAFILIA  is table of tmp_fact_op_servafil.usu_afilia%type;
     Type tp_FECDESAFIL is table of tmp_fact_op_servafil.fec_desafil%type;
     Type tp_USUDESAFIL is table of tmp_fact_op_servafil.usu_desafil%type;
     Type tp_ESTAFILIA is table of tmp_fact_op_servafil.est_afilia%type;

     
     
     -- Declaración de variables en base a tipos declarados 
     ln_codempser tp_codempser;
     ln_keyempser tp_KEYEMPSER;                              
     ln_CODSERVAFI tp_CODSERVAFI;                                      
     ln_KEYSERVAFI tp_KEYSERVAFI;                                        
     lv_CODCLIENTE tp_CODCLIENTE;                                        
     lv_CODIGOCUENTA tp_CODIGOCUENTA;                                      
     lv_CUENTAUNICA tp_CUENTAUNICA;                                       
     lv_NROCONTRATO tp_NROCONTRATO;                                       
     ld_FECAFILIA tp_FECAFILIA;                                         
     lv_USUAFILIA tp_USUAFILIA;                                         
     ld_FECDESAFIL tp_FECDESAFIL;                                       
     lv_USUDESAFIL tp_USUDESAFIL;                                        
     ln_ESTAFILIA tp_ESTAFILIA;                                              
     lc_NROTARJETA tp_NROTARJETA; 
     --ln_KEYTARJETA tp_KEYTARJETA;                                       
     
     
     
  
     
     -- Declaración de otras variables 
     --lv_Fecha varchar2(8) := to_char(PD_FECHA,'RRRRMMDD');

  
  BEGIN
      -- Truncar table de billetaje y tabla de errores
      --execute immediate 'truncate table tmp_fact_op_servafil';
      --execute immediate 'truncate table err$_TMP_FACT_OP_servafil';
      -- Cargar datos en cursor con sentencia select
      Open c_servafil FOR
           -- Seleccionar tabla de billetaje con filtro de fecha (WHERE)
                
           Select x.jaql524coent,
                  pq_tmp_carga_transacc.fn_key_empser(x.jaql524coent),
                  x.jaql524cotsv,
                  pq_tmp_carga_transacc.fn_key_servafi(x.jaql524cotsv),
                  (select trim(pepais||petdoc||pendoc) from dwextra.fsr008 u 
                  where u.ctnro=x.jaql524sccta and u.ttcod=1 and u.cttfir='T'),
                  jaql524scmod||'-'||jaql524scmda||'-'||jaql524sccta||'-'||'0'||'-'||jaql524scsbo||'-'|| jaql524sctop,
                  case when jaql524scmod=21 then 
                      jaql524scmod||'-'||jaql524scmda||'-'||jaql524sccta||'-'||'0'||'-'||jaql524scsbo||'-'|| jaql524sctop
                      when jaql524scmod=22 then
                    jaql524scmod||'-'||jaql524scmda||'-'||jaql524sccta||'-'||'0'
                   else null
                  end,
                  x.jaql524nrcon,
                  x.jaql524feafi,
                  x.jaql524usafi,
                  x.jaql524fedes,
                  x.jaql524usdes,
                  decode(nvl(jaql524esreg,'N'),'V',1,0),
                  pq_tmp_carga_transacc.fn_NROTARJ_DEBAUT(jaql524sccta,jaql524scmda,
                  jaql524scsbo,jaql524sctop,jaql524scmod)
                            
                  
              fROM DWEXTRA.JAQL524 X;
              
      
      -- Abrir cursor
      LOOP
           FETCH c_servafil  BULK COLLECT INTO   
           -- Listar variables basadas en tip. En el mismo orden que se realizaron en la sentencia SELECT 
                 
            ln_codempser,
            ln_keyempser,
            ln_CODSERVAFI,
            ln_KEYSERVAFI,
            lv_CODCLIENTE,
            --ln_KEYTARJETA,
            lv_CODIGOCUENTA,
            lv_CUENTAUNICA, 
            lv_NROCONTRATO, 
            ld_FECAFILIA,
            lv_USUAFILIA,
            ld_FECDESAFIL,
            lv_USUDESAFIL,
            ln_ESTAFILIA,
            lc_NROTARJETA     
    
    
      
     
           LIMIT 1000; 
           
           IF ln_codempser.count > 0 THEN                         
              FORALL x IN ln_codempser.FIRST .. ln_codempser.LAST
                 INSERT INTO TMP_FACT_OP_SERVAFIL nologging 
                        (COD_EMPSER,KEY_EMPSER,COD_SERVAFI,KEY_SERVAFI,
                        COD_CLIENTE,CODIGO_CUENTA,CUENTA_UNICA,NRO_CONTRATO,
                        FEC_AFILIA,USU_AFILIA,FEC_DESAFIL,USU_DESAFIL,
                        EST_AFILIA,NRO_TARJETA,KEY_TARJETA)
                         --campos de la tabla
                 VALUES (ln_codempser(x),ln_keyempser(x),ln_CODSERVAFI(x),ln_KEYSERVAFI(x),
                        lv_CODCLIENTE(x),lv_CODIGOCUENTA(x),lv_CUENTAUNICA(x),lv_NROCONTRATO(x),
                        ld_FECAFILIA(x),lv_USUAFILIA(x),ld_FECDESAFIL(x),lv_USUDESAFIL(x),
                        ln_ESTAFILIA(x),lc_NROTARJETA(X),
                        PQ_TMP_CARGA_TRANSACC.fn_key_tarjeta(lc_NROTARJETA(X))) 
                         --variables basada en tipo
              LOG ERRORS INTO Err$_Tmp_Fact_Op_Servafil ('INSERT-'||to_char(sysdate,'yyyymmdd')) REJECT LIMIT UNLIMITED;                                 
                commit;
           END IF;                        
           EXIT WHEN c_servafil%notfound;
        END LOOP;    
        Commit;         
  End ;

-----------------------------------------------------------------------------------------------------
Procedure sp_compras_extranjero (PD_FECHA  in date, --Fecha de proceso
                               pc_tipcar in varchar2 --Tipo de carga T:Total / E:Errores
                               )
  --------------------------------------------------------------------------------------
  -- Creación:Compras en el extranjero
  ---------------------------------------------------------------------------------------
  -- Fecha  : 04 Junio 2018
  -- Autor  : Rafael
  -- Cambios:
  ---------------------------------------------------------------------------------------
  IS
     lv_query varchar2(200);

     TYPE tc_servafil IS REF CURSOR;
     c_servafil tc_servafil;
  
     -- Declaración de tipos de variable (todos los campos de tabla tmp_dm_fact_op_servafil)
     Type tp_codempser is table of tmp_fact_op_servafil.cod_empser%type;
     Type tp_KEYEMPSER is table of tmp_fact_op_servafil.key_empser%type;
     Type tp_CODSERVAFI is table of tmp_fact_op_servafil.cod_servafi%type;
     Type tp_KEYSERVAFI is table of tmp_fact_op_servafil.key_servafi%type;
     Type tp_CODCLIENTE is table of tmp_fact_op_servafil.cod_cliente%type;
     Type tp_NROTARJETA is table of tmp_fact_op_servafil.nro_tarjeta%type;
     Type tp_KEYTARJETA is table of tmp_fact_op_servafil.key_tarjeta%type;
     Type tp_CODIGOCUENTA is table of tmp_fact_op_servafil.codigo_cuenta%type;
     Type tp_CUENTAUNICA is table of tmp_fact_op_servafil.cuenta_unica%type;
     Type tp_NROCONTRATO is table of tmp_fact_op_servafil.nro_contrato%type;
     Type tp_FECAFILIA is table of tmp_fact_op_servafil.fec_afilia%type;
     Type tp_USUAFILIA  is table of tmp_fact_op_servafil.usu_afilia%type;
     Type tp_FECDESAFIL is table of tmp_fact_op_servafil.fec_desafil%type;
     Type tp_USUDESAFIL is table of tmp_fact_op_servafil.usu_desafil%type;
     Type tp_ESTAFILIA is table of tmp_fact_op_servafil.est_afilia%type;

     
     
     -- Declaración de variables en base a tipos declarados 
     ln_codempser tp_codempser;
     ln_keyempser tp_KEYEMPSER;                              
     ln_CODSERVAFI tp_CODSERVAFI;                                      
     ln_KEYSERVAFI tp_KEYSERVAFI;                                        
     lv_CODCLIENTE tp_CODCLIENTE;                                        
     lc_NROTARJETA tp_NROTARJETA;
     ln_KEYTARJETA tp_KEYTARJETA;                                          
     lv_NROCONTRATO tp_NROCONTRATO;                                       
     ld_FECAFILIA tp_FECAFILIA;                                         
     lv_USUAFILIA tp_USUAFILIA;                                         
     ld_FECDESAFIL tp_FECDESAFIL;                                       
     lv_USUDESAFIL tp_USUDESAFIL;                                        
     ln_ESTAFILIA tp_ESTAFILIA; 
     lv_CODIGOCUENTA tp_CODIGOCUENTA;                                      
     lv_CUENTAUNICA tp_CUENTAUNICA;                                         
     
     
     
  
     
     -- Declaración de otras variables 
     --lv_Fecha varchar2(8) := to_char(PD_FECHA,'RRRRMMDD');

  
  BEGIN
      -- Truncar table de billetaje y tabla de errores
      --execute immediate 'truncate table tmp_fact_op_servafil';
      --execute immediate 'truncate table err$_TMP_FACT_OP_servafil';
      -- Cargar datos en cursor con sentencia select
      Open c_servafil FOR
           -- Seleccionar tabla de billetaje con filtro de fecha (WHERE)
                
           Select 999,
                  pq_tmp_carga_transacc.fn_key_empser(999),
                  991,
                  pq_tmp_carga_transacc.fn_key_servafi(991),
                  trim(T.z0e478thp||T.z0e478tht||T.z0e478thd),
                  x.jaqy572nutar,
                  pq_tmp_carga_transacc.fn_key_tarjeta(x.jaqy572nutar),
                  x.jaqy572nutar,
                  x.jaqy572feafi,
                  nvl(TRIM(x.jaqy572usafi),'NOREGIS'),
                  x.jaqy572fedes,
                  nvl(TRIM (x.jaqy572usdes),'NOREGIS'),
                  DECODE(nvl(JAQY572habil,'N'),'S',1,0),
                  PQ_TMP_CARGA_TRANSACC.fn_codcta(X.JAQY572NUTAR),
                  PQ_TMP_CARGA_TRANSACC.fn_ctauni(X.JAQY572NUTAR)
                  
                  
                  
                             
                  
              fROM DWEXTRA.JAQY572 X
              join DWEXTRA.Z0E478 T
              ON T.Z0E478NRO = x.jaqy572nutar;
              
      
      -- Abrir cursor
      LOOP
           FETCH c_servafil  BULK COLLECT INTO   
           -- Listar variables basadas en tip. En el mismo orden que se realizaron en la sentencia SELECT 
                 
            ln_codempser,
            ln_keyempser,
            ln_CODSERVAFI,
            ln_KEYSERVAFI,
            lv_CODCLIENTE,
            lc_NROTARJETA,
            ln_KEYTARJETA, 
            lv_NROCONTRATO, 
            ld_FECAFILIA,
            lv_USUAFILIA,
            ld_FECDESAFIL,
            lv_USUDESAFIL,
            ln_ESTAFILIA,            
            lv_CODIGOCUENTA,
            lv_CUENTAUNICA     
    
    
      
     
           LIMIT 1000; 
           
           IF ln_codempser.count > 0 THEN                         
              FORALL x IN ln_codempser.FIRST .. ln_codempser.LAST
                 INSERT INTO TMP_FACT_OP_SERVAFIL nologging 
                        (COD_EMPSER,KEY_EMPSER,COD_SERVAFI,KEY_SERVAFI,
                        COD_CLIENTE,NRO_TARJETA,KEY_TARJETA,NRO_CONTRATO,
                        FEC_AFILIA,USU_AFILIA,FEC_DESAFIL,USU_DESAFIL,
                        EST_AFILIA,CODIGO_CUENTA,CUENTA_UNICA)
                         --campos de la tabla
                 VALUES (ln_codempser(x),ln_keyempser(x),ln_CODSERVAFI(x),ln_KEYSERVAFI(x),
                        lv_CODCLIENTE(x),lc_NROTARJETA(x),ln_KEYTARJETA(x),lv_NROCONTRATO(x),
                        ld_FECAFILIA(x),lv_USUAFILIA(x),ld_FECDESAFIL(x),lv_USUDESAFIL(x),
                        ln_ESTAFILIA(x),lv_CODIGOCUENTA(X),lv_CUENTAUNICA(X)) 
                         --variables basada en tipo
              LOG ERRORS INTO Err$_Tmp_Fact_Op_Servafil ('INSERT-'||to_char(sysdate,'yyyymmdd')) REJECT LIMIT UNLIMITED;                                 
                commit;
           END IF;                        
           EXIT WHEN c_servafil%notfound;
        END LOOP;    
        Commit;         
  End ;

-----------------------------------------------------------------------------------------------------------------------------
Function fn_NROTARJ_DEBAUT (PN_SCCTA IN NUMBER,
                            PN_SCMDA IN NUMBER,
                            PN_SCSBO IN NUMBER,
                            PN_SCTOP IN NUMBER,
                            PN_SCMOD IN NUMBER
                            )
Return varchar2
Is
  ln_NROTDEB varchar2 (30) ;
Begin

    Begin
         Select
            b.z0e478NRO



           Into ln_NROTDEB
           From z0e479@produ b
        Where B.z0e479cta = PN_SCCTA
          and B.z0e479mon = PN_SCMDA
          and B.z0e479sct = PN_SCSBO
          and B.z0e479top = PN_SCTOP
          and B.z0e479mod = PN_SCMOD
         
           AND B.z0e479est = 'AC'
          and z0e480cod = 3;
    Exception When Others Then
          ln_NROTDEB := Null;
    End;
    
    If ln_NROTDEB Is Null Then
        -- Si no existe tarjeta activa
    begin
          Select max(z0e478nro) 
          into ln_NROTDEB
          from z0e479@produ v 
      where v.z0e479cta = pn_sccta 
        and v.z0e479mon = pn_scmda 
        and v.z0e479sct = pn_scsbo
        and v.z0e479top = pn_sctop 
        and v.z0e479mod = pn_scmod;
    Exception when others then
        ln_NROTDEB := Null;
    End;
end if;
    Return ln_NROTDEB;
End fn_NROTARJ_DEBAUT;

---------------------------------------------------------------------------------
Function fn_TARJCOOR (PN_PAIS in NUMBER,
                     PN_TDOC IN NUMBER,
                     PC_NDOC IN CHAR,
                     PD_FINI IN DATE,
                     PD_FFIN IN DATE)
   Return varchar2
   Is 
   ln_TARJ varchar2 (30) ; 
      
Begin
    
         Select * Into ln_TARJ
         From ( 
         Select k.z0e478nro 
         From dwextra.z0e478 k 
         Where k.z0e478thp = PN_PAIS
         and k.z0e478tht = PN_TDOC
         and k.z0e478thd = PC_NDOC
         and k.z0e478fal between PD_FINI and PD_FFIN  --fecha de alta de coordenadas y fecha de expiracion
         order by k.z0e478fal desc 
         ) where rownum=1;

         Return ln_TARJ;

Exception When Others Then
         RETURN Null;
                      
            
End FN_TARJCOOR;
---------------------------------------------------------------------------------------------------
Function fn_TARJCOOR (PN_PAIS in NUMBER,
                     PN_TDOC IN NUMBER,
                     PC_NDOC IN CHAR,
                     PD_FEST IN DATE,
                     PC_ESTA IN CHAR
                     )
   Return varchar2
   Is 
   ln_TARJ varchar2 (30) ; 
      
Begin

     IF PC_ESTA = 'C' THEN 
    
       BEGIN 
         Select MAX (k.z0e478nro)
         INTO ln_TARJ 
         From dwextra.z0e478 k 
         Where k.z0e478thp = PN_PAIS
         and k.z0e478tht = PN_TDOC
         and k.z0e478thd = PC_NDOC
         and k.z0e478fal <=PD_FEST;
       
       Exception When Others Then
         ln_TARJ:= Null;
         
         END;
         
         ELSE 
         
         
       BEGIN
         Select MAX (k.z0e478nro)
         INTO ln_TARJ 
         From dwextra.z0e478 k 
         Where k.z0e478thp = PN_PAIS
         and k.z0e478tht = PN_TDOC
         and k.z0e478thd = PC_NDOC;

       Exception When Others Then
         ln_TARJ:= Null;
         
         END;
      end if;
         Return ln_TARJ;

                      
            
End FN_TARJCOOR;
-----------------------------------------------------------------------------------------------------
Function fn_CODCLIENTE (Pn_codcta in number)
Return varchar2
Is 
  ln_codcli varchar2 (30) ; 
Begin
    
    Begin
        
        
         Select trim(c.pepais||c.petdoc||c.pendoc)
         
          Into ln_codcli
          From dwextra.fsr008 c
          Where c.ctnro = Pn_codcta   
          and c.ttcod = 1
          and c.cttfir= 'T'; 

         
    Exception When Others Then
          ln_codcli := Null;
    End;
    
    Return ln_codcli;
End fn_CODCLIENTE;
---------------------------------------------------------------------------------------------------------
Function fn_fechafil (Pn_mod in number, 
                     pn_mon in number,
                     pn_cta in number,
                     pn_ope in number,
                     pn_sub in number,
                     pn_top in number)
Return date
Is 
  ld_fecha varchar2 (30) ; 
Begin
    
    Begin
        
        
         Select d.aofval
                Into ld_fecha
                from dwstage.tmp_dm_credito d
                where d.aomod =pn_mod
                      and d.aomda = pn_mon
                      and d.aocta = pn_cta
                      and d.aoope = pn_ope
                      and d.aosbo = pn_sub
                      and d.aotop = pn_top;
          

         
    Exception When Others Then
          ld_fecha := Null;
    End;
    
    Return ld_fecha;
End fn_fechafil;

-----------------------------------------------------------------------------------------------------------
Procedure SP_CUENTA_COBRANZA (PD_FECHA  in date, --Fecha de proceso
                               pc_tipcar in varchar2 --Tipo de carga T:Total / E:Errores
                               )
  --------------------------------------------------------------------------------------
  -- Creación: Cuentas para Cobranza para Prestamos
  ---------------------------------------------------------------------------------------
  -- Fecha  : 18 Junio 2018
  -- Autor  : Rafael
  -- Cambios:
  
  ---------------------------------------------------------------------------------------
  IS
     lv_query varchar2(200);

     TYPE tc_servafil IS REF CURSOR;
     c_servafil tc_servafil;
  
     -- Declaración de tipos de variable (todos los campos de tabla tmp_dm_fact_op_servafil)
     Type tp_codempser is table of tmp_fact_op_servafil.cod_empser%type;
     Type tp_KEYEMPSER is table of tmp_fact_op_servafil.key_empser%type;
     Type tp_CODSERVAFI is table of tmp_fact_op_servafil.cod_servafi%type;
     Type tp_KEYSERVAFI is table of tmp_fact_op_servafil.key_servafi%type;
     Type tp_CODCLIENTE is table of tmp_fact_op_servafil.cod_cliente%type;
     Type tp_NROTARJETA is table of tmp_fact_op_servafil.nro_tarjeta%type;
     Type tp_KEYTARJETA is table of tmp_fact_op_servafil.key_tarjeta%type;
     Type tp_CODIGOCUENTA is table of tmp_fact_op_servafil.codigo_cuenta%type;
     Type tp_CUENTAUNICA is table of tmp_fact_op_servafil.cuenta_unica%type;
     Type tp_NROCONTRATO is table of tmp_fact_op_servafil.nro_contrato%type;
     Type tp_FECAFILIA is table of tmp_fact_op_servafil.fec_afilia%type;
     Type tp_USUAFILIA  is table of tmp_fact_op_servafil.usu_afilia%type;
     Type tp_FECDESAFIL is table of tmp_fact_op_servafil.fec_desafil%type;
     Type tp_USUDESAFIL is table of tmp_fact_op_servafil.usu_desafil%type;
     Type tp_ESTAFILIA is table of tmp_fact_op_servafil.est_afilia%type;

     
     
     -- Declaración de variables en base a tipos declarados 
     ln_codempser tp_codempser;
     ln_keyempser tp_KEYEMPSER;                              
     ln_CODSERVAFI tp_CODSERVAFI;                                      
     ln_KEYSERVAFI tp_KEYSERVAFI;                                        
     lv_CODCLIENTE tp_CODCLIENTE;                                        
     lc_NROTARJETA tp_NROTARJETA;
     ln_KEYTARJETA tp_KEYTARJETA;                                         
     lv_NROCONTRATO tp_NROCONTRATO;                                       
     ld_FECAFILIA tp_FECAFILIA;                                         
     lv_USUAFILIA tp_USUAFILIA;                                         
     ld_FECDESAFIL tp_FECDESAFIL;                                       
     lv_USUDESAFIL tp_USUDESAFIL;                                        
     ln_ESTAFILIA tp_ESTAFILIA;                                         
     lv_CODIGOCUENTA tp_CODIGOCUENTA;
     lv_CUENTAUNICA tp_CUENTAUNICA;      
     
     
  
     
     -- Declaración de otras variables 
     --lv_Fecha varchar2(8) := to_char(PD_FECHA,'RRRRMMDD');

  
  BEGIN
      -- Truncar table de billetaje y tabla de errores
      --execute immediate 'truncate table tmp_fact_op_servafil';
      --execute immediate 'truncate table err$_TMP_FACT_OP_servafil';
      -- Cargar datos en cursor con sentencia select
      Open c_servafil FOR
           -- Seleccionar tabla de billetaje con filtro de fecha (WHERE)
              
           Select 999,
                  PQ_TMP_CARGA_TRANSACC.fn_key_empser(999),
                  993,
                  PQ_TMP_CARGA_TRANSACC.fn_key_servafi(993),
                  PQ_TMP_CARGA_TRANSACC.fn_CODCLIENTE(F.PP4CTA),
                  pq_tmp_carga_transacc.fn_NROTARJ_DEBAUT(f.pp4cta,f.pp4mda,f.pp4sbop,f.pp4tope,f.pp4mod),
                  f.pp4mod||'-'||f.pp4mda||'-'||f.pp4cta||'-'||'0'||'-'||f.pp4sbop||'-'||f.pp4tope,
                  case when f.pp4mod=21 then 
                      f.pp4mod||'-'||f.pp4mda||'-'||f.pp4cta||'-'||'0'||'-'||f.pp4sbop||'-'||f.pp4tope
                      when f.pp4mod=22 then
                    f.pp4mod||'-'||f.pp4mda||'-'||f.pp4cta||'-'||'0'
                   else null
                  end,
                 f.pp3mod||'-'||f.pp3suc||'-'||f.pp3cta||'-'||f.pp3mda||'-'||f.pp3oper||'-'||f.pp3sbop||'-'||f.pp3tope,
                 pq_tmp_carga_transacc.fn_fechafil(f.pp3mod,f.pp3mda,f.pp3cta,f.pp3oper,f.pp3sbop,f.pp3tope),
                 'NOREGIS',
                 NULL,
                 'NOREGIS',
                 1
              fROM DWEXTRA.FSR601 f;
      -- Abrir cursor
      LOOP
           FETCH c_servafil  BULK COLLECT INTO   
           -- Listar variables basadas en tip. En el mismo orden que se realizaron en la sentencia SELECT 
                 
            ln_codempser,
            ln_keyempser,
            ln_CODSERVAFI,
            ln_KEYSERVAFI,
            lv_CODCLIENTE,
            lc_NROTARJETA,
            --ln_KEYTARJETA,
            lv_CODIGOCUENTA,
            lv_CUENTAUNICA,
            lv_NROCONTRATO, 
            ld_FECAFILIA,
            lv_USUAFILIA,
            ld_FECDESAFIL,
            lv_USUDESAFIL,
            ln_ESTAFILIA
                  
    
     
           LIMIT 1000; 
           
           IF ln_codempser.count > 0 THEN                         
              FORALL x IN ln_codempser.FIRST .. ln_codempser.LAST
                 INSERT INTO TMP_FACT_OP_SERVAFIL nologging 
                        (cod_empser,key_empser,cod_servafi,
                         key_servafi,cod_cliente,nro_tarjeta,
                         key_tarjeta,codigo_cuenta,cuenta_unica,
                         nro_contrato, fec_afilia,usu_afilia,
                         fec_desafil,usu_desafil,est_afilia)
                         --campos de la tabla
                 VALUES (ln_codempser(x),ln_keyempser(x),ln_CODSERVAFI(x),
                         ln_KEYSERVAFI(x),
                         lv_CODCLIENTE(X),lc_NROTARJETA(x),
                         pq_tmp_carga_transacc.fn_key_tarjeta(lc_NROTARJETA(x)),
                         lv_CODIGOCUENTA(x),
                         lv_CUENTAUNICA(x),lv_NROCONTRATO(x),ld_FECAFILIA(x),
                         lv_USUAFILIA(x),
                         ld_FECDESAFIL(x),lv_USUDESAFIL(x),ln_ESTAFILIA(x)) 
                         --variables basada en tipo
              LOG ERRORS INTO Err$_Tmp_Fact_Op_Servafil ('INSERT-'||to_char(sysdate,'yyyymmdd')) REJECT LIMIT UNLIMITED;                                 
                commit;
           END IF;                        
           EXIT WHEN c_servafil%notfound;
        END LOOP;    
        Commit;         
  End ;

------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Procedure SP_Afil_Desafil_Tarjeta (PD_FECHA  in date, --Fecha de proceso
                               pc_tipcar in varchar2 --Tipo de carga T:Total / E:Errores
                               )
  --------------------------------------------------------------------------------------
  -- Creación:Afiliacion/Desafiliacion Uso Tarjeta
  ---------------------------------------------------------------------------------------
  -- Fecha  : 18 Junio 2018
  -- Autor  : Rafael
  -- Cambios:
  
  ---------------------------------------------------------------------------------------
  IS
     lv_query varchar2(200);

     TYPE tc_servafil IS REF CURSOR;
     c_servafil tc_servafil;
  
     -- Declaración de tipos de variable (todos los campos de tabla tmp_dm_fact_op_servafil)
     Type tp_codempser is table of tmp_fact_op_servafil.cod_empser%type;
     Type tp_KEYEMPSER is table of tmp_fact_op_servafil.key_empser%type;
     Type tp_CODSERVAFI is table of tmp_fact_op_servafil.cod_servafi%type;
     Type tp_KEYSERVAFI is table of tmp_fact_op_servafil.key_servafi%type;
     Type tp_CODCLIENTE is table of tmp_fact_op_servafil.cod_cliente%type;
     Type tp_NROTARJETA is table of tmp_fact_op_servafil.nro_tarjeta%type;
     Type tp_KEYTARJETA is table of tmp_fact_op_servafil.key_tarjeta%type;
     Type tp_CODIGOCUENTA is table of tmp_fact_op_servafil.codigo_cuenta%type;
     Type tp_CUENTAUNICA is table of tmp_fact_op_servafil.cuenta_unica%type;
     Type tp_NROCONTRATO is table of tmp_fact_op_servafil.nro_contrato%type;
     Type tp_FECAFILIA is table of tmp_fact_op_servafil.fec_afilia%type;
     Type tp_USUAFILIA  is table of tmp_fact_op_servafil.usu_afilia%type;
     Type tp_FECDESAFIL is table of tmp_fact_op_servafil.fec_desafil%type;
     Type tp_USUDESAFIL is table of tmp_fact_op_servafil.usu_desafil%type;
     Type tp_ESTAFILIA is table of tmp_fact_op_servafil.est_afilia%type;

     
     
     -- Declaración de variables en base a tipos declarados 
     ln_codempser tp_codempser;
     ln_keyempser tp_KEYEMPSER;                              
     ln_CODSERVAFI tp_CODSERVAFI;                                      
     ln_KEYSERVAFI tp_KEYSERVAFI; 
     lc_NROTARJETA tp_NROTARJETA;
     lv_CODIGOCUENTA tp_CODIGOCUENTA;
     lv_CUENTAUNICA tp_CUENTAUNICA;                                       
     lv_CODCLIENTE tp_CODCLIENTE;                                  
     --ln_KEYTARJETA tp_KEYTARJETA;                                         
     lv_NROCONTRATO tp_NROCONTRATO;                                       
     ld_FECAFILIA tp_FECAFILIA;                                         
     lv_USUAFILIA tp_USUAFILIA;                                         
     ld_FECDESAFIL tp_FECDESAFIL;                                       
     lv_USUDESAFIL tp_USUDESAFIL;                                        
     ln_ESTAFILIA tp_ESTAFILIA;                                         
           
     
     
  
     
     -- Declaración de otras variables 
     --lv_Fecha varchar2(8) := to_char(PD_FECHA,'RRRRMMDD');

  
  BEGIN
      -- Truncar table de billetaje y tabla de errores
      --execute immediate 'truncate table tmp_fact_op_servafil';
      --execute immediate 'truncate table err$_TMP_FACT_OP_servafil';
      -- Cargar datos en cursor con sentencia select
      Open c_servafil FOR
           -- Seleccionar tabla de billetaje con filtro de fecha (WHERE)
            /*           cod_empser,key_empser,cod_servafi,
                         key_servafi,cod_cliente,nro_tarjeta,
                         key_tarjeta,codigo_cuenta,cuenta_unica,
                         nro_contrato, fec_afilia,usu_afilia,
                         fec_desafil,usu_desafil,est_afilia */
            
              
           Select 999,
                  PQ_TMP_CARGA_TRANSACC.fn_key_empser(999),
                  995,
                  PQ_TMP_CARGA_TRANSACC.fn_key_servafi(995),
                  pq_tmp_carga_transacc.fn_NROTARJ_DEBAUT(Q.JAQY660CTA,Q.JAQY660MDA,Q.JAQY660SUB,Q.JAQY660TOP,Q.JAQY660MOD),
                  Q.JAQY660MOD||'-'||Q.JAQY660MDA||'-'||Q.JAQY660CTA||'-'||'0'||'-'||Q.JAQY660SUB||'-'||Q.JAQY660TOP,
                  case when Q.JAQY660MOD=21 then 
                      Q.JAQY660MOD||'-'||Q.JAQY660MDA||'-'||Q.JAQY660CTA||'-'||'0'||'-'||Q.JAQY660SUB||'-'||Q.JAQY660TOP
                      when Q.JAQY660MOD=22 then
                    Q.JAQY660MOD||'-'||Q.JAQY660MDA||'-'||Q.JAQY660CTA||'-'||'0'
                   else null
                  end,
                  PQ_TMP_CARGA_TRANSACC.fn_CODCLIENTE(Q.JAQY660CTA),
                 Q.JAQY660AUX1,
                 Q.JAQY660FCH,
                 TRIM(UPPER(Q.JAQY660USU)),
                 Q.JAQY660FDE,
                 TRIM(UPPER(Q.JAQY660UDE)),
                 1
                                 
                  
                  
                
              fROM DWEXTRA.JAQY660 Q;
              
      
      -- Abrir cursor
      LOOP
           FETCH c_servafil  BULK COLLECT INTO   
           -- Listar variables basadas en tip. En el mismo orden que se realizaron en la sentencia SELECT 
                 
            ln_codempser,
            ln_keyempser,
            ln_CODSERVAFI,
            ln_KEYSERVAFI,
            
            lc_NROTARJETA,
            --ln_KEYTARJETA,
            lv_CODIGOCUENTA,
            lv_CUENTAUNICA,
            lv_CODCLIENTE,
            lv_NROCONTRATO, 
            ld_FECAFILIA,
            lv_USUAFILIA,
            ld_FECDESAFIL,
            lv_USUDESAFIL,
            ln_ESTAFILIA
                  
    
     
           LIMIT 1000; 
           
           IF ln_codempser.count > 0 THEN                         
              FORALL x IN ln_codempser.FIRST .. ln_codempser.LAST
                 INSERT INTO TMP_FACT_OP_SERVAFIL nologging 
                        (cod_empser,key_empser,cod_servafi,
                         key_servafi,nro_tarjeta,
                         key_tarjeta,codigo_cuenta,cuenta_unica,cod_cliente,
                         nro_contrato, fec_afilia,usu_afilia,
                         fec_desafil,usu_desafil,est_afilia)
                         --campos de la tabla
                 VALUES (ln_codempser(x),ln_keyempser(x),ln_CODSERVAFI(x),
                         ln_KEYSERVAFI(x),
                         lc_NROTARJETA(x),
                         pq_tmp_carga_transacc.fn_key_tarjeta(lc_NROTARJETA(x)),
                         lv_CODIGOCUENTA(x),
                         lv_CUENTAUNICA(x),
                         LV_CODCLIENTE(X),lv_NROCONTRATO(x),ld_FECAFILIA(x),
                         lv_USUAFILIA(x),
                         ld_FECDESAFIL(x),lv_USUDESAFIL(x),ln_ESTAFILIA(x)) 
                         --variables basada en tipo
              LOG ERRORS INTO Err$_Tmp_Fact_Op_Servafil ('INSERT-'||to_char(sysdate,'yyyymmdd')) REJECT LIMIT UNLIMITED;                                 
                commit;
           END IF;                        
           EXIT WHEN c_servafil%notfound;
        END LOOP;    
        Commit;         
  End ;

------------------------------------------------------------------------------------------------------------------
Procedure SP_AFIL_DESAFIL_GUARDADITO (PD_FECHA  in date, --Fecha de proceso
                               pc_tipcar in varchar2 --Tipo de carga T:Total / E:Errores
                               )
  --------------------------------------------------------------------------------------
  -- Creación:Afiliacion desafiliacion guardadito
  ---------------------------------------------------------------------------------------
  -- Fecha  : 18 Junio 2018
  -- Autor  : Rafael
  -- Cambios:
  
  ---------------------------------------------------------------------------------------
  IS
     lv_query varchar2(200);

     TYPE tc_servafil IS REF CURSOR;
     c_servafil tc_servafil;
  
     -- Declaración de tipos de variable (todos los campos de tabla tmp_dm_fact_op_servafil)
     Type tp_codempser is table of tmp_fact_op_servafil.cod_empser%type;
     Type tp_KEYEMPSER is table of tmp_fact_op_servafil.key_empser%type;
     Type tp_CODSERVAFI is table of tmp_fact_op_servafil.cod_servafi%type;
     Type tp_KEYSERVAFI is table of tmp_fact_op_servafil.key_servafi%type;
     Type tp_CODCLIENTE is table of tmp_fact_op_servafil.cod_cliente%type;
     Type tp_NROTARJETA is table of tmp_fact_op_servafil.nro_tarjeta%type;
     Type tp_KEYTARJETA is table of tmp_fact_op_servafil.key_tarjeta%type;
     Type tp_CODIGOCUENTA is table of tmp_fact_op_servafil.codigo_cuenta%type;
     Type tp_CUENTAUNICA is table of tmp_fact_op_servafil.cuenta_unica%type;
     Type tp_NROCONTRATO is table of tmp_fact_op_servafil.nro_contrato%type;
     Type tp_FECAFILIA is table of tmp_fact_op_servafil.fec_afilia%type;
     Type tp_USUAFILIA  is table of tmp_fact_op_servafil.usu_afilia%type;
     Type tp_FECDESAFIL is table of tmp_fact_op_servafil.fec_desafil%type;
     Type tp_USUDESAFIL is table of tmp_fact_op_servafil.usu_desafil%type;
     Type tp_ESTAFILIA is table of tmp_fact_op_servafil.est_afilia%type;

     
     
     -- Declaración de variables en base a tipos declarados 
     ln_codempser tp_codempser;
     ln_keyempser tp_KEYEMPSER;                              
     ln_CODSERVAFI tp_CODSERVAFI;                                      
     ln_KEYSERVAFI tp_KEYSERVAFI;                                        
     lv_CODCLIENTE tp_CODCLIENTE;                                        
     lc_NROTARJETA tp_NROTARJETA;
     --ln_KEYTARJETA tp_KEYTARJETA;                                         
     lv_NROCONTRATO tp_NROCONTRATO;                                       
     ld_FECAFILIA tp_FECAFILIA;                                         
     lv_USUAFILIA tp_USUAFILIA;                                         
     ld_FECDESAFIL tp_FECDESAFIL;                                       
     lv_USUDESAFIL tp_USUDESAFIL;                                        
     ln_ESTAFILIA tp_ESTAFILIA;                                         
     lv_CODIGOCUENTA tp_CODIGOCUENTA;
     lv_CUENTAUNICA tp_CUENTAUNICA;      
     
     
  
     
     -- Declaración de otras variables 
     --lv_Fecha varchar2(8) := to_char(PD_FECHA,'RRRRMMDD');

  
  BEGIN
      -- Truncar table de billetaje y tabla de errores
      --execute immediate 'truncate table tmp_fact_op_servafil';
      --execute immediate 'truncate table err$_TMP_FACT_OP_servafil';
      -- Cargar datos en cursor con sentencia select
      Open c_servafil FOR
           -- Seleccionar tabla de billetaje con filtro de fecha (WHERE)
            /*           cod_empser,key_empser,cod_servafi,
                         key_servafi,cod_cliente,nro_tarjeta,
                         key_tarjeta,codigo_cuenta,cuenta_unica,
                         nro_contrato, fec_afilia,usu_afilia,
                         fec_desafil,usu_desafil,est_afilia */
            
              
           Select 999,
                  PQ_TMP_CARGA_TRANSACC.fn_key_empser(999),
                  994,
                  PQ_TMP_CARGA_TRANSACC.fn_key_servafi(994),
                  TRIM(J.JAQZ157PAI||J.JAQZ157TPO||J.JAQZ157NUM),
                  pq_tmp_carga_transacc.fn_NROTARJ_DEBAUT(j.jaqz157cta,j.jaqz157mda,j.jaqz157sub,j.jaqz157top,j.jaqz157mod),
                  j.jaqz157mod||'-'||j.jaqz157mda||'-'||j.jaqz157cta||'-'||'0'||'-'||j.jaqz157sub||'-'||j.jaqz157top,
                  case when j.jaqz157mod=21 then 
                      j.jaqz157mod||'-'||j.jaqz157mda||'-'||j.jaqz157cta||'-'||'0'||'-'||j.jaqz157sub||'-'||j.jaqz157top
                      when j.jaqz157mod=22 then
                    j.jaqz157mod||'-'||j.jaqz157mda||'-'||j.jaqz157cta||'-'||'0'
                   else null
                  end,
                 j.jaqz157opg||'-'||j.jaqz157ctg||'-'||j.jaqz157sbg,
                 j.jaqz157faf,
                 TRIM(UPPER(j.jaqz157usa)),
                 j.jaqz157fdf,
                 TRIM(UPPER(j.jaqz157usd)),
                 CASE WHEN J.JAQZ157USD IS NOT NULL THEN 0 ELSE 1 END
                                 
                  
                  
                
              fROM DWEXTRA.JAQZ157 J;
              
      
      -- Abrir cursor
      LOOP
           FETCH c_servafil  BULK COLLECT INTO   
           -- Listar variables basadas en tip. En el mismo orden que se realizaron en la sentencia SELECT 
                 
            ln_codempser,
            ln_keyempser,
            ln_CODSERVAFI,
            ln_KEYSERVAFI,
            lv_CODCLIENTE,
            lc_NROTARJETA,
            --ln_KEYTARJETA,
            lv_CODIGOCUENTA,
            lv_CUENTAUNICA,
            lv_NROCONTRATO, 
            ld_FECAFILIA,
            lv_USUAFILIA,
            ld_FECDESAFIL,
            lv_USUDESAFIL,
            ln_ESTAFILIA
                  
    
     
           LIMIT 1000; 
           
           IF ln_codempser.count > 0 THEN                         
              FORALL x IN ln_codempser.FIRST .. ln_codempser.LAST
                 INSERT INTO TMP_FACT_OP_SERVAFIL nologging 
                        (cod_empser,key_empser,cod_servafi,
                         key_servafi,cod_cliente,nro_tarjeta,
                         key_tarjeta,codigo_cuenta,cuenta_unica,
                         nro_contrato, fec_afilia,usu_afilia,
                         fec_desafil,usu_desafil,est_afilia)
                         --campos de la tabla
                 VALUES (ln_codempser(x),ln_keyempser(x),ln_CODSERVAFI(x),
                         ln_KEYSERVAFI(x),
                         LV_CODCLIENTE(X), lc_NROTARJETA(x),
                         pq_tmp_carga_transacc.fn_key_tarjeta(lc_NROTARJETA(x)),
                         lv_CODIGOCUENTA(x),
                         lv_CUENTAUNICA(x),lv_NROCONTRATO(x),ld_FECAFILIA(x),
                         lv_USUAFILIA(x),
                         ld_FECDESAFIL(x),lv_USUDESAFIL(x),ln_ESTAFILIA(x)) 
                         --variables basada en tipo
              LOG ERRORS INTO Err$_Tmp_Fact_Op_Servafil ('INSERT-'||to_char(sysdate,'yyyymmdd')) REJECT LIMIT UNLIMITED;                                 
                commit;
           END IF;                        
           EXIT WHEN c_servafil%notfound;
        END LOOP;    
        Commit;         
  End ;

-----------------------------------------------------------------------------------------------
Procedure SP_TMP_DM_TIPOMOV 
  Is
  Begin
        MERGE INTO TMP_DM_TIPOMOV T
           USING (Select 1 codigo, 'Efectivo' descri From Dual
                 Union All
                 Select 2 codigo, 'No Efectivo' descri From Dual) x 
              ON (T.KEY_TIPOMOV = X.CODIGO)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET T.DES_TIPOMOV = X.DESCRI
      WHEN NOT MATCHED THEN
                       INSERT (T.KEY_TIPOMOV,T.DES_TIPOMOV)
                       VALUES(X.CODIGO,X.DESCRI)
      LOG ERRORS INTO Err$_Tmp_Dm_TIPOMOV('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                        
                                             
End SP_TMP_DM_TIPOMOV;
-----------------------------------------------------------------------------------------------
Procedure SP_TMP_DM_INGEGR 
  Is
  Begin
        MERGE INTO TMP_DM_INGEGR I
           USING (Select 1 codigo, 'Ingreso' descri From Dual
                 Union All
                 Select 2 codigo, 'Egreso' descri From Dual) x 
              ON (I.KEY_INGEGR = X.CODIGO)
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET I.DES_INGEGR = X.DESCRI
      WHEN NOT MATCHED THEN
                       INSERT (I.KEY_INGEGR,I.DES_INGEGR)
                       VALUES(X.CODIGO,X.DESCRI)
      LOG ERRORS INTO Err$_Tmp_Dm_INGEGR('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                        
                                             
End SP_TMP_DM_INGEGR;
---------------------------------------------------------------------------------

Procedure SP_TMP_DM_CANAL
Is
   LN_KEYCAN NUMBER(10);
BEGIN
        SELECT NVL(MAX(key_canal),0) INTO LN_KEYCAN FROM TMP_DM_CANAL;
        MERGE INTO TMP_DM_CANAL t
            USING (select 1 KEY_CANAL,'AGENCIA' DETCAN, 'AGE' ABR_CANAL, 1 COD_CANAL, 'AGENCIA' DES_CANAL, 1 COD_TICAN, 'PROPIO' DES_TCAN from dual  
                   union all 
                   select 5 KEY_CANAL,'AGENTE' DETCAN, 'AGT' ABR_CANAL, 2 COD_CANAL, 'AGENTE' DES_CANAL, 1 COD_TICAN, 'PROPIO' DES_TCAN from dual
                   union all 
                   select 6 KEY_CANAL,'KASNET' DETCAN, 'KNE' ABR_CANAL, 2 COD_CANAL, 'AGENTE' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual
                   union all 
                   select 13 KEY_CANAL,'WESTERN UNION' DETCAN, 'WUN' ABR_CANAL, 2 COD_CANAL, 'AGENTE' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual
                   union all 
                   select 2 KEY_CANAL,'RED PROPIA' DETCAN, 'RPRO' ABR_CANAL, 3 COD_CANAL, 'ATM' DES_CANAL, 1 COD_TICAN, 'PROPIO' DES_TCAN from dual
                   union all 
                   select 14 KEY_CANAL,'VISA EXTRANJERO' DETCAN, 'VEXT' ABR_CANAL, 3 COD_CANAL, 'ATM' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual      
                   union all 
                   select 15 KEY_CANAL,'GLOBALNET' DETCAN, 'GNE' ABR_CANAL, 3 COD_CANAL, 'ATM' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual   
                   union all 
                   select 3 KEY_CANAL,'B.INTERNET' DETCAN, 'BIN' ABR_CANAL, 10 COD_CANAL, 'DIGITAL' DES_CANAL, 1 COD_TICAN, 'PROPIO' DES_TCAN from dual                
                   union all 
                   select 4 KEY_CANAL,'B.MOVIL' DETCAN, 'BMO' ABR_CANAL, 10 COD_CANAL, 'DIGITAL' DES_CANAL, 1 COD_TICAN, 'PROPIO' DES_TCAN from dual
                   union all 
                   select 7 KEY_CANAL,'SCOTIABANK' DETCAN, 'SCO' ABR_CANAL, 6 COD_CANAL, 'CORRESPONSALIA' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual
                   union all 
                   select 8 KEY_CANAL,'INTERBANK' DETCAN, 'IBK' ABR_CANAL, 6 COD_CANAL, 'CORRESPONSALIA' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual
                   union all 
                   select 9 KEY_CANAL,'BCO.NACION' DETCAN, 'BNA' ABR_CANAL, 6 COD_CANAL, 'CORRESPONSALIA' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual
                   union all 
                   select 11 KEY_CANAL,'POS NACIONAL' DETCAN, 'PNAC' ABR_CANAL, 11 COD_CANAL, 'COMPRAS' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual
                   union all 
                   select 16 KEY_CANAL,'POS EXTRANJERO' DETCAN, 'PEXT' ABR_CANAL, 11 COD_CANAL, 'COMPRAS' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual
                   union all 
                   select 17 KEY_CANAL,'POS VISA MAS' DETCAN, 'PVMA' ABR_CANAL, 11 COD_CANAL, 'COMPRAS' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual
                   union all 
                   select 18 KEY_CANAL,'C.ELC.NACIONAL' DETCAN, 'CNAC' ABR_CANAL, 11 COD_CANAL, 'COMPRAS' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual
                   union all 
                   select 19 KEY_CANAL,'C.ELC.EXTRANJERO' DETCAN, 'CEXT' ABR_CANAL, 11 COD_CANAL, 'COMPRAS' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual
                   union all 
                   select 10 KEY_CANAL,'BILL.ELECTRONICA' DETCAN, 'BIE' ABR_CANAL, 9 COD_CANAL, 'BILL.ELECTRONICA' DES_CANAL, 1 COD_TICAN, 'PROPIO' DES_TCAN from dual
                   union all 
                   select 20 KEY_CANAL,'VISA' DETCAN, 'VISA' ABR_CANAL, 3 COD_CANAL, 'ATM' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual
                   union all 
                   select 21 KEY_CANAL,'UNICARD' DETCAN, 'UNIC' ABR_CANAL, 3 COD_CANAL, 'ATM' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual
                   union all 
                   select 22 KEY_CANAL,'BANBIF' DETCAN, 'BBIF' ABR_CANAL, 6 COD_CANAL, 'CORRESPONSALIA' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual
                   union all 
                   select 23 KEY_CANAL,'BCP' DETCAN, 'BCP' ABR_CANAL, 6 COD_CANAL, 'CORRESPONSALIA' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual
                   union all 
                   select 24 KEY_CANAL,'BBVA' DETCAN, 'BBVA' ABR_CANAL, 6 COD_CANAL, 'CORRESPONSALIA' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual
                   union all
                   select 25 KEY_CANAL,'WEB' DETCAN,'WEB' ABR_CANAL, 10 COD_CANAL,'DIGITAL' DES_CANAL,1 COD_TICAN, 'PROPIO' DES_TCAN from dual
                   union all
                   select 26 KEY_CANAL,'KIOSKO' DETCAN,'KIO' ABR_CANAL,13 COD_CANAL,'MULTIMEDIA' DES_CANAL, 1 COD_TICAN,'PROPIO' DES_TCAN from dual
                   union all
                   select 27 KEY_CANAL,'NIUBIZ' DETCAN,'NIU' ABR_CANAL, 2 COD_CANAL,'AGENTE' DES_CANAL, 2 COD_TICAN,'TERCEROS' DES_TCAN from dual
                   union all
                   select 28 KEY_CANAL,'TARJ.DIGITAL' DETCAN,'TDIG' ABR_CANAL, 10 COD_CANAL,'DIGITAL' DES_CANAL, 1 COD_TICAN,'PROPIO' DES_TCAN from dual 
                   union all   
                   select 29 KEY_CANAL,'CCE' DETCAN, 'CCE' ABR_CANAL, 6 COD_CANAL, 'CORRESPONSALIA' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual   
                   union all 
                   select 33 KEY_CANAL,'BCP FST' DETCAN, 'BCPF' ABR_CANAL, 6 COD_CANAL, 'CORRESPONSALIA' DES_CANAL, 2 COD_TICAN, 'TERCEROS' DES_TCAN from dual
             ) b
               ON (t.KEY_CANAL = b.KEY_CANAL)
        WHEN MATCHED THEN                                         
                     UPDATE
                       SET T.ABR_CANAL = B.ABR_CANAL,
                           T.COD_TIPCAN= B.COD_TICAN,
                           T.DES_TIPCAN= B.DES_TCAN,
                           T.COD_CANAL = B.COD_CANAL,
                           T.DES_CANAL = B.DES_CANAL,
                           T.DET_CANDET= B.DETCAN
        WHEN NOT MATCHED THEN
                     INSERT(KEY_CANAL,DET_CANDET,ABR_CANAL,COD_TIPCAN,DES_TIPCAN,COD_CANAL,DES_CANAL)
                     VALUES(PQ_TMP_CARGA_FACTS.SEQ_NEXTVAL('SQ_DM_CANAL'),B.DETCAN,B.ABR_CANAL,B.COD_TICAN,B.DES_TCAN,B.COD_CANAL,B.DES_CANAL)
        LOG ERRORS INTO ERR$_TMP_DM_CANAL('MERGE-' || to_char(sysdate,'rrrrmmdd')) REJECT LIMIT UNLIMITED;
        COMMIT;
Exception When Others then
      Null;                        
End SP_TMP_DM_CANAL;
---------------------------------------------------------------------------------
Procedure SP_TMP_DM_DETCANAL
  Is
  Begin
        MERGE INTO TMP_DM_detcanal D
           USING (Select TO_CHAR (cod_atm) COD, des_atm DES, nro_atm ABR, 2 CCANAL 
                    From dwstage.tmp_dm_atm
                 Union All
                 Select codigo_agencia, nombre_agencia, 
                        SUBSTR(NOMBRE_AGENCIA,1,10), 1 key_canal 
                   From dwstage.tmp_dm_geografia_activo
                   where tipo_region='R' 
                 Union All
                 Select '901', 'INTERNET', 'BINT', 3 KEY_CANAL From Dual
                 Union All
                 Select '905', 'MOVIL', 'BMOV', 4 KEY_CANAL From Dual
                 Union All
                 Select '908', 'BILLETERA ELECTRONICA', 'BILLE', 10 KEY_CANAL From Dual
                 Union All
                 Select '902', 'BCO.NACION', 'BN', 9 key_canal From Dual
                 Union All
                 Select '802', 'KASNET', 'KASN', 6 key_canal From Dual
                 Union All
                 Select '803', 'SCOTIABANK', 'SCO', 7 key_Canal From Dual
                 Union All
                 Select '804', 'INTERBANK', 'IBNK', 8 key_Canal From Dual
                 Union All
                 Select '806', 'BANBIF', 'BBIF', 22 key_Canal From Dual
                 Union All
                 Select '807', 'BCP', 'BCP', 23 key_Canal From Dual
                 Union All
                 Select '808', 'BBVA', 'BBVA', 24 key_Canal From Dual
                 Union All
                 Select TO_CHAR(JAQL4NUCOM), TRIM(JAQL4NOCOM),SUBSTR(TRIM(JAQL4NOCOM),1,10), 5 KEY_CANAL 
                   FROM dwextra.jaql004
                 Union All
                 Select '903', 'POS NACIONAL', 'PNAC', 11 key_Canal From Dual
                 Union All
                 Select '806', 'WESTERN UNION', 'WU', 13 key_Canal From Dual
                 Union All
                 --Select '816', 'VISA EXTRANJERO', 'VEXT', 14 key_Canal From Dual 
                 Select '816', 'VISA EXTRANJERO', 'VEXT', 20 key_Canal From Dual 
                 Union All
                 Select '807', 'GLOBAL NET', 'GNET', 15 key_Canal From Dual
                 Union All
                 Select '808', 'POS EXTRANJERO', 'PEXT', 16 key_Canal From Dual
                 Union All
                 Select '809', 'POS VISA MAS', 'PVMA', 17 key_Canal From Dual
                 Union All
                 Select '810', 'C.ELC.NACIONAL', 'CNAC', 18 key_Canal From Dual
                 Union All
                 Select '811', 'C.ELC.EXTRANJERO', 'CEXT', 19 key_Canal From Dual
                 Union All
                 Select '815', 'VISA NACIONAL', 'VNAC', 20 key_Canal From Dual
                 Union All
                 Select '805', 'UNICARD', 'UNIC', 21 key_Canal From Dual
                 Union All
                 Select '904', 'CCE', 'CCE', 29 key_Canal From Dual
                 Union All
                 Select '907', 'BCP FST', 'BCPF', 33 key_Canal From Dual
               ) x 
                 
              ON (D.COD_DETCANAL = X.COD AND D.KEY_CANAL = CCANAL)
                 
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET D.DES_DETCANAL = X.DES,
                              D.ABR_DETCANAL = X.ABR
      WHEN NOT MATCHED THEN
                       INSERT (D.KEY_DETCANAL, D.COD_DETCANAL, D.DES_DETCANAL, D.ABR_DETCANAL, D.KEY_CANAL)
                       VALUES(PQ_TMP_CARGA_FACTS.SEQ_NEXTVAL('SQ_DM_DETCANAL'),X.COD, X.DES, X.ABR, X.CCANAL)
      LOG ERRORS INTO Err$_Tmp_Dm_detcanal('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                        
                                             
End SP_TMP_DM_DETCANAL;

---------------------------------------------------------------------------------
Procedure SP_GEOGRAFIA_DETCANAL
Is 
   Cursor c_detcan
       is Select c.cod_canal,c.key_canal,d.key_detcanal,d.cod_detcanal 
            from tmp_dm_detcanal d
            join tmp_dm_canal c on c.key_canal=d.key_canal;
   lv_codsuc varchar2(5);
Begin
   For x in c_detcan Loop
       lv_codsuc := '11';
       
       If x.cod_canal = 1 Then --Agencia
          lv_codsuc := x.COD_DETCANAL;
       ElsIf x.cod_canal = 3 Then
          Begin
             Select to_char(f.z0e475suc)
               Into lv_codsuc 
               From dwextra.z0e475 f
              Where trim(f.z0e475cod) = x.COD_DETCANAL;
          Exception When Others Then
             lv_codsuc := '11';
          End;
       End If;
       
       Update TMP_DM_DETCANAL d
          Set d.codigo_agencia = lv_codsuc,
              d.tipo_region    = 'R'
        Where d.key_detcanal   = x.key_detcanal
          and d.key_canal      = x.key_canal;
        Commit;        
   End Loop;
End SP_GEOGRAFIA_DETCANAL;
---------------------------------------------------------------------------------
Procedure SP_TMP_DM_MOTCANCELA
  Is
  Begin
        MERGE INTO TMP_DM_MOTCANCELA M
           USING (Select x.MOTCOD, TRIM(X.MOTTXT) MOTTXT From dwextra.FST157 x
                  ) B
              ON (M.COD_MOTCAN = B.MOTCOD) 
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET M.DES_MOTCAN = B.MOTTXT
                          
      WHEN NOT MATCHED THEN
                       INSERT (M.KEY_MOTCAN,M.COD_MOTCAN,M.DES_MOTCAN)
                       VALUES(SQ_DM_MOTCANCELA.NEXTVAL,B.MOTCOD,B.MOTTXT)
      LOG ERRORS INTO Err$_Tmp_Dm_MOTCANCELA('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                        
                                             
End SP_TMP_DM_MOTCANCELA;
------------------------------------------------------------------------------------------
  Function fn_key_detcanal(PV_CODDET In Varchar2,
                         PN_CCANAL In Number
                        )
  Return Number
  Is
      ln_keydet tmp_dm_detcanal.key_detcanal%type;
  Begin
       Begin
            
            Select key_detcanal
              Into ln_keydet
              From tmp_dm_detcanal d
             Where d.cod_detcanal = PV_CODDET
               and d.key_canal    = PN_CCANAL;
        
      Exception When No_DAta_Found Then
            Begin
               Select key_detcanal
                 Into ln_keydet
                 From tmp_dm_detcanal d
                Where d.cod_detcanal = '0'
                  and d.key_canal    = PN_CCANAL;
            
            Exception When Others Then
                ln_keydet := Null;   
            End; 
      End;  
          
      Return ln_keydet;
      
  End fn_key_detcanal;
------------------------------------------------------------------------------------------
Function fn_cod_agente(PD_FECHA In Date,
                       PN_CMOD  In Number,
                       PN_CSUC  In Number,
                       PN_CTRA  In Number,
                       PN_CREL  In Number)
Return Varchar2
Is
  --ln_keydet tmp_dm_detcanal.key_detcanal%type;
  ln_nroage number(20);
  ln_mod    number(3);
  ln_mda    number(4);
  ln_cta    number(9);
  ln_ope    number(9);
  ln_sbo    number(3);
  ln_top    number(3);
  ln_ord    number(3);
Begin
    --If PV_DHIS = 'N' Then
       Begin
        Select n.jaql4nucom
          Into ln_nroage
          From DWEXTRA.jaql006 m
          Join DWEXTRA.jaql009 u on u.jaql9nuele = m.jaql9nuele
          Join dwextra.jaql004 n on n.jaql4cocom=u.jaql4cocom 
         Where m.jaql6ctfco=PD_FECHA 
           and m.jaql6ctmod=PN_CMOD 
           and m.jaql6ctsuc=PN_CSUC 
           and m.jaql6cttra=PN_CTRA 
           and m.jaql6ctrel=PN_CREL
           and m.jaql6estad='S';
       Exception When Others Then
           ln_nroage := Null; 
       End;
        --ln_keydet := pq_tmp_carga_transacc.fn_key_detcanal(to_char(ln_nroage),5);
     IF ln_nroage IS Null Then
          If PN_CMOD = 490 and PN_CTRA in (1,6,11,12,400,401) Then ln_ord:= 5;
          ElsIf PN_CMOD = 490 and PN_CTRA = 100 Then ln_ord:= 82;
          ElsIf PN_CMOD = 490 and PN_CTRA = 503 Then ln_ord:= 10;
          ElsIf PN_CMOD = 490 and PN_CTRA in (942,982,983) Then ln_ord:= 23;
          End If;
          
          Begin
               Execute Immediate 'Select u.hmodul,u.hmda,u.hcta,u.hoper,u.hsubop,u.htoper '||
                                 'From dwextra.fsh015_16 u '||
                                 'Where hcmod=:1 and hsucor=:2 and htran=:3 and hnrel=:4 '||
                                 'and hfcon=:5 and hcord=:6'
               Into ln_mod,ln_mda,ln_cta,ln_ope,ln_sbo,ln_top
               Using PN_CMOD,PN_CSUC,PN_CTRA,PN_CREL,PD_FECHA,ln_ord;
         
               Select n.jaql4nucom Into ln_nroage
                 from dwextra.jaql002 t
                 join dwextra.jaql009 c on c.jaql2coter = t.jaql2coter
                 Join dwextra.jaql004 n on n.jaql4cocom = c.jaql4cocom
                Where t.jaql2crmod = ln_mod
                  and t.jaql2crmda = ln_mda
                  and t.jaql2crcta = ln_cta
                  and t.jaql2crope = ln_ope
                  and t.jaql2crsbo = ln_sbo
                  and t.jaql2crtop = ln_top
                  and t.jaql2estad = 1;
                  --and c.jaql9fealt <= PD_FECHA
                  --and (c.jaql9febaj > PD_FECHA or nvl(c.jaql9febaj,'01/01/0001')='01/01/0001');
          Exception When Others Then
                 Begin
                       Select n.jaql4nucom Into ln_nroage
                       from dwextra.jaql002 t
                       join dwextra.jaql009 c on c.jaql2coter = t.jaql2coter
                       Join dwextra.jaql004 n on n.jaql4cocom = c.jaql4cocom
                      Where t.jaql2crmod = ln_mod
                        and t.jaql2crmda = ln_mda
                        and t.jaql2crcta = ln_cta
                        and t.jaql2crope = ln_ope
                        and t.jaql2crsbo = ln_sbo
                        and t.jaql2crtop = ln_top
                        and c.jaql9fealt <= PD_FECHA
                        and (c.jaql9febaj > PD_FECHA or nvl(c.jaql9febaj,'01/01/0001')='01/01/0001');
                 Exception When Others Then 
                       ln_nroage := Null;
                 End;        
          End;   
    End If;
  
    Return to_char(nvl(ln_nroage,0));
End fn_cod_agente; 
------------------------------------------------------------------------------------------   
Procedure sp_FSD_DIARIO (pn_ctaini in number, pn_ctafin in number,
                        Pc_FECHA  in varchar2)
  --------------------------------------------------------------------------------------
  -- Creación:
  ---------------------------------------------------------------------------------------
  -- Fecha  : 09/07/2018
  -- Autor  : 
  -- Cambios: 
  ---------------------------------------------------------------------------------------
  
  IS
  
       ld_Fechfinmes date:=last_day(to_date(Pc_FECHA,'yyyymmdd'));
       ln_dia number(2):=to_number(substr(pc_fecha,7,2));
       
       Cursor c_FBC510 is 
           Select rubro BC510ID1, BC510ID2,sum(BC510IMP1) BC510IMP1,sum(BC510IMP2) BC510IMP2
             From (
                   SELECT distinct BC510ID2, BC510IMP1, 
                          case when substr(BC510ID1,4,1) = 8 AND bc510id1 like '%98' then  to_number(substr(BC510ID1,1,6)||'98') 
                          when substr(BC510ID1,4,1) = 8 AND bc510id1 not like '%98' then to_number(substr(BC510ID1,1,8)) 
                          else BC510ID1 end rubro,
                          BC510IMP2 
                     FROM DWEXTRA.FBC510 
                    WHERE bc510id2 between pn_ctaini and pn_ctafin 
                      and bc510fch=ld_Fechfinmes 
                      and bc510id3=ln_dia 
                  ) group by rubro , BC510ID2 ;
        
        Cursor c_fact_pasivo (ln_cuenta in number, ld_fech in date, lv_rubro in varchar2,ln_mda in number) is 
              SELECT saldo_mo, codigo_rubro,
                     AOMOD, AOMDA, AOCTA, AOOPE, AOSBO, AOTOP, 
                     ind_dosrub,nvl(imp_fsd,0) imp_fsd
                from tmp_fact_pasivo
               Where fecha = ld_fech
                 and aocta = ln_cuenta
                 and aomda = ln_mda
                 and codigo_rubro =lv_rubro
                 Order by saldo_mo;
       
       Cursor c_fact_pasivo_INTERES (ln_cuenta in number, ld_fech in date) 
         is 
           SELECT saldo_mo, AOMOD, AOMDA, AOCTA, AOOPE, AOSBO, AOTOP, INTERES_GENERADO 
               from tmp_fact_pasivo
             WHERE aocta = ln_cuenta 
               and fecha = ld_fech 
               and AOMOD = 22;
               
       Cursor c_inac_act (ln_cuenta in number, ld_fech in date, lv_rubro in varchar2,ln_mda in number) 
         is
            SELECT saldo_mo,codigo_rubro,
                   AOMOD, AOMDA, AOCTA, AOOPE, AOSBO, AOTOP,
                   nvl(imp_fsd,0) imp_fsd,ind_dosrub
                 from tmp_fact_pasivo
               Where fecha = ld_fech
                 and aocta = ln_cuenta
                 and aomda = ln_mda
                 and (substr(codigo_rubro,1,5)||'0'||substr(codigo_rubro,7))=lv_rubro;
       
       Cursor c_Imp_Garant (ln_cuenta in number, ld_fech in date,ln_mda in number,ln_modulo in number) 
         is
            Select saldo_garantia imp_garantia, codigo_rubro,  
                   AOMOD, AOMDA, AOCTA, AOOPE, AOSBO, AOTOP
              from tmp_fact_pasivo
              Where fecha = ld_Fech
                and aocta = ln_cuenta
                and aomda = ln_mda
                and aomod = ln_modulo;
                
       Cursor c_interes (ln_cuenta in number, ld_fech in date,ln_mda in number) 
         is
            Select  AOMOD, AOMDA, AOCTA, AOOPE, AOSBO, AOTOP,
                    count(*) over (partition by aocta) Cantidad
                from tmp_fact_pasivo
              Where fecha = ld_Fech
                and aocta = ln_cuenta
                and aomda = ln_mda
                and aomod = 22;
                
       ld_fechasaldo date:=to_date(Pc_FECHA,'yyyymmdd');
       
       ln_saldotot Number(12,2);
       ln_saldo number(12,2);
       ln_aomod number(3);
       ln_aomda number(4);
       ln_aocta number(9);
       ln_aoope number(9);
       ln_aosbo number(3);
       ln_aotop number(3);
       lv_rubro      Varchar2(10);
       ln_codmda     number(4);
       ln_modulo     number(3);
       ln_cantcta    number (10);
       ln_dosrub     number(1);
       ln_inddrub    number(1);
       
   BEGIN
       FOR X IN C_FBC510 LOOP
           ln_saldo   := 0;
           ln_saldotot:= 0;
           ln_aomod   := null;
           ln_aomda   := null; 
           ln_aocta   := null; 
           ln_aoope   := null; 
           ln_aosbo   := null; 
           ln_aotop   := null; 
           ln_aomda   := null;  
           ln_inddrub := 1; 

           If substr(x.bc510id1,3,1)=1 then ln_saldotot:=x.bc510imp1;
           Else ln_saldotot:=x.bc510imp2;
           End if;
           
           ln_codmda:= substr(x.bc510id1,3,1);
           
           IF ln_codmda = 1 Then ln_codmda:=0; 
           Else ln_codmda:=101; 
           End if;
               
          If substr(x.bc510id1,4,1) = 8 Then 
       
             If x.bc510id1 like '%98' then 
                ln_cantcta:=0;--CURSOR C_INTERES
                FOR c in c_interes (x.BC510ID2,ld_fechasaldo,ln_codmda) LOOP
                    ln_aomod:=c.aomod;
                    ln_aomda:=c.aomda;
                    ln_aocta:=c.aocta;
                    ln_aoope:=c.aoope;
                    ln_aosbo:=c.aosbo;
                    ln_aotop:=c.aotop;
                       
                    Update tmp_fact_pasivo
                       Set dii_fsd = ln_saldotot,
                           IND_FSD = 0 
                     Where aomod = ln_aomod
                       and aomda = ln_aomda
                       and aocta = ln_aocta
                       and aoope = ln_aoope
                       and aosbo = ln_aosbo
                       and aotop = ln_aotop;
                     Commit;
                     Exit; 
                END LOOP;
             Else       
               lv_rubro := substr(x.bc510id1,1,2)||substr(x.bc510id1,5,2);
               FOR I IN c_fact_pasivo_INTERES(X.BC510ID2,ld_fechasaldo) loop
                   ln_aomod:=I.aomod;
                   ln_aomda:=I.aomda;
                   ln_aocta:=I.aocta;
                   ln_aoope:=I.aoope;
                   ln_aosbo:=I.aosbo;
                   ln_aotop:=I.aotop;
               
                   IF ln_saldotot >= I.INTERES_GENERADO THEN ln_saldo:=I.INTERES_GENERADO;
                      ELSE ln_saldo:=ln_saldotot;
                      ENd IF;
                   
                    Update tmp_fact_pasivo
                       set int_fsd=ln_saldo 
                     where aomod = ln_aomod
                       and aomda = ln_aomda
                       and aocta = ln_aocta
                       and aoope = ln_aoope
                       and aosbo = ln_aosbo
                       and aotop = ln_aotop;
                    
                    Commit;
                    ln_saldotot := ln_saldotot-ln_saldo;
              END LOOP;
           
              IF ln_saldotot > 0 then 
                 ln_saldo:= ln_saldo+ln_saldotot;
                 Update tmp_fact_pasivo 
                     set int_fsd=ln_saldo 
                   Where aomod = ln_aomod
                     and aomda = ln_aomda
                     and aocta = ln_aocta
                     and aoope = ln_aoope
                     and aosbo = ln_aosbo
                     and aotop = ln_aotop;
                  Commit;  
              END IF;
           End If;   
         ElsIf substr(x.bc510id1,4,1) = 7 Then 
               If substr(x.bc510id1,12,2) in ('03','09','98') then ln_modulo:=22; 
               Else ln_modulo:=21; 
               End if;
               
               FOR I IN c_Imp_Garant(X.BC510ID2,ld_fechasaldo,ln_codmda,ln_modulo) Loop
                   ln_aomod:=I.aomod;
                   ln_aomda:=I.aomda;
                   ln_aocta:=I.aocta;
                   ln_aoope:=I.aoope;
                   ln_aosbo:=I.aosbo;
                   ln_aotop:=I.aotop;
                
                   IF ln_saldotot >= I.IMP_GARANTIA Then
                      ln_saldo:= I.IMP_GARANTIA;
                   ELSE ln_saldo:= ln_saldotot;
                   END IF;
                   
                   Update tmp_fact_pasivo --dwhouse.fact_pasivo
                      Set gar_fsd=ln_saldo,
                          IND_FSD = 0  
                    Where aomod = ln_aomod
                      and aomda = ln_aomda
                      and aocta = ln_aocta
                      and aoope = ln_aoope
                      and aosbo = ln_aosbo
                      and aotop = ln_aotop;
                   Commit;
                   ln_saldotot := ln_saldotot-ln_saldo;
               END LOOP;
          
               IF ln_saldotot > 0 THEN 
                  ln_saldo:= ln_saldo+ln_saldotot;
                  Update tmp_fact_pasivo --dwhouse.tmp_fact_pasivo
                     set gar_fsd=ln_saldo,
                         IND_FSD = 0  
                   Where aomod = ln_aomod
                     and aomda = ln_aomda
                     and aocta = ln_aocta
                     and aoope = ln_aoope
                     and aosbo = ln_aosbo
                     and aotop = ln_aotop;
                  Commit;   
               END IF; 
          
          
         ELSE
              lv_rubro := substr(x.bC510ID1,1,10);
              lv_rubro := substr(lv_rubro,1,2)||'0'||substr(lv_rubro,4);
              ln_dosrub:= 0;
              
              For Y in c_fact_pasivo(x.BC510ID2,ld_fechasaldo,lv_rubro,ln_codmda) Loop
                    ln_aomod:=y.aomod;
                    ln_aomda:=y.aomda;
                    ln_aocta:=y.aocta;
                    ln_aoope:=y.aoope;
                    ln_aosbo:=y.aosbo;
                    ln_aotop:=y.aotop;
                    ln_inddrub   := nvl(y.ind_dosrub,1);
               
                    If ln_saldotot >= y.saldo_mo then ln_saldo:=y.saldo_mo;
                    Else ln_saldo:=ln_saldotot;
                    End if; 
               
                    If nvl(y.ind_dosrub,1) > 1 Then
                       Update tmp_fact_pasivo 
                          set imp_fsd=(ln_saldo+y.imp_fsd),
                              IND_FSD = 0 
                        Where aomod = ln_aomod
                          and aomda = ln_aomda
                          and aocta = ln_aocta
                          and aoope = ln_aoope
                          and aosbo = ln_aosbo
                          and aotop = ln_aotop;
                    Else
                       Update tmp_fact_pasivo
                          set imp_fsd=ln_saldo,
                              IND_FSD = 0 
                        Where aomod = ln_aomod
                          and aomda = ln_aomda
                          and aocta = ln_aocta
                          and aoope = ln_aoope
                          and aosbo = ln_aosbo
                          and aotop = ln_aotop;
                    End If; 
                    Commit;
           
                    ln_saldotot := ln_saldotot-ln_saldo;
                    ln_dosrub   := 1;
              End loop;
           
              IF ln_dosrub = 0 THEN
                 lv_rubro := substr(lv_rubro,1,5)||'0'||substr(lv_rubro,7);
                 FOR Z in c_inac_act(x.BC510ID2,ld_fechasaldo,lv_rubro,ln_codmda) LOOP
                     IF nvl(z.ind_dosrub,1) > 1 Then 
                        ln_aomod := z.aomod;
                        ln_aomda := z.aomda;
                        ln_aocta := z.aocta;
                        ln_aoope := z.aoope;
                        ln_aosbo := z.aosbo;
                        ln_aotop := z.aotop;
                        ln_inddrub   := nvl(z.ind_dosrub,1);
                       
                        IF ln_saldotot >= z.saldo_mo then ln_saldo:=z.saldo_mo;
                           ELSE ln_saldo:=ln_saldotot;
                        END IF; 
             
                        Update tmp_fact_pasivo--dwhouse.fact_pasivo 
                           set imp_fsd = ln_saldo + nvl(z.imp_fsd,0),
                               IND_FSD = 0 
                         Where aomod = ln_aomod
                           and aomda = ln_aomda
                           and aocta = ln_aocta
                           and aoope = ln_aoope
                           and aosbo = ln_aosbo
                           and aotop = ln_aotop;
                        Commit;
                        ln_saldotot := ln_saldotot-ln_saldo;
                     End If; --nvl(z.ind.dosrub,1)
                 End Loop; --loop c_inac_act
              End If; --ln_dosrub
              -- 
              IF ln_saldotot > 0 THEN 
                 ln_saldo:= ln_saldo+ln_saldotot;
                 IF ln_inddrub > 1 THEN
                    Update tmp_fact_pasivo
                       Set imp_fsd=(ln_saldo+nvl(imp_fsd,0)),
                           ind_fsd=0 
                     Where aomod = ln_aomod
                       and aomda = ln_aomda
                       and aocta = ln_aocta
                       and aoope = ln_aoope
                       and aosbo = ln_aosbo
                       and aotop = ln_aotop;
                 ELSE 
                    Update tmp_fact_pasivo
                       Set imp_fsd=ln_saldo,
                           ind_fsd=0 
                     Where aomod = ln_aomod
                       and aomda = ln_aomda
                       and aocta = ln_aocta
                       and aoope = ln_aoope
                       and aosbo = ln_aosbo
                       and aotop = ln_aotop;
                 END IF;--ln_inddrub
                 Commit; 
              END IF;--ln_saldotot  
      End if;  
     END LOOP;
         
end sp_FSD_DIARIO;
---------------------------------------------------------------------
 Procedure sp_job_fsd_diario(pc_fecha in varchar2)
 IS
    ln_max number(10);
    ln_rango number(10);
    x number(10);
    ln_job number(10);
    ln_ini number(10);
    ln_fin number(10);
    lc_variable varchar2(1000);
    lc_fecpro varchar2(10):=pq_tmp_carga_facts.FN_VALOR_PARAMETRO('1');
    ld_fecha date := to_date(lc_fecpro,'dd-mm-yyyy');
    NUM_JOB_PENDIENTES number(10);
    ln_mmxjob Number(5);
 Begin
    
         --execute immediate('truncate table  '||p_c_usuario||'.fbc510'); 
         begin 
             select max(ctnro),trunc(max(ctnro)/300)   
               into ln_max,ln_rango
               from dwextra.fsr008
              where ctnro <> 999999999;
              
              
         exception 
               when no_data_found then
                    ln_max := 0;
                     ln_rango:=0;
         end;    
         
         --lc_fecpro := to_char(ld_Fecha,'rrrrmmdd');
         
               
         x:=0;
         ln_job := 0;
         while x <= ln_max loop
              ln_ini := x+1;
              x:= x+ ln_rango;
              ln_fin := x;
              lc_variable := ' begin '||'  PQ_tmp_carga_transacc.sp_fsd_diario('||ln_ini||','||ln_fin ||',' || to_char(ld_Fecha,'rrrrmmdd') || ');'|| ' End; ';
              ln_job := ln_job +1;
              -- dbms_output.put_line (lc_variable);
                 
               dbms_scheduler.create_job(
                 job_name=> 'FSD_DIARIO_'||LPAD(TO_CHAR(ln_job),5,'0'),
                 job_type=> 'PLSQL_BLOCK',
                 job_action=> lc_variable,
                 start_date => sysdate+1/(24*180),
                 enabled => true, 
                 auto_drop=> TRUE,
                 comments => 'FSD_DIARIO'
                 );
              
             NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(pi_vc2_nomjob => 'FSD_DIARIO_%',
                                               pi_vc2_nomusr => USER);

             -- DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
              
              ---- INSERTA TABLA CONTROL

        /*      INSERT INTO Tab_jobs (c_codage,n_Numer1,c_detjob)
              VALUES('DMC',ln_ini,lc_variable);
              COMMIT;        */
          commit;
          end loop;
          /*++++++++++++++++++++  CONTROLA MAXIMO 50 JOBS*/
          --select count(*) into ln_mmxjob from user_scheduler_jobs;
          loop
             select count(*) into ln_mmxjob from user_scheduler_jobs
             where job_name like 'FSD_DIARIO_%';
          Exit when ln_mmxjob = 0;
          End Loop;   
          /*++++++++++++++++++++*/
          
          Update tmp_fact_pasivo x
             set IND_FSD = 1
           Where not exists (select 1 
                              from dwextra.fbc510 d where d.bc510id2=x.aocta);
          Commit;
          
 End sp_job_fsd_diario;
----------------------------------------------------------------------------------------------------------
Procedure sp_FSD_HIST (pn_ctaini in number, pn_ctafin in number,
                        Pc_FECHA  in varchar2)
  --------------------------------------------------------------------------------------
  -- Creación:
  ---------------------------------------------------------------------------------------
  -- Fecha  : 09/07/2018
  -- Autor  : 
  -- Cambios: 
  ---------------------------------------------------------------------------------------
  
  IS
  
       ld_Fechfinmes date:=last_day(to_date(Pc_FECHA,'yyyymmdd'));
       ln_dia number(2):=to_number(substr(pc_fecha,7,2));

       Cursor c_FBC510 is 
           Select rubro BC510ID1, BC510ID2,sum(BC510IMP1) BC510IMP1,sum(BC510IMP2) BC510IMP2
             From (
                   SELECT distinct BC510ID2, BC510IMP1, 
                          case when substr(BC510ID1,4,1) = 8 AND bc510id1 like '%98' then  to_number(substr(BC510ID1,1,6)||'98') 
                          when substr(BC510ID1,4,1) = 8 AND bc510id1 not like '%98' then to_number(substr(BC510ID1,1,8)) 
                          else BC510ID1 end rubro,
                          BC510IMP2 
                     FROM DWEXTRA.FBC510 
                    WHERE bc510id2 between pn_ctaini and pn_ctafin 
                      and bc510fch=ld_Fechfinmes 
                      and bc510id3=ln_dia 
                  ) group by rubro , BC510ID2 ;

       Cursor c_fact_pasivo (ln_cuenta in number, ld_fech in date, lv_rubro in varchar2,ln_mda in number) is 
              SELECT saldo_mo, AOCTA, codigo_rubro,cuentas_key,tiempo_key,aomda,ind_dosrub,nvl(imp_fsd,0) imp_fsd
                from tmp_fpasivo_fsd
               Where fecha = ld_fech
                 and aocta = ln_cuenta
                 and aomda = ln_mda
                 and codigo_rubro =lv_rubro
                 Order by saldo_mo; 
       
       Cursor c_inac_act (ln_cuenta in number, ld_fech in date, lv_rubro in varchar2,ln_mda in number) is
              SELECT saldo_mo, AOCTA, codigo_rubro,cuentas_key,tiempo_key,aomda,
                     nvl(imp_fsd,0) imp_fsd,ind_dosrub
                from dwstage.tmp_fpasivo_fsd
               Where fecha = ld_fech
                 and aocta = ln_cuenta
                 and aomda = ln_mda
                 and (substr(codigo_rubro,1,5)||'0'||substr(codigo_rubro,7))=lv_rubro;
                 
       Cursor c_fact_pasivo_interes (ln_cuenta in number, ld_fech in date,
                                     ln_mda in number,lv_rubro in Varchar2) is 
              SELECT int_gen_mo, AOCTA, codigo_rubro,cuentas_key,tiempo_key,aomda
                from tmp_fpasivo_fsd
               Where fecha = ld_fech
                 and aocta = ln_cuenta
                 and aomda = ln_mda
                 and aomod in(21,22)
                 and substr(codigo_rubro,1,4)=lv_rubro
                 Order by (case when aomod=22 Then 1
                               when aomod=21 and aotop <> 2 then 2
                               else 3 end);
                  
       Cursor c_Imp_Garant (ln_cuenta in number, ld_fech in date,
                                     ln_mda in number,ln_modulo in number) is
              Select imp_garantia, AOCTA, codigo_rubro, cuentas_key, tiempo_key,aomda
              from tmp_fpasivo_fsd
              where fecha = ld_Fech
                and aocta = ln_cuenta
                and aomda = ln_mda
                and aomod = ln_modulo;
                
                
        Cursor c_interes (ln_cuenta in number, ld_fech in date,
                          ln_mda in number) is
                          
                Select  tiempo_key, cuentas_key, aomda, count(*) over (partition by aocta) Cantidad
                from tmp_fpasivo_fsd
              where fecha = ld_Fech
                and aocta = ln_cuenta
                and aomda = ln_mda
                and aomod = 22;
                --and substr(codigo_rubro,1,4)=lv_rubro;
                
         --ln_modulo;  

          
       ld_fechasaldo date:=to_date(Pc_FECHA,'yyyymmdd');
       
       ln_saldotot   Number(12,2);
       ln_saldo      number(12,2);
       ln_aomda      number(4);
       lv_rubro      Varchar2(10);
       ln_cta_key    number(10);
       ln_tiempo_key number(10);
       ln_codmda     number(4);
       ln_modulo     number(3);
       ln_cantcta    number (10);
       ln_dosrub     number(1);
       ln_inddrub    number(1);
   begin
   
   FOR X IN C_FBC510 LOOP
       ln_saldo     := 0;
       ln_saldotot  :=0;
       ln_cta_key   := null;
       ln_tiempo_key:= null;  
       ln_aomda     := null;  
       ln_inddrub   := 1; 

       If substr(x.bc510id1,3,1)=1 then ln_saldotot:=x.bc510imp1;
       Else ln_saldotot:=x.bc510imp2;
       End if;
           
       ln_codmda:= substr(x.bc510id1,3,1);
           
       IF ln_codmda = 1 Then ln_codmda:=0; 
       Else ln_codmda:=101; 
       End if;
               
       If substr(x.bc510id1,4,1) = 8 Then 
       
          if x.bc510id1 like '%98' then 
              ln_cantcta:=0;
              for C in c_interes (x.BC510ID2,ld_fechasaldo,ln_codmda) loop
                     ln_cta_key:= c.CUENTAS_KEY;
                     ln_tiempo_key:= c.TIEMPO_KEY;
                     ln_aomda:= c.aomda;
                       
                     /*  ln_cantcta:=ln_cantcta+1; 
                       ln_saldo:= (ln_saldotot/c.cantidad);
                       if ln_cantcta=c.cantidad then 
                       ln_saldo := (ln_saldotot-(ln_saldo*(ln_cantcta-1)));
                       end if;
                       
                       Update tmp_fpasivo_fsd --dwhouse.fact_pasivo
                         Set dii_fsd=ln_saldo,
                     IND_FSD = 0 
                   Where CUENTAS_KEY = ln_cta_key
                     and TIEMPO_KEY  =ln_tiempo_key
                     and aomda       = ln_aomda
                     ;*/
                     Update tmp_fpasivo_fsd --dwhouse.fact_pasivo
                        Set dii_fsd = ln_saldotot,
                            IND_FSD = 0 
                   Where CUENTAS_KEY = ln_cta_key
                     and TIEMPO_KEY  = ln_tiempo_key
                     and aomda       = ln_aomda;
                     
                      Commit;
                      Exit; 
              end loop;
          
          Else
          
          lv_rubro := substr(x.bc510id1,1,2)||substr(x.bc510id1,5,2);
          For I IN c_fact_pasivo_INTERES(X.BC510ID2,ld_fechasaldo,ln_codmda,lv_rubro) Loop
              ln_cta_key:= I.CUENTAS_KEY;
              ln_tiempo_key:= I.TIEMPO_KEY;
              ln_aomda:= i.aomda;
                
              IF ln_saldotot >= I.INT_GEN_MO Then
                   ln_saldo:= I.INT_GEN_MO;
              ELSE ln_saldo:= ln_saldotot;
              END IF;
                   
              Update tmp_fpasivo_fsd --dwhouse.fact_pasivo
                 Set int_fsd=ln_saldo,
                 IND_FSD = 0  
               Where CUENTAS_KEY = ln_cta_key
                 and TIEMPO_KEY  =ln_tiempo_key
                 and aomda       = ln_aomda
                 ;
              Commit;
       
             ln_saldotot := ln_saldotot-ln_saldo;
            
          END LOOP;
          
          
           
          IF ln_saldotot > 0 then 
             ln_saldo:= ln_saldo+ln_saldotot;
             Update tmp_fpasivo_fsd --dwhouse.fact_pasivo 
                set int_fsd=ln_saldo,
                IND_FSD = 0  
              Where CUENTAS_KEY= ln_cta_key
                and TIEMPO_KEY =ln_tiempo_key
                and aomda      = ln_aomda
                ;
             Commit;   
          End if; 
          
       End if;
          
      elsIf substr(x.bc510id1,4,1) = 7 Then 
          if substr(x.bc510id1,12,2) in ('03','09','98') then ln_modulo:=22; 
          else ln_modulo:=21; 
          end if;
          For I IN c_Imp_Garant(X.BC510ID2,ld_fechasaldo,ln_codmda,ln_modulo) Loop
              ln_cta_key:= I.CUENTAS_KEY;
              ln_tiempo_key:= I.TIEMPO_KEY;
              ln_aomda:= i.aomda;
                
              IF   ln_saldotot >= I.IMP_GARANTIA Then
                       ln_saldo:= I.IMP_GARANTIA;
                  ELSE ln_saldo:= ln_saldotot;
              END IF;
                   
              Update tmp_fpasivo_fsd --dwhouse.fact_pasivo
                 Set gar_fsd=ln_saldo,
                 IND_FSD = 0  
               Where CUENTAS_KEY = ln_cta_key
                 and TIEMPO_KEY  =ln_tiempo_key
                 and aomda       = ln_aomda
                 ;
              Commit;
       
             ln_saldotot := ln_saldotot-ln_saldo;
            
          END LOOP;
          
          
           IF ln_saldotot > 0 then 
             ln_saldo:= ln_saldo+ln_saldotot;
             Update tmp_fpasivo_fsd --dwhouse.fpasivo _fsd
                set gar_fsd=ln_saldo,
                IND_FSD = 0  
              Where CUENTAS_KEY= ln_cta_key
                and TIEMPO_KEY =ln_tiempo_key
                and aomda      = ln_aomda
                ;
             Commit;   
           End if; 
          
          
          
       ELSE
           lv_rubro := substr(x.bC510ID1,1,10);
           lv_rubro := substr(lv_rubro,1,2)||'0'||substr(lv_rubro,4);
           ln_dosrub:= 0;
           For Y in c_fact_pasivo(x.BC510ID2,ld_fechasaldo,lv_rubro,ln_codmda) Loop
               ln_cta_key   := y.cuentas_key;
               ln_tiempo_key:=y.tiempo_key;
               ln_aomda     :=y.aomda;
               ln_inddrub   := nvl(y.ind_dosrub,1);
               
               If ln_saldotot >= y.saldo_mo then ln_saldo:=y.saldo_mo;
               Else ln_saldo:=ln_saldotot;
               End if; 
               
               If nvl(y.ind_dosrub,1) > 1 Then
                  Update tmp_fpasivo_fsd--dwhouse.fact_pasivo 
                      set imp_fsd=(ln_saldo+y.imp_fsd),
                      IND_FSD = 0 
                   Where CUENTAS_KEY= ln_cta_key
                     and TIEMPO_KEY = ln_tiempo_key
                     and aomda      = ln_aomda;
               Else
                   Update tmp_fpasivo_fsd--dwhouse.fact_pasivo 
                      set imp_fsd=ln_saldo,
                      IND_FSD = 0 
                   Where CUENTAS_KEY= ln_cta_key
                     and TIEMPO_KEY = ln_tiempo_key
                     and aomda      = ln_aomda;
               End If; 
               Commit;
       
               ln_saldotot := ln_saldotot-ln_saldo;
               ln_dosrub   := 1;
           End loop; 
           
           --- Buscar en cuentas con mas de un rubro
           IF ln_dosrub = 0 Then
              lv_rubro := substr(lv_rubro,1,5)||'0'||substr(lv_rubro,7);
              For z in c_inac_act(x.BC510ID2,ld_fechasaldo,lv_rubro,ln_codmda) Loop
                  If nvl(z.ind_dosrub,1) > 1 Then 
                    ln_cta_key   := z.cuentas_key;
                    ln_tiempo_key:= z.tiempo_key;
                    ln_aomda     := z.aomda;
                    ln_inddrub   := nvl(z.ind_dosrub,1);
                       
                    If ln_saldotot >= z.saldo_mo then ln_saldo:=z.saldo_mo;
                    Else ln_saldo:=ln_saldotot;
                    End if; 
             
                    Update tmp_fpasivo_fsd--dwhouse.fact_pasivo 
                       set imp_fsd=ln_saldo + nvl(z.imp_fsd,0),
                           IND_FSD = 0 
                    Where CUENTAS_KEY= ln_cta_key
                      and TIEMPO_KEY = ln_tiempo_key
                      and aomda      = ln_aomda;
                    Commit;
         
                    ln_saldotot := ln_saldotot-ln_saldo;
                  End If;
              End Loop;
           End If;
           --- 
           IF ln_saldotot > 0 then 
              ln_saldo:= ln_saldo+ln_saldotot;
              If ln_inddrub > 1 Then
                 Update tmp_fpasivo_fsd
                    Set imp_fsd=(ln_saldo+nvl(imp_fsd,0)),
                        ind_fsd=0 
                  Where CUENTAS_KEY= ln_cta_key
                    and TIEMPO_KEY = ln_tiempo_key
                    and aomda      = ln_aomda;
              Else 
                  Update tmp_fpasivo_fsd
                     Set imp_fsd=ln_saldo,
                     ind_fsd=0 
                   Where CUENTAS_KEY= ln_cta_key
                     and TIEMPO_KEY = ln_tiempo_key
                     and aomda      = ln_aomda;
              End If;
              Commit; 
           End if;  
       End if;  
       Commit;
   END LOOP;
   

         
End sp_FSD_HIST;

-------------------------------------------------------------------------------------------------------
procedure sp_job_fsd_HIST(pv_fecha in varchar2,pv_tipo in Varchar2)
is

   Cursor c_intcts
       is  Select t.aocta,t.aomod,t.aotop,t.aosbo,t.aoope,t.fecha,r.rrrubr,t.aomda
             from tmp_fpasivo_fsd t 
             Join dwextra.fsr014 r 
               on substr(r.rubro,1,10) = substr(t.codigo_rubro,1,2)||decode(t.aomda,'0','1','2')||substr(t.codigo_rubro,4)
              and r.rrcod = 1
            where aomod=21 and aotop=2;
       /*Select t.aocta,t.aomod,t.aotop,t.aosbo,t.aoope 
       from tmp_fpasivo_fsd t where aomod=21 and aotop=2;*/
   
   Cursor c_dosrub(dfecha in date)
       is Select bcemp,bcmda,bccta,bcoper,bcsbop,bctop,bcmod,count(*) dosrub
          From fsh012@produ
          Where bcfech = dfecha
            and bcmod in (21,22)
            and bcprod <> 99
          Group By bcemp,bcmda,bccta,bcoper,bcsbop,bctop,bcmod
          Having Count(*)>1;
           
ln_int number(12,2);
ln_max number(10);
ln_rango number(10);
x number(10);
ln_job number(10);
ln_ini number(10);
ln_fin number(10);
lc_variable varchar2(1000);
lc_fecpro varchar2(10):=pv_fecha;--pq_tmp_carga_facts.FN_VALOR_PARAMETRO('1');
ld_fecha date := to_date(lc_fecpro,'rrrrmmdd');
NUM_JOB_PENDIENTES number(10);
 ln_mmxjob number(10);
  
Begin
     If pv_tipo = 'T' Then
        -- Busca tabla, elimina y/o crea
        Execute Immediate 'Truncate table tmp_fpasivo_fsd';
        Begin
             Insert Into tmp_fpasivo_fsd(saldo_mo,aocta,codigo_rubro,cuentas_key,tiempo_key,
                                         int_gen_mo,aomod,fecha,aotop,aoope,aosbo,ccliente,imp_garantia,aomda,
                                         naturaleza,seccod,seg_key,ind_empbco)
             Select x.saldo_mo - x.saldo_gar_mo , z.AOCTA, r.codigo_rubro,x.cuentas_key,
                    x.tiempo_key,x.int_gen_mo,z.aomod,
                    t.fecha,z.aotop,z.aoope,z.aosbo,m.codigo_cliente,x.saldo_gar_mo,z.aomda,
                    m.naturaleza,s.seccod,
                    PQ_TMP_CARGA_TRANSACC.fn_key_Segmento_cta(s.seccod,r.codigo_rubro,m.naturaleza),
                    pq_tmp_carga_facts_pas.fn_cuenta_empcaj(z.AOCTA) ind_empbco  
                    from dwhouse.fact_pasivo x
                    join dwhouse.dm_cuentas c 
                      on c.cuentas_key=x.cuentas_key
                    join dwstage.tmp_dm_cuenta z 
                      on z.codigo_cuenta=c.codigo_cuenta and z.cuenta_unica=c.cuenta_unica
                    join dwhouse.dm_tiempo t 
                      on t.tiempo_key=x.tiempo_key
                    join dwhouse.dm_rubro r 
                      on r.rubro_key = x.rubro_key
                    join dwhouse.dm_cliente m 
                      on m.cliente_key = x.cliente_key  
                    join dwextra.fsd008 s on s.ctnro=z.aocta  
                   Where t.fecha = ld_fecha;
         Exception When Others Then
            Null;
         End;       
         --- Actualiza Interes de CTS
         /*
         Execute Immediate 'Truncate Table t_int_cts';
         Insert Into t_int_cts(bcemp,bcsuc,bcrubr,bcmda,bcpap,bccta,bcoper,bcsbop,bctop,bcfech,
                               bcmod,bcint,bcsdmo)
         Select bcemp,bcsuc,bcrubr,bcmda,bcpap,bccta,bcoper,bcsbop,bctop,bcfech,
                               bcmod,bcint,bcsdmo
          From fsh012@produ
          Where bcfech = ld_fecha
            and bcmod=21 and bctop=2;
          Commit;
          */
                                                      
         /* -- Eliminar Comentario
          For x in c_intcts Loop
              Update tmp_fpasivo_fsd  
                 set int_gen_mo=pq_tmp_carga_transacc.fn_interes_cts(x.fecha,x.aocta,x.rrrubr,x.aomda,x.aoope,x.aosbo)
              Where aocta=x.aocta
              and aomod=x.aomod
              and aotop=x.aotop
              and aosbo=x.aosbo
              and aoope=x.aoope;
              Commit;
         End Loop;
         */
         
         ---- Dos Rubros
         For x In c_dosrub(ld_Fecha) Loop
             Update tmp_fpasivo_fsd  
                set ind_dosrub=x.dosrub
              Where aocta=x.bccta
              and aomod=x.bcmod
              and aotop=x.bctop
              and aosbo=x.bcsbop
              and aoope=x.bcoper;
              Commit; 
         End Loop;
         
     End If;
     
     --- Limpia campos de fsd
     Begin
        Update tmp_fpasivo_fsd
           set imp_fsd = null,int_fsd=null,
               gar_fsd = null,dii_fsd=null,
               ind_fsd = null;
        Commit;        
     Exception When Others Then
        Null;
     End;
     ---
     
         --execute immediate('truncate table  '||p_c_usuario||'.fbc510'); 
         begin 
             select max(ctnro),trunc(max(ctnro)/300)   
               into ln_max,ln_rango
               from dwextra.fsr008
              where ctnro <> 999999999;
              
              
         exception 
               when no_data_found then
                    ln_max := 0;
                     ln_rango:=0;
         end;    
         
         --lc_fecpro := to_char(ld_Fecha,'rrrrmmdd');
         
               
         x:=0;
         ln_job := 0;
         while x <= ln_max loop
              ln_ini := x+1;
              x:= x+ ln_rango;
              ln_fin := x;
              lc_variable := ' begin '||'  PQ_tmp_carga_transacc.sp_fsd_HIST('||ln_ini||','||ln_fin ||',' || to_char(ld_Fecha,'rrrrmmdd') || ');'|| ' End; ';
              ln_job := ln_job +1;
              -- dbms_output.put_line (lc_variable);
                 
               dbms_scheduler.create_job(
                 job_name=> 'fsd_HIST'||LPAD(TO_CHAR(ln_job),5,'0'),
                 job_type=> 'PLSQL_BLOCK',
                 job_action=> lc_variable,
                 start_date => sysdate+1/(24*180),
                 enabled => true, 
                 auto_drop=> TRUE,
                 comments => 'fsd_HIST'
                 );
              
             NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(pi_vc2_nomjob => 'fsd_hist%',
                                               pi_vc2_nomusr => USER);

             -- DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
              
              ---- INSERTA TABLA CONTROL

        /*      INSERT INTO Tab_jobs (c_codage,n_Numer1,c_detjob)
              VALUES('DMC',ln_ini,lc_variable);
              COMMIT;        */
          commit;
          end loop;
          /*++++++++++++++++++++  CONTROLA MAXIMO 50 JOBS*/
          --select count(*) into ln_mmxjob from user_scheduler_jobs;
          loop
         
             select count(*) into ln_mmxjob from user_scheduler_jobs
             where job_name like 'fsd_HIST%';
             
          Exit when ln_mmxjob = 0;
          End Loop;   
          /*++++++++++++++++++++*/
          
          
            Update tmp_fpasivo_fsd x
           set IND_FSD = 1
           Where not exists (select 1 
           from dwextra.fbc510 d where d.bc510id2=x.aocta);
            commit;
          
end sp_job_fsd_hist;
---------------------------------------------------------------------------------------------------------------
  PROCEDURE SP_JOB_OP_TRANSACCIONES(PD_FECHA In date)
  IS  
    Cursor c_trx1(ld_fec in date)
        is select hfcon,hcmod,htran,substr(hhora,1,2) hora 
            from dwextra.fsh015_16 
           where hfcon = ld_fec
             and hcmod < 500
           group by hfcon,hcmod,htran, substr(hhora,1,2);  
           
    lv_query varchar2(500);
    ln_job number(5) := 0;
    ln_mmxjob number(10);
  BEGIN
    
    -- Revisar que finalizaron los Jobs de Tarjetas
   Loop
       Select count(*) Into ln_job 
         From user_scheduler_jobs where job_name like 'DM_TARJETAS_%';
   Exit When ln_job = 0;    
   End Loop;
   
   Execute Immediate 'Truncate table tmp_fact_op_transaccion';
   Execute Immediate 'Truncate table err$_tmp_fact_op_transaccion';
   Execute Immediate 'Truncate table tmp_fact_op_trxcom';
   
    For x in c_trx1(PD_FECHA) Loop
        lv_query := 'Begin PQ_TMP_CARGA_TRANSACC.sp_op_transacciones('||
                    x.hcmod||','|| 
                    x.htran||','|| 
                    ''''||x.hora||''','||
                    ''''||to_char(x.hfcon,'rrrrmmdd')||''''|| 
                    '); End;';
        
        ln_job := ln_job +1;
              
        dbms_scheduler.create_job(
                 job_name=> 'FACT_OP_TRANSACC_'||LPAD(TO_CHAR(ln_job),5,'0'),
                 job_type=> 'PLSQL_BLOCK',
                 job_action=> lv_query,
                 start_date => sysdate+1/(24*180),
                 enabled => true, 
                 auto_drop=> TRUE,
                 comments => 'Carga TRANSACCIONES'
                 );
        -- CONTROLA MAXIMO 300 JOBS
        Loop
           select count(*) into ln_mmxjob from user_scheduler_jobs;
        Exit When ln_mmxjob <= 300;
        End Loop;
    End Loop;
    
    /*-- Modulo 99
    For x in c_trx2(PD_FECHA) Loop
        lv_query := 'Begin PQ_TMP_CARGA_TRANSACC.sp_op_transacciones('||
                    x.hnrel||','||
                    x.hnrel||','||   
                    '''99'','||
                    ''''||x.hora||''','||
                    ''''||to_char(x.hfcon,'rrrrmmdd')||''''|| 
                    '); End;';
        
        ln_job := ln_job +1;
              
        dbms_scheduler.create_job(
                 job_name=> 'FACT_OP_TRANSACC_'||LPAD(TO_CHAR(ln_job),5,'0'),
                 job_type=> 'PLSQL_BLOCK',
                 job_action=> lv_query,
                 start_date => sysdate+1/(24*180),
                 enabled => true, 
                 auto_drop=> TRUE,
                 comments => 'Carga TRANSACCIONES'
                 );
        -- CONTROLA MAXIMO 300 JOBS
        Loop
           select count(*) into ln_mmxjob from user_scheduler_jobs;
        Exit When ln_mmxjob <= 300;
        End Loop;
    End Loop;*/
      
  
  END SP_JOB_OP_TRANSACCIONES;     
---------------------------------------------------------------------------------------------------------------
  Procedure sp_op_transacciones (--pn_ctaini in number, pn_ctafin in number,
                                 --Pc_FECHA  in varchar2
                                 PN_CMOD  in number,
                                 PN_CTRX  in number,
                                 PV_HORA  in varchar2,
                                 PC_FECHA in varchar2 
                                )
  --------------------------------------------------------------------------------------
  -- Creación:
  ---------------------------------------------------------------------------------------
  -- Fecha  : 09/07/2018
  -- Autor  : 
  -- Cambios: 
  ---------------------------------------------------------------------------------------
  -- Fecha  : 2022-10-06
  -- Autor  : Paola Vargas
  -- Cambio : Insertar perfil de usuario de operaciones
  -----------------------------------------------------------------
  
  IS

   Cursor c_trx (/*ld_fech in date*/
                 ld_fech in date,ln_cmod in number,
                 ln_ctrx in number,lv_hora in varchar2)
           
   Is
          Select distinct t.pgcod,t.hcmod,t.hsucor,t.htran,t.hnrel,
                 case when t.hcmod = 488 then 27 --NIUBIZ
                      when t.hcmod=140 OR T.HSUCOR=901 then 3 --INTERNET
                      WHEN T.HCMOD=66 AND T.HTRAN = 55 THEN 18 --COM.ELEC
                      WHEN T.HCMOD=98 AND T.HTRAN=78 THEN 33 --'BCP FST'
                      when t.hcmod=66 and T.HSUCOR=907 then 4 -- MOVIL
                      WHEN T.HCMOD=66 AND T.HTRAN in (146,145,144,141,142,148,149,135,136,137) THEN 4 -- MOVIL
                      WHEN T.HCMOD=66 AND T.HTRAN in (62,60) THEN 4 -- MOVIL
                      WHEN T.HCMOD=66 AND T.HTRAN in (85,87) THEN 11 --POS NAC
                      WHEN T.HCMOD=66 AND T.HTRAN in (50) THEN 16 -- POS EXT
                      WHEN T.HCMOD=66 AND T.HTRAN in (12,27) THEN 20 --ATM VISA NAC
                      WHEN T.HCMOD=66 AND T.HTRAN = 14 THEN 21 --ATM UNICARD
                      WHEN T.HCMOD=66 AND T.HTRAN in (18,505,506) THEN 15 -- ATM GLOBALNET
                      WHEN T.HCMOD=66 AND T.HTRAN in (16,28) THEN 20--14 --ATM VISA EXT
                      WHEN T.HCMOD=66 OR T.HSUCOR=903 THEN 2 --ATM
                      WHEN T.HCMOD=490 THEN 5 --AGENTE
                      WHEN (T.HCMOD=30 AND T.HTRAN IN (276,273)) OR T.HSUCOR=905 THEN 9 --BN
                      WHEN T.HCMOD=98 AND T.HTRAN=80 THEN 7 --'SCOTIABANK'
                      WHEN T.HCMOD=10 AND T.HTRAN=251 THEN 7--'SCOTIABANK'
                      WHEN T.HCMOD=98 AND T.HTRAN=85 THEN 8 --'INTERBANK'
                      WHEN T.HCMOD=10 AND T.HTRAN=252 THEN 8 --'INTERBANK'
                      WHEN T.HCMOD=98 AND T.HTRAN=87 THEN 22 --'BANBIF'
                      WHEN T.HCMOD=10 AND T.HTRAN=250 THEN 22 --'BANBIF'
                      WHEN T.HCMOD=98 AND T.HTRAN=82 THEN 23 --'BCP'
                      WHEN T.HCMOD=10 AND T.HTRAN=249 THEN 23 --'BCP'
                      WHEN T.HCMOD=98 AND T.HTRAN=81 THEN 24 --'BBVA'
                      WHEN T.HCMOD=10 AND T.HTRAN=248 THEN 24 --'BBVA'
                      when t.hcmod=489 OR T.HSUCOR=907 then 4 -- MOVIL  
                      WHEN T.HSUCOR=908 THEN 10 --BILLETERA ELECT
                      WHEN T.HCMOD=493 THEN 6 --KASNET
                      When t.hcmod=492 Then 1 -- AGENCIA
                      WHEN T.HCMOD=18 AND T.HTRAN in (141,142) THEN 29 --'CCE'  
                      ELSE 1 --'AG'
                 END CANAL,
                 T.HFCON,T.HHORA,trim(T.HUSING) HUSING,T.HCCORR      
          from dwextra.fsh015_16 t 
          where ((t.hrubro like '11_102_%1' or t.hrubro like '11_102_%2' or t.hrubro like '11_102_%3') Or
                 (substr(t.hrubro,1,6) in ('191807','192807','291807','292807') /*and substr(t.hrubro,13,2) = 37*/) Or
                 (substr(t.hrubro,1,8) in ('19180901',19280901) and substr(t.hrubro,12,2) between 91 and 98) Or
                 (substr(t.hrubro,1,6) in ('111109','112109') and substr(t.hrubro,13,1) between 1 and 3) Or
                 (substr(t.hrubro,1,6) in ('521229','522229') and substr(t.hrubro,13,1) = 1) Or
                 (substr(t.hrubro,1,6) in ('191801','291807','192801','292807')) Or
                 (t.hrubro like '28_8010000001%') Or
                 (t.hmodul in (21,22)) Or
                 (substr(t.hrubro,1,4) in ('1411','1414','1415','1416','1421','1424','1425','1426','2918','2928'))
                )
          and t.hcmod < 500 and t.hfcon=ld_fech---;
          ----
          and t.hcmod = ln_cmod
          and t.htran = ln_ctrx
          and substr(t.hhora,1,2) = lv_hora; 
          ----



          
          --and hcmod = 66 and htran=16 and hnrel = 3 ;
          --and t.hcmod=22;
          --and  hcmod = 66 and htran=146 ;
           --and t.hsucor=1;
   Cursor c_det (ln_mod in number, ln_trx in number, ln_suc in number, ln_rel in number,ld_fechat in date) is
          Select f.hrubro,f.hcodmo,f.hmda,f.hmodul,f.hcta,f.hoper,f.hsubop,f.htoper,f.huscnf,f.hcord,f.hsucur,
                 sum(f.hcimp1) hcimp1--,f.hcsubo 
            from dwextra.fsh015_16 f
           where hcmod = ln_mod and hsucor = ln_suc and htran=ln_trx and hnrel=ln_rel
             and hcta <> 999999999
           --hcmod = 22 and hsucor = 62 and htran=800 and hnrel=3
             and f.hcord < 90 and f.hfcon=ld_fechat
         Group By f.hrubro,f.hcodmo,f.hmda,f.hmodul,f.hcta,f.hoper,f.hsubop,f.htoper,f.huscnf,f.hcord,f.hsucur
         Order by f.hcord;
               
   ln_imptrx number(12,2);
   lv_codcta varchar2(50);
   lv_ctauni varchar2(50);  
   lv_creuni varchar2(30);
   lv_codcli varchar2(30);
   ln_impcom number(12,2);  
   ln_debhab number(1);
   ln_dehaco number(1);
   ln_tipmov number(1);   
   ln_rubcaj number(3); -- se agrego a 3 por transaccion libre
   lv_moneda varchar2(4);
   ln_debhab_2 number(1);
   ln_imptrx_2 number(12,2); 
   ln_usuari_2 varchar2(10); 
   lv_moneda_2 varchar2(4);
   ln_detcan number(10);
   lv_codcan varchar2(30);
   lv_imptrx_mn number(12,2);
   lv_imptrx_mn_2 number(12,2);
   lv_Feccar varchar2(10) := pq_tmp_carga_facts.FN_VALOR_PARAMETRO('1');
   ln_tipcam number(7,3) := pq_tmp_carga_facts.fn_tipo_cambio_fijo(to_date(lv_feccar,'dd-mm-rrrr'));
   ln_keyatm number(10);
   ld_fechatran date:=to_date(pc_fecha,'yyyymmdd');
   LN_TARJETA NUMBER(10);
   ln_job     Number(5);
   lc_msgerr  varchar2(300);
   ln_ranhor Number(5);
   ln_regope Number(5);
   ln_keyext Number(5);
   ln_rngimp Number(5);
   ln_comagn Number(12,2); -- Comision agentes
   ln_colcap Number(5);
   ln_rubro Number(13);
   lv_propas varchar2(5);
   lv_sprpas varchar2(5);
   lv_succta varchar2(4);
   ln_rubpas number(16);
   ln_diapag number(5);
   ln_spract number(4);
   ln_proact number(4);
   ln_plazo  number(4);
   ln_tasint number(9,5);
   ln_modcre number(3);
   
   ln_taspas Number(10,6);
   ln_impcap Number(12,2);
   ln_hmodul Number(4);
   ln_hmda   Number(4);
   ln_hcta   Number(9);
   ln_hoper  Number(9);
   ln_htoper Number(4);
   ln_hsubop Number(4);
   ln_hrubro Number(16);
   ln_mtotrx Number(12,2);
   ln_mtotrx_mn Number(12,2);
   ln_debhab_nw Number(3);
   lv_moneda_nw Number(4);
   ln_tipmov_nw Number(3);
   ln_kpais Number(10); 
   ln_kcpos Number(10);
   
   lv_prfcod tmp_dm_perfil_usu.prfgcod%type;
   ln_keyprf tmp_dm_perfil_usu.key_perfil%type; 
   ln_keygaf number(10); -- Geografia de afiliacion de tarjeta
   
   --GooglePlay    
   nGplay Number(5);
   lnMod  Number(5);    
   lnTrx  Number(10); 
      
Begin
   
   /*begin
           -- Call the procedure
           dwextra.pq_tmp_extrae_fuentes.sp_tb_re_indice_fsh015_16(p_n_codtab => 64,
                                                  p_c_tbspidx => 'DWEXTRA_IDX',
                                                  p_c_usuario => 'DWEXTRA');
   end;
   */
   For z in c_trx (ld_fechatran,PN_CMOD,PN_CTRX,PV_HORA)Loop
       ln_imptrx := 0;
       ln_debhab := null;
       ln_impcom := 0;
       ln_dehaco := null;
       ln_tipmov := 2;
       ln_rubcaj := 0;
       ln_debhab_2:= null;
       ln_imptrx_2:= 0;
       ln_usuari_2:= null;
       lv_moneda := null;
       lv_moneda_2:=null;
       lv_codcta := null;
       lv_ctauni := null;
       lv_creuni := null;
       lv_codcli := null;
       lv_codcan := null;
       ln_detcan := null;
       lv_imptrx_mn:=0;
       lv_imptrx_mn_2:=0;
       ln_keyatm := null;
       lv_propas := null;
       lv_sprpas := null;
       lv_succta := null;
       
       ln_taspas := 0;
       ln_impcap := 0;
       ln_hmodul := null;
       ln_hmda   := null;
       ln_hcta   := null;
       ln_hoper  := null;
       ln_htoper := null;
       ln_hsubop := null;
       ln_hrubro := null;
       ln_mtotrx := 0;
       ln_mtotrx_mn:= 0;
       ln_debhab_nw:= null;
       lv_moneda_nw:= null;
       ln_tipmov_nw:= ln_tipmov;
       ln_keygaf := 117893;
       
       
       LN_TARJETA:= pq_tmp_carga_transacc.fn_key_tarjeta('000');
       ln_ranhor := pq_tmp_carga_transacc.fn_rango_hora(z.HHORA);
       ln_proact := '-1';
       ln_spract := '-1';
       
          
                     
       For x in c_det(z.hcmod,z.htran,z.hsucor,z.hnrel,ld_fechatran) Loop
           
           ln_regope := pq_tmp_carga_transacc.fn_cod_region_op(z.hsucor,ld_fechatran);
           lnMod := z.hcmod;    
           lnTrx := z.htran;
       
           
           If z.canal <> 2 and ln_detcan is null Then
              If    z.canal = 1  Then lv_codcan:= to_char(z.hsucor);
              Elsif z.canal = 3  Then lv_codcan:= '901';
              Elsif z.canal = 4  Then lv_codcan:= '905'; 
              Elsif z.canal = 6  Then lv_codcan:= '802';
              Elsif z.canal = 7  Then lv_codcan:= '803';
              Elsif z.canal = 8  Then lv_codcan:= '804';
              Elsif z.canal = 9  Then lv_codcan:= '902';
              Elsif z.canal = 22  Then lv_codcan:= '806';
              Elsif z.canal = 23  Then lv_codcan:= '807';
              Elsif z.canal = 24  Then lv_codcan:= '808';
              Elsif z.canal = 10 Then lv_codcan:= '908';
              Elsif z.canal = 14 Then lv_codcan:= '816';
              Elsif z.canal = 15 Then lv_codcan:= '807';
              Elsif z.canal = 18 Then lv_codcan:= '810';
              Elsif z.canal = 20 Then lv_codcan:= '815';
              Elsif z.canal = 21 Then lv_codcan:= '805';
              Elsif z.canal = 29 Then lv_codcan:= '904';
              Elsif z.canal = 27 Then lv_codcan:= '907';
              Elsif z.canal = 33  Then lv_codcan:= '907';
              Elsif z.canal = 5 Then lv_codcan:= pq_tmp_carga_transacc.fn_cod_agente(z.hfcon,z.hcmod,z.hsucor,z.htran,z.hnrel);
              End If;
              ln_detcan := pq_tmp_carga_transacc.fn_key_detcanal(lv_codcan,z.canal);
           End If;
           
           If x.hrubro in (1111020000001,1111020000002,1111020000003,1121020000001,1121020000002,1121020000003) Then
              If  x.hrubro in (1111020000001,1121020000001) then
                 ln_keyatm := pq_tmp_carga_transacc.fn_key_atm(x.hsubop);
              End If;  
              If z.canal = 2 and ln_detcan is null Then
                 ln_detcan := pq_tmp_carga_transacc.fn_key_detcanal(to_char(x.hsubop),z.canal);
              End If;
              
              ln_rubcaj := ln_rubcaj + 1;
              If ln_rubcaj = 1 Then
                 ln_imptrx := x.hcimp1;
                 ln_debhab := x.hcodmo;
                 ln_tipmov := 1;
                 lv_moneda := x.hmda;
              ElsIf ln_rubcaj = 2 Then
                 ln_debhab_2:= x.hcodmo;
                 ln_imptrx_2:= x.hcimp1;
                 ln_usuari_2:= x.huscnf;
                 lv_moneda_2:= x.hmda;
              End If;
                
              ElsIf substr(x.hrubro,1,6) in ('292807','291807') and substr(x.hrubro,12,2)=28 then
                    ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda;                   
                    If z.canal = 16 then 
                       ln_detcan := pq_tmp_carga_transacc.fn_key_detcanal('808',16);
                    Elsif z.canal = 2 then 
                       ln_detcan := pq_tmp_carga_transacc.fn_key_detcanal('903',16);   
                    ElsIF (z.canal = 14) or (x.hsucur <> 903 and ln_detcan is null) then   
                       ln_detcan := pq_tmp_carga_transacc.fn_key_detcanal('805',14);
                    ElsIf x.hsucur=903 and ln_detcan is null then
                        ln_detcan := pq_tmp_carga_transacc.fn_key_detcanal(to_char(x.hsucur),11);
                    End If;
                 --End If;
                 /*If substr(x.hrubro,1,6) in ('292807','291807') and substr(x.hrubro,12,2)=28 and x.hsucur=903 and ln_detcan is null then
                    ln_detcan := pq_tmp_carga_transacc.fn_key_detcanal(to_char(x.hsucur),11);
                 Elsif substr(x.hrubro,1,6) in ('292807','291807') and substr(x.hrubro,12,2)=28 and x.hsucur <> 903 and ln_detcan is null then
                    ln_detcan := pq_tmp_carga_transacc.fn_key_detcanal('805',2);
                 End If;*/
           ElsIf (substr(x.hrubro,1,8) in ('19180901',19280901) and substr(x.hrubro,12,2) between 91 and 99) Then
                 If nvl(ln_imptrx,0) = 0 then ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda; End If;
           ElsIf (substr(x.hrubro,1,6) in ('111109','112109') and substr(x.hrubro,13,1) between 1 and 3) Then
                 If nvl(ln_imptrx,0) = 0 then ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda; End If;
           Elsif substr(x.hrubro,1,6) in ('191807','192807') and substr(x.hrubro,12,2) in (37,40) Then
                 If nvl(ln_imptrx,0) = 0 then ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda; End If;
           Elsif substr(x.hrubro,1,4) in ('4619','4629') and substr(x.hrubro,12,2) = 10 Then
                 If nvl(ln_imptrx,0) = 0 then ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda; End If;
           ElsIf --(substr(x.hrubro,1,8) in ('291809','292809')) Then
                 (substr(x.hrubro,1,4) in ('2918','2928')) Then
                 If nvl(ln_imptrx,0) = 0 then ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda; End If;
           ElsIf z.hcmod = 99 and z.htran = 73 and x.hcord = 80 then -- Cuota Diferida
                 ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda;
           --Elsif substr(x.hrubro,1,6) in ('521229','522229') and substr(x.hrubro,12,2) = 61 and ln_detcan is null Then
           ElsIf --(substr(x.hrubro,1,8) in ('291809','292809')) Then
                 (substr(x.hrubro,1,6) in ('251419','252419')) Then
                 If nvl(ln_imptrx,0) = 0 then ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda; End If;
              
           ElsIf substr(x.hrubro,1,6) in ('421229','422229') Then
                 If nvl(ln_imptrx,0) = 0 then ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda; End If;
           End If;

           -- Cuenta de depositos
           If x.hmodul in (21,22,426) Then
              --
              If z.canal = 5 Then
                 Select count(*) Into ln_colcap
                   from dwextra.jaql006 h
                  Where h.jaql6cta02 = x.hcta
                    and h.jaql6ope02 = x.hoper
                    and h.jaql6mda02 = x.hmda
                    and h.jaql6sbo02 = x.hsubop
                    and h.jaql6top02 = x.htoper
                    and h.jaql6ctmod = z.hcmod
                    and h.jaql6cttra = z.htran
                    and h.jaql6ctrel = z.hnrel
                    and h.jaql6ctfco = z.hfcon;
              Else
                 ln_colcap := 0;
              End If;
              
              If ln_colcap = 0 Then
                  If z.hcmod <> 490 Then
                     lv_codcli := pq_tmp_carga_transacc.fn_CODCLIENTE(x.hcta);
                  End If;
                  
                  lv_codcta:= (case when x.hmodul=426 then 22 else x.hmodul end)||'-'||x.hmda||'-'||x.hcta||'-'||x.hoper||'-'||x.hsubop||'-'||x.htoper;
                  If length(lv_codcta) > 30 then
                     dbms_output.put_line(z.hcmod||'-'||z.hsucor||'-'||z.htran||'-'||z.hnrel||':'||lv_codcta); 
                  End If;
                  lv_ctauni:= lv_codcta;
                     If x.hmodul in (22,426) Then
                        lv_ctauni := '22-'||x.hmda||'-'||x.hcta||'-'||x.hoper;
                     End If;   
              
                  If z.hcmod = 22 and x.hmodul = 22 Then
                     ln_imptrx:= x.hcimp1;
                     ln_debhab := x.hcodmo;
                     lv_moneda := x.hmda;
                  ElsIf z.hcmod = 22 and x.hmodul = 21 and x.hcimp1 > ln_imptrx Then
                     ln_imptrx:= x.hcimp1;
                     ln_debhab := x.hcodmo;
                     lv_moneda := x.hmda;
                  ElsIf z.hcmod <> 22 and x.hmodul = 426 /*and lv_ctadep is null*/ Then
                     ln_imptrx:= x.hcimp1;
                     --lv_ctadep := '22-'||x.hmda||'-'||x.hcta||'-'||x.hoper||'-'||x.hsubop||'-'||x.htoper;
                  ElsIf z.hcmod <> 22 Then
                     If nvl(ln_imptrx,0) = 0 Or x.hcimp1 > ln_imptrx then 
                        ln_imptrx:= x.hcimp1;
                        ln_debhab := x.hcodmo;
                        lv_moneda := x.hmda; 
                     End If;
                     --lv_ctadep := x.hmodul||'-'||x.hmda||'-'||x.hcta||'-'||x.hoper||'-'||x.hsubop||'-'||x.htoper;
                  End If;
              End If;
              -- Producto
              lv_succta := '0';
              ln_rubpas := x.hrubro;
              If x.hmodul = 426 Then
                 Begin 
                     Select u.rubro Into ln_rubpas
                       From dwextra.fsr014  u
                      Where rrrubr = x.hrubro 
                        and rrcod=1;
                 Exception When Others Then
                     ln_rubpas := x.hrubro;
                 End;
              End If;
              
              If x.hmodul in (22,426) and /*.hrubro*/ln_rubpas like '28_101%' then lv_propas := '221';
              ElsIf x.hmodul in (22,426) and ln_rubpas not like '28_101%' then lv_propas := x.hmodul;
              ElsIf x.hmodul = 21 and x.htoper = 2 then lv_propas := to_char(x.hmodul)||'1';
              ElsIf x.hmodul = 21 and x.htoper <> 2 then lv_propas := x.hmodul;
              Else lv_propas := '0';
              End If;
              -- SubProducto
              If x.hmodul = 21 and x.htoper not in (0,2) then lv_sprpas := x.htoper;
              ElsIf x.hmodul = 21 and x.htoper = 0 then lv_sprpas := '1';
              ElsIF x.hmodul in (22,426) and ln_rubpas like '28_101%' then lv_sprpas:= substr(x.hrubro,13,1);
              ElsIF x.hmodul in (22,426) and ln_rubpas not like '28_101%' and x.htoper in (0,1,5) then lv_sprpas:='1';
              ElsIF x.hmodul in (22,426) and ln_rubpas not like '28_101%' and x.htoper not in (0,1,5) then lv_sprpas := x.htoper;
              ElsIf x.hmodul = 21 and x.htoper = 2 Then
                    Begin
                       select bctasa 
                         into ln_tasint 
                         from dwextra.fsh012 
                        where bcmod=x.hmodul and bccta=x.hcta and bcoper=x.hoper 
                          and bcsbop=x.hsubop and bctop=x.htoper and bcmda=x.hmda;
                   Exception When Others Then
                      ln_tasint := 0;
                   End;       
                   lv_sprpas := pq_tmp_carga_facts.fn_tipo_cts(x.hmda,ln_tasint,z.HFCON);
              Else
                 lv_sprpas := '0'; 
              End If;
              
              If lv_propas Is not Null Then
                 lv_succta := x.hsucur; 
              End If;
              
           End If;
           -- Nro. de credito
           If substr(x.hrubro,1,4) in (1411,1421,1414,1424,1415,1425,1416,1426) Then
              ln_modcre := x.hmodul;
         
              
              lv_creuni := pq_tmp_carga_facts.fn_credito_unico(z.pgcod,ln_modcre,x.hmda,x.hcta,x.hoper,x.hsubop,x.htoper);
              If lv_codcli is null and z.hcmod <> 490 Then
                 lv_codcli := pq_tmp_carga_transacc.fn_CODCLIENTE(x.hcta);
              End If;
              -- Producto
              --Plazo
              Begin
                 Select d.aopzo Into ln_plazo
                   from tmp_dm_credito d
                  where d.aomod = ln_modcre
                    and d.aomda = x.hcta
                    and d.aocta = x.hcta
                    and d.aoope = x.hoper
                    and d.aosbo = x.hsubop
                    and d.aotop = x.htoper;
              Exception When Others Then
                 ln_plazo := 0;
              End;
              
              ln_proact := pq_tmp_carga_facts.fn_modulo_origen(1,ln_modcre,x.hmda,x.hcta,x.hoper,x.hsubop,x.htoper,ln_plazo,
                                                  (case When ln_modcre in (33,65) and x.hrubro Is null 
                                                        Then PQ_TMP_CARGA_FACTS.fn_tipo_credito_casven(1,ln_modcre,x.hmda,x.hcta,x.hoper,x.hsubop,x.htoper)
                                                            When substr(x.hrubro,5,2)='03' and x.hmodul=116 Then 31 
                                                            Else to_number(substr(x.hrubro,5,2))
                                                       end),
                                                      x.hrubro);
              ln_spract := pq_tmp_carga_facts.fn_tipope_origen(1,ln_modcre,x.hmda,x.hcta,x.hoper,x.hsubop,x.htoper,ln_plazo,
                                                      (case When ln_modcre in (33,65) and x.hrubro Is null 
                                                        Then PQ_TMP_CARGA_FACTS.fn_tipo_credito_casven(1,ln_modcre,x.hmda,x.hcta,x.hoper,x.hsubop,x.htoper)
                                                            When substr(x.hrubro,5,2)='03' and x.hmodul=116 Then 31 
                                                            Else to_number(substr(x.hrubro,5,2))
                                                       end),
                                                      x.hrubro);
                                                      
              
              
              
              -- Dias atraso
              Begin
                 Select (p.pp1fech) - (p.ppfpag)
                   Into ln_diapag
                   From dwextra.fsd602 p
                  Where p.d602mo = z.hcmod
                    and p.d602su = z.hsucor
                    and p.d602tr = z.htran
                    and p.d602re = z.hnrel
                    and p.d602fc = z.hfcon
                    and rownum = 1; 
              Exception When Others Then
                 ln_diapag := null;
              End;
           End If;
           -- Comisión
           If (substr(x.hrubro,1,6) in ('521229','522229') )
             /* and substr(x.hrubro,12,2) in ('01','74','75','26','61')) */ Then
              ln_impcom:=x.hcimp1; 
              ln_dehaco:= x.hcodmo;
              ln_rubro := x.hrubro;
           End If;
           -- Cliente para Agentes
           If z.hcmod = 490 and x.hcord = 10 Then
              lv_codcli := pq_tmp_carga_transacc.fn_CODCLIENTE(x.hcta);
           End If;
       
       End Loop; 
       --- FINALIZA DETALLE
       -- Revisar detcanal de ATM
       
       IF Z.CANAL in (2,15) then 
          LN_TARJETA:= pq_tmp_carga_transacc.fn_tarjeta_trx(z.hcmod,z.htran,z.hnrel,z.hfcon);
       end if;
       If z.canal = 2 and ln_detcan Is Null Then
          Begin
               Select to_char(to_number(c.jaql540coter))
                 Into lv_codcan
                 From jaql540@produ c--dwextra.jaql540 c
                Where c.jaql540feini = z.hfcon
                  and c.jaql540modul = z.hcmod
                  and c.jaql540trans = z.htran
                  and c.jaql540relac = z.hnrel;
               ln_detcan := pq_tmp_carga_transacc.fn_key_detcanal(lv_codcan,z.canal);   
          Exception When Others Then
               ln_detcan := null;
          End; 
       End If;
       
       lv_imptrx_mn := ln_imptrx;
       If lv_moneda = '101' Then
          lv_imptrx_mn := ln_imptrx*ln_tipcam;
       End If;   
       If lv_codcli Is Null Then
          lv_codcli := '0';
       End If;   
       -- Motivo de extorno
       If z.HCCORR = 99 Then
          ln_keyext := PQ_TMP_CARGA_TRANSACC.fn_key_motext(z.pgcod,z.hsucor,z.hcmod,z.htran,z.hnrel,z.HFCON);
       Else 
          ln_keyext := 0;          
       End If;
       
       -- Rango de importe exp.en moneda nacional
       ln_rngimp := pq_tmp_carga_transacc.fn_rango_importe(nvl(lv_imptrx_mn,0));
       If z.HCCORR <> 99 Then
          ln_comagn := pq_tmp_carga_transacc.fn_porcom_agente(z.hcmod,z.htran,ln_rngimp);
       Else
          ln_comagn := 0;
       End If;
       
       ----------------------------
       ---  NUEVO:CUENTA PASIVO
       ---
       Begin
         Select x.hrubro,x.hmodul,x.hmda,x.hcta,x.hoper,x.htoper,x.hsubop,x.hsucur
           Into ln_hrubro,ln_hmodul,ln_hmda,ln_hcta,ln_hoper,ln_htoper,ln_hsubop,lv_succta
           FRom dwextra.fsh015_16 x
           Join dwextra.ext_op_trasacc t
             on t.trmod = x.hcmod
            and t.trtra = x.htran
            and t.trord = x.hcord
            and t.trsbor= x.hcsubo
          Where x.pgcod = 1
            and x.hfcon = z.HFCON
            and x.hcmod = z.hcmod
            and x.hsucor= z.hsucor
            and x.htran = z.htran
            and x.hnrel = z.hnrel
            and t.trcon in ('P');
       Exception When Others Then
          ln_hmodul := null;
       End;
       
       If ln_hmodul Is Not Null Then
          -- Importe
          Begin
               Select x.hcimp1,decode(x.hmda,101,x.hcimp1*ln_tipcam,x.hcimp1),x.hcodmo,x.hmda,
                      (case when t.trcon = 'E' then decode(x.hcodmo,1,2,1) else x.hcodmo end)
                 Into ln_mtotrx,ln_mtotrx_mn,ln_debhab_nw,lv_moneda_nw,ln_tipmov_nw
                 FRom dwextra.fsh015_16 x
                 Join dwextra.ext_op_trasacc t
                   on t.trmod = x.hcmod
                  and t.trtra = x.htran
                  and t.trord = x.hcord
                  and t.trsbor= x.hcsubo
                Where x.pgcod = 1
                  and x.hfcon = ld_fechatran
                  and x.hcmod = z.hcmod
                  and x.hsucor= z.hsucor
                  and x.htran = z.htran
                  and x.hnrel = z.hnrel
                  and t.trcon in ('E','O');
          Exception When Others Then
             ln_mtotrx := null;
          End;
          IF ln_mtotrx IS Not Null Then
             ln_imptrx    := ln_mtotrx;
             lv_imptrx_mn := ln_mtotrx_mn;
             ln_debhab    := ln_debhab_nw;
             lv_moneda    := lv_moneda_nw;
             ln_tipmov    := ln_tipmov_nw;
          End If;
          
          lv_codcli := pq_tmp_carga_transacc.fn_CODCLIENTE(ln_hcta);

          If ln_hmodul in (22,426) Then
              -- Tasa de Interes
             Begin
                 Select x.hctasa
                   Into ln_taspas
                   FRom dwextra.fsh015_16 x
                   Join dwextra.ext_op_trasacc t
                     on t.trmod = x.hcmod
                    and t.trtra = x.htran
                    and t.trord = x.hcord
                    and t.trsbor= x.hcsubo
                  Where x.hfcon = z.hfcon
                    and x.hcmod = z.hcmod
                    and x.hsucor= z.hsucor
                    and x.htran = z.htran
                    and x.hnrel = z.hnrel
                    and t.trcon in ('T');
             Exception When Others Then
                 ln_taspas := 0;
             End;
             -- Importe de Capital
             Begin
                 Select x.hcimp1
                   Into ln_impcap
                   FRom dwextra.fsh015_16 x
                   Join dwextra.ext_op_trasacc t
                     on t.trmod = x.hcmod
                    and t.trtra = x.htran
                    and t.trord = x.hcord
                    and t.trsbor= x.hcsubo
                  Where x.hfcon = z.hfcon
                    and x.hcmod = z.hcmod
                    and x.hsucor= z.hsucor
                    and x.htran = z.htran
                    and x.hnrel = z.hnrel
                    and t.trcon in ('C');
             Exception When Others Then
                 ln_impcap := 0;
             End;
          End If;
          --- Operacion: Cuenta/Credito
          lv_codcta := ln_hmodul||'-'||ln_hmda||'-'||ln_hcta||'-'||ln_hoper||'-'||ln_hsubop||'-'||ln_htoper;
          lv_ctauni := lv_codcta;
          
          If ln_hmodul in (426,22) Then
             lv_codcta := '22-'||ln_hmda||'-'||ln_hcta||'-'||ln_hoper||'-'||ln_hsubop||'-'||ln_htoper;
             lv_ctauni := '22-'||ln_hmda||'-'||ln_hcta||'-'||ln_hoper;
          End If;
          -- Produto y Subproducto Pasivo
          ln_rubpas := ln_hrubro;
          If ln_hmodul = 426 Then
             ln_hmodul := 22;
             Begin
                 Select u.rubro Into ln_rubpas
                   From dwextra.fsr014  u
                  Where rrrubr = ln_hrubro
                    and rrcod=1;
             Exception When Others Then
                  ln_rubpas := ln_hrubro;
             End;
          End If;

          If ln_hmodul in (22,426) and ln_rubpas like '28_101%' then lv_propas := '221';
          ElsIf ln_hmodul in (22,426) and ln_rubpas not like '28_101%' then lv_propas := ln_hmodul;
          ElsIf ln_hmodul = 21 and ln_htoper = 2 then lv_propas := to_char(ln_hmodul)||'1';
          ElsIf ln_hmodul = 21 and ln_htoper <> 2 then lv_propas := ln_hmodul;
          Else  lv_propas := '0';
          End If;

          -- SubProducto
          If    ln_hmodul = 21 and ln_htoper not in (0,2) then lv_sprpas := ln_htoper;
          ElsIf ln_hmodul = 21 and ln_htoper = 0 then lv_sprpas := '1';
          ElsIF ln_hmodul in (22,426) and ln_rubpas like '28_101%' then lv_sprpas:= substr(ln_rubpas,13,1);
          ElsIF ln_hmodul in (22,426) and ln_rubpas not like '28_101%' and ln_htoper in (0,1,5) then lv_sprpas:='1';
          ElsIF ln_hmodul in (22,426) and ln_rubpas not like '28_101%' and ln_htoper not in (0,1,5) then lv_sprpas := ln_htoper;
          ElsIf ln_hmodul = 21 and ln_htoper = 2 Then
                Begin
                   select bctasa
                     into ln_tasint
                     from dwextra.fsh012
                    where bcmod=ln_hmodul and bccta=ln_hcta and bcoper=ln_hoper
                      and bcsbop=ln_hsubop and bctop=ln_htoper and bcmda=ln_hmda;
                Exception When Others Then
                  ln_tasint := 0;
                End;
                lv_sprpas := pq_tmp_carga_facts.fn_tipo_cts(ln_hmda,ln_tasint,z.HFCON);
          Else
                lv_sprpas := '0';
          End If;
       End If;
       ----------------------------
       -- CREDITOS
       ----
       Begin
           Select x.hcimp1,decode(x.hmda,101,x.hcimp1*ln_tipcam,x.hcimp1),x.hcodmo,x.hmda,
                  (case when t.trcon = 'E' then decode(x.hcodmo,1,2,1) else x.hcodmo end),
                  x.hrubro,x.hmodul,x.hmda,x.hcta,x.hoper,x.htoper,x.hsubop,x.hsucur
             Into ln_mtotrx,ln_mtotrx_mn,ln_debhab_nw,lv_moneda_nw,ln_tipmov_nw,
                  ln_hrubro,ln_hmodul,ln_hmda,ln_hcta,ln_hoper,ln_htoper,ln_hsubop,lv_succta
             FRom dwextra.fsh015_16 x
             Join dwextra.ext_op_trasacc t
               on t.trmod = x.hcmod
              and t.trtra = x.htran
              and t.trord = x.hcord
              and t.trsbor= x.hcsubo
            Where x.pgcod = 1
              and x.hfcon = ld_fechatran
              and x.hcmod = z.hcmod
              and x.hsucor= z.hsucor
              and x.htran = z.htran
              and x.hnrel = z.hnrel
              and t.trcon = 'A'
              and rownum = 1;
       Exception When Others Then
              ln_mtotrx := null;
              ln_hmodul := null;
       End;
       
       If substr(ln_hrubro,1,4) not in ('1411','1421','1414','1424','1415','1425','1416','1426') Then
          -- BUSCA MODULO DE CREDITO
          Begin
               select aomod,aotop Into ln_hmodul,ln_htoper
                 from tmp_dm_credito 
                where aocta = ln_hcta 
                  and aoope = ln_hoper 
                  and aomda = ln_hmda
                  and aosbo = ln_hsubop
                  and rownum=1;
          Exception When Others Then
             ln_hmodul := null;
             ln_htoper := null;
          End;           		
       End If;  
       
       If ln_hmodul Is Not Null Then
          --lv_succta
          lv_creuni := pq_tmp_carga_facts.fn_credito_unico(z.pgcod,ln_hmodul,ln_hmda,ln_hcta,ln_hoper,ln_hsubop,ln_htoper);
          If nvl(lv_codcli,'0') = '0' and z.hcmod <> 490 Then
             lv_codcli := pq_tmp_carga_transacc.fn_CODCLIENTE(ln_hcta);
          End If;
          --Plazo
          Begin
             Select d.aopzo Into ln_plazo
               from tmp_dm_credito d
              where d.aomod = ln_hmodul
                and d.aomda = ln_hmda
                and d.aocta = ln_hcta
                and d.aoope = ln_hoper
                and d.aosbo = ln_hsubop
                and d.aotop = ln_htoper;
          Exception When Others Then
             ln_plazo := 0;
          End;
          ln_proact := pq_tmp_carga_facts.fn_modulo_origen(z.pgcod,ln_hmodul,ln_hmda,ln_hcta,ln_hoper,ln_hsubop,ln_htoper,ln_plazo,
                                                  (case When ln_modcre in (33,65) and ln_hrubro Is null 
                                                        Then PQ_TMP_CARGA_FACTS.fn_tipo_credito_casven(z.pgcod,ln_hmodul,ln_hmda,ln_hcta,ln_hoper,ln_hsubop,ln_htoper)
                                                            When substr(ln_hrubro,5,2)='03' and ln_hmodul=116 Then 31 
                                                            Else to_number(substr(ln_hrubro,5,2))
                                                       end),
                                                      ln_hrubro);
          ln_spract := pq_tmp_carga_facts.fn_tipope_origen(z.pgcod,ln_hmodul,ln_hmda,ln_hcta,ln_hoper,ln_hsubop,ln_htoper,ln_plazo,
                                                      (case When ln_modcre in (33,65) and ln_hrubro Is null 
                                                        Then PQ_TMP_CARGA_FACTS.fn_tipo_credito_casven(z.pgcod,ln_hmodul,ln_hmda,ln_hcta,ln_hoper,ln_hsubop,ln_htoper)
                                                            When substr(ln_hrubro,5,2)='03' and ln_hrubro=116 Then 31 
                                                            Else to_number(substr(ln_hrubro,5,2))
                                                       end),
                                                      ln_hrubro);
          -- Dias atraso
          Begin
             Select (p.pp1fech) - (p.ppfpag)
               Into ln_diapag
               From dwextra.fsd602 p
              Where p.d602mo = z.hcmod
                and p.d602su = z.hsucor
                and p.d602tr = z.htran
                and p.d602re = z.hnrel
                and p.d602fc = z.hfcon
                and rownum = 1; 
          Exception When Others Then
             ln_diapag := null;
          End;                                            
       End If;       
       
       If nvl(ln_imptrx,0) = 0 and nvl(ln_mtotrx,0) = 0 Then
          Begin
               Select x.hcimp1,decode(x.hmda,101,x.hcimp1*ln_tipcam,x.hcimp1),x.hcodmo,x.hmda,
                      (case when t.trcon = 'E' then decode(x.hcodmo,1,2,1) else x.hcodmo end)
                 Into ln_mtotrx,ln_mtotrx_mn,ln_debhab_nw,lv_moneda_nw,ln_tipmov_nw
                 FRom dwextra.fsh015_16 x
                 Join dwextra.ext_op_trasacc t
                   on t.trmod = x.hcmod
                  and t.trtra = x.htran
                  and t.trord = x.hcord
                  and t.trsbor= x.hcsubo
                Where x.pgcod = 1
                  and x.hfcon = ld_fechatran
                  and x.hcmod = z.hcmod
                  and x.hsucor= z.hsucor
                  and x.htran = z.htran
                  and x.hnrel = z.hnrel
                  and t.trcon in ('E','O');
          Exception When Others Then
             ln_mtotrx := null;
          End;
       End If;
       
       -- Cliente compra/venta dólares
       If z.hcmod = 50 and z.htran in (535,536) Then
          lv_codcli := PQ_TMP_CARGA_TRANSACC.fn_cliente_compraventa(z.pgcod,z.hcmod,z.htran,z.hsucor,z.hnrel,z.hfcon);
       End If;
     
       
       IF nvl(ln_mtotrx,0) <> 0 and nvl(ln_imptrx,0) = 0 Then
         ln_imptrx    := ln_mtotrx;
         lv_imptrx_mn := ln_mtotrx_mn;
         ln_debhab    := ln_debhab_nw;
         lv_moneda    := lv_moneda_nw;
         ln_tipmov    := ln_tipmov_nw;
       End If;
       
       -- PAIS/ESTADO DONDE REALIZA TRX
       ln_kpais := pq_tmp_carga_transacc.fn_key_pais_estdep(z.hfcon,z.hcmod,z.htran,z.hnrel,z.hsucor);
       ln_kcpos := pq_tmp_carga_transacc.fn_key_comercio_pos(z.hfcon,z.hcmod,z.htran,z.hnrel,z.hsucor);
       IF ln_kpais <> 1 Or ln_kcpos <> 1 then 
          LN_TARJETA:= pq_tmp_carga_transacc.fn_tarjeta_trx(z.hcmod,z.htran,z.hnrel,z.hfcon);
       end if;
       
       --- PERFIL DE USUARIO------
       --- 2022-10-06
       lv_prfcod := PQ_TMP_CARGA_TRANSACC.fn_perfil_usuario(z.HUSING);
       ln_keyprf := PQ_TMP_CARGA_TRANSACC.fn_key_perfil_usu(lv_prfcod);
       ---------------------------
       
       --- Geografia de afiliacion de tarjeta
       Begin
           Select d.key_geografia Into ln_keygaf
             from dwhouse.dm_tarjeta d
            Where d.key_tarjeta = LN_TARJETA; 
       Exception When Others Then
          ln_keygaf := 117893;
       End; 
       
       ---- Google Play ------
       If z.hcmod = 66 and z.htran = 85 Then
          Begin
               Select count(*) Into nGplay
                 from JAQL539@produ a
                 Join JAQL540@produ b on b.jaql540cotra = a.jaql539cotra
                Where jaql540feini =  z.HFCON
                  and a.jaql539nucam = 60
                  and b.JAQL540modul = z.hcmod
                  and b.JAQL540trans = z.htran
                  and b.JAQL540relac = z.hnrel
                  and substr(a.jaql539valtr,9,1) = '4';
          Exception When Others Then
             nGplay := 0;
          End;  
          
          If nGplay > 0 Then
             lnMod := z.hcmod;
             lnTrx := 8504; 
          End If;

       End If;
       
       ------------------------
       ----------------------------
       -- Inserta registro
       Insert Into tmp_fact_op_transaccion(fecha, hora, pgcod, hcmod, hsucor, htran, hnrel,
                                           cod_canal, cod_usuario, ind_estado, val_importe,
                                           tipo_cambio,val_importe_mn,
                                           key_ingegr,val_impcom,key_iegcom,
                                           key_tipomov,codigo_moneda,key_detcanal,cnt_transac,
                                           codigo_cuenta,cuenta_unica,credito_unico,
                                           codigo_cliente,key_atm, key_tarj,cod_ranhor,cod_regope,
                                           key_motext,key_rngimp,imp_porcom,
                                           codpro_pas,subpro_pas,cod_succta,
                                           codpro_act,subpro_act,diaatr_pag,
                                           n_taspas,n_impcap,key_pais,key_cpos,
                                           cod_perfil,key_perfil,key_geoafiliat,codsuc_act)
                                   values (z.HFCON,z.HHORA,z.pgcod,lnMod,z.hsucor,lnTrx,z.hnrel,
                                           z.CANAL,z.HUSING,z.HCCORR,ln_imptrx,ln_tipcam,lv_imptrx_mn,
                                           nvl(ln_debhab,3),ln_impcom,ln_dehaco,
                                           ln_tipmov,lv_moneda,ln_detcan,1,
                                           lv_codcta,lv_ctauni,lv_creuni,lv_codcli,ln_keyatm,
                                           LN_TARJETA,ln_ranhor,ln_regope,ln_keyext,ln_rngimp,ln_comagn,
                                           lv_propas,lv_sprpas,lv_succta,ln_proact,ln_spract,ln_diapag,
                                           ln_taspas, ln_impcap,ln_kpais,ln_kcpos,lv_prfcod,ln_keyprf,
                                           ln_keygaf,lv_succta)
       LOG ERRORS INTO Err$_tmp_fact_op_transaccion ('INSERT-'||lv_Feccar) REJECT LIMIT UNLIMITED;                                 
       Commit;                 
       
       IF ln_rubcaj = 2 Then
          lv_imptrx_mn_2 := ln_imptrx_2;
          If lv_moneda_2 = '101' Then
             lv_imptrx_mn_2 := ln_imptrx_2*ln_tipcam;
          End If; 
          
          ln_rngimp := pq_tmp_carga_transacc.fn_rango_importe(nvl(lv_imptrx_mn_2,0));
          If z.HCCORR <> 99 Then
          ln_comagn := pq_tmp_carga_transacc.fn_porcom_agente(z.hcmod,z.htran,ln_rngimp);
          Else
              ln_comagn := 0;
          End If;
          
          Insert Into tmp_fact_op_transaccion(fecha, hora, pgcod, hcmod, hsucor, htran, hnrel,
                                              cod_canal, cod_usuario, ind_estado, val_importe,
                                              tipo_cambio,val_importe_mn,
                                              key_ingegr,val_impcom,key_iegcom,
                                              key_tipomov,codigo_moneda,key_detcanal,cnt_transac,
                                              codigo_cuenta,cuenta_unica,credito_unico,codigo_cliente,
                                              key_atm,key_tarj,cod_ranhor,cod_regope,key_rngimp,
                                              imp_porcom,codpro_pas,subpro_pas,cod_succta,
                                              codpro_act,subpro_act,diaatr_pag,n_taspas,n_impcap,
                                              key_pais,key_cpos,cod_perfil,key_perfil
                                             )
                                      values (z.HFCON,z.HHORA,z.pgcod,lnMod,z.hsucor,lnTrx,z.hnrel,
                                              z.CANAL,ln_usuari_2,z.HCCORR,ln_imptrx_2,ln_tipcam,lv_imptrx_mn_2,
                                              nvl(ln_debhab_2,3),0,null,
                                              ln_tipmov,lv_moneda_2,ln_detcan,0,
                                              lv_codcta,lv_ctauni,lv_creuni,lv_codcli,ln_keyatm,
                                              LN_TARJETA,ln_ranhor,ln_regope,ln_rngimp,ln_comagn,
                                              lv_propas,lv_sprpas,lv_succta,ln_proact,ln_spract,ln_diapag,
                                              ln_taspas,ln_impcap,ln_kpais,ln_kcpos,lv_prfcod,ln_keyprf)
         LOG ERRORS INTO Err$_tmp_fact_op_transaccion ('INSERT-'||lv_Feccar) REJECT LIMIT UNLIMITED;                                      
                                              --lv_ctadep,lv_numcre,0,null,);    
          Commit;  
       End IF;
        --Comision
        /*
        IF NVL(ln_impcom,0) <> 0 Then
           Begin
           Insert Into tmp_fact_op_trxcom (fecha, hora, pgcod, hcmod, hsucor, htran, hnrel,
                                              cod_canal, cod_usuario, ind_estado, val_importe,
                                              tipo_cambio,val_importe_mn,
                                              key_ingegr,
                                              key_tipomov,codigo_moneda,key_detcanal,cnt_transac,
                                              codigo_cuenta,cuenta_unica,credito_unico,
                                              codigo_cliente,key_atm, key_tarj,cod_ranhor,cod_regope,
                                              key_motext,key_rngimp,imp_porcom,cod_rubro)
                                   values (z.HFCON,z.HHORA,z.pgcod,z.hcmod,z.hsucor,z.htran,z.hnrel,
                                           z.CANAL,z.HUSING,z.HCCORR,ln_impcom,ln_tipcam,
                                           decode(lv_moneda,'0',ln_impcom,ln_impcom*ln_tipcam),
                                           ln_dehaco,
                                           ln_tipmov,lv_moneda,ln_detcan,1,
                                           lv_codcta,lv_ctauni,lv_creuni,lv_codcli,ln_keyatm,
                                           LN_TARJETA,ln_ranhor,ln_regope,
                                           ln_keyext,ln_rngimp,ln_comagn,ln_rubro);                                 
          exception When Others Then
           Null;
          end; 
         End If;
         */
   End Loop;
   exception 
      when others then 
          lc_msgerr := sqlerrm;
          insert into LOG_CARGA_TMP(NOMBRE_TABLA,DESCRIPCION,FECHA_CARGA,TIPO_TMP,ESTADO_TMP)
          values ('tmp_fact_op_transaccion',lc_msgerr,lv_Feccar,null,null); 
       commit; 

end sp_op_transacciones;
------------------------------------------------------------------------------------------------------------------
Procedure SP_TMP_DM_SEGMENTO_CTA 
  Is
  Begin
        MERGE INTO TMP_DM_SEGMENTO_CTA D
           USING (
                 
                 Select '1' KEY_SEG_CTA,  'PERSONA NATURAL' DES_SEG_CTA, 'PN' ABR_SEG_CTA  From Dual
                 Union All
                 Select '2' KEY_SEG_CTA, 'JURÍDICA SIN FINES DE LUCRO' DES_SEG_CTA, 'PJ S/L' ABR_SEG_CTA From Dual
                 Union All
                 Select '3' KEY_SEG_CTA, 'JURÍDICA CON FINES DE LUCRO' DES_SEG_CTA, 'PJ C/L' ABR_SEG_CTA From Dual
                 Union All
                 Select '4' KEY_SEG_CTA, 'INSTITUCIONES FINANCIERAS' DES_SEG_CTA, 'IF' ABR_SEG_CTA From Dual
                 Union All
                 Select '5' KEY_SEG_CTA, 'ORGANISMOS DEL ESTADO' DES_SEG_CTA, 'OE' ABR_SEG_CTA From Dual
                 
               ) x 
                 
              ON (D.KEY_SEG_CTA = X.KEY_SEG_CTA)
                 
      WHEN MATCHED THEN                                         
                       UPDATE
                          SET D.DES_SEG_CTA = X.DES_SEG_CTA,
                              D.ABR_SEG_CTA= X.ABR_SEG_CTA
      WHEN NOT MATCHED THEN
                       INSERT (D.KEY_SEG_CTA, D.DES_SEG_CTA, D.ABR_SEG_CTA)
                       VALUES(X.KEY_SEG_CTA, X.DES_SEG_CTA, X.ABR_SEG_CTA)
      LOG ERRORS INTO Err$_Tmp_Dm_SEGMENTO_CTA('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
      REJECT LIMIT UNLIMITED;
      COMMIT;
      Exception When Others then
      Null;                        
                                             
End SP_TMP_DM_SEGMENTO_CTA;

------------------------------------------------------------------------------------------------
Function fn_key_Segmento_cta (pn_seccod in number,
                              pn_codrub in number,
                              pv_cod_nat in varchar2)
Return Number
Is 
  ln_keySeg tmp_dm_segmento_cta.key_seg_cta%type;
   ln_indic number(1);
Begin
    
   
    If Pn_codrub like '23%' Then ln_keyseg:=4;  --Entidad Financiera
           
          elsif  substr(pn_codrub,1,8) in ('21030501','21030502') 
          then ln_keyseg:=1;
          
          elsif substr(pn_codrub,1,8) = '21080301'
          then ln_indic:=0;
          
          elsif  substr(pn_codrub,1,8) in ('21030301','21030401','21011301', '21020101','21020201',
          '21070101','21070201','21011201') 
          then ln_indic:=0; 
                  
              
          elsif substr(pn_codrub,1,10) in ('2107040101','2107040201','2103010201')
          then ln_indic:=0; 
                
         
          elsif substr(pn_codrub,1,8) in ('21011202','21011302','21020102','21020202','21030302',
          '21030402','21070102','21070202')
          then ln_indic:=1;
          
          elsif substr(pn_codrub,1,10) in ('2107040102','2107040202','2103010202' )
          then ln_indic:=1;
          
          elsif substr(pn_codrub,1,10) in ('2103010100')
          then ln_indic:=2;
             
      end if;
      
         if ln_indic=0 then 
               if pv_cod_nat='F' then ln_keyseg:=1;
               else   ln_keyseg:=2;
               end if;
               
         elsif ln_indic=1 then
               if pn_seccod=2 then ln_keyseg:=3;
               else ln_keyseg:=5;
               end if;
              
         elsif ln_indic=2 then
               if pn_seccod in (1,4) and pv_cod_nat='F' then ln_keyseg:=1;
               elsif pn_seccod=1 and pv_cod_nat='J' then ln_keyseg:=2;
               elsif pn_seccod=2 then ln_keyseg:=3;
               elsif pn_seccod=3 then ln_keyseg:=4;
               elsif pn_seccod=5 then ln_keyseg:=5;
               else ln_keyseg:=null;
               end if;
                     
         end if;
         
         return ln_keyseg;        
                 
    
   
End fn_key_Segmento_cta;
--------------------------------------------------------------------------------------------
Function fn_tarjeta_trx(PN_MODTRX in Number,
                         PN_CODTRX in Number,
                         PN_RELTRX in Number,
                         PD_FECHA IN DATE)
                         
Return Number
IS
LV_NROTAR VARCHAR(20); 
LN_KEYTAR NUMBER(10); 
  
  
Begin
     Begin
        Select j.jaql540nutar Into lv_nrotar
       -- from dwextra.jaql540 j 
       from jaql540@produ j 
        Where j.jaql540modul=PN_MODTRX 
          and j.jaql540trans=PN_CODTRX
          and j.jaql540relac=PN_RELTRX
          and j.jaql540feini = PD_FECHA; 
     Exception When Others Then
         IF PD_FECHA <> TRUNC(SYSDATE) THEN
         Begin
           select z0e4getar Into lv_nrotar
             from z0e4ge@produ
            where z0e4gefec = PD_FECHA
              and z0e4gemod = PN_MODTRX
              and z0e4getrn = PN_CODTRX
              and z0e4gerel = PN_RELTRX;
         Exception When Others Then
             lv_nrotar := '000';
         End;
         ELSE
            lv_nrotar := '000';
         END IF;
     End;
     lv_nrotar := trim(lv_nrotar);
     
     Begin
         Select k.key_tarj Into ln_keytar
           from dwstage.tmp_dm_tarjeta k
           where trim(nro_tarj)=lv_nrotar; 
     Exception When No_Data_Found Then
         Begin
              Select k.key_tarj Into ln_keytar
                From dwstage.tmp_dm_tarjeta k
               Where trim(nro_tarj)='000';
         Exception When Others Then  
                lv_nrotar := Null;
         End;
     End;
     
     Return ln_keytar;
    
End fn_tarjeta_trx;

 ----------------------------------------------------------------------------------------------------------
 Procedure SP_JOB_TMP_DM_TARJETA(pc_fecpro varchar2) 
 Is
    lc_coderr varchar2(2000);
  
    lc_variable varchar2(4000);
    ln_job      number := 0;
    ln_ini      number := 0;
    ln_fin      number := 0;
    pi_vc2_nomjob      VARCHAR2(30);
    ln_existe   number(10);
    ln_regdim   number(10);
    
    Cursor c_sucs 
        Is Select to_number(codigo_agencia) codsuc from tmp_dm_geografia_activo where tipo_region ='R';
 Begin
    /*begin
      select max(r.z0e478nro), trunc(max(r.z0e478nro) / 100)
        into ln_max, ln_rango
        from dwextra.z0e478 r;
    exception
      when no_data_found then
        ln_max   := 0;
        ln_rango := 0;
    end;*/
    --
    -- Tabla con datos de tmp_dm_tarjetas
     select count(*) into ln_existe from user_tables where table_name='TMP_TARJETAS'; 
     If ln_existe > 0 Then
        Execute immediate('Truncate table TMP_TARJETAS');
        Execute Immediate 'Insert into TMP_TARJETAS(NRO_TARJ) Select nro_tarj from tmp_dm_tarjeta';   
        Commit;
     End If;
     
     -- Revisa Indice
     select count(*) into ln_existe from user_indexes u where u.index_name = 'IX_TMP_TARJ' and u.table_name='TMP_TARJETAS'; 
     If ln_existe = 0 Then
        Execute Immediate 'create index IX_TMP_TARJ on TMP_TARJETAS(trim(nro_tarj)) tablespace DWSTAGE_IDX';
     End If;  
     
     Execute Immediate 'Select count(*) from TMP_TARJETAS' Into ln_existe;
     Select count(*) Into ln_regdim from TMP_TARJETAS;
     
            
     If ln_existe = ln_regdim Then
    --
    execute immediate 'truncate table err$_TMP_dm_tarjeta';
    For s in c_sucs Loop
      ln_ini := s.codsuc;
      ln_fin := s.codsuc;
    
      lc_variable := ' begin ' ||
                     ' pq_tmp_carga_transacc.sp_carga_tarjeta(' || ln_ini || ',' ||
                     ln_fin || ',' || pc_fecpro || ');' || ' End;';               
      ln_job      := ln_job + 1;
    
      pi_vc2_nomjob := 'DM_TARJETAS_' || LPAD(TO_CHAR(ln_job), 5, '0');
    
      dbms_scheduler.create_job(job_name   => 'DM_TARJETAS_' ||
                                              LPAD(TO_CHAR(ln_job), 5, '0'),
                                job_type   => 'PLSQL_BLOCK',
                                job_action => lc_variable,
                                start_date => sysdate + 1 / (24 * 180),
                                enabled    => true,
                                auto_drop  => TRUE,
                                comments   => 'DM_TARJETAS');
    
      commit;
    End loop;
  
    End If;
/*    WHILE NUM_JOB_PENDIENTES > 0 LOOP
    
      NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(pi_vc2_nomjob => pi_vc2_nomjob,
                                                 pi_vc2_nomusr => USER);
    end loop;*/
  
  exception
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      insert into log_carga_tmp (nombre_tabla,descripcion,fecha_carga,tipo_tmp,estado_tmp)
      values ('JOB_DM_TARJETAS',lc_coderr,sysdate,'DM','E');
      commit;
          
 End SP_JOB_TMP_DM_TARJETA;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
----------------------------------------------------------------------------------------------
procedure sp_carga_serv_afil (PD_FECHA  in date, --Fecha de proceso
                                   pc_tipcar in varchar2 --Tipo de carga T:Total / E:Errores
                                   )
                                  
is
begin
   
        execute immediate 'truncate table tmp_fact_op_servafil';
        execute immediate 'truncate table err$_tmp_fact_op_servafil';
        
         pq_tmp_carga_transacc.sp_operaciones_internet(PD_FECHA, PC_TIPCAR);
      
         pq_tmp_carga_transacc.sp_tarjeta_coordenadas(PD_FECHA, PC_TIPCAR);
      
         pq_tmp_carga_transacc.sp_deb_automatico_serv(PD_FECHA, PC_TIPCAR);
      
         pq_tmp_carga_transacc.sp_compras_extranjero(PD_FECHA, PC_TIPCAR);
      
         pq_tmp_carga_transacc.SP_CUENTA_COBRANZA(PD_FECHA, PC_TIPCAR);
      
         pq_tmp_carga_transacc.SP_Afil_Desafil_Tarjeta(PD_FECHA, PC_TIPCAR);
      
         pq_tmp_carga_transacc.SP_AFIL_DESAFIL_GUARDADITO(PD_FECHA, PC_TIPCAR);
      
 

end sp_carga_serv_afil;

-------------------------------------------------------------------------------------------------------
Function fn_interes_cts(PD_FECHA In Date,
                        PN_CODCTA In Number,
                        PN_CODRUB In Number,
                        PN_CODMDA In Number,
                        PN_CODOPE In Number,
                        PN_CODSBO In Number
                       ) 
Return Number
Is 
   ln_importe number(12,2);
Begin
   Begin
     Select nvl(bcsdmo,0) Into ln_importe
       From fsh012@produ s 
      Where bcfech = PD_FECHA
        and bccta  = PN_CODCTA 
        and bcrubr = PN_CODRUB
        and bcmda  = PN_CODMDA 
        and bcoper = PN_CODOPE
        and bcsbop = PN_CODSBO;
   Exception When Others Then
       ln_importe := 0;
   End;      
    Return ln_importe;      
End fn_interes_cts;



---------------------------------------------------------------------------------------------------------------
Procedure sp_Ctas_Vigentes (PD_FECHA in Date)
  --------------------------------------------------------------------------------------
  -- Creación: FSD JUNIO 2018
  ---------------------------------------------------------------------------------------
  -- Fecha  : 16/08/2018
  -- Autor  : Rafael
  -- Cambios: 
  ---------------------------------------------------------------------------------------
  
  IS
        LD_FECHA DATE := PD_FECHA;
--- FSD JUNIO 2018
--- Crear Tabla de Cuentas Vigentes al cierre de Mes:16s.
       
     
Begin       
        Execute Immediate 'Truncate table tmp_tfact_fsd_ctas';
        
        Insert Into dwstage.tmp_tfact_fsd_ctas(fecha,cuenta, cod_cuenta, cuentas_key, aosuc, 
                                               aomod, aomda, aocta, aoope, aosbo, aotop, 
                                               fecha_apertura, fecha_renov, key_seg_cta, abr_seg_cta, 
                                               saldo_mo, int_gen_mo, saldo_gar_mo, int_fsd, imp_fsd, gar_fsd, 
                                               dii_fsd,ind_fsd,ind_empbco,ind_dosrub,num_diaape,codigo_estado,
                                               codigo_rubro
                                               /*,p_impsaldo,p_impinter,p_impgaran,p_imp_fsd,
                                               p_int_fsd,p_gar_fsd,p_dii_fsd,num_titcta*/
                                               ) 
        Select t.fecha,c.cuenta,c.cod_cuenta,c.cuentas_key,
               k.aosuc,k.aomod,k.aomda,k.aocta,k.aoope,k.aosbo,k.aotop,k.fecha_apertura,k.fecha_renov,
               p.key_seg_cta,s.abr_seg_cta,
               p.saldo_mo,p.int_gen_mo,p.saldo_gar_mo,
               p.int_fsd,p.imp_fsd,p.gar_fsd,p.dii_fsd,p.ind_fsd,p.ind_empbco,p.ind_dosrub,
               t.fecha-c.fecha_apertura num_diaape,
               e.codigo_estado,r.codigo_rubro
               
          from dwhouse.fact_pasivo p
          join dwhouse.dm_estado e on e.estado_key = p.estado_key
          join dwhouse.dm_cuentas c on c.cuentas_key = p.cuentas_key
          join dwhouse.dm_tiempo t on t.tiempo_key = p.tiempo_key
          join dwhouse.dm_segmento_cta s on s.key_seg_cta = p.key_seg_cta
          join dwstage.tmp_dm_cuenta k on k.codigo_cuenta=c.codigo_cuenta and k.cuenta_unica=c.cuenta_unica
          join dwhouse.dm_rubro r on r.rubro_key = p.rubro_key
         Where e.codigo_estado <> '99'
           and t.fecha = ld_fecha;
    Commit;       
End sp_Ctas_Vigentes;  
--------------------------------------------------------------------------------------------------------------------------
Procedure sp_CTAS_SLDOS_MES (PD_FECHA in Date)
  --------------------------------------------------------------------------------------
  -- Creación: Fact con todas de cuentas y saldos del mes
  ---------------------------------------------------------------------------------------
  -- Fecha  : 16/08/2018
  -- Autor  : Rafael
  -- Cambios: 
  ---------------------------------------------------------------------------------------
  
  IS
--- Crear Fact con todas de cuentas y saldos del mes 
-----
  
  ld_Fecha date := PD_FECHA;
  ld_fecini date := to_date(to_char(ld_fecha,'rrrrmm')||'01','rrrrmmdd');
Begin
  Execute Immediate 'truncate table tmp_fsldomes_pas';
  ld_Fecha:=ld_Fecha-1;
  
  Loop
      Execute Immediate 'Insert Into tmp_fsldomes_pas(fecha,cuentas_key,saldo_mo,int_gen_mo,saldo_gar_mo,'||
                                                     'imp_fsd,int_fsd,dii_fsd,gar_fsd) '|| 
                                              'Select t.fecha,p.cuentas_key,p.saldo_mo,p.int_gen_mo,p.saldo_gar_mo,'||
                                                     'p.imp_fsd,p.int_fsd,p.dii_fsd,p.gar_fsd '||
                                                  'From dwhouse.FACT_PASIVO partition(fact_pasivo_'||to_char(ld_Fecha,'rrrrmmdd')||') p '||
                                                  'Join dwhouse.dm_tiempo t on t.tiempo_key=p.tiempo_key '||
                                                  'Where exists (select 1 from tmp_tfact_fsd_ctas c where c.cuentas_key=p.cuentas_key)';
     Commit;                                           
     ld_Fecha := ld_Fecha - 1;
   Exit when ld_Fecha < ld_fecini;
   End Loop; 
   
   --Inserta datos de Julio
   Execute Immediate 'Insert Into tmp_fsldomes_pas(fecha,cuentas_key,saldo_mo,int_gen_mo,saldo_gar_mo,'||
                                                  'imp_fsd,int_fsd,dii_fsd,gar_fsd) '|| 
                                           'Select p.fecha,p.cuentas_key,p.saldo_mo,p.int_gen_mo,p.saldo_gar_mo,'||
                                                  'p.imp_fsd,p.int_fsd,p.dii_fsd,p.gar_fsd '||
                                             'From tmp_tfact_fsd_ctas p';
   Commit;                                                                                            
End;
------------------------------------------------------------------------------------------------------------------------------------------------------
Procedure sp_fsd_clie (PD_FECHA in Date)
  --------------------------------------------------------------------------------------
  -- Creación: tmp_tfact_fsd_clie
  ---------------------------------------------------------------------------------------
  -- Fecha  : 16/08/2018
  -- Autor  : Rafael
  -- Cambios: 
  ---------------------------------------------------------------------------------------
  
  IS


-- tmp_tfact_fsd_clie
-----

   Cursor c_ctas (ld_fec in Date)
       is select * from dwstage.tmp_tfact_fsd_ctas x where x.fecha = ld_fec;-- where aocta=1702962;
   
   Cursor c_ntit (ln_Cta In Number)
       is  Select t.pepais,t.petdoc,t.pendoc,n.penom,
                    count(*) over (partition by t.ctnro) numtit
               From dwstage.fsr008 t
               LEft Join dwextra.fsd001 n on n.pepais = t.pepais and n.petdoc=t.petdoc and n.pendoc=t.pendoc
              Where t.ctnro = ln_Cta;
   
               
   ld_fecha   date := PD_FECHA; --to_date('20180630','rrrrmmdd');
   ln_diasm   number(2) := to_number(to_char(ld_fecha,'dd'));  
   ln_psaldo  number(12,2);
   ln_pinter  number(12,2);  
   ln_pgaran  number(12,2);
   ln_pimpfsd number(12,2);
   ln_pintfsd number(12,2);
   ln_pgarfsd number(12,2);
   ln_pdiifsd number(12,2);
   ln_numreg  number(5) := 0;
   ln_pais    number(3);
   ln_tdoc    number(3);
   lc_ndoc    char(12);
   ln_numtit  number(5);
   lv_nomcli  varchar2(200);
   ln_existe  number(2);
   ln_tiempo  number(10);
   ln_ndias   number(5);
Begin
   --Execute Immediate 'Truncate Table tmp_tfact_fsd_clie';
   Delete From tmp_tfact_fsd_clie where fecha = ld_fecha;
   Commit;
   
   Select tiempo_key Into ln_tiempo from dwhouse.dm_tiempo where fecha = ld_fecha;
   For x In c_ctas (ld_fecha)Loop
       Begin
            Select sum(l.saldo_mo),sum(l.int_gen_mo),sum(l.saldo_gar_mo),
                   sum(l.imp_fsd),sum(l.int_fsd),sum(l.gar_fsd),sum(l.dii_fsd)
              Into ln_psaldo, ln_pinter, ln_pgaran,
                   ln_pimpfsd, ln_pintfsd, ln_pgarfsd, ln_pdiifsd    
              From tmp_fsldomes_pas l
             Where cuentas_key = x.cuentas_key;  
       Exception When Others Then
          ln_psaldo := 0; ln_pinter := 0; ln_pgaran := 0;
          ln_pimpfsd:= 0; ln_pintfsd:= 0; ln_pgarfsd:= 0; ln_pdiifsd:= 0;
       End;
       
       -- Cantidad de titulares
       For z In c_ntit(x.cuenta) Loop
           If x.num_diaape+1 > ln_diasm Then ln_ndias := ln_diasm; else ln_ndias:= x.num_diaape+1; End If;
           
           Insert Into tmp_tfact_fsd_clie(fecha, tiempo_key, pais, tdoc, ndoc, cod_cliente, nom_cliente, 
                                          cuentas_key, aomda,aomod, aocta,aoope,aosbo,aotop, num_titcta,  
                                          key_segcta , abr_segcta ,
                                          fec_apertura,num_dias, dia_ape,  saldo_mo,  intgen_mon, salgar_mo, 
                                          p_impsaldo  , p_impinter,p_impgaran, 
                                          p_imp_fsd   , p_int_fsd, p_gar_fsd , p_dii_fsd,
                                          ind_empbco  , ind_dosrub,ind_estado, cod_rubro
                                         ) 
                                   values(x.fecha,ln_tiempo,z.pepais,z.petdoc,z.pendoc,trim(z.pepais||z.petdoc||z.pendoc),trim(z.penom),
                                          x.cuentas_key, x.aomda,x.aomod,x.aocta,x.aoope,x.aosbo,x.aotop,z.numtit,
                                          x.key_seg_cta , x.abr_seg_cta ,
                                          x.fecha_apertura,x.num_diaape,ln_ndias,x.saldo_mo,x.int_gen_mo,x.saldo_gar_mo,
                                          ln_psaldo ,ln_pinter,ln_pgaran,
                                          ln_pimpfsd,ln_pintfsd,ln_pgarfsd,ln_pdiifsd,
                                          x.ind_empbco, x.ind_dosrub,x.codigo_estado,x.codigo_rubro
                                         );
       End Loop;
       
       ln_numreg := ln_numreg + 1;
       If Mod(ln_numreg,1000) = 0 Then
          Commit;
          ln_numreg := 0;
       End If;            
       
   End Loop;
   Commit;
End;
--------------------------------------------------------------------------------------------------------------------------------------
Procedure sp_Prorrat_Sald (PD_FECHA in Date)
  --------------------------------------------------------------------------------------
  -- Creación: Prorrateo de saldos por persona
  ---------------------------------------------------------------------------------------
  -- Fecha  : 16/08/2018
  -- Autor  : Rafael
  -- Cambios: 
  ---------------------------------------------------------------------------------------
  
  IS
-- Prorrateo de saldos por persona
----

    Cursor c_clie (ld_fec in Date)
        Is Select distinct pais,tdoc,ndoc,ind_empbco From tmp_tfact_fsd_clie b
            where b.fecha = ld_fec;
        --exists (select 1 from fsd009_Exc where pepais = b.pais and petdoc=b.tdoc and pendoc=b.ndoc);-- where ndoc in ('000068767   ','000297278   ');
    Cursor c_ctas(ln_pais in Number,ln_tdoc in Number, lc_ndoc in Char,ld_fec In Date)
        Is Select * From (Select case when x.cod_rubro in ('2107040101','2107040201','2107040901') then 1
                                      when x.cod_rubro like '21020101%' then 3
                                      When x.cod_rubro like '21020201%' then 4
                                      When x.cod_rubro like '21030301%' then 5
                                      When x.cod_rubro like '210305%' then 6
                                      When x.cod_rubro like '21011201%' then 7
                                      else 8
                                  end n_orden,
                                  case when x.cod_rubro in ('2107040101','2107040201','2107040901') then 'G' else 'S' end tipimp,
                                  x.p_impsaldo-x.p_impgaran p_impsaldo,
                                  x.p_impinter,x.p_impgaran,x.p_imp_fsd,x.p_int_fsd,x.p_gar_fsd,x.p_dii_fsd,
                                  x.dia_ape,x.num_titcta,x.cod_rubro,
                                  x.aomda,x.aomod,x.aocta,x.aoope,x.aosbo,x.aotop,x.key_segcta
                             From tmp_tfact_fsd_clie x 
                            where x.pais=ln_pais and tdoc=ln_tdoc and x.ndoc=lc_ndoc--'29361801    '--'29479309    '
                              and x.fecha = ld_fec
                                  UNION ALL
                           Select 2, 'G',x.p_impsaldo-x.p_impgaran p_impsaldo,x.p_impinter,x.p_impgaran,
                                  x.p_imp_fsd,x.p_int_fsd,x.p_gar_fsd,x.p_dii_fsd,
                                  x.dia_ape,x.num_titcta,x.cod_rubro,
                                  x.aomda,x.aomod,x.aocta,x.aoope,x.aosbo,x.aotop,x.key_segcta
                             From tmp_tfact_fsd_clie x 
                            where x.pais=ln_pais and tdoc=ln_tdoc and x.ndoc=lc_ndoc
                              and x.fecha = ld_fec
                              and (x.cod_rubro not in ('2107040101','2107040201','2107040901')
                                   and x.salgar_mo <> 0)
                          )Order By n_orden;
                                                  
   ld_Fecha  date := PD_FECHA; --to_Date('20180630','rrrrmmdd'); 
   ln_limfsd number(12,2);  
   ln_tcam   number(7,3);    
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
   ln_isdo number(13,3); 
   ln_iint number(13,3); 
   ln_igar number(13,3); 
   ln_dsdo number(13,3);   
   ln_dint number(13,3);   
   ln_dgar number(13,3);  
   ln_isdo_fsd number(13,3);
   ln_iint_fsd number(13,3);
   ln_igar_fsd number(13,3);
   ln_dsdo_fsd number(13,3);
   ln_dint_fsd number(13,3);
   ln_dgar_fsd number(13,3);
   ln_tsdo number(13,3);   
   ln_tint number(13,3);   
   ln_tgar number(13,3);  
   ln_tsdo_fsd number(13,3);   
   ln_tint_fsd number(13,3);   
   ln_tgar_fsd number(13,3);    
   lv_mdes varchar2(5);
   ln_estra number(3);
Begin
    -- Parametros FSD
    Select cotcbi Into ln_tcam from dwextra.fsh005 f where f.cofdes = ld_Fecha;
    Select ciimp  Into ln_limfsd from dwextra.fsi002;
    --Select ctnro from fsd009;

    For c In c_clie(ld_Fecha) Loop
        ln_impacu := 0;
        ln_ima_fsd:= 0;
        For x In c_ctas(c.pais,c.tdoc,c.ndoc,ld_Fecha) Loop
            IF x.aomda = 101 Then
                ln_psdo := (x.p_impsaldo*ln_tcam)/(x.dia_ape*x.num_titcta);  
                ln_pint := ((x.p_impinter*ln_tcam)+(x.p_dii_fsd*ln_tcam))/(x.dia_ape*x.num_titcta);
                ln_pgar := (x.p_impgaran*ln_tcam)/(x.dia_ape*x.num_titcta);
                
                ln_psdo_fsd := (x.p_imp_fsd*ln_tcam)/(x.dia_ape*x.num_titcta);  
                ln_pint_fsd := ((x.p_int_fsd*ln_tcam)+(x.p_dii_fsd*ln_tcam))/(x.dia_ape*x.num_titcta);
                ln_pgar_fsd := (x.p_gar_fsd*ln_tcam)/(x.dia_ape*x.num_titcta);
            Else 
                ln_psdo := x.p_impsaldo/(x.dia_ape*x.num_titcta);  
                ln_pint := (x.p_impinter+x.p_dii_fsd)/(x.dia_ape*x.num_titcta);
                ln_pgar := x.p_impgaran/(x.dia_ape*x.num_titcta);
                
                ln_psdo_fsd := x.p_imp_fsd/(x.dia_ape*x.num_titcta);  
                ln_pint_fsd := (x.p_int_fsd+x.p_dii_fsd)/(x.dia_ape*x.num_titcta);
                ln_pgar_fsd := x.p_gar_fsd/(x.dia_ape*x.num_titcta);
            End If;
            ln_tsdo:=ln_psdo;
            ln_tint:=ln_pint;
            ln_tgar:=ln_pgar;
            
            ln_tsdo_fsd:=ln_psdo;
            ln_tint_fsd:=ln_pint;
            ln_tgar_fsd:=ln_pgar;
            
            IF x.tipimp = 'G' and x.cod_rubro not like '210704%' Then
               ln_saldo := ln_pgar;
               ln_psdo  := 0;
               ln_pint  := 0;
               
               ln_saldo_fsd := ln_pgar_fsd;
               ln_psdo_fsd  := 0;
               ln_pint_fsd  := 0;
            Else
               ln_saldo := ln_pgar+ln_psdo+ln_pint;
               ln_saldo_fsd := ln_pgar_fsd+ln_psdo_fsd+ln_pint_fsd;
            End If;
            
            --- Datamart
            If ln_impacu < ln_limfsd Then
               ln_impacu := ln_impacu + ln_saldo;
            Else 
               ln_saldo  := 0;
               ln_psdo   := 0;
               ln_pint   := 0;
               ln_pgar   := 0;
            End If;
            --- Bantotal
            If ln_ima_fsd < ln_limfsd Then
               ln_ima_fsd := ln_ima_fsd + ln_saldo_fsd;
            Else 
               ln_saldo_fsd  := 0;
               ln_psdo_fsd   := 0;
               ln_pint_fsd   := 0;
               ln_pgar_fsd   := 0;
            End If;
            
            --- Datamart 
            If ln_impacu > ln_limfsd and ln_saldo > 0 Then
               ln_saldo := ln_limfsd;
               
               If ln_pgar <= ln_saldo Then
                  ln_igar := ln_pgar;
                  ln_saldo := ln_saldo - ln_pgar; 
                  ln_dgar := 0;
               Else   
                  ln_igar := ln_saldo;
                  ln_dsdo := ln_pgar - ln_saldo; 
                  ln_saldo:= 0;
               End If;
               If ln_psdo <= ln_saldo Then
                  ln_isdo := ln_psdo;
                  ln_saldo := ln_saldo - ln_psdo; 
                  ln_dsdo := 0;
               Else   
                  ln_isdo := ln_saldo; 
                  ln_dsdo := ln_psdo - ln_saldo;
                  ln_saldo:= 0;
               End If;
               If ln_pint <= ln_saldo Then
                  ln_iint := ln_pint;
                  ln_saldo := ln_saldo - ln_pint; 
                  ln_dint := 0;
               Else   
                  ln_iint := ln_saldo; 
                  ln_dint := ln_pint - ln_saldo;
                  ln_saldo:= 0;
               End If;   
            Else 
               ln_isdo := ln_psdo;
               ln_iint := ln_pint;
               ln_igar := ln_pgar;
               ln_dsdo := 0;
               ln_dint := 0;
               ln_dgar := 0;
            End IF;
            
            --- Bantotal
            If ln_ima_fsd > ln_limfsd and ln_saldo_fsd > 0 Then
               ln_saldo_fsd := ln_limfsd;
               
               If ln_pgar_fsd <= ln_saldo Then
                  ln_igar_fsd := ln_pgar_fsd;
                  ln_saldo_fsd := ln_saldo_fsd - ln_pgar_fsd; 
                  ln_dgar_fsd := 0;
               Else   
                  ln_igar_fsd := ln_saldo_fsd;
                  ln_dsdo_fsd := ln_pgar_fsd - ln_saldo_fsd; 
                  ln_saldo_fsd:= 0;
               End If;
               If ln_psdo_fsd <= ln_saldo_fsd Then
                  ln_isdo_fsd := ln_psdo_fsd;
                  ln_saldo_fsd := ln_saldo_fsd - ln_psdo_fsd; 
                  ln_dsdo_fsd := 0;
               Else   
                  ln_isdo_fsd := ln_saldo_fsd; 
                  ln_dsdo_fsd := ln_psdo_fsd - ln_saldo_fsd;
                  ln_saldo_fsd:= 0;
               End If;
               If ln_pint_fsd <= ln_saldo_fsd Then
                  ln_iint_fsd := ln_pint_fsd;
                  ln_saldo_fsd := ln_saldo_fsd - ln_pint_fsd; 
                  ln_dint_fsd := 0;
               Else   
                  ln_iint_fsd := ln_saldo_fsd; 
                  ln_dint_fsd := ln_pint_fsd - ln_saldo_fsd;
                  ln_saldo_fsd:= 0;
               End If;   
            Else 
               ln_isdo_fsd := ln_psdo_fsd;
               ln_iint_fsd := ln_pint_fsd;
               ln_igar_fsd := ln_pgar_fsd;
               ln_dsdo_fsd := 0;
               ln_dint_fsd := 0;
               ln_dgar_fsd := 0;
            End IF;
            
            lv_mdes := 'C00';
            -- Buscar empleados Caja
            Select Count(*) Into ln_estra From fsd009_exc Where pepais=c.pais and petdoc=c.tdoc and pendoc=c.ndoc;
            
            If ln_estra > 0 and c.ind_empbco=1 Then
                  lv_mdes := 'C20';
            ElsIf ln_estra > 0 and c.ind_empbco=0 Then   
                  lv_mdes := 'C30';
            ElsIf x.key_segcta = 4 Then
                  lv_mdes := 'C10'; --Sist.Finan.
            ElsIf x.key_segcta in (3,5) Then      
                  lv_mdes := 'C60'; -- PJ Lucro
            Elsif(ln_tsdo-ln_isdo) + (ln_tint-ln_iint) + (ln_tgar-ln_igar) > 0 Then
               lv_mdes := 'C50';
            End If;
            
            Update tmp_tfact_fsd_clie s
               set s.imp_tcam = ln_tcam,
                   s.imp_lfsd = ln_limfsd,
                   s.sld_pdis = ln_isdo,
                   s.int_pdis = ln_iint,
                   s.gar_pdis = ln_igar,
                   s.sld_pdnc = ln_tsdo-ln_isdo,
                   s.int_pdnc = ln_tint-ln_iint,
                   s.gar_pdnc = ln_tgar-ln_igar,
                   s.sld_dtot = ln_tsdo,
                   s.int_dtot = ln_tint,
                   s.gar_dtot = ln_tgar,
                   s.cod_mdes = lv_mdes,
                   --- Bantotal
                   s.sldc_fsd = ln_isdo_fsd,
                   s.intc_fsd = ln_iint_fsd,
                   s.garc_fsd = ln_igar_fsd,
                   s.sldn_fsd = ln_tsdo_fsd-ln_isdo_fsd,
                   s.intn_fsd = ln_tint_fsd-ln_iint_fsd,
                   s.garn_fsd = ln_tgar_fsd-ln_igar_fsd,
                   s.sldt_fsd = ln_tsdo_fsd,
                   s.intt_fsd = ln_tint_fsd,
                   s.gart_fsd = ln_tgar_fsd
             Where s.pais = c.pais
               and s.tdoc = c.tdoc
               and s.ndoc = c.ndoc
               and s.aomda = x.aomda
               and s.aomod = x.aomod
               and s.aocta = x.aocta
               and s.aoope = x.aoope
               and s.aotop = x.aotop
               and s.aosbo = x.aosbo
               and s.fecha = ld_Fecha;      
             Commit;   
        End Loop;
    End Loop;
End;
-----------------------------------------------------------------------------------------------------------------------
Procedure sp_Datos_Anex (PD_FECHA in Date)
  --------------------------------------------------------------------------------------
  -- Creación: Datos para Anexos
  ---------------------------------------------------------------------------------------
  -- Fecha  : 16/08/2018
  -- Autor  : Rafael
  -- Cambios: 
  ---------------------------------------------------------------------------------------
  
  IS

-- Datos para Anexos
----

   Cursor c_detanex (ld_fec in Date)
       is select * from tmp_dm_fsd_conanex;
   ld_fecha date := PD_FECHA; --to_date('20180630','rrrrmmdd');   
Begin
   --Execute Immediate 'truncate table tmp_fact_fsd_anexos';
   Begin
     delete from tmp_fact_fsd_anexos f where f.fecha=ld_fecha and nvl(f.ind_proceso,1)=1;
     Commit;
   Exception When Others Then
       Null;  
   End;
   
   For x in c_detanex (ld_fecha) Loop
       If x.cod_anexo=1 and x.ind_sindat = 0 Then
          Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                          imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,ind_proceso)
                                   Values(ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                          0,0,0,0,0,1);
       ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=6 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then sld_dtot else 0 end),
                    sum(case when aomda=101 then sld_dtot else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when num_dias+1<=31 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.cod_rubro like '21011201%' and c.cod_mdes not in ('C10','C60')
                 and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=7 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then int_dtot else 0 end),
                    sum(case when aomda=101 then int_dtot else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when num_dias+1<=31 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.cod_mdes not in ('C10','C60')
               and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=8 Then  
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then sld_dtot else 0 end),
                    sum(case when aomda=101 then sld_dtot else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when num_dias+1<=31 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.cod_rubro like '21020101%' and c.cod_mdes not in ('C10','C60')
               and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=10 Then
                    Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then sld_dtot else 0 end),
                    sum(case when aomda=101 then sld_dtot else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when num_dias+1<=31 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.cod_rubro like '21030301%' and c.cod_mdes not in ('C10','C60')
               and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=12 Then
                    Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then gar_dtot else 0 end),
                    sum(case when aomda=101 then gar_dtot else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when num_dias+1<=31 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.gar_dtot <> 0 and c.cod_mdes not in ('C10','C60')
               and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=14 Then
                Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then sld_dtot else 0 end),
                    sum(case when aomda=101 then sld_dtot else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when num_dias+1<=31 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.cod_rubro like '210305%' and c.cod_mdes not in ('C10','C60')
               and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=16 Then
                Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then sld_dtot else 0 end),
                    sum(case when aomda=101 then sld_dtot else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when num_dias+1<=31 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.cod_rubro like '21020201%' and c.cod_mdes not in ('C10','C60')
               and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=31 and x.ind_sindat = 0 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso)
                                      Values(ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                             0,0,0,0,1);
       ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=6 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then sld_pdis else 0 end),
                    sum(case when aomda=101 then sld_pdis else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.cod_rubro like '21011201%' and c.cod_mdes in ('C00','C50')
               and c.tdoc <> 27 and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=7 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then sld_pdis else 0 end),
                    sum(case when aomda=101 then sld_pdis else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.cod_rubro like '21020101%' and c.cod_mdes in ('C00','C50')
               and c.tdoc <> 27 and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=9 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then sld_pdis else 0 end),
                    sum(case when aomda=101 then sld_pdis else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.cod_rubro like '21030301%' and c.cod_mdes in ('C00','C50')
               and c.tdoc <> 27 and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=11 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then gar_pdis else 0 end),
                    sum(case when aomda=101 then gar_pdis else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.gar_pdis <> 0 and c.cod_mdes in ('C00','C50')
               and c.tdoc <> 27 and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=13 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then sld_pdis else 0 end),
                    sum(case when aomda=101 then sld_pdis else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.cod_rubro like '210305%' and c.cod_mdes in ('C00','C50')
               and c.tdoc <> 27 and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=15 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then sld_pdis else 0 end),
                    sum(case when aomda=101 then sld_pdis else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.cod_rubro like '21020201%' and c.cod_mdes in ('C00','C50')
               and c.tdoc <> 27 and c.fecha = ld_fecha;
      
      ElsIf x.cod_anexo=32 and x.ind_sindat = 0 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso)
                                      Values(ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                             0,0,0,0,1);
       ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=6 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then sld_pdis else 0 end),
                    sum(case when aomda=101 then sld_pdis else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.cod_rubro like '21011201%' and c.cod_mdes in ('C00','C50')
               and c.tdoc = 27 and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=7 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then sld_pdis else 0 end),
                    sum(case when aomda=101 then sld_pdis else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.cod_rubro like '21020101%' and c.cod_mdes in ('C00','C50')
               and c.tdoc = 27 and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=9 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then sld_pdis else 0 end),
                    sum(case when aomda=101 then sld_pdis else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.cod_rubro like '21030301%' and c.cod_mdes in ('C00','C50')
               and c.tdoc = 27 and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=11 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then gar_pdis else 0 end),
                    sum(case when aomda=101 then gar_pdis else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.gar_pdis<>0 and c.cod_mdes in ('C00','C50')
               and c.tdoc = 27 and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=13 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then sld_pdis else 0 end),
                    sum(case when aomda=101 then sld_pdis else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.cod_rubro like '210305%' and c.cod_mdes in ('C00','C50')
               and c.tdoc = 27 and c.fecha = ld_fecha;
       ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=15 Then
             Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                             imp_soles,imp_dolar,cta_soles,cta_dolar,ind_proceso)
             Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                    sum(case when aomda=0 then sld_pdis else 0 end),
                    sum(case when aomda=101 then sld_pdis else 0 end),
                    count(distinct case when aomda=0 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    count(distinct case when aomda=101 then aocta||aoope||aosbo||aotop||aomda||aomod end),
                    1
               from tmp_tfact_fsd_clie c where c.cod_rubro like '21020201%' and c.cod_mdes in ('C00','C50')
               and c.tdoc = 27 and c.fecha = ld_fecha;
       End If;      
       Commit;
   End Loop;
End;
------------------------------------------------------------------------------------------------------------------------------------------------
Procedure sp_Anxs_Bantotal (PD_FECHA in Date)
  --------------------------------------------------------------------------------------
  -- Creación: DATOS DE ANEXOS DE BANTOTAL
  ---------------------------------------------------------------------------------------
  -- Fecha  : 16/08/2018
  -- Autor  : Rafael
  -- Cambios: 
  ---------------------------------------------------------------------------------------
  
  IS

-- DATOS DE ANEXOS DE BANTOTAL
----

   Cursor c_detanex (ld_fec in date)
       is select * from tmp_dm_fsd_conanex;
   ld_fecha date := PD_FECHA; --to_date('&rrrrmmdd','rrrrmmdd'); 
   ln_indpro number(2):=2;  
   ln_numreg number(10);
   lv_anexo  varchar2(20);
   ln_ranx17 number(10);
Begin
     Begin
       delete from tmp_fact_fsd_anexos f where f.fecha=ld_fecha and ind_proceso=ln_indpro;
       Commit;
     Exception When Others Then
         Null;  
     End;

     For x in c_detanex (ld_fecha)Loop
         If x.cod_anexo=1 and x.ind_sindat = 0 Then
            Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                            imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,ind_proceso)
                                     Values(ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                            0,0,0,0,0,2);
                                            dbms_output.put_line(1||'-'||0);
         ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=6 Then
               ln_numreg := 600;
         ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=7 Then
               ln_numreg := 700;
         ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=8 Then 
               ln_numreg := 800; 
         ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=10 Then
               ln_numreg := 1000;
         ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=12 Then
               ln_numreg := 1200;
         ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=14 Then
               ln_numreg := 1400;
         ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=15 Then
               ln_numreg := 1500;      
         ElsIf x.cod_anexo=1 and x.ind_sindat = 1 and x.ord_conane=16 Then
               ln_numreg := 1600;
         ElsIf x.cod_anexo=2 and x.ind_sindat = 0 Then
               Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                               imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,ind_proceso)
                                        Values(ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                               0,0,0,0,0,2);
         ElsIf x.cod_anexo=31 and x.ind_sindat = 0 Then
               Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                               imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,ind_proceso)
                                        Values(ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                               0,0,0,0,0,2);
         ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=6 Then
               ln_numreg := 600;
               ln_ranx17 := 600;
         ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=7 Then
               ln_numreg := 800;
               ln_ranx17 := 800;
         ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=9 Then
               ln_numreg := 1000;
               ln_ranx17 := 1000;
         ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=11 Then
               ln_numreg := 1200;
               ln_ranx17 := 1200;
         ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=13 Then
               ln_numreg := 1400;
               ln_ranx17 := 1400;
         ElsIf x.cod_anexo=31 and x.ind_sindat = 1 and x.ord_conane=15 Then
               ln_numreg := 1600;
               ln_ranx17 := 1600;                                                              
         ElsIf x.cod_anexo=32 and x.ind_sindat = 0 Then
               Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,
                                               imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva,ind_proceso)
                                        Values(ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,
                                               0,0,0,0,0,2);                                                                            
         ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=6 Then
               ln_numreg := 2600;
               ln_ranx17 := 600;
         ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=7 Then
               ln_numreg := 2800;
               ln_ranx17 := 800;
         ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=9 Then
               ln_numreg := 3000;
               ln_ranx17 := 1000;
         ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=11 Then
               ln_numreg := 3200;
               ln_ranx17 := 1200;
         ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=13 Then
               ln_numreg := 3400;
               ln_ranx17 := 1400;
         ElsIf x.cod_anexo=32 and x.ind_sindat = 1 and x.ord_conane=15 Then
               ln_numreg := 3600;
               ln_ranx17 := 1600;              
         End If;      
     --- Insertar
     IF x.cod_anexo=1 and x.ind_sindat = 1 Then
        --begin
        lv_anexo  := 'ANEXO17A2';
        --dbms_output.put_line(lv_anexo||'-'||ln_numreg||'-'||to_char(ld_fecha,'rrrr.mm.dd'));
        Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,ind_proceso,
                                        imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva)
                    Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,2,
                           sum(impsol),sum(impdol),sum(ctasol),sum(ctadol),sum(ctanue) 
                     From (
                           Select l.bcsdon1 impsol,0 impdol,0 ctasol,0 ctadol, 0 ctanue
                             from dwextra.fbc170 l where l.bcfinf = ld_fecha and trim(bcinfor) = lv_anexo
                              and l.bcsuc=0 and trim(l.bccicpo) is not null and bcreng=ln_numreg and l.bccolu=1
                           Union All 
                           Select 0,l.bcsdon1,0,0,0 
                             from dwextra.fbc170 l where l.bcfinf = ld_fecha and trim(bcinfor) = lv_anexo
                              and l.bcsuc=0 and trim(l.bccicpo) is not null and bcreng=ln_numreg and l.bccolu=2
                           Union All
                           Select 0,0,l.bcsdon1,0,0 
                             from dwextra.fbc170 l where l.bcfinf = ld_fecha and trim(bcinfor) = lv_anexo
                              and l.bcsuc=0 and trim(l.bccicpo) is not null and bcreng=ln_numreg and l.bccolu=4  
                           Union All
                           Select 0,0,0,l.bcsdon1,0 
                             from dwextra.fbc170 l where l.bcfinf = ld_fecha and trim(bcinfor) = lv_anexo
                              and l.bcsuc=0 and trim(l.bccicpo) is not null and bcreng=ln_numreg and l.bccolu=5  
                           Union All
                           Select 0,0,0,0,l.bcsdon1 
                             from dwextra.fbc170 l where l.bcfinf = ld_fecha and trim(bcinfor) = lv_anexo
                              and l.bcsuc=0 and trim(l.bccicpo) is not null and bcreng=ln_numreg and l.bccolu=7      
                          );  
           --exception when others then
             -- dbms_output.put_line('ERROR');
           --end;                           
     ElsIf x.cod_anexo=2 and x.ind_sindat = 1 Then
        lv_anexo  := 'ANEXO17A3';
        Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,ind_proceso,
                                        imp_soles,imp_dolar,cta_soles,cta_dolar)
                    Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,2,
                           sum(impsol),sum(impdol),sum(ctasol),sum(ctadol)
                     From (
                           Select l.bcsdon1 impsol,0 impdol,0 ctasol,0 ctadol
                             from dwextra.fbc170 l where l.bcfinf = ld_fecha and trim(bcinfor) = lv_anexo
                              and l.bcsuc=0 and trim(l.bccicpo) is not null and bcreng=ln_numreg and l.bccolu=1
                           Union All 
                           Select 0,l.bcsdon1,0,0
                             from dwextra.fbc170 l where l.bcfinf = ld_fecha and trim(bcinfor) = lv_anexo
                              and l.bcsuc=0 and trim(l.bccicpo) is not null and bcreng=600 and l.bccolu=2
                           Union All
                           Select 0,0,l.bcsdon1,0
                             from dwextra.fbc170 l where l.bcfinf = ld_fecha and trim(bcinfor) = lv_anexo
                              and l.bcsuc=0 and trim(l.bccicpo) is not null and bcreng=ln_numreg and l.bccolu=4  
                           Union All
                           Select 0,0,0,l.bcsdon1
                             from dwextra.fbc170 l where l.bcfinf = ld_fecha and trim(bcinfor) = lv_anexo
                              and l.bcsuc=0 and trim(l.bccicpo) is not null and bcreng=ln_numreg and l.bccolu=5  
                          );  
     ElsIf x.cod_anexo in (31,32) and x.ind_sindat = 1 Then
        lv_anexo  := 'ANEXO175';
        Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,ind_proceso,
                                        imp_soles,imp_dolar,cta_soles,cta_dolar,cta_nueva)    
                    Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,2,
                           sum(impsol),sum(impdol),sum(ctasol),sum(ctadol),sum(portot)
                     From (                                                 
                          Select bcsdon1 impsol, 0 impdol, 0 ctasol, 0 ctadol, 0 portot 
                           from dwextra.fbc170 l where l.bcfinf = ld_Fecha and trim(bcinfor) = lv_anexo
                            and l.bcsuc=0 and bcreng=ln_numreg and l.bccolu =1
                          Union All
                          Select 0 impsol, bcsdon1 impdol, 0 ctasol, 0 ctadol, 0 portot 
                           from dwextra.fbc170 l where l.bcfinf = ld_Fecha and trim(bcinfor) = lv_anexo
                            and l.bcsuc=0 and bcreng=ln_numreg and l.bccolu =2  
                          Union All
                          Select 0 impsol, 0 impdol, bcsdon1 ctasol, 0 ctadol, 0 portot 
                           from dwextra.fbc170 l where l.bcfinf = ld_Fecha and trim(bcinfor) = lv_anexo
                            and l.bcsuc=0 and bcreng=ln_numreg and l.bccolu = 4  
                          Union All
                          Select 0 impsol, 0 impdol, 0 ctasol, bcsdon1 ctadol, 0 portot 
                           from dwextra.fbc170 l where l.bcfinf = ld_Fecha and trim(bcinfor) = lv_anexo
                            and l.bcsuc=0 and bcreng=ln_numreg and l.bccolu = 5 
                          Union All
                          Select 0 impsol, 0 impdol, 0 ctasol, 0 ctadol, bcsdon1 portot 
                           from dwextra.fbc170 l where l.bcfinf = ld_Fecha and trim(bcinfor) = 'ANEXO17A2'
                            and l.bcsuc=0 and bcreng=ln_ranx17 and l.bccolu = 3 
                          );  
     ElsIf x.cod_anexo = 4 and x.ind_sindat = 1 Then
           lv_anexo  := 'ANEXO17A5';
           
           Insert Into tmp_fact_fsd_anexos(fecha,cod_anexo,ord_conane,rub_conane,des_conane,ind_proceso,
                                           imp_soles,imp_dolar,cta_nueva) 
                                           
                Select ld_fecha,x.cod_anexo,x.ord_conane,x.rub_conane,x.des_conane,2,
                       sum(impsol),sum(impdol),sum(portot)
                 From (                                 
                        Select bcsdon1 impsol, 0 impdol, 0 portot
                        from dwextra.fbc170 l
                        where l.bcfinf = ld_Fecha
                          and trim(l.bcinfor) = lv_anexo                         
                          and l.bcsuc = 0 and l.bccolu = 1
                        Union All
                        Select 0 impsol, bcsdon1 impdol, 0 portot
                          from dwextra.fbc170 l
                         where l.bcfinf = ld_Fecha 
                           and trim(l.bcinfor) = lv_anexo              
                           and l.bcsuc = 0 and l.bccolu = 2
                        Union All
                        Select 0 impsol, 0 impdol, bcsdon1 portot
                          from dwextra.fbc170 l
                         where l.bcfinf = ld_Fecha
                           and trim(l.bcinfor) = 'ANEXO17A2'  
                           and l.bcreng = 1700                       
                           and l.bcsuc=0
                           and l.bccolu =3      
                      );    
     End If;
     Commit;
     
     End Loop;
End;
-------------------------------------------------------------------------------------------------------------------------

Procedure sp_Prorrat_Bantot (PD_FECHA in Date)
  --------------------------------------------------------------------------------------
  -- Creación: PRORRATEO DATOS BANTOTAL ANEXO17
  ---------------------------------------------------------------------------------------
  -- Fecha  : 16/08/2018
  -- Autor  : Rafael
  -- Cambios: 
  ---------------------------------------------------------------------------------------
  
  IS

-- PRORRATEO DATOS BANTOTAL ANEXO17
-----
  
    Cursor c_fbc512(ld_Fec In Date)
        is select * from dwextra.fbc512 where bc512fch = ld_Fec 
           and trim(bc512aux2) in ('R17A0600','R17A0700','R17A0800','R17A1000','R17A1200','R17A1400','R17A1600');
           --and bc512nro2=ln_nro;-- and bc512ndoc='42349191    ';
    Cursor c_detdep(ld_Fec In Date,ln_Pais In Number,ln_Tdoc In Number,ln_Ndoc In Char,ln_Mda In Number,lv_Rub Varchar2,ln_ndig in Number)
        is Select * from tmp_tfact_fsd_clie where fecha=ld_Fec and pais=ln_Pais and tdoc=ln_Tdoc and ndoc=ln_Ndoc
              and aomda = ln_Mda and substr(cod_rubro,1,ln_ndig) = lv_Rub;   
              
    Cursor c_detgar(ld_Fec In Date,ln_Pais In Number,ln_Tdoc In Number,ln_Ndoc In Char,ln_Mda In Number)          
        is Select * from tmp_tfact_fsd_clie where fecha=ld_Fec and pais=ln_Pais and tdoc=ln_Tdoc and ndoc=ln_Ndoc
           and aomda = ln_Mda and nvl(gar_dtot,0) <> 0;   
  
    Cursor c_detint(ld_Fec In Date,ln_Pais In Number,ln_Tdoc In Number,ln_Ndoc In Char,ln_Mda In Number)          
        is Select * from tmp_tfact_fsd_clie where fecha=ld_Fec and pais=ln_Pais and tdoc=ln_Tdoc and ndoc=ln_Ndoc
           and aomda = ln_Mda and nvl(int_dtot,0) <> 0;
    
    ---- Distribuye Imp.Cobertura
    Cursor c_clie (ld_fec in Date)
        Is Select distinct pais,tdoc,ndoc,ind_empbco From tmp_tfact_fsd_clie b 
            where b.fecha = ld_fec;-- and cod_cliente='6042140479793';
        --exists (select 1 from fsd009_Exc where pepais = b.pais and petdoc=b.tdoc and pendoc=b.ndoc);-- where ndoc in ('000068767   ','000297278   ');
    Cursor c_ctas(ln_pais in Number,ln_tdoc in Number, lc_ndoc in Char,ld_fec In Date)
        Is Select * From (Select case when nvl(x.gar_anxs,0) <> 0 then 1
                                      when x.cod_denanx = 800 then 2
                                      When x.cod_denanx = 1600 then 3
                                      When x.cod_denanx = 1000 then 4
                                      When x.cod_denanx = 1400 then 5
                                      When x.cod_denanx = 600  then 7
                                      else 8
                                  end n_orden,
                                  case when nvl(x.gar_anxs,0) <> 0 then 'G' else 'S' end tipimp,
                                  x.p_impsaldo-x.p_impgaran p_impsaldo,
                                  x.p_impinter,x.p_impgaran,x.p_imp_fsd,x.p_int_fsd,x.p_gar_fsd,x.p_dii_fsd,
                                  x.dia_ape,x.num_titcta,x.cod_rubro,
                                  x.aomda,x.aomod,x.aocta,x.aoope,x.aosbo,x.aotop,x.key_segcta,
                                  nvl(x.sld_anxs,0) sld_anxs, nvl(x.gar_anxs,0) gar_anxs,nvl(int_anxs,0) int_anxs,
                                  x.tiempo_key 
                             From tmp_tfact_fsd_clie x 
                            where x.pais=ln_pais and tdoc=ln_tdoc and x.ndoc=lc_ndoc--'29361801    '--'29479309    '
                              and x.fecha = ld_fec
                           )Order By n_orden;
    ----
                       
    ld_Fecha date := PD_FECHA; --to_date('20180630','rrrrmmdd');    
    ln_imps number(12,2);
    ln_impd number(12,2);
    ln_ntit number(5);
    ln_ctas number(2);
    ln_ctad number(2);
    ln_mdac Number(3);
    lv_codcli Varchar2(30);
    ln_cuenta Number(10);
    ln_imp  Number(12,2);
    ln_inde Number(1);
    ln_nreg Number(5);-- := 1200;
    ln_drub Number(5);
    lv_rubro Varchar2(16);
    ln_nope Number(3); 
    
    -----
    ln_limfsd number(12,2);  
    ln_tcam   number(7,3);    
    ln_psdo   number(13,3);
    ln_pint   number(13,3);
    ln_pgar   number(13,3);      
    ln_saldo  number(13,3);  
    ln_impacu number(13,3); 
    ln_isdo number(13,3); 
    ln_iint number(13,3); 
    ln_igar number(13,3); 
    ln_dsdo number(13,3);   
    ln_dint number(13,3);   
    ln_dgar number(13,3);  
    ln_tsdo number(13,3);   
    ln_tint number(13,3);   
    ln_tgar number(13,3);  
   
Begin
    Update tmp_tfact_fsd_clie set sld_anxs=null,gar_anxs=null,cod_denanx=null Where fecha =ld_Fecha;
    Commit;  
    For x In c_fbc512(ld_Fecha) Loop
        ln_imps:=x.bc512imp1;
        ln_impd:=x.bc512imp2;
        ln_ntit:=x.bc512nro5;
        ln_ctas:=x.bc512nro3;
        ln_ctad:=x.bc512nro4;
        ln_nope := 0;
        -- Detalle de depósitos por cliente
        If x.bc512nro2=600 Then --Judiciales:21011201
           lv_rubro := '21011201'; 
           ln_drub  := 8; 
           ln_nreg  := 600;
        ElsIf x.bc512nro2=800 Then --Aho Act
           lv_rubro := '21020101';
           ln_drub  := 8;
            ln_nreg  := 800;
        ElsIf x.bc512nro2=1000 or trim(x.bc512aux2)='R17A1000' Then --FSD
           lv_rubro := '21030301';
           ln_drub  := 8;
           ln_nreg  := 1000;
        ElsIf x.bc512nro2=1400 or trim(x.bc512aux2)='R17A1400' Then  --CTS
           lv_rubro := '210305';
           ln_drub  := 6;
           ln_nreg  := 1400;
        ElsIf x.bc512nro2=1600 Then --Aho Inac
           lv_rubro := '21020201';
           ln_drub  := 8;
           ln_nreg  := 1600;
        --ElsIf trim(x.bc512aux2)='R17A1200' Then --Obligaciones/Intereses   
           
        End If;
        
           lv_codcli := null;
           ln_cuenta := null;
           ln_inde   := 0;
           
           If ln_imps <> 0 Then
              --dbms_output.put_line('Soles');
              --dbms_output.put_line('PAram:'||x.bc512pais||'-'||x.bc512tdoc||'-'||x.bc512ndoc);
              ln_inde   := 0; 
              If trim(x.bc512aux2)='R17A1200' Then --Garantias
                 For s in c_detgar(ld_Fecha,x.bc512pais,x.bc512tdoc,x.bc512ndoc,0) Loop
                     ln_inde   := 1; 
                     lv_codcli := s.cod_cliente;
                     ln_cuenta := s.cuentas_key;
                     If nvl(s.gar_dtot,0) <= ln_imps Then
                        ln_imp := nvl(s.gar_dtot,0);
                        ln_imps:= ln_imps - ln_imp;
                     Else
                        ln_imp := nvl(ln_imps,0);
                        ln_imps:= 0;
                     End If;   
                     
                     Update tmp_tfact_fsd_clie m
                        set gar_anxs = ln_imp
                      Where m.cod_cliente = lv_codcli
                        and m.cuentas_key = ln_cuenta
                        and m.fecha       = ld_fecha
                        and m.aomda       = 0;  
                 End Loop; 
                 -- Si quedo saldo actualizar en último registro
                 IF ln_inde = 1 and  ln_imps <> 0 Then
                    Update tmp_tfact_fsd_clie m
                       set gar_anxs = nvl(gar_anxs,0) + ln_imps
                     Where m.cod_cliente = lv_codcli
                       and m.cuentas_key = ln_cuenta
                       and m.fecha       = ld_fecha
                       and m.aomda       = 0; 
                 ElsIf ln_inde = 0 Then
                       ln_nope   := ln_nope +1 ;
                     Insert Into tmp_tfact_fsd_clie(fecha,pais,tdoc,ndoc,cod_cliente,gar_dtot,gart_fsd,gar_anxs,aomda,
                                                    aomod,aocta,aoope,aosbo,aotop)
                     Values(ld_Fecha,x.bc512pais,x.bc512tdoc,x.bc512ndoc,trim(x.bc512pais||x.bc512tdoc||x.bc512ndoc),0,0,ln_imps,0,
                                                    992,0,0,ln_nope,0);
                 End If;  
              ElsIf trim(x.bc512aux2)='R17A0700' Then --Interes
                    For s in c_detint(ld_Fecha,x.bc512pais,x.bc512tdoc,x.bc512ndoc,0) Loop
                        ln_inde   := 1; 
                        lv_codcli := s.cod_cliente;
                        ln_cuenta := s.cuentas_key;
                        
                        If nvl(s.int_dtot,0) <= ln_imps Then
                           ln_imp := nvl(s.int_dtot,0);
                           ln_imps:= ln_imps - ln_imp;
                        Else
                           ln_imp := nvl(ln_imps,0);
                           ln_imps:= 0;
                        End If;   
                     
                        Update tmp_tfact_fsd_clie m
                           set int_anxs = ln_imp
                         Where m.cod_cliente = lv_codcli
                           and m.cuentas_key = ln_cuenta
                           and m.fecha       = ld_fecha
                           and m.aomda       = 0;  
                    End Loop; 
                    -- Si quedo saldo actualizar en último registro
                    IF ln_inde = 1 and  ln_imps <> 0 Then
                       Update tmp_tfact_fsd_clie m
                          set int_anxs = nvl(gar_anxs,0) + ln_imps
                        Where m.cod_cliente = lv_codcli
                          and m.cuentas_key = ln_cuenta
                          and m.fecha       = ld_fecha
                          and m.aomda       = 0; 
                    ElsIf ln_inde = 0 Then
                          ln_nope   := ln_nope +1 ;
                          Insert Into tmp_tfact_fsd_clie(fecha,pais,tdoc,ndoc,cod_cliente,int_dtot,intt_fsd,int_anxs,aomda,
                                                         aomod,aocta,aoope,aosbo,aotop)
                          Values(ld_Fecha,x.bc512pais,x.bc512tdoc,x.bc512ndoc,trim(x.bc512pais||x.bc512tdoc||x.bc512ndoc),0,0,ln_imps,0,
                                                         993,0,0,ln_nope,0);
                    End If;
              Else 
                      For s in c_detdep(ld_Fecha,x.bc512pais,x.bc512tdoc,x.bc512ndoc,0,lv_rubro,ln_drub) Loop
                          --dbms_output.put_line('Cursor:'||x.bc512pais||'-'||x.bc512tdoc||'-'||x.bc512ndoc);
                          ln_inde   := 1; 
                          lv_codcli := s.cod_cliente;
                          ln_cuenta := s.cuentas_key;
                          If nvl(s.sld_dtot,0) <= ln_imps Then
                             ln_imp := nvl(s.sld_dtot,0);
                             ln_imps:= ln_imps - ln_imp;
                          Else
                             ln_imp := nvl(ln_imps,0);
                             ln_imps:= 0;
                          End If;   
                          --dbms_output.put_line(lv_codcli||'-'||ln_cuenta||':'||ln_imp);
                          Update tmp_tfact_fsd_clie m
                             set sld_anxs = ln_imp,
                                 cod_denanx = ln_nreg
                          Where m.cod_cliente = lv_codcli
                            and m.cuentas_key = ln_cuenta
                            and m.fecha       = ld_fecha
                            and m.aomda       = 0;  
                      End Loop;
                      -- Si quedo saldo actualizar en último registro
                      IF ln_inde = 1 and  ln_imps <> 0 Then
                         Update tmp_tfact_fsd_clie m
                             set sld_anxs = nvl(sld_anxs,0) + ln_imps,
                                 cod_denanx = ln_nreg
                          Where m.cod_cliente = lv_codcli
                            and m.cuentas_key = ln_cuenta
                            and m.fecha       = ld_fecha
                            and m.aomda       = 0; 
                      ElsIf ln_inde = 0 Then
                          ln_nope   := ln_nope +1 ;
                          Insert Into tmp_tfact_fsd_clie(fecha,pais,tdoc,ndoc,cod_cliente,sld_dtot,sldt_fsd,sld_anxs,cod_denanx,aomda,
                                                         aomod,aocta,aoope,aosbo,aotop)
                          Values(ld_Fecha,x.bc512pais,x.bc512tdoc,x.bc512ndoc,trim(x.bc512pais||x.bc512tdoc||x.bc512ndoc),0,0,ln_imps,
                                                         ln_nreg,0,991,0,0,ln_nope,0);
                      End If;  
               End If;  --FIN GARANTIAS       
           End If;
           -- Dólares
           If ln_impd <> 0 Then
              ln_imp := 0;
              ln_inde:= 0;
              If trim(x.bc512aux2)='R17A1200' Then --Garantias
                  For s in c_detgar(ld_Fecha,x.bc512pais,x.bc512tdoc,x.bc512ndoc,101) Loop
                      lv_codcli := s.cod_cliente;
                      ln_cuenta := s.cuentas_key;
                      ln_inde   := 1;
                      If nvl(s.gar_dtot,0) <= ln_impd Then
                         ln_imp := nvl(s.gar_dtot,0);
                         ln_impd:= ln_impd - ln_imp;
                      Else
                         ln_imp := nvl(ln_impd,0);
                         ln_impd:= 0;
                      End If;   
                      Update tmp_tfact_fsd_clie m
                         set gar_anxs = ln_imp
                      Where m.cod_cliente = lv_codcli
                        and m.cuentas_key = ln_cuenta
                        and m.fecha       = ld_fecha
                        and m.aomda       = 101;  
                  End Loop;
                  
                  IF ln_impd <> 0 and ln_inde = 1 Then
                     Update tmp_tfact_fsd_clie m
                        set gar_anxs = nvl(gar_anxs,0) + ln_impd
                      Where m.cod_cliente = lv_codcli
                        and m.cuentas_key = ln_cuenta
                        and m.fecha       = ld_fecha
                        and m.aomda       = 101; 
                  ElsIf ln_inde = 0 Then
                      ln_nope   := ln_nope +1 ;
                      Insert Into tmp_tfact_fsd_clie(fecha,pais,tdoc,ndoc,cod_cliente,gar_dtot,gart_fsd,gar_anxs,aomda,
                                                     aomod,aocta,aoope,aosbo,aotop)       
                      Values(ld_Fecha,x.bc512pais,x.bc512tdoc,x.bc512ndoc,trim(x.bc512pais||x.bc512tdoc||x.bc512ndoc),0,0,ln_impd,101,
                                                     992,0,0,ln_nope,0);
                  End If;
              ElsIf trim(x.bc512aux2)='R17A0700' Then --Garantias
                    For s in c_detint(ld_Fecha,x.bc512pais,x.bc512tdoc,x.bc512ndoc,101) Loop
                        lv_codcli := s.cod_cliente;
                        ln_cuenta := s.cuentas_key;
                        ln_inde   := 1;
                        If nvl(s.int_dtot,0) <= ln_impd Then
                           ln_imp := nvl(s.int_dtot,0);
                           ln_impd:= ln_impd - ln_imp;
                        Else
                           ln_imp := nvl(ln_impd,0);
                           ln_impd:= 0;
                        End If;   
                        Update tmp_tfact_fsd_clie m
                           set int_anxs = ln_imp
                         Where m.cod_cliente = lv_codcli
                           and m.cuentas_key = ln_cuenta
                           and m.fecha       = ld_fecha
                           and m.aomda       = 101;  
                    End Loop;
                  
                    IF ln_impd <> 0 and ln_inde = 1 Then
                       Update tmp_tfact_fsd_clie m
                          set int_anxs = nvl(int_anxs,0) + ln_impd
                        Where m.cod_cliente = lv_codcli
                          and m.cuentas_key = ln_cuenta
                          and m.fecha       = ld_fecha
                          and m.aomda       = 101; 
                     ElsIf ln_inde = 0 Then
                           ln_nope   := ln_nope +1 ;
                           Insert Into tmp_tfact_fsd_clie(fecha,pais,tdoc,ndoc,cod_cliente,int_dtot,intt_fsd,int_anxs,aomda,
                                                          aomod,aocta,aoope,aosbo,aotop)
                           Values(ld_Fecha,x.bc512pais,x.bc512tdoc,x.bc512ndoc,trim(x.bc512pais||x.bc512tdoc||x.bc512ndoc),0,0,ln_impd,101,
                                                          993,0,0,ln_nope,0);
                     End If;    
              Else
                  For s in c_detdep(ld_Fecha,x.bc512pais,x.bc512tdoc,x.bc512ndoc,101,lv_rubro,ln_drub) Loop
                      lv_codcli := s.cod_cliente;
                      ln_cuenta := s.cuentas_key;
                      ln_inde   := 1;
                      If nvl(s.sld_dtot,0) <= ln_impd Then
                         ln_imp := nvl(s.sld_dtot,0);
                         ln_impd:= ln_impd - ln_imp;
                      Else
                         ln_imp := nvl(ln_impd,0);
                         ln_impd:= 0;
                      End If;   
                      Update tmp_tfact_fsd_clie m
                         set sld_anxs = ln_imp,
                             cod_denanx = ln_nreg
                      Where m.cod_cliente = lv_codcli
                        and m.cuentas_key = ln_cuenta
                        and m.fecha       = ld_fecha
                        and m.aomda       = 101;  
                  End Loop;
                  -- Si quedo saldo actualizar en último registro
                  --dbms_output.put_line('Inde:'||ln_inde);
                  IF ln_impd <> 0 and ln_inde = 1 Then
                     Update tmp_tfact_fsd_clie m
                         set sld_anxs = nvl(sld_anxs,0) + ln_impd,
                             cod_denanx = ln_nreg
                      Where m.cod_cliente = lv_codcli
                        and m.cuentas_key = ln_cuenta
                        and m.fecha       = ld_fecha
                        and m.aomda       = 101; 
                  ElsIf ln_inde = 0 Then
                      --dbms_output.put_line('Inserta');
                      ln_nope   := ln_nope +1 ;
                      Insert Into tmp_tfact_fsd_clie(fecha,pais,tdoc,ndoc,cod_cliente,sld_dtot,sldt_fsd,sld_anxs,cod_denanx,aomda,
                                                     aomod,aocta,aoope,aosbo,aotop)
                      Values(ld_Fecha,x.bc512pais,x.bc512tdoc,x.bc512ndoc,trim(x.bc512pais||x.bc512tdoc||x.bc512ndoc),0,0,ln_impd,ln_nreg,101,
                                                     991,0,0,ln_nope,0);
                  End If;
              End If; -- Fin GARANTIA    
           End If;
        --End If;
        Commit;
    End Loop;

    ---- Distribuye
    -- Parametros FSD
    --Select cotcbi Into ln_tcam from dwextra.fsh005 f where f.cofdes = ld_Fecha;
    Select ciimp  Into ln_limfsd from dwextra.fsi002;
    --
     
    For c In c_clie(ld_Fecha) Loop
        ln_impacu := 0;
        For x In c_ctas(c.pais,c.tdoc,c.ndoc,ld_Fecha) Loop
             
            ln_psdo := x.sld_anxs;  
            ln_pint := x.int_anxs;
            ln_pgar := x.gar_anxs;
            ln_tsdo :=ln_psdo;
            ln_tint :=ln_pint;
            ln_tgar :=ln_pgar;
            
            IF ln_pgar <> 0 Then
               ln_saldo := ln_pgar;
               ln_psdo  := 0;
               ln_pint  := 0;
            Else
               ln_saldo := ln_pgar+ln_psdo+ln_pint;
            End If;
            
            --- Datamart
            If ln_impacu < ln_limfsd Then
               ln_impacu := ln_impacu + ln_saldo;
            Else 
               ln_saldo  := 0;
               ln_psdo   := 0;
               ln_pint   := 0;
               ln_pgar   := 0;
            End If;
            
            --- Datamart 
            If ln_impacu > ln_limfsd and ln_saldo > 0 Then
               ln_saldo := ln_limfsd;
               
               If ln_pgar <= ln_saldo Then
                  ln_igar := ln_pgar;
                  ln_saldo := ln_saldo - ln_pgar; 
                  ln_dgar := 0;
               Else   
                  ln_igar := ln_saldo;
                  ln_dsdo := ln_pgar - ln_saldo; 
                  ln_saldo:= 0;
               End If;
               If ln_psdo <= ln_saldo Then
                  ln_isdo := ln_psdo;
                  ln_saldo := ln_saldo - ln_psdo; 
                  ln_dsdo := 0;
               Else   
                  ln_isdo := ln_saldo; 
                  ln_dsdo := ln_psdo - ln_saldo;
                  ln_saldo:= 0;
               End If;
               If ln_pint <= ln_saldo Then
                  ln_iint := ln_pint;
                  ln_saldo := ln_saldo - ln_pint; 
                  ln_dint := 0;
               Else   
                  ln_iint := ln_saldo; 
                  ln_dint := ln_pint - ln_saldo;
                  ln_saldo:= 0;
               End If;   
            Else 
               ln_isdo := ln_psdo;
               ln_iint := ln_pint;
               ln_igar := ln_pgar;
               ln_dsdo := 0;
               ln_dint := 0;
               ln_dgar := 0;
            End IF;
            
            If x.tiempo_key is not null then
                Update tmp_tfact_fsd_clie s
                   set s.sld_anxc = ln_isdo,
                       s.int_anxc = ln_iint,
                       s.gar_anxc = ln_igar,
                       s.sld_anxn = ln_tsdo-ln_isdo,
                       s.int_anxn = ln_tint-ln_iint,
                       s.gar_anxn = ln_tgar-ln_igar
                 Where s.pais = c.pais
                   and s.tdoc = c.tdoc
                   and s.ndoc = c.ndoc
                   and s.aomda = x.aomda
                   and s.aomod = x.aomod
                   and s.aocta = x.aocta
                   and s.aoope = x.aoope
                   and s.aotop = x.aotop
                   and s.aosbo = x.aosbo
                   and s.fecha = ld_Fecha;      
             Else
                 Update tmp_tfact_fsd_clie s
                   set s.sld_anxc = ln_isdo,
                       s.int_anxc = ln_iint,
                       s.gar_anxc = ln_igar,
                       s.sld_anxn = ln_tsdo-ln_isdo,
                       s.int_anxn = ln_tint-ln_iint,
                       s.gar_anxn = ln_tgar-ln_igar
                 Where s.pais = c.pais
                   and s.tdoc = c.tdoc
                   and s.ndoc = c.ndoc
                   and s.aomda = x.aomda
                   and s.aomod = x.aomod
                   and s.aocta = x.aocta
                   and s.aoope = x.aoope
                   and s.aotop = x.aotop
                   and s.aosbo = x.aosbo
                   and s.fecha = ld_Fecha
                   and (nvl(s.sld_anxs,0) + nvl(s.gar_anxs,0)+nvl(s.int_anxs,0)) = (nvl(x.sld_anxs,0) + nvl(x.gar_anxs,0)+nvl(x.int_anxs,0));    
             End If;   
             Commit;   
        End Loop;
    End Loop;
    -- Actualizaciones finales
    ----
    Update tmp_tfact_fsd_clie set cod_denanx=600 where cod_denanx is null 
    and cod_rubro like '21011201%' and fecha=to_date('20180630','rrrrmmdd');
    Update tmp_tfact_fsd_clie set cod_denanx=800 where cod_denanx is null 
    and cod_rubro like '21020101%' and fecha=to_date('20180630','rrrrmmdd');
    Update tmp_tfact_fsd_clie set cod_denanx=1000 where cod_denanx is null 
    and cod_rubro like '21030301%' and fecha=to_date('20180630','rrrrmmdd');
    Update tmp_tfact_fsd_clie set cod_denanx=1400 where cod_denanx is null 
    and cod_rubro like '210305%' and fecha=to_date('20180630','rrrrmmdd');
    Update tmp_tfact_fsd_clie set cod_denanx=1600 where cod_denanx is null 
    and cod_rubro like '21020201%' and fecha=to_date('20180630','rrrrmmdd');
    ----
    Commit;
End;

---------------------------------------------------------------------------------------------------------
Function fn_ubigeo_detcan (PN_KCANAL In Number, PV_CODCAN In Varchar2)
Return Number
Is
   ln_ubikey Number(10);
Begin    
      If    PN_KCANAL = 1 Then -- Agencia
            Begin
                Select u.ubigeo_key
                  Into ln_ubikey
                  From tmp_dm_geografia_activo g
                  Join tmp_dm_ubigeo u
                    on u.codigo_distrito = g.codigo_distrito
                 Where codigo_agencia = PV_CODCAN
                   and tipo_region = 'R'; 
            Exception When Others Then
               ln_ubikey := 43921; --N/R
            End;
      ElsIf PN_KCANAL = 2 Then -- ATM
            Begin
                Select u.ubigeo_key 
                  Into ln_ubikey
                  from tmp_dm_geografia_activo g 
                  Join tmp_dm_ubigeo u 
                    on u.codigo_distrito=g.codigo_distrito
                  Join dwextra.z0e475 a 
                    on a.z0e475suc = to_number(g.codigo_agencia)
                 where tipo_region='R'
                   and trim(a.z0e475cod) = PV_CODCAN;
            Exception When Others Then
               ln_ubikey := 43921; --N/R
            End;
      ElsIf PN_KCANAL = 5 Then -- AGENTE
            Begin
                 Select u.ubigeo_key 
                   Into ln_ubikey
                  from dwextra.jaql004 a
                  Join tmp_dm_ubigeo u 
                    on u.codigo_distrito=a.jaql4distr
                 where a.jaql4nucom = to_number(PV_CODCAN);
           Exception When Others Then
               ln_ubikey := 43921; --N/R
           End;            
      Else
            ln_ubikey := 43921;
      End If;
      Return ln_ubikey; 
End fn_ubigeo_detcan;
---------------------------------------------------------------------------------------------------------
Procedure sp_ubicacion_detcan 
Is
  Cursor c_detcan
      Is Select * from tmp_dm_detcanal;
  ln_ubikey Number(10); 
  ln_loncan Number(12,7);  
  ln_latcan Number(12,7);  
  ln_loncen Number(12,7);  
  ln_latcen Number(12,7); 
Begin
   -- Longitud/Latitud de La Merced
   Begin
    Select u.fsx002lng,u.fsx002lat 
      Into ln_loncen,ln_latcen
      from dwextra.Fsx002 u
      where u.fsx002sucu = 11;
   Exception When Others Then
     ln_latcen:=null;
     ln_loncen:=null;
   End;   
   
   For x in c_detcan Loop
       ln_ubikey := PQ_TMP_CARGA_TRANSACC.fn_ubigeo_detcan(x.key_canal,x.cod_detcanal);
       -- Longitud/Latitud
          If x.key_canal = 1 Then --Agencias
             Begin
                  Select fsx002lng,fsx002lat
                    Into ln_loncan,ln_latcan
                    From dwextra.Fsx002
                   Where to_number(fsx002sucu) = x.cod_detcanal ;
             Exception When Others Then
                ln_loncan := null; ln_latcan:= Null;
             End;
       ElsIf x.key_canal = 2 Then --ATM
             Begin
                  Select jaqz233lon,jaqz233lat
                    Into ln_loncan,ln_latcan
                    From dwextra.jaqz233
                   Where trim(jaqz233atm) = x.cod_detcanal ;
             Exception When Others Then
                ln_loncan := null; ln_latcan:= Null;
             End;
       ElsIf x.key_canal = 5 Then --Corresponsal
             Begin
                  Select to_number(trim(jaql9aux1),'9990.00000000000000000'),
                         to_number(trim(jaql9aux2),'9990.00000000000000000')    
                    Into ln_loncan,ln_latcan
                    From dwextra.jaql009
                   Where jaql9nuele = x.cod_detcanal ;
             Exception When Others Then
                ln_loncan := null; ln_latcan:= Null;
             End;
       Else   
           ln_loncan := null; ln_latcan:= Null;    
       End If;
       
       IF ln_loncan is null and  ln_latcan is Null Then
          ln_loncan:= ln_loncen; 
          ln_latcan:= ln_latcen;
       End If;
       
       
       Update tmp_dm_detcanal d
          set d.ubigeo_key = ln_ubikey,
              d.lng_dcanal = ln_loncan,
              d.lat_dcanal = ln_latcan
        Where d.key_detcanal = x.key_detcanal
          and d.key_canal = x.key_canal;
       Commit;         
   End Loop;
End sp_ubicacion_detcan;
----------
Procedure sp_act_clatrx_gas
-- Fecha: 2019.0130
-- Auotr: Paola Vargas
-- Uso  : Clasifica transaciones según Gerencia de Ahorros y Servicios (GAS) 
Is
Begin
     /*Merge Into tmp_dm_transaccion t
     Using (select * from dwextra.ex_clasica_trx) e
        on (t.modulo = e.hcmod and 
            t.codtra = e.htran)
     WHEN MATCHED THEN                                         
         Update Set t.cod_subcla = e.cod_subcla,
                    t.des_subcla = e.des_subcla,
                    t.cod_clase  = e.cod_clase,
                    t.des_clase  = e.des_clase,
                    t.cod_grupo  = e.cod_grupo,
                    t.des_grupo  = e.des_grupo;*/
     Merge Into tmp_dm_transaccion t
     Using (select r.*,g.des_grupo,c.des_clase,s.des_subcla,a.des_area 
              from dwextra.ex_op_clastran r 
              join dwextra.ex_op_grupo g on g.cod_grupo=r.cod_grupo
              join dwextra.ex_op_clase c on c.cod_clase=r.cod_clase
              join dwextra.ex_op_subclase s on s.cod_subcla=r.cod_subcla
              join dwextra.ex_op_area a on a.cod_area=r.cod_area) e
        on (t.modulo = e.cod_modulo and 
            t.codtra = e.cod_tran)
     WHEN MATCHED THEN                                         
         Update Set t.cod_subcla = e.cod_subcla,
                    t.des_subcla = e.des_subcla,
                    t.cod_clase  = e.cod_clase,
                    t.des_clase  = e.des_clase,
                    t.cod_grupo  = e.cod_grupo,
                    t.des_grupo  = e.des_grupo;
                                   
Exception When Others Then
    Null;                    
End sp_act_clatrx_gas;
-----------------------------------------------------------------------------------------------
Function fn_rango_hora(PV_HORA In Varchar2)
Return Number
Is
  ln_rng Number(5);
  lv_hora Varchar2(10) := PV_HORA; 
Begin
      If    lv_hora between '00:00:00' and '00:30:00' Then ln_rng := 1;
      Elsif lv_hora between '00:30:01' and '01:00:00' Then ln_rng := 2;
      Elsif lv_hora between '01:00:01' and '01:30:00' Then ln_rng := 3;
      Elsif lv_hora between '01:30:01' and '02:00:00' Then ln_rng := 4;
      Elsif lv_hora between '02:00:01' and '02:30:00' Then ln_rng := 5;
      Elsif lv_hora between '02:30:01' and '03:00:00' Then ln_rng := 6;
      Elsif lv_hora between '03:00:01' and '03:30:00' Then ln_rng := 7;
      Elsif lv_hora between '03:30:01' and '04:00:00' Then ln_rng := 8;
      Elsif lv_hora between '04:00:01' and '04:30:00' Then ln_rng := 9;
      Elsif lv_hora between '04:30:01' and '05:00:00' Then ln_rng := 10;
      Elsif lv_hora between '05:00:01' and '05:30:00' Then ln_rng := 11;
      Elsif lv_hora between '05:30:01' and '06:00:00' Then ln_rng := 12;
      Elsif lv_hora between '06:00:01' and '06:30:00' Then ln_rng := 13;
      Elsif lv_hora between '06:30:01' and '07:00:00' Then ln_rng := 14;
      Elsif lv_hora between '07:00:01' and '07:30:00' Then ln_rng := 15;
      Elsif lv_hora between '07:30:01' and '08:00:00' Then ln_rng := 16;
      Elsif lv_hora between '08:00:01' and '08:30:00' Then ln_rng := 17;
      Elsif lv_hora between '08:30:01' and '09:00:00' Then ln_rng := 18;
      Elsif lv_hora between '09:00:01' and '09:30:00' Then ln_rng := 19;
      Elsif lv_hora between '09:30:01' and '10:00:00' Then ln_rng := 20;
      Elsif lv_hora between '10:00:01' and '10:30:00' Then ln_rng := 21;
      Elsif lv_hora between '10:30:01' and '11:00:00' Then ln_rng := 22;
      Elsif lv_hora between '11:00:01' and '11:30:00' Then ln_rng := 23;
      Elsif lv_hora between '11:30:01' and '12:00:00' Then ln_rng := 24;
      Elsif lv_hora between '12:00:01' and '12:30:00' Then ln_rng := 25;
      Elsif lv_hora between '12:30:01' and '13:00:00' Then ln_rng := 26;
      Elsif lv_hora between '13:00:01' and '13:30:00' Then ln_rng := 27;
      Elsif lv_hora between '13:30:01' and '14:00:00' Then ln_rng := 28;
      Elsif lv_hora between '14:00:01' and '14:30:00' Then ln_rng := 29;
      Elsif lv_hora between '14:30:01' and '15:00:00' Then ln_rng := 30;
      Elsif lv_hora between '15:00:01' and '15:30:00' Then ln_rng := 31;
      Elsif lv_hora between '15:30:01' and '16:00:00' Then ln_rng := 32;
      Elsif lv_hora between '16:00:01' and '16:30:00' Then ln_rng := 33;
      Elsif lv_hora between '16:30:01' and '17:00:00' Then ln_rng := 34;
      Elsif lv_hora between '17:00:01' and '17:30:00' Then ln_rng := 35;
      Elsif lv_hora between '17:30:01' and '18:00:00' Then ln_rng := 36;
      Elsif lv_hora between '18:00:01' and '18:30:00' Then ln_rng := 37;
      Elsif lv_hora between '18:30:01' and '19:00:00' Then ln_rng := 38;
      Elsif lv_hora between '19:00:01' and '19:30:00' Then ln_rng := 39;
      Elsif lv_hora between '19:30:01' and '20:00:00' Then ln_rng := 40;
      Elsif lv_hora between '20:00:01' and '20:30:00' Then ln_rng := 41;
      Elsif lv_hora between '20:30:01' and '21:00:00' Then ln_rng := 42;
      Elsif lv_hora between '21:00:01' and '21:30:00' Then ln_rng := 43;
      Elsif lv_hora between '21:30:01' and '22:00:00' Then ln_rng := 44;
      Elsif lv_hora between '22:00:01' and '22:30:00' Then ln_rng := 45;
      Elsif lv_hora between '22:30:01' and '23:00:00' Then ln_rng := 46;
      Elsif lv_hora between '23:00:01' and '23:30:00' Then ln_rng := 47;
      Elsif lv_hora between '23:30:01' and '23:59:59' Then ln_rng := 48;
      End If;
      
      Return ln_rng;

End fn_rango_hora;
-----------------------------------------------------------------------------------------------
Function fn_cod_region_op(PN_CODAGE In Number,
                          PD_FECHA  In Date) Return Number
Is 
   ln_codreg Number(5);
   ln_anio Number(4) := to_number(to_char(PD_FECHA,'rrrr'));
   ln_mes  Number(2) := to_number(to_char(PD_FECHA,'mm'));
Begin
   Select l.cod_region Into ln_codreg
     From dwextra.ex_regage l
    Where l.cod_sucurs = PN_CODAGE
      and l.num_mes  = ln_mes
      and l.num_anio = ln_anio;
   Return ln_codreg;
Exception When Others Then
   Return 0;      
End fn_cod_region_op;   
-----------------------------------------------------------------------------------------------
Function fn_key_region_op(PN_CODAGE In Number,
                          PD_FECHA  In Date) Return Number
Is 
   ln_codreg Number(5);
   ln_keyreg Number(10);
Begin
   ln_codreg := PQ_TMP_CARGA_TRANSACC.fn_cod_region_op(PN_CODAGE,PD_FECHA);

   Select l.key_region Into ln_keyreg
     From dwstage.tmp_dm_op_region l
    Where l.cod_region = ln_codreg;
   Return ln_keyreg;
Exception When Others Then
   Return 0;      
End fn_key_region_op; 
-----------------------------------------------------------------------------------------------
Function fn_key_motext(PN_GCOD In Number,
                       PN_CSUC In Number,
                       PN_CMOD In Number,
                       PN_TRAN In Number,
                       PN_NREL In Number,
                       PD_FECH In Date
                      )
Return Number                      
Is
  ln_nrel number(5);
  ln_mext number(5);
  ln_cmod number(10);
  lv_motext varchar2(200);
  ln_keymot number(5);
Begin    
     ln_cmod := PN_CMOD + 500;     
                   
     Select hnrel 
       Into ln_nrel
       From dwextra.fsx015 
      Where pgcod = PN_GCOD 
        and hcmod = ln_cmod 
        and hsucor= PN_CSUC 
        and htran = PN_TRAN 
        and hfcon = PD_FECH
        and trim(txtext) = to_char(PN_NREL)
        and txcod = 0
        and txreng= 1;
    
     Select upper(trim(txtext)) 
       Into lv_motext
       from dwextra.fsx015 
      where pgcod = PN_GCOD 
        and hcmod = ln_cmod 
        and hsucor= PN_CSUC 
        and htran = PN_TRAN 
        and hnrel = ln_nrel
        and hfcon = PD_FECH
        and txcod  = 519
        and txreng = 1;

     select key_motext 
       into ln_keymot
       from tmp_dm_motextorno 
      where des_motext=lv_motext;
     
     Return ln_keymot;
Exception When Others Then
    Return Null;      
End fn_key_motext;
-----------------------------------------------------------------------------------------------
Function fn_rango_importe(PN_IMPMN In Number)
Return Number
Is
  ln_rng Number(5);
Begin
          If PN_IMPMN  <= 50                    then ln_rng := 1;
       ElsIf PN_IMPMN between 50.01   and 100   then ln_rng := 2;
       ElsIf PN_IMPMN between 100.01  and 200   then ln_rng := 3;
       ElsIf PN_IMPMN between 200.01  and 500   then ln_rng := 4;
       ElsIf PN_IMPMN between 500.01  and 1000  then ln_rng := 5;
       ElsIf PN_IMPMN between 1000.01 and 5000  then ln_rng := 6;
       ElsIf PN_IMPMN between 5000.01 and 10000 then ln_rng := 7;
       ElsIf PN_IMPMN > 10000                   then ln_rng := 8;
       End If;

      Return ln_rng;

End fn_rango_importe;
-----------------------------------------------------------------------------------------------
 Function fn_porcom_agente(PN_CODMOD In Number,
                           PN_NUMTRX In Number,
                           PN_RNGIMP In Number)
 Return Number
 -- Porcentaje de comisión pago agentes
 Is
    ln_impcom Number(12,2);
 Begin
    Begin  
      Select l.impcom Into ln_impcom
        From dwextra.ex_op_comtrx l
       Where l.codmod = PN_CODMOD
         and l.codtrn = PN_NUMTRX
         and l.rngimp = PN_RNGIMP;
    Exception When NO_DATA_FOUND Then
              Begin 
                Select l.impcom Into ln_impcom
                  From dwextra.ex_op_comtrx l
                 Where l.codmod = PN_CODMOD
                   and l.codtrn = PN_NUMTRX
                   and l.rngimp = 9;
              Exception When Others Then
                  ln_impcom := 0;
              End;
    End;
    Return ln_impcom;
 End fn_porcom_agente;
-----------------------------------------------------------------------------------------------
----------
Procedure sp_act_tipopunto
-- Fecha: 2019.08.20
-- Auotr: Paola Vargas
-- Uso  : Identificación tipo de punto ATM (1:Agencia/2:Neutro/0:Ninguno)
Is
   cursor c_atm
       is  select u.id_tipoubicacion,d.key_detcanal,d.cod_detcanal,a.nom_atm,d.des_detcanal,
                  Case When u.id_tipoubicacion = 99 Then 1
                       When u.id_tipoubicacion = 100 Then 2
                       Else 0
                  end cod_punto,
                  Case When u.id_tipoubicacion = 99 Then 'AGENCIA'
                       When u.id_tipoubicacion = 100 Then 'NEUTRO'
                       Else 'NINGUNO'
                  end des_punto
              from microdata.equipo e join microdata.ubicacion_cajamatico u on u.id_ubicacion_cajamatico=e.id_ubicacion_cajamatico
               join microdata.atm a on a.id_equipo = e.id_equipo
               left join dwstage.tmp_dm_detcanal d on to_number(d.cod_detcanal) = e.cod_banktotal
                    and d.key_canal = 2 ;
            
Begin
     For x In c_atm Loop
         Update TMP_DM_detcanal
           set cod_tippun = x.cod_punto,
               des_tippun = x.des_punto
         Where key_detcanal = x.key_detcanal;
         Commit;       
     End Loop;  
     
     Update TMP_DM_detcanal
        set cod_tippun = 1,
            des_tippun = 'AGENCIA'
      Where key_canal =1;
     Commit;
       
     Update TMP_DM_detcanal
        set cod_tippun = 0,
            des_tippun = 'NINGUNO'
      Where key_canal not in (1,2); 
     Commit;          
End sp_act_tipopunto;
---------------------------------------------------------------------------------------------------------------
Procedure sp_op_comisiones (pn_ctaini in number, pn_ctafin in number,
                           Pc_FECHA  in varchar2)
  --------------------------------------------------------------------------------------
  -- Creación:
  ---------------------------------------------------------------------------------------
  -- Fecha  : 09/07/2018
  -- Autor  : 
  -- Cambios: 
  ---------------------------------------------------------------------------------------
  
  IS

   Cursor c_trx (ld_fech in date)
   
   Is
          Select distinct t.pgcod,t.hcmod,t.hsucor,t.htran,t.hnrel,
                 case when t.hcmod=140 OR T.HSUCOR=901 then 3 --INTERNET
                      when t.hcmod=489 OR T.HSUCOR=907 then 4 -- MOVIL
                      WHEN T.HCMOD=493 THEN 6 --KASNET
                      When t.hcmod=492 Then 1 -- AGENCIA
                      WHEN T.HCMOD=66 AND T.HTRAN in (85) THEN 11 --POS NAC
                      WHEN T.HCMOD=66 AND T.HTRAN in (12,27) THEN 20 --ATM VISA NAC
                      WHEN T.HCMOD=66 AND T.HTRAN = 14 THEN 21 --ATM UNICARD
                      WHEN T.HCMOD=66 AND T.HTRAN in (16,28) THEN 20--14 --ATM VISA EXT
                      WHEN T.HCMOD=66 AND T.HTRAN = 55 THEN 18 --COM.ELEC
                      WHEN T.HCMOD=66 AND T.HTRAN in (50) THEN 16 -- POS EXT
                      WHEN T.HCMOD=66 OR T.HSUCOR=903 THEN 2 --ATM
                      WHEN T.HCMOD=490 THEN 5 --AGENTE
                      WHEN (T.HCMOD=30 AND T.HTRAN IN (276,273)) OR T.HSUCOR=905 THEN 9 --BN
                      WHEN T.HCMOD=98 AND T.HTRAN=80 THEN 7 --'SCOTIABANK'
                      WHEN T.HCMOD=98 AND T.HTRAN=85 THEN 8 --'INTERBANK'
                      WHEN T.HSUCOR=908 THEN 10 --BILLETERA ELECT
                      ELSE 1 --'AG'
                 END CANAL,
                 T.HFCON,T.HHORA,trim(T.HUSING) HUSING,T.HCCORR      
          from dwextra.fsh015_16 t 
          where t.hcmod < 500
          and (t.hrubro like '52_229%' or 
               t.hrubro like '43_3010900002%' or
               t.hrubro like '52_208%')
          --and t.hcmod=50 and t.htran=426 and t.hsucor=6 and t.hnrel=11
          and t.hfcon=ld_fech;
          /*and ((t.hrubro like '11_102_%1' or t.hrubro like '11_102_%2' or t.hrubro like '11_102_%3') Or
                 (substr(t.hrubro,1,6) in ('191807','192807','291807','292807') ) Or
                 (substr(t.hrubro,1,8) in ('19180901',19280901) and substr(t.hrubro,12,2) between 91 and 98) Or
                 (substr(t.hrubro,1,6) in ('111109','112109') and substr(t.hrubro,13,1) between 1 and 3) Or
                 (substr(t.hrubro,1,6) in ('521229','522229') and substr(t.hrubro,13,1) = 1) Or
                 (substr(t.hrubro,1,6) in ('191801','291807','192801','292807')) Or
                 (t.hmodul in (21,22)) Or
                 (substr(t.hrubro,1,4) in ('1411','1414','1415','1416','1421','1424','1425','1426','2918','2928'))
               )*/
          --and t.hcmod = 66 and t.htran=530-- and hsucor=15
         
          --and hcmod=50 and htran=456 and hsucor=1 and hnrel=21
          --and t.hcmod=22;
               --and  hcmod = 22 and hsucor = 62 and htran=800 and hnrel=3;
           --and t.hsucor=1;
   Cursor c_det (ln_mod in number, ln_trx in number, ln_suc in number, ln_rel in number,ld_fechat in date) is
          Select f.hrubro,f.hcodmo,f.hmda,f.hmodul,f.hcta,f.hoper,f.hsubop,f.htoper,f.huscnf,f.hcord,f.hsucur,
                 f.hcimp1,f.hcsubo
            from dwextra.fsh015_16 f
           where hcmod = ln_mod and hsucor = ln_suc and htran=ln_trx and hnrel=ln_rel
             and hcta <> 999999999
             and (hrubro like '52_229%' Or 
                  hrubro like '43_3010900002%' Or
                  hrubro like '52_208%')
             and f.hfcon=ld_fechat
             --and decode(substr(hrubro,3,1),2,101,0) = hmda
         --Group By f.hrubro,f.hcodmo,f.hmda,f.hmodul,f.hcta,f.hoper,f.hsubop,f.htoper,f.huscnf,f.hcord,f.hsucur
         ;--Order by f.hcord;
               
   ln_imptrx number(12,2);
   lv_codcta varchar2(50);
   lv_ctauni varchar2(50);  
   lv_creuni varchar2(30);
   lv_codcre varchar2(30);
   lv_codcli varchar2(30);
   ln_impcom number(12,2);  
   ln_debhab number(1);
   ln_dehaco number(1);
   ln_tipmov number(1);   
   ln_rubcaj number(3); -- se agrego a 3 por transaccion libre
   lv_moneda varchar2(4);
   ln_debhab_2 number(1);
   ln_imptrx_2 number(12,2); 
   ln_usuari_2 varchar2(10); 
   lv_moneda_2 varchar2(4);
   ln_detcan number(10);
   lv_codcan varchar2(30);
   lv_imptrx_mn number(12,2);
   lv_imptrx_mn_2 number(12,2);
   lv_Feccar varchar2(10) := pq_tmp_carga_facts.FN_VALOR_PARAMETRO('1');
   ln_keyatm number(10);
   ld_fechatran date:=to_date(pc_fecha,'yyyymmdd');
   ln_tipcam number(7,3) := pq_tmp_carga_facts.fn_tipo_cambio_compra(ld_fechatran,800);
   LN_TARJETA NUMBER(10);
   ln_job     Number(5);
   lc_msgerr  varchar2(300);
   ln_ranhor Number(5);
   ln_regope Number(5);
   ln_keyext Number(5);
   ln_rngimp Number(5);
   ln_comagn Number(12,2); -- Comision agentes
   ln_colcap Number(5);
   ln_rubro Number(13);
   lv_propas varchar2(5);
   lv_sprpas varchar2(5);
   lv_succta varchar2(4);
   ln_rubpas number(16);
   ln_diapag number(5);
   ln_spract number(4);
   ln_proact number(4);
   ln_plazo  number(4);
   ln_tasint number(9,5);
   ln_modcre number(3);
   lv_mdacom number(4);
Begin
   -- Revisar que finalizaron los Jobs de Tarjetas
   Loop
       Select count(*) Into ln_job 
         From user_scheduler_jobs where job_name like 'DM_TARJETAS_%';
   Exit When ln_job = 0;    
   End Loop;
   
   Execute Immediate 'Truncate table tmp_fact_op_trxcom';
   
   For z in c_trx (ld_fechatran)Loop
       ln_imptrx := 0;
       ln_debhab := null;
       ln_impcom := 0;
       ln_dehaco := null;
       ln_tipmov := 2;
       ln_rubcaj := 0;
       ln_debhab_2:= null;
       ln_imptrx_2:= 0;
       ln_usuari_2:= null;
       lv_moneda := null;
       lv_moneda_2:=null;
       lv_codcta := null;
       lv_ctauni := null;
       lv_creuni := null;
       lv_codcli := null;
       lv_codcan := null;
       ln_detcan := null;
       lv_imptrx_mn:=0;
       lv_imptrx_mn_2:=0;
       ln_keyatm := null;
       lv_propas := null;
       lv_sprpas := null;
       lv_succta := null;
       LN_TARJETA:= pq_tmp_carga_transacc.fn_key_tarjeta('000');
       ln_ranhor := pq_tmp_carga_transacc.fn_rango_hora(z.HHORA);
                      ln_proact := '-1';
               ln_spract := '-1';
       
       For x in c_det(z.hcmod,z.htran,z.hsucor,z.hnrel,ld_fechatran) Loop
           --dbms_output.put_line('Detalle');
           ln_regope := pq_tmp_carga_transacc.fn_cod_region_op(z.hsucor,ld_fechatran);
           ln_impcom:= x.hcimp1; 
           ln_dehaco:= x.hcodmo;
           lv_mdacom:= x.hmda;
           ln_rubro := substr(x.hrubro,1,2)||0||substr(x.hrubro,4);
           lv_imptrx_mn := ln_impcom;
           
           If x.hmda = 101 /*and substr(x.hrubro,3,1) = 2*/  Then
              lv_imptrx_mn := ln_impcom * ln_tipcam;
           End If;   
          
           If z.canal <> 2 and ln_detcan is null Then
              If    z.canal = 1  Then lv_codcan:= to_char(z.hsucor);
              Elsif z.canal = 3  Then lv_codcan:= '901';
              Elsif z.canal = 4  Then lv_codcan:= '905'; 
              Elsif z.canal = 6  Then lv_codcan:= '802';
              Elsif z.canal = 7  Then lv_codcan:= '803';
              Elsif z.canal = 8  Then lv_codcan:= '804';
              Elsif z.canal = 9  Then lv_codcan:= '902';
              Elsif z.canal = 10 Then lv_codcan:= '908';
              Elsif z.canal = 14 Then lv_codcan:= '816';
              Elsif z.canal = 15 Then lv_codcan:= '807';
              Elsif z.canal = 18 Then lv_codcan:= '810';
              Elsif z.canal = 20 Then lv_codcan:= '815';
              Elsif z.canal = 21 Then lv_codcan:= '805';
              Elsif z.canal = 5 Then lv_codcan:= pq_tmp_carga_transacc.fn_cod_agente(z.hfcon,z.hcmod,z.hsucor,z.htran,z.hnrel);
              End If;
              ln_detcan := pq_tmp_carga_transacc.fn_key_detcanal(lv_codcan,z.canal);
           End If;
           
           -- Revisar detcanal de ATM
           IF Z.CANAL = 2 then 
              LN_TARJETA:= pq_tmp_carga_transacc.fn_tarjeta_trx(z.hcmod,z.htran,z.hnrel,z.hfcon);
           End if;
           If z.canal = 2 and ln_detcan Is Null Then
              Begin
                   lv_codcan := pq_tmp_carga_transacc.fn_atm_trx(z.hcmod,z.htran,z.hnrel,z.hfcon);   
                   ln_detcan := pq_tmp_carga_transacc.fn_key_detcanal(lv_codcan,z.canal);   
              Exception When Others Then
                   ln_detcan := null;
              End; 
           End If;
           
           -- Motivo de extorno
           If z.HCCORR = 99 Then
              ln_keyext := PQ_TMP_CARGA_TRANSACC.fn_key_motext(z.pgcod,z.hsucor,z.hcmod,z.htran,z.hnrel,z.HFCON);
           Else 
              ln_keyext := 0;          
           End If;
           
           -- Rango de importe exp.en moneda nacional
           ln_rngimp := pq_tmp_carga_transacc.fn_rango_importe(nvl(lv_imptrx_mn,0));
           If z.HCCORR <> 99 Then
              ln_comagn := pq_tmp_carga_transacc.fn_porcom_agente(z.hcmod,z.htran,ln_rngimp);
           Else
              ln_comagn := 0;
           End If;
           
           --- Cliente 
           lv_codcli := NVL(pq_tmp_carga_transacc.fn_CODCLIENTE(x.hcta),'0');
           --- Operaciones
           lv_codcta := '0';
           lv_ctauni := '0';
           lv_creuni := '0';
           
           --- Inserta Comisión
           Insert Into tmp_fact_op_trxcom (fecha, hora, pgcod, hcmod, hsucor, htran, hnrel,hcord,
                                           cod_canal, cod_usuario, ind_estado, val_importe,
                                           tipo_cambio,val_importe_mn,
                                           key_ingegr,
                                           key_tipomov,codigo_moneda,key_detcanal,cnt_transac,
                                           codigo_cuenta,cuenta_unica,credito_unico,
                                           codigo_cliente,key_atm, key_tarj,cod_ranhor,cod_regope,
                                           key_motext,key_rngimp,imp_porcom,cod_rubro,codigo_credito,
                                           hcsubo
                                          )
                                   values (z.HFCON,z.HHORA,z.pgcod,z.hcmod,z.hsucor,z.htran,z.hnrel,x.hcord,
                                           z.CANAL,z.HUSING,z.HCCORR,ln_impcom,ln_tipcam,lv_imptrx_mn,
                                           ln_dehaco,
                                           ln_tipmov,lv_mdacom,ln_detcan,1,
                                           lv_codcta,lv_ctauni,lv_creuni,lv_codcli,ln_keyatm,
                                           LN_TARJETA,ln_ranhor,ln_regope,
                                           ln_keyext,ln_rngimp,ln_comagn,ln_rubro,lv_codcre,x.hcsubo)
             LOG ERRORS INTO ERR$_TMP_FACT_OP_TRXCOM ('INSERT-'||lv_Feccar) REJECT LIMIT UNLIMITED;                                 
             Commit;
             
           
           /*
           If x.hrubro in (1111020000001,1111020000002,1111020000003,1121020000001,1121020000002,1121020000003) Then
              If  x.hrubro in (1111020000001,1121020000001) then
                 ln_keyatm := pq_tmp_carga_transacc.fn_key_atm(x.hsubop);
              End If;  
              If z.canal = 2 and ln_detcan is null Then
                 ln_detcan := pq_tmp_carga_transacc.fn_key_detcanal(to_char(x.hsubop),z.canal);
              End If;
              
              ln_rubcaj := ln_rubcaj + 1;
              If ln_rubcaj = 1 Then
                 ln_imptrx := x.hcimp1;
                 ln_debhab := x.hcodmo;
                 ln_tipmov := 1;
                 lv_moneda := x.hmda;
              ElsIf ln_rubcaj = 2 Then
                 ln_debhab_2:= x.hcodmo;
                 ln_imptrx_2:= x.hcimp1;
                 ln_usuari_2:= x.huscnf;
                 lv_moneda_2:= x.hmda;
              End If;
                          
              ElsIf substr(x.hrubro,1,6) in ('292807','291807') and substr(x.hrubro,12,2)=28 then
                    ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda;                   
                    If z.canal = 16 then 
                       ln_detcan := pq_tmp_carga_transacc.fn_key_detcanal('808',16);
                    ElsIF (z.canal = 14) or (x.hsucur <> 903 and ln_detcan is null) then   
                       ln_detcan := pq_tmp_carga_transacc.fn_key_detcanal('805',14);
                    ElsIf x.hsucur=903 and ln_detcan is null then
                        ln_detcan := pq_tmp_carga_transacc.fn_key_detcanal(to_char(x.hsucur),11);
                    End If;
           ElsIf (substr(x.hrubro,1,8) in ('19180901',19280901) and substr(x.hrubro,12,2) between 91 and 99) Then
                 If nvl(ln_imptrx,0) = 0 then ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda; End If;
           ElsIf (substr(x.hrubro,1,6) in ('111109','112109') and substr(x.hrubro,13,1) between 1 and 3) Then
                 If nvl(ln_imptrx,0) = 0 then ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda; End If;
           Elsif substr(x.hrubro,1,6) in ('191807','192807') and substr(x.hrubro,12,2) in (37,40) Then
                 If nvl(ln_imptrx,0) = 0 then ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda; End If;
           Elsif substr(x.hrubro,1,4) in ('4619','4629') and substr(x.hrubro,12,2) = 10 Then
                 If nvl(ln_imptrx,0) = 0 then ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda; End If;
           ElsIf (substr(x.hrubro,1,4) in ('2918','2928')) Then
                 If nvl(ln_imptrx,0) = 0 then ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda; End If;
           ElsIf z.hcmod = 99 and z.htran = 73 and x.hcord = 80 then -- Cuota Diferida
                 ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda;
           ElsIf (substr(x.hrubro,1,6) in ('251419','252419')) Then
                 If nvl(ln_imptrx,0) = 0 then ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda; End If;
              
           ElsIf substr(x.hrubro,1,6) in ('421229','422229') Then
                 If nvl(ln_imptrx,0) = 0 then ln_imptrx:= x.hcimp1;  ln_debhab := x.hcodmo; lv_moneda := x.hmda; End If;
           End If;
           */
           -- Cuenta de depositos
           /*If x.hmodul in (21,22,426) Then
              --
              If z.canal = 5 Then
                 Select count(*) Into ln_colcap
                   from dwextra.jaql006 h
                  Where h.jaql6cta02 = x.hcta
                    and h.jaql6ope02 = x.hoper
                    and h.jaql6mda02 = x.hmda
                    and h.jaql6sbo02 = x.hsubop
                    and h.jaql6top02 = x.htoper
                    and h.jaql6ctmod = z.hcmod
                    and h.jaql6cttra = z.htran
                    and h.jaql6ctrel = z.hnrel
                    and h.jaql6ctfco = z.hfcon;
              Else
                 ln_colcap := 0;
              End If;
              
              If ln_colcap = 0 Then
                  
                  lv_codcta:= (case when x.hmodul=426 then 22 else x.hmodul end)||'-'||x.hmda||'-'||x.hcta||'-'||x.hoper||'-'||x.hsubop||'-'||x.htoper;
                  If length(lv_codcta) > 30 then
                     dbms_output.put_line(z.hcmod||'-'||z.hsucor||'-'||z.htran||'-'||z.hnrel||':'||lv_codcta); 
                  End If;
                  lv_ctauni:= lv_codcta;
                     If x.hmodul in (22,426) Then
                        lv_ctauni := '22-'||x.hmda||'-'||x.hcta||'-'||x.hoper;
                     End If;   
              
                  If z.hcmod = 22 and x.hmodul = 22 Then
                     ln_imptrx:= x.hcimp1;
                     ln_debhab := x.hcodmo;
                     lv_moneda := x.hmda;
                  ElsIf z.hcmod = 22 and x.hmodul = 21 and x.hcimp1 > ln_imptrx Then
                     ln_imptrx:= x.hcimp1;
                     ln_debhab := x.hcodmo;
                     lv_moneda := x.hmda;
                  ElsIf z.hcmod <> 22 and x.hmodul = 426 Then
                     ln_imptrx:= x.hcimp1;
                  ElsIf z.hcmod <> 22 Then
                     If nvl(ln_imptrx,0) = 0 Or x.hcimp1 > ln_imptrx then 
                        ln_imptrx:= x.hcimp1;
                        ln_debhab := x.hcodmo;
                        lv_moneda := x.hmda; 
                     End If;
                  End If;
              End If;
              -- Producto
              lv_succta := '0';
              ln_rubpas := x.hrubro;
              If x.hmodul = 426 Then
                 Begin 
                     Select u.rubro Into ln_rubpas
                       From dwextra.fsr014  u
                      Where rrrubr = x.hrubro 
                        and rrcod=1;
                 Exception When Others Then
                     ln_rubpas := x.hrubro;
                 End;
              End If;
              
              If x.hmodul in (22,426) and ln_rubpas like '28_101%' then lv_propas := '221';
              ElsIf x.hmodul in (22,426) and ln_rubpas not like '28_101%' then lv_propas := x.hmodul;
              ElsIf x.hmodul = 21 and x.htoper = 2 then lv_propas := to_char(x.hmodul)||'1';
              ElsIf x.hmodul = 21 and x.htoper <> 2 then lv_propas := x.hmodul;
              Else lv_propas := '0';
              End If;
              -- SubProducto
              If x.hmodul = 21 and x.htoper not in (0,2) then lv_sprpas := x.htoper;
              ElsIf x.hmodul = 21 and x.htoper = 0 then lv_sprpas := '1';
              ElsIF x.hmodul in (22,426) and ln_rubpas like '28_101%' then lv_sprpas:= substr(x.hrubro,13,1);
              ElsIF x.hmodul in (22,426) and ln_rubpas not like '28_101%' and x.htoper in (0,1,5) then lv_sprpas:='1';
              ElsIF x.hmodul in (22,426) and ln_rubpas not like '28_101%' and x.htoper not in (0,1,5) then lv_sprpas := x.htoper;
              ElsIf x.hmodul = 21 and x.htoper = 2 Then
                    Begin
                       select bctasa 
                         into ln_tasint 
                         from dwextra.fsh012 
                        where bcmod=x.hmodul and bccta=x.hcta and bcoper=x.hoper 
                          and bcsbop=x.hsubop and bctop=x.htoper and bcmda=x.hmda;
                   Exception When Others Then
                      ln_tasint := 0;
                   End;       
                   lv_sprpas := pq_tmp_carga_facts.fn_tipo_cts(x.hmda,ln_tasint,z.HFCON);
              Else
                 lv_sprpas := '0'; 
              End If;
              
              If lv_propas Is not Null Then
                 lv_succta := x.hsucur; 
              End If;
              
           End If;
           -- Nro. de credito
           If substr(x.hrubro,1,4) in (1411,1421,1414,1424,1415,1425,1416,1426) Then
              
                  ln_modcre := x.hmodul;
              
              
              lv_codcre := pq_tmp_carga_facts.fn_codigo_credito(z.pgcod,ln_modcre,x.hmda,x.hcta,x.hoper,x.hsubop,x.htoper);
              lv_creuni := pq_tmp_carga_facts.fn_credito_unico(z.pgcod,ln_modcre,x.hmda,x.hcta,x.hoper,x.hsubop,x.htoper);
              If lv_codcli is null Then
                 lv_codcli := pq_tmp_carga_transacc.fn_CODCLIENTE(x.hcta);
              End If;
              -- Producto
              --Plazo
              Begin
                 Select d.aopzo Into ln_plazo
                   from tmp_dm_credito d
                  where d.aomod = ln_modcre
                    and d.aomda = x.hcta
                    and d.aocta = x.hcta
                    and d.aoope = x.hoper
                    and d.aosbo = x.hsubop
                    and d.aotop = x.htoper;
              Exception When Others Then
                 ln_plazo := 0;
              End;
              
              ln_proact := pq_tmp_carga_facts.fn_modulo_origen(1,ln_modcre,x.hmda,x.hcta,x.hoper,x.hsubop,x.htoper,ln_plazo,
                                                  (case When ln_modcre in (33,65) and x.hrubro Is null 
                                                        Then PQ_TMP_CARGA_FACTS.fn_tipo_credito_casven(1,ln_modcre,x.hmda,x.hcta,x.hoper,x.hsubop,x.htoper)
                                                            When substr(x.hrubro,5,2)='03' and x.hmodul=116 Then 31 
                                                            Else to_number(substr(x.hrubro,5,2))
                                                       end),
                                                      x.hrubro);
              ln_spract := pq_tmp_carga_facts.fn_tipope_origen(1,ln_modcre,x.hmda,x.hcta,x.hoper,x.hsubop,x.htoper,ln_plazo,
                                                      (case When ln_modcre in (33,65) and x.hrubro Is null 
                                                        Then PQ_TMP_CARGA_FACTS.fn_tipo_credito_casven(1,ln_modcre,x.hmda,x.hcta,x.hoper,x.hsubop,x.htoper)
                                                            When substr(x.hrubro,5,2)='03' and x.hmodul=116 Then 31 
                                                            Else to_number(substr(x.hrubro,5,2))
                                                       end),
                                                      x.hrubro);
                                                      
              
              
              
              
           End If;*/
           
       End Loop; 
     End Loop;
  Exception When others then 
             lc_msgerr := sqlerrm;
             insert into LOG_CARGA_TMP(NOMBRE_TABLA,DESCRIPCION,FECHA_CARGA,TIPO_TMP,ESTADO_TMP)
             values ('tmp_fact_op_trxcom',lc_msgerr,lv_Feccar,null,null); 
             Commit; 

  End sp_op_comisiones;
------------------------------------------------------------------------------------------------------------------
  Function fn_atm_trx(PN_MODTRX in Number,
                      PN_CODTRX in Number,
                      PN_RELTRX in Number,
                      PD_FECHA IN DATE)
  Return Varchar2
  IS
     lv_codatm VARCHAR(10); 
  Begin
     
      Begin
          Select to_char(to_number(c.jaql540coter))
            Into lv_codatm
            From jaql540@produ c
           Where c.jaql540feini = PD_FECHA
             and c.jaql540modul = PN_MODTRX
             and c.jaql540trans = PN_CODTRX
             and c.jaql540relac = PN_RELTRX;
      Exception When Others Then
         IF PD_FECHA <> TRUNC(SYSDATE) THEN
         Begin
           select trim(z0e4geter) Into lv_codatm
             from z0e4ge@produ
            where z0e4gefec = PD_FECHA
              and z0e4gemod = PN_MODTRX
              and z0e4getrn = PN_CODTRX
              and z0e4gerel = PN_RELTRX;
         Exception When Others Then
             lv_codatm := null;
         End;
         ELSE
            lv_codatm := null;
         END IF;
     End;
     
     Return lv_codatm;
    
  End fn_atm_trx;
-----------------------------------------------------------------------------------------------
  Function fn_cliente_compraventa(PN_GCOD In Number,
                                  PN_CMOD In Number,
                                  PN_CTRX In Number,
                                  PN_CSUC In Number,
                                  PN_NREL In Number,
                                  PD_FECH In Date
                                 )   
  Return Varchar2
  Is
     lv_codcli tmp_dm_cliente.codigo_cliente%type;
     lv_nomcli varchar2(300);
  Begin
       Begin
            Select Case when length(trim(txtord)) = 11 then '6049'||trim(txtord) 
                        else '60421'||trim(txtord) 
                   End     
              Into lv_codcli
              From dwextra.fsx016 s
             Where s.pgcod = PN_GCOD
               and s.hcmod = PN_CMOD
               and s.hsucor= PN_CSUC
               and s.htran = PN_CTRX
               and s.hnrel = PN_NREL
               and s.hfcon = PD_FECH
               and s.txcod = 6;
       Exception When Others Then
            lv_codcli := '0';
       End;
       
       If lv_codcli = '0' Then  
          -- Buscar por nombre            
             Begin
                Select trim(upper(txtord)) Into lv_nomcli
                  From dwextra.fsx016 s
                 Where s.pgcod = PN_GCOD
                   and s.hcmod = PN_CMOD
                   and s.hsucor= PN_CSUC
                   and s.htran = PN_CTRX
                   and s.hnrel = PN_NREL
                   and s.hfcon = PD_FECH
                   and s.txcod = 5;
                   
                   --- Buscar codigo Cliente
                   Begin
                         SElect n.codigo_cliente Into lv_codcli
                           FRom dwstage.tmp_dm_cliente n
                          Where trim(upper(nombre_cliente)) = lv_nomcli; 
                   Exception When Others Then
                       lv_codcli := 0;
                   End; 
             Exception When Others Then
                lv_codcli := '0';
             End;
       ENd IF;
       
       Return lv_codcli;
       
  End fn_cliente_compraventa;
-----------------------------------------------------------------------------------------------
  Procedure SP_OP_APE_AHORROS(PD_FECHA In Date)
  Is 
      Cursor c_aper(ld_Fec In Date)
          is Select s.bcfval,s.bcsuc,s.bcrubr,s.bcmda,s.bcpap,s.bccta,s.bcoper,s.bcsbop,s.bctop,s.bcmod,s.bcemp,
                 s.bcmod||'-'||s.bcmda||'-'||s.bccta||'-'||s.bcoper||'-'||s.bcsbop||'-'||s.bctop cueuni,
                 s.bcmod||'-'||s.bcmda||'-'||s.bccta||'-'||s.bcoper||'-'||s.bcsbop||'-'||s.bctop cuenta,
                 trim(a.cv1aux6) codusu,
                 Case When trim(a.cv1aux6) = 'USRMOVIL' Then 4 --'Movil'
                      When trim(a.cv1aux6) = 'NSBTUSER' Then 4 --3 --'IB'
                      Else 1--'Agencia'
                 End codcan,
                 Case When trim(a.cv1aux6) in ('USRMOVIL','NSBTUSER') Then pq_tmp_carga_transacc.fn_key_detcanal('905',4) --'Movil'
                      --When trim(a.cv1aux6) = 'NSBTUSER' Then pq_tmp_carga_transacc.fn_key_detcanal('901',3) --'IB'
                      Else pq_tmp_carga_transacc.fn_key_detcanal(s.bcsuc,1)--'Agencia'
                 End detcan,
                 trim(s.pepais||s.petdoc||s.pendoc) codcli,
                 Case when s.bcmod = 21 and s.bctop <> 2 then 2100
                      else 2102
                 End hcmod,
                 1 hcord, 1 hsbord, 
                 decode(s.bcprod,99,99,0) indest, s.bcsuc succta,
                 1 keying, 2 keymov, 1 cnttrx,
                 s.bctasa,
                 Case When trim(a.cv1aux6) in ('USRMOVIL','NSBTUSER') Then 907
                      Else s.bcsuc
                 End hsucor
           from dwextra.fsh012 s
           Join dwextra.fse113 a
             on a.pgcod = s.bcemp
            and a.cv1mod = s.bcmod
            and a.cv1mda = s.bcmda
            and a.cv1pap = s.bcpap
            and a.cv1cta = s.bccta
            and a.cv1suc = s.bcsuc
            and a.cv1oper= s.bcoper
            and a.cv1sbop= s.bcsbop
            and a.cv1tope= s.bctop
          Where s.bcmod = 21
            and s.bcfech = ld_Fec
            and s.bcfval = ld_Fec
            Order by s.bcsuc;
            
        ld_fecha date := PD_FECHA;        
        ln_hreg number(5);
        lv_sprpas varchar2(10);
        lv_propas varchar2(10);
        ln_tcam number(7,3) := pq_tmp_carga_facts.fn_tipo_cambio_fijo(ld_fecha); 
        ln_rhor number(5);
        lv_hora varchar2(10);
        ln_rego number(5); 
        ln_impa number(12,2);     
        ln_htrx number(4);   
        ln_mod  number(4);
        ln_top  number(4);
        ln_rngi number(10); 
        ln_imps number(12,2); 
        ln_suc  number(5);
        ln_indest number(5);
        ----
        lv_cuenta varchar2(50);
        ln_detcan number(10);
        ln_canal  number(10);

  Begin
        Execute Immediate('Truncate Table tmp_fact_op_ape_ahorro');
        Execute Immediate('Truncate Table err$_tmp_fact_op_ape_ahorro');
        -- recrear indice.
       begin
           -- Call the procedure
           dwextra.pq_tmp_extrae_fuentes.sp_tb_re_indice_fsh015_16(p_n_codtab => 64,
                                                  p_c_tbspidx => 'DWEXTRA_IDX',
                                                  p_c_usuario => 'DWEXTRA');
       end;
       
        
        ln_hreg := 0;
          For x in c_aper(ld_Fecha) Loop
              If ln_hreg = 0 or x.bcsuc = ln_suc Then
                 ln_hreg := ln_hreg + 1;
              Else 
                 ln_hreg := 1;
              End If;   
              ln_suc := x.bcsuc;
              --- Importe de Primer Depósito el mismo día
              Begin
                  Select hhora,hcimp1,decode(x.bcmda,0,hcimp1,hcimp1*ln_tcam)
                    Into lv_hora,ln_impa,ln_imps
                    From (
                           
                          Select /*+index(d IX_FSH01516_2) */
                                 d.hhora, d.hcimp1
                            From dwextra.fsh015_16 d
                           Where d.hfcon = x.bcfval
                             and d.hcmod < 500
                             and d.hccorr <> 99
                             and d.hcta = x.bccta
                             and d.hmda = x.bcmda
                             and d.hmodul = x.bcmod
                             and d.htoper = x.bctop
                             and d.hsubop = x.bcsbop
                             and d.hcodmo = 2
                             Order by d.hhora,d.hcord,d.hcsubo
                         )
                    Where Rownum = 1;
              Exception When Others Then
                 lv_hora := '10:00:00';
                 ln_impa := 0;
                 ln_imps := 0;
              End;
        
              --- Producto
              ln_mod := x.bcmod;
              ln_top := x.bctop;
                 
              If ln_mod = 21 and ln_top = 2 then lv_propas := to_char(ln_mod)||'1';
              ElsIf ln_mod = 21 and ln_top <> 2 then lv_propas := to_char(ln_mod);
              Else lv_propas := '0';
              End If;
              
              -- SubProducto
              If ln_mod = 21 and ln_top not in (0,2) then lv_sprpas := ln_top;
              ElsIf ln_mod = 21 and ln_top = 0 then lv_sprpas := '1';
              ElsIf ln_mod = 21 and ln_top = 2 Then
                    lv_sprpas := dwstage.pq_tmp_carga_facts.fn_tipo_cts(x.bcmda,x.bctasa,x.bcfval);
              End If;    
              
              ln_rhor := pq_tmp_carga_transacc.fn_rango_hora(lv_hora);
              ln_rego := dwstage.pq_tmp_carga_transacc.fn_cod_region_op(x.bcsuc,x.bcfval);
              ln_rngi := pq_tmp_carga_transacc.fn_rango_importe(nvl(ln_imps,0));
              
              -- Fecha de cancelacion y codigo de cuenta
              Begin
                  Select case when c.fecha_cancelacion is null or c.fecha_cancelacion > x.bcfval Then 0 Else 99 End,
                         cod_cuenta
                    Into ln_indest,lv_cuenta
                    From tmp_dm_cuenta c
                    Where c.pgcod = x.bcemp
                      and c.aomod = x.bcmod
                      and c.aomda = x.bcmda
                      and c.aocta = x.bccta
                      and c.aoope = x.bcoper
                      and c.aosbo = x.bcsbop
                      and c.aotop = x.bctop;
              Exception When Others Then
                ln_indest := x.indest;
                lv_cuenta := null;
              End;    
              
              ---- CANAL
              Begin
                   Select case when aqpa705AUXV5 = 'HB' Then 648
                               when aqpa705AUXV5 = 'APP' Then 649
                               when aqpa705AUXV5 = 'WEB' Then 4000
                               when aqpa705AUXV5 = 'KIOSCO' Then 4001 
                               when aqpa705CANAL = 3 Then 648
                               when aqpa705CANAL = 6 Then 649
                               when aqpa705CANAL = 7 Then 4000
                               when aqpa705CANAL = 8 Then 4001
                               else null
                          end detcan,     
                          case when aqpa705AUXV5 = 'HB' Then 4
                               when aqpa705AUXV5 = 'APP' Then 5
                               when aqpa705AUXV5 = 'WEB' Then 7
                               when aqpa705AUXV5 = 'KIOSCO' Then 8 
                               when aqpa705CANAL = 3 Then 4
                               when aqpa705CANAL = 6 Then 5
                               when aqpa705CANAL = 7 Then 7
                               when aqpa705CANAL = 8 Then 8
                               else null
                         end canNAL/*,         
                         aqpa705ctmod hcmod,aqpa705ctsuc hsuc,aqpa705cttra htra, aqpa705ctrel hrel,
                         aqpa705fectra fecha, d.aqpa705ctaori cta*/
                    Into ln_detcan,ln_canal 
                    From DWEXTRA.AQPA705 d --aqpa705@produ d
                   Where aqpa705fectra = x.bcfval
                    and aqpa705tipope = 'A'
                    and d.aqpa705ctaori = lv_cuenta;
                    
                    -- Transaccion
                    ln_htrx := ln_canal||x.bctop;
              Exception When Others Then
                ln_detcan:= null; ln_canal := null;
                ln_htrx:= null;
              End; 
              
              
              -- Cod.TRX
              If ln_htrx is null then 
                 If x.codcan = 1 Then ln_htrx:= 1;
                 ElsIf x.codcan = 3 Then ln_htrx:= 4;
                 Elsif x.codcan = 4 Then ln_htrx:= 5;
                 End If;
                 ln_htrx := ln_htrx||to_char(lv_sprpas);
              End If;   
              
              If ln_detcan Is Null Then
                 ln_detcan := x.detcan;
                 ln_canal  := x.codcan;
              End If;
              
              --- INSERTA
              Insert Into tmp_fact_op_ape_ahorro(fecha,hora,pgcod,hcmod,hsucor,hnrel,hcord,hsbor,
                                                 cod_canal,cod_usuario,ind_estado,codigo_moneda,
                                                 val_importe,tipo_cambio,key_ingegr,key_tipomov,
                                                 key_detcanal,codigo_cliente,cod_agencia,cnt_transac,
                                                 codigo_cuenta,cuenta_unica,codpro_pas,subpro_pas,
                                                 n_taspas,cod_succta,cod_regope,cod_ranhor,key_rngimp,
                                                 val_importe_mn,htran)
              Values(x.bcfval,lv_hora,x.bcemp,x.hcmod,x.hsucor,ln_hreg,x.hcord,x.hsbord,
                     ln_canal,-- x.codcan,
                     x.codusu,ln_indest,x.bcmda,
                     ln_impa,ln_tcam,x.keying,x.keymov, 
                     ln_detcan,--x.detcan,
                     x.codcli,x.bcsuc,x.cnttrx,
                     x.cuenta,x.cueuni,lv_propas,lv_sprpas,
                     x.bctasa,x.bcsuc,ln_rego,ln_rhor,ln_rngi,
                     ln_imps,ln_htrx)
              LOG ERRORS INTO err$_tmp_fact_op_ape_ahorro('MERGE-' || to_char(sysdate,'rrrrmmdd')) 
              REJECT LIMIT UNLIMITED;
              
              COMMIT;
             
          End Loop;
  Exception When Others Then
      Null;        
  End SP_OP_APE_AHORROS;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  FUNCTION fn_key_pais_estdep(PD_FECHA In Date,
                       PN_MODTR In Number,
                       PN_CODTR In Number,
                       PN_NUMRL In Number,
                       PN_SUCTR In Number
                      )
  RETURN Number
  Is
     ln_kpais  Number(10);
     lv_pais   Varchar2(4);
     lv_estdep Varchar2(20);
  BEGIN    
        Select count(*) Into ln_kpais
          from dwextra.ext_op_trasacc p 
         where p.trmod = PN_MODTR
           and p.trtra = PN_CODTR
           and p.trpais = 1
           and p.trcon = 'X';
        
        If ln_kpais = 0 Then
           ln_kpais := 1;
        Else               
            Begin      
                Select upper(trim(substr(jaqy254ubtra,39,4))) pais,
                       upper(trim(substr(jaqy254ubtra,26,13))) estdep
                  Into lv_pais,lv_estdep
                  From DWEXTRA.jaqy254
                 Where jaqy254fefin = PD_FECHA
                   and jaqy254modtr = PN_MODTR
                   and jaqy254codtr = PN_CODTR
                   and jaqy254reltr = PN_NUMRL
                   and jaqy254suctr= PN_SUCTR;
             Exception When Others Then
                lv_pais := 'NI';
                lv_estdep := 'N/I';
             End;  
         
             Begin
                 Select o.key_estdep
                   Into ln_kpais
                   From TMP_DM_PAIS_ESTDPT o
                  Where o.des_estdep = lv_estdep
                    and o.cod_pais_iso2 = lv_pais;
             Exception When Others Then
                ln_kpais := 1;
             End;  
         End If;
         Return ln_kpais;
  END fn_key_pais_estdep;         
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  FUNCTION fn_key_comercio_pos(PD_FECHA In Date,
                       PN_MODTR In Number,
                       PN_CODTR In Number,
                       PN_NUMRL In Number,
                       PN_SUCTR In Number
                      )
  RETURN Number
  Is
     ln_kcom  Number(10);
     lv_pais   Varchar2(4);
     lv_estdep Varchar2(20);
     lv_compos Varchar2(50);
  BEGIN    
        Select count(*) Into ln_kcom
          from dwextra.ext_op_trasacc p 
         where p.trmod = PN_MODTR
           and p.trtra = PN_CODTR
           and p.trcompos = 1
           and p.trcon = 'X';
        
        If ln_kcom = 0 Then
           ln_kcom := 1;
        Else               
            Begin      
                Select upper(trim(substr(jaqy254ubtra,39,4))) pais,
                       upper(trim(substr(jaqy254ubtra,26,13))) estdep,
                       upper(TRIM(substr(jaqy254ubtra,1,25))) comercio
                  Into lv_pais,lv_estdep, lv_compos
                  From DWEXTRA.jaqy254
                 Where jaqy254fetra = PD_FECHA
                   and jaqy254modtr = PN_MODTR
                   and jaqy254codtr = PN_CODTR
                   and jaqy254reltr = PN_NUMRL
                   and jaqy254suctr = PN_SUCTR;
             Exception When Others Then
                lv_pais := 'NI';
                lv_estdep := 'N/I';
                lv_compos := 'N/I';
             End;  
         
             Begin
                 Select o.key_compos
                   Into ln_kcom
                   From TMP_DM_COMERCIO_POS o
                  Where o.des_compos = lv_compos
                    and o.cod_pais   = lv_pais
                    and o.des_estdep = lv_estdep;
             Exception When Others Then
                ln_kcom := 1;
             End;  
         End If;
         Return ln_kcom;
  END fn_key_comercio_pos;         
  
-----------------------------------------------------------------------------------------------
Procedure SP_CLASIF_CLITRX(PD_FECHA In Date)
Is
Begin
   PQ_TMP_CARGA_TRANSACC.SP_CLITRX_BASE(PD_FECHA);
   PQ_TMP_CARGA_TRANSACC.SP_CLASIF_CLITRX_APP(PD_FECHA);
   PQ_TMP_CARGA_TRANSACC.SP_CLISINTRX_APP(PD_FECHA);
   PQ_TMP_CARGA_TRANSACC.SP_DATOS_CLISINTRX_APP(PD_FECHA);
   PQ_TMP_CARGA_TRANSACC.SP_CLASIF_CLITRX_COMPRAS(PD_FECHA);
End SP_CLASIF_CLITRX;
-----------------------------------------------------------------------------------------------
Procedure SP_CLITRX_BASE(PD_FECHA In Date)
Is
    ld_mesant date := last_day(add_months(PD_FECHA,-1)); 
    ln_perant number := to_number(to_char(ld_mesant,'rrrrmm'));
    ln_tmpkey number(10);
Begin
    Execute Immediate 'Truncate table tmp_fact_op_clitrx';
    ln_tmpkey := dwhouse.pq_carga_facts.fn_tiempo_key(ld_mesant);
    IF ln_tmpkey Is Null Then
       select max(fecha) Into ld_mesant From dwhouse.dm_tiempo where periodo = ln_perant;
       ln_tmpkey := dwhouse.pq_carga_facts.fn_tiempo_key(ld_mesant);
    End If;
    
    Insert Into tmp_fact_op_clitrx(tiempo_key,cliente_key,cod_cliente,
                                   cnt_trxapp,cnt_compos,cnt_comint,
                                   fec_utxapp,fec_ucmpos,fec_ucmint,
                                   periodo,ind_tippro,imp_compos,imp_comint
                                  )
    Select ln_tmpkey,tr.cliente_key,cl.codigo_cliente,
           sum(case when cn.cod_canorg = 5 Then 1 else 0 end) cnt_trxapp,
           sum(case when cn.cod_canorg = 7 Then 1 else 0 end) cnt_compos,
           sum(case when cn.cod_canorg = 8 Then 1 else 0 end) cnt_comint,
           max(case when cn.cod_canorg = 5 Then tm.fecha end) fec_utxapp,
           max(case when cn.cod_canorg = 7 Then tm.fecha end) fec_ucmpos,
           max(case when cn.cod_canorg = 8 Then tm.fecha end) fec_ucmint,
           tm.periodo,1,
           sum(case when cn.cod_canorg = 7 Then tr.importe_mn else 0 end) imp_compos,
           sum(case when cn.cod_canorg = 8 Then tr.importe_mn else 0 end) imp_comint
      From dwhouse.FACT_OP_TRANSACCION TR
      Join dwhouse.dm_tiempo TM on TM.TIEMPO_KEY = TR.TIEMPO_KEY
      Join dwhouse.dm_transaccion X on x.transacc_key = TR.Transacc_Key
      Join dwhouse.dm_detcanal d on d.key_detcanal = tr.key_detcanal
      Join dwhouse.dm_canal cn on cn.key_canal = d.key_canal
      Join dwhouse.dm_cliente cl on cl.cliente_key = tr.cliente_key
     Where tm.periodo = ln_perant
       and tr.cnt_transacc = 1
       and tr.ind_estado <> 99
       and cn.cod_canorg in (5,7,8) --5:MOVI
    group by  tr.cliente_key,cl.codigo_cliente,tm.periodo;
    
    Commit;
End SP_CLITRX_BASE;    
-----------------------------------------------------------------------------------------------
Procedure SP_CLASIF_CLITRX_APP(PD_FECHA In Date)
-- Clasificación de clientes que realizan transacciones desde APP
Is
   Cursor c_clien
       IS SElect r.cod_cliente,r.tiempo_key,r.cliente_key,r.ind_oc1app,r.ind_oc2app,
                 r.ind_rc1app,r.ind_rc2app,r.ind_nueapp,
                 (nvl(ind_nueapp,0) + nvl(ind_oc1app,0) + nvl(ind_oc2app,0) + nvl(ind_rc1app,0) + nvl(ind_rc2app,0)) totcli
            from tmp_fact_op_clitrx r
           Where nvl(cnt_trxapp,0) > 0 and ind_tippro = 1;
   
   ln_saldo number(12,2);
   ln_ctas number(5);
   ln_nuevo number(1);
   ln_ocac1 number(1);
   ln_ocac2 number(1);
   ln_recu1 number(1);
   ln_recu2 number(1);

   ln_mesr2 number(3) := 1;
   ln_mesr1 number(3) := 3;
   ln_meso1 number(3) := 6;
   ln_sdooc number(12,2) := 50;
   ln_pernue number(6) := 201501;
   
   ld_mesant date := last_day(add_months(PD_FECHA,-1)); 
   ln_period number(6) := to_number(to_char(ld_mesant,'rrrrmm'));
   ln_mesoca number(6) := to_number(to_char(add_months(to_date(to_char(ln_period,'999999')||'01','rrrrmmdd'),-6),'rrrrmm'));
   ln_mesrec number(6) := to_number(to_char(add_months(to_date(to_char(ln_period,'999999')||'01','rrrrmmdd'),-3),'rrrrmm'));
   ln_mesant number(6) := to_number(to_char(add_months(to_date(to_char(ln_period,'999999')||'01','rrrrmmdd'),-1),'rrrrmm'));
   
   lv_mail varchar2(200);
   lv_ncel varchar2(20);
   ln_clasc Number(5);
   
BEGIN
   --- ACTUALIZA RECURRENTES2
   Update tmp_fact_op_clitrx k
           set k.ind_nueapp = 0,
               k.ind_oc1app = 0,
               k.ind_oc2app = 0,
               k.ind_rc1app = 0,
               k.ind_rc2app = 1
         Where  nvl(cnt_trxapp,0) > 0
           and k.cliente_key 
            in (Select tr.cliente_key
                  From DWHOUSE.FACT_OP_TRANSACCION TR
                  Join DWHOUSE.Dm_Tiempo tm on tm.tiempo_key = tr.tiempo_key
                  Join dwhouse.dm_detcanal d on d.key_detcanal = tr.key_detcanal
                  Join dwhouse.dm_canal cn on cn.key_canal = d.key_canal
                 WHERE  tm.periodo = ln_mesant
                   and tr.cnt_transacc = 1
                   and tr.ind_estado <> 99
                   and cn.cod_canorg = 5
                   and tr.cliente_key is not null
                );
        Commit; 
        
   --- ACTUALIZA RECURRENTES1
   Update tmp_fact_op_clitrx k
           set k.ind_nueapp = 0,
               k.ind_oc1app = 0,
               k.ind_oc2app = 0,
               k.ind_rc1app = 1
         Where  nvl(cnt_trxapp,0) > 0
           and nvl(k.ind_rc2app,0) = 0
           and k.cliente_key 
            in (Select tr.cliente_key
                  From DWHOUSE.FACT_OP_TRANSACCION TR
                  Join DWHOUSE.Dm_Tiempo tm on tm.tiempo_key = tr.tiempo_key
                  Join dwhouse.dm_detcanal d on d.key_detcanal = tr.key_detcanal
                  Join dwhouse.dm_canal cn on cn.key_canal = d.key_canal
                 WHERE tm.periodo >= ln_mesrec
                   and tm.periodo < ln_mesant
                   and tr.cnt_transacc = 1
                   and tr.ind_estado <> 99
                   and cn.cod_canorg = 5
                   and tr.cliente_key is not null
                  );
        Commit;      
        
         -- Ocasionales 1: 
         Update tmp_fact_op_clitrx k
           set k.ind_nueapp = 0,
               k.ind_oc1app = 1,
               k.ind_oc2app = 0
         Where  nvl(cnt_trxapp,0) > 0
           and nvl(k.ind_rc2app,0) = 0
           and nvl(k.ind_rc1app,0) = 0
           and exists (Select 1
                 From DWHOUSE.FACT_OP_TRANSACCION TR
                 Join DWHOUSE.Dm_Tiempo tm on tm.tiempo_key = tr.tiempo_key
                 Join dwhouse.dm_detcanal d on d.key_detcanal = tr.key_detcanal
                 Join dwhouse.dm_canal cn on cn.key_canal = d.key_canal
                 WHERE  tr.cliente_key = k.cliente_key
                   and tm.periodo >= ln_mesoca
                   And tm.periodo < ln_mesrec
                   and tr.cnt_transacc = 1
                   and tr.ind_estado <> 99
                   and cn.cod_canorg = 5
                   and tr.cliente_key is not null
                   );
             Commit; 
          
          -- Nuevos: 
         Update tmp_fact_op_clitrx k
           set k.ind_nueapp = 1,
               k.ind_oc2app = 0
         Where nvl(cnt_trxapp,0) > 0
           and nvl(k.ind_rc2app,0) = 0
           and nvl(k.ind_rc1app,0) = 0
           and nvl(k.ind_oc1app,0) = 0
           and not exists 
             (Select 1
                 From DWHOUSE.FACT_OP_TRANSACCION TR
                 Join DWHOUSE.Dm_Tiempo tm on tm.tiempo_key = tr.tiempo_key
                 Join dwhouse.dm_detcanal d on d.key_detcanal = tr.key_detcanal
                 Join dwhouse.dm_canal cn on cn.key_canal = d.key_canal
                 WHERE  tm.periodo >= ln_pernue
                   and tm.periodo < ln_mesoca--ln_pernue and ln_mesant
                   and tr.cnt_transacc = 1
                   and tr.ind_estado <> 99
                   and cn.cod_canorg = 5
                   and tr.cliente_key = k.cliente_key
                   and tr.cliente_key is not null
                   );
             Commit;
             
             --- SALDOS
             For x In c_clien Loop
                 Select count(*),sum(s.saldo_mn)
                  Into ln_ctas, ln_saldo
                   From dwhouse.fact_pasivo s
                   Join dwhouse.dm_producto p on p.producto_key = s.producto_key
                  Where tiempo_key = x.tiempo_key
                   and cliente_key = x.cliente_key
                   and s.estado_key <> 72
                   and p.codigo_producto = '21';
                  
                  Begin
                      Select jaqz205email,jaqz205celul
                        Into lv_mail,lv_ncel
                        From (
                               select jaqz205email,jaqz205celul 
                                  from dwstage.TMP_DM_TARJETA m
                                  Join DWEXTRA.jaqz205 j on j.jaqz205nutar = m.nro_tarj
                                Where m.cod_cliente = x.cod_cliente
                                Order by j.jaqz205feafi desc
                             )
                        Where Rownum = 1;
                                
                  Exception When Others Then
                     lv_mail := null;
                     lv_ncel := null;
                  End;
                  
                  ln_ocac1 := x.ind_oc1app; 
                  ln_ocac2 := 0;
                  If x.ind_oc1app > 0 And  nvl(ln_saldo,0) < ln_sdooc Then
                     ln_ocac1 := 0;
                     ln_ocac2 := 1;
                  End If;
                  IF x.totcli = 0 and ln_ocac2 = 0 Then
                     ln_ocac2 := 1;
                  End If;
                  
                  IF x.ind_nueapp = 1 Then
                     ln_clasc := 1;  --NUEVO
                  ElsIf x.ind_rc1app = 1 Then 
                        ln_clasc := 2; --REC1
                  ElsIf x.ind_rc2app = 1 Then 
                        ln_clasc := 3;  --REC2
                  ElsIf ln_ocac1 = 1 Then 
                        ln_clasc := 4;  --OCA1     
                  ElsIf ln_ocac2 = 1 Then 
                        ln_clasc := 5;  --OCA2
                  End If;                          
      
                  
                  Update tmp_fact_op_clitrx k
                   set k.ind_oc1app = ln_ocac1,
                       k.ind_oc2app = ln_ocac2,
                       k.imp_sldaho = ln_saldo,
                       k.cnt_ctaaho = ln_ctas,
                       key_clacli_trx = ln_clasc,
                       des_mail = lv_mail,
                       des_celular = lv_ncel
                 Where k.cliente_key = x.cliente_key;
                Commit;      
            ENd Loop;
                
End SP_CLASIF_CLITRX_APP;
-----------------------------------------------------------------------------------------------
Procedure SP_CLISINTRX_APP(PD_FECHA In Date)
-- Identificación de clientes que no realizan transacciones en el mes de proceso
Is
    ld_mescie date := last_day(add_months(PD_FECHA,-1)); 
    ln_percie number := to_number(to_char(ld_mescie,'rrrrmm'));
    ld_mesant date := last_day(add_months(PD_FECHA,-2)); 
    ln_perant number := to_number(to_char(ld_mesant,'rrrrmm'));
    ln_tmpkey number(10);
    
Begin
    ln_tmpkey := dwhouse.pq_carga_facts.fn_tiempo_key(ld_mescie);
    IF ln_tmpkey Is Null Then
       select max(fecha) Into ld_mescie From dwhouse.dm_tiempo where periodo = ln_percie;
       ln_tmpkey := dwhouse.pq_carga_facts.fn_tiempo_key(ld_mescie);
    End If;
    
    -- CLIENTES SIN TRANSACCIONES EN EL MES DE PROCESO
    Insert Into tmp_fact_op_clitrx(tiempo_key,cliente_key,cod_cliente,
                                   cnt_trxapp,fec_utxapp,
                                   periodo,ind_tippro,ind_apedig
                                  )
    Select ln_tmpkey,tr.cliente_key,cl.codigo_cliente,
           count(*),
           max(tm.fecha),
           ln_percie,2,'No'
      From dwhouse.FACT_OP_TRANSACCION TR
      Join dwhouse.dm_tiempo TM on TM.TIEMPO_KEY = TR.TIEMPO_KEY
      Join dwhouse.dm_detcanal d on d.key_detcanal = tr.key_detcanal
      Join dwhouse.dm_canal cn on cn.key_canal = d.key_canal
      Join dwhouse.dm_cliente cl on cl.cliente_key = tr.cliente_key
     Where tm.periodo = ln_perant
       and tr.cnt_transacc = 1
       and tr.ind_estado <> 99
       and cn.cod_canorg = 5 --5:MOVI
       AND NOT EXISTS (Select 1 from dwhouse.FACT_OP_TRANSACCION KM
                         Join dwhouse.dm_tiempo P on p.TIEMPO_KEY = KM.TIEMPO_KEY
                         Join dwhouse.dm_detcanal dc on dc.key_detcanal = km.key_detcanal
                         Join dwhouse.dm_canal ct on ct.key_canal = dc.key_canal
                       Where km.cliente_key = tr.cliente_key
                         and p.periodo = ln_percie   
                         and ct.cod_canorg = 5
                         and KM.cnt_transacc = 1
                         and KM.ind_estado <> 99
                       )
    group by  ln_tmpkey,tr.cliente_key,cl.codigo_cliente,tm.periodo;
    commit;
End SP_CLISINTRX_APP;    
-----------------------------------------------------------------------------------------------
Procedure SP_DATOS_CLISINTRX_APP(PD_FECHA In Date)   
Is
   Cursor c_clien
       IS SElect r.cod_cliente,r.tiempo_key,r.cliente_key,nvl(r.cnt_trxapp,0) cnt_trxapp,
                 cl.pais,to_number(cl.tipo_documento) tdoc,cl.numero_documento ndoc
            from tmp_fact_op_clitrx r
            Join dwhouse.dm_cliente cl on cl.cliente_key = r.cliente_key
           Where ind_tippro = 2;
   
   ld_perio date := last_day(add_months(PD_FECHA,-1));
   ln_saldo number(12,2);
   ln_ctas number(5);
   ln_period number(6) := to_number(to_char(ld_perio,'rrrrmm'));
   ln_mesant number(6) := to_number(to_char(add_months(to_date(to_char(ln_period,'999999')||'01','rrrrmmdd'),-1),'rrrrmm'));
   
   lv_mail varchar2(200);
   lv_ncel varchar2(20);
   ln_ape  number(5);
   lv_apedig Varchar2(2);
Begin
 
             --- SALDOS
             For x In c_clien Loop
                 Select count(*),sum(s.saldo_mn)
                  Into ln_ctas, ln_saldo
                   From dwhouse.fact_pasivo s
                   Join dwhouse.dm_producto p on p.producto_key = s.producto_key
                  Where tiempo_key = x.tiempo_key
                   and cliente_key = x.cliente_key
                   and s.estado_key <> 72
                   and p.codigo_producto = '21';
                  
                  Begin
                      Select jaqz205email,jaqz205celul
                        Into lv_mail,lv_ncel
                        From (
                               select jaqz205email,jaqz205celul 
                                  from dwstage.TMP_DM_TARJETA m
                                  Join DWEXTRA.jaqz205 j on j.jaqz205nutar = m.nro_tarj
                                Where m.cod_cliente = x.cod_cliente
                                Order by j.jaqz205feafi desc
                             )
                        Where Rownum = 1;
                                
                  Exception When Others Then
                    -- Busca Correo
                    Begin
                     select e_mail Into lv_mail
                       From (
                             select trim(replace(pextxt,'\','')) e_mail 
                               from fsx001@produ 
                              where pepais = x.pais
                                and petdoc = x.tdoc
                                and pendoc = x.ndoc 
                                and trim(pexusu) = 'USRBIM'
                                and pexfch <= ld_perio 
                                order by pexfch desc
                            )
                      Where rownum = 1;          
                    Exception When Others Then
                              Begin
                                    select e_mail Into lv_mail
                                     From (
                                           select trim(replace(pextxt,'\','')) e_mail 
                                             from fsx001@produ 
                                            where pepais = x.pais
                                              and petdoc = x.tdoc
                                              and pendoc = x.ndoc 
                                              order by pexfch desc
                                          )
                                    Where rownum = 1;  
                              Exception When Others Then      
                              Begin
                               select dir_email
                                 Into lv_mail
                                 from dwhouse.dm_cliente 
                                where cliente_key = x.cliente_key;
                               Exception When Others Then 
                                   lv_mail := null;
                               End;
                               End;
                    End;
                    -- Busca Celular
                    Begin
                        Select numtel Into lv_ncel
                          From (
                                 select trim(dotelfp) numtel
                                   from fsr005@produ 
                                  where pepais = x.pais
                                    and petdoc = x.tdoc
                                    and pendoc = x.ndoc
                                    and trim(dofaxp) = 'CAJAMOVIL' 
                                    and docod=1
                               Order by doordp desc
                               )
                         Where Rownum = 1;        
                    Exception When Others Then
                               Begin
                                     select num_telefs
                                       Into lv_ncel
                                       from dwhouse.dm_cliente 
                                      where cliente_key = x.cliente_key;
                               Exception When Others Then 
                                  lv_ncel := null;
                               End;
                    End;
                  End;
                  
                  -- TRX sòlo es apertura digital
                  lv_apedig := 'No';
                  If x.cnt_trxapp = 1 Then
                    select count(*) Into ln_ape
                      from dwhouse.fact_op_transaccion tr 
                      join dwhouse.dm_tiempo t on t.tiempo_key = tr.tiempo_key
                      join dwhouse.dm_transaccion m on m.transacc_key = tr.transacc_key
                     where tr.cliente_key = x.cliente_key
                       and t.periodo = ln_mesant
                       and m.des_clase like 'APERTURA%';
                
                    If ln_ape = 1 Then
                       lv_apedig := 'Si';
                    End If;     
                  End If;
  
            
             
                 Update tmp_fact_op_clitrx k
                   set des_mail = lv_mail,
                       des_celular = lv_ncel,
                       ind_apedig = lv_apedig,
                       k.cnt_ctaaho = ln_ctas, 
                       k.imp_sldaho = ln_saldo
                 Where k.cliente_key = x.cliente_key
                   and ind_tippro = 2;
                Commit;      
            ENd Loop;
                
End SP_DATOS_CLISINTRX_APP;
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
Procedure SP_CLASIF_CLITRX_COMPRAS(PD_FECHA In Date)
-- Clasificación de clientes que realizan compras desde POS y/o INTERNET
Is
   Cursor c_clien
       IS SElect r.cod_cliente,r.tiempo_key,r.cliente_key,
                 r.ind_compos,r.ind_comint,cl.pais,
                 to_number(cl.tipo_documento)tdoc, cl.numero_documento ndoc
            from tmp_fact_op_clitrx r
            Join tmp_dm_cliente cl on cl.codigo_cliente = r.cod_cliente
           Where (nvl(r.cnt_compos,0) + nvl(r.cnt_comint,0)) > 0 
             and ind_tippro = 1;
   
   ln_saldo number(12,2);
   ln_ctas number(5);
   ln_nuevo number(1);
   ln_ocac1 number(1);
   ln_ocac2 number(1);
   ln_recu1 number(1);
   ln_recu2 number(1);

   ln_mesr2 number(3) := 1;
   ln_mesr1 number(3) := 3;
   ln_meso1 number(3) := 6;
   ln_sdooc number(12,2) := 50;
   ln_pernue number(6) := 201501;
   
   ld_mesant date := last_day(add_months(PD_FECHA,-1)); 
   ln_period number(6) := to_number(to_char(ld_mesant,'rrrrmm'));
   ln_mesant number(6) := to_number(to_char(add_months(to_date(to_char(ln_period,'999999')||'01','rrrrmmdd'),-1),'rrrrmm'));
   ln_mesrec number(6) := to_number(to_char(add_months(to_date(to_char(ln_period,'999999')||'01','rrrrmmdd'),-3),'rrrrmm'));
   ln_mesnue number(6) := to_number(to_char(add_months(to_date(to_char(ln_period,'999999')||'01','rrrrmmdd'),-9),'rrrrmm'));
   
   lv_mail varchar2(200);
   lv_ncel varchar2(20);
   ln_clasc Number(5);
   
BEGIN
   --- RECURRENTES:COMPRARON EN LOS ULTIMOS 3 MESES
   --- ACTUALIZA RECURRENTES POS
   Update tmp_fact_op_clitrx k
           set k.ind_compos = 3
         Where  nvl(cnt_compos,0) > 0
           and k.cliente_key 
            in (Select tr.cliente_key
                  From DWHOUSE.FACT_OP_TRANSACCION TR
                  Join DWHOUSE.Dm_Tiempo tm on tm.tiempo_key = tr.tiempo_key
                  Join dwhouse.dm_detcanal d on d.key_detcanal = tr.key_detcanal
                  Join dwhouse.dm_canal cn on cn.key_canal = d.key_canal
                 WHERE tm.periodo between ln_mesrec and ln_mesant
                   and tr.cnt_transacc = 1
                   and tr.ind_estado <> 99
                   and cn.cod_canorg = 7 -- POS
                   and tr.cliente_key is not null
                );
        Commit; 
   
   --- ACTUALIZA RECURRENTES INTERNET
   Update tmp_fact_op_clitrx k
           set k.ind_comint = 3
         Where  nvl(cnt_comint,0) > 0
           and k.cliente_key 
            in (Select tr.cliente_key
                  From DWHOUSE.FACT_OP_TRANSACCION TR
                  Join DWHOUSE.Dm_Tiempo tm on tm.tiempo_key = tr.tiempo_key
                  Join dwhouse.dm_detcanal d on d.key_detcanal = tr.key_detcanal
                  Join dwhouse.dm_canal cn on cn.key_canal = d.key_canal
                 WHERE tm.periodo between ln_mesrec and ln_mesant
                   and tr.cnt_transacc = 1
                   and tr.ind_estado <> 99
                   and cn.cod_canorg = 8 -- INTERNET
                   and tr.cliente_key is not null
                );
        Commit; 
   
   --- NUEVOS: NO COMPRARON EN LOS ULTIMOS 9 MESES   
   --- Nuevos POS
         Update tmp_fact_op_clitrx k
           set k.ind_compos = 1
         Where nvl(cnt_compos,0) > 0
           and nvl(k.ind_compos,0) = 0
           and not exists 
             (Select 1
                 From DWHOUSE.FACT_OP_TRANSACCION TR
                 Join DWHOUSE.Dm_Tiempo tm on tm.tiempo_key = tr.tiempo_key
                 Join dwhouse.dm_detcanal d on d.key_detcanal = tr.key_detcanal
                 Join dwhouse.dm_canal cn on cn.key_canal = d.key_canal
                 WHERE  tm.periodo between ln_mesnue and ln_mesant
                   and tr.cnt_transacc = 1
                   and tr.ind_estado <> 99
                   and cn.cod_canorg = 7 -- POS
                   and tr.cliente_key = k.cliente_key
                   and tr.cliente_key is not null
                   );
             Commit;
                    
         --- Nuevos INTERNET
         Update tmp_fact_op_clitrx k
           set k.ind_comint = 1
         Where nvl(cnt_comint,0) > 0
           and nvl(k.ind_comint,0) = 0
           and not exists 
             (Select 1
                 From DWHOUSE.FACT_OP_TRANSACCION TR
                 Join DWHOUSE.Dm_Tiempo tm on tm.tiempo_key = tr.tiempo_key
                 Join dwhouse.dm_detcanal d on d.key_detcanal = tr.key_detcanal
                 Join dwhouse.dm_canal cn on cn.key_canal = d.key_canal
                 WHERE  tm.periodo between ln_mesnue and ln_mesant
                   and tr.cnt_transacc = 1
                   and tr.ind_estado <> 99
                   and cn.cod_canorg = 8 -- Internet
                   and tr.cliente_key = k.cliente_key
                   and tr.cliente_key is not null
                   );
             Commit; 
             
   --- OCACIONALES: COMPRARON EN ALGULO DE LOS 9 MESES   
   --- Ocacionales POS           
        Update tmp_fact_op_clitrx k
           set k.ind_compos = 4
         Where nvl(cnt_compos,0) > 0
           and nvl(k.ind_compos,0) = 0;
         Commit;          
   --- Ocacionales Internet          
        Update tmp_fact_op_clitrx k
           set k.ind_comint = 4
         Where nvl(cnt_comint,0) > 0
           and nvl(k.ind_comint,0) = 0;
         Commit;            
    
    --- Correos y Telefonos
    For x In c_clien Loop
        ------
        Begin
            Select jaqz205email,jaqz205celul
              Into lv_mail,lv_ncel
              From (
                     select jaqz205email,jaqz205celul 
                        from dwstage.TMP_DM_TARJETA m
                        Join DWEXTRA.jaqz205 j on j.jaqz205nutar = m.nro_tarj
                      Where m.cod_cliente = x.cod_cliente
                      Order by j.jaqz205feafi desc
                   )
              Where Rownum = 1;
                                
        Exception When Others Then
                  -- Busca Correo
                  Begin
                     select e_mail Into lv_mail
                       From (
                             select trim(replace(pextxt,'\','')) e_mail 
                               from fsx001@produ 
                              where pepais = x.pais
                                and petdoc = x.tdoc
                                and pendoc = x.ndoc 
                                and trim(pexusu) = 'USRBIM'
                                and pexfch <= ld_mesant 
                                order by pexfch desc
                            )
                      Where rownum = 1;          
                  Exception When Others Then
                            Begin
                                 select e_mail Into lv_mail
                                   From (
                                           select trim(replace(pextxt,'\','')) e_mail 
                                             from fsx001@produ 
                                            where pepais = x.pais
                                              and petdoc = x.tdoc
                                              and pendoc = x.ndoc 
                                              order by pexfch desc
                                          )
                                    Where rownum = 1;  
                            Exception When Others Then      
                                  Begin
                                       select dir_email
                                         Into lv_mail
                                         from dwhouse.dm_cliente 
                                        where cliente_key = x.cliente_key;
                                   Exception When Others Then 
                                        lv_mail := null;
                                   End;
                            End;
                  End;
                  
                  -- Busca Celular
                  Begin
                        Select numtel Into lv_ncel
                          From (
                                 select trim(dotelfp) numtel
                                   from fsr005@produ 
                                  where pepais = x.pais
                                    and petdoc = x.tdoc
                                    and pendoc = x.ndoc
                                    and trim(dofaxp) = 'CAJAMOVIL' 
                                    and docod=1
                               Order by doordp desc
                               )
                         Where Rownum = 1;        
                  Exception When Others Then
                               Begin
                                     select num_telefs
                                       Into lv_ncel
                                       from dwhouse.dm_cliente 
                                      where cliente_key = x.cliente_key;
                               Exception When Others Then 
                                  lv_ncel := null;
                               End;
                  End;
        End;
                         
        Update tmp_fact_op_clitrx k
           set des_mail = lv_mail,
               des_celular = lv_ncel
         Where k.cliente_key = x.cliente_key;
        Commit;      
    End Loop;
                
End SP_CLASIF_CLITRX_COMPRAS;
-----------------------------------------------------------------------------------------------
  FUNCTION fn_perfil_usuario(PV_CODUSU varchar2) Return Varchar2
  -- Autor: Paola Vargas
  -- Fecha: 2022-10-06
  -- Uso: btener el perfil de usuario
  IS  
    lv_perfil dwstage.tmp_dm_perfil_usu.cod_perfil%type;
  BEGIN    
        Select trim(prfgcod) Into lv_perfil
          From (
                select Case when prfgcod = 'JPLA01' Then 1
                            when prfgcod = 'CAASIPLA' Then 2
                            when prfgcod = 'CAREPSER' Then 3
                            when prfgcod = 'CAASEPLA' Then 4
                            else 9
                       End orden,
                       g.prfgcod                   
                  from prfu00@produ g ---EXTRAER 
                 Where ubuser = PV_CODUSU
                 Order by orden, prfufecalt  desc
         ) Where rownum = 1;
         
         Return lv_perfil;
  
  EXCEPTION When Others Then
       Return '0';
  END fn_perfil_usuario;
-----------------------------------------------------------------------------------------------
  FUNCTION fn_key_perfil_usu(PV_CODPER varchar2) Return Number
  -- Autor: Paola Vargas
  -- Fecha: 2022-10-06
  -- Uso: obtener key de perfil de usuario
  IS  
    ln_perfil dwstage.tmp_dm_perfil_usu.key_perfil%type;
  BEGIN    
       Select y.key_perfil
         Into ln_perfil
         From tmp_dm_perfil_usu y
        Where trim(y.cod_perfil) = trim(PV_CODPER); 
       
       Return ln_perfil;
  
  EXCEPTION When Others Then
       Return 717;  -- No registrado
       
  END fn_key_perfil_usu;
  -----------------------------------------------------------------------------------------------
  PROCEDURE SP_OP_DATOS_DESEMBOLSO(PD_FECHA In Date)
  IS  
   ld_fecha date := PD_FECHA;
   Cursor c_desem(ld_fec in date) is
          Select FECHA, PGCOD, HCMOD, HSUCOR, HTRAN, HNREL, KEY_INGEGR
            from dwstage.tmp_fact_op_transaccion r
            Join dwhouse.dm_transaccion x on x.modulo = r.hcmod and x.transaccion = r.htran
           Where upper(x.tipo_transacc) like 'DESEMB%'
             --and hcmod=489 and htran=59 and hnrel = 1 
             and fecha = ld_fec;    
  
  ln_imp number(12,2);  
  ln_tipcam number(7,3);  
  ln_mda number(3);
  naocta number(9); naomod number(4); 
  naoope number(9); naosbo number(4); naotop number(4);
  ln_prp number(10);
 -- ln_kuenta number(10);
  ln_impcr number(12,2);ln_mocr number(3);ln_topcr number(3);
  ln_proc number(10);
  ln_ctacr number(9);
  ln_opecr number(9);
  ln_agebn number(10);
  ln_codbn varchar2(10);
  ln_pagcre number(10);
  ln_efectivo number(10);
  
  ln_sucu   number(5);    ln_mdac number(4); ln_sbope number(4);
  ln_prcre  number(5);    ln_spcre number(5);
  lv_codcta varchar2(50); lv_ctauni varchar2(50);
  ln_gdpf   number(5);    ln_indg number(5); ln_gcts number(5);
  lv_codpr  varchar2(5);
  lv_codsp  varchar2(5);
  
Begin
     For x In c_desem(ld_fecha) Loop
        Begin
          --- Importe de Depósito a cuenta
              select d.hcimp1,d.hmda,d.hmodul,d.hcta,d.hoper,d.hsubop, d.htoper
                Into ln_imp,ln_mda,naomod,naocta,naoope,naosbo,naotop   
                 from dwextra.fsh015_16 d 
                 Join dwextra.fsd014 r on r.rubro = d.hrubro  
                 where d.hfcon = x.fecha
                   and d.hcmod = x.hcmod
                   and d.htran = x.htran
                   and d.hnrel = x.hnrel
                   and d.hsucor = x.hsucor
                   and d.hcmcod in (2,41)
                   and d.hmodul = 21
                   and d.hcodmo = 2;
          Exception When Others Then
            ln_imp := 0;
            ln_mda := 0;
            naomod:= null; naocta:= null; naoope:= null; naosbo:= null; naotop:= null; 
          End;
            
          --- Producto de ahorros: declarar
          lv_codpr := to_char(naomod);
          lv_codsp := to_char(naotop);
          If to_char(naotop) = '0' Then
             lv_codsp := '1';
          End If;    
            
            
          --- Nro de cuenta
          Begin
              Select ct.codigo_cuenta,ct.cuenta_unica
                Into lv_codcta, lv_ctauni
                From dwstage.tmp_dm_cuenta ct
               where ct.aomod = naomod
                 and ct.aocta = naocta
                 and ct.aomda = ln_mda 
                 and ct.aoope = naoope
                 and ct.aosbo = naosbo
                 and ct.aotop = naotop;
          Exception When Others Then
              lv_codcta:='0'; lv_ctauni:='0';
          End;
                  
          --- Datos del credito
          Begin
              select d.hcimp1,d.hmodul,d.htoper,d.hcta,d.hoper, d.hsucur, d.hmda, d.hsubop
                Into ln_impcr,ln_mocr,ln_topcr,ln_ctacr,ln_opecr, ln_sucu, ln_mdac, ln_sbope 
                from dwextra.fsh015_16 d 
                 Join dwextra.fsd014 r on r.rubro = d.hrubro  
                 where d.hfcon = x.fecha
                   and d.hcmod = x.hcmod
                   and d.htran = x.htran
                   and d.hnrel = x.hnrel
                   and d.hsucor = x.hsucor
                   and substr(d.hrubro,1,4) in ('1421','1411','1414','1424','1415','1425','1416','1426') 
                   and d.hcodmo = 1;
          Exception When Others Then
            ln_impcr := 0;
            ln_mocr  := null; ln_sucu := null; 
            ln_topcr := null; ln_mdac := null; 
            ln_ctacr := null; ln_sbope := null;
            ln_opecr := null;
          End;
            
          Begin
              select sum(d.hcimp1)
                Into ln_pagcre
                 from dwextra.fsh015_16 d 
                 Join dwextra.fsd014 r on r.rubro = d.hrubro  
                 where d.hfcon = x.fecha
                   and d.hcmod = x.hcmod
                   and d.htran = x.htran
                   and d.hnrel = x.hnrel
                   and d.hsucor = x.hsucor
                   and substr(d.hrubro,1,4) in ('1421','1411','1414','1424','1415','1425','1416','1426') 
                   and d.hcodmo = 2;
          Exception When Others Then
            ln_pagcre := 0; 
          End;
            
           Begin
              select sum(d.hcimp1)
                Into ln_efectivo
                 from dwextra.fsh015_16 d 
                 Join dwextra.fsd014 r on r.rubro = d.hrubro  
                 where d.hfcon = x.fecha
                   and d.hcmod = x.hcmod
                   and d.htran = x.htran
                   and d.hnrel = x.hnrel
                   and d.hsucor = x.hsucor
                   and d.hmodul = 50 
                   and d.hcodmo = 2;
          Exception When Others Then
            ln_efectivo := 0;
          End;
            
            
          --- Producto reglamento creditos
          Begin
              select t.producto_reg_cod,t.producto_reg_cds
                Into ln_prcre, ln_spcre
                from dwstage.tmp_dm_producto_Reg t
               Where t.producto_reg_mod = ln_mocr
                 and t.producto_reg_top = ln_topcr;
          Exception When Others Then
              ln_prcre:=-1; ln_spcre:=-1;
          End;   
                 
          --- Revisar si es Banco de la Nacion
          Begin
             Select dwstage.pq_tmp_carga_facts.fn_agencia_bn(l.numins,l.aocta,l.aoope) agenciabn
               Into ln_codbn
               From dwstage.tmp_dm_credito l
              Where l.aocta = ln_ctacr
                and l.aoope = ln_opecr;
                  
              SElect bn.agenciabn_key Into ln_agebn
                from dwhouse.dm_agencia_bn bn
                where bn.codigo_agenciabn = ln_codbn;  
          Exception When Others Then
             ln_codbn := null;
             ln_agebn := 1;
          End;  

          --- REVISAR TIPO DE GARANTIA
          ln_indg := 0;
          Begin
               select sum(case when R2TOPE = 80 Then 1 else 0 end), 
                      sum(case when R2TOPE = 85 Then 1 else 0 end) 
                 Into ln_gdpf,ln_gcts
                 From dwextra.fsr011 
                where relcod = 50
                  and R1COD  = x.pgcod
                  and R1MOD  = ln_mocr
                  and R1SUC  = ln_sucu
                  and R1MDA  = ln_mdac
                  and R1PAP  = 0
                  and R1CTA  = ln_ctacr
                  and R1OPER = ln_opecr
                  and R1SBOP = ln_sbope
                  and R1TOPE = ln_topcr
                  and r2mod = 70
                  and R2TOPE in (80,85) ---DPF / CTS
                  and r011CO = 'S';
          Exception When Others Then
             ln_gdpf := 0; ln_gcts := 0; 
          End;    
                      
          If ln_gdpf > 0 then ln_indg := 1; End If; 
          If ln_gcts > 0 then ln_indg := ln_indg + 2; End If;
          ------
            
             
          Update Tmp_Fact_Op_Transaccion s
             set s.importe2      = ln_imp,   --deposito en cuenta
                 s.importe3      = ln_impcr, --importe bruto de desembolso
                 s.codpro_act    = ln_prcre, -- produto activo
                 s.subpro_act    = ln_spcre, 
                 s.codigo_cuenta = lv_codcta, 
                 s.cuenta_unica  = lv_ctauni,
                 s.codpro_pas    = lv_codpr,
                 s.subpro_pas    = lv_codsp, 
                 s.num_credito   = ln_ctacr||'-'||ln_opecr,
                 s.agenciabn_key = ln_agebn,
                 s.importe4      = ln_pagcre,--pago de credito
                 s.importe5      = ln_efectivo,--entrega en efectivo
                 s.ind_tipgar    = ln_indg 
           Where s.Fecha = x.fecha
             and s.PGCOD = x.PGCOD 
             and s.HCMOD = x.HCMOD 
             and s.HSUCOR= x.HSUCOR
             and s.HTRAN = x.HTRAN
             and s.HNREL = x.HNREL
             and s.KEY_INGEGR = x.KEY_INGEGR;
             Commit;      
     End Loop;
  End SP_OP_DATOS_DESEMBOLSO;
  -----------------------------------------------------------------------------------------------
  PROCEDURE SP_CAM_DEVOLUCION(PD_FECINI In Date)
  Is
     Cursor c_ctas(dFec in Date)
         is Select * from tmp_fact_servem_ahoaper Where fecha = dFec;
         
     NumTit Number(5);
     CtaCum Varchar2(1);
     nCueVig Number(5);
     dfecact date;
     dFecCan date;
     nComp number(5);
     vTipcli varchar2(2);
     TarjNum varchar2(20);
     nNumReg number(10);
     nNumTit  number(10);
     PD_FECHA Date := PD_FECINI;
     vMsgerr Varchar2(200);
Begin
  
        delete from tmp_fact_servem_ahoaper o where o.fecha = PD_FECHA;
        Commit;
        delete from TMP_FACT_SEM_COMPRAUNO where fecha = PD_FECHA;
        Commit;

        select nvl(max(numreg),0) Into nNumReg from tmp_fact_servem_ahoaper;
        Begin
            Insert Into tmp_fact_servem_ahoaper
                  (numreg, tiempo_key, fecha, fecha_apertura, cod_cuenta, cuentas_key, cliente_key,
                    pais, tdoc, ndoc, producto_key, nombre_producto, nombre_subproducto, email_app,
                    numcel_app, nombre_cliente, cuenta, cuenta_unica, codigo_cuenta, nombre_agencia,
                    nombre_region, nombre_zona, geografia_key)

            Select rownum+ nNumReg, p.tiempo_key,t.fecha,k.fecha_apertura,k.cod_cuenta,k.cuentas_key,p.cliente_key,
                   c.pais,c.tipo_docum tdoc, c.numero_documento ndoc, pr.producto_key,pr.nombre_producto,
                   pr.nombre_subproducto, c.email_app,c.numcel_app, c.nombre_cliente, k.cuenta,
                   k.cuenta_unica,k.codigo_cuenta, ge.nombre_agencia,ge.nombre_region,ge.nombre_zona,p.geografia_key
             From dwhouse.fact_pasivo p
             Join dwhouse.dm_tiempo t
               on t.tiempo_key = p.tiempo_key
             Join dwhouse.dm_cuentas k on k.cuentas_key  = p.cuentas_key
             Join dwhouse.dm_producto pr on pr.producto_key = p.producto_key
             Join dwhouse.dm_cliente c on c.cliente_key = p.cliente_key
             Join dwhouse.dm_geografia ge on ge.geografia_key = p.geografia_key
            Where t.fecha = PD_FECHA
              and pr.codigo_producto = '21'
              and pr.codigo_subproducto <> '8'
              and k.fecha_apertura = t.fecha
              and c.naturaleza = 'F';
          Commit;
       Exception When Others Then
           Null;
       End;

      For x in c_ctas(PD_FECHA) Loop
          CtaCum := 'N';

          --- Cuenta individual
          Select count(pendoc) Into nNumTit
            From dwextra.fsr008
           Where ctnro = x.cuenta;


          -- Fecha de activacion y nro de tarjeta
           Begin

               Select z.z0e478fau ,trim(b.z0e478nro)
                 Into dfecact,TarjNum
                 From dwextra.z0e479 b --z0e479@produ b
                 Join tmp_dm_cuenta ct
                  on ct.aomod = B.z0e479mod
                 and ct.aomda = B.z0e479mon
                 and ct.aocta = B.z0e479cta
                 and ct.aoope = B.z0e479ope
                 and ct.aosbo = B.z0e479sct
                 and ct.aotop = B.z0e479top
                 Join dwextra.Z0e478 z
                   on trim(z.z0e478nro) = trim(b.z0e478nro)
                  and z.z0e463cod = 1
               Where ct.codigo_cuenta = x.codigo_cuenta
                and ct.cuenta_unica = x.cuenta_unica;
           Exception When Others Then
              dfecact := null;
              TarjNum := null;
              vMsgerr := substr(sqlerrm,1,200);
           End;

          If nNumTit = 1 then
             -- Revisar antiguedad de cliente
             Select nvl(count(*),0) Into nCueVig
               From tmp_dm_cuenta c
               Join dwextra.fsr008 i on i.ctnro = c.aocta
              Where i.pepais = x.pais
                and i.petdoc = x.tdoc
                and i.pendoc = x.ndoc
                and c.aomod = 21
                and c.aotop <> 2
                and c.fecha_cancelacion is null
                and not(c.codigo_cuenta = x.codigo_cuenta and c.cuenta_unica = x.cuenta_unica);

              If nCueVig = 0 Then
                 Begin
                  Select max(c.fecha_cancelacion) Into dFecCan
                     From tmp_dm_cuenta c
                     Join dwextra.fsr008 i on i.ctnro = c.aocta
                    Where i.pepais = x.pais
                      and i.petdoc = x.tdoc
                      and i.pendoc = x.ndoc
                      and c.aomod = 21
                      and c.aotop <> 2
                      and c.fecha_cancelacion is not null
                      and not(c.codigo_cuenta = x.codigo_cuenta and c.cuenta_unica = x.cuenta_unica);
                 Exception When Others Then
                     dFecCan := null;
                 End;

                 If months_between(x.fecha_apertura,dFecCan) >= 12  or dFecCan Is null Then


                       -- Buscar compras
                       Begin
                           Insert Into TMP_FACT_SEM_COMPRAUNO
                                  (tiempo_key,cliente_key,transacc_key,nombre_transacc,des_subcla,
                                   des_subcla2,des_compos,v_hora,fecha,moneda,
                                   importe_mn,importe_mo)
                          Select o.tiempo_key,o.cliente_key,o.transacc_key,m.nombre_transacc,m.des_subcla,
                                 m.des_subcla2,p.des_compos,o.v_hora,t.fecha,
                                 decode(o.moneda_key,1,'Soles','Dólares') moneda,
                                 o.importe_mn,o.importe_mo
                            From dwhouse.fact_op_transaccion o
                            Join dwhouse.dm_tiempo t on t.tiempo_key = o.tiempo_key
                            Join dwhouse.dm_transaccion m on m.transacc_key = o.transacc_key
                            Left Join dwhouse.dm_comercio_pos p on p.key_compos = o.key_compos
                           Where t.fecha between x.fecha_apertura and (x.fecha_apertura + 7)
                             and upper(des_clase) like 'COMPRA%'
                             and o.importe_mn >= 100
                             and o.cnt_transacc = 1
                             and o.ind_estado <> 99
                             and o.cliente_key = x.cliente_key
                             and o.cuentas_key = x.cuentas_key;
                             Commit;
                       Exception When Others Then
                           Null;
                       End;

                       Select count(*) Into nComp from TMP_FACT_SEM_COMPRAUNO
                        Where cliente_key = x.cliente_key;

                       If nComp > 0 then
                          CtaCum := 'S';
                       End If;

                 End If;
              End If;
          End If;

          If dFecCan is Null Then
             vTipcli := 'N';
          Else
             vTipcli := 'I';
          End If;

          Update tmp_fact_servem_ahoaper
             set indcamp = CtaCum,
                 numtarj  = trim(TarjNum),
                 fecact  = dfecact,
                 dFecCan = dFecCan,
                 tipcli = vTipcli,
                 numtit = nNumTit,
                 cuevig = ncuevig
           Where numreg = x.numreg
             and fecha = PD_FECHA;
          Commit;
       End Loop;

  End SP_CAM_DEVOLUCION;
  -----------------------------------------------------------------------------------------------
  PROCEDURE SP_P51_ERRORES(PD_FECHA In Date)
  IS
   Cursor c_err(dFec in Date)
       is SELECT j.JAQZ208fetra,j.JAQZ208hotra,JAQZ208seint,JAQZ208cores,JAQZ208cotra,JAQZ208secrs,
                 j.JAQZ208canal,trim(j.JAQZ208detalle) detalle,
                 j.JAQZ208nutar,trim(x.msgerr) msgerr
          FROM JAQZ208@produ j,
               XMLTABLE('/TRAMAIB' PASSING XMLTYPE(j.jaqz208texto) COLUMNS msgerr VARCHAR2(200) PATH 'MSGERR') x
          Where j.JAQZ208FETRA = dFec 
            and j.JAQZ208CANAL = 10 
            and JAQZ208CORES <> '00';  
  
  BEGIN
     Execute Immediate 'Truncate table dwstage.TMP_FACT_P51_ERRORES';

     For x in c_err(PD_FECHA) Loop
         Begin
         Insert Into dwstage.TMP_FACT_P51_ERRORES
               (fecha, hora, fechor, secuencia, codres, codtra, 
                secres, canal, descan, msgerr, numtar
                )    
         Values(x.JAQZ208fetra,x.JAQZ208hotra,
                to_date(to_char(x.JAQZ208fetra,'rrrrmmdd')||' '||x.JAQZ208hotra,'rrrrmmdd hh24:mi.ss'),
                x.JAQZ208seint,trim(x.JAQZ208cores),trim(x.JAQZ208cotra),trim(x.JAQZ208secrs),
                x.JAQZ208canal,'P51',
                case when x.detalle is null then x.msgerr else x.msgerr||'-'||x.detalle end,trim(x.JAQZ208nutar)
               );
         Exception when Others Then
             null;
         End;     
         Commit;    
         
         
     End Loop;
       
  END SP_P51_ERRORES;    
  -----------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------  
END PQ_TMP_CARGA_TRANSACC;
/
