create or replace package pq_cr_carga_tasa_reg is

  -- Author  : HSUAREZ
  -- Created : 5/06/2021 21:17:32
  -- Purpose : Paquete para el proceso de cargar de interes moratorio en creditos penalidad
  -- Public type declarations
  ------------------------------------------------------------------------------------------
  -- Modif   : EFUENES
  --         : 16/03/2022
  --         : Creación del paquete sp_cr_update_mora_uno
  ------------------------------------------------------------------------------------------
  procedure sp_cr_update_mora_indv(ve_emp     in number,
                                   ve_mod     in number,
                                   ve_suc     in number,
                                   ve_mda     in number,
                                   ve_pap     in number,
                                   ve_cta     in number,
                                   ve_ope     in number,
                                   ve_sbo     in number,
                                   ve_top     in number,
                                   ve_feccarg in date);

  ------------------------------------------------------------------------------------------
  procedure sp_cr_update_mora_uno(ve_emp     in number,
                                  ve_mod     in number,
                                  ve_suc     in number,
                                  ve_mda     in number,
                                  ve_pap     in number,
                                  ve_cta     in number,
                                  ve_ope     in number,
                                  ve_sbo     in number,
                                  ve_top     in number,
                                  ve_feccarg in date);

  ------------------------------------------------------------------------------------------
  procedure sp_cr_update_mora_nominal_penalidad(p_emp200 in number,
                                                p_mod200 in number,
                                                p_suc200 in number,
                                                p_mda200 in number,
                                                p_pap200 in number,
                                                p_cta200 in number,
                                                p_ope200 in number,
                                                p_sbo200 in number,
                                                p_top200 in number,
                                                
                                                p_empNew in number,
                                                p_modNew in number,
                                                p_sucNew in number,
                                                p_mdaNew in number,
                                                p_papNew in number,
                                                p_ctaNew in number,
                                                p_opeNew in number,
                                                p_sboNew in number,
                                                p_topNew in number,
                                                
                                                ve_fecsys in date,
                                                pn_sis    in varchar2,
                                                PN_error  out varchar2);
end pq_cr_carga_tasa_reg;
/

