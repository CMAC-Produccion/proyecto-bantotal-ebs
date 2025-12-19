create or replace package pq_cr_gestion_bloq_excepc_rpgsincap is

  -- *********************************************************************************
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Author                     : IGS_RCASTRO
  -- Created                    : 24/10/2025 16:32:51
  -- Purpose                    : PAQUETE DE GESTION DE BLOQUEANTES CON EXCEPCION
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 04/11/2025
  -- Autor de la Modificación   : rcastro
  -- Detalle:                   : se agrega validaciones para aprobaciones
  -- Fecha de Modificación      : 21/11/2025
  -- Autor de la Modificación   : rcastro
  -- Detalle:                   : se agrega validacion adicional para caso espc. aprob regional

  -- **********************************************************************************  

  PROCEDURE SP_VALIDAR_APROB_PERFIL(vi_cargo     in number,
                                    vi_perfilc   in varchar,
                                    ve_suc       in number,
                                    vo_aprobador out varchar);

  PROCEDURE sp_val_asign_metodo(pe_instancia   number,
                                pe_cuentacred  number,
                                pe_operaccred  number,
                                pe_codProceso  number,
                                pe_codMetodo   number,
                                pe_nommetodo   varchar2,
                                ps_cargoAsign  out number,
                                ps_perfilAsign out varchar2,
                                ps_usuario     out varchar2,
                                ps_mensaje     out varchar2,
                                ps_codError    out varchar2,
                                ps_msgError    out varchar2);

  PROCEDURE sp_valid_tiene_arbol_aprob(pe_AQPB955REG    VARCHAR2, --VARIABLE DE REGLA
                                       pe_usuarioIng    varchar2, --usuario                       
                                       ps_flgTieneArbol OUT varchar2);

  PROCEDURE SP_ARMAR_ARBOL_AQPd159(pe_fecSolic      date,
                                   pe_fecReprogA400 date,
                                   pe_instancia     number,
                                   pe_VariableRNG   varchar2,
                                   pe_aqpc203Corr   number,
                                   pe_aqpc203AC1    varchar2, --text cargos
                                   pe_aqpc203AC2    varchar2, --text perfiles
                                   pe_aqpc202sucur  number,
                                   pe_tiporeprog    number,
                                   --  pe_CargoAprob      number,
                                   --  pe_PerfilAprob     varchar2,
                                   --  pe_UsuarioAprob    varchar2,
                                   pe_UsuarioRegistro varchar2,
                                   ps_CodError        out varchar2,
                                   ps_MsgError        out varchar2);
                                   
   PROCEDURE SP_CARGA_BLOQ_202_203(INSTANCIA NUMBER, PE_USU_ING VARCHAR2);                                  
   PROCEDURE SP_AUTORIZAR_EXCEPCION(
                                    VE_CORRELATIVO  IN NUMBER,                                     
                                    VE_AUTORIZADOR  IN VARCHAR,
                                    VE_COMENTARIO   IN VARCHAR,
                                    VE_ESTADO       IN VARCHAR,
                                    VE_CORRBLOQ     IN NUMBER,
                                    VE_INSTANCIA    IN NUMBER                                 
                                  );
   PROCEDURE SP_ARMAR_VARIABLE(
                               VE_CORRBLOQ IN NUMBER,
                               VE_INSTANCIA IN NUMBER,
                               VO_VARIABLE OUT VARCHAR                              
                             );
                             
   PROCEDURE SP_VALIDAR_APROB_BLOQ_203_RC(VE_INSTANCIA NUMBER, VE_VARIABLE VARCHAR2, VO_FLAGEXCEP OUT VARCHAR2);                             
