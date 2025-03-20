create or replace package PQ_CR_REDUCCION_TASA_CAMPANA is

  -- Author  : HSUAREZ
  -- Created : 7/12/2021 10:03:33
  -- Purpose : Paquete para el Panel de Autorizacion de Reprogramacion de Lineas en el Flujo
  -- Author  : HSUAREZ
  -- Modified : 04/01/2022 10:03:33
  -- Purpose : Se agrego Tasa, para la facilidad Amortización Anticipada.
  
 procedure SP_CARGAR_LISTA(ve_suc number,ve_fecha date);
 procedure SP_GRABAR_REG( VE_CORRELATIVO NUMBER,
                         VE_INSTANCIA NUMBER,
                         VE_FACILIDAD_DESC VARCHAR,
                         VE_FACILIDAD_COD NUMBER,
                         VE_PRC_DESC NUMBER,
                         VE_MONTO_DESC NUMBER,
                         VE_SALDOCAP NUMBER,
                         VE_TASA_RED NUMBER,
                         VE_TASA_ORI NUMBER,
                         VE_CARGO NUMBER,
                         VE_UBUSER VARCHAR,
                         VE_GESTION VARCHAR,
                         VE_FECHA DATE,
                         VO_CRPTA OUT NUMBER,
                         VO_RPTA OUT VARCHAR
                       );
  procedure SP_CARGAR_LISTA_CRD(ve_fecha in date,ve_ubuser in varchar,vo_msgs out varchar);
  
  PROCEDURE sp_gestionar_credito(ve_cod  in number,
                                 ve_est  in varchar,
                                 ve_cmt in varchar,
                                 ve_user in varchar,
                                 ve_msj  out varchar); 
  PROCEDURE SP_OBTENER_CARGO(
                              vi_cfacilidad in number,
                              vi_facilidad in varchar,
                              vi_situacion in varchar,
                              vi_pdescuento in number,
                              vo_cargo out number,
                              VO_DCARGO out varchar                            
                            );
  PROCEDURE SP_OBTENER_CARGO(
                              vi_cfacilidad in number,
                              vi_facilidad in varchar,
                              vi_situacion in varchar,
                              vi_grupo in number,
                              vi_pdescuento in number,
                              vo_cargo out number,
                              VO_DCARGO out varchar                            
                            );
PROCEDURE SP_RETIRAR_TASA (
                              pn_emp    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_ope    in number,
                              pn_sbo    in number,
                              pn_top    in number,
                              pn_fec    in DATE
    );
PROCEDURE SP_CARGAR_TASA_CUENTA (
                              pn_emp    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_ope    in number,
                              pn_sbo    in number,
                              pn_top    in number,
                              pn_tas    in number,
                              PN_FEC    in date,
                              PN_SALDO  in number,
                              PN_PZO    in number,
                              PN_USER   IN VARCHAR
                              
  );
PROCEDURE SP_CARGAR_CLV_LCRD(VE_CORRELATIVO in number,
                             VE_INSTANCIA in number,
                             VI_PGCOD     out number,
                             VI_AOMOD     out number,
                             VI_AOSUC     out number,
                             VI_AOMDA     out number,
                             VI_AOPAP     out number,
                             VI_AOCTA     out number,
                             VI_AOOPER    out number,
                             VI_AOSBOP    out number,
                             VI_AOTOPE    out number
                            ); 
PROCEDURE SP_VALIDAR_SALDOCAPITAL(
                                   VE_INSTANCIA  NUMBER,
                                   VO_SALDOCAP out NUMBER
                                 );      
PROCEDURE OBTENER_CLAVE_LINEA_UTILIZADA(
                                            pn_emp    in number,
                                            pn_mod    in number,
                                            pn_suc    in number,
                                            pn_mda    in number,
                                            pn_pap    in number,
                                            pn_cta    in number,
                                            pn_ope    in number,
                                            pn_sbo    in number,
                                            pn_top    in number,
                                            vo_emp    OUT number,
                                            vo_mod    out number,
                                            vo_suc    out number,
                                            vo_mda    out number,
                                            vo_pap    out number,
                                            vo_cta    out number,
                                            vo_ope    out number,
                                            vo_sbo    out number,
                                            vo_top    out number   
                                            );  
 PROCEDURE OBTENER_EL_SALDO_CAPITAL_TOT(vo_instancia number,vi_deutot out number);
 PROCEDURE OBTENER_DEUDAVIVA_TOT(vo_instancia number,vo_DeudaTotal out number);
 PROCEDURE SP_GRABAR_DEUDA_TOTAFEC(VE_INSTANCIA number,
                                  VE_CORRELATIVO number,
                                  VE_DeudaTotal number  
  ); 
 PROCEDURE SP_VALIDAR_CANCEL( pn_emp    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_ope    in number,
                             pn_sbo    in number,
                             pn_top    in number,
                             vs_rpta   out varchar
                           );                    

 PROCEDURE SP_CR_COMPRA_DEUDA(P_InInstancia IN NUMBER, 
                              P_OutCoprDeuda OUT VARCHAR2);

 PROCEDURE SP_CR_COMPRA_DEUDA2(P_InCuenta IN NUMBER, 
                              P_OutCoprDeuda OUT VARCHAR2);

 PROCEDURE SP_CR_ETAPA_SOLICITUD(P_InCuenta  IN NUMBER,
                                 P_OutSolicitud OUT VARCHAR2);

 PROCEDURE SP_CR_SI_GESTIONADO (P_InCuenta IN NUMBER, P_InModulo IN NUMBER, P_InTope IN NUMBER,   
                                P_OutGest OUT VARCHAR2);     

 PROCEDURE SP_CR_TASA_TARIFARIO (P_InInstancia  IN NUMBER, P_OutTasa OUT NUMBER);                              
   
end PQ_CR_REDUCCION_TASA_CAMPANA;
/

create or replace package body PQ_CR_REDUCCION_TASA_CAMPANA is

