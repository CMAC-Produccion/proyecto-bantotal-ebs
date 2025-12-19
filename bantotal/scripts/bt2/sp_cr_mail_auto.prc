create or replace procedure sp_cr_mail_auto(P_N_CODEXC IN NUMBER,
                                            p_c_coderr out varchar2,
                                            p_c_msgerr out varchar2)
-- *****************************************************************
  -- Nombre                     : sp_cr_mail_auto
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 15/01/2022
  -- Autor de Creación          : YRVING LOZADA
  -- Uso                        : ENVIO DE CORREO
  -- Estado                     : ACTIVO
  -- Acceso                     : PUBLICO
  -- Parámetros de Entrada      : P_N_CODEXC
  -- Retorno                    : p_c_coderr, p_c_msgerr
  -- Fecha de Modificacion      : 28/10/2025
  -- Autor de Modificacion      : RCASTRO
  -- Uso                        : Se ajusta envio de correo para 
  --                              bloqueantes con excepcion
  -- Autor de Modificacion      : RCASTRO
  -- Fecha de Modificacion      : 04/11/2025  
  -- Uso                        : Se ajusta envio de correo para 
  --                              bloqueantes con excepcion limites reprog
  -- Autor de Modificacion      : RCASTRO
  -- Fecha de Modificacion      : 20/11/2025  
  -- Uso                        : Se ajusta envio de correo para 
  --                              bloqueantes con excepcion limites reprog 2etapa
  -- *****************************************************************
 is

  cursor c_autorizadores_AQPD159(fechaSOl         date,
                                 pc_AQPD159CORBLO number,
                                 pc_fec400        date,
                                 pc_instancia     number,
                                 pc_tipRep        number,
                                 pc_estado        varchar2,
                                 PC_VARIABLE_RNG  varchar2) is
    SELECT *
      FROM AQPD159 A
     WHERE A.AQPD159FECSOL = fechaSOl
       AND A.AQPD159CORBLO = pc_AQPD159CORBLO
       AND A.AQPD159FECREP = pc_fec400
       AND A.AQPD159INST = pc_instancia
       AND A.AQPD159TIPREP = pc_tipRep
       AND A.AQPD159EST = pc_estado
       AND A.AQPD159VAREGLA = PC_VARIABLE_RNG
       and A.AQPD159REQ = 'S'
     order by a.AQPD159NIAP, a.AQPD159NIDP asc;

  cursor list_Bloqueantes_Pend_Aprob is --rc
    Select distinct a.aqpc203cor,
                    a.aqpc203vre,
                    a.aqpc203ac1,
                    a.aqpc203ac2,
                    A.AQPC203AN1 -- a.aqpc203uex --aqpc203uex
      from AQPC203 a
     where a.aqpc203cor = P_N_CODEXC
       and a.aqpc203est = 'P';

  cursor c_bloqueantesl is
    Select *
      from AQPC203 a
     where a.aqpc203cor = P_N_CODEXC
       and a.aqpc203est = 'P'
     ORDER BY a.aqpc203vre ASC;

  cursor bloqueantesxAutor(fechaSolici    date,
                           instancia      number,
                           cu_autorizador varchar2) is
    SELECT E.*, A.AQPC203DRE
      FROM AQPd159 e, AQPC203 a
     WHERE A.AQPC203COR = E.AQPD159CORBLO
       AND A.AQPC203VRE = E.AQPD159VAREGLA
       AND A.AQPC203EST = 'P'
       and e.aqpd159fecsol = fechaSolici
       AND e.aqpd159corblo = P_N_CODEXC
       AND e.aqpd159inst = instancia
       AND e.aqpd159uapro = rpad(cu_autorizador, 10, ' ')
       AND E.AQPD159EST = 'P';
  /*Select *
   from AQPC203 a, aqpd159 e
  where a.aqpc203cor = e.aqpd159corblo
    and e.aqpd159uapro = rpad(cu_autorizador, 10, ' ')
    and e.aqpd159fecsol = fechaSolici
    and e.aqpd159inst = instancia
    and e.aqpd159corblo = P_N_CODEXC
    and a.aqpc203est = 'P'; */
  /* Select *
   from AQPC203 a
  where a.aqpc203cor = P_N_CODEXC
    and a.aqpc203uex = cu_autorizador
    and a.aqpc203est = 'P';*/

  cursor bloqueantes_203 is ---rc
    Select * from AQPC203 a where a.aqpc203cor = P_N_CODEXC;
  -- and a.aqpc203vre = cu_VaribRegla --rc
  -- and a.aqpc203uex = cu_autorizador
  --  and a.aqpc203est = 'P';

  cursor c_archivos(lv_codblq in varchar2) is
    Select dbms_lob.getlength(a.aqpc204arc) len,
           a.aqpc204arc,
           trim(a.aqpc204nom) aqpc204nom
      from AQPC204 a
     where a.aqpc204co1 = P_N_CODEXC
       and a.aqpc204vre = lv_codblq;

  vblob           BLOB;
  vstart          NUMBER := 1;
  bytelen         NUMBER := 32000;
  len             NUMBER;
  my_vr           RAW(32000);
  x               NUMBER;
  GUIA            VARCHAR2(1);
  lv_nomrep       varchar2(30) := null;
  l_output        utl_file.file_type;
  lv_nomarc       varchar2(250) := null;
  lv_aqpc203vre   aqpc203.aqpc203vre%type;
  lc_Usuario      varchar2(10) := null;
  lc_Analista     varchar2(10) := null;
  ld_usuario      varchar2(50) := null;
  ld_Analista     varchar2(50) := null;
  lc_Cliente      varchar2(250) := null;
  ln_Cuenta       number(9) := 0;
  ln_Operacion    number(9) := 0;
  lc_Producto     varchar2(30) := null;
  ln_SaldoCapital number(17, 2) := 0;
  lc_sucursal     char(30) := null;
  lc_Bloqueante   varchar2(250) := null;
  lc_Comentario   varchar2(250) := null;
  lv_archxblq     varchar2(4000) := null;
  lv_archivos     varchar2(4000) := null;
  ll_mensaje      clob;
  ll_mensaje1     clob;
  lv_mensaje      varchar2(32767);
  lc_coderr       varchar2(400) := null;
  lc_deserr       varchar2(400) := null;
  lv_mailbot      varchar2(50) := null;
  lv_asunto       varchar2(4000) := null;
  lv_asuntoa      varchar2(4000) := null;
  lv_asuntor      varchar2(4000) := null;
  lv_body         varchar2(4000) := null;
  lv_bodya        varchar2(4000) := null;
  lv_bodyr        varchar2(4000) := null;
  lv_body2        varchar2(4000) := null;
  lv_body3        varchar2(4000) := null;
  lv_body4        varchar2(4000) := null;
  lv_bloqueantes  varchar2(4000) := null;
  lv_parar        varchar2(200) := null;
  lv_paraa        varchar2(200) := null;
  lv_remit        varchar2(200) := null;
  lv_body21       varchar2(4000) := null;
  lv_body22       varchar2(4000) := null;

  --08.05.2022 variable

  vi_suc_crd      number(3);
  vi_rcod_crd     number(3);
  vi_autorizador  varchar(10);
  vi_sautorizador varchar(10);

  ----
  v_cargos   VARCHAR2(200); -- := '202,220,310';
  v_perfiles VARCHAR2(200); --:= 'GAGE01,GREG01,GADM01';

  TYPE t_varchar_array IS TABLE OF VARCHAR2(50);
  v_cargos_arr   t_varchar_array := t_varchar_array();
  v_perfiles_arr t_varchar_array := t_varchar_array();

  v_count INTEGER;

  vi_cargo       number(3);
  aux_cargoItem  number(5);
  aux_perfilItem varchar2(10);

  auxListCorreos     VARCHAR2(300);
  auxListAutorizante VARCHAR2(300);
  auxLisCorreosCopia VARCHAR2(300);
  auxCorreoRow       Varchar2(40);

  v_fechaSolici     date;
  V_FECHAJAQA400    DATE;
  V_INSTANCIA202    NUMBER(10);
  V_AQPC202USU      VARCHAR2(10);
  VIO_COD_ERROR     VARCHAR2(5) := '';
  VIO_MSG_ERROR     VARCHAR2(300) := '';
  V_TIPOREPROG      NUMBER(5);
  V_HABI_CARGARCH   NUMBER(4);
  V_FLG_CARGADARCIV VARCHAR2(1);
  ----
  VO_CORRELATIVO   NUMBER(12);
  VIO_CORRELATIVO2 NUMBER(12);
  VIO_VARIABLE     VARCHAR2(50);
  VO_COD_ERROR     VARCHAR2(5);
  VO_MSG_ERROR     VARCHAR2(300);

  V_FLG_TIENE_ARBOL VARCHAR2(1);

  ----
  VI_NIVEL_APROB   AQPD159.AQPD159NIAP%TYPE;
  VI_NIVEL_DEPEND  AQPD159.AQPD159NIDP%TYPE;
  VI_USR_APROB     AQPD159.AQPD159UAPRO%TYPE;
  VI_USR_APROBR    AQPD159.AQPD159UAPRO%TYPE;
  VI_USR_COD_CARGO AQPD159.AQPD159CODCAR%TYPE;
  VI_USR_ESTADO    AQPD159.AQPD159EST%TYPE;

  V_FLAG_CONTINUE VARCHAR2(1);
  v_Autorizador_correo varchar2(30);