end pq_cr_gestion_bloq_excepc_rpgsincap;
/
create or replace package body pq_cr_gestion_bloq_excepc_rpgsincap is

  PROCEDURE SP_VALIDAR_APROB_PERFIL(vi_cargo     in number,
                                    vi_perfilc   in varchar,
                                    ve_suc       in number,
                                    vo_aprobador out varchar) IS
    vgerentec varchar(12);
    VI_REGCOD number(3);
  BEGIN
    --OBTENER CODIGO DE REGION
    BEGIN
      SELECT F.REGCOD
        INTO VI_REGCOD
        FROM FST811 F
       WHERE F.OFICOD = ve_suc
         AND F.REGCOD <= 100
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    IF vi_cargo = 202 THEN
      SELECT S.SNG057USR
        INTO vgerentec
        FROM SNG057 S, FST046 F, PRFU00 P
       WHERE S.SNG055EMP = 1
         AND S.SNG055CAR = VI_CARGO
         AND P.PGCOD = S.SNG055EMP
         AND P.UBUSER = S.SNG057USR
         AND P.PRFGCOD <> rpad('CESADO', 10, ' ')
         AND F.PGCOD = 1
         AND F.UBUSER = S.SNG057USR
         AND F.UBSUC = ve_suc
         AND ROWNUM = 1;
      vo_aprobador := vgerentec;
    END IF;
    IF vi_cargo = 220 THEN
      IF TRIM(vi_perfilc) = 'JZON01' THEN
        BEGIN
          select sng057usr
            INTO vgerentec
            from fst811 f, sng057 s, fst046 t
           where f.regcod = VI_REGCOD
             and s.sng055car = 220
             and t.ubuser = s.sng057usr
                --and s.sng057aut = 'S'
             and f.oficod = t.ubsuc
             AND ROWNUM = 1;
          vo_aprobador := vgerentec;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
      IF TRIM(vi_perfilc) = 'GREG01' THEN
        BEGIN
          SELECT F.REGCOD
            INTO VI_REGCOD
            FROM REGSUC F
           WHERE F.SUCURS = ve_suc;
        
          SELECT F.UBUSER
            INTO vgerentec
            FROM REGSUC R, FST046 F, PRFU00 P, SNG057 S
           WHERE R.REGCOD = VI_REGCOD
             AND R.SUCURS = F.UBSUC
             AND F.UBUSER = P.UBUSER
             AND P.PRFGCOD = 'GREG01'
             AND S.SNG055EMP = F.PGCOD
             AND S.SNG057USR = P.UBUSER
             AND S.SNG055CAR = 220
             AND ROWNUM = 1;
          --AND S.SNG057AUT = 'S';
          vo_aprobador := vgerentec;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
    END IF;
    IF vi_cargo in (223, 230, 240, 930, 362, 401) THEN
      SELECT S.SNG057USR
        INTO vgerentec
        FROM SNG057 S, PRFU00 P
       WHERE S.SNG055EMP = 1
         AND S.SNG055CAR = VI_CARGO
         AND SNG057AUT = 'S'
         AND P.PGCOD = S.SNG055EMP
         AND P.UBUSER = S.SNG057USR
         AND P.PRFGCOD <> rpad('CESADO', 10, ' ')
         AND ROWNUM = 1;
      vo_aprobador := vgerentec;
    END IF;
  END;

  PROCEDURE sp_val_asign_metodo(pe_instancia   number,
                                pe_cuentacred  number,
                                pe_operaccred  number,
                                pe_codProceso  number,
                                pe_codMetodo   number,
                                pe_nommetodo   varchar2,
                                ps_cargoAsign  out number,
                                ps_perfilAsign out varchar2,
                                ps_usuario     out varchar2,
                                ps_mensaje     out varchar2,
                                ps_codError    out varchar2,
                                ps_msgError    out varchar2) IS
    V_PEPAIS NUMBER(4);
    V_PETDOC NUMBER(4);
    V_PENDOC VARCHAR2(12);
  
    SEGMENTO         VARCHAR2(10);
    TABLA            VARCHAR2(15);
    NIVEL_RIESGO     VARCHAR2(100);
    V_SCORE_ACTU     VARCHAR2(30);
    PROGRAMA         VARCHAR2(10);
    PROBALIDAD       NUMBER(8, 7);
    PDCAL            NUMBER(8, 7);
    FECHA_SCORE      DATE;
    lc_user          VARCHAR2(10);
    PV_SCORE_CLIENTE varchar2(20);
    V_AUXUSUARIO     VARCHAR2(10);
  
    AuxCodCargo      NUMBER(5);
    AuxPerfil        VARCHAR2(10);
    AuxCorreFst198   number(2);
    Aux_Formtmensaje VARCHAR2(300);
    Aux_DescpAprob   varchar2(100);
  
    aux_sucursal number(5);
  
    auxResultado varCHAr2(1);
    auxMsgError  varchar2(200);
    auxCodError  varchar2(4);
  
  BEGIN
    ps_cargoAsign  := 0;
    ps_perfilAsign := '';
    AuxCorreFst198 := 0;
    ps_usuario     := '';
    ps_mensaje     := '';
    ps_codError    := '';
    ps_msgError    := '';
    Aux_DescpAprob := '';
  
    IF pe_codMetodo = 1 THEN
      --VAL_SCORE_RNG   
      --maria
      begin
        PQ_CR_LIMITES_RPG.SP_CR_VALIDA_LIMITE_REGION(PI_INSTANCIA => pe_instancia,
                                                     PI_USUARIO   => '',
                                                     PO_RESULTADO => auxResultado,
                                                     PO_COD_ERROR => auxCodError,
                                                     PO_MSG_ERROR => auxMsgError);
      exception
        when others then
          null;
      end;
    
      BEGIN
        SELECT PEPAIS, PETDOC, PENDOC
          INTO V_PEPAIS, V_PETDOC, V_PENDOC
          FROM FSR008
         WHERE CTNRO = pe_cuentacred
           AND CTTFIR = 'T';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      V_PENDOC := TRIM(V_PENDOC);
    
      --VALIDAR SCORE 
      PROGRAMA         := '';
      SEGMENTO         := NULL;
      TABLA            := NULL;
      NIVEL_RIESGO     := NULL;
      V_SCORE_ACTU     := NULL;
      PROBALIDAD       := 0;
      PDCAL            := 0;
      FECHA_SCORE      := NULL;
      PV_SCORE_CLIENTE := NULL;
      lc_user          := '';
    
      BEGIN
        PQ_CR_SCORE_RCC.SP_CR_SCOREDNI_II(LN_INST       => 0,
                                          LN_TDOC       => V_PETDOC,
                                          LC_NDOC       => V_PENDOC,
                                          LC_PRGM       => PROGRAMA,
                                          LC_USER       => lc_user,
                                          LC_SCORE      => NIVEL_RIESGO,
                                          LN_PROBAL     => PROBALIDAD,
                                          LC_SEGMRIESGO => SEGMENTO,
                                          LN_PDCAL      => PDCAL,
                                          LC_TABLA      => TABLA,
                                          LD_FCHSCORE   => FECHA_SCORE,
                                          LC_SCOREABR   => PV_SCORE_CLIENTE,
                                          LC_NEWSCORE   => V_SCORE_ACTU);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      V_SCORE_ACTU := trim(UPPER(V_SCORE_ACTU));
    
      IF (V_SCORE_ACTU = 'PRIME' OR V_SCORE_ACTU = 'ESTANDAR') and
         auxResultado = 'S' THEN
        --MESA DE CREDITOS        
        AuxCorreFst198 := 1;
        Aux_DescpAprob := 'debe ser autorizado por Mesa de Creditos';
      ELSE
        IF ((V_SCORE_ACTU = 'POTENCIAL' OR V_SCORE_ACTU = 'SUSTANCIAL') OR (V_SCORE_ACTU = 'SIN SCORE' OR (V_SCORE_ACTU IS NULL AND TRIM(V_SCORE_ACTU) = ''))) and auxResultado = 'S' THEN
          --SENIOR SUPERIOR DE ADMISION Y SEGUI 
          AuxCorreFst198 := 0;--2;
          Aux_DescpAprob := 'el caso necesita opinión de riesgos'; --'Admisión y Seguimiento';
          
          BEGIN
          SELECT AQPD160MGBLOQ
          INTO Aux_Formtmensaje
          FROM AQPD160 A
          WHERE A.AQPD160CORR = pe_codProceso;
          EXCEPTION
          WHEN OTHERS THEN
          Aux_Formtmensaje := '';
          END;
          
          Aux_Formtmensaje := REPLACE(Aux_Formtmensaje,
                                    '{textofinal}',
                                    Aux_DescpAprob);          
                
          Aux_Formtmensaje := REPLACE(Aux_Formtmensaje,
                                  '{Autorizante}',
                                  Aux_DescpAprob);
                  
          if V_SCORE_ACTU is not null then                            
          Aux_Formtmensaje := REPLACE(Aux_Formtmensaje,
                                  '{Score}',
                                  V_SCORE_ACTU); 
          end If;
          ps_mensaje := trim(Aux_Formtmensaje);
        END IF;
      END IF;
      
      /*IF (V_SCORE_ACTU = 'SIN SCORE' OR (V_SCORE_ACTU IS NULL AND TRIM(V_SCORE_ACTU) = '')) AND auxResultado = 'S' THEN
         AuxCorreFst198 := 0;--2;
         Aux_DescpAprob := 'Admisión y Seguimiento';
      END IF;*/
    
      IF AuxCorreFst198 > 0 THEN
        BEGIN
          SELECT AQPD160MGBLOQ
            INTO Aux_Formtmensaje
            FROM AQPD160 A
           WHERE A.AQPD160CORR = pe_codProceso;
        EXCEPTION
          WHEN OTHERS THEN
            Aux_Formtmensaje := '';
        END;
        
        Aux_Formtmensaje := REPLACE(Aux_Formtmensaje,
                                    '{textofinal}',
                                    Aux_DescpAprob);
        
      
        Aux_Formtmensaje := REPLACE(Aux_Formtmensaje,
                                    '{Autorizante}',
                                    Aux_DescpAprob);
        
        if V_SCORE_ACTU is not null then                            
        Aux_Formtmensaje := REPLACE(Aux_Formtmensaje,
                                    '{Score}',
                                    V_SCORE_ACTU); 
        end If;
                                                                     
                                    
      
        ps_mensaje := trim(Aux_Formtmensaje);
      
        BEGIN
          SELECT TP1NRO3, trim(TP1DESC)
            INTO AuxCodCargo, AuxPerfil
            FROM FST198
           WHERE TP1COD = 1
             AND tp1cod1 = 11152
             AND TP1CORR1 = 315
             AND TP1CORR2 = 1
             AND TP1CORR3 = AuxCorreFst198;
        EXCEPTION
          WHEN OTHERS THEN
            AuxCodCargo := 0;
            AuxPerfil   := '';
        END;
      
        ps_cargoAsign  := AuxCodCargo;
        ps_perfilAsign := trim(AuxPerfil);
      
        BEGIN
          SELECT W.XWFSUCURSAL
            INTO aux_sucursal
            FROM XWF700 W
           WHERE W.XWFPRCINS = pe_instancia
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        aux_sucursal := NVL(aux_sucursal, 0);
      
        -- SE OBTIENE USUARIO DERIVADO
      
        BEGIN
          pq_cr_gestion_bloq_excepc_rpgsincap.SP_VALIDAR_APROB_PERFIL(vi_cargo     => ps_cargoAsign,
                                                                      vi_perfilc   => ps_perfilAsign,
                                                                      ve_suc       => aux_sucursal, -- MANDAR SUCURSAL CRED
                                                                      vo_aprobador => V_AUXUSUARIO);
        EXCEPTION
          WHEN OTHERS THEN
            V_AUXUSUARIO := '';
        END;
        ps_usuario := NVL(V_AUXUSUARIO, '');
      END IF;
    END IF;
  END;

  PROCEDURE sp_valid_tiene_arbol_aprob(pe_AQPB955REG    VARCHAR2, --VARIABLE DE REGLA
                                       pe_usuarioIng    varchar2, --usuario                       
                                       ps_flgTieneArbol OUT varchar2) IS
    AUX_varibRegla varchar2(40);
  BEGIN
    AUX_varibRegla := trim(pe_AQPB955REG);
    BEGIN
      SELECT 'S'
        INTO ps_flgTieneArbol
        FROM AQPC849 B, AQPC780 A
       WHERE B.AQPC849CODVARI = A.AQPC780CORR
         AND A.AQPC780NOMVAR = AUX_varibRegla
         AND B.AQPC849EST = 'S'
         and ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        ps_flgTieneArbol := 'N';
    END;
  
    ps_flgTieneArbol := nvl(ps_flgTieneArbol, 'N');
  END;

  PROCEDURE SP_ARMAR_ARBOL_AQPd159(pe_fecSolic      date,
                                   pe_fecReprogA400 date,
                                   pe_instancia     number,
                                   pe_VariableRNG   varchar2,
                                   pe_aqpc203Corr   number,
                                   pe_aqpc203AC1    varchar2, --text cargos
                                   pe_aqpc203AC2    varchar2, --text perfiles
                                   pe_aqpc202sucur  number,
                                   pe_tiporeprog    number,
                                   --   pe_CargoAprob      number, ---
                                   --   pe_PerfilAprob     varchar2, ---
                                   --   pe_UsuarioAprob    varchar2, ----
                                   pe_UsuarioRegistro varchar2,
                                   ps_CodError        out varchar2,
                                   ps_MsgError        out varchar2) IS
    --CURSORES LISTADO
    CURSOR LISTADO_MATRIZ_AUTORIZANTES(VI_COD_REGLA IN NUMBER,
                                       VI_TIPORPG   IN NUMBER) IS
      SELECT *
        FROM AQPC849 A
       WHERE A.AQPC849CODVARI = VI_COD_REGLA
         AND A.AQPC849TPRG = VI_TIPORPG
         AND A.AQPC849EST = 'S'
         AND A.AQPC849REQ = 'S'
       ORDER BY AQPC849COR ASC;
  
    v_FechActual      Date;
    v_HoraActual      varchar2(10);
    v_CodigoVariabRNG number(10);
  
    v_cargos   VARCHAR2(200); -- := '202,220,310';
    v_perfiles VARCHAR2(200); --:= 'GAGE01,GREG01,GADM01';
    TYPE t_varchar_array IS TABLE OF VARCHAR2(50);
    v_cargos_arr   t_varchar_array := t_varchar_array();
    v_perfiles_arr t_varchar_array := t_varchar_array();
  
    v_count INTEGER;
  
    vi_cargo        number(3);
    aux_cargoItem   number(5);
    aux_perfilItem  varchar2(10);
    vi_sautorizador varchar2(10);
    V_NROREGLA_ASIGN NUMBER(5);
  BEGIN
    BEGIN
      SELECT PGFAPE INTO v_FechActual FROM FST017 WHERE PGCOD = 1;
      SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') INTO v_HoraActual FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN
        null;
    END;
    
  
  
    --buscar matriz de dependencia o no en AQPC849
    BEGIN
        SELECT
          JAQA400AN1 -- 93,94 O 95                    
         INTO V_NROREGLA_ASIGN
         FROM JAQA400
         WHERE jaqa400ai1 = pe_instancia AND jaqa400est = 'E' AND JAQA400FEC = (SELECT MAX(JAQA400FEC)FROM JAQA400 WHERE
               jaqa400ai1 = pe_instancia AND jaqa400est = 'E') AND ROWNUM = 1;
   EXCEPTION
        WHEN OTHERS THEN
          V_NROREGLA_ASIGN := 0;
   END;
      V_NROREGLA_ASIGN := NVL(V_NROREGLA_ASIGN, 0);    
    
    BEGIN
      select AQPC780CORR
        INTO v_CodigoVariabRNG
        from AQPC780
       WHERE AQPC780NOMVAR = pe_VariableRNG
       AND AQPC780NUMRGL =  V_NROREGLA_ASIGN ; --93,94,95
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF v_CodigoVariabRNG > 0 THEN
      v_count := 0;
    
      -- SE OBTIENE EL CARGO Y PERFIL Y USUARIO APROBADOR USANDO CAMPOS AUX AQPC203AC1 Y AQPC203AC2
      -- BUSCAR APROBADORES USANDO LOGICA PARA SEPARAR CARGOS Y PERFILES
      v_cargos   := pe_aqpc203AC1;
      v_perfiles := pe_aqpc203ac2;
    
      -- Dividir cadenas en arreglos
      BEGIN
        SELECT REGEXP_SUBSTR(v_cargos, '[^,]+', 1, LEVEL)
          BULK COLLECT
          INTO v_cargos_arr
          FROM dual
        CONNECT BY REGEXP_SUBSTR(v_cargos, '[^,]+', 1, LEVEL) IS NOT NULL;
      
        SELECT REGEXP_SUBSTR(v_perfiles, '[^,]+', 1, LEVEL)
          BULK COLLECT
          INTO v_perfiles_arr
          FROM dual
        CONNECT BY REGEXP_SUBSTR(v_perfiles, '[^,]+', 1, LEVEL) IS NOT NULL;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      FOR rowItemAprob IN LISTADO_MATRIZ_AUTORIZANTES(v_CodigoVariabRNG, pe_tiporeprog) LOOP
        v_count := v_count + 1;
      
        -- FOR i IN 1 .. LEAST(v_cargos_arr.COUNT, v_perfiles_arr.COUNT) LOOP
        DBMS_OUTPUT.PUT_LINE('Iteración ' || v_count);
        DBMS_OUTPUT.PUT_LINE('  Cargo: ' || v_cargos_arr(v_count));
        DBMS_OUTPUT.PUT_LINE('  Perfil: ' || v_perfiles_arr(v_count));
      
        -- proceso de aprobación
        aux_cargoItem  := trim(v_cargos_arr(v_count));
        aux_perfilItem := trim(v_perfiles_arr(v_count));
      
        BEGIN
          pq_cr_gestion_bloq_excepc_rpgsincap.SP_VALIDAR_APROB_PERFIL(aux_cargoItem,
                                                                      aux_perfilItem,
                                                                      pe_aqpc202sucur,
                                                                      vi_sautorizador);
        EXCEPTION
          WHEN OTHERS then
            NULL;
        END;
      
        BEGIN
          INSERT INTO AQPD159
            (AQPD159FECSOL,
             AQPD159FECREP,
             AQPD159VAREGLA,
             AQPD159CORBLO,
             AQPD159TPRPSC,
             AQPD159INST,
             AQPD159TIPREP,
             AQPD159CODCAR,
             AQPD159PERUS,
             AQPD159UAPRO,
             AQPD159EST,
             AQPD159UREG,
             AQPD159UUP,
             AQPD159FECREG,
             AQPD159HORREG,
             AQPD159FEACT,
             AQPD159HORACT,
             --AQPD159MCORR,
             AQPD159NIAP,
             AQPD159NIDP,
             --AQPD159CMTA,
             AQPD159REQ,
             AQPD159UAPRR,
             AQPD159MPCORR,
             AQPD159LOGPAPR,
             AQPD159LOGAPR)
          VALUES
            (pe_fecSolic,
             pe_fecReprogA400,
             pe_VariableRNG,
             pe_aqpc203Corr,
             pe_tiporeprog, --consultar con q campo
             pe_instancia,
             pe_tiporeprog,
             aux_cargoItem,
             aux_perfilItem,
             vi_sautorizador,
             'P', --pendiente aprobacion 
             pe_UsuarioRegistro,
             '',
             v_FechActual,
             v_HoraActual,
             null,
             '',
             rowItemAprob.Aqpc849napr,
             rowItemAprob.Aqpc849ndapr,
             'S',
             '',
             '',
             '',
             '');
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            ps_CodError := '0001';
            ps_MsgError := 'Error al grabar en la tabla AQPD159 - pq_cr_gestion_bloq_excepc_rpgsincap.SP_ARMAR_ARBOL_AQPd159';
        END;
      
      --  EXIT;  --SALIR DEL LOOP QUE REOCRRE EL ARREGLO
      --END LOOP;
      
      END LOOP;
    END IF;
  END;

  PROCEDURE SP_CARGA_BLOQ_202_203(INSTANCIA NUMBER, PE_USU_ING VARCHAR2) IS
    P_N_EMP    NUMBER(3);
    P_N_MOD    NUMBER(4);
    P_N_SUC    NUMBER(4);
    P_N_MDA    NUMBER(4);
    P_N_PAP    NUMBER(4);
    P_N_CTA    NUMBER(9);
    P_N_OPE    NUMBER(9);
    P_N_SBO    NUMBER(4);
    P_N_TOP    NUMBER(4);
    P_N_FECHA  DATE;
    P_N_HOR    VARCHAR2(10);
    P_N_USUING VARCHAR2(10);
  
    V_CORRE_MAX      NUMBER(17);
    V_PEPAIS         NUMBER(5);
    V_PETDOC         NUMBER(5);
    V_PENDOC         VARCHAR2(12);
    V_NOMBCLI        VARCHAR2(50);
    V_PRODUC         VARCHAR2(30);
    V_SALDO          NUMBER(17, 2);
    v_aqpc202msg     VARCHAR2(100);
    V_HORAREGI       VARCHAR2(10);
    V_FLGOK202       VARCHAR2(1);
    V_TIPOREPROG     NUMBER(5);
    V_NROREGLA_ASIGN NUMBER(5);
    V_FLGTIENEARBOL  VARCHAR2(1);
    V_FLG_EXIST_955  VARCHAR2(1);
    V_FLG_APROB_TOT_202  VARCHAR2(1);
    V_AQPC202COR_AUX NUMBER(17); 
    v_max_corr202    number(17);   
  
    CURSOR LIST_BLOQUE_955 IS
      SELECT aqpb955cod,
             aqpb955reg,
             aqpb955des,
             aqpb955usr,
             aqpb955cor,
             aqpb955ccar,
             aqpb955perfi
        FROM AQPB955
       WHERE AQPB955COD = INSTANCIA
         AND AQPB955USR = RPAD(PE_USU_ING, 10, ' ');
  BEGIN
  
    BEGIN
      sP_ACTIVAS_OBTIENE_JAQA400(P_N_INS => INSTANCIA,
                                 P_N_EMP => P_N_EMP,
                                 P_N_MOD => P_N_MOD,
                                 P_N_SUC => P_N_SUC,
                                 P_N_MDA => P_N_MDA,
                                 P_N_PAP => P_N_PAP,
                                 P_N_CTA => P_N_CTA,
                                 P_N_OPE => P_N_OPE,
                                 P_N_SBO => P_N_SBO,
                                 P_N_TOP => P_N_TOP,
                                 P_D_FEC => P_N_FECHA,
                                 P_C_HOR => P_N_HOR,
                                 P_C_USU => P_N_USUING);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    --VALIDAR que haya una bloqueante en la AQPD955
    V_FLG_EXIST_955 := 'N';
    BEGIN
       SELECT 'S' INTO V_FLG_EXIST_955
        FROM AQPB955
       WHERE AQPB955COD = INSTANCIA
         AND AQPB955USR = RPAD(PE_USU_ING, 10, ' ')
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        V_FLG_EXIST_955 := 'N';
    END;
    V_FLG_EXIST_955 := NVL(V_FLG_EXIST_955, 'N');
    
    --validar que se inserte nuevamente solo 
    
    ---validar el maximo correlativo por instancia
    v_max_corr202 := 0;
    BEGIN
      
      select max(AQPC202COR) INTO v_max_corr202  from AQPC202 WHERE 
      AQPC202EMP = P_N_EMP AND
      AQPC202MOD = P_N_MOD AND
      AQPC202SUC = P_N_SUC AND
      AQPC202MDA = P_N_MDA AND 
      AQPC202PAP = P_N_PAP AND
      AQPC202CTA = P_N_CTA AND 
      AQPC202OPE = P_N_OPE AND
      AQPC202SBO = P_N_SBO AND
      AQPC202TOP = P_N_TOP AND 
      AQPC202INS = INSTANCIA  AND 
      AQPC202FEC = P_N_FECHA AND
      AQPC202USU = RPAD(PE_USU_ING, 10, ' ') ;                 
    EXCEPTION
      WHEN OTHERS THEN
        v_max_corr202 := 0; 
    END;    
    v_max_corr202 := NVL(v_max_corr202,0);
    
    
    V_FLG_APROB_TOT_202 := 'N';
    V_AQPC202COR_AUX := 0;
    
    BEGIN      
      select 'S', AQPC202COR INTO V_FLG_APROB_TOT_202, V_AQPC202COR_AUX  from AQPC202 WHERE 
      AQPC202EMP = P_N_EMP AND
      AQPC202MOD = P_N_MOD AND
      AQPC202SUC = P_N_SUC AND
      AQPC202MDA = P_N_MDA AND 
      AQPC202PAP = P_N_PAP AND
      AQPC202CTA = P_N_CTA AND 
      AQPC202OPE = P_N_OPE AND
      AQPC202SBO = P_N_SBO AND
      AQPC202TOP = P_N_TOP AND 
      AQPC202INS = INSTANCIA  AND 
      AQPC202FEC = P_N_FECHA AND
      AQPC202COR = v_max_corr202 AND
      AQPC202USU = RPAD(PE_USU_ING, 10, ' ') AND      
      AQPC202EST NOT IN ('A', 'R');               
    EXCEPTION
      WHEN OTHERS THEN
        V_FLG_APROB_TOT_202 := 'N'; 
    END;
    V_FLG_APROB_TOT_202 := nvl(V_FLG_APROB_TOT_202, 'N');
    
   /* BEGIN
      select AQPC202COR INTO V_AQPC202COR_AUX  from AQPC202 WHERE 
      AQPC202EMP = P_N_EMP AND
      AQPC202MOD = P_N_MOD AND
      AQPC202SUC = P_N_SUC AND
      AQPC202MDA = P_N_MDA AND 
      AQPC202PAP = P_N_PAP AND
      AQPC202CTA = P_N_CTA AND 
      AQPC202OPE = P_N_OPE AND
      AQPC202SBO = P_N_SBO AND
      AQPC202TOP = P_N_TOP AND 
      AQPC202INS = INSTANCIA  AND 
      AQPC202FEC = P_N_FECHA AND
      AQPC202USU = RPAD(PE_USU_ING, 10, ' ')  AND
      AQPC202EST = 'P' AND
      ROWNUM = 1; 
    EXCEPTION
      WHEN OTHERS THEN
        NULL;      
    END; 
    
    V_AQPC202COR_AUX := NVL(V_AQPC202COR_AUX, 0);
    
    IF V_FLG_EXIST_202 = 'N' THEN 
      BEGIN
       DELETE  FROM AQPC202 WHERE 
      AQPC202EMP = P_N_EMP AND
      AQPC202MOD = P_N_MOD AND
      AQPC202SUC = P_N_SUC AND
      AQPC202MDA = P_N_MDA AND 
      AQPC202PAP = P_N_PAP AND
      AQPC202CTA = P_N_CTA AND 
      AQPC202OPE = P_N_OPE AND
      AQPC202SBO = P_N_SBO AND
      AQPC202TOP = P_N_TOP AND 
      AQPC202INS = INSTANCIA  AND 
      AQPC202FEC = P_N_FECHA AND
      --AQPC202COR = V_AQPC202COR_AUX AND
      AQPC202USU = RPAD(PE_USU_ING, 10, ' ') AND 
       AQPC202EST = 'P';
      COMMIT;
     EXCEPTION
      WHEN OTHERS THEN
        NULL;       
      END;
      --AQPC203
      BEGIN 
      DELETE FROM AQPC203 WHERE AQPC203COR = V_AQPC202COR_AUX AND AQPC203FEC = P_N_FECHA AND AQPC203USU = PE_USU_ING ;
      COMMIT; 
     EXCEPTION
      WHEN OTHERS THEN
        NULL;       
      END;      
    END IF; */
  
    IF P_N_CTA > 0 AND P_N_OPE > 0 AND P_N_FECHA IS NOT NULL AND V_FLG_EXIST_955 = 'S' AND V_FLG_APROB_TOT_202 = 'N' THEN
      V_FLGOK202 := 'N';
      --cliente
      BEGIN
        SELECT PEPAIS, PETDOC, PENDOC
          INTO V_PEPAIS, V_PETDOC, V_PENDOC
          FROM FSR008
         WHERE Pgcod = P_N_EMP
           AND Ctnro = P_N_CTA
           AND Cttfir = 'T'
           AND Ttcod = 1
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      BEGIN
        SELECT Penom INTO V_NOMBCLI
          FROM FSD001
         WHERE Pepais = V_PEPAIS
           AND Petdoc = V_PETDOC
           AND Pendoc = V_PENDOC;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      BEGIN
        SELECT Tonom
          INTO V_PRODUC
          FROM FST004
         WHERE Modulo = P_N_MOD
           AND Totope = P_N_TOP;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      BEGIN
        SELECT Scsdo
          INTO V_SALDO
          FROM FSD011
         WHERE Pgcod = P_N_EMP
           AND Scmod = P_N_MOD
           AND Scmda = P_N_MDA
           AND Scpap = P_N_PAP
           AND Sccta = P_N_CTA
           AND Scsuc = P_N_SUC
           AND Scoper = P_N_OPE
           AND Scsbop = P_N_SBO
           AND Sctope = P_N_TOP
           AND Scstat <> 99;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      V_SALDO := NVL(V_SALDO, 0);
    
      V_SALDO := V_SALDO * (-1);
      
      
      BEGIN
        SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') INTO V_HORAREGI FROM DUAL;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      BEGIN
        SELECT NVL(MAX(AQPC202COR), 0) + 1 INTO V_CORRE_MAX FROM AQPC202; -- Obtiene siguiente correlativo  
      EXCEPTION
        WHEN OTHERS THEN
          V_CORRE_MAX := 0;
      END;
    
      V_CORRE_MAX := NVL(V_CORRE_MAX, 0);
    
      BEGIN
        insert into aqpc202
          (aqpc202emp,
           aqpc202mod,
           aqpc202suc,
           aqpc202mda,
           aqpc202pap,
           aqpc202cta,
           aqpc202ope,
           aqpc202sbo,
           aqpc202top,
           aqpc202ins,
           aqpc202cor,
           aqpc202aut,
           aqpc202cli,
           aqpc202pro,
           aqpc202sal,
           aqpc202est,
           aqpc202msg,
           aqpc202fea,
           aqpc202hoa,
           aqpc202usa,
           -- aqpc202ac1,
           -- aqpc202ac2,
           -- aqpc202an1,
           -- aqpc202an2,
           --  aqpc202ad1,
           -- aqpc202ad2,
           aqpc202fec,
           aqpc202hor,
           aqpc202usu)
        values
          (P_N_EMP,
           P_N_MOD,
           P_N_SUC,
           P_N_MDA,
           P_N_PAP,
           P_N_CTA,
           P_N_OPE,
           P_N_SBO,
           P_N_TOP,
           INSTANCIA,
           V_CORRE_MAX,
           '',
           V_NOMBCLI,
           V_PRODUC,
           V_SALDO,
           'P',
           v_aqpc202msg,
           P_N_FECHA,
           P_N_HOR,
           P_N_USUING,
           --v_aqpc202ac1,
           -- v_aqpc202ac2,
           -- v_aqpc202an1,
           --v_aqpc202an2,
           -- v_aqpc202ad1,
           -- v_aqpc202ad2,
           P_N_FECHA,
           V_HORAREGI,
           P_N_USUING);
        COMMIT;
        V_FLGOK202 := 'S';
      EXCEPTION
        WHEN OTHERS THEN
          V_FLGOK202 := 'N';
          ROLLBACK;
      END;
    
      -----CARGAR BLOQUEANTES AQPC203
      IF V_FLGOK202 = 'S' THEN
        V_FLGOK202 := 'N';
        BEGIN
          SELECT JAQA400AN1 -- 93,94 O 95                    
            INTO V_NROREGLA_ASIGN
            FROM JAQA400
           WHERE jaqa400ai1 = INSTANCIA
             AND jaqa400est = 'E'
             AND JAQA400FEC = (SELECT MAX(JAQA400FEC)
                                 FROM JAQA400
                                WHERE jaqa400ai1 = INSTANCIA
                                  AND jaqa400est = 'E')
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            V_NROREGLA_ASIGN := 0;
        END;
        V_NROREGLA_ASIGN := NVL(V_NROREGLA_ASIGN, 0);
      
        FOR xrow_item IN LIST_BLOQUE_955 LOOP
          V_FLGTIENEARBOL := 'N';
          BEGIN
            pq_cr_gestion_bloq_excepc_rpgsincap.sp_valid_tiene_arbol_aprob(pe_AQPB955REG    => xrow_item.aqpb955reg,
                                                                           pe_usuarioIng    => P_N_USUING,
                                                                           ps_flgTieneArbol => V_FLGTIENEARBOL);
          EXCEPTION
            WHEN OTHERS THEN
              V_FLGTIENEARBOL := 'N';
          END;
          V_FLGTIENEARBOL := NVL(V_FLGTIENEARBOL, 'N');
        
          IF V_FLGTIENEARBOL = 'S' THEN
            BEGIN
              SELECT D.AQPC780TPREPR
                INTO V_TIPOREPROG
                FROM AQPC780 D
               WHERE D.AQPC780NUMRGL = V_NROREGLA_ASIGN
                 AND D.AQPC780NOMVAR = xrow_item.aqpb955reg;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
            V_TIPOREPROG := NVL(V_TIPOREPROG, 0);
          
            BEGIN
              insert into aqpc203
                (aqpc203cor,
                 aqpc203vre,
                 aqpc203dre,
                 aqpc203est,
                 aqpc203esx,
                 aqpc203com,
                 aqpc203fex,
                 aqpc203hex,
                 aqpc203uex,
                 aqpc203ac1,
                 aqpc203ac2,
                 aqpc203an1,
                 aqpc203an2,
                 aqpc203ad1,
                 aqpc203ad2,
                 aqpc203fec,
                 aqpc203hor,
                 aqpc203usu)
              values
                (V_CORRE_MAX,
                 xrow_item.aqpb955reg,
                 xrow_item.aqpb955des,
                 'P',
                 'P',
                 '',
                 NULL,
                 '',
                 '',
                 xrow_item.aqpb955ccar,
                 xrow_item.aqpb955perfi,
                 V_TIPOREPROG,
                 0,
                 NULL,
                 NULL,
                 P_N_FECHA,
                 V_HORAREGI,
                 P_N_USUING);
              COMMIT;
              V_FLGOK202 := 'S';
            EXCEPTION
              WHEN OTHERS THEN
                V_FLGOK202 := 'N';
                ROLLBACK;
            END;
          END IF;
        END LOOP;
      END IF;
    END IF;
  END;
  
                                         
  PROCEDURE SP_AUTORIZAR_EXCEPCION(
                                    VE_CORRELATIVO  IN NUMBER,                                     
                                    VE_AUTORIZADOR  IN VARCHAR,
                                    VE_COMENTARIO   IN VARCHAR,
                                    VE_ESTADO       IN VARCHAR,
                                    VE_CORRBLOQ     IN NUMBER,
                                    VE_INSTANCIA    IN NUMBER                                 
                                  )IS
  BEGIN
       --ACTUALIZAR TABLA DE AUTORIZACIONES AQPD159
     /*  BEGIN
            insert into prueba_log(msg) values(VE_CORRELATIVO||'-'||VE_AUTORIZADOR||'-'||VE_COMENTARIO||'-'||VE_ESTADO||'-'||VE_INSTANCIA||'-'||VE_CORRBLOQ);
            COMMIT;
       END; */
       BEGIN
           PQ_CR_BLOQ_REPROG.SP_CR_UPDATE_ESTADO  (
                                                   VE_INSTANCIA,
                                                   VE_CORRBLOQ,                                                   
                                                   SUBSTR(VE_ESTADO,1,1),
                                                   VE_AUTORIZADOR --autorizador predeterminado (PERFIL SINO SERIA USUARIO)                                                   
                                                  );
           COMMIT;
       EXCEPTION
         WHEN OTHERS THEN
           NULL;         
       END;
  END;
  
  PROCEDURE SP_ARMAR_VARIABLE(
                               VE_CORRBLOQ IN NUMBER,
                               VE_INSTANCIA IN NUMBER,
                               VO_VARIABLE OUT VARCHAR                              
                             )IS
  BEGIN
       BEGIN            
          VO_VARIABLE := 'CORRELATIVO|N|' || VE_CORRBLOQ || ';' ||
                         'INSTANCIA|N|' || VE_INSTANCIA || ';';        
       EXCEPTION
          WHEN OTHERS THEN
            NULL;
       END;
  EXCEPTION
    WHEN OTHERS THEN
         NULL;
  END;
  
  PROCEDURE SP_VALIDAR_APROB_BLOQ_203_RC(VE_INSTANCIA NUMBER, VE_VARIABLE VARCHAR2, VO_FLAGEXCEP OUT VARCHAR2) IS
  P_N_COR_1 NUMBER(17);
  V_FECHA_NOW DATE;
  V_USU_SOLICIT VARCHAR2(10);
  BEGIN
    BEGIN
      SELECT PGFAPE INTO V_FECHA_NOW FROM FST017 WHERE PGCOD = 1 ;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;  
  
    BEGIN  
      SELECT NVL(MAX(AQPC202COR),0) INTO P_N_COR_1 FROM AQPC202 WHERE
      AQPC202INS = VE_INSTANCIA
      AND AQPC202FEC = V_FECHA_NOW;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    V_USU_SOLICIT := '';
    BEGIN  
      SELECT AQPC202USU INTO V_USU_SOLICIT  FROM AQPC202 WHERE
      AQPC202INS = VE_INSTANCIA
      AND AQPC202COR = P_N_COR_1
      AND AQPC202FEC = V_FECHA_NOW;
    EXCEPTION
      WHEN OTHERS THEN
        V_USU_SOLICIT := '';
    END;   
    V_USU_SOLICIT := TRIM(V_USU_SOLICIT); 
  
     BEGIN
       Select 'S' INTO VO_FLAGEXCEP
        from AQPC203 a WHERE 
        A.AQPC203COR = P_N_COR_1
        AND A.AQPC203VRE = VE_VARIABLE
        AND A.AQPC203FEC = V_FECHA_NOW
        AND A.AQPC203USU =  RPAD(V_USU_SOLICIT, 10, ' ')
        AND A.AQPC203ESX = 'A'
        AND ROWNUM = 1 ;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;       
     END;
     VO_FLAGEXCEP := NVL(VO_FLAGEXCEP, 'N');
     
  END;
  
end pq_cr_gestion_bloq_excepc_rpgsincap;
/