procedure SP_CARGAR_LISTA(ve_suc number,ve_fecha date) IS

   CURSOR LISTA_BI IS
       SELECT * FROM JAQZ697 X 
              where X.jaqz697suc = ve_suc 
                and X.jaqz697fep = (select max(jaqz697fep) from JAQZ697)
                and (X.jaqz697mod,X.jaqz697top) in(
                  SELECT tp1nro1,tp1nro2 FROM fst198 
                     WHERE tp1cod = 1 AND tp1cod1 = 11161 AND tp1corr1 = 31 
                       AND tp1corr2 = 0 AND tp1corr3 > 0
                );
       
       VI_INSTANCIA number(10);
       V_PRC VARCHAR(3);
       vo_rpta VARCHAR(1);
       vo_DeudaTotal NUMBER(17,2);
       vI_DeudaTotal NUMBER(17,2);
       VI_CORRELATIVO number(9);
       VI_TASAORI NUMBER(10,6);
       VI_TASA_ORI NUMBER(10,6);
       VS_TASA_ORI NUMBER(10,6);
       vi_SaldoCapital number(17,2);
       VI_DEUDA_AFEC NUMBER(17,2);
       VI_FEC_GESTION DATE;
       VE_EGESTION VARCHAR(3);
       vo_cancel VARCHAR(1);
       ve_penom VARCHAR(50);
       --
       VI_FECHAC_AQPC551 DATE;
       V_FECCARGA DATE;
       VI_GUIA_FECHA_CARGA DATE;
       VI_GUIA_FECHA_VIGENCIA DATE;
       
       vi_jaqz697cod xwf700.xwfempresa%type;
       vi_jaqz697mod xwf700.xwfmodulo%type;
       vi_jaqz697suc xwf700.xwfsucursal%type;
       vi_jaqz697mda xwf700.xwfmoneda%type;
       vi_jaqz697pap xwf700.xwfpapel%type;
       vi_jaqz697cta xwf700.xwfcuenta%type;
       vi_jaqz697oper xwf700.xwfoperacion%type;
       vi_jaqz697sbop xwf700.xwfsubope%type;
       vi_jaqz697tope xwf700.xwftipope%type;
    BEGIN               
       -- GUIA PARA LA FECHA FE CARGAR Y LIMITE DE VIGENCIA
       BEGIN
         SELECT TO_DATE(TP1NRO1,'YYYYMMDD')
         INTO VI_GUIA_FECHA_CARGA
         FROM FST198
          WHERE TP1COD  = 1  
            AND TP1COD1 = 11161
            AND TP1CORR1= 5
            AND TP1CORR2= 1
            AND TP1CORR3= 5;
       END;
       -- GUIA PARA LIMITE DE VIGENCIA
       BEGIN
         SELECT TO_DATE(TP1NRO1,'YYYYMMDD')
         INTO VI_GUIA_FECHA_VIGENCIA
         FROM FST198
          WHERE TP1COD  = 1  
            AND TP1COD1 = 11161
            AND TP1CORR1= 5
            AND TP1CORR2= 1
            AND TP1CORR3= 3;
       END;
       --VALIDAR LA FECHA DE ULTIMA CARGA.
       BEGIN
           SELECT MAX(JAQZ697FEP)
           INTO V_FECCARGA FROM JAQZ697 WHERE JAQZ697FEP=VI_GUIA_FECHA_CARGA;
       EXCEPTION
         WHEN OTHERS THEN
           V_FECCARGA := TO_DATE('01/01/2001');
       END;
       --
       --CARGAR LOS REGISTROS EN NUESTRA TABLA
       IF (VI_GUIA_FECHA_CARGA = V_FECCARGA)  AND (V_FECCARGA < VI_GUIA_FECHA_VIGENCIA) and (ve_fecha <= VI_GUIA_FECHA_VIGENCIA)  THEN
           
         BEGIN
              for j in lista_bi loop
                  VI_INSTANCIA := 0;
                  V_PRC := 'UPD';
                  vi_jaqz697cod:= 0;
                  vi_jaqz697mod:= 0;
                  vi_jaqz697suc:= 0;
                  vi_jaqz697mda:= 0;
                  vi_jaqz697pap:= 0;
                  vi_jaqz697cta:= 0;
                  vi_jaqz697oper:= 0;
                  vi_jaqz697sbop:= 0;
                  vi_jaqz697tope:= 0;
                  
                  VI_TASA_ORI:=99;
                  VI_CORRELATIVO:= 0;
                  VI_TASAORI:= 0;
                  vo_DeudaTotal:= 0;                                  
                  BEGIN
                    SELECT A.AQPC551INS,A.AQPC551CORR,A.AQPC551TORI,A.AQPC551DEUTF,A.AQPC551FECM,A.AQPC551ESTA
                           INTO VI_INSTANCIA,VI_CORRELATIVO,VI_TASAORI,VI_DEUDA_AFEC,VI_FEC_GESTION,VE_EGESTION
                    FROM AQPC551 A
                         WHERE A.AQPC551FECC = J.JAQZ697FEP 
                           AND A.AQPC551CTA  = J.JAQZ697CTA
                           AND A.AQPC551MOD  = J.JAQZ697MOD
                           AND A.AQPC551TOPE = J.JAQZ697TOP
                           AND A.AQPC551EHAB = 'H'
                    AND ROWNUM = 1;
                  EXCEPTION 
                    WHEN OTHERS THEN
                      V_PRC := 'INS';
                      VI_CORRELATIVO :=  0;
                  END;
                  if J.JAQZ697CTA = 311859 then
                     null;
                  end if;
                  IF VI_CORRELATIVO = 0 AND V_PRC = 'INS' THEN
                     vi_deudaTotal := 0;
                     
                     --OBTENER DEUDA TOTAL DEL CREDITO.
                     BEGIN
                       SELECT penom INTO ve_penom FROM fsd001 
                               WHERE pepais = j.jaqz697pai and petdoc = j.jaqz697tdo and pendoc = j.jaqz697ndo; 
                     EXCEPTION WHEN OTHERS THEN                     
                        ve_penom := '';
                     END;
                     BEGIN
                     INSERT INTO AQPC551 (
                                   aqpc551cor2 ,aqpc551cod ,
                                   aqpc551mod  ,aqpc551suc ,aqpc551mda ,
                                   aqpc551pap  ,aqpc551cta ,aqpc551oper,aqpc551tope,
                                   aqpc551pais ,aqpc551tdoc ,aqpc551docu,aqpc551nomb,
                                   aqpc551esta ,aqpc551ehab ,aqpc551mcap,aqpc551fecr,--aqpb904usur,aqpb904hora
                                   aqpc551situ, aqpc551tori,
                                   aqpc551grup,aqpc551fecm ,aqpc551imp,AQPC551FECC
                                  )
                           VALUES (
                                    J.JAQZ697COR, 1,
                                    j.jaqz697mod,j.jaqz697suc,j.jaqz697mda,
                                    0,j.jaqz697cta,j.jaqz697top,j.jaqz697top,
                                    j.jaqz697pai,j.jaqz697tdo,j.jaqz697ndo,ve_penom,
                                    'P','H',0,j.jaqz697fep,j.jaqz697base,0,0,SYSDATE,j.jaqz697mto,j.jaqz697fep
                                  );   
                                
                      COMMIT;   
                      EXCEPTION WHEN OTHERS THEN
                        V_PRC := 'UPD';
                      END;   
                  END IF;
                  
                  IF VI_CORRELATIVO > 0 AND V_PRC = 'UPD' THEN
                                         
                   --ACTUALIZAMOS LA AQPB904 LA GESTION    
                   UPDATE AQPC551 T
                   SET --T.aqpc551mod  =j.jaqz697mod,
                       --T.aqpc551tope =j.jaqz697top,
                       T.AQPC551IMP  =j.jaqz697mto,
                       t.aqpc551ASE  =j.jaqz697ase,
                       t.aqpc551pzo  =j.jaqz697pzo,
                       t.aqpc551cuo  =j.jaqz697cuo 
                       /*T.AQPB904DEUT = vi_deudaTotal,
                       T.AQPB904SCAPT = vi_SaldoCapital,
                       t.AQPB904TORI = VS_TASA_ORI,
                       t.aqpb904grup = j.aqpb904agrup*/
                   WHERE T.aqpc551corr = VI_CORRELATIVO
                     AND T.aqpc551feCC = J.JAQZ697FEP
                     AND T.AQPC551CTA  = J.JAQZ697CTA
                     AND T.AQPC551MOD  = J.JAQZ697MOD
                     AND T.AQPC551TOPE = J.JAQZ697TOP
                     AND T.AQPC551ESTA = 'P'
                     AND T.AQPC551EHAB = 'H';
                     COMMIT;
                   
                  END IF;
                  --VALIDAR REGISTROS YA GESTIONADOS --PARA VOLVER A HABILITAR, SOLO EN CASO NO HAYAN SIDO CANCELADOS.
                  BEGIN
                        --VI_DEUDA_AFEC;
                        --VI_FEC_GESTION;
                        vo_cancel := 'S';
                        
                        IF (VE_EGESTION = 'G' OR VE_EGESTION = 'D') AND to_date(VI_FEC_GESTION,'dd/mm/yyyy') < to_date(ve_fecha,'dd/mm/yyyy') THEN --SI NO FUE CANCELADO Y YA SE REALIZO LA GESTION DEL CREDITO INHABILITAR EL REGISTRO GESTIONADO Y HABILITAR UNO NUEVO.                      
                         
                        --INHABILITAMOS EL REGISTRO GESTIONADO
                          UPDATE AQPC551 T
                             SET T.AQPC551EHAB = 'I'
                           WHERE T.AQPC551CORR = VI_CORRELATIVO
                             AND T.AQPC551FECC  = J.JAQZ697FEP
                             AND T.AQPC551ESTA IN ('G','D')
                             AND T.AQPC551EHAB = 'H';
                            
                          --EN CASO DE AUTORIZACION EXTERNA ACTUALIZAMOS TAMBIEN LA AQPB953  
                           UPDATE AQPC552 B9
                           SET B9.AQPC552EHAB = 'I'
                           WHERE B9.AQPC552COD = VI_CORRELATIVO
                             AND B9.AQPC552EHAB = 'H';
                             COMMIT;    
                          --INSERTAMOS NUEVO REGISTRO
                          BEGIN
                           INSERT INTO AQPC551 (
                                         aqpc551cor2 ,aqpc551cod ,
                                         aqpc551mod  ,aqpc551suc ,aqpc551mda ,
                                         aqpc551pap  ,aqpc551cta ,aqpc551oper,
                                         aqpc551pais ,aqpc551tdoc ,aqpc551docu,aqpc551nomb,
                                         aqpc551esta ,aqpc551ehab ,aqpc551mcap,aqpc551fecC,--aqpb904usur,aqpb904hora
                                         aqpc551situ, aqpc551tori,
                                         aqpc551grup,aqpc551fecm 
                                        )
                                 VALUES (
                                          J.JAQZ697COR, 1,
                                          j.jaqz697mod,j.jaqz697suc,j.jaqz697mda,
                                          0,j.jaqz697cta,j.jaqz697top,
                                          j.jaqz697pai,j.jaqz697tdo,j.jaqz697ndo,ve_penom,
                                          'P','H',0,j.jaqz697fep,j.jaqz697base,0,0,SYSDATE
                                        );            
                            COMMIT;     
                          EXCEPTION WHEN OTHERS THEN
                            NULL;  
                          END;  
                       END IF;  
                  END;                 
                end loop; 
           END;
       
       ELSE
           BEGIN
             SELECT MAX(AQPC551FECC) INTO VI_FECHAC_AQPC551 FROM AQPC551 WHERE AQPC551EHAB='H';
           EXCEPTION 
             WHEN OTHERS THEN
                 VI_FECHAC_AQPC551 := TO_DATE('01/01/2001');
           END;
         IF VI_FECHAC_AQPC551 <  VI_GUIA_FECHA_CARGA OR (VI_FECHAC_AQPC551 > VI_GUIA_FECHA_VIGENCIA ) THEN
           BEGIN
             UPDATE AQPC551 SET AQPC551EHAB='I'; 
           END;
         END IF;  
       END IF;
    END;


procedure SP_GRABAR_REG( VE_CORRELATIVO NUMBER,
                         VE_INSTANCIA NUMBER,
                         VE_FACILIDAD_DESC VARCHAR,
                         VE_FACILIDAD_COD NUMBER,
                         VE_PRC_DESC NUMBER,
                         VE_MONTO_DESC NUMBER,
                         VE_SALDOCAP NUMBER,
                         VE_TASA_RED NUMBER,
                         VE_TASA_ORI NUMBER,
                         VE_CARGO NUMBER,
                         VE_UBUSER VARCHAR,
                         VE_GESTION VARCHAR,
                         VE_FECHA DATE,
                         VO_CRPTA OUT NUMBER,
                         VO_RPTA OUT VARCHAR
                       ) IS
  VI_PGCOD FSD010.PGCOD%TYPE;
  VI_AOMOD FSD010.AOMOD%TYPE;
  VI_AOSUC FSD010.AOSUC%TYPE;
  VI_AOMDA FSD010.AOMDA%TYPE;
  VI_AOPAP FSD010.AOPAP%TYPE;
  VI_AOCTA FSD010.AOCTA%TYPE;
  VI_AOOPER FSD010.AOOPER%TYPE;
  VI_AOSBOP FSD010.AOSBOP%TYPE;
  VI_AOTOPE FSD010.AOTOPE%TYPE;  
  VI_FECHA_SISTEMA DATE; 
  SALDO_CAPITAL_T  NUMBER(17,2);
  TASA_ORI NUMBER (10,6);
  BEGIN
       VI_FECHA_SISTEMA := VE_FECHA;
       --OBTENER CLAVE DE LA LINEA DE CREDITO Y DATOS                                         
       PQ_CR_REDUCCION_TASA_CAMPANA.SP_CARGAR_CLV_LCRD(VE_CORRELATIVO,VE_INSTANCIA,
                                                VI_PGCOD,
                                                VI_AOMOD,
                                                VI_AOSUC,
                                                VI_AOPAP,
                                                VI_AOMDA,
                                                VI_AOCTA,
                                                VI_AOOPER,
                                                VI_AOSBOP,
                                                VI_AOTOPE);
        
        BEGIN            
            BEGIN
                UPDATE AQPC551 A SET
                  A.AQPC551FACI = VE_FACILIDAD_DESC,
                  A.AQPC551ESTA = VE_GESTION,
                  A.AQPC551EHAB = 'H',
                  A.AQPC551PRAP = VE_PRC_DESC,
                  --A.AQPB904MNTD = VE_MONTO_DESC,
                  A.AQPC551CFACI= VE_FACILIDAD_COD,
                  A.AQPC551TRED = VE_TASA_RED, 
                  A.AQPC551TORI = VE_TASA_ORI,
                  A.AQPC551USUR = VE_UBUSER,
                  A.AQPC551CARG = VE_CARGO,
                  A.AQPC551FECR = TO_DATE(SYSDATE,'DD/MM/YYYY'),
                  A.AQPC551HORA = TO_CHAR(SYSDATE,'HH:MI:ss'),            
                  A.AQPC551FECM = TO_DATE(VE_FECHA,'dd/MM/yyyy') --NUEVO
                  WHERE A.AQPC551CORR = VE_CORRELATIVO
                  --AND A.AQPC551INS = VE_INSTANCIA
                  AND A.AQPC551ESTA = 'P'
                  AND A.AQPC551EHAB = 'H';
                COMMIT; 
                IF TRIM(VE_GESTION) = 'G' THEN
                   PQ_CR_REDUCCION_TASA_CAMPANA.SP_CARGAR_TASA_CUENTA(
                                                                      VI_PGCOD ,
                                                                      VI_AOMOD ,
                                                                      VI_AOSUC ,
                                                                      VI_AOMDA ,
                                                                      VI_AOPAP ,
                                                                      VI_AOCTA ,
                                                                      VI_AOOPER ,
                                                                      VI_AOSBOP ,
                                                                      VI_AOTOPE ,
                                                                      VE_TASA_RED ,
                                                                      VI_FECHA_SISTEMA,
                                                                      --TO_DATE(SYSDATE,'DD/MM/YYYY'),
                                                                      VE_SALDOCAP,--SALDO_CAPITAL_T,--PN_SALDO ,
                                                                      9999,
                                                                      VE_UBUSER
                                                                      );--PN_PZO);
                                                                                                                                              
                 
                 END IF;                                          
                 IF TRIM(VE_GESTION) = 'R' THEN
                    UPDATE AQPC551 A SET
                          AQPC551EHAB   = 'R',
                          AQPC551FECD   = SYSDATE
                    WHERE A.AQPC551CORR = VE_CORRELATIVO
                      --AND A.AQPC551INS = VE_INSTANCIA
                      AND A.AQPC551ESTA = 'G'
                      AND A.AQPC551EHAB = 'H'; 
                      
                           
                 END IF;
            EXCEPTION
            WHEN OTHERS THEN
                NULL;      
            END;  
            COMMIT;  
        EXCEPTION
            WHEN OTHERS THEN
            NULL;  
        END;
        COMMIT;
  END;
 
