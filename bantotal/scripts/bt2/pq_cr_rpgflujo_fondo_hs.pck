create or replace package PQ_CR_RPGFLUJO_FONDO_HS is

  -- Author  : HSUAREZ
  -- Created : 11/02/2021 16:50:06
  -- Purpose : Paquete para proceasr creditos de reprogramacion gobierno

  procedure sp_calcular_monto( --ve_instancia number,
                              v_pgcod      number,
                              v_scmod      number,
                              v_scsuc      number,
                              v_scmda      number,
                              v_scpap      number,
                              v_sccta      number,
                              v_scoper     number,
                              v_scsbop     number,
                              v_sctope     number,
                              v_fecr       date,
                              v_users      varchar,
                              ve_comision  out number,
                              ve_tipofondo out varchar2,
                              ve_cod_msg   out number,
                              msg          out varchar2);
  procedure sp_calcular_comision(ve_instancia   number,
                                 ve_pgcod       number,
                                 ve_scmod       number,
                                 ve_scsuc       number,
                                 ve_scmda       number,
                                 ve_scpap       number,
                                 ve_sccta       number,
                                 ve_scoper      number,
                                 ve_scsbop      number,
                                 ve_sctope      number,
                                 ve_MtoCom      out number,
                                 ve_TpFndo      out varchar,
                                 ve_capitalc    out number,
                                 ve_porcentajec out number,
                                 msg            out varchar2);
  PROCEDURE sp_grabartasa(v_instancia in number,
                          v_Pgcod     in number,
                          v_Scmod     in number,
                          v_Scsuc     in number,
                          v_Scmda     in number,
                          v_Scpap     in number,
                          v_Sccta     in number,
                          v_Scoper    in number,
                          v_Scsbop    in number,
                          v_Sctope    in number,
                          --v_fecha  in number, 
                          vo_msg out varchar);

  PROCEDURE sp_grabar_transac(ve_instancia in number,
                              ve_codigo    in number,
                              ve_emp       in number,
                              ve_itmod     in number,
                              ve_itsuc     in number,
                              ve_ttran     in number,
                              ve_itnrel    in number,
                              ve_fvc       in date,
                              ve_fcont     in date);
  PROCEDURE sp_cr_tasa(v_Pgcod  in number,
                       v_Scmod  in number,
                       v_Scsuc  in number,
                       v_Scmda  in number,
                       v_Scpap  in number,
                       v_Sccta  in number,
                       v_Scoper in number,
                       v_Scsbop in number,
                       v_Sctope in number,
                       pn_tasa  out number);
  PROCEDURE SP_OBTENER_MONTO(v_Pgcod              in number,
                             v_Scmod              in number,
                             v_Scsuc              in number,
                             v_Scmda              in number,
                             v_Scpap              in number,
                             v_Sccta              in number,
                             v_Scoper             in number,
                             v_Scsbop             in number,
                             v_Sctope             in number,
                             vo_saldo             out number,
                             vo_comision_fae      out number,
                             vo_comision_reactiva out number);

  procedure sp_reprogramafondo(v_pgcod       in number,
                               v_Scmod       in number,
                               v_Scsuc       in number,
                               v_Scmda       in number,
                               v_Scpap       in number,
                               v_Sccta       in number,
                               v_Scoper      in number,
                               v_Scsbop      in number,
                               v_Sctope      in number,
                               ln_tipo       out number,
                               lc_tipo_fondo out varchar);
  PROCEDURE SP_CR_FONDOS_VTASA(ve_instancia number, vo_rpta out varchar);

  procedure SP_CR_turis_graciaturis(ln_instancia   in number,
                                    lv_turis       out varchar2,
                                    ln_graciaturis out number);
  procedure SP_CR_devolver_dias(ln_instacia          in number,
                                ln_dias_gracia_fondo out number);
  procedure sp_actualizaCMR(v_pgcod  in number,
                            v_Scmod  in number,
                            v_Scsuc  in number,
                            v_Scmda  in number,
                            v_Scpap  in number,
                            v_Sccta  in number,
                            v_Scoper in number,
                            v_Scsbop in number,
                            v_Sctope in number,
                            pgfape   in date,
                            v_nombre in varchar);
end PQ_CR_RPGFLUJO_FONDO_HS;
/