create or replace package body pq_cr_carga_tasa_reg is
  -----------------------------------------------------
  procedure sp_cr_update_mora_indv(ve_emp     in number,
                                   ve_mod     in number,
                                   ve_suc     in number,
                                   ve_mda     in number,
                                   ve_pap     in number,
                                   ve_cta     in number,
                                   ve_ope     in number,
                                   ve_sbo     in number,
                                   ve_top     in number,
                                   ve_feccarg in date) is
    cursor lista_contable is
      SELECT *
        FROM AQPB300 A
       WHERE A.AQPB300COD = ve_emp
         AND A.AQPB300SUC = ve_suc
         AND A.AQPB300MOD = ve_mod
         AND A.AQPB300MDA = ve_mda
         AND A.AQPB300PAP = ve_pap
         AND A.AQPB300CTA = ve_cta
         AND A.AQPB300OPE = ve_ope
         AND A.AQPB300SBOP = ve_sbo
         AND A.AQPB300TOPE = ve_top
         AND A.AQPB300AUX1 = 1
         AND A.AQPB300FEC = ve_feccarg
         AND A.AQPB300GRUI NOT IN
             (SELECT F.TP1NRO1
                FROM FST198 F
               WHERE TP1COD = 1
                 AND TP1COD1 = 10899
                 AND TP1CORR1 = 1500
                 AND TP1CORR2 = 1
                 AND TP1CORR3 > 0);
  
    vi_validar_tipo varchar(1);
    vo_rpta         varchar(1);
    vo_ind          varchar(1);
    vo_tas          number(10, 6);
    vo_corr         number;
    vo_fvto         date;
    vo_tipo_tasa    x054021.xllotexto%type;
    vo_fecha_car    x054021.xllotxtfch%type;
  BEGIN
    BEGIN
      NULL;
      FOR j in lista_contable LOOP
      
        vo_rpta := 'N';
        PQ_CR_CARGA_INTMOR.SP_CR_VAL_CRD_X054021(j.aqpb300cod,
                                                 j.aqpb300mod,
                                                 j.aqpb300suc,
                                                 j.aqpb300mda,
                                                 j.aqpb300pap,
                                                 j.aqpb300cta,
                                                 j.aqpb300ope,
                                                 j.aqpb300sbop,
                                                 j.aqpb300tope,
                                                 vo_rpta,
                                                 vo_tipo_tasa,
                                                 vo_fecha_car);
        -- INVOCAR PROCESO PARA INSERTAR DATA EN LA TABLA FSD012 EN CASOS SE CUMPLAN TODAS LA CONDICIONS.
        vo_ind := 'N';
        IF vo_rpta = 'S' THEN
          begin
          
            pq_cr_tasa_moratoria.sp_cr_actualiza_tasa(ve_cta  => j.aqpb300cta,
                                                      ve_ope  => j.aqpb300ope,
                                                      ve_emp  => j.aqpb300cod,
                                                      ve_mod  => j.aqpb300mod,
                                                      ve_suc  => j.aqpb300suc,
                                                      ve_mda  => j.aqpb300mda,
                                                      ve_pap  => j.aqpb300pap,
                                                      ve_sbo  => j.aqpb300sbop,
                                                      ve_top  => j.aqpb300tope,
                                                      vo_ind  => vo_ind,
                                                      vo_tas  => vo_tas,
                                                      vo_corr => vo_corr,
                                                      vo_fvto => vo_fvto);
          end;
        
          -- ACTUALIZAR ESTADO DE LA TABLA EN CASO DE HABER CUMPLIDO TODAS LAS CONDICIONES. 
          IF vo_ind = 'S' THEN
            BEGIN
              UPDATE AQPB300 A
                 SET A.AQPB300EST   = vo_ind,
                     A.AQPB300TASAI = vo_tas,
                     A.AQPB300CORRI = vo_corr,
                     A.AQPB300FVTOI = vo_fvto
               WHERE A.AQPB300COD = J.AQPB300COD
                 AND A.AQPB300SUC = J.AQPB300SUC
                 AND A.AQPB300MOD = J.AQPB300MOD
                 AND A.AQPB300MDA = J.AQPB300MDA
                 AND A.AQPB300PAP = J.AQPB300PAP
                 AND A.AQPB300CTA = J.AQPB300CTA
                 AND A.AQPB300OPE = J.AQPB300OPE
                 AND A.AQPB300SBOP = J.AQPB300SBOP
                 AND A.AQPB300TOPE = J.AQPB300TOPE
                 AND A.AQPB300FEC = J.AQPB300FEC;
              ------------------------------------- 
              -- SI EL PROCESO QUE ACTUALIZA LA FSD012 ES CONFORME (S) ENTONCES 
              --ACTUALIZA LOGS DE CAMPO ANTES DE APLICAR EL UPDATE.   
              PQ_CR_CARGA_INTMOR.SP_CR_SLOGS_X054021(J.AQPB300COD,
                                                     J.AQPB300MOD,
                                                     J.AQPB300SUC,
                                                     J.AQPB300MDA,
                                                     J.AQPB300PAP,
                                                     J.AQPB300CTA,
                                                     J.AQPB300OPE,
                                                     J.AQPB300SBOP,
                                                     J.AQPB300TOPE,
                                                     vo_tipo_tasa,
                                                     vo_fecha_car);
              -------------------------------------
              -- ACTUALIZA LA X054021
              -------------------------------------                             
              UPDATE X054021 x
                 SET x.xllotexto = 'I'
               WHERE x.pgcod = J.AQPB300COD
                 AND x.xlloaomod = J.AQPB300MOD
                 AND x.xlloaosuc = J.AQPB300SUC
                 AND x.xlloaomda = J.AQPB300MDA
                 AND x.xlloaopap = J.AQPB300PAP
                 AND x.xlloaocta = J.AQPB300CTA
                 AND x.xlloaooper = J.AQPB300OPE
                 AND x.xlloaosbop = J.AQPB300SBOP
                 AND x.xlloaotope = J.AQPB300TOPE
                 AND x.xllotxtcod = 250
                 AND x.xllotexto = 'P';
              COMMIT;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
          END IF;
        END IF;
        --END IF;    
      END LOOP;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END sp_cr_update_mora_indv;

  -----------------------------------------------------
  procedure sp_cr_update_mora_uno(ve_emp     in number,
                                  ve_mod     in number,
                                  ve_suc     in number,
                                  ve_mda     in number,
                                  ve_pap     in number,
                                  ve_cta     in number,
                                  ve_ope     in number,
                                  ve_sbo     in number,
                                  ve_top     in number,
                                  ve_feccarg in date) is
    vi_validar_tipo varchar(1);
    vo_rpta         varchar(1);
    vo_ind          varchar(1);
    vo_tas          number(10, 6);
    vo_corr         number;
    vo_fvto         date;
    vo_tipo_tasa    x054021.xllotexto%type;
    vo_fecha_car    x054021.xllotxtfch%type;
    vo_fecmax       date;
  BEGIN
    --maxima fecha
    BEGIN
      select max(A.AQPB300FEC)
        into vo_fecmax
        from AQPB300 A
       WHERE A.AQPB300COD = ve_emp
         AND A.AQPB300SUC = ve_suc
         AND A.AQPB300MOD = ve_mod
         AND A.AQPB300MDA = ve_mda
         AND A.AQPB300PAP = ve_pap
         AND A.AQPB300CTA = ve_cta
         AND A.AQPB300OPE = ve_ope
         AND A.AQPB300SBOP = ve_sbo
         AND A.AQPB300TOPE = ve_top;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      vo_rpta := 'N';
      PQ_CR_CARGA_INTMOR.SP_CR_VAL_CRD_X054021(ve_emp, --aqpb300cod,
                                               ve_mod, --aqpb300mod,
                                               ve_suc, --aqpb300suc,
                                               ve_mda, --aqpb300mda,
                                               ve_pap, --aqpb300pap,
                                               ve_cta, --aqpb300cta,
                                               ve_ope, --aqpb300ope,
                                               ve_sbo, --aqpb300sbop,
                                               ve_top, --aqpb300tope,
                                               vo_rpta,
                                               vo_tipo_tasa,
                                               vo_fecha_car);
      -- INVOCAR PROCESO PARA INSERTAR DATA EN LA TABLA FSD012 EN CASOS SE CUMPLAN TODAS LA CONDICIONS.
      vo_ind := 'N';
      IF vo_rpta = 'S' THEN
        begin
          pq_cr_tasa_moratoria.sp_cr_actualiza_tasa(ve_cta  => ve_cta, --j.aqpb300cta,
                                                    ve_ope  => ve_ope, --j.aqpb300ope,
                                                    ve_emp  => ve_emp, --j.aqpb300cod,
                                                    ve_mod  => ve_mod, --j.aqpb300mod,
                                                    ve_suc  => ve_suc, --j.aqpb300suc,
                                                    ve_mda  => ve_mda, --j.aqpb300mda,
                                                    ve_pap  => ve_pap, --j.aqpb300pap,
                                                    ve_sbo  => ve_sbo, --j.aqpb300sbop,
                                                    ve_top  => ve_top, --j.aqpb300tope,
                                                    vo_ind  => vo_ind,
                                                    vo_tas  => vo_tas,
                                                    vo_corr => vo_corr,
                                                    vo_fvto => vo_fvto);
        end;
        -- ACTUALIZAR ESTADO DE LA TABLA EN CASO DE HABER CUMPLIDO TODAS LAS CONDICIONES. 
        IF vo_ind = 'S' THEN
          BEGIN
            UPDATE AQPB300 A
               SET A.AQPB300EST   = vo_ind,
                   A.AQPB300TASAI = vo_tas,
                   A.AQPB300CORRI = vo_corr,
                   A.AQPB300FVTOI = vo_fvto
             WHERE A.AQPB300COD = ve_emp --J.AQPB300COD
               AND A.AQPB300SUC = ve_suc --J.AQPB300SUC
               AND A.AQPB300MOD = ve_mod --J.AQPB300MOD
               AND A.AQPB300MDA = ve_mda --J.AQPB300MDA
               AND A.AQPB300PAP = ve_pap --J.AQPB300PAP
               AND A.AQPB300CTA = ve_cta --J.AQPB300CTA
               AND A.AQPB300OPE = ve_ope --J.AQPB300OPE
               AND A.AQPB300SBOP = ve_sbo --J.AQPB300SBOP
               AND A.AQPB300TOPE = ve_top --J.AQPB300TOPE
               AND A.AQPB300FEC = vo_fecmax; --J.AQPB300FEC; maxima fecha de la clave del credito 
            ------------------------------------- 
            -- SI EL PROCESO QUE ACTUALIZA LA FSD012 ES CONFORME (S) ENTONCES 
            --ACTUALIZA LOGS DE CAMPO ANTES DE APLICAR EL UPDATE.
            PQ_CR_CARGA_INTMOR.SP_CR_SLOGS_X054021(ve_emp, --J.AQPB300COD,
                                                   ve_mod, --J.AQPB300MOD,
                                                   ve_suc, --J.AQPB300SUC,
                                                   ve_mda, --J.AQPB300MDA,
                                                   ve_pap, --J.AQPB300PAP,
                                                   ve_cta, --J.AQPB300CTA,
                                                   ve_ope, --J.AQPB300OPE,
                                                   ve_sbo, --J.AQPB300SBOP,
                                                   ve_top, --J.AQPB300TOPE,
                                                   vo_tipo_tasa,
                                                   vo_fecha_car);
            -------------------------------------
            -- ACTUALIZA LA X054021
            ------------------------------------- 
            UPDATE X054021 x
               SET x.xllotexto = 'I'
             WHERE x.pgcod = ve_emp --J.AQPB300COD
               AND x.xlloaomod = ve_mod --J.AQPB300MOD
               AND x.xlloaosuc = ve_suc --J.AQPB300SUC
               AND x.xlloaomda = ve_mda --J.AQPB300MDA
               AND x.xlloaopap = ve_pap --J.AQPB300PAP
               AND x.xlloaocta = ve_cta --J.AQPB300CTA
               AND x.xlloaooper = ve_ope --J.AQPB300OPE
               AND x.xlloaosbop = ve_sbo --J.AQPB300SBOP
               AND x.xlloaotope = ve_top --J.AQPB300TOPE
               AND x.xllotxtcod = 250
               AND x.xllotexto = 'P';
            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END sp_cr_update_mora_uno;

  -----------------------------------------------------
  procedure sp_cr_update_mora_nominal_penalidad(p_emp200 in number,
                                                p_mod200 in number,
                                                p_suc200 in number,
                                                p_mda200 in number,
                                                p_pap200 in number,
                                                p_cta200 in number,
                                                p_ope200 in number,
                                                p_sbo200 in number,
                                                p_top200 in number,
                                                
                                                p_empNew in number,
                                                p_modNew in number,
                                                p_sucNew in number,
                                                p_mdaNew in number,
                                                p_papNew in number,
                                                p_ctaNew in number,
                                                p_opeNew in number,
                                                p_sboNew in number,
                                                p_topNew in number,
                                                
                                                ve_fecsys in date,
                                                pn_sis    in varchar2,
                                                PN_error  out varchar2) is
  
    l_empOri number;
    l_modOri number;
    l_sucOri number;
    l_mdaOri number;
    l_papOri number;
    l_ctaOri number;
    l_opeOri number;
    l_sboOri number;
    l_topOri number;
  
  BEGIN
    --clave del credito origen
    begin
      select r.r1cod,
             r.r1mod,
             r.r1suc,
             r.r1mda,
             r.r1pap,
             r.r1cta,
             r.r1oper,
             r.r1sbop,
             r.r1tope
        into l_empOri,
             l_modOri,
             l_sucOri,
             l_mdaOri,
             l_papOri,
             l_ctaOri,
             l_opeOri,
             l_sboOri,
             l_topOri
        from fsr011 r
       where r.relcod = 52
         and r.r2cod = p_emp200
         and r.r2mod = p_mod200
         and r.r2suc = p_suc200
         and r.r2mda = p_mda200
         and r.r2pap = p_pap200
         and r.r2cta = p_cta200
         and r.r2oper = p_ope200
         and r.r2sbop = p_sbo200
         and r.r2tope = p_top200;
    exception
      when others then
        null;
    end;
    
