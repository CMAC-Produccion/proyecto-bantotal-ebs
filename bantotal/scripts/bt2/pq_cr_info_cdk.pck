CREATE OR REPLACE PACKAGE PQ_CR_INFO_CDK IS

   ----------------------------------------------------------------------------------------------------
   -- NOMBRE                      : PQ_CR_INFO_CDK
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 20/12/2024
   -- AUTOR DE CREACION           : DCASTRO
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 09/01/2025
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE AGREGO EL SIGUIENTE PROCEDIMIENTO:
   --                               1. SP_CR_CUOTAS_PAGADAS
   --                             : 2025/01/27 DCASTRO Se modificó el procedimiento SP_INSERTA_CRONOGRAMA
   ----------------------------------------------------------------------------------------------------
   
   ----------------------------------------------------------------------------------------------------
   PROCEDURE SP_INFO_CDK(PN_INSTANCIA   IN  NUMBER,
                         PD_FECDES OUT DATE,   --FECDES CDK
                         PN_MTODES OUT NUMBER, --MTO DESEMBOLSO CDK
                         PN_MTOCAP OUT NUMBER, --SALDO CAPITAL CDK
                         PN_NROCUO OUT NUMBER, --NRO CUOTAS ORIGINAL
                         PN_NROPAG OUT NUMBER, --NRO CUOTAS PAGADAS
                         PN_MTOCUO OUT NUMBER, --MTO CUOTA CREDINKA                                                                                                    
                         PN_NROEVA OUT NUMBER, --NRO EVALUACION
                         PN_PGCOD  OUT NUMBER, --PGCOD TRX
                         PN_MODTX  OUT NUMBER, --MODULO TRX
                         PN_SUCTX  OUT NUMBER, --SUCURSAL TRX
                         PN_TRAN   OUT NUMBER, --TRANSANCCION TRX
                         PN_RELTX  OUT NUMBER, --RELACION TRX
                         PN_FECTX  OUT DATE, --FECHA TRX
                         PC_CRECDK OUT VARCHAR2, --CODIGO CREDITO CDK                         
                         PC_IND    OUT CHAR    --INDICADOR CREDINKA                         
                          );
   
    
----------------------------------------------------------------------------------------------------
 PROCEDURE SP_INSERTA_CRONOGRAMA(PN_INSTANCIA   IN  NUMBER,
                                 PC_MENSAJE     OUT VARCHAR2               
                                ) ;                            
----------------------------------------------------------------------------------------------------
   PROCEDURE SP_LOG_CDK ( vc_aqpc737tab in varchar2,
                          vn_aqpc737cre in number, 
                          vn_aqpc737ins in number,  
                          vn_aqpc737cod in number, 
                          vn_aqpc737suc in number, 
                          vn_aqpc737mod in number, 
                          vn_aqpc737mda in number, 
                          vn_aqpc737pap in number, 
                          vn_aqpc737cta in number, 
                          vn_aqpc737oper in number,   
                          vn_aqpc737sbop in number,   
                          vn_aqpc737tope in number,   
                          vn_aqpc737fec  in date,  
                          vn_aqpc737601 in varchar2, 
                          vn_aqpc737611 in varchar2, 
                          vn_aqpc737001 in varchar2
                          );                               

----------------------------------------------------------------------------------------------------
    
   PROCEDURE SP_INSERTA_CRONOGRAMA(
                         PN_PGCOD  IN NUMBER, --PGCOD TRX
                         PN_MODTX  IN NUMBER, --MODULO TRX
                         PN_SUCTX  IN NUMBER, --SUCURSAL TRX
                         PN_TRAN   IN NUMBER, --TRANSANCCION TRX
                         PN_RELTX  IN NUMBER, --RELACION TRX
                         PN_FECTX  IN DATE
                          ) ;                      

  ----------------------------------------------------------------------------------------------------
  PROCEDURE SP_CREDITO_CDK(
                         PN_PGCOD  IN NUMBER, --PGCOD TRX
                         PN_MODTX  IN NUMBER, --MODULO TRX
                         PN_SUCTX  IN NUMBER, --SUCURSAL TRX
                         PN_TRAN   IN NUMBER, --TRANSANCCION TRX
                         PN_RELTX  IN NUMBER, --RELACION TRX
                         PN_ORDIN  IN NUMBER,
                         PC_CODCRE OUT VARCHAR2
                          ) ;
                          
----------------------------------------------      
PROCEDURE SP_INSERTA_CRONOGRAMA_1(
                         PN_PGCOD  IN NUMBER, --PGCOD TRX
                         PN_MODTX  IN NUMBER, --MODULO TRX
                         PN_SUCTX  IN NUMBER, --SUCURSAL TRX
                         PN_TRAN   IN NUMBER, --TRANSANCCION TRX
                         PN_RELTX  IN NUMBER, --RELACION TRX
                         PN_FECTX  IN DATE
                          ) ;     
                          
----------------------------------------------                            
PROCEDURE SP_CR_ELIMINA (   Vn_aqpb178pgcod in number, 
                            Vn_aqpb178modcr in number, 
                            Vn_aqpb178succr in number, 
                            Vn_aqpb178mdacr in number, 
                            Vn_aqpb178papcr in number, 
                            Vn_aqpb178ctacr in number, 
                            Vn_aqpb178opecr  in number,   
                            Vn_aqpb178sbopcr in number,   
                            Vn_aqpb178topecr in number,
                            PC_MSG OUT VARCHAR2                            
                          );
                          
   ----------------------------------------------------------------------------------------------------
   PROCEDURE SP_CR_CUOTAS_PAGADAS(P_CODCDK IN VARCHAR2,
                                  P_RESPTA OUT VARCHAR2);                         
                                                
END PQ_CR_INFO_CDK;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_INFO_CDK IS

   ----------------------------------------------------------------------------------------------------
    
   PROCEDURE SP_INFO_CDK(PN_INSTANCIA   IN  NUMBER,
                         PD_FECDES OUT DATE,   --FECDES CDK
                         PN_MTODES OUT NUMBER, --MTO DESEMBOLSO CDK
                         PN_MTOCAP OUT NUMBER, --SALDO CAPITAL CDK
                         PN_NROCUO OUT NUMBER, --NRO CUOTAS ORIGINAL
                         PN_NROPAG OUT NUMBER, --NRO CUOTAS PAGADAS
                         PN_MTOCUO OUT NUMBER, --MTO CUOTA CREDINKA                                                                                                    
                         PN_NROEVA OUT NUMBER, --NRO EVALUACION
                         PN_PGCOD  OUT NUMBER, --PGCOD TRX
                         PN_MODTX  OUT NUMBER, --MODULO TRX
                         PN_SUCTX  OUT NUMBER, --SUCURSAL TRX
                         PN_TRAN   OUT NUMBER, --TRANSANCCION TRX
                         PN_RELTX  OUT NUMBER, --RELACION TRX
                         PN_FECTX  OUT DATE,   --FECHA TRX
                         PC_CRECDK OUT VARCHAR2, --CODIGO CREDITO CDK
                         PC_IND    OUT CHAR    --INDICADOR CREDINKA
                          ) IS
   
 ---------------------------------------------------------------------------------------------------
   -- NOMBRE                      : SP_INFO_CDK
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 20/12/2024
   -- AUTOR DE CREACION           : DCASTRO
   -- USO                         : RETORNA DATOS TABLA AQPB178 CDK - DESEMBOLSO FLUJO EXPRESS
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   ----------------------------------------------------------------------------------------------------
  
   BEGIN
     
     BEGIN                    
        SELECT  AQPB178FCHDCDK,
                AQPB178MNTDCDK,
                AQPB178SCAPCDK,
                AQPB178NCORCDK,
                AQPB178NCPGCDK,
                AQPB178MCUCDK,
                AQPB178EVA,
                AQPB178PGTX,
                AQPB178MODTX, 
                AQPB178SUCTX, 
                AQPB178TRAN,
                AQPB178RELTX, 
                AQPB178FCONTX,
                aqpb178codcr ,                
                'S'
         INTO
               PD_FECDES,
               PN_MTODES,
               PN_MTOCAP,
               PN_NROCUO,
               PN_NROPAG,      
               PN_MTOCUO,
               PN_NROEVA,
               PN_PGCOD, 
               PN_MODTX, 
               PN_SUCTX, 
               PN_TRAN, 
               PN_RELTX, 
               PN_FECTX,
               PC_CRECDK, 
               PC_IND 
          from AQPB178 f 
         where f.AQPB178INS = PN_INSTANCIA
           AND F.AQPB178TFLU = 'D';
     EXCEPTION WHEN OTHERS THEN
           PD_FECDES := NULL;   
           PN_MTODES := NULL;
           PN_MTOCAP := NULL;
           PN_NROCUO := NULL;
           PN_NROPAG := NULL;
           PN_MTOCUO := NULL;
           PN_NROEVA := NULL;
           PN_PGCOD  := NULL;
           PN_MODTX  := NULL;
           PN_SUCTX  := NULL;
           PN_TRAN   := NULL;
           PN_RELTX  := NULL;
           PN_FECTX  := NULL;
           PC_IND    := 'N';
      END;
   
   