procedure SP_CARGAR_LISTA_CRD(ve_fecha in date,ve_ubuser in varchar,vo_msgs out varchar) is
  
cursor lista_crm is
SELECT L.AQPB904DOCU DNICLIENTE,                   
       l.aqpb904cod  EMPRESA,
       l.aqpb904mod  MODULO,
       l.aqpb904mda  MONEDA,
       l.aqpb904pap  PAPEL,
       l.aqpb904cta  CUENTA, --CUENTA
       l.aqpb904oper OPERACION,      --OPERACION
       l.aqpb904suc  SUCURSAL,
       l.aqpb904sbop SUBOPERACION,
       l.aqpb904tope TIPOOPERACION,       
       --CASE WHEN l.aqpb904mntd >0 THEN l.aqpb904mntd ELSE L.AQPB904DEUT END MONTOCAPITALIZACION,
       L.AQPB904MNTD MONTOCAPITALIZACION,
       l.aqpb904deut DESCUENTOSOLICITADO,
       l.aqpb904scapt SALDOCAPITALTOTAL,
       l.AQPB904TRED NUEVATASA,
       l.aqpb904prap PORCENTAJEREDUCCION,
       l.aqpb904fecr FECHAENBANTOTAL,
       -- F.MENSAJEAUTONOMIA,
       l.aqpb904faci FACILIDAD,
       L.AQPB904CFACI CFACILIDAD,
       L.AQPB904CARG CODCARGO,
       L.AQPB904ESTA ESTADO
  FROM AQPB904 L
 WHERE L.AQPB904ESTA IN ('D','G')
   AND L.AQPB904EHAB = 'H'
   AND TRUNC(L.AQPB904FECR) < (ve_fecha + 1);
  
 vi_pepais fsr008.pepais%type;
 vi_petdoc  fsr008.petdoc%type;
 vi_pendoc fsr008.pendoc%type;
 vi_instancia xwf700.xwfprcins%type;
 vi_flag char(1);
 vi_cargo number(10);
 vi_estado char(1);
 vo_msgsS VARCHAR(255);
 vo_DeudaTotal number(17,2);
 vo_rpta varchar(1);
 VI_REG_COD NUMBER(4);
 vo_aprobador_sup varchar(10);
 vo_aprobador     varchar(10);
 VI_TASA_ACTUAL NUMBER(10,6);            
  begin
        FOR x in lista_crm LOOP
            
            --CARGANDO LOS DATOS CLIENTE
            vi_pepais := 0;
            vi_petdoc := 0;
            vi_pendoc := '';
            vi_cargo := 0;
            vo_aprobador := 0;
            vo_aprobador_sup := 0;
            vi_tasa_actual:= 0;
            BEGIN              
              SELECT f.pepais,f.petdoc,f.pendoc
              INTO vi_pepais,vi_petdoc,vi_pendoc
              FROM fsr008 f where f.pgcod=1 and f.ctnro=x.CUENTA and F.CTTFIR='T' and F.TTCOD=1;
            EXCEPTION 
              WHEN OTHERS THEN
                NULL;   
              END;
            --CAGANRDO LA INSTANCIA Y SALDO CAPITAL.
            vi_instancia := 0;
            
            IF X.CUENTA = 528574 THEN
              NULL;
            END IF;
            
            BEGIN                       
                SELECT s.XWFPRCINS
                INTO   vi_instancia
                FROM XWF700 s
                WHERE s.XWFEMPRESA =  x.EMPRESA
                  AND s.XWFMODULO  =  x.MODULO
                  AND S.XWFMONEDA  =  x.MONEDA
                  AND S.XWFPAPEL   =  x.PAPEL
                  AND S.XWFCUENTA  =  x.CUENTA 
                  AND S.XWFOPERACION = x.OPERACION
                  AND S.XWFSUCURSAL = x.SUCURSAL
                  AND S.XWFSUBOPE   = x.SUBOPERACION
                  AND S.XWFTIPOPE   = x.TIPOOPERACION
                  AND S.XWFCAR3     IN ('1','A')
                  AND S.XWFPRCINS   = (SELECT MAX(D.XWFPRCINS) FROM XWF700 D
                                       WHERE D.XWFEMPRESA =  x.EMPRESA
                                         AND D.XWFMODULO  =  x.MODULO
                                         AND D.XWFMONEDA  =  x.MONEDA
                                         AND D.XWFPAPEL   =  x.PAPEL
                                         AND D.XWFCUENTA  =  x.CUENTA
                                         AND D.XWFOPERACION = x.OPERACION
                                         AND D.XWFSUCURSAL = x.SUCURSAL
                                         AND D.XWFSUBOPE   = x.SUBOPERACION
                                         AND D.XWFTIPOPE   = x.TIPOOPERACION
                                         AND D.XWFCAR3     IN ('1' ,'A')      
                                      )
                  AND ROWNUM = 1;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
              END;
           --Equivalencia de cargos de CRM a Bantotal.
           vi_estado := 'P';
           IF x.ESTADO = 'G' and x.CODCARGO = 202 then
              vi_estado := 'A';
              
           END IF;
           
           VI_CARGO := x.CODCARGO;            
           --VALIDAMOS SI EL REGISTRO EXISTE EN CAOS YA EXISTIERA NO SE INSERTA
           vi_flag := 'N';
           
           BEGIN
              SELECT 'S'
              INTO  vi_flag FROM AQPB953 A 
              WHERE A.AQPB953EMP = x.EMPRESA
                AND A.AQPB953MOD = x.MODULO
                AND A.AQPB953MDA = x.MONEDA
                AND A.AQPB953PAP = x.PAPEL
                AND A.AQPB953CTA = x.CUENTA
                AND A.AQPB953OPER= x.OPERACION
                AND A.AQPB953SUC = x.SUCURSAL
                AND A.AQPB953SBOP= x.SUBOPERACION
                AND A.AQPB953TOP = x.TIPOOPERACION
                AND A.AQPB953FCRM= x.FECHAENBANTOTAL;
           EXCEPTION WHEN OTHERS THEN
                     vi_flag:= 'N';     
           END;
           
           --OBTENER USUARIO APROBADOR
           vo_aprobador:= '';
           pq_cr_reprog_sin_cap.SP_CRD_OBTENER_APROBADOR(vi_cargo,x.SUCURSAL,vo_aprobador,vo_aprobador_sup);
           BEGIN
              select REGCOD
              INTO VI_REG_COD 
              from fst811
              where oficod=x.SUCURSAL and regcod<100;
              
              select S.SNG057USR 
              into vo_aprobador
              from fst811 f,sng057 s, fst046 t 
              where s.sng057usr=t.ubuser and s.sng055car=vi_cargo and t.ubsuc=f.oficod and regcod = VI_REG_COD AND ROWNUM=1;
              
           EXCEPTION WHEN OTHERS THEN
             NULL;   
              --regcod                    
           END;
                                                                                          
           --INVERTAMOS REGISTRO
           IF vi_flag = 'N' then 
              BEGIN 
                BEGIN
                  pq_cr_reprog_caja.sp_cr_tasa(
                                                x.EMPRESA,
                                                x.MODULO,
                                                x.SUCURSAL,
                                                x.MONEDA,
                                                x.PAPEL,
                                                x.CUENTA,
                                                x.OPERACION,                                                
                                                x.SUBOPERACION,
                                                x.TIPOOPERACION,
                                                VI_TASA_ACTUAL
                                              );
                EXCEPTION
                  WHEN OTHERS THEN
                    VI_TASA_ACTUAL:=0;
                END;  
              
                BEGIN
                INSERT INTO
                AQPB953 A ( A.AQPB953PAIS,A.AQPB953PTDC,A.AQPB953DNI,
                            A.AQPB953EMP,A.AQPB953MOD,A.AQPB953MDA,A.AQPB953PAP,A.AQPB953CTA,A.AQPB953OPER,A.AQPB953SUC,A.AQPB953SBOP,A.AQPB953TOP,
                            A.AQPB953INST,A.AQPB953CAPT,A.AQPB953REDU,A.AQPB953TREDU,A.AQPB953PREDU,A.AQPB953EHAB,A.AQPB953FECR,A.AQPB953FCRM,A.AQPB953USRR,A.AQPB953PCARG,A.AQPB953EST,A.AQPB953FAC,A.AQPB953USRPA,A.AQPB953TASAACT, A.AQPB953CFAC,A.AQPB953DTOT,a.aqpb953scapt) VALUES (
                            vi_pepais,vi_petdoc,vi_pendoc,
                            x.EMPRESA,x.MODULO,x.MONEDA,x.PAPEL,x.CUENTA,x.OPERACION,x.SUCURSAL,x.SUBOPERACION,x.TIPOOPERACION,
                            vi_instancia,x.MONTOCAPITALIZACION,x.NUEVATASA,x.NUEVATASA,x.PORCENTAJEREDUCCION,'H',SYSDATE,x.FECHAENBANTOTAL,ve_ubuser,vi_cargo,vi_estado,x.FACILIDAD,vo_aprobador,VI_TASA_ACTUAL,X.CFACILIDAD,X.DESCUENTOSOLICITADO,x.SALDOCAPITALTOTAL);
                commit;
                EXCEPTION
                  WHEN OTHERS THEN
                    vo_msgsS := SQLERRM;
                    DBMS_OUTPUT.put_line(vo_msgsS);
                END;
                begin
                     UPDATE
                           AQPB953 A  SET A.AQPB953EHAB = 'I'
                           WHERE A.AQPB953EMP  = x.EMPRESA
                             AND A.AQPB953MOD  = x.MODULO
                             AND A.AQPB953MDA  = x.MONEDA
                             AND A.AQPB953PAP  = x.PAPEL
                             AND A.AQPB953CTA  = x.CUENTA
                             AND A.AQPB953OPER = x.OPERACION
                             AND A.AQPB953SUC  = x.SUCURSAL
                             AND A.AQPB953SBOP = x.SUBOPERACION
                             AND A.AQPB953TOP  = x.TIPOOPERACION
                             AND A.AQPB953INST = vi_instancia
                             AND A.AQPB953FCRM < x.FECHAENBANTOTAL
                             AND A.AQPB953EHAB='H'
                             AND A.AQPB953EST IN ('A','P');
                   EXCEPTION 
                      WHEN OTHERS THEN
                           NULL;       
                  end;            
              EXCEPTION WHEN OTHERS THEN
                 vo_msgsS := SQLERRM;                            
              END;
           ELSE
             BEGIN
               
            UPDATE
                AQPB953 A  SET A.AQPB953CAPT = x.MONTOCAPITALIZACION,
                               A.AQPB953REDU = x.NUEVATASA,
                               A.AQPB953DTOT = x.DESCUENTOSOLICITADO,
                               a.aqpb953scapt= x.SALDOCAPITALTOTAL,
                               A.AQPB953USRPA = VO_APROBADOR,
                               A.AQPB953PCARG= vi_cargo
                           WHERE     
                               A.AQPB953EMP =x.EMPRESA
                             AND   A.AQPB953MOD =x.MODULO
                             AND   A.AQPB953MDA =x.MONEDA
                             AND   A.AQPB953PAP =x.PAPEL
                             AND   A.AQPB953CTA =x.CUENTA
                             AND   A.AQPB953OPER=x.OPERACION
                             AND   A.AQPB953SUC =x.SUCURSAL
                             AND   A.AQPB953SBOP=x.SUBOPERACION
                             AND   A.AQPB953TOP =x.TIPOOPERACION
                             AND   A.AQPB953INST=vi_instancia
                             AND   A.AQPB953FCRM=x.FECHAENBANTOTAL
                             AND   A.AQPB953EHAB='H'
                             AND   A.AQPB953EST ='P';
                             EXCEPTION 
                               WHEN OTHERS THEN
                                 NULL;
                             END;
                             
           END IF;           
        END LOOP;
        COMMIT;
    end;  

