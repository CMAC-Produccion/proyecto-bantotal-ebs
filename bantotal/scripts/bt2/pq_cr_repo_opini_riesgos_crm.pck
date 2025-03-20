create or replace package pq_cr_repo_opini_riesgos_CRM is
  -- *****************************************************************
  -- Nombre                     : PAQUETE PARA OPINION DE RIESGOS CRM
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 19/10/2023
  -- Autor de Creación          : IGS_RCASTRO
  -- Uso                        : Realiza cálculos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 05/12/2023
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Validación de Limite para generar nuevo codigo de opinión.
  -- Fecha de Modificación      : 18/12/2023
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se agrega nuevo formato de cod. opinión y se omite validación de vig. solicitud   
  -- Fecha de Modificación      : 22/1/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Ajuste en mostrar los comentarios en reconsideración cuando haya una observacion 
  --                             sp_grabar_comentarios_acr_ga     
  -- Fecha de Modificación      : 21/02/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se modifica procedimiento sp_delegar_analis_senior para la delegacion de opin. para perfiles superiores a supervisor
  -- Fecha de Modificación      : 03/04/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se agrega alertas al panel y eval. consumo  
  -- Fecha de Modificación      : 16/04/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se agrega eval anterior consumo    
  -- Fecha de Modificación      : 23/04/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se cambia el procedure para sp_score    
  -- Fecha de Modificación      : 12/08/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se agrega logica nueva para obtener la actividad.
  -- Fecha de Modificación      : 12/09/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se valida vinculacion de linas para creditos    
  -- Fecha de Modificación      : 01/10/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se cambia logica para obtener tipo de reprogramacion
  -- Fecha de Modificación      : 10/10/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se agrega guia para descripcion de tipo de reprog. crm 
  -- Fecha de Modificación      : 03/12/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se cambia logica para obtener aprobadores  
  -- Fecha de Modificación      : 07/01/2025
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se ajusta la obtencion de usuario suplente.
  -- Fecha de Modificación      : 10/01/2025
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Modificacion de arbol de aprobacion y autonomias 
  -- Fecha de Modificación      : 11/02/2025
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Modificacion de delegacion y arbol            
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
                                           p_fechaCrmM400          date,    
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
                                  SumSldVigent  out number);

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
  procedure sp_consul_por_solic156(auxint number, ubuser varchar2, fechHoy DATE, mensajeErro out varchar2); --01042024                                  
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
                                         xCondiRecomRiesg varchar2);

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
                                     NivelAprobOpi NUMBER,
                                     codNivelPerfiDeriv number);
 /* procedure sp_obtener_correos_usuarios(FechaHoy       DATE,
                                        UsuAnalisCred  varchar2,
                                        UsuGA          varchar2,
                                        UsuGZona       varchar2,
                                        UsuARiesgos    varchar2, --Ini Mod 10072023
                                        UsuSupervAdm   varchar2,
                                        UsuJefeAdm     varchar2,
                                        UsuGereRiesg   varchar2, --Fin Mod 10072023                                        
                                        Correos        out varchar2,
                                        CorreosEnCopia out varchar2); */

  procedure sp_actual_propuesto_156(instancia  number,
                                    codOpini   number,
                                    saldo      out number,
                                    montootorg out varchar2,
                                    cuotas     out number,
                                    ncuotas    out varchar2,
                                    tasa       out number);

  procedure sp_valid_aprob_anriesgo(codOpini number, flgEstd out varchar2);

  procedure sp_val_etap_solicitud(instancia     number, --07112023
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
  procedure sp_obtn_cuot_cred_vigen_Anter(auxInstnc         number,  --30042024
                                          auxTmod           number,                                              
                                          --xSumcuotaVigRec   OUT number,
                                          xSumcuotaVigAnter OUT number,
                                          --xCredicContingAct out number, --  
                                          xCredicContingAnt out number, --                                     
                                          --xCredPotencAct    OUT number, --
                                          xCredPotencAnt    OUT number);                                        
                                       
  PROCEDURE sp_cargar_entidad_gast_finan(codOpinion number,
                                         instancia  number);
                                         
  procedure sp_carg_ent_gst_fin_anter(codOpinion number,  --30042024
                                      flujo      varchar2,                                                                    
                                      instanciaAnt  number);
                                                                               
  Procedure sp_obtner_Instanci_anterior(instancia number,
                                        auxInstnc out number,
                                        fechaAnteM400 out date);--01042024
  procedure sp_desc_tipo_solicitud(instancia number,
                                   CodTipoSolicitud out number,
                                   DescTipoSolicitud OUT varchar2);
  procedure sp_obtener_datos_cabecera(xSucursal     number,
                                      cuenta        number,
                                      nomSucursCred out varchar2,
                                      nombreClient  out varchar2);
  procedure sp_validar_modelo_Evaluacion(instancia     number,
                                         usuario       varchar2,               
                                         flgModelEval  out varchar2,
                                         txtTipoEvalu  out varchar2,
                                         flgEsEvalFluj out varchar2,
                                         MsgRpta  out varchar2); --30062023
  procedure sp_validar_existe_ratio(instancia number, tipo varchar2, fecha date, usuario varchar2);                                         

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
                                      xAQPC171ANCNEG  out varchar,
                                      xAQPC171ANVIC   out varchar,
                                      xAQPC171FCN     out varchar,
                                      xAQPC171AESFCC  out varchar,
                                      xAQPC171RDCLN   out varchar,
                                      xAQPC171ANCP    out varchar,
                                      xAQPC171ANCPG   out varchar,
                                      xAQPC171DANDC   out varchar,
                                      xAQPC171DGCOR   out varchar,
                                      xAQPC171RANCNEG out varchar,
                                      xAQPC171MTREP   out varchar,
                                      xAQPC171RAESFCC out varchar,
                                      xAQPC171ANCPRF  out varchar,
                                      xAQPC171ANVPG   out varchar,
                                      xAQPC171DEGV    out varchar,
                                      xAQPC171RFANCNE out varchar,
                                      xAQPC171MTREFN  out varchar,
                                      xAQPC171RFAESFC out varchar,
                                      xAQPC171RFANCPR out varchar,
                                      xAQPC171RFANVPG out varchar,
                                      xAQPC171RFDEGV  out varchar,
                                      xAQPC171USURAR  out varchar,
                                      xAQPC171COMEN   out varchar,
                                      xAQPC171RESOL   out varchar,
                                      xAQPC171CONREC  out varchar,
                                      xAQPC171ARGRECO out varchar, -- INI MOD RCASTRO 10072023
                                      xAQPC171ANACOME out varchar,
                                      xAQPC171RESOLRE out varchar,
                                      xAQPC171CONDREC out varchar,
                                      xAQPC171MOTOBSV out varchar2); -- FIN MOD RCASTRO 10072023 

  PROCEDURE sp_lista_opiniones(instancia    number,
                               userIngreso  varchar2,
                               nivelUsuIng  number,
                               userSuplente varchar2,
                               nivelUsuSupl number,
                               fechaIngreso date,
                               msgError     out varchar2);
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

  PROCEDURE sp_obtn_val_cred_pyme(instancia         number, --21032023
                                  nroINTipoCN       number,                      
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
                                  NivelAprob   number, --18112024
                                  usuario      varchar2,
                                  ComentObserv varchar2,
                                  resptObser   out varchar2);

  PROCEDURE sp_grab_log_aqpc171(codOpinion number, instancia number);

  --newcrm
  procedure sp_obtener_Credito(instancia in number,
                               v_Pgcod   out number,
                               v_Scmod   out number,
                               v_Scsuc   out number,
                               v_Scmda   out number,
                               v_Scpap   out number,
                               v_Sccta   out number,
                               v_Scoper  out number,
                               v_Scsbop  out number,
                               v_Sctope  out number);
  PROCEDURE sp_obtn_Asesor(instancia  in number,
                           asesor     out varchar2,
                           fecIngreso out date);

  PROCEDURE sp_datos_opinion(instancia    number,
                             nivelPerfil  out number,
                             flgExiste    out varchar2,
                             UsuarioDeriv out varchar2);
  PROCEDURE sp_datos_reconsideracion(instancia     number,
                                     nroreconsider out number,
                                     estdOpini     out varchar2,
                                     p_nivelAproba out number,
                                     p_flg         out varchar2); --07112023                          
  PROCEDURE sp_val_solic_terminado(instancia number,
                                   tipoFlujo number,
                                   fechaHoy  date,
                                   codRpta   out varchar2); --07/12/2023
                                   
  PROCEDURE sp_tipoReprogr_CRM(instancia number, p_TipoRepr out varchar2); --27/09/2024                                  

end pq_cr_repo_opini_riesgos_CRM;
/

