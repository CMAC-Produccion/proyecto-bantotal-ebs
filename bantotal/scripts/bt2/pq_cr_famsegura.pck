create or replace package PQ_CR_FAMSEGURA is

  -- *****************************************************************
  -- Nombre                     : PQ_CR_FAMSEGURA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2016.05.16
  -- Autor de Creación          : AERNEDO / DCASTRO
  -- Uso                        : OBTENER PAGOS DE CREDITOS CON SEGURO VIDA CAJA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- *****************************************************************

  ----------------------------------------------------------------
  Procedure Sp_carga(pd_fecini in date, pd_fecpro in date);
  ----------------------------------------------------------------

  ---------------
  Procedure Sp_monto_calendarioVC(pn_emp      in number,
                                  pn_mod      in number,
                                  pn_suc      in number,
                                  pn_mda      in number,
                                  pn_pap      in number,
                                  pn_cta      in number,
                                  pn_ope      in number,
                                  pn_sbo      in number,
                                  pn_top      in number,
                                  pn_tip      in number,
                                  pd_fecini   in date,
                                  pd_fecpro   in date,
                                  ln_mtoprima out number,
                                  lc_tip      out char);

  ---------------

  Procedure Sp_monto_calendarioVCC(pn_emp      in number,
                                   pn_mod      in number,
                                   pn_suc      in number,
                                   pn_mda      in number,
                                   pn_pap      in number,
                                   pn_cta      in number,
                                   pn_ope      in number,
                                   pn_sbo      in number,
                                   pn_top      in number,
                                   pn_tip      in number,
                                   pd_fecpro   in date,
                                   ln_mtoprima out number,
                                   ln_codVar   out number,
                                   lc_tip      out char);
  -----------------------------------------------------------------------------
  Procedure Sp_carga_VC(P_C_DIGITO in varchar2,
                        pd_fecini  in date,
                        pd_fecpro  in date);
  ---------------
  ----------------------------------------------------------------
  procedure sp_cr_validapago(ln_pgcod in number,

                             ln_modulo    in number,
                             ln_sucursal  in number,
                             ln_moneda    in number,
                             ln_papel     in number,
                             ln_cuenta    in number,
                             ln_operacion in number,
                             ln_suboper   in number,
                             ln_tope      in number,
                             ld_fechpag   in date,
                             ld_pd_fecini in date,
                             ld_pd_fecfin in date,
                             ln_codvar    in number,
                             ln_monto     in out number,
                             lc_indica    in varchar2,
                             ln_numcuo    in number);
  --------------------------------------------------------------------------------------------
  procedure sp_cr_inserta(ln_pgcod     in number,
                          ln_modulo    in number,
                          ln_sucursal  in number,
                          ln_moneda    in number,
                          ln_papel     in number,
                          ln_cuenta    in number,
                          ln_operacion in number,
                          ln_suboper   in number,
                          ln_tope      in number,
                          ld_fechcuo   in date,
                          ld_fchpago   in date,
                          ln_imp       in number,
                          ln_imp1      in number,
                          ln_imp2      in number,
                          ln_imp3      in number,
                          ln_imp4      in number,
                          ln_imp5      in number,
                          lc_indicador in varchar2);
  ---------------
  procedure sp_cr_cargaVC_job(pd_fecini IN date, pd_fecpro IN date);
  ---------------
  Procedure Sp_cronograma(pn_emp    in number,
                          pn_mod    in number,
                          pn_suc    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number,
                          pn_ope    in number,
                          pn_sbo    in number,
                          pn_top    in number,
                          pn_tip    in number,
                          pd_fecini in date,
                          pd_fecfin in date,
                          pd_fecpro in date,
                          pn_mto11  out number,
                          pn_mto12  out number,
                          pn_mto13  out number,
                          pn_mto14  out number,
                          pn_mto15  out number);
  ---------------
  Procedure Sp_cr_gracia(pn_emp    in number,
                         pn_mod    in number,
                         pn_suc    in number,
                         pn_mda    in number,
                         pn_pap    in number,
                         pn_cta    in number,
                         pn_ope    in number,
                         pn_sbo    in number,
                         pn_top    in number,
                         pd_fecini in date,
                         pd_fecfin in date,
                         pn_numcuo out number);
  ---------------
  Procedure Sp_monto_calendarioSVC(pn_emp      in number,
                                   pn_mod      in number,
                                   pn_suc      in number,
                                   pn_mda      in number,
                                   pn_pap      in number,
                                   pn_cta      in number,
                                   pn_ope      in number,
                                   pn_sbo      in number,
                                   pn_top      in number,
                                   pn_tip      in number,
                                   pd_fecpro   in date,
                                   ln_mtoprima out number,
                                   ln_codVar   out number,
                                   lc_tip      out char);
  ---------------
  procedure sp_cr_listado(pd_fecini in date, pd_fecfin in date);
  -------------------------------------------------------------------

  procedure sp_cr_insertjaqy145(ln_pgcod     in number,
                                ln_modulo    in number,
                                ln_sucursal  in number,
                                ln_moneda    in number,
                                ln_papel     in number,
                                ln_cuenta    in number,
                                ln_operacion in number,
                                ln_suboper   in number,
                                ln_tope      in number,
                                ld_fchcuo    in date,
                                ld_fechpag   in date,
                                ln_monto     in number,
                                ln_imp1      in number,
                                ln_imp2      in number,
                                ln_imp3      in number,
                                ln_imp4      in number,
                                ln_imp5      in number);

  ----------------------------------------------------------------------
  procedure sp_cr_cliente(ln_pgcod     in number,
                          ln_modulo    in number,
                          ln_sucursal  in number,
                          ln_moneda    in number,
                          ln_papel     in number,
                          ln_cuenta    in number,
                          ln_operacion in number,
                          ln_suboper   in number,
                          ln_tope      in number);
  -----------------------------------------------------------------------
  procedure sp_cr_datoscli(P_N_INI in number, P_N_FIN in number);
  --------------------------------------------------------------
  procedure sp_cr_jobcliente;
  -----------------------------------------------------------------
  procedure sp_cr_jobjaqy145(pd_fecini in date, pd_fecfin in date);
  -------------------------------------------------------------------
  procedure sp_cr_llenardatosI(pd_fecini in date, pd_fecfin in date);
  ----------------------------------------------------------------------
  procedure sp_cr_llenardatosII;
  -------------------------------------------------------------------------
  procedure sp_cr_listadoII(pd_fecini in date,
                            pd_fecfin in date,
                            P_N_INI   in number,
                            P_N_FIN   in number);
  --------------------------------------------------------------------------
  PROCEDURE sp_cr_listado_SINVC(pd_fecini in date, pd_fecfin in date);
  ----------------------------------------------------------------------------------------------
  procedure sp_cr_listadoIII(pd_fecini in date, pd_fecfin in date);
  ----------------------------------------------------------------------------
  procedure sp_cr_llenardatosSV(pd_fecini in date, pd_fecfin in date);
  ----------------------------------------------------------------------------
  FUNCTION fn_mg_verifica_tarea(pi_vc2_nomjob IN VARCHAR2,
                                pi_vc2_nomusr IN VARCHAR2) RETURN NUMBER;
  --------------------------------------------------------------------------

end PQ_CR_FAMSEGURA;
/

create or replace package body PQ_CR_FAMSEGURA is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_FAMSEGURA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2016.07.19
  -- Autor de Creación          : ABERNEDO / DCASTRO / MPOSTIGO
  -- Uso                        : OBTENER PAGOS DE CREDITOS CON SEGURO VIDA CAJA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2016.06.22
  -- Autor de la Modificación   : DCASTRO
  -- Descripción de Modificación: Se modifico sp_monto_calendarioVC , sp_monto_calendarioVCC , Sp_cronograma
  -- Fecha de Modificación      : 2020.04.10
  -- Autor de la Modificación   : DCASTRO
  -- Descripción de Modificación: Se modifico sp_monto_calendarioVC , sp_monto_calendarioVCC , Sp_cronograma
  -- *****************************************************************

  Procedure Sp_carga(pd_fecini in date, pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : Sp_carga
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.05.16
    -- Autor de Creación          : DCASTRO
    -- Uso                        : CARGA CREDITOS CON SEGURO AFILIADO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************

    ld_fecini date;
  begin

    Execute immediate ('truncate table jaqz085_aux');

    ld_fecini := pd_fecini; --to_date('01' || to_char(pd_fecpro, 'mmyyyy'), 'ddmmyyyy');
    begin
      insert into jaqz085_aux
        (JAQZ085EMP,
         JAQZ085MOD,
         JAQZ085SUC,
         JAQZ085MDA,
         JAQZ085PAP,
         JAQZ085CTA,
         JAQZ085OPE,
         JAQZ085SBO,
         JAQZ085TOP,
         JAQZ085FEC,
         JAQZ085FVAL, --/*,JAQZ085MPA*/ /*,JAQZ085FPA*/)
         jaqz085seg) 
        select g.pgcod,
               g.aomod,
               g.aosuc,
               g.aomda,
               g.aopap,
               g.aocta,
               g.aooper,
               g.aosbop,
               g.aotope,
               pd_fecpro,
               g.aofval,
               h.sgcod
          from fsd010 g, fpp001 h
         where g.pgcod = 1
           and h.pgcod = g.pgcod
           and h.aocta = g.aocta
           and h.aooper = g.aooper
           and h.aocta <> 999999999
           and g.aomod in (select modulo
                             from fst111
                            where dscod = 50
                              and modulo not in (200, 33))
           and ((g.aostat = 99 and g.aofe99 >= ld_fecini /*and g.aofe99 <= pd_fecpro*/
               ) /*to_date('2015.10.01', 'yyyy.mm.dd')*/
               or g.aofe99 = to_Date('01.01.0001', 'dd.mm.yyyy'))
           and (h.sgcod in (200, 201, 202) or h.sgcod in( select tp1nro3
                                                            from fst198 a
                                                           Where Tp1cod   = 1
                                                             and Tp1cod1  = 10898
                                                             and Tp1corr1 = 18
                                                             and tp1corr3 = 2
                                                             and tp1nro1 = 1))
         group by g.pgcod,
                  g.aomod,
                  g.aosuc,
                  g.aomda,
                  g.aopap,
                  g.aocta,
                  g.aooper,
                  g.aosbop,
                  g.aotope,
                  pd_fecpro,
                  g.aofval,
                  h.sgcod;

      commit;
    end;

  end Sp_carga;

  ---------------
  Procedure Sp_monto_calendarioVC(pn_emp      in number,
                                  pn_mod      in number,
                                  pn_suc      in number,
                                  pn_mda      in number,
                                  pn_pap      in number,
                                  pn_cta      in number,
                                  pn_ope      in number,
                                  pn_sbo      in number,
                                  pn_top      in number,
                                  pn_tip      in number,
                                  pd_fecini   in date,
                                  pd_fecpro   in date,
                                  ln_mtoprima out number,
                                  lc_tip      out char) is

    -- *****************************************************************
    -- Nombre                     : Sp_monto_calendarioVC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.05.16
    -- Autor de Creación          : DCASTRO
    -- Uso                        : VALIDA MONTO CALENDARIO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2016.06.22
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se agrego llamada a sp_cronograma y busqueda para pagos realizados en mes de desembolso.
    --
    -- *****************************************************************

    cursor seguros is
      select sgcod tp1nro1
        from fst300 where (sgcod in (200, 201, 202)or sgcod in( select tp1nro3
                                                                  from fst198 a
                                                                 Where Tp1cod   = 1
                                                                   and Tp1cod1  = 10898
                                                                   and Tp1corr1 = 18
                                                                   and tp1corr3 = 2
                                                                   and tp1nro1 = 1));

    cursor seguros_ii is
      select *
        from fpp001 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;