PROCEDURE sp_gestionar_credito(ve_cod  in number,
                                 ve_est  in varchar,
                                 ve_cmt in varchar,
                                 ve_user in varchar,
                                 ve_msj  out varchar) is
  
  
  aux_est varchar(1);
  
  VI_PGCOD FSD010.PGCOD%TYPE;
  VI_AOMOD FSD010.AOMOD%TYPE;
  VI_AOSUC FSD010.AOSUC%TYPE;
  VI_AOMDA FSD010.AOMDA%TYPE;
  VI_AOPAP FSD010.AOPAP%TYPE;
  VI_AOCTA FSD010.AOCTA%TYPE;
  VI_AOOPER FSD010.AOOPER%TYPE;
  VI_AOSBOP FSD010.AOSBOP%TYPE;
  VI_AOTOPE FSD010.AOTOPE%TYPE;
  
  vi_cta number(9);
  vi_ope number(9);
  vi_subope number(4);
  vi_tope number(4);
  vi_fecha TIMESTAMP;
  vi_tasa_redu number(10,6);
  vi_tasa_ori number(10,6);
  vi_cfacilidad number(3);
  VI_FECHA_SISTEMA date;
  vi_saldo number(17,2);
  COD_CRM NUMBER;
  begin
  
    if ve_est = 'A' or ve_est='R' then
        begin
          UPDATE AQPC552 A
             SET A.AQPC552EST  = ve_est,
                 A.AQPC552USRM = ve_user,
                 A.AQPC552FECM = SYSDATE,
                 A.AQPC552FECC = SYSDATE,
                 A.AQPC552COM = VE_CMT
           WHERE AQPC552COD = ve_cod;
          ve_msj := 'Se han aplicado los cambios';
        EXCEPTION
          WHEN OTHERS THEN
            ve_msj := 'No se han podido aplicar los cambios, consulte al administrador';
        end;
        BEGIN
               select l.AQPC552EMP, l.AQPC552MOD, l.AQPC552SUC, l.AQPC552MDA, l.AQPC552PAP, l.AQPC552CTA, l.AQPC552OPER, l.AQPC552SBOP, l.AQPC552TOP,l.AQPC552fcrm,l.AQPC552tredu,l.AQPC552TASAACT,
                      l.AQPC552cfac,l.AQPC552SCAPT              
                      /*l.AQPB953cta,
                      l.AQPB953oper,
                      l.AQPB953sbop,
                      l.AQPB953top,
                      l.AQPB953fcrm
                      */
               into VI_PGCOD,VI_AOMOD,VI_AOSUC,VI_AOMDA,VI_AOPAP,VI_AOCTA,VI_AOOPER,VI_AOSBOP,VI_AOTOPE, vi_fecha,vi_tasa_redu,vi_tasa_ori,vi_cfacilidad,vi_saldo
               from AQPC552 l where AQPC552cod= ve_cod;
               
        END; 
        if ve_est = 'R' then
           BEGIN
               select L.AQPC551CORR
               INTO COD_CRM
               FROM AQPC551 L     
               where L.AQPC551CTA = VI_AOCTA
                 --AND L.AQPC551OPER = VI_AOOPER
                 AND TRUNC(L.AQPC551FECR) = vi_fecha;
           exception
             when others then
               null;
           END;   
           --/* descomentar para pase 14.08.2021
           UPDATE AQPC551 A SET A.AQPC551ESTA= 'P', A.AQPC551EHAB='H'
           where A.AQPC551CORR = COD_CRM  AND A.AQPC551ESTA='D' AND A.AQPC551EHAB='H';   
           --*/                
        end if;
        IF VE_EST = 'A'  THEN
          BEGIN
                    SELECT PGFAPE
                    INTO VI_FECHA_SISTEMA
                    FROM FST017
                    WHERE PGCOD=1;
          EXCEPTION
            WHEN OTHERS THEN
              VI_FECHA_SISTEMA := TO_DATE(SYSDATE,'DD/MM/YYYY');
          END;
          BEGIN
             select L.AQPC551CORR
             INTO COD_CRM
             FROM AQPC551 L     
             where L.AQPC551CTA = VI_AOCTA
               --AND L.AQPC551OPER = VI_AOOPER
               AND TRUNC(L.AQPC551FECR) = vi_fecha;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;       
           --/* descomentar para pase 14.08.2021
           UPDATE AQPC551 A SET A.AQPC551ESTA= 'G', A.AQPC551EHAB='H'
           where A.AQPC551CORR = COD_CRM  AND A.AQPC551ESTA='D' AND A.AQPC551EHAB='H'; 
           --CARGAR TASA SIO ES REDUCCION DE TASA Y SE AUTORIZA
           BEGIN
             --if vi_cfacilidad = 1 then  
                 IF vi_saldo = 0 OR vi_saldo is null THEN             
                    vi_saldo:= 99999999;
                 END IF;
                 pQ_CR_REDUCCION_TASA_CAMPANA.SP_CARGAR_TASA_CUENTA(
                  VI_PGCOD,VI_AOMOD,VI_AOSUC,VI_AOMDA,VI_AOPAP,VI_AOCTA,VI_AOOPER,VI_AOSBOP,VI_AOTOPE,
                  vi_tasa_redu,VI_FECHA_SISTEMA,vi_saldo,999,ve_user);
             --end if; 
             --ve_msj := 'Se han aplicado los cambios';
             /*
             if vi_cfacilidad = 7 then  
                 IF vi_saldo = 0 OR vi_saldo is null THEN             
                    vi_saldo:= 99999999;
                 END IF;
                 pQ_CR_REDUCCION_TASA_CAMPANA.SP_CARGAR_TASA_CUENTA(
                  VI_PGCOD,VI_AOMOD,VI_AOSUC,VI_AOMDA,VI_AOPAP,VI_AOCTA,VI_AOOPER,VI_AOSBOP,VI_AOTOPE,
                  vi_tasa_ori,VI_FECHA_SISTEMA,vi_saldo,999,ve_user);
             end if; 
             */
             ve_msj := 'Se han aplicado los cambios';
           END;
        END IF;
     END IF;   
    commit;
  end;


PROCEDURE SP_OBTENER_CARGO(
                            vi_cfacilidad in number,
                            vi_facilidad in varchar,
                            vi_situacion in varchar,
                            vi_pdescuento in number,
                            vo_cargo out number,
                            VO_DCARGO out varchar                            
                          )
  IS 
  BEGIN
       IF vi_cfacilidad = 6 THEN --EXONERACION DE CAPITALIZACION
          BEGIN
              select f.tp1nro1 
                into vo_cargo
              from fst198 f
              where f.tp1cod = 1
                and f.tp1cod1= 10899
                and f.tp1corr1= 400000
                and f.tp1corr2 = 501
                and UPPER(f.tp1desc)  = Rpad(trim(substr(vi_situacion,1,30)),30,' ')
                and f.tp1imp1 <= vi_pdescuento
                and f.tp1imp2 >= vi_pdescuento;
          EXCEPTION
            WHEN OTHERS THEN
              vo_cargo := 240;                             
          END;
       END IF; 
       IF vi_cfacilidad = 7 THEN --AMORTIZACION ANTICIPADA
          BEGIN
              select f.tp1nro1 
                into vo_cargo
              from fst198 f
              where f.tp1cod = 1
                and f.tp1cod1= 10899
                and f.tp1corr1= 400000
                and f.tp1corr2 = 502
                and UPPER(f.tp1desc)  = Rpad(trim(substr(vi_situacion,1,30)),30,' ')
                and f.tp1imp1 <= vi_pdescuento
                and f.tp1imp2 >= vi_pdescuento;
          EXCEPTION
            WHEN OTHERS THEN
              vo_cargo := 240;                             
          END;
       END IF; 
       IF vi_cfacilidad = 1 THEN --REDUCCION DE TASA
          BEGIN
              select f.tp1nro1 
                into vo_cargo
              from fst198 f
              where f.tp1cod = 1
                and f.tp1cod1= 10899
                and f.tp1corr1= 400000
                and f.tp1corr2 = 500
                and UPPER(f.tp1desc)  = Rpad(trim(substr(vi_situacion,1,30)),30,' ')
                and f.tp1imp1 <= vi_pdescuento
                and f.tp1imp2 >= vi_pdescuento;
          EXCEPTION
            WHEN OTHERS THEN
              vo_cargo := 240;                             
          END;
       END IF; 
       IF vi_cfacilidad = 5 THEN --TASA JUNTOS
          BEGIN
              select f.tp1nro1 
                into vo_cargo
              from fst198 f
              where f.tp1cod = 1
                and f.tp1cod1= 10899
                and f.tp1corr1= 400000
                and f.tp1corr2 = 503
                and UPPER(f.tp1desc)  = Rpad(trim(substr(vi_situacion,1,30)),30,' ')
                and f.tp1imp1 <= vi_pdescuento
                and f.tp1imp2 >= vi_pdescuento;
          EXCEPTION
            WHEN OTHERS THEN
              vo_cargo := 240;                             
          END;
       END IF;
       if vo_cargo > 0 then
         begin
          select sng055dsc
          into VO_DCARGO
          from sng055
          where sng055car = vo_cargo;
         exception
           when others then
             null; 
         end;
       end if;  
          
  END;