create or replace package body pq_cr_repo_opini_riesgos_CRM is

  procedure sp_nomclientes(codOpinion number,
                           instancia  number,
                           nrocuenta  number,
                           NomClien   out varchar2,
                           nrodocs    out varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_nomclientes
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca los integrantes del cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                             
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
         AND AQPC813AUX2 = codOpinion; --07112023;
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
  
    v_Pgcod  number(3); --newcrm
    v_Scmod  number(4);
    v_Scsuc  number(4);
    v_Scmda  number(4);
    v_Scpap  number(4);
    v_Sccta  number(9);
    v_Scoper number(9);
    v_Scsbop number(3);
    v_Sctope number(3);
    fecMax   date;
  
  Begin
    --Obtener datos
    --newcrm
    pq_cr_repo_opini_riesgos_crm.sp_obtener_Credito(instancia,
                                                    v_Pgcod,
                                                    v_Scmod,
                                                    v_Scsuc,
                                                    v_Scmda,
                                                    v_Scpap,
                                                    v_Sccta,
                                                    v_Scoper,
                                                    v_Scsbop,
                                                    v_Sctope);
  
    Begin
      SELECT MAX(JAQA400FEC)
        into fecMax
        FROM JAQA400 a
       WHERE a.JAQA400EMP = v_Pgcod
         AND a.JAQA400MOD = v_Scmod
         AND a.JAQA400SUC = v_Scsuc
         AND a.JAQA400MDA = v_Scmda
         AND a.jaqa400pap = v_Scpap
         AND a.JAQA400CTA = v_Sccta
         AND a.JAQA400OPE = v_Scoper
         AND a.JAQA400SBO = v_Scsbop
         AND a.JAQA400TOP = v_Sctope;
    Exception
      when others then
        null;
    End;
    ----                                           
  
    Begin
      select trim(a.jaqa400uss), --a.sng001ase),
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
        from jaqa400 a, fst046 b, fst001 c, Fst811 d, fst810 e, fst198 f --newcrm
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
         and b.ubuser = a.jaqa400uss
         and c.pgcod = b.pgcod
         and c.sucurs = b.ubsuc
         and
            --and a.sng001inst = instancia;
             a.JAQA400EMP = v_Pgcod
         AND a.JAQA400MOD = v_Scmod
         AND a.JAQA400SUC = v_Scsuc
         AND a.JAQA400MDA = v_Scmda
         AND a.jaqa400pap = v_Scpap
         AND a.JAQA400CTA = v_Sccta
         AND a.JAQA400OPE = v_Scoper
         AND a.JAQA400SBO = v_Scsbop
         AND a.JAQA400TOP = v_Sctope
         AND a.jaqa400fec = fecMax;
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
    -- *****************************************************************
    -- Nombre                     : sp_calificacion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca la calificacion
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                             
    auxFecha     date;
    auxPais      number(3);
    auxTdoc      number(2);
    auxNdoc      varchar2(12);
    porcCalif    number(5, 2);
    descCalif    varchar2(30);
    ln_porcCalif varchar2(10);
    v_pendoc     varchar2(12);
  
  begin
    BEGIN
      --newcrm
      SELECT PEPAIS, PETDOC, PENDOC
        INTO auxPais, auxTdoc, auxNdoc
        FROM FSR008
       WHERE CTNRO = cuenta
         AND CTTFIR = 'T';
      /*SELECT E.SNG001PAIS, E.SNG001TDOC, E.SNG001NDOC
       INTO auxPais, auxTdoc, auxNdoc
       FROM SNG001 E
      WHERE E.SNG001INST = instancia;*/
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
    -- *****************************************************************
    -- Nombre                     : sp_productoSBS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca el producto SBS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                            
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
    -- *****************************************************************
    -- Nombre                     : sp_actividad
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca la actividad del cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                          
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
    xpendoc := trim(xpendoc); --26032024
    IF xpepais <> 0 and xpetdoc <> 0 then
      /*BEGIN
        SELECT PETIPO
          into xtipo
          FROM FSD001
         WHERE PEPAIS = xpepais
           AND PETDOC = XPETDOC
           AND PENDOC = XPENDOC;
      EXCEPTION
        WHEN OTHERS THEN
          xtipo := '';
      END;*/
     
    --12/08/2024
      begin
        -- Call the procedure
        pq_cr_modulo_campanias.sp_cr_ciuu(ln_pais => xpepais,
                                          ln_tdoc => xpetdoc,
                                          lc_ndoc => xpendoc,
                                          ln_ciiu => ln_ciiu);
      EXCEPTION
        WHEN OTHERS THEN  
          ln_ciiu := 0;                                        
      end;
    ---
     /*
      BEGIN
        select pq_cr_funciones_opinion_riegos.fn_cr_ciiu_codigo(xpepais,
                                                                xpetdoc,
                                                                xpendoc,
                                                                xtipo) --fn_ciiu_codigo(xpepais, xpetdoc, xpendoc, xtipo)
          INTO xciiu
          from dual;
      EXCEPTION
        WHEN others THEN
          xciiu := 0;
      END;*/
      actividad := '';
      BEGIN
        select actnom1 INTO actividad from fst750 f where f.actcod1= ln_ciiu;
      EXCEPTION
        WHEN OTHERS THEN  
          actividad := '';        
      END;
    
      /*BEGIN
        --select FN_CIIU_DESCRI INTO actividad from aojeda_anx.microactividadx where fn_ciiu_codigo= xciiu; 
        select AQPC164FN_DES
          INTO actividad
          from AQPC164
         where AQPC164FN_CII = xciiu;
      EXCEPTION
        WHEN others THEN
          actividad := '';
      END;*/
    end if;
  
  END;

  procedure sp_score(instancia   number,
                     cuenta      number,
                     usuario     varchar2,
                     nivelRiesgo out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_score
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca el nivel de riesgos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                       
    XNDOC              VARCHAR2(12);
    XTIPDOC            NUMBER(4);
    fechaProc          DATE;
    xFechaCierreMesAnt DATE;
    XPAIS              NUMBER(3);
    lc_score           varchar2(200);
    ln_probal          number(10,7);
    lc_segmriesgo      varchar2(15);
    ln_pdcal           number(8,7);
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
    
    XNDOC := trim(XNDOC);
  
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
                                 ld_fchscore => ld_fchscore); */
                                 
        pq_cr_score_rcc.sp_cr_scoredni_ii(ln_inst => instancia,
                                         ln_tdoc => XTIPDOC,
                                         lc_ndoc => XNDOC,
                                         lc_prgm => 'OPRIE',
                                         lc_user => usuario,
                                         lc_score => lc_score,
                                         ln_probal => ln_probal,
                                         lc_segmriesgo => lc_segmriesgo,
                                         ln_pdcal => ln_pdcal,
                                         lc_tabla => lc_tabla,
                                         ld_fchscore => ld_fchscore,
                                         lc_scoreabr => lc_scoreabr,
                                         lc_newscore => lc_newscore);                                   
                                 
        nivelRiesgo := trim(lc_newscore);                                                                                            
    EXCEPTION
      WHEN others THEN
        nivelRiesgo := 'Sin Segmentación';
    end;
    
    IF lc_newscore is null or lc_newscore = ' ' or lc_newscore = 'SIN SCORE' THEN
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
    -- *****************************************************************
    -- Nombre                     : sp_pd
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca el PD
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                   
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
      auxAgencia  := agencia; --newcrm
      auxAnalista := analista;
      /*SELECT SNG001AGE, trim(SNG001ASE)
       into auxAgencia, auxAnalista
       FROM SNG001 B
      WHERE B.SNG001INST = instancia
        and rownum < 2;*/
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
    -- *****************************************************************
    -- Nombre                     : sp_obtener_pd_cos4_co6_Analista
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca las cosechas del analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                             
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
    -- *****************************************************************
    -- Nombre                     : sp_obtener_pd_cos4_co6_Agencia
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca las cosechas de la agencia
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                            
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
    -- *****************************************************************
    -- Nombre                     : sp_obtener_pd_cos4_co6_Zona
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca las cosechas de la zona
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                          
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
    -- *****************************************************************
    -- Nombre                     : sp_obtener_pd_cos4_co6_Region
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca las cosechas de la region
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                            
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
    -- *****************************************************************
    -- Nombre                     : sp_montoCred
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca el monto del crédito
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- ***************************************************************** 
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
  
    v_TC_credVig   number(14, 8);
    auxMontoReprog number(17, 2);
    v_fechaHoy     date;
    v_Pgcod        number(3); --newcrm
    v_Scmod        number(4);
    v_Scsuc        number(4);
    v_Scmda        number(4);
    v_Scpap        number(4);
    v_Sccta        number(9);
    v_Scoper       number(9);
    v_Scsbop       number(3);
    v_Sctope       number(3);
    v_flgRepr      varchar2(1);
  
    --- 18/12/2023
    v_correlativo  number(10);
    v_montoPropu   number(17, 2);
    v_modalidPropu varchar2(200);
    v_cuotaPropu   number(17, 2);
    v_totCuotPropu varchar2(20);
    v_tasaPropu    number(7, 2);
    v_monedaPropu  number(3);
    v_AQPC833AUX2  varchar2(100);
  
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
  
    ---datos del credito a reprogramar 
    BEGIN
      SELECT PGFAPE INTO v_fechaHoy FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        v_fechaHoy := to_date(sysdate);
    END;
  
    BEGIN
      pq_cr_repo_opini_riesgos_crm.sp_obtener_Credito(instancia,
                                                      v_Pgcod,
                                                      v_Scmod,
                                                      v_Scsuc,
                                                      v_Scmda,
                                                      v_Scpap,
                                                      v_Sccta,
                                                      v_Scoper,
                                                      v_Scsbop,
                                                      v_Sctope);
    
    END;
  
    v_flgRepr := 'N';
    BEGIN
      --VALIDAR SI SE ESTÁ REPRGORAMANDO EL DIA DE HOY
      SELECT 'S'
        INTO v_flgRepr
        FROM JAQA400 a
       WHERE a.JAQA400EMP = v_Pgcod
         AND a.JAQA400MOD = v_Scmod
         AND a.JAQA400SUC = v_Scsuc
         AND a.JAQA400MDA = v_Scmda
         AND a.jaqa400pap = v_Scpap
         AND a.JAQA400CTA = v_Sccta
         AND a.JAQA400OPE = v_Scoper
         AND a.JAQA400SBO = v_Scsbop
         AND a.JAQA400TOP = v_Sctope
         AND a.jaqa400fec = v_fechaHoy;
    Exception
      when others then
        v_flgRepr := 'N';
    End;
  
    IF v_flgRepr = 'S' THEN
      BEGIN
        SELECT XLLCAPITAL
          INTO auxMontoReprog
          FROM x054023
         WHERE XLLPGCOD = v_Pgcod
           AND XLLAOMOD = v_Scmod
           AND XLLAOSUC = v_Scsuc
           AND XLLAOMDA = v_Scmda
           AND XLLAOPAP = v_Scpap
           AND XLLAOCTA = v_Sccta
           AND XLLAOOPER = v_Scoper
           AND XLLAOSBOP = 609
           AND XLLAOTOP = v_Sctope;
      EXCEPTION
        WHEN OTHERS THEN
          auxMontoReprog := 0;
      END;
    END IF;
  
    v_MontoAcumuCredVuelo := v_MontoAcumuCredVuelo + NVL(auxMontoReprog, 0);
  
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
  
    --add credito a reprogramar a aqpc833   
    BEGIN
      pq_cr_repo_opini_riesgos_crm.sp_operac_propuesta(instancia,
                                                       0,
                                                       v_montoPropu,
                                                       v_modalidPropu,
                                                       v_cuotaPropu,
                                                       v_totCuotPropu,
                                                       v_tasaPropu,
                                                       v_monedaPropu);
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
    v_AQPC833AUX2 := 'RF'; -- marcar que es una reprogramación
  
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_insert_cred_vuelo_aqpc833(ln_CodOpi,
                                                              instancia,
                                                              v_montoPropu,
                                                              v_modalidPropu,
                                                              v_cuotaPropu,
                                                              v_totCuotPropu,
                                                              v_tasaPropu,
                                                              v_monedaPropu,
                                                              v_AQPC833AUX2);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END; --18/12/2023    
  
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
             AND A.XLLAOSBOP = p_suboper -- 609 newcrm
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
      END IF;
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
    
      v_AQPC833AUX2 := '';
      BEGIN
        pq_cr_repo_opinion_riesgos.sp_insert_cred_vuelo_aqpc833(ln_CodOpi,
                                                                xv.solicitudvuelo,
                                                                v_montoPropu,
                                                                v_modalidPropu,
                                                                v_cuotaPropu,
                                                                v_totCuotPropu,
                                                                v_tasaPropu,
                                                                v_monedaPropu,
                                                                v_AQPC833AUX2);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END; --18/12/2023                                     
    
    END LOOP;
  
    monto := round(v_MontoAcumuCredVuelo, 2);
  
    /*BEGIN
      SELECT K.SNG001CTA  --newcrm
        INTO v_cuentaOrig
        FROM SNG001 K
       WHERE K.SNG001INST = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        v_cuentaOrig := 0;
    END;*/
  
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
      select w.xwfcuenta
        into ln_cuenta
        from xwf700 w
       where --crm
       w.xwfprcins = instancia
       and w.xwfcar3 = '1';
      /*select s.sng001cta
       into ln_cuenta
       from sng001 s
      where s.sng001inst = instancia;*/
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
        pq_cr_repo_opini_riesgos_crm.sp_obtn_cred_vig_titu(auxnropinion  => ln_CodOpi,
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
        select SUM(decode(A.AQPC820MDA,
                          101,
                          A.AQPC820SLDVIG * v_TC_credVig,
                          A.AQPC820SLDVIG)) --SUM(A.AQPC820SLDVIG) 26092023
          INTO SumSldVigent
          from AQPC820 a
         where a.AQPC820codopi =
               (select MAX(b.aqpc815codopin) --07112023
                  from aqpc815 b
                 where b.aqpc815instan = instancia)
           and (a.AQPC820tipsol not in ('A', 'RF', 'V') or
               a.AQPC820tipsol is null)
           AND AQPC820ESTAD = 'H';
      exception
        when others then
          SumSldVigent := 0;
      end;
    
    end if;
  
    -- Responsabilidad Total o monto consolidado
    monto := monto + nvl(SumSldVigent, 0);
  
  End sp_montoCred;
  ----------------------------------------------------------------------------------------

  procedure sp_operac_propuesta(instancia  number,
                                cuenta     number,
                                monto      out number,
                                modalidad  out varchar2,
                                cuota      out number,
                                tot_cuotas out varchar2,
                                tasa       out number,
                                moneda     out number) is
    -- *****************************************************************
    -- Nombre                     : sp_operac_propuesta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca la operacion propuesta
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                  
  
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
    flgExisteM400 varchar2(1);
    FECHAACT  DATE;
  
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
             
             c.xwfmoneda
        INTO auxMonto, auxModalidad, auxMoneda
        FROM xwf700 c --sng001 a --wfwrkitems b, 
       where c.xwfprcins = instancia
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
  
    --Monto de la Cuota 
    xflgEsEvalFluj := 'N';
    /*BEGIN
      -- validar si tiene evaluación por flujo 
      pq_cr_ratio_evalflujo.sp_cr_verfevalflujo(instancia, xflgEsEvalFluj);
    EXCEPTION
      WHEN OTHERS THEN
        xflgEsEvalFluj := 'N';
    END;*/
  
    auxModEval := 0;
    auxCuota   := 0;
    IF xflgEsEvalFluj = 'N' THEN
      --01042024  
      BEGIN
        SELECT PGFAPE INTO FECHAACT FROM FST017 WHERE PGCOD = 1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL; 
      END; 
      flgExisteM400 := 'N';
      BEGIN
        SELECT 'S' into flgExisteM400 FROM JAQM400 W WHERE W.JAQM400INS = instancia AND W.JAQM400FEC = FECHAACT AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;      
      END;
      flgExisteM400 := nvl(flgExisteM400, 'N');
      ---
      IF flgExisteM400 = 'N' THEN
          BEGIN
            SELECT jaqz516TMOD
              INTO auxModEval
              FROM jaqz516 w
             WHERE jaqz516SOL = instancia
             and jaqz516fec = FECHAACT;
          EXCEPTION
            WHEN OTHERS THEN
              auxModEval := 0;
          END;
      ELSE 
          auxModEval := 14;
      END IF;
    
      IF auxModEval = 13 THEN
        BEGIN
          SELECT R.JAQY142CAPCUO
            INTO auxCuota
            FROM JAQY142B R --newcrm
           WHERE R.JAQY142INST = instancia
             AND R.JAQY142PGCOD = p_empresa
             AND R.JAQY142MOD = p_modulo
             AND R.JAQY142SUC = p_sucursal
             AND R.JAQY142MDA = p_moned
             AND R.JAQY142PAP = p_papel
             AND R.JAQY142CTA = p_cuenta
             AND R.JAQY142OPE = p_operacion
             AND R.JAQY142SBOP = 609 --p_suboper 04012024
             AND R.JAQY142TOPE = p_tipoper
             AND R.JAQY142EST = 'H'
                --AND R.JAQY142TAREA = 7 newcrm
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
              FROM jaqz822B K --newcrm
             WHERE K.JAQZ822INST = instancia
               AND K.JAQZ822PGCOD = p_empresa
               AND K.JAQZ822MOD = p_modulo
               AND K.JAQZ822SUC = p_sucursal
               AND K.JAQZ822MDA = p_moned
               AND K.JAQZ822PAP = p_papel
               AND K.JAQZ822CTA = p_cuenta
               AND K.JAQZ822OPE = p_operacion
               AND K.JAQZ822SBOP = 609 --p_suboper 04012024
               AND K.JAQZ822TOPE = p_tipoper
               AND K.JAQZ822EST = 'H'
                  --AND K.JAQZ822TAREA = 7
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
      SELECT XLLPERIODO, XLLCANTCUO, XLLTASAP, XLLCAPITAL
        INTO p_PERIODO, auxTotCuot, auxTasa, auxMonto --07112023
        FROM x054023
       WHERE XLLPGCOD = p_empresa
         AND XLLAOMOD = p_modulo
         AND XLLAOSUC = p_sucursal
         AND XLLAOMDA = p_moned
         AND XLLAOPAP = p_papel
         AND XLLAOCTA = p_cuenta
         AND XLLAOOPER = p_operacion
         AND XLLAOSBOP = 609 --p_suboper newcrm
         AND XLLAOTOP = p_tipoper;
    EXCEPTION
      WHEN OTHERS THEN
        p_PERIODO  := 0;
        auxTotCuot := 0;
        auxTasa    := 0;
        auxMonto   := 0;
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
  
    IF auxMoneda IS NULL THEN
      auxMoneda := 0;
      moneda    := 0;
    ELSE
      moneda := auxMoneda;
    END IF;
  
    monto      := nvl(auxMonto, 0);
    modalidad  := auxModalidad || chr(3) || chr(10);
    cuota      := nvl(auxCuota, 0);
    tot_cuotas := to_char(auxTotCuot) || ' cuo. ' || trim(p_descPeriodo);
    tasa       := nvl(auxTasa, 0);
  END;
  --EntidFinanc
  procedure sp_relaciones_finacie(instanci    number,
                                  cuenta      number,
                                  fechaAper   date,
                                  codSBS      out numeric,
                                  fechEvaluar OUT date) is
    -- *****************************************************************
    -- Nombre                     : sp_relaciones_finacie
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca las relaciones financieras
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                    
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
    p_ndoc := trim(p_ndoc); --26032024
  
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
    -- *****************************************************************
    -- Nombre                     : sp_grid_garantias
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca las garantias
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                               
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
    -- *****************************************************************
    -- Nombre                     : sp_analisisfinancieroCreditos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca el analisis financiero
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                           
  
    auxTmod      number(4);
    ln_evalflujo varchar2(1);
    FechActual date;
  BEGIN
    BEGIN
      SELECT pgfape into FechActual FROM FST017 WHERE PGCOD = 1; 
    exception 
      when others then
        null;
    END;  
  
    --Obtener Ratio Cuota
    BEGIN
      select jaqz516TMOD
        INTO auxTmod
        from jaqz516 w
       where jaqz516SOL = instancia
       and w.jaqz516fec = FechActual;
    EXCEPTION
      WHEN OTHERS THEN
        auxTmod := 0;
    END;
    
    ResultRatioEvalRec := 0;
    IF AUXTMOD = 13 THEN
      BEGIN
        SELECT JAQY140RATIO
          INTO ResultRatioEvalRec
          FROM JAQY140B --newcrm
         WHERE JAQY140INST = instancia
           AND JAQY140EST = 'H';
        --AND JAQY140TAREA = 7;
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
      END IF;
    END IF;
  
    IF AUXTMOD = 14 THEN
      -- SI MODELO  EVALUACION ES 14
      BEGIN
        SELECT JAQZ821RATIO
          INTO ResultRatioEvalRec
          FROM JAQZ821B --newcrm
         WHERE JAQZ821INST = instancia
           AND JAQZ821EST = 'H';
        --AND JAQZ821TAREA = 7;
      EXCEPTION
        WHEN OTHERS THEN
          ResultRatioEvalRec := 0;
      END;
    END IF;
  
    IF ResultRatioEvalRec <> 0 THEN
      ResultRatioEvalRec := ResultRatioEvalRec * 100;
    END IF;
  
    BEGIN
      select g021.jaqz516eval,
             (select sum(decode(c.jaqz517cod, 40, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                540,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (40, 540)) resultado_Neto,
             (select sum(decode(c.jaqz517cod, 41, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                541,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (41, 541)) Caja_bancos, --disponible,
             (select sum(decode(c.jaqz517cod, 42, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                542,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (42, 542)) cuentas_cobrar_comerci,
             (select sum(decode(c.jaqz517cod, 43, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                543,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (43, 543)) mercaderia,
             (select sum(decode(c.jaqz517cod, 44, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                544,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (44, 544)) gastos_anticipados,
             (select sum(decode(c.jaqz517cod, 45, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                545,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (45, 545)) existencias_recibir,
             (select sum(decode(c.jaqz517cod, 46, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                546,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (46, 546)) otros_act_corri,
             (select sum(decode(c.jaqz517cod, 47, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                547,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (47, 547)) total_actv_corri,
             (select sum(decode(c.jaqz517cod, 48, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                548,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (48, 548)) muebles,
             (select sum(decode(c.jaqz517cod, 49, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                549,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (49, 549)) inmuebles,
             (select sum(decode(c.jaqz517cod, 50, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                550,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (50, 550)) otros_act_fijo,
             (select sum(decode(c.jaqz517cod, 51, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                551,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (51, 551)) total_activ_fijo,
             (select sum(decode(c.jaqz517cod, 52, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                552,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (52, 552)) total_activ,
             (select sum(decode(c.jaqz517cod, 53, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                553,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (53, 553)) otros_ingreso,
             (select sum(decode(c.jaqz517cod, 54, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                554,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (54, 554)) gastos_familiares,
             (select sum(decode(c.jaqz517cod, 56, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                556,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (56, 556)) cuentas_banco,
             (select sum(decode(c.jaqz517cod, 57, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                557,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (57, 557)) tributo_pagar,
             (select sum(decode(c.jaqz517cod, 58, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                558,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (58, 558)) otros_pasiv_corr,
             (select sum(decode(c.jaqz517cod, 59, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                559,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (59, 559)) total_pasiv_corr,
             (select sum(decode(c.jaqz517cod, 60, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                560,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (60, 560)) cuentas_bancoLP,
             (select sum(decode(c.jaqz517cod, 61, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                561,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (61, 561)) beneficios_sociales,
             (select sum(decode(c.jaqz517cod, 62, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                562,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (62, 562)) reservas,
             (select sum(decode(c.jaqz517cod, 63, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                563,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (63, 563)) otros_pasiv_nocorri,
             (select sum(decode(c.jaqz517cod, 64, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                564,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (64, 564)) tot_pasiv_nocorri,
             (select sum(decode(c.jaqz517cod, 65, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                565,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (65, 565)) total_pasivo,
             (select sum(decode(c.jaqz517cod, 66, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                566,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (66, 566)) capital,
             (select sum(decode(c.jaqz517cod, 67, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                567,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (67, 567)) result_acumulad,
             (select sum(decode(c.jaqz517cod, 68, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                568,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (68, 568)) result_ejercici,
             (select sum(decode(c.jaqz517cod, 69, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                569,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (69, 569)) otros_patrim,
             (select sum(decode(c.jaqz517cod, 70, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                570,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (70, 570)) total_patrimonio,
             (select sum(decode(c.jaqz517cod, 71, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                571,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (71, 571)) total_pasivo_patrimonio,
             (select sum(decode(c.jaqz517cod, 73, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                573,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (73, 573)) venta,
             (select sum(decode(c.jaqz517cod, 74, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                574,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (74, 574)) costo_venta,
             (select sum(decode(c.jaqz517cod, 75, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                575,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (75, 575)) utilid_bruta,
             (select sum(decode(c.jaqz517cod, 76, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                576,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (76, 576)) gastos_ventas, --costo_operativo,    
             (select sum(decode(c.jaqz517cod, 77, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                577,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (77, 577)) gasto_administrativo,
             (select sum(decode(c.jaqz517cod, 78, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                578,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (78, 578)) utilid_operativa,
             (select sum(decode(c.jaqz517cod, 79, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                579,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (79, 579)) Gastos_financieros, --servicio_deuda,
             (select sum(decode(c.jaqz517cod, 80, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                580,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (80, 580)) ingres_financieros,
             (select sum(decode(c.jaqz517cod, 81, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                581,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (81, 581)) gastos_diversos,
             (select sum(decode(c.jaqz517cod, 82, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                582,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (82, 582)) utilid_antes_impuestos,
             (select sum(decode(c.jaqz517cod, 83, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                583,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (83, 583)) impuestos,
             (select sum(decode(c.jaqz517cod, 84, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                584,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (84, 584)) utilidad_neta,
             (select sum(decode(c.jaqz517cod, 89, c.jaqz517mto, 0) +
                         decode(c.jaqz517cod,
                                589,
                                c.jaqz517mto *
                                fn_tipo_cambio_fijo(g021.jaqz516fec),
                                0))
                from jaqz517 c
               where c.jaqz517eval = g021.jaqz516eval
                 and c.jaqz517cod in (89, 589)) cuentas_pagar,
             g021.jaqz516fec EvalReciente
      
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
      
        from jaqz516 g021
       where g021.jaqz516sol = instancia;
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
    -- *****************************************************************
    -- Nombre                     : sp_analisisfinancieroCredConsumo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca el analisis financiero
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                              
    auxTmod    number(4);
    ln_ModInst number;
    FecActu    DATE;
    flgExisM400    varchar2(1);
  BEGIN
    BEGIN          
      SELECT PGFAPE INTO FecActu FROM FST017 WHERE PGCOD = 1; --01/04/2023
    EXCEPTION 
      WHEN OTHERS THEN
        NULL;
    END;
      
    BEGIN
       SELECT 'S' INTO flgExisM400 FROM JAQM400 WHERE JAQM400INS = instancia AND JAQM400FEC = FecActu AND ROWNUM = 1;
    EXCEPTION 
      WHEN OTHERS THEN
        NULL;
    END;
    flgExisM400 := NVL(flgExisM400, 'N');
        
    /*BEGIN
      select jaqz516TMOD
        INTO auxTmod
        from jaqz516
       where jaqz516SOL = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        auxTmod := 0;
    END;*/
  
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
        FROM JAQZ821B --newcrm
       WHERE JAQZ821INST = instancia
         AND JAQZ821EST = 'H';
      --AND JAQZ821TAREA = 7;
    EXCEPTION
      WHEN OTHERS THEN
        ResuRatiCuExceNetEvlRec := 0;
    END;
    IF ResuRatiCuExceNetEvlRec <> 0 THEN
      ResuRatiCuExceNetEvlRec := ResuRatiCuExceNetEvlRec * 100;
    END IF;
  
    IF flgExisM400 = 'S' THEN --auxTmod = 14 OR flgExisM400 = 'S' THEN 01042024
      BEGIN
        select --g021.jaqz516eval,               
          (select sum(decode(c.JAQM400cod, 1, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      501,
                      c.jaqm400mon *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (1, 501)) ingr_brutos_titular,
                         
          (select sum(decode(c.JAQM400cod, 2, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      502,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (2, 502)) ingr_brutos_conyuge,
                         
          (select sum(decode(c.JAQM400cod, 3, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      503,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (3, 503)) ingr_brutos_comisiones,
                         
          (select sum(decode(c.JAQM400cod, 4, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      504,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (4, 504)) ingr_brutos_otros,
          ---
          (select sum(decode(c.JAQM400cod, 5, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      505,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (5, 505)) AporteTitu,
                         
          (select sum(decode(c.JAQM400cod, 6, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      506,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (6, 506)) AporteConyu,
                         
          (select sum(decode(c.JAQM400cod, 7, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      507,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (7, 507)) AporteComisiones,
                         
          (select sum(decode(c.JAQM400cod, 8, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      508,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (8, 508)) AporteOtros,
                         
          (select sum(decode(c.JAQM400cod, 9, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      509,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (9, 509)) OtroIngsTitul,
                         
          (select sum(decode(c.JAQM400cod, 10, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      510,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (10, 510)) OtroIngsConyu,
                         
          (select sum(decode(c.JAQM400cod, 11, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      511,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (11, 511)) OtroIngsComisiones,
                         
          (select sum(decode(c.JAQM400cod, 12, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      512,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (12, 512)) OtroIngsOtros,
                         
          ------                                                                   
          (select sum(decode(c.JAQM400cod, 21, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      521,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (21, 521)) ingr_netos_totales,
                         
          (select sum(decode(c.JAQM400cod, 13, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      513,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (13, 513)) egr_alimentacion,
                         
          (select sum(decode(c.JAQM400cod, 14, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      514,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (14, 514)) egr_alquiler,
                         
          (select sum(decode(c.JAQM400cod, 15, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      515,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (15, 515)) egr_transporte,
                         
          (select sum(decode(c.JAQM400cod, 16, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      516,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (16, 516)) egr_educacion,
                         
          (select sum(decode(c.JAQM400cod, 17, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      517,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (17, 517)) egr_servicios,
                         
          (select sum(decode(c.JAQM400cod, 18, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      518,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (18, 518)) egr_apfamiliar,
                         
          (select sum(decode(c.JAQM400cod, 20, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      520,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (20, 520)) egr_otros,
                         
          (select sum(decode(c.JAQM400cod, 19, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      519,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (19, 519)) gastos_financieros,
                         
          (select sum(decode(c.JAQM400cod, 26, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      526,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (26, 526)) cuota_cred_propueso,
                         
          (select sum(decode(c.JAQM400cod, 27, c.JAQM400MON, 0) +
               decode(c.JAQM400cod,
                      527,
                      c.JAQM400MON *
                      fn_tipo_cambio_fijo(g021.jaqm400fec),
                      0))
          from JAQM400 c
          where c.jaqm400ins = g021.jaqm400ins and c.JAQM400FEC = g021.jaqm400fec
          and c.JAQM400cod in (27, 527)) exedente_neto,
          g021.jaqm400fec EvalReciente
                  
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
          FechEvalReConsum
                  
          from JAQM400 g021
          where g021.JAQM400INS = instancia and g021.JAQM400FEC = FecActu and rownum < 2;
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
            FROM XWF700 A, JAQZ822B B --newcrm
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
             and b.jaqz822nrcuo > 1;
          --AND b.JAQZ822TAREA = 7;
        EXCEPTION
          WHEN OTHERS THEN
            CuotCredProp := 0;
        END;
      else
        if ln_ModInst = 117 then
          BEGIN
            SELECT JAQZ822CAPCUO
              INTO CuotCredProp
              FROM XWF700 A, JAQZ822B B
             WHERE A.XWFEMPRESA = B.JAQZ822PGCOD
               AND A.XWFSUCURSAL = B.JAQZ822SUC
               AND A.XWFCUENTA = B.JAQZ822CTA
               AND A.XWFOPERACION = B.JAQZ822OPE
               AND A.XWFPRCINS = B.JAQZ822INST
               AND A.XWFTIPOPE = B.JAQZ822TOPE
               AND A.XWFPRCINS = instancia
               AND A.XWFCAR3 = '1'
               AND B.JAQZ822EST = 'H';
            --AND b.JAQZ822TAREA = 7;
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
                                    nroINTipoCN              number,  --30042024
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
    -- *****************************************************************
    -- Nombre                     : sp_AnlFinancEvalAnterio
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca la evaluacion anterior
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                     
  
    auxPais            number(3);
    auxPetdoc          number(3);
    auxPendoc          varchar2(12);
    auxInstnc          number(10);
    cuenta             number(9);
    auxTmod            number(4);
    ln_evalflujo       varchar2(1);
    ln_evalflujoActual varchar2(1);
    fechaAnteM400 date;
    FechActual date;
    Indicflujo         VARCHAR2(3);
    fechAntOut         DATE;
    TipFlujCN          VARCHAR2(1);    

    nroOUTTipoCN          number(1);
    norm_crm_resulta_neto            number(17,2); 
    norm_crm_disponible              number(17,2); 
    norm_crm_ctxcbr                  number(17,2); 
    norm_crm_MERCADERIA              number(17,2);   
    norm_crm_GASTOS_ANTICIPADOS      number(17,2); 
    norm_crm_EXISTENCIAS_RECIBIR     number(17,2); 
    norm_crm_otros_actv_corr         number(17,2);  
    norm_crm_total_actv_corr         number(17,2); 
    norm_crm_MUEBLES                 number(17,2); 
    norm_crm_INMUEBLES               number(17,2); 
    norm_crm_otros_actv_fijo         number(17,2); 
    norm_crm_tot_actv_fijo           number(17,2);
    norm_crm_xtotal_activ            number(17,2); 
    norm_crm_OTROS_INGRESOS          number(17,2); 
    norm_crm_GASTOS_FAMILIARES       number(17,2); 
    norm_crm_CUENTAS_BANCO           number(17,2); 
    norm_crm_TRIBUTO_PAGAR           number(17,2); 
    norm_crm_xotros_pasiv_corr       number(17,2); 
    norm_crm_xtotal_pasiv_corr       number(17,2); 
    norm_crm_CUENTAS_BANCOLP         number(17,2); 
    norm_crm_BENEFICIOS_SOCIALES     number(17,2); 
    norm_crm_xreservas               number(17,2); 
    norm_crm_xotros_pasiv_nocorri    number(17,2); 
    norm_crm_xtot_pasiv_nocorri      number(17,2); 
    norm_crm_xtotal_pasivo           number(17,2); 
    norm_crm_xcapital                number(17,2); 
    norm_crm_xresult_acumulad        number(17,2); 
    norm_crm_xresult_ejercici        number(17,2); 
    norm_crm_xotros_patrim           number(17,2); 
    norm_crm_xtotal_patrimonio        number(17,2); 
    norm_crm_xtotal_pasivo_patrimonio number(17,2);
    norm_crm_VENTA                    number(17,2);
    norm_crm_COSTO_VENTA              number(17,2);
    norm_crm_xutilid_bruta            number(17,2);
    norm_crm_COSTO_OPERATIVO          number(17,2);
    norm_crm_Gastos_administd         number(17,2);
    norm_crm_xutilid_operativa        number(17,2);
    norm_crm_SERVICIO_DEUDA           number(17,2);
    norm_crm_xingres_financieros      number(17,2);
    norm_crm_xgastos_diversos         number(17,2);
    norm_crm_xutilid_antes_impuestos  number(17,2);
    norm_crm_ximpuestos               number(17,2);
    norm_crm_xutilidad_neta           number(17,2);
    norm_crm_CUENTAS_PAGAR            number(17,2);
    norm_crm_FechEvalRec              date;
    norm_crm_ResultRatioEvalAnterior  number(17,6); 


  BEGIN


    BEGIN
      SELECT PGFAPE INTO FechActual FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT jaqz516TMOD
        INTO auxTmod
        FROM jaqz516 
       WHERE jaqz516SOL = instancia
       and  jaqz516fec = FechActual;
    EXCEPTION
      WHEN OTHERS THEN
        auxTmod := 0;
    END;
  
    /*pq_cr_repo_opini_riesgos_crm.sp_obtner_Instanci_anterior(instancia => instancia, --2908
                                                             auxInstnc => auxInstnc,
                                                             fechaAnteM400 => fechaAnteM400);*/
    TipFlujCN := 'C';                                                             
    IF nroINTipoCN <> 1 THEN  --2 CRM, 1 NORMAL 30042024                                                              
       Indicflujo := 'CRM';
       BEGIN
       pq_cr_repo_opinion_riesgos.sp_obtner_Instanci_anterior(instancia => instancia,  --30042024
                                                             Indicflujo => Indicflujo,          
                                                             auxInstnc => auxInstnc,
                                                             fechAntOut => fechaAnteM400,
                                                             TipFlujCN => TipFlujCN); 
      EXCEPTION 
        WHEN OTHERS THEN
          NULL;
      END;                                                               
    END IF;   
    
    IF nroINTipoCN = 1 THEN --30042024
       auxInstnc := instancia;
    END IF;                                                                                                                       
    
    IF TipFlujCN = 'C' THEN     
        IF AUXTMOD = 13 THEN
          BEGIN
            SELECT JAQY140RATIO
              INTO ResultRatioEvalAnterior
              FROM JAQY140B --newcrm
             WHERE JAQY140INST = auxInstnc
               AND JAQY140EST = 'H';
            --AND JAQY140TAREA = 7;
          EXCEPTION
            WHEN OTHERS THEN
              ResultRatioEvalAnterior := 0;
          END;
        
          -- instancia actual
          BEGIN
            --identificar si la solicitud tiene evaluacion por flujo 30062023
            -- Call the procedure
            pq_cr_ratio_evalflujo.sp_cr_verfevalflujo(instancia,
                                                      ln_evalflujoActual);
          EXCEPTION
            WHEN OTHERS THEN
              ln_evalflujoActual := 'N';
          END;
        
          ln_evalflujo := 'N'; -- INI 30062023
          BEGIN
            --identificar si la solicitud tiene evaluacion por flujo 30062023
            -- Call the procedure
            pq_cr_ratio_evalflujo.sp_cr_verfevalflujo(auxInstnc, ln_evalflujo);
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
              FROM JAQZ821B --newcrm
             WHERE JAQZ821INST = auxInstnc
               AND JAQZ821EST = 'H';
            --AND JAQZ821TAREA = 7;
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
            select --g021.jaqz516eval,
                   (select sum(decode(c.jaqz517cod, 40, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      540,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (40, 540)) resultado_Neto,
                   (select sum(decode(c.jaqz517cod, 41, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      541,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (41, 541)) Caja_bancos, --disponible,
                   (select sum(decode(c.jaqz517cod, 42, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      542,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (42, 542)) cuentas_cobrar_comerci,
                   (select sum(decode(c.jaqz517cod, 43, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      543,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (43, 543)) mercaderia,
                   (select sum(decode(c.jaqz517cod, 44, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      544,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (44, 544)) gastos_anticipados,
                   (select sum(decode(c.jaqz517cod, 45, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      545,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (45, 545)) existencias_recibir,
                   (select sum(decode(c.jaqz517cod, 46, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      546,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (46, 546)) otros_act_corri,
                   (select sum(decode(c.jaqz517cod, 47, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      547,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (47, 547)) total_actv_corri,
                   (select sum(decode(c.jaqz517cod, 48, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      548,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (48, 548)) muebles,
                   (select sum(decode(c.jaqz517cod, 49, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      549,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (49, 549)) inmuebles,
                   (select sum(decode(c.jaqz517cod, 50, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      550,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (50, 550)) otros_act_fijo,
                   (select sum(decode(c.jaqz517cod, 51, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      551,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (51, 551)) total_activ_fijo,
                   (select sum(decode(c.jaqz517cod, 52, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      552,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (52, 552)) total_activ,
                   (select sum(decode(c.jaqz517cod, 53, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      553,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (53, 553)) otros_ingreso,
                   (select sum(decode(c.jaqz517cod, 54, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      554,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (54, 554)) gastos_familiares,
                   (select sum(decode(c.jaqz517cod, 56, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      556,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (56, 556)) cuentas_banco,
                   (select sum(decode(c.jaqz517cod, 57, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      557,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (57, 557)) tributo_pagar,
                   (select sum(decode(c.jaqz517cod, 58, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      558,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (58, 558)) otros_pasiv_corr,
                   (select sum(decode(c.jaqz517cod, 59, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      559,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (59, 559)) total_pasiv_corr,
                   (select sum(decode(c.jaqz517cod, 60, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      560,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (60, 560)) cuentas_bancoLP,
                   (select sum(decode(c.jaqz517cod, 61, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      561,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (61, 561)) beneficios_sociales,
                   (select sum(decode(c.jaqz517cod, 62, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      562,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (62, 562)) reservas,
                   (select sum(decode(c.jaqz517cod, 63, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      563,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (63, 563)) otros_pasiv_nocorri,
                   (select sum(decode(c.jaqz517cod, 64, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      564,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (64, 564)) tot_pasiv_nocorri,
                   (select sum(decode(c.jaqz517cod, 65, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      565,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (65, 565)) total_pasivo,
                   (select sum(decode(c.jaqz517cod, 66, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      566,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (66, 566)) capital,
                   (select sum(decode(c.jaqz517cod, 67, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      567,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (67, 567)) result_acumulad,
                   (select sum(decode(c.jaqz517cod, 68, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      568,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (68, 568)) result_ejercici,
                   (select sum(decode(c.jaqz517cod, 69, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      569,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (69, 569)) otros_patrim,
                   (select sum(decode(c.jaqz517cod, 70, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      570,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (70, 570)) total_patrimonio,
                   (select sum(decode(c.jaqz517cod, 71, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      571,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (71, 571)) total_pasivo_patrimonio,
                   (select sum(decode(c.jaqz517cod, 73, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      573,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (73, 573)) venta,
                   (select sum(decode(c.jaqz517cod, 74, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      574,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (74, 574)) costo_venta,
                   (select sum(decode(c.jaqz517cod, 75, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      575,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (75, 575)) utilid_bruta,
                   (select sum(decode(c.jaqz517cod, 76, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      576,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (76, 576)) gastos_ventas, --costo_operativo,    
                   (select sum(decode(c.jaqz517cod, 77, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      577,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (77, 577)) gasto_administrativo,
                   (select sum(decode(c.jaqz517cod, 78, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      578,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (78, 578)) utilid_operativa,
                   (select sum(decode(c.jaqz517cod, 79, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      579,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (79, 579)) Gastos_financieros, --servicio_deuda,
                   (select sum(decode(c.jaqz517cod, 80, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      580,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (80, 580)) ingres_financieros,
                   (select sum(decode(c.jaqz517cod, 81, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      581,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (81, 581)) gastos_diversos,
                   (select sum(decode(c.jaqz517cod, 82, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      582,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (82, 582)) utilid_antes_impuestos,
                   (select sum(decode(c.jaqz517cod, 83, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      583,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (83, 583)) impuestos,
                   (select sum(decode(c.jaqz517cod, 84, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      584,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (84, 584)) utilidad_neta,
                   (select sum(decode(c.jaqz517cod, 89, c.jaqz517mto, 0) +
                               decode(c.jaqz517cod,
                                      589,
                                      c.jaqz517mto *
                                      fn_tipo_cambio_fijo(g021.jaqz516fec),
                                      0))
                      from jaqz517 c
                     where c.jaqz517eval = g021.jaqz516eval
                       and c.jaqz517cod in (89, 589)) cuentas_pagar,
                   g021.jaqz516fec EvalReciente
            
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
              from jaqz516 g021
             where g021.jaqz516sol = auxInstnc;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
    ELSE ----si la eval anterior es NORMAL llamar proc. 30042024
       IF TipFlujCN = 'N' THEN
        nroOUTTipoCN := 2;
        BEGIN 
		    pq_cr_repo_opinion_riesgos.sp_AnlFinancEvalAnterio( auxInstnc                ,
                                                            nroOUTTipoCN              ,
                                                            norm_crm_resulta_neto            ,
                                                            norm_crm_disponible              ,
                                                            norm_crm_ctxcbr                  ,
                                                            norm_crm_MERCADERIA              ,
                                                            norm_crm_GASTOS_ANTICIPADOS      ,
                                                            norm_crm_EXISTENCIAS_RECIBIR     ,
                                                            norm_crm_otros_actv_corr         ,
                                                            norm_crm_total_actv_corr         ,
                                                            norm_crm_MUEBLES                 ,
                                                            norm_crm_INMUEBLES               ,
                                                            norm_crm_otros_actv_fijo         ,
                                                            norm_crm_tot_actv_fijo           ,
                                                            norm_crm_xtotal_activ            ,
                                                            norm_crm_OTROS_INGRESOS          ,
                                                            norm_crm_GASTOS_FAMILIARES       ,
                                                            norm_crm_CUENTAS_BANCO           ,
                                                            norm_crm_TRIBUTO_PAGAR           ,
                                                            norm_crm_xotros_pasiv_corr       ,
                                                            norm_crm_xtotal_pasiv_corr       ,
                                                            norm_crm_CUENTAS_BANCOLP         ,
                                                            norm_crm_BENEFICIOS_SOCIALES     ,
                                                            norm_crm_xreservas               ,
                                                            norm_crm_xotros_pasiv_nocorri    ,
                                                            norm_crm_xtot_pasiv_nocorri      ,
                                                            norm_crm_xtotal_pasivo           ,
                                                            norm_crm_xcapital                ,
                                                            norm_crm_xresult_acumulad        ,
                                                            norm_crm_xresult_ejercici        ,
                                                            norm_crm_xotros_patrim           ,
                                                            norm_crm_xtotal_patrimonio       ,
                                                            norm_crm_xtotal_pasivo_patrimonio,
                                                            norm_crm_VENTA                   ,
                                                            norm_crm_COSTO_VENTA             ,
                                                            norm_crm_xutilid_bruta           ,
                                                            norm_crm_COSTO_OPERATIVO         ,
                                                            norm_crm_Gastos_administd        ,
                                                            norm_crm_xutilid_operativa       ,
                                                            norm_crm_SERVICIO_DEUDA          ,
                                                            norm_crm_xingres_financieros     ,
                                                            norm_crm_xgastos_diversos        ,
                                                            norm_crm_xutilid_antes_impuestos ,
                                                            norm_crm_ximpuestos              ,
                                                            norm_crm_xutilidad_neta          ,
                                                            norm_crm_CUENTAS_PAGAR           ,
                                                            norm_crm_FechEvalRec             ,
                                                            norm_crm_ResultRatioEvalAnterior ); 
        EXCEPTION
          WHEN OTHERS THEN
            NULL; 
        END;                                                           
                                                            
        resulta_neto             := norm_crm_resulta_neto              ;									
        disponible               := norm_crm_disponible                ;
        ctxcbr                   := norm_crm_ctxcbr                    ;
        MERCADERIA               := norm_crm_MERCADERIA                ;
        GASTOS_ANTICIPADOS       := norm_crm_GASTOS_ANTICIPADOS        ;
        EXISTENCIAS_RECIBIR      := norm_crm_EXISTENCIAS_RECIBIR       ;
        otros_actv_corr          := norm_crm_otros_actv_corr           ;
        total_actv_corr          := norm_crm_total_actv_corr           ;
        MUEBLES                  := norm_crm_MUEBLES                   ;
        INMUEBLES                := norm_crm_INMUEBLES                 ;
        otros_actv_fijo          := norm_crm_otros_actv_fijo           ;
        tot_actv_fijo            := norm_crm_tot_actv_fijo             ;
        xtotal_activ             := norm_crm_xtotal_activ              ;
        OTROS_INGRESOS           := norm_crm_OTROS_INGRESOS            ;
        GASTOS_FAMILIARES        := norm_crm_GASTOS_FAMILIARES         ;
        CUENTAS_BANCO            := norm_crm_CUENTAS_BANCO             ;
        TRIBUTO_PAGAR            := norm_crm_TRIBUTO_PAGAR             ;
        xotros_pasiv_corr        := norm_crm_xotros_pasiv_corr         ;
        xtotal_pasiv_corr        := norm_crm_xtotal_pasiv_corr         ;
        CUENTAS_BANCOLP          := norm_crm_CUENTAS_BANCOLP           ;
        BENEFICIOS_SOCIALES      := norm_crm_BENEFICIOS_SOCIALES       ;
        xreservas                := norm_crm_xreservas                 ;
        xotros_pasiv_nocorri     := norm_crm_xotros_pasiv_nocorri      ;
        xtot_pasiv_nocorri       := norm_crm_xtot_pasiv_nocorri        ;
        xtotal_pasivo            := norm_crm_xtotal_pasivo             ;
        xcapital                 := norm_crm_xcapital                  ;
        xresult_acumulad         := norm_crm_xresult_acumulad          ;
        xresult_ejercici         := norm_crm_xresult_ejercici          ;
        xotros_patrim            := norm_crm_xotros_patrim             ;
        xtotal_patrimonio        := norm_crm_xtotal_patrimonio         ;
        xtotal_pasivo_patrimonio := norm_crm_xtotal_pasivo_patrimonio  ;
        VENTA                    := norm_crm_VENTA                     ;
        COSTO_VENTA              := norm_crm_COSTO_VENTA               ;
        xutilid_bruta            := norm_crm_xutilid_bruta             ;
        COSTO_OPERATIVO          := norm_crm_COSTO_OPERATIVO           ;
        Gastos_administd         := norm_crm_Gastos_administd          ;
        xutilid_operativa        := norm_crm_xutilid_operativa         ;
        SERVICIO_DEUDA           := norm_crm_SERVICIO_DEUDA            ;
        xingres_financieros      := norm_crm_xingres_financieros       ;
        xgastos_diversos         := norm_crm_xgastos_diversos          ;
        xutilid_antes_impuestos  := norm_crm_xutilid_antes_impuestos   ;
        ximpuestos               := norm_crm_ximpuestos                ;
        xutilidad_neta           := norm_crm_xutilidad_neta            ;
        CUENTAS_PAGAR            := norm_crm_CUENTAS_PAGAR             ;
        FechEvalRec              := norm_crm_FechEvalRec               ;
        ResultRatioEvalAnterior  := norm_crm_ResultRatioEvalAnterior   ;                                                                                                                                                                            
        END IF;
    END IF; 
  END;

  procedure sp_AnlFinancEvalAnterioConsumo(instancia               number, --08052023
                                           nroINTipoCN             number,
                                           p_fechaCrmM400          date,
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
    -- *****************************************************************
    -- Nombre                     : sp_AnlFinancEvalAnterioConsumo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca la evaluacion anterior
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                            
    auxPais    number(3);
    auxPetdoc  number(3);
    auxPendoc  varchar2(12);
    auxInstnc  number(10);
    cuenta     number(9);
    auxTmod    number(4);
    ln_ModInst number;
    fechaAnteM400 date;
    TipFlujCN  varchar2(1); 
    fechAntOut date;
    Indicflujo varchar2(3);

    --NORMAL
    nroOUTipoCN                 NUMBER(1); 
    norm_IngBrutTitu            NUMBER(17,2);							
    norm_IngBrutConyu           NUMBER(17,2);
    norm_IngBrutComis           NUMBER(17,2);
    norm_IngBrutOtros           NUMBER(17,2);
    norm_xAporteTitul           NUMBER(17,2);
    norm_xAporteConyu           NUMBER(17,2);
    norm_xAporteComisi          NUMBER(17,2);
    norm_xAporteOtros           NUMBER(17,2);
    norm_xOtroIngTitu           NUMBER(17,2);
    norm_xOtroIngConyu          NUMBER(17,2);
    norm_xOtroIngComis          NUMBER(17,2);
    norm_xOtroIngOtros          NUMBER(17,2);
    norm_IngNetoTotal           NUMBER(17,2);
    norm_EgrAlimentac           NUMBER(17,2);
    norm_EgrAlquiler            NUMBER(17,2);
    norm_EgrTranspor            NUMBER(17,2);
    norm_EgrEducacio            NUMBER(17,2);
    norm_EgrServicio            NUMBER(17,2);
    norm_EgrAporFami            NUMBER(17,2);
    norm_EgrOtros               NUMBER(17,2);
    norm_GastFinancier          NUMBER(17,2);
    norm_CuotCredProp           NUMBER(17,2);
    norm_ExcedNetoMen           NUMBER(17,2);
    norm_FechEvalAnterConsum    DATE;
    norm_ResuRatiCuIngNetEvlAnt NUMBER(17,2);
    norm_ResuRatiCuExceNetEvlAnt NUMBER(17,2); 

  BEGIN
    TipFlujCN := 'C';
    IF nroINTipoCN <> 1 THEN
    -- obtener instancia anterior
      /*pq_cr_repo_opini_riesgos_crm.sp_obtner_Instanci_anterior(instancia => instancia, --2908
                                                             auxInstnc => auxInstnc,
                                                             fechaAnteM400 => fechaAnteM400);*/
      Indicflujo := 'CRM';      
      BEGIN
      pq_cr_repo_opinion_riesgos.sp_obtner_Instanci_anterior(instancia => instancia,
                                                             Indicflujo => Indicflujo,             
                                                             auxInstnc => auxInstnc,
                                                             fechAntOut => fechAntOut,
                                                             TipFlujCN => TipFlujCN); 
      fechaAnteM400 :=  fechAntOut;
     EXCEPTION
      WHEN OTHERS THEN
        NULL;
     END;     
                                                                                                                               
    END IF; 
    IF nroINTipoCN = 1 THEN --30042024
       auxInstnc := instancia;  
       fechaAnteM400 := p_fechaCrmM400;                                                             
    END IF;                                                             
  
    IF TipFlujCN = 'C' THEN --30042024 
      BEGIN
        SELECT JAQZ821RATIO
          INTO ResuRatiCuExceNetEvlAnt
          FROM JAQZ821B --newcrm
         WHERE JAQZ821INST = auxInstnc
           AND JAQZ821EST = 'H';
        --AND JAQZ821TAREA = 7;
      EXCEPTION
        WHEN OTHERS THEN
          ResuRatiCuExceNetEvlAnt := 0;
      END;
    --END IF;
  
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
         select --g021.jaqz516eval,               
            (select sum(decode(c.JAQM400COD, 1, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          501,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (1, 501)) ingr_brutos_titular,
                           
            (select sum(decode(c.JAQM400COD, 2, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          502,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (2, 502)) ingr_brutos_conyuge,
                           
            (select sum(decode(c.JAQM400COD, 3, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          503,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (3, 503)) ingr_brutos_comisiones,
                           
            (select sum(decode(c.JAQM400COD, 4, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          504,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (4, 504)) ingr_brutos_otros,
            ---
            (select sum(decode(c.JAQM400COD, 5, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          505,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (5, 505)) AporteTitu,
                           
            (select sum(decode(c.JAQM400COD, 6, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          506,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (6, 506)) AporteConyu,
                           
            (select sum(decode(c.JAQM400COD, 7, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          507,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (7, 507)) AporteComisiones,
                           
            (select sum(decode(c.JAQM400COD, 8, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          508,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (8, 508)) AporteOtros,
            --   
            (select sum(decode(c.JAQM400COD, 9, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          509,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (9, 509)) OtroIngsTitul,
                           
            (select sum(decode(c.JAQM400COD, 10, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          510,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (10, 510)) OtroIngsConyu,
                           
            (select sum(decode(c.JAQM400COD, 11, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          511,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (11, 511)) OtroIngsComisiones,
                           
            (select sum(decode(c.JAQM400COD, 12, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          512,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (12, 512)) OtroIngsOtros,
            ------                                                     
                           
            (select sum(decode(c.JAQM400COD, 21, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          521,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (21, 521)) ingr_netos_totales,
                           
            (select sum(decode(c.JAQM400COD, 13, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          513,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (13, 513)) egr_alimentacion,
                           
            (select sum(decode(c.JAQM400COD, 14, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          514,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (14, 514)) egr_alquiler,
                           
            (select sum(decode(c.JAQM400COD, 15, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          515,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (15, 515)) egr_transporte,
                           
            (select sum(decode(c.JAQM400COD, 16, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          516,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (16, 516)) egr_educacion,
                           
            (select sum(decode(c.JAQM400COD, 17, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          517,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (17, 517)) egr_servicios,
                           
            (select sum(decode(c.JAQM400COD, 18, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          518,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (18, 518)) egr_apfamiliar,
                           
            (select sum(decode(c.JAQM400COD, 20, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          520,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (20, 520)) egr_otros,
                           
            (select sum(decode(c.JAQM400COD, 19, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          519,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (19, 519)) gastos_financieros,
                           
            (select sum(decode(c.JAQM400COD, 26, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          526,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (26, 526)) cuota_cred_propueso,
                           
            (select sum(decode(c.JAQM400COD, 27, c.JAQM400MON, 0) +
                   decode(c.JAQM400COD,
                          527,
                          c.JAQM400MON *
                          fn_tipo_cambio_fijo(g021.jaqm400fec),
                          0))
            from jaqM400 c
            where c.jaqm400ins = g021.JAQM400INS and c.JAQM400FEC = g021.JAQM400FEC 
            and c.JAQM400COD in (27, 527)) exedente_neto,
            g021.JAQM400FEC EvalReciente
                    
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
            from JAQM400 g021
            where g021.JAQM400INS = auxInstnc and g021.JAQM400FEC = fechaAnteM400 and rownum < 2;
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
            FROM XWF700 A, JAQZ822B B
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
             and b.jaqz822nrcuo > 1;
          --AND b.JAQZ822TAREA = 7;
        EXCEPTION
          WHEN OTHERS THEN
            CuotCredProp := 0;
        END;
      else
        if ln_ModInst = 117 then
          BEGIN
            SELECT JAQZ822CAPCUO
              INTO CuotCredProp
              FROM XWF700 A, JAQZ822B B --necrm
             WHERE A.XWFEMPRESA = B.JAQZ822PGCOD
               AND A.XWFSUCURSAL = B.JAQZ822SUC
               AND A.XWFCUENTA = B.JAQZ822CTA
               AND A.XWFOPERACION = B.JAQZ822OPE
               AND A.XWFPRCINS = B.JAQZ822INST
               AND A.XWFTIPOPE = B.JAQZ822TOPE
               AND A.XWFPRCINS = auxInstnc
               AND A.XWFCAR3 = '1'
               AND B.JAQZ822EST = 'H'
               AND ROWNUM = 1;
          EXCEPTION
            WHEN OTHERS THEN
              CuotCredProp := 0;
          END;
          CuotCredProp := nvl(CuotCredProp, 0);
        
        end if;
      end if;
    END IF;
    ELSE --CASO Q inst anter NORMAL
       IF TipFlujCN = 'N' THEN
        nroOUTipoCN := 2; 
        pq_cr_repo_opinion_riesgos.sp_AnlFinancEvalAnterioConsumo(auxInstnc               ,
                                                                  nroOUTipoCN             ,
                                                                  norm_IngBrutTitu             ,
                                                                  norm_IngBrutConyu            ,
                                                                  norm_IngBrutComis            ,
                                                                  norm_IngBrutOtros            ,
                                                                  norm_xAporteTitul            ,
                                                                  norm_xAporteConyu            ,
                                                                  norm_xAporteComisi           ,
                                                                  norm_xAporteOtros            ,
                                                                  norm_xOtroIngTitu            ,
                                                                  norm_xOtroIngConyu           ,
                                                                  norm_xOtroIngComis           ,
                                                                  norm_xOtroIngOtros           ,
                                                                  norm_IngNetoTotal            ,
                                                                  norm_EgrAlimentac            ,
                                                                  norm_EgrAlquiler             ,
                                                                  norm_EgrTranspor             ,
                                                                  norm_EgrEducacio             ,
                                                                  norm_EgrServicio             ,
                                                                  norm_EgrAporFami             ,
                                                                  norm_EgrOtros                ,
                                                                  norm_GastFinancier           ,
                                                                  norm_CuotCredProp            ,
                                                                  norm_ExcedNetoMen            ,
                                                                  norm_FechEvalAnterConsum     ,
                                                                  norm_ResuRatiCuIngNetEvlAnt  ,
                                                                  norm_ResuRatiCuExceNetEvlAnt );
        
        
        
        IngBrutTitu             :=  norm_IngBrutTitu             ;     
        IngBrutConyu            :=  norm_IngBrutConyu            ;
        IngBrutComis            :=  norm_IngBrutComis            ;
        IngBrutOtros            :=  norm_IngBrutOtros            ;
        xAporteTitul            :=  norm_xAporteTitul            ;
        xAporteConyu            :=  norm_xAporteConyu            ;
        xAporteComisi           :=  norm_xAporteComisi           ;
        xAporteOtros            :=  norm_xAporteOtros            ;
        xOtroIngTitu            :=  norm_xOtroIngTitu            ;
        xOtroIngConyu           :=  norm_xOtroIngConyu           ;
        xOtroIngComis           :=  norm_xOtroIngComis           ;
        xOtroIngOtros           :=  norm_xOtroIngOtros           ;
        IngNetoTotal            :=  norm_IngNetoTotal            ;
        EgrAlimentac            :=  norm_EgrAlimentac            ;
        EgrAlquiler             :=  norm_EgrAlquiler             ;
        EgrTranspor             :=  norm_EgrTranspor             ;
        EgrEducacio             :=  norm_EgrEducacio             ;
        EgrServicio             :=  norm_EgrServicio             ;
        EgrAporFami             :=  norm_EgrAporFami             ;
        EgrOtros                :=  norm_EgrOtros                ;
        GastFinancier           :=  norm_GastFinancier           ;
        CuotCredProp            :=  norm_CuotCredProp            ;
        ExcedNetoMen            :=  norm_ExcedNetoMen            ;
        FechEvalAnterConsum     :=  norm_FechEvalAnterConsum     ;
        ResuRatiCuIngNetEvlAnt  :=  norm_ResuRatiCuIngNetEvlAnt  ;
        ResuRatiCuExceNetEvlAnt :=  norm_ResuRatiCuExceNetEvlAnt ;        
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
    -- *****************************************************************
    -- Nombre                     : sp_inser_cabec_AQPC156
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Inserta la cabecera
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                    
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
        pq_cr_repo_opini_riesgos_crm.sp_operac_propuesta(auxAQPC156INSTAN,
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
        pq_cr_repo_opini_riesgos_crm.sp_obtenr_usu_AC_GA(auxAQPC156INSTAN,
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
          FROM AQPC818
         WHERE AQPC818CODOPI = codOpinionGenerado
           AND AQPC818INSTAN = auxAQPC156INSTAN
           AND AQPC818ESTAD = 'H';
      EXCEPTION
        WHEN OTHERS THEN
          x_contExist := 0;
      END;
      if x_contExist is null then
        x_contExist := 0;
      end if;
    
      IF x_contExist = 0 THEN
        -- 2108
        BEGIN
          SELECT MAX(AQPC818CORR)
            INTO v_correlativo
            FROM AQPC818
           WHERE AQPC818CODOPI = codOpinionGenerado
             AND AQPC818INSTAN = auxAQPC156INSTAN;
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
            UPDATE AQPC818
               SET AQPC818ESTAD = 'I'
             WHERE AQPC818CODOPI = codOpinionGenerado
               AND AQPC818INSTAN = auxAQPC156INSTAN
               AND AQPC818ESTAD = 'H';
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
        BEGIN
          SELECT T.PGFAPE INTO v_fechaActual FROM FST017 T WHERE PGCOD = 1;
        EXCEPTION
          WHEN OTHERS THEN
            v_fechaActual := TO_DATE(SYSDATE, 'dd/mm/rrrr');
        END;
      
        BEGIN
          INSERT INTO AQPC818
            (AQPC818CODOPI,
             AQPC818FECPRO,
             AQPC818INSTAN,
             AQPC818A,
             AQPC818DE,
             AQPC818ASUNT,
             AQPC818TEXCOM,
             AQPC818CLIEN,
             AQPC818DNI,
             AQPC818ANALIS,
             AQPC818AGENC,
             AQPC818ZONA,
             AQPC818REGIO,
             AQPC818RATGANA,
             AQPC818RATAGEN,
             AQPC818SLDCANA,
             AQPC818SLDCAGE,
             AQPC818SLDCZON,
             AQPC818SLDCREG,
             AQPC818NCLIANA,
             AQPC818NCLIAGE,
             AQPC818NCLIZON,
             AQPC818NCLIREG,
             AQPC818NMORAG,
             AQPC818NMORAN,
             AQPC818NMORZO,
             AQPC818NMOREG,
             AQPC818NVRIESG,
             AQPC818ACTIVID,
             AQPC818PDANA,
             AQPC818PDAGE,
             AQPC818PDZON,
             AQPC818PDREG,
             AQPC818COH4ANA,
             AQPC818COH4AGE,
             AQPC818COH4ZON,
             AQPC818COH4REG,
             AQPC818COH6ANA,
             AQPC818COH6AGE,
             AQPC818COH6ZON,
             AQPC818COH6REG,
             AQPC818SOLIC,
             AQPC818CTNRO,
             AQPC818CALIF,
             AQPC818PRODSBS,
             AQPC818FECEEFF,
             AQPC818FECINFC,
             AQPC818CODTPRO,
             AQPC818TIPPRO,
             AQPC818RESPTOT,
             AQPC818SLDPROP,
             AQPC818MODPRP,
             AQPC818CUOTAS,
             AQPC818CUOPRP,
             AQPC818TASPRP,
             AQPC818TIPSOL,
             AQPC818DETISOL,
             --AQPC818USUREG, -- INI MOD RCASTRO 10072023
             AQPC818USRDER,
             AQPC818ANSERIG, --  FIN MOD RCASTRO 10072023
             AQPC818HORRG,
             AQPC818ESTOP,
             AQPC818NIVEL,
             AQPC818ACTCONT,
             AQPC818USUREG, -- MOD RCASTRO 10072023
             AQPC818GRAGE,
             AQPC818NRECONS,
             AQPC818ESRECON,
             AQPC818CORR, --21082023
             AQPC818ESTAD,
             AQPC818AUX3, --21082023             
             AQPC818TCAMB,
             AQPC818MDAPROP)
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
            UPDATE AQPC818
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
          pq_cr_repo_opini_riesgos_crm.sp_grab_log_aqpc156(codOpinionGenerado,
                                                           auxAQPC156INSTAN);
        END;
        -- ACTUALIZAMOS DATA 
        begin
          UPDATE AQPC818
             SET AQPC818RATGANA = auxAQPC156RATGANA,
                 AQPC818RATAGEN = auxAQPC156RATAGEN,
                 AQPC818SLDCANA = auxAQPC156SLDCANA,
                 AQPC818SLDCAGE = auxAQPC156SLDCAGE,
                 AQPC818SLDCZON = auxAQPC156SLDCZON,
                 AQPC818SLDCREG = auxAQPC156SLDCREG,
                 AQPC818NCLIANA = auxAQPC156NCLIANA,
                 AQPC818NCLIAGE = auxAQPC156NCLIAGE,
                 AQPC818NCLIZON = auxAQPC156NCLIZON,
                 AQPC818NCLIREG = auxAQPC156NCLIREG,
                 AQPC818NMORAG  = auxAQPC156NMORAG,
                 AQPC818NMORAN  = auxAQPC156NMORAN,
                 AQPC818NMORZO  = auxAQPC156NMORZO,
                 AQPC818NMOREG  = auxAQPC156NMOREG,
                 AQPC818NVRIESG = auxAQPC156NVRIESG,
                 AQPC818ACTIVID = auxAQPC156ACTIVID,
                 AQPC818PDANA   = auxAQPC156PDANA,
                 AQPC818PDAGE   = auxAQPC156PDAGE,
                 AQPC818PDZON   = auxAQPC156PDZON,
                 AQPC818PDREG   = auxAQPC156PDREG,
                 AQPC818COH4ANA = auxAQPC156COH4ANA,
                 AQPC818COH4AGE = auxAQPC156COH4AGE,
                 AQPC818COH4ZON = auxAQPC156COH4ZON,
                 AQPC818COH4REG = auxAQPC156COH4REG,
                 AQPC818COH6ANA = auxAQPC156COH6ANA,
                 AQPC818COH6AGE = auxAQPC156COH6AGE,
                 AQPC818COH6ZON = auxAQPC156COH6ZON,
                 AQPC818COH6REG = auxAQPC156COH6REG,
                 AQPC818CALIF   = auxAQPC156CALIF,
                 AQPC818TIPPRO  = auxAQPC156TIPPRO,
                 AQPC818RESPTOT = auxAQPC156RESPTOT,
                 
                 AQPC818TCAMB = v_tipoCambio,
                 
                 AQPC818SLDPROP = v_montoPropu, --auxAQPC156SLDPROP,
                 AQPC818MODPRP  = v_modalidPropu, --auxAQPC156MODPRP,
                 AQPC818CUOTAS  = v_cuotaPropu, --auxcuota,
                 AQPC818CUOPRP  = v_totCuotPropu, --auxQPC156CUOPRP,
                 AQPC818TASPRP  = v_tasaPropu, --auxAQPC156TASPRP,
                 AQPC818MDAPROP = v_monedaPropu,
                 
                 AQPC818USUREG = UsuarioAC,
                 AQPC818GRAGE  = UsuarioGA
          
           WHERE AQPC818CODOPI = codOpinionGenerado
             AND AQPC818INSTAN = auxAQPC156INSTAN
             AND AQPC818ESTAD = 'H'; --2108
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
                                         EsReconsiderac varchar2,
                                         NuevoNivel     number,
                                         flgCambiEst    varchar2,
                                         TipoPropu      varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_actualizar_Datos_Obser156
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Actualiza datos de la cabecera
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                          
  BEGIN
    BEGIN
      pq_cr_repo_opini_riesgos_crm.sp_grab_log_aqpc156(codOpinion,
                                                       instancia);
    END;
  
    BEGIN
      UPDATE AQPC818
         SET --AQPC156A       = txtA,
             --AQPC156DE      = txtDE,
               AQPC818ASUNT = txtAsunto, --0308
             --AQPC156TEXCOM  = txtTextoAdic,
             --AQPC156ANALIS  = txtAnalista,
             --AQPC156DNI     = txtDNI,
             AQPC818ACTIVID = Actividad,
             --AQPC156SOLIC   = solicitud, 24072023
             AQPC818PRODSBS = productoSBS, --03082023
             AQPC818FECEEFF = fechaEEFF,
             AQPC818FECINFC = fechaInfComer,
             AQPC818NIVEL   = NuevoNivel,
             AQPC818TIPPRO  = TipoPropu,
             AQPC818ESRECON = EsReconsiderac
       WHERE AQPC818CODOPI = codOpinion
         AND AQPC818ESTAD = 'H'; --2108
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
    -- *****************************************************************
    -- Nombre                     : sp_obtn_cred_vig_titu
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca los creditos vigentes
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                     
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
  
    v_Pgcod  number(3); --newcrm
    v_Scmod  number(4);
    v_Scsuc  number(4);
    v_Scmda  number(4);
    v_Scpap  number(4);
    v_Sccta  number(9);
    v_Scoper number(9);
    v_Scsbop number(3);
    v_Sctope number(3);
  
    v_auxSbopRepr number(3);
    flgExisteM400 VARCHAR2(1);
    FECHAACT DATE;
  
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
                  and a.modulo not in (120, 29, 144, 33)) or d.aomod = 141); --18/12/2023
  
  BEGIN
    auxContCred := 0;
  
    BEGIN
      -- 2108 VIG
      UPDATE AQPC820
         SET AQPC820ESTAD = 'I'
       WHERE AQPC820CODOPI = auxNrOpinion
         AND (AQPC820ESTAD = 'H' OR AQPC820ESTAD IS NULL);
      --DELETE FROM AQPC820 WHERE AQPC820CODOPI = auxNrOpinion;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    /*xflgEsEvalFluj := 'N';
    
    BEGIN
      -- validar si tiene evaluación por flujo 
      pq_cr_ratio_evalflujo.sp_cr_verfevalflujo(instancia, xflgEsEvalFluj);
    EXCEPTION
      WHEN OTHERS THEN
        xflgEsEvalFluj := 'N';
    END;*/
  
    --SumSldVigent := 0;
    ----obtener crédito a reprogramar para no mostrar en lista de vigentes
    BEGIN
      pq_cr_repo_opini_riesgos_crm.sp_obtener_Credito(instancia,
                                                      v_Pgcod,
                                                      v_Scmod,
                                                      v_Scsuc,
                                                      v_Scmda,
                                                      v_Scpap,
                                                      v_Sccta,
                                                      v_Scoper,
                                                      v_Scsbop,
                                                      v_Sctope);
    END;
  
    FOR XR in CredVigent LOOP
      f_tipoSolic  := '';
      flgLineaVinc := 'N';
    
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
      
      
      --01042024  
      BEGIN
        SELECT PGFAPE INTO FECHAACT FROM FST017 WHERE PGCOD = 1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL; 
      END; 
      flgExisteM400 := 'N';
      BEGIN
        SELECT 'S' into flgExisteM400 FROM JAQM400 W WHERE W.JAQM400INS = instancia AND W.JAQM400FEC = FECHAACT AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;      
      END;
      flgExisteM400 := nvl(flgExisteM400, 'N'); 
      
      IF flgExisteM400 = 'N' THEN     
          BEGIN
            SELECT jaqz516TMOD
              INTO auxModeEval
              FROM jaqz516 w
             WHERE jaqz516SOL = instancia
             and jaqz516fec = FECHAACT;
          EXCEPTION
            WHEN OTHERS THEN
              auxModeEval := 0;
          END;
      ELSE 
          auxModeEval := '14';
      END IF;
    
      --08012024
      /*IF xr.pgcod = v_Pgcod AND xr.aomod = v_Scmod AND xr.aosuc = v_Scsuc AND xr.aomda = v_Scmda AND xr.aopap = v_Scpap AND xr.aocta = v_Sccta AND xr.aooper = v_Scoper AND xr.aosbop = v_Scsbop AND xr.aotope = v_Sctope THEN          
         v_auxSbopRepr := 609;
      ELSE */
      v_auxSbopRepr := XR.AOSBOP;
      --END IF; --08012024
    
      IF auxModeEval = 13 THEN
        BEGIN
          SELECT R.JAQY142CAPCUO
            INTO P_CUOTA
            FROM JAQY142B R --newcrm
           WHERE R.JAQY142INST = instancia
             AND R.JAQY142PGCOD = XR.PGCOD
             AND R.JAQY142MOD = XR.AOMOD
             AND R.JAQY142SUC = XR.AOSUC
             AND R.JAQY142MDA = XR.AOMDA
             AND R.JAQY142PAP = XR.AOPAP
             AND R.JAQY142CTA = XR.AOCTA
             AND R.JAQY142OPE = XR.AOOPER
             AND R.JAQY142SBOP = v_auxSbopRepr --XR.AOSBOP --04012023
             AND R.JAQY142TOPE = XR.AOTOPE
             AND R.JAQY142EST = 'H'
                --AND R.JAQY142TAREA = 7 --26072023
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
              FROM jaqz822B K --newcrm
             WHERE K.JAQZ822INST = instancia
               AND K.JAQZ822PGCOD = XR.PGCOD
               AND K.JAQZ822MOD = XR.AOMOD
               AND K.JAQZ822SUC = XR.AOSUC
               AND K.JAQZ822MDA = XR.AOMDA
               AND K.JAQZ822PAP = XR.AOPAP
               AND K.JAQZ822CTA = XR.AOCTA
               AND K.JAQZ822OPE = XR.AOOPER
               AND K.JAQZ822SBOP = v_auxSbopRepr --XR.AOSBOP 04012023
               AND K.JAQZ822TOPE = XR.AOTOPE
               AND K.JAQZ822EST = 'H'
                  --AND K.JAQZ822TAREA = 7
               AND ROWNUM < 2;
          EXCEPTION
            WHEN OTHERS THEN
              P_CUOTA := 0;
          END;
        END IF;
      END IF;
    
      p_cuota := nvl(p_cuota, 0);
    
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
      
        p_cuota := nvl(p_cuota, 0);
      
      END IF;
    
      if p_cuota = 0 then
        --08012024
        BEGIN
          SELECT (A.PPCAP + A.PPINT + NVL(B.PPIMP1, 0) + NVL(B.PPIMP2, 0) +
                 NVL(B.PPIMP3, 0) + NVL(B.PPIMP4, 0) + NVL(B.PPIMP5, 0) +
                 NVL(B.PPIMP6, 0) + NVL(B.PPIMP7, 0) + NVL(B.PPIMP8, 0) +
                 NVL(B.PPIMP9, 0) + NVL(B.PPIMP10, 0) + NVL(B.PPIMP11, 0) +
                 NVL(B.PPIMP12, 0) + NVL(B.PPIMP13, 0) + NVL(B.PPIMP14, 0) +
                 NVL(B.PPIMP15, 0) + NVL(B.PPIMP16, 0) + NVL(B.PPIMP17, 0) +
                 NVL(B.PPIMP18, 0) + NVL(B.PPIMP19, 0) + NVL(B.PPIMP20, 0)) AS CUOTA_ACTUAL_REPROGRAMACION
            INTO p_cuota
            FROM FSD601 A
            LEFT JOIN FSD611 B
              ON B.PGCOD = A.PGCOD
             AND B.PPMOD = A.PPMOD
             AND B.PPSUC = A.PPSUC
             AND B.PPMDA = A.PPMDA
             AND B.PPPAP = A.PPPAP
             AND B.PPCTA = A.PPCTA
             AND B.PPOPER = A.PPOPER
             AND B.PPSBOP = A.PPSBOP
             AND B.PPTOPE = A.PPTOPE
             AND B.PPFPAG = A.PPFPAG
           WHERE A.PGCOD = XR.PGCOD
             AND A.PPMOD = XR.AOMOD
             AND A.PPSUC = XR.AOSUC
             AND A.PPMDA = XR.AOMDA
             AND A.PPPAP = XR.AOPAP
             AND A.PPCTA = XR.AOCTA
             AND A.PPOPER = XR.AOOPER
             AND A.PPSBOP = v_auxSbopRepr
             AND A.PPTOPE = XR.AOTOPE
             AND A.D601CO = 'S'
             AND NOT EXISTS (SELECT *
                    FROM FSD602
                   WHERE PGCOD = A.PGCOD
                     AND PPMOD = A.PPMOD
                     AND PPSUC = A.PPSUC
                     AND PPMDA = A.PPMDA
                     AND PPPAP = A.PPPAP
                     AND PPCTA = A.PPCTA
                     AND PPOPER = A.PPOPER
                     AND PPSBOP = A.PPSBOP
                     AND PPTOPE = A.PPTOPE
                     AND PPFPAG = A.PPFPAG
                     AND D602CO = 'S'
                     AND PP1STAT = 'T')
             AND ROWNUM = 1
           ORDER BY A.PPFPAG ASC;
        EXCEPTION
          WHEN OTHERS THEN
            p_cuota := 0;
        END;
      
        p_cuota := nvl(p_cuota, 0);
      end if;
    
      --saldo
      BEGIN
        SELECT (g.scsdo) saldo --18/12/2023
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
           AND XLLAOSBOP = xr.aosbop --newcrm
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
          select f.scsdo -- 18/12/2023
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
      END IF; --18/12/2023
    
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
    
      --- rcastro 05/12/2023
      IF xr.pgcod = v_Pgcod AND xr.aomod = v_Scmod AND xr.aosuc = v_Scsuc AND
         xr.aomda = v_Scmda AND xr.aopap = v_Scpap AND xr.aocta = v_Sccta AND
         xr.aooper = v_Scoper AND xr.aosbop = v_Scsbop AND
         xr.aotope = v_Sctope THEN
        f_tipoSolic := 'RF';
      END IF;
      --- rcastro 05/12/2023
    
      -- END IF;
    
      IF flgLineaVinc = 'S' THEN
        -- si existe vinculación de lineas  mod 30/06/2023
        f_tipoSolic := 'V';
      END IF;
    
      --insert AQPC820
      pq_cr_repo_opini_riesgos_crm.sp_insert_aqpc160(auxNrOpinion,
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
    -- *****************************************************************
    -- Nombre                     : sp_insert_aqpc160
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Inserta los creditos vigentes
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                               
    auxCorr       number(10);
    v_HoraActual  VARCHAR2(8);
    v_FechaActual DATE;
  BEGIN
    IF codOpinion > 0 THEN
      v_HoraActual := TO_CHAR(SYSDATE, 'HH24:MI:SS');
      --v_FechaActual := TO_DATE(SYSDATE, 'dd/mm/rrrr');
    
      BEGIN
        SELECT MAX(AQPC820CORR)
          INTO auxCorr
          FROM AQPC820
         WHERE AQPC820CODOPI = codOpinion;
      EXCEPTION
        WHEN OTHERS THEN
          auxCorr := 0;
      END;
      IF auxCorr IS NULL THEN
        auxCorr := 0;
      END IF;
      auxCorr := auxCorr + 1;
    
      BEGIN
        INSERT INTO AQPC820
          (AQPC820CODOPI,
           AQPC820CORR,
           AQPC820FECPRO,
           AQPC820SLDVIG,
           AQPC820MODVIG,
           AQPC820MNTOTG,
           AQPC820CUOTG,
           AQPC820CUOVIG,
           AQPC820TASAVIG,
           AQPC820MONDCR,
           AQPC820TIPSOL,
           AQPC820PRMATRA,
           AQPC820HORAREG,
           AQPC820EMP,
           AQPC820SUC,
           AQPC820MODU,
           AQPC820MDA,
           AQPC820PAP,
           AQPC820CTA,
           AQPC820OPER,
           AQPC820SBOP,
           AQPC820TOPE,
           AQPC820ESTAD) --2108
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
    -- *****************************************************************
    -- Nombre                     : sp_insert_detalle_aqpc157
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Inserta el detalle
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                       
    v_FechaActual DATE; --03082023  
    v_HoraActual  VARCHAR2(8);
    v_correlativo number(10);
    auxInstnc     NUMBER(10);
    instancia     NUMBER(10);
    fechaAnteM400 date ;
    fechAntOut date;
  	TipFlujCN  varchar2(1); 
    Indicflujo varchar2(3);     
  Begin
    -- 2108
    BEGIN
      SELECT MAX(AQPC823CORR)
        INTO v_correlativo
        FROM AQPC823
       WHERE AQPC823CODOPI = p_AQPC157CODOPI; -- AND AQPC156INSTAN = auxAQPC156INSTAN;
    EXCEPTION
      WHEN OTHERS THEN
        v_correlativo := 0;
    END;
    IF v_correlativo IS NULL THEN
      v_correlativo := 0;
    END IF;
  
    v_correlativo := v_correlativo + 1;
  
    BEGIN
      UPDATE AQPC823
         SET AQPC823ESTAD = 'I'
       WHERE AQPC823CODOPI = p_AQPC157CODOPI
         AND (AQPC823ESTAD = 'H' OR AQPC823ESTAD IS NULL);
      --DELETE FROM AQPC823 WHERE AQPC823CODOPI = p_AQPC157CODOPI;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    v_FechaActual := TO_DATE(SYSDATE, 'dd/mm/rrrr');
    v_HoraActual  := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  
    --instancia anterior
    BEGIN
      SELECT AQPC818INSTAN
        INTO instancia
        FROM AQPC818
       WHERE AQPC818CODOPI = p_AQPC157CODOPI
         AND AQPC818ESTAD = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        instancia := 0;
    END;
  
    auxInstnc := 0;
    TipFlujCN := 'C';
    BEGIN
      /*pq_cr_repo_opini_riesgos_crm.sp_obtner_Instanci_anterior(instancia => instancia,
                                                               auxInstnc => auxInstnc,                                                               
                                                               fechaAnteM400 => fechaAnteM400);*/
      Indicflujo := 'CRM';      
      pq_cr_repo_opinion_riesgos.sp_obtner_Instanci_anterior(instancia => instancia,
                                                             Indicflujo => Indicflujo,             
                                                             auxInstnc => auxInstnc,
                                                             fechAntOut => fechAntOut,
                                                             TipFlujCN => TipFlujCN);                                                                
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      INSERT INTO AQPC823
        (AQPC823CODOPI,
         AQPC823Afeere,
         AQPC823Afeean,
         AQPC823AacMda1,
         AQPC823AacrDis,
         AQPC823AarvDis,
         AQPC823AacaDis,
         AQPC823AaavDis,
         AQPC823AaaHDis,
         
         AQPC823AacMda2,
         AQPC823AacrCxC,
         AQPC823AarvCxC,
         AQPC823AacaCxC,
         AQPC823AaavCxC,
         AQPC823AaaHCxC,
         
         AQPC823AacMda3,
         AQPC823AacrMer,
         AQPC823AarvMer,
         AQPC823AacaMer,
         AQPC823AaavMer,
         AQPC823AaaHMer,
         
         AQPC823AacMda4,
         AQPC823Aacrgap,
         AQPC823Aarvgap,
         AQPC823Aacagap,
         AQPC823Aaavgap,
         AQPC823AaaHgap,
         
         AQPC823AacMda5,
         AQPC823AacrExr,
         AQPC823AarvExr,
         AQPC823AacaExr,
         AQPC823AaavExr,
         AQPC823AaaHExr,
         
         AQPC823AacMda6,
         AQPC823AacrOt1,
         AQPC823AarvOt1,
         AQPC823AacaOt1,
         AQPC823AaavOt1,
         AQPC823AaaHOt1,
         
         AQPC823AacMda7,
         AQPC823AacrTac,
         AQPC823AacaTac,
         AQPC823AarvTac,
         AQPC823AaavTac,
         AQPC823AaaHTac,
         
         AQPC823AacMda8,
         AQPC823Aacrmue,
         AQPC823Aacamue,
         AQPC823Aarvmue,
         AQPC823Aaavmue,
         AQPC823AaaHmue,
         
         AQPC823AacMda9,
         AQPC823Aacrinm,
         AQPC823Aacainm,
         AQPC823Aarvinm,
         AQPC823Aaavinm,
         AQPC823AaaHinm,
         
         AQPC823AacMd10,
         AQPC823AACRot2,
         AQPC823AARVot2,
         AQPC823AACAot2,
         AQPC823AAAVot2,
         AQPC823AAAHot2,
         
         AQPC823AacMd11,
         AQPC823Aacrtaf,
         AQPC823Aacataf,
         AQPC823Aaavtaf,
         AQPC823AaaHtaf,
         AQPC823Aarvrta,
         
         AQPC823AacMd12,
         AQPC823AacrTat,
         AQPC823AacaTat,
         AQPC823AarvTat,
         AQPC823AaavTat,
         AQPC823AaaHTat,
         --pasivos  AQPC823AacMd13,
         AQPC823AacMd13,
         AQPC823APrcxpC,
         AQPC823APRVCxp,
         AQPC823APAcxpC,
         AQPC823APAVCxp,
         AQPC823APAHCxp,
         
         AQPC823AacMd14,
         AQPC823APRCXPB,
         AQPC823APRVXPB,
         AQPC823APACXPB,
         AQPC823APAVXPB,
         AQPC823APAHXPB,
         
         AQPC823AacMd15,
         AQPC823APRTXP,
         AQPC823APATXP,
         AQPC823APRVTXP,
         AQPC823APAVTXP,
         AQPC823APAHTXP,
         
         AQPC823AacMd16,
         AQPC823APROTR1,
         AQPC823APAOTR1,
         AQPC823APAVOT1,
         AQPC823APAHOT1,
         AQPC823APRVOT1,
         
         AQPC823AacMd17,
         AQPC823APRTPCR,
         AQPC823APRVTPC,
         AQPC823APATPCR,
         AQPC823APAVTPC,
         AQPC823APAHTPC,
         
         AQPC823AacMd18,
         AQPC823APRCXLP,
         AQPC823APRVCXL,
         AQPC823APACXLP,
         AQPC823APAVCXL,
         AQPC823APAHCXL,
         
         AQPC823AacMd19,
         AQPC823APRBST,
         AQPC823APRVBST,
         AQPC823APABST,
         AQPC823APAVBST,
         AQPC823APAHBST,
         
         AQPC823AacMd20,
         AQPC823APROTR2,
         AQPC823APRVOT2,
         AQPC823APAOTR2,
         AQPC823APAVOT2,
         AQPC823APAHOT2,
         
         AQPC823AacMd21,
         AQPC823APRPNCO,
         AQPC823APRVPNC,
         AQPC823APAPNCO,
         AQPC823APAVPNC,
         AQPC823APAHPNC,
         
         AQPC823AacMd22,
         AQPC823APRTTPA,
         AQPC823APRVTTP,
         AQPC823APATTPA,
         AQPC823APAVTTP,
         AQPC823APAHTTP,
         
         AQPC823AacMd23,
         AQPC823APRCAP,
         AQPC823APRVCAP,
         AQPC823APACAP,
         AQPC823APAVCAP,
         AQPC823APAHCAP,
         
         AQPC823AacMd24,
         AQPC823APRRESE,
         AQPC823APRVRES,
         AQPC823APARESE,
         AQPC823APAVRES,
         AQPC823APAHRES,
         
         AQPC823AacMd25,
         AQPC823APRREAC,
         AQPC823APRVREA,
         AQPC823APAREAC,
         AQPC823APAVREA,
         AQPC823APAHREA,
         
         AQPC823AacMd26,
         AQPC823APRRDEJ,
         AQPC823APRVRDE,
         AQPC823APAVRDE,
         AQPC823APARDEJ,
         AQPC823APAHRDE,
         
         AQPC823AacMd27,
         AQPC823APROTR3,
         AQPC823APRVOT3,
         AQPC823APAOTR3,
         AQPC823APAVOT3,
         AQPC823APAHOT3,
         
         AQPC823AacMd28,
         AQPC823APRPATR,
         AQPC823APRVPAT,
         AQPC823APAPATR,
         AQPC823APAVPAT,
         AQPC823APAHPAT,
         
         AQPC823AacMd29,
         AQPC823APRTTPP,
         AQPC823APRVTPP,
         AQPC823APATTPP,
         AQPC823APAVTPP,
         AQPC823APAHTPP,
         
         --ventas
         AQPC823AacMd30,
         AQPC823AVRVEN,
         AQPC823AVRVVEN,
         AQPC823AVAVEN,
         AQPC823AVAVVEN,
         AQPC823AVAHVEN,
         
         AQPC823AacMd31,
         AQPC823AVRCOSV,
         AQPC823AVRVCSV,
         AQPC823AVACOSV,
         AQPC823AVAVCSV,
         AQPC823AVHCOSV,
         
         AQPC823AacMd32,
         AQPC823AVRUBR,
         AQPC823AVRVUBR,
         AQPC823AVAUBR,
         AQPC823AVAVUBR,
         AQPC823AVHUBR,
         
         AQPC823AacMd33,
         AQPC823AVRCOOP,
         AQPC823AVRVCOP,
         AQPC823AVACOOP,
         AQPC823AVAVCOP,
         AQPC823AVHCOOP,
         
         AQPC823AacMd34,
         AQPC823AVRSDOI,
         AQPC823AVRVSDO,
         AQPC823AVASDOI,
         AQPC823AVAVSDO,
         AQPC823AVHSDOI,
         
         AQPC823AacMd35,
         AQPC823AVRSDV,
         AQPC823AVRVSD,
         AQPC823AVASDV,
         AQPC823AVAVSDV,
         AQPC823AVHSDV,
         
         AQPC823AacMd36,
         AQPC823AVRIMP,
         AQPC823AVRVIMP,
         AQPC823AVAIMP,
         AQPC823AVAVIMP,
         AQPC823AVHIMP,
         
         AQPC823AacMd37,
         AQPC823AVROTC,
         AQPC823AVRVOTC,
         AQPC823AVAOTC,
         AQPC823AVAVOTC,
         AQPC823AVHOTC,
         
         AQPC823AacMd38,
         AQPC823AVRRESE,
         AQPC823AVRVRES,
         AQPC823AVARESE,
         AQPC823AVAVRES,
         AQPC823AVHRESE,
         
         AQPC823AacMd39,
         AQPC823AVROTI,
         AQPC823AVRVOTI,
         AQPC823AVAOTI,
         AQPC823AVAVOTI,
         AQPC823AVHOTI,
         
         AQPC823AacMd40,
         AQPC823AVRGFM,
         AQPC823AVRVGFM,
         AQPC823AVAGFM,
         AQPC823AVAVGFM,
         AQPC823AVHGFM,
         
         AQPC823AacMd41,
         AQPC823AVRRSCP,
         AQPC823AVRVRSC,
         AQPC823AVARSCP,
         AQPC823AVAVRSC,
         AQPC823AVHRSCP,
         
         AQPC823AacMd42,
         AQPC823AVRMCCP,
         AQPC823AVRVMCP,
         AQPC823AVAMCCP,
         AQPC823AVAVMCC,
         AQPC823AVHMCCP,
         
         AQPC823AacMd43,
         AQPC823AVRRNET,
         AQPC823AVRVRNT,
         AQPC823AVARNET,
         AQPC823AVAVRNE,
         AQPC823AVHRNET,
         
         --MACEM        
         AQPC823MPMNP,
         AQPC823MPSLDV,
         AQPC823MPSLCO,
         AQPC823MMFUD1,
         AQPC823MMCR1,
         AQPC823MMMCM1,
         AQPC823MMFUD2,
         AQPC823MMCR2,
         AQPC823MMMCM2,
         
         --ratios
         AQPC823ARTLIQ1,
         AQPC823ARTRCX1,
         AQPC823ATRRDI1,
         AQPC823ATREND1,
         AQPC823ATRROE1,
         AQPC823ATRRCR1,
         
         AQPC823ARTLIQ2,
         AQPC823ARTRCX2,
         AQPC823ATRRDI2,
         AQPC823ATREND2,
         AQPC823ATRROE2,
         AQPC823ATRRCR2,
         
         AQPC823aacmd44,
         AQPC823avcruto,
         AQPC823avcauto,
         AQPC823avrvuto,
         AQPC823avavuto,
         AQPC823avahuto,
         
         AQPC823aacmd45,
         AQPC823avrrgfi,
         AQPC823avargfi,
         AQPC823avrvgfi,
         AQPC823avavgfi,
         AQPC823avhrgfi,
         
         AQPC823aacmd46,
         AQPC823avrrigf,
         AQPC823avarigf,
         AQPC823avrvigf,
         AQPC823avavigf,
         AQPC823avhrigf,
         
         AQPC823aacmd47,
         AQPC823avrrgdi,
         AQPC823avargdi,
         AQPC823avrvgdi,
         AQPC823avavgdi,
         AQPC823avhrgdi,
         
         AQPC823aacmd48,
         AQPC823avrruim,
         AQPC823avaruim,
         AQPC823avrvuim,
         AQPC823avavuim,
         AQPC823avhruim,
         
         AQPC823aacmd49,
         AQPC823avrrutn,
         AQPC823avarutn,
         AQPC823avrvutn,
         AQPC823avavutn,
         AQPC823avhrutn,
         
         AQPC823aacmd50,
         AQPC823avrrgad,
         AQPC823avargad,
         AQPC823avrvgad,
         AQPC823avavgad,
         AQPC823avhrgad,
         AQPC823FECHREG, --0308
         AQPC823HORAREG,
         AQPC823AACMD51, --21082023                               
         AQPC823AVCRPRP,
         AQPC823AVCAPRP,
         AQPC823aacmd52,
         AQPC823avrrvig,
         AQPC823avarvig,
         AQPC823aacmd53,
         AQPC823avrrcot,
         AQPC823avarcot,
         AQPC823aacmd54,
         AQPC823avrrpot,
         AQPC823avarpot,
         AQPC823aacmd55,
         AQPC823avrrrfi,
         AQPC823avarrfi,
         AQPC823CORR,
         AQPC823ESTAD,
         AQPC823INSTANT) --2108
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
                                                
                                                p_AQPC158AacMd36 varchar2,
                                                p_AQPC158AVRIMP  number,
                                                p_AQPC158AVRVIMP number,
                                                p_AQPC158AVAIMP  number,
                                                p_AQPC158AVAVIMP number,
                                                p_AQPC158AVHIMP  number,
                                                
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
    -- *****************************************************************
    -- Nombre                     : sp_insert_analicredcontador_AQPC158
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Inserta el analsis financiero contador
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                                 
    v_FechaActual DATE;
    v_HoraActual  VARCHAR2(8);
  Begin
    v_FechaActual := TO_DATE(SYSDATE, 'dd/mm/rrrr');
    v_HoraActual  := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  
    IF p_Modo = 'I' THEN
      --ADD 2602
      BEGIN
        INSERT INTO AQPC824
          (AQPC824CODOPI,
           AQPC824Afeere,
           AQPC824Afeean,
           AQPC824AacMda1,
           AQPC824AacrDis,
           AQPC824AarvDis,
           AQPC824AacaDis,
           AQPC824AaavDis,
           AQPC824AaaHDis,
           
           AQPC824AacMda2,
           AQPC824AacrCxC,
           AQPC824AarvCxC,
           AQPC824AacaCxC,
           AQPC824AaavCxC,
           AQPC824AaaHCxC,
           
           AQPC824AacMda3,
           AQPC824AacrMer,
           AQPC824AarvMer,
           AQPC824AacaMer,
           AQPC824AaavMer,
           AQPC824AaaHMer,
           
           AQPC824AacMda4,
           AQPC824Aacrgap,
           AQPC824Aarvgap,
           AQPC824Aacagap,
           AQPC824Aaavgap,
           AQPC824AaaHgap,
           
           AQPC824AacMda5,
           AQPC824AacrExr,
           AQPC824AarvExr,
           AQPC824AacaExr,
           AQPC824AaavExr,
           AQPC824AaaHExr,
           
           /*AQPC824AacMda6,
           AQPC824AacrOt1,
           AQPC824AarvOt1,
           AQPC824AacaOt1,
           AQPC824AaavOt1,
           AQPC824AaaHOt1,*/
           
           AQPC824AacMda7,
           AQPC824AacrTac,
           AQPC824AacaTac,
           AQPC824AarvTac,
           AQPC824AaavTac,
           AQPC824AaaHTac,
           
           AQPC824AacMda8,
           AQPC824Aacrmue,
           AQPC824Aacamue,
           AQPC824Aarvmue,
           AQPC824Aaavmue,
           AQPC824AaaHmue,
           
           AQPC824AacMda9,
           AQPC824Aacrinm,
           AQPC824Aacainm,
           AQPC824Aarvinm,
           AQPC824Aaavinm,
           AQPC824AaaHinm,
           
           AQPC824AacMd10,
           AQPC824AACRot2,
           AQPC824AARVot2,
           AQPC824AACAot2,
           AQPC824AAAVot2,
           AQPC824AAAHot2,
           
           AQPC824AacMd11,
           AQPC824Aacrtaf,
           AQPC824Aacataf,
           AQPC824Aaavtaf,
           AQPC824AaaHtaf,
           AQPC824Aarvrta,
           
           AQPC824AacMd12,
           AQPC824AacrTat,
           AQPC824AacaTat,
           AQPC824AarvTat,
           AQPC824AaavTat,
           AQPC824AaaHTat,
           --pasivos  AQPC824AacMd13,
           AQPC824AacMd13,
           AQPC824APrcxpC,
           AQPC824APRVCxp,
           AQPC824APAcxpC,
           AQPC824APAVCxp,
           AQPC824APAHCxp,
           
           AQPC824AacMd14,
           AQPC824APRCXPB,
           AQPC824APRVXPB,
           AQPC824APACXPB,
           AQPC824APAVXPB,
           AQPC824APAHXPB,
           
           AQPC824AacMd15,
           AQPC824APRTXP,
           AQPC824APATXP,
           AQPC824APRVTXP,
           AQPC824APAVTXP,
           AQPC824APAHTXP,
           
           AQPC824AacMd16,
           AQPC824APROTR1,
           AQPC824APAOTR1,
           AQPC824APAVOT1,
           AQPC824APAHOT1,
           AQPC824APRVOT1,
           
           AQPC824AacMd17,
           AQPC824APRTPCR,
           AQPC824APRVTPC,
           AQPC824APATPCR,
           AQPC824APAVTPC,
           AQPC824APAHTPC,
           
           AQPC824AacMd18,
           AQPC824APRCXLP,
           AQPC824APRVCXL,
           AQPC824APACXLP,
           AQPC824APAVCXL,
           AQPC824APAHCXL,
           
           AQPC824AacMd19,
           AQPC824APRBST,
           AQPC824APRVBST,
           AQPC824APABST,
           AQPC824APAVBST,
           AQPC824APAHBST,
           
           AQPC824AacMd20,
           AQPC824APROTR2,
           AQPC824APRVOT2,
           AQPC824APAOTR2,
           AQPC824APAVOT2,
           AQPC824APAHOT2,
           
           AQPC824AacMd21,
           AQPC824APRPNCO,
           AQPC824APRVPNC,
           AQPC824APAPNCO,
           AQPC824APAVPNC,
           AQPC824APAHPNC,
           
           AQPC824AacMd22,
           AQPC824APRTTPA,
           AQPC824APRVTTP,
           AQPC824APATTPA,
           AQPC824APAVTTP,
           AQPC824APAHTTP,
           
           AQPC824AacMd23,
           AQPC824APRCAP,
           AQPC824APRVCAP,
           AQPC824APACAP,
           AQPC824APAVCAP,
           AQPC824APAHCAP,
           
           AQPC824AacMd24,
           AQPC824APRRESE,
           AQPC824APRVRES,
           AQPC824APARESE,
           AQPC824APAVRES,
           AQPC824APAHRES,
           
           AQPC824AacMd25,
           AQPC824APRREAC,
           AQPC824APRVREA,
           AQPC824APAREAC,
           AQPC824APAVREA,
           AQPC824APAHREA,
           
           AQPC824AacMd26,
           AQPC824APRRDEJ,
           AQPC824APRVRDE,
           AQPC824APAVRDE,
           AQPC824APARDEJ,
           AQPC824APAHRDE,
           
           AQPC824AacMd27,
           AQPC824APROTR3,
           AQPC824APRVOT3,
           AQPC824APAOTR3,
           AQPC824APAVOT3,
           AQPC824APAHOT3,
           
           AQPC824AacMd28,
           AQPC824APRPATR,
           AQPC824APRVPAT,
           AQPC824APAPATR,
           AQPC824APAVPAT,
           AQPC824APAHPAT,
           
           AQPC824AacMd29,
           AQPC824APRTTPP,
           AQPC824APRVTPP,
           AQPC824APATTPP,
           AQPC824APAVTPP,
           AQPC824APAHTPP,
           
           --ventas
           AQPC824AacMd30,
           AQPC824AVRVEN,
           AQPC824AVRVVEN,
           AQPC824AVAVEN,
           AQPC824AVAVVEN,
           AQPC824AVAHVEN,
           
           AQPC824AacMd31,
           AQPC824AVRCOSV,
           AQPC824AVRVCSV,
           AQPC824AVACOSV,
           AQPC824AVAVCSV,
           AQPC824AVHCOSV,
           
           AQPC824AacMd32,
           AQPC824AVRUBR,
           AQPC824AVRVUBR,
           AQPC824AVAUBR,
           AQPC824AVAVUBR,
           AQPC824AVHUBR,
           
           /*AQPC824AacMd33,
           AQPC824AVRCOOP,
           AQPC824AVRVCOP,
           AQPC824AVACOOP,
           AQPC824AVAVCOP,
           AQPC824AVHCOOP,
           
           AQPC824AacMd34,
           AQPC824AVRSDOI,
           AQPC824AVRVSDO,
           AQPC824AVASDOI,
           AQPC824AVAVSDO,
           AQPC824AVHSDOI,
           
           AQPC824AacMd35,
           AQPC824AVRSDV,
           AQPC824AVRVSD,
           AQPC824AVASDV,
           AQPC824AVAVSDV,
           AQPC824AVHSDV,*/
           
           AQPC824AacMd36,
           AQPC824AVRIMP,
           AQPC824AVRVIMP,
           AQPC824AVAIMP,
           AQPC824AVAVIMP,
           AQPC824AVHIMP,
           
           /*AQPC824AacMd37,
           AQPC824AVROTC,
           AQPC824AVRVOTC,
           AQPC824AVAOTC,
           AQPC824AVAVOTC,
           AQPC824AVHOTC,
           
           AQPC824AacMd38,
           AQPC824AVRRESE,
           AQPC824AVRVRES,
           AQPC824AVARESE,
           AQPC824AVAVRES,
           AQPC824AVHRESE,*/
           
           AQPC824AacMd39,
           AQPC824AVROTI,
           AQPC824AVRVOTI,
           AQPC824AVAOTI,
           AQPC824AVAVOTI,
           AQPC824AVHOTI,
           
           AQPC824AacMd40,
           AQPC824AVRGFM,
           AQPC824AVRVGFM,
           AQPC824AVAGFM,
           AQPC824AVAVGFM,
           AQPC824AVHGFM,
           
           /*AQPC824AacMd41,
           AQPC824AVRRSCP,
           AQPC824AVRVRSC,
           AQPC824AVARSCP,
           AQPC824AVAVRSC,
           AQPC824AVHRSCP,
           
           AQPC824AacMd42,
           AQPC824AVRMCCP,
           AQPC824AVRVMCP,
           AQPC824AVAMCCP,
           AQPC824AVAVMCC,
           AQPC824AVHMCCP,*/
           
           AQPC824AacMd43,
           AQPC824AVRRNET,
           AQPC824AVRVRNT,
           AQPC824AVARNET,
           AQPC824AVAVRNE,
           AQPC824AVHRNET,
           
           --ratios
           AQPC824ARTLIQ1,
           AQPC824ARTRCX1,
           AQPC824ATRRDI1,
           AQPC824ATREND1,
           AQPC824ATRROE1,
           AQPC824ATRRCR1,
           
           AQPC824ARTLIQ2,
           AQPC824ARTRCX2,
           AQPC824ATRRDI2,
           AQPC824ATREND2,
           AQPC824ATRROE2,
           AQPC824ATRRCR2,
           --nuevos campos
           AQPC824aacmd44,
           AQPC824aacrota,
           AQPC824aacaota,
           AQPC824aarvota,
           AQPC824aaavota,
           AQPC824aaahota,
           
           AQPC824aacmd45,
           AQPC824avcrgtv,
           AQPC824avcagtv,
           AQPC824avrvgtv,
           AQPC824avavgtv,
           AQPC824avahgtv,
           
           AQPC824aacmd46,
           AQPC824avrrgad,
           AQPC824avargad,
           AQPC824avrvgad,
           AQPC824avavgad,
           AQPC824avhrgad,
           
           AQPC824aacmd47,
           AQPC824avrruto,
           AQPC824avaruto,
           AQPC824avrvuto,
           AQPC824avavuto,
           AQPC824avhruto,
           
           AQPC824aacmd48,
           AQPC824avrrgfi,
           AQPC824avargfi,
           AQPC824avrvgfi,
           AQPC824avavgfi,
           AQPC824avhrgfi,
           
           AQPC824aacmd49,
           AQPC824avrrigf,
           AQPC824avarigf,
           AQPC824avrvigf,
           AQPC824avavigf,
           AQPC824avhrigf,
           
           AQPC824aacmd50,
           AQPC824avrrgdi,
           AQPC824avargdi,
           AQPC824avrvgdi,
           AQPC824avavgdi,
           AQPC824avhrgdi,
           
           AQPC824aacmd51,
           AQPC824avrruim,
           AQPC824avaruim,
           AQPC824avrvuim,
           AQPC824avavuim,
           AQPC824avhruim,
           
           AQPC824aacmd52,
           AQPC824avrrutn,
           AQPC824avarutn,
           AQPC824avrvutn,
           AQPC824avavutn,
           AQPC824avhrutn,
           AQPC824FECHREG,
           AQPC824HORAREG)
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
            UPDATE AQPC824
               SET AQPC824Afeere  = p_AQPC158Afeere,
                   AQPC824Afeean  = p_AQPC158Afeean,
                   AQPC824AacMda1 = p_AQPC158AacMda1,
                   AQPC824AacrDis = p_AQPC158AacrDis,
                   AQPC824AarvDis = p_AQPC158AarvDis,
                   AQPC824AacaDis = p_AQPC158AacaDis,
                   AQPC824AaavDis = p_AQPC158AaavDis,
                   AQPC824AaaHDis = p_AQPC158AaaHDis,
                   
                   AQPC824AacMda2 = p_AQPC158AacMda2,
                   AQPC824AacrCxC = p_AQPC158AacrCxC,
                   AQPC824AarvCxC = p_AQPC158AarvCxC,
                   AQPC824AacaCxC = p_AQPC158AacaCxC,
                   AQPC824AaavCxC = p_AQPC158AaavCxC,
                   AQPC824AaaHCxC = p_AQPC158AaaHCxC,
                   
                   AQPC824AacMda3 = p_AQPC158AacMda3,
                   AQPC824AacrMer = p_AQPC158AacrMer,
                   AQPC824AarvMer = p_AQPC158AarvMer,
                   AQPC824AacaMer = p_AQPC158AacaMer,
                   AQPC824AaavMer = p_AQPC158AaavMer,
                   AQPC824AaaHMer = p_AQPC158AaaHMer,
                   
                   AQPC824AacMda4 = p_AQPC158AacMda4,
                   AQPC824Aacrgap = p_AQPC158Aacrgap,
                   AQPC824Aarvgap = p_AQPC158Aarvgap,
                   AQPC824Aacagap = p_AQPC158Aacagap,
                   AQPC824Aaavgap = p_AQPC158Aaavgap,
                   AQPC824AaaHgap = p_AQPC158AaaHgap,
                   
                   AQPC824AacMda5 = p_AQPC158AacMda5,
                   AQPC824AacrExr = p_AQPC158AacrExr,
                   AQPC824AarvExr = p_AQPC158AarvExr,
                   AQPC824AacaExr = p_AQPC158AacaExr,
                   AQPC824AaavExr = p_AQPC158AaavExr,
                   AQPC824AaaHExr = p_AQPC158AaaHExr,
                   
                   AQPC824AacMda7 = p_AQPC158AacMda7,
                   AQPC824AacrTac = p_AQPC158AacrTac,
                   AQPC824AacaTac = p_AQPC158AacaTac,
                   AQPC824AarvTac = p_AQPC158AarvTac,
                   AQPC824AaavTac = p_AQPC158AaavTac,
                   AQPC824AaaHTac = p_AQPC158AaaHTac,
                   
                   AQPC824AacMda8 = p_AQPC158AacMda8,
                   AQPC824Aacrmue = p_AQPC158Aacrmue,
                   AQPC824Aacamue = p_AQPC158Aacamue,
                   AQPC824Aarvmue = p_AQPC158Aarvmue,
                   AQPC824Aaavmue = p_AQPC158Aaavmue,
                   AQPC824AaaHmue = p_AQPC158AaaHmue,
                   
                   AQPC824AacMda9 = p_AQPC158AacMda9,
                   AQPC824Aacrinm = p_AQPC158Aacrinm,
                   AQPC824Aacainm = p_AQPC158Aacainm,
                   AQPC824Aarvinm = p_AQPC158Aarvinm,
                   AQPC824Aaavinm = p_AQPC158Aaavinm,
                   AQPC824AaaHinm = p_AQPC158AaaHinm,
                   
                   AQPC824AacMd10 = p_AQPC158AacMd10,
                   AQPC824AACRot2 = p_AQPC158AACRot2,
                   AQPC824AARVot2 = p_AQPC158AARVot2,
                   AQPC824AACAot2 = p_AQPC158AACAot2,
                   AQPC824AAAVot2 = p_AQPC158AAAVot2,
                   AQPC824AAAHot2 = p_AQPC158AAAHot2,
                   
                   AQPC824AacMd11 = p_AQPC158AacMd11,
                   AQPC824Aacrtaf = p_AQPC158Aacrtaf,
                   AQPC824Aacataf = p_AQPC158Aacataf,
                   AQPC824Aaavtaf = p_AQPC158Aaavtaf,
                   AQPC824AaaHtaf = p_AQPC158AaaHtaf,
                   AQPC824Aarvrta = p_AQPC158Aarvrta,
                   
                   AQPC824AacMd12 = p_AQPC158AacMd12,
                   AQPC824AacrTat = p_AQPC158AacrTat,
                   AQPC824AacaTat = p_AQPC158AacaTat,
                   AQPC824AarvTat = p_AQPC158AarvTat,
                   AQPC824AaavTat = p_AQPC158AaavTat,
                   AQPC824AaaHTat = p_AQPC158AaaHTat,
                   
                   AQPC824AacMd13 = p_AQPC158AacMd13,
                   AQPC824APrcxpC = p_AQPC158APrcxpC,
                   AQPC824APRVCxp = p_AQPC158APRVCxp,
                   AQPC824APAcxpC = p_AQPC158APAcxpC,
                   AQPC824APAVCxp = p_AQPC158APAVCxp,
                   AQPC824APAHCxp = p_AQPC158APAHCxp,
                   
                   AQPC824AacMd14 = p_AQPC158AacMd14,
                   AQPC824APRCXPB = p_AQPC158APRCXPB,
                   AQPC824APRVXPB = p_AQPC158APRVXPB,
                   AQPC824APACXPB = p_AQPC158APACXPB,
                   AQPC824APAVXPB = p_AQPC158APAVXPB,
                   AQPC824APAHXPB = p_AQPC158APAHXPB,
                   
                   AQPC824AacMd15 = p_AQPC158AacMd15,
                   AQPC824APRTXP  = p_AQPC158APRTXP,
                   AQPC824APATXP  = p_AQPC158APATXP,
                   AQPC824APRVTXP = p_AQPC158APRVTXP,
                   AQPC824APAVTXP = p_AQPC158APAVTXP,
                   AQPC824APAHTXP = p_AQPC158APAHTXP,
                   
                   AQPC824AacMd16 = p_AQPC158AacMd16,
                   AQPC824APROTR1 = p_AQPC158APROTR1,
                   AQPC824APAOTR1 = p_AQPC158APAOTR1,
                   AQPC824APAVOT1 = p_AQPC158APAVOT1,
                   AQPC824APAHOT1 = p_AQPC158APAHOT1,
                   AQPC824APRVOT1 = p_AQPC158APRVOT1,
                   
                   AQPC824AacMd17 = p_AQPC158AacMd17,
                   AQPC824APRTPCR = p_AQPC158APRTPCR,
                   AQPC824APRVTPC = p_AQPC158APRVTPC,
                   AQPC824APATPCR = p_AQPC158APATPCR,
                   AQPC824APAVTPC = p_AQPC158APAVTPC,
                   AQPC824APAHTPC = p_AQPC158APAHTPC,
                   
                   AQPC824AacMd18 = p_AQPC158AacMd18,
                   AQPC824APRCXLP = p_AQPC158APRCXLP,
                   AQPC824APRVCXL = p_AQPC158APRVCXL,
                   AQPC824APACXLP = p_AQPC158APACXLP,
                   AQPC824APAVCXL = p_AQPC158APAVCXL,
                   AQPC824APAHCXL = p_AQPC158APAHCXL,
                   
                   AQPC824AacMd19 = p_AQPC158AacMd19,
                   AQPC824APRBST  = p_AQPC158APRBST,
                   AQPC824APRVBST = p_AQPC158APRVBST,
                   AQPC824APABST  = p_AQPC158APABST,
                   AQPC824APAVBST = p_AQPC158APAVBST,
                   AQPC824APAHBST = p_AQPC158APAHBST,
                   
                   AQPC824AacMd20 = p_AQPC158AacMd20,
                   AQPC824APROTR2 = p_AQPC158APROTR2,
                   AQPC824APRVOT2 = p_AQPC158APRVOT2,
                   AQPC824APAOTR2 = p_AQPC158APAOTR2,
                   AQPC824APAVOT2 = p_AQPC158APAVOT2,
                   AQPC824APAHOT2 = p_AQPC158APAHOT2,
                   
                   AQPC824AacMd21 = p_AQPC158AacMd21,
                   AQPC824APRPNCO = p_AQPC158APRPNCO,
                   AQPC824APRVPNC = p_AQPC158APRVPNC,
                   AQPC824APAPNCO = p_AQPC158APAPNCO,
                   AQPC824APAVPNC = p_AQPC158APAVPNC,
                   AQPC824APAHPNC = p_AQPC158APAHPNC,
                   
                   AQPC824AacMd22 = p_AQPC158AacMd22,
                   AQPC824APRTTPA = p_AQPC158APRTTPA,
                   AQPC824APRVTTP = p_AQPC158APRVTTP,
                   AQPC824APATTPA = p_AQPC158APATTPA,
                   AQPC824APAVTTP = p_AQPC158APAVTTP,
                   AQPC824APAHTTP = p_AQPC158APAHTTP,
                   
                   AQPC824AacMd23 = p_AQPC158AacMd23,
                   AQPC824APRCAP  = p_AQPC158APRCAP,
                   AQPC824APRVCAP = p_AQPC158APRVCAP,
                   AQPC824APACAP  = p_AQPC158APACAP,
                   AQPC824APAVCAP = p_AQPC158APAVCAP,
                   AQPC824APAHCAP = p_AQPC158APAHCAP,
                   
                   AQPC824AacMd24 = p_AQPC158AacMd24,
                   AQPC824APRRESE = p_AQPC158APRRESE,
                   AQPC824APRVRES = p_AQPC158APRVRES,
                   AQPC824APARESE = p_AQPC158APARESE,
                   AQPC824APAVRES = p_AQPC158APAVRES,
                   AQPC824APAHRES = p_AQPC158APAHRES,
                   
                   AQPC824AacMd25 = p_AQPC158AacMd25,
                   AQPC824APRREAC = p_AQPC158APRREAC,
                   AQPC824APRVREA = p_AQPC158APRVREA,
                   AQPC824APAREAC = p_AQPC158APAREAC,
                   AQPC824APAVREA = p_AQPC158APAVREA,
                   AQPC824APAHREA = p_AQPC158APAHREA,
                   
                   AQPC824AacMd26 = p_AQPC158AacMd26,
                   AQPC824APRRDEJ = p_AQPC158APRRDEJ,
                   AQPC824APRVRDE = p_AQPC158APRVRDE,
                   AQPC824APAVRDE = p_AQPC158APAVRDE,
                   AQPC824APARDEJ = p_AQPC158APARDEJ,
                   AQPC824APAHRDE = p_AQPC158APAHRDE,
                   
                   AQPC824AacMd27 = p_AQPC158AacMd27,
                   AQPC824APROTR3 = p_AQPC158APROTR3,
                   AQPC824APRVOT3 = p_AQPC158APRVOT3,
                   AQPC824APAOTR3 = p_AQPC158APAOTR3,
                   AQPC824APAVOT3 = p_AQPC158APAVOT3,
                   AQPC824APAHOT3 = p_AQPC158APAHOT3,
                   
                   AQPC824AacMd28 = p_AQPC158AacMd28,
                   AQPC824APRPATR = p_AQPC158APRPATR,
                   AQPC824APRVPAT = p_AQPC158APRVPAT,
                   AQPC824APAPATR = p_AQPC158APAPATR,
                   AQPC824APAVPAT = p_AQPC158APAVPAT,
                   AQPC824APAHPAT = p_AQPC158APAHPAT,
                   
                   AQPC824AacMd29 = p_AQPC158AacMd29,
                   AQPC824APRTTPP = p_AQPC158APRTTPP,
                   AQPC824APRVTPP = p_AQPC158APRVTPP,
                   AQPC824APATTPP = p_AQPC158APATTPP,
                   AQPC824APAVTPP = p_AQPC158APAVTPP,
                   AQPC824APAHTPP = p_AQPC158APAHTPP,
                   
                   AQPC824AacMd30 = p_AQPC158AacMd30,
                   AQPC824AVRVEN  = p_AQPC158AVRVEN,
                   AQPC824AVRVVEN = p_AQPC158AVRVVEN,
                   AQPC824AVAVEN  = p_AQPC158AVAVEN,
                   AQPC824AVAVVEN = p_AQPC158AVAVVEN,
                   AQPC824AVAHVEN = p_AQPC158AVAHVEN,
                   
                   AQPC824AacMd31 = p_AQPC158AacMd31,
                   AQPC824AVRCOSV = p_AQPC158AVRCOSV,
                   AQPC824AVRVCSV = p_AQPC158AVRVCSV,
                   AQPC824AVACOSV = p_AQPC158AVACOSV,
                   AQPC824AVAVCSV = p_AQPC158AVAVCSV,
                   AQPC824AVHCOSV = p_AQPC158AVHCOSV,
                   
                   AQPC824AacMd32 = p_AQPC158AacMd32,
                   AQPC824AVRUBR  = p_AQPC158AVRUBR,
                   AQPC824AVRVUBR = p_AQPC158AVRVUBR,
                   AQPC824AVAUBR  = p_AQPC158AVAUBR,
                   AQPC824AVAVUBR = p_AQPC158AVAVUBR,
                   AQPC824AVHUBR  = p_AQPC158AVHUBR,
                   
                   AQPC824AacMd36 = p_AQPC158AacMd36,
                   AQPC824AVRIMP  = p_AQPC158AVRIMP,
                   AQPC824AVRVIMP = p_AQPC158AVRVIMP,
                   AQPC824AVAIMP  = p_AQPC158AVAIMP,
                   AQPC824AVAVIMP = p_AQPC158AVAVIMP,
                   AQPC824AVHIMP  = p_AQPC158AVHIMP,
                   
                   AQPC824AacMd39 = p_AQPC158AacMd39,
                   AQPC824AVROTI  = p_AQPC158AVROTI,
                   AQPC824AVRVOTI = p_AQPC158AVRVOTI,
                   AQPC824AVAOTI  = p_AQPC158AVAOTI,
                   AQPC824AVAVOTI = p_AQPC158AVAVOTI,
                   AQPC824AVHOTI  = p_AQPC158AVHOTI,
                   
                   AQPC824AacMd40 = p_AQPC158AacMd40,
                   AQPC824AVRGFM  = p_AQPC158AVRGFM,
                   AQPC824AVRVGFM = p_AQPC158AVRVGFM,
                   AQPC824AVAGFM  = p_AQPC158AVAGFM,
                   AQPC824AVAVGFM = p_AQPC158AVAVGFM,
                   AQPC824AVHGFM  = p_AQPC158AVHGFM,
                   
                   AQPC824AacMd43 = p_AQPC158AacMd43,
                   AQPC824AVRRNET = p_AQPC158AVRRNET,
                   AQPC824AVRVRNT = p_AQPC158AVRVRNT,
                   AQPC824AVARNET = p_AQPC158AVARNET,
                   AQPC824AVAVRNE = p_AQPC158AVAVRNE,
                   AQPC824AVHRNET = p_AQPC158AVHRNET,
                   
                   AQPC824ARTLIQ1 = p_AQPC158ARTLIQ1,
                   AQPC824ARTRCX1 = p_AQPC158ARTRCX1,
                   AQPC824ATRRDI1 = p_AQPC158ATRRDI1,
                   AQPC824ATREND1 = p_AQPC158ATREND1,
                   AQPC824ATRROE1 = p_AQPC158ATRROE1,
                   AQPC824ATRRCR1 = p_AQPC158ATRRCR1,
                   
                   AQPC824ARTLIQ2 = p_AQPC158ARTLIQ2,
                   AQPC824ARTRCX2 = p_AQPC158ARTRCX2,
                   AQPC824ATRRDI2 = p_AQPC158ATRRDI2,
                   AQPC824ATREND2 = p_AQPC158ATREND2,
                   AQPC824ATRROE2 = p_AQPC158ATRROE2,
                   AQPC824ATRRCR2 = p_AQPC158ATRRCR2,
                   --nuevos campos
                   AQPC824aacmd44 = p_aqpc158aacmd44,
                   AQPC824aacrota = p_aqpc158aacrota,
                   AQPC824aacaota = p_aqpc158aacaota,
                   AQPC824aarvota = p_aqpc158aarvota,
                   AQPC824aaavota = p_aqpc158aaavota,
                   AQPC824aaahota = p_aqpc158aaahota,
                   
                   AQPC824aacmd45 = p_aqpc158aacmd45,
                   AQPC824avcrgtv = p_aqpc158avcrgtv,
                   AQPC824avcagtv = p_aqpc158avcagtv,
                   AQPC824avrvgtv = p_aqpc158avrvgtv,
                   AQPC824avavgtv = p_aqpc158avavgtv,
                   AQPC824avahgtv = p_aqpc158avahgtv,
                   
                   AQPC824aacmd46 = p_aqpc158aacmd46,
                   AQPC824avrrgad = p_aqpc158avrrgad,
                   AQPC824avargad = p_aqpc158avargad,
                   AQPC824avrvgad = p_aqpc158avrvgad,
                   AQPC824avavgad = p_aqpc158avavgad,
                   AQPC824avhrgad = p_aqpc158avhrgad,
                   
                   AQPC824aacmd47 = p_aqpc158aacmd47,
                   AQPC824avrruto = p_aqpc158avrruto,
                   AQPC824avaruto = p_aqpc158avaruto,
                   AQPC824avrvuto = p_aqpc158avrvuto,
                   AQPC824avavuto = p_aqpc158avavuto,
                   AQPC824avhruto = p_aqpc158avhruto,
                   
                   AQPC824aacmd48 = p_aqpc158aacmd48,
                   AQPC824avrrgfi = p_aqpc158avrrgfi,
                   AQPC824avargfi = p_aqpc158avargfi,
                   AQPC824avrvgfi = p_aqpc158avrvgfi,
                   AQPC824avavgfi = p_aqpc158avavgfi,
                   AQPC824avhrgfi = p_aqpc158avhrgfi,
                   
                   AQPC824aacmd49 = p_aqpc158aacmd49,
                   AQPC824avrrigf = p_aqpc158avrrigf,
                   AQPC824avarigf = p_aqpc158avarigf,
                   AQPC824avrvigf = p_aqpc158avrvigf,
                   AQPC824avavigf = p_aqpc158avavigf,
                   AQPC824avhrigf = p_aqpc158avhrigf,
                   
                   AQPC824aacmd50 = p_aqpc158aacmd50,
                   AQPC824avrrgdi = p_aqpc158avrrgdi,
                   AQPC824avargdi = p_aqpc158avargdi,
                   AQPC824avrvgdi = p_aqpc158avrvgdi,
                   AQPC824avavgdi = p_aqpc158avavgdi,
                   AQPC824avhrgdi = p_aqpc158avhrgdi,
                   
                   AQPC824aacmd51 = p_aqpc158aacmd51,
                   AQPC824avrruim = p_aqpc158avrruim,
                   AQPC824avaruim = p_aqpc158avaruim,
                   AQPC824avrvuim = p_aqpc158avrvuim,
                   AQPC824avavuim = p_aqpc158avavuim,
                   AQPC824avhruim = p_aqpc158avhruim,
                   
                   AQPC824aacmd52 = p_aqpc158aacmd52,
                   AQPC824avrrutn = p_aqpc158avrrutn,
                   AQPC824avarutn = p_aqpc158avarutn,
                   AQPC824avrvutn = p_aqpc158avrvutn,
                   AQPC824avavutn = p_aqpc158avavutn,
                   AQPC824avhrutn = p_aqpc158avhrutn
             WHERE AQPC824CODOPI = p_AQPC158CODOPI;
            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
      END;
    END IF;
  
    IF p_Modo = 'U' THEN
      BEGIN
        UPDATE AQPC824
           SET --AQPC824CODOPI  =  p_AQPC158CODOPI   ,   
               AQPC824Afeere = p_AQPC158Afeere,
               AQPC824Afeean  = p_AQPC158Afeean,
               AQPC824AacMda1 = p_AQPC158AacMda1,
               AQPC824AacrDis = p_AQPC158AacrDis,
               AQPC824AarvDis = p_AQPC158AarvDis,
               AQPC824AacaDis = p_AQPC158AacaDis,
               AQPC824AaavDis = p_AQPC158AaavDis,
               AQPC824AaaHDis = p_AQPC158AaaHDis,
               
               AQPC824AacMda2 = p_AQPC158AacMda2,
               AQPC824AacrCxC = p_AQPC158AacrCxC,
               AQPC824AarvCxC = p_AQPC158AarvCxC,
               AQPC824AacaCxC = p_AQPC158AacaCxC,
               AQPC824AaavCxC = p_AQPC158AaavCxC,
               AQPC824AaaHCxC = p_AQPC158AaaHCxC,
               
               AQPC824AacMda3 = p_AQPC158AacMda3,
               AQPC824AacrMer = p_AQPC158AacrMer,
               AQPC824AarvMer = p_AQPC158AarvMer,
               AQPC824AacaMer = p_AQPC158AacaMer,
               AQPC824AaavMer = p_AQPC158AaavMer,
               AQPC824AaaHMer = p_AQPC158AaaHMer,
               
               AQPC824AacMda4 = p_AQPC158AacMda4,
               AQPC824Aacrgap = p_AQPC158Aacrgap,
               AQPC824Aarvgap = p_AQPC158Aarvgap,
               AQPC824Aacagap = p_AQPC158Aacagap,
               AQPC824Aaavgap = p_AQPC158Aaavgap,
               AQPC824AaaHgap = p_AQPC158AaaHgap,
               
               AQPC824AacMda5 = p_AQPC158AacMda5,
               AQPC824AacrExr = p_AQPC158AacrExr,
               AQPC824AarvExr = p_AQPC158AarvExr,
               AQPC824AacaExr = p_AQPC158AacaExr,
               AQPC824AaavExr = p_AQPC158AaavExr,
               AQPC824AaaHExr = p_AQPC158AaaHExr,
               
               /*AQPC824AacMda6 = p_AQPC158AacMda6,
               AQPC824AacrOt1 = p_AQPC158AacrOt1,
               AQPC824AarvOt1 = p_AQPC158AarvOt1,
               AQPC824AacaOt1 = p_AQPC158AacaOt1,
               AQPC824AaavOt1 = p_AQPC158AaavOt1,
               AQPC824AaaHOt1 = p_AQPC158AaaHOt1,*/
               
               AQPC824AacMda7 = p_AQPC158AacMda7,
               AQPC824AacrTac = p_AQPC158AacrTac,
               AQPC824AacaTac = p_AQPC158AacaTac,
               AQPC824AarvTac = p_AQPC158AarvTac,
               AQPC824AaavTac = p_AQPC158AaavTac,
               AQPC824AaaHTac = p_AQPC158AaaHTac,
               
               AQPC824AacMda8 = p_AQPC158AacMda8,
               AQPC824Aacrmue = p_AQPC158Aacrmue,
               AQPC824Aacamue = p_AQPC158Aacamue,
               AQPC824Aarvmue = p_AQPC158Aarvmue,
               AQPC824Aaavmue = p_AQPC158Aaavmue,
               AQPC824AaaHmue = p_AQPC158AaaHmue,
               
               AQPC824AacMda9 = p_AQPC158AacMda9,
               AQPC824Aacrinm = p_AQPC158Aacrinm,
               AQPC824Aacainm = p_AQPC158Aacainm,
               AQPC824Aarvinm = p_AQPC158Aarvinm,
               AQPC824Aaavinm = p_AQPC158Aaavinm,
               AQPC824AaaHinm = p_AQPC158AaaHinm,
               
               AQPC824AacMd10 = p_AQPC158AacMd10,
               AQPC824AACRot2 = p_AQPC158AACRot2,
               AQPC824AARVot2 = p_AQPC158AARVot2,
               AQPC824AACAot2 = p_AQPC158AACAot2,
               AQPC824AAAVot2 = p_AQPC158AAAVot2,
               AQPC824AAAHot2 = p_AQPC158AAAHot2,
               
               AQPC824AacMd11 = p_AQPC158AacMd11,
               AQPC824Aacrtaf = p_AQPC158Aacrtaf,
               AQPC824Aacataf = p_AQPC158Aacataf,
               AQPC824Aaavtaf = p_AQPC158Aaavtaf,
               AQPC824AaaHtaf = p_AQPC158AaaHtaf,
               AQPC824Aarvrta = p_AQPC158Aarvrta,
               
               AQPC824AacMd12 = p_AQPC158AacMd12,
               AQPC824AacrTat = p_AQPC158AacrTat,
               AQPC824AacaTat = p_AQPC158AacaTat,
               AQPC824AarvTat = p_AQPC158AarvTat,
               AQPC824AaavTat = p_AQPC158AaavTat,
               AQPC824AaaHTat = p_AQPC158AaaHTat,
               
               AQPC824AacMd13 = p_AQPC158AacMd13,
               AQPC824APrcxpC = p_AQPC158APrcxpC,
               AQPC824APRVCxp = p_AQPC158APRVCxp,
               AQPC824APAcxpC = p_AQPC158APAcxpC,
               AQPC824APAVCxp = p_AQPC158APAVCxp,
               AQPC824APAHCxp = p_AQPC158APAHCxp,
               
               AQPC824AacMd14 = p_AQPC158AacMd14,
               AQPC824APRCXPB = p_AQPC158APRCXPB,
               AQPC824APRVXPB = p_AQPC158APRVXPB,
               AQPC824APACXPB = p_AQPC158APACXPB,
               AQPC824APAVXPB = p_AQPC158APAVXPB,
               AQPC824APAHXPB = p_AQPC158APAHXPB,
               
               AQPC824AacMd15 = p_AQPC158AacMd15,
               AQPC824APRTXP  = p_AQPC158APRTXP,
               AQPC824APATXP  = p_AQPC158APATXP,
               AQPC824APRVTXP = p_AQPC158APRVTXP,
               AQPC824APAVTXP = p_AQPC158APAVTXP,
               AQPC824APAHTXP = p_AQPC158APAHTXP,
               
               AQPC824AacMd16 = p_AQPC158AacMd16,
               AQPC824APROTR1 = p_AQPC158APROTR1,
               AQPC824APAOTR1 = p_AQPC158APAOTR1,
               AQPC824APAVOT1 = p_AQPC158APAVOT1,
               AQPC824APAHOT1 = p_AQPC158APAHOT1,
               AQPC824APRVOT1 = p_AQPC158APRVOT1,
               
               AQPC824AacMd17 = p_AQPC158AacMd17,
               AQPC824APRTPCR = p_AQPC158APRTPCR,
               AQPC824APRVTPC = p_AQPC158APRVTPC,
               AQPC824APATPCR = p_AQPC158APATPCR,
               AQPC824APAVTPC = p_AQPC158APAVTPC,
               AQPC824APAHTPC = p_AQPC158APAHTPC,
               
               AQPC824AacMd18 = p_AQPC158AacMd18,
               AQPC824APRCXLP = p_AQPC158APRCXLP,
               AQPC824APRVCXL = p_AQPC158APRVCXL,
               AQPC824APACXLP = p_AQPC158APACXLP,
               AQPC824APAVCXL = p_AQPC158APAVCXL,
               AQPC824APAHCXL = p_AQPC158APAHCXL,
               
               AQPC824AacMd19 = p_AQPC158AacMd19,
               AQPC824APRBST  = p_AQPC158APRBST,
               AQPC824APRVBST = p_AQPC158APRVBST,
               AQPC824APABST  = p_AQPC158APABST,
               AQPC824APAVBST = p_AQPC158APAVBST,
               AQPC824APAHBST = p_AQPC158APAHBST,
               
               AQPC824AacMd20 = p_AQPC158AacMd20,
               AQPC824APROTR2 = p_AQPC158APROTR2,
               AQPC824APRVOT2 = p_AQPC158APRVOT2,
               AQPC824APAOTR2 = p_AQPC158APAOTR2,
               AQPC824APAVOT2 = p_AQPC158APAVOT2,
               AQPC824APAHOT2 = p_AQPC158APAHOT2,
               
               AQPC824AacMd21 = p_AQPC158AacMd21,
               AQPC824APRPNCO = p_AQPC158APRPNCO,
               AQPC824APRVPNC = p_AQPC158APRVPNC,
               AQPC824APAPNCO = p_AQPC158APAPNCO,
               AQPC824APAVPNC = p_AQPC158APAVPNC,
               AQPC824APAHPNC = p_AQPC158APAHPNC,
               
               AQPC824AacMd22 = p_AQPC158AacMd22,
               AQPC824APRTTPA = p_AQPC158APRTTPA,
               AQPC824APRVTTP = p_AQPC158APRVTTP,
               AQPC824APATTPA = p_AQPC158APATTPA,
               AQPC824APAVTTP = p_AQPC158APAVTTP,
               AQPC824APAHTTP = p_AQPC158APAHTTP,
               
               AQPC824AacMd23 = p_AQPC158AacMd23,
               AQPC824APRCAP  = p_AQPC158APRCAP,
               AQPC824APRVCAP = p_AQPC158APRVCAP,
               AQPC824APACAP  = p_AQPC158APACAP,
               AQPC824APAVCAP = p_AQPC158APAVCAP,
               AQPC824APAHCAP = p_AQPC158APAHCAP,
               
               AQPC824AacMd24 = p_AQPC158AacMd24,
               AQPC824APRRESE = p_AQPC158APRRESE,
               AQPC824APRVRES = p_AQPC158APRVRES,
               AQPC824APARESE = p_AQPC158APARESE,
               AQPC824APAVRES = p_AQPC158APAVRES,
               AQPC824APAHRES = p_AQPC158APAHRES,
               
               AQPC824AacMd25 = p_AQPC158AacMd25,
               AQPC824APRREAC = p_AQPC158APRREAC,
               AQPC824APRVREA = p_AQPC158APRVREA,
               AQPC824APAREAC = p_AQPC158APAREAC,
               AQPC824APAVREA = p_AQPC158APAVREA,
               AQPC824APAHREA = p_AQPC158APAHREA,
               
               AQPC824AacMd26 = p_AQPC158AacMd26,
               AQPC824APRRDEJ = p_AQPC158APRRDEJ,
               AQPC824APRVRDE = p_AQPC158APRVRDE,
               AQPC824APAVRDE = p_AQPC158APAVRDE,
               AQPC824APARDEJ = p_AQPC158APARDEJ,
               AQPC824APAHRDE = p_AQPC158APAHRDE,
               
               AQPC824AacMd27 = p_AQPC158AacMd27,
               AQPC824APROTR3 = p_AQPC158APROTR3,
               AQPC824APRVOT3 = p_AQPC158APRVOT3,
               AQPC824APAOTR3 = p_AQPC158APAOTR3,
               AQPC824APAVOT3 = p_AQPC158APAVOT3,
               AQPC824APAHOT3 = p_AQPC158APAHOT3,
               
               AQPC824AacMd28 = p_AQPC158AacMd28,
               AQPC824APRPATR = p_AQPC158APRPATR,
               AQPC824APRVPAT = p_AQPC158APRVPAT,
               AQPC824APAPATR = p_AQPC158APAPATR,
               AQPC824APAVPAT = p_AQPC158APAVPAT,
               AQPC824APAHPAT = p_AQPC158APAHPAT,
               
               AQPC824AacMd29 = p_AQPC158AacMd29,
               AQPC824APRTTPP = p_AQPC158APRTTPP,
               AQPC824APRVTPP = p_AQPC158APRVTPP,
               AQPC824APATTPP = p_AQPC158APATTPP,
               AQPC824APAVTPP = p_AQPC158APAVTPP,
               AQPC824APAHTPP = p_AQPC158APAHTPP,
               
               AQPC824AacMd30 = p_AQPC158AacMd30,
               AQPC824AVRVEN  = p_AQPC158AVRVEN,
               AQPC824AVRVVEN = p_AQPC158AVRVVEN,
               AQPC824AVAVEN  = p_AQPC158AVAVEN,
               AQPC824AVAVVEN = p_AQPC158AVAVVEN,
               AQPC824AVAHVEN = p_AQPC158AVAHVEN,
               
               AQPC824AacMd31 = p_AQPC158AacMd31,
               AQPC824AVRCOSV = p_AQPC158AVRCOSV,
               AQPC824AVRVCSV = p_AQPC158AVRVCSV,
               AQPC824AVACOSV = p_AQPC158AVACOSV,
               AQPC824AVAVCSV = p_AQPC158AVAVCSV,
               AQPC824AVHCOSV = p_AQPC158AVHCOSV,
               
               AQPC824AacMd32 = p_AQPC158AacMd32,
               AQPC824AVRUBR  = p_AQPC158AVRUBR,
               AQPC824AVRVUBR = p_AQPC158AVRVUBR,
               AQPC824AVAUBR  = p_AQPC158AVAUBR,
               AQPC824AVAVUBR = p_AQPC158AVAVUBR,
               AQPC824AVHUBR  = p_AQPC158AVHUBR,
               
               /* AQPC824AacMd33 = p_AQPC158AacMd33,
               AQPC824AVRCOOP = p_AQPC158AVRCOOP,
               AQPC824AVRVCOP = p_AQPC158AVRVCOP,
               AQPC824AVACOOP = p_AQPC158AVACOOP,
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
               
               AQPC824AacMd36 = p_AQPC158AacMd36,
               AQPC824AVRIMP  = p_AQPC158AVRIMP,
               AQPC824AVRVIMP = p_AQPC158AVRVIMP,
               AQPC824AVAIMP  = p_AQPC158AVAIMP,
               AQPC824AVAVIMP = p_AQPC158AVAVIMP,
               AQPC824AVHIMP  = p_AQPC158AVHIMP,
               
               /*   AQPC824AacMd37 = p_AQPC158AacMd37,
               AQPC824AVROTC  = p_AQPC158AVROTC,
               AQPC824AVRVOTC = p_AQPC158AVRVOTC,
               AQPC824AVAOTC  = p_AQPC158AVAOTC,
               AQPC824AVAVOTC = p_AQPC158AVAVOTC,
               AQPC824AVHOTC  = p_AQPC158AVHOTC,
               
               AQPC158AacMd38 = p_AQPC158AacMd38,
               AQPC158AVRRESE = p_AQPC158AVRRESE,
               AQPC158AVRVRES = p_AQPC158AVRVRES,
               AQPC158AVARESE = p_AQPC158AVARESE,
               AQPC158AVAVRES = p_AQPC158AVAVRES,
               AQPC158AVHRESE = p_AQPC158AVHRESE, */
               
               AQPC824AacMd39 = p_AQPC158AacMd39,
               AQPC824AVROTI  = p_AQPC158AVROTI,
               AQPC824AVRVOTI = p_AQPC158AVRVOTI,
               AQPC824AVAOTI  = p_AQPC158AVAOTI,
               AQPC824AVAVOTI = p_AQPC158AVAVOTI,
               AQPC824AVHOTI  = p_AQPC158AVHOTI,
               
               AQPC824AacMd40 = p_AQPC158AacMd40,
               AQPC824AVRGFM  = p_AQPC158AVRGFM,
               AQPC824AVRVGFM = p_AQPC158AVRVGFM,
               AQPC824AVAGFM  = p_AQPC158AVAGFM,
               AQPC824AVAVGFM = p_AQPC158AVAVGFM,
               AQPC824AVHGFM  = p_AQPC158AVHGFM,
               
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
               
               AQPC824AacMd43 = p_AQPC158AacMd43,
               AQPC824AVRRNET = p_AQPC158AVRRNET,
               AQPC824AVRVRNT = p_AQPC158AVRVRNT,
               AQPC824AVARNET = p_AQPC158AVARNET,
               AQPC824AVAVRNE = p_AQPC158AVAVRNE,
               AQPC824AVHRNET = p_AQPC158AVHRNET,
               
               AQPC824ARTLIQ1 = p_AQPC158ARTLIQ1,
               AQPC824ARTRCX1 = p_AQPC158ARTRCX1,
               AQPC824ATRRDI1 = p_AQPC158ATRRDI1,
               AQPC824ATREND1 = p_AQPC158ATREND1,
               AQPC824ATRROE1 = p_AQPC158ATRROE1,
               AQPC824ATRRCR1 = p_AQPC158ATRRCR1,
               
               AQPC824ARTLIQ2 = p_AQPC158ARTLIQ2,
               AQPC824ARTRCX2 = p_AQPC158ARTRCX2,
               AQPC824ATRRDI2 = p_AQPC158ATRRDI2,
               AQPC824ATREND2 = p_AQPC158ATREND2,
               AQPC824ATRROE2 = p_AQPC158ATRROE2,
               AQPC824ATRRCR2 = p_AQPC158ATRRCR2,
               --nuevos campos
               AQPC824aacmd44 = p_aqpc158aacmd44,
               AQPC824aacrota = p_aqpc158aacrota,
               AQPC824aacaota = p_aqpc158aacaota,
               AQPC824aarvota = p_aqpc158aarvota,
               AQPC824aaavota = p_aqpc158aaavota,
               AQPC824aaahota = p_aqpc158aaahota,
               
               AQPC824aacmd45 = p_aqpc158aacmd45,
               AQPC824avcrgtv = p_aqpc158avcrgtv,
               AQPC824avcagtv = p_aqpc158avcagtv,
               AQPC824avrvgtv = p_aqpc158avrvgtv,
               AQPC824avavgtv = p_aqpc158avavgtv,
               AQPC824avahgtv = p_aqpc158avahgtv,
               
               AQPC824aacmd46 = p_aqpc158aacmd46,
               AQPC824avrrgad = p_aqpc158avrrgad,
               AQPC824avargad = p_aqpc158avargad,
               AQPC824avrvgad = p_aqpc158avrvgad,
               AQPC824avavgad = p_aqpc158avavgad,
               AQPC824avhrgad = p_aqpc158avhrgad,
               
               AQPC824aacmd47 = p_aqpc158aacmd47,
               AQPC824avrruto = p_aqpc158avrruto,
               AQPC824avaruto = p_aqpc158avaruto,
               AQPC824avrvuto = p_aqpc158avrvuto,
               AQPC824avavuto = p_aqpc158avavuto,
               AQPC824avhruto = p_aqpc158avhruto,
               
               AQPC824aacmd48 = p_aqpc158aacmd48,
               AQPC824avrrgfi = p_aqpc158avrrgfi,
               AQPC824avargfi = p_aqpc158avargfi,
               AQPC824avrvgfi = p_aqpc158avrvgfi,
               AQPC824avavgfi = p_aqpc158avavgfi,
               AQPC824avhrgfi = p_aqpc158avhrgfi,
               
               AQPC824aacmd49 = p_aqpc158aacmd49,
               AQPC824avrrigf = p_aqpc158avrrigf,
               AQPC824avarigf = p_aqpc158avarigf,
               AQPC824avrvigf = p_aqpc158avrvigf,
               AQPC824avavigf = p_aqpc158avavigf,
               AQPC824avhrigf = p_aqpc158avhrigf,
               
               AQPC824aacmd50 = p_aqpc158aacmd50,
               AQPC824avrrgdi = p_aqpc158avrrgdi,
               AQPC824avargdi = p_aqpc158avargdi,
               AQPC824avrvgdi = p_aqpc158avrvgdi,
               AQPC824avavgdi = p_aqpc158avavgdi,
               AQPC824avhrgdi = p_aqpc158avhrgdi,
               
               AQPC824aacmd51 = p_aqpc158aacmd51,
               AQPC824avrruim = p_aqpc158avrruim,
               AQPC824avaruim = p_aqpc158avaruim,
               AQPC824avrvuim = p_aqpc158avrvuim,
               AQPC824avavuim = p_aqpc158avavuim,
               AQPC824avhruim = p_aqpc158avhruim,
               
               AQPC824aacmd52 = p_aqpc158aacmd52,
               AQPC824avrrutn = p_aqpc158avrrutn,
               AQPC824avarutn = p_aqpc158avarutn,
               AQPC824avrvutn = p_aqpc158avrvutn,
               AQPC824avavutn = p_aqpc158avavutn,
               AQPC824avhrutn = p_aqpc158avhrutn
         WHERE AQPC824CODOPI = p_AQPC158CODOPI;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
    END IF;
  
  End;

  procedure sp_obtcorr_aqpc156(Instancia number, CodOpinion out number) is
    -- *****************************************************************
    -- Nombre                     : sp_obtcorr_aqpc156
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Obtiene el correlativo
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************     
    --mod 24072023
    auxCorr       number(10);
    flgExis       varchar2(1);
    auxCodOpini   number(10);
    auxCod        number(10);
    codOpiniAsign number(10);
    auxHora       varchar2(10);
    auxFechaHoy   Date;
    valExis156    varchar2(1);
  
    AnioActual      number(4); --15/12/2023
    AnioGuia        number(4);
    OpinionEstandar number(10);
  begin
    auxCorr := 0;
  
    codOpiniAsign := 0;
    CodOpinion    := 0;
  
    --15/12/2023
    AnioGuia := 2023;
    BEGIN
      SELECT TP1NRO3
        into AnioGuia
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND TP1CORR1 = 53
         and tp1corr2 = 4
         AND TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        AnioGuia := 2023;
    END;
  
    AnioActual := 0;
    BEGIN
      SELECT extract(Year from PGFAPE) as anio
        INTO AnioActual
        FROM FST017
       WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        AnioActual := to_number(TO_char(SYSDATE, 'yyyy')) * 1;
    END;
  
    IF AnioGuia <> AnioActual THEN
      BEGIN
        UPDATE FST198
           SET TP1NRO3 = AnioActual
         WHERE TP1COD = 1
           AND TP1COD1 = 11152
           AND TP1CORR1 = 53
           and tp1corr2 = 4
           AND TP1CORR3 = 1;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
    AnioActual := AnioActual * 1;
  
    OpinionEstandar := AnioActual * 1000000;
  
    --15/12/2023
    valExis156 := 'S';
    WHILE (valExis156 = 'S') LOOP
      auxCorr := 0; -- 15/12/2023
    
      --15/12/2023
      IF AnioGuia = AnioActual THEN
        --        
        BEGIN
          SELECT MAX(F.AQPC815CODOPIN) INTO auxCorr FROM AQPC815 F;
        EXCEPTION
          WHEN OTHERS THEN
            auxCorr := 0;
        END;
        -------
        auxCorr := NVL(auxCorr, 0);
        IF auxCorr >= OpinionEstandar THEN
          auxCorr := auxCorr + 1;
        ELSE
          auxCorr := OpinionEstandar + auxCorr + 1;
        END IF;
      ELSE
        auxCorr := OpinionEstandar + 1;
      END IF;
      --              
    
      --auxCorr := auxCorr + 1;                      
    
      auxHora := to_char(SYSDATE, 'HH24:MI:SS');
      BEGIN
        SELECT T.PGFAPE INTO auxFechaHoy FROM FST017 T WHERE PGCOD = 1;
      EXCEPTION
        WHEN OTHERS THEN
          auxFechaHoy := to_date(SYSDATE, 'dd/mm/rrrr');
      END;
    
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
                (AQPC815CODOPIN, AQPC815INSTAN, AQPC815FECHA, AQPC815HORA)
              VALUES
                (auxCorr, Instancia, auxFechaHoy, auxHora);
              COMMIT;
          END;
      END;
    END IF;
  
    CodOpinion := auxCorr;
    /*ELSE
      CodOpinion := codOpiniAsign;
    END IF;*/
  end;

  procedure sp_cargar_solic_pend_opinion(instancia      number,
                                         ubuser         varchar2,
                                         UsuarSuplencia varchar2,
                                         fechHoy        date,
                                         xIdentfPerf    number,
                                         flgTerm        out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cargar_solic_pend_opinion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Obtiene las solicitudes pendientes
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                          
    auxUsu            varchar2(10);
    auxCta            numeric(9);
    auxOper           numeric(9);
    fechaHoy          date;
    AUXASES           VARCHAR2(10);
    auxint            numeric(10);
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
    
  
    --vi_tieneOpinion number(2);
    vi_TipoOpinion varchar2(50);
    vi_mensaje     varchar2(200);
  
    TipoSegmento    number(4) := 0;
    FlagExFechSolic varchar2(1) := 'N';
    ln_SegEvaluc    number(4) := 0;
    ln_CambSegmnto  varchar2(1) := '';
  
    xSucur     number(4); --18/12/2023
    xMonedCred number(4);
    xPapl      number(4);
    xSubOperac number(4);
    xTipoOperc number(4);
    
    FlgRpta           Varchar2(1);
    FlgPertencAnaliIng varchar2(1);
    FlgNivel          number(2);
    v_AnaliDeri156    varchar2(10);
    v_Estop156      varchar2(2); 
    xreg            number(10);   
    ratiopyme       NUMBER(12,6);
    ratioconsm       NUMBER(12,6);
    flgNoExi400      varchar2(1);
    
    CURSOR INSTNC_PEND IS

      SELECT JAQA400AI1 AS NroSolicitud
        FROM jaqa400
       WHERE JAQA400EMP = 1
         AND JAQA400FEC = fechHoy
         AND JAQA400AI1 = instancia
         AND JAQA400EST in ('E', 'A')
         and rownum < 2 --E : evaluación           
      union
      select tp1imp1
        from fst198
       Where tp1cod = 1
         and tp1cod1 = 11152
         and tp1corr1 = 50
         and tp1corr2 = 2
         and tp1corr3 > 0
         and tp1imp1 = instancia;
  
    CURSOR Dataos156_ASRiesgo(usuario       varchar2,
                              nivel         number,
                              estado        varchar2,
                              xUsuSuplencia varchar2) IS
      SELECT *
        FROM AQPC818
       WHERE AQPC818NIVEL = nivel
         AND (trim(AQPC818USRDER) = trim(usuario) or
             trim(AQPC818USRDER) = xUsuSuplencia)
         and (trim(AQPC818ESTOP) <> 'T' AND trim(AQPC818ESTOP) <> 'X')
         AND AQPC818ESTAD = 'H';
  
  BEGIN
    auxUsu := trim(UPPER(ubuser));
  
    Exis156 := 'N';
    BEGIN
      SELECT 'S'
        INTO Exis156
        FROM AQPC818
       WHERE AQPC818CODOPI =
             (SELECT MAX(AQPC818CODOPI)
                FROM AQPC818
               WHERE AQPC818INSTAN = instancia)
         AND AQPC818INSTAN = instancia
         AND AQPC818ESTAD = 'H' --2108   
         AND AQPC818AUX3 = fechHoy; --07112023    
         --AND AQPC818NIVEL > 1; --18112024
    EXCEPTION
      when OTHERS THEN
        Exis156 := 'N';
    END;
  
    IF Exis156 = 'N' AND instancia > 0 THEN
      flgTieneAsignad := 'N'; --31072023
      --validar zona asignada para analista riesgos  -- INI MOD 24072023  
      BEGIN
        pq_cr_repo_opini_riesgos_crm.sp_val_zona_soli_pertenc_AnaliRiesgo(instancia,
                                                                          ubuser,
                                                                          flgTieneAsignad);
      EXCEPTION
        WHEN OTHERS THEN
          flgTieneAsignad := 'N';
      END; -- FIN MOD 24072023  
    
      ---16082023 Validar si está registrado en guia, en casos que se necesiten se gestionados por otros ya que no está grabado en la AQPC818.
      flgSoliRegGuia := 'N';
      BEGIN
        SELECT 'S'
          INTO flgSoliRegGuia
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11152
           AND TP1CORR1 = 50
           AND TP1CORR2 = 2
           AND TP1CORR3 > 0
           AND TP1IMP1 = instancia;
      EXCEPTION
        WHEN OTHERS THEN
          flgSoliRegGuia := 'N';
      END;
      ---16082023
    
      IF flgTieneAsignad = 'S' OR flgSoliRegGuia = 'S' THEN
        flgNoExi400 := 'N';
        FOR r in INSTNC_PEND loop
          flgNoExi400 := 'S';
          --rcastro 07/12/2023 - validar segmento pyme o consumo  1 - PYME, 2 - CONSUMO
          BEGIN
            pq_cr_verificasegmento.sp_cr_verifsegmnto(instancia,
                                                      ln_SegEvaluc,
                                                      TipoSegmento,
                                                      ln_CambSegmnto);
          EXCEPTION
            WHEN OTHERS THEN
              TipoSegmento := 0;
          END;
        
          FlagExFechSolic := 'N';
          IF TipoSegmento = 1 THEN
            --PYME validar que exista con la fecha actual
            BEGIN
              SELECT 'S'
                INTO FlagExFechSolic
                FROM jaqy140b
               WHERE JAQY140FEC = fechHoy
                 AND JAQY140INST = instancia
                 AND JAQY140EST = 'H';
            EXCEPTION
              WHEN OTHERS THEN
                FlagExFechSolic := 'N';
            END;
          ELSE
            IF TipoSegmento = 2 THEN
              --Consumo
              BEGIN
                SELECT 'S'
                  INTO FlagExFechSolic
                  FROM jaqz821b
                 WHERE JAQZ821FEC = fechHoy
                   AND JAQZ821INST = instancia
                   AND JAQZ821EST = 'H';
              EXCEPTION
                WHEN OTHERS THEN
                  FlagExFechSolic := 'N';
              END;
            END IF;
          END IF;
        
          IF FlagExFechSolic = 'S' THEN
            ---rcastro 07/12/2023
          
            auxint  := r.NroSolicitud;
            Exis156 := 'N'; --3107
            BEGIN
              SELECT 'S'
                INTO Exis156
                FROM AQPC818
               WHERE AQPC818CODOPI =
                     (SELECT MAX(AQPC818CODOPI)
                        FROM AQPC818
                       WHERE AQPC818INSTAN = auxint)
                 AND AQPC818INSTAN = auxint
                 AND AQPC818ESTAD = 'H' --2108 
                 AND AQPC818AUX3 = fechHoy; --07112023 
                 --AND AQPC818NIVEL > 1; --18112024
            EXCEPTION
              when OTHERS THEN
                Exis156 := 'N';
            END;
          
          
            IF Exis156 = 'N' THEN
              --AND vi_tieneOpinion <> 1 THEN
             begin
              pq_cr_repo_opini_riesgos_crm.sp_obtener_datos_Opinion(auxint,
                                                                    NomClie,
                                                                    xMontoCred,
                                                                    xDescMod,
                                                                    auxCta,
                                                                    auxOper,
                                                                    xDescProd,
                                                                    xDescTipoSolic,
                                                                    AUXASES,
                                                                    xFechIngr);
            EXCEPTION                                                                    
              WHEN OTHERS THEN
                NULL;
            end;
                                                                    
            BEGIN
              pq_cr_repo_opinion_riesgos.sp_descripcion_ArbolPerfiles(xIdentfPerf,
                                                                      v_DescEtap); --18112024
            EXCEPTION
              when OTHERS THEN
                NULL;
            END;                                                                    
            
              --PRUEBA CAMBIAR EL S
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
                   AQPC194ANSRIEG) --11/12/2023 rcastro
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
                   v_DescEtap, -- '3-ANALISTA SENIOR DE ADMISIÓN Y SEGUIMIENTO', --'1-ANALISTA CRÉDITOS', 18112024
                   xIdentfPerf, --3, --1  18112024
                   'Pendiente',
                   auxUsu,
                   auxUsu);
                commit;            
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
            END IF;
          ELSE                        
             flgTerm := 'No se encontró datos de ratios, intentar nuevamente.';
             if TipoSegmento = 1 then
                BEGIN
                  select count(1)
                    into xreg
                    from jaqz516 e, jaqz517 w
                   WHERE  e.jaqz516sol = instancia 
                   and e.jaqz516eval = w.jaqz517eval
                   and e.JAQZ516FEC = fechHoy;
                EXCEPTION
                  WHEN OTHERS THEN
                    NULL;
                END;
             ELSE 
                IF TipoSegmento = 2 THEN
                   BEGIN
                    select count(1)
                    into xreg
                    from jaqm400 j
                   where j.jaqm400ins = instancia
                     and j.jaqm400fec = fechHoy;
                   EXCEPTION 
                     WHEN OTHERS THEN
                       NULL;
                   END;
                END IF;
             end if; 
             
             IF xreg > 0 THEN
                begin
                PQ_CR_RATIOS_REPROCAP.sp_cr_inicio(instancia,
                                                   fechHoy,
                                                   auxUsu,
                                                   ratiopyme,
                                                   ratioconsm);
              exception
                when others then
                  null;
              end;
             ELSE 
               flgTerm := 'No se cargó la evaluación con la fecha actual.';
             END IF;                          
          END IF;
        END LOOP;
        
        IF flgNoExi400 = 'N' THEN
           flgTerm := 'La solicitud no ha sido gestionada por CRM con fecha actual.';
        END IF;
        
      ELSE --01042024 alertas para el panel
         flgTerm := 'El usuario ' || auxUsu || ' no esta asignado a la zona/sucursal de la instancia ' || to_char(instancia);
      END IF;
      
    ELSIF Exis156 = 'S' AND instancia > 0 THEN  --caso donde se busca por instancia para solicitu q ya existen en aqpc156
      
      BEGIN
          SELECT AQPC818NIVEL, TRIM(AQPC818USRDER), TRIM(AQPC818ESTOP)
                 INTO FlgNivel, v_AnaliDeri156, v_Estop156 
          FROM AQPC818
          WHERE AQPC818CODOPI =
                   (SELECT (MAX(B.AQPC818CODOPI))
                      FROM AQPC818 B
                     WHERE B.AQPC818INSTAN = instancia                        
                       AND AQPC818ESTAD = 'H'
                       AND AQPC818AUX3 = fechHoy) 
           AND AQPC818INSTAN = instancia           
           and (trim(AQPC818ESTOP) <> 'T')
           AND AQPC818ESTAD = 'H'
           AND AQPC818AUX3 = fechHoy;
      EXCEPTION 
        WHEN OTHERS THEN
          NULL;        
      END;
      
      FlgNivel := NVL(FlgNivel, 0);
      FlgPertencAnaliIng := 'N';           
      IF TRIM(UPPER(v_AnaliDeri156)) = ubuser THEN
         FlgPertencAnaliIng :=  'S';
      END IF;      
                  
         
      flgTerm := '';    
      IF FlgNivel IN (1, 2, 3) THEN --18112024
          IF FlgPertencAnaliIng = 'S' THEN
             IF trim(v_Estop156) <> ('X') THEN
                BEGIN
                pq_cr_repo_opini_riesgos_CRM.sp_consul_por_solic156(instancia, ubuser, fechHoy, flgTerm);
                EXCEPTION 
                  WHEN OTHERS THEN
                    NULL;
                END;
             ELSE 
                flgTerm := 'La solicitud ' || to_char(instancia) || ' no está vigente';     
             END IF;
          ELSE 
              IF (v_AnaliDeri156 is not null or v_AnaliDeri156 <> ' ') and trim(v_Estop156) <> ('X') THEN
                 flgTerm := 'la instancia ' || to_char(instancia) || ' fue asignada al analista ' || trim(v_AnaliDeri156);                          
              END IF;
          END IF;
     ELSE 
          IF FlgNivel >= 1 and trim(v_Estop156) <> ('X') THEN    --18112024
             flgTerm := 'la solicitud ' || to_char(instancia) || ' fue derivado al usuario ' || trim(v_AnaliDeri156); 
          END IF;
     END IF;    --01042024    
      
    ELSE
      --  ELSE    --  IF xIdentfPerf = 3 THEN    10072023 
      FOR r in Dataos156_ASRiesgo(ubuser, xIdentfPerf, 'V', UsuarSuplencia) loop 
        auxint := r.aqpc818instan; --r.aqpc156instan;
      
        flgTerm := '';
        BEGIN
        pq_cr_repo_opini_riesgos_CRM.sp_consul_por_solic156(auxint, ubuser, fechHoy,  flgTerm); --01042024
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
    -- *****************************************************************
    -- Nombre                     : sp_cargar_opiniones_156
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Carga las opiniones
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                      
    CURSOR lista_opiniones(fechax date) IS
      SELECT *
        FROM AQPC818
       WHERE 
         AQPC818AUX3 = fechax and --18112024
         (AQPC818ESTOP <> 'X ' AND AQPC818ESTOP <> 'T ')
         AND AQPC818ESTAD = 'H'
         AND AQPC818NIVEL >= 1;           
         
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
  
    xSucur     number(4);
    xMonedCred number(4);
    xPapl      number(4);
    xSubOperac number(4);
    xTipoOperc number(4);
    x_FechActual date;
  BEGIN
    -- DELETE FROM AQPC194 WHERE TRIM(AQPC194USUEJ) = TRIM(auxUsu);  --30062023
    -- commit;
    BEGIN
      SELECT PGFAPE INTO x_FechActual FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END;
    
  
    FOR r in lista_opiniones(x_FechActual) LOOP
      auxint := r.AQPC818instan;
    
      --Validar si instancia está vigente  31072023
      /* flgSolicActivo := 'N';
      BEGIN
        pq_cr_repo_opini_riesgos_crm.sp_validar_vigent_solic(auxint,
                                                           flgSolicActivo);
      EXCEPTION
        WHEN OTHERS THEN
          flgSolicActivo := 'N';
      END;
      
      IF flgSolicActivo = 'S' THEN*/
      BEGIN
        SELECT B.XWFMODULO,
               B.XWFTIPOPE,
               B.XWFCUENTA,
               B.XWFOPERACION,
               B.XWFMONTO1,
               C.PENOM,
               B.XWFSUCURSAL,
               B.XWFMONEDA,
               B.XWFPAPEL,
               B.XWFSUBOPE
          INTO xModul,
               xTipoOper,
               auxCta,
               auxOper,
               xMontoCred,
               NomClie,
               xSucur,
               xMonedCred,
               xPapl,
               xSubOperac --18/12/2023
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
          xTipoOper  := 0;
          xSucur     := 0;
          xMonedCred := 0;
          xPapl      := 0;
          xSubOperac := 0;
      END;
      xMontoCred := nvl(xMontoCred, 0);
      --IF xMontoCred = 0 THEN --04012024
      BEGIN
        SELECT XLLCAPITAL
          INTO xMontoCred
          FROM x054023
         WHERE XLLPGCOD = 1
           AND XLLAOMOD = xModul
           AND XLLAOSUC = xSucur
           AND XLLAOMDA = xMonedCred
           AND XLLAOPAP = xPapl
           AND XLLAOCTA = auxCta
           AND XLLAOOPER = auxOper
           AND XLLAOSBOP = 609
           AND XLLAOTOP = xTipoOper;
      EXCEPTION
        WHEN OTHERS THEN
          xMontoCred := 0;
      END;
      --END IF; 
    
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
        pq_cr_repo_opini_riesgos_crm.sp_obtn_Asesor(auxint,
                                                    AUXASES,
                                                    xFechIngr);
        /*SELECT SNG001ASE, SNG001FIN, SNG001ORI
         INTO AUXASES, xFechIngr, xCodTipSoli
         FROM SNG001
        WHERE SNG001INST = auxint;*/
        xCodTipSoli := 13; --PRUEBA
      EXCEPTION
        when OTHERS THEN
          AUXASES     := '';
          xFechIngr   := '';
          xCodTipSoli := 0;
      END;
    
      BEGIN
      --xDescTipoSolic := 'Reprogramación CRM'; --27/09/2024
        pq_cr_repo_opini_riesgos_CRM.sp_tipoReprogr_CRM(auxint, xDescTipoSolic);
      EXCEPTION
        when OTHERS THEN
         xDescTipoSolic := 'Reprogramación CRM';        
      END;

    
      --Consultar AQPC818
      BEGIN
        SELECT C.AQPC818CODOPI, c.AQPC818nivel, TRIM(c.AQPC818ESTOP)
          INTO v_codOpin, x_nivel156, x_EstadOpini
          FROM AQPC818 C
         WHERE C.AQPC818CODOPI =
               (SELECT (MAX(B.AQPC818CODOPI))
                  FROM AQPC818 B
                 WHERE B.AQPC818INSTAN = auxint
                   AND AQPC818ESTAD = 'H') --2108)
           AND C.AQPC818INSTAN = auxint
           AND AQPC818ESTAD = 'H'; --2108;
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
      IF TRIM(R.AQPC818ESTOP) = 'P' THEN
        x_estado_Opinion := 'Pendiente';
      END IF;
      IF TRIM(R.AQPC818ESTOP) = 'V' THEN
        x_estado_Opinion := 'Viable';
      ELSE
        IF TRIM(R.AQPC818ESTOP) = 'NV' THEN
          x_estado_Opinion := 'No viable';
        ELSE
          IF TRIM(R.AQPC818ESTOP) = 'O' THEN
            x_estado_Opinion := 'Observado';
          ELSE
            IF TRIM(R.AQPC818ESTOP) = 'D' THEN
              x_estado_Opinion := 'Devuelto';
            ELSE
              IF TRIM(R.AQPC818ESTOP) = 'T' THEN
                x_estado_Opinion := 'Completado';
              ELSE
                IF TRIM(R.AQPC818ESTOP) = 'X' THEN
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
          (R.AQPC818INSTAN,
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
           r.AQPC818usrder,
           r.AQPC818ANSERIG);
        commit;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      --END IF;
    END LOOP;
  END;
  
  procedure sp_consul_por_solic156(auxint number, ubuser varchar2, fechHoy DATE, mensajeErro out varchar2) is   
    auxCta            numeric(9);
    auxOper           numeric(9);    
    AUXASES           VARCHAR2(10);    
    Exis156           VARCHAR2(1);
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
    v_DescEtap        varchar2(50);
    x_nivel156        number(3);
    x_EstadOpini      varchar2(2);
    x_AnlSeniRiDeriv  varchar2(10);
    x_estado_Opinion  varchar2(10);
    flgTieneAsignad   varchar2(1);
    x_usuarioDerivd   VARCHAR2(10);

  
    xSucur     number(4); --18/12/2023
    xMonedCred number(4);
    xPapl      number(4);
    xSubOperac number(4);   
  BEGIN
     --validar zona asignada para analista riesgos  -- INI MOD 24072023  
        flgTieneAsignad := 'N';
        BEGIN
          pq_cr_repo_opini_riesgos_crm.sp_val_zona_soli_pertenc_AnaliRiesgo(auxint,
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
                   C.PENOM,
                   B.XWFSUCURSAL,
                   B.XWFMONEDA,
                   B.XWFPAPEL,
                   B.XWFSUBOPE
              INTO xModul,
                   xTipoOper,
                   auxCta,
                   auxOper,
                   xMontoCred,
                   NomClie,
                   xSucur,
                   xMonedCred,
                   xPapl,
                   xSubOperac
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
              xSucur     := 0;
              xMonedCred := 0;
              xPapl      := 0;
              xSubOperac := 0;
          END;
        
          xMontoCred := nvl(xMontoCred, 0);
          --IF xMontoCred = 0 THEN --04012024
          BEGIN
            SELECT XLLCAPITAL
              INTO xMontoCred
              FROM x054023
             WHERE XLLPGCOD = 1
               AND XLLAOMOD = xModul
               AND XLLAOSUC = xSucur
               AND XLLAOMDA = xMonedCred
               AND XLLAOPAP = xPapl
               AND XLLAOCTA = auxCta
               AND XLLAOOPER = auxOper
               AND XLLAOSBOP = 609
               AND XLLAOTOP = xTipoOper;
          EXCEPTION
            WHEN OTHERS THEN
              xMontoCred := 0;
          END;
          -- END IF; 
        
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
            pq_cr_repo_opini_riesgos_crm.sp_obtn_Asesor(auxint,
                                                        AUXASES,
                                                        xFechIngr);
            /*SELECT SNG001ASE, SNG001FIN, SNG001ORI
             INTO AUXASES, xFechIngr, xCodTipSoli
             FROM SNG001
            WHERE SNG001INST = auxint;*/
          
            xCodTipSoli := 13;
          EXCEPTION
            when OTHERS THEN
              AUXASES     := '';
              xFechIngr   := '';
              xCodTipSoli := 0;
          END;        
                 
          BEGIN
          --xDescTipoSolic := 'Reprogramación CRM'; --27/09/2024
            pq_cr_repo_opini_riesgos_CRM.sp_tipoReprogr_CRM(auxint, xDescTipoSolic);
          EXCEPTION
            when OTHERS THEN
             xDescTipoSolic := 'Reprogramación CRM';        
          END;
          
        
          --Consultar AQPC818
          BEGIN
            SELECT C.AQPC818CODOPI,
                   c.AQPC818nivel,
                   TRIM(c.AQPC818ESTOP),
                   c.AQPC818ANSERIG,
                   C.AQPC818USRDER
              INTO v_codOpin, x_nivel156, x_EstadOpini, x_AnlSeniRiDeriv, x_usuarioDerivd
              FROM AQPC818 C
             WHERE C.AQPC818CODOPI =
                   (SELECT (MAX(B.AQPC818CODOPI))
                      FROM AQPC818 B
                     WHERE B.AQPC818INSTAN = auxint
                       AND C.AQPC818AUX3 = fechHoy
                       AND AQPC818ESTAD = 'H') --2108)
               AND C.AQPC818INSTAN = auxint
               AND C.AQPC818AUX3 = fechHoy
               AND C.AQPC818ESTAD = 'H'; --2108 ;
          EXCEPTION
            when OTHERS THEN
              Exis156          := 'N';
              v_codOpin        := 0;
              x_nivel156       := 0;
              x_EstadOpini     := '';
              x_AnlSeniRiDeriv := '';
          END;
          -- obtener etapa
          --pq_cr_repo_opinion_riesgos.sp_validar_Etapa_Opin(auxint,v_codOpin, v_codNivel ,v_DescEtap);
          v_DescEtap := '';
          BEGIN
            pq_cr_repo_opinion_riesgos.sp_descripcion_ArbolPerfiles(x_nivel156,
                                                                    v_DescEtap); --18112024
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
               AQPC194ANSRIEG --11/12/2023 rcastro                                                                                      
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
        ELSE --01042024 alertas para el panel
               mensajeErro := 'El usuario ' || TRIM(ubuser) || ' no esta asignado a la zona/sucursal de la instancia ' || to_char(auxint);           
        END IF;
  END;

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
    -- *****************************************************************
    -- Nombre                     : sp_cargar_opiniones_156
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Obtiene los datos de la opinion
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                      
    xModul      NUMBER(3);
    xTipoOper   NUMBER(3);
    xCodTipSoli NUMBER(3);
    xSucur      number(4);
    xMonedCred  number(4);
    xPapl       number(4);
    xSubOperac  number(4);
    xTipoOperc  number(4);
    fechHoy     DATE;
  BEGIN
    BEGIN
      SELECT B.XWFMODULO,
             B.XWFTIPOPE,
             B.XWFCUENTA,
             B.XWFOPERACION,
             B.XWFMONTO1,
             C.PENOM,
             B.XWFSUCURSAL,
             B.XWFMONEDA,
             B.XWFPAPEL,
             B.XWFSUBOPE
        INTO xModul,
             xTipoOper,
             auxCta,
             auxOper,
             xMontoCred,
             NomClie,
             xSucur,
             xMonedCred,
             xPapl,
             xSubOperac --18/12/2023
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
        xSucur     := 0;
        xMonedCred := 0;
        xPapl      := 0;
        xSubOperac := 0;
        xTipoOper  := 0;
    END;
    xMontoCred := nvl(xMontoCred, 0);
    --IF xMontoCred = 0 THEN --04012024
    BEGIN
      SELECT XLLCAPITAL
        INTO xMontoCred
        FROM x054023
       WHERE XLLPGCOD = 1
         AND XLLAOMOD = xModul
         AND XLLAOSUC = xSucur
         AND XLLAOMDA = xMonedCred
         AND XLLAOPAP = xPapl
         AND XLLAOCTA = auxCta
         AND XLLAOOPER = auxOper
         AND XLLAOSBOP = 609
         AND XLLAOTOP = xTipoOper;
    EXCEPTION
      WHEN OTHERS THEN
        xMontoCred := 0;
    END;
    --END IF; 
  
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
      pq_cr_repo_opini_riesgos_crm.sp_obtn_Asesor(auxint,
                                                  AUXASES,
                                                  xFechIngr);
      /*SELECT SNG001ASE, SNG001FIN, SNG001ORI
       INTO AUXASES, xFechIngr, xCodTipSoli
       FROM SNG001
      WHERE SNG001INST = auxint;*/
    
      xCodTipSoli := 13; --PRUEBA
    EXCEPTION
      when OTHERS THEN
        AUXASES     := '';
        xFechIngr   := '';
        xCodTipSoli := 0;
    END;
     
    BEGIN
      SELECT PGFAPE INTO fechHoy FROM FST017 WHERE PGCOD = 1;
    END;
    
    BEGIN
    --xDescTipoSolic := 'Reprogramación CRM'; --27/09/2024
      pq_cr_repo_opini_riesgos_CRM.sp_tipoReprogr_CRM(auxint, xDescTipoSolic);
    EXCEPTION
      when OTHERS THEN
       xDescTipoSolic := 'Reprogramación CRM';        
    END;
    

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
    -- *****************************************************************
    -- Nombre                     : sp_grabar_comentarios_ACR_GA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Graba los comentarios
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                          
    xcargo varchar2(40);
    xfecha date;
    xcorr2 NUMBER(10);
  
    TipoComentario     NUMBER(3);
    xHora              varchar2(8);
    v_ArgumReconsid    varchar2(4000);
    v_AnaliComReconsid varchar2(4000);
    v_ResolucReconsid  varchar2(4000);
    v_CondicReconsid   varchar2(4000);
  
    xComenObserv  VARCHAR2(4000);
    v_nroreconsid number(3);
    flgEstObser   VARCHAR2(1);
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
      select max(AQPC819CORR)
        into xcorr2
        from AQPC819
       where AQPC819CODOPI = codopini
         AND AQPC819INST = instancia
         AND AQPC819ESTAD = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        xcorr2 := 0;
    end;
    xcorr2 := nvl(xcorr2, 0); --22012024
  
    /*--07112023
    BEGIN
      SELECT AQPC819MOTOBSV
        INTO xComenObserv
        FROM AQPC819
       WHERE AQPC819CODOPI = codopini
         AND AQPC819CORR = xcorr2
         AND AQPC819INST = instancia
         AND AQPC819ESTAD = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        xComenObserv := ' ';
    END;
    
    BEGIN
      SELECT AQPC818NRECONS INTO v_nroreconsid FROM AQPC818 WHERE 
      AQPC818CODOPI = codopini
      AND AQPC818INSTAN = instancia
      AND AQPC818ESTAD = 'H';
    EXCEPTION 
        WHEN OTHERS THEN
        v_nroreconsid := 0;
    END;
    
    ----
    
    xcorr2 := xcorr2 + 1;
    
    BEGIN
      UPDATE AQPC819
         SET AQPC819ESTAD = 'I'
       WHERE AQPC819CODOPI = codopini
         AND AQPC819INST = instancia
         AND (AQPC819ESTAD = 'H' OR AQPC819ESTAD IS NULL);
      COMMIT;
    END;   */
    BEGIN
      pq_cr_repo_opini_riesgos_crm.sp_grab_log_aqpc171(codopini, instancia);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    /*-- mod 01032023    
    BEGIN
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
      --------
      IF xcorr2 > 0 THEN
        BEGIN
          UPDATE AQPC819
             SET AQPC819USUR    = usuario,
                 AQPC819ANCNEG  = xAQPC171ANCNEG,
                 AQPC819ANVIC   = xAQPC171ANVIC,
                 AQPC819FCN     = xAQPC171FCN,
                 AQPC819AESFCC  = xAQPC171AESFCC,
                 AQPC819RDCLN   = xAQPC171RDCLN,
                 AQPC819ANCP    = xAQPC171ANCP,
                 AQPC819ANCPG   = xAQPC171ANCPG,
                 AQPC819DANDC   = xAQPC171DANDC,
                 AQPC819DGCOR   = xAQPC171DGCOR,
                 AQPC819RANCNEG = xAQPC171RANCNEG,
                 AQPC819MTREP   = xAQPC171MTREP,
                 AQPC819RAESFCC = xAQPC171RAESFCC,
                 AQPC819ANCPRF  = xAQPC171ANCPRF,
                 AQPC819ANVPG   = xAQPC171ANVPG,
                 AQPC819DEGV    = xAQPC171DEGV,
                 AQPC819RFANCNE = xAQPC171RFANCNE,
                 AQPC819MTREFN  = xAQPC171MTREFN,
                 AQPC819RFAESFC = xAQPC171RFAESFC,
                 AQPC819RFANCPR = xAQPC171RFANCPR,
                 AQPC819RFANVPG = xAQPC171RFANVPG,
                 AQPC819RFDEGV  = xAQPC171RFDEGV,
                 AQPC819USURAR  = usuario,
                 AQPC819COMEN   = xComentRiesgos,
                 AQPC819RESOL   = xResoluRiesgos,
                 AQPC819CONREC  = xCondiRecomRiesg,
                 AQPC819ARGRECO = xAQPC171ARGRECO,
                 AQPC819ANACOME = xAQPC171ANACOME,
                 AQPC819RESOLRE = xAQPC171RESOLRE,
                 AQPC819CONDREC = xAQPC171CONDREC
           WHERE AQPC819CODOPI = codopini
             AND AQPC819INST = instancia
             AND AQPC819ESTAD = 'H';
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
            FROM AQPC818 A
           WHERE AQPC818CODOPI = codopini
             AND AQPC818INSTAN = instancia
             AND AQPC818ESTAD = 'H'
             AND TRIM(AQPC818ESTOP) <> 'O';
        EXCEPTION
          WHEN OTHERS THEN
            flgEstObser := 'N';
        END;
      
        IF flgEstObser = 'S' THEN
          UPDATE AQPC819
             SET AQPC819MOTOBSV = ''
           WHERE AQPC819CODOPI = codopini
             AND AQPC819INST = instancia
             AND AQPC819ESTAD = 'H';
          COMMIT;
        END IF;
      
      ELSE
        BEGIN
          INSERT INTO AQPC819
            (AQPC819CODOPI,
             AQPC819CORR,
             AQPC819USUR,
             AQPC819FECPRO,
             AQPC819INST,
             --AQPC819CARGO   ,
             AQPC819ANCNEG,
             AQPC819ANVIC,
             AQPC819FCN,
             AQPC819AESFCC,
             AQPC819RDCLN,
             AQPC819ANCP,
             AQPC819ANCPG,
             AQPC819DANDC,
             AQPC819DGCOR,
             AQPC819RANCNEG,
             AQPC819MTREP,
             AQPC819RAESFCC,
             AQPC819ANCPRF,
             AQPC819ANVPG,
             AQPC819DEGV,
             AQPC819RFANCNE,
             AQPC819MTREFN,
             AQPC819RFAESFC,
             AQPC819RFANCPR,
             AQPC819RFANVPG,
             AQPC819RFDEGV,
             AQPC819USURAR,
             AQPC819COMEN,
             AQPC819RESOL,
             AQPC819CONREC,
             AQPC819ARGRECO,
             AQPC819ANACOME,
             AQPC819RESOLRE,
             AQPC819CONDREC,
             AQPC819HORAREG,
             AQPC819ESTAD)
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
    
      /*--para reconsideraciónes 
      v_ArgumReconsid    := '';
      v_AnaliComReconsid := '';
      v_ResolucReconsid  := '';
      v_CondicReconsid   := '';
      IF v_nroreconsid > 0 THEN--07112023--xAQPC156ESTOP = 'NV' THEN
        v_ArgumReconsid    := xAQPC171ARGRECO;
        v_AnaliComReconsid := xAQPC171ANACOME;
        v_ResolucReconsid  := xAQPC171RESOLRE;
        v_CondicReconsid   := xAQPC171CONDREC;
      END IF;
      
      IF TipoComentario = 1 THEN
        --Solicitud normal - ampliacion
        BEGIN
          INSERT INTO AQPC819
            (AQPC819CODOPI,
             AQPC819CORR,
             AQPC819USUR,
             AQPC819FECPRO,
             AQPC819INST,
             AQPC819CARGO,
             AQPC819ANCNEG,
             AQPC819ANVIC,
             AQPC819FCN,
             AQPC819AESFCC,
             AQPC819RDCLN,
             AQPC819ANCP,
             AQPC819ANCPG,
             AQPC819DANDC,
             AQPC819DGCOR,
             
             AQPC819USURAR, --ini 21082023
             AQPC819COMEN,
             AQPC819RESOL,
             AQPC819CONREC,
             AQPC819ARGRECO,
             AQPC819ANACOME,
             AQPC819RESOLRE,
             AQPC819CONDREC,
             AQPC819HORAREG,
             AQPC819ESTAD,
             AQPC819MOTOBSV) --fin 21082023
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
          INSERT INTO AQPC819
            (AQPC819CODOPI,
             AQPC819CORR,
             AQPC819USUR,
             AQPC819FECPRO,
             AQPC819INST,
             AQPC819CARGO,
             AQPC819RANCNEG,
             AQPC819MTREP,
             AQPC819RAESFCC,
             AQPC819ANCPRF,
             AQPC819ANVPG,
             AQPC819DEGV,
             
             AQPC819USURAR, --ini 21082023
             AQPC819COMEN,
             AQPC819RESOL,
             AQPC819CONREC,
             AQPC819ARGRECO,
             AQPC819ANACOME,
             AQPC819RESOLRE,
             AQPC819CONDREC,
             
             AQPC819HORAREG,
             AQPC819ESTAD, --21082023)
             AQPC819MOTOBSV)
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
          INSERT INTO AQPC819
            (AQPC819CODOPI,
             AQPC819CORR,
             AQPC819USUR,
             AQPC819FECPRO,
             AQPC819INST,
             AQPC819CARGO,
             
             AQPC819RFANCNE,
             AQPC819MTREFN,
             AQPC819RFAESFC,
             AQPC819RFANCPR,
             AQPC819RFANVPG,
             AQPC819RFDEGV,
             
             AQPC819USURAR, --ini 21082023
             AQPC819COMEN,
             AQPC819RESOL,
             AQPC819CONREC,
             AQPC819ARGRECO,
             AQPC819ANACOME,
             AQPC819RESOLRE,
             AQPC819CONDREC,
             
             AQPC819HORAREG,
             AQPC819ESTAD, --21082023)
             AQPC819MOTOBSV)
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
      END IF;
      --para reconsideraciones    INI MOD RCASTRO 10072023*/
    END IF;
  
  END;

  procedure sp_grabar_comentarios_riesgos(codopini       number,
                                          instancia      number,
                                          usuario        varchar2,
                                          NivelComent    number,
                                          xAQPC171COMEN  varchar2,
                                          xAQPC171RESOL  varchar2,
                                          xAQPC171CONREC varchar2) IS
    -- *****************************************************************
    -- Nombre                     : sp_grabar_comentarios_riesgos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Graba los comentarios
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                           
    xusuario varchar2(10); --2108                                                                                                                                                                    
  begin
    IF NivelComent = 3 THEN
      --ETAPA RIESGOS --21082023 COMENTADO
      xusuario := usuario;
    END IF;
  end;

  procedure sp_Consultar_codOpinio(instancia  number,
                                   flgEstado  varchar2,
                                   codNivel   number,
                                   codOpinio  out number,
                                   flgEstdOpi out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_Consultar_codOpinio
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Consultar codigo de opinion
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************    
    fechaActual date;
  begin
    codOpinio := 0;
  
    BEGIN
      SELECT W.PGFAPE INTO fechaActual FROM FST017 W WHERE W.PGCOD = 1;
    Exception
      When others then
        fechaActual := to_Date(sysdate, 'dd/MM/yyyy');
    END;
  
    BEGIN
      SELECT AQPC818CODOPI, AQPC818ESTOP
        INTO codOpinio, flgEstdOpi -- mod 10072023
        FROM AQPC818
       WHERE AQPC818CODOPI = (SELECT MAX(AQPC818CODOPI)
                                FROM AQPC818
                               WHERE AQPC818INSTAN = instancia
                                 AND AQPC818ESTAD = 'H')
         AND AQPC818INSTAN = instancia
         AND AQPC818ESTAD = 'H' --2108
         AND AQPC818AUX3 = fechaActual
         AND AQPC818NIVEL = codNivel;
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
    -- *****************************************************************
    -- Nombre                     : sp_actulizar_estado_156
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Actualizar el estado
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                     
  begin
    BEGIN
      pq_cr_repo_opini_riesgos_crm.sp_grab_log_aqpc156(codopinion,
                                                       instancia);
    END;
  
    CASE
    WHEN CodNivel = 1 THEN
        --18112024
        BEGIN
          UPDATE AQPC818
             SET --AQPC156GRAGE = p_UserDerivado, MOD 2402
                 AQPC818USRDER = AnalistaDerivado,
                 AQPC818ANSERIG = AnalistaDerivado,
                 AQPC818NIVEL   = CodNivel
           WHERE AQPC818CODOPI = codopinion
             AND AQPC818INSTAN = instancia
             AND AQPC818ESTAD = 'H'; --21082023
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;      
      WHEN CodNivel IN (2, 3) THEN
        BEGIN
          UPDATE AQPC818
             SET --AQPC156GRAGE = p_UserDerivado, MOD 2402
                 AQPC818USRDER = AnalistaDerivado,
                 --AQPC818ANSERIG = AnalistaDerivado,
                 AQPC818NIVEL   = CodNivel
           WHERE AQPC818CODOPI = codopinion
             AND AQPC818INSTAN = instancia
             AND AQPC818ESTAD = 'H'; --21082023
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      WHEN CodNivel = 4 THEN
        --OR CodNivel = 5 OR CodNivel = 6 THEN 1906
        BEGIN
          UPDATE AQPC818
             SET AQPC818NIVEL   = CodNivel,
                 AQPC818USRDER  = AnalistaDerivado,
                 AQPC818SUPADMI = AnalistaDerivado
           WHERE AQPC818CODOPI = codopinion
             AND AQPC818INSTAN = instancia
             AND AQPC818ESTAD = 'H'; --21082023
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      WHEN CodNivel = 5 THEN
        BEGIN
          UPDATE AQPC818
             SET AQPC818NIVEL   = CodNivel,
                 AQPC818USRDER  = AnalistaDerivado,
                 AQPC818JEFADMI = AnalistaDerivado
           WHERE AQPC818CODOPI = codopinion
             AND AQPC818INSTAN = instancia
             AND AQPC818ESTAD = 'H'; --21082023
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      WHEN CodNivel = 6 THEN
        BEGIN
          UPDATE AQPC818
             SET AQPC818NIVEL   = CodNivel,
                 AQPC818USRDER  = AnalistaDerivado,
                 AQPC818GERRIES = AnalistaDerivado
           WHERE AQPC818CODOPI = codopinion
             AND AQPC818INSTAN = instancia
             AND AQPC818ESTAD = 'H'; --21082023
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
    -- *****************************************************************
    -- Nombre                     : sp_actualizar_estado_opi_156
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Actualizar el estado
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                          
  begin
    BEGIN
      --2108
      pq_cr_repo_opini_riesgos_crm.sp_grab_log_aqpc156(codopinion,
                                                       instancia);
    END;
  
    begin
      UPDATE AQPC818
         SET AQPC818ESTOP = flgEstado
       WHERE AQPC818CODOPI = codopinion
         AND AQPC818INSTAN = instancia
         AND AQPC818ESTAD = 'H'; --2108
      COMMIT;
    end;
  end;

  procedure sp_cargar_c162(codopin number) is
    -- *****************************************************************
    -- Nombre                     : sp_cargar_c162
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Cargar tabla
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************      
  BEGIN
    BEGIN
      --11072023 
      UPDATE AQPC822
         SET AQPC822ESTAD = 'I'
       WHERE AQPC822CODOPI = codopin
         AND (AQPC822ESTAD = 'H' OR AQPC822ESTAD IS NULL);
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
    -- *****************************************************************
    -- Nombre                     : sp_insert_garnt_aqpc162
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Inserta las garantias
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                     
    auxCorr      number(10);
    v_HoraActual VARCHAR2(8);
  begin
    /*BEGIN --11092023  comentado
      UPDATE AQPC822 
      SET AQPC822ESTAD = 'I'
      WHERE AQPC822CODOPI = codopin AND (AQPC822ESTAD = 'H' OR AQPC822ESTAD IS NULL );
      --DELETE FROM AQPC822 WHERE AQPC822CODOPI = codopin;
      COMMIT;
    exception
      when others then
        NULL;
    END;*/
  
    v_HoraActual := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  
    begin
      select max(AQPC822CORR)
        into auxCorr
        from AQPC822
       where AQPC822CODOPI = codopin;
    exception
      when others then
        auxCorr := 0;
    end;
  
    IF auxCorr IS NULL THEN
      auxCorr := 0;
    END IF;
  
    auxCorr := auxCorr + 1;
  
    BEGIN
      INSERT INTO AQPC822
        (AQPC822CODOPI,
         AQPC822CORR,
         AQPC822FECPRO,
         AQPC822TIPGAR,
         AQPC822DESGAR,
         AQPC822PROP,
         AQPC822FTASA,
         AQPC822TASD,
         AQPC822VGCOM,
         AQPC822VREAGAR,
         AQPC822VGRAV,
         AQPC822VGOBERT,
         AQPC822MODU,
         AQPC822TOPE,
         AQPC822TIPBIDE,
         AQPC822FECDECL,
         AQPC822VALGARN,
         AQPC822HORAREG,
         AQPC822ESTAD) --2108
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
    -- *****************************************************************
    -- Nombre                     : sp_cargar_c161
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Carga tabla
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  BEGIN
    BEGIN
      DELETE FROM AQPC821 WHERE AQPC821CODOPI = codopin; --AND AQPC821ESTAD = 'H'; --07112023
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
    -- *****************************************************************
    -- Nombre                     : sp_insert_relacFinan_aqpc161
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Inserta las relaciones financieras
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                         
    auxCorr      number(10);
    v_HoraActual VARCHAR2(8);
  begin
    v_HoraActual := TO_CHAR(SYSDATE, 'HH24:MI:SS'); --0308
  
    BEGIN
      select max(AQPC821corr)
        into auxCorr
        from AQPC821
       where AQPC821CODOPI = codopin; -- AND AQPC821ESTAD = 'H'; --07112023
    EXCEPTION
      WHEN OTHERS THEN
        auxCorr := 0;
    END;
  
    IF auxCorr IS NULL THEN
      auxCorr := 0;
    END IF;
  
    auxCorr := auxCorr + 1;
  
    BEGIN
      INSERT INTO AQPC821
        (AQPC821CODOPI,
         AQPC821corr,
         AQPC821FECPRO,
         AQPC821ENTFIN,
         -- AQPC821MONTRLF,
         -- AQPC821PLZORLF,
         AQPC821CUOTRLF,
         AQPC821SDORLF,
         --AQPC821CUOCAN,
         --AQPC821TEARLF,
         AQPC821CLASFRLF,
         AQPC821HORAREG) --07112023
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
    -- *****************************************************************
    -- Nombre                     : sp_valid_Segm_NoMinorista
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Valida el Segmento No minorista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                       
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
    -- *****************************************************************
    -- Nombre                     : sp_grabarLogEstadoOpinion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Graba el estado de opinion
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                      
    xDescEtapa1 varchar2(50);
    xNomUsuario varchar2(50);
    xCorrelat   number(4);
  begin
    
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
      SELECT max(aqpc801AUX1)
        INTO xCorrelat
        FROM aqpc801
       WHERE aqpc801CODOPI = codOpinion;
    EXCEPTION
      WHEN OTHERS THEN
        xCorrelat := 0;
    END;
  
    IF xCorrelat IS NULL THEN
      xCorrelat := 0;
    END IF;
  
    xCorrelat := xCorrelat + 1; -- FIN MOD RCASTRO 10072023
  
    BEGIN
      INSERT INTO aqpc801
        (aqpc801CORR,
         aqpc801CODOPI,
         aqpc801FECH,
         aqpc801HOR,
         aqpc801CODETA,
         aqpc801ETAPA,
         aqpc801ESTDA,
         aqpc801USREJ,
         aqpc801NIVL,
         aqpc801AUX2,
         aqpc801AUX1) -- INI MOD RCASTRO 10072023
      VALUES
        (0,
         codOpinion,
         fechaActual,
         Hora,
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
  end sp_grabarLogEstadoOpinion;

  procedure sp_cambiarEstadoAqpc156(Instancia      number,
                                    codopinion     number,
                                    flgCambiEstado varchar2,
                                    codNivel       number,
                                    NuevoAsunto    varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cambiarEstadoAqpc156
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Cambia el estado en la cabecera
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                    
  begin
    BEGIN
      --2108
      pq_cr_repo_opini_riesgos_crm.sp_grab_log_aqpc156(codOpinion,
                                                       instancia);
    END;
  
    IF flgCambiEstado = 'E' THEN
      --proc. enviar
      BEGIN
        update AQPC818
           SET AQPC818NIVEL = codNivel
         WHERE AQPC818CODOPI = codopinion
           AND AQPC818ESTAD = 'H'; --2108
        COMMIT;
      END;
    ELSE
      IF flgCambiEstado IS NULL OR flgCambiEstado = ' ' THEN
        --1906 Para devolver en etapa superiores supervisor, jefe y gerente
        begin
          update AQPC818
             set --AQPC156ESTOP = flgCambiEstado,
                 AQPC818NIVEL = codNivel
          --AQPC156ASUNT = NuevoAsunto
           WHERE AQPC818CODOPI = codopinion
             AND AQPC818ESTAD = 'H'; --2108
          commit;
        end;
      ELSE
        begin
          update AQPC818
             set AQPC818ESTOP = flgCambiEstado, -- 'O' ESTADO DE OBSERVADO
                 AQPC818NIVEL = codNivel,
                 AQPC818ASUNT = NuevoAsunto
           WHERE AQPC818CODOPI = codopinion
             AND AQPC818ESTAD = 'H'; --2108
          commit;
        end;
      END IF;
    END IF;
  end;

  procedure sp_validar_Etapa_Opin(Instancia  number,
                                  codopinion number,
                                  codNIVEL   out number,
                                  DescEtapa  out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_validar_Etapa_Opin
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Valida la Etapa de Opinion
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                     
  BEGIN
    BEGIN
      SELECT A.aqpc801ETAPA, A.aqpc801NIVL
        INTO DescEtapa, codNIVEL
        FROM aqpc801 A
       WHERE A.aqpc801CORR =
             (SELECT MAX(B.aqpc801CORR)
                FROM aqpc801 B
               WHERE B.aqpc801CODOPI = codopinion)
         AND A.aqpc801CODOPI = codopinion;
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
    -- *****************************************************************
    -- Nombre                     : sp_actualizarEstado156
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Actualiza el estado de la cabecera
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                     
  begin
    BEGIN
      --2108
      pq_cr_repo_opini_riesgos_crm.sp_grab_log_aqpc156(codOpinion,
                                                       intancia);
    END;
  
    begin
      UPDATE AQPC818
         SET AQPC818ESTOP = FlgEstado
       WHERE AQPC818CODOPI = codopinion
         AND AQPC818INSTAN = intancia
         AND AQPC818ESTAD = 'H'; --2108;
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
    -- *****************************************************************
    -- Nombre                     : sp_buscar_usuario_correo_GA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca el usuario de correo
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                         
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
      pq_cr_repo_opini_riesgos_crm.sp_grab_log_aqpc156(codOpinion,
                                                       solicitud);
    END;
    begin
      update AQPC818
         set AQPC818GRAGE = userGA
       where AQPC818CODOPI = codOpinion
         and AQPC818INSTAN = solicitud
         AND AQPC818ESTAD = 'H'; --2108
      commit;
    end;
  end;

  procedure sp_delegar_analis_senior(codOpinion    number,
                                     solicitud     number,
                                     cuenta        number,
                                     codAnalista   varchar2,
                                     NivelAprobOpi NUMBER,
                                     codNivelPerfiDeriv number) is
    auxFechaDeleg date;
    FLGest varchar2(1);
  begin
    BEGIN
      SELECT PGFAPE INTO auxFechaDeleg FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        auxFechaDeleg := to_date(sysdate);
    END;
  
    BEGIN
      --2108
      pq_cr_repo_opini_riesgos_crm.sp_grab_log_aqpc156(codOpinion,
                                                       solicitud);
    END;
  
    CASE
      WHEN NivelAprobOpi = 1 THEN   --18112024
        begin
          update AQPC818
             set AQPC818USRDER  = codAnalista,
                 AQPC818ANSERIG = codAnalista,
                 AQPC818FECDEL  = auxFechaDeleg,
                 AQPC818NIVEL   = codNivelPerfiDeriv
           where AQPC818CODOPI = codOpinion
             and AQPC818INSTAN = solicitud
             AND AQPC818ESTAD = 'H'; --21022024;
          commit;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
      end;         
      WHEN NivelAprobOpi IN (2,3) THEN
       FLGest := 'N';
       BEGIN --20022025
         
             pq_cr_repo_opinion_riesgos.sp_validar_estado_opin(2 , 
                                                               codOpinion, 
                                                               solicitud, 
                                                               FLGest);
       END;  
       IF FLGest = 'S' THEN         
          begin
            update AQPC818
               set AQPC818USRDER  = codAnalista,
                   AQPC818ANSERIG = codAnalista,
                   AQPC818FECDEL  = auxFechaDeleg,
                   AQPC818NIVEL   = codNivelPerfiDeriv
             where AQPC818CODOPI = codOpinion
               and AQPC818INSTAN = solicitud
               AND AQPC818ESTAD = 'H'; --2108;
            commit;
          end;        
        ELSE 
           begin
          update AQPC818
             set AQPC818USRDER  = codAnalista,
                 --AQPC818ANSERIG = codAnalista,
                 AQPC818FECDEL  = auxFechaDeleg,
                 AQPC818NIVEL   = codNivelPerfiDeriv
           where AQPC818CODOPI = codOpinion
             and AQPC818INSTAN = solicitud
             AND AQPC818ESTAD = 'H'; --2108;
          commit;
        end;
        
        END IF;
        
      WHEN NivelAprobOpi = 4 THEN
        BEGIN
          UPDATE AQPC818
             SET AQPC818USRDER  = codAnalista,
                 AQPC818SUPADMI = codAnalista,
                 AQPC818FECDEL  = auxFechaDeleg
           WHERE AQPC818CODOPI = codopinion
             AND AQPC818INSTAN = solicitud
             AND AQPC818ESTAD = 'H'; --21082023
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      WHEN NivelAprobOpi = 5 THEN
        BEGIN
          UPDATE AQPC818
             SET AQPC818USRDER  = codAnalista,
                 AQPC818JEFADMI = codAnalista,
                 AQPC818FECDEL  = auxFechaDeleg
           WHERE AQPC818CODOPI = codopinion
             AND AQPC818INSTAN = solicitud
             AND AQPC818ESTAD = 'H'; --21082023
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      WHEN NivelAprobOpi = 6 THEN
        BEGIN
          UPDATE AQPC818
             SET AQPC818USRDER  = codAnalista,
                 AQPC818GERRIES = codAnalista,
                 AQPC818FECDEL  = auxFechaDeleg
           WHERE AQPC818CODOPI = codopinion
             AND AQPC818INSTAN = solicitud
             AND AQPC818ESTAD = 'H'; --21082023
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      ELSE
        NULL;
    END CASE;
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
      SELECT AQPC818SLDPROP,
             AQPC818MODPRP,
             AQPC818CUOTAS,
             AQPC818CUOPRP,
             AQPC818TASPRP
        INTO saldo, montootorg, cuotas, ncuotas, tasa
        FROM AQPC818
       WHERE AQPC818CODOPI = CODOPINI
         AND AQPC818INSTAN = INSTANCIA
         AND AQPC818ESTAD = 'H';
    exception
      when others then
        saldo      := 0;
        montootorg := 0;
        cuotas     := 0;
        ncuotas    := 0;
        tasa       := 0;
    End;
  End;

  procedure sp_valid_aprob_anriesgo(codOpini number, flgEstd out varchar2) is --usado por pck anterior
  begin
    begin
      select 'S'
        INTO flgEstd
        from aqpc801
       where aqpc801CODOPI = codOpini
         and aqpc801NIVL >= 1 --3  18112024
         and rownum < 2;
    EXCEPTION
      WHEN OTHERS THEN
        flgEstd := 'N';
    end;
  end;

  procedure sp_val_etap_solicitud(instancia     number,
                                  xflagEstAprob OUT varchar2) is
    ---usado por pck anterior
    v_Pgcod  number(3); --newcrm
    v_Scmod  number(4);
    v_Scsuc  number(4);
    v_Scmda  number(4);
    v_Scpap  number(4);
    v_Sccta  number(9);
    v_Scoper number(9);
    v_Scsbop number(3);
    v_Sctope number(3);
    fecMax   date;
    fecSist  date;
  
  BEGIN
    --Excepción para casos con estdo C jaqa400
    BEGIN
      select 'S'
        INTO xflagEstAprob
        from fst198
       Where tp1cod = 1
         and tp1cod1 = 11152
         and tp1corr1 = 50
         and tp1corr2 = 2
         and tp1corr3 > 0
         and tp1imp1 = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        xflagEstAprob := 'N';
    END;
    xflagEstAprob := NVL(xflagEstAprob, 'N');
  
    IF xflagEstAprob = 'N' THEN
      ---
      BEGIN
        pq_cr_repo_opini_riesgos_crm.sp_obtener_Credito(instancia,
                                                        v_Pgcod,
                                                        v_Scmod,
                                                        v_Scsuc,
                                                        v_Scmda,
                                                        v_Scpap,
                                                        v_Sccta,
                                                        v_Scoper,
                                                        v_Scsbop,
                                                        v_Sctope);
      END;
    
      BEGIN
        SELECT PGFAPE INTO fecSist FROM FST017 WHERE PGCOD = V_PGCOD;
      EXCEPTION
        WHEN OTHERS THEN
          fecSist := TO_Date(sysdate);
      END;
    
      xflagEstAprob := 'N';
      BEGIN
        --se valida que esté en etapa de evaluación, ya que es donde sale la alerta.           
        SELECT 'S'
          INTO xflagEstAprob
          FROM JAQA400 a
         WHERE a.JAQA400EMP = v_Pgcod
           AND a.JAQA400MOD = v_Scmod
           AND a.JAQA400SUC = v_Scsuc
           AND a.JAQA400MDA = v_Scmda
           AND a.jaqa400pap = v_Scpap
           AND a.JAQA400CTA = v_Sccta
           AND a.JAQA400OPE = v_Scoper
           AND a.JAQA400SBO = v_Scsbop
           AND a.JAQA400TOP = v_Sctope
           AND a.JAQA400FEC = fecSist
           AND (a.JAQA400EST = 'E' OR a.JAQA400EST = 'A');
        /*select 'S'
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
          and b.WFITEMSTSACT = 1;*/
      
      EXCEPTION
        WHEN OTHERS THEN
          xflagEstAprob := 'N'; --2504 drop  
      END;
    END IF;
  END;

  procedure sp_actuali_responsTotal(instancia     number,
                                    xcodOpinion   number,
                                    montoConsolid number,
                                    fechaHoy      date,
                                    sucurCred     number) is
    --para eliminar
    UsuarioGA  varchar2(10);
    xEmail     varchar2(100);
    xCodCargo  number(4);
    UsuarioASE varchar2(10);
  BEGIN
    --actualizar ACreditos y GA
    BEGIN
      pq_cr_repo_opini_riesgos_crm.sp_obtenr_usu_AC_GA(instancia,
                                                       sucurCred,
                                                       UsuarioGA,
                                                       UsuarioASE);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      UPDATE AQPC818
         SET AQPC818RESPTOT = montoConsolid,
             AQPC818AUX3    = fechaHoy, -- AQPC818FECPRO  = fechaHoy,  27072023 
             AQPC818USUREG  = UsuarioASE,
             AQPC818GRAGE   = UsuarioGA
       WHERE AQPC818CODOPI = xcodOpinion
         AND AQPC818INSTAN = instancia
         AND AQPC818ESTAD = 'H'; --2108;
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
    auxPais   number(3);
    auxPetdoc number(3);
    auxPendoc varchar2(12);
    auxInstnc number(10);
    cuenta    number(9);
    auxTmod   number(4);
    xcodOpini number(10);
    FECHAACT DATE;
    flgExisteM400 VARCHAR2(1);
    fechaAnteM400 datE;
  
    Indicflujo         VARCHAR2(3);
    fechAntOut         DATE;
    TipFlujCN          VARCHAR2(1);
      
  BEGIN
    --vig reciente  
    BEGIN
      SELECT MAX(AQPC818CODOPI)
        INTO xcodOpini
        FROM AQPC818
       WHERE AQPC818INSTAN = instancia
         AND AQPC818ESTAD = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        xcodOpini := 0;
    END;
  
    --01042024
    BEGIN
      SELECT PGFAPE INTO FECHAACT FROM FST017 WHERE PGCOD = 1; 
    EXCEPTION
      WHEN OTHERS THEN
        NULL;      
    END;
    
    BEGIN
      SELECT 'S' into flgExisteM400 FROM JAQM400 W WHERE W.JAQM400INS = instancia AND W.JAQM400FEC = FECHAACT AND ROWNUM = 1 ;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;      
    END;
    flgExisteM400 := nvl(flgExisteM400, 'N');     
   
    IF flgExisteM400 = 'N' THEN
      BEGIN
        SELECT e.jaqz516TMOD, e.jaqz516pdoc, e.jaqz516tdoc, e.jaqz516ndoc --newcrm
          INTO auxTmod, auxPais, auxPetdoc, auxPendoc
          FROM jaqz516 e
         WHERE e.jaqz516SOL = instancia 
         and e.JAQZ516FEC = FECHAACT;
      EXCEPTION
        WHEN OTHERS THEN
          auxPais   := 0;
          auxPetdoc := 0;
          auxPendoc := 0;
          auxTmod   := 0;
      END;
    ELSE 
       auxTmod := 14;
    END IF;--
  
    IF auxTmod = 13 THEN
      -- CRED vigentes
      BEGIN
        SELECT SUM(JAQY142CAPCUO)
          INTO xSumcuotaVigRec
          FROM JAQY142B j --new crm
         WHERE j.JAQY142INST = instancia
           AND j.JAQY142EST = 'H'
           AND j.JAQY142INDIC IN ('CredVigent', 'CredVencid', 'LineaVencd')
           AND (j.jaqy142mod not in
               (select tp1nro1
                   from fst198 a
                  where a.tp1cod = 1
                    and a.tp1cod1 = 10899
                    and a.tp1corr1 = 13
                    and a.tp1corr2 = 1) and j.jaqy142mod not in 117) --mpostigoc 30.10.2023
           and j.jaqy142nrcuo > 1;
        --AND J.JAQY142TAREA = 7; --13/09/2023
      EXCEPTION
        WHEN OTHERS THEN
          xSumcuotaVigRec := 0;
      END;
      -- contingente Y -- potencial
      BEGIN
        SELECT JAQY140CCONTG, JAQY140CPOTEN
          INTO xCredicContingAct, xCredPotencAct
          FROM JAQY140B --newcrm
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
            FROM JAQZ822B j --newcrm
           WHERE j.JAQZ822INST = instancia
             AND j.JAQZ822EST = 'H'
             AND j.JAQZ822INDIC IN
                 ('CredVigent', 'CredVencid', 'LineaVencd')
             and (j.jaqz822mod not in
                 (select tp1nro1
                     from fst198 a
                    where a.tp1cod = 1
                      and a.tp1cod1 = 10899
                      and a.tp1corr1 = 200
                      and a.tp1corr2 = 1
                      and a.tp1corr3 > 0) and j.jaqz822mod not in 117) --mpostigoc 051118 
             and j.jaqz822nrcuo > 1;
          --AND JAQZ822TAREA = 7;
        EXCEPTION
          WHEN OTHERS THEN
            xSumcuotaVigRec := 0;
        END;
        -- contingente Y -- potencial
        BEGIN
          SELECT JAQZ821CCONTG, JAQZ821CPOTEN
            INTO xCredicContingAct, xCredPotencAct
            FROM JAQZ821B --newcrm
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
  
    IF xSumcuotaVigRec is null then
      xSumcuotaVigRec := 0;
    end IF;
  
  
    /*BEGIN now
      SELECT max(jaqz516SOL)
        INTO auxInstnc
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
        auxInstnc := 0;
    END;*/
    auxInstnc := 0;
    BEGIN
      /*pq_cr_repo_opini_riesgos_crm.sp_obtner_Instanci_anterior(instancia => instancia,
                                                               auxInstnc => auxInstnc,
                                                               fechaAnteM400 => fechaAnteM400);*/
      Indicflujo := 'CRM';
      TipFlujCN := 'C';
      pq_cr_repo_opinion_riesgos.sp_obtner_Instanci_anterior(instancia => instancia,  --30042024 FALTA
                                                             Indicflujo => Indicflujo,          
                                                             auxInstnc => auxInstnc,
                                                             fechAntOut => fechAntOut,
                                                             TipFlujCN => TipFlujCN); 
      fechaAnteM400 :=  fechAntOut;                                                                                                                          
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;-----    
      
    auxInstnc := nvl(auxInstnc, 0);
  
    IF auxInstnc > 0 THEN
       IF TipFlujCN = 'N' THEN
         BEGIN
          pq_cr_repo_opinion_riesgos.sp_obtn_cuot_cred_vigen_Anter( auxInstnc,  --30042024
                                                                    auxTmod           ,
                                                                    xSumcuotaVigAnter , 
                                                                    xCredicContingAnt ,                                      
                                                                    xCredPotencAnt    );  
        EXCEPTION
          WHEN OTHERS THEN
           NULL;
        END;                                                                        
         
       END IF;  
             
       IF TipFlujCN = 'C' THEN
          BEGIN
          pq_cr_repo_opini_riesgos_CRM.sp_obtn_cuot_cred_vigen_Anter(auxInstnc         ,  --30042024
                                                                     auxTmod           ,                                                                    
                                                                     xSumcuotaVigAnter , 
                                                                     xCredicContingAnt ,                                      
                                                                     xCredPotencAnt); 
          EXCEPTION
          WHEN OTHERS THEN
           NULL;
         END;                                                                     
       END IF;  
                                              
    END IF;
  
  END;
  
  procedure sp_obtn_cuot_cred_vigen_Anter(auxInstnc         number,  --30042024
                                          auxTmod           number,
                                          xSumcuotaVigAnter OUT number, 
                                          xCredicContingAnt out number, --                                     
                                          xCredPotencAnt    OUT number) is
 BEGIN
      IF auxTmod = 13 THEN
        -- VIGENTE
        BEGIN
          SELECT SUM(JAQY142CAPCUO)
            INTO xSumcuotaVigAnter
            FROM JAQY142B j --newcrm
           WHERE j.JAQY142INST = auxInstnc
             AND j.JAQY142EST = 'H'
             AND j.JAQY142INDIC IN
                 ('CredVigent', 'CredVencid', 'LineaVencd')
             and (j.jaqy142mod not in
                 (select tp1nro1
                     from fst198 a
                    where a.tp1cod = 1
                      and a.tp1cod1 = 10899
                      and a.tp1corr1 = 13
                      and a.tp1corr2 = 1) and j.jaqy142mod not in 117) --mpostigoc 30.10.2023
             and j.jaqy142nrcuo > 1;
          --AND JAQY142TAREA = 55; 
        EXCEPTION
          WHEN OTHERS THEN
            xSumcuotaVigAnter := 0;
        END;
        -- contingente Y -- potencial
        BEGIN
          SELECT JAQY140CCONTG, JAQY140CPOTEN
            INTO xCredicContingAnt, xCredPotencAnt
            FROM JAQY140B --newcrm
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
              FROM JAQZ822B j --newcrm
             WHERE j.JAQZ822INST = auxInstnc
               AND j.JAQZ822EST = 'H'
               AND j.JAQZ822INDIC IN
                   ('CredVigent', 'CredVencid', 'LineaVencd')
               and (j.jaqz822mod not in
                   (select tp1nro1
                       from fst198 a
                      where a.tp1cod = 1
                        and a.tp1cod1 = 10899
                        and a.tp1corr1 = 200
                        and a.tp1corr2 = 1
                        and a.tp1corr3 > 0) and j.jaqz822mod not in 117) --mpostigoc 051118 
               and j.jaqz822nrcuo > 1;
            --AND JAQZ822TAREA = 55; --13092023
          EXCEPTION
            WHEN OTHERS THEN
              xSumcuotaVigAnter := 0;
          END;
          -- contingente Y -- potencial
          BEGIN
            SELECT JAQZ821CCONTG, JAQZ821CPOTEN
              INTO xCredicContingAnt, xCredPotencAnt
              FROM JAQZ821B --newcrm
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
        FROM aqpb357
       WHERE aqpb357INST = auxInst
         AND aqpb357ESTA = 'S';
  
    contador        number(10) := 1;
    descMoned       varchar2(10);
    instancAnterior number(10) := 0;
    flgInser        varchar2(1) := 0;
    auxMntGFinanc   number(17, 2) := 0;
    v_FechaActual   date;
    v_HoraActual    varchar2(8);
    tipoCambio      number(14, 8);
    Fechaf017       date;
    fechaAnteM400 date;
    fechAntOut date;
  	TipFlujCN  varchar2(1); 
    Indicflujo varchar2(3);     
    
  BEGIN
    BEGIN
      DELETE FROM AQPC829 WHERE AQPC829CODOPI = codOpinion;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    v_FechaActual := TO_DATE(SYSDATE, 'dd/mm/rrrr');
    v_HoraActual  := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  
    FOR i in deta_entidad(instancia) LOOP
    
      auxMntGFinanc := i.aqpb357GFIN; --03082023
      descMoned     := 'S/.';
    
      IF TRIM(i.aqpb357tcre) IN
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
      
        auxMntGFinanc := auxMntGFinanc * TIPOCAMBIO; --fn_tipo_cambio_fijo(i.aqpb357FECH); -- 03082023    
      END IF;
    
      flgInser := 'N';
      BEGIN
        SELECT 'S'
          INTO flgInser
          FROM AQPC829
         WHERE AQPC829CODOPI = codOpinion
           AND TRIM(UPPER(AQPC829DESENT)) = TRIM(UPPER(i.aqpb357enti))
           AND TRIM(UPPER(AQPC829TCRE)) = TRIM(UPPER(i.aqpb357TCRE)); --03082023
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
             AQPC829FECHREG, --03082023
             AQPC829HORAREG,
             AQPC829TCRE) --03082023
          VALUES
            (codOpinion,
             TRIM(i.aqpb357CENT),
             contador,
             TRIM(i.aqpb357enti),
             0, --i.aqpb357MDA,
             descMoned,
             auxMntGFinanc,
             0,
             v_FechaActual, --03082023
             v_HoraActual,
             i.aqpb357tcre);
          COMMIT;
          contador := contador + 1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      ELSE
        IF flgInser = 'S' THEN
          BEGIN
            UPDATE AQPC829
               SET AQPC829EVAREC = AQPC829EVAREC + auxMntGFinanc --03082023
             WHERE AQPC829CODOPI = codOpinion
               AND TRIM(UPPER(AQPC829DESENT)) = TRIM(UPPER(i.aqpb357enti))
               AND TRIM(UPPER(AQPC829TCRE)) = TRIM(UPPER(i.aqpb357TCRE)); --03082023
            --AND TRIM(UPPER(AQPC829CODENT)) = TRIM(UPPER(i.aqpb357CENT)); --03082023;
            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
      END IF;
    
    END LOOP;
    
    /*pq_cr_repo_opini_riesgos_crm.sp_obtner_Instanci_anterior(instancia,
                                                             instancAnterior,
                                                             fechaAnteM400);*/                                                             
    Indicflujo := 'CRM';
    TipFlujCN := 'C';
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
    IF TipFlujCN = 'C' THEN
       BEGIN
       pq_cr_repo_opini_riesgos_CRM.sp_carg_ent_gst_fin_anter(codOpinion ,   --30042024
                                                              Indicflujo,                
                                                              instancAnterior);
        EXCEPTION
          WHEN OTHERS THEN
           NULL;
        END;                                                                   
    ELSE 
       IF TipFlujCN = 'N' THEN 
          BEGIN       
          pq_cr_repo_opinion_riesgos.sp_carg_ent_gst_fin_anter(codOpinion ,   --30042024
                                                               Indicflujo,                
                                                               instancAnterior);
          EXCEPTION
            WHEN OTHERS THEN
             NULL;
          END;                                                                
       END IF;                                                   
    END IF;                                                                 
  
   
  END;
  
  procedure sp_carg_ent_gst_fin_anter(codOpinion number,  --30042024
                                      flujo      varchar2,                                                                    
                                      instanciaAnt  number) IS
                                      
   CURSOR deta_entidad(auxInst number) IS
      SELECT *
        FROM aqpb357
       WHERE aqpb357INST = auxInst
         AND aqpb357ESTA = 'S';
  
  contador        number(10) := 1;
  descMoned       varchar2(10);
  --instancAnterior number(10) := 0;
  flgInser        varchar2(1) := 0;
  auxMntGFinanc   number(17, 2) := 0;
  v_FechaActual   date;
  v_HoraActual    varchar2(8);
  tipoCambio      number(14, 8);
  Fechaf017       date;
  fechaAnteM400 date;
                                          
  BEGIN
     BEGIN
          SELECT MAX(AQPC829CORREL)
            INTO contador
            FROM AQPC829
           WHERE AQPC829CODOPI = codOpinion;
        EXCEPTION
          WHEN OTHERS THEN
            contador := 0;
        END;
      
        IF contador IS NULL THEN
          contador := 0;
        END IF;
      
        contador := contador + 1;
      
        ---Eval Anterior
        IF instanciaAnt > 0 THEN
          FOR i in deta_entidad(instanciaAnt) LOOP
          
            auxMntGFinanc := 0;   
            descMoned     := 'S/.';
            auxMntGFinanc := i.aqpb357GFIN;   
          
            IF TRIM(i.aqpb357tcre) IN
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
                  SELECT E.PGFAPE
                    INTO Fechaf017
                    FROM FST017 E
                   WHERE E.PGCOD = 1;
                EXCEPTION
                  WHEN OTHERS THEN
                    Fechaf017 := TO_DATE(SYSDATE, 'dd/mm/rrrr');
                END;
                TIPOCAMBIO := fn_tipo_cambio_fijo(Fechaf017);
              END IF;
            
              auxMntGFinanc := auxMntGFinanc * TIPOCAMBIO; --fn_tipo_cambio_fijo(i.aqpb357FECH); -- 03082023    
            END IF;
            
            IF flujo = 'CRM' THEN --30042024 
                flgInser := 'N';
                BEGIN
                  SELECT 'S'
                    INTO flgInser
                    FROM AQPC829
                   WHERE AQPC829CODOPI = codOpinion
                     AND TRIM(UPPER(AQPC829DESENT)) = TRIM(UPPER(i.aqpb357enti))
                     AND TRIM(UPPER(AQPC829TCRE)) = TRIM(UPPER(i.aqpb357TCRE)); --03082023            
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
                       AQPC829FECHREG, --03082023
                       AQPC829HORAREG,
                       AQPC829TCRE) --03082023                              
                    VALUES
                      (codOpinion,
                       TRIM(i.aqpb357CENT),
                       contador,
                       TRIM(i.aqpb357enti),
                       0, --i.aqpb357MDA,
                       descMoned,
                       0,
                       auxMntGFinanc,
                       v_FechaActual, --03082023
                       v_HoraActual,
                       i.aqpb357tcre);
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
                         AND TRIM(UPPER(AQPC829DESENT)) = TRIM(UPPER(i.aqpb357enti))
                         AND TRIM(UPPER(AQPC829TCRE)) = TRIM(UPPER(i.aqpb357TCRE));
                      commit;
                    EXCEPTION
                      WHEN OTHERS THEN
                        NULL;
                    END;
                  END IF;
                END IF;
            ELSE --SI LO LLAMAN DE FLUJO NORMAL
                IF flujo = 'NOR' THEN --30042024                   
                    flgInser := 'N';
                    BEGIN
                      SELECT 'S'
                        INTO flgInser
                        FROM AQPC812
                       WHERE AQPC812CODOPI = codOpinion
                         AND TRIM(UPPER(AQPC812DESENT)) = TRIM(UPPER(i.aqpb357enti))
                         AND TRIM(UPPER(AQPC812TCRE)) = TRIM(UPPER(i.aqpb357TCRE));                                    
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
                               TRIM(i.Aqpb357cent), -- i.JAQZ862CENT),
                               contador,
                               TRIM(i.aqpb357enti), -- jaqz862enti),
                               0, 
                               descMoned,
                               0,
                               auxMntGFinanc,
                               v_FechaActual, 
                               v_HoraActual,
                               i.aqpb357tcre); -- jaqz862tcre);
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
                                 AND TRIM(UPPER(AQPC812DESENT)) =   TRIM(UPPER(i.aqpb357enti)) -- i.jaqz862enti))
                                 AND TRIM(UPPER(AQPC812TCRE)) = TRIM(UPPER(i.aqpb357tcre)); -- i.JAQZ862TCRE));                              
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
        END IF;    
  END;                                      

  Procedure sp_obtner_Instanci_anterior(instancia number,
                                        auxInstnc out number,
                                        fechaAnteM400 out date) is --01042024
    auxPais   number(3);
    auxPetdoc number(3);
    auxPendoc varchar2(12);
    cuenta    number(9);
    auxTmod   number(4);
    ln_cuenta number(9);
    FECHAACT  DATE;
    --fechaAnteM400 DATE;
    flgExisteM400 varchar2(1);
  BEGIN
    /*BEGIN
      --newcrm
      select w.xwfcuenta
        into ln_cuenta
        from xwf700 w
       where --crm
       w.xwfprcins = instancia
       and w.xwfcar3 = '1';
    END;*/
    
    BEGIN
      select w.SNG001CTA
        into ln_cuenta
        from sng001 w
       where --crm
       w.SNG001INST = instancia and rownum = 1;
    EXCEPTION 
      WHEN OTHERS THEN
        NULL;
    END;    
  
    BEGIN
      SELECT Pepais, Petdoc, Pendoc
        INTO auxPais, auxPetdoc, auxPendoc
        FROM FSR008
       WHERE CTNRO = ln_cuenta
         and Cttfir = 'T';
      /*SELECT SNG001PAIS, SNG001TDOC, SNG001NDOC
       INTO auxPais, auxPetdoc, auxPendoc
       FROM SNG001
      WHERE SNG001INST = instancia;*/
    EXCEPTION
      WHEN OTHERS THEN
        auxPais   := 0;
        auxPetdoc := 0;
        auxPendoc := '';
    END;
    auxPendoc := rpad(auxPendoc, 12, ' ');
    
    --01042024
    BEGIN
      SELECT PGFAPE INTO FECHAACT FROM FST017 WHERE PGCOD = 1; 
    EXCEPTION
      WHEN OTHERS THEN
        NULL;      
    END;
    
    BEGIN
      SELECT 'S' into flgExisteM400 FROM JAQM400 W WHERE W.JAQM400INS = instancia AND W.JAQM400FEC = FECHAACT AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;      
    END;
    flgExisteM400 := nvl(flgExisteM400, 'N');
    
    IF flgExisteM400 = 'S' THEN
        /*BEGIN
          SELECT MAX(W.JAQM400INS), MAX(W.JAQM400FEC) INTO
                 auxInstnc, fechaAnteM400
          FROM JAQM400 W WHERE W.JAQM400INS = instancia AND W.JAQM400FEC < FECHAACT ;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;      
        END;*/
        BEGIN
          select distinct b.jaqm400ins, max(b.jaqm400fec) INTO auxInstnc, fechaAnteM400
          from jaqa400 a, jaqm400 b 
         where a.jaqa400ai1 in
               (select s.sng001inst
                  from sng001 s
                 where s.sng001pais = auxPais
                   and s.sng001tdoc = auxPetdoc
                   and RPAD(s.sng001ndoc, 12, ' ') = auxPendoc)
           and a.jaqa400est = 'C'
           and a.jaqa400ai1 = b.jaqm400ins
           and a.jaqa400fec = b.jaqm400fec
           group by b.jaqm400ins;
        EXCEPTION 
          WHEN OTHERS THEN
            NULL;
        END;
        
    END IF;
    
    auxInstnc := NVL(auxInstnc, 0);
    
    IF auxInstnc = 0 AND flgExisteM400 = 'N' THEN
        ---    
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
      
        BEGIN
          SELECT max(jaqz516SOL)
            INTO auxInstnc
            FROM jaqz516 g021, xwf070 f
           where jaqz516PDOC = auxPais
             and jaqz516TDOC = auxPetdoc
             and rpad(jaqz516NDOC, 12, ' ') = auxPendoc
             and jaqz516TMOD = auxTmod
             and jaqz516SOL < instancia
             and g021.jaqz516sol = f.xwfprcin
             and f.xwfcont = 'S'
           group by jaqz516TMOD;
        EXCEPTION
          WHEN OTHERS THEN
            auxInstnc := 0;
        END;
        
        auxInstnc := NVL(auxInstnc, 0);
        
        --30042024
        IF auxInstnc > 0 THEN
            BEGIN
              SELECT JAQZ516FEC
                INTO fechaAnteM400
                FROM jaqz516 g021, xwf070 f
               where jaqz516PDOC = auxPais
                 and jaqz516TDOC = auxPetdoc
                 and rpad(jaqz516NDOC, 12, ' ') = auxPendoc
                 and jaqz516TMOD = auxTmod
                 and jaqz516SOL = auxInstnc
                 and g021.jaqz516sol = f.xwfprcin
                 and f.xwfcont = 'S' 
                 and rownum = 1;              
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;  
        END IF;                    
        --fechaAnteM400 := NULL; --01042024
     END IF;    
  
  END;

  procedure sp_desc_tipo_solicitud(instancia number,
                                   CodTipoSolicitud out number,
                                   DescTipoSolicitud OUT varchar2) is
  begin
    CodTipoSolicitud := 13; -- se indica que solo es Reprog CRM.  
  
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
        DescTipoSolicitud := 'REPROGRAMACIÓN CRM'; -- 22122023
      WHEN CodTipoSolicitud = 14 THEN
        DescTipoSolicitud := 'REPROGRAMACIÓN DESASTRE NATURAL';
      WHEN CodTipoSolicitud = 15 THEN
        DescTipoSolicitud := 'AMPLIACIÓN ESPECIAL';
      WHEN CodTipoSolicitud = 16 THEN
        DescTipoSolicitud := 'REPROGRAMACIÓN CAMPAÑA';
      ELSE
        DescTipoSolicitud := 'REPROGRAMACIÓN CRM'; -- 22122023
    End Case;
    
    BEGIN
      --xDescTipoSolic := 'Reprogramación CRM'; --27/09/2024
        pq_cr_repo_opini_riesgos_CRM.sp_tipoReprogr_CRM(instancia, DescTipoSolicitud);
    EXCEPTION
        when OTHERS THEN
         DescTipoSolicitud := 'Reprogramación CRM';        
    END;
    
    
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
  
    BEGIN
      SELECT Penom
        into nombreClient
        FROM FSD001
       WHERE Pepais = xPepais
         AND Petdoc = xPetdoc
         AND rpad(Pendoc, 12, ' ') = rpad(xPendoc, 12, ' ')
         and rownum < 2;
    EXCEPTION
      WHEN OTHERS THEN
        nombreClient := '';
    END;
  END;

  procedure sp_validar_modelo_Evaluacion(instancia     number,
                                         usuario       varchar2,               
                                         flgModelEval  out varchar2,
                                         txtTipoEvalu  out varchar2,
                                         flgEsEvalFluj out varchar2,
                                         MsgRpta       out varchar2) is
    --30062023
    ModelEval    number(4);
    ln_evalflujo varchar2(1);
    val_tp1nro2  number(4);
    Fech_act    DATE;
    flgExisM400  VARCHAR2(1);
  BEGIN
    ---01042024    
    BEGIN
       SELECT PGFAPE INTO Fech_act FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;      
    END;
    
    BEGIN
       SELECT 'S' INTO flgExisM400 FROM JAQM400 WHERE JAQM400INS = instancia AND JAQM400FEC = Fech_act and rownum = 1; --01042024
    EXCEPTION
      WHEN OTHERS THEN
        NULL;  
    END; 
    flgExisM400 := NVL(flgExisM400, 'N');   
    ----
    
    IF flgExisM400 = 'N' THEN --01042024
        BEGIN
          SELECT jaqz516TMod
            INTO ModelEval
            FROM jaqz516 A, jaqz517 b 
           WHERE a.jaqz516Sol = instancia 
             and a.JAQZ516EVAL = b.JAQZ517EVAL              
             and a.JAQZ516FEC = Fech_act
             and rownum = 1;
        EXCEPTION
          WHEN OTHERS THEN
            ModelEval := 0;
        END;                
        
        ModelEval := nvl(ModelEval, 0); --01042024                   
    ELSE 
       ModelEval := 14; --es consumo jaqm400  01042024 
    END IF;    
  
    val_tp1nro2 := 0;
  
    IF ModelEval = 14 THEN
      flgModelEval := 'C';
    
      flgEsEvalFluj := '';                                                                   
    ELSIF ModelEval = 13 THEN
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
    ELSE --En caso no existe mostrar alerta no hay evaluacion
        MsgRpta := 'No se cargo la evaluación para la instancia ' || to_char(instancia);
    END IF;
    
    IF ModelEval > 0 THEN --01042024
       BEGIN
           pq_cr_repo_opini_riesgos_crm.sp_validar_existe_ratio(instancia => instancia,
                                                           tipo => trim(flgModelEval),
                                                           fecha => Fech_act, 
                                                           usuario => usuario);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;   
    END IF;
  
    --Descripción de tipo de evaluación  30062023   
    txtTipoEvalu := '';
    IF ModelEval > 0 THEN
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
     END IF;
  END;
  
  -------------------01042024 0704
  procedure sp_validar_existe_ratio(instancia number, tipo varchar2, fecha date, usuario varchar2) is
  nreg number(9);
  ln_ratiopyme number(12,6);
  ln_ratioconsm number(12,6);
  BEGIN
    IF tipo = 'P' THEN
     --para pyme
     BEGIN
         select count(1) into nreg
        from jaqy140B j
         where j.jaqy140inst = Instancia 
         and j.jaqy140fec = fecha
         and j.JAQY140EST = 'H';
     EXCEPTION
       WHEN OTHERS THEN
         NULL;           
     END;        
    ELSE 
       IF tipo = 'C' THEN
         --para consumo
         BEGIN
            SELECT COUNT(1) into nreg FROM JAQZ821B j         
           where j.JAQZ821INST = Instancia
             and j.JAQZ821FEC = fecha
             and j.JAQZ821EST = 'H'; 
         EXCEPTION
           WHEN OTHERS THEN
             NULL;        
         END;
       END IF;              
    END IF;  
    
    nreg := nvl(nreg, 0);
     
    IF nreg <= 0 THEN
        begin
          -- Call the procedure
          PQ_CR_RATIOS_REPROCAP.sp_cr_inicio(ln_instancia => instancia,
                                             ld_fecha => fecha,
                                             lc_usuario => usuario,
                                             ln_ratiopyme => ln_ratiopyme,
                                             ln_ratioconsm => ln_ratioconsm);
        Exception
          when others then
            null;                                             
        end;    
    END IF; 
  END;  
  
  -------------------

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
    fechaAnteM400 date;
    fechAntOut date;
  	TipFlujCN  varchar2(1); 
    Indicflujo varchar2(3);      
  Begin
    -- 2108
    BEGIN
      SELECT MAX(AQPC828CORR)
        INTO v_correlativo
        FROM AQPC828
       WHERE AQPC828CODOPI = p_AQPC811CODOPI;
    EXCEPTION
      WHEN OTHERS THEN
        v_correlativo := 0;
    END;
    IF v_correlativo IS NULL THEN
      v_correlativo := 0;
    END IF;
  
    v_correlativo := v_correlativo + 1;
  
    BEGIN
      UPDATE AQPC828
         SET AQPC828ESTAD = 'I'
       WHERE AQPC828CODOPI = p_AQPC811CODOPI
         AND (AQPC828ESTAD = 'H' OR AQPC828ESTAD IS NULL);
      --DELETE FROM AQPC828 where AQPC828CODOPI = p_AQPC828CODOPI;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    v_FechaActual := TO_DATE(SYSDATE, 'dd/mm/rrrr');
    v_HoraActual  := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  
    --instancia anterior
    BEGIN
      SELECT AQPC818INSTAN
        INTO instancia
        FROM AQPC818
       WHERE AQPC818CODOPI = p_AQPC811CODOPI
         AND AQPC818ESTAD = 'H'; -- AND AQPC156INSTAN = auxAQPC156INSTAN;
    EXCEPTION
      WHEN OTHERS THEN
        instancia := 0;
    END;
  
    auxInstnc := 0;
    /*BEGIN
      pq_cr_repo_opini_riesgos_crm.sp_obtner_Instanci_anterior(instancia => instancia,
                                                               auxInstnc => auxInstnc,
                                                               fechaAnteM400 => fechaAnteM400);
    EXCEPTION
      WHEN OTHERS THEN
        auxInstnc := 0;
    END; */
    Indicflujo := 'CRM';
    TipFlujCN := 'C';
    BEGIN
      pq_cr_repo_opinion_riesgos.sp_obtner_Instanci_anterior(instancia => instancia,
                                                             Indicflujo => Indicflujo,          
                                                             auxInstnc => auxInstnc,
                                                             fechAntOut => fechAntOut,
                                                             TipFlujCN => TipFlujCN);
      fechaAnteM400  := fechAntOut;                                                           
    EXCEPTION
      WHEN OTHERS THEN
        auxInstnc := 0;
    END;    
    
  
    BEGIN
      INSERT INTO AQPC828
        (AQPC828CodOpi,
         AQPC828Afeere,
         AQPC828Afeean,
         AQPC828AIcMda1,
         AQPC828AIerBrT,
         AQPC828AIeaBrT,
         AQPC828AIahBrT,
         AQPC828AIcMda2,
         AQPC828AIerBrY,
         AQPC828AIeaBrY,
         AQPC828AIahBrY,
         AQPC828AIcMda3,
         AQPC828AIerBrC,
         AQPC828AIeaBrC,
         AQPC828AIahBrC,
         AQPC828AIcMda4,
         AQPC828AIerBrO,
         AQPC828AIeaBrO,
         AQPC828AIahBrO,
         AQPC828AIcMd24,
         AQPC828AIerBOT,
         AQPC828AIeaBOT,
         AQPC828AIahBOT,
         AQPC828AIcMda5,
         AQPC828AIerBTo,
         AQPC828AIeaBTo,
         AQPC828AIahBTo,
         AQPC828AIcMda6,
         AQPC828AIerNtT,
         AQPC828AIeaNtT,
         AQPC828AIahNtT,
         AQPC828AIcMda7,
         AQPC828AIerNtY,
         AQPC828AIeaNtY,
         AQPC828AIahNtY,
         AQPC828AIcMda8,
         AQPC828AIerNtC,
         AQPC828AIeaNtC,
         AQPC828AIahNtC,
         AQPC828AIcMda9,
         AQPC828AIerNtO,
         AQPC828AIeaNtO,
         AQPC828AIahNtO,
         AQPC828AEcMd25,
         AQPC828AEerNOT,
         AQPC828AEeaNOT,
         AQPC828AEahNOT,
         AQPC828AIcMd10,
         AQPC828AIerNTl,
         AQPC828AIeaNTl,
         AQPC828AIahNTl,
         AQPC828AEcMd11,
         AQPC828AEerAli,
         AQPC828AEeaAli,
         AQPC828AEahAli,
         AQPC828AEcMd12,
         AQPC828AEerAlq,
         AQPC828AEeaAlq,
         AQPC828AEahAlq,
         AQPC828AEcMd13,
         AQPC828AEerTrp,
         AQPC828AEeaTrp,
         AQPC828AEahTrp,
         AQPC828AEcMd14,
         AQPC828AEerEdu,
         AQPC828AEeaEdu,
         AQPC828AEahEdu,
         AQPC828AEcMd15,
         AQPC828AEerSer,
         AQPC828AEeaSer,
         AQPC828AEahSer,
         AQPC828AEcMd16,
         AQPC828AEerFam,
         AQPC828AEeaFam,
         AQPC828AEahFam,
         AQPC828AEcMd17,
         AQPC828AEerOtr,
         AQPC828AEeaOtr,
         AQPC828AEahOtr,
         AQPC828AEcMd18,
         AQPC828AEerGFt,
         AQPC828AEeaGFt,
         AQPC828AEahGFt,
         AQPC828AGcMd19,
         AQPC828AGerGFt,
         AQPC828AGeaGFt,
         AQPC828AGahGFt,
         AQPC828AEcMd20,
         AQPC828AEerNtM,
         AQPC828AEeaNtM,
         AQPC828AEahNtM,
         AQPC828AEcMd21,
         AQPC828AEerCrP,
         AQPC828AEeaCrP,
         AQPC828AEcMd22,
         AQPC828AEerCrV,
         AQPC828AEeaCrV,
         AQPC828AEcMd23,
         AQPC828AEerExF,
         AQPC828AEeaExF,
         AQPC828artign1,
         AQPC828artign2,
         AQPC828artexn1,
         AQPC828artexn2,
         AQPC828FECHREG, --0308
         AQPC828HORAREG,
         AQPC828AECMD24, --21082023
         AQPC828AEERCOT,
         AQPC828AEEACOT,
         AQPC828AECMD26,
         AQPC828AEERPOT,
         AQPC828AEEAPOT,
         AQPC828CORR, --2108               
         AQPC828ESTAD,
         AQPC828INSTANT,
         AQPC828FINANT) -- 01042024
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
         auxInstnc,
         fechaAnteM400);
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
    flgExisteM400   varchar2(1);
  
    CURSOR relac_financ_13_centid IS
      SELECT AQPB081ENTI,
             AQPB081TCRE,
             AQPB081CENT,
             sum(AQPB081SDEU) SaldoDeuda,
             sum(AQPB081GFIN) Cuota
        FROM AQPB081
       WHERE AQPB081INST = instancia
         AND AQPB081ESTA = 'S'
       group by AQPB081ENTI, AQPB081TCRE, AQPB081CENT;
  
    Cursor rl_financ_13 is
      SELECT AQPB081ENTI,
             AQPB081TCRE,
             sum(AQPB081SDEU) SaldoDeuda,
             sum(AQPB081GFIN) Cuota
        FROM AQPB081
       WHERE AQPB081INST = instancia
         AND AQPB081ESTA = 'S'
       group by AQPB081ENTI, AQPB081TCRE;
  
    Cursor rl_financ_14_centid IS
      select aqpb357ENTI,
             aqpb357TCRE,
             aqpb357CENT,
             sum(aqpb357GFIN) Cuota,
             sum(aqpb357SDEU) SaldoDeuda
        from aqpb357
       WHERE aqpb357INST = instancia
         AND aqpb357ESTA = 'S'
       group by aqpb357ENTI, aqpb357CENT, aqpb357TCRE;
  
    Cursor rl_financ_14 IS
      select aqpb357ENTI,
             aqpb357TCRE,
             sum(aqpb357GFIN) Cuota,
             sum(aqpb357SDEU) SaldoDeuda
        from aqpb357
       WHERE aqpb357INST = instancia
         AND aqpb357ESTA = 'S'
       group by aqpb357ENTI, aqpb357TCRE;
  
  BEGIN
    --11092023 --actualizar garantías
    BEGIN
      pq_cr_repo_opini_riesgos_crm.sp_cargar_c162(CodOpinion);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      /*UPDATE AQPC821 SET
      AQPC821ESTAD = 'I'
      WHERE AQPC821CODOPI = CodOpinion AND AQPC821ESTAD = 'H'; --07112023
      COMMIT;*/
      DELETE FROM AQPC821 WHERE AQPC821CODOPI = CodOpinion;
      COMMIT;
    END;
    
    flgExisteM400 := 'N'; --01042024
    BEGIN
      SELECT 'S' into flgExisteM400 FROM JAQM400 W WHERE W.JAQM400INS = instancia AND W.JAQM400FEC = fechaHoy AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;      
    END;   
    flgExisteM400 := nvl(flgExisteM400, 'N'); 
    
    IF flgExisteM400 = 'N' THEN
        BEGIN
          SELECT jaqz516TMod
            into xModelEvaluc
            FROM jaqz516
           WHERE jaqz516Sol = instancia
           and JAQZ516FEC = fechaHoy;
        EXCEPTION
          WHEN OTHERS THEN
            xModelEvaluc := 0;
        END;
    ELSE 
        xModelEvaluc := 14;
    END IF;
  
    IF xModelEvaluc = 13 THEN
      xFlgNoCodEntid := 'N';
      BEGIN
        SELECT 'S'
          INTO xFlgNoCodEntid
          FROM AQPB081 --newcrm
         WHERE AQPB081INST = instancia
           AND AQPB081ESTA = 'S'
           AND AQPB081CENT IS NULL
           AND ROWNUM < 2;
      EXCEPTION
        WHEN OTHERS THEN
          xFlgNoCodEntid := 'N';
      END;
    
      IF xFlgNoCodEntid = 'N' THEN
        FOR xentidades IN relac_financ_13_centid LOOP
          xEntidad    := xentidades.AQPB081enti;
          xSaldoVig   := xentidades.saldodeuda;
          xTipoCredi  := xentidades.AQPB081tcre;
          xGastoFinan := xentidades.cuota;
        
          xSaldoVigText   := trim(to_char(xSaldoVig));
          xGastoFinanText := trim(to_char(xGastoFinan));
        
          pq_cr_repo_opini_riesgos_crm.sp_insert_relacFinan_aqpc161(CodOpinion,
                                                                    fechaHoy,
                                                                    xEntidad,
                                                                    xGastoFinanText,
                                                                    xSaldoVigText,
                                                                    xTipoCredi);
        
        END LOOP;
      ELSE
        IF xFlgNoCodEntid = 'S' THEN
          FOR xentidades IN rl_financ_13 LOOP
            xEntidad    := xentidades.AQPB081enti;
            xSaldoVig   := xentidades.saldodeuda;
            xTipoCredi  := xentidades.AQPB081tcre;
            xGastoFinan := xentidades.cuota;
          
            xSaldoVigText   := trim(to_char(xSaldoVig));
            xGastoFinanText := trim(to_char(xGastoFinan));
          
            pq_cr_repo_opini_riesgos_crm.sp_insert_relacFinan_aqpc161(CodOpinion,
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
          from aqpb357
         WHERE aqpb357INST = instancia
           AND aqpb357ESTA = 'S'
           AND aqpb357CENT IS NULL
           AND ROWNUM < 2;
      EXCEPTION
        WHEN OTHERS THEN
          xFlgNoCodEntid := 'N';
      END;
    
      IF xFlgNoCodEntid = 'N' THEN
        FOR xentidades IN rl_financ_14_centid LOOP
          xEntidad    := xentidades.aqpb357enti;
          xSaldoVig   := xentidades.saldodeuda;
          xTipoCredi  := xentidades.aqpb357tcre;
          xGastoFinan := xentidades.cuota;
        
          xSaldoVigText   := trim(to_char(xSaldoVig));
          xGastoFinanText := trim(to_char(xGastoFinan));
        
          pq_cr_repo_opini_riesgos_crm.sp_insert_relacFinan_aqpc161(CodOpinion,
                                                                    fechaHoy,
                                                                    xEntidad,
                                                                    xGastoFinanText,
                                                                    xSaldoVigText,
                                                                    xTipoCredi);
        
        END LOOP;
      ELSE
        IF xFlgNoCodEntid = 'S' THEN
          FOR xentidades IN rl_financ_14 LOOP
            xEntidad    := xentidades.aqpb357enti;
            xSaldoVig   := xentidades.saldodeuda;
            xTipoCredi  := xentidades.aqpb357tcre;
            xGastoFinan := xentidades.cuota;
          
            xSaldoVigText   := trim(to_char(xSaldoVig));
            xGastoFinanText := trim(to_char(xGastoFinan));
          
            pq_cr_repo_opini_riesgos_crm.sp_insert_relacFinan_aqpc161(CodOpinion,
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
                                      xAQPC171ANCNEG  out varchar,
                                      xAQPC171ANVIC   out varchar,
                                      xAQPC171FCN     out varchar,
                                      xAQPC171AESFCC  out varchar,
                                      xAQPC171RDCLN   out varchar,
                                      xAQPC171ANCP    out varchar,
                                      xAQPC171ANCPG   out varchar,
                                      xAQPC171DANDC   out varchar,
                                      xAQPC171DGCOR   out varchar,
                                      xAQPC171RANCNEG out varchar,
                                      xAQPC171MTREP   out varchar,
                                      xAQPC171RAESFCC out varchar,
                                      xAQPC171ANCPRF  out varchar,
                                      xAQPC171ANVPG   out varchar,
                                      xAQPC171DEGV    out varchar,
                                      xAQPC171RFANCNE out varchar,
                                      xAQPC171MTREFN  out varchar,
                                      xAQPC171RFAESFC out varchar,
                                      xAQPC171RFANCPR out varchar,
                                      xAQPC171RFANVPG out varchar,
                                      xAQPC171RFDEGV  out varchar,
                                      xAQPC171USURAR  out varchar,
                                      xAQPC171COMEN   out varchar,
                                      xAQPC171RESOL   out varchar,
                                      xAQPC171CONREC  out varchar,
                                      xAQPC171ARGRECO out varchar, -- INI RCASTRO 10072023
                                      xAQPC171ANACOME out varchar,
                                      xAQPC171RESOLRE out varchar,
                                      xAQPC171CONDREC out varchar, -- FIN RCASTRO 10072023 
                                      xAQPC171MOTOBSV out varchar2) IS
  BEGIN
    BEGIN
      SELECT AQPC819ANCNEG,
             AQPC819ANVIC,
             AQPC819FCN,
             AQPC819AESFCC,
             AQPC819RDCLN,
             AQPC819ANCP,
             AQPC819ANCPG,
             AQPC819DANDC,
             AQPC819DGCOR,
             AQPC819RANCNEG,
             AQPC819MTREP,
             AQPC819RAESFCC,
             AQPC819ANCPRF,
             AQPC819ANVPG,
             AQPC819DEGV,
             AQPC819RFANCNE,
             AQPC819MTREFN,
             AQPC819RFAESFC,
             AQPC819RFANCPR,
             AQPC819RFANVPG,
             AQPC819RFDEGV,
             AQPC819USURAR,
             AQPC819COMEN,
             AQPC819RESOL,
             AQPC819CONREC,
             AQPC819ARGRECO,
             AQPC819ANACOME,
             AQPC819RESOLRE,
             AQPC819CONDREC,
             AQPC819MOTOBSV
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
        FROM AQPC819
       WHERE AQPC819CODOPI = CodOpinion
         AND AQPC819INST = instancia
         AND AQPC819ESTAD = 'H'; --21082023
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;

  PROCEDURE sp_lista_opiniones(instancia    number,
                               userIngreso  varchar2,
                               nivelUsuIng  number,
                               userSuplente varchar2,
                               nivelUsuSupl number,
                               fechaIngreso date,
                               msgError     out varchar2) IS --01042024
    --Variables
    i        number(1);
    auxUser  varchar2(10);
    auxUser2 varchar2(10);
    auxNivel number(2);
    flgErr   varchar2(200);
    n        number(1);
  BEGIN
    BEGIN
      DELETE FROM AQPC194 WHERE AQPC194USUEJ = userIngreso;
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
          pq_cr_repo_opini_riesgos_CRM.sp_cargar_solic_pend_opinion(instancia,
                                                                    auxUser,
                                                                    auxUser2,
                                                                    fechaIngreso,
                                                                    auxNivel,
                                                                    flgErr);
         msgError := flgErr ; --01042024                                                                                                                              
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      ELSE
        IF auxNivel in (4, 5, 6) THEN
          BEGIN
            pq_cr_repo_opini_riesgos_CRM.sp_cargar_opiniones_156(auxUser,
                                                                 0,
                                                                 fechaIngreso,
                                                                 flgErr);
            msgError := flgErr ; --01042024                                                                                                                       
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
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
    FechIngr  date;
  BEGIN
    --actualizar ACreditos y GA
    BEGIN
      pq_cr_repo_opini_riesgos_crm.sp_obtn_Asesor(instancia,
                                                  usuarioAC,
                                                  FechIngr);
      /*select SNG001ASE
       INTO usuarioAC
       from sng001
      where sng001inst = instancia
        AND ROWNUM < 2;*/
    EXCEPTION
      WHEN OTHERS THEN
        usuarioAC := '';
    END;
  
    xCodCargo := 202;
    BEGIN
      pq_cr_repo_opini_riesgos_crm.sp_buscar_usuario_correo_GA(sucurCred,
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
      pq_cr_repo_opini_riesgos_crm.sp_grab_log_aqpc156(codOpini, instancia);
    END;
  
    BEGIN
      SELECT AQPC818NRECONS
        INTO varRecons
        FROM AQPC818
       WHERE AQPC818CODOPI = codOpini
         AND AQPC818INSTAN = instancia
         AND AQPC818ESTAD = 'H'; --2108;
    EXCEPTION
      WHEN OTHERS THEN
        varRecons := 0;
    END;
  
    IF varRecons IS NULL THEN
      varRecons := 0;
    END IF;
  
    varRecons := varRecons + 1;
  
    BEGIN
      UPDATE AQPC818
         SET AQPC818NRECONS = varRecons
       WHERE AQPC818CODOPI = codOpini
         and AQPC818INSTAN = instancia
         AND AQPC818ESTAD = 'H'; --2108;
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
          FROM AQPC818 G
         WHERE G.AQPC818CODOPI =
               (SELECT (MAX(B.AQPC818CODOPI))
                  FROM AQPC818 B
                 WHERE B.AQPC818INSTAN = intancia
                   AND AQPC818ESTAD = 'H') --07112023
           AND G.AQPC818INSTAN = intancia
           AND AQPC818ESTAD = 'H' --2108
           AND AQPC818USRDER = userAnaliRiesgo;
           --AND AQPC818ANSERIG = userAnaliRiesgo
           --AND AQPC818NIVEL = 3;        
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
                                    correoSuplen  out varchar2) is --usado por pck anterior
  BEGIN
    BEGIN
      SELECT SNG057Sup
        INTO usuarioSuplen
        FROM SNG057
       WHERE SNG055Emp = 1
         AND RPAD(SNG057Usr, 10, ' ') = RPAD(usuario, 10, ' ')
         AND SNG057Ini <= fechaActual
         And SNG057Fin >= fechaActual
         AND ROWNUM < 2;
    EXCEPTION
      WHEN OTHERS THEN
        usuarioSuplen := ' ';
    END;
  
    IF usuarioSuplen IS NULL  OR usuarioSuplen = ' ' THEN
      usuarioSuplen := ' ';
    ELSE
      -- CORREO suplente
      BEGIN
        SELECT WFUSREMAIL
          INTO correoSuplen
          FROM WFUSERS
         WHERE RPAD(WFUSRCOD, 10, ' ') = RPAD(usuarioSuplen, 10, ' ');
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
    --vi_tieneOpinion number(2);
    vi_TipoOpinion varchar2(50);
    vi_mensaje     varchar2(200);
  BEGIN
    xflagAux := 'N';
    BEGIN
      SELECT 'S'
        INTO XFLAGAUX
        FROM WFWRKITEMS B
       WHERE --B.WFTASKCOD = 11 AND
       B.WFINSPRCID = INSTANCIA
       AND B.WFITEMSTSACT = 1;
    EXCEPTION
      WHEN OTHERS THEN
        xflagAux := 'N';
    END;
  
    --07112023  -- comentado rcastro 07/12/2023
    /*IF xflagAux = 'N' THEN
        --validar si ya fue gestionado newcrm
        BEGIN
          pq_cr_reprogramaexo.sp_validaopinion(INSTANCIA,
                                               vi_tieneOpinion,
                                               vi_TipoOpinion,
                                               vi_mensaje);
        EXCEPTION
          when OTHERS THEN
            null;
        END;
        
        IF vi_tieneOpinion <> 1  THEN
           xflagAux := 'S';
        END IF;          
    END IF;*/
    --07112023
  
    xflagAux := 'S'; -- se omite para crm 18/12/2023
  
    flgActivo := xflagAux;
  
    --actualizar AQPC156 con estado X -- RECHAZADO - INACTIVO
    IF xflagAux = 'N' THEN
      BEGIN
        --2108
        pq_cr_repo_opini_riesgos_crm.sp_grab_log_aqpc156(codOpinion,
                                                         instancia);
      END;
    
      BEGIN
        UPDATE AQPC818 G
           SET G.AQPC818ESTOP = 'X'
         WHERE G.AQPC818CODOPI =
               (SELECT (MAX(B.AQPC818CODOPI))
                  FROM AQPC818 B
                 WHERE B.AQPC818INSTAN = instancia
                   AND AQPC818ESTAD = 'H') --07112023
           AND G.AQPC818INSTAN = instancia
           AND G.AQPC818ESTAD = 'H'; --2108;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
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
        pq_cr_repo_opini_riesgos_crm.sp_grab_log_aqpc156(codOpinion,
                                                         instancia);
      END;
      BEGIN
        UPDATE AQPC818
           SET AQPC818ACTCONT = flgHabAnCont,
               AQPC818PRODSBS = txtProductoSBS
         WHERE AQPC818CODOPI = (SELECT (MAX(B.AQPC818CODOPI))
                                  FROM AQPC818 B
                                 WHERE B.AQPC818INSTAN = instancia
                                   AND AQPC818ESTAD = 'H') --07112023
           AND AQPC818INSTAN = instancia
           AND AQPC818ESTAD = 'H'; --2108;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  END;

  PROCEDURE sp_obtener_tipo_cambio(instancia number, tipoCambio out number) IS
    --usado por pck anterior
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
    flgExisteM400  VARCHAR2(1);
    Fech_act DATE;
  
    CURSOR PymeAvalados IS
      SELECT *
        FROM JAQY142B --newcrm
       WHERE JAQY142INST = instancia
         AND JAQY142EST = 'H'
         AND JAQY142INDIC IN ('CredVgnAvl', 'CredVlAval'); --18/12/2023
  
    CURSOR ConsumAvalados is
      SELECT *
        FROM JAQZ822B --01042024
       WHERE JAQZ822INST = instancia
         AND JAQZ822EST = 'H'
         AND JAQZ822INDIC IN ('CredVgnAvl', 'CredVlAval'); --18/12/2023
  
  BEGIN
    
    BEGIN
       SELECT PGFAPE INTO Fech_act FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;      
    END;    
    flgExisteM400 := 'N'; --01042024
    BEGIN
      SELECT 'S' into flgExisteM400 FROM JAQM400 W WHERE W.JAQM400INS = instancia AND W.JAQM400FEC = Fech_act AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;      
    END;   
    flgExisteM400 := nvl(flgExisteM400, 'N');        
    
    IF flgExisteM400 = 'N' THEN
        BEGIN
          select jaqz516TMOD
            INTO auxTmod
            from jaqz516
           where jaqz516SOL = instancia
            and JAQZ516FEC = Fech_act;
        EXCEPTION
          WHEN OTHERS THEN
            auxTmod := 0;
        END;
    ELSE 
       AUXTMOD := 14;
    END IF;    
  
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
          pq_cr_repo_opini_riesgos_crm.sp_obtner_datos_Avald(xr.jaqy142pgcod,
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
            pq_cr_repo_opini_riesgos_crm.sp_obtner_datos_Avald(xr.jaqz822pgcod,
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
         AND XLLAOSBOP = p_suboper --newcrm
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

  PROCEDURE sp_obtn_val_cred_pyme(instancia         number, --21032023
                                  nroINTipoCN       number,                      
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
  
    v_Pgcod  number(3); --08012024
    v_Scmod  number(4);
    v_Scsuc  number(4);
    v_Scmda  number(4);
    v_Scpap  number(4);
    v_Sccta  number(9);
    v_Scoper number(9);
    v_Scsbop number(3);
    v_Sctope number(3);
    fechAntM400 date;
    
    Indicflujo         VARCHAR2(3);
    fechAntOut         DATE;
    TipFlujCN          VARCHAR2(1); 
    norm_xCredPropueAct    number(17,2);     
    norm_xCredPropueAnt    number(17,2);    
    norm_xSumcuotaVigRec   number(17,2);   
    norm_xSumcuotaVigAnter number(17,2);   
    norm_xCredicContingAct number(17,2);   
    norm_xCredicContingAnt number(17,2);   
    norm_xCredPotencAct    number(17,2);   
    norm_xCredPotencAnt    number(17,2);
    nroOUTipoCN  number(1);            
       
  
    CURSOR CS_SumVigReci is --08012024
      SELECT *
      --INTO xSumcuotaVigRec
        FROM JAQY142B J
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
         and j.jaqy142nrcuo > 1;
  
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
          FROM XWF700 A, JAQY142B B --newcrm
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
                    and a.tp1corr2 = 1) and B.jaqy142mod not in 117);
        --AND b.jaqy142tarea = 7;         
      EXCEPTION
        WHEN OTHERS THEN
          xCredPropueAct := 0;
      END;
    else
      if ln_ModInst = 117 then
        BEGIN
          SELECT JAQY142CAPCUO
            INTO xCredPropueAct
            FROM XWF700 A, JAQY142B B
           WHERE A.XWFEMPRESA = B.JAQY142PGCOD
             AND A.XWFSUCURSAL = B.JAQY142SUC
             AND A.XWFCUENTA = B.JAQY142CTA
             AND A.XWFOPERACION = B.JAQY142OPE
             AND A.XWFPRCINS = B.JAQY142INST
             AND A.XWFTIPOPE = B.JAQY142TOPE
             AND XWFPRCINS = instancia
             AND XWFCAR3 = '1'
             AND B.JAQY142EST = 'H';
          --AND b.jaqy142tarea = 7;
        EXCEPTION
          WHEN OTHERS THEN
            xCredPropueAct := 0;
        END;
      
        xCredPropueAct := nvl(xCredPropueAct, 0);
      
      end if;
    end if;
    
    TipFlujCN := 'C';
    IF nroINTipoCN <> 1 THEN --30042024
       /*pq_cr_repo_opini_riesgos_crm.sp_obtner_Instanci_anterior(instancia,
                                                             auxInstanAnt,
                                                             fechAntM400);*/
       Indicflujo := 'CRM'; 
       BEGIN      
       pq_cr_repo_opinion_riesgos.sp_obtner_Instanci_anterior(instancia => instancia,  --30042024
                                                             Indicflujo => Indicflujo,          
                                                             auxInstnc => auxInstanAnt,
                                                             fechAntOut => fechAntOut,
                                                             TipFlujCN => TipFlujCN);  
      fechAntM400 := fechAntOut; 
      EXCEPTION
         WHEN OTHERS THEN
           NULL;
      END;                                                                                                                       
    END IF;  
    
    IF nroINTipoCN = 1 THEN --30042024
       auxInstanAnt := instancia;
    END IF;                                                              
    
    IF TipFlujCN = 'C' THEN
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
              FROM XWF700 A, JAQY142B B --newcrm
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
                        and a.tp1corr2 = 1) and B.jaqy142mod not in 117);
            --AND b.jaqy142tarea = 7;         
          EXCEPTION
            WHEN OTHERS THEN
              xCredPropueAnt := 0;
          END;
        
        else
          if ln_ModInstAnt = 117 then
          
            BEGIN
              SELECT JAQY142CAPCUO
                INTO xCredPropueAnt
                FROM XWF700 A, JAQY142B B
               WHERE A.XWFEMPRESA = B.JAQY142PGCOD
                 AND A.XWFSUCURSAL = B.JAQY142SUC
                 AND A.XWFCUENTA = B.JAQY142CTA
                 AND A.XWFOPERACION = B.JAQY142OPE
                 AND A.XWFPRCINS = B.JAQY142INST
                 AND A.XWFTIPOPE = B.JAQY142TOPE
                 AND XWFPRCINS = auxInstanAnt
                 AND XWFCAR3 = '1'
                 AND B.JAQY142EST = 'H';
              --AND b.jaqy142tarea = 7;
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
      --obtener el crédito a reprogramar suboperación = 609
      pq_cr_repo_opini_riesgos_crm.sp_obtener_Credito(instancia,
                                                      v_Pgcod,
                                                      v_Scmod,
                                                      v_Scsuc,
                                                      v_Scmda,
                                                      v_Scpap,
                                                      v_Sccta,
                                                      v_Scoper,
                                                      v_Scsbop,
                                                      v_Sctope);
    END;
    v_Scsbop := 609;
    FOR reg in CS_SumVigReci LOOP
      --08012024
      IF reg.jaqy142pgcod = v_pgcod and reg.jaqy142mod = v_Scmod and
         reg.jaqy142suc = v_Scsuc and reg.jaqy142mda = v_Scmda and
         reg.jaqy142pap = v_scpap and reg.jaqy142cta = v_sccta and
         reg.jaqy142ope = v_scoper and v_Scsbop = 609 and
         reg.jaqy142tope = v_sctope THEN
        continue;
      ELSE
        xSumcuotaVigRec := xSumcuotaVigRec + reg.JAQY142CAPCUO;
      END IF;
    END LOOP;
  
    IF TipFlujCN = 'C' THEN
        --Cred. Vigente anterior
        xSumcuotaVigAnter := 0;
        BEGIN
          SELECT SUM(JAQY142CAPCUO)
            INTO xSumcuotaVigAnter
            FROM JAQY142B J --newcrm
           WHERE J.JAQY142INST = auxInstanAnt
             AND J.JAQY142EST = 'H'
             AND J.JAQY142INDIC IN ('CredVigent', 'CredVencid', 'LineaVencd')
             and (j.jaqy142mod not in
                 (select tp1nro1
                     from fst198 a
                    where a.tp1cod = 1
                      and a.tp1cod1 = 10899
                      and a.tp1corr1 = 13
                      and a.tp1corr2 = 1) and j.jaqy142mod not in 117) --mpostigoc 30.10.2023
             and j.jaqy142nrcuo > 1;
          --AND JAQY142TAREA = 55; --13092023
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
        from jaqy140B --newcrm
       where JAQY140INST = instancia
         and JAQY140EST = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        xCredicContingAct := 0;
        xCredPotencAct    := 0;
    END;
  
    IF TipFlujCN = 'C' THEN
        --Cred. Contingencia anterior y  y potencial anterior 
        xCredicContingAnt := 0;
        xCredPotencAnt    := 0;
        BEGIN
          select JAQY140CCONTG, JAQY140CPOTEN
            INTO xCredicContingAnt, xCredPotencAnt
            from jaqy140B --newcrm
           where JAQY140INST = auxInstanAnt
             and JAQY140EST = 'H';
        EXCEPTION
          WHEN OTHERS THEN
            xCredicContingAnt := 0;
            xCredPotencAnt    := 0;
        END;
    END IF;
    
    IF TipFlujCN = 'N' THEN --EVAL anter es CRM 30042024
       nroOUTipoCN := 2;
       begin
       pq_cr_repo_opinion_riesgos.sp_obtn_val_cred_pyme(  auxInstanAnt          ,
                                                          nroOUTipoCN           ,                    
                                                          norm_xCredPropueAct    ,
                                                          norm_xCredPropueAnt    ,
                                                          norm_xSumcuotaVigRec   ,
                                                          norm_xSumcuotaVigAnter ,
                                                          norm_xCredicContingAct ,
                                                          norm_xCredicContingAnt ,
                                                          norm_xCredPotencAct    ,
                                                          norm_xCredPotencAnt    );
      Exception 
     when others then
       null;                                                                 
     end; 
     
     xCredPropueAnt     := norm_xCredPropueAnt;
     xSumcuotaVigAnter  := norm_xSumcuotaVigAnter;
     xCredicContingAnt  := norm_xCredicContingAnt;
     xCredPotencAnt     := norm_xCredPotencAnt;                                                                                                                    
      
    END IF;
  
  END;

  PROCEDURE sp_grab_log_aqpc156(codOpinion number, instancia number) IS
    CURSOR LOG_156(CodOpi number) IS
      SELECT *
        FROM AQPC818
       WHERE AQPC818CODOPI = CodOpi --07112023
         AND AQPC818INSTAN = INSTANCIA
         AND AQPC818ESTAD = 'H'
         AND AQPC818ESTOP <> 'T'; --07112023
  
    v_correlativo NUMBER(5);
    v_codOpinion  number(10);
    v_NewCorrel   NUMBER(5);
    v_fechaActual date;
  
  BEGIN
    IF codOpinion = 0 OR codOpinion IS NULL THEN
      BEGIN
        SELECT MAX(AQPC818CODOPI)
          INTO v_codOpinion
          FROM AQPC818
         WHERE AQPC818INSTAN = INSTANCIA
           AND AQPC818ESTAD = 'H';
      EXCEPTION
        WHEN OTHERS THEN
          v_codOpinion := 0;
      END;
    ELSE
      v_codOpinion := codOpinion;
    END IF;
  
    BEGIN
      SELECT T.PGFAPE INTO v_fechaActual FROM FST017 T WHERE T.PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        v_fechaActual := TO_DATE(SYSDATE, 'dd/mm/rrrr');
    END;
  
    -- 2108
    BEGIN
      SELECT MAX(AQPC818CORR)
        INTO v_correlativo
        FROM AQPC818
       WHERE AQPC818CODOPI = v_codOpinion
         AND AQPC818INSTAN = INSTANCIA;
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
        INSERT INTO AQPC818
          (AQPC818CODOPI,
           AQPC818FECPRO,
           AQPC818INSTAN,
           AQPC818A,
           AQPC818DE,
           AQPC818ASUNT,
           AQPC818TEXCOM,
           AQPC818CLIEN,
           AQPC818DNI,
           AQPC818ANALIS,
           AQPC818AGENC,
           AQPC818ZONA,
           AQPC818REGIO,
           AQPC818RATGANA,
           AQPC818RATAGEN,
           AQPC818SLDCANA,
           AQPC818SLDCAGE,
           AQPC818SLDCZON,
           AQPC818SLDCREG,
           AQPC818NCLIANA,
           AQPC818NCLIAGE,
           AQPC818NCLIZON,
           AQPC818NCLIREG,
           AQPC818NMORAG,
           AQPC818NMORAN,
           AQPC818NMORZO,
           AQPC818NMOREG,
           AQPC818NVRIESG,
           AQPC818ACTIVID,
           AQPC818PDANA,
           AQPC818PDAGE,
           AQPC818PDZON,
           AQPC818PDREG,
           AQPC818COH4ANA,
           AQPC818COH4AGE,
           AQPC818COH4ZON,
           AQPC818COH4REG,
           AQPC818COH6ANA,
           AQPC818COH6AGE,
           AQPC818COH6ZON,
           AQPC818COH6REG,
           AQPC818SOLIC,
           AQPC818CTNRO,
           AQPC818CALIF,
           AQPC818PRODSBS,
           AQPC818FECEEFF,
           AQPC818FECINFC,
           AQPC818CODTPRO,
           AQPC818TIPPRO,
           AQPC818RESPTOT,
           AQPC818SLDPROP,
           AQPC818MODPRP,
           AQPC818CUOTAS,
           AQPC818CUOPRP,
           AQPC818TASPRP,
           AQPC818TIPSOL,
           AQPC818DETISOL,
           AQPC818ESTOP,
           AQPC818HORRG,
           AQPC818USUREG,
           AQPC818GRAGE,
           AQPC818ANSERIG,
           AQPC818USRDER,
           AQPC818FECDEL,
           AQPC818NIVEL,
           AQPC818AUX1,
           AQPC818AUX2,
           AQPC818AUX3,
           AQPC818AUX4,
           AQPC818ACTCONT,
           AQPC818SUPADMI,
           AQPC818JEFADMI,
           AQPC818GERRIES,
           AQPC818NRECONS,
           AQPC818ESRECON,
           AQPC818ESTAD,
           AQPC818CORR,
           AQPC818TCAMB,
           AQPC818MDAPROP)
        VALUES
          (ln.AQPC818CODOPI,
           v_fechaActual,
           ln.AQPC818INSTAN,
           ln.AQPC818A,
           ln.AQPC818DE,
           ln.AQPC818ASUNT,
           ln.AQPC818TEXCOM,
           ln.AQPC818CLIEN,
           ln.AQPC818DNI,
           ln.AQPC818ANALIS,
           ln.AQPC818AGENC,
           ln.AQPC818ZONA,
           ln.AQPC818REGIO,
           ln.AQPC818RATGANA,
           ln.AQPC818RATAGEN,
           ln.AQPC818SLDCANA,
           ln.AQPC818SLDCAGE,
           ln.AQPC818SLDCZON,
           ln.AQPC818SLDCREG,
           ln.AQPC818NCLIANA,
           ln.AQPC818NCLIAGE,
           ln.AQPC818NCLIZON,
           ln.AQPC818NCLIREG,
           ln.AQPC818NMORAG,
           ln.AQPC818NMORAN,
           ln.AQPC818NMORZO,
           ln.AQPC818NMOREG,
           ln.AQPC818NVRIESG,
           ln.AQPC818ACTIVID,
           ln.AQPC818PDANA,
           ln.AQPC818PDAGE,
           ln.AQPC818PDZON,
           ln.AQPC818PDREG,
           ln.AQPC818COH4ANA,
           ln.AQPC818COH4AGE,
           ln.AQPC818COH4ZON,
           ln.AQPC818COH4REG,
           ln.AQPC818COH6ANA,
           ln.AQPC818COH6AGE,
           ln.AQPC818COH6ZON,
           ln.AQPC818COH6REG,
           ln.AQPC818SOLIC,
           ln.AQPC818CTNRO,
           ln.AQPC818CALIF,
           ln.AQPC818PRODSBS,
           ln.AQPC818FECEEFF,
           ln.AQPC818FECINFC,
           ln.AQPC818CODTPRO,
           ln.AQPC818TIPPRO,
           ln.AQPC818RESPTOT,
           ln.AQPC818SLDPROP,
           ln.AQPC818MODPRP,
           ln.AQPC818CUOTAS,
           ln.AQPC818CUOPRP,
           ln.AQPC818TASPRP,
           ln.AQPC818TIPSOL,
           ln.AQPC818DETISOL,
           ln.AQPC818ESTOP,
           to_char(SYSDATE, 'HH24:MI:SS'), --ln.AQPC818HORRG   ,
           ln.AQPC818USUREG,
           ln.AQPC818GRAGE,
           ln.AQPC818ANSERIG,
           ln.AQPC818USRDER,
           ln.AQPC818FECDEL,
           ln.AQPC818NIVEL,
           ln.AQPC818AUX1,
           ln.AQPC818AUX2,
           ln.AQPC818AUX3,
           ln.AQPC818AUX4,
           ln.AQPC818ACTCONT,
           ln.AQPC818SUPADMI,
           ln.AQPC818JEFADMI,
           ln.AQPC818GERRIES,
           ln.AQPC818NRECONS,
           ln.AQPC818ESRECON,
           ln.AQPC818ESTAD,
           v_NewCorrel,
           ln.AQPC818tcamb,
           ln.AQPC818mdaprop);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;
  
    --Actualizar de H a I 
    IF v_correlativo > 0 THEN
      BEGIN
        UPDATE AQPC818
           SET AQPC818ESTAD = 'I'
         WHERE AQPC818CODOPI = v_codOpinion
           AND AQPC818INSTAN = INSTANCIA
           AND AQPC818ESTAD = 'H'
           AND AQPC818CORR = v_correlativo;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
  END;

  PROCEDURE sp_grab_coment_observ(CodOpinion   number, --2410
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
      pq_cr_repo_opini_riesgos_crm.sp_grab_log_aqpc171(CodOpinion,
                                                       instancia);
    
      BEGIN
        UPDATE AQPC819
           SET AQPC819MOTOBSV = ComentObserv
         WHERE AQPC819CODOPI = CodOpinion
           AND AQPC819INST = instancia
           AND AQPC819ESTAD = 'H';
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      BEGIN
        SELECT T.PGFAPE INTO fechaActual FROM FST017 T WHERE T.PGCOD = 1;
      EXCEPTION
        WHEN OTHERS THEN
          fechaActual := to_date(sysdate, 'dd/MM/RRRR');
      END;
      HoraActu := TO_CHAR(SYSDATE, 'HH24:MI:SS');
    
      flgEstObser := 'N';
      BEGIN
        --22012024
        SELECT 'S'
          INTO flgEstObser
          FROM AQPC818 A
         WHERE AQPC818CODOPI = CodOpinion
           AND AQPC818INSTAN = instancia
           AND AQPC818ESTAD = 'H'
           AND AQPC818ESTOP = 'O';
      EXCEPTION
        WHEN OTHERS THEN
          flgEstObser := 'N';
      END;
    
      IF flgEstObser = 'N' THEN
        ---Guardar en la aqpc801
        pq_cr_repo_opini_riesgos_crm.sp_grabarLogEstadoOpinion(codOpinion   => CodOpinion,
                                                               fechaActual  => fechaActual,
                                                               Hora         => HoraActu,
                                                               UsuarioEjec  => usuario,
                                                               codCadena    => NivelAprob,--3,
                                                               estadoActual => 'O');
      
        begin
          UPDATE AQPC818
             SET AQPC818ESTOP = 'O'
           WHERE AQPC818CODOPI = CodOpinion
             AND AQPC818INSTAN = instancia
             AND AQPC818ESTAD = 'H';
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
          FROM AQPC818 A
         WHERE AQPC818CODOPI = CodOpinion
           AND AQPC818INSTAN = instancia
           AND AQPC818ESTAD = 'H'
           AND AQPC818ESTOP = 'O';
      EXCEPTION
        WHEN OTHERS THEN
          flgEstObser := 'N';
      END;
    
      IF flgEstObser = 'S' THEN
        pq_cr_repo_opini_riesgos_crm.sp_grab_log_aqpc171(CodOpinion,
                                                         instancia);
      
        BEGIN
          UPDATE AQPC819
             SET AQPC819MOTOBSV = ComentObserv
           WHERE AQPC819CODOPI = CodOpinion
             AND AQPC819INST = instancia
             AND AQPC819ESTAD = 'H';
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
  
    CURSOR data_AQPC819 IS
      SELECT *
        FROM AQPC819
       WHERE AQPC819CODOPI = codOpinion
         AND AQPC819INST = instancia
         AND AQPC819ESTAD = 'H'
         AND ROWNUM = 1;
  BEGIN
    fechaActual  := to_date(sysdate, 'dd/MM/RRRR');
    HoraActu     := TO_CHAR(SYSDATE, 'HH24:MI:SS');
    v_CorrActual := 0;
  
    FOR ln in data_AQPC819 LOOP
      v_CorrActual     := ln.AQPC819corr;
      v_NewCorrelativo := v_CorrActual + 1;
      BEGIN
        INSERT INTO AQPC819
          (AQPC819CODOPI,
           AQPC819CORR,
           AQPC819USUR,
           AQPC819FECPRO,
           AQPC819INST,
           AQPC819CARGO,
           AQPC819ANCNEG,
           AQPC819ANVIC,
           AQPC819FCN,
           AQPC819AESFCC,
           AQPC819RDCLN,
           AQPC819ANCP,
           AQPC819ANCPG,
           AQPC819DANDC,
           AQPC819DGCOR,
           AQPC819RANCNEG,
           AQPC819MTREP,
           AQPC819RAESFCC,
           AQPC819ANCPRF,
           AQPC819ANVPG,
           AQPC819DEGV,
           AQPC819RFANCNE,
           AQPC819MTREFN,
           AQPC819RFAESFC,
           AQPC819RFANCPR,
           AQPC819RFANVPG,
           AQPC819RFDEGV,
           AQPC819USURAR,
           AQPC819COMEN,
           AQPC819RESOL,
           AQPC819CONREC,
           AQPC819ARGRECO,
           AQPC819ANACOME,
           AQPC819RESOLRE,
           AQPC819CONDREC,
           AQPC819HORAREG,
           AQPC819ESTAD,
           AQPC819MOTOBSV)
        VALUES
          (ln.AQPC819CODOPI,
           v_NewCorrelativo,
           ln.AQPC819USUR,
           fechaActual,
           ln.AQPC819INST,
           ln.AQPC819CARGO,
           ln.AQPC819ANCNEG,
           ln.AQPC819ANVIC,
           ln.AQPC819FCN,
           ln.AQPC819AESFCC,
           ln.AQPC819RDCLN,
           ln.AQPC819ANCP,
           ln.AQPC819ANCPG,
           ln.AQPC819DANDC,
           ln.AQPC819DGCOR,
           ln.AQPC819RANCNEG,
           ln.AQPC819MTREP,
           ln.AQPC819RAESFCC,
           ln.AQPC819ANCPRF,
           ln.AQPC819ANVPG,
           ln.AQPC819DEGV,
           ln.AQPC819RFANCNE,
           ln.AQPC819MTREFN,
           ln.AQPC819RFAESFC,
           ln.AQPC819RFANCPR,
           ln.AQPC819RFANVPG,
           ln.AQPC819RFDEGV,
           ln.AQPC819USURAR,
           ln.AQPC819COMEN,
           ln.AQPC819RESOL,
           ln.AQPC819CONREC,
           ln.AQPC819ARGRECO,
           ln.AQPC819ANACOME,
           ln.AQPC819RESOLRE,
           ln.AQPC819CONDREC,
           HoraActu,
           'H',
           ln.AQPC819MOTOBSV);
      END;
      COMMIT;
    END LOOP;
  
    --Actualizar de H a I 
    IF v_CorrActual > 0 THEN
      BEGIN
        UPDATE AQPC819
           SET AQPC819ESTAD = 'I'
         WHERE AQPC819CODOPI = codOpinion
           AND AQPC819INST = INSTANCIA
           AND AQPC819ESTAD = 'H'
           AND AQPC819CORR = v_CorrActual;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
  END;

  procedure sp_obtener_Credito(instancia in number,
                               v_Pgcod   out number,
                               v_Scmod   out number,
                               v_Scsuc   out number,
                               v_Scmda   out number,
                               v_Scpap   out number,
                               v_Sccta   out number,
                               v_Scoper  out number,
                               v_Scsbop  out number,
                               v_Sctope  out number) IS
    -- *****************************************************************
    -- Nombre                     : sp_obtener_Credito
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Obtiene los creditos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                 
  BEGIN
    BEGIN
      SELECT W.XWFEMPRESA,
             W.XWFSUCURSAL,
             W.XWFMODULO,
             W.XWFMONEDA,
             W.XWFPAPEL,
             W.XWFCUENTA,
             W.XWFOPERACION,
             W.XWFSUBOPE,
             W.XWFTIPOPE
        INTO v_Pgcod,
             v_Scsuc,
             v_Scmod,
             v_Scmda,
             v_Scpap,
             v_Sccta,
             v_Scoper,
             v_Scsbop,
             v_Sctope
        FROM XWF700 W
       WHERE W.XWFPRCINS = instancia
         AND W.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;

  PROCEDURE sp_obtn_Asesor(instancia  in number,
                           asesor     out varchar2,
                           fecIngreso out date) is
    -- *****************************************************************
    -- Nombre                     : sp_obtn_Asesor
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca el asesor
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                            
    v_Pgcod  number(3); --newcrm
    v_Scmod  number(4);
    v_Scsuc  number(4);
    v_Scmda  number(4);
    v_Scpap  number(4);
    v_Sccta  number(9);
    v_Scoper number(9);
    v_Scsbop number(3);
    v_Sctope number(3);
    fecMax   date;
  BEGIN
    pq_cr_repo_opini_riesgos_crm.sp_obtener_Credito(instancia,
                                                    v_Pgcod,
                                                    v_Scmod,
                                                    v_Scsuc,
                                                    v_Scmda,
                                                    v_Scpap,
                                                    v_Sccta,
                                                    v_Scoper,
                                                    v_Scsbop,
                                                    v_Sctope);
  
    Begin
      SELECT MAX(JAQA400FEC)
        into fecMax
        FROM JAQA400 a
       WHERE a.JAQA400EMP = v_Pgcod
         AND a.JAQA400MOD = v_Scmod
         AND a.JAQA400SUC = v_Scsuc
         AND a.JAQA400MDA = v_Scmda
         AND a.jaqa400pap = v_Scpap
         AND a.JAQA400CTA = v_Sccta
         AND a.JAQA400OPE = v_Scoper
         AND a.JAQA400SBO = v_Scsbop
         AND a.JAQA400TOP = v_Sctope;
    Exception
      when others then
        null;
    End;
  
    Begin
      SELECT trim(a.jaqa400uss), a.jaqa400fec
        into asesor, fecIngreso
        FROM JAQA400 a
       WHERE a.JAQA400EMP = v_Pgcod
         AND a.JAQA400MOD = v_Scmod
         AND a.JAQA400SUC = v_Scsuc
         AND a.JAQA400MDA = v_Scmda
         AND a.jaqa400pap = v_Scpap
         AND a.JAQA400CTA = v_Sccta
         AND a.JAQA400OPE = v_Scoper
         AND a.JAQA400SBO = v_Scsbop
         AND a.JAQA400TOP = v_Sctope
         AND a.jaqa400fec = fecMax;
    Exception
      when others then
        null;
    End;
  
  END;

  PROCEDURE sp_datos_opinion(instancia    number,
                             nivelPerfil  out number,
                             flgExiste    out varchar2,
                             UsuarioDeriv out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_datos_opinion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca los datos de la opinion
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    FechaHoy DATE;
  BEGIN
    --06/12/2023
    BEGIN
      SELECT PGFAPE INTO FechaHoy FROM FST017 WHERE PGCOD = 1; --06/12/2023
    EXCEPTION
      WHEN OTHERS THEN
        FechaHoy := TO_DATE(SYSDATE, 'dd/mm/yyyy');
    END;
    --  
    flgExiste := 'N';
    BEGIN
      SELECT A.AQPC818NIVEL,
             'S',
             /*(CASE A.AQPC818NIVEL 18112024
               WHEN 1 THEN
                A.AQPC818USUREG
               WHEN 2 THEN
                A.AQPC818GRAGE
               WHEN 3 THEN
                A.AQPC818ANSERIG
               ELSE
                A.AQPC818USRDER
             END)*/
              A.AQPC818USRDER
              AS AnaliDerivado
        INTO nivelPerfil, flgExiste, UsuarioDeriv
        FROM AQPC818 A
       WHERE A.AQPC818CODOPI =
             (SELECT (MAX(B.AQPC818CODOPI))
                FROM AQPC818 B
               WHERE B.AQPC818INSTAN = instancia
                 AND B.AQPC818ESTAD = 'H')
         AND A.AQPC818INSTAN = instancia
         AND A.AQPC818AUX3 = FechaHoy --06/12/2023
         AND A.AQPC818ESTAD = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        nivelPerfil  := 0; --14/12/2023
        flgExiste    := 'N';
        UsuarioDeriv := '';
    END;
  END;

  PROCEDURE sp_datos_reconsideracion(instancia     number,
                                     nroreconsider out number,
                                     estdOpini     out varchar2,
                                     p_nivelAproba out number,
                                     p_flg         out varchar2) is
    --07112023
    -- *****************************************************************
    -- Nombre                     : sp_datos_reconsideracion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Busca los datos de la reconsideracion
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************  
    FechaHoy     DATE;
    v_codOpinion number(10);
    v_maxCorrEst number(5);
    v_estd801    varchar2(2);
  BEGIN
    --06/12/2023
    BEGIN
      SELECT PGFAPE INTO FechaHoy FROM FST017 WHERE PGCOD = 1; --06/12/2023
    EXCEPTION
      WHEN OTHERS THEN
        FechaHoy := TO_DATE(SYSDATE, 'dd/mm/yyyy');
    END;
    --  
  
    BEGIN
      SELECT W.AQPC818NRECONS,
             W.AQPC818ESTOP,
             w.AQPC818NIVEL,
             w.aqpc818codopi
        INTO nroreconsider, estdOpini, p_nivelAproba, v_codOpinion
        FROM AQPC818 W
       WHERE W.AQPC818CODOPI =
             (SELECT (MAX(B.AQPC818CODOPI))
                FROM AQPC818 B
               WHERE B.AQPC818INSTAN = instancia
                 AND B.AQPC818ESTAD = 'H')
         AND W.AQPC818INSTAN = instancia
         AND W.AQPC818AUX3 = FechaHoy --06/12/2023
         AND W.AQPC818ESTAD = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        nroreconsider := 0;
        estdOpini     := '';
    END;
    p_nivelAproba := nvl(p_nivelAproba, 0);
    v_codOpinion  := nvl(v_codOpinion, 0);
  
    --validar si existe R en aqpc801 para no insertar nuevamente R 21022024
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

  PROCEDURE sp_val_solic_terminado(instancia number,
                                   tipoFlujo number,
                                   fechaHoy  date,
                                   codRpta   out varchar2) IS
    -- *****************************************************************
    -- Nombre                     : sp_val_solic_terminado
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.12.07
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Valida si la solicitud está terminada
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************     
    ln_habilTerm number(1);
    FlgRpta      VARCHAR2(1);
  BEGIN
    BEGIN
      select tp1nro3
        into ln_habilTerm
        from fst198
       Where tp1cod = 1
         and tp1cod1 = 11152
         and tp1corr1 = 53
         and tp1corr2 = 3
         and tp1corr3 > 0;
    EXCEPTION
      WHEN OTHERS THEN
        ln_habilTerm := 0;
    END;
  
    codRpta := 'N';
    IF ln_habilTerm = 1 THEN
      IF tipoFlujo = 1 THEN
        --NORMAL           
      
        BEGIN
          SELECT 'S'
            INTO codRpta
            FROM AQPC156 W
           WHERE W.AQPC156CODOPI =
                 (SELECT MAX(M.AQPC156CODOPI)
                    FROM AQPC156 M
                   WHERE M.AQPC156INSTAN = instancia)
             AND W.AQPC156INSTAN = instancia
             AND W.AQPC156ESTAD = 'H'
             AND W.AQPC156ESTOP = 'T';
        EXCEPTION
          WHEN OTHERS THEN
            codRpta := 'N';
        END;
      
        BEGIN
          Pq_Cr_Repo_Opinion_Riesgos.sp_valid_dias_proce_solici_nuev(instancia,
                                                                     FlgRpta);
        EXCEPTION
          WHEN OTHERS THEN
            FlgRpta := 'N';
        END;
      
        IF FlgRpta = 'S' THEN
          codRpta := 'N';
        END IF;
      ELSE
        --CRM
        BEGIN
          SELECT 'S'
            INTO codRpta
            FROM AQPC818 K
           WHERE K.AQPC818CODOPI =
                 (SELECT MAX(A.AQPC818CODOPI)
                    FROM AQPC818 A
                   WHERE A.AQPC818INSTAN = instancia)
             AND K.AQPC818INSTAN = instancia
             AND K.AQPC818ESTAD = 'H'
             AND K.AQPC818AUX3 = fechaHoy
             AND K.AQPC818ESTOP = 'T';
        EXCEPTION
          WHEN OTHERS THEN
            codRpta := 'N';
        END;
      END IF;
    END IF;
  END;
  
  PROCEDURE sp_tipoReprogr_CRM(instancia number, p_TipoRepr out varchar2) is
  xtipoReprgCrm number(9);
  fechHoy  date;
  auxTp1desc varchar2(30);
  BEGIN
     BEGIN
      SELECT PGFAPE INTO fechHoy FROM FST017 WHERE PGCOD = 1;
     END;     
      BEGIN
         SELECT JAQA400AN1 INTO xtipoReprgCrm
        FROM jaqa400
       WHERE JAQA400EMP = 1
         AND JAQA400FEC = fechHoy
         AND JAQA400AI1 = instancia
         AND JAQA400EST in ('E', 'A');       
      EXCEPTION 
        WHEN OTHERS THEN
          xtipoReprgCrm := 0;
      END;
      
      xtipoReprgCrm := NVL(xtipoReprgCrm, 0);
      
      CASE 
        WHEN xtipoReprgCrm = 93 THEN
          p_TipoRepr := 'Reprogramación Desastre Natural Sin Capitalización';
        WHEN xtipoReprgCrm = 94 THEN
          p_TipoRepr := 'Reprogramación Cambio de Fecha Sin Capitalización'; 
        WHEN xtipoReprgCrm = 95 THEN
          p_TipoRepr := 'Normalización';
      ELSE 
          p_TipoRepr := 'Reprogramación CRM';  
      END CASE;  
      
     BEGIN
        SELECT TP1DESC INTO auxTp1desc FROM FST198 WHERE TP1COD = 1 AND TP1COD1 = 11152 AND Tp1corr1 = 201 
        AND Tp1corr2 = 1
        AND Tp1corr3 > 0
        AND TP1NRO3 = xtipoReprgCrm;
     EXCEPTION 
        WHEN OTHERS THEN   
          auxTp1desc := '';
          xtipoReprgCrm := 0;
     END;    
     
     IF auxTp1desc IS NOT NULL OR auxTp1desc <> '' THEN
        p_TipoRepr := TRIM(auxTp1desc);
     END IF;
     
                                   
  END;

end pq_cr_repo_opini_riesgos_CRM;
/

