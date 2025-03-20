create or replace package pq_cr_reprog_fondos_hs is

  -- Author  : HSUAREZ
  -- Created : 11/02/2021 16:50:06
  -- Purpose : Paquete para proceasr creditos de reprogramacion gobierno

  procedure sp_validar_rpg_gob(ve_instancia number,vo_rest out varchar);
  procedure sp_calcular_monto(ve_instancia number,
                              ve_pgcod number,
                              ve_scmod number,
                              ve_scsuc  number,
                              ve_scmda  number,
                              ve_scpap  number,
                              ve_sccta  number,
                              ve_scoper number,
                              ve_scsbop number,
                              ve_sctope number,
                              dif_int out number,
                              ve_MtoCom out number,
                              ve_TpFndo out varchar,
                              msg out varchar2);
 procedure sp_calcular_comision(ve_instancia number,
                               ve_pgcod number,
                               ve_scmod number,
                               ve_scsuc  number,
                               ve_scmda  number,
                               ve_scpap  number,
                               ve_sccta  number,
                               ve_scoper number,
                               ve_scsbop number,
                               ve_sctope number,
                               ve_MtoCom out number,
                               ve_TpFndo out varchar,
                               ve_capitalc out number,
                               ve_porcentajec out number,
                               msg out varchar2);
  PROCEDURE sp_grabartasa(v_instancia in number,
                          v_Pgcod  in number,
                          v_Scmod  in number,
                          v_Scsuc  in number,
                          v_Scmda  in number,
                          v_Scpap  in number,
                          v_Sccta  in number,
                          v_Scoper in number,
                          v_Scsbop in number,
                          v_Sctope in number,
                          --v_fecha  in number,
                          vo_msg  out varchar);

  PROCEDURE sp_grabar_transac(ve_instancia in number,
                            ve_codigo in number,
                            ve_emp    in number,
                            ve_itmod  in number,
                            ve_itsuc  in number,
                            ve_ttran  in number,
                            ve_itnrel in number,
                            ve_fvc    in date,
                            ve_fcont  in date
                           );
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
  PROCEDURE SP_OBTENER_MONTO(v_Pgcod  in number,
                           v_Scmod  in number,
                           v_Scsuc  in number,
                           v_Scmda  in number,
                           v_Scpap  in number,
                           v_Sccta  in number,
                           v_Scoper in number,
                           v_Scsbop in number,
                           v_Sctope in number,
                           vo_saldo out number,
                           vo_comision_fae out number,
                           vo_comision_reactiva out number);

  procedure sp_reprogramafondo(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             ln_tipo   out number,
                             lc_tipo_fondo out varchar
                             );
  PROCEDURE SP_CR_FONDOS_VTASA(
                              ve_instancia number,
                              vo_rpta out varchar
                            );
end pq_cr_reprog_fondos_hs;
/

create or replace package body pq_cr_reprog_fondos_hs is

procedure sp_validar_rpg_gob(ve_instancia number,vo_rest out varchar)is
  vi_emp  xwf700.xwfempresa%type;
  vi_mod  xwf700.xwfmodulo%type;
  vi_suc  xwf700.xwfsucursal%type;
  vi_mda  xwf700.xwfmoneda%type;
  vi_pap  xwf700.xwfpapel%type;
  vi_cta  xwf700.xwfcuenta%type;
  vi_oper xwf700.xwfoperacion%type;
  vi_sbop xwf700.xwfsubope%type;
  vi_tope xwf700.xwftipope%type;

  begin
    vo_rest:='N';
          begin
               select
               x.xwfempresa,
               x.xwfmodulo,
               x.xwfsucursal,
               x.xwfmoneda,
               x.xwfpapel,
               x.xwfcuenta,
               x.xwfoperacion,
               x.xwfsubope,
               x.xwftipope
               into
               vi_emp,
               vi_mod,
               vi_suc,
               vi_mda,
               vi_pap,
               vi_cta,
               vi_oper,
               vi_sbop,
               vi_tope
               from xwf700 x
               where x.xwfprcins=ve_instancia
                 and x.xwfcar3='1'
                 and rownum=1;
            end;
          begin
            select 'S'
              into vo_rest
            from aqpa840 t
            where t.AQPA840EMP = vi_emp
              and t.AQPA840MOD = vi_mod
              and t.AQPA840SUC = vi_suc
              and t.AQPA840MDA = vi_mda
              and t.AQPA840PAP = vi_pap
              and t.AQPA840CTA = vi_cta
              and t.AQPA840OPE = vi_oper
              and t.AQPA840SBO = vi_sbop
              and t.AQPA840TOP = vi_tope
              and t.aqpa840tip = '2';
          exception
            when others then
                vo_rest:='N';
          end;
    end;