create or replace package body PQ_CR_RPGFLUJO_FONDO_HS is

  procedure sp_calcular_monto(v_pgcod      number,
                              v_scmod      number,
                              v_scsuc      number,
                              v_scmda      number,
                              v_scpap      number,
                              v_sccta      number,
                              v_scoper     number,
                              v_scsbop     number,
                              v_sctope     number,
                              v_fecr       date,
                              v_users      varchar,
                              ve_comision  out number,
                              ve_tipofondo out varchar2,
                              ve_cod_msg   out number,
                              msg          out varchar2) is
    vi_tea     number(10, 6);
    vi_tsa_per number(16, 6);
    vi_interes number(17, 6);
  
    vi_tea_r     number(10, 6);
    vi_tsa_per_r number(16, 6);
    vi_interes_r number(17, 6);
  
    vi_capital  number(17, 6);
    dias_transc number(5);
    --dif_int number(17,6); 
  
    vi_fec_hoy      date;
    VI_FEC_IMP      date;
    VI_FEC_IMPPP    date;
    vi_fec_original date;
    --variablñedel credito 
  
    v_pgcod1  fsd010.pgcod%type;
    v_scmod1  fsd010.aomod%type;
    v_scsuc1  fsd010.aosuc%type;
    v_scmda1  fsd010.aomda%type;
    v_scpap1  fsd010.aopap%type;
    v_sccta1  fsd010.aocta%type;
    v_scoper1 fsd010.aooper%type;
    v_scsbop1 fsd010.aosbop%type;
    v_sctope1 fsd010.aotope%type;
  
    v_ttas             number(17, 6);
    ve_instancia       NUMBER(9);
    vi_gob             varchar2(1);
    v_comision         number(17, 2);
    v_tipo             varchar(20);
    flag_pago          varchar(1);
    vo_capitalc        number(17, 2);
    vo_porcentajec     number(17, 2);
    VI_EXISTE_REGISTRO NUMBER(17, 2);
  begin
    -----OBTENER CLAVE DEL CREDITO
  
    BEGIN
      SELECT XWFprcins
        INTO ve_instancia
        FROM XWF700 X
       WHERE X.XWFEMPRESA = v_pgcod
         AND X.XWFMODULO = v_scmod
         AND X.XWFSUCURSAL = v_scsuc
         AND X.XWFMONEDA = v_scmda
         AND X.XWFPAPEL = v_scpap
         AND X.XWFCUENTA = v_sccta
         AND X.XWFOPERACION = v_scoper
         AND X.XWFSUBOPE = v_scsbop
         AND X.XWFTIPOPE = v_sctope
         AND X.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into v_pgcod1,
             v_Scsuc1,
             v_Scmod1,
             v_Scmda1,
             v_Scpap1,
             v_Sccta1,
             v_Scoper1,
             v_Scsbop1,
             v_Sctope1
        from xwf700 x
       where x.xwfprcins = ve_instancia
         and x.xwfcar3 <> '1';
    EXCEPTION
      WHEN OTHERS THEN
        v_pgcod1  := 0;
        v_Scsuc1  := 0;
        v_Scmod1  := 0;
        v_Scmda1  := 0;
        v_Scpap1  := 0;
        v_Sccta1  := 0;
        v_Scoper1 := 0;
        v_Scsbop1 := 0;
        v_Sctope1 := 0;
    END;
  
    ---------------------------------------------------------
    -- ADICIONAL CALCULO DE COMISION
    ---------------------------------------------------------
    pq_cr_reprog_fondos_hs.sp_calcular_comision(ve_instancia,
                                                v_pgcod1,
                                                v_scmod1,
                                                v_scsuc1,
                                                v_scmda1,
                                                v_scpap1,
                                                v_sccta1,
                                                v_scoper1,
                                                v_scsbop1,
                                                v_sctope1,
                                                v_comision,
                                                v_tipo,
                                                vo_capitalc,
                                                vo_porcentajec,
                                                msg);
  
    -----------------------------------------------------------
    ve_comision  := v_comision;
    ve_tipofondo := v_tipo;
    --log de datos utilizados para el calculo
    BEGIN
      SELECT COUNT(*)
        INTO VI_EXISTE_REGISTRO
        FROM AQPA840 T
       where T.AQPA840EMP = v_pgcod
         and T.AQPA840MOD = v_scmod
         and T.AQPA840SUC = v_scsuc
         and T.AQPA840MDA = v_scmda
         and T.AQPA840PAP = v_scpap
         and T.AQPA840CTA = v_sccta
         and T.AQPA840OPE = v_scoper
         and T.AQPA840SBO = v_scsbop
         and T.AQPA840TOP = v_sctope
         and T.AQPA840EST = 'C';
    END;
    PRAGMA AUTONOMOUS_TRANSACTION;
    IF VI_EXISTE_REGISTRO = 0 THEN
      BEGIN
        INSERT INTO AQPA840
          (AQPA840EMP,
           AQPA840MOD,
           AQPA840SUC,
           AQPA840MDA,
           AQPA840PAP,
           AQPA840CTA,
           AQPA840OPE,
           AQPA840SBO,
           AQPA840TOP,
           AQPA840FECR,
           AQPA840TIP,
           AQPA840AUX02,
           AQPA840INS,
           AQPA840SDO,
           AQPA840EST,
           AQPA840ITFCON,
           AQPA840ITHOR,
           AQPA840ITUCNF,
           AQPA840TIPFONDO,
           aqpa840FCOMCAP,
           aqpa840FCOMPOR,
           AQPa840FCOMMONTO)
        VALUES
          (v_pgcod,
           v_scmod,
           v_scsuc,
           v_scmda,
           v_scpap,
           v_sccta,
           v_scoper,
           v_scsbop,
           v_sctope,
           v_fecr,
           4, --ES PARA INDICAR QUE ES REPROGRAMA FONDOS
           4, --PARA INDICAR QUE ES DE LAS REPROGRAMACIONES 2022 REACTIVA.
           0,
           vo_capitalc,
           'C',
           sysdate,
           to_char(sysdate, 'HH24:MI:SS'),
           v_users,
           v_tipo,
           vo_capitalc,
           vo_porcentajec,
           v_comision);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      COMMIT;
    ELSE
      BEGIN
        update AQPA840 t
           set /*T.AQPA840DIAST   = dias_transc,                                                                                                                                                                                                                                                                                                                                                                                                                             
               T.aqpa840difint   = dif_int,*/  T.aqpa840TIPFONDO = v_tipo,
               T.aqpa840FCOMCAP   = vo_capitalc,
               t.aqpa840FCOMPOR   = vo_porcentajec,
               T.AQPa840FCOMMONTO = v_comision
         where T.AQPA840EMP = v_pgcod
           and T.AQPA840MOD = v_scmod
           and T.AQPA840SUC = v_scsuc
           and T.AQPA840MDA = v_scmda
           and T.AQPA840PAP = v_scpap
           and T.AQPA840CTA = v_sccta
           and T.AQPA840OPE = v_scoper
           and T.AQPA840SBO = v_scsbop
           and T.AQPA840TOP = v_sctope
           and T.AQPA840EST = 'C';
        --and T.AQPA840FECR  =  vi_fec_hoy;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      commit;
    END IF;
  end;
  -----------------------------------------------------------------
  -- 
  -----------------------------------------------------------------
  procedure sp_calcular_comision(ve_instancia   number,
                                 ve_pgcod       number,
                                 ve_scmod       number,
                                 ve_scsuc       number,
                                 ve_scmda       number,
                                 ve_scpap       number,
                                 ve_sccta       number,
                                 ve_scoper      number,
                                 ve_scsbop      number,
                                 ve_sctope      number,
                                 ve_MtoCom      out number,
                                 ve_TpFndo      out varchar,
                                 ve_capitalc    out number,
                                 ve_porcentajec out number,
                                 msg            out varchar2) IS
    vi_montoAprob number(17, 2);
    vi_nuevaTasa  number(10, 6);
    vi_fechaSist  date;
    vi_estado     number(3);
  BEGIN
  
    if ve_scmod = 101 and ve_sctope = 355 then
    
      --OBTENER PERFIL
      BEGIN
        SELECT F.TIPOPROGRAMA
          INTO ve_TpFndo
          FROM TURISMO G, TURISMO_CREDITOSFACILIDAD F
         WHERE F.IDTURISMO = G.IDTURISMO
           AND G.ESTADOSOLICITUD IN ('BT', 'AP')
           AND SUBSTR(F.CUENTAOPERACION,
                      0,
                      INSTR(F.CUENTAOPERACION, '-') - 1) = ve_sccta
           AND SUBSTR(F.CUENTAOPERACION,
                      INSTR(F.CUENTAOPERACION, '-') + 1,
                      99) = ve_scoper
           AND F.EMPRESA = ve_pgcod
           AND F.SUCURSAL = ve_scsuc
           AND F.MODULO = ve_scmod
           AND F.MONEDA = ve_scmda
           AND F.PAPEL = ve_scpap
           AND F.SUBOPERACION = ve_scsbop
           AND F.TIPOOPERACION = ve_sctope;
      exception
        when others then
          null;
      END;
    
    else
      --OBTENER PERFIL
      BEGIN
        SELECT F.TIPOPROGRAMA
          INTO ve_TpFndo
          FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
         WHERE F.IDFONDO = G.IDFONDO
           AND G.ESTADOSOLICITUD IN ('BT', 'AP')
           AND SUBSTR(F.CUENTAOPERACION,
                      0,
                      INSTR(F.CUENTAOPERACION, '-') - 1) = ve_sccta
           AND SUBSTR(F.CUENTAOPERACION,
                      INSTR(F.CUENTAOPERACION, '-') + 1,
                      99) = ve_scoper
           AND F.EMPRESA = ve_pgcod
           AND F.SUCURSAL = ve_scsuc
           AND F.MODULO = ve_scmod
           AND F.MONEDA = ve_scmda
           AND F.PAPEL = ve_scpap
           AND F.SUBOPERACION = ve_scsbop
           AND F.TIPOOPERACION = ve_sctope;
      exception
        when others then
          null;
      END;
    
    end if;
  
    ve_TpFndo := trim(ve_TpFndo);
  
    --VALIDAR
    IF ve_TpFndo = 'REACTIVA' THEN
      BEGIN
        SELECT X.XWFMONTO1
          INTO vi_montoAprob
          FROM XWF700 X
         WHERE XWFPRCINS = ve_instancia
           AND XWFCAR3 = '1';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      ve_capitalc    := vi_montoAprob;
      ve_porcentajec := 0.02;
      ve_MtoCom      := (vi_montoAprob * (0.02)) / 100; --0.02 del monto reprogramado
    
      -- MPOSTIGOC 16.03.2023
    else
      IF ve_TpFndo = 'FAE TURISMO' THEN
        BEGIN
          SELECT X.XWFMONTO1
            INTO vi_montoAprob
            FROM XWF700 X
           WHERE XWFPRCINS = ve_instancia
             AND XWFCAR3 = '1';
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        ve_capitalc    := vi_montoAprob;
        ve_porcentajec := 0.02;
        ve_MtoCom      := (vi_montoAprob * (0.02)) / 100; --0.02 del monto reprogramado
      END IF;
    END IF;
    IF ve_TpFndo = 'FAE1' or ve_TpFndo = 'FAE2' THEN
      begin
        begin
          SELECT PGFAPE INTO vi_fechaSist FROM FST017 WHERE PGCOD = 1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        begin
          select d10.aostat
            into vi_estado
            from fsd010 d10
           where d10.pgcod = ve_pgcod
             and d10.aomod = ve_scmod
             and d10.aosuc = ve_scsuc
             and d10.aomda = ve_scmda
             and d10.aopap = ve_scpap
             and d10.aocta = ve_sccta
             and d10.aooper = ve_scoper
             and d10.aosbop = ve_scsbop
             and d10.aotope = ve_sctope;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        end;
        -- Call the procedure
        pq_cr_reporte_fondos_p3.sp_obtener_sald_insol2(pn_cod   => ve_pgcod, --- Empresa (Entrada)
                                                       pn_mod   => ve_scmod, --- Módulo (Entrada)
                                                       pn_suc   => ve_scsuc, --- Sucursal (Entrada)
                                                       pn_mda   => ve_scmda, --- Moneda (Entrada)
                                                       pn_pap   => ve_scpap, --- Papel (Entrada)
                                                       pn_cta   => ve_sccta, --- Cuenta (Entrada)
                                                       pn_ope   => ve_scoper, --- Operación (Entrada)
                                                       pn_sbo   => ve_scsbop, --- Suboperación (Entrada)
                                                       pn_top   => ve_sctope, --- Tipo de operación (Entrada)
                                                       pn_fecha => vi_fechaSist, --- Fecha (Entrada)
                                                       pn_indi  => 2, --- Indicador 1-REACTIVA 2-FAE 3-CRECER (Entrada)
                                                       pn_stat  => vi_estado, --- Estado del crédito (Entrada)
                                                       pn_sald  => vi_montoAprob); --- Saldo Insoluto (Salida)
      
      end;
      /*
      BEGIN
        SELECT X.XWFMONTO1 
        INTO vi_montoAprob
        FROM XWF700 X WHERE XWFPRCINS=ve_instancia AND XWFCAR3=1;
      EXCEPTION 
        WHEN OTHERS THEN
          NULL;  
      END;
      */
      ve_capitalc    := vi_montoAprob;
      ve_porcentajec := 0.06;
      ve_MtoCom      := (vi_montoAprob * (0.06)) / 100; --0.02 del monto reprogramado  
    END IF;
  END;

  PROCEDURE sp_grabartasa(v_instancia in number,
                          v_Pgcod     in number,
                          v_Scmod     in number,
                          v_Scsuc     in number,
                          v_Scmda     in number,
                          v_Scpap     in number,
                          v_Sccta     in number,
                          v_Scoper    in number,
                          v_Scsbop    in number,
                          v_Sctope    in number,
                          --v_fecha  in number, 
                          vo_msg out varchar) is
    vi_tea number(10, 6);
  begin
    --LIMPIAR TASAS DE LA TRANSACCION 98-579
    /*  
        BEGIN
              UPDATE FSD012 D
                SET  D.D012CO= 'E'
              WHERE  D.PGCOD = v_pgcod
                AND  D.AOMOD = v_scmod
                AND  D.AOSUC = v_scsuc
                AND  D.AOMDA = v_scmda
                AND  D.AOPAP = v_scpap
                AND  D.AOCTA = v_sccta
                AND  D.AOOPER= v_scoper
                AND  D.AOSBOP= v_scsbop
                AND  D.AOTOPE= v_sctope
                AND  D.D012FC= (SELECT PGFAPE FROM FST017 WHERE PGCOD=1 AND ROWNUM=1)
                AND  D.D012MO= 98
                AND  D.D012TR= 579
                AND  D.EVTIPO= 3;            
          END;
    */
  
    BEGIN
      --OBTENER LA TASA CREDITO VIGENTE
      --pq_cr_reprog_gob.sp_cr_tasa
      pq_cr_reprog_fondos_hs.sp_cr_tasa(v_pgcod  => v_pgcod,
                                        v_scmod  => v_scmod,
                                        v_scsuc  => v_scsuc,
                                        v_scmda  => v_scmda,
                                        v_scpap  => v_scpap,
                                        v_sccta  => v_sccta,
                                        v_scoper => v_scoper,
                                        v_scsbop => v_scsbop,
                                        v_sctope => v_sctope,
                                        pn_tasa  => vi_tea);
    END;
  
    BEGIN
      UPDATE AQPB556
         SET AQPB556TSAA = vi_tea
       WHERE AQPB556INST = v_instancia
         AND AQPB556EMP = v_Pgcod
         AND AQPB556MOD = v_Scmod
         AND AQPB556SUC = v_Scsuc
         AND AQPB556MDA = v_Scmda
         AND AQPB556PAP = v_Scpap
         AND AQPB556CTA = v_Sccta
         AND AQPB556OPER = v_Scoper
         AND AQPB556SBOP = v_Scsbop
         AND AQPB556TOP = v_Sctope
         AND AQPB556COD = (SELECT MAX(AQPB556COD)
                             FROM AQPB556
                            WHERE AQPB556INST = v_instancia
                              AND AQPB556EMP = v_Pgcod
                              AND AQPB556MOD = v_Scmod
                              AND AQPB556SUC = v_Scsuc
                              AND AQPB556MDA = v_Scmda
                              AND AQPB556PAP = v_Scpap
                              AND AQPB556CTA = v_Sccta
                              AND AQPB556OPER = v_Scoper
                              AND AQPB556SBOP = v_Scsbop
                              AND AQPB556TOP = v_Sctope
                              AND AQPB556EHAB = 'H')
            --AND AQPB556EST  = 'P'
         AND AQPB556EHAB = 'H'
         AND ROWNUM = 1;
    END;
  
  end sp_grabartasa;

  PROCEDURE sp_grabar_transac(ve_instancia in number,
                              ve_codigo    in number,
                              ve_emp       in number,
                              ve_itmod     in number,
                              ve_itsuc     in number,
                              ve_ttran     in number,
                              ve_itnrel    in number,
                              ve_fvc       in date,
                              ve_fcont     in date) is
  BEGIN
    --ACTUALIZA LA TRANSACCION DEL INTERES EN LA AQPB556
    begin
      UPDATE AQPB556
         SET AQPB556TEMP  = ve_emp,
             AQPB556TSUC  = ve_itsuc,
             AQPB556TMOD  = ve_itmod,
             AQPB556TTRAN = ve_ttran,
             AQPB556TNREL = ve_itnrel,
             AQPB556TFVC  = ve_fvc,
             AQPB556TFCON = ve_fcont
       WHERE AQPB556COD = ve_codigo
         AND AQPB556INST = ve_instancia
         AND AQPB556EHAB = 'H';
    exception
      when others then
        null;
    end;
  end;

  PROCEDURE sp_cr_tasa(v_Pgcod  in number,
                       v_Scmod  in number,
                       v_Scsuc  in number,
                       v_Scmda  in number,
                       v_Scpap  in number,
                       v_Sccta  in number,
                       v_Scoper in number,
                       v_Scsbop in number,
                       v_Sctope in number,
                       pn_tasa  out number) is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_TASA
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2020.06.27
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna TASA
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    --                              
    -- ***************************************************************** 
    LN_EVCORR NUMBER;
  
  BEGIN
  
    BEGIN
      select MIN(D.EVCORR) - 1
        INTO LN_EVCORR
        FROM FSD012 D
       WHERE D.PGCOD = v_pgcod
         AND D.AOMOD = v_scmod
         AND D.AOSUC = v_scsuc
         AND D.AOMDA = v_scmda
         AND D.AOPAP = v_scpap
         AND D.AOCTA = v_sccta
         AND D.AOOPER = v_scoper
         AND D.AOSBOP = v_scsbop
         AND D.AOTOPE = v_sctope
         AND D.D012FC = (SELECT PGFAPE
                           FROM FST017
                          WHERE PGCOD = 1
                            AND ROWNUM = 1) --12/09/2020
         AND D.D012MO = 98
         AND D.D012TR = 579
         AND D.EVTIPO = 3;
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        --08.07.2021
        BEGIN
          select MAX(D.EVCORR)
            INTO LN_EVCORR
            FROM FSD012 D
           WHERE D.PGCOD = v_pgcod
             AND D.AOMOD = v_scmod
             AND D.AOSUC = v_scsuc
             AND D.AOMDA = v_scmda
             AND D.AOPAP = v_scpap
             AND D.AOCTA = v_sccta
             AND D.AOOPER = v_scoper
             AND D.AOSBOP = v_scsbop
             AND D.AOTOPE = v_sctope
             and D.evtipo = 3
             and D.d012co = 'S';
        EXCEPTION
          WHEN OTHERS THEN
            LN_EVCORR := 0;
        END;
      
      WHEN OTHERS THEN
        BEGIN
          select MAX(D.EVCORR)
            INTO LN_EVCORR
            FROM FSD012 D
           WHERE D.PGCOD = v_pgcod
             AND D.AOMOD = v_scmod
             AND D.AOSUC = v_scsuc
             AND D.AOMDA = v_scmda
             AND D.AOPAP = v_scpap
             AND D.AOCTA = v_sccta
             AND D.AOOPER = v_scoper
             AND D.AOSBOP = v_scsbop
             AND D.AOTOPE = v_sctope
             and D.evtipo = 3
             and D.d012co = 'S';
        EXCEPTION
          WHEN OTHERS THEN
            LN_EVCORR := 0;
        END;
    END;
  
    IF LN_EVCORR IS NULL THEN
      -- 08.07.2021 NO RECONOCE EL EXCEPTION SE FORZA LA CONSULTA. PARA OBTENER EL CORRELATIVO.
      BEGIN
        select MAX(D.EVCORR)
          INTO LN_EVCORR
          FROM FSD012 D
         WHERE D.PGCOD = v_pgcod
           AND D.AOMOD = v_scmod
           AND D.AOSUC = v_scsuc
           AND D.AOMDA = v_scmda
           AND D.AOPAP = v_scpap
           AND D.AOCTA = v_sccta
           AND D.AOOPER = v_scoper
           AND D.AOSBOP = v_scsbop
           AND D.AOTOPE = v_sctope
           and D.evtipo = 3
           and D.d012co = 'S';
      EXCEPTION
        WHEN OTHERS THEN
          LN_EVCORR := 0;
      END;
    END IF;
    begin
      select f1.evtasa
        into pn_tasa
        from fsd012 f1
       where f1.pgcod = v_Pgcod
         and f1.aomod = v_Scmod
         and f1.aosuc = v_Scsuc
         and f1.aomda = v_Scmda
         and f1.aopap = v_Scpap
         and f1.aocta = v_Sccta
         and f1.aooper = v_Scoper
         and f1.aosbop = v_Scsbop
         and f1.aotope = v_Sctope
         and f1.evtipo = 3
         and f1.d012co = 'S'
         and f1.evcorr in (select MAX(D.EVCORR)
                             FROM FSD012 D
                            WHERE D.PGCOD = v_pgcod
                              AND D.AOMOD = v_scmod
                              AND D.AOSUC = v_scsuc
                              AND D.AOMDA = v_scmda
                              AND D.AOPAP = v_scpap
                              AND D.AOCTA = v_sccta
                              AND D.AOOPER = v_scoper
                              AND D.AOSBOP = v_scsbop
                              AND D.AOTOPE = v_sctope
                              and D.evtipo = 3
                              and D.d012co = 'S'
                              and d.evcorr <= LN_EVCORR);
    exception
      when others then
        begin
          select f1.aotasa
            into pn_tasa
            from fsd010 f1
           where f1.pgcod = v_Pgcod
             and f1.aomod = v_Scmod
             and f1.aosuc = v_Scsuc
             and f1.aomda = v_Scmda
             and f1.aopap = v_Scpap
             and f1.aocta = v_Sccta
             and f1.aooper = v_Scoper
             and f1.aosbop = v_Scsbop
             and f1.aotope = v_Sctope;
        exception
          when others then
            pn_tasa := 0;
        end;
    end;
  
    if pn_tasa = 0 then
      begin
        select f1.aotasa
          into pn_tasa
          from fsd010 f1
         where f1.pgcod = v_Pgcod
           and f1.aomod = v_Scmod
           and f1.aosuc = v_Scsuc
           and f1.aomda = v_Scmda
           and f1.aopap = v_Scpap
           and f1.aocta = v_Sccta
           and f1.aooper = v_Scoper
           and f1.aosbop = v_Scsbop
           and f1.aotope = v_Sctope;
      exception
        when others then
          pn_tasa := 0;
      end;
    
    end if;
  
  end sp_cr_tasa;
  -------------------------------------------------------------------------
  PROCEDURE SP_OBTENER_MONTO(v_Pgcod              in number,
                             v_Scmod              in number,
                             v_Scsuc              in number,
                             v_Scmda              in number,
                             v_Scpap              in number,
                             v_Sccta              in number,
                             v_Scoper             in number,
                             v_Scsbop             in number,
                             v_Sctope             in number,
                             vo_saldo             out number,
                             vo_comision_fae      out number,
                             vo_comision_reactiva out number) is
  BEGIN
    vo_saldo := 0;
    BEGIN
      --CONSULTAR TABLA 
      SELECT F.AQPA840DIFINT, F.AQPA840FCOMMONTO, F.AQPA840FCOMMONTO
        INTO vo_saldo, vo_comision_fae, vo_comision_reactiva
        FROM AQPA840 F
       WHERE F.AQPA840EMP = v_Pgcod
         AND F.AQPA840MOD = v_Scmod
         AND F.AQPA840SUC = v_Scsuc
         AND F.AQPA840MDA = v_Scmda
         AND F.AQPA840PAP = v_Scpap
         AND F.AQPA840CTA = v_Sccta
         AND F.AQPA840OPE = v_Scoper
         AND F.AQPA840SBO = v_Scsbop
         AND F.AQPA840TOP = v_sctope
         AND F.AQPA840EST = 'C' --CONTABILIZADO
         AND F.AQPA840TIP = 4; --TIPO DE REPROGRAMACION GOBIERNO
      -- caja
    EXCEPTION
      WHEN OTHERS THEN
        vo_saldo := 0;
    END;
  END;

  procedure sp_reprogramafondo(v_pgcod       in number,
                               v_Scmod       in number,
                               v_Scsuc       in number,
                               v_Scmda       in number,
                               v_Scpap       in number,
                               v_Sccta       in number,
                               v_Scoper      in number,
                               v_Scsbop      in number,
                               v_Sctope      in number,
                               ln_tipo       out number,
                               lc_tipo_fondo out varchar) is
    ln_caja char(1);
    --Retorna S si se encuentra habilitado
  Begin
    ln_tipo := 0;
    begin
      SELECT 'F', F.tipoprograma
        into ln_caja, lc_tipo_fondo
      --into ln_tasa
        FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
       WHERE F.IDFONDO = G.IDFONDO
         AND G.ESTADOSOLICITUD IN ('BT', 'AP', 'CE') --16.07.2021 se añadio 'CE'
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             v_Sccta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = v_Scoper
         AND F.EMPRESA = v_pgcod
         AND F.SUCURSAL = v_Scsuc
         AND F.MODULO = v_Scmod
         AND F.MONEDA = v_Scmda
         AND F.PAPEL = v_Scpap
         AND F.SUBOPERACION = v_Scsbop
         AND F.TIPOOPERACION = v_Sctope;
    exception
      when no_data_found then
        ln_caja       := ' ';
        lc_tipo_fondo := '';
    end;
    if (ln_caja = 'F') then
      ln_tipo := 4; --solo si devuelve 4      es reprogramado fonod Reactiva y FAE
    end if;
  end sp_reprogramafondo;
  PROCEDURE SP_CR_FONDOS_VTASA(ve_instancia number, vo_rpta out varchar) is
    vi_emp       xwf700.xwfempresa%type;
    vi_suc       xwf700.xwfsucursal%type;
    vi_mod       xwf700.xwfmodulo%type;
    vi_mda       xwf700.xwfmoneda%type;
    vi_pap       xwf700.xwfpapel%type;
    vi_cta       xwf700.xwfcuenta%type;
    vi_ope       xwf700.xwfoperacion%type;
    vi_sbop      xwf700.xwfsubope%type;
    vi_tope      xwf700.xwftipope%type;
    vi_nuevaTasa number(10, 6);
    ve_TpFndo    varchar(10);
    VI_TASA      number(10, 6);
    VI_TEM       number(10, 6);
  
    VI_TASA_R NUMBER(10, 6);
    VI_TASA_F NUMBER(10, 6);
  
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
      SELECT F.TIPOPROGRAMA, F.NUEVATASA
        INTO ve_TpFndo, vi_nuevaTasa
        FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
       WHERE F.IDFONDO = G.IDFONDO
         AND G.ESTADOSOLICITUD IN ('BT', 'AP')
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
  
    --TASA ORIGINAL FSD010
    pq_cr_reprog_fondos_hs.sp_cr_tasa(vi_EMP,
                                      vi_mod,
                                      vi_suc,
                                      vi_mda,
                                      vi_pap,
                                      vi_cta,
                                      vi_ope,
                                      vi_sbop,
                                      vi_tope,
                                      vi_tasa);
    /*
    BEGIN
      SELECT F.AOTASA
        INTO VI_TASA
      FROM FSD010 F
      WHERE F.PGCOD  =  vi_EMP
        AND F.AOMOD  =  vi_mod
        AND F.AOSUC  =  vi_suc 
        AND F.AOMDA  =  vi_mda
        AND F.AOPAP  =  vi_pap
        AND F.AOCTA  =  vi_cta
        AND F.AOOPER =  vi_ope
        AND F.AOSBOP =  vi_sbop
        AND F.AOTOPE =  vi_tope;
    EXCEPTION
      WHEN OTHERS THEN
        vi_tasa:=0;    
    END;*/
    --OBTENER TASA DE GUIA ESPECIAL DE PROCESO
    BEGIN
      SELECT F.TP1IMP1, F.TP1IMP2
        INTO VI_TASA_R, VI_TASA_F
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 10899
         AND F.TP1CORR1 = 400000
         AND F.TP1CORR2 = 22
         AND F.TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    vo_rpta := 'N';
    IF ve_TpFndo = 'REACTIVA' THEN
      --VI_TEM:= VI_TASA + (VI_TASA*0.25)/100;
      VI_TEM := VI_TASA + VI_TASA_R; --0.25;
      IF VI_TEM >= vi_nuevaTasa and VI_TEM > VI_TASA and
         vi_nuevaTasa > VI_TASA THEN
        vo_rpta := 'S';
      END IF;
    END IF;
    IF ve_TpFndo = 'FAE1' or ve_TpFndo = 'FAE2' THEN
      --VI_TEM:= VI_TASA + (VI_TASA*0.15)/100;
      VI_TEM := VI_TASA + VI_TASA_F; --0.15;
      IF VI_TEM >= vi_nuevaTasa and VI_TEM > VI_TASA and
         vi_nuevaTasa > VI_TASA THEN
        vo_rpta := 'S';
      END IF;
    END IF;
  END;

  procedure SP_CR_turis_graciaturis(ln_instancia   in number,
                                    lv_turis       out varchar2,
                                    ln_graciaturis out number) is
    ln_cuenta       number;
    ln_tipdoc       number;
    ln_numdoc       varchar2(12);
    ln_pais         number;
    ln_codciiu      number;
    ln_numregistros number;
  begin
    begin
      --OBTENER LA CUENTA A PARTIR DE LA INSTANCIA
      select xw.xwfcuenta
        into ln_cuenta
        from xwf700 xw
       where xwFprcins = ln_instancia
         AND XWFCAR3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      --OBTENER LA CLAVE DEL DOCUMENTO PAIS, TIPO DOCUMENTO Y DNI
      select fs.pepais, fs.petdoc, fs.pendoc
        into ln_pais, ln_tipdoc, ln_numdoc
        from fsr008 fs
       where ctnro = ln_cuenta
         and cttfir = 'T';
    exception
      when others then
        null;
    end;
    --SI LA CLAVE DEL DNI EL TIPO DOCUMENTO 
    --PETDOC = 9 SE OBTIENE DE LA fse001 CASO CONTRARIO SNGC60
    if ln_tipdoc = 9 then
      begin
        Select e001.expnins
          Into ln_codciiu
          From fse001 e001
         Where e001.d511pais = ln_pais
           And e001.d511tdoc = ln_tipdoc
           And e001.d511ndoc = ln_numdoc;
      exception
        when others then
          null;
      end;
    else
      begin
        select sngc60acte
          Into ln_codciiu
          from sngc60
         where sngc60pais = ln_pais
           and sngc60tdoc = ln_tipdoc
           and sngc60ndoc = ln_numdoc;
      exception
        when others then
          null;
      end;
    end if;
  
    begin
      select count(*)
        into ln_numregistros
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11161
         and tp1corr1 = 51
         and tp1corr2 = 0
         and tp1corr3 > 0
         and tp1nro1 = ln_codciiu;
    exception
      when others then
        null;
    end;
  
    if ln_numregistros = 0 then
      begin
        lv_turis       := 'N';
        ln_graciaturis := 0;
      exception
        when others then
          null;
      end;
    else
      begin
        lv_turis := 'S';
        select tp1nro1
          into ln_graciaturis
          from fst198
         where tp1cod = 1
           and tp1cod1 = 11161
           and tp1corr1 = 51
           and tp1corr2 = 1
           and tp1corr3 = 1;
      exception
        when others then
          null;
      end;
    end if;
  end;

  procedure SP_CR_devolver_dias(ln_instacia          in number,
                                ln_dias_gracia_fondo out number) is
    ln_empresa       xwf700.xwfempresa%type;
    ln_modulo        xwf700.xwfmodulo%type;
    ln_sucursal      xwf700.xwfsucursal%type;
    ln_moneda        xwf700.xwfmoneda%type;
    ln_papel         xwf700.xwfpapel%type;
    ln_cuenta        xwf700.xwfcuenta%type;
    ln_operacion     xwf700.xwfoperacion%type;
    ln_suboperacion  xwf700.xwfsubope%type;
    ln_suboperacion0 xwf700.xwfsubope%type;
    ln_tipope        xwf700.xwftipope%type;
  
    ln_empresa1      xwf700.xwfempresa%type;
    ln_modulo1       xwf700.xwfmodulo%type;
    ln_sucursal1     xwf700.xwfsucursal%type;
    ln_moneda1       xwf700.xwfmoneda%type;
    ln_papel1        xwf700.xwfpapel%type;
    ln_cuenta1       xwf700.xwfcuenta%type;
    ln_operacion1    xwf700.xwfoperacion%type;
    ln_suboperacion1 xwf700.xwfsubope%type;
    ln_tipope1       xwf700.xwftipope%type;
  
    ln_primer_cuota     fsd601.ppfpag%type;
    ln_primer_cuota_cap fsd601.ppfpag%type;
    ln_primer_cuot_pag  fsd601.ppfpag%type;
  begin
    begin
      select xw.xwfempresa,
             xw.xwfmodulo,
             xw.xwfsucursal,
             xw.xwfmoneda,
             xw.xwfpapel,
             xw.xwfcuenta,
             xw.xwfoperacion,
             xw.xwfsubope,
             xw.xwftipope
        into ln_empresa,
             ln_modulo,
             ln_sucursal,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_suboperacion,
             ln_tipope
        from xwf700 xw
       where xwFprcins = ln_instacia
         AND XWFCAR3 = '1';
    exception
      when others then
        null;
    end;
    begin
      select xw.xwfempresa,
             xw.xwfmodulo,
             xw.xwfsucursal,
             xw.xwfmoneda,
             xw.xwfpapel,
             xw.xwfcuenta,
             xw.xwfoperacion,
             xw.xwfsubope,
             xw.xwftipope
        into ln_empresa1,
             ln_modulo1,
             ln_sucursal1,
             ln_moneda1,
             ln_papel1,
             ln_cuenta1,
             ln_operacion1,
             ln_suboperacion1,
             ln_tipope1
        from xwf700 xw
       where xwFprcins = ln_instacia
         AND XWFCAR3 <> '1';
    exception
      when others then
        null;
    end;
    ln_primer_cuot_pag := to_date('01/01/2001', 'dd/mm/yyyy');
    ln_suboperacion0   := ln_suboperacion - 1;
    begin
      select max(f.ppfpag)
        into ln_primer_cuot_pag
        from fsd602 f
       where f.pgcod = ln_empresa1
         and f.ppmod = ln_modulo1
         and f.ppsuc = ln_sucursal1
         and f.ppmda = ln_moneda1
         and f.pppap = ln_papel1
         and f.ppcta = ln_cuenta1
         and f.ppoper = ln_operacion1
         and f.ppsbop = ln_suboperacion1
         and f.pptope = ln_tipope1
         and f.d602co = 'S' --contabilizada
         and f.pp1stat = 'T'; --totalmente pagada
    exception
      when no_data_found then
        ln_primer_cuot_pag := to_date('01/01/2001', 'dd/mm/yyyy');
      when others then
        ln_primer_cuot_pag := to_date('01/01/2001', 'dd/mm/yyyy');
      
    end;
    if ln_primer_cuot_pag is null then
      ln_primer_cuot_pag := to_date('01/01/2001', 'dd/mm/yyyy');
    end if;
    --CREDITO VIGENTE 
    --obtenerr la primera Cuota Impaga
    begin
      select min(ppfpag)
        into ln_primer_cuota
        from fsd601 f
       where f.pgcod = ln_empresa1
         and f.ppmod = ln_modulo1
         and f.ppsuc = ln_sucursal1
         and f.ppmda = ln_moneda1
         and pppap = ln_papel1
         and ppcta = ln_cuenta1
         and ppoper = ln_operacion1
         and ppsbop = ln_suboperacion1
         and pptope = ln_tipope1
         and ppfpag > ln_primer_cuot_pag;
    exception
      when others then
        BEGIN
          select min(ppfpag)
            into ln_primer_cuota
            from fsd601 f
           where f.pgcod = ln_empresa1
             and f.ppmod = ln_modulo1
             and f.ppsuc = ln_sucursal1
             and f.ppmda = ln_moneda1
             and pppap = ln_papel1
             and ppcta = ln_cuenta1
             and ppoper = ln_operacion1
             and ppsbop = ln_suboperacion1
             and pptope = ln_tipope1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
    end;
    if ln_primer_cuota is null then
      begin
        select min(ppfpag)
          into ln_primer_cuota
          from fsd601 f
         where f.pgcod = ln_empresa1
           and f.ppmod = ln_modulo1
           and f.ppsuc = ln_sucursal1
           and f.ppmda = ln_moneda1
           and pppap = ln_papel1
           and ppcta = ln_cuenta1
           and ppoper = ln_operacion1
           and ppsbop = ln_suboperacion1
           and pptope = ln_tipope1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    end if;
    --CREDITO ACTUAL
    begin
      select min(ppfpag)
        into ln_primer_cuota_cap
        from fsd601 f
       where f.pgcod = ln_empresa
         and f.ppmod = ln_modulo
         and f.ppsuc = ln_sucursal
         and f.ppmda = ln_moneda
         and pppap = ln_papel
         and ppcta = ln_cuenta
         and ppoper = ln_operacion
         and ppsbop = ln_suboperacion
         and pptope = ln_tipope
         and ppcap > 0;
    exception
      when others then
        null;
    end;
  
    begin
      ln_dias_gracia_fondo := ln_primer_cuota_cap - ln_primer_cuota;
    exception
      when others then
        null;
    end;
  
  end;

  procedure sp_actualizaCMR(v_pgcod  in number,
                            v_Scmod  in number,
                            v_Scsuc  in number,
                            v_Scmda  in number,
                            v_Scpap  in number,
                            v_Sccta  in number,
                            v_Scoper in number,
                            v_Scsbop in number,
                            v_Sctope in number,
                            pgfape   in date,
                            v_nombre in varchar) is
  
    ---    PRAGMA AUTONOMOUS_TRANSACTION;
    ln_id        number;
    ln_contador  number; --registros por procesar
    ln_contadorp number; --registros procesados
    --Retorna S si se encuentra habilitado
  Begin
    ln_id        := 0;
    ln_contador  := 0;
    ln_contadorp := 0;
  
    if v_Scmod = 101 and v_Sctope = 355 then
      --mpostigoc 20.03.2023
      Begin
        select F.IDTURISMO
          into ln_id --obtengo  l.idley3150
          FROM TURISMO G, TURISMO_CREDITOSFACILIDAD F
         WHERE F.IDTURISMO = G.IDTURISMO
           AND G.ESTADOSOLICITUD = 'BT'
           AND SUBSTR(F.CUENTAOPERACION,
                      0,
                      INSTR(F.CUENTAOPERACION, '-') - 1) = v_Sccta
           AND SUBSTR(F.CUENTAOPERACION,
                      INSTR(F.CUENTAOPERACION, '-') + 1,
                      99) = v_Scoper
           AND F.EMPRESA = v_pgcod
           AND F.SUCURSAL = v_Scsuc
           AND F.MODULO = v_Scmod
           AND F.MONEDA = v_Scmda
           AND F.PAPEL = v_Scpap
           AND F.SUBOPERACION = v_Scsbop
           AND F.TIPOOPERACION = v_Sctope;
      exception
        when no_data_found then
          ln_id := 0;
        WHEN OTHERS THEN
          NULL;
      end;
      if (ln_id <> 0) then
      
        BEGIN
          update TURISMO_CREDITOSFACILIDAD F
             set PROCESADOBT = 'S'
           WHERE F.IDTURISMO = ln_id
             AND SUBSTR(F.CUENTAOPERACION,
                        0,
                        INSTR(F.CUENTAOPERACION, '-') - 1) = v_Sccta
             AND SUBSTR(F.CUENTAOPERACION,
                        INSTR(F.CUENTAOPERACION, '-') + 1,
                        99) = v_Scoper
             AND F.EMPRESA = v_pgcod
             AND F.SUCURSAL = v_Scsuc
             AND F.MODULO = v_Scmod
             AND F.MONEDA = v_Scmda
             AND F.PAPEL = v_Scpap
             AND F.SUBOPERACION = v_Scsbop
             AND F.TIPOOPERACION = v_Sctope;
          commit;
        END;
      
        BEGIN
          select count(*)
            into ln_contadorp
            from TURISMO_CREDITOSFACILIDAD F
           where F.IDTURISMO = ln_id
             and PROCESADOBT in ('S'); --cuenta todos los procesados
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        BEGIN
          select count(*)
            into ln_contador
            from TURISMO_CREDITOSFACILIDAD F
           where F.IDTURISMO = ln_id; -- and ( PROCESADOBT in ('') or PROCESADOBT=null);--cuenta todos los no procesados          
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        if (ln_contadorp = ln_contador) then
          --si es igual a cero quiere decir que no hay ninguno en nullo vacio todos están procesados o extornados
          update TURISMO L
             set ESTADOSOLICITUD = 'AP', FECHAENPARAAPROBACION = pgfape
           WHERE L.IDTURISMO = ln_id
             and L.ESTADOSOLICITUD = 'BT';
          commit;
        end if;
      end if;
    
    else
    
      Begin
        select F.IDFONDO
          into ln_id --obtengo  l.idley3150
          FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
         WHERE F.IDFONDO = G.IDFONDO
           AND G.ESTADOSOLICITUD = 'BT'
           AND SUBSTR(F.CUENTAOPERACION,
                      0,
                      INSTR(F.CUENTAOPERACION, '-') - 1) = v_Sccta
           AND SUBSTR(F.CUENTAOPERACION,
                      INSTR(F.CUENTAOPERACION, '-') + 1,
                      99) = v_Scoper
           AND F.EMPRESA = v_pgcod
           AND F.SUCURSAL = v_Scsuc
           AND F.MODULO = v_Scmod
           AND F.MONEDA = v_Scmda
           AND F.PAPEL = v_Scpap
           AND F.SUBOPERACION = v_Scsbop
           AND F.TIPOOPERACION = v_Sctope;
      exception
        when no_data_found then
          ln_id := 0;
        WHEN OTHERS THEN
          NULL;
      end;
      if (ln_id <> 0) then
      
        update FONDOS_CREDITOSFACILIDAD F
           set PROCESADOBT = 'S', NUEVOCRONOGRAMA = v_nombre
         WHERE F.IDFONDO = ln_id
           AND SUBSTR(F.CUENTAOPERACION,
                      0,
                      INSTR(F.CUENTAOPERACION, '-') - 1) = v_Sccta
           AND SUBSTR(F.CUENTAOPERACION,
                      INSTR(F.CUENTAOPERACION, '-') + 1,
                      99) = v_Scoper
           AND F.EMPRESA = v_pgcod
           AND F.SUCURSAL = v_Scsuc
           AND F.MODULO = v_Scmod
           AND F.MONEDA = v_Scmda
           AND F.PAPEL = v_Scpap
           AND F.SUBOPERACION = v_Scsbop
           AND F.TIPOOPERACION = v_Sctope;
        commit;
        /*   --esto es para los casos que tienen doble registro por que uno de los titulares falleció
        update LEY31050_CREDITOSFACILIDAD F set PROCESADOBT='S', NUEVOCRONOGRAMA = v_nombre
        WHERE F.IDLEY31050 = ln_id
           -- AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
            AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
            AND F.EMPRESA  = v_pgcod;
        commit;   */
        BEGIN
          select count(*)
            into ln_contadorp
            from FONDOS_CREDITOSFACILIDAD F
           where F.IDFONDO = ln_id
             and PROCESADOBT in ('S'); --cuenta todos los procesados
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        BEGIN
          select count(*)
            into ln_contador
            from FONDOS_CREDITOSFACILIDAD F
           where F.IDFONDO = ln_id; -- and ( PROCESADOBT in ('') or PROCESADOBT=null);--cuenta todos los no procesados          
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        if (ln_contadorp = ln_contador) then
          --si es igual a cero quiere decir que no hay ninguno en nullo vacio todos están procesados o extornados
          update FONDOS L
             set ESTADOSOLICITUD = 'AP', FECHAENPARAAPROBACION = pgfape
           WHERE L.IDFONDO = ln_id
             and L.ESTADOSOLICITUD = 'BT';
          commit;
        end if;
      end if;
    end if;
  end sp_actualizaCMR;

end PQ_CR_RPGFLUJO_FONDO_HS;
/

