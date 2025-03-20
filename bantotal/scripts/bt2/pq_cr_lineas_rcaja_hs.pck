create or replace package pQ_CR_LINEAS_RCAJA_HS is

  -- Author  : HSUAREZ
  -- Created : 7/12/2021 10:03:33
  -- Purpose : Paquete para el Panel de Autorizacion de Reprogramacion de Lineas en el Flujo
  -- Author  : HSUAREZ
  -- Modified : 04/01/2022 10:03:33
  -- Purpose : Se agrego Tasa, para la facilidad Amortización Anticipada.
 PROCEdURE SP_CARGAR_LISTA;
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
end pQ_CR_LINEAS_RCAJA_HS;
/

create or replace package body pQ_CR_LINEAS_RCAJA_HS is

procedure SP_CARGAR_LISTA IS
CURSOR LISTA_BI IS

       SELECT * FROM AQPB904A;
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
       
       vi_aqpb904acod xwf700.xwfempresa%type;
       vi_aqpb904amod xwf700.xwfmodulo%type;
       vi_aqpb904asuc xwf700.xwfsucursal%type;
       vi_aqpb904amda xwf700.xwfmoneda%type;
       vi_aqpb904apap xwf700.xwfpapel%type;
       vi_aqpb904acta xwf700.xwfcuenta%type;
       vi_aqpb904aoper xwf700.xwfoperacion%type;
       vi_aqpb904asbop xwf700.xwfsubope%type;
       vi_aqpb904atope xwf700.xwftipope%type;
    BEGIN   
       --CARGAR LOS REGISTROS EN NUESTRA TABLA
       
       BEGIN
              for j in lista_bi loop
                VI_INSTANCIA := 0;
                V_PRC := 'UPD';
                vi_aqpb904acod:= 0;
                vi_aqpb904amod:= 0;
                vi_aqpb904asuc:= 0;
                vi_aqpb904amda:= 0;
                vi_aqpb904apap:= 0;
                vi_aqpb904acta:= 0;
                vi_aqpb904aoper:= 0;
                vi_aqpb904asbop:=0;
                vi_aqpb904atope:= 0;
                VI_TASA_ORI:=99;
                VI_CORRELATIVO:= 0;
                VI_TASAORI:= 0;
                vo_DeudaTotal:= 0;                                  
                BEGIN
                  SELECT A.AQPB904INS,A.AQPB904CORR,A.AQPB904TORI
                  INTO VI_INSTANCIA,VI_CORRELATIVO,VI_TASAORI
                  FROM AQPB904 A
                  WHERE A.AQPB904INS = J.AQPB904AINS                  
                  --AND A.AQPB904CORR = J.AQPB904ACORR
                  AND ROWNUM = 1;
                EXCEPTION 
                  WHEN OTHERS THEN
                    V_PRC := 'INS';
                    VI_INSTANCIA :=  J.AQPB904AINS;
                END;
                
                IF VI_INSTANCIA > 0 AND V_PRC = 'INS' THEN
                   vi_deudaTotal := 0;
                   vi_deudaTotal := j.AQPB904aDEUT;
                   --OBTENER DEUDA TOTAL VIVA
                   pq_cr_lineas_rcaja_hs.OBTENER_CLAVE_LINEA_UTILIZADA(j.aqpb904acod,j.aqpb904amod,j.aqpb904asuc,
                                                                       j.aqpb904amda,j.aqpb904apap,j.aqpb904acta,
                                                                       j.aqpb904aoper,j.aqpb904asbop,j.aqpb904atope,
                                                                       vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                                                                       vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                                                                       vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope
                   );
                   --OBTENER TASA ORIGEN
                   pq_cr_reprog_caja.sp_cr_tasa(vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                                                                   vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                                                                   vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope,
                                                                   VI_TASA_ORI);
                   IF VI_TASAORI > VI_TASA_ORI THEN
                      VS_TASA_ORI := VI_TASA_ORI;
                   ELSE
                      VS_TASA_ORI := VI_TASA_ORI;   
                   END IF;                                               
                   --OBTENER DEUDA VIVA
                    PQ_CR_LINEAS_RCAJA_HS.OBTENER_DEUDAVIVA_TOT(VI_INSTANCIA,vo_DeudaTotal); 
                   /*
                   PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_deuda_viva_credito(
                                                                   vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                                                                   vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                                                                   vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope,
                   
                   --OBTNER SALDO CAPITAL TOTAL                                                                   vo_DeudaTotal,vo_rpta); */

                   PQ_CR_LINEAS_RCAJA_HS.OBTENER_EL_SALDO_CAPITAL_TOT(VI_INSTANCIA,vi_SaldoCapital); 
                                                                   
                   IF (vi_deudaTotal < vo_DeudaTotal AND vo_DeudaTotal<> 0) OR vi_deudaTotal=0 OR vI_DeudaTotal is null  THEN
                      if vo_DeudaTotal > 0 then 
                         vi_deudaTotal := vo_DeudaTotal;                                             
                      end if;                                             
                   END IF;  
                   --OBTENER DEUDA TOTAL DEL CREDITO.
                   
                   
                   INSERT 
                   INTO AQPB904 (
                                 aqpb904corr ,aqpb904ins ,aqpb904cod ,
                                 aqpb904mod  ,aqpb904suc ,aqpb904mda ,
                                 aqpb904pap  ,aqpb904cta ,aqpb904oper,
                                 aqpb904sbop ,aqpb904tope,aqpb904pais,
                                 aqpb904tdoc ,aqpb904docu,aqpb904nomb,
                                 aqpb904esta ,aqpb904ehab, aqpb904mcap,--aqpb904usur ,aqpb904fecr,aqpb904hora
                                 aqpb904situ, aqpb904deut,AQPB904TORI,AQPB904SCAPT,AQPB904GRUP
                                )
                         VALUES (
                                  j.aqpb904acorr,j.aqpb904ains,j.aqpb904acod,
                                  j.aqpb904amod,j.aqpb904asuc,j.aqpb904amda,
                                  j.aqpb904apap,j.aqpb904acta,j.aqpb904aoper,
                                  j.aqpb904asbop,j.aqpb904atope,j.aqpb904apais,
                                  j.aqpb904atdoc,j.aqpb904adocu,j.aqpb904ancli,
                                  'P','H',j.aqpb904amcap,j.aqpb904asitu,vi_deudaTotal,VS_TASA_ORI,vi_SaldoCapital,j.aqpb904agrup
                                );                   
                     commit;
                END IF;
                
                IF VI_INSTANCIA > 0 AND V_PRC = 'UPD' THEN
                   /*IF VI_INSTANCIA = 4488950 THEN
                      NULL;
                   END IF;*/
                   vi_deudaTotal := j.AQPB904aDEUT;
                   pq_cr_lineas_rcaja_hs.OBTENER_CLAVE_LINEA_UTILIZADA(j.aqpb904acod,j.aqpb904amod,j.aqpb904asuc,
                                                                       j.aqpb904amda,j.aqpb904apap,j.aqpb904acta,
                                                                       j.aqpb904aoper,j.aqpb904asbop,j.aqpb904atope,
                                                                       vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                                                                       vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                                                                       vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope
                   );
                   --OBTENER TASA ORIGEN
                   pq_cr_reprog_caja.sp_cr_tasa(vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                                                                   vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                                                                   vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope,
                                                                   VI_TASA_ORI);
                   IF VI_TASAORI > VI_TASA_ORI THEN
                      VS_TASA_ORI := VI_TASA_ORI;
                   ELSE
                      VS_TASA_ORI := VI_TASA_ORI;   
                   END IF;                                                                    
                   --OBTENER DEUDA VIVA
                    PQ_CR_LINEAS_RCAJA_HS.OBTENER_DEUDAVIVA_TOT(VI_INSTANCIA,vo_DeudaTotal); 
                   
                                                                                      
                   --OBTNER SALDO CAPITAL TOTAL
                   PQ_CR_LINEAS_RCAJA_HS.OBTENER_EL_SALDO_CAPITAL_TOT(VI_INSTANCIA,vi_SaldoCapital);
                     
                   IF (vi_deudaTotal > vo_DeudaTotal AND vo_DeudaTotal<> 0) OR vi_deudaTotal=0 OR vI_DeudaTotal is null  THEN
                      if vo_DeudaTotal > 0 then 
                         vi_deudaTotal := vo_DeudaTotal;                                             
                      end if;
                   END IF;  
                     
                 UPDATE AQPB904 T
                 SET T.AQPB904DEUT = vi_deudaTotal,
                     T.AQPB904SCAPT = vi_SaldoCapital,
                     t.AQPB904TORI = VS_TASA_ORI,
                     t.aqpb904grup = j.aqpb904agrup
                 WHERE T.aqpb904corr = VI_CORRELATIVO
                   AND T.AQPB904INS  = J.AQPB904AINS
                   AND T.AQPB904ESTA = 'P'
                   AND T.AQPB904EHAB = 'H';
                   COMMIT;
                END IF;
                
              end loop; 
         END;
    END;