END SP_INFO_CDK;     
   
----------------------------------------------------------------------------------------------------
 PROCEDURE SP_INSERTA_CRONOGRAMA(PN_INSTANCIA   IN  NUMBER,
                                 PC_MENSAJE     OUT VARCHAR2               
                                ) IS
   
 ---------------------------------------------------------------------------------------------------
   -- NOMBRE                      : SP_INSERTA_CRONOGRAMA
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 23/12/2024
   -- AUTOR DE CREACION           : DCASTRO
   -- USO                         : 
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   ----------------------------------------------------------------------------------------------------

   Vc_AQPB178CODCR CHAR(50);
   Vn_aqpb178pgtx  NUMBER;
   Vn_aqpb178modtx NUMBER;
   Vn_aqpb178suctx NUMBER;
   Vn_aqpb178tran  NUMBER;
   Vn_aqpb178reltx NUMBER;
   Vd_aqpb178fcontx date;
   Vn_aqpb178pgcod NUMBER;
   Vn_aqpb178modcr NUMBER;
   Vn_aqpb178succr NUMBER;
   Vn_aqpb178mdacr NUMBER;
   Vn_aqpb178papcr NUMBER;
   Vn_aqpb178ctacr NUMBER;
   Vn_aqpb178opecr NUMBER;
   Vn_aqpb178sbopcr NUMBER;
   Vn_aqpb178topecr NUMBER;
   vn_alta_invertida number;
   VN_SEGURO number; 
   LC_MSG    VARCHAR2(2000); 
   LN_CONT   NUMBER(1); 
   VC_CODERROR VARCHAR2(100);  
   VC_MSGERROR VARCHAR2(1000);
   vc_flag     varchar2(1);      
   
   CURSOR CRONOGRAMA(CREDITO_CDK IN VARCHAR2) IS
   --Con el credito credinka buscar en AQPC736 y obtener las cuotas del cronograma y seguro
   SELECT 
   aqpc736cre,aqpc736ncuo,aqpc736fpag,aqpc736fval,plazo,aqpc736mto,aqpc736cap,aqpc736int,aqpc736seg
     FROM AQPC736 A
    WHERE trim(A.AQPC736CRE) = trim(CREDITO_CDK)
    ORDER BY A.AQPC736FPAG; 

  BEGIN
     
   LC_MSG := NULL;
  
   --Instancia leer tabla AQPB178 para obtener credito credito credito, clave del credito BT, datos trx de BT
   BEGIN
      SELECT  trim(AQPB178CODCR), 
              aqpb178pgtx,
              aqpb178modtx,
              aqpb178suctx,
              aqpb178tran,
              aqpb178reltx,
              aqpb178fcontx,
              aqpb178pgcod,
              aqpb178modcr,
              aqpb178succr,
              aqpb178mdacr,
              aqpb178papcr,
              aqpb178ctacr,
              aqpb178opecr,
              aqpb178sbopcr,
              aqpb178topecr
       into  
             Vc_AQPB178CODCR,  
             Vn_aqpb178pgtx,  
             Vn_aqpb178modtx, 
             Vn_aqpb178suctx, 
             Vn_aqpb178tran,  
             Vn_aqpb178reltx, 
             Vd_aqpb178fcontx,
             Vn_aqpb178pgcod, 
             Vn_aqpb178modcr, 
             Vn_aqpb178succr, 
             Vn_aqpb178mdacr, 
             Vn_aqpb178papcr, 
             Vn_aqpb178ctacr, 
             Vn_aqpb178opecr, 
             Vn_aqpb178sbopcr,
             Vn_aqpb178topecr
      from AQPB178 f              
      where f.AQPB178INS = PN_INSTANCIA  AND F.AQPB178TFLU = 'D';
   EXCEPTION WHEN OTHERS THEN
      NULL;        
   END;  
     
   --backup en fsd601 y fsd602 y fpp001
    --LLAMAR PROCESO GENERA BACKUPs
   PQ_CR_CREDINKA_HS.SP_ALTA_BASE(PN_INSTANCIA,Vc_AQPB178CODCR,Vd_aqpb178fcontx, 'BANTPROD',VC_CODERROR , VC_MSGERROR);
    
   -- INSTANCIA, CUENTA CREDINKA, FECHA DESEMBOLSO Bt
   -- RETORNA S- SI OBTIENE
   LC_MSG    := NULL;
   
   IF VC_CODERROR = '0000' THEN --inicio validacion backup
    
       --eliminar 
       BEGIN
         DELETE FROM FSD601 F 
         WHERE F.PGCOD = Vn_aqpb178pgcod 
           AND F.PPMOD = Vn_aqpb178modcr 
           AND F.PPSUC = Vn_aqpb178succr 
           AND F.PPMDA = Vn_aqpb178mdacr 
           AND F.PPPAP = Vn_aqpb178papcr 
           AND F.PPCTA = Vn_aqpb178ctacr 
           AND F.PPOPER = Vn_aqpb178opecr 
           AND F.PPSBOP = Vn_aqpb178sbopcr
           AND F.PPTOPE = Vn_aqpb178topecr;
      EXCEPTION WHEN OTHERS THEN
        LC_MSG := 'ERROR DELETE FSD601 '||SQLCODE||' - '||SQLERRM;
      END;   
      
       BEGIN
         DELETE FROM FSD611 F 
         WHERE F.PGCOD = Vn_aqpb178pgcod 
           AND F.PPMOD = Vn_aqpb178modcr 
           AND F.PPSUC = Vn_aqpb178succr 
           AND F.PPMDA = Vn_aqpb178mdacr 
           AND F.PPPAP = Vn_aqpb178papcr 
           AND F.PPCTA = Vn_aqpb178ctacr 
           AND F.PPOPER = Vn_aqpb178opecr 
           AND F.PPSBOP = Vn_aqpb178sbopcr
           AND F.PPTOPE = Vn_aqpb178topecr;  
      EXCEPTION WHEN OTHERS THEN
        LC_MSG := LC_MSG ||' ERROR DELETE FSD611 '||SQLCODE||' - '||SQLERRM;
      END;         

       BEGIN
         DELETE FROM FPP001 F 
         WHERE F.PGCOD = Vn_aqpb178pgcod 
           AND F.AOMOD = Vn_aqpb178modcr 
           AND F.AOSUC = Vn_aqpb178succr 
           AND F.AOMDA = Vn_aqpb178mdacr 
           AND F.AOPAP = Vn_aqpb178papcr 
           AND F.AOCTA = Vn_aqpb178ctacr 
           AND F.AOOPER = Vn_aqpb178opecr 
           AND F.AOSBOP = Vn_aqpb178sbopcr
           AND F.AOTOPE = Vn_aqpb178topecr; 
      EXCEPTION WHEN OTHERS THEN
        LC_MSG := LC_MSG || ' ERROR DELETE FPP001 '||SQLCODE||' - '||SQLERRM;
      END;  
      
      IF LC_MSG IS NULL THEN --si no hay error al eliminar puede insertar
         commit; 
         --insertar en fsd601 y fsd602 y fpp001
            LN_CONT := 1;
            FOR I IN CRONOGRAMA( Vc_AQPB178CODCR ) LOOP
             ---alta invertida
             vn_alta_invertida := 99999999 - to_char(i.aqpc736fpag, 'RRRRMMDD');

              begin
                  PQ_CR_INFO_CDK.SP_LOG_CDK('AQPC737' ,Vc_AQPB178CODCR ,PN_INSTANCIA ,Vn_aqpb178pgcod ,Vn_aqpb178succr ,Vn_aqpb178modcr ,
                                                  Vn_aqpb178mdacr ,Vn_aqpb178papcr ,Vn_aqpb178ctacr ,Vn_aqpb178opecr,Vn_aqpb178sbopcr,Vn_aqpb178topecr,Vd_aqpb178fcontx ,'' ,'', '');
              end;

               --fsd601
               BEGIN
                 INSERT INTO FSD601
                   (
                   pgcod, ppmod, ppsuc, ppmda, pppap, ppcta, ppoper, ppsbop, pptope, 
                   ppfpag, pptipo, ppfval, ppfvto, pppzo, ppcap, ppint, ppnume, ppfinv, 
                   d601cd, d601mo, d601su, d601tr, d601re, d601fc, d601or, d601sb, d601co
                   )
                 VALUES
                   (
                   Vn_aqpb178pgcod, Vn_aqpb178modcr, Vn_aqpb178succr, Vn_aqpb178mdacr, Vn_aqpb178papcr, Vn_aqpb178ctacr,
                   Vn_aqpb178opecr, Vn_aqpb178sbopcr, Vn_aqpb178topecr,
                   i.aqpc736fpag, 'F', i.aqpc736fpag, i.aqpc736fval, i.plazo, i.aqpc736cap, i.aqpc736int, 0, vn_alta_invertida,  
                   Vn_aqpb178pgtx, Vn_aqpb178modtx, Vn_aqpb178suctx, Vn_aqpb178tran, Vn_aqpb178reltx, Vd_aqpb178fcontx,  10, 0, 'S'
                   );
                 COMMIT;
                 vc_flag := 'S';
              EXCEPTION WHEN OTHERS THEN
                LC_MSG := 'ERROR INSERTAR FSD601 '||SQLCODE||' - '||SQLERRM;
                vc_flag := 'N';
              END; 
              begin
                  PQ_CR_INFO_CDK.SP_LOG_CDK('FSD601' ,Vc_AQPB178CODCR ,PN_INSTANCIA ,Vn_aqpb178pgcod ,Vn_aqpb178succr ,Vn_aqpb178modcr ,
                                                  Vn_aqpb178mdacr ,Vn_aqpb178papcr ,Vn_aqpb178ctacr ,Vn_aqpb178opecr,Vn_aqpb178sbopcr,Vn_aqpb178topecr,Vd_aqpb178fcontx ,vc_flag ,'', '');
              end;  
               ---fsd611
              BEGIN 
               INSERT INTO FSD611
                 (
                  pgcod, ppmod, ppsuc, ppmda, pppap, ppcta, ppoper,ppsbop,pptope,
                  ppfpag,pptipo,ppimp1,ppimp2,ppimp3,ppimp4,ppimp5,ppimp6,ppimp7,ppimp8,ppimp9,ppimp10, ppimp11,
                  ppimp12,ppimp13,ppimp14,ppimp15,ppimp16,ppimp17,ppimp18,ppimp19,ppimp20, PPEXTE
                 )
               VALUES
                 (
                  Vn_aqpb178pgcod, Vn_aqpb178modcr, Vn_aqpb178succr, Vn_aqpb178mdacr, Vn_aqpb178papcr, Vn_aqpb178ctacr,
                  Vn_aqpb178opecr, Vn_aqpb178sbopcr, Vn_aqpb178topecr,
                  i.aqpc736fpag, 'F',0,0,0,0,0,0,0,0,0,0, I.aqpc736seg,0,0,0,0,0,0,0,0,0 ,0
                  );
               COMMIT;
               vc_flag := 'S';
              EXCEPTION WHEN OTHERS THEN
                LC_MSG := 'ERROR INSERTAR FSD611 '||SQLCODE||' - '||SQLERRM;
                vc_flag := 'N';                
              END;    
             begin
                       PQ_CR_INFO_CDK.SP_LOG_CDK('FSD611' ,Vc_AQPB178CODCR ,PN_INSTANCIA ,Vn_aqpb178pgcod ,Vn_aqpb178succr ,Vn_aqpb178modcr ,
                                    Vn_aqpb178mdacr ,Vn_aqpb178papcr ,Vn_aqpb178ctacr ,Vn_aqpb178opecr,Vn_aqpb178sbopcr,Vn_aqpb178topecr,Vd_aqpb178fcontx ,vc_flag ,'', '');
             end; 
               --fpp001--
               --seguro 503
               IF LN_CONT = 1 then    
                   VN_SEGURO := 503;
                  BEGIN 
                   INSERT INTO FPP001
                     (
                     pgcod,aomod,aosuc,aomda,aopap, aocta,aooper,aosbop,aotope,sgcod,
                     pp001vc,pp001imp,pp001porc,pp001plus,pp001part,pp001co
                     )
                   VALUES
                     (
                     Vn_aqpb178pgcod, Vn_aqpb178modcr, Vn_aqpb178succr, Vn_aqpb178mdacr, Vn_aqpb178papcr, Vn_aqpb178ctacr,
                     Vn_aqpb178opecr, Vn_aqpb178sbopcr, Vn_aqpb178topecr,VN_SEGURO,
                     0,I.aqpc736seg, 0, 0, 100, 'X'
                     );
                   COMMIT;
                   vc_flag := 'S';
                  EXCEPTION WHEN OTHERS THEN
                    LC_MSG := 'ERROR INSERTAR FPP001 '||SQLCODE||' - '||SQLERRM;
                    vc_flag := 'N';
                  END; 
                  LN_CONT := LN_CONT+ 1;
                  begin
                          PQ_CR_INFO_CDK.SP_LOG_CDK('FPP001' ,Vc_AQPB178CODCR ,PN_INSTANCIA ,Vn_aqpb178pgcod ,Vn_aqpb178succr ,Vn_aqpb178modcr ,
                                                  Vn_aqpb178mdacr ,Vn_aqpb178papcr ,Vn_aqpb178ctacr ,Vn_aqpb178opecr,Vn_aqpb178sbopcr,Vn_aqpb178topecr,Vd_aqpb178fcontx ,vc_flag ,'', '');
                  end;
                END IF;
             
           END LOOP;
       ELSE
              rollback; 
       END IF;    
  ELSE
     LC_MSG := 'NO GENERO BACKUP -NO REALIZO CAMBIO DE CRONOGRAMA';
  END IF;  ---fin validacion backup 

 PC_MENSAJE := LC_MSG;


 END SP_INSERTA_CRONOGRAMA;


  ----------------------------------------------------------------------------------------------------
    
   PROCEDURE SP_LOG_CDK ( vc_aqpc737tab in varchar2,
                          vn_aqpc737cre in number, 
                          vn_aqpc737ins in number,  
                          vn_aqpc737cod in number, 
                          vn_aqpc737suc in number, 
                          vn_aqpc737mod in number, 
                          vn_aqpc737mda in number, 
                          vn_aqpc737pap in number, 
                          vn_aqpc737cta in number, 
                          vn_aqpc737oper in number,   
                          vn_aqpc737sbop in number,   
                          vn_aqpc737tope in number,   
                          vn_aqpc737fec  in date,  
                          vn_aqpc737601 in varchar2, 
                          vn_aqpc737611 in varchar2, 
                          vn_aqpc737001 in varchar2
                          ) IS
   
 ---------------------------------------------------------------------------------------------------
   -- NOMBRE                      : SP_LOG_CDK
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 24/12/2024
   -- AUTOR DE CREACION           : DCASTRO
   -- USO                         : GRABA DATOS
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   ----------------------------------------------------------------------------------------------------
   VC_CODERR varchar2(100);
   VC_MSGERR varchar2(1000);

  BEGIN

   if vc_aqpc737tab = 'AQPC737' then
      begin
        insert into AQPC737 (  aqpc737cre, aqpc737ins,aqpc737cod,aqpc737suc,aqpc737mod,aqpc737mda,aqpc737pap,aqpc737cta,aqpc737oper,aqpc737sbop,aqpc737tope,
                               aqpc737fec, aqpc737601, aqpc737611, aqpc737001)
        values( vn_aqpc737cre ,vn_aqpc737ins,vn_aqpc737cod,vn_aqpc737suc,vn_aqpc737mod, vn_aqpc737mda,vn_aqpc737pap,vn_aqpc737cta,vn_aqpc737oper,
                vn_aqpc737sbop,vn_aqpc737tope,vn_aqpc737fec,vn_aqpc737601,vn_aqpc737611, vn_aqpc737001);
        commit;
      exception when others then
          ---TABLA ERROR
            VC_CODERR := '0000';
            VC_MSGERR := SUBSTR(SQLERRM,1,150);
            PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(vn_aqpc737ins,'','PQ_CR_INFO_CDK','SP_LOG_CDK','',VC_CODERR,VC_MSGERR);
     end;        
   end if;
 
   if vc_aqpc737tab = 'FSD601' then
        begin
          update AQPC737 a
             set a.aqpc737601 = vn_aqpc737601
          where a.aqpc737ins = vn_aqpc737ins
            and a.aqpc737fec = vn_aqpc737fec;
          commit;
        exception when others then
         ---TABLA ERROR
            VC_CODERR := '0001';
            VC_MSGERR := SUBSTR(SQLERRM,1,150);
            PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(vn_aqpc737ins,'','PQ_CR_INFO_CDK','SP_LOG_CDK','',VC_CODERR,VC_MSGERR);
        end;        
    end if;   
    if vc_aqpc737tab = 'FSD611' then
          begin
            update AQPC737 a
               set a.aqpc737611= vn_aqpc737611
            where a.aqpc737ins = vn_aqpc737ins
              and a.aqpc737fec = vn_aqpc737fec;
            commit;
          exception when others then
                ---TABLA ERROR
                VC_CODERR := '0002';
                VC_MSGERR := SUBSTR(SQLERRM,1,150);
                PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(vn_aqpc737ins,'','PQ_CR_INFO_CDK','SP_LOG_CDK','',VC_CODERR,VC_MSGERR);
          end;        
     end if;   
     if vc_aqpc737tab = 'FPP001' then
      begin
        update AQPC737 a
           set a.aqpc737001 = vn_aqpc737001
        where a.aqpc737ins = vn_aqpc737ins
          and a.aqpc737fec = vn_aqpc737fec;
        commit;
      exception when others then
           ---TABLA ERROR
          VC_CODERR := '0001';
          VC_MSGERR := SUBSTR(SQLERRM,1,150);
          PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(vn_aqpc737ins,'','PQ_CR_INFO_CDK','SP_LOG_CDK','',VC_CODERR,VC_MSGERR);

      end;        
     end if;
                     
      
  END SP_LOG_CDK ;
 
   ----------------------------------------------------------------------------------------------------
   
   PROCEDURE SP_INSERTA_CRONOGRAMA(
                         PN_PGCOD  IN NUMBER, --PGCOD TRX
                         PN_MODTX  IN NUMBER, --MODULO TRX
                         PN_SUCTX  IN NUMBER, --SUCURSAL TRX
                         PN_TRAN   IN NUMBER, --TRANSANCCION TRX
                         PN_RELTX  IN NUMBER, --RELACION TRX
                         PN_FECTX  IN DATE
                          ) IS
   
 ---------------------------------------------------------------------------------------------------
   -- NOMBRE                      : SP_CODCRE_CDK
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 20/12/2024
   -- AUTOR DE CREACION           : DCASTRO
   -- USO                         : RETORNA DATOS TABLA AQPB178 CDK - DESEMBOLSO FLUJO EXPRESS
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 2025.01.27 
   -- AUTOR DE LA MODIFICACION    : DCASTRO
   -- DESCRIPCION DE MODIFICACION : Se agregó condición cuando credito no posee seguro
   ----------------------------------------------------------------------------------------------------
  
   Vc_AQPB178CODCR VARCHAR2(50);
   Vn_aqpb178pgtx  NUMBER;
   Vn_aqpb178modtx NUMBER;
   Vn_aqpb178suctx NUMBER;
   Vn_aqpb178tran  NUMBER;
   Vn_aqpb178reltx NUMBER;
   Vd_aqpb178fcontx date;
   Vn_aqpb178pgcod NUMBER;
   Vn_aqpb178modcr NUMBER;
   Vn_aqpb178succr NUMBER;
   Vn_aqpb178mdacr NUMBER;
   Vn_aqpb178papcr NUMBER;
   Vn_aqpb178ctacr NUMBER;
   Vn_aqpb178opecr NUMBER;
   Vn_aqpb178sbopcr NUMBER;
   Vn_aqpb178topecr NUMBER;
   vn_AQPB178INS    number;
   vn_alta_invertida number;
   VN_SEGURO number; 
   LC_MSG    VARCHAR2(2000); 
   LN_CONT   NUMBER(1); 
   VC_CODERROR VARCHAR2(100);  
   VC_MSGERROR VARCHAR2(1000);
   vc_flag     varchar2(1);  
   LN_PLAN     NUMBER;   
   ln_plazo    NUMBER;
   ln_cuo      NUMBER; 
   ld_feccuo   date;
   ln_seguro   number; --- 2025.01.27 dcastro
   Vn_tasa_mor number; --- 2025.01.27 dcastro 

   VC_CODERR varchar2(100);
   VC_MSGERR varchar2(1000);   
   
   CURSOR CRONOGRAMA(CREDITO_CDK IN VARCHAR2) IS
   --Con el credito credinka buscar en AQPC736 y obtener las cuotas del cronograma y seguro
   select aqpc736cre,
         aqpc736ncuo,
         aqpc736fpag,
         aqpc736fval,
         plazo,
         aqpc736mto,
         aqpc736cap,
         aqpc736int,
         aqpc736seg
    FROM AQPC736 A
   where a.aqpc736cre = CREDITO_CDK
   ORDER BY A.AQPC736FPAG;  
   
  BEGIN
     
   LC_MSG := NULL;
  
   --Instancia leer tabla AQPB178 para obtener credito credito credito, clave del credito BT, datos trx de BT
   BEGIN
      SELECT  trim(AQPB178CODCR), 
              aqpb178pgcod,
              aqpb178modcr,
              aqpb178succr,
              aqpb178mdacr,
              aqpb178papcr,
              aqpb178ctacr,
              aqpb178opecr,
              aqpb178sbopcr,
              aqpb178topecr,
              AQPB178INS,
              AQPB178AUXN6 ---tasa moratoria
       into  
             Vc_AQPB178CODCR,  
             Vn_aqpb178pgcod, 
             Vn_aqpb178modcr, 
             Vn_aqpb178succr, 
             Vn_aqpb178mdacr, 
             Vn_aqpb178papcr, 
             Vn_aqpb178ctacr, 
             Vn_aqpb178opecr, 
             Vn_aqpb178sbopcr,
             Vn_aqpb178topecr,
             vn_AQPB178INS,
             Vn_tasa_mor
       from AQPB178 f              
      where aqpb178pgtx   = PN_PGCOD
        and aqpb178modtx  = PN_MODTX
        and aqpb178suctx  = PN_SUCTX
        and aqpb178tran   = PN_TRAN 
        and aqpb178reltx  = PN_RELTX
        and aqpb178fcontx = PN_FECTX
        AND F.AQPB178TFLU = 'D';
   EXCEPTION WHEN OTHERS THEN
      NULL;        
   END;  
     
   Vn_aqpb178pgtx   := PN_PGCOD; 
   Vn_aqpb178modtx  := PN_MODTX;
   Vn_aqpb178suctx  := PN_SUCTX; 
   Vn_aqpb178tran   := PN_TRAN;   
   Vn_aqpb178reltx  := PN_RELTX; 
   Vd_aqpb178fcontx := PN_FECTX;   
   
   --EXISTE CRONOGRAMA
   LN_PLAN := 0;
   BEGIN
    SELECT COUNT(*)
      INTO LN_PLAN
      FROM AQPC736 A
     WHERE a.aqpc736cre = Vc_AQPB178CODCR;
   EXCEPTION WHEN OTHERS THEN
     LN_PLAN := 0;  
   END; 

   IF LN_PLAN = 0 THEN -- VALIDACION NO EXISTE CRONOGRAMA NO DEBE PROCESAR NADA
   
        begin
            PQ_CR_INFO_CDK.SP_LOG_CDK('AQPC737' ,Vc_AQPB178CODCR ,vn_AQPB178INS ,Vn_aqpb178pgcod ,Vn_aqpb178succr ,Vn_aqpb178modcr ,
                                            Vn_aqpb178mdacr ,Vn_aqpb178papcr ,Vn_aqpb178ctacr ,Vn_aqpb178opecr,Vn_aqpb178sbopcr,Vn_aqpb178topecr,Vd_aqpb178fcontx ,'E' ,'E', 'E');
        end;
  
   ELSE --EXISTE CRONOGRAMA DEBE ELIMINAR CALENDARIO Y ACTUALIZAR CON DATA CREDINKA        

        ---inserta cabecera
        begin
            PQ_CR_INFO_CDK.SP_LOG_CDK('AQPC737' ,Vc_AQPB178CODCR ,vn_AQPB178INS ,Vn_aqpb178pgcod ,Vn_aqpb178succr ,Vn_aqpb178modcr ,
                                            Vn_aqpb178mdacr ,Vn_aqpb178papcr ,Vn_aqpb178ctacr ,Vn_aqpb178opecr,Vn_aqpb178sbopcr,Vn_aqpb178topecr,Vd_aqpb178fcontx ,'' ,'', '');
        end;
   
         --PROCESO GENERA BACKUPs
         PQ_CR_CREDINKA_HS.SP_ALTA_BASE(vn_AQPB178INS,Vc_AQPB178CODCR,Vd_aqpb178fcontx, 'BANTPROD',VC_CODERROR , VC_MSGERROR);
          
         ---------------- VC_CODERROR := '0000'; ---sea agrego   
         IF VC_CODERROR = '0000' THEN --inicio validacion backup
               LC_MSG    := NULL;
               begin
                PQ_CR_INFO_CDK.SP_CR_ELIMINA(Vn_aqpb178pgcod ,
                                             Vn_aqpb178modcr ,
                                             Vn_aqpb178succr ,
                                             Vn_aqpb178mdacr ,
                                             Vn_aqpb178papcr ,
                                             Vn_aqpb178ctacr ,
                                             Vn_aqpb178opecr ,
                                             Vn_aqpb178sbopcr,
                                             Vn_aqpb178topecr,
                                             LC_MSG);
              end;
        
              IF LC_MSG IS NULL THEN --si no hay error al eliminar puede insertar
               commit; 
               --insertar en fsd601 y fsd602 y fpp001
                  LN_CONT := 1;
                  ln_cuo  := 1;
                  FOR I IN CRONOGRAMA( Vc_AQPB178CODCR ) LOOP
                     
                     ---alta invertida
                     vn_alta_invertida := 99999999 - to_char(i.aqpc736fpag, 'RRRRMMDD');
                     if ln_cuo = 1 then
                        begin
                            select f.aofval
                              into ld_feccuo
                              from fsd010 f
                            where f.pgcod =  Vn_aqpb178pgcod
                              and f.aomod =  Vn_aqpb178modcr
                              and f.aosuc =  Vn_aqpb178succr
                              and f.aomda =  Vn_aqpb178mdacr
                              and f.aopap =  Vn_aqpb178papcr
                              and f.aocta =  Vn_aqpb178ctacr
                              and f.aooper = Vn_aqpb178opecr
                              and f.aosbop = Vn_aqpb178sbopcr
                              and f.aotope = Vn_aqpb178topecr ;  
                        exception when others then
                             ld_feccuo := trunc(sysdate);
                        end;
                        ln_plazo := i.aqpc736fpag - ld_feccuo;
                        ln_cuo  := ln_cuo + 1;
                     else 
                        ld_feccuo := i.aqpc736fval;
                        ln_plazo  := i.plazo;
                     end if;  
                     --fsd601
                     BEGIN
                       INSERT INTO FSD601
                         (
                         pgcod, ppmod, ppsuc, ppmda, pppap, ppcta, ppoper, ppsbop, pptope, 
                         ppfpag, pptipo, ppfval, ppfvto, pppzo, ppcap, ppint, ppnume, ppfinv, 
                         d601cd, d601mo, d601su, d601tr, d601re, d601fc, d601or, d601sb, d601co
                         )
                       VALUES
                         (
                         Vn_aqpb178pgcod, Vn_aqpb178modcr, Vn_aqpb178succr, Vn_aqpb178mdacr, Vn_aqpb178papcr, Vn_aqpb178ctacr,
                         Vn_aqpb178opecr, Vn_aqpb178sbopcr, Vn_aqpb178topecr,
                         i.aqpc736fpag, 'F', ld_feccuo/*i.aqpc736fval*/, i.aqpc736fpag, ln_plazo/*i.plazo*/, i.aqpc736cap, i.aqpc736int, 0, vn_alta_invertida,  
                         Vn_aqpb178pgtx, Vn_aqpb178modtx, Vn_aqpb178suctx, Vn_aqpb178tran, Vn_aqpb178reltx, Vd_aqpb178fcontx,  10, 0, 'S'
                         );
                       COMMIT;
                       vc_flag := 'S';
                             
                         --actualiza cuota insertada
                         begin
                           update aqpc736 a
                              set a.AQPC73INS  = vn_AQPB178INS, 
                               a.AQPC73COD  = Vn_aqpb178pgcod, 
                               a.AQPC73SUC  = Vn_aqpb178succr, 
                               a.AQPC73MOD  = Vn_aqpb178modcr,
                               a.aqpc73MDA  = Vn_aqpb178mdacr,
                               a.AQPC73PAP  = Vn_aqpb178papcr,
                               a.AQPC73CTA  = Vn_aqpb178ctacr,
                               a.AQPC73OPE  = Vn_aqpb178opecr,
                               a.AQPC73SUB  = Vn_aqpb178sbopcr,
                               a.AQPC73TIP  = Vn_aqpb178topecr,
                               a.AQPC73601  = vc_flag
                            where a.aqpc736cre = Vc_AQPB178CODCR
                              and a.aqpc736fpag = i.aqpc736fpag;
                              commit;
                         end;
                         --fin actualiza                   
                    EXCEPTION WHEN OTHERS THEN
                        LC_MSG := 'ERROR INSERTAR FSD601 '||SQLCODE||' - '||SQLERRM;
                        vc_flag := 'N';
                        ---TABLA ERROR
                        VC_CODERR := '0001';
                        VC_MSGERR := SUBSTR(SQLERRM,1,250);
                        PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(vn_AQPB178INS,'','PQ_CR_INFO_CDK','SP_INSERTA_CRONOGRAMA','',VC_CODERR,VC_MSGERR);

                    END; 
                    begin
                        PQ_CR_INFO_CDK.SP_LOG_CDK('FSD601' ,Vc_AQPB178CODCR ,vn_AQPB178INS ,Vn_aqpb178pgcod ,Vn_aqpb178succr ,Vn_aqpb178modcr ,
                                                        Vn_aqpb178mdacr ,Vn_aqpb178papcr ,Vn_aqpb178ctacr ,Vn_aqpb178opecr,Vn_aqpb178sbopcr,Vn_aqpb178topecr,Vd_aqpb178fcontx ,vc_flag ,'', '');
                    end;  
                    
                   
                     ln_seguro := I.aqpc736seg; ---2025.01.27 dcastro
                    
                      
                         ---fsd611
                        BEGIN 
                         INSERT INTO FSD611
                           (
                            pgcod, ppmod, ppsuc, ppmda, pppap, ppcta, ppoper,ppsbop,pptope,
                            ppfpag,pptipo,ppimp1,ppimp2,ppimp3,ppimp4,ppimp5,ppimp6,ppimp7,ppimp8,ppimp9,ppimp10, ppimp11,
                            ppimp12,ppimp13,ppimp14,ppimp15,ppimp16,ppimp17,ppimp18,ppimp19,ppimp20, PPEXTE
                           )
                         VALUES
                           (
                            Vn_aqpb178pgcod, Vn_aqpb178modcr, Vn_aqpb178succr, Vn_aqpb178mdacr, Vn_aqpb178papcr, Vn_aqpb178ctacr,
                            Vn_aqpb178opecr, Vn_aqpb178sbopcr, Vn_aqpb178topecr,
                            i.aqpc736fpag, 'F',0,0,0,0,0,0,0,0,0,0, ln_seguro ,0,0,0,0,0,0,0,0,0 ,0
                            );
                         COMMIT;
                         vc_flag := 'S';
                               
                             --actualiza cuota insertada
                             begin
                               update aqpc736 a
                                  set a.AQPC73INS  = vn_AQPB178INS, 
                                   a.AQPC73COD  = Vn_aqpb178pgcod, 
                                   a.AQPC73SUC  = Vn_aqpb178succr, 
                                   a.AQPC73MOD  = Vn_aqpb178modcr,
                                   a.aqpc73MDA  = Vn_aqpb178mdacr,
                                   a.AQPC73PAP  = Vn_aqpb178papcr,
                                   a.AQPC73CTA  = Vn_aqpb178ctacr,
                                   a.AQPC73OPE  = Vn_aqpb178opecr,
                                   a.AQPC73SUB  = Vn_aqpb178sbopcr,
                                   a.AQPC73TIP  = Vn_aqpb178topecr,
                                    a.aqpc73611  = vc_flag
                                where a.aqpc736cre = Vc_AQPB178CODCR
                                  and a.aqpc736fpag = i.aqpc736fpag;
                                  commit;
                             end;
                             --fin actualiza
                                   
                        EXCEPTION WHEN OTHERS THEN
                          LC_MSG := 'ERROR INSERTAR FSD611 '||SQLCODE||' - '||SQLERRM;
                          vc_flag := 'N';   
                            ---TABLA ERROR
                            VC_CODERR := '0002';
                            VC_MSGERR := SUBSTR(SQLERRM,1,250);
                            PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(vn_AQPB178INS,'','PQ_CR_INFO_CDK','SP_INSERTA_CRONOGRAMA','',VC_CODERR,VC_MSGERR);
                             
                        END;    
                         begin
                                   PQ_CR_INFO_CDK.SP_LOG_CDK('FSD611' ,Vc_AQPB178CODCR ,vn_AQPB178INS ,Vn_aqpb178pgcod ,Vn_aqpb178succr ,Vn_aqpb178modcr ,
                                                Vn_aqpb178mdacr ,Vn_aqpb178papcr ,Vn_aqpb178ctacr ,Vn_aqpb178opecr,Vn_aqpb178sbopcr,Vn_aqpb178topecr,Vd_aqpb178fcontx ,'',vc_flag , '');
                         end; 
                     --fpp001--
                     --seguro 503
                     IF LN_CONT = 1 then    
                         VN_SEGURO := 503;
                         
                         IF I.aqpc736seg <> 0 then ---2025.01.27 dcastro inserta FPP001 si segur es diferente 999999
                            BEGIN 
                               INSERT INTO FPP001
                                 (
                                 pgcod,aomod,aosuc,aomda,aopap, aocta,aooper,aosbop,aotope,sgcod,pp001stat,
                                 pp001vc,pp001imp,pp001porc,pp001plus,pp001part,pp001co,  PP001AUX1,	PP001AUX2	,PP001AUX4,PP001VEH,PP001INM
                                 )
                               VALUES
                                 (
                                 Vn_aqpb178pgcod, Vn_aqpb178modcr, Vn_aqpb178succr, Vn_aqpb178mdacr, Vn_aqpb178papcr, Vn_aqpb178ctacr,
                                 Vn_aqpb178opecr, Vn_aqpb178sbopcr, Vn_aqpb178topecr,VN_SEGURO,' ',
                                 0,I.aqpc736seg, 0, 0, 100, 'X', 0.00	,0.000000, 0.00, 0,	0
                                 );
                               COMMIT;
                               vc_flag := 'S';
                                     
                                 --actualiza cuota insertada
                                 begin
                                   update aqpc736 a
                                      set a.AQPC73INS  = vn_AQPB178INS, 
                                       a.AQPC73COD  = Vn_aqpb178pgcod, 
                                       a.AQPC73SUC  = Vn_aqpb178succr, 
                                       a.AQPC73MOD  = Vn_aqpb178modcr,
                                       a.aqpc73MDA  = Vn_aqpb178mdacr,
                                       a.AQPC73PAP  = Vn_aqpb178papcr,
                                       a.AQPC73CTA  = Vn_aqpb178ctacr,
                                       a.AQPC73OPE  = Vn_aqpb178opecr,
                                       a.AQPC73SUB  = Vn_aqpb178sbopcr,
                                       a.AQPC73TIP  = Vn_aqpb178topecr,
                                       a.aqpc73001  = vc_flag
                                    where a.aqpc736cre = Vc_AQPB178CODCR
                                      and a.aqpc736fpag = i.aqpc736fpag;
                                      commit;
                                 end;
                                 --fin actualiza
                            EXCEPTION WHEN OTHERS THEN
                              LC_MSG := 'ERROR INSERTAR FPP001 '||SQLCODE||' - '||SQLERRM;
                              vc_flag := 'N';
                                 ---TABLA ERROR
                                VC_CODERR := '0003';
                                VC_MSGERR := SUBSTR(SQLERRM,1,250);
                                PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(vn_AQPB178INS,'','PQ_CR_INFO_CDK','SP_INSERTA_CRONOGRAMA','',VC_CODERR,VC_MSGERR);
                            END; 
                            LN_CONT := LN_CONT+ 1;
                            begin
                                    PQ_CR_INFO_CDK.SP_LOG_CDK('FPP001' ,Vc_AQPB178CODCR ,vn_AQPB178INS ,Vn_aqpb178pgcod ,Vn_aqpb178succr ,Vn_aqpb178modcr ,
                                                            Vn_aqpb178mdacr ,Vn_aqpb178papcr ,Vn_aqpb178ctacr ,Vn_aqpb178opecr,Vn_aqpb178sbopcr,Vn_aqpb178topecr,Vd_aqpb178fcontx ,'', '',vc_flag );
                            end;
                        END IF; --- ---2025.01.27 dcastro inserta FPP001 si segur es diferente 999999   
                            
                      END IF; --- FIN LC_MSG 


                 END LOOP;
             ELSE
               
                 rollback; 
                 begin
                    update AQPC737 a 
                       set a.aqpc737601 = 'D', --error al eliminar cronograma, nose aplica nada
                           a.aqpc737611 = 'D',
                           a.aqpc737001 = 'D'
                    where a.aqpc737ins = vn_AQPB178INS
                      and a.aqpc737fec = Vd_aqpb178fcontx;
                    commit;
                  exception when others then
                   ---TABLA ERROR
                      VC_CODERR := '0004';
                      VC_MSGERR := SUBSTR(SQLERRM,1,150);
                      PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(vn_AQPB178INS,'','PQ_CR_INFO_CDK','SP_CR_INSERTA_CRONOGRAMA','',VC_CODERR,VC_MSGERR);
                  end;  
             END IF;    
        ELSE
           LC_MSG := 'NO GENERO BACKUP -NO REALIZO CAMBIO DE CRONOGRAMA';
        END IF;  ---fin validacion backup 

        ---2025.01.27 dcastro actualiza tasa moratoria
          begin
            update FSD012
               set EVTASA =  Vn_tasa_mor
             where PGCOD =   Vn_aqpb178pgcod 
               and AOMOD =   Vn_aqpb178modcr 
               and AOSUC =   Vn_aqpb178succr
               and AOMDA =   Vn_aqpb178mdacr
               and AOPAP =   Vn_aqpb178papcr
               and AOCTA =   Vn_aqpb178ctacr
               and AOOPER =  Vn_aqpb178opecr
               and AOSBOP =  Vn_aqpb178sbopcr
               and AOTOPE =  Vn_aqpb178topecr
               and EVTIPO = 4
               and D012CO = 'S';
            commit;
          exception
           when others then
              null;
          end;

        
        ---2025.01.27 dcastro actualiza tasa moratoria        

   END IF; ---FIN VALIDACION NO EXISTE CRONOGRAMA NO DEBE PROCESAR NADA     
   
