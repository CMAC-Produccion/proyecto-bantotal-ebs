create or replace package PQ_CR_RESOLUTOR_RIESGOCAMB is

  -- Author  : MPOSTIGOC
  -- Created : 13/01/2016 04:46:54 p.m.
  -- Purpose : 

  procedure sp_cuentas(Pn_Pepais    in number,
                       Pn_Petdoc    in number,
                       Pn_Pendoc    in character,
                       ln_instancia in number,
                       lc_usuario   in char,
                       tipocambio   in number,
                       pd_fecpro    in date,
                       PV_RG5921    IN VARCHAR2, --efuentes
                       pv_progra    IN VARCHAR2, --efuentes
                       ln_captotal  out number);
  ------------------------------------------------------
  procedure sp_cuotas(ln_pgcod10    in number,
                      ln_mod10      in number,
                      ln_suc10      in number,
                      ln_mda10      in number,
                      ln_pap10      in number,
                      ln_cta10      in number,
                      ln_oper10     in number,
                      ln_sbop10     in number,
                      ln_tope10     in number,
                      ln_NRO_CUOTAS out number);
  -------------------------------------------------------
  procedure sp_instancia(ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         ln_SNG001Ori out number,
                         ln_instancia out number);
  -------------------------------------------------------
  procedure sp_cuota_impaga(ln_pgcod10    in number,
                            ln_mod10      in number,
                            ln_suc10      in number,
                            ln_mda10      in number,
                            ln_pap10      in number,
                            ln_cta10      in number,
                            ln_oper10     in number,
                            tipocambio    in number,
                            ln_NRO_CUOTAS in number,
                            ln_cuoimp     out number,
                            fech_maxcuota out date,
                            ln_ratio      out number);
  ---------------------------------------------------------
  --------------------------------------------------
  procedure sp_seguro(ln_mod10        in number,
                      ln_suc10        in number,
                      ln_mda10        in number,
                      ln_pap10        in number,
                      ln_cta10        in number,
                      ln_oper10       in number,
                      ln_sbop10       in number,
                      ln_tope10       in number,
                      tipocambio      in number,
                      fech_maxcuota   in date,
                      ln_monto_seguro out number);
  ----------------------------------------------------------

  procedure sp_capacidadlinea(ln_mod10     in number,
                              ln_suc10     in number,
                              ln_mda10     in number,
                              ln_pap10     in number,
                              ln_cta10     in number,
                              ln_oper10    in number,
                              ln_sbop10    in number,
                              ln_tope10    in number,
                              tipocambio   in number,
                              ln_nrocuotas in number,
                              ln_formula   out number,
                              ln_ratio     out number);

  ---------------------------------------------------------
  procedure sp_capcartfianza(ln_mod10   in number,
                             ln_suc10   in number,
                             ln_mda10   in number,
                             ln_pap10   in number,
                             ln_cta10   in number,
                             ln_oper10  in number,
                             ln_sbop10  in number,
                             ln_tope10  in number,
                             tipocambio in number,
                             ln_formula out number);
  --------------------------------------------------
  procedure sp_capacidadpago(ln_MAX_CUOTA    in number,
                             ln_NRO_CUOTAS   in number,
                             ln_SNG001Ori    in number,
                             ln_peri10       in number,
                             ln_monto_seguro in number,
                             ln_mod10        in number,
                             ln_instancia    in number,
                             tipocambio      in number,
                             ln_capacidad    out number,
                             ln_ratio        out number);
  -----------------------------------------------------
  procedure sp_resolutor(ln_Pepais    in number,
                         ln_Petdoc    in number,
                         ln_Pendoc    in character,
                         ln_instancia in number,
                         lc_usuario   in char,
                         pd_fecpro    in date,
                         ln_pgcod10   in number,
                         ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         ln_peri10    in number,
                         tipocambio   in number,
                         lc_TipCre    in varchar2,
                         pv_progra    IN VARCHAR2, --efuentes
                         ln_capacidad out number);
  ------------------------------------20160623abr-------------------------------------------------------
  Procedure Sp_ampliados_CK(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            Pc_flag   out varchar2); --20160623abr
  ------------------------------20160623abr----------------------------------------------------
  Procedure Sp_Adicional_CK(pn_mod  in number,
                            pn_top  in number,
                            Pc_flag out varchar2);
  -------------------------------------20160623ABR-------------------------------------------
  procedure sp_capacidadpago_Lin(ln_MAX_CUOTA    in number,
                                 ln_NRO_CUOTAS   in number,
                                 ln_peri10       in number,
                                 ln_monto_seguro in number,
                                 ln_mod10        in number,
                                 ln_capacidad    out number);
  -------------------------------------20160623ABR------------------------------------------------------
  procedure sp_cuota_impaga_Lin(ln_pgcod10    in number,
                                ln_mod10      in number,
                                ln_suc10      in number,
                                ln_mda10      in number,
                                ln_pap10      in number,
                                ln_cta10      in number,
                                ln_oper10     in number,
                                tipocambio    in number,
                                ln_cuoimp     out number,
                                fech_maxcuota out date);
  -----------------------------20160623abr--------------------------------------------------
  procedure sp_resolutor_venc(ln_pgcod10 in number, --20160623ABR
                              ln_mod10   in number,
                              ln_suc10   in number,
                              ln_mda10   in number,
                              ln_pap10   in number,
                              ln_cta10   in number,
                              ln_oper10  in number,
                              ln_sbop10  in number,
                              ln_tope10  in number,
                              --ln_peri10    in number,
                              tipocambio in number,
                              -- ln_indicador in number,
                              ln_capacidad out number);
  -- Modifier  : GCARRANZAS
  -- Created : 22/09/2020
  -- Purpose : AGREGAR LOG CABECERA
  PROCEDURE SP_INSERTA_AQPA981_CAB(PD_FPROC  DATE,
                                   PN_PAIS   NUMBER,
                                   PN_TDOC   NUMBER,
                                   PC_NDOC   CHAR,
                                   PN_INST   NUMBER,
                                   PV_EST    VARCHAR2,
                                   PV_USER   VARCHAR2,
                                   PN_CAPTOT NUMBER,
                                   PN_SALDOL NUMBER,
                                   PN_SALSOL NUMBER,
                                   PC_MONSOL CHAR,
                                   PC_DEUDOL CHAR,
                                   PC_DEUSOL CHAR,
                                   PN_VENDOL NUMBER,
                                   PN_VENSOL NUMBER,
                                   PN_TCAMB  NUMBER,
                                   PN_EXCDOL NUMBER,
                                   PN_EXCSOL NUMBER,
                                   PN_RESDOL NUMBER,
                                   PN_RESSOL NUMBER,
                                   PC_CA1    CHAR,
                                   PN_NA1    NUMBER,
                                   PD_FA1    DATE);
  -- Modifier  : GCARRANZAS
  -- Created : 22/09/2020
  -- Purpose : AGREGAR LOG DETALLE                                   
  PROCEDURE SP_INSERTA_LOG_AQPA982_DET(PD_FPROC   DATE,
                                       PN_PAIS    NUMBER,
                                       PN_TDOC    NUMBER,
                                       PC_NDOC    CHAR,
                                       PN_INST    NUMBER,
                                       PV_EST     VARCHAR2,
                                       PV_USER    VARCHAR2,
                                       PN_EMP     NUMBER,
                                       PN_SUC     NUMBER,
                                       PN_MOD     NUMBER,
                                       PN_MDA     NUMBER,
                                       PN_PAP     NUMBER,
                                       PN_CTA     NUMBER,
                                       PN_OPE     NUMBER,
                                       PN_SBO     NUMBER,
                                       PN_TOP     NUMBER,
                                       PN_NRCUO   NUMBER,
                                       PN_INSTV   NUMBER,
                                       PN_CUOIMP  NUMBER,
                                       PN_SEGURO  NUMBER,
                                       PN_CAPLIN  NUMBER,
                                       PN_CARFIA  NUMBER,
                                       PN_CAPCUOM NUMBER,
                                       PV_CA1     CHAR,
                                       PN_NA1     NUMBER,
                                       PD_FA1     DATE);

  -- AUTHOR  : GCARRANZAS
  -- Created : 24/09/2020
  -- Purpose : VERIFICAR LOGS  
  PROCEDURE SP_VALIDAR_LOG(PD_FPROC     IN DATE,
                           PN_INST      IN NUMBER,
                           PV_RESPUESTA OUT VARCHAR2);

  -------------------------------------------------------------

  PROCEDURE SP_INSERTA_AQPB612(PN_INST      IN NUMBER,
                               PV_EXCD      IN NUMBER,
                               PV_EXCS      IN NUMBER,
                               PV_RESD      IN NUMBER,
                               PV_RESS      IN NUMBER,
                               PN_RIESCAMBT IN NUMBER,
                               PV_USUARIO   IN VARCHAR2,
                               PV_RG5921    IN VARCHAR2);
  -------------------------------------------------------------
  -- VARIABLES RESOLUTOR 4002                  
  PROCEDURE SP_VAR_RESOLUTOR_4002(PN_INSTANCIA         IN NUMBER,
                                  TIPO_PERSONA         OUT CHARACTER,
                                  DES_PARCIAL          OUT NUMBER,
                                  SALARIO_DOL          OUT NUMBER,
                                  SALARIO_SOL          OUT NUMBER,
                                  MONEDA_SOLICITUD_SOL OUT CHARACTER,
                                  DEUDA_EN_DOLAR       OUT CHARACTER,
                                  DEUDA_EN_SOLES       OUT CHARACTER,
                                  VENTAS_DOL           OUT NUMBER,
                                  VENTAS_SOL           OUT NUMBER,
                                  RESULTADO_DOL        OUT NUMBER,
                                  RESULTADO_SOL        OUT NUMBER,
                                  EXCEDENTE_DOL        OUT NUMBER,
                                  EXCEDENTE_SOL        OUT NUMBER);
  -------------------------------------------------------------
  PROCEDURE SP_VAR_TIPO_PERSONA(PN_INSTANCIA IN NUMBER,
                                TIPO_PERSONA OUT CHARACTER);
  -------------------------------------------------------------
  PROCEDURE SP_VAR_DES_PARCIAL(PN_INSTANCIA IN NUMBER,
                               DES_PARCIAL  OUT NUMBER);
  -------------------------------------------------------------
  PROCEDURE SP_VAR_SALARIO_DOL(PN_INSTANCIA IN NUMBER,
                               SALARIO_DOL  OUT NUMBER);
  -------------------------------------------------------------
  PROCEDURE SP_VAR_SALARIO_SOL(PN_INSTANCIA IN NUMBER,
                               SALARIO_SOL  OUT NUMBER);
  -------------------------------------------------------------
  PROCEDURE SP_VAR_MONEDA_SOLICITUD_SOL(PN_INSTANCIA         IN NUMBER,
                                        MONEDA_SOLICITUD_SOL OUT CHARACTER);
  -------------------------------------------------------------
  PROCEDURE SP_VAR_DEUDA_EN_DOLAR(PN_INSTANCIA   IN NUMBER,
                                  DEUDA_EN_DOLAR OUT CHARACTER);
  -------------------------------------------------------------
  PROCEDURE SP_VAR_DEUDA_EN_SOLES(PN_INSTANCIA   IN NUMBER,
                                  DEUDA_EN_SOLES OUT CHARACTER);
  -------------------------------------------------------------
  PROCEDURE SP_VAR_VENTAS_DOL(PN_INSTANCIA IN NUMBER,
                              VENTAS_DOL   OUT NUMBER);
  -------------------------------------------------------------
  PROCEDURE SP_VAR_VENTAS_SOL(PN_INSTANCIA IN NUMBER,
                              VENTAS_SOL   OUT NUMBER);
  -------------------------------------------------------------
  PROCEDURE SP_VAR_RESULTADO_DOL(PN_INSTANCIA  IN NUMBER,
                                 RESULTADO_DOL OUT NUMBER);
  -------------------------------------------------------------
  PROCEDURE SP_VAR_RESULTADO_SOL(PN_INSTANCIA  IN NUMBER,
                                 RESULTADO_SOL OUT NUMBER);
  -------------------------------------------------------------
  PROCEDURE SP_VAR_EXCEDENTE_DOL(PN_INSTANCIA  IN NUMBER,
                                 EXCEDENTE_DOL OUT NUMBER);
  -------------------------------------------------------------
  PROCEDURE SP_VAR_EXCEDENTE_SOL(PN_INSTANCIA  IN NUMBER,
                                 EXCEDENTE_SOL OUT NUMBER);
  -------------------------------------------------------------
  PROCEDURE SP_VAR_TPO_CAMBIO(PN_INSTANCIA IN NUMBER,
                              TPO_CAMBIO   OUT NUMBER);
  -------------------------------------------------------------
  PROCEDURE SP_UPDATE_REGLAS(PN_INSTAN  IN NUMBER,
                             PV_RG5921  IN VARCHAR2,
                             PV_RG5922  IN VARCHAR2,
                             PV_USUARIO IN VARCHAR2,
                             PC_FLAG    OUT CHARACTER);
  -------------------------------------------------------------
  PROCEDURE SP_INSERT_REGLAS(PN_INSTAN  IN NUMBER,
                             PV_RG5921  IN VARCHAR2,
                             PV_RG5922  IN VARCHAR2,
                             PV_USUARIO IN VARCHAR2,
                             PD_FECPRO  IN DATE,
                             PC_FLAG    OUT CHARACTER);
  -------------------------------------------------------------
  PROCEDURE SP_VALIDAR_LOG_612(PN_INSTAN  IN NUMBER,
                               PV_USUARIO IN VARCHAR2,
                               PD_FECPRO  IN DATE,
                               PC_FLAG    OUT CHARACTER);
  -------------------------------------------------------------
end PQ_CR_RESOLUTOR_RIESGOCAMB;
/