procedure sp_calcular_monto(ve_instancia number,
                            ve_pgcod number,
                            ve_scmod number,
                            ve_scsuc  number,
                            ve_scmda  number,
                            ve_scpap  number,
                            ve_sccta  number,
                            ve_scoper number,
                            ve_scsbop number,
                            ve_sctope number,
                            dif_int out number,
                            ve_MtoCom out number,
                            ve_TpFndo out varchar,
                            msg out varchar2) is
  vi_tea number(10,6);
  vi_tsa_per number(16,6);
  vi_interes number(17,6);

  vi_tea_r number(10,6);
  vi_tsa_per_r number(16,6);
  vi_interes_r number(17,6);

  vi_capital number(17,6);
  dias_transc number(5);
  --dif_int number(17,6);

  vi_fec_hoy date;
  VI_FEC_IMP date;
  VI_FEC_IMPPP date;
  vi_fec_original date;
  --variablñedel credito
  v_pgcod  fsd010.pgcod%type;
  v_scmod  fsd010.aomod%type;
  v_scsuc  fsd010.aosuc%type;
  v_scmda  fsd010.aomda%type;
  v_scpap  fsd010.aopap%type;
  v_sccta fsd010.aocta%type;
  v_scoper fsd010.aooper%type;
  v_scsbop fsd010.aosbop%type;
  v_sctope fsd010.aotope%type;
  v_ttas   number(17,6);
  vi_gob   varchar2(1);
  v_comision number(17,2);
  v_tipo varchar(20);
  flag_pago varchar(1);
  vo_capitalc number(17,2);
  vo_porcentajec number(17,2);