END SP_INSERTA_CRONOGRAMA;     
  ----------------------------------------------------------------------------------------------------
   
PROCEDURE SP_CREDITO_CDK(
                         PN_PGCOD  IN NUMBER, --PGCOD TRX
                         PN_MODTX  IN NUMBER, --MODULO TRX
                         PN_SUCTX  IN NUMBER, --SUCURSAL TRX
                         PN_TRAN   IN NUMBER, --TRANSANCCION TRX
                         PN_RELTX  IN NUMBER, --RELACION TRX
                         PN_ORDIN  IN NUMBER,
                         PC_CODCRE OUT VARCHAR2 --CREDITO CREDINKA
                          ) IS
   
 ---------------------------------------------------------------------------------------------------
   -- NOMBRE                      : SP_CREDITO_CDK
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 20/12/2024
   -- AUTOR DE CREACION           : DCASTRO
   -- USO                         : RETORNA VARIABLE CREDITO CREDINKA
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   ----------------------------------------------------------------------------------------------------
  
  Vc_AQPB178CODCR CHAR(50);
  VC_CODERR varchar2(100);
  VC_MSGERR varchar2(1000);  
  Vc_aqpb178ins number;
  LN_CTA     NUMBER(9);
  LN_OPER    NUMBER(9);
  

  BEGIN
     
   --fsd016
  BEGIN
    SELECT F.CTNRO, F.ITOPER
       INTO LN_CTA, LN_OPER
      FROM FSD016 F 
     WHERE F.PGCOD =  PN_PGCOD 
       AND F.ITSUC =  PN_SUCTX  
       AND F.ITMOD =  PN_MODTX
       AND F.ITTRAN = PN_TRAN  
       AND F.ITNREL = PN_RELTX 
       AND F.ITORD =  PN_ORDIN;
   END;
 
    --Instancia leer tabla AQPB178 para obtener credito credito credito, clave del credito BT, datos trx de BT
   BEGIN
      SELECT  trim(AQPB178CODCR) , f.aqpb178ins
        into Vc_AQPB178CODCR, Vc_aqpb178ins
        from AQPB178 f              
       where F.AQPB178CTACR = LN_CTA
         and F.AQPB178OPECR = LN_OPER
         AND F.AQPB178TFLU = 'D';
   EXCEPTION WHEN OTHERS THEN
      Vc_AQPB178CODCR := NULL;  
      ---TABLA ERROR
      VC_CODERR := '0005';
      VC_MSGERR := SUBSTR(SQLERRM,1,150);
      PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(Vc_aqpb178ins,'','PQ_CR_INFO_CDK','SP_CREDITO_CDK','',VC_CODERR,VC_MSGERR);
      
   END; 
   
   PC_CODCRE := Vc_AQPB178CODCR;
   