begin

  auxListCorreos := '';

  begin
    select a.aqpc202suc, A.AQPC202FEC, A.AQPC202FEA, AQPC202INS, AQPC202USU
      into vi_suc_crd,
           v_fechaSolici,
           V_FECHAJAQA400,
           V_INSTANCIA202,
           V_AQPC202USU
      from aqpc202 a
     where a.aqpc202cor = P_N_CODEXC
       and rownum = 1;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  end;

  ------------- rc
  --validar si en guia esta habilitado cargar archivos, se valide que haya cargado
  BEGIN
    SELECT TPNRO
      INTO V_HABI_CARGARCH
      FROM FST098
     WHERE -- 1= Solicita Archivo - 0= Omite Archivo
     Pgcod = 1
     AND Tpcod = 7753
     AND Tpcorr = 1
     AND ROWNUM = 1;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  V_HABI_CARGARCH := NVL(V_HABI_CARGARCH, 0);

  V_FLG_CARGADARCIV := 'S';
  IF V_HABI_CARGARCH = 1 THEN
    V_FLG_CARGADARCIV := 'N';
    FOR archi_row IN bloqueantes_203 LOOP
      V_FLG_CARGADARCIV := 'N';
      BEGIN
        SELECT 'S'
          INTO V_FLG_CARGADARCIV
          FROM AQPC204
         WHERE AQPC204CO1 = archi_row.Aqpc203cor
           AND AQPC204VRE = archi_row.Aqpc203vre;
      EXCEPTION
        WHEN OTHERS THEN
          V_FLG_CARGADARCIV := 'N';
      END;
      V_FLG_CARGADARCIV := NVL(V_FLG_CARGADARCIV, 'N');
    
      IF V_FLG_CARGADARCIV = 'N' THEN
        p_c_coderr := '001';
        p_c_msgerr := 'Falta cargar archivo para la bloqueante ' ||
                      archi_row.Aqpc203vre;
        EXIT;
      END IF;
    END LOOP;
  END IF;

  IF V_FLG_CARGADARCIV = 'N' AND V_HABI_CARGARCH = 1 THEN
    p_c_coderr := '002';
    p_c_msgerr := 'Se requiere cargar archivo en cada excepción.';
  END IF;

  IF V_FLG_CARGADARCIV = 'S' THEN
    --Validar si ya tiene arbol creado para no crear nuevamente 
    V_FLG_TIENE_ARBOL := 'N';
    BEGIN
      SELECT 'S'
        INTO V_FLG_TIENE_ARBOL
        FROM AQPd159
       WHERE --AQPD159FECSOL = v_fechaSolici
      --AND 
       AQPD159FECREP = v_fechaSolici
       AND AQPD159CORBLO = P_N_CODEXC
       AND AQPD159INST = V_INSTANCIA202
       AND AQPD159UREG = RPAD(V_AQPC202USU, 10, ' ')
       AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        V_FLG_TIENE_ARBOL := 'N';
    END;
  
    IF V_FLG_TIENE_ARBOL = 'S' THEN
      BEGIN
        UPDATE AQPd159 SET AQPD159EST = 'X'
        WHERE AQPD159FECREP = v_fechaSolici AND AQPD159CORBLO = P_N_CODEXC AND AQPD159INST = V_INSTANCIA202  
        AND AQPD159UREG = RPAD(V_AQPC202USU,10, ' ') ;
        --AND AQPD159EST = 'P';
        COMMIT;
        V_FLG_TIENE_ARBOL := 'N';
      EXCEPTION
        WHEN OTHERS THEN
          V_FLG_TIENE_ARBOL := 'N';        
      END;
    END IF;
  
    IF V_FLG_TIENE_ARBOL = 'N' THEN
    
      /*BEGIN  -- 11/11/25
        DELETE FROM AQPd159 WHERE AQPD159FECSOL = v_fechaSolici AND AQPD159FECREG = v_fechaSolici AND  AQPD159CORBLO = P_N_CODEXC AND AQPD159INST = V_INSTANCIA202 AND AQPD159UREG = RPAD(V_AQPC202USU, 10, ' ');
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;*/
    
      FOR rowItemBlqPend IN list_Bloqueantes_Pend_Aprob LOOP
        V_TIPOREPROG := rowItemBlqPend.Aqpc203an1;
        --CARGAR TODO EL ARBOL AQPB159 POR LA REGLA
        BEGIN
          pq_cr_gestion_bloq_excepc_rpgsincap.SP_ARMAR_ARBOL_AQPd159(pe_fecSolic        => v_fechaSolici,
                                                                     pe_fecReprogA400   => V_FECHAJAQA400,
                                                                     pe_instancia       => V_INSTANCIA202,
                                                                     pe_VariableRNG     => rowItemBlqPend.Aqpc203vre,
                                                                     pe_aqpc203Corr     => rowItemBlqPend.Aqpc203cor,
                                                                     pe_aqpc203AC1      => rowItemBlqPend.Aqpc203ac1,
                                                                     pe_aqpc203AC2      => rowItemBlqPend.Aqpc203ac2,
                                                                     pe_aqpc202sucur    => vi_suc_crd,
                                                                     pe_tiporeprog      => V_TIPOREPROG,
                                                                     pe_UsuarioRegistro => V_AQPC202USU,
                                                                     ps_CodError        => VIO_COD_ERROR,
                                                                     ps_MsgError        => VIO_MSG_ERROR);
        EXCEPTION
          WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('error al invocar pq_cr_gestion_bloq_excepc_rpgsincap.SP_ARMAR_ARBOL_AQPd159');
        END;
      
      END LOOP;
      ----------------r
    
    END IF;
  
    lc_usuario := '';
    --Validar que exista registro  
    begin
      Select a.aqpc202usa,
             a.AQPC202USU,
             a.AQPC202CLI,
             a.AQPC202CTA,
             a.AQPC202OPE,
             a.AQPC202PRO,
             a.AQPC202SAL,
             'S'
        into lc_Usuario,
             lc_Analista,
             lc_Cliente,
             ln_Cuenta,
             ln_Operacion,
             lc_Producto,
             ln_SaldoCapital,
             GUIA
        from AQPC202 a
       where a.aqpc202cor = P_N_CODEXC
         AND A.AQPC202EST = 'P';
    exception
      when others then
        GUIA := 'N';
    end;
  
    IF GUIA = 'S' THEN
      auxListCorreos     := null;
      auxLisCorreosCopia := NULL;
    
      ------ arma correo en copia a USUARIO QUE GESTIONA los envios
      auxCorreoRow := '';
      BEGIN
        SELECT WFUSREMAIL
          INTO auxCorreoRow
          FROM WFUSERS
         WHERE WFUSRCOD = RPAD(lc_Analista, 30, ' ');
      EXCEPTION
        WHEN OTHERS then
          auxCorreoRow := null;
        
      END;
    
      auxLisCorreosCopia := auxCorreoRow;
    
      FOR au in C_BLOQUEANTESL loop
      
        FOR rowAutorizaD159 in c_autorizadores_AQPD159(v_fechaSolici, P_N_CODEXC, V_FECHAJAQA400, V_INSTANCIA202, AU.AQPC203AN1, AU.AQPC203EST, AU.AQPC203VRE) loop
          -----validar si tiene pendiente aprobacion         
          V_FLAG_CONTINUE := 'S';
          IF rowAutorizaD159.Aqpd159niap > 0 THEN
            IF rowAutorizaD159.Aqpd159nidp > 0 THEN
              --OBTENER LOS DATOS DE LOS ANTERIORES AUTORIZADORES.
            
              BEGIN
                SELECT A.AQPD159UAPRO, A.AQPD159CODCAR, A.AQPD159EST
                  INTO VI_USR_APROB, VI_USR_COD_CARGO, VI_USR_ESTADO
                  FROM AQPD159 A
                 WHERE A.AQPD159FECREG = v_fechaSolici
                   AND A.AQPD159CORBLO = P_N_CODEXC
                   AND A.AQPD159INST = V_INSTANCIA202
                   AND A.AQPD159NIAP = rowAutorizaD159.Aqpd159nidp
                   AND A.AQPD159EST IN ('A', 'P', 'R')
                   AND ROWNUM = 1;
              EXCEPTION
                WHEN OTHERS THEN
                  BEGIN
                    SELECT B.AQPD159UAPRO, B.AQPD159CODCAR, B.AQPD159EST
                      INTO VI_USR_APROB, VI_USR_COD_CARGO, VI_USR_ESTADO
                      FROM AQPD159 B
                     WHERE B.AQPD159FECREG = v_fechaSolici
                       AND B.AQPD159CORBLO = P_N_CODEXC
                       AND B.AQPD159INST = V_INSTANCIA202
                       AND B.AQPD159NIAP < rowAutorizaD159.Aqpd159nidp
                       AND B.AQPD159EST IN ('A', 'P', 'R')
                       AND ROWNUM = 1;
                  EXCEPTION
                    WHEN OTHERS THEN
                      null;
                  END;
              END;
              IF ((TRIM(VI_USR_APROB)) IS NOT NULL OR VI_USR_COD_CARGO > 0) AND
                 trim(VI_USR_ESTADO) <> 'A' THEN
                V_FLAG_CONTINUE := 'N';
              END IF;
            
            End if;
          end if;
        
          IF V_FLAG_CONTINUE = 'S' THEN
            auxListCorreos := '';
            IF TRIM(rowAutorizaD159.Aqpd159est) not in ('A', 'R') THEN
            
              ------------  armar correos destinatarios
              vi_sautorizador := rowAutorizaD159.Aqpd159uapro;
            
              auxCorreoRow := '';
            
              BEGIN
                SELECT WFUSREMAIL
                  INTO auxCorreoRow
                  FROM WFUSERS
                 WHERE WFUSRCOD = RPAD(vi_sautorizador, 30, ' ');
              EXCEPTION
                WHEN OTHERS then
                  auxCorreoRow := null;
                
              END;
            
              if auxListCorreos is null then
                auxListCorreos     := auxCorreoRow;
                auxListAutorizante := vi_sautorizador;
              else
                auxListCorreos     := auxListCorreos || ';' ||
                                      trim(auxCorreoRow);
                auxListAutorizante := auxListAutorizante || ';' ||
                                      vi_sautorizador;
              end if;
            
              --  END IF;
              -- End Loop;
              --------------------
            
              --OBTENEMOS SUCURSAL DEL ANALISTA
              begin
                Select upper(b.scnom)
                  into lc_sucursal
                  from fst046 a, fst001 b
                 where a.pgcod = b.pgcod
                   and a.ubsuc = b.sucurs
                   and a.pgcod = 1
                   and a.ubuser = rpad(lc_Analista, 10, ' ');
              exception
                when others then
                  p_c_coderr := '002';
                  p_c_msgerr := 'No Se encontro Sucursal';
                  return;
              end;
            
              lv_mailbot := 'autorizacionesBT';
              lv_parar   := auxListCorreos; --lower(trim(lc_usuario)) || '@cajaarequipa.pe'; --06.05.2022 - descomentar solo para pruebas
              lv_paraa   := auxListCorreos; --;lower(trim(lc_analista))||'@cajaarequipa.pe'; --06.05.2022 - descomentar solo para pruebas 
              --lv_parar := 'hsuarez@cajaarequipa.pe';
              --lv_paraa := 'carlos.lagones@sesitdigital.com';
            
              lv_remit  := 'notificacionesbantotal@cajaarequipa.pe';
              lv_asunto := '[C07] AUTORIZACIÓN DE EXCEPCIONES REPROGRAMACIÓN SIN CAPITALIZACIÓN CUENTA:' ||
                           ln_cuenta || ' OPERACIÓN:' || ln_Operacion;
            
              dbms_lob.createtemporary(ll_mensaje, TRUE);
              dbms_lob.createtemporary(ll_mensaje1, TRUE);
            
              BEGIN
                select t.ubnom
                  into ld_usuario
                  from FST746 t
                 WHERE UBUSER = RPAD(lc_usuario, 10, ' ');
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
            
              BEGIN
                select t.ubnom
                  into ld_analista
                  from FST746 t
                 WHERE UBUSER = RPAD(lc_analista, 10, ' ');
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
              
              v_Autorizador_correo := '';
                BEGIN
                select t.ubnom
                  into v_Autorizador_correo
                  from FST746 t
                 WHERE UBUSER = RPAD(vi_sautorizador, 10, ' ');
              EXCEPTION
                WHEN OTHERS THEN
                  v_Autorizador_correo := '';
              END;
              
            
              --               
              lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a): ' ||
                            v_Autorizador_correo || '</p>' ||
                            '<p "font-family: Arial, sans-serif; font-size: 14px;">Tiene las siguientes excepciones por autorizar que corresponden a las reprogramaciones sin capitalización del Cliente ' ||
                            lc_Cliente || ', con cuenta y operación  ' ||
                            ln_cuenta || '- ' || ln_Operacion || ':</p>' ||
                            '<p "font-family: Arial, sans-serif; font-size: 14px;">Producto: ' ||
                            lc_Producto || '</p>' ||
                            '<p "font-family: Arial, sans-serif; font-size: 14px;">Saldo Capital: ' ||
                            trim(to_char(ln_SaldoCapital, '99,999,999.99')) ||
                            '</p>';
              lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
              dbms_lob.writeappend(ll_mensaje,
                                   length(lv_mensaje),
                                   lv_mensaje);
            
              lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimados, ' ||
                           --ld_analista || 
                            '</p>' ||
                            '<p "font-family: Arial, sans-serif; font-size: 14px;">Tiene las siguientes excepciones pendientes de ser autorizadas, que corresponden a las reprogramaciones sin capitalización del Cliente ' ||
                            lc_Cliente || ', con cuenta y operación  ' ||
                            ln_cuenta || '- ' || ln_Operacion || ':</p>' ||
                            '<p "font-family: Arial, sans-serif; font-size: 14px;">Producto: ' ||
                            lc_Producto || '</p>' ||
                            '<p "font-family: Arial, sans-serif; font-size: 14px;">Saldo Capital: ' ||
                            trim(to_char(ln_SaldoCapital, '99,999,999.99')) ||
                            '</p>'; -- ||
              -- '<p "font-family: Arial, sans-serif; font-size: 14px;"> Lista correos: ' ||
              --  auxListCorreos || '</p>'; --rc
              lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
              dbms_lob.writeappend(ll_mensaje1,
                                   length(lv_mensaje),
                                   lv_mensaje);
            
              lv_mensaje := '<style  type="text/css">td {font-family: Arial, sans-serif; font-size: 14px;}</style>' ||
                            '<table cellspacing=0 cellpadding=3 width=900 border="1">';
              lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
              dbms_lob.writeappend(ll_mensaje,
                                   length(lv_mensaje),
                                   lv_mensaje);
              dbms_lob.writeappend(ll_mensaje1,
                                   length(lv_mensaje),
                                   lv_mensaje);
            
              lv_mensaje := '  <tr>' ||
                            '    <td width="300" style="border-bottom: 1px solid black;"><b>Bloqueante</b></td>' ||
                            '    <td width="300" style="border-bottom: 1px solid black;"><b>Comentario</b></td>' ||
                            '    <td width="300" style="border-bottom: 1px solid black;"><b>Archivo Adjunto</b></td>' ||
                            '  </tr>          ';
              lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
              dbms_lob.writeappend(ll_mensaje,
                                   length(lv_mensaje),
                                   lv_mensaje);
              dbms_lob.writeappend(ll_mensaje1,
                                   length(lv_mensaje),
                                   lv_mensaje);
            
              lv_nomrep := 'DTPUMP_PR_EMAIL';
              vstart    := 1;
              bytelen   := 32000;
              --armamos el detalle de los bloqueantes
              --Limpiams variable 08.05.2022
            
              lv_bloqueantes := '';
              lv_archivos    := '';
              lv_archxblq    := '';
            
              For i in bloqueantesxAutor(v_fechaSolici, V_INSTANCIA202, vi_sautorizador) loop
                lc_Bloqueante  := TRIM(AU.aqpc203dre); --TRIM(i.aqpc203dre);
                lv_bloqueantes := lv_bloqueantes || lc_Bloqueante || ',';
                lc_Comentario  := AU.aqpc203com;
                lv_aqpc203vre  := au.aqpc203vre;
              
                for j in c_archivos(lv_aqpc203vre) loop
                  len       := j.len;
                  vblob     := j.aqpc204arc;
                  lv_nomarc := trim(j.aqpc204nom);
                  --
                  --extraemos el arvhivo de la tabla y lo descargamos en el repositorio extractos    
                  --  
                  -- define output directory
                  l_output := utl_file.fopen(lv_nomrep,
                                             lv_nomarc,
                                             'wb',
                                             32760);
                
                  -- save blob length
                  x := len;
                
                  -- if small enough for a single write
                  If len < 32760 then
                    utl_file.put_raw(l_output, vblob);
                    utl_file.fflush(l_output);
                  Else
                    -- write in pieces
                    vstart  := 1;
                    bytelen := 32000;
                    While vstart < len and bytelen > 0 Loop
                      dbms_lob.read(vblob, bytelen, vstart, my_vr);
                    
                      utl_file.put_raw(l_output, my_vr);
                      utl_file.fflush(l_output);
                    
                      -- set the start position for the next cut
                      vstart := vstart + bytelen;
                    
                      -- set the end position if less than 32000 bytes
                      x := x - bytelen;
                      If x < 32000 Then
                        bytelen := x;
                      End If;
                    End Loop;
                    utl_file.fclose(l_output);
                  End If;
                  --fin descarga
                  lv_archxblq := lv_archxblq || lv_nomarc || ';';
                End loop;
                lv_archxblq := substr(lv_archxblq,
                                      1,
                                      length(lv_archxblq) - 1);
              
                lv_mensaje := '  <tr>' ||
                              '    <td width="300" style="border-bottom: 1px solid black;">' ||
                              trim(lc_Bloqueante) || '</td>' ||
                              '    <td width="300" style="border-bottom: 1px solid black;">' ||
                              trim(lc_Comentario) || '</td>' ||
                              '    <td width="300" style="border-bottom: 1px solid black;">' ||
                              trim(lv_archxblq) || '</td>' ||
                              '  </tr>          ';
                lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
                dbms_lob.writeappend(ll_mensaje,
                                     length(lv_mensaje),
                                     lv_mensaje);
                dbms_lob.writeappend(ll_mensaje1,
                                     length(lv_mensaje),
                                     lv_mensaje);
              
                if lv_archxblq is not null then
                  lv_archivos := lv_archivos || lv_archxblq || ';';
                End if;
                lv_archxblq := '';
              End Loop;
              lv_archivos    := substr(lv_archivos,
                                       1,
                                       length(lv_archivos) - 1);
              lv_bloqueantes := substr(lv_bloqueantes,
                                       1,
                                       length(lv_bloqueantes) - 1);
            
              lv_mensaje := '</table>' || '<br/>';
              lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
              dbms_lob.writeappend(ll_mensaje,
                                   length(lv_mensaje),
                                   lv_mensaje);
              dbms_lob.writeappend(ll_mensaje1,
                                   length(lv_mensaje),
                                   lv_mensaje);
            
              /**********************
                 DESARROLLO - LOG DE AUTORIZACION DE REPROG
                 
              ***********************/
              --PROCESO PARA AGREGARLO EN EL LOG DE AUTORIZACIONES AQPC565. (PARA ESTA OPORTUNIDAD NO SERA POR MEDIO DEL PROCESO AUTOMATIZADO PENDIENTE ARREGLO) @HASL
              PQ_CR_AUT_BLOQ_GENERAL.SP_INSERT_AQPC565(P_N_CODEXC, --VE_CORR_AUT_REPRO,
                                                       V_INSTANCIA202,
                                                       lc_analista,
                                                       7, --el codigo 7 es asingado desde la aqpc566 para aut de bloq.,
                                                       lv_asunto,
                                                       '-', --asunto bot
                                                       substr(ll_mensaje,
                                                              1,
                                                              3000),
                                                       lv_paraa,
                                                       auxLisCorreosCopia,
                                                       VO_CORRELATIVO,
                                                       VO_COD_ERROR,
                                                       VO_MSG_ERROR);
              --PROCESO PARA AGREGAR LAS VARIABLES ADICIONAL PARA LA AQPC565
              BEGIN
                pq_cr_gestion_bloq_excepc_rpgsincap.SP_ARMAR_VARIABLE(P_N_CODEXC,
                                                                      V_INSTANCIA202,
                                                                      VIO_VARIABLE);
                --
                UPDATE AQPC565
                   SET AQPC565VAR = VIO_VARIABLE
                 WHERE AQPC565CORr = VO_CORRELATIVO;
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
              --OBTENER IDPROCESO INTERNO AQPC565
              BEGIN
                SELECT AA.AQPC565CORR2
                  INTO VIO_CORRELATIVO2
                  FROM AQPC565 AA
                 WHERE AA.AQPC565CORR = VO_CORRELATIVO;
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
              lv_mensaje := '<table cellspacing=0 cellpadding=3 width=900>';
              dbms_lob.writeappend(ll_mensaje,
                                   length(lv_mensaje),
                                   lv_mensaje);
              dbms_lob.writeappend(ll_mensaje1,
                                   length(lv_mensaje),
                                   lv_mensaje);
            
              --
              -- ARMAMOS CURPO Y ASUNTO DE MAIL DE APROBACION O RECHAZO
              --
              -- 06.05.2022 - SE REALIZO EL CAMBIO DONDE DICE AUTORIZACION/RECHAZO POR ALGO MAS DINAMICO.
            
              lv_body21 := 'Se realizó la autorización de las bloqueantes solicitadas que corresponden a las reprogramaciones sin capitalización del Cliente ' ||
                           lc_cliente || ', con cuenta y operación: ' ||
                           ln_cuenta || ' - ' || ln_operacion;
              lv_body21 := replace(lv_body21, ' ', '%20');
            
              lv_body22 := 'Se realizó el rechazo de las bloqueantes solicitadas que corresponden a las reprogramaciones sin capitalización del Cliente ' ||
                           lc_cliente || ', con cuenta y operación: ' ||
                           ln_cuenta || ' - ' || ln_operacion;
              lv_body22 := replace(lv_body22, ' ', '%20');
            
              lv_body3 := '- IDCODIGO: ' || VO_CORRELATIVO || '%0D%0A' ||
                          '- IDCODPROCESO: 7' || '%0D%0A' ||
                          '- IDCODPROCESO_INTERNO: ' || VIO_CORRELATIVO2 ||
                          '%0D%0A' || '- AUTORIZADOR: ' || vi_sautorizador ||
                          '%0D%0A' || '- MAUTORIZADOR: ' || lv_paraa ||
                          '%0D%0A' || '- SOLICITANTE: ' || lc_analista ||
                          '%0D%0A' || '- ESTADO: Autorizado';
              lv_body3 := replace(lv_body3, ' ', '%20');
              lv_body4 := '- IDCODIGO: ' || VO_CORRELATIVO || '%0D%0A' ||
                          '- IDCODPROCESO: 7 ' || '%0D%0A' ||
                          '- IDCODPROCESO_INTERNO: ' || VIO_CORRELATIVO2 ||
                          '%0D%0A' || '- AUTORIZADOR: ' || vi_sautorizador ||
                          '%0D%0A' || '- MAUTORIZADOR: ' || lv_paraa ||
                          '%0D%0A' || '- ANALISTA: ' || lc_analista ||
                          '%0D%0A' || '- ESTADO: Rechazado';
              lv_body4 := replace(lv_body4, ' ', '%20');
            
              lv_asuntoa := '[C07] - ' || VO_CORRELATIVO ||
                            '- Se Autoriza la Solicitud de Excepción de las Reglas de Reprogramados para ';
              lv_asuntoa := replace(lv_asuntoa, ' ', '%20') || ln_cuenta || '-' ||
                            ln_operacion;
              lv_asuntor := '[C07] - ' || VO_CORRELATIVO ||
                            '- Se Rechaza la Solicitud de Excepción de las Reglas de Reprogramados para ';
              lv_asuntor := replace(lv_asuntor, ' ', '%20') || ln_cuenta || '-' ||
                            ln_operacion;
              lv_asuntoa := pq_ah_email_trx.fn_ah_replace_tildes(lv_asuntoa);
              lv_asuntor := pq_ah_email_trx.fn_ah_replace_tildes(lv_asuntor);
            
              lv_body  := 'Comentarios del Autorizador: ';
              lv_bodya := replace(trim(lv_body), ' ', '%20') /*||replace(trim(lc_Comentario),' ','%20')*/
                          || '%0D%0A%0D%0A' || lv_body21 || '%0D%0A%0D%0A' ||
                          lv_body3;
              lv_bodyr := replace(trim(lv_body), ' ', '%20') /*||replace(trim(lc_Comentario),' ','%20')*/
                          || '%0D%0A%0D%0A' || lv_body22 || '%0D%0A%0D%0A' ||
                          lv_body4;
              lv_bodya := pq_ah_email_trx.fn_ah_replace_tildes(lv_bodya);
              lv_bodyr := pq_ah_email_trx.fn_ah_replace_tildes(lv_bodyr);
            
              --FIN ARMADO
              --06.05.2022 - SE CAMBIO EL CC POR QUE SE ESTA ENVIADO AL MISMO AUTORIZADOR, DEBIENDO SER ANALISTA O ASESOR.  
              lv_mensaje := '  <tr>' ||
                            '    <td width="300"><b><a href="mailto:' ||
                            lv_mailbot || '@cajaarequipa.pe?cc=' ||
                            lower(lc_analista) ||
                            '@cajaarequipa.pe&Subject=' || lv_asuntoa ||
                            '&body=' || lv_bodya ||
                            '">AUTORIZAR</a></b></td>' ||
                           --'    <td width="300"><b><a href="mailto:'||lv_mailbot||'@cajaarequipa.pe?cc=carlos.lagones@sesitdigital.com;hsuarez@cajaarequipa.pe&Subject='||lv_asuntoa||'&body='||lv_bodya||'">AUTORIZAR</a></b></td>'||
                            '    <td width="300"><b><a href="mailto:' ||
                            lv_mailbot || '@cajaarequipa.pe?cc=' ||
                            lower(lc_analista) ||
                            '@cajaarequipa.pe&Subject=' || lv_asuntor ||
                            '&body=' || lv_bodyr ||
                            '">RECHAZAR</a></b></td>' ||
                           --'    <td width="300"><b><a href="mailto:'||lv_mailbot||'@cajaarequipa.pe?cc=carlos.lagones@sesitdigital.com;hsuarez@cajaarequipa.pe&Subject='||lv_asuntor||'&body='||lv_bodyr||'">RECHAZAR</a></b></td>'||          
                            '  </tr> ';
              dbms_lob.writeappend(ll_mensaje,
                                   length(lv_mensaje),
                                   lv_mensaje);
            
              lv_mensaje := '</table>' || '<br/>';
              dbms_lob.writeappend(ll_mensaje,
                                   length(lv_mensaje),
                                   lv_mensaje);
              dbms_lob.writeappend(ll_mensaje1,
                                   length(lv_mensaje),
                                   lv_mensaje);
            
              lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';
              dbms_lob.writeappend(ll_mensaje,
                                   length(lv_mensaje),
                                   lv_mensaje);
              dbms_lob.writeappend(ll_mensaje1,
                                   length(lv_mensaje),
                                   lv_mensaje);
            
              --envio correo usuario aprobador
            
              /* begin           
                -- Call the procedure
                pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_parar,
                                                 p_destinatarioscc   => auxLisCorreosCopia,
                                                 p_destinatariosbcc  => '',
                                                 p_mensaje           => ll_mensaje1,
                                                 p_remitente         => lv_remit,
                                                 p_asunto            => lv_asunto,
                                                 p_tipomensaje       => 'HTML',
                                                 p_directorio        => lv_nomrep,
                                                 p_archivosadjuntos  => lv_archivos,
                                                 p_c_coderr          => lc_coderr,
                                                 p_c_deserr          => lc_deserr
                                                 );
              
              end;  */
            
              --Envio correo a analista sin links de aprobaciones
              begin
                -- Call the procedure
                pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_paraa,
                                                 p_destinatarioscc   => auxLisCorreosCopia,
                                                 p_destinatariosbcc  => '', --'HSUAREZ@CAJAAREQUIPA.PE', --PRUEBA ,--'romario.castro@igs.com.pe'--
                                                 p_mensaje           => ll_mensaje,
                                                 p_remitente         => lv_remit,
                                                 p_asunto            => lv_asunto,
                                                 p_tipomensaje       => 'HTML',
                                                 p_directorio        => lv_nomrep,
                                                 p_archivosadjuntos  => lv_archivos,
                                                 p_c_coderr          => lc_coderr,
                                                 p_c_deserr          => lc_deserr);
              
              end;
            
              dbms_lob.freetemporary(ll_mensaje);
              dbms_lob.freetemporary(ll_mensaje1);
            
              p_c_coderr := lc_coderr;
              if p_c_coderr = '000' then
                p_c_msgerr := 'Envío Satisfactorio, revise su bandeja de correo electrónico.';
              Else
                p_c_msgerr := lc_deserr;
              End if;
            
            End If;
          END IF;
        End Loop;
      
        --actualizamos la tabla
        IF p_c_coderr = '000' then
          --RC SE ACTUALIZA ESTADOS 1 FASE
          begin
            update AQPC202 a
               set a.aqpc202est = decode(p_c_coderr, '000', 'S', 'N'),
                   A.AQPC202MSG = substr(p_c_msgerr, 1, 100)
             where a.aqpc202cor = P_N_CODEXC;
            if sql%notfound then
              p_c_coderr := '004';
              p_c_msgerr := 'Ocurrio un error al procesar la información, vuelva a intentar.';
              return;
            Else
              commit;
            End If;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          End;
        
          --RC
          /* BEGIN
            UPDATE AQPC203 B
               SET AQPC203ESX = 'A', AQPC203FEX = v_fechaSolici
             WHERE B.AQPC203COR = P_N_CODEXC;
             COMMIT;
           -- AND B.AQPC203VRE = trim(AU.AQPC203VRE); ---RCX
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;*/
        
        END IF;
        --  Exception
      --   when others then
      --   p_c_coderr := sqlcode;
      --    p_c_msgerr := sqlerrm;
      --end;
      end loop; --FIN DEL CICLO 08.05.2022  
    ELSE
      p_c_coderr := '001';
      p_c_msgerr := 'No existe(n) registro(s) para autorizar.';
    END IF;
  END IF;
end sp_cr_mail_auto;
/