begin
          --obtener la clave del credito
          /*
          begin
              select x.xwfempresa,
                     x.xwfmodulo,
                     x.xwfsucursal,
                     x.xwfmoneda,
                     x.xwfpapel,
                     x.xwfcuenta,
                     x.xwfoperacion,
                     x.xwfsubope,
                     x.xwftipope
                into
                     v_pgcod,
                     v_scmod,
                     v_scsuc,
                     v_scmda,
                     v_scpap,
                     v_sccta,
                     v_scoper,
                     v_scsbop,
                     v_sctope
                from xwf700 x
               where x.xwfprcins = ve_instancia
                 and x.xwfcar3='1';
          end;
          */
          v_pgcod :=  ve_pgcod;
          v_scmod :=  ve_scmod;
          v_scsuc :=  ve_scsuc;
          v_scmda :=  ve_scmda;
          v_scpap :=  ve_scpap;
          v_sccta :=  ve_sccta;
          v_scoper := ve_scoper;
          v_scsbop := ve_scsbop;
          v_sctope := ve_sctope;
       --OBTENER LA TASA CREDITO VIGENTE
       /*
       pq_cr_jaqa257.sp_cr_tasa(v_pgcod => v_pgcod,
                           v_scmod => v_scmod,
                           v_scsuc => v_scsuc,
                           v_scmda => v_scmda,
                           v_scpap => v_scpap,
                           v_sccta => v_sccta,
                           v_scoper => v_scoper,
                           v_scsbop => v_scsbop,
                           v_sctope => v_sctope,
                           pn_tasa => vi_tea);
       */
       BEGIN
           SELECT AQPB556TSAA
           INTO vi_tea
           FROM AQPB556 A
           WHERE A.AQPB556INST = ve_instancia
            AND A.AQPB556EMP  = v_Pgcod
            AND A.AQPB556MOD  = v_Scmod
            AND A.AQPB556SUC  = v_Scsuc
            AND A.AQPB556MDA  = v_Scmda
            AND A.AQPB556PAP  = v_Scpap
            AND A.AQPB556CTA  = v_Sccta
            AND A.AQPB556OPER = v_Scoper
            AND A.AQPB556SBOP = v_Scsbop
            AND A.AQPB556TOP = v_Sctope
            AND AQPB556COD = (
                           SELECT MAX(AQPB556COD)
                             FROM AQPB556
                            WHERE AQPB556INST = ve_instancia
                              AND AQPB556EMP  = v_Pgcod
                              AND AQPB556MOD  = v_Scmod
                              AND AQPB556SUC  = v_Scsuc
                              AND AQPB556MDA  = v_Scmda
                              AND AQPB556PAP  = v_Scpap
                              AND AQPB556CTA  = v_Sccta
                              AND AQPB556OPER = v_Scoper
                              AND AQPB556SBOP = v_Scsbop
                              AND AQPB556TOP  = v_Sctope
                              AND AQPB556EHAB = 'H'
             )
            --AND A.AQPB556EST  = 'P'
            AND A.AQPB556EHAB = 'H'
            AND ROWNUM=1;
         EXCEPTION
            WHEN OTHERS THEN
              NULL;
         END;
       --DIAS TRANSCURRIDOS
              --OBTENER FECHA DE PRIMERA CUOTA IMPAGA.
              flag_pago := 'S';
              BEGIN
                    select max(ppfpag),'N'
                      into vi_fec_original,flag_pago
                      from fsd602 f
                     where f.pgcod = v_pgcod
                       and f.ppmod = v_scmod
                       and f.ppsuc = v_scsuc
                       and f.ppmda = v_scmda
                       and f.pppap = v_scpap
                       and f.ppcta = v_sccta
                       and f.ppoper = v_scoper
                       and f.ppsbop = v_scsbop
                       and f.pptope = v_sctope
                       and D602CO = 'S';
                exception
                  when no_data_found then
                    flag_pago:='S';
                  when others then
                    null;

                END;
                IF vi_fec_original IS NULL THEN
                  flag_pago:='S';
                  BEGIN
                    select min(ppfpag)
                      into vi_fec_original
                      from fsd601 f
                     where f.pgcod = v_pgcod
                       and f.ppmod = v_scmod
                       and f.ppsuc = v_scsuc
                       and f.ppmda = v_scmda
                       and f.pppap = v_scpap
                       and f.ppcta = v_sccta
                       and f.ppoper = v_scoper
                       and f.ppsbop = v_scsbop
                       and f.pptope = v_sctope;
                  END;
                END IF;
                --OBTENER FECHA IMPAGA
                if flag_pago = 'S' then
                  BEGIN
                     select max(f.ppfval)
                        into VI_FEC_IMP
                        from fsd601 f
                       where f.pgcod  = v_pgcod
                         and f.ppmod  = v_scmod
                         and f.ppsuc  = v_scsuc
                         and f.ppmda  = v_scmda
                         and f.pppap  = v_scpap
                         and f.ppcta  = v_sccta
                         and f.ppoper = v_scoper
                         and f.ppsbop = v_scsbop
                         and f.pptope = v_sctope
                         and f.ppfpag = vi_fec_original;
                    END;
                 else
                     VI_FEC_IMP := vi_fec_original;
                 end if;
              --OBTENER FECHA DE HOY.
              BEGIN
                SELECT f.pgfape
                  INTO vi_fec_hoy
                  FROM fst017 f
                  WHERE f.pgcod = v_pgcod;
                END;
              --DIFERENCIA DIA
              /* GOBIERNO
              SELECT vi_fec_hoy - VI_FEC_IMP
              INTO dias_transc
              FROM DUAL;
              */
              -- REPROGRAMACION FONDOS, EL CALUCLO SE OBTIENE DE LA FECHA DE PAGO DE LA CUOTA IMPAGA  - FECHA DE REPROGRAMACION  (DIF DIAS)
              BEGIN
               select min(f.ppfpag) --OBTENER PRIMERA CUOTA IMPAGA PROPUESTA
                  into VI_FEC_IMPPP
                  from fsd601 f
                 where f.pgcod  = v_pgcod
                   and f.ppmod  = v_scmod
                   and f.ppsuc  = v_scsuc
                   and f.ppmda  = v_scmda
                   and f.pppap  = v_scpap
                   and f.ppcta  = v_sccta
                   and f.ppoper = v_scoper
                   and f.ppsbop = (select max(ppsbop)
                                     from fsd601 f6
                                    where f6.pgcod  = v_pgcod
                                      and f6.ppmod  = v_scmod
                                      and f6.ppsuc  = v_scsuc
                                      and f6.ppmda  = v_scmda
                                      and f6.pppap  = v_scpap
                                      and f6.ppcta  = v_sccta
                                      and f6.ppoper = v_scoper
                                      and f6.pptope = v_sctope
                                      --and f6.ppstat = 'S'
                                      )
                   and f.pptope = v_sctope;
                   --and f.ppfpag = vi_fec_original;
              END;
              BEGIN
                SELECT VI_FEC_IMPPP - vi_fec_hoy
                INTO dias_transc
                FROM DUAL;
              END;
       --TASA DEL PERIODO CREDITO VIGENTE
        vi_tsa_per := (power((1+(vi_tea/100)),(dias_transc/360)))-1;
       --CAPITAL
       BEGIN
         SELECT d.scsdo
         INTO vi_capital
         FROM FSD011 D
         WHERE D.PGCOD  =  v_pgcod
            AND D.SCMOD =  v_scmod
            AND D.SCSUC =  v_scsuc
            AND D.SCMDA =  v_scmda
            AND D.SCPAP =  v_scpap
            AND D.SCCTA =  v_sccta
            AND D.SCOPER=  v_scoper
            AND D.SCSBOP=  v_scsbop
            AND D.SCTOPE=  v_sctope;
        EXCEPTION WHEN OTHERS THEN
          NULL;
         END;

       --CALCULO INTERES  CREDITO VIGENTE
       vi_interes := vi_capital*vi_tsa_per;

       -------------------------------------------------
       -------------------------------------------------
       -------------------------------------------------

       pq_cr_funciones_cho.sp_obtener_tasaFondo(pn_emp => v_pgcod,
                                                pn_mod => v_scmod,
                                                pn_suc => v_scsuc,
                                                pn_mda => v_scmda,
                                                pn_pap => v_scpap,
                                                pn_cta => v_sccta,
                                                pn_ope => v_scoper,
                                                pn_sbo => v_scsbop,
                                                pn_top => v_sctope,
                                                pn_tasa => vi_tea_r,
                                                pn_ttas => vi_gob);
       --TASA DEL PERIODO DEL CREDITO VIGENTE.
       vi_tsa_per_r := (power((1+(vi_tea_r/100)),(dias_transc/360)))-1;
       --CALCULO INTERES  CREDITO REBAJADO
       vi_interes_r := vi_capital*vi_tsa_per_r;


       dif_int := vi_interes - vi_interes_r;
       dif_int := abs(dif_int);

       ---------------------------------------------------------
       -- ADICIONAL CALCULO DE COMISION
       ---------------------------------------------------------
       pq_cr_reprog_fondos_hs.sp_calcular_comision(ve_instancia,
                                                   v_pgcod,
                                                   v_scmod,
                                                   v_scsuc,
                                                   v_scmda,
                                                   v_scpap,
                                                   v_sccta,
                                                   v_scoper,
                                                   v_scsbop,
                                                   v_sctope,
                                                   v_comision,
                                                   v_tipo,
                                                   vo_capitalc,
                                                   vo_porcentajec,
                                                   msg
       );
       ---ADICIONAR A LAS VARIABLES
       -----------------------------------------------------------
       ve_MtoCom := v_comision;
       ve_TpFndo := v_tipo;
       -----------------------------------------------------------

       if dif_int is null then
         dif_int := 0;
         msg := 'No se realizo correctamente el calculo, revisar los datos usados en el calculo';
       end if;
       if dif_int = 0 then
         msg := 'Las tasas son iguales, revisar si hay cambio de tasa';
       end if;
       --log de datos utilizados para el calculo
       BEGIN
             update AQPA840 t
             set T.AQPA840DIAST   = dias_transc,
                 T.AQPA840CAPITAL = vi_capital,
                 T.AQPA840TASAN   = vi_tea_r,
                 T.AQPA840TASAPR  = vi_tsa_per,
                 T.AQPA840INTR    = vi_interes_r,
                 T.AQPA840TASAV   = vi_tea,
                 T.AQPA840TASAPV  = vi_tsa_per_r,
                 T.AQPA840INTV    = vi_interes,
                 T.aqpa840difint   = dif_int,

                 T.aqpa840TIPFONDO = v_tipo,
                 T.aqpa840FCOMCAP = vo_capitalc,
                 t.aqpa840FCOMPOR  = vo_porcentajec,
                 T.AQPa840FCOMMONTO  = v_comision

             where T.AQPA840EMP   =  v_pgcod
               and T.AQPA840MOD   =  v_scmod
               and T.AQPA840SUC   =  v_scsuc
               and T.AQPA840MDA   =  v_scmda
               and T.AQPA840PAP   =  v_scpap
               and T.AQPA840CTA   =  v_sccta
               and T.AQPA840OPE   =  v_scoper
               and T.AQPA840SBO   =  v_scsbop
               and T.AQPA840TOP   =  v_sctope
               and T.AQPA840EST   =  'C';
               --and T.AQPA840FECR  =  vi_fec_hoy;
       END;
       commit;

       --dif_int := 350;
    end;
