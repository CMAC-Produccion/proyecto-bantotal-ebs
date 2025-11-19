create or replace package PQ_CR_BOT__APROB_REPROG is
   -- *****************************************************************
    -- Nombre                     : PQ_CR_BOT__APROB_REPROG
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 10/04/2025 14:16:53
    -- Autor de Creación          : IGS_RCASTRO
    -- Uso                        : Bot de reprogramaciones
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************

  PROCEDURE SP_ENVIO_CORREO_BOT(P_CORR_REPRO NUMBER,
                                INSTANCIA    NUMBER,
                                P_USUARIOING VARCHAR2,
                                P_ASUNTO     VARCHAR2,
                                P_MENSAJE    VARCHAR2,
                                P_CORRPARA   VARCHAR2,
                                P_CORRDE     VARCHAR2);

  PROCEDURE SP_INSERT_AQPC565(P_CORR_REPRO   NUMBER,
                              INSTANCIA      NUMBER,
                              P_USUARIOING   VARCHAR2,
                              P_AQPC565IDCPE NUMBER,
                              P_ASUNTO       VARCHAR2,
                              P_MENSAJE      VARCHAR2,
                              P_CORRPARA     VARCHAR2,
                              P_CORRDE       VARCHAR2);

  procedure sp_cr_llamado_reprogramacion(ve_corr       in number,
                                         ve_usuario    in varchar,
                                         ve_coment     in varchar,
                                         ve_est        in varchar,
                                         ve_fec_reprog in date,
                                         ve_cod_reprog in number,
                                         ve_inst       in number);

