create or replace package "PQ_CR_CREDINKA_HS" is

  -- Author  : HSUAREZ
  -- Created : 23/12/2024 11:38:32
  -- Purpose : Paquete para procesar credinka, backups...
  
  PROCEDURE SP_ALTA_BASE(VE_N_INSTANCIA IN NUMBER,
                         VE_V_CUENTA_CDK IN VARCHAR,
                         VE_D_FECHA_ALTA IN DATE,
                         VO_V_USER IN CHAR,
                         VO_V_COD_ERROR OUT VARCHAR,
                         VO_V_MSG_ERROR OUT VARCHAR
                         );
  PROCEDURE SP_BACKUP_FSD601_CDK(
                                  VE_INSTANCIA IN NUMBER,  
                                  VE_CORRELATIVO IN NUMBER,
                                  VE_FECHA IN DATE,
                                  VO_V_COD_ERROR OUT VARCHAR,
                                  VO_V_MSG_ERROR OUT VARCHAR
                                );
  PROCEDURE SP_BACKUP_FSD611_CDK(
                                  VE_INSTANCIA IN NUMBER,  
                                  VE_CORRELATIVO IN NUMBER,
                                  VE_FECHA IN DATE,
                                  VO_V_COD_ERROR OUT VARCHAR,
                                  VO_V_MSG_ERROR OUT VARCHAR
                                );
  PROCEDURE SP_BACKUP_FPP001_CDK(
                                  VE_N_INSTANCIA IN NUMBER,  
                                  VE_CORRELATIVO IN NUMBER,
                                  VE_FECHA IN DATE,
                                  VO_V_COD_ERROR OUT VARCHAR,
                                  VO_V_MSG_ERROR OUT VARCHAR
                                );
  PROCEDURE SP_OBTENER_CLV_CRD( VE_INSTANCIA IN NUMBER,
                                VO_N_EMP OUT NUMBER,
                                VO_N_MOD OUT NUMBER,
                                VO_N_SUC OUT NUMBER,
                                VO_N_MDA OUT NUMBER,
                                VO_N_PAP OUT NUMBER,
                                VO_N_CTA OUT NUMBER,
                                VO_N_OPE OUT NUMBER, 
                                VO_N_SBO OUT NUMBER,
                                VO_N_TOP OUT NUMBER,
                                VO_V_COD_ERROR OUT VARCHAR,
                                VO_V_MSG_ERROR OUT VARCHAR
                              );

end PQ_CR_CREDINKA_HS;
 /* GOLDENGATE_DDL_REPLICATION */
/