-----------------------------------------------------------------
--
-----------------------------------------------------------------
procedure sp_calcular_comision(ve_instancia number,
                               ve_pgcod number,
                               ve_scmod number,
                               ve_scsuc  number,
                               ve_scmda  number,
                               ve_scpap  number,
                               ve_sccta  number,
                               ve_scoper number,
                               ve_scsbop number,
                               ve_sctope number,
                               ve_MtoCom out number,
                               ve_TpFndo out varchar,
                               ve_capitalc out number,
                               ve_porcentajec out number,
                               msg out varchar2) IS
vi_montoAprob number(17,2);
vi_nuevaTasa number(10,6);
vi_fechaSist date;
vi_estado number(3);
BEGIN
     --OBTENER PERFIL
     BEGIN
       SELECT F.TIPOPROGRAMA
         INTO ve_TpFndo
        FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
        WHERE F.IDFONDO = G.IDFONDO
         AND G.ESTADOSOLICITUD IN ('BT','AP')
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) = ve_sccta
         AND SUBSTR(F.CUENTAOPERACION, INSTR(F.CUENTAOPERACION, '-') + 1,99) = ve_scoper
         AND F.EMPRESA      = ve_pgcod
         AND F.SUCURSAL     = ve_scsuc
         AND F.MODULO       = ve_scmod
         AND F.MONEDA       = ve_scmda
         AND F.PAPEL        = ve_scpap
         AND F.SUBOPERACION = ve_scsbop
         AND F.TIPOOPERACION= ve_sctope;
     exception
       when others then
         null;
     END;
     --VALIDAR
     IF ve_TpFndo = 'REACTIVA' THEN
       BEGIN
         SELECT X.XWFMONTO1
         INTO vi_montoAprob
         FROM XWF700 X WHERE XWFPRCINS=ve_instancia AND XWFCAR3='1';
       EXCEPTION
         WHEN OTHERS THEN
           NULL;
       END;
       ve_capitalc:= vi_montoAprob;
       ve_porcentajec:= 0.02;
       ve_MtoCom :=  (vi_montoAprob*(0.02))/100; --0.02 del monto reprogramado
     END IF;
     IF ve_TpFndo = 'FAE1' or ve_TpFndo = 'FAE2' THEN
       begin
         begin
           SELECT PGFAPE INTO vi_fechaSist FROM FST017 WHERE PGCOD=1;
           end;
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
           end;
          -- Call the procedure
          pq_cr_reporte_fondos_p3.sp_obtener_sald_insol2(pn_cod => ve_pgcod, --- Empresa (Entrada)
                                                         pn_mod => ve_scmod, --- Módulo (Entrada)
                                                         pn_suc => ve_scsuc, --- Sucursal (Entrada)
                                                         pn_mda => ve_scmda, --- Moneda (Entrada)
                                                         pn_pap => ve_scpap, --- Papel (Entrada)
                                                         pn_cta => ve_sccta, --- Cuenta (Entrada)
                                                         pn_ope => ve_scoper, --- Operación (Entrada)
                                                         pn_sbo => ve_scsbop, --- Suboperación (Entrada)
                                                         pn_top => ve_sctope, --- Tipo de operación (Entrada)
                                                         pn_fecha => vi_fechaSist, --- Fecha (Entrada)
                                                         pn_indi => 2,   --- Indicador 1-REACTIVA 2-FAE 3-CRECER (Entrada)
                                                         pn_stat => vi_estado,   --- Estado del crédito (Entrada)
                                                         pn_sald => vi_montoAprob);  --- Saldo Insoluto (Salida)

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
       ve_capitalc := vi_montoAprob;
       ve_porcentajec:= 0.06;
       ve_MtoCom :=  (vi_montoAprob*(0.06))/100; --0.02 del monto reprogramado
     END IF;