--    insert into prueba_log
--    (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
--     ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA)
    /*
    insert into prueba_log
    (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,MSG, FECHA) values
    (l_empOri,l_modOri,l_sucOri,l_mdaOri,l_papOri,l_ctaOri,l_opeOri,l_sboOri,l_topOri,'prb 1 - ori ef', null);
    
    insert into prueba_log
    (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,MSG, FECHA) values
    (p_emp200,p_mod200,p_suc200,p_mda200,p_pap200,p_cta200,p_ope200,p_sbo200,p_top200,'prb 1 - 000 ef', null);
    
    insert into prueba_log
    (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,MSG, FECHA) values
    (p_empNew,p_modNew,p_sucNew,p_mdaNew,p_papNew,p_ctaNew,p_opeNew,p_sboNew,p_topNew,'prb 1 - 001 ef', ve_fecsys);
    */
  
    BEGIN
      --maxima fecha de la aqpa300 se obtiene en ese procedimiento 
      sp_cr_update_mora_uno(l_empOri,--ve_emp,
                            l_modOri,--ve_mod,
                            l_sucOri,--ve_suc,
                            l_mdaOri,--ve_mda,
                            l_papOri,--ve_pap,
                            l_ctaOri,--ve_cta,
                            l_opeOri,--ve_ope,
                            l_sboOri,--ve_sbo,
                            l_topOri,--ve_top,
                            ve_fecsys);
    
      PQ_CR_MORA_NOMINAL_LINEAL.sp_cr_tasmor_cre_v2(l_empOri,--ve_emp,
                                                    l_modOri,--ve_mod,
                                                    l_sucOri,--ve_suc,
                                                    l_mdaOri,--ve_mda,
                                                    l_papOri,--ve_pap,
                                                    l_ctaOri,--ve_cta,
                                                    l_opeOri,--ve_ope,
                                                    l_sboOri,--ve_sbo,
                                                    l_topOri,--ve_top,
                                                    
                                                    p_empNew,
                                                    p_modNew,
                                                    p_sucNew,
                                                    p_mdaNew,
                                                    p_papNew,
                                                    p_ctaNew,
                                                    p_opeNew,
                                                    p_sboNew,
                                                    p_topNew,
                                                    
                                                    ve_fecsys,
                                                    pn_sis,
                                                    PN_error);
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END sp_cr_update_mora_nominal_penalidad;

end pq_cr_carga_tasa_reg;
/

