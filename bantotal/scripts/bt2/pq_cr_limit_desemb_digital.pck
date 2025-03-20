create or replace package pq_cr_limit_desemb_digital is

  /* ************************************************************************************************************
     -- Nombre                     : pq_cr_limit_desemb_digital
     -- Sistema                    : BANTOTAL
     -- Módulo                     : ACTIVAS
     -- Descripción                : Nuevos parámetros y límites Desembolso Digital
     -- Versión                    : 1.0
     -- Fecha de Creación          : 13/09/2023
     -- Autor de Creación          : IGS_RCASTRO
     -- Estado                     : Activo
     -- Acceso                     : Público
     -- Fecha de Modificación      : 06/02/2024
     -- Autor de la Modificación   : IGS_RCASTRO
     -- Descripción de Modificación: Validación de score máximo y validacion de plazo máx. para Aplicar Desembolso Digital
     -- Fecha de Modificación      : 01/3/2024
     -- Autor de la Modificación   : IGS_RCASTRO
     -- Descripción de Modificación: Ajuste en garantia y score
     -- Fecha de Modificación      : 27/8/2024
     -- Autor de la Modificación   : IGS_RCASTRO
     -- Descripción de Modificación: Ajuste en garantia reales y el mismo cambio aplicado en PQ_CR_CORREOS_DESEMBOLSO_DIGITAL
     -- Fecha de Modificación      : 28/8/2024
     -- Autor de la Modificación   : IGS_RCASTRO
     -- Descripción de Modificación: Ajuste en score minimo
     -- Fecha de Modificación      : 18/12/2024
     -- Autor de la Modificación   : IGS_RCASTRO
     -- Descripción de Modificación: Se agregan nuevos controles masificacion aval, fondos gob. y compra deuda
     -- Fecha de Modificación      : 04/2/2025
     -- Autor de la Modificación   : IGS_RCASTRO
     -- Descripción de Modificación: Se agregan ajusta validacion de aval
  * *************************************************************************************************************/

  procedure sp_valid_limites_desemb_digital(instancia   number,
                                            monto       number,
                                            cuotas      number,
                                            usuarioEjec varchar2,
                                            codRpta     OUT varchar2,
                                            msgRepta    OUT varchar2);

  procedure sp_valid_garantias_reales(instancia number,
                                      codRpta   out varchar2,
                                      msgRpta   out varchar2);
  procedure sp_validar_modulos_habilit(instancia number,
                                       codRpta   out varchar2,
                                       msgRpta   out varchar2);
  procedure sp_validar_segmt_MYPE(instancia   number,
                                  usuarioEjec varchar2,
                                  codRpta     out varchar2,
                                  msgRpta     out varchar2);
  procedure sp_validar_segmt_Inclusivos(instancia   number,
                                        usuarioEjec varchar2,
                                        codRpta     out varchar2,
                                        msgRpta     out varchar2);
  procedure sp_validar_orig_fondos_estado(instancia number,
                                          codRpta   out varchar2,
                                          msgRpta   out varchar2);
  procedure sp_validar_plz_meses(instancia number,
                                 codRpta   out varchar2,
                                 msgRpta   out varchar2);
  procedure sp_validar_score(instancia  number,
                             usuarioEje varchar2,
                             codRpta    out varchar2,
                             msgRpta    out varchar2);

  PROCEDURE sp_valid_aval(pn_instancia number,
                          codRpta   out varchar2,
                          msgRpta   out varchar2) ;

  procedure sp_validar_fondos_gobierno(instancia in number,
                                       codRpta   out varchar2,
                                       msgRpta   out varchar2);

  procedure sp_validar_compraDeuda(instancia number,
                                   codRpta   out varchar2,
                                   msgRpta   out varchar2);

  procedure sp_obtener_Credito(instancia in number,
                               v_Pgcod   out number,
                               v_Scmod   out number,
                               v_Scsuc   out number,
                               v_Scmda   out number,
                               v_Scpap   out number,
                               v_Sccta   out number,
                               v_Scoper  out number,
                               v_Scsbop  out number,
                               v_Sctope  out number);
  procedure sp_buscar_descp_msg(codigo varchar2, mensaje out varchar2);
  PROCEDURE SP_VALIDAR_EXCEPCIONES_CONTROL(instancia number, NroControl number, flgExcepc out varchar2);

end pq_cr_limit_desemb_digital;
/