END;

PROCEDURE sp_grabartasa(v_instancia in number,
                        v_Pgcod  in number,
                        v_Scmod  in number,
                        v_Scsuc  in number,
                        v_Scmda  in number,
                        v_Scpap  in number,
                        v_Sccta  in number,
                        v_Scoper in number,
                        v_Scsbop in number,
                        v_Sctope in number,
                        --v_fecha  in number,
                        vo_msg  out varchar) is
  vi_tea number(10,6);
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
       pq_cr_reprog_fondos_hs.sp_cr_tasa(v_pgcod => v_pgcod,
                                v_scmod => v_scmod,
                                v_scsuc => v_scsuc,
                                v_scmda => v_scmda,
                                v_scpap => v_scpap,
                                v_sccta => v_sccta,
                                v_scoper => v_scoper,
                                v_scsbop => v_scsbop,
                                v_sctope => v_sctope,
                                pn_tasa => vi_tea);
    END;

    BEGIN
      UPDATE AQPB556
      SET AQPB556TSAA   = vi_tea
      WHERE AQPB556INST = v_instancia
        AND AQPB556EMP  = v_Pgcod
        AND AQPB556MOD  = v_Scmod
        AND AQPB556SUC  = v_Scsuc
        AND AQPB556MDA  = v_Scmda
        AND AQPB556PAP  = v_Scpap
        AND AQPB556CTA  = v_Sccta
        AND AQPB556OPER = v_Scoper
        AND AQPB556SBOP = v_Scsbop
        AND AQPB556TOP = v_Sctope
        AND AQPB556COD = (
                           SELECT MAX(AQPB556COD)
                             FROM AQPB556
                            WHERE AQPB556INST = v_instancia
                              AND AQPB556EMP  = v_Pgcod
                              AND AQPB556MOD  = v_Scmod
                              AND AQPB556SUC  = v_Scsuc
                              AND AQPB556MDA  = v_Scmda
                              AND AQPB556PAP  = v_Scpap
                              AND AQPB556CTA  = v_Sccta
                              AND AQPB556OPER = v_Scoper
                              AND AQPB556SBOP = v_Scsbop
                              AND AQPB556TOP  = v_Sctope
                              AND AQPB556EHAB = 'H'
        )
        --AND AQPB556EST  = 'P'
        AND AQPB556EHAB = 'H'
        AND ROWNUM=1;
      END;

  end sp_grabartasa;

PROCEDURE sp_grabar_transac(ve_instancia in number,
                            ve_codigo in number,
                            ve_emp    in number,
                            ve_itmod  in number,
                            ve_itsuc  in number,
                            ve_ttran  in number,
                            ve_itnrel in number,
                            ve_fvc    in date,
                            ve_fcont  in date
                           ) is