create or replace package body PQ_CR_RESOLUTOR_RIESGOCAMB is

  --- RESOLUTOR SHOCK CAMBIARIO
  --  procedure sp_cuentas(Pn_Pepais IN number, Pn_Petdoc in number, Pn_Pendoc in character, ln_instancia in number, lc_usuario in char, tipocambio in number, pd_fecpro in date, ln_captotal out number)
  procedure sp_cuentas(Pn_Pepais    IN number,
                       Pn_Petdoc    in number,
                       Pn_Pendoc    in character,
                       ln_instancia in number,
                       lc_usuario   in char,
                       tipocambio   in number,
                       pd_fecpro    in date,
                       PV_RG5921    IN VARCHAR2, --efuentes
                       pv_progra    IN VARCHAR2, --efuentes
                       ln_captotal  out number) is
  
    ln_capacidad number;
  
    Ln_Pepais number;
    Ln_Petdoc number;
    Ln_Pendoc character(12);
  
    lc_fgAdic varchar2(1); --20160623abr
    lc_fgAmpl varchar2(1); --20160623abr
    lc_ven    char(1); --20160623abr
  
    cursor inserta is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
        from fsd010 d10
       where Pgcod = 1
         and Aocta in (select Ctnro
                         from fsr008
                        where pepais = ln_Pepais
                          and Petdoc = ln_Petdoc
                          and pendoc = ln_Pendoc
                          and Ttcod = 1
                          and Cttfir = 'T')
         and (Aomod in (select modulo
                          from fst111 f
                         where f.dscod = 50
                           and f.modulo not in (33, 200, 144)) or
             aomod in (117, 141))
         and Aostat <> 99
         and aofvto > pd_fecpro; --20160623ABR
  
    cursor vuelo is
      select x.xwfempresa ln_pgcod10,
             x.xwfmodulo ln_mod10,
             x.xwfsucursal ln_suc10,
             x.xwfmoneda ln_mda10,
             x.xwfpapel ln_pap10,
             x.xwfcuenta ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope ln_sbop10,
             x.xwftipope ln_tope10,
             max(s.sng120per) ln_peri10
        from xwf700 x, sng120 s
      --MODIF. 05032018
       where x.XWFEMPRESA = 1
         and x.xwfcuenta in (select Ctnro
                               from fsr008
                              where pepais = ln_Pepais
                                and Petdoc = ln_Petdoc
                                and pendoc = ln_Pendoc
                                and Ttcod = 1
                                and Cttfir = 'T')
         and (x.xwfmodulo in
             (select modulo
                 from fst111 f
                where f.dscod = 50
                  and f.modulo not in (33, 200, 144)) or
             x.xwfmodulo in (117, 141))
         and x.XWFPRCINS in
             (select wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                 and wf.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                            -- and wftaskcod <> 55 --20160623ABR
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd'))
                    -- and wftaskcod <> 55 --20160623ABR
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd'))
         and s.sng120ins = x.XWFPRCINS
         and x.xwfcar3 = '1' --20160623ABR
      
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope;
  
    --20160623ABR
    cursor lineas_ven is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
        from fsd010 d10
       where Pgcod = 1
         and Aocta in (select Ctnro
                         from fsr008
                        where pepais = ln_Pepais
                          and Petdoc = ln_Petdoc
                          and pendoc = ln_Pendoc
                          and Ttcod = 1
                          and Cttfir = 'T')
         and Aomod = 117
         and aofvto < pd_fecpro;
  
    --20160623ABR
    ln_periodo number;
  
    /*ln_salario_dol          number(17, 2);
    ln_salario_sol          number(17, 2);
    lc_moneda_solicitud_sol char(1);
    lc_deuda_dolar          char(1);
    lc_deuda_soles          char(1);
    ln_ventas_dol           number(17, 2);
    ln_ventas_sol           number(17, 2);
    ln_tipo_cambio          number(14, 8);
    ln_excedente_dol        number(17, 2);
    ln_excedente_sol        number(17, 2);
    ln_resultado_dol        number(17, 2);
    ln_resultado_sol        number(17, 2);*/
  
    ln_salario_dol          VARCHAR2(20);
    ln_salario_sol          VARCHAR2(20);
    lc_moneda_solicitud_sol VARCHAR2(5);
    lc_deuda_dolar          VARCHAR2(5);
    lc_deuda_soles          VARCHAR2(5);
    ln_ventas_dol           VARCHAR2(20);
    ln_ventas_sol           VARCHAR2(20);
    ln_tipo_cambio          VARCHAR2(20);
    ln_excedente_dol        VARCHAR2(20);
    ln_excedente_sol        VARCHAR2(20);
    ln_resultado_dol        VARCHAR2(20);
    ln_resultado_sol        VARCHAR2(20);
  
    lc_TipoCredito VARCHAR2(20);
  
  begin
  
    -- VERIFICAR VARIABLES DE ENTRADA 
    IF Pn_Pepais IS NULL OR Pn_Petdoc IS NULL OR Pn_Pendoc IS NULL THEN
      BEGIN
        SELECT F.PEPAIS, F.PETDOC, F.PENDOC
          INTO LN_PEPAIS, LN_PETDOC, LN_PENDOC
          FROM SNG001 S, FSR008 F
         WHERE F.PEPAIS = S.SNG001PAIS
           AND F.PETDOC = S.SNG001TDOC
           AND F.PENDOC = S.SNG001NDOC
           AND F.CTNRO = S.SNG001CTA
           AND F.TTCOD = 1
           AND F.CTTFIR = 'T'
           AND S.SNG001INST = LN_INSTANCIA;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RETURN;
      END;
    ELSE
      ln_Pepais := Pn_Pepais;
      Ln_Petdoc := Pn_Petdoc;
      Ln_Pendoc := Pn_Pendoc;
    END IF;
  
    IF ln_instancia IS NULL THEN
      RETURN;
    END IF;
  
    ln_captotal := 0;
  
    -- DESACTIVAR ANTIGUOS REGISTROS LOGS CABECERA
    IF pv_progra = 'RAQPB179' THEN
      BEGIN
        UPDATE AQPA981 J
           SET J.AQPA981EST = 'S'
         WHERE J.AQPA981INST = ln_instancia;
        COMMIT;
      END;
    
      -- DESACTIVAR ANTIGUOS REGISTROS LOGS DETALLE
      BEGIN
        UPDATE AQPA982 J
           SET J.AQPA982EST = 'S'
         WHERE J.AQPA982INST = ln_instancia;
        COMMIT;
      END;
    END IF;
    
    -- invocar al procedimiento de DENNIS para usar el tipo de cambio
    pq_cr_var_riesgo_cambiario.sp_total_variables_rc(ln_instancia,
                                                     ln_salario_dol,
                                                     ln_salario_sol,
                                                     lc_moneda_solicitud_sol,
                                                     lc_deuda_dolar,
                                                     lc_deuda_soles,
                                                     ln_ventas_dol,
                                                     ln_ventas_sol,
                                                     ln_tipo_cambio,
                                                     ln_excedente_dol,
                                                     ln_excedente_sol,
                                                     ln_resultado_dol,
                                                     ln_resultado_sol);
  
    /* efuentes validar tip cambio 20-09-2021*/
  
    ln_tipo_cambio := NVL(ln_tipo_cambio, 0);
    -- si el tipo de cambio fuera 0 o null o no existe usar la funcion     
    IF ln_tipo_cambio = 0 THEN
      BEGIN
        ln_tipo_cambio := fn_tipo_cambio_fijo(P_FECHA => pd_fecpro);
      EXCEPTION
        WHEN OTHERS THEN
          ln_tipo_cambio := 1;
      END;
    END IF;
  
    --tipocambio := ln_tipo_cambio;
    -- si el tipo de cambio es 0, consultar si vamos considerar el tipo cmbio d ela SNG120 task EVALUACION o
    -- tipo de cambio del dia -  en caso contrario si no hay tipo de cambio 1 - verificar
    -- Consultar sobre flujo de caja
    -- 
  
    for i in inserta loop
      lc_TipoCredito := 'VIGENTE'; --EFUENTES 20210719
      lc_fgAdic      := null; --20160623abr
      lc_fgAmpl      := null; --20160623abr  
    
      PQ_CR_RESOLUTOR_RIESGOCAMB.Sp_Adicional_CK(i.ln_mod10,
                                                 i.ln_tope10,
                                                 lc_fgAdic); --20160623abr
      PQ_CR_RESOLUTOR_RIESGOCAMB.Sp_ampliados_CK(i.ln_pgcod10,
                                                 i.ln_mod10,
                                                 i.ln_suc10,
                                                 i.ln_mda10,
                                                 i.ln_pap10,
                                                 i.ln_cta10,
                                                 i.ln_oper10,
                                                 i.ln_sbop10,
                                                 i.ln_tope10,
                                                 lc_fgAmpl); --20160623abr
    
      if lc_fgAdic <> 'S' and lc_fgAmpl <> 'S' and i.ln_tope10 <> 550 then
        --20160623abr
        PQ_CR_RESOLUTOR_RIESGOCAMB.sp_resolutor(ln_Pepais,
                                                ln_Petdoc,
                                                ln_Pendoc,
                                                ln_instancia,
                                                lc_usuario,
                                                pd_fecpro,
                                                i.ln_pgcod10,
                                                i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                i.ln_sbop10,
                                                i.ln_tope10,
                                                i.ln_peri10,
                                                ln_tipo_cambio,
                                                lc_TipoCredito,
                                                pv_progra, --efuentes
                                                ln_capacidad);
      
        ln_captotal := nvl(ln_captotal, 0) + nvl(ln_capacidad, 0);
      end if;
    end loop;
  
    for c in vuelo loop
      -- corresponde a creditos que estan en proceso
      lc_TipoCredito := 'VUELO'; --EFUENTES 20210719
      ln_periodo     := c.ln_peri10;
    
      begin
        select tp1imp1
          into ln_periodo
          from fst198 f
         where tp1cod = 1 -- mpostigoc 07.02.2022
         and tp1cod1 = 10801
           and tp1corr1 = 54
           and tp1corr2 = 1
           and tp1corr3 > 0
           and tp1nro2 = c.ln_mod10
           and tp1nro3 = c.ln_tope10;
      exception
        when no_data_found then
          ln_periodo := c.ln_peri10;
      end;
    
      ln_periodo := nvl(ln_periodo, 0);
    
      if ln_periodo = 0 then
        -- mpostigoc 22062020
      
        begin
          select x.xllperiodo
            into ln_periodo
            from x054023 x
           where x.xllpgcod = c.ln_pgcod10
             and x.xllaomod = c.ln_mod10
             and x.xllaosuc = c.ln_suc10
             and x.xllaomda = c.ln_mda10
             and x.xllaopap = c.ln_pap10
             and x.xllaocta = c.ln_cta10
             and x.xllaooper = c.ln_oper10
             and x.xllaosbop = c.ln_sbop10
             and x.xllaotop = c.ln_tope10;
        exception
          when others then
            ln_periodo := 30;
        end;
      end if;
    
      PQ_CR_RESOLUTOR_RIESGOCAMB.sp_resolutor(ln_Pepais,
                                              ln_Petdoc,
                                              ln_Pendoc,
                                              ln_instancia,
                                              lc_usuario,
                                              pd_fecpro,
                                              c.ln_pgcod10,
                                              c.ln_mod10,
                                              c.ln_suc10,
                                              c.ln_mda10,
                                              c.ln_pap10,
                                              c.ln_cta10,
                                              c.ln_oper10,
                                              c.ln_sbop10,
                                              c.ln_tope10,
                                              ln_periodo,
                                              ln_tipo_cambio,
                                              lc_TipoCredito,
                                              pv_progra, --efuentes
                                              ln_capacidad);
    
      ln_captotal := nvl(ln_captotal, 0) + nvl(ln_capacidad, 0);
    end loop;
  
    --20160623abr
    for j in lineas_ven loop
      lc_TipoCredito := 'VENCIDO'; --EFUENTES 20210719
      --ln_indicador := 3;
      begin
        select 'S'
          into lc_ven
          from fsr011 a, fsd010 b
         where a.r2cod = j.ln_pgcod10
           and a.r2mod = j.ln_mod10
           and a.r2suc = j.ln_suc10
           and a.r2mda = j.ln_mda10
           and a.r2pap = j.ln_pap10
           and a.r2cta = j.ln_cta10
           and a.r2oper = j.ln_oper10
           and a.r2sbop = j.ln_sbop10
           and a.r2tope = j.ln_tope10
           and a.r1cod = b.pgcod
           and a.r1mod = b.aomod
           and a.r1suc = b.aosuc
           and a.r1mda = b.aomda
           and a.r1pap = b.aopap
           and a.r1cta = b.aocta
           and a.r1oper = b.aooper
           and a.r1sbop = b.aosbop
           and a.r1tope = b.aotope
           and b.aostat <> 99
           and relcod = 46
           and rownum = 1;
      exception
        when no_data_found then
          lc_ven := 'N';
      end;
    
      lc_fgAdic := null;
    
      PQ_CR_RESOLUTOR_RIESGOCAMB.Sp_Adicional_CK(j.ln_mod10,
                                                 j.ln_tope10,
                                                 lc_fgAdic);
    
      if lc_ven = 'S' and lc_fgAdic <> 'S' then
        PQ_CR_RESOLUTOR_RIESGOCAMB.sp_resolutor_venc(j.ln_pgcod10,
                                                     j.ln_mod10,
                                                     j.ln_suc10,
                                                     j.ln_mda10,
                                                     j.ln_pap10,
                                                     j.ln_cta10,
                                                     j.ln_oper10,
                                                     j.ln_sbop10,
                                                     j.ln_tope10,
                                                     -- j.ln_peri10,
                                                     ln_tipo_cambio,
                                                     -- ln_indicador,
                                                     ln_capacidad);
      
        ln_captotal := nvl(ln_captotal, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
    --20160623abr
  
    --- log cabcera -- GCARRANZAS 22.09.20
  
    ln_salario_dol   := NVL(ln_salario_dol, '0');
    ln_salario_sol   := NVL(ln_salario_sol, '0');
    ln_ventas_dol    := NVL(ln_ventas_dol, '0');
    ln_ventas_sol    := NVL(ln_ventas_sol, '0');
    ln_tipo_cambio   := NVL(ln_tipo_cambio, '0');
    ln_excedente_dol := NVL(ln_excedente_dol, '0');
    ln_excedente_sol := NVL(ln_excedente_sol, '0');
    ln_resultado_dol := NVL(ln_resultado_dol, '0');
    ln_resultado_sol := NVL(ln_resultado_sol, '0');
  
    ln_captotal := ROUND(ln_captotal, 2);
  
    IF pv_progra = 'RAQPB179' THEN
      PQ_CR_RESOLUTOR_RIESGOCAMB.SP_INSERTA_AQPA981_CAB(pd_fecpro,
                                                        ln_Pepais,
                                                        ln_Petdoc,
                                                        ln_Pendoc,
                                                        ln_instancia,
                                                        'G', --ACTIVO
                                                        lc_usuario,
                                                        ln_captotal,
                                                        TO_NUMBER(ln_salario_dol),
                                                        TO_NUMBER(ln_salario_sol),
                                                        lc_moneda_solicitud_sol,
                                                        lc_deuda_dolar,
                                                        lc_deuda_soles,
                                                        TO_NUMBER(ln_ventas_dol),
                                                        TO_NUMBER(ln_ventas_sol),
                                                        TO_NUMBER(ln_tipo_cambio),
                                                        TO_NUMBER(ln_excedente_dol),
                                                        TO_NUMBER(ln_excedente_sol),
                                                        TO_NUMBER(ln_resultado_dol),
                                                        TO_NUMBER(ln_resultado_sol),
                                                        NULL,
                                                        NULL,
                                                        NULL);
    
      --AQPB6012
      PQ_CR_RESOLUTOR_RIESGOCAMB.SP_INSERTA_AQPB612(ln_instancia,
                                                    TO_NUMBER(ln_excedente_dol),
                                                    TO_NUMBER(ln_excedente_sol),
                                                    TO_NUMBER(ln_resultado_dol),
                                                    TO_NUMBER(ln_resultado_sol),
                                                    ln_captotal,
                                                    trim(lc_usuario),
                                                    PV_RG5921);
    
    END IF;
  
    --                                                      TO_NUMBER(ln_ventas_dol),
    --                                                      TO_NUMBER(ln_ventas_sol),
    --                                                      TO_NUMBER(ln_tipo_cambio),
  
  end sp_cuentas;
  --------------------------------------------------------------------------------

  procedure sp_cuotas(ln_pgcod10    in number,
                      ln_mod10      in number,
                      ln_suc10      in number,
                      ln_mda10      in number,
                      ln_pap10      in number,
                      ln_cta10      in number,
                      ln_oper10     in number,
                      ln_sbop10     in number,
                      ln_tope10     in number,
                      ln_NRO_CUOTAS out number) is
  begin
    begin
    
      select count(*)
        into ln_NRO_CUOTAS
        from fsd601
       where Pgcod = ln_pgcod10
         and Ppmod = ln_mod10
         and Ppsuc = ln_suc10
         and Ppmda = ln_mda10
         and Pppap = ln_pap10
         and Ppcta = ln_cta10
         and Ppoper = ln_oper10
         and Ppsbop = ln_sbop10
         and Pptope = ln_tope10
         and D601co in ('S', 'X');
    exception
      when others then
        null;
    end;
  
  end sp_cuotas;
  ----------------------------------------------------
  procedure sp_instancia(ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         ln_SNG001Ori out number,
                         ln_instancia out number) is
  
    -- ln_instancia number;
  
  begin
    begin
      sp_instancia_credito(v_Scmod     => ln_mod10,
                           v_Scsuc     => ln_suc10,
                           v_Scmda     => ln_mda10,
                           v_Scpap     => ln_pap10,
                           v_Sccta     => ln_cta10,
                           v_Scoper    => ln_oper10,
                           v_Scsbop    => ln_sbop10,
                           v_Sctope    => ln_tope10,
                           v_instancia => ln_instancia);
    end;
  
    begin
      select SNG001Ori
        into ln_SNG001Ori
        from sng001 s01
       where s01.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
  end sp_instancia;

  ---CUOTA IMPAGA --------------------------
  procedure sp_cuota_impaga(ln_pgcod10    in number,
                            ln_mod10      in number,
                            ln_suc10      in number,
                            ln_mda10      in number,
                            ln_pap10      in number,
                            ln_cta10      in number,
                            ln_oper10     in number,
                            tipocambio    in number,
                            ln_NRO_CUOTAS in number,
                            ln_cuoimp     out number,
                            fech_maxcuota out date,
                            ln_ratio      out number) -- EFUENTES 20210719
   is
  
    lc_estado character(1);
    ld_fecha  date;
    /*ln_r1mod  number;
    ln_r1suc  number;
    ln_r1mda  number;
    ln_r1pap  number;
    ln_r1cta  number;
    ln_r1oper number;
    ln_r1cod  number;*/
  
  begin
  
    if ln_mod10 <> 117 then
    
      BEGIN
        select max(ppfpag)
          into ld_fecha
          from fsd602
         where pgcod = ln_pgcod10
           and ppmod = ln_mod10
           and ppsuc = ln_suc10
           and ppmda = ln_mda10
           and pppap = ln_pap10
           and ppcta = ln_cta10
           and ppoper = ln_oper10;
      exception
        when others then
          NULL;
        
      END;
    
      begin
        select max(f602.pp1stat) --, ppfpag
          into lc_estado
          from fsd602 f602
         where f602.pgcod = ln_pgcod10
           and f602.ppmod = ln_mod10
           and f602.ppsuc = ln_suc10
           and f602.ppmda = ln_mda10
           and f602.pppap = ln_pap10
           and f602.ppcta = ln_cta10
           and f602.ppoper = ln_oper10
           and f602.ppfpag = ld_fecha;
      exception
        when others then
          NULL;
      end;
    
      if lc_estado = 'T' or lc_estado = 'P' then
        begin
          select max(ppcap + ppint)
            into ln_cuoimp
            from fsd601
           where pgcod = ln_pgcod10
             and ppmod = ln_mod10
             and ppsuc = ln_suc10
             and ppmda = ln_mda10
             and pppap = ln_pap10
             and ppcta = ln_cta10
             and ppoper = ln_oper10
             and ppfpag > ld_fecha;
          -- and rownum = 1;
        exception
          when too_many_rows then
            begin
              select max(ppcap + ppint)
                into ln_cuoimp
                from fsd601
               where pgcod = ln_pgcod10
                 and ppmod = ln_mod10
                 and ppsuc = ln_suc10
                 and ppmda = ln_mda10
                 and pppap = ln_pap10
                 and ppcta = ln_cta10
                 and ppoper = ln_oper10
                 and ppfpag > ld_fecha
                 and rownum = 1;
            exception
              when others then
              
                NULL;
            end;
        end;
      
      else
        if lc_estado is null then
          begin
            select max(ppcap + ppint)
              into ln_cuoimp
              from fsd601 d
             where pgcod = ln_pgcod10
               and ppmod = ln_mod10
               and ppsuc = ln_suc10
               and ppmda = ln_mda10
               and pppap = ln_pap10
               and ppcta = ln_cta10
               and ppoper = ln_oper10;
          exception
            when others then
            
              NULL;
          end;
        
        end if;
      
      end if;
    
      begin
        select d.ppfpag
          into fech_maxcuota
          from fsd601 d
         where pgcod = ln_pgcod10
           and ppmod = ln_mod10
           and ppsuc = ln_suc10
           and ppmda = ln_mda10
           and pppap = ln_pap10
           and ppcta = ln_cta10
           and ppoper = ln_oper10
           and (ppcap + ppint) = ln_cuoimp
           and rownum = 1;
      exception
        when others then
          NULL;
      end;
    
      --  end if;
    
      if ln_mda10 = 101 and ln_NRO_CUOTAS > 12 then
        ln_cuoimp := nvl(ln_cuoimp, 0) * nvl(tipocambio, 0) * 1.2;
        ln_ratio  := 1.2;
      else
        if ln_mda10 = 101 and ln_NRO_CUOTAS <= 12 then
          ln_cuoimp := nvl(ln_cuoimp, 0) * nvl(tipocambio, 0) * 1.1;
          ln_ratio  := 1.1;
        end if;
      end if;
    
    end if;
  
  end sp_cuota_impaga;
  --------------------------------------------------
  procedure sp_seguro(ln_mod10        in number,
                      ln_suc10        in number,
                      ln_mda10        in number,
                      ln_pap10        in number,
                      ln_cta10        in number,
                      ln_oper10       in number,
                      ln_sbop10       in number,
                      ln_tope10       in number,
                      tipocambio      in number,
                      fech_maxcuota   in date,
                      ln_monto_seguro out number) is
  
  begin
    begin
      select sum(ppimp10 + ppimp11 + ppimp12 + ppimp13)
        into ln_monto_seguro
        from fsd611
       where Pgcod = 1
         and Ppmod = ln_mod10
         and Ppsuc = ln_suc10
         and Ppmda = ln_mda10
         and Pppap = ln_pap10
         and Ppcta = ln_cta10
         and Ppoper = ln_oper10
         and Ppsbop = ln_sbop10
         and Pptope = ln_tope10
         and ppfpag = fech_maxcuota;
    exception
      when others then
        null;
    end;
  
    if ln_mda10 = 101 then
      ln_monto_seguro := nvl(ln_monto_seguro, 0) * nvl(tipocambio, 0);
    end if;
  
    ln_monto_seguro := nvl(ln_monto_seguro, 0);
  
  end sp_seguro;
  --------------------------------------------------

  procedure sp_capacidadlinea(ln_mod10     in number,
                              ln_suc10     in number,
                              ln_mda10     in number,
                              ln_pap10     in number,
                              ln_cta10     in number,
                              ln_oper10    in number,
                              ln_sbop10    in number,
                              ln_tope10    in number,
                              tipocambio   in number,
                              ln_nrocuotas in number,
                              ln_formula   out number,
                              ln_ratio     out number) -- EFUENTES 20210719
   is
  
    ln_plazo  number(10, 2);
    ln_tasa   number(10, 3);
    ln_saldo  number(10, 2);
    instancia number(10);
    --sum_paralelo number;  20160623abr
  
  begin
  
    begin
      select f.pp028defn
        into ln_plazo
        from fpp028 f
       where f.pp017par = 103
         and f.pp028mod = 116
         and f.pp028top = ln_tope10
         and f.pp028mda = ln_mda10; -- plazo
    exception
      when others then
        null;
    end;
  
    begin
      select aotasa, aoimp
        into ln_tasa, ln_saldo
        from fsd010
       where aocta = ln_cta10
         and aooper = ln_oper10
         and aomod = ln_mod10
         and aosuc = ln_suc10
         and aomda = ln_mda10
         and aopap = ln_pap10
         and aosbop = ln_sbop10
         and aotope = ln_tope10; --tasa
    exception
      when others then
        null;
    end;
  
    if ln_saldo is null then
      begin
        select x.xwfmonto1, x.xwfprcins
          into ln_saldo, instancia
          from xwf700 x
         where x.xwfempresa = 1
           and x.xwfsucursal = ln_suc10
           and x.xwfmodulo = ln_mod10
           and x.xwfmoneda = ln_mda10
           and x.xwfpapel = ln_pap10
           and x.xwfcuenta = ln_cta10
           and x.xwfoperacion = ln_oper10
           and x.xwfsubope = ln_sbop10
           and x.xwftipope = ln_tope10;
      exception
        when others then
          null;
        
      end;
    
      begin
        select max(sng120tasa)
          into ln_tasa
          from sng120
         where sng120ins = instancia;
      exception
        when others then
          null;
      end;
    end if;
    
    --EFUENTES 2021.10.14 SI ES QUE LA TASA ES 0 O ES NULL
    if ln_tasa is null or ln_tasa = 0.000000 or ln_tasa = 0 then
      begin
        select x.xlltasap
          into ln_tasa
          from x054023 x
         where x.xllpgcod = 1
           and x.xllaosuc = ln_suc10
           and x.xllaomod = ln_mod10
           and x.xllaomda = ln_mda10
           and x.xllaopap = ln_pap10
           and x.xllaocta = ln_cta10
           and x.xllaooper = ln_oper10
           and x.xllaosbop = ln_sbop10
           and x.xllaotop = ln_tope10;
      exception
        when others then
          null;
      end;
    end if;
    
    if ln_mda10 = 101 then
      ln_saldo := ln_saldo * tipocambio;
    end if;
  
    begin
    
      ln_formula := (ln_saldo *
                    ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)) /
                    (1 - power((1 +
                               ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)),
                               -ln_plazo));
    
    end;
  
    if ln_mda10 = 101 and ln_plazo > 12 then
      ln_formula := nvl(ln_formula, 0) * 1.2;
      ln_ratio   := 1.2;
    else
      if ln_mda10 = 101 and ln_plazo <= 12 then
        ln_formula := nvl(ln_formula, 0) * 1.1;
        ln_ratio   := 1.1;
      end if;
    
    end if;
  
  end sp_capacidadlinea;

  ------------------------------------------------------------
  procedure sp_capcartfianza(ln_mod10   in number,
                             ln_suc10   in number,
                             ln_mda10   in number,
                             ln_pap10   in number,
                             ln_cta10   in number,
                             ln_oper10  in number,
                             ln_sbop10  in number,
                             ln_tope10  in number,
                             tipocambio in number,
                             ln_formula out number) is
  
    --ln_plazo number(10, 2);
    ln_tasa  number(10, 3);
    ln_saldo number(10, 2);
  
  begin
    begin
      select tpimp
        into ln_tasa
        from fst098
       where pgcod = 1
         and tpcod = 7697
         and tpcorr = 1
         and tpnro = 141;
    exception
      when others then
        null;
    end;
  
    begin
      select aoimp
        into ln_saldo
        from fsd010
       where aocta = ln_cta10
         and aooper = ln_oper10
         and aomod = ln_mod10
         and aosuc = ln_suc10
         and aomda = ln_mda10
         and aopap = ln_pap10
         and aosbop = ln_sbop10
         and aotope = ln_tope10; --tasa
    exception
      when others then
        null;
    end;
  
    if ln_saldo is null then
      begin
        select x.xwfmonto1
          into ln_saldo
          from xwf700 x
         where x.xwfempresa = 1
           and x.xwfsucursal = ln_suc10
           and x.xwfmodulo = ln_mod10
           and x.xwfmoneda = ln_mda10
           and x.xwfpapel = ln_pap10
           and x.xwfcuenta = ln_cta10
           and x.xwfoperacion = ln_oper10
           and x.xwfsubope = ln_sbop10
           and x.xwftipope = ln_tope10;
      exception
        when others then
          null;
        
      end;
    end if;
  
    ln_saldo := ((30 * ln_saldo) / 100);
  
    if ln_mda10 = 101 then
      ln_saldo := ln_saldo * tipocambio;
    end if;
  
    begin
    
      ln_formula := (ln_saldo *
                    ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)) /
                    (1 - power((1 +
                               ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)),
                               -24));
    end;
  
  end sp_capcartfianza;

  -----------------------------------------------------------
  procedure sp_capacidadpago(ln_MAX_CUOTA    in number,
                             ln_NRO_CUOTAS   in number,
                             ln_SNG001Ori    in number,
                             ln_peri10       in number,
                             ln_monto_seguro in number,
                             ln_mod10        in number,
                             ln_instancia    in number,
                             tipocambio      in number,
                             ln_capacidad    out number,
                             ln_ratio        out number) -- EFUENTES 20210719
   is
    ln_mensual  number;
    ln_cuota    number;
    ln_sngmda   number;
    ln_cuotaimp number;
  
  begin
  
    begin
    
      if ln_mod10 <> 117 then
      
        if ln_NRO_CUOTAS > 1 and ln_SNG001Ori <> 7 and ln_peri10 > 0 then
        
          ln_mensual := ln_peri10 / 30;
        
          -- ln_cuota := ln_MAX_CUOTA / ln_mensual;
          ln_cuota := nvl(ln_MAX_CUOTA, 0) + nvl(ln_monto_seguro, 0);
          --   ln_capacidad := nvl(ln_cuota, 0) + nvl(ln_monto_seguro, 0);
        
          ln_capacidad := nvl(ln_cuota, 0) / nvl(ln_mensual, 0);
        
        else
          if ln_NRO_CUOTAS > 1 and ln_SNG001Ori = 7 then
          
            begin
              select sng120vcuo, sng120mda
                into ln_cuotaimp, ln_sngmda
                from sng120
               where SNG120INS = ln_instancia
                 and sng120mod = ln_mod10;
            exception
              when others then
                NULL;
            end;
          
            if ln_sngmda = 101 and ln_NRO_CUOTAS > 12 then
              ln_cuotaimp := nvl(ln_cuotaimp, 0) * nvl(tipocambio, 0) * 1.2;
              ln_ratio    := 1.2;
            else
              if ln_sngmda = 101 and ln_NRO_CUOTAS <= 12 then
                ln_cuotaimp := nvl(ln_cuotaimp, 0) * nvl(tipocambio, 0) * 1.1;
                ln_ratio    := 1.1;
              end if;
            
            end if;
          
            ln_mensual := ln_peri10 / 30;
          
            ln_cuota := ln_cuotaimp / ln_mensual;
          
            ln_capacidad := nvl(ln_cuota, 0) + nvl(ln_monto_seguro, 0);
          end if;
        
        end if;
      end if;
    end;
  end sp_capacidadpago;

  --------------------------------------------------
  procedure sp_resolutor(ln_Pepais    in number,
                         ln_Petdoc    in number,
                         ln_Pendoc    in character,
                         ln_instancia in number,
                         lc_usuario   in char,
                         pd_fecpro    in date,
                         ln_pgcod10   in number,
                         ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         ln_peri10    in number,
                         tipocambio   in number,
                         lc_TipCre    in varchar2,
                         pv_progra    IN VARCHAR2, --efuentes
                         ln_capacidad out number) is
    ln_nrocuotas  number;
    ln_parciales  number;
    ln_cuotimp    number;
    ln_seguro     number;
    fech_maxcuota date;
    ln_instanciav number;
  
    ln_capacidad_linea      number;
    ln_capacidad_cartfianza number;
    ln_capacidad_pago       number;
  
    ln_ratio_CuoImp number;
    ln_ratio_CapLin number;
    ln_ratio_CapPag number;
    ln_ratio        number;
  
  begin
    PQ_CR_RESOLUTOR_RIESGOCAMB.sp_cuotas(ln_pgcod10,
                                         ln_mod10,
                                         ln_suc10,
                                         ln_mda10,
                                         ln_pap10,
                                         ln_cta10,
                                         ln_oper10,
                                         ln_sbop10,
                                         ln_tope10,
                                         ln_nrocuotas); --log detalle
  
    PQ_CR_RESOLUTOR_RIESGOCAMB.sp_instancia(ln_mod10,
                                            ln_suc10,
                                            ln_mda10,
                                            ln_pap10,
                                            ln_cta10,
                                            ln_oper10,
                                            ln_sbop10,
                                            ln_tope10,
                                            ln_parciales,
                                            ln_instanciav); --log detalle
  
    if ln_mod10 <> 117 and ln_mod10 <> 141 then
      PQ_CR_RESOLUTOR_RIESGOCAMB.sp_cuota_impaga(ln_pgcod10,
                                                 ln_mod10,
                                                 ln_suc10,
                                                 ln_mda10,
                                                 ln_pap10,
                                                 ln_cta10,
                                                 ln_oper10,
                                                 tipocambio,
                                                 ln_nrocuotas,
                                                 ln_cuotimp, --log detalle
                                                 fech_maxcuota,
                                                 ln_ratio_CuoImp); -- EFUENTES 20210719
    
      ln_ratio := ln_ratio_CuoImp;
    end if;
  
    PQ_CR_RESOLUTOR_RIESGOCAMB.sp_seguro(ln_mod10,
                                         ln_suc10,
                                         ln_mda10,
                                         ln_pap10,
                                         ln_cta10,
                                         ln_oper10,
                                         ln_sbop10,
                                         ln_tope10,
                                         tipocambio,
                                         fech_maxcuota,
                                         ln_seguro); --log detalle
  
    if ln_mod10 = 117 and ln_tope10 not in (2, 4) then
      PQ_CR_RESOLUTOR_RIESGOCAMB.sp_capacidadlinea(ln_mod10,
                                                   ln_suc10,
                                                   ln_mda10,
                                                   ln_pap10,
                                                   ln_cta10,
                                                   ln_oper10,
                                                   ln_sbop10,
                                                   ln_tope10,
                                                   tipocambio,
                                                   ln_nrocuotas,
                                                   ln_capacidad, --log detalle
                                                   ln_ratio_CapLin); -- EFUENTES 20210719
    
      ln_capacidad_linea := ln_capacidad;
    
    end if;
  
    if ln_mod10 = 141 then
      PQ_CR_RESOLUTOR_RIESGOCAMB.sp_capcartfianza(ln_mod10,
                                                  ln_suc10,
                                                  ln_mda10,
                                                  ln_pap10,
                                                  ln_cta10,
                                                  ln_oper10,
                                                  ln_sbop10,
                                                  ln_tope10,
                                                  tipocambio, --log detalle
                                                  ln_capacidad); -- EFUENTES 20210719
      ln_capacidad_cartfianza := ln_capacidad;
    end if;
  
    if ln_mod10 <> 117 and ln_mod10 <> 141 then
      PQ_CR_RESOLUTOR_RIESGOCAMB.sp_capacidadpago(ln_cuotimp,
                                                  ln_nrocuotas,
                                                  ln_parciales,
                                                  ln_peri10, --log detalle
                                                  ln_seguro,
                                                  ln_mod10,
                                                  ln_instanciav,
                                                  tipocambio,
                                                  ln_capacidad,
                                                  ln_ratio_CapPag); --log detalle CAPCUOMENSUAL
    end if;
  
    ln_capacidad_pago := ln_capacidad;
  
    ln_nrocuotas            := NVL(ln_nrocuotas, 0);
    ln_cuotimp              := NVL(ln_cuotimp, 0);
    ln_seguro               := NVL(ln_seguro, 0);
    ln_capacidad_linea      := NVL(ln_capacidad_linea, 0);
    ln_capacidad_cartfianza := NVL(ln_capacidad_cartfianza, 0);
    ln_capacidad_pago       := NVL(ln_capacidad_pago, 0);
  
    ln_ratio_CapLin := NVL(ln_ratio_CapLin, -1);
    ln_ratio_CapPag := NVL(ln_ratio_CapPag, -1);
  
    if ln_ratio_CapLin != -1 then
      IF ln_ratio_CapLin > ln_ratio_CuoImp then
        ln_ratio := ln_ratio_CapLin;
      END IF;
    end if;
  
    if ln_ratio_CapPag != -1 then
      IF ln_ratio_CapPag > ln_ratio_CuoImp then
        ln_ratio := ln_ratio_CapPag;
      END IF;
      IF ln_ratio_CapPag > ln_ratio_CapLin then
        ln_ratio := ln_ratio_CapPag;
      END IF;
    end if;
  
    ln_ratio := NVL(ln_ratio, 0);
  
    IF pv_progra = 'RAQPB179' THEN
      -- Log detalle
      -- Grabar en el detalle ln_CuotaCF ln_CuoLinea ln_capacidad y los otros datos
      PQ_CR_RESOLUTOR_RIESGOCAMB.sp_inserta_log_aqpa982_det(pd_fecpro,
                                                            ln_Pepais,
                                                            ln_Petdoc,
                                                            ln_Pendoc,
                                                            ln_instancia,
                                                            'G',
                                                            lc_usuario,
                                                            ln_pgcod10,
                                                            ln_suc10,
                                                            ln_mod10,
                                                            ln_mda10,
                                                            ln_pap10,
                                                            ln_cta10,
                                                            ln_oper10,
                                                            ln_sbop10,
                                                            ln_tope10,
                                                            ln_nrocuotas,
                                                            ln_instanciav,
                                                            ln_cuotimp,
                                                            ln_seguro,
                                                            ln_capacidad_linea,
                                                            ln_capacidad_cartfianza,
                                                            ln_capacidad_pago,
                                                            lc_TipCre,
                                                            ln_ratio,
                                                            null);
    END IF;
  
  end sp_resolutor;

  ------------------------------------20160623abr-------------------------------------------------------
  Procedure Sp_ampliados_CK(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            Pc_flag   out varchar2) is
    --20160623abr
    ln_instancia number(15);
    lc_flag      varchar2(2);
  
  begin
  
    /*begin
      select 'S'
        into Pc_flag
        from xwf700 a
       where a.xwfempresa = ln_emp10
         and a.xwfsucursal = ln_suc10
         and a.xwfmodulo = ln_mod10
         and a.xwfmoneda = ln_mda10
         and a.xwfpapel = ln_pap10
         and a.xwfcuenta = ln_cta10
         and a.xwfoperacion = ln_oper10
         and a.xwfsubope = ln_sbop10
         and a.xwftipope = ln_tope10
         and a.xwfcar3 not in ('1','A','G')
         and rownum = 1;
    exception
      when no_data_found then
        Pc_flag := 'N';
    end;*/
  
    --  lc_flag := 'N';
    Pc_flag := 'N';
  
    begin
      select s.sng001inst, 'S'
        into ln_instancia, lc_flag
        from sng001 s
       where sng001inst in (select a.xwfprcins
                              from xwf700 a
                             where a.xwfempresa = ln_emp10
                               and a.xwfsucursal = ln_suc10
                               and a.xwfmodulo = ln_mod10
                               and a.xwfmoneda = ln_mda10
                               and a.xwfpapel = ln_pap10
                               and a.xwfcuenta = ln_cta10
                               and a.xwfoperacion = ln_oper10
                               and a.xwfsubope = ln_sbop10
                               and a.xwftipope = ln_tope10
                               and a.xwfcar3 in ('G', 'S', 'R')
                               and rownum = 1) -- G AMPLIADO, S REPROGRAMADO, R REFINANCIADO
         and s.sng001ori in (3, 4, 13, 14, 15);
    exception
      when others then
        lc_flag := 'N';
        -- and a.xwfcar3 not in ('1','A','G')
      --  and rownum = 1;
    
    end;
  
    if lc_flag = 'S' then
    
      begin
        select 'N'
          into Pc_flag
          from wfwrkitems w
         WHERE wfinsprcid = ln_instancia
           and w.wftaskcod = 55;
      exception
        when others then
          Pc_flag := 'S';
        
      end;
      /*else
      Pc_flag := 'S';*/
    end if;
  
  end Sp_ampliados_CK;
  -------------------------------20160623abr----------------------------------------------------
  Procedure Sp_Adicional_CK(pn_mod  in number,
                            pn_top  in number,
                            Pc_flag out varchar2) is --mod 2016.04.12
  
  begin
    if pn_mod = 117 then
      begin
        select 'S'
          into Pc_flag
          from fst198 a
        --MODIF 05.03.2018          
         where a.tp1cod = 1
           and a.tp1cod1 = 20001
           and a.tp1corr1 = 1
           and a.tp1corr2 = 1211
           and a.tp1nro1 = pn_top;
      
      exception
        when no_data_found then
          Pc_flag := 'N';
      end;
    else
      Pc_flag := 'N';
    end if;
  
  end Sp_Adicional_CK;

  -----------------------------20160623abr--------------------------------------------------
  procedure sp_resolutor_venc(ln_pgcod10 in number, --20160623ABR
                              ln_mod10   in number,
                              ln_suc10   in number,
                              ln_mda10   in number,
                              ln_pap10   in number,
                              ln_cta10   in number,
                              ln_oper10  in number,
                              ln_sbop10  in number,
                              ln_tope10  in number,
                              --ln_peri10    in number,
                              tipocambio in number,
                              -- ln_indicador in number,
                              ln_capacidad out number) is
    ln_nrocuotas number;
    -- ln_parciales  number;
    ln_cuotimp    number;
    ln_seguro     number;
    fech_maxcuota date;
    --   ln_instancia  number;
    lc_ven char(1);
  
    cursor creditos is
      select a.r1cod  ln_pgcod10,
             a.r1mod  ln_mod10,
             a.r1suc  ln_suc10,
             a.r1mda  ln_mda10,
             a.r1pap  ln_pap10,
             a.r1cta  ln_cta10,
             a.r1oper ln_oper10,
             a.r1sbop ln_sbop10,
             a.r1tope ln_tope10
        from fsr011 a, fsd010 b
       where a.r2cod = ln_pgcod10
         and a.r2mod = ln_mod10
         and a.r2suc = ln_suc10
         and a.r2mda = ln_mda10
         and a.r2pap = ln_pap10
         and a.r2cta = ln_cta10
         and a.r2oper = ln_oper10
         and a.r2sbop = ln_sbop10
         and a.r2tope = ln_tope10
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and b.aostat <> 99
         and relcod = 46;
  
    ln_pr116  number;
    ln_capTem number;
  
  begin
  
    begin
      select 'S'
        into lc_ven
        from fsr011 a, fsd010 b
       where a.r2cod = ln_pgcod10
         and a.r2mod = ln_mod10
         and a.r2suc = ln_suc10
         and a.r2mda = ln_mda10
         and a.r2pap = ln_pap10
         and a.r2cta = ln_cta10
         and a.r2oper = ln_oper10
         and a.r2sbop = ln_sbop10
         and a.r2tope = ln_tope10
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and b.aostat <> 99
         and relcod = 46
         and rownum = 1;
    exception
      when no_data_found then
        lc_ven := 'N';
    end;
  
    if lc_ven = 'S' then
      for i in creditos loop
      
        PQ_CR_RESOLUTOR_RIESGOCAMB.sp_cuotas(i.ln_pgcod10,
                                             i.ln_mod10,
                                             i.ln_suc10,
                                             i.ln_mda10,
                                             i.ln_pap10,
                                             i.ln_cta10,
                                             i.ln_oper10,
                                             i.ln_sbop10,
                                             i.ln_tope10,
                                             ln_nrocuotas);
        begin
          select a.aoperiod
            into ln_pr116
            from fsd010 a
           where a.pgcod = i.ln_pgcod10
             and a.aomod = i.ln_mod10
             and a.aosuc = i.ln_suc10
             and a.aomda = i.ln_mda10
             and a.aopap = i.ln_pap10
             and a.aocta = i.ln_cta10
             and a.aooper = i.ln_oper10
             and a.aosbop = i.ln_sbop10
             and a.aotope = i.ln_tope10;
        exception
          when others then
            null;
        end;
      
        PQ_CR_RESOLUTOR_RIESGOCAMB.sp_cuota_impaga_lin(i.ln_pgcod10,
                                                       i.ln_mod10,
                                                       i.ln_suc10,
                                                       i.ln_mda10,
                                                       i.ln_pap10,
                                                       i.ln_cta10,
                                                       i.ln_oper10,
                                                       tipocambio,
                                                       ln_cuotimp,
                                                       fech_maxcuota);
      
        PQ_CR_RESOLUTOR_RIESGOCAMB.sp_seguro(i.ln_mod10,
                                             i.ln_suc10,
                                             i.ln_mda10,
                                             i.ln_pap10,
                                             i.ln_cta10,
                                             i.ln_oper10,
                                             i.ln_sbop10,
                                             i.ln_tope10,
                                             tipocambio,
                                             fech_maxcuota,
                                             ln_seguro);
        PQ_CR_RESOLUTOR_RIESGOCAMB.sp_capacidadpago_lin(ln_cuotimp,
                                                        ln_nrocuotas,
                                                        ln_pr116,
                                                        ln_seguro,
                                                        i.ln_mod10,
                                                        ln_capTem);
      
        ln_capacidad := nvl(ln_capacidad, 0) + nvl(ln_capTem, 0);
      
      end loop;
    end if;
  
  end sp_resolutor_venc;
  -------------------------------------20160623ABR------------------------------------------------------
  procedure sp_cuota_impaga_Lin(ln_pgcod10    in number,
                                ln_mod10      in number,
                                ln_suc10      in number,
                                ln_mda10      in number,
                                ln_pap10      in number,
                                ln_cta10      in number,
                                ln_oper10     in number,
                                tipocambio    in number,
                                ln_cuoimp     out number,
                                fech_maxcuota out date) is
  
    lc_estado character(1);
    ld_fecha  date;
  
  begin
  
    BEGIN
      select max(ppfpag)
        into ld_fecha
        from fsd602
       where pgcod = ln_pgcod10
         and ppmod = ln_mod10
         and ppsuc = ln_suc10
         and ppmda = ln_mda10
         and pppap = ln_pap10
         and ppcta = ln_cta10
         and ppoper = ln_oper10;
    exception
      when others then
        NULL;
      
    END;
  
    begin
      select max(f602.pp1stat)
        into lc_estado
        from fsd602 f602
       where f602.pgcod = ln_pgcod10
         and f602.ppmod = ln_mod10
         and f602.ppsuc = ln_suc10
         and f602.ppmda = ln_mda10
         and f602.pppap = ln_pap10
         and f602.ppcta = ln_cta10
         and f602.ppoper = ln_oper10
         and f602.ppfpag = ld_fecha;
    exception
      when others then
        NULL;
    end;
  
    if lc_estado = 'T' or lc_estado = 'P' then
      begin
        select max(ppcap + ppint)
          into ln_cuoimp
          from fsd601
         where pgcod = ln_pgcod10
           and ppmod = ln_mod10
           and ppsuc = ln_suc10
           and ppmda = ln_mda10
           and pppap = ln_pap10
           and ppcta = ln_cta10
           and ppoper = ln_oper10
           and ppfpag > ld_fecha;
      
      exception
        when too_many_rows then
          begin
            select max(ppcap + ppint)
              into ln_cuoimp
              from fsd601
             where pgcod = ln_pgcod10
               and ppmod = ln_mod10
               and ppsuc = ln_suc10
               and ppmda = ln_mda10
               and pppap = ln_pap10
               and ppcta = ln_cta10
               and ppoper = ln_oper10
               and ppfpag > ld_fecha
               and rownum = 1;
          exception
            when others then
            
              NULL;
          end;
      end;
    
    else
      if lc_estado is null then
        begin
          select max(ppcap + ppint)
            into ln_cuoimp
            from fsd601 d
           where pgcod = ln_pgcod10
             and ppmod = ln_mod10
             and ppsuc = ln_suc10
             and ppmda = ln_mda10
             and pppap = ln_pap10
             and ppcta = ln_cta10
             and ppoper = ln_oper10;
        exception
          when others then
          
            NULL;
          
        end;
      
      end if;
    
    end if;
  
    begin
      select d.ppfpag
        into fech_maxcuota
        from fsd601 d
       where pgcod = ln_pgcod10
         and ppmod = ln_mod10
         and ppsuc = ln_suc10
         and ppmda = ln_mda10
         and pppap = ln_pap10
         and ppcta = ln_cta10
         and ppoper = ln_oper10
         and (ppcap + ppint) = ln_cuoimp
         and rownum = 1;
    exception
      when others then
      
        NULL;
      
    end;
  
    if ln_mda10 = 101 then
      ln_cuoimp := nvl(ln_cuoimp, 0) * tipocambio;
    end if;
  
  end sp_cuota_impaga_Lin;

  -------------------------------------20160623ABR-------------------------------------------
  procedure sp_capacidadpago_Lin(ln_MAX_CUOTA    in number,
                                 ln_NRO_CUOTAS   in number,
                                 ln_peri10       in number,
                                 ln_monto_seguro in number,
                                 ln_mod10        in number,
                                 ln_capacidad    out number) is
    ln_mensual number;
    ln_cuota   number;
    -- ln_sngmda  number;
    -- ln_cuotaimp number;
  
  begin
  
    begin
    
      if ln_mod10 <> 117 then
      
        if ln_NRO_CUOTAS > 1 then
        
          ln_mensual := ln_peri10 / 30;
        
          ln_cuota := ln_MAX_CUOTA / ln_mensual; --mensualisa la cuota
        
          ln_capacidad := nvl(ln_cuota, 0) + nvl(ln_monto_seguro, 0);
        
        end if;
      
      end if;
    end;
  end sp_capacidadpago_Lin;
  -------------------------------------------20160623ABR--------------------------------------

  PROCEDURE SP_INSERTA_AQPA981_CAB(PD_FPROC  DATE,
                                   PN_PAIS   NUMBER,
                                   PN_TDOC   NUMBER,
                                   PC_NDOC   CHAR,
                                   PN_INST   NUMBER,
                                   PV_EST    VARCHAR2,
                                   PV_USER   VARCHAR2,
                                   PN_CAPTOT NUMBER,
                                   PN_SALDOL NUMBER,
                                   PN_SALSOL NUMBER,
                                   PC_MONSOL CHAR,
                                   PC_DEUDOL CHAR,
                                   PC_DEUSOL CHAR,
                                   PN_VENDOL NUMBER,
                                   PN_VENSOL NUMBER,
                                   PN_TCAMB  NUMBER,
                                   PN_EXCDOL NUMBER,
                                   PN_EXCSOL NUMBER,
                                   PN_RESDOL NUMBER,
                                   PN_RESSOL NUMBER,
                                   PC_CA1    CHAR,
                                   PN_NA1    NUMBER,
                                   PD_FA1    DATE) IS
    LN_CORR NUMBER;
    LC_HORA CHARACTER(8);
  BEGIN
  
    -- CORRELATIVO
    BEGIN
      SELECT MAX(J.AQPA981CORR)
        INTO LN_CORR
        FROM AQPA981 J
       WHERE J.AQPA981FPROC = PD_FPROC
         AND J.AQPA981INST = PN_INST;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    LN_CORR := NVL(LN_CORR, 0);
  
    BEGIN
      SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') INTO LC_HORA FROM DUAL;
    END;
  
    BEGIN
      INSERT INTO AQPA981
        (AQPA981FPROC,
         AQPA981HORA,
         AQPA981PAIS,
         AQPA981TDOC,
         AQPA981NDOC,
         AQPA981INST,
         AQPA981EST,
         AQPA981CORR,
         AQPA981USER,
         AQPA981CAPTOT,
         AQPA981SALDOL,
         AQPA981SALSOL,
         AQPA981MONSOL,
         AQPA981DEUDOL,
         AQPA981DEUSOL,
         AQPA981VENDOL,
         AQPA981VENSOL,
         AQPA981TCAMB,
         AQPA981EXCDOL,
         AQPA981EXCSOL,
         AQPA981RESDOL,
         AQPA981RESSOL,
         AQPA981CA1,
         AQPA981NA1,
         AQPA981FA1)
      VALUES
        (PD_FPROC,
         LC_HORA,
         PN_PAIS,
         PN_TDOC,
         PC_NDOC,
         PN_INST,
         PV_EST,
         LN_CORR + 1,
         PV_USER,
         PN_CAPTOT,
         PN_SALDOL,
         PN_SALSOL,
         PC_MONSOL,
         PC_DEUDOL,
         PC_DEUSOL,
         PN_VENDOL,
         PN_VENSOL,
         PN_TCAMB,
         PN_EXCDOL,
         PN_EXCSOL,
         PN_RESDOL,
         PN_RESSOL,
         PC_CA1,
         PN_NA1,
         PD_FA1);
      COMMIT;
    END;
  
  END SP_INSERTA_AQPA981_CAB;

  PROCEDURE SP_INSERTA_LOG_AQPA982_DET(PD_FPROC   DATE,
                                       PN_PAIS    NUMBER,
                                       PN_TDOC    NUMBER,
                                       PC_NDOC    CHAR,
                                       PN_INST    NUMBER,
                                       PV_EST     VARCHAR2,
                                       PV_USER    VARCHAR2,
                                       PN_EMP     NUMBER,
                                       PN_SUC     NUMBER,
                                       PN_MOD     NUMBER,
                                       PN_MDA     NUMBER,
                                       PN_PAP     NUMBER,
                                       PN_CTA     NUMBER,
                                       PN_OPE     NUMBER,
                                       PN_SBO     NUMBER,
                                       PN_TOP     NUMBER,
                                       PN_NRCUO   NUMBER,
                                       PN_INSTV   NUMBER,
                                       PN_CUOIMP  NUMBER,
                                       PN_SEGURO  NUMBER,
                                       PN_CAPLIN  NUMBER,
                                       PN_CARFIA  NUMBER,
                                       PN_CAPCUOM NUMBER,
                                       PV_CA1     CHAR,
                                       PN_NA1     NUMBER,
                                       PD_FA1     DATE) IS
    LN_CORR NUMBER;
    LC_HORA CHARACTER(8);
  BEGIN
  
    -- CORRELATIVO
    BEGIN
      SELECT MAX(J.AQPA982CORR)
        INTO LN_CORR
        FROM AQPA982 J
       WHERE J.AQPA982FPROC = PD_FPROC
         AND J.AQPA982INST = PN_INST;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    LN_CORR := NVL(LN_CORR, 0);
  
    BEGIN
      SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') INTO LC_HORA FROM DUAL;
    END;
  
    BEGIN
      INSERT INTO AQPA982
        (AQPA982FPROC,
         AQPA982HORA,
         AQPA982PAIS,
         AQPA982TDOC,
         AQPA982NDOC,
         AQPA982INST,
         AQPA982EST,
         AQPA982CORR,
         AQPA982USER,
         AQPA982EMP,
         AQPA982SUC,
         AQPA982MOD,
         AQPA982MDA,
         AQPA982PAP,
         AQPA982CTA,
         AQPA982OPE,
         AQPA982SBO,
         AQPA982TOP,
         AQPA982NRCUO,
         AQPA982INSTV,
         AQPA982CUOIMP,
         AQPA982SEGURO,
         AQPA982CAPLIN,
         AQPA982CARFIA,
         AQPA982CAPCUOM,
         AQPA982CA1,
         AQPA982NA1,
         AQPA982FA1)
      VALUES
        (PD_FPROC,
         LC_HORA,
         PN_PAIS,
         PN_TDOC,
         PC_NDOC,
         PN_INST,
         PV_EST,
         LN_CORR + 1,
         PV_USER,
         PN_EMP,
         PN_SUC,
         PN_MOD,
         PN_MDA,
         PN_PAP,
         PN_CTA,
         PN_OPE,
         PN_SBO,
         PN_TOP,
         PN_NRCUO,
         PN_INSTV,
         PN_CUOIMP,
         PN_SEGURO,
         PN_CAPLIN,
         PN_CARFIA,
         PN_CAPCUOM,
         PV_CA1,
         PN_NA1,
         PD_FA1);
      COMMIT;
    END;
  
  END SP_INSERTA_LOG_AQPA982_DET;

  PROCEDURE SP_VALIDAR_LOG(PD_FPROC     IN DATE,
                           PN_INST      IN NUMBER,
                           PV_RESPUESTA OUT VARCHAR2) IS
    LN_INSTANCIA NUMBER(10);
  BEGIN
    PV_RESPUESTA := 'N';
  
    BEGIN
      select A.AQPA981INST
        INTO LN_INSTANCIA
        FROM AQPA981 A
       WHERE A.AQPA981FPROC = PD_FPROC
         AND A.AQPA981INST = PN_INST
         AND A.AQPA981EST = 'G';
    EXCEPTION
      WHEN OTHERS THEN
        LN_INSTANCIA := NULL;
        PV_RESPUESTA := 'N';
    END;
    IF LN_INSTANCIA IS NOT NULL THEN
      PV_RESPUESTA := 'S';
    END IF;
  
  END SP_VALIDAR_LOG;

  --------------------------------------------------------------------------
  PROCEDURE SP_INSERTA_AQPB612(PN_INST      IN NUMBER,
                               PV_EXCD      IN NUMBER,
                               PV_EXCS      IN NUMBER,
                               PV_RESD      IN NUMBER,
                               PV_RESS      IN NUMBER,
                               PN_RIESCAMBT IN NUMBER,
                               PV_USUARIO   IN VARCHAR2,
                               PV_RG5921    IN VARCHAR2) IS
    -- CLAVE DEL CREDITO
    LN_PGCOD NUMBER;
    LN_MOD   NUMBER;
    LN_SUC   NUMBER;
    LN_MDA   NUMBER;
    LN_PAP   NUMBER;
    LN_CTA   NUMBER;
    LN_OPER  NUMBER;
    LN_SBOP  NUMBER;
    LN_TOPE  NUMBER;
    ---------------------
    LN_NUMEVA NUMBER;
    LN_TIPCRE NUMBER;
    LD_FECEVA DATE;
    LN_TIPCAM NUMBER;
    LN_CUNUDO NUMBER;
    LN_CUNUSO NUMBER;
    LN_CUVIDO NUMBER;
    LN_CUVISO NUMBER;
    LN_TORENE NUMBER;
    LN_TOEXNE NUMBER;
    LN_PLRESO NUMBER;
    LN_PLREVI NUMBER;
    LN_SHOCK  NUMBER(17, 6);
    LN_RG5922 NUMBER(17, 6);
  
    --    LC_INDICADOR NUMBER;
    --    LN_RATIO     NUMBER;    
    LN_SEGMENTO NUMBER;
  
    LN_CORR NUMBER;
  
    LC_HORA CHARACTER(8);
  
    PV_ResNetSol NUMBER;
    PV_ResNetDol NUMBER;
    PV_ExcNetSol NUMBER;
    PV_ExcNetDol NUMBER;
  
    --VARIABLES
    TIPO_PERSONA         CHARACTER(1);
    DES_PARCIAL          NUMBER;
    SALARIO_DOL          NUMBER(17, 2);
    SALARIO_SOL          NUMBER(17, 2);
    MONEDA_SOLICITUD_SOL CHARACTER(1);
    DEUDA_EN_DOLAR       CHARACTER(1);
    DEUDA_EN_SOLES       CHARACTER(1);
    VENTAS_DOL           NUMBER(17, 2);
    VENTAS_SOL           NUMBER(17, 2);
    RESULTADO_DOL        NUMBER(17, 2);
    RESULTADO_SOL        NUMBER(17, 2);
    EXCEDENTE_DOL        NUMBER(17, 2);
    EXCEDENTE_SOL        NUMBER(17, 2);
  
    --MAXIMO PLAZO RESIDUAL
    LN_PLARESVIG NUMBER(17, 2);
    LN_PLARESVUE NUMBER(17, 2);
    LN_PLARESVEN NUMBER(17, 2);
  
  BEGIN
    -- CLAVE DEL CREDITO
    BEGIN
      select C.XWFEMPRESA,
             C.XWFSUCURSAL,
             C.XWFMODULO,
             C.XWFMONEDA,
             C.XWFPAPEL,
             C.XWFCUENTA,
             C.XWFOPERACION,
             C.XWFSUBOPE,
             C.XWFTIPOPE
        into LN_PGCOD,
             LN_SUC,
             LN_MOD,
             LN_MDA,
             LN_PAP,
             LN_CTA,
             LN_OPER,
             LN_SBOP,
             LN_TOPE
        from xwf700 c
       where c.xwfcar3 = '1'
         and c.xwfprcins = PN_INST;
    EXCEPTION
      WHEN OTHERS THEN
        RETURN;
    END;
  
    -- NUMERO DE EVALUACION --13 pyme y 14 consumo
    BEGIN
      select b.sng021eval, b.sng021tmod
        into LN_NUMEVA, LN_TIPCRE
        from sng021 b
       where b.sng021sol = PN_INST
         and b.sng021tmod in (13, 14);
    EXCEPTION
      WHEN OTHERS THEN
        LN_NUMEVA := 0;
    END;
  
    -- FECHA DE EVALUACION
    select c.pgfape into LD_FECEVA from fst017 c where c.pgcod = 1;
  
    -- TIPO DE CAMBIO AL MOMENTO DE EVALUACION
    BEGIN
      select d.sng120tcbi
        into LN_TIPCAM
        from sng120 d
       where d.sng120ins = PN_INST
         and d.sng120tsk = 'EVALUACION';
    EXCEPTION
      WHEN OTHERS THEN
        LN_TIPCAM := NULL;
    END;
  
    LN_TIPCAM := NVL(LN_TIPCAM, 0);
    -- si el tipo de cambio fuera 0 o null o no existe usar la funcion     
    IF LN_TIPCAM = 0 THEN
      BEGIN
        LN_TIPCAM := fn_tipo_cambio_fijo(P_FECHA => LD_FECEVA);
      EXCEPTION
        WHEN OTHERS THEN
          LN_TIPCAM := 0;
      END;
    END IF;
  
    -- MAXIMO PLAZO RESIDUAL VIGENTE
    BEGIN
      select max(e.AQPA982NA1)
        into LN_PLARESVIG
        from aqpa982 e
       where e.aqpa982emp = LN_PGCOD
         and e.aqpa982suc = LN_SUC
         and e.aqpa982mod = LN_MOD
         and e.aqpa982mda = LN_MDA
         and e.aqpa982pap = LN_PAP
         and e.aqpa982cta = LN_CTA
         and e.aqpa982ope = LN_OPER
         and e.aqpa982sbo = LN_SBOP
         and e.aqpa982top = LN_TOPE
         and e.aqpa982inst = PN_INST
         and e.aqpa982est = 'G'
         and e.AQPA982CA1 = RPAD('VIGENTE', 30, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        LN_PLARESVIG := 0;
    END;
  
    -- MAXIMO PLAZO RESIDUAL VUELO
    BEGIN
      select max(e.AQPA982NA1)
        into LN_PLARESVUE
        from aqpa982 e
       where e.aqpa982emp = LN_PGCOD
         and e.aqpa982suc = LN_SUC
         and e.aqpa982mod = LN_MOD
         and e.aqpa982mda = LN_MDA
         and e.aqpa982pap = LN_PAP
         and e.aqpa982cta = LN_CTA
         and e.aqpa982ope = LN_OPER
         and e.aqpa982sbo = LN_SBOP
         and e.aqpa982top = LN_TOPE
         and e.aqpa982inst = PN_INST
         and e.aqpa982est = 'G'
         and e.AQPA982CA1 = RPAD('VUELO', 30, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        LN_PLARESVUE := 0;
    END;
  
    -- MAXIMO PLAZO RESIDUAL VUELO
    BEGIN
      select max(e.AQPA982NA1)
        into LN_PLARESVEN
        from aqpa982 e
       where e.aqpa982emp = LN_PGCOD
         and e.aqpa982suc = LN_SUC
         and e.aqpa982mod = LN_MOD
         and e.aqpa982mda = LN_MDA
         and e.aqpa982pap = LN_PAP
         and e.aqpa982cta = LN_CTA
         and e.aqpa982ope = LN_OPER
         and e.aqpa982sbo = LN_SBOP
         and e.aqpa982top = LN_TOPE
         and e.aqpa982inst = PN_INST
         and e.aqpa982est = 'G'
         and e.AQPA982CA1 = RPAD('VENCIDO', 30, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        LN_PLARESVEN := 0;
    END;
    LN_PLARESVIG := NVL(LN_PLARESVEN, 0);
    LN_PLARESVUE := NVL(LN_PLARESVUE, 0);
    LN_PLARESVEN := NVL(LN_PLARESVEN, 0);
  
    IF LN_MDA = 0 THEN
      -- CUOTA NUEVA EN SOLES 
      -- Plazo residual de la operación asociada al crédito solicitado (nuevo)
      BEGIN
        select e.aqpa982capcuom, e.AQPA982NA1
          into LN_CUNUSO, LN_PLRESO
          from aqpa982 e
         where e.aqpa982inst = PN_INST
           and e.aqpa982est = 'G'
           and e.aqpa982emp = LN_PGCOD
           and e.aqpa982suc = LN_SUC
           and e.aqpa982mod = LN_MOD
           and e.aqpa982mda = LN_MDA
           and e.aqpa982pap = LN_PAP
           and e.aqpa982cta = LN_CTA
           and e.aqpa982ope = LN_OPER
           and e.aqpa982sbo = LN_SBOP
           and e.aqpa982top = LN_TOPE;
      EXCEPTION
        WHEN no_data_found THEN
          LN_CUNUSO := NVL(LN_CUNUDO, 0);
          LN_PLRESO := NVL(LN_PLRESO, 0);
        WHEN OTHERS THEN
          LN_CUNUSO := NULL;
          LN_PLRESO := NULL;
      END;
    ELSE
      -- CUOTA NUEVA EN DOLARES
      -- Plazo residual de la operación asociada al crédito solicitado (nuevo)
      BEGIN
        select e.aqpa982capcuom, e.AQPA982NA1
          into LN_CUNUDO, LN_PLRESO
          from aqpa982 e
         where e.aqpa982inst = PN_INST
           and e.aqpa982est = 'G'
           and e.aqpa982emp = LN_PGCOD
           and e.aqpa982suc = LN_SUC
           and e.aqpa982mod = LN_MOD
           and e.aqpa982mda = LN_MDA
           and e.aqpa982pap = LN_PAP
           and e.aqpa982cta = LN_CTA
           and e.aqpa982ope = LN_OPER
           and e.aqpa982sbo = LN_SBOP
           and e.aqpa982top = LN_TOPE;
      EXCEPTION
        WHEN no_data_found THEN
          LN_CUNUDO := NVL(LN_CUNUDO, 0);
          LN_PLRESO := NVL(LN_PLRESO, 0);
        WHEN OTHERS THEN
          LN_CUNUDO := NULL;
          LN_PLRESO := NULL;
      END;
    END IF;
  
    -- CUOTAS VIGENTES EN SOLES
    select sum(e.aqpa982capcuom)
      into LN_CUVISO
      from aqpa982 e
     where e.aqpa982inst = PN_INST
       and e.aqpa982est = 'G'
       and e.aqpa982mda = 0
       and e.aqpa982ca1 = 'VIGENTE';
  
    -- CUOTAS VIGENTES EN DOLARES
    select sum(e.aqpa982capcuom)
      into LN_CUVIDO
      from aqpa982 e
     where e.aqpa982inst = PN_INST
       and e.aqpa982est = 'G'
       and e.aqpa982mda <> 0
       and e.aqpa982ca1 = 'VIGENTE';
  
    /*
    -- CUOTAS VIGENTES EN SOLES
    IF LN_MDA = 0 THEN 
      BEGIN
        select sum(e.aqpa982capcuom)
          into LN_CUVISO
        from aqpa982 e 
        where e.aqpa982inst = PN_INST and e.aqpa982est = 'G';
        
        LN_CUVISO := LN_CUVISO - LN_CUNUSO;
        
      EXCEPTION
        WHEN OTHERS THEN
          LN_CUVISO := NULL;
      END;
     ELSE
       -- CUOTAS VIGENTES EN DOLARES
      BEGIN
        select sum(e.aqpa982capcuom)
          into LN_CUVIDO
        from aqpa982 e 
        where e.aqpa982inst = PN_INST and e.aqpa982est = 'G';
        
        LN_CUVIDO := LN_CUVIDO - LN_CUNUDO;
    
      EXCEPTION
        WHEN OTHERS THEN
          LN_CUVIDO := NULL;
      END;
    END IF;
    */
    --cuando es pyme 13
    -- PV_RESS -> Resultado Neto en soles
    -- PV_RESD -> Resultado Neto en dólares 
    IF LN_TIPCRE = 13 THEN
      --IF LN_MDA = 0 THEN
        -- Resultado Neto en soles 
        BEGIN
          SELECT F.SNG023MTO
            INTO PV_ResNetSol
            FROM SNG023 F
           WHERE F.SNG021EVAL = LN_NUMEVA
             AND F.SNG026COD = 40;
        EXCEPTION
          WHEN OTHERS THEN
            PV_ResNetSol := 0;
        END;
      --ELSE
        -- Resultado Neto en dólares
        BEGIN
          SELECT F.SNG023MTO
            INTO PV_ResNetDol
            FROM SNG023 F
           WHERE F.SNG021EVAL = LN_NUMEVA
             AND F.SNG026COD = 540;
        EXCEPTION
          WHEN OTHERS THEN
            PV_ResNetDol := 0;
        END;
      ---END IF;
    END IF;
  
    --cuando es consumo 14
    -- PV_EXCS -> Excedente Neto en soles 
    -- PV_EXCD -> Excedente Neto en dólares
    IF LN_TIPCRE = 14 THEN
      --IF LN_MDA = 0 THEN
        -- Excedente Neto en soles
        BEGIN
          SELECT F.SNG023MTO
            INTO PV_ExcNetSol
            FROM SNG023 F
           WHERE F.SNG021EVAL = LN_NUMEVA
             AND F.SNG026COD = 27;
        EXCEPTION
          WHEN OTHERS THEN
            PV_ExcNetSol := 0;
        END;
      --ELSE
        -- Excedente Neto en dólares
        BEGIN
          SELECT F.SNG023MTO
            INTO PV_ExcNetDol
            FROM SNG023 F
           WHERE F.SNG021EVAL = LN_NUMEVA
             AND F.SNG026COD = 527;
        EXCEPTION
          WHEN OTHERS THEN
            PV_ExcNetDol := 0;
        END;
      --END IF;
    END IF;
  
    PV_ResNetSol := NVL(PV_ResNetSol, 0);
    PV_ResNetDol := NVL(PV_ResNetDol, 0);
    PV_ExcNetSol := NVL(PV_ExcNetSol, 0);
    PV_ExcNetDol := NVL(PV_ExcNetDol, 0);
  
    IF LN_TIPCRE = 13 THEN
      -- Total Resultado Neto (datos obtenidos de la evaluación asociada al crédito solicitado - admisión)
      LN_TORENE := (PV_RESD * LN_TIPCAM) + PV_RESS;
      --LN_TORENE := (PV_ResNetDol * LN_TIPCAM) + PV_ResNetSol;
    ELSE
      -- Total Excedente Neto (datos obtenidos de la evaluación asociada al crédito solicitado - admisión)
      LN_TOEXNE := (PV_EXCD * LN_TIPCAM) + PV_EXCS;
      --LN_TOEXNE := (PV_ExcNetDol * LN_TIPCAM) + PV_ExcNetSol;
    END IF;
  
    -- Plazo residual de la operación asociada a los créditos vigentes
    BEGIN
      select MAX(e.AQPA982NA1)
        into LN_PLREVI
        from aqpa982 e
       where e.aqpa982inst = PN_INST
         and e.aqpa982est = 'G'
         and e.aqpa982ca1 = rpad('VIGENTE', 30);
    EXCEPTION
      WHEN OTHERS THEN
        LN_PLREVI := NULL;
    END;
  
    -- Shock aplicado en la determinación del ratio (10% ó 20%)
    BEGIN
      PQ_CR_RTE_VERIFICASEGMENTO.sp_cr_SegmntoActual(PN_INST, LN_SEGMENTO);
      --IF LN_SEGMENTO = 1 THEN
      IF LN_TIPCRE = 13 THEN
        LN_SHOCK := PN_RIESCAMBT / (PV_RESD * LN_TIPCAM + PV_RESS);
      --ELSIF LN_SEGMENTO = 2 THEN
      ELSIF LN_TIPCRE = 14 THEN
        LN_SHOCK := PN_RIESCAMBT / (PV_EXCD * LN_TIPCAM + PV_EXCS);
      ELSE
        LN_SHOCK := 999.999;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        LN_SHOCK := 999.999;
    END;
    LN_SHOCK := NVL(LN_SHOCK, 0);
  
    -- Indicador de la exposición a riesgo cambiario del cliente, 
    -- referida al recuadro casos comunes en la medición donde se habilita 
    -- el check de riesgo cambiario (si expuesto/ no expuesto).    
    --LC_INDICADOR := NULL;
  
    --***********
    --CORRELATIVO
    BEGIN
      SELECT MAX(A.AQPB612CORREL)
        INTO LN_CORR
        FROM AQPB612 A
       WHERE A.AQPB612INSTAN = PN_INST;
      --AND A.AQPB612CUENTA = LN_CTA AND A.AQPB612OPERAC = LN_OPER AND A.AQPB612NUMEVA = LN_NUMEVA;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    LN_CORR := NVL(LN_CORR, 0);
  
    --DESACTIVAR REGISTROS ANTERIORES
    BEGIN
      UPDATE AQPB612 A
         SET A.AQPB612ESTADO = 'S'
       WHERE A.AQPB612INSTAN = PN_INST;
      --AND A.AQPB612CUENTA = LN_CTA-- AND A.AQPB612OPERAC = LN_OPER --A.AQPB612NUMEVA = LN_NUMEVA;
      COMMIT;
    END;
  
    -- HORA DEL REGISTRO
    BEGIN
      SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') INTO LC_HORA FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN
        LC_HORA := NULL;
    END;
  
    PQ_CR_RESOLUTOR_RIESGOCAMB.SP_VAR_TIPO_PERSONA(PN_INST, TIPO_PERSONA);
  
    PQ_CR_RESOLUTOR_RIESGOCAMB.SP_VAR_DES_PARCIAL(PN_INST, DES_PARCIAL);
  
    PQ_CR_RESOLUTOR_RIESGOCAMB.SP_VAR_SALARIO_DOL(PN_INST, SALARIO_DOL);
  
    PQ_CR_RESOLUTOR_RIESGOCAMB.SP_VAR_SALARIO_SOL(PN_INST, SALARIO_SOL);
  
    PQ_CR_RESOLUTOR_RIESGOCAMB.SP_VAR_MONEDA_SOLICITUD_SOL(PN_INST,
                                                           MONEDA_SOLICITUD_SOL);
  
    PQ_CR_RESOLUTOR_RIESGOCAMB.SP_VAR_DEUDA_EN_DOLAR(PN_INST,
                                                     DEUDA_EN_DOLAR);
  
    PQ_CR_RESOLUTOR_RIESGOCAMB.SP_VAR_DEUDA_EN_SOLES(PN_INST,
                                                     DEUDA_EN_SOLES);
  
    PQ_CR_RESOLUTOR_RIESGOCAMB.SP_VAR_VENTAS_DOL(PN_INST, VENTAS_DOL);
  
    PQ_CR_RESOLUTOR_RIESGOCAMB.SP_VAR_VENTAS_SOL(PN_INST, VENTAS_SOL);
  
    PQ_CR_RESOLUTOR_RIESGOCAMB.SP_VAR_RESULTADO_DOL(PN_INST, RESULTADO_DOL);
  
    PQ_CR_RESOLUTOR_RIESGOCAMB.SP_VAR_RESULTADO_SOL(PN_INST, RESULTADO_SOL);
  
    PQ_CR_RESOLUTOR_RIESGOCAMB.SP_VAR_EXCEDENTE_DOL(PN_INST, EXCEDENTE_DOL);
  
    PQ_CR_RESOLUTOR_RIESGOCAMB.SP_VAR_EXCEDENTE_SOL(PN_INST, EXCEDENTE_SOL);
  
    LN_RG5922 := LN_SHOCK;
  
    if PV_RG5921 = 'N' then
      LN_SHOCK := null;
    end if;
  
    INSERT INTO AQPB612
      (AQPB612CORREL, --1
       AQPB612CUENTA, --2
       AQPB612OPERAC, --3
       AQPB612INSTAN, --4
       AQPB612NUMEVA, --5
       AQPB612FECEVA, --6
       AQPB612TIPCAM, --7
       AQPB612CUNUDO, --8
       AQPB612CUNUSO, --9
       AQPB612CUVISO, --10
       AQPB612CUVIDO, --11
       AQPB612RENESO, --12
       AQPB612RENEDO, --13
       AQPB612EXNESO, --14
       AQPB612EXNEDO, --15
       AQPB612TORENE, --16
       AQPB612TOEXNE, --17
       AQPB612PLRESO, --18
       AQPB612PLRECV, --19
       AQPB612SHOAPL, --20
       AQPB612INDCAD, --21
       AQPB612ESTADO, --22
       AQPB612USUGEN, --23
       AQPB612FECGEN, --24
       AQPB612HORGEN, --25
       -------------
       AQPB612TIPPER,
       AQPB612DESPAR,
       AQPB612SALDOL,
       AQPB612SALSOL,
       AQPB612MONSOL,
       AQPB612DEUDOL,
       AQPB612DEUSOL,
       AQPB612VENDOL,
       AQPB612VENSOL,
       AQPB612RESDOL,
       AQPB612RESSOL,
       AQPB612EXCDOL,
       AQPB612EXCSOL,
       -------------
       AQPB612PLAVIG,
       AQPB612PLAVUE,
       AQPB612PLAVEN,
       -------------
       AQPB612RG5921,
       AQPB612RG5922,
       AQPB612USUREG,
       AQPB612FECREG,
       AQPB612HORREG)
    VALUES
      (LN_CORR + 1, --1
       LN_CTA, --2
       LN_OPER, --3
       PN_INST, --4   
       LN_NUMEVA, --5
       LD_FECEVA, --6
       LN_TIPCAM, --7
       LN_CUNUDO, --8
       LN_CUNUSO, --9                        
       LN_CUVISO, --10
       LN_CUVIDO, --11                        
       PV_ResNetSol, --12                                                                
       PV_ResNetDol, --13
       PV_ExcNetSol, --14
       PV_ExcNetDol, --15
       LN_TORENE, --16
       LN_TOEXNE, --17
       LN_PLRESO, --18
       LN_PLREVI, --19
       LN_SHOCK, --20
       PV_RG5921, --21
       'G', --22
       PV_USUARIO, --23
       LD_FECEVA, --24
       LC_HORA, --25
       -------------
       TIPO_PERSONA,
       DES_PARCIAL,
       SALARIO_DOL,
       SALARIO_SOL,
       MONEDA_SOLICITUD_SOL,
       DEUDA_EN_DOLAR,
       DEUDA_EN_SOLES,
       VENTAS_DOL,
       VENTAS_SOL,
       RESULTADO_DOL,
       RESULTADO_SOL,
       EXCEDENTE_DOL,
       EXCEDENTE_SOL,
       -------------
       LN_PLARESVIG,
       LN_PLARESVUE,
       LN_PLARESVEN,
       -------------
       PV_RG5921,
       LN_SHOCK,
       PV_USUARIO,
       LD_FECEVA,
       LC_HORA);
    COMMIT;
  
  END SP_INSERTA_AQPB612;

  --------------------------------------------------------------------------
  --VARIABLES

  PROCEDURE SP_VAR_RESOLUTOR_4002(PN_INSTANCIA         IN NUMBER,
                                  TIPO_PERSONA         OUT CHARACTER,
                                  DES_PARCIAL          OUT NUMBER,
                                  SALARIO_DOL          OUT NUMBER,
                                  SALARIO_SOL          OUT NUMBER,
                                  MONEDA_SOLICITUD_SOL OUT CHARACTER,
                                  DEUDA_EN_DOLAR       OUT CHARACTER,
                                  DEUDA_EN_SOLES       OUT CHARACTER,
                                  VENTAS_DOL           OUT NUMBER,
                                  VENTAS_SOL           OUT NUMBER,
                                  RESULTADO_DOL        OUT NUMBER,
                                  RESULTADO_SOL        OUT NUMBER,
                                  EXCEDENTE_DOL        OUT NUMBER,
                                  EXCEDENTE_SOL        OUT NUMBER) IS
    LN_RESOLU    NUMBER;
    sql_select   VARCHAR2(5000);
    sql_from     VARCHAR2(5000);
    LV_RESPUESTA varchar2(250);
    CURSOR QRYS_RESOLUTOR(PN_RESOLUTOR IN NUMBER) IS
      select r3.rep001cod,
             r3.rep002cons,
             r3.rep003col,
             r3.rep003dsc,
             r3.rep003exp,
             r2.rep002dsc,
             r2.rep002from,
             'SELECT ' || trim(r3.rep003exp) || ' "' || trim(r2.rep002dsc) || '"' qry_select,
             'FROM ' || trim(r2.rep002from) qry_from,
             'SELECT ' || trim(r3.rep003exp) || ' "' || trim(r2.rep002dsc) || '" ' ||
             'FROM ' || trim(r2.rep002from) CONSULTA
        from rep003 r3 -- despues del select (rep003exp)
        join rep002 r2
          on r2.rep001cod = r3.rep001cod
         and r2.rep002cons = r3.rep002cons -- despues dl from (rep002from)
       where r2.rep001cod = PN_RESOLUTOR;
  BEGIN
    LN_RESOLU := 4002; -- EL REPORTEADOR DE LA REGLA -> 5921
    FOR i IN QRYS_RESOLUTOR(LN_RESOLU) LOOP
      sql_select := i.qry_select;
      sql_from   := i.qry_from;
      sql_from   := REPLACE(sql_from, '@', ':');
      begin
        execute immediate sql_select || ' ' || sql_from
          into LV_RESPUESTA
          using PN_INSTANCIA;
      exception
        when others then
          LV_RESPUESTA := '';
      end;
      CASE
        WHEN i.rep002cons = 1 THEN
          TIPO_PERSONA := LV_RESPUESTA;
        WHEN i.rep002cons = 2 THEN
          DES_PARCIAL := LV_RESPUESTA;
        WHEN i.rep002cons = 3 THEN
          SALARIO_DOL := LV_RESPUESTA;
        WHEN i.rep002cons = 4 THEN
          SALARIO_SOL := LV_RESPUESTA;
        WHEN i.rep002cons = 5 THEN
          MONEDA_SOLICITUD_SOL := LV_RESPUESTA;
        WHEN i.rep002cons = 6 THEN
          DEUDA_EN_DOLAR := LV_RESPUESTA;
        WHEN i.rep002cons = 7 THEN
          DEUDA_EN_SOLES := LV_RESPUESTA;
        WHEN i.rep002cons = 8 THEN
          VENTAS_DOL := LV_RESPUESTA;
        WHEN i.rep002cons = 9 THEN
          VENTAS_SOL := LV_RESPUESTA;
        WHEN i.rep002cons = 10 THEN
          RESULTADO_DOL := LV_RESPUESTA;
        WHEN i.rep002cons = 11 THEN
          RESULTADO_SOL := LV_RESPUESTA;
        WHEN i.rep002cons = 12 THEN
          EXCEDENTE_DOL := LV_RESPUESTA;
        ELSE
          EXCEDENTE_SOL := LV_RESPUESTA;
      END CASE;
    END LOOP;
  END SP_VAR_RESOLUTOR_4002;

  --------------------------------------------------------------------------
  PROCEDURE SP_VAR_TIPO_PERSONA(PN_INSTANCIA IN NUMBER,
                                TIPO_PERSONA OUT CHARACTER) IS
  BEGIN
    --LN_RESOLU := 4002; -- EL REPORTEADOR DE LA REGLA -> 5921
    -- VARIABLE 1
    begin
      SELECT B.PETIPO "TIPO PERSONA"
        INTO TIPO_PERSONA
        FROM SNG001 A, FSD001 B
       WHERE A.SNG001Pais = B.PEPAIS
         AND A.SNG001Tdoc = B.PETDOC
         AND A.SNG001NDoc = B.PENDOC
         AND A.SNG001INST = PN_INSTANCIA;
    exception
      when others then
        TIPO_PERSONA := '';
    end;
  END SP_VAR_TIPO_PERSONA;

  --------------------------------------------------------------------------
  PROCEDURE SP_VAR_DES_PARCIAL(PN_INSTANCIA IN NUMBER,
                               DES_PARCIAL  OUT NUMBER) IS
  BEGIN
    -- VARIABLE 2
    begin
      SELECT COUNT(*) "DES_PARCIAL"
        INTO DES_PARCIAL
        FROM sng002 a
       where a.sng001inst = PN_INSTANCIA;
    exception
      when others then
        DES_PARCIAL := '';
    end;
  END SP_VAR_DES_PARCIAL;

  --------------------------------------------------------------------------
  PROCEDURE SP_VAR_SALARIO_DOL(PN_INSTANCIA IN NUMBER,
                               SALARIO_DOL  OUT NUMBER) IS
  BEGIN
    -- VARIABLE 3
    begin
      SELECT sum(sng023mto) "SALARIO_DOL"
        INTO SALARIO_DOL
        FROM SNG023
       where sng021eval =
             (select SNG021EVAL from sng021 where sng021sol = PN_INSTANCIA)
         AND SNG026COD IN (501, 502, 503, 504, 509, 510, 511, 512)
       group by sng021eval;
    exception
      when others then
        SALARIO_DOL := 0.00;
    end;
  END SP_VAR_SALARIO_DOL;

  --------------------------------------------------------------------------
  PROCEDURE SP_VAR_SALARIO_SOL(PN_INSTANCIA IN NUMBER,
                               SALARIO_SOL  OUT NUMBER) IS
  BEGIN
    -- VARIABLE 4
    begin
      SELECT sum(sng023mto) "SALARIO_SOL"
        INTO SALARIO_SOL
        FROM SNG023
       where sng021eval =
             (select SNG021EVAL from sng021 where sng021sol = PN_INSTANCIA)
         AND SNG026COD IN (1, 2, 3, 4, 9, 10, 11, 12)
       group by sng021eval;
    exception
      when others then
        SALARIO_SOL := 0.00;
    end;
  END SP_VAR_SALARIO_SOL;

  --------------------------------------------------------------------------
  PROCEDURE SP_VAR_MONEDA_SOLICITUD_SOL(PN_INSTANCIA         IN NUMBER,
                                        MONEDA_SOLICITUD_SOL OUT CHARACTER) IS
  BEGIN
    -- VARIABLE 5
    begin
      SELECT CASE
               WHEN COUNT(*) > 0 THEN
                'S'
               ELSE
                'N'
             END "MONEDA_SOLICITUD_SOL"
        INTO MONEDA_SOLICITUD_SOL
        FROM XWF700 C
       WHERE C.XWFMONEDA = 0
         AND C.XWFPRCINS = PN_INSTANCIA;
    exception
      when others then
        MONEDA_SOLICITUD_SOL := 'N';
    end;
  END SP_VAR_MONEDA_SOLICITUD_SOL;

  --------------------------------------------------------------------------
  PROCEDURE SP_VAR_DEUDA_EN_DOLAR(PN_INSTANCIA   IN NUMBER,
                                  DEUDA_EN_DOLAR OUT CHARACTER) IS
  BEGIN
    -- VARIABLE 6
    begin
      SELECT CASE
               WHEN COUNT(*) > 0 THEN
                'S'
               ELSE
                'N'
             END "DEUDA_EN_DOLAR"
        INTO DEUDA_EN_DOLAR
        FROM FSD010 B
       WHERE B.AOMDA = 101
         AND B.AOCTA IN (select A.CTNRO
                           from FSR008 A
                          WHERE A.PEPAIS =
                                (select d.sng001pais
                                   from SNG001 D
                                  WHERE D.SNG001INST = PN_INSTANCIA)
                            AND A.PETDOC =
                                (select d.sng001tdoc
                                   from SNG001 D
                                  WHERE D.SNG001INST = PN_INSTANCIA)
                            AND A.PENDOC =
                                (select d.sng001ndoc
                                   from SNG001 D
                                  WHERE D.SNG001INST = PN_INSTANCIA)
                            AND A.CTTFIR = 'T')
         AND B.PGCOD = 1
         AND B.AOMOD IN (101,
                         102,
                         103,
                         104,
                         105,
                         106,
                         107,
                         109,
                         110,
                         111,
                         112,
                         113,
                         114,
                         115,
                         116,
                         117)
         AND B.AOSTAT <> 99;
    exception
      when others then
        DEUDA_EN_DOLAR := 'N';
    end;
  END SP_VAR_DEUDA_EN_DOLAR;

  --------------------------------------------------------------------------
  PROCEDURE SP_VAR_DEUDA_EN_SOLES(PN_INSTANCIA   IN NUMBER,
                                  DEUDA_EN_SOLES OUT CHARACTER) IS
  BEGIN
    -- VARIABLE 7
    begin
      SELECT CASE
               WHEN COUNT(*) > 0 THEN
                'S'
               ELSE
                'N'
             END "DEUDA_EN_SOLES"
        INTO DEUDA_EN_SOLES
        FROM FSD010 B
       WHERE B.AOMDA = 0
         AND B.AOCTA IN (select A.CTNRO
                           from FSR008 A
                          WHERE A.PEPAIS =
                                (select d.sng001pais
                                   from SNG001 D
                                  WHERE D.SNG001INST = PN_INSTANCIA)
                            AND A.PETDOC =
                                (select d.sng001tdoc
                                   from SNG001 D
                                  WHERE D.SNG001INST = PN_INSTANCIA)
                            AND A.PENDOC =
                                (select d.sng001ndoc
                                   from SNG001 D
                                  WHERE D.SNG001INST = PN_INSTANCIA)
                            AND A.CTTFIR = 'T')
         AND B.PGCOD = 1
         AND B.AOMOD IN (101,
                         102,
                         103,
                         104,
                         105,
                         106,
                         107,
                         109,
                         110,
                         111,
                         112,
                         113,
                         114,
                         115,
                         116,
                         117)
         AND B.AOSTAT <> 99;
    exception
      when others then
        DEUDA_EN_SOLES := 'N';
    end;
  END SP_VAR_DEUDA_EN_SOLES;

  --------------------------------------------------------------------------
  PROCEDURE SP_VAR_VENTAS_DOL(PN_INSTANCIA IN NUMBER,
                              VENTAS_DOL   OUT NUMBER) IS
  BEGIN
    -- VARIABLE 8
    begin
      SELECT sum(sng023mto) "VENTAS_DOL"
        INTO VENTAS_DOL
        FROM SNG023
       where sng021eval =
             (select SNG021EVAL from sng021 where sng021sol = PN_INSTANCIA)
         AND SNG026COD IN (573)
       group by sng021eval;
    exception
      when others then
        VENTAS_DOL := 0.00;
    end;
  END SP_VAR_VENTAS_DOL;

  --------------------------------------------------------------------------
  PROCEDURE SP_VAR_VENTAS_SOL(PN_INSTANCIA IN NUMBER,
                              VENTAS_SOL   OUT NUMBER) IS
  BEGIN
    -- VARIABLE 9
    begin
      SELECT sum(sng023mto) "VENTAS_SOL"
        INTO VENTAS_SOL
        FROM SNG023
       where sng021eval =
             (select SNG021EVAL from sng021 where sng021sol = PN_INSTANCIA)
         AND SNG026COD IN (73)
       group by sng021eval;
    exception
      when others then
        VENTAS_SOL := 0.00;
    end;
  END SP_VAR_VENTAS_SOL;

  --------------------------------------------------------------------------
  PROCEDURE SP_VAR_RESULTADO_DOL(PN_INSTANCIA  IN NUMBER,
                                 RESULTADO_DOL OUT NUMBER) IS
  BEGIN
    -- VARIABLE 10
    begin
      SELECT sng023mto "RESULTADO_DOL"
        INTO RESULTADO_DOL
        FROM SNG023
       where sng021eval =
             (select SNG021EVAL from sng021 where sng021sol = PN_INSTANCIA)
         AND SNG026COD IN (540);
    exception
      when others then
        RESULTADO_DOL := 0.00;
    end;
  END SP_VAR_RESULTADO_DOL;

  --------------------------------------------------------------------------
  PROCEDURE SP_VAR_RESULTADO_SOL(PN_INSTANCIA  IN NUMBER,
                                 RESULTADO_SOL OUT NUMBER) IS
  BEGIN
    -- VARIABLE 11
    begin
      SELECT sng023mto "RESULTADO_SOL"
        INTO RESULTADO_SOL
        FROM SNG023
       where sng021eval =
             (select SNG021EVAL from sng021 where sng021sol = PN_INSTANCIA)
         AND SNG026COD IN (40);
    exception
      when others then
        RESULTADO_SOL := 0.00;
    end;
  END SP_VAR_RESULTADO_SOL;

  --------------------------------------------------------------------------
  PROCEDURE SP_VAR_EXCEDENTE_DOL(PN_INSTANCIA  IN NUMBER,
                                 EXCEDENTE_DOL OUT NUMBER) IS
  BEGIN
    -- VARIABLE 12
    begin
      SELECT sng023mto "EXCEDENTE_DOL"
        INTO EXCEDENTE_DOL
        FROM SNG023
       where sng021eval =
             (select SNG021EVAL from sng021 where sng021sol = PN_INSTANCIA)
         AND SNG026COD IN (527);
    exception
      when others then
        EXCEDENTE_DOL := 0.00;
    end;
  END SP_VAR_EXCEDENTE_DOL;

  --------------------------------------------------------------------------
  PROCEDURE SP_VAR_EXCEDENTE_SOL(PN_INSTANCIA  IN NUMBER,
                                 EXCEDENTE_SOL OUT NUMBER) IS
  BEGIN
    -- VARIABLE 13
    begin
      SELECT sng023mto "EXCEDENTE_SOL"
        INTO EXCEDENTE_SOL
        FROM SNG023
       where sng021eval =
             (select SNG021EVAL from sng021 where sng021sol = PN_INSTANCIA)
         AND SNG026COD IN (27);
    exception
      when others then
        EXCEDENTE_SOL := 0.00;
    end;
  END SP_VAR_EXCEDENTE_SOL;

  --------------------------------------------------------------------------  
  PROCEDURE SP_VAR_TPO_CAMBIO(PN_INSTANCIA IN NUMBER,
                              TPO_CAMBIO   OUT NUMBER) IS
  BEGIN
    -- VARIABLE 14
    begin
      SELECT case
               when SNG120TCBI = 0 THEN
                1
               else
                SNG120TCBI
             end "TPO_CAMBIO"
        INTO TPO_CAMBIO
        FROM SNG120
       WHERE SNG120TSK = 'EVALUACION'
         AND SNG120INS = PN_INSTANCIA;
    exception
      when others then
        TPO_CAMBIO := 1;
    end;
  END SP_VAR_TPO_CAMBIO;

  --------------------------------------------------------------------------
  PROCEDURE SP_UPDATE_REGLAS(PN_INSTAN  IN NUMBER,
                             PV_RG5921  IN VARCHAR2,
                             PV_RG5922  IN VARCHAR2,
                             PV_USUARIO IN VARCHAR2,
                             PC_FLAG    OUT CHARACTER) IS
    LC_HORA   VARCHAR2(15);
    LD_FECSIS DATE;
  BEGIN
    -- FECHA Y HORA DEL REGISTRO
    BEGIN
      SELECT c.pgfape INTO LD_FECSIS FROM fst017 c WHERE c.pgcod = 1;
    
      SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') INTO LC_HORA FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN
        LC_HORA := NULL;
    END;
  
    --DESACTIVAR REGISTROS ANTERIORES
    BEGIN
      UPDATE AQPB612 A
         SET A.AQPB612RG5921 = PV_RG5921,
             A.AQPB612RG5922 = PV_RG5922,
             A.AQPB612USUREG = PV_USUARIO,
             A.AQPB612FECREG = LD_FECSIS,
             A.AQPB612HORREG = LC_HORA
       WHERE A.AQPB612INSTAN = PN_INSTAN
            --AND A.AQPB612CUENTA = LN_CTA AND A.AQPB612OPERAC = LN_OPER
         AND A.AQPB612ESTADO = 'G';
      COMMIT;
      PC_FLAG := 'S';
    EXCEPTION
      WHEN OTHERS THEN
        PC_FLAG := 'N';
    END;
  
  END SP_UPDATE_REGLAS;

  --------------------------------------------------------------------------
  PROCEDURE SP_INSERT_REGLAS(PN_INSTAN  IN NUMBER,
                             PV_RG5921  IN VARCHAR2,
                             PV_RG5922  IN VARCHAR2,
                             PV_USUARIO IN VARCHAR2,
                             PD_FECPRO  IN DATE,
                             PC_FLAG    OUT CHARACTER) IS
    LC_HORA VARCHAR2(15);
    LN_CORR NUMBER;
  BEGIN
  
    --***********
    --CORRELATIVO
    BEGIN
      SELECT MAX(A.AQPB612CORREL)
        INTO LN_CORR
        FROM AQPB612 A
       WHERE A.AQPB612INSTAN = PN_INSTAN
         AND A.AQPB612FECGEN = PD_FECPRO;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    LN_CORR := NVL(LN_CORR, 0);
  
    --DESACTIVAR REGISTROS ANTERIORES
    BEGIN
      UPDATE AQPB612 A
         SET A.AQPB612ESTADO = 'S'
       WHERE A.AQPB612INSTAN = PN_INSTAN
         AND A.AQPB612FECGEN = PD_FECPRO;
      COMMIT;
    END;
  
    -- HORA DEL REGISTRO
    BEGIN
      SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') INTO LC_HORA FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN
        LC_HORA := NULL;
    END;
  
    BEGIN
      INSERT INTO AQPB612
        (AQPB612CORREL,
         AQPB612CUENTA,
         AQPB612OPERAC,
         AQPB612INSTAN,
         AQPB612NUMEVA,
         AQPB612FECEVA,
         AQPB612TIPCAM,
         AQPB612CUNUDO,
         AQPB612CUNUSO,
         AQPB612CUVISO,
         AQPB612CUVIDO,
         AQPB612RENESO,
         AQPB612RENEDO,
         AQPB612EXNESO,
         AQPB612EXNEDO,
         AQPB612TORENE,
         AQPB612TOEXNE,
         AQPB612PLRESO,
         AQPB612PLRECV,
         AQPB612SHOAPL,
         AQPB612INDCAD,
         AQPB612ESTADO,
         AQPB612USUGEN,
         AQPB612FECGEN,
         AQPB612HORGEN,
         -------------
         AQPB612TIPPER,
         AQPB612DESPAR,
         AQPB612SALDOL,
         AQPB612SALSOL,
         AQPB612MONSOL,
         AQPB612DEUDOL,
         AQPB612DEUSOL,
         AQPB612VENDOL,
         AQPB612VENSOL,
         AQPB612RESDOL,
         AQPB612RESSOL,
         AQPB612EXCDOL,
         AQPB612EXCSOL,
         
         AQPB612RG5921,
         AQPB612RG5922,
         AQPB612USUREG,
         AQPB612FECREG,
         AQPB612HORREG)
        SELECT /*+all_rows*/
         (LN_CORR + 1),
         AQPB612CUENTA,
         AQPB612OPERAC,
         AQPB612INSTAN,
         AQPB612NUMEVA,
         AQPB612FECEVA,
         AQPB612TIPCAM,
         AQPB612CUNUDO,
         AQPB612CUNUSO,
         AQPB612CUVISO,
         AQPB612CUVIDO,
         AQPB612RENESO,
         AQPB612RENEDO,
         AQPB612EXNESO,
         AQPB612EXNEDO,
         AQPB612TORENE,
         AQPB612TOEXNE,
         AQPB612PLRESO,
         AQPB612PLRECV,
         AQPB612SHOAPL,
         AQPB612INDCAD,
         'G',
         AQPB612USUGEN,
         AQPB612FECGEN,
         AQPB612HORGEN,
         
         AQPB612TIPPER,
         AQPB612DESPAR,
         AQPB612SALDOL,
         AQPB612SALSOL,
         AQPB612MONSOL,
         AQPB612DEUDOL,
         AQPB612DEUSOL,
         AQPB612VENDOL,
         AQPB612VENSOL,
         AQPB612RESDOL,
         AQPB612RESSOL,
         AQPB612EXCDOL,
         AQPB612EXCSOL,
         
         PV_RG5921,
         PV_RG5922,
         
         PV_USUARIO,
         PD_FECPRO,
         LC_HORA
          FROM AQPB612 X
         WHERE X.AQPB612INSTAN = PN_INSTAN
           AND X.AQPB612FECGEN = PD_FECPRO
           AND X.AQPB612CORREL = LN_CORR;
    
      COMMIT;
      PC_FLAG := 'S';
    EXCEPTION
      WHEN OTHERS THEN
        PC_FLAG := 'N';
    END;
  
  END SP_INSERT_REGLAS;

  --------------------------------------------------------------------------
  PROCEDURE SP_VALIDAR_LOG_612(PN_INSTAN  IN NUMBER,
                               PV_USUARIO IN VARCHAR2,
                               PD_FECPRO  IN DATE,
                               PC_FLAG    OUT CHARACTER) IS
    LN_CONT   NUMBER;
    LN_CONT_B NUMBER;
  BEGIN
  
    BEGIN
      SELECT COUNT(*)
        INTO LN_CONT
        FROM AQPB612 A
       WHERE A.AQPB612ESTADO = 'G'
         AND A.AQPB612INSTAN = PN_INSTAN
         AND A.AQPB612FECGEN = PD_FECPRO;
      --AND TRIM(A.AQPB612USUGEN) = TRIM(PV_USUARIO);
    EXCEPTION
      WHEN OTHERS THEN
        LN_CONT := 0;
    END;
  
    BEGIN
      SELECT COUNT(*)
        INTO LN_CONT_B
        FROM AQPA981 B
       WHERE B.AQPA981EST = 'G'
         AND B.AQPA981INST = PN_INSTAN
         AND B.AQPA981FPROC = PD_FECPRO;
    EXCEPTION
      WHEN OTHERS THEN
        LN_CONT_B := 0;
    END;
  
    IF LN_CONT = 0 OR LN_CONT_B = 0 THEN
      PC_FLAG := 'N';
    ELSE
      PC_FLAG := 'S';
    END IF;
  
  END SP_VALIDAR_LOG_612;

--------------------------------------------------------------------------
end PQ_CR_RESOLUTOR_RIESGOCAMB;
/

