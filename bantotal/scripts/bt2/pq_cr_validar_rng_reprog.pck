create or replace package pq_cr_validar_rng_reprog is

  -- Author  : HSUAREZ
  -- Created : 15/06/2021 22:50:51
  -- Purpose : Paquete para validar las reglas de negocio del panel de reprogramacion
  -- Public Table record
  -- Modificacion: HSUAREZ - 2024.01.18
  -- Detalle:      Se ha agregado controles para el MEMO17-2024, que tiene que ver con plazo, gracia y Opinion de riesgos.
  -- Modificacion: HSUAREZ - 2024.08.16
  -- Detalle:      Se agrego controles para politicas de reprogramados sin capitalización sin CRM, plazo, gracia.
  -- Modificacion: HSUAREZ - 2024.09.03
  -- Detalle:      Se agrego controles para habilitar o deshabilitar controles de Reprogramados por desastre natural.
  -- Modificacion: MCORDOVA - 2024.10.23
  -- Detalle:      Se agrega el llamado para validar ratios SP_CR_RATIOS_REPROGRAMADOS
  -- Modificacion: MCORDOVA - 2025.04.07
  -- Detalle:      Se agrega control de opinion de riesgos segun MEMO
  -- Modificacion: CALARCONAP - 2025.05.02
  -- Detalle:      Se modifica validacion de reprogramaciones por normalizacion
  -- Modificacion: MCORDOVA - 2025.05.19
  -- Detalle:      Se agrega logica para control reprogramaciones gradientes
  -- Modificacion: MCORDOVA - 2025.08.14
  -- Detalle:      Se modifica flag gradientes
  -- Modificacion: MPOSTIGOC - 2025.09.23
  -- Detalle:      Se cambio el mensaje para el control de Limites de Reprogramaciones, lineas 6061 y 6063

  type reglas_excepcion is record(
    v_codigo      number(10),
    v_regla       varchar2(40),
    v_descripcion varchar2(250));

  type v_temp is varray(10) of reglas_excepcion;
  --  type v_temp is REF CURSOR return reglas_excepcion;
  --tab_temp v_temp;

  -- Public type declarations
  procedure sp_cr_validarrng91(ve_pgcod     number,
                               ve_scmod     number,
                               ve_scsuc     number,
                               ve_scmda     number,
                               ve_scpap     number,
                               ve_sccta     number,
                               ve_scoper    number,
                               ve_scsbop    number,
                               ve_sctope    number,
                               ve_instancia number,
                               ve_indicador out varchar,
                               ve_mensaje   out varchar);
  PROCEDURE SP_GRABAR_LOG_RNG(VE_NRO       NUMBER, --CORRELATIVO
                              ve_variable  varchar, --VARIABLE
                              ve_valor     varchar, --VALOR
                              ve_regla     number, --REGLA
                              ve_instancia number --INSTANCIA
                              );
  PROCEDURE sp_cr_val_reprog_fondo(ve_instancia number,
                                   --ve_indicador out varchar,
                                   ve_mensaje out varchar2);
  PROCEDURE SP_CR_VTASA(ve_instancia number, --INSTANCIA
                        ve_vtasa     out varchar);
  PROCEDURE sp_validar_reglas_general(ve_instancia in number, --INSTANCIA
                                      VI_NRO       in number, --CORRELATIVO
                                      ve_vfondo    in varchar, --SI ES FONDOS
                                      ve_excepcion in varchar, -- ACTIVAR CASRGAR REGLA
                                      ve_user      in varchar,
                                      ve_mensaje   out varchar2 --MENSAJE DEVUELTO
                                      );

  PROCEDURE SP_VALIDAR_REGLAS_UNIV(ve_instancia in number, --INSTANCIA
                                   VI_NRO       in number, --CORRELATIVO
                                   ve_mensaje   out varchar --MENSAJE DEVUELTO
                                   );
  PROCEDURE SP_VALIDAR_REGLAS_CAJA(ve_instancia in number,
                                   vi_nro       in number,
                                   ve_mensaje   out varchar);
  PROCEDURE SP_VALIDAR_REGLAS_CAJA_RT_EXO_AMO(ve_instancia in number,
                                              vi_nro       in number,
                                              ve_excepcion in varchar,
                                              ve_user      in varchar,
                                              ve_mensaje   out varchar);
  PROCEDURE SP_VALIDAR_REGLAS_CAJA_SOLJ(ve_instancia   in number,
                                        vi_nro         in number,
                                        ve_excepcion   in varchar, --SE AGREGO PARAMETRO ADICIONAL 09.05.2022
                                        ve_user        in varchar, --SE AGREGO PARAMETRO ADICIONAL 09.05.2022
                                        ve_tipo_reprog in varchar,
                                        ve_mensaje     out varchar);
  PROCEDURE SP_OBTENER_PERIODO(ve_instancia number, ve_rpta out number);
  PROCEDURE SP_OBTENER_LIM_VAR(VE_VARIABLE IN VARCHAR, VO_RPTA OUT VARCHAR);
  PROCEDURE SP_OBTENER_EXCEPCION_REGLA(VI_NRO       NUMBER,
                                       VE_INSTANCIA IN NUMBER,
                                       VE_VARIABLE  IN VARCHAR,
                                       VO_RPTA      OUT VARCHAR);
  PROCEDURE SP_DESACTIVAR_REGLA(VI_NRO       NUMBER,
                                VE_INSTANCIA NUMBER,
                                VE_VARIABLE  IN VARCHAR,
                                VO_RPTA      OUT VARCHAR);
  PROCEDURE SP_CONTROL_EXONERACION(VE_INSTANCIA NUMBER,
                                   VE_RPTAC     OUT VARCHAR);
  PROCEDURE SP_GRABAR_LOG_DE_RNG(
                                 --VE_NRO NUMBER, --CORRELATIVO
                                 ve_variable  varchar, -- VARIABLE (máximo 30)
                                 ve_valor     varchar, -- VALOR (máximo 30)
                                 ve_regla     number, -- REGLA
                                 ve_flujo     varchar, -- FLUJO
                                 ve_usuario   varchar, -- USUARIO
                                 ve_sucursal  number, -- SUCURSAL
                                 ve_instancia number --INSTANCIA
                                 );
  PROCEDURE SP_VALIDAR_REPROGRAMADO_GRUPO_NF(ve_instancia number,
                                             vo_rpta      out varchar);
  PROCEDURE SP_OBTENER_DIF_FECVENC(VE_INSTANCIA NUMBER, VO_DIAS OUT NUMBER);
  PROCEDURE SP_CONTROLAR_COMENTARIOS(ve_instancia number,
                                     ve_rpta      out varchar2);
  PROCEDURE SP_VALIDAR_REPROG_CRM(ve_instancia number,
                                  ve_rpta      out varchar2);
  -- Author  : IGS_MCHAVEZ
  -- Created : 25/03/2022 21:56:45
  -- Purpose : Validar que no ingresen cuotas 0

  PROCEDURE SP_CR_VALIDAR_CUOTA(INS IN NUMBER, RESP OUT VARCHAR2);

  PROCEDURE SP_CARGAR_REGLAS_EXCEPCION(ve_Instancia number,
                                       VI_NRO       number,
                                       VE_USER      varchar);
  PROCEDURE SP_GRABAR_LISTA_EXCEPCION(ve_variable  varchar, --VARIABLE
                                      ve_mensaje   varchar, --VALOR
                                      ve_regla     number, --REGLA
                                      ve_instancia number, --INSTANCIA
                                      ve_usuario   varchar --USUARIO
                                      );
  PROCEDURE SP_SAVE_EXCEPCION_HS(ve_codigo      number,
                                 ve_estado      varchar,
                                 ve_autorizador varchar,
                                 vo_coderror    out number,
                                 vo_msgerror    out varchar);
  PROCEDURE SP_DESACTIVA_REGLA_AUTM(VE_CODIGO      NUMBER,
                                    VE_ESTADO      VARCHAR,
                                    VE_AUTORIZADOR VARCHAR,
                                    VE_RPTA        OUT VARCHAR,
                                    VO_CODERROR    OUT NUMBER,
                                    VO_MSGERROR    OUT VARCHAR);
  PROCEDURE SP_OBTENER_AUTOR_EXCEP(ve_analista    varchar, -- V(10)
                                   ve_instancia   number, --N(10)
                                   ve_saldocap    number, --N(17,2)
                                   vo_autorizador out varchar, --V(10)
                                   vo_coderror    out number, --N(3)
                                   vo_msgerror    out varchar --V(250)
                                   );
  PROCEDURE SP_EXCEPTUAR_REGLA_VAR(VE_INSTANCIA NUMBER,
                                   VE_FECHA     DATE,
                                   VE_VARIABLE  VARCHAR,
                                   VO_RPTA      OUT VARCHAR);

  PROCEDURE SP_OBTENER_PRESETEO(VE_INSTANCIA  IN NUMBER,
                                VI_PLAZO_GUIA OUT NUMBER,
                                VI_PLAZO_609  OUT NUMBER,
                                VO_EXCEPCION  OUT VARCHAR);
  --20.06.2022 - PLAZO RESIDUAL.
  PROCEDURE SP_OBTENER_PLAZO_RESIDUAL(ve_instancia in int,
                                      vi_plzo_res  out number);
  PROCEDURE SP_VALIDAR_LISTA(ve_instancia   number,
                             ve_rpta        OUT varchar,
                             ve_descripcion OUT varchar);

  --08.02.2023 - BASE SINCERAMIENTO                           
  PROCEDURE SP_VALIDAR_SI_EN_LISTA_EXCP(ve_instancia in number,
                                        ve_rpta      OUT varchar2);
  PROCEDURE SP_VALIDAR_CREDITOS_CRM(ve_instancia   in number,
                                    vi_nro         in number,
                                    vi_mensaje_crm out varchar);
  PROCEDURE SP_REGLAS_LOGS_EXCEPTION(VE_NRO         IN NUMBER,
                                     VE_INSTANCIA   IN NUMBER,
                                     VE_VARIABLE    IN VARCHAR,
                                     VE_RPTAC       IN VARCHAR,
                                     VE_COD_REGLA   IN NUMBER,
                                     VE_EXCEPCION_G OUT VARCHAR,
                                     VE_EXCEPTION_U OUT VARCHAR);
  PROCEDURE SP_VALIDAR_NRO_REPROG(VE_INSTANCIA IN NUMBER,
                                  VE_RPTA      OUT VARCHAR);

  --apachecoh 2023.09.27
  PROCEDURE SP_VALIDAR_LISTA_BI(VE_INSTANCIA   IN NUMBER,
                                VE_NRO_RPG     OUT NUMBER,
                                VE_CARGO_APROB OUT NUMBER,
                                VE_APROBADOR   OUT VARCHAR,
                                VE_RPTA        OUT VARCHAR);
  --HSUAREZ 2024.01.18
  PROCEDURE SP_VALIDAR_NRO_REPROGN(VE_INSTANCIA IN NUMBER,
                                   VO_NRO_RPG   OUT NUMBER);
  PROCEDURE SP_CR_VALIDA_FECHA_REPROGRAMADO(INSTANCIA IN NUMBER,
                                            FLAG      OUT VARCHAR,
                                            CODMSG    OUT VARCHAR2,
                                            DESMSG    OUT VARCHAR2);
  PROCEDURE SP_CR_VALIDA_REPROGRAMADO_DIAS_ATRASO(INSTANCIA IN NUMBER,
                                                  FLAG      OUT VARCHAR,
                                                  CODMSG    OUT VARCHAR2,
                                                  DESMSG    OUT VARCHAR2);
  PROCEDURE SP_VALIDAR_RPDNATURAL_SINCRM(VE_INSTANCE IN NUMBER, --INSTANCIA
                                         VE_NRO      IN NUMBER, --CORRELATIVO
                                         VE_MENSAJE  OUT VARCHAR, --MENSAJE DEVUELTO
                                         VO_CODERROR OUT VARCHAR,
                                         VO_MSGERROR OUT VARCHAR);
  PROCEDURE SP_CR_VALIDA_EXCEPCION_CRM(INSTANCIA IN NUMBER,
                                       FLAG      OUT VARCHAR,
                                       CODMSG    OUT VARCHAR2,
                                       DESMSG    OUT VARCHAR2);
  PROCEDURE SP_VALIDAR_OPINION_RSG(VE_INSTANCE IN NUMBER, --INSTANCIA
                                   VE_NRO      IN NUMBER, --CORRELATIVO
                                   VE_MENSAJE  OUT VARCHAR, --MENSAJE DEVUELTO
                                   VO_CODERROR OUT VARCHAR,
                                   VO_MSGERROR OUT VARCHAR);
  PROCEDURE SP_CR_RATIOS_REPROGRAMADOS(V_INSTANCIA     in number,
                                       V_USUARIO       in varchar2,
                                       V_FLAG          out varchar2,
                                       V_CODIGO_ERROR  out varchar2,
                                       V_MENSAJE_ERROR out varchar2);
  PROCEDURE SP_BLOQUEO_CREDINKA(P_INSTANCIA IN NUMBER,
                                P_USUARIO   IN VARCHAR2,
                                P_RESPUESTA OUT VARCHAR2,
                                P_COD_ERROR OUT VARCHAR2,
                                P_MENSAJE   OUT VARCHAR2);