PROCEDURE SP_OBTENER_CARGO(
                            vi_cfacilidad in number,
                            vi_facilidad in varchar,
                            vi_situacion in varchar,
                            vi_grupo in number,
                            vi_pdescuento in number,
                            vo_cargo out number,                            
                            VO_DCARGO out varchar                            
                          )
  IS 
  BEGIN
       IF vi_cfacilidad = 6 THEN --EXONERACION DE CAPITALIZACION
          BEGIN
              select f.tp1nro1 
                into vo_cargo
              from fst198 f
              where f.tp1cod = 1
                and f.tp1cod1= 10899
                and f.tp1corr1= 400000
                and f.tp1corr2 = 501
                and UPPER(f.tp1desc)  = Rpad(trim(substr(vi_situacion,1,30)),30,' ')
                and f.tp1imp1 <= vi_pdescuento
                and f.tp1imp2 >= vi_pdescuento;
          EXCEPTION
            WHEN OTHERS THEN
              vo_cargo := 240;                             
          END;
       END IF; 
       IF vi_cfacilidad = 7 THEN --AMORTIZACION ANTICIPADA
          BEGIN
              select f.tp1nro1 
                into vo_cargo
              from fst198 f
              where f.tp1cod = 1
                and f.tp1cod1= 10899
                and f.tp1corr1= 400000
                and f.tp1corr2 = 502
                and UPPER(f.tp1desc)  = Rpad(trim(substr(vi_situacion,1,30)),30,' ')
                and f.tp1imp1 <= vi_pdescuento
                and f.tp1imp2 >= vi_pdescuento;
          EXCEPTION
            WHEN OTHERS THEN
              vo_cargo := 240;                             
          END;
       END IF; 
       IF vi_cfacilidad = 1 THEN --REDUCCION DE TASA
          BEGIN
              select f.tp1nro1 
                into vo_cargo
              from fst198 f
              where f.tp1cod = 1
                and f.tp1cod1= 10899
                and f.tp1corr1= 400000
                and f.tp1corr2 = 510
                and f.tp1nro2 = vi_grupo
                and UPPER(f.tp1desc)  = Rpad(trim(substr(vi_situacion,1,30)),30,' ')
                and f.tp1imp1 <= vi_pdescuento
                and f.tp1imp2 >= vi_pdescuento;
          EXCEPTION
            WHEN OTHERS THEN
              BEGIN
                  select f.tp1nro1 
                    into vo_cargo
                  from fst198 f
                  where f.tp1cod = 1
                    and f.tp1cod1= 10899
                    and f.tp1corr1= 400000
                    and f.tp1corr2 = 500
                    and UPPER(f.tp1desc)  = Rpad(trim(substr(vi_situacion,1,30)),30,' ')
                    and f.tp1imp1 <= vi_pdescuento
                    and f.tp1imp2 >= vi_pdescuento;
              EXCEPTION
                WHEN OTHERS THEN
                  vo_cargo := 240;                             
              END;                             
          END;
       END IF;  
       IF vi_cfacilidad = 5 THEN --TASA JUNTOS
          BEGIN
              select f.tp1nro1 
                into vo_cargo
              from fst198 f
              where f.tp1cod = 1
                and f.tp1cod1= 10899
                and f.tp1corr1= 400000
                and f.tp1corr2 = 503
                and UPPER(f.tp1desc)  = Rpad(trim(substr(vi_situacion,1,30)),30,' ')
                and f.tp1imp1 <= vi_pdescuento
                and f.tp1imp2 >= vi_pdescuento;
          EXCEPTION
            WHEN OTHERS THEN
              vo_cargo := 240;                             
          END;
       END IF;
       if vo_cargo > 0 then
         begin
          select sng055dsc
          into VO_DCARGO
          from sng055
          where sng055car = vo_cargo;
         exception
           when others then
             null; 
         end;
       end if; 
          
  END;

PROCEDURE SP_CARGAR_TASA_CUENTA (
                              pn_emp    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_ope    in number,
                              pn_sbo    in number,
                              pn_top    in number,
                              pn_tas    in number,
                              PN_FEC    in date,
                              PN_SALDO  in number,
                              PN_PZO    in number,
                              PN_USER   IN VARCHAR
                              
  ) IS
  VI_FECV DATE;
  VI_PIZARRA NUMBER(5);
  VI_DIAS_VIGENCIA NUMBER(3);
  vi_fec_invertida NUMBER(8);
  ln_FlagTasa NUMBER(3);
  VI_MSG VARCHAR(150);
  BEGIN
    --OBTENER PIZARRA
    --149 PIZARRA DEFINIDA A UTILIZAR, SE PUEDE OBTENER DE LA FPP028
    BEGIN
      SELECT pp028defn
      INTO  VI_PIZARRA
      FROM FPP028 F
      WHERE F.PP028MOD = pn_mod--101 --FIJO
        AND F.PP028TOP = pn_top--600 --FIJO
        AND F.PP028MDA = pn_mda
        AND F.PP028PAP = pn_pap
        AND F.PP017PAR = 17 --ES FIJO
        AND ROWNUM = 1;
    EXCEPTION 
      WHEN OTHERS THEN    
        BEGIN
           VI_PIZARRA := 0;
          END;
    END;
    --
    vi_fec_invertida := 99999999 - to_number(to_char(pn_fec,'YYYYMMDD'));
    
    --AGREGAR LOG DE REGISTRO, PARA VER LAS TASAS INGRESADAS DESDE ESTE MEDIO.
    BEGIN
        PQ_CR_REDUCCION_TASA_CAMPANA.SP_RETIRAR_TASA(
              PN_EMP,PN_MOD,PN_SUC,PN_MDA,PN_PAP,PN_CTA,PN_OPE,PN_SBO,pn_top,pn_fec
        ); 
        commit;
    END;
    
    BEGIN
       INSERT INTO
               AQPC553 C ( C.AQPC553EMP,C.AQPC553MOD,C.AQPC553SUC,
                           C.AQPC553MDA,C.AQPC553PAP,C.AQPC553CTA,
                           C.AQPC553OPE,C.AQPC553SBO,C.AQPC553TOP,
                           C.AQPC553TCOD,C.AQPC553TMOD,C.AQPC553TPIZ,
                           C.AQPC553TCTA,C.AQPC553TMDA,C.AQPC553TPAP,
                           C.AQPC553TFDE,C.AQPC553TMTO,C.AQPC553TTAS,
                           C.AQPC553TPFI,C.AQPC553TPVI,
                           C.AQPC553FECR,C.AQPC553USUR,C.AQPC553TIPR,C.AQPC553TIPI) 
               VALUES (
                        PN_EMP,PN_MOD,PN_SUC,PN_MDA,PN_PAP,PN_CTA,PN_OPE,PN_SBO,PN_TOP,
                        PN_EMP,PN_MOD,VI_PIZARRA,PN_CTA,PN_MDA,PN_PAP,PN_FEC,PN_SALDO,1,vi_fec_invertida,'S',
                        SYSDATE,PN_USER,0,'I'
                      );
               --commit;               
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    ln_FlagTasa := 0;
    --GRABAR PRIMERA PIZARRA
    --FSD027
    --COLOCAR EL SALDO CAPITAL DEL CREDITO A OTORGAR LA TASA, LA FECHA DE INICIO DE VIGENCIA Y LA FECHA INVERTIDA
    --PROBAR CON FECHA 03/12/2021
    SELECT COUNT(*) INTO ln_FlagTasa FROM FSD027 
           WHERE MODULO = PN_MOD AND CTNRO = PN_CTA AND TPIZAR = VI_PIZARRA AND TPFDES = PN_FEC;
    --      
    IF ln_FlagTasa = 0 THEN
      BEGIN        
          INSERT INTO
                  FSD027 A ( A.PGCOD,A.MODULO,A.TPIZAR,A.CTNRO,A.MONEDA,A.PAPEL,A.TPFDES,A.TPMTO,A.TPTTAS,A.TPFINV,A.TPVIG)
                  VALUES (
                           PN_EMP,PN_MOD,VI_PIZARRA,PN_CTA,PN_MDA,PN_PAP,PN_FEC,PN_SALDO,1,vi_fec_invertida,'S'
                         );
                  --commit;
                  
                  
      EXCEPTION
        WHEN OTHERS THEN  
          BEGIN          
              UPDATE FSD027 A
              SET TPVIG = 'S',
                  TPMTO = PN_SALDO --NUEVO
              WHERE  A.PGCOD =  pn_emp
                AND  A.MODULO=  PN_MOD
                AND  A.TPIZAR=  VI_PIZARRA
                AND  A.CTNRO =  pn_cta
                AND  A.MONEDA=  pn_mda
                AND  A.PAPEL =  pn_pap
                AND  A.TPFDES=  PN_FEC;
                --AND  A.TPVIG = 'N';
          END;                    
       END;
    ELSE
       BEGIN
        UPDATE FSD027 A
            SET TPVIG = 'S',
                TPMTO = PN_SALDO --NUEVO
            WHERE  A.PGCOD =  pn_emp
              AND  A.MODULO=  PN_MOD
              AND  A.TPIZAR=  VI_PIZARRA
              AND  A.CTNRO =  pn_cta
              AND  A.MONEDA=  pn_mda
              AND  A.PAPEL =  pn_pap
              AND  A.TPFDES=  PN_FEC;            
      EXCEPTION
        WHEN OTHERS THEN  
          NULL;
      END;
    END IF;       
    
    --FSR027
    ln_FlagTasa := 0;
    SELECT COUNT(*) INTO ln_FlagTasa FROM FSR027 
           WHERE MODULO = PN_MOD AND CTNRO = PN_CTA AND TPIZAR = VI_PIZARRA AND TPFDES = PN_FEC;
    IF ln_FlagTasa = 0 THEN
      BEGIN
        INSERT INTO
               FSR027 B ( B.PGCOD,B.MODULO,B.TPIZAR,B.CTNRO,B.MONEDA,B.PAPEL,B.TPFDES,B.TPMTO,B.TPPZO,B.TPTASA)
               VALUES (
                        PN_EMP,PN_MOD,VI_PIZARRA,PN_CTA,PN_MDA,PN_PAP,PN_FEC,PN_SALDO,99999,PN_TAS
                      );
               --commit;  
      exception
        when others then
          null;                 
      END;
    ELSE
      BEGIN
        UPDATE FSR027 A
            SET TPMTO = PN_SALDO,
                TPTASA = PN_TAS --NUEVO
            WHERE  A.PGCOD =  pn_emp
              AND  A.MODULO=  PN_MOD
              AND  A.TPIZAR=  VI_PIZARRA
              AND  A.CTNRO =  pn_cta
              AND  A.MONEDA=  pn_mda
              AND  A.PAPEL =  pn_pap
              AND  A.TPFDES=  PN_FEC;            
      EXCEPTION
        WHEN OTHERS THEN  
          NULL;
      END;
    END IF;    
    
    --FSD327
    BEGIN
      SELECT TP1NRO1
      INTO VI_DIAS_VIGENCIA 
      FROM FST198
      WHERE TP1COD   = 1
        AND TP1COD1  = 11161
        AND TP1CORR1 = 5
        AND TP1CORR2 = 1
        AND TP1CORR3 = 4;
    EXCEPTION 
      WHEN OTHERS THEN
        VI_DIAS_VIGENCIA := 30;    
    END;
    VI_FECV := PN_FEC + VI_DIAS_VIGENCIA;
    BEGIN
       INSERT INTO
               FSD327 B ( B.VT1PGCOD,B.VT1MOD,B.VT1TPIZ,B.VT1CTNR,B.VT1MON,B.VT1PAP,B.VT1TPFD,B.VT1FCHVEN)
               VALUES (
                        PN_EMP,PN_MOD,VI_PIZARRA,PN_CTA,PN_MDA,PN_PAP,PN_FEC,VI_FECV
                      );
               --commit;
    EXCEPTION 
      WHEN OTHERS THEN           
        UPDATE FSD327 B
            SET B.VT1FCHVEN = VI_FECV
            WHERE B.VT1PGCOD = pn_emp
              AND B.VT1MOD = PN_MOD
              AND B.VT1TPIZ= VI_PIZARRA
              AND B.VT1CTNR= pn_cta
              AND B.VT1MON = pn_mda
              AND B.VT1PAP = pn_pap
              AND B.VT1TPFD= PN_FEC;
    END;        
  END;
  
  PROCEDURE SP_RETIRAR_TASA (
                              pn_emp    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_ope    in number,
                              pn_sbo    in number,
                              pn_top    in number,
                              pn_fec    in DATE
    )
    IS
    VI_FLAG NUMBER(3);
    VI_FEC DATE;
    VI_TIPOUPDREG NUMBER(3);
    VI_PIZARRA NUMBER(3);
    VI_FECHAB DATE;
    FLAG CHAR(1);
  BEGIN
      begin
         SELECT PGFAPE INTO VI_FECHAB FROM FST017 WHERE PGCOD=1;
      end;
      --OBTENER LA FECHA DE REGISTRO DE DESEMBOLSO
      FLAG := 'S';
      BEGIN
           SELECT MAX(AQPC553TFDE)
           INTO VI_FEC
           FROM AQPC553 A
           WHERE A.AQPC553TCOD = pn_emp
             AND A.AQPC553TMOD = pn_mod
             AND A.AQPC553TCTA = pn_cta
             AND A.AQPC553TMDA = pn_mda
             AND A.AQPC553TPAP = pn_pap
             --AND A.AQPB954TFDE = VI_FEC
             AND A.AQPC553TPVI = 'S';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          FLAG := 'N';      
      END;
      IF FLAG = 'S' THEN
      BEGIN
           SELECT A.AQPC553TPIZ
           INTO VI_PIZARRA
           FROM AQPC553 A
           WHERE A.AQPC553TCOD = pn_emp
             AND A.AQPC553TMOD = pn_mod
             AND A.AQPC553TCTA = pn_cta
             AND A.AQPC553TMDA = pn_mda
             AND A.AQPC553TPAP = pn_pap
             AND A.AQPC553TFDE = VI_FEC
             AND A.AQPC553TPVI = 'S';
       EXCEPTION
         WHEN OTHERS THEN
           NULL;    
       END;

      BEGIN
        SELECT A.PGCOD
        INTO VI_FLAG
        FROM FSD027 a
        WHERE  A.PGCOD =  pn_emp
          AND  A.MODULO=  pn_mod
          AND  A.TPIZAR=  VI_PIZARRA
          AND  A.CTNRO =  pn_cta
          AND  A.MONEDA=  pn_mda
          AND  A.PAPEL =  pn_pap
          AND  A.TPFDES=  VI_FEC
          AND  A.TPVIG = 'S';
      EXCEPTION
        WHEN OTHERS THEN
            VI_FLAG:= 0;  
      END;

      END IF;
      BEGIN
          IF VI_FLAG = 1 THEN
            update AQPC553 A
            SET A.AQPC553TPVI = 'N'
           WHERE A.AQPC553TCOD = pn_emp
             AND A.AQPC553TMOD = pn_mod
             AND A.AQPC553TCTA = pn_cta
             AND A.AQPC553TMDA = pn_mda
             AND A.AQPC553TPAP = pn_pap
             AND A.AQPC553TFDE = VI_FEC
             AND A.AQPC553TPVI = 'S';
             COMMIT;

            UPDATE FSD027 A
            SET TPVIG = 'N'
            WHERE  A.PGCOD =  pn_emp
              AND  A.MODULO=  pn_mod
              AND  A.TPIZAR=  VI_PIZARRA
              AND  A.CTNRO =  pn_cta
              AND  A.MONEDA=  pn_mda
              AND  A.PAPEL =  pn_pap
              AND  A.TPFDES=  VI_FEC
              AND  A.TPVIG = 'S';
              VI_TIPOUPDREG := 1;

            UPDATE FSD327 B
            SET B.VT1FCHVEN = VI_FECHAB - 1
            WHERE B.VT1PGCOD = pn_emp
              AND B.VT1MOD = pn_mod
              AND B.VT1TPIZ= VI_PIZARRA
              AND B.VT1CTNR= pn_cta
              AND B.VT1MON = pn_mda
              AND B.VT1PAP = pn_pap
              AND B.VT1TPFD= VI_FEC;
              COMMIT;  
          END IF;
      END;
  --COLOCAR LOG DE RETIRO. DE LA TRANSACCION DE RETIRO
  BEGIN      
       BEGIN
             UPDATE AQPC553 AB
             SET AB.AQPC553FECM = SYSDATE,
                 AB.AQPC553TPVI = 'N'
             WHERE AB.AQPC553TCOD = pn_emp
             AND AB.AQPC553TMOD = pn_mod
             AND AB.AQPC553TCTA = pn_cta
             AND AB.AQPC553TMDA = pn_mda
             AND AB.AQPC553TPAP = pn_pap
             AND AB.AQPC553TFDE = VI_FEC
             AND AB.AQPC553TIPI = 'S';
       END;            
       COMMIT;
    END;
