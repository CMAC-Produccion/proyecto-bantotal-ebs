create or replace package pq_cr_reprog_sin_cap is

  -- Author  : HSUAREZ
  -- Created : 29/01/2021 09:42:39
  -- Purpose : Paquete para reprogramacion de creditos sin capitalizacion
  -- MOdificacion: Hsuarez
  -- Fecha Modificacion: 27/09/2023 12:52
  -- Contenido: Se agrego un tipo de reprogramacion para los del listado de BI sin consultar a CRM.
  -- Fecha Modificacion:23/01/2024 12:52
  -- Contenido: Se modifico el arbol de aprobacion para reprogramados CAJA segun MEMO18-2024.
  -- Fecha Modificacion:11/04/2024 12:52 
  -- Autor: HSUAREZ 
  -- Contenido: Se modifico el proceso para añadir arbol de aprobacion multinivel
  -- Fecha Modificacion:11/06/2024 12:52 
  -- Autor: HSUAREZ 
  -- Contenido: Se modifico el proceso de Tipo de Reprogramacion, para inicializar el arbol multinivel, se mejoro el proceso obtner Aprobador.
  -- Contenido: Se modifico el proceso para añadir arbol de aprobacion multinivel
  -- Fecha Modificacion:14/06/2024 12:52 
  -- Autor: HSUAREZ 
  -- Contenido: Se agrego un proceso para manejar log de secuencias.
  -- Fecha Modificacion:11/09/2024 12:52 
  -- Autor: HSUAREZ 
  -- Contenido: Se modifico paquete para validar los rechazos y actualizar guia.
  -- Fecha Modificacion:26/09/2024 12:52 
  -- Autor: HSUAREZ 
  -- Contenido: Se modifico paquete para manejar mensaje de correos segun reprogramación.
  -- Fecha Modificacion:02/05/2025 
  -- Autor: MCHAVEZ 
  -- Contenido: Se Agrega procedimiento SP_CR_MANT_ARBOL_APROB.
  -- Fecha Modificacion:23/10/2025
  -- Autor: ENINAH 
  -- Contenido: Se modifico SP_ENVIAR_CORREO_PAPR para el uso de Bot de reprogramaciones
  type list_cred is record(
    n_cod    number(10), -- Codigo de Registro  
    n_dni    varchar(12), --DNI
    n_nombre varchar(50), --Nombres y Apellidos
    
    n_emp number(3), -- Empresa
    n_mod number(3), -- Modulo
    n_suc number(3), -- Sucursal
    n_mda number(4), -- Moneda
    n_pap number(4), -- Papel
    n_cta number(9), -- Cuenta
    n_ope number(9), -- Operacion
    n_sbo number(3), -- SubOperacion
    n_top number(3), -- Tipo de Operacion
    
    n_scap    number(17, 2), -- Saldo Capital
    n_estado  char(1), -- Estado
    n_destado varchar2(15), -- Descripcion de Estado
    n_fec_reg timestamp, -- Fecha de Registro
    n_fec_cam timestamp, -- Fecha de Aprobaci?n y/o Rechazo
    
    n_cuo_ant number(17, 2), -- Cuota Anterior
    n_cuo_nue number(17, 2), -- Nueva Cuota Propuesta
    
    n_frc_ant number(5), -- Frecuencia Anterior
    n_frc_nue number(5), -- Nueva Frecuencia
    n_fec_cia date, -- Fecha de Cuota Impaga
    n_fec_cin date, -- Nueva Fecha de Cuota Impaga
    n_fec_vca date, -- Fecha de Cancelacion del Credito.
    n_fec_vcn date -- Nueva Fecha de Cancelacion del Credito.
    );
  type list_cred_cur is REF CURSOR return list_cred;
  ---
  function sp_obtener_lista(ve_est  in varchar,
                            ve_cta  in varchar,
                            ve_pais in number,
                            ve_tdoc in number,
                            ve_ndoc in varchar,
                            ve_fecc in date)
    return pq_cr_reprog_sin_cap.list_cred_cur;
  ---
  function fn_gestionar_cred(ve_cod  in number,
                             ve_est  in varchar,
                             ve_user in varchar) return varchar;
  --pq_cr_reprog_sin_cap.list_cred_cur;
  ---
  PROCEDURE sp_gestionar_credito(ve_cod  in number,
                                 ve_est  in varchar,
                                 ve_user in varchar,
                                 ve_msj  out varchar);

  PROCEDURE SP_VALIDAR_JAQA400(pn_emp in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               pv_out out varchar);

  PROCEDURE sp_pasar_covit_indv(ve_cod  in number,
                                ve_est  in varchar,
                                ve_user in varchar,
                                ve_msj  out varchar);

  PROCEDURE sp_creditos_upd_lstcovt(ve_cod  in number,
                                    ve_user in varchar,
                                    ve_msj  out varchar);
  PROCEDURE sp_creditos_upd_lstcovd(ve_cod  in number,
                                    ve_user in varchar,
                                    ve_msj  out varchar);
  PROCEDURE SP_CRD_TCOVIT_MAIL(P_N_PGCOD  IN number,
                               P_N_SCSUC  IN number,
                               P_N_SCMDA  IN number,
                               P_N_SCPAP  IN number,
                               P_N_SCCTA  IN number,
                               P_N_SCOPER IN number,
                               P_N_SCSBOP IN number,
                               P_N_SCTOPE IN number,
                               P_N_SCMOD  IN number,
                               P_V_UBUSER IN varchar2,
                               P_V_TIPO   IN varchar2,
                               P_D_PGFAPE IN date,
                               p_n_coderr out number,
                               p_c_msgerr out varchar2);
  procedure SP_CR_EXCP_REPRO(PN_INST IN NUMBER,
                             PN_USR  OUT VARCHAR2,
                             PN_CODE OUT NUMBER,
                             PV_MSGE OUT VARCHAR2);
  PROCEDURE SP_CRD_TIPO_REPROGRAMACION(codigo    in number,
                                       instancia in number,
                                       vo_tprpg  out number);
  PROCEDURE SP_CRD_ARBOL_APROBACION(codigo    in number,
                                    instancia in number,
                                    vo_cargo  out number);
  PROCEDURE SP_CRD_ARBOL_APROBACION_CAJA2024(codigo    in number,
                                             instancia in number,
                                             vo_cargo  out number,
                                             vo_perfil out varchar);
  PROCEDURE SP_CRD_ARBOL_APROBACION_RNG(instancia    in number,
                                        vo_ind_error out varchar2,
                                        vo_tip_error out varchar2);
  procedure SP_CREDITOS_UPD_RCAJA(VE_AQPB556COD  IN NUMBER,
                                  VE_AQPB556INST IN NUMBER,
                                  VE_AQPB556VAR  IN VARCHAR,
                                  VE_AQPB556VAL  IN VARCHAR,
                                  VE_MESSAGE     OUT VARCHAR);
  PROCEDURE SP_CR_Tasa_Interes(P_Emp       in number,
                               P_Modulo    in number,
                               P_Cod_Age   in number,
                               P_Moneda    in number,
                               p_Papel     in number,
                               P_Cuenta    in number,
                               P_Operacion in number,
                               P_SubTipo   in number,
                               P_Tipo      in number,
                               P_tasa      out number);

  procedure SP_CRD_SAVE_APROB_PRP(VE_AQPB556COD  in number,
                                  VE_AQPB556INST in number,
                                  VE_CARGO       in number,
                                  VE_APROBADOR   in varchar,
                                  VE_MENSAJE     in varchar);

  PROCEDURE SP_CRD_SAVE_APROB_AUT(VE_AQPB556COD  in number,
                                  VE_AQPB556INST in number,
                                  VE_MENSAJE     in varchar);

  PROCEDURE SP_CRD_SAVE_CAMBIO_PRP(VE_AQPB556COD  in number,
                                   VE_AQPB556INST in number,
                                   VE_MENSAJE     in varchar);

  PROCEDURE SP_CRD_OBTENER_APROBADOR(ve_cargo       number,
                                     ve_sucursal    number,
                                     vo_usuario     OUT varchar,
                                     vo_usuario_sup OUT varchar);
  PROCEDURE SP_OBTENER_TASA_CAJA(ve_aqpb556cod number,
                                 ve_instancia  number,
                                 ve_nuevaTasa  out number,
                                 ve_preduccion out number,
                                 ve_montocap   out number,
                                 ve_facilidad  out varchar,
                                 ve_rpta       out varchar);
  PROCEDURE SP_OBT_INST_COD_RPG(ve_pgcod     in number,
                                ve_mod       in number,
                                ve_suc       in number,
                                ve_mda       in number,
                                ve_pap       in number,
                                ve_cta       in number,
                                ve_ope       in number,
                                ve_sbo       in number,
                                ve_top       in number,
                                ve_codigo    out number,
                                ve_instancia out number);
  PROCEDURE sp_grabar_cronograma(ve_codigo    IN number,
                                 ve_instancia IN number,
                                 ve_pgcod     in number,
                                 ve_mod       in number,
                                 ve_suc       in number,
                                 ve_mda       in number,
                                 ve_pap       in number,
                                 ve_cta       in number,
                                 ve_ope       in number,
                                 ve_sbo       in number,
                                 ve_top       in number,
                                 VE_ARCHIVO   IN VARCHAR);
  --apachecoh 06/01/2023
  PROCEDURE sp_pasar_masiv_indv(ve_fec  in date,
                                ve_cod  in number,
                                ve_est  in varchar,
                                ve_user in varchar,
                                ve_msj  out varchar);

  PROCEDURE SP_CRD_LOG_APROB_AQPD157(VE_AQPB556COD IN NUMBER,
                                     VE_INSTANCIA  IN NUMBER,
                                     VE_FECHARPG   IN DATE,
                                     VE_CARGO_APR  IN NUMBER,
                                     VE_CORREOS    IN VARCHAR,
                                     VE_ESTADO     IN VARCHAR,
                                     VE_USR_APR    IN VARCHAR,
                                     VE_MENSAJE    IN VARCHAR,
                                     VO_COD_ERROR  OUT VARCHAR,
                                     VO_MSG_ERROR  OUT VARCHAR);
  PROCEDURE SP_CARGAR_AUTORIZANTES(VE_AQPB556COD IN NUMBER,
                                   VE_INSTANCIA  IN NUMBER,
                                   
                                   VO_COD_ERROR OUT VARCHAR,
                                   VO_MSG_ERROR OUT VARCHAR);
  PROCEDURE sp_obtener_data_jaqa400(VE_AQPB556COD IN NUMBER,
                                    VE_INSTANCIA  IN NUMBER,
                                    
                                    VO_ANALISTA  OUT VARCHAR,
                                    VO_CMTAEC    OUT VARCHAR,
                                    VO_CMTDCR    OUT VARCHAR,
                                    VO_CMTVP     OUT VARCHAR,
                                    VO_COD_ERROR OUT VARCHAR,
                                    VO_MSG_ERROR OUT VARCHAR);
  PROCEDURE SP_GRABAR_APROBACION(VE_FECHAREG  IN DATE,
                                 VE_CODREPROG IN NUMBER,
                                 VE_INSTANCIA IN NUMBER,
                                 --
                                 VE_UBUSER     IN VARCHAR,
                                 VE_COMENTARIO IN VARCHAR,
                                 VE_ESTADO     IN VARCHAR,
                                 --
                                 VO_CODERROR OUT VARCHAR,
                                 VO_MSGERROR OUT VARCHAR);
  PROCEDURE SP_GRABAR_LOG_ERRORES(VE_INSTANCIA IN NUMBER,
                                  VE_PROGRAMA  IN VARCHAR,
                                  VE_PAQUETE   IN VARCHAR,
                                  VE_PROCED    IN VARCHAR,
                                  VE_PEJE      IN VARCHAR,
                                  VE_ERR       IN VARCHAR,
                                  VE_MSG       IN VARCHAR);
  PROCEDURE SP_ENVIAR_CORREO_PAPR(VE_FECHAREG   IN DATE,
                                  VE_CODREPROG  IN NUMBER,
                                  VE_INSTANCIA  IN NUMBER,
                                  VE_ESTADO     IN VARCHAR,
                                  VE_USR_APROBR IN VARCHAR,
                                  VO_CODERROR   OUT VARCHAR,
                                  VO_MSGERROR   OUT VARCHAR);
  PROCEDURE SP_OBTENER_CORREOS_AQPD157(VE_FECHAREG      IN DATE,
                                       VE_CODREPROG     IN NUMBER,
                                       VE_INSTANCIA     IN NUMBER,
                                       VO_CORREOS_APROB OUT VARCHAR,
                                       VO_CODERROR      OUT VARCHAR,
                                       VO_MSGERROR      OUT VARCHAR);
  PROCEDURE SP_OBTENER_SGTE_APR(VE_FECHAREG      IN DATE,
                                VE_CODREPROG     IN NUMBER,
                                VE_INSTANCIA     IN NUMBER,
                                VO_USUARIO_APROB OUT VARCHAR,
                                VO_CARGO_APROB   OUT VARCHAR,
                                VO_CORREOS_APROB OUT VARCHAR,
                                VO_CODERROR      OUT VARCHAR,
                                VO_MSGERROR      OUT VARCHAR);
  PROCEDURE SP_LOG_CORREO(VE_FECHAREG    IN DATE,
                          VE_CODREPROG   IN NUMBER,
                          VE_INSTANCIA   IN NUMBER,
                          VE_ESTADO      IN VARCHAR,
                          VE_USR_APROBR  IN VARCHAR,
                          VE_MENSAJE_LOG IN VARCHAR,
                          lv_destinos    IN VARCHAR,
                          lv_destinos_c  IN VARCHAR,
                          VO_CODERROR    OUT VARCHAR,
                          VO_MSGERROR    OUT VARCHAR);
  PROCEDURE SP_VALIDAR_TIPO_REPROGD(VIE_N_COREPROG IN NUMBER,
                                    VIE_N_INSTANCE IN NUMBER,
                                    VOE_N_COD_TRPG OUT NUMBER,
                                    VOE_V_DSC_TRPG OUT VARCHAR);

  PROCEDURE SP_CR_MANT_ARBOL_APROB(P_MODO      IN VARCHAR2,
                                   P_TPOREPROG IN NUMBER,
                                   P_GRUPO     IN NUMBER,
                                   P_NVLAPROB  IN NUMBER,
                                   P_CGOAPROB  IN NUMBER,
                                   P_PFLAPROB  IN VARCHAR2,
                                   P_DEPAPROB  IN NUMBER,
                                   P_USUREG    IN VARCHAR2,
                                   P_IMPMIN    IN NUMBER,
                                   P_IMPMAX    IN NUMBER,
                                   P_APROBREQ  IN VARCHAR2);