END SP_CREDITO_CDK;   


----------------------------------------------      
PROCEDURE SP_INSERTA_CRONOGRAMA_1(
                         PN_PGCOD  IN NUMBER, --PGCOD TRX
                         PN_MODTX  IN NUMBER, --MODULO TRX
                         PN_SUCTX  IN NUMBER, --SUCURSAL TRX
                         PN_TRAN   IN NUMBER, --TRANSANCCION TRX
                         PN_RELTX  IN NUMBER, --RELACION TRX
                         PN_FECTX  IN DATE
                          ) IS
   
 ---------------------------------------------------------------------------------------------------
   -- NOMBRE                      : SP_CODCRE_CDK
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 20/12/2024
   -- AUTOR DE CREACION           : DCASTRO
   -- USO                         : RETORNA DATOS TABLA AQPB178 CDK - DESEMBOLSO FLUJO EXPRESS
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   ----------------------------------------------------------------------------------------------------
  
   Vc_AQPB178CODCR VARCHAR2(50);
   Vn_aqpb178pgtx  NUMBER;
   Vn_aqpb178modtx NUMBER;
   Vn_aqpb178suctx NUMBER;
   Vn_aqpb178tran  NUMBER;
   Vn_aqpb178reltx NUMBER;
   Vd_aqpb178fcontx date;
   Vn_aqpb178pgcod NUMBER;
   Vn_aqpb178modcr NUMBER;
   Vn_aqpb178succr NUMBER;
   Vn_aqpb178mdacr NUMBER;
   Vn_aqpb178papcr NUMBER;
   Vn_aqpb178ctacr NUMBER;
   Vn_aqpb178opecr NUMBER;
   Vn_aqpb178sbopcr NUMBER;
   Vn_aqpb178topecr NUMBER;
   vn_AQPB178INS    number;
   vn_alta_invertida number;
   VN_SEGURO number; 
   LC_MSG    VARCHAR2(2000); 
   LN_CONT   NUMBER(1); 
   VC_CODERROR VARCHAR2(100);  
   VC_MSGERROR VARCHAR2(1000);
   vc_flag     varchar2(1);      

   VC_CODERR varchar2(100);
   VC_MSGERR varchar2(1000);   
   
   CURSOR CRONOGRAMA(CREDITO_CDK IN VARCHAR2) IS
   --Con el credito credinka buscar en AQPC736 y obtener las cuotas del cronograma y seguro
   select b.aqpb178codcr aqpc736cre,
       aqpc736ncuo,
       aqpc736fpag,
       aqpc736fval,
       plazo,
       aqpc736mto,
       aqpc736cap,
       aqpc736int,
       aqpc736seg
  FROM aqpb178 b
  left join AQPC736 A
    on b.aqpb178codcr = a.aqpc736cre
 where b.aqpb178codcr = CREDITO_CDK
    AND b.AQPB178TFLU = 'D'
    ORDER BY A.AQPC736FPAG;
   
  BEGIN
     
   LC_MSG := NULL;
  
   --Instancia leer tabla AQPB178 para obtener credito credito credito, clave del credito BT, datos trx de BT
   BEGIN
      SELECT  trim(AQPB178CODCR), 
              aqpb178pgcod,
              aqpb178modcr,
              aqpb178succr,
              aqpb178mdacr,
              aqpb178papcr,
              aqpb178ctacr,
              aqpb178opecr,
              aqpb178sbopcr,
              aqpb178topecr,
              AQPB178INS
       into  
             Vc_AQPB178CODCR,  
             Vn_aqpb178pgcod, 
             Vn_aqpb178modcr, 
             Vn_aqpb178succr, 
             Vn_aqpb178mdacr, 
             Vn_aqpb178papcr, 
             Vn_aqpb178ctacr, 
             Vn_aqpb178opecr, 
             Vn_aqpb178sbopcr,
             Vn_aqpb178topecr,
             vn_AQPB178INS
      from AQPB178 f              
      where 
        aqpb178pgtx   = PN_PGCOD
        and aqpb178modtx  = PN_MODTX
        and aqpb178suctx  = PN_SUCTX
        and aqpb178tran   = PN_TRAN 
        and aqpb178reltx  = PN_RELTX
        and aqpb178fcontx = PN_FECTX
        AND F.AQPB178TFLU = 'D';
   EXCEPTION WHEN OTHERS THEN
      NULL;        
   END;  
     
   Vn_aqpb178pgtx   := PN_PGCOD; 
   Vn_aqpb178modtx  := PN_MODTX;
   Vn_aqpb178suctx  := PN_SUCTX; 
   Vn_aqpb178tran   := PN_TRAN;   
   Vn_aqpb178reltx  := PN_RELTX; 
   Vd_aqpb178fcontx := PN_FECTX;   
   
   --backup en fsd601 y fsd602 y fpp001
    --LLAMAR PROCESO GENERA BACKUPs
   PQ_CR_CREDINKA_HS.SP_ALTA_BASE(vn_AQPB178INS,Vc_AQPB178CODCR,Vd_aqpb178fcontx, 'BANTPROD',VC_CODERROR , VC_MSGERROR);
    
   -- INSTANCIA, CUENTA CREDINKA, FECHA DESEMBOLSO Bt
   -- RETORNA S- SI OBTIENE
   LC_MSG    := NULL;



 ---------------- VC_CODERROR := '0000'; ---sea agrego   
   IF VC_CODERROR = '0000' THEN --inicio validacion backup
    
       --eliminar 
       BEGIN
         DELETE FROM FSD601 F 
         WHERE F.PGCOD = Vn_aqpb178pgcod 
           AND F.PPMOD = Vn_aqpb178modcr 
           AND F.PPSUC = Vn_aqpb178succr 
           AND F.PPMDA = Vn_aqpb178mdacr 
           AND F.PPPAP = Vn_aqpb178papcr 
           AND F.PPCTA = Vn_aqpb178ctacr 
           AND F.PPOPER = Vn_aqpb178opecr 
           AND F.PPSBOP = Vn_aqpb178sbopcr
           AND F.PPTOPE = Vn_aqpb178topecr;
      EXCEPTION WHEN OTHERS THEN
        LC_MSG := 'ERROR DELETE FSD601 '||SQLCODE||' - '||SQLERRM;
      END;   
      
       BEGIN
         DELETE FROM FSD611 F 
         WHERE F.PGCOD = Vn_aqpb178pgcod 
           AND F.PPMOD = Vn_aqpb178modcr 
           AND F.PPSUC = Vn_aqpb178succr 
           AND F.PPMDA = Vn_aqpb178mdacr 
           AND F.PPPAP = Vn_aqpb178papcr 
           AND F.PPCTA = Vn_aqpb178ctacr 
           AND F.PPOPER = Vn_aqpb178opecr 
           AND F.PPSBOP = Vn_aqpb178sbopcr
           AND F.PPTOPE = Vn_aqpb178topecr;  
      EXCEPTION WHEN OTHERS THEN
        LC_MSG := LC_MSG ||' ERROR DELETE FSD611 '||SQLCODE||' - '||SQLERRM;
      END;         

       BEGIN
         DELETE FROM FPP001 F 
         WHERE F.PGCOD = Vn_aqpb178pgcod 
           AND F.AOMOD = Vn_aqpb178modcr 
           AND F.AOSUC = Vn_aqpb178succr 
           AND F.AOMDA = Vn_aqpb178mdacr 
           AND F.AOPAP = Vn_aqpb178papcr 
           AND F.AOCTA = Vn_aqpb178ctacr 
           AND F.AOOPER = Vn_aqpb178opecr 
           AND F.AOSBOP = Vn_aqpb178sbopcr
           AND F.AOTOPE = Vn_aqpb178topecr; 
      EXCEPTION WHEN OTHERS THEN
        LC_MSG := LC_MSG || ' ERROR DELETE FPP001 '||SQLCODE||' - '||SQLERRM;
      END;  
      
      IF LC_MSG IS NULL THEN --si no hay error al eliminar puede insertar
         commit; 
         --insertar en fsd601 y fsd602 y fpp001
            LN_CONT := 1;
            FOR I IN CRONOGRAMA( Vc_AQPB178CODCR ) LOOP
             ---alta invertida
             vn_alta_invertida := 99999999 - to_char(i.aqpc736fpag, 'RRRRMMDD');

              begin
                  PQ_CR_INFO_CDK.SP_LOG_CDK('AQPC737' ,Vc_AQPB178CODCR ,vn_AQPB178INS ,Vn_aqpb178pgcod ,Vn_aqpb178succr ,Vn_aqpb178modcr ,
                                                  Vn_aqpb178mdacr ,Vn_aqpb178papcr ,Vn_aqpb178ctacr ,Vn_aqpb178opecr,Vn_aqpb178sbopcr,Vn_aqpb178topecr,Vd_aqpb178fcontx ,'' ,'', '');
              end;

               --fsd601
               BEGIN
                 INSERT INTO FSD601
                   (
                   pgcod, ppmod, ppsuc, ppmda, pppap, ppcta, ppoper, ppsbop, pptope, 
                   ppfpag, pptipo, ppfval, ppfvto, pppzo, ppcap, ppint, ppnume, ppfinv, 
                   d601cd, d601mo, d601su, d601tr, d601re, d601fc, d601or, d601sb, d601co
                   )
                 VALUES
                   (
                   Vn_aqpb178pgcod, Vn_aqpb178modcr, Vn_aqpb178succr, Vn_aqpb178mdacr, Vn_aqpb178papcr, Vn_aqpb178ctacr,
                   Vn_aqpb178opecr, Vn_aqpb178sbopcr, Vn_aqpb178topecr,
                   i.aqpc736fpag, 'F', i.aqpc736fpag, i.aqpc736fval, i.plazo, i.aqpc736cap, i.aqpc736int, 0, vn_alta_invertida,  
                   Vn_aqpb178pgtx, Vn_aqpb178modtx, Vn_aqpb178suctx, Vn_aqpb178tran, Vn_aqpb178reltx, Vd_aqpb178fcontx,  10, 0, 'S'
                   );
                 COMMIT;
                 vc_flag := 'S';
              EXCEPTION WHEN OTHERS THEN
                  LC_MSG := 'ERROR INSERTAR FSD601 '||SQLCODE||' - '||SQLERRM;
                  vc_flag := 'N';
                  ---TABLA ERROR
                  VC_CODERR := '0001';
                  VC_MSGERR := SUBSTR(SQLERRM,1,150);
                  PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(vn_AQPB178INS,'','PQ_CR_INFO_CDK','SP_INSERTA_CRONOGRAMA','',VC_CODERR,VC_MSGERR);

              END; 
              begin
                  PQ_CR_INFO_CDK.SP_LOG_CDK('FSD601' ,Vc_AQPB178CODCR ,vn_AQPB178INS ,Vn_aqpb178pgcod ,Vn_aqpb178succr ,Vn_aqpb178modcr ,
                                                  Vn_aqpb178mdacr ,Vn_aqpb178papcr ,Vn_aqpb178ctacr ,Vn_aqpb178opecr,Vn_aqpb178sbopcr,Vn_aqpb178topecr,Vd_aqpb178fcontx ,vc_flag ,'', '');
              end;  
               ---fsd611
              BEGIN 
               INSERT INTO FSD611
                 (
                  pgcod, ppmod, ppsuc, ppmda, pppap, ppcta, ppoper,ppsbop,pptope,
                  ppfpag,pptipo,ppimp1,ppimp2,ppimp3,ppimp4,ppimp5,ppimp6,ppimp7,ppimp8,ppimp9,ppimp10, ppimp11,
                  ppimp12,ppimp13,ppimp14,ppimp15,ppimp16,ppimp17,ppimp18,ppimp19,ppimp20, PPEXTE
                 )
               VALUES
                 (
                  Vn_aqpb178pgcod, Vn_aqpb178modcr, Vn_aqpb178succr, Vn_aqpb178mdacr, Vn_aqpb178papcr, Vn_aqpb178ctacr,
                  Vn_aqpb178opecr, Vn_aqpb178sbopcr, Vn_aqpb178topecr,
                  i.aqpc736fpag, 'F',0,0,0,0,0,0,0,0,0,0, I.aqpc736seg,0,0,0,0,0,0,0,0,0 ,0
                  );
               COMMIT;
               vc_flag := 'S';
              EXCEPTION WHEN OTHERS THEN
                LC_MSG := 'ERROR INSERTAR FSD611 '||SQLCODE||' - '||SQLERRM;
                vc_flag := 'N';   
                  ---TABLA ERROR
                  VC_CODERR := '0002';
                  VC_MSGERR := SUBSTR(SQLERRM,1,250);
                  PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(vn_AQPB178INS,'','PQ_CR_INFO_CDK','SP_INSERTA_CRONOGRAMA','',VC_CODERR,VC_MSGERR);
             
              END;    
               begin
                         PQ_CR_INFO_CDK.SP_LOG_CDK('FSD611' ,Vc_AQPB178CODCR ,vn_AQPB178INS ,Vn_aqpb178pgcod ,Vn_aqpb178succr ,Vn_aqpb178modcr ,
                                      Vn_aqpb178mdacr ,Vn_aqpb178papcr ,Vn_aqpb178ctacr ,Vn_aqpb178opecr,Vn_aqpb178sbopcr,Vn_aqpb178topecr,Vd_aqpb178fcontx ,'',vc_flag , '');
               end; 
               --fpp001--
               --seguro 503
               IF LN_CONT = 1 then    
                   VN_SEGURO := 503;
                  BEGIN 
                     INSERT INTO FPP001
                       (
                       pgcod,aomod,aosuc,aomda,aopap, aocta,aooper,aosbop,aotope,sgcod,
                       pp001vc,pp001imp,pp001porc,pp001plus,pp001part,pp001co
                       )
                     VALUES
                       (
                       Vn_aqpb178pgcod, Vn_aqpb178modcr, Vn_aqpb178succr, Vn_aqpb178mdacr, Vn_aqpb178papcr, Vn_aqpb178ctacr,
                       Vn_aqpb178opecr, Vn_aqpb178sbopcr, Vn_aqpb178topecr,VN_SEGURO,
                       0,I.aqpc736seg, 0, 0, 100, 'X'
                       );
                     COMMIT;
                     vc_flag := 'S';
                  EXCEPTION WHEN OTHERS THEN
                    LC_MSG := 'ERROR INSERTAR FPP001 '||SQLCODE||' - '||SQLERRM;
                    vc_flag := 'N';
                       ---TABLA ERROR
                      VC_CODERR := '0003';
                      VC_MSGERR := SUBSTR(SQLERRM,1,250);
                      PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(vn_AQPB178INS,'','PQ_CR_INFO_CDK','SP_INSERTA_CRONOGRAMA','',VC_CODERR,VC_MSGERR);
                 
                    
                  END; 
                  LN_CONT := LN_CONT+ 1;
                  begin
                          PQ_CR_INFO_CDK.SP_LOG_CDK('FPP001' ,Vc_AQPB178CODCR ,vn_AQPB178INS ,Vn_aqpb178pgcod ,Vn_aqpb178succr ,Vn_aqpb178modcr ,
                                                  Vn_aqpb178mdacr ,Vn_aqpb178papcr ,Vn_aqpb178ctacr ,Vn_aqpb178opecr,Vn_aqpb178sbopcr,Vn_aqpb178topecr,Vd_aqpb178fcontx ,'', '',vc_flag );
                  end;
                END IF;
             
           END LOOP;
       ELSE
              rollback; 
       END IF;    
  ELSE
     LC_MSG := 'NO GENERO BACKUP -NO REALIZO CAMBIO DE CRONOGRAMA';
  END IF;  ---fin validacion backup 

   