--         and a.pp001imp <> 0;

    cursor calendario_vida is
      select *
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top

      ;

    ln_canSeg number(2);
    ln_codVar number(2);
    ld_fecan  date;

    ld_fecini date;

    --ln_mtoprima number(17,2) ;
    ln_mto11 number(17, 2);
    ln_mto12 number(17, 2);
    ln_mto13 number(17, 2);
    ln_mto14 number(17, 2);
    ln_mto15 number(17, 2);

    lc_flag   char(1);
    ln_impAux number(17, 2);

    lc_flag11   char(1);
    ln_impAux11 number(17, 2);

    lc_flag13   char(1);
    ln_impAux13 number(17, 2);

    ld_pago date;
    --lc_tip char(1);
    ln_mtoseg number(17, 2);
    ld_fecnew date;

    ld_fecfin date; --2016.06.21
    ln_numcuo number := 0;
    ln_numseg number := 0;

  begin

    --ld_fecini := pd_fecini;--to_date('01' || to_char(pd_fecpro, 'mmyyyy'), 'ddmmyyyy');
    ld_fecini := to_date('01' || to_char(pd_fecpro, 'mmyyyy'), 'ddmmyyyy');
    lc_tip    := null;

    begin

      for i in seguros loop
        ln_canSeg := 0;
        ln_codVar := 0;
        for j in seguros_ii loop
          ln_canSeg := ln_canSeg + 1;
          if i.tp1nro1 = j.SgCod then
            ln_codVar := ln_canSeg;
            ln_mtoseg := j.pp001imp;
            exit;
          end if;
        end loop;

        if ln_codVar <> 0 then

          begin

            begin
              PQ_CR_FAMSEGURA.sp_cronograma(pn_emp    => pn_emp,
                                            pn_mod    => pn_mod,
                                            pn_suc    => pn_suc,
                                            pn_mda    => pn_mda,
                                            pn_pap    => pn_pap,
                                            pn_cta    => pn_cta,
                                            pn_ope    => pn_ope,
                                            pn_sbo    => pn_sbo,
                                            pn_top    => pn_top,
                                            pn_tip    => pn_tip,
                                            pd_fecini => ld_fecini,
                                            pd_fecfin => pd_fecpro,
                                            pd_fecpro => pd_fecpro,
                                            pn_mto11  => ln_mto11,
                                            pn_mto12  => ln_mto12,
                                            pn_mto13  => ln_mto13,
                                            pn_mto14  => ln_mto14,
                                            pn_mto15  => ln_mto15);
            end;
            --   when no_data_found then
            ld_fecnew := add_months(ld_fecini, -1); -- para menos de un mes

            ln_mto11 := nvl(ln_mto11, 0);
            ln_mto12 := nvl(ln_mto12, 0);
            ln_mto13 := nvl(ln_mto13, 0);
            ln_mto14 := nvl(ln_mto14, 0);
            ln_mto15 := nvl(ln_mto15, 0);

            if ln_mto11 = 0 and ln_mto12 = 0 and ln_mto13 = 0 and
               ln_mto14 = 0 and ln_mto15 = 0 then

              begin
                PQ_CR_FAMSEGURA.sp_cronograma(pn_emp    => pn_emp,
                                              pn_mod    => pn_mod,
                                              pn_suc    => pn_suc,
                                              pn_mda    => pn_mda,
                                              pn_pap    => pn_pap,
                                              pn_cta    => pn_cta,
                                              pn_ope    => pn_ope,
                                              pn_sbo    => pn_sbo,
                                              pn_top    => pn_top,
                                              pn_tip    => pn_tip,
                                              pd_fecini => ld_fecnew,
                                              pd_fecfin => pd_fecpro,
                                              pd_fecpro => pd_fecpro,
                                              pn_mto11  => ln_mto11,
                                              pn_mto12  => ln_mto12,
                                              pn_mto13  => ln_mto13,
                                              pn_mto14  => ln_mto14,
                                              pn_mto15  => ln_mto15);
              end;

              ln_mto11 := nvl(ln_mto11, 0);
              ln_mto12 := nvl(ln_mto12, 0);
              ln_mto13 := nvl(ln_mto13, 0);
              ln_mto14 := nvl(ln_mto14, 0);
              ln_mto15 := nvl(ln_mto15, 0);

              if ln_mto11 = 0 and ln_mto12 = 0 and ln_mto13 = 0 and
                 ln_mto14 = 0 and ln_mto15 = 0 then

                ld_fecnew := add_months(ld_fecini, -2); -- para menos de 2 meses

                begin
                  PQ_CR_FAMSEGURA.sp_cronograma(pn_emp    => pn_emp,
                                                pn_mod    => pn_mod,
                                                pn_suc    => pn_suc,
                                                pn_mda    => pn_mda,
                                                pn_pap    => pn_pap,
                                                pn_cta    => pn_cta,
                                                pn_ope    => pn_ope,
                                                pn_sbo    => pn_sbo,
                                                pn_top    => pn_top,
                                                pn_tip    => pn_tip,
                                                pd_fecini => ld_fecnew,
                                                pd_fecfin => pd_fecpro,
                                                pd_fecpro => pd_fecpro,
                                                pn_mto11  => ln_mto11,
                                                pn_mto12  => ln_mto12,
                                                pn_mto13  => ln_mto13,
                                                pn_mto14  => ln_mto14,
                                                pn_mto15  => ln_mto15);
                end;

                --2016.06.21
                ln_mto11 := nvl(ln_mto11, 0);
                ln_mto12 := nvl(ln_mto12, 0);
                ln_mto13 := nvl(ln_mto13, 0);
                ln_mto14 := nvl(ln_mto14, 0);
                ln_mto15 := nvl(ln_mto15, 0);

                if ln_mto11 = 0 and ln_mto12 = 0 and ln_mto13 = 0 and
                   ln_mto14 = 0 and ln_mto15 = 0 then

                  ld_fecfin := add_months(pd_fecpro, 1); -- Se agrega un mes a fecha de proces, puede ser cuota adelantada

                  begin
                    PQ_CR_FAMSEGURA.sp_cronograma(pn_emp    => pn_emp,
                                                  pn_mod    => pn_mod,
                                                  pn_suc    => pn_suc,
                                                  pn_mda    => pn_mda,
                                                  pn_pap    => pn_pap,
                                                  pn_cta    => pn_cta,
                                                  pn_ope    => pn_ope,
                                                  pn_sbo    => pn_sbo,
                                                  pn_top    => pn_top,
                                                  pn_tip    => pn_tip,
                                                  pd_fecini => ld_fecini,
                                                  pd_fecfin => ld_fecfin,
                                                  pd_fecpro => pd_fecpro,
                                                  pn_mto11  => ln_mto11,
                                                  pn_mto12  => ln_mto12,
                                                  pn_mto13  => ln_mto13,
                                                  pn_mto14  => ln_mto14,
                                                  pn_mto15  => ln_mto15);
                  end;
                end if;

                ln_mto11 := nvl(ln_mto11, 0);
                ln_mto12 := nvl(ln_mto12, 0);
                ln_mto13 := nvl(ln_mto13, 0);
                ln_mto14 := nvl(ln_mto14, 0);
                ln_mto15 := nvl(ln_mto15, 0);

                if ln_mto11 = 0 and ln_mto12 = 0 and ln_mto13 = 0 and
                   ln_mto14 = 0 and ln_mto15 = 0 then

                  ld_fecfin := add_months(pd_fecpro, 2); -- Se agrega dos meses a fecha de proces, puede ser cuota adelantada

                  begin
                    PQ_CR_FAMSEGURA.sp_cronograma(pn_emp    => pn_emp,
                                                 pn_mod    => pn_mod,
                                                 pn_suc    => pn_suc,
                                                 pn_mda    => pn_mda,
                                                 pn_pap    => pn_pap,
                                                 pn_cta    => pn_cta,
                                                 pn_ope    => pn_ope,
                                                 pn_sbo    => pn_sbo,
                                                 pn_top    => pn_top,
                                                 pn_tip    => pn_tip,
                                                 pd_fecini => ld_fecini,
                                                 pd_fecfin => ld_fecfin,
                                                 pd_fecpro => pd_fecpro,
                                                 pn_mto11  => ln_mto11,
                                                 pn_mto12  => ln_mto12,
                                                 pn_mto13  => ln_mto13,
                                                 pn_mto14  => ln_mto14,
                                                 pn_mto15  => ln_mto15);
                  end;
                end if;

                ln_mto11 := nvl(ln_mto11, 0);
                ln_mto12 := nvl(ln_mto12, 0);
                ln_mto13 := nvl(ln_mto13, 0);
                ln_mto14 := nvl(ln_mto14, 0);
                ln_mto15 := nvl(ln_mto15, 0);

                if ln_mto11 = 0 and ln_mto12 = 0 and ln_mto13 = 0 and
                   ln_mto14 = 0 and ln_mto15 = 0 then

                  ld_fecfin := add_months(pd_fecpro, 3); -- Se agrega tres meses a fecha de proces, puede ser cuota adelantada

                  begin
                    PQ_CR_FAMSEGURA.sp_cronograma(pn_emp    => pn_emp,
                                                  pn_mod    => pn_mod,
                                                  pn_suc    => pn_suc,
                                                  pn_mda    => pn_mda,
                                                  pn_pap    => pn_pap,
                                                  pn_cta    => pn_cta,
                                                  pn_ope    => pn_ope,
                                                  pn_sbo    => pn_sbo,
                                                  pn_top    => pn_top,
                                                  pn_tip    => pn_tip,
                                                  pd_fecini => ld_fecini,
                                                  pd_fecfin => ld_fecfin,
                                                  pd_fecpro => pd_fecpro,
                                                  pn_mto11  => ln_mto11,
                                                  pn_mto12  => ln_mto12,
                                                  pn_mto13  => ln_mto13,
                                                  pn_mto14  => ln_mto14,
                                                  pn_mto15  => ln_mto15);
                  end;
                end if;

                ln_mto11 := nvl(ln_mto11, 0);
                ln_mto12 := nvl(ln_mto12, 0);
                ln_mto13 := nvl(ln_mto13, 0);
                ln_mto14 := nvl(ln_mto14, 0);
                ln_mto15 := nvl(ln_mto15, 0);

                if ln_mto11 = 0 and ln_mto12 = 0 and ln_mto13 = 0 and
                   ln_mto14 = 0 and ln_mto15 = 0 then

                  ld_fecfin := add_months(pd_fecpro, 4); -- Se agrega cuatro meses a fecha de proces, puede ser cuota adelantada

                  begin
                    PQ_CR_FAMSEGURA.sp_cronograma(pn_emp    => pn_emp,
                                                  pn_mod    => pn_mod,
                                                  pn_suc    => pn_suc,
                                                  pn_mda    => pn_mda,
                                                  pn_pap    => pn_pap,
                                                  pn_cta    => pn_cta,
                                                  pn_ope    => pn_ope,
                                                  pn_sbo    => pn_sbo,
                                                  pn_top    => pn_top,
                                                  pn_tip    => pn_tip,
                                                  pd_fecini => ld_fecini,
                                                  pd_fecfin => ld_fecfin,
                                                  pd_fecpro => pd_fecpro,
                                                  pn_mto11  => ln_mto11,
                                                  pn_mto12  => ln_mto12,
                                                  pn_mto13  => ln_mto13,
                                                  pn_mto14  => ln_mto14,
                                                  pn_mto15  => ln_mto15);
                  end;
                end if;

                ln_mto11 := nvl(ln_mto11, 0);
                ln_mto12 := nvl(ln_mto12, 0);
                ln_mto13 := nvl(ln_mto13, 0);
                ln_mto14 := nvl(ln_mto14, 0);
                ln_mto15 := nvl(ln_mto15, 0);

                if ln_mto11 = 0 and ln_mto12 = 0 and ln_mto13 = 0 and
                   ln_mto14 = 0 and ln_mto15 = 0 then

                  ld_fecfin := add_months(pd_fecpro, 5); -- Se agrega cinco meses a fecha de proces, puede ser cuota adelantada

                  begin
                    PQ_CR_FAMSEGURA.sp_cronograma(pn_emp    => pn_emp,
                                                  pn_mod    => pn_mod,
                                                  pn_suc    => pn_suc,
                                                  pn_mda    => pn_mda,
                                                  pn_pap    => pn_pap,
                                                  pn_cta    => pn_cta,
                                                  pn_ope    => pn_ope,
                                                  pn_sbo    => pn_sbo,
                                                  pn_top    => pn_top,
                                                  pn_tip    => pn_tip,
                                                  pd_fecini => ld_fecini,
                                                  pd_fecfin => ld_fecfin,
                                                  pd_fecpro => pd_fecpro,
                                                  pn_mto11  => ln_mto11,
                                                  pn_mto12  => ln_mto12,
                                                  pn_mto13  => ln_mto13,
                                                  pn_mto14  => ln_mto14,
                                                  pn_mto15  => ln_mto15);
                  end;
                end if;

                if ld_fecini is null then
                  ld_fecini := ld_fecnew;
                end if;

                if ld_fecfin is null then
                  ld_fecfin := pd_fecpro;
                end if;
                --2016.06.21

              end if;

            end if;

            --si monto de prima es igual a PP1IMP
            case
              when ln_codVar = 1 then
                ln_mtoprima := ln_mto11;
                --2016.06.22
                if ln_mtoprima <> ln_mtoseg then
                  begin
                    PQ_CR_FAMSEGURA.sp_cr_gracia(pn_emp    => pn_emp,
                                                 pn_mod    => pn_mod,
                                                 pn_suc    => pn_suc,
                                                 pn_mda    => pn_mda,
                                                 pn_pap    => pn_pap,
                                                 pn_cta    => pn_cta,
                                                 pn_ope    => pn_ope,
                                                 pn_sbo    => pn_sbo,
                                                 pn_top    => pn_top,
                                                 pd_fecini => ld_fecini,
                                                 pd_fecfin => ld_fecfin,
                                                 pn_numcuo => ln_numcuo);
                  end;
                  if ln_numcuo > 0 then
                    if ln_mtoseg <> 0 then ---sma 20200410 adicion para validacion todas igual a esta
                      if ln_mtoprima / ln_mtoseg = 2 then
                        --si es el doble y tiene gracia
                        ln_mtoprima := ln_mtoseg;
                      end if;
                     end if;
                  end if;
                end if;
                --2016.06.22
                if ln_mtoprima = ln_mtoseg then
                  ln_impAux := ln_mtoseg;
                  for h in calendario_vida loop
                    if ln_impAux = h.ppimp11 then

                      lc_flag := 'S';
                    else
                      --2016.06.22
                      if ln_numcuo > 0 then
                        lc_flag := 'S';
                      else
                        --2016.06.22
                        lc_flag := 'N';
                        exit;
                      end if; --2016.06.22

                    end if;
                    ln_impAux := h.ppimp11;
                  end loop;

                  /*if lc_flag = 'S' then
                     ln_mtoprima := ln_mto12;
                     ln_codVar := 2;
                  end if;*/

                end if;
              when ln_codVar = 2 then
                ln_mtoprima := ln_mto12;
                --2016.06.22
                if ln_mtoprima <> ln_mtoseg then
                  begin
                    PQ_CR_FAMSEGURA.sp_cr_gracia(pn_emp    => pn_emp,
                                                 pn_mod    => pn_mod,
                                                 pn_suc    => pn_suc,
                                                 pn_mda    => pn_mda,
                                                 pn_pap    => pn_pap,
                                                 pn_cta    => pn_cta,
                                                 pn_ope    => pn_ope,
                                                 pn_sbo    => pn_sbo,
                                                 pn_top    => pn_top,
                                                 pd_fecini => ld_fecini,
                                                 pd_fecfin => ld_fecfin,
                                                 pn_numcuo => ln_numcuo);
                  end;
                  if ln_numcuo > 0 then
                    if ln_mtoseg <> 0 then
                      if ln_mtoprima / ln_mtoseg = 2 then
                        --si es el doble y tiene gracia
                        ln_mtoprima := ln_mtoseg;
                      end if;
                    end if;  
                  end if;
                end if;
                --2016.06.22

                if ln_mtoprima = ln_mtoseg then
                  ln_impAux := ln_mtoseg;

                  for h in calendario_vida loop
                    if ln_impAux = h.ppimp12 then

                      lc_flag := 'S';
                    else
                      --2016.06.22
                      if ln_numcuo > 0 then
                        lc_flag := 'S';
                      else
                        --2016.06.22
                        lc_flag := 'N';
                        exit;
                      end if; --2016.06.22
                    end if;
                    ln_impAux := h.ppimp12;
                  end loop;

                end if;
              when ln_codVar = 3 then
                ln_mtoprima := ln_mto13;

                --2016.06.22
                if ln_mtoprima <> ln_mtoseg then
                  begin
                    PQ_CR_FAMSEGURA.sp_cr_gracia(pn_emp    => pn_emp,
                                                 pn_mod    => pn_mod,
                                                 pn_suc    => pn_suc,
                                                 pn_mda    => pn_mda,
                                                 pn_pap    => pn_pap,
                                                 pn_cta    => pn_cta,
                                                 pn_ope    => pn_ope,
                                                 pn_sbo    => pn_sbo,
                                                 pn_top    => pn_top,
                                                 pd_fecini => ld_fecini,
                                                 pd_fecfin => ld_fecfin,
                                                 pn_numcuo => ln_numcuo);
                  end;
                  if ln_numcuo > 0 then
                    if  ln_mtoseg <> 0 then
                        if ln_mtoprima / ln_mtoseg = 2 then
                          --si es el doble y tiene gracia
                          ln_mtoprima := ln_mtoseg;
                        end if;
                    end if;
                  end if;
                end if;
                --2016.06.22
                if ln_mtoprima = ln_mtoseg then
                  ln_impAux := ln_mtoseg;
                  for h in calendario_vida loop
                    if ln_impAux = h.ppimp13 then

                      lc_flag := 'S';
                    else
                      --2016.06.22
                      if ln_numcuo > 0 then
                        lc_flag := 'S';
                      else
                        --2016.06.22
                        lc_flag := 'N';
                        exit;
                      end if; --2016.06.22
                    end if;
                    ln_impAux := h.ppimp13;
                  end loop;

                end if;
              when ln_codVar = 4 then
                ln_mtoprima := ln_mto14;
                --2016.06.22
                if ln_mtoprima <> ln_mtoseg then
                  begin
                    PQ_CR_FAMSEGURA.sp_cr_gracia(pn_emp    => pn_emp,
                                                 pn_mod    => pn_mod,
                                                 pn_suc    => pn_suc,
                                                 pn_mda    => pn_mda,
                                                 pn_pap    => pn_pap,
                                                 pn_cta    => pn_cta,
                                                 pn_ope    => pn_ope,
                                                 pn_sbo    => pn_sbo,
                                                 pn_top    => pn_top,
                                                 pd_fecini => ld_fecini,
                                                 pd_fecfin => ld_fecfin,
                                                 pn_numcuo => ln_numcuo);
                  end;
                  if ln_numcuo > 0 then
                    if ln_mtoseg <> 0 then
                      if ln_mtoprima / ln_mtoseg = 2 then
                        --si es el doble y tiene gracia
                        ln_mtoprima := ln_mtoseg;
                      end if;
                    end if;
                  end if;
                end if;
                --2016.06.22
                if ln_mtoprima = ln_mtoseg then
                  ln_impAux := ln_mtoseg;
                  for h in calendario_vida loop
                    if ln_impAux = h.ppimp14 then

                      lc_flag := 'S';
                    else
                      --2016.06.22
                      if ln_numcuo > 0 then
                        lc_flag := 'S';
                      else
                        --2016.06.22
                        lc_flag := 'N';
                        exit;
                      end if; --2016.06.22
                    end if;
                    ln_impAux := h.ppimp14;
                  end loop;
                end if;
              when ln_codVar = 5 then
                ln_mtoprima := ln_mto15;
                --2016.06.22
                if ln_mtoprima <> ln_mtoseg then
                  begin
                    PQ_CR_FAMSEGURA.sp_cr_gracia(pn_emp    => pn_emp,
                                                 pn_mod    => pn_mod,
                                                 pn_suc    => pn_suc,
                                                 pn_mda    => pn_mda,
                                                 pn_pap    => pn_pap,
                                                 pn_cta    => pn_cta,
                                                 pn_ope    => pn_ope,
                                                 pn_sbo    => pn_sbo,
                                                 pn_top    => pn_top,
                                                 pd_fecini => ld_fecini,
                                                 pd_fecfin => ld_fecfin,
                                                 pn_numcuo => ln_numcuo);
                  end;
                  if ln_numcuo > 0 then
                    if ln_mtoseg <> 0 then
                        if ln_mtoprima / ln_mtoseg = 2 then
                          --si es el doble y tiene gracia
                          ln_mtoprima := ln_mtoseg;
                        end if;
                    end if;    
                  end if;
                end if;
                --2016.06.22
                if ln_mtoprima = ln_mtoseg then
                  ln_impAux := ln_mtoseg;
                  for h in calendario_vida loop
                    if ln_impAux = h.ppimp15 then

                      lc_flag := 'S';
                    else
                      --2016.06.22
                      if ln_numcuo > 0 then
                        lc_flag := 'S';
                      else
                        --2016.06.22
                        lc_flag := 'N';
                        exit;
                      end if; --2016.06.22
                    end if;
                    ln_impAux := h.ppimp15;
                  end loop;
                end if;
              else
                ln_mtoprima := 0;
            end case;

          end;
        end if;

        ---validar cuota pagada
        --ln_codvar / ln_mtoprima

        if nvl(ln_mtoprima, 0) > 0 then
          begin
            PQ_CR_FAMSEGURA.sp_cr_validapago(ln_pgcod     => pn_emp,
                                             ln_modulo    => pn_mod,
                                             ln_sucursal  => pn_suc,
                                             ln_moneda    => pn_mda,
                                             ln_papel     => pn_pap,
                                             ln_cuenta    => pn_cta,
                                             ln_operacion => pn_ope,
                                             ln_suboper   => pn_sbo,
                                             ln_tope      => pn_top,
                                             ld_fechpag   => pd_fecpro,
                                             ld_pd_fecini => ld_fecini,
                                             ld_pd_fecfin => pd_fecpro,
                                             ln_codvar    => ln_codvar,
                                             ln_monto     => ln_mtoprima,
                                             lc_indica    => 'A',
                                             ln_numcuo    => ln_numcuo);
          end;
        end if;
        ---

      end loop;
    end;

  end Sp_monto_calendarioVC;

  ---------------
  Procedure Sp_monto_calendarioVCC(pn_emp      in number,
                                   pn_mod      in number,
                                   pn_suc      in number,
                                   pn_mda      in number,
                                   pn_pap      in number,
                                   pn_cta      in number,
                                   pn_ope      in number,
                                   pn_sbo      in number,
                                   pn_top      in number,
                                   pn_tip      in number,
                                   pd_fecpro   in date,
                                   ln_mtoprima out number,
                                   ln_codVar   out number,
                                   lc_tip      out char) is

    -- *****************************************************************
    -- Nombre                     : Sp_monto_calendarioVC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.05.16
    -- Autor de Creación          : DCASTRO
    -- Uso                        : VALIDA MONTO CALENDARIO CREDITOS DESAFILIADOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2016.06.22
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se agrego llamada a sp_cronograma y busqueda para pagos realizados en mes de desembolso.
    --
    -- *****************************************************************

    cursor seguros_ii is
      select *
        from fpp001 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;