create or replace package body pq_cr_limit_desemb_digital is

  procedure sp_valid_limites_desemb_digital(instancia   number,
                                            monto       number,
                                            cuotas      number,
                                            usuarioEjec varchar2,
                                            codRpta     OUT varchar2,
                                            msgRepta    OUT varchar2) IS
    ModelEval NUMBER(4);
  BEGIN
    codRpta  := '0000';
    msgRepta := '';
    BEGIN
    --Garantias reales asociadas
    pq_cr_limit_desemb_digital.sp_valid_garantias_reales(instancia,
                                                         codRpta,
                                                         msgRepta);
    IF codRpta = '0000' OR codRpta IS NULL THEN
      --validar modulo permitido
      pq_cr_limit_desemb_digital.sp_validar_modulos_habilit(instancia,
                                                            codRpta,
                                                            msgRepta);
      IF codRpta = '0000' OR codRpta IS NULL THEN
          pq_cr_limit_desemb_digital.sp_validar_score(instancia,
                                                      usuarioEjec,
                                                      codRpta,
                                                      msgRepta);

          IF codRpta = '0000' OR codRpta IS NULL THEN   --12/12/2024
              pq_cr_limit_desemb_digital.sp_valid_aval(instancia,
                                                       codRpta,
                                                       msgRepta);


              IF codRpta = '0000' OR codRpta IS NULL THEN --12/12/2024
                 pq_cr_limit_desemb_digital.sp_validar_compraDeuda(instancia,
                                                                   codRpta,
                                                                   msgRepta);
                 IF codRpta = '0000' OR codRpta IS NULL THEN --12/12/2024
                    pq_cr_limit_desemb_digital.sp_validar_fondos_gobierno(instancia,
                                                                          codRpta,
                                                                          msgRepta);
                 END IF;
              END IF;
          END IF;
       END IF;
     END IF;
     END;
  END;

  procedure sp_valid_garantias_reales(instancia number,
                                      codRpta   out varchar2,
                                      msgRpta   out varchar2) IS
    cont    number(2);
    mensaje VARCHAR2(200);
    v_flgExcpSolicitud varchar2(1);
    v_Modulo number(3);
    v_tope  number(3);
    v_flgHblCtr varchar2(1);
    nroControl number(3);
  BEGIN
    codRpta := '0000';
    msgRpta := '';
    ---01/03/2024 EXCEPTUAR por instancia o mod y transaccion de garantia
    BEGIN
      SELECT XWFMODULO, XWFTIPOPE INTO v_Modulo, v_tope
      FROM XWF700 W WHERE W.XWFPRCINS = instancia AND W.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        v_Modulo := 0;
        v_tope   := 0;
    END;

    v_flgExcpSolicitud := 'N';
    nroControl := 1;
    BEGIN
       pq_cr_limit_desemb_digital.SP_VALIDAR_EXCEPCIONES_CONTROL(instancia, nroControl, v_flgExcpSolicitud);
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END;
    v_flgExcpSolicitud := NVL(v_flgExcpSolicitud, 'N');

    IF v_flgExcpSolicitud = 'N' THEN

     BEGIN
        SELECT 'S' INTO v_flgHblCtr FROM FST198 M  WHERE
           M.Tp1cod = 1
           AND M.Tp1cod1 = 11152
           AND M.Tp1corr1 = 80 --for update
           AND M.Tp1corr2 = 3
           AND M.TP1NRO3 = 1;
     EXCEPTION
       WHEN OTHERS THEN
         v_flgHblCtr := 'N';
     END;

     v_flgHblCtr := NVL(v_flgHblCtr, 'N');

      IF v_Modulo = 106 AND v_tope = 91 AND v_flgHblCtr = 'S' THEN
          --VALIDAR que solo tenga garantias por guia
          BEGIN
            SELECT COUNT(1)
              INTO cont
              FROM SNG122 G WHERE
               G.SNG122INST = instancia
               --AND SNG122MOD = 70 AND G.SNG122TOPE <> 90;
               AND (SNG122MOD, SNG122TOPE) NOT IN
                (SELECT M.TP1NRO2,M.TP1NRO3 -- habilit tope 80 RCASTRO 27/08/2024
                 FROM FST198 M  WHERE
                           M.Tp1cod = 1
                           AND M.Tp1cod1 = 11152
                           AND M.Tp1corr1 = 80
                           AND M.Tp1corr2 = 4
                           AND M.TP1CORR3 > 0
               );
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
       ELSE
          BEGIN
            SELECT COUNT(1)
              INTO cont
              FROM SNG122 G, FST198 K
             WHERE K.Tp1cod = 1
               AND K.Tp1cod1 = 10897
               AND K.Tp1corr1 = 500
               AND K.Tp1corr2 = 1
               AND K.TP1NRO1 = G.SNG122MOD
               AND K.TP1NRO2 = G.SNG122TOPE
               AND G.SNG122INST = instancia
               AND NOT EXISTS( --exceptuar por mod y tope garantia
               SELECT * FROM FST198 M  WHERE
                 M.Tp1cod = 1
                 AND M.Tp1cod1 = 11152
                 AND M.Tp1corr1 = 80
                 AND M.Tp1corr2 = 2
                 AND M.TP1CORR3 > 0
                 AND M.TP1NRO2 = G.SNG122MOD
                 AND M.TP1NRO3 = G.SNG122TOPE
               );
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
       END IF;

        cont := nvl(cont, 0);
        IF CONT > 0 THEN
          codRpta := '1000';
          BEGIN
            mensaje := 'No se puede procesar las solicitudes con garantía real.';
          EXCEPTION
            WHEN OTHERS THEN
              mensaje := '';
          END;
          IF mensaje is not null THEN
            msgRpta := mensaje;
          END IF;
        ELSE
          codRpta := '0000';
        END IF;
    ELSE
       codRpta := '0000';
    END IF;
  END;

  procedure sp_validar_modulos_habilit(instancia number,
                                       codRpta   out varchar2,
                                       msgRpta   out varchar2) IS
    xrow    number(3);
    mensaje varchar2(200);

    v_Pgcod  number(3);
    v_Scmod  number(4);
    v_Scsuc  number(4);
    v_Scmda  number(4);
    v_Scpap  number(4);
    v_Sccta  number(9);
    v_Scoper number(9);
    v_Scsbop number(3);
    v_Sctope number(3);
  BEGIN
    BEGIN
      pq_cr_limit_desemb_digital.sp_obtener_Credito(instancia => instancia,
                                                    v_Pgcod   => v_Pgcod,
                                                    v_Scmod   => v_Scmod,
                                                    v_Scsuc   => v_Scsuc,
                                                    v_Scmda   => v_Scmda,
                                                    v_Scpap   => v_Scpap,
                                                    v_Sccta   => v_Sccta,
                                                    v_Scoper  => v_Scoper,
                                                    v_Scsbop  => v_Scsbop,
                                                    v_Sctope  => v_Sctope);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    BEGIN
      SELECT COUNT(1)
        INTO xrow
        FROM FST198 K
       WHERE K.TP1COD = 1
         AND K.TP1COD1 = 11152
         AND K.tp1corr1 = 70
         AND K.TP1CORR2 = 2
         AND K.TP1CORR3 > 0
         AND K.TP1NRO1 = v_Scmod;
    EXCEPTION
      WHEN OTHERS THEN
        xrow := 0;
    END;
    xrow := nvl(xrow, 0);

    IF xrow > 0 THEN
      codRpta := '1001';
      mensaje := 'No es posible desembolsar por ser modulo ' ||
                 trim(to_char(v_Scmod)) || '.';
      IF mensaje is not null THEN
        msgRpta := mensaje;
      END IF;
    ELSE
      codRpta := '0000';
    END IF;

  END;

  procedure sp_validar_segmt_MYPE(instancia   number,
                                  usuarioEjec varchar2,
                                  codRpta     out varchar2,
                                  msgRpta     out varchar2) is
    SegmClient  varchar2(30);
    Contador    number(1);
    mensaje     varchar2(200);
    P_PAIS      number(4);
    P_TDOC      number(4);
    P_NDOC      varchar2(12);
    P_USER      varchar2(10);
    P_SEGM_MICR varchar2(30);
    P_SEGM_PYME varchar2(30);
    P_SEGM_CONS varchar2(30);

  BEGIN
    P_USER := usuarioEjec;

    BEGIN
      SELECT A.SNG001PAIS, A.SNG001TDOC, A.SNG001NDOC
        INTO P_PAIS, P_TDOC, P_NDOC
        FROM SNG001 A
       WHERE A.SNG001INST = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --Obtener segemnto del client
    BEGIN
      PQ_CR_DATOS_CONSULTA_BURO.SP_CR_OBTENER_TIPO_SEGM(P_PAIS,
                                                        P_TDOC,
                                                        P_NDOC,
                                                        P_USER,
                                                        P_SEGM_MICR,
                                                        P_SEGM_PYME, --
                                                        P_SEGM_CONS);
    EXCEPTION
      WHEN OTHERS THEN
        P_SEGM_MICR := '';
        P_SEGM_PYME := '';
        P_SEGM_CONS := '';
    END;

    SegmClient := P_SEGM_PYME; --'BRONCE';
    --
    BEGIN
      SELECT COUNT(1)
        INTO Contador
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND tp1corr1 = 70
         AND TP1CORR2 = 4
         AND TP1CORR3 > 0
         AND TP1DESC = RPAD(SegmClient, 30, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        Contador := 0;
    END;

    Contador := NVL(Contador, 0);

    IF Contador > 0 THEN
      codRpta := '1002';
      BEGIN
        pq_cr_limit_desemb_digital.sp_buscar_descp_msg(codRpta, mensaje);
      EXCEPTION
        WHEN OTHERS THEN
          mensaje := '';
      END;
      IF mensaje is not null THEN
        msgRpta := mensaje;
      END IF;
    END IF;
  END;

  procedure sp_validar_segmt_Inclusivos(instancia   number,
                                        usuarioEjec varchar2,
                                        codRpta     out varchar2,
                                        msgRpta     out varchar2) is
    SegmClientInclu varchar2(30);
    Contador        number(1);
    mensaje         varchar2(200);
    P_PAIS          number(4);
    P_TDOC          number(4);
    P_NDOC          varchar2(12);
    P_USER          varchar2(10);
    P_SEGM_MICR     varchar2(30);
    P_SEGM_PYME     varchar2(30);
    P_SEGM_CONS     varchar2(30);

  BEGIN
    P_USER := usuarioEjec;

    BEGIN
      SELECT A.SNG001PAIS, A.SNG001TDOC, A.SNG001NDOC
        INTO P_PAIS, P_TDOC, P_NDOC
        FROM SNG001 A
       WHERE A.SNG001INST = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --Obtener segemnto del client
    BEGIN
      PQ_CR_DATOS_CONSULTA_BURO.SP_CR_OBTENER_TIPO_SEGM(P_PAIS,
                                                        P_TDOC,
                                                        P_NDOC,
                                                        P_USER,
                                                        P_SEGM_MICR,
                                                        P_SEGM_PYME, --
                                                        P_SEGM_CONS);
    EXCEPTION
      WHEN OTHERS THEN
        P_SEGM_MICR := '';
        P_SEGM_PYME := '';
        P_SEGM_CONS := '';
    END;

    SegmClientInclu := P_SEGM_MICR; --'BRONCE';

    --Obtener segemnto del client
    --SegmClientInclu := 'RECURRENTE';
    --
    BEGIN
      SELECT COUNT(1)
        INTO Contador
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND tp1corr1 = 70
         AND TP1CORR2 = 5
         AND TP1CORR3 > 0
         AND TP1DESC = RPAD(SegmClientInclu, 30, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        Contador := 0;
    END;

    Contador := NVL(Contador, 0);

    IF Contador > 0 THEN
      codRpta := '1003';
      BEGIN
        pq_cr_limit_desemb_digital.sp_buscar_descp_msg(codRpta, mensaje);
      EXCEPTION
        WHEN OTHERS THEN
          mensaje := '';
      END;
      IF mensaje is not null THEN
        msgRpta := mensaje;
      END IF;
    END IF;
  END;

  procedure sp_validar_orig_fondos_estado(instancia number,
                                          codRpta   out varchar2,
                                          msgRpta   out varchar2) is
    v_Pgcod  number(3);
    v_Scmod  number(4);
    v_Scsuc  number(4);
    v_Scmda  number(4);
    v_Scpap  number(4);
    v_Sccta  number(9);
    v_Scoper number(9);
    v_Scsbop number(3);
    v_Sctope number(3);

    v_flgExist varchar2(1);
    mensaje    varchar2(200);
  BEGIN
    BEGIN
      pq_cr_limit_desemb_digital.sp_obtener_Credito(instancia => instancia,
                                                    v_Pgcod   => v_Pgcod,
                                                    v_Scmod   => v_Scmod,
                                                    v_Scsuc   => v_Scsuc,
                                                    v_Scmda   => v_Scmda,
                                                    v_Scpap   => v_Scpap,
                                                    v_Sccta   => v_Sccta,
                                                    v_Scoper  => v_Scoper,
                                                    v_Scsbop  => v_Scsbop,
                                                    v_Sctope  => v_Sctope);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    -- Obtener meses permitidos
    v_flgExist := 'N';
    BEGIN
      SELECT 'S'
        INTO v_flgExist
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND tp1corr1 = 70
         AND TP1CORR2 = 6
         AND TP1CORR3 > 0
         AND TP1NRO1 = v_Scmod
         AND TP1NRO2 = v_Sctope;
    EXCEPTION
      WHEN OTHERS THEN
        v_flgExist := 'N';
    END;

    IF v_flgExist = 'S' THEN
      codRpta := '1004';
      BEGIN
        pq_cr_limit_desemb_digital.sp_buscar_descp_msg(codRpta, mensaje);
      EXCEPTION
        WHEN OTHERS THEN
          mensaje := '';
      END;
      IF mensaje is not null THEN
        msgRpta := mensaje;
      END IF;
    END IF;
  END;

  procedure sp_validar_plz_meses(instancia number,
                                 codRpta   out varchar2,
                                 msgRpta   out varchar2) is
    PlazoCred    number(5);
    NMeses       number(3);
    MesesPermitd number(4);
    mensaje      varchar2(200);
  BEGIN
    -- Obtener meses permitidos
    BEGIN
      SELECT TP1NRO1
        INTO MesesPermitd
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND tp1corr1 = 70
         AND TP1CORR2 = 3
         AND TP1CORR3 > 0;
    EXCEPTION
      WHEN OTHERS THEN
        MesesPermitd := 0;
    END;

    MesesPermitd := NVL(MesesPermitd, 0);

    NMeses := 0;
    BEGIN
      SELECT W.XWFPLAZO1
        INTO PlazoCred
        FROM XWF700 W
       WHERE W.XWFPRCINS = instancia
         AND W.XWFCAR3 = '1';
    END;

    PlazoCred := NVL(PlazoCred, 0);

    IF PlazoCred > 0 THEN
      NMeses := round((PlazoCred / 30.44));

      IF NMeses > MesesPermitd THEN
        codRpta := '1005';
        BEGIN
          pq_cr_limit_desemb_digital.sp_buscar_descp_msg(codRpta, mensaje);
        EXCEPTION
          WHEN OTHERS THEN
            mensaje := '';
        END;
        IF mensaje is not null THEN
          msgRpta := mensaje;
        END IF;
      END IF;
    END IF;
  END;

  procedure sp_validar_score(instancia  number,
                             usuarioEje varchar2,
                             codRpta    out varchar2,
                             msgRpta    out varchar2) is
    v_pais number(4);
    v_tdoc number(3);
    v_ndoc varchar2(12);

    p_segmRiesg  varchar2(50);
    p_riesgoScor varchar2(50);
    p_tipoScore  varchar2(50);
    p_puntaje    NUMBER(9, 2);
    p_fechScore  date;
    P_SEGM_MICR  varchar2(30);
    P_SEGM_PYME  varchar2(30);
    P_SEGM_CONS  varchar2(30);
    SegmClient   varchar2(30);

    ScoreHabil    varchar2(1);
    mensaje       varchar2(200);
    v_EsSegmHabil varchar2(1);

    v_Pgcod  number(3);
    v_Scmod  number(4);
    v_Scsuc  number(4);
    v_Scmda  number(4);
    v_Scpap  number(4);
    v_Sccta  number(9);
    v_Scoper number(9);
    v_Scsbop number(4);
    v_Sctope number(4);

    v_LetraScore      varchar2(1);
    v_NScoreMaxPermit number(2);
    v_ValScoreClient  number(2);
    v_LetrScoreMin    varchar2(30);

  BEGIN
    -- Clientes premium o superior con score A,B,C,D,E
    BEGIN
      SELECT W.SNG001PAIS, W.SNG001TDOC, W.SNG001NDOC
        INTO v_pais, v_tdoc, v_ndoc
        FROM SNG001 W
       WHERE W.SNG001INST = instancia;
    EXCEPTION
      WHEN OTHERS THEN
        v_pais := 0;
        v_tdoc := 0;
        v_ndoc := '';
    END;

    v_ndoc := TRIM(v_ndoc);

    BEGIN
      pq_cr_limit_desemb_digital.sp_obtener_Credito(instancia => instancia,
                                                    v_Pgcod   => v_Pgcod,
                                                    v_Scmod   => v_Scmod,
                                                    v_Scsuc   => v_Scsuc,
                                                    v_Scmda   => v_Scmda,
                                                    v_Scpap   => v_Scpap,
                                                    v_Sccta   => v_Sccta,
                                                    v_Scoper  => v_Scoper,
                                                    v_Scsbop  => v_Scsbop,
                                                    v_Sctope  => v_Sctope);
    END;

    --Validar max score para mod y tipo operac permitido
    v_NScoreMaxPermit := 0;
    BEGIN
      SELECT TP1IMP3
        INTO v_NScoreMaxPermit
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 10801
         AND tp1corr1 = 65
         AND TP1CORR2 = v_Scmod
         AND TP1CORR3 = v_Sctope;
    EXCEPTION
      WHEN OTHERS THEN
        v_NScoreMaxPermit := 0;
    END;
    v_NScoreMaxPermit := NVL(v_NScoreMaxPermit, 0);

   IF v_NScoreMaxPermit <> 0 THEN  --28/08/2024

        v_LetrScoreMin := '';
        BEGIN
          SELECT TP1DESC
            INTO v_LetrScoreMin
            FROM FST198
           WHERE TP1COD = 1
             AND TP1COD1 = 11152
             AND tp1corr1 = 70
             AND TP1CORR2 = 7
             AND TP1CORR3 > 0
             AND TP1NRO3 = v_NScoreMaxPermit;
        EXCEPTION
          WHEN OTHERS THEN
            v_LetrScoreMin := '';
        END;

        v_LetrScoreMin := RPAD(v_LetrScoreMin, 30, ' ');
        --IF v_NScoreMaxPermit > 0 THEN
          -- Obtener el score del cliente
          BEGIN
            PQ_CR_DATOS_CONSULTA_BURO.SP_CR_OBTENER_SCORE(P_TIPO_DOCUMENTO  => v_tdoc,
                                                          P_NRO_DOCUMENTO   => v_ndoc,
                                                          P_USUARIO_EJECUTA => usuarioEje,
                                                          P_SEGMENTO_RIESGO => p_segmRiesg,
                                                          P_RIESGO_SCORE    => p_riesgoScor,
                                                          P_TIPO_SCORE      => p_tipoScore,
                                                          P_PUNTAJE         => p_puntaje,
                                                          P_FECHA_SCORE     => p_fechScore);
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;

          v_LetraScore := substr(trim(p_riesgoScor), 8, 1);
          v_LetraScore := TRIM(v_LetraScore);
          IF TRIM(p_riesgoScor) = 'SIN SCORE' THEN
            v_LetraScore := '';
          END IF;

          v_ValScoreClient := 0;
          BEGIN
            SELECT TP1NRO3
              INTO v_ValScoreClient
              FROM FST198
             WHERE TP1COD = 1
               AND TP1COD1 = 11152
               AND tp1corr1 = 70
               AND TP1CORR2 = 7
               AND TP1CORR3 > 0
               AND TP1DESC = RPAD(v_LetraScore, 30, ' ');
          EXCEPTION
            WHEN OTHERS THEN
              v_ValScoreClient := 0;
          END;

          v_ValScoreClient := NVL(v_ValScoreClient, 0);

          IF v_ValScoreClient = 0 THEN
            codRpta := '1002';
            mensaje := 'No es posible desembolsar el crédito. El cliente no tiene SCORE.';
            msgRpta := mensaje;
          ELSE
            IF v_ValScoreClient > v_NScoreMaxPermit THEN
              -- rcastro Mod 28/11/2023
              -- ori v_NScoreMaxPermit >= v_ValScoreClient THEN
              codRpta := '1002';
              BEGIN
                mensaje := 'No es posible desembolsar el crédito. Score mínimo ' ||
                           trim(v_LetrScoreMin) || ' . Score cliente ' ||
                           trim(v_LetraScore) || '';
              EXCEPTION
                WHEN OTHERS THEN
                  mensaje := '';
              END;
              IF mensaje is not null THEN
                msgRpta := mensaje;
              END IF;
            ELSE
              codRpta := '0000';
              msgRpta := '';
            END IF;
            /* ELSE
            codRpta := '0000';  */
          END IF;
        --END IF;
    ELSE
      codRpta := '0000';
      msgRpta := '';
    END IF;
  END;
  -----------------------------------------------------------------------------------------------------------------------------
  PROCEDURE sp_valid_aval(pn_instancia number,               --11/12/2024
                          codRpta   out varchar2,
                          msgRpta   out varchar2) IS
  ln_cntcta number;

  v_Pgcod  number(3);
  v_Scmod  number(4);
  v_Scsuc  number(4);
  v_Scmda  number(4);
  v_Scpap  number(4);
  v_Sccta  number(9);
  v_Scoper number(9);
  v_Scsbop number(3);
  v_Sctope number(3);
  mensaje varchar2(200);
  v_flgExcpSolicitud varchar2(1);
  nroControl NUMBER;
  BEGIN
    BEGIN
      pq_cr_limit_desemb_digital.sp_obtener_Credito(instancia => pn_instancia,
                                                    v_Pgcod   => v_Pgcod,
                                                    v_Scmod   => v_Scmod,
                                                    v_Scsuc   => v_Scsuc,
                                                    v_Scmda   => v_Scmda,
                                                    v_Scpap   => v_Scpap,
                                                    v_Sccta   => v_Sccta,
                                                    v_Scoper  => v_Scoper,
                                                    v_Scsbop  => v_Scsbop,
                                                    v_Sctope  => v_Sctope);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    v_flgExcpSolicitud := 'N';
    nroControl := 7;
    BEGIN
       pq_cr_limit_desemb_digital.SP_VALIDAR_EXCEPCIONES_CONTROL(pn_instancia, nroControl, v_flgExcpSolicitud);
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END;

    IF v_flgExcpSolicitud = 'N' THEN
       BEGIN
          BEGIN
               select count(*) into ln_cntcta from sng003
                      where sng001inst = pn_instancia;
          EXCEPTION
          WHEN OTHERS THEN
            NULL;
          END;
          ln_cntcta := nvl(ln_cntcta, 0);

          IF ln_cntcta = 0 THEN
            BEGIN
                  select count(*) into ln_cntcta from fsr011
                        where r1cod = v_Pgcod and r1mod = v_Scmod and r1suc = v_Scsuc and r1mda = v_Scmda and r1pap = v_Scpap
                          and r1cta = v_Sccta and r1oper = v_Scoper and r1sbop = v_Scsbop and r1tope = v_Sctope
                          AND R011CO = 'S'
                          and relcod = 50;
            EXCEPTION
            WHEN OTHERS THEN
              NULL;
            END;
            ln_cntcta := nvl(ln_cntcta, 0);
          END IF;

          if ln_cntcta > 0 then
             codRpta  := '1007' ;
              BEGIN
                pq_cr_limit_desemb_digital.sp_buscar_descp_msg(codRpta, mensaje);
              EXCEPTION
                WHEN OTHERS THEN
                  mensaje := '';
              END;
              IF mensaje is not null THEN
                msgRpta := mensaje;
              END IF;
          ELSE
             codRpta := '0000';
             msgRpta := '';
          end if;
       END;
     END IF;
  END;
  -----------------------------------------------------------------------------------------------------------------------------
  procedure sp_validar_compraDeuda(instancia number,
                                   codRpta   out varchar2,
                                   msgRpta   out varchar2)  is
  p_outcoprdeuda VARCHAR2(1);
  p_outtipconv   VARCHAR2(20);
  mensaje        VARCHAR2(200);

  BEGIN
      begin
        pq_cr_camp_consumo.sp_cr_restriccion_desemb_app(instancia,
                                                        p_outcoprdeuda,
                                                        p_outtipconv);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      end;

      if p_outcoprdeuda = 'S' then
             codRpta  := '1008' ;
              BEGIN
                pq_cr_limit_desemb_digital.sp_buscar_descp_msg(codRpta, mensaje);
              EXCEPTION
              WHEN OTHERS THEN
              mensaje := '';
              END;
              IF mensaje is not null THEN
                msgRpta := mensaje;
              END IF;
       ELSE
          codRpta := '0000';
          msgRpta := '';
       end if;
  END;

  -----------------------------------------------------------------------------------------------------------------------------
  procedure sp_validar_fondos_gobierno(instancia in number,
                                       codRpta   out varchar2,
                                       msgRpta   out varchar2) is    --Créditos asociados a Programas de Gobierno
  v_Pgcod  number(3);
  v_Scmod  number(4);
  v_Scsuc  number(4);
  v_Scmda  number(4);
  v_Scpap  number(4);
  v_Sccta  number(9);
  v_Scoper number(9);
  v_Scsbop number(3);
  v_Sctope number(3);
  xrow     NUMBER(4);
  mensaje  VARCHAR2(200);
  BEGIN
       BEGIN
          pq_cr_limit_desemb_digital.sp_obtener_Credito(instancia => instancia,
                                                        v_Pgcod   => v_Pgcod,
                                                        v_Scmod   => v_Scmod,
                                                        v_Scsuc   => v_Scsuc,
                                                        v_Scmda   => v_Scmda,
                                                        v_Scpap   => v_Scpap,
                                                        v_Sccta   => v_Sccta,
                                                        v_Scoper  => v_Scoper,
                                                        v_Scsbop  => v_Scsbop,
                                                        v_Sctope  => v_Sctope);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;


       BEGIN
           SELECT COUNT(1)
           INTO xrow
        FROM FST198 K
       WHERE K.TP1COD = 1
         AND K.TP1COD1 = 11152
         AND K.tp1corr1 = 70
         AND K.TP1CORR2 = 3
         AND K.TP1CORR3 > 0
         AND K.TP1NRO2 = v_Scmod
         AND K.TP1NRO3 = v_Sctope;
       EXCEPTION
          WHEN OTHERS THEN
            xrow := 0;
       END;

       xrow := NVL(xrow, 0);

       IF xrow > 0 THEN
          codRpta  := '1010' ;
          BEGIN
            pq_cr_limit_desemb_digital.sp_buscar_descp_msg(codRpta, mensaje);
          EXCEPTION
          WHEN OTHERS THEN
          mensaje := '';
          END;
          IF mensaje is not null THEN
            msgRpta := mensaje;
          END IF;
        ELSE
          codRpta := '0000';
          msgRpta := '';
        END IF;

  END;
  -----------------------------------------------------------------------------------------------------------------------------
  procedure sp_obtener_Credito(instancia in number,
                               v_Pgcod   out number,
                               v_Scmod   out number,
                               v_Scsuc   out number,
                               v_Scmda   out number,
                               v_Scpap   out number,
                               v_Sccta   out number,
                               v_Scoper  out number,
                               v_Scsbop  out number,
                               v_Sctope  out number) IS
  BEGIN
    BEGIN
      SELECT W.XWFEMPRESA,
             W.XWFSUCURSAL,
             W.XWFMODULO,
             W.XWFMONEDA,
             W.XWFPAPEL,
             W.XWFCUENTA,
             W.XWFOPERACION,
             W.XWFSUBOPE,
             W.XWFTIPOPE
        INTO v_Pgcod,
             v_Scsuc,
             v_Scmod,
             v_Scmda,
             v_Scpap,
             v_Sccta,
             v_Scoper,
             v_Scsbop,
             v_Sctope
        FROM XWF700 W
       WHERE W.XWFPRCINS = instancia
         AND W.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;

  procedure sp_buscar_descp_msg(codigo varchar2, mensaje out varchar2) is
  v_codigoRep number(4);

  CURSOR dat_msg is
   SELECT TP1DESC as mensaje
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND tp1corr1 = 70
         AND TP1CORR2 = 1
         AND TP1CORR3 > 0
         AND TP1NRO1 = v_codigoRep
         ORDER BY TP1CORR3 ASC;

  BEGIN
    begin
      v_codigoRep := to_number(codigo, '9999');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    BEGIN
      FOR i IN dat_msg LOOP
         IF i.mensaje is not null or i.mensaje <> ' ' then
            IF mensaje IS NULL THEN
               mensaje := i.mensaje;
            ELSE
               mensaje := mensaje || ' ' || i.mensaje;
            END IF;
         end if;
      END LOOP;
    END;
  END;

  PROCEDURE SP_VALIDAR_EXCEPCIONES_CONTROL(instancia number, NroControl number, flgExcepc out varchar2) IS
  v_flgExcpSolicitud VARCHAR2(1);
  BEGIN
    ---01/03/2024 EXCEPTUAR por instancia
    flgExcepc := 'N';
    BEGIN
      SELECT 'S' into flgExcepc FROM FST198 K  WHERE
         K.Tp1cod = 1
         AND K.Tp1cod1 = 11152
         AND K.Tp1corr1 = 80
         AND K.Tp1corr2 = 1
         AND K.TP1CORR3 > 0
         AND K.TP1IMP1 = instancia;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END;

    IF flgExcepc = 'N' THEN
      ---valida el control este habilitado
      BEGIN
        SELECT 'S' into flgExcepc FROM FST198 K  WHERE
           K.Tp1cod = 1
           AND K.Tp1cod1 = 11152
           AND K.Tp1corr1 = 80
           AND K.Tp1corr2 = 5
           AND K.TP1CORR3 > 0
           AND K.TP1NRO2  = NroControl
           AND K.TP1NRO3  = 0;
      EXCEPTION
        WHEN OTHERS THEN
         flgExcepc := 'N';
      END;
    END IF;

    flgExcepc := NVL(flgExcepc, 'N');

  END;

end pq_cr_limit_desemb_digital;
/

