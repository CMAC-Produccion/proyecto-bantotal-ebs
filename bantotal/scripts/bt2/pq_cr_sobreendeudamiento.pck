create or replace package pq_cr_sobreendeudamiento is

  -- Author  : HSUAREZ
  -- Created : 4/02/2021 15:53:23
  -- Purpose : Paquete pra procesar el sobrenedeudamiento

  --------------------------------
  --PROCEDIMINETO PRINCIPAL
  --------------------------------
  
   PROCEDURE sp_procesar(ve_instancia in number,
                        ve_fecha     in date,
                        ve_Pepais    in number,
                        ve_Petdoc    in number,
                        ve_Pendoc    in varchar,
                        vo_CSOBEND   out varchar);
                        
  PROCEDURE sp_procesar2(ve_instancia in number,
                        ve_fecha     in date,
                        ve_Pepais    in number,
                        ve_Petdoc    in number,
                        ve_Pendoc    in varchar,
                        vo_CSOBEND   out varchar);
  --------------------------------------
  --------------------------------------
  PROCEDURE SP_EVALUAR_CRITERIOS(ve_JAQY490ASEG      in number,
                                 ve_nSegInd          in number,
                                 ve_nCuoRes          in number,
                                 ve_nRatDeuTotPat    in number,
                                 ve_JAQY490VEN       in number,
                                 ve_JAQY490LTC       in number,
                                 ve_Jaqy490vsi       in number,
                                 ve_nRatDeuTotIngBru in number,
                                 vo_ln_valcri1       out number,
                                 vo_ln_valcri2       out number,
                                 vo_ln_valcri3       out number,
                                 vo_ln_valcri4       out number,
                                 vo_ln_valsob        out number);
  --------------------------------------
  --------------------------------------
  --PROCEDURE SP_VALIDAR_EXCEPTION();
  PROCEDURE SP_CRITERIO_CUOTA_RESULTADO(ve_XWfModulo   in number,
                                        ve_cTipCre     in number,
                                        ve_SNG001Ori   in number,
                                        ve_Jaqy490aseg in number,
                                        ve_nCuoRes     in number,
                                        vo_ln_valcri1  out number,
                                        vo_ln_valsob   out number);
  PROCEDURE SP_EVAL_POL_INDEPENDIENTE(ve_RNG50Grp  in number,
                                      ve_XWfModulo in number,
                                      ve_cTipCre   in number,
                                      ve_SNG001Ori in number,
                                      ve_nCuoRes   in number,
                                      vo_cCumCri   out varchar);
  PROCEDURE SP_EVAL_POL_DEPENDIENTE(ve_RNG50Grp  in number,
                                    ve_XWfModulo in number,
                                    ve_cTipCre   in number,
                                    ve_SNG001Ori in number,
                                    ve_nCuoRes   in number,
                                    vo_cCumCri   out varchar);
  PROCEDURE SP_EVALUAR_ITEM(ve_RNG51Ope   in varchar,
                            ve_nValIzq    in number,
                            ve_RNG50Grp   in number,
                            ve_RNG51Cod   in number,
                            ve_RNG51Val   in varchar,
                            vo_nNumItmVal out number);
  /*
  PROCEDURE SP_REGISTRAR_VARIABLES(ve_ln_valcri1 in varchar2,ve_ln_valcri2 in varchar2,ve_ln_valcri3 in varchar2,
                                   ve_ln_valcri4 in varchar2,ln_valsob in varchar2,ve_JAQY490ASEG in number,
                                   ve_nRatDeuTotPat in number);
                                   */
  PROCEDURE SP_VAR_DEPEND_CONSUMO(ve_instancia        in number,
                                  ve_fechad           in date,
                                  ve_SNG021Eval       in number,
                                  ve_JAQY490CPO       in number,
                                  ve_JAQY490STD       in number,
                                  ve_SNG120TCbi       in number,
                                  ve_nCuoCajAqp       in number,
                                  vo_nIngTot          out number,
                                  vo_nCuoRes          out number,
                                  vo_nRatDeuTotIngBru out number,
                                  vo_nCuoSF           out number,
                                  vo_nCuoTot          out number,
                                  vo_nRatCapPag       out number,
                                  vo_nIngBru          out number);
  -------------------------------------------
  PROCEDURE SP_VAR_INDEPEND_PYME(ve_instancia        in number,
                                 ve_pepais           in number,
                                 ve_petdoc           in number,
                                 ve_cNumdoc          in varchar,
                                 ve_fechad           in date,
                                 ve_SNG021Eval       in number,
                                 ve_JAQY490CPO       in number,
                                 ve_JAQY490STD       in number,
                                 ve_JAQY490DTI       in number,
                                 ve_SNG120TCbi       in number,
                                 ve_nCuoCajAqp       in number,
                                 vo_nCuoRes          out number,
                                 vo_nRatDeuTotIngBru out number,
                                 --vo_nIngTot out number,vo_nCuoRes out number,vo_nRatDeuTotIngBru out number,
                                 -- vo_nCuoSF out number,
                                 vo_nRatDeuTotPat    out number,
                                 vo_nCuoSF           out number,
                                 vo_nCuoTot          out number,
                                 vo_nRatCapPag       out number,
                                 vo_nIngBru          out number,
                                 vo_nVentas          out number,
                                 vo_nOtrIng          out number,
                                 vo_nIngNet          out number,
                                 vo_nUtiNet          out number,
                                 vo_nSegInd          out number,
                                 vo_nRatCuoTotResNet out number,
                                 vo_nResNetMen       out number,
                                 vo_nTotPas          out number,
                                 vo_nTotPat          out number,
                                 vo_nDeuTotIngNetMen out number);
  ----------------------------------------------
  procedure SP_VALIDAR_EXCEPTION(ve_cTipCre     in varchar,
                                 ve_XWfModulo   in varchar,
                                 ve_instancia   in number,
                                 vo_JAQY490AEXC out varchar,
                                 vo_JAQY490ACOM out varchar,
                                 vo_cSOBEND     in out varchar,
                                 vo_ln_valcri1  out number,
                                 vo_ln_valcri2  out number,
                                 vo_ln_valcri3  out number,
                                 vo_ln_valcri4  out number);
  --------------------------------------
  --------------------------------------
  procedure sp_cr_SegmntoActual(ln_Instancia     in number,
                                lc_SegmntoActual out number);
  --------------------------------------

  procedure sp_cr_CuotaEstimad(ln_mod10   in number,
                               ln_suc10   in number,
                               ln_mda10   in number,
                               ln_pap10   in number,
                               ln_cta10   in number,
                               ln_oper10  in number,
                               ln_sbop10  in number,
                               ln_tope10  in number,
                               tipocambio in number,
                               ln_formula out number);
end pq_cr_sobreendeudamiento;
/