--         and a.pp001imp <> 0;

    cursor calendario_vida is
      select *
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;

    ln_canSeg number(2);
    --ln_codVar number(2);
    ld_fecan date;

    ld_fecini date;

    --ln_mtoprima number(17,2) ;
    ln_mto11 number(17, 2);
    ln_mto12 number(17, 2);
    ln_mto13 number(17, 2);
    ln_mto14 number(17, 2);
    ln_mto15 number(17, 2);

    lc_flag   char(1);
    ln_impAux number(17, 2);

    lc_flag11   char(1);
    ln_impAux11 number(17, 2);

    lc_flag13   char(1);
    ln_impAux13 number(17, 2);

    ld_pago date;
    --lc_tip char(1);
    ln_mtoseg  number(17, 2);
    ln_mtoseg1 number(17, 2);
    ln_mtoseg2 number(17, 2);
    ln_mtoseg3 number(17, 2);
    ln_mtoseg4 number(17, 2);
    ln_mtoseg5 number(17, 2);
    ln_mtoseg6 number(17, 2);
    ld_fecnew  date;

    ld_fecfin date; -- 2016.06.21
    ln_numcuo number := 0;

  begin

    ld_fecini := to_date('01' || to_char(pd_fecpro, 'mmyyyy'), 'ddmmyyyy');
    lc_tip    := null;

    ln_mtoseg1 := 6.5; --soles
    ln_mtoseg2 := 12; --soles
    ln_mtoseg3 := 24; --soles

    ln_mtoseg4 := 1.81; --dolares
    ln_mtoseg5 := 3.33; --dolares
    ln_mtoseg6 := 6.67; --dolares

    begin

      begin

        begin
          PQ_CR_FAMSEGURA.sp_cronograma(pn_emp    => pn_emp,
                                        pn_mod    => pn_mod,
                                        pn_suc    => pn_suc,
                                        pn_mda    => pn_mda,
                                        pn_pap    => pn_pap,
                                        pn_cta    => pn_cta,
                                        pn_ope    => pn_ope,
                                        pn_sbo    => pn_sbo,
                                        pn_top    => pn_top,
                                        pn_tip    => pn_tip,
                                        pd_fecini => ld_fecini,
                                        pd_fecfin => pd_fecpro,
                                        pd_fecpro => pd_fecpro,
                                        pn_mto11  => ln_mto11,
                                        pn_mto12  => ln_mto12,
                                        pn_mto13  => ln_mto13,
                                        pn_mto14  => ln_mto14,
                                        pn_mto15  => ln_mto15);
        end;

        --   when no_data_found then
        ld_fecnew := add_months(ld_fecini, -1); -- para menos de un mes

        ln_mto11 := nvl(ln_mto11, 0);
        ln_mto12 := nvl(ln_mto12, 0);
        ln_mto13 := nvl(ln_mto13, 0);
        ln_mto14 := nvl(ln_mto14, 0);
        ln_mto15 := nvl(ln_mto15, 0);

        if ln_mto11 = 0 and ln_mto12 = 0 and ln_mto13 = 0 and ln_mto14 = 0 and
           ln_mto15 = 0 then

          begin
            PQ_CR_FAMSEGURA.sp_cronograma(pn_emp    => pn_emp,
                                          pn_mod    => pn_mod,
                                          pn_suc    => pn_suc,
                                          pn_mda    => pn_mda,
                                          pn_pap    => pn_pap,
                                          pn_cta    => pn_cta,
                                          pn_ope    => pn_ope,
                                          pn_sbo    => pn_sbo,
                                          pn_top    => pn_top,
                                          pn_tip    => pn_tip,
                                          pd_fecini => ld_fecnew,
                                          pd_fecfin => pd_fecpro,
                                          pd_fecpro => pd_fecpro,
                                          pn_mto11  => ln_mto11,
                                          pn_mto12  => ln_mto12,
                                          pn_mto13  => ln_mto13,
                                          pn_mto14  => ln_mto14,
                                          pn_mto15  => ln_mto15);
          end;

          ln_mto11 := nvl(ln_mto11, 0);
          ln_mto12 := nvl(ln_mto12, 0);
          ln_mto13 := nvl(ln_mto13, 0);
          ln_mto14 := nvl(ln_mto14, 0);
          ln_mto15 := nvl(ln_mto15, 0);

          if ln_mto11 = 0 and ln_mto12 = 0 and ln_mto13 = 0 and
             ln_mto14 = 0 and ln_mto15 = 0 then

            ld_fecnew := add_months(ld_fecini, -2); -- para menos de 2 meses

            begin
              PQ_CR_FAMSEGURA.sp_cronograma(pn_emp    => pn_emp,
                                            pn_mod    => pn_mod,
                                            pn_suc    => pn_suc,
                                            pn_mda    => pn_mda,
                                            pn_pap    => pn_pap,
                                            pn_cta    => pn_cta,
                                            pn_ope    => pn_ope,
                                            pn_sbo    => pn_sbo,
                                            pn_top    => pn_top,
                                            pn_tip    => pn_tip,
                                            pd_fecini => ld_fecnew,
                                            pd_fecfin => pd_fecpro,
                                            pd_fecpro => pd_fecpro,
                                            pn_mto11  => ln_mto11,
                                            pn_mto12  => ln_mto12,
                                            pn_mto13  => ln_mto13,
                                            pn_mto14  => ln_mto14,
                                            pn_mto15  => ln_mto15);
            end;

            --2016.06.21
            ln_mto11 := nvl(ln_mto11, 0);
            ln_mto12 := nvl(ln_mto12, 0);
            ln_mto13 := nvl(ln_mto13, 0);
            ln_mto14 := nvl(ln_mto14, 0);
            ln_mto15 := nvl(ln_mto15, 0);

            if ln_mto11 = 0 and ln_mto12 = 0 and ln_mto13 = 0 and
               ln_mto14 = 0 and ln_mto15 = 0 then

              ld_fecfin := add_months(pd_fecpro, 1); -- Se agrega un mes a fecha de proces, puede ser cuota adelantada

              begin
                PQ_CR_FAMSEGURA.sp_cronograma(pn_emp    => pn_emp,
                                              pn_mod    => pn_mod,
                                              pn_suc    => pn_suc,
                                              pn_mda    => pn_mda,
                                              pn_pap    => pn_pap,
                                              pn_cta    => pn_cta,
                                              pn_ope    => pn_ope,
                                              pn_sbo    => pn_sbo,
                                              pn_top    => pn_top,
                                              pn_tip    => pn_tip,
                                              pd_fecini => ld_fecini,
                                              pd_fecfin => ld_fecfin,
                                              pd_fecpro => pd_fecpro,
                                              pn_mto11  => ln_mto11,
                                              pn_mto12  => ln_mto12,
                                              pn_mto13  => ln_mto13,
                                              pn_mto14  => ln_mto14,
                                              pn_mto15  => ln_mto15);
              end;
            end if;
            --2016.06.21

          end if;
        end if;

        case
          when ln_mto11 = ln_mtoseg1 or ln_mto11 = ln_mtoseg2 or
               ln_mto11 = ln_mtoseg3 or
               ((ln_mto11 = ln_mtoseg4 or ln_mto11 = ln_mtoseg5 or
               ln_mto11 = ln_mtoseg6) and pn_mda = 101) then
            ln_mtoseg := ln_mto11;
            ln_codVar := 1;
          when ln_mto12 = ln_mtoseg1 or ln_mto12 = ln_mtoseg2 or
               ((ln_mto12 = ln_mtoseg4 or ln_mto12 = ln_mtoseg5 or
               ln_mto12 = ln_mtoseg6) and pn_mda = 101) then
            ln_mtoseg := ln_mto12;
            ln_codVar := 2;
          when ln_mto13 = ln_mtoseg1 or ln_mto13 = ln_mtoseg2 or
               ((ln_mto13 = ln_mtoseg4 or ln_mto13 = ln_mtoseg5 or
               ln_mto13 = ln_mtoseg6) and pn_mda = 101) then
            ln_mtoseg := ln_mto13;
            ln_codVar := 3;
          when ln_mto14 = ln_mtoseg1 or ln_mto14 = ln_mtoseg2 or
               ((ln_mto14 = ln_mtoseg4 or ln_mto14 = ln_mtoseg5 or
               ln_mto14 = ln_mtoseg6) and pn_mda = 101) then
            ln_mtoseg := ln_mto14;
            ln_codVar := 4;
          when ln_mto15 = ln_mtoseg1 or ln_mto15 = ln_mtoseg2 or
               ((ln_mto15 = ln_mtoseg4 or ln_mto15 = ln_mtoseg5 or
               ln_mto15 = ln_mtoseg6) and pn_mda = 101) then
            ln_mtoseg := ln_mto15;
            ln_codVar := 5;
          else
            ln_codVar := 0;
        end case;

        --si monto de prima es igual a PP1IMP
        case
          when ln_codVar = 1 then
            ln_mtoprima := ln_mto11;
            --2016.06.22
            if ln_mtoprima <> ln_mtoseg then
              begin
                PQ_CR_FAMSEGURA.sp_cr_gracia(pn_emp    => pn_emp,
                                             pn_mod    => pn_mod,
                                             pn_suc    => pn_suc,
                                             pn_mda    => pn_mda,
                                             pn_pap    => pn_pap,
                                             pn_cta    => pn_cta,
                                             pn_ope    => pn_ope,
                                             pn_sbo    => pn_sbo,
                                             pn_top    => pn_top,
                                             pd_fecini => ld_fecini,
                                             pd_fecfin => ld_fecfin,
                                             pn_numcuo => ln_numcuo);
              end;
              if ln_numcuo > 0 then
                if ln_mtoseg <> 0 then
                    if ln_mtoprima / ln_mtoseg = 2 then
                      --si es el doble y tiene gracia
                      ln_mtoprima := ln_mtoseg;
                    end if;
                end if;    
              end if;
            end if;
            --2016.06.22

            if ln_mtoprima = ln_mtoseg then
              ln_impAux := ln_mtoseg;
              for h in calendario_vida loop
                if ln_impAux = h.ppimp11 then

                  lc_flag := 'S';
                else
                  --2016.06.22
                  if ln_numcuo > 0 then
                    lc_flag := 'S';
                  else
                    --2016.06.22
                    lc_flag := 'N';
                    exit;
                  end if; --2016.06.22

                end if;
                ln_impAux := h.ppimp11;
              end loop;

            end if;
          when ln_codVar = 2 then
            ln_mtoprima := ln_mto12;
            --2016.06.22
            if ln_mtoprima <> ln_mtoseg then
              begin
                PQ_CR_FAMSEGURA.sp_cr_gracia(pn_emp    => pn_emp,
                                             pn_mod    => pn_mod,
                                             pn_suc    => pn_suc,
                                             pn_mda    => pn_mda,
                                             pn_pap    => pn_pap,
                                             pn_cta    => pn_cta,
                                             pn_ope    => pn_ope,
                                             pn_sbo    => pn_sbo,
                                             pn_top    => pn_top,
                                             pd_fecini => ld_fecini,
                                             pd_fecfin => ld_fecfin,
                                             pn_numcuo => ln_numcuo);
              end;
              if ln_numcuo > 0 then
                if ln_mtoseg <> 0 then
                  if ln_mtoprima / ln_mtoseg = 2 then
                    --si es el doble y tiene gracia
                    ln_mtoprima := ln_mtoseg;
                  end if;
                end if;  
              end if;
            end if;
            --2016.06.22
            if ln_mtoprima = ln_mtoseg then
              ln_impAux := ln_mtoseg;
              for h in calendario_vida loop
                if ln_impAux = h.ppimp12 then

                  lc_flag := 'S';
                else
                  --2016.06.22
                  if ln_numcuo > 0 then
                    lc_flag := 'S';
                  else
                    --2016.06.22
                    lc_flag := 'N';
                    exit;
                  end if; --2016.06.22
                end if;
                ln_impAux := h.ppimp12;
              end loop;

            end if;
          when ln_codVar = 3 then
            ln_mtoprima := ln_mto13;
            --2016.06.22
            if ln_mtoprima <> ln_mtoseg then
              begin
                PQ_CR_FAMSEGURA.sp_cr_gracia(pn_emp    => pn_emp,
                                             pn_mod    => pn_mod,
                                             pn_suc    => pn_suc,
                                             pn_mda    => pn_mda,
                                             pn_pap    => pn_pap,
                                             pn_cta    => pn_cta,
                                             pn_ope    => pn_ope,
                                             pn_sbo    => pn_sbo,
                                             pn_top    => pn_top,
                                             pd_fecini => ld_fecini,
                                             pd_fecfin => ld_fecfin,
                                             pn_numcuo => ln_numcuo);
              end;
              if ln_numcuo > 0 then
                if ln_mtoseg <> 0 then
                  if ln_mtoprima / ln_mtoseg = 2 then
                    --si es el doble y tiene gracia
                    ln_mtoprima := ln_mtoseg;
                  end if;
                end if;  
              end if;
            end if;
            --2016.06.22
            if ln_mtoprima = ln_mtoseg then
              ln_impAux := ln_mtoseg;
              for h in calendario_vida loop
                if ln_impAux = h.ppimp13 then

                  lc_flag := 'S';
                else
                  --2016.06.22
                  if ln_numcuo > 0 then
                    lc_flag := 'S';
                  else
                    --2016.06.22
                    lc_flag := 'N';
                    exit;
                  end if; --2016.06.22
                end if;
                ln_impAux := h.ppimp13;
              end loop;

            end if;
          when ln_codVar = 4 then
            ln_mtoprima := ln_mto14;
            --2016.06.22
            if ln_mtoprima <> ln_mtoseg then
              begin
                PQ_CR_FAMSEGURA.sp_cr_gracia(pn_emp    => pn_emp,
                                             pn_mod    => pn_mod,
                                             pn_suc    => pn_suc,
                                             pn_mda    => pn_mda,
                                             pn_pap    => pn_pap,
                                             pn_cta    => pn_cta,
                                             pn_ope    => pn_ope,
                                             pn_sbo    => pn_sbo,
                                             pn_top    => pn_top,
                                             pd_fecini => ld_fecini,
                                             pd_fecfin => ld_fecfin,
                                             pn_numcuo => ln_numcuo);
              end;
              if ln_numcuo > 0 then
               if ln_mtoseg <> 0 then
                  if ln_mtoprima / ln_mtoseg = 2 then
                    --si es el doble y tiene gracia
                    ln_mtoprima := ln_mtoseg;
                  end if;
                end if;  
              end if;
            end if;
            --2016.06.22
            if ln_mtoprima = ln_mtoseg then
              ln_impAux := ln_mtoseg;
              for h in calendario_vida loop
                if ln_impAux = h.ppimp14 then

                  lc_flag := 'S';
                else
                  --2016.06.22
                  if ln_numcuo > 0 then
                    lc_flag := 'S';
                  else
                    --2016.06.22
                    lc_flag := 'N';
                    exit;
                  end if; --2016.06.22
                end if;
                ln_impAux := h.ppimp14;
              end loop;
            end if;
          when ln_codVar = 5 then
            ln_mtoprima := ln_mto15;
            --2016.06.22
            if ln_mtoprima <> ln_mtoseg then
              begin
                PQ_CR_FAMSEGURA.sp_cr_gracia(pn_emp    => pn_emp,
                                             pn_mod    => pn_mod,
                                             pn_suc    => pn_suc,
                                             pn_mda    => pn_mda,
                                             pn_pap    => pn_pap,
                                             pn_cta    => pn_cta,
                                             pn_ope    => pn_ope,
                                             pn_sbo    => pn_sbo,
                                             pn_top    => pn_top,
                                             pd_fecini => ld_fecini,
                                             pd_fecfin => ld_fecfin,
                                             pn_numcuo => ln_numcuo);
              end;
              if ln_numcuo > 0 then
                if ln_mtoseg <> 0 then
                  if ln_mtoprima / ln_mtoseg = 2 then
                    --si es el doble y tiene gracia
                    ln_mtoprima := ln_mtoseg;
                  end if;
                end if;  
              end if;
            end if;
            --2016.06.22
            if ln_mtoprima = ln_mtoseg then
              ln_impAux := ln_mtoseg;
              for h in calendario_vida loop
                if ln_impAux = h.ppimp15 then

                  lc_flag := 'S';
                else
                  --2016.06.22
                  if ln_numcuo > 0 then
                    lc_flag := 'S';
                  else
                    --2016.06.22
                    lc_flag := 'N';
                    exit;
                  end if; --2016.06.22
                end if;
                ln_impAux := h.ppimp15;
              end loop;
            end if;
          else
            ln_mtoprima := 0;
        end case;

      end;
      ---validar cuota pagada
      --ln_codvar / ln_mtoprima

      if nvl(ln_mtoprima, 0) > 0 then
        begin
          PQ_CR_FAMSEGURA.sp_cr_validapago(ln_pgcod     => pn_emp,
                                           ln_modulo    => pn_mod,
                                           ln_sucursal  => pn_suc,
                                           ln_moneda    => pn_mda,
                                           ln_papel     => pn_pap,
                                           ln_cuenta    => pn_cta,
                                           ln_operacion => pn_ope,
                                           ln_suboper   => pn_sbo,
                                           ln_tope      => pn_top,
                                           ld_fechpag   => pd_fecpro,
                                           ld_pd_fecini => ld_fecini,
                                           ld_pd_fecfin => pd_fecpro,
                                           ln_codvar    => ln_codvar,
                                           ln_monto     => ln_mtoprima,
                                           lc_indica    => 'D',
                                           ln_numcuo    => ln_numcuo);
        end;
      end if;
      ---

      /* end loop;*/
    end;

  end Sp_monto_calendarioVCC;
  ----------------------

  ---------------
  Procedure Sp_carga_VC(P_C_DIGITO in varchar2,
                        pd_fecini  in date,
                        pd_fecpro  in date) is

    -- *****************************************************************
    -- Nombre                     : Sp_carga_VC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.05.16
    -- Autor de Creación          : DCASTRO
    -- Uso                        : CARGA CURSOR INICIAL
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************

    cursor creditos is
      select *
        from jaqz085_aux a
      --  where a.jaqz085cta in (1269191)
       where to_char(substr(trim(jaqZ085cta), -1, 1)) = P_C_DIGITO
      --- and  a.jaqz085cta=2011250 --and a.jaqz085ope=1990862 pruebas
      ;

    ln_numpol    number(10);
    ld_fecvini   date;
    ld_fecvfin   date;
    ln_tasa      number(17, 6);
    ln_monto     number(17, 6);
    ln_salcap    number(17, 2);
    ln_grupo     number(2);
    lc_plan      char(30);
    ln_instancia number(10);
    ln_mtoapr    number(17, 2);
    ln_pai       number(3);
    ln_tdo       number(2);
    lc_ndo       char(12);
    lc_petipo    char(1);
    lc_apepat    char(30);
    lc_apemat    char(30);
    lc_nombre    char(50);
    lc_razsoc    char(70);
    lc_sexo      char(1);
    ld_fecnac    date;
    ln_paij      number(3);
    ln_tdoj      number(2);
    lc_ndoj      char(12);
    ld_fecant    date;
    lc_numcre    char(25);
    ln_aoimp     number(17, 2);
    ln_sucAct    number(3);

    ln_mtoCalen number(17, 2);
    ln_salcal   number(17, 2);
    ld_Fec      date;
    lc_tip      char(1);

  begin
    begin

      --ld_fecant := last_day(add_months(pd_fecpro,-1));
      for i in creditos loop
        lc_tip   := null;
        ln_grupo := null;
        lc_plan  := null;

        --fecha de vigencia inicial
        ld_fecvini := to_date('01' ||
                              to_char( /*i.jaqz085fec*/ pd_fecpro, 'mmyyyy'),
                              'dd/mm/yyyy');
        --fecha de vigencia final
        ld_fecvfin := pd_fecpro; --i.jaqz085fec;

        --instancia
        ln_instancia := fn_instancia_credito(i.JAQZ085MOD,
                                             i.JAQZ085SUC,
                                             i.JAQZ085MDA,
                                             i.JAQZ085PAP,
                                             i.JAQZ085CTA,
                                             i.JAQZ085OPE,
                                             i.JAQZ085SBO,
                                             i.JAQZ085TOP);
        if nvl(ln_instancia, 0) = 0 then
          begin
            select a.aosuc
              into ln_sucAct
              from fsd010 a
             where a.pgcod = i.JAQZ085EMP
               and a.aomod = i.JAQZ085MOD
               and a.aomda = i.JAQZ085MDA
               and a.aopap = i.JAQZ085PAP
               and a.aocta = i.JAQZ085CTA
               and a.aooper = i.JAQZ085OPE
               and a.aosbop = i.JAQZ085SBO
               and a.aotope = i.JAQZ085TOP;
          exception
            when others then
              null;
          end;
          ln_instancia := fn_instancia_credito(i.JAQZ085MOD,
                                               ln_sucAct,
                                               i.JAQZ085MDA,
                                               i.JAQZ085PAP,
                                               i.JAQZ085CTA,
                                               i.JAQZ085OPE,
                                               i.JAQZ085SBO,
                                               i.JAQZ085TOP);

        else
          ln_sucAct := i.JAQZ085SUC;
        end if;

        --monto calendario de pago
        PQ_CR_FAMSEGURA.Sp_monto_calendarioVC(i.JAQZ085EMP,
                                              i.JAQZ085MOD,
                                              ln_sucAct,
                                              i.JAQZ085MDA,
                                              i.JAQZ085PAP,
                                              i.JAQZ085CTA,
                                              i.JAQZ085OPE,
                                              i.JAQZ085SBO,
                                              i.JAQZ085TOP,
                                              2,
                                              pd_fecini,
                                              pd_fecpro,
                                              ln_mtoCalen,
                                              lc_tip);

      end loop;

    end;
  end Sp_carga_VC;

  ---------------

  ----------------------
  --------------------------------------------------------------------------------------------
  procedure sp_cr_validapago(ln_pgcod     in number,
                             ln_modulo    in number,
                             ln_sucursal  in number,
                             ln_moneda    in number,
                             ln_papel     in number,
                             ln_cuenta    in number,
                             ln_operacion in number,
                             ln_suboper   in number,
                             ln_tope      in number,
                             ld_fechpag   in date,
                             ld_pd_fecini in date,
                             ld_pd_fecfin in date,
                             ln_codvar    in number,
                             ln_monto     in out number,
                             lc_indica    in varchar2,
                             ln_numcuo    in number) is

    -- *****************************************************************
    -- Nombre                     : sp_cr_validapago
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.05.16
    -- Autor de Creación          : DCASTRO
    -- Uso                        : VALIDA PAGO DE CUOTA FSD602, FSD612, FSH016
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************

    cursor cuotas is

      select /*+ parallel(h,2)*/
       h.d602mo modulo,
       h.d602su sucursal,
       h.d602tr transaccion,
       h.d602re relacion,
       h.d602fc fchcontable,
       h.pp1nump ppnum,
       h.pp1stat lc_estado,
       i.ppfpag ld_fchcuo,
       h.d602fc ld_fchpago,
       to_char(to_date(i.ppfpag, 'dd/mm/rrrr'), 'RRRRMM') lc_mespago,
       to_char(to_date(ld_pd_fecini, 'dd/mm/rrrr'), 'RRRRMM') lc_mescuot,
       sum(i.pp1imp11) ln_imp1,
       sum(i.pp1imp12) ln_imp2,
       sum(i.pp1imp13) ln_imp3,
       sum(i.pp1imp14) ln_imp4,
       sum(i.pp1imp15) ln_imp5

        from fsd602 h, fsd612 i
       where h.d602cd = i.pgcod
         and h.d602co = 'S'
         and h.d602fc = ld_pd_fecfin
         and i.pgcod = h.pgcod
         and i.ppcta = h.ppcta
         and i.ppoper = h.ppoper
         and i.ppfpag = h.ppfpag
         and i.ppmod = h.ppmod
         and i.ppsuc = h.ppsuc
         and i.ppmda = h.ppmda
         and i.pppap = h.pppap
         and i.pp1nump = h.pp1nump
         and i.pgcod = ln_pgcod
         and i.ppmod = ln_modulo
         and i.ppsuc = ln_sucursal
         and i.ppmda = ln_moneda
         and i.pppap = ln_papel
         and i.ppcta = ln_cuenta
         and i.ppoper = ln_operacion
       group by h.d602mo,
                h.d602su,
                h.d602tr,
                h.d602re,
                h.d602fc,
                h.pp1nump,
                h.pp1stat,
                i.ppfpag,
                h.d602fc;

    lc_flag     varchar2(2) := 'N';
    ln_corr     number := 1;
    ln_imp      number(10, 2);
    lc_variable varchar2(2);
    ln_pago1    number(17, 2);
    ln_pago2    number(17, 2);
    ln_pago3    number(17, 2);
    ln_pago4    number(17, 2);
    ln_pago5    number(17, 2);
    ln_SegVal   number(17, 2);
    ln_mto11    number(17, 2);
    ln_mto12    number(17, 2);
    ln_mto13    number(17, 2);
    ln_mto14    number(17, 2);
    ln_mto15    number(17, 2);
    ln_montoT   number(17, 2);
    ld_fecha    date;

  begin

    for j in cuotas loop
      lc_flag := 'N';

      ln_pago1 := 0;
      ln_pago2 := 0;
      ln_pago3 := 0;
      ln_pago4 := 0;
      ln_pago5 := 0;

      begin

        select distinct ('S')
          into lc_variable
          from fsh016
         where PGCOD = 1
           and HCMOD = j.modulo
           and hcmod not in (98,99)
           and HSUCOR = j.sucursal
           and HTRAN = j.transaccion
           and HNREL = j.relacion
           and HFCON = j.fchcontable
           and hrubro in ('2514020000013', '2524020000013');
      exception
        when others then
          lc_variable := 'N';

      end;

      --validar si monto de la transaccion coincide con monto de cronograma segun fecha de pago
      --D602CD, D602MO, D602SU, D602TR, D602RE, D602FC, D602OR, D602SB

      begin
        select a.ppfpag
          into ld_fecha
          from fsd602 a
         where a.d602cd = ln_pgcod
           and a.d602mo = j.modulo
           and a.d602su = j.sucursal
           and a.d602tr = j.transaccion
           and a.d602re = j.relacion
           and a.d602fc = j.fchcontable
           and rownum = 1;
      exception
        when others then
          insert into jaqz097_error
          values
            (ln_cuenta, ln_operacion, 3, ld_pd_fecfin);
      end;

      begin
        select ppimp11, ppimp12, ppimp13, ppimp14, ppimp15
          into ln_mto11, ln_mto12, ln_mto13, ln_mto14, ln_mto15
          from fsd611 a
         where a.pgcod = ln_pgcod
           and a.ppmod = ln_modulo
           and a.ppsuc = ln_sucursal
           and a.ppmda = ln_moneda
           and a.pppap = ln_papel
           and a.ppcta = ln_cuenta
           and a.ppoper = ln_operacion
           and a.ppsbop = ln_suboper
           and a.pptope = ln_tope
           and a.ppfpag = ld_fecha
           and rownum = 1;
      exception
        when others then
          insert into jaqz097_error
          values
            (ln_cuenta, ln_operacion, 3, ld_pd_fecfin);
      end;

      case
        when ln_codVar = 1 then
          ln_SegVal := ln_mto11;
        when ln_codVar = 2 then
          ln_SegVal := ln_mto12;
        when ln_codVar = 3 then
          ln_SegVal := ln_mto13;
        when ln_codVar = 4 then
          ln_SegVal := ln_mto14;
        when ln_codVar = 5 then
          ln_SegVal := ln_mto15;
        else
          ln_SegVal := ln_monto;
      end case;

      if ln_monto <> ln_SegVal then
        ln_monto := ln_SegVal;
      end if;

      if lc_variable = 'S' then

        case
          when ln_codvar = 0 then
            lc_flag := 'N';
          when ln_codvar = 1 then
            if j.ln_imp1 = ln_monto then
              lc_flag := 'S';
            else
              if j.ln_imp1 < ln_monto then
                --verificar si mes es menor a fecha de proceso y verificar estado
                --si estado es T insertar porque ya cancelo
                if J.lc_mespago <= J.lc_mescuot and J.lc_estado = 'T' and
                   j.ln_imp1 <> 0 then
                  lc_flag := 'S';
                end if;
                --verificar si mes es menor a fecha de proceso y estado P no insertar
                if J.lc_mespago <= J.lc_mescuot and J.lc_estado = 'P' and
                   j.ln_imp1 <> 0 then
                  begin
                    select sum(f.pp1imp11)
                    /*sum(i.pp1imp12) ln_imp2,
                                                                                                                                                                               sum(i.pp1imp13) ln_imp3,
                                                                                                                                                                               sum(i.pp1imp14) ln_imp4,
                                                                                                                                                                               sum(i.pp1imp15) ln_imp5*/
                      into ln_pago1
                      from fsd612 f
                     where f.pgcod = ln_pgcod
                       and f.ppmod = ln_modulo
                       and f.ppsuc = ln_sucursal
                       and f.ppmda = ln_moneda
                       and f.pppap = ln_papel
                       and f.ppcta = ln_cuenta
                       and f.ppoper = ln_operacion
                       and f.ppfpag = j.ld_fchcuo
                       and f.pp1nump <= j.ppnum;
                  exception
                    when others then
                      ln_pago1 := 0;
                  end;

                  if ln_pago1 = ln_monto then
                    lc_flag := 'S';
                  else
                    lc_flag := 'N';
                  end if;
                end if;
                --verificar si mes es mayor a fecha de proceso y estado T  insertar
                if J.lc_mespago > J.lc_mescuot and J.lc_estado = 'T' and
                   j.ln_imp1 <> 0 then
                  lc_flag := 'S';
                end if;

                if J.lc_mespago > J.lc_mescuot and J.lc_estado = 'P' and
                   j.ln_imp1 <> 0 then
                  begin
                    select sum(f.pp1imp11)
                      into ln_pago1
                      from fsd612 f
                     where f.pgcod = ln_pgcod
                       and f.ppmod = ln_modulo
                       and f.ppsuc = ln_sucursal
                       and f.ppmda = ln_moneda
                       and f.pppap = ln_papel
                       and f.ppcta = ln_cuenta
                       and f.ppoper = ln_operacion
                       and f.ppfpag = j.ld_fchcuo
                       and f.pp1nump <= j.ppnum;
                  exception
                    when others then
                      ln_pago1 := 0;
                  end;

                  if ln_pago1 = ln_monto then
                    lc_flag := 'S';
                  else
                    lc_flag := 'N';
                  end if;
                end if;

              else
                --2016.06.22 si monto es mayor puede ser por gracia
                if ln_numcuo > 0 then
                  if j.ln_imp1 / ln_monto = 2 then
                    --si es el doble y tiene gracia
                    lc_flag := 'S';
                  end if;
                else
                  lc_flag := 'N';
                end if;
                --2016.06.22
              end if;
            end if;
          when ln_codvar = 2 then
            if j.ln_imp2 = ln_monto then
              lc_flag := 'S';
            else
              if j.ln_imp2 < ln_monto then
                --verificar si mes es menor a fecha de proceso y verificar estado
                --si estado es T insertar porque ya cancelo
                if J.lc_mespago <= J.lc_mescuot and J.lc_estado = 'T' and
                   j.ln_imp2 <> 0 then
                  lc_flag := 'S';
                end if;
                --verificar si mes es menor a fecha de proceso y estado P no insertar
                if J.lc_mespago <= J.lc_mescuot and J.lc_estado = 'P' and
                   j.ln_imp2 <> 0 then

                  begin
                    select sum(f.pp1imp12) /*ln_imp2/*,
                                                                                                                                                                           sum(i.pp1imp13) ln_imp3,
                                                                                                                                                                           sum(i.pp1imp14) ln_imp4,
                                                                                                                                                                           sum(i.pp1imp15) ln_imp5*/
                      into ln_pago2
                      from fsd612 f
                     where f.pgcod = ln_pgcod
                       and f.ppmod = ln_modulo
                       and f.ppsuc = ln_sucursal
                       and f.ppmda = ln_moneda
                       and f.pppap = ln_papel
                       and f.ppcta = ln_cuenta
                       and f.ppoper = ln_operacion
                       and f.ppfpag = j.ld_fchcuo
                       and f.pp1nump <= j.ppnum;
                  exception
                    when others then
                      ln_pago2 := 0;
                  end;

                  if ln_pago2 = ln_monto then
                    lc_flag := 'S';
                  else
                    lc_flag := 'N';
                  end if;

                end if;
                --verificar si mes es mayor a fecha de proceso y estado T  insertar
                if J.lc_mespago > J.lc_mescuot and J.lc_estado = 'T' and
                   j.ln_imp2 <> 0 then
                  lc_flag := 'S';
                end if;
                if J.lc_mespago > J.lc_mescuot and J.lc_estado = 'P' and
                   j.ln_imp2 <> 0 then
                  begin
                    select sum(f.pp1imp12)
                      into ln_pago2
                      from fsd612 f
                     where f.pgcod = ln_pgcod
                       and f.ppmod = ln_modulo
                       and f.ppsuc = ln_sucursal
                       and f.ppmda = ln_moneda
                       and f.pppap = ln_papel
                       and f.ppcta = ln_cuenta
                       and f.ppoper = ln_operacion
                       and f.ppfpag = j.ld_fchcuo
                       and f.pp1nump <= j.ppnum;
                  exception
                    when others then
                      ln_pago2 := 0;
                  end;

                  if ln_pago2 = ln_monto then
                    lc_flag := 'S';
                  else
                    lc_flag := 'N';
                  end if;
                end if;

              else
                --2016.06.22 si monto es mayor puede ser por gracia
                if ln_numcuo > 0 then
                  if j.ln_imp2 / ln_monto = 2 then
                    --si es el doble y tiene gracia
                    lc_flag := 'S';
                  end if;
                else
                  lc_flag := 'N';
                end if;
                --2016.06.22

              end if;
            end if;
          when ln_codvar = 3 then
            if j.ln_imp3 = ln_monto then
              lc_flag := 'S';
            else
              if j.ln_imp3 < ln_monto then
                --verificar si mes es menor a fecha de proceso y verificar estado
                --si estado es T insertar porque ya cancelo
                if J.lc_mespago <= J.lc_mescuot and J.lc_estado = 'T' and
                   j.ln_imp3 <> 0 then
                  lc_flag := 'S';
                end if;
                --verificar si mes es menor a fecha de proceso y estado P no insertar
                if J.lc_mespago <= J.lc_mescuot and J.lc_estado = 'P' and
                   j.ln_imp3 <> 0 then

                  begin
                    select sum(f.pp1imp13)
                      into ln_pago3
                      from fsd612 f
                     where f.pgcod = ln_pgcod
                       and f.ppmod = ln_modulo
                       and f.ppsuc = ln_sucursal
                       and f.ppmda = ln_moneda
                       and f.pppap = ln_papel
                       and f.ppcta = ln_cuenta
                       and f.ppoper = ln_operacion
                       and f.ppfpag = j.ld_fchcuo
                       and f.pp1nump <= j.ppnum;
                  exception
                    when others then
                      ln_pago3 := 0;
                  end;

                  if ln_pago3 = ln_monto then
                    lc_flag := 'S';
                  else
                    lc_flag := 'N';
                  end if;
                end if;
                --verificar si mes es mayor a fecha de proceso y estado T  insertar
                if J.lc_mespago > J.lc_mescuot and J.lc_estado = 'T' and
                   j.ln_imp3 <> 0 then
                  lc_flag := 'S';
                end if;

                if J.lc_mespago > J.lc_mescuot and J.lc_estado = 'P' and
                   j.ln_imp3 <> 0 then
                  begin
                    select sum(f.pp1imp13)
                      into ln_pago3
                      from fsd612 f
                     where f.pgcod = ln_pgcod
                       and f.ppmod = ln_modulo
                       and f.ppsuc = ln_sucursal
                       and f.ppmda = ln_moneda
                       and f.pppap = ln_papel
                       and f.ppcta = ln_cuenta
                       and f.ppoper = ln_operacion
                       and f.ppfpag = j.ld_fchcuo
                       and f.pp1nump <= j.ppnum;
                  exception
                    when others then
                      ln_pago3 := 0;
                  end;

                  if ln_pago3 = ln_monto then
                    lc_flag := 'S';
                  else
                    lc_flag := 'N';
                  end if;
                end if;
              else
                --2016.06.22 si monto es mayor puede ser por gracia
                if ln_numcuo > 0 then
                  if j.ln_imp3 / ln_monto = 2 then
                    --si es el doble y tiene gracia
                    lc_flag := 'S';
                  end if;
                else
                  lc_flag := 'N';
                end if;
                --2016.06.22

              end if;
            end if;

          when ln_codvar = 4 then
            if j.ln_imp4 = ln_monto then
              lc_flag := 'S';
            else
              if j.ln_imp4 < ln_monto then
                --verificar si mes es menor a fecha de proceso y verificar estado
                --si estado es T insertar porque ya cancelo
                if J.lc_mespago <= J.lc_mescuot and J.lc_estado = 'T' and
                   j.ln_imp4 <> 0 then
                  lc_flag := 'S';
                end if;
                --verificar si mes es menor a fecha de proceso y estado P no insertar
                if J.lc_mespago <= J.lc_mescuot and J.lc_estado = 'P' and
                   j.ln_imp4 <> 0 then
                  begin
                    select sum(f.pp1imp14)
                    into ln_pago4
                      from fsd612 f
                     where f.pgcod = ln_pgcod
                       and f.ppmod = ln_modulo
                       and f.ppsuc = ln_sucursal
                       and f.ppmda = ln_moneda
                       and f.pppap = ln_papel
                       and f.ppcta = ln_cuenta
                       and f.ppoper = ln_operacion
                       and f.ppfpag = j.ld_fchcuo
                       and f.pp1nump <= j.ppnum;
                  exception
                    when others then
                      ln_pago4 := 0;
                  end;

                  if ln_pago4 = ln_monto then
                    lc_flag := 'S';
                  else
                    lc_flag := 'N';
                  end if;
                end if;
                --verificar si mes es mayor a fecha de proceso y estado T  insertar
                if J.lc_mespago > J.lc_mescuot and J.lc_estado = 'T' and
                   j.ln_imp4 <> 0 then
                  lc_flag := 'S';
                end if;

                if J.lc_mespago > J.lc_mescuot and J.lc_estado = 'P' and
                   j.ln_imp4 <> 0 then
                  begin
                    select sum(f.pp1imp14)
                      into ln_pago4
                      from fsd612 f
                     where f.pgcod = ln_pgcod
                       and f.ppmod = ln_modulo
                       and f.ppsuc = ln_sucursal
                       and f.ppmda = ln_moneda
                       and f.pppap = ln_papel
                       and f.ppcta = ln_cuenta
                       and f.ppoper = ln_operacion
                       and f.ppfpag = j.ld_fchcuo
                       and f.pp1nump <= j.ppnum;
                  exception
                    when others then
                      ln_pago4 := 0;
                  end;

                  if ln_pago4 = ln_monto then
                    lc_flag := 'S';
                  else
                    lc_flag := 'N';
                  end if;
                end if;

              else
                --2016.06.22 si monto es mayor puede ser por gracia
                if ln_numcuo > 0 then
                  if j.ln_imp4 / ln_monto = 2 then
                    --si es el doble y tiene gracia
                    lc_flag := 'S';
                  end if;
                else
                  lc_flag := 'N';
                end if;
                --2016.06.22

              end if;
            end if;

          when ln_codvar = 5 then

            if j.ln_imp5 = ln_monto then
              lc_flag := 'S';
            else
              if j.ln_imp5 < ln_monto then
                --verificar si mes es menor a fecha de proceso y verificar estado
                --si estado es T insertar porque ya cancelo
                if J.lc_mespago <= J.lc_mescuot and J.lc_estado = 'T' and
                   j.ln_imp5 <> 0 then
                  lc_flag := 'S';
                end if;
                --verificar si mes es menor a fecha de proceso y estado P no insertar
                if J.lc_mespago <= J.lc_mescuot and J.lc_estado = 'P' and
                   j.ln_imp5 <> 0 then
                  begin
                    select sum(f.pp1imp15)
                    into ln_pago5
                      from fsd612 f
                     where f.pgcod = ln_pgcod
                       and f.ppmod = ln_modulo
                       and f.ppsuc = ln_sucursal
                       and f.ppmda = ln_moneda
                       and f.pppap = ln_papel
                       and f.ppcta = ln_cuenta
                       and f.ppoper = ln_operacion
                       and f.ppfpag = j.ld_fchcuo
                       and f.pp1nump <= j.ppnum;
                  exception
                    when others then
                      ln_pago5 := 0;
                  end;

                  if ln_pago5 = ln_monto then
                    lc_flag := 'S';
                  else
                    lc_flag := 'N';
                  end if;
                end if;
                --verificar si mes es mayor a fecha de proceso y estado T  insertar
                if J.lc_mespago > J.lc_mescuot and J.lc_estado = 'T' and
                   j.ln_imp5 <> 0 then
                  lc_flag := 'S';
                end if;

                if J.lc_mespago > J.lc_mescuot and J.lc_estado = 'P' and
                   j.ln_imp5 <> 0 then
                  begin
                    select sum(f.pp1imp15)
                      into ln_pago5
                      from fsd612 f
                     where f.pgcod = ln_pgcod
                       and f.ppmod = ln_modulo
                       and f.ppsuc = ln_sucursal
                       and f.ppmda = ln_moneda
                       and f.pppap = ln_papel
                       and f.ppcta = ln_cuenta
                       and f.ppoper = ln_operacion
                       and f.ppfpag = j.ld_fchcuo
                       and f.pp1nump <= j.ppnum;
                  exception
                    when others then
                      ln_pago5 := 0;
                  end;

                  if ln_pago5 = ln_monto then
                    lc_flag := 'S';
                  else
                    lc_flag := 'N';
                  end if;
                end if;

              else
                --2016.06.22 si monto es mayor puede ser por gracia
                if ln_numcuo > 0 then
                  if j.ln_imp5 / ln_monto = 2 then
                    --si es el doble y tiene gracia
                    lc_flag := 'S';
                  end if;
                else
                  lc_flag := 'N';
                end if;
                --2016.06.22
              end if;
            end if;
          else
            lc_flag := 'N';
        end case;

        ln_imp := ln_monto;
        --2016.06.22
        if ln_numcuo > 0 then
          if j.ln_imp1 > ln_monto then
            --si es el doble y tiene gracia
            ln_imp := j.ln_imp1;
          end if;
        end if;
        --2016.06.22

        if lc_flag = 'S' and ln_monto <> 0 then

          begin
            PQ_CR_FAMSEGURA.sp_cr_inserta(ln_pgcod     => ln_pgcod,
                                          ln_modulo    => ln_modulo,
                                          ln_sucursal  => ln_sucursal,
                                          ln_moneda    => ln_moneda,
                                          ln_papel     => ln_papel,
                                          ln_cuenta    => ln_cuenta,
                                          ln_operacion => ln_operacion,
                                          ln_suboper   => ln_suboper,
                                          ln_tope      => ln_tope,
                                          ld_fechcuo   => J.ld_fchcuo,
                                          ld_fchpago   => j.ld_fchpago,
                                          ln_imp       => ln_imp,
                                          ln_imp1      => j.ln_imp1,
                                          ln_imp2      => j.ln_imp2,
                                          ln_imp3      => j.ln_imp3,
                                          ln_imp4      => j.ln_imp4,
                                          ln_imp5      => j.ln_imp5,
                                          lc_indicador => lc_indica);
          end;

        end if;

      end if;

    end loop;

  end sp_cr_validapago;

  --------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------
  procedure sp_cr_inserta(ln_pgcod     in number,
                          ln_modulo    in number,
                          ln_sucursal  in number,
                          ln_moneda    in number,
                          ln_papel     in number,
                          ln_cuenta    in number,
                          ln_operacion in number,
                          ln_suboper   in number,
                          ln_tope      in number,
                          ld_fechcuo   in date,
                          ld_fchpago   in date,
                          ln_imp       in number,
                          ln_imp1      in number,
                          ln_imp2      in number,
                          ln_imp3      in number,
                          ln_imp4      in number,
                          ln_imp5      in number,
                          lc_indicador in varchar2) is

    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.05.16
    -- Autor de Creación          : DCASTRO
    -- Uso                        : INSERTA PAGOS EN TABLA JAQY145
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************

    ln_corr number;

  begin
    begin
      select count(*) into ln_corr from jaqy145;
    exception
      when no_data_found then
        ln_corr := 0;
    end;
    INSERT INTO JAQy145
      (Jaqy145corr,
       Jaqy145pgcod,
       Jaqy145mod,
       Jaqy145suc,
       Jaqy145mda,
       Jaqy145pap,
       Jaqy145cta,
       Jaqy145ope,
       Jaqy145sbop,
       Jaqy145top,
       Jaqy145fchcuo,
       Jaqy145fchpag,
       JAQY145IMPSG,
       Jaqy145imp1,
       Jaqy145imp2,
       Jaqy145imp3,
       Jaqy145imp4,
       Jaqy145imp5,
       Jaqy145Ind)
    VALUES
      (ln_corr + 1,
       ln_pgcod,
       ln_modulo,
       ln_sucursal,
       ln_moneda,
       ln_papel,
       ln_cuenta,
       ln_operacion,
       ln_suboper,
       ln_tope,
       ld_fechcuo,
       ld_fchpago,
       ln_imp,
       ln_imp1,
       ln_imp2,
       ln_imp3,
       ln_imp4,
       ln_imp5,
       lc_indicador);

    commit;

  end sp_cr_inserta;
  ----------------------------------------------------------------------------------------------
  ---------------
  ------------------------------------------------------------
  procedure sp_cr_cargaVC_job(pd_fecini IN date, pd_fecpro IN date) is

    -- *****************************************************************
    -- Nombre                     : sp_cr_cargaVC_job
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.05.16
    -- Autor de Creación          : DCASTRO
    -- Uso                        : CARGA JOBS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************

    cursor c_clientes_job is
      select to_char(substr(trim(j.jaqz085cta), -1, 1)) digito
        from jaqz085_aux j
       group by to_char(substr(trim(j.jaqz085cta), -1, 1));

    ln_ini      number;
    ln_fin      number;
    ln_divisor  number := 5000;
    lc_variable varchar2(1000);
    --ln_job number:=0;
    lc_fecpro   char(10);
    ld_finmes   date;
    ln_contador number;
    ln_num      number := 1;
    JOB_digito  NUMBER := 0;

    ln_job      number := 0;
    lc_hostname varchar2(64);
    ln_cont     number(2) := 0;
    ln_inst     number(1) := 1;

  begin

    begin
      select host_name into lc_hostname from v$instance;
    end;
    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD', --'BANTPROD',--'BANTPROD',
                                    tabname          => 'JAQZ085_AUX',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;

    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD', --'BANTPROD',--'BANTPROD',
                                    tabname          => 'JAQY145',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;

    execute immediate 'truncate table JAQY145';

    for job in c_clientes_job loop

      lc_variable := ' begin ' || ' PQ_CR_FAMSEGURA.Sp_carga_VC(''' ||
                     job.digito || ''',''' || pd_fecini || ''',''' ||
                     pd_fecpro || ''');' || ' End; ';
      ln_cont     := ln_cont + 1;

      if (ln_cont >= 50) then
        ln_inst := 1;
      end if;

      ln_job := ln_job + 1;


--      if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
IF SYS.FN_BD_ISRAC='TRUE' THEN

        dbms_scheduler.create_job(job_name   => 'FAM_SEG' ||
                                                LPAD(TO_CHAR(ln_job),
                                                     5,
                                                     '0'),
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => true,
                                  comments   => 'PAGOS FAMILIA SEGURA');
        begin
          dbms_scheduler.set_attribute('FAM_SEG' ||
                                       LPAD(TO_CHAR(ln_job), 5, '0'),
                                       'instance_id',
                                       2);
        end;
      else
        dbms_scheduler.create_job(job_name   => 'FAM_SEG' ||
                                                LPAD(TO_CHAR(ln_job),
                                                     5,
                                                     '0'),
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => true,
                                  comments   => 'PAGOS FAMILIA SEGURA');
      end if;
      commit;

    end loop;

  end sp_cr_cargaVC_job;

  ---------------

  Procedure Sp_cronograma(pn_emp    in number,
                          pn_mod    in number,
                          pn_suc    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number,
                          pn_ope    in number,
                          pn_sbo    in number,
                          pn_top    in number,
                          pn_tip    in number,
                          pd_fecini in date,
                          pd_fecfin in date,
                          pd_fecpro in date,
                          pn_mto11  out number,
                          pn_mto12  out number,
                          pn_mto13  out number,
                          pn_mto14  out number,
                          pn_mto15  out number) is

    -- *****************************************************************
    -- Nombre                     : Sp_cronograma
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.06.22
    -- Autor de Creación          : DCASTRO
    -- Uso                        : VALIDA CRONOGRAMA EN FSD611
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************

  begin

    --pagos
    begin
      select sum(ppimp11),
             sum(ppimp12),
             sum(ppimp13),
             sum(ppimp14),
             sum(ppimp15)
        into pn_mto11, pn_mto12, pn_mto13, pn_mto14, pn_mto15
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag between pd_fecini and pd_fecfin
         and rownum = 1;
    exception
      when others then
        insert into jaqz097_error values (pn_cta, pn_ope, 3, pd_fecpro);
    end;

  end Sp_cronograma;
  ---------------
  ---------------
  Procedure Sp_cr_gracia(pn_emp    in number,
                         pn_mod    in number,
                         pn_suc    in number,
                         pn_mda    in number,
                         pn_pap    in number,
                         pn_cta    in number,
                         pn_ope    in number,
                         pn_sbo    in number,
                         pn_top    in number,
                         pd_fecini in date,
                         pd_fecfin in date,
                         pn_numcuo out number) is

    -- *****************************************************************
    -- Nombre                     : Sp_cr_gracia
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.06.22
    -- Autor de Creación          : DCASTRO
    -- Uso                        : VALIDA SI CRONOGRAMA POSEE GRACIA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
    ln_numcuo number;

  begin

    begin
      --cuota con gracia
      select count(*)
        into ln_numcuo
        from fsd601 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.pptipo <> 'M'
         and a.ppfpag between pd_fecini and pd_fecfin;
    exception
      when no_data_found then
        ln_numcuo := 0;
    end;
    pn_numcuo := ln_numcuo;

  end Sp_cr_gracia;
  ---------------
  ---------------
  Procedure Sp_monto_calendarioSVC(pn_emp      in number,
                                   pn_mod      in number,
                                   pn_suc      in number,
                                   pn_mda      in number,
                                   pn_pap      in number,
                                   pn_cta      in number,
                                   pn_ope      in number,
                                   pn_sbo      in number,
                                   pn_top      in number,
                                   pn_tip      in number,
                                   pd_fecpro   in date,
                                   ln_mtoprima out number,
                                   ln_codVar   out number,
                                   lc_tip      out char) is

    -- *****************************************************************
    -- Nombre                     : Sp_monto_calendarioVC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.05.16
    -- Autor de Creación          : DCASTRO
    -- Uso                        : VALIDA MONTO CALENDARIO CREDITOS DESAFILIADOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2016.06.22
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se agrego llamada a sp_cronograma y busqueda para pagos realizados en mes de desembolso.
    --
    -- *****************************************************************

    cursor seguros_ii is
      select *
        from fpp001 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;

    cursor calendario_vida is
      select *
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;

    ln_canSeg number(2);
    --ln_codVar number(2);
    ld_fecan date;

    ld_fecini date;

    --ln_mtoprima number(17,2) ;
    ln_mto11 number(17, 2);
    ln_mto12 number(17, 2);
    ln_mto13 number(17, 2);
    ln_mto14 number(17, 2);
    ln_mto15 number(17, 2);

    lc_flag   char(1);
    ln_impAux number(17, 2);

    lc_flag11   char(1);
    ln_impAux11 number(17, 2);

    lc_flag13   char(1);
    ln_impAux13 number(17, 2);

    ld_pago date;
    --lc_tip char(1);
    ln_mtoseg  number(17, 2);
    ln_mtoseg1 number(17, 2);
    ln_mtoseg2 number(17, 2);
    ln_mtoseg3 number(17, 2);
    ln_mtoseg4 number(17, 2);
    ln_mtoseg5 number(17, 2);
    ln_mtoseg6 number(17, 2);

    ld_fecnew date;

    ld_fecfin date; -- 2016.06.21
    ln_numcuo number := 0;

  begin

    ld_fecini := to_date('01' || to_char(pd_fecpro, 'mmyyyy'), 'ddmmyyyy');
    lc_tip    := null;

    ln_mtoseg1 := 6.5; --soles
    ln_mtoseg2 := 12; --soles
    ln_mtoseg3 := 24; --soles

    ln_mtoseg4 := 1.81; --dolares
    ln_mtoseg5 := 3.33; --dolares
    ln_mtoseg6 := 6.67; --dolares

    begin

      begin
        --pagos
        /*begin
          select sum(ppimp11),
                 sum(ppimp12),
                 sum(ppimp13),
                 sum(ppimp14),
                 sum(ppimp15)
            into ln_mto11, ln_mto12, ln_mto13, ln_mto14, ln_mto15
            from fsd611 a
           where a.pgcod = pn_emp
             and a.ppmod = pn_mod
             and a.ppsuc = pn_suc
             and a.ppmda = pn_mda
             and a.pppap = pn_pap
             and a.ppcta = pn_cta
             and a.ppoper = pn_ope
             and a.ppsbop = pn_sbo
             and a.pptope = pn_top
             and a.ppfpag between ld_fecini and pd_fecpro;
        exception
          when others then
            insert into jaqz097_error
            values
              (pn_cta, pn_ope, 3, pd_fecpro);
        end;*/
        begin
          PQ_CR_FAMSEGURA.sp_cronograma(pn_emp    => pn_emp,
                                        pn_mod    => pn_mod,
                                        pn_suc    => pn_suc,
                                        pn_mda    => pn_mda,
                                        pn_pap    => pn_pap,
                                        pn_cta    => pn_cta,
                                        pn_ope    => pn_ope,
                                        pn_sbo    => pn_sbo,
                                        pn_top    => pn_top,
                                        pn_tip    => pn_tip,
                                        pd_fecini => ld_fecini,
                                        pd_fecfin => pd_fecpro,
                                        pd_fecpro => pd_fecpro,
                                        pn_mto11  => ln_mto11,
                                        pn_mto12  => ln_mto12,
                                        pn_mto13  => ln_mto13,
                                        pn_mto14  => ln_mto14,
                                        pn_mto15  => ln_mto15);
        end;

        --   when no_data_found then
        ld_fecnew := add_months(ld_fecini, -1); -- para menos de un mes

        ln_mto11 := nvl(ln_mto11, 0);
        ln_mto12 := nvl(ln_mto12, 0);
        ln_mto13 := nvl(ln_mto13, 0);
        ln_mto14 := nvl(ln_mto14, 0);
        ln_mto15 := nvl(ln_mto15, 0);

        if ln_mto11 = 0 and ln_mto12 = 0 and ln_mto13 = 0 and ln_mto14 = 0 and
           ln_mto15 = 0 then

          /*          begin
            select sum(ppimp11),
                   sum(ppimp12),
                   sum(ppimp13),
                   sum(ppimp14),
                   sum(ppimp15)
              into ln_mto11, ln_mto12, ln_mto13, ln_mto14, ln_mto15
              from fsd611 a
             where a.pgcod = pn_emp
               and a.ppmod = pn_mod
               and a.ppsuc = pn_suc
               and a.ppmda = pn_mda
               and a.pppap = pn_pap
               and a.ppcta = pn_cta
               and a.ppoper = pn_ope
               and a.ppsbop = pn_sbo
               and a.pptope = pn_top
               and a.ppfpag between ld_fecnew and pd_fecpro;
          exception
            when others then
              insert into jaqz097_error
              values
                (pn_cta, pn_ope, 3, pd_fecpro);
          end;*/

          begin
            PQ_CR_FAMSEGURA.sp_cronograma(pn_emp    => pn_emp,
                                          pn_mod    => pn_mod,
                                          pn_suc    => pn_suc,
                                          pn_mda    => pn_mda,
                                          pn_pap    => pn_pap,
                                          pn_cta    => pn_cta,
                                          pn_ope    => pn_ope,
                                          pn_sbo    => pn_sbo,
                                          pn_top    => pn_top,
                                          pn_tip    => pn_tip,
                                          pd_fecini => ld_fecnew,
                                          pd_fecfin => pd_fecpro,
                                          pd_fecpro => pd_fecpro,
                                          pn_mto11  => ln_mto11,
                                          pn_mto12  => ln_mto12,
                                          pn_mto13  => ln_mto13,
                                          pn_mto14  => ln_mto14,
                                          pn_mto15  => ln_mto15);
          end;

          ln_mto11 := nvl(ln_mto11, 0);
          ln_mto12 := nvl(ln_mto12, 0);
          ln_mto13 := nvl(ln_mto13, 0);
          ln_mto14 := nvl(ln_mto14, 0);
          ln_mto15 := nvl(ln_mto15, 0);

          if ln_mto11 = 0 and ln_mto12 = 0 and ln_mto13 = 0 and
             ln_mto14 = 0 and ln_mto15 = 0 then

            ld_fecnew := add_months(ld_fecini, -2); -- para menos de 2 meses

            /* begin

              select sum(ppimp11),
                     sum(ppimp12),
                     sum(ppimp13),
                     sum(ppimp14),
                     sum(ppimp15)
                into ln_mto11, ln_mto12, ln_mto13, ln_mto14, ln_mto15
                from fsd611 a
               where a.pgcod = pn_emp
                 and a.ppmod = pn_mod
                 and a.ppsuc = pn_suc
                 and a.ppmda = pn_mda
                 and a.pppap = pn_pap
                 and a.ppcta = pn_cta
                 and a.ppoper = pn_ope
                 and a.ppsbop = pn_sbo
                 and a.pptope = pn_top
                 and a.ppfpag between ld_fecnew and pd_fecpro;
            exception
              when others then
                insert into jaqz097_error
                values
                  (pn_cta, pn_ope, 3, pd_fecpro);
            end;*/

            begin
              PQ_CR_FAMSEGURA.sp_cronograma(pn_emp    => pn_emp,
                                            pn_mod    => pn_mod,
                                            pn_suc    => pn_suc,
                                            pn_mda    => pn_mda,
                                            pn_pap    => pn_pap,
                                            pn_cta    => pn_cta,
                                            pn_ope    => pn_ope,
                                            pn_sbo    => pn_sbo,
                                            pn_top    => pn_top,
                                            pn_tip    => pn_tip,
                                            pd_fecini => ld_fecnew,
                                            pd_fecfin => pd_fecpro,
                                            pd_fecpro => pd_fecpro,
                                            pn_mto11  => ln_mto11,
                                            pn_mto12  => ln_mto12,
                                            pn_mto13  => ln_mto13,
                                            pn_mto14  => ln_mto14,
                                            pn_mto15  => ln_mto15);
            end;

            --2016.06.21
            ln_mto11 := nvl(ln_mto11, 0);
            ln_mto12 := nvl(ln_mto12, 0);
            ln_mto13 := nvl(ln_mto13, 0);
            ln_mto14 := nvl(ln_mto14, 0);
            ln_mto15 := nvl(ln_mto15, 0);

            if ln_mto11 = 0 and ln_mto12 = 0 and ln_mto13 = 0 and
               ln_mto14 = 0 and ln_mto15 = 0 then

              ld_fecfin := add_months(pd_fecpro, 1); -- Se agrega un mes a fecha de proces, puede ser cuota adelantada

              begin
                PQ_CR_FAMSEGURA.sp_cronograma(pn_emp    => pn_emp,
                                              pn_mod    => pn_mod,
                                              pn_suc    => pn_suc,
                                              pn_mda    => pn_mda,
                                              pn_pap    => pn_pap,
                                              pn_cta    => pn_cta,
                                              pn_ope    => pn_ope,
                                              pn_sbo    => pn_sbo,
                                              pn_top    => pn_top,
                                              pn_tip    => pn_tip,
                                              pd_fecini => ld_fecini,
                                              pd_fecfin => ld_fecfin,
                                              pd_fecpro => pd_fecpro,
                                              pn_mto11  => ln_mto11,
                                              pn_mto12  => ln_mto12,
                                              pn_mto13  => ln_mto13,
                                              pn_mto14  => ln_mto14,
                                              pn_mto15  => ln_mto15);
              end;
            end if;
            --2016.06.21

          end if;
        end if;

        case
          when ln_mto11 = ln_mtoseg1 or ln_mto11 = ln_mtoseg2 or
               ln_mto11 = ln_mtoseg3 or
               ((ln_mto11 = ln_mtoseg4 or ln_mto11 = ln_mtoseg5 or
               ln_mto11 = ln_mtoseg6) and pn_mda = 101) then
            ln_mtoseg := ln_mto11;
            ln_codVar := 1;
          when ln_mto12 = ln_mtoseg1 or ln_mto12 = ln_mtoseg2 or
               ln_mto12 = ln_mtoseg3 or
               ((ln_mto12 = ln_mtoseg4 or ln_mto12 = ln_mtoseg5 or
               ln_mto12 = ln_mtoseg6) and pn_mda = 101) then
            ln_mtoseg := ln_mto12;
            ln_codVar := 2;
          when ln_mto13 = ln_mtoseg1 or ln_mto13 = ln_mtoseg2 or
               ln_mto13 = ln_mtoseg3 or
               ((ln_mto13 = ln_mtoseg4 or ln_mto13 = ln_mtoseg5 or
               ln_mto13 = ln_mtoseg6) and pn_mda = 101) then
            ln_mtoseg := ln_mto13;
            ln_codVar := 3;
          when ln_mto14 = ln_mtoseg1 or ln_mto14 = ln_mtoseg2 or
               ln_mto14 = ln_mtoseg3 or
               ((ln_mto14 = ln_mtoseg4 or ln_mto14 = ln_mtoseg5 or
               ln_mto14 = ln_mtoseg6) and pn_mda = 101) then
            ln_mtoseg := ln_mto14;
            ln_codVar := 4;
          when ln_mto15 = ln_mtoseg1 or ln_mto15 = ln_mtoseg2 or
               ln_mto15 = ln_mtoseg3 or
               ((ln_mto15 = ln_mtoseg4 or ln_mto15 = ln_mtoseg5 or
               ln_mto15 = ln_mtoseg6) and pn_mda = 101) then
            ln_mtoseg := ln_mto15;
            ln_codVar := 5;
          else
            ln_codVar := 0;
        end case;

        --si monto de prima es igual a PP1IMP
        case
          when ln_codVar = 1 then
            ln_mtoprima := ln_mto11;
            --2016.06.22
            if ln_mtoprima <> ln_mtoseg then
              begin
                PQ_CR_FAMSEGURA.sp_cr_gracia(pn_emp    => pn_emp,
                                             pn_mod    => pn_mod,
                                             pn_suc    => pn_suc,
                                             pn_mda    => pn_mda,
                                             pn_pap    => pn_pap,
                                             pn_cta    => pn_cta,
                                             pn_ope    => pn_ope,
                                             pn_sbo    => pn_sbo,
                                             pn_top    => pn_top,
                                             pd_fecini => ld_fecini,
                                             pd_fecfin => ld_fecfin,
                                             pn_numcuo => ln_numcuo);
              end;
              if ln_numcuo > 0 then
                if ln_mtoseg <> 0 then
                  if ln_mtoprima / ln_mtoseg = 2 then
                    --si es el doble y tiene gracia
                    ln_mtoprima := ln_mtoseg;
                  end if;
                end if;  
              end if;
            end if;
            --2016.06.22

            if ln_mtoprima = ln_mtoseg then
              ln_impAux := ln_mtoseg;
              for h in calendario_vida loop
                if ln_impAux = h.ppimp11 then

                  lc_flag := 'S';
                else
                  --2016.06.22
                  if ln_numcuo > 0 then
                    lc_flag := 'S';
                  else
                    --2016.06.22
                    lc_flag := 'N';
                    exit;
                  end if; --2016.06.22

                end if;
                ln_impAux := h.ppimp11;
              end loop;

            end if;
          when ln_codVar = 2 then
            ln_mtoprima := ln_mto12;
            --2016.06.22
            if ln_mtoprima <> ln_mtoseg then
              begin
                PQ_CR_FAMSEGURA.sp_cr_gracia(pn_emp    => pn_emp,
                                             pn_mod    => pn_mod,
                                             pn_suc    => pn_suc,
                                             pn_mda    => pn_mda,
                                             pn_pap    => pn_pap,
                                             pn_cta    => pn_cta,
                                             pn_ope    => pn_ope,
                                             pn_sbo    => pn_sbo,
                                             pn_top    => pn_top,
                                             pd_fecini => ld_fecini,
                                             pd_fecfin => ld_fecfin,
                                             pn_numcuo => ln_numcuo);
              end;
              if ln_numcuo > 0 then
                if ln_mtoseg <> 0 then
                  if ln_mtoprima / ln_mtoseg = 2 then
                    --si es el doble y tiene gracia
                    ln_mtoprima := ln_mtoseg;
                  end if;
                end if;  
              end if;
            end if;
            --2016.06.22
            if ln_mtoprima = ln_mtoseg then
              ln_impAux := ln_mtoseg;
              for h in calendario_vida loop
                if ln_impAux = h.ppimp12 then

                  lc_flag := 'S';
                else
                  --2016.06.22
                  if ln_numcuo > 0 then
                    lc_flag := 'S';
                  else
                    --2016.06.22
                    lc_flag := 'N';
                    exit;
                  end if; --2016.06.22
                end if;
                ln_impAux := h.ppimp12;
              end loop;

            end if;
          when ln_codVar = 3 then
            ln_mtoprima := ln_mto13;
            --2016.06.22
            if ln_mtoprima <> ln_mtoseg then
              begin
                PQ_CR_FAMSEGURA.sp_cr_gracia(pn_emp    => pn_emp,
                                             pn_mod    => pn_mod,
                                             pn_suc    => pn_suc,
                                             pn_mda    => pn_mda,
                                             pn_pap    => pn_pap,
                                             pn_cta    => pn_cta,
                                             pn_ope    => pn_ope,
                                             pn_sbo    => pn_sbo,
                                             pn_top    => pn_top,
                                             pd_fecini => ld_fecini,
                                             pd_fecfin => ld_fecfin,
                                             pn_numcuo => ln_numcuo);
              end;
              if ln_numcuo > 0 then
                if ln_mtoseg <> 0 then
                  if ln_mtoprima / ln_mtoseg = 2 then
                    --si es el doble y tiene gracia
                    ln_mtoprima := ln_mtoseg;
                  end if;
                end if;  
              end if;
            end if;
            --2016.06.22
            if ln_mtoprima = ln_mtoseg then
              ln_impAux := ln_mtoseg;
              for h in calendario_vida loop
                if ln_impAux = h.ppimp13 then

                  lc_flag := 'S';
                else
                  --2016.06.22
                  if ln_numcuo > 0 then
                    lc_flag := 'S';
                  else
                    --2016.06.22
                    lc_flag := 'N';
                    exit;
                  end if; --2016.06.22
                end if;
                ln_impAux := h.ppimp13;
              end loop;

            end if;
          when ln_codVar = 4 then
            ln_mtoprima := ln_mto14;
            --2016.06.22
            if ln_mtoprima <> ln_mtoseg then
              begin
                PQ_CR_FAMSEGURA.sp_cr_gracia(pn_emp    => pn_emp,
                                             pn_mod    => pn_mod,
                                             pn_suc    => pn_suc,
                                             pn_mda    => pn_mda,
                                             pn_pap    => pn_pap,
                                             pn_cta    => pn_cta,
                                             pn_ope    => pn_ope,
                                             pn_sbo    => pn_sbo,
                                             pn_top    => pn_top,
                                             pd_fecini => ld_fecini,
                                             pd_fecfin => ld_fecfin,
                                             pn_numcuo => ln_numcuo);
              end;
              if ln_numcuo > 0 then
                if ln_mtoseg <> 0 then
                  if ln_mtoprima / ln_mtoseg = 2 then
                    --si es el doble y tiene gracia
                    ln_mtoprima := ln_mtoseg;
                  end if;
                end if;  
              end if;
            end if;
            --2016.06.22
            if ln_mtoprima = ln_mtoseg then
              ln_impAux := ln_mtoseg;
              for h in calendario_vida loop
                if ln_impAux = h.ppimp14 then

                  lc_flag := 'S';
                else
                  --2016.06.22
                  if ln_numcuo > 0 then
                    lc_flag := 'S';
                  else
                    --2016.06.22
                    lc_flag := 'N';
                    exit;
                  end if; --2016.06.22
                end if;
                ln_impAux := h.ppimp14;
              end loop;
            end if;
          when ln_codVar = 5 then
            ln_mtoprima := ln_mto15;
            --2016.06.22
            if ln_mtoprima <> ln_mtoseg then
              begin
                PQ_CR_FAMSEGURA.sp_cr_gracia(pn_emp    => pn_emp,
                                             pn_mod    => pn_mod,
                                             pn_suc    => pn_suc,
                                             pn_mda    => pn_mda,
                                             pn_pap    => pn_pap,
                                             pn_cta    => pn_cta,
                                             pn_ope    => pn_ope,
                                             pn_sbo    => pn_sbo,
                                             pn_top    => pn_top,
                                             pd_fecini => ld_fecini,
                                             pd_fecfin => ld_fecfin,
                                             pn_numcuo => ln_numcuo);
              end;
              if ln_numcuo > 0 then
                if ln_mtoseg <> 0 then
                  if ln_mtoprima / ln_mtoseg = 2 then
                    --si es el doble y tiene gracia
                    ln_mtoprima := ln_mtoseg;
                  end if;
                end if;  
              end if;
            end if;
            --2016.06.22
            if ln_mtoprima = ln_mtoseg then
              ln_impAux := ln_mtoseg;
              for h in calendario_vida loop
                if ln_impAux = h.ppimp15 then

                  lc_flag := 'S';
                else
                  --2016.06.22
                  if ln_numcuo > 0 then
                    lc_flag := 'S';
                  else
                    --2016.06.22
                    lc_flag := 'N';
                    exit;
                  end if; --2016.06.22
                end if;
                ln_impAux := h.ppimp15;
              end loop;
            end if;
          else
            ln_mtoprima := 0;
        end case;

      end;
      ---validar cuota pagada
      --ln_codvar / ln_mtoprima

      if nvl(ln_mtoprima, 0) > 0 then
        begin
          PQ_CR_FAMSEGURA.sp_cr_validapago(ln_pgcod     => pn_emp,
                                           ln_modulo    => pn_mod,
                                           ln_sucursal  => pn_suc,
                                           ln_moneda    => pn_mda,
                                           ln_papel     => pn_pap,
                                           ln_cuenta    => pn_cta,
                                           ln_operacion => pn_ope,
                                           ln_suboper   => pn_sbo,
                                           ln_tope      => pn_top,
                                           ld_fechpag   => pd_fecpro,
                                           ld_pd_fecini => ld_fecini,
                                           ld_pd_fecfin => pd_fecpro,
                                           ln_codvar    => ln_codvar,
                                           ln_monto     => ln_mtoprima,
                                           lc_indica    => 'D', ---cambiar
                                           ln_numcuo    => ln_numcuo);
        end;
      end if;
      ---

      /* end loop;*/
    end;

  end Sp_monto_calendarioSVC;
  ----------------------
  PROCEDURE sp_cr_listado(pd_fecini in date, pd_fecfin in date) is

    cursor listado(pd_fecini date, pd_fecfin date) is

      select f.pgcod  pgcod,
             f.ppmod  modulo,
             f.ppsuc  sucursal,
             f.ppmda  moneda,
             f.pppap  papel,
             f.ppcta  cuenta,
             f.ppoper operacion,
             f.ppsbop suboper,
             f.pptope tope /*,
                                                                                                                                                             f.ppfpag fechapag*/

        from fsd611 f, fsd010 g, fsd602 h
       where f.ppcta = g.aocta
         and f.ppoper = g.aooper
         and f.ppmod in (select modulo from fst111 where dscod = 50)
         and h.pgcod = f.pgcod
         and h.ppmod = f.ppmod
            --and h.ppsuc
         and h.ppmda = f.ppmda
         and h.pppap = f.pppap
         and h.ppcta = f.ppcta
         and h.ppoper = f.ppoper
         and h.d602co = 'S'
         and h.d602fc between (pd_fecini) and (pd_fecfin)
         and f.ppfpag = h.ppfpag
         and ((g.aofe99 > (pd_fecini) and g.aostat = 99) or
             g.aofe99 = to_Date('01.01.0001', 'dd.mm.yyyy'))
            /*and ((ppimp11 + ppimp12 + ppimp13 + ppimp14) in (1.5, 2.5) or
                                                 (h.ppmda = 101 and
                                                 (ppimp11 + ppimp12 + ppimp13 + ppimp14) < 1))*/
         and f.ppcta <> 999999999
      -- and f.ppcta in (1180431, 1584411, 1386736)
      /*and h.d602mo = 30        and h.d602tr not in (355,356,357,358,359,360,381,390,391,392)*/
       group by f.pgcod,
                f.ppmod,
                f.ppsuc,
                f.ppmda,
                f.pppap,
                f.ppcta,
                f.ppoper,
                f.ppsbop,
                f.pptope /*,f.ppfpag*/

      minus (select pgcod,
                    aomod,
                    aosuc,
                    aomda,
                    aopap,
                    aocta,
                    aooper,
                    aosbop,
                    aotope
               from fpp001
                where (sgcod in (200, 201, 202) or sgcod in ( select tp1nro3
                                                                from fst198 a
                                                               Where Tp1cod   = 1
                                                                 and Tp1cod1  = 10898
                                                                 and Tp1corr1 = 18
                                                                 and tp1corr3 = 2
                                                                 and tp1nro1 = 1) ) --2016.07.07
              group by pgcod,
                       aomod,
                       aosuc,
                       aomda,
                       aopap,
                       aocta,
                       aooper,
                       aosbop,
                       aotope);

    ln_numero number := 0;
    ln_corr   number := 1;
  begin

    execute immediate 'truncate table jaqy144';
    --  execute immediate 'truncate table jaqy145';

    for i in listado(pd_fecini, pd_fecfin) loop

      insert into jaqy144
        (jaqy144corr,
         jaqy144pgcod,
         jaqy144mod,
         jaqy144suc,
         jaqy144mda,
         jaqy144pap,
         jaqy144cta,
         jaqy144ope,
         jaqy144sbop,
         jaqy144top)
      values
        (ln_corr,
         i.pgcod,
         i.modulo,
         i.sucursal,
         i.moneda,
         i.papel,
         i.cuenta,
         i.operacion,
         i.suboper,
         i.tope);
      ln_corr   := ln_corr + 1;
      ln_numero := ln_numero + 1;
      if ln_corr = 500 then
        commit;
        ln_numero := 0;
      end if;
    end loop;
    commit;
    ----
    begin
      select max(jaqy144corr) into ln_corr from jaqy144;
    end;
    ln_corr := ln_corr + 1;
    ----

  end sp_cr_listado;

  ----------------------------------------------------------------------------------------------
  procedure sp_cr_listadoII(pd_fecini in date,
                            pd_fecfin in date,
                            P_N_INI   in number,
                            P_N_FIN   in number) is

    ln_imp1 number(10, 2);

    ln_imp2 number(10, 2);
    ln_imp3 number(10, 2);
    ln_imp4 number(10, 2);
    ln_imp5 number(10, 2);
    --estado     varchar2(2);
    lc_mespago varchar2(2);
    lc_mescuot varchar2(2);
    ln_monto   number(10, 2);

    lc_tip char(1) := null;
    pc_tip char(1) := null;

    ln_codvar   NUMBER;
    ln_mtoprima number(10, 2);

    cursor llenar is

      select j.jaqy144pgcod,
             j.jaqy144mod,
             j.jaqy144suc,
             j.jaqy144mda,
             j.jaqy144pap,
             j.jaqy144cta,
             j.jaqy144ope,
             j.jaqy144sbop,
             j.jaqy144top,
             j.jaqy144fchpag
        from jaqy144 j
       where jaqy144corr >= P_N_INI
         and jaqy144corr <= P_N_FIN;
    /* jaqy144cta = 178636 ;*/

  begin
    for i in llenar loop
      pq_cr_famsegura.Sp_monto_calendarioVCC(i.jaqy144pgcod,
                                             i.jaqy144mod,
                                             i.jaqy144suc,
                                             i.jaqy144mda,
                                             i.jaqy144pap,
                                             i.jaqy144cta,
                                             i.jaqy144ope,
                                             i.jaqy144sbop,
                                             i.jaqy144top,
                                             pc_tip,
                                             pd_fecfin,
                                             ln_mtoprima,
                                             ln_codvar,
                                             lc_tip);

    end loop;
  end sp_cr_listadoII;
  --------------------------------------------------------------------------------------------
  /*procedure sp_cr_estado(ln_pgcod     in number,
                        ln_modulo    in number,
                        ln_sucursal  in number,
                        ln_moneda    in number,
                        ln_papel     in number,
                        ln_cuenta    in number,
                        ln_operacion in number,
                        ln_suboper   in number,
                        ln_tope      in number,
                        --ld_fechpag   in date,
                        ld_pd_fecini in date,
                        ld_pd_fecfin in date,
                        ln_monto     out number,
                        ln_imp1      out number,
                        ln_imp2      out number,
                        ln_imp3      out number,
                        ln_imp4      out number,
                        ln_imp5      out number,
                        --estado       out varchar2,
                        lc_mespago   out varchar2,
                        lc_mescuot   out varchar2) is

   --  ld_fchpago date;

   lc_flag   varchar2(2) := 'N';

  -- ln_corr number := 1;
   -- ln_monto number(10, 2);

   lc_tip      char(1) := null;
   ln_mtoprima number(10, 2);
   ln_codvar number;

   lc_variable varchar2(2);

   cursor cuotas is
     select /*+ parallel(h,2)*/
  /* h.d602mo modulo,
   h.d602su sucursal,
   h.d602tr transaccion,
   h.d602re relacion,
   h.d602fc fchcontable,

   h.pp1stat lc_estado,
   i.ppfpag ld_fchcuo,
   h.d602fc ld_fchpago,
   to_char(to_date(i.ppfpag, 'dd/mm/rrrr'), 'MM') lc_mespago,
   to_char(to_date(ld_pd_fecini, 'dd/mm/rrrr'), 'MM') lc_mescuot,
   sum(i.pp1imp11) ln_imp1,
   sum(i.pp1imp12) ln_imp2,
   sum(i.pp1imp13) ln_imp3,
   sum(i.pp1imp14) ln_imp4,
   sum(i.pp1imp15) ln_imp5

    from fsd602 h, fsd612 i
   where h.d602cd = i.pgcod
     and h.d602co = 'S'
     and h.d602fc between (ld_pd_fecini) and (ld_pd_fecfin)
     and i.pgcod = h.pgcod
     and i.ppcta = h.ppcta
     and i.ppoper = h.ppoper
     and i.ppfpag = h.ppfpag
     and i.ppmod = h.ppmod
     and i.ppsuc = h.ppsuc
     and i.ppmda = h.ppmda
     and i.pppap = h.pppap
     and i.pp1nump = h.pp1nump
     and i.pgcod = ln_pgcod
     and i.ppmod = ln_modulo
     and i.ppsuc = ln_sucursal
     and i.ppmda = ln_moneda
     and i.pppap = ln_papel
     and i.ppcta = ln_cuenta
     and i.ppoper = ln_operacion
  /* and i.ppsbop = ln_suboper
                                                           and i.pptope = ln_tope*/
  /*   group by h.d602mo,
                h.d602su,
                h.d602tr,
                h.d602re,
                h.d602fc,
                h.pp1stat,
                i.ppfpag,
                h.d602fc;

  begin

    for j in cuotas loop
      lc_flag := 'N';

      begin

        select distinct ('S')
          into lc_variable
          from fsh016
         where PGCOD = 1
           and HCMOD = j.modulo
           and HSUCOR = j.sucursal
           and HTRAN = j.transaccion
           and HNREL = j.relacion
           and HFCON = j.fchcontable
           and hrubro in ('2524020000008', '2514020000008');
      exception
        when others then
          lc_variable := 'N';

      end;

      if lc_variable = 'S' then

        begin

          pq_cr_famsegura.Sp_monto_calendarioVCC(ln_pgcod,
                                                ln_modulo,
                                                ln_sucursal,
                                                ln_moneda,
                                                ln_papel,
                                                ln_cuenta,
                                                ln_operacion,
                                                ln_suboper,
                                                ln_tope,
                                                lc_tip,
                                                j.ld_fchpago,
                                                ln_mtoprima,
                                                ln_codvar,
                                                lc_tip);
        end;




      end if;
    end loop;

  end sp_cr_estado;*/
  --------------------------------------------------------------------------------------------
  procedure sp_cr_insertjaqy145(ln_pgcod     in number,
                                ln_modulo    in number,
                                ln_sucursal  in number,
                                ln_moneda    in number,
                                ln_papel     in number,
                                ln_cuenta    in number,
                                ln_operacion in number,
                                ln_suboper   in number,
                                ln_tope      in number,
                                ld_fchcuo    in date,
                                ld_fechpag   in date,
                                ln_monto     in number,
                                ln_imp1      in number,
                                ln_imp2      in number,
                                ln_imp3      in number,
                                ln_imp4      in number,
                                ln_imp5      in number) is
    ln_corr number;

  begin
    begin
      select count(*) into ln_corr from jaqy145;
    exception
      when no_data_found then
        ln_corr := 0;
    end;
    INSERT INTO JAQy145
      (Jaqy145corr,
       Jaqy145pgcod,
       Jaqy145mod,
       Jaqy145suc,
       Jaqy145mda,
       Jaqy145pap,
       Jaqy145cta,
       Jaqy145ope,
       Jaqy145sbop,
       Jaqy145top,
       JAQY145FCHCUO,
       Jaqy145fchpag,
       JAQY145IMPSG,
       Jaqy145imp1,
       Jaqy145imp2,
       Jaqy145imp3,
       Jaqy145imp4,
       Jaqy145imp5,
       JAQY145IND)
    VALUES
      (ln_corr + 1,
       ln_pgcod,
       ln_modulo,
       ln_sucursal,
       ln_moneda,
       ln_papel,
       ln_cuenta,
       ln_operacion,
       ln_suboper,
       ln_tope,
       ld_fchcuo,
       ld_fechpag,
       ln_monto,
       ln_imp1,
       ln_imp2,
       ln_imp3,
       ln_imp4,
       ln_imp5,
       'D');

    commit;

  end sp_cr_insertjaqy145;

  ------------------------------------------------------------------------------
  procedure sp_cr_cliente(ln_pgcod     in number,
                          ln_modulo    in number,
                          ln_sucursal  in number,
                          ln_moneda    in number,
                          ln_papel     in number,
                          ln_cuenta    in number,
                          ln_operacion in number,
                          ln_suboper   in number,
                          ln_tope      in number) is
    ln_pais     number;
    ln_petdoc   number;
    ln_doc      varchar2(12);
    lc_nombre   varchar2(250);
    ld_fchnac   date;
    ld_fecha    date;
    ld_fechades date;
    estado      number;
    lc_estado   varchar2(50);
    numcre      varchar2(22);
  begin
    begin
      -- principales
      select f.pepais, f.petdoc, f.pendoc
        into ln_pais, ln_petdoc, ln_doc
        from fsr008 f
       where f.pgcod = 1
         and f.ctnro = ln_cuenta
         and f.ttcod = 1
         and f.cttfir = 'T';
    exception
      when others then
        null;
    end;

    begin
      --nombre del cliente
      select f.penom
        into lc_nombre
        from fsd001 f
       where f.pepais = ln_pais
         and f.petdoc = ln_petdoc
         and f.pendoc = ln_doc;
    exception
      when others then
        null;

    end;

    begin
      --fecha de nacimiento
      select f.pffnac
        into ld_fchnac
        from fsd002 f
       where f.pfpais = ln_pais
         and f.pftdoc = ln_petdoc
         and f.pfndoc = ln_doc;
    exception
      when others then
        null;
    end;

    begin
      --fecha de cancelacion
      select b.aofe99
        into ld_fecha
        from FSD010 b
       where b.pgcod = ln_pgcod
         and b.aomod = ln_modulo
         and b.aosuc = ln_sucursal
         and b.aomda = ln_moneda
         and b.aopap = ln_papel
         and b.aocta = ln_cuenta
         and b.aooper = ln_operacion
         and b.aosbop = ln_suboper
         and b.aotope = ln_tope
         and b.aostat = 99;
    exception
      when others then
        NULL;
    end;

    begin
      --fecha de cancelacion
      select b.aofval, b.aostat
        into ld_fechades, estado
        from FSD010 b
       where b.pgcod = ln_pgcod
         and b.aomod = ln_modulo
         and b.aosuc = ln_sucursal
         and b.aomda = ln_moneda
         and b.aopap = ln_papel
         and b.aocta = ln_cuenta
         and b.aooper = ln_operacion
         and b.aosbop = ln_suboper
         and b.aotope = ln_tope;
      --    and b.aostat <> 99;
    exception
      when others then
        NULL;
    end;

    begin
      --fecha de cancelacion
      select f.cenom into lc_estado from fst026 f where f.cecod = estado;
      --    and b.aostat <> 99;
    exception
      when others then
        NULL;
    end;

    begin

      numcre := lpad(Trim(to_char(ln_cuenta)), 9, '0') ||
                lpad(Trim(to_char(ln_moneda)), 4, '0') ||
                lpad(Trim(to_char(ln_operacion)), 9, '0');
    end;

    begin
      update jaqy145 j
         set j.jaqy145tit  = lc_nombre,
             j.jaqy145doc  = ln_doc,
             j.jaqy145fnac = ld_fchnac,
             j.jaqy145fcan = ld_fecha,
             j.jaqy145fdes = ld_fechades,
             j.jaqy145est  = lc_estado,
             j.jaqy145nroc = numcre
       where j.jaqy145pgcod = ln_pgcod
         and j.jaqy145mod = ln_modulo
         and j.jaqy145suc = ln_sucursal
         and j.jaqy145mda = ln_moneda
         and j.jaqy145pap = ln_papel
         and j.jaqy145cta = ln_cuenta
         and j.jaqy145ope = ln_operacion
         and j.jaqy145sbop = ln_suboper
         and j.jaqy145top = ln_tope;

      commit;
    end;
  end sp_cr_cliente;
  --------------------------------------------------------------------------
  procedure sp_cr_datoscli(P_N_INI in number, P_N_FIN in number) is

    cursor datos is

      select *
        from jaqy145
       where jaqy145corr >= P_N_INI
         and jaqy145corr <= P_N_FIN;

  begin
    for i in datos loop
      pq_cr_famsegura.sp_cr_cliente(i.jaqy145pgcod,
                                    i.jaqy145mod,
                                    i.jaqy145suc,
                                    i.jaqy145mda,
                                    i.jaqy145pap,
                                    i.jaqy145cta,
                                    i.jaqy145ope,
                                    i.jaqy145sbop,
                                    i.jaqy145top);
    end loop;

  end sp_cr_datoscli;
  -----------------------------------------------------------------------------
  procedure sp_cr_jobcliente is
    ln_ini      number;
    ln_fin      number;
    ln_divisor  number := 5000;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    ld_finmes   date;
    ln_contador number;
    ln_num      number := 1;
    lc_hostname varchar2(64);

  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;

    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD', --'BANTPROD',
                                    tabname          => 'JAQY145',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;

    begin
      select ceil(count(*) / ln_divisor) into ln_contador from jaqy145;
    end;

    ln_ini := 1;
    ln_fin := 5000;
    WHILE ln_num <= ln_contador LOOP

      lc_variable := 'begin ' || '  pq_cr_famsegura.sp_cr_datoscli(' ||
                     ln_ini || ',' || ln_fin || ' );' || ' End;';
      ln_job      := ln_job + 1;
      if UPPER(lc_hostname) in ('BTRAC2051', 'BTRAC2052') then
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;

      ln_ini := ln_fin + 1;
      ln_fin := ln_ini + ln_divisor - 1;
      ln_num := ln_num + 1;
      commit;
    END LOOP;

  end sp_cr_jobcliente;

  ----------------------------------------------------------------------------
  procedure sp_cr_jobjaqy145(pd_fecini in date, pd_fecfin in date) is
    ln_ini      number;
    ln_fin      number;
    ln_divisor  number := 5000;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    ld_finmes   date;
    ln_contador number;
    ln_num      number := 1;
    lc_hostname varchar2(64);

  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD', --'BANTPROD',
                                    tabname          => 'JAQY144',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;

    begin
      select ceil(count(*) / ln_divisor) into ln_contador from jaqy144;
    end;

    ln_ini := 1;
    ln_fin := 5000;
    WHILE ln_num <= ln_contador LOOP

      lc_variable := 'begin ' || '  pq_cr_famsegura.sp_cr_listadoII(''' ||
                     pd_fecini || ''',''' || pd_fecfin || ''',' || ln_ini || ',' ||
                     ln_fin || ' );' || ' End;';
      ln_job      := ln_job + 1;
      if UPPER(lc_hostname) in ('BTRAC2051', 'BTRAC2052') then
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;

      ln_ini := ln_fin + 1;
      ln_fin := ln_ini + ln_divisor - 1;
      ln_num := ln_num + 1;
      commit;
    END LOOP;

  end sp_cr_jobjaqy145;

  ----------------------------------------------------------------------------
  procedure sp_cr_llenardatosI(pd_fecini in date, pd_fecfin in date) is
  begin

    begin
      --- llena jaqy144
      pq_cr_famsegura.sp_cr_listado(pd_fecini, pd_fecfin);
    end;

    begin
      -- llena desafiliados jaqy145
      pq_cr_famsegura.sp_cr_jobjaqy145(pd_fecini, pd_fecfin);
    end;

    /* begin
      -- completa datos jaqy145 (Afiliados y desafiliados)
        pq_cr_famsegura.sp_cr_jobcliente;
    end;*/

    commit;
  end sp_cr_llenardatosI;
  ----------------------------------------------------------------------------
  procedure sp_cr_llenardatosII is
  begin

    begin
      -- completa datos jaqy145 (Afiliados y desafiliados)
      pq_cr_famsegura.sp_cr_jobcliente;
    end;

    commit;
  end sp_cr_llenardatosII;

  --------------------------------------------------------------------------
  PROCEDURE sp_cr_listado_SINVC(pd_fecini in date, pd_fecfin in date) is

    cursor listado(pd_fecini date, pd_fecfin date) is

      select f.pgcod  pgcod,
             f.ppmod  modulo,
             f.ppsuc  sucursal,
             f.ppmda  moneda,
             f.pppap  papel,
             f.ppcta  cuenta,
             f.ppoper operacion,
             f.ppsbop suboper,
             f.pptope tope /*,
                                                                                                                                                             f.ppfpag fechapag*/

        from fsd611 f, fsd010 g, fsd602 h
       where f.ppcta = g.aocta
         and f.ppoper = g.aooper
         and f.ppmod in (select modulo from fst111 where dscod = 50)
         and h.pgcod = f.pgcod
         and h.ppmod = f.ppmod
            --and h.ppsuc
         and h.ppmda = f.ppmda
         and h.pppap = f.pppap
         and h.ppcta = f.ppcta
         and h.ppoper = f.ppoper
         and h.d602co = 'S'
         and h.d602fc between (pd_fecini) and (pd_fecfin)
         and f.ppfpag = h.ppfpag
         and ((g.aofe99 > (pd_fecini) and g.aostat = 99) or
             g.aofe99 = to_Date('01.01.0001', 'dd.mm.yyyy'))
         and f.ppcta <> 999999999
      --and f.ppcta in (1231094) and f.ppoper = 2140771

      /*and h.d602mo = 30        and h.d602tr not in (355,356,357,358,359,360,381,390,391,392)*/
       group by f.pgcod,
                f.ppmod,
                f.ppsuc,
                f.ppmda,
                f.pppap,
                f.ppcta,
                f.ppoper,
                f.ppsbop,
                f.pptope /*,f.ppfpag*/

      minus (select pgcod,
                    aomod,
                    aosuc,
                    aomda,
                    aopap,
                    aocta,
                    aooper,
                    aosbop,
                    aotope
               from fpp001
              where (sgcod in (200, 201, 202) or sgcod in( select tp1nro3
                                                              from fst198
                                                             Where Tp1cod   = 1
                                                               and Tp1cod1  = 10898
                                                               and Tp1corr1 = 18
                                                               and tp1corr3 = 2
                                                               and tp1nro1 = 1))
              group by pgcod,
                       aomod,
                       aosuc,
                       aomda,
                       aopap,
                       aocta,
                       aooper,
                       aosbop,
                       aotope);

    ln_numero number := 0;
    ln_corr   number := 1;
  begin

    --inserta a tabla ya existente
    execute immediate 'truncate table jaqy144';
    execute immediate 'truncate table jaqy145';

    for i in listado(pd_fecini, pd_fecfin) loop

      insert into jaqy144
        (jaqy144corr,
         jaqy144pgcod,
         jaqy144mod,
         jaqy144suc,
         jaqy144mda,
         jaqy144pap,
         jaqy144cta,
         jaqy144ope,
         jaqy144sbop,
         jaqy144top)
      values
        (ln_corr,
         i.pgcod,
         i.modulo,
         i.sucursal,
         i.moneda,
         i.papel,
         i.cuenta,
         i.operacion,
         i.suboper,
         i.tope);
      ln_corr   := ln_corr + 1;
      ln_numero := ln_numero + 1;
      if ln_corr = 500 then
        commit;
        ln_numero := 0;
      end if;
    end loop;
    commit;
    ----
    begin
      select max(jaqy144corr) into ln_corr from jaqy144;
    end;
    ln_corr := ln_corr + 1;
    ----

  end sp_cr_listado_SINVC;
  ----------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------------
  procedure sp_cr_listadoIII(pd_fecini in date, pd_fecfin in date) is

    ln_imp1 number(10, 2);

    ln_imp2 number(10, 2);
    ln_imp3 number(10, 2);
    ln_imp4 number(10, 2);
    ln_imp5 number(10, 2);
    --estado     varchar2(2);
    lc_mespago varchar2(2);
    lc_mescuot varchar2(2);
    ln_monto   number(10, 2);

    lc_tip char(1) := null;
    pc_tip char(1) := null;

    ln_codvar   NUMBER;
    ln_mtoprima number(10, 2);

    cursor llenar is

      select j.jaqy144pgcod,
             j.jaqy144mod,
             j.jaqy144suc,
             j.jaqy144mda,
             j.jaqy144pap,
             j.jaqy144cta,
             j.jaqy144ope,
             j.jaqy144sbop,
             j.jaqy144top,
             j.jaqy144fchpag
        from jaqy144 j;

  begin
    for i in llenar loop
      pq_cr_famsegura.Sp_monto_calendarioSVC(i.jaqy144pgcod,
                                             i.jaqy144mod,
                                             i.jaqy144suc,
                                             i.jaqy144mda,
                                             i.jaqy144pap,
                                             i.jaqy144cta,
                                             i.jaqy144ope,
                                             i.jaqy144sbop,
                                             i.jaqy144top,
                                             pc_tip,
                                             pd_fecfin,
                                             ln_mtoprima,
                                             ln_codvar,
                                             lc_tip);

    end loop;
  end sp_cr_listadoIII;
  --------------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------
  procedure sp_cr_llenardatosSV(pd_fecini in date, pd_fecfin in date) is
  begin

    begin
      --- llena jaqy144
      pq_cr_famsegura.sp_cr_listado_SINVC(pd_fecini, pd_fecfin);
    end;

    begin
      pq_cr_famsegura.sp_cr_listadoiii(pd_fecini => pd_fecini,
                                       pd_fecfin => pd_fecfin);
    end;

    commit;
  end sp_cr_llenardatosSV;
  ----------------------------------------------------------------------------
  FUNCTION fn_mg_verifica_tarea(pi_vc2_nomjob IN VARCHAR2,
                                pi_vc2_nomusr IN VARCHAR2) RETURN NUMBER IS
    -- *****************************************************************
    -- Nombre                     : fn_mg_verifica_tarea
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.08.02
    -- Autor de Creación          : YLOZADA
    -- Uso                        : VERIFICA EL ESTADO DE LOS SCHEDULERS PARA UN OWNER DETERMINADO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************

    num_job NUMBER(10);
  BEGIN

    SELECT COUNT(1)
      INTO num_job
      FROM dba_scheduler_jobs job
     WHERE owner = 'BANTPROD' --pi_vc2_nomusr
       AND job.job_name LIKE pi_vc2_nomjob || '%';

    RETURN num_job;

  END fn_mg_verifica_tarea;
  ----------------------
end PQ_CR_FAMSEGURA;
/

