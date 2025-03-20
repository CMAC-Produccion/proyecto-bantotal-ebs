CREATE OR REPLACE PACKAGE pq_ar_facturacion_e IS

  -- *******************************************************************
  -- Nombre                    : PAQUETES FACTURACION ELECTRONICA
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : Genera Facturas Eletronicas
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- *******************************************************************

  vg_ejecucion number;
  vg_cant_comp NUMBER := 20;
  vv_url_http  VARCHAR2(250);
  ve_exc   EXCEPTION;
  ve_exc_2 EXCEPTION;
  vn_count          NUMBER;
  req               utl_http.req := NULL;
  resp              utl_http.resp := NULL;
  respval           VARCHAR2(32760);
  reqxml_0          VARCHAR2(32760);
  reqxml_1          VARCHAR2(32760);
  reqxml_2          VARCHAR2(32760);
  reqxml_3          VARCHAR2(32760);
  reqxml_4          VARCHAR2(32760);
  gc_clob           CLOB;
  gc_clob1          CLOB;
  vv_status_host    VARCHAR2(100);
  vv_message        VARCHAR2(250);
  vn_xml_id         NUMBER;
  gn_request_id     NUMBER; --:= apps.fnd_global.conc_request_id;  --CVEAS
  gn_trx_id         NUMBER;
  gn_numero_comp    NUMBER;
  gv_serial_comp    aqpa471.aqpa460seri%TYPE;
  pn_request_id_xml NUMBER := 0;
  gn_trx_id_nuevo   NUMBER;
  --jcshaloom
  vg_serie VARCHAR2(50);
  vg_nro   NUMBER;

  vn_id_log NUMBER;

  PROCEDURE PR_JC_INSERTAR_LOG(pv_metodo varchar2,pn_id_log out number,pn_trxid number);

  PROCEDURE PR_JC_ACTUALIZAR_LOG(pn_id_log varchar2);

  PROCEDURE pr_ar_proceso_ws(pc_proceso   IN VARCHAR2
                            ,pc_status_of IN VARCHAR2
                            ,pn_trx_id    NUMBER);

  --function fu_ping(server varchar2) return varchar2;

  FUNCTION fn_ar_env_procs_ws(pc_proceso VARCHAR2
                             ,
                              --pn_certificate_id number,
                              pn_trx_id    NUMBER
                             ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN;

  FUNCTION fn_ar_confirmar_status_ws(pc_proceso   VARCHAR2
                                    ,pn_trx_id    NUMBER
                                    ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN;
  FUNCTION fn_ar_env_status_ws(pc_proceso   VARCHAR2
                              ,pn_trx_id    NUMBER
                              ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN;

  PROCEDURE pr_ar_data_ws(pc_proceso IN VARCHAR2
                         ,pn_trx_id  NUMBER
                         ,vc_date    IN VARCHAR2
                         ,pc_mensaje OUT VARCHAR2);

  PROCEDURE pr_ar_xml_ws(pc_tipo    IN VARCHAR2
                        ,pc_proceso IN VARCHAR2
                        ,pn_trx_id  IN NUMBER
                        ,pc_xml     IN CLOB
                        ,pc_obs     IN VARCHAR2);

  --function fu_get_val_ref_cia(p_value apps.fnd_flex_values_vl.flex_value%type) return varchar2;

  PROCEDURE pr_ar_data_ws_sunat(pc_proceso        IN VARCHAR2
                               ,vc_date           IN VARCHAR2
                               ,pv_respuesta      OUT VARCHAR2
                               ,pv_desc_respuesta OUT VARCHAR2);
  --
  FUNCTION fn_ar_obtener_xml_ws(pc_proceso   VARCHAR2
                               ,pn_trx_id    NUMBER
                               ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN;

  PROCEDURE pr_ar_data_ws_xml(pc_proceso IN VARCHAR2
                             ,vc_date    IN CLOB
                              --,pv_codigo_error out varchar2
                             ,pv_nombre_xml  OUT VARCHAR2
                             ,pv_archivo_xml OUT CLOB
                              --
                             ,pv_desc_error_consulta OUT VARCHAR2
                              
                              --
                              );

  FUNCTION fn_ar_obtener_pdf_ws(pc_proceso   VARCHAR2
                               ,pn_trx_id    NUMBER
                               ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN;

  PROCEDURE pr_ar_data_ws_pdf(pc_proceso IN VARCHAR2
                             ,vc_date    IN CLOB
                              --,pv_codigo_error out varchar2
                             ,pv_nombre_pdf  OUT VARCHAR2
                             ,pv_archivo_pdf OUT CLOB
                              --
                             ,pv_desc_error_consulta OUT VARCHAR2);

  FUNCTION fn_ar_consultarestadocomp_ws(pc_proceso   VARCHAR2
                                       ,pn_trx_id    NUMBER
                                       ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN;

  PROCEDURE pr_ar_consultarestadocomp_ws(pc_proceso             IN VARCHAR2
                                        ,vc_respval             IN VARCHAR2
                                        ,pv_respuesta           OUT VARCHAR2
                                        ,pv_descripcion         OUT VARCHAR2
                                        ,pv_tipocomprobante     OUT VARCHAR2
                                        ,pv_serie               OUT VARCHAR2
                                        ,pv_numero              OUT VARCHAR2
                                        ,pv_idcomprobanteemisor OUT VARCHAR2
                                        ,pv_activootorgado      OUT VARCHAR2
                                        ,pv_fechaotorgado       OUT VARCHAR2
                                        ,pv_fechaleido          OUT VARCHAR2
                                        ,pv_activoleido         OUT VARCHAR2
                                        ,pv_fecharechazo        OUT VARCHAR2
                                        ,pv_activorechazo       OUT VARCHAR2
                                        ,pv_motivorechazo       OUT VARCHAR2);

  FUNCTION fn_ar_confirmarestadocomp_ws(pc_proceso   VARCHAR2
                                       ,pn_trx_id    NUMBER
                                       ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN;

  PROCEDURE pr_ar_confirmarestadocomp_ws(pc_proceso IN VARCHAR2
                                        ,vc_respval IN VARCHAR2
                                        ,
                                         --pv_ENRespuestaConfirmacion out varchar2,
                                         pv_respuesta   OUT VARCHAR2
                                        ,pv_descripcion OUT VARCHAR2
                                         
                                         );

  FUNCTION fn_ar_consrespcomp(pc_proceso   VARCHAR2
                             ,pn_trx_id    NUMBER
                             ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN;

  PROCEDURE pr_ar_consultarrespcomprobante(pc_proceso              IN VARCHAR2
                                          ,vc_respval              IN VARCHAR2
                                          ,pv_codigoresultado      OUT VARCHAR2
                                          ,pv_descripcion          OUT VARCHAR2
                                          ,pv_tipocomprobante      OUT VARCHAR2
                                          ,pv_serie                OUT VARCHAR2
                                          ,pv_numero               OUT VARCHAR2
                                          ,pv_idcomprobantecliente OUT VARCHAR2
                                          ,pv_codigorespuesta      OUT VARCHAR2
                                          ,pv_descripcionrespuesta OUT VARCHAR2
                                          ,pv_fecharespuesta       OUT VARCHAR2
                                          ,pv_detallerespuesta     OUT VARCHAR
                                           --pv_ListaError           out varchar2
                                           
                                           );

  FUNCTION fn_ar_confrespcomp(pc_proceso   VARCHAR2
                             ,pn_trx_id    NUMBER
                             ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN;

  PROCEDURE pr_ar_confirmarrespcomprobante(pc_proceso          IN VARCHAR2
                                          ,vc_respval          IN VARCHAR2
                                          ,pv_codigoresultado  OUT VARCHAR2
                                          ,pv_descripcion      OUT VARCHAR2
                                          ,pv_tipocomprobante  OUT VARCHAR2
                                          ,pv_serie            OUT VARCHAR2
                                          ,pv_numero           OUT VARCHAR2
                                          ,pv_descripcionerror OUT VARCHAR2
                                           
                                           );

  FUNCTION fn_ar_clob_to_blob_base64(p_clob_in IN CLOB) RETURN BLOB;

  FUNCTION fn_ar_get_url_http(pv_type VARCHAR2) RETURN VARCHAR2;

  PROCEDURE pr_ar_verifica_proceso(errbuf  OUT VARCHAR2
                                  ,retcode OUT VARCHAR2);

  FUNCTION fn_ar_actu_esta_tci_masivo RETURN BOOLEAN;
  FUNCTION fn_ar_inserta_data RETURN BOOLEAN;
  FUNCTION fn_ar_elimina_data RETURN BOOLEAN;
  FUNCTION fn_ar_envio_tci_masivo RETURN BOOLEAN;
  PROCEDURE pr_ar_refresh_ede(pn_trx_id aqpa471.aqpa471trxid%TYPE);

  PROCEDURE pr_ar_upd_status_ede(pn_trx_id         aqpa471.aqpa471trxid%TYPE
                                ,pc_source         aqpa471.aqpa471source%TYPE
                                ,pc_status_of      aqpa471.aqpa471status%TYPE
                                ,pc_status_of_desc aqpa471.aqpa471statusd%TYPE);

  PROCEDURE pr_ar_main(pn_serie aqpa471.aqpa460seri%TYPE
                      ,pn_nro   aqpa471.aqpa460num%TYPE
                       --
                      ,pv_flag_error  OUT VARCHAR2
                      ,pv_error       OUT VARCHAR2
                      ,pv_codigo_hash OUT VARCHAR2
                       --                       
                       );

  PROCEDURE pr_ar_get_xml_pdf(pn_serie aqpa471.aqpa460seri%TYPE
                             ,pn_nro   aqpa471.aqpa460num%TYPE);

  PROCEDURE pr_ar_get_masivo_xml_pdf;

  PROCEDURE pr_ar_actu_esta_tci(pn_trxid IN NUMBER);

  PROCEDURE pr_ar_log_bt(vv_line VARCHAR2);

END pq_ar_facturacion_e;
/

CREATE OR REPLACE PACKAGE BODY pq_ar_facturacion_e IS

  -- *******************************************************************
  -- Nombre                    : PAQUETE FACTURACION ELECTRONICA
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  --
  --
  --
  -- *******************************************************************

  PROCEDURE pr_ar_proceso_ws(pc_proceso   IN VARCHAR2
                            ,pc_status_of IN VARCHAR2
                            ,pn_trx_id    NUMBER) IS
    vb_resultado BOOLEAN;
    pc_resultado VARCHAR2(3000);
  BEGIN
    -- Call te function
    vb_resultado := fn_ar_env_procs_ws(pc_proceso, pn_trx_id, pc_resultado);
  
    COMMIT;
  
  END;

  PROCEDURE PR_JC_INSERTAR_LOG(pv_metodo varchar2,pn_id_log out number,pn_trxid number) AS

  BEGIN

   /*pn_id_log := JC_ID_LOG_S.nextval;

    INSERT INTO JC_LOG_METODO
      (ID_LOG, METODO, INICIO,TRXID)
    VALUES
      (pn_id_log,pv_metodo,SYSDATE,pn_trxid);

    COMMIT;*/

    null;    

  END;

  PROCEDURE PR_JC_ACTUALIZAR_LOG(pn_id_log varchar2) AS

  BEGIN

    null;

  /*UPDATE JC_LOG_METODO SET FIN = SYSDATE WHERE ID_LOG = pn_id_log;

  COMMIT;*/

  END;

  -- *******************************************************************
  -- Nombre                    : FUNCION PARA ENVIAR PROCESOS WEBSERVICE
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : Envia Procesos a WebService
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- ******************************************************************* 

  FUNCTION fn_ar_env_procs_ws(pc_proceso VARCHAR2
                              -- ,pn_certificate_id number
                             ,pn_trx_id    NUMBER
                             ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN IS
  
    /* fu_send_procesos_ws(pc_proceso        varchar2
                                  ,pn_certificate_id number
                                  ,pc_resultado      in out varchar2) return boolean is
    */
    --
    vv_multi VARCHAR2(500);
    vn_prox  NUMBER;
    vn_prox2 NUMBER;
    vv_linea VARCHAR2(500);
    --  
    vv_aqpa460tcomf    aqpa471.aqpa460tcomf%TYPE;
    vv_error_detalle   VARCHAR2(1500);
    vv_error_corto     VARCHAR2(1500);
    vv_serial_comp     aqpa471.aqpa460seri%TYPE;
    vn_numero_comp     aqpa471.aqpa460num%TYPE;
    vv_tipocomprobante VARCHAR2(2);
    CURSOR c_main IS
      SELECT
      -- Datos generales antes de las lineas 
       a.aqpa471trxid
      ,a.aqpa460nruc   AS ruc
      ,a.aqpa460rasoc  AS razonsocial
      ,a.aqpa460seri   AS serie
      ,a.aqpa460num    AS numero
      ,a.aqpa460femi   AS fechaemision
      ,a.aqpa460hemi   AS horaemision
      ,a.aqpa460impt   AS importetotal
      ,a.aqpa460tcomf  AS tipocomprobante
      ,a.aqpa460mglo   AS glosa
      ,a.aqpa460tdocr  AS tipodocumentoidentidad
      ,a.aqpa460mone   AS moneda
      ,a.aqpa460mtimp  AS totalimpuesto
      ,a.aqpa471siemco AS versionubl
      ,a.aqpa460tope   AS tipooperacion
       
       -- Datos generales despues de las lineas
      ,a.aqpa460corrr  AS correoelectronico
      ,a.aqpa460impt   AS base
      ,a.aqpa460impt   AS total
      ,a.aqpa460mtimp  AS valorimpuesto
      ,a.aqpa460pcima  AS porcentaje
      ,a.aqpa460rucc   AS ruc2
      ,a.aqpa460rsoc   AS razonsocial2
      ,a.aqpa460cdis   AS coddistrito
      ,a.aqpa460cpais  AS codpais
      ,NULL            AS codigoestablecimientosunat
      ,NULL            AS otipocomprobante
      ,NULL            AS tipocodigo
      ,a.aqpa471idcocl AS idcomprobantecliente
      ,NULL            AS otorgar
       -- Campos a nivel de Lineas
      ,b.aqpa460csuna AS codigo
      ,b.aqpa460item  AS item
      ,b.aqpa460cantf AS cantidad
      ,b.aqpa460total AS total2
      ,b.aqpa460desc  AS descripcion
      ,b.aqpa460vvun  AS valorventaunitario
      ,b.aqpa460pnetu AS unidadcomercial
      ,b.aqpa460vvuig AS valorventaunitarioincigv
      ,b.aqpa460ctpr  AS codigotipoprecio
      ,b.aqpa460dete  AS determinante
      ,b.aqpa460imptb AS impuestototal
      ,b.aqpa460ititm AS importetributo
      ,b.aqpa460codun AS codigoun
      ,b.aqpa460dstrb AS destributo
      ,b.aqpa460codtb AS codigotributo
      ,b.aqpa460afigv AS afectacionigv
      ,b.aqpa460mbim  AS montobase
      ,NULL           AS codigoproductosunat
      ,NULL           AS tasaaplicada
       --
      ,b.aqpa460dete
      ,b.aqpa460ctpr
      ,b.aqpa460vvun
      ,b.aqpa460vvuig
      ,b.aqpa460desc
      ,b.aqpa460mfun
      ,b.aqpa460prvit
      ,b.aqpa460medem
      ,b.aqpa460csuna
      ,b.aqpa460cpgs1
      ,b.aqpa460ititm
      ,b.aqpa460imptb
      ,b.aqpa460impex
      ,b.aqpa460afigv
      ,b.aqpa460sisc
      ,b.aqpa460codtb
      ,b.aqpa460dstrb
      ,b.aqpa460codun
      ,b.aqpa460mbim
      ,b.aqpa460taimp
      ,b.aqpa460vpcva
      ,b.aqpa460nexp
      ,b.aqpa460cind
      ,b.aqpa460npart
      ,replace(b.aqpa460ncont,'-','') aqpa460ncont
      ,to_char(b.aqpa460fotrc, 'YYYY-MM-DD') AS aqpa460fotrc
      ,b.aqpa460cdisn
      ,b.aqpa460direh
      ,b.aqpa460urbh
      ,b.aqpa460prvh
      ,b.aqpa460dsth
      ,b.aqpa460depth
      ,b.aqpa460item
      ,b.aqpa460pnetu
      ,b.aqpa460cantf
      ,b.aqpa460total
       --
      ,a.aqpa460cdley
      ,a.aqpa460teley
      ,a.aqpa460text1
      ,a.aqpa460text2
      ,a.aqpa460trecv
      ,a.aqpa460templ
      ,a.aqpa460subje
      ,a.aqpa460mtotal
      ,a.aqpa460baimp
      ,a.aqpa460mtimp
      ,a.aqpa460pcima
      ,a.aqpa460bsimp
      ,a.aqpa460vaimp
      ,a.aqpa460mtinf
      ,a.aqpa460mtgrt
      ,a.aqpa460bsimps
      ,a.aqpa460mtoti
      ,a.aqpa460tdoc
      ,a.aqpa460rucc
      ,a.aqpa460rsoc
      ,a.aqpa460cdis
      ,a.aqpa460ncom
      ,a.aqpa460calle
      ,a.aqpa460urba
      ,a.aqpa460depa
      ,a.aqpa460prov
      ,a.aqpa460dist
      ,a.aqpa460telf
      ,a.aqpa460web
      ,a.aqpa460cpais
      ,a.aqpa460cesun
      ,a.aqpa460seri
      ,a.aqpa460num
       --
      ,to_char(a.aqpa460femi, 'YYYY-MM-DD') AS aqpa460femi
       --
      ,lpad(a.aqpa460tcomf, 2, '0') AS aqpa460tcomf
      ,a.aqpa460mone
      ,a.aqpa460corrr
      ,a.aqpa460mglo
      ,a.aqpa460coma
      ,a.aqpa460tpla
      ,a.aqpa460tope
      ,a.aqpa460tplco
      ,a.aqpa460clog
      ,a.aqpa460tdocr
      ,a.aqpa460nruc
      ,a.aqpa460rasoc
      ,a.aqpa460impt
      ,a.aqpa460hemi
      ,a.aqpa460simc
      ,a.aqpa460svitm
      ,a.aqpa460spvi
      ,a.aqpa460txml
      ,a.aqpa460cdist
      ,a.aqpa460call
      ,a.aqpa460urb
      ,a.aqpa460dep
      ,a.aqpa460prv
      ,a.aqpa460dst
      ,a.aqpa460cpai
       --
      ,a.aqpa460sdref
      ,a.aqpa460ndref
      ,a.aqpa460sust
      ,a.aqpa460cmem
      ,a.aqpa460serie
      ,a.aqpa460nro
      ,a.aqpa460tcomp
       --,to_char(a.AQPA460FDREF, 'YYYY-MM-DD') as AQPA460FDREF
      ,to_char(to_date(a.aqpa460fdref, 'DD-MM-YY'), 'YYYY-MM-DD') AS aqpa460fdref
       --
       --Columnas Nuevas
      ,b.aqpa460glos
      ,b.aqpa460tipag
      ,b.aqpa460text3
      ,b.aqpa460text4
      
        FROM aqpa471 a
            ,aqpa460 b
       WHERE 1 = 1
         AND a.aqpa460seri = b.aqpa460seri
         AND a.aqpa460num = b.aqpa460num
         AND a.aqpa471trxid = pn_trx_id
       ORDER BY b.aqpa460item ASC;
  
    vc_total_import_letras VARCHAR2(3000);
    vn_valor_tot           NUMBER;
    vc_invoice_serial      VARCHAR2(50);
    vc_invoice_numero      VARCHAR2(50);
    vc_mensaje             VARCHAR2(3000);
  
    vc_mail_cct_cia VARCHAR2(240);
    vc_rs_cia       VARCHAR2(240);
    vc_tel_cia      VARCHAR2(240);
    vc_web_cia      VARCHAR2(240);
    vc_ubig_cia     VARCHAR2(240);
    vc_urb_cia      VARCHAR2(240);
    vc_prov_cia     VARCHAR2(240);
    vc_dep_cia      VARCHAR2(240);
    vc_dist_cia     VARCHAR2(240);
    vv_aqpa460codtb aqpa460.aqpa460codtb%TYPE;
    vv_gravado      VARCHAR2(1);
  BEGIN
    --bv 26/12/2018
    pr_ar_log_bt('1');
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
  
    vn_count := 0;
    --bv 26/12/2018
    pr_ar_log_bt('2');
    -- Obtiene el url del servidor web
    vv_url_http := fn_ar_get_url_http(pc_proceso);
    --bv 26/12/2018
    pr_ar_log_bt('3');
    vv_status_host := 'OK';
  
    reqxml_0 := '';
    reqxml_1 := '';
    reqxml_2 := '';
    reqxml_3 := '';
    reqxml_4 := '';
  
    SELECT lpad(TRIM(aqpa460tcomf), 2, '0')
      INTO vv_aqpa460tcomf
      FROM aqpa471 h
     WHERE h.aqpa471trxid = pn_trx_id;
  
    IF (vv_aqpa460tcomf = '01') THEN
    
      -- Factura
      --
      vv_gravado := 'N';
      --bv 26/12/2018
      pr_ar_log_bt('4');
      FOR x IN c_main LOOP
      
        BEGIN
          SELECT DISTINCT l.aqpa460codtb
            INTO vv_aqpa460codtb
            FROM aqpa460 l
           WHERE l.aqpa460seri = x.aqpa460seri
             AND l.aqpa460num = x.aqpa460num;
        EXCEPTION
          WHEN OTHERS THEN
            vv_aqpa460codtb := NULL;
        END;
      
        IF vn_count = 0 THEN
        
          ---------------------------------------------
          -- Informacion a nivel CABECERA, solo una vez
          ---------------------------------------------
          -- 21
          reqxml_0 := reqxml_0 || '<?xml version="1.0" encoding="UTF-8"?>';
          reqxml_0 := reqxml_0 || chr(10) ||
                      '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
          reqxml_0 := reqxml_0 || chr(10) ||
                      '   <soap12:Body xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
          reqxml_0 := reqxml_0 || chr(10) || '      <Registrar xmlns="http://tempuri.org/">';
          reqxml_0 := reqxml_0 || chr(10) || '         <oGeneral>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '            <oENEmpresa>';
          reqxml_0 := reqxml_0 || chr(10) || '               <CodigoTipoDocumento>' || x.aqpa460tdoc ||
                      '</CodigoTipoDocumento>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Ruc>' || x.aqpa460rucc || '</Ruc>';
          reqxml_0 := reqxml_0 || chr(10) || '               <RazonSocial>' || x.aqpa460rsoc || '</RazonSocial>';
          reqxml_0 := reqxml_0 || chr(10) || '               <CodDistrito>' || x.aqpa460cdis || '</CodDistrito>';
          IF (x.aqpa460ncom IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <NombreComercial>' || x.aqpa460ncom ||
                        '</NombreComercial>';
          END IF;
          IF (x.aqpa460calle IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Calle>' || x.aqpa460calle || '</Calle>';
          END IF;
          IF (x.aqpa460urba IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Urbanizacion>' || x.aqpa460urba || '</Urbanizacion>';
          END IF;
          IF (x.aqpa460depa IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Departamento>' || x.aqpa460depa || '</Departamento>';
          END IF;
          IF (x.aqpa460prov IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Provincia>' || x.aqpa460prov || '</Provincia>';
          END IF;
          IF (x.aqpa460dist IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Distrito>' || x.aqpa460dist || '</Distrito>';
          END IF;
          IF (x.aqpa460telf IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Telefono>' || x.aqpa460telf || '</Telefono>';
          END IF;
          IF (x.aqpa460web IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Web>' || x.aqpa460web || '</Web>';
          END IF;
          IF (x.aqpa460cpais IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <CodPais>' || x.aqpa460cpais || '</CodPais>';
          END IF;
          reqxml_0 := reqxml_0 || chr(10) || '               <CodigoEstablecimientoSUNAT>' || x.aqpa460cesun ||
                      '</CodigoEstablecimientoSUNAT>';
          reqxml_0 := reqxml_0 || chr(10) || '            </oENEmpresa>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '            <oENComprobante>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Serie>' || x.aqpa460seri || '</Serie>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Numero>' || x.aqpa460num || '</Numero>';
          reqxml_0 := reqxml_0 || chr(10) || '               <FechaEmision>' || x.aqpa460femi || '</FechaEmision>';
          reqxml_0 := reqxml_0 || chr(10) || '               <TipoComprobante>' || x.aqpa460tcomf ||
                      '</TipoComprobante>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Moneda>' || x.aqpa460mone || '</Moneda>';
          IF (x.aqpa460corrr IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <CorreoElectronico>' || x.aqpa460corrr ||
                        '</CorreoElectronico>';
          END IF;
        
          IF (x.glosa IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Glosa>' || x.glosa || '</Glosa>';
          END IF;
        
          IF (x.aqpa460mglo IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Multiglosa>';
            reqxml_0 := reqxml_0 || chr(10) || '               <string>' || x.aqpa460mglo || '</string>';
            reqxml_0 := reqxml_0 || chr(10) || '               </Multiglosa>';
          END IF;
        
          IF (x.aqpa460tipag IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TipoPago>' || x.aqpa460tipag || '</TipoPago>';
          END IF;
        
          IF (x.aqpa460coma IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <ComprobanteAlias>' || x.aqpa460coma ||
                        '</ComprobanteAlias>';
          END IF;
          IF (x.aqpa460tpla IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TipoPlantilla>' || x.aqpa460tpla ||
                        '</TipoPlantilla>';
          END IF;
          reqxml_0 := reqxml_0 || chr(10) || '               <TipoOperacion>' || x.aqpa460tope || '</TipoOperacion>';
          IF (x.aqpa460tplco IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TipoPlantillaCorreo>' || x.aqpa460tplco ||
                        '</TipoPlantillaCorreo>';
          END IF;
          IF (x.aqpa460clog IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <CodigoLogo>' || x.aqpa460clog || '</CodigoLogo>';
          END IF;
          reqxml_0 := reqxml_0 || chr(10) || '               <TipoDocumentoIdentidad>' || x.aqpa460tdocr ||
                      '</TipoDocumentoIdentidad>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Ruc>' || x.aqpa460nruc || '</Ruc>';
          reqxml_0 := reqxml_0 || chr(10) || '               <RazonSocial>' || x.aqpa460rasoc || '</RazonSocial>';
          reqxml_0 := reqxml_0 || chr(10) || '               <ImporteTotal>' || x.aqpa460impt || '</ImporteTotal>';
          reqxml_0 := reqxml_0 || chr(10) || '               <HoraEmision>' || x.aqpa460hemi || '</HoraEmision>';
          IF (x.aqpa460simc IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TotalImpuesto>' || x.aqpa460simc ||
                        '</TotalImpuesto>';
          END IF;
          IF (x.aqpa460svitm <> 0) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TotalValorVenta>' || x.aqpa460svitm ||
                        '</TotalValorVenta>';
          END IF;
          IF (x.aqpa460spvi <> 0) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TotalPrecioVenta>' || x.aqpa460spvi ||
                        '</TotalPrecioVenta>';
          END IF;
          IF (x.aqpa460txml IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <VersionUbl>' || x.aqpa460txml || '</VersionUbl>';
          END IF;
          --
          reqxml_0 := reqxml_0 || chr(10) || '               <Receptor>';
          reqxml_0 := reqxml_0 || chr(10) || '               <ENReceptor>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <CodDistrito>' || x.aqpa460cdist || '</CodDistrito>';
          -- cveas modificar
          reqxml_0 := reqxml_0 || chr(10) || '                 <Ubigeo>' || x.aqpa460cdis || '</Ubigeo>';
          -- cveas
          reqxml_0 := reqxml_0 || chr(10) || '                 <Calle>' || x.aqpa460call || '</Calle>';
          IF (x.aqpa460urb IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '                 <Urbanizacion>' || x.aqpa460urb ||
                        '</Urbanizacion>';
          END IF;
          reqxml_0 := reqxml_0 || chr(10) || '                 <Departamento>' || x.aqpa460dep || '</Departamento>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <Provincia>' || x.aqpa460prv || '</Provincia>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <Distrito>' || x.aqpa460dst || '</Distrito>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <CodPais>' || x.aqpa460cpai || '</CodPais>';
          reqxml_0 := reqxml_0 || chr(10) || '               </ENReceptor>';
          reqxml_0 := reqxml_0 || chr(10) || '               </Receptor>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '               <ComprobanteDetalle>';
          --
          vn_count := 1;
        
        END IF;
      
        -----------------------------
        -- Informacion a nivel LINEAS
        -----------------------------
        -- 25
        reqxml_3 := reqxml_3 || chr(10) || '                  <ENComprobanteDetalle>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Item>' || x.aqpa460item || '</Item>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <UnidadComercial>' || x.aqpa460pnetu ||
                    '</UnidadComercial>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Cantidad>' || x.aqpa460cantf || '</Cantidad>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Total>' || x.aqpa460total || '</Total>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Determinante>' || x.aqpa460dete ||
                    '</Determinante>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <CodigoTipoPrecio>' || x.aqpa460ctpr ||
                    '</CodigoTipoPrecio>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <ValorVentaUnitario>' || x.aqpa460vvun ||
                    '</ValorVentaUnitario>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <ValorVentaUnitarioIncIgv>' || x.aqpa460vvuig ||
                    '</ValorVentaUnitarioIncIgv>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Descripcion>' || x.aqpa460desc || '</Descripcion>';
        IF (x.aqpa460mfun IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                     <MultiDescripcion>';
          -- loop para separar las lineas
          vv_multi := x.aqpa460mfun;
          LOOP
            vn_prox  := nvl(instr(vv_multi, '|'), 0);
            vn_prox2 := nvl(instr(vv_multi, '|'), 0);
            IF (vn_prox = 0) THEN
              vn_prox := 500;
            END IF;
            vv_linea := substr(vv_multi, 1, vn_prox - 1);
            vv_multi := substr(vv_multi, vn_prox + 1, 500);
            IF (vv_linea IS NOT NULL) THEN
              reqxml_3 := reqxml_3 || chr(10) || '                       <string>' || vv_linea || '</string>';
            END IF;
            EXIT WHEN vn_prox2 = 0;
          END LOOP;
          --
          reqxml_3 := reqxml_3 || chr(10) || '                     </MultiDescripcion>';
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                     <PrecioVentaItem>' || x.aqpa460prvit ||
                    '</PrecioVentaItem>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <UnidadMedidaEmisor>' || x.aqpa460medem ||
                    '</UnidadMedidaEmisor>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <CodigoProductoSunat>' || x.aqpa460csuna ||
                    '</CodigoProductoSunat>';
        IF (x.aqpa460cpgs1 IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                     <CodigoProductoGS1>' || x.aqpa460cpgs1 ||
                      '</CodigoProductoGS1>';
        END IF;
        IF (x.aqpa460ititm IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                     <ImpuestoTotal>' || x.aqpa460ititm ||
                      '</ImpuestoTotal>';
        END IF;
      
        -- cveas modificar
      
        -- reqxml_3 := reqxml_3 || chr(10) || '                     <EstructuraGTIN>' || x.EstructuraGTIN || '</EstructuraGTIN>';
        -- cveas
      
        reqxml_3 := reqxml_3 || chr(10) || '                     <ComprobanteDetalleImpuestos>';
        reqxml_3 := reqxml_3 || chr(10) || '                        <ENComprobanteDetalleImpuestos>';
        IF (x.aqpa460imptb IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                           <ImporteTributo>' || x.aqpa460imptb ||
                      '</ImporteTributo>';
        END IF;
        IF (FALSE) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                           <ImporteExplicito>' || x.aqpa460impex ||
                      '</ImporteExplicito>';
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                           <AfectacionIGV>' || x.aqpa460afigv ||
                    '</AfectacionIGV>';
        IF (x.aqpa460sisc IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                           <SistemaISC>' || x.aqpa460sisc ||
                      '</SistemaISC>';
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                           <CodigoTributo>' || /*'9996'*/
                    x.aqpa460codtb || '</CodigoTributo>';
        reqxml_3 := reqxml_3 || chr(10) || '                           <DesTributo>' || /*'GRA'*/
                    x.aqpa460dstrb || '</DesTributo>';
        reqxml_3 := reqxml_3 || chr(10) || '                           <CodigoUN>' || x.aqpa460codun ||
                    '</CodigoUN>';
        IF (x.aqpa460mbim IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                           <MontoBase>' || x.aqpa460mbim ||
                      '</MontoBase>';
        END IF;
        IF (x.aqpa460taimp IS NOT NULL) THEN
          IF (x.aqpa460taimp <> 0 OR x.aqpa460taimp IS NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                           <TasaAplicada>' || x.aqpa460taimp ||
                        '</TasaAplicada>';
          END IF;
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                        </ENComprobanteDetalleImpuestos>';
        reqxml_3 := reqxml_3 || chr(10) || '                     </ComprobanteDetalleImpuestos>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '                     <ENInformacionAdicional>';
        IF (x.aqpa460vpcva IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Placa>' || x.aqpa460vpcva || '</Placa>';
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                     </ENInformacionAdicional>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '                     <GastosHipotecario>';
        IF (x.aqpa460nexp IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <CodigoTipoPrestamo>' || x.aqpa460nexp ||
                      '</CodigoTipoPrestamo>';
        END IF;
        IF (x.aqpa460cind IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <CodigoIndicador>' || x.aqpa460cind ||
                      '</CodigoIndicador>';
        END IF;
        IF (x.aqpa460npart IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <NumeroPartidaRegistral>' || x.aqpa460npart ||
                      '</NumeroPartidaRegistral>';
        END IF;
        IF (x.aqpa460ncont IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <NumeroContrato>' || x.aqpa460ncont ||
                      '</NumeroContrato>';
        END IF;
        IF (x.aqpa460fotrc IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <FechaOtorgaCredito>' || x.aqpa460fotrc ||
                      '</FechaOtorgaCredito>';
          reqxml_3 := reqxml_3 || chr(10) || '                       <MontoCredito>' || 1 ||
                      '</MontoCredito>';  --add jc 26082021                
        END IF;
        IF (x.aqpa460cdisn IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <CodigoUbigeo>' || x.aqpa460cdisn ||
                      '</CodigoUbigeo>';
        END IF;
        IF (x.aqpa460direh IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Direccion>' || x.aqpa460direh ||
                      '</Direccion>';
        END IF;
        IF (x.aqpa460urbh IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Urbanizacion>' || x.aqpa460urbh ||
                      '</Urbanizacion>';
        END IF;
        IF (x.aqpa460prvh IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Provincia>' || x.aqpa460prvh || '</Provincia>';
        END IF;
        IF (x.aqpa460dsth IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Distrito>' || x.aqpa460dsth || '</Distrito>';
        END IF;
        IF (x.aqpa460depth IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Departamento>' || x.aqpa460depth ||
                      '</Departamento>';
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                     </GastosHipotecario>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '                  </ENComprobanteDetalle>';
        --
      
        --
        IF (x.aqpa460dstrb = 'IGV') THEN
          vv_gravado := 'Y';
        END IF;
      
      END LOOP;
      --bv 26/12/2018
      pr_ar_log_bt('5');
      ----------------------------------------------------------
      -- Datos a nivel DOCUMENTO, debajo de la seccion de LINEAS
      ----------------------------------------------------------
      --bv 26/12/2018
      pr_ar_log_bt('6');
      FOR x IN c_main LOOP
        --
        -- 27
        reqxml_3 := reqxml_3 || chr(10) || '               </ComprobanteDetalle>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '               <ComprobantePropiedadesAdicionales>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <ENComprobantePropiedadesAdicionales>';
        reqxml_3 := reqxml_3 || chr(10) || '                   <Codigo>' || x.aqpa460cdley || '</Codigo>';
        reqxml_3 := reqxml_3 || chr(10) || '                   <Valor>' || x.aqpa460teley || '</Valor>';
        reqxml_3 := reqxml_3 || chr(10) || '                 </ENComprobantePropiedadesAdicionales>';
        reqxml_3 := reqxml_3 || chr(10) || '               </ComprobantePropiedadesAdicionales>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '               <Texto>';
        reqxml_3 := reqxml_3 || chr(10) || '               <ENTexto>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Texto1>' || x.aqpa460text1 || '</Texto1>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Texto2>' || x.aqpa460text2 || '</Texto2>';
      
        -- cveas modificar
        reqxml_3 := reqxml_3 || chr(10) || '                 <Texto3>' || x.aqpa460text3 || '</Texto3>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Texto4>' || x.aqpa460text4 || '</Texto4>';
        -- cveas
      
        reqxml_3 := reqxml_3 || chr(10) || '               </ENTexto>';
        reqxml_3 := reqxml_3 || chr(10) || '               </Texto>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '               <ENCorreoTerceros>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <ToReceive>' || x.aqpa460trecv || '</ToReceive>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Template>' || x.aqpa460templ || '</Template>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Subject>' || x.aqpa460subje || '</Subject>';
        reqxml_3 := reqxml_3 || chr(10) || '               </ENCorreoTerceros>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '               <MontosTotales>';
        IF (nvl(vv_aqpa460codtb, 'SIN_VALOR') <> '9998') THEN
          reqxml_3 := reqxml_3 || chr(10) || '                 <Gravado>';
          IF (x.aqpa460mtotal IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                   <Total>' || x.aqpa460mtotal || '</Total>';
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   <GravadoIGV>';
          IF (x.aqpa460baimp IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <Base>' || x.aqpa460baimp || '</Base>';
          END IF;
          IF (x.aqpa460mtimp IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <ValorImpuesto>' || x.aqpa460mtimp ||
                        '</ValorImpuesto>';
          END IF;
          IF (x.aqpa460pcima IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <Porcentaje>' || x.aqpa460pcima ||
                        '</Porcentaje>';
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   </GravadoIGV>';
          reqxml_3 := reqxml_3 || chr(10) || '                   <GravadoOTROS>';
          IF (x.aqpa460bsimp IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <Base>' || x.aqpa460bsimp || '</Base>';
          END IF;
          IF (x.aqpa460vaimp IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <ValorImpuesto>' || x.aqpa460vaimp ||
                        '</ValorImpuesto>';
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   </GravadoOTROS>';
          reqxml_3 := reqxml_3 || chr(10) || '                 </Gravado>';
        END IF;
        -- 31/10/2018, INI
        IF (vv_gravado = 'N') THEN
          reqxml_3 := reqxml_3 || chr(10) || '                 <Inafecto>';
          reqxml_3 := reqxml_3 || chr(10) || '                   <Total>' || x.aqpa460mtinf || '</Total>';
          reqxml_3 := reqxml_3 || chr(10) || '                 </Inafecto>';
        END IF;
        -- 31/10/2018, FIN
        IF (nvl(vv_aqpa460codtb, 'SIN_VALOR') <> '9998') THEN
          -- 31/10/2018, INI
          IF (vv_gravado = 'N') THEN
            reqxml_3 := reqxml_3 || chr(10) || '                 <Gratuito>';
            IF (x.aqpa460mtgrt IS NOT NULL) THEN
              reqxml_3 := reqxml_3 || chr(10) || '                   <Total>' || x.aqpa460mtgrt || '</Total>';
            END IF;
            reqxml_3 := reqxml_3 || chr(10) || '                   <GratuitoImpuesto>';
            IF (x.aqpa460bsimps IS NOT NULL) THEN
              reqxml_3 := reqxml_3 || chr(10) || '                     <Base>' || x.aqpa460bsimps || '</Base>';
            END IF;
            IF (x.aqpa460mtoti IS NOT NULL) THEN
              reqxml_3 := reqxml_3 || chr(10) || '                     <ValorImpuesto>' || x.aqpa460mtoti ||
                          '</ValorImpuesto>';
            END IF;
            reqxml_3 := reqxml_3 || chr(10) || '                   </GratuitoImpuesto>';
            reqxml_3 := reqxml_3 || chr(10) || '                 </Gratuito>';
          END IF;
          -- 31/10/2018, FIN
        END IF;
      
        reqxml_3 := reqxml_3 || chr(10) || '               </MontosTotales>';
        --INI ADD JC 22082021
        reqxml_3 := reqxml_3 || chr(10) || '               <FormaPagoSunat>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <TipoFormaPago>' || '1' || '</TipoFormaPago>';
        reqxml_3 := reqxml_3 || chr(10) || '               </FormaPagoSunat>';
        -- FIN JC 22082021
        --
        reqxml_3 := reqxml_3 || chr(10) || '            </oENComprobante>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '         </oGeneral>';
        reqxml_3 := reqxml_3 || chr(10) || '         <oTipoComprobante>' || 'Factura' || '</oTipoComprobante>';
        reqxml_3 := reqxml_3 || chr(10) || '         <TipoCodigo>' || '1' || '</TipoCodigo>'; -- CODIGO HASH
        reqxml_3 := reqxml_3 || chr(10) || '         <IdComprobanteCliente>' || '0' || '</IdComprobanteCliente>'; -- Cualquier valor numerico
        reqxml_3 := reqxml_3 || chr(10) || '         <Otorgar>' || '1' || '</Otorgar>'; -- AUTOMATICAMENTE
        reqxml_3 := reqxml_3 || chr(10) || '      </Registrar>';
        reqxml_3 := reqxml_3 || chr(10) || '   </soap12:Body>';
        reqxml_3 := reqxml_3 || chr(10) || '</soap12:Envelope>';
        --
        EXIT;
      END LOOP;
      --bv 26/12/2018
      pr_ar_log_bt('7');
      ------------ cveas modificar
    
    ELSIF (vv_aqpa460tcomf = '03') THEN
      -- BOLETA DE VENTA
      --
      --bv 26/12/2018
      vv_gravado := 'N'; --cveas 26072019
      pr_ar_log_bt('8');
      FOR x IN c_main LOOP
      
        BEGIN
          SELECT DISTINCT l.aqpa460codtb
            INTO vv_aqpa460codtb
            FROM aqpa460 l
           -- INI, 31/12/2018  
           WHERE l.aqpa460seri = x.aqpa460seri
             AND l.aqpa460num = x.aqpa460num
           -- FIN, 31/12/2018                         
            ;
          -- where l.certificate_id = x.AQPA471TRXID;
        EXCEPTION
          WHEN OTHERS THEN
            vv_aqpa460codtb := NULL;
        END;
      
        IF vn_count = 0 THEN
        
          ---------------------------------------------
          -- Informacion a nivel CABECERA, solo una vez
          ---------------------------------------------
          -- 21
          reqxml_0 := reqxml_0 || '<?xml version="1.0" encoding="UTF-8"?>';
          reqxml_0 := reqxml_0 || chr(10) ||
                      '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
          reqxml_0 := reqxml_0 || chr(10) ||
                      '   <soap12:Body xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
          reqxml_0 := reqxml_0 || chr(10) || '      <Registrar xmlns="http://tempuri.org/">';
          reqxml_0 := reqxml_0 || chr(10) || '         <oGeneral>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '            <oENEmpresa>';
          reqxml_0 := reqxml_0 || chr(10) || '               <CodigoTipoDocumento>' || x.aqpa460tdoc ||
                      '</CodigoTipoDocumento>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Ruc>' || x.aqpa460rucc || '</Ruc>';
          reqxml_0 := reqxml_0 || chr(10) || '               <RazonSocial>' || x.aqpa460rsoc || '</RazonSocial>';
          reqxml_0 := reqxml_0 || chr(10) || '               <CodDistrito>' || x.aqpa460cdis || '</CodDistrito>';
          IF (x.aqpa460ncom IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <NombreComercial>' || x.aqpa460ncom ||
                        '</NombreComercial>';
          END IF;
          IF (x.aqpa460calle IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Calle>' || x.aqpa460calle || '</Calle>';
          END IF;
          IF (x.aqpa460urba IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Urbanizacion>' || x.aqpa460urba || '</Urbanizacion>';
          END IF;
          IF (x.aqpa460depa IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Departamento>' || x.aqpa460depa || '</Departamento>';
          END IF;
          IF (x.aqpa460prov IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Provincia>' || x.aqpa460prov || '</Provincia>';
          END IF;
          IF (x.aqpa460dist IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Distrito>' || x.aqpa460dist || '</Distrito>';
          END IF;
          IF (x.aqpa460telf IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Telefono>' || x.aqpa460telf || '</Telefono>';
          END IF;
          IF (x.aqpa460web IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Web>' || x.aqpa460web || '</Web>';
          END IF;
          IF (x.aqpa460cpais IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <CodPais>' || x.aqpa460cpais || '</CodPais>';
          END IF;
          reqxml_0 := reqxml_0 || chr(10) || '               <CodigoEstablecimientoSUNAT>' || x.aqpa460cesun ||
                      '</CodigoEstablecimientoSUNAT>';
          reqxml_0 := reqxml_0 || chr(10) || '            </oENEmpresa>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '            <oENComprobante>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Serie>' || x.aqpa460seri || '</Serie>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Numero>' || x.aqpa460num || '</Numero>';
          reqxml_0 := reqxml_0 || chr(10) || '               <FechaEmision>' || x.aqpa460femi || '</FechaEmision>';
          reqxml_0 := reqxml_0 || chr(10) || '               <TipoComprobante>' || x.aqpa460tcomf ||
                      '</TipoComprobante>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Moneda>' || x.aqpa460mone || '</Moneda>';
          IF (x.aqpa460corrr IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <CorreoElectronico>' || x.aqpa460corrr ||
                        '</CorreoElectronico>';
          END IF;
        
          IF (x.glosa IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Glosa>' || x.glosa || '</Glosa>';
          END IF;
        
          IF (x.aqpa460mglo IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Multiglosa>';
            reqxml_0 := reqxml_0 || chr(10) || '               <string>' || x.aqpa460mglo || '</string>';
            reqxml_0 := reqxml_0 || chr(10) || '               </Multiglosa>';
          END IF;
          IF (x.aqpa460tipag IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TipoPago>' || x.aqpa460tipag || '</TipoPago>';
          END IF;
          IF (x.aqpa460coma IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <ComprobanteAlias>' || x.aqpa460coma ||
                        '</ComprobanteAlias>';
          END IF;
          IF (x.aqpa460tpla IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TipoPlantilla>' || x.aqpa460tpla ||
                        '</TipoPlantilla>';
          END IF;
          reqxml_0 := reqxml_0 || chr(10) || '               <TipoOperacion>' || x.aqpa460tope || '</TipoOperacion>';
          IF (x.aqpa460tplco IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TipoPlantillaCorreo>' || x.aqpa460tplco ||
                        '</TipoPlantillaCorreo>';
          END IF;
          IF (x.aqpa460clog IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <CodigoLogo>' || x.aqpa460clog || '</CodigoLogo>';
          END IF;
          reqxml_0 := reqxml_0 || chr(10) || '               <TipoDocumentoIdentidad>' || x.aqpa460tdocr ||
                      '</TipoDocumentoIdentidad>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Ruc>' || x.aqpa460nruc || '</Ruc>';
          reqxml_0 := reqxml_0 || chr(10) || '               <RazonSocial>' || x.aqpa460rasoc || '</RazonSocial>';
          reqxml_0 := reqxml_0 || chr(10) || '               <ImporteTotal>' || x.aqpa460impt || '</ImporteTotal>';
          reqxml_0 := reqxml_0 || chr(10) || '               <HoraEmision>' || x.aqpa460hemi || '</HoraEmision>';
          IF (x.aqpa460simc IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TotalImpuesto>' || x.aqpa460simc ||
                        '</TotalImpuesto>';
          END IF;
          IF (x.aqpa460svitm <> 0) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TotalValorVenta>' || x.aqpa460svitm ||
                        '</TotalValorVenta>';
          END IF;
          IF (x.aqpa460spvi <> 0) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TotalPrecioVenta>' || x.aqpa460spvi ||
                        '</TotalPrecioVenta>';
          END IF;
          IF (x.aqpa460txml IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <VersionUbl>' || x.aqpa460txml || '</VersionUbl>';
          END IF;
          --
          reqxml_0 := reqxml_0 || chr(10) || '               <Receptor>';
          reqxml_0 := reqxml_0 || chr(10) || '               <ENReceptor>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <CodDistrito>' || x.aqpa460cdist || '</CodDistrito>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <Ubigeo>' || x.aqpa460cdis || '</Ubigeo>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <Calle>' || x.aqpa460call || '</Calle>';
          IF (x.aqpa460urb IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '                 <Urbanizacion>' || x.aqpa460urb ||
                        '</Urbanizacion>';
          END IF;
          reqxml_0 := reqxml_0 || chr(10) || '                 <Departamento>' || x.aqpa460dep || '</Departamento>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <Provincia>' || x.aqpa460prv || '</Provincia>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <Distrito>' || x.aqpa460dst || '</Distrito>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <CodPais>' || x.aqpa460cpai || '</CodPais>';
          reqxml_0 := reqxml_0 || chr(10) || '               </ENReceptor>';
          reqxml_0 := reqxml_0 || chr(10) || '               </Receptor>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '               <ComprobanteDetalle>';
          --
          vn_count := 1;
        
        END IF;
      
        -----------------------------
        -- Informacion a nivel LINEAS
        -----------------------------
        -- 25
        reqxml_3 := reqxml_3 || chr(10) || '                  <ENComprobanteDetalle>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Item>' || x.aqpa460item || '</Item>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <UnidadComercial>' || x.aqpa460pnetu ||
                    '</UnidadComercial>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Cantidad>' || x.aqpa460cantf || '</Cantidad>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Total>' || x.aqpa460total || '</Total>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Determinante>' || x.aqpa460dete ||
                    '</Determinante>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <CodigoTipoPrecio>' || x.aqpa460ctpr ||
                    '</CodigoTipoPrecio>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <ValorVentaUnitario>' || x.aqpa460vvun ||
                    '</ValorVentaUnitario>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <ValorVentaUnitarioIncIgv>' || x.aqpa460vvuig ||
                    '</ValorVentaUnitarioIncIgv>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Descripcion>' || x.aqpa460desc || '</Descripcion>';
        IF (x.aqpa460mfun IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                     <MultiDescripcion>';
          -- loop para separar las lineas
          vv_multi := x.aqpa460mfun;
          LOOP
            vn_prox  := nvl(instr(vv_multi, '|'), 0);
            vn_prox2 := nvl(instr(vv_multi, '|'), 0);
            IF (vn_prox = 0) THEN
              vn_prox := 500;
            END IF;
            vv_linea := substr(vv_multi, 1, vn_prox - 1);
            vv_multi := substr(vv_multi, vn_prox + 1, 500);
            IF (vv_linea IS NOT NULL) THEN
              reqxml_3 := reqxml_3 || chr(10) || '                       <string>' || vv_linea || '</string>';
            END IF;
            EXIT WHEN vn_prox2 = 0;
          END LOOP;
          --
          reqxml_3 := reqxml_3 || chr(10) || '                     </MultiDescripcion>';
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                     <PrecioVentaItem>' || x.aqpa460prvit ||
                    '</PrecioVentaItem>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <UnidadMedidaEmisor>' || x.aqpa460medem ||
                    '</UnidadMedidaEmisor>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <CodigoProductoSunat>' || x.aqpa460csuna ||
                    '</CodigoProductoSunat>';
        IF (x.aqpa460cpgs1 IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                     <CodigoProductoGS1>' || x.aqpa460cpgs1 ||
                      '</CodigoProductoGS1>';
        END IF;
        IF (x.aqpa460ititm IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                     <ImpuestoTotal>' || x.aqpa460ititm ||
                      '</ImpuestoTotal>';
        END IF;
        --
        --cveas modificar
        /*  reqxml_3 := reqxml_3 || chr(10) ||
        '                     <EstructuraGTIN>' ||
        x.EstructuraGTIN || '</EstructuraGTIN>';*/
        ---
        reqxml_3 := reqxml_3 || chr(10) || '                     <ComprobanteDetalleImpuestos>';
        reqxml_3 := reqxml_3 || chr(10) || '                        <ENComprobanteDetalleImpuestos>';
        IF (x.aqpa460imptb IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                           <ImporteTributo>' || x.aqpa460imptb ||
                      '</ImporteTributo>';
        END IF;
        IF (FALSE) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                           <ImporteExplicito>' || x.aqpa460impex ||
                      '</ImporteExplicito>';
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                           <AfectacionIGV>' || x.aqpa460afigv ||
                    '</AfectacionIGV>';
        IF (x.aqpa460sisc IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                           <SistemaISC>' || x.aqpa460sisc ||
                      '</SistemaISC>';
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                           <CodigoTributo>' || /*'9996'*/
                    x.aqpa460codtb || '</CodigoTributo>';
        reqxml_3 := reqxml_3 || chr(10) || '                           <DesTributo>' || /*'GRA'*/
                    x.aqpa460dstrb || '</DesTributo>';
        reqxml_3 := reqxml_3 || chr(10) || '                           <CodigoUN>' || x.aqpa460codun ||
                    '</CodigoUN>';
        IF (x.aqpa460mbim IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                           <MontoBase>' || x.aqpa460mbim ||
                      '</MontoBase>';
        END IF;
        IF (x.aqpa460taimp IS NOT NULL) THEN
          IF (x.aqpa460taimp <> 0 OR x.aqpa460taimp IS NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                           <TasaAplicada>' || x.aqpa460taimp ||
                        '</TasaAplicada>';
          END IF;
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                        </ENComprobanteDetalleImpuestos>';
        reqxml_3 := reqxml_3 || chr(10) || '                     </ComprobanteDetalleImpuestos>';
        ---revisar       --
        /*reqxml_3 := reqxml_3 || chr(10) || '                     <ENInformacionAdicional>';
        if (x.AQPA460VPCVA is not null) then
        reqxml_3 := reqxml_3 || chr(10) || '                       <Placa>' || x.AQPA460VPCVA || '</Placa>';
        end if;
        reqxml_3 := reqxml_3 || chr(10) || '                     </ENInformacionAdicional>';*/
        --
        reqxml_3 := reqxml_3 || chr(10) || '                     <GastosHipotecario>';
      
        IF (x.aqpa460nexp IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <CodigoTipoPrestamo>' || x.aqpa460nexp ||
                      '</CodigoTipoPrestamo>';
        END IF;
        IF (x.aqpa460cind IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <CodigoIndicador>' || x.aqpa460cind ||
                      '</CodigoIndicador>';
        END IF;
        IF (x.aqpa460npart IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <NumeroPartidaRegistral>' || x.aqpa460npart ||
                      '</NumeroPartidaRegistral>';
        END IF;
        IF (x.aqpa460ncont IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <NumeroContrato>' || x.aqpa460ncont ||
                      '</NumeroContrato>';
        END IF;
        IF (x.aqpa460fotrc IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <FechaOtorgaCredito>' || x.aqpa460fotrc ||
                      '</FechaOtorgaCredito>';
        END IF;
        IF (x.aqpa460cdisn IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <CodigoUbigeo>' || x.aqpa460cdisn ||
                      '</CodigoUbigeo>';
        END IF;
        IF (x.aqpa460direh IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Direccion>' || x.aqpa460direh ||
                      '</Direccion>';
        END IF;
        IF (x.aqpa460urbh IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Urbanizacion>' || x.aqpa460urbh ||
                      '</Urbanizacion>';
        END IF;
        IF (x.aqpa460prvh IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Provincia>' || x.aqpa460prvh || '</Provincia>';
        END IF;
        IF (x.aqpa460dsth IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Distrito>' || x.aqpa460dsth || '</Distrito>';
        END IF;
        IF (x.aqpa460depth IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Departamento>' || x.aqpa460depth ||
                      '</Departamento>';
        END IF;
      
        reqxml_3 := reqxml_3 || chr(10) || '                     </GastosHipotecario>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '                  </ENComprobanteDetalle>';
        --
  --cveas 06062019 <INI>
      IF (x.aqpa460dstrb = 'IGV') THEN
          vv_gravado := 'Y';
        END IF;
  --cveas 06062019 <FIN>   
     
      END LOOP;
      --bv 26/12/2018
      pr_ar_log_bt('9');
      ----------------------------------------------------------
      -- Datos a nivel DOCUMENTO, debajo de la seccion de LINEAS
      ----------------------------------------------------------
      --bv 26/12/2018
      pr_ar_log_bt('10');
      FOR x IN c_main LOOP
        --
        -- 27
        reqxml_3 := reqxml_3 || chr(10) || '               </ComprobanteDetalle>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '               <ComprobantePropiedadesAdicionales>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <ENComprobantePropiedadesAdicionales>';
        reqxml_3 := reqxml_3 || chr(10) || '                   <Codigo>' || x.aqpa460cdley || '</Codigo>';
        reqxml_3 := reqxml_3 || chr(10) || '                   <Valor>' || x.aqpa460teley || '</Valor>';
        reqxml_3 := reqxml_3 || chr(10) || '                 </ENComprobantePropiedadesAdicionales>';
        reqxml_3 := reqxml_3 || chr(10) || '               </ComprobantePropiedadesAdicionales>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '               <Texto>';
        reqxml_3 := reqxml_3 || chr(10) || '               <ENTexto>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Texto1>' || x.aqpa460text1 || '</Texto1>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Texto2>' || x.aqpa460text2 || '</Texto2>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Texto3>' || x.aqpa460text3 || '</Texto3>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Texto4>' || x.aqpa460text4 || '</Texto4>';
        reqxml_3 := reqxml_3 || chr(10) || '               </ENTexto>';
        reqxml_3 := reqxml_3 || chr(10) || '               </Texto>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '               <ENCorreoTerceros>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <ToReceive>' || x.aqpa460trecv || '</ToReceive>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Template>' || x.aqpa460templ || '</Template>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Subject>' || x.aqpa460subje || '</Subject>';
        reqxml_3 := reqxml_3 || chr(10) || '               </ENCorreoTerceros>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '               <MontosTotales>';
       -- IF (nvl(vv_aqpa460codtb, 'SIN_VALOR') <> '9998') THEN
        IF (nvl(vv_aqpa460codtb, 'SIN_VALOR') NOT IN ('9998', '9996')) THEN
        
          reqxml_3 := reqxml_3 || chr(10) || '                 <Gravado>';
          IF (x.aqpa460mtotal IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                   <Total>' || x.aqpa460mtotal || '</Total>';
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   <GravadoIGV>';
          IF (x.aqpa460baimp IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <Base>' || x.aqpa460baimp || '</Base>';
          END IF;
          IF (x.aqpa460mtimp IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <ValorImpuesto>' || x.aqpa460mtimp ||
                        '</ValorImpuesto>';
          END IF;
          IF (x.aqpa460pcima IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <Porcentaje>' || x.aqpa460pcima ||
                        '</Porcentaje>';
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   </GravadoIGV>';
          reqxml_3 := reqxml_3 || chr(10) || '                   <GravadoOTROS>';
          IF (x.aqpa460bsimp IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <Base>' || x.aqpa460bsimp || '</Base>';
          END IF;
          IF (x.aqpa460vaimp IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <ValorImpuesto>' || x.aqpa460vaimp ||
                        '</ValorImpuesto>';
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   </GravadoOTROS>';
          reqxml_3 := reqxml_3 || chr(10) || '                 </Gravado>';
        END IF;
        
         -- 06062019, INI
        IF (vv_gravado = 'N') THEN
        reqxml_3 := reqxml_3 || chr(10) || '                 <Inafecto>';
        reqxml_3 := reqxml_3 || chr(10) || '                   <Total>' || x.aqpa460mtinf || '</Total>';
        reqxml_3 := reqxml_3 || chr(10) || '                 </Inafecto>';
        END IF;
        -- 06062019, FIN
        
        --IF (nvl(vv_aqpa460codtb, 'SIN_VALOR') <> '9998') THEN
        IF (nvl(vv_aqpa460codtb, 'SIN_VALOR') = '9996') THEN
          reqxml_3 := reqxml_3 || chr(10) || '                 <Gratuito>';
          IF (x.aqpa460mtgrt IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                   <Total>' || x.aqpa460mtgrt || '</Total>';
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   <GratuitoImpuesto>';
          IF (x.aqpa460bsimps IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <Base>' || x.aqpa460bsimps || '</Base>';
          END IF;
          IF (x.aqpa460mtoti IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <ValorImpuesto>' || x.aqpa460mtoti ||
                        '</ValorImpuesto>';
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   </GratuitoImpuesto>';
          reqxml_3 := reqxml_3 || chr(10) || '                 </Gratuito>';
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '               </MontosTotales>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '            </oENComprobante>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '         </oGeneral>';
        reqxml_3 := reqxml_3 || chr(10) || '         <oTipoComprobante>' || 'Boleta' || '</oTipoComprobante>';
        reqxml_3 := reqxml_3 || chr(10) || '         <TipoCodigo>' || '1' || '</TipoCodigo>'; -- CODIGO HASH
        reqxml_3 := reqxml_3 || chr(10) || '         <IdComprobanteCliente>' || '0' || '</IdComprobanteCliente>'; -- Cualquier valor numerico
        reqxml_3 := reqxml_3 || chr(10) || '         <Otorgar>' || '1' || '</Otorgar>'; -- AUTOMATICAMENTE
        reqxml_3 := reqxml_3 || chr(10) || '      </Registrar>';
        reqxml_3 := reqxml_3 || chr(10) || '   </soap12:Body>';
        reqxml_3 := reqxml_3 || chr(10) || '</soap12:Envelope>';
        --
        EXIT;
      END LOOP;
      --bv 26/12/2018
      pr_ar_log_bt('11');
      ----------------------
    
    ELSIF (vv_aqpa460tcomf = '07') THEN
      -- NC
      --
      --bv 26/12/2018
      pr_ar_log_bt('12');
      vv_gravado := 'N'; --cveas 26072019
      
      FOR x IN c_main LOOP
      
        BEGIN
          SELECT DISTINCT l.aqpa460codtb
            INTO vv_aqpa460codtb
            FROM aqpa460 l
           WHERE l.aqpa460seri = x.aqpa460seri
             AND l.aqpa460num = x.aqpa460num;
        
        EXCEPTION
          WHEN OTHERS THEN
            vv_aqpa460codtb := NULL;
        END;
      
        IF vn_count = 0 THEN
        
          ---------------------------------------------
          -- Informacion a nivel CABECERA, solo una vez
          ---------------------------------------------
          -- 21
          reqxml_0 := reqxml_0 || '<?xml version="1.0" encoding="UTF-8"?>';
          reqxml_0 := reqxml_0 || chr(10) ||
                      '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
          reqxml_0 := reqxml_0 || chr(10) ||
                      '   <soap12:Body xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
          reqxml_0 := reqxml_0 || chr(10) || '      <Registrar xmlns="http://tempuri.org/">';
          reqxml_0 := reqxml_0 || chr(10) || '         <oGeneral>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '            <oENEmpresa>';
          reqxml_0 := reqxml_0 || chr(10) || '               <CodigoTipoDocumento>' || x.aqpa460tdoc ||
                      '</CodigoTipoDocumento>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Ruc>' || x.aqpa460rucc || '</Ruc>';
          reqxml_0 := reqxml_0 || chr(10) || '               <RazonSocial>' || x.aqpa460rsoc || '</RazonSocial>';
          reqxml_0 := reqxml_0 || chr(10) || '               <CodDistrito>' || x.aqpa460cdis || '</CodDistrito>';
          IF (x.aqpa460ncom IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <NombreComercial>' || x.aqpa460ncom ||
                        '</NombreComercial>';
          END IF;
          IF (x.aqpa460calle IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Calle>' || x.aqpa460calle || '</Calle>';
          END IF;
          IF (x.aqpa460urba IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Urbanizacion>' || x.aqpa460urba || '</Urbanizacion>';
          END IF;
          IF (x.aqpa460depa IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Departamento>' || x.aqpa460depa || '</Departamento>';
          END IF;
          IF (x.aqpa460prov IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Provincia>' || x.aqpa460prov || '</Provincia>';
          END IF;
          IF (x.aqpa460dist IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Distrito>' || x.aqpa460dist || '</Distrito>';
          END IF;
          IF (x.aqpa460telf IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Telefono>' || x.aqpa460telf || '</Telefono>';
          END IF;
          IF (x.aqpa460web IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Web>' || x.aqpa460web || '</Web>';
          END IF;
          IF (x.aqpa460cpais IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <CodPais>' || x.aqpa460cpais || '</CodPais>';
          END IF;
          reqxml_0 := reqxml_0 || chr(10) || '               <CodigoEstablecimientoSUNAT>' || x.aqpa460cesun ||
                      '</CodigoEstablecimientoSUNAT>';
          reqxml_0 := reqxml_0 || chr(10) || '            </oENEmpresa>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '            <oENComprobante>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Serie>' || x.aqpa460seri || '</Serie>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Numero>' || x.aqpa460num || '</Numero>';
          reqxml_0 := reqxml_0 || chr(10) || '               <FechaEmision>' || x.aqpa460femi || '</FechaEmision>';
          reqxml_0 := reqxml_0 || chr(10) || '               <TipoComprobante>' || x.aqpa460tcomf ||
                      '</TipoComprobante>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Moneda>' || x.aqpa460mone || '</Moneda>';
          IF (x.aqpa460corrr IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <CorreoElectronico>' || x.aqpa460corrr ||
                        '</CorreoElectronico>';
          END IF;
        
          IF (x.aqpa460glos IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Glosa>' || x.aqpa460glos || '</Glosa>';
          END IF;
          IF (x.aqpa460mglo IS NOT NULL) THEN
            --reqxml_0 := reqxml_0 || chr(10) || '               <Multiglosa>' || x.AQPA460MGLO || '</Multiglosa>';
            reqxml_0 := reqxml_0 || chr(10) || '               <Multiglosa>';
            reqxml_0 := reqxml_0 || chr(10) || '               <string>' || x.aqpa460mglo || '</string>';
            reqxml_0 := reqxml_0 || chr(10) || '               </Multiglosa>';
          END IF;
        
          IF (x.aqpa460tipag IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TipoPago>' || x.aqpa460tipag || '</TipoPago>';
          END IF;
        
          IF (x.aqpa460coma IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <ComprobanteAlias>' || x.aqpa460coma ||
                        '</ComprobanteAlias>';
          END IF;
          IF (x.aqpa460tpla IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TipoPlantilla>' || x.aqpa460tpla ||
                        '</TipoPlantilla>';
          END IF;
          --reqxml_0 := reqxml_0 || chr(10) || '               <TipoOperacion>' || x.AQPA460TOPE || '</TipoOperacion>';
          IF (x.aqpa460tplco IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TipoPlantillaCorreo>' || x.aqpa460tplco ||
                        '</TipoPlantillaCorreo>';
          END IF;
          IF (x.aqpa460clog IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <CodigoLogo>' || x.aqpa460clog || '</CodigoLogo>';
          END IF;
          reqxml_0 := reqxml_0 || chr(10) || '               <TipoDocumentoIdentidad>' || x.aqpa460tdocr ||
                      '</TipoDocumentoIdentidad>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Ruc>' || x.aqpa460nruc || '</Ruc>';
          reqxml_0 := reqxml_0 || chr(10) || '               <RazonSocial>' || x.aqpa460rasoc || '</RazonSocial>';
          reqxml_0 := reqxml_0 || chr(10) || '               <ImporteTotal>' || x.aqpa460impt || '</ImporteTotal>';
          reqxml_0 := reqxml_0 || chr(10) || '               <HoraEmision>' || x.aqpa460hemi || '</HoraEmision>';
          IF (x.aqpa460simc IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TotalImpuesto>' || x.aqpa460simc ||
                        '</TotalImpuesto>';
          END IF;
          --reqxml_0 := reqxml_0 || chr(10) || '               <TotalValorVenta>' || x.AQPA460SVITM || '</TotalValorVenta>';
          --reqxml_0 := reqxml_0 || chr(10) || '               <TotalPrecioVenta>' || x.AQPA460SPVI || '</TotalPrecioVenta>';
          IF (x.aqpa460txml IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <VersionUbl>' || x.aqpa460txml || '</VersionUbl>';
          END IF;
          --
          reqxml_0 := reqxml_0 || chr(10) || '               <ComprobanteMotivosDocumentos>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <ENComprobanteMotivoDocumento>';
          reqxml_0 := reqxml_0 || chr(10) || '                   <SerieDocRef>' || x.aqpa460sdref ||
                      '</SerieDocRef>';
          reqxml_0 := reqxml_0 || chr(10) || '                   <NumeroDocRef>' || x.aqpa460ndref ||
                      '</NumeroDocRef>';
          reqxml_0 := reqxml_0 || chr(10) || '                   <CodigoMotivoEmision>' || x.aqpa460cmem ||
                      '</CodigoMotivoEmision>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '                   <Sustentos>';
          reqxml_0 := reqxml_0 || chr(10) || '                   <ENComprobanteMotivoDocumentoSustento>';
          reqxml_0 := reqxml_0 || chr(10) || '                     <Sustento>' || x.aqpa460sust || '</Sustento>';
          reqxml_0 := reqxml_0 || chr(10) || '                   </ENComprobanteMotivoDocumentoSustento>';
          reqxml_0 := reqxml_0 || chr(10) || '                   </Sustentos>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '                 </ENComprobanteMotivoDocumento>';
          reqxml_0 := reqxml_0 || chr(10) || '               </ComprobanteMotivosDocumentos>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '               <ComprobanteNotaCreditoDocRef>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <ENComprobanteNotaDocRef>';
          reqxml_0 := reqxml_0 || chr(10) || '                   <Serie>' || x.aqpa460serie || '</Serie>';
          reqxml_0 := reqxml_0 || chr(10) || '                   <Numero>' || x.aqpa460nro || '</Numero>';
          reqxml_0 := reqxml_0 || chr(10) || '                   <TipoComprobante>' || x.aqpa460tcomp ||
                      '</TipoComprobante>';
          IF (x.aqpa460fdref IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '                   <FechaDocRef>' || x.aqpa460fdref ||
                        '</FechaDocRef>';
          END IF;
          reqxml_0 := reqxml_0 || chr(10) || '                 </ENComprobanteNotaDocRef>';
          reqxml_0 := reqxml_0 || chr(10) || '               </ComprobanteNotaCreditoDocRef>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '               <Receptor>';
          reqxml_0 := reqxml_0 || chr(10) || '               <ENReceptor>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <CodDistrito>' || x.aqpa460cdist || '</CodDistrito>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <Ubigeo>' || x.aqpa460cdis || '</Ubigeo>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <Calle>' || x.aqpa460call || '</Calle>';
          IF (x.aqpa460urb IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '                 <Urbanizacion>' || x.aqpa460urb ||
                        '</Urbanizacion>';
          END IF;
          reqxml_0 := reqxml_0 || chr(10) || '                 <Departamento>' || x.aqpa460dep || '</Departamento>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <Provincia>' || x.aqpa460prv || '</Provincia>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <Distrito>' || x.aqpa460dst || '</Distrito>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <CodPais>' || x.aqpa460cpai || '</CodPais>';
          reqxml_0 := reqxml_0 || chr(10) || '               </ENReceptor>';
          reqxml_0 := reqxml_0 || chr(10) || '               </Receptor>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '               <ComprobanteDetalle>';
          --
          vn_count := 1;
        
        END IF;
      
        -----------------------------
        -- Informacion a nivel LINEAS
        -----------------------------
        -- 25
        reqxml_3 := reqxml_3 || chr(10) || '                  <ENComprobanteDetalle>';
      
        reqxml_3 := reqxml_3 || chr(10) || '                     <Item>' || x.aqpa460item || '</Item>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <UnidadComercial>' || x.aqpa460pnetu ||
                    '</UnidadComercial>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Cantidad>' || x.aqpa460cantf || '</Cantidad>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Total>' || x.aqpa460total || '</Total>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Determinante>' || x.aqpa460dete ||
                    '</Determinante>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <CodigoTipoPrecio>' || x.aqpa460ctpr ||
                    '</CodigoTipoPrecio>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <ValorVentaUnitario>' || x.aqpa460vvun ||
                    '</ValorVentaUnitario>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <ValorVentaUnitarioIncIgv>' || x.aqpa460vvuig ||
                    '</ValorVentaUnitarioIncIgv>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Descripcion>' || x.aqpa460desc || '</Descripcion>';
        IF (x.aqpa460mfun IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                     <MultiDescripcion>';
          -- loop para separar las lineas
          vv_multi := x.aqpa460mfun;
          LOOP
            vn_prox  := nvl(instr(vv_multi, '|'), 0);
            vn_prox2 := nvl(instr(vv_multi, '|'), 0);
            IF (vn_prox = 0) THEN
              vn_prox := 500;
            END IF;
            vv_linea := substr(vv_multi, 1, vn_prox - 1);
            vv_multi := substr(vv_multi, vn_prox + 1, 500);
            IF (vv_linea IS NOT NULL) THEN
              reqxml_3 := reqxml_3 || chr(10) || '                       <string>' || vv_linea || '</string>';
            END IF;
            EXIT WHEN vn_prox2 = 0;
          END LOOP;
          --
          reqxml_3 := reqxml_3 || chr(10) || '                     </MultiDescripcion>';
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                     <PrecioVentaItem>' || x.aqpa460prvit ||
                    '</PrecioVentaItem>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <UnidadMedidaEmisor>' || x.aqpa460medem ||
                    '</UnidadMedidaEmisor>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <CodigoProductoSunat>' || x.aqpa460csuna ||
                    '</CodigoProductoSunat>';
        IF (x.aqpa460cpgs1 IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                     <CodigoProductoGS1>' || x.aqpa460cpgs1 ||
                      '</CodigoProductoGS1>';
        END IF;
        IF (x.aqpa460ititm IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                     <ImpuestoTotal>' || x.aqpa460ititm ||
                      '</ImpuestoTotal>';
        END IF;
      
        --cveas modificar         
        /*       --
        reqxml_3 := reqxml_3 || chr(10) ||
                   '                     <EstructuraGTIN>' ||
                   x.EstructuraGTIN || '</EstructuraGTIN>';
         --*/
        reqxml_3 := reqxml_3 || chr(10) || '                     <ComprobanteDetalleImpuestos>';
        reqxml_3 := reqxml_3 || chr(10) || '                        <ENComprobanteDetalleImpuestos>';
        IF (x.aqpa460imptb IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                           <ImporteTributo>' || x.aqpa460imptb ||
                      '</ImporteTributo>';
        END IF;
        IF (FALSE) THEN
          IF (x.aqpa460impex IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                           <ImporteExplicito>' || x.aqpa460impex ||
                        '</ImporteExplicito>';
          END IF;
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                           <AfectacionIGV>' || x.aqpa460afigv ||
                    '</AfectacionIGV>';
        IF (x.aqpa460sisc IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                           <SistemaISC>' || x.aqpa460sisc ||
                      '</SistemaISC>';
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                           <CodigoTributo>' || x.aqpa460codtb ||
                    '</CodigoTributo>';
        reqxml_3 := reqxml_3 || chr(10) || '                           <DesTributo>' || x.aqpa460dstrb ||
                    '</DesTributo>';
        reqxml_3 := reqxml_3 || chr(10) || '                           <CodigoUN>' || x.aqpa460codun ||
                    '</CodigoUN>';
        IF (x.aqpa460mbim IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                           <MontoBase>' || x.aqpa460mbim ||
                      '</MontoBase>';
        END IF;
        IF (x.aqpa460taimp IS NOT NULL) THEN
          IF (x.aqpa460taimp <> 0 OR x.aqpa460taimp IS NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                           <TasaAplicada>' || x.aqpa460taimp ||
                        '</TasaAplicada>';
          END IF;
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                        </ENComprobanteDetalleImpuestos>';
        reqxml_3 := reqxml_3 || chr(10) || '                     </ComprobanteDetalleImpuestos>'; ---
        --
        --reqxml_3 := reqxml_3 || chr(10) || '                     <ENInformacionAdicional>';
        --reqxml_3 := reqxml_3 || chr(10) || '                       <Placa>' || x.AQPA460VPCVA || '</Placa>';
        --reqxml_3 := reqxml_3 || chr(10) || '                     </ENInformacionAdicional>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '                     <GastosHipotecario>';
        IF (x.aqpa460nexp IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <CodigoTipoPrestamo>' || x.aqpa460nexp ||
                      '</CodigoTipoPrestamo>';
        END IF;
        IF (x.aqpa460cind IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <CodigoIndicador>' || x.aqpa460cind ||
                      '</CodigoIndicador>';
        END IF;
        IF (x.aqpa460npart IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <NumeroPartidaRegistral>' || x.aqpa460npart ||
                      '</NumeroPartidaRegistral>';
        END IF;
        IF (x.aqpa460ncont IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <NumeroContrato>' || x.aqpa460ncont ||
                      '</NumeroContrato>';
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                       <FechaOtorgaCredito>' || x.aqpa460fotrc ||
                    '</FechaOtorgaCredito>';
        IF (x.aqpa460cdisn IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <CodigoUbigeo>' || x.aqpa460cdisn ||
                      '</CodigoUbigeo>';
        END IF;
        IF (x.aqpa460direh IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Direccion>' || x.aqpa460direh ||
                      '</Direccion>';
        END IF;
        IF (x.aqpa460urbh IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Urbanizacion>' || x.aqpa460urbh ||
                      '</Urbanizacion>';
        END IF;
        IF (x.aqpa460prvh IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Provincia>' || x.aqpa460prvh || '</Provincia>';
        END IF;
        IF (x.aqpa460dsth IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Distrito>' || x.aqpa460dsth || '</Distrito>';
        END IF;
        IF (x.aqpa460depth IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Departamento>' || x.aqpa460depth ||
                      '</Departamento>';
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                     </GastosHipotecario>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '                  </ENComprobanteDetalle>';
        --
      -- 06062019, INI cveas
      IF (x.aqpa460dstrb = 'IGV') THEN
          vv_gravado := 'Y';
        END IF;
      -- 06062019, FIN cveas
      END LOOP;
      --bv 26/12/2018
      pr_ar_log_bt('13');
      ----------------------------------------------------------
      -- Datos a nivel DOCUMENTO, debajo de la seccion de LINEAS
      ----------------------------------------------------------
      --bv 26/12/2018
      pr_ar_log_bt('14');
      FOR x IN c_main LOOP
        --
        -- 27
        reqxml_3 := reqxml_3 || chr(10) || '               </ComprobanteDetalle>';
        --
        --reqxml_3 := reqxml_3 || chr(10) || '               <ENComprobantePropiedadesAdicionales>';
        --reqxml_3 := reqxml_3 || chr(10) || '                 <Codigo>' || x.AQPA460CDLEY || '</Codigo>';
        --reqxml_3 := reqxml_3 || chr(10) || '                 <Valor>' || x.AQPA460TELEY || '</Valor>';
        --reqxml_3 := reqxml_3 || chr(10) || '               </ENComprobantePropiedadesAdicionales>';
      
        ----------
      
        reqxml_3 := reqxml_3 || chr(10) || '               <ComprobantePropiedadesAdicionales>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <ENComprobantePropiedadesAdicionales>';
        reqxml_3 := reqxml_3 || chr(10) || '                   <Codigo>' || x.aqpa460cdley || '</Codigo>';
        reqxml_3 := reqxml_3 || chr(10) || '                   <Valor>' || x.aqpa460teley || '</Valor>';
        reqxml_3 := reqxml_3 || chr(10) || '                 </ENComprobantePropiedadesAdicionales>';
        reqxml_3 := reqxml_3 || chr(10) || '               </ComprobantePropiedadesAdicionales>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '               <Texto>';
        reqxml_3 := reqxml_3 || chr(10) || '               <ENTexto>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Texto1>' || x.aqpa460text1 || '</Texto1>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Texto2>' || x.aqpa460text2 || '</Texto2>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Texto3>' || x.aqpa460text3 || '</Texto3>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Texto4>' || x.aqpa460text4 || '</Texto4>';
        reqxml_3 := reqxml_3 || chr(10) || '               </ENTexto>';
        reqxml_3 := reqxml_3 || chr(10) || '               </Texto>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '               <ENCorreoTerceros>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <ToReceive>' || x.aqpa460trecv || '</ToReceive>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Template>' || x.aqpa460templ || '</Template>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Subject>' || x.aqpa460subje || '</Subject>';
        reqxml_3 := reqxml_3 || chr(10) || '               </ENCorreoTerceros>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '               <MontosTotales>';
        IF (nvl(vv_aqpa460codtb, 'SIN_VALOR') <> '9998') THEN
          reqxml_3 := reqxml_3 || chr(10) || '                 <Gravado>';
          IF (x.aqpa460mtotal IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                   <Total>' || x.aqpa460mtotal || '</Total>';
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   <GravadoIGV>';
          IF (x.aqpa460baimp IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <Base>' || x.aqpa460baimp || '</Base>';
          END IF;
          IF (x.aqpa460mtimp IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <ValorImpuesto>' || x.aqpa460mtimp ||
                        '</ValorImpuesto>';
          END IF;
          IF (x.aqpa460pcima IS NOT NULL) THEN
            IF (x.aqpa460pcima <> 0) THEN
              reqxml_3 := reqxml_3 || chr(10) || '                     <Porcentaje>' || x.aqpa460pcima ||
                          '</Porcentaje>';
            END IF;
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   </GravadoIGV>';
          reqxml_3 := reqxml_3 || chr(10) || '                   <GravadoOTROS>';
          IF (x.aqpa460bsimp IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <Base>' || x.aqpa460bsimp || '</Base>';
          END IF;
          IF (x.aqpa460vaimp IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <ValorImpuesto>' || x.aqpa460vaimp ||
                        '</ValorImpuesto>';
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   </GravadoOTROS>';
          reqxml_3 := reqxml_3 || chr(10) || '                 </Gravado>';
        END IF;
        
        -- 06062019, INI cveas
        IF (vv_gravado = 'N') THEN
        reqxml_3 := reqxml_3 || chr(10) || '                 <Inafecto>';
        reqxml_3 := reqxml_3 || chr(10) || '                   <Total>' || x.aqpa460mtinf || '</Total>';
        reqxml_3 := reqxml_3 || chr(10) || '                 </Inafecto>';
        END IF;
        -- 06062019, FIN cveas
        
        IF (nvl(vv_aqpa460codtb, 'SIN_VALOR') <> '9998') THEN
          reqxml_3 := reqxml_3 || chr(10) || '                 <Gratuito>';
          IF (x.aqpa460mtgrt IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                   <Total>' || x.aqpa460mtgrt || '</Total>';
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   <GratuitoImpuesto>';
          IF (x.aqpa460bsimps IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <Base>' || x.aqpa460bsimps || '</Base>';
          END IF;
          IF (x.aqpa460mtoti IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <ValorImpuesto>' || x.aqpa460mtoti ||
                        '</ValorImpuesto>';
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   </GratuitoImpuesto>';
          reqxml_3 := reqxml_3 || chr(10) || '                 </Gratuito>';
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '               </MontosTotales>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '            </oENComprobante>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '         </oGeneral>';
        reqxml_3 := reqxml_3 || chr(10) || '         <oTipoComprobante>' || 'NotaCredito' || '</oTipoComprobante>'; -- Nota de Credito
        reqxml_3 := reqxml_3 || chr(10) || '         <TipoCodigo>' || '1' || '</TipoCodigo>'; -- CODIGO HASH
        reqxml_3 := reqxml_3 || chr(10) || '         <IdComprobanteCliente>' || '0' || '</IdComprobanteCliente>'; -- Cualquier valor numerico
        reqxml_3 := reqxml_3 || chr(10) || '         <Otorgar>' || '1' || '</Otorgar>'; -- AUTOMATICAMENTE
        reqxml_3 := reqxml_3 || chr(10) || '      </Registrar>';
        reqxml_3 := reqxml_3 || chr(10) || '   </soap12:Body>';
        reqxml_3 := reqxml_3 || chr(10) || '</soap12:Envelope>';
        --
        EXIT;
      END LOOP;
      --bv 26/12/2018
      pr_ar_log_bt('15');
      -------------    
    
    ELSIF (vv_aqpa460tcomf = '08') THEN
      -- ND
      --bv 26/12/2018
      vv_gravado := 'N'; --cveas 26072019
      
      pr_ar_log_bt('16');
      FOR x IN c_main LOOP
      
        BEGIN
          SELECT DISTINCT l.aqpa460codtb
            INTO vv_aqpa460codtb
            FROM aqpa460 l
           -- INI, 31/12/2018  
           WHERE l.aqpa460seri = x.aqpa460seri
             AND l.aqpa460num = x.aqpa460num
           -- FIN, 31/12/2018                         
            ;
          -- where l.certificate_id = x.certificate_id;
        EXCEPTION
          WHEN OTHERS THEN
            vv_aqpa460codtb := NULL;
        END;
      
        IF vn_count = 0 THEN
        
          ---------------------------------------------
          -- Informacion a nivel CABECERA, solo una vez
          ---------------------------------------------          
          -- 21
          reqxml_0 := reqxml_0 || '<?xml version="1.0" encoding="UTF-8"?>';
          reqxml_0 := reqxml_0 || chr(10) ||
                      '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
          reqxml_0 := reqxml_0 || chr(10) ||
                      '   <soap12:Body xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
          reqxml_0 := reqxml_0 || chr(10) || '      <Registrar xmlns="http://tempuri.org/">';
          reqxml_0 := reqxml_0 || chr(10) || '         <oGeneral>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '            <oENEmpresa>';
          reqxml_0 := reqxml_0 || chr(10) || '               <CodigoTipoDocumento>' || x.aqpa460tdoc ||
                      '</CodigoTipoDocumento>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Ruc>' || x.aqpa460rucc || '</Ruc>';
          reqxml_0 := reqxml_0 || chr(10) || '               <RazonSocial>' || x.aqpa460rsoc || '</RazonSocial>';
          reqxml_0 := reqxml_0 || chr(10) || '               <CodDistrito>' || x.aqpa460cdis || '</CodDistrito>';
          IF (x.aqpa460ncom IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <NombreComercial>' || x.aqpa460ncom ||
                        '</NombreComercial>';
          END IF;
          IF (x.aqpa460calle IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Calle>' || x.aqpa460calle || '</Calle>';
          END IF;
          IF (x.aqpa460urba IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Urbanizacion>' || x.aqpa460urba || '</Urbanizacion>';
          END IF;
          IF (x.aqpa460depa IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Departamento>' || x.aqpa460depa || '</Departamento>';
          END IF;
          IF (x.aqpa460prov IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Provincia>' || x.aqpa460prov || '</Provincia>';
          END IF;
          IF (x.aqpa460dist IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Distrito>' || x.aqpa460dist || '</Distrito>';
          END IF;
          IF (x.aqpa460telf IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Telefono>' || x.aqpa460telf || '</Telefono>';
          END IF;
          IF (x.aqpa460web IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Web>' || x.aqpa460web || '</Web>';
          END IF;
          IF (x.aqpa460cpais IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <CodPais>' || x.aqpa460cpais || '</CodPais>';
          END IF;
          reqxml_0 := reqxml_0 || chr(10) || '               <CodigoEstablecimientoSUNAT>' || x.aqpa460cesun ||
                      '</CodigoEstablecimientoSUNAT>';
          reqxml_0 := reqxml_0 || chr(10) || '            </oENEmpresa>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '            <oENComprobante>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Serie>' || x.aqpa460seri || '</Serie>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Numero>' || x.aqpa460num || '</Numero>';
          reqxml_0 := reqxml_0 || chr(10) || '               <FechaEmision>' || x.aqpa460femi || '</FechaEmision>';
          reqxml_0 := reqxml_0 || chr(10) || '               <TipoComprobante>' || x.aqpa460tcomf ||
                      '</TipoComprobante>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Moneda>' || x.aqpa460mone || '</Moneda>';
          IF (x.aqpa460corrr IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <CorreoElectronico>' || x.aqpa460corrr ||
                        '</CorreoElectronico>';
          END IF;
          IF (x.glosa IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <Glosa>' || x.glosa || '</Glosa>';
          END IF;
          IF (x.aqpa460mglo IS NOT NULL) THEN
            --reqxml_0 := reqxml_0 || chr(10) || '               <Multiglosa>' || x.AQPA460MGLO || '</Multiglosa>';
            reqxml_0 := reqxml_0 || chr(10) || '               <Multiglosa>';
            reqxml_0 := reqxml_0 || chr(10) || '               <string>' || x.aqpa460mglo || '</string>';
            reqxml_0 := reqxml_0 || chr(10) || '               </Multiglosa>';
          END IF;
          IF (x.aqpa460tipag IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TipoPago>' || x.aqpa460tipag || '</TipoPago>';
          END IF;
          IF (x.aqpa460coma IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <ComprobanteAlias>' || x.aqpa460coma ||
                        '</ComprobanteAlias>';
          END IF;
          IF (x.aqpa460tpla IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TipoPlantilla>' || x.aqpa460tpla ||
                        '</TipoPlantilla>';
          END IF;
          --reqxml_0 := reqxml_0 || chr(10) || '               <TipoOperacion>' || x.AQPA460TOPE || '</TipoOperacion>';
          IF (x.aqpa460tplco IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TipoPlantillaCorreo>' || x.aqpa460tplco ||
                        '</TipoPlantillaCorreo>';
          END IF;
          IF (x.aqpa460clog IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <CodigoLogo>' || x.aqpa460clog || '</CodigoLogo>';
          END IF;
          reqxml_0 := reqxml_0 || chr(10) || '               <TipoDocumentoIdentidad>' || x.aqpa460tdocr ||
                      '</TipoDocumentoIdentidad>';
          reqxml_0 := reqxml_0 || chr(10) || '               <Ruc>' || x.aqpa460nruc || '</Ruc>';
          reqxml_0 := reqxml_0 || chr(10) || '               <RazonSocial>' || x.aqpa460rasoc || '</RazonSocial>';
          reqxml_0 := reqxml_0 || chr(10) || '               <ImporteTotal>' || x.aqpa460impt || '</ImporteTotal>';
          reqxml_0 := reqxml_0 || chr(10) || '               <HoraEmision>' || x.aqpa460hemi || '</HoraEmision>';
          IF (x.aqpa460simc IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <TotalImpuesto>' || x.aqpa460simc ||
                        '</TotalImpuesto>';
          END IF;
          --reqxml_0 := reqxml_0 || chr(10) || '               <TotalValorVenta>' || x.AQPA460SVITM || '</TotalValorVenta>';
          --reqxml_0 := reqxml_0 || chr(10) || '               <TotalPrecioVenta>' || x.AQPA460SPVI || '</TotalPrecioVenta>';                    
          IF (x.aqpa460txml IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '               <VersionUbl>' || x.aqpa460txml || '</VersionUbl>';
          END IF;
          --
          reqxml_0 := reqxml_0 || chr(10) || '               <ComprobanteMotivosDocumentos>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <ENComprobanteMotivoDocumento>';
          reqxml_0 := reqxml_0 || chr(10) || '                   <SerieDocRef>' || x.aqpa460sdref ||
                      '</SerieDocRef>';
          reqxml_0 := reqxml_0 || chr(10) || '                   <NumeroDocRef>' || x.aqpa460ndref ||
                      '</NumeroDocRef>';
          --reqxml_0 := reqxml_0 || chr(10) || '                   <CodigoMotivoEmision>' || x.AQPA460CMEM || '</CodigoMotivoEmision>';          
          --
          reqxml_0 := reqxml_0 || chr(10) || '                   <Sustentos>';
          reqxml_0 := reqxml_0 || chr(10) || '                   <ENComprobanteMotivoDocumentoSustento>';
          reqxml_0 := reqxml_0 || chr(10) || '                     <Sustento>' || x.aqpa460sust || '</Sustento>';
          reqxml_0 := reqxml_0 || chr(10) || '                   </ENComprobanteMotivoDocumentoSustento>';
          reqxml_0 := reqxml_0 || chr(10) || '                   </Sustentos>';
          --                    
          reqxml_0 := reqxml_0 || chr(10) || '                 </ENComprobanteMotivoDocumento>';
          reqxml_0 := reqxml_0 || chr(10) || '               </ComprobanteMotivosDocumentos>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '               <ComprobanteNotaCreditoDocRef>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <ENComprobanteNotaDocRef>';
          reqxml_0 := reqxml_0 || chr(10) || '                   <Serie>' || x.aqpa460serie || '</Serie>';
          reqxml_0 := reqxml_0 || chr(10) || '                   <Numero>' || x.aqpa460nro || '</Numero>';
          reqxml_0 := reqxml_0 || chr(10) || '                   <TipoComprobante>' || x.aqpa460tcomp ||
                      '</TipoComprobante>';
          IF (x.aqpa460fdref IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '                   <FechaDocRef>' || x.aqpa460fdref ||
                        '</FechaDocRef>';
          END IF;
          reqxml_0 := reqxml_0 || chr(10) || '                 </ENComprobanteNotaDocRef>';
          reqxml_0 := reqxml_0 || chr(10) || '               </ComprobanteNotaCreditoDocRef>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '               <Receptor>';
          reqxml_0 := reqxml_0 || chr(10) || '               <ENReceptor>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <CodDistrito>' || x.aqpa460cdist || '</CodDistrito>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <Ubigeo>' || x.aqpa460cdis || '</Ubigeo>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <Calle>' || x.aqpa460call || '</Calle>';
          IF (x.aqpa460urb IS NOT NULL) THEN
            reqxml_0 := reqxml_0 || chr(10) || '                 <Urbanizacion>' || x.aqpa460urb ||
                        '</Urbanizacion>';
          END IF;
          reqxml_0 := reqxml_0 || chr(10) || '                 <Departamento>' || x.aqpa460dep || '</Departamento>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <Provincia>' || x.aqpa460prv || '</Provincia>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <Distrito>' || x.aqpa460dst || '</Distrito>';
          reqxml_0 := reqxml_0 || chr(10) || '                 <CodPais>' || x.aqpa460cpai || '</CodPais>';
          reqxml_0 := reqxml_0 || chr(10) || '               </ENReceptor>';
          reqxml_0 := reqxml_0 || chr(10) || '               </Receptor>';
          --
          reqxml_0 := reqxml_0 || chr(10) || '               <ComprobanteDetalle>';
          --
          vn_count := 1;
        
        END IF;
      
        -----------------------------
        -- Informacion a nivel LINEAS
        -----------------------------
        -- 25       
        reqxml_3 := reqxml_3 || chr(10) || '                  <ENComprobanteDetalle>';
      
        reqxml_3 := reqxml_3 || chr(10) || '                     <Item>' || x.aqpa460item || '</Item>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <UnidadComercial>' || x.aqpa460pnetu ||
                    '</UnidadComercial>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Cantidad>' || x.aqpa460cantf || '</Cantidad>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Total>' || x.aqpa460total || '</Total>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Determinante>' || x.aqpa460dete ||
                    '</Determinante>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <CodigoTipoPrecio>' || x.aqpa460ctpr ||
                    '</CodigoTipoPrecio>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <ValorVentaUnitario>' || x.aqpa460vvun ||
                    '</ValorVentaUnitario>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <ValorVentaUnitarioIncIgv>' || x.aqpa460vvuig ||
                    '</ValorVentaUnitarioIncIgv>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <Descripcion>' || x.aqpa460desc || '</Descripcion>';
        IF (x.aqpa460mfun IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                     <MultiDescripcion>';
          -- loop para separar las lineas
          vv_multi := x.aqpa460mfun;
          LOOP
            vn_prox  := nvl(instr(vv_multi, '|'), 0);
            vn_prox2 := nvl(instr(vv_multi, '|'), 0);
            IF (vn_prox = 0) THEN
              vn_prox := 500;
            END IF;
            vv_linea := substr(vv_multi, 1, vn_prox - 1);
            vv_multi := substr(vv_multi, vn_prox + 1, 500);
            IF (vv_linea IS NOT NULL) THEN
              reqxml_3 := reqxml_3 || chr(10) || '                       <string>' || vv_linea || '</string>';
            END IF;
            EXIT WHEN vn_prox2 = 0;
          END LOOP;
          --
          reqxml_3 := reqxml_3 || chr(10) || '                     </MultiDescripcion>';
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                     <PrecioVentaItem>' || x.aqpa460prvit ||
                    '</PrecioVentaItem>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <UnidadMedidaEmisor>' || x.aqpa460medem ||
                    '</UnidadMedidaEmisor>';
        reqxml_3 := reqxml_3 || chr(10) || '                     <CodigoProductoSunat>' || x.aqpa460csuna ||
                    '</CodigoProductoSunat>';
        IF (x.aqpa460cpgs1 IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                     <CodigoProductoGS1>' || x.aqpa460cpgs1 ||
                      '</CodigoProductoGS1>';
        END IF;
        IF (x.aqpa460ititm IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                     <ImpuestoTotal>' || x.aqpa460ititm ||
                      '</ImpuestoTotal>';
        END IF;
      
        --cveas modificar
      
        /*   
        reqxml_3 := reqxml_3 || chr(10) ||
                      '                     <EstructuraGTIN>' ||
                      x.EstructuraGTIN || '</EstructuraGTIN>';*/
      
        reqxml_3 := reqxml_3 || chr(10) || '                     <ComprobanteDetalleImpuestos>';
        reqxml_3 := reqxml_3 || chr(10) || '                        <ENComprobanteDetalleImpuestos>';
        IF (x.aqpa460imptb IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                           <ImporteTributo>' || x.aqpa460imptb ||
                      '</ImporteTributo>';
        END IF;
        IF (FALSE) THEN
          IF (x.aqpa460impex IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                           <ImporteExplicito>' || x.aqpa460impex ||
                        '</ImporteExplicito>';
          END IF;
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                           <AfectacionIGV>' || x.aqpa460afigv ||
                    '</AfectacionIGV>';
        IF (x.aqpa460sisc IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                           <SistemaISC>' || x.aqpa460sisc ||
                      '</SistemaISC>';
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                           <CodigoTributo>' || x.aqpa460codtb ||
                    '</CodigoTributo>';
        reqxml_3 := reqxml_3 || chr(10) || '                           <DesTributo>' || x.aqpa460dstrb ||
                    '</DesTributo>';
        reqxml_3 := reqxml_3 || chr(10) || '                           <CodigoUN>' || x.aqpa460codun ||
                    '</CodigoUN>';
        IF (x.aqpa460mbim IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                           <MontoBase>' || x.aqpa460mbim ||
                      '</MontoBase>';
        END IF;
        IF (x.aqpa460taimp IS NOT NULL) THEN
          IF (x.aqpa460taimp <> 0 OR x.aqpa460taimp IS NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                           <TasaAplicada>' || x.aqpa460taimp ||
                        '</TasaAplicada>';
          END IF;
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '                        </ENComprobanteDetalleImpuestos>';
        reqxml_3 := reqxml_3 || chr(10) || '                     </ComprobanteDetalleImpuestos>';
        --
        --reqxml_3 := reqxml_3 || chr(10) || '                     <ENInformacionAdicional>';
        --reqxml_3 := reqxml_3 || chr(10) || '                       <Placa>' || x.AQPA460VPCVA || '</Placa>';
        --reqxml_3 := reqxml_3 || chr(10) || '                     </ENInformacionAdicional>';          
        --
        reqxml_3 := reqxml_3 || chr(10) || '                     <GastosHipotecario>';
      
        IF (x.aqpa460nexp IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <CodigoTipoPrestamo>' || x.aqpa460nexp ||
                      '</CodigoTipoPrestamo>';
        END IF;
        IF (x.aqpa460cind IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <CodigoIndicador>' || x.aqpa460cind ||
                      '</CodigoIndicador>';
        END IF;
        IF (x.aqpa460npart IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <NumeroPartidaRegistral>' || x.aqpa460npart ||
                      '</NumeroPartidaRegistral>';
        END IF;
        IF (x.aqpa460ncont IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <NumeroContrato>' || x.aqpa460ncont ||
                      '</NumeroContrato>';
        END IF;
        --reqxml_3 := reqxml_3 || chr(10) || '                       <FechaOtorgaCredito>' || x.AQPA460FOTRC || '</FechaOtorgaCredito>';
        IF (x.aqpa460cdisn IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <CodigoUbigeo>' || x.aqpa460cdisn ||
                      '</CodigoUbigeo>';
        END IF;
        IF (x.aqpa460direh IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Direccion>' || x.aqpa460direh ||
                      '</Direccion>';
        END IF;
        IF (x.aqpa460urbh IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Urbanizacion>' || x.aqpa460urbh ||
                      '</Urbanizacion>';
        END IF;
        IF (x.aqpa460prvh IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Provincia>' || x.aqpa460prvh || '</Provincia>';
        END IF;
        IF (x.aqpa460dsth IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Distrito>' || x.aqpa460dsth || '</Distrito>';
        END IF;
        IF (x.aqpa460depth IS NOT NULL) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                       <Departamento>' || x.aqpa460depth ||
                      '</Departamento>';
        END IF;
      
        reqxml_3 := reqxml_3 || chr(10) || '                     </GastosHipotecario>';
        --          
        reqxml_3 := reqxml_3 || chr(10) || '                  </ENComprobanteDetalle>';
        --
      
      -- 06062019, INI cveas
        IF (x.aqpa460dstrb = 'IGV') THEN
          vv_gravado := 'Y';
        END IF;
        -- 06062019, FIN cveas
      
      
      END LOOP;
      --bv 26/12/2018
      pr_ar_log_bt('17');
      ----------------------------------------------------------
      -- Datos a nivel DOCUMENTO, debajo de la seccion de LINEAS
      ----------------------------------------------------------
      --bv 26/12/2018
      pr_ar_log_bt('18');
      FOR x IN c_main LOOP
        --
        -- 27                
        reqxml_3 := reqxml_3 || chr(10) || '               </ComprobanteDetalle>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '               <ComprobantePropiedadesAdicionales>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <ENComprobantePropiedadesAdicionales>';
        reqxml_3 := reqxml_3 || chr(10) || '                   <Codigo>' || x.aqpa460cdley || '</Codigo>';
        reqxml_3 := reqxml_3 || chr(10) || '                   <Valor>' || x.aqpa460teley || '</Valor>';
        reqxml_3 := reqxml_3 || chr(10) || '                 </ENComprobantePropiedadesAdicionales>';
        reqxml_3 := reqxml_3 || chr(10) || '               </ComprobantePropiedadesAdicionales>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '               <Texto>';
        reqxml_3 := reqxml_3 || chr(10) || '               <ENTexto>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Texto1>' || x.aqpa460text1 || '</Texto1>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Texto2>' || x.aqpa460text2 || '</Texto2>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Texto3>' || x.aqpa460text3 || '</Texto3>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Texto4>' || x.aqpa460text4 || '</Texto4>';
        reqxml_3 := reqxml_3 || chr(10) || '               </ENTexto>';
        reqxml_3 := reqxml_3 || chr(10) || '               </Texto>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '               <ENCorreoTerceros>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <ToReceive>' || x.aqpa460trecv || '</ToReceive>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Template>' || x.aqpa460templ || '</Template>';
        reqxml_3 := reqxml_3 || chr(10) || '                 <Subject>' || x.aqpa460subje || '</Subject>';
        reqxml_3 := reqxml_3 || chr(10) || '               </ENCorreoTerceros>';
        --       
        reqxml_3 := reqxml_3 || chr(10) || '               <MontosTotales>';
--        IF (nvl(vv_aqpa460codtb, 'SIN_VALOR') <> '9998') THEN
        IF (nvl(vv_aqpa460codtb, 'SIN_VALOR') NOT IN ('9998', '9996')) THEN
          reqxml_3 := reqxml_3 || chr(10) || '                 <Gravado>';
          IF (x.aqpa460mtotal IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                   <Total>' || x.aqpa460mtotal || '</Total>';
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   <GravadoIGV>';
          IF (x.aqpa460baimp IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <Base>' || x.aqpa460baimp || '</Base>';
          END IF;
          IF (x.aqpa460mtimp IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <ValorImpuesto>' || x.aqpa460mtimp ||
                        '</ValorImpuesto>';
          END IF;
          IF (x.aqpa460pcima IS NOT NULL) THEN
            IF (x.aqpa460pcima <> 0) THEN
              reqxml_3 := reqxml_3 || chr(10) || '                     <Porcentaje>' || x.aqpa460pcima ||
                          '</Porcentaje>';
            END IF;
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   </GravadoIGV>';
          reqxml_3 := reqxml_3 || chr(10) || '                   <GravadoOTROS>';
          IF (x.aqpa460bsimp IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <Base>' || x.aqpa460bsimp || '</Base>';
          END IF;
          IF (x.aqpa460vaimp IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <ValorImpuesto>' || x.aqpa460vaimp ||
                        '</ValorImpuesto>';
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   </GravadoOTROS>';
          reqxml_3 := reqxml_3 || chr(10) || '                 </Gravado>';
        END IF;
        
        -- 06062019, INI cveas
        IF (vv_gravado = 'N') THEN
        reqxml_3 := reqxml_3 || chr(10) || '                 <Inafecto>';
        reqxml_3 := reqxml_3 || chr(10) || '                   <Total>' || x.aqpa460mtinf || '</Total>';
        reqxml_3 := reqxml_3 || chr(10) || '                 </Inafecto>';
        END IF;
        -- 06062019, FIN cveas 
        
        --IF (nvl(vv_aqpa460codtb, 'SIN_VALOR') <> '9998') THEN
        IF (nvl(vv_aqpa460codtb, 'SIN_VALOR') = '9996') THEN
          reqxml_3 := reqxml_3 || chr(10) || '                 <Gratuito>';
          IF (x.aqpa460mtgrt IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                   <Total>' || x.aqpa460mtgrt || '</Total>';
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   <GratuitoImpuesto>';
          IF (x.aqpa460bsimps IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <Base>' || x.aqpa460bsimps || '</Base>';
          END IF;
          IF (x.aqpa460mtoti IS NOT NULL) THEN
            reqxml_3 := reqxml_3 || chr(10) || '                     <ValorImpuesto>' || x.aqpa460mtoti ||
                        '</ValorImpuesto>';
          END IF;
          reqxml_3 := reqxml_3 || chr(10) || '                   </GratuitoImpuesto>';
          reqxml_3 := reqxml_3 || chr(10) || '                 </Gratuito>';
        END IF;
        reqxml_3 := reqxml_3 || chr(10) || '               </MontosTotales>';
        --
        reqxml_3 := reqxml_3 || chr(10) || '            </oENComprobante>';
        --        
        reqxml_3 := reqxml_3 || chr(10) || '         </oGeneral>';
        reqxml_3 := reqxml_3 || chr(10) || '         <oTipoComprobante>' || 'NotaCredito' || '</oTipoComprobante>'; -- Nota de Credito
        reqxml_3 := reqxml_3 || chr(10) || '         <TipoCodigo>' || '1' || '</TipoCodigo>'; -- CODIGO HASH
        reqxml_3 := reqxml_3 || chr(10) || '         <IdComprobanteCliente>' || '0' || '</IdComprobanteCliente>'; -- Cualquier valor numerico
        reqxml_3 := reqxml_3 || chr(10) || '         <Otorgar>' || '1' || '</Otorgar>'; -- AUTOMATICAMENTE
        reqxml_3 := reqxml_3 || chr(10) || '      </Registrar>';
        reqxml_3 := reqxml_3 || chr(10) || '   </soap12:Body>';
        reqxml_3 := reqxml_3 || chr(10) || '</soap12:Envelope>';
        --
        EXIT;
      END LOOP;
      --bv 26/12/2018
      pr_ar_log_bt('19');
      --
    END IF;
  
    reqxml_4 := reqxml_0 || reqxml_3;
  
    --DBMS_OUTPUT.PUT_LINE(reqxml_4);
    --bv 26/12/2018
    pr_ar_log_bt('20');
    pr_ar_xml_ws('INSERT', pc_proceso, pn_trx_id, reqxml_4, 'Registrar xmlns');
    --bv 26/12/2018
    pr_ar_log_bt('21');
    ----CVEAS---<INI>18122018
    pr_jc_insertar_log('Registrar', vn_id_log, pn_trx_id);
  
    -- CORREGIR
    req := utl_http.begin_request(url => vv_url_http, method => 'POST', http_version => 'HTTP/1.1');
  
    utl_http.set_transfer_timeout( /*60*/ 180);
    utl_http.set_header(req, 'Content-Type', 'application/soap+xml; charset=utf-8');
    utl_http.set_header(req, 'Content-Length', length(reqxml_4));
    utl_http.write_text(req, reqxml_4);
    resp := utl_http.get_response(req);
    utl_http.read_text(resp, respval);
    -- apps.fnd_file.put_line(apps.fnd_file.log, respval);
    utl_http.end_response(resp);
  
    pr_jc_actualizar_log(vn_id_log);
    ----CVEAS---<FIN>18122018
    --bv 26/12/2018
    pr_ar_log_bt('22');
    pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, '');
    --bv 26/12/2018
    pr_ar_log_bt('23');
    vc_mensaje := NULL;
    --bv 26/12/2018
    pr_ar_log_bt('24');
    -- Procesamos la respuesta del WS : Registrar
    pr_ar_data_ws(pc_proceso, pn_trx_id, respval, vc_mensaje);
    --bv 26/12/2018
    pr_ar_log_bt('25');
    IF vc_mensaje IS NOT NULL THEN
      pc_resultado := NULL;
      RETURN FALSE;
    ELSE
      IF instr(respval, '<?xml version="1.0" encoding="utf-8"?') >= 1 THEN
        pc_resultado := NULL;
        RETURN TRUE;
      ELSE
        pc_resultado := 'Error de Formato en Trama de Retorno 1';
        RETURN FALSE;
      END IF;
    END IF;
  
  EXCEPTION
  
    /*when ve_exc_2 then
    insert into jc.jc_log1 values ('1- ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); commit;
    apps.fnd_file.put_line(apps.fnd_file.output, 'Error WS: No hay datos para env?o');
    pc_resultado := 'Error WS: No hay datos para env?o';
    
    pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, pc_resultado);
    
    return false;*/
  
    /* when ve_exc then
    insert into jc.jc_log1 values ('2- ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); commit;    
    apps.fnd_file.put_line(apps.fnd_file.output, vv_message);
    pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, vv_message);
    
    return false;*/
    WHEN utl_http.end_of_body THEN
      --insert into jc.jc_log1 values ('3- ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); commit;    
      -- corregir
      --utl_http.end_response(resp);
      --apps.fnd_file.put_line(apps.fnd_file.log, 'Error end_of_body: ' || respval);
      pc_resultado := 'Error estructura xml (1): ' || SQLERRM; --|| respval;
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
      --
      SELECT a.aqpa460seri
            ,a.aqpa460num
            ,lpad(TRIM(a.aqpa460tcomf), 2, '0') AS tipocomprobante
        INTO vv_serial_comp
            ,vn_numero_comp
            ,vv_tipocomprobante
        FROM aqpa471 a
       WHERE 1 = 1
         AND a.aqpa471trxid = pn_trx_id;
    
      UPDATE aqpa471 h
         SET h.aqpa471status  = 'PEN_BT'
            ,h.aqpa471statusd = pc_resultado
            ,h.aqpa471ertci   = NULL
            ,h.aqpa471detci   = NULL
            ,h.aqpa471eres    = NULL
            ,h.aqpa471deres   = NULL
            ,h.aqpa471fepro   = SYSDATE
       WHERE h.aqpa471trxid = pn_trx_id;
    
      IF (vv_tipocomprobante IN ('01', '03')) THEN
        UPDATE aqpa465 h
           SET h.aqpa465est  = 'E'
              ,h.aqpa465msgs = pc_resultado
         WHERE h.aqpa465serie = vv_serial_comp
           AND h.aqpa465corr = vn_numero_comp;
      ELSIF (vv_tipocomprobante IN ('07', '08')) THEN
        UPDATE aqpa466 h
           SET h.aqpa466est  = 'E'
              ,h.aqpa466msgs = pc_resultado
         WHERE h.aqpa466serie = vv_serial_comp
           AND h.aqpa466corr = vn_numero_comp;
      END IF;
      --
      RETURN FALSE;
    WHEN OTHERS THEN
      vv_error_detalle := dbms_utility.format_error_backtrace;
      vv_error_corto   := SQLERRM;
      --insert into jc.jc_log1 values ('4-' || vv_url_http || '-'|| vv_error_corto || '-' || vv_error_detalle); commit;
      --dbms_output.put_line('Error WS: ' || sqlerrm);
      --apps.fnd_file.put_line(apps.fnd_file.log, 'Error WS: ' || sqlerrm);
      pc_resultado := vv_url_http || '-' || vv_error_corto || '-' || vv_error_detalle; --- || sqlerrm;
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
      UPDATE aqpa471
         SET aqpa471statusd = pc_resultado
            ,aqpa471status  = 'PEN_EMI'
            ,aqpa471ertci   = 'WS'
            ,aqpa471detci   = pc_resultado
            ,aqpa471eres    = NULL
            ,aqpa471deres   = NULL
            ,aqpa471fepro   = SYSDATE
       WHERE 1 = 1
         AND aqpa471trxid = pn_trx_id;
      RETURN FALSE;
  END fn_ar_env_procs_ws;

  -- *******************************************************************
  -- Nombre                    : FUNCION PARA CONFIRMAR STATUS WEBSERVICE
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : Confirma Status de WebService
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- *******************************************************************

  FUNCTION fn_ar_confirmar_status_ws(pc_proceso   VARCHAR2
                                    ,pn_trx_id    NUMBER
                                    ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN IS
  
    /*function fu_confirmar_status_ws(pc_proceso        varchar2
                                   ,pn_certificate_id number
                                   ,pc_resultado      in out varchar2) return boolean is
    */
    CURSOR c_main_ret IS
      SELECT a.aqpa471trxid
            ,a.aqpa460seri
            ,a.aqpa460num
            ,a.aqpa460femi
            ,a.aqpa460tcomf
            ,a.aqpa460mglo
            ,a.aqpa460mone
            ,a.aqpa460tope
            ,a.aqpa471todco
            ,a.aqpa460impt
            ,a.aqpa460mtimp
            ,a.aqpa471ibco
            ,a.aqpa460mtimp
            ,a.aqpa460pcima
            ,a.aqpa471cuid
            ,a.aqpa460nruc
            ,a.aqpa460rasoc
            ,a.aqpa460tdocr
            ,a.aqpa460corrr
            ,a.aqpa471source
            ,a.aqpa460rsoc
            ,a.aqpa460rucc
            ,a.aqpa471orad
            ,a.aqpa471prin1
            ,a.aqpa471prin2
            ,a.aqpa471prin3
            ,a.aqpa471tico
            ,a.aqpa471idcocl
             --,b.cert_detail_id      CORREGIR
             -- ,b.cert_line_number   CORREGIR
            ,b.aqpa460csuna
            ,b.aqpa460item
            ,b.aqpa460total
            ,b.aqpa460cantf
            ,b.aqpa460desc
            ,b.aqpa460vvun
            ,b.aqpa460pnetu
            ,b.aqpa460vvuig
            ,b.aqpa460ctpr
            ,b.aqpa460dete
            ,b.aqpa460csuna
            ,b.aqpa460imptb
            ,b.aqpa460ititm
            ,b.aqpa460afigv
            ,b.aqpa460codtb
            ,b.aqpa460dstrb
            ,b.aqpa460codun
            ,b.aqpa460mbim
            ,b.aqpa460taimp
        FROM aqpa471 a
            ,aqpa460 b
       WHERE 1 = 1
            --  and a.certificate_id = b.certificate_id
         AND a.aqpa460seri = b.aqpa460seri
         AND a.aqpa460num = b.aqpa460num
         AND a.aqpa471trxid = pn_trx_id;
  
    vc_invoice_serial VARCHAR2(50);
    vc_invoice_numero VARCHAR2(50);
    vc_mensaje        VARCHAR2(3000);
  BEGIN
  
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
  
    vn_count := 0;
  
    -- Obtiene el url del servidor web
    vv_url_http := fn_ar_get_url_http(pc_proceso); --CVEAS 
  
    req := utl_http.begin_request(url => vv_url_http, method => 'POST', http_version => 'HTTP/1.1');
    /*  
      if pc_proceso = 'RETENCION' then
      
        for x in c_main_ret loop
          if vn_count = 0 then
          
            if substr(x.invoice_serial, 1, 1) = '0' then
              vc_invoice_serial := lpad(x.invoice_serial, 4, '0');
            else
              -- vc_invoice_serial := 'E' || lpad(x.invoice_serial, 3, '0');
              vc_invoice_serial := x.invoice_serial;
            end if;
          
            begin
              vc_invoice_numero := to_number(x.invoice_numero);
            exception
              when others then
                vc_invoice_numero := x.invoice_numero;
            end;
          
            reqxml_0 := reqxml_0 ||
                        '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
            reqxml_0 := reqxml_0 || '<soap12:Body>';
            reqxml_0 := reqxml_0 || '<ConfirmarEstadoRetencion xmlns="http://tempuri.org/">';
            reqxml_0 := reqxml_0 || '<ent_ConfirmarEstado>';
            reqxml_0 := reqxml_0 || '<at_NumeroDocumentoIdentidad>' || x.organization_ruc ||
                        '</at_NumeroDocumentoIdentidad>';
            reqxml_0 := reqxml_0 || '<l_Comprobante>';
            reqxml_0 := reqxml_0 || '<en_ComprobanteConfirmarEstado>';
            reqxml_0 := reqxml_0 || '<at_Serie>' || vc_invoice_serial || '</at_Serie>';
            reqxml_0 := reqxml_0 || '<at_Numero>' || vc_invoice_numero || '</at_Numero>';
            reqxml_0 := reqxml_0 || '</en_ComprobanteConfirmarEstado>';
            reqxml_0 := reqxml_0 || '</l_Comprobante>';
            reqxml_0 := reqxml_0 || '</ent_ConfirmarEstado>';
            reqxml_0 := reqxml_0 || '</ConfirmarEstadoRetencion>';
            reqxml_0 := reqxml_0 || '</soap12:Body>';
            reqxml_0 := reqxml_0 || '</soap12:Envelope>';
            dbms_output.put_line('Error WS: ' || reqxml_0);
          
          end if;
        
          dbms_output.put_line('Error WS: ' || reqxml_1);
        end loop;
      
      elsif pc_proceso = 'REVERSION' then
      
        reqxml_3 := '';
      
      end if;
    */
    reqxml_4 := reqxml_0 || reqxml_1 || reqxml_2 || reqxml_3;
  
    pr_ar_xml_ws('INSERT', pc_proceso, pn_trx_id, reqxml_4, 'ConfirmarEstadoRetencion xmlns');
  
    -- corregir
    /*utl_http.set_transfer_timeout(60);
    utl_http.set_header(req, 'Content-Type', 'application/soap+xml; charset=utf-8');
    utl_http.set_header(req, 'Content-Length', length(reqxml_4));
    utl_http.write_text(req, reqxml_4);
    resp := utl_http.get_response(req);
    utl_http.read_text(resp, respval);
    apps.fnd_file.put_line(apps.fnd_file.log, respval);
    utl_http.end_response(resp);*/
  
    pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, '');
  
    pr_ar_data_ws(pc_proceso, pn_trx_id, respval, vc_mensaje);
  
    IF vc_mensaje IS NOT NULL THEN
      pc_resultado := vc_mensaje;
      RETURN FALSE;
    ELSE
      IF instr(respval, '<?xml version="1.0" encoding="utf-8"?') >= 1 THEN
        pc_resultado := NULL;
        RETURN TRUE;
      ELSE
        pc_resultado := NULL;
        RETURN FALSE;
      END IF;
    END IF;
  
  EXCEPTION
    --CVEAS <INI>
    WHEN ve_exc_2 THEN
    
      --apps.fnd_file.put_line(apps.fnd_file.output, 'Error WS: No hay datos para env?o');
      pc_resultado := 'Error WS: No hay datos para env?o';
    
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
    
      RETURN FALSE;
    
    WHEN ve_exc THEN
      --- apps.fnd_file.put_line(apps.fnd_file.output, vv_message);
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, vv_message);
    
      RETURN FALSE;
    WHEN utl_http.end_of_body THEN
      -- corregir
      --utl_http.end_response(resp);
      --
      --dbms_output.put_line('Error end_of_body: ' || respval);
      --- apps.fnd_file.put_line(apps.fnd_file.log, 'Error end_of_body: ' || respval);
      pc_resultado := 'Error estructura xml (2)'; --|| respval;
    
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
    
      RETURN FALSE;
    WHEN OTHERS THEN
      --dbms_output.put_line('Error WS: ' || sqlerrm);
      --- apps.fnd_file.put_line(apps.fnd_file.log, 'Error WS: ' || sqlerrm);
      pc_resultado := 'Error WS: ' || SQLERRM;
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
      RETURN FALSE;
    
  END fn_ar_confirmar_status_ws;

  -- *******************************************************************
  -- Nombre                    : FUNCION PARA ENVIAR STATUS A WEBSERVICE
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : Consulta el Estado del Documento
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- ******************************************************************* 

  FUNCTION fn_ar_env_status_ws(pc_proceso   VARCHAR2
                              ,pn_trx_id    NUMBER
                              ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN IS
  
    -- Consulta el Estado del Documento
    /* function fu_send_status_ws(pc_proceso        varchar2
    ,pn_certificate_id number
    ,pc_resultado      in out varchar2) return boolean is*/
  
    vv_error_detalle VARCHAR2(1500);
    vv_error_corto   VARCHAR2(1500);
    vv_codigohash    aqpa471.aqpa471coha%TYPE;
  
    CURSOR c_main_ret IS
      SELECT a.aqpa471trxid
            ,a.aqpa460seri
            ,a.aqpa460num
            ,a.aqpa460rucc
            ,lpad(TRIM(a.aqpa460tcomf), 2, '0') AS tipocomprobante
            ,a.aqpa471coha
        FROM aqpa471 a
       WHERE 1 = 1
         AND a.aqpa471trxid = pn_trx_id;
  
    vv_respuesta       VARCHAR2(15);
    vv_desc_respuesta  VARCHAR2(3000);
    vv_tipocomprobante VARCHAR2(2);
    vv_serial_comp     aqpa471.aqpa460seri%TYPE;
    vn_numero_comp     aqpa471.aqpa460num%TYPE;
  
  BEGIN
    --bv 26/12/2018
    pr_ar_log_bt('26');
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
  
    vn_count := 0;
  
    vv_url_http := fn_ar_get_url_http(pv_type => pc_proceso); --CVEAS CAMBIAR
  
    ----CVEAS---<INI>18122018
    pr_jc_insertar_log('ConsultarComprobanteIndividual', vn_id_log, pn_trx_id);
  
    req := utl_http.begin_request(url => vv_url_http, method => 'POST', http_version => 'HTTP/1.1');
  
    IF pc_proceso = 'FACTURACION' THEN
      vv_codigohash := NULL;
      --bv 26/12/2018
      pr_ar_log_bt('27');
      FOR x IN c_main_ret LOOP
        vn_count           := vn_count + 1;
        vv_tipocomprobante := x.tipocomprobante;
        vv_serial_comp     := x.aqpa460seri;
        vn_numero_comp     := x.aqpa460num;
        vv_codigohash      := x.aqpa471coha;
        reqxml_0           := '<?xml version="1.0" encoding="utf-8"?>';
        reqxml_0           := reqxml_0 ||
                              '  <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
        reqxml_0           := reqxml_0 || '    <soap12:Body>';
        reqxml_0           := reqxml_0 || '      <ConsultarComprobanteIndividual xmlns="http://tempuri.org/">';
        reqxml_0           := reqxml_0 || '        <oENconsulta>';
        reqxml_0           := reqxml_0 || '          <NComprobante>';
        reqxml_0           := reqxml_0 || '            <IdComprobanteCliente>0</IdComprobanteCliente>';
        reqxml_0           := reqxml_0 || '            <Numero>' || x.aqpa460num || '</Numero>';
        reqxml_0           := reqxml_0 || '            <Serie>' || x.aqpa460seri || '</Serie>';
        reqxml_0           := reqxml_0 || '            <TipoComprobante>' || x.tipocomprobante ||
                              '</TipoComprobante>';
        reqxml_0           := reqxml_0 || '          </NComprobante>';
        reqxml_0           := reqxml_0 || '          <TipoConsulta>1</TipoConsulta>';
        reqxml_0           := reqxml_0 || '          <RucEmpresa>' || x.aqpa460rucc || '</RucEmpresa>';
        reqxml_0           := reqxml_0 || '        </oENconsulta>';
        reqxml_0           := reqxml_0 || '      </ConsultarComprobanteIndividual>';
        reqxml_0           := reqxml_0 || '    </soap12:Body>';
        reqxml_0           := reqxml_0 || '  </soap12:Envelope>';
      
      /*reqxml_0 := '<?xml version="1.0" encoding="utf-8"?>';
                                                                                                                                                              reqxml_0 := reqxml_0 || '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
                                                                                                                                                              reqxml_0 := reqxml_0 || '<soap12:Body>';
                                                                                                                                                              reqxml_0 := reqxml_0 || '<ConsultarComprobanteIndividual xmlns="http://tempuri.org/">';
                                                                                                                                                              reqxml_0 := reqxml_0 || '<ent_ConsultarComprobanteIndividual>';
                                                                                                                                                              reqxml_0 := reqxml_0 || '<at_NumeroDocumentoIdentidad>' || x.organization_ruc || '</at_NumeroDocumentoIdentidad>';
                                                                                                                                                              reqxml_0 := reqxml_0 || '<at_Serie>' || x.serial_comp || '</at_Serie>';
                                                                                                                                                              reqxml_0 := reqxml_0 || '<at_Numero>' || x.numero_comp || '</at_Numero>';
                                                                                                                                                              reqxml_0 := reqxml_0 || '</ent_ConsultarComprobanteIndividual>';
                                                                                                                                                              reqxml_0 := reqxml_0 || '</ConsultarComprobanteIndividual>';
                                                                                                                                                              reqxml_0 := reqxml_0 || '</soap12:Body>';
                                                                                                                                                              reqxml_0 := reqxml_0 || '</soap12:Envelope>';*/
      
      END LOOP;
      --bv 26/12/2018
      pr_ar_log_bt('28');
    END IF;
  
    reqxml_4 := reqxml_0;
  
    -- CORREGIR  
    pr_ar_xml_ws('INSERT', pc_proceso, pn_trx_id, reqxml_4, '');
  
    utl_http.set_transfer_timeout(60);
    utl_http.set_header(req, 'Content-Type', 'application/soap+xml; charset=utf-8');
    utl_http.set_header(req, 'Content-Length', length(reqxml_4));
    utl_http.write_text(req, reqxml_4);
    resp := utl_http.get_response(req);
    utl_http.read_text(resp, respval);
    utl_http.end_response(resp);
  
    pr_jc_actualizar_log(vn_id_log);
    ----CVEAS---<FIN>18122018
  
    /*    pc_resultado := respval;
    */
    pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, '');
  
    pr_ar_data_ws_sunat(pc_proceso, respval, vv_respuesta, vv_desc_respuesta);
  
    -- En caso de BOLETAS, lo marcamos como ACEPTADO directamente                       
    IF (vv_tipocomprobante = '03') THEN
      respval      := '<?xml version="1.0" encoding="utf-8"?';
      vv_respuesta := '0';
    END IF;
  
    IF instr(respval, '<?xml version="1.0" encoding="utf-8"?') >= 1 THEN
    
      IF (vv_respuesta IN ('0')) THEN
        -- Aceptado por SUNAT
        UPDATE aqpa471 h
           SET h.aqpa471status  = 'ACEPTADO'
              ,h.aqpa471statusd = 'Aceptado por SUNAT'
              ,h.aqpa471ertci   = NULL
              ,h.aqpa471detci   = NULL
              ,h.aqpa471eres    = vv_respuesta
              ,h.aqpa471deres   = NULL
              ,h.aqpa471fepro   = SYSDATE
        --h.AQPA471RIDAC  = gn_request_id
         WHERE h.aqpa471trxid = pn_trx_id;
        IF (vv_tipocomprobante IN ('01', '03')) THEN
          UPDATE aqpa465 h
             SET h.aqpa465est  = 'A'
                ,h.aqpa465hash = vv_codigohash
                ,h.aqpa465msgs = vv_desc_respuesta
           WHERE h.aqpa465serie = vv_serial_comp
             AND h.aqpa465corr = vn_numero_comp;
        ELSIF (vv_tipocomprobante IN ('07', '08')) THEN
          UPDATE aqpa466 h
             SET h.aqpa466est  = 'A'
                ,h.aqpa466hash = vv_codigohash
                ,h.aqpa466msgs = vv_desc_respuesta
           WHERE h.aqpa466serie = vv_serial_comp
             AND h.aqpa466corr = vn_numero_comp;
        END IF;
        --                   
      ELSIF (vv_respuesta IN ('3')) THEN
        -- Aceptado por SUNAT con Observaciones
        UPDATE aqpa471 h
           SET h.aqpa471status  = 'ACEPTADO'
              ,h.aqpa471statusd = 'Aceptado por SUNAT con observaciones. ' || vv_desc_respuesta
              ,h.aqpa471ertci   = NULL
              ,h.aqpa471detci   = NULL
              ,h.aqpa471eres    = vv_respuesta
              ,h.aqpa471deres   = vv_desc_respuesta
              ,h.aqpa471fepro   = SYSDATE
        --h.AQPA471RIDCA  = gn_request_id
         WHERE h.aqpa471trxid = pn_trx_id;
        IF (vv_tipocomprobante IN ('01', '03')) THEN
          UPDATE aqpa465 h
             SET h.aqpa465est  = 'A'
                ,h.aqpa465msgs = vv_desc_respuesta
                ,h.aqpa465hash = vv_codigohash
           WHERE h.aqpa465serie = vv_serial_comp
             AND h.aqpa465corr = vn_numero_comp;
        ELSIF (vv_tipocomprobante IN ('07', '08')) THEN
          UPDATE aqpa466 h
             SET h.aqpa466est  = 'A'
                ,h.aqpa466msgs = vv_desc_respuesta
                ,h.aqpa466hash = vv_codigohash
           WHERE h.aqpa466serie = vv_serial_comp
             AND h.aqpa466corr = vn_numero_comp;
        END IF;
      ELSIF (vv_respuesta IN ('1')) THEN
        -- Rechazado por SUNAT
        UPDATE aqpa471 h
           SET h.aqpa471status  = 'RECHAZADO'
              ,h.aqpa471statusd = 'Rechazado por SUNAT. ' || vv_desc_respuesta
              ,h.aqpa471ertci   = NULL
              ,h.aqpa471detci   = NULL
              ,h.aqpa471eres    = vv_respuesta
              ,h.aqpa471deres   = vv_desc_respuesta
              ,h.aqpa471fepro   = SYSDATE
        --h.AQPA471RIDCA  = gn_request_id
         WHERE h.aqpa471trxid = pn_trx_id;
        IF (vv_tipocomprobante IN ('01', '03')) THEN
          UPDATE aqpa465 h
             SET h.aqpa465est  = 'R'
                ,h.aqpa465msgs = vv_desc_respuesta
           WHERE h.aqpa465serie = vv_serial_comp
             AND h.aqpa465corr = vn_numero_comp;
        ELSIF (vv_tipocomprobante IN ('07', '08')) THEN
          UPDATE aqpa466 h
             SET h.aqpa466est  = 'R'
                ,h.aqpa466msgs = vv_desc_respuesta
           WHERE h.aqpa466serie = vv_serial_comp
             AND h.aqpa466corr = vn_numero_comp;
        END IF;
      ELSIF (vv_respuesta IN ('-3', '-1')) THEN
        -- Error de WS
        UPDATE aqpa471 h
           SET h.aqpa471status  = 'PEN_ACT_EST'
              ,h.aqpa471statusd = 'Error de WebService. ' || vv_desc_respuesta
              ,h.aqpa471ertci   = NULL
              ,h.aqpa471detci   = NULL
              ,h.aqpa471eres    = vv_respuesta
              ,h.aqpa471deres   = 'Error de WebService. ' || vv_desc_respuesta
              ,h.aqpa471fepro   = SYSDATE
        --h.AQPA471RIDCA  = gn_request_id
         WHERE h.aqpa471trxid = pn_trx_id;
      ELSIF (vv_respuesta IN ('2', '4')) THEN
        -- Corregir BT
        UPDATE aqpa471 h
           SET h.aqpa471status  = 'PEN_BT'
              ,h.aqpa471statusd = 'Error de Trama (1). ' || vv_desc_respuesta
              ,h.aqpa471ertci   = NULL
              ,h.aqpa471detci   = NULL
              ,h.aqpa471eres    = vv_respuesta
              ,h.aqpa471deres   = 'Error de Trama (1). ' || vv_desc_respuesta
              ,h.aqpa471fepro   = SYSDATE
        --h.AQPA471RIDCA  = gn_request_id
         WHERE h.aqpa471trxid = pn_trx_id;
        IF (vv_tipocomprobante IN ('01', '03')) THEN
          UPDATE aqpa465 h
             SET h.aqpa465est  = 'E'
                ,h.aqpa465msgs = vv_desc_respuesta
           WHERE h.aqpa465serie = vv_serial_comp
             AND h.aqpa465corr = vn_numero_comp;
        ELSIF (vv_tipocomprobante IN ('07', '08')) THEN
          UPDATE aqpa466 h
             SET h.aqpa466est  = 'E'
                ,h.aqpa466msgs = vv_desc_respuesta
           WHERE h.aqpa466serie = vv_serial_comp
             AND h.aqpa466corr = vn_numero_comp;
        END IF;
      ELSIF (vv_respuesta IN ('-2')) THEN
        -- Volver a Enviar a TCI
        UPDATE aqpa471 h
           SET h.aqpa471status  = 'PEN_EMI'
              ,h.aqpa471statusd = 'Error al Registrar en TCI. ' || vv_desc_respuesta
              ,h.aqpa471ertci   = NULL
              ,h.aqpa471detci   = NULL
              ,h.aqpa471eres    = vv_respuesta
              ,h.aqpa471deres   = 'Error al Registrar en TCI. ' || vv_desc_respuesta
              ,h.aqpa471fepro   = SYSDATE
        --h.AQPA471RIDCA  = gn_request_id
         WHERE h.aqpa471trxid = pn_trx_id;
        /*else 
        update JC.JC_EDE_LO_AR_HEADER_ALL h
           set 
               h.STATUS_OF = 'PEN_ACT_EST'
               ,h.STAacTUS_OF_DESC = decode(vv_respuesta,
                                             '2' , 'Hubo una excepción y es necesario volver a enviar',
                                             '-2', 'No existe el comprobante',
                                             '-3', 'Ocurrió un error en el proceso',
                                             '-1', 'No hay respuesta',
                                             '4' , 'No paso el proceso de Validación',
                                             null
                                            ) || vv_desc_respuesta
               ,h.ERROR_TCI = null
               ,h.DESC_ERROR_TCI = null
               ,h.ERROR_ESTADO = vv_respuesta
               ,h.DESC_ERROR_ESTADO = decode(vv_respuesta,
                                             '2' , 'Hubo una excepción y es necesario volver a enviar',
                                             '-2', 'No existe el comprobante',
                                             '-3', 'Ocurrió un error en el proceso',
                                             '-1', 'No hay respuesta',
                                             '4' , 'No paso el proceso de Validación',
                                             null
                                            ) || vv_desc_respuesta
         where h.certificate_id = pn_certificate_id;  */
      END IF;
    
      /*if (vv_respuesta in ('0', '3')) then -- Aceptado por SUNAT / Aceptado por SUNAT con Observaciones
        declare
          vv_resultado varchar2(1500);
          vb_retorno boolean;
        begin
      
          vb_retorno :=
          jc.jc_ede_lo_ar_webservice_pkg.fu_obtener_xml_ws
          (
          'FACTURACION'
          ,3114
          ,vv_resultado 
          );
        end;                            
      
        declare
          vv_resultado varchar2(1500);
          vb_retorno boolean;
        begin
      
          vb_retorno :=
          jc.jc_ede_lo_ar_webservice_pkg.fu_obtener_pdf_ws
          (
          'FACTURACION'
          ,3114
          ,vv_resultado 
          );
        end;
      end if;*/
    
      COMMIT;
      RETURN TRUE;
    ELSE
      -- corregir
      UPDATE aqpa471 h
         SET h.aqpa471status  = 'PEN_ACT_EST'
            ,h.aqpa471statusd = 'Error de Formato en Trama de Retorno 2'
            ,h.aqpa471ertci   = NULL
            ,h.aqpa471detci   = NULL
            ,h.aqpa471eres    = 'WS'
            ,h.aqpa471deres   = 'Error de Formato en Trama de Retorno 2'
            ,h.aqpa471fepro   = SYSDATE
      --h.AQPA471RIDCA  = gn_request_id
       WHERE h.aqpa471trxid = pn_trx_id;
      pc_resultado := NULL;
      RETURN FALSE;
    END IF;
  
    /*if vc_mensaje is not null then
      pc_resultado := vc_mensaje;
      return false;
    else
      if instr(respval, '<?xml version="1.0" encoding="utf-8"?') >= 1 then
        pc_resultado := null;
        update JC.JC_EDE_LO_AR_HEADER_ALL h
           set 
               h.STATUS_OF = ''
               ,h.STATUS_OF_DESC = ''
               ,h.ERROR_TCI = null
               ,h.DESC_ERROR_TCI = null
               ,h.ERROR_ESTADO = ''
               ,h.DESC_ERROR_ESTADO = '' -- corregir
         where h.certificate_id = pn_certificate_id;
         commit;
        return true;
      else
        update JC.JC_EDE_LO_AR_HEADER_ALL h
           set 
               h.STATUS_OF = 'PEN_ACT_EST'
               ,h.STATUS_OF_DESC = 'Error de Formato en Trama de Retorno'
               ,h.ERROR_TCI = null
               ,h.DESC_ERROR_TCI = null
               ,h.ERROR_ESTADO = 'WS'
               ,h.DESC_ERROR_ESTADO = 'Error de Formato en Trama de Retorno'
         where h.certificate_id = pn_certificate_id;        
        pc_resultado := null;
        return false;
      end if;
    end if;*/
  
  EXCEPTION
    /*when ve_exc_2 then
    
    apps.fnd_file.put_line(apps.fnd_file.output, 'Error WS: No hay datos para env?o');
    pc_resultado := 'Error WS: No hay datos para env?o';
    
    pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, pc_resultado);
    
    return false;*/
  
    /*when ve_exc then
    apps.fnd_file.put_line(apps.fnd_file.output, vv_message);
    pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, vv_message);
    
    return false;*/
    WHEN utl_http.end_of_body THEN
      -- corregir
      --utl_http.end_response(resp);
      --
      --dbms_output.put_line('Error end_of_body: ' || respval);
      --apps.fnd_file.put_line(apps.fnd_file.log, 'Error end_of_body: ' || respval);
      vv_error_detalle := dbms_utility.format_error_backtrace;
      vv_error_corto   := SQLERRM;
      pc_resultado     := 'Error estructura xml (3) - ' || vv_error_corto || ' - ' || vv_error_detalle;
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
      UPDATE aqpa471 h
         SET h.aqpa471status  = 'PEN_ACT_EST'
            ,h.aqpa471statusd = 'a ' || pc_resultado
            , -- corregir
             h.aqpa471ertci   = NULL
            ,h.aqpa471detci   = NULL
            ,h.aqpa471eres    = 'WS'
            ,h.aqpa471deres   = pc_resultado
            ,h.aqpa471fepro   = SYSDATE
      --h.AQPA471RIDCA  = gn_request_id
       WHERE h.aqpa471trxid = pn_trx_id;
      COMMIT;
      RETURN FALSE;
    WHEN OTHERS THEN
      --dbms_output.put_line('Error WS: ' || sqlerrm);
      --apps.fnd_file.put_line(apps.fnd_file.log, 'Error WS: ' || sqlerrm);
      vv_error_detalle := dbms_utility.format_error_backtrace;
      vv_error_corto   := SQLERRM;
      pc_resultado     := vv_error_corto || ' - ' || vv_error_detalle;
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
      UPDATE aqpa471 h
         SET h.aqpa471status  = 'PEN_ACT_EST'
            ,h.aqpa471statusd = 'b ' || pc_resultado
            , -- corregir
             h.aqpa471ertci   = NULL
            ,h.aqpa471detci   = NULL
            ,h.aqpa471eres    = 'WS'
            ,h.aqpa471deres   = pc_resultado
            ,h.aqpa471fepro   = SYSDATE
      --h.AQPA471RIDCA  = gn_request_id
       WHERE h.aqpa471trxid = pn_trx_id;
      COMMIT;
      RETURN FALSE;
  END fn_ar_env_status_ws;

  -- *******************************************************************
  -- Nombre                    : PROCESO PARA REVISAR LA TRAMA XML
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- ******************************************************************* 

  -- Revisa la trama XML de respuesta retornada por el proveedor, del metodo REGISTRAR
  PROCEDURE pr_ar_data_ws(pc_proceso IN VARCHAR2
                         ,pn_trx_id  NUMBER
                         ,vc_date    IN VARCHAR2
                         ,pc_mensaje OUT VARCHAR2) IS
  
    vn_point_ini            NUMBER := 0;
    vn_point_fin            NUMBER := 0;
    vc_point_ini            VARCHAR2(3000);
    vc_point_fin            VARCHAR2(3000);
    vc_val_resultado        VARCHAR2(3000);
    vc_val_codigohash       VARCHAR2(3000);
    vc_val_mensajeresultado VARCHAR2(3000);
    vc_val_nombrexml        VARCHAR2(3000);
    vc_val_codigoerror      VARCHAR2(3000);
    vv_error_xml            VARCHAR2(500);
    vv_serial_comp          aqpa471.aqpa460seri%TYPE;
    vn_numero_comp          aqpa471.aqpa460num%TYPE;
    vv_tipo_comp            aqpa471.aqpa460tcomf%TYPE;
    vv_resultado            VARCHAR2(10);
    vv_desc_resultado       VARCHAR2(3000);
    vc_soap_text            VARCHAR2(3000);
  
  BEGIN
    --bv 26/12/2018
    pr_ar_log_bt('29');
    pc_mensaje := NULL;
  
    IF pc_proceso = 'FACTURACION' THEN
    
      vc_point_ini            := '<at_NivelResultado>';
      vc_point_fin            := '</at_NivelResultado>';
      vn_point_ini            := instr(vc_date, vc_point_ini);
      vn_point_fin            := instr(vc_date, vc_point_fin);
      vc_val_resultado        := substr(vc_date
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
      vc_point_ini            := '<at_MensajeResultado>';
      vc_point_fin            := '</at_MensajeResultado>';
      vn_point_ini            := instr(vc_date, vc_point_ini);
      vn_point_fin            := instr(vc_date, vc_point_fin);
      vc_val_mensajeresultado := substr(vc_date
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      vc_point_ini       := '<at_NombreXML>';
      vc_point_fin       := '</at_NombreXML>';
      vn_point_ini       := instr(vc_date, vc_point_ini);
      vn_point_fin       := instr(vc_date, vc_point_fin);
      vc_val_nombrexml   := substr(vc_date
                                  ,vn_point_ini + length(vc_point_ini)
                                  ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
      vc_point_ini       := '<at_CodigoError>';
      vc_point_fin       := '</at_CodigoError>';
      vn_point_ini       := instr(vc_date, vc_point_ini);
      vn_point_fin       := instr(vc_date, vc_point_fin);
      vc_val_codigoerror := substr(vc_date
                                  ,vn_point_ini + length(vc_point_ini)
                                  ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      -- RegistrarResult : false / true
      vc_point_ini := '<RegistrarResult>';
      vc_point_fin := '</RegistrarResult>';
      vn_point_ini := instr(vc_date, vc_point_ini);
      vn_point_fin := instr(vc_date, vc_point_fin);
      vv_resultado := substr(vc_date
                            ,vn_point_ini + length(vc_point_ini)
                            ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      -- Cadena
      vc_point_ini      := '<Cadena>';
      vc_point_fin      := '</Cadena>';
      vn_point_ini      := instr(vc_date, vc_point_ini);
      vn_point_fin      := instr(vc_date, vc_point_fin);
      vv_desc_resultado := substr(vc_date
                                 ,vn_point_ini + length(vc_point_ini)
                                 ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      -- Error de cuerpo XML
      vc_point_ini := '<p>';
      vc_point_fin := '</p>';
      vn_point_ini := instr(vc_date, vc_point_ini);
      vn_point_fin := instr(vc_date, vc_point_fin);
      vv_error_xml := substr(vc_date
                            ,vn_point_ini + length(vc_point_ini)
                            ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      -- Codigo Hash
      vc_point_ini      := '<CodigoHash>';
      vc_point_fin      := '</CodigoHash>';
      vn_point_ini      := instr(vc_date, vc_point_ini);
      vn_point_fin      := instr(vc_date, vc_point_fin);
      vc_val_codigohash := substr(vc_date
                                 ,vn_point_ini + length(vc_point_ini)
                                 ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      -- Error trama
      vc_point_ini := '<soap:Text xml:lang="es">';
      vc_point_fin := '</soap:Text>';
      vn_point_ini := instr(vc_date, vc_point_ini);
      vn_point_fin := instr(vc_date, vc_point_fin);
      vc_soap_text := substr(vc_date
                            ,vn_point_ini + length(vc_point_ini)
                            ,(vn_point_fin - vn_point_ini) - length(vc_point_ini));
    
      SELECT h.aqpa460seri
            ,h.aqpa460num
            , /*h.AQPA460TCOMP*/h.aqpa460tcomf
        INTO vv_serial_comp
            ,vn_numero_comp
            ,vv_tipo_comp
        FROM aqpa471 h
       WHERE h.aqpa471trxid = pn_trx_id;
    
      IF (upper(vv_resultado) = 'TRUE') THEN
        --
        UPDATE aqpa471
           SET aqpa471statusd = NULL
              , -- nvl(vc_val_mensajeresultado, AQPA471STATUSD),
               aqpa471coha    = nvl(vc_val_codigohash, aqpa471coha)
              ,aqpa471status  = 'PEN_ACT_EST'
              ,aqpa471ertci   = NULL
              ,aqpa471detci   = NULL
              ,aqpa471eres    = NULL
              ,aqpa471deres   = NULL
              ,aqpa471fepro   = SYSDATE
        --AQPA471RIDEM  = gn_request_id
        --
         WHERE 1 = 1
           AND aqpa471trxid = pn_trx_id;
      
        /*if (vv_TIPO_COMP = '01') then
           update AQPA465@BT h
              set h.AQPA465HASH = vc_val_codigohash
            where h.AQPA465SERIE = vv_SERIAL_COMP
              and h.AQPA465CORR  = vn_NUMERO_COMP;                 
        elsif (vv_TIPO_COMP = '07') then
           update AQPA466@BT h
              set h.AQPA466HASH = vc_val_codigohash
            where h.AQPA466SERIE = vv_SERIAL_COMP
              and h.AQPA466CORR  = vn_NUMERO_COMP;
        end if;   */
        --
      ELSE
        --
        pc_mensaje := nvl(vc_val_mensajeresultado, 'Error no registrado');
      
        --
        UPDATE aqpa471
           SET aqpa471statusd = 'Error de Trama (2). ' || vv_desc_resultado || ' - ' || vc_soap_text ||
                                decode(vv_resultado, NULL, vv_error_xml, NULL)
              ,aqpa471coha    = NULL
              ,aqpa471status  = 'PEN_BT'
              ,aqpa471ertci   = 'TRAMA'
              ,aqpa471detci   = 'Error de Trama (2). ' || vv_desc_resultado || ' - ' || vc_soap_text ||
                                decode(vv_resultado, NULL, vv_error_xml, NULL)
              ,aqpa471eres    = NULL
              ,aqpa471deres   = NULL
              ,aqpa471fepro   = SYSDATE
        --
         WHERE 1 = 1
           AND aqpa471trxid = pn_trx_id;
        IF (vv_tipo_comp IN ('01', '03')) THEN
          UPDATE aqpa465 h
             SET h.aqpa465hash = NULL
                ,h.aqpa465est  = 'E'
                ,h.aqpa465msgs = vv_desc_resultado || ' - ' || vc_soap_text ||
                                 decode(vv_resultado, NULL, vv_error_xml, NULL)
           WHERE h.aqpa465serie = vv_serial_comp
             AND h.aqpa465corr = vn_numero_comp;
        ELSIF (vv_tipo_comp IN ('07', '08')) THEN
          UPDATE aqpa466 h
             SET h.aqpa466hash = NULL
                ,h.aqpa466est  = 'E'
                ,h.aqpa466msgs = vv_desc_resultado || ' - ' || vc_soap_text ||
                                 decode(vv_resultado, NULL, vv_error_xml, NULL)
           WHERE h.aqpa466serie = vv_serial_comp
             AND h.aqpa466corr = vn_numero_comp;
        END IF;
      END IF;
    
    END IF;
    --bv 26/12/2018
    pr_ar_log_bt('30');
  END;

  -- *******************************************************************
  -- Nombre                    : PROCESO PARA REVISAR LA TRAMA XML ACTUALIZA ESTADOS
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- ******************************************************************* 

  -- Revisa la trama XML de respuesta retornada por el proveedor (SUNAT - Actualiza estados)
  PROCEDURE pr_ar_data_ws_sunat(pc_proceso        IN VARCHAR2
                               ,vc_date           IN VARCHAR2
                               ,pv_respuesta      OUT VARCHAR2
                               ,pv_desc_respuesta OUT VARCHAR2) IS
  
    vn_point_ini            NUMBER := 0;
    vn_point_fin            NUMBER := 0;
    vc_point_ini            VARCHAR2(3000);
    vc_point_fin            VARCHAR2(3000);
    vc_val_resultado        VARCHAR2(3000);
    vc_val_codigohash       VARCHAR2(3000);
    vc_val_mensajeresultado VARCHAR2(3000);
    vc_val_nombrexml        VARCHAR2(3000);
    vc_val_codigoerror      VARCHAR2(3000);
    vv_serial_comp          aqpa471.aqpa460seri%TYPE;
    vn_numero_comp          aqpa471.aqpa460num%TYPE;
  
  BEGIN
  
    --pv_codigo_error := null;
  
    IF pc_proceso = 'FACTURACION' THEN
    
      /*vc_point_ini            := '<at_NivelResultado>';
      vc_point_fin            := '</at_NivelResultado>';
      vn_point_ini            := instr(vc_date, vc_point_ini);
      vn_point_fin            := instr(vc_date, vc_point_fin);
      vc_val_resultado        := substr(vc_date
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
      vc_point_ini            := '<at_MensajeResultado>';
      vc_point_fin            := '</at_MensajeResultado>';
      vn_point_ini            := instr(vc_date, vc_point_ini);
      vn_point_fin            := instr(vc_date, vc_point_fin);
      vc_val_mensajeresultado := substr(vc_date
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
      vc_point_ini            := '<at_CodigoHash>';
      vc_point_fin            := '</at_CodigoHash>';
      vn_point_ini            := instr(vc_date, vc_point_ini);
      vn_point_fin            := instr(vc_date, vc_point_fin);
      vc_val_codigohash       := substr(vc_date
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
      vc_point_ini            := '<at_NombreXML>';
      vc_point_fin            := '</at_NombreXML>';
      vn_point_ini            := instr(vc_date, vc_point_ini);
      vn_point_fin            := instr(vc_date, vc_point_fin);
      vc_val_nombrexml        := substr(vc_date
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);*/
      vc_point_ini := '<Respuesta>';
      vc_point_fin := '</Respuesta>';
      vn_point_ini := instr(vc_date, vc_point_ini);
      vn_point_fin := instr(vc_date, vc_point_fin);
      pv_respuesta := substr(vc_date
                            ,vn_point_ini + length(vc_point_ini)
                            ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      vc_point_ini      := '<DescripcionRespuesta>';
      vc_point_fin      := '</DescripcionRespuesta>';
      vn_point_ini      := instr(vc_date, vc_point_ini);
      vn_point_fin      := instr(vc_date, vc_point_fin);
      pv_desc_respuesta := substr(vc_date
                                 ,vn_point_ini + length(vc_point_ini)
                                 ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
    END IF;
  
  END;

  -- *******************************************************************
  -- Nombre                    : PROCESO PARA CARGAR LA TABLA DE TRAMAS
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- ******************************************************************* 

  -- Carga en la tabla: jc.jc_ede_lo_ar_xml_all
  PROCEDURE pr_ar_xml_ws(pc_tipo    IN VARCHAR2
                        ,pc_proceso IN VARCHAR2
                        ,pn_trx_id  IN NUMBER
                        ,pc_xml     IN CLOB
                        ,pc_obs     IN VARCHAR2) IS
  
  BEGIN
    -- Call the function
  
    IF pc_tipo = 'INSERT' THEN
    
      SELECT SQ_CR_EDE_LO_AR_XML.nextval
        INTO vn_xml_id
        FROM dual;
    
      INSERT INTO aqpa473
        (aqpa473xmlid
        ,aqpa473trxid
        ,aqpa473proc
        ,aqpa473xmle
        ,aqpa473obsv
         -- ,org_id
         -- ,created_by
        ,aqpa473freg
         -- ,last_updated_by
        ,aqpa473fact
         --,last_update_login
        ,aqpa473tipo_de_ws)
      VALUES
        (vn_xml_id
        ,pn_trx_id
        ,pc_proceso
        ,pc_xml
        ,substr(pc_obs, 1, 3600)
         -- ,apps.fnd_global.org_id    --CVEAS
         --,apps.fnd_global.user_id
        ,SYSDATE
         --,apps.fnd_global.user_id
        ,SYSDATE
         -- ,apps.fnd_global.login_id
        ,pc_obs);
    
    ELSIF pc_tipo = 'UPDATE' THEN
    
      UPDATE aqpa473
         SET aqpa473xmlr = pc_xml
             --,last_updated_by  = apps.fnd_global.user_id
            ,aqpa473fact = SYSDATE
            ,aqpa473obsv = substr(nvl(aqpa473obsv, '') || '-' || pc_obs, 1, 3600)
       WHERE 1 = 1
         AND aqpa473xmlid = vn_xml_id;
    
    END IF;
  
    COMMIT;
  
    /*  exception
    when others then
      null;*/
  END;

  /*function fu_get_val_ref_cia(p_value apps.fnd_flex_values_vl.flex_value%type) return varchar2 is
  
    v_description apps.fnd_flex_values_vl.description%type;
  
  begin
  
    select fv.description
      into v_description
      from apps.fnd_flex_value_sets fvs
          ,apps.fnd_flex_values_vl  fv
     where fvs.flex_value_set_name = 'JC_CRE_LO_AP_REFERENCIAL'
       and fvs.flex_value_set_id = fv.flex_value_set_id
       and fv.enabled_flag = 'Y'
       and fv.flex_value = p_value;
  
    return v_description;
  
  exception
    when others then
    
      v_description := null;
      return v_description;
    
  end fu_get_val_ref_cia;*/

  -- WS ADICIONALES

  -- *******************************************************************
  -- Nombre                    : FUNCION PARA OBTENER XML DE WEBSERVICE
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : OBTENER XML
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- *******************************************************************    

  FUNCTION fn_ar_obtener_xml_ws(pc_proceso   VARCHAR2
                               ,pn_trx_id    NUMBER
                               ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN IS
  
    /*
    function fu_obtener_xml_ws(pc_proceso        varchar2
                                ,pn_certificate_id number
                                ,pc_resultado      in out varchar2) return boolean is*/
  
    vv_error_detalle VARCHAR2(1500);
    vv_error_corto   VARCHAR2(1500);
  
    CURSOR c_main_ret IS
      SELECT a.aqpa471trxid
            ,a.aqpa460seri
            ,a.aqpa460num
            ,a.aqpa460rucc
            ,a.aqpa460tcomf
        FROM aqpa471 a
       WHERE 1 = 1
         AND a.aqpa471trxid = pn_trx_id;
  
    vc_mensaje VARCHAR2(3000);
    l_text     VARCHAR2(32767);
    l_clob     CLOB;
  
  BEGIN
  
    reqxml_0 := NULL;
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
  
    vn_count := 0;
  
    vv_url_http := fn_ar_get_url_http(pv_type => pc_proceso); --CVEAS CAMBIAR
  
    IF pc_proceso = 'FACTURACION' /*'Obtener_XML'*/
     THEN
    
      FOR x IN c_main_ret LOOP
        vn_count := vn_count + 1;
        --reqxml_0 := '<?xml version="1.0" encoding="utf-8"?>';
        reqxml_0 := reqxml_0 || '<?xml version="1.0" encoding="UTF-8"?>';
        --reqxml_0 := reqxml_0 ||
        --            '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
        reqxml_0 := reqxml_0 || chr(10) ||
                    '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
        --reqxml_0 := reqxml_0 || '<soap12:Body>';
        reqxml_0 := reqxml_0 || chr(10) ||
                    '   <soap12:Body xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        reqxml_0 := reqxml_0 || '<Obtener_XML xmlns="http://tempuri.org/">';
        reqxml_0 := reqxml_0 || '<oENPeticion>';
        reqxml_0 := reqxml_0 || '<IndicadorComprobante>' || 0 /*x.certificate_id*/
                    || --Comprobantes Emitidos
                    '</IndicadorComprobante>';
        reqxml_0 := reqxml_0 || '<Serie>' || x.aqpa460seri || '</Serie>';
        reqxml_0 := reqxml_0 || '<Numero>' || x.aqpa460num || '</Numero>';
        reqxml_0 := reqxml_0 || '<TipoComprobante>' || lpad(x.aqpa460tcomf, 2, 0) || '</TipoComprobante>';
        reqxml_0 := reqxml_0 || '<Ruc>' || x.aqpa460rucc || '</Ruc>';
        reqxml_0 := reqxml_0 || '</oENPeticion>';
        --reqxml_0 := reqxml_0 || '<Cadena>' || x.numero_comp || '</Cadena>';
        reqxml_0 := reqxml_0 || '</Obtener_XML>';
        reqxml_0 := reqxml_0 || '</soap12:Body>';
        reqxml_0 := reqxml_0 || '</soap12:Envelope>';
      END LOOP;
    
    END IF;
  
    reqxml_4 := reqxml_0;
  
    pr_ar_xml_ws('INSERT', pc_proceso, pn_trx_id, reqxml_4, 'Obtener_XML xmlns');
  
    utl_http.set_persistent_conn_support(TRUE);
  
    ----CVEAS---<INI>18122018
    pr_jc_insertar_log('Obtener_XML', vn_id_log, pn_trx_id);
  
    req := utl_http.begin_request(url => vv_url_http, method => 'POST', http_version => 'HTTP/1.1');
    utl_http.set_transfer_timeout(60);
    utl_http.set_header(req, 'Content-Type', 'application/soap+xml; charset=utf-8');
    utl_http.set_header(req, 'Content-Length', length(reqxml_4));
    utl_http.write_text(req, reqxml_4);
    resp := utl_http.get_response(req);
  
    pr_jc_actualizar_log(vn_id_log);
    ----CVEAS---<FIN>18122018     
  
    --
    --utl_http.read_text(resp, respval);
    dbms_lob.createtemporary(l_clob, FALSE);
    BEGIN
      LOOP
        utl_http.read_text(resp, l_text, 32766);
        dbms_lob.writeappend(l_clob, length(l_text), l_text);
      END LOOP;
      utl_http.end_response(resp);
    EXCEPTION
      WHEN utl_http.end_of_body THEN
        utl_http.end_response(resp);
    END;
    --
    --apps.fnd_file.put_line(apps.fnd_file.log, respval);
    --utl_http.end_response(resp);
  
    -- corregir
    --dbms_output.put_line(respval);
    --
  
    pc_resultado := NULL; --respval;
  
    vc_mensaje := NULL;
  
    pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, l_clob /*respval*/, '');
  
    pr_ar_data_ws_xml(pc_proceso, /*respval*/ l_clob, vc_mensaje, /*reqxml_4*/ /*gc_clob*/ gc_clob1, reqxml_0);
    --dbms_output.put_line('reqxml_3 = '||respval); 
    --dbms_output.put_line('reqxml_2 = '||reqxml_0); 
  
    UPDATE aqpa473
       SET aqpa473caxml = gc_clob1 /*gc_clob*/ /*reqxml_4*/ --reqxml_0
           --,last_updated_by  = apps.fnd_global.user_id
          ,aqpa473fact = SYSDATE
     WHERE 1 = 1
          --and AQPA473TRXID = pn_trx_id;
          -- INI, LUIS JARA, 16/09/2018
       AND aqpa473xmlid = vn_xml_id;
    -- FIN, LUIS JARA, 16/09/2018       
  
    COMMIT;
  
    IF instr(l_clob, '<?xml version="1.0" encoding="utf-8"?') >= 1 THEN
    
      -- Guardamos el archvio XML en la tabla de documentos
      UPDATE aqpa471 h
         SET h.aqpa471noxml = vc_mensaje
            ,h.aqpa471xml   = pq_ar_facturacion_e.fn_ar_clob_to_blob_base64(gc_clob1 /*reqxml_4*/ /*gc_clob*/)
       WHERE aqpa471trxid = pn_trx_id;
      --
    
      pc_resultado := NULL;
    
      --  commit;
      RETURN TRUE;
      --dbms_output.put_line('TRUE'); 
      --dbms_output.put_line('reqxml_4 = '||'TRUE');
      /*dbms_output.put_line('reqxml_4 = '||respval);
      dbms_output.put_line('reqxml_4 = '||pn_certificate_id);
      dbms_output.put_line('reqxml_4 = '||pc_resultado);*/
    
      --end if;
    
      /*if vc_mensaje is not null then
      pc_resultado := vc_mensaje;
      return false;*/
    ELSE
      --return false;
      --dbms_output.put_line('FALSE'); 
      /* if instr(respval, '<?xml version="1.0" encoding="utf-8"?') >= 1 then
        pc_resultado := null;
        update JC.JC_EDE_LO_AR_HEADER_ALL h
           set 
               h.STATUS_OF = ''
               ,h.STATUS_OF_DESC = ''
               ,h.ERROR_TCI = null
               ,h.DESC_ERROR_TCI = null
               ,h.ERROR_ESTADO = ''
               ,h.DESC_ERROR_ESTADO = '' -- corregir
         where h.certificate_id = pn_certificate_id;
         commit;
        return true;
      else
        update JC.JC_EDE_LO_AR_HEADER_ALL h
           set 
               h.STATUS_OF = 'PEN_ACT_EST'
               ,h.STATUS_OF_DESC = 'Error de Formato en Trama de Retorno'
               ,h.ERROR_TCI = null
               ,h.DESC_ERROR_TCI = null
               ,h.ERROR_ESTADO = 'WS'
               ,h.DESC_ERROR_ESTADO = 'Error de Formato en Trama de Retorno'
         where h.certificate_id = pn_certificate_id;  */
      pc_resultado := NULL;
      RETURN FALSE;
      --end if;
    END IF;
  
  EXCEPTION
    /*when ve_exc_2 then
    
    apps.fnd_file.put_line(apps.fnd_file.output, 'Error WS: No hay datos para env?o');
    pc_resultado := 'Error WS: No hay datos para env?o';
    
    pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, pc_resultado);
    
    return false;*/
  
    /*when ve_exc then
    apps.fnd_file.put_line(apps.fnd_file.output, vv_message);
    pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, vv_message);
    
    return false;*/
    WHEN utl_http.end_of_body THEN
      vv_error_detalle := dbms_utility.format_error_backtrace;
      vv_error_corto   := SQLERRM;
      pc_resultado     := 'Error estructura xml (4) - ' || vv_error_corto || ' - ' || vv_error_detalle;
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
      RETURN FALSE;
      --dbms_output.put_line('FALSE'); 
  
    WHEN OTHERS THEN
      --dbms_output.put_line('Error WS: ' || sqlerrm);
      --apps.fnd_file.put_line(apps.fnd_file.log, 'Error WS: ' || sqlerrm);
      vv_error_detalle := dbms_utility.format_error_backtrace;
      vv_error_corto   := SQLERRM;
      pc_resultado     := vv_error_corto || ' - ' || vv_error_detalle;
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
    
      RETURN FALSE;
      --dbms_output.put_line('FALSE'); 
    --dbms_output.put_line('reqxml_4 = '||respval);
    --d-bms_output.put_line('reqxml_4 = '||pn_certificate_id);
    --dbms_output.put_line('reqxml_4 = '||pc_resultado);
  
  END fn_ar_obtener_xml_ws;

  -- *******************************************************************
  -- Nombre                    : PROCESO 
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- *******************************************************************   

  PROCEDURE pr_ar_data_ws_xml(pc_proceso IN VARCHAR2
                             ,vc_date    IN CLOB
                              --,pv_codigo_error out varchar2
                             ,pv_nombre_xml  OUT VARCHAR2
                             ,pv_archivo_xml OUT CLOB
                              --
                             ,pv_desc_error_consulta OUT VARCHAR2
                              
                              --
                              ) IS
  
    vn_point_ini            NUMBER := 0;
    vn_point_fin            NUMBER := 0;
    vc_point_ini            VARCHAR2(3000);
    vc_point_fin            VARCHAR2(3000);
    vc_val_resultado        VARCHAR2(3000);
    vc_val_codigohash       VARCHAR2(3000);
    vc_val_mensajeresultado VARCHAR2(3000);
    vc_val_codigoerror      VARCHAR2(3000);
    vv_serial_comp          aqpa471.aqpa460seri%TYPE;
    vn_numero_comp          aqpa471.aqpa460num%TYPE;
  
  BEGIN
    pv_desc_error_consulta := NULL;
  
    IF pc_proceso = 'FACTURACION' THEN
      /*
      vc_point_ini            := '<at_NivelResultado>';
      vc_point_fin            := '</at_NivelResultado>';
      vn_point_ini            := instr(vc_date, vc_point_ini);
      vn_point_fin            := instr(vc_date, vc_point_fin);
      vc_val_resultado        := substr(vc_date
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
      vc_point_ini            := '<at_MensajeResultado>';
      vc_point_fin            := '</at_MensajeResultado>';
      vn_point_ini            := instr(vc_date, vc_point_ini);
      vn_point_fin            := instr(vc_date, vc_point_fin);
      vc_val_mensajeresultado := substr(vc_date
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
      vc_point_ini            := '<at_CodigoHash>';
      vc_point_fin            := '</at_CodigoHash>';
      vn_point_ini            := instr(vc_date, vc_point_ini);
      vn_point_fin            := instr(vc_date, vc_point_fin);
      vc_val_codigohash       := substr(vc_date
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
      vc_point_ini            := '<at_NombreXML>';
      vc_point_fin            := '</at_NombreXML>';
      vn_point_ini            := instr(vc_date, vc_point_ini);
      vn_point_fin            := instr(vc_date, vc_point_fin);
      vc_val_nombrexml        := substr(vc_date
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
      vc_point_ini            := '<at_CodigoError>';
      vc_point_fin            := '</at_CodigoError>';
      vn_point_ini            := instr(vc_date, vc_point_ini);
      vn_point_fin            := instr(vc_date, vc_point_fin);
      vc_val_codigoerror      := substr(vc_date
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);*/
    
      vc_point_ini  := '<NombreXML>';
      vc_point_fin  := '</NombreXML>';
      vn_point_ini  := instr(vc_date, vc_point_ini);
      vn_point_fin  := instr(vc_date, vc_point_fin);
      pv_nombre_xml := substr(vc_date
                             ,vn_point_ini + length(vc_point_ini)
                             ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      vc_point_ini   := '<ArchivoXML>';
      vc_point_fin   := '</ArchivoXML>';
      vn_point_ini   := instr(vc_date, vc_point_ini);
      vn_point_fin   := instr(vc_date, vc_point_fin);
      pv_archivo_xml := substr(vc_date
                              ,vn_point_ini + length(vc_point_ini)
                              ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      vc_point_ini       := '<Cadena>';
      vc_point_fin       := '</Cadena>';
      vn_point_ini       := instr(vc_date, vc_point_ini);
      vn_point_fin       := instr(vc_date, vc_point_fin);
      vc_val_codigoerror := substr(vc_date
                                  ,vn_point_ini + length(vc_point_ini)
                                  ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      -- pv_codigo_error := vc_val_codigoerror;
      pv_desc_error_consulta := vc_val_codigoerror;
    
    END IF;
  
  END;

  -- *******************************************************************
  -- Nombre                    : FUNCION PARA OBTENER PDF DE WEBSERVICE
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : Obtener PDF
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- *******************************************************************     

  FUNCTION fn_ar_obtener_pdf_ws(pc_proceso   VARCHAR2
                               ,pn_trx_id    NUMBER
                               ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN IS
  
    vv_error_detalle VARCHAR2(1500);
    vv_error_corto   VARCHAR2(1500);
  
    CURSOR c_main_ret IS
      SELECT a.aqpa471trxid
            ,a.aqpa460seri
            ,a.aqpa460num
            ,a.aqpa460rucc
            ,a.aqpa460tcomf
        FROM aqpa471 a
       WHERE 1 = 1
         AND a.aqpa471trxid = pn_trx_id;
  
    vc_mensaje VARCHAR2(3000);
    l_raw      RAW(32767);
    l_blob     BLOB;
    l_text     VARCHAR2(32767);
    l_clob     CLOB;
  BEGIN
  
    reqxml_0 := NULL;
  
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
  
    vn_count := 0;
  
    vv_url_http := fn_ar_get_url_http(pv_type => pc_proceso); --CVEAS CAMBIAR
  
    IF pc_proceso = 'FACTURACION' THEN
    
      FOR x IN c_main_ret LOOP
        vn_count := vn_count + 1;
        --reqxml_0 := '<?xml version="1.0" encoding="utf-8"?>';
        reqxml_0 := reqxml_0 || '<?xml version="1.0" encoding="UTF-8"?>';
        --reqxml_0 := reqxml_0 ||
        --            '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
        reqxml_0 := reqxml_0 || chr(10) ||
                    '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
        --reqxml_0 := reqxml_0 || '<soap12:Body>';
        reqxml_0 := reqxml_0 || chr(10) ||
                    '   <soap12:Body xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        reqxml_0 := reqxml_0 || '<Obtener_PDF xmlns="http://tempuri.org/">';
        reqxml_0 := reqxml_0 || '<oENPeticion>';
        reqxml_0 := reqxml_0 || '<IndicadorComprobante>' || 0 /*x.certificate_id*/
                    || '</IndicadorComprobante>';
        reqxml_0 := reqxml_0 || '<Serie>' || x.aqpa460seri || '</Serie>';
        reqxml_0 := reqxml_0 || '<Numero>' || x.aqpa460num || '</Numero>';
        reqxml_0 := reqxml_0 || '<TipoComprobante>' || lpad(x.aqpa460tcomf, 2, 0) || '</TipoComprobante>';
        reqxml_0 := reqxml_0 || '<Ruc>' || x.aqpa460rucc || '</Ruc>';
        reqxml_0 := reqxml_0 || '</oENPeticion>';
        reqxml_0 := reqxml_0 || '</Obtener_PDF>';
        reqxml_0 := reqxml_0 || '</soap12:Body>';
        reqxml_0 := reqxml_0 || '</soap12:Envelope>';
      END LOOP;
    
    END IF;
  
    reqxml_4 := reqxml_0;
  
    pr_ar_xml_ws('INSERT', pc_proceso, pn_trx_id, reqxml_4, 'Obtener_PDF xmlns');
  
    utl_http.set_persistent_conn_support(TRUE);
  
    ----CVEAS---<INI>18122018
    pr_jc_insertar_log('Obtener_PDF', vn_id_log, pn_trx_id);
  
    req := utl_http.begin_request(url => vv_url_http, method => 'POST', http_version => 'HTTP/1.1');
    utl_http.set_transfer_timeout(60);
    utl_http.set_header(req, 'Content-Type', 'application/soap+xml; charset=utf-8');
    utl_http.set_header(req, 'Content-Length', length(reqxml_4));
    utl_http.write_text(req, reqxml_4);
    resp := utl_http.get_response(req);
  
    dbms_lob.createtemporary(l_clob, FALSE);
    BEGIN
      LOOP
        utl_http.read_text(resp, l_text, 32766);
        dbms_lob.writeappend(l_clob, length(l_text), l_text);
      END LOOP;
      utl_http.end_response(resp);
    EXCEPTION
      WHEN utl_http.end_of_body THEN
        utl_http.end_response(resp);
    END;
  
    pr_jc_actualizar_log(vn_id_log);
    ----CVEAS---<FIN>18122018    
  
    --    insert into JC.jc_pureba_xml (cadena_xml, linea) values (l_clob ,11);
    --    
    --dbms_output.put_line(length(respval));
    --    utl_http.end_response(resp);
  
    pc_resultado := NULL; --respval;
  
    vc_mensaje := NULL;
    pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, /*respval*/ l_clob /*respval_cl*/, '');
  
    --dbms_output.put_line('reqxml_4 ANTES = '||respval); 
  
    --dbms_output.put_line('reqxml_2 ANTES = '||reqxml_0); 
    --dbms_output.put_line('reqxml_3 ANTES= '||reqxml_4);   
    pr_ar_data_ws_pdf(pc_proceso, /*respval*/ l_clob, vc_mensaje, /*reqxml_4*/ gc_clob1, reqxml_0);
    --    dbms_output.put_line('reqxml_4 = '||respval); 
    --dbms_output.put_line('reqxml_2 = '||length(l_clob)); 
    --dbms_output.put_line('reqxml_3 = '||length(gc_clob1));
  
    UPDATE aqpa473
       SET aqpa473capdf = gc_clob1 /*reqxml_4*/ --reqxml_0
           -- ,last_updated_by  = apps.fnd_global.user_id --CVEAS
          ,aqpa473fact = SYSDATE
     WHERE 1 = 1
          --and AQPA473TRXID = pn_trx_id;
          -- INI, LUIS JARA, 16/09/2018
       AND aqpa473xmlid = vn_xml_id;
    -- FIN, LUIS JARA, 16/09/2018       
  
    COMMIT;
  
    IF instr(l_clob, '<?xml version="1.0" encoding="utf-8"?') >= 1 THEN
    
      -- Guardamos el archvio XML en la tabla de documentos
      UPDATE aqpa471 h
         SET h.aqpa471nopdf = vc_mensaje
            ,h.aqpa471pdf   = pq_ar_facturacion_e.fn_ar_clob_to_blob_base64( /*reqxml_4*/ gc_clob1)
       WHERE aqpa471trxid = pn_trx_id;
      --
    
      pc_resultado := NULL;
    
      --  commit;
      RETURN TRUE;
      --dbms_output.put_line('TRUE'); 
      --dbms_output.put_line('reqxml_4 = '||'TRUE');
      /*dbms_output.put_line('reqxml_4 = '||respval);
      dbms_output.put_line('reqxml_4 = '||pn_certificate_id);
      dbms_output.put_line('reqxml_4 = '||pc_resultado);*/
    
      --end if;
    
      /*if vc_mensaje is not null then
      pc_resultado := vc_mensaje;
      return false;*/
    ELSE
      --return false;
      --dbms_output.put_line('FALSE'); 
      /* if instr(respval, '<?xml version="1.0" encoding="utf-8"?') >= 1 then
        pc_resultado := null;
        update JC.JC_EDE_LO_AR_HEADER_ALL h
           set 
               h.STATUS_OF = ''
               ,h.STATUS_OF_DESC = ''
               ,h.ERROR_TCI = null
               ,h.DESC_ERROR_TCI = null
               ,h.ERROR_ESTADO = ''
               ,h.DESC_ERROR_ESTADO = '' -- corregir
         where h.certificate_id = pn_certificate_id;
         commit;
        return true;
      else
        update JC.JC_EDE_LO_AR_HEADER_ALL h
           set 
               h.STATUS_OF = 'PEN_ACT_EST'
               ,h.STATUS_OF_DESC = 'Error de Formato en Trama de Retorno'
               ,h.ERROR_TCI = null
               ,h.DESC_ERROR_TCI = null
               ,h.ERROR_ESTADO = 'WS'
               ,h.DESC_ERROR_ESTADO = 'Error de Formato en Trama de Retorno'
         where h.certificate_id = pn_certificate_id;  */
      pc_resultado := NULL;
      RETURN FALSE;
      --end if;
    END IF;
  
  EXCEPTION
    /*when ve_exc_2 then
    
    apps.fnd_file.put_line(apps.fnd_file.output, 'Error WS: No hay datos para env?o');
    pc_resultado := 'Error WS: No hay datos para env?o';
    
    pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, pc_resultado);
    
    return false;*/
  
    /*when ve_exc then
    apps.fnd_file.put_line(apps.fnd_file.output, vv_message);
    pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, vv_message);
    
    return false;*/
    WHEN utl_http.end_of_body THEN
      vv_error_detalle := dbms_utility.format_error_backtrace;
      vv_error_corto   := SQLERRM;
      pc_resultado     := 'Error estructura xml (5) - ' || vv_error_corto || ' - ' || vv_error_detalle;
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
      RETURN FALSE;
      --dbms_output.put_line('FALSE'); 
  
    WHEN OTHERS THEN
      --dbms_output.put_line('Error WS: ' || sqlerrm);
      --apps.fnd_file.put_line(apps.fnd_file.log, 'Error WS: ' || sqlerrm);
      vv_error_detalle := dbms_utility.format_error_backtrace;
      vv_error_corto   := SQLERRM;
      pc_resultado     := vv_error_corto || ' - ' || vv_error_detalle;
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
    
      RETURN FALSE;
      --dbms_output.put_line('FALSE'); 
    --dbms_output.put_line('reqxml_4 = '||respval);
    --d-bms_output.put_line('reqxml_4 = '||pn_certificate_id);
    --dbms_output.put_line('reqxml_4 = '||pc_resultado);
  
  END;

  -- *******************************************************************
  -- Nombre                    : PROCESO 
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- *******************************************************************   

  PROCEDURE pr_ar_data_ws_pdf(pc_proceso IN VARCHAR2
                             ,vc_date    IN CLOB
                              --,pv_codigo_error out varchar2
                             ,pv_nombre_pdf  OUT VARCHAR2
                             ,pv_archivo_pdf OUT CLOB
                              --
                             ,pv_desc_error_consulta OUT VARCHAR2
                              
                              ) IS
  
    vn_point_ini            NUMBER := 0;
    vn_point_fin            NUMBER := 0;
    vc_point_ini            VARCHAR2(3000);
    vc_point_fin            VARCHAR2(3000);
    vc_val_resultado        VARCHAR2(3000);
    vc_val_codigohash       VARCHAR2(3000);
    vc_val_mensajeresultado VARCHAR2(3000);
    vc_val_nombrexml        VARCHAR2(3000);
    vc_val_codigoerror      VARCHAR2(3000);
    vv_serial_comp          aqpa471.aqpa460seri%TYPE;
    vn_numero_comp          aqpa471.aqpa460num%TYPE;
  
  BEGIN
  
    pv_desc_error_consulta := NULL;
  
    IF pc_proceso = 'FACTURACION' THEN
    
      /*vc_point_ini            := '<at_NivelResultado>';
      vc_point_fin            := '</at_NivelResultado>';
      vn_point_ini            := instr(vc_date, vc_point_ini);
      vn_point_fin            := instr(vc_date, vc_point_fin);
      vc_val_resultado        := substr(vc_date
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
      vc_point_ini            := '<at_MensajeResultado>';
      vc_point_fin            := '</at_MensajeResultado>';
      vn_point_ini            := instr(vc_date, vc_point_ini);
      vn_point_fin            := instr(vc_date, vc_point_fin);
      vc_val_mensajeresultado := substr(vc_date
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
      vc_point_ini            := '<at_CodigoHash>';
      vc_point_fin            := '</at_CodigoHash>';
      vn_point_ini            := instr(vc_date, vc_point_ini);
      vn_point_fin            := instr(vc_date, vc_point_fin);
      vc_val_codigohash       := substr(vc_date
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
      vc_point_ini            := '<at_NombreXML>';
      vc_point_fin            := '</at_NombreXML>';
      vn_point_ini            := instr(vc_date, vc_point_ini);
      vn_point_fin            := instr(vc_date, vc_point_fin);
      vc_val_nombrexml        := substr(vc_date
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
      vc_point_ini            := '<at_CodigoError>';
      vc_point_fin            := '</at_CodigoError>';
      vn_point_ini            := instr(vc_date, vc_point_ini);
      vn_point_fin            := instr(vc_date, vc_point_fin);
      vc_val_codigoerror      := substr(vc_date
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);*/
    
      vc_point_ini   := '<NombrePDF>';
      vc_point_fin   := '</NombrePDF>';
      vn_point_ini   := instr(vc_date, vc_point_ini);
      vn_point_fin   := instr(vc_date, vc_point_fin);
      pv_nombre_pdf  := substr(vc_date
                              ,vn_point_ini + length(vc_point_ini)
                              ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
      vc_point_ini   := '<ArchivoPDF>';
      vc_point_fin   := '</ArchivoPDF>';
      vn_point_ini   := instr(vc_date, vc_point_ini);
      vn_point_fin   := instr(vc_date, vc_point_fin);
      pv_archivo_pdf := substr(vc_date
                              ,vn_point_ini + length(vc_point_ini)
                              ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      vc_point_ini       := '<Cadena>';
      vc_point_fin       := '</Cadena>';
      vn_point_ini       := instr(vc_date, vc_point_ini);
      vn_point_fin       := instr(vc_date, vc_point_fin);
      vc_val_codigoerror := substr(vc_date
                                  ,vn_point_ini + length(vc_point_ini)
                                  ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      --  pv_codigo_error := vc_val_codigoerror;
      pv_desc_error_consulta := vc_val_codigoerror;
    
    END IF;
  
  END;

  -- *******************************************************************
  -- Nombre                    : FUNCION 
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- *******************************************************************

  FUNCTION fn_ar_clob_to_blob_base64(p_clob_in IN CLOB) RETURN BLOB IS
  
    v_blob           BLOB;
    v_result         BLOB;
    v_offset         INTEGER;
    v_buffer_size    BINARY_INTEGER := 48;
    v_buffer_varchar VARCHAR2(48);
    v_buffer_raw     RAW(48);
  BEGIN
    IF p_clob_in IS NULL THEN
      RETURN NULL;
    END IF;
    dbms_lob.createtemporary(v_blob, TRUE);
    v_offset := 1;
    FOR i IN 1 .. ceil(dbms_lob.getlength(p_clob_in) / v_buffer_size) LOOP
      dbms_lob.read(p_clob_in, v_buffer_size, v_offset, v_buffer_varchar);
      v_buffer_raw := utl_raw.cast_to_raw(v_buffer_varchar);
      v_buffer_raw := utl_encode.base64_decode(v_buffer_raw);
      dbms_lob.writeappend(v_blob, utl_raw.length(v_buffer_raw), v_buffer_raw);
      v_offset := v_offset + v_buffer_size;
    END LOOP;
    v_result := v_blob;
    dbms_lob.freetemporary(v_blob);
    RETURN v_result;
  
  END fn_ar_clob_to_blob_base64;

  -- ****************************************************************************
  -- Nombre                    : FUNCION PARA CONSULTAR ESTADO DE COMPROBANTE WS
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : Consultar Estado de Comprobante
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- ***************************************************************************  

  FUNCTION fn_ar_consultarestadocomp_ws(pc_proceso   VARCHAR2
                                       ,pn_trx_id    NUMBER
                                       ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN IS
  
    vv_error_detalle VARCHAR2(1500);
    vv_error_corto   VARCHAR2(1500);
    vb_retorno       BOOLEAN;
    vv_retorno       VARCHAR2(1500);
    --180618pdz     
    vv_respuesta           VARCHAR2(1500);
    vv_descripcion         VARCHAR2(1500);
    vv_tipocomprobante     VARCHAR2(1500);
    vv_serie               VARCHAR2(1500);
    vv_numero              VARCHAR2(1500);
    vv_idcomprobanteemisor VARCHAR2(1500);
    vv_activootorgado      VARCHAR2(1500);
    vv_fechaotorgado       VARCHAR2(1500);
    vv_fechaleido          VARCHAR2(1500);
    vv_activoleido         VARCHAR2(1500);
    vv_fecharechazo        VARCHAR2(1500);
    vv_activorechazo       VARCHAR2(1500);
    vv_motivorechazo       VARCHAR2(1500);
    --
    CURSOR c_main_ret IS
      SELECT p.aqpa475valor AS aqpa460rucc
        FROM aqpa475 p
       WHERE p.aqpa475param = 'RUC_EMISOR';
  
    vc_mensaje VARCHAR2(3000);
  
  BEGIN
  
    -- desabilitado pdz 200618
    -- return true;
  
    reqxml_0 := NULL;
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
  
    vn_count := 0;
  
    vv_url_http := fn_ar_get_url_http(pv_type => pc_proceso); --CVEAS CAMBIAR
  
    /*req := utl_http.begin_request(url          => vv_url_http,
    method       => 'POST',
    http_version => 'HTTP/1.1');*/
  
    IF pc_proceso = 'FACTURACION' /*'Obtener_XML'*/
     THEN
    
      FOR x IN c_main_ret LOOP
        vn_count := vn_count + 1;
        reqxml_0 := reqxml_0 || '<?xml version="1.0" encoding="UTF-8"?>';
        reqxml_0 := reqxml_0 || chr(10) ||
                    '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
        reqxml_0 := reqxml_0 || chr(10) ||
                    '   <soap12:Body xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        reqxml_0 := reqxml_0 || '<ConsultarEstadoComprobante xmlns="http://tempuri.org/">';
        reqxml_0 := reqxml_0 || '<oENPeticionEstadoComprobante>';
        reqxml_0 := reqxml_0 || '<RucEmpresa>' || x.aqpa460rucc || '</RucEmpresa>';
        reqxml_0 := reqxml_0 || '<CantidadComprobantes>' || vg_cant_comp || '</CantidadComprobantes>';
        reqxml_0 := reqxml_0 || '</oENPeticionEstadoComprobante>';
        reqxml_0 := reqxml_0 || '</ConsultarEstadoComprobante>';
        reqxml_0 := reqxml_0 || '</soap12:Body>';
        reqxml_0 := reqxml_0 || '</soap12:Envelope>';
      END LOOP;
    
    END IF;
  
    reqxml_4 := reqxml_0;
  
    --CORREGIR
  
    /* req := utl_http.begin_request(url          => vv_url_http,
                                     method       => 'POST',
                                     http_version => 'HTTP/1.1');
       utl_http.set_transfer_timeout(60);
       utl_http.set_header(req,
                           'Content-Type',
                           'application/soap+xml; charset=utf-8');
       utl_http.set_header(req, 'Content-Length', length(reqxml_4));
       utl_http.write_text(req, reqxml_4);
       resp := utl_http.get_response(req);
       utl_http.read_text(resp, respval);
    --   apps.fnd_file.put_line(apps.fnd_file.log, respval);
       utl_http.end_response(resp);*/
  
    pc_resultado := NULL; --respval;
  
    vc_mensaje := NULL;
  
    --pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, '');
  
    --180618pdz
  
    pr_ar_consultarestadocomp_ws(pc_proceso
                                ,respval
                                ,vv_respuesta
                                ,vv_descripcion
                                ,vv_tipocomprobante
                                ,vv_serie
                                ,vv_numero
                                ,vv_idcomprobanteemisor
                                ,vv_activootorgado
                                ,vv_fechaotorgado
                                ,vv_fechaleido
                                ,vv_activoleido
                                ,vv_fecharechazo
                                ,vv_activorechazo
                                ,vv_motivorechazo);
  
    --pv_IdDocumentoCliente   out varchar2,
  
    --180618pdz                          
  
    /*dbms_output.put_line('vv_Respuesta = ' || vv_Respuesta);
    dbms_output.put_line('vv_Descripcion = ' || vv_Descripcion);
    dbms_output.put_line('vv_TipoComprobante = ' || vv_TipoComprobante);
    dbms_output.put_line('vv_Serie = ' || vv_Serie);
    dbms_output.put_line('vv_Numero = ' || vv_Numero);
    dbms_output.put_line('vv_IdComprobanteEmisor = ' ||
                         vv_IdComprobanteEmisor);
    dbms_output.put_line('vv_ActivoOtorgado = ' || vv_ActivoOtorgado);
    
    dbms_output.put_line('vv_FechaOtorgado = ' || vv_FechaOtorgado);
    dbms_output.put_line('vv_FechaLeido = ' || vv_FechaLeido);
    dbms_output.put_line('vv_ActivoLeido = ' || vv_ActivoLeido);
    dbms_output.put_line('vv_FechaRechazo = ' || vv_FechaRechazo);
    dbms_output.put_line('vv_ActivoRechazo = ' || vv_ActivoRechazo);
    dbms_output.put_line('vv_MotivoRechazo = ' || vv_MotivoRechazo);*/
  
    /* dbms_output.put_line('  ');
    
    dbms_output.put_line('respval = ' || respval);*/
  
    IF instr(respval, '<?xml version="1.0" encoding="utf-8"?') >= 1 THEN
    
      pc_resultado := NULL;
    
      --  commit;
      --return true;
      --dbms_output.put_line('TRUE'); 
      --dbms_output.put_line('reqxml_4 = ' || 'TRUE');
      /*dbms_output.put_line('reqxml_4 = '||respval);
      dbms_output.put_line('reqxml_4 = '||pn_certificate_id);
      dbms_output.put_line('reqxml_4 = '||pc_resultado);*/
    
      --end if;
    
      /*if vc_mensaje is not null then
      pc_resultado := vc_mensaje;
      return false;*/
    ELSE
      --return false;
      --dbms_output.put_line('FALSE'); 
      /* if instr(respval, '<?xml version="1.0" encoding="utf-8"?') >= 1 then
        pc_resultado := null;
        update JC.JC_EDE_LO_AR_HEADER_ALL h
           set 
               h.STATUS_OF = ''
               ,h.STATUS_OF_DESC = ''
               ,h.ERROR_TCI = null
               ,h.DESC_ERROR_TCI = null
               ,h.ERROR_ESTADO = ''
               ,h.DESC_ERROR_ESTADO = '' -- corregir
         where h.certificate_id = pn_certificate_id;
         commit;
        return true;
      else
        update JC.JC_EDE_LO_AR_HEADER_ALL h
           set 
               h.STATUS_OF = 'PEN_ACT_EST'
               ,h.STATUS_OF_DESC = 'Error de Formato en Trama de Retorno'
               ,h.ERROR_TCI = null
               ,h.DESC_ERROR_TCI = null
               ,h.ERROR_ESTADO = 'WS'
               ,h.DESC_ERROR_ESTADO = 'Error de Formato en Trama de Retorno'
         where h.certificate_id = pn_certificate_id;  */
      pc_resultado := NULL;
      RETURN FALSE;
      --end if;
    END IF;
  
    -- Llamamos a las demas rutinas
    -- corregir    
    --dbms_output.put_line('fu_ConfirmarEstadoComp_ws');    
  
    vb_retorno := fn_ar_confirmarestadocomp_ws('FACTURACION', NULL, vv_retorno);
    ---
  
    vb_retorno := fn_ar_consrespcomp('FACTURACION', NULL, vv_retorno);
    --
    vb_retorno := fn_ar_confrespcomp('FACTURACION', NULL, vv_retorno);
  
    RETURN TRUE;
  
  EXCEPTION
    /*when ve_exc_2 then
    
    apps.fnd_file.put_line(apps.fnd_file.output, 'Error WS: No hay datos para env?o');
    pc_resultado := 'Error WS: No hay datos para env?o';
    
    pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, pc_resultado);
    
    return false;*/
  
    /*when ve_exc then
    apps.fnd_file.put_line(apps.fnd_file.output, vv_message);
    pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, vv_message);
    
    return false;*/
    WHEN utl_http.end_of_body THEN
      vv_error_detalle := dbms_utility.format_error_backtrace;
      vv_error_corto   := SQLERRM;
      pc_resultado     := 'Error estructura xml (6) - ' || vv_error_corto || ' - ' || vv_error_detalle;
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
      RETURN FALSE;
      --dbms_output.put_line('FALSE');
  
    WHEN OTHERS THEN
      --dbms_output.put_line('Error WS: ' || sqlerrm);
      --apps.fnd_file.put_line(apps.fnd_file.log, 'Error WS: ' || sqlerrm);
      vv_error_detalle := dbms_utility.format_error_backtrace;
      vv_error_corto   := SQLERRM;
      pc_resultado     := vv_error_corto || ' - ' || vv_error_detalle;
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
    
      RETURN FALSE;
      --dbms_output.put_line('FALSE');
    --dbms_output.put_line('reqxml_4 = '||respval);
    --d-bms_output.put_line('reqxml_4 = '||pn_certificate_id);
    --dbms_output.put_line('reqxml_4 = '||pc_resultado);
  
  END;

  -- *******************************************************************
  -- Nombre                    : PROCESO PARA CONSULTAR ESTADO COMPROBANTE WS 
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- ******************************************************************* 

  PROCEDURE pr_ar_consultarestadocomp_ws(pc_proceso             IN VARCHAR2
                                        ,vc_respval             IN VARCHAR2
                                        ,pv_respuesta           OUT VARCHAR2
                                        ,pv_descripcion         OUT VARCHAR2
                                        ,pv_tipocomprobante     OUT VARCHAR2
                                        ,pv_serie               OUT VARCHAR2
                                        ,pv_numero              OUT VARCHAR2
                                        ,pv_idcomprobanteemisor OUT VARCHAR2
                                        ,pv_activootorgado      OUT VARCHAR2
                                        ,pv_fechaotorgado       OUT VARCHAR2
                                        ,pv_fechaleido          OUT VARCHAR2
                                        ,pv_activoleido         OUT VARCHAR2
                                        ,pv_fecharechazo        OUT VARCHAR2
                                        ,pv_activorechazo       OUT VARCHAR2
                                        ,pv_motivorechazo       OUT VARCHAR2
                                         
                                         ) IS
  
    vn_point_ini            NUMBER := 0;
    vn_point_fin            NUMBER := 0;
    vc_point_ini            VARCHAR2(3000);
    vc_point_fin            VARCHAR2(3000);
    vc_val_resultado        VARCHAR2(3000);
    vc_val_codigohash       VARCHAR2(3000);
    vc_val_mensajeresultado VARCHAR2(3000);
    vc_val_nombrexml        VARCHAR2(3000);
    vc_val_codigoerror      VARCHAR2(3000);
    vv_serial_comp          aqpa471.aqpa460seri%TYPE;
    vn_numero_comp          aqpa471.aqpa460num%TYPE;
    --
    vn_point_ini_aux    NUMBER;
    vn_estados          VARCHAR2(3000);
    vv_otorgado         VARCHAR2(3000);
    vv_leido            VARCHAR2(3000);
    vv_rechazado        VARCHAR2(3000);
    vv_rechazado_activo VARCHAR2(25);
    vv_leido_activo     VARCHAR2(25);
    vv_otorgado_activo  VARCHAR2(25);
    vv_serie            VARCHAR2(25);
    vn_numero           NUMBER;
  
    --
  BEGIN
  
    --pv_desc_error_consulta := null;
  
    IF pc_proceso = 'FACTURACION' THEN
    
      vc_point_ini   := '<Respuesta>';
      vc_point_fin   := '</Respuesta>';
      vn_point_ini   := instr(vc_respval, vc_point_ini);
      vn_point_fin   := instr(vc_respval, vc_point_fin);
      pv_respuesta   := substr(vc_respval
                              ,vn_point_ini + length(vc_point_ini)
                              ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
      vc_point_ini   := '<Descripcion>';
      vc_point_fin   := '</Descripcion>';
      vn_point_ini   := instr(vc_respval, vc_point_ini);
      vn_point_fin   := instr(vc_respval, vc_point_fin);
      pv_descripcion := substr(vc_respval
                              ,vn_point_ini + length(vc_point_ini)
                              ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      --desabilitado pdz190619                                  
      /*vc_point_ini            := '<FechaRespuesta>';
      vc_point_fin            := '</FechaRespuesta>';
      vn_point_ini            := instr(vc_respval, vc_point_ini);
      vn_point_fin            := instr(vc_respval, vc_point_fin);
      pv_FechaRespuesta       := substr(vc_respval,
                                        vn_point_ini + length(vc_point_ini),
                                        (vn_point_fin - vn_point_ini) -
                                        length(vc_point_fin) + 1);
                                        
      vc_point_ini            := '<TipoComprobante>';
      vc_point_fin            := '</TipoComprobante>';
      vn_point_ini            := instr(vc_respval, vc_point_ini);
      vn_point_fin            := instr(vc_respval, vc_point_fin);
      pv_TipoComprobante      := substr(vc_respval,
                                        vn_point_ini + length(vc_point_ini),
                                        (vn_point_fin - vn_point_ini) -
                                        length(vc_point_fin) + 1);
      vc_point_ini            := '<Serie>';
      vc_point_fin            := '</Serie>';
      vn_point_ini            := instr(vc_respval, vc_point_ini);
      vn_point_fin            := instr(vc_respval, vc_point_fin);
      pv_Serie                := substr(vc_respval,
                                        vn_point_ini + length(vc_point_ini),
                                        (vn_point_fin - vn_point_ini) -
                                        length(vc_point_fin) + 1);
      vc_point_ini            := '<Numero>';
      vc_point_fin            := '</Numero>';
      vn_point_ini            := instr(vc_respval, vc_point_ini);
      vn_point_fin            := instr(vc_respval, vc_point_fin);
      pv_Numero               := substr(vc_respval,
                                        vn_point_ini + length(vc_point_ini),
                                        (vn_point_fin - vn_point_ini) -
                                        length(vc_point_fin) + 1);
      
      vc_point_ini          := '<IdDocumentoCliente>';
      vc_point_fin          := '</IdDocumentoCliente>';
      vn_point_ini          := instr(vc_respval, vc_point_ini);
      vn_point_fin          := instr(vc_respval, vc_point_fin);
      pv_IdDocumentoCliente := substr(vc_respval,
                                      vn_point_ini + length(vc_point_ini),
                                      (vn_point_fin - vn_point_ini) -
                                      length(vc_point_fin) + 1);
      vc_point_ini          := '<ListaError>';
      vc_point_fin          := '</ListaError>';
      vn_point_ini          := instr(vc_respval, vc_point_ini);
      vn_point_fin          := instr(vc_respval, vc_point_fin);
      pv_ListaError         := substr(vc_respval,
                                      vn_point_ini + length(vc_point_ini),
                                      (vn_point_fin - vn_point_ini) -
                                      length(vc_point_fin) + 1);*/
    
      -- Analizamos los documentos retornados
      vn_point_ini_aux := 1;
      LOOP
        -- Obtenemos cada seccion de ListaEstadoComprobante
        vc_point_ini := '<ENListaEstadoComprobante>';
        vc_point_fin := '</ENListaEstadoComprobante>';
        vn_point_ini := instr(vc_respval, vc_point_ini, vn_point_ini_aux);
        vn_point_fin := instr(vc_respval, vc_point_fin, vn_point_ini_aux);
        vn_estados   := substr(vc_respval
                              ,vn_point_ini + length(vc_point_ini)
                              ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
        IF (vn_estados IS NULL) THEN
          EXIT;
        ELSE
          vn_point_ini_aux := vn_point_fin + 1;
          --dbms_output.put_line('seccion: ' || vn_estados);
          vc_point_ini       := '<TipoComprobante>';
          vc_point_fin       := '</TipoComprobante>';
          vn_point_ini       := instr(vn_estados, vc_point_ini);
          vn_point_fin       := instr(vn_estados, vc_point_fin);
          pv_tipocomprobante := substr(vn_estados
                                      ,vn_point_ini + length(vc_point_ini)
                                      ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
          vc_point_ini       := '<Serie>';
          vc_point_fin       := '</Serie>';
          vn_point_ini       := instr(vn_estados, vc_point_ini);
          vn_point_fin       := instr(vn_estados, vc_point_fin);
          vv_serie           := substr(vn_estados
                                      ,vn_point_ini + length(vc_point_ini)
                                      ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
        
          pv_serie := vv_serie;
        
          EXIT WHEN vv_serie IS NULL;
        
          vc_point_ini := '<Numero>';
          vc_point_fin := '</Numero>';
          vn_point_ini := instr(vn_estados, vc_point_ini);
          vn_point_fin := instr(vn_estados, vc_point_fin);
          vn_numero    := to_number(substr(vn_estados
                                          ,vn_point_ini + length(vc_point_ini)
                                          ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1));
        
          pv_numero := vn_numero;
        
          /*dbms_output.put_line('serie: ' || vv_serie);
          dbms_output.put_line('numero: ' || vn_numero);*/
        
          ---pdz190618
          vc_point_ini           := '<IdComprobanteEmisor>';
          vc_point_fin           := '</IdComprobanteEmisor>';
          vn_point_ini           := instr(vn_estados, vc_point_ini);
          vn_point_fin           := instr(vn_estados, vc_point_fin);
          pv_idcomprobanteemisor := to_number(substr(vn_estados
                                                    ,vn_point_ini + length(vc_point_ini)
                                                    ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1));
          --
          vc_point_ini := '<Otorgado>';
          vc_point_fin := '</Otorgado>';
          vn_point_ini := instr(vn_estados, vc_point_ini);
          vn_point_fin := instr(vn_estados, vc_point_fin);
          vv_otorgado  := substr(vn_estados
                                ,vn_point_ini + length(vc_point_ini)
                                ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
        
          IF (vv_otorgado IS NOT NULL) THEN
            vc_point_ini       := '<Activo>';
            vc_point_fin       := '</Activo>';
            vn_point_ini       := instr(vv_otorgado, vc_point_ini);
            vn_point_fin       := instr(vv_otorgado, vc_point_fin);
            vv_otorgado_activo := substr(vv_otorgado
                                        ,vn_point_ini + length(vc_point_ini)
                                        ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
          
            /*dbms_output.put_line('vv_otorgado_activo: ' ||
            vv_otorgado_activo);*/
          
            pv_activootorgado := vv_otorgado_activo;
          
            vc_point_ini     := '<FechaOtorgado>';
            vc_point_fin     := '</FechaOtorgado>';
            vn_point_ini     := instr(vv_otorgado, vc_point_ini);
            vn_point_fin     := instr(vv_otorgado, vc_point_fin);
            pv_fechaotorgado := substr(vv_otorgado
                                      ,vn_point_ini + length(vc_point_ini)
                                      ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
          
          END IF;
        
          vc_point_ini := '<Leido>';
          vc_point_fin := '</Leido>';
          vn_point_ini := instr(vn_estados, vc_point_ini);
          vn_point_fin := instr(vn_estados, vc_point_fin);
          vv_leido     := substr(vn_estados
                                ,vn_point_ini + length(vc_point_ini)
                                ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
        
          IF (vv_leido IS NOT NULL) THEN
            vc_point_ini    := '<Activo>';
            vc_point_fin    := '</Activo>';
            vn_point_ini    := instr(vv_leido, vc_point_ini);
            vn_point_fin    := instr(vv_leido, vc_point_fin);
            vv_leido_activo := substr(vv_leido
                                     ,vn_point_ini + length(vc_point_ini)
                                     ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
          
            --dbms_output.put_line('vv_leido_activo: ' || vv_leido_activo);
          
            pv_activoleido := vv_leido_activo;
          
            --pdz190618
            vc_point_ini  := '<FechaLeido>';
            vc_point_fin  := '</FechaLeido>';
            vn_point_ini  := instr(vv_leido, vc_point_ini);
            vn_point_fin  := instr(vv_leido, vc_point_fin);
            pv_fechaleido := substr(vv_leido
                                   ,vn_point_ini + length(vc_point_ini)
                                   ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
          
            --dbms_output.put_line('pv_FechaLeido: ' || pv_FechaLeido);
          END IF;
        
          vc_point_ini := '<Rechazo>';
          vc_point_fin := '</Rechazo>';
          vn_point_ini := instr(vn_estados, vc_point_ini);
          vn_point_fin := instr(vn_estados, vc_point_fin);
          vv_rechazado := substr(vn_estados
                                ,vn_point_ini + length(vc_point_ini)
                                ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
        
          IF (vv_rechazado IS NOT NULL) THEN
            vc_point_ini        := '<Activo>';
            vc_point_fin        := '</Activo>';
            vn_point_ini        := instr(vv_rechazado, vc_point_ini);
            vn_point_fin        := instr(vv_rechazado, vc_point_fin);
            vv_rechazado_activo := substr(vv_rechazado
                                         ,vn_point_ini + length(vc_point_ini)
                                         ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
          
            pv_activorechazo := vv_rechazado_activo;
          
            --pdz190618
            vc_point_ini    := '<FechaRechazo>';
            vc_point_fin    := '</FechaRechazo>';
            vn_point_ini    := instr(vv_rechazado, vc_point_ini);
            vn_point_fin    := instr(vv_rechazado, vc_point_fin);
            pv_fecharechazo := substr(vv_rechazado
                                     ,vn_point_ini + length(vc_point_ini)
                                     ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
          
            vc_point_ini     := '<MotivoRechazo>';
            vc_point_fin     := '</MotivoRechazo>';
            vn_point_ini     := instr(vv_rechazado, vc_point_ini);
            vn_point_fin     := instr(vv_rechazado, vc_point_fin);
            pv_motivorechazo := substr(vv_rechazado
                                      ,vn_point_ini + length(vc_point_ini)
                                      ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
          
            /* dbms_output.put_line('vv_rechazado_activo: ' ||
            vv_rechazado_activo);*/
          END IF;
        
          IF (vv_otorgado_activo IS NOT NULL OR vv_leido_activo IS NOT NULL OR vv_rechazado_activo IS NOT NULL) THEN
            UPDATE aqpa471 h
               SET h.aqpa471cesot = vv_otorgado_activo
                  ,h.aqpa471cesle = vv_leido_activo
                  ,h.aqpa471cesre = vv_rechazado_activo
             WHERE h.aqpa460seri = vv_serie
               AND h.aqpa460num = vn_numero
               AND nvl(h.aqpa471coes, 'N') = 'N';
          END IF;
          --
        END IF;
        --
      END LOOP;
      --                                       
    
    END IF;
  
  END;

  -- *******************************************************************
  -- Nombre                    : FUNCION PARA CONFIMAR ESTADO COMPROBANTE WS
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : Confirmar Estado Comprobante
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- *******************************************************************  

  FUNCTION fn_ar_confirmarestadocomp_ws(pc_proceso   VARCHAR2
                                       ,pn_trx_id    NUMBER
                                       ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN IS
  
    /*function fu_ConfirmarEstadoComp_ws(pc_proceso        varchar2,
                                     pn_certificate_id number,
                                     pc_resultado      in out varchar2)
    return boolean is*/
  
    vv_error_detalle VARCHAR2(1500);
    vv_error_corto   VARCHAR2(1500);
  
    --pdz180618
    vv_enrespuestaconfirmacion VARCHAR2(1500);
    vv_respuesta               VARCHAR2(1500);
    vv_descripcion             VARCHAR2(1500);
    --
  
    CURSOR c_main_ret IS
      SELECT a.aqpa471trxid
            ,a.aqpa460seri
            ,a.aqpa460num
            ,a.aqpa460rucc
            ,a.aqpa460tcomf
        FROM aqpa471 a
       WHERE 1 = 1
         AND nvl(aqpa471coes, 'N') = 'N'
         AND (a.aqpa471cesot IS NOT NULL OR a.aqpa471cesle IS NOT NULL OR a.aqpa471cesre IS NOT NULL);
  
    vc_mensaje          VARCHAR2(3000);
    vv_organization_ruc VARCHAR2(50);
  BEGIN
  
    reqxml_0 := NULL;
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
  
    vn_count := 0;
  
    vv_url_http := fn_ar_get_url_http(pv_type => pc_proceso); --CVEAS CAMBIAR
  
    /*req := utl_http.begin_request(url          => vv_url_http,
    method       => 'POST',
    http_version => 'HTTP/1.1');*/
  
    IF pc_proceso = 'FACTURACION' /*'Obtener_XML'*/
     THEN
    
      SELECT p.aqpa475valor
        INTO vv_organization_ruc
        FROM aqpa475 p
       WHERE p.aqpa475param = 'RUC_EMISOR';
    
      reqxml_0 := '<?xml version="1.0" encoding="utf-8"?>';
      reqxml_0 := reqxml_0 || chr(10) ||
                  '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
      reqxml_0 := reqxml_0 || chr(10) || '<soap12:Body>';
      reqxml_0 := reqxml_0 || chr(10) || '<ConfirmarEstadoComprobante xmlns="http://tempuri.org/">';
      reqxml_0 := reqxml_0 || chr(10) || '<oENPeticionConfirmacion>';
      reqxml_0 := reqxml_0 || chr(10) || '<RucEmpresa>' || vv_organization_ruc || '</RucEmpresa>';
      reqxml_0 := reqxml_0 || chr(10) || '<ListaConfirmacionComprobante>';
    
      FOR x IN c_main_ret LOOP
        vn_count := vn_count + 1;
        --
        reqxml_0 := reqxml_0 || chr(10) || '<ENListaConfirmacionComprobante>';
        --pdz190618
        reqxml_0 := reqxml_0 || chr(10) || '<TipoComprobante>' || x.aqpa460tcomf || '</TipoComprobante>';
        --
        reqxml_0 := reqxml_0 || chr(10) || '<Serie>' || x.aqpa460seri || '</Serie>';
        reqxml_0 := reqxml_0 || chr(10) || '<Numero>' || x.aqpa460num || '</Numero>';
        reqxml_0 := reqxml_0 || chr(10) || '<IdComprobanteEmisor>' || 0 || '</IdComprobanteEmisor>';
        reqxml_0 := reqxml_0 || chr(10) || '<Otorgado>' || 'true' || '</Otorgado>';
        reqxml_0 := reqxml_0 || chr(10) || '<Leido>' || 'true' || '</Leido>';
        reqxml_0 := reqxml_0 || chr(10) || '<Rechazo>' || 'true' || '</Rechazo>';
        reqxml_0 := reqxml_0 || chr(10) || '</ENListaConfirmacionComprobante>';
        --
      END LOOP;
    
      reqxml_0 := reqxml_0 || chr(10) || '</ListaConfirmacionComprobante>';
      reqxml_0 := reqxml_0 || chr(10) || '</oENPeticionConfirmacion>';
      reqxml_0 := reqxml_0 || chr(10) || '</ConfirmarEstadoComprobante>';
      reqxml_0 := reqxml_0 || chr(10) || '</soap12:Body>';
      reqxml_0 := reqxml_0 || chr(10) || '</soap12:Envelope>';
    
    END IF;
  
    -- corregir
    --dbms_output.put_line('enviado: ' || reqxml_0);
    --dbms_output.put_line('tamaño: ' || length(reqxml_0));
  
    reqxml_4 := reqxml_0;
  
    pr_ar_xml_ws('INSERT', pc_proceso, pn_trx_id, reqxml_4, 'ConfirmarEstadoComprobante xmlns');
  
    --dbms_output.put_line('reqxml_4 = ' || reqxml_4);
  
    ----CVEAS---<INI>18122018
    pr_jc_insertar_log('ConfirmarEstadoComprobante', vn_id_log, pn_trx_id);
  
    req := utl_http.begin_request(url => vv_url_http, method => 'POST', http_version => 'HTTP/1.1');
    utl_http.set_transfer_timeout(60);
    utl_http.set_header(req, 'Content-Type', 'application/soap+xml; charset=utf-8');
    utl_http.set_header(req, 'Content-Length', length(reqxml_4));
    utl_http.write_text(req, reqxml_4);
    resp := utl_http.get_response(req);
    utl_http.read_text(resp, respval);
    -- apps.fnd_file.put_line(apps.fnd_file.log, respval);
    utl_http.end_response(resp);
  
    pr_jc_actualizar_log(vn_id_log);
    ----CVEAS---<FIN>18122018  
  
    -- corregir
    --dbms_output.put_line('envio: ' ||reqxml_4);
  
    -- corregir
    --dbms_output.put_line('retorno: ' ||respval);
  
    pc_resultado := NULL; --respval;
  
    vc_mensaje := NULL;
  
    pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, '');
  
    --pr_data_ws_xml(pc_proceso, respval, vc_mensaje, reqxml_4, reqxml_0);
    --pdz 180618
  
    -- corregir
    --dbms_output.put_line('recibido: ' || respval);
  
    pr_ar_confirmarestadocomp_ws(pc_proceso
                                ,respval
                                ,
                                 --vv_ENRespuestaConfirmacion,
                                 vv_respuesta
                                ,vv_descripcion);
  
    -- corregir
    --dbms_output.put_line('reqxml_3 = ' || vv_ENRespuestaConfirmacion);
    --dbms_output.put_line('vv_Respuesta = ' || vv_Respuesta);
    --dbms_output.put_line('vv_Descripcion = ' || vv_Descripcion);
  
    UPDATE aqpa473
       SET aqpa473caxml = reqxml_4 --reqxml_0
          ,
           --last_updated_by  = apps.fnd_global.user_id,
           aqpa473fact = SYSDATE
     WHERE 1 = 1
          --and AQPA473TRXID = pn_trx_id;
          -- INI, LUIS JARA, 16/09/2018
       AND aqpa473xmlid = vn_xml_id;
    -- FIN, LUIS JARA, 16/09/2018       
  
    COMMIT;
  
    IF instr(respval, '<?xml version="1.0" encoding="utf-8"?') >= 1 THEN
    
      pc_resultado := NULL;
    
      --  commit;
      RETURN TRUE;
      --dbms_output.put_line('TRUE'); 
      --dbms_output.put_line('reqxml_4 = ' || 'TRUE');
      /*dbms_output.put_line('reqxml_4 = '||respval);
      dbms_output.put_line('reqxml_4 = '||pn_certificate_id);
      dbms_output.put_line('reqxml_4 = '||pc_resultado);*/
    
      --end if;
    
      /*if vc_mensaje is not null then
      pc_resultado := vc_mensaje;
      return false;*/
    ELSE
      --return false;
      --dbms_output.put_line('FALSE'); 
      /* if instr(respval, '<?xml version="1.0" encoding="utf-8"?') >= 1 then
        pc_resultado := null;
        update JC.JC_EDE_LO_AR_HEADER_ALL h
           set 
               h.STATUS_OF = ''
               ,h.STATUS_OF_DESC = ''
               ,h.ERROR_TCI = null
               ,h.DESC_ERROR_TCI = null
               ,h.ERROR_ESTADO = ''
               ,h.DESC_ERROR_ESTADO = '' -- corregir
         where h.certificate_id = pn_certificate_id;
         commit;
        return true;
      else
        update JC.JC_EDE_LO_AR_HEADER_ALL h
           set 
               h.STATUS_OF = 'PEN_ACT_EST'
               ,h.STATUS_OF_DESC = 'Error de Formato en Trama de Retorno'
               ,h.ERROR_TCI = null
               ,h.DESC_ERROR_TCI = null
               ,h.ERROR_ESTADO = 'WS'
               ,h.DESC_ERROR_ESTADO = 'Error de Formato en Trama de Retorno'
         where h.certificate_id = pn_certificate_id;  */
      pc_resultado := NULL;
      RETURN FALSE;
      --end if;
    END IF;
  
  EXCEPTION
    /*when ve_exc_2 then
    
    apps.fnd_file.put_line(apps.fnd_file.output, 'Error WS: No hay datos para env?o');
    pc_resultado := 'Error WS: No hay datos para env?o';
    
    pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, pc_resultado);
    
    return false;*/
  
    /*when ve_exc then
    apps.fnd_file.put_line(apps.fnd_file.output, vv_message);
    pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, vv_message);
    
    return false;*/
    WHEN utl_http.end_of_body THEN
      vv_error_detalle := dbms_utility.format_error_backtrace;
      vv_error_corto   := SQLERRM;
      pc_resultado     := 'Error estructura xml (7) - ' || vv_error_corto || ' - ' || vv_error_detalle;
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
      RETURN FALSE;
      --dbms_output.put_line('FALSE');
  
    WHEN OTHERS THEN
      --dbms_output.put_line('Error WS: ' || sqlerrm);
      --apps.fnd_file.put_line(apps.fnd_file.log, 'Error WS: ' || sqlerrm);
      vv_error_detalle := dbms_utility.format_error_backtrace;
      vv_error_corto   := SQLERRM;
      pc_resultado     := vv_error_corto || ' - ' || vv_error_detalle;
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
    
      RETURN FALSE;
      --dbms_output.put_line('FALSE');
    --dbms_output.put_line('reqxml_4 = '||respval);
    --d-bms_output.put_line('reqxml_4 = '||pn_certificate_id);
    --dbms_output.put_line('reqxml_4 = '||pc_resultado);
  
  END;

  -- *******************************************************************
  -- Nombre                    : PROCESO PARA CONFIRMAR ESTADO COMPROBANTE WS
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- ******************************************************************* 

  PROCEDURE pr_ar_confirmarestadocomp_ws(pc_proceso IN VARCHAR2
                                        ,vc_respval IN VARCHAR2
                                        ,
                                         --pv_ENRespuestaConfirmacion out varchar2,
                                         pv_respuesta   OUT VARCHAR2
                                        ,pv_descripcion OUT VARCHAR2
                                         
                                         ) IS
  
    vn_point_ini            NUMBER := 0;
    vn_point_fin            NUMBER := 0;
    vc_point_ini            VARCHAR2(3000);
    vc_point_fin            VARCHAR2(3000);
    vc_val_resultado        VARCHAR2(3000);
    vc_val_codigohash       VARCHAR2(3000);
    vc_val_mensajeresultado VARCHAR2(3000);
    vc_val_nombrexml        VARCHAR2(3000);
    vc_val_codigoerror      VARCHAR2(3000);
    vv_serial_comp          aqpa471.aqpa460seri%TYPE;
    vn_numero_comp          aqpa471.aqpa460num%TYPE;
  
  BEGIN
  
    --pv_desc_error_consulta := null;
  
    IF pc_proceso = 'FACTURACION' THEN
    
      /*vc_point_ini               := '<ENRespuestaConfirmacion>';
      vc_point_fin               := '</ENRespuestaConfirmacion>';
      vn_point_ini               := instr(vc_respval, vc_point_ini);
      vn_point_fin               := instr(vc_respval, vc_point_fin);
      pv_ENRespuestaConfirmacion := substr(vc_respval,
                                           vn_point_ini +
                                           length(vc_point_ini),
                                           (vn_point_fin - vn_point_ini) -
                                           length(vc_point_fin) + 1);*/
    
      vc_point_ini := '<Respuesta>';
      vc_point_fin := '</Respuesta>';
      vn_point_ini := instr(vc_respval, vc_point_ini);
      vn_point_fin := instr(vc_respval, vc_point_fin);
      pv_respuesta := substr(vc_respval
                            ,vn_point_ini + length(vc_point_ini)
                            ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      vc_point_ini   := '<Descripcion>';
      vc_point_fin   := '</Descripcion>';
      vn_point_ini   := instr(vc_respval, vc_point_ini);
      vn_point_fin   := instr(vc_respval, vc_point_fin);
      pv_descripcion := substr(vc_respval
                              ,vn_point_ini + length(vc_point_ini)
                              ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
    END IF;
  
    -- Marcamos la confirmacion a todos los registros pendientes
    IF (upper(pv_respuesta) = 'TRUE') THEN
      UPDATE aqpa471 h
         SET h.aqpa471coes = 'Y'
       WHERE 1 = 1
         AND nvl(h.aqpa471coes, 'N') = 'N'
         AND (h.aqpa471cesot IS NOT NULL OR h.aqpa471cesle IS NOT NULL OR h.aqpa471cesre IS NOT NULL);
    END IF;
  
  END;

  --

  -- ******************************************************************************
  -- Nombre                    : FUNCION PARA CONSULTAR RESPONSABLE DE COMPROBANTE
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : Consultar Responsable de Comprobante
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- *****************************************************************************  

  FUNCTION fn_ar_consrespcomp(pc_proceso   VARCHAR2
                             ,pn_trx_id    NUMBER
                             ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN IS
  
    /* function fu_Consultar_Resp_Comprobante(pc_proceso        varchar2,
                                         pn_certificate_id number,
                                         pc_resultado      in out varchar2)
    return boolean is*/
  
    vv_error_detalle VARCHAR2(1500);
    vv_error_corto   VARCHAR2(1500);
  
    --180618pdz
  
    vv_codigoresultado      VARCHAR2(1500);
    vv_descripcion          VARCHAR2(1500);
    vv_tipocomprobante      VARCHAR2(1500);
    vv_serie                VARCHAR2(1500);
    vv_numero               VARCHAR2(1500);
    vv_idcomprobantecliente VARCHAR2(1500);
    vv_codigorespuesta      VARCHAR2(1500);
    vv_descripcionrespuesta VARCHAR2(1500);
    vv_fecharespuesta       VARCHAR2(1500);
    vv_detallerespuesta     VARCHAR2(1500);
    --pv_ListaError           out varchar2
    --
  
    CURSOR c_main_ret IS
      SELECT p.aqpa475valor AS aqpa460rucc
        FROM aqpa475 p
       WHERE p.aqpa475param = 'RUC_EMISOR';
  
    vc_mensaje VARCHAR2(3000);
  
    vn_id_log NUMBER;
  
  BEGIN
  
    /*return true;*/
  
    reqxml_0 := NULL;
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
  
    vn_count := 0;
  
    vv_url_http := fn_ar_get_url_http(pv_type => pc_proceso); --CVEAS CAMBIAR
  
    /*req := utl_http.begin_request(url          => vv_url_http,
    method       => 'POST',
    http_version => 'HTTP/1.1');*/
  
    IF pc_proceso = 'FACTURACION' /*'Obtener_XML'*/
     THEN
    
      FOR x IN c_main_ret LOOP
        vn_count := vn_count + 1;
        reqxml_0 := reqxml_0 || '<?xml version="1.0" encoding="UTF-8"?>';
        reqxml_0 := reqxml_0 || chr(10) ||
                    '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
        reqxml_0 := reqxml_0 || chr(10) ||
                    '   <soap12:Body xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        reqxml_0 := reqxml_0 || '<ConsultarRespuestaComprobante xmlns="http://tempuri.org/">';
        reqxml_0 := reqxml_0 || '<objConsultaComprobante>';
        reqxml_0 := reqxml_0 || '<RucEmisor>' || x.aqpa460rucc || '</RucEmisor>';
        reqxml_0 := reqxml_0 || '<CantidadComprobante>' || vg_cant_comp || '</CantidadComprobante>';
        reqxml_0 := reqxml_0 || '</objConsultaComprobante>';
        reqxml_0 := reqxml_0 || '</ConsultarRespuestaComprobante>';
        reqxml_0 := reqxml_0 || '</soap12:Body>';
        reqxml_0 := reqxml_0 || '</soap12:Envelope>';
      END LOOP;
    
    END IF;
  
    reqxml_4 := reqxml_0;
  
    --pr_xml_ws('INSERT', pc_proceso, pn_certificate_id, reqxml_4, '');
  
    --dbms_output.put_line('reqxml_4 = ' || reqxml_4);
  
    -- corregir
  
    ----CVEAS---<INI>18122018
    pr_jc_insertar_log('ConsultarRespuestaComprobante', vn_id_log, pn_trx_id);
  
    req := utl_http.begin_request(url => vv_url_http, method => 'POST', http_version => 'HTTP/1.1');
    utl_http.set_transfer_timeout(60);
    utl_http.set_header(req, 'Content-Type', 'application/soap+xml; charset=utf-8');
    utl_http.set_header(req, 'Content-Length', length(reqxml_4));
  
    utl_http.write_text(req, reqxml_4);
    resp := utl_http.get_response(req);
    utl_http.read_text(resp, respval);
    --apps.fnd_file.put_line(apps.fnd_file.log, respval);
    utl_http.end_response(resp);
  
    pr_jc_actualizar_log(vn_id_log);
    ----CVEAS---<FIN>18122018
  
    pc_resultado := NULL; --respval;
  
    vc_mensaje := NULL;
  
    --pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, '');
  
    --180618pdz
  
    -- corregir    
    --    dbms_output.put_line('respval: ' || respval);
    --insert into jc.jc_tmp20 values (respval);
  
    pr_ar_consultarrespcomprobante(pc_proceso
                                  ,respval
                                  ,vv_codigoresultado
                                  ,vv_descripcion
                                  ,vv_tipocomprobante
                                  ,vv_serie
                                  ,vv_numero
                                  ,vv_idcomprobantecliente
                                  ,vv_codigorespuesta
                                  ,vv_descripcionrespuesta
                                  ,vv_fecharespuesta
                                  ,vv_detallerespuesta);
    --180618pdz                          
  
    /*dbms_output.put_line('vv_CodigoResultado = '||vv_CodigoResultado); 
    dbms_output.put_line('vv_Descripcion = '||vv_Descripcion); 
    dbms_output.put_line('vv_TipoComprobante = '||vv_TipoComprobante); 
    dbms_output.put_line('vv_Serie = '||vv_Serie);
    dbms_output.put_line('vv_Numero = '||vv_Numero);  
    dbms_output.put_line('vv_IdComprobanteCliente = '||vv_IdComprobanteCliente); 
    dbms_output.put_line('vv_CodigoRespuesta = '||vv_CodigoRespuesta); 
    dbms_output.put_line('vv_DescripcionRespuesta = '||vv_DescripcionRespuesta); 
    dbms_output.put_line('vv_FechaRespuesta = '||vv_FechaRespuesta);
    dbms_output.put_line('vv_DetalleRespuesta = '||vv_DetalleRespuesta);*/
  
    IF instr(respval, '<?xml version="1.0" encoding="utf-8"?') >= 1 THEN
    
      pc_resultado := NULL;
    
      --  commit;
      RETURN TRUE;
      --dbms_output.put_line('TRUE'); 
      --dbms_output.put_line('reqxml_4 = ' || 'TRUE');
      /*dbms_output.put_line('reqxml_4 = '||respval);
      dbms_output.put_line('reqxml_4 = '||pn_certificate_id);
      dbms_output.put_line('reqxml_4 = '||pc_resultado);*/
    
      --end if;
    
      /*if vc_mensaje is not null then
      pc_resultado := vc_mensaje;
      return false;*/
    ELSE
      --return false;
      --dbms_output.put_line('FALSE'); 
      /* if instr(respval, '<?xml version="1.0" encoding="utf-8"?') >= 1 then
        pc_resultado := null;
        update JC.JC_EDE_LO_AR_HEADER_ALL h
           set 
               h.STATUS_OF = ''
               ,h.STATUS_OF_DESC = ''
               ,h.ERROR_TCI = null
               ,h.DESC_ERROR_TCI = null
               ,h.ERROR_ESTADO = ''
               ,h.DESC_ERROR_ESTADO = '' -- corregir
         where h.certificate_id = pn_certificate_id;
         commit;
        return true;
      else
        update JC.JC_EDE_LO_AR_HEADER_ALL h
           set 
               h.STATUS_OF = 'PEN_ACT_EST'
               ,h.STATUS_OF_DESC = 'Error de Formato en Trama de Retorno'
               ,h.ERROR_TCI = null
               ,h.DESC_ERROR_TCI = null
               ,h.ERROR_ESTADO = 'WS'
               ,h.DESC_ERROR_ESTADO = 'Error de Formato en Trama de Retorno'
         where h.certificate_id = pn_certificate_id;  */
      pc_resultado := NULL;
      RETURN FALSE;
      --end if;
    END IF;
  
  EXCEPTION
    /*when ve_exc_2 then
    
    apps.fnd_file.put_line(apps.fnd_file.output, 'Error WS: No hay datos para env?o');
    pc_resultado := 'Error WS: No hay datos para env?o';
    
    pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, pc_resultado);
    
    return false;*/
  
    /*when ve_exc then
    apps.fnd_file.put_line(apps.fnd_file.output, vv_message);
    pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, vv_message);
    
    return false;*/
    WHEN utl_http.end_of_body THEN
      vv_error_detalle := dbms_utility.format_error_backtrace;
      vv_error_corto   := SQLERRM;
      pc_resultado     := 'Error estructura xml (8) - ' || vv_error_corto || ' - ' || vv_error_detalle;
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
      RETURN FALSE;
      --dbms_output.put_line('FALSE');
  
    WHEN OTHERS THEN
      --dbms_output.put_line('Error WS: ' || sqlerrm);
      --apps.fnd_file.put_line(apps.fnd_file.log, 'Error WS: ' || sqlerrm);
      vv_error_detalle := dbms_utility.format_error_backtrace;
      vv_error_corto   := SQLERRM;
      pc_resultado     := vv_error_corto || ' - ' || vv_error_detalle;
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
    
      RETURN FALSE;
      --dbms_output.put_line('FALSE');
    --dbms_output.put_line('reqxml_4 = '||respval);
    --d-bms_output.put_line('reqxml_4 = '||pn_certificate_id);
    --dbms_output.put_line('reqxml_4 = '||pc_resultado);
  
  END fn_ar_consrespcomp;

  -- *******************************************************************
  -- Nombre                    : PROCESO PARA CONSULTAR RESPONSABLE COMPROBANTE
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- ******************************************************************* 

  PROCEDURE pr_ar_consultarrespcomprobante(pc_proceso              IN VARCHAR2
                                          ,vc_respval              IN VARCHAR2
                                          ,pv_codigoresultado      OUT VARCHAR2
                                          ,pv_descripcion          OUT VARCHAR2
                                          ,pv_tipocomprobante      OUT VARCHAR2
                                          ,pv_serie                OUT VARCHAR2
                                          ,pv_numero               OUT VARCHAR2
                                          ,pv_idcomprobantecliente OUT VARCHAR2
                                          ,pv_codigorespuesta      OUT VARCHAR2
                                          ,pv_descripcionrespuesta OUT VARCHAR2
                                          ,pv_fecharespuesta       OUT VARCHAR2
                                          ,pv_detallerespuesta     OUT VARCHAR
                                           --pv_ListaError           out varchar2
                                           
                                           ) IS
  
    vn_point_ini            NUMBER := 0;
    vn_point_fin            NUMBER := 0;
    vc_point_ini            VARCHAR2(3000);
    vc_point_fin            VARCHAR2(3000);
    vc_val_resultado        VARCHAR2(3000);
    vc_val_codigohash       VARCHAR2(3000);
    vc_val_mensajeresultado VARCHAR2(3000);
    vc_val_nombrexml        VARCHAR2(3000);
    vc_val_codigoerror      VARCHAR2(3000);
    vv_serial_comp          aqpa471.aqpa460seri%TYPE;
    vn_numero_comp          aqpa471.aqpa460num%TYPE;
    --
    vv_serie         VARCHAR2(25);
    vn_numero        NUMBER;
    vn_estados       VARCHAR2(3000);
    vv_codigo_resp   VARCHAR2(1);
    vn_point_ini_aux NUMBER;
    --
  BEGIN
  
    --pv_desc_error_consulta := null;
  
    IF pc_proceso = 'FACTURACION' THEN
    
      vc_point_ini       := '<CodigoResultado>';
      vc_point_fin       := '</CodigoResultado>';
      vn_point_ini       := instr(vc_respval, vc_point_ini);
      vn_point_fin       := instr(vc_respval, vc_point_fin);
      pv_codigoresultado := substr(vc_respval
                                  ,vn_point_ini + length(vc_point_ini)
                                  ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      vc_point_ini            := '<Descripcion>';
      vc_point_fin            := '</Descripcion>';
      vn_point_ini            := instr(vc_respval, vc_point_ini);
      vn_point_fin            := instr(vc_respval, vc_point_fin);
      pv_descripcionrespuesta := substr(vc_respval
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      --
      -- Analizamos los documentos retornados
      vn_point_ini_aux := 1;
      LOOP
        -- Obtenemos cada seccion de ListaEstadoComprobante
        vc_point_ini := '<ENComprobanteRespuesta>';
        vc_point_fin := '</ENComprobanteRespuesta>';
        vn_point_ini := instr(vc_respval, vc_point_ini, vn_point_ini_aux);
        vn_point_fin := instr(vc_respval, vc_point_fin, vn_point_ini_aux);
        vn_estados   := substr(vc_respval
                              ,vn_point_ini + length(vc_point_ini)
                              ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
        IF (vn_estados IS NULL) THEN
          EXIT;
        ELSE
          vn_point_ini_aux := vn_point_fin + 1;
          --dbms_output.put_line('seccion: ' || vn_estados);
        
          vc_point_ini       := '<TipoComprobante>';
          vc_point_fin       := '</TipoComprobante>';
          vn_point_ini       := instr(vn_estados, vc_point_ini);
          vn_point_fin       := instr(vn_estados, vc_point_fin);
          pv_tipocomprobante := substr(vn_estados
                                      ,vn_point_ini + length(vc_point_ini)
                                      ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
        
          vc_point_ini := '<Serie>';
          vc_point_fin := '</Serie>';
          vn_point_ini := instr(vn_estados, vc_point_ini);
          vn_point_fin := instr(vn_estados, vc_point_fin);
          vv_serie     := substr(vn_estados
                                ,vn_point_ini + length(vc_point_ini)
                                ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
        
          pv_serie := vv_serie;
        
          EXIT WHEN vv_serie IS NULL;
        
          vc_point_ini := '<Numero>';
          vc_point_fin := '</Numero>';
          vn_point_ini := instr(vn_estados, vc_point_ini);
          vn_point_fin := instr(vn_estados, vc_point_fin);
          vn_numero    := to_number(substr(vn_estados
                                          ,vn_point_ini + length(vc_point_ini)
                                          ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1));
        
          pv_numero := vn_numero;
        
          vc_point_ini            := '<IdComprobanteCliente>';
          vc_point_fin            := '</IdComprobanteCliente>';
          vn_point_ini            := instr(vn_estados, vc_point_ini);
          vn_point_fin            := instr(vn_estados, vc_point_fin);
          pv_idcomprobantecliente := substr(vn_estados
                                           ,vn_point_ini + length(vc_point_ini)
                                           ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
        
          vc_point_ini   := '<CodigoRespuesta>';
          vc_point_fin   := '</CodigoRespuesta>';
          vn_point_ini   := instr(vn_estados, vc_point_ini);
          vn_point_fin   := instr(vn_estados, vc_point_fin);
          vv_codigo_resp := substr(vn_estados
                                  ,vn_point_ini + length(vc_point_ini)
                                  ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
        
          pv_codigorespuesta := vv_codigo_resp;
        
          vc_point_ini            := '<DescripcionRespuesta>';
          vc_point_fin            := '</DescripcionRespuesta>';
          vn_point_ini            := instr(vn_estados, vc_point_ini);
          vn_point_fin            := instr(vn_estados, vc_point_fin);
          pv_descripcionrespuesta := substr(vn_estados
                                           ,vn_point_ini + length(vc_point_ini)
                                           ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
        
          vc_point_ini      := '<FechaRespuesta>';
          vc_point_fin      := '</FechaRespuesta>';
          vn_point_ini      := instr(vn_estados, vc_point_ini);
          vn_point_fin      := instr(vn_estados, vc_point_fin);
          pv_fecharespuesta := substr(vn_estados
                                     ,vn_point_ini + length(vc_point_ini)
                                     ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
        
          vc_point_ini        := '<DetalleRespuesta>';
          vc_point_fin        := '</DetalleRespuesta>';
          vn_point_ini        := instr(vn_estados, vc_point_ini);
          vn_point_fin        := instr(vn_estados, vc_point_fin);
          pv_detallerespuesta := substr(vn_estados
                                       ,vn_point_ini + length(vc_point_ini)
                                       ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
        
          IF vv_codigo_resp IS NOT NULL THEN
            UPDATE aqpa471 h
               SET h.aqpa471codrco = vv_codigo_resp
             WHERE h.aqpa460seri = vv_serie
               AND h.aqpa460num = vn_numero
               AND h.aqpa471codrco IS NULL;
          END IF;
          --
        END IF;
        --
      END LOOP;
      --
    
    END IF;
  
  END pr_ar_consultarrespcomprobante;

  --

  -- *******************************************************************
  -- Nombre                    : FUNCION CONFIRMAR RESPONSABLE DE COMPROBANTE
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : Confirmar Responsable de Comprobante
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- *******************************************************************    

  FUNCTION fn_ar_confrespcomp(pc_proceso   VARCHAR2
                             ,pn_trx_id    NUMBER
                             ,pc_resultado IN OUT VARCHAR2) RETURN BOOLEAN IS
  
    /*function fu_Confirmar_Resp_Comprobante(pc_proceso        varchar2,
                                         pn_certificate_id number,
                                         pc_resultado      in out varchar2)
    return boolean is*/
  
    vv_error_detalle VARCHAR2(1500);
    vv_error_corto   VARCHAR2(1500);
  
    --180618pdz
  
    vv_codigoresultado  VARCHAR2(1500);
    vv_descripcion      VARCHAR2(1500);
    vv_tipocomprobante  VARCHAR2(1500);
    vv_serie            VARCHAR2(1500);
    vv_numero           VARCHAR2(1500);
    vv_descripcionerror VARCHAR2(1500);
    --
  
    CURSOR c_main_ret IS
      SELECT p.aqpa475valor AS aqpa460rucc
        FROM aqpa475 p
       WHERE p.aqpa475param = 'RUC_EMISOR';
  
    vc_mensaje VARCHAR2(3000);
  
  BEGIN
  
    /*return true;*/
  
    reqxml_0 := NULL;
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
  
    vn_count := 0;
  
    vv_url_http := fn_ar_get_url_http(pv_type => pc_proceso); --CVEAS CAMBIAR
  
    /*req := utl_http.begin_request(url          => vv_url_http,
    method       => 'POST',
    http_version => 'HTTP/1.1');*/
  
    IF pc_proceso = 'FACTURACION' /*'Obtener_XML'*/
     THEN
    
      FOR x IN c_main_ret LOOP
      
        vn_count := vn_count + 1;
        reqxml_0 := reqxml_0 || '<?xml version="1.0" encoding="UTF-8"?>';
        reqxml_0 := reqxml_0 || chr(10) ||
                    '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
        reqxml_0 := reqxml_0 || chr(10) ||
                    '   <soap12:Body xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        reqxml_0 := reqxml_0 || '<ConfirmarRespuestaComprobante xmlns="http://tempuri.org/">';
        reqxml_0 := reqxml_0 || '<objENConfirmarRespuestaComprobante>';
        reqxml_0 := reqxml_0 || '<RucEmisor>' || x.aqpa460rucc || '</RucEmisor>';
        reqxml_0 := reqxml_0 || '<DetalleComprobante />';
        /*-- loop
         
           reqxml_0 := reqxml_0 || '<oENDetalleComprobante>';
           reqxml_0 := reqxml_0 || '<TipoComprobante>' || x.tipo_comp ||
                       '</TipoComprobante>';
           reqxml_0 := reqxml_0 || '<Serie>' || x.serial_comp || '</Serie>';
           reqxml_0 := reqxml_0 || '<Numero>' || x.numero_comp ||
                       '</Numero>';
         
           reqxml_0 := reqxml_0 || '</oENDetalleComprobante>';
         
        -- end loop;*/
      
        reqxml_0 := reqxml_0 || '</objENConfirmarRespuestaComprobante>';
        reqxml_0 := reqxml_0 || '</ConfirmarRespuestaComprobante>';
        reqxml_0 := reqxml_0 || '</soap12:Body>';
        reqxml_0 := reqxml_0 || '</soap12:Envelope>';
      END LOOP;
    
    END IF;
  
    reqxml_4 := reqxml_0;
  
    --pr_xml_ws('INSERT', pc_proceso, pn_certificate_id, reqxml_4, '');
  
    --dbms_output.put_line('reqxml_4 = ' || reqxml_4);
  
    -- corregir
  
    ----CVEAS---<INI>18122018
    pr_jc_insertar_log('ConfirmarRespuestaComprobante', vn_id_log, pn_trx_id);
  
    req := utl_http.begin_request(url => vv_url_http, method => 'POST', http_version => 'HTTP/1.1');
    utl_http.set_transfer_timeout(60);
    utl_http.set_header(req, 'Content-Type', 'application/soap+xml; charset=utf-8');
    utl_http.set_header(req, 'Content-Length', length(reqxml_4));
    utl_http.write_text(req, reqxml_4);
    resp := utl_http.get_response(req);
    utl_http.read_text(resp, respval);
    -- apps.fnd_file.put_line(apps.fnd_file.log, respval); ---CVEAS
    utl_http.end_response(resp);
  
    pr_jc_actualizar_log(vn_id_log);
    ----CVEAS---<FIN>18122018
  
    pc_resultado := NULL; --respval;
  
    vc_mensaje := NULL;
  
    --pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, '');
    --dbms_output.put_line('respval = ' || respval);
    --180618pdz
  
    pr_ar_confirmarrespcomprobante(pc_proceso
                                  ,respval
                                  ,vv_codigoresultado
                                  ,vv_descripcion
                                  ,vv_tipocomprobante
                                  ,vv_serie
                                  ,vv_numero
                                  ,vv_descripcionerror);
  
    --180618pdz                          
  
    /*dbms_output.put_line('vv_CodigoResultado = ' || vv_CodigoResultado);
    dbms_output.put_line('vv_Descripcion = ' ||
                         vv_Descripcion);
    dbms_output.put_line('vv_TipoComprobante = ' || vv_TipoComprobante);
    dbms_output.put_line('vv_Serie = ' || vv_Serie);
    dbms_output.put_line('vv_Numero = ' || vv_Numero);
    dbms_output.put_line('vv_DescripcionError = ' || vv_DescripcionError);*/
  
    IF instr(respval, '<?xml version="1.0" encoding="utf-8"?') >= 1 THEN
    
      pc_resultado := NULL;
    
      --  commit;
      RETURN TRUE;
      --dbms_output.put_line('TRUE'); 
      --dbms_output.put_line('reqxml_4 = ' || 'TRUE');
      /*dbms_output.put_line('reqxml_4 = '||respval);
      dbms_output.put_line('reqxml_4 = '||pn_certificate_id);
      dbms_output.put_line('reqxml_4 = '||pc_resultado);*/
    
      --end if;
    
      /*if vc_mensaje is not null then
      pc_resultado := vc_mensaje;
      return false;*/
    ELSE
      --return false;
      --dbms_output.put_line('FALSE'); 
      /* if instr(respval, '<?xml version="1.0" encoding="utf-8"?') >= 1 then
        pc_resultado := null;
        update JC.JC_EDE_LO_AR_HEADER_ALL h
           set 
               h.STATUS_OF = ''
               ,h.STATUS_OF_DESC = ''
               ,h.ERROR_TCI = null
               ,h.DESC_ERROR_TCI = null
               ,h.ERROR_ESTADO = ''
               ,h.DESC_ERROR_ESTADO = '' -- corregir
         where h.certificate_id = pn_certificate_id;
         commit;
        return true;
      else
        update JC.JC_EDE_LO_AR_HEADER_ALL h
           set 
               h.STATUS_OF = 'PEN_ACT_EST'
               ,h.STATUS_OF_DESC = 'Error de Formato en Trama de Retorno'
               ,h.ERROR_TCI = null
               ,h.DESC_ERROR_TCI = null
               ,h.ERROR_ESTADO = 'WS'
               ,h.DESC_ERROR_ESTADO = 'Error de Formato en Trama de Retorno'
         where h.certificate_id = pn_certificate_id;  */
      pc_resultado := NULL;
      RETURN FALSE;
      --end if;
    END IF;
  
  EXCEPTION
    /*when ve_exc_2 then
    
    apps.fnd_file.put_line(apps.fnd_file.output, 'Error WS: No hay datos para env?o');
    pc_resultado := 'Error WS: No hay datos para env?o';
    
    pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, pc_resultado);
    
    return false;*/
  
    /*when ve_exc then
    apps.fnd_file.put_line(apps.fnd_file.output, vv_message);
    pr_xml_ws('UPDATE', pc_proceso, pn_certificate_id, respval, vv_message);
    
    return false;*/
    WHEN utl_http.end_of_body THEN
      vv_error_detalle := dbms_utility.format_error_backtrace;
      vv_error_corto   := SQLERRM;
      pc_resultado     := 'Error estructura xml (9) - ' || vv_error_corto || ' - ' || vv_error_detalle;
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
      RETURN FALSE;
      --dbms_output.put_line('FALSE');
  
    WHEN OTHERS THEN
      --dbms_output.put_line('Error WS: ' || sqlerrm);
      --apps.fnd_file.put_line(apps.fnd_file.log, 'Error WS: ' || sqlerrm);
      vv_error_detalle := dbms_utility.format_error_backtrace;
      vv_error_corto   := SQLERRM;
      pc_resultado     := vv_error_corto || ' - ' || vv_error_detalle;
      pr_ar_xml_ws('UPDATE', pc_proceso, pn_trx_id, respval, pc_resultado);
    
      RETURN FALSE;
      --dbms_output.put_line('FALSE');
    --dbms_output.put_line('reqxml_4 = '||respval);
    --d-bms_output.put_line('reqxml_4 = '||pn_certificate_id);
    --dbms_output.put_line('reqxml_4 = '||pc_resultado);
  
  END fn_ar_confrespcomp;

  -- *******************************************************************
  -- Nombre                    : PROCESO PARA CONFIRMAR RESPONSABLE COMPROBANTE
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- ******************************************************************* 

  PROCEDURE pr_ar_confirmarrespcomprobante(pc_proceso          IN VARCHAR2
                                          ,vc_respval          IN VARCHAR2
                                          ,pv_codigoresultado  OUT VARCHAR2
                                          ,pv_descripcion      OUT VARCHAR2
                                          ,pv_tipocomprobante  OUT VARCHAR2
                                          ,pv_serie            OUT VARCHAR2
                                          ,pv_numero           OUT VARCHAR2
                                          ,pv_descripcionerror OUT VARCHAR2) IS
  
    vn_point_ini            NUMBER := 0;
    vn_point_fin            NUMBER := 0;
    vc_point_ini            VARCHAR2(3000);
    vc_point_fin            VARCHAR2(3000);
    vc_val_resultado        VARCHAR2(3000);
    vc_val_codigohash       VARCHAR2(3000);
    vc_val_mensajeresultado VARCHAR2(3000);
    vc_val_nombrexml        VARCHAR2(3000);
    vc_val_codigoerror      VARCHAR2(3000);
    vv_serial_comp          aqpa471.aqpa460seri%TYPE;
    vn_numero_comp          aqpa471.aqpa460num%TYPE;
    --
    vn_point_ini_aux NUMBER;
    vn_estados       VARCHAR2(3000);
    vv_desc_error    VARCHAR2(500);
    vv_serie         VARCHAR2(25);
    vn_numero        NUMBER;
    --
  
  BEGIN
  
    --pv_desc_error_consulta := null;
  
    IF pc_proceso = 'FACTURACION' THEN
    
      vc_point_ini       := '<CodigoResultado>';
      vc_point_fin       := '</CodigoResultado>';
      vn_point_ini       := instr(vc_respval, vc_point_ini);
      vn_point_fin       := instr(vc_respval, vc_point_fin);
      pv_codigoresultado := substr(vc_respval
                                  ,vn_point_ini + length(vc_point_ini)
                                  ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      vc_point_ini   := '<Descripcion>';
      vc_point_fin   := '</Descripcion>';
      vn_point_ini   := instr(vc_respval, vc_point_ini);
      vn_point_fin   := instr(vc_respval, vc_point_fin);
      pv_descripcion := substr(vc_respval
                              ,vn_point_ini + length(vc_point_ini)
                              ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
    
      /*dbms_output.put_line('CodigoResultado: ' || pv_CodigoResultado);
      dbms_output.put_line('Descripcion: ' || pv_Descripcion);*/
    
      -- Analizamos los documentos retornados
      vn_point_ini_aux := 1;
    
      LOOP
        -- Obtenemos cada seccion de ListaEstadoComprobante
        vc_point_ini := '<ENDetalleComprobanteError>';
        vc_point_fin := '</ENDetalleComprobanteError>';
        vn_point_ini := instr(vc_respval, vc_point_ini, vn_point_ini_aux);
        vn_point_fin := instr(vc_respval, vc_point_fin, vn_point_ini_aux);
        vn_estados   := substr(vc_respval
                              ,vn_point_ini + length(vc_point_ini)
                              ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
        IF (vn_estados IS NULL) THEN
          EXIT;
        ELSE
          vn_point_ini_aux := vn_point_fin + 1;
          --dbms_output.put_line('seccion: ' || vn_estados);
          vc_point_ini       := '<TipoComprobante>';
          vc_point_fin       := '</TipoComprobante>';
          vn_point_ini       := instr(vn_estados, vc_point_ini);
          vn_point_fin       := instr(vn_estados, vc_point_fin);
          pv_tipocomprobante := substr(vn_estados
                                      ,vn_point_ini + length(vc_point_ini)
                                      ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
        
          vc_point_ini := '<Serie>';
          vc_point_fin := '</Serie>';
          vn_point_ini := instr(vn_estados, vc_point_ini);
          vn_point_fin := instr(vn_estados, vc_point_fin);
          vv_serie     := substr(vn_estados
                                ,vn_point_ini + length(vc_point_ini)
                                ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
        
          pv_serie := vv_serie;
        
          EXIT WHEN vv_serie IS NULL;
        
          vc_point_ini := '<Numero>';
          vc_point_fin := '</Numero>';
          vn_point_ini := instr(vn_estados, vc_point_ini);
          vn_point_fin := instr(vn_estados, vc_point_fin);
          vn_numero    := to_number(substr(vn_estados
                                          ,vn_point_ini + length(vc_point_ini)
                                          ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1));
        
          pv_numero := vn_numero;
        
          /*dbms_output.put_line('serie: ' || vv_serie);
          dbms_output.put_line('numero: ' || vn_numero);*/
        
          vc_point_ini  := '<DescripcionError>';
          vc_point_fin  := '</DescripcionError>';
          vn_point_ini  := instr(vn_estados, vc_point_ini);
          vn_point_fin  := instr(vn_estados, vc_point_fin);
          vv_desc_error := substr(vn_estados
                                 ,vn_point_ini + length(vc_point_ini)
                                 ,(vn_point_fin - vn_point_ini) - length(vc_point_fin) + 1);
        
          pv_descripcionerror := vv_desc_error;
        
          IF (vn_point_ini > 0 AND vn_point_fin > 0) THEN
            IF (vv_desc_error IS NULL) THEN
              UPDATE aqpa471 h
                 SET h.aqpa471conrco = 'Y'
                    ,h.aqpa471ereco  = NULL
               WHERE h.aqpa460seri = vv_serie
                 AND h.aqpa460num = vn_numero
                 AND nvl(h.aqpa471conrco, 'N') = 'N';
            ELSE
              UPDATE aqpa471 h
                 SET h.aqpa471conrco = 'N'
                    ,h.aqpa471ereco  = vv_desc_error
               WHERE h.aqpa460seri = vv_serie
                 AND h.aqpa460num = vn_numero
                 AND nvl(h.aqpa471conrco, 'N') = 'N';
            END IF;
          
          END IF;
          --
        END IF;
        --
      END LOOP;
    
    END IF;
  
  END pr_ar_confirmarrespcomprobante;

  -- *******************************************************************
  -- Nombre                    : FUNCION
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- *******************************************************************  

  FUNCTION fn_ar_get_url_http(pv_type VARCHAR2) RETURN VARCHAR2 IS
  
    vv_url_http aqpa474.aqpa474urlhttp%TYPE;
    vv_db       VARCHAR2(50);
  BEGIN
  
    SELECT aqpa474urlhttp
      INTO vv_url_http
      FROM aqpa474 t
     WHERE 1 = 1
       AND t.aqpa474type = pv_type;
    --AND T.URL_HTTP IS NOT NULL; -- 21/12/2018
  
    RETURN vv_url_http;
  
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  -- *******************************************************************
  -- Nombre                    : PROCESO PARA VERIFICAR PROCESO
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- ******************************************************************* 

  PROCEDURE pr_ar_verifica_proceso(errbuf  OUT VARCHAR2
                                  ,retcode OUT VARCHAR2) IS
    vn_req_id          NUMBER;
    l_layout           BOOLEAN;
    l_bol_delivery     BOOLEAN;
    vn_cuenta_x_avisar NUMBER;
    vn_alert_id        NUMBER;
    vn_cuenta          NUMBER;
    vv_resultado       VARCHAR2(1500);
    vb_retorno         BOOLEAN;
    vb_cons_esta       BOOLEAN;
    vv_retorno         VARCHAR2(1500);
    vv_email_para      VARCHAR2(3000);
    vv_email_cc        VARCHAR2(3000);
    vn_cuenta_xrevisar NUMBER;
  BEGIN
  
    --
    vb_cons_esta := fn_ar_consultarestadocomp_ws('FACTURACION', NULL, vv_retorno);
  
    -- Cargamos los archivos xml y pdf para los documentos ACEPTADOS
    SELECT COUNT(1)
      INTO vn_cuenta
      FROM aqpa471 h
     WHERE h.aqpa471status = 'ACEPTADO'
       AND (h.aqpa471noxml IS NULL OR h.aqpa471nopdf IS NULL);
    IF (vn_cuenta > 0) THEN
      --sys.DBMS_LOCK.sleep(2*60);    CORREGIR
      FOR r IN (SELECT h.aqpa471trxid
                  FROM aqpa471 h
                 WHERE h.aqpa471status = 'ACEPTADO'
                   AND (h.aqpa471noxml IS NULL OR h.aqpa471nopdf IS NULL)) LOOP
        --
        vb_retorno := fn_ar_obtener_xml_ws('FACTURACION', r.aqpa471trxid, vv_resultado);
      
        vb_retorno := fn_ar_obtener_pdf_ws('FACTURACION', r.aqpa471trxid, vv_resultado);
        --               
      END LOOP;
    END IF;
  
    COMMIT;
  
    --CVEAS REVISAR    
    -- En caso haya errores, enviar el reporte de estados al administrador de BANTOTAL
  
    SELECT COUNT(1) -- x.ESTADO
      INTO vn_cuenta_xrevisar
      FROM jc_ar_fe_est_doc_v x
     WHERE x.estado IN ('PEN_BT', 'PEN_ACT_EST', 'PEN_EMI');
  
    /* if (vn_cuenta_xrevisar > 0) then
          --
          
    --CVEAS REVISAR   
    
         
         \* l_layout := 
         apps.fnd_request.add_layout (
          template_appl_name  => 'JC',
          template_code       => 'JC_AR_FE_EST_DOC',
          template_language   => 'es',
          template_territory  => null,
          output_format       => 'EXCEL'
          );
          *\
          
    --CVEAS REVISAR      
    
      \*    -- Obtenemos los correos de los admistradores del modulo EDE
          select LISTAGG(a1.FLEX_VALUE, '; ') WITHIN GROUP (ORDER BY a1.FLEX_VALUE) 
           into vv_email_para
           from apps.fnd_flex_values_vl  a1
               ,apps.fnd_flex_value_sets b1
          where a1.flex_value_set_id = b1.flex_value_set_id
            and b1.flex_value_set_name = 'JC_EDE_LO_AR_EMAIL_ADMIN'
            and a1.enabled_flag = 'Y'
            and trunc(sysdate) between nvl(a1.start_date_active, sysdate - 1) and nvl(a1.end_date_active, sysdate + 1)
            and a1.attribute1 = 'P';
    
          select LISTAGG(a1.FLEX_VALUE, '; ') WITHIN GROUP (ORDER BY a1.FLEX_VALUE) 
           into vv_email_cc
           from apps.fnd_flex_values_vl  a1
               ,apps.fnd_flex_value_sets b1
          where a1.flex_value_set_id = b1.flex_value_set_id
            and b1.flex_value_set_name = 'JC_EDE_LO_AR_EMAIL_ADMIN'
            and a1.enabled_flag = 'Y'
            and trunc(sysdate) between nvl(a1.start_date_active, sysdate - 1) and nvl(a1.end_date_active, sysdate + 1)
            and a1.attribute1 = 'C';      
    
    
         l_bol_delivery := apps.fnd_request.add_delivery_option 
          (TYPE             => 'E', -- EMAIL
          p_argument1      => 'JC - EDE - Reporte de Documentos Electronicos POR REVISAR', -- Email Subject
          p_argument2      => 'notificacionesebs@cajaarequipa.pe',-- From Address
          p_argument3      => vv_email_para,   -- To Address
          p_argument4      => vv_email_cc    -- CC
          );
    
          vn_req_id := apps.fnd_request.submit_request(application => 'JC',
                                                       program     => 'JC_AR_FE_EST_DOC',
                                                       description => null,
                                                       start_time  => sysdate,
                                                       sub_request => null,
                                                       --
                                                       argument1   => null,
                                                       argument2   => null,
                                                       argument3   => null,
                                                       argument4   => null,
                                                       argument5   => null,
                                                       argument6   => null,                                                                                                                                                   
                                                       argument7   => 'REVISAR'
                                                       );*\
                                                       
    
          commit;      
          --
        
        end if;
    
        -- En caso haya documentos por informar al cliente, ejecutar la alerta:
    
        select count(1)
          into vn_cuenta_x_avisar
          from AQPA471 h
          where AQPA471FAVCL is null
            and AQPA471STATUS = 'ACEPTADO';
    
        if (vn_cuenta_x_avisar > 0) then
          
          \*select alert_id
            into vn_alert_id
            from alr.alr_alerts
           where alert_name = 'JC_AR_FE_AVISO_CLIENTE';
    
          vn_req_id := apps.fnd_request.submit_request(application => 'ALR',
                                                     program     => 'ALECDC',
                                                     description => null,
                                                     start_time  => sysdate,
                                                     sub_request => null,
                                                     --
                                                     argument1   => '200',
                                                     argument2   => vn_alert_id,
                                                     argument3   => 'A'
                                                     ); *\  
          -- Metodo SMTP                                                 
          \*for r in (
                    select h.certificate_id
                      from JC.JC_EDE_LO_AR_HEADER_ALL h
                      where FECHA_AVISO_CLIENTE is null
                        and status_of = 'ACEPTADO'      
                   ) loop
            --
            jc.jc_ede_lo_ar_webservice_pkg.pr_avisar_cliente(r.certificate_id);
            --               
          end loop;*\                                                                
                                                     
          commit;                                                     
           
        end if;*/
  
    --    
  
  END;

  -- *******************************************************************
  -- Nombre                    : FUNCION ACTUALIZAR ESTADO TCI MASIVO
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- ******************************************************************* 

  FUNCTION fn_ar_actu_esta_tci_masivo RETURN BOOLEAN IS
  
  BEGIN
  
    -- Hacemos una espera
    --sys.DBMS_LOCK.sleep(2*60);   CORREGIR
  
    FOR r IN (SELECT h.aqpa471trxid
                FROM aqpa471 h
               WHERE h.aqpa471status = 'PEN_ACT_EST'
                 AND h.aqpa471ertci IS NULL
                 AND (h.aqpa471eres IS NULL OR h.aqpa471eres IN ('-3', '-1', 'WS'))) LOOP
      --             
      pr_ar_refresh_ede(r.aqpa471trxid);
      --          
    END LOOP;
  
    RETURN TRUE;
  
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
    
  END;

  PROCEDURE pr_ar_actu_esta_tci(pn_trxid IN NUMBER) IS
  
  BEGIN
    --bv 26/12/2018
    pr_ar_log_bt('31');
    FOR r IN (SELECT h.aqpa471trxid
                FROM aqpa471 h
               WHERE h.aqpa471status = 'PEN_ACT_EST'
                 AND h.aqpa471ertci IS NULL
                 AND (h.aqpa471eres IS NULL OR h.aqpa471eres IN ('-3', '-1', 'WS'))
                 AND h.aqpa471trxid = pn_trxid) LOOP
      --             
      pr_ar_refresh_ede(r.aqpa471trxid);
      --          
    END LOOP;
    --bv 26/12/2018
    pr_ar_log_bt('32');
  END;

  -- *******************************************************************
  -- Nombre                    : FUNCION INSERTAR DATA
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- ******************************************************************* 

  FUNCTION fn_ar_inserta_data RETURN BOOLEAN IS
  
    vv_serie    VARCHAR2(4);
    vn_numero   NUMBER;
    vn_cuenta_h NUMBER := 0;
    vn_cuenta_d NUMBER := 0;
  
    CURSOR c_main_h IS
      SELECT DISTINCT aqpa460seri serial_comp
                     ,aqpa460num numero_comp
                     ,aqpa460femi fecha_emi_comp
                     ,aqpa460hemi AS hora_emi_comp
                     ,aqpa460tcomf tipo_comp
                     ,aqpa460mglo glosa_comp
                     ,aqpa460mone moneda_comp
                     ,aqpa460tope tipooper_comp
                     ,'Factura' AS tipooper_des_comp
                     ,aqpa460impt AS importe_total_comp
                     ,aqpa460mtimp importe_total_igv_comp
                     ,aqpa460pcima porcentaje_igv_comp
                     ,aqpa460mtimp importe_igv_comp
                     ,aqpa460nruc customer_number
                     ,aqpa460rasoc customer_name
                     ,aqpa460tdocr customer_type
                     ,TRIM(aqpa460corrr) customer_mail
                     ,aqpa460rsoc organization_name
                     ,aqpa460rucc organization_ruc
                     ,'PEN_EMI' status_of
                     ,'Pendiente de Enviar a TCI' status_of_desc
                     ,aqpa460cdis AS cod_ubigeo
                     ,aqpa460cpais AS cod_pais_emisor
                      --
                     ,aqpa460cdley
                     ,aqpa460teley
                     ,aqpa460text1
                     ,aqpa460text2
                     ,aqpa460trecv
                     ,aqpa460templ
                     ,aqpa460subje
                     ,aqpa460mtotal
                     ,aqpa460baimp
                     ,aqpa460mtimp
                     ,aqpa460pcima
                     ,aqpa460bsimp
                     ,aqpa460vaimp
                     ,aqpa460mtinf
                     ,aqpa460mtgrt
                     ,aqpa460bsimps
                     ,aqpa460mtoti
                     ,aqpa460tdoc
                     ,aqpa460rucc
                     ,aqpa460rsoc
                     ,aqpa460cdis
                     ,aqpa460ncom
                     ,aqpa460calle
                     ,aqpa460urba
                     ,aqpa460depa
                     ,aqpa460prov
                     ,aqpa460dist
                     ,aqpa460telf
                     ,aqpa460web
                     ,aqpa460cpais
                     ,aqpa460cesun
                     ,aqpa460seri
                     ,aqpa460num
                     ,aqpa460femi
                     ,aqpa460tcomf
                     ,aqpa460mone
                     ,aqpa460corrr
                     ,aqpa460mglo
                     ,aqpa460coma
                     ,aqpa460tpla
                     ,aqpa460tope
                     ,aqpa460tplco
                     ,aqpa460clog
                     ,aqpa460tdocr
                     ,aqpa460nruc
                     ,aqpa460rasoc
                     ,aqpa460impt
                     ,aqpa460hemi
                     ,aqpa460simc
                     ,aqpa460svitm
                     ,aqpa460spvi
                     ,aqpa460txml
                     ,aqpa460cdist
                     ,aqpa460call
                     ,aqpa460urb
                     ,aqpa460dep
                     ,aqpa460prv
                     ,aqpa460dst
                     ,aqpa460cpai
                      -- Para NC
                     ,aqpa460sdref
                     ,aqpa460ndref
                     ,aqpa460sust
                     ,aqpa460cmem
                     ,aqpa460serie
                     ,aqpa460nro
                     ,aqpa460tcomp
                     ,aqpa460fdref
      --
        FROM aqpa460 f_bt
            ,aqpa465 e
       WHERE 1 = 1
         AND f_bt.aqpa460seri = e.aqpa465serie
         AND f_bt.aqpa460num = e.aqpa465corr
         AND e.aqpa465est IS NULL
            
            --
         AND f_bt.aqpa460seri = vg_serie
         AND f_bt.aqpa460num = vg_nro
            --
            /*(
            -- No haya sido cargado anteriormente
            not exists
            (
            select 1
              from jc.jc_ede_lo_ar_header_all h
             where h.SERIAL_COMP = f_bt.AQPA460SERI
               and h.NUMERO_COMP = f_bt.AQPA460NUM
            ) or
            exists
            (
            select 1
              from jc.jc_ede_lo_ar_header_all h
             where h.SERIAL_COMP = f_bt.AQPA460SERI
               and h.NUMERO_COMP = f_bt.AQPA460NUM
               and h.STATUS_OF = 'PEN_EMI'
               and h.error_tci = 'TRAMA'
            ) or
            exists
            (
            select 1
              from jc.jc_ede_lo_ar_header_all h
             where h.SERIAL_COMP = f_bt.AQPA460SERI
               and h.NUMERO_COMP = f_bt.AQPA460NUM
               and h.STATUS_OF = 'PEN_ACT_EST'
               and h.error_estado in ('2', '4')
            )
            )*/
         AND ((gn_trx_id IS NOT NULL AND f_bt.aqpa460seri = gv_serial_comp AND f_bt.aqpa460num = gn_numero_comp) OR
             gn_trx_id IS NULL)
      UNION ALL
      SELECT DISTINCT aqpa460seri serial_comp
                     ,aqpa460num numero_comp
                     ,aqpa460femi fecha_emi_comp
                     ,aqpa460hemi AS hora_emi_comp
                     ,aqpa460tcomf tipo_comp
                     ,aqpa460mglo glosa_comp
                     ,aqpa460mone moneda_comp
                     ,aqpa460tope tipooper_comp
                     ,'Nota de Crédito' AS tipooper_des_comp
                     ,aqpa460impt AS importe_total_comp
                     ,aqpa460mtimp importe_total_igv_comp
                     ,aqpa460pcima porcentaje_igv_comp
                     ,aqpa460mtimp importe_igv_comp
                     ,aqpa460nruc customer_number
                     ,aqpa460rasoc customer_name
                     ,aqpa460tdocr customer_type
                     ,TRIM(aqpa460corrr) customer_mail
                     ,aqpa460rsoc organization_name
                     ,aqpa460rucc organization_ruc
                     ,'PEN_EMI' status_of
                     ,'Pendiente de Enviar a TCI' status_of_desc
                     ,aqpa460cdis AS cod_ubigeo
                     ,aqpa460cpais AS cod_pais_emisor
                      --
                     ,aqpa460cdley
                     ,aqpa460teley
                     ,aqpa460text1
                     ,aqpa460text2
                     ,aqpa460trecv
                     ,aqpa460templ
                     ,aqpa460subje
                     ,aqpa460mtotal
                     ,aqpa460baimp
                     ,aqpa460mtimp
                     ,aqpa460pcima
                     ,aqpa460bsimp
                     ,aqpa460vaimp
                     ,aqpa460mtinf
                     ,aqpa460mtgrt
                     ,aqpa460bsimps
                     ,aqpa460mtoti
                     ,aqpa460tdoc
                     ,aqpa460rucc
                     ,aqpa460rsoc
                     ,aqpa460cdis
                     ,aqpa460ncom
                     ,aqpa460calle
                     ,aqpa460urba
                     ,aqpa460depa
                     ,aqpa460prov
                     ,aqpa460dist
                     ,aqpa460telf
                     ,aqpa460web
                     ,aqpa460cpais
                     ,aqpa460cesun
                     ,aqpa460seri
                     ,aqpa460num
                     ,aqpa460femi
                     ,aqpa460tcomf
                     ,aqpa460mone
                     ,aqpa460corrr
                     ,aqpa460mglo
                     ,aqpa460coma
                     ,aqpa460tpla
                     ,aqpa460tope
                     ,aqpa460tplco
                     ,aqpa460clog
                     ,aqpa460tdocr
                     ,aqpa460nruc
                     ,aqpa460rasoc
                     ,aqpa460impt
                     ,aqpa460hemi
                     ,aqpa460simc
                     ,aqpa460svitm
                     ,aqpa460spvi
                     ,aqpa460txml
                     ,aqpa460cdist
                     ,aqpa460call
                     ,aqpa460urb
                     ,aqpa460dep
                     ,aqpa460prv
                     ,aqpa460dst
                     ,aqpa460cpai
                      -- Para NC
                     ,aqpa460sdref
                     ,aqpa460ndref
                     ,aqpa460sust
                     ,aqpa460cmem
                     ,aqpa460serie
                     ,aqpa460nro
                     ,aqpa460tcomp
                     ,aqpa460fdref
      --            
        FROM aqpa460 f_bt
            ,aqpa466 e
       WHERE 1 = 1
         AND f_bt.aqpa460seri = e.aqpa466serie
         AND f_bt.aqpa460num = e.aqpa466corr
         AND e.aqpa466est IS NULL
            
            --
         AND f_bt.aqpa460seri = vg_serie
         AND f_bt.aqpa460num = vg_nro
            --       
            /*(
            -- No haya sido cargado anteriormente
            not exists
            (
            select 1
              from jc.jc_ede_lo_ar_header_all h
             where h.SERIAL_COMP = f_bt.AQPA460SERI
               and h.NUMERO_COMP = f_bt.AQPA460NUM
            ) or
            exists
            (
            select 1
              from jc.jc_ede_lo_ar_header_all h
             where h.SERIAL_COMP = f_bt.AQPA460SERI
               and h.NUMERO_COMP = f_bt.AQPA460NUM
               and h.STATUS_OF = 'PEN_EMI'
               and h.error_tci = 'TRAMA'
            ) or
            exists
            (
            select 1
              from jc.jc_ede_lo_ar_header_all h
             where h.SERIAL_COMP = f_bt.AQPA460SERI
               and h.NUMERO_COMP = f_bt.AQPA460NUM
               and h.STATUS_OF = 'PEN_ACT_EST'
               and h.error_estado in ('2', '4')
            )
            )*/
         AND ((gn_trx_id IS NOT NULL AND f_bt.aqpa460seri = gv_serial_comp AND f_bt.aqpa460num = gn_numero_comp) OR
             gn_trx_id IS NULL);
  
    CURSOR c_main_d IS
      SELECT aqpa460csuna AS codigo
            ,aqpa460item item
            ,aqpa460cantf cantidad
            ,aqpa460total total
            ,TRIM(aqpa460desc) descripcion
            ,aqpa460vvun valorventaunitario
            ,aqpa460vvuig valorventaunitarioincigv
            ,aqpa460pnetu unidadcomercial
            ,aqpa460ctpr codigotipoprecio
            ,aqpa460dete determinante
            ,aqpa460csuna AS codigoproductosunat
            ,aqpa460imptb AS impuestototal
            ,aqpa460ititm importetributo_di
            ,aqpa460afigv AS afectacionigv_di
            ,aqpa460codtb codigotributo_di
            ,aqpa460dstrb destributo_di
            ,aqpa460codun codigoun_di
            ,aqpa460mbim montobase_di
            ,aqpa460taimp tasaaplicada_di
             --
            ,aqpa460dete
            ,aqpa460ctpr
            ,aqpa460vvun
            ,aqpa460vvuig
            ,aqpa460desc
            ,aqpa460mfun
            ,aqpa460prvit
            ,aqpa460medem
            ,aqpa460csuna
            ,aqpa460cpgs1
            ,aqpa460ititm
            ,aqpa460imptb
            ,aqpa460impex
            ,aqpa460afigv
            ,aqpa460sisc
            ,aqpa460codtb
            ,aqpa460dstrb
            ,aqpa460codun
            ,aqpa460mbim
            ,aqpa460taimp
            ,aqpa460vpcva
            ,aqpa460nexp
            ,aqpa460cind
            ,aqpa460npart
            ,aqpa460ncont
            ,aqpa460fotrc
            ,aqpa460cdisn
            ,aqpa460direh
            ,aqpa460urbh
            ,aqpa460prvh
            ,aqpa460dsth
            ,aqpa460depth
            ,aqpa460item
            ,aqpa460pnetu
            ,aqpa460cantf
            ,aqpa460total
      --
        FROM aqpa460 f_bt
       WHERE 1 = 1
         AND f_bt.aqpa460seri = vv_serie
         AND f_bt.aqpa460num = vn_numero
      
      ;
    /*    union all
    select AQPA460CSUNA as codigo
          ,aqpa460item item
          ,AQPA460CANTF cantidad
          ,aqpa460total total
          ,TRIM(aqpa460desc) descripcion
          ,AQPA460VVUN valorventaunitario
          ,AQPA460VVUIG valorventaunitarioincigv            
          ,AQPA460PNETU as unidadcomercial
          ,AQPA460CTPR codigotipoprecio
          ,AQPA460DETE determinante
          ,AQPA460CSUNA as codigoproductosunat
          ,AQPA460IMPTB as impuestototal
          ,AQPA460ITITM importetributo_di
          ,AQPA460AFIGV as afectacionigv_di
          ,AQPA460CODTB codigotributo_di
          ,AQPA460DSTRB destributo_di
          ,AQPA460CODUN codigoun_di
          ,AQPA460MBIM montobase_di
          ,AQPA460TAIMP tasaaplicada_di
          --
          ,AQPA460DETE
          ,AQPA460CTPR
          ,AQPA460VVUN
          ,AQPA460VVUIG
          ,AQPA460DESC
          ,AQPA460MFUN
          ,AQPA460PRVIT
          ,AQPA460MEDEM
          ,AQPA460CSUNA
          ,AQPA460CPGS1
          ,AQPA460ITITM
          ,AQPA460IMPTB
          ,AQPA460IMPEX
          ,AQPA460AFIGV
          ,AQPA460SISC
          ,AQPA460CODTB
          ,AQPA460DSTRB
          ,AQPA460CODUN
          ,AQPA460MBIM
          ,AQPA460TAIMP
          ,AQPA460VPCVA
          ,AQPA460NEXP
          ,AQPA460CIND
          ,AQPA460NPART
          ,AQPA460NCONT
          ,AQPA460FOTRC
          ,AQPA460CDISN
          ,AQPA460DIREH
          ,AQPA460URBH
          ,AQPA460PRVH
          ,AQPA460DSTH
          ,AQPA460DEPTH
          ,AQPA460ITEM
          ,AQPA460PNETU
          ,AQPA460CANTF
          ,AQPA460TOTAL            
          --
      from 
            aqpa460 f_bt
     where 1 = 1
       and f_bt.AQPA460SERI = vv_serie
       and f_bt.AQPA460NUM  = vn_numero;     */
  
    vn_trx_id              NUMBER;
    vn_trx_id_ant          NUMBER;
    vn_correlativo_number  NUMBER;
    vc_certificate_number  VARCHAR2(30);
    vc_certificate_number2 VARCHAR2(30);
    vc_tipo_serie          VARCHAR2(250);
    vc_grupo_retencion     VARCHAR2(250);
    vn_cert_detail_id      NUMBER;
    vn_cert_line_number    NUMBER;
    vn_rete_tax            NUMBER;
  
  BEGIN
  
    --bv 26/12/2018
    pr_ar_log_bt('33');
    -- Para carga individual
    IF (gn_trx_id IS NOT NULL) THEN
      SELECT h.aqpa460seri
            ,h.aqpa460num
        INTO gv_serial_comp
            ,gn_numero_comp
        FROM aqpa471 h
       WHERE 1 = 1
         AND h.aqpa471trxid = gn_trx_id;
    END IF;
    --
  
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
  
    IF nvl(pn_request_id_xml, 0) = 0 THEN
      --
      --bv 26/12/2018
      pr_ar_log_bt('34');
      FOR x IN c_main_h LOOP
      
        -- Borramos el documento en caso existiera:
        BEGIN
          SELECT h.aqpa471trxid
            INTO vn_trx_id_ant
            FROM aqpa471 h
           WHERE h.aqpa460seri = x.aqpa460seri
             AND h.aqpa460num = x.aqpa460num;
        
          DELETE FROM aqpa471 l
           WHERE l.aqpa471trxid = vn_trx_id_ant;
          --dbms_output.put_line('Elimino de AQPA471: ' || sql%rowcount ||
          --                     ', trx_id: ' || gn_trx_id);
        
        EXCEPTION
          WHEN no_data_found THEN
            NULL;
        END;
        --
      
        SELECT SQ_CR_EDE_LO_AR_CERT_HEADER.nextval
          INTO vn_trx_id
          FROM dual;
      
        gn_trx_id_nuevo := vn_trx_id;
      
        --dbms_output.put_line('vn_certificate_id=' || vn_certificate_id);
      
        --dbms_output.put_line('Inserto en AQPA471, 1TRXID: ' || gn_trx_id);
      
        INSERT INTO aqpa471
          (aqpa471trxid
           -- ,serial_comp
           -- ,numero_comp
           -- ,fecha_emi_comp
           -- ,tipo_comp
           -- ,glosa_comp
           -- ,moneda_comp
           -- ,tipooper_comp
          ,aqpa471todco
           -- ,importe_total_comp
           -- ,importe_total_igv_comp
           -- ,importe_igv_comp
           -- ,porcentaje_igv_comp
           --  ,customer_number
           -- ,customer_name
           -- ,customer_type
           -- ,customer_mail
           -- ,organization_name
           -- ,organization_ruc
          ,aqpa471status
          ,aqpa471statusd
           --     ,org_id
           -- ,AQPA471IDREG
          ,aqpa471freg
           -- ,AQPA471IDACT
          ,aqpa471fact
           --AQPA471IDACTLO
           -- ,COD_UBIGEO
           -- ,COD_PAIS_EMISOR
           -- ,HORA_EMI_COMP
           --
          ,aqpa460cdley
          ,aqpa460teley
          ,aqpa460text1
          ,aqpa460text2
          ,aqpa460trecv
          ,aqpa460templ
          ,aqpa460subje
          ,aqpa460mtotal
          ,aqpa460baimp
          ,aqpa460mtimp
          ,aqpa460pcima
          ,aqpa460bsimp
          ,aqpa460vaimp
          ,aqpa460mtinf
          ,aqpa460mtgrt
          ,aqpa460bsimps
          ,aqpa460mtoti
          ,aqpa460tdoc
          ,aqpa460rucc
          ,aqpa460rsoc
          ,aqpa460cdis
          ,aqpa460ncom
          ,aqpa460calle
          ,aqpa460urba
          ,aqpa460depa
          ,aqpa460prov
          ,aqpa460dist
          ,aqpa460telf
          ,aqpa460web
          ,aqpa460cpais
          ,aqpa460cesun
          ,aqpa460seri
          ,aqpa460num
          ,aqpa460femi
          ,aqpa460tcomf
          ,aqpa460mone
          ,aqpa460corrr
          ,aqpa460mglo
          ,aqpa460coma
          ,aqpa460tpla
          ,aqpa460tope
          ,aqpa460tplco
          ,aqpa460clog
          ,aqpa460tdocr
          ,aqpa460nruc
          ,aqpa460rasoc
          ,aqpa460impt
          ,aqpa460hemi
          ,aqpa460simc
          ,aqpa460svitm
          ,aqpa460spvi
          ,aqpa460txml
          ,aqpa460cdist
          ,aqpa460call
          ,aqpa460urb
          ,aqpa460dep
          ,aqpa460prv
          ,aqpa460dst
          ,aqpa460cpai
          ,aqpa471fepro
          ,aqpa471scoap
          ,aqpa471ncoap
           --
          ,aqpa460sdref
          ,aqpa460ndref
          ,aqpa460sust
          ,aqpa460cmem
          ,aqpa460tcomp
          ,aqpa460fdref
           --
          ,aqpa460serie
          ,aqpa460nro
           -- ,AQPA471RIDCA
           --
           )
        VALUES
          (vn_trx_id
           -- ,x.serial_comp
           -- ,x.numero_comp
           -- ,x.fecha_emi_comp
           -- ,x.tipo_comp
           -- ,x.glosa_comp
           -- ,x.moneda_comp
           -- ,x.tipooper_comp
          ,x.tipooper_des_comp
           -- ,x.importe_total_comp
           -- ,x.importe_total_igv_comp
           -- ,x.importe_igv_comp
           -- ,x.porcentaje_igv_comp
           -- ,x.customer_number
           -- ,x.customer_name
           -- ,x.customer_type
           -- ,x.customer_mail
           -- ,x.organization_name
           -- ,x.organization_ruc
          ,x.status_of
          ,x.status_of_desc
           ---      ,pn_org_id
           --,apps.fnd_global.user_id
          ,SYSDATE
           --,apps.fnd_global.user_id
          ,SYSDATE
          ,
           --  1
           -- ,x.COD_UBIGEO
           -- ,x.COD_PAIS_EMISOR       
           -- ,x.HORA_EMI_COMP
           --
           
           x.aqpa460cdley
          ,x.aqpa460teley
          ,x.aqpa460text1
          ,x.aqpa460text2
          ,x.aqpa460trecv
          ,x.aqpa460templ
          ,x.aqpa460subje
          ,x.aqpa460mtotal
          ,x.aqpa460baimp
          ,x.aqpa460mtimp
          ,x.aqpa460pcima
          ,x.aqpa460bsimp
          ,x.aqpa460vaimp
          ,x.aqpa460mtinf
          ,x.aqpa460mtgrt
          ,x.aqpa460bsimps
          ,x.aqpa460mtoti
          ,x.aqpa460tdoc
          ,x.aqpa460rucc
          ,x.aqpa460rsoc
          ,x.aqpa460cdis
          ,x.aqpa460ncom
          ,x.aqpa460calle
          ,x.aqpa460urba
          ,x.aqpa460depa
          ,x.aqpa460prov
          ,x.aqpa460dist
          ,x.aqpa460telf
          ,x.aqpa460web
          ,x.aqpa460cpais
          ,x.aqpa460cesun
          ,x.aqpa460seri
          ,x.aqpa460num
          ,x.aqpa460femi
          ,x.aqpa460tcomf
          ,x.aqpa460mone
          ,x.aqpa460corrr
          ,x.aqpa460mglo
          ,x.aqpa460coma
          ,x.aqpa460tpla
          ,x.aqpa460tope
          ,x.aqpa460tplco
          ,x.aqpa460clog
          ,x.aqpa460tdocr
          ,x.aqpa460nruc
          ,x.aqpa460rasoc
          ,x.aqpa460impt
          ,x.aqpa460hemi
          ,x.aqpa460simc
          ,x.aqpa460svitm
          ,x.aqpa460spvi
          ,x.aqpa460txml
          ,x.aqpa460cdist
          ,x.aqpa460call
          ,x.aqpa460urb
          ,x.aqpa460dep
          ,x.aqpa460prv
          ,x.aqpa460dst
          ,x.aqpa460cpai
          ,SYSDATE
          ,x.aqpa460serie
          ,x.aqpa460nro
           --
           --
          ,x.aqpa460sdref
          ,x.aqpa460ndref
          ,x.aqpa460sust
          ,x.aqpa460cmem
          ,x.aqpa460tcomp
          ,x.aqpa460fdref
           --          
          ,x.aqpa460serie
          ,x.aqpa460nro
           --    
           -- ,x.AQPA471RIDCA      
           );
      
        --FACTURA / BOLETA
        IF (x.aqpa460tcomf IN ('01', '03')) THEN
          UPDATE aqpa465 h
             SET h.aqpa465est = 'P'
           WHERE h.aqpa465serie = x.aqpa460seri
             AND h.aqpa465corr = x.aqpa460num;
        ELSIF (x.aqpa460tcomf IN ('07', '08')) THEN
          -- NOTA DE CREDITO / DEBITO
          UPDATE aqpa466 h
             SET h.aqpa466est = 'P'
           WHERE h.aqpa466serie = x.aqpa460seri
             AND h.aqpa466corr = x.aqpa460num;
        END IF;
        --
        vn_cuenta_h := vn_cuenta_h + 1;
      
        vv_serie  := x.aqpa460seri;
        vn_numero := x.aqpa460num;
      
        FOR d IN c_main_d LOOP
          --
          SELECT SQ_CR_EDE_LO_AR_CERT_LINES.nextval
            INTO vn_cert_detail_id
            FROM dual;
          vn_cuenta_d := vn_cuenta_d + 1;
          -- 
        
        END LOOP;
      
        COMMIT;
      
      END LOOP;
      --bv 26/12/2018
      pr_ar_log_bt('35');
      COMMIT;
    
      -- CVEAS REVISAR
      /*
        apps.fnd_file.put_line(apps.fnd_file.log, 'Documentos Cargados: ' || vn_cuenta_h);
        apps.fnd_file.put_line(apps.fnd_file.log, 'Lineas Cargadas: ' || vn_cuenta_d);
      */
    END IF; --
  
    RETURN TRUE;
  
  END;

  -- *******************************************************************
  -- Nombre                    : FUNCION ELIMINAR DATA
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- ******************************************************************* 

  FUNCTION fn_ar_elimina_data RETURN BOOLEAN IS
  BEGIN
  
    --dbms_output.put_line('FN: FN_ELIMINA_DATA');
    --CVEAS CORREGIR
    --  dbms_output.put_line('pn_request_id=' || pn_request_id);
  
    /*   delete from jc.jc_cre_lo_ap_carga_auto_all
     where request_id = pn_request_id;
    commit;*/
    RETURN TRUE;
  END;

  -- *******************************************************************
  -- Nombre                    : FUNCION ENVIO TCI MASIVO
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- ******************************************************************* 

  FUNCTION fn_ar_envio_tci_masivo RETURN BOOLEAN IS
  
  BEGIN
  
    FOR r IN (SELECT h.aqpa471trxid
                FROM aqpa471 h
               WHERE aqpa471status = 'PEN_EMI'
                 AND (h.aqpa471ertci IS NULL OR h.aqpa471ertci = 'WS')) LOOP
      --             
      pr_ar_upd_status_ede(r.aqpa471trxid, '', 'PEN_TCI', '');
      --          
    END LOOP;
  
    RETURN TRUE;
  
  EXCEPTION
    WHEN OTHERS THEN
      --CVEAS REVISAR apps.fnd_file.put_line(apps.fnd_file.log, sqlerrm || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN FALSE;
  END;

  -- *******************************************************************
  -- Nombre                    : PROCESO 
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- ******************************************************************* 

  PROCEDURE pr_ar_refresh_ede(pn_trx_id aqpa471.aqpa471trxid%TYPE) IS
  
    vc_errbuf    VARCHAR2(3000);
    vc_retcode   VARCHAR2(3000);
    vb_resultado BOOLEAN;
    vc_resultado VARCHAR2(3000);
  
  BEGIN
    --bv 26/12/2018
    pr_ar_log_bt('36');
    vb_resultado := fn_ar_env_status_ws(pc_proceso   => 'FACTURACION'
                                       ,pn_trx_id    => pn_trx_id
                                       ,pc_resultado => vc_resultado);
    COMMIT;
  
    --bv 26/12/2018
    pr_ar_log_bt('37');
    /*exception
    when others then
    
      null;*/
  END;

  -- *******************************************************************
  -- Nombre                    : PROCESO 
  -- Sistema                   : BANTOTAL
  -- Modulo                    : AR
  -- Version                   : 1.0
  -- Fecha de Creacion         : 
  -- Autor de Creacion         : 
  -- Uso                       : 
  -- Estado                    : Activo
  -- Acceso                    : Publico
  -- Parametros de Entrada     :
  --
  --
  --
  -- ******************************************************************* 

  PROCEDURE pr_ar_upd_status_ede(pn_trx_id         aqpa471.aqpa471trxid%TYPE
                                ,pc_source         aqpa471.aqpa471source%TYPE
                                ,pc_status_of      aqpa471.aqpa471status%TYPE
                                ,pc_status_of_desc aqpa471.aqpa471statusd%TYPE) IS
  
    vc_errbuf  VARCHAR2(3000);
    vc_retcode VARCHAR2(3000);
    vn_count   NUMBER := 0;
  
  BEGIN
  
    IF pc_status_of = 'PEN_TCI' THEN
      -- Enviar a TCI  
    
      pr_ar_proceso_ws('FACTURACION', pc_status_of, pn_trx_id);
    
    ELSIF pc_status_of = 'PEN_EMI' THEN
      UPDATE aqpa471
         SET aqpa471status = nvl(pc_status_of, aqpa471status)
       WHERE 1 = 1
         AND aqpa471trxid = pn_trx_id;
    
      COMMIT;
    ELSIF pc_status_of = 'ANULA' THEN
      UPDATE aqpa471
         SET aqpa471status = nvl(pc_status_of, aqpa471status)
       WHERE 1 = 1
         AND aqpa471trxid = pn_trx_id;
      COMMIT;
    
    ELSIF pc_status_of = 'REVER' THEN
    
      pr_ar_proceso_ws('REVERSION', pc_status_of, pn_trx_id);
    
    ELSIF pc_status_of = 'PEN_VAL' THEN
      UPDATE aqpa471
         SET aqpa471status  = nvl(pc_status_of, aqpa471status)
            ,aqpa471statusd = NULL
       WHERE 1 = 1
         AND aqpa471trxid = pn_trx_id;
      COMMIT;
    
      DELETE FROM aqpa473
       WHERE aqpa473trxid = pn_trx_id;
      COMMIT;
    ELSE
      UPDATE aqpa471
         SET aqpa471status = nvl(pc_status_of, aqpa471status)
       WHERE 1 = 1
         AND aqpa471trxid = pn_trx_id;
      COMMIT;
    END IF;
  
  END;

  PROCEDURE pr_ar_main(pn_serie aqpa471.aqpa460seri%TYPE
                      ,pn_nro   aqpa471.aqpa460num%TYPE
                       --
                      ,pv_flag_error  OUT VARCHAR2
                      ,pv_error       OUT VARCHAR2
                      ,pv_codigo_hash OUT VARCHAR2
                       --
                       ) IS
  
    vc_errbuf  VARCHAR2(3000);
    vc_retcode VARCHAR2(3000);
  
    /*vl_SERIE aqpa471.AQPA460SERI%type;
    vl_NRO   aqpa471.AQPA460NUM%type;*/
    vl_trxid aqpa471.aqpa471trxid%TYPE;
  
    v_fn BOOLEAN;
  
    pc_proceso   VARCHAR2(20) := 'FACTURACION';
    pc_status_of VARCHAR2(20) := '';
    --
    vv_flag_error  CHAR(1);
    vv_error       VARCHAR2(3000);
    vv_codigo_hash VARCHAR2(250);
    --
  BEGIN
  
    vg_ejecucion := SQ_CR_EDE_LO_AR_LOG2.NEXTVAL;
  
    vg_serie := pn_serie;
    vg_nro   := pn_nro;
  
    --1
    --bv 26/12/2018
    pr_ar_log_bt('38');
    v_fn := fn_ar_inserta_data;
    pr_ar_log_bt('39');
    BEGIN
      SELECT aq.aqpa471trxid
        INTO vl_trxid
        FROM aqpa471 aq
       WHERE aq.aqpa460seri = vg_serie
         AND aq.aqpa460num = vg_nro;
    END;
  
    IF vl_trxid IS NOT NULL THEN
    
      --2 
      --bv 26/12/2018
      pr_ar_log_bt('40');
      pr_ar_proceso_ws('FACTURACION', pc_status_of, vl_trxid);
      --bv 26/12/2018
      pr_ar_log_bt('41');
      --
      SELECT decode(aq.aqpa471statusd, NULL, 'N', 'Y') AS flag_error
            ,aq.aqpa471statusd AS error
            ,decode(aq.aqpa471statusd, NULL, aqpa471coha, NULL) AS codigo_hash
        INTO pv_flag_error
            ,pv_error
            ,pv_codigo_hash
        FROM aqpa471 aq
       WHERE aq.aqpa460seri = vg_serie
         AND aq.aqpa460num = vg_nro;
      --bv 26/12/2018
      pr_ar_log_bt('42');
      pr_ar_actu_esta_tci(vl_trxid);
      --bv 26/12/2018
      pr_ar_log_bt('43');
    END IF;
    --bv 26/12/2018
    pr_ar_log_bt('44');
  END;

  PROCEDURE pr_ar_get_xml_pdf(pn_serie aqpa471.aqpa460seri%TYPE
                             ,pn_nro   aqpa471.aqpa460num%TYPE) IS
  
    vn_cuenta_x_avisar NUMBER;
    vn_cuenta          NUMBER;
    vv_resultado       VARCHAR2(1500);
    vb_retorno         BOOLEAN;
    vb_cons_esta       BOOLEAN;
    vv_retorno         VARCHAR2(1500);
  
    vn_cuenta_xrevisar NUMBER;
  BEGIN
  
    --
    /* vb_cons_esta := FN_AR_CONSULTARESTADOCOMP_WS('FACTURACION',
    null,
    vv_retorno);*/
  
    -- Cargamos los archivos xml y pdf para los documentos
  
    FOR r IN (SELECT h.aqpa471trxid
                FROM aqpa471 h
               WHERE h.aqpa460seri = pn_serie
                 AND h.aqpa460num = pn_nro) LOOP
      --
      pr_ar_actu_esta_tci(r.aqpa471trxid);
      --                 
    END LOOP;
  
    --
  
    SELECT COUNT(1)
      INTO vn_cuenta
      FROM aqpa471 h
     WHERE h.aqpa471status = 'ACEPTADO'
       AND (h.aqpa471noxml IS NULL OR h.aqpa471nopdf IS NULL)
       AND h.aqpa460seri = pn_serie -- 21/12/2018
       AND h.aqpa460num = pn_nro -- 21/12/2018 
    ;
  
    IF (vn_cuenta > 0) THEN
    
      FOR r IN (SELECT h.aqpa471trxid
                  FROM aqpa471 h
                 WHERE h.aqpa471status = 'ACEPTADO'
                   AND (h.aqpa471noxml IS NULL OR h.aqpa471nopdf IS NULL)
                   AND h.aqpa460seri = pn_serie
                   AND h.aqpa460num = pn_nro) LOOP
        --
        vb_retorno := fn_ar_obtener_xml_ws('FACTURACION', r.aqpa471trxid, vv_resultado);
      
        vb_retorno := fn_ar_obtener_pdf_ws('FACTURACION', r.aqpa471trxid, vv_resultado);
        --               
      END LOOP;
    END IF;
  
    COMMIT;
  
  END;

  PROCEDURE pr_ar_get_masivo_xml_pdf IS
  
    vn_cuenta_x_avisar NUMBER;
    vn_cuenta          NUMBER;
    vv_resultado       VARCHAR2(1500);
    vb_retorno         BOOLEAN;
    vb_cons_esta       BOOLEAN;
    vv_retorno         VARCHAR2(1500);
  
    vn_cuenta_xrevisar NUMBER;
  BEGIN
  
    --
    vb_cons_esta := fn_ar_consultarestadocomp_ws('FACTURACION', NULL, vv_retorno);
  
    -- Actualizamos estado a todo lo pendiente
    FOR r IN (SELECT h.aqpa471trxid
                FROM aqpa471 h
               WHERE aqpa471status = 'PEN_ACT_EST') LOOP
      pr_ar_actu_esta_tci(r.aqpa471trxid);
    END LOOP;
    --
  
    -- Cargamos los archivos xml y pdf para los documentos
    SELECT COUNT(1)
      INTO vn_cuenta
      FROM aqpa471 h
     WHERE /*h.AQPA471STATUS = 'ACEPTADO'
                                                           and */
     (h.aqpa471noxml IS NULL OR h.aqpa471nopdf IS NULL);
    IF (vn_cuenta > 0) THEN
      --sys.DBMS_LOCK.sleep(2*60);    CORREGIR
      FOR r IN (SELECT h.aqpa471trxid
                  FROM aqpa471 h
                 WHERE /*h.AQPA471STATUS = 'ACEPTADO'
                                                                                                                                                                                                                                   and*/
                 (h.aqpa471noxml IS NULL OR h.aqpa471nopdf IS NULL)
             AND aqpa471coha IS NOT NULL) LOOP
        --
        vb_retorno := fn_ar_obtener_xml_ws('FACTURACION', r.aqpa471trxid, vv_resultado);
      
        vb_retorno := fn_ar_obtener_pdf_ws('FACTURACION', r.aqpa471trxid, vv_resultado);
        --               
      END LOOP;
    END IF;
  
    COMMIT;
  
  END;

  PROCEDURE pr_ar_log_bt
  (
  vv_line VARCHAR2
  ) IS
  BEGIN
    INSERT INTO AQPA476
    (
    AQPA476serie, 
    AQPA476numero, 
    AQPA476fecha, 
    AQPA476id, 
    AQPA476line, 
    AQPA476ejecucion
    )
    VALUES
      (vg_serie
      ,vg_nro
      ,SYSDATE
      ,SQ_CR_EDE_LO_AR_LOG.nextval
      ,vv_line -- ultimo 44
      ,vg_ejecucion
      );
  END;

END pq_ar_facturacion_e;
/