END SP_INSERTA_CRONOGRAMA_1;

PROCEDURE SP_CR_ELIMINA (   Vn_aqpb178pgcod in number, 
                            Vn_aqpb178modcr in number, 
                            Vn_aqpb178succr in number, 
                            Vn_aqpb178mdacr in number, 
                            Vn_aqpb178papcr in number, 
                            Vn_aqpb178ctacr in number, 
                            Vn_aqpb178opecr  in number,   
                            Vn_aqpb178sbopcr in number,   
                            Vn_aqpb178topecr in number,
                            PC_MSG OUT VARCHAR2    
                          ) IS
   
 ---------------------------------------------------------------------------------------------------
   -- NOMBRE                      : SP_CR_ELIMINA
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 24/12/2024
   -- AUTOR DE CREACION           : DCASTRO
   -- USO                         : GRABA DATOS
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   ----------------------------------------------------------------------------------------------------

BEGIN
  
     --

      --eliminar 
       BEGIN
         DELETE FROM FSD601 F 
         WHERE F.PGCOD =  Vn_aqpb178pgcod 
           AND F.PPMOD =  Vn_aqpb178modcr 
           AND F.PPSUC =  Vn_aqpb178succr 
           AND F.PPMDA =  Vn_aqpb178mdacr 
           AND F.PPPAP =  Vn_aqpb178papcr 
           AND F.PPCTA =  Vn_aqpb178ctacr 
           AND F.PPOPER = Vn_aqpb178opecr 
           AND F.PPSBOP = Vn_aqpb178sbopcr
           AND F.PPTOPE = Vn_aqpb178topecr;
      EXCEPTION WHEN OTHERS THEN
        PC_MSG := 'ERROR DELETE FSD601 '||SQLCODE||' - '||SQLERRM;
      END;   
      
       BEGIN
         DELETE FROM FSD611 F 
         WHERE F.PGCOD = Vn_aqpb178pgcod 
           AND F.PPMOD = Vn_aqpb178modcr 
           AND F.PPSUC = Vn_aqpb178succr 
           AND F.PPMDA = Vn_aqpb178mdacr 
           AND F.PPPAP = Vn_aqpb178papcr 
           AND F.PPCTA = Vn_aqpb178ctacr 
           AND F.PPOPER = Vn_aqpb178opecr 
           AND F.PPSBOP = Vn_aqpb178sbopcr
           AND F.PPTOPE = Vn_aqpb178topecr;  
      EXCEPTION WHEN OTHERS THEN
        PC_MSG := PC_MSG ||' ERROR DELETE FSD611 '||SQLCODE||' - '||SQLERRM;
      END;         

       BEGIN
         DELETE FROM FPP001 F 
         WHERE F.PGCOD = Vn_aqpb178pgcod 
           AND F.AOMOD = Vn_aqpb178modcr 
           AND F.AOSUC = Vn_aqpb178succr 
           AND F.AOMDA = Vn_aqpb178mdacr 
           AND F.AOPAP = Vn_aqpb178papcr 
           AND F.AOCTA = Vn_aqpb178ctacr 
           AND F.AOOPER = Vn_aqpb178opecr 
           AND F.AOSBOP = Vn_aqpb178sbopcr
           AND F.AOTOPE = Vn_aqpb178topecr; 
      EXCEPTION WHEN OTHERS THEN
        PC_MSG := PC_MSG || ' ERROR DELETE FPP001 '||SQLCODE||' - '||SQLERRM;
      END;