BEGIN
          --ACTUALIZA LA TRANSACCION DEL INTERES EN LA AQPB556
          begin
            UPDATE AQPB556
            SET AQPB556TEMP = ve_emp,
                AQPB556TSUC  = ve_itsuc,
                AQPB556TMOD  = ve_itmod,
                AQPB556TTRAN = ve_ttran,
                AQPB556TNREL = ve_itnrel,
                AQPB556TFVC  = ve_fvc,
                AQPB556TFCON = ve_fcont
            WHERE AQPB556COD  = ve_codigo
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
          select MIN(D.EVCORR)-1
            INTO LN_EVCORR
            FROM FSD012 D
          WHERE  D.PGCOD = v_pgcod
            AND  D.AOMOD = v_scmod
            AND  D.AOSUC = v_scsuc
            AND  D.AOMDA = v_scmda
            AND  D.AOPAP = v_scpap
            AND  D.AOCTA = v_sccta
            AND  D.AOOPER= v_scoper
            AND  D.AOSBOP= v_scsbop
            AND  D.AOTOPE= v_sctope
            AND  D.D012FC= (SELECT PGFAPE FROM FST017 WHERE PGCOD=1 AND ROWNUM=1) --12/09/2020
            AND  D.D012MO= 98
            AND  D.D012TR= 579
            AND  D.EVTIPO= 3;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN --08.07.2021
        BEGIN
          select MAX(D.EVCORR)
            INTO LN_EVCORR
            FROM FSD012 D
          WHERE  D.PGCOD = v_pgcod
            AND  D.AOMOD = v_scmod
            AND  D.AOSUC = v_scsuc
            AND  D.AOMDA = v_scmda
            AND  D.AOPAP = v_scpap
            AND  D.AOCTA = v_sccta
            AND  D.AOOPER= v_scoper
            AND  D.AOSBOP= v_scsbop
            AND  D.AOTOPE= v_sctope
            and  D.evtipo = 3
            and  D.d012co = 'S';
        EXCEPTION WHEN OTHERS THEN
              LN_EVCORR := 0;
        END;

       WHEN OTHERS THEN
       BEGIN
        select MAX(D.EVCORR)
            INTO LN_EVCORR
            FROM FSD012 D
          WHERE  D.PGCOD = v_pgcod
            AND  D.AOMOD = v_scmod
            AND  D.AOSUC = v_scsuc
            AND  D.AOMDA = v_scmda
            AND  D.AOPAP = v_scpap
            AND  D.AOCTA = v_sccta
            AND  D.AOOPER= v_scoper
            AND  D.AOSBOP= v_scsbop
            AND  D.AOTOPE= v_sctope
            and  D.evtipo = 3
            and  D.d012co = 'S';
       EXCEPTION WHEN OTHERS THEN
              LN_EVCORR := 0;
       END;
    END;

    IF LN_EVCORR IS NULL THEN -- 08.07.2021 NO RECONOCE EL EXCEPTION SE FORZA LA CONSULTA. PARA OBTENER EL CORRELATIVO.
       BEGIN
          select MAX(D.EVCORR)
            INTO LN_EVCORR
            FROM FSD012 D
          WHERE  D.PGCOD = v_pgcod
            AND  D.AOMOD = v_scmod
            AND  D.AOSUC = v_scsuc
            AND  D.AOMDA = v_scmda
            AND  D.AOPAP = v_scpap
            AND  D.AOCTA = v_sccta
            AND  D.AOOPER= v_scoper
            AND  D.AOSBOP= v_scsbop
            AND  D.AOTOPE= v_sctope
            and  D.evtipo = 3
            and  D.d012co = 'S';
        EXCEPTION WHEN OTHERS THEN
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
PROCEDURE SP_OBTENER_MONTO(v_Pgcod  in number,
                           v_Scmod  in number,
                           v_Scsuc  in number,
                           v_Scmda  in number,
                           v_Scpap  in number,
                           v_Sccta  in number,
                           v_Scoper in number,
                           v_Scsbop in number,
                           v_Sctope in number,
                           vo_saldo out number,
                           vo_comision_fae out number,
                           vo_comision_reactiva out number) is