create or replace package body "PQ_CR_CREDINKA_HS" is
  PROCEDURE SP_ALTA_BASE(VE_N_INSTANCIA IN NUMBER,
                         VE_V_CUENTA_CDK IN VARCHAR,
                         VE_D_FECHA_ALTA IN DATE,
                         VO_V_USER IN CHAR,
                         VO_V_COD_ERROR OUT VARCHAR,
                         VO_V_MSG_ERROR OUT VARCHAR
                         )
  IS
  VO_N_EMP XWF700.XWFEMPRESA%TYPE;
  VO_N_MOD XWF700.XWFMODULO%TYPE;
  VO_N_SUC XWF700.XWFSUCURSAL%TYPE;
  VO_N_MDA XWF700.XWFMONEDA%TYPE;
  VO_N_PAP XWF700.XWFPAPEL%TYPE;
  VO_N_CTA XWF700.XWFCUENTA%TYPE;
  VO_N_OPE XWF700.XWFOPERACION%TYPE;
  VO_N_SBO XWF700.XWFSUBOPE%TYPE;
  VO_N_TOP XWF700.XWFTIPOPE%TYPE;
  ---
  VI_N_AQPB178CODCR AQPB178.AQPB178CODCR%TYPE;
  VI_N_aqpb178pgtx  AQPB178.AQPB178PGTX%TYPE;
  VI_N_aqpb178modtx AQPB178.AQPB178MODTX%TYPE;
  VI_N_aqpb178suctx AQPB178.AQPB178SUCTX%TYPE;
  VI_N_aqpb178tran  AQPB178.AQPB178TRAN%TYPE;
  VI_N_aqpb178reltx AQPB178.AQPB178RELTX%TYPE;
  VI_D_aqpb178fcontx AQPB178.AQPB178FCONTX%TYPE;
  ---
  VI_N_AQPD756COD AQPD756.AQPD756COD%TYPE;
  ---
  BEGIN
    VO_V_COD_ERROR := '0000';
    VO_V_MSG_ERROR := '';
    --OBTENEMOS LA CLAVE DEL CREDITO
    PQ_CR_CREDINKA_HS.SP_OBTENER_CLV_CRD( VE_N_INSTANCIA,
                                          VO_N_EMP,
                                          VO_N_MOD,
                                          VO_N_SUC,
                                          VO_N_MDA,
                                          VO_N_PAP,
                                          VO_N_CTA,
                                          VO_N_OPE,
                                          VO_N_SBO,
                                          VO_N_TOP,
                                          VO_V_COD_ERROR,
                                          VO_V_MSG_ERROR
                                        );
    --OBTENER DATOS CREDINKA
    BEGIN
        SELECT AQPB178CODCR,
               aqpb178pgtx,
               aqpb178modtx,
               aqpb178suctx,
               aqpb178tran,
               aqpb178reltx,
               aqpb178fcontx
          into VI_N_AQPB178CODCR,
               VI_N_aqpb178pgtx,
               VI_N_aqpb178modtx,
               VI_N_aqpb178suctx,
               VI_N_aqpb178tran,
               VI_N_aqpb178reltx,
               VI_D_aqpb178fcontx
          from AQPB178 f
         where f.AQPB178INS  = VE_N_INSTANCIA
           AND F.AQPB178TFLU = 'D';
    EXCEPTION
       WHEN OTHERS THEN
         VO_V_COD_ERROR := '0001';
         VO_V_MSG_ERROR := '0001-'||SUBSTR(SQLERRM,1,150); 
         
    END;
    --INSERTAMOS LOS DATOS.
    BEGIN
       INSERT INTO AQPD756 D (D.AQPD756INST,D.AQPD756PGCOD,D.AQPD756MOD,D.AQPD756SUC,D.AQPD756MDA,
                              D.AQPD756PAP,D.AQPD756CTA,D.AQPD756OPER,D.AQPD756SBOP,D.AQPD756TOPE,
                              D.AQPD756CTACRK,D.AQPD756CDTCOD,D.AQPD756CDTSUC,D.AQPD756CDTMOD,
                              D.AQPD756CDTTRANC,D.AQPD756CDTNREL,D.AQPD756CDTFCH,D.AQPD756FCHDES,
                              D.AQPD756USUREG,D.AQPD756FCHREG,D.AQPD756HREG)
       VALUES(VE_N_INSTANCIA, VO_N_EMP,VO_N_MOD,VO_N_SUC,VO_N_MDA,
                              VO_N_PAP,VO_N_CTA,VO_N_OPE,VO_N_SBO,VO_N_TOP,
                              VE_V_CUENTA_CDK,VI_N_aqpb178pgtx,VI_N_aqpb178suctx,VI_N_aqpb178modtx, 
                              VI_N_aqpb178tran,VI_N_aqpb178reltx,VI_D_aqpb178fcontx,VE_D_FECHA_ALTA,
                              VO_V_USER,TRUNC(SYSDATE),TO_CHAR(SYSDATE,'HH24:MI:SS'))
       RETURNING AQPD756COD INTO VI_N_AQPD756COD;
       DBMS_OUTPUT.PUT_LINE('El valor generado para AQPD756COD es: ' || VI_N_AQPD756COD);
       COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        VO_V_COD_ERROR := '0002';
        VO_V_MSG_ERROR := '0002-'||SUBSTR(SQLERRM,1,150);
        
    END;
  
    --BACKUPS
    IF VI_N_AQPD756COD > 0 THEN
      --FSD601 -     
      begin
        PQ_CR_CREDINKA_HS.SP_BACKUP_FSD601_CDK(
                                                VE_N_INSTANCIA,
                                                VI_N_AQPD756COD,
                                                VE_D_FECHA_ALTA,
                                                VO_V_COD_ERROR,
                                                VO_V_MSG_ERROR
                                              );
      end;
      --FSD611     
      begin
        PQ_CR_CREDINKA_HS.SP_BACKUP_FSD611_CDK(
                                                VE_N_INSTANCIA,
                                                VI_N_AQPD756COD,
                                                VE_D_FECHA_ALTA,
                                                VO_V_COD_ERROR,
                                                VO_V_MSG_ERROR
                                              );
      end;
      --FPP001 -     
      begin
        PQ_CR_CREDINKA_HS.SP_BACKUP_FPP001_CDK(
                                                VE_N_INSTANCIA,
                                                VI_N_AQPD756COD,
                                                VE_D_FECHA_ALTA,
                                                VO_V_COD_ERROR,
                                                VO_V_MSG_ERROR
                                              );
      end;
     END IF;
  EXCEPTION
    WHEN OTHERS THEN
       NULL;
  END;
  
  PROCEDURE SP_BACKUP_FSD601_CDK(
                                  VE_INSTANCIA IN NUMBER,  
                                  VE_CORRELATIVO IN NUMBER,
                                  VE_FECHA IN DATE,
                                  VO_V_COD_ERROR OUT VARCHAR,
                                  VO_V_MSG_ERROR OUT VARCHAR
                                )
  IS
  VO_N_EMP XWF700.XWFEMPRESA%TYPE;
  VO_N_MOD XWF700.XWFMODULO%TYPE;
  VO_N_SUC XWF700.XWFSUCURSAL%TYPE;
  VO_N_MDA XWF700.XWFMONEDA%TYPE;
  VO_N_PAP XWF700.XWFPAPEL%TYPE;
  VO_N_CTA XWF700.XWFCUENTA%TYPE;
  VO_N_OPE XWF700.XWFOPERACION%TYPE;
  VO_N_SBO XWF700.XWFSUBOPE%TYPE;
  VO_N_TOP XWF700.XWFTIPOPE%TYPE;
  BEGIN
      VO_V_COD_ERROR := '0000';
      VO_V_MSG_ERROR := '';
      --OBTENEMOS LA CLAVE DEL CREDITO
      PQ_CR_CREDINKA_HS.SP_OBTENER_CLV_CRD( VE_INSTANCIA,
                                            VO_N_EMP,
                                            VO_N_MOD,
                                            VO_N_SUC,
                                            VO_N_MDA,
                                            VO_N_PAP,
                                            VO_N_CTA,
                                            VO_N_OPE,
                                            VO_N_SBO,
                                            VO_N_TOP,
                                            VO_V_COD_ERROR,
                                            VO_V_MSG_ERROR
                                          );
      --INSERTAR BACKUP
      BEGIN
          INSERT INTO AQPC234 A (A.AQPC234PGCOD,A.AQPC234PPMOD,A.AQPC234PPSUC,A.AQPC234PPMDA,A.AQPC234PPPAP,
                                 A.AQPC234PPCTA,A.AQPC234PPOPER,A.AQPC234PPSBOP,A.AQPC234PPTOPE,
                                 A.AQPC234PPFPAG,A.AQPC234PPTIPO,A.AQPC234PPFVAL,A.AQPC234PPFVTO,A.AQPC234PPPZO,
                                 A.AQPC234PPCAP,A.AQPC234PPINT,A.AQPC234PPINTMEX,A.AQPC234PPICAP,A.AQPC234PPIINT,
                                 A.AQPC234PPSTAT,A.AQPC234PPNUME,A.AQPC234PPFINV,
                                 A.AQPC234D601CD,A.AQPC234D601MO,A.AQPC234D601SU,A.AQPC234D601TR,A.AQPC234D601RE,
                                 A.AQPC234D601FC,A.AQPC234D601OR,A.AQPC234D601SB,A.AQPC234D601CO,
                                 A.AQPC234DCORR,A.AQPC234DFEC)
                      SELECT D.*,VE_CORRELATIVO,VE_FECHA FROM FSD601 D
                      WHERE D.PGCOD  = VO_N_EMP
                        AND D.PPMOD  = VO_N_MOD
                        AND D.PPSUC  = VO_N_SUC
                        AND D.PPMDA  = VO_N_MDA
                        AND D.PPPAP  = VO_N_PAP
                        AND D.PPCTA  = VO_N_CTA  
                        AND D.PPOPER = VO_N_OPE
                        AND D.PPSBOP = VO_N_SBO
                        AND D.PPTOPE = VO_N_TOP;
         COMMIT;
       EXCEPTION
         WHEN OTHERS THEN
           VO_V_COD_ERROR := '0003';
           VO_V_MSG_ERROR := '0003-'||SUBSTR(SQLERRM,1,150);           
       END;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;  
  ---
  PROCEDURE SP_BACKUP_FSD611_CDK(
                                  VE_INSTANCIA IN NUMBER,  
                                  VE_CORRELATIVO IN NUMBER,
                                  VE_FECHA IN DATE,
                                  VO_V_COD_ERROR OUT VARCHAR,
                                  VO_V_MSG_ERROR OUT VARCHAR
                                )
  IS
  VO_N_EMP XWF700.XWFEMPRESA%TYPE;
  VO_N_MOD XWF700.XWFMODULO%TYPE;
  VO_N_SUC XWF700.XWFSUCURSAL%TYPE;
  VO_N_MDA XWF700.XWFMONEDA%TYPE;
  VO_N_PAP XWF700.XWFPAPEL%TYPE;
  VO_N_CTA XWF700.XWFCUENTA%TYPE;
  VO_N_OPE XWF700.XWFOPERACION%TYPE;
  VO_N_SBO XWF700.XWFSUBOPE%TYPE;
  VO_N_TOP XWF700.XWFTIPOPE%TYPE;  
  
  BEGIN
    VO_V_COD_ERROR := '0000';
    VO_V_MSG_ERROR := '';
    --OBTENEMOS LA CLAVE DEL CREDITO
    PQ_CR_CREDINKA_HS.SP_OBTENER_CLV_CRD( VE_INSTANCIA,
                                          VO_N_EMP,
                                          VO_N_MOD,
                                          VO_N_SUC,
                                          VO_N_MDA,
                                          VO_N_PAP,
                                          VO_N_CTA,
                                          VO_N_OPE,
                                          VO_N_SBO,
                                          VO_N_TOP,
                                          VO_V_COD_ERROR,
                                          VO_V_MSG_ERROR
                                        );
    BEGIN
      INSERT INTO AQPD754 A (A.PGCOD,A.PPMOD,A.PPSUC,A.PPMDA,A.PPPAP,A.PPCTA,A.PPOPER,A.PPSBOP,A.PPTOPE,
                             A.PPFPAG,A.PPTIPO,A.PPEXTE,A.PPIMP1,A.PPIMP2,A.PPIMP3,A.PPIMP4,A.PPIMP5,A.PPIMP6,
                             A.PPIMP7,A.PPIMP8,A.PPIMP9,A.PPIMP10,A.PPIMP11,A.PPIMP12,A.PPIMP13,A.PPIMP14,
                             A.PPIMP15,A.PPIMP16,A.PPIMP17,A.PPIMP18,A.PPIMP19,A.PPIMP20,
                             A.AQPD754COD,A.AQPD754FCHDES)
                  SELECT D.*,VE_CORRELATIVO,VE_FECHA FROM FSD611 D
                  WHERE D.PGCOD  = VO_N_EMP
                    AND D.PPMOD  = VO_N_MOD
                    AND D.PPSUC  = VO_N_SUC
                    AND D.PPMDA  = VO_N_MDA
                    AND D.PPPAP  = VO_N_PAP
                    AND D.PPCTA  = VO_N_CTA  
                    AND D.PPOPER = VO_N_OPE
                    AND D.PPSBOP = VO_N_SBO
                    AND D.PPTOPE = VO_N_TOP;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
         VO_V_COD_ERROR := '0004';
         VO_V_MSG_ERROR := '0004-'||SUBSTR(SQLERRM,1,150);
         
    END;  
  END;
  PROCEDURE SP_BACKUP_FPP001_CDK(
                                  VE_N_INSTANCIA IN NUMBER,  
                                  VE_CORRELATIVO IN NUMBER,
                                  VE_FECHA IN DATE,
                                  VO_V_COD_ERROR OUT VARCHAR,
                                  VO_V_MSG_ERROR OUT VARCHAR
                                )
  IS 
  VO_N_EMP XWF700.XWFEMPRESA%TYPE;
  VO_N_MOD XWF700.XWFMODULO%TYPE;
  VO_N_SUC XWF700.XWFSUCURSAL%TYPE;
  VO_N_MDA XWF700.XWFMONEDA%TYPE;
  VO_N_PAP XWF700.XWFPAPEL%TYPE;
  VO_N_CTA XWF700.XWFCUENTA%TYPE;
  VO_N_OPE XWF700.XWFOPERACION%TYPE;
  VO_N_SBO XWF700.XWFSUBOPE%TYPE;
  VO_N_TOP XWF700.XWFTIPOPE%TYPE; 
  BEGIN
    --OBTENEMOS LA CLAVE DEL CREDITO
    PQ_CR_CREDINKA_HS.SP_OBTENER_CLV_CRD( VE_N_INSTANCIA,
                                          VO_N_EMP,
                                          VO_N_MOD,
                                          VO_N_SUC,
                                          VO_N_MDA,
                                          VO_N_PAP,
                                          VO_N_CTA,
                                          VO_N_OPE,
                                          VO_N_SBO,
                                          VO_N_TOP,
                                          VO_V_COD_ERROR,
                                          VO_V_MSG_ERROR
                                        );
    --
    --INSERTAR BACKUP
      BEGIN
          INSERT INTO AQPC235 A (A.AQPC235PGCOD,A.AQPC235AOMOD,A.AQPC235AOSUC,A.AQPC235AOMDA,A.AQPC235AOPAP,
                                 A.AQPC235AOCTA,A.AQPC235AOOPER,A.AQPC235AOSBOP,A.AQPC235AOTOPE,
                                 A.AQPC235SGCOD,A.AQPC235PP001VC,A.AQPC235PP001IMP,A.AQPC235PP001PORC,A.AQPC235PP001PLUS,
                                 A.AQPC235PP001PART,A.AQPC235PP001VEH,A.AQPC235PP001INM,A.AQPC235PP001END,A.AQPC235PP001STAT,
                                 A.AQPC235PP001CO,A.AQPC235PP001AUX1,A.AQPC235PP001AUX2,A.AQPC235PP001AUX3,
                                 A.AQPC235PP001AUX4,A.AQPC235PP001AUX5,A.AQPC235PP001AUX6,A.AQPC235PP001AUX7,
                                 A.AQPC235CORR,A.AQPC235FEC)                                 
                      SELECT F.*,VE_CORRELATIVO,VE_FECHA FROM FPP001 F                      
                      WHERE F.PGCOD  = VO_N_EMP
                        AND F.AOMOD  = VO_N_MOD
                        AND F.AOSUC  = VO_N_SUC
                        AND F.AOMDA  = VO_N_MDA
                        AND F.AOPAP  = VO_N_PAP
                        AND F.AOCTA  = VO_N_CTA  
                        AND F.AOOPER = VO_N_OPE
                        AND F.AOSBOP = VO_N_SBO
                        AND F.AOTOPE = VO_N_TOP;
           COMMIT;
       EXCEPTION
         WHEN OTHERS THEN
           VO_V_COD_ERROR := '0005';
           VO_V_MSG_ERROR := '0005-'||SUBSTR(SQLERRM,1,150);
           
       END;
  EXCEPTION 
    WHEN OTHERS THEN
      NULL;
  END;                                        
  PROCEDURE SP_OBTENER_CLV_CRD( VE_INSTANCIA IN NUMBER,
                                VO_N_EMP OUT NUMBER,
                                VO_N_MOD OUT NUMBER,
                                VO_N_SUC OUT NUMBER,
                                VO_N_MDA OUT NUMBER,
                                VO_N_PAP OUT NUMBER,
                                VO_N_CTA OUT NUMBER,
                                VO_N_OPE OUT NUMBER, 
                                VO_N_SBO OUT NUMBER,
                                VO_N_TOP OUT NUMBER,
                                VO_V_COD_ERROR OUT VARCHAR,
                                VO_V_MSG_ERROR OUT VARCHAR
                              )
  IS
  
  BEGIN
      VO_V_COD_ERROR := '0000';
      VO_V_MSG_ERROR := ''; 
      BEGIN
        SELECT X.XWFEMPRESA, X.XWFSUCURSAL, X.XWFMODULO,
               X.XWFMONEDA, X.XWFPAPEL, X.XWFCUENTA,
               X.XWFOPERACION,X.XWFSUBOPE,X.XWFTIPOPE
          INTO VO_N_EMP,VO_N_SUC,VO_N_MOD,
               VO_N_MDA,VO_N_PAP,VO_N_CTA,
               VO_N_OPE,VO_N_SBO,VO_N_TOP          
          FROM XWF700 X WHERE X.XWFPRCINS = VE_INSTANCIA
            AND XWFCAR3='1';
          COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
           VO_V_COD_ERROR := '0006';
           VO_V_MSG_ERROR := '0006-'||SUBSTR(SQLERRM,1,150);  
           
      END;     
  END;
                              
end PQ_CR_CREDINKA_HS;
 /* GOLDENGATE_DDL_REPLICATION */
/