end PQ_CR_BOT__APROB_REPROG;
/
create or replace package body PQ_CR_BOT__APROB_REPROG is

  PROCEDURE SP_ENVIO_CORREO_BOT(P_CORR_REPRO NUMBER,
                                INSTANCIA    NUMBER,
                                P_USUARIOING VARCHAR2,
                                P_ASUNTO     VARCHAR2,
                                P_MENSAJE    VARCHAR2,
                                P_CORRPARA   VARCHAR2,
                                P_CORRDE     VARCHAR2) IS
    V_AQPC565IDCPE NUMBER(6);
    V_AQPC565CORR  NUMBER(12);
    V_AQPC565CORR2 NUMBER(12);
    V_COERR        NUMBER(5);
    V_MSGGERR      VARCHAR2(100);
  BEGIN
    V_AQPC565IDCPE := 6;
  
    BEGIN
      PQ_CR_BOT__APROB_REPROG.SP_INSERT_AQPC565(P_CORR_REPRO   => P_CORR_REPRO,
                                                INSTANCIA      => INSTANCIA,
                                                P_USUARIOING   => P_USUARIOING,
                                                P_AQPC565IDCPE => V_AQPC565IDCPE,
                                                P_ASUNTO       => P_ASUNTO,
                                                P_MENSAJE      => P_MENSAJE,
                                                P_CORRPARA     => P_CORRPARA,
                                                P_CORRDE       => P_CORRDE);
    
    END;
  
    BEGIN
      PQ_CR_PROCESOS_BOT.sp_cr_devolver_corr_exte(V_AQPC565IDCPE,
                                                  INSTANCIA,
                                                  V_AQPC565CORR,
                                                  V_AQPC565CORR2,
                                                  V_COERR,
                                                  V_MSGGERR);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    V_COERR := NVL(V_COERR, 0);
  
    --llamar al proceso q ejeucta el bot
    IF V_COERR = 0 THEN
      BEGIN
        PQ_CR_PROCESAR_BOT.SP_ENVIAR_MAIL_BOT(VI_IDCORRELATIVO => V_AQPC565CORR,
                                              VI_GESTION       => 0,
                                              VI_IDCODIGOPE    => V_AQPC565IDCPE,
                                              VI_ID_CODIGOPI   => V_AQPC565CORR2,
                                              VI_INSTANCIA     => INSTANCIA,
                                              VI_AUXILIAR1     => 0,
                                              VI_AUXILIAR2     => '',
                                              VI_CODERROR      => V_COERR,
                                              VI_MSGERROR      => V_MSGGERR);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  END;

  PROCEDURE SP_INSERT_AQPC565(P_CORR_REPRO   NUMBER,
                              INSTANCIA      NUMBER,
                              P_USUARIOING   VARCHAR2,
                              P_AQPC565IDCPE NUMBER,
                              P_ASUNTO       VARCHAR2,
                              P_MENSAJE      VARCHAR2,
                              P_CORRPARA     VARCHAR2,
                              P_CORRDE       VARCHAR2) IS
    vi_emp  xwf700.xwfempresa%type;
    vi_suc  xwf700.xwfsucursal%type;
    vi_mod  xwf700.xwfmodulo%type;
    vi_mda  xwf700.xwfmoneda%type;
    vi_pap  xwf700.xwfpapel%type;
    vi_cta  xwf700.xwfcuenta%type;
    vi_ope  xwf700.xwfoperacion%type;
    vi_sbop xwf700.xwfsubope%type;
    vi_tope xwf700.xwftipope%type;
  
    V_AQPC565ASBOT VARCHAR2(350);
    V_AQPC565VAR   VARCHAR2(3000);
    V_CODERROR     VARCHAR2(10);
    V_MSGERROR     VARCHAR2(100);
  BEGIN
    V_AQPC565ASBOT := 'Autorización de Reprogramación';
    /*--  OBTEBER-VARIABLES(
                        IN COD DE REPROGRAMACION 
                        IN INSTANCIA 
                        OUT AQPC565
                        OUT MSGERROR
                        OUT CODERROR
                      )
                      
    
    aqpb556  -> valores ve_fec_reprogramacion   aqpb556fecrpg
                cod de repro 
                instancia 
                
                 inst|N|valor(inst)
                 
     */
    BEGIN
      sp_cr_agrega_aqpc565vaR(CODREPROG  => P_CORR_REPRO,
                              INSTANCIA  => INSTANCIA,
                              AQPC565VAR => V_AQPC565VAR,
                              CODERROR   => V_CODERROR,
                              MSGERROR   => V_MSGERROR);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT X.XWFEMPRESA,
             X.XWFSUCURSAL,
             X.XWFMODULO,
             X.XWFMONEDA,
             X.XWFPAPEL,
             X.XWFCUENTA,
             X.XWFOPERACION,
             X.XWFSUBOPE,
             X.XWFTIPOPE
        INTO vi_EMP,
             vi_suc,
             vi_mod,
             vi_mda,
             vi_pap,
             vi_cta,
             vi_ope,
             vi_sbop,
             vi_tope
        FROM XWF700 X
       WHERE XWFPRCINS = INSTANCIA
         AND XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      INSERT INTO AQPC565
        (AQPC565PARA,
         AQPC565DE,
         AQPC565IDCPE,
         AQPC565ASNT,
         AQPC565CRPO,
         AQPC565ASBOT,
         AQPC565CBOT1,
         AQPC565GSTN,
         
         AQPC565F_REG,
         AQPC565H_REG,
         AQPC565U_REG,
         
         AQPC565VAR,
         
         Aqpc565inst,
         AQPC565EMP,
         AQPC565SUC,
         AQPC565MOD,
         AQPC565MND,
         AQPC565PAP,
         AQPC565CTA,
         AQPC565OPE,
         AQPC565SOPE,
         AQPC565TOPE,
         AQPC565EST
         
         )
      VALUES
        (
         
         P_CORRPARA,
         P_CORRDE,
         P_AQPC565IDCPE, -- DIFINIDO EN AQPC566
         P_ASUNTO,
         P_MENSAJE,
         V_AQPC565ASBOT,
         '',
         1, -- INDICA Q NECESITA APROB O RECHAZ
         
         TO_DATE(SYSDATE, 'dd/mm/rrrr'),
         TO_CHAR(SYSDATE, 'HH24:MI:SS'),
         P_USUARIOING,
         
         V_AQPC565VAR,
         
         INSTANCIA,
         vi_EMP,
         vi_suc,
         vi_mod,
         vi_mda,
         vi_pap,
         vi_cta,
         vi_ope,
         vi_sbop,
         vi_tope,
         'P'
         
         );
      COMMIT;
    
      /* EXCEPTION
      WHEN OTHERS THEN
        NULL; */
    END;
  END;
  procedure sp_cr_llamado_reprogramacion(ve_corr       in number,
                                         ve_usuario    in varchar,
                                         ve_coment     in varchar,
                                         ve_est        in varchar,
                                         ve_fec_reprog in date,
                                         ve_cod_reprog in number,
                                         ve_inst       in number) is
    vi_cod_error varchar2(4) := '';
    vi_msg_error varchar2(150) := '';
    usuario      varchar2(30) := '';
    estado       varchar2(1) := '';
  begin
  
    begin
      select WFUSRCOD
        into usuario
        from wfusers a
       where a.WFUSREMAIL = RPAD(ve_usuario, 40, ' ')
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    begin
      estado := SUBSTR(ve_est, 1, 1);
    exception
      when others then
        null;
    end;
  
    begin
      pq_cr_reprog_sin_cap.SP_GRABAR_APROBACION(VE_FECHAREG  => ve_fec_reprog,
                                                VE_CODREPROG => ve_cod_reprog,
                                                VE_INSTANCIA => ve_inst,
                                                --
                                                VE_UBUSER     => usuario,
                                                VE_COMENTARIO => ve_coment,
                                                VE_ESTADO     => estado,
                                                --
                                                VO_CODERROR => vi_cod_error,
                                                VO_MSGERROR => vi_msg_error);
    exception
      when others then
        null;
    end;
  
  end sp_cr_llamado_reprogramacion;
end PQ_CR_BOT__APROB_REPROG;
/