end pq_cr_validar_rng_reprog;
/
create or replace package body pq_cr_validar_rng_reprog is
  -- Author  : HSUAREZ
  -- Created : 15/06/2021 22:50:51
  -- Purpose : Paquete para validar las reglas de negocio del panel de reprogramacion
  -- Public Table record
  -- Modificacion: HSUAREZ - 2024.01.18
  -- Detalle:      Se ha agregado controles para el MEMO17-2024, que tiene que ver con plazo, gracia y Opinion de riesgos.
  -- Modificacion: HSUAREZ - 2024.08.16
  -- Detalle:      Se agrego controles para politicas de reprogramados sin capitalización sin CRM, plazo, gracia.
  -- Modificacion: HSUAREZ - 2024.09.03
  -- Detalle:      Se agrego controles para habilitar o deshabilitar controles de Reprogramados por desastre natural.
  -- Modificacion: MCORDOVA - 2024.10.23
  -- Detalle:      Se agrega el llamado para validar ratios SP_CR_RATIOS_REPROGRAMADOS
  -- Modificacion: HSUAREZ - 2025.03.31
  -- Detalle:      Se agrega una bloqueante general para creditos credinka, no se pueden reprogamar por este medio.
  -- Modificacion: CALARCONAP - 2025.01.21
  -- Detalle:      Se modifica validacion de reprogramaciones por normalizacion
  -- Modificacion: MCORDOVA - 2025.05.20
  -- Detalle:      Se agrega logica para control reprogramaciones gradientes
  -- Modificacion: MCORDOVA - 2025.08.08
  -- Detalle:      Se modifica flag de periodo gracia
  -- Modificacion: MCORDOVA - 2025.08.14
  -- Detalle:      Se modifica flag gradientes
  -- Modificacion: MPOSTIGOC - 2025.09.23
  -- Detalle:      Se cambio el mensaje para el control de Limites de Reprogramaciones, lineas 6061 y 6063
  -----------------------------------------------------------------------------------------------------------------
  procedure sp_cr_validarrng91(ve_pgcod     number,
                               ve_scmod     number,
                               ve_scsuc     number,
                               ve_scmda     number,
                               ve_scpap     number,
                               ve_sccta     number,
                               ve_scoper    number,
                               ve_scsbop    number,
                               ve_sctope    number,
                               ve_instancia number,
                               ve_indicador out varchar,
                               ve_mensaje   out varchar) is
  begin
    null;
    ve_mensaje := 'N';
  end;

  PROCEDURE sp_cr_val_reprog_fondo(ve_instancia number,
                                   --ve_indicador out varchar,
                                   ve_mensaje out varchar2) is
    ve_rptac              varchar(150);
    ve_rptan              number(17, 6);
    VI_FECHA              DATE;
    VI_HORA               CHAR(8);
    VI_NRO                number(16);
    VI_VTASA              VARCHAR(1);
    VI_USUARIO            VARCHAR(10);
    VI_REGLA              NUMBER(10);
    VI_PERFIL             varchar(200);
    VI_PROGRAMA           VARCHAR(40);
    VI_VFONDO             VARCHAR(1);
    VI_LIMITE_CUO         NUMBER(3);
    vi_tieneOpinion       number(3);
    vi_TipoOpinion        varchar(3);
    vi_mensaje            varchar(250);
    vi_mensaje_caja       varchar(250);
    vi_tipo_reprog        VARCHAR(5);
    VI_EXCEPCION          number(17);
    vi_mensaje_crm        VARCHAR2(250);
    VE_RPTA_DESACTIVA_REG VARCHAR2(3);
    --
    vo_excepcion           VARCHAR2(3);
    VO_CODERROR            VARCHAR(5);
    VO_MSGERROR            VARCHAR(250);
    VIO_RPTA_DESACTIVA_REG VARCHAR2(10);
    VIO_EXCEPCION          VARCHAR2(10);
  
    VE_RPTAMSG VARCHAR2(100);
  
    --apacheco 31.12.2021 bloqueo
    ve_mensaje_bloqueo varchar(250);
    cursor mensaje_bloqueo_fondos is
      select tp1desc
        from fst198
       where tp1cod1 = 10899
         and tp1corr1 = 400000
         and tp1corr2 = 602
         and tp1corr3 > 0
         and tp1nro1 = 1;
  begin
  
    VI_LIMITE_CUO := 36;
    --OBTENER CORRELATIVO
    VI_NRO := 0;
    BEGIN
      SELECT NVL(MAX(AQPB582NRO), 0) INTO VI_NRO FROM AQPB582;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        VI_NRO := 1;
    END;
    VI_NRO := VI_NRO + 1;
    --INICIALIZAR VARIABLES DE CONTROL
    --VALIDAR SI ES REPROGRAMA FONDO.
    ve_mensaje := '';
    pq_cr_validar_rng_reprog.sp_validar_creditos_crm(ve_instancia,
                                                     vi_nro,
                                                     vi_mensaje_crm);
  
    IF LENGTH(VI_MENSAJE_CRM) = 0 or VI_MENSAJE_CRM IS NULL THEN
    
      pq_cr_rt_reprogramacion2.sp_cr_existe_creditocrm(VE_INSTANCIA,
                                                       VI_VFONDO);
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'VALIDAR_ESRPG_FONDOS', --variable
                                                 VI_VFONDO, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
      --apacheco 31.12.2021 bloqueo
      IF VI_VFONDO = 'S' THEN
        ve_mensaje_bloqueo := '';
        for jj in mensaje_bloqueo_fondos loop
          ve_mensaje_bloqueo := ve_mensaje_bloqueo || ' ' || jj.tp1desc;
        end loop;
      END IF;
      -----------------------------------------------------------------------------------
      -- VALIDAR TODAS LAS REGLAS
      -----------------------------------------------------------------------------------
      ve_mensaje := '';
      ----15/07/2025
      begin
        ve_rptac := '';
        pq_cr_controles_cartera_reprogramada.sp_cr_cliente_validar_instancia(VE_INSTANCIA,
                                                                             VE_RPTAC,
                                                                             VE_RPTAMSG);
      
        PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                   'LISTNEGR_MEMO225', --variable
                                                   VE_RPTAC, --valor
                                                   91, --regla
                                                   ve_instancia --instancia
                                                   );
      
        PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                     VE_INSTANCIA,
                                                     'LISTNEGR_MEMO225',
                                                     VE_RPTA_DESACTIVA_REG);
      
        IF trim(ve_rptac) <> 'S' OR VE_RPTA_DESACTIVA_REG = 'S' THEN
          --VE_MENSAJE:= '';
          NULL;
        ELSE
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
            VE_MENSAJE := VE_MENSAJE || ';' || 'RSC: ' || VE_RPTAMSG;
          ELSE
            ve_mensaje := 'RSC: ' || VE_RPTAMSG;
          END IF;
        END IF;
        ve_rptac := '';
      exception
        when others then
          null;
      end;
      ----15/07/2025      
    
      pq_cr_funciones_cho.sp_indicador_CRM_Caja(ve_instancia, VE_RPTAC);
      vi_tipo_reprog := VE_RPTAC;
      IF VE_RPTAC != 'N' THEN
        -- INICIO DE CONDICION GENERAL
        PQ_CR_VALIDAR_RNG_REPROG.sp_validar_reglas_univ(ve_instancia, --INSTANCIA
                                                        VI_NRO, --CORRELATIVO
                                                        ve_mensaje --MENSAJE DEVUELTO
                                                        );
      
        PQ_CR_VALIDAR_RNG_REPROG.SP_VALIDAR_REGLAS_CAJA(ve_instancia, --INSTANCIA
                                                        VI_NRO, --CORRELATIVO
                                                        vi_mensaje_caja --MENSAJE DEVUELTO
                                                        );
      
        ------------------------------------------------------------------------------------
        -- VALIDAR SOLO FONDOS
        -----------------------------------------------------------------------------------
      
        IF VI_VFONDO = 'S' THEN
          --VALIDAR PLAZO CUOTAS INICIO
          ve_rptac := '';
          /*
          PQ_CR_RN_REPROG_FONDOS.sp_cr_validar_plazo_reprog(
          
                                                              VE_INSTANCIA,
                                                              ve_rptac --DEVUELVE N BLOQUEA S NO BLOQUEA 04.01.2022 - APACHECOH
          );
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(
                                                     VI_NRO,
                                                     'RPG_FOND_PLZ',--variable
                                                     ve_rptac,--valor
                                                     91,--regla
                                                     ve_instancia--instancia
                                                    );
          IF ve_rptac <> 'N' THEN
             --ve_mensaje := '';
             NULL;
          ELSE
             ve_mensaje := 'REPROG FONDOS: PLAZ MAYOR AL PERMITIDO, CONSIDERAR LA CUOTAS YA PAGADAS.';
             RETURN;
          END IF;
          */
          --FIN BLOQUEO PLAZO CUOTAS.
          --VALIDAR QUE NO TENGA TASA
          pq_cr_validar_rng_reprog.sp_cr_vtasa(VE_INSTANCIA, -- INSTANCIA
                                               VI_VTASA --VALOR DEVUELTO
                                               );
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                     'VALIDAR_TASA_FUT', --variable
                                                     VI_VTASA, --valor
                                                     91, --regla
                                                     ve_instancia --instancia
                                                     );
        
          IF VI_VTASA <> 'N' THEN
            --ve_mensaje := '';
            NULL;
          ELSE
            --ve_mensaje := 'REPROG FONDOS: ERROR VERIFICAR TASA';
          
            IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
               LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
              VE_MENSAJE := VE_MENSAJE || ';' ||
                            'RSC: REPROG FONDOS: ERROR VERIFICAR TASA';
            ELSE
              ve_mensaje := 'RSC: REPROG FONDOS: ERROR VERIFICAR TASA';
            END IF;
            --RETURN;
          END IF;
          --OBTENER PERFIL
          pq_cr_rt_reprogramacion2.sp_cr_perfil(VE_INSTANCIA,
                                                VI_PERFIL --ecollado 23/12/2022
                                                );
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                     'PERFIL_FONDOS', --variable
                                                     to_char(VI_PERFIL), --valor
                                                     91, --regla
                                                     ve_instancia --instancia
                                                     );
          --OBTENER TIPO PROGRAMA
          pq_cr_rt_reprogramacion2.sp_cr_tipo_programa(VE_INSTANCIA,
                                                       VI_PROGRAMA);
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                     'PROGRAMA_FONDOS', --variable
                                                     VI_PROGRAMA, --valor
                                                     91, --regla
                                                     ve_instancia --instancia
                                                     );
          --REGLA DE CONTROL DE TASA
          PQ_CR_REPROG_FONDOS_HS.SP_CR_FONDOS_VTASA(VE_INSTANCIA,
                                                    ve_rptac ---DEVUELVE S O N
                                                    );
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                     'VALIDAR_TASA_FONDOS', --variable
                                                     ve_rptac, --valor
                                                     91, --regla
                                                     ve_instancia --instancia
                                                     );
          IF ve_rptac <> 'N' THEN
            --ve_mensaje := '';
            NULL;
          ELSE
            --ve_mensaje := ' REPROG FONDOS:Tasa es menor o mayor al margen permitdo';
          
            IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
               LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
              VE_MENSAJE := VE_MENSAJE || ';' ||
                            'RSC: REPROG FONDOS:Tasa es menor o mayor al margen permitdo';
            ELSE
              ve_mensaje := 'RSC: REPROG FONDOS:Tasa es menor o mayor al margen permitdo';
            END IF;
          
            --RETURN;
          END IF;
          VE_RPTAC := '';
          --REGLA DE CONTROL DE PLAZO REACTIVA Y FAE
          --REGLA REACTIVA DEVUELVE LA CANTIDAD E CUOTAS NO DEBE SER MAYOR A 36
          PQ_CR_CTRL_REPROFONDOS.sp_cr_nrocuotas(VE_INSTANCIA, ve_rptan);
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                     'NRO_CUOTAS_FONDOS', --variable
                                                     TO_CHAR(ve_rptan), --valor
                                                     91, --regla
                                                     ve_instancia --instancia
                                                     );
        
          IF VI_PROGRAMA = 'REACTIVA' THEN
            IF VE_RPTAN <= VI_LIMITE_CUO THEN
              --ve_mensaje := '';
              NULL;
            ELSE
              ve_mensaje := 'REPROG FONDOS: PLAZO MAYOR A ' ||
                            VI_LIMITE_CUO || ' MESES';
            END IF;
          END IF;
          --REGLA DE CONTROL
          PQ_CR_CTRL_REPROFONDOS.sp_cr_plazototal(VE_INSTANCIA, VE_RPTAC);
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                     'PLAZO_TOTAL_FONDOS', --variable
                                                     VE_RPTAC, --valor
                                                     91, --regla
                                                     ve_instancia --instancia
                                                     );
          IF VE_RPTAC <> 'N' THEN
            --ve_mensaje := '';
            NULL;
          ELSE
            -- ve_mensaje := 'REPROG FONDOS: EL PLAZO TOTAL DE LOS CREDITOS NO PUEDE SER MAYOR A 48 MESES';
          
            IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
               LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
              VE_MENSAJE := VE_MENSAJE || ';' ||
                            'RSC: REPROG FONDOS: EL PLAZO TOTAL DE LOS CREDITOS NO PUEDE SER MAYOR A 48 MESES';
            ELSE
              ve_mensaje := 'RSC: REPROG FONDOS: EL PLAZO TOTAL DE LOS CREDITOS NO PUEDE SER MAYOR A 48 MESES';
            END IF;
          
            --RETURN;
          END IF;
          VE_RPTAC := '';
          --REGLA DE CONTROL DE GRACIA REACTIVA Y FAE
          PQ_CR_CTRL_REPROFONDOS.sp_cr_periodgracia(VE_INSTANCIA, VE_RPTAC);
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                     'GRACIA TOTAL_FONDOS', --variable
                                                     VE_RPTAC, --valor
                                                     91, --regla
                                                     ve_instancia --instancia
                                                     );
          IF VE_RPTAC <> 'N' THEN
            --ve_mensaje := '';
            NULL;
          ELSE
            IF VI_PROGRAMA = 'REACTIVA' THEN
              --Ve_mensaje := 'REPROG FONDOS:LA GRACIA SOLO PUEDE SER 180 dias o 363 dias';
              IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
                 LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
                VE_MENSAJE := VE_MENSAJE || ';' ||
                              'RSC: REPROG FONDOS:LA GRACIA SOLO PUEDE SER 180 dias o 363 dias';
              ELSE
                ve_mensaje := 'RSC: REPROG FONDOS:LA GRACIA SOLO PUEDE SER 180 dias o 363 dias';
              END IF;
            
            ELSE
              --Ve_mensaje := 'REPROG FONDOS: LA GRACIA SOLO PUEDE HASTA 363 dias';
              IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
                 LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
                VE_MENSAJE := VE_MENSAJE || ';' ||
                              'RSC: REPROG FONDOS: LA GRACIA SOLO PUEDE HASTA 363 dias';
              ELSE
                ve_mensaje := 'RSC: REPROG FONDOS: LA GRACIA SOLO PUEDE HASTA 363 dias';
              END IF;
            
              --RETURN;
            END IF;
          END IF;
          VE_RPTAC := '';
          --REGLA DE CONTROL DE OPINION PARA EVALUAR
          IF (VI_PERFIL = 4 AND VI_VFONDO = 'S') OR
             (VI_PERFIL = 3 AND VI_VFONDO = 'S') THEN
            pq_cr_reprogramaexo.sp_validaopinion(ve_instancia,
                                                 vi_tieneOpinion,
                                                 vi_TipoOpinion,
                                                 vi_mensaje);
            if vi_tieneOpinion = 1 and vi_TipoOpinion = 'V' THEN
              --&TipoOpinion si es V es viable  y si es N es no viable  //&TieneOpinion=0 no tiene opinion y si es 1 si tiene opinion
              VE_RPTAC := 'S';
            else
              VE_RPTAC := 'N';
            end if;
            --VE_RPTAC:='N';
            PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                       'REQUIERE_OPINION_FONDOS', --variable
                                                       VE_RPTAC, --valor
                                                       91, --regla
                                                       ve_instancia --instancia
                                                       );
            --VE_MENSAJE:= '';
            IF ve_rptac <> 'N' THEN
              --VE_MENSAJE:= '';
              NULL;
            ELSE
              --ve_mensaje := 'REPROG FONDOS: REQUIERE OPINION DE RIESGOS';
              IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
                 LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
                VE_MENSAJE := VE_MENSAJE || ';' ||
                              'RSC: REPROG FONDOS: REQUIERE OPINION DE RIESGOS';
              ELSE
                ve_mensaje := 'RSC: REPROG FONDOS: REQUIERE OPINION DE RIESGOS';
              END IF;
              --RETURN ;
            END IF;
          END IF;
          --apacheco 31.12.2021 bloqueo
          if length(trim(ve_mensaje_bloqueo)) > 0 then
            ve_mensaje := ve_mensaje_bloqueo;
          end if;
        ELSE
          --ve_mensaje:='';
          sp_validar_reglas_general(ve_instancia, --INSTANCIA
                                    VI_NRO, --CORRELATIVO
                                    VI_VFONDO,
                                    'N',
                                    'S',
                                    vi_mensaje --MENSAJE DEVUELTO
                                    );
        END IF;
      
      ELSE
        --FIN DE VE_RPTAC SOBRE VALIDACION SI ES REPROGRAMADO CON CRM
        --VALIDAR EN CASO NO TENGA CRM GESTIONADO
        PQ_CR_VALIDAR_RNG_REPROG.SP_CR_VALIDA_EXCEPCION_CRM(VE_INSTANCIA,
                                                            VE_RPTAC,
                                                            VO_CODERROR,
                                                            VO_MSGERROR);
        IF VE_RPTAC = 'N' THEN
          ve_mensaje := 'RSC: Reprogramación por Desastre Natural no Habilitado';
          return;
        END IF;
        /* DATOS DE LA REGLA DE LA JAQA400 */
        BEGIN
          SELECT J.JAQA400AN1, J.JAQA400USS
            INTO VI_REGLA, VI_USUARIO
            FROM JAQA400 J
           WHERE J.JAQA400AI1 = VE_INSTANCIA
             AND J.JAQA400FEC = (SELECT PGFAPE FROM FST017 WHERE PGCOD = 1);
        EXCEPTION
          WHEN OTHERS THEN
            --dbms_output.put_line(SUBSTR(SQLERRM,1,150));
            NULL;
        END;
        BEGIN
          VE_RPTAC := '';
          PQ_CR_VALIDAR_RNG_REPROG.SP_CONTROLAR_COMENTARIOS(ve_instancia,
                                                            VE_RPTAC);
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                     'V_CONTROL_CMT', --variable
                                                     VE_RPTAC, --valor
                                                     91, --regla
                                                     ve_instancia --instancia
                                                     );
          VE_RPTA_DESACTIVA_REG := 'N';
          PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                       ve_instancia,
                                                       'V_CONTROL_CMT',
                                                       VE_RPTA_DESACTIVA_REG);
          vo_excepcion := 'N';
          PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                              VE_INSTANCIA,
                                                              'V_CONTROL_CMT',
                                                              vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
          --Dbms_Output.put_line('V_CONTROL_CMT');
          --Dbms_Output.put_line(VE_RPTAC);
          --SP_VALIDAR_REPROGRAMACIONES_CRM(ve_instancia, ve_respuesta);
          IF trim(ve_rptac) = 'N' AND VE_RPTA_DESACTIVA_REG <> 'S' AND
             vo_excepcion <> 'S' THEN
            IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
               LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
              ve_mensaje := ve_mensaje ||
                            ';RSC: No se ingresaron los comentarios en la Propuesta, ingresarlos';
            else
              ve_mensaje := 'RSC: No se ingresaron los comentarios en la Propuesta, ingresarlos';
            end if;
          
            --Dbms_Output.put_line(ve_mensaje);
            --RETURN;  --DESCOMENTAR 19092021
            --VE_MENSAJE:= '';
          
          ELSE
            NULL;
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        --BLOQUEO CREDINKA
        BEGIN
          BEGIN
            PQ_CR_VALIDAR_RNG_REPROG.SP_BLOQUEO_CREDINKA(VE_INSTANCIA,
                                                         '',
                                                         VE_RPTAC,
                                                         VO_CODERROR,
                                                         VO_MSGERROR);
          EXCEPTION
            WHEN OTHERS THEN
              VE_RPTAC    := '';
              VO_CODERROR := '';
              VO_MSGERROR := '';
          END;
          --
          BEGIN
            PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VI_NRO,
                                                              VE_INSTANCIA,
                                                              'BLQ_CRDINKA',
                                                              (VE_RPTAC || '-' ||
                                                              VO_MSGERROR),
                                                              91,
                                                              VIO_RPTA_DESACTIVA_REG,
                                                              VIO_EXCEPCION);
          EXCEPTION
            WHEN OTHERS THEN
              VIO_RPTA_DESACTIVA_REG := 'N';
              VIO_EXCEPCION          := 'N';
          END;
          -----VALIDAR MENSAJE SI SALTA POLITICA
          IF VE_RPTAC = 'N' or VIO_RPTA_DESACTIVA_REG = 'S' or
             VIO_EXCEPCION = 'S' THEN
            --VE_MENSAJE:= 'ASDJLHSAKDLJHAS';
            NULL;
          ELSE
            IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
               LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
              VE_MENSAJE := VE_MENSAJE || ';' ||
                            'RSC:No esta permitido la reprogramación de Credinka, por este canal';
            ELSE
              ve_mensaje := 'RSC:No esta permitido la reprogramación de Credinka, por este canal;';
            END IF;
            RETURN;
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        -- OPINION DE RIESGOS LISTA NEGRA NO SE PUEDE REPROGRAMAR
        BEGIN
          PQ_CR_VALIDAR_RNG_REPROG.SP_VALIDAR_OPINION_RSG(ve_instancia,
                                                          VI_NRO,
                                                          VI_MENSAJE,
                                                          VO_CODERROR,
                                                          VO_MSGERROR);
          IF LENGTH(TRIM(VI_MENSAJE)) > 0 THEN
            IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
               LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
              VE_MENSAJE := VE_MENSAJE || ';' || VI_MENSAJE;
            ELSE
              VE_MENSAJE := VI_MENSAJE;
            END IF;
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        --OPINION DE RIESGOS MEMO CON SCORE
        --HASL@2025.04.04
        BEGIN
          BEGIN
            PQ_CR_CTROL_OPI_RIE_REPROG_REFIN.SP_CNTROL_REPROG(VE_INSTANCIA,
                                                              '',
                                                              VE_RPTAC,
                                                              VO_CODERROR,
                                                              VO_MSGERROR);
          EXCEPTION
            WHEN OTHERS THEN
              VE_RPTAC    := '';
              VO_CODERROR := '';
              VO_MSGERROR := '';
          END;
          --
          BEGIN
            PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VI_NRO,
                                                              VE_INSTANCIA,
                                                              'OPI_RSGO_M2025',
                                                              (VE_RPTAC || '-' ||
                                                              VO_MSGERROR),
                                                              91,
                                                              VIO_RPTA_DESACTIVA_REG,
                                                              VIO_EXCEPCION);
          EXCEPTION
            WHEN OTHERS THEN
              VIO_RPTA_DESACTIVA_REG := 'N';
              VIO_EXCEPCION          := 'N';
          END;
          -----VALIDAR MENSAJE SI SALTA POLITICA
          IF VE_RPTAC = 'N' or VIO_RPTA_DESACTIVA_REG = 'S' or
             VIO_EXCEPCION = 'S' THEN
            --VE_MENSAJE:= 'ASDJLHSAKDLJHAS';
            NULL;
          ELSE
            IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
               LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
              VE_MENSAJE := VE_MENSAJE || ';' ||
                            'RSC: Requiere opinion de riesgos - ' ||
                            VO_MSGERROR;
            ELSE
              ve_mensaje := 'RSC: Requiere opinion de riesgos - ' ||
                            VO_MSGERROR;
            END IF;
            RETURN;
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        IF VI_REGLA = 93 THEN
          PQ_CR_VALIDAR_RNG_REPROG.SP_VALIDAR_RPDNATURAL_SINCRM(ve_instancia,
                                                                VI_NRO,
                                                                VE_MENSAJE,
                                                                VO_CODERROR,
                                                                VO_MSGERROR);
        END IF;
        IF VI_REGLA = 94 THEN
          PQ_CR_VALIDAR_RNG_RPSC.SP_VALIDAR_RNG_GENERAL(ve_instancia,
                                                        VI_NRO,
                                                        10,
                                                        VI_USUARIO,
                                                        VE_MENSAJE);
        END IF;
        IF VI_REGLA = 95 THEN
        
          PQ_CR_VALIDAR_RNG_RPSC.SP_VALIDAR_RNG_GENERAL(ve_instancia,
                                                        VI_NRO,
                                                        11,
                                                        VI_USUARIO,
                                                        VE_MENSAJE);
          /*
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
            ve_mensaje := ve_mensaje ||
                          ';RSC: Tipo de Reprogramacion no habilitada';
          else
            ve_mensaje := ';RSC: Tipo de Reprogramacion no habilitada';
          end if;
          */
        END IF;
        BEGIN
          pq_cr_validar_rng_reprog.SP_CR_RATIOS_REPROGRAMADOS(ve_instancia,
                                                              VI_USUARIO,
                                                              VE_RPTAC,
                                                              VO_CODERROR,
                                                              VO_MSGERROR);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        BEGIN
          PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VI_NRO,
                                                            VE_INSTANCIA,
                                                            'RATIOS_RPG',
                                                            (VE_RPTAC || '-' ||
                                                            VO_MSGERROR),
                                                            91,
                                                            VIO_RPTA_DESACTIVA_REG,
                                                            VIO_EXCEPCION);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        --MCHIGS
        -----VALIDAR MENSAJE SI SALTA POLITICA
        IF VE_RPTAC = 'N' or VIO_RPTA_DESACTIVA_REG = 'S' or
           VIO_EXCEPCION = 'S' THEN
          --VE_MENSAJE:= 'ASDJLHSAKDLJHAS';
          NULL;
        ELSE
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'RSC:Ratio capacidad de pago mayor al establecido.';
          ELSE
            ve_mensaje := 'RSC:Ratio capacidad de pago mayor al establecido.';
          END IF;
        END IF;
      
      END IF; --FIN CONDICION GENERAL
    
      if length(vi_mensaje_caja) > 0 and vi_mensaje_caja is not null then
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' || vi_mensaje_caja;
        ELSE
          ve_mensaje := vi_mensaje_caja;
        END IF;
      end if;
      if length(vi_mensaje) > 0 and vi_mensaje is not null then
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
        
          VE_MENSAJE := VE_MENSAJE || ';' || vi_mensaje;
        ELSE
          ve_mensaje := vi_mensaje;
        END IF;
      end if;
    ELSE
      ve_mensaje := vi_mensaje_crm;
    END IF;
    --EXCEPCION
    IF LENGTH(ve_mensaje) > 0 THEN
      VI_EXCEPCION := 0;
      BEGIN
        SELECT F.TP1NRO1
          INTO VI_EXCEPCION
          FROM FST198 F
         WHERE F.TP1COD = 1
           AND F.TP1COD1 = 10899
           AND F.TP1CORR1 = 400000
           AND F.TP1CORR2 = 20
           AND F.TP1NRO1 = VE_INSTANCIA;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      IF VI_EXCEPCION > 0 THEN
        ve_mensaje := '';
        PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                   'CONTROL EXCEPTUADO', --variable
                                                   'S', --valor
                                                   91, --regla
                                                   ve_instancia --instancia
                                                   );
      END IF;
    END IF;
  end;
  PROCEDURE SP_GRABAR_LOG_RNG(VE_NRO       NUMBER, --CORRELATIVO
                              ve_variable  varchar, --VARIABLE
                              ve_valor     varchar, --VALOR
                              ve_regla     number, --REGLA
                              ve_instancia number --INSTANCIA
                              ) IS
    VI_NRO   NUMBER(10);
    VI_FECHA DATE;
    VI_HORA  CHAR(8);
  BEGIN
    --INSERTAR LOG DE VARIABLE
    BEGIN
      SELECT TRUNC(SYSDATE), TO_CHAR(SYSDATE, 'HH24:MI:SS')
        INTO VI_FECHA, VI_HORA
        FROM DUAL;
    Exception
      when others then
        null;
    END;
    BEGIN
      INSERT INTO AQPB582
        (AQPB582NRO,
         AQPB582VAR,
         AQPB582VAL,
         AQPB582REGL,
         AQPB582INST,
         AQPB582FEC,
         AQPB582HOR)
      VALUES
        (VE_NRO,
         VE_VARIABLE,
         VE_VALOR,
         VE_REGLA,
         VE_INSTANCIA,
         VI_FECHA,
         VI_HORA);
      COMMIT;
    END;
  END;

  PROCEDURE SP_VALIDAR_REPROGRAMACIONES_CRM(instancia in number,
                                            respuesta out varchar2) IS
  
    cantidad_total     NUMBER := 0;
    cantidad_LEY31050  NUMBER := 0;
    cantidad_vreprog   NUMBER := 0;
    cantidad_fondos    NUMBER := 0;
    var_suboperacion   NUMBER;
    var_tipo_operacion NUMBER;
    cuenta_operacion   varchar2(50);
    var_empresa        NUMBER;
    var_sucursal       number;
    var_modulo         number;
    var_moneda         number;
    var_papel          number;
  BEGIN
    respuesta := 'N';
    Begin
      SELECT xwfcuenta || '-' || xwfoperacion,
             xwfsubope,
             xwftipope,
             xwfempresa,
             xwfsucursal,
             xwfmodulo,
             xwfmoneda,
             xwfpapel
        INTO cuenta_operacion,
             var_suboperacion,
             var_tipo_operacion,
             var_empresa,
             var_sucursal,
             var_modulo,
             var_moneda,
             var_papel
        from xwf700
       where xwfprcins = instancia
         and xwfcar3 = '1';
    exception
      when others then
        null;
    End;
  
    BEGIN
      SELECT count(*)
        into cantidad_vreprog --Reprogramacion Covid
        from v_reprog
       WHERE estadosolicitud = 'BT'
         and cuentaoperacion = cuenta_operacion;
    EXCEPTION
      WHEN OTHERS THEN
        cantidad_vreprog := 0;
    END;
  
    BEGIN
      SELECT COUNT(*)
        INTO cantidad_LEY31050 --Reprogramacion Caja Gobierno
        from LEY31050_CREDITOSFACILIDAD F
       inner join LEY31050 l
          on l.idley31050 = F.idley31050
       where f.cuentaoperacion = cuenta_operacion
         and estadosolicitud = 'BT'
         and suboperacion = var_suboperacion
         and tipooperacion = var_tipo_operacion;
    EXCEPTION
      WHEN OTHERS THEN
        cantidad_LEY31050 := 0;
    END;
  
    BEGIN
      SELECT count(*)
        INTO cantidad_fondos --Reprogramacion Fondos
        from fondos_creditosfacilidad c
       inner join fondos f
          on c.idfondo = f.idfondo
         and estadosolicitud = 'BT'
         and cuentaoperacion = cuenta_operacion
         and empresa = var_empresa
         and sucursal = var_sucursal
         and modulo = var_modulo
         and moneda = var_moneda
         and papel = var_papel;
    EXCEPTION
      WHEN OTHERS THEN
        cantidad_fondos := 0;
    END;
  
    cantidad_total := cantidad_LEY31050 + cantidad_vreprog +
                      cantidad_fondos; --Totales
    IF (cantidad_total > 1) THEN
      respuesta := 'S';
    ELSE
      respuesta := 'N';
    END IF;
  
  END;

  PROCEDURE SP_CR_VTASA(ve_instancia number, --INSTANCIA
                        ve_vtasa     out varchar) IS
    VI_CONTROL  VARCHAR(1);
    VI_CONTADOR NUMBER;
  
    VI_PGCOD XWF700.XWFEMPRESA%TYPE;
    VI_SUC   XWF700.XWFSUCURSAL%TYPE;
    VI_MOD   XWF700.XWFMODULO%TYPE;
    VI_MDA   XWF700.XWFMONEDA%TYPE;
    VI_PAP   XWF700.XWFPAPEL%TYPE;
    VI_CTA   XWF700.XWFCUENTA%TYPE;
    VI_OPE   XWF700.XWFOPERACION%TYPE;
    VI_SBO   XWF700.XWFSUBOPE%TYPE;
    VI_TOP   XWF700.XWFTIPOPE%TYPE;
  
    VI_FVALOR DATE;
    VI_FPAGO  DATE;
    VI_NTASA  NUMBER(10, 6);
    VI_VVTASA VARCHAR(1); --NUMBER (10,6); --07/10/2021 CAMBIO DE TIPO DE DATO.
  BEGIN
    --ELIMINAR CONTROL
    VI_CONTROL := 'N';
    ve_vtasa   := 'S';
    BEGIN
      SELECT TRIM(TP1DESC)
        INTO VI_CONTROL
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 10899
         AND TP1CORR1 = 400000
         AND TP1CORR2 = 21
         AND TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    -----OBTENER CLAVE DEL CREDITO
    BEGIN
      SELECT XWFEMPRESA,
             XWFSUCURSAL,
             XWFMODULO,
             XWFMONEDA,
             XWFPAPEL,
             XWFCUENTA,
             XWFOPERACION,
             XWFSUBOPE,
             XWFTIPOPE
        INTO VI_PGCOD,
             VI_SUC,
             VI_MOD,
             VI_MDA,
             VI_PAP,
             VI_CTA,
             VI_OPE,
             VI_SBO,
             VI_TOP
        FROM XWF700 X
       WHERE X.XWFPRCINS = ve_instancia
         AND X.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    IF VI_CONTROL = 'S' THEN
      --OBTENER FECHA DE ULITMO PAGO DE CRONOGRAMA
      VI_FPAGO := NULL;
      BEGIN
        SELECT MAX(D.PPFPAG)
          INTO VI_FPAGO
          FROM FSD602 D
         WHERE D.PGCOD = VI_PGCOD
           AND D.PPMOD = VI_SUC
           AND D.PPSUC = VI_MOD
           AND D.PPMDA = VI_MDA
           AND D.PPPAP = VI_PAP
           AND D.PPCTA = VI_CTA
           AND D.PPOPER = VI_OPE
           AND D.PPSBOP = VI_SBO
           AND D.PPTOPE = VI_TOP
           AND D.PP1STAT = 'T';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          VI_FPAGO := TO_DATE('01/01/1990', 'DD/MM/YYYY');
        WHEN OTHERS THEN
          VI_FPAGO := TO_DATE('01/01/1990', 'DD/MM/YYYY');
      END;
    
      VI_FVALOR := NULL;
      BEGIN
        SELECT MIN(PPFVAL)
          INTO VI_FVALOR
          FROM FSD601 D
         WHERE D.PGCOD = VI_PGCOD
           AND D.PPMOD = VI_SUC
           AND D.PPSUC = VI_MOD
           AND D.PPMDA = VI_MDA
           AND D.PPPAP = VI_PAP
           AND D.PPCTA = VI_CTA
           AND D.PPOPER = VI_OPE
           AND D.PPSBOP = VI_SBO
           AND D.PPTOPE = VI_TOP
           AND D.PPFPAG > VI_FPAGO;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      --VALIDAR FSD012 NO HAYA TASA POSTERIOR
      IF VI_FVALOR IS NOT NULL THEN
        VI_NTASA  := 0;
        VI_VVTASA := 'N';
        BEGIN
          SELECT A.EVTASA, 'S'
            INTO VI_NTASA, VI_VVTASA
            FROM FSD012 A
           WHERE A.PGCOD = VI_PGCOD
             AND A.AOMOD = VI_SUC
             AND A.AOSUC = VI_MOD
             AND A.AOMDA = VI_MDA
             AND A.AOPAP = VI_PAP
             AND A.AOCTA = VI_CTA
             AND A.AOOPER = VI_OPE
             AND A.AOSBOP = VI_SBO
             AND A.AOTOPE = VI_TOP
             AND A.EVTIPO = 3
             AND A.EVFVAL >= VI_FVALOR;
        exception
          WHEN NO_DATA_FOUND THEN
            VI_NTASA  := 0;
            VI_VVTASA := 'N';
          WHEN OTHERS THEN
            NULL;
        END;
        IF VI_VVTASA = 'S' AND VI_NTASA <> 0 THEN
          ve_vtasa := 'N'; --CONTROLAMOS
        END IF;
      
        ve_vtasa := 'S'; --NO CONTROLAMOS
      END IF;
    END IF;
  END;

  PROCEDURE sp_validar_reglas_general(ve_instancia in number, --INSTANCIA
                                      VI_NRO       in number, --CORRELATIVO
                                      ve_vfondo    in varchar, --SI ES FONDOS
                                      ve_excepcion in varchar, -- ACTIVAR CASRGAR REGLA
                                      ve_user      in varchar,
                                      ve_mensaje   out varchar2 --MENSAJE DEVUELTO
                                      ) is
    vi_requiereopinion    varchar(3);
    vi_requiereopinion2   varchar(3);
    vi_tieneOpinion       number(3);
    vi_TipoOpinion        varchar(3);
    vi_mensaje            varchar(250);
    ve_rptac              varchar(150);
    ve_rptar              varchar(150);
    vi_tipo_reprog        varchar(1);
    VI_DIAS               number(6, 2); --05.05.2022 - aumento el tamaño
    VE_RPTA_DESACTIVA_REG VARCHAR(1);
  
    vi_mod            number(3);
    vi_suc            number(4);
    vi_mda            number(4);
    vi_pap            number(4);
    vi_cta            number(9);
    vi_ope            number(9);
    vi_sbo            number(3);
    vi_top            number(3);
    vi_plazo_preseteo number(5);
    vi_plazo_609      number(5);
    vo_excepcion      varchar(1);
    VE_MSG            varchar(150);
    ln_rango          number(9);
    ln_monto_tope     number(17, 2);
    ln_sucursal       number(4);
    --ve_mensaje varchar2(5000);
    ln_reprog              number(4);
    ln_cargo               number(4);
    ln_aproba              varchar(100);
    vi_requiere_opinion_bi varchar(30);
    ln_indicador29         number(4);
    ln_cta29               number(9);
    ln_ope29               number(9);
    --VARIABLES PARA EL MEMO17-2024
    vo_gracia   number(9);
    vo_monto    number(17, 2);
    vo_plazo_re number(9);
    CODMSG      varchar(300);
    DESMSG      varchar(300);
    VI_NRO_RPG  NUMBER(9);
    vo_datraaso number(9);
    vi_mensaje1 varchar(150);
  BEGIN
    pq_cr_funciones_cho.sp_indicador_CRM_Caja(ve_instancia, VE_RPTAC);
    vi_tipo_reprog := VE_RPTAC;
    --VALIDAR OPINION DE RIESGOS
    --REGLA DE CONTROL DE OPINION PARA EVALUAR
    IF VE_VFONDO <> 'S' THEN
      BEGIN
        --VALIDAMOS NRO DE REPROGRAMADOS
        PQ_CR_VALIDAR_RNG_REPROG.SP_VALIDAR_NRO_REPROG(VE_INSTANCIA,
                                                       vi_requiereopinion2);
        --VALIDAR SI ESTA EXCEPTUADO
        PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VI_NRO,
                                                          
                                                          VE_INSTANCIA,
                                                          'NRO_RPROG',
                                                          vi_requiereopinion2,
                                                          91,
                                                          VE_RPTA_DESACTIVA_REG,
                                                          vo_excepcion);
      END;
      begin
        -- MONTO DE OPINION
        pq_cr_reprogramaopinion.sp_validamontoopinion(ve_instancia,
                                                      vi_requiereopinion);
        pq_cr_reprogramaexo.sp_validaopinion(ve_instancia,
                                             vi_tieneOpinion,
                                             vi_TipoOpinion,
                                             vi_mensaje);
      exception
        when others then
          null;
      end;
      --apachecoh 2023.09.27
      begin
        -- EN LISTA DE BI
        pq_cr_validar_rng_reprog.SP_VALIDAR_LISTA_BI(ve_instancia,
                                                     ln_reprog,
                                                     ln_cargo,
                                                     ln_aproba,
                                                     vi_requiere_opinion_bi);
        PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VI_NRO,
                                                          VE_INSTANCIA,
                                                          'REQ_OPINION_RIESGOS_BI',
                                                          vi_requiere_opinion_bi,
                                                          91,
                                                          VE_RPTA_DESACTIVA_REG,
                                                          vo_excepcion);
      exception
        when others then
          null;
      end;
      if (vi_tieneOpinion = 1 or vi_requiere_opinion_bi = 'SI') and
         vi_TipoOpinion = 'V' THEN
        --&TipoOpinion si es V es viable y si es N es no viable  
        --&TieneOpinion = 0 no tiene opinion y si es 1 si tiene opinion
        VE_RPTAC := 'S'; --requiere y fue gestionado por riesgos como viable
      else
        VE_RPTAC := 'N'; --no requiere o no fue gestionado
      end if;
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'REQUIERE_OPINION_RIESGOS', --variable
                                                 vi_requiereopinion, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'TIENE_OPINION_RIESGOS', --variable
                                                 VE_RPTAC, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'REQ_OPINION_RIESGOS_2', --variable
                                                 vi_requiereopinion2, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'REQ_OPINION_RIESGOS_BI', --variable
                                                 vi_requiere_opinion_bi, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
      --VE_MENSAJE:= '';
      --IF VE_RPTAC <> 'N' THEN
      IF VE_RPTAC = 'S' or VE_RPTA_DESACTIVA_REG = 'S' or
         vo_excepcion = 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        if vi_requiere_opinion_bi is null then
          ---2023.09.29 dcastro
          begin
            select x.xwfcuenta, x.xwfoperacion
              into ln_cta29, ln_ope29
              from xwf700 x
             where x.xwfprcins = ve_instancia
               and x.xwfcar3 = '1'
               and rownum = 1;
          exception
            when others then
              ln_cta29 := null;
          end;
        
          if ln_cta29 is not null then
            begin
              select count(*)
                into ln_indicador29
                FROM /*USRWEBCRM.*/ REPROG L
               WHERE L.ESTADOSOLICITUD = 'BT'
                 and TIPOREPROGRAMACION = '29SEP'
                 AND SUBSTR(L.CUENTAOPERACION,
                            0,
                            INSTR(L.CUENTAOPERACION, '-') - 1) = ln_cta29
                 AND SUBSTR(L.CUENTAOPERACION,
                            INSTR(L.CUENTAOPERACION, '-') + 1,
                            99) = ln_ope29;
            exception
              when others then
                ln_indicador29 := 0;
            end;
          end if;
          --2023.09.29 dcastro
          if vi_requiereopinion = 'S' and ve_rptac = 'N' and
             ln_indicador29 = 0 then
            --2023.09.29
            begin
              SELECT xwfsucursal
                into ln_sucursal
                from xwf700
               where XWFPRCINS = ve_instancia
                 and xwfcar3 = '1';
            exception
              when others then
                null;
            end;
            --busco el rating de la sucursal de la agencia
            begin
              select tpimp
                into ln_rango
                from fst098
               where pgcod = 1
                 and tpcod = 7698
                 and tpnro = ln_sucursal
                 and rownum = 1;
            exception
              when others then
                ln_rango := 1;
            end;
          
            ---según el rango busco el monto
            begin
              select tp1imp1 - 1
                into ln_monto_tope
                from fst198
               where Tp1cod = 1
                 and Tp1cod1 = 10899
                 and Tp1corr1 = 400001
                 and Tp1corr2 = 1
                 and Tp1corr3 > 0
                 and tp1nro1 = ln_rango;
            exception
              when others then
                ln_monto_tope := 0;
            end;
          
            IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
               LENGTH(TRIM(VE_MENSAJE)) < 200 THEN
              VE_MENSAJE := VE_MENSAJE || ';' ||
                            'RSC:Requiere Opinión de Riesgos, Saldo Consolidado mayor a S/' ||
                            ln_monto_tope ||
                            '. Rating de Agencia, segun MEMO'; --SE ELIMINO MEMO372
            ELSE
              VE_MENSAJE := 'RSC:Requiere Opinión de Riesgos, Saldo Consolidado mayor a S/' ||
                            ln_monto_tope ||
                            '. Rating de Agencia, segun MEMO'; --SE ELIMINO MEMO372
            END IF;
          ELSE
            ve_mensaje := '';
          end if;
        
          if vi_requiereopinion2 = 'S' and ve_rptac = 'N' and
             ln_indicador29 = 0 then
            --2023.09.29
            IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
               LENGTH(TRIM(VE_MENSAJE)) < 200 THEN
              VE_MENSAJE := VE_MENSAJE || ';' ||
                            'RSC:Requiere opinión de Riesgos, El crédito a reprogramar supera el limite de reprogramaciones segun MEMO372';
            ELSE
              VE_MENSAJE := 'RSC:Requiere opinión de Riesgos, El crédito a reprogramar supera el limite de reprogramaciones segun MEMO372';
            END IF;
            --RETURN ;
          END IF;
        
        else
          --apachecoh 2023.09.28
          if vi_requiere_opinion_bi = 'SI' and ve_rptac = 'N' then
            IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
               LENGTH(TRIM(VE_MENSAJE)) < 200 THEN
              VE_MENSAJE := VE_MENSAJE || ';' ||
                            'RSC:Requiere opinión de Riesgos, El crédito a reprogramar supera el limite de reprogramaciones segun MEMO428';
            ELSE
              VE_MENSAJE := 'RSC:Requiere opinión de Riesgos, El crédito a reprogramar supera el limite de reprogramaciones segun MEMO428';
            END IF;
          else
            ve_mensaje := '';
          end if;
        end if;
      END IF;
      ------------------------------------------------
      ------------------------------------------------
      --VALIDAR NRO DE REPROGRAMACIONES
      /*
      BEGIN
        PQ_CR_VALIDAR_RNG_REPROG.SP_VALIDAR_NRO_REPROG(
                                                        VE_INSTANCIA,
                                                        VE_RPTAC
                                                      );
                                                                                                           
        --VALIDAR SI ESTA EXCEPTUADO
        PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(
                                                           VI_NRO,
                                                           VE_INSTANCIA,
                                                           'NRO_RPROG',
                                                           VE_RPTAC,
                                                           91,
                                                           VE_RPTA_DESACTIVA_REG,
                                                           vo_excepcion 
                                                         );                                                                 
        IF trim(ve_rptac) = 'N'  AND
           VE_RPTA_DESACTIVA_REG <> 'S' AND vo_excepcion <> 'S' THEN
            IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
               LENGTH(TRIM(VE_MENSAJE)) < 200 THEN
              VE_MENSAJE := VE_MENSAJE || ';' ||
                            'RSC:Requiere opinión de Riesgos, El crédito a reprogramar supera el limite de reprogramaciones segun MEMO372';
            ELSE
              VE_MENSAJE := 'RSC:Requiere opinión de Riesgos, El crédito a reprogramar supera el limite de reprogramaciones segun MEMO372';
            END IF;        
        ELSE
          NULL;
        END IF;
                                                                                                            
      END;
      */
      begin
        VE_RPTAC := '';
        PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_DIF_FECVENC(ve_instancia,
                                                        VI_DIAS);
        sp_activas_unilateral(ve_instancia, VI_DIAS, VE_RPTAC, VE_MSG); --2022.12.25
        IF ve_excepcion = 'N' then
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                     'V_UNILATERAL', --variable
                                                     VE_RPTAC, --valor
                                                     91, --regla
                                                     ve_instancia --instancia
                                                     );
        END IF;
        Dbms_Output.put_line('V_UNILATERAL');
        Dbms_Output.put_line(VE_RPTAC);
      
        PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                     VE_INSTANCIA,
                                                     'V_UNILATERAL',
                                                     VE_RPTA_DESACTIVA_REG);
        PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                            VE_INSTANCIA,
                                                            'V_UNILATERAL',
                                                            vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
      
        IF trim(ve_rptac) = 'N' AND vi_tipo_reprog = 'V' AND
           VE_RPTA_DESACTIVA_REG <> 'S' AND vo_excepcion <> 'S' THEN
          --RETURN;  --DESCOMENTAR 19092021
          --VE_MENSAJE:= '';
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 200 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'RSC: El crédito a reprogramar no cumple con las condiciones de la normativa SBS-' ||
                          VE_MSG;
          ELSE
            VE_MENSAJE := 'RSC: El crédito a reprogramar no cumple con las condiciones de la normativa SBS-' ||
                          VE_MSG;
          END IF;
        ELSE
          NULL;
        END IF;
      
        --CANTIDAD DE CUOTAS ES OTRO CONTROL
        --SI ES UN CLIENTE QUE TIENE UN SALDO DE 5000, AL GERENTE REGIONAL
      end;
    END IF;
    --MEMO 17-2024 - HSUAREZ 2024.01.18
    BEGIN
      ---VALIDAR SI ES REPROGRAMADOS DE LA TABLA REPROG COVID
      if vi_tipo_reprog = 'V' or vi_tipo_reprog = 'M' or
         vi_tipo_reprog = 'N' then
        -- MEMO 17-2024 HSUAREZ 2024.01.18
        ----VALIDAR GRACIA
        pq_cr_controles_memo24.sp_cr_control_periodio_gracia(VE_INSTANCIA,
                                                             vo_gracia,
                                                             vo_monto,
                                                             ve_rptac);
        ------VALIDAR SI ESTA EXCEPTUADO
        PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VI_NRO,
                                                          VE_INSTANCIA,
                                                          'GRACIA_M17',
                                                          (ve_rptac || '-' ||
                                                          vo_gracia),
                                                          91,
                                                          VE_RPTA_DESACTIVA_REG,
                                                          vo_excepcion);
        ------VALIDAR MENSAJE SI SALTA POLITICA
        IF VE_RPTAC = 'S' or VE_RPTA_DESACTIVA_REG = 'S' or
           vo_excepcion = 'S' THEN
          --VE_MENSAJE:= '';
          NULL;
        ELSE
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'RSC:Gracia mayor a la permitida.';
          ELSE
            ve_mensaje := 'RSC:Gracia mayor a la permitida.';
          END IF;
        END IF;
        ----VALIDAR PLAZO RESIDUAL
        pq_cr_controles_memo24.sp_cr_plazo_residual(ve_instancia,
                                                    vo_plazo_re,
                                                    ve_rptac);
        ------VALIDAR SI ESTA EXCEPTUADO
        PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VI_NRO,
                                                          VE_INSTANCIA,
                                                          'PZORES_M17',
                                                          (ve_rptac || '-' ||
                                                          vo_plazo_re),
                                                          91,
                                                          VE_RPTA_DESACTIVA_REG,
                                                          vo_excepcion);
        ------VALIDAR MENSAJE SI SALTA POLITICA
        IF VE_RPTAC = 'S' or VE_RPTA_DESACTIVA_REG = 'S' or
           vo_excepcion = 'S' THEN
          --VE_MENSAJE:= '';
          NULL;
        ELSE
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'RSC:Plazo residual mayor a la permitida.';
          ELSE
            ve_mensaje := 'RSC:Plazo residual mayor a la permitida.';
          END IF;
        END IF;
        ----VALIDAR DIAS DE ATRASO
        PQ_CR_VALIDAR_RNG_REPROG.SP_CR_VALIDA_REPROGRAMADO_DIAS_ATRASO(VE_INSTANCIA,
                                                                       ve_rptac,
                                                                       CODMSG,
                                                                       DESMSG);
        ------VALIDAR SI ESTA EXCEPTUADO
        BEGIN
          PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VI_NRO,
                                                            VE_INSTANCIA,
                                                            'ATRASO_M17',
                                                            (ve_rptac || '-' ||
                                                            DESMSG),
                                                            91,
                                                            VE_RPTA_DESACTIVA_REG,
                                                            vo_excepcion);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        ------VALIDAR MENSAJE SI SALTA POLITICA
        IF VE_RPTAC = 'S' or VE_RPTA_DESACTIVA_REG = 'S' or
           vo_excepcion = 'S' THEN
          --VE_MENSAJE:= '';
          NULL;
        ELSE
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'RSC:Tiene mas de 30 dias de atraso.';
          ELSE
            ve_mensaje := 'RSC:Tiene mas de 30 dias de atraso.';
          END IF;
        END IF;
        ----VALIDAR OPINION DE RIESGOS
        ------VALIDAR QUE GRUPO ES SI ES DENTRO DE DIC2022 HASTA JUN2023
        BEGIN
          PQ_CR_VALIDAR_RNG_REPROG.SP_CR_VALIDA_FECHA_REPROGRAMADO(VE_INSTANCIA,
                                                                   ve_rptar, -- S ESTA DENTRO DEL GRUPO N FUERA DEL GRUPO
                                                                   CODMSG,
                                                                   DESMSG);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        ------GRABAR LOG DE GRUPO
        PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VI_NRO,
                                                          VE_INSTANCIA,
                                                          'GRUPO_M17',
                                                          (ve_rptar || '-' ||
                                                          DESMSG),
                                                          91,
                                                          VE_RPTA_DESACTIVA_REG,
                                                          vo_excepcion);
      
        ------DENTRO DEL GRUPO
        begin
          PQ_CR_VALIDAR_RNG_REPROG.SP_VALIDAR_NRO_REPROGN(VE_INSTANCIA,
                                                          VI_NRO_RPG);
          pq_cr_reprogramaopinion.sp_validamontoopinionCap(ve_instancia,
                                                           vi_requiereopinion);
          PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VI_NRO,
                                                            VE_INSTANCIA,
                                                            'REQ_OPINION_M17',
                                                            ('REQ_OPI - ' ||
                                                            vi_requiereopinion),
                                                            91,
                                                            VE_RPTA_DESACTIVA_REG,
                                                            vo_excepcion);
          PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VI_NRO,
                                                            VE_INSTANCIA,
                                                            'NRO_RPG_M17',
                                                            ('NRO_RPG - ' ||
                                                            VI_NRO_RPG),
                                                            91,
                                                            VE_RPTA_DESACTIVA_REG,
                                                            vo_excepcion);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        end;
        VE_RPTAC := 'S';
        IF ve_rptar = 'S' THEN
          --IF (VI_NRO_RPG > 4 AND VI_NRO_RPG < 9 AND vi_requiereopinion = 'S') OR VI_NRO_RPG > 8 THEN
          IF (VI_NRO_RPG > 4 AND VI_NRO_RPG < 8 AND
             vi_requiereopinion = 'S') OR VI_NRO_RPG > 8 THEN
            VE_RPTAC    := 'N';
            vi_mensaje1 := 'Monto mayor a S/ 50000 - entre Dic 2022 y Jun 2023';
          END IF;
          IF VI_NRO_RPG > 4 THEN
            vi_mensaje1 := 'Supera el limite máx. de reprogramaciones - entre Dic 2022 y Jun 2023';
          END IF;
        ELSE
          IF vi_requiereopinion = 'S' THEN
            VE_RPTAC    := 'N';
            vi_mensaje1 := 'Monto mayor a S/ 50000 - antes Dic 2022 - posteriores Jun 2023';
          END IF;
        END IF;
        ------VALIDAR SI ESTA EXCEPTUADO
        VE_RPTA_DESACTIVA_REG := 'N';
        vo_excepcion          := 'N';
        PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VI_NRO,
                                                          VE_INSTANCIA,
                                                          'REQ_OPINION_M17',
                                                          ve_rptac,
                                                          91,
                                                          VE_RPTA_DESACTIVA_REG,
                                                          vo_excepcion);
        ------VALIDAR SI INGRESARON OPINION      
        pq_cr_reprogramaexo.sp_validaopinion(ve_instancia,
                                             vi_tieneOpinion,
                                             vi_TipoOpinion,
                                             vi_mensaje);
        ------VALIDAR MENSAJE SI SALTA POLITICA
        IF VE_RPTAC = 'S' or VE_RPTA_DESACTIVA_REG = 'S' or
           vo_excepcion = 'S' or
           (vi_tieneOpinion = 1 and vi_TipoOpinion = 'V') THEN
          --VE_MENSAJE:= '';
          NULL;
        ELSE
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'RSC:Requiere Opinion de Riesgos' || '-' ||
                          vi_mensaje1;
          ELSE
            ve_mensaje := 'RSC:Requiere Opinion de Riesgos' || '-' ||
                          vi_mensaje1;
          END IF;
        END IF;
      end if;
      if vi_tipo_reprog = 'N' then
        --validar RCC
        null;
      end if;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;

  PROCEDURE SP_VALIDAR_REGLAS_GOBIERNO(ve_instancia in number,
                                       vi_nro       in number,
                                       ve_mensaje   out varchar) IS
    VE_RPTAC              varchar(15);
    VE_RPTA_EXCEP         VARCHAR(1);
    VE_RPTA_DESACTIVA_REG VARCHAR(1);
    ve_rptan              number(17, 6);
  BEGIN
    NULL;
  END;

  PROCEDURE SP_VALIDAR_REGLAS_CAJA(ve_instancia in number,
                                   vi_nro       in number,
                                   ve_mensaje   out varchar) IS
    VE_RPTAC              varchar(15);
    VE_RPTA_EXCEP         VARCHAR(1);
    VE_RPTA_DESACTIVA_REG VARCHAR(1);
    ve_rptan              number(17, 6);
  BEGIN
    -------------------------------------------------
    -- VALIDAR QUE SEA CAJA
    -------------------------------------------------
    VE_RPTAC   := '';
    VE_MENSAJE := '';
    begin
      ---VALIDAR REGLAS CAJA PARA AMORTIZACION ANTICIPADA.
      pq_cr_reprog_cancel_anticipada.sp_cr_valida_reprogramado(ve_instancia,
                                                               VE_RPTAC);
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'RCAJA_VALIDAR_CRM', --variable
                                                 VE_RPTAC, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
      IF ve_rptac = 'S' THEN
      
        ----------------------------------------------------------------------
        -- FECHA DE PRIMER PAGO
        ----------------------------------------------------------------------
        VE_RPTAC              := '';
        VE_RPTA_DESACTIVA_REG := '';
        PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                     ve_instancia,
                                                     'RCAJA_FECHA_PPAGO',
                                                     VE_RPTA_DESACTIVA_REG);
        pq_cr_reprog_cancel_anticipada.sp_cr_fchvenc_primcuota(ve_instancia,
                                                               VE_RPTAC);
        PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                   'RCAJA_FECHA_PPAGO', --variable
                                                   VE_RPTAC, --valor
                                                   91, --regla
                                                   ve_instancia --instancia
                                                   );
      
        IF ve_rptac <> 'N' or VE_RPTA_DESACTIVA_REG = 'S' THEN
          --VE_MENSAJE:= '';
          NULL;
        ELSE
          VE_MENSAJE := 'RSC:La fecha de primer pago debe ser al dia siguiente de la Reprogramación';
        END IF;
        VE_RPTA_DESACTIVA_REG := '';
        --
        -- VALIDAR NUMERO DE CUOTAS
        --
        VE_RPTAC := '';
        pq_cr_reprog_cancel_anticipada.sp_cr_valida_numero_cuotas(ve_instancia,
                                                                  VE_RPTAC);
        PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                   'RCAJA_NUMERO_CUOTAS', --variable
                                                   VE_RPTAC, --valor
                                                   91, --regla
                                                   ve_instancia --instancia
                                                   );
      
        IF ve_rptac <> 'N' THEN
          --VE_MENSAJE:= '';
          NULL;
        ELSE
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 200 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'Solo pueden generarse entre 2 a 4 cuotas, para reprogramacion caja, de la modalidad seleccionada';
          ELSE
            VE_MENSAJE := 'RSC:Solo pueden generarse entre 2 a 4 cuotas, para reprogramacion caja, de la modalidad seleccionada';
          END IF;
        END IF;
      
        --
        -- VALIDAR PRIMERA CUOTA NO MENOR AL 40%
        --
        VE_RPTAC := '';
        pq_cr_reprog_cancel_anticipada.sp_cr_porcentaje_primera_cuota(ve_instancia,
                                                                      VE_RPTAC);
        PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                   'RCAJA_PPRIM_CUOTA', --variable
                                                   VE_RPTAC, --valor
                                                   91, --regla
                                                   ve_instancia --instancia
                                                   );
        PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                            ve_instancia,
                                                            'EXCEP_REGLA_MAY_40_CAJA',
                                                            VE_RPTA_EXCEP);
        IF ve_rptac <> 'N' OR VE_RPTA_EXCEP <> 'N' THEN
          NULL;
        ELSE
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 200 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'La primera cuota no puede ser menor al 40% del Saldo Capital';
          ELSE
            VE_MENSAJE := 'RSC:La primera cuota no puede ser menor al 40% del Saldo Capital';
          END IF;
        END IF;
      
        --
        -- VALIDAR ULTIMA CUOTA DEBE SER IGUAL AL MONTO AUTORIZADO EN EL CRM
        --
        VE_RPTAC := '';
        pq_cr_reprog_cancel_anticipada.sp_cr_ultima_cuota_al_capital(ve_instancia,
                                                                     VE_RPTAC);
        PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                   'RCAJA_ULTM_CUOTA', --variable
                                                   VE_RPTAC, --valor
                                                   91, --regla
                                                   ve_instancia --instancia
                                                   );
        IF ve_rptac <> 'N' THEN
          NULL;
        ELSE
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 200 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'La ultima cuota generada debe ser igual al monto autorizado a descontar del CRM';
          ELSE
            VE_MENSAJE := 'RSC:La ultima cuota generada debe ser igual al monto autorizado a descontar del CRM';
          END IF;
        END IF;
        --
        -- VALIDAR ULTIMA CUOTA DEBE SER IGUAL AL MONTO AUTORIZADO EN EL CRM
        --
        VE_RPTAC := '';
        pq_cr_validar_rng_reprog.SP_OBTENER_PERIODO(ve_instancia, ve_rptan);
        PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                   'RCAJA_PERIODO', --variable
                                                   to_number(ve_rptan), --valor
                                                   91, --regla
                                                   ve_instancia --instancia
                                                   );
        IF ve_rptan = 60 THEN
          NULL;
        ELSE
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 200 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'Las cuotas deben ser bimestrales';
          ELSE
            IF VE_MENSAJE is NULL OR TRIM(VE_MENSAJE) = 'NULL' or
               trim(ve_mensaje) = '' THEN
              VE_MENSAJE := 'RSC:Las cuotas deben ser bimestrales';
            ELSE
              VE_MENSAJE := VE_MENSAJE; --'Las cuotas deben ser bimestrales';
            END IF;
          END IF;
        END IF;
      
      ELSE
        NULL;
      END IF;
    end;
  END;

  PROCEDURE SP_VALIDAR_REGLAS_CAJA_RT_EXO_AMO(ve_instancia in number,
                                              vi_nro       in number,
                                              ve_excepcion in varchar,
                                              ve_user      in varchar,
                                              ve_mensaje   out varchar) IS
    VE_RPTAC               varchar(15);
    VE_RPTA_EXCEP          VARCHAR(1);
    VI_PLAZO_CAJA          number(17, 2);
    VI_PLAZO_CAJA_PRP      number(17, 2);
    VI_TIPO_REPROGRAMACION varchar(10);
    VE_RPTA_DESACTIVA_REG  VARCHAR(1);
    VI_GRACIA              NUMBER(5, 2);
    VI_MONTO               number(17, 2);
    ve_rptan               number(17, 6);
    vo_excepcion           varchar(1);
  BEGIN
    --------------------------------------------------------------------------------------------------------
    -- REPROGRAMADOS CAJA - F. REDUCCION DE TASA
    --------------------------------------------------------------------------------------------------------
    --PLAZO MATRIZ CAJA--
    PQ_CR_RNG_REPROG_HS.sp_cr_plazo_matriz(ve_instancia, ve_rptan);
    VI_PLAZO_CAJA := ve_rptan + 0.99;
    PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                               'PLAZO_MATRIZ_CAJA', --variable
                                               to_char(VI_PLAZO_CAJA), --valor
                                               91, --regla
                                               ve_instancia --instancia
                                               );
    --PLAZO CAJA PROPUESTO
    --VI_PLAZO_CAJA := ve_rptan;--DIVIDO ENTRE 30
    ve_rptan := 0;
    pq_cr_funciones_cho.sp_plazo_caja(ve_instancia, ve_rptan);
    if ve_rptan > 0 then
      VI_PLAZO_CAJA_PRP := ve_rptan / 30;
    end if;
    IF ve_excepcion = 'N' THEN
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'PLAZO_PRPTO_CAJA', --variable
                                                 to_char(ve_rptan), --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
      -----------------
    END IF;
    --VALIDA SI ESTA EXCEPTUADO
    vo_excepcion := 'N';
    PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                        VE_INSTANCIA,
                                                        'PLAZO_CAJA',
                                                        vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
    IF VI_PLAZO_CAJA >= VI_PLAZO_CAJA_PRP or vo_excepcion = 'S' THEN
      NULL;
    ELSE
      IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 200 THEN
        VE_MENSAJE := VE_MENSAJE || ';' ||
                      'RSC: Plazo propuesto Caja, mayor al Permitido de acuerdo al cuadro';
      
      ELSE
        ve_mensaje := 'RSC: Plazo propuesto Caja, mayor al Permitido de acuerdo al cuadro';
      END IF;
      IF ve_excepcion = 'S' THEN
        --LISTA  AGREGAR EXCEPCION
        PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LISTA_EXCEPCION('PLAZO_CAJA',
                                                           ve_mensaje,
                                                           91,
                                                           ve_Instancia,
                                                           VE_USER);
      END IF;
    END IF;
    -- FIN PLAZO
    -------------------------------------------------
    -- VALIDAR GRACIA
    -------------------------------------------------
    PQ_CR_RNG_REPROG_HS.sp_cr_gracia_caj(ve_instancia, VI_GRACIA, VI_MONTO);
    PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                               'GRACIA_RPG_CAJA', --variable
                                               to_char(VI_GRACIA), --valor
                                               91, --regla
                                               ve_instancia --instancia
                                               );
    IF ve_excepcion = 'N' THEN
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'MONTO_RPG_CAJA', --variable
                                                 to_char(VI_MONTO), --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
    END IF;
    --VALIDA SI ESTA EXCEPTUADO
    vo_excepcion := 'N';
    PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                        VE_INSTANCIA,
                                                        'GRACIA_CAJA',
                                                        vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
    --CONTROL FUNCION
    IF (VI_MONTO <= 75000 AND VI_GRACIA > 60) AND vo_excepcion <> 'S' THEN
      VE_MENSAJE := 'RNG Caja: La Gracia es mayor a la permitida de acuerdo a la matriz-Caja';
      IF ve_excepcion = 'S' THEN
        --LISTA  AGREGAR EXCEPCION
        PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LISTA_EXCEPCION('GRACIA_CAJA',
                                                           ve_mensaje,
                                                           91,
                                                           ve_Instancia,
                                                           VE_USER);
      END IF;
    ELSE
      NULL;
    END IF;
    IF (VI_MONTO > 75000 AND VI_GRACIA > 90) AND vo_excepcion <> 'S' THEN
      VE_MENSAJE := 'RNG Caja: La Gracia es mayor a la permitida de acuerdo a la matriz-Caja';
    
      IF ve_excepcion = 'S' THEN
        --LISTA  AGREGAR EXCEPCION
        PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LISTA_EXCEPCION('GRACIA_CAJA',
                                                           ve_mensaje,
                                                           91,
                                                           ve_Instancia,
                                                           VE_USER);
      END IF;
    ELSE
      NULL;
    END IF;
    -------------------------------------------------
    -- VALIDAR GRADIENTE
    -------------------------------------------------
    BEGIN
      ve_rptac := '';
      PQ_CR_RNG_REPROG_HS.SP_CR_GRADIENTE_CAJ_SJ(ve_instancia, ve_rptac);
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'GRADIENTE_CAJA', --variable
                                                 ve_rptac, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
      IF ve_rptac = 'N' OR vo_excepcion <> 'S' THEN
        VE_MENSAJE := 'RNG Caja: Revisar la Grediente no cumple con lo indicado segun matriz-Caja';
      
        IF ve_excepcion = 'S' THEN
          /*
          --LISTA  AGREGAR EXCEPCION
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LISTA_EXCEPCION(
             'GRADIENTE_CAJA',ve_mensaje,91,ve_Instancia,VE_USER
          );
          */
          NULL;
        END IF;
      ELSE
        NULL;
      END IF;
    END;
  
    -- FIN REPROGRAMADOS CASA
    -----------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------
  
  END;
  PROCEDURE SP_VALIDAR_REGLAS_CAJA_SOLJ(ve_instancia   in number,
                                        vi_nro         in number,
                                        ve_excepcion   in varchar, --SE AGREGO PARAMETRO ADICIONAL 09.05.2022
                                        ve_user        in varchar, --SE AGREGO PARAMETRO ADICIONAL 09.05.2022
                                        ve_tipo_reprog in varchar,
                                        ve_mensaje     out varchar) IS
    VE_RPTAC               varchar(15);
    VE_RPTA_EXCEP          VARCHAR(1);
    VI_PLAZO_CAJA          number(17, 2);
    VI_PLAZO_CAJA_PRP      number(17, 2);
    VI_TIPO_REPROGRAMACION varchar(10);
    VE_RPTA_DESACTIVA_REG  VARCHAR(1);
    VI_GRACIA              NUMBER(5, 2);
    VI_MONTO               number(17, 2);
    ve_rptan               number(17, 6);
    vo_excepcion           varchar(1);
  
  BEGIN
    -------------------------------------------------
    -- VALIDAR QUE SEA CAJA REDUCCION DE TASA SOL. JUNTOS
    -------------------------------------------------
  
    VE_RPTAC   := '';
    VE_MENSAJE := '';
    BEGIN
      IF ve_tipo_reprog = 'J' THEN
      
        --VALIDAR SI SE AUTORIZO LA GESTION DEL CRÉDITO
        PQ_CR_FUNCIONES_CHO.SP_EXISTE_CRM_CAJA(VE_INSTANCIA, ve_rptac);
      
        IF ve_excepcion = 'N' THEN
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                     'VALIDAR_AUTOR_CAJA', --variable
                                                     ve_rptac, --valor
                                                     91, --regla
                                                     ve_instancia --instancia
                                                     );
        
        END IF;
        IF trim(ve_rptac) = 'Z' THEN
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'RSC:Reprogramación Caja, falta autorizar la Reprogramacion';
          ELSE
            ve_mensaje := 'RSC:Reprogramación Caja, falta autorizar la Reprogramacion';
          END IF;
        END IF;
      
        IF trim(ve_rptac) = 'D' THEN
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'RSC:Diferencia en datos CRM con datos en BT';
          ELSE
            ve_mensaje := 'RSC:Diferencia en datos CRM con datos en BT';
          END IF;
        END IF;
        IF trim(ve_rptac) = 'S' THEN
          NULL;
        END IF;
      
        -------------------------------------------------
        -- VALIDAR PLAZO
        -------------------------------------------------
        --PLAZO MATRIZ CAJA
        BEGIN
          PQ_CR_RNG_REPROG_HS.sp_cr_plazo_matriz_sj(ve_instancia, ve_rptan);
          VI_PLAZO_CAJA := ve_rptan + 0.99;
          IF ve_excepcion = 'N' THEN
            PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                       'PLAZO_MATRIZ_CAJA_SJ', --variable
                                                       to_char(VI_PLAZO_CAJA), --valor
                                                       91, --regla
                                                       ve_instancia --instancia
                                                       );
          END IF;
          --PLAZO CAJA PROPUESTO
          --VI_PLAZO_CAJA := ve_rptan;--DIVIDO ENTRE 30
          ve_rptan := 0;
          pq_cr_funciones_cho.sp_plazo_caja(ve_instancia, ve_rptan);
          if ve_rptan > 0 then
            VI_PLAZO_CAJA_PRP := ve_rptan / 30;
          end if;
          IF ve_excepcion = 'N' THEN
            PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                       'PLAZO_PRPTO_CAJA_SJ', --variable
                                                       to_char(ve_rptan), --valor
                                                       91, --regla
                                                       ve_instancia --instancia
                                                       );
          END IF;
          -----------------
          --VALIDA SI ESTA EXCEPTUADO
          vo_excepcion := 'N';
          PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                              VE_INSTANCIA,
                                                              'PLAZO_CAJA_SJ',
                                                              vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
        
          IF VI_PLAZO_CAJA >= VI_PLAZO_CAJA_PRP or vo_excepcion = 'S' THEN
            NULL;
          ELSE
            IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
               LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
              VE_MENSAJE := VE_MENSAJE || ';' ||
                            'RSC: Plazo propuesto Caja, mayor al Permitido de acuerdo al cuadro-Sol. Juntos';
            ELSE
              ve_mensaje := 'RSC: Plazo propuesto Caja, mayor al Permitido de acuerdo al cuadro-Sol. Juntos';
            END IF;
            IF ve_excepcion = 'S' THEN
              --LISTA  AGREGAR EXCEPCION
              PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LISTA_EXCEPCION('PLAZO_CAJA_SJ',
                                                                 'RSC: Plazo propuesto Caja, mayor al Permitido de acuerdo al cuadro-Sol. Juntos',
                                                                 91,
                                                                 ve_Instancia,
                                                                 VE_USER);
            END IF;
          END IF;
        END;
        -------------------------------------------------
        -- VALIDAR GRACIA
        -------------------------------------------------
        PQ_CR_RNG_REPROG_HS.sp_cr_gracia_caj(ve_instancia,
                                             VI_GRACIA,
                                             VI_MONTO);
        IF ve_excepcion = 'N' THEN
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                     'GRACIA_RPG_CAJA_SJ', --variable
                                                     to_char(VI_GRACIA), --valor
                                                     91, --regla
                                                     ve_instancia --instancia
                                                     );
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                     'MONTO_RPG_CAJA_SJ', --variable
                                                     to_char(VI_MONTO), --valor
                                                     91, --regla
                                                     ve_instancia --instancia
                                                     );
        END IF;
        --VALIDA SI ESTA EXCEPTUADO
        vo_excepcion := 'N';
        PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                            VE_INSTANCIA,
                                                            'GRACIA_CAJA_SJ',
                                                            vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
      
        --CONTROL FUNCION
        IF VI_MONTO <= 75000 AND VI_GRACIA > 60 and vo_excepcion <> 'S' THEN
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'RNG Caja: La Gracia es mayor a la permitida de acuerdo a la matriz-Sol.Juntos';
          ELSE
            VE_MENSAJE := 'RNG Caja: La Gracia es mayor a la permitida de acuerdo a la matriz-Sol.Juntos';
          END IF;
          IF ve_excepcion = 'S' THEN
            -- LISTA  AGREGAR EXCEPCION
            PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LISTA_EXCEPCION('GRACIA_CAJA_SJ',
                                                               'RNG Caja: La Gracia es mayor a la permitida de acuerdo a la matriz-Sol.Juntos',
                                                               91,
                                                               ve_Instancia,
                                                               VE_USER);
          END IF;
        ELSE
          NULL;
        END IF;
        IF VI_MONTO > 75000 AND VI_GRACIA > 90 and vo_excepcion <> 'S' THEN
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'RNG Caja: La Gracia es mayor a la permitida de acuerdo a la matriz-Sol.Juntos';
          ELSE
            VE_MENSAJE := 'RNG Caja: La Gracia es mayor a la permitida de acuerdo a la matriz-Sol.Juntos';
          END IF;
          IF ve_excepcion = 'S' THEN
            --LISTA  AGREGAR EXCEPCION
            PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LISTA_EXCEPCION('GRACIA_CAJA_SJ',
                                                               'RNG Caja: La Gracia es mayor a la permitida de acuerdo a la matriz-Sol.Juntos',
                                                               91,
                                                               ve_Instancia,
                                                               VE_USER);
          END IF;
        ELSE
          NULL;
        END IF;
        -------------------------------------------------
        -- VALIDAR GRADIENTE
        -------------------------------------------------
        BEGIN
          ve_rptac := '';
          PQ_CR_RNG_REPROG_HS.SP_CR_GRADIENTE_CAJ_SJ(ve_instancia,
                                                     ve_rptac);
          IF ve_excepcion = 'N' THEN
            PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                       'GRADI_RPG_CAJA', --variable
                                                       ve_rptac, --valor
                                                       91, --regla
                                                       ve_instancia --instancia
                                                       );
          END IF;
          --VALIDA SI ESTA EXCEPTUADO
          vo_excepcion := 'N';
          PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                              VE_INSTANCIA,
                                                              'GRADIENTE_CAJA_SJ',
                                                              vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
        
          IF ve_rptac = 'N' AND vo_excepcion <> 'S' THEN
            IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
               LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
              VE_MENSAJE := VE_MENSAJE || ';' ||
                            'RNG Caja: Revisar la Grediente no cumple con lo indicado segun matriz-Sol.Juntos';
            ELSE
              VE_MENSAJE := 'RNG Caja: Revisar la Grediente no cumple con lo indicado segun matriz-Sol.Juntos';
            END IF;
          ELSE
            NULL;
          END IF;
        END;
        BEGIN
          ve_rptac := '';
          PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_nuevacuota_menororiginal(ve_instancia,
                                                                        ve_rptac);
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                     'NUOCUO_MYMN_RPG_CAJA', --variable
                                                     ve_rptac, --valor
                                                     91, --regla
                                                     ve_instancia --instancia
                                                     );
          IF ve_rptac = 'N' THEN
            IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
               LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
              VE_MENSAJE := VE_MENSAJE || ';' ||
                            'RNG Caja: La nueva Cuota es mayor a la cuota Origen Sol.Juntos';
            ELSE
              VE_MENSAJE := 'RNG Caja: La nueva Cuota es mayor a la cuota Origen Sol.Juntos';
            END IF;
          ELSE
            NULL;
          END IF;
        END;
      END IF;
    
    END;
  END;

  PROCEDURE SP_VALIDAR_REGLAS_UNIV(ve_instancia in number, --INSTANCIA
                                   VI_NRO       in number, --CORRELATIVO
                                   ve_mensaje   out varchar --MENSAJE DEVUELTO
                                   ) IS
  
    VE_MSG       VARCHAR(200);
    VE_COD_ERROR NUMBER(2);
    VE_MSG_ERROR VARCHAR(100);
  
    v_tcovid               varchar(1);
    ve_rptac               varchar(150);
    VE_DESCRIPCION         VARCHAR(250);
    ve_rptan               number(17, 6);
    vo_excepcion           varchar(1);
    VI_PLAZO_CAJA          number(17, 2);
    VI_PLAZO_CAJA_PRP      number(17, 2);
    VI_GRACIA_CAJA         NUMBER(5, 2);
    VI_MONTO_CAJA          number(17, 2);
    VI_TIPO_REPROGRAMACION varchar(10);
    VE_RPTA_DESACTIVA_REG  VARCHAR(1);
    VE_FECHA               DATE;
    VE_RPTAMSG             VARCHAR2(100);
    VE_CUO                 VARCHAR(1);
    TEMP                   NUMBER(17, 2);
    vi_mensaje_SOLJUNTOS   varchar(350);
    vo_grupo_nf            varchar(2);
    vo_exepcion            varchar(1);
    VI_CONVENIO            NUMBER(9);
    vi_tipo_reprog         varchar(50);
  
    vi_pgcod          number(3);
    vi_mod            number(3);
    vi_suc            number(4);
    vi_mda            number(4);
    vi_pap            number(4);
    vi_cta            number(9);
    vi_ope            number(9);
    vi_sbo            number(3);
    vi_top            number(3);
    vi_plazo_preseteo number(5);
    vi_plazo_609      number(5);
    VI_UNI            VARCHAR(10);
    vi_aux            number(5);
    --
    ln_reprog      number(4);
    ln_cargo       number(4);
    ln_aproba      varchar(100);
    vi_exist_lista varchar(30);
  
    vi_gradiente_limite number(17, 2);
    vi_plazo_limite     number(17, 2);
    vi_gracia_limite    number(17, 2);
  BEGIN
    -------------------------------------------------
    -- DATOS INCIALES DEL PROCESO
    -------------------------------------------------
    -- FECHA DE SISTEMA
    BEGIN
      SELECT PGFAPE INTO VE_FECHA FROM FST017 WHERE PGCOD = 1;
    exception
      when others then
        null;
    END;
  
    -------------------------------------------------
    -- EXONERACION
    -------------------------------------------------
    BEGIN
      pq_cr_reprogramaexo.sp_VarRefExo(VE_INSTANCIA, VE_CUO, VE_RPTAC);
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'ES_REFCONEXO', --variable
                                                 VE_RPTAC, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                   VE_INSTANCIA,
                                                   'ES_REFCONEXO',
                                                   VE_RPTA_DESACTIVA_REG);
      PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                          VE_INSTANCIA,
                                                          'ES_REFCONEXO',
                                                          vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
    
      --IF VE_RPTAC
      IF VE_RPTAC <> 'S' OR VE_RPTAC IS NULL OR VE_RPTA_DESACTIVA_REG = 'S' OR
         vo_excepcion = 'S' THEN
        NULL;
      ELSE
        --  ve_mensaje:='RSC: Crédito Refinanciado con exoneración Futura';
      
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RSC: Crédito Refinanciado con exoneración Futura';
        ELSE
          ve_mensaje := 'RSC: Crédito Refinanciado con exoneración Futura';
        END IF;
      
        --RETURN;  --DESCOMENTAR 19092021
      END IF;
    END;
  
    -------------------------------------------------
    -- VALIDAR REGLA QUE NO TENGA CAPITAL NEGATIVO
    -------------------------------------------------
    VE_RPTAC := '';
    /*
    begin
       pq_cr_capital_negativo.sp_existe_609(ve_instancia,
                                            VE_RPTAC);
       PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(
                                                VI_NRO,
                                                'TIENE_CAPITAL_NEGATIVO',--variable
                                                VE_RPTAC,--valor
                                                91,--regla
                                                ve_instancia--instancia
                                               );
      IF ve_rptac <> 'S' THEN
      --VE_MENSAJE:= '';
        NULL;
      ELSE
        ve_mensaje:='RSC:Tiene Capital Negativo, Volver a procesar, de tal forma que no genere capital negativo';
      END IF;
    end;
    */
    -------------------------------------------------
    -- VALIDAR REGLA TIPO REPROG CRM
    -------------------------------------------------
    VE_RPTAC := '';
    begin
      pq_cr_funciones_cho.sp_indicador_CRM_Caja(ve_instancia, VE_RPTAC);
      --apachecoh 2023.09.27 Actualizamos la tabla JAQA400
      begin
        pq_cr_validar_rng_reprog.SP_VALIDAR_LISTA_BI(ve_instancia,
                                                     ln_reprog,
                                                     ln_cargo,
                                                     ln_aproba,
                                                     vi_exist_lista);
      exception
        when others then
          null;
      end;
      if VE_RPTAC = 'V' and vi_exist_lista is not null then
        begin
          update JAQA400 A
             set JAQA400AC1 = 'C'
           where A.JAQA400AI1 = ve_instancia
             and A.JAQA400FEC =
                 (SELECT MAX(D.JAQA400FEC)
                    FROM JAQA400 D
                   WHERE D.JAQA400AI1 = ve_instancia);
          commit;
        exception
          when others then
            null;
        end;
      end if;
      --apachecoh 2023.09.27
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'TIPO_REPROG_CRM', --variable
                                                 VE_RPTAC, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
      VI_TIPO_REPROGRAMACION := VE_RPTAC;
      /*
      IF ve_rptac <> 'S' THEN
      --VE_MENSAJE:= '';
        NULL;
      ELSE
        ve_mensaje:='Tiene Capital Negativo, Volver a procesar, de tal forma que no genere capital negativo';
      END IF;
      */
    end;
    -------------------------------------------------
    -- VALIDAR REGLA TIPO REPROG CRM
    -------------------------------------------------
    VE_RPTAC := '';
    begin
      --apachecoh 2023.09.27 Si hay CRM
      pq_cr_funciones_cho.sp_indicador_CRM_Caja(ve_instancia, VE_RPTAC);
      if VE_RPTAC = 'N' then
        pQ_CR_RT_REPROGRAMACION.sp_cr_existe_credito_crm(ve_instancia,
                                                         VE_RPTAC);
      end if;
      --apachecoh 2023.09.27   
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'REPRO_IND_CRM', --variable
                                                 VE_RPTAC, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
    
      IF trim(ve_rptac) <> 'N' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        NULL;
        -- ve_mensaje:='RSC: No tiene CRM gestionado';
        /* 2024.06.12 - descomentar temporalmente.
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' || 'RSC: No tiene CRM gestionado';
        ELSE
          ve_mensaje := 'RSC: No tiene CRM gestionado';
        END IF;
        RETURN; --DESCOMENTAR 19092021  ecollado 20/05/2022
        */
      END IF;
      -------------------------------------------------
      -- CONTROL PARA REPROGRAMADOS FONDOS, NO PERMITIR QUE SE PUEDAN REPROGRAMAR. - 18.08.2022
      -------------------------------------------------
      BEGIN
        IF VI_TIPO_REPROGRAMACION = 'F' THEN
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'No se pueden reprogramar Creditos FONDOS,desde este módulo, realizar desde el Flujo';
            RETURN;
          ELSE
            ve_mensaje := 'No se pueden reprogramar Creditos FONDOS,desde este módulo, realizar desde el Flujo';
            RETURN;
          END IF;
        END IF;
      END;
      -------------------------------------------------
      -- CONTROL PARA REPROGRAMADOS, SI ESTA EN LA LISTA NO DEBE PERMITIR REPROGRAMAR. - 17.08.2022
      -------------------------------------------------
      /* COMENTADO 28.11.2022  - HSUAREZ
      BEGIN
        PQ_CR_VALIDAR_RNG_REPROG.SP_VALIDAR_LISTA(VE_INSTANCIA,
                                                  VE_RPTAC,
                                                  VE_DESCRIPCION);
      END;
      IF VE_RPTAC = 'N' AND VI_TIPO_REPROGRAMACION='V' THEN --valido que este en la lista y que sea reprogramacion COVID
         IF LENGTH(TRIM(VE_MENSAJE))> 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
                  VE_MENSAJE := VE_MENSAJE||';'||VE_DESCRIPCION;
                  RETURN;
              ELSE
                  ve_mensaje:=VE_DESCRIPCION;
                  RETURN;
         END IF;
      END IF;
      */
      ---CONTROL PARA EN CASO DE CAJA NO SALTE
    
      --CANTIDAD DE CUOTAS ES OTRO CONTROL
      --SI ES UN CLIENTE QUE TIENE UN SALDO DE 5000, AL GERENTE REGIONAL
    
    end;
  
    --apachecoh 2024.05.31 Control Lista Negra de Refinanciados y Reprogramados
    begin
      ve_rptac := '';
      pq_cr_controles_cartera_reprogramada.sp_cr_cliente_validar_instancia(VE_INSTANCIA,
                                                                           VE_RPTAC,
                                                                           VE_RPTAMSG);
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'LISTNEGR_MEMO225', --variable
                                                 VE_RPTAC, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                   VE_INSTANCIA,
                                                   'LISTNEGR_MEMO225',
                                                   VE_RPTA_DESACTIVA_REG);
    
      IF trim(ve_rptac) <> 'S' OR VE_RPTA_DESACTIVA_REG = 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' || 'RSC: ' || VE_RPTAMSG;
        ELSE
          ve_mensaje := 'RSC: ' || VE_RPTAMSG;
        END IF;
      END IF;
      ve_rptac := '';
    exception
      when others then
        null;
    end;
    --apachecoh 2024.05.31 Control Lista Negra de Refinanciados y Reprogramados
  
    --CONTROL PLAZO COVID UNILATERAL MENOR A 90 DIAS  14/09/2021
    BEGIN
      VE_RPTAC := '';
      v_tcovid := '';
      pq_cr_funciones_cho.sp_fecha_covid(ve_instancia, ve_rptac);
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'PLAZO_UNILATERAL', --variable
                                                 VE_RPTAC, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
    
      pq_cr_funciones_cho.sp_unilateral(ve_instancia, v_tcovid);
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'ES_UNILATERAL', --variable
                                                 v_tcovid, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
      PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                   VE_INSTANCIA,
                                                   'ES_UNILATERAL',
                                                   VE_RPTA_DESACTIVA_REG);
      PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                          VE_INSTANCIA,
                                                          'PLAZO_UNILATERAL',
                                                          vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
    
      IF trim(ve_rptac) = 'S' AND (v_tcovid = 'U' OR V_TCOVID = 'E') AND
         vo_excepcion <> 'S' AND vi_mod <> 107 AND
         VE_RPTA_DESACTIVA_REG <> 'S' THEN
        --SE AGREGO PARA QUE NO INCLUYA EN ESTE CONTROL MODULO 107
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RSC: La nueva fecha de vcto. no puede ser mayor a 90 dias de la anterior reprog.';
        ELSE
          ve_mensaje := 'RSC: La nueva fecha de vcto. no puede ser mayor a 90 dias de la anterior reprog.';
        END IF;
        --RETURN;
        --NULL;
      ELSE
        NULL;
      END IF;
    
    END;
    -----------------------------
    --PASIVO PATRIMONIO
    -----------------------------
    BEGIN
      ve_rptac := '';
      pq_cr_reprog_sincap.sp_activo_pasivo(VE_INSTANCIA,
                                           VE_FECHA,
                                           VE_RPTAC);
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'DIF_PASIVOPAT', --variable
                                                 VE_RPTAC, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                   VE_INSTANCIA,
                                                   'DIF_PASIVOPAT',
                                                   VE_RPTA_DESACTIVA_REG);
      IF trim(ve_rptac) <> 'S' OR VE_RPTA_DESACTIVA_REG = 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RSC: Pasivo Patrimonio Difiere del Activo';
        ELSE
          ve_mensaje := 'RSC: Pasivo Patrimonio Difiere del Activo';
        END IF;
      END IF;
      ve_rptac := '';
    
    END;
    -----------------------------------------------------------
    -- OBTENER PLAZO Y VALIDAR QUE NO SUPERE LO MENCIONADO
    -----------------------------------------------------------
    ve_rptan := 0;
    BEGIN
    
      pq_cr_variables.sp_REP_PLAZO(1, ve_instancia, ve_rptan);
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'REP_PLAZO_UNIV', --variable
                                                 to_char(ve_rptan), --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
      PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_LIM_VAR('REP_PLAZO_UNIV_MAX', --VARIABLE
                                                  VE_RPTAC);
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'REP_PLAZO_UNIV_MAX', --variable
                                                 ve_rptac, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
    
      IF ve_rptan < to_number(ve_rptac) THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RSC: Plazo mayor al Permitido';
        ELSE
          ve_mensaje := 'RSC: Plazo mayor al Permitido';
        END IF;
      END IF;
    END;
    --------------------------------------------------------------------------------------
    ----REGLAS PARA GOBIERNO, TODOS LOS CREDITOS VALIDAR QUE NO SEA FAE TURISMO O FAE AGRO
    --------------------------------------------------------------------------------------
  
    pq_cr_ctr_faeagro_turismo.sp_cr_es_pae(VE_INSTANCIA, VE_RPTAC);
  
    PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                               'PAE_MYPE', --variable
                                               ve_rptac, --valor
                                               91, --regla
                                               ve_instancia --instancia
                                               );
    IF VE_RPTAC <> 'S' THEN
      --VE_MENSAJE:= '';
      NULL;
    ELSE
      IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
        VE_MENSAJE := VE_MENSAJE || ';' ||
                      'RSC: Crd.PAE Mype no se puede reprogramar';
      ELSE
        ve_mensaje := 'RSC: Crd.PAE Mype no se puede reprogramar';
      END IF;
    END IF;
  
    --apachecoh 17/10/2023 Validar que si es de tipo COVID no permita continuar si es de tipo UNILATERAL 
    pq_cr_funciones_cho.sp_indicador_CRM_Caja(VE_INSTANCIA, VE_RPTAC);
    vi_tipo_reprog := VE_RPTAC;
  
    IF vi_tipo_reprog = 'V' THEN
      --Validamos si es UNILATERAL
      begin
        SELECT JAQA400AC1
          INTO VI_UNI
          FROM JAQA400
         WHERE JAQA400AI1 = VE_INSTANCIA
           AND JAQA400FEC = (SELECT PGFAPE FROM FST017 WHERE PGCOD = 1)
           AND ROWNUM = 1;
      exception
        when others then
          null;
      end;
    
      if vi_tipo_reprog = 'V' and (VI_UNI <> 'C') then
        VE_RPTAC := 'N'; -- UNILATERAL
      else
        VE_RPTAC := 'S'; -- CONSENSUADO
      end if;
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'RESTRIC_UNILAT', --variable
                                                 VE_RPTAC, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                   VE_INSTANCIA,
                                                   'RESTRIC_UNILAT',
                                                   VE_RPTA_DESACTIVA_REG);
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                          VE_INSTANCIA,
                                                          'RESTRIC_UNILAT',
                                                          vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.                                              
    
      IF VE_RPTAC <> 'N' OR VE_RPTA_DESACTIVA_REG = 'S' or
         vo_excepcion = 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        NULL;
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RSC: No se puede reprogramar la operación de forma UNILATERAL.';
        ELSE
          ve_mensaje := 'RSC: No se puede reprogramar la operación de forma UNILATERAL.';
        END IF;
      END IF;
    
    END IF;
    ---apachecoh 17/10/2023 Validar que si es de tipo COVID no permita continuar si es de tipo UNILATERAL
  
    --apachecoh 08/02/2023 Validar que si es de tipo COVID no permita continuar si esta en lista aqpb936  
    pq_cr_funciones_cho.sp_indicador_CRM_Caja(VE_INSTANCIA, VE_RPTAC);
    vi_tipo_reprog := VE_RPTAC;
  
    IF vi_tipo_reprog = 'V' THEN
      PQ_CR_VALIDAR_RNG_REPROG.SP_VALIDAR_SI_EN_LISTA_EXCP(VE_INSTANCIA,
                                                           VE_RPTAC);
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'COVID_LSTEX', --variable
                                                 VE_RPTAC, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                   VE_INSTANCIA,
                                                   'COVID_LSTEX',
                                                   VE_RPTA_DESACTIVA_REG);
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                          VE_INSTANCIA,
                                                          'COVID_LSTEX',
                                                          vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.                                              
    
      IF VE_RPTAC <> 'N' OR VE_RPTA_DESACTIVA_REG = 'S' or
         vo_excepcion = 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        NULL;
        -- DESCOMENTAR @HASL 2023
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RSC: No se puede reprogramar la operación.';
        ELSE
          ve_mensaje := 'RSC: No se puede reprogramar la operación.';
        END IF;
      END IF;
    END IF;
    ---apachecoh 08/02/2023 Validar que si es de tipo COVID no permita continuar si esta en lista aqpb936       
  
    --apachecoh 30/12/2022 Validar que si es de tipo COVID este como UNILATERAL o CONSENSUADO  
    pq_cr_funciones_cho.sp_indicador_CRM_Caja(VE_INSTANCIA, VE_RPTAC);
    vi_tipo_reprog := VE_RPTAC;
  
    IF vi_tipo_reprog = 'V' THEN
      begin
        SELECT jaqa400ac1
          INTO VI_UNI
          FROM JAQA400
         WHERE JAQA400AI1 = VE_INSTANCIA
           and JAQA400FEC = (SELECT PGFAPE FROM FST017 WHERE PGCOD = 1);
      exception
        when others then
          null;
      end;
    
      if vi_tipo_reprog = 'V' and (VI_UNI = ' ' or VI_UNI is null) then
        VE_RPTAC := 'N';
      else
        VE_RPTAC := 'S';
      end if;
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'COVID_UNI_CON', --variable
                                                 VE_RPTAC, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                   VE_INSTANCIA,
                                                   'COVID_UNI_CON',
                                                   VE_RPTA_DESACTIVA_REG);
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                          VE_INSTANCIA,
                                                          'COVID_UNI_CON',
                                                          vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.                                              
    
      IF VE_RPTAC <> 'N' OR VE_RPTA_DESACTIVA_REG = 'S' or
         vo_excepcion = 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RSC: No se indico el tipo de RPG(Unilateral o Consensuado) en la etapa de solicitud.';
        ELSE
          ve_mensaje := 'RSC: No se indico el tipo de RPG(Unilateral o Consensuado) en la etapa de solicitud.';
        END IF;
      END IF;
    END IF;
    --Fin apachecoh 30/12/2022 Validar que si es de tipo COVID este como UNILATERAL o CONSENSUADO
  
    --ecollado 23/12/2022 Maximo dias Dias de Gracia - Reprogramacion
  
    pq_cr_funciones_cho.sp_indicador_CRM_Caja(VE_INSTANCIA, VE_RPTAC);
    vi_tipo_reprog := VE_RPTAC;
    begin
      SELECT jaqa400ac1
        INTO VI_UNI
        FROM JAQA400
       WHERE JAQA400AI1 = VE_INSTANCIA
         and JAQA400FEC = (SELECT PGFAPE FROM FST017 WHERE PGCOD = 1);
    exception
      when others then
        null;
    end;
    if vi_tipo_reprog = 'V' AND VI_UNI = 'U' then
      pq_cr_max_dias_reprog.sp_cr_max_dias_reprog(VE_INSTANCIA, VE_RPTAC);
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'GRACIA_CONLA', --variable
                                                 VE_RPTAC, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                   VE_INSTANCIA,
                                                   'GRACIA_CONLA',
                                                   VE_RPTA_DESACTIVA_REG);
      PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                          VE_INSTANCIA,
                                                          'GRACIA_CONLA',
                                                          vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.                                              
      IF VE_RPTAC <> 'N' OR VE_RPTA_DESACTIVA_REG = 'S' or
         vo_excepcion = 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RSC: Dias de gracia superior al maximo permitido en reprogramados';
        ELSE
          ve_mensaje := 'RSC: Dias de gracia superior al maximo permitido en reprogramados';
        END IF;
      END IF;
    end if;
  
    --Fin ecollado 23/12/2022 Maximo dias Dias de Gracia - Reprogramacion
  
    --ecollado 26/12/2022 Maximo dias Dias de Gracia - Primera Cuta impaga
  
    pq_cr_funciones_cho.sp_indicador_CRM_Caja(VE_INSTANCIA, VE_RPTAC);
    vi_tipo_reprog := VE_RPTAC;
    begin
      SELECT jaqa400ac1
        INTO VI_UNI
        FROM JAQA400
       WHERE JAQA400AI1 = VE_INSTANCIA
         and JAQA400FEC = (SELECT PGFAPE FROM FST017 WHERE PGCOD = 1);
    exception
      when others then
        null;
    end;
    if vi_tipo_reprog = 'V' AND VI_UNI = 'U' then
      pq_cr_max_dias_reprog.sp_cr_min_fecha(VE_INSTANCIA, VE_RPTAC);
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'GRACIA_CUOIM', --variable
                                                 VE_RPTAC, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                   VE_INSTANCIA,
                                                   'GRACIA_CUOIM',
                                                   VE_RPTA_DESACTIVA_REG);
      PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                          VE_INSTANCIA,
                                                          'GRACIA_CUOIM',
                                                          vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.                                              
      IF VE_RPTAC <> 'N' OR VE_RPTA_DESACTIVA_REG = 'S' or
         vo_excepcion = 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RSC: Dias de gracia superior al maximo permitido en reprogramados.';
        ELSE
          ve_mensaje := 'RSC: Dias de gracia superior al maximo permitido en reprogramados.';
        END IF;
      END IF;
    end if;
  
    --Fin ecollado 26/12/2022 Maximo dias Dias de Gracia - Primera Cuota Impaga
  
    --VALIDACIONES ADICIONALES SOLO EN CASO DE SER REPROGRAMADO CAJA, EN GENERAL
    IF VI_TIPO_REPROGRAMACION = 'C' THEN
      BEGIN
        --VALIDAR SI SE AUTORIZO LA GESTION DEL CRÉDITO
        PQ_CR_FUNCIONES_CHO.SP_EXISTE_CRM_CAJA(VE_INSTANCIA, ve_rptac);
      
        PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                   'VALIDAR_AUTOR_CAJA', --variable
                                                   ve_rptac, --valor
                                                   91, --regla
                                                   ve_instancia --instancia
                                                   );
      
        IF trim(ve_rptac) = 'Z' THEN
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'RSC:Reprogramación Caja, falta autorizar la Reprogramacion';
          ELSE
            ve_mensaje := 'RSC:Reprogramación Caja, falta autorizar la Reprogramacion';
          END IF;
        END IF;
      
        IF trim(ve_rptac) = 'D' THEN
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'RSC:Diferencia en datos CRM con datos en BT';
          ELSE
            ve_mensaje := 'RSC:Diferencia en datos CRM con datos en BT';
          END IF;
        END IF;
        IF trim(ve_rptac) = 'S' THEN
          NULL;
        END IF;
      
        --PLAZO MATRIZ CAJA
        PQ_CR_RNG_REPROG_HS.sp_cr_plazo_residual_2024(ve_instancia,
                                                      ve_rptan);
        /*
        PQ_CR_RNG_REPROG_HS.sp_cr_plazo_matriz(ve_instancia, ve_rptan);
        VI_PLAZO_CAJA := ve_rptan + 0.99;
        PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                   'PLAZO_MATRIZ_CAJA', --variable
                                                   to_char(VI_PLAZO_CAJA), --valor
                                                   91, --regla
                                                   ve_instancia --instancia
                                                   );
        -----PLAZO CAJA PROPUESTO
        --VI_PLAZO_CAJA := ve_rptan;--DIVIDO ENTRE 30
        ve_rptan := 0;
        pq_cr_funciones_cho.sp_plazo_caja(ve_instancia, ve_rptan);
        if ve_rptan > 0 then
          VI_PLAZO_CAJA_PRP := ve_rptan / 30;
        end if;
        */
        BEGIN
          select tp1imp1
            into vi_plazo_limite
            from fst198
           where tp1cod1 = 10899
             and tp1corr1 = 400000
             and tp1corr2 = 19
             and tp1corr3 = 1;
        EXCEPTION
          WHEN OTHERS THEN
            vi_plazo_limite := 24;
        END;
        PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                   'PLAZO_PRPTO_CAJA', --variable
                                                   to_char(ve_rptan), --valor
                                                   91, --regla
                                                   ve_instancia --instancia
                                                   );
        -----------------
        --VALIDA SI ESTA EXCEPTUADO
        vo_excepcion := 'N';
        PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                            VE_INSTANCIA,
                                                            'PLAZO_CAJA',
                                                            vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
        PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                     VE_INSTANCIA,
                                                     'PLAZO_CAJA',
                                                     VE_RPTA_DESACTIVA_REG);
        --IF (VI_PLAZO_CAJA >= VI_PLAZO_CAJA_PRP) or vo_excepcion = 'S' or VE_RPTA_DESACTIVA_REG = 'S' THEN
        IF (vi_plazo_limite >= ve_rptan) or vo_excepcion = 'S' or
           VE_RPTA_DESACTIVA_REG = 'S' THEN
          NULL;
        ELSE
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'RSC: Plazo residual propuesto, mayor al Permitido de acuerdo a Matriz-Caja';
          ELSE
            ve_mensaje := 'RSC: Plazo residual propuesto, mayor al Permitido de acuerdo a Matriz-Caja';
          END IF;
        END IF;
      END;
    
      -------------------------------------------------
      -- VALIDAR GRACIA
      -------------------------------------------------
      PQ_CR_RNG_REPROG_HS.sp_cr_gracia_caj(ve_instancia,
                                           VI_GRACIA_CAJA,
                                           VI_MONTO_CAJA);
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'GRACIA_RPG_CAJA', --variable
                                                 to_char(VI_GRACIA_CAJA), --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'MONTO_RPG_CAJA', --variable
                                                 to_char(VI_MONTO_CAJA), --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
      --CONTROL FUNCION
      --VALIDA SI ESTA EXCEPTUADO
      vo_excepcion := 'N';
      PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                          VE_INSTANCIA,
                                                          'GRACIA_CAJA',
                                                          vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
      PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                   VE_INSTANCIA,
                                                   'GRACIA_CAJA',
                                                   VE_RPTA_DESACTIVA_REG);
    
      /*
      IF (VI_MONTO_CAJA <= 75000 AND VI_GRACIA_CAJA > 60) AND
         vo_excepcion <> 'S' and VE_RPTA_DESACTIVA_REG <> 'S' THEN
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 200 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RNG Caja: La Gracia es mayor a la permitida de acuerdo a la matriz-CAJA';
        ELSE
          VE_MENSAJE := 'RNG Caja: La Gracia es mayor a la permitida de acuerdo a la matriz-CAJA';
        END IF;
      ELSE
        NULL;
      END IF;
      IF (VI_MONTO_CAJA > 75000 AND VI_GRACIA_CAJA > 90) AND
         vo_excepcion <> 'S' THEN
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RNG Caja: La Gracia es mayor a la permitida de acuerdo a la matriz-CAJA';
        ELSE
          VE_MENSAJE := 'RNG Caja: La Gracia es mayor a la permitida de acuerdo a la matriz-CAJA';
        END IF;
      */
      BEGIN
        select tp1imp1
          into vi_gracia_limite
          from fst198
         where tp1cod1 = 10899
           and tp1corr1 = 400000
           and tp1corr2 = 18
           and tp1corr3 = 1;
      EXCEPTION
        WHEN OTHERS THEN
          vi_gracia_limite := 180;
      END;
      IF vi_gracia_caja > vi_gracia_limite and
         (vo_exepcion <> 'S' or vo_exepcion is null) and
         VE_RPTA_DESACTIVA_REG <> 'S' THEN
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RNG Caja: Gracia mayor al limite, segun matriz-CAJA';
        ELSE
          VE_MENSAJE := 'RNG Caja: Gracia mayor al limite, segun matriz-CAJA';
        END IF;
      ELSE
        NULL;
      END IF;
      -------------------------------------------------
      -- VALIDAR GRADIENTE
      -------------------------------------------------
      BEGIN
        ve_rptac := '';
        PQ_CR_RNG_REPROG_HS.SP_CR_GRADIENTE_CAJ(ve_instancia, ve_rptan);
        PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                   'GRADI_RPG_CAJA', --variable
                                                   ve_rptac, --valor
                                                   91, --regla
                                                   ve_instancia --instancia
                                                   );
        --VALIDA SI ESTA EXCEPTUADO
        vo_excepcion := 'N';
        PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                            VE_INSTANCIA,
                                                            'GRADIENTE_CAJA',
                                                            vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
        PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                     VE_INSTANCIA,
                                                     'GRADIENTE_CAJA',
                                                     VE_RPTA_DESACTIVA_REG);
      
        BEGIN
          select tp1imp1
            into vi_gradiente_limite
            from fst198
           where tp1cod1 = 10899
             and tp1corr1 = 400000
             and tp1corr2 = 17
             and tp1corr3 = 1;
        EXCEPTION
          WHEN OTHERS THEN
            vi_gradiente_limite := 50;
        END;
        IF ve_rptan > vi_gradiente_limite and
           (vo_exepcion <> 'S' or vo_exepcion is null) and
           VE_RPTA_DESACTIVA_REG <> 'S' THEN
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'RNG Caja: Gradiente mayor al limite segun matriz-CAJA';
          ELSE
            VE_MENSAJE := 'RNG Caja: Gradiente mayor al limite segun matriz-CAJA';
          END IF;
        ELSE
          NULL;
        END IF;
      END;
    
      --------
      -- CONTORL DE EXONERACION DE ULTIMA CUOTA
      --------
      BEGIN
        VE_RPTAC := '';
        PQ_CR_VALIDAR_RNG_REPROG.SP_CONTROL_EXONERACION(VE_INSTANCIA,
                                                        VE_RPTAC);
        PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                   'EXONERA_ULT_CUOTA', --variable
                                                   VE_RPTAC, --valor
                                                   91, --regla
                                                   ve_instancia --instancia
                                                   );
        PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                     VE_INSTANCIA,
                                                     'EXONERA_ULT_CUOTA',
                                                     VE_RPTA_DESACTIVA_REG);
        IF VE_RPTAC <> 'S' or VE_RPTA_DESACTIVA_REG = 'S' THEN
          NULL;
        ELSE
          IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
             LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
            VE_MENSAJE := VE_MENSAJE || ';' ||
                          'RNG CAJA: LA ULTIMA CUOTA ES MAYOR A LO PERMITIDO ';
          ELSE
            ve_mensaje := 'RNG CAJA: PLA ULTIMA CUOTA ES MAYOR A LO PERMITIDO';
          END IF;
        END IF;
      END;
      /*
      ELSE
      
          IF trim(ve_rptac) = 'N' THEN
             IF LENGTH(TRIM(VE_MENSAJE))> 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
                ve_mensaje:= ve_mensaje||';RSC: No se ingresaron los comentarios en la Propuesta, ingresarlos';
             else
                ve_mensaje:= 'RSC: No se ingresaron los comentarios en la Propuesta, ingresarlos';
             end if;
          ELSE
              NULL;
          END IF;
        */
    END IF;
  
    --REGLAS GENERALES
    begin
      VE_RPTAC := '';
      PQ_CR_VALIDAR_RNG_REPROG.SP_CONTROLAR_COMENTARIOS(ve_instancia,
                                                        VE_RPTAC);
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'V_CONTROL_CMT', --variable
                                                 VE_RPTAC, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
      VE_RPTA_DESACTIVA_REG := 'N';
      PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                   ve_instancia,
                                                   'V_CONTROL_CMT',
                                                   VE_RPTA_DESACTIVA_REG);
      vo_excepcion := 'N';
      PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                          VE_INSTANCIA,
                                                          'V_CONTROL_CMT',
                                                          vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
      --Dbms_Output.put_line('V_CONTROL_CMT');
      --Dbms_Output.put_line(VE_RPTAC);
      --SP_VALIDAR_REPROGRAMACIONES_CRM(ve_instancia, ve_respuesta);
      IF trim(ve_rptac) = 'N' AND VE_RPTA_DESACTIVA_REG <> 'S' AND
         vo_excepcion <> 'S' THEN
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          ve_mensaje := ve_mensaje ||
                        ';RSC: No se ingresaron los comentarios en la Propuesta, ingresarlos';
        else
          ve_mensaje := 'RSC: No se ingresaron los comentarios en la Propuesta, ingresarlos';
        end if;
      
        --Dbms_Output.put_line(ve_mensaje);
        --RETURN;  --DESCOMENTAR 19092021
        --VE_MENSAJE:= '';
      
      ELSE
        NULL;
      END IF;
      /* REGLAS DE REPROGRAMADOS COVID - BERTHONY*/ --25.11.2022
      /*
      PQ_CR_REPROGRAMADOS_VALI_BLOQ.val_cred_reprogramacion(
                                                                 ve_instancia,
                                                                 VE_RPTAC,
                                                                 VE_MSG,
                                                                 VE_COD_ERROR,
                                                                 VE_MSG_ERROR
                                                               );
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(
                                                    VI_NRO,
                                                    'V_BLOQ_REPROG',--variable
                                                    VE_RPTAC,--valor
                                                    91,--regla
                                                    ve_instancia--instancia
                                                   );
           VE_RPTA_DESACTIVA_REG := 'N';
           PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(
                                                           VI_NRO,
                                                           ve_instancia,
                                                           'V_BLOQ_REPROG',
                                                           VE_RPTA_DESACTIVA_REG
                                                          );
           vo_excepcion := 'N';
           PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(
                                                                VI_NRO,
                                                                VE_INSTANCIA,
                                                                'V_BLOQ_REPROG',
                                                                vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
      
          IF trim(ve_rptac) = 'S' AND VE_RPTA_DESACTIVA_REG <> 'S' AND vo_excepcion <> 'S' THEN
            IF LENGTH(TRIM(VE_MENSAJE))> 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
               ve_mensaje:= ve_mensaje||'; RSC: '||VE_MSG;
            else
               ve_mensaje:= VE_MSG;
            end if;
          ELSE
             NULL;
          END IF;
          */
      /*REGLA REPROGRAMADOS CONVENIO*/
      BEGIN
        BEGIN
          PQ_CR_RN_REPROG_CAJA.sp_buscar_credito(ve_instancia,
                                                 vi_pgcod,
                                                 vi_mod,
                                                 vi_suc,
                                                 vi_mda,
                                                 vi_pap,
                                                 vi_cta,
                                                 vi_ope,
                                                 vi_sbo,
                                                 vi_top);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        BEGIN
          SELECT TP1NRO2
            INTO VI_CONVENIO
            FROM FST198
           WHERE TP1COD1 = 11161
             AND TP1CORR1 = 5
             AND TP1CORR2 = 1
             AND TP1CORR3 > 0
             AND TP1NRO1 = 1
             AND TP1NRO2 = VI_MOD;
        EXCEPTION
          WHEN OTHERS THEN
            VI_CONVENIO := 0;
        END;
        IF VI_CONVENIO = VI_MOD THEN
          /*REGLA DE CONTROL 1*/
          BEGIN
            PQ_CR_RN_REPROG_CAJA_ENH.sp_cr_control_mismo_dia(ve_instancia,
                                                             VE_RPTAC);
            PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                       'V_RPGCV_DIAF', --variable
                                                       VE_RPTAC, --valor
                                                       91, --regla
                                                       ve_instancia --instancia
                                                       );
            VE_RPTA_DESACTIVA_REG := 'N';
            PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                         ve_instancia,
                                                         'V_RPGCV_DIAF',
                                                         VE_RPTA_DESACTIVA_REG);
            vo_excepcion := 'N';
            PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                                VE_INSTANCIA,
                                                                'V_RPGCV_DIAF',
                                                                vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
          
            IF trim(ve_rptac) = 'S' AND VE_RPTA_DESACTIVA_REG <> 'S' AND
               vo_excepcion <> 'S' THEN
              IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
                 LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
                ve_mensaje := ve_mensaje || ';RSC:' ||
                              'DIA DE FECHA DE PAGO DIFERENTE AL ORIGINAL EN CONVENIO';
              else
                ve_mensaje := 'RSC:DIA DE FECHA DE PAGO DIFERENTE AL ORIGINAL EN CONVENIO';
              end if;
            ELSE
              NULL;
            END IF;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          /*REGLA DE CONTROL 2*/
          BEGIN
            PQ_CR_RN_REPROG_CAJA_ENH.sp_cr_control_cuo_mayor(ve_instancia,
                                                             VE_RPTAC);
            PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                       'V_RPGCV_CUO', --variable
                                                       VE_RPTAC, --valor
                                                       91, --regla
                                                       ve_instancia --instancia
                                                       );
            VE_RPTA_DESACTIVA_REG := 'N';
            PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                         ve_instancia,
                                                         'V_RPGCV_CUO',
                                                         VE_RPTA_DESACTIVA_REG);
            vo_excepcion := 'N';
            PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                                VE_INSTANCIA,
                                                                'V_RPGCV_CUO',
                                                                vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
          
            IF trim(ve_rptac) = 'S' AND VE_RPTA_DESACTIVA_REG <> 'S' AND
               vo_excepcion <> 'S' THEN
              IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
                 LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
                ve_mensaje := ve_mensaje || ';RSC:' ||
                              'CUOTA MENOR O MAYOR AL PERMITIDO EN CONVENIO';
              else
                ve_mensaje := 'RSC:CUOTA MENOR O MAYOR AL PERMITIDO EN CONVENIO';
              end if;
            ELSE
              NULL;
            END IF;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          /*REGLA DE CONTROL 3*/
          BEGIN
            PQ_CR_RN_REPROG_CAJA_ENH.sp_cr_control_cuota_impaga(ve_instancia,
                                                                VE_RPTAC);
            PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                       'V_RPGCV_GRA', --variable
                                                       VE_RPTAC, --valor
                                                       91, --regla
                                                       ve_instancia --instancia
                                                       );
            VE_RPTA_DESACTIVA_REG := 'N';
            PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                         ve_instancia,
                                                         'V_RPGCV_GRA',
                                                         VE_RPTA_DESACTIVA_REG);
            vo_excepcion := 'N';
            PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                                VE_INSTANCIA,
                                                                'V_RPGCV_GRA',
                                                                vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
          
            IF trim(ve_rptac) = 'S' AND VE_RPTA_DESACTIVA_REG <> 'S' AND
               vo_excepcion <> 'S' THEN
              IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
                 LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
                ve_mensaje := ve_mensaje || ';RSC:' ||
                              'GRACIA MAYOR A LA PERMITIDA EN CONVENIO';
              else
                ve_mensaje := 'RSC:GRACIA MAYOR A LA PERMITIDA EN CONVENIO';
              end if;
            ELSE
              NULL;
            END IF;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          /*REGLA DE CONTROL 4*/
          BEGIN
            PQ_CR_RN_REPROG_CAJA_ENH.sp_cr_control_negativo(ve_instancia,
                                                            VE_RPTAC);
            PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                       'V_RPGCVNEG', --variable
                                                       VE_RPTAC, --valor
                                                       91, --regla
                                                       ve_instancia --instancia
                                                       );
            VE_RPTA_DESACTIVA_REG := 'N';
            PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                         ve_instancia,
                                                         'V_RPGCVNEG',
                                                         VE_RPTA_DESACTIVA_REG);
            vo_excepcion := 'N';
            PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                                VE_INSTANCIA,
                                                                'V_RPGCVNEG',
                                                                vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
          
            IF trim(ve_rptac) = 'S' AND VE_RPTA_DESACTIVA_REG <> 'S' AND
               vo_excepcion <> 'S' THEN
              IF LENGTH(TRIM(VE_MENSAJE)) > 0 and
                 LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
                ve_mensaje := ve_mensaje || ';RSC:' ||
                              'Credito Conveino con Capitalización de Interes.';
              else
                ve_mensaje := 'RSC:Credito Convenio con Capitalización de Interes.';
              end if;
            ELSE
              NULL;
            END IF;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
      END;
      /*FIN REGLA DE REPROGRAMADOS CONVENIO*/
      /*
      IF ve_respuesta = 'S' THEN --ecollado
        IF LENGTH(TRIM(VE_MENSAJE))> 0 and LENGTH(TRIM(VE_MENSAJE)) < 200 THEN
           ve_mensaje:= ve_mensaje||';RSC: Cuenta con dos o mas Gestiones en CRM, anule la gestion que no debe procesarce, devolver la solicitud y volver a gestionar';
        else
           ve_mensaje:= 'RSC: Cuenta con dos o mas Gestiones en CRM';
        end if;
      
        --Dbms_Output.put_line(ve_mensaje);
        --RETURN;  --DESCOMENTAR 19092021
      --VE_MENSAJE:= '';
      
      ELSE
         NULL;
      END IF;*/
    
    end;
    begin
      VE_RPTAC := '';
      PQ_CR_VALIDAR_RNG_REPROG.SP_VALIDAR_REPROGRAMACIONES_CRM(ve_instancia,
                                                               VE_RPTAC);
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'V_VALIDAR_CRM', --variable
                                                 VE_RPTAC, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
    
      VE_RPTA_DESACTIVA_REG := 'N';
      PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                   ve_instancia,
                                                   'V_VALIDAR_CRM',
                                                   VE_RPTA_DESACTIVA_REG);
      vo_excepcion := 'N';
      PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                          VE_INSTANCIA,
                                                          'V_VALIDAR_CRM',
                                                          vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
    
      IF trim(ve_rptac) = 'S' AND VE_RPTA_DESACTIVA_REG <> 'S' AND
         vo_excepcion <> 'S' THEN
      
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          ve_mensaje := ve_mensaje ||
                        ';RSC: Cuenta con más de una Gestión en CRM, anule la gestión que no debe procesarse, devolver la solicitud y volver a gestionar';
        else
          ve_mensaje := 'RSC: Cuenta con más de una Gestión en CRM, anule la gestión que no debe procesarse,devolver la solicitud y volver a gestionar';
        end if;
        --Dbms_Output.put_line(ve_mensaje);
        --RETURN;  --DESCOMENTAR 19092021
        --VE_MENSAJE:= '';
      ELSE
        NULL;
      END IF;
    end;
  
    begin
      VE_RPTAC := '';
      PQ_CR_VALIDAR_RNG_REPROG.SP_CR_VALIDAR_CUOTA(ve_instancia, VE_RPTAC);
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'V_VALIDAR_CUOTA0', --variable
                                                 VE_RPTAC, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
      VE_RPTA_DESACTIVA_REG := 'N';
      PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                   ve_instancia,
                                                   'V_VALIDAR_CUOTA0',
                                                   VE_RPTA_DESACTIVA_REG);
      vo_excepcion := 'N';
      PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                          VE_INSTANCIA,
                                                          'V_VALIDAR_CUOTA0',
                                                          vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
      IF trim(ve_rptac) = 'S' AND VE_RPTA_DESACTIVA_REG <> 'S' AND
         vo_excepcion <> 'S' THEN
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          ve_mensaje := ve_mensaje ||
                        ';RSC: Reprogramación no puede tener cuotas con valor 0';
        else
          ve_mensaje := 'RSC: Reprogramacion no puede tener cuotas con valor 0';
        end if;
      ELSE
        NULL;
      END IF;
    end;
    BEGIN
      --validar credito obtener modulo y tipo de operacion
      BEGIN
        select jaqa400suc,
               jaqa400mod,
               jaqa400mda,
               jaqa400pap,
               jaqa400cta,
               jaqa400ope,
               jaqa400sbo,
               jaqa400top
          into vi_suc,
               vi_mod,
               vi_mda,
               vi_pap,
               vi_cta,
               vi_ope,
               vi_sbo,
               vi_top
          from jaqa400
         where jaqa400ai1 = ve_instancia
           and jaqa400fec = (select max(jaqa400fec)
                               from jaqa400
                              where jaqa400ai1 = ve_instancia);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      ---preseteo plazo maximo
      BEGIN
        SELECT TP1IMP1
          INTO vi_plazo_preseteo
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11161
           AND TP1CORR1 = 1
           AND TP1CORR2 = 0
           AND TP1CORR3 > 0
           AND TP1NRO1 = vi_mod
           AND TP1NRO2 = vi_top;
      EXCEPTION
        WHEN OTHERS THEN
          BEGIN
            SELECT TP1IMP1
              INTO vi_plazo_preseteo
              FROM FST198
             WHERE TP1COD = 1
               AND TP1COD1 = 11161
               AND TP1CORR1 = 1
               AND TP1CORR2 = 0
               AND TP1CORR3 > 0
               AND TP1NRO1 = vi_mod
               AND TP1NRO2 = 0;
          EXCEPTION
            WHEN OTHERS THEN
              vi_plazo_preseteo := 0;
          END;
      END;
      IF vi_plazo_preseteo is null or nvl(vi_plazo_preseteo, 0) = 0 THEN
        BEGIN
          SELECT TP1IMP1
            INTO vi_plazo_preseteo
            FROM FST198
           WHERE TP1COD = 1
             AND TP1COD1 = 11161
             AND TP1CORR1 = 1
             AND TP1CORR2 = 0
             AND TP1CORR3 > 0
             AND TP1NRO1 = vi_mod
             AND TP1NRO2 = 0;
        EXCEPTION
          WHEN OTHERS THEN
            vi_plazo_preseteo := 0;
        END;
      END IF;
      /*
      begin
        select xy.pp028defn into vi_plazo_preseteo from fpp028 xy
        where xy.pp017par=150 and xy.pp028mod=vi_mod and xy.pp028top=vi_top AND ROWNUM=1;
      exception
        when others then
          null;
      end;
      */
      --validar plazo del credito fecha valor y fecha primer pago
      /*
      begin
        select max(ppfpag)
        into vi_fecha_pago
        from fsd602 where pgcod = 1 and ppsuc = vi_suc and ppmda = vi_mda and pppap = vi_pap and ppcta= vi_cta and ppoper = vi_ope and ppsbop=vi_sbo and pptope = vi_top and pp1stat='T' and d602co='S';
      exception
        when others then
          vi_fecha_pago := '01/01/2000';
      end;
      */
      begin
        select d.ppfpag - d.ppfval
          into vi_plazo_609
          from fsd601 d
         where pgcod = 1
           and d.ppsuc = vi_suc
           and d.ppmda = vi_mda
           and d.pppap = vi_pap
           and d.ppcta = vi_cta
           and d.ppoper = vi_ope
           and d.ppsbop = 609
           and d.pptope = vi_top
           and d.ppfpag = (select min(ppfpag)
                             from fsd601 h
                            where h.pgcod = 1
                              and h.ppsuc = vi_suc
                              and h.ppmda = vi_mda
                              and h.pppap = vi_pap
                              and h.ppcta = vi_cta
                              and h.ppoper = vi_ope
                              and h.ppsbop = 609
                              and h.pptope = vi_top);
      exception
        when others then
          vi_plazo_609 := 0;
      end;
      VE_RPTA_DESACTIVA_REG := 'N';
      PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VI_NRO,
                                                   ve_instancia,
                                                   'PLAZO_PRESETEO',
                                                   VE_RPTA_DESACTIVA_REG);
      vo_excepcion := 'N';
      PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                          VE_INSTANCIA,
                                                          'PLAZO_PRESETEO',
                                                          vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG( -- ecollado 26/08/2022
                                                 VI_NRO,
                                                 'PLAZO_609', --variable
                                                 TO_CHAR(vi_plazo_609), --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG( --ecollado 26/08/2022
                                                 VI_NRO,
                                                 'PLAZO_PRESETEO', --variable
                                                 TO_CHAR(vi_plazo_preseteo), --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
    
      IF (vi_plazo_609 > vi_plazo_preseteo) and vo_excepcion <> 'S' AND
         VE_RPTA_DESACTIVA_REG <> 'S' THEN
        Dbms_Output.put_line(ve_mensaje);
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          ve_mensaje := ve_mensaje ||
                        ';RSC: No se cumple periodo máximo entre fecha valor y fecha de primer pago';
        else
          ve_mensaje := 'RSC: No se cumple periodo máximo entre fecha valor y fecha de primer pago';
        end if;
        --RETURN;  --DESCOMENTAR 19092021
        --VE_MENSAJE:= '';
      ELSE
        NULL;
      END IF;
    END;
  
    BEGIN
    
      pq_cr_validar_rng_reprog.SP_VALIDAR_REPROGRAMADO_GRUPO_NF(ve_instancia,
                                                                vo_grupo_nf);
    END;
    IF VI_TIPO_REPROGRAMACION = 'J' OR vo_grupo_nf = 'S' THEN
      PQ_CR_VALIDAR_RNG_REPROG.SP_VALIDAR_REGLAS_CAJA_SOLJ(ve_instancia,
                                                           vi_nro,
                                                           'N',
                                                           '',
                                                           VI_TIPO_REPROGRAMACION,
                                                           vi_mensaje_SOLJUNTOS);
      IF LENGTH(TRIM(vi_mensaje_SOLJUNTOS)) > 0 and
         LENGTH(TRIM(vi_mensaje_SOLJUNTOS)) < 300 THEN
        if ve_mensaje is null then
          ve_mensaje := vi_mensaje_SOLJUNTOS;
        else
          ve_mensaje := ve_mensaje || ';' || vi_mensaje_SOLJUNTOS;
        end if;
      ELSE
        IF LENGTH(trim(ve_mensaje)) = 0 OR ve_mensaje is NULL then
          ve_mensaje := TRIM(vi_mensaje_SOLJUNTOS);
          --NULL;
        end if;
      END IF;
    END IF;
  END;

  PROCEDURE SP_OBTENER_PERIODO(ve_instancia number, ve_rpta out number) IS
    VI_PGCOD     XWF700.XWFEMPRESA%TYPE;
    VI_SUC       XWF700.XWFSUCURSAL%TYPE;
    VI_MOD       XWF700.XWFMODULO%TYPE;
    VI_MDA       XWF700.XWFMONEDA%TYPE;
    VI_PAP       XWF700.XWFPAPEL%TYPE;
    VI_CTA       XWF700.XWFCUENTA%TYPE;
    VI_OPE       XWF700.XWFOPERACION%TYPE;
    VI_SBO       XWF700.XWFSUBOPE%TYPE;
    VI_TOP       XWF700.XWFTIPOPE%TYPE;
    VI_FECHA_MIN DATE;
    VI_RPTA      NUMBER;
    CURSOR LISTA(VI_FECHA DATE) IS
      SELECT *
        FROM FSD601 D
       WHERE D.PGCOD = VI_PGCOD
         AND D.PPMOD = VI_MOD
         AND D.PPSUC = VI_SUC
         AND D.PPMDA = VI_MDA
         AND D.PPPAP = VI_PAP
         AND D.PPCTA = VI_CTA
         AND D.PPOPER = VI_OPE
         AND D.PPSBOP = 609
         AND D.PPTOPE = VI_TOP
         AND D.PPFPAG > VI_FECHA;
  BEGIN
    -----OBTENER CLAVE DEL CREDITO
    BEGIN
      SELECT XWFEMPRESA,
             XWFSUCURSAL,
             XWFMODULO,
             XWFMONEDA,
             XWFPAPEL,
             XWFCUENTA,
             XWFOPERACION,
             XWFSUBOPE,
             XWFTIPOPE
        INTO VI_PGCOD,
             VI_SUC,
             VI_MOD,
             VI_MDA,
             VI_PAP,
             VI_CTA,
             VI_OPE,
             VI_SBO,
             VI_TOP
        FROM XWF700 X
       WHERE X.XWFPRCINS = ve_instancia
         AND X.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    --OBTENER PERIODO
    BEGIN
      SELECT y.xllperiodo --periodo en dias
        INTO ve_rpta
        FROM x054023 y
       where y.xllpgcod = vi_pgcod
         and y.xllaomod = vi_mod
         and y.xllaosuc = vi_suc
         and y.xllaomda = vi_mda
         and y.xllaopap = vi_pap
         and y.xllaocta = vi_cta
         and y.xllaooper = vi_ope
         and y.xllaosbop = 609 --CRONOGRAMA PROPUESTO
         and y.xllaotop = vi_top;
    exception
      when others then
        null;
    END;
    /*
    --OBTENER FECHA DE LA PRIMERA CUOTA PROPUESTA
    BEGIN
      SELECT MIN(PPFPAG)
       INTO VI_FECHA_MIN
      FROM FSD601 D
      WHERE  D.PGCOD = VI_PGCOD
        AND  D.PPMOD = VI_MOD
        AND  D.PPSUC = VI_SUC
        AND  D.PPMDA = VI_MDA
        AND  D.PPPAP = VI_PAP
        AND  D.PPCTA = VI_CTA
        AND  D.PPOPER= VI_OPE
        AND  D.PPSBOP= 609
        AND  D.PPTOPE= VI_TOP;
    END;
    BEGIN
        FOR X IN LISTA(VI_FECHA_MIN) LOOP
            IF X.PPPZO>= 59 AND X.PPPZO<=61 THEN
               VI_RPTA:=60;
            ELSE
               VI_RPTA:=0; VE_RPTA:=0; EXIT;
            END IF ;
        END LOOP;
        VE_RPTA := VI_RPTA;
      END;
      */
  END;
  PROCEDURE SP_OBTENER_LIM_VAR(VE_VARIABLE IN VARCHAR, VO_RPTA OUT VARCHAR) IS
  BEGIN
    BEGIN
      select TP1NRO1
        into vo_rpta
        from fst198
       where tp1cod1 = 10899
         and tp1corr1 = 400000
         and tp1corr2 = 50
         AND tp1desc = rpad(ve_variable, 30, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;
  PROCEDURE SP_OBTENER_EXCEPCION_REGLA(VI_NRO       NUMBER,
                                       VE_INSTANCIA IN NUMBER,
                                       VE_VARIABLE  IN VARCHAR,
                                       VO_RPTA      OUT VARCHAR) IS
    VI_CORRELATIVO  NUMBER;
    VI_CONTADOR     NUMBER;
    FECHA_SISTEMA   DATE;
    FECHA_EXCEPCION DATE;
  BEGIN
  
    BEGIN
      SELECT TP1CORR2
        INTO VI_CORRELATIVO
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 10899
         AND TP1CORR1 = 400000
         AND TP1CORR2 > 99
         AND TP1CORR2 < 201
         AND TP1CORR3 = 0
         AND TP1DESC = RPAD(VE_VARIABLE, 30, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        VI_CORRELATIVO := 0;
    END;
    IF VI_CORRELATIVO > 0 THEN
      BEGIN
        SELECT COUNT(*)
          INTO VI_CONTADOR
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 10899
           AND TP1CORR1 = 400000
           AND TP1CORR2 = VI_CORRELATIVO
           AND TP1CORR3 > 0
           AND TP1NRO1 = VE_INSTANCIA;
      
      EXCEPTION
        WHEN OTHERS THEN
          VI_CONTADOR := 0;
      END;
    END IF;
    IF VI_CONTADOR > 0 THEN
      BEGIN
        SELECT PGFAPE INTO FECHA_SISTEMA FROM FST017 WHERE PGCOD = 1;
        SELECT TO_DATE(TP1DESC, 'dd/mm/yyyy')
          INTO FECHA_EXCEPCION
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 10899
           AND TP1CORR1 = 400000
           AND TP1CORR2 = VI_CORRELATIVO
           AND TP1CORR3 = (SELECT MAX(TP1CORR3)
                             FROM FST198
                            WHERE TP1COD = 1
                              AND TP1COD1 = 10899
                              AND TP1CORR1 = 400000
                              AND TP1CORR2 = VI_CORRELATIVO
                              AND TP1CORR3 > 0
                              AND TP1NRO1 = VE_INSTANCIA) --INSTANCIA
           AND TP1NRO1 = VE_INSTANCIA;
      EXCEPTION
        WHEN OTHERS THEN
          FECHA_EXCEPCION := to_date('01/01/2020', 'dd/mm/yyyy');
      END;
      IF to_date(FECHA_EXCEPCION, 'dd/mm/yyyy') >=
         to_date(FECHA_SISTEMA, 'dd/mm/yyyy') THEN
        --18.05.2022 - CAMBIOS EN LA VALIDACION DE LA EXCEPCION, SE AGREGO TO_DATE HSUAREZ
        VO_RPTA := 'S';
      ELSE
        VO_RPTA := 'N';
      END IF;
    
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'INSTANCIA_EXCEPTUADA', --variable
                                                 VE_VARIABLE, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
    ELSE
      VO_RPTA := 'N';
    END IF;
  END;
  PROCEDURE SP_DESACTIVAR_REGLA(VI_NRO       NUMBER,
                                VE_INSTANCIA NUMBER,
                                VE_VARIABLE  IN VARCHAR,
                                VO_RPTA      OUT VARCHAR) IS
    VI_CORRELATIVO NUMBER;
    VI_CONTADOR    NUMBER;
  BEGIN
    BEGIN
      SELECT TP1NRO1
        INTO VI_CONTADOR
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 10899
         AND TP1CORR1 = 400000
         AND TP1CORR2 = 16
         AND TP1CORR3 > 0
         AND TP1NRO1 = 1 --20.09.2021
         AND TP1DESC = RPAD(VE_VARIABLE, 30, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        VI_CORRELATIVO := 0;
    END;
  
    IF VI_CONTADOR > 0 THEN
      VO_RPTA := 'S';
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                                 'REGLA_DESACTIVADA', --variable
                                                 VE_VARIABLE, --valor
                                                 91, --regla
                                                 ve_instancia --instancia
                                                 );
    ELSE
      VO_RPTA := 'N';
    END IF;
  
  END;
  PROCEDURE SP_CONTROL_EXONERACION(VE_INSTANCIA NUMBER,
                                   VE_RPTAC     OUT VARCHAR) IS
  
    VI_PGCOD      XWF700.XWFEMPRESA%TYPE;
    VI_SUC        XWF700.XWFSUCURSAL%TYPE;
    VI_MOD        XWF700.XWFMODULO%TYPE;
    VI_MDA        XWF700.XWFMONEDA%TYPE;
    VI_PAP        XWF700.XWFPAPEL%TYPE;
    VI_CTA        XWF700.XWFCUENTA%TYPE;
    VI_OPE        XWF700.XWFOPERACION%TYPE;
    VI_SBO        XWF700.XWFSUBOPE%TYPE;
    VI_TOP        XWF700.XWFTIPOPE%TYPE;
    VI_MTO_AJUSTE NUMBER(17, 2);
    VI_TIPO       NUMBER(10);
  BEGIN
    -----OBTENER CLAVE DEL CREDITO
    BEGIN
      SELECT XWFEMPRESA,
             XWFSUCURSAL,
             XWFMODULO,
             XWFMONEDA,
             XWFPAPEL,
             XWFCUENTA,
             XWFOPERACION,
             XWFSUBOPE,
             XWFTIPOPE
        INTO VI_PGCOD,
             VI_SUC,
             VI_MOD,
             VI_MDA,
             VI_PAP,
             VI_CTA,
             VI_OPE,
             VI_SBO,
             VI_TOP
        FROM XWF700 X
       WHERE X.XWFPRCINS = ve_instancia
         AND X.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    VE_RPTAC := 'N';
    BEGIN
      PQ_CR_REPROGRAMAEXO.sp_esexonerado(VI_PGCOD,
                                         VI_MOD,
                                         VI_SUC,
                                         VI_MDA,
                                         VI_PAP,
                                         VI_CTA,
                                         VI_OPE,
                                         VI_SBO,
                                         VI_TOP,
                                         VI_MTO_AJUSTE,
                                         VI_TIPO);
    
      IF VI_TIPO = 1 THEN
        pq_cr_reprogramaexo.sp_MONTOEXO_ESMAYOR(VI_PGCOD,
                                                VI_MOD,
                                                VI_SUC,
                                                VI_MDA,
                                                VI_PAP,
                                                VI_CTA,
                                                VI_OPE,
                                                VI_SBO,
                                                VI_TOP,
                                                VE_RPTAC);
      END IF;
    END;
  END;

  PROCEDURE SP_GRABAR_LOG_DE_RNG(
                                 --VE_NRO NUMBER, --CORRELATIVO
                                 ve_variable  varchar, -- VARIABLE (máximo 30)
                                 ve_valor     varchar, -- VALOR (máximo 30)
                                 ve_regla     number, -- REGLA
                                 ve_flujo     varchar, -- FLUJO
                                 ve_usuario   varchar, -- USUARIO
                                 ve_sucursal  number, -- SUCURSAL
                                 ve_instancia number --INSTANCIA
                                 ) IS
    VI_NRO   NUMBER(10);
    VI_FECHA DATE;
    VI_HORA  CHAR(8);
  BEGIN
    --OBTENER CORRELATIVO
    VI_NRO := 0;
    BEGIN
      SELECT NVL(MAX(AQPB582NRO), 0) INTO VI_NRO FROM AQPB582;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        VI_NRO := 1;
    END;
    VI_NRO := VI_NRO + 1;
  
    --INSERTAR LOG DE VARIABLE
    PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VI_NRO,
                                               ve_variable, --variable
                                               ve_valor, --valor
                                               ve_regla, --regla
                                               ve_instancia --instancia
                                               );
  END;

  PROCEDURE SP_VALIDAR_REPROGRAMADO_GRUPO_NF(ve_instancia number,
                                             vo_rpta      out varchar) IS
    --
    VI_PGCOD XWF700.XWFEMPRESA%TYPE;
    VI_SUC   XWF700.XWFSUCURSAL%TYPE;
    VI_MOD   XWF700.XWFMODULO%TYPE;
    VI_MDA   XWF700.XWFMONEDA%TYPE;
    VI_PAP   XWF700.XWFPAPEL%TYPE;
    VI_CTA   XWF700.XWFCUENTA%TYPE;
    VI_OPE   XWF700.XWFOPERACION%TYPE;
    VI_SBO   XWF700.XWFSUBOPE%TYPE;
    VI_TOP   XWF700.XWFTIPOPE%TYPE;
  
    vi_indicador  VARCHAR(3);
    vi_dnicliente VARCHAR(12);
    vi_grupo      NUMBER;
    vi_califica   VARCHAR(2);
  
  BEGIN
  
    ----- -----
    --OBTENER LA CLAVE DEL CREDITO
    BEGIN
      SELECT XWFEMPRESA,
             XWFSUCURSAL,
             XWFMODULO,
             XWFMONEDA,
             XWFPAPEL,
             XWFCUENTA,
             XWFOPERACION,
             XWFSUBOPE,
             XWFTIPOPE
        INTO VI_PGCOD,
             VI_SUC,
             VI_MOD,
             VI_MDA,
             VI_PAP,
             VI_CTA,
             VI_OPE,
             VI_SBO,
             VI_TOP
        FROM XWF700 X
       WHERE X.XWFPRCINS = ve_instancia
         AND X.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --OBTENER EL DNI DEL DE LEY31050.
    begin
      SELECT 'J', l.dnicliente
        into vi_indicador, vi_dnicliente
        FROM /*usrwebcrm.*/ LEY31050 L
       INNER JOIN /*usrwebcrm.*/
      LEY31050_CREDITOSFACILIDAD F
          ON L.IDLEY31050 = F.IDLEY31050
       WHERE L.ESTADOSOLICITUD = 'BT'
         AND L.TIPOFACILIDAD = 'CAJA'
            --AND UPPER(F.FACILIDAD) like '%JUNTOS%'
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             VI_CTA
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = VI_OPE
         AND F.EMPRESA = VI_PGCOD
         AND F.SUCURSAL = VI_SUC
         AND F.MODULO = VI_MOD
         AND F.MONEDA = VI_MDA
         AND F.PAPEL = VI_PAP
         AND F.SUBOPERACION = VI_SBO
         AND F.TIPOOPERACION = VI_TOP;
    exception
      when others then
        vi_indicador := 'N';
    end; ---20211028 dcastro
    --BUSCAR EL GRUPO Y SI ESTA HABILITADO
    BEGIN
      SELECT FO.GRUPO_REPROG, FO.CALIFICA_SJ
        INTO vi_grupo, vi_califica
        FROM LEY31050_FORM_DATA FO
       WHERE FO.DNICLIENTE = VI_DNICLIENTE;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --SI CUMPLE TODO DEVOLVER, S CASO CONTRARIO DEVOLVER N
    ----- -----
    IF vi_grupo <= 5 AND TRIM(vi_califica) = 'SI' THEN
      vo_rpta := 'S';
    ELSE
      vo_rpta := 'N'; --
    END IF;
  END;

  PROCEDURE SP_OBTENER_DIF_FECVENC(VE_INSTANCIA NUMBER, VO_DIAS OUT NUMBER) IS
    ln_cont   number;
    ld_fec    date;
    ld_newfec date;
    ln_dias   number;
    pn_emp    number;
    pn_suc    number;
    pn_mod    number;
    pn_mda    number;
    pn_pap    number;
    pn_cta    number;
    pn_ope    number;
    pn_sbo    number;
    pn_top    number;
  
  BEGIN
    begin
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into pn_emp,
             pn_suc,
             pn_mod,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top
        from xwf700 x
       where x.xwfprcins = VE_INSTANCIA
         and x.xwfcar3 = '1'
         and rownum = 1;
    exception
      when others then
        pn_cta := null;
    end;
  
    if pn_cta is not null then
    
      begin
        select F.AOFVTO
          into ld_fec
          from fsd010 f
         where f.pgcod = pn_emp
           and f.aomod = pn_mod
           and f.aosuc = pn_suc
           and f.aomda = pn_mda
           and f.aopap = pn_pap
           and f.aocta = pn_cta
           and f.aooper = pn_ope
           and f.aosbop = pn_sbo
           and f.aotope = pn_top;
      exception
        when others then
          ld_fec := null;
      end;
    
      begin
        select max(f.ppfpag)
          into ld_newfec
          from fsd601 f
         where f.pgcod = pn_emp
           and f.ppmod = pn_mod
           and f.ppsuc = pn_suc
           and f.ppmda = pn_mda
           and f.pppap = pn_pap
           and f.ppcta = pn_cta
           and f.ppoper = pn_ope
           and f.ppsbop = 609
           and f.pptope = pn_top;
      exception
        when others then
          ld_newfec := null;
      end;
      BEGIN
        select MONTHS_BETWEEN(ld_newfec, ld_fec) into VO_DIAS from dual;
      exception
        when others then
          VO_DIAS := 3;
      END;
    END IF;
  END;

  PROCEDURE SP_CONTROLAR_COMENTARIOS(ve_instancia number,
                                     ve_rpta      out varchar2) IS
    VI_JAQA400AEC VARCHAR2(2000);
    VI_JAQA400DCR VARCHAR2(2000);
    VI_JAQA400VPG VARCHAR2(2000);
  
  BEGIN
    BEGIN
      SELECT JAQA400AEC, JAQA400DCR, JAQA400VPG
        into VI_JAQA400AEC, VI_JAQA400DCR, VI_JAQA400VPG
        FROM JAQA400
       WHERE JAQA400AI1 = ve_instancia
         and JAQA400FEC = (select max(jaqa400fec)
                             FROM JAQA400
                            WHERE jaqa400ai1 = ve_instancia);
    EXCEPTION
      WHEN OTHERS THEN
        VI_JAQA400AEC := '';
        VI_JAQA400DCR := '';
        VI_JAQA400VPG := '';
    END;
    IF LENGTH(TRIM(VI_JAQA400AEC)) > 0 AND LENGTH(TRIM(VI_JAQA400DCR)) > 0 AND
       LENGTH(TRIM(VI_JAQA400VPG)) > 0 THEN
      VE_RPTA := 'S'; -- no mostrar mensae
    ELSE
      VE_RPTA := 'N'; --mostrar mensaje
    END IF;
  
  END SP_CONTROLAR_COMENTARIOS;
  PROCEDURE SP_VALIDAR_REPROG_CRM(ve_instancia number,
                                  ve_rpta      out varchar2) IS
  
    cantidad_total     NUMBER(3) := 0;
    cantidad_LEY31050  NUMBER(3) := 0;
    cantidad_vreprog   NUMBER(3) := 0;
    cantidad_fondos    NUMBER(3) := 0;
    var_suboperacion   NUMBER(4);
    var_tipo_operacion NUMBER(4);
    cuenta_operacion   varchar2(50);
  BEGIN
    ve_rpta := 'N';
    BEGIN
      SELECT xwfcuenta || '-' || xwfoperacion, xwfsubope, xwftipope
        INTO cuenta_operacion, var_suboperacion, var_tipo_operacion
        from xwf700
       where xwfprcins = ve_instancia
         and xwfcar3 = '1';
    exception
      when others then
        null;
    END;
    BEGIN
      SELECT count(*)
        into cantidad_vreprog --Reprogramacion Covid
        from v_reprog
       WHERE estadosolicitud = 'BT'
         and cuentaoperacion = cuenta_operacion;
    EXCEPTION
      WHEN OTHERS THEN
        cantidad_vreprog := 0;
    END;
  
    BEGIN
      SELECT COUNT(*)
        INTO cantidad_LEY31050 --Reprogramacion Caja Gobierno
        from LEY31050_CREDITOSFACILIDAD F
       inner join LEY31050 l
          on l.idley31050 = F.idley31050
       where f.cuentaoperacion = cuenta_operacion
         and estadosolicitud = 'BT'
         and suboperacion = var_suboperacion
         and tipooperacion = var_tipo_operacion;
    EXCEPTION
      WHEN OTHERS THEN
        cantidad_LEY31050 := 0;
    END;
    BEGIN
      SELECT count(*)
        INTO cantidad_fondos --Reprogramacion Fondos
        from fondos_creditosfacilidad c
       inner join fondos f
          on c.idfondo = f.idfondo
         and estadosolicitud = 'BT'
         and cuentaoperacion = cuenta_operacion;
    EXCEPTION
      WHEN OTHERS THEN
        cantidad_fondos := 0;
    END;
    cantidad_total := cantidad_LEY31050 + cantidad_vreprog +
                      cantidad_fondos; --Totales
    IF (cantidad_total > 1) THEN
      ve_rpta := 'S';
    ELSE
      ve_rpta := 'N';
    END IF;
  END SP_VALIDAR_REPROG_CRM;

  -- Author  : IGS_MCHAVEZ
  -- Created : 25/03/2022 21:56:45
  -- Purpose : Validar que no ingresen cuotas 0

  PROCEDURE SP_CR_VALIDAR_CUOTA(INS IN NUMBER, RESP OUT VARCHAR2) AS
    vEMP   XWF700.XWFEMPRESA%TYPE := 0;
    vSUC   XWF700.XWFSUCURSAL%TYPE := 0;
    vMOD   XWF700.XWFMODULO%TYPE := 0;
    vMDA   XWF700.XWFMONEDA%TYPE := 0;
    vPAP   XWF700.XWFPAPEL%TYPE := 0;
    vCTA   XWF700.XWFCUENTA%TYPE := 0;
    vOPE   XWF700.XWFOPERACION%TYPE := 0;
    vSBO   XWF700.XWFSUBOPE%TYPE := 0;
    vTOP   XWF700.XWFTIPOPE%TYPE := 0;
    vIMP10 FSD611.PPIMP10%TYPE := 0;
    vIMP11 FSD611.PPIMP11%TYPE := 0;
    vIMP12 FSD611.PPIMP12%TYPE := 0;
    vIMP13 FSD611.PPIMP13%TYPE := 0;
    vIMP14 FSD611.PPIMP14%TYPE := 0;
    vIMP15 FSD611.PPIMP15%TYPE := 0;
    vIMP16 FSD611.PPIMP16%TYPE := 0;
    vIMP17 FSD611.PPIMP17%TYPE := 0;
    vIMP18 FSD611.PPIMP18%TYPE := 0;
    vIMP19 FSD611.PPIMP19%TYPE := 0;
    vIMP20 FSD611.PPIMP20%TYPE := 0;
    vTOT   NUMBER(17) := 0;
    CURSOR LISTA_FSD601 IS
      SELECT *
        FROM FSD601
       WHERE PGCOD = vEMP
         AND PPMOD = vMOD
         AND PPSUC = vSUC
         AND PPMDA = vMDA
         AND PPPAP = vPAP
         AND PPCTA = vCTA
         AND PPOPER = vOPE
         AND PPSBOP = 609
         AND PPTOPE = vTOP; --AND PPTIPO <> 'K' AND D601CO = 'S';
  BEGIN
    BEGIN
      begin
        SELECT XWFEMPRESA,
               XWFSUCURSAL,
               XWFMODULO,
               XWFMONEDA,
               XWFPAPEL,
               XWFCUENTA,
               XWFOPERACION,
               XWFSUBOPE,
               XWFTIPOPE
          INTO vEMP, vSUC, vMOD, vMDA, vPAP, vCTA, vOPE, vSBO, vTOP
          FROM XWF700
         WHERE XWFPRCINS = INS
           AND XWFCAR3 = '1';
      exception
        when others then
          null;
      end;
    
      FOR X IN LISTA_FSD601 LOOP
        BEGIN
          begin
            SELECT PPIMP10,
                   PPIMP11,
                   PPIMP12,
                   PPIMP13,
                   PPIMP14,
                   PPIMP15,
                   PPIMP16,
                   PPIMP17,
                   PPIMP18,
                   PPIMP19,
                   PPIMP20
              INTO vIMP10,
                   vIMP11,
                   vIMP12,
                   vIMP13,
                   vIMP14,
                   vIMP15,
                   vIMP16,
                   vIMP17,
                   vIMP18,
                   vIMP19,
                   vIMP20
              FROM FSD611
             WHERE PGCOD = X.PGCOD
               AND PPMOD = X.PPMOD
               AND PPSUC = X.PPSUC
               AND PPMDA = X.PPMDA
               AND PPPAP = X.PPPAP
               AND PPCTA = X.PPCTA
               AND PPOPER = X.PPOPER
               AND PPSBOP = X.PPSBOP
               AND PPTOPE = X.PPTOPE
               AND PPFPAG = X.PPFPAG;
          exception
            when others then
              null;
          end;
        
          vTOT := X.PPCAP + X.PPINT + vIMP10 + vIMP11 + vIMP12 + vIMP13 +
                  vIMP14 + vIMP15 + vIMP16 + vIMP17 + vIMP18 + vIMP19 +
                  vIMP20;
          IF vTOT = 0 THEN
            RESP := 'S';
            EXIT;
          ELSE
            RESP := 'N';
          END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            vTOT := X.PPCAP + X.PPINT;
            IF vTOT = 0 THEN
              RESP := 'S';
              EXIT;
            ELSE
              RESP := 'N';
            END IF;
          WHEN OTHERS THEN
            RESP := ' ';
        END;
      END LOOP;
    EXCEPTION
      WHEN OTHERS THEN
        RESP := ' ';
    END;
  END SP_CR_VALIDAR_CUOTA;

  -- DESCOMENTAR PARA REPROGRAMADOS EXCEPCION
  PROCEDURE SP_CARGAR_REGLAS_EXCEPCION(ve_Instancia number,
                                       VI_NRO       number,
                                       VE_USER      varchar) IS
    VE_RPTAC               varchar(3);
    v_tcovid               varchar(1);
    vo_excepcion           varchar(1);
    ve_mensaje             varchar(700);
    ve_usuario             varchar(10);
    ve_variable            varchar(40);
    VI_TIPO_REPROGRAMACION varchar(10);
  
    vi_mod            number(3);
    vi_suc            number(4);
    vi_mda            number(4);
    vi_pap            number(4);
    vi_cta            number(9);
    vi_ope            number(9);
    vi_sbo            number(3);
    vi_top            number(3);
    vi_plazo_preseteo number(5);
    vi_plazo_609      number(5);
  
    vo_grupo_nf varchar2(2);
  BEGIN
    BEGIN
      VE_RPTAC := '';
      v_tcovid := '';
    
      --OBTENER USUARIO
      begin
        select j.jaqa400uss
          into ve_usuario
          from jaqa400 j
         where jaqa400ai1 = ve_instancia
           and rownum = 1
         order by jaqa400fec desc;
        delete from aqpb955 where aqpb955usr = VE_USER; --LIMPIA REGLAS
        commit;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      end;
      ---PRESETEO
      BEGIN
        --validar credito obtener modulo y tipo de operacion
        begin
          select jaqa400suc,
                 jaqa400mod,
                 jaqa400mda,
                 jaqa400pap,
                 jaqa400cta,
                 jaqa400ope,
                 jaqa400sbo,
                 jaqa400top
            into vi_suc,
                 vi_mod,
                 vi_mda,
                 vi_pap,
                 vi_cta,
                 vi_ope,
                 vi_sbo,
                 vi_top
            from jaqa400
           where jaqa400ai1 = ve_instancia
             and jaqa400fec =
                 (select max(jaqa400fec)
                    from jaqa400
                   where jaqa400ai1 = ve_instancia)
             and rownum = 1; --09.05.2022 - MCORDOVA se coloco en rownum.
        exception
          when others then
            null;
        end;
        ---preseteo plazo maximo
        --begin
        --  select xy.pp028defn into vi_plazo_preseteo from fpp028 xy
        --  where xy.pp017par=150 and xy.pp028mod=vi_mod and xy.pp028top=vi_top AND ROWNUM=1;
        --exception
        --  when others then
        --    null;
        -- end;
      
        BEGIN
          SELECT TP1IMP1
            INTO vi_plazo_preseteo
            FROM FST198
           WHERE TP1COD = 1
             AND TP1COD1 = 11161
             AND TP1CORR1 = 1
             AND TP1CORR2 = 0
             AND TP1CORR3 > 0
             AND TP1NRO1 = vi_mod
             AND TP1NRO2 = vi_top;
        EXCEPTION
          WHEN OTHERS THEN
            BEGIN
              SELECT TP1IMP1
                INTO vi_plazo_preseteo
                FROM FST198
               WHERE TP1COD = 1
                 AND TP1COD1 = 11161
                 AND TP1CORR1 = 1
                 AND TP1CORR2 = 0
                 AND TP1CORR3 > 0
                 AND TP1NRO1 = vi_mod
                 AND TP1NRO2 = 0;
            EXCEPTION
              WHEN OTHERS THEN
                vi_plazo_preseteo := 0;
            END;
        END;
      
        begin
          select d.ppfpag - d.ppfval
            into vi_plazo_609
            from fsd601 d
           where pgcod = 1
             and d.ppsuc = vi_suc
             and d.ppmda = vi_mda
             and d.pppap = vi_pap
             and d.ppcta = vi_cta
             and d.ppoper = vi_ope
             and d.ppsbop = 609
             and d.pptope = vi_top
             and d.ppfpag = (select min(ppfpag)
                               from fsd601 h
                              where h.pgcod = 1
                                and h.ppsuc = vi_suc
                                and h.ppmda = vi_mda
                                and h.pppap = vi_pap
                                and h.ppcta = vi_cta
                                and h.ppoper = vi_ope
                                and h.ppsbop = 609
                                and h.pptope = vi_top);
        exception
          when others then
            vi_plazo_609 := 0;
        end;
        vo_excepcion := 'N';
        PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                            VE_INSTANCIA,
                                                            'PLAZO_PRESETEO',
                                                            vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
        IF (vi_plazo_609 > vi_plazo_preseteo) AND vo_excepcion <> 'S' THEN
          ve_mensaje := 'RSC: No se cumple periodo máximo entre fecha Valor y fecha de primer pago';
          Dbms_Output.put_line(ve_mensaje);
          --LISTA  AGREGAR EXCEPCION
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LISTA_EXCEPCION('PLAZO_PRESETEO',
                                                             ve_mensaje,
                                                             91,
                                                             ve_Instancia,
                                                             VE_USER);
        ELSE
          NULL;
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      --REPROGRAMACION COVID
      BEGIN
        --VALIDAR SI EL PLAZO ES MAYOR A 90 DIAS
        pq_cr_funciones_cho.sp_fecha_covid(ve_instancia, ve_rptac);
        --VALIDA SI ES REPROGRAMADO UNILATERAL
        pq_cr_funciones_cho.sp_unilateral(ve_instancia, v_tcovid);
        --VALIDA SI ESTA EXCEPTUADO
        PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                            VE_INSTANCIA,
                                                            'PLAZO_UNILATERAL',
                                                            vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
        IF trim(ve_rptac) = 'S' AND (v_tcovid = 'U' OR V_TCOVID = 'E') AND
           vo_excepcion <> 'S' THEN
          ve_mensaje  := 'RSC: La nueva fecha de vcto. no puede ser mayor a 90 dias de la anterior reprog.';
          ve_variable := 'PLAZO_UNILATERAL';
          --LISTA  AGREGAR EXCEPCION
          PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LISTA_EXCEPCION(ve_variable,
                                                             ve_mensaje,
                                                             91,
                                                             ve_Instancia,
                                                             VE_USER);
        ELSE
          NULL;
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      pq_cr_funciones_cho.sp_indicador_CRM_Caja(ve_instancia, VE_RPTAC);
      VI_TIPO_REPROGRAMACION := VE_RPTAC;
    
      --REPROGRAMACION CAJA
      if VI_TIPO_REPROGRAMACION = 'C' then
        PQ_CR_VALIDAR_RNG_REPROG.SP_VALIDAR_REGLAS_CAJA_RT_EXO_AMO(ve_instancia,
                                                                   0,
                                                                   'S', --ACTIVAR REGLAS
                                                                   ve_user,
                                                                   ve_mensaje);
      end if;
      BEGIN
        pq_cr_validar_rng_reprog.SP_VALIDAR_REPROGRAMADO_GRUPO_NF(ve_instancia,
                                                                  vo_grupo_nf);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      IF VI_TIPO_REPROGRAMACION = 'J' OR vo_grupo_nf = 'S' THEN
        PQ_CR_VALIDAR_RNG_REPROG.SP_VALIDAR_REGLAS_CAJA_SOLJ(ve_instancia,
                                                             0,
                                                             'S',
                                                             ve_user,
                                                             VI_TIPO_REPROGRAMACION,
                                                             ve_mensaje);
      END IF;
      --REPROGRAMACION GOBIERNO    
      /*
      BEGIN
        NULL;
      END;
      */
    END;
  END;

  PROCEDURE SP_GRABAR_LISTA_EXCEPCION(ve_variable  varchar, --VARIABLE
                                      ve_mensaje   varchar, --VALOR
                                      ve_regla     number, --REGLA
                                      ve_instancia number, --INSTANCIA
                                      ve_usuario   varchar --USUARIO
                                      ) IS
  BEGIN
    BEGIN
      INSERT INTO aqpb955
        (aqpb955cod, aqpb955reg, aqpb955des, aqpb955usr)
      VALUES
        (VE_INSTANCIA, VE_VARIABLE, ve_mensaje, ve_usuario);
      COMMIT;
    END;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE SP_SAVE_EXCEPCION_HS(ve_codigo      number,
                                 ve_estado      varchar,
                                 ve_autorizador varchar,
                                 vo_coderror    out number,
                                 vo_msgerror    out varchar) AS
    ve_rpta    VARCHAR(1);
    P_C_ESX_1  VARCHAR2(1);
    P_C_EXISTE VARCHAR(1);
  
  BEGIN
    vo_coderror := 1;
    vo_msgerror := 'ERROR NO SE ENCONTRÓ EL CRÉDITO';
    -- VALIDA EXISTENCIA DE INSTANCIA
    BEGIN
      SELECT 'S' INTO P_C_EXISTE FROM AQPC202 WHERE AQPC202COR = ve_codigo;
    EXCEPTION
      WHEN OTHERS THEN
        P_C_EXISTE  := 'N';
        vo_coderror := 2;
        vo_msgerror := 'NO SE ENCONTRO LA INSTANCIA PARA EL Nro. de SOLICITUD ' ||
                       VE_CODIGO || ' SOLICITADO';
    END;
    BEGIN
      IF P_C_EXISTE = 'S' THEN
        -- PROCESO PARA ACTUALIZAR TABLAS
        BEGIN
          IF ve_estado = 'Autorizado' THEN
            P_C_ESX_1 := 'A';
          ELSIF ve_estado = 'Rechazado' THEN
            P_C_ESX_1 := 'R';
          END IF;
        END;
        UPDATE AQPC203
           SET AQPC203ESX = P_C_ESX_1,
               AQPC203FEX = TO_DATE(SYSDATE, 'dd/mm/RRRR'),
               AQPC203HEX = TO_CHAR(SYSDATE, 'HH24:MI:SS')
         WHERE AQPC203COR = ve_codigo
           and trim(AQPC203UEX) = trim(ve_autorizador); --cambio 18.05.2022 HSUAREZ
        IF SQL%NOTFOUND THEN
          vo_coderror := 3;
          vo_msgerror := 'NO SE ENCONTRO CREDITO A ACTUALIZAR';
        ELSE
          -- PROCESO PARA ACTIVAR EXCEPCIÓN
          IF P_C_ESX_1 = 'A' THEN
            PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVA_REGLA_AUTM(ve_codigo,
                                                             ve_estado,
                                                             ve_autorizador,
                                                             ve_rpta,
                                                             vo_coderror,
                                                             vo_msgerror);
            IF ve_rpta = 'S' THEN
              vo_coderror := 0;
              vo_msgerror := 'REGISTRO GESTIONADO COMO: ' ||
                             UPPER(ve_estado);
            END IF;
          ELSE
            vo_coderror := 0;
            vo_msgerror := '';
          END IF;
        END IF;
        COMMIT;
      END IF;
    END;
  EXCEPTION
    WHEN OTHERS THEN
      vo_coderror := 8;
      vo_msgerror := 'ERROR, VERIFIQUE LOS DATOS';
  END;

  PROCEDURE SP_OBTENER_AUTOR_EXCEP(ve_analista    varchar, -- V(10)
                                   ve_instancia   number, --N(10)
                                   ve_saldocap    number, --N(17,2)
                                   vo_autorizador out varchar, --V(10)
                                   vo_coderror    out number, --N(3)
                                   vo_msgerror    out varchar --V(250)
                                   ) IS
  BEGIN
    begin
      SELECT trim(tp1desc)
        INTO vo_autorizador
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 10899
         AND TP1CORR1 = 3100
         AND TP1CORR2 = 1
         AND TP1CORR3 = 1
         AND TP1NRO1 = 1; --habilitado
    Exception
      when others then
        null;
    end;
  END;

  PROCEDURE SP_DESACTIVA_REGLA_AUTM(VE_CODIGO      NUMBER,
                                    VE_ESTADO      VARCHAR,
                                    VE_AUTORIZADOR VARCHAR,
                                    ve_rpta        OUT VARCHAR,
                                    VO_CODERROR    OUT NUMBER,
                                    VO_MSGERROR    OUT VARCHAR) IS
    CURSOR LISTA_VARIABLES_EXCEPTUADAS(VE_CODIGO      NUMBER,
                                       VE_AUTORIZADOR VARCHAR) IS
      SELECT A.AQPC203COR,
             A.AQPC203VRE VI_VARIABLE,
             A.AQPC203DRE,
             A.AQPC203EST,
             A.AQPC203ESX,
             A.AQPC203UEX
        FROM AQPC203 A
       WHERE TRIM(A.AQPC203UEX) = TRIM(VE_AUTORIZADOR)
         AND A.AQPC203COR = VE_CODIGO
         AND A.AQPC203ESX = 'A'; --18.02.2022 - TRIM HSUAREZ
  
    VI_INSTANCIA NUMBER(10);
    VO_RPTA      VARCHAR(1);
    VI_FECHA     DATE;
  BEGIN
    --OBTENER INSTANCIA
    BEGIN
      SELECT AQPC202INS, (AQPC202FEA + 1)
        INTO VI_INSTANCIA, VI_FECHA
        FROM AQPC202
       WHERE AQPC202COR = VE_CODIGO;
    exception
      when others then
        null;
    END;
    --RECORRER VARIABLES EXCEPTUADAS
    ve_rpta := 'S';
    FOR X IN LISTA_VARIABLES_EXCEPTUADAS(VE_CODIGO, VE_AUTORIZADOR) LOOP
      PQ_CR_VALIDAR_RNG_REPROG.SP_EXCEPTUAR_REGLA_VAR(VI_INSTANCIA,
                                                      VI_FECHA,
                                                      X.VI_VARIABLE,
                                                      VO_RPTA);
      IF VO_RPTA <> 'S' THEN
        VO_CODERROR := 4;
        VO_MSGERROR := 'NO SE PUDIERON EXCEPCIONAR TODAS LAS REGLAS DE CONTROL';
        ve_rpta     := 'N';
      END IF;
    END LOOP;
  END;
  PROCEDURE SP_EXCEPTUAR_REGLA_VAR(VE_INSTANCIA NUMBER,
                                   VE_FECHA     DATE,
                                   VE_VARIABLE  VARCHAR,
                                   VO_RPTA      OUT VARCHAR) IS
    VI_CORRELATIVO  NUMBER(9);
    VI_CONTADOR     NUMBER(9);
    VI_CONTADOR_REG NUMBER(9);
    VE_FECHAC       VARCHAR2(10);
  BEGIN
    BEGIN
      SELECT TP1CORR2
        INTO VI_CORRELATIVO
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 10899
         AND TP1CORR1 = 400000
         AND TP1CORR2 > 99
         AND TP1CORR2 < 201
         AND TP1CORR3 = 0
         AND TP1DESC = RPAD(VE_VARIABLE, 30, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        VI_CORRELATIVO := 0;
    END;
    IF VI_CORRELATIVO > 0 THEN
      BEGIN
        SELECT COUNT(*)
          INTO VI_CONTADOR
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 10899
           AND TP1CORR1 = 400000
           AND TP1CORR2 = VI_CORRELATIVO
           AND TP1CORR3 > 0
           AND TP1NRO1 = VE_INSTANCIA;
      EXCEPTION
        WHEN OTHERS THEN
          VI_CONTADOR := 0;
        
      END;
      IF VI_CONTADOR = 0 THEN
        BEGIN
          SELECT NVL(max(tp1corr3), 0)
            INTO VI_CONTADOR_REG
            FROM FST198
           WHERE TP1COD = 1
             AND TP1COD1 = 10899
             AND TP1CORR1 = 400000
             AND TP1CORR2 = VI_CORRELATIVO
             AND TP1CORR3 > 0;
        EXCEPTION
          WHEN OTHERS THEN
            VI_CONTADOR := 0;
        END;
      END IF;
      --AGREGAR EXCEPCION
      BEGIN
        VE_FECHAC := TO_CHAR(VE_FECHA, 'DD/MM/RRRR');
        if VI_CONTADOR_REG >= 1 OR VI_CONTADOR = 0 THEN
          insert into FST198
            (TP1COD,
             TP1COD1,
             TP1CORR1,
             TP1CORR2,
             TP1CORR3,
             TP1NRO1,
             TP1NRO2,
             TP1NRO3,
             TP1DESC,
             TP1IMP1,
             TP1IMP2,
             TP1IMP3)
          values
            (1,
             10899,
             400000,
             VI_CORRELATIVO,
             (VI_CONTADOR_REG + 1),
             VE_INSTANCIA,
             null,
             null,
             VE_FECHAC,
             null,
             null,
             null);
        else
          UPDATE FST198
             SET TP1DESC = TO_CHAR(VE_FECHA, 'DD/MM/RRRR')
           where tp1cod = 1
             and tp1cod1 = 10899
             and tp1corr1 = 400000
             and tp1corr2 = VI_CORRELATIVO
             and tp1nro1 = VE_INSTANCIA;
        end if;
        COMMIT;
      
        VO_RPTA := 'S';
      EXCEPTION
        WHEN OTHERS THEN
          VO_RPTA := 'N';
      END;
      --INSERT INTO AQPC205(N1,D1,C1,C2) VALUES(VE_INSTANCIA,VE_FECHA,VE_VARIABLE,VO_RPTA);
      --COMMIT;
    END IF;
  END;

  PROCEDURE SP_OBTENER_PRESETEO(VE_INSTANCIA  IN NUMBER,
                                VI_PLAZO_GUIA OUT NUMBER,
                                VI_PLAZO_609  OUT NUMBER,
                                VO_EXCEPCION  OUT VARCHAR) IS
  
    vi_mod NUMBER(9);
    vi_suc NUMBER(9);
    vi_mda NUMBER(9);
    vi_pap NUMBER(9);
    vi_cta NUMBER(9);
    vi_ope NUMBER(9);
    vi_top NUMBER(9);
    VI_NRO NUMBER(9);
  BEGIN
    BEGIN
      SELECT jaqa400mod,
             jaqa400suc,
             jaqa400mda,
             jaqa400pap,
             jaqa400cta,
             jaqa400ope,
             jaqa400top
        INTO vi_mod, vi_suc, vi_mda, vi_pap, vi_cta, vi_ope, vi_top
        from jaqa400
       where jaqa400ai1 = VE_INSTANCIA
         and jaqa400fec = (select max(jaqa400fec)
                             from jaqa400
                            where jaqa400ai1 = VE_INSTANCIA);
    
      SELECT TP1IMP1
        INTO VI_PLAZO_GUIA
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11161
         AND TP1CORR1 = 1
         AND TP1CORR2 = 0
         AND TP1CORR3 > 0
         AND TP1NRO1 = vi_mod
         AND TP1NRO2 = vi_top;
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          SELECT TP1IMP1
            INTO VI_PLAZO_GUIA
            FROM FST198
           WHERE TP1COD = 1
             AND TP1COD1 = 11161
             AND TP1CORR1 = 1
             AND TP1CORR2 = 0
             AND TP1CORR3 > 0
             AND TP1NRO1 = vi_mod
             AND TP1NRO2 = 0;
        EXCEPTION
          WHEN OTHERS THEN
            VI_PLAZO_GUIA := 0;
        END;
    END;
  
    ---preseteo plazo maximo
    /*
    begin
      select xy.pp028defn into vi_plazo_preseteo from fpp028 xy
      where xy.pp017par=150 and xy.pp028mod=vi_mod and xy.pp028top=vi_top AND ROWNUM=1;
    
    
    exception
      when others then
        null;
    end; */
    --validar plazo del credito fecha valor y fecha primer pago
    /*
    begin
      select max(ppfpag)
      into vi_fecha_pago
      from fsd602 where pgcod = 1 and ppsuc = vi_suc and ppmda = vi_mda and pppap = vi_pap and ppcta= vi_cta and ppoper = vi_ope and ppsbop=vi_sbo and pptope = vi_top and pp1stat='T' and d602co='S';
    exception
      when others then
        vi_fecha_pago := '01/01/2000';
    end;
    */
    begin
      select d.ppfpag - d.ppfval
        into vi_plazo_609
        from fsd601 d
       where pgcod = 1
         and d.ppsuc = vi_suc
         and d.ppmda = vi_mda
         and d.pppap = vi_pap
         and d.ppcta = vi_cta
         and d.ppoper = vi_ope
         and d.ppsbop = 609
         and d.pptope = vi_top
         and d.ppfpag = (select min(ppfpag)
                           from fsd601 h
                          where h.pgcod = 1
                            and h.ppsuc = vi_suc
                            and h.ppmda = vi_mda
                            and h.pppap = vi_pap
                            and h.ppcta = vi_cta
                            and h.ppoper = vi_ope
                            and h.ppsbop = 609
                            and h.pptope = vi_top);
    exception
      when others then
        vi_plazo_609 := 0;
    end;
    vo_excepcion := 'N';
    PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VI_NRO,
                                                        VE_INSTANCIA,
                                                        'PLAZO_PRESETEO',
                                                        vo_excepcion); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
    -- IF (vi_plazo_609 > vi_plazo_preseteo) and vo_excepcion <> 'S'  THEN
    -- Dbms_Output.put_line(ve_mensaje);
    -- IF LENGTH(TRIM(VE_MENSAJE))> 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
    --   ve_mensaje:= ve_mensaje || ';RSC: Plazo de la Fecha Valor mayor al establecido';
    --else
    --  ve_mensaje:='RSC: Plazo de la Fecha Valor mayor al establecido';
    --end if;
    --RETURN;  --DESCOMENTAR 19092021
    --VE_MENSAJE:= '';
    -- ELSE
    --   NULL;
    --END IF;
  
    /*BEGIN
       VI_PLAZO_PRESETEO := 1;
       VI_PLAZO_609 := 1;
       VI_EXCEPCION := 'p_BEGI';
    
    EXCEPTION
       WHEN OTHERS THEN
         VI_PLAZO_PRESETEO := 0;
         VI_PLAZO_609 := 0;
         VI_EXCEPCION := 'EXCEPCION';*/
  
  END;

  PROCEDURE SP_OBTENER_PLAZO_RESIDUAL(ve_instancia in int,
                                      vi_plzo_res  out number) IS
  
    vi_pgcod  xwf700.xwfempresa%type;
    vi_aomod  xwf700.xwfmodulo%type;
    vi_aosuc  xwf700.xwfsucursal%type;
    vi_aomda  xwf700.xwfmoneda%type;
    vi_aopap  xwf700.xwfpapel%type;
    vi_aocta  xwf700.xwfcuenta%type;
    vi_aooper xwf700.xwfoperacion%type;
    vi_aosbop xwf700.xwfsubope%type;
    vi_aotope xwf700.xwftipope%type;
  
    vi_fecpagmax date;
    vi_fecactual date;
    --vi_plzo_res number(4);
    vi_scsdo     number(17, 2);
    FEC_PAGO     DATE;
    FLAG_PAGOS   varchar2(1);
    vi_fecpagmin date;
  
  BEGIN
    BEGIN
      select xwfempresa,
             xwfmodulo,
             xwfsucursal,
             xwfmoneda,
             xwfpapel,
             xwfcuenta,
             xwfoperacion,
             xwfsubope,
             xwftipope
        into vi_pgcod,
             vi_aomod,
             vi_aosuc,
             vi_aomda,
             vi_aopap,
             vi_aocta,
             vi_aooper,
             vi_aosbop,
             vi_aotope
        from xwf700
       where xwfprcins = ve_instancia
         and xwfcar3 = '1';
    exception
      when others then
        null;
    END;
    begin
      SELECT MAX(D.PPFPAG)
        INTO vi_fecpagmax
        FROM FSD601 D
       WHERE D.PGCOD = vi_pgcod
         AND D.PPMOD = vi_aomod
         AND D.PPSUC = vi_aosuc
         AND D.PPMDA = vi_aomda
         AND D.PPPAP = vi_aopap
         AND D.PPCTA = vi_aocta
         AND D.PPOPER = vi_aooper
         AND D.PPSBOP = vi_aosbop
         AND D.PPTOPE = vi_aotope;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    end;
    --Cuantas cuotas faltan pagar
    FLAG_PAGOS := 'S';
    BEGIN
      SELECT MAX(D.PPFPAG), 'N'
        INTO FEC_PAGO, FLAG_PAGOS
        FROM FSD601 D, FSD602 D2
       WHERE D.PGCOD = vi_pgcod
         AND D.PPMOD = vi_aomod
         AND D.PPSUC = vi_aosuc
         AND D.PPMDA = vi_aomda
         AND D.PPPAP = vi_aopap
         AND D.PPCTA = vi_aocta
         AND D.PPOPER = vi_aooper
         AND D.PPSBOP = vi_aosbop
         AND D.PPTOPE = vi_aotope
         AND D2.PGCOD = D.PGCOD
         AND D2.PPMOD = D.PPMOD
         AND D2.PPSUC = D.PPSUC
         AND D2.PPMDA = D.PPMDA
         AND D2.PPPAP = D.PPPAP
         AND D2.PPCTA = D.PPCTA
         AND D2.PPOPER = D.PPOPER
         AND D2.PPSBOP = D.PPSBOP
         AND D2.PPTOPE = D.PPTOPE
         and d2.pp1stat = 'T'
         AND D2.PPFPAG = D.PPFPAG;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        FLAG_PAGOS := 'S';
    END;
    --OBTENER LA FECHA MINIMA DE PAGO
    IF FLAG_PAGOS = 'N' AND FEC_PAGO IS NOT NULL THEN
      begin
        SELECT MIN(D.PPFPAG)
          INTO vi_fecpagmin
          FROM FSD601 D
         WHERE D.PGCOD = vi_pgcod
           AND D.PPMOD = vi_aomod
           AND D.PPSUC = vi_aosuc
           AND D.PPMDA = vi_aomda
           AND D.PPPAP = vi_aopap
           AND D.PPCTA = vi_aocta
           AND D.PPOPER = vi_aooper
           AND D.PPSBOP = vi_aosbop
           AND D.PPTOPE = vi_aotope
           AND D.PPFPAG > FEC_PAGO;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      end;
      vi_fecactual := vi_fecpagmin;
    ELSE
      BEGIN
        SELECT MIN(D.PPFPAG)
          INTO vi_fecactual
          FROM FSD601 D
         WHERE D.PGCOD = vi_pgcod
           AND D.PPMOD = vi_aomod
           AND D.PPSUC = vi_aosuc
           AND D.PPMDA = vi_aomda
           AND D.PPPAP = vi_aopap
           AND D.PPCTA = vi_aocta
           AND D.PPOPER = vi_aooper
           AND D.PPSBOP = vi_aosbop
           AND D.PPTOPE = vi_aotope;
      exception
        when others then
          null;
          /*SELECT pgfape INTO vi_fecactual FROM FST017 WHERE PGCOD=1;*/
      END;
    END IF;
    --OBTENGO EL PLAZO RESIDUAL
    BEGIN
      SELECT MONTHS_BETWEEN(vi_fecpagmax, vi_fecactual) + 1
        INTO vi_plzo_res
        FROM DUAL;
    exception
      when others then
        null;
    END;
  END;
  PROCEDURE SP_VALIDAR_LISTA(ve_instancia   number,
                             ve_rpta        OUT varchar,
                             ve_descripcion OUT varchar) IS
    VI_PGCOD      XWF700.XWFEMPRESA%TYPE;
    VI_SUC        XWF700.XWFSUCURSAL%TYPE;
    VI_MOD        XWF700.XWFMODULO%TYPE;
    VI_MDA        XWF700.XWFMONEDA%TYPE;
    VI_PAP        XWF700.XWFPAPEL%TYPE;
    VI_CTA        XWF700.XWFCUENTA%TYPE;
    VI_OPE        XWF700.XWFOPERACION%TYPE;
    VI_SBO        XWF700.XWFSUBOPE%TYPE;
    VI_TOP        XWF700.XWFTIPOPE%TYPE;
    VI_HABILITADO NUMBER(17, 2);
    VI_CODDES     NUMBER(9);
  
    CURSOR DESCRIPCION IS
      SELECT TP1DESC
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11161
         AND TP1CORR1 = 50
         AND TP1CORR2 = VI_CODDES
         AND TP1CORR3 > 0
       ORDER BY TP1CORR3 ASC;
  BEGIN
    -----OBTENER CLAVE DEL CREDITO
    BEGIN
      SELECT XWFEMPRESA,
             XWFSUCURSAL,
             XWFMODULO,
             XWFMONEDA,
             XWFPAPEL,
             XWFCUENTA,
             XWFOPERACION,
             XWFSUBOPE,
             XWFTIPOPE
        INTO VI_PGCOD,
             VI_SUC,
             VI_MOD,
             VI_MDA,
             VI_PAP,
             VI_CTA,
             VI_OPE,
             VI_SBO,
             VI_TOP
        FROM XWF700 X
       WHERE X.XWFPRCINS = ve_instancia
         AND X.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      SELECT TP1IMP1, TP1NRO3
        INTO VI_HABILITADO, VI_CODDES
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11161
         AND TP1CORR1 = 50
         AND TP1CORR2 = 2
         AND TP1CORR3 > 0
         AND TP1NRO1 = VI_CTA
         AND TP1NRO2 = VI_OPE;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      FOR X IN DESCRIPCION LOOP
        ve_descripcion := ve_descripcion || X.TP1DESC;
      END LOOP;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    if VI_HABILITADO = 1 then
      ve_rpta := 'N';
    else
      ve_rpta := 'S';
    end if;
  END;
  --apachecoh 2023.02.08
  PROCEDURE SP_VALIDAR_SI_EN_LISTA_EXCP(ve_instancia in number,
                                        ve_rpta      out varchar2) IS
    VI_PGCOD      XWF700.XWFEMPRESA%TYPE;
    VI_SUC        XWF700.XWFSUCURSAL%TYPE;
    VI_MOD        XWF700.XWFMODULO%TYPE;
    VI_MDA        XWF700.XWFMONEDA%TYPE;
    VI_PAP        XWF700.XWFPAPEL%TYPE;
    VI_CTA        XWF700.XWFCUENTA%TYPE;
    VI_OPE        XWF700.XWFOPERACION%TYPE;
    VI_SBO        XWF700.XWFSUBOPE%TYPE;
    VI_TOP        XWF700.XWFTIPOPE%TYPE;
    VI_HABILITADO VARCHAR2(2);
  
  BEGIN
    -----OBTENER CLAVE DEL CREDITO
    BEGIN
      SELECT XWFEMPRESA,
             XWFSUCURSAL,
             XWFMODULO,
             XWFMONEDA,
             XWFPAPEL,
             XWFCUENTA,
             XWFOPERACION,
             XWFSUBOPE,
             XWFTIPOPE
        INTO VI_PGCOD,
             VI_SUC,
             VI_MOD,
             VI_MDA,
             VI_PAP,
             VI_CTA,
             VI_OPE,
             VI_SBO,
             VI_TOP
        FROM XWF700 X
       WHERE X.XWFPRCINS = ve_instancia
         AND X.XWFCAR3 = '1'
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      SELECT AQPB936EST
        INTO VI_HABILITADO
        FROM AQPB936
       WHERE AQPB936COD = VI_PGCOD
         AND AQPB936SUC = VI_SUC
         AND AQPB936MOD = VI_MOD
         AND AQPB936MDA = VI_MDA
         AND AQPB936PAP = VI_PAP
         AND AQPB936CTA = VI_CTA
         AND AQPB936OPER = VI_OPE
         AND AQPB936SBOP = VI_SBO
         AND AQPB936TOP = VI_TOP
         AND AQPB936EST = 'S'
         AND AQPB936FCAR = (SELECT MAX(AQPB936FCAR) FROM AQPB936);
    EXCEPTION
      WHEN OTHERS THEN
        ve_rpta := 'S';
    END;
    IF VI_HABILITADO = 'S' THEN
      ve_rpta := 'N';
    ELSE
      ve_rpta := 'S';
    END IF;
  END;

  PROCEDURE SP_VALIDAR_CREDITOS_CRM(ve_instancia   in number,
                                    vi_nro         in number,
                                    vi_mensaje_crm out varchar) IS
    VI_PGCOD      XWF700.XWFEMPRESA%TYPE;
    VI_SUC        XWF700.XWFSUCURSAL%TYPE;
    VI_MOD        XWF700.XWFMODULO%TYPE;
    VI_MDA        XWF700.XWFMONEDA%TYPE;
    VI_PAP        XWF700.XWFPAPEL%TYPE;
    VI_CTA        XWF700.XWFCUENTA%TYPE;
    VI_OPE        XWF700.XWFOPERACION%TYPE;
    VI_SBO        XWF700.XWFSUBOPE%TYPE;
    VI_TOP        XWF700.XWFTIPOPE%TYPE;
    VI_MTO_AJUSTE NUMBER(17, 2);
    VI_TIPO       NUMBER(10);
    vi_modulo     XWF700.XWFMODULO%TYPE;
  BEGIN
    vi_mensaje_crm := '';
    -----OBTENER CLAVE DEL CREDITO
    BEGIN
      SELECT XWFEMPRESA,
             XWFSUCURSAL,
             XWFMODULO,
             XWFMONEDA,
             XWFPAPEL,
             XWFCUENTA,
             XWFOPERACION,
             XWFSUBOPE,
             XWFTIPOPE
        INTO VI_PGCOD,
             VI_SUC,
             VI_MOD,
             VI_MDA,
             VI_PAP,
             VI_CTA,
             VI_OPE,
             VI_SBO,
             VI_TOP
        FROM XWF700 X
       WHERE X.XWFPRCINS = ve_instancia
         AND X.XWFCAR3 = '1'
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      select tp1nro1
        into vi_modulo
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 400000
         AND TP1NRO1 = VI_MOD
         AND TP1NRO2 = VI_TOP
         and f.tp1corr2 = 26
         and f.tp1corr3 >= 1;
    EXCEPTION
      WHEN OTHERS THEN
        vi_modulo := 0;
    END;
    IF vi_modulo > 0 THEN
      vi_mensaje_crm := 'No se pueden reprogramar desde este panel estos Créditos, reintente desde el Flujo Normal';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE SP_REGLAS_LOGS_EXCEPTION(VE_NRO         IN NUMBER,
                                     VE_INSTANCIA   IN NUMBER,
                                     VE_VARIABLE    IN VARCHAR,
                                     VE_RPTAC       IN VARCHAR,
                                     VE_COD_REGLA   IN NUMBER,
                                     VE_EXCEPCION_G OUT VARCHAR,
                                     VE_EXCEPTION_U OUT VARCHAR) IS
  BEGIN
    --VALIDAR SI ESTA EXCEPTUADO
    PQ_CR_VALIDAR_RNG_REPROG.SP_DESACTIVAR_REGLA(VE_NRO,
                                                 VE_INSTANCIA,
                                                 VE_VARIABLE,
                                                 VE_EXCEPCION_G);
    PQ_CR_VALIDAR_RNG_REPROG.SP_OBTENER_EXCEPCION_REGLA(VE_NRO,
                                                        VE_INSTANCIA,
                                                        VE_VARIABLE,
                                                        VE_EXCEPTION_U); --VALIDAR SI LA REGLA ESTA EXCEPTUADA PARA LA INSTANCIA SELECCIONADA.
    PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(VE_NRO,
                                               VE_VARIABLE, --variable
                                               VE_RPTAC, --valor
                                               VE_COD_REGLA, --regla
                                               ve_instancia --instancia
                                               );
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE SP_VALIDAR_NRO_REPROG(VE_INSTANCIA IN NUMBER,
                                  VE_RPTA      OUT VARCHAR) IS
    VI_NRO_REPROG NUMBER(5);
    VI_LIMITE     NUMBER(5);
  BEGIN
    --LIMITE DE REPROGRAMACIONES
    BEGIN
      SELECT TP1NRO1
        INTO VI_LIMITE
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11161
         AND TP1CORR1 = 10
         AND TP1CORR2 = 0
         AND TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        VI_LIMITE := 3;
    END;
    --NRO DE REPROGRAMADOS
    BEGIN
      select count(*)
        into VI_NRO_REPROG
        from (select jaqa400fec
                from jaqa400
               where jaqa400ai1 = VE_INSTANCIA
                 and jaqa400est = 'C'
              union all
              select jaqz698fep
                from jaqz698 j, xwf700 x
               where j.jaqz698emp = x.xwfempresa
                 and j.jaqz698mod = x.xwfmodulo
                 and j.jaqz698suc = x.xwfsucursal
                 and j.jaqz698mda = x.xwfmoneda
                 and j.jaqz698pap = x.xwfpapel
                 and j.jaqz698cta = x.xwfcuenta
                 and j.jaqz698ope = x.xwfoperacion
                 and j.jaqz698sbo = x.xwfsubope
                 and j.jaqz698top = x.xwftipope
                 and x.xwfprcins = VE_INSTANCIA
                 and xwfcar3 = '1'
                 and j.jaqz698est = 'C'
              union all
              select x.xwffec1
                from xwf700 x
               where xwfprcins = VE_INSTANCIA
                 and xwfcar3 <> '1');
    EXCEPTION
      WHEN OTHERS THEN
        VI_NRO_REPROG := 0;
    END;
    --VALIDAR SI NO SOBREPASAMOS EL LIMITE
    BEGIN
      IF VI_NRO_REPROG <= VI_LIMITE THEN
        VE_RPTA := 'N';
      ELSE
        VE_RPTA := 'S';
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        VE_RPTA := 'N';
    END;
  END;
  PROCEDURE SP_VALIDAR_NRO_REPROGN(VE_INSTANCIA IN NUMBER,
                                   VO_NRO_RPG   OUT NUMBER) IS
    VI_NRO_REPROG NUMBER(5);
    VI_LIMITE     NUMBER(5);
  BEGIN
    --NRO DE REPROGRAMADOS
    BEGIN
      select count(*)
        into VO_NRO_RPG
        from (select jaqa400fec
                from jaqa400
               where jaqa400ai1 = VE_INSTANCIA
                 and jaqa400est = 'C'
              union all
              select jaqz698fep
                from jaqz698 j, xwf700 x
               where j.jaqz698emp = x.xwfempresa
                 and j.jaqz698mod = x.xwfmodulo
                 and j.jaqz698suc = x.xwfsucursal
                 and j.jaqz698mda = x.xwfmoneda
                 and j.jaqz698pap = x.xwfpapel
                 and j.jaqz698cta = x.xwfcuenta
                 and j.jaqz698ope = x.xwfoperacion
                 and j.jaqz698sbo = x.xwfsubope
                 and j.jaqz698top = x.xwftipope
                 and x.xwfprcins = VE_INSTANCIA
                 and xwfcar3 = '1'
                 and j.jaqz698est = 'C'
              union all
              select x.xwffec1
                from xwf700 x
               where xwfprcins = VE_INSTANCIA
                 and xwfcar3 <> '1');
    EXCEPTION
      WHEN OTHERS THEN
        VO_NRO_RPG := 0;
    END;
  END;
  --apachecoh 2023.09.27
  PROCEDURE SP_VALIDAR_LISTA_BI(VE_INSTANCIA   IN NUMBER,
                                VE_NRO_RPG     OUT NUMBER,
                                VE_CARGO_APROB OUT NUMBER,
                                VE_APROBADOR   OUT VARCHAR,
                                VE_RPTA        OUT VARCHAR) IS
    LN_CTA  NUMBER(9);
    LN_OPE  NUMBER(9);
    LN_PAIS NUMBER(5);
    LN_TDOC NUMBER(5);
    LV_NDOC VARCHAR2(12);
  BEGIN
    BEGIN
      SELECT XWFCUENTA, XWFOPERACION
        INTO LN_CTA, LN_OPE
        FROM XWF700
       WHERE XWFPRCINS = VE_INSTANCIA
         AND XWFCAR3 = '1'
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT SNG001PAIS, SNG001TDOC, TRIM(SNG001NDOC)
        INTO LN_PAIS, LN_TDOC, LV_NDOC
        FROM SNG001
       WHERE SNG001INST = VE_INSTANCIA
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT AQPC952nrpgs,
             CASE
               WHEN AQPC952aprob = 'Gerente de Agencia' THEN
                202
               WHEN AQPC952aprob IN ('Gerente Zonal', 'Gerente Regional') THEN
                220
               WHEN AQPC952aprob = 'URIE' THEN
                230
               ELSE
                230
             END AS CARGO,
             AQPC952aprob,
             AQPC952reqopi
        INTO VE_NRO_RPG, VE_CARGO_APROB, VE_APROBADOR, VE_RPTA
        FROM AQPC952 B
       WHERE B.AQPC952FECC = (SELECT MAX(AQPC952FECC) FROM AQPC952)
         AND B.AQPC952HORC =
             (SELECT MAX(AQPC952HORC)
                FROM AQPC952
               WHERE AQPC952FECC = (SELECT MAX(AQPC952FECC) FROM AQPC952))
         AND B.AQPC952CTA = LN_CTA
         AND B.AQPC952OPER = LN_OPE
         AND ROWNUM = 1;
      /*SELECT NUMERO_REPROGRAMACIONES,
            CASE
              WHEN APROBADOR = 'Gerente de Agencia' THEN
               202
              WHEN APROBADOR IN ('Gerente Zonal', 'Gerente Regional') THEN
               220
              WHEN APROBADOR = 'URIE' THEN
               230
              ELSE
               230
            END AS CARGO,
            APROBADOR,
            NECESITA_OPINION_RIESGOS
       INTO VE_NRO_RPG, VE_CARGO_APROB, VE_APROBADOR, VE_RPTA
       FROM USRREPBI.REP_308_REPROGRAMACIONES_VENCIDOS A
      WHERE A.BCCTA = LN_CTA
        AND A.BCOPER = LN_OPE
           --AND A.PENDOC = LV_NDOC
        AND ROWNUM = 1;*/
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  END;

  PROCEDURE SP_CR_VALIDA_FECHA_REPROGRAMADO(INSTANCIA IN NUMBER,
                                            FLAG      OUT VARCHAR,
                                            CODMSG    OUT VARCHAR2,
                                            DESMSG    OUT VARCHAR2) IS
    FECHA_REPROGRAMADO DATE;
    FECHA_INICIO       CHAR(30);
    FECHA_FIN          CHAR(30);
    FLAGX              CHAR(1);
  BEGIN
    BEGIN
      SELECT MIN(AQPB074FREP)
        INTO FECHA_REPROGRAMADO
        FROM XWF700 T1
        JOIN AQPB074 T2
          ON T1.XWFEMPRESA = T2.AQPB074COD
         AND T1.XWFSUCURSAL = T2.AQPB074SUC
         AND T1.XWFMODULO = T2.AQPB074MOD
         AND T1.XWFMONEDA = T2.AQPB074MDA
         AND T1.XWFPAPEL = T2.AQPB074PAP
         AND T1.XWFCUENTA = T2.AQPB074CTA
         AND T1.XWFOPERACION = T2.AQPB074OPER
         AND T1.XWFSUBOPE = T2.AQPB074SBOP
         AND T1.XWFTIPOPE = T2.AQPB074TOPE
       WHERE XWFPRCINS = INSTANCIA
         AND XWFCAR3 = '1';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        FECHA_REPROGRAMADO := '';
        CODMSG             := '1';
        DESMSG             := 'No se encontro fecha de reprogramación para el crédito';
    END;
  
    BEGIN
      SELECT TP1DESC
        INTO FECHA_INICIO
        FROM FST198
       WHERE TP1COD1 = 11153
         AND TP1CORR1 = 15
         AND TP1CORR2 = 1
         AND TP1CORR3 = 0;
      FLAGX := 'S';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        FLAGX := 'N';
    END;
  
    BEGIN
      SELECT TP1DESC
        INTO FECHA_FIN
        FROM FST198
       WHERE TP1COD1 = 11153
         AND TP1CORR1 = 15
         AND TP1CORR2 = 2
         AND TP1CORR3 = 0;
      FLAGX := 'S';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        FLAGX := 'N';
    END;
  
    IF FLAGX = 'S' THEN
      IF FECHA_REPROGRAMADO >= TO_DATE(TRIM(FECHA_INICIO), 'DD/MM/RRRR') AND
         FECHA_REPROGRAMADO <= TO_DATE(trim(FECHA_FIN), 'DD/MM/RRRR') THEN
        FLAG   := 'S';
        CODMSG := '0';
        DESMSG := 'Ok';
      ELSE
        FLAG   := 'N';
        CODMSG := '1';
        DESMSG := 'El fecha de la reprogramación no se encuentra en el rango parametrizado';
      END IF;
    ELSE
      FLAG   := 'N';
      CODMSG := '2';
      DESMSG := 'No existe rango de fechas para validar la fecha de reprogramacion del crédito';
    END IF;
  END;
  PROCEDURE SP_CR_VALIDA_REPROGRAMADO_DIAS_ATRASO(INSTANCIA IN NUMBER,
                                                  FLAG      OUT VARCHAR,
                                                  CODMSG    OUT VARCHAR2,
                                                  DESMSG    OUT VARCHAR2) IS
    FECHA_PROXIMA  DATE;
    FECHA_APERTURA DATE;
    DIAS           NUMBER(17);
    VE_DIAS_ATRASO NUMBER;
  BEGIN
    BEGIN
      SELECT TP1IMP1
        INTO VE_DIAS_ATRASO
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11165
         AND TP1CORR1 = 200
         AND TP1CORR2 = 1
         AND TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        VE_DIAS_ATRASO := 30;
    END;
    BEGIN
      SELECT T1.PPFPAG
        INTO FECHA_PROXIMA
        FROM FSD601 T1
        JOIN XWF700 T2
          ON T1.PGCOD = T2.XWFEMPRESA
         AND T1.PPMOD = T2.XWFMODULO
         AND T1.PPSUC = T2.XWFSUCURSAL
         AND T1.PPMDA = T2.XWFMONEDA
         AND T1.PPPAP = T2.XWFPAPEL
         AND T1.PPCTA = T2.XWFCUENTA
         AND T1.PPOPER = T2.XWFOPERACION
         AND T1.PPSBOP = T2.XWFSUBOPE
         AND T1.PPTOPE = T2.XWFTIPOPE
       WHERE PPFPAG > (SELECT MAX(T1.PPFPAG)
                         FROM FSD602 T1
                         JOIN XWF700 T2
                           ON T1.PGCOD = T2.XWFEMPRESA
                          AND T1.PPMOD = T2.XWFMODULO
                          AND T1.PPSUC = T2.XWFSUCURSAL
                          AND T1.PPMDA = T2.XWFMONEDA
                          AND T1.PPPAP = T2.XWFPAPEL
                          AND T1.PPCTA = T2.XWFCUENTA
                          AND T1.PPOPER = T2.XWFOPERACION
                          AND T1.PPSBOP = T2.XWFSUBOPE
                          AND T1.PPTOPE = T2.XWFTIPOPE
                          AND T1.D601CO = 'S'
                          AND T1.PP1STAT = 'T'
                          AND T2.XWFPRCINS = INSTANCIA
                          AND T2.XWFCAR3 = '1')
         AND T2.XWFPRCINS = INSTANCIA
         AND T2.XWFCAR3 = '1'
         and rownum = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        FECHA_PROXIMA := NULL;
    END;
    BEGIN
      SELECT PGFAPE INTO FECHA_APERTURA FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        FECHA_APERTURA := NULL;
    END;
    BEGIN
      DIAS := TRUNC(FECHA_APERTURA) - TRUNC(FECHA_PROXIMA);
      IF DIAS > VE_DIAS_ATRASO THEN
        FLAG   := 'N';
        CODMSG := '0';
        DESMSG := DIAS || ' días de atraso'; --'TO_CHAR(FECHA_APERTURA || ' ' || FECHA_PROXIMA || ' ' || DIAS );
      ELSE
        FLAG   := 'S';
        CODMSG := '1';
        DESMSG := 'No tiene días de atraso';
      END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        FLAG   := 'S';
        CODMSG := '1';
        DESMSG := DIAS || ' días de atraso';
    END;
  END;
  PROCEDURE SP_VALIDAR_RPDNATURAL_SINCRM(VE_INSTANCE IN NUMBER, --INSTANCIA
                                         VE_NRO      IN NUMBER, --CORRELATIVO
                                         VE_MENSAJE  OUT VARCHAR, --MENSAJE DEVUELTO
                                         VO_CODERROR OUT VARCHAR,
                                         VO_MSGERROR OUT VARCHAR) IS
    --VARIABLES INTERNAS NECESARIAS
    VE_RPTAC VARCHAR(15);
    --
    VIO_RPTA_DESACTIVA_REG VARCHAR(4);
    VIO_EXCEPCION          VARCHAR(4);
    vo_plazo_re            NUMBER(10);
    --
    vo_gracia number(17);
    vo_monto  number(17, 2);
  BEGIN
  
    BEGIN
      --CONTROLES SOLICITADOS
      --ATRASO 30 DIAS
      -----VALIDAR DIAS DE ATRASO
      PQ_CR_VALIDAR_RNG_REPROG.SP_CR_VALIDA_REPROGRAMADO_DIAS_ATRASO(VE_INSTANCE,
                                                                     VE_RPTAC,
                                                                     VO_CODERROR,
                                                                     VO_MSGERROR);
      -----VALIDAR SI ESTA EXCEPTUADO
      PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VE_NRO,
                                                        VE_INSTANCE,
                                                        'ATRASO_RPDN',
                                                        (VE_RPTAC || '-' ||
                                                        VO_MSGERROR),
                                                        93,
                                                        VIO_RPTA_DESACTIVA_REG,
                                                        VIO_EXCEPCION);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    -----VALIDAR MENSAJE SI SALTA POLITICA
    IF VE_RPTAC = 'S' or VIO_RPTA_DESACTIVA_REG = 'S' or
       VIO_EXCEPCION = 'S' THEN
      --VE_MENSAJE:= 'ASDJLHSAKDLJHAS';
      NULL;
    ELSE
      IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
        VE_MENSAJE := VE_MENSAJE || ';' ||
                      'RSC:Tiene mas de 30 dias de atraso.';
      ELSE
        ve_mensaje := 'RSC:Tiene mas de 30 dias de atraso.';
      END IF;
    END IF;
    BEGIN
      --PLAZO GRACIAS <= 6 MESES
      --VALIDAR GRACIA
      /*pq_cr_controles_memo24.sp_cr_control_periodio_gracia(VE_INSTANCE,
      vo_gracia,
      vo_monto,
      VE_RPTAC);*/
      PQ_CR_CALIFICAC_REPRG_DESAS_NATURAL.sp_cr_control_periodio_gracia_sin_CRM(VE_INSTANCE,
                                                                                VE_RPTAC,
                                                                                VO_CODERROR,
                                                                                VO_MSGERROR);
      /*PQ_CR_GRADIENTE.sp_cr_control_periodio_gracia_sin_CRM(VE_INSTANCE,
      '',
      VE_RPTAC,
      VO_CODERROR,
      VO_MSGERROR);*/
      --VALIDAR SI ESTA EXCEPTUADO
      PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VE_NRO,
                                                        VE_INSTANCE,
                                                        'GRACIA_RPDN',
                                                        (VE_RPTAC || '-' ||
                                                        vo_gracia),
                                                        93,
                                                        VIO_RPTA_DESACTIVA_REG,
                                                        VIO_EXCEPCION);
      --VALIDAR MENSAJE SI SALTA POLITICA
      --IF VE_RPTAC = 'N' or VIO_RPTA_DESACTIVA_REG = 'S' or
      IF VE_RPTAC = 'S' or VIO_RPTA_DESACTIVA_REG = 'S' or
         VIO_EXCEPCION = 'S' THEN
        NULL;
      ELSE
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RSC:Gracia mayor a la permitida.';
        ELSE
          VE_MENSAJE := 'RSC:Gracia mayor a la permitida.';
        END IF;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --NO APLICA OPERACIONES REFINANCIADAS
    BEGIN
      VE_RPTAC := 'S';
      --VALIDAR SI EL ORIGEN ES REFINANCIADO
      BEGIN
        SELECT 'N'
          INTO VE_RPTAC
          FROM SNG001
         WHERE SNG001INST = VE_INSTANCE
           AND SNG001ORI = 3;
      EXCEPTION
        WHEN OTHERS THEN
          VE_RPTAC := 'S';
      END;
      ----VALIDAR SI ESTA EXCEPTUADO
      PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VE_NRO,
                                                        VE_INSTANCE,
                                                        'REFIN_RPDN',
                                                        (VE_RPTAC),
                                                        93,
                                                        VIO_RPTA_DESACTIVA_REG,
                                                        VIO_EXCEPCION);
      ----VALIDAR MENSAJE SI SALTA POLITICA
      IF VE_RPTAC = 'S' or VIO_RPTA_DESACTIVA_REG = 'S' or
         VIO_EXCEPCION = 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RSC:Creditos Refinanciados no se puede Reprogramar';
        ELSE
          VE_MENSAJE := 'RSC:Creditos Refinanciados no se puede Reprogramar';
        END IF;
      END IF;
      --          
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --plazo residual
    BEGIN
      /*
      pq_cr_controles_memo24.sp_cr_plazo_residual( VE_INSTANCE,
                                                   vo_plazo_re,
                                                   ve_rptac);
      */
      PQ_CR_CALIFICAC_REPRG_DESAS_NATURAL.sp_cr_valid_plazo_maximo(VE_INSTANCE,
                                                                   VE_RPTAC,
                                                                   VO_CODERROR,
                                                                   VO_MSGERROR);
      ----
    
      ----VALIDAR SI ESTA EXCEPTUADO
      PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VE_NRO,
                                                        VE_INSTANCE,
                                                        'PZO_RESIDUAL_SINCRM',
                                                        (VE_RPTAC) || '-' ||
                                                        VO_CODERROR,
                                                        93,
                                                        VIO_RPTA_DESACTIVA_REG,
                                                        VIO_EXCEPCION);
      ----VALIDAR MENSAJE SI SALTA POLITICA
      IF VE_RPTAC = 'S' or VIO_RPTA_DESACTIVA_REG = 'S' or
         VIO_EXCEPCION = 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RSC:El plazo propuesto no puede ser mayor al plazo del producto';
        ELSE
          VE_MENSAJE := 'RSC::El plazo propuesto no puede ser mayor al plazo del producto';
        END IF;
      END If;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --PRODUCTOS NO PERMITIDOS
    BEGIN
      PQ_CR_CALIFICAC_REPRG_DESAS_NATURAL.sp_cr_control_productos_permitidos(VE_INSTANCE,
                                                                             VE_RPTAC,
                                                                             VO_CODERROR,
                                                                             VO_MSGERROR);
      ----VALIDAR SI ESTA EXCEPTUADO
      PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VE_NRO,
                                                        VE_INSTANCE,
                                                        'PRD_NO_SCRM',
                                                        (VE_RPTAC),
                                                        93,
                                                        VIO_RPTA_DESACTIVA_REG,
                                                        VIO_EXCEPCION);
      ----VALIDAR MENSAJE SI SALTA POLITICA
      IF VE_RPTAC = 'N' or VIO_RPTA_DESACTIVA_REG = 'S' or -- MCORDOVA - 17/07/2025
        --IF VE_RPTAC = 'S' or VIO_RPTA_DESACTIVA_REG = 'S' or 
         VIO_EXCEPCION = 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RSC:No se puede ejecutar estos creditos';
        ELSE
          VE_MENSAJE := 'RSC:No se puede ejecutar estos creditos';
        END IF;
      END If;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --CALIFICACION NORMAL O CPP
    BEGIN
      pq_cr_calificac_reprg_desas_natural.SP_CR_CALIFIC_RCC(VE_INSTANCE,
                                                            VE_RPTAC);
      ----VALIDAR SI ESTA EXCEPTUADO
      PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VE_NRO,
                                                        VE_INSTANCE,
                                                        'RCC_RPDN',
                                                        (VE_RPTAC),
                                                        93,
                                                        VIO_RPTA_DESACTIVA_REG,
                                                        VIO_EXCEPCION);
      ----VALIDAR MENSAJE SI SALTA POLITICA
      IF VE_RPTAC = 'S' or VIO_RPTA_DESACTIVA_REG = 'S' or
         VIO_EXCEPCION = 'S' THEN
        NULL;
      ELSE
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RSC:La calificacion Interna del Cliente no esta en Normal o CPP';
        ELSE
          VE_MENSAJE := 'RSC:La calificacion Interna del Cliente no esta en Normal o CPP';
        END IF;
      END IF;
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    --VALIDAR CUENTA GRADIENTE MENOS DEL 30%
    BEGIN
      pq_cr_contrl_reprog_refin25.SP_CR_RP_GRADIENTE_CAJ_REPRGSINCAP(VE_INSTANCE,
                                                                     '',
                                                                     VE_RPTAC,
                                                                     VO_CODERROR,
                                                                     VO_MSGERROR);
      ----VALIDAR SI ESTA EXCEPTUADO
      PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VE_NRO,
                                                        VE_INSTANCE,
                                                        'CF_CRD_CUE_GRADIEN',
                                                        (VE_RPTAC),
                                                        93,
                                                        VIO_RPTA_DESACTIVA_REG,
                                                        VIO_EXCEPCION);
      ----VALIDAR MENSAJE SI SALTA POLITICA
      IF VE_RPTAC = 'N' or VIO_RPTA_DESACTIVA_REG = 'S' or
         VIO_EXCEPCION = 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RNG:El capital representa menos del 30% del valor total de la cuota gradiente';
        ELSE
          VE_MENSAJE := 'RNG:El capital representa menos del 30% del valor total de la cuota gradiente';
        END IF;
      END IF;
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --VALIDAR GRADIENTES NO PUEDEN SER MAS DE 25%
    BEGIN
      PQ_CR_GRADIENTE.SP_CR_GRDNT_CRONOGR2(VE_INSTANCE,
                                           '',
                                           VE_RPTAC,
                                           VO_CODERROR,
                                           VO_MSGERROR);
    
      ----VALIDAR SI ESTA EXCEPTUADO
      PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VE_NRO,
                                                        VE_INSTANCE,
                                                        'CF_CRD_CUE_GRADIEN2',
                                                        (VE_RPTAC),
                                                        93,
                                                        VIO_RPTA_DESACTIVA_REG,
                                                        VIO_EXCEPCION);
      ----VALIDAR MENSAJE SI SALTA POLITICA
      IF VE_RPTAC = 'N' or VIO_RPTA_DESACTIVA_REG = 'S' or
         VIO_EXCEPCION = 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RNG:El n° cuotas gradientes debe ser menor o igual al 25% del cronograma';
        ELSE
          VE_MENSAJE := 'RNG:El n° cuotas gradientes debe ser menor o igual al 25% del cronograma';
        END IF;
      END IF;
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    --VALIDAR ESTADO DE ACTA DIGITAL
    BEGIN
      PQ_CR_REGISTRO_ACTA_DIGITAL.SP_CR_VALIDA_ACTA_CERRADA2(VE_INSTANCE,
                                                             '',
                                                             VE_RPTAC,
                                                             VO_CODERROR,
                                                             VO_MSGERROR);
    
      --VALIDAR SI ESTA EXCEPTUADO
      PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VE_NRO,
                                                        VE_INSTANCE,
                                                        'CF_CRD_VAL_ACT_DIG',
                                                        (VE_RPTAC),
                                                        93,
                                                        VIO_RPTA_DESACTIVA_REG,
                                                        VIO_EXCEPCION);
      --VALIDAR MENSAJE SI SALTA POLITICA
      IF VE_RPTAC = 'N' or VIO_RPTA_DESACTIVA_REG = 'S' or
         VIO_EXCEPCION = 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RNG:No se completó la gestión del acta digital';
        ELSE
          VE_MENSAJE := 'RNG:No se completó la gestión del acta digital';
        END IF;
      END IF;
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --VALIDA LIMITES POR REGION - MILTON CORDOVA IGS
    BEGIN
      PQ_CR_LIMITES_RPG.SP_CR_VALIDA_LIMITE_REGION(VE_INSTANCE,
                                                   '',
                                                   VE_RPTAC,
                                                   VO_CODERROR,
                                                   VO_MSGERROR);
    
      ----VALIDAR SI ESTA EXCEPTUADO
      PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VE_NRO,
                                                        VE_INSTANCE,
                                                        'CF_CRD_VAL_LIM_REG',
                                                        (VE_RPTAC),
                                                        93,
                                                        VIO_RPTA_DESACTIVA_REG,
                                                        VIO_EXCEPCION);
      ----VALIDAR MENSAJE SI SALTA POLITICA
      IF VE_RPTAC = 'N' or VIO_RPTA_DESACTIVA_REG = 'S' or
         VIO_EXCEPCION = 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
          VE_MENSAJE := VE_MENSAJE || ';' ||
                        'RNG:Supero límite de reprogramaciones para la región, el caso necesita opinión de riesgos';
        ELSE
          VE_MENSAJE := 'RNG:Supero límite de reprogramaciones para la región, el caso necesita opinión de riesgos';
        END IF;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE SP_CR_VALIDA_EXCEPCION_CRM(INSTANCIA IN NUMBER,
                                       FLAG      OUT VARCHAR,
                                       CODMSG    OUT VARCHAR2,
                                       DESMSG    OUT VARCHAR2) IS
    XRESPUESTA VARCHAR2(100);
    XFLAG      CHAR(1);
  BEGIN
    BEGIN
      SELECT 'S'
        INTO XFLAG
        FROM FST198
       WHERE TP1COD1 = 11153
         AND TP1CORR1 = 27
         AND TP1CORR2 = 1
         AND TP1CORR3 = 0
         AND TP1NRO1 = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        XFLAG := 'N';
    END;
    IF XFLAG = 'S' THEN
      FLAG := 'S';
    ELSE
      pq_cr_funciones_cho.sp_indicador_CRM_Caja(INSTANCIA, XRESPUESTA);
      IF XRESPUESTA <> 'N' THEN
        FLAG := 'S';
      ELSE
        FLAG := 'N';
      END IF;
    END IF;
  END;
  PROCEDURE SP_VALIDAR_OPINION_RSG(VE_INSTANCE IN NUMBER, --INSTANCIA
                                   VE_NRO      IN NUMBER, --CORRELATIVO
                                   VE_MENSAJE  OUT VARCHAR, --MENSAJE DEVUELTO
                                   VO_CODERROR OUT VARCHAR,
                                   VO_MSGERROR OUT VARCHAR) IS
    vi_requiereopinion    varchar(3);
    vi_tieneOpinion       number(3);
    vi_TipoOpinion        varchar(3);
    vi_mensaje            varchar(250);
    ve_rptac              varchar(150);
    ve_rptar              varchar(150);
    vi_tipo_reprog        varchar(1);
    VI_DIAS               number(6, 2); --05.05.2022 - aumento el tamaño
    VE_RPTA_DESACTIVA_REG VARCHAR(1);
    vo_excepcion          varchar(1);
  BEGIN
    ----DENTRO DEL GRUPO
    BEGIN
      --PROCESO PARA VALIDAR SI REQUIERE OPINION O NO.
      PQ_CR_INST_VUELO_RP.SP_CR_VALIDAR_CTA_OPER(VE_INSTANCE,
                                                 vi_requiereopinion);
      --PROCESO PARA VALIDAR SI TIENE EXCEPCION
      PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VE_NRO,
                                                        VE_INSTANCE,
                                                        'REQ_OPI_SCRM',
                                                        'OPI_RSCRM:' ||
                                                        vi_requiereopinion,
                                                        91,
                                                        VE_RPTA_DESACTIVA_REG,
                                                        vo_excepcion);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    end;
    --VALIDAR SI INGRESARON OPINION      
    pq_cr_reprogramaexo.sp_validaopinion(VE_INSTANCE,
                                         vi_tieneOpinion,
                                         vi_TipoOpinion,
                                         vi_mensaje);
    --VALIDAR MENSAJE SI SALTA POLITICA
    IF vi_requiereopinion = 'N' or VE_RPTA_DESACTIVA_REG = 'S' or
       vo_excepcion = 'S' or (vi_tieneOpinion = 1 and vi_TipoOpinion = 'V') THEN
      --VE_MENSAJE:= '';
      NULL;
    ELSE
      IF LENGTH(TRIM(VE_MENSAJE)) > 0 and LENGTH(TRIM(VE_MENSAJE)) < 700 THEN
        VE_MENSAJE := VE_MENSAJE || ';' ||
                      'RSC:Requiere Opinion de Riesgos' || '-' ||
                      VE_MENSAJE;
      ELSE
        ve_mensaje := 'RSC:Requiere Opinion de Riesgos' || '-' ||
                      VE_MENSAJE;
      END IF;
    END IF;
  END;

  PROCEDURE SP_CR_RATIOS_REPROGRAMADOS(V_INSTANCIA     in number,
                                       V_USUARIO       in varchar2,
                                       V_FLAG          out varchar2,
                                       V_CODIGO_ERROR  out varchar2,
                                       V_MENSAJE_ERROR out varchar2) IS
    V_SEGMENTO_ACTUAL NUMBER;
    V_PGFAPE          DATE;
    RATIOP            NUMBER;
    RATIOC            NUMBER;
    -- V_RESPUESTA VARCHAR2(1);
  BEGIN
    BEGIN
      SELECT PGFAPE INTO V_PGFAPE FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    pq_cr_ratios_reprocap.sp_cr_SegmntoActual(V_INSTANCIA,
                                              V_SEGMENTO_ACTUAL);
    pq_cr_ratios_reprocap.sp_cr_inicio(V_INSTANCIA,
                                       V_PGFAPE,
                                       V_USUARIO,
                                       RATIOP,
                                       RATIOC);
    pq_cr_ratios_reprocap.sp_cr_ratio(V_INSTANCIA,
                                      V_SEGMENTO_ACTUAL,
                                      V_FLAG);
    V_MENSAJE_ERROR := ' Segmento:' || V_SEGMENTO_ACTUAL || ' RatioP:' ||
                       TO_CHAR(RATIOP) || ' RatioC:' || TO_CHAR(RATIOC) ||
                       ' Indicador:' || V_FLAG;
  END;
  PROCEDURE SP_BLOQUEO_CREDINKA(P_INSTANCIA IN NUMBER,
                                P_USUARIO   IN VARCHAR2,
                                P_RESPUESTA OUT VARCHAR2,
                                P_COD_ERROR OUT VARCHAR2,
                                P_MENSAJE   OUT VARCHAR2) IS
    VI_C_EXISTE NUMBER(9) := 0;
    VI_N_PGCOD  XWF700.XWFEMPRESA%TYPE;
    VI_N_SUC    XWF700.XWFSUCURSAL%TYPE;
    VI_N_MOD    XWF700.XWFMODULO%TYPE;
    VI_N_MDA    XWF700.XWFMONEDA%TYPE;
    VI_N_PAP    XWF700.XWFPAPEL%TYPE;
    VI_N_CTA    XWF700.XWFCUENTA%TYPE;
    VI_N_OPE    XWF700.XWFOPERACION%TYPE;
    VI_N_SBO    XWF700.XWFSUBOPE%TYPE;
    VI_N_TOP    XWF700.XWFTIPOPE%TYPE;
  BEGIN
    P_RESPUESTA := 'N';
    P_COD_ERROR := '0000';
    P_MENSAJE   := '';
    --
    -----OBTENER CLAVE DEL CREDITO
    BEGIN
      SELECT XWFEMPRESA,
             XWFSUCURSAL,
             XWFMODULO,
             XWFMONEDA,
             XWFPAPEL,
             XWFCUENTA,
             XWFOPERACION,
             XWFSUBOPE,
             XWFTIPOPE
        INTO VI_N_PGCOD,
             VI_N_SUC,
             VI_N_MOD,
             VI_N_MDA,
             VI_N_PAP,
             VI_N_CTA,
             VI_N_OPE,
             VI_N_SBO,
             VI_N_TOP
        FROM XWF700 X
       WHERE X.XWFPRCINS = P_INSTANCIA
         AND X.XWFCAR3 = '1'
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --VALIDAR EN GUIA SI LA INSTANCIA TIENE EL SIGUIEN MODULO Y TIPO DE OPERACION
    BEGIN
      SELECT COUNT(*)
        INTO VI_C_EXISTE
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11161
         AND F.TP1CORR1 = 551
         AND F.TP1CORR2 = 0
         AND F.TP1NRO1 = VI_N_MOD --MODULO
         AND F.TP1NRO2 = VI_N_TOP --TIPO_OPERACION
         AND F.TP1NRO3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        VI_C_EXISTE := 0;
        P_COD_ERROR := '0001';
        P_MENSAJE   := 'C01-No se logro procesar, contactar con el Administrador';
    END;
    --
    IF VI_C_EXISTE > 0 THEN
      P_RESPUESTA := 'S';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      P_COD_ERROR := '0002';
      P_MENSAJE   := 'C02-No se logro procesar, contactar con el Administrador';
  END;
end pq_cr_validar_rng_reprog;
/
