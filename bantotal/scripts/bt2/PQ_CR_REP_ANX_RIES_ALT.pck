create or replace package PQ_CR_REP_ANX_RIES is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_REP_ANX_RIES
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 22/09/2023 14:57:31
  -- Autor de Creación          : LLATANPVARGAS Paola Vargas
  -- Uso                        : Anexos riesgos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 22/09/2023 14:57:31
  -- Autor de la modificacíon   : LLATANPVARGAS Paola Vargas
  -- Fecha de Modificación      : 20/09/2024
  -- Autor de la modificacíon   : LLATANPVARGAS Paola Vargas  
  -- Modificación               : Mejoras a reportes normativos
  -- Fecha de Modificación      : 04/10/2024
  -- Autor de la modificacíon   : LLATANPVARGAS Paola Vargas  
  -- Modificación               : Correcciones a reportes normativos  
  -- Fecha de Modificación      : 27/03/2025
  -- Autor de la modificacíon   : LLATANPVARGAS Paola Vargas  
  -- Modificación               : Correcciones a reportes normativos    
  -- *****************************************************************
  
  -----------------------------------------------------
  ---------- GENERAL ----------------------------------
  ------------------------------------------------------
  FUNCTION FN_TIPO_CAMBIO_FIJO(P_FECHA in date) 
  Return number; 
  ------------------------------------------------------
  ------------------ INICIO ANEXO 2A1 ------------------
  ------------------------------------------------------
  procedure sp_generar_anexo2a1(p_fecproces in out date,
                                p_anexo     in varchar2,
                                p_usuario   in varchar2,
                                p_respuesta out varchar2);
                                            
  ------------------------------------------------------
  procedure sp_cargar_data_reporte_anexo2a1(p_fecproces in out date,
                                            p_anexo     in varchar2,
                                            p_usuario   in varchar2,
                                            p_respuesta out varchar2);
                                            
  ------------------------------------------------------
  procedure sp_copiar_param_period_anexo2a1(p_periodo   in number,
                                            p_anexo     in varchar2,
                                            p_usuario   in varchar2,
                                            p_respuesta out varchar2,
                                            p_resptexto out varchar2);
                                            
  ------------------------------------------------------
  procedure sp_validar_estado_periodo(p_periodo in number,
                                      p_anexo   in varchar2,
                                      p_estado  out varchar2);

  ------------------------------------------------------
  ------------------- INICIO ANEXO 8 -------------------
  ------------------------------------------------------
  Function FN_CALIF_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date) Return VARCHAR2;

  ------------------------------------------------------
  Function FN_NOMBRE_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date) Return VARCHAR2;

  ------------------------------------------------------
  Function FN_RESIDENTE_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date) Return VARCHAR2;

  ------------------------------------------------------
  Function FN_PAIS_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date) Return VARCHAR2;

  ------------------------------------------------------
  Function FN_DOCUMENTO_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date) Return VARCHAR2;

  ------------------------------------------------------
  Function FN_FINANCIERO_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date) Return VARCHAR2;

  ------------------------------------------------------
  Function FN_COD_SBS_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date) Return VARCHAR2;

  ------------------------------------------------------
  Function FN_CUENTA_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date) Return VARCHAR2;

  ------------------------------------------------------
  Function FN_CONVENIO_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date) Return VARCHAR2;

  ------------------------------------------------------
  procedure SP_A8_TRAER_FWD_TODO(pdfecha      in date,
                                 pdfechaPro   in date,
                                 p_vUsuario   in varchar2,
                                 p_vRespuesta out varchar2);

  ------------------------------------------------------
  procedure SP_A8_TRAER_FORWARD(p_dFecha     in date,
                                p_dFechaPro  in date,
                                p_vUsuario   in varchar2,
                                p_vRespuesta out varchar2);

  ------------------------------------------------------
  procedure SP_A8_LLENAR_COM_VEN(p_dFecha     in date,
                                 p_dFechaPro  in date,
                                 p_nTipCam    in number,
                                 p_vUsuario   in varchar2,
                                 p_vRespuesta out varchar2);

  ------------------------------------------------------
  procedure SP_A8_VALORIZACION(p_dFecha     in date,
                               p_vUsuario   in varchar2,
                               p_vRespuesta out varchar2);
  
  ------------------------------------------------------
  procedure SP_A8_CURVA_PIP(p_vCalif  in varchar2,
                            p_vMoneda in varchar2,
                            p_dFecha  in date,
                            p_nTipCam in number,
                            p_cUsu    in char,
                            p_rpt     out varchar2);

  ------------------------------------------------------
  procedure SP_A8_REPORTE(p_dFecha     in date,
                          p_dFechaPro  in date,
                          p_vUsuario   in varchar2,
                          p_vRespuesta out varchar2);
                          
  ------------------------------------------------------
  procedure SP_A8_ACTUALIZAR_FWD(p_dFecha     in date,
                                 p_vUsuario   in varchar2,
                                 p_vRespuesta out varchar2);
                                 
  ------------------------------------------------------
  procedure SP_A8_GENERAR(p_dFecha     in date,
                          p_vUsuario   in varchar2,
                          p_vRespuesta out varchar2);

  -----------------------------------------------
  Procedure PR_A8_PRUEBAS(pc_tipo_prueba  in varchar2,
                          pd_fecha        in date,
                          pn_escenarios   in number, --Q1 / I1
                          pn_orden        in varchar2, --T1
                          pn_sent_regre   in varchar2, --W1
                          pn_nominal_usd  in number, --Q4
                          pd_fecha_inicio in date, --Q5
                          pd_fecha_vcto   in date, --Q6
                          pc_tipo         in varchar2, --Q7
                          pc_categoria    in varchar2, --Q8
                          pn_cod_fwd      in number, --Q9
                          pn_nom_fwd      in varchar2, --Q9
                          pc_moneda       in varchar2,
                          pn_strike       in number, --retrospectiva --Q9
                          pn_Sld_Cub_usd  in number, --U4
                          pd_par_fec_ini  in date, --U5
                          pd_par_fec_vcto in date, --U6
                          pn_TasaRend     in number, --U7
                          pn_Pendiente    out number,
                          pn_R2           out number,
                          pv_res_cober    out varchar2,
                          pv_Respuesta    out varchar2,
                          pv_respuesta1   out varchar2,
                          pv_respuesta2   out varchar2,
                          pv_respuesta3   out varchar2);
  ------------------------------------------------------
  procedure PR_A8_TRAER_CURVA(pv_tipoCurva in varchar2,
                              pv_calif     in varchar2,
                              pv_moneda    in varchar2,
                              pd_fecIni    in date,
                              pd_fecFin    in date,
                              pv_usuario   in varchar2,
                              pv_rpta      out varchar2);
                              
  ------------------------------------------------------
  procedure PR_A8_UPDATE_CURVA(pv_tipo in varchar2,
                               pv_calif     in varchar2,
                               pv_moneda    in varchar2,
                               pd_fecha     in date,
                               pn_nodo      in number,
                               pv_valor     in varchar2,
                               pv_rpta      out varchar2);

  ------------------------------------------------------
  --NUEVO
  procedure PR_A8_VALIDAR_PRUEBAS(pd_fecha in date,
                                  pv_analista in varchar2,
                                  pv_rpta out varchar2);
                                  
  ------------------------------------------------------
  -------------------- INICIO REP37 --------------------
  ------------------------------------------------------
  procedure SP_REP37_TRAER(pdFecha in date, pvRpta out varchar2);

  ------------------------------------------------------
  procedure SP_REP37_GENERAR(pdFecha in date, pvRpta out varchar2);
  ------------------------------------------------------
  ------------------- INICIO ANEXO 4B ------------------
  ------------------------------------------------------
  procedure SP_4B_TRAER(pdfecha in date,
                        pcAnexo in varchar2,
                        pvRpta  out varchar2);
                        
  ------------------------------------------------------
  procedure SP_4B_GENERAR(pdfecha in date,
                          pvRpta  out varchar2);

  ------------------------------------------------------
  ------------------- INICIO REP 25A -------------------
  ------------------------------------------------------
  procedure SP_25A_TRAER(pdFecha In Date, pdRpta out varchar2);

  ------------------------------------------------------
  procedure SP_25A_GENERAR(pdFecha In Date, pdRpta out varchar2);

  ------------------------------------------------------
  Procedure SP_25A_OBTENER_ADQUIRIENTES(PD_FECHA IN Date, PN_RPTA OUT NUMBER);
  
  ------------------------------------------------------
  ------------------- INICIO REP 15B -------------------
  ------------------------------------------------------
  procedure SP_15B_TRAER(pdFecha In Date, pdRpta out varchar2);
  
  ------------------------------------------------------
  procedure SP_15B_GENERAR(pdFecha In Date, pdRpta out varchar2);
  
   ------------------------------------------------------
  ---------------- VALIDAR DATOS FSH012 ---------------
  ------------------------------------------------------
  procedure SP_VALIDAR_FSH012(pdFecha In Date, pdRpta out varchar2);
  ------------------------------------------------------
  procedure SP_GENERAR_FSH012(pdFecha In Date, pdRpta out varchar2);
  
  ------------------------------------------------------
  ----------------- COPIAR PARAMETROS ------------------
  ------------------------------------------------------
  procedure SP_COPIAR_PARAMETROS(pnPeriodo In Number, 
                                 pcAnexo in varchar2, 
                                 pcUsuario in varchar2,
                                 pdRpta out varchar2);
  ------------------------------------------------------
  ----------- AQPD115 MIVIVIENDA-TECHOPROP -------------
  ------------------------------------------------------
  procedure SP_GENERAR_CRO_MIVIVIENDA(pdFechaCar in date,
                                      pnContrato in varchar2,
                                      pdFechaDes in date,
                                      pnMontoApr in number,
                                      pnBBP      in number,
                                      pnPlazo    in number,
                                      pnTasa     in number,
                                      pcProducto in varchar2,
                                      pcTipo     in varchar2,
                                      pcMoneda   in varchar2,
                                      pcUsuario  in varchar2,
                                      pdRpta     out varchar2);                                 
  ------------------------------------------------------
  ------------------- REPORTE 29 -----------------------
  ------------------------------------------------------
  Procedure SP_EJE_REP29_PARTE_I(PD_FECHA IN Date, PN_RPTA OUT NUMBER, PD_RPTA OUT VARCHAR2); 
  ------------------------------------------------------
  Procedure SP_EJE_REP29_PARTE_II(PD_FECHA IN Date, PN_RPTA OUT NUMBER, PD_RPTA OUT VARCHAR2);
  ------------------------------------------------------
  Procedure SP_TRAER_REP29_PARTE_I(PD_FECHA IN Date, PD_RPTA OUT VARCHAR2);
  ------------------------------------------------------
  Procedure SP_TRAER_REP29_PARTE_II(PD_FECHA IN Date, PD_RPTA OUT VARCHAR2);  
  ------------------------------------------------------
  ------------------ ANEXO 5 - 5A ----------------------
  ------------------------------------------------------
  Procedure SP_TRAER_5_5A(pd_fecha IN Date,
                          pv_ana   IN Varchar2,
                          pv_rpta  OUT Varchar2);
  ------------------------------------------------------
  Procedure SP_GENERAR_5_5A(PD_FECHA In DATE,
                            PN_RPTA OUT NUMBER, 
                            PV_RPTA Out VARCHAR2);
  ------------------------------------------------------
  -------------------- ANEXO 5D ------------------------
  ------------------------------------------------------
  Procedure SP_TRAER_5D(pd_fecha IN Date,
                          pv_ana   IN Varchar2,
                          pv_rpta  OUT Varchar2);
  Procedure SP_GENERAR_5D(pdfecha in date,pvRpta  out varchar2); 
  ------------------------------------------------------
  -------------------- ADEUDOS -------------------------
  ------------------------------------------------------
  Procedure SP_RECAL_ADEUDO(pn_Correlativo IN Number,
                            pn_Id       IN Number,
                            pd_FechaDes IN Date,
                            pn_NroCuota IN Number,
                            pn_Tasa     IN Number,
                            pn_Monto    IN Number,
                            pv_rpta     OUT VARCHAR2);
                         
  
  
  /*
  ------------------------------------------------------
  ------------------- INICIO REP 16A -------------------
  ------------------------------------------------------
  procedure SP_REP16A_REPORTE(pdFecha In Date, pdRpta out varchar2);

  ------------------------------------------------------
  procedure SP_16A_TRAER_CTAS_INV_DIS(pdFech in date,
                                      pcRpta out varchar2);
                                      
  ------------------------------------------------------
  procedure SP_16A_UPDATE_FCVTO(pnPgcod in number,
                            pnSuc in number,
                            pnMda in number,
                            pnPap in number,
                            pnCta in number,
                            pnOper in number,
                            pnSbop in number,
                            pnTop in number,
                            pnMod in number,
                            pdFech in date,
                            pdFvto in date,
                            pdRpta out varchar2); 
                            
  ------------------------------------------------------
  procedure SP_16A_GENERAR(pdFech in date,
                           pcRpta out varchar2);
  */