END;

PROCEDURE SP_CARGAR_CLV_LCRD(VE_CORRELATIVO in number,
                             VE_INSTANCIA in number,
                             VI_PGCOD     out number,
                             VI_AOMOD     out number,
                             VI_AOSUC     out number,
                             VI_AOMDA     out number,
                             VI_AOPAP     out number,
                             VI_AOCTA     out number,
                             VI_AOOPER    out number,
                             VI_AOSBOP    out number,
                             VI_AOTOPE    out number
                            )

is
BEGIN
        BEGIN
            SELECT A.AQPC551COD, A.AQPC551MOD, A.AQPC551SUC, A.AQPC551MDA, A.AQPC551PAP, A.AQPC551CTA, A.AQPC551OPER, A.AQPC551SBOP, A.AQPC551TOPE
                   INTO VI_PGCOD, VI_AOMOD, VI_AOSUC, VI_AOMDA,VI_AOPAP, VI_AOCTA, VI_AOOPER, VI_AOSBOP, VI_AOTOPE
            FROM AQPC551 A
            WHERE A.AQPC551CORR = VE_CORRELATIVO
                --AND A.AQPB904INS = VE_INSTANCIA
                AND A.AQPC551ESTA IN ('P','D','A','G')
                AND A.AQPC551EHAB = 'H';
        END;
END;

PROCEDURE SP_VALIDAR_SALDOCAPITAL(
                                   VE_INSTANCIA  NUMBER,
                                   VO_SALDOCAP out NUMBER
                                 )
                                  IS
                                  --LISTA DE CREDITOS VINCULADOS
                                  CURSOR LISTA_LINEAS(vi_instancia number) is
                                  select *
                                     from jaqy800 j
                                     where j.jaqy800ins = Vi_INSTANCIA ;
                                  --
                                  saldo_capital number(17,2); 
                                  sdo_cap_total number(17,2);
                                  
                                  --
                                  vi_aqpb904acod xwf700.xwfempresa%type;
                                  vi_aqpb904amod xwf700.xwfmodulo%type;
                                  vi_aqpb904asuc xwf700.xwfsucursal%type;
                                  vi_aqpb904amda xwf700.xwfmoneda%type;
                                  vi_aqpb904apap xwf700.xwfpapel%type;
                                  vi_aqpb904acta xwf700.xwfcuenta%type;
                                  vi_aqpb904aoper xwf700.xwfoperacion%type;
                                  vi_aqpb904asbop xwf700.xwfsubope%type;
                                  vi_aqpb904atope xwf700.xwftipope%type;  
                                  --Buscar la linea vinculada
                                  BEGIN
                                     sdo_cap_total := 0;
                                     FOR  J in  LISTA_LINEAS(ve_instancia) LOOP
                                         saldo_capital := 0;
                                         
                                         vi_aqpb904acod:= 0;
                                         vi_aqpb904amod:= 0;
                                         vi_aqpb904asuc:= 0;
                                         vi_aqpb904amda:= 0;
                                         vi_aqpb904apap:= 0;
                                         vi_aqpb904acta:= 0;
                                         vi_aqpb904aoper:= 0;
                                         vi_aqpb904asbop:=0;
                                         vi_aqpb904atope:= 0;
                                         BEGIN
                                            
                                            pq_cr_lineas_rcaja_hs.OBTENER_CLAVE_LINEA_UTILIZADA( j.JAQY800PGCD,j.JAQY800MOD,j.JAQY800SUC,
                                                                                                 j.JAQY800MDA,j.JAQY800PAP,j.JAQY800CTA,
                                                                                                 j.JAQY800OPE,j.JAQY800SBOP,j.JAQY800TOPE,
                                                                                                 vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                                                                                                 vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                                                                                                 vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope
                                                                                                 );
                                                                                                     
                                         END;
                                         BEGIN
                                              SELECT d.scsdo*-1
                                              INTO  saldo_capital 
                                              FROM FSD011 D
                                              WHERE D.PGCOD = vi_aqpb904acod 
                                                AND D.SCSUC = vi_aqpb904asuc
                                                and d.scmod = vi_aqpb904amod
                                                AND D.SCMDA = vi_aqpb904amda
                                                AND D.SCPAP = vi_aqpb904apap                                   
                                                AND D.SCCTA = vi_aqpb904acta
                                                AND D.SCOPER= vi_aqpb904aoper
                                                AND D.SCSBOP= vi_aqpb904asbop
                                                AND D.SCTOPE= vi_aqpb904atope;
                                         EXCEPTION 
                                           WHEN OTHERS THEN 
                                             saldo_capital := 0;       
                                         END;  
                                         sdo_cap_total := sdo_cap_total + saldo_capital;
                                     END LOOP;
                                     vo_saldocap := sdo_cap_total;
                                  END;
    PROCEDURE OBTENER_CLAVE_LINEA_UTILIZADA(
                                            pn_emp    in number,
                                            pn_mod    in number,
                                            pn_suc    in number,
                                            pn_mda    in number,
                                            pn_pap    in number,
                                            pn_cta    in number,
                                            pn_ope    in number,
                                            pn_sbo    in number,
                                            pn_top    in number,
                                            vo_emp    OUT number,
                                            vo_mod    out number,
                                            vo_suc    out number,
                                            vo_mda    out number,
                                            vo_pap    out number,
                                            vo_cta    out number,
                                            vo_ope    out number,
                                            vo_sbo    out number,
                                            vo_top    out number   
                                            ) is
      VI_MAX_FEC DATE;
      
    BEGIN
      --OBTENER LA ULTIMA FECHA
      BEGIN
            SELECT MAX(R011FC)
            INTO VI_MAX_FEC 
            FROM FSR011 
            WHERE R2COD=pn_emp AND R2MOD = pn_mod AND R2SUC=pn_suc AND R2MDA=pn_mda AND R2PAP=pn_pap
              AND R2CTA=pn_CTA and r2oper= pn_ope and r2sbop=pn_sbo and r2tope=pn_top;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;      
      END;
      BEGIN
            SELECT R1COD,R1MOD,R1SUC,R1MDA,R1PAP,R1CTA,r1oper,r1sbop,r1tope
            INTO   vo_emp,vo_mod,vo_suc,vo_mda,vo_pap,vo_cta,vo_ope,vo_sbo,vo_top
            FROM FSR011 
            WHERE R2COD=pn_emp AND R2MOD = pn_mod AND R2SUC=pn_suc AND R2MDA=pn_mda AND R2PAP=pn_pap
              AND R2CTA=pn_CTA and r2oper= pn_ope and r2sbop=pn_sbo and r2tope=pn_top AND R011FC=VI_MAX_FEC;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;      
      END;
    END;
    
   
 PROCEDURE OBTENER_EL_SALDO_CAPITAL_TOT(vo_instancia number,vi_deutot out number) IS
             
   --VI_DEUTOT NUMBER(17,2);
   VI_DEUDA NUMBER(17,2);
   VS_RPTA VARCHAR(150);

   vi_aqpb904acod xwf700.xwfempresa%type;
   vi_aqpb904amod xwf700.xwfmodulo%type;
   vi_aqpb904asuc xwf700.xwfsucursal%type;
   vi_aqpb904amda xwf700.xwfmoneda%type;
   vi_aqpb904apap xwf700.xwfpapel%type;
   vi_aqpb904acta xwf700.xwfcuenta%type;
   vi_aqpb904aoper xwf700.xwfoperacion%type;
   vi_aqpb904asbop xwf700.xwfsubope%type;
   vi_aqpb904atope xwf700.xwftipope%type;
         
