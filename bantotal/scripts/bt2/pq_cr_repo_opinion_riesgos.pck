create or replace package pq_cr_repo_opinion_riesgos is

  -- *****************************************************************
  -- Nombre                     : PAQUETE PARA OPINION DE RIESGOS 
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 20/12/2022 18:46:23
  -- Autor de Creación          : IGS_RCASTRO
  -- Uso                        : Realiza cálculos para opinión de riesgos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 30/06/2023
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Validación de vinculación de líneas para no considerarlas en el monto de la responsabilidad total.
  -- Fecha de Modificación      : 10/07/2023
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Ajuste para iniciar flujo por Analista Senior de Riesgos.
  -- Fecha de Modificación      : 16/10/2023
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Ajuste para creditos propuestos.
  -- Fecha de Modificación      : 06/11/2023
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Ajuste para créditos vigentes.
  -- Fecha de Modificación      : 05/12/2023
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Validación de Limite para generar nuevo codigo de opinión.
  -- Fecha de Modificación      : 18/12/2023
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se agrega nuevo formato de codigo de opinion.  
  -- Fecha de Modificación      : 22/1/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Ajuste en mostrar los comentarios en reconsideración cuando haya una observacion 
  --                             sp_grabar_comentarios_acr_ga
  -- Fecha de Modificación      : 21/02/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se modifica la derivacion a usuarios de aprob. de opiniones y se agrega la fecha de reconsideracion
  -- Fecha de Modificación      : 03/04/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se agrega alertas.   
  -- Fecha de Modificación      : 23/04/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se cambia el procedure para sp_score  
  -- Fecha de Modificación      : 30/04/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se ajusta eval. anterior
  -- Fecha de Modificación      : 09/07/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se ajusta procedure obtener instancia anterior    
  -- Fecha de Modificación      : 31/07/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se agrega procedure sp_drop_reg_expedig 
  -- Fecha de Modificación      : 12/08/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se agrega logica nueva para obtener la actividad.  
  -- Fecha de Modificación      : 20/08/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se elimina codigo innecesario actividad. 
  -- Fecha de Modificación      : 12/09/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se valida vinculacion de linas para creditos     
  -- Fecha de Modificación      : 03/12/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se cambia logica para obtener aprobadores   
  -- Fecha de Modificación      : 10/01/2025
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Modificacion de arbol de aprobacion y autonomias  
  -- Fecha de Modificación      : 11/02/2025
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Modificacion de delegacion y arbol   
  -- Fecha de Modificación      : 11/03/2025
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Modificacion de correos en copia en aprobacion y valid. vigencia 
  --                              de solicitud.          
  -- Fecha de Modificación      : 18/08/2025
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Modificacion de ajuste en arbol de autonomias.             
  -- *****************************************************************
  -----------------------------------------------------------------------

  procedure sp_nomclientes(codOpinion number,
                           instancia  number,
                           nrocuenta  number,
                           NomClien   out varchar2,
                           nrodocs    out varchar2);
  procedure sp_datos_indicad_cart(instancia     number,
                                  fechaApertura date,
                                  nomAnalista   out varchar2,
                                  ratingAnalis  out varchar2,
                                  SldoCartAnali out number,
                                  NroCliAnalis  out number,
                                  NlvMoraAnalis out number,
                                  nomAgencia    out varchar2,
                                  ratingAgenc   out varchar2,
                                  SldoCartAgenc out number,
                                  NroCliAgenc   out number,
                                  NlvMoraAgenc  out number,
                                  nomZona       out varchar2,
                                  SldoCartZona  out number,
                                  NroCliZona    out number,
                                  NlvMoraZona   out number,
                                  nomRegi       out varchar2,
                                  SldoCartRegi  out number,
                                  NroCliRegi    out number,
                                  NlvMoraRegi   out number);
  procedure sp_calificacion(instancia     number,
                            cuenta        number,
                            fechaApertura date,
                            calificacion  out varchar2);
  procedure sp_productoSBS(instancia     number,
                           cuenta        number,
                           fechaApertura date,
                           produSBS      out varchar2);
  procedure sp_actividad(instancia number,
                         cuenta    number,
                         actividad out varchar2);
  procedure sp_score(instancia   number,
                     cuenta      number,
                     usuario     varchar2,
                     nivelRiesgo out varchar2);
  procedure sp_pd(instancia  number,
                  analista   varchar2,
                  agencia    varchar2,
                  zona       varchar2,
                  region     varchar2,
                  PdAnalista out number,
                  pdAgencia  out number,
                  pdzona     out number,
                  pdregion   out number,
                  cos4anl    out number,
                  cos4agen   out number,
                  cos4zona   out number,
                  cos4reg    out number,
                  cos6anl    out number,
                  cos6agen   out number,
                  cos6zona   out number,
                  cos6reg    out number);
  PROCEDURE sp_obtener_pd_cos4_co6_Analista(fechaCierreAnt date,
                                            nomReg         varchar2,
                                            nomZon         varchar2,
                                            NAgencia       number,
                                            NomAnalista    varchar2,
                                            cos4mAnli      out number,
                                            cos6mAnli      out number,
                                            pdAnli         out number);
  PROCEDURE sp_obtener_pd_cos4_co6_Agencia(fechaCierreAnt date,
                                           nomReg         varchar2,
                                           nomZona        varchar2,
                                           xaosuc         number,
                                           cos4mAge       out number,
                                           cos6mAge       out number,
                                           pdAge          out number);
  PROCEDURE sp_obtener_pd_cos4_co6_Zona(fechaCierreAnt date,
                                        nomRegion      varchar2,
                                        nomZon         varchar2,
                                        cos4mZona      out number,
                                        cos6mZona      out number,
                                        pdZona         out number);
  PROCEDURE sp_obtener_pd_cos4_co6_Region(fechaCierreAnt date,
                                          nomReg         varchar2,
                                          cos4mRegion    out number,
                                          cos6mRegion    out number,
                                          pdRegion       out number);
  procedure sp_montoCred(instancia number, monto out number);
  procedure sp_insert_cred_vuelo_aqpc833(xAQPC833codopi  in number,
                                         xAQPC833instan  in number,
                                         xAQPC833sldprop in number,
                                         xAQPC833modprp  in varchar2,
                                         xAQPC833cuotas  in number,
                                         xAQPC833cuoprp  in varchar2,
                                         xAQPC833tasprp  in number,
                                         xAQPC833mdaprop in number,
                                         xAQPC833AUX2    IN VARCHAR2); --18/12/2023
  procedure sp_operac_propuesta(instancia  number,
                                cuenta     number,
                                monto      out number,
                                modalidad  out varchar2,
                                cuota      out number,
                                tot_cuotas out varchar2,
                                tasa       out number,
                                moneda     out number);

  procedure sp_relaciones_finacie(instanci    number,
                                  cuenta      number,
                                  fechaAper   date,
                                  codSBS      out numeric,
                                  fechEvaluar out date);
  procedure sp_grid_garantias(instancia     in number,
                              p_sng122_cod  in number,
                              p_sng122_mod  in number,
                              p_sng122_suc  in number,
                              p_sng122_mda  in number,
                              p_sng122_pap  in number,
                              p_sng122_cta  in number,
                              p_sng122_ope  in number,
                              p_sng122_sbo  in number,
                              p_sng122_top  in number,
                              p_tipGarant   out varchar2,
                              p_Propietrio  out varchar2,
                              p_tasador     out varchar2,
                              Fechatasa     out date,
                              valComer      out varchar2,
                              valRealiz     out varchar2,
                              valGravamen   out number,
                              desGarant     out varchar2,
                              auxMoned      out number,
                              p_tipBienDecl out varchar2,
                              p_fechDecl    out date,
                              p_valorGarnt  out varchar2);

  procedure sp_analisisfinancieroCreditos(instancia                number,
                                          nroevaluacion            out number,
                                          resulta_neto             out number,
                                          disponible               out number,
                                          ctxcbr                   out number,
                                          MERCADERIA               out number,
                                          GASTOS_ANTICIPADOS       out number,
                                          EXISTENCIAS_RECIBIR      out number,
                                          otros_actv_corr          out number,
                                          total_actv_corr          out number,
                                          MUEBLES                  out number,
                                          INMUEBLES                out number,
                                          otros_actv_fijo          out number,
                                          tot_actv_fijo            out number,
                                          xtotal_activ             out number,
                                          OTROS_INGRESOS           out number,
                                          GASTOS_FAMILIARES        out number,
                                          CUENTAS_BANCO            out number,
                                          TRIBUTO_PAGAR            out number,
                                          xotros_pasiv_corr        out number,
                                          xtotal_pasiv_corr        out number,
                                          CUENTAS_BANCOLP          out number,
                                          BENEFICIOS_SOCIALES      out number,
                                          xreservas                out number,
                                          xotros_pasiv_nocorri     out number,
                                          xtot_pasiv_nocorri       out number,
                                          xtotal_pasivo            out number,
                                          xcapital                 out number,
                                          xresult_acumulad         out number,
                                          xresult_ejercici         out number,
                                          xotros_patrim            out number,
                                          xtotal_patrimonio        out number,
                                          xtotal_pasivo_patrimonio out number,
                                          VENTA                    out number,
                                          COSTO_VENTA              out number,
                                          xutilid_bruta            out number,
                                          COSTO_OPERATIVO          out number,
                                          Gastos_administd         out number,
                                          xutilid_operativa        out number,
                                          SERVICIO_DEUDA           out number,
                                          xingres_financieros      out number,
                                          xgastos_diversos         out number,
                                          xutilid_antes_impuestos  out number,
                                          ximpuestos               out number,
                                          xutilidad_neta           out number,
                                          CUENTAS_PAGAR            out number,
                                          FechEvalRec              out date,
                                          ResultRatioEvalRec       out number);

  procedure sp_analisisfinancieroCredConsumo(instancia               number, --08052023
                                             nroevaluacion           out number,
                                             IngBrutTitu             out number,
                                             IngBrutConyu            out number,
                                             IngBrutComis            out number,
                                             IngBrutOtros            out number,
                                             xAporteTitul            out number,
                                             xAporteConyu            out number,
                                             xAporteComisi           out number,
                                             xAporteOtros            out number,
                                             xOtroIngTitu            out number,
                                             xOtroIngConyu           out number,
                                             xOtroIngComis           out number,
                                             xOtroIngOtros           out number,
                                             IngNetoTotal            out number,
                                             EgrAlimentac            out number,
                                             EgrAlquiler             out number,
                                             EgrTranspor             out number,
                                             EgrEducacio             out number,
                                             EgrServicio             out number,
                                             EgrAporFami             out number,
                                             EgrOtros                out number,
                                             GastFinancier           out number,
                                             CuotCredProp            out number,
                                             ExcedNetoMen            out number,
                                             FechEvalReConsum        out date,
                                             ResuRatiCuIngNetEvlRec  out number,
                                             ResuRatiCuExceNetEvlRec out number);

  procedure sp_AnlFinancEvalAnterio(instancia                number,
                                    nroINTipoCN              number,
                                    resulta_neto             out number,
                                    disponible               out number,
                                    ctxcbr                   out number,
                                    MERCADERIA               out number,
                                    GASTOS_ANTICIPADOS       out number,
                                    EXISTENCIAS_RECIBIR      out number,
                                    otros_actv_corr          out number,
                                    total_actv_corr          out number,
                                    MUEBLES                  out number,
                                    INMUEBLES                out number,
                                    otros_actv_fijo          out number,
                                    tot_actv_fijo            out number,
                                    xtotal_activ             out number,
                                    OTROS_INGRESOS           out number,
                                    GASTOS_FAMILIARES        out number,
                                    CUENTAS_BANCO            out number,
                                    TRIBUTO_PAGAR            out number,
                                    xotros_pasiv_corr        out number,
                                    xtotal_pasiv_corr        out number,
                                    CUENTAS_BANCOLP          out number,
                                    BENEFICIOS_SOCIALES      out number,
                                    xreservas                out number,
                                    xotros_pasiv_nocorri     out number,
                                    xtot_pasiv_nocorri       out number,
                                    xtotal_pasivo            out number,
                                    xcapital                 out number,
                                    xresult_acumulad         out number,
                                    xresult_ejercici         out number,
                                    xotros_patrim            out number,
                                    xtotal_patrimonio        out number,
                                    xtotal_pasivo_patrimonio out number,
                                    VENTA                    out number,
                                    COSTO_VENTA              out number,
                                    xutilid_bruta            out number,
                                    COSTO_OPERATIVO          out number,
                                    Gastos_administd         out number,
                                    xutilid_operativa        out number,
                                    SERVICIO_DEUDA           out number,
                                    xingres_financieros      out number,
                                    xgastos_diversos         out number,
                                    xutilid_antes_impuestos  out number,
                                    ximpuestos               out number,
                                    xutilidad_neta           out number,
                                    CUENTAS_PAGAR            out number,
                                    FechEvalRec              out date,
                                    ResultRatioEvalAnterior  out number);

  procedure sp_AnlFinancEvalAnterioConsumo(instancia               number, --08052023
                                           nroINTipoCN             number,
                                           IngBrutTitu             out number,
                                           IngBrutConyu            out number,
                                           IngBrutComis            out number,
                                           IngBrutOtros            out number,
                                           xAporteTitul            out number,
                                           xAporteConyu            out number,
                                           xAporteComisi           out number,
                                           xAporteOtros            out number,
                                           xOtroIngTitu            out number,
                                           xOtroIngConyu           out number,
                                           xOtroIngComis           out number,
                                           xOtroIngOtros           out number,
                                           IngNetoTotal            out number,
                                           EgrAlimentac            out number,
                                           EgrAlquiler             out number,
                                           EgrTranspor             out number,
                                           EgrEducacio             out number,
                                           EgrServicio             out number,
                                           EgrAporFami             out number,
                                           EgrOtros                out number,
                                           GastFinancier           out number,
                                           CuotCredProp            out number,
                                           ExcedNetoMen            out number,
                                           FechEvalAnterConsum     out date,
                                           ResuRatiCuIngNetEvlAnt  out number,
                                           ResuRatiCuExceNetEvlAnt out number);

  procedure sp_inser_cabec_AQPC156(codOpinionGenerado number,
                                   auxAQPC156FECPRO   date,
                                   auxAQPC156INSTAN   number,
                                   auxAQPC156A        varchar2,
                                   auxAQPC156DE       varchar2,
                                   auxAQPC156ASUNT    varchar2,
                                   auxTextComple      varchar2,
                                   auxAQPC156CLIEN    varchar2,
                                   auxAQPC156DNI      varchar2,
                                   auxAQPC156ANALIS   varchar2,
                                   auxAQPC156AGENC    varchar2,
                                   auxAQPC156ZONA     varchar2,
                                   auxAQPC156REGIO    varchar2,
                                   auxAQPC156RATGANA  VARCHAR2,
                                   auxAQPC156RATAGEN  VARCHAR2,
                                   auxAQPC156SLDCANA  number,
                                   auxAQPC156SLDCAGE  number,
                                   auxAQPC156SLDCZON  number,
                                   auxAQPC156SLDCREG  number,
                                   auxAQPC156NCLIANA  number,
                                   auxAQPC156NCLIAGE  number,
                                   auxAQPC156NCLIZON  number,
                                   auxAQPC156NCLIREG  number,
                                   auxAQPC156NMORAG   varchar2,
                                   auxAQPC156NMORAN   varchar2,
                                   auxAQPC156NMORZO   varchar2,
                                   auxAQPC156NMOREG   varchar2,
                                   auxAQPC156NVRIESG  varchar2,
                                   auxAQPC156ACTIVID  varchar2,
                                   auxAQPC156PDANA    number,
                                   auxAQPC156PDAGE    number,
                                   auxAQPC156PDZON    number,
                                   auxAQPC156PDREG    number,
                                   auxAQPC156COH4ANA  number,
                                   auxAQPC156COH4AGE  number,
                                   auxAQPC156COH4ZON  number,
                                   auxAQPC156COH4REG  number,
                                   auxAQPC156COH6ANA  number,
                                   auxAQPC156COH6AGE  number,
                                   auxAQPC156COH6ZON  number,
                                   auxAQPC156COH6REG  number,
                                   auxAQPC156SOLIC    number,
                                   auxAQPC156CTNRO    number,
                                   auxAQPC156CALIF    varchar2,
                                   auxAQPC156PRODSBS  varchar2,
                                   auxAQPC156FECEEFF  date,
                                   auxAQPC156FECINFC  date,
                                   auxAQPC156CODTPRO  number,
                                   auxAQPC156TIPPRO   varchar2,
                                   auxAQPC156RESPTOT  number,
                                   auxAQPC156SLDPROP  number,
                                   auxAQPC156MODPRP   varchar2,
                                   auxcuota           number,
                                   auxQPC156CUOPRP    varchar2,
                                   auxAQPC156TASPRP   number,
                                   auxCodTipSolicitud number,
                                   auxDescTipSolic    varchar2,
                                   auxAQPC156DESCRED  long,
                                   auxAQPC160USUREG   varchar2,
                                   auxAQPC160HORRG    varchar2,
                                   CodNivel           number,
                                   auxFlgAnaliCont    varchar2,
                                   flagGrabad         out varchar2);
  procedure sp_actualizar_Datos_Obser156(instancia      number,
                                         codOpinion     number,
                                         txtA           varchar2,
                                         txtDE          varchar2,
                                         txtAsunto      varchar2,
                                         txtTextoAdic   varchar2,
                                         txtAnalista    varchar2,
                                         txtDNI         varchar2,
                                         Actividad      varchar2,
                                         solicitud      number,
                                         productoSBS    varchar2,
                                         fechaEEFF      date,
                                         fechaInfComer  date,
                                         EsReconsiderac varchar2,
                                         NuevoNivel     number,
                                         flgCambiEst    varchar2,
                                         TipoPropu      varchar2);

  procedure sp_obtn_cred_vig_titu(auxNrOpinion  number,
                                  instancia     number,
                                  cuenta        number,
                                  FechaApertura date,
                                  SumSldVigent  out number /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    saldoCrVig    out varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    modalidad     out varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    cuotas_tot    out varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    tasaCrVig     out varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    montoOtorga   out varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    aux_moned     out varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    CantCred      out number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    valcuota      out varchar2*/);
  procedure sp_obtn_cadena_caracter(texto1      varchar2,
                                    texto2      varchar2,
                                    texto3      varchar2,
                                    texto4      varchar2,
                                    texto5      varchar2,
                                    texto6      varchar2,
                                    nrocred     number,
                                    texto7      varchar2,
                                    saldoCrVig  out number,
                                    auxModali   out varchar2,
                                    cuot_tot    out number,
                                    tasaCrVig   out number,
                                    montoOtorga out number,
                                    moneda      out number,
                                    valcuota    out number);
  procedure sp_insert_aqpc160(codOpinion      number,
                              XAQPC160FECPRO  date,
                              xAQPC160SLDVIG  NUMBER,
                              XAQPC160MODVIG  varchar2,
                              xMontOtorg      number,
                              xcuota          number,
                              XAQPC160CUOVIG  varchar2,
                              XAQPC160TASAVIG NUMBER,
                              xMoneda         varchar2,
                              f_tipoSolic     VARCHAR2,
                              xPromedioAtraso number,
                              p_empresa       NUMBER,
                              p_sucursal      NUMBER,
                              p_modulo        NUMBER,
                              p_moned         NUMBER,
                              p_papel         NUMBER,
                              p_cuenta        NUMBER,
                              p_operacion     NUMBER,
                              p_suboper       NUMBER,
                              p_tipoper       NUMBER,
                              flgOK           out varchar2);

  --procedure sp_insert_detalle_aqpc157(codOpinion number, FechaActReci date, FechaActAnter date, auxActRecDispo number, auxActRecVDisp number, auxActAntDisp number, auxActAntVDisp number, auxActHorDisp number, flgOk out varchar2);
  procedure sp_insert_detalle_aqpc157(p_AQPC157CODOPI number,
                                      
                                      p_AQPC157Afeere  date,
                                      p_AQPC157Afeean  date,
                                      p_AQPC157AacMda1 varchar2,
                                      p_AQPC157AacrDis number,
                                      p_AQPC157AarvDis number,
                                      p_AQPC157AacaDis number,
                                      p_AQPC157AaavDis number,
                                      p_AQPC157AaaHDis number,
                                      
                                      p_AQPC157AacMda2 varchar2,
                                      p_AQPC157AacrCxC number,
                                      p_AQPC157AarvCxC number,
                                      p_AQPC157AacaCxC number,
                                      p_AQPC157AaavCxC number,
                                      p_AQPC157AaaHCxC number,
                                      
                                      p_AQPC157AacMda3 varchar2,
                                      p_AQPC157AacrMer number,
                                      p_AQPC157AarvMer number,
                                      p_AQPC157AacaMer number,
                                      p_AQPC157AaavMer number,
                                      p_AQPC157AaaHMer number,
                                      
                                      p_AQPC157AacMda4 varchar2,
                                      p_AQPC157Aacrgap number,
                                      p_AQPC157Aarvgap number,
                                      p_AQPC157Aacagap number,
                                      p_AQPC157Aaavgap number,
                                      p_AQPC157AaaHgap number,
                                      
                                      p_AQPC157AacMda5 varchar2,
                                      p_AQPC157AacrExr number,
                                      p_AQPC157AarvExr number,
                                      p_AQPC157AacaExr number,
                                      p_AQPC157AaavExr number,
                                      p_AQPC157AaaHExr number,
                                      
                                      p_AQPC157AacMda6 varchar2,
                                      p_AQPC157AacrOt1 number,
                                      p_AQPC157AarvOt1 number,
                                      p_AQPC157AacaOt1 number,
                                      p_AQPC157AaavOt1 number,
                                      p_AQPC157AaaHOt1 number,
                                      
                                      p_AQPC157AacMda7 varchar2,
                                      p_AQPC157AacrTac number,
                                      p_AQPC157AacaTac number,
                                      p_AQPC157AarvTac number,
                                      p_AQPC157AaavTac number,
                                      p_AQPC157AaaHTac number,
                                      
                                      p_AQPC157AacMda8 varchar2,
                                      p_AQPC157Aacrmue number,
                                      p_AQPC157Aacamue number,
                                      p_AQPC157Aarvmue number,
                                      p_AQPC157Aaavmue number,
                                      p_AQPC157AaaHmue number,
                                      
                                      p_AQPC157AacMda9 varchar2,
                                      p_AQPC157Aacrinm number,
                                      p_AQPC157Aacainm number,
                                      p_AQPC157Aarvinm number,
                                      p_AQPC157Aaavinm number,
                                      p_AQPC157AaaHinm number,
                                      
                                      p_AQPC157AacMd10 varchar2,
                                      p_AQPC157AACRot2 number,
                                      p_AQPC157AARVot2 number,
                                      p_AQPC157AACAot2 number,
                                      p_AQPC157AAAVot2 number,
                                      p_AQPC157AAAHot2 number,
                                      
                                      p_AQPC157AacMd11 varchar2,
                                      p_AQPC157Aacrtaf number,
                                      p_AQPC157Aacataf number,
                                      p_AQPC157Aaavtaf number,
                                      p_AQPC157AaaHtaf number,
                                      p_AQPC157Aarvrta number,
                                      
                                      p_AQPC157AacMd12 varchar2,
                                      p_AQPC157AacrTat number,
                                      p_AQPC157AacaTat number,
                                      p_AQPC157AarvTat number,
                                      p_AQPC157AaavTat number,
                                      p_AQPC157AaaHTat number,
                                      --pasivos
                                      p_AQPC157AacMd13 varchar2,
                                      p_AQPC157APrcxpC number,
                                      p_AQPC157APRVCxp number,
                                      p_AQPC157APAcxpC number,
                                      p_AQPC157APAVCxp number,
                                      p_AQPC157APAHCxp number,
                                      
                                      p_AQPC157AacMd14 varchar2,
                                      p_AQPC157APRCXPB number,
                                      p_AQPC157APRVXPB number,
                                      p_AQPC157APACXPB number,
                                      p_AQPC157APAVXPB number,
                                      p_AQPC157APAHXPB number,
                                      
                                      p_AQPC157AacMd15 varchar2,
                                      p_AQPC157APRTXP  number,
                                      p_AQPC157APATXP  number,
                                      p_AQPC157APRVTXP number,
                                      p_AQPC157APAVTXP number,
                                      p_AQPC157APAHTXP number,
                                      
                                      p_AQPC157AacMd16 varchar2,
                                      p_AQPC157APROTR1 number,
                                      p_AQPC157APAOTR1 number,
                                      p_AQPC157APAVOT1 number,
                                      p_AQPC157APAHOT1 number,
                                      p_AQPC157APRVOT1 number,
                                      
                                      p_AQPC157AacMd17 varchar2,
                                      p_AQPC157APRTPCR number,
                                      p_AQPC157APRVTPC number,
                                      p_AQPC157APATPCR number,
                                      p_AQPC157APAVTPC number,
                                      p_AQPC157APAHTPC number,
                                      
                                      p_AQPC157AacMd18 varchar2,
                                      p_AQPC157APRCXLP number,
                                      p_AQPC157APRVCXL number,
                                      p_AQPC157APACXLP number,
                                      p_AQPC157APAVCXL number,
                                      p_AQPC157APAHCXL number,
                                      
                                      p_AQPC157AacMd19 varchar2,
                                      p_AQPC157APRBST  number,
                                      p_AQPC157APRVBST number,
                                      p_AQPC157APABST  number,
                                      p_AQPC157APAVBST number,
                                      p_AQPC157APAHBST number,
                                      
                                      p_AQPC157AacMd20 varchar2,
                                      p_AQPC157APROTR2 number,
                                      p_AQPC157APRVOT2 number,
                                      p_AQPC157APAOTR2 number,
                                      p_AQPC157APAVOT2 number,
                                      p_AQPC157APAHOT2 number,
                                      
                                      p_AQPC157AacMd21 varchar2,
                                      p_AQPC157APRPNCO number,
                                      p_AQPC157APRVPNC number,
                                      p_AQPC157APAPNCO number,
                                      p_AQPC157APAVPNC number,
                                      p_AQPC157APAHPNC number,
                                      
                                      p_AQPC157AacMd22 varchar2,
                                      p_AQPC157APRTTPA number,
                                      p_AQPC157APRVTTP number,
                                      p_AQPC157APATTPA number,
                                      p_AQPC157APAVTTP number,
                                      p_AQPC157APAHTTP number,
                                      
                                      p_AQPC157AacMd23 varchar2,
                                      p_AQPC157APRCAP  number,
                                      p_AQPC157APRVCAP number,
                                      p_AQPC157APACAP  number,
                                      p_AQPC157APAVCAP number,
                                      p_AQPC157APAHCAP number,
                                      
                                      p_AQPC157AacMd24 varchar2,
                                      p_AQPC157APRRESE number,
                                      p_AQPC157APRVRES number,
                                      p_AQPC157APARESE number,
                                      p_AQPC157APAVRES number,
                                      p_AQPC157APAHRES number,
                                      
                                      p_AQPC157AacMd25 varchar2,
                                      p_AQPC157APRREAC number,
                                      p_AQPC157APRVREA number,
                                      p_AQPC157APAREAC number,
                                      p_AQPC157APAVREA number,
                                      p_AQPC157APAHREA number,
                                      
                                      p_AQPC157AacMd26 varchar2,
                                      p_AQPC157APRRDEJ number,
                                      p_AQPC157APRVRDE number,
                                      p_AQPC157APAVRDE number,
                                      p_AQPC157APARDEJ number,
                                      p_AQPC157APAHRDE number,
                                      
                                      p_AQPC157AacMd27 varchar2,
                                      p_AQPC157APROTR3 number,
                                      p_AQPC157APRVOT3 number,
                                      p_AQPC157APAOTR3 number,
                                      p_AQPC157APAVOT3 number,
                                      p_AQPC157APAHOT3 number,
                                      
                                      p_AQPC157AacMd28 varchar2,
                                      p_AQPC157APRPATR number,
                                      p_AQPC157APRVPAT number,
                                      p_AQPC157APAPATR number,
                                      p_AQPC157APAVPAT number,
                                      p_AQPC157APAHPAT number,
                                      
                                      p_AQPC157AacMd29 varchar2,
                                      p_AQPC157APRTTPP number,
                                      p_AQPC157APRVTPP number,
                                      p_AQPC157APATTPP number,
                                      p_AQPC157APAVTPP number,
                                      p_AQPC157APAHTPP number,
                                      --ventas
                                      p_AQPC157AacMd30 varchar2,
                                      p_AQPC157AVRVEN  number,
                                      p_AQPC157AVRVVEN number,
                                      p_AQPC157AVAVEN  number,
                                      p_AQPC157AVAVVEN number,
                                      p_AQPC157AVAHVEN number,
                                      
                                      p_AQPC157AacMd31 varchar2,
                                      p_AQPC157AVRCOSV number,
                                      p_AQPC157AVRVCSV number,
                                      p_AQPC157AVACOSV number,
                                      p_AQPC157AVAVCSV number,
                                      p_AQPC157AVHCOSV number,
                                      
                                      p_AQPC157AacMd32 varchar2,
                                      p_AQPC157AVRUBR  number,
                                      p_AQPC157AVRVUBR number,
                                      p_AQPC157AVAUBR  number,
                                      p_AQPC157AVAVUBR number,
                                      p_AQPC157AVHUBR  number,
                                      
                                      p_AQPC157AacMd33 varchar2,
                                      p_AQPC157AVRCOOP number,
                                      p_AQPC157AVRVCOP number,
                                      p_AQPC157AVACOOP number,
                                      p_AQPC157AVAVCOP number,
                                      p_AQPC157AVHCOOP number,
                                      
                                      p_AQPC157AacMd34 varchar2,
                                      p_AQPC157AVRSDOI number,
                                      p_AQPC157AVRVSDO number,
                                      p_AQPC157AVASDOI number,
                                      p_AQPC157AVAVSDO number,
                                      p_AQPC157AVHSDOI number,
                                      
                                      p_AQPC157AacMd35 varchar2,
                                      p_AQPC157AVRSDV  number,
                                      p_AQPC157AVRVSD  number,
                                      p_AQPC157AVASDV  number,
                                      p_AQPC157AVAVSDV number,
                                      p_AQPC157AVHSDV  number,
                                      
                                      p_AQPC157AacMd36 varchar2,
                                      p_AQPC157AVRIMP  number,
                                      p_AQPC157AVRVIMP number,
                                      p_AQPC157AVAIMP  number,
                                      p_AQPC157AVAVIMP number,
                                      p_AQPC157AVHIMP  number,
                                      
                                      p_AQPC157AacMd37 varchar2,
                                      p_AQPC157AVROTC  number,
                                      p_AQPC157AVRVOTC number,
                                      p_AQPC157AVAOTC  number,
                                      p_AQPC157AVAVOTC number,
                                      p_AQPC157AVHOTC  number,
                                      
                                      p_AQPC157AacMd38 varchar2,
                                      p_AQPC157AVRRESE number,
                                      p_AQPC157AVRVRES number,
                                      p_AQPC157AVARESE number,
                                      p_AQPC157AVAVRES number,
                                      p_AQPC157AVHRESE number,
                                      
                                      p_AQPC157AacMd39 varchar2,
                                      p_AQPC157AVROTI  number,
                                      p_AQPC157AVRVOTI number,
                                      p_AQPC157AVAOTI  number,
                                      p_AQPC157AVAVOTI number,
                                      p_AQPC157AVHOTI  number,
                                      
                                      p_AQPC157AacMd40 varchar2,
                                      p_AQPC157AVRGFM  number,
                                      p_AQPC157AVRVGFM number,
                                      p_AQPC157AVAGFM  number,
                                      p_AQPC157AVAVGFM number,
                                      p_AQPC157AVHGFM  number,
                                      
                                      p_AQPC157AacMd41 varchar2,
                                      p_AQPC157AVRRSCP number,
                                      p_AQPC157AVRVRSC number,
                                      p_AQPC157AVARSCP number,
                                      p_AQPC157AVAVRSC number,
                                      p_AQPC157AVHRSCP number,
                                      
                                      p_AQPC157AacMd42 varchar2,
                                      p_AQPC157AVRMCCP number,
                                      p_AQPC157AVRVMCP number,
                                      p_AQPC157AVAMCCP number,
                                      p_AQPC157AVAVMCC number,
                                      p_AQPC157AVHMCCP number,
                                      
                                      p_AQPC157AacMd43 varchar2,
                                      p_AQPC157AVRRNET number,
                                      p_AQPC157AVRVRNT number,
                                      p_AQPC157AVARNET number,
                                      p_AQPC157AVAVRNE number,
                                      p_AQPC157AVHRNET number,
                                      
                                      --MACEM
                                      p_AQPC157MPMNP  varchar2,
                                      p_AQPC157MPSLDV varchar2,
                                      p_AQPC157MPSLCO varchar2,
                                      p_AQPC157MMFUD1 varchar2,
                                      p_AQPC157MMCR1  varchar2,
                                      p_AQPC157MMMCM1 varchar2,
                                      p_AQPC157MMFUD2 varchar2,
                                      p_AQPC157MMCR2  varchar2,
                                      p_AQPC157MMMCM2 varchar2,
                                      
                                      --ratios   
                                      p_AQPC157ARTLIQ1 varchar2,
                                      p_AQPC157ARTRCX1 varchar2,
                                      p_AQPC157ATRRDI1 varchar2,
                                      p_AQPC157ATREND1 varchar2,
                                      p_AQPC157ATRROE1 varchar2,
                                      p_AQPC157ATRRCR1 varchar2,
                                      
                                      p_AQPC157ARTLIQ2 varchar2,
                                      p_AQPC157ARTRCX2 varchar2,
                                      p_AQPC157ATRRDI2 varchar2,
                                      p_AQPC157ATREND2 varchar2,
                                      p_AQPC157ATRROE2 varchar2,
                                      p_AQPC157ATRRCR2 varchar2,
                                      p_AQPC157ACTCONT varchar2,
                                      
                                      p_aqpc157aacmd44 varchar2,
                                      p_aqpc157avcruto number,
                                      p_aqpc157avcauto number,
                                      p_aqpc157avrvuto number,
                                      p_aqpc157avavuto number,
                                      p_aqpc157avahuto number,
                                      
                                      p_aqpc157aacmd45 varchar2,
                                      p_aqpc157avrrgfi number,
                                      p_aqpc157avargfi number,
                                      p_aqpc157avrvgfi number,
                                      p_aqpc157avavgfi number,
                                      p_aqpc157avhrgfi number,
                                      
                                      p_aqpc157aacmd46 varchar2,
                                      p_aqpc157avrrigf number,
                                      p_aqpc157avarigf number,
                                      p_aqpc157avrvigf number,
                                      p_aqpc157avavigf number,
                                      p_aqpc157avhrigf number,
                                      
                                      p_aqpc157aacmd47 varchar2,
                                      p_aqpc157avrrgdi number,
                                      p_aqpc157avargdi number,
                                      p_aqpc157avrvgdi number,
                                      p_aqpc157avavgdi number,
                                      p_aqpc157avhrgdi number,
                                      
                                      p_aqpc157aacmd48 varchar2,
                                      p_aqpc157avrruim number,
                                      p_aqpc157avaruim number,
                                      p_aqpc157avrvuim number,
                                      p_aqpc157avavuim number,
                                      p_aqpc157avhruim number,
                                      
                                      p_aqpc157aacmd49 varchar2,
                                      p_aqpc157avrrutn number,
                                      p_aqpc157avarutn number,
                                      p_aqpc157avrvutn number,
                                      p_aqpc157avavutn number,
                                      p_aqpc157avhrutn number,
                                      
                                      p_aqpc157aacmd50 varchar2,
                                      p_aqpc157avrrgad number,
                                      p_aqpc157avargad number,
                                      p_aqpc157avrvgad number,
                                      p_aqpc157avavgad number,
                                      p_aqpc157avhrgad number,
                                      
                                      p_aqpc157aacmd51 varchar2,
                                      p_aqpc157avcrprp number,
                                      p_aqpc157avcaprp number,
                                      
                                      p_aqpc157aacmd52 varchar2,
                                      p_aqpc157avrrvig number,
                                      p_aqpc157avarvig number,
                                      
                                      p_aqpc157aacmd53 varchar2,
                                      p_aqpc157avrrcot number,
                                      p_aqpc157avarcot number,
                                      
                                      p_aqpc157aacmd54 varchar2,
                                      p_aqpc157avrrpot number,
                                      p_aqpc157avarpot number,
                                      
                                      p_aqpc157aacmd55 varchar2,
                                      p_aqpc157avrrrfi number,
                                      p_aqpc157avarrfi number,
                                      
                                      flgOk out varchar2);

  procedure sp_insert_analicredcontador_AQPC158(p_AQPC158CODOPI number,
                                                
                                                p_AQPC158Afeere  date,
                                                p_AQPC158Afeean  date,
                                                p_AQPC158AacMda1 varchar2,
                                                p_AQPC158AacrDis number,
                                                p_AQPC158AarvDis number,
                                                p_AQPC158AacaDis number,
                                                p_AQPC158AaavDis number,
                                                p_AQPC158AaaHDis number,
                                                
                                                p_AQPC158AacMda2 varchar2,
                                                p_AQPC158AacrCxC number,
                                                p_AQPC158AarvCxC number,
                                                p_AQPC158AacaCxC number,
                                                p_AQPC158AaavCxC number,
                                                p_AQPC158AaaHCxC number,
                                                
                                                p_AQPC158AacMda3 varchar2,
                                                p_AQPC158AacrMer number,
                                                p_AQPC158AarvMer number,
                                                p_AQPC158AacaMer number,
                                                p_AQPC158AaavMer number,
                                                p_AQPC158AaaHMer number,
                                                
                                                p_AQPC158AacMda4 varchar2,
                                                p_AQPC158Aacrgap number,
                                                p_AQPC158Aarvgap number,
                                                p_AQPC158Aacagap number,
                                                p_AQPC158Aaavgap number,
                                                p_AQPC158AaaHgap number,
                                                
                                                p_AQPC158AacMda5 varchar2,
                                                p_AQPC158AacrExr number,
                                                p_AQPC158AarvExr number,
                                                p_AQPC158AacaExr number,
                                                p_AQPC158AaavExr number,
                                                p_AQPC158AaaHExr number,
                                                
                                                /*p_AQPC158AacMda6 varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AacrOt1 number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AarvOt1 number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AacaOt1 number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AaavOt1 number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AaaHOt1 number,*/
                                                
                                                p_AQPC158AacMda7 varchar2,
                                                p_AQPC158AacrTac number,
                                                p_AQPC158AacaTac number,
                                                p_AQPC158AarvTac number,
                                                p_AQPC158AaavTac number,
                                                p_AQPC158AaaHTac number,
                                                
                                                p_AQPC158AacMda8 varchar2,
                                                p_AQPC158Aacrmue number,
                                                p_AQPC158Aacamue number,
                                                p_AQPC158Aarvmue number,
                                                p_AQPC158Aaavmue number,
                                                p_AQPC158AaaHmue number,
                                                
                                                p_AQPC158AacMda9 varchar2,
                                                p_AQPC158Aacrinm number,
                                                p_AQPC158Aacainm number,
                                                p_AQPC158Aarvinm number,
                                                p_AQPC158Aaavinm number,
                                                p_AQPC158AaaHinm number,
                                                
                                                p_AQPC158AacMd10 varchar2,
                                                p_AQPC158AACRot2 number,
                                                p_AQPC158AARVot2 number,
                                                p_AQPC158AACAot2 number,
                                                p_AQPC158AAAVot2 number,
                                                p_AQPC158AAAHot2 number,
                                                
                                                p_AQPC158AacMd11 varchar2,
                                                p_AQPC158Aacrtaf number,
                                                p_AQPC158Aacataf number,
                                                p_AQPC158Aaavtaf number,
                                                p_AQPC158AaaHtaf number,
                                                p_AQPC158Aarvrta number,
                                                
                                                p_AQPC158AacMd12 varchar2,
                                                p_AQPC158AacrTat number,
                                                p_AQPC158AacaTat number,
                                                p_AQPC158AarvTat number,
                                                p_AQPC158AaavTat number,
                                                p_AQPC158AaaHTat number,
                                                --pasivos
                                                p_AQPC158AacMd13 varchar2,
                                                p_AQPC158APrcxpC number,
                                                p_AQPC158APRVCxp number,
                                                p_AQPC158APAcxpC number,
                                                p_AQPC158APAVCxp number,
                                                p_AQPC158APAHCxp number,
                                                
                                                p_AQPC158AacMd14 varchar2,
                                                p_AQPC158APRCXPB number,
                                                p_AQPC158APRVXPB number,
                                                p_AQPC158APACXPB number,
                                                p_AQPC158APAVXPB number,
                                                p_AQPC158APAHXPB number,
                                                
                                                p_AQPC158AacMd15 varchar2,
                                                p_AQPC158APRTXP  number,
                                                p_AQPC158APATXP  number,
                                                p_AQPC158APRVTXP number,
                                                p_AQPC158APAVTXP number,
                                                p_AQPC158APAHTXP number,
                                                
                                                p_AQPC158AacMd16 varchar2,
                                                p_AQPC158APROTR1 number,
                                                p_AQPC158APAOTR1 number,
                                                p_AQPC158APAVOT1 number,
                                                p_AQPC158APAHOT1 number,
                                                p_AQPC158APRVOT1 number,
                                                
                                                p_AQPC158AacMd17 varchar2,
                                                p_AQPC158APRTPCR number,
                                                p_AQPC158APRVTPC number,
                                                p_AQPC158APATPCR number,
                                                p_AQPC158APAVTPC number,
                                                p_AQPC158APAHTPC number,
                                                
                                                p_AQPC158AacMd18 varchar2,
                                                p_AQPC158APRCXLP number,
                                                p_AQPC158APRVCXL number,
                                                p_AQPC158APACXLP number,
                                                p_AQPC158APAVCXL number,
                                                p_AQPC158APAHCXL number,
                                                
                                                p_AQPC158AacMd19 varchar2,
                                                p_AQPC158APRBST  number,
                                                p_AQPC158APRVBST number,
                                                p_AQPC158APABST  number,
                                                p_AQPC158APAVBST number,
                                                p_AQPC158APAHBST number,
                                                
                                                p_AQPC158AacMd20 varchar2,
                                                p_AQPC158APROTR2 number,
                                                p_AQPC158APRVOT2 number,
                                                p_AQPC158APAOTR2 number,
                                                p_AQPC158APAVOT2 number,
                                                p_AQPC158APAHOT2 number,
                                                
                                                p_AQPC158AacMd21 varchar2,
                                                p_AQPC158APRPNCO number,
                                                p_AQPC158APRVPNC number,
                                                p_AQPC158APAPNCO number,
                                                p_AQPC158APAVPNC number,
                                                p_AQPC158APAHPNC number,
                                                
                                                p_AQPC158AacMd22 varchar2,
                                                p_AQPC158APRTTPA number,
                                                p_AQPC158APRVTTP number,
                                                p_AQPC158APATTPA number,
                                                p_AQPC158APAVTTP number,
                                                p_AQPC158APAHTTP number,
                                                
                                                p_AQPC158AacMd23 varchar2,
                                                p_AQPC158APRCAP  number,
                                                p_AQPC158APRVCAP number,
                                                p_AQPC158APACAP  number,
                                                p_AQPC158APAVCAP number,
                                                p_AQPC158APAHCAP number,
                                                
                                                p_AQPC158AacMd24 varchar2,
                                                p_AQPC158APRRESE number,
                                                p_AQPC158APRVRES number,
                                                p_AQPC158APARESE number,
                                                p_AQPC158APAVRES number,
                                                p_AQPC158APAHRES number,
                                                
                                                p_AQPC158AacMd25 varchar2,
                                                p_AQPC158APRREAC number,
                                                p_AQPC158APRVREA number,
                                                p_AQPC158APAREAC number,
                                                p_AQPC158APAVREA number,
                                                p_AQPC158APAHREA number,
                                                
                                                p_AQPC158AacMd26 varchar2,
                                                p_AQPC158APRRDEJ number,
                                                p_AQPC158APRVRDE number,
                                                p_AQPC158APAVRDE number,
                                                p_AQPC158APARDEJ number,
                                                p_AQPC158APAHRDE number,
                                                
                                                p_AQPC158AacMd27 varchar2,
                                                p_AQPC158APROTR3 number,
                                                p_AQPC158APRVOT3 number,
                                                p_AQPC158APAOTR3 number,
                                                p_AQPC158APAVOT3 number,
                                                p_AQPC158APAHOT3 number,
                                                
                                                p_AQPC158AacMd28 varchar2,
                                                p_AQPC158APRPATR number,
                                                p_AQPC158APRVPAT number,
                                                p_AQPC158APAPATR number,
                                                p_AQPC158APAVPAT number,
                                                p_AQPC158APAHPAT number,
                                                
                                                p_AQPC158AacMd29 varchar2,
                                                p_AQPC158APRTTPP number,
                                                p_AQPC158APRVTPP number,
                                                p_AQPC158APATTPP number,
                                                p_AQPC158APAVTPP number,
                                                p_AQPC158APAHTPP number,
                                                --ventas
                                                p_AQPC158AacMd30 varchar2,
                                                p_AQPC158AVRVEN  number,
                                                p_AQPC158AVRVVEN number,
                                                p_AQPC158AVAVEN  number,
                                                p_AQPC158AVAVVEN number,
                                                p_AQPC158AVAHVEN number,
                                                
                                                p_AQPC158AacMd31 varchar2,
                                                p_AQPC158AVRCOSV number,
                                                p_AQPC158AVRVCSV number,
                                                p_AQPC158AVACOSV number,
                                                p_AQPC158AVAVCSV number,
                                                p_AQPC158AVHCOSV number,
                                                
                                                p_AQPC158AacMd32 varchar2,
                                                p_AQPC158AVRUBR  number,
                                                p_AQPC158AVRVUBR number,
                                                p_AQPC158AVAUBR  number,
                                                p_AQPC158AVAVUBR number,
                                                p_AQPC158AVHUBR  number,
                                                
                                                /*  p_AQPC158AacMd33 varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRCOOP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRVCOP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVACOOP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAVCOP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVHCOOP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AacMd34 varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRSDOI number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRVSDO number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVASDOI number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAVSDO number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVHSDOI number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AacMd35 varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRSDV  number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRVSD  number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVASDV  number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAVSDV number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVHSDV  number, */
                                                
                                                p_AQPC158AacMd36 varchar2,
                                                p_AQPC158AVRIMP  number,
                                                p_AQPC158AVRVIMP number,
                                                p_AQPC158AVAIMP  number,
                                                p_AQPC158AVAVIMP number,
                                                p_AQPC158AVHIMP  number,
                                                
                                                /* p_AQPC158AacMd37 varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVROTC  number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRVOTC number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAOTC  number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAVOTC number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVHOTC  number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AacMd38 varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRRESE number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRVRES number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVARESE number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAVRES number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVHRESE number, */
                                                
                                                p_AQPC158AacMd39 varchar2,
                                                p_AQPC158AVROTI  number,
                                                p_AQPC158AVRVOTI number,
                                                p_AQPC158AVAOTI  number,
                                                p_AQPC158AVAVOTI number,
                                                p_AQPC158AVHOTI  number,
                                                
                                                p_AQPC158AacMd40 varchar2,
                                                p_AQPC158AVRGFM  number,
                                                p_AQPC158AVRVGFM number,
                                                p_AQPC158AVAGFM  number,
                                                p_AQPC158AVAVGFM number,
                                                p_AQPC158AVHGFM  number,
                                                
                                                /* p_AQPC158AacMd41 varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRRSCP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRVRSC number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVARSCP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAVRSC number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVHRSCP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AacMd42 varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRMCCP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRVMCP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAMCCP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAVMCC number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVHMCCP number, */
                                                
                                                p_AQPC158AacMd43 varchar2,
                                                p_AQPC158AVRRNET number,
                                                p_AQPC158AVRVRNT number,
                                                p_AQPC158AVARNET number,
                                                p_AQPC158AVAVRNE number,
                                                p_AQPC158AVHRNET number,
                                                --ratios   
                                                p_AQPC158ARTLIQ1 varchar2,
                                                p_AQPC158ARTRCX1 varchar2,
                                                p_AQPC158ATRRDI1 varchar2,
                                                p_AQPC158ATREND1 varchar2,
                                                p_AQPC158ATRROE1 varchar2,
                                                p_AQPC158ATRRCR1 varchar2,
                                                
                                                p_AQPC158ARTLIQ2 varchar2,
                                                p_AQPC158ARTRCX2 varchar2,
                                                p_AQPC158ATRRDI2 varchar2,
                                                p_AQPC158ATREND2 varchar2,
                                                p_AQPC158ATRROE2 varchar2,
                                                p_AQPC158ATRRCR2 varchar2,
                                                
                                                --nuevos campos
                                                p_aqpc158aacmd44 varchar2,
                                                p_aqpc158aacrota number,
                                                p_aqpc158aacaota number,
                                                p_aqpc158aarvota number,
                                                p_aqpc158aaavota number,
                                                p_aqpc158aaahota number,
                                                
                                                p_aqpc158aacmd45 varchar2,
                                                p_aqpc158avcrgtv number,
                                                p_aqpc158avcagtv number,
                                                p_aqpc158avrvgtv number,
                                                p_aqpc158avavgtv number,
                                                p_aqpc158avahgtv number,
                                                
                                                p_aqpc158aacmd46 varchar2,
                                                p_aqpc158avrrgad number,
                                                p_aqpc158avargad number,
                                                p_aqpc158avrvgad number,
                                                p_aqpc158avavgad number,
                                                p_aqpc158avhrgad number,
                                                
                                                p_aqpc158aacmd47 varchar2,
                                                p_aqpc158avrruto number,
                                                p_aqpc158avaruto number,
                                                p_aqpc158avrvuto number,
                                                p_aqpc158avavuto number,
                                                p_aqpc158avhruto number,
                                                
                                                p_aqpc158aacmd48 varchar2,
                                                p_aqpc158avrrgfi number,
                                                p_aqpc158avargfi number,
                                                p_aqpc158avrvgfi number,
                                                p_aqpc158avavgfi number,
                                                p_aqpc158avhrgfi number,
                                                
                                                p_aqpc158aacmd49 varchar2,
                                                p_aqpc158avrrigf number,
                                                p_aqpc158avarigf number,
                                                p_aqpc158avrvigf number,
                                                p_aqpc158avavigf number,
                                                p_aqpc158avhrigf number,
                                                
                                                p_aqpc158aacmd50 varchar2,
                                                p_aqpc158avrrgdi number,
                                                p_aqpc158avargdi number,
                                                p_aqpc158avrvgdi number,
                                                p_aqpc158avavgdi number,
                                                p_aqpc158avhrgdi number,
                                                
                                                p_aqpc158aacmd51 varchar2,
                                                p_aqpc158avrruim number,
                                                p_aqpc158avaruim number,
                                                p_aqpc158avrvuim number,
                                                p_aqpc158avavuim number,
                                                p_aqpc158avhruim number,
                                                
                                                p_aqpc158aacmd52 varchar2,
                                                p_aqpc158avrrutn number,
                                                p_aqpc158avarutn number,
                                                p_aqpc158avrvutn number,
                                                p_aqpc158avavutn number,
                                                p_aqpc158avhrutn number,
                                                
                                                p_Modo varchar2,
                                                flgOk  out varchar2);
  procedure sp_obtcorr_aqpc156(Instancia number, CodOpinion out number);
  --procedure sp_obt_max_nro_fpae70(Instancia number, Max70Nro out number);
  procedure sp_cargar_solic_pend_opinion(instancia      number,
                                         ubuser         varchar2,
                                         UsuarSuplencia varchar2,
                                         fechHoy        date,
                                         xIdentfPerf    number,
                                         flgTerm        out varchar2);
  procedure sp_cargar_opiniones_156(auxUsu    VARCHAR2,
                                    NroNivel  number,
                                    fechHoy   DATE,
                                    flgcrg194 out varchar2);

  procedure sp_consul_por_solic156(auxint      number,
                                   ubuser      varchar2,
                                   fechHoy     date,
                                   mensajeErro out varchar2); --01042024   

  procedure sp_obtener_datos_Opinion(auxint         NUMBER,
                                     NomClie        OUT VARCHAR2,
                                     xMontoCred     OUT NUMBER,
                                     xDescMod       OUT VARCHAR2,
                                     auxCta         OUT NUMBER,
                                     auxOper        OUT NUMBER,
                                     xDescProd      OUT VARCHAR2,
                                     xDescTipoSolic OUT VARCHAR2,
                                     AUXASES        OUT VARCHAR2,
                                     xFechIngr      OUT DATE);
  --procedure sp_grabar_comentarios(codopini number, instancia number, usuario varchar2, comentario long);
  procedure sp_grabar_comentarios_ACR_GA(codopini         number,
                                         instancia        number,
                                         usuario          varchar2,
                                         NivelComent      number,
                                         TipoView         varchar2,
                                         CodTipoSolicitud number,
                                         xAQPC171ANCNEG   varchar2,
                                         xAQPC171ANVIC    VARCHAR2,
                                         xAQPC171FCN      varchar2,
                                         xAQPC171AESFCC   varchar2,
                                         xAQPC171RDCLN    varchar2,
                                         xAQPC171ANCP     varchar2,
                                         xAQPC171ANCPG    varchar2,
                                         xAQPC171DANDC    varchar2,
                                         xAQPC171DGCOR    varchar2,
                                         xAQPC171RANCNEG  varchar2,
                                         xAQPC171MTREP    varchar2,
                                         xAQPC171RAESFCC  varchar2,
                                         xAQPC171ANCPRF   varchar2,
                                         xAQPC171ANVPG    varchar2,
                                         xAQPC171DEGV     varchar2,
                                         xAQPC171RFANCNE  varchar2,
                                         xAQPC171MTREFN   varchar2,
                                         xAQPC171RFAESFC  varchar2,
                                         xAQPC171RFANCPR  varchar2,
                                         xAQPC171RFANVPG  varchar2,
                                         xAQPC171RFDEGV   varchar2,
                                         xAQPC156ESTOP    varchar2, --INI mod rcastro 10072023
                                         xAQPC171ARGRECO  varchar2,
                                         xAQPC171ANACOME  varchar2,
                                         xAQPC171RESOLRE  varchar2,
                                         xAQPC171CONDREC  varchar2,
                                         xComentRiesgos   varchar2, --23082023
                                         xResoluRiesgos   varchar2,
                                         xCondiRecomRiesg varchar2); --2410

  procedure sp_grabar_comentarios_riesgos(codopini       number,
                                          instancia      number,
                                          usuario        varchar2,
                                          NivelComent    number,
                                          xAQPC171COMEN  varchar2,
                                          xAQPC171RESOL  varchar2,
                                          xAQPC171CONREC varchar2);
  procedure sp_Consultar_codOpinio(instancia  number,
                                   flgEstado  varchar2,
                                   codNivel   number,
                                   codOpinio  out number,
                                   flgEstdOpi out varchar2); --mod rcastro 10072023

  procedure sp_actulizar_estado_156(codopinion       number,
                                    instancia        number,
                                    flgEstado        varchar2,
                                    CodNivel         number,
                                    p_UserDerivado   varchar2,
                                    AnalistaDerivado varchar2);
  procedure sp_actualizar_estado_opi_156(codopinion number,
                                         instancia  number,
                                         flgEstado  varchar2);
  procedure sp_cargar_c162(codopin number);
  procedure sp_insert_garnt_aqpc162(codopin       number,
                                    fechaHoy      date,
                                    tipGarant     varchar2,
                                    descGarnt     varchar2,
                                    propietar     varchar2,
                                    fecTasa       date,
                                    tasad         varchar2,
                                    valcom        varchar2,
                                    valRealiz     varchar2,
                                    valGravamen   varchar2,
                                    Cobertur      varchar2,
                                    xModulo       number,
                                    xTipOperacion number,
                                    p_tipDeclar   varchar2,
                                    p_fechDecl    date,
                                    p_valoGarnt   varchar2);
  procedure sp_cargar_c161(codopin number);
  procedure sp_insert_relacFinan_aqpc161(codopin   number,
                                         fechaHoy  date,
                                         EntiFinc  varchar2,
                                         Cuota     varchar2,
                                         sldoCapit varchar2,
                                         TipoCred  varchar2);
  procedure sp_valid_Segm_NoMinorista(instancia   number,
                                      flgEsNoMino out varchar2);

  procedure sp_grabarLogEstadoOpinion(codOpinion   number,
                                      fechaActual  date,
                                      Hora         varchar2,
                                      UsuarioEjec  varchar2,
                                      codCadena    number,
                                      estadoActual varchar2);

  procedure sp_cambiarEstadoAqpc156(Instancia      number,
                                    codopinion     number,
                                    flgCambiEstado varchar2,
                                    codNivel       number,
                                    NuevoAsunto    varchar2);
  procedure sp_validar_Etapa_Opin(Instancia  number,
                                  codopinion number,
                                  codNIVEL   out number,
                                  DescEtapa  out varchar2);
  procedure sp_actualizarEstado156(intancia   number,
                                   codOpinion number,
                                   FlgEstado  varchar2);
  procedure sp_buscar_usuario_correo_GA(SucurCredito numeric,
                                        xCodCargo    number,
                                        UsuarioGA    out varchar2,
                                        xEmail       out varchar2);
  procedure sp_actualizar_GA_156(codOpinion number,
                                 solicitud  number,
                                 userGA     varchar2);
  procedure sp_delegar_analis_senior(codOpinion    number,
                                     solicitud     number,
                                     cuenta        number,
                                     codAnalista   varchar2,
                                     NivelAprobOpi number,
                                     codNivelPerfiDeriv number); --21022024
                                     
  procedure sp_obtener_correos_usuarios(flujo          number,          
                                        codOpinion     number,
                                        instancia      number,
                                        FechaHoy       date, --Ini Mod 25072023
                                        sucuCred       number,
                                      /*UsuAnalisCred  varchar2,   18112024
                                        UsuGA          varchar2,
                                        UsuGZona       varchar2,
                                        UsuARiesgos    varchar2, --Ini Mod 10072023
                                        UsuSupervAdm   varchar2,
                                        UsuJefeAdm     varchar2,
                                        UsuGereRiesg   varchar2, --Fin Mod 10072023  */
                                        Correos        out varchar2,
                                        CorreosEnCopia out varchar2);

  procedure sp_actual_propuesto_156(instancia  number,
                                    codOpini   number,
                                    saldo      out number,
                                    montootorg out varchar2,
                                    cuotas     out number,
                                    ncuotas    out varchar2,
                                    tasa       out number);

  procedure sp_valid_aprob_anriesgo(codOpini number, flgEstd out varchar2);

  procedure sp_val_etap_aprobacion(instancia     number,
                                   xflagEstAprob out varchar2);
  procedure sp_actuali_responsTotal(instancia     number,
                                    xcodOpinion   number,
                                    montoConsolid number,
                                    fechaHoy      date,
                                    sucurCred     number);

  procedure sp_obtn_cuot_cred_vigentes(instancia         number,
                                       xSumcuotaVigRec   OUT number,
                                       xSumcuotaVigAnter OUT number,
                                       xCredicContingAct out number, --21082023  
                                       xCredicContingAnt out number, --21082023                                     
                                       xCredPotencAct    OUT number, --21082023
                                       xCredPotencAnt    OUT number --21082023                                                                              
                                       );
  PROCEDURE sp_cargar_entidad_gast_finan(codOpinion number,
                                         instancia  number);

  procedure sp_obtn_cuot_cred_vigen_Anter(auxInstnc         number, --30042024
                                          auxTmod           number,
                                          xSumcuotaVigAnter OUT number,
                                          xCredicContingAnt out number, --                                     
                                          xCredPotencAnt    OUT number);

  procedure sp_carg_ent_gst_fin_anter(codOpinion   number, --30042024
                                      flujo        varchar2,
                                      instanciaAnt number);

  Procedure sp_obtner_Instanci_anterior(instancia  number,
                                        Indicflujo varchar2,
                                        auxInstnc  out number,
                                        fechAntOut out date,
                                        TipFlujCN  out varchar2); --30042024
  procedure sp_desc_tipo_solicitud(CodTipoSolicitud  number,
                                   DescTipoSolicitud OUT varchar2);
  procedure sp_obtener_datos_cabecera(xSucursal     number,
                                      cuenta        number,
                                      nomSucursCred out varchar2,
                                      nombreClient  out varchar2);
  procedure sp_validar_modelo_Evaluacion(instancia     number,
                                         flgModelEval  out varchar2,
                                         txtTipoEvalu  out varchar2,
                                         flgEsEvalFluj out varchar2); --30062023

  procedure sp_insert_aqpc811(p_AQPC811CODOPI   number,
                              p_AQPC811FecEvRec date,
                              p_AQPC811FecEvAnt date,
                              
                              p_AQPC811AICMDA1 varchar2,
                              p_AQPC811AIERBRT number,
                              p_AQPC811AIEABRT number,
                              p_AQPC811AIAHBRT number,
                              
                              p_AQPC811AICMDA2 varchar2,
                              p_AQPC811AIERBRY number,
                              p_AQPC811AIEABRY number,
                              p_AQPC811AIAHBRY number,
                              
                              p_AQPC811AICMDA3 varchar2,
                              p_AQPC811AIERBRC number,
                              p_AQPC811AIEABRC number,
                              p_AQPC811AIAHBRC number,
                              
                              p_AQPC811AICMDA4 varchar2,
                              p_AQPC811AIERBRO number,
                              p_AQPC811AIEABRO number,
                              p_AQPC811AIAHBRO number,
                              
                              p_AQPC811AIcMd24 varchar2,
                              p_AQPC811AIerBOT number,
                              p_AQPC811AIeaBOT number,
                              p_AQPC811AIahBOT number,
                              
                              p_AQPC811AICMDA5 varchar2,
                              p_AQPC811AIERBTO number,
                              p_AQPC811AIEABTO number,
                              p_AQPC811AIAHBTO number,
                              
                              p_AQPC811AICMDA6 varchar2,
                              p_AQPC811AIERNTT number,
                              p_AQPC811AIEANTT number,
                              p_AQPC811AIAHNTT number,
                              
                              p_AQPC811AICMDA7 varchar2,
                              p_AQPC811AIERNTY number,
                              p_AQPC811AIEANTY number,
                              p_AQPC811AIAHNTY number,
                              
                              p_AQPC811AICMDA8 varchar2,
                              p_AQPC811AIERNTC number,
                              p_AQPC811AIEANTC number,
                              p_AQPC811AIAHNTC number,
                              
                              p_AQPC811AICMDA9 varchar2,
                              p_AQPC811AIERNTO number,
                              p_AQPC811AIEANTO number,
                              p_AQPC811AIAHNTO number,
                              
                              p_AQPC811AEcMd25 varchar2,
                              p_AQPC811AEerNOT NUMBER,
                              p_AQPC811AEeaNOT NUMBER,
                              p_AQPC811AEahNOT NUMBER,
                              
                              p_AQPC811AICMD10 varchar2,
                              p_AQPC811AIERNTL number,
                              p_AQPC811AIEANTL number,
                              p_AQPC811AIAHNTL number,
                              
                              p_AQPC811AECMD11 varchar2,
                              p_AQPC811AEERALI number,
                              p_AQPC811AEEAALI number,
                              p_AQPC811AEAHALI number,
                              
                              p_AQPC811AECMD12 varchar2,
                              p_AQPC811AEERALQ number,
                              p_AQPC811AEEAALQ number,
                              p_AQPC811AEAHALQ number,
                              
                              p_AQPC811AECMD13 varchar2,
                              p_AQPC811AEERTRP number,
                              p_AQPC811AEEATRP number,
                              p_AQPC811AEAHTRP number,
                              
                              p_AQPC811AECMD14 varchar2,
                              p_AQPC811AEEREDU number,
                              p_AQPC811AEEAEDU number,
                              p_AQPC811AEAHEDU number,
                              
                              p_AQPC811AECMD15 varchar2,
                              p_AQPC811AEERSER number,
                              p_AQPC811AEEASER number,
                              p_AQPC811AEAHSER number,
                              
                              p_AQPC811AECMD16 varchar2,
                              p_AQPC811AEERFAM number,
                              p_AQPC811AEEAFAM number,
                              p_AQPC811AEAHFAM number,
                              
                              p_AQPC811AECMD17 varchar2,
                              p_AQPC811AEEROTR number,
                              p_AQPC811AEEAOTR number,
                              p_AQPC811AEAHOTR number,
                              
                              p_AQPC811AECMD18 varchar2,
                              p_AQPC811AEERGFT number,
                              p_AQPC811AEEAGFT number,
                              p_AQPC811AEAHGFT number,
                              
                              p_AQPC811AGCMD19 varchar2,
                              p_AQPC811AGERGFT number,
                              p_AQPC811AGEAGFT number,
                              p_AQPC811AGAHGFT number,
                              
                              p_AQPC811AECMD20 varchar2,
                              p_AQPC811AEERNTM number,
                              p_AQPC811AEEANTM number,
                              p_AQPC811AEAHNTM number,
                              
                              p_AQPC811AECMD21 varchar2,
                              p_AQPC811AEERCRP number,
                              p_AQPC811AEEACRP number,
                              
                              p_AQPC811AECMD22 varchar2,
                              p_AQPC811AEERCRV number,
                              p_AQPC811AEEACRV number,
                              
                              p_AQPC811AECMD23 varchar2,
                              p_AQPC811AEEREXF number,
                              p_AQPC811AEEAEXF number,
                              
                              p_AQPC811ARTIGN1 varchar2,
                              p_AQPC811ARTIGN2 varchar2,
                              p_AQPC811ARTEXN1 varchar2,
                              p_AQPC811ARTEXN2 varchar2,
                              
                              p_AQPC811AECMD24 VARCHAR2, --21082023
                              p_AQPC811AEERCOT NUMBER,
                              p_AQPC811AEEACOT NUMBER,
                              p_AQPC811AECMD26 VARCHAR2,
                              p_AQPC811AEERPOT NUMBER,
                              p_AQPC811AEEAPOT NUMBER);

  PROCEDURE sp_lista_relac_financ(CodOpinion number,
                                  fechaHoy   date,
                                  instancia  number);
  procedure sp_niveles_opinion(TipoSolicitud    number,
                               montoConsolidado number,
                               nivelMaximoAlcan out number);
  procedure sp_obtener_coment_aqpc171(CodOpinion      number,
                                      instancia       number,
                                      xAQPC171ANCNEG  out varchar2,
                                      xAQPC171ANVIC   out varchar2,
                                      xAQPC171FCN     out varchar2,
                                      xAQPC171AESFCC  out varchar2,
                                      xAQPC171RDCLN   out varchar2,
                                      xAQPC171ANCP    out varchar2,
                                      xAQPC171ANCPG   out varchar2,
                                      xAQPC171DANDC   out varchar2,
                                      xAQPC171DGCOR   out varchar2,
                                      xAQPC171RANCNEG out varchar2,
                                      xAQPC171MTREP   out varchar2,
                                      xAQPC171RAESFCC out varchar2,
                                      xAQPC171ANCPRF  out varchar2,
                                      xAQPC171ANVPG   out varchar2,
                                      xAQPC171DEGV    out varchar2,
                                      xAQPC171RFANCNE out varchar2,
                                      xAQPC171MTREFN  out varchar2,
                                      xAQPC171RFAESFC out varchar2,
                                      xAQPC171RFANCPR out varchar2,
                                      xAQPC171RFANVPG out varchar2,
                                      xAQPC171RFDEGV  out varchar2,
                                      xAQPC171USURAR  out varchar2,
                                      xAQPC171COMEN   out varchar2,
                                      xAQPC171RESOL   out varchar2,
                                      xAQPC171CONREC  out varchar2,
                                      xAQPC171ARGRECO out varchar2, -- INI MOD RCASTRO 10072023
                                      xAQPC171ANACOME out varchar2,
                                      xAQPC171RESOLRE out varchar2,
                                      xAQPC171CONDREC out varchar2,
                                      xAQPC171MOTOBSV out varchar2); -- FIN MOD RCASTRO 10072023 

  PROCEDURE sp_insert_aqpc813_titul(codOpinion      number,
                                    instancia       number,
                                    xAQPC813PAIS    number,
                                    xAQPC813PETDOC  number,
                                    xAQPC813PENDOC  varchar2,
                                    xAQPC813DESTDOC varchar2,
                                    xAQPC813NOMCLI  varchar2,
                                    xAQPC813RELAC   varchar2);

  PROCEDURE sp_lista_opiniones(instancia    number,
                               userIngreso  varchar2,
                               nivelUsuIng  number,
                               userSuplente varchar2,
                               nivelUsuSupl number,
                               fechaIngreso date,
                               msgError     out varchar2); --01042024
  PROCEDURE sp_limpiar_por_usu_aqpc194(userIngreso varchar2);

  PROCEDURE sp_obtenr_usu_AC_GA(instancia number,
                                sucurCred number,
                                usuarioGA OUT varchar2,
                                usuarioAC OUT varchar2);

  PROCEDURE sp_actualiza_reconsideracion(instancia number, -- MOD RCASTRO 10072023
                                         codOpini  number);

  PROCEDURE sp_val_zona_soli_pertenc_AnaliRiesgo(intancia        number,
                                                 userAnaliRiesgo varchar2,
                                                 flgTieneAsignad out varchar2); -- MOD RCASTRO 24072023  

  PROCEDURE sp_obtn_usuar_suplencia(fechaActual   date,
                                    usuario       varchar2,
                                    usuarioSuplen out varchar2,
                                    correoSuplen  out varchar2);

  PROCEDURE sp_validar_vigent_solic(instancia number,
                                    flgActivo OUT varchar2);

  PROCEDURE sp_val_visuali_anali_contd(instancia      number,
                                       txtProductoSBS varchar2,
                                       flgHabAnCont   out varchar2);
  PROCEDURE sp_obtener_tipo_cambio(instancia number, tipoCambio out number);

  PROCEDURE sp_lista_cred_Avalados(codOpinion number, instancia number);
  PROCEDURE sp_obtner_datos_Avald(p_empresa     NUMBER,
                                  p_sucursal    NUMBER,
                                  p_modulo      NUMBER,
                                  p_moned       NUMBER,
                                  p_papel       NUMBER,
                                  p_cuenta      NUMBER,
                                  p_operacion   NUMBER,
                                  p_suboper     NUMBER,
                                  p_tipoper     NUMBER,
                                  p_nomcli      out VARCHAR2,
                                  p_saldoAct    out NUMBER,
                                  v_mnto_Otorg  out NUMBER,
                                  v_modalidad   out VARCHAR2,
                                  v_promeAtraso out NUMBER,
                                  v_CharTotCuot out VARCHAR2,
                                  v_Cuota       OUT NUMBER,
                                  v_tasa        OUT NUMBER);

  PROCEDURE sp_Insert_AQPC816(codOpinion   NUMBER,
                              instancia    NUMBER,
                              p_empresa    NUMBER,
                              p_modulo     NUMBER,
                              p_sucursal   NUMBER,
                              p_moned      NUMBER,
                              p_papel      NUMBER,
                              p_cuenta     NUMBER,
                              p_operacion  NUMBER,
                              p_suboper    NUMBER,
                              p_tipoper    NUMBER,
                              p_nomClien   VARCHAR2,
                              p_saldo      NUMBER,
                              p_montoOtorg NUMBER,
                              p_modalidad  VARCHAR2,
                              p_promedAtrs NUMBER,
                              p_totCuot    VARCHAR2,
                              p_cuota      NUMBER,
                              p_tasa       NUMBER);

  PROCEDURE sp_obtn_val_cred_pyme(instancia         number, --21032023
                                  nroINTipoCN       number, --30042024                           
                                  xCredPropueAct    out number,
                                  xCredPropueAnt    out number,
                                  xSumcuotaVigRec   OUT number,
                                  xSumcuotaVigAnter OUT number,
                                  xCredicContingAct out number,
                                  xCredicContingAnt out number,
                                  xCredPotencAct    OUT number,
                                  xCredPotencAnt    OUT number);

  PROCEDURE sp_grab_log_aqpc156(codOpinion number, instancia number);

  PROCEDURE sp_grab_coment_observ(CodOpinion   number,
                                  instancia    number,
                                  NivelAprob   number,
                                  usuario      varchar2,
                                  ComentObserv varchar2,
                                  resptObser   out varchar2);

  PROCEDURE sp_grab_log_aqpc171(codOpinion number, instancia number);

  PROCEDURE sp_datos_opinion(instancia    number,
                             nivelPerfil  out number,
                             flgExiste    out varchar2,
                             UsuarioDeriv out varchar2);
  PROCEDURE sp_datos_reconsideracion(instancia     number,
                                     nroreconsider out number,
                                     estdOpini     out varchar2,
                                     p_nivelAproba out number,
                                     p_flg         out varchar2);

  PROCEDURE sp_valid_dias_proce_solici_nuev(instancia number,
                                            flgRpta   out varchar2); --06/12/2023 

  ----------------------------------------------------------------------------------------------------------      
  /*PROCEDURE sp_buscar_usu_derivar_perfil(p_Perfil         varchar2,
                                         p_UsuarioDerivar out varchar2); --21022024 */
  PROCEDURE sp_buscar_usu_derivar_perfil(flujo            number,
                                         codOpinion       number,
                                         instancia        number, 
                                         p_Perfil         varchar2,
                                         p_usuarioIngreso varchar2,       --10012025 
                                         p_nivelUsuIng    number,                  
                                         p_UsuarioDerivar out varchar2,
                                         p_nivelADerivar  out number );                                         
  PROCEDURE sp_actuali_fecha_reconsideracion(instancia    number,
                                             xFlujo       number,
                                             p_usuarioEje varchar2);
  PROCEDURE sp_grbar_estado_aqpc801(p_CodOpinion      number,
                                    p_FechaHoy        DATE,
                                    p_hora            varchar2,
                                    p_UsuarioActual   varchar2,
                                    p_NivelActual     number,
                                    p_flgEstadoActual varchar2,
                                    p_UsuarioDerivado varchar2,
                                    p_CodNivelDerivar number,
                                    p_flgReq2regis801 varchar2);

  PROCEDURE sp_drop_reg_expedig(p_ndoc varchar2, p_instancia number); --31/07/2024
  PROCEDURE sp_descripcion_ArbolPerfiles(NivelAprobador    number,
                                         DescripcionPerfil out varchar2);
  PROCEDURE sp_descripcion_firmas(codOpinion number, --18112024 
                                  instancia number, 
                                  nivel_1 out varchar2, 
                                  nivel_2 out varchar2,
                                  nive2_1 out varchar2,
                                  nive2_2 out varchar2,
                                  nive3_1 out varchar2,
                                  nive3_2 out varchar2,
                                  nive4_1 out varchar2,
                                  nive4_2 out varchar2,
                                  nive5_1 out varchar2,
                                  nive5_2 out varchar2,
                                  nive6_1 out varchar2,
                                  nive6_2 out varchar2) ;                                         
  PROCEDURE sp_NivelAprobacion_derivarAnalista(flujo                 number, --18112024
                                               codOpinion            number,
                                               tipoSolicitud         number,
                                               nivelUsuIngreso       number,
                                               nivelRequerAprobacion out number,
                                               PerfilAsignar         out varchar2);
  PROCEDURE sp_valid_operativi_bt(nivelAprobad number, HabilitadoSN out varchar2 );                                              
  PROCEDURE sp_obtnUsuariosAprobad(flujo number,
                                   codOpinion number, 
                                   instancia number, 
                                   usuAnlCred out varchar2, 
                                   usuGA out varchar2, 
                                   usuNivelAprb1 out varchar2,
                                   usuNivelAprb2 out varchar2,
                                   usuNivelAprb3 out varchar2,
                                   usuNivelAprb4 out varchar2,
                                   usuNivelAprb5 out varchar2,
                                   usuNivelAprb6 out varchar2
                                   ) ;
  PROCEDURE sp_armar_correo_Aprobacion(flujo number, CodOpinion number, instancia varchar2, NivelAproba number, usuDerivar varchar2, corrUsuIngre varchar2, correosPara out varchar2, correosCopia out varchar2);
  PROCEDURE sp_analis_gestio_opi(codOpinion number, p_usuarioGestio out varchar2, p_nivelUsuGestion out number); --10012025    
  PROCEDURE sp_validar_estado_opin(flujo number, codOpinion number, instancia number, flgOk out varchar2);  
  
  PROCEDURE sp_valid_duplic_Panel_Derivar(usuario varchar2, nivelPerfil number, flgDuplNoLis out varchar2);
end pq_cr_repo_opinion_riesgos;
/
create or replace package body pq_cr_repo_opinion_riesgos is

  procedure sp_nomclientes(codOpinion number, --07112023
                           instancia  number,
                           nrocuenta  number,
                           NomClien   out varchar2,
                           nrodocs    out varchar2) as
    CURSOR NombresCli is
      select a.pepais,
             a.petdoc,
             a.pendoc,
             A.CTTFIR,
             trim(b.penom) nombre,
             b.petipo,
             d.tdnom
        from FSR008 a, fsd001 b, FSt014 d
       where a.pgcod = 1
         and a.ctnro = nrocuenta
         and b.pepais = a.pepais
         and b.petdoc = a.petdoc
         and b.pendoc = a.pendoc
         and d.tdocum = a.petdoc
       ORDER BY CTTFIR DESC;
    --and CTTFIR <> 'T';
  
    CURSOR NomAvales is
      Select k.ctnro, k.pepais, k.petdoc, k.pendoc, p.penom nombres
        from SNG003 j, fsr008 k, fsd001 p
       where j.sng003cta = k.ctnro
         and p.pepais = k.pepais
         and p.petdoc = k.petdoc
         and p.pendoc = k.pendoc
         and j.sng001inst = instancia;
    /*select distinct r008.pepais,
                   r008.petdoc,
                   r008.pendoc dni,
                   f.penom     nombres
     from fsr011 r11
     join fsd011 d011
       on d011.pgcod = r11.r2cod
      and d011.scmod = r11.r2mod
      and d011.sccta = r11.r2cta
      and d011.scoper = r11.r2oper
      and d011.scstat <> 99
     join fsr008 r008
       on r008.ctnro = d011.sccta
      and r008.ttcod = 1
      and r008.cttfir = 'T'
     join fsd001 f
       on r008.pepais = f.pepais
      and r008.petdoc = f.petdoc
      and r008.pendoc = f.pendoc
    where r11.r1cod = 1
      and r11.r1cta = nrocuenta
      and r11.relcod = 50
      and r11.r011co = 'S'
      and r11.r2tope = 91;*/
  
    auxNombres   varchar2(400);
    auxAvales    varchar2(400);
    txtNrodoc    varchar2(400);
    xpetdoc      number(4);
    ndocTitu     varchar2(12);
    xRelacion    varchar2(30);
    xNombreClien varchar2(300);
    auxNroDoc    varchar2(300);
  Begin
    BEGIN
      DELETE FROM AQPC813
       WHERE AQPC813INSTAN = instancia
         AND AQPC813AUX2 = codOpinion; --07112023
      commit;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    For xrow in NombresCli loop
      --old
      auxNombres := auxNombres || xrow.nombre || '; ';
      --docs
      if xrow.petdoc = 21 then
        txtNrodoc := txtNrodoc || 'DNI: ' || trim(xrow.pendoc) || ';';
      end if;
      if xrow.petdoc = 9 then
        txtNrodoc := txtNrodoc || 'RUC: ' || trim(xrow.pendoc) || ';';
      end if;
    
      --buscar nombre cliente
      IF xrow.petipo = 'F' then
        BEGIN
          SELECT TRIM(PFAPE1) || ' ' || TRIM(PFAPE2) || ' ' || TRIM(PFNOM1) || ' ' ||
                 TRIM(PFNOM2)
            INTO xNombreClien
            FROM FSd002
           WHERE PFPAIS = XROW.PEPAIS
             AND PFTDOC = XROW.PETDOC
             AND PFNDOC = XROW.PENDOC
             AND ROWNUM < 2;
        EXCEPTION
          WHEN OTHERS THEN
            xNombreClien := ' ';
        END;
      ELSE
        IF xrow.petipo = 'J' THEN
          BEGIN
            SELECT PJRAZS
              INTO xNombreClien
              FROM FSd003
             WHERE PJPAIS = XROW.PEPAIS
               AND PJTDOC = XROW.PETDOC
               AND PJNDOC = XROW.PENDOC
               AND ROWNUM < 2;
          EXCEPTION
            WHEN OTHERS THEN
              xNombreClien := ' ';
          END;
        ELSE
          BEGIN
            SELECT PENOM
              INTO xNombreClien
              FROM FSd001
             WHERE PEPAIS = XROW.PEPAIS
               AND PETDOC = XROW.PETDOC
               AND PENDOC = XROW.PENDOC
               AND ROWNUM < 2;
          EXCEPTION
            WHEN OTHERS THEN
              xNombreClien := ' ';
          END;
        END IF;
      END IF;
    
      IF xNombreClien IS NULL OR xNombreClien = ' ' THEN
        xNombreClien := XROW.NOMBRE;
      END IF;
    
      IF XROW.CTTFIR = 'T' THEN
        xRelacion := 'Titular';
      ELSE
        xRelacion := 'Integrantes';
      END IF;
    
      pq_cr_repo_opinion_riesgos.sp_insert_aqpc813_titul(codOpinion,
                                                         instancia,
                                                         xrow.pepais,
                                                         xrow.petdoc,
                                                         xrow.pendoc,
                                                         xrow.tdnom,
                                                         xNombreClien,
                                                         xRelacion);
    
    end loop;
  
    NomClien := trim(auxNombres);
    nrodocs  := txtNrodoc;
  
    txtNrodoc := null;
    For xrow2 in NomAvales loop
      --old  
      auxAvales := auxAvales || trim(xrow2.nombres) || '; ';
      --docs
      if xrow2.petdoc = 21 then
        txtNrodoc := txtNrodoc || 'DNI: ' || trim(xrow2.pendoc) || ';';
      end if;
      if xrow2.petdoc = 9 then
        txtNrodoc := txtNrodoc || 'RUC: ' || trim(xrow2.pendoc) || ';';
      end if;
      --new
      xRelacion := 'Aval';
      BEGIN
        SELECT TDNOM
          INTO auxNroDoc
          FROM FSt014
         WHERE TDOCUM = xrow2.petdoc;
      EXCEPTION
        WHEN OTHERS THEN
          auxNroDoc := '';
      END;
      pq_cr_repo_opinion_riesgos.sp_insert_aqpc813_titul(codOpinion,
                                                         instancia,
                                                         xrow2.pepais,
                                                         xrow2.petdoc,
                                                         xrow2.pendoc,
                                                         auxNroDoc,
                                                         xrow2.nombres,
                                                         xRelacion);
    end loop;
  
    NomClien := NomClien || trim(auxAvales);
    nrodocs  := nrodocs || trim(txtNrodoc);
  
  End sp_nomclientes;

  procedure sp_datos_indicad_cart(instancia     number,
                                  fechaApertura date,
                                  nomAnalista   out varchar2,
                                  ratingAnalis  out varchar2,
                                  SldoCartAnali out number,
                                  NroCliAnalis  out number,
                                  NlvMoraAnalis out number,
                                  nomAgencia    out varchar2,
                                  ratingAgenc   out varchar2,
                                  SldoCartAgenc out number,
                                  NroCliAgenc   out number,
                                  NlvMoraAgenc  out number,
                                  nomZona       out varchar2,
                                  SldoCartZona  out number,
                                  NroCliZona    out number,
                                  NlvMoraZona   out number,
                                  nomRegi       out varchar2,
                                  SldoCartRegi  out number,
                                  NroCliRegi    out number,
                                  NlvMoraRegi   out number) is
    nsucur             number(3);
    fechaCierrAnter    VARCHAR2(10);
    auxNlvMoraporc     number(18, 8);
    SaldosCartera      number(18, 8);
    NroClient          number(10);
    AuxCodReg          number(5);
    AuxCodZon          number(5);
    AuxNomReg          varchar2(40);
    AuxNomZon          varchar2(40);
    xFech              date;
    auxtext            varchar2(10);
    fechaCierrMesAnt   date;
    ld_maxfec162       date;
    lc_maxhor162       varchar2(8);
    xFechaCierreMesAnt date;
  Begin
    --Obtener datos
    Begin
      select trim(a.sng001ase),
             c.sucurs,
             c.scnom,
             e.regcod,
             e.regnom,
             f.tp1nro1,
             f.tp1desc
        into nomAnalista,
             nSucur,
             nomAgencia,
             AuxCodZon,
             nomZona,
             AuxCodReg,
             nomRegi
        from sng001 a, fst046 b, fst001 c, Fst811 d, fst810 e, fst198 f
       where f.Tp1cod = 1
         and f.Tp1cod1 = 10872
         and f.Tp1corr1 = 11
         and f.Tp1nro2 = e.regcod
         and d.PgCod = 1
         and d.RegCod < 100
         and d.oficod = c.sucurs
         and e.PgCod = 1
         and e.RegCod = d.regcod
         and e.RegCod < 100
         and b.pgcod = 1
         and b.ubuser = a.sng001ase
         and c.pgcod = b.pgcod
         and c.sucurs = b.ubsuc
         and a.sng001inst = instancia;
    Exception
      when others then
        nomAnalista := '';
        nomAgencia  := '';
        nomZona     := '';
        nomRegi     := '';
        nSucur      := 0;
        AuxCodZon   := 0;
    end;
  
    -- Rating Analista  
    ratingAnalis := ' ';
    BEGIN
      SELECT AQPB883RAT --AQPB883RAM 11082023
        INTO ratingAnalis
        FROM AQPB883
       WHERE AQPB883ANA = UPPER(TRIM(nomAnalista))
         AND AQPB883FEC =
             (SELECT MAX(AQPB883FEC)
                FROM AQPB883
               WHERE AQPB883ANA = UPPER(TRIM(nomAnalista)))
         and rownum < 2;
    EXCEPTION
      WHEN OTHERS THEN
        ratingAnalis := '';
    END;
  
    -- Rating Agencia 
    ratingAgenc := '';
    BEGIN
      SELECT AQPB882RAT --AQPB882RAM 11082023
        into ratingAgenc
        FROM AQPB882
       WHERE UPPER(AQPB882AGE) = UPPER(TRIM(nomAgencia))
         AND AQPB882FEC =
             (SELECT MAX(AQPB882FEC)
                FROM AQPB882
               WHERE UPPER(AQPB882AGE) = UPPER(TRIM(nomAgencia)))
         and rownum < 2;
    EXCEPTION
      WHEN OTHERS THEN
        ratingAgenc := '';
    END;
  
    --Fecha y hora
    BEGIN
      ld_maxfec162 := trunc(fechaApertura, 'mm'); --0308  --add_months(last_day(to_Date(fechaApertura)), -1);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    /*begin
      select max(a.aqpb162fecreg) into ld_maxfec162 from aqpb162 a;
    exception
      when others then
        null;
    end;*/
  
    begin
      select max(a.aqpb162horar)
        into lc_maxhor162
        from aqpb162 a
       where a.aqpb162fecreg = ld_maxfec162;
    exception
      when others then
        null;
    end;
    --AGENCIA
    auxNlvMoraporc := 0;
    NroClient      := 0;
    SaldosCartera  := 0;
    BEGIN
      select a.aqpb162nrocli, a.AQPB162MNTO, a.aqpb162morasbs
        into NroClient, SaldosCartera, auxNlvMoraporc
        from aqpb162 a
       where a.aqpb162fecreg = ld_maxfec162
         and a.aqpb162horar = lc_maxhor162
         and substr(a.aqpb162grupo, 1, instr(a.aqpb162grupo, '=') - 1) =
             'CODAGE '
         and to_number(trim(substr(a.aqpb162grupo,
                                   instr(a.aqpb162grupo, '=') + 1))) =
             nSucur
         and rownum = 1;
      /*
        SELECT +ALL_ROWS 
         SUM(-H12.BCSDMN) SALCAPMN,
         COUNT(DISTINCT(R.PENDOC)) CLIENTES,
         SUM(CASE
               WHEN REGEXP_LIKE(H12.BCRUBR, '^14.[5-6]') THEN
                H12.BCSDMN
             END) / SUM(H12.BCSDMN) * 100 PERC_MORASBS
          into SaldosCartera, NroClient, auxNlvMoraporc
          FROM FSH012 H12, FSR008 R
         WHERE H12.BCEMP = 1
           AND REGEXP_LIKE(H12.BCRUBR, '^14.[1-6]')
           AND H12.BCFECH = TO_DATE(fechaCierrAnter, 'rrrrmmdd')
           AND H12.BCMOD <> 108
           AND H12.BCSUC = nsucur --4
           AND ABS(H12.BCSDMN) > 0
           AND H12.BCCTA = R.CTNRO
           AND R.TTCOD = 1
           AND R.CTTFIR = 'T';
      */
    Exception
      when others then
        SaldosCartera  := 0;
        NroClient      := 0;
        auxNlvMoraporc := 0;
    END;
  
    NlvMoraAgenc  := round(auxNlvMoraporc * 100, 2);
    SldoCartAgenc := round(SaldosCartera, 2);
    NroCliAgenc   := NroClient;
  
    --ANALISTA 
    BEGIN
      select a.aqpb162nrocli, a.AQPB162MNTO, a.aqpb162morasbs
        into NroClient, SaldosCartera, auxNlvMoraporc
        from aqpb162 a
       where a.aqpb162fecreg = ld_maxfec162
         and a.aqpb162horar = lc_maxhor162
         and substr(a.aqpb162grupo, 1, instr(a.aqpb162grupo, '=') - 1) =
             'ANALISTA '
         and trim(substr(a.aqpb162grupo, instr(a.aqpb162grupo, '=') + 1)) =
             nomAnalista
         and a.aqpb162bcsuc = nSucur
         and rownum = 1;
      /*      
        SELECT +ALL_ROWS
         SUM(-H12.BCSDMN) SALCAPMN,
         COUNT(DISTINCT(R.PENDOC)) CLIENTES,
         SUM(CASE
               WHEN REGEXP_LIKE(H12.BCRUBR, '^14.[5-6]') THEN
                H12.BCSDMN
             END) / SUM(H12.BCSDMN) * 100 PERC_MORASBS
          INTO SaldosCartera, NroClient, auxNlvMoraporc
          FROM FSH012 H12, FSR008 R
         WHERE H12.BCEMP = 1
           AND REGEXP_LIKE(H12.BCRUBR, '^14.[1-6]')
           AND H12.BCFECH = TO_DATE(fechaCierrAnter, 'rrrrmmdd')
           AND H12.BCMOD <> 108
           AND H12.BCSUC = nsucur --4
           AND ABS(H12.BCSDMN) > 0
           AND H12.BCCTA = R.CTNRO
           AND R.TTCOD = 1
           AND R.CTTFIR = 'T'
           AND Upper(TRIM(fn_analista_credito(H12.bcmod,
                                              H12.bcsuc,
                                              H12.bcmda,
                                              H12.bcpap,
                                              H12.bccta,
                                              H12.bcoper,
                                              H12.bcsbop,
                                              H12.bctop))) =
               trim(nomAnalista);
      */
    Exception
      when others then
        SaldosCartera  := 0;
        NroClient      := 0;
        auxNlvMoraporc := 0;
    END;
  
    NlvMoraAnalis := round(auxNlvMoraporc * 100, 2);
    SldoCartAnali := round(SaldosCartera, 2);
    NroCliAnalis  := NroClient;
  
    --REGION
    auxNlvMoraporc := 0;
    NroClient      := 0;
    SaldosCartera  := 0;
    BEGIN
      select a.aqpb162nrocli, a.AQPB162MNTO, a.aqpb162morasbs
        into NroClient, SaldosCartera, auxNlvMoraporc
        from aqpb162 a
       where a.aqpb162fecreg = ld_maxfec162
         and a.aqpb162horar = lc_maxhor162
         and substr(a.aqpb162grupo, 1, instr(a.aqpb162grupo, '=') - 1) =
             'CODREG '
         and to_number(trim(substr(a.aqpb162grupo,
                                   instr(a.aqpb162grupo, '=') + 1))) =
             auxCodReg
         and rownum = 1;
      /*
        SELECT +ALL_ROWS
         initcap(trim(gr.tp1desc)) nom_region,
         SUM(-H12.BCSDMN) SALCAPMN,
         COUNT(DISTINCT(R.PENDOC)) CLIENTES,
         SUM(CASE
               WHEN REGEXP_LIKE(H12.BCRUBR, '^14.[5-6]') THEN
                H12.BCSDMN
             END) / SUM(H12.BCSDMN) * 100 PERC_MORASBS
          INTO AuxNomReg, SaldosCartera, NroClient, auxNlvMoraporc
          FROM FSH012 H12,
               FSR008 R,
               fst001 t,
               fst811 t81,
               fst810 t80,
               FST198 gr
         WHERE H12.BCEMP = 1
           AND REGEXP_LIKE(H12.BCRUBR, '^14.[1-6]')
           AND H12.BCFECH = TO_DATE(fechaCierrAnter, 'rrrrmmdd')
           AND H12.BCMOD <> 108
           AND ABS(H12.BCSDMN) > 0
           AND H12.BCCTA = R.CTNRO
           AND R.TTCOD = 1
           AND R.CTTFIR = 'T'
           and H12.BCSUC = t.sucurs
           and t81.pgcod = t.pgcod
           and t81.oficod = t.sucurs
           and t81.regcod < 100
           and t81.regcod < 100
           and t80.pgcod = t81.pgcod
           and t80.regcod = t81.regcod
           and gr.TP1COD = 1
           and gr.TP1COD1 = 10872
           and gr.TP1CORR1 = 11
           and gr.tp1nro2 = t80.regcod
           and t.sucurs < 800
           and nvl(gr.tp1nro1, 0) <> 0
           and upper(initcap(trim(gr.tp1desc))) = (trim(upper(nomRegi)))
         group by initcap(trim(gr.tp1desc));
      */
    Exception
      when others then
        AuxNomReg      := '';
        SaldosCartera  := 0;
        NroClient      := 0;
        auxNlvMoraporc := 0;
    END;
  
    NlvMoraRegi  := round(auxNlvMoraporc * 100, 2);
    SldoCartRegi := round(SaldosCartera, 2);
    NroCliRegi   := NroClient;
  
    --ZONA
    auxNlvMoraporc := 0;
    NroClient      := 0;
    SaldosCartera  := 0;
    BEGIN
      select a.aqpb162nrocli, a.AQPB162MNTO, a.aqpb162morasbs
        into NroClient, SaldosCartera, auxNlvMoraporc
        from aqpb162 a
       where a.aqpb162fecreg = ld_maxfec162
         and a.aqpb162horar = lc_maxhor162
         and substr(a.aqpb162grupo, 1, instr(a.aqpb162grupo, '=') - 1) =
             'CODZON '
         and to_number(trim(substr(a.aqpb162grupo,
                                   instr(a.aqpb162grupo, '=') + 1))) =
             auxCodZon
         and rownum = 1;
      /*
        SELECT +ALL_ROWS
         initcap(trim(t80.regnom)) deszon,
         SUM(-H12.BCSDMN) SALCAPMN,
         COUNT(DISTINCT(R.PENDOC)) CLIENTES,
         SUM(CASE
               WHEN REGEXP_LIKE(H12.BCRUBR, '^14.[5-6]') THEN
                H12.BCSDMN
             END) / SUM(H12.BCSDMN) * 100 PERC_MORASBS
          INTO AuxNomZon, SaldosCartera, NroClient, auxNlvMoraporc
          FROM FSH012 H12,
               FSR008 R,
               fst001 t,
               fst811 t81,
               fst810 t80,
               FST198 gr
         WHERE H12.BCEMP = 1
           AND REGEXP_LIKE(H12.BCRUBR, '^14.[1-6]')
           AND H12.BCFECH = TO_DATE(fechaCierrAnter, 'rrrrmmdd')
           AND H12.BCMOD <> 108
           AND ABS(H12.BCSDMN) > 0
           AND H12.BCCTA = R.CTNRO
           AND R.TTCOD = 1
           AND R.CTTFIR = 'T'
           and H12.BCSUC = t.sucurs
           and t81.pgcod = t.pgcod
           and t81.oficod = t.sucurs
           and t81.regcod < 100
           and t81.regcod < 100
           and t80.pgcod = t81.pgcod
           and t80.regcod = t81.regcod
           and gr.TP1COD = 1
           and gr.TP1COD1 = 10872
           and gr.TP1CORR1 = 11
           and gr.tp1nro2 = t80.regcod
           and t.sucurs < 800
           and nvl(gr.tp1nro1, 0) <> 0
           and initcap(upper(trim(t80.regnom))) = trim(nomZona) --'Arequipa Norte'
         group by initcap(trim(t80.regnom));
      */
    Exception
      when others then
        AuxNomZon      := '';
        SaldosCartera  := 0;
        NroClient      := 0;
        auxNlvMoraporc := 0;
    END;
    NlvMoraZona  := round(auxNlvMoraporc * 100, 2);
    SldoCartZona := round(SaldosCartera, 2);
    NroCliZona   := NroClient;
  
  end sp_datos_indicad_cart;

  procedure sp_calificacion(instancia     number,
                            cuenta        number,
                            fechaApertura date,
                            calificacion  out varchar2) is
    auxFecha     date;
    auxPais      number(3);
    auxTdoc      number(2);
    auxNdoc      varchar2(12);
    porcCalif    number(5, 2);
    descCalif    varchar2(30);
    ln_porcCalif varchar2(10);
    v_pendoc     varchar2(12);
  
  begin
    --auxFecha := add_Months(last_day(fechaApertura), -1);            
    BEGIN
      SELECT E.SNG001PAIS, E.SNG001TDOC, E.SNG001NDOC
        INTO auxPais, auxTdoc, auxNdoc
        FROM SNG001 E
       WHERE E.SNG001INST = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        auxPais := 0;
        auxTdoc := 0;
        auxNdoc := ' ';
    END;
    v_pendoc := trim(auxNdoc);
  
    calificacion := ' ';
    BEGIN
      --03082023
      PQ_CR_DATOS_CONSULTA_BURO.SP_OBTENER_PEOR_CALIFICACION(auxPais,
                                                             auxTdoc,
                                                             v_pendoc,
                                                             porcCalif,
                                                             descCalif);
    EXCEPTION
      WHEN OTHERS THEN
        porcCalif := '';
        descCalif := '';
    END;
  
    IF porcCalif > 0 AND descCalif is not null THEN
      ln_porcCalif := to_char(porcCalif);
      calificacion := trim(ln_porcCalif) || '% - ' || trim(descCalif);
    END IF;
  
    IF calificacion IS NULL OR calificacion = ' ' THEN
      calificacion := '--';
    END IF;
  
    /* BEGIN
      select CATCATEG
        INTO calificacion
        from fsd212
       where catcod = 4
         and catcta = cuenta
         and catfchdes = auxFecha
         and rownum < 2;
    Exception
      when others then
        calificacion := '--';
        NULL;
    END;*/
  end sp_calificacion;

  procedure sp_productoSBS(instancia     number,
                           cuenta        number,
                           fechaApertura date,
                           produSBS      out varchar2) is
    xrubro    number(18);
    v_rubr    varchar2(20);
    auxSegm   varchar2(30);
    xposi     number(3);
    xtextSegm varchar2(30);
  begin
    AUXSEGM := ' ';
    BEGIN
      SELECT WFATTSVAL
        INTO AUXSEGM
        FROM WFATTSVALUES
       WHERE WFINSPRCID = INSTANCIA
         AND WFATTSID IN ('TIPO_CREDITO')
         AND TRIM(WFATTSVAL) IS NOT NULL;
    EXCEPTION
      WHEN OTHERS THEN
        AUXSEGM := '';
    END;
  
    IF AUXSEGM IS NULL OR AUXSEGM = ' ' THEN
      produSBS := '--';
    ELSE
      BEGIN
        SELECT INSTR(AUXSEGM, ';', 1, 1) INTO XPOSI FROM DUAL;
      EXCEPTION
        WHEN OTHERS THEN
          XPOSI := 0;
      END;
    
      XTEXTSEGM := SUBSTR(AUXSEGM, XPOSI + 1, 30 - XPOSI);
      XTEXTSEGM := UPPER(XTEXTSEGM);
    
      produSBS := UPPER(trim(XTEXTSEGM));
    END IF;
  
    /*BEGIN
      SELECT to_number(ww.pp028defc)
        into xrubro
        FROM FPP028 WW, xwf700 I
       WHERE WW.PP017PAR = 115
         AND WW.PP028MOD = I.XWFMODULO
         AND WW.PP028TOP = I.XWFTIPOPE
         AND WW.PP028EMP = I.XWFEMPRESA
         AND WW.PP028MDA = I.XWFMONEDA
         AND WW.PP028PAP = I.XWFPAPEL
         AND I.XWFPRCINS = instancia
         AND I.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        xrubro := 0;
    END;
    v_rubr   := trim(to_char(xrubro));
    produSBS := '';
    case
      when v_rubr like '14__02%' then
        produSBS := 'MICROEMPRESAS';
      when (v_rubr like '14__03%' and substr(xrubro, 11, 3) = '015') then
        produSBS := 'CONSUMO REVOLVENTE';
      when v_rubr like '14__03%' and substr(xrubro, 11, 3) <> '015' then
        produSBS := 'CONSUMO NO REVOLVENTE';
      when v_rubr like '14__04%' then
        produSBS := 'HIPOTECARIO';
      when v_rubr like '14__09%' then
        produSBS := 'CORPORATIVO';
      when v_rubr like '14__10%' then
        produSBS := 'CORPORATIVO';
      when v_rubr like '14__11%' then
        produSBS := 'GRANDE EMPRESA';
      when v_rubr like '14__12%' then
        produSBS := 'MEDIANA EMPRESA';
      when v_rubr like '14__13%' then
        produSBS := 'PEQUEÑA EMPRESA';
      else
        produSBS := '--';
    end case;   */
  
  end sp_productoSBS;

  procedure sp_actividad(instancia number,
                         cuenta    number,
                         actividad out varchar2) is
    xpepais number(3);
    xpendoc varchar2(12);
    xpetdoc number(3);
    xciiu   number(10);
    xtipo   varchar2(1);
    ln_ciiu number(11);
  BEGIN
    BEGIN
      SELECT PEPAIS, PETDOC, PENDOC
        INTO xpepais, xpetdoc, xpendoc
        FROM fsr008
       where CTNRO = cuenta
         AND CTTFIR = 'T';
    EXCEPTION
      WHEN OTHERS THEN
        xpepais := 0;
        xpendoc := '';
        xpetdoc := 0;
    END;
  
    xpendoc := rpad(xpendoc, 12, ' '); --24032024
  
    IF xpepais <> 0 and xpetdoc <> 0 then
      begin
        -- Call the procedure
        pq_cr_modulo_campanias.sp_cr_ciuu(ln_pais => xpepais,
                                          ln_tdoc => xpetdoc,
                                          lc_ndoc => xpendoc,
                                          ln_ciiu => ln_ciiu);
      end;
    
      actividad := '';
      BEGIN
        select actnom1
          INTO actividad
          from fst750 f
         where f.actcod1 = ln_ciiu;
      EXCEPTION
        WHEN OTHERS THEN
          actividad := '';
      END;
    
    end if;
  
  END;

  procedure sp_score(instancia   number,
                     cuenta      number,
                     usuario     varchar2,
                     nivelRiesgo out varchar2) is
    XNDOC              VARCHAR2(12);
    XTIPDOC            NUMBER(4);
    fechaProc          DATE;
    xFechaCierreMesAnt DATE;
    XPAIS              NUMBER(3);
    lc_score           varchar2(200);
    ln_probal          number(8, 7);
    lc_segmriesgo      varchar2(15);
    ln_pdcal           number(8, 7);
    lc_tabla           varchar2(15);
    ld_fchscore        date;
    lc_scoreabr        varchar2(30);
    lc_newscore        varchar2(30);
  begin
    BEGIN
      SELECT PGFAPE INTO fechaProc FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        fechaProc := to_date(Sysdate, 'dd/mm/rrrr');
    END;
  
    /*xFechaCierreMesAnt := TO_DATE(add_months(last_day(to_Date(fechaProc)),
               -1),
    'DD/MM/RRRR');*/
  
    BEGIN
      SELECT PEPAIS, PETDOC, PENDOC
        INTO XPAIS, XTIPDOC, XNDOC
        FROM FSR008
       WHERE CTNRO = CUENTA
         AND CTTFIR = 'T';
    EXCEPTION
      WHEN others THEN
        XPAIS   := 0;
        XTIPDOC := 0;
        XNDOC   := '';
    END;
  
    XNDOC := trim(XNDOC); --26032024
  
    begin
      /* pq_cr_score_rcc.sp_cr_scoredni(ln_inst => instancia, --01042024
      ln_tdoc => XTIPDOC,
      lc_ndoc => XNDOC,
      lc_prgm => 'OPRIE',
      lc_user => usuario,
      lc_score => lc_score,
      ln_probal => ln_probal,
      lc_segmriesgo => lc_segmriesgo,
      ln_pdcal => ln_pdcal,
      lc_tabla => lc_tabla,
      ld_fchscore => ld_fchscore);*/
    
      pq_cr_score_rcc.sp_cr_scoredni_ii(ln_inst       => instancia,
                                        ln_tdoc       => XTIPDOC,
                                        lc_ndoc       => XNDOC,
                                        lc_prgm       => 'OPRIE',
                                        lc_user       => usuario,
                                        lc_score      => lc_score,
                                        ln_probal     => ln_probal,
                                        lc_segmriesgo => lc_segmriesgo,
                                        ln_pdcal      => ln_pdcal,
                                        lc_tabla      => lc_tabla,
                                        ld_fchscore   => ld_fchscore,
                                        lc_scoreabr   => lc_scoreabr,
                                        lc_newscore   => lc_newscore);
    
      nivelRiesgo := trim(lc_newscore);
    EXCEPTION
      WHEN others THEN
        nivelRiesgo := 'Sin Segmentación';
    end;
  
    IF lc_newscore is null or lc_newscore = ' ' or
       lc_newscore = 'SIN SCORE' THEN
      nivelRiesgo := 'Sin Segmentación';
    END IF;
  
  end;

  procedure sp_pd(instancia  number,
                  analista   varchar2,
                  agencia    varchar2,
                  zona       varchar2,
                  region     varchar2,
                  PdAnalista out number,
                  pdAgencia  out number,
                  pdzona     out number,
                  pdregion   out number,
                  cos4anl    out number,
                  cos4agen   out number,
                  cos4zona   out number,
                  cos4reg    out number,
                  cos6anl    out number,
                  cos6agen   out number,
                  cos6zona   out number,
                  cos6reg    out number) is
    xpdAnl         number(17, 5);
    xpdAgen        number(17, 5);
    xpdZon         number(17, 5);
    xpdReg         number(17, 5);
    xCos4Anl       number(17, 5);
    xCos4Agen      number(17, 5);
    xCos4Zona      number(17, 5);
    xCos4Regi      number(17, 5);
    xCos6Anl       number(17, 5);
    xCos6Agen      number(17, 5);
    xCos6Zona      number(17, 5);
    xCos6Regi      number(17, 5);
    xFechaDesembol date;
    auxCtnro       number(9);
    codZona        number(4);
    codRegion      number(4);
    xAnalista      varchar2(10);
    fechaProc      date;
    auxAgencia     number(4);
    auxAnalista    varchar2(10);
    auxDescZona    varchar2(50);
    auxDescReg     varchar2(50);
  
  begin
    /* BEGIN
      DELETE FROM AQPC804;
      COMMIT;
    END;*/
  
    BEGIN
      SELECT PGFAPE INTO fechaProc FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        fechaProc := '';
    END;
  
    --xFechaCierreMesAnt := add_months(last_day(to_Date(fechaProc)), -1);
  
    --apachecoh 2023.09.26 
    xFechaDesembol := '';
    BEGIN
      SELECT MAX(AQPB172FECC) INTO xFechaDesembol FROM AQPB172; -- 26072023
    EXCEPTION
      WHEN OTHERS THEN
        null;
    END;
  
    --xFechaDesembol := to_date('30/06/2023', 'dd/mm/rrrr' ) ;-- prueba  
  
    BEGIN
      SELECT SNG001AGE, trim(SNG001ASE)
        into auxAgencia, auxAnalista
        FROM SNG001 B
       WHERE B.SNG001INST = instancia
         and rownum < 2;
    EXCEPTION
      WHEN OTHERS THEN
        auxAgencia  := '';
        auxAnalista := '';
    END;
  
    IF auxAgencia > 0 THEN
      BEGIN
        SELECT UPPER(DESZON), UPPER(REGNOM)
          into auxDescZona, auxDescReg
          FROM REGSUC
         WHERE SUCURS = auxAgencia;
      EXCEPTION
        WHEN OTHERS THEN
          auxDescZona := '';
          auxDescReg  := '';
      END;
    
      pq_cr_repo_opinion_riesgos.sp_obtener_pd_cos4_co6_Analista(xFechaDesembol,
                                                                 auxDescReg,
                                                                 auxDescZona,
                                                                 auxAgencia,
                                                                 auxAnalista,
                                                                 cos4anl,
                                                                 cos6anl,
                                                                 PdAnalista);
    
      pq_cr_repo_opinion_riesgos.sp_obtener_pd_cos4_co6_Agencia(xFechaDesembol,
                                                                auxDescReg,
                                                                auxDescZona,
                                                                auxAgencia,
                                                                cos4agen,
                                                                cos6agen,
                                                                pdAgencia);
    
      pq_cr_repo_opinion_riesgos.sp_obtener_pd_cos4_co6_Zona(xFechaDesembol,
                                                             auxDescReg,
                                                             auxDescZona,
                                                             cos4zona,
                                                             cos6zona,
                                                             pdzona);
    
      pq_cr_repo_opinion_riesgos.sp_obtener_pd_cos4_co6_Region(xFechaDesembol,
                                                               auxDescReg,
                                                               cos4reg,
                                                               cos6reg,
                                                               pdregion);
    END IF;
  
  end;

  PROCEDURE sp_obtener_pd_cos4_co6_Analista(fechaCierreAnt date,
                                            nomReg         varchar2,
                                            nomZon         varchar2,
                                            NAgencia       number,
                                            NomAnalista    varchar2,
                                            cos4mAnli      out number,
                                            cos6mAnli      out number,
                                            pdAnli         out number) is
    --xAnalista number;
    NomAgencia   varchar2(75);
    auxFechaCos4 date;
    auxFechaCos6 date;
    ld_maxfec162 date;
    lc_maxhor162 varchar2(8);
  BEGIN
    BEGIN
      select initcap(scnom)
        into NomAgencia
        from fst001
       where pgcod = 1
         and sucurs = NAgencia;
    EXCEPTION
      WHEN OTHERS THEN
        NomAgencia := '';
    END;
    --ANALISTA
  
    --apachecoh 2023.09.26 MAXIMA HORA
    begin
      select max(a.AQPB172horac)
        into lc_maxhor162
        from AQPB172 a
       where a.AQPB172fecc = fechaCierreAnt;
    exception
      when others then
        null;
    end;
  
    -- cosecha 4            
    BEGIN
      auxFechaCos4 := ADD_MONTHS(fechaCierreAnt, -4);
      auxFechaCos4 := last_day(to_Date(auxFechaCos4));
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      select round(100 * (sum(t.aqpb172var1) / sum(t.aqpb172var2)), 2)
        into cos4mAnli
        from aqpb172 t
       where t.aqpb172anals = trim(NomAnalista)
         and t.aqpb172fecc = fechaCierreAnt
         and t.aqpb172horac = lc_maxhor162
         and t.aqpb172ind = 'CO4';
    EXCEPTION
      WHEN OTHERS THEN
        cos4mAnli := 0;
    END;
  
    /*IF cos4mAnli <> 0 THEN
       cos4mAnli := cos4mAnli * 100; --0108
    END IF;*/
  
    -- COSECHA 6
    BEGIN
      auxFechaCos6 := ADD_MONTHS(fechaCierreAnt, -6);
      auxFechaCos6 := last_day(to_Date(auxFechaCos6));
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      select round(100 * (sum(t.aqpb172var1) / sum(t.aqpb172var2)), 2)
        into cos6mAnli
        from aqpb172 t
       where t.aqpb172anals = trim(NomAnalista)
         and t.aqpb172fecc = fechaCierreAnt
         and t.aqpb172horac = lc_maxhor162
         and t.aqpb172ind = 'CO6';
    EXCEPTION
      WHEN OTHERS THEN
        cos6mAnli := 0;
    END;
  
    /*IF cos6mAnli <> 0 THEN
       cos6mAnli := cos6mAnli * 100; --0108
    END IF;*/
  
    --PD  ANALISTA  
    BEGIN
      select round(100 * (sum(t.aqpb172var1) / sum(t.aqpb172var2)), 2)
        into PDANLI
        from aqpb172 t
       where t.aqpb172anals = trim(NomAnalista)
         and t.aqpb172fecc = fechaCierreAnt
         and t.aqpb172horac = lc_maxhor162
         and t.aqpb172ind = 'PD';
    EXCEPTION
      WHEN OTHERS THEN
        PDANLI := 0;
    END;
  
    /*BEGIN
      SELECT (AVG(B.AQPB152PD) * 100)
        INTO PDANLI
        FROM FSD010 A, AQPB152 B
       WHERE A.PGCOD = 1
         AND A.AOCTA = B.AQPB152CTA
         AND A.AOOPER = B.AQPB152OPE
         AND TRIM(B.AQPB152AGNCIA) = UPPER(TRIM(NomAgencia))
         AND UPPER(TRIM(FN_ANALISTA_CREDITO(AOMOD,
                                            AOSUC,
                                            AOMDA,
                                            AOPAP,
                                            AOCTA,
                                            AOOPER,
                                            AOSBOP,
                                            AOTOPE))) =
             UPPER(TRIM(NomAnalista))
         AND B.AQPB152MDESMB = FECHACIERREANT;
    EXCEPTION
      WHEN OTHERS THEN
        PDANLI := 0;
    END;  */
  
  END;

  PROCEDURE sp_obtener_pd_cos4_co6_Agencia(fechaCierreAnt date,
                                           nomReg         varchar2,
                                           nomZona        varchar2,
                                           xaosuc         number,
                                           cos4mAge       out number,
                                           cos6mAge       out number,
                                           pdAge          out number) is
    auxSuc       number(3);
    NomAgencia   varchar2(75);
    auxFechaCos4 DATE;
    auxFechaCos6 DATE;
    ld_maxfec162 date;
    lc_maxhor162 varchar2(8);
  BEGIN
  
    BEGIN
      select initcap(scnom)
        into NomAgencia
        from fst001
       where pgcod = 1
         and sucurs = xaosuc;
    EXCEPTION
      WHEN OTHERS THEN
        NomAgencia := '';
    END;
    --AGENCIA
  
    --apachecoh 2023.09.26 MAXIMA HORA
    begin
      select max(a.AQPB172horac)
        into lc_maxhor162
        from AQPB172 a
       where a.AQPB172fecc = fechaCierreAnt;
    exception
      when others then
        null;
    end;
  
    --COSECHA 4 
    BEGIN
      auxFechaCos4 := ADD_MONTHS(fechaCierreAnt, -4);
      auxFechaCos4 := last_day(to_Date(auxFechaCos4));
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      select round(100 * (sum(t.aqpb172var1) / sum(t.aqpb172var2)), 2)
        into COS4MAGE
        from aqpb172 t
       where t.aqpb172codsuc = xaosuc
         and t.aqpb172fecc = fechaCierreAnt
         and t.aqpb172horac = lc_maxhor162
         and t.aqpb172ind = 'CO4';
    EXCEPTION
      WHEN OTHERS THEN
        COS4MAGE := 0;
    END;
  
    /*IF COS4MAGE <> 0 THEN
       COS4MAGE := COS4MAGE * 100; --0108
    END IF; */
  
    -- COSECHA 6
    BEGIN
      auxFechaCos6 := ADD_MONTHS(fechaCierreAnt, -6);
      auxFechaCos6 := last_day(to_Date(auxFechaCos6));
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      select round(100 * (sum(t.aqpb172var1) / sum(t.aqpb172var2)), 2)
        into COS6MAGE
        from aqpb172 t
       where t.aqpb172codsuc = xaosuc
         and t.aqpb172fecc = fechaCierreAnt
         and t.aqpb172horac = lc_maxhor162
         and t.aqpb172ind = 'CO6';
    EXCEPTION
      WHEN OTHERS THEN
        cos6mAge := 0;
    END;
  
    /*IF cos6mAge <> 0 THEN
       cos6mAge := cos6mAge * 100; --0108
    END IF; */
  
    --PD
    BEGIN
      select round(100 * (sum(t.aqpb172var1) / sum(t.aqpb172var2)), 2)
        into pdAge
        from aqpb172 t
       where t.aqpb172codsuc = xaosuc
         and t.aqpb172fecc = fechaCierreAnt
         and t.aqpb172horac = lc_maxhor162
         and t.aqpb172ind = 'PD';
    EXCEPTION
      WHEN OTHERS THEN
        pdAge := 0;
    END;
  
    /*BEGIN
      SELECT (AVG(B.AQPB152PD) * 100)
        INTO pdAge
        FROM FSD010 A, AQPB152 B
       WHERE A.PGCOD = 1
         AND A.AOCTA = B.AQPB152CTA
         AND A.AOOPER = B.AQPB152OPE
         AND UPPER(TRIM(B.AQPB152AGNCIA)) = UPPER(TRIM(NOMAGENCIA))
         AND B.AQPB152MDESMB = fechaCierreAnt;
    EXCEPTION
      WHEN OTHERS THEN
        pdAge := 0;
    END;*/
  
  END;

  PROCEDURE sp_obtener_pd_cos4_co6_Zona(fechaCierreAnt date,
                                        nomRegion      varchar2,
                                        nomZon         varchar2,
                                        cos4mZona      out number,
                                        cos6mZona      out number,
                                        pdZona         out number) is
    auxZona      number(4);
    auxFechaCos4 DATE;
    auxFechaCos6 DATE;
    ld_maxfec162 date;
    lc_maxhor162 varchar2(8);
  BEGIN
    --ZONA
  
    --apachecoh 2023.09.26 MAXIMA HORA
    begin
      select max(a.AQPB172horac)
        into lc_maxhor162
        from AQPB172 a
       where a.AQPB172fecc = fechaCierreAnt;
    exception
      when others then
        null;
    end;
  
    -- cosecha 4 
    BEGIN
      AUXFECHACOS4 := ADD_MONTHS(fechaCierreAnt, -4);
      auxFechaCos4 := last_day(to_Date(auxFechaCos4));
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      select round(100 * (sum(t.aqpb172var1) / sum(t.aqpb172var2)), 2)
        into cos4mZona
        from aqpb172 t
       where upper(trim(T.AQPB172ZONA)) = upper(trim(nomZon))
         and t.aqpb172fecc = fechaCierreAnt
         and t.aqpb172horac = lc_maxhor162
         and t.aqpb172ind = 'CO4';
    EXCEPTION
      WHEN OTHERS THEN
        cos4mZona := 0;
    END;
  
    /*IF cos4mZona <> 0 THEN
       cos4mZona := cos4mZona * 100; --0108
    END IF; */
  
    -- COSECHA 6
    BEGIN
      AUXFECHACOS6 := ADD_MONTHS(fechaCierreAnt, -6);
      auxFechaCos6 := last_day(to_Date(auxFechaCos6));
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      select round(100 * (sum(t.aqpb172var1) / sum(t.aqpb172var2)), 2)
        into cos6mZona
        from aqpb172 t
       where upper(trim(T.AQPB172ZONA)) = upper(trim(nomZon))
         and t.aqpb172fecc = fechaCierreAnt
         and t.aqpb172horac = lc_maxhor162
         and t.aqpb172ind = 'CO6';
    EXCEPTION
      WHEN OTHERS THEN
        cos6mZona := 0;
    END;
  
    /*IF cos6mZona <> 0 THEN
       cos6mZona := cos6mZona * 100; --0108
    END IF; */
  
    --PD   
    BEGIN
      select round(100 * (sum(t.aqpb172var1) / sum(t.aqpb172var2)), 2)
        into pdZona
        from aqpb172 t
       where upper(trim(T.AQPB172ZONA)) = upper(trim(nomZon))
         and t.aqpb172fecc = fechaCierreAnt
         and t.aqpb172horac = lc_maxhor162
         and t.aqpb172ind = 'PD';
    EXCEPTION
      WHEN OTHERS THEN
        pdZona := 0;
    END;
  
    /* BEGIN
      SELECT (AVG(B.AQPB152PD) * 100)
        INTO pdZona
        FROM FSD010 A, AQPB152 B
       WHERE A.PGCOD = 1
         AND A.AOCTA = B.AQPB152CTA
         AND A.AOOPER = B.AQPB152OPE
         AND UPPER(TRIM(B.AQPB152ZONA)) = UPPER(TRIM(NOMZON))
         AND B.AQPB152MDESMB = fechaCierreAnt;
    EXCEPTION
      WHEN OTHERS THEN
        pdZona := 0;
    END;*/
  
  END;

  PROCEDURE sp_obtener_pd_cos4_co6_Region(fechaCierreAnt date,
                                          nomReg         varchar2,
                                          cos4mRegion    out number,
                                          cos6mRegion    out number,
                                          pdRegion       out number) is
    auxReg       number(3);
    ld_152mdesmb date;
    auxFechaCos4 DATE;
    auxFechaCos6 DATE;
    ld_maxfec162 date;
    lc_maxhor162 varchar2(8);
  
  BEGIN
    --REGION
  
    --apachecoh 2023.09.26 MAXIMA HORA
    begin
      select max(a.AQPB172horac)
        into lc_maxhor162
        from AQPB172 a
       where a.AQPB172fecc = fechaCierreAnt;
    exception
      when others then
        null;
    end;
  
    -- cosecha 4 
    BEGIN
      AUXFECHACOS4 := ADD_MONTHS(fechaCierreAnt, -4);
      auxFechaCos4 := last_day(to_Date(auxFechaCos4));
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      select round(100 * (sum(t.aqpb172var1) / sum(t.aqpb172var2)), 2)
        into COS4MREGION
        from aqpb172 t
       where UPPER(TRIM(T.AQPB172REGION)) = UPPER(TRIM(nomReg))
         and t.aqpb172fecc = fechaCierreAnt
         and t.aqpb172horac = lc_maxhor162
         and t.aqpb172ind = 'CO4';
    EXCEPTION
      WHEN OTHERS THEN
        COS4MREGION := 0;
    END;
  
    /*IF COS4MREGION <> 0 THEN
       COS4MREGION := COS4MREGION * 100; --0108
    END IF;  */
  
    -- COSECHA 6
    BEGIN
      auxFechaCos6 := ADD_MONTHS(fechaCierreAnt, -6);
      auxFechaCos6 := last_day(to_Date(auxFechaCos6));
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      select round(100 * (sum(t.aqpb172var1) / sum(t.aqpb172var2)), 2)
        into cos6mRegion
        from aqpb172 t
       where UPPER(TRIM(T.AQPB172REGION)) = UPPER(TRIM(nomReg))
         and t.aqpb172fecc = fechaCierreAnt
         and t.aqpb172horac = lc_maxhor162
         and t.aqpb172ind = 'CO6';
    EXCEPTION
      WHEN OTHERS THEN
        cos6mRegion := 0;
    END;
  
    /*IF cos6mRegion <> 0 THEN
       cos6mRegion := cos6mRegion * 100; --0108
    END IF;  */
  
    --PD   
    BEGIN
      select round(100 * (sum(t.aqpb172var1) / sum(t.aqpb172var2)), 2)
        into pdRegion
        from aqpb172 t
       where UPPER(TRIM(T.AQPB172REGION)) = UPPER(TRIM(nomReg))
         and t.aqpb172fecc = fechaCierreAnt
         and t.aqpb172horac = lc_maxhor162
         and t.aqpb172ind = 'PD';
    EXCEPTION
      WHEN OTHERS THEN
        pdRegion := 0;
    END;
  
  END;

  ----------------------------------------------------------------------------------------
  procedure sp_montoCred(instancia number, monto out number) is
    p_empresa   number(3);
    p_sucursal  number(3);
    p_modulo    number(3);
    p_moned     number(4);
    p_papel     number(4);
    p_cuenta    number(9);
    p_operacion number(9);
    p_suboper   number(3);
    p_tipoper   number(3);
  
    p_saldof11 number(17, 2);
    --LINEAS
    ln_pgcod117     number;
    ln_modulo117    number;
    ln_sucursal117  number;
    ln_moneda117    number;
    ln_papel117     number;
    ln_cuenta117    number;
    ln_operacion117 number;
    ln_sbop117      number;
    ln_top117       number;
    ln_LineaTotal   number(17, 2) := 0.00;
    ln_LineaUtilzd  number(17, 2) := 0.00;
  
    lc_flagConsiderar varchar2(2);
    x_count           number(3);
    SumSldVigent      NUMBER(17, 2);
    p_sng001ori       number(2);
  
    flgLineaVinc          VARCHAR2(1);
    v_montoSoles          number(17, 2); --17082023
    v_montoPropuSoles     number(17, 2);
    v_tipoCambio          number(14, 8); --17082023
    v_MontoAcumuCredVuelo number(17, 2);
    v_SolicVuelo          number(10);
    v_cuentaOrig          number(9);
    ln_CodOpi             number;
    ln_cuenta             number;
    ld_fchSist            date;
    ln_sumsldvigentAux    number;
  
    v_TC_credVig number(14, 8);
    --- 18/12/2023
    v_correlativo  number(10);
    v_montoPropu   number(17, 2);
    v_modalidPropu varchar2(200);
    v_cuotaPropu   number(17, 2);
    v_totCuotPropu varchar2(20);
    v_tasaPropu    number(7, 2);
    v_monedaPropu  number(3);
    xAQPC833AUX2   varchar2(100) := '';
  
    --Cred. en Vuelo  2808
    Cursor CredPropuesVuelo(instancia number) IS
      SELECT S.SNG001INST as SolicitudVuelo
        FROM SNG001 S, WFWRKITEMS W
       WHERE S.SNG001INST = W.WFINSPRCID
         AND (S.SNG001PAIS, S.SNG001TDOC, S.SNG001NDOC) IN
             (SELECT D.SNG001PAIS, D.SNG001TDOC, D.SNG001NDOC
                FROM SNG001 D
               WHERE D.SNG001INST = instancia)
         AND W.WFITEMSTSACT = 1;
  
  Begin
    --- Sumatoria de monto de creds en Vuelo  
    v_MontoAcumuCredVuelo := 0;
    monto                 := 0;
  
    ln_CodOpi := 0; -------------18/12/2023 
    begin
      select MAX(b.aqpc815codopin)
        into ln_CodOpi
        from aqpc815 b
       where b.aqpc815instan = instancia;
    exception
      when others then
        ln_CodOpi := 0;
    end;
  
    BEGIN
      UPDATE AQPC833
         SET AQPC833ESTAD = 'I'
       WHERE AQPC833CODOPI = ln_CodOpi
         AND (AQPC833ESTAD = 'H' OR AQPC833ESTAD IS NULL);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -----------------------------18/12/2023   
  
    FOR xv IN CredPropuesVuelo(instancia) LOOP
    
      p_empresa   := 0;
      p_sucursal  := 0;
      p_modulo    := 0;
      p_moned     := 0;
      p_papel     := 0;
      p_cuenta    := 0;
      p_operacion := 0;
      p_suboper   := 0;
      p_tipoper   := 0;
    
      -- monto de solicitud
      BEGIN
        SELECT E.XWFEMPRESA,
               E.xwfsucursal,
               E.XWFMODULO,
               E.XWFMONEDA,
               E.XWFPAPEL,
               E.XWFCUENTA,
               E.XWFOPERACION,
               E.XWFSUBOPE,
               E.XWFTIPOPE
          INTO p_empresa,
               p_sucursal,
               p_modulo,
               p_moned,
               p_papel,
               p_cuenta,
               p_operacion,
               p_suboper,
               p_tipoper
          FROM XWF700 E
         WHERE E.XWFPRCINS = xv.solicitudvuelo
           AND E.xwfcar3 = '1';
      EXCEPTION
        WHEN OTHERS THEN
          p_empresa   := 0;
          p_sucursal  := 0;
          p_modulo    := 0;
          p_moned     := 0;
          p_papel     := 0;
          p_cuenta    := 0;
          p_operacion := 0;
          p_suboper   := 0;
          p_tipoper   := 0;
      END;
    
      v_montoPropuSoles := 0;
    
      IF p_cuenta <> 0 AND p_operacion <> 0 THEN
        BEGIN
          SELECT XLLCAPITAL
            INTO v_montoPropuSoles --monto
            FROM X054023 A
           WHERE A.XLLPGCOD = p_empresa
             AND A.XLLAOMOD = p_modulo
             AND A.XLLAOSUC = p_sucursal
             AND A.XLLAOMDA = p_moned
             AND A.XLLAOPAP = p_papel
             AND A.XLLAOCTA = p_cuenta
             AND A.XLLAOOPER = p_operacion
             AND A.XLLAOSBOP = p_suboper
             AND A.XLLAOTOP = p_tipoper
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            v_montoPropuSoles := 0; --monto := 0;
        END;
      
        v_montoPropuSoles := nvl(v_montoPropuSoles, 0);
      
        IF p_moned = 101 and v_montoPropuSoles <> 0 THEN
          -- 17082023
          v_tipoCambio := 0;
          BEGIN
            pq_cr_repo_opinion_riesgos.sp_obtener_tipo_cambio(xv.solicitudvuelo,
                                                              v_tipoCambio);
          EXCEPTION
            WHEN OTHERS THEN
              v_tipoCambio := 0;
          END;
          v_montoPropuSoles := v_montoPropuSoles * v_tipoCambio;
        END IF;
        --END IF; 01042024
        v_MontoAcumuCredVuelo := nvl(v_MontoAcumuCredVuelo, 0) +
                                 v_montoPropuSoles;
      
        --insert aqpc833 --18/12/2023
        v_montoPropu   := 0;
        v_modalidPropu := '';
        v_cuotaPropu   := 0;
        v_totCuotPropu := '';
        v_tasaPropu    := 0;
        v_monedaPropu  := 0;
        BEGIN
          pq_cr_repo_opinion_riesgos.sp_operac_propuesta(xv.solicitudvuelo,
                                                         0,
                                                         v_montoPropu,
                                                         v_modalidPropu,
                                                         v_cuotaPropu,
                                                         v_totCuotPropu,
                                                         v_tasaPropu,
                                                         v_monedaPropu); --2108
        EXCEPTION
          WHEN OTHERS THEN
            v_montoPropu   := 0;
            v_modalidPropu := '';
            v_cuotaPropu   := 0;
            v_totCuotPropu := '';
            v_tasaPropu    := 0;
            v_monedaPropu  := 0;
        END;
      
        BEGIN
          pq_cr_repo_opinion_riesgos.sp_insert_cred_vuelo_aqpc833(ln_CodOpi,
                                                                  xv.solicitudvuelo,
                                                                  v_montoPropu,
                                                                  v_modalidPropu,
                                                                  v_cuotaPropu,
                                                                  v_totCuotPropu,
                                                                  v_tasaPropu,
                                                                  v_monedaPropu,
                                                                  xAQPC833AUX2);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END; --18/12/2023      
      END IF;
    END LOOP;
  
    monto := round(v_MontoAcumuCredVuelo, 2);
  
    BEGIN
      SELECT K.SNG001CTA
        INTO v_cuentaOrig
        FROM SNG001 K
       WHERE K.SNG001INST = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        v_cuentaOrig := 0;
    END;
  
    --------------------------------------------------------------------------------------------
  
    -- monto responsabilidad social monto propuesto más los vigentes
    SumSldVigent := 0;
    begin
    
      select MAX(b.aqpc815codopin) --07112023
        into ln_CodOpi
        from aqpc815 b
       where b.aqpc815instan = instancia;
    exception
      when others then
        ln_CodOpi := 0;
    end;
  
    begin
      select s.sng001cta
        into ln_cuenta
        from sng001 s
       where s.sng001inst = instancia;
    exception
      when others then
        ln_cuenta := 0;
    end;
    begin
      select f.pgfape into ld_fchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    if ln_CodOpi > 0 then
    
      begin
        -- Call the procedure
        pq_cr_repo_opinion_riesgos.sp_obtn_cred_vig_titu(auxnropinion  => ln_CodOpi,
                                                         instancia     => instancia,
                                                         cuenta        => ln_cuenta,
                                                         fechaapertura => ld_fchSist,
                                                         sumsldvigent  => ln_sumsldvigentAux);
      exception
        when others then
          null;
      end;
    
      v_TC_credVig := 0;
      BEGIN
        pq_cr_repo_opinion_riesgos.sp_obtener_tipo_cambio(instancia,
                                                          v_TC_credVig);
      EXCEPTION
        WHEN OTHERS THEN
          v_TC_credVig := 0;
      END;
    
      begin
        select SUM(decode(A.AQPC160MDA,
                          101,
                          A.AQPC160SLDVIG * v_TC_credVig,
                          A.AQPC160SLDVIG)) --SUM(A.AQPC160SLDVIG) 26092023
          INTO SumSldVigent
          from aqpc160 a
         where a.aqpc160codopi =
               (select max(b.aqpc815codopin) --07112023
                  from aqpc815 b
                 where b.aqpc815instan = instancia)
           and (a.aqpc160tipsol not in ('A', 'RF', 'V') or
               a.aqpc160tipsol is null)
           AND AQPC160ESTAD = 'H';
      exception
        when others then
          SumSldVigent := 0;
      end;
    
    end if;
  
    -- Responsabilidad Total o monto consolidado
    monto := monto + nvl(SumSldVigent, 0);
  
  End sp_montoCred;
  ----------------------------------------------------------------------------------------
  procedure sp_insert_cred_vuelo_aqpc833(xAQPC833codopi  in number,
                                         xAQPC833instan  in number,
                                         xAQPC833sldprop in number,
                                         xAQPC833modprp  in varchar2,
                                         xAQPC833cuotas  in number,
                                         xAQPC833cuoprp  in varchar2,
                                         xAQPC833tasprp  in number,
                                         xAQPC833mdaprop in number,
                                         xAQPC833AUX2    IN VARCHAR2) is
    --18/12/2023
    xAQPC833fecpro date;
    xCorrelativo   number(10);
  BEGIN
    begin
      select f.pgfape into xAQPC833fecpro from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    xCorrelativo := 0;
    BEGIN
      SELECT MAX(AQPC833corr)
        INTO xCorrelativo
        FROM AQPC833 A
       WHERE A.AQPC833CODOPI = xAQPC833codopi;
    EXCEPTION
      WHEN OTHERS THEN
        xCorrelativo := 0;
    END;
  
    xCorrelativo := nvl(xCorrelativo, 0);
  
    xCorrelativo := xCorrelativo + 1;
  
    BEGIN
      INSERT INTO AQPC833
        (AQPC833codopi,
         AQPC833fecpro,
         AQPC833instan,
         AQPC833sldprop,
         AQPC833modprp,
         AQPC833cuotas,
         AQPC833cuoprp,
         AQPC833tasprp,
         AQPC833mdaprop,
         AQPC833estad,
         AQPC833corr,
         AQPC833horrg,
         AQPC833AUX2)
      VALUES
        (xAQPC833codopi,
         xAQPC833fecpro,
         xAQPC833instan,
         xAQPC833sldprop,
         xAQPC833modprp,
         xAQPC833cuotas,
         xAQPC833cuoprp,
         xAQPC833tasprp,
         xAQPC833mdaprop,
         'H',
         xCorrelativo,
         TO_CHAR(SYSDATE, 'HH24:MI:SS'),
         xAQPC833AUX2);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  END;
  ----------------------------------------------------------------------------------------
  procedure sp_operac_propuesta(instancia  number,
                                cuenta     number,
                                monto      out number,
                                modalidad  out varchar2,
                                cuota      out number,
                                tot_cuotas out varchar2,
                                tasa       out number,
                                moneda     out number) is
  
    auxMonto     number(17, 2);
    auxModalidad varchar2(200);
    auxCuota     number(17, 2);
    auxTotCuot   number(17, 2);
    auxTasa      number(10, 6);
    auxMoneda    number(3);
  
    p_empresa     number(3);
    p_sucursal    number(3);
    p_modulo      number(3);
    p_moned       number(4);
    p_papel       number(4);
    p_cuenta      number(9);
    p_operacion   number(9);
    p_suboper     number(3);
    p_tipoper     number(3);
    p_PERIODO     number(5);
    p_descPeriodo varchar2(30);
    p_cuotas      number(5);
  
    auxModEval     number(3);
    xflgEsEvalFluj varchar2(1);
  
  BEGIN
    BEGIN
      select c.xwfmonto1,
             (select c.xwfmodulo || '-' || trim(mdnom) || ', ' ||
                     c.xwftipope || '-' || trim(TONOM)
                from fst003 a, fst004 b
               where a.modulo = c.xwfmodulo
                 and b.totope = c.xwftipope
                 and b.modulo = a.MODULO
                 and rownum < 2) modalidad,
             --a.sng01icuot cuota,             
             c.xwfmoneda
        INTO auxMonto, auxModalidad, auxMoneda --auxCuota, auxMoneda
        FROM xwf700 c, sng001 a --wfwrkitems b, 
       where a.sng001inst = c.xwfprcins
         and c.xwfprcins = instancia
         and c.xwfcar3 = '1';
    Exception
      when OTHERS then
        auxMonto     := 0;
        auxModalidad := '';
        auxCuota     := 0;
        --auxTotCuot   := 0;
        auxMoneda := 0;
    END;
  
    BEGIN
      SELECT E.XWFEMPRESA,
             E.xwfsucursal,
             E.XWFMODULO,
             E.XWFMONEDA,
             E.XWFPAPEL,
             E.XWFCUENTA,
             E.XWFOPERACION,
             E.XWFSUBOPE,
             E.XWFTIPOPE
        INTO p_empresa,
             p_sucursal,
             p_modulo,
             p_moned,
             p_papel,
             p_cuenta,
             p_operacion,
             p_suboper,
             p_tipoper
        FROM XWF700 E
       WHERE E.XWFPRCINS = instancia
         and E.xwfcar3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        p_empresa   := 0;
        p_sucursal  := 0;
        p_modulo    := 0;
        p_moned     := 0;
        p_papel     := 0;
        p_cuenta    := 0;
        p_operacion := 0;
        p_suboper   := 0;
        p_tipoper   := 0;
    END;
  
    BEGIN
      SELECT XLLCAPITAL
        INTO auxMonto --monto
        FROM X054023 A
       WHERE A.XLLPGCOD = p_empresa
         AND A.XLLAOMOD = p_modulo
         AND A.XLLAOSUC = p_sucursal
         AND A.XLLAOMDA = p_moned
         AND A.XLLAOPAP = p_papel
         AND A.XLLAOCTA = p_cuenta
         AND A.XLLAOOPER = p_operacion
         AND A.XLLAOSBOP = p_suboper
         AND A.XLLAOTOP = p_tipoper
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        auxMonto := 0; --monto := 0;
    END;
  
    --Monto de la Cuota 
    xflgEsEvalFluj := 'N';
    BEGIN
      -- validar si tiene evaluación por flujo 
      pq_cr_ratio_evalflujo.sp_cr_verfevalflujo(instancia, xflgEsEvalFluj);
    EXCEPTION
      WHEN OTHERS THEN
        xflgEsEvalFluj := 'N';
    END;
  
    auxModEval := 0;
    auxCuota   := 0;
    IF xflgEsEvalFluj = 'N' THEN
      BEGIN
        SELECT SNG021TMOD
          INTO auxModEval
          FROM sng021
         WHERE SNG021SOL = instancia;
      EXCEPTION
        WHEN OTHERS THEN
          auxModEval := 0;
      END;
    
      IF auxModEval = 13 THEN
        BEGIN
          SELECT R.JAQY142CAPCUO
            INTO auxCuota
            FROM JAQY142 R
           WHERE R.JAQY142INST = instancia
             AND R.JAQY142PGCOD = p_empresa
             AND R.JAQY142MOD = p_modulo
             AND R.JAQY142SUC = p_sucursal
             AND R.JAQY142MDA = p_moned
             AND R.JAQY142PAP = p_papel
             AND R.JAQY142CTA = p_cuenta
             AND R.JAQY142OPE = p_operacion
             AND R.JAQY142SBOP = p_suboper
             AND R.JAQY142TOPE = p_tipoper
             AND R.JAQY142EST = 'H'
             AND R.JAQY142TAREA = 7
             AND ROWNUM < 2;
        EXCEPTION
          WHEN OTHERS THEN
            auxCuota := 0;
        END;
      ELSE
        IF auxModEval = 14 THEN
          BEGIN
            SELECT K.JAQZ822CAPCUO
              INTO auxCuota
              FROM jaqz822 K
             WHERE K.JAQZ822INST = instancia
               AND K.JAQZ822PGCOD = p_empresa
               AND K.JAQZ822MOD = p_modulo
               AND K.JAQZ822SUC = p_sucursal
               AND K.JAQZ822MDA = p_moned
               AND K.JAQZ822PAP = p_papel
               AND K.JAQZ822CTA = p_cuenta
               AND K.JAQZ822OPE = p_operacion
               AND K.JAQZ822SBOP = p_suboper
               AND K.JAQZ822TOPE = p_tipoper
               AND K.JAQZ822EST = 'H'
               AND K.JAQZ822TAREA = 7
               AND ROWNUM < 2;
          EXCEPTION
            WHEN OTHERS THEN
              auxCuota := 0;
          END;
        END IF;
      END IF;
    ELSE
      IF xflgEsEvalFluj = 'S' THEN
        BEGIN
          pq_cr_resolutor_cappago.sp_cr_maxcuotppago(p_empresa,
                                                     p_modulo,
                                                     p_sucursal,
                                                     p_moned,
                                                     p_papel,
                                                     p_cuenta,
                                                     p_operacion,
                                                     p_suboper,
                                                     p_tipoper,
                                                     1,
                                                     auxCuota);
        EXCEPTION
          WHEN OTHERS THEN
            auxCuota := 0;
        END;
        /* BEGIN 
          SELECT L.SNG01ICUOT INTO auxCuota FROM SNG001 L WHERE 
          L.SNG001INST = instancia;
        EXCEPTION
           WHEN OTHERS THEN    
           auxCuota := 0;       
        END;*/
      END IF;
    END IF;
  
    IF auxCuota = 0 OR auxCuota is null THEN
      --0108
      BEGIN
        pq_cr_resolutor_cappago.sp_cr_maxcuotppago(p_empresa,
                                                   p_modulo,
                                                   p_sucursal,
                                                   p_moned,
                                                   p_papel,
                                                   p_cuenta,
                                                   p_operacion,
                                                   p_suboper,
                                                   p_tipoper,
                                                   1,
                                                   auxCuota);
      EXCEPTION
        WHEN OTHERS THEN
          auxCuota := 0;
      END;
    END IF;
  
    ---
    BEGIN
      SELECT XLLPERIODO, XLLCANTCUO, XLLTASAP
        INTO p_PERIODO, auxTotCuot, auxTasa
        FROM x054023
       WHERE XLLPGCOD = p_empresa
         AND XLLAOMOD = p_modulo
         AND XLLAOSUC = p_sucursal
         AND XLLAOMDA = p_moned
         AND XLLAOPAP = p_papel
         AND XLLAOCTA = p_cuenta
         AND XLLAOOPER = p_operacion
         AND XLLAOSBOP = p_suboper
         AND XLLAOTOP = p_tipoper;
    EXCEPTION
      WHEN OTHERS THEN
        p_PERIODO  := 0;
        auxTotCuot := 0;
        auxTasa    := 0;
    END;
  
    BEGIN
      SELECT TP1DESC
        INTO p_descPeriodo
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         and tp1corr1 = 13
         AND TP1corr2 = 0 --24072023
         AND TP1CORR3 > 0
         AND TP1NRO1 = p_PERIODO;
    EXCEPTION
      WHEN OTHERS THEN
        p_descPeriodo := '';
    END;
  
    IF p_moned IS NULL THEN
      p_moned := 0;
      moneda  := 0;
    ELSE
      moneda := p_moned;
    END IF;
  
    monto      := auxMonto;
    modalidad  := auxModalidad || chr(3) || chr(10);
    cuota      := auxCuota;
    tot_cuotas := to_char(auxTotCuot) || ' cuo. ' || trim(p_descPeriodo);
    tasa       := auxTasa;
  END;
  --EntidFinanc
  procedure sp_relaciones_finacie(instanci    number,
                                  cuenta      number,
                                  fechaAper   date,
                                  codSBS      out numeric,
                                  fechEvaluar OUT date) is
    --codSbs numeric(10); 
    p_pais    number(3);
    p_tdoc    number(2);
    p_ndoc    varchar2(12);
    xRcc      number;
    xAuxFecha varchar2(10);
  begin
    BEGIN
      SELECT PEPAIS, PETDOC, PENDOC
        INTO p_pais, p_tdoc, p_ndoc
        FROM FSR008
       WHERE PGCOD = 1
         AND CTNRO = cuenta
         AND CTTFIR = 'T';
    Exception
      when OTHERS then
        p_pais := 0;
        p_tdoc := 0;
        p_ndoc := '';
    END;
    p_ndoc := RPAD(p_ndoc, 12, ' '); --26032024
  
    Begin
      select /*+ALL_ROWS */
       lpad(to_char(c.bc739sbs), 10, 0)
        into codSbs
        from fbc739 c
       where c.bc739pais = p_pais
         and c.bc739tdoc = p_tdoc
         and c.bc739ndoc = p_ndoc
         and c.bc739cta = cuenta
         and rownum < 2;
    Exception
      when OTHERS then
        codSbs := 0;
    End;
  
    --FECHA DE RCC
    BEGIN
      SELECT TPNRO
        INTO xRcc
        FROM FST098
       where pgcod = 1
         and TPCOD = 7647
         and TPCORR = 12;
    EXCEPTION
      WHEN OTHERS THEN
        xRcc := null;
    END;
  
    IF xRcc IS NULL THEN
      xRcc := '01/01/0001';
    ELSE
      xAuxFecha   := to_char(xRcc);
      fechEvaluar := to_date(xAuxFecha, 'dd/MM/RRRR');
    END IF;
  
  end;

  procedure sp_grid_garantias(instancia     in number,
                              p_sng122_cod  in number,
                              p_sng122_mod  in number,
                              p_sng122_suc  in number,
                              p_sng122_mda  in number,
                              p_sng122_pap  in number,
                              p_sng122_cta  in number,
                              p_sng122_ope  in number,
                              p_sng122_sbo  in number,
                              p_sng122_top  in number,
                              p_tipGarant   out varchar2,
                              p_Propietrio  out varchar2,
                              p_tasador     out varchar2,
                              Fechatasa     out date,
                              valComer      out varchar2,
                              valRealiz     out varchar2,
                              valGravamen   out number, --1906
                              desGarant     out varchar2,
                              auxMoned      out number,
                              p_tipBienDecl out varchar2,
                              p_fechDecl    out date,
                              p_valorGarnt  out varchar2) is
    auxEmp  number(3);
    auxSucu number(3);
    auxMod  number(3);
    --auxMoned number(4);
    auxPapel   number(4);
    auxCuenta  number(9);
    auxOper    number(9);
    auxSubOp   number(3);
    auxTipOper number(3);
  
    auxFechaTasa  Date;
    auxValComer   number(17, 2);
    auxValRealiz  number(17, 2);
    auxDescGarant varchar2(100);
    v_mod         number(4);
    v_Tope        number(4);
    x_cuentagarnt number(9);
    g_Empr        number(3);
    g_Modul       number(4);
    g_Sucur       number(4);
    g_Moned       number(3);
    g_cta         number(9);
    g_oper        number(9);
    g_tope        number(3);
    g_sboper      number(3);
    g_papel       number(4);
  
    g_tipo_ab varchar2(2);
  
  begin
    begin
      select a.xwfempresa,
             a.xwfsucursal,
             a.xwfmodulo,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope
        into auxEmp,
             auxSucu,
             auxMod,
             auxMoned,
             auxPapel,
             auxCuenta,
             auxOper,
             auxSubOp,
             auxTipOper
        from xwf700 a
       where a.xwfprcins = instancia
         and a.xwfcar3 = '1';
    Exception
      when OTHERS then
        auxEmp     := 0;
        auxSucu    := 0;
        auxMod     := 0;
        auxMoned   := 0;
        auxPapel   := 0;
        auxCuenta  := 0;
        auxOper    := 0;
        auxSubOp   := 0;
        auxTipOper := 0;
    end;
    -- Tipo de garantia
    /*BEGIN
      SELECT SNG122PGC,
             SNG122MOD,
             SNG122SUC,
             SNG122MDA,
             SNG122PAP,
             SNG122CTA,
             SNG122OPER,
             SNG122SBOP,
             SNG122TOPE,
             TONOM
        INTO g_Empr,
             g_Modul,
             g_Sucur,
             g_Moned,
             g_papel,
             x_cuentagarnt,
             g_oper,
             g_sboper,
             g_tope,
             p_tipGarant
        FROM sng122 a, fst004 b
       WHERE b.modulo = a.sng122mod
         and b.totope = a.sng122tope
         and a.sng122pgc = p_sng122_cod
         and a.sng122cta = p_sng122_cta
    Exception
      when others then
        g_Empr        := 0;
        g_Modul       := 0;
        g_Sucur       := 0;
        g_Moned       := 0;
        g_papel       := 0;
        g_oper        := 0;
        g_sboper      := 0;
        g_tope        := 0;
        p_tipGarant   := 0;
        x_cuentagarnt := 0;
    END;*/
  
    -- Tipo de garantia
    BEGIN
      select TONOM
        into p_tipGarant
        from fst004 b
       where b.modulo = p_sng122_mod
         and b.totope = p_sng122_top;
    EXCEPTION
      WHEN OTHERS THEN
        null;
    END;
  
    g_Empr        := p_sng122_cod;
    g_Modul       := p_sng122_mod;
    g_Sucur       := p_sng122_suc;
    g_Moned       := p_sng122_mda;
    g_papel       := p_sng122_pap;
    g_oper        := p_sng122_ope;
    g_sboper      := p_sng122_sbo;
    g_tope        := p_sng122_top;
    x_cuentagarnt := p_sng122_cta;
  
    BEGIN
      select 'B'
        into g_tipo_ab
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11152
         and tp1corr1 = 13
         and tp1corr2 = 1
         and tp1corr3 > 0
         and tp1nro1 = g_tope;
    Exception
      when others then
        g_tipo_ab := 'A';
    END;
  
    BEGIN
      select y.penom
        into p_Propietrio
        from fsr008 x, fsd001 y
       where x.pepais = y.pepais
         and x.petdoc = y.petdoc
         and x.pendoc = y.pendoc
         and x.ctnro = x_cuentagarnt
         and x.cttfir = 'T';
    Exception
      when others then
        p_Propietrio := '';
    END;
  
    If g_tipo_ab = 'A' then
      -- Fecha Tasación
      Begin
        select pq_cr_funciones_opinion_riegos.fn_cr_tas_fecha_tasacion(g_Empr, --fn_tasacion_fecha_tasacion
                                                                       g_Modul,
                                                                       g_Sucur,
                                                                       g_Moned,
                                                                       g_papel,
                                                                       x_cuentagarnt,
                                                                       g_oper,
                                                                       g_sboper,
                                                                       g_tope) fecha_tasa
          into auxFechaTasa
          from dual;
      Exception
        when others then
          auxFechaTasa := '';
      End;
      Fechatasa := auxFechaTasa;
    Else
      -- Fecha Declaracion
      Begin
        select pq_cr_funciones_opinion_riegos.fn_cr_tas_fecha_declaracion(g_Empr, --fn_tasacion_fecha_tasacion
                                                                          g_Modul,
                                                                          g_Sucur,
                                                                          g_Moned,
                                                                          g_papel,
                                                                          x_cuentagarnt,
                                                                          g_oper,
                                                                          g_sboper,
                                                                          g_tope) fecha_tasa
          into p_fechDecl --auxFechaTasa 1606
          from dual;
      Exception
        when others then
          p_fechDecl := '';
      End;
      --Fechatasa := p_fechDecl;
    End If;
    -- Tasa Val. Comercial
    Begin
      select pq_cr_funciones_opinion_riegos.fn_cr_tas_val_comercial(g_Empr, --fn_tasacion_fecha_tasacion
                                                                    g_Modul,
                                                                    g_Sucur,
                                                                    g_Moned,
                                                                    g_papel,
                                                                    x_cuentagarnt,
                                                                    g_oper,
                                                                    g_sboper,
                                                                    g_tope) val_comercial
        into auxValComer
        from dual;
    Exception
      when others then
        auxValComer := 0;
    End;
  
    If auxValComer is null then
      auxValComer := 0;
    End If;
  
    If auxValComer = 0 THEN
      BEGIN
        SELECT AOIMP
          INTO auxValComer
          FROM FSD010 E
         WHERE E.PGCOD = g_Empr
           AND E.AOMOD = g_Modul
           AND E.AOSUC = g_Sucur
           AND E.AOMDA = g_Moned
           AND E.AOPAP = g_papel
           AND E.AOCTA = x_cuentagarnt
           AND E.AOOPER = g_oper
           AND E.AOSBOP = g_sboper
           AND E.AOTOPE = g_tope;
      EXCEPTION
        WHEN OTHERS THEN
          auxValComer := 0;
      END;
    End If;
  
    IF g_Moned = 0 then
      --2504
      valComer := 'S/. ' || to_char(auxValComer);
    Else
      If g_Moned = 101 then
        --2504
        valComer := 'USD ' || to_char(auxValComer);
      End If;
    End If;
  
    -- Val. Realizacion
    Begin
      select pq_cr_funciones_opinion_riegos.fn_cr_tas_val_realizacion(g_Empr, --fn_tasacion_fecha_tasacion
                                                                      g_Modul,
                                                                      g_Sucur,
                                                                      g_Moned,
                                                                      g_papel,
                                                                      x_cuentagarnt,
                                                                      g_oper,
                                                                      g_sboper,
                                                                      g_tope) val_realizacion
        INTO auxValRealiz
        from dual;
    Exception
      when others then
        auxValRealiz := 0;
    End;
  
    If auxValRealiz is null then
      auxValRealiz := 0;
    End If;
  
    If auxValRealiz = 0 THEN
      BEGIN
        SELECT AOIMP
          INTO auxValRealiz
          FROM FSD010 E
         WHERE E.PGCOD = g_Empr
           AND E.AOMOD = g_Modul
           AND E.AOSUC = g_Sucur
           AND E.AOMDA = g_Moned
           AND E.AOPAP = g_papel
           AND E.AOCTA = x_cuentagarnt
           AND E.AOOPER = g_oper
           AND E.AOSBOP = g_sboper
           AND E.AOTOPE = g_tope;
      EXCEPTION
        WHEN OTHERS THEN
          auxValRealiz := 0;
      END;
    End If;
  
    If g_Moned = 0 then
      valRealiz := 'S/. ' || to_char(auxValRealiz);
    Else
      If g_Moned = 101 then
        valRealiz := 'USD ' || to_char(auxValRealiz);
      End If;
    End If;
  
    If g_tipo_ab = 'B' THEN
      p_valorGarnt := valRealiz;
    Else
      p_valorGarnt := '--';
    End If;
  
    begin
      select pq_cr_funciones_opinion_riegos.fn_cr_tas_dato(g_Empr,
                                                           g_Modul,
                                                           g_Sucur,
                                                           g_Moned,
                                                           g_papel,
                                                           x_cuentagarnt,
                                                           g_oper,
                                                           g_sboper,
                                                           g_tope) desc_garantia
        into auxDescGarant
        from dual;
    Exception
      when others then
        auxDescGarant := null;
    End;
  
    desGarant := auxDescGarant;
  
    If g_tipo_ab = 'A' then
      -- Tasador
      Begin
        select PPG008DESC
          into p_tasador
          from ppg008
         where PPG008PGC = g_Empr
           and PPG008MOD = g_Modul
           and PPG008SUC = g_Sucur
           and PPG008MDA = g_Moned
           and PPG008PAP = g_papel
           and ppg008cta = x_cuentagarnt
           and ppg008ope = g_oper
           and PPG008SBO = g_sboper
           and PPG008TOP = g_tope
           and ppg008cdat = 121
           and rownum < 2; --Tasador o perito ppg008cip-> código de perito , ppg008desc->nombre del perito  
      Exception
        when others then
          p_tasador := '';
      End;
    Else
      -- Tipo de Bien Declarado
      Begin
        select pq_cr_funciones_opinion_riegos.fn_cr_tas_tipo_bien(g_Empr, --fn_tasacion_fecha_tasacion
                                                                  g_Modul,
                                                                  g_Sucur,
                                                                  g_Moned,
                                                                  g_papel,
                                                                  x_cuentagarnt,
                                                                  g_oper,
                                                                  g_sboper,
                                                                  g_tope) p_tasador
          INTO p_tipBienDecl --p_tasador 1606
          from dual;
      Exception
        when others then
          p_tipBienDecl := 0;
      End;
    
      p_tasador := '--';
    End If;
  
    If p_tasador is null then
      p_tasador := '';
    End If;
  
    -- Val. Gravamen
    BEGIN
      SELECT abs(g.scsdo * (-1)) saldo
        INTO valGravamen
        FROM FSD011 G
       WHERE g.pgcod = g_Empr
         AND g.scsuc = g_Sucur
         AND g.scmod = g_Modul
         AND g.scmda = g_Moned
         AND g.scpap = g_papel
         AND g.sccta = x_cuentagarnt
         AND g.scoper = g_oper
         AND g.scsbop = g_sboper
         AND g.sctope = g_tope;
    Exception
      when others then
        valGravamen := 0;
    END;
    If valGravamen IS NULL THEN
      valGravamen := 0;
    End If;
  
    If g_tipo_ab = 'A' then
      p_tipBienDecl := '--';
    Else
      p_tasador := '--';
    End if;
  
    /*begin
      select PPG004DATO
        INTO valGravamen
        from ppg004
       where PPG004COD = g_Empr
         and PPG004MOD = g_Modul
         and PPG004SUC = g_Sucur
         and PPG004MDA = g_Moned
         and PPG004PAP = g_papel
         and PPG004CTA = x_cuentagarnt
         AND PPG004OPE = g_oper
         AND PPG004SBO = g_sboper
         AND PPG004TOP = g_tope
         and ppg004cdat = 136
         and rownum < 2;    
    Exception
      when others then
        valGravamen := 0;
    End;    
    IF valGravamen IS NULL THEN
       valGravamen := 0;
    END IF;
    
    IF valGravamen = 0 THEN*/
  
  end sp_grid_garantias;

  procedure sp_analisisfinancieroCreditos(instancia                number,
                                          nroevaluacion            out number,
                                          resulta_neto             out number,
                                          disponible               out number,
                                          ctxcbr                   out number,
                                          MERCADERIA               out number,
                                          GASTOS_ANTICIPADOS       out number,
                                          EXISTENCIAS_RECIBIR      out number,
                                          otros_actv_corr          out number,
                                          total_actv_corr          out number,
                                          MUEBLES                  out number,
                                          INMUEBLES                out number,
                                          otros_actv_fijo          out number,
                                          tot_actv_fijo            out number,
                                          xtotal_activ             out number,
                                          OTROS_INGRESOS           out number,
                                          GASTOS_FAMILIARES        out number,
                                          CUENTAS_BANCO            out number,
                                          TRIBUTO_PAGAR            out number,
                                          xotros_pasiv_corr        out number,
                                          xtotal_pasiv_corr        out number,
                                          CUENTAS_BANCOLP          out number,
                                          BENEFICIOS_SOCIALES      out number,
                                          xreservas                out number,
                                          xotros_pasiv_nocorri     out number,
                                          xtot_pasiv_nocorri       out number,
                                          xtotal_pasivo            out number,
                                          xcapital                 out number,
                                          xresult_acumulad         out number,
                                          xresult_ejercici         out number,
                                          xotros_patrim            out number,
                                          xtotal_patrimonio        out number,
                                          xtotal_pasivo_patrimonio out number,
                                          VENTA                    out number,
                                          COSTO_VENTA              out number,
                                          xutilid_bruta            out number,
                                          COSTO_OPERATIVO          out number,
                                          Gastos_administd         out number,
                                          xutilid_operativa        out number,
                                          SERVICIO_DEUDA           out number,
                                          xingres_financieros      out number,
                                          xgastos_diversos         out number,
                                          xutilid_antes_impuestos  out number,
                                          ximpuestos               out number,
                                          xutilidad_neta           out number,
                                          CUENTAS_PAGAR            out number,
                                          FechEvalRec              out date,
                                          ResultRatioEvalRec       out number) is
  
    auxTmod      number(4);
    ln_evalflujo varchar2(1);
  BEGIN
    --Obtener Ratio Cuota
    BEGIN
      select SNG021TMOD
        INTO auxTmod
        from sng021
       where SNG021SOL = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        auxTmod := 0;
    END;
    ResultRatioEvalRec := 0;
    IF AUXTMOD = 13 THEN
      BEGIN
        SELECT JAQY140RATIO
          INTO ResultRatioEvalRec
          FROM JAQY140
         WHERE JAQY140INST = instancia
           AND JAQY140EST = 'H'
           AND JAQY140TAREA = 7;
      EXCEPTION
        WHEN OTHERS THEN
          ResultRatioEvalRec := 0;
      END;
    
      ln_evalflujo := 'N'; -- INI 30062023
      BEGIN
        --identificar si la solicitud tiene evaluacion por flujo 30062023
        -- Call the procedure
        pq_cr_ratio_evalflujo.sp_cr_verfevalflujo(instancia, ln_evalflujo);
      EXCEPTION
        WHEN OTHERS THEN
          ln_evalflujo := 'N';
      END;
    
      IF ln_evalflujo = 'S' THEN
        -- es un credito con Evaluacion por Flujo
        BEGIN
          select a.aqpa354ratio
            INTO ResultRatioEvalRec
            from aqpa354 a
           where a.aqpa354inst = instancia
             and a.aqpa354est = 'H' --Estado, siempre debe ser H
             and a.aqpa354tarea = 7; -- Tarea de ejecución de ratio, siempre debemos considerar el 7 ya que es ratio ejecutado en evaluación propuesta.
        EXCEPTION
          WHEN OTHERS THEN
            ResultRatioEvalRec := 0;
        END;
      END IF; -- FIN 30062023
    END IF;
  
    IF AUXTMOD = 14 THEN
      -- SI MODELO  EVALUACION ES 14
      BEGIN
        SELECT JAQZ821RATIO
          INTO ResultRatioEvalRec
          FROM JAQZ821
         WHERE JAQZ821INST = instancia
           AND JAQZ821EST = 'H'
           AND JAQZ821TAREA = 7;
      EXCEPTION
        WHEN OTHERS THEN
          ResultRatioEvalRec := 0;
      END;
    END IF;
  
    IF ResultRatioEvalRec <> 0 THEN
      ResultRatioEvalRec := ResultRatioEvalRec * 100;
    END IF;
  
    BEGIN
      select g021.sng021eval,
             (select sum(decode(c.sng026cod, 40, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                540,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (40, 540)) resultado_Neto,
             (select sum(decode(c.sng026cod, 41, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                541,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (41, 541)) Caja_bancos, --disponible,
             (select sum(decode(c.sng026cod, 42, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                542,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (42, 542)) cuentas_cobrar_comerci,
             (select sum(decode(c.sng026cod, 43, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                543,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (43, 543)) mercaderia,
             (select sum(decode(c.sng026cod, 44, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                544,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (44, 544)) gastos_anticipados,
             (select sum(decode(c.sng026cod, 45, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                545,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (45, 545)) existencias_recibir,
             (select sum(decode(c.sng026cod, 46, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                546,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (46, 546)) otros_act_corri,
             (select sum(decode(c.sng026cod, 47, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                547,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (47, 547)) total_actv_corri,
             (select sum(decode(c.sng026cod, 48, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                548,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (48, 548)) muebles,
             (select sum(decode(c.sng026cod, 49, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                549,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (49, 549)) inmuebles,
             (select sum(decode(c.sng026cod, 50, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                550,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (50, 550)) otros_act_fijo,
             (select sum(decode(c.sng026cod, 51, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                551,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (51, 551)) total_activ_fijo,
             (select sum(decode(c.sng026cod, 52, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                552,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (52, 552)) total_activ,
             (select sum(decode(c.sng026cod, 53, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                553,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (53, 553)) otros_ingreso,
             (select sum(decode(c.sng026cod, 54, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                554,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (54, 554)) gastos_familiares,
             (select sum(decode(c.sng026cod, 56, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                556,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (56, 556)) cuentas_banco,
             (select sum(decode(c.sng026cod, 57, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                557,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (57, 557)) tributo_pagar,
             (select sum(decode(c.sng026cod, 58, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                558,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (58, 558)) otros_pasiv_corr,
             (select sum(decode(c.sng026cod, 59, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                559,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (59, 559)) total_pasiv_corr,
             (select sum(decode(c.sng026cod, 60, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                560,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (60, 560)) cuentas_bancoLP,
             (select sum(decode(c.sng026cod, 61, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                561,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (61, 561)) beneficios_sociales,
             (select sum(decode(c.sng026cod, 62, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                562,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (62, 562)) reservas,
             (select sum(decode(c.sng026cod, 63, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                563,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (63, 563)) otros_pasiv_nocorri,
             (select sum(decode(c.sng026cod, 64, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                564,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (64, 564)) tot_pasiv_nocorri,
             (select sum(decode(c.sng026cod, 65, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                565,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (65, 565)) total_pasivo,
             (select sum(decode(c.sng026cod, 66, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                566,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (66, 566)) capital,
             (select sum(decode(c.sng026cod, 67, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                567,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (67, 567)) result_acumulad,
             (select sum(decode(c.sng026cod, 68, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                568,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (68, 568)) result_ejercici,
             (select sum(decode(c.sng026cod, 69, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                569,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (69, 569)) otros_patrim,
             (select sum(decode(c.sng026cod, 70, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                570,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (70, 570)) total_patrimonio,
             (select sum(decode(c.sng026cod, 71, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                571,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (71, 571)) total_pasivo_patrimonio,
             (select sum(decode(c.sng026cod, 73, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                573,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (73, 573)) venta,
             (select sum(decode(c.sng026cod, 74, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                574,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (74, 574)) costo_venta,
             (select sum(decode(c.sng026cod, 75, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                575,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (75, 575)) utilid_bruta,
             (select sum(decode(c.sng026cod, 76, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                576,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (76, 576)) gastos_ventas, --costo_operativo,    
             (select sum(decode(c.sng026cod, 77, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                577,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (77, 577)) gasto_administrativo,
             (select sum(decode(c.sng026cod, 78, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                578,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (78, 578)) utilid_operativa,
             (select sum(decode(c.sng026cod, 79, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                579,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (79, 579)) Gastos_financieros, --servicio_deuda,
             (select sum(decode(c.sng026cod, 80, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                580,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (80, 580)) ingres_financieros,
             (select sum(decode(c.sng026cod, 81, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                581,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (81, 581)) gastos_diversos,
             (select sum(decode(c.sng026cod, 82, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                582,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (82, 582)) utilid_antes_impuestos,
             (select sum(decode(c.sng026cod, 83, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                583,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (83, 583)) impuestos,
             (select sum(decode(c.sng026cod, 84, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                584,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (84, 584)) utilidad_neta,
             (select sum(decode(c.sng026cod, 89, c.sng023mto, 0) +
                         decode(c.sng026cod,
                                589,
                                c.sng023mto *
                                fn_tipo_cambio_fijo(g021.sng021fec),
                                0))
                from sng023 c
               where c.sng021eval = g021.sng021eval
                 and c.sng026cod in (89, 589)) cuentas_pagar,
             g021.sng021fec EvalReciente
      
        INTO nroevaluacion,
             resulta_neto,
             disponible,
             ctxcbr,
             MERCADERIA,
             GASTOS_ANTICIPADOS,
             EXISTENCIAS_RECIBIR,
             otros_actv_corr,
             total_actv_corr,
             MUEBLES,
             INMUEBLES,
             otros_actv_fijo,
             tot_actv_fijo,
             xtotal_activ,
             OTROS_INGRESOS,
             GASTOS_FAMILIARES,
             CUENTAS_BANCO,
             TRIBUTO_PAGAR,
             xotros_pasiv_corr,
             xtotal_pasiv_corr,
             CUENTAS_BANCOLP,
             BENEFICIOS_SOCIALES,
             xreservas,
             xotros_pasiv_nocorri,
             xtot_pasiv_nocorri,
             xtotal_pasivo,
             xcapital,
             xresult_acumulad,
             xresult_ejercici,
             xotros_patrim,
             xtotal_patrimonio,
             xtotal_pasivo_patrimonio,
             VENTA,
             COSTO_VENTA,
             xutilid_bruta,
             COSTO_OPERATIVO,
             Gastos_administd,
             xutilid_operativa,
             SERVICIO_DEUDA,
             xingres_financieros,
             xgastos_diversos,
             xutilid_antes_impuestos,
             ximpuestos,
             xutilidad_neta,
             CUENTAS_PAGAR,
             FechEvalRec
      
        from sng021 g021
       where g021.sng021sol = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;

  -- 08052023
  procedure sp_analisisfinancieroCredConsumo(instancia               number, --08052023
                                             nroevaluacion           out number,
                                             IngBrutTitu             out number,
                                             IngBrutConyu            out number,
                                             IngBrutComis            out number,
                                             IngBrutOtros            out number,
                                             xAporteTitul            out number,
                                             xAporteConyu            out number,
                                             xAporteComisi           out number,
                                             xAporteOtros            out number,
                                             xOtroIngTitu            out number,
                                             xOtroIngConyu           out number,
                                             xOtroIngComis           out number,
                                             xOtroIngOtros           out number,
                                             IngNetoTotal            out number,
                                             EgrAlimentac            out number,
                                             EgrAlquiler             out number,
                                             EgrTranspor             out number,
                                             EgrEducacio             out number,
                                             EgrServicio             out number,
                                             EgrAporFami             out number,
                                             EgrOtros                out number,
                                             GastFinancier           out number,
                                             CuotCredProp            out number,
                                             ExcedNetoMen            out number,
                                             FechEvalReConsum        out date,
                                             ResuRatiCuIngNetEvlRec  out number,
                                             ResuRatiCuExceNetEvlRec out number) is
    auxTmod    number(4);
    ln_ModInst number;
  BEGIN
    BEGIN
      select SNG021TMOD
        INTO auxTmod
        from sng021
       where SNG021SOL = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        auxTmod := 0;
    END;
  
    --ratio cuota Ingreso Neto
    BEGIN
      SELECT JAQZ835RATIO
        INTO ResuRatiCuIngNetEvlRec
        FROM jaqz835
       WHERE JAQZ835INST = instancia
         AND JAQZ835EST = 'H'
         AND ROWNUM < 2;
    EXCEPTION
      WHEN OTHERS THEN
        ResuRatiCuIngNetEvlRec := 0;
    END;
    IF ResuRatiCuIngNetEvlRec <> 0 THEN
      ResuRatiCuIngNetEvlRec := ResuRatiCuIngNetEvlRec * 100;
    END IF;
  
    --ratio Excedente neto  
    BEGIN
      SELECT JAQZ821RATIO
        INTO ResuRatiCuExceNetEvlRec
        FROM JAQZ821
       WHERE JAQZ821INST = instancia
         AND JAQZ821EST = 'H'
         AND JAQZ821TAREA = 7;
    EXCEPTION
      WHEN OTHERS THEN
        ResuRatiCuExceNetEvlRec := 0;
    END;
    IF ResuRatiCuExceNetEvlRec <> 0 THEN
      ResuRatiCuExceNetEvlRec := ResuRatiCuExceNetEvlRec * 100;
    END IF;
  
    IF auxTmod = 14 THEN
      BEGIN
        select g021.sng021eval,
               
               (select sum(decode(c.sng026cod, 1, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  501,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (1, 501)) ingr_brutos_titular,
               
               (select sum(decode(c.sng026cod, 2, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  502,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (2, 502)) ingr_brutos_conyuge,
               
               (select sum(decode(c.sng026cod, 3, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  503,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (3, 503)) ingr_brutos_comisiones,
               
               (select sum(decode(c.sng026cod, 4, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  504,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (4, 504)) ingr_brutos_otros,
               ---
               (select sum(decode(c.sng026cod, 5, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  505,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (5, 505)) AporteTitu,
               
               (select sum(decode(c.sng026cod, 6, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  506,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (6, 506)) AporteConyu,
               
               (select sum(decode(c.sng026cod, 7, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  507,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (7, 507)) AporteComisiones,
               
               (select sum(decode(c.sng026cod, 8, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  508,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (8, 508)) AporteOtros,
               
               (select sum(decode(c.sng026cod, 9, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  509,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (9, 509)) OtroIngsTitul,
               
               (select sum(decode(c.sng026cod, 10, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  510,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (10, 510)) OtroIngsConyu,
               
               (select sum(decode(c.sng026cod, 11, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  511,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (11, 511)) OtroIngsComisiones,
               
               (select sum(decode(c.sng026cod, 12, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  512,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (12, 512)) OtroIngsOtros,
               
               ------                                                                   
               (select sum(decode(c.sng026cod, 21, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  521,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (21, 521)) ingr_netos_totales,
               
               (select sum(decode(c.sng026cod, 13, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  513,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (13, 513)) egr_alimentacion,
               
               (select sum(decode(c.sng026cod, 14, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  514,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (14, 514)) egr_alquiler,
               
               (select sum(decode(c.sng026cod, 15, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  515,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (15, 515)) egr_transporte,
               
               (select sum(decode(c.sng026cod, 16, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  516,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (16, 516)) egr_educacion,
               
               (select sum(decode(c.sng026cod, 17, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  517,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (17, 517)) egr_servicios,
               
               (select sum(decode(c.sng026cod, 18, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  518,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (18, 518)) egr_apfamiliar,
               
               (select sum(decode(c.sng026cod, 20, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  520,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (20, 520)) egr_otros,
               
               (select sum(decode(c.sng026cod, 19, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  519,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (19, 519)) gastos_financieros,
               
               (select sum(decode(c.sng026cod, 26, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  526,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (26, 526)) cuota_cred_propueso,
               
               (select sum(decode(c.sng026cod, 27, c.sng023mto, 0) +
                           decode(c.sng026cod,
                                  527,
                                  c.sng023mto *
                                  fn_tipo_cambio_fijo(g021.sng021fec),
                                  0))
                  from sng023 c
                 where c.sng021eval = g021.sng021eval
                   and c.sng026cod in (27, 527)) exedente_neto,
               g021.sng021fec EvalReciente
        
          INTO nroevaluacion,
               IngBrutTitu,
               IngBrutConyu,
               IngBrutComis,
               IngBrutOtros,
               xAporteTitul,
               xAporteConyu,
               xAporteComisi,
               xAporteOtros,
               xOtroIngTitu,
               xOtroIngConyu,
               xOtroIngComis,
               xOtroIngOtros,
               IngNetoTotal,
               EgrAlimentac,
               EgrAlquiler,
               EgrTranspor,
               EgrEducacio,
               EgrServicio,
               EgrAporFami,
               EgrOtros,
               GastFinancier,
               CuotCredProp,
               ExcedNetoMen,
               FechEvalReConsum
        
          from sng021 g021
         where g021.sng021sol = instancia;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      --Cred Propuesto 21082023
      CuotCredProp := 0;
      begin
        select x.xwfmodulo
          into ln_ModInst
          from xwf700 x
         where x.xwfprcins = instancia
           and x.xwfcar3 = '1';
      exception
        when others then
          null;
      end;
    
      if ln_ModInst <> 117 then
        BEGIN
          SELECT JAQZ822CAPCUO
            INTO CuotCredProp
            FROM XWF700 A, JAQZ822 B
           WHERE A.XWFEMPRESA = B.JAQZ822PGCOD
             AND A.XWFSUCURSAL = B.JAQZ822SUC
             AND A.XWFCUENTA = B.JAQZ822CTA
             AND A.XWFOPERACION = B.JAQZ822OPE
             AND A.XWFPRCINS = B.JAQZ822INST
             AND A.XWFTIPOPE = B.JAQZ822TOPE
             AND A.XWFPRCINS = instancia
             AND A.XWFCAR3 = '1'
             AND B.JAQZ822EST = 'H'
             and (b.jaqz822mod not in
                 (select tp1nro1
                     from fst198 f
                    where f.tp1cod = 1
                      and f.tp1cod1 = 10899
                      and f.tp1corr1 = 200
                      and f.tp1corr2 = 1
                      and f.tp1corr3 > 0) and b.jaqz822mod not in 117) --mpostigoc 051118 
             and b.jaqz822nrcuo > 1
             AND b.JAQZ822TAREA = 7;
        EXCEPTION
          WHEN OTHERS THEN
            CuotCredProp := 0;
        END;
      else
        if ln_ModInst = 117 then
        
          BEGIN
            SELECT JAQZ822CAPCUO
              INTO CuotCredProp
              FROM XWF700 A, JAQZ822 B
             WHERE A.XWFEMPRESA = B.JAQZ822PGCOD
               AND A.XWFSUCURSAL = B.JAQZ822SUC
               AND A.XWFCUENTA = B.JAQZ822CTA
               AND A.XWFOPERACION = B.JAQZ822OPE
               AND A.XWFPRCINS = B.JAQZ822INST
               AND A.XWFTIPOPE = B.JAQZ822TOPE
               AND A.XWFPRCINS = instancia
               AND A.XWFCAR3 = '1'
               AND B.JAQZ822EST = 'H'
               AND b.JAQZ822TAREA = 7;
          EXCEPTION
            WHEN OTHERS THEN
              CuotCredProp := 0;
          END;
        
          CuotCredProp := nvl(CuotCredProp, 0);
        end if;
      end if;
    
    END IF;
  END;

  procedure sp_AnlFinancEvalAnterio(instancia                number,
                                    nroINTipoCN              number, --30042024
                                    resulta_neto             out number,
                                    disponible               out number,
                                    ctxcbr                   out number,
                                    MERCADERIA               out number,
                                    GASTOS_ANTICIPADOS       out number,
                                    EXISTENCIAS_RECIBIR      out number,
                                    otros_actv_corr          out number,
                                    total_actv_corr          out number,
                                    MUEBLES                  out number,
                                    INMUEBLES                out number,
                                    otros_actv_fijo          out number,
                                    tot_actv_fijo            out number,
                                    xtotal_activ             out number,
                                    OTROS_INGRESOS           out number,
                                    GASTOS_FAMILIARES        out number,
                                    CUENTAS_BANCO            out number,
                                    TRIBUTO_PAGAR            out number,
                                    xotros_pasiv_corr        out number,
                                    xtotal_pasiv_corr        out number,
                                    CUENTAS_BANCOLP          out number,
                                    BENEFICIOS_SOCIALES      out number,
                                    xreservas                out number,
                                    xotros_pasiv_nocorri     out number,
                                    xtot_pasiv_nocorri       out number,
                                    xtotal_pasivo            out number,
                                    xcapital                 out number,
                                    xresult_acumulad         out number,
                                    xresult_ejercici         out number,
                                    xotros_patrim            out number,
                                    xtotal_patrimonio        out number,
                                    xtotal_pasivo_patrimonio out number,
                                    VENTA                    out number,
                                    COSTO_VENTA              out number,
                                    xutilid_bruta            out number,
                                    COSTO_OPERATIVO          out number,
                                    Gastos_administd         out number,
                                    xutilid_operativa        out number,
                                    SERVICIO_DEUDA           out number,
                                    xingres_financieros      out number,
                                    xgastos_diversos         out number,
                                    xutilid_antes_impuestos  out number,
                                    ximpuestos               out number,
                                    xutilidad_neta           out number,
                                    CUENTAS_PAGAR            out number,
                                    FechEvalRec              out date,
                                    ResultRatioEvalAnterior  out number) is
  
    auxPais            number(3);
    auxPetdoc          number(3);
    auxPendoc          varchar2(12);
    auxInstnc          number(10);
    cuenta             number(9);
    auxTmod            number(4);
    ln_evalflujo       varchar2(1);
    ln_evalflujoActual varchar2(1);
    Indicflujo         VARCHAR2(3);
    fechAntOut         DATE;
    TipFlujCN          VARCHAR2(1);
  
    --30042024
    nroOUTTipoCN                 number(1);
    crm_resulta_neto             number(17, 2);
    crm_disponible               number(17, 2);
    crm_ctxcbr                   number(17, 2);
    crm_MERCADERIA               number(17, 2);
    crm_GASTOS_ANTICIPADOS       number(17, 2);
    crm_EXISTENCIAS_RECIBIR      number(17, 2);
    crm_otros_actv_corr          number(17, 2);
    crm_total_actv_corr          number(17, 2);
    crm_MUEBLES                  number(17, 2);
    crm_INMUEBLES                number(17, 2);
    crm_otros_actv_fijo          number(17, 2);
    crm_tot_actv_fijo            number(17, 2);
    crm_xtotal_activ             number(17, 2);
    crm_OTROS_INGRESOS           number(17, 2);
    crm_GASTOS_FAMILIARES        number(17, 2);
    crm_CUENTAS_BANCO            number(17, 2);
    crm_TRIBUTO_PAGAR            number(17, 2);
    crm_xotros_pasiv_corr        number(17, 2);
    crm_xtotal_pasiv_corr        number(17, 2);
    crm_CUENTAS_BANCOLP          number(17, 2);
    crm_BENEFICIOS_SOCIALES      number(17, 2);
    crm_xreservas                number(17, 2);
    crm_xotros_pasiv_nocorri     number(17, 2);
    crm_xtot_pasiv_nocorri       number(17, 2);
    crm_xtotal_pasivo            number(17, 2);
    crm_xcapital                 number(17, 2);
    crm_xresult_acumulad         number(17, 2);
    crm_xresult_ejercici         number(17, 2);
    crm_xotros_patrim            number(17, 2);
    crm_xtotal_patrimonio        number(17, 2);
    crm_xtotal_pasivo_patrimonio number(17, 2);
    crm_VENTA                    number(17, 2);
    crm_COSTO_VENTA              number(17, 2);
    crm_xutilid_bruta            number(17, 2);
    crm_COSTO_OPERATIVO          number(17, 2);
    crm_Gastos_administd         number(17, 2);
    crm_xutilid_operativa        number(17, 2);
    crm_SERVICIO_DEUDA           number(17, 2);
    crm_xingres_financieros      number(17, 2);
    crm_xgastos_diversos         number(17, 2);
    crm_xutilid_antes_impuestos  number(17, 2);
    crm_ximpuestos               number(17, 2);
    crm_xutilidad_neta           number(17, 2);
    crm_CUENTAS_PAGAR            number(17, 2);
    crm_FechEvalRec              date;
    crm_ResultRatioEvalAnterior  number(17, 6);
  
  BEGIN
  
    BEGIN
      SELECT SNG021TMOD
        INTO auxTmod
        FROM sng021
       WHERE SNG021SOL = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        auxTmod := 0;
    END;
  
    TipFlujCN := 'N';
    IF nroINTipoCN <> 2 THEN
      --2 CRM, 1 NORMAL 30042024
      Indicflujo := 'NOR';
      BEGIN
        pq_cr_repo_opinion_riesgos.sp_obtner_Instanci_anterior(instancia  => instancia, --30042024
                                                               Indicflujo => Indicflujo,
                                                               auxInstnc  => auxInstnc,
                                                               fechAntOut => fechAntOut,
                                                               TipFlujCN  => TipFlujCN);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
    IF nroINTipoCN = 2 THEN
      --30042024
      auxInstnc := instancia;
    END IF;
  
    IF TipFlujCN = 'N' THEN
      --NORMAL                                                                                                                             
      IF AUXTMOD = 13 THEN
        BEGIN
          SELECT JAQY140RATIO
            INTO ResultRatioEvalAnterior
            FROM JAQY140
           WHERE JAQY140INST = auxInstnc
             AND JAQY140EST = 'H'
             AND JAQY140TAREA = 7;
        EXCEPTION
          WHEN OTHERS THEN
            ResultRatioEvalAnterior := 0;
        END;
      
        -- instancia actual
        BEGIN
          --identificar si la solicitud tiene evaluacion por flujo 30062023
          pq_cr_ratio_evalflujo.sp_cr_verfevalflujo(instancia,
                                                    ln_evalflujoActual);
        EXCEPTION
          WHEN OTHERS THEN
            ln_evalflujoActual := 'N';
        END;
      
        ln_evalflujo := 'N'; -- INI 30062023
        BEGIN
          --identificar si la solicitud tiene evaluacion por flujo 30062023
          pq_cr_ratio_evalflujo.sp_cr_verfevalflujo(auxInstnc,
                                                    ln_evalflujo);
        EXCEPTION
          WHEN OTHERS THEN
            ln_evalflujo := 'N';
        END;
      
        IF ln_evalflujo = 'S' AND ln_evalflujoActual = 'S' THEN
          -- es un credito con Evaluacion por Flujo
          BEGIN
            select a.aqpa354ratio
              INTO ResultRatioEvalAnterior
              from aqpa354 a
             where a.aqpa354inst = auxInstnc
               and a.aqpa354est = 'H' --Estado, siempre debe ser H
               and a.aqpa354tarea = 7; -- Tarea de ejecución de ratio, siempre debemos considerar el 7 ya que es ratio ejecutado en evaluación propuesta.
          EXCEPTION
            WHEN OTHERS THEN
              ResultRatioEvalAnterior := 0;
          END;
        ELSE
          IF ln_evalflujoActual = 'S' AND ln_evalflujo = 'N' THEN
            ResultRatioEvalAnterior := 0;
          END IF;
        END IF; -- FIN 30062023            
      
      END IF;
      IF AUXTMOD = 14 THEN
        -- SI MODELO  EVALUACION ES 14
        BEGIN
          SELECT JAQZ821RATIO
            INTO ResultRatioEvalAnterior
            FROM JAQZ821
           WHERE JAQZ821INST = auxInstnc
             AND JAQZ821EST = 'H'
             AND JAQZ821TAREA = 7;
        EXCEPTION
          WHEN OTHERS THEN
            ResultRatioEvalAnterior := 0;
        END;
      END IF;
    
      IF ResultRatioEvalAnterior <> 0 THEN
        ResultRatioEvalAnterior := ResultRatioEvalAnterior * 100;
      END IF;
    
      IF auxInstnc IS NULL THEN
        auxInstnc := 0;
      END IF;
    
      IF auxInstnc > 0 THEN
        BEGIN
          select --g021.sng021eval,
           (select sum(decode(c.sng026cod, 40, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              540,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (40, 540)) resultado_Neto,
           (select sum(decode(c.sng026cod, 41, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              541,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (41, 541)) Caja_bancos, --disponible,
           (select sum(decode(c.sng026cod, 42, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              542,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (42, 542)) cuentas_cobrar_comerci,
           (select sum(decode(c.sng026cod, 43, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              543,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (43, 543)) mercaderia,
           (select sum(decode(c.sng026cod, 44, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              544,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (44, 544)) gastos_anticipados,
           (select sum(decode(c.sng026cod, 45, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              545,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (45, 545)) existencias_recibir,
           (select sum(decode(c.sng026cod, 46, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              546,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (46, 546)) otros_act_corri,
           (select sum(decode(c.sng026cod, 47, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              547,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (47, 547)) total_actv_corri,
           (select sum(decode(c.sng026cod, 48, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              548,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (48, 548)) muebles,
           (select sum(decode(c.sng026cod, 49, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              549,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (49, 549)) inmuebles,
           (select sum(decode(c.sng026cod, 50, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              550,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (50, 550)) otros_act_fijo,
           (select sum(decode(c.sng026cod, 51, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              551,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (51, 551)) total_activ_fijo,
           (select sum(decode(c.sng026cod, 52, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              552,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (52, 552)) total_activ,
           (select sum(decode(c.sng026cod, 53, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              553,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (53, 553)) otros_ingreso,
           (select sum(decode(c.sng026cod, 54, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              554,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (54, 554)) gastos_familiares,
           (select sum(decode(c.sng026cod, 56, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              556,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (56, 556)) cuentas_banco,
           (select sum(decode(c.sng026cod, 57, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              557,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (57, 557)) tributo_pagar,
           (select sum(decode(c.sng026cod, 58, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              558,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (58, 558)) otros_pasiv_corr,
           (select sum(decode(c.sng026cod, 59, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              559,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (59, 559)) total_pasiv_corr,
           (select sum(decode(c.sng026cod, 60, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              560,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (60, 560)) cuentas_bancoLP,
           (select sum(decode(c.sng026cod, 61, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              561,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (61, 561)) beneficios_sociales,
           (select sum(decode(c.sng026cod, 62, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              562,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (62, 562)) reservas,
           (select sum(decode(c.sng026cod, 63, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              563,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (63, 563)) otros_pasiv_nocorri,
           (select sum(decode(c.sng026cod, 64, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              564,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (64, 564)) tot_pasiv_nocorri,
           (select sum(decode(c.sng026cod, 65, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              565,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (65, 565)) total_pasivo,
           (select sum(decode(c.sng026cod, 66, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              566,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (66, 566)) capital,
           (select sum(decode(c.sng026cod, 67, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              567,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (67, 567)) result_acumulad,
           (select sum(decode(c.sng026cod, 68, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              568,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (68, 568)) result_ejercici,
           (select sum(decode(c.sng026cod, 69, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              569,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (69, 569)) otros_patrim,
           (select sum(decode(c.sng026cod, 70, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              570,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (70, 570)) total_patrimonio,
           (select sum(decode(c.sng026cod, 71, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              571,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (71, 571)) total_pasivo_patrimonio,
           (select sum(decode(c.sng026cod, 73, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              573,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (73, 573)) venta,
           (select sum(decode(c.sng026cod, 74, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              574,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (74, 574)) costo_venta,
           (select sum(decode(c.sng026cod, 75, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              575,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (75, 575)) utilid_bruta,
           (select sum(decode(c.sng026cod, 76, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              576,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (76, 576)) gastos_ventas, --costo_operativo,    
           (select sum(decode(c.sng026cod, 77, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              577,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (77, 577)) gasto_administrativo,
           (select sum(decode(c.sng026cod, 78, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              578,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (78, 578)) utilid_operativa,
           (select sum(decode(c.sng026cod, 79, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              579,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (79, 579)) Gastos_financieros, --servicio_deuda,
           (select sum(decode(c.sng026cod, 80, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              580,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (80, 580)) ingres_financieros,
           (select sum(decode(c.sng026cod, 81, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              581,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (81, 581)) gastos_diversos,
           (select sum(decode(c.sng026cod, 82, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              582,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (82, 582)) utilid_antes_impuestos,
           (select sum(decode(c.sng026cod, 83, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              583,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (83, 583)) impuestos,
           (select sum(decode(c.sng026cod, 84, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              584,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (84, 584)) utilidad_neta,
           (select sum(decode(c.sng026cod, 89, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              589,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (89, 589)) cuentas_pagar,
           g021.sng021fec EvalReciente
          
            INTO --nroevaluacion,
                 resulta_neto,
                 disponible,
                 ctxcbr,
                 MERCADERIA,
                 GASTOS_ANTICIPADOS,
                 EXISTENCIAS_RECIBIR,
                 otros_actv_corr,
                 total_actv_corr,
                 MUEBLES,
                 INMUEBLES,
                 otros_actv_fijo,
                 tot_actv_fijo,
                 xtotal_activ,
                 OTROS_INGRESOS,
                 GASTOS_FAMILIARES,
                 CUENTAS_BANCO,
                 TRIBUTO_PAGAR,
                 xotros_pasiv_corr,
                 xtotal_pasiv_corr,
                 CUENTAS_BANCOLP,
                 BENEFICIOS_SOCIALES,
                 xreservas,
                 xotros_pasiv_nocorri,
                 xtot_pasiv_nocorri,
                 xtotal_pasivo,
                 xcapital,
                 xresult_acumulad,
                 xresult_ejercici,
                 xotros_patrim,
                 xtotal_patrimonio,
                 xtotal_pasivo_patrimonio,
                 VENTA,
                 COSTO_VENTA,
                 xutilid_bruta,
                 COSTO_OPERATIVO,
                 Gastos_administd,
                 xutilid_operativa,
                 SERVICIO_DEUDA,
                 xingres_financieros,
                 xgastos_diversos,
                 xutilid_antes_impuestos,
                 ximpuestos,
                 xutilidad_neta,
                 CUENTAS_PAGAR,
                 FechEvalRec
            from sng021 g021
           where g021.sng021sol = auxInstnc;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            NULL;
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
    ELSE
      ----si la eval anterior es CRM llamar proc. 30042024
      IF TipFlujCN = 'C' THEN
        nroOUTTipoCN := 1;
        BEGIN
          pq_cr_repo_opini_riesgos_CRM.sp_AnlFinancEvalAnterio(auxInstnc,
                                                               nroOUTTipoCN,
                                                               crm_resulta_neto,
                                                               crm_disponible,
                                                               crm_ctxcbr,
                                                               crm_MERCADERIA,
                                                               crm_GASTOS_ANTICIPADOS,
                                                               crm_EXISTENCIAS_RECIBIR,
                                                               crm_otros_actv_corr,
                                                               crm_total_actv_corr,
                                                               crm_MUEBLES,
                                                               crm_INMUEBLES,
                                                               crm_otros_actv_fijo,
                                                               crm_tot_actv_fijo,
                                                               crm_xtotal_activ,
                                                               crm_OTROS_INGRESOS,
                                                               crm_GASTOS_FAMILIARES,
                                                               crm_CUENTAS_BANCO,
                                                               crm_TRIBUTO_PAGAR,
                                                               crm_xotros_pasiv_corr,
                                                               crm_xtotal_pasiv_corr,
                                                               crm_CUENTAS_BANCOLP,
                                                               crm_BENEFICIOS_SOCIALES,
                                                               crm_xreservas,
                                                               crm_xotros_pasiv_nocorri,
                                                               crm_xtot_pasiv_nocorri,
                                                               crm_xtotal_pasivo,
                                                               crm_xcapital,
                                                               crm_xresult_acumulad,
                                                               crm_xresult_ejercici,
                                                               crm_xotros_patrim,
                                                               crm_xtotal_patrimonio,
                                                               crm_xtotal_pasivo_patrimonio,
                                                               crm_VENTA,
                                                               crm_COSTO_VENTA,
                                                               crm_xutilid_bruta,
                                                               crm_COSTO_OPERATIVO,
                                                               crm_Gastos_administd,
                                                               crm_xutilid_operativa,
                                                               crm_SERVICIO_DEUDA,
                                                               crm_xingres_financieros,
                                                               crm_xgastos_diversos,
                                                               crm_xutilid_antes_impuestos,
                                                               crm_ximpuestos,
                                                               crm_xutilidad_neta,
                                                               crm_CUENTAS_PAGAR,
                                                               crm_FechEvalRec,
                                                               crm_ResultRatioEvalAnterior);
        
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        resulta_neto             := crm_resulta_neto;
        disponible               := crm_disponible;
        ctxcbr                   := crm_ctxcbr;
        MERCADERIA               := crm_MERCADERIA;
        GASTOS_ANTICIPADOS       := crm_GASTOS_ANTICIPADOS;
        EXISTENCIAS_RECIBIR      := crm_EXISTENCIAS_RECIBIR;
        otros_actv_corr          := crm_otros_actv_corr;
        total_actv_corr          := crm_total_actv_corr;
        MUEBLES                  := crm_MUEBLES;
        INMUEBLES                := crm_INMUEBLES;
        otros_actv_fijo          := crm_otros_actv_fijo;
        tot_actv_fijo            := crm_tot_actv_fijo;
        xtotal_activ             := crm_xtotal_activ;
        OTROS_INGRESOS           := crm_OTROS_INGRESOS;
        GASTOS_FAMILIARES        := crm_GASTOS_FAMILIARES;
        CUENTAS_BANCO            := crm_CUENTAS_BANCO;
        TRIBUTO_PAGAR            := crm_TRIBUTO_PAGAR;
        xotros_pasiv_corr        := crm_xotros_pasiv_corr;
        xtotal_pasiv_corr        := crm_xtotal_pasiv_corr;
        CUENTAS_BANCOLP          := crm_CUENTAS_BANCOLP;
        BENEFICIOS_SOCIALES      := crm_BENEFICIOS_SOCIALES;
        xreservas                := crm_xreservas;
        xotros_pasiv_nocorri     := crm_xotros_pasiv_nocorri;
        xtot_pasiv_nocorri       := crm_xtot_pasiv_nocorri;
        xtotal_pasivo            := crm_xtotal_pasivo;
        xcapital                 := crm_xcapital;
        xresult_acumulad         := crm_xresult_acumulad;
        xresult_ejercici         := crm_xresult_ejercici;
        xotros_patrim            := crm_xotros_patrim;
        xtotal_patrimonio        := crm_xtotal_patrimonio;
        xtotal_pasivo_patrimonio := crm_xtotal_pasivo_patrimonio;
        VENTA                    := crm_VENTA;
        COSTO_VENTA              := crm_COSTO_VENTA;
        xutilid_bruta            := crm_xutilid_bruta;
        COSTO_OPERATIVO          := crm_COSTO_OPERATIVO;
        Gastos_administd         := crm_Gastos_administd;
        xutilid_operativa        := crm_xutilid_operativa;
        SERVICIO_DEUDA           := crm_SERVICIO_DEUDA;
        xingres_financieros      := crm_xingres_financieros;
        xgastos_diversos         := crm_xgastos_diversos;
        xutilid_antes_impuestos  := crm_xutilid_antes_impuestos;
        ximpuestos               := crm_ximpuestos;
        xutilidad_neta           := crm_xutilidad_neta;
        CUENTAS_PAGAR            := crm_CUENTAS_PAGAR;
        FechEvalRec              := crm_FechEvalRec;
        ResultRatioEvalAnterior  := crm_ResultRatioEvalAnterior;
      END IF;
    END IF;
  END;

  procedure sp_AnlFinancEvalAnterioConsumo(instancia               number, --08052023
                                           nroINTipoCN             number,
                                           IngBrutTitu             out number,
                                           IngBrutConyu            out number,
                                           IngBrutComis            out number,
                                           IngBrutOtros            out number,
                                           xAporteTitul            out number,
                                           xAporteConyu            out number,
                                           xAporteComisi           out number,
                                           xAporteOtros            out number,
                                           xOtroIngTitu            out number,
                                           xOtroIngConyu           out number,
                                           xOtroIngComis           out number,
                                           xOtroIngOtros           out number,
                                           IngNetoTotal            out number,
                                           EgrAlimentac            out number,
                                           EgrAlquiler             out number,
                                           EgrTranspor             out number,
                                           EgrEducacio             out number,
                                           EgrServicio             out number,
                                           EgrAporFami             out number,
                                           EgrOtros                out number,
                                           GastFinancier           out number,
                                           CuotCredProp            out number,
                                           ExcedNetoMen            out number,
                                           FechEvalAnterConsum     out date,
                                           ResuRatiCuIngNetEvlAnt  out number,
                                           ResuRatiCuExceNetEvlAnt out number) is
    auxPais    number(3);
    auxPetdoc  number(3);
    auxPendoc  varchar2(12);
    auxInstnc  number(10);
    cuenta     number(9);
    auxTmod    number(4);
    ln_ModInst number;
    fechAntOut date;
    TipFlujCN  varchar2(1);
    Indicflujo varchar2(3);
  
    --Crm
    nroOUTipoCN                 NUMBER(1);
    crm_IngBrutTitu             NUMBER(17, 2);
    crm_IngBrutConyu            NUMBER(17, 2);
    crm_IngBrutComis            NUMBER(17, 2);
    crm_IngBrutOtros            NUMBER(17, 2);
    crm_xAporteTitul            NUMBER(17, 2);
    crm_xAporteConyu            NUMBER(17, 2);
    crm_xAporteComisi           NUMBER(17, 2);
    crm_xAporteOtros            NUMBER(17, 2);
    crm_xOtroIngTitu            NUMBER(17, 2);
    crm_xOtroIngConyu           NUMBER(17, 2);
    crm_xOtroIngComis           NUMBER(17, 2);
    crm_xOtroIngOtros           NUMBER(17, 2);
    crm_IngNetoTotal            NUMBER(17, 2);
    crm_EgrAlimentac            NUMBER(17, 2);
    crm_EgrAlquiler             NUMBER(17, 2);
    crm_EgrTranspor             NUMBER(17, 2);
    crm_EgrEducacio             NUMBER(17, 2);
    crm_EgrServicio             NUMBER(17, 2);
    crm_EgrAporFami             NUMBER(17, 2);
    crm_EgrOtros                NUMBER(17, 2);
    crm_GastFinancier           NUMBER(17, 2);
    crm_CuotCredProp            NUMBER(17, 2);
    crm_ExcedNetoMen            NUMBER(17, 2);
    crm_FechEvalAnterConsum     DATE;
    crm_ResuRatiCuIngNetEvlAnt  NUMBER(17, 2);
    crm_ResuRatiCuExceNetEvlAnt NUMBER(17, 2);
  
  BEGIN
  
    BEGIN
      SELECT SNG021TMOD
        INTO auxTmod
        FROM sng021
       WHERE SNG021SOL = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        auxTmod := 0;
    END;
  
    TipFlujCN := 'N';
    -- obtener instancia anterior
    IF nroINTipoCN <> 2 THEN
      Indicflujo := 'NOR';
      BEGIN
        pq_cr_repo_opinion_riesgos.sp_obtner_Instanci_anterior(instancia  => instancia,
                                                               Indicflujo => Indicflujo,
                                                               auxInstnc  => auxInstnc,
                                                               fechAntOut => fechAntOut,
                                                               TipFlujCN  => TipFlujCN);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
    IF nroINTipoCN = 2 THEN
      --30042024
      auxInstnc := instancia;
    END IF;
  
    IF TipFlujCN = 'N' THEN
      --N NORMAL C - CRM   
      IF AUXTMOD = 13 THEN
        BEGIN
          SELECT JAQY140RATIO
            INTO ResuRatiCuExceNetEvlAnt
            FROM JAQY140
           WHERE JAQY140INST = auxInstnc
             AND JAQY140EST = 'H'
             AND JAQY140TAREA = 7;
        EXCEPTION
          WHEN OTHERS THEN
            ResuRatiCuExceNetEvlAnt := 0;
        END;
      END IF;
      IF AUXTMOD = 14 THEN
        -- SI MODELO  EVALUACION ES 14
        BEGIN
          SELECT JAQZ821RATIO
            INTO ResuRatiCuExceNetEvlAnt
            FROM JAQZ821
           WHERE JAQZ821INST = auxInstnc
             AND JAQZ821EST = 'H'
             AND JAQZ821TAREA = 7;
        EXCEPTION
          WHEN OTHERS THEN
            ResuRatiCuExceNetEvlAnt := 0;
        END;
      END IF;
    
      IF ResuRatiCuExceNetEvlAnt <> 0 THEN
        ResuRatiCuExceNetEvlAnt := ResuRatiCuExceNetEvlAnt * 100;
      END IF;
    
      --ratio cuota Ingreso Neto
      BEGIN
        SELECT JAQZ835RATIO
          INTO ResuRatiCuIngNetEvlAnt
          FROM jaqz835
         WHERE JAQZ835INST = auxInstnc
           AND JAQZ835EST = 'H'
           AND ROWNUM < 2;
      EXCEPTION
        WHEN OTHERS THEN
          ResuRatiCuIngNetEvlAnt := 0;
      END;
      IF ResuRatiCuIngNetEvlAnt <> 0 THEN
        ResuRatiCuIngNetEvlAnt := ResuRatiCuIngNetEvlAnt * 100;
      END IF;
    
      IF auxInstnc > 0 THEN
        BEGIN
          select --g021.sng021eval,
          
           (select sum(decode(c.sng026cod, 1, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              501,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (1, 501)) ingr_brutos_titular,
           
           (select sum(decode(c.sng026cod, 2, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              502,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (2, 502)) ingr_brutos_conyuge,
           
           (select sum(decode(c.sng026cod, 3, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              503,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (3, 503)) ingr_brutos_comisiones,
           
           (select sum(decode(c.sng026cod, 4, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              504,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (4, 504)) ingr_brutos_otros,
           ---
           (select sum(decode(c.sng026cod, 5, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              505,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (5, 505)) AporteTitu,
           
           (select sum(decode(c.sng026cod, 6, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              506,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (6, 506)) AporteConyu,
           
           (select sum(decode(c.sng026cod, 7, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              507,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (7, 507)) AporteComisiones,
           
           (select sum(decode(c.sng026cod, 8, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              508,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (8, 508)) AporteOtros,
           --   
           (select sum(decode(c.sng026cod, 9, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              509,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (9, 509)) OtroIngsTitul,
           
           (select sum(decode(c.sng026cod, 10, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              510,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (10, 510)) OtroIngsConyu,
           
           (select sum(decode(c.sng026cod, 11, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              511,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (11, 511)) OtroIngsComisiones,
           
           (select sum(decode(c.sng026cod, 12, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              512,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (12, 512)) OtroIngsOtros,
           ------                                                     
           
           (select sum(decode(c.sng026cod, 21, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              521,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (21, 521)) ingr_netos_totales,
           
           (select sum(decode(c.sng026cod, 13, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              513,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (13, 513)) egr_alimentacion,
           
           (select sum(decode(c.sng026cod, 14, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              514,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (14, 514)) egr_alquiler,
           
           (select sum(decode(c.sng026cod, 15, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              515,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (15, 515)) egr_transporte,
           
           (select sum(decode(c.sng026cod, 16, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              516,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (16, 516)) egr_educacion,
           
           (select sum(decode(c.sng026cod, 17, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              517,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (17, 517)) egr_servicios,
           
           (select sum(decode(c.sng026cod, 18, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              518,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (18, 518)) egr_apfamiliar,
           
           (select sum(decode(c.sng026cod, 20, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              520,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (20, 520)) egr_otros,
           
           (select sum(decode(c.sng026cod, 19, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              519,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (19, 519)) gastos_financieros,
           
           (select sum(decode(c.sng026cod, 26, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              526,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (26, 526)) cuota_cred_propueso,
           
           (select sum(decode(c.sng026cod, 27, c.sng023mto, 0) +
                       decode(c.sng026cod,
                              527,
                              c.sng023mto *
                              fn_tipo_cambio_fijo(g021.sng021fec),
                              0))
              from sng023 c
             where c.sng021eval = g021.sng021eval
               and c.sng026cod in (27, 527)) exedente_neto,
           g021.sng021fec EvalReciente
          
            INTO --nroevaluacion,
                 IngBrutTitu,
                 IngBrutConyu,
                 IngBrutComis,
                 IngBrutOtros,
                 xAporteTitul,
                 xAporteConyu,
                 xAporteComisi,
                 xAporteOtros,
                 xOtroIngTitu,
                 xOtroIngConyu,
                 xOtroIngComis,
                 xOtroIngOtros,
                 IngNetoTotal,
                 EgrAlimentac,
                 EgrAlquiler,
                 EgrTranspor,
                 EgrEducacio,
                 EgrServicio,
                 EgrAporFami,
                 EgrOtros,
                 GastFinancier,
                 CuotCredProp,
                 ExcedNetoMen,
                 FechEvalAnterConsum
            from sng021 g021
           where g021.sng021sol = auxInstnc;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            NULL;
          WHEN OTHERS THEN
            NULL;
        END;
      
        --Cred Propuesto 21082023
        CuotCredProp := 0;
        begin
          select x.xwfmodulo
            into ln_ModInst
            from xwf700 x
           where x.xwfprcins = auxInstnc
             and x.xwfcar3 = '1';
        exception
          when others then
            null;
        end;
      
        if ln_ModInst <> 117 then
        
          BEGIN
            SELECT JAQZ822CAPCUO
              INTO CuotCredProp
              FROM XWF700 A, JAQZ822 B
             WHERE A.XWFEMPRESA = B.JAQZ822PGCOD
               AND A.XWFSUCURSAL = B.JAQZ822SUC
               AND A.XWFCUENTA = B.JAQZ822CTA
               AND A.XWFOPERACION = B.JAQZ822OPE
               AND A.XWFPRCINS = B.JAQZ822INST
               AND A.XWFTIPOPE = B.JAQZ822TOPE
               AND A.XWFPRCINS = auxInstnc
               AND A.XWFCAR3 = '1'
               AND B.JAQZ822EST = 'H'
               and (b.jaqz822mod not in
                   (select tp1nro1
                       from fst198 f
                      where f.tp1cod = 1
                        and f.tp1cod1 = 10899
                        and f.tp1corr1 = 200
                        and f.tp1corr2 = 1
                        and f.tp1corr3 > 0) and b.jaqz822mod not in 117) --mpostigoc 051118 
               and b.jaqz822nrcuo > 1
               AND b.JAQZ822TAREA = 7;
          EXCEPTION
            WHEN OTHERS THEN
              CuotCredProp := 0;
          END;
        
        else
          if ln_ModInst = 117 then
            BEGIN
              SELECT JAQZ822CAPCUO
                INTO CuotCredProp
                FROM XWF700 A, JAQZ822 B
               WHERE A.XWFEMPRESA = B.JAQZ822PGCOD
                 AND A.XWFSUCURSAL = B.JAQZ822SUC
                 AND A.XWFCUENTA = B.JAQZ822CTA
                 AND A.XWFOPERACION = B.JAQZ822OPE
                 AND A.XWFPRCINS = B.JAQZ822INST
                 AND A.XWFTIPOPE = B.JAQZ822TOPE
                 AND A.XWFPRCINS = auxInstnc
                 AND A.XWFCAR3 = '1'
                 AND B.JAQZ822EST = 'H'
                 AND B.JAQZ822TAREA = 7;
            EXCEPTION
              WHEN OTHERS THEN
                CuotCredProp := 0;
            END;
            CuotCredProp := nvl(CuotCredProp, 0);
          end if;
        end if;
      END IF;
    ELSE
      --CASO Q inst anter CRM  30042024
      IF TipFlujCN = 'C' THEN
        nroOUTipoCN := 1;
        BEGIN
          pq_cr_repo_opini_riesgos_CRM.sp_AnlFinancEvalAnterioConsumo(auxInstnc,
                                                                      nroOUTipoCN,
                                                                      fechAntOut,
                                                                      crm_IngBrutTitu,
                                                                      crm_IngBrutConyu,
                                                                      crm_IngBrutComis,
                                                                      crm_IngBrutOtros,
                                                                      crm_xAporteTitul,
                                                                      crm_xAporteConyu,
                                                                      crm_xAporteComisi,
                                                                      crm_xAporteOtros,
                                                                      crm_xOtroIngTitu,
                                                                      crm_xOtroIngConyu,
                                                                      crm_xOtroIngComis,
                                                                      crm_xOtroIngOtros,
                                                                      crm_IngNetoTotal,
                                                                      crm_EgrAlimentac,
                                                                      crm_EgrAlquiler,
                                                                      crm_EgrTranspor,
                                                                      crm_EgrEducacio,
                                                                      crm_EgrServicio,
                                                                      crm_EgrAporFami,
                                                                      crm_EgrOtros,
                                                                      crm_GastFinancier,
                                                                      crm_CuotCredProp,
                                                                      crm_ExcedNetoMen,
                                                                      crm_FechEvalAnterConsum,
                                                                      crm_ResuRatiCuIngNetEvlAnt,
                                                                      crm_ResuRatiCuExceNetEvlAnt);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        IngBrutTitu             := crm_IngBrutTitu;
        IngBrutConyu            := crm_IngBrutConyu;
        IngBrutComis            := crm_IngBrutComis;
        IngBrutOtros            := crm_IngBrutOtros;
        xAporteTitul            := crm_xAporteTitul;
        xAporteConyu            := crm_xAporteConyu;
        xAporteComisi           := crm_xAporteComisi;
        xAporteOtros            := crm_xAporteOtros;
        xOtroIngTitu            := crm_xOtroIngTitu;
        xOtroIngConyu           := crm_xOtroIngConyu;
        xOtroIngComis           := crm_xOtroIngComis;
        xOtroIngOtros           := crm_xOtroIngOtros;
        IngNetoTotal            := crm_IngNetoTotal;
        EgrAlimentac            := crm_EgrAlimentac;
        EgrAlquiler             := crm_EgrAlquiler;
        EgrTranspor             := crm_EgrTranspor;
        EgrEducacio             := crm_EgrEducacio;
        EgrServicio             := crm_EgrServicio;
        EgrAporFami             := crm_EgrAporFami;
        EgrOtros                := crm_EgrOtros;
        GastFinancier           := crm_GastFinancier;
        CuotCredProp            := crm_CuotCredProp;
        ExcedNetoMen            := crm_ExcedNetoMen;
        FechEvalAnterConsum     := crm_FechEvalAnterConsum;
        ResuRatiCuIngNetEvlAnt  := crm_ResuRatiCuIngNetEvlAnt;
        ResuRatiCuExceNetEvlAnt := crm_ResuRatiCuExceNetEvlAnt;
      END IF;
    END IF;
  END;

  procedure sp_inser_cabec_AQPC156(codOpinionGenerado number,
                                   auxAQPC156FECPRO   date,
                                   auxAQPC156INSTAN   number,
                                   auxAQPC156A        varchar2,
                                   auxAQPC156DE       varchar2,
                                   auxAQPC156ASUNT    varchar2,
                                   auxTextComple      varchar2,
                                   auxAQPC156CLIEN    varchar2,
                                   auxAQPC156DNI      varchar2,
                                   auxAQPC156ANALIS   varchar2,
                                   auxAQPC156AGENC    varchar2,
                                   auxAQPC156ZONA     varchar2,
                                   auxAQPC156REGIO    varchar2,
                                   auxAQPC156RATGANA  VARCHAR2,
                                   auxAQPC156RATAGEN  VARCHAR2,
                                   auxAQPC156SLDCANA  number,
                                   auxAQPC156SLDCAGE  number,
                                   auxAQPC156SLDCZON  number,
                                   auxAQPC156SLDCREG  number,
                                   auxAQPC156NCLIANA  number,
                                   auxAQPC156NCLIAGE  number,
                                   auxAQPC156NCLIZON  number,
                                   auxAQPC156NCLIREG  number,
                                   auxAQPC156NMORAG   varchar2,
                                   auxAQPC156NMORAN   varchar2,
                                   auxAQPC156NMORZO   varchar2,
                                   auxAQPC156NMOREG   varchar2,
                                   auxAQPC156NVRIESG  varchar2,
                                   auxAQPC156ACTIVID  varchar2,
                                   auxAQPC156PDANA    number,
                                   auxAQPC156PDAGE    number,
                                   auxAQPC156PDZON    number,
                                   auxAQPC156PDREG    number,
                                   auxAQPC156COH4ANA  number,
                                   auxAQPC156COH4AGE  number,
                                   auxAQPC156COH4ZON  number,
                                   auxAQPC156COH4REG  number,
                                   auxAQPC156COH6ANA  number,
                                   auxAQPC156COH6AGE  number,
                                   auxAQPC156COH6ZON  number,
                                   auxAQPC156COH6REG  number,
                                   auxAQPC156SOLIC    number,
                                   auxAQPC156CTNRO    number,
                                   auxAQPC156CALIF    varchar2,
                                   auxAQPC156PRODSBS  varchar2,
                                   auxAQPC156FECEEFF  date,
                                   auxAQPC156FECINFC  date,
                                   auxAQPC156CODTPRO  number,
                                   auxAQPC156TIPPRO   varchar2,
                                   auxAQPC156RESPTOT  number,
                                   auxAQPC156SLDPROP  number,
                                   auxAQPC156MODPRP   varchar2,
                                   auxcuota           number,
                                   auxQPC156CUOPRP    varchar2,
                                   auxAQPC156TASPRP   number,
                                   auxCodTipSolicitud number,
                                   auxDescTipSolic    varchar2,
                                   auxAQPC156DESCRED  long,
                                   auxAQPC160USUREG   varchar2,
                                   auxAQPC160HORRG    varchar2,
                                   CodNivel           number,
                                   auxFlgAnaliCont    varchar2,
                                   flagGrabad         out varchar2) IS
    SucursalCred   number(3);
    UsuarioGA      varchar2(10);
    UsuarioAC      varchar2(10);
    v_correlativo  number(10); --2108
    v_montoPropu   number(17, 2);
    v_modalidPropu varchar2(200);
    v_cuotaPropu   number(17, 2);
    v_totCuotPropu varchar2(20);
    v_tasaPropu    number(7, 2);
    v_monedaPropu  number(3);
  
    v_fechaActual date;
    x_contExist   number(1);
    v_tipoCambio  number(10, 6);
  BEGIN
    IF codOpinionGenerado > 0 THEN
      --1108
      -- obtener tipo cambio
      v_tipoCambio := 0;
      BEGIN
        pq_cr_repo_opinion_riesgos.sp_obtener_tipo_cambio(auxAQPC156INSTAN,
                                                          v_tipoCambio);
      EXCEPTION
        WHEN OTHERS THEN
          v_tipoCambio := 0;
      END;
    
      --obtener cred propuesto 15092023    
      BEGIN
        pq_cr_repo_opinion_riesgos.sp_operac_propuesta(auxAQPC156INSTAN,
                                                       0,
                                                       v_montoPropu,
                                                       v_modalidPropu,
                                                       v_cuotaPropu,
                                                       v_totCuotPropu,
                                                       v_tasaPropu,
                                                       v_monedaPropu); --2108
      EXCEPTION
        WHEN OTHERS THEN
          v_montoPropu   := 0;
          v_modalidPropu := '';
          v_cuotaPropu   := 0;
          v_totCuotPropu := '';
          v_tasaPropu    := 0;
          v_monedaPropu  := 0;
      END;
    
      v_montoPropu  := nvl(v_montoPropu, 0);
      v_cuotaPropu  := nvl(v_cuotaPropu, 0);
      v_tasaPropu   := nvl(v_tasaPropu, 0);
      v_monedaPropu := nvl(v_monedaPropu, 0);
    
      -- obtener usuario GA, AC 
      BEGIN
        SELECT M.XWFSUCURSAL
          INTO SucursalCred
          FROM XWF700 M
         WHERE M.XWFPRCINS = auxAQPC156INSTAN
           AND M.XWFCAR3 = '1'
           AND ROWNUM < 2;
      EXCEPTION
        WHEN OTHERS THEN
          SucursalCred := 0;
      END;
    
      BEGIN
        pq_cr_repo_opinion_riesgos.sp_obtenr_usu_AC_GA(auxAQPC156INSTAN,
                                                       SucursalCred,
                                                       UsuarioGA,
                                                       UsuarioAC);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      --VALIDAR si existe
      BEGIN
        --2108
        SELECT count(1)
          into x_contExist
          FROM AQPC156
         WHERE AQPC156CODOPI = codOpinionGenerado
           AND AQPC156INSTAN = auxAQPC156INSTAN
           AND AQPC156ESTAD = 'H';
      EXCEPTION
        WHEN OTHERS THEN
          x_contExist := 0;
      END;
      if x_contExist is null then
        x_contExist := 0;
      end if;
      x_contExist := NVL(x_contExist, 0);
    
      IF x_contExist = 0 THEN
        -- 2108
        BEGIN
          SELECT MAX(AQPC156CORR)
            INTO v_correlativo
            FROM AQPC156
           WHERE AQPC156CODOPI = codOpinionGenerado
             AND AQPC156INSTAN = auxAQPC156INSTAN;
        EXCEPTION
          WHEN OTHERS THEN
            v_correlativo := 0;
        END;
        IF v_correlativo IS NULL THEN
          v_correlativo := 0;
        END IF;
      
        v_correlativo := v_correlativo + 1;
        --Actualizar de H a I 
        IF v_correlativo > 0 THEN
          BEGIN
            UPDATE AQPC156
               SET AQPC156ESTAD = 'I'
             WHERE AQPC156CODOPI = codOpinionGenerado
               AND AQPC156INSTAN = auxAQPC156INSTAN
               AND AQPC156ESTAD = 'H';
            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
      
        -- obtener usuario GA, AC 
        /* BEGIN
          SELECT M.XWFSUCURSAL
            INTO SucursalCred
            FROM XWF700 M
           WHERE M.XWFPRCINS = auxAQPC156INSTAN
             AND M.XWFCAR3 = '1'
             AND ROWNUM < 2;
        EXCEPTION
          WHEN OTHERS THEN
            SucursalCred := 0;
        END;
        
        BEGIN
          pq_cr_repo_opinion_riesgos.sp_obtenr_usu_AC_GA(auxAQPC156INSTAN,
                                                         SucursalCred,
                                                         UsuarioGA,
                                                         UsuarioAC);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;*/
      
        --obtener cred propuesto 15092023
        /* BEGIN
          pq_cr_repo_opinion_riesgos.sp_operac_propuesta(auxAQPC156INSTAN, 
                                                         0,
                                                         v_montoPropu,  
                                                         v_modalidPropu,
                                                         v_cuotaPropu,  
                                                         v_totCuotPropu,
                                                         v_tasaPropu,   
                                                         v_monedaPropu); --2108
        EXCEPTION
          WHEN OTHERS THEN
            v_montoPropu := 0;  
            v_modalidPropu:= 0;
            v_cuotaPropu := 0;  
            v_totCuotPropu := 0;
            v_tasaPropu := 0;   
            v_monedaPropu := 0;                                                                   
        END;*/
      
        --FECHA ACTUAL
        v_fechaActual := TO_DATE(SYSDATE, 'dd/mm/rrrr');
      
        BEGIN
          INSERT INTO AQPC156
            (AQPC156CODOPI,
             AQPC156FECPRO,
             AQPC156INSTAN,
             AQPC156A,
             AQPC156DE,
             AQPC156ASUNT,
             AQPC156TEXCOM,
             AQPC156CLIEN,
             AQPC156DNI,
             AQPC156ANALIS,
             AQPC156AGENC,
             AQPC156ZONA,
             AQPC156REGIO,
             AQPC156RATGANA,
             AQPC156RATAGEN,
             AQPC156SLDCANA,
             AQPC156SLDCAGE,
             AQPC156SLDCZON,
             AQPC156SLDCREG,
             AQPC156NCLIANA,
             AQPC156NCLIAGE,
             AQPC156NCLIZON,
             AQPC156NCLIREG,
             AQPC156NMORAG,
             AQPC156NMORAN,
             AQPC156NMORZO,
             AQPC156NMOREG,
             AQPC156NVRIESG,
             AQPC156ACTIVID,
             AQPC156PDANA,
             AQPC156PDAGE,
             AQPC156PDZON,
             AQPC156PDREG,
             AQPC156COH4ANA,
             AQPC156COH4AGE,
             AQPC156COH4ZON,
             AQPC156COH4REG,
             AQPC156COH6ANA,
             AQPC156COH6AGE,
             AQPC156COH6ZON,
             AQPC156COH6REG,
             AQPC156SOLIC,
             AQPC156CTNRO,
             AQPC156CALIF,
             AQPC156PRODSBS,
             AQPC156FECEEFF,
             AQPC156FECINFC,
             AQPC156CODTPRO,
             AQPC156TIPPRO,
             AQPC156RESPTOT,
             AQPC156SLDPROP,
             AQPC156MODPRP,
             AQPC156CUOTAS,
             AQPC156CUOPRP,
             AQPC156TASPRP,
             AQPC156TIPSOL,
             AQPC156DETISOL,
             --AQPC156USUREG, -- INI MOD RCASTRO 10072023
             AQPC156USRDER,
             AQPC156ANSERIG, --  FIN MOD RCASTRO 10072023
             AQPC156HORRG,
             AQPC156ESTOP,
             AQPC156NIVEL,
             AQPC156ACTCONT,
             AQPC156USUREG, -- MOD RCASTRO 10072023
             AQPC156GRAGE,
             AQPC156NRECONS,
             AQPC156ESRECON,
             AQPC156CORR, --21082023
             AQPC156ESTAD,
             AQPC156AUX3, --21082023             
             AQPC156TCAMB,
             AQPC156MDAPROP)
          VALUES
            (codOpinionGenerado,
             auxAQPC156FECPRO,
             auxAQPC156INSTAN,
             auxAQPC156A,
             auxAQPC156DE,
             auxAQPC156ASUNT,
             auxTextComple,
             auxAQPC156CLIEN,
             auxAQPC156DNI,
             auxAQPC156ANALIS,
             auxAQPC156AGENC,
             auxAQPC156ZONA,
             auxAQPC156REGIO,
             auxAQPC156RATGANA,
             auxAQPC156RATAGEN,
             auxAQPC156SLDCANA,
             auxAQPC156SLDCAGE,
             auxAQPC156SLDCZON,
             auxAQPC156SLDCREG,
             auxAQPC156NCLIANA,
             auxAQPC156NCLIAGE,
             auxAQPC156NCLIZON,
             auxAQPC156NCLIREG,
             auxAQPC156NMORAG,
             auxAQPC156NMORAN,
             auxAQPC156NMORZO,
             auxAQPC156NMOREG,
             auxAQPC156NVRIESG,
             auxAQPC156ACTIVID,
             auxAQPC156PDANA,
             auxAQPC156PDAGE,
             auxAQPC156PDZON,
             auxAQPC156PDREG,
             auxAQPC156COH4ANA,
             auxAQPC156COH4AGE,
             auxAQPC156COH4ZON,
             auxAQPC156COH4REG,
             auxAQPC156COH6ANA,
             auxAQPC156COH6AGE,
             auxAQPC156COH6ZON,
             auxAQPC156COH6REG,
             auxAQPC156SOLIC,
             auxAQPC156CTNRO,
             auxAQPC156CALIF,
             auxAQPC156PRODSBS,
             auxAQPC156FECEEFF,
             auxAQPC156FECINFC,
             0,
             auxAQPC156TIPPRO,
             auxAQPC156RESPTOT,
             v_montoPropu, --auxAQPC156SLDPROP,
             v_modalidPropu, --auxAQPC156MODPRP,
             v_cuotaPropu, --auxcuota,
             v_totCuotPropu, --auxQPC156CUOPRP,
             v_tasaPropu, --auxAQPC156TASPRP,
             auxCodTipSolicitud,
             auxDescTipSolic,
             auxAQPC160USUREG,
             auxAQPC160USUREG,
             auxAQPC160HORRG,
             'P',
             CodNivel,
             auxFlgAnaliCont,
             UsuarioAC, -- MOD RCASTRO 10072023
             UsuarioGA,
             0,
             'N',
             v_correlativo, --2108
             'H',
             v_fechaActual,
             v_tipoCambio,
             v_monedaPropu);
          commit;
          flagGrabad := 'S';
        EXCEPTION
          /*WHEN DUP_VAL_ON_INDEX THEN
          begin
            UPDATE AQPC156
               SET AQPC156RATGANA = auxAQPC156RATGANA,
                   AQPC156RATAGEN = auxAQPC156RATAGEN,
                   AQPC156SLDCANA = auxAQPC156SLDCANA,
                   AQPC156SLDCAGE = auxAQPC156SLDCAGE,
                   AQPC156SLDCZON = auxAQPC156SLDCZON,
                   AQPC156SLDCREG = auxAQPC156SLDCREG,
                   AQPC156NCLIANA = auxAQPC156NCLIANA,
                   AQPC156NCLIAGE = auxAQPC156NCLIAGE,
                   AQPC156NCLIZON = auxAQPC156NCLIZON,
                   AQPC156NCLIREG = auxAQPC156NCLIREG,
                   AQPC156NMORAG  = auxAQPC156NMORAG,
                   AQPC156NMORAN  = auxAQPC156NMORAN,
                   AQPC156NMORZO  = auxAQPC156NMORZO,
                   AQPC156NMOREG  = auxAQPC156NMOREG,
                   AQPC156NVRIESG = auxAQPC156NVRIESG,
                   AQPC156ACTIVID = auxAQPC156ACTIVID,
                   AQPC156PDANA   = auxAQPC156PDANA,
                   AQPC156PDAGE   = auxAQPC156PDAGE,
                   AQPC156PDZON   = auxAQPC156PDZON,
                   AQPC156PDREG   = auxAQPC156PDREG,
                   AQPC156COH4ANA = auxAQPC156COH4ANA,
                   AQPC156COH4AGE = auxAQPC156COH4AGE,
                   AQPC156COH4ZON = auxAQPC156COH4ZON,
                   AQPC156COH4REG = auxAQPC156COH4REG,
                   AQPC156COH6ANA = auxAQPC156COH6ANA,
                   AQPC156COH6AGE = auxAQPC156COH6AGE,
                   AQPC156COH6ZON = auxAQPC156COH6ZON,
                   AQPC156COH6REG = auxAQPC156COH6REG,
                   AQPC156CALIF   = auxAQPC156CALIF,
                   AQPC156TIPPRO  = auxAQPC156TIPPRO
            /*AQPC156SLDPROP     = auxAQPC156SLDPROP,
            AQPC156MODPRP     =  auxAQPC156MODPRP,
            AQPC156CUOTAS     =  auxcuota,
            AQPC156CUOPRP     =  auxQPC156CUOPRP,
            AQPC156TASPRP     =  auxAQPC156TASPRP*/
          /* WHERE AQPC156CODOPI = codOpinionGenerado
               AND AQPC156INSTAN = auxAQPC156INSTAN;
            commit;
          END;*/
          WHEN OTHERS THEN
            NULL;
        END;
      ELSE
        BEGIN
          pq_cr_repo_opinion_riesgos.sp_grab_log_aqpc156(codOpinionGenerado,
                                                         auxAQPC156INSTAN);
        END;
        -- ACTUALIZAMOS DATA 
        begin
          UPDATE AQPC156
             SET AQPC156RATGANA = auxAQPC156RATGANA,
                 AQPC156RATAGEN = auxAQPC156RATAGEN,
                 AQPC156SLDCANA = auxAQPC156SLDCANA,
                 AQPC156SLDCAGE = auxAQPC156SLDCAGE,
                 AQPC156SLDCZON = auxAQPC156SLDCZON,
                 AQPC156SLDCREG = auxAQPC156SLDCREG,
                 AQPC156NCLIANA = auxAQPC156NCLIANA,
                 AQPC156NCLIAGE = auxAQPC156NCLIAGE,
                 AQPC156NCLIZON = auxAQPC156NCLIZON,
                 AQPC156NCLIREG = auxAQPC156NCLIREG,
                 AQPC156NMORAG  = auxAQPC156NMORAG,
                 AQPC156NMORAN  = auxAQPC156NMORAN,
                 AQPC156NMORZO  = auxAQPC156NMORZO,
                 AQPC156NMOREG  = auxAQPC156NMOREG,
                 AQPC156NVRIESG = auxAQPC156NVRIESG,
                 AQPC156ACTIVID = auxAQPC156ACTIVID,
                 AQPC156PDANA   = auxAQPC156PDANA,
                 AQPC156PDAGE   = auxAQPC156PDAGE,
                 AQPC156PDZON   = auxAQPC156PDZON,
                 AQPC156PDREG   = auxAQPC156PDREG,
                 AQPC156COH4ANA = auxAQPC156COH4ANA,
                 AQPC156COH4AGE = auxAQPC156COH4AGE,
                 AQPC156COH4ZON = auxAQPC156COH4ZON,
                 AQPC156COH4REG = auxAQPC156COH4REG,
                 AQPC156COH6ANA = auxAQPC156COH6ANA,
                 AQPC156COH6AGE = auxAQPC156COH6AGE,
                 AQPC156COH6ZON = auxAQPC156COH6ZON,
                 AQPC156COH6REG = auxAQPC156COH6REG,
                 AQPC156CALIF   = auxAQPC156CALIF,
                 AQPC156TIPPRO  = auxAQPC156TIPPRO,
                 AQPC156RESPTOT = auxAQPC156RESPTOT,
                 
                 AQPC156TCAMB = v_tipoCambio,
                 
                 AQPC156SLDPROP = v_montoPropu, --auxAQPC156SLDPROP,
                 AQPC156MODPRP  = v_modalidPropu, --auxAQPC156MODPRP,
                 AQPC156CUOTAS  = v_cuotaPropu, --auxcuota,
                 AQPC156CUOPRP  = v_totCuotPropu, --auxQPC156CUOPRP,
                 AQPC156TASPRP  = v_tasaPropu, --auxAQPC156TASPRP,
                 AQPC156MDAPROP = v_monedaPropu,
                 
                 AQPC156USUREG = UsuarioAC,
                 AQPC156GRAGE  = UsuarioGA
          
           WHERE AQPC156CODOPI = codOpinionGenerado
             AND AQPC156INSTAN = auxAQPC156INSTAN
             AND AQPC156ESTAD = 'H'; --2108
          commit;
        END;
      END IF;
    END IF;
  END;

  procedure sp_actualizar_Datos_Obser156(instancia      number,
                                         codOpinion     number,
                                         txtA           varchar2,
                                         txtDE          varchar2,
                                         txtAsunto      varchar2,
                                         txtTextoAdic   varchar2,
                                         txtAnalista    varchar2,
                                         txtDNI         varchar2,
                                         Actividad      varchar2,
                                         solicitud      number,
                                         productoSBS    varchar2,
                                         fechaEEFF      date,
                                         fechaInfComer  date,
                                         EsReconsiderac varchar2, --txtDestinoCred varchar2, mod rcastro 10072023
                                         NuevoNivel     number,
                                         flgCambiEst    varchar2,
                                         TipoPropu      varchar2) is
  BEGIN
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_grab_log_aqpc156(codOpinion, instancia);
    END;
  
    BEGIN
      UPDATE AQPC156
         SET --AQPC156A       = txtA,
             --AQPC156DE      = txtDE,
               AQPC156ASUNT = txtAsunto, --0308
             --AQPC156TEXCOM  = txtTextoAdic,
             --AQPC156ANALIS  = txtAnalista,
             --AQPC156DNI     = txtDNI,
             AQPC156ACTIVID = Actividad,
             --AQPC156SOLIC   = solicitud, 24072023
             AQPC156PRODSBS = productoSBS, --03082023
             AQPC156FECEEFF = fechaEEFF,
             AQPC156FECINFC = fechaInfComer,
             AQPC156NIVEL   = NuevoNivel,
             AQPC156TIPPRO  = TipoPropu,
             AQPC156ESRECON = EsReconsiderac
       WHERE AQPC156CODOPI = codOpinion
         AND AQPC156ESTAD = 'H'; --2108
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;

  procedure sp_obtn_cred_vig_titu(auxNrOpinion  number,
                                  instancia     number,
                                  cuenta        number,
                                  FechaApertura date,
                                  SumSldVigent  out number) is
    auxCuenta   number(9);
    auxOperac   number(9);
    auxMntOtorg number(17, 2);
    auxTasa     number(17, 6);
    auxSaldo    number(17, 2);
    auxNomCred  varchar2(30);
    auxMeses    number(5);
    auxMoned    number(3);
    auxContCred number(3);
    auxCuota    number(17, 2);
    xflgOk      varchar2(3);
    aux_moned   varchar2(10);
    cuotas_tot  varchar2(30);
  
    x_empresa       number(3);
    x_sucurs        number(4);
    x_moneda        number(4);
    x_papel         number(4);
    x_modulo        number(4);
    x_cuenta        number(9);
    x_operacion     number(9);
    x_suboper       number(4);
    x_tipoOperacion number(4);
    p_cuotPagadas   NUMBER(4);
    p_descPeriodo   VARCHAR(30);
    p_PERIODO       number(5);
  
    --LINEAS
    ln_pgcod117     number;
    ln_modulo117    number;
    ln_sucursal117  number;
    ln_moneda117    number;
    ln_papel117     number;
    ln_cuenta117    number;
    ln_operacion117 number;
    ln_sbop117      number;
    ln_top117       number;
    ln_LineaTotal   number(17, 2) := 0.00;
    ln_LineaUtilzd  number(17, 2) := 0.00;
  
    p_montoOtorgado number(17, 2);
    p_cuota         number(17, 2);
    p_saldof11      number(17, 2);
  
    p_xcar3     varchar2(1);
    f_tipoSolic varchar2(2) := '';
    p_sng001ori number(2);
    p_ppfpag    date;
    p_sldseguro number(17, 2);
  
    ln_cuoimp         number(17, 2);
    ln_cuoseg         number(17, 2);
    ln_totcuoimp      number(17, 2);
    ld_fech_maxcuo    date;
    lc_flag           varchar2(2);
    lc_flagA          varchar2(2);
    lc_flagR          varchar2(2);
    lc_flagConsiderar varchar2(2);
  
    v_tasa         number(15, 6);
    x_count        number(3);
    PromedioAtraso number(17, 2);
  
    flgLineaVinc   varchar2(1);
    auxModeEval    number(3);
    auxInstancia   number(10);
    xflgEsEvalFluj varchar2(1);
  
    Cursor CredVigent is
      SELECT d.PGCOD,
             d.AOMOD,
             d.AOSUC,
             d.AOMDA,
             d.AOPAP,
             d.AOCTA,
             d.AOOPER,
             d.AOSBOP,
             d.AOTOPE,
             d.AOTASA tasa,
             d.AOIMP monto_otorgado,
             (select count(1)
                from fsd601 p
               where p.pgcod = d.pgcod
                 and p.PPMOD = d.aomod
                 and p.PPSUC = d.aosuc
                 and p.PPMDA = d.aomda
                 and p.PPPAP = d.aopap
                 and p.ppcta = d.aocta
                 and p.ppoper = d.aooper
                 and p.ppsbop = d.aosbop
                 and p.PPTOPE = d.aotope
                 and p.d601co = 'S') meses,
             (select d.aomod || '-' || TRIM(mdnom) || ', ' || d.aotope || '-' ||
                     trim(TONOM)
                from fst003 a, fst004 b
               where a.modulo = d.aomod --e.xwfmodulo
                 and b.totope = d.aotope --e.xwftipope
                 and b.modulo = a.MODULO
                 and rownum < 2) credito
        FROM FSD010 d
       where d.pgcod = 1
         and d.aostat <> 99
         and d.aocta in
             (select distinct ctnro
                from fsr008
               where pendoc in (select pendoc
                                  from fsr008
                                 where pgcod = 1
                                   and ctnro = cuenta)
              union
              select distinct ctnro
                from fsr008
               where pendoc in (select K.RPNDOC
                                  from fsr008 M, FSR002 K
                                 where M.PEPAIS = K.PEPAIS
                                   AND M.PETDOC = K.PETDOC
                                   AND M.PENDOC = K.PENDOC
                                   AND M.CTNRO = cuenta
                                   AND M.CTTFIR = 'T'
                                   AND K.RPCCYG = 66)) --18/12/2023
         and (d.aomod in
             (select a.modulo
                 from fst111 a
                where a.dscod = 50
                  and a.modulo not in (120, 29, 144, 33)) or d.aomod = 141); --18/!2/2023  
  
  BEGIN
    auxContCred := 0;
  
    BEGIN
      -- 2108 VIG
      UPDATE AQPC160
         SET AQPC160ESTAD = 'I'
       WHERE AQPC160CODOPI = auxNrOpinion
         AND (AQPC160ESTAD = 'H' OR AQPC160ESTAD IS NULL);
      --DELETE FROM AQPC160 WHERE AQPC160CODOPI = auxNrOpinion;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    xflgEsEvalFluj := 'N';
  
    BEGIN
      -- validar si tiene evaluación por flujo 
      pq_cr_ratio_evalflujo.sp_cr_verfevalflujo(instancia, xflgEsEvalFluj);
    EXCEPTION
      WHEN OTHERS THEN
        xflgEsEvalFluj := 'N';
    END;
  
    --SumSldVigent := 0;
  
    FOR XR in CredVigent LOOP
      f_tipoSolic  := ''; --mod 24072023
      flgLineaVinc := 'N'; --mod 24072023 
    
      IF xr.aomda = 0 THEN
        aux_moned := 'S/.';
      END IF;
    
      IF xr.aomda = 101 THEN
        aux_moned := 'USD';
      END IF;
      --TASA
      v_tasa := 0;
      BEGIN
        SELECT EVTASA
          INTO v_tasa
          FROM FSD012 E
         WHERE E.PGCOD = xr.pgcod
           AND E.AOMOD = xr.aomod
           AND E.AOSUC = xr.aosuc
           AND E.AOMDA = xr.aomda
           AND E.AOPAP = xr.aopap
           AND E.AOCTA = xr.aocta
           AND E.AOOPER = xr.aooper
           AND E.AOSBOP = xr.aosbop
           AND E.AOTOPE = xr.aotope
           AND E.EVTIPO = 3
           AND E.D012CO = 'S'
           AND E.EVFVAL = (select max(E.EVFVAL)
                             from FSD012 E
                            WHERE E.PGCOD = xr.pgcod
                              AND E.AOMOD = xr.aomod
                              AND E.AOSUC = xr.aosuc
                              AND E.AOMDA = xr.aomda
                              AND E.AOPAP = xr.aopap
                              AND E.AOCTA = xr.aocta
                              AND E.AOOPER = xr.aooper
                              AND E.AOSBOP = xr.aosbop
                              AND E.AOTOPE = xr.aotope
                              AND E.EVTIPO = 3
                              AND E.D012CO = 'S');
      EXCEPTION
        WHEN OTHERS THEN
          v_tasa := 0;
      END;
    
      IF v_tasa IS NULL THEN
        v_tasa := 0;
      END IF;
    
      IF v_tasa = 0 then
        v_tasa := xr.tasa;
      END IF;
    
      auxModeEval := 0;
      P_CUOTA     := 0;
    
      IF xflgEsEvalFluj = 'N' THEN
      
        BEGIN
          SELECT SNG021TMOD
            INTO auxModeEval
            FROM sng021
           WHERE SNG021SOL = instancia;
        EXCEPTION
          WHEN OTHERS THEN
            auxModeEval := 0;
        END;
      
        IF auxModeEval = 13 THEN
        
          BEGIN
            SELECT R.JAQY142CAPCUO
              INTO P_CUOTA
              FROM JAQY142 R
             WHERE R.JAQY142INST = instancia
               AND R.JAQY142PGCOD = XR.PGCOD
               AND R.JAQY142MOD = XR.AOMOD
               AND R.JAQY142SUC = XR.AOSUC
               AND R.JAQY142MDA = XR.AOMDA
               AND R.JAQY142PAP = XR.AOPAP
               AND R.JAQY142CTA = XR.AOCTA
               AND R.JAQY142OPE = XR.AOOPER
               AND R.JAQY142SBOP = XR.AOSBOP
               AND R.JAQY142TOPE = XR.AOTOPE
               AND R.JAQY142EST = 'H'
               AND R.JAQY142TAREA = 7 --26072023
               AND ROWNUM < 2;
          EXCEPTION
            WHEN OTHERS THEN
              P_CUOTA := 0;
          END;
        ELSE
          IF auxModeEval = 14 THEN
            BEGIN
              SELECT K.JAQZ822CAPCUO
                INTO P_CUOTA
                FROM jaqz822 K
               WHERE K.JAQZ822INST = instancia
                 AND K.JAQZ822PGCOD = XR.PGCOD
                 AND K.JAQZ822MOD = XR.AOMOD
                 AND K.JAQZ822SUC = XR.AOSUC
                 AND K.JAQZ822MDA = XR.AOMDA
                 AND K.JAQZ822PAP = XR.AOPAP
                 AND K.JAQZ822CTA = XR.AOCTA
                 AND K.JAQZ822OPE = XR.AOOPER
                 AND K.JAQZ822SBOP = XR.AOSBOP
                 AND K.JAQZ822TOPE = XR.AOTOPE
                 AND K.JAQZ822EST = 'H'
                 AND K.JAQZ822TAREA = 7
                 AND ROWNUM < 2;
            EXCEPTION
              WHEN OTHERS THEN
                P_CUOTA := 0;
            END;
          END IF;
        END IF;
      ELSE
        IF xflgEsEvalFluj = 'S' THEN
          BEGIN
            pq_cr_resolutor_cappago.sp_cr_maxcuotppago(xr.pgcod,
                                                       xr.aomod,
                                                       xr.aosuc,
                                                       xr.aomda,
                                                       xr.aopap,
                                                       xr.aocta,
                                                       xr.aooper,
                                                       xr.aosbop,
                                                       xr.aotope,
                                                       1,
                                                       p_cuota);
          EXCEPTION
            WHEN OTHERS THEN
              p_cuota := 0;
          END;
        END IF;
      END IF;
    
      IF p_cuota = 0 OR p_cuota is null THEN
        --0108
        BEGIN
          pq_cr_resolutor_cappago.sp_cr_maxcuotppago(xr.pgcod,
                                                     xr.aomod,
                                                     xr.aosuc,
                                                     xr.aomda,
                                                     xr.aopap,
                                                     xr.aocta,
                                                     xr.aooper,
                                                     xr.aosbop,
                                                     xr.aotope,
                                                     1,
                                                     p_cuota);
        EXCEPTION
          WHEN OTHERS THEN
            p_cuota := 0;
        END;
      END IF;
    
      --saldo
      BEGIN
        SELECT (g.scsdo) saldo
          INTO p_saldof11
          FROM FSD011 G
         WHERE g.pgcod = xr.pgcod
           AND g.scsuc = xr.aosuc
           AND g.scmod = xr.aomod
           AND g.scmda = xr.aomda
           AND g.scpap = xr.aopap
           AND g.sccta = xr.aocta
           AND g.scoper = xr.aooper
           AND g.scsbop = xr.aosbop
           AND g.sctope = xr.aotope;
      EXCEPTION
        WHEN OTHERS THEN
          p_saldof11 := 0;
      END;
    
      if p_saldof11 < 0 then
        --18/12/2023
        p_saldof11 := p_saldof11 * (-1);
      End If;
    
      --cant cuotas pagdas
      p_cuotPagadas := 0;
      BEGIN
        SELECT count(1)
          INTO p_cuotPagadas
          FROM FSD601 B
         INNER JOIN FSD602 C
            ON B.PGCOD = C.PGCOD
           AND B.PPMOD = C.PPMOD
           AND B.PPSUC = C.PPSUC
           AND B.PPMDA = C.PPMDA
           AND B.PPPAP = C.PPPAP
           AND B.PPCTA = C.PPCTA
           AND B.PPOPER = C.PPOPER
           AND B.PPSBOP = C.PPSBOP
           AND B.PPTOPE = C.PPTOPE
           AND B.PPFPAG = C.PPFPAG
           AND B.PPTIPO = C.PPTIPO
         WHERE C.D602co = 'S'
           AND C.Pp1stat = 'T'
           AND B.PGCOD = xr.pgcod
           AND B.PPMOD = xr.aomod
           AND B.PPSUC = xr.aosuc
           AND B.PPMDA = xr.aomda
           AND B.PPPAP = xr.aopap
           AND B.PPCTA = xr.aocta
           AND B.PPOPER = xr.aooper
           AND B.PPSBOP = xr.aosbop
           AND B.PPTOPE = xr.aotope;
      EXCEPTION
        WHEN OTHERS THEN
          p_cuotPagadas := 0;
      END;
    
      -- Promedio Dias Atraso 6 meses
      PromedioAtraso := 0;
      IF xr.aomod <> 141 THEN
        --18/12/2023
        BEGIN
          pq_cr_central.sp_6meses(xr.pgcod,
                                  xr.aomod,
                                  xr.aosuc,
                                  xr.aomda,
                                  xr.aopap,
                                  xr.aocta,
                                  xr.aooper,
                                  xr.aosbop,
                                  xr.aotope,
                                  FechaApertura,
                                  PromedioAtraso);
        EXCEPTION
          WHEN OTHERS THEN
            PromedioAtraso := 0;
        END;
      END IF;
    
      --periodo
      BEGIN
        SELECT XLLPERIODO
          INTO p_PERIODO
          FROM x054023
         WHERE XLLPGCOD = xr.pgcod
           AND XLLAOMOD = xr.aomod
           AND XLLAOSUC = xr.aosuc
           AND XLLAOMDA = xr.aomda
           AND XLLAOPAP = xr.aopap
           AND XLLAOCTA = xr.aocta
           AND XLLAOOPER = xr.aooper
           AND XLLAOSBOP = xr.aosbop
           AND XLLAOTOP = xr.aotope;
      EXCEPTION
        WHEN OTHERS THEN
          p_PERIODO := 0;
      END;
    
      --descripcion periodo
      BEGIN
        SELECT TP1DESC
          INTO p_descPeriodo
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11152
           and tp1corr1 = 13
           AND TP1CORR3 > 0
           AND TP1NRO1 = p_PERIODO;
      EXCEPTION
        WHEN OTHERS THEN
          p_descPeriodo := '';
      END;
    
      p_montoOtorgado := xr.monto_otorgado;
    
      --PARA SALDOS DE LINEA             
      IF xr.aomod = 116 or xr.aomod = 117 THEN
        begin
          select r2cod,
                 r2mod,
                 r2suc,
                 r2mda,
                 r2pap,
                 r2cta,
                 r2oper,
                 r2sbop,
                 r2tope
            into ln_pgcod117,
                 ln_modulo117,
                 ln_sucursal117,
                 ln_moneda117,
                 ln_papel117,
                 ln_cuenta117,
                 ln_operacion117,
                 ln_sbop117,
                 ln_top117
            from fsr011 f
           where f.r1cod = xr.pgcod
             and f.r1mod = xr.aomod
             and f.r1suc = xr.aosuc
             and f.r1cta = xr.aocta
             and f.r1oper = xr.aooper
             and f.r1sbop = xr.aosbop
             and f.r1mda = xr.aomda
             and f.r1pap = xr.aopap
             and f.r1tope = xr.aotope
             and f.relcod = 46;
        exception
          when others then
            ln_pgcod117     := 0;
            ln_modulo117    := 0;
            ln_sucursal117  := 0;
            ln_moneda117    := 0;
            ln_papel117     := 0;
            ln_cuenta117    := 0;
            ln_operacion117 := 0;
            ln_sbop117      := 0;
            ln_top117       := 0;
        end;
      
        if ln_modulo117 > 0 then
          begin
            select f.scsdo
              into ln_LineaTotal
              from fsd011 f
             where f.pgcod = ln_pgcod117
               and f.scsuc = ln_sucursal117
               and f.scmda = ln_moneda117
               and f.scpap = ln_papel117
               and f.sccta = ln_cuenta117
               and f.scoper = ln_operacion117
               and f.scsbop = ln_sbop117
               and f.sctope = ln_top117
               and f.scmod = ln_modulo117;
          exception
            when others then
              ln_LineaTotal := 0.00;
          end;
        end if;
      
        begin
          select f.scsdo
            into ln_LineaUtilzd
            from fsd011 f
           where f.pgcod = xr.pgcod
             and f.scmod = xr.aomod
             and f.scsuc = xr.aosuc
             and f.scmda = xr.aomda
             and f.scpap = xr.aopap
             and f.sccta = xr.aocta
             and f.scoper = xr.aooper
             and f.scsbop = xr.aosbop
             and f.sctope = xr.aotope;
        exception
          when others then
            ln_LineaUtilzd := 0.00;
        end;
      
        if ln_LineaUtilzd < 0 then
          --18/12/2023
          ln_LineaUtilzd := ln_LineaUtilzd * (-1);
        end if;
      
        p_saldof11      := ln_LineaUtilzd;
        p_montoOtorgado := ln_LineaTotal;
      
      END IF;
    
      flgLineaVinc := 'N'; --validación de vinculación de linea  -- Ini mod 30/06/2023
      BEGIN
        pq_cr_resolutor_cappago.sp_cr_VerVincLinea(xr.aomod,
                                                   xr.aosuc,
                                                   xr.aomda,
                                                   xr.aopap,
                                                   xr.aocta,
                                                   xr.aooper,
                                                   xr.aosbop,
                                                   xr.aotope,
                                                   flgLineaVinc);
      EXCEPTION
        WHEN OTHERS THEN
          flgLineaVinc := 'N';
      END; --Fin mod 30/06/2023        
    
      -- END IF;
    
      ---        
      if xr.aomod <> 141 then
        --18/12/2023        
        cuotas_tot := p_cuotPagadas || '/' || xr.meses || ' cuo. ' ||
                      trim(p_descPeriodo);
        cuotas_tot := trim(cuotas_tot);
      ELSE
        p_cuota    := 0;
        cuotas_tot := '0';
        v_tasa     := 0;
      END IF;
    
      f_tipoSolic := 'N';
      --ampliaciones en linea
      BEGIN
        pq_cr_resolutor_cappago.Sp_ampliados_CK(xr.pgcod,
                                                xr.aomod,
                                                xr.aosuc,
                                                xr.aomda,
                                                xr.aopap,
                                                xr.aocta,
                                                xr.aooper,
                                                xr.aosbop,
                                                xr.aotope,
                                                lc_flagA);
      EXCEPTION
        WHEN OTHERS THEN
          lc_flagA := 'N';
      END;
    
      IF lc_flagA = 'S' THEN
        f_tipoSolic := 'A';
      else
        IF lc_flagA = 'N' THEN
          --refinanciaciones y repogramaciones en linea
          BEGIN
            pq_cr_resolutor_cappago.sp_refinanLinea(xr.pgcod,
                                                    xr.aomod,
                                                    xr.aosuc,
                                                    xr.aomda,
                                                    xr.aopap,
                                                    xr.aocta,
                                                    xr.aooper,
                                                    lc_flagR);
          EXCEPTION
            WHEN OTHERS THEN
              lc_flagR := 'N';
          END;
        
          IF lc_flagR = 'S' THEN
            --para reprogramacion y refinanciacion mismo flag
            f_tipoSolic := 'RF';
          else
            f_tipoSolic := 'N';
          END IF;
        END IF;
      END IF;
      -- END IF;
    
      IF flgLineaVinc = 'S' THEN
        -- si existe vinculación de lineas  mod 30/06/2023
        f_tipoSolic := 'V';
      END IF;
    
      --insert aqpc160
      pq_cr_repo_opinion_riesgos.sp_insert_aqpc160(auxNrOpinion,
                                                   FechaApertura,
                                                   p_saldof11, --xr.saldo,
                                                   xr.credito,
                                                   p_montoOtorgado, --xr.monto_otorgado,
                                                   p_cuota, --xr.cuota,
                                                   cuotas_tot,
                                                   v_tasa,
                                                   aux_moned,
                                                   f_tipoSolic,
                                                   PromedioAtraso,
                                                   xr.pgcod,
                                                   xr.aosuc,
                                                   xr.aomod,
                                                   xr.aomda,
                                                   xr.aopap,
                                                   xr.aocta,
                                                   xr.aooper,
                                                   xr.aosbop,
                                                   xr.aotope,
                                                   xflgOk);
    
    END LOOP;
  
  end;

  procedure sp_obtn_cadena_caracter(texto1      varchar2,
                                    texto2      varchar2,
                                    texto3      varchar2,
                                    texto4      varchar2,
                                    texto5      varchar2,
                                    texto6      varchar2,
                                    nrocred     number,
                                    texto7      varchar2,
                                    saldoCrVig  out number,
                                    auxModali   out varchar2,
                                    cuot_tot    out number,
                                    tasaCrVig   out number,
                                    montoOtorga out number,
                                    moneda      out number,
                                    valcuota    out number) is
    nro      number(3);
    posicion number(4);
    pos      varchar2(4);
    Dato1    varchar2(4000);
  BEGIN
    BEGIN
      SELECT instr(texto1, ';', 1, nrocred) INTO posicion FROM DUAL;
    EXCEPTION
      WHEN others THEN
        NULL;
    END;
    /*  Dato1      := substr(texto1, 1, posicion - 1);--replace(substr(texto1, 1, posicion - 1), '.', ',');
    saldoCrVig := to_number(Dato1);
    
    BEGIN
      SELECT instr(texto2, ';', 1, nrocred) INTO posicion FROM DUAL;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END; */
    -- posicion := to_number(instr(texto2,';', 1,nrocred - 1));
    Dato1     := substr(texto2, 1, posicion - 1);
    auxModali := Dato1;
  
    BEGIN
      SELECT instr(texto3, ';', 1, nrocred) INTO posicion FROM DUAL;
    EXCEPTION
      WHEN others THEN
        NULL;
    END;
    --posicion := to_number(instr(texto3,';', 1,nrocred - 1));
    Dato1 := substr(texto3, 1, posicion - 1);
    --cuot_tot := to_number(Dato1);
  
    BEGIN
      SELECT instr(texto4, ';', 1, nrocred) INTO posicion FROM DUAL;
    EXCEPTION
      WHEN others THEN
        NULL;
    END;
    --posicion := to_number(instr(texto4,';', 1,nrocred - 1));
    Dato1     := substr(texto4, 1, posicion - 1);
    tasaCrVig := to_number(Dato1);
  
    BEGIN
      SELECT instr(texto5, ';', 1, nrocred) INTO posicion FROM DUAL;
    EXCEPTION
      WHEN others THEN
        NULL;
    END;
    -- posicion := to_number(instr(texto5,';', 1,nrocred - 1));
    Dato1 := substr(texto5, 1, posicion - 1);
    --montoOtorga := to_number(Dato1);
  
    BEGIN
      SELECT instr(texto6, ';', 1, nrocred) INTO posicion FROM DUAL;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END;
    -- posicion := to_number(instr(texto6,';', 1,nrocred - 1));
    Dato1  := substr(texto6, 1, posicion - 1);
    moneda := to_number(Dato1);
  
    BEGIN
      SELECT instr(texto7, ';', 1, nrocred) INTO posicion FROM DUAL;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END;
    -- posicion := to_number(instr(texto7,';', 1,nrocred - 1));
    Dato1    := substr(texto7, 1, posicion - 1);
    valcuota := to_number(Dato1);
  
  END;

  procedure sp_insert_aqpc160(codOpinion      number,
                              XAQPC160FECPRO  date,
                              xAQPC160SLDVIG  NUMBER,
                              XAQPC160MODVIG  varchar2,
                              xMontOtorg      number,
                              xcuota          number,
                              XAQPC160CUOVIG  varchar2,
                              XAQPC160TASAVIG NUMBER,
                              xMoneda         varchar2,
                              f_tipoSolic     VARCHAR2,
                              xPromedioAtraso number,
                              p_empresa       NUMBER,
                              p_sucursal      NUMBER,
                              p_modulo        NUMBER,
                              p_moned         NUMBER,
                              p_papel         NUMBER,
                              p_cuenta        NUMBER,
                              p_operacion     NUMBER,
                              p_suboper       NUMBER,
                              p_tipoper       NUMBER,
                              flgOK           out varchar2) IS
    auxCorr       number(10);
    v_HoraActual  VARCHAR2(8);
    v_FechaActual DATE;
  BEGIN
    IF codOpinion > 0 THEN
      v_HoraActual := TO_CHAR(SYSDATE, 'HH24:MI:SS');
      --v_FechaActual := TO_DATE(SYSDATE, 'dd/mm/rrrr');
    
      BEGIN
        SELECT MAX(AQPC160CORR)
          INTO auxCorr
          FROM AQPC160
         WHERE AQPC160CODOPI = codOpinion;
      EXCEPTION
        WHEN OTHERS THEN
          auxCorr := 0;
      END;
      IF auxCorr IS NULL THEN
        auxCorr := 0;
      END IF;
      auxCorr := auxCorr + 1;
    
      BEGIN
        INSERT INTO AQPC160
          (AQPC160CODOPI,
           AQPC160CORR,
           AQPC160FECPRO,
           AQPC160SLDVIG,
           AQPC160MODVIG,
           AQPC160MNTOTG,
           AQPC160CUOTG,
           AQPC160CUOVIG,
           AQPC160TASAVIG,
           AQPC160MONDCR,
           AQPC160TIPSOL,
           AQPC160PRMATRA,
           AQPC160HORAREG,
           AQPC160EMP,
           AQPC160SUC,
           AQPC160MODU,
           AQPC160MDA,
           AQPC160PAP,
           AQPC160CTA,
           AQPC160OPER,
           AQPC160SBOP,
           AQPC160TOPE,
           AQPC160ESTAD) --2108
        VALUES
          (codOpinion,
           auxCorr,
           xAQPC160FECPRO,
           xAQPC160SLDVIG,
           XAQPC160MODVIG,
           xMontOtorg,
           xcuota,
           XAQPC160CUOVIG,
           XAQPC160TASAVIG,
           xMoneda,
           f_tipoSolic,
           xPromedioAtraso,
           v_HoraActual,
           p_empresa,
           p_sucursal,
           p_modulo,
           p_moned,
           p_papel,
           p_cuenta,
           p_operacion,
           p_suboper,
           p_tipoper,
           'H');
        COMMIT;
        flgOK := 'S';
      EXCEPTION
        WHEN OTHERS THEN
          flgOK := 'N';
      END;
    END IF;
  END;

  procedure sp_insert_detalle_aqpc157(p_AQPC157CODOPI number,
                                      
                                      p_AQPC157Afeere  date,
                                      p_AQPC157Afeean  date,
                                      p_AQPC157AacMda1 varchar2,
                                      p_AQPC157AacrDis number,
                                      p_AQPC157AarvDis number,
                                      p_AQPC157AacaDis number,
                                      p_AQPC157AaavDis number,
                                      p_AQPC157AaaHDis number,
                                      
                                      p_AQPC157AacMda2 varchar2,
                                      p_AQPC157AacrCxC number,
                                      p_AQPC157AarvCxC number,
                                      p_AQPC157AacaCxC number,
                                      p_AQPC157AaavCxC number,
                                      p_AQPC157AaaHCxC number,
                                      
                                      p_AQPC157AacMda3 varchar2,
                                      p_AQPC157AacrMer number,
                                      p_AQPC157AarvMer number,
                                      p_AQPC157AacaMer number,
                                      p_AQPC157AaavMer number,
                                      p_AQPC157AaaHMer number,
                                      
                                      p_AQPC157AacMda4 varchar2,
                                      p_AQPC157Aacrgap number,
                                      p_AQPC157Aarvgap number,
                                      p_AQPC157Aacagap number,
                                      p_AQPC157Aaavgap number,
                                      p_AQPC157AaaHgap number,
                                      
                                      p_AQPC157AacMda5 varchar2,
                                      p_AQPC157AacrExr number,
                                      p_AQPC157AarvExr number,
                                      p_AQPC157AacaExr number,
                                      p_AQPC157AaavExr number,
                                      p_AQPC157AaaHExr number,
                                      
                                      p_AQPC157AacMda6 varchar2,
                                      p_AQPC157AacrOt1 number,
                                      p_AQPC157AarvOt1 number,
                                      p_AQPC157AacaOt1 number,
                                      p_AQPC157AaavOt1 number,
                                      p_AQPC157AaaHOt1 number,
                                      
                                      p_AQPC157AacMda7 varchar2,
                                      p_AQPC157AacrTac number,
                                      p_AQPC157AacaTac number,
                                      p_AQPC157AarvTac number,
                                      p_AQPC157AaavTac number,
                                      p_AQPC157AaaHTac number,
                                      
                                      p_AQPC157AacMda8 varchar2,
                                      p_AQPC157Aacrmue number,
                                      p_AQPC157Aacamue number,
                                      p_AQPC157Aarvmue number,
                                      p_AQPC157Aaavmue number,
                                      p_AQPC157AaaHmue number,
                                      
                                      p_AQPC157AacMda9 varchar2,
                                      p_AQPC157Aacrinm number,
                                      p_AQPC157Aacainm number,
                                      p_AQPC157Aarvinm number,
                                      p_AQPC157Aaavinm number,
                                      p_AQPC157AaaHinm number,
                                      
                                      p_AQPC157AacMd10 varchar2,
                                      p_AQPC157AACRot2 number,
                                      p_AQPC157AARVot2 number,
                                      p_AQPC157AACAot2 number,
                                      p_AQPC157AAAVot2 number,
                                      p_AQPC157AAAHot2 number,
                                      
                                      p_AQPC157AacMd11 varchar2,
                                      p_AQPC157Aacrtaf number,
                                      p_AQPC157Aacataf number,
                                      p_AQPC157Aaavtaf number,
                                      p_AQPC157AaaHtaf number,
                                      p_AQPC157Aarvrta number,
                                      
                                      p_AQPC157AacMd12 varchar2,
                                      p_AQPC157AacrTat number,
                                      p_AQPC157AacaTat number,
                                      p_AQPC157AarvTat number,
                                      p_AQPC157AaavTat number,
                                      p_AQPC157AaaHTat number,
                                      --pasivos
                                      p_AQPC157AacMd13 varchar2,
                                      p_AQPC157APrcxpC number,
                                      p_AQPC157APRVCxp number,
                                      p_AQPC157APAcxpC number,
                                      p_AQPC157APAVCxp number,
                                      p_AQPC157APAHCxp number,
                                      
                                      p_AQPC157AacMd14 varchar2,
                                      p_AQPC157APRCXPB number,
                                      p_AQPC157APRVXPB number,
                                      p_AQPC157APACXPB number,
                                      p_AQPC157APAVXPB number,
                                      p_AQPC157APAHXPB number,
                                      
                                      p_AQPC157AacMd15 varchar2,
                                      p_AQPC157APRTXP  number,
                                      p_AQPC157APATXP  number,
                                      p_AQPC157APRVTXP number,
                                      p_AQPC157APAVTXP number,
                                      p_AQPC157APAHTXP number,
                                      
                                      p_AQPC157AacMd16 varchar2,
                                      p_AQPC157APROTR1 number,
                                      p_AQPC157APAOTR1 number,
                                      p_AQPC157APAVOT1 number,
                                      p_AQPC157APAHOT1 number,
                                      p_AQPC157APRVOT1 number,
                                      
                                      p_AQPC157AacMd17 varchar2,
                                      p_AQPC157APRTPCR number,
                                      p_AQPC157APRVTPC number,
                                      p_AQPC157APATPCR number,
                                      p_AQPC157APAVTPC number,
                                      p_AQPC157APAHTPC number,
                                      
                                      p_AQPC157AacMd18 varchar2,
                                      p_AQPC157APRCXLP number,
                                      p_AQPC157APRVCXL number,
                                      p_AQPC157APACXLP number,
                                      p_AQPC157APAVCXL number,
                                      p_AQPC157APAHCXL number,
                                      
                                      p_AQPC157AacMd19 varchar2,
                                      p_AQPC157APRBST  number,
                                      p_AQPC157APRVBST number,
                                      p_AQPC157APABST  number,
                                      p_AQPC157APAVBST number,
                                      p_AQPC157APAHBST number,
                                      
                                      p_AQPC157AacMd20 varchar2,
                                      p_AQPC157APROTR2 number,
                                      p_AQPC157APRVOT2 number,
                                      p_AQPC157APAOTR2 number,
                                      p_AQPC157APAVOT2 number,
                                      p_AQPC157APAHOT2 number,
                                      
                                      p_AQPC157AacMd21 varchar2,
                                      p_AQPC157APRPNCO number,
                                      p_AQPC157APRVPNC number,
                                      p_AQPC157APAPNCO number,
                                      p_AQPC157APAVPNC number,
                                      p_AQPC157APAHPNC number,
                                      
                                      p_AQPC157AacMd22 varchar2,
                                      p_AQPC157APRTTPA number,
                                      p_AQPC157APRVTTP number,
                                      p_AQPC157APATTPA number,
                                      p_AQPC157APAVTTP number,
                                      p_AQPC157APAHTTP number,
                                      
                                      p_AQPC157AacMd23 varchar2,
                                      p_AQPC157APRCAP  number,
                                      p_AQPC157APRVCAP number,
                                      p_AQPC157APACAP  number,
                                      p_AQPC157APAVCAP number,
                                      p_AQPC157APAHCAP number,
                                      
                                      p_AQPC157AacMd24 varchar2,
                                      p_AQPC157APRRESE number,
                                      p_AQPC157APRVRES number,
                                      p_AQPC157APARESE number,
                                      p_AQPC157APAVRES number,
                                      p_AQPC157APAHRES number,
                                      
                                      p_AQPC157AacMd25 varchar2,
                                      p_AQPC157APRREAC number,
                                      p_AQPC157APRVREA number,
                                      p_AQPC157APAREAC number,
                                      p_AQPC157APAVREA number,
                                      p_AQPC157APAHREA number,
                                      
                                      p_AQPC157AacMd26 varchar2,
                                      p_AQPC157APRRDEJ number,
                                      p_AQPC157APRVRDE number,
                                      p_AQPC157APAVRDE number,
                                      p_AQPC157APARDEJ number,
                                      p_AQPC157APAHRDE number,
                                      
                                      p_AQPC157AacMd27 varchar2,
                                      p_AQPC157APROTR3 number,
                                      p_AQPC157APRVOT3 number,
                                      p_AQPC157APAOTR3 number,
                                      p_AQPC157APAVOT3 number,
                                      p_AQPC157APAHOT3 number,
                                      
                                      p_AQPC157AacMd28 varchar2,
                                      p_AQPC157APRPATR number,
                                      p_AQPC157APRVPAT number,
                                      p_AQPC157APAPATR number,
                                      p_AQPC157APAVPAT number,
                                      p_AQPC157APAHPAT number,
                                      
                                      p_AQPC157AacMd29 varchar2,
                                      p_AQPC157APRTTPP number,
                                      p_AQPC157APRVTPP number,
                                      p_AQPC157APATTPP number,
                                      p_AQPC157APAVTPP number,
                                      p_AQPC157APAHTPP number,
                                      
                                      --ventas
                                      p_AQPC157AacMd30 varchar2,
                                      p_AQPC157AVRVEN  number,
                                      p_AQPC157AVRVVEN number,
                                      p_AQPC157AVAVEN  number,
                                      p_AQPC157AVAVVEN number,
                                      p_AQPC157AVAHVEN number,
                                      
                                      p_AQPC157AacMd31 varchar2,
                                      p_AQPC157AVRCOSV number,
                                      p_AQPC157AVRVCSV number,
                                      p_AQPC157AVACOSV number,
                                      p_AQPC157AVAVCSV number,
                                      p_AQPC157AVHCOSV number,
                                      
                                      p_AQPC157AacMd32 varchar2,
                                      p_AQPC157AVRUBR  number,
                                      p_AQPC157AVRVUBR number,
                                      p_AQPC157AVAUBR  number,
                                      p_AQPC157AVAVUBR number,
                                      p_AQPC157AVHUBR  number,
                                      
                                      p_AQPC157AacMd33 varchar2,
                                      p_AQPC157AVRCOOP number,
                                      p_AQPC157AVRVCOP number,
                                      p_AQPC157AVACOOP number,
                                      p_AQPC157AVAVCOP number,
                                      p_AQPC157AVHCOOP number,
                                      
                                      p_AQPC157AacMd34 varchar2,
                                      p_AQPC157AVRSDOI number,
                                      p_AQPC157AVRVSDO number,
                                      p_AQPC157AVASDOI number,
                                      p_AQPC157AVAVSDO number,
                                      p_AQPC157AVHSDOI number,
                                      
                                      p_AQPC157AacMd35 varchar2,
                                      p_AQPC157AVRSDV  number,
                                      p_AQPC157AVRVSD  number,
                                      p_AQPC157AVASDV  number,
                                      p_AQPC157AVAVSDV number,
                                      p_AQPC157AVHSDV  number,
                                      
                                      p_AQPC157AacMd36 varchar2,
                                      p_AQPC157AVRIMP  number,
                                      p_AQPC157AVRVIMP number,
                                      p_AQPC157AVAIMP  number,
                                      p_AQPC157AVAVIMP number,
                                      p_AQPC157AVHIMP  number,
                                      
                                      p_AQPC157AacMd37 varchar2,
                                      p_AQPC157AVROTC  number,
                                      p_AQPC157AVRVOTC number,
                                      p_AQPC157AVAOTC  number,
                                      p_AQPC157AVAVOTC number,
                                      p_AQPC157AVHOTC  number,
                                      
                                      p_AQPC157AacMd38 varchar2,
                                      p_AQPC157AVRRESE number,
                                      p_AQPC157AVRVRES number,
                                      p_AQPC157AVARESE number,
                                      p_AQPC157AVAVRES number,
                                      p_AQPC157AVHRESE number,
                                      
                                      p_AQPC157AacMd39 varchar2,
                                      p_AQPC157AVROTI  number,
                                      p_AQPC157AVRVOTI number,
                                      p_AQPC157AVAOTI  number,
                                      p_AQPC157AVAVOTI number,
                                      p_AQPC157AVHOTI  number,
                                      
                                      p_AQPC157AacMd40 varchar2,
                                      p_AQPC157AVRGFM  number,
                                      p_AQPC157AVRVGFM number,
                                      p_AQPC157AVAGFM  number,
                                      p_AQPC157AVAVGFM number,
                                      p_AQPC157AVHGFM  number,
                                      
                                      p_AQPC157AacMd41 varchar2,
                                      p_AQPC157AVRRSCP number,
                                      p_AQPC157AVRVRSC number,
                                      p_AQPC157AVARSCP number,
                                      p_AQPC157AVAVRSC number,
                                      p_AQPC157AVHRSCP number,
                                      
                                      p_AQPC157AacMd42 varchar2,
                                      p_AQPC157AVRMCCP number,
                                      p_AQPC157AVRVMCP number,
                                      p_AQPC157AVAMCCP number,
                                      p_AQPC157AVAVMCC number,
                                      p_AQPC157AVHMCCP number,
                                      
                                      p_AQPC157AacMd43 varchar2,
                                      p_AQPC157AVRRNET number,
                                      p_AQPC157AVRVRNT number,
                                      p_AQPC157AVARNET number,
                                      p_AQPC157AVAVRNE number,
                                      p_AQPC157AVHRNET number,
                                      
                                      --MACEM
                                      p_AQPC157MPMNP  varchar2,
                                      p_AQPC157MPSLDV varchar2,
                                      p_AQPC157MPSLCO varchar2,
                                      p_AQPC157MMFUD1 varchar2,
                                      p_AQPC157MMCR1  varchar2,
                                      p_AQPC157MMMCM1 varchar2,
                                      p_AQPC157MMFUD2 varchar2,
                                      p_AQPC157MMCR2  varchar2,
                                      p_AQPC157MMMCM2 varchar2,
                                      
                                      --ratios   
                                      p_AQPC157ARTLIQ1 varchar2,
                                      p_AQPC157ARTRCX1 varchar2,
                                      p_AQPC157ATRRDI1 varchar2,
                                      p_AQPC157ATREND1 varchar2,
                                      p_AQPC157ATRROE1 varchar2,
                                      p_AQPC157ATRRCR1 varchar2,
                                      
                                      p_AQPC157ARTLIQ2 varchar2,
                                      p_AQPC157ARTRCX2 varchar2,
                                      p_AQPC157ATRRDI2 varchar2,
                                      p_AQPC157ATREND2 varchar2,
                                      p_AQPC157ATRROE2 varchar2,
                                      p_AQPC157ATRRCR2 varchar2,
                                      p_AQPC157ACTCONT varchar2,
                                      
                                      p_aqpc157aacmd44 varchar2,
                                      p_aqpc157avcruto number,
                                      p_aqpc157avcauto number,
                                      p_aqpc157avrvuto number,
                                      p_aqpc157avavuto number,
                                      p_aqpc157avahuto number,
                                      
                                      p_aqpc157aacmd45 varchar2,
                                      p_aqpc157avrrgfi number,
                                      p_aqpc157avargfi number,
                                      p_aqpc157avrvgfi number,
                                      p_aqpc157avavgfi number,
                                      p_aqpc157avhrgfi number,
                                      
                                      p_aqpc157aacmd46 varchar2,
                                      p_aqpc157avrrigf number,
                                      p_aqpc157avarigf number,
                                      p_aqpc157avrvigf number,
                                      p_aqpc157avavigf number,
                                      p_aqpc157avhrigf number,
                                      
                                      p_aqpc157aacmd47 varchar2,
                                      p_aqpc157avrrgdi number,
                                      p_aqpc157avargdi number,
                                      p_aqpc157avrvgdi number,
                                      p_aqpc157avavgdi number,
                                      p_aqpc157avhrgdi number,
                                      
                                      p_aqpc157aacmd48 varchar2,
                                      p_aqpc157avrruim number,
                                      p_aqpc157avaruim number,
                                      p_aqpc157avrvuim number,
                                      p_aqpc157avavuim number,
                                      p_aqpc157avhruim number,
                                      
                                      p_aqpc157aacmd49 varchar2,
                                      p_aqpc157avrrutn number,
                                      p_aqpc157avarutn number,
                                      p_aqpc157avrvutn number,
                                      p_aqpc157avavutn number,
                                      p_aqpc157avhrutn number,
                                      
                                      p_aqpc157aacmd50 varchar2,
                                      p_aqpc157avrrgad number,
                                      p_aqpc157avargad number,
                                      p_aqpc157avrvgad number,
                                      p_aqpc157avavgad number,
                                      p_aqpc157avhrgad number,
                                      
                                      p_aqpc157aacmd51 varchar2,
                                      p_aqpc157avcrprp number,
                                      p_aqpc157avcaprp number,
                                      
                                      p_aqpc157aacmd52 varchar2,
                                      p_aqpc157avrrvig number,
                                      p_aqpc157avarvig number,
                                      
                                      p_aqpc157aacmd53 varchar2,
                                      p_aqpc157avrrcot number,
                                      p_aqpc157avarcot number,
                                      
                                      p_aqpc157aacmd54 varchar2,
                                      p_aqpc157avrrpot number,
                                      p_aqpc157avarpot number,
                                      
                                      p_aqpc157aacmd55 varchar2,
                                      p_aqpc157avrrrfi number,
                                      p_aqpc157avarrfi number,
                                      
                                      flgOk out varchar2) is
    v_FechaActual DATE; --03082023  
    v_HoraActual  VARCHAR2(8);
    v_correlativo number(10);
    auxInstnc     NUMBER(10);
    instancia     NUMBER(10);
    fechAntOut    date;
    TipFlujCN     varchar2(1);
    Indicflujo    varchar2(3);
  Begin
    -- 2108
    BEGIN
      SELECT MAX(AQPC157CORR)
        INTO v_correlativo
        FROM AQPC157
       WHERE AQPC157CODOPI = p_AQPC157CODOPI; -- AND AQPC156INSTAN = auxAQPC156INSTAN;
    EXCEPTION
      WHEN OTHERS THEN
        v_correlativo := 0;
    END;
    IF v_correlativo IS NULL THEN
      v_correlativo := 0;
    END IF;
  
    v_correlativo := v_correlativo + 1;
  
    BEGIN
      UPDATE AQPC157
         SET AQPC157ESTAD = 'I'
       WHERE AQPC157CODOPI = p_AQPC157CODOPI
         AND (AQPC157ESTAD = 'H' OR AQPC157ESTAD IS NULL);
      --DELETE FROM AQPC157 WHERE AQPC157CODOPI = p_AQPC157CODOPI;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    v_FechaActual := TO_DATE(SYSDATE, 'dd/mm/rrrr');
    v_HoraActual  := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  
    --instancia anterior
    BEGIN
      SELECT AQPC156INSTAN
        INTO instancia
        FROM AQPC156
       WHERE AQPC156CODOPI = p_AQPC157CODOPI
         AND AQPC156ESTAD = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        instancia := 0;
    END;
  
    auxInstnc  := 0;
    Indicflujo := 'NOR';
    TipFlujCN  := 'N';
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_obtner_Instanci_anterior(instancia  => instancia,
                                                             Indicflujo => Indicflujo,
                                                             auxInstnc  => auxInstnc,
                                                             fechAntOut => fechAntOut,
                                                             TipFlujCN  => TipFlujCN);
    EXCEPTION
      WHEN OTHERS THEN
        auxInstnc := 0;
    END;
  
    BEGIN
      INSERT INTO AQPC157
        (AQPC157CODOPI,
         AQPC157Afeere,
         AQPC157Afeean,
         AQPC157AacMda1,
         AQPC157AacrDis,
         AQPC157AarvDis,
         AQPC157AacaDis,
         AQPC157AaavDis,
         AQPC157AaaHDis,
         
         AQPC157AacMda2,
         AQPC157AacrCxC,
         AQPC157AarvCxC,
         AQPC157AacaCxC,
         AQPC157AaavCxC,
         AQPC157AaaHCxC,
         
         AQPC157AacMda3,
         AQPC157AacrMer,
         AQPC157AarvMer,
         AQPC157AacaMer,
         AQPC157AaavMer,
         AQPC157AaaHMer,
         
         AQPC157AacMda4,
         AQPC157Aacrgap,
         AQPC157Aarvgap,
         AQPC157Aacagap,
         AQPC157Aaavgap,
         AQPC157AaaHgap,
         
         AQPC157AacMda5,
         AQPC157AacrExr,
         AQPC157AarvExr,
         AQPC157AacaExr,
         AQPC157AaavExr,
         AQPC157AaaHExr,
         
         AQPC157AacMda6,
         AQPC157AacrOt1,
         AQPC157AarvOt1,
         AQPC157AacaOt1,
         AQPC157AaavOt1,
         AQPC157AaaHOt1,
         
         AQPC157AacMda7,
         AQPC157AacrTac,
         AQPC157AacaTac,
         AQPC157AarvTac,
         AQPC157AaavTac,
         AQPC157AaaHTac,
         
         AQPC157AacMda8,
         AQPC157Aacrmue,
         AQPC157Aacamue,
         AQPC157Aarvmue,
         AQPC157Aaavmue,
         AQPC157AaaHmue,
         
         AQPC157AacMda9,
         AQPC157Aacrinm,
         AQPC157Aacainm,
         AQPC157Aarvinm,
         AQPC157Aaavinm,
         AQPC157AaaHinm,
         
         AQPC157AacMd10,
         AQPC157AACRot2,
         AQPC157AARVot2,
         AQPC157AACAot2,
         AQPC157AAAVot2,
         AQPC157AAAHot2,
         
         AQPC157AacMd11,
         AQPC157Aacrtaf,
         AQPC157Aacataf,
         AQPC157Aaavtaf,
         AQPC157AaaHtaf,
         AQPC157Aarvrta,
         
         AQPC157AacMd12,
         AQPC157AacrTat,
         AQPC157AacaTat,
         AQPC157AarvTat,
         AQPC157AaavTat,
         AQPC157AaaHTat,
         --pasivos  AQPC157AacMd13,
         AQPC157AacMd13,
         AQPC157APrcxpC,
         AQPC157APRVCxp,
         AQPC157APAcxpC,
         AQPC157APAVCxp,
         AQPC157APAHCxp,
         
         AQPC157AacMd14,
         AQPC157APRCXPB,
         AQPC157APRVXPB,
         AQPC157APACXPB,
         AQPC157APAVXPB,
         AQPC157APAHXPB,
         
         AQPC157AacMd15,
         AQPC157APRTXP,
         AQPC157APATXP,
         AQPC157APRVTXP,
         AQPC157APAVTXP,
         AQPC157APAHTXP,
         
         AQPC157AacMd16,
         AQPC157APROTR1,
         AQPC157APAOTR1,
         AQPC157APAVOT1,
         AQPC157APAHOT1,
         AQPC157APRVOT1,
         
         AQPC157AacMd17,
         AQPC157APRTPCR,
         AQPC157APRVTPC,
         AQPC157APATPCR,
         AQPC157APAVTPC,
         AQPC157APAHTPC,
         
         AQPC157AacMd18,
         AQPC157APRCXLP,
         AQPC157APRVCXL,
         AQPC157APACXLP,
         AQPC157APAVCXL,
         AQPC157APAHCXL,
         
         AQPC157AacMd19,
         AQPC157APRBST,
         AQPC157APRVBST,
         AQPC157APABST,
         AQPC157APAVBST,
         AQPC157APAHBST,
         
         AQPC157AacMd20,
         AQPC157APROTR2,
         AQPC157APRVOT2,
         AQPC157APAOTR2,
         AQPC157APAVOT2,
         AQPC157APAHOT2,
         
         AQPC157AacMd21,
         AQPC157APRPNCO,
         AQPC157APRVPNC,
         AQPC157APAPNCO,
         AQPC157APAVPNC,
         AQPC157APAHPNC,
         
         AQPC157AacMd22,
         AQPC157APRTTPA,
         AQPC157APRVTTP,
         AQPC157APATTPA,
         AQPC157APAVTTP,
         AQPC157APAHTTP,
         
         AQPC157AacMd23,
         AQPC157APRCAP,
         AQPC157APRVCAP,
         AQPC157APACAP,
         AQPC157APAVCAP,
         AQPC157APAHCAP,
         
         AQPC157AacMd24,
         AQPC157APRRESE,
         AQPC157APRVRES,
         AQPC157APARESE,
         AQPC157APAVRES,
         AQPC157APAHRES,
         
         AQPC157AacMd25,
         AQPC157APRREAC,
         AQPC157APRVREA,
         AQPC157APAREAC,
         AQPC157APAVREA,
         AQPC157APAHREA,
         
         AQPC157AacMd26,
         AQPC157APRRDEJ,
         AQPC157APRVRDE,
         AQPC157APAVRDE,
         AQPC157APARDEJ,
         AQPC157APAHRDE,
         
         AQPC157AacMd27,
         AQPC157APROTR3,
         AQPC157APRVOT3,
         AQPC157APAOTR3,
         AQPC157APAVOT3,
         AQPC157APAHOT3,
         
         AQPC157AacMd28,
         AQPC157APRPATR,
         AQPC157APRVPAT,
         AQPC157APAPATR,
         AQPC157APAVPAT,
         AQPC157APAHPAT,
         
         AQPC157AacMd29,
         AQPC157APRTTPP,
         AQPC157APRVTPP,
         AQPC157APATTPP,
         AQPC157APAVTPP,
         AQPC157APAHTPP,
         
         --ventas
         AQPC157AacMd30,
         AQPC157AVRVEN,
         AQPC157AVRVVEN,
         AQPC157AVAVEN,
         AQPC157AVAVVEN,
         AQPC157AVAHVEN,
         
         AQPC157AacMd31,
         AQPC157AVRCOSV,
         AQPC157AVRVCSV,
         AQPC157AVACOSV,
         AQPC157AVAVCSV,
         AQPC157AVHCOSV,
         
         AQPC157AacMd32,
         AQPC157AVRUBR,
         AQPC157AVRVUBR,
         AQPC157AVAUBR,
         AQPC157AVAVUBR,
         AQPC157AVHUBR,
         
         AQPC157AacMd33,
         AQPC157AVRCOOP,
         AQPC157AVRVCOP,
         AQPC157AVACOOP,
         AQPC157AVAVCOP,
         AQPC157AVHCOOP,
         
         AQPC157AacMd34,
         AQPC157AVRSDOI,
         AQPC157AVRVSDO,
         AQPC157AVASDOI,
         AQPC157AVAVSDO,
         AQPC157AVHSDOI,
         
         AQPC157AacMd35,
         AQPC157AVRSDV,
         AQPC157AVRVSD,
         AQPC157AVASDV,
         AQPC157AVAVSDV,
         AQPC157AVHSDV,
         
         AQPC157AacMd36,
         AQPC157AVRIMP,
         AQPC157AVRVIMP,
         AQPC157AVAIMP,
         AQPC157AVAVIMP,
         AQPC157AVHIMP,
         
         AQPC157AacMd37,
         AQPC157AVROTC,
         AQPC157AVRVOTC,
         AQPC157AVAOTC,
         AQPC157AVAVOTC,
         AQPC157AVHOTC,
         
         AQPC157AacMd38,
         AQPC157AVRRESE,
         AQPC157AVRVRES,
         AQPC157AVARESE,
         AQPC157AVAVRES,
         AQPC157AVHRESE,
         
         AQPC157AacMd39,
         AQPC157AVROTI,
         AQPC157AVRVOTI,
         AQPC157AVAOTI,
         AQPC157AVAVOTI,
         AQPC157AVHOTI,
         
         AQPC157AacMd40,
         AQPC157AVRGFM,
         AQPC157AVRVGFM,
         AQPC157AVAGFM,
         AQPC157AVAVGFM,
         AQPC157AVHGFM,
         
         AQPC157AacMd41,
         AQPC157AVRRSCP,
         AQPC157AVRVRSC,
         AQPC157AVARSCP,
         AQPC157AVAVRSC,
         AQPC157AVHRSCP,
         
         AQPC157AacMd42,
         AQPC157AVRMCCP,
         AQPC157AVRVMCP,
         AQPC157AVAMCCP,
         AQPC157AVAVMCC,
         AQPC157AVHMCCP,
         
         AQPC157AacMd43,
         AQPC157AVRRNET,
         AQPC157AVRVRNT,
         AQPC157AVARNET,
         AQPC157AVAVRNE,
         AQPC157AVHRNET,
         
         --MACEM        
         AQPC157MPMNP,
         AQPC157MPSLDV,
         AQPC157MPSLCO,
         AQPC157MMFUD1,
         AQPC157MMCR1,
         AQPC157MMMCM1,
         AQPC157MMFUD2,
         AQPC157MMCR2,
         AQPC157MMMCM2,
         
         --ratios
         AQPC157ARTLIQ1,
         AQPC157ARTRCX1,
         AQPC157ATRRDI1,
         AQPC157ATREND1,
         AQPC157ATRROE1,
         AQPC157ATRRCR1,
         
         AQPC157ARTLIQ2,
         AQPC157ARTRCX2,
         AQPC157ATRRDI2,
         AQPC157ATREND2,
         AQPC157ATRROE2,
         AQPC157ATRRCR2,
         
         aqpc157aacmd44,
         aqpc157avcruto,
         aqpc157avcauto,
         aqpc157avrvuto,
         aqpc157avavuto,
         aqpc157avahuto,
         
         aqpc157aacmd45,
         aqpc157avrrgfi,
         aqpc157avargfi,
         aqpc157avrvgfi,
         aqpc157avavgfi,
         aqpc157avhrgfi,
         
         aqpc157aacmd46,
         aqpc157avrrigf,
         aqpc157avarigf,
         aqpc157avrvigf,
         aqpc157avavigf,
         aqpc157avhrigf,
         
         aqpc157aacmd47,
         aqpc157avrrgdi,
         aqpc157avargdi,
         aqpc157avrvgdi,
         aqpc157avavgdi,
         aqpc157avhrgdi,
         
         aqpc157aacmd48,
         aqpc157avrruim,
         aqpc157avaruim,
         aqpc157avrvuim,
         aqpc157avavuim,
         aqpc157avhruim,
         
         aqpc157aacmd49,
         aqpc157avrrutn,
         aqpc157avarutn,
         aqpc157avrvutn,
         aqpc157avavutn,
         aqpc157avhrutn,
         
         aqpc157aacmd50,
         aqpc157avrrgad,
         aqpc157avargad,
         aqpc157avrvgad,
         aqpc157avavgad,
         aqpc157avhrgad,
         AQPC157FECHREG, --0308
         AQPC157HORAREG,
         AQPC157AACMD51, --21082023                               
         AQPC157AVCRPRP,
         AQPC157AVCAPRP,
         aqpc157aacmd52,
         aqpc157avrrvig,
         aqpc157avarvig,
         aqpc157aacmd53,
         aqpc157avrrcot,
         aqpc157avarcot,
         aqpc157aacmd54,
         aqpc157avrrpot,
         aqpc157avarpot,
         aqpc157aacmd55,
         aqpc157avrrrfi,
         aqpc157avarrfi,
         AQPC157CORR,
         AQPC157ESTAD,
         AQPC157INSTANT) --2108
      VALUES
        (p_AQPC157CODOPI,
         p_AQPC157Afeere,
         p_AQPC157Afeean,
         p_AQPC157AacMda1,
         p_AQPC157AacrDis,
         p_AQPC157AarvDis,
         p_AQPC157AacaDis,
         p_AQPC157AaavDis,
         p_AQPC157AaaHDis,
         
         p_AQPC157AacMda2,
         p_AQPC157AacrCxC,
         p_AQPC157AarvCxC,
         p_AQPC157AacaCxC,
         p_AQPC157AaavCxC,
         p_AQPC157AaaHCxC,
         
         p_AQPC157AacMda3,
         p_AQPC157AacrMer,
         p_AQPC157AarvMer,
         p_AQPC157AacaMer,
         p_AQPC157AaavMer,
         p_AQPC157AaaHMer,
         
         p_AQPC157AacMda4,
         p_AQPC157Aacrgap,
         p_AQPC157Aarvgap,
         p_AQPC157Aacagap,
         p_AQPC157Aaavgap,
         p_AQPC157AaaHgap,
         
         p_AQPC157AacMda5,
         p_AQPC157AacrExr,
         p_AQPC157AarvExr,
         p_AQPC157AacaExr,
         p_AQPC157AaavExr,
         p_AQPC157AaaHExr,
         
         p_AQPC157AacMda6,
         p_AQPC157AacrOt1,
         p_AQPC157AarvOt1,
         p_AQPC157AacaOt1,
         p_AQPC157AaavOt1,
         p_AQPC157AaaHOt1,
         
         p_AQPC157AacMda7,
         p_AQPC157AacrTac,
         p_AQPC157AacaTac,
         p_AQPC157AarvTac,
         p_AQPC157AaavTac,
         p_AQPC157AaaHTac,
         
         p_AQPC157AacMda8,
         p_AQPC157Aacrmue,
         p_AQPC157Aacamue,
         p_AQPC157Aarvmue,
         p_AQPC157Aaavmue,
         p_AQPC157AaaHmue,
         
         p_AQPC157AacMda9,
         p_AQPC157Aacrinm,
         p_AQPC157Aacainm,
         p_AQPC157Aarvinm,
         p_AQPC157Aaavinm,
         p_AQPC157AaaHinm,
         
         p_AQPC157AacMd10,
         p_AQPC157AACRot2,
         p_AQPC157AARVot2,
         p_AQPC157AACAot2,
         p_AQPC157AAAVot2,
         p_AQPC157AAAHot2,
         
         p_AQPC157AacMd11,
         p_AQPC157Aacrtaf,
         p_AQPC157Aacataf,
         p_AQPC157Aaavtaf,
         p_AQPC157AaaHtaf,
         p_AQPC157Aarvrta,
         
         p_AQPC157AacMd12,
         p_AQPC157AacrTat,
         p_AQPC157AacaTat,
         p_AQPC157AarvTat,
         p_AQPC157AaavTat,
         p_AQPC157AaaHTat,
         --pasivos
         p_AQPC157AacMd13,
         p_AQPC157APrcxpC,
         p_AQPC157APRVCxp,
         p_AQPC157APAcxpC,
         p_AQPC157APAVCxp,
         p_AQPC157APAHCxp,
         
         p_AQPC157AacMd14,
         p_AQPC157APRCXPB,
         p_AQPC157APRVXPB,
         p_AQPC157APACXPB,
         p_AQPC157APAVXPB,
         p_AQPC157APAHXPB,
         
         p_AQPC157AacMd15,
         p_AQPC157APRTXP,
         p_AQPC157APATXP,
         p_AQPC157APRVTXP,
         p_AQPC157APAVTXP,
         p_AQPC157APAHTXP,
         
         p_AQPC157AacMd16,
         p_AQPC157APROTR1,
         p_AQPC157APAOTR1,
         p_AQPC157APAVOT1,
         p_AQPC157APAHOT1,
         p_AQPC157APRVOT1,
         
         p_AQPC157AacMd17,
         p_AQPC157APRTPCR,
         p_AQPC157APRVTPC,
         p_AQPC157APATPCR,
         p_AQPC157APAVTPC,
         p_AQPC157APAHTPC,
         
         p_AQPC157AacMd18,
         p_AQPC157APRCXLP,
         p_AQPC157APRVCXL,
         p_AQPC157APACXLP,
         p_AQPC157APAVCXL,
         p_AQPC157APAHCXL,
         
         p_AQPC157AacMd19,
         p_AQPC157APRBST,
         p_AQPC157APRVBST,
         p_AQPC157APABST,
         p_AQPC157APAVBST,
         p_AQPC157APAHBST,
         
         p_AQPC157AacMd20,
         p_AQPC157APROTR2,
         p_AQPC157APRVOT2,
         p_AQPC157APAOTR2,
         p_AQPC157APAVOT2,
         p_AQPC157APAHOT2,
         
         p_AQPC157AacMd21,
         p_AQPC157APRPNCO,
         p_AQPC157APRVPNC,
         p_AQPC157APAPNCO,
         p_AQPC157APAVPNC,
         p_AQPC157APAHPNC,
         
         p_AQPC157AacMd22,
         p_AQPC157APRTTPA,
         p_AQPC157APRVTTP,
         p_AQPC157APATTPA,
         p_AQPC157APAVTTP,
         p_AQPC157APAHTTP,
         
         p_AQPC157AacMd23,
         p_AQPC157APRCAP,
         p_AQPC157APRVCAP,
         p_AQPC157APACAP,
         p_AQPC157APAVCAP,
         p_AQPC157APAHCAP,
         
         p_AQPC157AacMd24,
         p_AQPC157APRRESE,
         p_AQPC157APRVRES,
         p_AQPC157APARESE,
         p_AQPC157APAVRES,
         p_AQPC157APAHRES,
         
         p_AQPC157AacMd25,
         p_AQPC157APRREAC,
         p_AQPC157APRVREA,
         p_AQPC157APAREAC,
         p_AQPC157APAVREA,
         p_AQPC157APAHREA,
         
         p_AQPC157AacMd26,
         p_AQPC157APRRDEJ,
         p_AQPC157APRVRDE,
         p_AQPC157APAVRDE,
         p_AQPC157APARDEJ,
         p_AQPC157APAHRDE,
         
         p_AQPC157AacMd27,
         p_AQPC157APROTR3,
         p_AQPC157APRVOT3,
         p_AQPC157APAOTR3,
         p_AQPC157APAVOT3,
         p_AQPC157APAHOT3,
         
         p_AQPC157AacMd28,
         p_AQPC157APRPATR,
         p_AQPC157APRVPAT,
         p_AQPC157APAPATR,
         p_AQPC157APAVPAT,
         p_AQPC157APAHPAT,
         
         p_AQPC157AacMd29,
         p_AQPC157APRTTPP,
         p_AQPC157APRVTPP,
         p_AQPC157APATTPP,
         p_AQPC157APAVTPP,
         p_AQPC157APAHTPP,
         
         --ventas
         p_AQPC157AacMd30,
         p_AQPC157AVRVEN,
         p_AQPC157AVRVVEN,
         p_AQPC157AVAVEN,
         p_AQPC157AVAVVEN,
         p_AQPC157AVAHVEN,
         
         p_AQPC157AacMd31,
         p_AQPC157AVRCOSV,
         p_AQPC157AVRVCSV,
         p_AQPC157AVACOSV,
         p_AQPC157AVAVCSV,
         p_AQPC157AVHCOSV,
         
         p_AQPC157AacMd32,
         p_AQPC157AVRUBR,
         p_AQPC157AVRVUBR,
         p_AQPC157AVAUBR,
         p_AQPC157AVAVUBR,
         p_AQPC157AVHUBR,
         
         p_AQPC157AacMd33,
         p_AQPC157AVRCOOP,
         p_AQPC157AVRVCOP,
         p_AQPC157AVACOOP,
         p_AQPC157AVAVCOP,
         p_AQPC157AVHCOOP,
         
         p_AQPC157AacMd34,
         p_AQPC157AVRSDOI,
         p_AQPC157AVRVSDO,
         p_AQPC157AVASDOI,
         p_AQPC157AVAVSDO,
         p_AQPC157AVHSDOI,
         
         p_AQPC157AacMd35,
         p_AQPC157AVRSDV,
         p_AQPC157AVRVSD,
         p_AQPC157AVASDV,
         p_AQPC157AVAVSDV,
         p_AQPC157AVHSDV,
         
         p_AQPC157AacMd36,
         p_AQPC157AVRIMP,
         p_AQPC157AVRVIMP,
         p_AQPC157AVAIMP,
         p_AQPC157AVAVIMP,
         p_AQPC157AVHIMP,
         
         p_AQPC157AacMd37,
         p_AQPC157AVROTC,
         p_AQPC157AVRVOTC,
         p_AQPC157AVAOTC,
         p_AQPC157AVAVOTC,
         p_AQPC157AVHOTC,
         
         p_AQPC157AacMd38,
         p_AQPC157AVRRESE,
         p_AQPC157AVRVRES,
         p_AQPC157AVARESE,
         p_AQPC157AVAVRES,
         p_AQPC157AVHRESE,
         
         p_AQPC157AacMd39,
         p_AQPC157AVROTI,
         p_AQPC157AVRVOTI,
         p_AQPC157AVAOTI,
         p_AQPC157AVAVOTI,
         p_AQPC157AVHOTI,
         
         p_AQPC157AacMd40,
         p_AQPC157AVRGFM,
         p_AQPC157AVRVGFM,
         p_AQPC157AVAGFM,
         p_AQPC157AVAVGFM,
         p_AQPC157AVHGFM,
         
         p_AQPC157AacMd41,
         p_AQPC157AVRRSCP,
         p_AQPC157AVRVRSC,
         p_AQPC157AVARSCP,
         p_AQPC157AVAVRSC,
         p_AQPC157AVHRSCP,
         
         p_AQPC157AacMd42,
         p_AQPC157AVRMCCP,
         p_AQPC157AVRVMCP,
         p_AQPC157AVAMCCP,
         p_AQPC157AVAVMCC,
         p_AQPC157AVHMCCP,
         
         p_AQPC157AacMd43,
         p_AQPC157AVRRNET,
         p_AQPC157AVRVRNT,
         p_AQPC157AVARNET,
         p_AQPC157AVAVRNE,
         p_AQPC157AVHRNET,
         
         --MACEM
         p_AQPC157MPMNP,
         p_AQPC157MPSLDV,
         p_AQPC157MPSLCO,
         p_AQPC157MMFUD1,
         p_AQPC157MMCR1,
         p_AQPC157MMMCM1,
         p_AQPC157MMFUD2,
         p_AQPC157MMCR2,
         p_AQPC157MMMCM2,
         
         --ratios
         p_AQPC157ARTLIQ1,
         p_AQPC157ARTRCX1,
         p_AQPC157ATRRDI1,
         p_AQPC157ATREND1,
         p_AQPC157ATRROE1,
         p_AQPC157ATRRCR1,
         
         p_AQPC157ARTLIQ2,
         p_AQPC157ARTRCX2,
         p_AQPC157ATRRDI2,
         p_AQPC157ATREND2,
         p_AQPC157ATRROE2,
         p_AQPC157ATRRCR2,
         
         p_aqpc157aacmd44,
         p_aqpc157avcruto,
         p_aqpc157avcauto,
         p_aqpc157avrvuto,
         p_aqpc157avavuto,
         p_aqpc157avahuto,
         
         p_aqpc157aacmd45,
         p_aqpc157avrrgfi,
         p_aqpc157avargfi,
         p_aqpc157avrvgfi,
         p_aqpc157avavgfi,
         p_aqpc157avhrgfi,
         
         p_aqpc157aacmd46,
         p_aqpc157avrrigf,
         p_aqpc157avarigf,
         p_aqpc157avrvigf,
         p_aqpc157avavigf,
         p_aqpc157avhrigf,
         
         p_aqpc157aacmd47,
         p_aqpc157avrrgdi,
         p_aqpc157avargdi,
         p_aqpc157avrvgdi,
         p_aqpc157avavgdi,
         p_aqpc157avhrgdi,
         
         p_aqpc157aacmd48,
         p_aqpc157avrruim,
         p_aqpc157avaruim,
         p_aqpc157avrvuim,
         p_aqpc157avavuim,
         p_aqpc157avhruim,
         
         p_aqpc157aacmd49,
         p_aqpc157avrrutn,
         p_aqpc157avarutn,
         p_aqpc157avrvutn,
         p_aqpc157avavutn,
         p_aqpc157avhrutn,
         
         p_aqpc157aacmd50,
         p_aqpc157avrrgad,
         p_aqpc157avargad,
         p_aqpc157avrvgad,
         p_aqpc157avavgad,
         p_aqpc157avhrgad,
         v_FechaActual,
         v_HoraActual,
         p_AQPC157AACMD51,
         p_AQPC157AVCRPRP,
         p_AQPC157AVCAPRP,
         p_aqpc157aacmd52,
         p_aqpc157avrrvig,
         p_aqpc157avarvig,
         p_aqpc157aacmd53,
         p_aqpc157avrrcot,
         p_aqpc157avarcot,
         p_aqpc157aacmd54,
         p_aqpc157avrrpot,
         p_aqpc157avarpot,
         p_aqpc157aacmd55,
         p_aqpc157avrrrfi,
         p_aqpc157avarrfi,
         v_correlativo,
         'H',
         auxInstnc);
      flgOk := 'S';
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        --ROLLBACK;
        flgOK := 'E';
    END;
  End;

  procedure sp_insert_analicredcontador_AQPC158(p_AQPC158CODOPI number,
                                                
                                                p_AQPC158Afeere  date,
                                                p_AQPC158Afeean  date,
                                                p_AQPC158AacMda1 varchar2,
                                                p_AQPC158AacrDis number,
                                                p_AQPC158AarvDis number,
                                                p_AQPC158AacaDis number,
                                                p_AQPC158AaavDis number,
                                                p_AQPC158AaaHDis number,
                                                
                                                p_AQPC158AacMda2 varchar2,
                                                p_AQPC158AacrCxC number,
                                                p_AQPC158AarvCxC number,
                                                p_AQPC158AacaCxC number,
                                                p_AQPC158AaavCxC number,
                                                p_AQPC158AaaHCxC number,
                                                
                                                p_AQPC158AacMda3 varchar2,
                                                p_AQPC158AacrMer number,
                                                p_AQPC158AarvMer number,
                                                p_AQPC158AacaMer number,
                                                p_AQPC158AaavMer number,
                                                p_AQPC158AaaHMer number,
                                                
                                                p_AQPC158AacMda4 varchar2,
                                                p_AQPC158Aacrgap number,
                                                p_AQPC158Aarvgap number,
                                                p_AQPC158Aacagap number,
                                                p_AQPC158Aaavgap number,
                                                p_AQPC158AaaHgap number,
                                                
                                                p_AQPC158AacMda5 varchar2,
                                                p_AQPC158AacrExr number,
                                                p_AQPC158AarvExr number,
                                                p_AQPC158AacaExr number,
                                                p_AQPC158AaavExr number,
                                                p_AQPC158AaaHExr number,
                                                
                                                /* p_AQPC158AacMda6 varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AacrOt1 number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AarvOt1 number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AacaOt1 number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AaavOt1 number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AaaHOt1 number,*/
                                                
                                                p_AQPC158AacMda7 varchar2,
                                                p_AQPC158AacrTac number,
                                                p_AQPC158AacaTac number,
                                                p_AQPC158AarvTac number,
                                                p_AQPC158AaavTac number,
                                                p_AQPC158AaaHTac number,
                                                
                                                p_AQPC158AacMda8 varchar2,
                                                p_AQPC158Aacrmue number,
                                                p_AQPC158Aacamue number,
                                                p_AQPC158Aarvmue number,
                                                p_AQPC158Aaavmue number,
                                                p_AQPC158AaaHmue number,
                                                
                                                p_AQPC158AacMda9 varchar2,
                                                p_AQPC158Aacrinm number,
                                                p_AQPC158Aacainm number,
                                                p_AQPC158Aarvinm number,
                                                p_AQPC158Aaavinm number,
                                                p_AQPC158AaaHinm number,
                                                
                                                p_AQPC158AacMd10 varchar2,
                                                p_AQPC158AACRot2 number,
                                                p_AQPC158AARVot2 number,
                                                p_AQPC158AACAot2 number,
                                                p_AQPC158AAAVot2 number,
                                                p_AQPC158AAAHot2 number,
                                                
                                                p_AQPC158AacMd11 varchar2,
                                                p_AQPC158Aacrtaf number,
                                                p_AQPC158Aacataf number,
                                                p_AQPC158Aaavtaf number,
                                                p_AQPC158AaaHtaf number,
                                                p_AQPC158Aarvrta number,
                                                
                                                p_AQPC158AacMd12 varchar2,
                                                p_AQPC158AacrTat number,
                                                p_AQPC158AacaTat number,
                                                p_AQPC158AarvTat number,
                                                p_AQPC158AaavTat number,
                                                p_AQPC158AaaHTat number,
                                                --pasivos
                                                p_AQPC158AacMd13 varchar2,
                                                p_AQPC158APrcxpC number,
                                                p_AQPC158APRVCxp number,
                                                p_AQPC158APAcxpC number,
                                                p_AQPC158APAVCxp number,
                                                p_AQPC158APAHCxp number,
                                                
                                                p_AQPC158AacMd14 varchar2,
                                                p_AQPC158APRCXPB number,
                                                p_AQPC158APRVXPB number,
                                                p_AQPC158APACXPB number,
                                                p_AQPC158APAVXPB number,
                                                p_AQPC158APAHXPB number,
                                                
                                                p_AQPC158AacMd15 varchar2,
                                                p_AQPC158APRTXP  number,
                                                p_AQPC158APATXP  number,
                                                p_AQPC158APRVTXP number,
                                                p_AQPC158APAVTXP number,
                                                p_AQPC158APAHTXP number,
                                                
                                                p_AQPC158AacMd16 varchar2,
                                                p_AQPC158APROTR1 number,
                                                p_AQPC158APAOTR1 number,
                                                p_AQPC158APAVOT1 number,
                                                p_AQPC158APAHOT1 number,
                                                p_AQPC158APRVOT1 number,
                                                
                                                p_AQPC158AacMd17 varchar2,
                                                p_AQPC158APRTPCR number,
                                                p_AQPC158APRVTPC number,
                                                p_AQPC158APATPCR number,
                                                p_AQPC158APAVTPC number,
                                                p_AQPC158APAHTPC number,
                                                
                                                p_AQPC158AacMd18 varchar2,
                                                p_AQPC158APRCXLP number,
                                                p_AQPC158APRVCXL number,
                                                p_AQPC158APACXLP number,
                                                p_AQPC158APAVCXL number,
                                                p_AQPC158APAHCXL number,
                                                
                                                p_AQPC158AacMd19 varchar2,
                                                p_AQPC158APRBST  number,
                                                p_AQPC158APRVBST number,
                                                p_AQPC158APABST  number,
                                                p_AQPC158APAVBST number,
                                                p_AQPC158APAHBST number,
                                                
                                                p_AQPC158AacMd20 varchar2,
                                                p_AQPC158APROTR2 number,
                                                p_AQPC158APRVOT2 number,
                                                p_AQPC158APAOTR2 number,
                                                p_AQPC158APAVOT2 number,
                                                p_AQPC158APAHOT2 number,
                                                
                                                p_AQPC158AacMd21 varchar2,
                                                p_AQPC158APRPNCO number,
                                                p_AQPC158APRVPNC number,
                                                p_AQPC158APAPNCO number,
                                                p_AQPC158APAVPNC number,
                                                p_AQPC158APAHPNC number,
                                                
                                                p_AQPC158AacMd22 varchar2,
                                                p_AQPC158APRTTPA number,
                                                p_AQPC158APRVTTP number,
                                                p_AQPC158APATTPA number,
                                                p_AQPC158APAVTTP number,
                                                p_AQPC158APAHTTP number,
                                                
                                                p_AQPC158AacMd23 varchar2,
                                                p_AQPC158APRCAP  number,
                                                p_AQPC158APRVCAP number,
                                                p_AQPC158APACAP  number,
                                                p_AQPC158APAVCAP number,
                                                p_AQPC158APAHCAP number,
                                                
                                                p_AQPC158AacMd24 varchar2,
                                                p_AQPC158APRRESE number,
                                                p_AQPC158APRVRES number,
                                                p_AQPC158APARESE number,
                                                p_AQPC158APAVRES number,
                                                p_AQPC158APAHRES number,
                                                
                                                p_AQPC158AacMd25 varchar2,
                                                p_AQPC158APRREAC number,
                                                p_AQPC158APRVREA number,
                                                p_AQPC158APAREAC number,
                                                p_AQPC158APAVREA number,
                                                p_AQPC158APAHREA number,
                                                
                                                p_AQPC158AacMd26 varchar2,
                                                p_AQPC158APRRDEJ number,
                                                p_AQPC158APRVRDE number,
                                                p_AQPC158APAVRDE number,
                                                p_AQPC158APARDEJ number,
                                                p_AQPC158APAHRDE number,
                                                
                                                p_AQPC158AacMd27 varchar2,
                                                p_AQPC158APROTR3 number,
                                                p_AQPC158APRVOT3 number,
                                                p_AQPC158APAOTR3 number,
                                                p_AQPC158APAVOT3 number,
                                                p_AQPC158APAHOT3 number,
                                                
                                                p_AQPC158AacMd28 varchar2,
                                                p_AQPC158APRPATR number,
                                                p_AQPC158APRVPAT number,
                                                p_AQPC158APAPATR number,
                                                p_AQPC158APAVPAT number,
                                                p_AQPC158APAHPAT number,
                                                
                                                p_AQPC158AacMd29 varchar2,
                                                p_AQPC158APRTTPP number,
                                                p_AQPC158APRVTPP number,
                                                p_AQPC158APATTPP number,
                                                p_AQPC158APAVTPP number,
                                                p_AQPC158APAHTPP number,
                                                
                                                --ventas
                                                p_AQPC158AacMd30 varchar2,
                                                p_AQPC158AVRVEN  number,
                                                p_AQPC158AVRVVEN number,
                                                p_AQPC158AVAVEN  number,
                                                p_AQPC158AVAVVEN number,
                                                p_AQPC158AVAHVEN number,
                                                
                                                p_AQPC158AacMd31 varchar2,
                                                p_AQPC158AVRCOSV number,
                                                p_AQPC158AVRVCSV number,
                                                p_AQPC158AVACOSV number,
                                                p_AQPC158AVAVCSV number,
                                                p_AQPC158AVHCOSV number,
                                                
                                                p_AQPC158AacMd32 varchar2,
                                                p_AQPC158AVRUBR  number,
                                                p_AQPC158AVRVUBR number,
                                                p_AQPC158AVAUBR  number,
                                                p_AQPC158AVAVUBR number,
                                                p_AQPC158AVHUBR  number,
                                                
                                                /*   p_AQPC158AacMd33 varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRCOOP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRVCOP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVACOOP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAVCOP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVHCOOP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AacMd34 varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRSDOI number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRVSDO number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVASDOI number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAVSDO number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVHSDOI number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AacMd35 varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRSDV  number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRVSD  number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVASDV  number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAVSDV number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVHSDV  number,*/
                                                
                                                p_AQPC158AacMd36 varchar2,
                                                p_AQPC158AVRIMP  number,
                                                p_AQPC158AVRVIMP number,
                                                p_AQPC158AVAIMP  number,
                                                p_AQPC158AVAVIMP number,
                                                p_AQPC158AVHIMP  number,
                                                
                                                /* p_AQPC158AacMd37 varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVROTC  number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRVOTC number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAOTC  number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAVOTC number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVHOTC  number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AacMd38 varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRRESE number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRVRES number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVARESE number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAVRES number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVHRESE number, */
                                                
                                                p_AQPC158AacMd39 varchar2,
                                                p_AQPC158AVROTI  number,
                                                p_AQPC158AVRVOTI number,
                                                p_AQPC158AVAOTI  number,
                                                p_AQPC158AVAVOTI number,
                                                p_AQPC158AVHOTI  number,
                                                
                                                p_AQPC158AacMd40 varchar2,
                                                p_AQPC158AVRGFM  number,
                                                p_AQPC158AVRVGFM number,
                                                p_AQPC158AVAGFM  number,
                                                p_AQPC158AVAVGFM number,
                                                p_AQPC158AVHGFM  number,
                                                
                                                /*  p_AQPC158AacMd41 varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRRSCP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRVRSC number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVARSCP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAVRSC number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVHRSCP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AacMd42 varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRMCCP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVRVMCP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAMCCP number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVAVMCC number,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                p_AQPC158AVHMCCP number, */
                                                
                                                p_AQPC158AacMd43 varchar2,
                                                p_AQPC158AVRRNET number,
                                                p_AQPC158AVRVRNT number,
                                                p_AQPC158AVARNET number,
                                                p_AQPC158AVAVRNE number,
                                                p_AQPC158AVHRNET number,
                                                
                                                --ratios   
                                                p_AQPC158ARTLIQ1 varchar2,
                                                p_AQPC158ARTRCX1 varchar2,
                                                p_AQPC158ATRRDI1 varchar2,
                                                p_AQPC158ATREND1 varchar2,
                                                p_AQPC158ATRROE1 varchar2,
                                                p_AQPC158ATRRCR1 varchar2,
                                                
                                                p_AQPC158ARTLIQ2 varchar2,
                                                p_AQPC158ARTRCX2 varchar2,
                                                p_AQPC158ATRRDI2 varchar2,
                                                p_AQPC158ATREND2 varchar2,
                                                p_AQPC158ATRROE2 varchar2,
                                                p_AQPC158ATRRCR2 varchar2,
                                                
                                                --nuevos campos
                                                p_aqpc158aacmd44 varchar2,
                                                p_aqpc158aacrota number,
                                                p_aqpc158aacaota number,
                                                p_aqpc158aarvota number,
                                                p_aqpc158aaavota number,
                                                p_aqpc158aaahota number,
                                                
                                                p_aqpc158aacmd45 varchar2,
                                                p_aqpc158avcrgtv number,
                                                p_aqpc158avcagtv number,
                                                p_aqpc158avrvgtv number,
                                                p_aqpc158avavgtv number,
                                                p_aqpc158avahgtv number,
                                                
                                                p_aqpc158aacmd46 varchar2,
                                                p_aqpc158avrrgad number,
                                                p_aqpc158avargad number,
                                                p_aqpc158avrvgad number,
                                                p_aqpc158avavgad number,
                                                p_aqpc158avhrgad number,
                                                
                                                p_aqpc158aacmd47 varchar2,
                                                p_aqpc158avrruto number,
                                                p_aqpc158avaruto number,
                                                p_aqpc158avrvuto number,
                                                p_aqpc158avavuto number,
                                                p_aqpc158avhruto number,
                                                
                                                p_aqpc158aacmd48 varchar2,
                                                p_aqpc158avrrgfi number,
                                                p_aqpc158avargfi number,
                                                p_aqpc158avrvgfi number,
                                                p_aqpc158avavgfi number,
                                                p_aqpc158avhrgfi number,
                                                
                                                p_aqpc158aacmd49 varchar2,
                                                p_aqpc158avrrigf number,
                                                p_aqpc158avarigf number,
                                                p_aqpc158avrvigf number,
                                                p_aqpc158avavigf number,
                                                p_aqpc158avhrigf number,
                                                
                                                p_aqpc158aacmd50 varchar2,
                                                p_aqpc158avrrgdi number,
                                                p_aqpc158avargdi number,
                                                p_aqpc158avrvgdi number,
                                                p_aqpc158avavgdi number,
                                                p_aqpc158avhrgdi number,
                                                
                                                p_aqpc158aacmd51 varchar2,
                                                p_aqpc158avrruim number,
                                                p_aqpc158avaruim number,
                                                p_aqpc158avrvuim number,
                                                p_aqpc158avavuim number,
                                                p_aqpc158avhruim number,
                                                
                                                p_aqpc158aacmd52 varchar2,
                                                p_aqpc158avrrutn number,
                                                p_aqpc158avarutn number,
                                                p_aqpc158avrvutn number,
                                                p_aqpc158avavutn number,
                                                p_aqpc158avhrutn number,
                                                
                                                p_Modo varchar2,
                                                flgOk  out varchar2) is
    v_FechaActual DATE;
    v_HoraActual  VARCHAR2(8);
  Begin
    v_FechaActual := TO_DATE(SYSDATE, 'dd/mm/rrrr');
    v_HoraActual  := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  
    IF p_Modo = 'I' THEN
      --ADD 2602
      BEGIN
        INSERT INTO AQPC158
          (AQPC158CODOPI,
           AQPC158Afeere,
           AQPC158Afeean,
           AQPC158AacMda1,
           AQPC158AacrDis,
           AQPC158AarvDis,
           AQPC158AacaDis,
           AQPC158AaavDis,
           AQPC158AaaHDis,
           
           AQPC158AacMda2,
           AQPC158AacrCxC,
           AQPC158AarvCxC,
           AQPC158AacaCxC,
           AQPC158AaavCxC,
           AQPC158AaaHCxC,
           
           AQPC158AacMda3,
           AQPC158AacrMer,
           AQPC158AarvMer,
           AQPC158AacaMer,
           AQPC158AaavMer,
           AQPC158AaaHMer,
           
           AQPC158AacMda4,
           AQPC158Aacrgap,
           AQPC158Aarvgap,
           AQPC158Aacagap,
           AQPC158Aaavgap,
           AQPC158AaaHgap,
           
           AQPC158AacMda5,
           AQPC158AacrExr,
           AQPC158AarvExr,
           AQPC158AacaExr,
           AQPC158AaavExr,
           AQPC158AaaHExr,
           
           /*AQPC158AacMda6,
           AQPC158AacrOt1,
           AQPC158AarvOt1,
           AQPC158AacaOt1,
           AQPC158AaavOt1,
           AQPC158AaaHOt1,*/
           
           AQPC158AacMda7,
           AQPC158AacrTac,
           AQPC158AacaTac,
           AQPC158AarvTac,
           AQPC158AaavTac,
           AQPC158AaaHTac,
           
           AQPC158AacMda8,
           AQPC158Aacrmue,
           AQPC158Aacamue,
           AQPC158Aarvmue,
           AQPC158Aaavmue,
           AQPC158AaaHmue,
           
           AQPC158AacMda9,
           AQPC158Aacrinm,
           AQPC158Aacainm,
           AQPC158Aarvinm,
           AQPC158Aaavinm,
           AQPC158AaaHinm,
           
           AQPC158AacMd10,
           AQPC158AACRot2,
           AQPC158AARVot2,
           AQPC158AACAot2,
           AQPC158AAAVot2,
           AQPC158AAAHot2,
           
           AQPC158AacMd11,
           AQPC158Aacrtaf,
           AQPC158Aacataf,
           AQPC158Aaavtaf,
           AQPC158AaaHtaf,
           AQPC158Aarvrta,
           
           AQPC158AacMd12,
           AQPC158AacrTat,
           AQPC158AacaTat,
           AQPC158AarvTat,
           AQPC158AaavTat,
           AQPC158AaaHTat,
           --pasivos  AQPC158AacMd13,
           AQPC158AacMd13,
           AQPC158APrcxpC,
           AQPC158APRVCxp,
           AQPC158APAcxpC,
           AQPC158APAVCxp,
           AQPC158APAHCxp,
           
           AQPC158AacMd14,
           AQPC158APRCXPB,
           AQPC158APRVXPB,
           AQPC158APACXPB,
           AQPC158APAVXPB,
           AQPC158APAHXPB,
           
           AQPC158AacMd15,
           AQPC158APRTXP,
           AQPC158APATXP,
           AQPC158APRVTXP,
           AQPC158APAVTXP,
           AQPC158APAHTXP,
           
           AQPC158AacMd16,
           AQPC158APROTR1,
           AQPC158APAOTR1,
           AQPC158APAVOT1,
           AQPC158APAHOT1,
           AQPC158APRVOT1,
           
           AQPC158AacMd17,
           AQPC158APRTPCR,
           AQPC158APRVTPC,
           AQPC158APATPCR,
           AQPC158APAVTPC,
           AQPC158APAHTPC,
           
           AQPC158AacMd18,
           AQPC158APRCXLP,
           AQPC158APRVCXL,
           AQPC158APACXLP,
           AQPC158APAVCXL,
           AQPC158APAHCXL,
           
           AQPC158AacMd19,
           AQPC158APRBST,
           AQPC158APRVBST,
           AQPC158APABST,
           AQPC158APAVBST,
           AQPC158APAHBST,
           
           AQPC158AacMd20,
           AQPC158APROTR2,
           AQPC158APRVOT2,
           AQPC158APAOTR2,
           AQPC158APAVOT2,
           AQPC158APAHOT2,
           
           AQPC158AacMd21,
           AQPC158APRPNCO,
           AQPC158APRVPNC,
           AQPC158APAPNCO,
           AQPC158APAVPNC,
           AQPC158APAHPNC,
           
           AQPC158AacMd22,
           AQPC158APRTTPA,
           AQPC158APRVTTP,
           AQPC158APATTPA,
           AQPC158APAVTTP,
           AQPC158APAHTTP,
           
           AQPC158AacMd23,
           AQPC158APRCAP,
           AQPC158APRVCAP,
           AQPC158APACAP,
           AQPC158APAVCAP,
           AQPC158APAHCAP,
           
           AQPC158AacMd24,
           AQPC158APRRESE,
           AQPC158APRVRES,
           AQPC158APARESE,
           AQPC158APAVRES,
           AQPC158APAHRES,
           
           AQPC158AacMd25,
           AQPC158APRREAC,
           AQPC158APRVREA,
           AQPC158APAREAC,
           AQPC158APAVREA,
           AQPC158APAHREA,
           
           AQPC158AacMd26,
           AQPC158APRRDEJ,
           AQPC158APRVRDE,
           AQPC158APAVRDE,
           AQPC158APARDEJ,
           AQPC158APAHRDE,
           
           AQPC158AacMd27,
           AQPC158APROTR3,
           AQPC158APRVOT3,
           AQPC158APAOTR3,
           AQPC158APAVOT3,
           AQPC158APAHOT3,
           
           AQPC158AacMd28,
           AQPC158APRPATR,
           AQPC158APRVPAT,
           AQPC158APAPATR,
           AQPC158APAVPAT,
           AQPC158APAHPAT,
           
           AQPC158AacMd29,
           AQPC158APRTTPP,
           AQPC158APRVTPP,
           AQPC158APATTPP,
           AQPC158APAVTPP,
           AQPC158APAHTPP,
           
           --ventas
           AQPC158AacMd30,
           AQPC158AVRVEN,
           AQPC158AVRVVEN,
           AQPC158AVAVEN,
           AQPC158AVAVVEN,
           AQPC158AVAHVEN,
           
           AQPC158AacMd31,
           AQPC158AVRCOSV,
           AQPC158AVRVCSV,
           AQPC158AVACOSV,
           AQPC158AVAVCSV,
           AQPC158AVHCOSV,
           
           AQPC158AacMd32,
           AQPC158AVRUBR,
           AQPC158AVRVUBR,
           AQPC158AVAUBR,
           AQPC158AVAVUBR,
           AQPC158AVHUBR,
           
           /*AQPC158AacMd33,
           AQPC158AVRCOOP,
           AQPC158AVRVCOP,
           AQPC158AVACOOP,
           AQPC158AVAVCOP,
           AQPC158AVHCOOP,
           
           AQPC158AacMd34,
           AQPC158AVRSDOI,
           AQPC158AVRVSDO,
           AQPC158AVASDOI,
           AQPC158AVAVSDO,
           AQPC158AVHSDOI,
           
           AQPC158AacMd35,
           AQPC158AVRSDV,
           AQPC158AVRVSD,
           AQPC158AVASDV,
           AQPC158AVAVSDV,
           AQPC158AVHSDV,*/
           
           AQPC158AacMd36,
           AQPC158AVRIMP,
           AQPC158AVRVIMP,
           AQPC158AVAIMP,
           AQPC158AVAVIMP,
           AQPC158AVHIMP,
           
           /*AQPC158AacMd37,
           AQPC158AVROTC,
           AQPC158AVRVOTC,
           AQPC158AVAOTC,
           AQPC158AVAVOTC,
           AQPC158AVHOTC,
           
           AQPC158AacMd38,
           AQPC158AVRRESE,
           AQPC158AVRVRES,
           AQPC158AVARESE,
           AQPC158AVAVRES,
           AQPC158AVHRESE,*/
           
           AQPC158AacMd39,
           AQPC158AVROTI,
           AQPC158AVRVOTI,
           AQPC158AVAOTI,
           AQPC158AVAVOTI,
           AQPC158AVHOTI,
           
           AQPC158AacMd40,
           AQPC158AVRGFM,
           AQPC158AVRVGFM,
           AQPC158AVAGFM,
           AQPC158AVAVGFM,
           AQPC158AVHGFM,
           
           /*AQPC158AacMd41,
           AQPC158AVRRSCP,
           AQPC158AVRVRSC,
           AQPC158AVARSCP,
           AQPC158AVAVRSC,
           AQPC158AVHRSCP,
           
           AQPC158AacMd42,
           AQPC158AVRMCCP,
           AQPC158AVRVMCP,
           AQPC158AVAMCCP,
           AQPC158AVAVMCC,
           AQPC158AVHMCCP,*/
           
           AQPC158AacMd43,
           AQPC158AVRRNET,
           AQPC158AVRVRNT,
           AQPC158AVARNET,
           AQPC158AVAVRNE,
           AQPC158AVHRNET,
           
           --ratios
           AQPC158ARTLIQ1,
           AQPC158ARTRCX1,
           AQPC158ATRRDI1,
           AQPC158ATREND1,
           AQPC158ATRROE1,
           AQPC158ATRRCR1,
           
           AQPC158ARTLIQ2,
           AQPC158ARTRCX2,
           AQPC158ATRRDI2,
           AQPC158ATREND2,
           AQPC158ATRROE2,
           AQPC158ATRRCR2,
           --nuevos campos
           aqpc158aacmd44,
           aqpc158aacrota,
           aqpc158aacaota,
           aqpc158aarvota,
           aqpc158aaavota,
           aqpc158aaahota,
           
           aqpc158aacmd45,
           aqpc158avcrgtv,
           aqpc158avcagtv,
           aqpc158avrvgtv,
           aqpc158avavgtv,
           aqpc158avahgtv,
           
           aqpc158aacmd46,
           aqpc158avrrgad,
           aqpc158avargad,
           aqpc158avrvgad,
           aqpc158avavgad,
           aqpc158avhrgad,
           
           aqpc158aacmd47,
           aqpc158avrruto,
           aqpc158avaruto,
           aqpc158avrvuto,
           aqpc158avavuto,
           aqpc158avhruto,
           
           aqpc158aacmd48,
           aqpc158avrrgfi,
           aqpc158avargfi,
           aqpc158avrvgfi,
           aqpc158avavgfi,
           aqpc158avhrgfi,
           
           aqpc158aacmd49,
           aqpc158avrrigf,
           aqpc158avarigf,
           aqpc158avrvigf,
           aqpc158avavigf,
           aqpc158avhrigf,
           
           aqpc158aacmd50,
           aqpc158avrrgdi,
           aqpc158avargdi,
           aqpc158avrvgdi,
           aqpc158avavgdi,
           aqpc158avhrgdi,
           
           aqpc158aacmd51,
           aqpc158avrruim,
           aqpc158avaruim,
           aqpc158avrvuim,
           aqpc158avavuim,
           aqpc158avhruim,
           
           aqpc158aacmd52,
           aqpc158avrrutn,
           aqpc158avarutn,
           aqpc158avrvutn,
           aqpc158avavutn,
           aqpc158avhrutn,
           AQPC158FECHREG,
           AQPC158HORAREG)
        VALUES
          (p_AQPC158CODOPI,
           p_AQPC158Afeere,
           p_AQPC158Afeean,
           p_AQPC158AacMda1,
           p_AQPC158AacrDis,
           p_AQPC158AarvDis,
           p_AQPC158AacaDis,
           p_AQPC158AaavDis,
           p_AQPC158AaaHDis,
           
           p_AQPC158AacMda2,
           p_AQPC158AacrCxC,
           p_AQPC158AarvCxC,
           p_AQPC158AacaCxC,
           p_AQPC158AaavCxC,
           p_AQPC158AaaHCxC,
           
           p_AQPC158AacMda3,
           p_AQPC158AacrMer,
           p_AQPC158AarvMer,
           p_AQPC158AacaMer,
           p_AQPC158AaavMer,
           p_AQPC158AaaHMer,
           
           p_AQPC158AacMda4,
           p_AQPC158Aacrgap,
           p_AQPC158Aarvgap,
           p_AQPC158Aacagap,
           p_AQPC158Aaavgap,
           p_AQPC158AaaHgap,
           
           p_AQPC158AacMda5,
           p_AQPC158AacrExr,
           p_AQPC158AarvExr,
           p_AQPC158AacaExr,
           p_AQPC158AaavExr,
           p_AQPC158AaaHExr,
           
           /*p_AQPC158AacMda6,
           p_AQPC158AacrOt1,
           p_AQPC158AarvOt1,
           p_AQPC158AacaOt1,
           p_AQPC158AaavOt1,
           p_AQPC158AaaHOt1,*/
           
           p_AQPC158AacMda7,
           p_AQPC158AacrTac,
           p_AQPC158AacaTac,
           p_AQPC158AarvTac,
           p_AQPC158AaavTac,
           p_AQPC158AaaHTac,
           
           p_AQPC158AacMda8,
           p_AQPC158Aacrmue,
           p_AQPC158Aacamue,
           p_AQPC158Aarvmue,
           p_AQPC158Aaavmue,
           p_AQPC158AaaHmue,
           
           p_AQPC158AacMda9,
           p_AQPC158Aacrinm,
           p_AQPC158Aacainm,
           p_AQPC158Aarvinm,
           p_AQPC158Aaavinm,
           p_AQPC158AaaHinm,
           
           p_AQPC158AacMd10,
           p_AQPC158AACRot2,
           p_AQPC158AARVot2,
           p_AQPC158AACAot2,
           p_AQPC158AAAVot2,
           p_AQPC158AAAHot2,
           
           p_AQPC158AacMd11,
           p_AQPC158Aacrtaf,
           p_AQPC158Aacataf,
           p_AQPC158Aaavtaf,
           p_AQPC158AaaHtaf,
           p_AQPC158Aarvrta,
           
           p_AQPC158AacMd12,
           p_AQPC158AacrTat,
           p_AQPC158AacaTat,
           p_AQPC158AarvTat,
           p_AQPC158AaavTat,
           p_AQPC158AaaHTat,
           --pasivos
           p_AQPC158AacMd13,
           p_AQPC158APrcxpC,
           p_AQPC158APRVCxp,
           p_AQPC158APAcxpC,
           p_AQPC158APAVCxp,
           p_AQPC158APAHCxp,
           
           p_AQPC158AacMd14,
           p_AQPC158APRCXPB,
           p_AQPC158APRVXPB,
           p_AQPC158APACXPB,
           p_AQPC158APAVXPB,
           p_AQPC158APAHXPB,
           
           p_AQPC158AacMd15,
           p_AQPC158APRTXP,
           p_AQPC158APATXP,
           p_AQPC158APRVTXP,
           p_AQPC158APAVTXP,
           p_AQPC158APAHTXP,
           
           p_AQPC158AacMd16,
           p_AQPC158APROTR1,
           p_AQPC158APAOTR1,
           p_AQPC158APAVOT1,
           p_AQPC158APAHOT1,
           p_AQPC158APRVOT1,
           
           p_AQPC158AacMd17,
           p_AQPC158APRTPCR,
           p_AQPC158APRVTPC,
           p_AQPC158APATPCR,
           p_AQPC158APAVTPC,
           p_AQPC158APAHTPC,
           
           p_AQPC158AacMd18,
           p_AQPC158APRCXLP,
           p_AQPC158APRVCXL,
           p_AQPC158APACXLP,
           p_AQPC158APAVCXL,
           p_AQPC158APAHCXL,
           
           p_AQPC158AacMd19,
           p_AQPC158APRBST,
           p_AQPC158APRVBST,
           p_AQPC158APABST,
           p_AQPC158APAVBST,
           p_AQPC158APAHBST,
           
           p_AQPC158AacMd20,
           p_AQPC158APROTR2,
           p_AQPC158APRVOT2,
           p_AQPC158APAOTR2,
           p_AQPC158APAVOT2,
           p_AQPC158APAHOT2,
           
           p_AQPC158AacMd21,
           p_AQPC158APRPNCO,
           p_AQPC158APRVPNC,
           p_AQPC158APAPNCO,
           p_AQPC158APAVPNC,
           p_AQPC158APAHPNC,
           
           p_AQPC158AacMd22,
           p_AQPC158APRTTPA,
           p_AQPC158APRVTTP,
           p_AQPC158APATTPA,
           p_AQPC158APAVTTP,
           p_AQPC158APAHTTP,
           
           p_AQPC158AacMd23,
           p_AQPC158APRCAP,
           p_AQPC158APRVCAP,
           p_AQPC158APACAP,
           p_AQPC158APAVCAP,
           p_AQPC158APAHCAP,
           
           p_AQPC158AacMd24,
           p_AQPC158APRRESE,
           p_AQPC158APRVRES,
           p_AQPC158APARESE,
           p_AQPC158APAVRES,
           p_AQPC158APAHRES,
           
           p_AQPC158AacMd25,
           p_AQPC158APRREAC,
           p_AQPC158APRVREA,
           p_AQPC158APAREAC,
           p_AQPC158APAVREA,
           p_AQPC158APAHREA,
           
           p_AQPC158AacMd26,
           p_AQPC158APRRDEJ,
           p_AQPC158APRVRDE,
           p_AQPC158APAVRDE,
           p_AQPC158APARDEJ,
           p_AQPC158APAHRDE,
           
           p_AQPC158AacMd27,
           p_AQPC158APROTR3,
           p_AQPC158APRVOT3,
           p_AQPC158APAOTR3,
           p_AQPC158APAVOT3,
           p_AQPC158APAHOT3,
           
           p_AQPC158AacMd28,
           p_AQPC158APRPATR,
           p_AQPC158APRVPAT,
           p_AQPC158APAPATR,
           p_AQPC158APAVPAT,
           p_AQPC158APAHPAT,
           
           p_AQPC158AacMd29,
           p_AQPC158APRTTPP,
           p_AQPC158APRVTPP,
           p_AQPC158APATTPP,
           p_AQPC158APAVTPP,
           p_AQPC158APAHTPP,
           
           --ventas
           p_AQPC158AacMd30,
           p_AQPC158AVRVEN,
           p_AQPC158AVRVVEN,
           p_AQPC158AVAVEN,
           p_AQPC158AVAVVEN,
           p_AQPC158AVAHVEN,
           
           p_AQPC158AacMd31,
           p_AQPC158AVRCOSV,
           p_AQPC158AVRVCSV,
           p_AQPC158AVACOSV,
           p_AQPC158AVAVCSV,
           p_AQPC158AVHCOSV,
           
           p_AQPC158AacMd32,
           p_AQPC158AVRUBR,
           p_AQPC158AVRVUBR,
           p_AQPC158AVAUBR,
           p_AQPC158AVAVUBR,
           p_AQPC158AVHUBR,
           
           /*p_AQPC158AacMd33,
           p_AQPC158AVRCOOP,
           p_AQPC158AVRVCOP,
           p_AQPC158AVACOOP,
           p_AQPC158AVAVCOP,
           p_AQPC158AVHCOOP,
           
           p_AQPC158AacMd34,
           p_AQPC158AVRSDOI,
           p_AQPC158AVRVSDO,
           p_AQPC158AVASDOI,
           p_AQPC158AVAVSDO,
           p_AQPC158AVHSDOI,
           
           p_AQPC158AacMd35,
           p_AQPC158AVRSDV,
           p_AQPC158AVRVSD,
           p_AQPC158AVASDV,
           p_AQPC158AVAVSDV,
           p_AQPC158AVHSDV,*/
           
           p_AQPC158AacMd36,
           p_AQPC158AVRIMP,
           p_AQPC158AVRVIMP,
           p_AQPC158AVAIMP,
           p_AQPC158AVAVIMP,
           p_AQPC158AVHIMP,
           
           /* p_AQPC158AacMd37,
           p_AQPC158AVROTC,
           p_AQPC158AVRVOTC,
           p_AQPC158AVAOTC,
           p_AQPC158AVAVOTC,
           p_AQPC158AVHOTC,
           
           p_AQPC158AacMd38,
           p_AQPC158AVRRESE,
           p_AQPC158AVRVRES,
           p_AQPC158AVARESE,
           p_AQPC158AVAVRES,
           p_AQPC158AVHRESE,*/
           
           p_AQPC158AacMd39,
           p_AQPC158AVROTI,
           p_AQPC158AVRVOTI,
           p_AQPC158AVAOTI,
           p_AQPC158AVAVOTI,
           p_AQPC158AVHOTI,
           
           p_AQPC158AacMd40,
           p_AQPC158AVRGFM,
           p_AQPC158AVRVGFM,
           p_AQPC158AVAGFM,
           p_AQPC158AVAVGFM,
           p_AQPC158AVHGFM,
           
           /*  p_AQPC158AacMd41,
           p_AQPC158AVRRSCP,
           p_AQPC158AVRVRSC,
           p_AQPC158AVARSCP,
           p_AQPC158AVAVRSC,
           p_AQPC158AVHRSCP,
           
           p_AQPC158AacMd42,
           p_AQPC158AVRMCCP,
           p_AQPC158AVRVMCP,
           p_AQPC158AVAMCCP,
           p_AQPC158AVAVMCC,
           p_AQPC158AVHMCCP, */
           
           p_AQPC158AacMd43,
           p_AQPC158AVRRNET,
           p_AQPC158AVRVRNT,
           p_AQPC158AVARNET,
           p_AQPC158AVAVRNE,
           p_AQPC158AVHRNET,
           
           --ratios
           p_AQPC158ARTLIQ1,
           p_AQPC158ARTRCX1,
           p_AQPC158ATRRDI1,
           p_AQPC158ATREND1,
           p_AQPC158ATRROE1,
           p_AQPC158ATRRCR1,
           
           p_AQPC158ARTLIQ2,
           p_AQPC158ARTRCX2,
           p_AQPC158ATRRDI2,
           p_AQPC158ATREND2,
           p_AQPC158ATRROE2,
           p_AQPC158ATRRCR2,
           p_aqpc158aacmd44,
           p_aqpc158aacrota,
           p_aqpc158aacaota,
           p_aqpc158aarvota,
           p_aqpc158aaavota,
           p_aqpc158aaahota,
           
           p_aqpc158aacmd45,
           p_aqpc158avcrgtv,
           p_aqpc158avcagtv,
           p_aqpc158avrvgtv,
           p_aqpc158avavgtv,
           p_aqpc158avahgtv,
           
           p_aqpc158aacmd46,
           p_aqpc158avrrgad,
           p_aqpc158avargad,
           p_aqpc158avrvgad,
           p_aqpc158avavgad,
           p_aqpc158avhrgad,
           
           p_aqpc158aacmd47,
           p_aqpc158avrruto,
           p_aqpc158avaruto,
           p_aqpc158avrvuto,
           p_aqpc158avavuto,
           p_aqpc158avhruto,
           
           p_aqpc158aacmd48,
           p_aqpc158avrrgfi,
           p_aqpc158avargfi,
           p_aqpc158avrvgfi,
           p_aqpc158avavgfi,
           p_aqpc158avhrgfi,
           
           p_aqpc158aacmd49,
           p_aqpc158avrrigf,
           p_aqpc158avarigf,
           p_aqpc158avrvigf,
           p_aqpc158avavigf,
           p_aqpc158avhrigf,
           
           p_aqpc158aacmd50,
           p_aqpc158avrrgdi,
           p_aqpc158avargdi,
           p_aqpc158avrvgdi,
           p_aqpc158avavgdi,
           p_aqpc158avhrgdi,
           
           p_aqpc158aacmd51,
           p_aqpc158avrruim,
           p_aqpc158avaruim,
           p_aqpc158avrvuim,
           p_aqpc158avavuim,
           p_aqpc158avhruim,
           
           p_aqpc158aacmd52,
           p_aqpc158avrrutn,
           p_aqpc158avarutn,
           p_aqpc158avrvutn,
           p_aqpc158avavutn,
           p_aqpc158avhrutn,
           v_FechaActual,
           v_HoraActual);
        COMMIT;
        flgOk := 'S';
      EXCEPTION
        WHEN OTHERS THEN
          BEGIN
            UPDATE AQPC158
               SET AQPC158Afeere  = p_AQPC158Afeere,
                   AQPC158Afeean  = p_AQPC158Afeean,
                   AQPC158AacMda1 = p_AQPC158AacMda1,
                   AQPC158AacrDis = p_AQPC158AacrDis,
                   AQPC158AarvDis = p_AQPC158AarvDis,
                   AQPC158AacaDis = p_AQPC158AacaDis,
                   AQPC158AaavDis = p_AQPC158AaavDis,
                   AQPC158AaaHDis = p_AQPC158AaaHDis,
                   
                   AQPC158AacMda2 = p_AQPC158AacMda2,
                   AQPC158AacrCxC = p_AQPC158AacrCxC,
                   AQPC158AarvCxC = p_AQPC158AarvCxC,
                   AQPC158AacaCxC = p_AQPC158AacaCxC,
                   AQPC158AaavCxC = p_AQPC158AaavCxC,
                   AQPC158AaaHCxC = p_AQPC158AaaHCxC,
                   
                   AQPC158AacMda3 = p_AQPC158AacMda3,
                   AQPC158AacrMer = p_AQPC158AacrMer,
                   AQPC158AarvMer = p_AQPC158AarvMer,
                   AQPC158AacaMer = p_AQPC158AacaMer,
                   AQPC158AaavMer = p_AQPC158AaavMer,
                   AQPC158AaaHMer = p_AQPC158AaaHMer,
                   
                   AQPC158AacMda4 = p_AQPC158AacMda4,
                   AQPC158Aacrgap = p_AQPC158Aacrgap,
                   AQPC158Aarvgap = p_AQPC158Aarvgap,
                   AQPC158Aacagap = p_AQPC158Aacagap,
                   AQPC158Aaavgap = p_AQPC158Aaavgap,
                   AQPC158AaaHgap = p_AQPC158AaaHgap,
                   
                   AQPC158AacMda5 = p_AQPC158AacMda5,
                   AQPC158AacrExr = p_AQPC158AacrExr,
                   AQPC158AarvExr = p_AQPC158AarvExr,
                   AQPC158AacaExr = p_AQPC158AacaExr,
                   AQPC158AaavExr = p_AQPC158AaavExr,
                   AQPC158AaaHExr = p_AQPC158AaaHExr,
                   
                   AQPC158AacMda7 = p_AQPC158AacMda7,
                   AQPC158AacrTac = p_AQPC158AacrTac,
                   AQPC158AacaTac = p_AQPC158AacaTac,
                   AQPC158AarvTac = p_AQPC158AarvTac,
                   AQPC158AaavTac = p_AQPC158AaavTac,
                   AQPC158AaaHTac = p_AQPC158AaaHTac,
                   
                   AQPC158AacMda8 = p_AQPC158AacMda8,
                   AQPC158Aacrmue = p_AQPC158Aacrmue,
                   AQPC158Aacamue = p_AQPC158Aacamue,
                   AQPC158Aarvmue = p_AQPC158Aarvmue,
                   AQPC158Aaavmue = p_AQPC158Aaavmue,
                   AQPC158AaaHmue = p_AQPC158AaaHmue,
                   
                   AQPC158AacMda9 = p_AQPC158AacMda9,
                   AQPC158Aacrinm = p_AQPC158Aacrinm,
                   AQPC158Aacainm = p_AQPC158Aacainm,
                   AQPC158Aarvinm = p_AQPC158Aarvinm,
                   AQPC158Aaavinm = p_AQPC158Aaavinm,
                   AQPC158AaaHinm = p_AQPC158AaaHinm,
                   
                   AQPC158AacMd10 = p_AQPC158AacMd10,
                   AQPC158AACRot2 = p_AQPC158AACRot2,
                   AQPC158AARVot2 = p_AQPC158AARVot2,
                   AQPC158AACAot2 = p_AQPC158AACAot2,
                   AQPC158AAAVot2 = p_AQPC158AAAVot2,
                   AQPC158AAAHot2 = p_AQPC158AAAHot2,
                   
                   AQPC158AacMd11 = p_AQPC158AacMd11,
                   AQPC158Aacrtaf = p_AQPC158Aacrtaf,
                   AQPC158Aacataf = p_AQPC158Aacataf,
                   AQPC158Aaavtaf = p_AQPC158Aaavtaf,
                   AQPC158AaaHtaf = p_AQPC158AaaHtaf,
                   AQPC158Aarvrta = p_AQPC158Aarvrta,
                   
                   AQPC158AacMd12 = p_AQPC158AacMd12,
                   AQPC158AacrTat = p_AQPC158AacrTat,
                   AQPC158AacaTat = p_AQPC158AacaTat,
                   AQPC158AarvTat = p_AQPC158AarvTat,
                   AQPC158AaavTat = p_AQPC158AaavTat,
                   AQPC158AaaHTat = p_AQPC158AaaHTat,
                   
                   AQPC158AacMd13 = p_AQPC158AacMd13,
                   AQPC158APrcxpC = p_AQPC158APrcxpC,
                   AQPC158APRVCxp = p_AQPC158APRVCxp,
                   AQPC158APAcxpC = p_AQPC158APAcxpC,
                   AQPC158APAVCxp = p_AQPC158APAVCxp,
                   AQPC158APAHCxp = p_AQPC158APAHCxp,
                   
                   AQPC158AacMd14 = p_AQPC158AacMd14,
                   AQPC158APRCXPB = p_AQPC158APRCXPB,
                   AQPC158APRVXPB = p_AQPC158APRVXPB,
                   AQPC158APACXPB = p_AQPC158APACXPB,
                   AQPC158APAVXPB = p_AQPC158APAVXPB,
                   AQPC158APAHXPB = p_AQPC158APAHXPB,
                   
                   AQPC158AacMd15 = p_AQPC158AacMd15,
                   AQPC158APRTXP  = p_AQPC158APRTXP,
                   AQPC158APATXP  = p_AQPC158APATXP,
                   AQPC158APRVTXP = p_AQPC158APRVTXP,
                   AQPC158APAVTXP = p_AQPC158APAVTXP,
                   AQPC158APAHTXP = p_AQPC158APAHTXP,
                   
                   AQPC158AacMd16 = p_AQPC158AacMd16,
                   AQPC158APROTR1 = p_AQPC158APROTR1,
                   AQPC158APAOTR1 = p_AQPC158APAOTR1,
                   AQPC158APAVOT1 = p_AQPC158APAVOT1,
                   AQPC158APAHOT1 = p_AQPC158APAHOT1,
                   AQPC158APRVOT1 = p_AQPC158APRVOT1,
                   
                   AQPC158AacMd17 = p_AQPC158AacMd17,
                   AQPC158APRTPCR = p_AQPC158APRTPCR,
                   AQPC158APRVTPC = p_AQPC158APRVTPC,
                   AQPC158APATPCR = p_AQPC158APATPCR,
                   AQPC158APAVTPC = p_AQPC158APAVTPC,
                   AQPC158APAHTPC = p_AQPC158APAHTPC,
                   
                   AQPC158AacMd18 = p_AQPC158AacMd18,
                   AQPC158APRCXLP = p_AQPC158APRCXLP,
                   AQPC158APRVCXL = p_AQPC158APRVCXL,
                   AQPC158APACXLP = p_AQPC158APACXLP,
                   AQPC158APAVCXL = p_AQPC158APAVCXL,
                   AQPC158APAHCXL = p_AQPC158APAHCXL,
                   
                   AQPC158AacMd19 = p_AQPC158AacMd19,
                   AQPC158APRBST  = p_AQPC158APRBST,
                   AQPC158APRVBST = p_AQPC158APRVBST,
                   AQPC158APABST  = p_AQPC158APABST,
                   AQPC158APAVBST = p_AQPC158APAVBST,
                   AQPC158APAHBST = p_AQPC158APAHBST,
                   
                   AQPC158AacMd20 = p_AQPC158AacMd20,
                   AQPC158APROTR2 = p_AQPC158APROTR2,
                   AQPC158APRVOT2 = p_AQPC158APRVOT2,
                   AQPC158APAOTR2 = p_AQPC158APAOTR2,
                   AQPC158APAVOT2 = p_AQPC158APAVOT2,
                   AQPC158APAHOT2 = p_AQPC158APAHOT2,
                   
                   AQPC158AacMd21 = p_AQPC158AacMd21,
                   AQPC158APRPNCO = p_AQPC158APRPNCO,
                   AQPC158APRVPNC = p_AQPC158APRVPNC,
                   AQPC158APAPNCO = p_AQPC158APAPNCO,
                   AQPC158APAVPNC = p_AQPC158APAVPNC,
                   AQPC158APAHPNC = p_AQPC158APAHPNC,
                   
                   AQPC158AacMd22 = p_AQPC158AacMd22,
                   AQPC158APRTTPA = p_AQPC158APRTTPA,
                   AQPC158APRVTTP = p_AQPC158APRVTTP,
                   AQPC158APATTPA = p_AQPC158APATTPA,
                   AQPC158APAVTTP = p_AQPC158APAVTTP,
                   AQPC158APAHTTP = p_AQPC158APAHTTP,
                   
                   AQPC158AacMd23 = p_AQPC158AacMd23,
                   AQPC158APRCAP  = p_AQPC158APRCAP,
                   AQPC158APRVCAP = p_AQPC158APRVCAP,
                   AQPC158APACAP  = p_AQPC158APACAP,
                   AQPC158APAVCAP = p_AQPC158APAVCAP,
                   AQPC158APAHCAP = p_AQPC158APAHCAP,
                   
                   AQPC158AacMd24 = p_AQPC158AacMd24,
                   AQPC158APRRESE = p_AQPC158APRRESE,
                   AQPC158APRVRES = p_AQPC158APRVRES,
                   AQPC158APARESE = p_AQPC158APARESE,
                   AQPC158APAVRES = p_AQPC158APAVRES,
                   AQPC158APAHRES = p_AQPC158APAHRES,
                   
                   AQPC158AacMd25 = p_AQPC158AacMd25,
                   AQPC158APRREAC = p_AQPC158APRREAC,
                   AQPC158APRVREA = p_AQPC158APRVREA,
                   AQPC158APAREAC = p_AQPC158APAREAC,
                   AQPC158APAVREA = p_AQPC158APAVREA,
                   AQPC158APAHREA = p_AQPC158APAHREA,
                   
                   AQPC158AacMd26 = p_AQPC158AacMd26,
                   AQPC158APRRDEJ = p_AQPC158APRRDEJ,
                   AQPC158APRVRDE = p_AQPC158APRVRDE,
                   AQPC158APAVRDE = p_AQPC158APAVRDE,
                   AQPC158APARDEJ = p_AQPC158APARDEJ,
                   AQPC158APAHRDE = p_AQPC158APAHRDE,
                   
                   AQPC158AacMd27 = p_AQPC158AacMd27,
                   AQPC158APROTR3 = p_AQPC158APROTR3,
                   AQPC158APRVOT3 = p_AQPC158APRVOT3,
                   AQPC158APAOTR3 = p_AQPC158APAOTR3,
                   AQPC158APAVOT3 = p_AQPC158APAVOT3,
                   AQPC158APAHOT3 = p_AQPC158APAHOT3,
                   
                   AQPC158AacMd28 = p_AQPC158AacMd28,
                   AQPC158APRPATR = p_AQPC158APRPATR,
                   AQPC158APRVPAT = p_AQPC158APRVPAT,
                   AQPC158APAPATR = p_AQPC158APAPATR,
                   AQPC158APAVPAT = p_AQPC158APAVPAT,
                   AQPC158APAHPAT = p_AQPC158APAHPAT,
                   
                   AQPC158AacMd29 = p_AQPC158AacMd29,
                   AQPC158APRTTPP = p_AQPC158APRTTPP,
                   AQPC158APRVTPP = p_AQPC158APRVTPP,
                   AQPC158APATTPP = p_AQPC158APATTPP,
                   AQPC158APAVTPP = p_AQPC158APAVTPP,
                   AQPC158APAHTPP = p_AQPC158APAHTPP,
                   
                   AQPC158AacMd30 = p_AQPC158AacMd30,
                   AQPC158AVRVEN  = p_AQPC158AVRVEN,
                   AQPC158AVRVVEN = p_AQPC158AVRVVEN,
                   AQPC158AVAVEN  = p_AQPC158AVAVEN,
                   AQPC158AVAVVEN = p_AQPC158AVAVVEN,
                   AQPC158AVAHVEN = p_AQPC158AVAHVEN,
                   
                   AQPC158AacMd31 = p_AQPC158AacMd31,
                   AQPC158AVRCOSV = p_AQPC158AVRCOSV,
                   AQPC158AVRVCSV = p_AQPC158AVRVCSV,
                   AQPC158AVACOSV = p_AQPC158AVACOSV,
                   AQPC158AVAVCSV = p_AQPC158AVAVCSV,
                   AQPC158AVHCOSV = p_AQPC158AVHCOSV,
                   
                   AQPC158AacMd32 = p_AQPC158AacMd32,
                   AQPC158AVRUBR  = p_AQPC158AVRUBR,
                   AQPC158AVRVUBR = p_AQPC158AVRVUBR,
                   AQPC158AVAUBR  = p_AQPC158AVAUBR,
                   AQPC158AVAVUBR = p_AQPC158AVAVUBR,
                   AQPC158AVHUBR  = p_AQPC158AVHUBR,
                   
                   AQPC158AacMd36 = p_AQPC158AacMd36,
                   AQPC158AVRIMP  = p_AQPC158AVRIMP,
                   AQPC158AVRVIMP = p_AQPC158AVRVIMP,
                   AQPC158AVAIMP  = p_AQPC158AVAIMP,
                   AQPC158AVAVIMP = p_AQPC158AVAVIMP,
                   AQPC158AVHIMP  = p_AQPC158AVHIMP,
                   
                   AQPC158AacMd39 = p_AQPC158AacMd39,
                   AQPC158AVROTI  = p_AQPC158AVROTI,
                   AQPC158AVRVOTI = p_AQPC158AVRVOTI,
                   AQPC158AVAOTI  = p_AQPC158AVAOTI,
                   AQPC158AVAVOTI = p_AQPC158AVAVOTI,
                   AQPC158AVHOTI  = p_AQPC158AVHOTI,
                   
                   AQPC158AacMd40 = p_AQPC158AacMd40,
                   AQPC158AVRGFM  = p_AQPC158AVRGFM,
                   AQPC158AVRVGFM = p_AQPC158AVRVGFM,
                   AQPC158AVAGFM  = p_AQPC158AVAGFM,
                   AQPC158AVAVGFM = p_AQPC158AVAVGFM,
                   AQPC158AVHGFM  = p_AQPC158AVHGFM,
                   
                   AQPC158AacMd43 = p_AQPC158AacMd43,
                   AQPC158AVRRNET = p_AQPC158AVRRNET,
                   AQPC158AVRVRNT = p_AQPC158AVRVRNT,
                   AQPC158AVARNET = p_AQPC158AVARNET,
                   AQPC158AVAVRNE = p_AQPC158AVAVRNE,
                   AQPC158AVHRNET = p_AQPC158AVHRNET,
                   
                   AQPC158ARTLIQ1 = p_AQPC158ARTLIQ1,
                   AQPC158ARTRCX1 = p_AQPC158ARTRCX1,
                   AQPC158ATRRDI1 = p_AQPC158ATRRDI1,
                   AQPC158ATREND1 = p_AQPC158ATREND1,
                   AQPC158ATRROE1 = p_AQPC158ATRROE1,
                   AQPC158ATRRCR1 = p_AQPC158ATRRCR1,
                   
                   AQPC158ARTLIQ2 = p_AQPC158ARTLIQ2,
                   AQPC158ARTRCX2 = p_AQPC158ARTRCX2,
                   AQPC158ATRRDI2 = p_AQPC158ATRRDI2,
                   AQPC158ATREND2 = p_AQPC158ATREND2,
                   AQPC158ATRROE2 = p_AQPC158ATRROE2,
                   AQPC158ATRRCR2 = p_AQPC158ATRRCR2,
                   --nuevos campos
                   aqpc158aacmd44 = p_aqpc158aacmd44,
                   aqpc158aacrota = p_aqpc158aacrota,
                   aqpc158aacaota = p_aqpc158aacaota,
                   aqpc158aarvota = p_aqpc158aarvota,
                   aqpc158aaavota = p_aqpc158aaavota,
                   aqpc158aaahota = p_aqpc158aaahota,
                   
                   aqpc158aacmd45 = p_aqpc158aacmd45,
                   aqpc158avcrgtv = p_aqpc158avcrgtv,
                   aqpc158avcagtv = p_aqpc158avcagtv,
                   aqpc158avrvgtv = p_aqpc158avrvgtv,
                   aqpc158avavgtv = p_aqpc158avavgtv,
                   aqpc158avahgtv = p_aqpc158avahgtv,
                   
                   aqpc158aacmd46 = p_aqpc158aacmd46,
                   aqpc158avrrgad = p_aqpc158avrrgad,
                   aqpc158avargad = p_aqpc158avargad,
                   aqpc158avrvgad = p_aqpc158avrvgad,
                   aqpc158avavgad = p_aqpc158avavgad,
                   aqpc158avhrgad = p_aqpc158avhrgad,
                   
                   aqpc158aacmd47 = p_aqpc158aacmd47,
                   aqpc158avrruto = p_aqpc158avrruto,
                   aqpc158avaruto = p_aqpc158avaruto,
                   aqpc158avrvuto = p_aqpc158avrvuto,
                   aqpc158avavuto = p_aqpc158avavuto,
                   aqpc158avhruto = p_aqpc158avhruto,
                   
                   aqpc158aacmd48 = p_aqpc158aacmd48,
                   aqpc158avrrgfi = p_aqpc158avrrgfi,
                   aqpc158avargfi = p_aqpc158avargfi,
                   aqpc158avrvgfi = p_aqpc158avrvgfi,
                   aqpc158avavgfi = p_aqpc158avavgfi,
                   aqpc158avhrgfi = p_aqpc158avhrgfi,
                   
                   aqpc158aacmd49 = p_aqpc158aacmd49,
                   aqpc158avrrigf = p_aqpc158avrrigf,
                   aqpc158avarigf = p_aqpc158avarigf,
                   aqpc158avrvigf = p_aqpc158avrvigf,
                   aqpc158avavigf = p_aqpc158avavigf,
                   aqpc158avhrigf = p_aqpc158avhrigf,
                   
                   aqpc158aacmd50 = p_aqpc158aacmd50,
                   aqpc158avrrgdi = p_aqpc158avrrgdi,
                   aqpc158avargdi = p_aqpc158avargdi,
                   aqpc158avrvgdi = p_aqpc158avrvgdi,
                   aqpc158avavgdi = p_aqpc158avavgdi,
                   aqpc158avhrgdi = p_aqpc158avhrgdi,
                   
                   aqpc158aacmd51 = p_aqpc158aacmd51,
                   aqpc158avrruim = p_aqpc158avrruim,
                   aqpc158avaruim = p_aqpc158avaruim,
                   aqpc158avrvuim = p_aqpc158avrvuim,
                   aqpc158avavuim = p_aqpc158avavuim,
                   aqpc158avhruim = p_aqpc158avhruim,
                   
                   aqpc158aacmd52 = p_aqpc158aacmd52,
                   aqpc158avrrutn = p_aqpc158avrrutn,
                   aqpc158avarutn = p_aqpc158avarutn,
                   aqpc158avrvutn = p_aqpc158avrvutn,
                   aqpc158avavutn = p_aqpc158avavutn,
                   aqpc158avhrutn = p_aqpc158avhrutn
             WHERE AQPC158CODOPI = p_AQPC158CODOPI;
            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
      END;
    END IF;
  
    IF p_Modo = 'U' THEN
      BEGIN
        UPDATE AQPC158
           SET --AQPC158CODOPI  =  p_AQPC158CODOPI   ,   
               AQPC158Afeere = p_AQPC158Afeere,
               AQPC158Afeean  = p_AQPC158Afeean,
               AQPC158AacMda1 = p_AQPC158AacMda1,
               AQPC158AacrDis = p_AQPC158AacrDis,
               AQPC158AarvDis = p_AQPC158AarvDis,
               AQPC158AacaDis = p_AQPC158AacaDis,
               AQPC158AaavDis = p_AQPC158AaavDis,
               AQPC158AaaHDis = p_AQPC158AaaHDis,
               
               AQPC158AacMda2 = p_AQPC158AacMda2,
               AQPC158AacrCxC = p_AQPC158AacrCxC,
               AQPC158AarvCxC = p_AQPC158AarvCxC,
               AQPC158AacaCxC = p_AQPC158AacaCxC,
               AQPC158AaavCxC = p_AQPC158AaavCxC,
               AQPC158AaaHCxC = p_AQPC158AaaHCxC,
               
               AQPC158AacMda3 = p_AQPC158AacMda3,
               AQPC158AacrMer = p_AQPC158AacrMer,
               AQPC158AarvMer = p_AQPC158AarvMer,
               AQPC158AacaMer = p_AQPC158AacaMer,
               AQPC158AaavMer = p_AQPC158AaavMer,
               AQPC158AaaHMer = p_AQPC158AaaHMer,
               
               AQPC158AacMda4 = p_AQPC158AacMda4,
               AQPC158Aacrgap = p_AQPC158Aacrgap,
               AQPC158Aarvgap = p_AQPC158Aarvgap,
               AQPC158Aacagap = p_AQPC158Aacagap,
               AQPC158Aaavgap = p_AQPC158Aaavgap,
               AQPC158AaaHgap = p_AQPC158AaaHgap,
               
               AQPC158AacMda5 = p_AQPC158AacMda5,
               AQPC158AacrExr = p_AQPC158AacrExr,
               AQPC158AarvExr = p_AQPC158AarvExr,
               AQPC158AacaExr = p_AQPC158AacaExr,
               AQPC158AaavExr = p_AQPC158AaavExr,
               AQPC158AaaHExr = p_AQPC158AaaHExr,
               
               /*AQPC158AacMda6 = p_AQPC158AacMda6,
               AQPC158AacrOt1 = p_AQPC158AacrOt1,
               AQPC158AarvOt1 = p_AQPC158AarvOt1,
               AQPC158AacaOt1 = p_AQPC158AacaOt1,
               AQPC158AaavOt1 = p_AQPC158AaavOt1,
               AQPC158AaaHOt1 = p_AQPC158AaaHOt1,*/
               
               AQPC158AacMda7 = p_AQPC158AacMda7,
               AQPC158AacrTac = p_AQPC158AacrTac,
               AQPC158AacaTac = p_AQPC158AacaTac,
               AQPC158AarvTac = p_AQPC158AarvTac,
               AQPC158AaavTac = p_AQPC158AaavTac,
               AQPC158AaaHTac = p_AQPC158AaaHTac,
               
               AQPC158AacMda8 = p_AQPC158AacMda8,
               AQPC158Aacrmue = p_AQPC158Aacrmue,
               AQPC158Aacamue = p_AQPC158Aacamue,
               AQPC158Aarvmue = p_AQPC158Aarvmue,
               AQPC158Aaavmue = p_AQPC158Aaavmue,
               AQPC158AaaHmue = p_AQPC158AaaHmue,
               
               AQPC158AacMda9 = p_AQPC158AacMda9,
               AQPC158Aacrinm = p_AQPC158Aacrinm,
               AQPC158Aacainm = p_AQPC158Aacainm,
               AQPC158Aarvinm = p_AQPC158Aarvinm,
               AQPC158Aaavinm = p_AQPC158Aaavinm,
               AQPC158AaaHinm = p_AQPC158AaaHinm,
               
               AQPC158AacMd10 = p_AQPC158AacMd10,
               AQPC158AACRot2 = p_AQPC158AACRot2,
               AQPC158AARVot2 = p_AQPC158AARVot2,
               AQPC158AACAot2 = p_AQPC158AACAot2,
               AQPC158AAAVot2 = p_AQPC158AAAVot2,
               AQPC158AAAHot2 = p_AQPC158AAAHot2,
               
               AQPC158AacMd11 = p_AQPC158AacMd11,
               AQPC158Aacrtaf = p_AQPC158Aacrtaf,
               AQPC158Aacataf = p_AQPC158Aacataf,
               AQPC158Aaavtaf = p_AQPC158Aaavtaf,
               AQPC158AaaHtaf = p_AQPC158AaaHtaf,
               AQPC158Aarvrta = p_AQPC158Aarvrta,
               
               AQPC158AacMd12 = p_AQPC158AacMd12,
               AQPC158AacrTat = p_AQPC158AacrTat,
               AQPC158AacaTat = p_AQPC158AacaTat,
               AQPC158AarvTat = p_AQPC158AarvTat,
               AQPC158AaavTat = p_AQPC158AaavTat,
               AQPC158AaaHTat = p_AQPC158AaaHTat,
               
               AQPC158AacMd13 = p_AQPC158AacMd13,
               AQPC158APrcxpC = p_AQPC158APrcxpC,
               AQPC158APRVCxp = p_AQPC158APRVCxp,
               AQPC158APAcxpC = p_AQPC158APAcxpC,
               AQPC158APAVCxp = p_AQPC158APAVCxp,
               AQPC158APAHCxp = p_AQPC158APAHCxp,
               
               AQPC158AacMd14 = p_AQPC158AacMd14,
               AQPC158APRCXPB = p_AQPC158APRCXPB,
               AQPC158APRVXPB = p_AQPC158APRVXPB,
               AQPC158APACXPB = p_AQPC158APACXPB,
               AQPC158APAVXPB = p_AQPC158APAVXPB,
               AQPC158APAHXPB = p_AQPC158APAHXPB,
               
               AQPC158AacMd15 = p_AQPC158AacMd15,
               AQPC158APRTXP  = p_AQPC158APRTXP,
               AQPC158APATXP  = p_AQPC158APATXP,
               AQPC158APRVTXP = p_AQPC158APRVTXP,
               AQPC158APAVTXP = p_AQPC158APAVTXP,
               AQPC158APAHTXP = p_AQPC158APAHTXP,
               
               AQPC158AacMd16 = p_AQPC158AacMd16,
               AQPC158APROTR1 = p_AQPC158APROTR1,
               AQPC158APAOTR1 = p_AQPC158APAOTR1,
               AQPC158APAVOT1 = p_AQPC158APAVOT1,
               AQPC158APAHOT1 = p_AQPC158APAHOT1,
               AQPC158APRVOT1 = p_AQPC158APRVOT1,
               
               AQPC158AacMd17 = p_AQPC158AacMd17,
               AQPC158APRTPCR = p_AQPC158APRTPCR,
               AQPC158APRVTPC = p_AQPC158APRVTPC,
               AQPC158APATPCR = p_AQPC158APATPCR,
               AQPC158APAVTPC = p_AQPC158APAVTPC,
               AQPC158APAHTPC = p_AQPC158APAHTPC,
               
               AQPC158AacMd18 = p_AQPC158AacMd18,
               AQPC158APRCXLP = p_AQPC158APRCXLP,
               AQPC158APRVCXL = p_AQPC158APRVCXL,
               AQPC158APACXLP = p_AQPC158APACXLP,
               AQPC158APAVCXL = p_AQPC158APAVCXL,
               AQPC158APAHCXL = p_AQPC158APAHCXL,
               
               AQPC158AacMd19 = p_AQPC158AacMd19,
               AQPC158APRBST  = p_AQPC158APRBST,
               AQPC158APRVBST = p_AQPC158APRVBST,
               AQPC158APABST  = p_AQPC158APABST,
               AQPC158APAVBST = p_AQPC158APAVBST,
               AQPC158APAHBST = p_AQPC158APAHBST,
               
               AQPC158AacMd20 = p_AQPC158AacMd20,
               AQPC158APROTR2 = p_AQPC158APROTR2,
               AQPC158APRVOT2 = p_AQPC158APRVOT2,
               AQPC158APAOTR2 = p_AQPC158APAOTR2,
               AQPC158APAVOT2 = p_AQPC158APAVOT2,
               AQPC158APAHOT2 = p_AQPC158APAHOT2,
               
               AQPC158AacMd21 = p_AQPC158AacMd21,
               AQPC158APRPNCO = p_AQPC158APRPNCO,
               AQPC158APRVPNC = p_AQPC158APRVPNC,
               AQPC158APAPNCO = p_AQPC158APAPNCO,
               AQPC158APAVPNC = p_AQPC158APAVPNC,
               AQPC158APAHPNC = p_AQPC158APAHPNC,
               
               AQPC158AacMd22 = p_AQPC158AacMd22,
               AQPC158APRTTPA = p_AQPC158APRTTPA,
               AQPC158APRVTTP = p_AQPC158APRVTTP,
               AQPC158APATTPA = p_AQPC158APATTPA,
               AQPC158APAVTTP = p_AQPC158APAVTTP,
               AQPC158APAHTTP = p_AQPC158APAHTTP,
               
               AQPC158AacMd23 = p_AQPC158AacMd23,
               AQPC158APRCAP  = p_AQPC158APRCAP,
               AQPC158APRVCAP = p_AQPC158APRVCAP,
               AQPC158APACAP  = p_AQPC158APACAP,
               AQPC158APAVCAP = p_AQPC158APAVCAP,
               AQPC158APAHCAP = p_AQPC158APAHCAP,
               
               AQPC158AacMd24 = p_AQPC158AacMd24,
               AQPC158APRRESE = p_AQPC158APRRESE,
               AQPC158APRVRES = p_AQPC158APRVRES,
               AQPC158APARESE = p_AQPC158APARESE,
               AQPC158APAVRES = p_AQPC158APAVRES,
               AQPC158APAHRES = p_AQPC158APAHRES,
               
               AQPC158AacMd25 = p_AQPC158AacMd25,
               AQPC158APRREAC = p_AQPC158APRREAC,
               AQPC158APRVREA = p_AQPC158APRVREA,
               AQPC158APAREAC = p_AQPC158APAREAC,
               AQPC158APAVREA = p_AQPC158APAVREA,
               AQPC158APAHREA = p_AQPC158APAHREA,
               
               AQPC158AacMd26 = p_AQPC158AacMd26,
               AQPC158APRRDEJ = p_AQPC158APRRDEJ,
               AQPC158APRVRDE = p_AQPC158APRVRDE,
               AQPC158APAVRDE = p_AQPC158APAVRDE,
               AQPC158APARDEJ = p_AQPC158APARDEJ,
               AQPC158APAHRDE = p_AQPC158APAHRDE,
               
               AQPC158AacMd27 = p_AQPC158AacMd27,
               AQPC158APROTR3 = p_AQPC158APROTR3,
               AQPC158APRVOT3 = p_AQPC158APRVOT3,
               AQPC158APAOTR3 = p_AQPC158APAOTR3,
               AQPC158APAVOT3 = p_AQPC158APAVOT3,
               AQPC158APAHOT3 = p_AQPC158APAHOT3,
               
               AQPC158AacMd28 = p_AQPC158AacMd28,
               AQPC158APRPATR = p_AQPC158APRPATR,
               AQPC158APRVPAT = p_AQPC158APRVPAT,
               AQPC158APAPATR = p_AQPC158APAPATR,
               AQPC158APAVPAT = p_AQPC158APAVPAT,
               AQPC158APAHPAT = p_AQPC158APAHPAT,
               
               AQPC158AacMd29 = p_AQPC158AacMd29,
               AQPC158APRTTPP = p_AQPC158APRTTPP,
               AQPC158APRVTPP = p_AQPC158APRVTPP,
               AQPC158APATTPP = p_AQPC158APATTPP,
               AQPC158APAVTPP = p_AQPC158APAVTPP,
               AQPC158APAHTPP = p_AQPC158APAHTPP,
               
               AQPC158AacMd30 = p_AQPC158AacMd30,
               AQPC158AVRVEN  = p_AQPC158AVRVEN,
               AQPC158AVRVVEN = p_AQPC158AVRVVEN,
               AQPC158AVAVEN  = p_AQPC158AVAVEN,
               AQPC158AVAVVEN = p_AQPC158AVAVVEN,
               AQPC158AVAHVEN = p_AQPC158AVAHVEN,
               
               AQPC158AacMd31 = p_AQPC158AacMd31,
               AQPC158AVRCOSV = p_AQPC158AVRCOSV,
               AQPC158AVRVCSV = p_AQPC158AVRVCSV,
               AQPC158AVACOSV = p_AQPC158AVACOSV,
               AQPC158AVAVCSV = p_AQPC158AVAVCSV,
               AQPC158AVHCOSV = p_AQPC158AVHCOSV,
               
               AQPC158AacMd32 = p_AQPC158AacMd32,
               AQPC158AVRUBR  = p_AQPC158AVRUBR,
               AQPC158AVRVUBR = p_AQPC158AVRVUBR,
               AQPC158AVAUBR  = p_AQPC158AVAUBR,
               AQPC158AVAVUBR = p_AQPC158AVAVUBR,
               AQPC158AVHUBR  = p_AQPC158AVHUBR,
               
               /* AQPC158AacMd33 = p_AQPC158AacMd33,
               AQPC158AVRCOOP = p_AQPC158AVRCOOP,
               AQPC158AVRVCOP = p_AQPC158AVRVCOP,
               AQPC158AVACOOP = p_AQPC158AVACOOP,
               AQPC158AVAVCOP = p_AQPC158AVAVCOP,
               AQPC158AVHCOOP = p_AQPC158AVHCOOP,
               
               AQPC158AacMd34 = p_AQPC158AacMd34,
               AQPC158AVRSDOI = p_AQPC158AVRSDOI,
               AQPC158AVRVSDO = p_AQPC158AVRVSDO,
               AQPC158AVASDOI = p_AQPC158AVASDOI,
               AQPC158AVAVSDO = p_AQPC158AVAVSDO,
               AQPC158AVHSDOI = p_AQPC158AVHSDOI,
               
               AQPC158AacMd35 = p_AQPC158AacMd35,
               AQPC158AVRSDV  = p_AQPC158AVRSDV,
               AQPC158AVRVSD  = p_AQPC158AVRVSD,
               AQPC158AVASDV  = p_AQPC158AVASDV,
               AQPC158AVAVSDV = p_AQPC158AVAVSDV,
               AQPC158AVHSDV  = p_AQPC158AVHSDV, */
               
               AQPC158AacMd36 = p_AQPC158AacMd36,
               AQPC158AVRIMP  = p_AQPC158AVRIMP,
               AQPC158AVRVIMP = p_AQPC158AVRVIMP,
               AQPC158AVAIMP  = p_AQPC158AVAIMP,
               AQPC158AVAVIMP = p_AQPC158AVAVIMP,
               AQPC158AVHIMP  = p_AQPC158AVHIMP,
               
               /*   AQPC158AacMd37 = p_AQPC158AacMd37,
               AQPC158AVROTC  = p_AQPC158AVROTC,
               AQPC158AVRVOTC = p_AQPC158AVRVOTC,
               AQPC158AVAOTC  = p_AQPC158AVAOTC,
               AQPC158AVAVOTC = p_AQPC158AVAVOTC,
               AQPC158AVHOTC  = p_AQPC158AVHOTC,
               
               AQPC158AacMd38 = p_AQPC158AacMd38,
               AQPC158AVRRESE = p_AQPC158AVRRESE,
               AQPC158AVRVRES = p_AQPC158AVRVRES,
               AQPC158AVARESE = p_AQPC158AVARESE,
               AQPC158AVAVRES = p_AQPC158AVAVRES,
               AQPC158AVHRESE = p_AQPC158AVHRESE, */
               
               AQPC158AacMd39 = p_AQPC158AacMd39,
               AQPC158AVROTI  = p_AQPC158AVROTI,
               AQPC158AVRVOTI = p_AQPC158AVRVOTI,
               AQPC158AVAOTI  = p_AQPC158AVAOTI,
               AQPC158AVAVOTI = p_AQPC158AVAVOTI,
               AQPC158AVHOTI  = p_AQPC158AVHOTI,
               
               AQPC158AacMd40 = p_AQPC158AacMd40,
               AQPC158AVRGFM  = p_AQPC158AVRGFM,
               AQPC158AVRVGFM = p_AQPC158AVRVGFM,
               AQPC158AVAGFM  = p_AQPC158AVAGFM,
               AQPC158AVAVGFM = p_AQPC158AVAVGFM,
               AQPC158AVHGFM  = p_AQPC158AVHGFM,
               
               /* AQPC158AacMd41 = p_AQPC158AacMd41,
               AQPC158AVRRSCP = p_AQPC158AVRRSCP,
               AQPC158AVRVRSC = p_AQPC158AVRVRSC,
               AQPC158AVARSCP = p_AQPC158AVARSCP,
               AQPC158AVAVRSC = p_AQPC158AVAVRSC,
               AQPC158AVHRSCP = p_AQPC158AVHRSCP,
               
               AQPC158AacMd42 = p_AQPC158AacMd42,
               AQPC158AVRMCCP = p_AQPC158AVRMCCP,
               AQPC158AVRVMCP = p_AQPC158AVRVMCP,
               AQPC158AVAMCCP = p_AQPC158AVAMCCP,
               AQPC158AVAVMCC = p_AQPC158AVAVMCC,
               AQPC158AVHMCCP = p_AQPC158AVHMCCP, */
               
               AQPC158AacMd43 = p_AQPC158AacMd43,
               AQPC158AVRRNET = p_AQPC158AVRRNET,
               AQPC158AVRVRNT = p_AQPC158AVRVRNT,
               AQPC158AVARNET = p_AQPC158AVARNET,
               AQPC158AVAVRNE = p_AQPC158AVAVRNE,
               AQPC158AVHRNET = p_AQPC158AVHRNET,
               
               AQPC158ARTLIQ1 = p_AQPC158ARTLIQ1,
               AQPC158ARTRCX1 = p_AQPC158ARTRCX1,
               AQPC158ATRRDI1 = p_AQPC158ATRRDI1,
               AQPC158ATREND1 = p_AQPC158ATREND1,
               AQPC158ATRROE1 = p_AQPC158ATRROE1,
               AQPC158ATRRCR1 = p_AQPC158ATRRCR1,
               
               AQPC158ARTLIQ2 = p_AQPC158ARTLIQ2,
               AQPC158ARTRCX2 = p_AQPC158ARTRCX2,
               AQPC158ATRRDI2 = p_AQPC158ATRRDI2,
               AQPC158ATREND2 = p_AQPC158ATREND2,
               AQPC158ATRROE2 = p_AQPC158ATRROE2,
               AQPC158ATRRCR2 = p_AQPC158ATRRCR2,
               --nuevos campos
               aqpc158aacmd44 = p_aqpc158aacmd44,
               aqpc158aacrota = p_aqpc158aacrota,
               aqpc158aacaota = p_aqpc158aacaota,
               aqpc158aarvota = p_aqpc158aarvota,
               aqpc158aaavota = p_aqpc158aaavota,
               aqpc158aaahota = p_aqpc158aaahota,
               
               aqpc158aacmd45 = p_aqpc158aacmd45,
               aqpc158avcrgtv = p_aqpc158avcrgtv,
               aqpc158avcagtv = p_aqpc158avcagtv,
               aqpc158avrvgtv = p_aqpc158avrvgtv,
               aqpc158avavgtv = p_aqpc158avavgtv,
               aqpc158avahgtv = p_aqpc158avahgtv,
               
               aqpc158aacmd46 = p_aqpc158aacmd46,
               aqpc158avrrgad = p_aqpc158avrrgad,
               aqpc158avargad = p_aqpc158avargad,
               aqpc158avrvgad = p_aqpc158avrvgad,
               aqpc158avavgad = p_aqpc158avavgad,
               aqpc158avhrgad = p_aqpc158avhrgad,
               
               aqpc158aacmd47 = p_aqpc158aacmd47,
               aqpc158avrruto = p_aqpc158avrruto,
               aqpc158avaruto = p_aqpc158avaruto,
               aqpc158avrvuto = p_aqpc158avrvuto,
               aqpc158avavuto = p_aqpc158avavuto,
               aqpc158avhruto = p_aqpc158avhruto,
               
               aqpc158aacmd48 = p_aqpc158aacmd48,
               aqpc158avrrgfi = p_aqpc158avrrgfi,
               aqpc158avargfi = p_aqpc158avargfi,
               aqpc158avrvgfi = p_aqpc158avrvgfi,
               aqpc158avavgfi = p_aqpc158avavgfi,
               aqpc158avhrgfi = p_aqpc158avhrgfi,
               
               aqpc158aacmd49 = p_aqpc158aacmd49,
               aqpc158avrrigf = p_aqpc158avrrigf,
               aqpc158avarigf = p_aqpc158avarigf,
               aqpc158avrvigf = p_aqpc158avrvigf,
               aqpc158avavigf = p_aqpc158avavigf,
               aqpc158avhrigf = p_aqpc158avhrigf,
               
               aqpc158aacmd50 = p_aqpc158aacmd50,
               aqpc158avrrgdi = p_aqpc158avrrgdi,
               aqpc158avargdi = p_aqpc158avargdi,
               aqpc158avrvgdi = p_aqpc158avrvgdi,
               aqpc158avavgdi = p_aqpc158avavgdi,
               aqpc158avhrgdi = p_aqpc158avhrgdi,
               
               aqpc158aacmd51 = p_aqpc158aacmd51,
               aqpc158avrruim = p_aqpc158avrruim,
               aqpc158avaruim = p_aqpc158avaruim,
               aqpc158avrvuim = p_aqpc158avrvuim,
               aqpc158avavuim = p_aqpc158avavuim,
               aqpc158avhruim = p_aqpc158avhruim,
               
               aqpc158aacmd52 = p_aqpc158aacmd52,
               aqpc158avrrutn = p_aqpc158avrrutn,
               aqpc158avarutn = p_aqpc158avarutn,
               aqpc158avrvutn = p_aqpc158avrvutn,
               aqpc158avavutn = p_aqpc158avavutn,
               aqpc158avhrutn = p_aqpc158avhrutn
         WHERE AQPC158CODOPI = p_AQPC158CODOPI;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
    END IF;
  
  End;

  procedure sp_obtcorr_aqpc156(Instancia number, CodOpinion out number) is
    --mod 24072023
    auxCorr       number(10);
    flgExis       varchar2(1);
    auxCodOpini   number(10);
    auxCod        number(10);
    codOpiniAsign number(10);
    auxHora       varchar2(10);
    auxFechaHoy   Date;
    valExis156    varchar2(1);
  begin
    auxCorr := 0;
    BEGIN
      DELETE FROM AQPC815 WHERE AQPC815INSTAN = Instancia;
      COMMIT;
    END;
    codOpiniAsign := 0;
    CodOpinion    := 0;
    BEGIN
      SELECT AQPC815CODOPIN
        into codOpiniAsign
        FROM AQPC815
       WHERE AQPC815INSTAN = Instancia;
    EXCEPTION
      WHEN OTHERS THEN
        codOpiniAsign := 0;
    END;
  
    IF codOpiniAsign IS NULL THEN
      codOpiniAsign := 0;
    END IF;
  
    IF codOpiniAsign = 0 THEN
      valExis156 := 'S';
      WHILE (valExis156 = 'S') LOOP
        auxCorr := 0;
        BEGIN
          SELECT MAX(F.AQPC815CODOPIN) INTO auxCorr FROM AQPC815 F;
        EXCEPTION
          WHEN OTHERS THEN
            auxCorr := 0;
        END;
        IF auxCorr IS NULL THEN
          auxCorr := 0;
        END IF;
      
        auxCorr := auxCorr + 1;
      
        auxHora     := to_char(SYSDATE, 'HH24:MI:SS');
        auxFechaHoy := to_date(SYSDATE, 'dd/mm/rrrr');
      
        -- Validar si existe
        valExis156 := 'N';
        BEGIN
          SELECT 'S'
            INTO valExis156
            FROM AQPC815 F
           WHERE F.AQPC815CODOPIN = auxCorr
             and rownum < 2;
        EXCEPTION
          WHEN OTHERS THEN
            valExis156 := 'N';
        END;
      
      END LOOP; --
    
      IF auxCorr > 0 THEN
        BEGIN
          INSERT INTO AQPC815
            (AQPC815CODOPIN, AQPC815INSTAN, AQPC815FECHA, AQPC815HORA)
          VALUES
            (auxCorr, Instancia, auxFechaHoy, auxHora);
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            BEGIN
              auxCorr := auxCorr + 1;
              INSERT INTO AQPC815
                (AQPC815CODOPIN, AQPC815INSTAN, AQPC815FECHA, AQPC815HORA)
              VALUES
                (auxCorr, Instancia, auxFechaHoy, auxHora);
              COMMIT;
            EXCEPTION
              WHEN OTHERS THEN
                auxCorr := auxCorr + 2;
                INSERT INTO AQPC815
                  (AQPC815CODOPIN,
                   AQPC815INSTAN,
                   AQPC815FECHA,
                   AQPC815HORA)
                VALUES
                  (auxCorr, Instancia, auxFechaHoy, auxHora);
                COMMIT;
            END;
        END;
      END IF;
    
      CodOpinion := auxCorr;
    ELSE
      CodOpinion := codOpiniAsign;
    END IF;
  end;

  procedure sp_cargar_solic_pend_opinion(instancia      number,
                                         ubuser         varchar2,
                                         UsuarSuplencia varchar2,
                                         fechHoy        date,
                                         xIdentfPerf    number,
                                         flgTerm        out varchar2) is
    auxUsu             varchar2(10);
    auxCta             numeric(9);
    auxOper            numeric(9);
    fechaHoy           date;
    AUXASES            VARCHAR2(10);
    auxint             numeric(10);
    Exis156            VARCHAR2(1);
    estado             varchar2(2);
    letra              number(2);
    NomClie            varchar2(30);
    xModul             number(3);
    xTipoOper          number(3);
    xMontoCred         number(17, 2);
    xDescMod           varchar2(50);
    xDescProd          varchar2(50);
    xFechIngr          date;
    xCodTipSoli        number(3);
    xDescTipoSolic     varchar2(50);
    v_codOpin          number(10);
    v_codNivel         number(3);
    v_DescEtap         varchar2(50);
    x_nivel156         number(3);
    x_EstadOpini       varchar2(2);
    auxEstado          varchar2(2);
    x_AnlSeniRiDeriv   varchar2(10);
    x_estado_Opinion   varchar2(10);
    x_usuarioDerivado  varchar2(10);
    flgTieneAsignad    varchar2(1);
    flgSolicActivo     VARCHAR2(1);
    flgSoliRegGuia     VARCHAR2(1);
    FlgRpta            Varchar2(1);
    FlgPertencAnaliIng varchar2(1);
    FlgNivel           number(2);
    v_AnaliDeri156     varchar2(10);
    v_Estop156         varchar2(2);
    FLGEXISPOLIT       VARCHAR2(1);
  
    CURSOR INSTNC_PEND IS
      select /*+ all_rows index(xx SYS_C0048315)*/
       XX.PAE70INS
        from wfwrkitems e, fpae70 xx, fpae73 yy
       where e.wfinsprcid = xx.pae70ins
         and e.wfitemstsact = 1
         and xx.pae51eva = yy.pae51eva
         and xx.pae70nro = yy.pae70nro
         and xx.pae51eva = 2
         and xx.pae70nro = (select max(A.pae70nro)
                              from fpae70 A
                             where A.PAE51EVA = 2
                               AND A.pae70ins = xx.pae70ins)
         and yy.pae51eva = 2
            --and yy.PAE73POL = 103
         and xx.pae70ins = instancia
         and rownum = 1
      union
      select tp1imp1
        from fst198
       Where tp1cod = 1
         and tp1cod1 = 11152
         and tp1corr1 = 50
         and tp1corr2 = 1
         and tp1corr3 > 0
         and tp1imp1 = instancia;
  
    CURSOR LEERAQPC156(letra         number,
                       estado        varchar2,
                       xubuser       varchar2,
                       xUsuSuplencia varchar2) IS
      SELECT *
        FROM AQPC156
       WHERE AQPC156NIVEL = letra
         AND (trim(AQPC156GRAGE) = xubuser or
             trim(AQPC156GRAGE) = xUsuSuplencia)
         and (trim(AQPC156ESTOP) <> 'T' AND TRIM(AQPC156ESTOP) <> 'X')
         AND AQPC156ESTAD = 'H'; --2108
    CURSOR LEERAQPC156_ANALISCREDI(letra         number,
                                   estado        varchar2,
                                   ubuser        varchar2,
                                   xUsuSuplencia varchar2) IS
      SELECT *
        FROM AQPC156
       WHERE AQPC156INSTAN = instancia
         AND AQPC156NIVEL = letra
         AND (trim(AQPC156ESTOP) = trim(estado) or trim(AQPC156ESTOP) = 'D')
         and (trim(AQPC156USUREG) = trim(ubuser) or
             trim(AQPC156USUREG) = xUsuSuplencia)
         AND AQPC156ESTAD = 'H'; --2108
  
    CURSOR Dataos156_ASRiesgo(usuario       varchar2,
                              nivel         number,
                              estado        varchar2,
                              xUsuSuplencia varchar2) IS
      SELECT *
        FROM AQPC156
       WHERE AQPC156NIVEL = nivel
         AND (trim(AQPC156USRDER) = trim(usuario) or
             trim(AQPC156USRDER) = xUsuSuplencia)
         and (trim(AQPC156ESTOP) <> 'T' AND trim(AQPC156ESTOP) <> 'X')
         AND AQPC156ESTAD = 'H'; --2108;
  
  BEGIN
    auxUsu := trim(UPPER(ubuser));
    /* BEGIN --27062023
      DELETE FROM AQPC194 WHERE TRIM(AQPC194USUEJ) = TRIM(auxUsu);
      COMMIT;
    END;*/ --27062023         
    --validar si se puede reprocesar despues de 30 dias la solici      
    BEGIN
      Pq_Cr_Repo_Opinion_Riesgos.sp_valid_dias_proce_solici_nuev(instancia,
                                                                 FlgRpta);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    Exis156 := 'N';
    IF FlgRpta = 'N' THEN
      -- 06/12/2023        
      BEGIN
        SELECT 'S'
          INTO Exis156
          FROM AQPC156
         WHERE AQPC156CODOPI =
               (SELECT MAX(AQPC156CODOPI)
                  FROM AQPC156
                 WHERE AQPC156INSTAN = instancia)
           AND AQPC156INSTAN = instancia
           AND AQPC156ESTAD = 'H'; --2108       
        --AND AQPC156NIVEL > 1; --commnet 18112024
      EXCEPTION
        when OTHERS THEN
          Exis156 := 'N';
      END;
    ELSE
      IF FlgRpta = 'S' THEN
        BEGIN
          SELECT 'S'
            INTO Exis156
            FROM AQPC156
           WHERE AQPC156CODOPI =
                 (SELECT MAX(AQPC156CODOPI)
                    FROM AQPC156
                   WHERE AQPC156INSTAN = instancia)
             AND AQPC156INSTAN = instancia
             AND AQPC156ESTAD = 'H' --2108 
             AND AQPC156ESTOP <> 'T'; -- 28112023      
          --AND AQPC156NIVEL > 1;--commnet 18112024
        EXCEPTION
          when OTHERS THEN
            Exis156 := 'N';
        END;
      END IF;
    END IF; --06/12/2023
  
    IF Exis156 = 'N' AND instancia > 0 THEN
      flgTieneAsignad := 'N'; --31072023
      --validar zona asignada para analista riesgos  -- INI MOD 24072023  
      BEGIN
        pq_cr_repo_opinion_riesgos.sp_val_zona_soli_pertenc_AnaliRiesgo(instancia,
                                                                        ubuser,
                                                                        flgTieneAsignad);
      EXCEPTION
        WHEN OTHERS THEN
          flgTieneAsignad := 'N';
      END; -- FIN MOD 24072023  
    
      ---16082023 Validar si está registrado en guia, en casos que se necesiten se gestionados por otros ya que no está grabado en la aqpc156.
      flgSoliRegGuia := 'N';
      BEGIN
        SELECT 'S'
          INTO flgSoliRegGuia
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11152
           AND TP1CORR1 = 50
           AND TP1CORR2 = 1
           AND TP1CORR3 > 0
           AND TP1IMP1 = instancia;
      EXCEPTION
        WHEN OTHERS THEN
          flgSoliRegGuia := 'N';
      END;
      ---16082023
    
      IF flgTieneAsignad = 'S' OR flgSoliRegGuia = 'S' THEN
        --16082023
        --IF xIdentfPerf = 1 THEN 10072023
        FLGEXISPOLIT := 'N';
        FOR r in INSTNC_PEND loop
          auxint       := r.pae70ins;
          FLGEXISPOLIT := 'S';
          /*Exis156 := 'N'; ---06/12/2023
          BEGIN
            SELECT 'S'
              INTO Exis156
              FROM AQPC156
             WHERE AQPC156CODOPI =
                   (SELECT MAX(AQPC156CODOPI)
                      FROM AQPC156
                     WHERE AQPC156INSTAN = auxint)
               AND AQPC156INSTAN = auxint
               AND AQPC156ESTAD = 'H' --2108 
               AND AQPC156ESTOP <> 'T' -- 28112023
               AND AQPC156NIVEL > 1;
          EXCEPTION
            when OTHERS THEN
              Exis156 := 'N';
          END;*/ ---06/12/2023
        
          IF Exis156 = 'N' THEN
          
            pq_cr_repo_opinion_riesgos.sp_obtener_datos_Opinion(auxint,
                                                                NomClie,
                                                                xMontoCred,
                                                                xDescMod,
                                                                auxCta,
                                                                auxOper,
                                                                xDescProd,
                                                                xDescTipoSolic,
                                                                AUXASES,
                                                                xFechIngr);
          
            BEGIN
              pq_cr_repo_opinion_riesgos.sp_descripcion_ArbolPerfiles(xIdentfPerf,
                                                                      v_DescEtap); --18112024
            EXCEPTION
              when OTHERS THEN
                NULL;
            END;
          
            v_DescEtap := trim(TO_char(xIdentfPerf)) || '-' || v_DescEtap;
          
            BEGIN
              INSERT INTO AQPC194
                (AQPC194INST,
                 AQPC194FECCG,
                 AQPC194USUEJ,
                 AQPC194CTA,
                 AQPC194OPER,
                 AQPC194ASES,
                 AQPC194CLIE,
                 AQPC194DESMOD,
                 AQPC194PROD,
                 AQPC194TIPSO,
                 AQPC194FECING,
                 AQPC194MNTCR,
                 AQPC194ETPA,
                 AQPC194NIVL,
                 AQPC194ESTD,
                 AQPC194AUX1,
                 AQPC194ANSRIEG) --11/12/2023 
              VALUES
                (R.PAE70INS,
                 fechHoy,
                 ubuser,
                 auxCta,
                 auxOper,
                 AUXASES,
                 NomClie,
                 xDescMod,
                 xDescProd,
                 xDescTipoSolic,
                 xFechIngr,
                 xMontoCred,
                 v_DescEtap, --'1-ANALISTA SENIOR DE ADMISIÓN Y SEGUIMIENTO', --'1-ANALISTA CRÉDITOS', 18112024
                 xIdentfPerf, --3,  18112024
                 'Pendiente',
                 auxUsu,
                 auxUsu);
              commit;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
          END IF;
        END LOOP;
      
        IF FLGEXISPOLIT = 'N' THEN
          flgTerm := 'No se ejecutaron las politicas para la solicitud.';
        END IF;
      
      ELSE
        --01042024 alertas para el panel
        flgTerm := 'El usuario ' || auxUsu ||
                   ' no esta asignado a la zona/sucursal de la instancia ' ||
                   to_char(instancia);
      END IF;
    
    ELSIF Exis156 = 'S' AND instancia > 0 THEN
      --caso donde se busca por instancia para solicitu q ya existen en aqpc156
    
      BEGIN
        SELECT AQPC156NIVEL, TRIM(AQPC156USRDER), TRIM(AQPC156ESTOP)
          INTO FlgNivel, v_AnaliDeri156, v_Estop156
          FROM AQPC156
         WHERE AQPC156CODOPI =
               (SELECT (MAX(B.AQPC156CODOPI))
                  FROM AQPC156 B
                 WHERE B.AQPC156INSTAN = instancia
                   AND B.AQPC156ESTAD = 'H')
           AND AQPC156INSTAN = instancia
           and (trim(AQPC156ESTOP) <> 'T')
           AND AQPC156ESTAD = 'H';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      FlgNivel           := NVL(FlgNivel, 0);
      FlgPertencAnaliIng := 'N';
      IF TRIM(UPPER(v_AnaliDeri156)) = ubuser THEN
        FlgPertencAnaliIng := 'S';
      END IF;
    
      flgTerm := '';
      IF FlgNivel IN (1, 2, 3) THEN
        --18112024
        IF FlgPertencAnaliIng = 'S' THEN
          IF TRIM(v_Estop156) <> ('X') THEN
            BEGIN
              pq_cr_repo_opinion_riesgos.sp_consul_por_solic156(instancia,
                                                                ubuser,
                                                                fechHoy,
                                                                flgTerm);
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
          ELSE
            flgTerm := 'La solicitud ' || to_char(instancia) ||
                       ' no está vigente';
          END IF;
        ELSE
          IF (v_AnaliDeri156 is not null or v_AnaliDeri156 <> ' ') AND
             TRIM(v_Estop156) <> ('X') THEN
            flgTerm := 'la instancia ' || to_char(instancia) ||
                       ' fue asignada al analista ' || trim(v_AnaliDeri156);
          END IF;
        END IF;
      ELSE
        IF FlgNivel >= 1 and TRIM(v_Estop156) <> ('X') THEN --18112024
          flgTerm := 'la solicitud ' || to_char(instancia) ||
                     ' fue derivado al usuario ' || trim(v_AnaliDeri156);
        END IF;
      END IF;
    
    ELSE
      --  ELSE    --  IF xIdentfPerf = 3 THEN    10072023 
      FOR r in Dataos156_ASRiesgo(ubuser, xIdentfPerf, 'V', UsuarSuplencia) loop
        auxint := r.aqpc156instan;
      
        flgTerm := '';
        BEGIN
          pq_cr_repo_opinion_riesgos.sp_consul_por_solic156(auxint,
                                                            ubuser,
                                                            fechHoy,
                                                            flgTerm);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        flgTerm := '';
      END LOOP;
    END IF; --10072023 
    --  END IF;
    -- END IF;
  
  END;
  --cargar instancias de 156 para niveles 4,5 y 6 perfiles superiores como XASSENASR, ASJEFASR, GRGERRIE deberían poder ver todas las solicitudes.
  procedure sp_cargar_opiniones_156(auxUsu    VARCHAR2,
                                    NroNivel  number,
                                    fechHoy   DATE,
                                    flgcrg194 out varchar2) IS
    CURSOR lista_opiniones IS
      SELECT *
        FROM AQPC156
       WHERE (TRIM(AQPC156ESTOP) <> 'X' AND TRIM(AQPC156ESTOP) <> 'T')
         AND AQPC156ESTAD = 'H' --2108    
         AND AQPC156NIVEL >= 1;
    --AND aqpc156instan = 9163546; --PRUEBA   
    xModul           number(3);
    NomClie          VARCHAR2(30);
    xTipoOper        number(3);
    xMontoCred       number(17, 2);
    xDescMod         varchar2(40);
    xDescProd        varchar2(40);
    xFechIngr        date;
    xCodTipSoli      number(3);
    xDescTipoSolic   varchar2(50);
    v_codOpin        number(10);
    v_codNivel       number(3);
    v_DescEtap       varchar2(50);
    x_nivel156       number(3);
    x_EstadOpini     varchar2(2);
    auxEstado        varchar2(2);
    auxint           NUMBER(10);
    auxCta           NUMBER(9);
    auxOper          NUMBER(9);
    AUXASES          VARCHAR2(10);
    x_estado_Opinion varchar2(10);
    flgSolicActivo   varchar2(1);
  BEGIN
    -- DELETE FROM AQPC194 WHERE TRIM(AQPC194USUEJ) = TRIM(auxUsu);  --30062023
    -- commit;
  
    FOR r in lista_opiniones LOOP
      auxint := r.aqpc156instan;
    
      --Validar si instancia está vigente  31072023
      flgSolicActivo := 'N'; --11/03/2025
      BEGIN
        pq_cr_repo_opinion_riesgos.sp_validar_vigent_solic(auxint,
                                                           flgSolicActivo);
      EXCEPTION
        WHEN OTHERS THEN
          flgSolicActivo := 'N';
      END;
    
      IF flgSolicActivo = 'S' THEN
        BEGIN
          SELECT B.XWFMODULO,
                 B.XWFTIPOPE,
                 B.XWFCUENTA,
                 B.XWFOPERACION,
                 B.XWFMONTO1,
                 C.PENOM
            INTO xModul, xTipoOper, auxCta, auxOper, xMontoCred, NomClie
            FROM XWF700 B, FSR008 A, FSD001 C
           WHERE B.XWFPRCINS = auxint
             and A.CTNRO = B.XWFCUENTA
             AND C.PEPAIS = A.PEPAIS
             AND C.PETDOC = A.PETDOC
             AND C.PENDOC = A.PENDOC
             AND A.CTTFIR = 'T'
             AND B.XWFCAR3 = '1'
             AND ROWNUM < 2;
        EXCEPTION
          when OTHERS THEN
            auxCta  := 0;
            auxOper := 0;
            xModul  := 0;
            NomClie := '';
        END;
      
        --MODULO
        BEGIN
          SELECT e.MDNOM
            into xDescMod
            FROM FST003 e
           WHERE e.MODULO = xModul;
        EXCEPTION
          when OTHERS THEN
            xDescMod := '';
        END;
        xDescMod := to_char(xModul) || '-' || trim(xDescMod);
      
        BEGIN
          SELECT tonom
            into xDescProd
            FROM fst004
           WHERE MODULO = xModul
             AND totope = xTipoOper;
        EXCEPTION
          when OTHERS THEN
            xDescProd := '';
        END;
        xDescProd := to_char(xTipoOper) || '-' || trim(xDescProd);
      
        BEGIN
          SELECT SNG001ASE, SNG001FIN, SNG001ORI
            INTO AUXASES, xFechIngr, xCodTipSoli
            FROM SNG001
           WHERE SNG001INST = auxint;
        EXCEPTION
          when OTHERS THEN
            AUXASES     := '';
            xFechIngr   := '';
            xCodTipSoli := 0;
        END;
      
        CASE
          WHEN xCodTipSoli = 0 THEN
            ---normal
            xDescTipoSolic := 'Normal';
          WHEN xCodTipSoli = 1 THEN
            xDescTipoSolic := 'Carta Fianza';
          WHEN xCodTipSoli = 2 THEN
            xDescTipoSolic := 'No Habilitado';
          WHEN xCodTipSoli = 3 THEN
            xDescTipoSolic := 'Refinanciacion';
          WHEN xCodTipSoli = 4 THEN
            xDescTipoSolic := 'Ampliacion';
          WHEN xCodTipSoli = 7 THEN
            xDescTipoSolic := 'Desembolsos Parciales';
          WHEN xCodTipSoli = 10 THEN
            xDescTipoSolic := 'Convenios';
          WHEN xCodTipSoli = 11 THEN
            xDescTipoSolic := 'Linea Credito';
          WHEN xCodTipSoli = 12 THEN
            xDescTipoSolic := 'Ampliacion Lineas Credito';
          WHEN xCodTipSoli = 13 THEN
            xDescTipoSolic := 'Reprogramacion Cambio Fecha';
          WHEN xCodTipSoli = 14 THEN
            xDescTipoSolic := 'Reprogramacion Desastre Natural';
          WHEN xCodTipSoli = 15 THEN
            xDescTipoSolic := 'Ampliacion Especial';
          WHEN xCodTipSoli = 16 THEN
            xDescTipoSolic := 'Reprogramacion Campaña';
          ELSE
            xDescTipoSolic := '';
        END CASE;
      
        --Consultar aqpc156
        BEGIN
          SELECT C.AQPC156CODOPI, c.aqpc156nivel, TRIM(c.AQPC156ESTOP)
            INTO v_codOpin, x_nivel156, x_EstadOpini
            FROM AQPC156 C
           WHERE C.AQPC156CODOPI =
                 (SELECT (MAX(B.AQPC156CODOPI))
                    FROM AQPC156 B
                   WHERE B.AQPC156INSTAN = auxint
                     AND AQPC156ESTAD = 'H') --2108)
             AND C.AQPC156INSTAN = auxint
             AND AQPC156ESTAD = 'H'
             AND AQPC156ESTOP <> 'T'; -- 28112023; --2108;
        EXCEPTION
          when OTHERS THEN
            v_codOpin    := 0;
            x_nivel156   := 0;
            x_EstadOpini := '';
        END;
      
        BEGIN
          pq_cr_repo_opinion_riesgos.sp_descripcion_ArbolPerfiles(x_nivel156,
                                                                  v_DescEtap); --18112024
        EXCEPTION
          when OTHERS THEN
            NULL;
        END;
      
        x_estado_Opinion := '';
        IF TRIM(R.AQPC156ESTOP) = 'P' THEN
          x_estado_Opinion := 'Pendiente';
        END IF;
        IF TRIM(R.AQPC156ESTOP) = 'V' THEN
          x_estado_Opinion := 'Viable';
        ELSE
          IF TRIM(R.AQPC156ESTOP) = 'NV' THEN
            x_estado_Opinion := 'No viable';
          ELSE
            IF TRIM(R.AQPC156ESTOP) = 'O' THEN
              x_estado_Opinion := 'Observado';
            ELSE
              IF TRIM(R.AQPC156ESTOP) = 'D' THEN
                x_estado_Opinion := 'Devuelto';
              ELSE
                IF TRIM(R.AQPC156ESTOP) = 'T' THEN
                  x_estado_Opinion := 'Completado';
                ELSE
                  IF TRIM(R.AQPC156ESTOP) = 'X' THEN
                    x_estado_Opinion := 'Inactivo';
                  END IF;
                END IF;
              END IF;
            END IF;
          END IF;
        END IF;
      
        BEGIN
          INSERT INTO AQPC194
            (AQPC194INST,
             AQPC194FECCG,
             AQPC194USUEJ,
             AQPC194CTA,
             AQPC194OPER,
             AQPC194ASES,
             AQPC194CLIE,
             AQPC194DESMOD,
             AQPC194PROD,
             AQPC194TIPSO,
             AQPC194FECING,
             AQPC194MNTCR,
             AQPC194ETPA,
             AQPC194NIVL,
             AQPC194ESTD,
             AQPC194AUX1,
             AQPC194ANSRIEG) --11/12/2023
          VALUES
            (R.AQPC156INSTAN,
             fechHoy,
             auxUsu,
             auxCta,
             auxOper,
             AUXASES,
             NomClie,
             xDescMod,
             xDescProd,
             xDescTipoSolic,
             xFechIngr,
             xMontoCred,
             v_DescEtap,
             x_nivel156,
             x_estado_Opinion,
             r.aqpc156usrder,
             r.AQPC156ANSERIG);
          commit;
          --flgcrg194 := 'S'; 01042024
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
            --flgcrg194 := 'N';01042024
        END;
     /* ELSE
        flgcrg194 := 'La solicitud ' || to_char(auxint) ||
                     ' no está vigente'; --01042024 */
      END IF;
    END LOOP;
  END;

  procedure sp_consul_por_solic156(auxint      number,
                                   ubuser      varchar2,
                                   fechHoy     DATE,
                                   mensajeErro out varchar2) is
    --01042024    
    auxCta   numeric(9);
    auxOper  numeric(9);
    fechaHoy date;
    AUXASES  VARCHAR2(10);
    --auxint            numeric(10);
    Exis156           VARCHAR2(1);
    estado            varchar2(2);
    letra             number(2);
    NomClie           varchar2(30);
    xModul            number(3);
    xTipoOper         number(3);
    xMontoCred        number(17, 2);
    xDescMod          varchar2(50);
    xDescProd         varchar2(50);
    xFechIngr         date;
    xCodTipSoli       number(3);
    xDescTipoSolic    varchar2(50);
    v_codOpin         number(10);
    v_codNivel        number(3);
    v_DescEtap        varchar2(50);
    x_nivel156        number(3);
    x_EstadOpini      varchar2(2);
    auxEstado         varchar2(2);
    x_AnlSeniRiDeriv  varchar2(10);
    x_estado_Opinion  varchar2(10);
    x_usuarioDerivado varchar2(10);
    flgTieneAsignad   varchar2(1);
    flgSolicActivo    VARCHAR2(1);
    flgSoliRegGuia    VARCHAR2(1);
    FlgRpta           Varchar2(1);
  
    x_usuarioDerivd varchar2(12);
  begin
    --Validar si instancia está vigente  31072023
    flgSolicActivo := 'N';
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_validar_vigent_solic(auxint,
                                                         flgSolicActivo);
    EXCEPTION
      WHEN OTHERS THEN
        flgSolicActivo := 'N';
    END;
  
    IF flgSolicActivo = 'S' THEN
      --31072023              
      --validar zona asignada para analista riesgos  -- INI MOD 24072023  
      flgTieneAsignad := 'N';
      BEGIN
        pq_cr_repo_opinion_riesgos.sp_val_zona_soli_pertenc_AnaliRiesgo(auxint,
                                                                        ubuser,
                                                                        flgTieneAsignad);
      EXCEPTION
        WHEN OTHERS THEN
          flgTieneAsignad := 'N';
      END;
      IF flgTieneAsignad = 'S' THEN
        -- FIN MOD 24072023                      
        BEGIN
          SELECT B.XWFMODULO,
                 B.XWFTIPOPE,
                 B.XWFCUENTA,
                 B.XWFOPERACION,
                 B.XWFMONTO1,
                 C.PENOM
            INTO xModul, xTipoOper, auxCta, auxOper, xMontoCred, NomClie
            FROM XWF700 B, FSR008 A, FSD001 C
           WHERE B.XWFPRCINS = auxint
             and A.CTNRO = B.XWFCUENTA
             AND C.PEPAIS = A.PEPAIS
             AND C.PETDOC = A.PETDOC
             AND C.PENDOC = A.PENDOC
             AND A.CTTFIR = 'T'
             AND B.XWFCAR3 = '1'
             AND ROWNUM < 2;
        EXCEPTION
          when OTHERS THEN
            auxCta     := 0;
            auxOper    := 0;
            xModul     := 0;
            NomClie    := '';
            xTipoOper  := 0;
            xMontoCred := 0;
        END;
      
        --MODULO
        BEGIN
          SELECT e.MDNOM
            into xDescMod
            FROM FST003 e
           WHERE e.MODULO = xModul;
        EXCEPTION
          when OTHERS THEN
            xDescMod := '';
        END;
        xDescMod := to_char(xModul) || '-' || trim(xDescMod);
      
        BEGIN
          SELECT tonom
            into xDescProd
            FROM fst004
           WHERE MODULO = xModul
             AND totope = xTipoOper;
        EXCEPTION
          when OTHERS THEN
            xDescProd := '';
        END;
        xDescProd := to_char(xTipoOper) || '-' || trim(xDescProd);
      
        BEGIN
          SELECT SNG001ASE, SNG001FIN, SNG001ORI
            INTO AUXASES, xFechIngr, xCodTipSoli
            FROM SNG001
           WHERE SNG001INST = auxint;
        EXCEPTION
          when OTHERS THEN
            AUXASES     := '';
            xFechIngr   := '';
            xCodTipSoli := 0;
        END;
      
        CASE
          WHEN xCodTipSoli = 0 THEN
            ---normal
            xDescTipoSolic := 'Normal';
          WHEN xCodTipSoli = 1 THEN
            xDescTipoSolic := 'carta fianza';
          WHEN xCodTipSoli = 2 THEN
            xDescTipoSolic := 'no habilitado';
          WHEN xCodTipSoli = 3 THEN
            xDescTipoSolic := 'refinanciacion';
          WHEN xCodTipSoli = 4 THEN
            xDescTipoSolic := 'ampliacion';
          WHEN xCodTipSoli = 7 THEN
            xDescTipoSolic := 'desembolsos parciales';
          WHEN xCodTipSoli = 10 THEN
            xDescTipoSolic := 'convenios';
          WHEN xCodTipSoli = 11 THEN
            xDescTipoSolic := 'linea credito';
          WHEN xCodTipSoli = 12 THEN
            xDescTipoSolic := 'ampliacion lineas credito';
          WHEN xCodTipSoli = 13 THEN
            xDescTipoSolic := 'reprogramacion cambio fecha';
          WHEN xCodTipSoli = 14 THEN
            xDescTipoSolic := 'reprogramacion desastre natural';
          WHEN xCodTipSoli = 15 THEN
            xDescTipoSolic := 'ampliacion especial';
          WHEN xCodTipSoli = 16 THEN
            xDescTipoSolic := 'reprogramacion campaña';
          ELSE
            NULL;
        END CASE;
      
        --Consultar aqpc156
        BEGIN
          SELECT C.AQPC156CODOPI,
                 c.aqpc156nivel,
                 TRIM(c.AQPC156ESTOP),
                 c.AQPC156ANSERIG,
                 c.AQPC156USRDER
            INTO v_codOpin,
                 x_nivel156,
                 x_EstadOpini,
                 x_AnlSeniRiDeriv,
                 x_usuarioDerivd --18112024
            FROM AQPC156 C
           WHERE C.AQPC156CODOPI =
                 (SELECT (MAX(B.AQPC156CODOPI))
                    FROM AQPC156 B
                   WHERE B.AQPC156INSTAN = auxint
                     AND AQPC156ESTAD = 'H') --2108)
             AND C.AQPC156INSTAN = auxint
             AND AQPC156ESTAD = 'H'
             AND AQPC156ESTOP <> 'T'; -- 28112023; --2108 ;
        EXCEPTION
          when OTHERS THEN
            Exis156          := 'N';
            v_codOpin        := 0;
            x_nivel156       := 0;
            x_EstadOpini     := '';
            x_AnlSeniRiDeriv := '';
            x_usuarioDerivd  := '';
        END;
      
        BEGIN
          pq_cr_repo_opinion_riesgos.sp_descripcion_ArbolPerfiles(x_nivel156,
                                                                  v_DescEtap); --
        EXCEPTION
          when OTHERS THEN
            NULL;
        END;
      
        IF x_EstadOpini = 'P' THEN
          -- ADD 2402        
          x_estado_Opinion := 'Pendiente';
        END IF;
        IF x_EstadOpini = 'V' THEN
          -- ADD 2202        
          x_estado_Opinion := 'Viable';
        ELSE
          IF x_EstadOpini = 'NV' THEN
            x_estado_Opinion := 'No viable';
          ELSE
            IF x_EstadOpini = 'O' THEN
              x_estado_Opinion := 'Observado';
            ELSE
              IF x_EstadOpini = 'D' THEN
                x_estado_Opinion := 'Devuelto';
              ELSE
                IF x_EstadOpini = 'T' THEN
                  x_estado_Opinion := 'Completado';
                ELSE
                  IF x_EstadOpini = 'X' THEN
                    x_estado_Opinion := 'Inactivo';
                  END IF;
                END IF;
              END IF;
            END IF;
          END IF;
        END IF;
      
        BEGIN
          INSERT INTO AQPC194
            (AQPC194INST,
             AQPC194FECCG,
             AQPC194USUEJ,
             AQPC194CTA,
             AQPC194OPER,
             AQPC194ASES,
             AQPC194CLIE,
             AQPC194DESMOD,
             AQPC194PROD,
             AQPC194TIPSO,
             AQPC194FECING,
             AQPC194MNTCR,
             AQPC194ETPA,
             AQPC194NIVL,
             AQPC194ESTD,
             AQPC194AUX1, --analis senior derivdo                                                                                
             AQPC194ANSRIEG --11/12/2023
             )
          VALUES
            (auxint,
             fechHoy,
             ubuser,
             auxCta,
             auxOper,
             AUXASES,
             NomClie,
             xDescMod,
             xDescProd,
             xDescTipoSolic,
             xFechIngr,
             xMontoCred,
             v_DescEtap,
             x_nivel156,
             x_estado_Opinion,
             x_usuarioDerivd,
             x_AnlSeniRiDeriv);
          commit;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      ELSE
        --01042024 alertas para el panel
        mensajeErro := 'El usuario ' || TRIM(ubuser) ||
                       ' no esta asignado a la zona/sucursal de la instancia ' ||
                       to_char(auxint);
      END IF;
    ELSE
      --01042024
      mensajeErro := 'La solicitud ' || to_char(auxint) ||
                     ' no está vigente.';
    END IF;
  end;

  procedure sp_obtener_datos_Opinion(auxint         NUMBER,
                                     NomClie        OUT VARCHAR2,
                                     xMontoCred     OUT NUMBER,
                                     xDescMod       OUT VARCHAR2,
                                     auxCta         OUT NUMBER,
                                     auxOper        OUT NUMBER,
                                     xDescProd      OUT VARCHAR2,
                                     xDescTipoSolic OUT VARCHAR2,
                                     AUXASES        OUT VARCHAR2,
                                     xFechIngr      OUT DATE) is
    xModul      NUMBER(3);
    xTipoOper   NUMBER(3);
    xCodTipSoli NUMBER(3);
  BEGIN
    BEGIN
      SELECT B.XWFMODULO,
             B.XWFTIPOPE,
             B.XWFCUENTA,
             B.XWFOPERACION,
             B.XWFMONTO1,
             C.PENOM
        INTO xModul, xTipoOper, auxCta, auxOper, xMontoCred, NomClie
        FROM XWF700 B, FSR008 A, FSD001 C
       WHERE B.XWFPRCINS = auxint
         and A.CTNRO = B.XWFCUENTA
         AND C.PEPAIS = A.PEPAIS
         AND C.PETDOC = A.PETDOC
         AND C.PENDOC = A.PENDOC
         AND A.CTTFIR = 'T'
         AND B.XWFCAR3 = '1'
         AND ROWNUM < 2;
    EXCEPTION
      when OTHERS THEN
        auxCta     := 0;
        auxOper    := 0;
        xModul     := 0;
        NomClie    := '';
        xMontoCred := 0;
    END;
    --MODULO
    BEGIN
      SELECT e.MDNOM into xDescMod FROM FST003 e WHERE e.MODULO = xModul;
    EXCEPTION
      when OTHERS THEN
        xDescMod := '';
    END;
    xDescMod := to_char(xModul) || '-' || trim(xDescMod);
  
    BEGIN
      SELECT tonom
        into xDescProd
        FROM fst004
       WHERE MODULO = xModul
         AND totope = xTipoOper;
    EXCEPTION
      when OTHERS THEN
        xDescProd := '';
    END;
    xDescProd := to_char(xTipoOper) || '-' || trim(xDescProd);
  
    BEGIN
      SELECT SNG001ASE, SNG001FIN, SNG001ORI
        INTO AUXASES, xFechIngr, xCodTipSoli
        FROM SNG001
       WHERE SNG001INST = auxint;
    EXCEPTION
      when OTHERS THEN
        AUXASES     := '';
        xFechIngr   := '';
        xCodTipSoli := 0;
    END;
  
    CASE
      WHEN xCodTipSoli = 0 THEN
        ---normal
        xDescTipoSolic := 'Normal';
      WHEN xCodTipSoli = 1 THEN
        xDescTipoSolic := 'carta fianza';
      WHEN xCodTipSoli = 2 THEN
        xDescTipoSolic := 'no habilitado';
      WHEN xCodTipSoli = 3 THEN
        xDescTipoSolic := 'refinanciacion';
      WHEN xCodTipSoli = 4 THEN
        xDescTipoSolic := 'ampliacion';
      WHEN xCodTipSoli = 7 THEN
        xDescTipoSolic := 'desembolsos parciales';
      WHEN xCodTipSoli = 10 THEN
        xDescTipoSolic := 'convenios';
      WHEN xCodTipSoli = 11 THEN
        xDescTipoSolic := 'linea credito';
      WHEN xCodTipSoli = 12 THEN
        xDescTipoSolic := 'ampliacion lineas credito';
      WHEN xCodTipSoli = 13 THEN
        xDescTipoSolic := 'reprogramacion cambio fecha';
      WHEN xCodTipSoli = 14 THEN
        xDescTipoSolic := 'reprogramacion desastre natural';
      WHEN xCodTipSoli = 15 THEN
        xDescTipoSolic := 'ampliacion especial';
      WHEN xCodTipSoli = 16 THEN
        xDescTipoSolic := 'reprogramacion campaña';
      ELSE
        xDescTipoSolic := '';
    END CASE;
  END;

  procedure sp_grabar_comentarios_ACR_GA(codopini         number,
                                         instancia        number,
                                         usuario          varchar2,
                                         NivelComent      number,
                                         TipoView         varchar2,
                                         CodTipoSolicitud number,
                                         xAQPC171ANCNEG   varchar2,
                                         xAQPC171ANVIC    VARCHAR2,
                                         xAQPC171FCN      varchar2,
                                         xAQPC171AESFCC   varchar2,
                                         xAQPC171RDCLN    varchar2,
                                         xAQPC171ANCP     varchar2,
                                         xAQPC171ANCPG    varchar2,
                                         xAQPC171DANDC    varchar2,
                                         xAQPC171DGCOR    varchar2,
                                         xAQPC171RANCNEG  varchar2,
                                         xAQPC171MTREP    varchar2,
                                         xAQPC171RAESFCC  varchar2,
                                         xAQPC171ANCPRF   varchar2,
                                         xAQPC171ANVPG    varchar2,
                                         xAQPC171DEGV     varchar2,
                                         xAQPC171RFANCNE  varchar2,
                                         xAQPC171MTREFN   varchar2,
                                         xAQPC171RFAESFC  varchar2,
                                         xAQPC171RFANCPR  varchar2,
                                         xAQPC171RFANVPG  varchar2,
                                         xAQPC171RFDEGV   varchar2,
                                         xAQPC156ESTOP    varchar2, --INI mod rcastro 10072023
                                         xAQPC171ARGRECO  varchar2,
                                         xAQPC171ANACOME  varchar2,
                                         xAQPC171RESOLRE  varchar2,
                                         xAQPC171CONDREC  varchar2, --FIN mod rcastro 10072023
                                         xComentRiesgos   varchar2, --23082023
                                         xResoluRiesgos   varchar2,
                                         xCondiRecomRiesg varchar2) is
    --07112023
    xcargo varchar2(40);
    xfecha date;
    xcorr2 NUMBER(10);
  
    TipoComentario     NUMBER(3);
    xHora              varchar2(8);
    v_ArgumReconsid    varchar2(4000);
    v_AnaliComReconsid varchar2(4000);
    v_ResolucReconsid  varchar2(4000);
    v_CondicReconsid   varchar2(4000);
  
    xComenObserv varchar2(4000); --2410
    flgEstObser  VARCHAR2(1);
  
  begin
  
    BEGIN
      SELECT PGFAPE INTO xfecha FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        xfecha := to_Date(sysdate, 'dd/MM/RRRR');
    END;
  
    xHora := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  
    xcorr2 := 0;
    begin
      select max(AQPC171CORR)
        into xcorr2
        from aqpc171
       where AQPC171CODOPI = codopini
         AND AQPC171INST = instancia
         AND AQPC171ESTAD = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        xcorr2 := 0;
    end;
    xcorr2 := nvl(xcorr2, 0); --22012024
  
    /*--07112023
    BEGIN
      SELECT AQPC171MOTOBSV INTO xComenObserv FROM AQPC171
       WHERE AQPC171CODOPI = codopini
         AND AQPC171CORR = xcorr2
         AND AQPC171INST = instancia
         AND AQPC171ESTAD = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        xComenObserv := ' ';    
    END;  
    
    xcorr2 := xcorr2 + 1;    
    
    BEGIN
      UPDATE AQPC171
         SET AQPC171ESTAD = 'I'
       WHERE AQPC171CODOPI = codopini
         AND AQPC171INST = instancia
         AND (AQPC171ESTAD = 'H' OR AQPC171ESTAD IS NULL);
      COMMIT;
    END;
    */
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_grab_log_aqpc171(codopini, instancia);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- mod 01032023    
    /* BEGIN
      SELECT TP1NRO1
        INTO TipoComentario
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 111154
         AND TP1CORR1 = 1
         AND TP1CORR2 = 4
         AND TP1CORR3 > 0
         AND TP1NRO2 = CodTipoSolicitud;
    EXCEPTION
      WHEN OTHERS THEN
        TipoComentario := 1;
    END;*/
  
    IF NivelComent in (1, 2, 3) THEN
      --18112024
      --------
      IF xcorr2 > 0 THEN
        BEGIN
          UPDATE AQPC171
             SET AQPC171USUR    = usuario,
                 AQPC171ANCNEG  = xAQPC171ANCNEG,
                 AQPC171ANVIC   = xAQPC171ANVIC,
                 AQPC171FCN     = xAQPC171FCN,
                 AQPC171AESFCC  = xAQPC171AESFCC,
                 AQPC171RDCLN   = xAQPC171RDCLN,
                 AQPC171ANCP    = xAQPC171ANCP,
                 AQPC171ANCPG   = xAQPC171ANCPG,
                 AQPC171DANDC   = xAQPC171DANDC,
                 AQPC171DGCOR   = xAQPC171DGCOR,
                 AQPC171RANCNEG = xAQPC171RANCNEG,
                 AQPC171MTREP   = xAQPC171MTREP,
                 AQPC171RAESFCC = xAQPC171RAESFCC,
                 AQPC171ANCPRF  = xAQPC171ANCPRF,
                 AQPC171ANVPG   = xAQPC171ANVPG,
                 AQPC171DEGV    = xAQPC171DEGV,
                 AQPC171RFANCNE = xAQPC171RFANCNE,
                 AQPC171MTREFN  = xAQPC171MTREFN,
                 AQPC171RFAESFC = xAQPC171RFAESFC,
                 AQPC171RFANCPR = xAQPC171RFANCPR,
                 AQPC171RFANVPG = xAQPC171RFANVPG,
                 AQPC171RFDEGV  = xAQPC171RFDEGV,
                 AQPC171USURAR  = usuario,
                 AQPC171COMEN   = xComentRiesgos,
                 AQPC171RESOL   = xResoluRiesgos,
                 AQPC171CONREC  = xCondiRecomRiesg,
                 AQPC171ARGRECO = xAQPC171ARGRECO,
                 AQPC171ANACOME = xAQPC171ANACOME,
                 AQPC171RESOLRE = xAQPC171RESOLRE,
                 AQPC171CONDREC = xAQPC171CONDREC
           WHERE AQPC171CODOPI = codopini
             AND AQPC171INST = instancia
             AND AQPC171ESTAD = 'H';
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        flgEstObser := 'N';
        BEGIN
          --22012024
          SELECT 'S'
            INTO flgEstObser
            FROM AQPC156 A
           WHERE AQPC156CODOPI = codopini
             AND AQPC156INSTAN = instancia
             AND AQPC156ESTAD = 'H'
             AND TRIM(AQPC156ESTOP) <> 'O';
        EXCEPTION
          WHEN OTHERS THEN
            flgEstObser := 'N';
        END;
      
        IF flgEstObser = 'S' THEN
          UPDATE AQPC171
             SET AQPC171MOTOBSV = ''
           WHERE AQPC171CODOPI = codopini
             AND AQPC171INST = instancia
             AND AQPC171ESTAD = 'H';
          COMMIT;
        END IF;
      
      ELSE
        BEGIN
          INSERT INTO AQPC171
            (AQPC171CODOPI,
             AQPC171CORR,
             AQPC171USUR,
             AQPC171FECPRO,
             AQPC171INST,
             --AQPC171CARGO   ,
             AQPC171ANCNEG,
             AQPC171ANVIC,
             AQPC171FCN,
             AQPC171AESFCC,
             AQPC171RDCLN,
             AQPC171ANCP,
             AQPC171ANCPG,
             AQPC171DANDC,
             AQPC171DGCOR,
             AQPC171RANCNEG,
             AQPC171MTREP,
             AQPC171RAESFCC,
             AQPC171ANCPRF,
             AQPC171ANVPG,
             AQPC171DEGV,
             AQPC171RFANCNE,
             AQPC171MTREFN,
             AQPC171RFAESFC,
             AQPC171RFANCPR,
             AQPC171RFANVPG,
             AQPC171RFDEGV,
             AQPC171USURAR,
             AQPC171COMEN,
             AQPC171RESOL,
             AQPC171CONREC,
             AQPC171ARGRECO,
             AQPC171ANACOME,
             AQPC171RESOLRE,
             AQPC171CONDREC,
             AQPC171HORAREG,
             AQPC171ESTAD)
          VALUES
            (codopini,
             xcorr2 + 1,
             usuario,
             xfecha,
             instancia,
             --''              ,        
             xAQPC171ANCNEG,
             xAQPC171ANVIC,
             xAQPC171FCN,
             xAQPC171AESFCC,
             xAQPC171RDCLN,
             xAQPC171ANCP,
             xAQPC171ANCPG,
             xAQPC171DANDC,
             xAQPC171DGCOR,
             xAQPC171RANCNEG,
             xAQPC171MTREP,
             xAQPC171RAESFCC,
             xAQPC171ANCPRF,
             xAQPC171ANVPG,
             xAQPC171DEGV,
             xAQPC171RFANCNE,
             xAQPC171MTREFN,
             xAQPC171RFAESFC,
             xAQPC171RFANCPR,
             xAQPC171RFANVPG,
             xAQPC171RFDEGV,
             usuario,
             xComentRiesgos,
             xResoluRiesgos,
             xCondiRecomRiesg,
             xAQPC171ARGRECO,
             xAQPC171ANACOME,
             xAQPC171RESOLRE,
             xAQPC171CONDREC,
             xHora,
             'H');
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
      ---------------
      /*--para reconsideraciónes 
      v_ArgumReconsid    := '';
      v_AnaliComReconsid := '';
      v_ResolucReconsid  := '';
      v_CondicReconsid   := '';
      IF xAQPC156ESTOP = 'NV' THEN
        v_ArgumReconsid    := xAQPC171ARGRECO;
        v_AnaliComReconsid := xAQPC171ANACOME;
        v_ResolucReconsid  := xAQPC171RESOLRE;
        v_CondicReconsid   := xAQPC171CONDREC;
      END IF;
      
      IF TipoComentario = 1 THEN
        --Solicitud normal - ampliacion
        BEGIN
          INSERT INTO AQPC171
            (AQPC171CODOPI,
             AQPC171CORR,
             AQPC171USUR,
             AQPC171FECPRO,
             AQPC171INST,
             AQPC171CARGO,
             AQPC171ANCNEG,
             AQPC171ANVIC,
             AQPC171FCN,
             AQPC171AESFCC,
             AQPC171RDCLN,
             AQPC171ANCP,
             AQPC171ANCPG,
             AQPC171DANDC,
             AQPC171DGCOR,
             
             AQPC171USURAR, --ini 21082023
             AQPC171COMEN,
             AQPC171RESOL,
             AQPC171CONREC,
             AQPC171ARGRECO,
             AQPC171ANACOME,
             AQPC171RESOLRE,
             AQPC171CONDREC,
             AQPC171HORAREG,
             AQPC171ESTAD, --fin 21082023
             AQPC171MOTOBSV)
          VALUES
            (codopini,
             xcorr2,
             usuario,
             xfecha,
             instancia,
             xcargo,
             xAQPC171ANCNEG,
             xAQPC171ANVIC,
             xAQPC171FCN,
             xAQPC171AESFCC,
             xAQPC171RDCLN,
             xAQPC171ANCP,
             xAQPC171ANCPG,
             xAQPC171DANDC,
             xAQPC171DGCOR,
             
             usuario,
             xComentRiesgos,
             xResoluRiesgos,
             xCondiRecomRiesg,
             v_ArgumReconsid,
             v_AnaliComReconsid,
             v_ResolucReconsid,
             v_CondicReconsid,
             xHora,
             'H',
             xComenObserv); -- 21082023
          commit;
        END;
      END IF;
      
      IF TipoComentario = 2 THEN
        --reprogramación
        BEGIN
          INSERT INTO AQPC171
            (AQPC171CODOPI,
             AQPC171CORR,
             AQPC171USUR,
             AQPC171FECPRO,
             AQPC171INST,
             AQPC171CARGO,
             AQPC171RANCNEG,
             AQPC171MTREP,
             AQPC171RAESFCC,
             AQPC171ANCPRF,
             AQPC171ANVPG,
             AQPC171DEGV,
             
             AQPC171USURAR, --ini 21082023
             AQPC171COMEN,
             AQPC171RESOL,
             AQPC171CONREC,
             AQPC171ARGRECO,
             AQPC171ANACOME,
             AQPC171RESOLRE,
             AQPC171CONDREC,
             
             AQPC171HORAREG,
             AQPC171ESTAD, --21082023)
             AQPC171MOTOBSV
             )
          VALUES
            (codopini,
             xcorr2,
             usuario,
             xfecha,
             instancia,
             xcargo,
             xAQPC171RANCNEG,
             xAQPC171MTREP,
             xAQPC171RAESFCC,
             xAQPC171ANCPRF,
             xAQPC171ANVPG,
             xAQPC171DEGV,
             
             usuario,
             xComentRiesgos,
             xResoluRiesgos,
             xCondiRecomRiesg,
             v_ArgumReconsid,
             v_AnaliComReconsid,
             v_ResolucReconsid,
             v_CondicReconsid,
             xHora,
             'H',
             xComenObserv);
          commit;
        END;
      END IF;
      
      IF TipoComentario = 3 THEN
        --refinanciamiento
        BEGIN
          INSERT INTO AQPC171
            (AQPC171CODOPI,
             AQPC171CORR,
             AQPC171USUR,
             AQPC171FECPRO,
             AQPC171INST,
             AQPC171CARGO,
             
             AQPC171RFANCNE,
             AQPC171MTREFN,
             AQPC171RFAESFC,
             AQPC171RFANCPR,
             AQPC171RFANVPG,
             AQPC171RFDEGV,
             
             AQPC171USURAR, --ini 21082023
             AQPC171COMEN,
             AQPC171RESOL,
             AQPC171CONREC,
             AQPC171ARGRECO,
             AQPC171ANACOME,
             AQPC171RESOLRE,
             AQPC171CONDREC,
             
             AQPC171HORAREG,
             AQPC171ESTAD,
             AQPC171MOTOBSV)
          VALUES
            (codopini,
             xcorr2,
             usuario,
             xfecha,
             instancia,
             xcargo,
             xAQPC171RFANCNE,
             xAQPC171MTREFN,
             xAQPC171RFAESFC,
             xAQPC171RFANCPR,
             xAQPC171RFANVPG,
             xAQPC171RFDEGV,
             
             usuario,
             xComentRiesgos,
             xResoluRiesgos,
             xCondiRecomRiesg,
             v_ArgumReconsid,
             v_AnaliComReconsid,
             v_ResolucReconsid,
             v_CondicReconsid,
             xHora,
             'H',
             xComenObserv);
          commit;
        END;
      END IF;*/
    END IF;
  
  END;

  procedure sp_grabar_comentarios_riesgos(codopini       number,
                                          instancia      number,
                                          usuario        varchar2,
                                          NivelComent    number,
                                          xAQPC171COMEN  varchar2,
                                          xAQPC171RESOL  varchar2,
                                          xAQPC171CONREC varchar2) IS
    xusuario varchar2(10); --2108                                                                                                                                                                    
  begin
    IF NivelComent = 3 THEN
      --ETAPA RIESGOS --21082023 COMENTADO
      xusuario := usuario;
      /*BEGIN
        UPDATE AQPC171
           SET AQPC171COMEN  = xAQPC171COMEN,
               AQPC171RESOL  = xAQPC171RESOL,
               AQPC171CONREC = xAQPC171CONREC,
               AQPC171USURAR = usuario
         WHERE AQPC171CODOPI = codopini
           AND AQPC171INST = instancia;
        COMMIT;
      END;*/
    END IF;
  end;

  procedure sp_Consultar_codOpinio(instancia  number,
                                   flgEstado  varchar2,
                                   codNivel   number,
                                   codOpinio  out number,
                                   flgEstdOpi out varchar2) -- mod 10072023
   is
  begin
    codOpinio := 0;
    BEGIN
      SELECT AQPC156CODOPI, AQPC156ESTOP
        INTO codOpinio, flgEstdOpi -- mod 10072023
        FROM AQPC156
       WHERE AQPC156CODOPI = (SELECT MAX(A.AQPC156CODOPI)
                                FROM AQPC156 A
                               WHERE A.AQPC156INSTAN = instancia
                                 AND A.AQPC156ESTAD = 'H')
         AND AQPC156INSTAN = instancia
         AND AQPC156ESTAD = 'H' --2108
         AND AQPC156ESTOP <> 'T' -- 28112023
         AND AQPC156NIVEL = codNivel;
    EXCEPTION
      WHEN OTHERS THEN
        codOpinio := 0;
    END;
  end;

  procedure sp_actulizar_estado_156(codopinion       number,
                                    instancia        number,
                                    flgEstado        varchar2,
                                    CodNivel         number,
                                    p_UserDerivado   varchar2,
                                    AnalistaDerivado varchar2) is
  begin
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_grab_log_aqpc156(codopinion, instancia);
    END;
  
    CASE
      WHEN CodNivel = 1 THEN
        --18112024
        BEGIN
          UPDATE AQPC156
             SET --AQPC156GRAGE = p_UserDerivado, MOD 2402
                 AQPC156USRDER = AnalistaDerivado,
                 AQPC156ANSERIG = AnalistaDerivado,
                 AQPC156NIVEL   = CodNivel
           WHERE AQPC156CODOPI = codopinion
             AND AQPC156INSTAN = instancia
             AND AQPC156ESTAD = 'H'; --21082023
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      WHEN CodNivel IN (2, 3) THEN
        BEGIN
          UPDATE AQPC156
             SET AQPC156USRDER = AnalistaDerivado,
                 --AQPC156ANSERIG = AnalistaDerivado,
                 AQPC156NIVEL = CodNivel
           WHERE AQPC156CODOPI = codopinion
             AND AQPC156INSTAN = instancia
             AND AQPC156ESTAD = 'H'; --21082023
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      WHEN CodNivel = 4 THEN
        --OR CodNivel = 5 OR CodNivel = 6 THEN 1906
        BEGIN
          UPDATE AQPC156
             SET AQPC156NIVEL   = CodNivel,
                 AQPC156USRDER  = AnalistaDerivado,
                 AQPC156SUPADMI = AnalistaDerivado
           WHERE AQPC156CODOPI = codopinion
             AND AQPC156INSTAN = instancia
             AND AQPC156ESTAD = 'H'; --21082023
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      WHEN CodNivel = 5 THEN
        BEGIN
          UPDATE AQPC156
             SET AQPC156NIVEL   = CodNivel,
                 AQPC156USRDER  = AnalistaDerivado,
                 AQPC156JEFADMI = AnalistaDerivado
           WHERE AQPC156CODOPI = codopinion
             AND AQPC156INSTAN = instancia
             AND AQPC156ESTAD = 'H'; --21082023
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      WHEN CodNivel = 6 THEN
        BEGIN
          UPDATE AQPC156
             SET AQPC156NIVEL   = CodNivel,
                 AQPC156USRDER  = AnalistaDerivado,
                 AQPC156GERRIES = AnalistaDerivado
           WHERE AQPC156CODOPI = codopinion
             AND AQPC156INSTAN = instancia
             AND AQPC156ESTAD = 'H'; --21082023
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      ELSE
        NULL;
    END CASE;
  end;

  procedure sp_actualizar_estado_opi_156(codopinion number,
                                         instancia  number,
                                         flgEstado  varchar2) is
  begin
    BEGIN
      --2108
      pq_cr_repo_opinion_riesgos.sp_grab_log_aqpc156(codopinion, instancia);
    END;
  
    begin
      UPDATE AQPC156
         SET AQPC156ESTOP = flgEstado
       WHERE AQPC156CODOPI = codopinion
         AND AQPC156INSTAN = instancia
         AND AQPC156ESTAD = 'H'; --2108
      COMMIT;
    end;
  end;

  procedure sp_cargar_c162(codopin number) is
  BEGIN
    /*BEGIN
      DELETE FROM AQPC162 WHERE AQPC162CODOPI = codopin;
      COMMIT;
    END;*/
    BEGIN
      --11072023 
      UPDATE AQPC162
         SET AQPC162ESTAD = 'I'
       WHERE AQPC162CODOPI = codopin
         AND (AQPC162ESTAD = 'H' OR AQPC162ESTAD IS NULL);
      COMMIT;
    exception
      when others then
        NULL;
    END;
  END;
  procedure sp_insert_garnt_aqpc162(codopin       number,
                                    fechaHoy      date,
                                    tipGarant     varchar2,
                                    descGarnt     varchar2,
                                    propietar     varchar2,
                                    fecTasa       date,
                                    tasad         varchar2,
                                    valcom        varchar2,
                                    valRealiz     varchar2,
                                    valGravamen   varchar2,
                                    Cobertur      varchar2,
                                    xModulo       number,
                                    xTipOperacion number,
                                    p_tipDeclar   varchar2,
                                    p_fechDecl    date,
                                    p_valoGarnt   varchar2) is
    auxCorr      number(10);
    v_HoraActual VARCHAR2(8);
  begin
    /*BEGIN --11092023  comentado
      UPDATE AQPC162 
      SET AQPC162ESTAD = 'I'
      WHERE AQPC162CODOPI = codopin AND (AQPC162ESTAD = 'H' OR AQPC162ESTAD IS NULL );
      --DELETE FROM AQPC162 WHERE AQPC162CODOPI = codopin;
      COMMIT;
    exception
      when others then
        NULL;
    END;*/
  
    v_HoraActual := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  
    begin
      select max(AQPC162CORR)
        into auxCorr
        from aqpc162
       where AQPC162CODOPI = codopin;
    exception
      when others then
        auxCorr := 0;
    end;
  
    IF auxCorr IS NULL THEN
      auxCorr := 0;
    END IF;
  
    auxCorr := auxCorr + 1;
  
    BEGIN
      INSERT INTO AQPC162
        (AQPC162CODOPI,
         AQPC162CORR,
         AQPC162FECPRO,
         AQPC162TIPGAR,
         AQPC162DESGAR,
         AQPC162PROP,
         AQPC162FTASA,
         AQPC162TASD,
         AQPC162VGCOM,
         AQPC162VREAGAR,
         AQPC162VGRAV,
         AQPC162VGOBERT,
         AQPC162MODU,
         AQPC162TOPE,
         AQPC162TIPBIDE,
         AQPC162FECDECL,
         AQPC162VALGARN,
         AQPC162HORAREG,
         AQPC162ESTAD) --2108
      VALUES
        (codopin,
         auxCorr,
         fechaHoy,
         tipGarant,
         descGarnt,
         propietar,
         fecTasa,
         tasad,
         valcom,
         valRealiz,
         valGravamen,
         Cobertur,
         xModulo,
         xTipOperacion,
         p_tipDeclar,
         p_fechDecl,
         p_valoGarnt,
         v_HoraActual,
         'H');
      commit;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  end;

  procedure sp_cargar_c161(codopin number) is
  BEGIN
    BEGIN
      DELETE FROM AQPC161 WHERE AQPC161CODOPI = codopin;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;
  procedure sp_insert_relacFinan_aqpc161(codopin   number,
                                         fechaHoy  date,
                                         EntiFinc  varchar2,
                                         Cuota     varchar2,
                                         sldoCapit varchar2,
                                         TipoCred  varchar2) is
    auxCorr      number(10);
    v_HoraActual VARCHAR2(8);
  begin
    v_HoraActual := TO_CHAR(SYSDATE, 'HH24:MI:SS'); --0308
  
    BEGIN
      select max(aqpc161corr)
        into auxCorr
        from aqpc161
       where AQPC161CODOPI = codopin;
    EXCEPTION
      WHEN OTHERS THEN
        auxCorr := 0;
    END;
  
    IF auxCorr IS NULL THEN
      auxCorr := 0;
    END IF;
  
    auxCorr := auxCorr + 1;
  
    BEGIN
      INSERT INTO AQPC161
        (AQPC161CODOPI,
         aqpc161corr,
         AQPC161FECPRO,
         AQPC161ENTFIN,
         -- AQPC161MONTRLF,
         -- AQPC161PLZORLF,
         AQPC161CUOTRLF,
         AQPC161SDORLF,
         --AQPC161CUOCAN,
         --AQPC161TEARLF,
         AQPC161CLASFRLF,
         AQPC161HORAREG)
      VALUES
        (codopin,
         auxCorr,
         fechaHoy,
         EntiFinc,
         Cuota,
         sldoCapit,
         TipoCred,
         v_HoraActual);
      commit;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  end;
  procedure sp_valid_Segm_NoMinorista(instancia   number,
                                      flgEsNoMino out varchar2) is
    auxSegm   varchar2(30);
    xposi     number(3);
    xtextSegm varchar2(30);
  begin
    BEGIN
      select WFATTSVAL
        into auxSegm
        from wfattsvalues
       where WFINSPRCID = instancia
         AND wfattsid in ('TIPO_CREDITO')
         and trim(wfattsval) is not null;
    EXCEPTION
      WHEN OTHERS THEN
        auxSegm := '';
    END;
    begin
      select instr(auxSegm, ';', 1, 1) into xposi from dual;
    EXCEPTION
      WHEN OTHERS THEN
        xposi := 0;
    end;
    xtextSegm := substr(auxSegm, xposi + 1, 30 - xposi);
    xtextSegm := upper(xtextSegm);
  
    --MOD 24072023
    flgEsNoMino := 'N';
    BEGIN
      SELECT 'S'
        INTO flgEsNoMino
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND TP1CORR1 = 15
         AND TP1CORR2 = 1
         AND TP1CORR3 > 0
         AND TP1DESC = RPAD(xtextSegm, 30, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        flgEsNoMino := 'N';
    END;
  
    /*IF TRIM(xtextSegm) = 'MEDIANA EMPRESA' OR
       TRIM(xtextSegm) = 'GRANDE EMPRESA' OR
       TRIM(xtextSegm) = 'CORPORATIVOS' THEN
       flgEsNoMino := 'S';
    END IF;*/
  end;

  procedure sp_grabarLogEstadoOpinion(codOpinion   number,
                                      fechaActual  date,
                                      Hora         varchar2,
                                      UsuarioEjec  varchar2,
                                      codCadena    number,
                                      estadoActual varchar2) IS
    xDescEtapa1 varchar2(50);
    xNomUsuario varchar2(50);
    xCorrelat   number(4);
    v_EstdActu  varchar2(2);
    v_HoraActual VARCHAR2(10);
  begin
    BEGIN --20022025
      v_HoraActual  := TO_CHAR(SYSDATE, 'HH24:MI:SS');
    EXCEPTION
      WHEN OTHERS THEN
        v_HoraActual := Hora;
    END;  
  
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_descripcion_ArbolPerfiles(codCadena,
                                                              xDescEtapa1); --18112024
    EXCEPTION
      when OTHERS THEN
        NULL;
    END;
  
    --Nombre usuario
    BEGIN
      SELECT UBNOM
        into xNomUsuario
        FROM FST746
       WHERE UBUSER = rpad(UsuarioEjec, 10, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      -- INI MOD RCASTRO 10072023
      SELECT max(AQPC801AUX1)
        INTO xCorrelat
        FROM AQPC801
       WHERE AQPC801CODOPI = codOpinion;
    EXCEPTION
      WHEN OTHERS THEN
        xCorrelat := 0;
    END;
  
    xCorrelat := NVL(xCorrelat, 0);
  
    ---VALIDAMOS SI EXISTE REGIS CON P PARA ACTUALIZAR Y NO INSERTAR 21022024
    BEGIN
      SELECT AQPC801ESTDA
        INTO v_EstdActu
        FROM AQPC801
       WHERE AQPC801CODOPI = codOpinion
         AND AQPC801AUX1 = xCorrelat;
    EXCEPTION
      WHEN OTHERS THEN
        v_EstdActu := '';
    END;
  
    IF v_EstdActu = 'P' THEN
      BEGIN
        UPDATE AQPC801
           SET AQPC801CODETA = codCadena,
               AQPC801ETAPA  = xDescEtapa1,
               AQPC801ESTDA  = estadoActual,
               AQPC801USREJ  = UsuarioEjec,
               AQPC801NIVL   = codCadena,
               AQPC801AUX2   = xNomUsuario,
               AQPC801FECH   = fechaActual,
               AQPC801HOR    = v_HoraActual
         WHERE AQPC801CODOPI = codOpinion
           AND AQPC801AUX1 = xCorrelat
           AND AQPC801ESTDA = 'P';
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    ELSE
      xCorrelat := xCorrelat + 1; -- FIN MOD RCASTRO 10072023
      BEGIN
        INSERT INTO AQPC801
          (AQPC801CORR,
           AQPC801CODOPI,
           AQPC801FECH,
           AQPC801HOR,
           AQPC801CODETA,
           AQPC801ETAPA,
           AQPC801ESTDA,
           AQPC801USREJ,
           AQPC801NIVL,
           AQPC801AUX2,
           AQPC801AUX1) -- INI MOD RCASTRO 10072023
        VALUES
          (0,
           codOpinion,
           fechaActual,
           v_HoraActual,
           codCadena,
           xDescEtapa1,
           estadoActual,
           UsuarioEjec,
           codCadena,
           xNomUsuario,
           xCorrelat);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  end sp_grabarLogEstadoOpinion;

  procedure sp_cambiarEstadoAqpc156(Instancia      number,
                                    codopinion     number,
                                    flgCambiEstado varchar2,
                                    codNivel       number,
                                    NuevoAsunto    varchar2) is
  begin
    BEGIN
      --2108
      pq_cr_repo_opinion_riesgos.sp_grab_log_aqpc156(codOpinion, instancia);
    END;
  
    IF flgCambiEstado = 'E' THEN
      --proc. enviar
      BEGIN
        update aqpc156
           SET AQPC156NIVEL = codNivel
         WHERE AQPC156CODOPI = codopinion
           AND AQPC156ESTAD = 'H'; --2108
        COMMIT;
      END;
    ELSE
      IF flgCambiEstado IS NULL OR flgCambiEstado = ' ' THEN
        --1906 Para devolver en etapa superiores supervisor, jefe y gerente
        begin
          update aqpc156
             set --AQPC156ESTOP = flgCambiEstado,
                 AQPC156NIVEL = codNivel
          --AQPC156ASUNT = NuevoAsunto
           WHERE AQPC156CODOPI = codopinion
             AND AQPC156ESTAD = 'H'; --2108
          commit;
        end;
      ELSE
        begin
          update aqpc156
             set AQPC156ESTOP = flgCambiEstado, -- 'O' ESTADO DE OBSERVADO
                 AQPC156NIVEL = codNivel,
                 AQPC156ASUNT = NuevoAsunto
           WHERE AQPC156CODOPI = codopinion
             AND AQPC156ESTAD = 'H'; --2108
          commit;
        end;
      END IF;
    END IF;
  end;

  procedure sp_validar_Etapa_Opin(Instancia  number,
                                  codopinion number,
                                  codNIVEL   out number,
                                  DescEtapa  out varchar2) is
  BEGIN
    BEGIN
      SELECT A.AQPC801ETAPA, A.AQPC801NIVL
        INTO DescEtapa, codNIVEL
        FROM AQPC801 A
       WHERE A.AQPC801CORR =
             (SELECT MAX(B.AQPC801CORR)
                FROM AQPC801 B
               WHERE B.AQPC801CODOPI = codopinion)
         AND A.AQPC801CODOPI = codopinion;
    EXCEPTION
      WHEN OTHERS THEN
        DescEtapa := 'ANALISTA SENIOR DE RIESGOS'; -- MOD 10072023
        codNIVEL  := 1;
    END;
    DescEtapa := to_char(codNIVEL) || '-' || DescEtapa;
  
  END;

  procedure sp_actualizarEstado156(intancia   number,
                                   codOpinion number,
                                   FlgEstado  varchar2) is
  begin
    BEGIN
      --2108
      pq_cr_repo_opinion_riesgos.sp_grab_log_aqpc156(codOpinion, intancia);
    END;
  
    begin
      UPDATE AQPC156
         SET AQPC156ESTOP = FlgEstado
       WHERE AQPC156CODOPI = codopinion
         AND AQPC156INSTAN = intancia
         AND AQPC156ESTAD = 'H'; --2108;
      COMMIT;
    exception
      when others then
        null;
    end;
  end;

  procedure sp_buscar_usuario_correo_GA(SucurCredito numeric,
                                        xCodCargo    number,
                                        UsuarioGA    out varchar2,
                                        xEmail       out varchar2) is
    --xUbuser varchar2(10);  
    xFecha     date;
    xCodZona   number(5);
    auxUsuario varchar2(10);
    xTp1desc   varchar2(30);
    xchar      char(30);
    usexxx     varchar2(10);
  Begin
    BEGIN
      SELECT PGFAPE INTO xFecha FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        xFecha := to_date(sysdate);
    END;
    --Gerente de Zona/Region
    IF xCodCargo = 220 THEN
      BEGIN
        SELECT REGCOD
          INTO xCodZona
          FROM FST811
         WHERE OFICOD = SucurCredito
           AND REGCOD < 100
           AND ROWNUM < 2;
      EXCEPTION
        WHEN OTHERS THEN
          xCodZona := 0;
      END;
    
      --- MOD 25072023
      BEGIN
        select trim(TP1DESC)
          INTO xTp1desc -- 01082023 auxUsuario
          from fst198
         Where tp1cod = 1
           and tp1cod1 = 11152
           and tp1corr1 = 20
           and TP1CORR2 = 1
           and TP1NRO2 = xCodZona
           AND ROWNUM < 2;
      EXCEPTION
        WHEN OTHERS THEN
          xTp1desc := ' '; --0108       
      END;
    
      auxUsuario := trim(substr(xTp1desc, 1, 10));
    
      IF auxUsuario IS NULL OR auxUsuario = ' ' THEN
        BEGIN
          SELECT B.UBUSER
            INTO auxUsuario
            FROM SNG057 A, FST046 B
           WHERE B.UBUSER = A.SNG057USR
             AND B.UBSUC IN
                 (SELECT OFICOD FROM FST811 WHERE REGCOD = xCodZona)
             AND A.SNG055CAR = xCodCargo
             and rownum < 2;
        EXCEPTION
          WHEN OTHERS THEN
            auxUsuario := '';
        END;
      END IF;
    
    ELSE
      BEGIN
        SELECT B.UBUSER
          INTO auxUsuario
          FROM SNG057 A, FST046 B
         WHERE B.UBUSER = A.SNG057USR
           AND B.UBSUC = SucurCredito
           AND A.SNG055CAR = xCodCargo -- 202 ga - 220 GZ
              /* and SNG057INI <= xFecha
              and xFecha <= SNG057FIN*/
           and rownum < 2;
      EXCEPTION
        WHEN OTHERS THEN
          auxUsuario := '';
      END;
    END IF;
  
    UsuarioGA := auxUsuario;
    BEGIN
      SELECT w.wfusremail
        INTO xEmail
        FROM FST046 K, WFUSERS W
       WHERE K.PGCOD = 1
         AND K.UBUSER = W.WFUSRCOD
         AND K.UBUSER = rpad(UsuarioGA, 10, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        xEmail := ' ';
    END;
  End;

  procedure sp_actualizar_GA_156(codOpinion number,
                                 solicitud  number,
                                 userGA     varchar2) is
  begin
    BEGIN
      --2108
      pq_cr_repo_opinion_riesgos.sp_grab_log_aqpc156(codOpinion, solicitud);
    END;
    begin
      update aqpc156
         set AQPC156GRAGE = userGA
       where AQPC156CODOPI = codOpinion
         and AQPC156INSTAN = solicitud
         AND AQPC156ESTAD = 'H'; --2108
      commit;
    end;
  end;

  procedure sp_delegar_analis_senior(codOpinion    number,
                                     solicitud     number,
                                     cuenta        number,
                                     codAnalista   varchar2,
                                     NivelAprobOpi number,
                                     codNivelPerfiDeriv number) is
    --21022024
    auxFechaDeleg date;
    FLGest varchar2(1);
  begin
    auxFechaDeleg := to_date(sysdate);
  
    BEGIN
      --2108
      pq_cr_repo_opinion_riesgos.sp_grab_log_aqpc156(codOpinion, solicitud);
    END;
  
    CASE
      WHEN NivelAprobOpi = 1 THEN   --18112024
        begin
          update aqpc156
             set AQPC156USRDER  = codAnalista,
                 AQPC156ANSERIG = codAnalista,
                 AQPC156FECDEL  = auxFechaDeleg,
                 AQPC156NIVEL   = codNivelPerfiDeriv
           where AQPC156CODOPI = codOpinion
             and AQPC156INSTAN = solicitud
             AND AQPC156ESTAD = 'H'; --21022024;
          commit;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
      end;      
    
      WHEN NivelAprobOpi IN (2,3) THEN 
       FLGest := 'N';
       BEGIN --20022025
         
             pq_cr_repo_opinion_riesgos.sp_validar_estado_opin(1 , 
                                                               codOpinion, 
                                                               solicitud, 
                                                               FLGest);
       END;  
       IF FLGest = 'S' THEN      
            begin
              update aqpc156
                 set AQPC156USRDER  = codAnalista,
                     AQPC156ANSERIG = codAnalista,
                     AQPC156FECDEL  = auxFechaDeleg,
                     AQPC156NIVEL   = codNivelPerfiDeriv
               where AQPC156CODOPI = codOpinion
                 and AQPC156INSTAN = solicitud
                 AND AQPC156ESTAD = 'H'; --21022024;
              commit;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            end;
       ELSE 
             begin
                update aqpc156
                   set AQPC156USRDER  = codAnalista,
                       --AQPC156ANSERIG = codAnalista,
                       AQPC156FECDEL  = auxFechaDeleg,
                       AQPC156NIVEL   = codNivelPerfiDeriv
                 where AQPC156CODOPI = codOpinion
                   and AQPC156INSTAN = solicitud
                   AND AQPC156ESTAD = 'H'; --21022024;
                commit;
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              end;         
       END IF;
      WHEN NivelAprobOpi = 4 THEN
        begin
          UPDATE AQPC156
             SET AQPC156USRDER  = codAnalista,
                 AQPC156SUPADMI = codAnalista,
                 AQPC156FECDEL  = auxFechaDeleg
           WHERE AQPC156CODOPI = codopinion
             AND AQPC156INSTAN = solicitud
             AND AQPC156ESTAD = 'H'; --21022024
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        end;
      WHEN NivelAprobOpi = 5 THEN
        BEGIN
          UPDATE AQPC156
             SET AQPC156USRDER  = codAnalista,
                 AQPC156JEFADMI = codAnalista,
                 AQPC156FECDEL  = auxFechaDeleg
           WHERE AQPC156CODOPI = codopinion
             AND AQPC156INSTAN = solicitud
             AND AQPC156ESTAD = 'H'; --21022024
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        end;
      WHEN NivelAprobOpi = 6 THEN
        BEGIN
          UPDATE AQPC156
             SET AQPC156USRDER  = codAnalista,
                 AQPC156GERRIES = codAnalista,
                 AQPC156FECDEL  = auxFechaDeleg
           WHERE AQPC156CODOPI = codopinion
             AND AQPC156INSTAN = solicitud
             AND AQPC156ESTAD = 'H'; --21022024
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      ELSE
        NULL;
    END CASE;
  
  end;

  procedure sp_obtener_correos_usuarios(flujo          number,          
                                        codOpinion     number,
                                        instancia      number,
                                        FechaHoy       date, --Ini Mod 25072023
                                        sucuCred       number,
                                      /*UsuAnalisCred  varchar2,   18112024
                                        UsuGA          varchar2,
                                        UsuGZona       varchar2,
                                        UsuARiesgos    varchar2, --Ini Mod 10072023
                                        UsuSupervAdm   varchar2,
                                        UsuJefeAdm     varchar2,
                                        UsuGereRiesg   varchar2, --Fin Mod 10072023  */
                                        Correos        out varchar2,
                                        CorreosEnCopia out varchar2) is
    xCorreo1 varchar2(40);
    xCorreo2 varchar2(40);
    xCorreo3 varchar2(40);
    xCorreo4 varchar2(40);
    xCorreo5 varchar2(40);
    xCorreo6 varchar2(40);
    xCorreo7 varchar2(40);
    xCorreo8 varchar2(40);
    xCorreo9 varchar2(40);    
  
    auxUsuSuple   varchar2(10);
    auxCoreoSuple varchar2(50);
    
    --18112024
    UsuARiesgos   varchar2(10);
    UsuSupervAdm  varchar2(10);
    UsuJefeAdm    varchar2(10);
    UsuGereRiesg  varchar2(10);      
     
    UsuAnalisCred varchar2(10); 
    UsuGA         varchar2(10);
    usuNivelAprb1 varchar2(10);
    usuNivelAprb2 varchar2(10);
    usuNivelAprb3 varchar2(10);
    usuNivelAprb4 varchar2(10);
    usuNivelAprb5 varchar2(10);
    usuNivelAprb6 varchar2(10);    
    xCodCargo     number(4);
    UsuGZona    varchar2(20);
    correoGZona   varchar2(40);
    
  begin
    CorreosEnCopia := '';
    Correos        := '';
    ---
    BEGIN
         pq_cr_repo_opinion_riesgos.sp_obtnUsuariosAprobad(flujo,
                                                           CodOpinion,
                                                           instancia,
                                                           UsuAnalisCred,   
                                                           usuGA ,       
                                                           usuNivelAprb1,
                                                           usuNivelAprb2,
                                                           usuNivelAprb3,
                                                           usuNivelAprb4,
                                                           usuNivelAprb5,
                                                           usuNivelAprb6                                                           
                                                           );
    EXCEPTION
        WHEN OTHERS THEN
          NULL;                                                           
    END;  
    
    UsuARiesgos   := usuNivelAprb1;
    UsuSupervAdm  := usuNivelAprb4;    
    UsuJefeAdm    := usuNivelAprb5;  
    UsuGereRiesg  := usuNivelAprb6;  
    
    --usuario zona
    xCodCargo := 220;
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_buscar_usuario_correo_GA(sucuCred,
                                                             xCodCargo,
                                                             UsuGZona,
                                                             correoGZona);
    EXCEPTION
      WHEN OTHERS THEN
        UsuGZona := '';
        correoGZona := '';
    END;
           
    -----                
    begin
      select WFUSREMAIL
        into xCorreo1
        from wFusers
       WHERE trim(WFUSRCOD) = trim(UsuAnalisCred);
    exception
      when others then
        xCorreo1 := ' ';
    end;
  
    If xCorreo1 <> ' ' Then
      If Correos is null then
        Correos := TRIM(xCorreo1);
      Else
        Correos := Correos || ';' || TRIM(xCorreo1);
      End If;
    End If;      
    -- validar suplencia  25072023
    auxCoreoSuple := ' ';
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_obtn_usuar_suplencia(FechaHoy,
                                                         UsuAnalisCred,
                                                         auxUsuSuple,
                                                         auxCoreoSuple);
    exception
      when others then
        auxCoreoSuple := ' ';
    END;
  
    IF auxCoreoSuple <> ' ' then
      CorreosEnCopia := trim(auxCoreoSuple);
    END IF;
  
    begin
      select WFUSREMAIL
        into xCorreo2
        from wFusers
       WHERE trim(WFUSRCOD) = trim(UsuGA);
    exception
      when others then
        xCorreo2 := ' ';
    end;
  
    If xCorreo2 <> ' ' Then
      If Correos is null then
        Correos := TRIM(xCorreo2);
      Else
        Correos := Correos || ';' || TRIM(xCorreo2);
      End If;
    End If;
  
    -- validar suplencia  25072023
    auxCoreoSuple := ' ';
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_obtn_usuar_suplencia(FechaHoy,
                                                         UsuGA,
                                                         auxUsuSuple,
                                                         auxCoreoSuple);
    exception
      when others then
        auxCoreoSuple := ' ';
    END;
  
    IF auxCoreoSuple <> ' ' then
      IF CorreosEnCopia is null then
        CorreosEnCopia := TRIM(auxCoreoSuple);
      ELSE
        CorreosEnCopia := CorreosEnCopia || ';' || trim(auxCoreoSuple);
      END IF;
    END IF;
  
    begin
      select WFUSREMAIL
        into xCorreo3
        from wFusers
       WHERE trim(WFUSRCOD) = trim(UsuGZona);
    exception
      when others then
        xCorreo3 := ' ';
    end;
  
    If xCorreo3 <> ' ' Then
      If Correos is null then
        Correos := TRIM(xCorreo3);
      Else
        Correos := Correos || ';' || TRIM(xCorreo3);
      End If;
    End If;
  
    -- validar suplencia  25072023
    auxCoreoSuple := ' ';
    auxUsuSuple   := ' ';
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_obtn_usuar_suplencia(FechaHoy,
                                                         UsuGZona,
                                                         auxUsuSuple,
                                                         auxCoreoSuple);
    exception
      when others then
        auxCoreoSuple := ' ';
    END;
  
    IF auxCoreoSuple <> ' ' then
      IF CorreosEnCopia is null then
        CorreosEnCopia := TRIM(auxCoreoSuple);
      ELSE
        CorreosEnCopia := CorreosEnCopia || ';' || trim(auxCoreoSuple);
      END IF;
    END IF;
  
    -- A. riesgos, supervisor adm., jefe adm. y gerente de riesgos
    --CorreosEnCopia := '';
    begin
      select WFUSREMAIL
        into xCorreo4
        from wFusers
       WHERE trim(WFUSRCOD) = trim(UsuARiesgos);
    exception
      when others then
        xCorreo4 := ' ';
    end;
  
    If xCorreo4 <> ' ' then
      If CorreosEnCopia is null then
        CorreosEnCopia := TRIM(xCorreo4);
      Else
        CorreosEnCopia := CorreosEnCopia || ';' || TRIM(xCorreo4);
      End If;
    End If;
  
    -- validar suplencia  25072023
    auxCoreoSuple := ' ';
    auxUsuSuple   := ' ';
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_obtn_usuar_suplencia(FechaHoy,
                                                         UsuARiesgos,
                                                         auxUsuSuple,
                                                         auxCoreoSuple);
    exception
      when others then
        auxCoreoSuple := ' ';
    END;
  
    IF auxCoreoSuple <> ' ' then
      IF CorreosEnCopia is null then
        CorreosEnCopia := TRIM(auxCoreoSuple);
      ELSE
        CorreosEnCopia := CorreosEnCopia || ';' || trim(auxCoreoSuple);
      END IF;
    END IF;
  
    begin
      select WFUSREMAIL
        into xCorreo5
        from wFusers
       WHERE trim(WFUSRCOD) = trim(UsuSupervAdm);
    exception
      when others then
        xCorreo5 := ' ';
    end;
  
    If xCorreo5 <> ' ' Then
      If CorreosEnCopia is null then
        CorreosEnCopia := TRIM(xCorreo5);
      Else
        CorreosEnCopia := CorreosEnCopia || ';' || TRIM(xCorreo5);
      End If;
    End If;
  
    -- validar suplencia  25072023
    auxCoreoSuple := ' ';
    auxUsuSuple   := ' ';
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_obtn_usuar_suplencia(FechaHoy,
                                                         UsuSupervAdm,
                                                         auxUsuSuple,
                                                         auxCoreoSuple);
    exception
      when others then
        auxCoreoSuple := ' ';
    END;
  
    IF auxCoreoSuple <> ' ' then
      IF CorreosEnCopia is null then
        CorreosEnCopia := TRIM(auxCoreoSuple);
      ELSE
        CorreosEnCopia := CorreosEnCopia || ';' || trim(auxCoreoSuple);
      END IF;
    END IF;
  
    begin
      select WFUSREMAIL
        into xCorreo6
        from wFusers
       WHERE trim(WFUSRCOD) = trim(UsuJefeAdm);
    exception
      when others then
        xCorreo6 := ' ';
    end;
  
    If xCorreo6 <> ' ' Then
      If CorreosEnCopia is null then
        CorreosEnCopia := TRIM(xCorreo6);
      Else
        CorreosEnCopia := CorreosEnCopia || ';' || TRIM(xCorreo6);
      End If;
    End If;
  
    -- validar suplencia  25072023
    auxCoreoSuple := ' ';
    auxUsuSuple   := ' ';
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_obtn_usuar_suplencia(FechaHoy,
                                                         UsuJefeAdm,
                                                         auxUsuSuple,
                                                         auxCoreoSuple);
    exception
      when others then
        auxCoreoSuple := ' ';
    END;
  
    IF auxCoreoSuple <> ' ' then
      IF CorreosEnCopia is null then
        CorreosEnCopia := TRIM(auxCoreoSuple);
      ELSE
        CorreosEnCopia := CorreosEnCopia || ';' || trim(auxCoreoSuple);
      END IF;
    END IF;
  
    begin
      select WFUSREMAIL
        into xCorreo7
        from wFusers
       WHERE trim(WFUSRCOD) = trim(UsuGereRiesg);
    exception
      when others then
        xCorreo7 := ' ';
    end;
  
    If xCorreo7 <> ' ' Then
      If CorreosEnCopia is null then
        CorreosEnCopia := TRIM(xCorreo7);
      Else
        CorreosEnCopia := CorreosEnCopia || ';' || TRIM(xCorreo7);
      End If;
    End If;
  
    -- validar suplencia  25072023
    auxCoreoSuple := ' ';
    auxUsuSuple   := ' ';
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_obtn_usuar_suplencia(FechaHoy,
                                                         UsuGereRiesg,
                                                         auxUsuSuple,
                                                         auxCoreoSuple);
    exception
      when others then
        auxCoreoSuple := ' ';
    END;
  
    IF auxCoreoSuple <> ' ' then
      IF CorreosEnCopia is null then
        CorreosEnCopia := TRIM(auxCoreoSuple);
      ELSE
        CorreosEnCopia := CorreosEnCopia || ';' || trim(auxCoreoSuple);
      END IF;
    END IF;
    
    ---se agrega perfiles nuevos 2,3 18112024
    begin
      select WFUSREMAIL
        into xCorreo8
        from wFusers
       WHERE WFUSRCOD = rpad(usuNivelAprb2,30, ' ');
    exception
      when others then
        xCorreo8 := ' ';
    end;
  
    If xCorreo8 <> ' ' Then
      If CorreosEnCopia is null then
        CorreosEnCopia := TRIM(xCorreo8);
      Else
        CorreosEnCopia := CorreosEnCopia || ';' || TRIM(xCorreo8);
      End If;
    End If;
  
    -- validar suplencia  25072023
    auxCoreoSuple := ' ';
    auxUsuSuple   := ' ';
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_obtn_usuar_suplencia(FechaHoy,
                                                         usuNivelAprb2,
                                                         auxUsuSuple,
                                                         auxCoreoSuple);
    exception
      when others then
        auxCoreoSuple := ' ';
    END;
  
    IF auxCoreoSuple <> ' ' then
      IF CorreosEnCopia is null then
        CorreosEnCopia := TRIM(auxCoreoSuple);
      ELSE
        CorreosEnCopia := CorreosEnCopia || ';' || trim(auxCoreoSuple);
      END IF;
    END IF;    
    ---
    begin
      select WFUSREMAIL
        into xCorreo9
        from wFusers
       WHERE WFUSRCOD = rpad(usuNivelAprb3,30, ' ');
    exception
      when others then
        xCorreo9 := ' ';
    end;
  
    If xCorreo9 <> ' ' Then
      If CorreosEnCopia is null then
        CorreosEnCopia := TRIM(xCorreo9);
      Else
        CorreosEnCopia := CorreosEnCopia || ';' || TRIM(xCorreo9);
      End If;
    End If;
  
    -- validar suplencia  25072023
    auxCoreoSuple := ' ';
    auxUsuSuple   := ' ';
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_obtn_usuar_suplencia(FechaHoy,
                                                         usuNivelAprb3,
                                                         auxUsuSuple,
                                                         auxCoreoSuple);
    exception
      when others then
        auxCoreoSuple := ' ';
    END;
  
    IF auxCoreoSuple <> ' ' then
      IF CorreosEnCopia is null then
        CorreosEnCopia := TRIM(auxCoreoSuple);
      ELSE
        CorreosEnCopia := CorreosEnCopia || ';' || trim(auxCoreoSuple);
      END IF;
    END IF;      
    
  
    IF Correos IS NULL OR Correos = ' ' THEN
      Correos        := CorreosEnCopia;
      CorreosEnCopia := '';
    END IF;
  
  end;

  procedure sp_actual_propuesto_156(instancia  number,
                                    codOpini   number,
                                    saldo      out number,
                                    montootorg out varchar2,
                                    cuotas     out number,
                                    ncuotas    out varchar2,
                                    tasa       out number) is
  Begin
    BEGIN
      --add 2108
      SELECT AQPC156SLDPROP,
             AQPC156MODPRP,
             AQPC156CUOTAS,
             AQPC156CUOPRP,
             AQPC156TASPRP
        INTO saldo, montootorg, cuotas, ncuotas, tasa
        FROM AQPC156
       WHERE AQPC156CODOPI = CODOPINI
         AND AQPC156INSTAN = INSTANCIA
         AND AQPC156ESTAD = 'H';
    
      /*update aqpc156   21082023 comentado
         set AQPC156SLDPROP = saldo,
             AQPC156MODPRP  = montootorg,
             AQPC156CUOTAS  = cuotas,
             AQPC156CUOPRP  = ncuotas,
             AQPC156TASPRP  = tasa
       where aqpc156codopi = codOpini
         and AQPC156INSTAN = instancia
         AND AQPC156ESTAD = 'H';  --2108;
      commit;*/
    exception
      when others then
        saldo      := 0;
        montootorg := 0;
        cuotas     := 0;
        ncuotas    := 0;
        tasa       := 0;
    End;
  End;

  procedure sp_valid_aprob_anriesgo(codOpini number, flgEstd out varchar2) is
  begin
    begin
      select 'S'
        INTO flgEstd
        from AQPC801
       where AQPC801CODOPI = codOpini
         and AQPC801NIVL >= 1 --3  18112024
         and rownum < 2;
    EXCEPTION
      WHEN OTHERS THEN
        flgEstd := 'N';
    end;
  end;

  procedure sp_val_etap_aprobacion(instancia     number,
                                   xflagEstAprob OUT varchar2) is
  
  BEGIN
    xflagEstAprob := 'N';
    BEGIN
      select 'S'
        INTO xflagEstAprob
        FROM wfwrkitems b, xwf700 c
       where b.wfiteminit = (select max(bx.wfiteminit)
                               from wfwrkitems bx
                              WHERE bx.wfinsprcid = b.wfinsprcid
                                and bx.wftaskcod = 11)
         and b.wftaskcod = 11
         and b.wfinsprcid = c.xwfprcins
         and c.xwfprcins = instancia
         and c.xwfcar3 = '1'
         and b.WFITEMSTSACT = 1;
    EXCEPTION
      WHEN OTHERS THEN
        xflagEstAprob := 'N'; --2504 drop  
    END;
    --xflagEstAprob := 'S'; -- prueba 2410     
  END;

  procedure sp_actuali_responsTotal(instancia     number,
                                    xcodOpinion   number,
                                    montoConsolid number,
                                    fechaHoy      date,
                                    sucurCred     number) is
    UsuarioGA  varchar2(10);
    xEmail     varchar2(100);
    xCodCargo  number(4);
    UsuarioASE varchar2(10);
  BEGIN
    --actualizar ACreditos y GA
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_obtenr_usu_AC_GA(instancia,
                                                     sucurCred,
                                                     UsuarioGA,
                                                     UsuarioASE);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      UPDATE AQPC156
         SET AQPC156RESPTOT = montoConsolid,
             AQPC156AUX3    = fechaHoy, -- AQPC156FECPRO  = fechaHoy,  27072023 
             AQPC156USUREG  = UsuarioASE,
             AQPC156GRAGE   = UsuarioGA
       WHERE AQPC156CODOPI = xcodOpinion
         AND AQPC156INSTAN = instancia
         AND AQPC156ESTAD = 'H'; --2108;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        null;
    END;
  END;

  procedure sp_obtn_cuot_cred_vigentes(instancia         number,
                                       xSumcuotaVigRec   OUT number,
                                       xSumcuotaVigAnter OUT number,
                                       xCredicContingAct out number, --21082023  
                                       xCredicContingAnt out number, --21082023                                     
                                       xCredPotencAct    OUT number, --21082023
                                       xCredPotencAnt    OUT number --21082023                                      
                                       ) is
    auxPais    number(3);
    auxPetdoc  number(3);
    auxPendoc  varchar2(12);
    auxInstnc  number(10);
    cuenta     number(9);
    auxTmod    number(4);
    xcodOpini  number(10);
    fechAntOut date;
    TipFlujCN  varchar2(1);
    Indicflujo varchar2(3);
  
  BEGIN
    --vig reciente  
    BEGIN
      SELECT MAX(AQPC156CODOPI)
        INTO xcodOpini
        FROM AQPC156
       WHERE AQPC156INSTAN = instancia
         AND AQPC156ESTAD = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        xcodOpini := 0;
    END;
  
    BEGIN
      SELECT SNG021TMOD
        INTO auxTmod
        FROM sng021
       WHERE SNG021SOL = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        auxTmod := 0;
    END;
  
    --IF xcodOpini > 0 THEN
    IF auxTmod = 13 THEN
      -- CRED vigentes
      BEGIN
        SELECT SUM(JAQY142CAPCUO)
          INTO xSumcuotaVigRec
          FROM JAQY142 J
         WHERE J.JAQY142INST = instancia
           AND J.JAQY142EST = 'H'
           AND J.JAQY142INDIC IN ('CredVigent', 'CredVencid', 'LineaVencd')
           and (j.jaqy142mod not in
               (select tp1nro1
                   from fst198 a
                  where a.tp1cod = 1
                    and a.tp1cod1 = 10899
                    and a.tp1corr1 = 13
                    and a.tp1corr2 = 1) and j.jaqy142mod not in 117) --mpostigoc 30.10.2023
           and j.jaqy142nrcuo > 1
           AND J.JAQY142TAREA = 7; --13/09/2023
      EXCEPTION
        WHEN OTHERS THEN
          xSumcuotaVigRec := 0;
      END;
      -- contingente Y -- potencial
      BEGIN
        SELECT JAQY140CCONTG, JAQY140CPOTEN
          INTO xCredicContingAct, xCredPotencAct
          FROM JAQY140
         WHERE JAQY140INST = instancia
           AND JAQY140EST = 'H'
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          xCredicContingAct := 0;
          xCredPotencAct    := 0;
      END;
    
    ELSE
      IF auxTmod = 14 THEN
        -- vigente
        BEGIN
          SELECT SUM(JAQZ822CAPCUO)
            INTO xSumcuotaVigRec
            FROM JAQZ822 J
           WHERE J.JAQZ822INST = instancia
             AND J.JAQZ822EST = 'H'
             AND J.JAQZ822INDIC IN
                 ('CredVigent', 'CredVencid', 'LineaVencd')
             and (j.jaqz822mod not in
                 (select tp1nro1
                     from fst198 a
                    where a.tp1cod = 1
                      and a.tp1cod1 = 10899
                      and a.tp1corr1 = 200
                      and a.tp1corr2 = 1
                      and a.tp1corr3 > 0) and j.jaqz822mod not in 117) --mpostigoc 051118 
             and j.jaqz822nrcuo > 1
             AND J.JAQZ822TAREA = 7;
        EXCEPTION
          WHEN OTHERS THEN
            xSumcuotaVigRec := 0;
        END;
        -- contingente Y -- potencial
        BEGIN
          SELECT JAQZ821CCONTG, JAQZ821CPOTEN
            INTO xCredicContingAct, xCredPotencAct
            FROM JAQZ821
           WHERE JAQZ821INST = instancia
             AND JAQZ821EST = 'H'
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            xCredicContingAct := 0;
            xCredPotencAct    := 0;
        END;
      END IF;
    END IF;
    /*BEGIN
      SELECT SUM(AQPC160CUOTG)
        INTO xSumcuotaVigRec
        FROM AQPC160
       WHERE AQPC160CODOPI = xcodOpini
         and (AQPC160TIPSOL = '' OR AQPC160TIPSOL IS NULL); -- 12062023
    EXCEPTION
      WHEN OTHERS THEN
        xSumcuotaVigRec := 0;
    END; */
    --END IF;
  
    IF xSumcuotaVigRec is null then
      xSumcuotaVigRec := 0;
    end IF;
  
    --vig anterior
    /*BEGIN
      SELECT SNG001PAIS, SNG001TDOC, SNG001NDOC
        INTO auxPais, auxPetdoc, auxPendoc
        FROM SNG001
       WHERE SNG001INST = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        auxPais   := 0;
        auxPetdoc := 0;
        auxPendoc := '';
        cuenta    := 0;
    END;
    
    --auxPendoc := TRIM(auxPendoc); 
    
    BEGIN
      SELECT max(SNG021SOL)
        INTO auxInstnc
        FROM sng021 g021, xwf070 f
       where SNG021PDOC = auxPais
         and SNG021TDOC = auxPetdoc
         and rpad(SNG021NDOC, 12, ' ') = rpad(auxPendoc, 12, ' ')
         and SNG021TMOD = auxTmod
         and SNG021SOL < instancia
         and g021.sng021sol = f.xwfprcin
         and f.xwfcont = 'S'
       group by SNG021TMOD;
    EXCEPTION
      WHEN OTHERS THEN
        auxInstnc := 0;
    END;*/
  
    Indicflujo := 'NOR';
    TipFlujCN  := 'N';
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_obtner_Instanci_anterior(instancia,
                                                             Indicflujo,
                                                             auxInstnc,
                                                             fechAntOut,
                                                             TipFlujCN);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    auxInstnc := nvl(auxInstnc, 0);
  
    IF auxInstnc > 0 THEN
      IF TipFlujCN = 'N' THEN
        BEGIN
          pq_cr_repo_opinion_riesgos.sp_obtn_cuot_cred_vigen_Anter(auxInstnc, --30042024
                                                                   auxTmod,
                                                                   xSumcuotaVigAnter,
                                                                   xCredicContingAnt,
                                                                   xCredPotencAnt);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
      END IF;
    
      IF TipFlujCN = 'C' THEN
        BEGIN
          pq_cr_repo_opini_riesgos_CRM.sp_obtn_cuot_cred_vigen_Anter(auxInstnc, --30042024
                                                                     auxTmod,
                                                                     xSumcuotaVigAnter,
                                                                     xCredicContingAnt,
                                                                     xCredPotencAnt);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
    END IF;
  END;

  procedure sp_obtn_cuot_cred_vigen_Anter(auxInstnc         number, --30042024
                                          auxTmod           number,
                                          xSumcuotaVigAnter OUT number,
                                          xCredicContingAnt out number, --                                     
                                          xCredPotencAnt    OUT number) IS
  BEGIN
    IF auxTmod = 13 THEN
      -- VIGENTE
      BEGIN
        SELECT SUM(JAQY142CAPCUO)
          INTO xSumcuotaVigAnter
          FROM JAQY142 J
         WHERE J.JAQY142INST = auxInstnc
           AND J.JAQY142EST = 'H'
           AND J.JAQY142INDIC IN ('CredVigent', 'CredVencid', 'LineaVencd')
           and (j.jaqy142mod not in
               (select tp1nro1
                   from fst198 a
                  where a.tp1cod = 1
                    and a.tp1cod1 = 10899
                    and a.tp1corr1 = 13
                    and a.tp1corr2 = 1) and j.jaqy142mod not in 117) --mpostigoc 30.10.2023
           and j.jaqy142nrcuo > 1
           AND J.JAQY142TAREA = 55; --13092023;
      EXCEPTION
        WHEN OTHERS THEN
          xSumcuotaVigAnter := 0;
      END;
      -- contingente Y -- potencial
      BEGIN
        SELECT JAQY140CCONTG, JAQY140CPOTEN
          INTO xCredicContingAnt, xCredPotencAnt
          FROM JAQY140
         WHERE JAQY140INST = auxInstnc
           AND JAQY140EST = 'H'
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          xCredicContingAnt := 0;
          xCredPotencAnt    := 0;
      END;
    ELSE
      IF auxTmod = 14 THEN
        --vigentes
        BEGIN
          SELECT SUM(JAQZ822CAPCUO)
            INTO xSumcuotaVigAnter
            FROM JAQZ822 J
           WHERE J.JAQZ822INST = auxInstnc
             AND J.JAQZ822EST = 'H'
             AND J.JAQZ822INDIC IN
                 ('CredVigent', 'CredVencid', 'LineaVencd')
             and (j.jaqz822mod not in
                 (select tp1nro1
                     from fst198 a
                    where a.tp1cod = 1
                      and a.tp1cod1 = 10899
                      and a.tp1corr1 = 200
                      and a.tp1corr2 = 1
                      and a.tp1corr3 > 0) and j.jaqz822mod not in 117) --mpostigoc 051118 
             and j.jaqz822nrcuo > 1
             AND J.JAQZ822TAREA = 55; --13092023
        EXCEPTION
          WHEN OTHERS THEN
            xSumcuotaVigAnter := 0;
        END;
        -- contingente Y -- potencial
        BEGIN
          SELECT JAQZ821CCONTG, JAQZ821CPOTEN
            INTO xCredicContingAnt, xCredPotencAnt
            FROM JAQZ821
           WHERE JAQZ821INST = auxInstnc
             AND JAQZ821EST = 'H'
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            xCredicContingAnt := 0;
            xCredPotencAnt    := 0;
        END;
      END IF;
    END IF;
  
  END;

  PROCEDURE sp_cargar_entidad_gast_finan(codOpinion number,
                                         instancia  number) is
    CURSOR deta_entidad(auxInst number) IS
      SELECT *
        FROM JAQZ862
       WHERE JAQZ862INST = auxInst
         AND JAQZ862ESTA = 'S';
  
    contador        number(10) := 1;
    descMoned       varchar2(10);
    instancAnterior number(10) := 0;
    flgInser        varchar2(1) := 0;
    auxMntGFinanc   number(17, 2) := 0;
    v_FechaActual   date;
    v_HoraActual    varchar2(8);
    tipoCambio      number(14, 8);
    Fechaf017       date;
    fechAntOut      date;
    TipFlujCN       varchar2(1);
    Indicflujo      varchar2(3);
  BEGIN
    BEGIN
      DELETE FROM AQPC812 WHERE AQPC812CODOPI = codOpinion;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    v_FechaActual := TO_DATE(SYSDATE, 'dd/mm/rrrr');
    v_HoraActual  := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  
    FOR i in deta_entidad(instancia) LOOP
    
      auxMntGFinanc := i.JAQZ862GFIN; --03082023
      descMoned     := 'S/.';
    
      IF TRIM(i.jaqz862tcre) IN
         ('Pymes US$', 'Consumo US$', 'Hipotecario US$') THEN
        -- = 101 THEN
        tipoCambio := 0;
        BEGIN
          SELECT SNG120TCBI
            INTO TIPOCAMBIO
            FROM SNG120
           WHERE SNG120INS = instancia
             AND SNG120TSK = 'EVALUACION'
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            tipoCambio := 0;
        END;
      
        IF tipoCambio is null or tipoCambio = 0 THEN
          BEGIN
            SELECT E.PGFAPE INTO Fechaf017 FROM FST017 E WHERE E.PGCOD = 1;
          EXCEPTION
            WHEN OTHERS THEN
              Fechaf017 := TO_DATE(SYSDATE, 'dd/mm/rrrr');
          END;
          TIPOCAMBIO := fn_tipo_cambio_fijo(Fechaf017);
        END IF;
      
        auxMntGFinanc := auxMntGFinanc * TIPOCAMBIO; --fn_tipo_cambio_fijo(i.JAQZ862FECH); -- 03082023    
      END IF;
    
      flgInser := 'N';
      BEGIN
        SELECT 'S'
          INTO flgInser
          FROM AQPC812
         WHERE AQPC812CODOPI = codOpinion
           AND TRIM(UPPER(AQPC812DESENT)) = TRIM(UPPER(i.jaqz862enti))
           AND TRIM(UPPER(AQPC812TCRE)) = TRIM(UPPER(i.JAQZ862TCRE)); --03082023
        --AND TRIM(UPPER(AQPC812CODENT)) = TRIM(UPPER(i.JAQZ862CENT)); --03082023
      EXCEPTION
        WHEN OTHERS THEN
          flgInser := 'N';
      END;
    
      IF flgInser = 'N' THEN
        BEGIN
          INSERT INTO AQPC812
            (AQPC812CODOPI,
             AQPC812CODENT,
             AQPC812CORREL,
             AQPC812DESENT,
             AQPC812CODMDA,
             AQPC812MONEDA,
             AQPC812EVAREC,
             AQPC812EVAANT,
             AQPC812FECHREG, --03082023
             AQPC812HORAREG,
             AQPC812TCRE) --03082023
          VALUES
            (codOpinion,
             TRIM(i.JAQZ862CENT),
             contador,
             TRIM(i.jaqz862enti),
             0, --i.JAQZ862MDA,
             descMoned,
             auxMntGFinanc,
             0,
             v_FechaActual, --03082023
             v_HoraActual,
             i.jaqz862tcre);
          COMMIT;
          contador := contador + 1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      ELSE
        IF flgInser = 'S' THEN
          BEGIN
            UPDATE AQPC812
               SET AQPC812EVAREC = AQPC812EVAREC + auxMntGFinanc --03082023
             WHERE AQPC812CODOPI = codOpinion
               AND TRIM(UPPER(AQPC812DESENT)) = TRIM(UPPER(i.jaqz862enti))
               AND TRIM(UPPER(AQPC812TCRE)) = TRIM(UPPER(i.JAQZ862TCRE)); --03082023
            --AND TRIM(UPPER(AQPC812CODENT)) = TRIM(UPPER(i.JAQZ862CENT)); --03082023;
            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
      END IF;
    
    END LOOP;
  
    Indicflujo := 'NOR';
    TipFlujCN  := 'N';
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_obtner_Instanci_anterior(instancia,
                                                             Indicflujo,
                                                             instancAnterior,
                                                             fechAntOut,
                                                             TipFlujCN);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    ---Eval Anterior
    IF TipFlujCN = 'N' THEN
      BEGIN
        pq_cr_repo_opinion_riesgos.sp_carg_ent_gst_fin_anter(codOpinion, --30042024
                                                             Indicflujo,
                                                             instancAnterior);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    ELSE
      IF TipFlujCN = 'C' THEN
        BEGIN
          pq_cr_repo_opini_riesgos_CRM.sp_carg_ent_gst_fin_anter(codOpinion, --30042024
                                                                 Indicflujo,
                                                                 instancAnterior);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
    END IF;
  
  END;

  procedure sp_carg_ent_gst_fin_anter(codOpinion   number, --30042024
                                      flujo        varchar2,
                                      instanciaAnt number) is
    CURSOR deta_entidad(auxInst number) IS
      SELECT *
        FROM JAQZ862
       WHERE JAQZ862INST = auxInst
         AND JAQZ862ESTA = 'S';
  
    contador      number(10) := 1;
    descMoned     varchar2(10);
    flgInser      varchar2(1) := 0;
    auxMntGFinanc number(17, 2) := 0;
    v_FechaActual date;
    v_HoraActual  varchar2(8);
    tipoCambio    number(14, 8);
    Fechaf017     date;
  begin
    v_FechaActual := TO_DATE(SYSDATE, 'dd/mm/rrrr');
    v_HoraActual  := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  
    BEGIN
      SELECT MAX(AQPC812CORREL)
        INTO contador
        FROM AQPC812
       WHERE AQPC812CODOPI = codOpinion;
    EXCEPTION
      WHEN OTHERS THEN
        contador := 0;
    END;
  
    IF contador IS NULL THEN
      contador := 0;
    END IF;
  
    contador := contador + 1;
  
    FOR i in deta_entidad(instanciaAnt) LOOP
    
      auxMntGFinanc := 0; --03082023  
      descMoned     := 'S/.';
      auxMntGFinanc := i.JAQZ862GFIN; --03082023  
    
      /*IF TRIM(i.jaqz862tcre) IN ('Pymes US$', 'Consumo US$', 'Hipotecario US$') THEN--IF i.JAQZ862MDA = 101 THEN
        auxMntGFinanc := auxMntGFinanc * fn_tipo_cambio_fijo(i.JAQZ862FECH); -- 03082023    
      END IF;*/
      IF TRIM(i.jaqz862tcre) IN
         ('Pymes US$', 'Consumo US$', 'Hipotecario US$') THEN
        -- = 101 THEN 03082023
        tipoCambio := 0;
        BEGIN
          SELECT SNG120TCBI
            INTO TIPOCAMBIO
            FROM SNG120
           WHERE SNG120INS = instanciaAnt
             AND SNG120TSK = 'EVALUACION'
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            tipoCambio := 0;
        END;
      
        IF tipoCambio is null or tipoCambio = 0 THEN
          BEGIN
            SELECT E.PGFAPE INTO Fechaf017 FROM FST017 E WHERE E.PGCOD = 1;
          EXCEPTION
            WHEN OTHERS THEN
              Fechaf017 := TO_DATE(SYSDATE, 'dd/mm/rrrr');
          END;
          TIPOCAMBIO := fn_tipo_cambio_fijo(Fechaf017);
        END IF;
      
        auxMntGFinanc := auxMntGFinanc * TIPOCAMBIO; --fn_tipo_cambio_fijo(i.JAQZ862FECH); -- 03082023    
      END IF;
    
      IF flujo = 'NOR' THEN
        --30042024        
        flgInser := 'N';
        BEGIN
          SELECT 'S'
            INTO flgInser
            FROM AQPC812
           WHERE AQPC812CODOPI = codOpinion
             AND TRIM(UPPER(AQPC812DESENT)) = TRIM(UPPER(i.jaqz862enti))
             AND TRIM(UPPER(AQPC812TCRE)) = TRIM(UPPER(i.JAQZ862TCRE)); --03082023
          --AND TRIM(UPPER(AQPC812CODENT)) = TRIM(UPPER(i.JAQZ862CENT)); --03082023             
        EXCEPTION
          WHEN OTHERS THEN
            flgInser := 'N';
        END;
      
        IF flgInser = 'N' THEN
          BEGIN
            INSERT INTO AQPC812
              (AQPC812CODOPI,
               AQPC812CODENT,
               AQPC812CORREL,
               AQPC812DESENT,
               AQPC812CODMDA,
               AQPC812MONEDA,
               AQPC812EVAREC,
               AQPC812EVAANT,
               AQPC812FECHREG, --03082023
               AQPC812HORAREG,
               AQPC812TCRE) --03082023                              
            VALUES
              (codOpinion,
               TRIM(i.JAQZ862CENT),
               contador,
               TRIM(i.jaqz862enti),
               0, --i.JAQZ862MDA,
               descMoned,
               0,
               auxMntGFinanc,
               v_FechaActual, --03082023
               v_HoraActual,
               i.jaqz862tcre);
            COMMIT;
            contador := contador + 1;
          EXCEPTION
            WHEN others then
              NULL;
          END;
        ELSE
          IF flgInser = 'S' THEN
            BEGIN
              UPDATE AQPC812
                 SET AQPC812EVAANT = AQPC812EVAANT + auxMntGFinanc --i.JAQZ862GFIN  03082023
               WHERE AQPC812CODOPI = codOpinion
                 AND TRIM(UPPER(AQPC812DESENT)) =
                     TRIM(UPPER(i.jaqz862enti))
                 AND TRIM(UPPER(AQPC812TCRE)) = TRIM(UPPER(i.JAQZ862TCRE));
              --AND AQPC812CODENT = i.JAQZ862CENT;
              commit;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
          END IF;
        END IF;
      ELSE
        -- SI ES eval anter CRM
        IF flujo = 'CRM' THEN
          --30042024 
          flgInser := 'N';
          BEGIN
            SELECT 'S'
              INTO flgInser
              FROM AQPC829
             WHERE AQPC829CODOPI = codOpinion
               AND TRIM(UPPER(AQPC829DESENT)) = TRIM(UPPER(i.jaqz862enti)) -- TRIM(UPPER(i.aqpb357enti))
               AND TRIM(UPPER(AQPC829TCRE)) = TRIM(UPPER(i.JAQZ862TCRE)); --TRIM(UPPER(i.aqpb357TCRE)); --03082023
            --AND TRIM(UPPER(AQPC829CODENT)) = TRIM(UPPER(i.aqpb357CENT)); --03082023             
          EXCEPTION
            WHEN OTHERS THEN
              flgInser := 'N';
          END;
        
          IF flgInser = 'N' THEN
            BEGIN
              INSERT INTO AQPC829
                (AQPC829CODOPI,
                 AQPC829CODENT,
                 AQPC829CORREL,
                 AQPC829DESENT,
                 AQPC829CODMDA,
                 AQPC829MONEDA,
                 AQPC829EVAREC,
                 AQPC829EVAANT,
                 AQPC829FECHREG,
                 AQPC829HORAREG,
                 AQPC829TCRE)
              VALUES
                (codOpinion,
                 TRIM(i.jaqz862cent), -- aqpb357CENT),
                 contador,
                 TRIM(i.jaqz862enti), --aqpb357enti),
                 0, --i.aqpb357MDA,
                 descMoned,
                 0,
                 auxMntGFinanc,
                 v_FechaActual,
                 v_HoraActual,
                 i.jaqz862tcre); --aqpb357tcre);
              COMMIT;
              contador := contador + 1;
            EXCEPTION
              WHEN others then
                NULL;
            END;
          ELSE
            IF flgInser = 'S' THEN
              BEGIN
                UPDATE AQPC829
                   SET AQPC829EVAANT = AQPC829EVAANT + auxMntGFinanc --i.aqpb357GFIN  03082023
                 WHERE AQPC829CODOPI = codOpinion
                   AND TRIM(UPPER(AQPC829DESENT)) =
                       TRIM(UPPER(i.jaqz862enti)) --aqpb357enti))
                   AND TRIM(UPPER(AQPC829TCRE)) =
                       TRIM(UPPER(i.jaqz862tcre)); --i.aqpb357TCRE));                        
                commit;
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
            END IF;
          END IF;
        END IF;
      END IF;
    END LOOP;
  end;

  Procedure sp_obtner_Instanci_anterior(instancia  number,
                                        Indicflujo varchar2,
                                        auxInstnc  out number,
                                        fechAntOut out date,
                                        TipFlujCN  out varchar2) is
    --C:crm o N: Normal
    auxPais        number(3);
    auxPetdoc      number(3);
    auxPendoc      varchar2(12);
    cuenta         number(9);
    auxTmod        number(4);
    FECHAACT       DATE;
    flgExisteM400  VARCHAR2(1);
    auxInstncNorm  number(10);
    auxInstncCRM   number(10);
    FechInsAntNorm DATE;
    FechInsAntCrm  Date;
  BEGIN
    BEGIN
      SELECT PGFAPE INTO FECHAACT FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT SNG001PAIS, SNG001TDOC, SNG001NDOC
        INTO auxPais, auxPetdoc, auxPendoc
        FROM SNG001
       WHERE SNG001INST = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        auxPais   := 0;
        auxPetdoc := 0;
        auxPendoc := '';
    END;
  
    auxPendoc := rpad(auxPendoc, 12, ' '); --12042024
    auxTmod   := 0;
  
    --Identificar el tipo 
    IF Indicflujo = 'NOR' THEN
      BEGIN
        SELECT SNG021TMOD
          INTO auxTmod
          FROM sng021
         WHERE SNG021SOL = instancia;
      EXCEPTION
        WHEN OTHERS THEN
          auxTmod := 0;
      END;
    ELSE
      IF Indicflujo = 'CRM' THEN
        BEGIN
          SELECT 'S'
            into flgExisteM400
            FROM JAQM400 W
           WHERE W.JAQM400INS = instancia
             AND W.JAQM400FEC = FECHAACT
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        flgExisteM400 := nvl(flgExisteM400, 'N');
        IF flgExisteM400 = 'S' THEN
          auxTmod := 14;
        ELSE
          BEGIN
            SELECT jaqz516TMOD
              INTO auxTmod
              FROM jaqz516
             WHERE jaqz516SOL = instancia
               and JAQZ516FEC = FECHAACT;
          EXCEPTION
            WHEN OTHERS THEN
              auxTmod := 0;
          END;
        END IF;
      END IF;
    END IF;
  
    --buscar la instanc anterior con el mismo tipo
  
    BEGIN
      SELECT max(SNG021SOL)
        INTO auxInstncNorm
        FROM sng021 g021, xwf070 f
       where SNG021PDOC = auxPais
         and SNG021TDOC = auxPetdoc
         and SNG021NDOC = auxPendoc --12042024
         and SNG021TMOD = auxTmod
         and SNG021SOL < instancia
         and g021.sng021sol = f.xwfprcin
         and f.xwfcont = 'S'
       group by SNG021TMOD;
    EXCEPTION
      WHEN OTHERS THEN
        auxInstncNorm := 0;
    END;
  
    BEGIN
      SELECT SNG021FEC
        INTO FechInsAntNorm
        FROM sng021 g021
       where SNG021PDOC = auxPais
         and SNG021TDOC = auxPetdoc
         and SNG021NDOC = auxPendoc --12042024
         and SNG021TMOD = auxTmod
         and SNG021SOL = auxInstncNorm
         and rownum = 1;
    EXCEPTION
      WHEN OTHERS THEN
        auxInstncNorm := 0;
    END;
  
    auxInstncNorm := NVL(auxInstncNorm, 0);
  
    --validamos la inst anterior en crm
    auxInstncCRM := 0;
    IF auxTmod = 14 THEN
      BEGIN
        select distinct b.jaqm400ins, max(b.jaqm400fec)
          INTO auxInstncCRM, FechInsAntCrm
          from jaqa400 a, jaqm400 b
         where a.jaqa400ai1 in
               (select s.sng001inst
                  from sng001 s
                 where s.sng001pais = auxPais
                   and s.sng001tdoc = auxPetdoc
                   and s.sng001ndoc = auxPendoc)
           and a.jaqa400est = 'C'
           and a.jaqa400ai1 = b.jaqm400ins
           and a.jaqa400fec = b.jaqm400fec
         group by b.jaqm400ins;
      EXCEPTION
        WHEN OTHERS THEN
          auxInstncCRM := 0;
      END;
    ELSE
      IF auxTmod = 13 THEN
        BEGIN
          SELECT max(jaqz516SOL)
            INTO auxInstncCRM
            FROM jaqz516 g021, xwf070 f
           where jaqz516PDOC = auxPais
             and jaqz516TDOC = auxPetdoc
             and jaqz516NDOC = auxPendoc
             and jaqz516TMOD = auxTmod
             and jaqz516SOL < instancia
             and g021.jaqz516sol = f.xwfprcin
             and f.xwfcont = 'S'
           group by jaqz516TMOD;
        EXCEPTION
          WHEN OTHERS THEN
            auxInstncCRM := 0;
        END;
      
        auxInstncCRM := NVL(auxInstncCRM, 0);
      
        IF auxInstncCRM > 0 THEN
          BEGIN
            SELECT JAQZ516FEC
              INTO FechInsAntCrm
              FROM jaqz516 g021, xwf070 f
             where jaqz516PDOC = auxPais
               and jaqz516TDOC = auxPetdoc
               and jaqz516NDOC = auxPendoc
               and jaqz516TMOD = auxTmod
               and jaqz516SOL = auxInstncCRM
               and g021.jaqz516sol = f.xwfprcin
               and f.xwfcont = 'S'
               and rownum = 1;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
      END IF;
    END IF;
    auxInstncCRM := NVL(auxInstncCRM, 0);
  
    --elegir con la mayor fecha 
    IF auxInstncNorm > auxInstncCRM THEN
      IF FechInsAntNorm < FechInsAntCrm THEN
        auxInstnc  := auxInstncCRM;
        fechAntOut := FechInsAntCrm;
        TipFlujCN  := 'C';
      ELSE
        auxInstnc  := auxInstncNorm;
        fechAntOut := FechInsAntNorm;
        TipFlujCN  := 'N';
      END IF;
    ELSE
      IF auxInstncNorm <= auxInstncCRM THEN
        IF FechInsAntNorm = FechInsAntCrm THEN
          IF Indicflujo = 'CRM' THEN
            auxInstnc  := auxInstncCRM;
            fechAntOut := FechInsAntCrm;
            TipFlujCN  := 'C';
          END IF;
          IF Indicflujo = 'NOR' THEN
            auxInstnc  := auxInstncNorm;
            fechAntOut := FechInsAntNorm;
            TipFlujCN  := 'N';
          END IF;
        END IF;
      
        IF FechInsAntNorm > FechInsAntCrm THEN
          auxInstnc  := auxInstncNorm;
          fechAntOut := FechInsAntNorm;
          TipFlujCN  := 'N';
        END IF;
      
        IF FechInsAntNorm < FechInsAntCrm THEN
          auxInstnc  := auxInstncCRM;
          fechAntOut := FechInsAntCrm;
          TipFlujCN  := 'C';
        END IF;
      END IF;
    END IF;
  
  END;

  procedure sp_desc_tipo_solicitud(CodTipoSolicitud  number,
                                   DescTipoSolicitud OUT varchar2) is
  begin
    Case
      WHEN CodTipoSolicitud = 0 THEN
        DescTipoSolicitud := 'NORMAL';
      WHEN CodTipoSolicitud = 1 THEN
        DescTipoSolicitud := 'CARTA FIANZA';
      WHEN CodTipoSolicitud = 2 THEN
        DescTipoSolicitud := 'NO HABILITADO';
      WHEN CodTipoSolicitud = 3 THEN
        DescTipoSolicitud := 'REFINANCIACIÓN';
      WHEN CodTipoSolicitud = 4 THEN
        DescTipoSolicitud := 'AMPLIACIÓN';
      WHEN CodTipoSolicitud = 7 THEN
        DescTipoSolicitud := 'DESEMBOLSOS PARCIALES';
      WHEN CodTipoSolicitud = 10 THEN
        DescTipoSolicitud := 'CONVENIOS';
      WHEN CodTipoSolicitud = 11 THEN
        DescTipoSolicitud := 'LINEA CREDITO';
      WHEN CodTipoSolicitud = 12 THEN
        DescTipoSolicitud := 'AMPLIACIÓN LINEAS CREDITO';
      WHEN CodTipoSolicitud = 13 THEN
        DescTipoSolicitud := 'REPROGRAMACIÓN CAMBIO FECHA';
      WHEN CodTipoSolicitud = 14 THEN
        DescTipoSolicitud := 'REPROGRAMAACIÓN DESASTRE NATURAL';
      WHEN CodTipoSolicitud = 15 THEN
        DescTipoSolicitud := 'AMPLIACIÓN ESPECIAL';
      WHEN CodTipoSolicitud = 16 THEN
        DescTipoSolicitud := 'REPROGRAMACIÓN CAMPAÑA';
      ELSE
        DescTipoSolicitud := '';
    End Case;
  end;

  procedure sp_obtener_datos_cabecera(xSucursal     number,
                                      cuenta        number,
                                      nomSucursCred out varchar2,
                                      nombreClient  out varchar2) IS
  
    xPepais number(3);
    xPetdoc number(3);
    xPendoc varchar2(12);
  BEGIN
    --SUCURSAL 
    BEGIN
      SELECT Scnom
        INTO nomSucursCred
        FROM FST001
       WHERE Pgcod = 1
         AND Sucurs = xSucursal
         AND ROWNUM < 2;
    EXCEPTION
      WHEN OTHERS THEN
        nomSucursCred := '';
    END;
    --Nombre Clientes
    BEGIN
      SELECT Pepais, Petdoc, Pendoc
        INTO xPepais, xPetdoc, xPendoc
        FROM FSR008
       WHERE Pgcod = 1
         AND Ctnro = cuenta
         AND Cttfir = 'T'
         and rownum < 2;
    EXCEPTION
      WHEN OTHERS THEN
        xPepais := '';
        xPetdoc := '';
        xPendoc := '';
    END;
  
    xPendoc := rpad(xPendoc, 12, ' '); --26032024
  
    BEGIN
      SELECT Penom
        into nombreClient
        FROM FSD001
       WHERE Pepais = xPepais
         AND Petdoc = xPetdoc
         AND Pendoc = xPendoc --09/07/2024
         and rownum < 2;
    EXCEPTION
      WHEN OTHERS THEN
        nombreClient := '';
    END;
  END;

  procedure sp_validar_modelo_Evaluacion(instancia     number,
                                         flgModelEval  out varchar2,
                                         txtTipoEvalu  out varchar2,
                                         flgEsEvalFluj out varchar2) is
    --30062023
    ModelEval    number(4);
    ln_evalflujo varchar2(1);
    val_tp1nro2  number(4);
  BEGIN
    BEGIN
      SELECT SNG021TMod
        INTO ModelEval
        FROM SNG021
       WHERE SNG021Sol = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        ModelEval := 0;
    END;
  
    val_tp1nro2 := 0;
  
    IF ModelEval = 14 THEN
      flgModelEval := 'C';
    
      flgEsEvalFluj := '';
    ELSE
      IF ModelEval = 13 THEN
        flgModelEval := 'P';
      
        BEGIN
          -- validar si tiene evaluación por flujo 
          pq_cr_ratio_evalflujo.sp_cr_verfevalflujo(instancia,
                                                    flgEsEvalFluj);
        EXCEPTION
          WHEN OTHERS THEN
            flgEsEvalFluj := 'N';
        END;
      
        IF flgEsEvalFluj = 'S' THEN
          val_tp1nro2 := 2;
        ELSE
          val_tp1nro2 := 1;
        END IF;
      END IF;
    END IF;
  
    --Descripción de tipo de evaluación  30062023   
    txtTipoEvalu := '';
    BEGIN
      select TP1DESC
        into txtTipoEvalu
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11152
         and tp1corr1 = 8
         and tp1corr2 = 3
         and tp1corr3 > 0
         and tp1nro1 = ModelEval
         and TP1NRO2 = val_tp1nro2
         and rownum < 2;
    EXCEPTION
      WHEN OTHERS THEN
        txtTipoEvalu := '';
    END;
  END;

  procedure sp_insert_aqpc811(p_AQPC811CODOPI   number,
                              p_AQPC811FecEvRec date,
                              p_AQPC811FecEvAnt date,
                              
                              p_AQPC811AICMDA1 varchar2,
                              p_AQPC811AIERBRT number,
                              p_AQPC811AIEABRT number,
                              p_AQPC811AIAHBRT number,
                              
                              p_AQPC811AICMDA2 varchar2,
                              p_AQPC811AIERBRY number,
                              p_AQPC811AIEABRY number,
                              p_AQPC811AIAHBRY number,
                              
                              p_AQPC811AICMDA3 varchar2,
                              p_AQPC811AIERBRC number,
                              p_AQPC811AIEABRC number,
                              p_AQPC811AIAHBRC number,
                              
                              p_AQPC811AICMDA4 varchar2,
                              p_AQPC811AIERBRO number,
                              p_AQPC811AIEABRO number,
                              p_AQPC811AIAHBRO number,
                              
                              p_AQPC811AIcMd24 varchar2,
                              p_AQPC811AIerBOT number,
                              p_AQPC811AIeaBOT number,
                              p_AQPC811AIahBOT number,
                              
                              p_AQPC811AICMDA5 varchar2,
                              p_AQPC811AIERBTO number,
                              p_AQPC811AIEABTO number,
                              p_AQPC811AIAHBTO number,
                              
                              p_AQPC811AICMDA6 varchar2,
                              p_AQPC811AIERNTT number,
                              p_AQPC811AIEANTT number,
                              p_AQPC811AIAHNTT number,
                              
                              p_AQPC811AICMDA7 varchar2,
                              p_AQPC811AIERNTY number,
                              p_AQPC811AIEANTY number,
                              p_AQPC811AIAHNTY number,
                              
                              p_AQPC811AICMDA8 varchar2,
                              p_AQPC811AIERNTC number,
                              p_AQPC811AIEANTC number,
                              p_AQPC811AIAHNTC number,
                              
                              p_AQPC811AICMDA9 varchar2,
                              p_AQPC811AIERNTO number,
                              p_AQPC811AIEANTO number,
                              p_AQPC811AIAHNTO number,
                              
                              p_AQPC811AEcMd25 varchar2,
                              p_AQPC811AEerNOT NUMBER,
                              p_AQPC811AEeaNOT NUMBER,
                              p_AQPC811AEahNOT NUMBER,
                              
                              p_AQPC811AICMD10 varchar2,
                              p_AQPC811AIERNTL number,
                              p_AQPC811AIEANTL number,
                              p_AQPC811AIAHNTL number,
                              
                              p_AQPC811AECMD11 varchar2,
                              p_AQPC811AEERALI number,
                              p_AQPC811AEEAALI number,
                              p_AQPC811AEAHALI number,
                              
                              p_AQPC811AECMD12 varchar2,
                              p_AQPC811AEERALQ number,
                              p_AQPC811AEEAALQ number,
                              p_AQPC811AEAHALQ number,
                              
                              p_AQPC811AECMD13 varchar2,
                              p_AQPC811AEERTRP number,
                              p_AQPC811AEEATRP number,
                              p_AQPC811AEAHTRP number,
                              
                              p_AQPC811AECMD14 varchar2,
                              p_AQPC811AEEREDU number,
                              p_AQPC811AEEAEDU number,
                              p_AQPC811AEAHEDU number,
                              
                              p_AQPC811AECMD15 varchar2,
                              p_AQPC811AEERSER number,
                              p_AQPC811AEEASER number,
                              p_AQPC811AEAHSER number,
                              
                              p_AQPC811AECMD16 varchar2,
                              p_AQPC811AEERFAM number,
                              p_AQPC811AEEAFAM number,
                              p_AQPC811AEAHFAM number,
                              
                              p_AQPC811AECMD17 varchar2,
                              p_AQPC811AEEROTR number,
                              p_AQPC811AEEAOTR number,
                              p_AQPC811AEAHOTR number,
                              
                              p_AQPC811AECMD18 varchar2,
                              p_AQPC811AEERGFT number,
                              p_AQPC811AEEAGFT number,
                              p_AQPC811AEAHGFT number,
                              
                              p_AQPC811AGCMD19 varchar2,
                              p_AQPC811AGERGFT number,
                              p_AQPC811AGEAGFT number,
                              p_AQPC811AGAHGFT number,
                              
                              p_AQPC811AECMD20 varchar2,
                              p_AQPC811AEERNTM number,
                              p_AQPC811AEEANTM number,
                              p_AQPC811AEAHNTM number,
                              
                              p_AQPC811AECMD21 varchar2,
                              p_AQPC811AEERCRP number,
                              p_AQPC811AEEACRP number,
                              
                              p_AQPC811AECMD22 varchar2,
                              p_AQPC811AEERCRV number,
                              p_AQPC811AEEACRV number,
                              
                              p_AQPC811AECMD23 varchar2,
                              p_AQPC811AEEREXF number,
                              p_AQPC811AEEAEXF number,
                              
                              p_AQPC811ARTIGN1 varchar2,
                              p_AQPC811ARTIGN2 varchar2,
                              p_AQPC811ARTEXN1 varchar2,
                              p_AQPC811ARTEXN2 varchar2,
                              
                              p_AQPC811AECMD24 VARCHAR2, --21082023
                              p_AQPC811AEERCOT NUMBER,
                              p_AQPC811AEEACOT NUMBER,
                              p_AQPC811AECMD26 VARCHAR2,
                              p_AQPC811AEERPOT NUMBER,
                              p_AQPC811AEEAPOT NUMBER) is
    flgOk         varchar2(1);
    v_FechaActual DATE;
    v_HoraActual  VARCHAR2(8);
    v_correlativo NUMBER(10);
    instancia     NUMBER(10);
    auxInstnc     NUMBER(10);
    fechAntOut    date;
    TipFlujCN     varchar2(1);
    Indicflujo    varchar2(3);
  Begin
    -- 2108
    BEGIN
      SELECT MAX(AQPC811CORR)
        INTO v_correlativo
        FROM AQPC811
       WHERE AQPC811CODOPI = p_AQPC811CODOPI;
    EXCEPTION
      WHEN OTHERS THEN
        v_correlativo := 0;
    END;
    IF v_correlativo IS NULL THEN
      v_correlativo := 0;
    END IF;
  
    v_correlativo := v_correlativo + 1;
  
    BEGIN
      UPDATE AQPC811
         SET AQPC811ESTAD = 'I'
       WHERE AQPC811CODOPI = p_AQPC811CODOPI
         AND (AQPC811ESTAD = 'H' OR AQPC811ESTAD IS NULL);
      --DELETE FROM AQPC811 where AQPC811CODOPI = p_AQPC811CODOPI;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    v_FechaActual := TO_DATE(SYSDATE, 'dd/mm/rrrr');
    v_HoraActual  := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  
    --instancia anterior
    BEGIN
      SELECT AQPC156INSTAN
        INTO instancia
        FROM AQPC156
       WHERE AQPC156CODOPI = p_AQPC811CODOPI
         AND AQPC156ESTAD = 'H'; -- AND AQPC156INSTAN = auxAQPC156INSTAN;
    EXCEPTION
      WHEN OTHERS THEN
        instancia := 0;
    END;
  
    auxInstnc  := 0;
    Indicflujo := 'NOR';
    TipFlujCN  := 'N';
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_obtner_Instanci_anterior(instancia  => instancia,
                                                             Indicflujo => Indicflujo,
                                                             auxInstnc  => auxInstnc,
                                                             fechAntOut => fechAntOut,
                                                             TipFlujCN  => TipFlujCN);
    EXCEPTION
      WHEN OTHERS THEN
        auxInstnc := 0;
    END;
  
    BEGIN
      INSERT INTO AQPC811
        (AQPC811CodOpi,
         AQPC811Afeere,
         AQPC811Afeean,
         AQPC811AIcMda1,
         AQPC811AIerBrT,
         AQPC811AIeaBrT,
         AQPC811AIahBrT,
         AQPC811AIcMda2,
         AQPC811AIerBrY,
         AQPC811AIeaBrY,
         AQPC811AIahBrY,
         AQPC811AIcMda3,
         AQPC811AIerBrC,
         AQPC811AIeaBrC,
         AQPC811AIahBrC,
         AQPC811AIcMda4,
         AQPC811AIerBrO,
         AQPC811AIeaBrO,
         AQPC811AIahBrO,
         AQPC811AIcMd24,
         AQPC811AIerBOT,
         AQPC811AIeaBOT,
         AQPC811AIahBOT,
         AQPC811AIcMda5,
         AQPC811AIerBTo,
         AQPC811AIeaBTo,
         AQPC811AIahBTo,
         AQPC811AIcMda6,
         AQPC811AIerNtT,
         AQPC811AIeaNtT,
         AQPC811AIahNtT,
         AQPC811AIcMda7,
         AQPC811AIerNtY,
         AQPC811AIeaNtY,
         AQPC811AIahNtY,
         AQPC811AIcMda8,
         AQPC811AIerNtC,
         AQPC811AIeaNtC,
         AQPC811AIahNtC,
         AQPC811AIcMda9,
         AQPC811AIerNtO,
         AQPC811AIeaNtO,
         AQPC811AIahNtO,
         AQPC811AEcMd25,
         AQPC811AEerNOT,
         AQPC811AEeaNOT,
         AQPC811AEahNOT,
         AQPC811AIcMd10,
         AQPC811AIerNTl,
         AQPC811AIeaNTl,
         AQPC811AIahNTl,
         AQPC811AEcMd11,
         AQPC811AEerAli,
         AQPC811AEeaAli,
         AQPC811AEahAli,
         AQPC811AEcMd12,
         AQPC811AEerAlq,
         AQPC811AEeaAlq,
         AQPC811AEahAlq,
         AQPC811AEcMd13,
         AQPC811AEerTrp,
         AQPC811AEeaTrp,
         AQPC811AEahTrp,
         AQPC811AEcMd14,
         AQPC811AEerEdu,
         AQPC811AEeaEdu,
         AQPC811AEahEdu,
         AQPC811AEcMd15,
         AQPC811AEerSer,
         AQPC811AEeaSer,
         AQPC811AEahSer,
         AQPC811AEcMd16,
         AQPC811AEerFam,
         AQPC811AEeaFam,
         AQPC811AEahFam,
         AQPC811AEcMd17,
         AQPC811AEerOtr,
         AQPC811AEeaOtr,
         AQPC811AEahOtr,
         AQPC811AEcMd18,
         AQPC811AEerGFt,
         AQPC811AEeaGFt,
         AQPC811AEahGFt,
         AQPC811AGcMd19,
         AQPC811AGerGFt,
         AQPC811AGeaGFt,
         AQPC811AGahGFt,
         AQPC811AEcMd20,
         AQPC811AEerNtM,
         AQPC811AEeaNtM,
         AQPC811AEahNtM,
         AQPC811AEcMd21,
         AQPC811AEerCrP,
         AQPC811AEeaCrP,
         AQPC811AEcMd22,
         AQPC811AEerCrV,
         AQPC811AEeaCrV,
         AQPC811AEcMd23,
         AQPC811AEerExF,
         AQPC811AEeaExF,
         aqpc811artign1,
         aqpc811artign2,
         aqpc811artexn1,
         aqpc811artexn2,
         AQPC811FECHREG, --0308
         AQPC811HORAREG,
         AQPC811AECMD24, --21082023
         AQPC811AEERCOT,
         AQPC811AEEACOT,
         AQPC811AECMD26,
         AQPC811AEERPOT,
         AQPC811AEEAPOT,
         AQPC811CORR, --2108               
         AQPC811ESTAD,
         AQPC811INSTANT)
      VALUES
        (p_AQPC811CODOPI,
         p_AQPC811FecEvRec,
         p_AQPC811FecEvAnt,
         p_AQPC811AICMDA1,
         p_AQPC811AIERBRT,
         p_AQPC811AIEABRT,
         p_AQPC811AIAHBRT,
         p_AQPC811AICMDA2,
         p_AQPC811AIERBRY,
         p_AQPC811AIEABRY,
         p_AQPC811AIAHBRY,
         p_AQPC811AICMDA3,
         p_AQPC811AIERBRC,
         p_AQPC811AIEABRC,
         p_AQPC811AIAHBRC,
         p_AQPC811AICMDA4,
         p_AQPC811AIERBRO,
         p_AQPC811AIEABRO,
         p_AQPC811AIAHBRO,
         p_AQPC811AIcMd24,
         p_AQPC811AIerBOT,
         p_AQPC811AIeaBOT,
         p_AQPC811AIahBOT,
         p_AQPC811AICMDA5,
         p_AQPC811AIERBTO,
         p_AQPC811AIEABTO,
         p_AQPC811AIAHBTO,
         p_AQPC811AICMDA6,
         p_AQPC811AIERNTT,
         p_AQPC811AIEANTT,
         p_AQPC811AIAHNTT,
         p_AQPC811AICMDA7,
         p_AQPC811AIERNTY,
         p_AQPC811AIEANTY,
         p_AQPC811AIAHNTY,
         p_AQPC811AICMDA8,
         p_AQPC811AIERNTC,
         p_AQPC811AIEANTC,
         p_AQPC811AIAHNTC,
         p_AQPC811AICMDA9,
         p_AQPC811AIERNTO,
         p_AQPC811AIEANTO,
         p_AQPC811AIAHNTO,
         p_AQPC811AEcMd25,
         p_AQPC811AEerNOT,
         p_AQPC811AEeaNOT,
         p_AQPC811AEahNOT,
         p_AQPC811AICMD10,
         p_AQPC811AIERNTL,
         p_AQPC811AIEANTL,
         p_AQPC811AIAHNTL,
         p_AQPC811AECMD11,
         p_AQPC811AEERALI,
         p_AQPC811AEEAALI,
         p_AQPC811AEAHALI,
         p_AQPC811AECMD12,
         p_AQPC811AEERALQ,
         p_AQPC811AEEAALQ,
         p_AQPC811AEAHALQ,
         p_AQPC811AECMD13,
         p_AQPC811AEERTRP,
         p_AQPC811AEEATRP,
         p_AQPC811AEAHTRP,
         p_AQPC811AECMD14,
         p_AQPC811AEEREDU,
         p_AQPC811AEEAEDU,
         p_AQPC811AEAHEDU,
         p_AQPC811AECMD15,
         p_AQPC811AEERSER,
         p_AQPC811AEEASER,
         p_AQPC811AEAHSER,
         p_AQPC811AECMD16,
         p_AQPC811AEERFAM,
         p_AQPC811AEEAFAM,
         p_AQPC811AEAHFAM,
         p_AQPC811AECMD17,
         p_AQPC811AEEROTR,
         p_AQPC811AEEAOTR,
         p_AQPC811AEAHOTR,
         p_AQPC811AECMD18,
         p_AQPC811AEERGFT,
         p_AQPC811AEEAGFT,
         p_AQPC811AEAHGFT,
         p_AQPC811AGCMD19,
         p_AQPC811AGERGFT,
         p_AQPC811AGEAGFT,
         p_AQPC811AGAHGFT,
         p_AQPC811AECMD20,
         p_AQPC811AEERNTM,
         p_AQPC811AEEANTM,
         p_AQPC811AEAHNTM,
         p_AQPC811AECMD21,
         p_AQPC811AEERCRP,
         p_AQPC811AEEACRP,
         p_AQPC811AECMD22,
         p_AQPC811AEERCRV,
         p_AQPC811AEEACRV,
         p_AQPC811AECMD23,
         p_AQPC811AEEREXF,
         p_AQPC811AEEAEXF,
         p_AQPC811ARTIGN1,
         p_AQPC811ARTIGN2,
         p_AQPC811ARTEXN1,
         p_AQPC811ARTEXN2,
         v_FechaActual,
         v_HoraActual,
         p_AQPC811AECMD24, --21082023
         p_AQPC811AEERCOT,
         p_AQPC811AEEACOT,
         p_AQPC811AECMD26,
         p_AQPC811AEERPOT,
         p_AQPC811AEEAPOT,
         v_correlativo,
         'H',
         auxInstnc);
      flgOk := 'S';
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        --ROLLBACK;
        flgOK := 'E';
    END;
  End;

  PROCEDURE sp_lista_relac_financ(CodOpinion number,
                                  fechaHoy   date,
                                  instancia  number) is
    xModelEvaluc    number(5);
    xFlgNoCodEntid  varchar2(1);
    xEntidad        varchar2(200);
    xSaldoVig       number(17, 2);
    xTipoCredi      varchar2(30);
    xGastoFinan     number(17, 2);
    xSaldoVigText   varchar2(20);
    xGastoFinanText varchar2(20);
  
    CURSOR relac_financ_13_centid IS
      SELECT JAQY327ENTI,
             JAQY327TCRE,
             JAQY327CENT,
             sum(JAQY327SDEU) SaldoDeuda,
             sum(JAQY327GFIN) Cuota
        FROM JAQY327
       WHERE JAQY327INST = instancia
         AND JAQY327ESTA = 'S'
       group by JAQY327ENTI, JAQY327TCRE, JAQY327CENT;
  
    Cursor rl_financ_13 is
      SELECT JAQY327ENTI,
             JAQY327TCRE,
             sum(JAQY327SDEU) SaldoDeuda,
             sum(JAQY327GFIN) Cuota
        FROM JAQY327
       WHERE JAQY327INST = instancia
         AND JAQY327ESTA = 'S'
       group by JAQY327ENTI, JAQY327TCRE;
  
    Cursor rl_financ_14_centid IS
      select JAQZ862ENTI,
             JAQZ862TCRE,
             JAQZ862CENT,
             sum(JAQZ862GFIN) Cuota,
             sum(JAQZ862SDEU) SaldoDeuda
        from jaqz862
       WHERE JAQZ862INST = instancia
         AND JAQZ862ESTA = 'S'
       group by JAQZ862ENTI, JAQZ862CENT, JAQZ862TCRE;
  
    Cursor rl_financ_14 IS
      select JAQZ862ENTI,
             JAQZ862TCRE,
             sum(JAQZ862GFIN) Cuota,
             sum(JAQZ862SDEU) SaldoDeuda
        from jaqz862
       WHERE JAQZ862INST = instancia
         AND JAQZ862ESTA = 'S'
       group by JAQZ862ENTI, JAQZ862TCRE;
  
  BEGIN
    --11092023 --actualizar garantías
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_cargar_c162(CodOpinion);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      DELETE FROM AQPC161 WHERE AQPC161CODOPI = CodOpinion;
      COMMIT;
    END;
  
    BEGIN
      SELECT SNG021TMod
        into xModelEvaluc
        FROM sng021
       WHERE SNG021Sol = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        xModelEvaluc := 0;
    END;
  
    IF xModelEvaluc = 13 THEN
      xFlgNoCodEntid := 'N';
      BEGIN
        SELECT 'S'
          INTO xFlgNoCodEntid
          FROM JAQY327
         WHERE JAQY327INST = instancia
           AND JAQY327ESTA = 'S'
           AND JAQY327CENT IS NULL
           AND ROWNUM < 2;
      EXCEPTION
        WHEN OTHERS THEN
          xFlgNoCodEntid := 'N';
      END;
    
      IF xFlgNoCodEntid = 'N' THEN
        FOR xentidades IN relac_financ_13_centid LOOP
          xEntidad    := xentidades.jaqy327enti;
          xSaldoVig   := xentidades.saldodeuda;
          xTipoCredi  := xentidades.jaqy327tcre;
          xGastoFinan := xentidades.cuota;
        
          xSaldoVigText   := trim(to_char(xSaldoVig));
          xGastoFinanText := trim(to_char(xGastoFinan));
        
          pq_cr_repo_opinion_riesgos.sp_insert_relacFinan_aqpc161(CodOpinion,
                                                                  fechaHoy,
                                                                  xEntidad,
                                                                  xGastoFinanText,
                                                                  xSaldoVigText,
                                                                  xTipoCredi);
        
        END LOOP;
      ELSE
        IF xFlgNoCodEntid = 'S' THEN
          FOR xentidades IN rl_financ_13 LOOP
            xEntidad    := xentidades.jaqy327enti;
            xSaldoVig   := xentidades.saldodeuda;
            xTipoCredi  := xentidades.jaqy327tcre;
            xGastoFinan := xentidades.cuota;
          
            xSaldoVigText   := trim(to_char(xSaldoVig));
            xGastoFinanText := trim(to_char(xGastoFinan));
          
            pq_cr_repo_opinion_riesgos.sp_insert_relacFinan_aqpc161(CodOpinion,
                                                                    fechaHoy,
                                                                    xEntidad,
                                                                    xGastoFinanText,
                                                                    xSaldoVigText,
                                                                    xTipoCredi);
          END LOOP;
        
        END IF;
      END IF;
    END IF;
  
    IF xModelEvaluc = 14 THEN
      xFlgNoCodEntid := 'N';
      BEGIN
        select 'S'
          INTO xFlgNoCodEntid
          from jaqz862
         WHERE JAQZ862INST = instancia
           AND JAQZ862ESTA = 'S'
           AND JAQZ862CENT IS NULL
           AND ROWNUM < 2;
      EXCEPTION
        WHEN OTHERS THEN
          xFlgNoCodEntid := 'N';
      END;
    
      IF xFlgNoCodEntid = 'N' THEN
        FOR xentidades IN rl_financ_14_centid LOOP
          xEntidad    := xentidades.jaqz862enti;
          xSaldoVig   := xentidades.saldodeuda;
          xTipoCredi  := xentidades.jaqz862tcre;
          xGastoFinan := xentidades.cuota;
        
          xSaldoVigText   := trim(to_char(xSaldoVig));
          xGastoFinanText := trim(to_char(xGastoFinan));
        
          pq_cr_repo_opinion_riesgos.sp_insert_relacFinan_aqpc161(CodOpinion,
                                                                  fechaHoy,
                                                                  xEntidad,
                                                                  xGastoFinanText,
                                                                  xSaldoVigText,
                                                                  xTipoCredi);
        
        END LOOP;
      ELSE
        IF xFlgNoCodEntid = 'S' THEN
          FOR xentidades IN rl_financ_14 LOOP
            xEntidad    := xentidades.jaqz862enti;
            xSaldoVig   := xentidades.saldodeuda;
            xTipoCredi  := xentidades.jaqz862tcre;
            xGastoFinan := xentidades.cuota;
          
            xSaldoVigText   := trim(to_char(xSaldoVig));
            xGastoFinanText := trim(to_char(xGastoFinan));
          
            pq_cr_repo_opinion_riesgos.sp_insert_relacFinan_aqpc161(CodOpinion,
                                                                    fechaHoy,
                                                                    xEntidad,
                                                                    xGastoFinanText,
                                                                    xSaldoVigText,
                                                                    xTipoCredi);
          END LOOP;
        
        END IF;
      END IF;
    END IF;
  
  END;
  procedure sp_niveles_opinion(TipoSolicitud    number,
                               montoConsolidado number,
                               nivelMaximoAlcan out number) IS
    xNivel number(17, 2);
  BEGIN
    BEGIN
      select TP1CORR3
        into xNivel
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11152
         and tp1corr1 = 10
         and tp1corr2 > 0
         and tp1corr3 > 0
         and tp1nro1 = TipoSolicitud
         and tp1imp1 < montoConsolidado
         and TP1IMP2 >= montoConsolidado;
    EXCEPTION
      WHEN OTHERS THEN
        xNivel := 0;
    END;
  
    IF xNivel IS NULL THEN
      xNivel := 0;
    END IF;
  
    CASE
      WHEN xNivel = 1 THEN
        nivelMaximoAlcan := 3;
      WHEN xNivel = 2 THEN
        nivelMaximoAlcan := 4;
      WHEN xNivel = 3 THEN
        nivelMaximoAlcan := 5;
      WHEN xNivel = 4 THEN
        nivelMaximoAlcan := 6;
      ELSE
        nivelMaximoAlcan := 0; --2108
    END CASE;
  
  END;

  procedure sp_obtener_coment_aqpc171(CodOpinion      number, --sp_obtn_comentarios_aqpc171
                                      instancia       number,
                                      xAQPC171ANCNEG  out varchar2,
                                      xAQPC171ANVIC   out varchar2,
                                      xAQPC171FCN     out varchar2,
                                      xAQPC171AESFCC  out varchar2,
                                      xAQPC171RDCLN   out varchar2,
                                      xAQPC171ANCP    out varchar2,
                                      xAQPC171ANCPG   out varchar2,
                                      xAQPC171DANDC   out varchar2,
                                      xAQPC171DGCOR   out varchar2,
                                      xAQPC171RANCNEG out varchar2,
                                      xAQPC171MTREP   out varchar2,
                                      xAQPC171RAESFCC out varchar2,
                                      xAQPC171ANCPRF  out varchar2,
                                      xAQPC171ANVPG   out varchar2,
                                      xAQPC171DEGV    out varchar2,
                                      xAQPC171RFANCNE out varchar2,
                                      xAQPC171MTREFN  out varchar2,
                                      xAQPC171RFAESFC out varchar2,
                                      xAQPC171RFANCPR out varchar2,
                                      xAQPC171RFANVPG out varchar2,
                                      xAQPC171RFDEGV  out varchar2,
                                      xAQPC171USURAR  out varchar2,
                                      xAQPC171COMEN   out varchar2,
                                      xAQPC171RESOL   out varchar2,
                                      xAQPC171CONREC  out varchar2,
                                      xAQPC171ARGRECO out varchar2, -- INI RCASTRO 10072023
                                      xAQPC171ANACOME out varchar2,
                                      xAQPC171RESOLRE out varchar2,
                                      xAQPC171CONDREC out varchar2, -- FIN RCASTRO 10072023 
                                      xAQPC171MOTOBSV out varchar2 -- 07112023
                                      ) IS
  BEGIN
    BEGIN
      SELECT AQPC171ANCNEG,
             AQPC171ANVIC,
             AQPC171FCN,
             AQPC171AESFCC,
             AQPC171RDCLN,
             AQPC171ANCP,
             AQPC171ANCPG,
             AQPC171DANDC,
             AQPC171DGCOR,
             AQPC171RANCNEG,
             AQPC171MTREP,
             AQPC171RAESFCC,
             AQPC171ANCPRF,
             AQPC171ANVPG,
             AQPC171DEGV,
             AQPC171RFANCNE,
             AQPC171MTREFN,
             AQPC171RFAESFC,
             AQPC171RFANCPR,
             AQPC171RFANVPG,
             AQPC171RFDEGV,
             AQPC171USURAR,
             AQPC171COMEN,
             AQPC171RESOL,
             AQPC171CONREC,
             AQPC171ARGRECO,
             AQPC171ANACOME,
             AQPC171RESOLRE,
             AQPC171CONDREC,
             AQPC171MOTOBSV
        INTO xAQPC171ANCNEG,
             xAQPC171ANVIC,
             xAQPC171FCN,
             xAQPC171AESFCC,
             xAQPC171RDCLN,
             xAQPC171ANCP,
             xAQPC171ANCPG,
             xAQPC171DANDC,
             xAQPC171DGCOR,
             xAQPC171RANCNEG,
             xAQPC171MTREP,
             xAQPC171RAESFCC,
             xAQPC171ANCPRF,
             xAQPC171ANVPG,
             xAQPC171DEGV,
             xAQPC171RFANCNE,
             xAQPC171MTREFN,
             xAQPC171RFAESFC,
             xAQPC171RFANCPR,
             xAQPC171RFANVPG,
             xAQPC171RFDEGV,
             xAQPC171USURAR,
             xAQPC171COMEN,
             xAQPC171RESOL,
             xAQPC171CONREC,
             xAQPC171ARGRECO, --10072023
             xAQPC171ANACOME,
             xAQPC171RESOLRE,
             xAQPC171CONDREC,
             xAQPC171MOTOBSV
        FROM AQPC171
       WHERE AQPC171CODOPI = CodOpinion
         AND AQPC171INST = instancia
         AND AQPC171ESTAD = 'H'; --21082023
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;

  PROCEDURE sp_insert_aqpc813_titul(codOpinion      number, --07112023
                                    instancia       number,
                                    xAQPC813PAIS    number,
                                    xAQPC813PETDOC  number,
                                    xAQPC813PENDOC  varchar2,
                                    xAQPC813DESTDOC varchar2,
                                    xAQPC813NOMCLI  varchar2,
                                    xAQPC813RELAC   varchar2) IS
    maxCorrel     number(5);
    v_FechaActual DATE;
    v_HoraActual  VARCHAR2(8);
  
  BEGIN
    IF instancia > 0 THEN
      --1108
      v_FechaActual := TO_DATE(SYSDATE, 'dd/mm/rrrr');
      v_HoraActual  := TO_CHAR(SYSDATE, 'HH24:MI:SS');
    
      BEGIN
        SELECT MAX(AQPC813CORR)
          INTO maxCorrel
          FROM AQPC813
         WHERE AQPC813INSTAN = instancia
           AND AQPC813AUX2 = codOpinion;
      EXCEPTION
        WHEN OTHERS THEN
          maxCorrel := 0;
      END;
    
      IF maxCorrel IS NULL THEN
        maxCorrel := 0;
      END IF;
    
      maxCorrel := maxCorrel + 1;
    
      BEGIN
        INSERT INTO AQPC813
          (AQPC813INSTAN,
           AQPC813CORR,
           AQPC813PAIS,
           AQPC813PETDOC,
           AQPC813PENDOC,
           AQPC813DESTDOC,
           AQPC813NOMCLI,
           AQPC813RELAC,
           AQPC813FECHREG,
           AQPC813HORAREG,
           AQPC813AUX2) --07112023
        VALUES
          (instancia,
           maxCorrel,
           xAQPC813PAIS,
           xAQPC813PETDOC,
           xAQPC813PENDOC,
           xAQPC813DESTDOC,
           xAQPC813NOMCLI,
           xAQPC813RELAC,
           v_FechaActual,
           v_HoraActual,
           codOpinion);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  END;

  PROCEDURE sp_lista_opiniones(instancia    number,
                               userIngreso  varchar2,
                               nivelUsuIng  number,
                               userSuplente varchar2,
                               nivelUsuSupl number,
                               fechaIngreso date,
                               msgError     out varchar2) IS
    ----01042024
    --Variables
    i        number(1);
    auxUser  varchar2(10);
    auxUser2 varchar2(10);
    auxNivel number(2);
    flgErr   varchar2(200);
    n        number(1);
  BEGIN
    BEGIN
      DELETE FROM AQPC194 WHERE AQPC194USUEJ = userIngreso; --18112024
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    i := 1;
    n := 1;
    IF userSuplente <> '' or userSuplente <> ' ' THEN
      n := 2;
    END IF;
  
    WHILE (i <= n) LOOP
      CASE
        WHEN i = 1 THEN
          auxUser  := userIngreso;
          auxNivel := nivelUsuIng;
        WHEN i = 2 THEN
          auxUser2 := userSuplente;
          auxNivel := nivelUsuSupl;
        ELSE
          NULL; --2108
      END CASE;
      IF auxNivel in (1, 2, 3) THEN
        --
        BEGIN
          pq_cr_repo_opinion_riesgos.sp_cargar_solic_pend_opinion(instancia,
                                                                  auxUser,
                                                                  auxUser2,
                                                                  fechaIngreso,
                                                                  auxNivel,
                                                                  flgErr);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        msgError := flgErr; --01042024
      ELSE
        IF auxNivel in (4, 5, 6) THEN
          BEGIN
            pq_cr_repo_opinion_riesgos.sp_cargar_opiniones_156(auxUser,
                                                               0,
                                                               fechaIngreso,
                                                               flgErr);
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
        msgError := flgErr; --01042024
      END IF;
    
      i := i + 1;
    END LOOP;
  END;

  --10072023
  PROCEDURE sp_limpiar_por_usu_aqpc194(userIngreso varchar2) IS
  BEGIN
    DELETE FROM AQPC194
     WHERE rpad(AQPC194USUEJ, 10, ' ') = rpad(userIngreso, 10, ' ');
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE sp_obtenr_usu_AC_GA(instancia number,
                                sucurCred number,
                                usuarioGA OUT varchar2,
                                usuarioAC OUT varchar2) IS
  
    xEmail    varchar2(100);
    xCodCargo number(4);
  BEGIN
    --actualizar ACreditos y GA
    BEGIN
      select SNG001ASE
        INTO usuarioAC
        from sng001
       where sng001inst = instancia
         AND ROWNUM < 2;
    EXCEPTION
      WHEN OTHERS THEN
        usuarioAC := '';
    END;
  
    xCodCargo := 202;
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_buscar_usuario_correo_GA(sucurCred,
                                                             xCodCargo,
                                                             usuarioGA,
                                                             xEmail);
    EXCEPTION
      WHEN OTHERS THEN
        usuarioGA := '';
    END;
  END;

  PROCEDURE sp_actualiza_reconsideracion(instancia number, --10072023
                                         codOpini  number) IS
    varRecons number(4);
  BEGIN
    BEGIN
      --2108
      pq_cr_repo_opinion_riesgos.sp_grab_log_aqpc156(codOpini, instancia);
    END;
  
    BEGIN
      SELECT AQPC156NRECONS
        INTO varRecons
        FROM AQPC156
       WHERE AQPC156CODOPI = codOpini
         AND AQPC156INSTAN = instancia
         AND AQPC156ESTAD = 'H'; --2108;
    EXCEPTION
      WHEN OTHERS THEN
        varRecons := 0;
    END;
  
    IF varRecons IS NULL THEN
      varRecons := 0;
    END IF;
  
    varRecons := varRecons + 1;
  
    BEGIN
      UPDATE AQPC156
         SET AQPC156NRECONS = varRecons
       WHERE AQPC156CODOPI = codOpini
         and AQPC156INSTAN = instancia
         AND AQPC156ESTAD = 'H'; --2108;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;

  PROCEDURE sp_val_zona_soli_pertenc_AnaliRiesgo(intancia        number,
                                                 userAnaliRiesgo varchar2,
                                                 flgTieneAsignad out varchar2) IS
    SucursalCred  number(3);
    ZonaCred      number(3);
    TieneDerivado varchar2(1);
  BEGIN
    TieneDerivado := 'N'; -- MOD RCASTRO 25072023
    BEGIN
      SELECT XWFSUCURSAL
        INTO SucursalCred
        FROM XWF700
       WHERE XWFPRCINS = intancia
         AND XWFCAR3 = '1'
         AND ROWNUM < 2;
    EXCEPTION
      WHEN OTHERS THEN
        SucursalCred := 0;
    END;
  
    --Zona crédito
    BEGIN
      SELECT CODZON
        INTO ZonaCred
        FROM REGSUC
       WHERE SUCURS = SucursalCred
         AND ROWNUM < 2;
    EXCEPTION
      WHEN OTHERS THEN
        ZonaCred := 0;
    END;
    -- validar si el analista de crédito tiene asignado la sucursal
    BEGIN
      SELECT 'S'
        INTO flgTieneAsignad
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND TP1CORR1 = 11
         AND TP1CORR2 = 7
         AND TP1CORR3 > 0
         AND TP1IMP1 = ZonaCred --04/12/2023
         AND TP1NRO3 = SucursalCred
         AND rpad(TP1DESC, 10, ' ') = rpad(userAnaliRiesgo, 10, ' ')
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        flgTieneAsignad := 'N';
    END;
    flgTieneAsignad := NVL(flgTieneAsignad, 'N');
  
    -- para exonerar casos de delegación
    IF flgTieneAsignad = 'N' THEN
      BEGIN
        SELECT 'S'
          INTO TieneDerivado
          FROM AQPC156 G
         WHERE G.AQPC156CODOPI =
               (SELECT (MAX(B.AQPC156CODOPI))
                  FROM AQPC156 B
                 WHERE B.AQPC156INSTAN = intancia
                   AND B.AQPC156ESTAD = 'H') --18/12/2023
           AND G.AQPC156INSTAN = intancia
           AND G.AQPC156ESTAD = 'H' --2108
           AND G.AQPC156USRDER = userAnaliRiesgo;
        --AND G.AQPC156ANSERIG = userAnaliRiesgo comment 18112024
        --AND G.AQPC156NIVEL = 3;   comment 18112024
      EXCEPTION
        WHEN OTHERS THEN
          TieneDerivado := 'N';
      END;
    
      IF TieneDerivado = 'S' THEN
        flgTieneAsignad := 'S';
      END IF;
    END IF;
  END;

  PROCEDURE sp_obtn_usuar_suplencia(fechaActual   date,
                                    usuario       varchar2,
                                    usuarioSuplen out varchar2,
                                    correoSuplen  out varchar2) is
  BEGIN
    BEGIN
      SELECT SNG057Sup
        INTO usuarioSuplen
        FROM SNG057
       WHERE SNG055Emp = 1
         AND SNG057Usr = RPAD(usuario, 10, ' ') --09/07/2024
         AND SNG057Ini <= fechaActual
         And SNG057Fin >= fechaActual
         AND ROWNUM < 2;
    EXCEPTION
      WHEN OTHERS THEN
        usuarioSuplen := ' ';
    END;
  
    usuarioSuplen := TRIM(usuarioSuplen); --09/07/2024
  
    IF usuarioSuplen IS NULL OR usuarioSuplen = ' ' THEN
      usuarioSuplen := ' ';
    ELSE
      -- CORREO
      BEGIN
        SELECT WFUSREMAIL
          INTO correoSuplen
          FROM WFUSERS
         WHERE WFUSRCOD = RPAD(usuarioSuplen, 30, ' '); --09/07/2024
      EXCEPTION
        WHEN OTHERS THEN
          correoSuplen := ' ';
      END;
    END IF;
  END;

  PROCEDURE sp_validar_vigent_solic(instancia number,
                                    flgActivo OUT varchar2) is
    --3107
    xflagAux   varchar2(1);
    codOpinion number(10) := 0;
  BEGIN
    xflagAux := 'N';
    BEGIN
      SELECT 'S'
        INTO flgActivo
        FROM WFWRKITEMS B
       WHERE --B.WFTASKCOD = 11 AND
       B.WFINSPRCID = INSTANCIA
       AND B.WFITEMSTSACT = 1;
    EXCEPTION
      WHEN OTHERS THEN
        flgActivo := 'N';
    END;
    flgActivo := nvl(flgActivo, 'N'); --01042024
    --flgActivo := xflagAux;
  
    --actualizar AQPC156 con estado X -- RECHAZADO - INACTIVO
    /*IF flgActivo = 'N' THEN   01042024
      BEGIN
        --2108
        pq_cr_repo_opinion_riesgos.sp_grab_log_aqpc156(codOpinion,
                                                       instancia);
      END;
    
      BEGIN
        UPDATE AQPC156
           SET AQPC156ESTOP = 'X'
         WHERE 
           AQPC156CODOPI = ( SELECT (MAX(B.AQPC156CODOPI))
                             FROM AQPC156 B
                             WHERE B.AQPC156INSTAN = instancia
                             ) --18/12/2023
           AND AQPC156INSTAN = instancia
           AND AQPC156ESTAD = 'H'; --2108;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;*/
  
  END;

  PROCEDURE sp_val_visuali_anali_contd(instancia      number,
                                       txtProductoSBS varchar2,
                                       flgHabAnCont   out varchar2) is
    --03082023
    auxProdSBS varchar2(30);
    posi       number(2);
    xchar1     varchar2(30);
    xchar2     varchar2(30);
    longi      number(2);
    auxText    varchar2(30);
    codOpinion number(10);
  BEGIN
    auxText := upper(trim(txtProductoSBS));
    longi   := length(auxText);
    posi    := instr(auxText, ' ');
  
    IF posi > 0 THEN
      xchar1     := trim(substr(auxText, 1, posi - 1));
      xchar2     := trim(substr(auxText, posi, longi));
      auxProdSBS := xchar1 || ' ' || xchar2;
    ELSE
      auxProdSBS := auxText;
    END IF;
  
    --auxText := '%' || trim(auxProdSBS) || '%'; --RPAD(auxProdSBS, 30, ' ') || '%';
  
    flgHabAnCont := 'N';
    BEGIN
      SELECT 'S'
        INTO flgHabAnCont
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND TP1CORR1 = 15
         AND TP1CORR2 = 1
         AND TP1CORR3 > 0
         AND (TP1DESC = RPAD(auxProdSBS, 30, ' ') OR
             TP1DESC = RPAD(auxProdSBS || 'S', 30, ' '));
    EXCEPTION
      WHEN OTHERS THEN
        flgHabAnCont := 'N';
    END;
  
    --actualizar aqc156 campo activ analisis contador
    IF instancia > 0 THEN
      codOpinion := 0;
      BEGIN
        --2108
        pq_cr_repo_opinion_riesgos.sp_grab_log_aqpc156(codOpinion,
                                                       instancia);
      END;
      BEGIN
        UPDATE AQPC156
           SET AQPC156ACTCONT = flgHabAnCont,
               AQPC156PRODSBS = txtProductoSBS
         WHERE AQPC156CODOPI =
               (SELECT (MAX(B.AQPC156CODOPI))
                  FROM AQPC156 B
                 WHERE B.AQPC156INSTAN = instancia) --18/12/2023
           AND AQPC156INSTAN = instancia
           AND AQPC156ESTAD = 'H'; --2108;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  END;

  PROCEDURE sp_obtener_tipo_cambio(instancia number, tipoCambio out number) IS
    Fechaf017 DATE;
  BEGIN
    tipoCambio := 0;
    BEGIN
      SELECT SNG120TCBI
        INTO TIPOCAMBIO
        FROM SNG120
       WHERE SNG120INS = instancia
         AND SNG120TSK = 'EVALUACION'
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        tipoCambio := 0;
    END;
  
    IF tipoCambio is null or tipoCambio = 0 THEN
      BEGIN
        SELECT E.PGFAPE INTO Fechaf017 FROM FST017 E WHERE E.PGCOD = 1;
      EXCEPTION
        WHEN OTHERS THEN
          Fechaf017 := TO_DATE(SYSDATE, 'dd/mm/rrrr');
      END;
      TIPOCAMBIO := fn_tipo_cambio_fijo(Fechaf017);
    END IF;
  END;

  PROCEDURE sp_lista_cred_Avalados(codOpinion number, instancia number) is
    auxTmod       NUMBER(4);
    p_nomcli      VARCHAR2(30);
    v_saldod011   number(17, 2);
    v_mnto_Otorg  number(17, 2);
    v_modalidad   varchar(200);
    v_promeAtraso number(7, 2);
    v_Fechaf017   DATE;
    v_totCuotas   number(5, 2);
    v_cuotPagad   number(5, 2);
    v_CharTotCuot varchar(30);
    v_Cuota       number(17, 2);
    v_tasa        number(15, 6);
  
    CURSOR PymeAvalados IS
      SELECT *
        FROM JAQY142
       WHERE JAQY142INST = instancia
         AND JAQY142EST = 'H'
         AND JAQY142INDIC IN ('CredVgnAvl', 'CredVlAval'); -- 18/12/2023
  
    CURSOR ConsumAvalados is
      SELECT *
        FROM JAQZ822
       WHERE JAQZ822INST = instancia
         AND JAQZ822EST = 'H'
         AND JAQZ822INDIC IN ('CredVgnAvl', 'CredVlAval'); --18/12/2023
  
  BEGIN
    BEGIN
      select SNG021TMOD
        INTO auxTmod
        from sng021
       where SNG021SOL = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        auxTmod := 0;
    END;
  
    --2912
    BEGIN
      UPDATE AQPC816
         SET AQPC816EST = 'I'
       WHERE AQPC816CODOPI = codOpinion
         AND AQPC816INSTAN = instancia
         AND AQPC816EST = 'H';
      -- DELETE FROM AQPC816 E WHERE E.AQPC816CODOPI = codOpinion AND E.AQPC816INSTAN = instancia;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF AUXTMOD = 13 THEN
      FOR xr IN PymeAvalados LOOP
        BEGIN
          pq_cr_repo_opinion_riesgos.sp_obtner_datos_Avald(xr.jaqy142pgcod,
                                                           xr.jaqy142suc,
                                                           xr.jaqy142mod,
                                                           xr.jaqy142mda,
                                                           xr.jaqy142pap,
                                                           xr.jaqy142cta,
                                                           xr.jaqy142ope,
                                                           xr.jaqy142sbop,
                                                           xr.jaqy142tope,
                                                           p_nomcli,
                                                           v_saldod011,
                                                           v_mnto_Otorg,
                                                           v_modalidad,
                                                           v_promeAtraso,
                                                           v_CharTotCuot,
                                                           v_Cuota,
                                                           v_tasa);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        BEGIN
          pq_cr_repo_opinion_riesgos.sp_Insert_AQPC816(codOpinion,
                                                       instancia,
                                                       xr.jaqy142pgcod,
                                                       xr.jaqy142mod,
                                                       xr.jaqy142suc,
                                                       xr.jaqy142mda,
                                                       xr.jaqy142pap,
                                                       xr.jaqy142cta,
                                                       xr.jaqy142ope,
                                                       xr.jaqy142sbop,
                                                       xr.jaqy142tope,
                                                       p_nomcli,
                                                       v_saldod011,
                                                       v_mnto_Otorg,
                                                       v_modalidad,
                                                       v_promeAtraso,
                                                       v_CharTotCuot,
                                                       v_Cuota,
                                                       v_tasa);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
      END LOOP;
    ELSE
      IF AUXTMOD = 14 THEN
        FOR xr IN ConsumAvalados LOOP
          BEGIN
            pq_cr_repo_opinion_riesgos.sp_obtner_datos_Avald(xr.jaqz822pgcod,
                                                             xr.jaqz822suc,
                                                             xr.jaqz822mod,
                                                             xr.jaqz822mda,
                                                             xr.jaqz822pap,
                                                             xr.jaqz822cta,
                                                             xr.jaqz822ope,
                                                             xr.jaqz822sbop,
                                                             xr.jaqz822tope,
                                                             p_nomcli,
                                                             v_saldod011,
                                                             v_mnto_Otorg,
                                                             v_modalidad,
                                                             v_promeAtraso,
                                                             v_CharTotCuot,
                                                             v_Cuota,
                                                             v_tasa);
          EXCEPTION
            WHEN OTHERS THEN
              p_nomcli      := '';
              v_saldod011   := 0;
              v_mnto_Otorg  := 0;
              v_modalidad   := '';
              v_promeAtraso := 0;
              v_CharTotCuot := '';
              v_Cuota       := 0;
              v_tasa        := 0;
          END;
        
          BEGIN
            pq_cr_repo_opinion_riesgos.sp_Insert_AQPC816(codOpinion,
                                                         instancia,
                                                         xr.jaqz822pgcod,
                                                         xr.jaqz822mod,
                                                         xr.jaqz822suc,
                                                         xr.jaqz822mda,
                                                         xr.jaqz822pap,
                                                         xr.jaqz822cta,
                                                         xr.jaqz822ope,
                                                         xr.jaqz822sbop,
                                                         xr.jaqz822tope,
                                                         p_nomcli,
                                                         v_saldod011,
                                                         v_mnto_Otorg,
                                                         v_modalidad,
                                                         v_promeAtraso,
                                                         v_CharTotCuot,
                                                         v_Cuota,
                                                         v_tasa);
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END LOOP;
      
      END IF;
    END IF;
  END;

  PROCEDURE sp_obtner_datos_Avald(p_empresa     NUMBER,
                                  p_sucursal    NUMBER,
                                  p_modulo      NUMBER,
                                  p_moned       NUMBER,
                                  p_papel       NUMBER,
                                  p_cuenta      NUMBER,
                                  p_operacion   NUMBER,
                                  p_suboper     NUMBER,
                                  p_tipoper     NUMBER,
                                  p_nomcli      out VARCHAR2,
                                  p_saldoAct    out NUMBER,
                                  v_mnto_Otorg  out NUMBER,
                                  v_modalidad   out VARCHAR2,
                                  v_promeAtraso out NUMBER,
                                  v_CharTotCuot out VARCHAR2,
                                  v_Cuota       OUT NUMBER,
                                  v_tasa        OUT NUMBER) IS
    v_Fechaf017   DATE;
    v_cuotPagad   NUMBER(10, 2);
    v_totCuotas   NUMBER(4);
    p_PERIODO     number(5);
    p_descPeriodo VARCHAR2(30);
  BEGIN
    -- nom cliente
    p_nomcli := '';
    BEGIN
      SELECT R.PENOM
        INTO p_nomcli
        FROM FSR008 E, FSD001 R
       WHERE E.PEPAIS = R.PEPAIS
         AND E.PETDOC = R.PETDOC
         AND E.PENDOC = R.PENDOC
         AND CTNRO = p_cuenta
         AND CTTFIR = 'T'
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        p_nomcli := '';
    END;
  
    -- saldo
    p_saldoAct := 0;
    BEGIN
      SELECT (g.scsdo * (-1)) saldo
        INTO p_saldoAct
        FROM FSD011 G
       WHERE g.pgcod = p_empresa
         AND g.scsuc = p_sucursal
         AND g.scmod = p_modulo
         AND g.scmda = p_moned
         AND g.scpap = p_papel
         AND g.sccta = p_cuenta
         AND g.scoper = p_operacion
         AND g.scsbop = p_suboper
         AND g.sctope = p_tipoper;
    EXCEPTION
      WHEN OTHERS THEN
        p_saldoAct := 0;
    END;
  
    --Monto otorgado
    v_mnto_Otorg := 0;
    BEGIN
      SELECT XLLCAPITAL, XLLPERIODO
        INTO v_mnto_Otorg, p_PERIODO
        FROM x054023
       WHERE XLLPGCOD = p_empresa
         AND XLLAOMOD = p_modulo
         AND XLLAOSUC = p_sucursal
         AND XLLAOMDA = p_moned
         AND XLLAOPAP = p_papel
         AND XLLAOCTA = p_cuenta
         AND XLLAOOPER = p_operacion
         AND XLLAOSBOP = p_suboper
         AND XLLAOTOP = p_tipoper;
    EXCEPTION
      WHEN OTHERS THEN
        v_mnto_Otorg := 0;
    END;
  
    --descripcion periodo
    BEGIN
      SELECT TP1DESC
        INTO p_descPeriodo
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         and tp1corr1 = 13
         AND TP1CORR3 > 0
         AND TP1NRO1 = p_PERIODO;
    EXCEPTION
      WHEN OTHERS THEN
        p_descPeriodo := '';
    END;
  
    -- Modalidad 
    v_modalidad := '--';
    BEGIN
      SELECT p_modulo || '-' || TRIM(A.MDNOM) || ', ' || p_tipoper || '-' ||
             TRIM(B.TONOM)
        INTO v_modalidad
        FROM FST003 A, FST004 B
       WHERE A.MODULO = p_modulo
         AND B.TOTOPE = p_tipoper
         AND B.MODULO = A.MODULO
         AND ROWNUM < 2;
    EXCEPTION
      WHEN OTHERS THEN
        v_modalidad := '';
    END;
  
    -- Promedio Dias Atraso 6 meses
    v_promeAtraso := 0;
    BEGIN
      SELECT E.PGFAPE INTO v_Fechaf017 FROM FST017 E WHERE E.PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        v_Fechaf017 := TO_DATE(SYSDATE, 'dd/mm/rrrr');
    END;
  
    BEGIN
      PQ_CR_CENTRAL.SP_6MESES(p_empresa,
                              p_modulo,
                              p_sucursal,
                              p_moned,
                              p_papel,
                              p_cuenta,
                              p_operacion,
                              p_suboper,
                              p_tipoper,
                              v_Fechaf017,
                              v_promeAtraso);
    EXCEPTION
      WHEN OTHERS THEN
        v_promeAtraso := 0;
    END;
  
    -- Total Cuotas
    v_totCuotas := 0;
    BEGIN
      SELECT COUNT(1)
        INTO v_totCuotas
        FROM FSD601 P
       WHERE P.PGCOD = p_empresa
         AND P.PPMOD = p_modulo
         AND P.PPSUC = p_sucursal
         AND P.PPMDA = p_moned
         AND P.PPPAP = p_papel
         AND P.PPCTA = p_cuenta
         AND P.PPOPER = p_operacion
         AND P.PPSBOP = p_suboper
         AND P.PPTOPE = p_tipoper
         AND P.D601CO = 'S';
    EXCEPTION
      WHEN OTHERS THEN
        v_totCuotas := 0;
    END;
  
    v_cuotPagad := 0;
    BEGIN
      SELECT count(1)
        INTO v_cuotPagad
        FROM FSD601 B
       INNER JOIN FSD602 C
          ON B.PGCOD = C.PGCOD
         AND B.PPMOD = C.PPMOD
         AND B.PPSUC = C.PPSUC
         AND B.PPMDA = C.PPMDA
         AND B.PPPAP = C.PPPAP
         AND B.PPCTA = C.PPCTA
         AND B.PPOPER = C.PPOPER
         AND B.PPSBOP = C.PPSBOP
         AND B.PPTOPE = C.PPTOPE
         AND B.PPFPAG = C.PPFPAG
         AND B.PPTIPO = C.PPTIPO
       WHERE C.D602co = 'S'
         AND C.Pp1stat = 'T'
         AND B.PGCOD = p_empresa
         AND B.PPMOD = p_modulo
         AND B.PPSUC = p_sucursal
         AND B.PPMDA = p_moned
         AND B.PPPAP = p_papel
         AND B.PPCTA = p_cuenta
         AND B.PPOPER = p_operacion
         AND B.PPSBOP = p_suboper
         AND B.PPTOPE = p_tipoper;
    EXCEPTION
      WHEN OTHERS THEN
        v_cuotPagad := 0;
    END;
  
    v_CharTotCuot := to_char(v_cuotPagad) || '/' || to_char(v_totCuotas) ||
                     ' cuo. ' || trim(p_descPeriodo);
  
    --Cuota
    v_Cuota := 0;
    BEGIN
      PQ_CR_RESOLUTOR_CAPPAGO.SP_CR_MAXCUOTPPAGO(p_empresa,
                                                 p_modulo,
                                                 p_sucursal,
                                                 p_moned,
                                                 p_papel,
                                                 p_cuenta,
                                                 p_operacion,
                                                 p_suboper,
                                                 p_tipoper,
                                                 1,
                                                 v_Cuota);
    EXCEPTION
      WHEN OTHERS THEN
        v_Cuota := 0;
    END;
  
    --TASA
    v_tasa := 0;
    BEGIN
      SELECT EVTASA
        INTO v_tasa
        FROM FSD012 E
       WHERE E.PGCOD = p_empresa
         AND E.AOMOD = p_modulo
         AND E.AOSUC = p_sucursal
         AND E.AOMDA = p_moned
         AND E.AOPAP = p_papel
         AND E.AOCTA = p_cuenta
         AND E.AOOPER = p_operacion
         AND E.AOSBOP = p_suboper
         AND E.AOTOPE = p_tipoper
         AND E.EVTIPO = 3
         AND E.D012CO = 'S'
         AND E.EVFVAL = (select max(E.EVFVAL)
                           from FSD012 E
                          WHERE E.PGCOD = p_empresa
                            AND E.AOMOD = p_modulo
                            AND E.AOSUC = p_sucursal
                            AND E.AOMDA = p_moned
                            AND E.AOPAP = p_papel
                            AND E.AOCTA = p_cuenta
                            AND E.AOOPER = p_operacion
                            AND E.AOSBOP = p_suboper
                            AND E.AOTOPE = p_tipoper
                            AND E.EVTIPO = 3
                            AND E.D012CO = 'S');
    EXCEPTION
      WHEN OTHERS THEN
        v_tasa := 0;
    END;
  
    IF v_tasa IS NULL THEN
      v_tasa := 0;
    END IF;
  
    IF v_tasa = 0 then
      BEGIN
        SELECT R.AOTASA
          INTO v_tasa
          FROM FSD010 R
         WHERE R.PGCOD = p_empresa
           AND R.AOMOD = p_modulo
           AND R.AOSUC = p_sucursal
           AND R.AOMDA = p_moned
           AND R.AOPAP = p_papel
           AND R.AOCTA = p_cuenta
           AND R.AOOPER = p_operacion
           AND R.AOSBOP = p_suboper
           AND R.AOTOPE = p_tipoper;
      EXCEPTION
        WHEN OTHERS THEN
          v_tasa := 0;
      END;
    END IF;
  END;

  PROCEDURE sp_Insert_AQPC816(codOpinion   NUMBER,
                              instancia    NUMBER,
                              p_empresa    NUMBER,
                              p_modulo     NUMBER,
                              p_sucursal   NUMBER,
                              p_moned      NUMBER,
                              p_papel      NUMBER,
                              p_cuenta     NUMBER,
                              p_operacion  NUMBER,
                              p_suboper    NUMBER,
                              p_tipoper    NUMBER,
                              p_nomClien   VARCHAR2,
                              p_saldo      NUMBER,
                              p_montoOtorg NUMBER,
                              p_modalidad  VARCHAR2,
                              p_promedAtrs NUMBER,
                              p_totCuot    VARCHAR2,
                              p_cuota      NUMBER,
                              p_tasa       NUMBER) IS
    v_correlativo number(10);
    v_FechaActual date;
    v_HoraActual  varchar2(10);
  BEGIN
    BEGIN
      SELECT MAX(AQPC816CORR)
        INTO v_correlativo
        FROM AQPC816 E
       WHERE E.AQPC816CODOPI = codOpinion
         AND E.AQPC816INSTAN = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        v_correlativo := 0;
    END;
    IF v_correlativo IS NULL THEN
      v_correlativo := 0;
    END IF;
  
    v_correlativo := v_correlativo + 1;
  
    v_FechaActual := TO_DATE(SYSDATE, 'dd/mm/rrrr');
    v_HoraActual  := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  
    BEGIN
      INSERT INTO AQPC816
        (AQPC816CODOPI,
         AQPC816CORR,
         AQPC816FECREG,
         AQPC816HORREG,
         AQPC816INSTAN,
         AQPC816EST,
         AQPC816PGCOD,
         AQPC816MOD,
         AQPC816SUC,
         AQPC816MDA,
         AQPC816PAP,
         AQPC816CTA,
         AQPC816OPE,
         AQPC816SBOP,
         AQPC816TOPE,
         AQPC816NOMCLI,
         AQPC816SALDO,
         AQPC816MNTOTG,
         AQPC816MODALI,
         AQPC816PRMATRA,
         AQPC816TOTCUO,
         AQPC816CUOTA,
         AQPC816TASA)
      VALUES
        (codOpinion,
         v_correlativo,
         v_FechaActual,
         v_HoraActual,
         instancia,
         'H',
         p_empresa,
         p_modulo,
         p_sucursal,
         p_moned,
         p_papel,
         p_cuenta,
         p_operacion,
         p_suboper,
         p_tipoper,
         p_nomClien,
         p_saldo,
         p_montoOtorg,
         p_modalidad,
         p_promedAtrs,
         p_totCuot,
         p_cuota,
         p_tasa);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  END;

  PROCEDURE sp_obtn_val_cred_pyme(instancia         number,
                                  nroINTipoCN       number, --30042024                        
                                  xCredPropueAct    out number,
                                  xCredPropueAnt    out number,
                                  xSumcuotaVigRec   OUT number,
                                  xSumcuotaVigAnter OUT number,
                                  xCredicContingAct out number,
                                  xCredicContingAnt out number,
                                  xCredPotencAct    OUT number,
                                  xCredPotencAnt    OUT number) IS
    auxInstanAnt  number(10);
    ln_ModInst    number;
    ln_ModInstAnt number;
    fechAntOut    date;
    TipFlujCN     varchar2(1);
    Indicflujo    varchar2(3);
  
    crm_xCredPropueAct    number(17, 2);
    crm_xCredPropueAnt    number(17, 2);
    crm_xSumcuotaVigRec   number(17, 2);
    crm_xSumcuotaVigAnter number(17, 2);
    crm_xCredicContingAct number(17, 2);
    crm_xCredicContingAnt number(17, 2);
    crm_xCredPotencAct    number(17, 2);
    crm_xCredPotencAnt    number(17, 2);
  
    nroOUTipoCN number(1);
  
  BEGIN
    --Cred. Propuesto actual
    xCredPropueAct := 0;
    begin
      select x.xwfmodulo
        into ln_ModInst
        from xwf700 x
       where x.xwfprcins = instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_ModInst <> 117 then
      BEGIN
        SELECT JAQY142CAPCUO
          INTO xCredPropueAct
          FROM XWF700 A, JAQY142 B
         WHERE A.XWFEMPRESA = B.JAQY142PGCOD
           AND A.XWFSUCURSAL = B.JAQY142SUC
           AND A.XWFCUENTA = B.JAQY142CTA
           AND A.XWFOPERACION = B.JAQY142OPE
           AND A.XWFPRCINS = B.JAQY142INST
           AND A.XWFTIPOPE = B.JAQY142TOPE
           AND XWFPRCINS = instancia
           AND XWFCAR3 = '1'
           AND B.JAQY142EST = 'H'
           AND B.JAQY142NRCUO > 1
           and (B.jaqy142mod not in
               (select tp1nro1
                   from fst198 a
                  where a.tp1cod = 1
                    and a.tp1cod1 = 10899
                    and a.tp1corr1 = 13
                    and a.tp1corr2 = 1) and B.jaqy142mod not in 117)
           AND b.jaqy142tarea = 7;
      EXCEPTION
        WHEN OTHERS THEN
          xCredPropueAct := 0;
      END;
    else
      if ln_ModInst = 117 then
        BEGIN
          SELECT JAQY142CAPCUO
            INTO xCredPropueAct
            FROM XWF700 A, JAQY142 B
           WHERE A.XWFEMPRESA = B.JAQY142PGCOD
             AND A.XWFSUCURSAL = B.JAQY142SUC
             AND A.XWFCUENTA = B.JAQY142CTA
             AND A.XWFOPERACION = B.JAQY142OPE
             AND A.XWFPRCINS = B.JAQY142INST
             AND A.XWFTIPOPE = B.JAQY142TOPE
             AND XWFPRCINS = instancia
             AND XWFCAR3 = '1'
             AND B.JAQY142EST = 'H'
             AND b.jaqy142tarea = 7;
        EXCEPTION
          WHEN OTHERS THEN
            xCredPropueAct := 0;
        END;
      
        xCredPropueAct := nvl(xCredPropueAct, 0);
      
      end if;
    end if;
  
    TipFlujCN := 'N';
    IF nroINTipoCN <> 2 THEN
      Indicflujo := 'NOR';
      BEGIN
        pq_cr_repo_opinion_riesgos.sp_obtner_Instanci_anterior(instancia,
                                                               Indicflujo,
                                                               auxInstanAnt,
                                                               fechAntOut,
                                                               TipFlujCN);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
    IF nroINTipoCN = 2 THEN
      --30042024
      auxInstanAnt := instancia;
    END IF;
  
    IF TipFlujCN = 'N' THEN
      begin
        select x.xwfmodulo
          into ln_ModInstAnt
          from xwf700 x
         where x.xwfprcins = auxInstanAnt
           and x.xwfcar3 = '1';
      exception
        when others then
          null;
      end;
    
      --Cred. Propuesto anterior
      xCredPropueAnt := 0;
      if ln_ModInstAnt <> 117 then
        BEGIN
          SELECT JAQY142CAPCUO
            INTO xCredPropueAnt
            FROM XWF700 A, JAQY142 B
           WHERE A.XWFEMPRESA = B.JAQY142PGCOD
             AND A.XWFSUCURSAL = B.JAQY142SUC
             AND A.XWFCUENTA = B.JAQY142CTA
             AND A.XWFOPERACION = B.JAQY142OPE
             AND A.XWFPRCINS = B.JAQY142INST
             AND A.XWFTIPOPE = B.JAQY142TOPE
             AND XWFPRCINS = auxInstanAnt
             AND XWFCAR3 = '1'
             AND B.JAQY142EST = 'H'
             AND B.JAQY142NRCUO > 1
             and (B.jaqy142mod not in
                 (select tp1nro1
                     from fst198 a
                    where a.tp1cod = 1
                      and a.tp1cod1 = 10899
                      and a.tp1corr1 = 13
                      and a.tp1corr2 = 1) and B.jaqy142mod not in 117)
             AND b.jaqy142tarea = 7;
        EXCEPTION
          WHEN OTHERS THEN
            xCredPropueAnt := 0;
        END;
      else
        if ln_ModInstAnt = 117 then
          BEGIN
            SELECT JAQY142CAPCUO
              INTO xCredPropueAnt
              FROM XWF700 A, JAQY142 B
             WHERE A.XWFEMPRESA = B.JAQY142PGCOD
               AND A.XWFSUCURSAL = B.JAQY142SUC
               AND A.XWFCUENTA = B.JAQY142CTA
               AND A.XWFOPERACION = B.JAQY142OPE
               AND A.XWFPRCINS = B.JAQY142INST
               AND A.XWFTIPOPE = B.JAQY142TOPE
               AND XWFPRCINS = auxInstanAnt
               AND XWFCAR3 = '1'
               AND B.JAQY142EST = 'H'
               AND b.jaqy142tarea = 7;
          EXCEPTION
            WHEN OTHERS THEN
              xCredPropueAnt := 0;
          END;
        
          xCredPropueAnt := nvl(xCredPropueAnt, 0);
        
        end if;
      end if;
    
    END IF;
  
    --Cred. Vigente actual
    xSumcuotaVigRec := 0;
    BEGIN
      SELECT SUM(JAQY142CAPCUO)
        INTO xSumcuotaVigRec
        FROM JAQY142 j
       WHERE j.JAQY142INST = instancia
         AND j.JAQY142EST = 'H'
         AND j.JAQY142INDIC IN ('CredVigent', 'CredVencid', 'LineaVencd')
         and (j.jaqy142mod not in
             (select tp1nro1
                 from fst198 a
                where a.tp1cod = 1
                  and a.tp1cod1 = 10899
                  and a.tp1corr1 = 13
                  and a.tp1corr2 = 1) and j.jaqy142mod not in 117) --mpostigoc 30.10.2023
         and j.jaqy142nrcuo > 1
         AND j.JAQY142TAREA = 7;
    EXCEPTION
      WHEN OTHERS THEN
        xSumcuotaVigRec := 0;
    END;
  
    IF TipFlujCN = 'N' THEN
      --Cred. Vigente anterior
      xSumcuotaVigAnter := 0;
      BEGIN
        SELECT SUM(JAQY142CAPCUO)
          INTO xSumcuotaVigAnter
          FROM JAQY142 j
         WHERE j.JAQY142INST = auxInstanAnt
           AND j.JAQY142EST = 'H'
           AND j.JAQY142INDIC IN ('CredVigent', 'CredVencid', 'LineaVencd')
           and (j.jaqy142mod not in
               (select tp1nro1
                   from fst198 a
                  where a.tp1cod = 1
                    and a.tp1cod1 = 10899
                    and a.tp1corr1 = 13
                    and a.tp1corr2 = 1) and j.jaqy142mod not in 117) --mpostigoc 30.10.2023
           and j.jaqy142nrcuo > 1
           AND j.JAQY142TAREA = 55; --
      EXCEPTION
        WHEN OTHERS THEN
          xSumcuotaVigAnter := 0;
      END;
    END IF;
  
    --Cred. Contingencia y potencial  
    xCredicContingAct := 0;
    xCredPotencAct    := 0;
    BEGIN
      select JAQY140CCONTG, JAQY140CPOTEN
        INTO xCredicContingAct, xCredPotencAct
        from jaqy140
       where JAQY140INST = instancia
         and JAQY140EST = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        xCredicContingAct := 0;
        xCredPotencAct    := 0;
    END;
  
    IF TipFlujCN = 'N' THEN
      --Cred. Contingencia anterior y  y potencial anterior 
      xCredicContingAnt := 0;
      xCredPotencAnt    := 0;
      BEGIN
        select JAQY140CCONTG, JAQY140CPOTEN
          INTO xCredicContingAnt, xCredPotencAnt
          from jaqy140
         where JAQY140INST = auxInstanAnt
           and JAQY140EST = 'H';
      EXCEPTION
        WHEN OTHERS THEN
          xCredicContingAnt := 0;
          xCredPotencAnt    := 0;
      END;
    END IF;
  
    IF TipFlujCN = 'C' THEN
      --EVAL anter es CRM
      nroOUTipoCN := 1;
      begin
        pq_cr_repo_opini_riesgos_CRM.sp_obtn_val_cred_pyme(auxInstanAnt,
                                                           nroOUTipoCN,
                                                           crm_xCredPropueAct,
                                                           crm_xCredPropueAnt,
                                                           crm_xSumcuotaVigRec,
                                                           crm_xSumcuotaVigAnter,
                                                           crm_xCredicContingAct,
                                                           crm_xCredicContingAnt,
                                                           crm_xCredPotencAct,
                                                           crm_xCredPotencAnt);
        /* Exception 
        when others then
          null;    
        */
      end;
    
      xCredPropueAnt    := crm_xCredPropueAnt;
      xSumcuotaVigAnter := crm_xSumcuotaVigAnter;
      xCredicContingAnt := crm_xCredicContingAnt;
      xCredPotencAnt    := crm_xCredPotencAnt;
    
    END IF;
  
  END;

  PROCEDURE sp_grab_log_aqpc156(codOpinion number, instancia number) IS
    CURSOR LOG_156(codopi number) IS
      SELECT *
        FROM AQPC156
       WHERE AQPC156CODOPI = codopi --07112023
         AND AQPC156INSTAN = INSTANCIA
         AND AQPC156ESTAD = 'H'
         AND AQPC156ESTOP <> 'T'; --07112023
  
    v_correlativo NUMBER(5);
    v_codOpinion  number(10);
    v_NewCorrel   NUMBER(5);
  
  BEGIN
    IF codOpinion = 0 OR codOpinion IS NULL THEN
      BEGIN
        SELECT MAX(AQPC156CODOPI)
          INTO v_codOpinion
          FROM AQPC156
         WHERE AQPC156INSTAN = INSTANCIA
           AND AQPC156ESTAD = 'H';
      EXCEPTION
        WHEN OTHERS THEN
          v_codOpinion := 0;
      END;
    ELSE
      v_codOpinion := codOpinion;
    END IF;
  
    -- 2108
    BEGIN
      SELECT MAX(AQPC156CORR)
        INTO v_correlativo
        FROM AQPC156
       WHERE AQPC156CODOPI = v_codOpinion
         AND AQPC156INSTAN = INSTANCIA;
    EXCEPTION
      WHEN OTHERS THEN
        v_correlativo := 0;
    END;
    IF v_correlativo IS NULL THEN
      v_correlativo := 0;
    END IF;
  
    v_NewCorrel := v_correlativo + 1;
  
    FOR ln IN LOG_156(v_codOpinion) LOOP
      --07112023
      BEGIN
        INSERT INTO AQPC156
          (AQPC156CODOPI,
           AQPC156FECPRO,
           AQPC156INSTAN,
           AQPC156A,
           AQPC156DE,
           AQPC156ASUNT,
           AQPC156TEXCOM,
           AQPC156CLIEN,
           AQPC156DNI,
           AQPC156ANALIS,
           AQPC156AGENC,
           AQPC156ZONA,
           AQPC156REGIO,
           AQPC156RATGANA,
           AQPC156RATAGEN,
           AQPC156SLDCANA,
           AQPC156SLDCAGE,
           AQPC156SLDCZON,
           AQPC156SLDCREG,
           AQPC156NCLIANA,
           AQPC156NCLIAGE,
           AQPC156NCLIZON,
           AQPC156NCLIREG,
           AQPC156NMORAG,
           AQPC156NMORAN,
           AQPC156NMORZO,
           AQPC156NMOREG,
           AQPC156NVRIESG,
           AQPC156ACTIVID,
           AQPC156PDANA,
           AQPC156PDAGE,
           AQPC156PDZON,
           AQPC156PDREG,
           AQPC156COH4ANA,
           AQPC156COH4AGE,
           AQPC156COH4ZON,
           AQPC156COH4REG,
           AQPC156COH6ANA,
           AQPC156COH6AGE,
           AQPC156COH6ZON,
           AQPC156COH6REG,
           AQPC156SOLIC,
           AQPC156CTNRO,
           AQPC156CALIF,
           AQPC156PRODSBS,
           AQPC156FECEEFF,
           AQPC156FECINFC,
           AQPC156CODTPRO,
           AQPC156TIPPRO,
           AQPC156RESPTOT,
           AQPC156SLDPROP,
           AQPC156MODPRP,
           AQPC156CUOTAS,
           AQPC156CUOPRP,
           AQPC156TASPRP,
           AQPC156TIPSOL,
           AQPC156DETISOL,
           AQPC156ESTOP,
           AQPC156HORRG,
           AQPC156USUREG,
           AQPC156GRAGE,
           AQPC156ANSERIG,
           AQPC156USRDER,
           AQPC156FECDEL,
           AQPC156NIVEL,
           AQPC156AUX1,
           AQPC156AUX2,
           AQPC156AUX3,
           AQPC156AUX4,
           AQPC156ACTCONT,
           AQPC156SUPADMI,
           AQPC156JEFADMI,
           AQPC156GERRIES,
           AQPC156NRECONS,
           AQPC156ESRECON,
           AQPC156ESTAD,
           AQPC156CORR,
           AQPC156TCAMB,
           AQPC156MDAPROP)
        VALUES
          (ln.AQPC156CODOPI,
           TO_DATE(SYSDATE, 'dd/mm/rrrr'),
           ln.AQPC156INSTAN,
           ln.AQPC156A,
           ln.AQPC156DE,
           ln.AQPC156ASUNT,
           ln.AQPC156TEXCOM,
           ln.AQPC156CLIEN,
           ln.AQPC156DNI,
           ln.AQPC156ANALIS,
           ln.AQPC156AGENC,
           ln.AQPC156ZONA,
           ln.AQPC156REGIO,
           ln.AQPC156RATGANA,
           ln.AQPC156RATAGEN,
           ln.AQPC156SLDCANA,
           ln.AQPC156SLDCAGE,
           ln.AQPC156SLDCZON,
           ln.AQPC156SLDCREG,
           ln.AQPC156NCLIANA,
           ln.AQPC156NCLIAGE,
           ln.AQPC156NCLIZON,
           ln.AQPC156NCLIREG,
           ln.AQPC156NMORAG,
           ln.AQPC156NMORAN,
           ln.AQPC156NMORZO,
           ln.AQPC156NMOREG,
           ln.AQPC156NVRIESG,
           ln.AQPC156ACTIVID,
           ln.AQPC156PDANA,
           ln.AQPC156PDAGE,
           ln.AQPC156PDZON,
           ln.AQPC156PDREG,
           ln.AQPC156COH4ANA,
           ln.AQPC156COH4AGE,
           ln.AQPC156COH4ZON,
           ln.AQPC156COH4REG,
           ln.AQPC156COH6ANA,
           ln.AQPC156COH6AGE,
           ln.AQPC156COH6ZON,
           ln.AQPC156COH6REG,
           ln.AQPC156SOLIC,
           ln.AQPC156CTNRO,
           ln.AQPC156CALIF,
           ln.AQPC156PRODSBS,
           ln.AQPC156FECEEFF,
           ln.AQPC156FECINFC,
           ln.AQPC156CODTPRO,
           ln.AQPC156TIPPRO,
           ln.AQPC156RESPTOT,
           ln.AQPC156SLDPROP,
           ln.AQPC156MODPRP,
           ln.AQPC156CUOTAS,
           ln.AQPC156CUOPRP,
           ln.AQPC156TASPRP,
           ln.AQPC156TIPSOL,
           ln.AQPC156DETISOL,
           ln.AQPC156ESTOP,
           to_char(SYSDATE, 'HH24:MI:SS'), --ln.AQPC156HORRG   ,
           ln.AQPC156USUREG,
           ln.AQPC156GRAGE,
           ln.AQPC156ANSERIG,
           ln.AQPC156USRDER,
           ln.AQPC156FECDEL,
           ln.AQPC156NIVEL,
           ln.AQPC156AUX1,
           ln.AQPC156AUX2,
           ln.AQPC156AUX3,
           ln.AQPC156AUX4,
           ln.AQPC156ACTCONT,
           ln.AQPC156SUPADMI,
           ln.AQPC156JEFADMI,
           ln.AQPC156GERRIES,
           ln.AQPC156NRECONS,
           ln.AQPC156ESRECON,
           ln.AQPC156ESTAD,
           v_NewCorrel,
           ln.aqpc156tcamb,
           ln.aqpc156mdaprop);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;
  
    --Actualizar de H a I 
    IF v_correlativo > 0 THEN
      BEGIN
        UPDATE AQPC156
           SET AQPC156ESTAD = 'I'
         WHERE AQPC156CODOPI =
               (SELECT (MAX(B.AQPC156CODOPI))
                  FROM AQPC156 B
                 WHERE B.AQPC156INSTAN = instancia) --18/12/2023
           AND AQPC156INSTAN = INSTANCIA
           AND AQPC156ESTAD = 'H'
           AND AQPC156CORR = v_correlativo;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
  END;

  PROCEDURE sp_grab_coment_observ(CodOpinion   number, --07112023
                                  instancia    number,
                                  NivelAprob   number,
                                  usuario      varchar2,
                                  ComentObserv varchar2,
                                  resptObser   out varchar2) IS
    fechaActual Date;
    HoraActu    varchar2(10);
    flgEstObser varchar2(1);
  BEGIN
    resptObser := 'N';
  
    IF ComentObserv IS NOT NULL AND ComentObserv <> ' ' THEN
      --IF resptObser = 'S' THEN
      pq_cr_repo_opinion_riesgos.sp_grab_log_aqpc171(CodOpinion, instancia);
    
      BEGIN
        UPDATE AQPC171
           SET AQPC171MOTOBSV = ComentObserv
         WHERE AQPC171CODOPI = CodOpinion
           AND AQPC171INST = instancia
           AND AQPC171ESTAD = 'H';
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      fechaActual := to_date(sysdate, 'dd/MM/RRRR');
      HoraActu    := TO_CHAR(SYSDATE, 'HH24:MI:SS');
      flgEstObser := 'N';
      BEGIN
        --22012024
        SELECT 'S'
          INTO flgEstObser
          FROM AQPC156 A
         WHERE AQPC156CODOPI = CodOpinion
           AND AQPC156INSTAN = instancia
           AND AQPC156ESTAD = 'H'
           AND AQPC156ESTOP = 'O';
      EXCEPTION
        WHEN OTHERS THEN
          flgEstObser := 'N';
      END;
    
      IF flgEstObser = 'N' THEN
        ---Guardar en la aqpc801
        pq_cr_repo_opinion_riesgos.sp_grabarLogEstadoOpinion(codOpinion   => CodOpinion,
                                                             fechaActual  => fechaActual,
                                                             Hora         => HoraActu,
                                                             UsuarioEjec  => usuario,
                                                             codCadena    => NivelAprob, --3, 18112024
                                                             estadoActual => 'O');
      
        /*pq_cr_repo_opinion_riesgos.sp_actualizarEstado156(intancia   => instancia,
        codOpinion => CodOpinion,
        FlgEstado  => 'O');*/
        --IF TRIM(ComentObserv) IS NOT NULL AND ComentObserv <> '' THEN--OR ComentObserv <> NULL THEN--2710                                                    
        begin
          UPDATE AQPC156
             SET AQPC156ESTOP = 'O'
           WHERE AQPC156CODOPI = CodOpinion
             AND AQPC156INSTAN = instancia
             AND AQPC156ESTAD = 'H';
          COMMIT;
        exception
          when others then
            null;
        end;
      END IF;
    
      resptObser := 'S';
    ELSE
      flgEstObser := 'N';
      BEGIN
        SELECT 'S'
          INTO flgEstObser
          FROM AQPC156 A
         WHERE AQPC156CODOPI = CodOpinion
           AND AQPC156INSTAN = instancia
           AND AQPC156ESTAD = 'H'
           AND AQPC156ESTOP = 'O';
      EXCEPTION
        WHEN OTHERS THEN
          flgEstObser := 'N';
      END;
    
      IF flgEstObser = 'S' THEN
        pq_cr_repo_opinion_riesgos.sp_grab_log_aqpc171(CodOpinion,
                                                       instancia);
      
        BEGIN
          UPDATE AQPC171
             SET AQPC171MOTOBSV = ComentObserv
           WHERE AQPC171CODOPI = CodOpinion
             AND AQPC171INST = instancia
             AND AQPC171ESTAD = 'H';
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        resptObser := 'S';
      END IF;
    END IF;
  
  END;

  PROCEDURE sp_grab_log_aqpc171(codOpinion number, instancia number) is
    v_NewCorrelativo number(10);
    v_CorrActual     number(10);
    fechaActual      date;
    HoraActu         varchar2(10);
  
    CURSOR data_aqpc171 IS
      SELECT *
        FROM AQPC171
       WHERE AQPC171CODOPI = codOpinion
         AND AQPC171INST = instancia
         AND AQPC171ESTAD = 'H'
         AND ROWNUM = 1;
  BEGIN
    fechaActual  := to_date(sysdate, 'dd/MM/RRRR');
    HoraActu     := TO_CHAR(SYSDATE, 'HH24:MI:SS');
    v_CorrActual := 0;
  
    FOR ln in data_aqpc171 LOOP
      v_CorrActual     := ln.aqpc171corr;
      v_NewCorrelativo := v_CorrActual + 1;
      BEGIN
        INSERT INTO AQPC171
          (AQPC171CODOPI,
           AQPC171CORR,
           AQPC171USUR,
           AQPC171FECPRO,
           AQPC171INST,
           AQPC171CARGO,
           AQPC171ANCNEG,
           AQPC171ANVIC,
           AQPC171FCN,
           AQPC171AESFCC,
           AQPC171RDCLN,
           AQPC171ANCP,
           AQPC171ANCPG,
           AQPC171DANDC,
           AQPC171DGCOR,
           AQPC171RANCNEG,
           AQPC171MTREP,
           AQPC171RAESFCC,
           AQPC171ANCPRF,
           AQPC171ANVPG,
           AQPC171DEGV,
           AQPC171RFANCNE,
           AQPC171MTREFN,
           AQPC171RFAESFC,
           AQPC171RFANCPR,
           AQPC171RFANVPG,
           AQPC171RFDEGV,
           AQPC171USURAR,
           AQPC171COMEN,
           AQPC171RESOL,
           AQPC171CONREC,
           AQPC171ARGRECO,
           AQPC171ANACOME,
           AQPC171RESOLRE,
           AQPC171CONDREC,
           AQPC171HORAREG,
           AQPC171ESTAD,
           AQPC171MOTOBSV)
        VALUES
          (ln.AQPC171CODOPI,
           v_NewCorrelativo,
           ln.AQPC171USUR,
           fechaActual,
           ln.AQPC171INST,
           ln.AQPC171CARGO,
           ln.AQPC171ANCNEG,
           ln.AQPC171ANVIC,
           ln.AQPC171FCN,
           ln.AQPC171AESFCC,
           ln.AQPC171RDCLN,
           ln.AQPC171ANCP,
           ln.AQPC171ANCPG,
           ln.AQPC171DANDC,
           ln.AQPC171DGCOR,
           ln.AQPC171RANCNEG,
           ln.AQPC171MTREP,
           ln.AQPC171RAESFCC,
           ln.AQPC171ANCPRF,
           ln.AQPC171ANVPG,
           ln.AQPC171DEGV,
           ln.AQPC171RFANCNE,
           ln.AQPC171MTREFN,
           ln.AQPC171RFAESFC,
           ln.AQPC171RFANCPR,
           ln.AQPC171RFANVPG,
           ln.AQPC171RFDEGV,
           ln.AQPC171USURAR,
           ln.AQPC171COMEN,
           ln.AQPC171RESOL,
           ln.AQPC171CONREC,
           ln.AQPC171ARGRECO,
           ln.AQPC171ANACOME,
           ln.AQPC171RESOLRE,
           ln.AQPC171CONDREC,
           HoraActu,
           'H',
           ln.AQPC171MOTOBSV);
      END;
      COMMIT;
    END LOOP;
  
    --Actualizar de H a I 
    IF v_CorrActual > 0 THEN
      BEGIN
        UPDATE AQPC171
           SET AQPC171ESTAD = 'I'
         WHERE AQPC171CODOPI = codOpinion
           AND AQPC171INST = INSTANCIA
           AND AQPC171ESTAD = 'H'
           AND AQPC171CORR = v_CorrActual;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
  END;

  PROCEDURE sp_datos_opinion(instancia    number,
                             nivelPerfil  out number,
                             flgExiste    out varchar2,
                             UsuarioDeriv out varchar2) is --07112023
  BEGIN
    flgExiste := 'N'; --14/11/2023
    BEGIN
      SELECT A.AQPC156NIVEL,
             'S', --(CASE A.AQPC156NIVEL 
             --WHEN 1 THEN A.AQPC156USUREG
             --WHEN 2 THEN A.AQPC156GRAGE
             --WHEN 3 THEN A.AQPC156ANSERIG
             --ELSE 
             A.AQPC156USRDER AS AnaliDerivado
      --END) 
        INTO nivelPerfil, flgExiste, UsuarioDeriv
        FROM AQPC156 A
       WHERE --07112023
       A.AQPC156CODOPI = (SELECT (MAX(B.AQPC156CODOPI))
                            FROM AQPC156 B
                           WHERE B.AQPC156INSTAN = instancia
                             AND B.AQPC156ESTAD = 'H')
       AND A.AQPC156INSTAN = instancia
       AND A.AQPC156ESTAD = 'H'
       AND AQPC156ESTOP <> 'T'; -- 28112023;
    EXCEPTION
      WHEN OTHERS THEN
        nivelPerfil  := 0; --14/11/2023
        flgExiste    := 'N';
        UsuarioDeriv := '';
    END;
  END;

  PROCEDURE sp_datos_reconsideracion(instancia     number,
                                     nroreconsider out number,
                                     estdOpini     out varchar2,
                                     p_nivelAproba out number,
                                     p_flg         out varchar2) is
    --21022024
    v_codOpinion number(10);
    v_maxCorrEst number(5);
    v_estd801    varchar2(2);
  BEGIN
    BEGIN
      SELECT W.AQPC156NRECONS,
             W.AQPC156ESTOP,
             w.AQPC156NIVEL,
             w.aqpc156codopi
        INTO nroreconsider, estdOpini, p_nivelAproba, v_codOpinion
        FROM AQPC156 W
       WHERE W.AQPC156CODOPI =
             (SELECT (MAX(B.AQPC156CODOPI))
                FROM AQPC156 B
               WHERE B.AQPC156INSTAN = instancia
                 AND B.AQPC156ESTAD = 'H')
         AND W.AQPC156INSTAN = instancia
         AND W.AQPC156ESTAD = 'H'
         AND AQPC156ESTOP <> 'T'; -- 28112023;
    EXCEPTION
      WHEN OTHERS THEN
        nroreconsider := 0;
        estdOpini     := '';
        p_nivelAproba := 0;
    END;
    p_nivelAproba := nvl(p_nivelAproba, 0);
    v_codOpinion  := nvl(v_codOpinion, 0);
  
    --validar si existe R o O en aqpc801 para no insertar nuevamente R
    BEGIN
      SELECT MAX(AQPC801AUX1)
        into v_maxCorrEst
        FROM AQPC801
       WHERE AQPC801CODOPI = v_codOpinion
         and TRIM(AQPC801ESTDA) <> 'P';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    v_maxCorrEst := NVL(v_maxCorrEst, 0);
  
    BEGIN
      SELECT AQPC801ESTDA
        INTO v_estd801
        FROM AQPC801
       WHERE AQPC801CODOPI = v_codOpinion
         and AQPC801AUX1 = v_maxCorrEst;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    p_flg := 'N';
    IF v_estd801 = 'NV' THEN
      p_flg := 'S';
    END IF;
  END;

  PROCEDURE sp_valid_dias_proce_solici_nuev(instancia number,
                                            flgRpta   out varchar2) IS
    --06/12/2023
    DiasHabilGenOpi NUMBER(7);
    FechaActual     DATE;
    DifernDias      NUMBER(7);
    FlgExisFecha    varchar2(1);
    FecInicOpíni    date;
  BEGIN
    --Buscar fecha de proceso de la solicitud 
    FlgExisFecha := 'N';
    BEGIN
      SELECT 'S', AQPC156AUX3
        INTO FlgExisFecha, FecInicOpíni
        FROM AQPC156
       WHERE AQPC156CODOPI =
             (SELECT MAX(AQPC156CODOPI)
                FROM AQPC156
               WHERE AQPC156INSTAN = instancia)
         AND AQPC156INSTAN = instancia
         AND AQPC156ESTAD = 'H'; --2108       
      --AND AQPC156NIVEL > 1; -- comment 18112024
    EXCEPTION
      when OTHERS THEN
        FlgExisFecha := 'N';
    END;
  
    ---buscar guia para volver a gestionar la solicitud despues de 30 dias
    DiasHabilGenOpi := 0;
    BEGIN
      SELECT TP1NRO3
        INTO DiasHabilGenOpi
        FROM fst198
       where tp1cod1 = 11152
         and TP1CORR1 = 53
         and tp1corr2 = 2
         AND TP1CORR3 = 1;
    EXCEPTION
      when OTHERS THEN
        DiasHabilGenOpi := 0;
    END;
  
    DifernDias := 0;
    IF FlgExisFecha = 'S' THEN
      BEGIN
        --Fecha actual
        SELECT PGFAPE INTO FechaActual FROM FST017 WHERE PGCOD = 1;
      EXCEPTION
        when OTHERS THEN
          FechaActual := TO_DATE(SYSDATE);
      END;
    
      DifernDias := 0;
      BEGIN
        SELECT (TO_DATE(FechaActual, 'dd/mm/yyyy') -
               TO_DATE(FecInicOpíni, 'dd/mm/yyyy'))
          INTO DifernDias
          FROM DUAL;
      EXCEPTION
        when OTHERS THEN
          DifernDias := 0;
      END;
    END IF;
  
    IF DifernDias >= DiasHabilGenOpi THEN
      flgRpta := 'S';
    ELSE
      flgRpta := 'N';
    END IF;
  END;

  ---------------------------------------------------------------------------------------------------------
  PROCEDURE sp_buscar_usu_derivar_perfil(flujo            number,
                                         codOpinion       number,
                                         instancia        number,                       
                                         p_Perfil         varchar2,
                                         p_usuarioIngreso varchar2,       --10012025 
                                         p_nivelUsuIng    number,                  
                                         p_UsuarioDerivar out varchar2,
                                         p_nivelADerivar  out number ) IS
    --21022024  
    FechaHoy          DATE;
    v_UsuaParaDerivar varchar2(10);
    v_UsuaSuplenc     varchar2(10);
    v_esActivo        number(9);
    codArbolAuton     number(4);
    v_codUsuDerivado  number(17,2);    
    v_tp1desc         varchar2(30);
    x_perfil          varchar2(10);
    x_guianiv         number(4);
    x_exis156         varchar2(1);
    v_usuarioGestion  varchar2(10);
    v_guiaNivelUsuGestion number(1);
    
  
    CURSOR v_ListUsuPerfil(fechaAct date, var_perfil varchar2) is
      SELECT Ubuser as Usuario
        FROM PRFU00
       WHERE Pgcod = 1
         AND PrfGCod = rpad(var_perfil, 10, ' ')
         AND PrfUFecAlt <= fechaAct
         And PrfUFecVto >= fechaAct;
  
  BEGIN
    BEGIN
      SELECT PGFAPE INTO FechaHoy FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    ----
    x_exis156 := 'N'; 
    v_usuarioGestion := '';
    IF flujo = 1 THEN
        BEGIN
           SELECT AQPC156ANSERIG, 'S' 
              INTO v_usuarioGestion, x_exis156  
              FROM AQPC156 W
             WHERE W.AQPC156CODOPI = codOpinion
               AND W.AQPC156INSTAN = instancia
               AND W.AQPC156ESTAD = 'H'
               AND AQPC156ESTOP <> 'T';
        EXCEPTION
          WHEN OTHERS THEN
            x_exis156 := 'N'; 
            v_usuarioGestion := '';          
        END;
    ELSE
      IF flujo = 2 THEN
        BEGIN
           SELECT AQPC818ANSERIG, 'S' 
              INTO v_usuarioGestion, x_exis156  
              FROM AQPC818 W
             WHERE W.AQPC818CODOPI = codOpinion
               AND W.AQPC818INSTAN = instancia
               AND W.AQPC818ESTAD = 'H'
               AND W.AQPC818ESTOP <> 'T';
        EXCEPTION
          WHEN OTHERS THEN
            x_exis156 := 'N'; 
            v_usuarioGestion := '';
        END;          
      END IF;
    END IF;
    
    IF x_exis156 = 'N' THEN
       v_usuarioGestion := p_usuarioIngreso;
    END IF;
    
    v_codUsuDerivado := 0;
    IF p_Perfil IS NULL OR TRIM(p_Perfil) = '' OR p_Perfil = ' ' THEN --10012025  
       
       BEGIN
          select TP1NRO2 codAutonomia, TP1IMP1 guiaNivelUsuGestion into codArbolAuton, v_guiaNivelUsuGestion from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 9 and tp1corr3 > 0 and tp1desc = rpad(v_usuarioGestion, 30, ' ');
       EXCEPTION
          WHEN OTHERS THEN
            codArbolAuton := 0;
       END; 
       
       codArbolAuton := nvl(codArbolAuton, 0);
       
       IF v_guiaNivelUsuGestion = 1 THEN   ---ETAPA 1        
               IF p_nivelUsuIng = 1 THEN
                 BEGIN
                      select tp1nro2 into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro1 = codArbolAuton ;
                   EXCEPTION
                      WHEN OTHERS THEN
                        NULL;         
                 END;
               END IF;       
               v_codUsuDerivado := nvl(v_codUsuDerivado, 0);
               IF (v_codUsuDerivado = 0 AND p_nivelUsuIng < 3)  OR p_nivelUsuIng = 2 THEN
                  BEGIN
                      select tp1nro3 into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro1 = codArbolAuton ;
                   EXCEPTION
                      WHEN OTHERS THEN
                        NULL;         
                 END;               
               END IF;
               
               IF p_nivelUsuIng = 3 THEN
                  BEGIN
                      select tp1IMP1 into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro1 = codArbolAuton ;
                   EXCEPTION
                      WHEN OTHERS THEN
                        NULL;         
                 END;               
               END IF;   
               
               IF p_nivelUsuIng = 4 THEN
                  BEGIN
                      select tp1IMP2 into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro1 = codArbolAuton ;
                   EXCEPTION
                      WHEN OTHERS THEN
                        NULL;         
                 END;               
               END IF;      
               
               IF p_nivelUsuIng = 5 THEN
                  BEGIN
                      select tp1IMP3 into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro1 = codArbolAuton ;
                   EXCEPTION
                      WHEN OTHERS THEN
                        NULL;         
                 END;               
               END IF;   
       END IF;        
       
       IF v_guiaNivelUsuGestion = 2 THEN  ---ETAPA 2
                /* IF p_nivelUsuIng = 1 THEN
                 BEGIN
                      select tp1nro2 into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro1 = codArbolAuton ;
                   EXCEPTION
                      WHEN OTHERS THEN
                        NULL;         
                 END;
               END IF;       */
               v_codUsuDerivado := nvl(v_codUsuDerivado, 0);
               IF (v_codUsuDerivado = 0 AND p_nivelUsuIng < 3)  OR p_nivelUsuIng = 2 THEN
                  BEGIN
                      select tp1nro3 into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro2 = codArbolAuton and tp1nro1 = 0 ;
                   EXCEPTION
                      WHEN OTHERS THEN
                        NULL;         
                 END;               
               END IF;
               
               IF p_nivelUsuIng = 3 THEN
                  BEGIN
                      select tp1IMP1 into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro2 = codArbolAuton and tp1nro1 = 0;
                   EXCEPTION
                      WHEN OTHERS THEN
                        NULL;         
                 END;               
               END IF;   
               
               IF p_nivelUsuIng = 4 THEN
                  BEGIN
                      select tp1IMP2 into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro2 = codArbolAuton and tp1nro1 = 0;
                   EXCEPTION
                      WHEN OTHERS THEN
                        NULL;         
                 END;               
               END IF;      
               
               IF p_nivelUsuIng = 5 THEN
                  BEGIN
                      select tp1IMP3 into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro2 = codArbolAuton and tp1nro1 = 0;
                   EXCEPTION
                      WHEN OTHERS THEN
                        NULL;         
                 END;               
               END IF; 
       END IF;

       IF v_guiaNivelUsuGestion = 3 THEN  ---ETAPA 3
                /* IF p_nivelUsuIng = 1 THEN
                 BEGIN
                      select tp1nro2 into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro1 = codArbolAuton ;
                   EXCEPTION
                      WHEN OTHERS THEN
                        NULL;         
                 END;
               END IF;   
              
               IF (v_codUsuDerivado = 0 AND p_nivelUsuIng < 3)  OR p_nivelUsuIng = 2 THEN
                  BEGIN
                      select tp1nro3 into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro2 = codArbolAuton ;
                   EXCEPTION
                      WHEN OTHERS THEN
                        NULL;         
                 END;               
               END IF;    */
                v_codUsuDerivado := nvl(v_codUsuDerivado, 0);
               IF p_nivelUsuIng = 3 THEN
                  BEGIN
                      select tp1IMP1 into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro3 = codArbolAuton and tp1nro2 = 0 and tp1nro1 = 0;
                   EXCEPTION
                      WHEN OTHERS THEN
                        NULL;         
                 END;               
               END IF;   
               
               IF p_nivelUsuIng = 4 THEN
                  BEGIN
                      select tp1IMP2 into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro3 = codArbolAuton and tp1nro2 = 0 and tp1nro1 = 0;
                   EXCEPTION
                      WHEN OTHERS THEN
                        NULL;         
                 END;               
               END IF;      
               
               IF p_nivelUsuIng = 5 THEN
                  BEGIN
                      select tp1IMP3 into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro3 = codArbolAuton and tp1nro2 = 0 and tp1nro1 = 0;
                   EXCEPTION
                      WHEN OTHERS THEN
                        NULL;         
                 END;               
               END IF;                                            
       END IF;
       /*CASE 
       WHEN p_nivelUsuIng = 1 THEN
         BEGIN
            select DECODE(tp1nro1, codArbolAuton, decode(tp1nro2, 0, decode(tp1nro3, 0, decode(tp1imp1, 0, decode(tp1imp2, 0, tp1imp3, tp1imp2), tp1imp1), tp1nro3), tp1nro2)) into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro1 = codArbolAuton ;
         EXCEPTION
            WHEN OTHERS THEN
              NULL;         
         END;
       WHEN p_nivelUsuIng = 2 THEN
         BEGIN
            select DECODE(tp1nro2, codArbolAuton, decode(tp1nro3, 0, decode(tp1imp1, 0, decode(tp1imp2, 0, tp1imp3, tp1imp2), tp1imp1), tp1nro3), tp1nro2) into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro1 = codArbolAuton ;
         EXCEPTION
            WHEN OTHERS THEN
              NULL;         
         END;           
       WHEN p_nivelUsuIng = 3 THEN
         BEGIN
            select DECODE(tp1nro3, codArbolAuton, decode(tp1imp1, 0, decode(tp1imp2, 0, tp1imp3, tp1imp2), tp1imp1), tp1nro3) into v_codUsuDerivado from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 10 and tp1nro1 = codArbolAuton ;
         EXCEPTION
            WHEN OTHERS THEN
              NULL;         
         END;                  
       END CASE; */
       
       v_codUsuDerivado := nvl(v_codUsuDerivado, 0);
       
       --buscar usuario derivar
       BEGIN
          select TP1DESC, TP1IMP1 into v_tp1desc, p_nivelADerivar from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 11 and Tp1corr2 = 9 and tp1corr3 > 0 and tp1nro3 = v_codUsuDerivado;
       EXCEPTION
          WHEN OTHERS THEN
            v_tp1desc := '';
            p_nivelADerivar := 0;
       END; 
       
       
       p_UsuarioDerivar := trim(v_tp1desc);      
       p_nivelADerivar  := nvl(p_nivelADerivar, 0);   
       
       ------validar si tiene suplencia
      /* BEGIN
            select SNG057SUP
              INTO v_UsuaSuplenc
              from sng057
             WHERE SNG055EMP = 1
               AND SNG057USR = RPAD(p_UsuarioDerivar, 10, ' ')
               AND SNG057INI <= FechaHoy
               AND SNG057FIN >= FechaHoy
               AND SNG057AUT = 'S';
          EXCEPTION
            WHEN OTHERS THEN
              v_UsuaSuplenc := ' ';
       END;
      
       v_UsuaSuplenc := NVL(v_UsuaSuplenc, NULL);
       v_UsuaSuplenc := TRIM(v_UsuaSuplenc);
              
       IF v_UsuaSuplenc IS NOT NULL THEN
          p_UsuarioDerivar := v_UsuaSuplenc;                          
       END IF; */
                
    END IF;          
    
  
  END;

  ----------------------------------------------------------------------------------------------------------------

  PROCEDURE sp_actuali_fecha_reconsideracion(instancia    number,
                                             xFlujo       number,
                                             p_usuarioEje varchar2) IS
    v_Max_codOpin  number(10);
    v_fecha_actual date;
    v_hora         varchar2(10);
    v_concFech     varchar2(100);
    v_flgOk        varchar2(1);
    p_nivelAproba  number;
  BEGIN
    BEGIN
      SELECT PGFAPE INTO v_fecha_actual FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        v_fecha_actual := to_date(Sysdate, 'dd/mm/rrrr');
    END;
  
    v_hora := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  
    v_concFech := to_char(v_fecha_actual, 'dd/MM/YYYY') || ' ' || v_hora;
    v_flgOk    := 'N';
    IF xFlujo = 1 THEN
      --FLUJO NORMAL
      BEGIN
        SELECT MAX(AQPC156CODOPI)
          INTO v_Max_codOpin
          FROM AQPC156
         WHERE AQPC156INSTAN = instancia
           AND AQPC156ESTAD = 'H';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      v_Max_codOpin := NVL(v_Max_codOpin, 0);
    
      --18112024
      BEGIN
        SELECT w.AQPC156NIVEL
          INTO p_nivelAproba
          FROM AQPC156 W
         WHERE W.AQPC156CODOPI = v_Max_codOpin
           AND W.AQPC156INSTAN = instancia
           AND W.AQPC156ESTAD = 'H'
           AND AQPC156ESTOP <> 'T';
      EXCEPTION
        WHEN OTHERS THEN
          p_nivelAproba := 0;
      END;
      p_nivelAproba := nvl(p_nivelAproba, 0);
      ----------                    
    
      BEGIN
        UPDATE AQPC156 A
           SET AQPC156AUX2 = v_concFech, AQPC156ESRECON = 'S'
         WHERE A.AQPC156CODOPI = v_Max_codOpin
           AND A.AQPC156INSTAN = instancia
           AND AQPC156ESTAD = 'H'; -- AND AQPC156AUX2 IS NULL; 
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
    IF xFlujo = 2 THEN
      --FLUJO CRM
      BEGIN
        SELECT MAX(AQPC818CODOPI)
          INTO v_Max_codOpin
          FROM AQPC818
         WHERE AQPC818INSTAN = instancia
           AND AQPC818ESTAD = 'H';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      v_Max_codOpin := NVL(v_Max_codOpin, 0);
    
      --18112024
      BEGIN
        SELECT w.AQPC818NIVEL
          INTO p_nivelAproba
          FROM AQPC818 W
         WHERE W.AQPC818CODOPI = v_Max_codOpin
           AND W.AQPC818INSTAN = instancia
           AND W.AQPC818ESTAD = 'H'
           AND w.AQPC818ESTOP <> 'T';
      EXCEPTION
        WHEN OTHERS THEN
          p_nivelAproba := 0;
      END;
      p_nivelAproba := nvl(p_nivelAproba, 0);
    
      BEGIN
        UPDATE AQPC818 A
           SET AQPC818AUX2 = v_concFech, AQPC818ESRECON = 'S'
         WHERE A.AQPC818CODOPI = v_Max_codOpin
           AND A.AQPC818INSTAN = instancia
           AND AQPC818ESTAD = 'H'
           AND A.AQPC818AUX3 = v_fecha_actual;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
    END IF;
  
    --grabr estaod R en aqpc801 para repor excel se vizsualice en estado pendiente
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_grabarLogEstadoOpinion(codOpinion   => v_Max_codOpin,
                                                           fechaActual  => v_fecha_actual,
                                                           Hora         => v_hora,
                                                           UsuarioEjec  => p_usuarioEje,
                                                           codCadena    => p_nivelAproba, --18112024
                                                           estadoActual => 'R');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  END;

  PROCEDURE sp_grbar_estado_aqpc801(p_CodOpinion      number,
                                    p_FechaHoy        DATE,
                                    p_hora            varchar2,
                                    p_UsuarioActual   varchar2,
                                    p_NivelActual     number,
                                    p_flgEstadoActual varchar2,
                                    p_UsuarioDerivado varchar2,
                                    p_CodNivelDerivar number,
                                    p_flgReq2regis801 varchar2) IS
  BEGIN
    --grabar log usuario aprobador
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_grabarLogEstadoOpinion(codOpinion   => p_CodOpinion,
                                                           fechaActual  => p_FechaHoy,
                                                           Hora         => p_hora,
                                                           UsuarioEjec  => p_UsuarioActual,
                                                           codCadena    => p_NivelActual,
                                                           estadoActual => p_flgEstadoActual);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    --grabar log usuario q fue derivado
    IF p_flgReq2regis801 = 'S' THEN
      BEGIN
        pq_cr_repo_opinion_riesgos.sp_grabarLogEstadoOpinion(codOpinion   => p_CodOpinion,
                                                             fechaActual  => p_FechaHoy,
                                                             Hora         => p_hora,
                                                             UsuarioEjec  => p_UsuarioDerivado,
                                                             codCadena    => p_CodNivelDerivar,
                                                             estadoActual => 'P');
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
  END;

  PROCEDURE sp_drop_reg_expedig(p_ndoc varchar2, p_instancia number) IS
    X_JAQM22CEXP VARCHAR2(50);
  BEGIN
    X_JAQM22CEXP := NULL;
    BEGIN
      select JAQM22CEXP
        INTO X_JAQM22CEXP
        from JAQM22
       where JAQM22NDOC = rpad(p_ndoc, 12, ' ')
         and JAQM22INS = p_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        X_JAQM22CEXP := NULL;
    END;
  
    IF X_JAQM22CEXP IS NOT NULL THEN
      BEGIN
        DELETE FROM JAQM22
         where JAQM22NDOC = rpad(p_ndoc, 12, ' ')
           and JAQM22INS = p_instancia
           AND JAQM22CEXP = Rpad(X_JAQM22CEXP, 50, ' ');
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  END;

  PROCEDURE sp_descripcion_ArbolPerfiles(NivelAprobador    number,
                                         DescripcionPerfil out varchar2) IS
  BEGIN
    BEGIN
      SELECT TP1DESC
        into DescripcionPerfil
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND TP1CORR1 = 8
         AND TP1CORR2 = 5
         AND TP1CORR3 > 0
         AND TP1NRO3 = NivelAprobador;
    EXCEPTION
      WHEN OTHERS THEN
        DescripcionPerfil := '';
    END;
  
    DescripcionPerfil := trim(DescripcionPerfil);
  
  END;
  
  PROCEDURE sp_descripcion_firmas(codOpinion number, --18112024 
                                  instancia number, 
                                  nivel_1 out varchar2, 
                                  nivel_2 out varchar2,
                                  nive2_1 out varchar2,
                                  nive2_2 out varchar2,
                                  nive3_1 out varchar2,
                                  nive3_2 out varchar2,
                                  nive4_1 out varchar2,
                                  nive4_2 out varchar2,
                                  nive5_1 out varchar2,
                                  nive5_2 out varchar2,
                                  nive6_1 out varchar2,
                                  nive6_2 out varchar2) is
                                  
  CURSOR descrFirmas is
  select * from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 8 AND TP1CORR2 = 7 order by  TP1CORR3 asc;  
                                    
  BEGIN
   FOR data in descrFirmas LOOP 
       CASE
         WHEN data.TP1CORR3 = 2 THEN             
              nivel_1 :=  trim(data.TP1DESC);    
         WHEN data.TP1CORR3 = 3 THEN               
              nivel_2 :=  trim(data.TP1DESC);
         WHEN data.TP1CORR3 = 4 THEN    
              nive2_1 :=  trim(data.TP1DESC);                   
         WHEN data.TP1CORR3 = 5 THEN     
              nive2_2 :=  trim(data.TP1DESC);                              
         WHEN data.TP1CORR3 = 6 THEN  
              nive3_1 :=  trim(data.TP1DESC);                    
         WHEN data.TP1CORR3 = 7 THEN
              nive3_2 :=  trim(data.TP1DESC);           
         WHEN data.TP1CORR3 = 8 THEN         
              nive4_1 :=  trim(data.TP1DESC);             
         WHEN data.TP1CORR3 = 9 THEN
              nive4_2 :=  trim(data.TP1DESC);           
         WHEN data.TP1CORR3 = 10 THEN         
              nive5_1 :=  trim(data.TP1DESC);             
         WHEN data.TP1CORR3 = 11 THEN
              nive5_2 :=  trim(data.TP1DESC);           
         WHEN data.TP1CORR3 = 12 THEN    
              nive6_1 :=  trim(data.TP1DESC);                  
         WHEN data.TP1CORR3 = 13 THEN        
              nive6_2 :=  trim(data.TP1DESC);                                    
         WHEN data.TP1CORR3 = 14 THEN        
              nive2_2 :=  trim(data.TP1DESC);  
        ELSE 
          NULL;
        END CASE;                          
    END LOOP;
  END;  
 

  PROCEDURE sp_NivelAprobacion_derivarAnalista(flujo                 number,
                                               codOpinion            number,
                                               tipoSolicitud         number,
                                               nivelUsuIngreso       number,
                                               nivelRequerAprobacion out number,
                                               PerfilAsignar         out varchar2) IS
    montoConsolidado number(18, 2);
    auxNivel         number(3);
  BEGIN
    --buscar MontoConsolidado 
    IF flujo = 1 THEN
      BEGIN
        SELECT AQPC156RESPTOT
          INTO montoConsolidado
          FROM AQPC156
         WHERE AQPC156CODOPI = codOpinion
           AND AQPC156ESTAD = 'H';
      EXCEPTION
        WHEN OTHERS THEN
          montoConsolidado := 0;
      END;
    ELSE 
       IF flujo = 2 THEN
        BEGIN
          SELECT AQPC818RESPTOT
          INTO montoConsolidado
          FROM AQPC818
         WHERE AQPC818CODOPI = codOpinion
           AND AQPC818ESTAD = 'H';   
        EXCEPTION
          WHEN OTHERS THEN
            montoConsolidado := 0;
        END;    
       END IF;
    END IF;
  
    montoConsolidado := nvl(montoConsolidado, 0);
  
    --comparar con guia de montos
    BEGIN
      SELECT TP1CORR3
        INTO nivelRequerAprobacion
        FROM FST198
       WHERE Tp1cod = 1
         AND Tp1cod1 = 11152
         AND Tp1corr1 = 10
         AND Tp1corr2 > 0
         AND Tp1corr3 > 0
         AND Tp1nro1 = tipoSolicitud
         AND Tp1imp1 < montoConsolidado
         AND Tp1imp2 >= montoConsolidado;
    EXCEPTION
      WHEN OTHERS THEN
        nivelRequerAprobacion := 0;
    END;
  
    --buscar perfil a derivar
    /*  auxNivel := nivelUsuIngreso + 1; ----- modificar con nueva guia 10/01/2024
    auxNivel := nvl(auxNivel, 0);
  
    BEGIN
      SELECT TP1DESC
        INTO PerfilAsignar
        FROM FST198
       WHERE Tp1cod = 1
         AND Tp1cod1 = 11152
         AND Tp1corr1 = 10
         AND Tp1corr2 > 0
         AND Tp1corr3 > 0
         AND Tp1nro1 = tipoSolicitud
         AND TP1CORR3 = auxNivel;
    EXCEPTION
      WHEN OTHERS THEN
        PerfilAsignar := '';
    END;
    */
    PerfilAsignar := null;
    nivelRequerAprobacion := NVL(nivelRequerAprobacion, 0);
    
    --10012025
    IF nivelUsuIngreso > nivelRequerAprobacion AND nivelUsuIngreso <= 3 THEN
       nivelRequerAprobacion := nivelUsuIngreso;
    END IF;
    
  END;
  
  PROCEDURE sp_valid_operativi_bt(nivelAprobad number, HabilitadoSN out varchar2 ) is
  BEGIN
     HabilitadoSN := 'N';
     --guia para habilitar btn Autorizar en panel 
     BEGIN
       select 'S' INTO HabilitadoSN from fst198 where Tp1cod = 1 and Tp1cod1  = 11152 and Tp1corr1 = 8 AND TP1CORR2 = 6 AND TP1NRO3 = nivelAprobad;
     EXCEPTION 
       WHEN OTHERS THEN
         HabilitadoSN := 'N';
     END;          
  END;   
  
  PROCEDURE sp_obtnUsuariosAprobad(flujo      number, --18112024
                                   codOpinion number, 
                                   instancia number, 
                                   usuAnlCred out varchar2, 
                                   usuGA out varchar2, 
                                   usuNivelAprb1 out varchar2,
                                   usuNivelAprb2 out varchar2,
                                   usuNivelAprb3 out varchar2,
                                   usuNivelAprb4 out varchar2,
                                   usuNivelAprb5 out varchar2,
                                   usuNivelAprb6 out varchar2
                                   ) IS
  maxContdNivl number;   
  auxUsuRej  varchar2(10);                                
  BEGIN
     --obtn AC Y GA
     IF flujo = 1 THEN
         BEGIN
             SELECT W.AQPC156USUREG, W.AQPC156GRAGE
              INTO usuAnlCred, usuGA
              FROM AQPC156 W
             WHERE W.AQPC156CODOPI = codOpinion
               AND W.AQPC156INSTAN = instancia
               AND W.AQPC156ESTAD = 'H';
         EXCEPTION WHEN OTHERS THEN
           usuAnlCred := '';
           usuGA := '';
         END;
     ELSE 
        IF flujo = 2 THEN
           BEGIN
               SELECT W.AQPC818USUREG, W.AQPC818GRAGE
                INTO usuAnlCred, usuGA
                FROM AQPC818 W
               WHERE W.AQPC818CODOPI = codOpinion
                 AND W.AQPC818INSTAN = instancia
                 AND W.AQPC818ESTAD = 'H';
           EXCEPTION WHEN OTHERS THEN
             usuAnlCred := '';
             usuGA := '';
           END;           
        END IF;
     END IF;
     
     --para los demas
     FOR cont in 1..6 LOOP
         BEGIN
           SELECT MAX( A.AQPC801AUX1) INTO maxContdNivl FROM AQPC801 A WHERE 
           A.AQPC801CODOPI = codOpinion AND
           A.AQPC801NIVL = cont;
            EXCEPTION WHEN OTHERS THEN
              maxContdNivl := 0;
         END;
         
         BEGIN
           SELECT AQPC801USREJ into auxUsuRej FROM AQPC801 A WHERE 
           A.AQPC801CODOPI = codOpinion AND
           A.AQPC801NIVL = cont         AND 
           A.AQPC801AUX1 = maxContdNivl;
            EXCEPTION WHEN OTHERS THEN
              maxContdNivl := 0;
              auxUsuRej := '';
         END;    
         
         CASE 
           WHEN cont = 1 THEN
           usuNivelAprb1 := auxUsuRej;
           WHEN cont = 2 THEN
           usuNivelAprb2 := auxUsuRej;
           WHEN cont = 3 THEN
           usuNivelAprb3 := auxUsuRej;
           WHEN cont = 4 THEN
           usuNivelAprb4 := auxUsuRej;
           WHEN cont = 5 THEN
           usuNivelAprb5 := auxUsuRej;
           WHEN cont = 6 THEN
           usuNivelAprb6 := auxUsuRej;              
         END CASE;                   
        
     END LOOP;
     
     
  END;
  
  PROCEDURE sp_armar_correo_Aprobacion(flujo number, CodOpinion number, instancia varchar2, NivelAproba number, usuDerivar varchar2, corrUsuIngre varchar2, correosPara out varchar2, correosCopia out varchar2) is
  usuAnlCred    varchar2(10); 
  usuGA         varchar2(10);
  usuNivelAprb1 varchar2(10);
  usuNivelAprb2 varchar2(10);
  usuNivelAprb3 varchar2(10);
  usuNivelAprb4 varchar2(10);
  usuNivelAprb5 varchar2(10);
  usuNivelAprb6 varchar2(10);
  corrUsuDerivado varchar2(40);
  corrNvlApr1 varchar2(50);
  corrNvlApr2 varchar2(50);
  corrNvlApr3 varchar2(50);
  corrNvlApr4 varchar2(50);
  corrNvlApr5 varchar2(50);
  corrNvlApr6 varchar2(50); 
  XcorreoAnom varchar2(50); 
  contNroCorre number(4);
    
  BEGIN
      
      BEGIN
         pq_cr_repo_opinion_riesgos.sp_obtnUsuariosAprobad(flujo,
                                                           CodOpinion,
                                                           instancia,
                                                           usuAnlCred,   
                                                           usuGA ,       
                                                           usuNivelAprb1,
                                                           usuNivelAprb2,
                                                           usuNivelAprb3,
                                                           usuNivelAprb4,
                                                           usuNivelAprb5,
                                                           usuNivelAprb6                                                           
                                                           );
      EXCEPTION
        WHEN OTHERS THEN
          NULL;                                                           
      END;  
      
      --OBTENER CORREO USUARIO DERIVAR
      contNroCorre := 1;
      IF corrUsuIngre is not null then                  
         correosCopia := trim(corrUsuIngre);
      end if;
      
      correosCopia := nvl(correosCopia, null);
      
      
      begin
        select WFUSREMAIL
          into corrUsuDerivado
          from wFusers
         WHERE WFUSRCOD = RPAD(usuDerivar, 30, ' ');
      exception
        when others then
          corrUsuDerivado := null;
      end;            
  
       begin
        select WFUSREMAIL
          into XcorreoAnom
          from wFusers
         WHERE WFUSRCOD = RPAD(usuNivelAprb1, 30, ' ');
      exception
        when others then
          XcorreoAnom := null;
      end;  
      
      XcorreoAnom := nvl(XcorreoAnom, null);
      
      IF NivelAproba > contNroCorre and XcorreoAnom is not null then
         contNroCorre := contNroCorre + 1;
         if correosCopia is null then
            correosCopia := XcorreoAnom;
         else 
            correosCopia := correosCopia || ';' || trim(XcorreoAnom);
         end if;
      else 
        contNroCorre := contNroCorre + 1;
      End if;
      

       begin
        select WFUSREMAIL
          into XcorreoAnom --corrNvlApr2
          from wFusers
         WHERE WFUSRCOD = RPAD(usuNivelAprb2, 30, ' ');
      exception
        when others then
          XcorreoAnom := null;
      end; 
      
      XcorreoAnom := nvl(XcorreoAnom, null);
      
      IF NivelAproba > contNroCorre and XcorreoAnom is not null then
         contNroCorre := contNroCorre + 1;
         if correosCopia is null then
            correosCopia := XcorreoAnom;
         else 
            correosCopia := correosCopia || ';' || trim(XcorreoAnom);
         end if;
      else 
        contNroCorre := contNroCorre + 1;         
      End if;      
      
       begin
        select WFUSREMAIL
          into XcorreoAnom -- corrNvlApr3
          from wFusers
         WHERE WFUSRCOD = RPAD(usuNivelAprb3, 30, ' ');
      exception
        when others then
          XcorreoAnom := null;
      end;     
      
      XcorreoAnom := nvl(XcorreoAnom, null);
      
      IF NivelAproba > contNroCorre and XcorreoAnom is not null then
         contNroCorre := contNroCorre + 1;
         if correosCopia is null then
            correosCopia := XcorreoAnom;
         else 
            correosCopia := correosCopia || ';' || trim(XcorreoAnom);
         end if;
      else 
        contNroCorre := contNroCorre + 1;         
      End if;        
      
       begin
        select WFUSREMAIL
          into XcorreoAnom --corrNvlApr4
          from wFusers
         WHERE WFUSRCOD = RPAD(usuNivelAprb4, 30, ' ');
      exception
        when others then
          XcorreoAnom := null;
      end;     
      
      XcorreoAnom := nvl(XcorreoAnom, null);
      
      IF NivelAproba > contNroCorre and XcorreoAnom is not null then
         contNroCorre := contNroCorre + 1;
         if correosCopia is null then
            correosCopia := XcorreoAnom;
         else 
            correosCopia := correosCopia || ';' || trim(XcorreoAnom);
         end if;
      else 
        contNroCorre := contNroCorre + 1;         
      End if;                  
      
       begin
        select WFUSREMAIL
          into XcorreoAnom --corrNvlApr5
          from wFusers
         WHERE WFUSRCOD = RPAD(usuNivelAprb5, 30, ' ');
      exception
        when others then
          XcorreoAnom := null;
      end;   
      
      XcorreoAnom := nvl(XcorreoAnom, null);
      
      IF NivelAproba > contNroCorre and XcorreoAnom is not null then
         contNroCorre := contNroCorre + 1;
         if correosCopia is null then
            correosCopia := XcorreoAnom;
         else 
            correosCopia := correosCopia || ';' || trim(XcorreoAnom);
         end if;
      else 
        contNroCorre := contNroCorre + 1;         
      End if;         
      
       begin
        select WFUSREMAIL
          into XcorreoAnom --corrNvlApr6
          from wFusers
         WHERE WFUSRCOD = RPAD(usuNivelAprb6, 30, ' ');
      exception
        when others then
          XcorreoAnom := null;
      end;      
      
      XcorreoAnom := nvl(XcorreoAnom, null);
      
      IF NivelAproba > contNroCorre and XcorreoAnom is not null then
         contNroCorre := contNroCorre + 1;
         if correosCopia is null then
            correosCopia := XcorreoAnom;
         else 
            correosCopia := correosCopia || ';' || trim(XcorreoAnom);
         end if;
      else 
        contNroCorre := contNroCorre + 1;         
      End if;             
            
      correosPara := trim(corrUsuDerivado);       
  END;
  
  PROCEDURE SP_ANALIS_GESTIO_OPI(CODOPINION NUMBER, P_USUARIOGESTIO OUT VARCHAR2, P_NIVELUSUGESTION OUT NUMBER) IS---10/01/2025
  V_USUAR VARCHAR2(10);    
  BEGIN
     BEGIN
        SELECT AQPC801USREJ, AQPC801NIVL INTO V_USUAR, P_NIVELUSUGESTION FROM AQPC801 WHERE AQPC801CODOPI = CODOPINION AND AQPC801ESTDA <> 'O' AND AQPC801AUX1 = 1;
      EXCEPTION
        WHEN OTHERS THEN
          V_USUAR := '';  
          P_NIVELUSUGESTION := 0;   
     END;  
     
     P_USUARIOGESTIO  := V_USUAR;
     P_NIVELUSUGESTION := NVL(P_NIVELUSUGESTION, 0);          
  
    IF P_NIVELUSUGESTION = 0 THEN
        BEGIN
          SELECT AQPC156ANSERIG --, AQPC156NIVEL   18/08/2025
          INTO V_USUAR--, P_NIVELUSUGESTION 
          FROM AQPC156 WHERE AQPC156CODOPI = CODOPINION AND  AQPC156ESTAD = 'H';
        EXCEPTION
        WHEN OTHERS THEN
          V_USUAR := '';
        END; 
         
         
        IF V_USUAR IS NULL OR V_USUAR = '' THEN  --20022025
             BEGIN
                SELECT AQPC818ANSERIG  INTO V_USUAR FROM AQPC818 WHERE AQPC818CODOPI = CODOPINION AND  AQPC818ESTAD = 'H';
             EXCEPTION
              WHEN OTHERS THEN
                V_USUAR := '';
               END;          
         END IF;
       

         --BUSCAR POR USUARIO EL NIVEL EN GUIA DE ARBOL DE AUTONOMIAS
         BEGIN
           SELECT TP1IMP1 INTO P_NIVELUSUGESTION FROM FST198 WHERE TP1COD = 1 AND TP1COD1  = 11152 AND TP1CORR1 = 11 
           AND TP1CORR2 = 9 AND TP1CORR3 > 0 AND TP1DESC = RPAD(V_USUAR, 30, ' ');         
          EXCEPTION
          WHEN OTHERS THEN
            P_NIVELUSUGESTION := 0;
           END;  
              
         P_USUARIOGESTIO  := TRIM(V_USUAR);       
         P_NIVELUSUGESTION := NVL(P_NIVELUSUGESTION, 0);
        
     END IF;
     
    
  END;
  
  
  PROCEDURE sp_validar_estado_opin(flujo number, codOpinion number, instancia number, flgOk out varchar2) IS
  BEGIN
     flgOk := 'N';
     IF flujo = 1 THEN
        BEGIN
           SELECT 'S'
          into flgOk
          FROM AQPC156
         WHERE AQPC156CODOPI = codOpinion
           AND AQPC156INSTAN = instancia
           AND AQPC156ESTOP  IN ('P', 'O')
           AND AQPC156ESTAD = 'H';
        EXCEPTION 
          WHEN OTHERS THEN
            NULL;
        END;
     ELSE
         BEGIN
           SELECT 'S'
          into flgOk
          FROM aqpc818
         WHERE aqpc818CODOPI = codOpinion
           AND aqpc818INSTAN = instancia
           AND aqpc818ESTOP  IN ('P', 'O')
           AND aqpc818ESTAD = 'H';
        EXCEPTION 
          WHEN OTHERS THEN
            NULL;
        END;
     END IF;
     
     
     IF flgOk = 'N' THEN
         IF flujo = 1 THEN
            BEGIN
               SELECT 'S'
              into flgOk
              FROM AQPC156
             WHERE AQPC156CODOPI = codOpinion
               AND AQPC156INSTAN = instancia
               AND AQPC156ESTOP  IN ('NV')
               AND AQPC156NRECONS > 0
               AND AQPC156ESTAD = 'H';
            EXCEPTION 
              WHEN OTHERS THEN
                NULL;
            END;
         ELSE
             BEGIN
               SELECT 'S'
              into flgOk
              FROM aqpc818
             WHERE aqpc818CODOPI = codOpinion
               AND aqpc818INSTAN = instancia
               AND AQPC818ESTOP  IN ('NV')
               AND AQPC818NRECONS > 0
               AND aqpc818ESTAD = 'H';
            EXCEPTION 
              WHEN OTHERS THEN
                NULL;
            END;
         END IF;
     END IF;
     
     flgOk := NVL(flgOk, 'N'); 
  END;
  
  PROCEDURE sp_valid_duplic_Panel_Derivar(usuario varchar2, nivelPerfil number, flgDuplNoLis out varchar2) IS
  
  NivelMaxiPerf number;
  BEGIN
     BEGIN
        SELECT MAX(G.TP1NRO3) INTO NivelMaxiPerf FROM PRFU00 P, FST198 G  WHERE       
        g.Tp1cod = 1             AND
        g.Tp1cod1 = 11152        AND
        g.Tp1corr1 = 12          AND
        g.Tp1corr2 = 1           AND
        g.Tp1corr3 > 0           and      
        g.tp1desc  = rpad(PRFGCOD, 30, ' ') AND        
        P.Ubuser = RPAD(usuario, 10, ' ');
      EXCEPTION 
        WHEN OTHERS THEN
          NULL;
      END;   
      
      NivelMaxiPerf := nvl(NivelMaxiPerf, 0);         
      IF nivelPerfil = NivelMaxiPerf THEN
         flgDuplNoLis := 'S';
      ELSE 
         flgDuplNoLis := 'N';
      END IF;
     
  
  END;    
  

end pq_cr_repo_opinion_riesgos;
/