END SP_CR_ELIMINA;

   /*===================================================================================================*/
   PROCEDURE SP_CR_CUOTAS_PAGADAS(P_CODCDK IN VARCHAR2,
                                  P_RESPTA OUT VARCHAR2) IS
                                  
   -- ====================================================================================================
   -- NOMBRE                      : SP_CR_CUOTAS_PAGADAS
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 09/01/2025
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : RETORNA LAS CUOTAS PAGADAS
   -- PARAMETROS                  : P_CODCDK | VARCHAR2(50)
   --                               P_RESPTA | VARCHAR2(250)
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   -- ====================================================================================================
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   -- ====================================================================================================
   
   V_RESPTA VARCHAR2(250) := NULL;
                      
   BEGIN
      BEGIN
         SELECT B.AQPC736NCUO || '/' || A.AQPB178NCORCDK
           INTO V_RESPTA
           FROM AQPB178 A, AQPC736 B
          WHERE A.AQPB178CODCR = P_CODCDK
            AND A.AQPB178TFLU  = 'D'
            AND B.AQPC736CRE   = A.AQPB178CODCR
            AND B.AQPC736FPAG  = (SELECT MAX(T.PPFPAG)
                                    FROM FSD602 T
                                   WHERE T.PGCOD   = A.AQPB178PGCOD
                                     AND T.PPMOD   = A.AQPB178MODCR
                                     AND T.PPSUC   = A.AQPB178SUCCR
                                     AND T.PPMDA   = A.AQPB178MDACR
                                     AND T.PPPAP   = A.AQPB178PAPCR
                                     AND T.PPCTA   = A.AQPB178CTACR
                                     AND T.PPOPER  = A.AQPB178OPECR
                                     AND T.PPSBOP  = A.AQPB178SBOPCR
                                     AND T.PPTOPE  = A.AQPB178TOPECR
                                     AND T.PP1STAT = 'T'
                                     AND T.D602CO  = 'S');
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      P_RESPTA := V_RESPTA;
      
   END SP_CR_CUOTAS_PAGADAS;

   
END PQ_CR_INFO_CDK;
/