end pq_cr_reprog_sin_cap;
/
create or replace package body pq_cr_reprog_sin_cap is
  -- Author  : HSUAREZ
  -- Created : 29/01/2021 09:42:39
  -- Purpose : Paquete para reprogramacion de creditos sin capitalizacion
  -- MOdificacion: Hsuarez
  -- Fecha Modificacion: 27/09/2023 12:52
  -- Contenido: Se agrego un tipo de reprogramacion para los del listado de BI sin consultar a CRM.
  -- Fecha Modificacion:23/01/2024 12:52
  -- Contenido: Se modifico el arbol de aprobacion para reprogramados CAJA segun MEMO18-2024.
  -- Fecha Modificacion:11/04/2024 12:52 
  -- Autor: HSUAREZ 
  -- Contenido: Se modifico el proceso para añadir arbol de aprobacion multinivel
  -- Fecha Modificacion:11/06/2024 12:52 
  -- Autor: HSUAREZ 
  -- Contenido: Se modifico el proceso de Tipo de Reprogramacion, para inicializar el arbol multinivel, se mejoro el proceso obtner Aprobador.
  -- Contenido: Se modifico el proceso para añadir arbol de aprobacion multinivel
  -- Fecha Modificacion:14/06/2024 12:52 
  -- Autor: HSUAREZ 
  -- Contenido: Se agrego un proceso para manejar log de secuencias.
  function sp_obtener_lista(ve_est  in varchar,
                            ve_cta  in varchar,
                            ve_pais in number,
                            ve_tdoc in number,
                            ve_ndoc in varchar,
                            ve_fecc in date)
    return pq_cr_reprog_sin_cap.list_cred_cur is
  
    curref pq_cr_reprog_sin_cap.list_cred_cur;
  begin
    begin
      open curref for
        SELECT F.AQPB556COD,
               F.AQPB556DNI,
               (SELECT PENOM
                  FROM FSD001
                 WHERE PEPAIS = F.AQPB556PAIS
                   AND PETDOC = F.AQPB556PTDC
                   AND PENDOC = F.AQPB556DNI) AQPB556NOMB,
               
               F.AQPB556EMP,
               F.AQPB556MOD,
               F.AQPB556SUC,
               F.AQPB556MDA,
               F.AQPB556PAP,
               F.AQPB556CTA,
               F.AQPB556OPER,
               F.AQPB556SBOP,
               F.AQPB556TOP,
               
               F.AQPB556SCAP,
               F.AQPB556EST,
               CASE
                 WHEN AQPB556EST = 'A' THEN
                  'APROBADO'
                 WHEN AQPB556EST = 'P' THEN
                  'PENDIENTE'
                 WHEN AQPB556EST = 'R' THEN
                  'RECHAZADO'
               END AQPB556DEST,
               
               --DETALLE
               F.AQPB556FECR,
               F.AQPB556FECM,
               
               D.AQPB556DCUOA,
               D.AQPB556DCUON,
               D.AQPB556DFRCA,
               D.AQPB556DFRCN,
               D.AQPB556DFCIA,
               D.AQPB556DFCIN,
               D.AQPB556DFVCA,
               D.AQPB556DFVCN
        
          from AQPB556 F, AQPB556D D
         WHERE (F.AQPB556EST = ve_est OR ve_est is null)
           AND (F.AQPB556CTA = ve_cta OR ve_cta is null)
           AND (F.AQPB556PAIS = ve_pais OR ve_pais is null)
           AND (F.AQPB556PTDC = ve_tdoc OR ve_ndoc is null)
           AND (F.AQPB556DNI = ve_ndoc OR ve_ndoc is null)
           AND (trunc(f.Aqpb556fecm) = ve_fecc OR ve_fecc is null)
           AND F.AQPB556COD = D.AQPB556DCOD
           AND F.AQPB556EHAB = 'H';
    
      return curref;
    exception
      when others then
        null;
    end;
  end;

  function fn_gestionar_cred(ve_cod  in number,
                             ve_est  in varchar,
                             ve_user in varchar) return varchar is
    --pq_cr_reprog_sin_cap.list_cred_cur is
    --curref pq_cr_reprog_sin_cap.list_cred_cur;
    cursor lista_aqpb556 is
      select t.*
        from aqpb556 t
       where t.aqpb556cod = ve_cod
         and t.aqpb556ehab = 'H'
         and t.aqpb556est IN ('A', 'R')
         and rownum = 1;
  
    msj            varchar(255);
    err_num        NUMBER;
    err_msg        VARCHAR2(255);
    aux_est        varchar(1);
    vi_aqpb556tprg number(4);
  begin
    vi_aqpb556tprg := 0;
    begin
      select aqpb556tprg
        into vi_aqpb556tprg
        from aqpb556
       where aqpb556est = 'P'
         and aqpb556cod = ve_cod
         and aqpb556ehab = 'H';
    exception
      when others then
        null;
    end;
    if vi_aqpb556tprg = 1 then
      if ve_est = 'A' or ve_est = 'R' then
        begin
          UPDATE AQPB556
             SET AQPB556EST  = ve_est,
                 AQPB556USRM = ve_user,
                 AQPB556FECM = SYSDATE
           WHERE AQPB556COD = ve_cod
             AND AQPB556EST = 'P'
             AND AQPB556EHAB = 'H';
          msj := 'ok';
          COMMIT;
        exception
          when others then
            err_msg := SQLERRM;
            msj     := err_msg;
        end;
      
        IF VE_EST = 'A' THEN
          aux_est := 'C';
        ELSE
          aux_est := '';
        END IF;
      
        begin
          for x in lista_aqpb556 loop
            UPDATE JAQA400 J
               SET JAQA400EST = aux_est
             WHERE J.JAQA400EMP = x.aqpb556emp
               AND J.JAQA400MOD = x.aqpb556mod
               AND J.JAQA400SUC = x.aqpb556suc
               AND J.JAQA400MDA = x.aqpb556mda
               AND J.JAQA400PAP = x.aqpb556pap
               AND J.JAQA400CTA = x.aqpb556cta
               AND J.JAQA400OPE = x.aqpb556opeR
               AND J.JAQA400SBO = x.aqpb556sbop
               AND J.JAQA400TOP = x.aqpb556top
               AND J.JAQA400FEC = (select MAX(JAQA400FEC)
                                     FROM JAQA400 D
                                    WHERE D.JAQA400EMP = x.aqpb556emp
                                      AND D.JAQA400MOD = x.aqpb556mod
                                      AND D.JAQA400SUC = x.aqpb556suc
                                      AND D.JAQA400MDA = x.aqpb556mda
                                      AND D.JAQA400PAP = x.aqpb556pap
                                      AND D.JAQA400CTA = x.aqpb556cta
                                      AND D.JAQA400OPE = x.aqpb556opeR
                                      AND D.JAQA400SBO = x.aqpb556sbop
                                      AND D.JAQA400TOP = x.aqpb556top
                                   /*AND D.JAQA400EST = 'A'*/
                                   );
            /*AND J.JAQA400EST = 'A';*/
            COMMIT;
          end loop;
        exception
          when others then
            null;
        end;
        /*  
        begin
          open curref for
         SELECT  
               F.AQPB556COD,
               F.AQPB556DNI,
               (SELECT PENOM FROM FSD001 WHERE PEPAIS=F.AQPB556PAIS AND PETDOC=F.AQPB556PTDC AND PENDOC=F.AQPB556DNI)  AQPB556NOMB,
               
               F.AQPB556EMP,
               F.AQPB556MOD,
               F.AQPB556SUC,
               F.AQPB556MDA,
               F.AQPB556PAP,
               F.AQPB556CTA,
               F.AQPB556OPER,
               F.AQPB556SBOP,
               F.AQPB556TOP,
               
               F.AQPB556SCAP,
               F.AQPB556EST,
               CASE WHEN AQPB556EST='A' THEN 'APROBADO' 
                    WHEN AQPB556EST='P' THEN 'PENDIENTE'
                    WHEN AQPB556EST='R' THEN 'RECHAZADO'
                 END AQPB556DEST,
                 
               --DETALLE
               F.AQPB556FECR,
               F.AQPB556FECM,
               
               D.AQPB556DCUOA,
               D.AQPB556DCUON,
               D.AQPB556DFRCA,
               D.AQPB556DFRCN,
               D.AQPB556DFCIA,
               D.AQPB556DFCIN,
               D.AQPB556DFVCA,
               D.AQPB556DFVCN  
         from AQPB556 F, AQPB556D D
         where f.aqpb556cod = ve_cod;
         return curref;
        end;  
        */
      else
        msj := 'El estado seleccionado, Solo puede ser Aprobado o Rechazado';
      end if;
    else
      msj := 'El Tipo de Reprogramación no es COVID, reprogramaciones diferentes se aprueban desde Bantotal';
    end if;
    COMMIT;
    return msj;
  end;
  PROCEDURE sp_gestionar_credito(ve_cod  in number,
                                 ve_est  in varchar,
                                 ve_user in varchar,
                                 ve_msj  out varchar) is
  
    cursor lista_aqpb556 is
      select t.*
        from aqpb556 t
       where t.aqpb556cod = ve_cod
         and t.aqpb556ehab = 'H'
         and t.aqpb556est IN ('A', 'R')
         and rownum = 1;
  
    aux_est varchar(1);
  begin
  
    IF ve_est = 'A' or ve_est = 'R' then
      begin
        UPDATE AQPB556
           SET AQPB556EST  = ve_est,
               AQPB556USRM = ve_user,
               AQPB556FECM = SYSDATE
         WHERE AQPB556COD = ve_cod
           AND AQPB556EHAB = 'H'
           AND AQPB556EST = 'P';
        ve_msj := 'Se han aplicado los cambios';
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          ve_msj := 'No se han podido aplicar los cambios, consulte al administrador';
      end;
    END IF;
  
    IF VE_EST = 'A' OR VE_EST = 'R' THEN
      IF VE_EST = 'A' THEN
        aux_est := 'C';
      ELSE
        aux_est := '';
      END IF;
      begin
        for x in lista_aqpb556 loop
          UPDATE JAQA400 J
             SET JAQA400EST = aux_est
           WHERE J.JAQA400EMP = x.aqpb556emp
             AND J.JAQA400MOD = x.aqpb556mod
             AND J.JAQA400SUC = x.aqpb556suc
             AND J.JAQA400MDA = x.aqpb556mda
             AND J.JAQA400PAP = x.aqpb556pap
             AND J.JAQA400CTA = x.aqpb556cta
             AND J.JAQA400OPE = x.aqpb556opeR
             AND J.JAQA400SBO = x.aqpb556sbop
             AND J.JAQA400TOP = x.aqpb556top
             AND J.JAQA400FEC = (select MAX(JAQA400FEC)
                                   FROM JAQA400 D
                                  WHERE D.JAQA400EMP = x.aqpb556emp
                                    AND D.JAQA400MOD = x.aqpb556mod
                                    AND D.JAQA400SUC = x.aqpb556suc
                                    AND D.JAQA400MDA = x.aqpb556mda
                                    AND D.JAQA400PAP = x.aqpb556pap
                                    AND D.JAQA400CTA = x.aqpb556cta
                                    AND D.JAQA400OPE = x.aqpb556opeR
                                    AND D.JAQA400SBO = x.aqpb556sbop
                                    AND D.JAQA400TOP = x.aqpb556top
                                 /*AND D.JAQA400EST = 'A'*/
                                 );
          --AND J.JAQA400EST = 'A';
          COMMIT;
        end loop;
      exception
        when others then
          null;
      end;
    END IF;
    --end if;
    commit;
  end;

  PROCEDURE SP_VALIDAR_JAQA400(pn_emp in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               pv_out out varchar) is
  begin
  
    begin
      pv_out := 'N';
      select 'S'
        into pv_out
        FROM JAQA400 D
       WHERE D.JAQA400EMP = pn_emp
         AND D.JAQA400MOD = pn_mod
         AND D.JAQA400SUC = pn_suc
         AND D.JAQA400MDA = pn_mda
         AND D.JAQA400PAP = pn_pap
         AND D.JAQA400CTA = pn_cta
         AND D.JAQA400OPE = pn_ope
         AND D.JAQA400SBO = pn_sbo
         AND D.JAQA400TOP = pn_top
         AND D.JAQA400EST = 'C';
    exception
      when others then
        pv_out := 'N';
    end;
  
  end;
  PROCEDURE sp_pasar_covit_indv(ve_cod  in number,
                                ve_est  in varchar,
                                ve_user in varchar,
                                ve_msj  out varchar) is
    cursor lista_aqpb556 is
      select t.*
        from aqpb556 t
       where t.aqpb556cod = ve_cod
         and t.aqpb556ehab = 'H'
         and t.aqpb556est = 'A'
         and rownum = 1;
    vi_fecha date;
    vi_err   number;
    vi_merr  varchar(100);
  BEGIN
    IF ve_est = 'C' then
    
      BEGIN
        for x in lista_aqpb556 loop
          --ACTUALIZANDO EL ESTADO EN LA TABLA DE REPROGRMACION DEL ANALISTA
          UPDATE JAQA400 J
             SET J.JAQA400AC1 = ve_est
           WHERE J.JAQA400EMP = x.aqpb556emp
             AND J.JAQA400MOD = x.aqpb556mod
             AND J.JAQA400SUC = x.aqpb556suc
             AND J.JAQA400MDA = x.aqpb556mda
             AND J.JAQA400PAP = x.aqpb556pap
             AND J.JAQA400CTA = x.aqpb556cta
             AND J.JAQA400OPE = x.aqpb556opeR
             AND J.JAQA400SBO = x.aqpb556sbop
             AND J.JAQA400TOP = x.aqpb556top
             AND J.JAQA400EST = 'C'
             AND J.JAQA400FEC = (select MAX(JAQA400FEC)
                                   FROM JAQA400 D
                                  WHERE D.JAQA400EMP = x.aqpb556emp
                                    AND D.JAQA400MOD = x.aqpb556mod
                                    AND D.JAQA400SUC = x.aqpb556suc
                                    AND D.JAQA400MDA = x.aqpb556mda
                                    AND D.JAQA400PAP = x.aqpb556pap
                                    AND D.JAQA400CTA = x.aqpb556cta
                                    AND D.JAQA400OPE = x.aqpb556opeR
                                    AND D.JAQA400SBO = x.aqpb556sbop
                                    AND D.JAQA400TOP = x.aqpb556top
                                    AND D.JAQA400EST = 'C');
          commit;
          BEGIN
            select pgfape into vi_fecha from fst017 where pgcod = 1;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          sp_cr_correo_aprobacion(p_n_pgcod  => x.aqpb556emp,
                                  p_n_scsuc  => x.aqpb556suc,
                                  p_n_scmda  => x.aqpb556mda,
                                  p_n_scpap  => x.aqpb556pap,
                                  p_n_sccta  => x.aqpb556cta,
                                  p_n_scoper => x.aqpb556opeR,
                                  p_n_scsbop => x.aqpb556sbop,
                                  p_n_sctope => x.aqpb556top,
                                  p_n_scmod  => x.aqpb556mod,
                                  p_v_ubuser => ve_user,
                                  p_v_tipo   => 'T',
                                  p_d_pgfape => vi_fecha,
                                  p_n_coderr => vi_err,
                                  p_c_msgerr => vi_merr);
        END LOOP;
        --ACTUALIZANDO EL ESTADO EN LA TABLA DE APROBACION
        UPDATE AQPB556 A
           SET A.AQPB556TCOV  = ve_est,
               A.AQPB556PUSRR = ve_user,
               A.AQPB556FECCP = SYSDATE
         WHERE AQPB556COD = ve_cod
           AND AQPB556EST = 'A'
           AND AQPB556EHAB = 'H';
        COMMIT;
        ve_msj := 'Se traslado de Unilateral a Consensuada';
      
      EXCEPTION
        WHEN OTHERS THEN
          ve_msj := 'No se han podido aplicar los cambios, consulte al administrador';
      END;
    ELSE
      ve_msj := 'Spolo puede seleccionar Unilateral, no existe otro';
    END IF;
    commit;
  END;
  PROCEDURE sp_creditos_upd_lstcovt(ve_cod  in number,
                                    ve_user in varchar,
                                    ve_msj  out varchar) is
  
    /*
    cursor lista_aqpb556 is
        select t.*
          from aqpb556 t
         where t.aqpb556cod = ve_cod
           and t.aqpb556ehab= 'H'
           and t.aqpb556est = 'A'
           and rownum = 1;
    */
    TRPGCOVIT char(1);
  begin
    TRPGCOVIT := 'X';
    begin
      --ACTUALIZAR TIPO DE REPROGRAMACION, 
      --for x in lista_aqpb556 loop
      SELECT TRIM(J.JAQA400AC1)
        INTO TRPGCOVIT
        FROM JAQA400 J, AQPB556 T
       WHERE J.JAQA400EMP = T.aqpb556emp
         AND J.JAQA400MOD = T.aqpb556mod
         AND J.JAQA400SUC = T.aqpb556suc
         AND J.JAQA400MDA = T.aqpb556mda
         AND J.JAQA400PAP = T.aqpb556pap
         AND J.JAQA400CTA = T.aqpb556cta
         AND J.JAQA400OPE = T.aqpb556opeR
         AND J.JAQA400SBO = T.aqpb556sbop
         AND J.JAQA400TOP = T.aqpb556top
         AND T.AQPB556COD = ve_cod
         AND T.AQPB556EHAB = 'H'
         AND T.AQPB556EST = 'A'
         AND J.JAQA400FEC = (select MAX(JAQA400FEC)
                               FROM JAQA400 D
                              WHERE D.JAQA400EMP = T.aqpb556emp
                                AND D.JAQA400MOD = T.aqpb556mod
                                AND D.JAQA400SUC = T.aqpb556suc
                                AND D.JAQA400MDA = T.aqpb556mda
                                AND D.JAQA400PAP = T.aqpb556pap
                                AND D.JAQA400CTA = T.aqpb556cta
                                AND D.JAQA400OPE = T.aqpb556opeR
                                AND D.JAQA400SBO = T.aqpb556sbop
                                AND D.JAQA400TOP = T.aqpb556top
                             /*AND D.JAQA400EST = 'A'*/
                             )
         AND ROWNUM = 1;
      --end loop;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    end;
    BEGIN
      IF TRPGCOVIT IN ('C', 'U') THEN
        UPDATE AQPB556
           SET AQPB556TCOV = TRPGCOVIT
         WHERE AQPB556COD = ve_cod
           AND AQPB556EST = 'A'
           AND AQPB556EHAB = 'H'
           AND (AQPB556TCOV IS NULL OR TRIM(AQPB556TCOV) = '');
        COMMIT;
      END IF;
    exception
      when others then
        null;
    END;
  end;

  PROCEDURE sp_creditos_upd_lstcovd(ve_cod  in number,
                                    ve_user in varchar,
                                    ve_msj  out varchar) is
  
    /*
    cursor lista_aqpb556 is
        select t.*
          from aqpb556 t
         where t.aqpb556cod = ve_cod
           and t.aqpb556ehab= 'H'
           and t.aqpb556est = 'A'
           and rownum = 1;
    */
    TRPGCOVIT char(1);
  begin
    TRPGCOVIT := 'X';
    begin
      --ACTUALIZAR TIPO DE REPROGRAMACION, 
      --for x in lista_aqpb556 loop
      SELECT TRIM(J.JAQA400AC1)
        INTO TRPGCOVIT
        FROM JAQA400 J, AQPB556 T
       WHERE J.JAQA400EMP = T.aqpb556emp
         AND J.JAQA400MOD = T.aqpb556mod
         AND J.JAQA400SUC = T.aqpb556suc
         AND J.JAQA400MDA = T.aqpb556mda
         AND J.JAQA400PAP = T.aqpb556pap
         AND J.JAQA400CTA = T.aqpb556cta
         AND J.JAQA400OPE = T.aqpb556opeR
         AND J.JAQA400SBO = T.aqpb556sbop
         AND J.JAQA400TOP = T.aqpb556top
         AND T.AQPB556COD = ve_cod
         AND T.AQPB556EHAB = 'H'
         AND T.AQPB556EST = 'P'
         AND J.JAQA400FEC = (select MAX(JAQA400FEC)
                               FROM JAQA400 D
                              WHERE D.JAQA400EMP = T.aqpb556emp
                                AND D.JAQA400MOD = T.aqpb556mod
                                AND D.JAQA400SUC = T.aqpb556suc
                                AND D.JAQA400MDA = T.aqpb556mda
                                AND D.JAQA400PAP = T.aqpb556pap
                                AND D.JAQA400CTA = T.aqpb556cta
                                AND D.JAQA400OPE = T.aqpb556opeR
                                AND D.JAQA400SBO = T.aqpb556sbop
                                AND D.JAQA400TOP = T.aqpb556top
                             /*AND D.JAQA400EST = 'A'*/
                             )
         AND ROWNUM = 1;
      --end loop;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    end;
    BEGIN
      IF TRPGCOVIT IN ('C', 'U') THEN
        UPDATE AQPB556
           SET AQPB556TCOV = TRPGCOVIT
         WHERE AQPB556COD = ve_cod
           AND AQPB556EST = 'P'
           AND AQPB556EHAB = 'H'
           AND (AQPB556TCOV IS NULL OR TRIM(AQPB556TCOV) = '');
        COMMIT;
      END IF;
    exception
      when others then
        null;
    END;
  end;
  PROCEDURE SP_CRD_TCOVIT_MAIL(P_N_PGCOD  IN number,
                               P_N_SCSUC  IN number,
                               P_N_SCMDA  IN number,
                               P_N_SCPAP  IN number,
                               P_N_SCCTA  IN number,
                               P_N_SCOPER IN number,
                               P_N_SCSBOP IN number,
                               P_N_SCTOPE IN number,
                               P_N_SCMOD  IN number,
                               P_V_UBUSER IN varchar2,
                               P_V_TIPO   IN varchar2,
                               P_D_PGFAPE IN date,
                               p_n_coderr out number,
                               p_c_msgerr out varchar2) is
    p_c_coderr     char(2);
    vanalista      wfusers.wfusrcod%type;
    vcapital       number(17, 2);
    vsaldocons     number(17, 2);
    vi_AQPB556PTDC fsr008.petdoc%type;
    vi_AQPB556DNI  fsr008.pendoc%type;
    vi_AQPB556INST xwf700.xwfprcins%type;
    vi_aqpb556pais fsr008.pepais%type;
    vcliente       fsd001.penom%type;
    lv_correog     varchar(100);
    lv_correoa     varchar(100);
    lv_cuentat     VARCHAR2(100);
    vmosign        fst005.mosign%type;
    flag_enc       char(1);
    vi_pFechaN     date;
    vi_TIPOCAMBIO  number(10, 6);
    vi_AQPB556CONS number(17, 2);
    vi_dcargo      varchar2(100);
    --
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);
    lv_remitente  VARCHAR2(90);
    lv_asunto     VARCHAR2(200);
    lv_directorio VARCHAR2(30);
    lv_destinos   VARCHAR2(4000) := '';
    lv_destinos_c VARCHAR2(4000) := '';
    v_mensaje_a   varchar(100);
  BEGIN
  
    p_c_coderr := '00';
    --CORREO DEL USUAIRO QUE REALIZO EL CAMBIO
    begin
      select wfusremail
        into lv_correog
        from WFUSERS
       where trim(wfusrcod) = trim(P_V_UBUSER);
    exception
      when others then
        p_c_coderr := '05';
        p_c_msgerr := 'No se encontr? correo del Usuario que realizo el cambio';
    end;
  
    if p_c_coderr = '00' then
      begin
        select y.penom,
               x.aqpb556scap,
               x.aqpb556usrr,
               x.aqpb556scons,
               x.aqpb556pais,
               x.aqpb556ptdc,
               x.aqpb556dni,
               x.Aqpb556inst
          into vcliente,
               vcapital,
               vanalista,
               vsaldocons,
               vi_aqpb556pais,
               vi_AQPB556PTDC,
               vi_AQPB556DNI,
               vi_AQPB556INST
          from aqpb556 x, fsd001 y
         where x.aqpb556pais = y.pepais
           and x.aqpb556ptdc = y.petdoc
           and rpad(x.aqpb556dni, 12, ' ') = y.pendoc
           and x.aqpb556emp = P_N_PGCOD
           and x.aqpb556mod = P_N_SCMOD
           and x.aqpb556suc = P_N_SCSUC
           and x.aqpb556mda = P_N_SCMDA
           and x.aqpb556pap = P_N_SCPAP
           and x.aqpb556cta = P_N_SCCTA
           and x.aqpb556oper = P_N_SCOPER
           and x.aqpb556sbop = P_N_SCSBOP
           and x.aqpb556top = P_N_SCTOPE
           AND x.aqpb556ehab = 'H'
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      end;
      begin
        select wfusremail
          into lv_correoa
          from WFUSERS
         where wfusrcod = vanalista;
      exception
        when others then
          p_c_coderr := '05';
          p_c_msgerr := 'No se encontr? correo analista';
      end;
    end if;
  
    if p_c_coderr = '00' then
    
      lv_cuentat := 'cuenta ' || trim(to_char(P_N_SCCTA)) ||
                    ' y operaci?n ' || trim(to_char(P_N_SCOPER)) || ' por ' ||
                    trim(vmosign) ||
                    trim(to_char(vcapital, '9,999,999.99'));
      dbms_lob.createtemporary(ll_mensaje, TRUE);
    
      Case
        WHEN P_V_TIPO = 'T' THEN
          vi_dcargo := 'Analista';
          --EXTRAYENDO DESCRIPCION DEL CARGO.
          /*
          BEGIN
            SELECT s.sng055dsc
            INTO vi_dcargo FROM SNG055 s WHERE s.SNG055CAR=vi_cargo;
          EXCEPTION WHEN OTHERS THEN vi_dcargo:='Gerente';
          END;        
          */
          ----------------------------------------------  
          lv_destinos   := lv_correog;
          lv_destinos_c := lv_correoa;
          lv_mensaje    := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado ' ||
                           vi_dcargo || ',</p>' ||
                           '<p "font-family: Arial, sans-serif; font-size: 14px;">se realizo el cambio a su credito pediente de aprobacion de Unilateral a Individual de ' ||
                           lv_cuentat || '<br />' || trim(v_mensaje_a) ||
                           '.</p>';
      end case;
      lv_remitente := 'notificacionesbantotal@cajaarequipa.pe';
      lv_asunto    := 'REPROGRAMACION CLIENTE COVIT ' ||
                      upper(trim(vcliente));
    
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    
      lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Atentamente<br/>Caja Arequipa</strong></p>';
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    
      begin
        -- Call the procedure
        pq_ah_planillas.p_sendmailattach(p_destinatariospara => TRIM(lv_destinos),
                                         p_destinatarioscc   => TRIM(lv_destinos_c),
                                         p_destinatariosbcc  => '',
                                         p_mensaje           => '-', --ll_mensaje,
                                         p_remitente         => TRIM(lv_remitente),
                                         p_asunto            => '-', --TRIM(lv_asunto),
                                         p_tipomensaje       => 'HTML',
                                         p_directorio        => '',
                                         p_archivosadjuntos  => '',
                                         p_c_coderr          => p_c_coderr,
                                         p_c_deserr          => p_c_msgerr);
      exception
        when others then
          p_c_coderr := '99';
          p_c_msgerr := sqlerrm;
      end;
    
      dbms_lob.freetemporary(ll_mensaje);
    end if;
    p_n_coderr := to_number(p_c_coderr);
  END;

  PROCEDURE SP_CRD_TIPO_REPROGRAMACION(codigo    in number,
                                       instancia in number,
                                       vo_tprpg  out number) IS
    vi_cuenta     number(9);
    vi_operacion  number(9);
    vi_tireprog   number(4);
    vi_cant_caja  number(3);
    vi_cant_cov   number(3);
    vi_cant_gob   number(3);
    vi_cant_fondo number(3);
    --
    vi_cant_bi     NUMBER(9);
    VE_NRO_RPG     NUMBER(9);
    VE_CARGO_APROB NUMBER(9);
    VE_APROBADOR   VARCHAR(20);
    VE_RPTA        VARCHAR(10);
    vi_tipo_reprog VARCHAR(30);
    VO_COD_ERROR   VARCHAR(4);
    VO_MSG_ERROR   VARCHAR(150);
    --
  BEGIN
    vi_tireprog := 0;
    --COMENTAR SOLO HANILITA PARA PRUEBA EL PRUEBA_LOG
    --insert into prueba_log(PGCOD,msg)values(250,''||codigo||'-'||instancia||'-'||vo_tprpg);commit;
    BEGIN
      SELECT A.AQPB556CTA, A.AQPB556OPER
        INTO vi_cuenta, vi_operacion
        FROM AQPB556 A
       WHERE A.AQPB556INST = instancia
         AND A.AQPB556EHAB = 'H'
         AND A.AQPB556EST = 'P';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    -- VALIDAR QUE TIPO DE REPROGRAMACION ES COVIT;
    BEGIN
      select count(*)
        INTO vi_cant_cov
        from reprog F
       where SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             vi_cuenta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = vi_operacion
         AND F.ESTADOSOLICITUD IN ('BT', 'AP'); --06.07.2021;
      select TIPOREPROGRAMACION
        INTO vi_tipo_reprog
        from reprog F
       where SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             vi_cuenta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = vi_operacion
         AND F.ESTADOSOLICITUD IN ('BT', 'AP')
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        vi_cant_cov := 0;
    END;
    -- VALIDAR SI ES CAJA/GOBIERNO
    BEGIN
      SELECT count(*)
        INTO vi_cant_caja
        FROM LEY31050 L
       INNER JOIN LEY31050_CREDITOSFACILIDAD F
          ON L.IDLEY31050 = F.IDLEY31050
       WHERE L.ESTADOSOLICITUD = 'BT'
         AND L.TIPOFACILIDAD = 'CAJA'
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             vi_cuenta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = vi_operacion; --AGREGAR CLAVE DEL CREDITO
    EXCEPTION
      WHEN OTHERS THEN
        vi_cant_caja := 0;
    END;
    BEGIN
      SELECT count(*)
        INTO vi_cant_gob
        FROM LEY31050 L
       INNER JOIN LEY31050_CREDITOSFACILIDAD F
          ON L.IDLEY31050 = F.IDLEY31050
       WHERE L.ESTADOSOLICITUD = 'BT'
         AND L.TIPOFACILIDAD = 'GOBIERNO'
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             vi_cuenta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = vi_operacion; -- AGREGAR CLAVE CREDITO.
    EXCEPTION
      WHEN OTHERS THEN
        vi_cant_caja := 0;
    END;
    BEGIN
      SELECT count(*)
        INTO vi_cant_fondo
        FROM FONDOS L
       INNER JOIN FONDOS_CREDITOSFACILIDAD F
          ON L.IDFONDO = F.IDFONDO
       WHERE L.ESTADOSOLICITUD = 'BT'
            --AND L.TIPOFACILIDAD = 'GOBIERNO'
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             vi_cuenta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = vi_operacion; -- AGREGAR CLAVE CREDITO.
    EXCEPTION
      WHEN OTHERS THEN
        vi_cant_caja := 0;
    END;
    --AGREGADO PROCESO PARA VALIDAR SI EXISTE EN EL LISTADO DE BI.
    BEGIN
      --AGREGAR PAQUETE PARA VALIDAR.
      pq_cr_validar_rng_reprog.SP_VALIDAR_LISTA_BI(instancia,
                                                   VE_NRO_RPG,
                                                   VE_CARGO_APROB,
                                                   VE_APROBADOR,
                                                   VE_RPTA);
      IF VE_CARGO_APROB > 201 THEN
        vi_cant_bi := 1;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        vi_cant_bi := 0;
    END;
  
    --ACTUALIZAMOS TABLA AQPB556 CON EL TIPO DE REPROGRAMACION QUE TIENE
    IF vi_cant_bi > 0 then
      vi_tireprog := 6; -- LISTADO DE BI
    END IF;
    IF vi_cant_caja > 0 then
      vi_tireprog := 3; --LISTADO CRM CAJA.
    END IF;
    IF vi_cant_gob > 0 then
      vi_tireprog := 2; --LISTADO CRM GOBIERNO
    END IF;
    IF vi_cant_fondo > 0 then
      vi_tireprog := 4; --LISTADO CRM FONDO
    END IF;
    IF vi_cant_cov > 0 then
      vi_tireprog := 1; --LISTADO CRM COVID
      IF TRIM(vi_tipo_reprog) <> 'COVID' OR vi_tipo_reprog IS NULL THEN
        vi_tireprog := 7; --REPROGRAMADOS 2024 NO COVID
      END IF;
    END IF;
    IF vi_tireprog = 0 THEN
      vi_tireprog := 10;
    END IF;
    BEGIN
      --INSERT INTO PRUEBA_LOG(pgcod,MSG)VALUES(525,'CODIGO:'||codigo||'-'||INSTANCIA||'-'||vi_tireprog);
      UPDATE aqpb556 a
         set a.aqpb556tprg   = vi_tireprog,
             a.aqpb556fecrpg = to_date(TO_CHAR(AQPB556FECR, 'dd/mm/rrrr'),
                                       'DD/MM/RRRR')
       WHERE a.aqpb556cod = codigo
         AND a.aqpb556inst = instancia
         AND a.aqpb556est = 'P'
         AND a.aqpb556ehab = 'H';
      COMMIT;
      vo_tprpg := vi_tireprog;
    exception
      when others then
        null;
    END;
    --CARGAR AUTORIZANTES
    IF vi_tireprog = 10 then
      BEGIN
        PQ_CR_REPROG_SIN_CAP.SP_CARGAR_AUTORIZANTES(codigo,
                                                    instancia,
                                                    VO_COD_ERROR,
                                                    VO_MSG_ERROR);
        null;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    end if;
  END;

  PROCEDURE SP_CRD_ARBOL_APROBACION(codigo    in number,
                                    instancia in number,
                                    vo_cargo  out number) is
    vo_plazoh number(4);
    vo_plazoc number(4);
    vo_gracia number(4);
    vo_plazor number(4);
    vo_monto  number(17, 2);
    vo_tasa   number(17, 6);
  
    vo_gradiente    number(5); -- 19.10.2022 cambio a number(5)
    vi_SaldoCap     number(17, 2);
    vi_cargo_mont   number(4);
    vi_cargo_pzo_r  number(4);
    vi_cargo_grac   number(4);
    vi_cargo_grad   number(4);
    vi_cargo_tasa   number(4);
    vi_cargo_plaz   number(4);
    vi_cuenta       number(9);
    vi_flag_l31050  number(3);
    vi_operacion    number(9);
    vi_situacion    varchar(50);
    vi_codigo_monto number(4);
    vi_perfil       varchar(30);
  BEGIN
    --MONTO
    BEGIN
    
      SELECT T.AQPB556SCAP
        INTO vi_SaldoCap
        FROM AQPB556 T
       WHERE T.AQPB556INST = instancia
            --AND T.AQPB556EST='P'
         AND T.AQPB556EHAB = 'H'
         AND AQPB556COD = (SELECT MAX(AQPB556COD)
                             FROM AQPB556 A
                            WHERE A.AQPB556INST = instancia
                              AND A.AQPB556EHAB = 'H');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT F.TP1NRO1, F.TP1CORR3
        INTO vi_cargo_mont, vi_codigo_monto
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 10899
         AND F.TP1CORR1 = 400000
         AND F.TP1CORR2 = 60 --11
         AND TP1IMP1 <= vi_SaldoCap
         AND TP1IMP2 >= vi_SaldoCap;
    EXCEPTION
      WHEN OTHERS THEN
        vi_cargo_mont   := 0;
        vi_codigo_monto := 0;
    END;
  
    --VALIDAR PRIMERO PLAZO RESIDUAL
  
    PQ_CR_RNG_REPROG_HS.sp_cr_plazo_matriz(instancia, vo_plazoh);
    PQ_CR_RNG_REPROG_HS.sp_cr_plazo_crd_caj(instancia, vo_plazoc);
    --IF vo_plazoh<vo_plazoc THEN 2024.01.22 Comentado.
    --PQ_CR_RNG_REPROG_HS.sp_cr_plazo_residual(instancia,
    --                                         vo_plazor);
  
    PQ_CR_RNG_REPROG_HS.sp_cr_plazo_residual_2024(instancia, vo_plazor);
    BEGIN
      SELECT F.TP1NRO1, TRIM(F.TP1DESC)
        INTO vi_cargo_pzo_r, vi_perfil
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 10899
         AND F.TP1CORR1 = 400000
         AND F.TP1CORR2 = 61 --8
         AND F.TP1IMP1 <= vo_plazor
         AND F.TP1IMP2 >= vo_plazor
         AND F.tp1nro2 = vi_codigo_monto;
    EXCEPTION
      WHEN OTHERS THEN
        SELECT F.TP1NRO1, TRIM(F.TP1DESC)
          INTO vi_cargo_pzo_r, vi_perfil
          FROM FST198 F
         WHERE F.TP1COD = 1
           AND F.TP1COD1 = 10899
           AND F.TP1CORR1 = 400000
           AND F.TP1CORR2 = 61 --8
           AND F.TP1IMP1 <= vo_plazor
           AND F.TP1IMP2 >= vo_plazor;
    END;
    --END IF;
  
    --------------------------------------------------
    --VALIDAR SEGUNDO GRACIA
    PQ_CR_RNG_REPROG_HS.sp_cr_gracia_caj(instancia, vo_gracia, vo_monto);
    BEGIN
      SELECT F.TP1NRO1
        INTO vi_cargo_grac
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 10899
         AND F.TP1CORR1 = 400000
         AND F.TP1CORR2 = 62 --6
         AND F.TP1IMP1 <= vo_gracia
         AND F.TP1IMP2 >= vo_gracia
         AND F.tp1nro2 = vi_codigo_monto;
    exception
      when no_data_found then
        SELECT min(F.TP1NRO1)
          INTO vi_cargo_grac
          FROM FST198 F
         WHERE F.TP1COD = 1
           AND F.TP1COD1 = 10899
           AND F.TP1CORR1 = 400000
           AND F.TP1CORR2 = 6
           AND F.TP1IMP1 <= vo_gracia
           AND F.TP1IMP2 >= vo_gracia;
      
    END;
    --------------------------------------------------                                     
    --VALIDAR GRADIENTE
    PQ_CR_RNG_REPROG_HS.sp_cr_gradiente_caj(instancia, vo_gradiente);
    BEGIN
      SELECT F.TP1NRO1
        INTO vi_cargo_grad
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 10899
         AND F.TP1CORR1 = 400000
         AND F.TP1CORR2 = 63 --7
         AND F.TP1IMP1 <= vo_gradiente
         AND F.TP1IMP2 >= vo_gradiente
         AND F.tp1nro2 = vi_codigo_monto;
    exception
      when no_data_found then
        SELECT min(F.TP1NRO1)
          INTO vi_cargo_grad
          FROM FST198 F
         WHERE F.TP1COD = 1
           AND F.TP1COD1 = 10899
           AND F.TP1CORR1 = 400000
           AND F.TP1CORR2 = 63 --7
           AND F.TP1IMP1 <= vo_gradiente
           AND F.TP1IMP2 >= vo_gradiente;
    END;
    --------------------------------------------------                    
    ---VALIDAR TASA/
  
    vi_cargo_tasa := 0; -- POREL MOMENTO HASTA DEFINIR.
    --OBTENER TASA, CUENTA OPERACION
    BEGIN
      SELECT A.JAQA400AI2, A.JAQA400CTA, A.JAQA400OPE
        INTO vo_tasa, vi_cuenta, vi_operacion
        FROM JAQA400 A
       WHERE A.JAQA400AI1 = instancia
         AND A.JAQA400FEC =
             (SELECT MAX(B.JAQA400FEC)
                FROM JAQA400 B
               WHERE B.JAQA400AI1 = instancia);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --OBTENER SITUACION
  
    BEGIN
      SELECT count(*)
        INTO vi_flag_l31050
        FROM LEY31050 L
       INNER JOIN LEY31050_CREDITOSFACILIDAD F
          ON L.IDLEY31050 = F.IDLEY31050
       WHERE L.ESTADOSOLICITUD = 'BT'
         AND L.TIPOFACILIDAD = 'CAJA'
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             vi_cuenta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = vi_operacion;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF vi_flag_l31050 > 0 THEN
    
      BEGIN
        SELECT LOWER(L.SITUACIONNEGOCIO)
          INTO vi_situacion
          FROM LEY31050_CREDITOSFACILIDAD L
         WHERE SUBSTR(L.CUENTAOPERACION,
                      0,
                      INSTR(L.CUENTAOPERACION, '-') - 1) = vi_cuenta
           AND SUBSTR(L.CUENTAOPERACION,
                      INSTR(L.CUENTAOPERACION, '-') + 1,
                      99) = vi_operacion;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      IF TRIM(vi_situacion) = 'con pago de deudas no financieras' then
        vi_situacion := 'con pago de deudas no financi';
      END IF;
    end if;
  
    --REVISAR GUIA DE PROCESO ESPECIAL DE LA TASA.
    /*
    BEGIN
       SELECT F.TP1NRO1
        INTO vi_cargo_tasa
        FROM FST198 F
       WHERE F.TP1COD   = 1
         AND F.TP1COD1  = 10899
         AND F.TP1CORR1 = 400000
         AND F.TP1CORR2 = 9
         AND F.TP1IMP1 <= vo_tasa
         AND F.TP1IMP2 >= vo_tasa
         AND F.TP1DESC = rpad(vi_situacion, 30, ' ');
    EXCEPTION 
      WHEN OTHERS THEN
        vi_cargo_tasa:=230; --CUALQUIER EXCEPCION A LA MATRIZ A GERENCIA DE CREDITOS.         
    END; 
    */
    ---VALIDAR EL MAXIMO CARGO
    vo_cargo := vi_cargo_mont;
    IF vo_cargo < vi_cargo_pzo_r THEN
      vo_cargo := vi_cargo_pzo_r;
    END IF;
    IF vo_cargo < vi_cargo_grac THEN
      vo_cargo := vi_cargo_grac;
    END IF;
    IF vo_cargo < vi_cargo_grad THEN
      vo_cargo := vi_cargo_grad;
    END IF;
    IF vo_cargo < vi_cargo_tasa THEN
      vo_cargo := vi_cargo_tasa;
    END IF;
  
  END;
  PROCEDURE SP_CRD_ARBOL_APROBACION_CAJA2024(codigo    in number,
                                             instancia in number,
                                             vo_cargo  out number,
                                             vo_perfil out varchar) is
    vo_plazoh number(4);
    vo_plazoc number(4);
    vo_gracia number(4);
    vo_plazor number(4);
    vo_monto  number(17, 2);
    vo_tasa   number(17, 6);
  
    vo_gradiente   number(5); -- 19.10.2022 cambio a number(5)
    vi_SaldoCap    number(17, 2);
    vi_cargo_mont  number(4);
    vi_cargo_pzo_r number(4);
    vi_cargo_grac  number(4);
    vi_cargo_grad  number(4);
    vi_cargo_tasa  number(4);
    vi_cargo_plaz  number(4);
  
    vi_cuenta       number(9);
    vi_flag_l31050  number(3);
    vi_operacion    number(9);
    vi_situacion    varchar(50);
    vi_codigo_monto number(4);
    vi_perfil_mont  varchar(30);
    vi_perfil_pzo   varchar(30);
    vi_perfil_grac  varchar(30);
    vi_perfil_grad  varchar(30);
    vi_auxiliar_per number(3);
  
  BEGIN
    --OBTENER SALDO CAPITAL
    BEGIN
      SELECT T.AQPB556SCAP
        INTO vi_SaldoCap
        FROM AQPB556 T
       WHERE T.AQPB556INST = instancia
            --AND T.AQPB556EST='P'
         AND T.AQPB556EHAB = 'H'
         AND AQPB556COD = (SELECT MAX(AQPB556COD)
                             FROM AQPB556 A
                            WHERE A.AQPB556INST = instancia
                              AND A.AQPB556EHAB = 'H');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --OBTENER CARGO POR MONTO      
    BEGIN
      SELECT F.TP1NRO1, F.TP1CORR3, TRIM(F.TP1DESC)
        INTO vi_cargo_mont, vi_codigo_monto, vi_perfil_mont
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 10899
         AND F.TP1CORR1 = 400000
         AND F.TP1CORR2 = 60 --11
         AND TP1IMP1 <= vi_SaldoCap
         AND TP1IMP2 >= vi_SaldoCap;
    EXCEPTION
      WHEN OTHERS THEN
        vi_cargo_mont   := 0;
        vi_codigo_monto := 0;
    END;
    --OBTENER EL PLAZO RESIDUAL DEL CREDITO.           
    BEGIN
      PQ_CR_RNG_REPROG_HS.sp_cr_plazo_residual_2024(instancia, vo_plazor);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --OBTENER EL CARGO POR MATRIZ DE PLAZO RESIDUAL                                                     
    BEGIN
      SELECT F.TP1NRO1, trim(F.TP1DESC)
        INTO vi_cargo_pzo_r, vi_perfil_pzo
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 10899
         AND F.TP1CORR1 = 400000
         AND F.TP1CORR2 = 61 --8
         AND F.TP1IMP1 <= vo_plazor
         AND F.TP1IMP2 >= vo_plazor
         AND F.tp1nro2 = vi_codigo_monto;
    EXCEPTION
      WHEN OTHERS THEN
        SELECT F.TP1NRO1, TRIM(F.TP1DESC)
          INTO vi_cargo_pzo_r, vi_perfil_pzo
          FROM FST198 F
         WHERE F.TP1COD = 1
           AND F.TP1COD1 = 10899
           AND F.TP1CORR1 = 400000
           AND F.TP1CORR2 = 61 --8
           AND F.TP1IMP1 <= vo_plazor
           AND F.TP1IMP2 >= vo_plazor
           AND ROWNUM = 1;
    END;
    --------------------------------------------------
    --VALIDAR SEGUNDO GRACIA
    PQ_CR_RNG_REPROG_HS.sp_cr_gracia_caj(instancia, vo_gracia, vo_monto);
    BEGIN
      SELECT F.TP1NRO1, trim(F.tp1desc)
        INTO vi_cargo_grac, vi_perfil_grac
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 10899
         AND F.TP1CORR1 = 400000
         AND F.TP1CORR2 = 62 --6
         AND F.TP1IMP1 <= vo_gracia
         AND F.TP1IMP2 >= vo_gracia
         AND F.tp1nro2 = vi_codigo_monto;
    exception
      when no_data_found then
        begin
          SELECT F.TP1NRO1, trim(F.tp1desc)
            INTO vi_cargo_grac, vi_perfil_grac
            FROM FST198 F
           WHERE F.TP1COD = 1
             AND F.TP1COD1 = 10899
             AND F.TP1CORR1 = 400000
             AND F.TP1CORR2 = 62
             AND F.TP1IMP1 <= vo_gracia
             AND F.TP1IMP2 >= vo_gracia
             and ROWNUM = 1;
        exception
          when others then
            null;
        end;
    END;
    --------------------------------------------------                                     
    --VALIDAR GRADIENTE
    BEGIN
      PQ_CR_RNG_REPROG_HS.sp_cr_gradiente_caj(instancia, vo_gradiente);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      SELECT F.TP1NRO1, TRIM(F.TP1DESC)
        INTO vi_cargo_grad, VI_PERFIL_GRAD
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 10899
         AND F.TP1CORR1 = 400000
         AND F.TP1CORR2 = 63 --7
         AND F.TP1IMP1 <= vo_gradiente
         AND F.TP1IMP2 >= vo_gradiente
         AND F.tp1nro2 = vi_codigo_monto;
    exception
      when no_data_found then
        begin
          SELECT min(F.TP1NRO1), TRIM(F.TP1DESC)
            INTO vi_cargo_grad, VI_PERFIL_GRAD
            FROM FST198 F
           WHERE F.TP1COD = 1
             AND F.TP1COD1 = 10899
             AND F.TP1CORR1 = 400000
             AND F.TP1CORR2 = 63 --7
             AND F.TP1IMP1 <= vo_gradiente
             AND F.TP1IMP2 >= vo_gradiente
             and rownum = 1;
        exception
          when others then
            null;
        end;
    END;
  
    ---VALIDAR EL MAXIMO CARGO
    vo_cargo := vi_cargo_mont;
    IF vo_cargo < vi_cargo_pzo_r THEN
      vo_cargo := vi_cargo_pzo_r;
    END IF;
    IF vo_cargo < vi_cargo_grac THEN
      vo_cargo := vi_cargo_grac;
    END IF;
    IF vo_cargo < vi_cargo_grad THEN
      vo_cargo := vi_cargo_grad;
    END IF;
    IF vo_cargo < vi_cargo_tasa THEN
      vo_cargo := vi_cargo_tasa;
    END IF;
    --VALIDAR MAXIMO PERFIL
    IF vi_perfil_pzo = 'JZON01' or vi_perfil_grac = 'JZON01' or
       vi_perfil_grad = 'JZON01' or vi_perfil_mont = 'JZON01' then
      vo_perfil := 'JZON01';
    end if;
    IF vi_perfil_pzo = 'GREG01' or vi_perfil_grac = 'GREG01' or
       vi_perfil_grad = 'GREG01' or vi_perfil_mont = 'GREG01' then
      vo_perfil := 'GREG01';
    end if;
    IF vi_perfil_pzo = 'GCRE01' or vi_perfil_grac = 'GCRE01' or
       vi_perfil_grad = 'GCRE01' or vi_perfil_mont = 'GCRE01' then
      vo_perfil := 'GCRE01';
    end if;
  END;
  PROCEDURE SP_CR_Tasa_Interes(P_Emp       in number,
                               P_Modulo    in number,
                               P_Cod_Age   in number,
                               P_Moneda    in number,
                               p_Papel     in number,
                               P_Cuenta    in number,
                               P_Operacion in number,
                               P_SubTipo   in number,
                               P_Tipo      in number,
                               P_tasa      out number) is
    -- *****************************************************************
    -- Nombre                     : BT_Tasa_Interes
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.12
    -- Autor de Creación          : Abernedo
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:   
    -- *****************************************************************
  
    pn_Tasa_Interes fsd012.evtasa%type;
  begin
  
    begin
      select nvl(d_012.evtasa, 0)
        into pn_Tasa_Interes
        from fsd012 d_012
       where d_012.pgcod = P_Emp
         and d_012.aomod = P_Modulo
         and d_012.aosuc = P_Cod_Age
         and d_012.aomda = P_Moneda
         and d_012.aopap = p_Papel
         and d_012.aocta = P_Cuenta
         and d_012.aooper = P_Operacion
         and d_012.aosbop = P_SubTipo
         and d_012.aotope = P_Tipo
         and d_012.evtipo = 3
         and d_012.evcorr = (select max(d_012a.evcorr)
                               from fsd012 d_012a
                              where d_012a.pgcod = P_Emp
                                and d_012a.aomod = P_Modulo
                                and d_012a.aosuc = P_Cod_Age
                                and d_012a.aomda = P_Moneda
                                and d_012a.aopap = p_Papel
                                and d_012a.aocta = P_Cuenta
                                and d_012a.aooper = P_Operacion
                                and d_012a.aosbop = P_SubTipo
                                and d_012a.aotope = P_Tipo
                                and d_012a.evtipo = 3
                                and d_012a.d012co = 'S')
         and d_012.d012co = 'S';
    exception
      when no_data_found then
        pn_Tasa_Interes := -1;
      WHEN OTHERS THEN
        NULL;
    end;
    if pn_Tasa_Interes = -1 then
      begin
        select nvl(d_010.aotasa, 0)
          into pn_Tasa_Interes
          from fsd010 d_010
         where d_010.pgcod = P_Emp
           and d_010.aomod = P_Modulo
           and d_010.aosuc = P_Cod_Age
           and d_010.aomda = P_Moneda
           and d_010.aopap = p_Papel
           and d_010.aocta = P_Cuenta
           and d_010.aooper = P_Operacion
           and d_010.aosbop = P_SubTipo
           and d_010.aotope = P_Tipo
           and d_010.aostat <> 99;
      exception
        when no_data_found then
          pn_Tasa_Interes := -1;
        WHEN OTHERS THEN
          NULL;
      end;
    end if;
    if pn_Tasa_Interes = -1 then
      pn_Tasa_Interes := 0;
    end if;
    P_tasa := pn_Tasa_Interes;
  end SP_CR_Tasa_Interes;

  procedure SP_CR_EXCP_REPRO(PN_INST IN NUMBER,
                             PN_USR  OUT VARCHAR2,
                             PN_CODE OUT NUMBER,
                             PV_MSGE OUT VARCHAR2) is
  
    lv_instancia NUMBER(10);
    ------  
    my_errm VARCHAR2(32000);
  BEGIN
    PN_CODE := 0;
    BEGIN
      SELECT AQPB556INST
        INTO lv_instancia
        FROM AQPB556
       WHERE AQPB556INST = PN_INST
         AND AQPB556EHAB = 'H'
         AND AQPB556EST = 'P';
    EXCEPTION
      WHEN no_data_found THEN
        PN_CODE := 1;
        PV_MSGE := 'NO SE ENCONTRO LA INSTANCIA.';
      WHEN too_many_rows THEN
        PN_CODE := 2;
        PV_MSGE := 'SE ENCONTRO MAS DE UN RESULTADO.';
      WHEN OTHERS THEN
        PN_CODE := 3;
        my_errm := SQLERRM;
        PV_MSGE := my_errm;
    END;
  
    IF PN_CODE = 0 THEN
      BEGIN
        SELECT TP1DESC
          INTO PN_USR
          FROM fst198
         WHERE TP1COD = 1
           AND TP1COD1 = 10899
           AND TP1CORR1 = 400000
           AND TP1CORR2 = 10
           AND TP1NRO1 = PN_INST;
      EXCEPTION
        WHEN no_data_found THEN
          PN_CODE := 4;
          PV_MSGE := 'INSTANCIA NO ESTA EN LA GUIA.';
        WHEN too_many_rows THEN
          PN_CODE := 5;
          PV_MSGE := 'SE ENCONTRO MAS DE UN RESULTADO.';
        WHEN OTHERS THEN
          PN_CODE := 6;
          my_errm := SQLERRM;
          PV_MSGE := my_errm;
      END;
    END IF;
  end SP_CR_EXCP_REPRO;

  procedure SP_CREDITOS_UPD_RCAJA(VE_AQPB556COD  IN NUMBER,
                                  VE_AQPB556INST IN NUMBER,
                                  VE_AQPB556VAR  IN VARCHAR,
                                  VE_AQPB556VAL  IN VARCHAR,
                                  VE_MESSAGE     OUT VARCHAR) is
    VI_TASAPROPUESTA NUMBER(10, 6);
    vi_nuevaTasa     number(10, 6);
    vi_preduccion    number(10, 6);
    vi_montocap      number(17, 2);
    vi_facilidad     varchar(30);
    ve_rpta          varchar(100);
  BEGIN
    IF VE_AQPB556VAR = 'TASA_PROPUESTA' THEN
      BEGIN
        SELECT TRIM(J.JAQA400AI2)
          INTO VI_TASAPROPUESTA
          FROM JAQA400 J, AQPB556 T
         WHERE J.JAQA400EMP = T.aqpb556emp
           AND J.JAQA400MOD = T.aqpb556mod
           AND J.JAQA400SUC = T.aqpb556suc
           AND J.JAQA400MDA = T.aqpb556mda
           AND J.JAQA400PAP = T.aqpb556pap
           AND J.JAQA400CTA = T.aqpb556cta
           AND J.JAQA400OPE = T.aqpb556opeR
           AND J.JAQA400SBO = T.aqpb556sbop
           AND J.JAQA400TOP = T.aqpb556top
           AND T.AQPB556COD = VE_AQPB556COD
           AND T.AQPB556INST = VE_AQPB556INST
           AND T.AQPB556EHAB = 'H'
           AND T.AQPB556EST = 'P'
           AND J.JAQA400FEC = (select MAX(JAQA400FEC)
                                 FROM JAQA400 D
                                WHERE D.JAQA400EMP = T.aqpb556emp
                                  AND D.JAQA400MOD = T.aqpb556mod
                                  AND D.JAQA400SUC = T.aqpb556suc
                                  AND D.JAQA400MDA = T.aqpb556mda
                                  AND D.JAQA400PAP = T.aqpb556pap
                                  AND D.JAQA400CTA = T.aqpb556cta
                                  AND D.JAQA400OPE = T.aqpb556opeR
                                  AND D.JAQA400SBO = T.aqpb556sbop
                                  AND D.JAQA400TOP = T.aqpb556top
                               /*AND D.JAQA400EST = 'A'*/
                               )
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      BEGIN
        PQ_CR_REPROG_SIN_CAP.SP_OBTENER_TASA_CAJA(VE_AQPB556COD,
                                                  VE_AQPB556INST,
                                                  vi_nuevaTasa,
                                                  vi_preduccion,
                                                  vi_montocap,
                                                  vi_facilidad,
                                                  ve_rpta);
        VI_TASAPROPUESTA := vi_nuevaTasa;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      BEGIN
        UPDATE AQPB556 G
           SET G.AQPB556RCPA = VI_TASAPROPUESTA
         WHERE G.AQPB556COD = VE_AQPB556COD
           AND G.AQPB556INST = VE_AQPB556INST
           AND G.AQPB556EHAB = 'H'
           AND G.AQPB556EST = 'P';
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
    IF VE_AQPB556VAR = 'TASA_ACEPTADA' THEN
      VI_TASAPROPUESTA := CAST(VE_AQPB556VAL AS FLOAT);
      BEGIN
        UPDATE AQPB556 G
           SET G.AQPB556RCAP = VI_TASAPROPUESTA
         WHERE G.AQPB556COD = VE_AQPB556COD
           AND G.AQPB556INST = VE_AQPB556INST
           AND G.AQPB556EHAB = 'H'
           AND G.AQPB556EST = 'P';
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
    IF VE_AQPB556VAR = 'TASA_APROBADA_CAJA' THEN
      VI_TASAPROPUESTA := CAST(VE_AQPB556VAL AS FLOAT);
      BEGIN
        UPDATE AQPB556 G
           SET G.AQPB556TSAP = VI_TASAPROPUESTA
         WHERE G.AQPB556COD = VE_AQPB556COD
           AND G.AQPB556INST = VE_AQPB556INST
           AND G.AQPB556EHAB = 'H'
           AND G.AQPB556EST = 'P';
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  END;

  procedure SP_CRD_SAVE_APROB_PRP(VE_AQPB556COD  in number,
                                  VE_AQPB556INST in number,
                                  VE_CARGO       in number,
                                  VE_APROBADOR   in varchar,
                                  VE_MENSAJE     in varchar) is
  BEGIN
    BEGIN
      UPDATE AQPB556 F
         SET F.AQPB556USRA = VE_APROBADOR,
             F.AQPB556CARA = VE_CARGO,
             F.AQPB556MAIL = VE_MENSAJE
       WHERE F.AQPB556COD = VE_AQPB556COD
         AND F.AQPB556INST = VE_AQPB556INST;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;
  PROCEDURE SP_CRD_SAVE_APROB_AUT(VE_AQPB556COD  in number,
                                  VE_AQPB556INST in number,
                                  VE_MENSAJE     in varchar) is
  BEGIN
    BEGIN
      UPDATE AQPB556 F
         SET F.AQPB556MAILA = VE_MENSAJE
       WHERE F.AQPB556COD = VE_AQPB556COD
         AND F.AQPB556INST = VE_AQPB556INST;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;

  PROCEDURE SP_CRD_SAVE_CAMBIO_PRP(VE_AQPB556COD  in number,
                                   VE_AQPB556INST in number,
                                   VE_MENSAJE     in varchar) is
  BEGIN
    BEGIN
      UPDATE AQPB556 F
         SET F.AQPB556MAILC = VE_MENSAJE
       WHERE F.AQPB556COD = VE_AQPB556COD
         AND F.AQPB556INST = VE_AQPB556INST;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;

  PROCEDURE SP_CRD_ARBOL_APROBACION_RNG(instancia    in number,
                                        vo_ind_error out varchar2,
                                        vo_tip_error out varchar2) is
    vo_plazoh number(4);
    vo_plazoc number(4);
    vo_gracia number(4);
    vo_plazor number(4);
    vo_monto  number(17, 2);
    vo_tasa   number(17, 6);
  
    vo_gradiente    number(5); -- 19.10.2022 cambio a number(5) de number(3)
    vi_SaldoCap     number(17, 2);
    vi_cargo_mont   number(4);
    vi_cargo_pzo_r  number(4);
    vi_cargo_grac   number(4);
    vi_cargo_grad   number(4);
    vi_cargo_tasa   number(4);
    vi_cargo_plaz   number(4);
    vi_cuenta       number(9);
    vi_flag_l31050  number(3);
    vi_operacion    number(9);
    vi_situacion    varchar(50);
    vi_codigo_monto number(4);
  
    vi_emp fsd010.pgcod%type;
    vi_mod fsd010.aomod%type;
    vi_suc fsd010.aosuc%type;
    vi_mda fsd010.aomda%type;
    vi_pap fsd010.aopap%type;
    vi_cta fsd010.aocta%type;
    vi_ope fsd010.aooper%type;
    vi_sbo fsd010.aosbop%type;
    vi_top fsd010.aotope%type;
  BEGIN
    vo_ind_error := 'S';
    vo_tip_error := '';
  
    /*
    vo_ind_error := 'S';
    vo_tip_error := ''; 
    RETURN;
    */
    --MONTO
    BEGIN
      select j.jaqa400emp,
             j.jaqa400mod,
             j.jaqa400suc,
             j.jaqa400mda,
             j.jaqa400pap,
             j.jaqa400cta,
             j.jaqa400ope,
             j.jaqa400sbo,
             j.jaqa400top
        into vi_emp,
             vi_mod,
             vi_suc,
             vi_mda,
             vi_pap,
             vi_cta,
             vi_ope,
             vi_sbo,
             vi_top
        from jaqa400 j
       where j.jaqa400ai1 = instancia
         and j.jaqa400fec = (select max(jaqa400fec)
                               from jaqa400
                              where jaqa400ai1 = instancia);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      SELECT D.SCSDO * -1
        INTO vi_SaldoCap
        FROM FSD011 D
       WHERE D.PGCOD = vi_emp
         AND D.SCSUC = vi_suc
         AND D.SCMOD = vi_mod
         AND D.SCSUC = vi_suc
         AND D.SCMDA = vi_mda
         AND D.SCPAP = vi_pap
         AND D.SCCTA = vi_cta
         AND D.SCOPER = vi_ope
         AND D.SCSBOP = vi_sbo
         AND D.SCTOPE = vi_top
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    /*           
    BEGIN
      SELECT T.AQPB556SCAP
        INTO vi_SaldoCap
        FROM AQPB556 T WHERE T.AQPB556INST = instancia
         AND T.AQPB556EHAB='H';
    EXCEPTION WHEN OTHERS THEN
      NULL;     
      END;
    */
    BEGIN
      SELECT F.TP1NRO1, F.TP1CORR3
        INTO vi_cargo_mont, vi_codigo_monto
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 10899
         AND F.TP1CORR1 = 400000
         AND F.TP1CORR2 = 5
         AND TP1IMP1 <= vi_SaldoCap
         AND TP1IMP2 >= vi_SaldoCap;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --VALIDAR PRIMERO PLAZO RESIDUAL
    PQ_CR_RNG_REPROG_HS.sp_cr_plazo_matriz(instancia, vo_plazoh);
    PQ_CR_RNG_REPROG_HS.sp_cr_plazo_crd_caj(instancia, vo_plazoc);
    IF vo_plazoh < vo_plazoc THEN
      PQ_CR_RNG_REPROG_HS.sp_cr_plazo_residual(instancia, vo_plazor);
      BEGIN
        SELECT F.TP1NRO1
          INTO vi_cargo_pzo_r
          FROM FST198 F
         WHERE F.TP1COD = 1
           AND F.TP1COD1 = 10899
           AND F.TP1CORR1 = 400000
           AND F.TP1CORR2 = 8
           AND F.TP1IMP1 <= vo_plazor
           AND F.TP1IMP2 >= vo_plazor
           AND F.tp1nro2 = vi_codigo_monto;
      EXCEPTION
        WHEN OTHERS THEN
          vi_cargo_pzo_r := 0;
      END;
    END IF;
  
    --------------------------------------------------
    --VALIDAR SEGUNDO GRACIA
    PQ_CR_RNG_REPROG_HS.sp_cr_gracia_caj(instancia, vo_gracia, vo_monto);
    BEGIN
      SELECT F.TP1NRO1
        INTO vi_cargo_grac
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 10899
         AND F.TP1CORR1 = 400000
         AND F.TP1CORR2 = 6
         AND F.TP1IMP1 <= vo_gracia
         AND F.TP1IMP2 >= vo_gracia
         AND F.tp1nro2 = vi_codigo_monto;
    exception
      when no_data_found then
        BEGIN
          SELECT min(F.TP1NRO1)
            INTO vi_cargo_grac
            FROM FST198 F
           WHERE F.TP1COD = 1
             AND F.TP1COD1 = 10899
             AND F.TP1CORR1 = 400000
             AND F.TP1CORR2 = 6
             AND F.TP1IMP1 <= vo_gracia
             AND F.TP1IMP2 >= vo_gracia;
        EXCEPTION
          WHEN OTHERS THEN
            vo_ind_error := 'N';
            vo_tip_error := 'GRACIA';
            RETURN;
        END;
    END;
    --------------------------------------------------                                     
    --VALIDAR GRADIENTE
    PQ_CR_RNG_REPROG_HS.sp_cr_gradiente_caj(instancia, vo_gradiente);
    BEGIN
      SELECT F.TP1NRO1
        INTO vi_cargo_grad
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 10899
         AND F.TP1CORR1 = 400000
         AND F.TP1CORR2 = 7
         AND F.TP1IMP1 <= vo_gradiente
         AND F.TP1IMP2 >= vo_gradiente
         AND F.tp1nro2 = vi_codigo_monto;
    exception
      when no_data_found then
        BEGIN
          SELECT min(F.TP1NRO1)
            INTO vi_cargo_grad
            FROM FST198 F
           WHERE F.TP1COD = 1
             AND F.TP1COD1 = 10899
             AND F.TP1CORR1 = 400000
             AND F.TP1CORR2 = 7
             AND F.TP1IMP1 <= vo_gradiente
             AND F.TP1IMP2 >= vo_gradiente;
        EXCEPTION
          WHEN OTHERS THEN
            vo_ind_error := 'N';
            vo_tip_error := 'GRADIENTE';
            RETURN;
        END;
    END;
    --------------------------------------------------                    
    ---VALIDAR TASA
    vi_cargo_tasa := 0; -- POREL MOMENTO HASTA DEFINIR.
    --OBTENER TASA, CUENTA OPERACION
    BEGIN
      SELECT A.JAQA400AI2, A.JAQA400CTA, A.JAQA400OPE
        INTO vo_tasa, vi_cuenta, vi_operacion
        FROM JAQA400 A
       WHERE A.JAQA400AI1 = instancia
         AND A.JAQA400FEC =
             (SELECT MAX(B.JAQA400FEC)
                FROM JAQA400 B
               WHERE B.JAQA400AI1 = instancia);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    /*
    --OBTENER SITUACION
    BEGIN
      SELECT count(*)
      INTO vi_flag_l31050
      FROM LEY31050 L
     INNER JOIN LEY31050_CREDITOSFACILIDAD F
        ON L.IDLEY31050 = F.IDLEY31050
     WHERE L.ESTADOSOLICITUD = 'BT'
       AND L.TIPOFACILIDAD = 'CAJA'
       AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION, '-') - 1)  = vi_cuenta
       AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION, '-') + 1,99) = vi_operacion;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;  
    END;
    IF vi_flag_l31050 > 0 THEN
    BEGIN
      SELECT L.SITUACIONCLIENTE 
      INTO vi_situacion
      FROM LEY31050_CREDITOS L
      WHERE SUBSTR(L.CUENTAOPERACION,0,INSTR(L.CUENTAOPERACION, '-') - 1)  = vi_cuenta
        AND SUBSTR(L.CUENTAOPERACION,INSTR(L.CUENTAOPERACION, '-') + 1,99) = vi_operacion;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;  
      END;
    end if; 
    */
    --REVISAR GUIA DE PROCESO ESPECIAL DE LA TASA.
    BEGIN
      SELECT F.TP1NRO1
        INTO vi_cargo_tasa
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 10899
         AND F.TP1CORR1 = 400000
         AND F.TP1CORR2 = 9
         AND F.TP1IMP1 <= vo_tasa
         AND F.TP1IMP2 >= vo_tasa
         AND F.TP1DESC = rpad(vi_situacion, 30, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        vi_cargo_tasa := 230; --CUALQUIER EXCEPCION A LA MATRIZ A GERENCIA DE CREDITOS.         
        vo_ind_error  := 'N';
        vo_tip_error  := 'TASA';
        RETURN;
    END;
  
    /*
    ---VALIDAR EL MAXIMO CARGO
    vo_cargo := vi_cargo_mont;
    IF vo_cargo < vi_cargo_pzo_r THEN
      vo_cargo:= vi_cargo_pzo_r;
    END IF;
    IF vo_cargo < vi_cargo_grac THEN
      vo_cargo:= vi_cargo_grac;
    END IF;
    IF vo_cargo < vi_cargo_grad THEN
      vo_cargo:= vi_cargo_grad;
    END IF;
    IF vo_cargo < vi_cargo_tasa THEN
      vo_cargo:= vi_cargo_tasa;
    END IF;
    */
  
  END;

  PROCEDURE SP_CRD_OBTENER_APROBADOR(ve_cargo       number,
                                     ve_sucursal    number,
                                     vo_usuario     OUT varchar,
                                     vo_usuario_sup OUT varchar) is
    VI_REGCOD NUMBER(3);
  BEGIN
    --OBTENER REGION DE LA SUCURSAL DEL CRÉDITO
    VI_REGCOD := 0;
    BEGIN
      SELECT F.REGCOD
        INTO VI_REGCOD
        FROM FST811 F
       WHERE F.PGCOD = 1
         AND F.OFICOD = VE_SUCURSAL
         AND F.REGCOD < 100;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --OBTENER USUARIO SI CARGO ES 220
    IF VE_CARGO = 202 THEN
      BEGIN
        SELECT S.SNG057USR
          INTO VO_USUARIO
          FROM FST046 F4, SNG057 S, FST811 F, PRFU00 p
         WHERE F4.PGCOD = S.SNG055EMP
           AND F4.UBUSER = S.SNG057USR
           AND F4.UBSUC = F.OFICOD
           AND S.SNG055CAR = VE_CARGO
           AND S.SNG057AUT = 'S'
           AND F.PGCOD = S.SNG055EMP
           AND F.OFICOD = VE_SUCURSAL
           AND P.PGCOD = F4.PGCOD
           AND P.UBUSER = F4.UBUSER
           AND P.PRFGCOD <> rpad('CESADO', 10, ' ')
           AND ROWNUM = 1;
      EXCEPTION
        --04.02.2022
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
    IF VE_CARGO = 220 THEN
      BEGIN
        SELECT S.SNG057USR
          INTO VO_USUARIO
          FROM FST046 F4, SNG057 S, FST811 F
         WHERE F4.PGCOD = S.SNG055EMP
           AND F4.UBUSER = S.SNG057USR
           AND S.SNG055CAR = VE_CARGO
           AND S.SNG057AUT = 'S'
           AND F.PGCOD = S.SNG055EMP
           AND F.REGCOD = VI_REGCOD
           AND ROWNUM = 1;
      EXCEPTION
        --04.02.2022
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
    IF VE_CARGO = 230 OR VE_CARGO = 240 THEN
      BEGIN
        SELECT S.SNG057USR
          INTO VO_USUARIO
          FROM SNG057 S, PRFU00 p
         WHERE S.SNG055EMP = 1
           AND S.SNG055CAR = VE_CARGO
           AND S.SNG057AUT = 'S'
           AND P.PGCOD = S.SNG055EMP
           AND P.UBUSER = S.SNG057USR
           AND P.PRFGCOD <> rpad('CESADO', 10, ' ')
           AND ROWNUM = 1;
      EXCEPTION
        --04.02.2022
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
    --OBTENER SUPLENTE
    BEGIN
      SELECT S.SNG057SUP
        INTO vo_usuario_sup
        FROM SNG057 S
       WHERE S.SNG055EMP = 1
         AND S.SNG057USR = VO_USUARIO
         AND S.SNG057AUT = 'S'
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        vo_usuario_sup := '';
    END;
  END;
  PROCEDURE SP_OBTENER_TASA_CAJA(ve_aqpb556cod number,
                                 ve_instancia  number,
                                 ve_nuevaTasa  out number,
                                 ve_preduccion out number,
                                 ve_montocap   out number,
                                 ve_facilidad  out varchar,
                                 ve_rpta       out varchar) is
    vi_emp        xwf700.xwfempresa%type;
    vi_suc        xwf700.xwfsucursal%type;
    vi_mod        xwf700.xwfmodulo%type;
    vi_mda        xwf700.xwfmoneda%type;
    vi_pap        xwf700.xwfpapel%type;
    vi_cta        xwf700.xwfcuenta%type;
    vi_ope        xwf700.xwfoperacion%type;
    vi_sbop       xwf700.xwfsubope%type;
    vi_tope       xwf700.xwftipope%type;
    vi_nuevaTasa  number(10, 6);
    ve_TpFndo     varchar(100);
    VI_TASA       number(10, 6);
    VI_TEM        number(10, 6);
    vi_preduccion NUMBER(10, 6);
    vi_montocap   NUMBER(17, 2);
  BEGIN
    --OBTENER CLAVEL DEL CREDITO
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
       WHERE XWFPRCINS = ve_instancia
         AND XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --OBTENER EL TIPO DE PROGRAMA
    BEGIN
      SELECT F.FACILIDAD,
             F.NUEVATASA,
             F.PORCENTAJEREDUCCION,
             F.MONTOCAPITALIZACION,
             F.FACILIDAD
        INTO ve_TpFndo,
             ve_nuevaTasa,
             ve_preduccion,
             ve_montocap,
             ve_facilidad
        FROM LEY31050 G, LEY31050_CREDITOSFACILIDAD F
       WHERE F.idley31050 = G.idley31050
         AND G.ESTADOSOLICITUD IN ('BT', 'AP')
         AND G.TIPOFACILIDAD = 'CAJA'
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             vi_cta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = vi_ope
         AND F.EMPRESA = vi_emp
         AND F.SUCURSAL = vi_suc
         AND F.MODULO = vi_mod
         AND F.MONEDA = vi_mda
         AND F.PAPEL = vi_pap
         AND F.SUBOPERACION = vi_sbop
         AND F.TIPOOPERACION = vi_tope;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  END;

  PROCEDURE SP_OBT_INST_COD_RPG(ve_pgcod     in number,
                                ve_mod       in number,
                                ve_suc       in number,
                                ve_mda       in number,
                                ve_pap       in number,
                                ve_cta       in number,
                                ve_ope       in number,
                                ve_sbo       in number,
                                ve_top       in number,
                                ve_codigo    out number,
                                ve_instancia out number) IS
  BEGIN
    --OBTENER CODIGO E INSTANCIA
    BEGIN
      SELECT A.AQPB556COD, A.AQPB556INST
        INTO ve_codigo, ve_instancia
        FROM AQPB556 A
       WHERE A.AQPB556EMP = ve_pgcod
         AND A.AQPB556MOD = ve_mod
         AND A.AQPB556SUC = ve_suc
         AND A.AQPB556MDA = ve_mda
         AND A.AQPB556PAP = ve_pap
         AND A.AQPB556CTA = ve_cta
         AND A.AQPB556OPER = ve_ope
         AND A.AQPB556SBOP = ve_sbo
         AND A.AQPB556TOP = ve_top
         AND AQPB556EHAB = 'H'
         AND A.AQPB556FECR = (SELECT MAX(AQPB556FECR)
                                FROM AQPB556 A
                               WHERE A.AQPB556EMP = ve_pgcod
                                 AND A.AQPB556MOD = ve_mod
                                 AND A.AQPB556SUC = ve_suc
                                 AND A.AQPB556MDA = ve_mda
                                 AND A.AQPB556PAP = ve_pap
                                 AND A.AQPB556CTA = ve_cta
                                 AND A.AQPB556OPER = ve_ope
                                 AND A.AQPB556SBOP = ve_sbo
                                 AND A.AQPB556TOP = ve_top
                                 AND A.AQPB556EHAB = 'H');
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;
  PROCEDURE sp_grabar_cronograma(ve_codigo    number,
                                 ve_instancia number,
                                 ve_pgcod     in number,
                                 ve_mod       in number,
                                 ve_suc       in number,
                                 ve_mda       in number,
                                 ve_pap       in number,
                                 ve_cta       in number,
                                 ve_ope       in number,
                                 ve_sbo       in number,
                                 ve_top       in number,
                                 VE_ARCHIVO   IN VARCHAR) IS
  BEGIN
    UPDATE AQPB556 A
       SET A.AQPB556ARCH = TRIM(VE_ARCHIVO)
     WHERE A.AQPB556EMP = ve_pgcod
       AND A.AQPB556MOD = ve_mod
       AND A.AQPB556SUC = ve_suc
       AND A.AQPB556MDA = ve_mda
       AND A.AQPB556PAP = ve_pap
       AND A.AQPB556CTA = ve_cta
       AND A.AQPB556OPER = ve_ope
       AND A.AQPB556SBOP = ve_sbo
       AND A.AQPB556TOP = ve_top
       AND AQPB556EHAB = 'H'
       AND A.AQPB556FECR = (SELECT MAX(AQPB556FECR)
                              FROM AQPB556 A
                             WHERE A.AQPB556EMP = ve_pgcod
                               AND A.AQPB556MOD = ve_mod
                               AND A.AQPB556SUC = ve_suc
                               AND A.AQPB556MDA = ve_mda
                               AND A.AQPB556PAP = ve_pap
                               AND A.AQPB556CTA = ve_cta
                               AND A.AQPB556OPER = ve_ope
                               AND A.AQPB556SBOP = ve_sbo
                               AND A.AQPB556TOP = ve_top
                               AND A.AQPB556EHAB = 'H');
    commit;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  PROCEDURE sp_pasar_masiv_indv(ve_fec  in date,
                                ve_cod  in number,
                                ve_est  in varchar,
                                ve_user in varchar,
                                ve_msj  out varchar) is
    cursor lista_jaqz698 is
      select t.JAQZ698FEP,
             t.JAQZ698COR,
             t.JAQZ698EMP,
             t.JAQZ698MOD,
             t.JAQZ698SUC,
             t.JAQZ698MDA,
             t.JAQZ698PAP,
             t.JAQZ698CTA,
             t.JAQZ698OPE,
             t.JAQZ698SBO,
             t.JAQZ698TOP
        from jaqz698 t
       where t.JAQZ698FEP = ve_fec
         and t.JAQZ698COR = ve_cod
         and t.JAQZ698EST = 'C'
         and rownum = 1;
    vi_fecha date;
    vi_err   number;
    vi_merr  varchar(100);
  BEGIN
    IF ve_est = 'C' then
      BEGIN
        for x in lista_jaqz698 loop
          --ACTUALIZANDO EL ESTADO EN LA TABLA DE REPROGRMACION DEL ANALISTA             
          BEGIN
            select pgfape into vi_fecha from fst017 where pgcod = 1;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          --ACTUALIZANDO EL ESTADO EN LA TABLA DE APROBACION
          UPDATE jaqz698 a
             set a.JAQZ698NU2 = 2,
                 a.JAQZ698CA2 = ve_user,
                 a.JAQZ698FA3 = vi_fecha
           WHERE JAQZ698EST = 'C'
             and JAQZ698FEP = ve_fec
             and JAQZ698COR = ve_cod;
          COMMIT;
          --ENVIO DE CORREO               
          sp_cr_correo_aprobacion(p_n_pgcod  => x.JAQZ698EMP,
                                  p_n_scsuc  => x.JAQZ698SUC,
                                  p_n_scmda  => x.JAQZ698MDA,
                                  p_n_scpap  => x.JAQZ698PAP,
                                  p_n_sccta  => x.JAQZ698CTA,
                                  p_n_scoper => x.JAQZ698OPE,
                                  p_n_scsbop => x.JAQZ698SBO,
                                  p_n_sctope => x.JAQZ698TOP,
                                  p_n_scmod  => x.JAQZ698MOD,
                                  p_v_ubuser => ve_user,
                                  p_v_tipo   => 'M',
                                  p_d_pgfape => vi_fecha,
                                  p_n_coderr => vi_err,
                                  p_c_msgerr => vi_merr);
        END LOOP;
      
        ve_msj := 'Se traslado de Unilateral a Consensuada';
      
      EXCEPTION
        WHEN OTHERS THEN
          ve_msj := 'No se han podido aplicar los cambios, consulte al administrador';
      END;
    ELSE
      ve_msj := 'Solo puede seleccionar Unilateral, no existe otro';
    END IF;
    commit;
  END;
  PROCEDURE SP_CRD_LOG_APROB_AQPD157(VE_AQPB556COD IN NUMBER,
                                     VE_INSTANCIA  IN NUMBER,
                                     VE_FECHARPG   IN DATE,
                                     VE_CARGO_APR  IN NUMBER,
                                     VE_CORREOS    IN VARCHAR,
                                     VE_ESTADO     IN VARCHAR,
                                     VE_USR_APR    IN VARCHAR,
                                     VE_MENSAJE    IN VARCHAR,
                                     VO_COD_ERROR  OUT VARCHAR,
                                     VO_MSG_ERROR  OUT VARCHAR) IS
    VI_ESTADO VARCHAR(4);
  BEGIN
    VI_ESTADO := NULL;
    BEGIN
      SELECT A.AQPD157EST
        INTO VI_ESTADO
        FROM AQPD157 A
       WHERE A.AQPD157CODREP = VE_AQPB556COD
         AND A.AQPD157INST = VE_INSTANCIA
         AND A.AQPD157FECAPRO = VE_FECHARPG
         AND A.AQPD157EST = VE_ESTADO
         AND A.AQPD157UAPRO = RPAD(VE_USR_APR, 10, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        VO_COD_ERROR := '0020';
        VO_MSG_ERROR := SUBSTR(SQLERRM, 1, 150);
        PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                   '',
                                                   'PQ_CR_REPROG_SIN_CAP',
                                                   'SP_CRD_LOG_APROB_AQPD157',
                                                   '',
                                                   VO_COD_ERROR,
                                                   VO_MSG_ERROR);
        VO_MSG_ERROR := 'No se encontro al Aprobador en el Arbol de Aprobación, contactar con el administrador.';
    END;
    IF VI_ESTADO IS NOT NULL AND VI_ESTADO = 'P' THEN
      BEGIN
        UPDATE AQPD157 B
           SET B.AQPD157MPCORR = VE_MENSAJE, B.AQPD157LOGPAPR = VE_CORREOS
         WHERE B.AQPD157CODREP = VE_AQPB556COD
           AND B.AQPD157INST = VE_INSTANCIA
           AND B.AQPD157FECAPRO = VE_FECHARPG
           AND B.AQPD157EST = VE_ESTADO
           AND B.AQPD157UAPRO = RPAD(VE_USR_APR, 10, ' ');
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          VO_COD_ERROR := '0021';
          VO_MSG_ERROR := SUBSTR(SQLERRM, 1, 150);
          PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                     '',
                                                     'PQ_CR_REPROG_SIN_CAP',
                                                     'SP_CRD_LOG_APROB_AQPD157',
                                                     '',
                                                     VO_COD_ERROR,
                                                     VO_MSG_ERROR);
          VO_MSG_ERROR := 'No se encontro al Aprobador en el Arbol de Aprobación, contactar con el administrador.';
      END;
    END IF;
    IF VI_ESTADO IS NOT NULL AND VI_ESTADO IN ('A', 'R') THEN
      BEGIN
        UPDATE AQPD157 B
           SET B.AQPD157MCORR = VE_MENSAJE
         WHERE B.AQPD157CODREP = VE_AQPB556COD
           AND B.AQPD157INST = VE_INSTANCIA
           AND B.AQPD157FECAPRO = VE_FECHARPG
           AND B.AQPD157EST = VE_ESTADO
           AND B.AQPD157UAPRO = RPAD(VE_USR_APR, 10, ' ');
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          VO_COD_ERROR := '0022';
          VO_MSG_ERROR := SUBSTR(SQLERRM, 1, 150);
          PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                     '',
                                                     'PQ_CR_REPROG_SIN_CAP',
                                                     'SP_CRD_LOG_APROB_AQPD157',
                                                     '',
                                                     VO_COD_ERROR,
                                                     VO_MSG_ERROR);
          VO_MSG_ERROR := 'No se encontro al Aprobador en el Arbol de Aprobación, contactar con el administrador.';
      END;
    END IF;
  END;
  PROCEDURE SP_CARGAR_AUTORIZANTES(VE_AQPB556COD IN NUMBER,
                                   VE_INSTANCIA  IN NUMBER,
                                   
                                   VO_COD_ERROR OUT VARCHAR,
                                   VO_MSG_ERROR OUT VARCHAR) IS
    VI_TIPORPG    NUMBER(3);
    VI_FECHARPG   DATE;
    VI_SUCURSAL   NUMBER(3);
    vio_aprobador CHAR(10);
    VI_ANALISTA   CHAR(10);
    VI_SALDOCAP   NUMBER(17, 2);
    VI_CARGO      NUMBER(4);
    CURSOR LISTA_CLIENTES_AUTORIZANTES(VS_TIPRPG NUMBER, VS_SCAP NUMBER) IS
      SELECT A.*
        FROM AQPC722 A
       WHERE A.AQPC722TPRG = VS_TIPRPG
         AND A.AQPC722EST = 'S'
         AND A.AQPC722IMPMN <= VS_SCAP
         AND A.AQPC722IMPMAX >= VS_SCAP;
  BEGIN
    --INICIALIZAMOS ALGUNAS VARIABLES
    VO_COD_ERROR := '0000';
    VO_MSG_ERROR := '';
    VI_CARGO     := 0;
    --VALIDAR TIPO DE REPROGRAMACIÓN DEL CRÉDITO
    BEGIN
      SELECT A.AQPB556TPRG,
             A.AQPB556FECRPG,
             A.AQPB556SUC,
             A.AQPB556USRR,
             ABS(A.AQPB556SCAP)
        INTO VI_TIPORPG, VI_FECHARPG, VI_SUCURSAL, VI_ANALISTA, VI_SALDOCAP
        FROM AQPB556 A
       WHERE A.AQPB556COD = VE_AQPB556COD
         AND A.AQPB556INST = VE_INSTANCIA;
    EXCEPTION
      WHEN OTHERS THEN
        VO_COD_ERROR := '0001';
        VO_MSG_ERROR := SUBSTR(SQLERRM, 1, 150);
        PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                   '',
                                                   'PQ_CR_REPROG_SIN_CAP',
                                                   'SP_CARGAR_AUTORIZANTES',
                                                   '',
                                                   VO_COD_ERROR,
                                                   VO_MSG_ERROR);
        VO_MSG_ERROR := 'No se encontro arbol de autorización';
    END;
    --CARGAR LA LISTA DE AUTORIZANTES EN TABLA LOCAL.
    BEGIN
      BEGIN
        UPDATE AQPD157 A
           SET A.AQPD157EST = 'N'
         WHERE A.AQPD157CODREP = VE_AQPB556COD
           AND A.AQPD157INST = VE_INSTANCIA
           AND AQPD157FECAPRO = VI_FECHARPG;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      FOR X IN LISTA_CLIENTES_AUTORIZANTES(VI_TIPORPG, VI_SALDOCAP) LOOP
      
        PQ_CR_APROBACION_REPROG_HS.SP_VALIDAR_APROB_PERFIL(X.AQPC722CCARG,
                                                           X.AQPC722PCARG,
                                                           VI_SUCURSAL,
                                                           vio_aprobador);
        IF VI_CARGO <= X.AQPC722CCARG THEN
          VI_CARGO := X.AQPC722CCARG;
          BEGIN
            UPDATE AQPB556 A
               SET A.AQPB556CARA = VI_CARGO, A.AQPB556USRA = vio_aprobador
             WHERE A.AQPB556COD = VE_AQPB556COD
               AND A.AQPB556INST = VE_INSTANCIA
               AND A.AQPB556FECRPG = VI_FECHARPG;
            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
        BEGIN
          INSERT INTO AQPD157
            (AQPD157FECAPRO,
             AQPD157CODREP,
             AQPD157INST,
             AQPD157TIPREP,
             AQPD157NIAP,
             AQPD157NIDP,
             AQPD157CODCAR,
             AQPD157PERUS,
             AQPD157UAPRO,
             AQPD157EST,
             AQPD157UREG,
             AQPD157FECREG,
             AQPD157HORREG,
             AQPD157REQ)
          VALUES
            (VI_FECHARPG,
             VE_AQPB556COD,
             VE_INSTANCIA,
             VI_TIPORPG,
             X.AQPC722NAPR,
             X.AQPC722NDAPR,
             X.AQPC722CCARG,
             X.AQPC722PCARG,
             vio_aprobador,
             'P',
             VI_ANALISTA,
             TO_DATE(SYSDATE, 'DD/MM/RRRR'),
             TO_CHAR(SYSDATE, 'HH:Mi:SS'),
             X.AQPC722REQ);
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            VO_COD_ERROR := '0000';
            VO_MSG_ERROR := SUBSTR(SQLERRM, 1, 150);
            PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                       '',
                                                       'PQ_CR_REPROG_SIN_CAP',
                                                       'SP_CARGAR_AUTORIZANTES',
                                                       '',
                                                       VO_COD_ERROR,
                                                       VO_MSG_ERROR);
            VO_MSG_ERROR := 'No se pudo encontrar el aprobador para asignar delegación';
        END;
      END LOOP;
    END;
  END;

  PROCEDURE sp_obtener_data_jaqa400(VE_AQPB556COD IN NUMBER,
                                    VE_INSTANCIA  IN NUMBER,
                                    
                                    VO_ANALISTA  OUT VARCHAR,
                                    VO_CMTAEC    OUT VARCHAR,
                                    VO_CMTDCR    OUT VARCHAR,
                                    VO_CMTVP     OUT VARCHAR,
                                    VO_COD_ERROR OUT VARCHAR,
                                    VO_MSG_ERROR OUT VARCHAR) IS
    VI_FECHA_RPG DATE;
    VI_EMP       JAQA400.JAQA400EMP%TYPE;
    VI_MOD       JAQA400.JAQA400MOD%TYPE;
    VI_SUC       JAQA400.JAQA400SUC%TYPE;
    VI_MDA       JAQA400.JAQA400MDA%TYPE;
    VI_PAP       JAQA400.JAQA400PAP%TYPE;
    VI_CTA       JAQA400.JAQA400CTA%TYPE;
    VI_OPER      JAQA400.JAQA400OPE%TYPE;
    VI_SBOP      JAQA400.JAQA400SBO%TYPE;
    VI_TOP       JAQA400.JAQA400TOP%TYPE;
  BEGIN
    --INICIALIZAMOS ALGUNAS VARIABLES
    VO_COD_ERROR := '0000';
    VO_MSG_ERROR := '';
    --CONSULTAR TABLA AQPB556
    BEGIN
      SELECT A.AQPB556FECRPG,
             A.AQPB556EMP,
             A.AQPB556MOD,
             A.AQPB556SUC,
             A.AQPB556MDA,
             A.AQPB556PAP,
             A.AQPB556CTA,
             A.AQPB556OPER,
             A.AQPB556SBOP,
             A.AQPB556TOP
        INTO VI_FECHA_RPG,
             VI_EMP,
             VI_MOD,
             VI_SUC,
             VI_MDA,
             VI_PAP,
             VI_CTA,
             VI_OPER,
             VI_SBOP,
             VI_TOP
        FROM AQPB556 A
       WHERE A.AQPB556COD = VE_AQPB556COD
         AND A.AQPB556INST = VE_INSTANCIA;
    EXCEPTION
      WHEN OTHERS THEN
        VO_COD_ERROR := '0001';
        VO_MSG_ERROR := SUBSTR(SQLERRM, 1, 150);
        PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                   '',
                                                   'PQ_CR_REPROG_SIN_CAP',
                                                   'sp_obtener_data_jaqa400',
                                                   '',
                                                   VO_COD_ERROR,
                                                   VO_MSG_ERROR);
        VO_MSG_ERROR := 'No se pudo encontrar información del credito';
    END;
    --CONSULTAR TABLA JAQA400 PARA OBTENER ANALISTA Y COMENTARIOS
    --INSERT INTO PRUEBA_LOG(MSG)VALUES(VE_AQPB556COD||'-'||VI_EMP||'-'||VI_MOD||'-'||VI_SUC||'-'||VI_MDA||'-'||VI_PAP||'-'||VI_CTA||'-'||VI_OPER||'-'||VI_SBOP||'-'||VI_TOP||'-'||VI_FECHA_RPG);
    --commit;
    BEGIN
      SELECT J.JAQA400USS, J.JAQA400AEC, J.JAQA400DCR, J.JAQA400VPG
        INTO VO_ANALISTA, VO_CMTAEC, VO_CMTDCR, VO_CMTVP
        FROM JAQA400 J
       WHERE J.JAQA400EMP = VI_EMP
         AND J.JAQA400MOD = VI_MOD
         AND J.JAQA400SUC = VI_SUC
         AND J.JAQA400MDA = VI_MDA
         AND J.JAQA400PAP = VI_PAP
         AND J.JAQA400CTA = VI_CTA
         AND J.JAQA400OPE = VI_OPER
         AND J.JAQA400SBO = VI_SBOP
         AND J.JAQA400TOP = VI_TOP
         AND J.JAQA400FEC = VI_FECHA_RPG;
    EXCEPTION
      WHEN OTHERS THEN
        VO_COD_ERROR := '0002';
        VO_MSG_ERROR := SUBSTR(SQLERRM, 1, 150);
        PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                   '',
                                                   'PQ_CR_REPROG_SIN_CAP',
                                                   'sp_obtener_data_jaqa400',
                                                   '',
                                                   VO_COD_ERROR,
                                                   VO_MSG_ERROR);
        VO_MSG_ERROR := 'No se pudo encontrar información de los comentarios del Analista';
    END;
  END;

  PROCEDURE SP_GRABAR_APROBACION(VE_FECHAREG  IN DATE,
                                 VE_CODREPROG IN NUMBER,
                                 VE_INSTANCIA IN NUMBER,
                                 --
                                 VE_UBUSER     IN VARCHAR,
                                 VE_COMENTARIO IN VARCHAR,
                                 VE_ESTADO     IN VARCHAR,
                                 --
                                 VO_CODERROR OUT VARCHAR,
                                 VO_MSGERROR OUT VARCHAR) IS
    VI_NIVEL_APROB          AQPD157.AQPD157NIAP%TYPE;
    VI_NIVEL_DEPEND         AQPD157.AQPD157NIDP%TYPE;
    VI_USR_APROB            AQPD157.AQPD157UAPRO%TYPE;
    VI_USR_APROBR           AQPD157.AQPD157UAPRO%TYPE;
    VI_USR_COD_CARGO        AQPD157.AQPD157CODCAR%TYPE;
    VI_USR_ESTADO           AQPD157.AQPD157EST%TYPE;
    vi_total_autorizantes   NUMBER(3);
    vi_total_autorizaciones number(3);
    VI_ESTADO               varchar(1);
  BEGIN
    --INICIALIZAMOS LAS VARIABLES
    VI_USR_APROB  := '';
    VI_USR_APROBR := '';
    VO_CODERROR   := '0000';
    VO_MSGERROR   := 'Se realizo la autorización del Credito, validar si queda pendiente mas autorizaciones.';
    --VALIDAMOS QUE EXISTA REGISTRO PARA ACTUALIZAR ESTADO DE LA APROBACION
    BEGIN
      SELECT A.AQPD157NIAP, A.AQPD157NIDP, A.AQPD157UAPRO
        INTO VI_NIVEL_APROB, VI_NIVEL_DEPEND, VI_USR_APROBR
        FROM AQPD157 A
       WHERE A.AQPD157FECAPRO = VE_FECHAREG
         AND A.AQPD157CODREP = VE_CODREPROG
         AND A.AQPD157INST = VE_INSTANCIA
         AND A.AQPD157UAPRO = RPAD(TRIM(VE_UBUSER), 10, ' ')
         and A.AQPD157EST = 'P';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BEGIN
          SELECT A.AQPD157NIAP, A.AQPD157NIDP, A.AQPD157UAPRO
            INTO VI_NIVEL_APROB, VI_NIVEL_DEPEND, VI_USR_APROBR
            FROM AQPD157 A
           WHERE A.AQPD157FECAPRO = VE_FECHAREG
             AND A.AQPD157CODREP = VE_CODREPROG
             AND A.AQPD157INST = VE_INSTANCIA
             AND A.AQPD157UAPRO =
                 (SELECT SNG057USR
                    FROM SNG057
                   WHERE SNG057SUP = RPAD(TRIM(VE_UBUSER), 10, ' ')
                     AND SNG057FIN >=
                         (SELECT PGFAPE FROM FST017 WHERE PGCOD = 1)
                     AND ROWNUM = 1)
             AND A.AQPD157EST = 'P';
        EXCEPTION
          WHEN OTHERS THEN
            VO_CODERROR := '0001';
            VO_MSGERROR := SUBSTR(SQLERRM, 1, 150);
            PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                       '',
                                                       'PQ_CR_REPROG_SIN_CAP',
                                                       'SP_GRABAR_APROBACION',
                                                       '',
                                                       VO_CODERROR,
                                                       VO_MSGERROR);
            VO_MSGERROR := 'No se pudo encontrar su información para grabar su aprobación, valide si esta en listado de autorizantes';
        END;
      WHEN OTHERS THEN
        NULL;
    END;
    IF VI_NIVEL_APROB > 0 THEN
      --VALIDAMOS SI TENEMOS DEPENDENCIA EN CASO SEA VALIDAMOS SI YA AUTORIZO EL ANTERIOR 
      IF VI_NIVEL_DEPEND > 0 THEN
        --OBTENER LOS DATOS DE LOS ANTERIORES AUTORIZADORES.
        BEGIN
          SELECT A.AQPD157UAPRO, A.AQPD157CODCAR, A.AQPD157EST
            INTO VI_USR_APROB, VI_USR_COD_CARGO, VI_USR_ESTADO
            FROM AQPD157 A
           WHERE A.AQPD157FECAPRO = VE_FECHAREG
             AND A.AQPD157CODREP = VE_CODREPROG
             AND A.AQPD157INST = VE_INSTANCIA
             AND A.AQPD157NIAP = VI_NIVEL_DEPEND
             AND A.AQPD157EST IN ('A', 'P', 'R')
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            BEGIN
              SELECT B.AQPD157UAPRO, B.AQPD157CODCAR, B.AQPD157EST
                INTO VI_USR_APROB, VI_USR_COD_CARGO, VI_USR_ESTADO
                FROM AQPD157 B
               WHERE B.AQPD157FECAPRO = VE_FECHAREG
                 AND B.AQPD157CODREP = VE_CODREPROG
                 AND B.AQPD157INST = VE_INSTANCIA
                 AND B.AQPD157NIAP < VI_NIVEL_DEPEND
                 AND B.AQPD157EST IN ('P', 'A', 'R')
                 AND ROWNUM = 1;
            EXCEPTION
              WHEN OTHERS THEN
                VO_CODERROR := '0002';
                VO_MSGERROR := SUBSTR(SQLERRM, 1, 150);
                PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                           '',
                                                           'PQ_CR_REPROG_SIN_CAP',
                                                           'SP_GRABAR_APROBACION',
                                                           '',
                                                           VO_CODERROR,
                                                           VO_MSGERROR);
                VO_MSGERROR := 'No se pudo encontrar al autorizante, por favor contacte al administrador';
            END;
        END;
      
        -- SI SE ENCUENTRA EL AUTORIZANTE VALIDAR SI LO AUTORIZO
        IF (TRIM(VI_USR_APROB)) IS NOT NULL OR VI_USR_COD_CARGO > 0 THEN
          IF VI_USR_ESTADO = 'A' THEN
            --SI EL ANTERIOR AUTORIZO RECIEN ACTUALIZO LOS CAMBIOS DEL ACTUAL AUTORIZANTE
            --SE  ACTUALIZA LAS CONDIONES DE LA AUTORIZACION DEL CREDITO A REPROGRAMAR
            BEGIN
              UPDATE AQPD157 A
                 SET A.AQPD157EST    = VE_ESTADO,
                     A.AQPD157CMTA   = VE_COMENTARIO,
                     A.AQPD157FEACT  = TO_DATE(sysdate, 'dd/mm/rrrr'),
                     A.AQPD157HORACT = to_char(sysdate, 'hh:mi:ss'),
                     A.AQPD157UAPRR  = TRIM(VE_UBUSER)
               WHERE A.AQPD157FECAPRO = VE_FECHAREG
                 AND A.AQPD157CODREP = VE_CODREPROG
                 AND A.AQPD157INST = VE_INSTANCIA
                 AND A.AQPD157UAPRO = VI_USR_APROBR
                 AND A.AQPD157EST = 'P';
              COMMIT;
              -------
              BEGIN
                --ENVIAR CORREO DE APROBACION 
                PQ_CR_REPROG_SIN_CAP.SP_ENVIAR_CORREO_PAPR(VE_FECHAREG,
                                                           VE_CODREPROG,
                                                           VE_INSTANCIA,
                                                           VE_ESTADO,
                                                           VI_USR_APROBR,
                                                           VO_CODERROR,
                                                           VO_MSGERROR);
              EXCEPTION
                WHEN OTHERS THEN
                  VO_CODERROR := '0007';
                  VO_MSGERROR := SUBSTR(SQLERRM, 1, 150);
                  PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                             '',
                                                             'PQ_CR_REPROG_SIN_CAP',
                                                             'SP_GRABAR_APROBACION',
                                                             '',
                                                             VO_CODERROR,
                                                             VO_MSGERROR);
                  VO_MSGERROR := 'No se pudo enviar el correo de la autorización, pero si se Gestiono.';
              END;
              -------          
            EXCEPTION
              WHEN OTHERS THEN
                VO_CODERROR := '0003';
                VO_MSGERROR := SUBSTR(SQLERRM, 1, 150);
                PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                           '',
                                                           'PQ_CR_REPROG_SIN_CAP',
                                                           'SP_GRABAR_APROBACION',
                                                           '',
                                                           VO_CODERROR,
                                                           VO_MSGERROR);
                VO_MSGERROR := 'No se encuentra en el listado para autorizar la aprobacion del Credito a reprogramar';
            END;
          ELSE
            IF VI_USR_ESTADO = 'P' THEN
              VO_CODERROR := '0004';
              VO_MSGERROR := 'No puede autorizar esta pendiente la autorización de ' ||
                             VI_USR_APROB || ' - ' || VI_USR_COD_CARGO;
            END IF;
          END IF;
        END IF;
      ELSE
        -- EN CASO NO TENGA DEPENDENCIAS DIRECTAMENTE SE GESTIONA LA DESICIÓN DEL AUTORIZANTE
        --SE  ACTUALIZA LAS CONDIONES DE LA AUTORIZACION DEL CREDITO A REPROGRAMAR
        BEGIN
          --insert into prueba_log(msg)values(VE_FECHAREG||'-'||VE_CODREPROG||'-'||VE_INSTANCIA||'-'||VE_UBUSER);
          --commit;
          UPDATE AQPD157 A
             SET A.AQPD157EST    = VE_ESTADO,
                 A.AQPD157CMTA   = VE_COMENTARIO,
                 A.AQPD157FEACT  = TO_DATE(sysdate, 'dd/mm/rrrr'),
                 A.AQPD157HORACT = to_char(sysdate, 'hh:mi:ss'),
                 A.AQPD157UAPRR  = TRIM(VE_UBUSER)
           WHERE A.AQPD157FECAPRO = VE_FECHAREG
             AND A.AQPD157CODREP = VE_CODREPROG
             AND A.AQPD157INST = VE_INSTANCIA
             AND A.AQPD157UAPRO = VI_USR_APROBR
             AND A.AQPD157EST = 'P';
          COMMIT;
          -------
          BEGIN
            --ENVIAR CORREO DE APROBACION 
            PQ_CR_REPROG_SIN_CAP.SP_ENVIAR_CORREO_PAPR(VE_FECHAREG,
                                                       VE_CODREPROG,
                                                       VE_INSTANCIA,
                                                       VE_ESTADO,
                                                       VI_USR_APROBR,
                                                       VO_CODERROR,
                                                       VO_MSGERROR);
          EXCEPTION
            WHEN OTHERS THEN
              VO_CODERROR := '0007';
              VO_MSGERROR := SUBSTR(SQLERRM, 1, 150);
              PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                         '',
                                                         'PQ_CR_REPROG_SIN_CAP',
                                                         'SP_GRABAR_APROBACION',
                                                         '',
                                                         VO_CODERROR,
                                                         VO_MSGERROR);
              VO_MSGERROR := 'No se pudo enviar el correo de la autorización, pero si se Gestiono.';
          END;
          -------   
        EXCEPTION
          WHEN OTHERS THEN
            VO_CODERROR := '0005';
            VO_MSGERROR := SUBSTR(SQLERRM, 1, 150);
            PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                       '',
                                                       'PQ_CR_REPROG_SIN_CAP',
                                                       'SP_GRABAR_APROBACION',
                                                       '',
                                                       VO_CODERROR,
                                                       VO_MSGERROR);
            VO_MSGERROR := 'No se encuentra en el listado para autorizar la aprobacion del Credito a reprogramar';
        END;
      END IF;
      --FINALMENTE SE VALIDA SI SE CUENTA CON TODAS LAS AUTORIZACIONES PARA REALIZAR CAMBIOS EN LA TABLA PRINCIPAL AQPB556
      BEGIN
        --OBTENER EL TOTAL DE AUTORIZANTES
        BEGIN
          SELECT count(*)
            INTO vi_total_autorizantes
            FROM AQPD157 A
           WHERE A.AQPD157FECAPRO = VE_FECHAREG
             AND A.AQPD157CODREP = VE_CODREPROG
             AND A.AQPD157INST = VE_INSTANCIA
             AND A.AQPD157EST IN ('P', 'A');
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        --VALIDAR SI CUENTA CON TODAS LAS AUTORIZACIONES
        BEGIN
          SELECT count(*)
            INTO vi_total_autorizaciones
            FROM AQPD157 A
           WHERE A.AQPD157FECAPRO = VE_FECHAREG
             AND A.AQPD157CODREP = VE_CODREPROG
             AND A.AQPD157INST = VE_INSTANCIA
             AND A.AQPD157EST = 'A';
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        --VALIDAR SI EL AUTORIZANTE ACTUAL HA RECHAZADO LA SOLICITUD. 
        IF VE_ESTADO = 'R' THEN
          BEGIN
            --ACTUALIZO LOS ESTADOS DE AUTORIZACION EN TABLA PRINCIPAL
            UPDATE AQPB556 A5
               SET A5.AQPB556FECUAT = to_DATE(sysdate, 'dd/mm/rrrr'),
                   A5.AQPB556HORUAT = to_char(sysdate, 'hh:mi:ss'),
                   A5.AQPB556ESTAUT = 'R',
                   A5.AQPB556EST    = 'R'
             WHERE A5.AQPB556COD = VE_CODREPROG
               AND A5.AQPB556INST = VE_INSTANCIA
               AND A5.AQPB556FECRPG = VE_FECHAREG
               AND A5.AQPB556EST = 'P'
               AND A5.AQPB556EHAB = 'H';
            --ACTUALIZO EL ESTADO DE TABLA PRINCIPAL DE ANALISTA PARA QUE VUELVA A SOLICITUD
            UPDATE JAQA400 J
               SET J.JAQA400EST = 'S'
             WHERE J.JAQA400FEC = VE_FECHAREG
               AND J.JAQA400EST = 'A'
               AND J.JAQA400AI1 = VE_INSTANCIA;
            COMMIT; --@2024.09.11 - AGREGADO
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
        --VALIDAR SI TIENE TODAS LAS AUTORIZACIONES 
        IF vi_total_autorizantes = vi_total_autorizaciones THEN
          BEGIN
            --ACTUALIZO EL ESTADO EN TABLA PRINCIPAL EN SEÑAL QUE SE CUENTA CON TODAS LAS AUTORIZACIONES.
            UPDATE AQPB556 A5
               SET A5.AQPB556FECUAT = to_DATE(sysdate, 'dd/mm/rrrr'),
                   A5.AQPB556HORUAT = to_char(sysdate, 'hh:mi:ss'),
                   A5.AQPB556ESTAUT = 'A'
             WHERE A5.AQPB556COD = VE_CODREPROG
               AND A5.AQPB556INST = VE_INSTANCIA
               AND A5.AQPB556FECRPG = VE_FECHAREG
               AND A5.AQPB556EST = 'P'
               AND A5.AQPB556EHAB = 'H';
          
            UPDATE AQPD157 A
               SET A.AQPD157EST    = VE_ESTADO,
                   A.AQPD157CMTA   = VE_COMENTARIO,
                   A.AQPD157FEACT  = TO_DATE(sysdate, 'dd/mm/rrrr'),
                   A.AQPD157HORACT = to_char(sysdate, 'hh:mi:ss'),
                   A.AQPD157UAPRR  = TRIM(VE_UBUSER)
             WHERE A.AQPD157FECAPRO = VE_FECHAREG
               AND A.AQPD157CODREP = VE_CODREPROG
               AND A.AQPD157INST = VE_INSTANCIA
               AND A.AQPD157UAPRO = VI_USR_APROBR
               AND A.AQPD157EST = 'P';
            commit; --@2024.09.11 - AGREGADO
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          -------
          BEGIN
            --ENVIAR CORREO DE APROBACION TOTAL
            PQ_CR_REPROG_SIN_CAP.SP_ENVIAR_CORREO_PAPR(VE_FECHAREG,
                                                       VE_CODREPROG,
                                                       VE_INSTANCIA,
                                                       'AAA',
                                                       VI_USR_APROBR,
                                                       VO_CODERROR,
                                                       VO_MSGERROR);
          EXCEPTION
            WHEN OTHERS THEN
              VO_CODERROR := '0007';
              VO_MSGERROR := SUBSTR(SQLERRM, 1, 150);
              PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                         '',
                                                         'PQ_CR_REPROG_SIN_CAP',
                                                         'SP_GRABAR_APROBACION',
                                                         '',
                                                         VO_CODERROR,
                                                         VO_MSGERROR);
              VO_MSGERROR := 'No se pudo enviar el correo de la autorización, pero si se Gestiono.';
          END;
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    ELSE
      VI_ESTADO := 'N';
      BEGIN
        SELECT A.AQPD157EST
          INTO VI_ESTADO
          FROM AQPD157 A
         WHERE A.AQPD157FECAPRO = VE_FECHAREG
           AND A.AQPD157CODREP = VE_CODREPROG
           AND A.AQPD157INST = VE_INSTANCIA
           AND A.AQPD157UAPRO = RPAD(TRIM(VE_UBUSER), 10, ' ');
      EXCEPTION
        WHEN OTHERS THEN
          BEGIN
            SELECT A.AQPD157EST
              INTO VI_ESTADO
              FROM AQPD157 A
             WHERE A.AQPD157FECAPRO = VE_FECHAREG
               AND A.AQPD157CODREP = VE_CODREPROG
               AND A.AQPD157INST = VE_INSTANCIA
               AND A.AQPD157UAPRO =
                   (SELECT SNG057USR
                      FROM SNG057
                     WHERE SNG057SUP = RPAD(TRIM(VE_UBUSER), 10, ' ')
                       AND SNG057FIN >=
                           (SELECT PGFAPE FROM FST017 WHERE PGCOD = 1)
                       AND ROWNUM = 1);
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
      END;
      IF VI_ESTADO = 'N' THEN
        VO_CODERROR := '0006';
        VO_MSGERROR := 'No se ha definido un arbol de autorización, para el crédito seleccionado, contactar al administrador';
      END IF;
      IF VI_ESTADO = 'A' OR VI_ESTADO = 'R' THEN
        VO_CODERROR := '0007';
        VO_MSGERROR := 'No se puede volver a gestionar lo ya gestionado, validar que autorizante falta o realizar el desembolso con plataforma';
      END IF;
    END IF;
  
  END;

  PROCEDURE SP_GRABAR_LOG_ERRORES(VE_INSTANCIA IN NUMBER,
                                  VE_PROGRAMA  IN VARCHAR,
                                  VE_PAQUETE   IN VARCHAR,
                                  VE_PROCED    IN VARCHAR,
                                  VE_PEJE      IN VARCHAR,
                                  VE_ERR       IN VARCHAR,
                                  VE_MSG       IN VARCHAR) IS
    VI_FECHA DATE;
  BEGIN
    BEGIN
      VI_FECHA := TO_DATE(SYSDATE, 'DD/MM/RRRR');
      INSERT INTO AQPC716
        (AQPC716FECR,
         AQPC716inst,
         aqpc716prg,
         aqpc716pqt,
         aqpc716prd,
         aqpc716peje,
         aqpc716err,
         aqpc716msge)
      VALUES
        (VI_FECHA,
         VE_INSTANCIA,
         VE_PROGRAMA,
         VE_PAQUETE,
         VE_PROCED,
         VE_PEJE,
         VE_ERR,
         VE_MSG);
    
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --INSERT INTO PRUEBA_LOG(MSG)VALUES(VI_FECHA||'-'||VE_INSTANCIA||'-'||VE_PROGRAMA||'-'||VE_PAQUETE||'-'||VE_PROCED||'-'||VE_PEJE||'-'||VE_ERR||'-'||VE_MSG);
  
  END;

  PROCEDURE SP_ENVIAR_CORREO_PAPR(VE_FECHAREG   IN DATE,
                                  VE_CODREPROG  IN NUMBER,
                                  VE_INSTANCIA  IN NUMBER,
                                  VE_ESTADO     IN VARCHAR,
                                  VE_USR_APROBR IN VARCHAR,
                                  VO_CODERROR   OUT VARCHAR,
                                  VO_MSGERROR   OUT VARCHAR) IS
    VI_USR_COD_CARGO   NUMBER(3);
    VI_USR_ESTADO      VARCHAR(3);
    VI_COMENTARIO      VARCHAR(150);
    VI_ANALISTA        CHAR(10);
    VI_DCARGO_ANALISTA VARCHAR(50);
    VI_CARGO_APR       VARCHAR(50);
  
    VI_CORREOS_COPIA  VARCHAR(350);
    VI_CORREO_DESTINO VARCHAR(150);
    VI_MAIL_ANALISTA  VARCHAR(150);
    --VARIABLES DEL CORREO
    VO_CORREOS_APROB VARCHAR(300);
    ll_mensaje       CLOB;
    lv_mensaje       VARCHAR2(32767);
    lv_remitente     VARCHAR2(90);
    lv_asunto        VARCHAR2(200);
    lv_directorio    VARCHAR2(40) := '';
    lv_destinos      VARCHAR2(4000) := '';
    lv_destinos_c    VARCHAR2(4000) := '';
    lv_archivo       VARCHAR2(100) := '';
    l_bfile          BFILE;
    l_blob           BLOB;
    VI_DATOS         VARCHAR(500);
    VI_CLIENTE       VARCHAR(70);
    VI_CUENTA        NUMBER(9);
    VI_OPERACION     NUMBER(9);
    VI_MONEDA        VARCHAR(4);
    VI_CAPITAL       NUMBER(17, 2);
  
    ------------------------
    VO_USUARIO_APROB VARCHAR(150);
    VO_CARGO_APROB   VARCHAR(150);
    VE_MENSAJE_LOG   VARCHAR(400);
    --VI_ESTADO     VARCHAR(3);
    ------------------------
    VOI_N_COD_TRPG NUMBER(9);
    VOI_V_DSC_TRPG VARCHAR(50);
    validacion     varchar(1);
  BEGIN
    BEGIN
      VO_CODERROR := '0000';
      --SE OBTIENE LOS DATOS DE LA GESTION
      --SE OBTIENE EL TIPO DE REPROGRAMACIÓN
      BEGIN
        PQ_CR_REPROG_SIN_CAP.SP_VALIDAR_TIPO_REPROGD(VE_CODREPROG,
                                                     VE_INSTANCIA,
                                                     VOI_N_COD_TRPG,
                                                     VOI_V_DSC_TRPG);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      --SE OBTIENE LOS DATOS DE LA AQPB556
      BEGIN
        SELECT B.AQPB556CTA,
               B.AQPB556OPER,
               ABS(B.AQPB556SCAP),
               F.MOSIGN,
               D.PENOM,
               W.WFUSREMAIL
          INTO VI_CUENTA,
               VI_OPERACION,
               VI_CAPITAL,
               VI_MONEDA,
               VI_CLIENTE,
               VI_MAIL_ANALISTA
          FROM AQPB556 B, FST005 F, FSD001 D, WFUSERS W
         WHERE B.AQPB556FECRPG = VE_FECHAREG
           AND B.AQPB556COD = VE_CODREPROG
           AND B.AQPB556INST = VE_INSTANCIA
           AND B.AQPB556EST IN ('P', 'A')
           AND B.AQPB556EHAB = 'H'
           AND F.MONEDA = B.AQPB556MDA
           AND D.PEPAIS = B.AQPB556PAIS
           AND D.PETDOC = B.AQPB556PTDC
           AND D.PENDOC = RPAD(B.AQPB556DNI, 12, ' ')
           AND W.WFUSRCOD = RPAD(B.AQPB556USRR, 30, ' ');
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          VO_CODERROR := '0002';
          VO_MSGERROR := SUBSTR(SQLERRM, 1, 150);
          PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                     '',
                                                     'PQ_CR_REPROG_SIN_CAP',
                                                     'SP_ENVIAR_CORREO_PAPR',
                                                     '',
                                                     VO_CODERROR,
                                                     VO_MSGERROR);
          VO_MSGERROR := 'No se pudo obtener los datos para el envio del correo, pero si se llevo a gestionar';
      END;
      --INICIALIZANDO EL DBMS_LOB
      dbms_lob.createtemporary(ll_mensaje, TRUE);
      --SE ARMA EL CORREO
      BEGIN
        LV_REMITENTE := 'notificacionesbantotal@cajaarequipa.pe';
        LV_ASUNTO    := 'APROBACION DE REPROGRAMACION CLIENTE ' ||
                        upper(trim(VI_CLIENTE));
        VI_DATOS     := 'cuenta ' || trim(to_char(VI_CUENTA)) ||
                        ' y operación ' || trim(to_char(VI_OPERACION)) ||
                        ' por ' || trim(VI_MONEDA) ||
                        trim(to_char(VI_CAPITAL, '9,999,999.99'));
      
        --ARMANDO EL MENSAJE
        IF VE_ESTADO = 'A' THEN
          -----
          BEGIN
            PQ_CR_REPROG_SIN_CAP.SP_OBTENER_SGTE_APR(VE_FECHAREG,
                                                     VE_CODREPROG,
                                                     VE_INSTANCIA,
                                                     VO_USUARIO_APROB,
                                                     VO_CARGO_APROB,
                                                     lv_destinos,
                                                     VO_CODERROR,
                                                     VO_MSGERROR);
          EXCEPTION
            WHEN OTHERS THEN
              VO_CODERROR := '0012';
              VO_MSGERROR := SUBSTR(SQLERRM, 1, 150);
              PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                         '',
                                                         'PQ_CR_REPROG_SIN_CAP',
                                                         'SP_ENVIAR_CORREO_PAPR',
                                                         '',
                                                         VO_CODERROR,
                                                         VO_MSGERROR);
              VO_MSGERROR := 'No se pudo enviar el correo pero si se llego a gestionar';
          END;
          --SE OBTIENE LOS DATOS DE LA AQPD157
          BEGIN
            SELECT A.AQPD157CODCAR,
                   A.AQPD157EST,
                   A.AQPD157CMTA,
                   S.SNG055DSC
              INTO VI_USR_COD_CARGO,
                   VI_USR_ESTADO,
                   VI_COMENTARIO,
                   VI_CARGO_APR
              FROM AQPD157 A, SNG055 S
             WHERE A.AQPD157FECAPRO = VE_FECHAREG
               AND A.AQPD157CODREP = VE_CODREPROG
               AND A.AQPD157INST = VE_INSTANCIA
               AND A.AQPD157UAPRO = RPAD(TRIM(VO_USUARIO_APROB), 10, ' ')
               AND A.AQPD157EST IN ('P', 'R', 'A')
               AND S.SNG055EMP = 1
               AND S.SNG055CAR = A.AQPD157CODCAR;
          EXCEPTION
            WHEN OTHERS THEN
              VO_CODERROR := '0001';
              VO_MSGERROR := SUBSTR(SQLERRM, 1, 150);
              PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                         '',
                                                         'PQ_CR_REPROG_SIN_CAP',
                                                         'SP_ENVIAR_CORREO_PAPR',
                                                         '',
                                                         VO_CODERROR,
                                                         VO_MSGERROR);
              VO_MSGERROR := 'No se pudo obtener los datos para el envio del correo, pero si se llevo a gestionar';
          END;
          -----          
          lv_mensaje     := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(s) ' ||
                            trim(VI_CARGO_APR) || ',</p>' ||
                            '<p "font-family: Arial, sans-serif; font-size: 14px;">Tiene pendiente de aprobación la reprogramación ' ||
                            VOI_V_DSC_TRPG || ' sin CRM de ' ||
                            trim(VI_DATOS);
          VE_MENSAJE_LOG := 'Estimado(s)' || trim(VI_CARGO_APR) || ',' ||
                            'Tiene pendiente de aprobación la reprogramación ' ||
                            VOI_V_DSC_TRPG || ' sin CRM de ' ||
                            trim(VI_DATOS);
          --OBTENER EL CORREO DEL APROBADOR.
          BEGIN
            SELECT W.WFUSREMAIL
              INTO lv_destinos_c
              FROM WFUSERS W
             WHERE W.WFUSRCOD = RPAD(TRIM(VE_USR_APROBR), 30, ' ');
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          --lv_destinos   := ;
          LV_DESTINOS_C := TRIM(lv_destinos_c) || ';' ||
                           TRIM(VI_MAIL_ANALISTA);
        
          ---------------------------------------
          -- segundo momento de envio chat bot
          ---------------------------------------
        
          PQ_CR_BOT__APROB_REPROG.SP_ENVIO_CORREO_BOT(P_CORR_REPRO => VE_CODREPROG,
                                                      INSTANCIA    => VE_INSTANCIA,
                                                      P_USUARIOING => VO_USUARIO_APROB,
                                                      P_ASUNTO     => lv_asunto,
                                                      P_MENSAJE    => lv_mensaje, -- ll_mensaje,
                                                      P_CORRPARA   => lv_destinos,
                                                      P_CORRDE     => VI_MAIL_ANALISTA); -- lv_remitente
        
        END IF;
        -- eninah 05/08/2025
        IF VE_ESTADO = 'R' THEN
          --SE OBTIENE LOS DATOS DE LA AQPD157
          BEGIN
            SELECT A.AQPD157CODCAR,
                   A.AQPD157EST,
                   A.AQPD157CMTA,
                   S.SNG055DSC
              INTO VI_USR_COD_CARGO,
                   VI_USR_ESTADO,
                   VI_COMENTARIO,
                   VI_CARGO_APR
              FROM AQPD157 A, SNG055 S
             WHERE A.AQPD157FECAPRO = VE_FECHAREG
               AND A.AQPD157CODREP = VE_CODREPROG
               AND A.AQPD157INST = VE_INSTANCIA
               AND A.AQPD157UAPRO = RPAD(TRIM(VO_USUARIO_APROB), 10, ' ')
               AND A.AQPD157EST IN ('P', 'R', 'A')
               AND S.SNG055EMP = 1
               AND S.SNG055CAR = A.AQPD157CODCAR;
          EXCEPTION
            WHEN OTHERS THEN
              VO_CODERROR := '0001';
              VO_MSGERROR := SUBSTR(SQLERRM, 1, 150);
              PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                         '',
                                                         'PQ_CR_REPROG_SIN_CAP',
                                                         'SP_ENVIAR_CORREO_PAPR',
                                                         '',
                                                         VO_CODERROR,
                                                         VO_MSGERROR);
              VO_MSGERROR := 'No se pudo obtener los datos para el envio del correo, pero si se llevo a gestionar';
          END;
          -----          
          lv_mensaje     := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado Analista ' ||
                           /*trim(VI_CARGO_APR) ||*/
                            ',</p>' ||
                            '<p "font-family: Arial, sans-serif; font-size: 14px;">Se ha rechazado la reprogramación ' ||
                            VOI_V_DSC_TRPG || ' sin CRM de ' ||
                            trim(VI_DATOS);
          VE_MENSAJE_LOG := 'Estimado(s)' || trim(VI_CARGO_APR) || ',' ||
                            'Se ha rechazado la reprogramación ' ||
                            VOI_V_DSC_TRPG || ' sin CRM de ' ||
                            trim(VI_DATOS);
          --OBTENER EL CORREO DEL APROBADOR.
          BEGIN
            SELECT W.WFUSREMAIL
              INTO lv_destinos_c
              FROM WFUSERS W
             WHERE W.WFUSRCOD = RPAD(TRIM(VE_USR_APROBR), 30, ' ');
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          --lv_destinos   := ;
          LV_DESTINOS_C := TRIM(lv_destinos_c) || ';' ||
                           TRIM(VI_MAIL_ANALISTA);
        END IF;
        -- eninah 05/08/2025
        BEGIN
          select case
                   when count(*) = (select count(*)
                                      from aqpd157 b
                                     where b.aqpd157inst = a.aqpd157inst
                                       and b.aqpd157codrep = a.aqpd157codrep
                                       and b.aqpd157est = 'A') then
                    'S'
                   else
                    'N'
                 end
            into validacion
            from aqpd157 a
           where a.aqpd157inst = VE_INSTANCIA
             and a.aqpd157codrep = VE_CODREPROG
             and a.aqpd157est <> 'P'
           group by a.aqpd157codrep, a.aqpd157inst;
        END;
        -- eninah 05/08/2025
        IF VE_ESTADO = 'AAA' and validacion = 'S' THEN
          VO_USUARIO_APROB := VE_USR_APROBR;
          lv_mensaje       := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado Analista se realizaron todas las Aprobaciones, ' ||
                              'de la reprogramación por ' || VOI_V_DSC_TRPG ||
                              ' sin CRM de ' || trim(VI_DATOS) ||
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">El cliente debe acercarse en ventanilla, para que se genere la reprogramación y recoger su nuevo cronograma';
          VE_MENSAJE_LOG   := 'Estimado Analista se realizaron todas las Aprobaciones' ||
                              'de la reprogramación por ' || VOI_V_DSC_TRPG ||
                              'l sin CRM de' ||
                              'El cliente debe acercarse en ventanilla, para que se genere la reprogramación recoger su nuevo cronograma';
          --OBTENER LOS CORREOS DE TODOS LOS APROBADORES.
          BEGIN
            PQ_CR_REPROG_SIN_CAP.SP_OBTENER_CORREOS_AQPD157(VE_FECHAREG,
                                                            VE_CODREPROG,
                                                            VE_INSTANCIA,
                                                            VO_CORREOS_APROB,
                                                            VO_CODERROR,
                                                            VO_MSGERROR);
          EXCEPTION
            WHEN OTHERS THEN
              VO_CODERROR := '0010';
              VO_MSGERROR := SUBSTR(SQLERRM, 1, 150);
              PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                         '',
                                                         'PQ_CR_REPROG_SIN_CAP',
                                                         'SP_ENVIAR_CORREO_PAPR',
                                                         '',
                                                         VO_CODERROR,
                                                         VO_MSGERROR);
              VO_MSGERROR := 'No se pudo enviar el correo pero si se llego a gestionar';
          END;
          lv_destinos   := TRIM(VI_MAIL_ANALISTA);
          LV_DESTINOS_C := TRIM(VO_CORREOS_APROB);
        END IF;
        ---------------------------------------------------------------
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Atentamente<br/>Caja Arequipa</strong></p>';
      EXCEPTION
        WHEN OTHERS THEN
          VO_CODERROR := '0006';
          VO_MSGERROR := SUBSTR(SQLERRM, 1, 150);
          PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                     '',
                                                     'PQ_CR_REPROG_SIN_CAP',
                                                     'SP_ENVIAR_CORREO_PAPR',
                                                     '',
                                                     VO_CODERROR,
                                                     VO_MSGERROR);
          VO_MSGERROR := 'No se pudo enviar el correo pero si se llego a gestionar';
      END;
      --SE AREGA EL CONTENIDO DEL CORREO AL DBMS_LOB.
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      --SE ENVIA EL CORREO.
      BEGIN
        -- Call the procedure
      
        pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos, -- 'eninah@cajaarequipa.pe', -- 
                                         p_destinatarioscc   => lv_destinos_c, -- 'jalvaroh@cajaarequipa.pe', -- 
                                         p_destinatariosbcc  => '', --'hsuarez@cajaarequipa.pe',
                                         p_mensaje           => ll_mensaje,
                                         p_remitente         => lv_remitente,
                                         p_asunto            => lv_asunto,
                                         p_tipomensaje       => 'HTML',
                                         p_directorio        => lv_directorio,
                                         p_archivosadjuntos  => lv_archivo,
                                         p_c_coderr          => VO_CODERROR,
                                         p_c_deserr          => VO_MSGERROR);
      
        ---------------------------------------
        PQ_CR_REPROG_SIN_CAP.SP_LOG_CORREO(VE_FECHAREG,
                                           VE_CODREPROG,
                                           VE_INSTANCIA,
                                           VE_ESTADO,
                                           VO_USUARIO_APROB,
                                           VE_MENSAJE_LOG,
                                           lv_destinos,
                                           lv_destinos_c,
                                           VO_CODERROR,
                                           VO_MSGERROR);
      EXCEPTION
        WHEN OTHERS THEN
          VO_CODERROR := '9999';
          VO_MSGERROR := SUBSTR(SQLERRM, 1, 150);
          PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                     '',
                                                     'PQ_CR_REPROG_SIN_CAP',
                                                     'SP_ENVIAR_CORREO_PAPR',
                                                     '',
                                                     VO_CODERROR,
                                                     VO_MSGERROR);
          VO_MSGERROR := 'No se pudo enviar el correo pero si se llego a gestionar';
      END;
      --SE LIBERA LA MEMORIA DEL DBMS_LOB.
      dbms_lob.freetemporary(ll_mensaje);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;
  PROCEDURE SP_OBTENER_CORREOS_AQPD157(VE_FECHAREG      IN DATE,
                                       VE_CODREPROG     IN NUMBER,
                                       VE_INSTANCIA     IN NUMBER,
                                       VO_CORREOS_APROB OUT VARCHAR,
                                       VO_CODERROR      OUT VARCHAR,
                                       VO_MSGERROR      OUT VARCHAR) IS
    --CURSORES PARA EL LISTADO.
    --------------------------
    CURSOR lista_Aprobadores_sinCRM(vi_codrpg   in number,
                                    vi_instance in number,
                                    vi_fecharpg in date) is
      select *
        from aqpd157 a
       where a.aqpd157codrep = vi_codrpg
         and a.aqpd157inst = vi_instance
         and a.aqpd157fecapro = vi_fecharpg
         and a.aqpd157est = 'A'
         and a.AQPD157REQ = 'S';
    lv_correog  VARCHAR(150);
    VI_CONTADOR NUMBER(3);
  BEGIN
    VO_CODERROR := '0000';
    BEGIN
      vi_contador := 0;
      for x in lista_Aprobadores_sinCRM(VE_CODREPROG, VE_INSTANCIA, VE_FECHAREG) loop
        --OBTENER DESCRIPCION CARGO
        /*
        BEGIN
           SELECT s.sng055dsc
             INTO vi_dcargo
             FROM SNG055 s
            WHERE s.SNG055CAR = x.AQPD157CODCAR;
        EXCEPTION
           WHEN OTHERS THEN
             vi_dcargo := 'Gerente';
        END;
        */
        --OBTENER CORREO DEL APROBADOR
        BEGIN
          select wfusremail
            into lv_correog
            from WFUSERS
           where wfusrcod = RPAD(X.AQPD157UAPRO, 30, ' ');
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        if x.AQPD157NIAP = 1 AND x.AQPD157NIDP = 0 then
          --vi_cargo_papr := vi_dcargo; 
          --vi_usr_papr   := X.AQPD157UAPRO;
          VO_CORREOS_APROB := lv_correog;
          --vi_cargo      := x.AQPD157CODCAR;
        end if;
      
        if vi_contador = 0 then
          VO_CORREOS_APROB := lv_correog;
          --vi_usuarios_aprobador := X.AQPD157UAPRO;
          --vi_cargos_aprobador := vi_dcargo;
        else
          if lv_correog is not null then
            VO_CORREOS_APROB := TRIM(VO_CORREOS_APROB) || ';' ||
                                TRIM(lv_correog);
            --vi_usuarios_aprobador := TRIM(vi_usuarios_aprobador)||';'||X.AQPD157UAPRO;
            --vi_cargos_aprobador := TRIM(vi_cargos_aprobador)||';'||vi_dcargo;
          end if;
        end if;
        vi_contador := vi_contador + 1;
      end loop;
    END;
  END;
  PROCEDURE SP_OBTENER_SGTE_APR(VE_FECHAREG      IN DATE,
                                VE_CODREPROG     IN NUMBER,
                                VE_INSTANCIA     IN NUMBER,
                                VO_USUARIO_APROB OUT VARCHAR,
                                VO_CARGO_APROB   OUT VARCHAR,
                                VO_CORREOS_APROB OUT VARCHAR,
                                VO_CODERROR      OUT VARCHAR,
                                VO_MSGERROR      OUT VARCHAR) IS
  BEGIN
    VO_CODERROR := '0000';
    BEGIN
      SELECT A.AQPD157UAPRO, S.SNG055DSC, W.WFUSREMAIL
        INTO VO_USUARIO_APROB, VO_CARGO_APROB, VO_CORREOS_APROB
        FROM AQPD157 A, SNG055 S, WFUSERS W
       WHERE A.AQPD157FECAPRO = VE_FECHAREG
         AND A.AQPD157CODREP = VE_CODREPROG
         AND A.AQPD157INST = VE_INSTANCIA
         AND A.AQPD157EST = 'P'
         AND A.AQPD157REQ = 'S'
         AND A.AQPD157NIAP = (SELECT MIN(A.AQPD157NIAP)
                                FROM AQPD157 A
                               WHERE A.AQPD157FECAPRO = VE_FECHAREG
                                 AND A.AQPD157CODREP = VE_CODREPROG
                                 AND A.AQPD157INST = VE_INSTANCIA
                                 AND A.AQPD157EST = 'P')
         AND S.SNG055EMP = 1
         AND S.SNG055CAR = A.AQPD157CODCAR
         AND W.WFUSRCOD = RPAD(TRIM(A.AQPD157UAPRO), 30, ' ')
         AND ROWNUM = 1;
    
    EXCEPTION
      WHEN OTHERS THEN
        VO_CODERROR := '0001';
        VO_MSGERROR := SUBSTR(SQLERRM, 1, 150);
        PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                   '',
                                                   'PQ_CR_REPROG_SIN_CAP',
                                                   'SP_OBTENER_SGTE_APR',
                                                   '',
                                                   VO_CODERROR,
                                                   VO_MSGERROR);
        VO_MSGERROR := 'No se pudo obtner el siguien aprobador, o no existe un siguiente aprobador';
    END;
  END;

  PROCEDURE SP_LOG_CORREO(VE_FECHAREG    IN DATE,
                          VE_CODREPROG   IN NUMBER,
                          VE_INSTANCIA   IN NUMBER,
                          VE_ESTADO      IN VARCHAR,
                          VE_USR_APROBR  IN VARCHAR,
                          VE_MENSAJE_LOG IN VARCHAR,
                          lv_destinos    IN VARCHAR,
                          lv_destinos_c  IN VARCHAR,
                          VO_CODERROR    OUT VARCHAR,
                          VO_MSGERROR    OUT VARCHAR) IS
  BEGIN
    VO_CODERROR := '0000';
    BEGIN
      IF VE_ESTADO = 'A' THEN
        UPDATE AQPD157 A
           SET A.AQPD157LOGPAPR = 'para: ' || TRIM(lv_destinos) ||
                                  '***con copia:' || TRIM(lv_destinos_c),
               A.AQPD157MPCORR  = VE_MENSAJE_LOG
         WHERE A.AQPD157FECAPRO = VE_FECHAREG
           AND A.AQPD157CODREP = VE_CODREPROG
           AND A.AQPD157INST = VE_INSTANCIA
           AND A.AQPD157EST = 'P'
           AND A.AQPD157REQ = 'S'
           AND A.AQPD157UAPRO = RPAD(TRIM(VE_USR_APROBR), 10, ' ');
        COMMIT;
      END IF;
      IF VE_ESTADO = 'AAA' THEN
        UPDATE AQPD157 A
           SET A.AQPD157LOGAPR = 'para: ' || TRIM(lv_destinos) ||
                                 '***con copia:' || TRIM(lv_destinos_c),
               A.AQPD157MCORR  = VE_MENSAJE_LOG
         WHERE A.AQPD157FECAPRO = VE_FECHAREG
           AND A.AQPD157CODREP = VE_CODREPROG
           AND A.AQPD157INST = VE_INSTANCIA
           AND A.AQPD157EST = 'A'
           AND A.AQPD157REQ = 'S'
           AND A.AQPD157UAPRO = RPAD(TRIM(VE_USR_APROBR), 10, ' ');
        COMMIT;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        VO_CODERROR := '0001';
        VO_MSGERROR := SUBSTR(SQLERRM, 1, 150);
        PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(VE_INSTANCIA,
                                                   '',
                                                   'PQ_CR_REPROG_SIN_CAP',
                                                   'SP_LOG_CORREO',
                                                   '',
                                                   VO_CODERROR,
                                                   VO_MSGERROR);
        VO_MSGERROR := 'No se pudo enviar el correo pero si se llego a gestionar';
    END;
  END;
  PROCEDURE SP_VALIDAR_TIPO_REPROGD(VIE_N_COREPROG IN NUMBER,
                                    VIE_N_INSTANCE IN NUMBER,
                                    VOE_N_COD_TRPG OUT NUMBER,
                                    VOE_V_DSC_TRPG OUT VARCHAR) IS
  BEGIN
  
    -- OBTENER TIPO DE REPROGRAMACION
    BEGIN
      SELECT JAQA400AN1
        INTO VOE_N_COD_TRPG
        FROM JAQA400
       WHERE JAQA400AI1 = VIE_N_INSTANCE
         AND JAQA400FEC = (SELECT MAX(JAQA400FEC)
                             FROM JAQA400
                            WHERE JAQA400AI1 = VIE_N_INSTANCE);
    EXCEPTION
      WHEN OTHERS THEN
        VOE_N_COD_TRPG := 10;
    END;
    --OBTENER DESCRPIPCION DEL TIPO DE REPROGRAMACION
    BEGIN
      SELECT TP1DESC
        INTO VOE_V_DSC_TRPG
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11161
         AND TP1CORR1 = 500
         AND TP1CORR2 = 10
         AND TP1CORR3 = VOE_N_COD_TRPG;
    EXCEPTION
      WHEN OTHERS THEN
        VOE_V_DSC_TRPG := 'Reprogramación'; -- Estaba con VOE_N_COD_TRPG -- corregido eninah 23/04/2025
    END;
  END;

  /*===================================================================================================*/
  PROCEDURE SP_CR_MANT_ARBOL_APROB(P_MODO      IN VARCHAR2,
                                   P_TPOREPROG IN NUMBER,
                                   P_GRUPO     IN NUMBER,
                                   P_NVLAPROB  IN NUMBER,
                                   P_CGOAPROB  IN NUMBER,
                                   P_PFLAPROB  IN VARCHAR2,
                                   P_DEPAPROB  IN NUMBER,
                                   P_USUREG    IN VARCHAR2,
                                   P_IMPMIN    IN NUMBER,
                                   P_IMPMAX    IN NUMBER,
                                   P_APROBREQ  IN VARCHAR2) IS
  
    -- ====================================================================================================
    -- NOMBRE                      : SP_CR_GRABAR_ARBOL_APROB
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 21/11/2024
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- USO                         : MODIFICA, ELIMINA Y AGREGA UN REGISTRO DE LA TABLA AQPC722
    -- PARAMETROS                  : - P_MODO      | VARCHAR2(3)
    --                               - P_TPOREPROG | NUMBER(4)
    --                               - P_GRUPO     | NUMBER(17)
    --                               - P_NVLAPROB  | NUMBER(3)
    --                               - P_CGOAPROB  | NUMBER(3)
    --                               - P_PFLAPROB  | VARCHAR2(10)
    --                               - P_USUREG    | VARCHAR2(10)
    --                               - P_IMPMIN    | NUMBER(17, 2)
    --                               - P_IMPMAX    | NUMBER(17, 2)
    --                               - P_APROBREQ  | VARCHAR2(1)
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    -- ====================================================================================================
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    -- ====================================================================================================                                   
  
    V_CORREL NUMBER(17) := 0;
  BEGIN
    BEGIN
      SELECT NVL(MAX(A1.AQPC722COR), 0) + 1
        INTO V_CORREL
        FROM AQPC722 A1
       WHERE A1.AQPC722TPRG = P_TPOREPROG;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF P_MODO = 'INS' THEN
      BEGIN
        INSERT INTO AQPC722
          (AQPC722COR,
           AQPC722TPRG,
           AQPC722CCARG,
           AQPC722PCARG,
           AQPC722NAPR,
           AQPC722NDAPR,
           AQPC722USRR,
           AQPC722FRG,
           AQPC722EST,
           AQPC722IMPMN,
           AQPC722IMPMAX,
           AQPC722REQ,
           AQPC722GRUPO)
        VALUES
          (V_CORREL,
           P_TPOREPROG,
           P_CGOAPROB,
           P_PFLAPROB,
           P_NVLAPROB,
           P_DEPAPROB,
           P_USUREG,
           SYSDATE,
           'S',
           P_IMPMIN,
           P_IMPMAX,
           P_APROBREQ,
           P_GRUPO);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
    IF P_MODO = 'UPD' THEN
      BEGIN
        UPDATE AQPC722 A
           SET A.AQPC722NDAPR  = P_DEPAPROB,
               A.AQPC722IMPMN  = P_IMPMIN,
               A.AQPC722IMPMAX = P_IMPMAX,
               A.AQPC722REQ    = P_APROBREQ,
               A.AQPC722USRM   = P_USUREG,
               A.AQPC722FMD    = SYSDATE
         WHERE A.AQPC722TPRG = P_TPOREPROG
           AND A.AQPC722EST = 'S'
           AND A.AQPC722GRUPO = P_GRUPO
           AND A.AQPC722CCARG = P_CGOAPROB
           AND A.AQPC722PCARG = RPAD(P_PFLAPROB, 10, ' ')
           AND A.AQPC722NAPR = P_NVLAPROB;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
    IF P_MODO = 'DEL' THEN
      BEGIN
        UPDATE AQPC722 A
           SET A.AQPC722EST = 'N'
         WHERE A.AQPC722TPRG = P_TPOREPROG
           AND A.AQPC722CCARG = P_CGOAPROB
           AND A.AQPC722NAPR = P_NVLAPROB
           AND A.AQPC722IMPMN = P_IMPMIN
           AND A.AQPC722IMPMAX = P_IMPMAX;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
  END SP_CR_MANT_ARBOL_APROB;
end pq_cr_reprog_sin_cap;
/