create or replace package body pq_cr_sobreendeudamiento is

  --------------------------------
  --PROCEDIMINETO PRINCIPAL
  --------------------------------
  PROCEDURE sp_procesar(ve_instancia in number,
                        ve_fecha     in date,
                        ve_Pepais    in number,
                        ve_Petdoc    in number,
                        ve_Pendoc    in varchar,
                        vo_CSOBEND   out varchar) is
  BEGIN
    
    BEGIN
      SELECT TO_CHAR(S.JAQY490SOB)
        INTO vo_CSOBEND 
        FROM JAQY490S S WHERE
        S.JAQY490INS = ve_instancia
        AND S.jaqy490fec = (select max(A.jaqy490fec) FROM JAQY490S A WHERE A.JAQY490INS=ve_instancia);
    exception 
      when others then
           vo_CSOBEND := 0;   
      END;
    END;                      
  PROCEDURE sp_procesar2(ve_instancia in number,
                        ve_fecha     in date,
                        ve_Pepais    in number,
                        ve_Petdoc    in number,
                        ve_Pendoc    in varchar,
                        vo_CSOBEND   out varchar) is
    --variables iniciales
  
    --variables inciales del sistema financiero
    /*
    vi_JAQY490CPO  NUMBER(20,5);
    vi_JAQY490LTC  NUMBER(20,5);
    vi_JAQY490VSD  NUMBER(20,5);
    vi_JAQY490vsi  NUMBER(20,5);
    vi_JAQY490VNE  NUMBER(20,5);
    vi_JAQY490VEN  NUMBER(10);
    vi_JAQY490NEN  NUMBER(10);
    vi_JAQY490DTI  NUMBER(20,5);
    vi_JAQY490DTC  NUMBER(20,5);
    
    vi_JAQY490LCN  NUMBER(12,2);
    vi_JAQY490SUT  NUMBER(12,2);
    vi_JAQY490STD  NUMBER(12,2);
    */
    vi_JAQY490COC JAQY490.JAQY490COC%TYPE;
    vi_JAQY490LCN JAQY490.JAQY490LCN%TYPE;
    vi_JAQY490SUT JAQY490.JAQY490SUT%TYPE;
    vi_JAQY490STD JAQY490.JAQY490STD%TYPE;
  
    vi_JAQY490SUTCON NUMBER(17, 2);
    vi_JAQY490LCNCON number(17, 2);
    vi_SNG120TCbi    NUMBER(17, 4);
    vi_SNG001SEG     sng001.sng001seg%type;
    vi_SNG01ICUOT    sng001.sng01icuot%type;
    vi_XWFMONEDA     xwf700.xwfmoneda%type;
    vi_XWFMODULO     xwf700.xwfmodulo%type;
    vi_XWFCAR3       xwf700.xwfcar3%type;
    vi_xwfempresa    xwf700.xwfempresa%type;
    vi_xwfsucursal   xwf700.xwfsucursal%type;
    vi_xwfpapel      xwf700.xwfpapel%type;
    vi_xwfcuenta     xwf700.xwfcuenta%type;
    vi_xwfoperacion  xwf700.xwfoperacion%type;
    vi_xwfsubope     xwf700.xwfsubope%type;
    vi_xwftipope     xwf700.xwftipope%type;
    
    
    vi_nCuoCajAqpMN  number(17, 2);
    vi_nCuoCajAqpME  number(17, 2);
    --vi_NCUOCAJAQP NUMBER(17,2);
    vi_TIP_CRD VARCHAR(12);
    vi_ncuores NUMBER(17, 2);
  
    vi_WFATTSVAL WFATTSVALUES.WFATTSVAL%TYPE;
    vi_SNG001ORI SNG001.SNG001ORI%TYPE;
  
    --variables para el insert faltantes
    vi_JAQY490CPOcon    JAQY490A.JAQY490ACPO%TYPE;
    vi_JAQY490CUCcon    JAQY490A.JAQY490ACUC%TYPE;
    vi_JAQY490DTIcon    JAQY490A.JAQY490ADTIC%TYPE;
    vi_nRatDeuTotIngBru JAQY490A.JAQY490ARDI%TYPE;
    vi_JAQY490ACR       JAQY490A.JAQY490ACR%TYPE;
    vi_JAQY490ACOM      JAQY490A.JAQY490ACOM%TYPE;
    vi_cSOBEND          JAQY490A.JAQY490ASOB%TYPE;
    vi_JAQY490ACRI1     JAQY490A.JAQY490ACRI1%TYPE;
    vi_JAQY490ACRI2     JAQY490A.JAQY490ACRI2%TYPE;
    vi_JAQY490ACRI3     JAQY490A.JAQY490ACRI3%TYPE;
    vi_JAQY490ACRI4     JAQY490A.JAQY490ACRI4%TYPE;
    vi_JAQY490AEXC      JAQY490A.JAQY490AEXC%TYPE;
    vi_cFlgOtrIng       JAQY490A.JAQY490AFLGOTRING%TYPE;
    vi_nRazCapPag       JAQY490A.JAQY490ARAZCAPPAG%TYPE;
    vi_nRazApcIng       JAQY490A.JAQY490ARAZAPCING%TYPE;
    vi_JAQY490VSI       JAQY490A.JAQY490AVSI%TYPE;
    vi_nDeuTotIngNetMen JAQY490A.JAQY490ADEUING%TYPE;
    vi_nRatCuoTotResNet JAQY490A.JAQY490ARATCUORES%TYPE;
    vi_nRatDeuTotPat    JAQY490A.JAQY490ARATDEUPAT%TYPE;
    vi_nSegInd          JAQY490A.JAQY490ASEGIND%TYPE;
    vi_JAQY490DTC       JAQY490A.JAQY490ADTC%TYPE;
    vi_JAQY490DTI       JAQY490A.JAQY490ADTI%TYPE;
    vi_JAQY490VEN       JAQY490A.JAQY490AVEN%TYPE;
    vi_JAQY490NEN       JAQY490A.JAQY490ANEN%TYPE;
    vi_JAQY490AMLTCSF   JAQY490A.JAQY490AMLTCSF%TYPE;
    vi_JAQY490LTC       JAQY490A.JAQY490ALTC%TYPE;
    vi_JAQY490VSD       JAQY490A.JAQY490AVSD%TYPE;
    vi_JAQY490VNE       JAQY490A.JAQY490AVNE%TYPE;
    vi_nRatCapPag       JAQY490A.JAQY490ARATCAP%TYPE;
    vi_nIngTot          JAQY490A.JAQY490AINGTOT%TYPE;
    vi_nTotPat          JAQY490A.JAQY490ATOTPAT%TYPE;
    vi_nTotPas          JAQY490A.JAQY490ATOTPAS%TYPE;
    vi_nResNetMen       JAQY490A.JAQY490ARESNET%TYPE;
    vi_nUtiNet          JAQY490A.JAQY490AUTINET%TYPE;
    vi_nIngNet          JAQY490A.JAQY490AINGNET%TYPE;
    vi_nIngBru          JAQY490A.JAQY490AINGBRU%TYPE;
    vi_nOtrIng          JAQY490A.JAQY490AOTRING%TYPE;
    vi_nVentas          JAQY490A.JAQY490AVENTAS%TYPE;
    vi_nCuoTot          JAQY490A.JAQY490ACUOTOT%TYPE;
    vi_JAQY490CPO       JAQY490A.JAQY490ACPOSFI%TYPE;
    vi_nCuoSF           JAQY490A.JAQY490ACUOSFI%TYPE;
    vi_nCuoCajAqp       JAQY490A.JAQY490ACUOCAJ%TYPE;
    vi_JAQY490ASEG      JAQY490A.JAQY490ASEG%TYPE;
    --vi_SNG001Seg        JAQY490A.JAQY490ASEGINS%TYPE;
    vi_SNG021TMod  JAQY490A.JAQY490AMODEVA%TYPE;
    vi_SNG021Eval  JAQY490A.JAQY490AEVA%TYPE;
    vi_SNG021Fec   JAQY490A.JAQY490AFECEVA%TYPE;
    vi_Pgfape      JAQY490A.JAQY490AFEC%TYPE;
    vi_Pendoc      JAQY490A.JAQY490ADOC%TYPE;
    vi_Petdoc      JAQY490A.JAQY490ATDO%TYPE;
    vi_Pepais      JAQY490A.JAQY490APAI%TYPE;
    vi_JAQY490AEJE JAQY490A.JAQY490AEJE%TYPE;
  
    vi_cTipCre VARCHAR2(2);
  BEGIN
    --CARGAR DNI
    vi_Pendoc := ve_Pendoc;
    vi_Petdoc := ve_petdoc;
    vi_Pepais := ve_pepais;
    -- CARGAR VARIABLES DEL SISTEMA FINANCIERO
    BEGIN
      select JAQY490CPO,
             JAQY490LTC,
             JAQY490VSD,
             Jaqy490VSI,
             JAQY490VNE,
             JAQY490VEN,
             JAQY490NEN,
             JAQY490DTI,
             JAQY490DTC,
             JAQY490COC,
             JAQY490LCN,
             JAQY490SUT,
             JAQY490STD
        INTO vi_JAQY490CPO,
             vi_JAQY490LTC,
             vi_JAQY490VSD,
             vi_JAQY490vsi,
             vi_JAQY490VNE,
             vi_JAQY490VEN,
             vi_JAQY490NEN,
             vi_JAQY490DTI,
             vi_JAQY490DTC,
             vi_JAQY490COC,
             vi_JAQY490LCN,
             vi_JAQY490SUT,
             vi_JAQY490STD
        from JAQY490
       where jaqy490ndi = vi_pendoc
         and jaqy490per = '1';
    exception
      when others then
        begin
          select JAQY490CPO,
                 JAQY490LTC,
                 JAQY490VSD,
                 Jaqy490VSI,
                 JAQY490VNE,
                 JAQY490VEN,
                 JAQY490NEN,
                 JAQY490DTI,
                 JAQY490DTC,
                 JAQY490COC,
                 JAQY490LCN,
                 JAQY490SUT,
                 JAQY490STD
            INTO vi_JAQY490CPO,
                 vi_JAQY490LTC,
                 vi_JAQY490VSD,
                 vi_JAQY490vsi,
                 vi_JAQY490VNE,
                 vi_JAQY490VEN,
                 vi_JAQY490NEN,
                 vi_JAQY490DTI,
                 vi_JAQY490DTC,
                 vi_JAQY490COC,
                 vi_JAQY490LCN,
                 vi_JAQY490SUT,
                 vi_JAQY490STD
            FROM JAQY490
           WHERE JAQY490NDI = vi_pendoc;
        exception
          when others then
            begin
              select JAQY490CPO,
                     JAQY490LTC,
                     JAQY490VSD,
                     Jaqy490VSI,
                     JAQY490VNE,
                     JAQY490VEN,
                     JAQY490NEN,
                     JAQY490DTI,
                     JAQY490DTC,
                     JAQY490COC,
                     JAQY490LCN,
                     JAQY490SUT,
                     JAQY490STD
                INTO vi_JAQY490CPO,
                     vi_JAQY490LTC,
                     vi_JAQY490VSD,
                     vi_JAQY490vsi,
                     vi_JAQY490VNE,
                     vi_JAQY490VEN,
                     vi_JAQY490NEN,
                     vi_JAQY490DTI,
                     vi_JAQY490DTC,
                     vi_JAQY490COC,
                     vi_JAQY490LCN,
                     vi_JAQY490SUT,
                     vi_JAQY490STD
                FROM JAQY490
               WHERE JAQY490NDT = vi_pendoc;
            EXCEPTION
              WHEN OTHERS THEN
                vi_JAQY490SUT := 0;
                vi_JAQY490LCN := 0;
            end;
        end;
        IF vi_JAQY490SUT + vi_JAQY490LCN + vi_JAQY490SUTCON +
           vi_JAQY490LCNCON <> 0 THEN
          vi_JAQY490LTC := (vi_JAQY490SUT + vi_JAQY490SUTCON) /
                           (vi_JAQY490SUT + vi_JAQY490LCN +
                           vi_JAQY490SUTCON + vi_JAQY490LCNCON);
        ELSE
          vi_JAQY490LTC := 0;
        END IF;
    END;
    --FIN DE LA CARGA DE VARIABLES DEL SISTEMA FINANCIERO.
  
    --TIPO DE CAMBIO
    vi_SNG120TCbi := fn_tipo_cambio_fijo(ve_fecha);
    --FIN TIPO DE CAMBIO
  
    --SEGMENTO DE CREDITO CUOTA
    /* 
    BEGIN
        SELECT S.SNG001SEG,S.SNG01ICUOT
        INTO   vi_SNG001SEG,vi_SNG01ICUOT
        FROM SNG001 S
        WHERE SNG001INST = ve_instancia;
    END;
    */
    sp_cr_SegmntoActual(ve_instancia, vi_SNG001SEG);
    if vi_SNG001SEG = 1 then -- pyme
       vi_SNG021TMOD := 13;  --independiente
    else 
       vi_SNG021TMOD:= 14; --dependiente
    end if;
    --FIN DE SEGMENTO DE CREDITO CUOTA
  
    --RELACION INSTANCIA OPERACION
    BEGIN
      SELECT XWFMONEDA, XWFMODULO, XWFCAR3, x.xwfempresa, x.xwfsucursal, x.xwfpapel, x.xwfcuenta, x.xwfoperacion, x.xwfsubope, x.xwftipope
        INTO vi_XWFMONEDA, vi_XWFMODULO, vi_XWFCAR3, vi_xwfempresa, vi_xwfsucursal, vi_xwfpapel,  vi_xwfcuenta, vi_xwfoperacion, vi_xwfsubope, vi_xwftipope
        FROM XWF700 x
       WHERE XWFPRCINS = ve_instancia
         AND XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --FIN RELACION INSTANCIA OPERACION
  
    --obtener cuota
     sp_cr_cuotaestimad(vi_XWFMODULO, vi_xwfsucursal, vi_XWFMONEDA, vi_xwfpapel, vi_xwfcuenta, vi_xwfoperacion,
                        vi_xwfsubope, vi_xwftipope, vi_SNG120TCbi, vi_SNG01ICUOT);
    
    
    ---fin obtener cuota
  
  
    --MONTO DE LA CUOTA PROPUESTA
    IF vi_XWFMONEDA = 0 THEN
      vi_nCuoCajAqpMN := vi_SNG01ICUOT;
      vi_nCuoCajAqpME := 0;
    END IF;
    IF vi_XWFMONEDA = 101 THEN
      vi_nCuoCajAqpMN := 0;
      vi_nCuoCajAqpME := vi_SNG01ICUOT;
    END IF;
    --FIN DEL MONTO DE LA CUOTA PROPUESTA
  
    --CUOTA PROPUESTA CAJA AQP
    vi_NCUOCAJAQP := 0;
    vi_NCUOCAJAQP := vi_NCUOCAJAQPMN + (vi_NCUOCAJAQPME * vi_SNG120TCBI);
    --FIN DE CUOTA PROPUESTA CAJA AQP
  
    --TIPO DE CREDITO (se mantiene logica)
    BEGIN
      SELECT WFATTSVAL
        INTO vi_WFATTSVAL
        FROM WFATTSVALUES
       WHERE WFInsPrcId = ve_instancia
         AND WFATTSID = 'TIPO_CREDITO';
      --AND WFATTSVAL <> NullValue(vi_WFATTSVAL);
    
      --OBTENIENDO EL TIPO DE CREDITO
      IF trim(vi_WFATTSVAL) is not null THEN
       -- vi_cTipCre := Substr(trim(vi_WFATTSVAL), 1, 2) );
        vi_cTipCre := to_number(substr(vi_WFATTSVAL,
                                    1,
                                    INSTR(vi_WFATTSVAL, ';') - 1));

        
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --FIN DE TIPO DE CREDITO
  
    --ORIGEN DE LA SOLICITUD
    BEGIN
      SELECT SNG001ORI
        INTO vi_SNG001ORI
        FROM SNG001
       WHERE SNG001INST = ve_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --FIN DEL ORIGEN DE LA SOLICITUD 
  
    ---VALIDAR SI SE CARGAN VARIABLES DEPENDIENTES CONSUMO O PYMES
    BEGIN
      IF vi_SNG021TMOD = 14 THEN
        vi_Jaqy490aseg := 1;
        pq_cr_sobreendeudamiento.SP_VAR_DEPEND_CONSUMO(ve_instancia,
                                                         ve_fecha,
                                                         vi_SNG021Eval,
                                                         vi_JAQY490CPO,
                                                         vi_JAQY490STD,
                                                         vi_SNG120TCbi,
                                                         vi_nCuoCajAqp,
                                                         vi_nIngTot,
                                                         vi_nCuoRes,
                                                         vi_nRatDeuTotIngBru,
                                                         vi_nCuoSF,
                                                         vi_nCuoTot,
                                                         vi_nRatCapPag,
                                                         vi_nIngBru);
      END IF;
      IF vi_SNG021TMOD = 13 THEN
        vi_Jaqy490aseg := 2;
        pq_cr_sobreendeudamiento.SP_VAR_INDEPEND_PYME(ve_instancia,
                                                        ve_Pepais,
                                                        ve_Petdoc,
                                                        ve_Pendoc,
                                                        ve_fecha,
                                                        vi_SNG021Eval,
                                                        vi_JAQY490CPO,
                                                        vi_JAQY490STD,
                                                        vi_JAQY490DTI,
                                                        vi_SNG120TCbi,
                                                        vi_nCuoCajAqp,
                                                        vi_nCuoRes,
                                                        vi_nRatDeuTotIngBru,
                                                        vi_nRatDeuTotPat,
                                                        vi_nCuoSF,
                                                        vi_nCuoTot,
                                                        vi_nRatCapPag,
                                                        vi_nIngBru,
                                                        vi_nVentas,
                                                        vi_nOtrIng,
                                                        vi_nIngNet,
                                                        vi_nUtiNet,
                                                        vi_nSegInd,
                                                        vi_nRatCuoTotResNet,
                                                        vi_nResNetMen,
                                                        vi_nTotPas,
                                                        vi_nTotPat,
                                                        vi_nDeuTotIngNetMen);
      END IF;
    END;
    ---FIN DE LA CARGA DE VARIABLES
  
    --CARGANDO EL RESTO DE PROCESOS
  
    pq_cr_sobreendeudamiento.SP_EVALUAR_CRITERIOS(vi_JAQY490ASEG,
                                                    vi_nSegInd,
                                                    vi_nCuoRes,
                                                    vi_nRatDeuTotPat,
                                                    vi_JAQY490VEN,
                                                    vi_JAQY490LTC,
                                                    vi_Jaqy490vsi,
                                                    vi_nRatDeuTotIngBru,
                                                    vi_JAQY490ACRI1,
                                                    vi_JAQY490ACRI2,
                                                    vi_JAQY490ACRI3,
                                                    vi_JAQY490ACRI4,
                                                    vi_cSOBEND);
  
    pq_cr_sobreendeudamiento.SP_CRITERIO_CUOTA_RESULTADO(vi_XWfModulo,
                                                           vi_cTipCre,
                                                           vi_SNG001Ori,
                                                           vi_Jaqy490aseg,
                                                           vi_nCuoRes,
                                                           vi_JAQY490ACRI1,
                                                           vi_cSOBEND);
  
    pq_cr_sobreendeudamiento.SP_VALIDAR_EXCEPTION(vi_cTipCre,
                                                    vi_XWfModulo,
                                                    ve_instancia,
                                                    vi_JAQY490AEXC,
                                                    vi_JAQY490ACOM,
                                                    vi_cSOBEND,
                                                    vi_JAQY490ACRI1,
                                                    vi_JAQY490ACRI2,
                                                    vi_JAQY490ACRI3,
                                                    vi_JAQY490ACRI4);
    /*
    PQ_CR_SOBREENDEUDAMIENTO.SP_REGISTRAR_VARIABLES(); --YA NO SE USA ESTA SUBRUTINA
    */
    --FIN DE LA CARGA DEL RESTO DE PROCESOS
  
    --REGISTRAR EN JAQY490A
    vi_JAQY490AEJE := 0;
    BEGIN
      SELECT MAX(JAQY490AEJE)
        INTO vi_JAQY490AEJE
        FROM JAQY490A
       WHERE JAQY490AINS = ve_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    vi_JAQY490AEJE := vi_JAQY490AEJE + 1;
  
    --CONVERTIR DE NUMERICO A VARCHAR PARA EL INSERT REEMPLAZA A LA SUBRTUINA REGISTRAR VBARIABLES
    /*
    vi_JAQY490acr1 := trim(to_char(ve_ln_valcri1));
    vi_JAQY490acr2 := trim(to_char(ve_ln_valcri2));
    vi_JAQY490acr3 := trim(to_char(ve_ln_valcri3));
    vi_JAQY490acr4 := trim(to_char(ve_ln_valcri4));
    vi_Sobend := trim(to_char(ve_ln_valsob));  
    */
  
    BEGIN
      INSERT INTO JAQY490A
        (JAQY490AINS,
         JAQY490AEJE,
         JAQY490APAI,
         JAQY490ATDO,
         JAQY490ADOC,
         JAQY490AFEC,
         JAQY490AFECEVA,
         JAQY490AEVA,
         JAQY490AMODEVA,
         JAQY490ASEGINS,
         JAQY490ASEG,
         JAQY490ACUOCAJ,
         JAQY490ACUOSFI,
         JAQY490ACPOSFI,
         JAQY490ACUOTOT,
         JAQY490AVENTAS,
         JAQY490AOTRING,
         JAQY490AINGBRU,
         JAQY490AINGNET,
         JAQY490AUTINET,
         JAQY490ARESNET,
         JAQY490ATOTPAS,
         JAQY490ATOTPAT,
         JAQY490AINGTOT,
         JAQY490ARATCAP,
         JAQY490AVNE,
         JAQY490AVSD,
         JAQY490ALTC,
         JAQY490AMLTCSF,
         JAQY490ANEN,
         JAQY490AVEN,
         JAQY490ADTI,
         JAQY490ADTC,
         JAQY490ASEGIND,
         JAQY490ARATDEUPAT,
         JAQY490ARATCUORES,
         JAQY490ADEUING,
         JAQY490AVSI,
         JAQY490ARAZAPCING,
         JAQY490ARAZCAPPAG,
         JAQY490AFLGOTRING,
         JAQY490AEXC,
         JAQY490ACRI1,
         JAQY490ACRI2,
         JAQY490ACRI3,
         JAQY490ACRI4,
         JAQY490ASOB,
         JAQY490ACOM,
         JAQY490ACR,
         JAQY490ARDI,
         JAQY490ADTIC,
         JAQY490ACPO,
         JAQY490ACUC)
      VALUES
        (ve_instancia,
         vi_JAQY490AEJE,
         ve_Pepais,
         ve_Petdoc,
         ve_Pendoc,
         vi_Pgfape,
         vi_SNG021Fec,
         vi_SNG021Eval,
         vi_SNG021TMod,
         vi_SNG001Seg,
         vi_JAQY490ASEG,
         vi_nCuoCajAqp,
         vi_nCuoSF,
         vi_JAQY490CPO,
         vi_nCuoTot,
         vi_nVentas,
         vi_nOtrIng,
         vi_nIngBru,
         vi_nIngNet,
         vi_nUtiNet,
         vi_nResNetMen,
         vi_nTotPas,
         vi_nTotPat,
         vi_nIngTot,
         vi_nRatCapPag,
         vi_JAQY490VNE,
         vi_JAQY490VSD,
         vi_JAQY490LTC,
         vi_JAQY490AMLTCSF,
         vi_JAQY490NEN,
         vi_JAQY490VEN,
         vi_JAQY490DTI,
         vi_JAQY490DTC,
         vi_nSegInd,
         vi_nRatDeuTotPat,
         vi_nRatCuoTotResNet,
         vi_nDeuTotIngNetMen,
         vi_JAQY490VSI,
         vi_nRazApcIng,
         vi_nRazCapPag,
         vi_cFlgOtrIng,
         vi_JAQY490AEXC,
         vi_JAQY490ACRI1,
         vi_JAQY490ACRI2,
         vi_JAQY490ACRI3,
         vi_JAQY490ACRI4,
         vi_cSOBEND,
         vi_JAQY490ACOM,
         vi_JAQY490ACR,
         vi_nRatDeuTotIngBru,
         vi_JAQY490DTIcon,
         vi_JAQY490CPOcon,
         vi_JAQY490CUCcon);
    
      INSERT INTO AQPB559
        (AQPB559INS,
         AQPB559EJE,
         AQPB559PAI,
         AQPB559TDO,
         AQPB559DOC,
         AQPB559FEC,
         AQPB559FECEVA,
         AQPB559EVA,
         AQPB559MODEVA,
         AQPB559SEGINS,
         AQPB559SEG,
         AQPB559CUOCAJ,
         AQPB559CUOSFI,
         AQPB559CPOSFI,
         AQPB559CUOTOT,
         AQPB559VENTAS,
         AQPB559OTRING,
         AQPB559INGBRU,
         AQPB559INGNET,
         AQPB559UTINET,
         AQPB559RESNET,
         AQPB559TOTPAS,
         AQPB559TOTPAT,
         AQPB559INGTOT,
         AQPB559RATCAP,
         AQPB559VNE,
         AQPB559VSD,
         AQPB559LTC,
         AQPB559MLTCSF,
         AQPB559NEN,
         AQPB559VEN,
         AQPB559DTI,
         AQPB559DTC,
         AQPB559SEGIND,
         AQPB559RATDEUPAT,
         AQPB559RATCUORES,
         AQPB559DEUING,
         AQPB559VSI,
         AQPB559RAZAPCING,
         AQPB559RAZCAPPAG,
         AQPB559FLGOTRING,
         AQPB559EXC,
         AQPB559CRI1,
         AQPB559CRI2,
         AQPB559CRI3,
         AQPB559CRI4,
         AQPB559SOB,
         AQPB559COM,
         AQPB559CR,
         AQPB559RDI,
         AQPB559DTIC,
         AQPB559CPO,
         AQPB559CUC,
         AQPB559MSG)
      VALUES
        (ve_instancia,
         vi_JAQY490AEJE,
         vi_Pepais,
         vi_Petdoc,
         vi_Pendoc,
         vi_Pgfape,
         vi_SNG021Fec,
         vi_SNG021Eval,
         vi_SNG021TMod,
         vi_SNG001Seg,
         vi_JAQY490ASEG,
         vi_nCuoCajAqp,
         vi_nCuoSF,
         vi_JAQY490CPO,
         vi_nCuoTot,
         vi_nVentas,
         vi_nOtrIng,
         vi_nIngBru,
         vi_nIngNet,
         vi_nUtiNet,
         vi_nResNetMen,
         vi_nTotPas,
         vi_nTotPat,
         vi_nIngTot,
         vi_nRatCapPag,
         vi_JAQY490VNE,
         vi_JAQY490VSD,
         vi_JAQY490LTC,
         vi_JAQY490AMLTCSF,
         vi_JAQY490NEN,
         vi_JAQY490VEN,
         vi_JAQY490DTI,
         vi_JAQY490DTC,
         vi_nSegInd,
         vi_nRatDeuTotPat,
         vi_nRatCuoTotResNet,
         vi_nDeuTotIngNetMen,
         vi_JAQY490VSI,
         vi_nRazApcIng,
         vi_nRazCapPag,
         vi_cFlgOtrIng,
         vi_JAQY490AEXC,
         vi_JAQY490ACRI1,
         vi_JAQY490ACRI2,
         vi_JAQY490ACRI3,
         vi_JAQY490ACRI4,
         vi_cSOBEND,
         vi_JAQY490ACOM,
         vi_JAQY490ACR,
         vi_nRatDeuTotIngBru,
         vi_JAQY490DTIcon,
         vi_JAQY490CPOcon,
         vi_JAQY490CUCcon,
         'OK');
         commit;
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          INSERT INTO AQPB559
            (AQPB559INS, AQPB559EJE, AQPB559MSG)
          values
            (ve_instancia, vi_JAQY490AEJE, 'Error');
          commit;  
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;      
    END;
    --FIN DE REGISTRO EN JAQY490A
    ---
    /*
    vi_CSOBEND := vi_JAQY490ACRI2; --drc110718 P1206
    vi_CSOBEND := Concat(Trim(Str(ve_JAQY490ASEG)),vi_JAQY490ACRI2);
    IF vi_nSegInd = 1 Or vi_nSegInd = 2 THEN
        vi_CSOBEND := Concat(vi_CSOBEND,'12');
        IF ve_nRatDeuTotPat > 0.8 THEN
            vi_Sobend := Concat(vi_CSOBEND,'8');
        ELSE
            vi_Sobend := Concat(vi_CSOBEND,'0');
        END IF;
    ELSE
        vi_Sobend := Concat(vi_Sobend,Trim(Str(ve_nSegInd)));
    END IF;
    */
    ----
    vo_CSOBEND := vi_CSOBEND;
    if vo_CSOBEND IS NULL THEN
      vo_CSOBEND := 0;
    END IF;
    ---

    ---
  END;
  --------------------------------------
  --------------------------------------
  PROCEDURE SP_EVALUAR_CRITERIOS(ve_JAQY490ASEG      in number,
                                 ve_nSegInd          in number,
                                 ve_nCuoRes          in number,
                                 ve_nRatDeuTotPat    in number,
                                 ve_JAQY490VEN       in number,
                                 ve_JAQY490LTC       in number,
                                 ve_Jaqy490vsi       in number,
                                 ve_nRatDeuTotIngBru in number,
                                 vo_ln_valcri1       out number,
                                 vo_ln_valcri2       out number,
                                 vo_ln_valcri3       out number,
                                 vo_ln_valcri4       out number,
                                 vo_ln_valsob        out number) is
    ln_tipseg   number(10);
    ln_valvar11 number(18, 2);
    ln_valvar12 number(18, 2); --NO USADAS
    ln_valvar13 number(18, 2); --NO USADAS
    ln_valvar14 number(18, 2); --NO USADAS
  
    ln_valvar21 number(18, 2);
    ln_valvar22 number(18, 2);
    ln_valvar23 number(18, 2);
    ln_valvar24 NUMBER(18, 2); -- NO USADAS
    ln_valvar31 number(18, 2);
    ln_valvar32 number(18, 2);
    ln_valvar33 number(18, 2);
    ln_valvar34 number(18, 2);
    ln_valvar41 number(18, 2);
    ln_valvar42 number(18, 2);
    ln_valvar43 number(18, 2);
    ln_valvar44 number(18, 2); ---NO USADA
  
  BEGIN
    --(17,2)
    --INDEPENDIENTES
    If ve_JAQY490ASEG = 2 THEN
      ln_tipseg   := 120 + ve_nSegInd; --121,122,123
      ln_valvar11 := ve_nCuoRes;
      ln_valvar21 := ve_nRatDeuTotPat;
      ln_valvar22 := ve_JAQY490VEN;
    
      If ln_tipseg = 121 then
        ln_valvar31 := ln_valvar21;
        ln_valvar32 := ln_valvar22;
        ln_valvar33 := ve_JAQY490LTC;
        ln_valvar34 := ve_Jaqy490vsi;
        ln_valvar41 := ln_valvar21;
        ln_valvar42 := ln_valvar22;
        ln_valvar43 := ln_valvar33;
      End If;
      If ln_tipseg = 122 THEN
        ln_valvar31 := ln_valvar21;
        ln_valvar32 := ln_valvar21;
        ln_valvar33 := ln_valvar22;
        ln_valvar41 := ln_valvar21;
        ln_valvar42 := ln_valvar22;
      End If;
    
      If ln_tipseg = 123 THEN
        ln_valvar21 := ve_nRatDeuTotIngBru;
        ln_valvar31 := ve_nRatDeuTotPat;
        ln_valvar32 := ln_valvar22;
        ln_valvar33 := ve_nRatDeuTotIngBru;
      End If;
    End If;
  
    --DEPENDIENTES
    If ve_JAQY490ASEG = 1 THEN
      ln_tipseg   := 22;
      ln_valvar11 := ve_nCuoRes;
      ln_valvar21 := ve_nRatDeuTotIngBru;
      ln_valvar22 := ve_JAQY490VEN;
      ln_valvar23 := ve_JAQY490LTC;
      ln_valvar31 := ln_valvar21;
      ln_valvar32 := ln_valvar22;
      ln_valvar33 := ln_valvar23;
      ln_valvar41 := ln_valvar21;
      ln_valvar42 := ln_valvar22;
      ln_valvar43 := ln_valvar23;
    End If;
    --PROCESO PARA EVALUAR LOS CRITERIOS
    pq_sobend_seg.sp_evalua_criterios(ln_tipseg,
                                      ln_valvar11,
                                      ln_valvar12,
                                      ln_valvar13,
                                      ln_valvar14,
                                      ln_valvar21,
                                      ln_valvar22,
                                      ln_valvar23,
                                      ln_valvar24,
                                      ln_valvar31,
                                      ln_valvar32,
                                      ln_valvar33,
                                      ln_valvar34,
                                      ln_valvar41,
                                      ln_valvar42,
                                      ln_valvar43,
                                      ln_valvar44,
                                      vo_ln_valcri1,
                                      vo_ln_valcri2,
                                      vo_ln_valcri3,
                                      vo_ln_valcri4, ---VARIABLES DEVUELTAS
                                      vo_ln_valsob); --VARIABLE DEVEULTA
  END;

  -------------------------------------------
  -------------------------------------------
  PROCEDURE SP_CRITERIO_CUOTA_RESULTADO(ve_XWfModulo   in number,
                                        ve_cTipCre     in number,
                                        ve_SNG001Ori   in number,
                                        ve_Jaqy490aseg in number,
                                        ve_nCuoRes     in number,
                                        vo_ln_valcri1  out number,
                                        vo_ln_valsob   out number) is
  
    --CARGAR CURSORES
    CURSOR lista_frng50 is
  /*    SELECT *
        FROM FRNG50
       WHERE RNG49Cod = 1000030
         AND RNG50Grp < 999
         AND RNG50Ret like '174%';*/
     SELECT *
        FROM FRNG50
       WHERE RNG49Cod = 91;         
  
    vi_CumCri   varchar(1);
    vi_cExiGru  VARCHAR(1);
    vi_RNG50Grp FRNG50.RNG50GRP%TYPE;
  
  BEGIN
    vi_CumCri := 'N';
    FOR x in lista_frng50 LOOP
      vi_RNG50Grp := x.RNG50Grp;
      vi_cExiGru  := 'N';
      IF ve_Jaqy490aseg = 2 THEN
        --INDEPENDIENTE
        BEGIN
          /*SELECT 'S'
            INTO vi_cExiGru
            FROM FRNG51
           WHERE RNG49Cod = 1000030
             AND RNG50Grp = vi_RNG50Grp
             AND RNG68Cod = 287; --CUO_RES ratio cuota resultado*/
           SELECT 'S'
            INTO vi_cExiGru
            FROM FRNG51
           WHERE RNG49Cod = 91
             AND RNG50Grp = vi_RNG50Grp
             AND RNG68Cod = 4;   
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        IF vi_cExiGru = 'S' THEN
          SP_EVAL_POL_INDEPENDIENTE(vi_RNG50Grp,
                                                             ve_XWfModulo,
                                                             ve_cTipCre,
                                                             ve_SNG001Ori,
                                                             ve_nCuoRes,
                                                             vi_CumCri);
        END IF;
      END IF;
    
    
      If ve_Jaqy490aseg = 1 THEN
        --DEPENDIENTE
        BEGIN
         /* SELECT 'S'
            INTO vi_cExiGru
            FROM FRNG51
           WHERE RNG49Cod = 91
             AND RNG50Grp = vi_RNG50Grp
             AND RNG68Cod = 329; --RATIO_CNSM ratio cuota consumo*/
          SELECT 'S'
            INTO vi_cExiGru
            FROM FRNG51
           WHERE RNG49Cod = 91
             AND RNG50Grp = vi_RNG50Grp
             AND RNG68Cod = 5;              
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        If vi_cExiGru = 'S' THEN
          SP_EVAL_POL_DEPENDIENTE(vi_RNG50Grp,
                                                           ve_XWfModulo,
                                                           ve_cTipCre,
                                                           ve_SNG001Ori,
                                                           ve_nCuoRes,
                                                           vi_CumCri);
        End If;
      End If;
      If vi_cExiGru = 'S' And vi_CumCri = 'S' THEN
        Exit;
      End If;
    End loop;
    If vi_CumCri = 'S' THEN
      vo_ln_valcri1 := 1;
      vo_ln_valsob  := 1;
    else 
      vo_ln_valcri1 := 0;
      vo_ln_valsob  := 0;
    End If;
  END;
  -------------------------------------------
  -------------------------------------------
  PROCEDURE SP_EVAL_POL_INDEPENDIENTE(ve_RNG50Grp  in number,
                                      ve_XWfModulo in number,
                                      ve_cTipCre   in number,
                                      ve_SNG001Ori in number,
                                      ve_nCuoRes   in number,
                                      vo_cCumCri   out varchar) IS
  
    cursor lista_frng51 is
  /*    SELECT *
        FROM frng51
       WHERE RNG49Cod = 1000030
         AND RNG50Grp = ve_RNG50Grp
         AND (RNG68Cod = 13 Or RNG68Cod = 31 Or RNG68Cod = 37 Or
             RNG68Cod = 39 Or RNG68Cod = 287);
  */
           SELECT *
            FROM FRNG51
           WHERE RNG49Cod = 91
             AND RNG50Grp = ve_RNG50Grp
             AND RNG68Cod = 4;   
    --VARIABLES INTERNAS
    vi_nNumItm    number(10);
    vr_nNumItmVal number(10);
    vi_RNG51Cod   FRNG51.RNG51COD%TYPE;
    vi_RNG51Ope   FRNG51.RNG51OPE%TYPE;
    vi_RNG51Val   FRNG51.RNG51VAL%TYPE;
    vi_nValIzq    number(17, 2);
  BEGIN
    vi_nNumItm    := 0;
    vr_nNumItmVal := 0;
    vo_cCumCri    := 'N';
    For x in lista_frng51 LOOP
      vi_nNumItm  := vi_nNumItm + 1;
      vi_RNG51Cod := x.RNG51Cod;
      vi_RNG51Ope := x.RNG51Ope;
      vi_RNG51Val := x.RNG51Val;
      IF x.RNG68Cod = 4 THEN
        --cuota resultado
        vi_nValIzq := ve_nCuoRes;
      END IF;      
      IF x.RNG68Cod = 13 THEN
        --SEGMENTO
        vi_nValIzq := 1;
      END IF;
      IF x.RNG68Cod = 31 THEN
        --MODULO
        vi_nValIzq := ve_XWfModulo;
      END IF;
      IF x.RNG68Cod = 37 THEN
        --tipo de crédito
        vi_nValIzq := TO_NUMBER(Trim(ve_cTipCre));
      END IF;
      IF x.RNG68Cod = 39 THEN
        --tipo de solicitud
        vi_nValIzq := ve_SNG001Ori;
      END IF;
      IF x.RNG68Cod = 287 THEN
        --cuota resultado
        vi_nValIzq := ve_nCuoRes;
      END IF;
      SP_EVALUAR_ITEM(vi_RNG51Ope,
                                               vi_nValIzq,
                                               ve_RNG50Grp,
                                               vi_RNG51Cod,
                                               vi_RNG51Val,
                                               vr_nNumItmVal);
    END LOOP;
    If vi_nNumItm = vr_nNumItmVal THEN
      vo_cCumCri := 'S';
    End If;
  END;
  -------------------------------------------
  -------------------------------------------
  PROCEDURE SP_EVAL_POL_DEPENDIENTE(ve_RNG50Grp  in number,
                                    ve_XWfModulo in number,
                                    ve_cTipCre   in number,
                                    ve_SNG001Ori in number,
                                    ve_nCuoRes   in number,
                                    vo_cCumCri   out varchar) IS
  
    CURSOR lista_regla is
   /*   SELECT *
        FROM FRNG51
       WHERE RNG49Cod = 1000030
         AND RNG50Grp = ve_RNG50Grp
         AND (RNG68Cod = 13 Or RNG68Cod = 31 Or RNG68Cod = 37 Or
             RNG68Cod = 39 Or RNG68Cod = 329);
  */
          SELECT *
            FROM FRNG51
           WHERE RNG49Cod = 91
             AND RNG50Grp = ve_RNG50Grp
             AND RNG68Cod = 5;              
    --VARIABLES INTERNAS
    vi_nNumItm    number(10);
    vr_nNumItmVal number(10);
    vi_RNG51Cod   FRNG51.RNG51COD%TYPE;
    vi_RNG51Ope   FRNG51.RNG51OPE%TYPE;
    vi_RNG51Val   FRNG51.RNG51VAL%TYPE;
    vi_nValIzq    number(17, 2);
  
  BEGIN
    vi_nNumItm    := 0;
    vr_nNumItmVal := 0;
    vo_cCumCri    := 'N';
    FOR x in lista_regla LOOP
      vi_nNumItm  := vi_nNumItm + 1;
      vi_RNG51Cod := x.RNG51Cod;
      vi_RNG51Ope := x.RNG51Ope;
      vi_RNG51Val := x.RNG51Val;
  
      IF x.RNG68Cod = 5 THEN
        --cuota resultado
        vi_nValIzq := ve_nCuoRes;
      END IF;
      
      IF x.RNG68Cod = 13 THEN
        --segmento
        vi_nValIzq := 2;
      END IF;
      IF x.RNG68Cod = 31 THEN
        --módulo
        vi_nValIzq := ve_XWfModulo;
      END IF;
      IF x.RNG68Cod = 37 THEN
        --tipo de crédito
        vi_nValIzq := Trim(ve_cTipCre);
      END IF;
      IF x.RNG68Cod = 39 THEN
        --tipo de solicitud
        vi_nValIzq := ve_SNG001Ori;
      END IF;
      IF x.RNG68Cod = 329 THEN
        --cuota resultado dependiente
        vi_nValIzq := ve_nCuoRes;
      END IF;
      SP_EVALUAR_ITEM(vi_RNG51Ope,
                                               vi_nValIzq,
                                               ve_RNG50Grp,
                                               vi_RNG51Cod,
                                               vi_RNG51Val,
                                               vr_nNumItmVal);
    END LOOP;
    If vi_nNumItm = vr_nNumItmVal THEN
      vo_cCumCri := 'S';
    End If;
  END;
  -------------------------------------------
  -------------------------------------------
  PROCEDURE SP_EVALUAR_ITEM(ve_RNG51Ope   in varchar,
                            ve_nValIzq    in number,
                            ve_RNG50Grp   in number,
                            ve_RNG51Cod   in number,
                            ve_RNG51Val   in varchar,
                            vo_nNumItmVal out number) IS
    cursor lista_frng67 is
      SELECT *
        FROM FRNG67
       WHERE RNG49Cod = 91--1000030
         AND RNG50Grp = ve_RNG50Grp
         AND RNG51Cod = ve_RNG51Cod;
  
    --VARIABLES INTERNAS
    vi_nValDer    number(17,2);
    vi_nCanItmVal number(17);
    vi_nCanItm    number(17);
    vi_cOperad    varchar2(10);
  BEGIN
    If ve_RNG51Ope = 'EN' then
      vi_nCanItmVal := 0;
      BEGIN
        for x in lista_frng67 loop
          vi_nValDer := to_number(x.RNG67VAL);
          If ve_nValIzq = vi_nValDer THEN
            vi_nCanItmVal := 1;
          End If;
        end loop;
      END;
      If vi_nCanItmVal = 1 THEN
        vo_nNumItmVal := vo_nNumItmVal + 1;
      End If;
    End If;
  
    If ve_RNG51Ope = 'NE' THEN
      vi_nCanItm    := 0;
      vi_nCanItmVal := 0;
      BEGIN
        for x in lista_frng67 loop
          vi_nCanItm := vi_nCanItm + 1;
          vi_nValDer := x.RNG67Val;
          If ve_nValIzq <> vi_nValDer THEN
            vi_nCanItmVal := vi_nCanItmVal + 1;
          End If;
        end loop;
      END;
      If vi_nCanItm = vi_nCanItmVal THEN
        vo_nNumItmVal := vo_nNumItmVal + 1;
      End If;
    End If;
  
    If ve_RNG51Ope <> 'EN' And ve_RNG51Ope <> 'NE' THEN
      vi_nValDer := TO_NUMBER(trim(ve_RNG51Val), '999.99' );
      vi_cOperad := Trim(ve_RNG51Ope);
      If (vi_cOperad = '=' And ve_nValIzq = vi_nValDer) Or
         (vi_cOperad = '>' And ve_nValIzq > vi_nValDer) Or
         (vi_cOperad = '<' And ve_nValIzq < vi_nValDer) Or
         (vi_cOperad = '>=' And ve_nValIzq >= vi_nValDer) Or
         (vi_cOperad = '<=' And ve_nValIzq <= vi_nValDer) Or
         (vi_cOperad = '<>' And ve_nValIzq <> vi_nValDer) THEN
        vo_nNumItmVal := vo_nNumItmVal + 1;
      End If;
    End If;
    
     vo_nNumItmVal := nvl(vo_nNumItmVal,0);

  End;
  


  -------------------------------------------
  -------------------------------------------
  /*
  PROCEDURE SP_REGISTRAR_VARIABLES(ve_ln_valcri1 in number,ve_ln_valcri2 in number,ve_ln_valcri3 in number,
                                   ve_ln_valcri4 in number,ve_ln_valsob in number,ve_JAQY490ASEG in number,
                                   ve_nRatDeuTotPat in number,ve_nSegInd in number,
                                   vo_JAQY490acr1 out varchar,vo_JAQY490acr2 out varchar,vo_JAQY490acr3 out varchar,vo_JAQY490acr4 out varchar,
                                   vo_Sobend out varchar) is
  
  BEGIN
    
    vo_JAQY490acr1 := trim(to_char(ve_ln_valcri1));
    vo_JAQY490acr2 := trim(to_char(ve_ln_valcri2));
    vo_JAQY490acr3 := trim(to_char(ve_ln_valcri3));
    vo_JAQY490acr4 := trim(to_char(ve_ln_valcri4));
    vo_Sobend := trim(to_char(ve_ln_valsob));  
    
    
    vo_Sobend := vo_JAQY490acr1; --drc110718 P1206
    vo_Sobend := Concat(Trim(TO_CHAR(ve_JAQY490ASEG)),vo_JAQY490acr2);
      IF ve_nSegInd = 1 Or ve_nSegInd = 2 THEN
          vo_Sobend := Concat(vo_Sobend,'12');
          IF ve_nRatDeuTotPat > 0.8 THEN
              vo_Sobend := Concat(vo_Sobend,'8');
          ELSE
              vo_Sobend := Concat(vo_Sobend,'0');
          END IF;
      ELSE
          vo_Sobend := Concat(vo_Sobend,Trim(to_char(ve_nSegInd)));
      END IF;
  END;
  */
  -------------------------------------------
  -------------------------------------------
  PROCEDURE SP_VAR_DEPEND_CONSUMO(ve_instancia        in number,
                                  ve_fechad           in date,
                                  ve_SNG021Eval       in number,
                                  ve_JAQY490CPO       in number,
                                  ve_JAQY490STD       in number,
                                  ve_SNG120TCbi       in number,
                                  ve_nCuoCajAqp       in number,
                                  vo_nIngTot          out number,
                                  vo_nCuoRes          out number,
                                  vo_nRatDeuTotIngBru out number,
                                  vo_nCuoSF           out number,
                                  vo_nCuoTot          out number,
                                  vo_nRatCapPag       out number,
                                  vo_nIngBru          out number) IS
  
    cursor lista_jaqm400 is
      SELECT *
        FROM JAQM400
       Where JAQM400INS = ve_instancia
         AND JAQM400FEC = ve_fechad
         AND (JAQM400cod = 21 Or JAQM400COD = 521);
  
    cursor lista_AQPB364 is
      SELECT *
        FROM AQPB364
       Where AQPB364EVAL = ve_SNG021Eval
         AND AQPB364Cod = 36
         AND AQPB364Mto2 <> 0;
  
    cursor lista_JAQZ821b is
      SELECT *
        FROM JAQZ821b
       Where jaqz821inst = ve_instancia
         AND JAQZ821EST = 'H';
  
    --VARIABLES INTERNAS
    vi_AQPB364Mto2 NUMBER(17, 2);
    vi_nIngTotME   NUMBER(17, 2);
    vi_nIngTotMN   NUMBER(17, 2);
    vi_jaqz821corr NUMBER(10);
  
  BEGIN
    vo_nIngTot          := 0;
    vi_nIngTotMN        := 0;
    vi_nIngTotME        := 0;
    vo_nCuoRes          := 0;
    vo_nRatDeuTotIngBru := 0;
  
    FOR x in lista_jaqm400 LOOP
      IF x.JAQM400COD = 21 THEN
        vi_nIngTotMN := x.JAQM400MON;
      END IF;
      IF x.JAQM400COD = 521 THEN
        vi_nIngTotME := x.JAQM400MON;
      END IF;
    END LOOP;
  
    vo_nIngTot     := vi_nIngTotMN + (vi_nIngTotME * ve_SNG120TCbi);
    vi_AQPB364Mto2 := 0;
  
    FOR y in lista_AQPB364 LOOP
      If y.AQPB364Con3 Like '%lares%' THEN
        --vi_SNG028Mto2 := vi_SNG028Mto2 + (SNG028Mto2 * ve_SNG120TCbi);
        vi_AQPB364Mto2 := vi_AQPB364Mto2 + (y.AQPB364Mto2 * ve_SNG120TCbi);
      Else
        --vi_SNG028Mto2 := vi_SNG028Mto2 + SNG028Mto2;
        vi_AQPB364Mto2 := vi_AQPB364Mto2 + y.AQPB364Mto2;
      End If;
    End LOOP;
  
    vo_nCuoSF     := vi_AQPB364Mto2;
    vo_nCuoTot    := ve_nCuoCajAqp + vo_nCuoSF + nvl(ve_JAQY490CPO,0);
    vo_nRatCapPag := 0;
    If vo_nIngTot <> 0 THEN
      vo_nRatCapPag := vo_nCuoTot / vo_nIngTot;
    End If;
  
    vi_jaqz821corr := 0;
    FOR z in lista_JAQZ821b LOOP
      If z.jaqz821corr > vi_jaqz821corr THEN
        vo_nCuoRes     := z.jaqz821ratio;
        vi_jaqz821corr := z.jaqz821corr;
      End If;
    END LOOP;
    vo_nIngBru := vo_nIngTot;
    If vo_nIngBru <> 0 THEN
      vo_nRatDeuTotIngBru := nvl(ve_JAQY490STD,0) / vo_nIngBru;
    End If;
  END;
  -------------------------------------------
  -------------------------------------------
  PROCEDURE SP_VAR_INDEPEND_PYME(ve_instancia        in number,
                                 ve_pepais           in number,
                                 ve_petdoc           in number,
                                 ve_cNumdoc          in varchar,
                                 ve_fechad           in date,
                                 ve_SNG021Eval       in number,
                                 ve_JAQY490CPO       in number,
                                 ve_JAQY490STD       in number,
                                 ve_JAQY490DTI       in number,
                                 ve_SNG120TCbi       in number,
                                 ve_nCuoCajAqp       in number,
                                 vo_nCuoRes          out number,
                                 vo_nRatDeuTotIngBru out number,
                                 --vo_nIngTot out number,vo_nCuoRes out number,vo_nRatDeuTotIngBru out number,
                                 -- vo_nCuoSF out number,
                                 vo_nRatDeuTotPat    out number,
                                 vo_nCuoSF           out number,
                                 vo_nCuoTot          out number,
                                 vo_nRatCapPag       out number,
                                 vo_nIngBru          out number,
                                 vo_nVentas          out number,
                                 vo_nOtrIng          out number,
                                 vo_nIngNet          out number,
                                 vo_nUtiNet          out number,
                                 vo_nSegInd          out number,
                                 vo_nRatCuoTotResNet out number,
                                 vo_nResNetMen       out number,
                                 vo_nTotPas          out number,
                                 vo_nTotPat          out number,
                                 vo_nDeuTotIngNetMen out number) IS
  
    cursor lista_jaqz516(vc_JAQZ515PDOC number,
                         vc_JAQZ515TDOC number,
                         vc_JAQZ515NDOC varchar) is
      SELECT JAQZ516EVAL
        FROM JAQZ516 j
       WHERE jaqz516sol = ve_instancia
         AND JAQZ516PDOC = vc_JAQZ515PDOC
         AND JAQZ516TDOC = vc_JAQZ515TDOC
         AND JAQZ516NDOC = vc_JAQZ515NDOC;
  
    cursor lista_jaqz517(vi_codigo number) is
      SELECT *
        FROM JAQZ517 A
       WHERE A.JAQZ517EVAL = vi_codigo
         AND (JAQZ517COD = 73 Or JAQZ517COD = 573 Or JAQZ517COD = 53 Or
             JAQZ517COD = 553 Or JAQZ517COD = 84 Or JAQZ517COD = 584 Or
             JAQZ517COD = 40 Or JAQZ517COD = 540 Or JAQZ517COD = 65 Or
             JAQZ517COD = 565 Or JAQZ517COD = 70 Or JAQZ517COD = 570 Or
             JAQZ517COD = 79 Or JAQZ517COD = 579 Or JAQZ517COD = 19 Or
             JAQZ517COD = 519);
    cursor lista_AQPB081 is
      SELECT *
        FROM AQPB081
       WHERE AQPB081INST = ve_instancia
         AND AQPB081PAIS = ve_Pepais
         AND AQPB081TDOC = ve_Petdoc
         AND AQPB081NDOC = ve_cNumDoc
         AND AQPB081ESTA = 'S';
  
    cursor lista_jaqy140 is
      SELECT *
        FROM JAQY140
       WHERE JAQY140INST = ve_instancia
         AND JAQY140EST = 'H';
  
    --VARIABLES INTERNAS
    vi_JAQZ515PDOC NUMBER(3);
    vi_JAQZ515TDOC NUMBER(2);
    vi_JAQZ515NDOC VARCHAR(12);
  
    vi_AQPB081CCALC NUMBER(17, 2);
  
    vi_nVentasMN NUMBER(17, 2);
    vi_nVentasME NUMBER(17, 2);
  
    vi_nIngTotME NUMBER(17, 2);
    vi_nIngTotMN NUMBER(17, 2);
  
    vi_nOtrIngMN NUMBER(17, 2);
    vi_nOtrIngME NUMBER(17, 2);
  
    vi_nUtiNetMN NUMBER(17, 2);
    vi_nUtiNetME NUMBER(17, 2);
  
    vi_nResNetMenMN NUMBER(17, 2);
    vi_nResNetMenME NUMBER(17, 2);
    vi_jaqz821corr  NUMBER(10);
    vi_nGasFin      NUMBER(17, 2);
    vi_nGasFinME    NUMBER(17, 2);
    vi_nGasFinMN    NUMBER(17, 2);
    vi_nGasFinFam   NUMBER(17, 2);
    vi_nGasFinFamME NUMBER(17, 2);
    vi_nGasFinFamMN NUMBER(17, 2);
    vi_nTotPasMN    NUMBER(17, 2);
    vi_nTotPasME    NUMBER(17, 2);
    vi_nTotPatMN    NUMBER(17, 2);
    vi_nTotPatME    NUMBER(17, 2);
    vi_jaqy140corr  number(10);
  
  BEGIN
    ---INGRESO BRUTO
    --ventas
    vo_nVentas   := 0;
    vi_nVentasMN := 0;
    vi_nVentasME := 0;
    vo_nSegInd   := 0;
    ---otros ingresos
    vo_nOtrIng   := 0;
    vi_nOtrIngMN := 0;
    vi_nOtrIngME := 0;
    ---INGRESOS NETOS
    vo_nIngNet   := 0;
    vo_nUtiNet   := 0;
    vi_nUtiNetMN := 0;
  
    vi_nUtiNetME := 0;
  
    --RESULTADO NETO MENSUAL
    vo_nResNetMen   := 0;
    vi_nResNetMenMN := 0;
    vi_nResNetMenME := 0;
  
    --RATIO DEUDA TOTAL/PATRIMONIO
    vo_nRatDeuTotPat := 0;
    --Gastos Financieros, Gastos Financieros Familiares
    vi_nGasFin      := 0;
    vi_nGasFinME    := 0;
    vi_nGasFinMN    := 0;
    vi_nGasFinFam   := 0;
    vi_nGasFinFamME := 0;
    vi_nGasFinFamMN := 0;
    vo_nTotPas      := 0;
    vi_nTotPasMN    := 0;
    vi_nTotPasME    := 0;
    vo_nTotPat      := 0;
    vi_nTotPatMN    := 0;
    vi_nTotPatME    := 0;
    --drc0518
    vo_nCuoRes          := 0;
    vo_nRatDeuTotIngBru := 0;
  
    BEGIN
      SELECT l.jaqz515pai, l.jaqz515tdo, l.JAQZ515NDO
        INTO vi_JAQZ515PDOC, vi_JAQZ515TDOC, vi_JAQZ515NDOC
        FROM JAQZ515 l
       WHERE JAQZ515INS = ve_instancia;
    exception
      when others then
        null;   
    END;
  
    FOR h in lista_jaqz516(vi_JAQZ515PDOC, vi_JAQZ515TDOC, vi_JAQZ515NDOC) LOOP
      FOR j in lista_jaqz517(h.jaqz516eval) LOOP
        --Montos Concepto Evaluación
      
        IF j.jaqz517cod = 73 THEN
          vi_nVentasMN := j.jaqz517mto;
        END IF;
        IF j.jaqz517cod = 573 THEN
          vi_nVentasME := j.jaqz517mto;
        END IF;
        IF j.jaqz517cod = 53 THEN
          vi_nOtrIngMN := j.jaqz517mto;
        END IF;
        IF j.jaqz517cod = 553 THEN
          vi_nOtrIngME := j.jaqz517mto;
        END IF;
        IF j.jaqz517cod = 84 THEN
          vi_nUtiNetMN := j.jaqz517mto;
        END IF;
        IF j.jaqz517cod = 584 THEN
          vi_nUtiNetME := j.jaqz517mto;
        END IF;
        IF j.jaqz517cod = 40 THEN
          vi_nResNetMenMN := j.jaqz517mto;
        END IF;
        IF j.jaqz517cod = 540 THEN
          vi_nResNetMenME := j.jaqz517mto;
        END IF;
        IF j.jaqz517cod = 65 THEN
          vi_nTotPasMN := j.jaqz517mto;
        END IF;
        IF j.jaqz517cod = 565 THEN
          vi_nTotPasME := j.jaqz517mto;
        END IF;
        IF j.jaqz517cod = 70 THEN
          vi_nTotPatMN := j.jaqz517mto;
        END IF;
        IF j.jaqz517cod = 570 THEN
          vi_nTotPatME := j.jaqz517mto;
        END IF;
        IF j.jaqz517cod = 79 THEN
          vi_nGasFinMN := j.jaqz517mto;
        END IF;
        IF j.jaqz517cod = 579 THEN
          vi_nGasFinME := j.jaqz517mto;
        END IF;
        IF j.jaqz517cod = 19 THEN
          vi_nGasFinFamMN := j.jaqz517mto;
        END IF;
        IF j.jaqz517cod = 519 THEN
          vi_nGasFinFamME := j.jaqz517mto;
        END IF;
      End Loop;
    End loop;
    vo_nVentas := vi_nVentasMN + (vi_nVentasME * ve_SNG120TCbi);
    vo_nOtrIng := vi_nOtrIngMN + (vi_nOtrIngME * ve_SNG120TCbi);
    vo_nIngBru := vo_nVentas + vo_nOtrIng;
  
    vi_nGasFin    := vi_nGasFinMN + (vi_nGasFinME * ve_SNG120TCbi);
    vi_nGasFinFam := vi_nGasFinFamMN + (vi_nGasFinFamME * ve_SNG120TCbi);
    --cuotas en el sistema financiero - de evaluación
    vo_nCuoSF       := vi_nGasFin + vi_nGasFinFam;
    vi_AQPB081CCALC := 0;
  
    For y in lista_AQPB081 loop
      If SubStr(y.aqpb081RUBR, 3, 1) = '1' then
        --vi_JAQY327CCALC := vi_JAQY327CCALC + JAQY327CCALC;
        vi_AQPB081CCALC := vi_AQPB081CCALC + y.AQPB081CCALC;
      Else
        --vi_JAQY327CCALC := vi_JAQY327CCALC + (JAQY327CAQPBCALC * vi_SNG120TCbi);
        vi_AQPB081CCALC := vi_AQPB081CCALC +
                           (y.AQPB081CCALC * ve_SNG120TCbi);
      End If;
    End Loop;
  
    If vi_AQPB081CCALC <> 0 THEN
      vo_nCuoSF := vi_AQPB081CCALC;
    End If;
    vo_nCuoTot    := ve_nCuoCajAqp + vo_nCuoSF + nvl(ve_JAQY490CPO,0);
    vo_nUtiNet    := vi_nUtiNetMN + (vi_nUtiNetME * ve_SNG120TCbi);
    vo_nIngNet    := vo_nUtiNet + vo_nOtrIng;
    vo_nResNetMen := vi_nResNetMenMN + (vi_nResNetMenME * ve_SNG120TCbi);
    vo_nTotPas    := vi_nTotPasMN + (vi_nTotPasME * ve_SNG120TCbi);
    vo_nTotPat    := vi_nTotPatMN + (vi_nTotPatME * ve_SNG120TCbi);
    If vo_nTotPat <> 0 then
      vo_nRatDeuTotPat := vo_nTotPas / vo_nTotPat;
    End If;
    vo_nDeuTotIngNetMen := 0;
    If vo_nIngNet <> 0 THEN
      vo_nDeuTotIngNetMen := nvl(ve_JAQY490DTI,0) / vo_nIngNet;
    End If;
    vo_nRatCuoTotResNet := 0;
    If (vo_nResNetMen + vo_nCuoSF + nvl(ve_JAQY490CPO,0)) <> 0 THEN
      vo_nRatCuoTotResNet := vo_nCuoTot /
                             (vo_nResNetMen + vo_nCuoSF + nvl(ve_JAQY490CPO,0));
    End If;
  
    If vo_nVentas <= 4800 THEN
      vo_nSegInd := 1;
    Else
      If vo_nVentas > 4800 And vo_nVentas <= 19800 THEN
        vo_nSegInd := 2;
      Else
        If vo_nVentas > 19800 THEN
          vo_nSegInd := 3;
        End If;
      End If;
    End If;
  
    vi_jaqy140corr := 0;
    FOR z in lista_jaqy140 LOOP
      If z.jaqy140corr > vi_jaqy140corr THEN
        vo_nCuoRes     := z.jaqy140ratio;
        vi_jaqy140corr := z.jaqy140corr;
      End If;
    End Loop;
    If vo_nIngBru <> 0 then
      vo_nRatDeuTotIngBru := nvl(ve_JAQY490STD,0) / vo_nIngBru;
    End If;
  END;
  -------------------------------------------
  -------------------------------------------
  procedure sp_cr_SegmntoActual(ln_Instancia     in number,
                                lc_SegmntoActual out number) is
    ln_pais   number;
    ln_tdoc   number;
    lc_nrodoc char(12);
  
  begin
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_nrodoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;   
    end;
    if ln_tdoc <> 9 then
      begin
        select to_number(trim(b.segcod))
          into lc_SegmntoActual
          from sngc60 a, sngc07 b
         where a.sngc60pais = ln_pais
           and a.sngc60tdoc = ln_tdoc
           and a.sngc60ndoc = lc_nrodoc
           and a.sngc60ocup = b.sngc07cod;
      exception
        when too_many_rows then
          begin
            select to_number(trim(b.segcod))
              into lc_SegmntoActual
              from sngc60 a, sngc07 b
             where a.sngc60pais = ln_pais
               and a.sngc60tdoc = ln_tdoc
               and a.sngc60ndoc = lc_nrodoc
               and a.sngc60ocup = b.sngc07cod
               and a.sngc60corr =
                   (select min(a.sngc60corr)
                      from sngc60 a, sngc07 b
                     where a.sngc60pais = ln_pais
                       and a.sngc60tdoc = ln_tdoc
                       and a.sngc60ndoc = lc_nrodoc
                       and a.sngc60ocup = b.sngc07cod);
          end;
        when others then
          null;
      end;
    else
      if ln_tdoc = 9 then
        lc_SegmntoActual := 1;
      end if;
    end if;
  end sp_cr_SegmntoActual;
  -------------------------------------------
  -------------------------------------------
  procedure SP_VALIDAR_EXCEPTION(ve_cTipCre     in varchar,
                                 ve_XWfModulo   in varchar,
                                 ve_instancia   in number,
                                 vo_JAQY490AEXC out varchar,
                                 vo_JAQY490ACOM out varchar,
                                 vo_cSOBEND     in out varchar,
                                 vo_ln_valcri1  out number,
                                 vo_ln_valcri2  out number,
                                 vo_ln_valcri3  out number,
                                 vo_ln_valcri4  out number)
  
   IS
  
  BEGIN
  
    vo_JAQY490AEXC := '';
    vo_JAQY490ACOM := '';
    --Tipo de Crédito -   Mediana Empresa, Gran Empresa y Corporativos
    If vo_JAQY490AEXC = '' THEN
      If ve_cTipCre = '12' Or ve_cTipCre = '11' Or ve_cTipCre = '10' THEN
        vo_JAQY490AEXC := 'S';
        If ve_cTipCre = '12' THEN
          vo_JAQY490ACOM := 'Mediana Empresa';
        End If;
        If ve_cTipCre = '11' THEN
          vo_JAQY490ACOM := 'Gran Empresa';
        End If;
        If ve_cTipCre = '10' THEN
          vo_JAQY490ACOM := 'Corporativos';
        End If;
      End If;
    End If;
  
    --CARTAS FIANZA //PIGNORATICIO
    If vo_JAQY490AEXC = '' THEN
      --CARTAS FIANZA
      If ve_XWfModulo = 141 THEN
        vo_JAQY490AEXC := 'S';
        vo_JAQY490ACOM := 'Cartas Fianza';
      End If;
      --PIGNORATICIO
      If ve_XWfModulo = 108 THEN
        vo_JAQY490AEXC := 'S';
        vo_JAQY490ACOM := 'Pignoraticio';
      End If;
    
    End If;
    If vo_JAQY490AEXC = '' THEN
      begin
        select 'S', 'Operación Colateralizada con DPF'
          into vo_JAQY490AEXC, vo_JAQY490ACOM
          from SNG122 s
         inner join FSR011 r
            on s.sng122pgc = r.r2cod
           and s.sng122mod = r.r2mod
           and s.sng122cta = r.r2cta
           and s.sng122oper = r.r2oper
           and s.sng122sbop = r.r2sbop
           and s.sng122suc = r.r2suc
           and s.sng122mda = r.r2mda
           and s.sng122pap = r.r2pap
           and r.relcod = 2 --DEPOSITO AFECTADO EN GARANTIA
           and r.r1mod = 22 --GARANTIA
         WHERE s.sng122inst = ve_instancia;
      EXCEPTION
        WHEN OTHERS THEN
          null;
      end;
    End If;
  
    If vo_JAQY490AEXC = 'S' THEN
      vo_cSOBEND    := '0';
      vo_ln_valcri1 := 0;
      vo_ln_valcri2 := 0;
      vo_ln_valcri3 := 0;
      vo_ln_valcri4 := 0;
    End If;
  END;
  -------------------------------------------

  procedure sp_cr_CuotaEstimad(ln_mod10   in number,
                               ln_suc10   in number,
                               ln_mda10   in number,
                               ln_pap10   in number,
                               ln_cta10   in number,
                               ln_oper10  in number,
                               ln_sbop10  in number,
                               ln_tope10  in number,
                               tipocambio in number,
                               ln_formula out number) is
  
    ln_plazo  number := 0;
    ln_tasa   number(17, 6) := 0.00;
    ln_saldo  number(17, 2) := 0.00;
    ln_cuotas number;
  
  begin
  
    BEGIN
      select x.xllcapital, x.xllcantcuo, x.xllperiodo, x.xlltasap
        into ln_saldo, ln_cuotas, ln_plazo, ln_tasa
        from x054023 x
       where x.xllpgcod = 1
         and x.xllaomod = ln_mod10
         and x.xllaosuc = ln_suc10
         and x.xllaomda = ln_mda10
         and x.xllaopap = ln_pap10
         and x.xllaocta = ln_cta10
         and x.xllaooper = ln_oper10
         and x.xllaosbop = 609
         and x.xllaotop = ln_tope10;
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    if ln_mda10 = 101 then
      ln_saldo := ln_saldo * tipocambio;
    end if;
  
    if ln_mod10 <> 33 and ln_tasa > 0 and ln_plazo > 0 and ln_saldo > 0 and
       ln_cuotas > 0 then
    
      begin
      
        ln_tasa := ((power(1 + (ln_tasa / 100), (ln_plazo / 360))) - 1) * 100;
      end;
    
      begin
      
        ln_formula := round(ln_saldo *
                            (((ln_tasa / 100) *
                            (power(1 + (ln_tasa / 100), ln_cuotas))) /
                            (power(1 + (ln_tasa / 100), ln_cuotas) - 1)),
                            2);
      
      end;
    
    end if;
  end sp_cr_CuotaEstimad;
  -------------------------------------------
end pq_cr_sobreendeudamiento;
/