BEGIN
      vo_saldo := 0;
      BEGIN --CONSULTAR TABLA
        SELECT F.AQPA840DIFINT,F.AQPA840FCOMMONTO,F.AQPA840FCOMMONTO
        INTO vo_saldo,vo_comision_fae,vo_comision_reactiva
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
          AND F.AQPA840TIP = 4;   --TIPO DE REPROGRAMACION GOBIERNO
        -- caja
       EXCEPTION
         WHEN OTHERS THEN
           vo_saldo:=0;
        END;
  END;

  procedure sp_reprogramafondo(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             ln_tipo   out number,
                             lc_tipo_fondo out varchar
                             ) is
    ln_caja char(1);
    v_pgcod1  xwf700.xwfempresa%type;
    v_Scmod1  xwf700.xwfmodulo%type;
    v_Scsuc1  xwf700.xwfsucursal%type;
    v_Scmda1  xwf700.xwfmoneda%type;
    v_Scpap1  xwf700.xwfpapel%type;
    v_Sccta1  xwf700.xwfcuenta%type;
    v_Scoper1 xwf700.xwfoperacion%type;
    v_Scsbop1 xwf700.xwfsubope%type;
    v_Sctope1 xwf700.xwftipope%type;
    v_instancia xwf700.xwfprcins%type;

    --Retorna S si se encuentra habilitado
   Begin
      ln_tipo := 0;
        begin
             SELECT 'F',F.tipoprograma
             into ln_caja, lc_tipo_fondo
               --into ln_tasa
              FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
              WHERE F.IDFONDO = G.IDFONDO
              AND G.ESTADOSOLICITUD IN ('BT','AP','CE') --16.07.2021 se añadio 'CE'
               AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) = v_Sccta
               AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION, '-') + 1,99) = v_Scoper
               AND F.EMPRESA = v_pgcod
               AND F.SUCURSAL = v_Scsuc
               AND F.MODULO = v_Scmod
               AND F.MONEDA = v_Scmda
               AND F.PAPEL = v_Scpap
               AND F.SUBOPERACION = v_Scsbop
               AND F.TIPOOPERACION = v_Sctope;
         exception
           when no_data_found then
             begin
                SELECT 'F',F.tipoprograma
                  into ln_caja, lc_tipo_fondo         
                  FROM Turismo G, 
                       Turismo_CREDITOSFACILIDAD  F                 
                  WHERE F.idturismo = G.idturismo              
                   AND G.ESTADOSOLICITUD IN ('BT','AP','CE') --16.07.2021 se añadio 'CE'
                   AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) = v_Sccta
                   AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION, '-') + 1,99) = v_Scoper
                   AND F.EMPRESA = v_pgcod
                   AND F.SUCURSAL = v_Scsuc
                   AND F.MODULO = v_Scmod
                   AND F.MONEDA = v_Scmda
                   AND F.PAPEL = v_Scpap
                   AND F.SUBOPERACION = v_Scsbop
                   AND F.TIPOOPERACION = v_Sctope;
             exception
               when no_data_found then
              
                 BEGIN
                    select xwfprcins
                      into v_instancia
                      from xwf700 x
                     where x.xwfempresa = v_pgcod
                       and x.xwfsucursal = v_Scsuc
                       and x.xwfmodulo = v_Scmod
                       and x.xwfmoneda = v_Scmda
                       and x.xwfpapel = v_Scpap
                       and x.xwfcuenta = v_Sccta
                       and x.xwfoperacion = v_Scoper
                       and x.xwfsubope = v_Scsbop
                       and x.xwftipope = v_Sctope
                       and x.xwfcar3 = '1';
                 exception
                   when others then
                     v_instancia:=0;
                 END;
                 BEGIN
                       select
                       x.xwfempresa,x.xwfsucursal,x.xwfmodulo,x.xwfmoneda,x.xwfpapel,x.xwfcuenta,x.xwfoperacion,x.xwfsubope,x.xwftipope
                      into
                      v_pgcod1,v_Scsuc1,v_Scmod1,v_Scmda1,v_Scpap1,v_Sccta1,v_Scoper1,v_Scsbop1,v_Sctope1
                      from xwf700 x
                     where x.xwfprcins = v_instancia
                       and x.xwfcar3 = 'S';
                 exception
                   when others then
                       v_pgcod1:=0;
                       v_Scsuc1:=0;
                       v_Scmod1:=0;
                       v_Scmda1:=0;
                       v_Scpap1:=0;
                       v_Sccta1:=0;
                       v_Scoper1:=0;
                       v_Scsbop1:=0;
                       v_Sctope1:=0;
                   END;
                 BEGIN
                      SELECT 'F',F.tipoprograma
                       into ln_caja, lc_tipo_fondo
                         --into ln_tasa
                        FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
                        WHERE F.IDFONDO = G.IDFONDO
                        AND G.ESTADOSOLICITUD IN ('BT','AP','CE') --16.07.2021 se añadio 'CE'
                         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) = v_Sccta1
                         AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION, '-') + 1,99) = v_Scoper1
                         AND F.EMPRESA = v_pgcod1
                         AND F.SUCURSAL = v_Scsuc1
                         AND F.MODULO = v_Scmod1
                         AND F.MONEDA = v_Scmda1
                         AND F.PAPEL = v_Scpap1
                         AND F.SUBOPERACION = v_Scsbop1
                         AND F.TIPOOPERACION = v_Sctope1;
                 exception
                   when no_data_found then
                       begin
                        SELECT 'F',F.tipoprograma
                          into ln_caja, lc_tipo_fondo         
                          FROM Turismo G, 
                               Turismo_CREDITOSFACILIDAD  F                 
                          WHERE F.idturismo = G.idturismo              
                           AND G.ESTADOSOLICITUD IN ('BT','AP','CE') --16.07.2021 se añadio 'CE'
                           AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) = v_Sccta1
                           AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION, '-') + 1,99) = v_Scoper1
                           AND F.EMPRESA = v_pgcod1
                           AND F.SUCURSAL = v_Scsuc1
                           AND F.MODULO = v_Scmod1
                           AND F.MONEDA = v_Scmda1
                           AND F.PAPEL = v_Scpap1
                           AND F.SUBOPERACION = v_Scsbop1
                           AND F.TIPOOPERACION = v_Sctope1;
                     exception
                       when no_data_found then
                           ln_caja := ' ';
                           lc_tipo_fondo :='';
                     end;
                   
                   when others then
                     ln_caja := ' ';
                     lc_tipo_fondo :='';
                 end;
             end;
         when others then
           null;
         end;
      if ( ln_caja = 'F' ) then
        ln_tipo:=4;  --solo si devuelve 4      es reprogramado fonod Reactiva y FAE
      end if;
   end sp_reprogramafondo;
   PROCEDURE SP_CR_FONDOS_VTASA(
                              ve_instancia number,
                              vo_rpta out varchar
                            )
                            is
   vi_emp xwf700.xwfempresa%type;
   vi_suc xwf700.xwfsucursal%type;
   vi_mod xwf700.xwfmodulo%type;
   vi_mda xwf700.xwfmoneda%type;
   vi_pap xwf700.xwfpapel%type;
   vi_cta xwf700.xwfcuenta%type;
   vi_ope xwf700.xwfoperacion%type;
   vi_sbop xwf700.xwfsubope%type;
   vi_tope xwf700.xwftipope%type;
   vi_nuevaTasa number(10,6);
   ve_TpFndo varchar(10);
   VI_TASA number(10,6);
   VI_TEM number(10,6);

   VI_TASA_R NUMBER(10,6);
   VI_TASA_F NUMBER(10,6);

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
         FROM XWF700 X WHERE XWFPRCINS=ve_instancia AND XWFCAR3='1';
       EXCEPTION
         WHEN OTHERS THEN
           NULL;
    END;
    --OBTENER EL TIPO DE PROGRAMA
    BEGIN
       SELECT F.TIPOPROGRAMA,F.NUEVATASA
         INTO ve_TpFndo,vi_nuevaTasa
         FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
        WHERE F.IDFONDO = G.IDFONDO
         AND G.ESTADOSOLICITUD IN ('BT','AP')
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) = vi_cta
         AND SUBSTR(F.CUENTAOPERACION, INSTR(F.CUENTAOPERACION, '-') + 1,99) = vi_ope
         AND F.EMPRESA      = vi_emp
         AND F.SUCURSAL     = vi_suc
         AND F.MODULO       = vi_mod
         AND F.MONEDA       = vi_mda
         AND F.PAPEL        = vi_pap
         AND F.SUBOPERACION = vi_sbop
         AND F.TIPOOPERACION= vi_tope;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    --TASA ORIGINAL FSD010
    pq_cr_reprog_fondos_hs.sp_cr_tasa(
                                       vi_EMP,
                                       vi_mod,
                                       vi_suc,
                                       vi_mda,
                                       vi_pap,
                                       vi_cta,
                                       vi_ope,
                                       vi_sbop,
                                       vi_tope,
                                       vi_tasa
                                       );
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
        SELECT F.TP1IMP1,F.TP1IMP2
          INTO VI_TASA_R,VI_TASA_F
          FROM FST198 F
         WHERE F.TP1COD  = 1
           AND F.TP1COD1 = 10899
           AND F.TP1CORR1= 400000
           AND F.TP1CORR2= 22
           AND F.TP1CORR3= 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    vo_rpta:= 'N';
     IF ve_TpFndo = 'REACTIVA' THEN
        --VI_TEM:= VI_TASA + (VI_TASA*0.25)/100;
        VI_TEM:= VI_TASA + VI_TASA_R;--0.25;
        IF  VI_TEM >= vi_nuevaTasa and VI_TEM > VI_TASA and vi_nuevaTasa>VI_TASA THEN
            vo_rpta:= 'S';
        END IF;
     END IF;
     IF ve_TpFndo = 'FAE1' or ve_TpFndo = 'FAE2' THEN
        --VI_TEM:= VI_TASA + (VI_TASA*0.15)/100;
        VI_TEM:= VI_TASA + VI_TASA_F;--0.15;
        IF  VI_TEM >= vi_nuevaTasa and VI_TEM > VI_TASA and vi_nuevaTasa>VI_TASA THEN
            vo_rpta:= 'S';
        END IF;
     END IF;
END;
end pq_cr_reprog_fondos_hs;
/