CURSOR LISTA_CREDITOS(VI_INSTANCIA NUMBER) IS
SELECT *
  FROM XWF700 
 WHERE XWFCAR3 IN ('1','A')
   AND XWFPRCINS = VI_INSTANCIA; 
BEGIN
    VI_DEUTOT := 0;
    FOR J IN LISTA_CREDITOS(vo_instancia) LOOP
        VI_DEUDA:=0;
        
        pq_cr_lineas_rcaja_hs.OBTENER_CLAVE_LINEA_UTILIZADA(j.xwfempresa,j.xwfmodulo,j.xwfsucursal,
                                                                   j.xwfmoneda,j.xwfpapel,j.xwfcuenta,
                                                                   j.xwfoperacion,j.xwfsubope,j.xwftipope,
                                                                       vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                                                                       vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                                                                       vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope
                   );
        PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_saldo_capital(
                                                                   vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                                                                   vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                                                                   vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope,
                                                                   VI_DEUDA);                                                                  
        vi_deutot := vi_deutot + VI_DEUDA;                                                           
    END LOOP;
    --DBMS_OUTPUT.put_line(VI_DEUTOT);
END;
PROCEDURE OBTENER_DEUDAVIVA_TOT(vo_instancia number,vo_DeudaTotal out number) IS
             
   --VI_DEUTOT NUMBER(17,2);
   VI_DEUDA NUMBER(17,2);
   VS_RPTA VARCHAR(150);

   vi_aqpb904acod xwf700.xwfempresa%type;
   vi_aqpb904amod xwf700.xwfmodulo%type;
   vi_aqpb904asuc xwf700.xwfsucursal%type;
   vi_aqpb904amda xwf700.xwfmoneda%type;
   vi_aqpb904apap xwf700.xwfpapel%type;
   vi_aqpb904acta xwf700.xwfcuenta%type;
   vi_aqpb904aoper xwf700.xwfoperacion%type;
   vi_aqpb904asbop xwf700.xwfsubope%type;
   vi_aqpb904atope xwf700.xwftipope%type;
         
CURSOR LISTA_CREDITOS(VI_INSTANCIA NUMBER) IS
SELECT *
  FROM XWF700 
 WHERE XWFCAR3 IN ('1','A')
   AND XWFPRCINS = VI_INSTANCIA; 
BEGIN
    vo_DeudaTotal := 0;
    FOR J IN LISTA_CREDITOS(vo_instancia) LOOP
        VI_DEUDA:=0;
        
        pq_cr_lineas_rcaja_hs.OBTENER_CLAVE_LINEA_UTILIZADA(j.xwfempresa,j.xwfmodulo,j.xwfsucursal,
                                                                   j.xwfmoneda,j.xwfpapel,j.xwfcuenta,
                                                                   j.xwfoperacion,j.xwfsubope,j.xwftipope,
                                                                       vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                                                                       vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                                                                       vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope
                   );
        PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_deuda_viva_credito(
                                                                   vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                                                                   vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                                                                   vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope,
                                                                   VI_DEUDA,vs_rpta);                                                                  
        vo_DeudaTotal := vo_DeudaTotal + VI_DEUDA;                                                           
    END LOOP;
    --DBMS_OUTPUT.put_line(VI_DEUTOT);
END;  
PROCEDURE SP_GRABAR_DEUDA_TOTAFEC(VE_INSTANCIA number,
                                  VE_CORRELATIVO number,
                                  VE_DeudaTotal number  
  ) is 
begin
      UPDATE AQPB904 A SET
             A.AQPB904DEUTF = VE_DeudaTotal,
             A.AQPB904FECR  = TO_DATE(SYSDATE,'DD/MM/YYYY'),
             A.AQPB904HORA  = TO_CHAR(SYSDATE,'HH:MI:ss')
             WHERE A.AQPB904CORR = VE_CORRELATIVO
               AND A.AQPB904INS  = VE_INSTANCIA
               AND A.AQPB904ESTA = 'P'
               AND A.AQPB904EHAB = 'H';
             COMMIT;
end;

PROCEDURE SP_VALIDAR_CANCEL( pn_emp    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_ope    in number,
                             pn_sbo    in number,
                             pn_top    in number,
                             vs_rpta   out varchar
                           ) is
VI_ESTA NUMBER(2);                 
BEGIN
      --validar estado
      BEGIN
          SELECT D.AOSTAT
            INTO VI_ESTA
            FROM FSD010 D
           WHERE D.PGCOD  =  pn_emp
             AND D.AOMOD  =  pn_mod
             AND D.AOSUC  =  pn_suc
             AND D.AOMDA  =  pn_mda
             AND D.AOPAP  =  pn_pap
             AND D.AOCTA  =  pn_cta
             AND D.AOOPER =  pn_ope
             AND D.AOSBOP =  pn_sbo
             AND D.AOTOPE =  pn_top;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;       
      END;   
      IF VI_ESTA = 99 THEN
         vs_rpta:= 'S';
      ELSE
         vs_rpta:= 'N' ;  
      END IF;