procedure SP_CARGAR_LISTA(ve_suc number,ve_fecha date) IS
CURSOR LISTA_BI IS

       SELECT * FROM AQPB904A  X where X.AQPB904ASUC=ve_suc ;
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
       
       vi_aqpb904acod xwf700.xwfempresa%type;
       vi_aqpb904amod xwf700.xwfmodulo%type;
       vi_aqpb904asuc xwf700.xwfsucursal%type;
       vi_aqpb904amda xwf700.xwfmoneda%type;
       vi_aqpb904apap xwf700.xwfpapel%type;
       vi_aqpb904acta xwf700.xwfcuenta%type;
       vi_aqpb904aoper xwf700.xwfoperacion%type;
       vi_aqpb904asbop xwf700.xwfsubope%type;
       vi_aqpb904atope xwf700.xwftipope%type;
    BEGIN   
       --CARGAR LOS REGISTROS EN NUESTRA TABLA
       
       BEGIN
              for j in lista_bi loop
                VI_INSTANCIA := 0;
                V_PRC := 'UPD';
                vi_aqpb904acod:= 0;
                vi_aqpb904amod:= 0;
                vi_aqpb904asuc:= 0;
                vi_aqpb904amda:= 0;
                vi_aqpb904apap:= 0;
                vi_aqpb904acta:= 0;
                vi_aqpb904aoper:= 0;
                vi_aqpb904asbop:=0;
                vi_aqpb904atope:= 0;
                VI_TASA_ORI:=99;
                VI_CORRELATIVO:= 0;
                VI_TASAORI:= 0;
                vo_DeudaTotal:= 0;                                  
                BEGIN
                  SELECT A.AQPB904INS,A.AQPB904CORR,A.AQPB904TORI,A.AQPB904DEUTF,A.AQPB904FECM,A.AQPB904ESTA
                  INTO VI_INSTANCIA,VI_CORRELATIVO,VI_TASAORI,VI_DEUDA_AFEC,VI_FEC_GESTION,VE_EGESTION
                  FROM AQPB904 A
                  WHERE A.AQPB904INS = J.AQPB904AINS
                  AND A.AQPB904EHAB = 'H'
                  --AND A.AQPB904CORR = J.AQPB904ACORR
                  AND ROWNUM = 1;
                EXCEPTION 
                  WHEN OTHERS THEN
                    V_PRC := 'INS';
                    VI_INSTANCIA :=  J.AQPB904AINS;
                END;
                
                IF VI_INSTANCIA > 0 AND V_PRC = 'INS' THEN
                   vi_deudaTotal := 0;
                   vi_deudaTotal := j.AQPB904aDEUT;
                   --OBTENER DEUDA TOTAL VIVA
                   pq_cr_lineas_rcaja_hs.OBTENER_CLAVE_LINEA_UTILIZADA(j.aqpb904acod,j.aqpb904amod,j.aqpb904asuc,
                                                                       j.aqpb904amda,j.aqpb904apap,j.aqpb904acta,
                                                                       j.aqpb904aoper,j.aqpb904asbop,j.aqpb904atope,
                                                                       vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                                                                       vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                                                                       vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope
                   );
                   --OBTENER TASA ORIGEN
                   pq_cr_reprog_caja.sp_cr_tasa(vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                                                                   vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                                                                   vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope,
                                                                   VI_TASA_ORI);
                   IF VI_TASAORI > VI_TASA_ORI THEN
                      VS_TASA_ORI := VI_TASA_ORI;
                   ELSE
                      VS_TASA_ORI := VI_TASA_ORI;   
                   END IF;                                               
                   --OBTENER DEUDA VIVA
                   PQ_CR_LINEAS_RCAJA_HS.OBTENER_DEUDAVIVA_TOT(VI_INSTANCIA,vo_DeudaTotal); 
                   PQ_CR_LINEAS_RCAJA_HS.OBTENER_EL_SALDO_CAPITAL_TOT(VI_INSTANCIA,vi_SaldoCapital); 
                                                                   
                   --IF (vi_deudaTotal < vo_DeudaTotal AND vo_DeudaTotal<> 0) OR vi_deudaTotal=0 OR vI_DeudaTotal is null  THEN
                      if vo_DeudaTotal > 0 then 
                         vi_deudaTotal := vo_DeudaTotal;                                             
                      end if;                                             
                   --END IF;  
                   --OBTENER DEUDA TOTAL DEL CREDITO.
                   
                   
                   INSERT 
                   INTO AQPB904 (
                                 aqpb904corr ,aqpb904ins ,aqpb904cod ,
                                 aqpb904mod  ,aqpb904suc ,aqpb904mda ,
                                 aqpb904pap  ,aqpb904cta ,aqpb904oper,
                                 aqpb904sbop ,aqpb904tope,aqpb904pais,
                                 aqpb904tdoc ,aqpb904docu,aqpb904nomb,
                                 aqpb904esta ,aqpb904ehab, aqpb904mcap,--aqpb904usur ,aqpb904fecr,aqpb904hora
                                 aqpb904situ, aqpb904deut,AQPB904TORI,AQPB904SCAPT,AQPB904GRUP,AQPB904FECM
                                )
                         VALUES (
                                  j.aqpb904acorr,j.aqpb904ains,j.aqpb904acod,
                                  j.aqpb904amod,j.aqpb904asuc,j.aqpb904amda,
                                  j.aqpb904apap,j.aqpb904acta,j.aqpb904aoper,
                                  j.aqpb904asbop,j.aqpb904atope,j.aqpb904apais,
                                  j.aqpb904atdoc,j.aqpb904adocu,j.aqpb904ancli,
                                  'P','H',j.aqpb904amcap,j.aqpb904asitu,vi_deudaTotal,VS_TASA_ORI,vi_SaldoCapital,j.aqpb904agrup,
                                  ve_fecha
                                );                   
                     commit;
                END IF;
                
                IF VI_INSTANCIA > 0 AND V_PRC = 'UPD' THEN
                   /*IF VI_INSTANCIA = 8136792 THEN
                      NULL;
                   END IF;*/
                   vi_deudaTotal := j.AQPB904aDEUT;
                   pq_cr_lineas_rcaja_hs.OBTENER_CLAVE_LINEA_UTILIZADA(j.aqpb904acod,j.aqpb904amod,j.aqpb904asuc,
                                                                       j.aqpb904amda,j.aqpb904apap,j.aqpb904acta,
                                                                       j.aqpb904aoper,j.aqpb904asbop,j.aqpb904atope,
                                                                       vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                                                                       vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                                                                       vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope
                   );
                   --OBTENER TASA ORIGEN
                   pq_cr_reprog_caja.sp_cr_tasa(vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                                                                   vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                                                                   vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope,
                                                                   VI_TASA_ORI);
                   IF VI_TASAORI > VI_TASA_ORI THEN
                      VS_TASA_ORI := VI_TASA_ORI;
                   ELSE
                      VS_TASA_ORI := VI_TASA_ORI;   
                   END IF;                                                                    
                   --OBTENER DEUDA VIVA
                    PQ_CR_LINEAS_RCAJA_HS.OBTENER_DEUDAVIVA_TOT(VI_INSTANCIA,vo_DeudaTotal);  
                   --OBTNER SALDO CAPITAL TOTAL
                   PQ_CR_LINEAS_RCAJA_HS.OBTENER_EL_SALDO_CAPITAL_TOT(VI_INSTANCIA,vi_SaldoCapital);
                     
                   /*IF (vi_deudaTotal > vo_DeudaTotal AND vo_DeudaTotal<> 0) OR vi_deudaTotal=0 OR vI_DeudaTotal is null  THEN*/
                      if vo_DeudaTotal > 0 then 
                         vi_deudaTotal := vo_DeudaTotal;                                             
                      end if;
                   /*END IF;  */
                 --ACTUALIZAMOS LA AQPB904 LA GESTION    
                 UPDATE AQPB904 T
                 SET T.AQPB904DEUT = vi_deudaTotal,
                     T.AQPB904SCAPT = vi_SaldoCapital,
                     t.AQPB904TORI = VS_TASA_ORI,
                     t.aqpb904grup = j.aqpb904agrup
                 WHERE T.aqpb904corr = VI_CORRELATIVO
                   AND T.AQPB904INS  = J.AQPB904AINS
                   AND T.AQPB904ESTA = 'P'
                   AND T.AQPB904EHAB = 'H';
                   COMMIT;
                 
                END IF;
                --VALIDAR REGISTROS YA GESTIONADOS --PARA VOLVER A HABILITAR, SOLO EN CASO NO HAYAN SIDO CANCELADOS.
                BEGIN
                      --VI_DEUDA_AFEC;
                      --VI_FEC_GESTION;
                      vo_cancel := 'S';
                      --VALIDAR  SI EL CREDITO FUE CANCELADO
                      PQ_CR_LINEAS_RCAJA_HS.SP_VALIDAR_CANCEL(vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                                                              vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                                                              vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope,vo_cancel);
                      IF VO_CANCEL = 'N' AND (VE_EGESTION = 'G' OR VE_EGESTION = 'D') AND to_date(VI_FEC_GESTION,'dd/mm/yyyy') < to_date(ve_fecha,'dd/mm/yyyy')  THEN --SI NO FUE CANCELADO Y YA SE REALIZO LA GESTION DEL CREDITO INHABILITAR EL REGISTRO GESTIONADO Y HABILITAR UNO NUEVO.                      
                       /*IF VI_INSTANCIA = 7949977 THEN
                           DBMS_OUTPUT.put_line('VO_CANCEL:' || VO_CANCEL);
                           DBMS_OUTPUT.put_line('VI_FEC_GESTION:' || VI_FEC_GESTION);
                           DBMS_OUTPUT.put_line('ve_fecha:' || ve_fecha);
                       END IF;*/
                      --INHABILITAMOS EL REGISTRO GESTIONADO
                        UPDATE AQPB904 T
                           SET T.AQPB904EHAB = 'I'
                         WHERE T.aqpb904corr = VI_CORRELATIVO
                           AND T.AQPB904INS  = J.AQPB904AINS
                           AND T.AQPB904ESTA IN ('G','D')
                           AND T.AQPB904EHAB = 'H';
                          
                        --EN CASO DE AUTORIZACION EXTERNA ACTUALIZAMOS TAMBIEN LA AQPB953  
                         UPDATE AQPB953 B9
                         SET B9.AQPB953EHAB = 'I'
                         WHERE B9.AQPB953INST = J.AQPB904AINS
                           AND B9.AQPB953EHAB = 'H';
                           COMMIT;    
                      --INSERTAMOS NUEVO REGISTRO
                      begin
                           INSERT 
                             INTO AQPB904 (
                                           aqpb904corr ,aqpb904ins ,aqpb904cod ,
                                           aqpb904mod  ,aqpb904suc ,aqpb904mda ,
                                           aqpb904pap  ,aqpb904cta ,aqpb904oper,
                                           aqpb904sbop ,aqpb904tope,aqpb904pais,
                                           aqpb904tdoc ,aqpb904docu,aqpb904nomb,
                                           aqpb904esta ,aqpb904ehab, aqpb904mcap,--aqpb904usur ,aqpb904fecr,aqpb904hora
                                           aqpb904situ, aqpb904deut,AQPB904TORI,AQPB904SCAPT,AQPB904GRUP,AQPB904FECM
                                          )
                                   VALUES (
                                            j.aqpb904acorr,j.aqpb904ains,j.aqpb904acod,
                                            j.aqpb904amod,j.aqpb904asuc,j.aqpb904amda,
                                            j.aqpb904apap,j.aqpb904acta,j.aqpb904aoper,
                                            j.aqpb904asbop,j.aqpb904atope,j.aqpb904apais,
                                            j.aqpb904atdoc,j.aqpb904adocu,j.aqpb904ancli,
                                            'P','H',j.aqpb904amcap,j.aqpb904asitu,vi_deudaTotal,VS_TASA_ORI,vi_SaldoCapital,j.aqpb904agrup,
                                            ve_fecha
                                          );                   
                               COMMIT;
                      end;   
                      END IF;  
                END;                 
              end loop; 
         END;
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
       PQ_CR_LINEAS_RCAJA_HS.SP_CARGAR_CLV_LCRD(VE_CORRELATIVO,VE_INSTANCIA,
                                                VI_PGCOD,
                                                VI_AOMOD,
                                                VI_AOSUC,
                                                VI_AOPAP,
                                                VI_AOMDA,
                                                VI_AOCTA,
                                                VI_AOOPER,
                                                VI_AOSBOP,
                                                VI_AOTOPE                                            
                                               );
       IF VE_FACILIDAD_COD = 6 OR VE_FACILIDAD_COD = 7 THEN
          BEGIN
             TASA_ORI := 999; --INICIALIZO VARIABLE 04.01.2022
             --CARGAR SALDO --- INCLUYO PROCESO PARA OBTENR EL SALDO CAPITAL Y LA TASA ORIGINAL 04.01.2022
             BEGIN
                   --SELECT A.AQPB904SCAPT,A.AQPB904TORI CAMBIO A SOLICITUD DE NEGOCIO
                   SELECT A.AQPB904DEUTF,A.AQPB904TORI
                   INTO SALDO_CAPITAL_T,TASA_ORI
                   FROM AQPB904 A 
                   WHERE A.AQPB904CORR = VE_CORRELATIVO
                     AND A.AQPB904INS = VE_INSTANCIA
                     AND A.AQPB904ESTA = 'P'
                     AND A.AQPB904EHAB = 'H';
             EXCEPTION
                  WHEN OTHERS THEN
                       SALDO_CAPITAL_T := 9999999;              
             END;
                
             UPDATE AQPB904 A SET
             A.AQPB904FACI = VE_FACILIDAD_DESC,
             A.AQPB904ESTA = VE_GESTION,
             A.AQPB904EHAB = 'H',
             A.AQPB904PRAP = VE_PRC_DESC,
             A.AQPB904MNTD = VE_MONTO_DESC,
             A.AQPB904IMP  = VE_SALDOCAP,
             A.AQPB904CFACI= VE_FACILIDAD_COD,
             --A.AQBP904TRED = VE_TASA_RED,
             A.AQPB904TORI = VE_TASA_ORI,
             A.AQPB904USUR = VE_UBUSER,
             A.AQPB904CARG = VE_CARGO,
             A.AQPB904FECR = TO_DATE(SYSDATE,'DD/MM/YYYY'),
             A.AQPB904HORA = TO_CHAR(SYSDATE,'HH:MI:ss'),            
             A.AQPB904FECM = TO_DATE(VE_FECHA,'dd/MM/yyyy') --NUEVO
             WHERE A.AQPB904CORR = VE_CORRELATIVO
               AND A.AQPB904INS = VE_INSTANCIA
               AND A.AQPB904ESTA = 'P'
               AND A.AQPB904EHAB = 'H';
             COMMIT;
             IF TRIM(VE_GESTION) = 'G' THEN
                        PQ_CR_LINEAS_RCAJA_HS.SP_CARGAR_TASA_CUENTA(
                                                            VI_PGCOD ,
                                                            VI_AOMOD ,
                                                            VI_AOSUC ,
                                                            VI_AOMDA ,
                                                            VI_AOPAP ,
                                                            VI_AOCTA ,
                                                            VI_AOOPER ,
                                                            VI_AOSBOP ,
                                                            VI_AOTOPE ,
                                                            TASA_ORI ,
                                                            VI_FECHA_SISTEMA,
                                                            --TO_DATE(SYSDATE,'DD/MM/YYYY'),
                                                            SALDO_CAPITAL_T,--PN_SALDO ,
                                                            9999,
                                                            VE_UBUSER
                                                            );--PN_PZO);  
             END IF;  
           EXCEPTION
             WHEN OTHERS THEN
               NULL;  
           END;
              
       ELSE
           IF VE_FACILIDAD_COD = 1 OR VE_FACILIDAD_COD = 5 THEN
            BEGIN
              /*
                BEGIN
                    SELECT PGFAPE
                    INTO VI_FECHA_SISTEMA
                    FROM FST017
                    WHERE PGCOD=1;
                END;
                */
                --CARGAR SALDO
                BEGIN
                   --SELECT A.AQPB904SCAPT CAMBIO A SOLICITUD DE NEGOCIO
                   SELECT A.AQPB904DEUTF
                   INTO SALDO_CAPITAL_T
                   FROM AQPB904 A 
                   WHERE A.AQPB904CORR = VE_CORRELATIVO
                     AND A.AQPB904INS = VE_INSTANCIA
                     AND A.AQPB904ESTA = 'P'
                     AND A.AQPB904EHAB = 'H';
                EXCEPTION
                  WHEN OTHERS THEN
                       SALDO_CAPITAL_T := 999999;              
                END;
                BEGIN
                    UPDATE AQPB904 A SET
                    A.AQPB904FACI = VE_FACILIDAD_DESC,
                    A.AQPB904ESTA = VE_GESTION,
                    A.AQPB904EHAB = 'H',
                    A.AQPB904PRAP = VE_PRC_DESC,
                    --A.AQPB904MNTD = VE_MONTO_DESC,
                    A.AQPB904CFACI= VE_FACILIDAD_COD,
                    A.AQPB904TRED = VE_TASA_RED, 
                    A.AQPB904TORI = VE_TASA_ORI,
                    A.AQPB904USUR = VE_UBUSER,
                    A.AQPB904CARG = VE_CARGO,
                    A.AQPB904FECR = TO_DATE(SYSDATE,'DD/MM/YYYY'),
                    A.AQPB904HORA = TO_CHAR(SYSDATE,'HH:MI:ss'),            
                    A.AQPB904FECM = TO_DATE(VE_FECHA,'dd/MM/yyyy') --NUEVO
                    WHERE A.AQPB904CORR = VE_CORRELATIVO
                    AND A.AQPB904INS = VE_INSTANCIA
                    AND A.AQPB904ESTA = 'P'
                    AND A.AQPB904EHAB = 'H';
                    COMMIT; 
                    IF TRIM(VE_GESTION) = 'G' THEN
                        PQ_CR_LINEAS_RCAJA_HS.SP_CARGAR_TASA_CUENTA(
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
                                                            SALDO_CAPITAL_T,--PN_SALDO ,
                                                            9999,
                                                            VE_UBUSER
                                                            );--PN_PZO);  
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
           end if;  
       END IF;    
       commit;
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
           /*
           BEGIN
             IF UPPER(x.MENSAJEAUTONOMIA) LIKE '%CONTROL%' THEN--'Se necesita aprobación de Control de créditos' THEN
                vi_cargo:=215;
             END IF;
             IF UPPER(x.MENSAJEAUTONOMIA) LIKE '%ANALISTA%' THEN--'dentro de la autonomía del analista' THEN
                vi_cargo:=200;
                vi_estado := 'A';
             END IF;
             IF UPPER(x.MENSAJEAUTONOMIA) LIKE '%GERENTE DE AGENCIA%' THEN --'Se necesita aprobación de Gerente de agencia' THEN
                vi_cargo:=202;
             END IF;
             IF UPPER(x.MENSAJEAUTONOMIA) LIKE '%GERENTE REGIONAL%' THEN --'Se necesita aprobación de Gerente regional' THEN
                vi_cargo:=220;
             END IF;
             IF UPPER(x.MENSAJEAUTONOMIA) LIKE '%GERENCIA DE CR%' THEN--'Se necesita aprobación de Gerencia de Créditos' THEN
                vi_cargo:=230;
             END IF;
             IF UPPER(x.MENSAJEAUTONOMIA) LIKE '%SE NECESITA APROBACION DE GERENTE CENTRAL DE NEGOCIOS%' THEN--'Se necesita aprobación de Gerencia de Créditos' THEN
                vi_cargo:=240;
             END IF;
             END;  
           */ 
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
            
                                                                              
           --INVERTAMOS REGISRO
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
              /*IF VI_INSTANCIA = 4488950 THEN
                      NULL;
              END IF;*/
                   
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
                             AND    A.AQPB953MOD =x.MODULO
                            AND     A.AQPB953MDA =x.MONEDA
                            AND     A.AQPB953PAP =x.PAPEL
                             AND    A.AQPB953CTA =x.CUENTA
                             AND    A.AQPB953OPER=x.OPERACION
                             AND    A.AQPB953SUC =x.SUCURSAL
                              AND   A.AQPB953SBOP=x.SUBOPERACION
                              AND   A.AQPB953TOP =x.TIPOOPERACION
                              AND   A.AQPB953INST=vi_instancia
                              AND   A.AQPB953FCRM=x.FECHAENBANTOTAL
                              AND   A.AQPB953EHAB='H'
                             AND    A.AQPB953EST ='P';
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
          UPDATE AQPB953 A
             SET A.AQPB953EST  = ve_est,
                 A.AQPB953USRM = ve_user,
                 A.AQPB953FECM = SYSDATE,
                 A.AQPB953FECC = SYSDATE,
                 A.AQPB953COM = VE_CMT
           WHERE AQPB953COD = ve_cod;
          ve_msj := 'Se han aplicado los cambios';
        EXCEPTION
          WHEN OTHERS THEN
            ve_msj := 'No se han podido aplicar los cambios, consulte al administrador';
        end;
        BEGIN
               select l.AQPB953EMP, l.AQPB953MOD, l.AQPB953SUC, l.AQPB953MDA, l.AQPB953PAP, l.AQPB953CTA, l.AQPB953OPER, l.AQPB953SBOP, l.AQPB953TOP,l.AQPB953fcrm,l.aqpb953tredu,l.AQPB953TASAACT,
                      l.aqpb953cfac,l.AQPB953SCAPT              
                      /*l.AQPB953cta,
                      l.AQPB953oper,
                      l.AQPB953sbop,
                      l.AQPB953top,
                      l.AQPB953fcrm
                      */
               into VI_PGCOD,VI_AOMOD,VI_AOSUC,VI_AOMDA,VI_AOPAP,VI_AOCTA,VI_AOOPER,VI_AOSBOP,VI_AOTOPE, vi_fecha,vi_tasa_redu,vi_tasa_ori,vi_cfacilidad,vi_saldo
               from AQPB953 l where AQPB953cod= ve_cod;
               
        END; 
        if ve_est = 'R' then
           BEGIN
               select L.AQPB904CORR
               INTO COD_CRM
               FROM AQPB904 L     
               where L.AQPB904CTA = VI_AOCTA
                 AND L.AQPB904OPER = VI_AOOPER
                 AND TRUNC(L.AQPB904FECR) = vi_fecha;
           exception
             when others then
               null;
           END;   
           --/* descomentar para pase 14.08.2021
           UPDATE AQPB904 A SET A.AQPB904ESTA= 'P', A.AQPB904EHAB='H'
           where A.AQPB904CORR = COD_CRM  AND A.AQPB904ESTA='D' AND A.AQPB904EHAB='H';   
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
             select L.AQPB904CORR
             INTO COD_CRM
             FROM AQPB904 L     
             where L.AQPB904CTA = VI_AOCTA
               AND L.AQPB904OPER = VI_AOOPER
               AND TRUNC(L.AQPB904FECR) = vi_fecha;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;       
           --/* descomentar para pase 14.08.2021
           UPDATE AQPB904 A SET A.AQPB904ESTA= 'G', A.AQPB904EHAB='H'
           where A.AQPB904CORR = COD_CRM  AND A.AQPB904ESTA='D' AND A.AQPB904EHAB='H'; 
           --CARGAR TASA SIO ES REDUCCION DE TASA Y SE AUTORIZA
           BEGIN
             if vi_cfacilidad = 1 then  
                 IF vi_saldo = 0 OR vi_saldo is null THEN             
                    vi_saldo:= 99999999;
                 END IF;
                 pq_cr_lineas_rcaja_HS.SP_CARGAR_TASA_CUENTA(
                  VI_PGCOD,VI_AOMOD,VI_AOSUC,VI_AOMDA,VI_AOPAP,VI_AOCTA,VI_AOOPER,VI_AOSBOP,VI_AOTOPE,
                  vi_tasa_redu,VI_FECHA_SISTEMA,vi_saldo,999,ve_user);
             end if; 
             --ve_msj := 'Se han aplicado los cambios';
             if vi_cfacilidad = 7 then  
                 IF vi_saldo = 0 OR vi_saldo is null THEN             
                    vi_saldo:= 99999999;
                 END IF;
                 pq_cr_lineas_rcaja_HS.SP_CARGAR_TASA_CUENTA(
                  VI_PGCOD,VI_AOMOD,VI_AOSUC,VI_AOMDA,VI_AOPAP,VI_AOCTA,VI_AOOPER,VI_AOSBOP,VI_AOTOPE,
                  vi_tasa_ori,VI_FECHA_SISTEMA,vi_saldo,999,ve_user);
             end if; 
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
  BEGIN
    --OBTENER PIZARRA
    --149 PIZARRA DEFINIDA A UTILIZAR, SE PUEDE OBTENER DE LA FPP028
    BEGIN
      SELECT pp028defn
      INTO  VI_PIZARRA
      FROM FPP028 F
      WHERE F.PP028MOD = 101 --FIJO
        AND F.PP028TOP = 600 --FIJO
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
    
    vi_fec_invertida := 99999999 - to_number(to_char(pn_fec,'YYYYMMDD'));
    --grabar log
    
    --AGREGAR LOG DE REGISTRO, PARA VER LAS TASAS INGRESADAS DESDE ESTE MEDIO.
    BEGIN
        pq_cr_lineas_rcaja_hs.SP_RETIRAR_TASA(
              PN_EMP,PN_MOD,PN_SUC,PN_MDA,PN_PAP,PN_CTA,PN_OPE,PN_SBO,pn_top,pn_fec
        ); 
        commit;
    END;
    
    BEGIN
       INSERT INTO
               AQPB954 C ( C.AQPB954EMP,C.AQPB954MOD,C.AQPB954SUC,
                           C.AQPB954MDA,C.AQPB954PAP,C.AQPB954CTA,
                           C.AQPB954OPE,C.AQPB954SBO,C.AQPB954TOP,
                           C.AQPB954TCOD,C.AQPB954TMOD,C.AQPB954TPIZ,
                           C.AQPB954TCTA,C.AQPB954TMDA,C.AQPB954TPAP,
                           C.AQPB954TFDE,C.AQPB954TMTO,C.AQPB954TTAS,
                           C.AQPB954TPFI,C.AQPB954TPVI,
                           C.AQPB954FECR,C.AQPB954USUR,C.AQPB954TIPR,C.AQPB954TIPI) 
               VALUES (
                        PN_EMP,PN_MOD,PN_SUC,PN_MDA,PN_PAP,PN_CTA,PN_OPE,PN_SBO,PN_TOP,
                        PN_EMP,101,VI_PIZARRA,PN_CTA,PN_MDA,PN_PAP,PN_FEC,PN_SALDO,1,vi_fec_invertida,'S',
                        SYSDATE,PN_USER,0,'I'
                      );
               --commit;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        /*INSERT INTO PRUEBA_LOG(pgcod, 
                               aomod ,
                               aosuc ,
                               aomda ,
                               aopap ,
                               aocta ,
                               aooper,
                               aosbop,
                               aotope,
                               fecha,
                               msg
        ) values (PN_EMP,PN_MOD,PN_SUC,PN_MDA,PN_PAP,PN_CTA,PN_OPE,PN_SBO,PN_TOP,PN_FEC,'PRUEBA_AQPB954');*/
    END;
    ln_FlagTasa := 0;
    --GRABAR PRIMERA PIZARRA
    --FSD027
    --COLOCAR EL SALDO CAPITAL DEL CREDITO A OTORGAR LA TASA, LA FECHA DE INICIO DE VIGENCIA Y LA FECHA INVERTIDA
    --PROBAR CON FECHA 03/12/2021
    SELECT COUNT(*) INTO ln_FlagTasa FROM FSD027 
           WHERE MODULO = 101 AND CTNRO = PN_CTA AND TPIZAR = VI_PIZARRA AND TPFDES = PN_FEC;
    IF ln_FlagTasa = 0 THEN
      BEGIN        
          INSERT INTO
                  FSD027 A ( A.PGCOD,A.MODULO,A.TPIZAR,A.CTNRO,A.MONEDA,A.PAPEL,A.TPFDES,A.TPMTO,A.TPTTAS,A.TPFINV,A.TPVIG)
                  VALUES (
                           PN_EMP,101,VI_PIZARRA,PN_CTA,PN_MDA,PN_PAP,PN_FEC,PN_SALDO,1,vi_fec_invertida,'S'
                         );
                  --commit;
      EXCEPTION
        WHEN OTHERS THEN  
          BEGIN          
              UPDATE FSD027 A
              SET TPVIG = 'S',
                  TPMTO = PN_SALDO --NUEVO
              WHERE  A.PGCOD =  pn_emp
                AND  A.MODULO=  101
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
              AND  A.MODULO=  101
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
           WHERE MODULO = 101 AND CTNRO = PN_CTA AND TPIZAR = VI_PIZARRA AND TPFDES = PN_FEC;
    IF ln_FlagTasa = 0 THEN
      BEGIN
        INSERT INTO
               FSR027 B ( B.PGCOD,B.MODULO,B.TPIZAR,B.CTNRO,B.MONEDA,B.PAPEL,B.TPFDES,B.TPMTO,B.TPPZO,B.TPTASA)
               VALUES (
                        PN_EMP,101,VI_PIZARRA,PN_CTA,PN_MDA,PN_PAP,PN_FEC,PN_SALDO,99999,PN_TAS
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
              AND  A.MODULO=  101
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
        AND TP1COD1  = 10899
        AND TP1CORR1 = 400000
        AND TP1CORR2 = 511
        AND TP1CORR3 = 2;
    EXCEPTION 
      WHEN OTHERS THEN
        VI_DIAS_VIGENCIA := 30;    
    END;
    VI_FECV := PN_FEC + VI_DIAS_VIGENCIA;
    BEGIN
       INSERT INTO
               FSD327 B ( B.VT1PGCOD,B.VT1MOD,B.VT1TPIZ,B.VT1CTNR,B.VT1MON,B.VT1PAP,B.VT1TPFD,B.VT1FCHVEN)
               VALUES (
                        PN_EMP,101,VI_PIZARRA,PN_CTA,PN_MDA,PN_PAP,PN_FEC,VI_FECV
                      );
               --commit;
    EXCEPTION 
      WHEN OTHERS THEN           
        UPDATE FSD327 B
            SET B.VT1FCHVEN = VI_FECV
            WHERE B.VT1PGCOD = pn_emp
              AND B.VT1MOD = 101
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
           SELECT MAX(AQPB954TFDE) 
           INTO VI_FEC
           FROM AQPB954 A
           WHERE A.AQPB954TCOD = pn_emp
             AND A.AQPB954TMOD = 101
             AND A.AQPB954TCTA = pn_cta
             AND A.AQPB954TMDA = pn_mda
             AND A.AQPB954TPAP = pn_pap
             --AND A.AQPB954TFDE = VI_FEC 
             AND A.AQPB954TPVI = 'S';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          FLAG := 'N';       
      END;
      IF FLAG = 'S' THEN
      BEGIN
           SELECT a.aqpb954tpiz 
           INTO VI_PIZARRA
           FROM AQPB954 A
           WHERE A.AQPB954TCOD = pn_emp
             AND A.AQPB954TMOD = 101
             AND A.AQPB954TCTA = pn_cta
             AND A.AQPB954TMDA = pn_mda
             AND A.AQPB954TPAP = pn_pap
             AND A.AQPB954TFDE = VI_FEC 
             AND A.AQPB954TPVI = 'S';
       EXCEPTION
         WHEN OTHERS THEN
           NULL;      
       END;
        
      BEGIN
        SELECT A.PGCOD
        INTO VI_FLAG
        FROM FSD027 a
        WHERE  A.PGCOD =  pn_emp
          AND  A.MODULO=  101
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
            update AQPB954 A
            SET A.AQPB954TPVI = 'N'
           WHERE A.AQPB954TCOD = pn_emp
             AND A.AQPB954TMOD = 101
             AND A.AQPB954TCTA = pn_cta
             AND A.AQPB954TMDA = pn_mda
             AND A.AQPB954TPAP = pn_pap
             AND A.AQPB954TFDE = VI_FEC 
             AND A.AQPB954TPVI = 'S';
             commit;
             
            UPDATE FSD027 A
            SET TPVIG = 'N'
            WHERE  A.PGCOD =  pn_emp
              AND  A.MODULO=  101
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
              AND B.VT1MOD = 101
              AND B.VT1TPIZ= VI_PIZARRA
              AND B.VT1CTNR= pn_cta
              AND B.VT1MON = pn_mda
              AND B.VT1PAP = pn_pap
              AND B.VT1TPFD= VI_FEC;
              commit;
              
          /*
          ELSE
            UPDATE FSD027 A
               SET TPVIG = 'N'
             WHERE  A.PGCOD =  pn_emp
               AND  A.MODULO=  pn_mod
               AND  A.TPIZAR=  VI_PIZARRA
               AND  A.CTNRO =  pn_cta
               AND  A.MONEDA=  pn_mda
               AND  A.PAPEL =  pn_pap
               AND  A.TPVIG = 'S';
               VI_TIPOUPDREG := 2;
          */     
          END IF;
      END;
  --COLOCAR LOG DE RETIRO. DE LA TRANSACCION DE RETIRO
  BEGIN       
       BEGIN
             UPDATE AQPB954 AB
             SET AB.AQPB954FECM = SYSDATE,
                 AB.AQPB954TPVI = 'N'
             WHERE AB.AQPB954TCOD = pn_emp
             AND AB.AQPB954TMOD = 101
             AND AB.AQPB954TCTA = pn_cta
             AND AB.AQPB954TMDA = pn_mda
             AND AB.AQPB954TPAP = pn_pap
             AND AB.AQPB954TFDE = VI_FEC 
             AND AB.AQPB954TIPI = 'S';
       END;
       /*
         INSERT INTO
               AQPB954 C ( C.AQPB954EMP,C.AQPB954MOD,C.AQPB954SUC,
                           C.AQPB954MDA,C.AQPB954PAP,C.AQPB954CTA,
                           C.AQPB954OPE,C.AQPB954SBO,C.AQPB954TOP,
                           C.AQPB954TCOD,C.AQPB954TMOD,C.AQPB954TPIZ,
                           C.AQPB954TCTA,C.AQPB954TMDA,C.AQPB954TPAP,
                           C.AQPB954TFDE,C.AQPB954TMTO,C.AQPB954TTAS,
                           C.AQPB954TPFI,C.AQPB954TPVI,
                           C.AQPB954FECR,C.AQPB954USUR,C.AQPB954TIPR,C.AQPB954TIPI) 
               VALUES (
                        PN_EMP,PN_MOD,PN_SUC,PN_MDA,PN_PAP,PN_CTA,PN_OPE,PN_SBO,PN_TOP,
                        PN_EMP,PN_MOD,VI_PIZARRA,PN_CTA,PN_MDA,PN_PAP,PN_FEC,PN_SALDO,1,vi_fec_invertida,'N',
                        SYSDATE,PN_USER,VI_TIPOUPDREG,'R'
                      );
       */               
               commit;
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
            SELECT A.AQPB904COD, A.AQPB904MOD, A.AQPB904SUC, A.AQPB904MDA, A.AQPB904PAP, A.AQPB904CTA, A.AQPB904OPER, A.AQPB904SBOP, A.AQPB904TOPE
            INTO VI_PGCOD, VI_AOMOD, VI_AOSUC, VI_AOMDA,VI_AOPAP, VI_AOCTA, VI_AOOPER, VI_AOSBOP, VI_AOTOPE
            FROM AQPB904 A
            WHERE A.AQPB904CORR = VE_CORRELATIVO
                AND A.AQPB904INS = VE_INSTANCIA
                AND A.AQPB904ESTA IN ('P','D','A')
                AND A.AQPB904EHAB = 'H';
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

end pQ_CR_LINEAS_RCAJA_HS;
/