end PQ_CR_REP_ANX_RIES;
/
create or replace package body PQ_CR_REP_ANX_RIES
is
  -----------------------------------------------------
  ---------- GENERAL ----------------------------------
  -----------------------------------------------------
  FUNCTION FN_TIPO_CAMBIO_FIJO(P_FECHA in date) 
  Return number 
  Is
    ln_tipcam number(8,3);
  Begin
    Select cotcbi
      Into ln_tipcam
      From (select u.cotcbi
              From fsh005 u
             Where moneda = 101
               And cofdes <= P_FECHA
             Order by cofdes desc)
     Where rownum = 1;
  
    Return ln_tipcam;
  Exception
    when others then
      return 0;
  END FN_TIPO_CAMBIO_FIJO;

  ------------------------------------------------------
  ------------------ INICIO ANEXO 2A1 ------------------
  ------------------------------------------------------
  procedure sp_generar_anexo2a1(p_fecproces in out date,
                                p_anexo     in varchar2,
                                p_usuario   in varchar2,
                                p_respuesta out varchar2) is
    v_error      varchar2(300);
    --n_numeracion number(10);
    --n_orden      number(10);
    --n_sumacol19  number(17, 2);
    --n_col19det1  number(17, 2);
    --n_col19det2  number(17, 2);
    --n_col19det3  number(17, 2);
    --n_factajust  number(17, 6);
    --n_limitglob  number(17, 6);
  
    v_valorpro varchar2(2);
  begin
    p_respuesta := 'S';
    --Limpieza de tabla temporal
    begin
      delete from aqpd101 a
       where a.aqpd101fec = p_fecproces
         and a.aqpd101usr = p_usuario;
      commit;
    exception
      when others then
        null;
    end;

    --Validamos que el proceso del periodo no este Cerrado
    begin
      PQ_CR_REP_ANX_RIES.sp_validar_estado_periodo(to_char(p_fecproces, 'rrrrmm'),
                                                   p_anexo,
                                                   v_valorpro);
    exception
      when others then
        v_valorpro := 'C';
    end;
    
    --Invocamos al procedimiento de carga
    begin
      dwhouse.pq_ries_anexos_reportes.SP_EJE_REP2A1@DW(p_fecproces);
    exception when others then
        v_error     := substr(SQLERRM, 1, 250);
        p_respuesta := 'N';
    end;

  end sp_generar_anexo2a1;

  ------------------------------------------------------
  procedure sp_cargar_data_reporte_anexo2a1(p_fecproces in out date,
                                            p_anexo     in varchar2,
                                            p_usuario   in varchar2,
                                            p_respuesta out varchar2) is
    v_error      varchar2(300);
    n_numeracion number(10);
    n_orden      number(10);
    n_sumacol19  number(17, 2);
    n_col19det1  number(17, 2);
    n_col19det2  number(17, 2);
    n_col19det3  number(17, 2);
    n_factajust  number(17, 6);
    n_limitglob  number(17, 6);
  
    --v_valorpro varchar2(2);
  begin
    --Cargamos el detalle 1 *****************************************************************************************************
    begin
      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101COD,
         AQPD101TEX,
         AQPD101PRI,
         AQPD101PON,
         AQPD101C01,
         AQPD101C02,
         AQPD101C03,
         AQPD101C04,
         AQPD101C05,
         AQPD101C06,
         AQPD101C07,
         AQPD101C08,
         AQPD101C09,
         AQPD101C10,
         AQPD101C11,
         AQPD101C12,
         AQPD101C13,
         AQPD101C14,
         AQPD101C141,
         AQPD101C15,
         AQPD101C16,
         AQPD101C17,
         AQPD101C18,
         AQPD101C19,
         AQPD101USR,
         AQPD101FECC,
         AQPD101HORC,
         AQPD101DET)
        SELECT orden,
               fecha,
               codigo,
               tipo_exposicion,
               ponderado,
               ponderado_valor,
               sum(nvl(col_1, 0)) col_1,
               sum(nvl(col_2, 0)) col_2,
               sum(nvl(col_3, 0)) col_3,
               sum(nvl(col_1, 0) - nvl(col_2, 0) + nvl(col_3, 0)) col4,
               sum(nvl(col_5, 0)) col_5,
               sum(nvl(col_6, 0)) col_6,
               sum(nvl(col_7, 0)) col_7,
               sum(nvl(col_8, 0)) col_8,
               sum(nvl(col_9, 0)) col_9,
               sum(nvl(col_10, 0)) col_10,
               sum(nvl(col_11, 0)) col_11,
               sum(nvl(col_12, 0)) col_12,
               sum((nvl(col_1, 0) - nvl(col_2, 0) + nvl(col_3, 0)) -
                   nvl(col_5, 0) + nvl(col_6, 0) + nvl(col_7, 0) +
                   nvl(col_8, 0) -
                   (nvl(col_10, 0) - nvl(col_11, 0) - nvl(col_12, 0))) col_13cal,
               sum(nvl(col_14, 0)) col_14,
               sum(nvl(col_14_1, 0)) col_14_1,
               sum(nvl(col_15, 0)) col_15,
               sum(nvl(col_16, 0)) col_16,
               sum(nvl(col_17, 0)) col_17,
               sum(((nvl(col_1, 0) - nvl(col_2, 0) + nvl(col_3, 0)) -
                   nvl(col_5, 0) + nvl(col_6, 0) + nvl(col_7, 0) +
                   nvl(col_8, 0) -
                   (nvl(col_10, 0) - nvl(col_11, 0) - nvl(col_12, 0))) -
                   nvl(col_14, 0) - 0.9 * nvl(col_14_1, 0) -
                   0.8 * nvl(col_15, 0) - 0.5 * nvl(col_16, 0)) col_18,
               sum((((nvl(col_1, 0) - nvl(col_2, 0) + nvl(col_3, 0)) -
                   nvl(col_5, 0) + nvl(col_6, 0) + nvl(col_7, 0) +
                   nvl(col_8, 0) -
                   (nvl(col_10, 0) - nvl(col_11, 0) - nvl(col_12, 0))) -
                   nvl(col_14, 0) - 0.9 * nvl(col_14_1, 0) -
                   0.8 * nvl(col_15, 0) - 0.5 * nvl(col_16, 0)) *
                   d.ponderado_valor * 1) col_19,
               p_usuario,
               trunc(SYSDATE),
               TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               1
          from dwhouse.FACT_RIES_2A1_REP@DW d
         where fecha = p_fecproces
           and codigo is not null
           and ind_seccion = 1
         group by orden,
                  fecha,
                  codigo,
                  tipo_exposicion,
                  ponderado,
                  ponderado_valor
         order by orden;
    
      Commit;

      p_respuesta := 'S';
    exception
      when others then
        v_error     := substr(SQLERRM, 1, 300);
        p_respuesta := 'N';
    end;

    --Cargamos el detalle 9    
    begin

      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101COD,
         AQPD101TEX,
         AQPD101C01,
         AQPD101C02,
         AQPD101USR,
         AQPD101FECC,
         AQPD101HORC,
         AQPD101DET)
        SELECT orden,
               nvl(d.fecha, p_fecproces),
               null,
               trim(tipo_exposicion),
               col_1,
               col_2,
               p_usuario,
               trunc(SYSDATE),
               TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               9
          from dwhouse.FACT_RIES_2A1_REP@DW d
         where fecha = p_fecproces
           and ind_seccion = 0
         Order by 1;
      Commit;
    exception
      when others then
        null;
    end;

    --Totales detalle 1
    begin
      SELECT AQPD101ORD, round(TO_NUMBER(trim(AQPD101COD), '999.99'), 0)
        into n_orden, n_numeracion
        from AQPD101
       where AQPD101FEC = p_fecproces
            --and AQPD101FECC = trunc(SYSDATE)
         and AQPD101USR = p_usuario
         and AQPD101DET = 1
         and AQPD101ORD = (select max(AQPD101ORD)
                             from aqpd101
                            where AQPD101FEC = p_fecproces
                              and AQPD101FECC = trunc(SYSDATE)
                              and AQPD101USR = p_usuario
                              and AQPD101DET = 1);
    exception
      when others then
        n_numeracion := 16;
    end;

    --Suma Columna 19
    begin
      SELECT round(SUM(AQPD101C19), 2)
        into n_sumacol19
        from AQPD101
       where AQPD101FEC = p_fecproces
         and AQPD101FECC = trunc(SYSDATE)
         and AQPD101USR = p_usuario
         and AQPD101DET = 1;
    exception
      when others then
        n_sumacol19 := 0;
    end;

    --Factor de Ajuste y Limite Global 
    begin
      SELECT round(AQPD101C01, 2)
        into n_factajust
        from AQPD101
       where AQPD101FEC = p_fecproces
            --and AQPD101FECC = trunc(SYSDATE)
         and AQPD101USR = p_usuario
         and AQPD101DET = 9
         and AQPD101TEX = 'FACTOR AJUSTE A';
    exception
      when others then
        n_factajust := 1;
    end;

    begin
      SELECT round(AQPD101C02, 2)
        into n_limitglob
        from AQPD101
       where AQPD101FEC = p_fecproces
            --and AQPD101FECC = trunc(SYSDATE)
         and AQPD101USR = p_usuario
         and AQPD101DET = 9
         and AQPD101TEX = 'LÍMITE GLOBAL';
    exception
      when others then
        n_limitglob := 0.09;
    end;

    --Calculos
    begin
      n_col19det1 := round(n_factajust * n_sumacol19, 2);
      n_col19det2 := round(n_sumacol19 - n_col19det1, 2);
      n_col19det3 := round(n_col19det2 * n_limitglob, 2);
    exception
      when others then
        n_col19det1 := 0;
        n_col19det2 := 0;
        n_col19det3 := 0;
    end;
    n_orden      := n_orden + 1;
    n_numeracion := n_numeracion + 1;
  
    begin
      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101COD,
         AQPD101TEX,
         AQPD101C19,
         AQPD101USR,
         AQPD101FECC,
         AQPD101HORC,
         AQPD101DET)
        SELECT n_orden,
               p_fecproces,
               n_numeracion,
               'EXPOSICIONES AJUSTADAS PONDERADAS POR RIESGO DE CRÉDITO SIN DEDUCIR PROVISIONES GENÉRICAS NO CONSIDERADAS EN PATRIMONIO EFECTIVO XVI',
               n_sumacol19,
               p_usuario,
               trunc(SYSDATE),
               TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               1
          from dual d;
      Commit;
    exception
      when others then
        v_error := substr(SQLERRM, 1, 300);
        DBMS_OUTPUT.put_line(v_error);
    end;

    --
    n_orden      := n_orden + 1;
    n_numeracion := n_numeracion + 1;
    begin
      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101COD,
         AQPD101TEX,
         AQPD101C19,
         AQPD101USR,
         AQPD101FECC,
         AQPD101HORC,
         AQPD101DET)
        SELECT n_orden,
               p_fecproces,
               n_numeracion,
               'Provisiones Genéricas no consideradas en el patrimonio efectivo XVII',
               n_col19det1,
               p_usuario,
               trunc(SYSDATE),
               TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               1
          from dual d;
      Commit;
    exception
      when others then
        null;
    end;

    --
    n_orden      := n_orden + 1;
    n_numeracion := n_numeracion + 1;
    begin
      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101COD,
         AQPD101TEX,
         AQPD101C19,
         AQPD101C20,
         AQPD101USR,
         AQPD101FECC,
         AQPD101HORC,
         AQPD101DET)
        SELECT n_orden,
               p_fecproces,
               n_numeracion,
               'TOTALES XVIII',
               n_col19det2,
               n_col19det3,
               p_usuario,
               trunc(SYSDATE),
               TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               1
          from dual d;
      Commit;
    exception
      when others then
        null;
    end;

    --Cargamos el detalle 2 *****************************************************************************************************
    begin
      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101COD,
         AQPD101TEX,
         AQPD101PRI,
         AQPD101PON,
         AQPD101C01,
         AQPD101C02,
         AQPD101C03,
         AQPD101C04,
         AQPD101C05,
         AQPD101C06,
         AQPD101C07,
         AQPD101C08,
         AQPD101C09,
         AQPD101C10,
         AQPD101C11,
         AQPD101C12,
         AQPD101C13,
         AQPD101C14,
         AQPD101C141,
         AQPD101C15,
         AQPD101C16,
         AQPD101C17,
         AQPD101C18,
         AQPD101C19,
         AQPD101USR,
         AQPD101FECC,
         AQPD101HORC,
         AQPD101DET)
        SELECT orden,
               fecha,
               codigo,
               null,
               ponderado,
               null,
               sum(nvl(col_1, 0)) col_1,
               sum(nvl(col_2, 0)) col_2,
               sum(nvl(col_3, 0)) col_3,
               sum(nvl(col_1, 0) - nvl(col_2, 0) + nvl(col_3, 0)) col4,
               sum(nvl(col_5, 0)) col_5,
               sum(nvl(col_6, 0)) col_6,
               sum(nvl(col_7, 0)) col_7,
               sum(nvl(col_8, 0)) col_8,
               sum(nvl(col_9, 0)) col_9,
               sum(nvl(col_10, 0)) col_10,
               sum(nvl(col_11, 0)) col_11,
               sum(nvl(col_12, 0)) col_12,
               sum((nvl(col_1, 0) - nvl(col_2, 0) + nvl(col_3, 0)) -
                   nvl(col_5, 0) + nvl(col_6, 0) + nvl(col_7, 0) +
                   nvl(col_8, 0) -
                   (nvl(col_10, 0) - nvl(col_11, 0) - nvl(col_12, 0))) col_13cal,
               sum(nvl(col_14, 0)) col_14,
               sum(nvl(col_14_1, 0)) col_14_1,
               sum(nvl(col_15, 0)) col_15,
               sum(nvl(col_16, 0)) col_16,
               sum(nvl(col_17, 0)) col_17,
               sum(nvl(col_18, 0)) col_18,
               sum(nvl(col_19, 0)) col_19,
               p_usuario,
               trunc(SYSDATE),
               TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               2
          from dwhouse.FACT_RIES_2A1_REP@DW d
         where fecha = p_fecproces
           and ind_seccion = 2
         group by orden, fecha, codigo, ponderado
         order by orden;
      Commit;

      p_respuesta := 'S';
    exception
      when others then
        v_error     := substr(SQLERRM, 1, 300);
        p_respuesta := 'N';
    end;

    --Totales detalle 2  
    --Suma Columna 18
    begin
      SELECT round(SUM(AQPD101C19), 2)
        into n_sumacol19
        from AQPD101
       where AQPD101FEC = p_fecproces
         and AQPD101USR = p_usuario
         and AQPD101DET = 2;
    exception
      when others then
        n_sumacol19 := 0;
    end;

    --Calculos
    begin
      n_col19det1 := round(n_factajust * n_sumacol19, 2);
      n_col19det2 := round(n_sumacol19 - n_col19det1, 2);
      n_col19det3 := round(n_col19det2 * n_limitglob, 2);
    exception
      when others then
        n_col19det1 := 0;
        n_col19det2 := 0;
        n_col19det3 := 0;
    end;
    --
    begin
      UPDATE AQPD101
         set AQPD101C19 = n_sumacol19
       where AQPD101FEC = p_fecproces
         and AQPD101USR = p_usuario
         and AQPD101DET = 2
         and AQPD101ORD = 37;
      Commit;
    exception
      when others then
        null;
    end;
    --
    begin
      UPDATE AQPD101
         set AQPD101C19 = n_col19det1
       where AQPD101FEC = p_fecproces
         and AQPD101USR = p_usuario
         and AQPD101DET = 2
         and AQPD101ORD = 38;
      Commit;
    exception
      when others then
        null;
    end;
    --
    begin
      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101PRI,
         AQPD101C19,
         AQPD101C20,
         AQPD101USR,
         AQPD101FECC,
         AQPD101HORC,
         AQPD101DET)
        SELECT 39,
               p_fecproces,
               'Totales',
               n_col19det2,
               n_col19det3,
               p_usuario,
               trunc(SYSDATE),
               TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               2
          from dual d;
      Commit;
    exception
      when others then
        v_error := substr(SQLERRM, 1, 300);
        DBMS_OUTPUT.put_line(v_error);
    end;

    --Cargamos el detalle 3 *****************************************************************************************************
    begin
      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101COD,
         AQPD101TEX,
         AQPD101PRI,
         AQPD101PON,
         AQPD101C01,
         AQPD101C02,
         AQPD101C03,
         AQPD101C04,
         AQPD101C05,
         AQPD101C06,
         AQPD101C07,
         AQPD101C08,
         AQPD101C09,
         AQPD101C10,
         AQPD101C11,
         AQPD101C12,
         AQPD101C13,
         AQPD101C14,
         AQPD101C141,
         AQPD101C15,
         AQPD101C16,
         AQPD101C17,
         AQPD101C18,
         AQPD101C19,
         AQPD101USR,
         AQPD101FECC,
         AQPD101HORC,
         AQPD101DET)
        SELECT orden,
               fecha,
               null,
               codigo,
               ponderado,
               null,
               sum(nvl(col_1, 0)) col_1,
               sum(nvl(col_2, 0)) col_2,
               sum(nvl(col_3, 0)) col_3,
               sum(nvl(col_1, 0) - nvl(col_2, 0) + nvl(col_3, 0)) col4,
               sum(nvl(col_5, 0)) col_5,
               sum(nvl(col_6, 0)) col_6,
               sum(nvl(col_7, 0)) col_7,
               sum(nvl(col_8, 0)) col_8,
               sum(nvl(col_9, 0)) col_9,
               sum(nvl(col_10, 0)) col_10,
               sum(nvl(col_11, 0)) col_11,
               sum(nvl(col_12, 0)) col_12,
               sum((nvl(col_1, 0) - nvl(col_2, 0) + nvl(col_3, 0)) -
                   nvl(col_5, 0) + nvl(col_6, 0) + nvl(col_7, 0) +
                   nvl(col_8, 0) -
                   (nvl(col_10, 0) - nvl(col_11, 0) - nvl(col_12, 0))) col_13cal,
               sum(nvl(col_14, 0)) col_14,
               sum(nvl(col_14_1, 0)) col_14_1,
               sum(nvl(col_15, 0)) col_15,
               sum(nvl(col_16, 0)) col_16,
               sum(nvl(col_17, 0)) col_17,
               sum(nvl(col_18, 0)) col_18,
               sum(nvl(col_19, 0)) col_19,
               p_usuario,
               trunc(SYSDATE),
               TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               3
          from dwhouse.FACT_RIES_2A1_REP@DW d
         where fecha = p_fecproces
           and ind_seccion = 3
         group by orden, fecha, codigo, ponderado
         order by orden;
      Commit;

      p_respuesta := 'S';
    exception
      when others then
        v_error     := substr(SQLERRM, 1, 300);
        p_respuesta := 'N';
    end;

    --Totales detalle 3
    --Suma Columna 18
    begin
      SELECT round(SUM(AQPD101C19), 2)
        into n_sumacol19
        from AQPD101
       where AQPD101FEC = p_fecproces
         and AQPD101USR = p_usuario
         and AQPD101DET = 3;
    exception
      when others then
        n_sumacol19 := 0;
    end;
    --Calculos
    begin
      n_col19det1 := round(n_factajust * n_sumacol19, 2);
      n_col19det2 := round(n_sumacol19 - n_col19det1, 2);
      n_col19det3 := round(n_col19det2 * n_limitglob, 2);
    exception
      when others then
        n_col19det1 := 0;
        n_col19det2 := 0;
        n_col19det3 := 0;
    end;
    --
    begin
      UPDATE AQPD101
         set AQPD101C19 = n_sumacol19
       where AQPD101FEC = p_fecproces
         and AQPD101USR = p_usuario
         and AQPD101DET = 3
         and AQPD101ORD = 17;
      Commit;
    exception
      when others then
        null;
    end;
    --
    begin
      UPDATE AQPD101
         set AQPD101C19 = n_col19det1
       where AQPD101FEC = p_fecproces
         and AQPD101USR = p_usuario
         and AQPD101DET = 3
         and AQPD101ORD = 18;
      Commit;
    exception
      when others then
        null;
    end;
    --
    begin
      UPDATE AQPD101
         set AQPD101C19 = n_col19det2, AQPD101C20 = n_col19det3
       where AQPD101FEC = p_fecproces
         and AQPD101USR = p_usuario
         and AQPD101DET = 3
         and AQPD101ORD = 19;
      Commit;
    exception
      when others then
        null;
    end;
    /*begin
      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101PRI,
         AQPD101C18,
         AQPD101C19,
         AQPD101USR,
         AQPD101FECC,
         AQPD101DET)
        SELECT 19,
               p_fecproces,
               'Totales',
               round(n_sumacol18 - round(n_factajust * n_sumacol18, 2), 2),
               round(round(n_sumacol18 -
                           round(n_factajust * n_sumacol18, 2),
                           2) * n_limitglob,
                     2),
               p_usuario,
               trunc(SYSDATE),
               3
          from dual d;
      Commit;
    exception
      when others then
        v_error := substr(SQLERRM, 1, 300);
        DBMS_OUTPUT.put_line(v_error);
    end;*/
  end sp_cargar_data_reporte_anexo2a1;

  ------------------------------------------------------
  procedure sp_copiar_param_period_anexo2a1(p_periodo   in number,
                                            p_anexo     in varchar2,
                                            p_usuario   in varchar2,
                                            p_respuesta out varchar2,
                                            p_resptexto out varchar2) is
    v_error       varchar2(300);
    n_periodo_ant number(8);
    n_anio        number(4);
    n_mes         number(2);
    n_cant        number(5);
    --v_valorpro    varchar2(2);
  begin
    --Limpieza de tabla temporal
    begin
      delete from aqpd102 a
       where a.aqpd102per = p_periodo
         and a.aqpd102anx = p_anexo;
      commit;
    exception
      when others then
        null;
    end;
    --obtener periodo anterior
    begin
      SELECT CASE
               WHEN TO_NUMBER(SUBSTR(TO_CHAR(p_periodo), 5, 2)) = 1 THEN
                TO_NUMBER(SUBSTR(TO_CHAR(p_periodo), 1, 4)) - 1
               ELSE
                TO_NUMBER(SUBSTR(TO_CHAR(p_periodo), 1, 4))
             END AS anio_anterior,
             CASE
               WHEN TO_NUMBER(SUBSTR(TO_CHAR(p_periodo), 5, 2)) = 1 THEN
                12
               ELSE
                TO_NUMBER(SUBSTR(TO_CHAR(p_periodo), 5, 2)) - 1
             END AS mes_anterior
        INTO n_anio, n_mes
        FROM dual;
    exception
      when others then
        p_respuesta := 'N';
        p_resptexto := 'Error al cargar el periodo anterior.';
        return;
    end;
    n_periodo_ant := n_anio * 100 + n_mes;
    begin
      select count(*)
        into n_cant
        from AQPD102
       where AQPD102PER = n_periodo_ant
         AND AQPD102ANX = p_anexo;
    exception
      when others then
        p_respuesta := 'N';
        p_resptexto := 'Error al cargar el periodo anterior.';
        return;
    end;
    if n_cant > 0 then
      begin
        INSERT INTO AQPD102
          (AQPD102PER,
           AQPD102ANX,
           AQPD102CTP,
           AQPD102DTP,
           AQPD102COR,
           AQPD102CVA,
           AQPD102VAL,
           AQPD102VLN,
           AQPD102VLP,
           AQPD102VDE,
           AQPD102DFE,
           AQPD102HOJ,
           AQPD102CA1,
           AQPD102CA2,
           AQPD102CA3,
           AQPD102WH1,
           AQPD102CA4,
           AQPD102CA5,
           AQPD102CA6,
           AQPD102CA7,
           AQPD102CA8,
           AQPD102CA9,
           AQPD102CA10,
           AQPD102CA11,
           AQPD102CA12,
           AQPD102CA13,
           AQPD102CA14,
           AQPD102CA141,
           AQPD102CA15,
           AQPD102CA16,
           AQPD102CA17,
           AQPD102CVL1,
           AQPD102CVL2,
           AQPD102CVL3,
           AQPD102CREP,
           AQPD102RPC1,
           AQPD102RPC2,
           AQPD102CSBS,
           AQPD102USRA,
           AQPD102FECA,
           AQPD102HORA)
          SELECT p_periodo,
                 p_anexo,
                 AQPD102CTP,
                 AQPD102DTP,
                 AQPD102COR,
                 AQPD102CVA,
                 AQPD102VAL,
                 AQPD102VLN,
                 AQPD102VLP,
                 AQPD102VDE,
                 AQPD102DFE,
                 AQPD102HOJ,
                 AQPD102CA1,
                 AQPD102CA2,
                 AQPD102CA3,
                 AQPD102WH1,
                 AQPD102CA4,
                 AQPD102CA5,
                 AQPD102CA6,
                 AQPD102CA7,
                 AQPD102CA8,
                 AQPD102CA9,
                 AQPD102CA10,
                 AQPD102CA11,
                 AQPD102CA12,
                 AQPD102CA13,
                 AQPD102CA14,
                 AQPD102CA141,
                 AQPD102CA15,
                 AQPD102CA16,
                 AQPD102CA17,
                 AQPD102CVL1,
                 AQPD102CVL2,
                 AQPD102CVL3,
                 AQPD102CREP,
                 AQPD102RPC1,
                 AQPD102RPC2,
                 AQPD102CSBS,
                 p_usuario,
                 TRUNC(SYSDATE),
                 TO_CHAR(SYSDATE, 'HH24:MI:SS')
            FROM AQPD102
           WHERE AQPD102PER = n_periodo_ant
             AND AQPD102ANX = p_anexo;
        commit;
        --actualiza el estado como A
        UPDATE AQPD102
           SET AQPD102VAL = 'A'
         WHERE AQPD102PER = p_periodo
           AND AQPD102ANX = p_anexo
           AND AQPD102CTP = 0;
        commit;
        p_respuesta := 'S';
        p_resptexto := 'OK.';
      exception
        when others then
          v_error     := substr(SQLERRM, 1, 300);
          p_respuesta := 'N';
          p_resptexto := 'Error al cargar el periodo anterior.';
      end;
    else
      p_respuesta := 'N';
      p_resptexto := 'El periodo anterior no tiene registros.';
    end if;
  end sp_copiar_param_period_anexo2a1;

  ------------------------------------------------------
  procedure sp_validar_estado_periodo(p_periodo in number,
                                      p_anexo   in varchar2,
                                      p_estado  out varchar2) is
  
  begin
    begin
      select AQPD102VAL
        into p_estado
        from AQPD102
       where AQPD102PER = p_periodo
         and AQPD102ANX = p_anexo
         and AQPD102CTP = 0
         and rownum = 1;
      /*select vvalor into v_valorpro from dwhouse.prm_anxrep@DW
      where nperiod = to_number(to_char(p_fecproces,'rrrrmm'))
        and vcodanx = 'ANEXO2A1' 
        and ncodtip = 0
        and rownum = 1;*/
    exception
      when others then
        p_estado := 'C';
    end;
  end sp_validar_estado_periodo;

  ------------------------------------------------------
  ------------------- INICIO ANEXO 8 -------------------
  ------------------------------------------------------
  Function FN_CALIF_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date)
    Return VARCHAR2 Is
    vCalificacion varchar2(10);
    nPeriodo      number(10);
  Begin
    nPeriodo := to_char(pn_Fecha, 'rrrrmm');
  
    begin
      select aqpd102val
        into vCalificacion
        from aqpd102
       where aqpd102anx = 'ANEXO8'
         and aqpd102ctp = 2
         and aqpd102per = nPeriodo
         and aqpd102cva = pv_CodEnt;
    Exception
      When Others Then
        null;
    End;
  
    Return vCalificacion;
  End FN_CALIF_ENT_FINAN;

  ------------------------------------------------------
  Function FN_NOMBRE_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date)
    Return VARCHAR2 Is
    vNombre  varchar2(50);
    nPeriodo number(10);
  Begin
    nPeriodo := to_char(pn_Fecha, 'rrrrmm');
  
    begin
      select AQPD102VDE
        into vNombre
        from aqpd102
       where aqpd102anx = 'ANEXO8'
         and aqpd102ctp = 2
         and aqpd102per = nPeriodo
         and aqpd102cva = pv_CodEnt;
    Exception
      When Others Then
        null;
    End;
  
    Return vNombre;
  End FN_NOMBRE_ENT_FINAN;

  ------------------------------------------------------
  Function FN_RESIDENTE_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date)
    Return VARCHAR2 Is
    vResidente varchar2(50);
    nPeriodo   number(10);
  Begin
    nPeriodo := to_char(pn_Fecha, 'rrrrmm');
  
    begin
      select aqpd102ca3
        into vResidente
        from aqpd102
       where aqpd102anx = 'ANEXO8'
         and aqpd102ctp = 2
         and aqpd102per = nPeriodo
         and aqpd102cva = pv_CodEnt;
    Exception
      When Others Then
        null;
    End;
  
    Return vResidente;
  End FN_RESIDENTE_ENT_FINAN;

  ------------------------------------------------------
  Function FN_PAIS_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date)
    Return VARCHAR2 Is
    vPais    varchar2(50);
    nPeriodo number(10);
  Begin
    nPeriodo := to_char(pn_Fecha, 'rrrrmm');
  
    begin
      select aqpd102ca4
        into vPais
        from aqpd102
       where aqpd102anx = 'ANEXO8'
         and aqpd102ctp = 2
         and aqpd102per = nPeriodo
         and aqpd102cva = pv_CodEnt;
    Exception
      When Others Then
        null;
    End;
  
    Return vPais;
  End FN_PAIS_ENT_FINAN;

  ------------------------------------------------------
  Function FN_DOCUMENTO_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date)
    Return VARCHAR2 Is
    vDocumento varchar2(50);
    nPeriodo   number(10);
  Begin
    nPeriodo := to_char(pn_Fecha, 'rrrrmm');
  
    begin
      select aqpd102ca2
        into vDocumento
        from aqpd102
       where aqpd102anx = 'ANEXO8'
         and aqpd102ctp = 2
         and aqpd102per = nPeriodo
         and aqpd102cva = pv_CodEnt;
    Exception
      When Others Then
        null;
    End;
  
    Return vDocumento;
  End FN_DOCUMENTO_ENT_FINAN;

  ------------------------------------------------------
  Function FN_FINANCIERO_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date)
    Return VARCHAR2 Is
    vFinanciero varchar2(50);
    nPeriodo    number(10);
  Begin
    nPeriodo := to_char(pn_Fecha, 'rrrrmm');
  
    begin
      select aqpd102ca5
        into vFinanciero
        from aqpd102
       where aqpd102anx = 'ANEXO8'
         and aqpd102ctp = 2
         and aqpd102per = nPeriodo
         and aqpd102cva = pv_CodEnt;
    Exception
      When Others Then
        null;
    End;
  
    Return vFinanciero;
  End FN_FINANCIERO_ENT_FINAN;

  ------------------------------------------------------
  Function FN_COD_SBS_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date)
    Return VARCHAR2 Is
    vCodSbs  varchar2(50);
    nPeriodo number(10);
  Begin
    nPeriodo := to_char(pn_Fecha, 'rrrrmm');
  
    begin
      select aqpd102ca6
        into vCodSbs
        from aqpd102
       where aqpd102anx = 'ANEXO8'
         and aqpd102ctp = 2
         and aqpd102per = nPeriodo
         and aqpd102cva = pv_CodEnt;
    Exception
      When Others Then
        null;
    End;
  
    Return vCodSbs;
  End FN_COD_SBS_ENT_FINAN;

  ------------------------------------------------------
  Function FN_CUENTA_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date)
    Return VARCHAR2 Is
    vCuenta  varchar2(50);
    nPeriodo number(10);
  Begin
    nPeriodo := to_char(pn_Fecha, 'rrrrmm');
  
    begin
      select aqpd102ca1
        into vCuenta
        from aqpd102
       where aqpd102anx = 'ANEXO8'
         and aqpd102ctp = 2
         and aqpd102per = nPeriodo
         and aqpd102cva = pv_CodEnt;
    Exception
      When Others Then
        null;
    End;
  
    Return vCuenta;
  End FN_CUENTA_ENT_FINAN;

  ------------------------------------------------------
  Function FN_CONVENIO_ENT_FINAN(pv_CodEnt in varchar2, pn_Fecha in date)
    Return VARCHAR2 Is
    vConvenio varchar2(50);
    nPeriodo  number(10);
  Begin
    nPeriodo := to_char(pn_Fecha, 'rrrrmm');
  
    begin
      select aqpd102ca7
        into vConvenio
        from aqpd102
       where aqpd102anx = 'ANEXO8'
         and aqpd102ctp = 2
         and aqpd102per = nPeriodo
         and aqpd102cva = pv_CodEnt;
    Exception
      When Others Then
        null;
    End;
  
    Return vConvenio;
  End FN_CONVENIO_ENT_FINAN;

  ------------------------------------------------------
  procedure SP_A8_TRAER_FWD_TODO(pdfecha      in date,
                                 pdfechaPro   in date,
                                 p_vUsuario   in varchar2,
                                 p_vRespuesta out varchar2) is
    err_msg  varchar2(255);
    dFecha   date := pdfecha;
    cUsuario char(10);
  begin
    cUsuario := p_vUsuario;
  
    p_vRespuesta := 'N';
    begin
      --NUEVO se agrego deal
      insert into AQPD103
        (AQPD103DEAL, AQPD103NFWD, AQPD103CODFWD, AQPD103FECINI, AQPD103FECVTO, 
         AQPD103MNTUSD, AQPD103ENT, AQPD103CODENT, AQPD103TIPO, 
         AQPD103FPAGO, AQPD103TCFWDS, AQPD103TSUSD, AQPD103TSPEN, 
         AQPD103TCSPOT, AQPD103TIPCUR, AQPD103MONEDA, AQPD103CORRE, 
         AQPD103ESTREG, AQPD103USUREG, AQPD103FECREG, AQPD103FECPRO, AQPD103FECREP)
        Select 
          inv.deal_no, inv.NOM_FORDWARD, inv.NRO_FORDWARD, inv.fecha_transaccion, inv.fecha_vencimiento,
          inv.monto_transaccion, PQ_CR_REP_ANX_RIES.FN_NOMBRE_ENT_FINAN(inv.entidad, dFecha), inv.entidad, inv.product_type,
          inv.forma_de_pago, inv.TC_Strike, 
          inv.Tasa_USD, --para genexus
          inv.Tasa_PEN, --para genexus
          --to_number(replace(inv.Tasa_USD, '.', ',')) Tasa_USD, --para test
          --to_number(replace(inv.Tasa_PEN, '.', ',')) Tasa_PEN, --para test
          inv.TC_spot, PQ_CR_REP_ANX_RIES.FN_CALIF_ENT_FINAN(inv.entidad, dFecha), inv.moneda, 1,
          1, cUsuario, sysdate, pdfechaPro, pdfecha
          from DWHOUSE.FACT_RIES_XTR_DEALS@DW inv
          left join AQPD103 A
            on A.AQPD103CODFWD = inv.NRO_FORDWARD
           and A.AQPD103TIPO = inv.product_type
         where A.AQPD103NFWD is null;
      commit;
      p_vRespuesta := 'S';
    exception
      when others then
        err_msg      := substr(SQLERRM, 1, 255);
        p_vRespuesta := err_msg;
        null;
    end;
    COMMIT;
  end SP_A8_TRAER_FWD_TODO;

  ------------------------------------------------------
  procedure SP_A8_TRAER_FORWARD(p_dFecha     in date,
                                p_dFechaPro  in date,
                                p_vUsuario   in varchar2,
                                p_vRespuesta out varchar2) is
    --NUEVO DEAL
    cursor lst_ebs(p_Fecha in date) is
      Select inv.DEAL_NO,
             inv.NOM_FORDWARD,
             inv.NRO_FORDWARD,
             inv.fecha_transaccion,
             inv.fecha_vencimiento,
             inv.monto_transaccion,
             PQ_CR_REP_ANX_RIES.FN_NOMBRE_ENT_FINAN(inv.entidad, p_Fecha) nom_entidad,
             inv.entidad cod_entidad,
             inv.product_type,
             inv.forma_de_pago,
             inv.TC_Strike,
             inv.Tasa_USD, --para genexus
             inv.Tasa_PEN, --para genexus
             --to_number(replace(inv.Tasa_USD, '.', ',')) Tasa_USD, --para test
             --to_number(replace(inv.Tasa_PEN, '.', ',')) Tasa_PEN, --para test
             --to_number(inv.Tasa_USD) Tasa_USD,
             --to_number(inv.Tasa_PEN) Tasa_PEN,
             inv.TC_spot,
             inv.moneda,
             PQ_CR_REP_ANX_RIES.FN_CALIF_ENT_FINAN(inv.entidad, p_Fecha) calificacion
        from DWHOUSE.FACT_RIES_XTR_DEALS@DW inv
       ORDER BY NRO_FORDWARD;
       
  
    err_msg  varchar2(255);
    cUsuario char(10) := p_vUsuario;
  
    nCODFWD  NUMBER(20); --CODIGO FORWARD
    nNOMFWD  VARCHAR2(15);
    dFECINI  DATE; --FECHA COMPRA (INICIO)
    dFECVTO  DATE; --FECHA RECOMPRA (VENCIMIENTO)
    nMNTUSD  NUMBER(18, 2); --MONTO USD
    vCODENT  VARCHAR2(50); --CODIGO ENTIDAD      
    vNOMENT  VARCHAR2(50);
    vTIPO    VARCHAR2(10); --TIPO (COMPRA - VENTA)
    vFPAGO   VARCHAR2(20); --FORMA DE PAGO
    nTCFWDS  NUMBER(18, 8); --TC STRIKE = TC FWD
    nTSUSD   NUMBER(18, 14); --TASA USD (AL FIJAR EL PRECIO)
    nTSPEN   NUMBER(18, 14); --TASA PEN (AL FIJAR EL PRECIO)
    nTCSPOT  NUMBER(18, 14); --TIPO DE CAMBIO COMPRA SPOT
    vTIPCUR  VARCHAR2(20); --TIPO CURVA
    vMONEDA  VARCHAR2(10); --MONEDA
    nCorrMax NUMBER(3);
    --nDeal    NUMBER(18);
  begin
    p_vRespuesta := 'N';
    Begin
      Update AQPD103 a set a.aqpd103modif = null;
      commit;
    Exception
      When Others Then
        null;
    End;

    --NUEVO: EN EL PROCEDIMIENTO SE AMBIO EL WHERE POR DEAL  
    begin
      For j in lst_ebs(p_dFecha) Loop
        nCorrMax := null;
        vCODENT  := null;
        nCODFWD  := null;
        dFECINI  := null;
        dFECVTO  := null;
        nMNTUSD  := null;
        vCODENT  := null;
        vTIPO    := null;
        vFPAGO   := null;
        nTCFWDS  := null;
        nTSUSD   := null;
        nTSPEN   := null;
        nTCSPOT  := null;
      
        Begin
          select max(a.aqpd103corre)
            into nCorrMax
            from AQPD103 a
           where a.AQPD103DEAL = j.DEAL_NO;
        Exception
          When Others Then
            nCorrMax := NULL;
            err_msg  := substr(SQLERRM, 1, 255);
            null;
        End;
      
        nCorrMax := nvl(nCorrMax, 0);
        if nCorrMax = 0 Then
          insert into AQPD103
            (AQPD103DEAL,
             AQPD103NFWD,
             AQPD103CODFWD,
             AQPD103FECINI,
             AQPD103FECVTO,
             AQPD103MNTUSD,
             AQPD103ENT,
             AQPD103CODENT,
             AQPD103TIPO,
             AQPD103FPAGO,
             AQPD103TCFWDS,
             AQPD103TSUSD,
             AQPD103TSPEN,
             AQPD103TCSPOT,
             AQPD103TIPCUR,
             AQPD103MONEDA,
             AQPD103USUREG,
             AQPD103ESTREG,
             AQPD103CORRE,
             AQPD103FECREG,
             AQPD103MODIF,
             AQPD103FECPRO, 
             AQPD103FECREP)
          values
            (j.deal_no,
             j.nom_fordward,
             j.NRO_FORDWARD,
             j.fecha_transaccion,
             j.fecha_vencimiento,
             j.monto_transaccion,
             j.nom_entidad,
             j.cod_entidad,
             j.product_type,
             j.forma_de_pago,
             j.tc_strike,
             j.tasa_usd,
             j.tasa_pen,
             j.tc_spot,
             j.calificacion,
             j.moneda,
             cUsuario,
             1,
             (nCorrMax + 1),
             SYSDATE,
             'M',
             p_dFechaPro,
             p_dFecha);
          commit;
        else
          Begin
            select AQPD103NFWD,
                   AQPD103CODFWD,
                   AQPD103FECINI,
                   AQPD103FECVTO,
                   AQPD103MNTUSD,
                   AQPD103ENT,
                   AQPD103CODENT,
                   AQPD103TIPO,
                   AQPD103FPAGO,
                   AQPD103TCFWDS,
                   AQPD103TSUSD,
                   AQPD103TSPEN,
                   AQPD103TCSPOT,
                   AQPD103TIPCUR,
                   AQPD103MONEDA
              into nNOMFWD,
                   nCODFWD,
                   dFECINI,
                   dFECVTO,
                   nMNTUSD,
                   vNOMENT,
                   vCODENT,
                   vTIPO,
                   vFPAGO,
                   nTCFWDS,
                   nTSUSD,
                   nTSPEN,
                   nTCSPOT,
                   vTIPCUR,
                   vMONEDA
              from AQPD103 a
             where a.AQPD103DEAL = j.DEAL_NO
               and a.aqpd103corre = nCorrMax;
          Exception
            When Others Then
              err_msg := substr(SQLERRM, 1, 255);
              null;
          End;
        
          IF nCODFWD <> j.nro_fordward or dFECINI <> j.fecha_transaccion or
             dFECVTO <> j.fecha_vencimiento or
             nMNTUSD <> j.monto_transaccion or vCODENT <> j.cod_entidad or
             vTIPO <> j.product_type or vFPAGO <> j.forma_de_pago or
             nTCFWDS <> j.tc_strike or nTSUSD <> j.tasa_usd or
             nTSPEN <> j.tasa_pen or --nTCSPOT <> j.tc_spot or
             vMONEDA <> j.moneda then
            Begin
              Update AQPD103 a
                 set a.aqpd103estreg = 0
               where a.AQPD103DEAL = j.DEAL_NO;
              commit;
            Exception
              When Others Then
                null;
            End;
          
            Begin
              insert into AQPD103
                (AQPD103DEAL,
                 AQPD103NFWD,
                 AQPD103CODFWD,
                 AQPD103FECINI,
                 AQPD103FECVTO,
                 AQPD103MNTUSD,
                 AQPD103ENT,
                 AQPD103CODENT,
                 AQPD103TIPO,
                 AQPD103FPAGO,
                 AQPD103TCFWDS,
                 AQPD103TSUSD,
                 AQPD103TSPEN,
                 AQPD103TCSPOT,
                 AQPD103TIPCUR,
                 AQPD103MONEDA,
                 AQPD103USUREG,
                 AQPD103ESTREG,
                 AQPD103CORRE,
                 AQPD103FECREG,
                 AQPD103MODIF)
              values
                (j.deal_no,
                 j.nom_fordward,
                 j.NRO_FORDWARD,
                 j.fecha_transaccion,
                 j.fecha_vencimiento,
                 j.monto_transaccion,
                 j.nom_entidad,
                 j.cod_entidad,
                 j.product_type,
                 j.forma_de_pago,
                 j.tc_strike,
                 j.tasa_usd,
                 j.tasa_pen,
                 j.tc_spot,
                 j.calificacion,
                 j.moneda,
                 cUsuario,
                 1,
                 (nCorrMax + 1),
                 SYSDATE,
                 'M');
              commit;
            Exception
              When Others Then
                null;
            End;
          else
            Begin
              Update AQPD103 a
                 set a.aqpd103estreg = 
                     case when a.aqpd103corre = nCorrMax 
                       then 1
                       else 0
                     end
               where a.AQPD103DEAL = j.DEAL_NO;
              commit;
            Exception
              When Others Then
                null;
            End;
          end if;
        End If;
      end loop;
    
      p_vRespuesta := 'S';
    exception
      when others then
        err_msg      := substr(SQLERRM, 1, 255);
        p_vRespuesta := err_msg;
        null;
    end;
  end SP_A8_TRAER_FORWARD;

  ------------------------------------------------------
  procedure SP_A8_LLENAR_COM_VEN(p_dFecha     in date,
                                 p_dFechaPro  in date,
                                 p_nTipCam    in number,
                                 p_vUsuario   in varchar2,
                                 p_vRespuesta out varchar2) is
    err_msg varchar2(255);
    cursor lst_forward(p_fecha in date) is
      select a.*
        from AQPD103 a
       where a.aqpd103estreg = 1
         and p_fecha >= a.AQPD103FECINI
         and AQPD103FECVTO > p_fecha
       order by a.AQPD103TIPCUR, a.aqpd103codfwd;
    --$C$2>=D107;
    --E107>$C$2
  
    cUsuario CHAR(10);
  
    nDIASRES     NUMBER(18);
    nPorRiesEqui NUMBER(18, 4);
    nRieEqu      NUMBER(18);
    vEstado      VARCHAR2(15);
    nPlzOrg      NUMBER(18);
    nTsPEN_P     NUMBER(18, 10);
    nTsUSD_P     NUMBER(18, 10);
    nTcFWDR      NUMBER(18, 5);
    nValActNom   NUMBER(18, 3);
    nTcSBS       NUMBER(18, 8);
    nTcFWDPIP    NUMBER(18, 8);
    nTasaIntC    NUMBER(18, 11);
    nTcFWContra  NUMBER(18, 8);
    nFactor      NUMBER(18, 9);
    nValOpe      NUMBER(18, 2);
    nNomiUSD     NUMBER(18, 3);
    nPosLarga1   NUMBER(18, 2);
    nPosCorta1   NUMBER(18, 2);
    nPosLarga2   NUMBER(18, 2);
    nPosCorta2   NUMBER(18, 2);
    nPosLarga    NUMBER(18, 2);
    nPosCorta    NUMBER(18, 2);
    nTasaUSD2    NUMBER(18, 6);
    nTasaSOL     NUMBER(18, 6);
    nET          NUMBER(18, 6);
    nPosLaPosCo  NUMBER(18, 6);
    nEfecTipCam  NUMBER(18, 2);
    nEfecTasaInt NUMBER(18, 2);
    nNomSoles    NUMBER(18);
    nDeltaPos    NUMBER(18);
  
    vCalif   varchar2(20) := '';
    vRptaPip varchar2(500);
    
    vAnexo varchar2(10) := 'ANEXO8';
    nPeriodo number(10) := to_number(to_char(p_dFechaPro, 'rrrrmm'));
    vParCub  varchar2(30);
    nPorCob  number(18,5);
    vParCubD varchar2(30);
    nEfiCobe Number(18,12);
  begin
    p_vRespuesta := 'N';
    cUsuario     := p_vUsuario;
  
    Begin
      select AQPD102CVA 
      into vParCub
      from aqpd102 p 
      where p.aqpd102anx = vAnexo and p.aqpd102per = nPeriodo and p.aqpd102ctp = 4;
      
      select AQPD102VLN 
      into nPorCob
      from aqpd102 p 
      where p.aqpd102anx = vAnexo and p.aqpd102per = nPeriodo and p.aqpd102ctp = 5;
      
      select AQPD102CVA 
      into vParCubD
      from aqpd102 p 
      where p.aqpd102anx = vAnexo and p.aqpd102per = nPeriodo and p.aqpd102ctp = 6;
    Exception
      When Others Then
        null;
    End;
    
    Begin
      For j in lst_forward(p_dFecha) Loop
        nTcFWDR      := null;
        nRieEqu      := null;
        nDIASRES     := null;
        vEstado      := null;
        nPlzOrg      := null;
        nValActNom   := null;
        nTcSBS       := null;
        nTcFWDPIP    := null;
        nTcFWContra  := null;
        nTasaIntC    := null;
        nFactor      := null;
        nValOpe      := null;
        nPosLarga1   := null;
        nPosCorta1   := null;
        nPosLarga2   := null;
        nPosCorta2   := null;
        nPosLarga    := null;
        nPosCorta    := null;
        nEfecTipCam  := null;
        nEfecTasaInt := null;
        nTasaSOL     := null;
        nET          := null;
        nPosLaPosCo  := null;
        nPorRiesEqui := null;
        nNomiUSD     := null;
        nNomSoles    := null;
        nDeltaPos    := null;
        nTasaUSD2    := null;
        nEfiCobe     := null;
        DBMS_OUTPUT.put_line('nombre: ' || j.aqpd103nfwd);
        if j.AQPD103TIPCUR <> nvl(vCalif, 'X') then
          PQ_CR_REP_ANX_RIES.SP_A8_CURVA_PIP(p_vCalif  => j.AQPD103TIPCUR,
                                             p_vMoneda => 'S',
                                             p_dFecha  => p_dFechaPro, --p_dFecha,
                                             p_nTipCam => p_nTipCam,
                                             p_cUsu    => cUsuario,
                                             p_rpt     => vRptaPip);
          vCalif := j.AQPD103TIPCUR;
        End if;
      
        --Días Restantes => Y
        --=+E107 - $C$2
        nDIASRES := j.aqpd103fecvto - p_dFecha; --p_dFechaPro
      
        --Porcentaje Riesgo Equivalente => AW
        --=+SI(Y107<=0; ""; SI(Y107<=30; 2.5%; SI(Y107<=60; 4%; SI(Y107<=90; 5.25%; SI(Y107<=180; 6.75%; SI(Y107<=360; 9.5%; 12.25%))))))        
        Begin
          Select AQPD102VLP/100
            Into nPorRiesEqui
            From AQPD102
           Where AQPD102PER = nPeriodo
             and AQPD102ANX = vAnexo
             and nDIASRES between AQPD102VLN and AQPD102VLN2;  
        Exception When Others Then
           nPorRiesEqui := 0.1250;
        End;  
        /*        
        If nDIASRES < 0 then
          nPorRiesEqui := 0;
        ElsIf nDIASRES <= 30 then
          nPorRiesEqui := 0.025; --2.5%
        ElsIf nDIASRES <= 60 then
          nPorRiesEqui := 0.040; --4%
        ElsIf nDIASRES <= 90 then
          nPorRiesEqui := 0.0525; --5.25%
        ElsIf nDIASRES <= 180 then
          nPorRiesEqui := 0.0675; --6.75%
        ElsIf nDIASRES <= 360 then
          nPorRiesEqui := 0.0950; --9.5%
        Else
          nPorRiesEqui := 0.1250; --12.25%
        End If;
       */
        --Riesgo equivalente =+C107 * $C$3 * AW107
        nRIEEQU := j.AQPD103MNTUSD * p_nTipCam * nPorRiesEqui;
      
        --Estado => Z
        --=SI(Y($C$2>=D107;E107>$C$2);"Vigente";"No Vigente")
        --If p_dFecha >= j.AQPD103FECINI And j.aqpd103fecvto > p_dFecha Then
        If p_dFechaPro >= j.AQPD103FECINI And j.aqpd103fecvto > p_dFechaPro Then
          vEstado := 'Vigente';
        Else
          vEstado := 'NoVigente';
        End If;
      
        --Plazo Original => AA
        --=E107 - D107
        nPlzOrg := j.aqpd103fecvto - j.AQPD103FECINI;
      
        --TC FWD Riesgo =>  K
        --=+(G120 * ((1 + H120) / (1 + I120)) ^ (AA120 / 360))
        nTsPEN_P := j.AQPD103TSPEN / 100;
        nTsUSD_P := j.AQPD103TSUSD / 100;
        nTcFWDR  := (j.AQPD103TCSPOT *
                    ((1 + nTsPEN_P) / (1 + nTsUSD_P)) ** (nPlzOrg / 360));
      
        --Nominal USD => AX
        --=+SI(C107<>"";C107;"")
        If j.aqpd103mntusd <> 0 Then
          nNomiUSD := j.aqpd103mntusd;
        End If;
      
        --TC Spot SBS => AC
        --=SI(Y107>0;$C$3;"")
        nTcSBS := 0;
        If nDIASRES > 0 Then
          nTcSBS := p_nTipCam;
        End If;
      
        --DBMS_OUTPUT.put_line('nombre: ' || j.aqpd103nfwd);
        --TC Fw PIP (Ajustado a TC  Spot SBS) => AD
        nTcFWDPIP := 0;
        nTasaIntC := 0;
        Begin
          select p.AQPD103PTCSBS --/ 100 -> EN EL UPDATE LE DEJE EL /100
            into nTcFWDPIP
            from AQPD103P p
           where p.aqpd103pclf = j.aqpd103tipcur
             and p.aqpd103pmnd = 'S' --j.aqpd103moneda
             and p.AQPD103PNODO = nDIASRES
             and p.AQPD103PFEC = p_dFechaPro --p_dFecha
             and rownum = 1;
        Exception
          When Others Then
            err_msg   := substr(SQLERRM, 1, 255);
            nTcFWDPIP := 0;
            nTasaIntC := 0;
        End;
      
        --Tasa Interés Contraparte (soles) => AF
        --=+SI(AD107<>"";BUSCARV(Y107;pip_2;2;0);"")
        Begin
          select Round(c.tasa * 100, 9)
            into nTasaIntC
            from dwhouse.fact_ries_curvas_fin@DW c
           where c.calif = j.aqpd103tipcur
             and c.moneda = 'S' --j.aqpd103moneda
             and c.fecha = p_dFechaPro --p_dFecha
             and c.nodo = nDIASRES;
        Exception
          When Others Then
            err_msg   := substr(SQLERRM, 1, 255);
            nTasaIntC := 0;
        End;
        
        --TC Fw Contrato (Strike Price) => AE
        --=+SI(AD107<>"";BUSCARV(AZ107;posicomp;9;0);"")
        If nTcFWDPIP <> 0 Then
          nTcFWContra := j.AQPD103TCFWDS;
        End If;
      
        --Factor => AG
        --SI.ERROR( SI(IZQUIERDA(AZ120;4)="FWDC";
        --*             (AD120-AE120)/
        --*             (1 + AF120 / 100) ^ (Y120/360);
        --             -(AD120-AE120)/
        --              (1 + AF120 / 100) ^ (Y120/360)); "")
        Begin
          nFactor := (nTcFWDPIP - j.AQPD103TCFWDS) /
                     ((1 + nTasaIntC / 100) ** (nDIASRES / 360));
          if UPPER(rtrim(j.aqpd103tipo)) = 'COMPRA' Then
            nFactor := nFactor;
          Else
            nFactor := -nFactor;
          End If;
        Exception
          When Others Then
            nFactor := 0;
        End;
      
        --Valor de la Operación => AH
        --=SI(AG107<>""; AG107*AX107;"")
        nValOpe := 0;
        If nFactor <> 0 Then
          nValOpe := nFactor * nNomiUSD;
        End If;
      
        --Tasa USD => AR
        --=+SI(AD120<>"";BUSCARV(Y120;pip;3;0);"")
        If nTcFWDPIP <> 0 Then
          Begin
            select Round(c.valor * 100, 9)
              into nTasaUSD2
              from dwhouse.fact_ries_curvas@DW c
             where c.tipo = 'CURVA'
               and c.calif = j.aqpd103tipcur
               and c.moneda = 'D'
               and c.fecha = p_dFechaPro --p_dFecha
               and nodo = nDIASRES;
          
          Exception
            When Others Then
              null;
          End;
        End If;

        --Tasa soles => AS
        --=+AF107
        nTasaSOL := nTasaIntC;
              
        --Valor Actual de Nominal (en MN) => AB
        --=SI.ERROR( (AX107 / ( (1 + AR107 / 100) ^ (Y107 / 360) ) ) * $C$3; "")
        Begin
          nValActNom := (nNomiUSD /
                        ((1 + nTasaUSD2 / 100) ** (nDIASRES / 360))) *
                        p_nTipCam;
        Exception
          When Others Then
            nValActNom := 0;
        End;
      
        --Pos. Larga FWDC => AI
        --=SI(Y(Y107<=90;Z107="Vigente");C107/((1+AR107/100)^(Y107/360));"")
        --> EN EL UPDATE SE CAMBIO j.AQPD103TSUSD POR nTasaUSD2
        nPosLarga1 := 0;
        If nDIASRES <= 90 And vEstado = 'Vigente' then
          nPosLarga1 := j.AQPD103MNTUSD /
                        ((1 + nTasaUSD2 / 100) ** (nDIASRES / 360));
        End If;
      
        --Pos. Corta FWDC => AJ
        --=SI(Y(Y107<=90;Z107="Vigente");(C107*AE107)/((1+AS107/100)^(Y107/360));"")
        nPosCorta1 := 0;
        If nDIASRES <= 90 And vEstado = 'Vigente' then
          nPosCorta1 := (j.AQPD103MNTUSD * j.AQPD103TCFWDS) /
                        ((1 + nTasaSOL / 100) ** (nDIASRES / 360));
        End If;
      
        --Pos. Larga FWDC => AK
        --=+SI(Y(Y107<=30;Z107="Vigente");C107;"")
        nPosLarga2 := 0;
        If nDIASRES <= 30 And vEstado = 'Vigente' then
          nPosLarga2 := j.AQPD103MNTUSD;
        End If;
      
        --Pos. Corta FWDC => AL
        --=+SI(Y(Y107<=30;Z107="Vigente");C107*AE107;"")
        nPosCorta2 := 0;
        If nDIASRES <= 30 And vEstado = 'Vigente' then
          nPosCorta2 := j.AQPD103MNTUSD * j.AQPD103TCFWDS;
        End If;
      
        --Pos. Larga FWDC => AN
        --=SI(Z107="Vigente";(C107*AD107)/((1+AF107/100)^(Y107/360));"")
        nPosLarga := 0;
        If vEstado = 'Vigente' then
          nPosLarga := (j.AQPD103MNTUSD * nTcFWDPIP) /
                       ((1 + nTasaIntC / 100) ** (nDIASRES / 360));
        End If;
      
        --Pos. Corta FWDC => AO
        --=SI(Z107="Vigente";(C107*AE107)/((1+AF107/100)^(Y107/360));"")
        nPosCorta := 0;
        If vEstado = 'Vigente' then
          nPosCorta := (j.AQPD103MNTUSD * j.AQPD103TCFWDS) /
                       ((1 + nTasaIntC / 100) ** (nDIASRES / 360));
        End If;
      
        --Efecto tipo de cambio => AP
        --=SI(Z120="Vigente";(C120*(((AC120-G120)*(((1+AS120/100)/(1+AR120/100))^(Y120/360)))/((1+AS120/100)^(Y120/360))));"")
        nEfecTipCam := 0;
        If vEstado = 'Vigente' Then
          nEfecTipCam := (j.AQPD103MNTUSD *
                         (((nTcSBS - j.AQPD103TCSPOT) *
                         (((1 + nTasaIntC / 100) / (1 + nTasaUSD2 / 100)) **
                         (nDIASRES / 360))) /
                         ((1 + nTasaSOL / 100) ** (nDIASRES / 360))));
        End If;
      
        --Efecto tasa de interés => AQ
        --=SI(Z120="Vigente";AH120-AP120;"")
        nEfecTasaInt := 0;
        If vEstado = 'Vigente' Then
          nEfecTasaInt := nValOpe - nEfecTipCam;
        End If;
      
        --ET=ETI+ETC => AT
        --=SI.Error(AP107+AQ107;"")
        Begin
          nET := nEfecTipCam + nEfecTasaInt;
        Exception
          When Others Then
            nET := 0;
        End;
      
        --POS. Lar-POS. Cor => AU
        --=SI.ERROR(AN107-AO107;"")
        Begin
          nPosLaPosCo := nPosLarga - nPosCorta;
        Exception
          When Others Then
            nPosLaPosCo := 0;
        End;
      
        --Nominal Soles => BA
        --=AX107*J107
        nNomSoles := nNomiUSD * j.AQPD103TCFWDS;
      
        --Delta Posición Comprada
        --=SI(Z107="Vigente"; (AX107/(((1+1%)^((E107-$C$2)/360))))*$C$3-BA107/(((1-1%)^((E107-$C$2)/360))); 0)
        nDeltaPos := 0;
        If vEstado = 'Vigente' Then
          /*nDeltaPos := (nNomiUSD / (((1 + 0.01) **
                       ((j.aqpd103fecvto - p_dFecha) / 360)))) * p_nTipCam -
                       nNomSoles /
                       (((1 - 0.01) ** ((j.aqpd103fecvto - p_dFecha) / 360)));*/
          nDeltaPos := (nNomiUSD / (((1 + 0.01) **
                       ((j.aqpd103fecvto - p_dFechaPro) / 360)))) * p_nTipCam -
                       nNomSoles /
                       (((1 - 0.01) ** ((j.aqpd103fecvto - p_dFechaPro) / 360)));
        End If;
        
        -- Resultado Eficacia Cobertura
        nEfiCobe:= dwhouse.PQ_RIES_ANEXOS_REPORTES.FN_A8_EFICACIA_COBERTURA@DW(j.AQPD103DEAL,
                                                                                    j.AQPD103CODFWD,
                                                                                    j.aqpd103tipo,
                                                                                    p_dFechaPro,
                                                                                    j.AQPD103fecini
                                                                                   ); 
                                   
        Begin
          --nuevo: cambie el where por deal
          Update AQPD103
             set AQPD103TCFWDR   = nTcFWDR,
                 AQPD103RIEEQU   = nRieEqu,
                 AQPD103DIARES   = nDIASRES,
                 AQPD103ESTADO   = vEstado,
                 AQPD103PLZORG   = nPlzOrg,
                 AQPD103VANMN    = nValActNom,
                 AQPD103TCSBS    = nTcSBS,
                 AQPD103TCFWDPIP = nTcFWDPIP,
                 AQPD103TCFWC    = nTcFWContra,
                 AQPD103TSINTC   = nTasaIntC,
                 AQPD103FAC      = nFactor,
                 AQPD103VALOPE   = nValOpe,
                 AQPD103PLFWD1   = nPosLarga1,
                 AQPD103PCFWD1   = nPosCorta1,
                 AQPD103PLFWD2   = nPosLarga2,
                 AQPD103PCFWD2   = nPosCorta2,
                 AQPD103PLFWDC   = nPosLarga,
                 AQPD103PCFWDC   = nPosCorta,
                 AQPD103EFECTC   = nEfecTipCam,
                 AQPD103EFECTI   = nEfecTasaInt,
                 AQPD103TSSOL    = nTasaSOL,
                 AQPD103ET       = nET,
                 AQPD103PLPC     = nPosLaPosCo,
                 AQPD103PORRE    = nPorRiesEqui,
                 AQPD103NOMUSD   = nNomiUSD,
                 AQPD103NOMSOL   = nNomSoles,
                 AQPD103DELPOS   = nDeltaPos,
                 AQPD103TSUSD2   = nTasaUSD2,
                 AQPD103PARCUB   = vParCub, --NUEVO: 20240821
                 AQPD103PORCOB   = nPorCob, --NUEVO: 20240818
                 AQPD103PARCUBD  = vParCubD, --NUEVO: 20240821
                 AQPD103PCFINI   = j.AQPD103FECINI, --NUEVO: 20240821
                 AQPD103PCFFIN   = j.AQPD103FECVTO, --NUEVO: 20240821
                 AQPD103EFICOB   = nEfiCobe
                 --AQPD103EFICOB   = dwhouse.PQ_RIES_ANEXOS_REPORTES.FN_A8_EFICACIA_COBERTURA@dw(j.AQPD103DEAL,  --NUEVO: 20240818
                 --                                                                              j.AQPD103CODFWD, 
                 --                                                                              j.aqpd103tipo)
           where aqpd103estreg = 1
             and AQPD103DEAL = j.AQPD103DEAL;
          commit;
        exception
          when others then
            null;
        end;
      END LOOP;
    
      p_vRespuesta := 'S';
    exception
      when others then
        p_vRespuesta := 'E';
        err_msg      := substr(SQLERRM, 1, 255);
        null;
    end;
  
  end SP_A8_LLENAR_COM_VEN;

  ------------------------------------------------------
  procedure SP_A8_VALORIZACION(p_dFecha     in date,
                               p_vUsuario   in varchar2,
                               p_vRespuesta out varchar2) 
  -- Fecha: 2025.03.10
  -- Autor: Paola Vargas
  -- Cambio: Se agregaron datos calculado en la valorización 
  --         para los anexos 15
  is
    dFecha      date := sysdate;
    cUsuario    CHAR(10) := rtrim(p_vUsuario);
    p_nTipCam   number;
    
  begin
    p_vRespuesta := 'N';
    
    p_nTipCam := PQ_CR_REP_ANX_RIES.fn_tipo_cambio_fijo(P_FECHA => p_dFecha);    
    
    Begin
      Delete from AQPD103V where AQPD103VFECHA = p_dFecha;
      commit;
    exception
      when others then
        null;
    end;
    
    Begin
         INSERT INTO AQPD103V
            (AQPD103VNFWD, AQPD103VCODFWD, AQPD103VFECINI, AQPD103VFECVTO,
             AQPD103VDIARES, AQPD103VMNTUSD, AQPD103VVANMN, AQPD103VTCSPOSBS,
             AQPD103VTCFWDPIP,AQPD103VTCFWC, AQPD103VTSINTC,AQPD103VFAC,
             AQPD103VVALOPE,AQPD103VENT,AQPD103VFECHA, AQPD103VFECR,
             AQPD103VUSER,
             --------------
             AQPD103VPL1, AQPD103VPC1,AQPD103VPL2, AQPD103VPC2, 
             AQPD103VPL , AQPD103VPC ,AQPD103VTSL, AQPD103VPLPC,
             AQPD103VREQ, AQPD103VTCU,AQPD103VTUS2,AQPD103VTCF,
             --------------
             aqpd103vcodent, aqpd103vpor,aqpd103vcomp1,
             aqpd103vresul1,aqpd103vcomp2      
            )
        SELECT a.aqpd103nfwd,a.aqpd103codfwd,a.aqpd103fecini,a.aqpd103fecvto,
               a.aqpd103diares,a.aqpd103mntusd,a.aqpd103vanmn,p_nTipCam,
               a.aqpd103tcfwdpip,a.aqpd103tcfwc,a.aqpd103tsintc,a.aqpd103fac,
               a.aqpd103valope,a.aqpd103ent,p_dFecha,dFecha,cUsuario,
               ---------
               a.aqpd103plfwd1,a.aqpd103pcfwd1,a.aqpd103plfwd2,a.aqpd103pcfwd2,
               a.aqpd103plfwdc,a.aqpd103pcfwdc,a.aqpd103tssol,a.aqpd103plpc,
               a.aqpd103porre,a.aqpd103tipcur,a.aqpd103tsusd2, a.aqpd103tcfwdr,
               a.AQPD103CODENT,a.aqpd103porre,
               (case when a.aqpd103valope < 0 then 0 else a.aqpd103valope end),
               a.aqpd103mntusd * a.aqpd103porre,  
               (a.aqpd103mntusd * a.aqpd103porre) * p_nTipCam            
            FROM aqpd103 a
           where a.aqpd103estreg = 1
             and p_dFecha >= a.aqpd103fecini
             and a.aqpd103fecvto > p_dFecha;
      commit;
      
      p_vRespuesta := 'S';
      
      Begin
          -- Actualiza el Total
          Update AQPD103V 
             set aqpd103vtotal = nvl(aqpd103vcomp1,0) + nvl(aqpd103vcomp2,0)
           Where AQPD103VFECHA = p_dFecha;  
          Commit;       
      Exception When Others Then
          p_vRespuesta := 'E';
      End;    
      
    Exception when others then
        p_vRespuesta := 'E';
    end;
  

  End SP_A8_VALORIZACION;

  ------------------------------------------------------
  procedure SP_A8_CURVA_PIP(p_vCalif  in varchar2,
                            p_vMoneda in varchar2,
                            p_dFecha  in date,
                            p_nTipCam in number,
                            p_cUsu    in char,
                            p_rpt     out varchar2) is
    nTipCam  number;
    ERR_msg varchar2(250);
  begin
    p_rpt   := 'N';
    
    --> NUEVO: CAMBIO p_nTipCam POR fn_tipo_cambio
    nTipCam := PQ_CR_REP_ANX_RIES.FN_TIPO_CAMBIO_FIJO(P_FECHA => p_dFecha);
    --nTipCam := nTipCam * 100; PROBAR
  
    Begin
      delete from AQPD103P p
       where p.aqpd103pclf = p_vCalif
         and p.aqpd103pmnd = p_vMoneda
         and p.aqpd103puser = p_cUsu;
      commit;
    exception
      when others then
        null;
    end;
    
    Begin
      insert into AQPD103P
      (AQPD103PCLF, AQPD103PMND, AQPD103PFEC, AQPD103PNODO, 
      AQPD103PDIF, 
      AQPD103PTCSBS, AQPD103PUSER)
      select
      z.calif, z.moneda, z.fecha, z.nodo,
      z.diferencial,
      case when z.nodo = 0 then nTipCam else (z.DIFERENCIAL * nTipCam) end valorFinal
      , p_cUsu
      from (
        select p_vCalif calif, p_vMoneda moneda, a.fecha, a.nodo, 
         a.valor "Curva FWD PIP",
         case when a.nodo = 0 then null
           else (a.valor /
                 (select x.valor from dwhouse.fact_ries_curvas@DW x where x.tipo = a.tipo and x.fecha = a.fecha and x.nodo = 0)) 
         end Diferencial
        from dwhouse.fact_ries_curvas@dw a
        left join dwhouse.fact_ries_curvas@dw b
         on b.tipo = 'CURVA'
        and b.calif = p_vCalif
        and b.moneda = p_vCalif
        and b.fecha = a.fecha
        and b.nodo = a.nodo
        where a.tipo = 'TCFWD'
        and a.fecha = p_dFecha
        order by a.nodo
      ) z;
      
      /*
      select
      z.calif, z.moneda, z.fecha, z.nodo,
      round(z.diferencial,9) diferencial,
      case when z.nodo = 0 then nTipCam else round((z.DIFERENCIAL * nTipCam), 7) end valorFinal, p_cUsu
      from (
        select
          b.calif, b.moneda, b.fecha, b.nodo, 
          (b.valor * 100) valorCurva,
          (a.valor * 100) valorFWD, 
          (case when a.nodo = 0 then null else a.valor end /
          (select x.valor from dwhouse.fact_ries_curvas@DW x where x.tipo = a.tipo and x.fecha = a.fecha and x.nodo = 0)) diferencial
        from dwhouse.fact_ries_curvas@dw a
        left join dwhouse.fact_ries_curvas@dw b
             on b.tipo = 'CURVA'
            and b.calif = p_vCalif --'AAA'
            and b.moneda = p_vMoneda --'S'
            and b.fecha = a.fecha
            and b.nodo = a.nodo
            where a.tipo = 'TCFWD'
            and a.fecha = p_dFecha --to_date('20240531','rrrrmmdd')
        order by b.nodo
        ) z;
      */
      commit;
      p_rpt := 'S';
    exception
      when others then
        err_msg := substr(SQLERRM, 1, 255);
        null;
    end;
  
  end SP_A8_CURVA_PIP;

  ------------------------------------------------------
  procedure SP_A8_REPORTE(p_dFecha     in date,
                          p_dFechaPro  in date,
                          p_vUsuario   in varchar2,
                          p_vRespuesta out varchar2) is
    err_msg   varchar2(255);
    p_nTipCam NUMBER;
    cUsuario  CHAR(10);
  begin
    p_vRespuesta := 'N';
    cUsuario     := p_vUsuario;
  
    p_nTipCam := PQ_CR_REP_ANX_RIES.FN_TIPO_CAMBIO_FIJO(P_FECHA => p_dFecha);
  
    Begin
      Delete from aqpd103f where aqpd103ffecha = p_dFecha;
      commit;
    exception
      when others then
        err_msg := substr(SQLERRM, 1, 255);
        null;
    end;
  
    Begin
      insert into aqpd103f
        (aqpd103fctacon, aqpd103ftipo, 
         aqpd103fnfwd, aqpd103fcodfwd, aqpd103fsldcon,
         aqpd103fmoneda, aqpd103fmntnom, aqpd103fplvalm, aqpd103fdrmapl, 
         aqpd103fdrmopl,
         aqpd103fpcvalm, aqpd103fdrmapc, 
         aqpd103fdrmopc, 
         aqpd103fcmoen1, aqpd103fcmore1, aqpd103ffecini, aqpd103ffecvto, aqpd103fent, aqpd103fcodent, 
         aqpd103freside, aqpd103fpais, aqpd103fdoc, aqpd103ffinan, aqpd103fcodsbs, aqpd103fcoddeu,
         aqpd103fponven, aqpd103fconven, 
         aqpd103fini, aqpd103fcie, aqpd103fticapa, aqpd103fpotsin, 
         aqpd103fpotica, aqpd103ftot, aqpd103fintcon, aqpd103fparcub,
         aqpd103fporcob, aqpd103feficob, aqpd103ffpago, 
         aqpd103fnmoent2, aqpd103fnmorec2,
         aqpd103fnmoent3, aqpd103fnmorec3, 
         aqpd103ffecha, aqpd103ffecgen, aqpd103fusugen,
         AQPD103FFECPRO)
        select 
         decode(a.aqpd103tipo, 'COMPRA', '7206.01.02.01', '7206.01.02.02') "A",
         decode(a.aqpd103tipo, 'COMPRA', 'Compra Forwards', 'Venta Forwards') "B",
         a.aqpd103nfwd "D", a.aqpd103codfwd "D-2", (a.aqpd103mntusd * p_nTipCam) "E",
         'USD' "F", a.aqpd103mntusd "G", a.aqpd103plfwdc "H", ((a.aqpd103fecvto - p_dFecha) / 360) "I",
         ((a.aqpd103fecvto - p_dFecha) / 360) / (1 + (case when a.aqpd103tipo = 'COMPRA' then (a.aqpd103tsusd2 / 100) --=> "AO"
                                                      else (a.aqpd103tssol / 100) end)) "J",
         a.aqpd103pcfwdc "K", ((a.aqpd103fecvto - p_dFecha) / 360) "L",
         ((a.aqpd103fecvto - p_dFecha) / 360) / (1 + (case when a.aqpd103tipo = 'COMPRA' then (a.aqpd103tssol / 100) --=> "AN"
                                                      else (a.aqpd103tsusd2 / 100) end)) "M",
         'PEN' "N", 'USD' "O", a.aqpd103fecini "P", a.aqpd103fecvto "Q", upper(a.aqpd103ent) "R", a.aqpd103codent "R2",
         PQ_CR_REP_ANX_RIES.FN_RESIDENTE_ENT_FINAN(pv_CodEnt => a.aqpd103codent,
                                                   pn_Fecha  => p_dFecha) "S",
         PQ_CR_REP_ANX_RIES.FN_PAIS_ENT_FINAN(pv_CodEnt => a.aqpd103codent,
                                              pn_Fecha  => p_dFecha) "T",
         PQ_CR_REP_ANX_RIES.FN_DOCUMENTO_ENT_FINAN(pv_CodEnt => a.aqpd103codent,
                                                   pn_Fecha  => p_dFecha) "U",
         PQ_CR_REP_ANX_RIES.FN_FINANCIERO_ENT_FINAN(pv_CodEnt => a.aqpd103codent,
                                                    pn_Fecha  => p_dFecha) "V",
         PQ_CR_REP_ANX_RIES.FN_COD_SBS_ENT_FINAN(pv_CodEnt => a.aqpd103codent,
                                                 pn_Fecha  => p_dFecha) "W",
         PQ_CR_REP_ANX_RIES.FN_CUENTA_ENT_FINAN(pv_CodEnt => a.aqpd103codent,
                                                pn_Fecha  => p_dFecha) "X",
         a.aqpd103porre "Y",
         PQ_CR_REP_ANX_RIES.FN_CONVENIO_ENT_FINAN(pv_CodEnt => a.aqpd103codent,
                                                  pn_Fecha  => p_dFecha) "Z",
         a.aqpd103tcspot "AA", p_nTipCam "AB", a.aqpd103tcfwds "AC", a.aqpd103efecti "AD",
         a.aqpd103efectc "AE", a.aqpd103valope "AF", 'CC' "AG", a.aqpd103parcub "AH",
         a.aqpd103porcob "AI", a.aqpd103eficob "AJ", a.aqpd103fpago "AK", 
         a.aqpd103tspen / 100 "AL", a.aqpd103tsusd / 100 "AM",
         case when a.aqpd103tipo = 'COMPRA' then (a.aqpd103tssol / 100) else (a.aqpd103tsusd2 / 100) end "AN",
         case when a.aqpd103tipo = 'COMPRA' then (a.aqpd103tsusd2 / 100) else (a.aqpd103tssol / 100) end "AO",
         p_dFecha, sysdate, cUsuario,
         p_dFechaPro
          from aqpd103 a
         where a.aqpd103estreg = 1
           and p_dFecha >= a.aqpd103fecini
           and a.aqpd103fecvto > p_dFecha;
    
      commit;
      p_vRespuesta := 'S';
    exception
      when others then
        p_vRespuesta := 'E';
        err_msg      := substr(SQLERRM, 1, 255);
        null;
    end;
  
  end SP_A8_REPORTE;

  ------------------------------------------------------
  --nuevo: nuevo
  procedure SP_A8_ACTUALIZAR_FWD(p_dFecha     in date,
                                 p_vUsuario   in varchar2,
                                 p_vRespuesta out varchar2) is
    cursor cur_validar_calif(p_periodo in number) is
      select p.aqpd102cva calif, p.aqpd102val moneda
      from aqpd102 p
      where p.aqpd102anx = 'ANEXO8'
      and p.aqpd102per = p_periodo
      and p.aqpd102ctp = 7
      and nvl(p.aqpd102val, 'S') = 'S'
      and p.AQPD102VLN = 1;
      
    dFechaProcess date := p_dFecha;
    p_nTipCam NUMBER;
    cUsuario  CHAR(10);
    contador  NUMBER(1);
    cFecha varchar2(10) := to_char(p_dFecha,'yyyymmdd');
    nPeriodoAct number(9) := to_char(p_dFecha,'yyyymm');
    nPeriodoAnt number(9) := to_char(p_dFecha,'yyyymm');
    vCurvasComp varchar2(1) := 'S';
  begin
    p_vRespuesta := 'N';
    cUsuario     := p_vUsuario;
   
    for i in cur_validar_calif(nPeriodoAct) loop
      begin
        if i.calif = 'TC' OR i.calif = 'TCFWD' then
          select 'S'
            into vCurvasComp
          from dwhouse.fact_ries_curvas@dw c
          where c.tipo = i.calif
          and c.fecha = p_dFecha
          fetch next 1 rows only;
        else 
          select 'S'
            into vCurvasComp
          from dwhouse.fact_ries_curvas@dw c
          where c.calif = i.calif
          and c.moneda = i.moneda
          and c.fecha = p_dFecha
          fetch next 1 rows only;
        end if;
        commit;
      exception
        when others then
          vCurvasComp := 'N';
      end;
      exit when vCurvasComp = 'N';
    End loop;
    
    if vCurvasComp = 'S' then
    Begin
      select 1 into contador
      from dwhouse.fact_ries_curvas@DW
      where fecha = p_dFecha
      and rownum = 1;
    exception
      when others then
        null;
    end;
    
    if contador is null then 
       Begin
         Select max(fecha) into dFechaProcess
           From dwhouse.fact_ries_curvas@DW
          where fecha between add_months(p_dFecha,-15) and p_dFecha;
       Exception When others then
          null;
       End;
    end if;
   
    p_nTipCam := PQ_CR_REP_ANX_RIES.FN_TIPO_CAMBIO_FIJO(P_FECHA => p_dFecha);

    Begin
      --DWHOUSE.PQ_RIES_ANEXOS_REPORTES.PR_A8_GEN_CURVAS_JOB@DW(pcFecha => cFecha);
      DWHOUSE.PQ_RIES_ANEXOS_REPORTES.PR_A8_GEN_CURVAS_JOB_FECHA@DW(pcFecha => cFecha);
    exception
      when others then
        p_vRespuesta := substr(SQLERRM, 1, 255);
    end;

    contador := null;
    Begin
      select 1
      into contador
      from aqpd102 p
      where p.aqpd102anx = 'ANEXO8'
      and p.aqpd102per = nPeriodoAct
      and rownum = 1;
    exception
      when others then
        nPeriodoAnt := to_char(add_months(p_dFecha, -1), 'yyyymm');
        null;
    end;
    
    if contador is null then
      begin
        insert into aqpd102
        (aqpd102per, aqpd102anx, aqpd102ctp, aqpd102dtp, aqpd102cor, aqpd102cva, aqpd102val, aqpd102vln, aqpd102vlp, aqpd102vde, aqpd102dfe, aqpd102hoj, aqpd102ca1, aqpd102ca2, aqpd102ca3, aqpd102wh1, aqpd102ca4, aqpd102ca5, aqpd102ca6, aqpd102ca7, aqpd102ca8, aqpd102ca9, aqpd102ca10, aqpd102ca11, aqpd102ca12, aqpd102ca13, aqpd102ca14, aqpd102ca141, aqpd102ca15, aqpd102ca16, aqpd102ca17, aqpd102cvl1, aqpd102cvl2, aqpd102cvl3, aqpd102crep, aqpd102rpc1, aqpd102rpc2, aqpd102csbs, aqpd102usra, aqpd102feca, aqpd102hora, aqpd102aux1, aqpd102aux2, aqpd102aux3, aqpd102aux4, aqpd102aux5)
        select
        nPeriodoAct, AQPD102ANX, AQPD102CTP, AQPD102DTP, AQPD102COR, AQPD102CVA, AQPD102VAL, AQPD102VLN, AQPD102VLP, AQPD102VDE, AQPD102DFE, AQPD102HOJ, AQPD102CA1, AQPD102CA2, AQPD102CA3, AQPD102WH1, AQPD102CA4, AQPD102CA5, AQPD102CA6, AQPD102CA7, AQPD102CA8, AQPD102CA9, AQPD102CA10, AQPD102CA11, AQPD102CA12, AQPD102CA13, AQPD102CA14, AQPD102CA141, AQPD102CA15, AQPD102CA16, AQPD102CA17, AQPD102CVL1, AQPD102CVL2, AQPD102CVL3, AQPD102CREP, AQPD102RPC1, AQPD102RPC2, AQPD102CSBS, AQPD102USRA, AQPD102FECA, AQPD102HORA, AQPD102AUX1, AQPD102AUX2, AQPD102AUX3, AQPD102AUX4, AQPD102AUX5
        from aqpd102 p
        where p.aqpd102anx = 'ANEXO8'
        and p.aqpd102per = nPeriodoAnt;
      exception
        when others then
          null;
      end;
    end if;
  
    Begin
      PQ_CR_REP_ANX_RIES.SP_A8_TRAER_FWD_TODO(pdfecha      => p_dFecha,
                                              pdfechaPro   => dFechaProcess,
                                              p_vUsuario   => cUsuario,
                                              p_vRespuesta => p_vRespuesta);
      if p_vRespuesta = 'S' then
        p_vRespuesta := null;
        PQ_CR_REP_ANX_RIES.SP_A8_TRAER_FORWARD(p_dFecha     => p_dFecha,
                                               p_dFechaPro  => dFechaProcess,
                                               p_vUsuario   => cUsuario,
                                               p_vRespuesta => p_vRespuesta);
        if p_vRespuesta = 'S' then
          p_vRespuesta := null;
          PQ_CR_REP_ANX_RIES.SP_A8_LLENAR_COM_VEN(p_dFecha     => p_dFecha,
                                                  p_dFechaPro  => dFechaProcess,
                                                  p_nTipCam    => p_nTipCam,
                                                  p_vUsuario   => cUsuario,
                                                  p_vRespuesta => p_vRespuesta);
        end if;
      end if;
    exception
      when others then
        p_vRespuesta := substr(SQLERRM, 1, 255);
    end;
    else
      p_vRespuesta := 'C';
    end if;
  end SP_A8_ACTUALIZAR_FWD;
  
  ------------------------------------------------------
  procedure SP_A8_GENERAR(p_dFecha     in date,
                          p_vUsuario   in varchar2,
                          p_vRespuesta out varchar2) is
    dFechaProcess date := p_dFecha;
    p_nTipCam NUMBER;
    cUsuario  CHAR(10);
    contador  NUMBER(1);
    cFecha number(9) := to_char(p_dFecha,'yyyymmdd');
    nPeriodoAct number(9) := to_char(p_dFecha,'yyyymm');
    nPeriodoAnt number(9) := to_char(p_dFecha,'yyyymm');
    --nCountCurvas number(1);
  begin
    p_vRespuesta := 'N';
    cUsuario     := p_vUsuario;
   
    Begin
      select 1 into contador
      from dwhouse.fact_ries_curvas@DW
      where fecha = p_dFecha
      and rownum = 1;
    exception
      when others then
        null;
    end;
    
    If contador is null then 
      Begin
         Select max(fecha) into dFechaProcess
           From dwhouse.fact_ries_curvas@DW
          where fecha between add_months(p_dFecha,-15) and p_dFecha;
       Exception When others then
          null;
       End;
    End if;
   
    p_nTipCam := PQ_CR_REP_ANX_RIES.FN_TIPO_CAMBIO_FIJO(P_FECHA => p_dFecha);
    
    Begin
      --DWHOUSE.PQ_RIES_ANEXOS_REPORTES.PR_A8_GEN_CURVAS_JOB@DW(pcFecha => cFecha);
      DWHOUSE.PQ_RIES_ANEXOS_REPORTES.PR_A8_GEN_CURVAS_JOB_FECHA@DW(pcFecha => cFecha);
    exception
      when others then
        p_vRespuesta := substr(SQLERRM, 1, 255);
    end;
    
    contador := null;
    Begin
      select 1
      into contador
      from aqpd102 p
      where p.aqpd102anx = 'ANEXO8'
      and p.aqpd102per = nPeriodoAct
      and rownum = 1;
    exception
      when others then
        nPeriodoAnt := to_char(add_months(p_dFecha, -1), 'yyyymm');
        null;
    end;
    
    if contador is null then
      begin
        insert into aqpd102
        (aqpd102per, aqpd102anx, aqpd102ctp, aqpd102dtp, aqpd102cor, aqpd102cva, aqpd102val, aqpd102vln, aqpd102vlp, aqpd102vde, aqpd102dfe, aqpd102hoj, aqpd102ca1, aqpd102ca2, aqpd102ca3, aqpd102wh1, aqpd102ca4, aqpd102ca5, aqpd102ca6, aqpd102ca7, aqpd102ca8, aqpd102ca9, aqpd102ca10, aqpd102ca11, aqpd102ca12, aqpd102ca13, aqpd102ca14, aqpd102ca141, aqpd102ca15, aqpd102ca16, aqpd102ca17, aqpd102cvl1, aqpd102cvl2, aqpd102cvl3, aqpd102crep, aqpd102rpc1, aqpd102rpc2, aqpd102csbs, aqpd102usra, aqpd102feca, aqpd102hora, aqpd102aux1, aqpd102aux2, aqpd102aux3, aqpd102aux4, aqpd102aux5)
        select
        nPeriodoAct, AQPD102ANX, AQPD102CTP, AQPD102DTP, AQPD102COR, AQPD102CVA, AQPD102VAL, AQPD102VLN, AQPD102VLP, AQPD102VDE, AQPD102DFE, AQPD102HOJ, AQPD102CA1, AQPD102CA2, AQPD102CA3, AQPD102WH1, AQPD102CA4, AQPD102CA5, AQPD102CA6, AQPD102CA7, AQPD102CA8, AQPD102CA9, AQPD102CA10, AQPD102CA11, AQPD102CA12, AQPD102CA13, AQPD102CA14, AQPD102CA141, AQPD102CA15, AQPD102CA16, AQPD102CA17, AQPD102CVL1, AQPD102CVL2, AQPD102CVL3, AQPD102CREP, AQPD102RPC1, AQPD102RPC2, AQPD102CSBS, AQPD102USRA, AQPD102FECA, AQPD102HORA, AQPD102AUX1, AQPD102AUX2, AQPD102AUX3, AQPD102AUX4, AQPD102AUX5
        from aqpd102 p
        where p.aqpd102anx = 'ANEXO8'
        and p.aqpd102per = nPeriodoAnt;
      exception
        when others then
          null;
      end;
    end if;
  
    Begin
      --nuevo: solamente se llenan datos 
      p_vRespuesta := null;
      PQ_CR_REP_ANX_RIES.SP_A8_LLENAR_COM_VEN(p_dFecha     => p_dFecha,
                                              p_dFechaPro  => dFechaProcess,
                                              p_nTipCam    => p_nTipCam,
                                              p_vUsuario   => cUsuario,
                                              p_vRespuesta => p_vRespuesta);
      if p_vRespuesta = 'S' then
        p_vRespuesta := null;
        PQ_CR_REP_ANX_RIES.SP_A8_REPORTE(p_dFecha     => p_dFecha,
                                         p_dFechaPro  => dFechaProcess,
                                         p_vUsuario   => cUsuario,
                                         p_vRespuesta => p_vRespuesta);
      end if;
    exception
      when others then
        p_vRespuesta := substr(SQLERRM, 1, 255);
    end;
  
  end SP_A8_GENERAR;
   
  ------------------------------------------------------
  procedure PR_A8_PRUEBAS(pc_tipo_prueba  in varchar2,
                          pd_fecha        in date,
                          pn_escenarios   in number, --Q1 / I1
                          pn_orden        in varchar2, --T1
                          pn_sent_regre   in varchar2, --W1
                          pn_nominal_usd  in number, --Q4
                          pd_fecha_inicio in date, --Q5
                          pd_fecha_vcto   in date, --Q6
                          pc_tipo         in varchar2, --Q7
                          pc_categoria    in varchar2, --Q8
                          pn_cod_fwd      in number, --Q9
                          pn_nom_fwd      in varchar2, --Q9
                          pc_moneda       in varchar2,
                          pn_strike       in number, --retrospectiva --Q9
                          pn_Sld_Cub_usd  in number, --U4
                          pd_par_fec_ini  in date, --U5
                          pd_par_fec_vcto in date, --U6
                          pn_TasaRend     in number, --U7
                          pn_Pendiente    out number,
                          pn_R2           out number,
                          pv_res_cober    out varchar2,
                          pv_Respuesta    out varchar2,
                          pv_respuesta1   out varchar2,
                          pv_respuesta2   out varchar2,
                          pv_respuesta3   out varchar2) is
    err_msg varchar2(255);
  begin
    pv_Respuesta := 'N';
    Begin
      DWHOUSE.PQ_RIES_ANEXOS_REPORTES.PR_A8_PRUEBAS_P1@DW(pc_tipo_prueba  => pc_tipo_prueba,
                                                               pd_fecha        => pd_fecha,
                                                               pn_escenarios   => pn_escenarios, --Q1 / I1
                                                               pd_fecha_inicio => pd_fecha_inicio,
                                                               pd_fecha_vcto   => pd_fecha_vcto,
                                                               pc_tipo         => pc_tipo,
                                                               pc_categoria    => pc_categoria,
                                                               pn_cod_fwd      => pn_cod_fwd,
                                                               pn_nom_fwd      => pn_nom_fwd,
                                                               pc_moneda       => pc_moneda,
                                                               pv_respuesta_p1 => pv_respuesta1);
      COMMIT;
      DWHOUSE.PQ_RIES_ANEXOS_REPORTES.PR_A8_PRUEBAS_P2@DW(pc_tipo_prueba  => pc_tipo_prueba,
                                                               pd_fecha        => pd_fecha,
                                                               pd_fecha_inicio => pd_fecha_inicio,
                                                               pd_fecha_vcto   => pd_fecha_vcto,
                                                               pn_nominal_usd  => pn_nominal_usd,
                                                               pc_tipo         => pc_tipo,
                                                               pc_categoria    => pc_categoria,
                                                               pn_cod_fwd      => pn_cod_fwd,
                                                               pc_moneda       => pc_moneda,
                                                               pn_strike       => pn_strike,
                                                               pn_Sld_Cub_usd  => pn_Sld_Cub_usd,
                                                               pn_TasaRend     => pn_TasaRend,
                                                               pv_respuesta_p2 => pv_respuesta2);
      COMMIT;
      DWHOUSE.PQ_RIES_ANEXOS_REPORTES.PR_A8_PRUEBAS_REG@DW(pc_tipo_prueba  => pc_tipo_prueba,
                                                                pd_fecha        => pd_fecha,
                                                                pn_sent_regre   => pn_sent_regre,
                                                                pc_tipo         => pc_tipo,
                                                                pn_cod_fwd      => pn_cod_fwd,
                                                                pn_nom_fwd      => pn_nom_fwd,
                                                                pn_Pendiente    => pn_Pendiente,
                                                                pn_R2           => pn_R2,
                                                                pv_res_cober    => pv_res_cober,
                                                                pv_respuesta_rg => pv_respuesta3);
    
      COMMIT;
      pv_Respuesta := 'S';
    exception
      when others then
        err_msg      := substr(SQLERRM, 1, 255);
        pv_Respuesta := err_msg;
        null;
    end;
  end PR_A8_PRUEBAS;
  
  ------------------------------------------------------
  procedure PR_A8_TRAER_CURVA(pv_tipoCurva in varchar2,
                              pv_calif     in varchar2,
                              pv_moneda    in varchar2,
                              pd_fecIni    in date,
                              pd_fecFin    in date,
                              pv_usuario   in varchar2,
                              pv_rpta      out varchar2) is
    err_msg  varchar2(255);
    --cUsuario char(10) := pv_usuario;
  begin
    pv_rpta := 'N';
  
    Begin
      EXECUTE IMMEDIATE 'TRUNCATE TABLE aqpd103d';
      pv_rpta := 'S';
    exception
      when others then
        err_msg := substr(SQLERRM, 1, 255);
        pv_rpta := err_msg;
        null;
    end;
  
    Begin
      if pv_tipoCurva = 'TC' OR pv_tipoCurva = 'TCFWD' then
        INSERT INTO AQPD103D
          (AQPD103DTIP, AQPD103DCAL, AQPD103DMON, AQPD103DFEC,
           AQPD103DNOD, AQPD103DVAL, AQPD103DUSU)
          SELECT DISTINCT TIPO, nvl(CALIF, '-'), nvl(MONEDA, '-'), FECHA, 
            nvl(NODO, 0), VALOR, pv_usuario
            FROM dwhouse.fact_ries_curvas@DW c
           where c.tipo = pv_tipoCurva
             and c.fecha between pd_fecIni and pd_fecFin;
      else
        INSERT INTO AQPD103D
          (AQPD103DTIP, AQPD103DCAL, AQPD103DMON, AQPD103DFEC,
           AQPD103DNOD, AQPD103DVAL, AQPD103DUSU)
          SELECT DISTINCT TIPO, nvl(CALIF, '-'), MONEDA, FECHA, 
            NODO, VALOR, pv_usuario
            FROM dwhouse.fact_ries_curvas@DW c
           where c.tipo = pv_tipoCurva
             and c.calif = pv_calif
             and c.moneda = pv_moneda
             and c.fecha between pd_fecIni and pd_fecFin;
      end if;
      commit;
      pv_rpta := 'S';
    exception
      when others then
        err_msg := substr(SQLERRM, 1, 255);
        pv_rpta := err_msg;
        null;
    end;
  
  end PR_A8_TRAER_CURVA;

  ------------------------------------------------------
  procedure PR_A8_UPDATE_CURVA(pv_tipo in varchar2,
                               pv_calif     in varchar2,
                               pv_moneda    in varchar2,
                               pd_fecha     in date,
                               pn_nodo      in number,
                               pv_valor     in varchar2,
                               pv_rpta      out varchar2) is
    err_msg varchar2(255);
    vTipo varchar2(10) := pv_tipo;
    vCalif varchar2(10) := pv_calif;
    vMoneda varchar2(10) := pv_moneda;
    dFecha date := pd_fecha;
    nNodo number(18) := pn_nodo;
    vValor varchar2(100) := pv_valor;
    nValor number(18,12);
    
    nContador number(18);
  begin
    pv_rpta := 'N';
    --NUEVO: SE REFINO LA CONSULTA
    if vValor = 'X' then
      nValor := null;
    else 
      begin
        nValor := TO_NUMBER(vValor);
      exception 
        when value_error then
          vValor := replace(vValor, '.', ',');
          nValor := TO_NUMBER(vValor);
      end;
    end if;

    if vTipo not in ('TC', 'TCFWD') and nNodo = 0 then
      nValor := null;
    end if;
    
    Begin
      if vTipo = 'TC' then
        select 1
        into nContador
        from dwhouse.FACT_RIES_CURVAS@DW
        where tipo = vTipo
        and fecha = dFecha
        and nodo = nNodo;
      elsif vTipo = 'TCFWD' then
        select 1
        into nContador
        from dwhouse.FACT_RIES_CURVAS@DW
        where tipo = vTipo
        and moneda = 'S'
        and fecha = dFecha
        and nodo = nNodo;
      else
        select 1
        into nContador
        from dwhouse.FACT_RIES_CURVAS@DW
        where tipo = vTipo
        and calif = vCalif
        and moneda = vMoneda
        and fecha = dFecha
        and nodo = nNodo;
      end if;
    exception
      when others then
        nContador := 0;
    end;
    
    Begin
      if nContador > 0 then
        if vTipo = 'TC' then
          update dwhouse.FACT_RIES_CURVAS@DW
             set valor = nValor
          where tipo = vTipo
          and fecha = dFecha;
        elsif vTipo = 'TCFWD' then
          update dwhouse.FACT_RIES_CURVAS@DW
             set valor = nValor
          where tipo = vTipo
            and moneda = 'S'
            and fecha = dFecha
            and nodo = nNodo;
        else
          update dwhouse.FACT_RIES_CURVAS@DW
             set valor = nValor
           where tipo = vTipo
             and calif = vCalif
             and moneda = vMoneda
             and fecha = dFecha
             and nodo = nNodo;
        end if;
      else
        if vTipo = 'TC' then
          insert into dwhouse.FACT_RIES_CURVAS@DW
          (tipo, fecha, valor) values
          (vTipo, dFecha, nValor);
        elsif vTipo = 'TCFWD' then
          insert into dwhouse.FACT_RIES_CURVAS@DW
          (tipo, moneda, fecha, nodo, valor) values
          (vTipo, 'S', dFecha, nNodo, nValor);
        else
          insert into dwhouse.FACT_RIES_CURVAS@DW
          (tipo, calif, moneda, fecha, nodo, valor) values
          (vTipo, vCalif, vMoneda, dFecha, nNodo, nValor);
        end if;
      end if;
      commit;
      
      pv_rpta := 'S';
    exception
      when others then
        err_msg := substr(SQLERRM, 1, 255);
        null;
    end;
  end PR_A8_UPDATE_CURVA;
  
  ------------------------------------------------------
  --NUEVO
  procedure PR_A8_VALIDAR_PRUEBAS(pd_fecha in date,
                                  pv_analista in varchar2,
                                  pv_rpta out varchar2) is
    nContador number(5) := 0;
    cMoneda varchar2(1) := 'S';
  begin
    pv_rpta := 'N';

    Begin
      EXECUTE IMMEDIATE 'TRUNCATE TABLE AQPD103T';
    exception
      when others then
        NULL;
    end;
    
    Begin
      insert into aqpd103t
      (aqpd103ttipo, aqpd103tnfwd, aqpd103tcfwd, aqpd103tent, aqpd103tdeal, aqpd103tpru, aqpd103tana)
      select 
      a.aqpd103tipo, a.aqpd103nfwd, a.aqpd103codfwd, a.aqpd103ent, a.aqpd103deal,
      dwhouse.PQ_RIES_ANEXOS_REPORTES.FN_A8_TIENE_PRUEBAS@dw(a.AQPD103DEAL,
                                                                  a.AQPD103TIPCUR,
                                                                  cMoneda,
                                                                  pd_fecha,
                                                                  a.Aqpd103fecini) tienePrueba,
      pv_analista
      FROM aqpd103 a
      where a.aqpd103estreg = 1
      and pd_fecha >= a.aqpd103fecini
      and a.aqpd103fecvto > pd_fecha;
      commit;
      pv_rpta := 'S';
    exception
      when others then
        --pv_rpta := 'N';
        pv_rpta := substr(SQLERRM, 1, 255);
    end;
    
    if pv_rpta = 'S' then 
      Begin      
        select count(aqpd103tpru)
        into nContador
        from aqpd103t
        where aqpd103tpru like 'N:%';
      exception
        when others then
          pv_rpta := substr(SQLERRM, 1, 255);
          nContador := 1;
      end;
      
      if nContador = 0 then
        pv_rpta := 'S';
      Else
        pv_rpta := 'N';
      End if;
    End if;
    
  end PR_A8_VALIDAR_PRUEBAS;

  ------------------------------------------------------
  -------------------- INICIO REP37 --------------------
  ------------------------------------------------------
  procedure SP_REP37_TRAER(pdFecha in date, pvRpta out varchar2) is
    --err_msg varchar2(255);
  begin
    pvRpta := 'S';
    begin
      EXECUTE IMMEDIATE 'TRUNCATE TABLE aqpd105';
    exception
      when others then
        pvRpta := substr(SQLERRM, 1, 255);
    end;
  
    begin
      insert into aqpd105
        (aqpd105fec, aqpd105ord, aqpd105dsc1, aqpd105dsc2, aqpd105sld)
        SELECT FECHA, ORDEN, DESC1, DESC2, SALDO
          FROM DWHOUSE.FACT_RIES_REP37_CONSOL@DW
         where FECHA = pdFecha;
    
      COMMIT;
      pvRpta := 'S';
    exception
      when others then
        pvRpta := substr(SQLERRM, 1, 255);
        null;
    end;
  
  end SP_REP37_TRAER;

  ------------------------------------------------------
  procedure SP_REP37_GENERAR(pdFecha in date, pvRpta out varchar2) is
    --err_msg varchar2(255);
  begin
    pvRpta := 'S';
  
    begin
      DWHOUSE.PQ_RIES_ANEXOS_REPORTES.SP_REP37_GENERAR@DW(PD_FECHA => pdFecha);
      commit;
    exception
      when others then
        pvRpta := substr(SQLERRM, 1, 255);
    end;
  end SP_REP37_GENERAR;
  ------------------------------------------------------
  ------------------- INICIO ANEXO 4B ------------------
  ------------------------------------------------------
  Procedure SP_4B_TRAER(pdfecha in date,
                        pcAnexo in varchar2,
                        pvRpta  out varchar2) 
  Is
  Begin
    pvRpta := 'S';
    begin
      EXECUTE IMMEDIATE 'TRUNCATE TABLE aqpd104';
    exception
      when others then
        pvRpta := substr(SQLERRM, 1, 255);
    end;
    
    begin
      insert into aqpd104
        (AQPD104FECHA, AQPD104CODREP, AQPD104CODSEC, AQPD104ORDEN, AQPD104DESCON,
        AQPD104COL_1, AQPD104COL_2, AQPD104COL_3, AQPD104COL_4, AQPD104COL_5, AQPD104COL_6, AQPD104COL_7, AQPD104FECPRO)
        select FECHA,
               CODREP,
               CODSEC,
               ORDEN,
               DESCON,
               COL_1,
               COL_2,
               COL_3,
               COL_4,
               COL_5,
               COL_6,
               COL_7,
               FECPRO
          from dwhouse.fact_ries_anexo4b_rep@DW
         where CODREP = pcAnexo
           and FECHA = pdfecha;
    
      COMMIT;
      pvRpta := 'S';
    exception
      when others then
        pvRpta := substr(SQLERRM, 1, 255);
        null;
    end;
    
  End SP_4B_TRAER;
  -----------------------------------------------------
  Procedure SP_4B_GENERAR(pdfecha in date,
                          pvRpta  out varchar2) is
    nNumDat Number(10);
  Begin
      pvRpta := 'S';
      
      -- Revisar parámetros configurados para 4B2
      nNumDat := DWHOUSE.PQ_RIES_ANEXOS_REPORTES.FN_REVISA_PARAM@DW(pdfecha,'ANEXO4B2');
      IF nNumDat = 0 Then
         pvRpta:= 'No existen parámetros configurados del Reporte N°4-B2 para el mes '||
                  to_char(pdfecha,'rrrr.mm.dd')||' Revise.';
      End If;
      
      -- Revisar parámetros configurados para 4B3
      nNumDat := DWHOUSE.PQ_RIES_ANEXOS_REPORTES.FN_REVISA_PARAM@DW(pdfecha,'ANEXO4B3');
      IF nNumDat = 0 Then
         pvRpta:= 'No existen parámetros configurados del Reporte N°4-B3 para el mes '||
                  to_char(pdfecha,'rrrr.mm.dd')||' Revise.';
      End If;
      
      -- Revisar registros del Reporte 2A1      
      If pvRpta = 'S' Then
         nNumDat := DWHOUSE.PQ_RIES_ANEXOS_REPORTES.FN_2A1_CONSOL_REG@DW(pdfecha);
         If nNumDat = 0 Then
            pvRpta:= 'No existen datos en el Reporte N°2-A1 para el mes '||
                     to_char(pdfecha,'rrrr.mm.dd')||' Revise.';
         End If; 
      End if;     
    
      If pvRpta = 'S' Then
         Begin
             DWHOUSE.PQ_RIES_ANEXOS_REPORTES.SP_4B_GENERAR@DW(PD_FECHA => pdfecha);
         Exception When others then
             pvRpta := substr(SQLERRM, 1, 255);
         End;
      End If;
      
  end SP_4B_GENERAR;
  
  ------------------------------------------------------
  ------------------- INICIO REP 25A -------------------
  ------------------------------------------------------
  procedure SP_25A_TRAER(pdFecha In Date, pdRpta out varchar2) is
    --err_msg    varchar2(255);
    PD_FECHA_1 Date;
    PD_FECHA_2 Date;
    nPeriodo   number(10) := to_number(to_char(pdFecha, 'yyyymm'));
    
    cModalidadTrans VARCHAR2(10);
    cRelacionAdq VARCHAR2(10);
    cResolucion VARCHAR2(10);
    cTipRep VARCHAR2(10);
  begin
    PD_FECHA_1 := trunc(add_months(pdFecha, -2), 'MM');
    PD_FECHA_2 := last_day(pdFecha);

    pdRpta     := 'N';
    begin
      execute immediate 'truncate table aqpd106';
    exception
      when others then
        null;
    end;
    
    --NUEVO: PARAMETROS 
    begin
      select AQPD102VAL into cModalidadTrans
      from aqpd102 p
      where p.aqpd102anx = 'REP25A'
      and p.aqpd102ctp = 1
      and p.aqpd102cor = 1
      AND p.aqpd102per = nPeriodo;
      
      select AQPD102VAL into cRelacionAdq
      from aqpd102 p
      where p.aqpd102anx = 'REP25A'
      and p.aqpd102ctp = 2
      and p.aqpd102cor = 1
      AND p.aqpd102per = nPeriodo;
      
      select AQPD102VAL into cResolucion
      from aqpd102 p
      where p.aqpd102anx = 'REP25A'
      and p.aqpd102ctp = 3
      and p.aqpd102cor = 1
      AND p.aqpd102per = nPeriodo;
      
      select AQPD102VAL into cTipRep
      from aqpd102 p
      where p.aqpd102anx = 'REP25A'
      and p.aqpd102ctp = 4
      and p.aqpd102cor = 1
      AND p.aqpd102per = nPeriodo;
    exception
      when others then 
        null;
    end;
    
    begin
      insert into aqpd106
        (aqpd106fec, aqpd106nro, aqpd106nomadq, aqpd106tipdoc, aqpd106nrodoc,
        aqpd106modtra, aqpd106clasi, aqpd106reladq, aqpd106fectra, aqpd106coosbs,
        aqpd106ressbs, aqpd106tiprep, aqpd106corgep, aqpd106medemp, aqpd106peqemp,
        aqpd106micemp, aqpd106consu, aqpd106hipo, aqpd106imp1, aqpd106vig,
        aqpd106ref, aqpd106venci, aqpd106jud, aqpd106cas, aqpd106imp2,
        aqpd106carind, aqpd106dev, aqpd106sus, aqpd106pro, aqpd106venta,
        aqpd106deudo, AQPD106FEC1, AQPD106FEC2)
        select 
        TRUNC(SYSDATE), nro, nomadq, tipdoc, nrodoc,
        cModalidadTrans, clasi, cRelacionAdq, fectra, coosbs,
        cResolucion, cTipRep, corp_ge, medemp, peqemp,
        microemp, consumo, hipote, imp_tot_1, vigente,
        refinan, vencida, judicial, castigada, imp_tot_2,
        car_ind, deven, suspenso, prov, venta,
        deudores, fecha1, fecha2
          from DWHOUSE.fact_ries_25a@DW
         where fecha = pdFecha;
      COMMIT;
      pdRpta := 'S';
    exception
      when others then
        pdRpta := substr(SQLERRM, 1, 255);
    end;
    
  
  end SP_25A_TRAER;

  ------------------------------------------------------
  procedure SP_25A_GENERAR(pdFecha In Date, pdRpta out varchar2) is
    --err_msg varchar2(255);
    PD_FECHA_1 Date;
    PD_FECHA_2 Date;
  begin
    PD_FECHA_1 := trunc(add_months(pdFecha, -2), 'MM');
    PD_FECHA_2 := last_day(pdFecha);
    pdRpta := 'N';
    
    begin
      DWHOUSE.PQ_RIES_ANEXOS_REPORTES.SP_25A_TRAER@DW(PDFECHA => pdFecha,
                                                           PD_FECHA_1 => PD_FECHA_1,
                                                           PD_FECHA_2 => PD_FECHA_2);
      COMMIT;
    exception
      when others then
        pdRpta := substr(SQLERRM, 1, 255);
    end;
    
    pdRpta := 'S';
  
  end SP_25A_GENERAR;
  
  ------------------------------------------------------
  Procedure SP_25A_OBTENER_ADQUIRIENTES(PD_FECHA IN Date,
                                        PN_RPTA OUT NUMBER)
  -- Creación -----------------------------------------
  -- Fecha: 2024.07.10
  -- Uso  : LLenar parametros de adquirientes
  -- Autor: Llatan SAC - EFuentes
  -----------------------------------------------------
  IS
    nExiste number(1) := 0;
    dFecInicio DATE := trunc(add_months(PD_FECHA, -2), 'MM');
    dFecFin DATE := last_day(PD_FECHA);
    nPeriodo NUMBER(8) := to_number(to_char(dFecFin, 'YYYYMM'));
    cAnexo VARCHAR2(10) := 'REP25A';
    nCodTipo NUMBER(2) := 1;
    cDescri VARCHAR2(20) := 'ADQUIRIENTE';
  Begin
    PN_RPTA := 0;
    Begin
      select 1
        into nExiste
        from aqpd102
       where aqpd102per = nPeriodo
         and aqpd102anx = cAnexo
         and aqpd102ctp = nCodTipo
      fetch next 1 rows only;
    Exception When others then
      nExiste := 0;
    End;
    
    if nExiste = 0 then
      Begin
        insert into aqpd102
        (aqpd102per, aqpd102anx, aqpd102ctp, aqpd102dtp, aqpd102cva, aqpd102vde, aqpd102cvl1, aqpd102cvl2, aqpd102cor)
        select
          nPeriodo, cAnexo, nCodTipo, cDescri, a.jaqy470fnumdoc, a.jaqy470fnomadq, a.jaqy470ftipdoc, a.jaqy470fcodtra, 
          row_number() over (order by a.jaqy470fnumdoc) as correlativo      
        from jaqy470f a
        where a.jaqy470ffectra between dFecInicio and dFecFin;
        
        Commit;
      Exception When others then
        PN_RPTA := 1;
      End;
    end if;
  End SP_25A_OBTENER_ADQUIRIENTES;  
  ------------------------------------------------------
  ------------------- INICIO REP 15B -------------------
  ------------------------------------------------------
  procedure SP_15B_TRAER(pdFecha In Date, pdRpta out varchar2) is
  
  begin
    begin
      execute immediate 'truncate table aqpd107';
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpd107
        (aqpd107codrow, aqpd107ord, aqpd107fec,
         aqpd107rubrow, aqpd107desrow,
         aqpd107col1, aqpd107col2, aqpd107factor,
         aqpd107col3, aqpd107col4, aqpd107col5,
         aqpd107col6, aqpd107col7, aqpd107col8,
         aqpd107tipcam, aqpd107tipo/*, AQPD107CODSUC*/)
        select 
         codrow, orden, fecha,
         rubrow, desrow, 
         col_1, col_2, d.factor / 100 factor,
         col_3, col_4, col_5,
         col_6, col_7, col_8,
         d.tipcam, d.tipreg--, d.codsucave
          from dwhouse.fact_ries_anexo15b_rep@DW d
         where fecha = pdFecha
         order by codrow, orden;
      pdRpta := 'S';
    exception
      when others then
        pdRpta := substr(SQLERRM, 1, 255);
    end;
  
  end SP_15B_TRAER;

  ------------------------------------------------------
  procedure SP_15B_GENERAR(pdFecha In Date, pdRpta out varchar2) is

  begin
    begin
      pdRpta := dwhouse.PQ_RIES_ANEXOS_REPORTES.FN_NUMREG_ANEXO15B@DW(pdFecha);
      If pdRpta is Null Then
        dwhouse.PQ_RIES_ANEXOS_REPORTES.SP_EJE_ANEXO15B@DW(pdFecha);
        
        pdRpta := 'S';
      Else 
        dbms_output.put_line(pdRpta);
      End If;
    exception
      when others then
        pdRpta := substr(SQLERRM, 1, 255);
    end;
  end SP_15B_GENERAR;
  
  ------------------------------------------------------
  ---------------- VALIDAR DATOS FSH012 ----------------
  ------------------------------------------------------
  procedure SP_VALIDAR_FSH012(pdFecha In Date, pdRpta out varchar2) is
    dFinMes date := LAST_DAY(pdFecha);
    nCount  number(10);
  begin
  
    pdRpta := 'S';
    nCount := 0;
    
    -- un select a la fsh012 de dwhouse
    -- S: hay informacion, N: aun no hay informacion
    if dFinMes = pdFecha then
      begin
        SELECT 1
          into nCount
          FROM DWHOUSE.FACT_RIES_FSH012@DW
         WHERE BCFECH = pdFecha
           and rownum = 1;
           
        COMMIT;
      exception
        when others then
          nCount := 0;
      end;
      
      if nCount = 0 then
        pdRpta := 'No hay información para la Fecha!';
      end if;
    else
      pdRpta := 'Debe seleccionar un fin de mes!';
    end if;
  end SP_VALIDAR_FSH012;
  
  ------------------------------------------------------
  procedure SP_GENERAR_FSH012(pdFecha In Date, pdRpta out varchar2) is
    dFinMes date := LAST_DAY(pdFecha);
    nCount  number(10);
  begin
  
    pdRpta := 'S';
  
    nCount := 0;
    
    if dFinMes = pdFecha then
      begin
        dwhouse.pq_ries_anexos_reportes.SP_JOB_DATOS_BASE_ANEXOS@DW(pdFecha);
      exception
        when others then
          pdRpta := substr(SQLERRM, 1, 255);
      end;
      COMMIT;
    else
      pdRpta := 'Debe seleccionar un fin de mes!';
    end if;
  end SP_GENERAR_FSH012;
  
  ------------------------------------------------------
  ----------------- COPIAR PARAMETROS ------------------
  ------------------------------------------------------
  procedure SP_COPIAR_PARAMETROS(pnPeriodo In Number, 
                                 pcAnexo in varchar2, 
                                 pcUsuario in varchar2,
                                 pdRpta out varchar2) 
  -- Modificacion
  -- Fecha: 2025.03.10
  -- Autor: Paola Vargas
  -- Cambio: Filto para copia de parámetros del Anexo15B
  --         Si no existe mes anterior copiar de la última fecha
     
  is

      cPeriodo varchar2(8);
      dFecha date;
      dFechaAnt date;
      cPeriodoAnt varchar2(8);
      nPeriodoAnt number(8);
      dFechaRegistro date := sysdate;
      vHora varchar2(8) := to_char(sysdate, 'HH24:MI:SS');
      vQuery Varchar2(4000);
      nNumReg Number(10);

  Begin

    pdRpta := 'S';
    
    cPeriodo := to_char(pnPeriodo);
    dFecha := to_date(cPeriodo, 'YYYYMM');
    dFechaAnt := add_months(dFecha, -1);
    cPeriodoAnt := to_char(dFechaAnt, 'YYYYMM');
    nPeriodoAnt := to_number(cPeriodoAnt);
    
    -- Revisar datos de periodo anterior
    Select count(*) Into nNumReg
      From aqpd102 Where aqpd102per = nPeriodoAnt and aqpd102anx = pcAnexo;
    -- Si no hay registros, buscar la fecha máxima
    If nNumReg = 0 Then
       Begin
           Select max(aqpd102per) Into nPeriodoAnt
             From aqpd102 Where aqpd102anx = pcAnexo; 
       Exception When Others Then
          nPeriodoAnt := null;
       End;    
    End IF;    
    
    vQuery := 'Insert into aqpd102 '||
                '(AQPD102PER, AQPD102ANX, AQPD102CTP, AQPD102DTP, AQPD102COR, AQPD102CVA, AQPD102VAL, AQPD102VLN, AQPD102VLP, AQPD102VDE, AQPD102DFE,'|| 
                 'AQPD102HOJ, AQPD102CA1, AQPD102CA2, AQPD102CA3, AQPD102WH1, AQPD102CA4, AQPD102CA5, AQPD102CA6, AQPD102CA7, AQPD102CA8, AQPD102CA9,'|| 
                 'AQPD102CA10, AQPD102CA11, AQPD102CA12, AQPD102CA13, AQPD102CA14, AQPD102CA141, AQPD102CA15, AQPD102CA16, AQPD102CA17, AQPD102CVL1,'|| 
                 'AQPD102CVL2, AQPD102CVL3, AQPD102CREP, AQPD102RPC1, AQPD102RPC2, AQPD102CSBS, AQPD102USRA, AQPD102FECA, aqpd102hora, AQPD102AUX1, '||
                 'AQPD102AUX2, AQPD102AUX3, AQPD102AUX4, AQPD102AUX5) '||
               'Select :1, AQPD102ANX, AQPD102CTP, AQPD102DTP, AQPD102COR, AQPD102CVA, AQPD102VAL, AQPD102VLN, AQPD102VLP, AQPD102VDE, :2,'|| 
                 'AQPD102HOJ, AQPD102CA1, AQPD102CA2, AQPD102CA3, AQPD102WH1, AQPD102CA4, AQPD102CA5, AQPD102CA6, AQPD102CA7, AQPD102CA8, AQPD102CA9, '||
                 'AQPD102CA10, AQPD102CA11, AQPD102CA12, AQPD102CA13, AQPD102CA14, AQPD102CA141, AQPD102CA15, AQPD102CA16, AQPD102CA17, AQPD102CVL1, '||
                 'AQPD102CVL2, AQPD102CVL3, AQPD102CREP, AQPD102RPC1, AQPD102RPC2, AQPD102CSBS, :3, :4, :5, AQPD102AUX1, AQPD102AUX2, '||
                 'AQPD102AUX3, AQPD102AUX4, AQPD102AUX5 '||
                 'from aqpd102 p '||
                 'where p.aqpd102anx = '''||pcAnexo||''' '||
                   'and p.aqpd102per = :6';
      
      If pcAnexo = 'ANEXO15B' Then 
         vQuery := vQuery||' and aqpd102ctp < 2000 ';
      End If;
         
      Begin
         Execute Immediate vQuery Using  pnPeriodo,dFechaRegistro,pcUsuario,dFechaRegistro,vHora,nPeriodoAnt;  
         Commit;
      Exception when others then
        pdRpta  := substr(SQLERRM, 1, 250);
      End;
  
  End SP_COPIAR_PARAMETROS;
  ------------------------------------------------------
  ----------- AQPD115 MIVIVIENDA-TECHOPROP -------------
  ------------------------------------------------------
  procedure SP_GENERAR_CRO_MIVIVIENDA(pdFechaCar in date,
                                      pnContrato in varchar2,
                                      pdFechaDes in date,
                                      pnMontoApr in number,
                                      pnBBP      in number,
                                      pnPlazo    in number,
                                      pnTasa     in number,
                                      pcProducto in varchar2,
                                      pcTipo     in varchar2,
                                      pcMoneda   in varchar2,
                                      pcUsuario  in varchar2,
                                      pdRpta     out varchar2) is
    cursor cur_Cronograma(p_dFechaCar in date, p_nContrato in varchar2) is
      Select *
      from aqpd115s a
      where a.aqpd115sfcar = p_dFechaCar
      and a.aqpd115scon = p_nContrato
      order by a.aqpd115sncuo;
      
    nTea number(10,2);
    nTeq number(12,8);
    nFc  number(12,8);
    nCuota number(10,2);
    dFechaVto date;
    dFechaVto_ant date;
    nDias number(10);
    nDiasAcum number(10) := 0;
    nFactorCuota number(18,8);
    nFactorInteresCuota number(18,8);
    nSaldoPrincipal number(18,2);
    nSaldoPrincipal_ant number(18,2);
    nInteres number(18,2);
    nCapital number(18,2);
    nCapitalAcum number(18,2);
    nCapitalAcum_ant number(18,2);
    nCapitalPrin number(18,2);
  begin
    pdRpta := 'S';
    
    nTea := pnTasa;
    nTeq := (((1 + (pnTasa / 100)) ** (30 / 360)) - 1) * 100;

    begin
      delete from aqpd115s a
      where a.aqpd115sfcar = pdFechaCar
      and a.aqpd115scon = pnContrato;
      commit;
    exception
      when others then
        pdRpta  := substr(SQLERRM, 1, 250);
    end;
    
    begin
      for i in 0 .. pnPlazo loop
        if i = 0 then
          dFechaVto := pdFechaDes;
        else
          dFechaVto_ant := dFechaVto;
          dFechaVto := last_day(add_months(pdFechaDes, i));
          nDias := dFechaVto - dFechaVto_ant;
          nDiasAcum := nDiasAcum + nDias;
          nFactorCuota := (1 + (nTeq / 100)) ** (-nDiasAcum / 30);
          nFactorInteresCuota := (((1 + (nTea / 100)) ** (nDias / 360)) - 1) * 100;
        end if;
        
        begin
          insert into aqpd115s
          (aqpd115sfcar, aqpd115scon, aqpd115sfdes, aqpd115smntapr, aqpd115sbbp, aqpd115splz, aqpd115stas, aqpd115spro, 
          aqpd115stea, aqpd115steq, aqpd115sncuo, aqpd115sfvto, aqpd115sdias, aqpd115sdiasac, 
          aqpd115sfaccuo, aqpd115sfacint, aqpd115stipo, aqpd115samo, aqpd115smnd, aqpd115sana) values
          (pdFechaCar, pnContrato, pdFechaDes, pnMontoApr, pnBBP, pnPlazo, pnTasa, pcProducto, 
           nTea, nTeq, i, dFechaVto, nDias, nDiasAcum, 
           nFactorCuota, nFactorInteresCuota, pcTipo, 'N', pcMoneda, pcUsuario);
           
           commit;
        exception
          when others then
            pdRpta  := substr(SQLERRM, 1, 250);
        end;
      end loop;
    exception
      when others then
        pdRpta  := substr(SQLERRM, 1, 250);
    end;
    
    begin
      begin
        Select 1 / sum(a.aqpd115sfaccuo)
        into nFc
        from aqpd115s a
        where a.aqpd115sfcar = pdFechaCar
        and a.aqpd115scon = pnContrato;
      exception
        when others then
          null;
      end;

      nCuota :=  pnMontoApr * nFc;
      
      for i in cur_Cronograma(pdFechaCar, pnContrato) loop
        if i.aqpd115sncuo = 0 then
          nSaldoPrincipal := pnMontoApr;
        else
          nSaldoPrincipal_ant := nSaldoPrincipal;
          nInteres := i.aqpd115sfacint * (nSaldoPrincipal_ant / 100);
          nCapital := nCuota - nInteres;
          nSaldoPrincipal := nSaldoPrincipal_ant - nCapital;
          nCapitalAcum_ant := nCapitalAcum;
          nCapitalAcum := nCapital + nvl(nCapitalAcum_ant, 0);
          
          if i.aqpd115sncuo = i.aqpd115splz then
            if nCapitalAcum <> pnMontoApr then
              nCapitalPrin := pnMontoApr - nCapitalAcum + nCapital;
            else
              nCapitalPrin := nCapital;
            end if;
          else
            nCapitalPrin := nCapital;
          end if;

        end if;
        
        begin
          update aqpd115s
          set
          aqpd115ssld = nSaldoPrincipal,
          aqpd115sfc = nFc,
          aqpd115scuo = nCuota,
          aqpd115sint = nInteres,
          aqpd115scappri = nCapitalPrin,
          aqpd115scap = nCapital,
          AQPD115sMNTCOB = case when i.aqpd115sncuo = 0 then null else nCuota end,
          aqpd115scapacu = nCapitalAcum
          where aqpd115sfcar = i.aqpd115sfcar
          and aqpd115scon = i.aqpd115scon
          and aqpd115sncuo = i.aqpd115sncuo;
          
          commit;
        exception
          when others then
            pdRpta  := substr(SQLERRM, 1, 250);
        end;
      end loop;
    exception
      when others then
        pdRpta  := substr(SQLERRM, 1, 250);
    end;
  
  end SP_GENERAR_CRO_MIVIVIENDA;  
  ------------------------------------------------------
  ------------------- REPORTE 29 -----------------------
  ------------------------------------------------------
  Procedure SP_EJE_REP29_PARTE_I(PD_FECHA IN Date, 
                                 PN_RPTA OUT NUMBER, 
                                 PD_RPTA OUT VARCHAR2
                                ) 
  -- Creación -----------------------------------------
  -- Fecha: 2024.07.10
  -- Uso  : Generar datos de la FaseI del Reporte N°29
  -- Autor: Llatan SAC - EFuentes
  -----------------------------------------------------
  IS 
    nNumDat Number(10);
  Begin
    
      PD_RPTA := 'S';
      PN_RPTA := 0;
    
      -- Revisar cantidad de registros en el reporte RGE - Bantotal
      nNumDat := DWHOUSE.PQ_RIES_ANEXOS_REPORTES.FN_REP29_DATOS_RGE@DW(PD_FECHA);
      IF nNumDat = 0 Then
         PN_RPTA := 1;
         PD_RPTA := 'No existen datos en la tabla JAQZ461A. Ejecute el Reporte 29-GE. '||
                    'para el mes '||to_char(PD_FECHA,'rrrr.mm.dd');
      End If;
    
      -- Revisar parámetros configurados
      If PN_RPTA = 0 Then
         nNumDat := DWHOUSE.PQ_RIES_ANEXOS_REPORTES.FN_REP29_CNT_PARAM@DW(PD_FECHA);
         IF nNumDat = 0 Then
            PN_RPTA := 1;
            PD_RPTA := 'No existen parámetros configurados del Reporte 29 para el mes '||
                        to_char(PD_FECHA,'rrrr.mm.dd')||' Revise.';
         End If;
      End If;
          
      -- Si los requisitos se cumplieron, ejecutar el proceso
      If PN_RPTA = 0 THEN              
         Begin
              DWHOUSE.PQ_RIES_ANEXOS_REPORTES.SP_EJE_REP29_PARTE_I@DW(PD_FECHA  => PD_FECHA);
              Commit;
         Exception When others then
            PN_RPTA := 1;
            PD_RPTA := substr(SQLERRM, 1, 255);
         End;
      End If;
     
  End SP_EJE_REP29_PARTE_I;  
  ------------------------------------------------------
  Procedure SP_EJE_REP29_PARTE_II(PD_FECHA IN Date, 
                                  PN_RPTA OUT NUMBER, 
                                  PD_RPTA OUT VARCHAR2)
  -- Creación -----------------------------------------
  -- Fecha: 2024.07.10
  -- Uso  : Generar datos de la FaseII del Reporte N°29
  -- Autor: Llatan SAC - EFuentes
  -----------------------------------------------------
  IS 
     nNumDat Number(10);
  Begin
      PD_RPTA := 'S';
      PN_RPTA := 0;
    
      -- Revisar cantidad de registros de la Fase I
      nNumDat := DWHOUSE.PQ_RIES_ANEXOS_REPORTES.FN_REP29_CNT_FASEI@DW(PD_FECHA);
      IF nNumDat = 0 Then
         PN_RPTA := 1;
         PD_RPTA := 'No hay datos de la Fase I del Reporte 29 para el mes '||
                    to_char(PD_FECHA,'rrrr.mm.dd')||' Revise.';
      End If;
      
      -- Requisitos cumplidos
      If PN_RPTA = 0 Then 
         Begin
            DWHOUSE.PQ_RIES_ANEXOS_REPORTES.SP_EJE_REP29_PARTE_II@DW(PD_FECHA => PD_FECHA);      
            commit;
         Exception When others then
            PN_RPTA := 1;
            PD_RPTA := substr(SQLERRM, 1, 255);
         End;
      End If;
      
  End SP_EJE_REP29_PARTE_II;
  ------------------------------------------------------
  Procedure SP_TRAER_REP29_PARTE_I(PD_FECHA IN Date, PD_RPTA OUT VARCHAR2) 
  -- Creación -----------------------------------------
  -- Fecha: 2024.07.10
  -- Uso  : Obtener datos de la FaseI del Reporte N°29
  -- Autor: Llatan SAC - EFuentes
  -----------------------------------------------------  
  IS
    nPeriodo number(8) := to_number(to_char(PD_FECHA, 'rrrrmm'));
  Begin
    PD_RPTA := 'S';
    begin
      --GRUPOS
      EXECUTE IMMEDIATE 'TRUNCATE TABLE aqpd113a';
      --CUENTAS
      EXECUTE IMMEDIATE 'TRUNCATE TABLE aqpd113b';
      --GRUPOS ECONOMICOS
      EXECUTE IMMEDIATE 'TRUNCATE TABLE aqpd113c';
    exception
      when others then
        PD_RPTA := substr(SQLERRM, 1, 255);
    end;
    begin
      --GRUPOS
      insert into aqpd113a
      (aqpd113aper, aqpd113acge, aqpd113apai, 
       aqpd113atdoc, aqpd113andoc, aqpd113acta)
      select periodo, cod_grueco CodGE, jaqz461apais Pais,
       jaqz461atdoc Tipodoc, jaqz461andoc Numdoc, jaqz461acta CUENTA
      from  DWHOUSE.FACT_RIES_REPORTE29_BASE@dw
      where ind_increp = 5
      and periodo = nPeriodo
      Order by 2;

      --CUENTAS
      insert into aqpd113b
      (aqpd113bcta, aqpd113bcant)
      Select cuenta, count(distinct codge) 
      From
      (
      select periodo,cod_grueco CodGE,jaqz461apais Pais,
      jaqz461atdoc Tipodoc,jaqz461andoc Numdoc, pr.ctnro CUENTA
      from DWHOUSE.FACT_RIES_REPORTE29_BASE@DW b29
      Join fsr008 pr on pr.pepais = jaqz461apais
      and pr.petdoc = jaqz461atdoc
      and pr.pendoc = jaqz461andoc
      and pr.cttfir = 'T'
      where ind_increp = 5
      and periodo = nPeriodo
      Order by 2
      ) 
      Group by cuenta;
      
      --GRUPOS ECONOMICOS
      insert into aqpd113c
      (aqpd113ccod, aqpd113cgru, aqpd113cdocge, aqpd113ctdoci, aqpd113cdoci, 
       aqpd113cint, aqpd113ccglo, aqpd113cper, aqpd113cfpro, aqpd113ctreg, 
       aqpd113cindm, aqpd113cgrua, aqpd113cest)
      Select 
       COD_GRUECO, NOM_GRUECO, DOC_GRUECO, TDO_INTEGR, DOC_INTEGR, 
       NOM_INTEGR, COD_GLOBAL, PERIOD, FECPRO, TIPREG, 
       INDMOD, GRUANT, INDEST
      from dwhouse.dm_ries_grupo_economico@DW
      Where period = nPeriodo;
      commit;
    exception
      when others then
        PD_RPTA := substr(SQLERRM, 1, 255);
    end;
  End SP_TRAER_REP29_PARTE_I;  
  ------------------------------------------------------
  Procedure SP_TRAER_REP29_PARTE_II(PD_FECHA IN Date, PD_RPTA OUT VARCHAR2) 
  IS
  -- Creación -----------------------------------------
  -- Fecha: 2024.07.10
  -- Uso  : Obtener datos de la FaseII del Reporte N°29
  -- Autor: Llatan SAC - EFuentes
  -----------------------------------------------------    
    nPeriodo number(8) := to_number(to_char(PD_FECHA, 'rrrrmm'));
  Begin
    PD_RPTA := 'S';
    begin
      --GRUPOS ECONOMICOS
      EXECUTE IMMEDIATE 'TRUNCATE TABLE aqpd113r';
    exception
      when others then
        PD_RPTA := substr(SQLERRM, 1, 255);
    end;
    begin
      insert into aqpd113r
      (aqpd113rper, aqpd113rcol1, aqpd113rcol2, aqpd113rcol3, aqpd113rcol4, 
       aqpd113rcol5, aqpd113rcol6, aqpd113rcol7, aqpd113rcol8, aqpd113rcol9, 
       aqpd113rcol10, aqpd113rcol11, aqpd113rcol12, aqpd113rcol13, aqpd113rcol14, 
       aqpd113rcol15, aqpd113rcol16, aqpd113rcol17, aqpd113rcol18, aqpd113rcol19, 
       aqpd113rcol20, aqpd113rcol21)
      select distinct periodo, col_1, col_2, col_3, col_4, 
      col_5, col_6, col_7,col_8, col_9, 
      col_10, col_11, col_12, col_13, col_14, 
      col_15, col_16, col_17, col_18, col_19, 
      col_20, col_21
       from dwhouse.fact_ries_reporte29_res@DW
       where periodo =  nPeriodo
      Order by  col_1;
      commit;
    exception
      when others then
        PD_RPTA := substr(SQLERRM, 1, 255);
    end;
  End SP_TRAER_REP29_PARTE_II;  
  ------------------------------------------------------
  ------------------ ANEXO 5 - 5A ----------------------
  ------------------------------------------------------
  Procedure SP_TRAER_5_5A(pd_fecha IN Date,
                          pv_ana   IN Varchar2,
                          pv_rpta  OUT Varchar2)
  IS 
  Begin
      pv_rpta := 'S';
    
      Begin
           EXECUTE IMMEDIATE 'TRUNCATE TABLE aqpd116';
      Exception When others then
           pv_rpta := 'No se pudo limpiar la tabla';
      End;
    
      If pv_rpta = 'S' then
         Begin
              Insert Into aqpd116
                     (aqpd116ord, aqpd116codrow, aqpd116fec, aqpd116desrow,aqpd116col1, 
                      aqpd116col2, aqpd116col3, aqpd116col4, aqpd116col5, aqpd116col6, 
                      aqpd116desgru, aqpd116codanx, aqpd116codsuc,aqpd116ana
                     )
              Select orden, codrow, fecha, desrow,
                     col_1, col_2, col_3, col_4, col_5, col_6,
                     desgroup, cod_anexo, cod_sucave, 
                     pv_ana
                From dwhouse.fact_ries_anexo5_5a@dw d
               Where d.fecha = pd_fecha;
         Exception When others then
             pv_rpta := 'No se pudo traer información del reporte';
         End;
      End If;
    
  End SP_TRAER_5_5A;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure SP_GENERAR_5_5A(PD_FECHA In DATE,
                            PN_RPTA OUT NUMBER, 
                            PV_RPTA Out VARCHAR2)
  IS 
    nNumDat Number(10);
  Begin
      PN_RPTA := 0;

      -- Revisar parámetros configurados para 4B2
      nNumDat := DWHOUSE.PQ_RIES_ANEXOS_REPORTES.FN_REVISA_PARAM@DW(PD_FECHA,'ANEXO5');
      IF nNumDat = 0 Then
         PN_RPTA := 1;
         PV_RPTA:= 'No existen parámetros configurados del Anexo N°5 para el mes '||
                  to_char(PD_FECHA,'rrrr.mm.dd')||' Revise.';
      End If;
      
      -- Revisar parámetros configurados para 4B3
      If PN_RPTA = 0 THEN
         nNumDat := DWHOUSE.PQ_RIES_ANEXOS_REPORTES.FN_REVISA_PARAM@DW(PD_FECHA,'ANEXO5A');
         IF nNumDat = 0 Then
            PN_RPTA := 1;
            PV_RPTA:= 'No existen parámetros configurados del Anexo N°5-A para el mes '||
                      to_char(PD_FECHA,'rrrr.mm.dd')||' Revise.';
         End If;
      END IF;
      
      -- Revisar registros del Reporte 2A1      
      If PN_RPTA = 0 Then
         nNumDat := DWHOUSE.PQ_RIES_ANEXOS_REPORTES.FN_2A1_CONSOL_REG@DW(PD_FECHA);
         If nNumDat = 0 Then
            PN_RPTA := 1;
            PV_RPTA:= 'No existen datos en el Reporte N°2-A1 para el mes '||
                     to_char(PD_FECHA,'rrrr.mm.dd')||' Revise.';
         End If; 
      End if;   
      
      -- PROCESO
      If PN_RPTA = 0 Then      
         Begin
             dwhouse.PQ_RIES_ANEXOS_REPORTES.SP_EJE_ANEXO5_5A@DW(PD_FECHA => PD_FECHA); 
         Exception When others then
             PN_RPTA := 1;
             PV_RPTA := substr(SQLERRM, 1, 255);
         End;
      End If;   

  End SP_GENERAR_5_5A;    
  ------------------------------------------------------
  -------------------- ANEXO 5D ------------------------
  ------------------------------------------------------
  Procedure SP_TRAER_5D(pd_fecha IN Date,
                        pv_ana   IN Varchar2,
                        pv_rpta  OUT Varchar2)
  Is 
  Begin
      pv_rpta := 'S';

      Begin
        EXECUTE IMMEDIATE 'TRUNCATE TABLE aqpd117';
      Exception When others then
        pv_rpta := 'No se pudo limpiar la tabla';
      End;
    
      If pv_rpta = 'S' then
         Begin
              Insert into aqpd117
                     (aqpd117fec, aqpd117ord, aqpd117codrow, aqpd117desrow, aqpd117cfondo, 
                      aqpd117dfondo, aqpd117col1, aqpd117col2, aqpd117col3, aqpd117col4, 
                      aqpd117col5, aqpd117col6, aqpd117ana
                     )
              Select fecha, orden, codrow, desrow, cfondo, dfondo,
                     nvl(col_1,0), nvl(col_2,0), nvl(col_3,0) ,nvl(col_4,0) , 
                     nvl(col_5,0), nvl(col_6,0),pv_ana
                From dwhouse.fact_ries_anexo5d_rep@DW
               Where fecha = pd_fecha
                 and nvl(ntipsbs,-1) = 999;
               Commit;
         Exception When others then
             pv_rpta := 'No se pudo traer información del reporte';
         End;
      End if;     
  End SP_TRAER_5D;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure SP_GENERAR_5D(pdfecha in date,pvRpta  out varchar2) 
  Is
    nNumDat Number(10);
  Begin
      pvRpta := 'S';
      
      -- Revisar parámetros configurados para 4B2
      nNumDat := DWHOUSE.PQ_RIES_ANEXOS_REPORTES.FN_REVISA_PARAM@DW(pdfecha,'ANEXO5D');
      IF nNumDat = 0 Then
         pvRpta:= 'No existen parámetros configurados del Anexo N°5-D para el mes '||
                  to_char(pdfecha,'rrrr.mm.dd')||' Revise.';
      End If;
      
      
      -- Revisar registros de FSH012   
      If pvRpta = 'S' Then
         PQ_CR_REP_ANX_RIES.SP_VALIDAR_FSH012(pdfecha,pvRpta);
         If pvRpta = 'N' Then
            pvRpta:= 'No existen saldos de balance (FSH012) para el mes '||
                     to_char(pdfecha,'rrrr.mm.dd')||' Revise.';
         End If; 
      End if;     
    
      If pvRpta = 'S' Then
         Begin
             dwhouse.PQ_RIES_ANEXOS_REPORTES.SP_EJE_ANEXO5D@DW(pdfecha);
         Exception When others then
             pvRpta := substr(SQLERRM, 1, 255);
         End;
      End If;
      
  End SP_GENERAR_5D;  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
  ------------------------------------------------------
  -------------------- ADEUDOS -------------------------
  ------------------------------------------------------
  Procedure SP_RECAL_ADEUDO(pn_Correlativo IN Number,
                            pn_Id       IN Number,
                            pd_FechaDes IN Date,
                            pn_NroCuota IN Number,
                            pn_Tasa     IN Number,
                            pn_Monto    IN Number,
                            pv_rpta     OUT VARCHAR2)
  IS 
    cursor lst_cuotas(p_correlativo in number, p_id in number, p_nroCuota in number, p_fechaDes in date) is
      select
      c.AQPD114COR, c.AQPD114EST, c.AQPD114FDES, c.AQPD114IMP, c.AQPD114CUO, c.AQPD114FCUO, c.AQPD114TAS, c.AQPD114PRI, 
      c.AQPD114INT, c.AQPD114SLD, 
      --NVL(lag(c.AQPD114SLD) over (order by c.aqpd114cuo), 0) as sld_anterior,
      c.AQPD114DIACAL, c.AQPD114ID, c.AQPD114FORM, c.AQPD114DIAANO
      from aqpd114 c
      where c.aqpd114cor = p_correlativo
        and c.aqpd114id = p_id
        and c.aqpd114cuo >= p_nroCuota
        and c.aqpd114fdes = p_fechaDes
      order by c.aqpd114cuo;

    nInteres NUMBER(18,9);
    
    vEstado varchar2(1) := 'S';
    nNewCorre Number(18) := pn_Correlativo + 1;
    nSaldo number(18, 2);
    nAmort number(12,2);
  Begin
    pv_rpta := 'S';
    
    Begin
      insert into aqpd114
      (aqpd114cor, aqpd114est, aqpd114fdes, aqpd114par, aqpd114ade, aqpd114mnd, aqpd114imp, aqpd114cuo, aqpd114fcuo, aqpd114tas, aqpd114pri, aqpd114int, aqpd114sld, aqpd114tiptas, aqpd114diacal, aqpd114id, aqpd114subo, aqpd114ori, aqpd114form, aqpd114diaano, aqpd114freg, aqpd114ana)
      select
      nNewCorre, vEstado, AQPD114FDES, AQPD114PAR, AQPD114ADE, AQPD114MND, AQPD114IMP, AQPD114CUO, AQPD114FCUO, AQPD114TAS, AQPD114PRI, 
      AQPD114INT, AQPD114SLD, AQPD114TIPTAS, AQPD114DIACAL, AQPD114ID, AQPD114SUBO, AQPD114ORI, AQPD114FORM, AQPD114DIAANO, sysdate, AQPD114ANA
      from aqpd114 c
      where c.aqpd114id = pn_Id
      and c.aqpd114fdes = pd_FechaDes
      and c.aqpd114est = vEstado;
      commit;
    Exception When others then
      pv_rpta := substr(SQLERRM, 1, 255);
    End;
    
    Begin
      update aqpd114
         set aqpd114est = 'N'
       where aqpd114cor = pn_Correlativo
         and aqpd114id = pn_Id
         and aqpd114fdes = pd_FechaDes;
      commit;
    Exception When others then
      pv_rpta := substr(SQLERRM, 1, 255);
    End;

    /*
    Begin
      update aqpd114 c
         set c.aqpd114pri = pn_Monto
      where c.aqpd114cor = nNewCorre
        and c.aqpd114id = pn_Id
        and c.aqpd114cuo = pn_NroCuota
        and c.aqpd114fdes = pd_FechaDes;
      commit;
    Exception When others then
      pv_rpta := substr(SQLERRM, 1, 255);
    End;
    */
    
    -- Saldo Remanente cuota anterior
    Begin
        select c.aqpd114sld into nSaldo
          from aqpd114 c
         where c.aqpd114cor = nNewCorre
           and c.aqpd114id = pn_Id
           and c.aqpd114cuo = (pn_NroCuota-1);
    Exception When Others Then
       nSaldo := 0;
    End;    
        
    For i in lst_cuotas(nNewCorre, pn_Id, pn_NroCuota, pd_FechaDes) Loop
      nAmort := i.aqpd114pri;
      if i.aqpd114cuo = pn_NroCuota then
         nAmort := pn_Monto;
      end IF;   
        
      if i.aqpd114form = 'COMNAC' then
        --COMNAC Interés compuesto: (del país)
        --Interés = ((1+tasa)^((días entre un pago y otro)/360)-1) * capital remanente
        nInteres := ((1 + (pn_Tasa/100)) ** ((i.aqpd114diacal) / i.aqpd114diaano) - 1) * nSaldo;
      else 
        --SIMEXT Interés simple: (del exterior)
        --I (interés) = C (capital) * R (tasa de interés) * T (tiempo)
        --Interés = capital remanente  * tasa/365 * (días entre un pago y otro)
        nInteres := nSaldo * (pn_Tasa/100) / i.aqpd114diaano * (i.aqpd114diacal);
      End if;
      nSaldo := nvl(nSaldo,0) - nAmort;
      Begin
        update aqpd114
           set aqpd114tas = pn_Tasa,
               aqpd114pri = nAmort,
               aqpd114int = nInteres,
               aqpd114sld = nSaldo,
               aqpd114freg = sysdate
         where aqpd114cor = i.aqpd114cor
           and aqpd114id = i.aqpd114id
           and aqpd114fdes = i.aqpd114fdes
           and aqpd114cuo = i.aqpd114cuo;
        Commit;
      Exception When others then
        pv_rpta := substr(SQLERRM, 1, 255);
      End;
      
    End loop;
  End SP_RECAL_ADEUDO;
   
 /*
  ------------------------------------------------------
  ------------------- INICIO REP 16A -------------------
  ------------------------------------------------------
  procedure SP_REP16A_REPORTE(pdFecha In Date, pdRpta out varchar2) is

  begin
    begin
      execute immediate 'truncate table aqpd110';
    exception
      when others then
        null;
    end;
    
    begin
      insert into aqpd110
      (AQPD110FEC, AQPD110TIP, AQPD110ORD, AQPD110DES, 
       AQPD110B1, AQPD110B2, AQPD110B3, AQPD110B4, AQPD110B5, AQPD110B6, AQPD110B7, AQPD110B8, AQPD110B9, AQPD110B10, AQPD110B11, AQPD110TOT, 
       AQPD110MND, AQPD110TDAT, AQPD110GTOT)
      select 
        FECHA, TIPO, ORDEN, DESCRIPCION,
        MES01, MES02, MES03, MES04, MES05, MES06, MES7A9, MES10A12, MES1A2A, MES2A5A, MES5A, TOTAL,
        MONEDA, TIPODATO, GRUPOTOTAL
      from dwhouse.FACT_RIES_ANEXO16A_REP@DW d
      where fecha = pdFecha;

      commit;
      pdRpta := 'S';
    exception
      when others then
        pdRpta := substr(SQLERRM, 1, 255);
    end;
  
  end SP_REP16A_REPORTE;

  ------------------------------------------------------
  procedure SP_16A_TRAER_CTAS_INV_DIS(pdFech in date,
                                      pcRpta out varchar2) is

  begin
    pcRpta := 'S';
    begin
      
      insert into aqpd109
      (aqpd109pgcod, aqpd109suc, aqpd109mda, aqpd109pap, aqpd109cta, aqpd109oper, aqpd109sbop, aqpd109top, aqpd109mod, aqpd109fech, 
       aqpd109fvto, aqpd109fvtoo, aqpd109sdmn, aqpd109sdmo, aqpd109rubr)
      select
       BCEMP, BCSUC, BCMDA, BCPAP, BCCTA, BCOPER, BCSBOP, BCTOP, BCMOD, BCFECH, 
       BCFVTO, BCFVTO, -BCSDMN, -BCSDMO, BCRUBR
      from dwhouse.fact_ries_fsh012@DW f
      left join aqpd109 a on 
       a.aqpd109pgcod = f.BCEMP and a.aqpd109suc = f.BCSUC and 
       a.aqpd109mda = f.BCMDA and a.aqpd109pap = f.BCPAP and 
       a.aqpd109cta = f.BCCTA and a.aqpd109oper = f.BCOPER and 
       a.aqpd109sbop = f.BCSBOP and a.aqpd109top = f.BCTOP and 
       a.aqpd109mod = f.BCMOD and a.aqpd109fech = f.BCFECH
      where bcfech = pdFech
       and (bcrubr like '13_3%' or
            bcrubr like '13_4%' or
            bcrubr like '13_803%')
      and aqpd109cta is null;
      
      commit;
    exception
      when others then
        pcRpta := substr(SQLERRM, 1, 255);
    end;
  
  end SP_16A_TRAER_CTAS_INV_DIS;

  ------------------------------------------------------
  procedure SP_16A_UPDATE_FCVTO(pnPgcod in number,
                            pnSuc in number,
                            pnMda in number,
                            pnPap in number,
                            pnCta in number,
                            pnOper in number,
                            pnSbop in number,
                            pnTop in number,
                            pnMod in number,
                            pdFech in date,
                            pdFvto in date,
                            pdRpta out varchar2) is

  begin
    pdRpta := 'S';
    begin
      update aqpd109
         set aqpd109fvto = pdFvto
       where aqpd109pgcod = pnPgcod
         and aqpd109suc = pnSuc
         and aqpd109mda = pnMda
         and aqpd109pap = pnPap
         and aqpd109cta = pnCta
         and aqpd109oper = pnOper
         and aqpd109sbop = pnSbop
         and aqpd109top = pnTop
         and aqpd109mod = pnMod
         and aqpd109fech = pdFech;
      commit;
    exception
      when others then
        pdRpta := substr(SQLERRM, 1, 255);
    end;
  
  end SP_16A_UPDATE_FCVTO;
    
  ------------------------------------------------------
  procedure SP_16A_GENERAR(pdFech in date,
                           pcRpta out varchar2)
  is
  begin
    pcRpta := 'S';
    begin
      DWHOUSE.PQ_RIES_ANEXOS_REPORTES.SP_A16A_GENERAR@DW(pdFech);
      commit;
    exception
      when others then
        pcRpta := substr(SQLERRM, 1, 255);
    end;
  
  end SP_16A_GENERAR;
  */
end PQ_CR_REP_ANX_RIES;
/