END;           
     
  PROCEDURE SP_CR_COMPRA_DEUDA(
     P_InInstancia  IN NUMBER,
     P_OutCoprDeuda OUT VARCHAR2) IS
     vCoprDeuda VARCHAR2(1);
     vOutTipConv VARCHAR2(10);
     BEGIN
       BEGIN
         SELECT 'S'
         INTO vCoprDeuda
         FROM JAQZ862
         WHERE JAQZ862INST = P_InInstancia AND JAQZ862ESTA = 'S' AND JAQZ862AUX4 = '1' AND
         JAQZ862CORR = (SELECT MAX(JAQZ862CORR) FROM JAQZ862 WHERE JAQZ862INST = P_InInstancia AND
          JAQZ862ESTA = 'S' AND JAQZ862AUX4 = '1');
       EXCEPTION
         WHEN OTHERS THEN
           BEGIN
             SELECT 'S'
             INTO vCoprDeuda
             FROM JAQY327
             WHERE JAQY327INST = P_InInstancia AND JAQY327ESTA = 'S' AND JAQY327AUX4 = '1' AND
             JAQY327CORR = (SELECT MAX(JAQY327CORR) FROM JAQY327 WHERE JAQY327INST = P_InInstancia AND
             JAQY327ESTA = 'S' AND JAQY327AUX4 = '1');
             EXCEPTION
               WHEN OTHERS THEN
                 vCoprDeuda:= 'N';
             END;
       END;
       P_OutCoprDeuda := vCoprDeuda;
  END SP_CR_COMPRA_DEUDA;

  PROCEDURE SP_CR_COMPRA_DEUDA2(
     P_InCuenta IN NUMBER,
     P_OutCoprDeuda OUT VARCHAR2) IS

     CURSOR INSTANCIAS_VUELO(VI_CUENTA NUMBER) IS
       SELECT XWFPRCINS
              FROM XWF700
           WHERE XWFCUENTA = VI_CUENTA
             AND XWFCAR3 = 'S';

     vCoprDeuda VARCHAR2(1);
     vOutTipConv VARCHAR2(10);
     BEGIN
       vCoprDeuda := 'N';
       FOR I IN INSTANCIAS_VUELO(P_InCuenta) LOOP
           BEGIN
             SELECT 'S'
             INTO vCoprDeuda
             FROM JAQZ862
             WHERE JAQZ862INST = I.XWFPRCINS AND JAQZ862ESTA = 'S' AND JAQZ862AUX4 = '1' AND
             JAQZ862CORR = (SELECT MAX(JAQZ862CORR) FROM JAQZ862 WHERE JAQZ862INST = I.XWFPRCINS AND
              JAQZ862ESTA = 'S' AND JAQZ862AUX4 = '1');
           EXCEPTION
             WHEN OTHERS THEN
               BEGIN
                 SELECT 'S'
                 INTO vCoprDeuda
                 FROM JAQY327
                 WHERE JAQY327INST = I.XWFPRCINS AND JAQY327ESTA = 'S' AND JAQY327AUX4 = '1' AND
                 JAQY327CORR = (SELECT MAX(JAQY327CORR) FROM JAQY327 WHERE JAQY327INST = I.XWFPRCINS AND
                 JAQY327ESTA = 'S' AND JAQY327AUX4 = '1');
                 EXCEPTION
                   WHEN OTHERS THEN
                     vCoprDeuda:= 'N';
                 END;
           END;
       END LOOP;
       P_OutCoprDeuda := vCoprDeuda;
       /*IF vCoprDeuda = 'S' THEN
         PQ_CR_CAMP_CONVENIO.sp_cr_inicio(P_InInstancia, vOutTipConv);
         IF vOutTipConv = 'PRIVADA' OR vOutTipConv = 'PUBLICA' THEN
           P_OutCoprDeuda := vCoprDeuda;
           P_OutTipConv := vOutTipConv;
         END IF;
       END IF;*/
  END SP_CR_COMPRA_DEUDA2;
  
  PROCEDURE SP_CR_ETAPA_SOLICITUD(
     P_InCuenta  IN NUMBER, 
     P_OutSolicitud OUT VARCHAR2) IS
     
     CURSOR INSTANCIAS_VUELO(VI_CUENTA NUMBER) IS
       SELECT XWFPRCINS 
              FROM XWF700 
           WHERE XWFCUENTA = VI_CUENTA
             AND XWFCAR3 = '1'
             AND (XWFMODULO,XWFTIPOPE)
             IN(
                 SELECT tp1nro1, tp1nro2 FROM FST198 
                 WHERE tp1cod = 1 AND tp1cod1 = 11161 
                   AND tp1corr1 = 31 AND tp1corr2 = 0 AND tp1corr3 > 0
             );
                
     vSolicitud VARCHAR2(1);
     BEGIN
       vSolicitud := 'N';
       FOR I IN INSTANCIAS_VUELO(P_InCuenta) LOOP
           BEGIN             
             SELECT 'S' INTO vSolicitud
             FROM WFWRKITEMS 
             WHERE WFINSPRCID = I.XWFPRCINS
               AND WFTASKCOD = 3
               AND WFITEMSTSACT = 1;
           EXCEPTION
             WHEN OTHERS THEN
               vSolicitud:= 'N';
           END;
       END LOOP;
       --vSolicitud := 'S';
       P_OutSolicitud := vSolicitud;
  END SP_CR_ETAPA_SOLICITUD;
  
  PROCEDURE SP_CR_SI_GESTIONADO (P_InCuenta IN NUMBER, P_InModulo IN NUMBER, P_InTope IN NUMBER, P_OutGest OUT VARCHAR2)
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.07.07
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Resolutor Politica indica si fue gestionado
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_InCuenta ( Cuenta )
    --                            : P_InModulo ( Modulo )
    --                            : P_InModulo ( TipOpe )
    -- Parámetros de Salida       : P_OutGest ( Resultado S/N )
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
    -- ******************************************************************
  is
        lv_res_panel varchar2(1);
  begin
        P_OutGest := 'N';
        BEGIN
            SELECT 'S' INTO lv_res_panel FROM AQPC551
                    WHERE AQPC551MOD = P_InModulo
                      AND AQPC551CTA = P_InCuenta
                      AND AQPC551TOPE = P_InTope
                      AND AQPC551FECC = (SELECT MAX(AQPC551FECC) FROM AQPC551);

        EXCEPTION WHEN OTHERS THEN
            lv_res_panel := 'N';
        END;
        --lv_res_panel := 'S';
        P_OutGest := lv_res_panel;
  END SP_CR_SI_GESTIONADO;

  PROCEDURE SP_CR_TASA_TARIFARIO (P_InInstancia IN NUMBER, P_OutTasa OUT NUMBER)
        is
        vi_empresa xwf700.xwfempresa%type;
        vi_modulo xwf700.xwfmodulo%type;
        vi_sucursal xwf700.xwfsucursal%type;
        vi_moneda xwf700.xwfmoneda%type;
        vi_papel xwf700.xwfpapel%type;
        vi_cuenta xwf700.xwfcuenta%type;
        vi_operacion xwf700.xwfoperacion%type;
        vi_suboperacion xwf700.xwfsubope%type;
        vi_tipoperacion xwf700.xwftipope%type;
        vi_monto xwf700.xwfmonto1%type;
        vi_pais   NUMBER;
        VI_petdoc NUMBER;
        vi_pendoc VARCHAR2(12);
        --------------------
        evaluacion number(10);
        ---------------------               
        pn_plazo NUMBER;
        pn_tarifario NUMBER;
        pn_codsegment NUMBER;
        pv_dessegment VARCHAR2(50);
        pn_grupo NUMBER;
        pn_codvivienda NUMBER;
        pn_codsegment_incl NUMBER;
        pn_tipo_inclusivo NUMBER;
        VI_EXISTE NUMBER(3);
  begin
        P_OutTasa := 0;  
        pn_plazo := 0;
        pn_tarifario := 0;
        pn_codsegment := 0;
        pv_dessegment := '';
        pn_grupo := 0;
        pn_codvivienda := 0;
        pn_codsegment_incl := 0;
        pn_tipo_inclusivo := 0;
        --Buscar clave de la instancia en vuelo   
        --INSERT INTO PRUEBA_LOG(PGCOD,MSG,INSTANCIA,FECHA)VALUES(33,'PARAMETRO DELLEGADA' ,P_InInstancia,SYSDATE);
        BEGIN
            SELECT XWFEMPRESA,XWFSUCURSAL,XWFMODULO,
                   XWFMONEDA,XWFPAPEL,XWFCUENTA,XWFOPERACION,
                   XWFSUBOPE,XWFTIPOPE,XWFMONTO1,XWFPLAZO1
               INTO vi_empresa,vi_sucursal,vi_modulo, 
                    vi_moneda,vi_papel,vi_cuenta,vi_operacion, 
                    vi_suboperacion, vi_tipoperacion,vi_monto,pn_plazo
            FROM XWF700 WHERE XWFPRCINS = P_InInstancia AND XWFCAR3 = '1'
            AND (XWFMODULO, XWFTIPOPE) IN (
              SELECT tp1nro1,tp1nro2 FROM fst198 
                   WHERE tp1cod = 1 AND tp1cod1 = 11161 AND tp1corr1 = 31 
                     AND tp1corr2 = 0 AND tp1corr3 > 0
            );
        EXCEPTION WHEN OTHERS THEN
            vi_monto := 0;
            pn_plazo := 0;
        END;
        --Buscar plazo segun la clave del credito en vuelo             
        /*BEGIN
            SELECT XLLPLAZO INTO pn_plazo FROM x054023 
                  WHERE XLLPGCOD = vi_empresa
                   AND XLLAOMOD = vi_modulo
                   AND XLLAOSUC = vi_sucursal
                   AND XLLAOMDA = vi_moneda
                   AND XLLAOPAP = vi_papel
                   AND XLLAOCTA = vi_cuenta
                   AND XLLAOOPER = vi_operacion
                   AND XLLAOSBOP = vi_suboperacion
                   AND XLLAOTOP = vi_tipoperacion;
        EXCEPTION WHEN OTHERS THEN
            pn_plazo := 0;
        END;*/
        --Buscar el tarifario de meses segun el plazo
        BEGIN          
            SELECT tp1nro1 INTO pn_tarifario FROM fst198 
                 WHERE tp1cod = 1 AND tp1cod1 = 11161 AND tp1corr1 = 6 
                   AND tp1corr2 = 2 AND tp1corr3 > 0
                   AND pn_plazo >= tp1imp1 AND pn_plazo <= tp1imp2;
        EXCEPTION WHEN OTHERS THEN
            pn_tarifario := 0;
        END;               
        IF vi_modulo IN (101,102) THEN
           --Buscar el codigo de segmento en el tarifario segun la instancia 
           BEGIN
              SELECT SUBSTR(PAE71VAL,0,(INSTR(PAE71VAL,':')-1)) INTO pv_dessegment from fpae70 xx, fpae71 yy where xx.pae51eva=yy.pae51eva
                  and xx.pae70nro=yy.pae70nro 
                  and xx.pae51eva= 1 
                  and yy.pae71ite = 380
                  and xx.pae70ins = P_InInstancia
                  and XX.pae70nro = (select max(pae70nro) from fpae70 where pae70ins = P_InInstancia AND PAE51EVA=1);          
            EXCEPTION WHEN OTHERS THEN
                pv_dessegment := '';
                pn_codvivienda := 0;
            END;               
            --Buscar la descripcion del segmento por la guia  
            BEGIN   
              SELECT tp1nro1 INTO pn_codsegment FROM fst198 
                     WHERE tp1cod = 1 AND tp1cod1 = 11161 AND tp1corr1 = 6 
                       AND tp1corr2 = 0 AND tp1corr3 > 0
                       AND tp1desc = upper(rpad(pv_dessegment, 30, ' '));
            EXCEPTION WHEN OTHERS THEN
                 pn_codsegment := 0;
            END; 
            --Buscar el codigo de grupo
            BEGIN
               SELECT tp1nro1 INTO pn_grupo FROM fst198 
                     WHERE tp1cod = 1 AND tp1cod1 = 11161 AND tp1corr1 = 6 
                       AND tp1corr2 = 3 AND tp1corr3 > 0
                       AND tp1corr3 = vi_sucursal;
            EXCEPTION WHEN OTHERS THEN
                 pn_grupo := 0;     
            END;
            --FINAL Buscar la tasa acorde a la matriz del tarifario
            BEGIN          
                SELECT tp1imp3 INTO P_OutTasa FROM fst198 
                       WHERE tp1cod = 1 AND tp1cod1 = 11161 AND tp1corr1 = 6 
                         AND tp1corr2 = 1 AND tp1corr3 > 0
                         AND tp1nro1 = pn_codsegment AND tp1nro2 = pn_tarifario AND tp1nro3 = pn_grupo 
                         AND vi_monto >= tp1imp1 AND vi_monto <= tp1imp2;
              EXCEPTION WHEN OTHERS THEN
                 P_OutTasa := 400;
            END;
        ELSIF vi_modulo = 103 THEN ------------------------------------------------------------
           BEGIN
              SELECT TRIM(PAE71VAL) INTO pv_dessegment from fpae70 xx, fpae71 yy where xx.pae51eva=yy.pae51eva
                  and xx.pae70nro=yy.pae70nro 
                  and xx.pae51eva= 1 
                  and yy.pae71ite = 338
                  and xx.pae70ins = P_InInstancia
                  and XX.pae70nro = (select max(pae70nro) from fpae70 where pae70ins = P_InInstancia AND PAE51EVA=1);                              
            EXCEPTION WHEN OTHERS THEN
                pv_dessegment := '';
            END;   
            BEGIN
              --Obtener documento
              SELECT PEPAIS,PETDOC,PENDOC
                     INTO vi_pais,vi_petdoc,vi_pendoc
              FROM FSR008 WHERE CTNRO = vi_cuenta AND CTTFIR = 'T';
              --OBTENER CODIGO DE VIVIENDA
              SELECT s.sngc12vivc
                     INTO pn_codvivienda FROM sngc13 s 
              WHERE S.SNGC13PAIS  = vi_pais
                and S.SNGC13TDOC  = vi_petdoc
                and S.SNGC13NDOC  = vi_pendoc
                and S.docod       = 1 
                and S.sngc13est   = 'H' 
                and s.sngc13corr  = 
                  (select max(sngc13corr) from sngc13 ss 
                  where ss.SNGC13PAIS  = vi_pais
                    and ss.SNGC13TDOC  = vi_petdoc
                    and ss.SNGC13NDOC  = vi_pendoc 
                    and ss.docod=1 and ss.sngc13est='H');
            EXCEPTION WHEN OTHERS THEN              
                pn_codvivienda := 0;
            END;
            --Buscar la descripcion del segmento por la guia  
            BEGIN   
              SELECT tp1nro1 into pn_codsegment FROM fst198 
                     WHERE tp1cod = 1 AND tp1cod1 = 11161 AND tp1corr1 = 6 
                       AND tp1corr2 = 0 AND tp1corr3 > 9
                       AND tp1desc = upper(rpad(pv_dessegment, 30, ' '));
            EXCEPTION WHEN OTHERS THEN
                 pn_codsegment := 0;
            END;   
            --Buscar codigo de segmento
            BEGIN   
              SELECT tp1nro1 INTO pn_codsegment_incl FROM fst198 
                     WHERE tp1cod1 = 11161 AND tp1corr1 = 7 
                       AND tp1corr2 = 0 AND tp1corr3 > 0 
                       AND tp1nro2 = pn_codvivienda AND tp1nro3 = pn_codsegment;
              --Obtener el tipo de operacion
              SELECT tp1nro1 INTO pn_tipo_inclusivo FROM fst198 
                     WHERE tp1cod1 = 11161 AND tp1corr1 = 7 
                       AND tp1corr2 = 1 AND tp1corr3 > 0 
                       AND tp1imp1 < vi_tipoperacion AND tp1imp2 > vi_tipoperacion;            
            EXCEPTION WHEN OTHERS THEN
                 pn_codsegment_incl := 0;
                 pn_tipo_inclusivo := 0;
            END;    
            ----Obtener el tarifario
            BEGIN
               SELECT tp1imp1 into P_OutTasa FROM fst198
                      WHERE tp1cod1 = 11161 AND tp1corr1 = 7 
                        AND tp1corr2 = 2 AND tp1corr3 > 0 
                        AND tp1nro1 = pn_tipo_inclusivo AND tp1nro2 = pn_codsegment_incl;
            EXCEPTION WHEN OTHERS THEN
               P_OutTasa := 400;
            END;
        ELSE
          P_OutTasa := 400;
        END IF; 
        
        --LOG DE CALCULO DE TASA
        BEGIN
        SELECT COUNT(*) INTO VI_EXISTE FROM fst198 
                   WHERE tp1cod = 1 AND tp1cod1 = 11161 AND tp1corr1 = 31 
                     AND tp1corr2 = 0 AND tp1corr3 > 0
                     AND TP1NRO1 = vi_modulo
                     AND TP1NRO2 = vi_tipoperacion;
                     
        EXCEPTION 
          WHEN OTHERS THEN
            VI_EXISTE := 0;
        END; 
        IF VI_EXISTE > 0 THEN            
              begin
                  INSERT INTO AQPB980(
                  AQPB980INST,
                  AQPB980DSEG,
                  AQPB980CSEG,
                  AQPB980TPZL,
                  AQPB980GRPO,
                  AQPB980MNTO,
                  AQPB980TASA
                   ) VALUES (P_InInstancia,pv_dessegment,pn_codsegment,pn_tarifario,pn_grupo,vi_monto,P_OutTasa);
                   commit;
              exception
                when others then
                null;        
              end;
        END IF;
  END SP_CR_TASA_TARIFARIO;

end PQ_CR_REDUCCION_TASA_CAMPANA;
/

