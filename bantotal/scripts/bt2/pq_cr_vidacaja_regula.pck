create or replace package PQ_CR_VIDACAJA_REGULA is

  -- *****************************************************************
  -- Nombre                     : PQ_CR_VIDACAJA
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
                             ln_monto     in number,
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

  -----------------------------
  procedure sp_cr_Desafiliaciones(ld_fecini  in date,
                                  pd_fecpro  in date,
                                  P_C_DIGITO in varchar2);

  --------------------------------------------------------
  procedure sp_cr_Desafilia60(P_C_DIGITO in varchar2,
                              pd_fecini  in date,
                              pd_fecpro  in date);

  -------------------------------------------------------
  procedure sp_cr_OtrosDesafilia60(P_C_DIGITO in varchar2,
                                   ld_fecini  in date,
                                   ld_fecfin  in date);
  ---------------
  procedure sp_cr_copiainfo(PGFAPE      in date,
                            ln_cuenta   in number,
                            ln_modulo   in number,
                            ln_moneda   in number,
                            ln_operar   in number,
                            ln_tipope   in number,
                            ln_importe  in number,
                            ld_fchcuota in date,
                            ld_fchpago  in date);
  -------------------------------------------------------------------
  procedure sp_cr_cargaVC_job(pd_fecini IN date, pd_fecpro IN date);
  --------------------------------------------------------------------
  procedure sp_cr_Desafilia60_job(pd_fecini IN date, pd_fecpro IN date);
  -----------------------------------------------------------------------
  procedure sp_cr_OtrosDesafilia60_job(pd_fecini IN date,
                                       pd_fecpro IN date);
  ------------------------------------------------------------------------

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
                          ln_mntseg in number,
                          ln_codvar in number,
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
  FUNCTION fn_mg_verifica_tarea(pi_vc2_nomjob IN VARCHAR2,
                                pi_vc2_nomusr IN VARCHAR2) RETURN NUMBER;
  ---------------
end PQ_CR_VIDACAJA_REGULA;
/

create or replace package body PQ_CR_VIDACAJA_REGULA is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_VIDACAJA_REGULA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2016.05.16
  -- Autor de Creación          : ABERNEDO / DCASTRO
  -- Uso                        : OBTENER PAGOS DE CREDITOS CON SEGURO VIDA CAJA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2016.06.22
  -- Autor de la Modificación   : DCASTRO
  -- Descripción de Modificación: Se modifico sp_monto_calendarioVC , sp_monto_calendarioVCC , Sp_cronograma
  --                              
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
    -- Fecha de Modificación      : 02/02/02
    -- Autor de la Modificación   : MPOSTIGOC
    -- Descripción de Modificación:  Se comento en la linea 76 y 197, se agrego la linea 198  ld_fecini
    --                              
    -- *****************************************************************
  
    ld_fecini date;
  begin
  
    Execute immediate ('truncate table jaqz085_aux');
  
    ld_fecini := to_date('01' || to_char(pd_fecpro, 'mmyyyy'), 'ddmmyyyy');
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
         JAQZ085FVAL /*,JAQZ085MPA*/ /*,JAQZ085FPA*/)
      
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
               g.aofval
          from fsd010 g, fpp001 h
         where g.pgcod = 1
           and h.pgcod = g.pgcod
           and h.aocta = g.aocta
           and h.aooper = g.aooper
           and h.aocta <> 999999999
           and g.aomod in (select modulo from fst111 where dscod = 50)
           and ((g.aostat = 99 and g.aofe99 >= ld_fecini /*and g.aofe99 <= pd_fecpro*/
               ) /*to_date('2015.10.01', 'yyyy.mm.dd')*/
               or g.aofe99 = to_Date('01.01.0001', 'dd.mm.yyyy'))
           and h.sgcod in (116, 117, 118, 119, 120, 121, 122)
        /*  and g.aocta = 210375
                                                                                                                                                                                                                                                                                                                                                                                                                                           and g.aooper = 1003182*/
        
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
                  g.aofval;
    
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
        from fst300
       where sgcod in (116, 117, 118, 119, 120, 121, 122);
  
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
    ln_mntseg number;
  
  begin
  
    -- ld_fecini := pd_fecini;--to_date('01' || to_char(pd_fecpro, 'mmyyyy'), 'ddmmyyyy');
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
            --pagos
          
            begin
              select a.pp001imp
                into ln_mntseg
                from fpp001 a
               where a.pgcod = pn_emp
                 and a.aomod = pn_mod
                 and a.aosuc = pn_suc
                 and a.aomda = pn_mda
                 and a.aopap = pn_pap
                 and a.aocta = pn_cta
                 and a.aooper = pn_ope
                 and a.aosbop = pn_sbo
                 and a.aotope = pn_top
                 and a.sgcod in (116, 117, 118, 119, 120, 121, 122);
            end;
          
            begin
              PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                  ln_mntseg => ln_mntseg,
                                                  ln_codvar => ln_codVar,
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
                PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                    ln_mntseg => ln_mntseg,
                                                    ln_codvar => ln_codVar,
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
                  PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                      ln_mntseg => ln_mntseg,
                                                      ln_codvar => ln_codVar,
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
                
                  ld_fecnew := add_months(ld_fecini, -3); -- para menos de 3 meses
                
                  begin
                    PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                        ln_mntseg => ln_mntseg,
                                                        ln_codvar => ln_codVar,
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
                
                end if;
              
                if ln_mto11 = 0 and ln_mto12 = 0 and ln_mto13 = 0 and
                   ln_mto14 = 0 and ln_mto15 = 0 then
                
                  ld_fecnew := add_months(ld_fecini, -4); -- para menos de 4 meses
                
                  begin
                    PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                        ln_mntseg => ln_mntseg,
                                                        ln_codvar => ln_codVar,
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
                
                  ld_fecnew := add_months(ld_fecini, -5); -- para menos de 5 meses
                
                  begin
                    PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                        ln_mntseg => ln_mntseg,
                                                        ln_codvar => ln_codVar,
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
                
                  ld_fecnew := add_months(ld_fecini, -6); -- para menos de 6 meses
                
                  begin
                    PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                        ln_mntseg => ln_mntseg,
                                                        ln_codvar => ln_codVar,
                                                        pn_mto11  => ln_mto11,
                                                        pn_mto12  => ln_mto12,
                                                        pn_mto13  => ln_mto13,
                                                        pn_mto14  => ln_mto14,
                                                        pn_mto15  => ln_mto15);
                  end;
                end if;
              
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
                    PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                        ln_mntseg => ln_mntseg,
                                                        ln_codvar => ln_codVar,
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
                    PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                        ln_mntseg => ln_mntseg,
                                                        ln_codvar => ln_codVar,
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
                    PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                        ln_mntseg => ln_mntseg,
                                                        ln_codvar => ln_codVar,
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
                    PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                        ln_mntseg => ln_mntseg,
                                                        ln_codvar => ln_codVar,
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
                    PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                        ln_mntseg => ln_mntseg,
                                                        ln_codvar => ln_codVar,
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
                
                  ld_fecfin := add_months(pd_fecpro, 6); -- Se agrega seis meses a fecha de proces, puede ser cuota adelantada
                
                  begin
                    PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                        ln_mntseg => ln_mntseg,
                                                        ln_codvar => ln_codVar,
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
                --2017.01.24
              
              end if;
            
            end if;
          
            --si monto de prima es igual a PP1IMP        
            case
              when ln_codVar = 1 then
                ln_mtoprima := ln_mto11;
                --2016.06.22
                if ln_mtoprima <> ln_mtoseg then
                  begin
                    PQ_CR_VIDACAJA_REGULA.sp_cr_gracia(pn_emp    => pn_emp,
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
                    if ln_mtoprima / ln_mtoseg = 2 then
                      --si es el doble y tiene gracia 
                      ln_mtoprima := ln_mtoseg;
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
                    PQ_CR_VIDACAJA_REGULA.sp_cr_gracia(pn_emp    => pn_emp,
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
                    if ln_mtoprima / ln_mtoseg = 2 then
                      --si es el doble y tiene gracia 
                      ln_mtoprima := ln_mtoseg;
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
                    PQ_CR_VIDACAJA_REGULA.sp_cr_gracia(pn_emp    => pn_emp,
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
                    if ln_mtoprima / ln_mtoseg = 2 then
                      --si es el doble y tiene gracia 
                      ln_mtoprima := ln_mtoseg;
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
                    PQ_CR_VIDACAJA_REGULA.sp_cr_gracia(pn_emp    => pn_emp,
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
                    if ln_mtoprima / ln_mtoseg = 2 then
                      --si es el doble y tiene gracia 
                      ln_mtoprima := ln_mtoseg;
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
                    PQ_CR_VIDACAJA_REGULA.sp_cr_gracia(pn_emp    => pn_emp,
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
                    if ln_mtoprima / ln_mtoseg = 2 then
                      --si es el doble y tiene gracia 
                      ln_mtoprima := ln_mtoseg;
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
            PQ_CR_VIDACAJA_REGULA.sp_cr_validapago(ln_pgcod     => pn_emp,
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
    ld_fecnew  date;
    ln_mntseg  number;
  
    ld_fecfin date; -- 2016.06.21
    ln_numcuo number := 0;
  
  begin
  
    ld_fecini := to_date('01' || to_char(pd_fecpro, 'mmyyyy'), 'ddmmyyyy');
    lc_tip    := null;
  
    ln_mtoseg1 := 1.5; --moneda soles y dolares
    ln_mtoseg2 := 2.5; --moneda soles y dolares
    ln_mtoseg3 := 1; --0.58,0.59,0.60,0.90  <1 si moneda es dolares
    --ln_mtoseg4 := 
  
    begin
    
      begin
        --pagos
      
        begin
          select a.pp001imp
            into ln_mntseg
            from fpp001 a
           where a.pgcod = pn_emp
             and a.aomod = pn_mod
             and a.aosuc = pn_suc
             and a.aomda = pn_mda
             and a.aopap = pn_pap
             and a.aocta = pn_cta
             and a.aooper = pn_ope
             and a.aosbop = pn_sbo
             and a.aotope = pn_top
             and a.sgcod in (116, 117, 118, 119, 120, 121, 122);
        end;
      
        begin
          PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                              ln_mntseg => ln_mntseg,
                                              ln_codvar => ln_codVar,
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
            PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                ln_mntseg => ln_mntseg,
                                                ln_codvar => ln_codVar,
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
              PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                  ln_mntseg => ln_mntseg,
                                                  ln_codvar => ln_codVar,
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
                PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                    ln_mntseg => ln_mntseg,
                                                    ln_codvar => ln_codVar,
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
               (ln_mto11 < ln_mtoseg3 and pn_mda = 101) then
            ln_mtoseg := ln_mto11;
            ln_codVar := 1;
          when ln_mto12 = ln_mtoseg1 or ln_mto12 = ln_mtoseg2 or
               (ln_mto12 < ln_mtoseg3 and pn_mda = 101) then
            ln_mtoseg := ln_mto12;
            ln_codVar := 2;
          when ln_mto13 = ln_mtoseg1 or ln_mto13 = ln_mtoseg2 or
               (ln_mto13 < ln_mtoseg3 and pn_mda = 101) then
            ln_mtoseg := ln_mto13;
            ln_codVar := 3;
          when ln_mto14 = ln_mtoseg1 or ln_mto14 = ln_mtoseg2 or
               (ln_mto14 < ln_mtoseg3 and pn_mda = 101) then
            ln_mtoseg := ln_mto14;
            ln_codVar := 4;
          when ln_mto15 = ln_mtoseg1 or ln_mto15 = ln_mtoseg2 or
               (ln_mto15 < ln_mtoseg3 and pn_mda = 101) then
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
                PQ_CR_VIDACAJA_REGULA.sp_cr_gracia(pn_emp    => pn_emp,
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
                if ln_mtoprima / ln_mtoseg = 2 then
                  --si es el doble y tiene gracia 
                  ln_mtoprima := ln_mtoseg;
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
                PQ_CR_VIDACAJA_REGULA.sp_cr_gracia(pn_emp    => pn_emp,
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
                if ln_mtoprima / ln_mtoseg = 2 then
                  --si es el doble y tiene gracia 
                  ln_mtoprima := ln_mtoseg;
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
                PQ_CR_VIDACAJA_REGULA.sp_cr_gracia(pn_emp    => pn_emp,
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
                if ln_mtoprima / ln_mtoseg = 2 then
                  --si es el doble y tiene gracia 
                  ln_mtoprima := ln_mtoseg;
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
                PQ_CR_VIDACAJA_REGULA.sp_cr_gracia(pn_emp    => pn_emp,
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
                if ln_mtoprima / ln_mtoseg = 2 then
                  --si es el doble y tiene gracia 
                  ln_mtoprima := ln_mtoseg;
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
                PQ_CR_VIDACAJA_REGULA.sp_cr_gracia(pn_emp    => pn_emp,
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
                if ln_mtoprima / ln_mtoseg = 2 then
                  --si es el doble y tiene gracia 
                  ln_mtoprima := ln_mtoseg;
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
          PQ_CR_VIDACAJA_REGULA.sp_cr_validapago(ln_pgcod     => pn_emp,
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
       where to_char(substr(trim(jaqZ085cta), -1, 1)) = P_C_DIGITO;
    -- where a.jaqz085cta = 44065;
  
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
        PQ_CR_VIDACAJA_REGULA.Sp_monto_calendarioVC(i.JAQZ085EMP,
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
    
      PQ_CR_VIDACAJA_REGULA.sp_cr_Desafiliaciones(ld_fecvini,
                                                  pd_fecpro,
                                                  P_C_DIGITO);
    
      pq_cr_vidacaja_regula.sp_cr_Desafilia60(P_C_DIGITO,
                                              ld_fecvini,
                                              pd_fecpro);
    
      pq_cr_vidacaja_regula.sp_cr_OtrosDesafilia60(P_C_DIGITO,
                                                   ld_fecvini,
                                                   pd_fecpro);
    
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
                             ln_monto     in number,
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
         and h.d602fc between ld_pd_fecini and ld_pd_fecfin
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
         and i.ppsbop = ln_suboper
      
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
  
  begin
  
    /*ln_monto  := 2.5;
    ln_codvar := 1;*/
  
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
      
        case
          when ln_codvar = 0 then
            lc_flag := 'N';
          when ln_codvar = 1 then
            if j.ln_imp1 = ln_monto then
              lc_flag := 'S';
            else
              if j.ln_imp1 > 0 and j.ln_imp1 < ln_monto then
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
              
                -------------******************************
                if j.ln_imp1 > ln_monto then
                
                  if (j.ln_imp1 = ln_monto * 2) or
                     (j.ln_imp1 = ln_monto * 3) then
                  
                    lc_flag := 'S';
                  
                  else
                    if lc_flag = 'N' then
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
                           and f.ppfpag = j.ld_fchcuo;
                      exception
                        when others then
                          ln_pago1 := 0;
                        
                      end;
                    
                      if (ln_pago1 = ln_monto * 2) or
                         (ln_pago1 = ln_monto * 3) then
                      
                        lc_flag := 'S';
                      else
                        lc_flag := 'N';
                      end if;
                    end if;
                  end if; ---*********************
                  /*else
                  lc_flag := 'N';*/
                end if;
              end if;
            
            end if;
          when ln_codvar = 2 then
            if j.ln_imp2 = ln_monto then
              lc_flag := 'S';
            else
              if j.ln_imp2 > 0 and j.ln_imp2 < ln_monto then
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
              
                -------------******************************
                /*if j.ln_imp2 > ln_monto then
                
                  if (j.ln_imp2 = ln_monto * 2) or
                     (j.ln_imp2 = ln_monto * 3) then
                  
                    lc_flag := 'S';
                  else
                    lc_flag := 'N';
                  
                  end if; ---*********************
                  \*else
                  lc_flag := 'N';*\
                end if;*/
              
                if j.ln_imp2 > ln_monto then
                
                  if (j.ln_imp2 = ln_monto * 2) or
                     (j.ln_imp2 = ln_monto * 3) then
                  
                    lc_flag := 'S';
                  
                  else
                    if lc_flag = 'N' then
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
                           and f.ppfpag = j.ld_fchcuo;
                      exception
                        when others then
                          ln_pago2 := 0;
                        
                      end;
                    
                      if (ln_pago2 = ln_monto * 2) or
                         (ln_pago2 = ln_monto * 3) then
                      
                        lc_flag := 'S';
                      else
                        lc_flag := 'N';
                      end if;
                    end if;
                  end if; ---*********************
                  /*else
                  lc_flag := 'N';*/
                end if;
              
              end if;
            end if;
          when ln_codvar = 3 then
            if j.ln_imp3 = ln_monto then
              lc_flag := 'S';
            else
              if j.ln_imp3 > 0 and j.ln_imp3 < ln_monto then
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
                    select sum(f.pp1imp13) /*ln_imp2/*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     sum(i.pp1imp13) ln_imp3,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     sum(i.pp1imp14) ln_imp4,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     sum(i.pp1imp15) ln_imp5*/
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
                    select sum(f.pp1imp13) /*ln_imp2/*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   sum(i.pp1imp15) ln_imp5*/
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
              
                -------------******************************
                /* if j.ln_imp3 > ln_monto then
                
                  if (j.ln_imp3 = ln_monto * 2) or
                     (j.ln_imp3 = ln_monto * 3) then
                  
                    lc_flag := 'S';
                  else
                    lc_flag := 'N';
                  
                  end if; ---*********************
                  \*else
                  lc_flag := 'N';*\
                end if;*/
              
                if j.ln_imp3 > ln_monto then
                
                  if (j.ln_imp3 = ln_monto * 2) or
                     (j.ln_imp3 = ln_monto * 3) then
                  
                    lc_flag := 'S';
                  
                  else
                    if lc_flag = 'N' then
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
                           and f.ppfpag = j.ld_fchcuo;
                      exception
                        when others then
                          ln_pago3 := 0;
                        
                      end;
                    
                      if (ln_pago3 = ln_monto * 2) or
                         (ln_pago3 = ln_monto * 3) then
                      
                        lc_flag := 'S';
                      else
                        lc_flag := 'N';
                      end if;
                    end if;
                  end if; ---*********************
                  /*else
                  lc_flag := 'N';*/
                end if;
              
              end if;
            end if;
          
          when ln_codvar = 4 then
            if j.ln_imp4 = ln_monto then
              lc_flag := 'S';
            else
              if j.ln_imp4 > 0 and j.ln_imp4 < ln_monto then
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
              
                -------------******************************
                /*if j.ln_imp4 > ln_monto then
                
                  if (j.ln_imp4 = ln_monto * 2) or
                     (j.ln_imp4 = ln_monto * 3) then
                  
                    lc_flag := 'S';
                  else
                    lc_flag := 'N';
                  
                  end if; ---*********************
                  \* else
                  lc_flag := 'N';*\
                end if;*/
              
                if j.ln_imp4 > ln_monto then
                
                  if (j.ln_imp4 = ln_monto * 2) or
                     (j.ln_imp4 = ln_monto * 3) then
                  
                    lc_flag := 'S';
                  
                  else
                    if lc_flag = 'N' then
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
                           and f.ppfpag = j.ld_fchcuo;
                      exception
                        when others then
                          ln_pago4 := 0;
                        
                      end;
                    
                      if (ln_pago4 = ln_monto * 2) or
                         (ln_pago4 = ln_monto * 3) then
                      
                        lc_flag := 'S';
                      else
                        lc_flag := 'N';
                      end if;
                    end if;
                  end if; ---*********************
                  /*else
                  lc_flag := 'N';*/
                end if;
              
              end if;
            end if;
          
          when ln_codvar = 5 then
          
            if j.ln_imp5 = ln_monto then
              lc_flag := 'S';
            else
              if j.ln_imp5 > 0 and j.ln_imp5 < ln_monto then
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
                -------------******************************
                /* if j.ln_imp5 > ln_monto then
                  
                    if (j.ln_imp5 = ln_monto * 2) or
                       (j.ln_imp5 = ln_monto * 3) then
                    
                      lc_flag := 'S';
                    else
                      lc_flag := 'N';
                    
                    end if; ---*********************
                    \* else
                    lc_flag := 'N';*\
                  end if;
                */
              
                if j.ln_imp5 > ln_monto then
                
                  if (j.ln_imp5 = ln_monto * 2) or
                     (j.ln_imp5 = ln_monto * 3) then
                  
                    lc_flag := 'S';
                  
                  else
                    if lc_flag = 'N' then
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
                           and f.ppfpag = j.ld_fchcuo;
                      exception
                        when others then
                          ln_pago5 := 0;
                        
                      end;
                    
                      if (ln_pago5 = ln_monto * 2) or
                         (ln_pago5 = ln_monto * 3) then
                      
                        lc_flag := 'S';
                      else
                        lc_flag := 'N';
                      end if;
                    end if;
                  end if; ---*********************
                  /*else
                  lc_flag := 'N';*/
                end if;
              
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
        -------------******************************
        /* if j.ln_imp1 > ln_monto then
          
            if (j.ln_imp1 = ln_monto * 2) or (j.ln_imp1 = ln_monto * 3) then
            
              lc_flag := 'S';
            else
              lc_flag := 'N';
            
            end if; ---*********************
            \* else
            lc_flag := 'N';*\
          end if;
        */
        if lc_flag = 'S' and ln_monto <> 0 then
        
          begin
            PQ_CR_VIDACAJA_REGULA.sp_cr_inserta(ln_pgcod     => ln_pgcod,
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
  
    /*begin
     select * from jaqy145
     
    end;*/
  
    --if lc_Existe = 'N' then 
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
  
    --  end if;
  
  end sp_cr_inserta;
  ----------------------------------------------------------------------------------------------
  procedure sp_cr_Desafiliaciones(ld_fecini  in date,
                                  pd_fecpro  in date,
                                  P_C_DIGITO in varchar2) is
  
    cursor desafilio is
    
      select lpad(trim(to_char(a.jaqy782cta)), 9, '0') ||
             lpad(trim(to_char(a.jaqy782mod)), 3, '0') ||
             lpad(trim(to_char(a.jaqy782mda)), 3, '0') ||
             lpad(trim(to_char(a.jaqy782ope)), 9, '0') ||
             lpad(trim(to_char(a.jaqy782top)), 3, '0') Nro_Credito,
             to_char(z.ppfpag, 'yyyymmdd') FchEmsionCuota,
             to_char(z.d602fc, 'yyyymmdd') FchPagoCuota,
             a.jaqy782pgc ln_pgcod,
             a.jaqy782mod ln_modulo,
             a.jaqy782suc ln_sucurs,
             a.jaqy782mda ln_moneda,
             a.jaqy782pap ln_papel,
             a.jaqy782cta ln_cuenta,
             a.jaqy782ope ln_opera,
             a.jaqy782sbo ln_suboper,
             a.jaqy782top ln_tipoper,
             z.ppfpag ld_fchcuot,
             z.d602fc ld_fchpago,
             f.hcimp1 ld_importe,
             z.d602cd ln_pgtransac,
             z.d602mo ln_modtransac,
             z.d602su ln_suctransac,
             z.d602tr ln_transaccion,
             z.d602re ln_reltransac,
             z.d602fc ld_fchtransac,
             max(a.jaqy782fchsis) FchDesafilia /*,
                                                                                                       max(a.jaqy782hrasis) HoraDesafilia*/
        from jaqy782 a, fsd602 z, fsh016 f
       where a.jaqy782pgc = z.pgcod
         and a.jaqy782mod = z.ppmod
         and a.jaqy782suc = z.ppsuc
         and a.jaqy782mda = z.ppmda
         and a.jaqy782pap = z.pppap
         and a.jaqy782cta = z.ppcta
         and a.jaqy782ope = z.ppoper
         and a.jaqy782sbo = z.ppsbop
         and a.jaqy782top = z.pptope
            -- and a.jaqy782fchsis = z.d602fc
            --  and a.jaqy782fchsis = pd_fecpro
         and f.pgcod = z.d602cd
         and f.hcmod = z.d602mo
         and f.hsucor = z.d602su
         and f.htran = z.d602tr
         and f.hnrel = z.d602re
         and f.hfcon = z.d602fc
         and z.d602fc between ld_fecini and pd_fecpro
         and f.hrubro in ('2524020000008', '2514020000008')
         and to_char(substr(trim(a.jaqy782cta), -1, 1)) = P_C_DIGITO
      -- and a.jaqy782cta = 2126356
       group by a.jaqy782pgc,
                a.jaqy782mod,
                a.jaqy782suc,
                a.jaqy782mda,
                a.jaqy782pap,
                a.jaqy782cta,
                a.jaqy782ope,
                a.jaqy782sbo,
                a.jaqy782top,
                z.ppfpag,
                z.d602fc,
                f.hcimp1,
                z.d602cd,
                z.d602mo,
                z.d602su,
                z.d602tr,
                z.d602re,
                z.d602fc;
  
    flag_desa     varchar2(2) := 'N';
    HoraABM       varchar2(8);
    FchABM        date;
    lc_EstadoSeg  varchar2(2);
    lc_FlagExist  varchar2(2);
    lc_flagExtSeg varchar2(2);
    HoraDesafilia character(8);
    ld_fchtransac date;
    ln_import1    number;
    ln_import2    number;
    ln_import3    number;
    lc_Existe     varchar2(2);
  
  begin
  
    for d in desafilio loop
    
      flag_desa := 'N';
    
      begin
        -- Verificar que no tenga seguro vida Caja
      
        select 'S'
          into lc_flagExtSeg
          from fpp001 f
         where f.pgcod = d.ln_pgcod
           and f.aomod = d.ln_modulo
           and f.aosuc = d.ln_sucurs
           and f.aomda = d.ln_moneda
           and f.aopap = d.ln_papel
           and f.aocta = d.ln_cuenta
           and f.aooper = d.ln_opera
           and f.aosbop = d.ln_suboper
           and f.aotope = d.ln_tipoper
           and f.sgcod in (116, 117, 118, 119, 120, 121, 122);
      exception
        when no_data_found then
          lc_flagExtSeg := 'N';
        
      end;
    
      if lc_flagExtSeg = 'N' then
      
        begin
        
          begin
            select max(a.jaqy782hrasis)
              into HoraDesafilia
              from jaqy782 a
             where a.jaqy782pgc = d.ln_pgcod
               and a.jaqy782mod = d.ln_modulo
               and a.jaqy782suc = d.ln_sucurs
               and a.jaqy782mda = d.ln_moneda
               and a.jaqy782pap = d.ln_papel
               and a.jaqy782cta = d.ln_cuenta
               and a.jaqy782ope = d.ln_opera
               and a.jaqy782sbo = d.ln_suboper
               and a.jaqy782top = d.ln_tipoper
               and a.jaqy782fchsis = d.FchDesafilia;
          exception
            when others then
              null;
            
          end;
        
          begin
            select a.jaqy782est
              into lc_EstadoSeg
              from jaqy782 a
             where a.jaqy782pgc = d.ln_pgcod
               and a.jaqy782mod = d.ln_modulo
               and a.jaqy782suc = d.ln_sucurs
               and a.jaqy782mda = d.ln_moneda
               and a.jaqy782pap = d.ln_papel
               and a.jaqy782cta = d.ln_cuenta
               and a.jaqy782ope = d.ln_opera
               and a.jaqy782sbo = d.ln_suboper
               and a.jaqy782top = d.ln_tipoper
               and a.jaqy782fchsis = d.FchDesafilia
               and a.jaqy782hrasis = HoraDesafilia;
          exception
            when others then
              null;
            
          end;
        
          if lc_EstadoSeg = 'D' then
          
            begin
              select 'S'
                into lc_FlagExist
                from jaql099 j
               where j.jaql99fepr = d.ld_fchtransac
                 and j.numcta99 = d.Nro_Credito
                 and j.fecemisioncuota99 = d.FchEmsionCuota
                 and j.fecpagocuota99 = d.FchPagoCuota;
            exception
              when no_data_found then
                lc_FlagExist := 'N';
              
            end;
          
            if lc_FlagExist = 'N' then
            
              begin
                select max(q.jaqm251fec)
                  into FchABM
                  from jaqm251 q
                 where q.jaqm251pgc = d.ln_pgcod
                   and q.jaqm251mod = d.ln_modulo
                   and q.jaqm251suc = d.ln_sucurs
                   and q.jaqm251mda = d.ln_moneda
                   and q.jaqm251pap = d.ln_papel
                   and q.jaqm251cta = d.ln_cuenta
                   and q.jaqm251ope = d.ln_opera
                   and q.jaqm251sbo = d.ln_suboper
                   and q.jaqm251top = d.ln_tipoper;
              exception
                when others then
                  null;
                
              end;
            
              if FchABM is not null then
              
                if d.FchDesafilia <= FchABM then
                
                  begin
                    select max(q.jaqm251hoc)
                      into HoraABM
                      from jaqm251 q
                     where q.jaqm251pgc = d.ln_pgcod
                       and q.jaqm251mod = d.ln_modulo
                       and q.jaqm251suc = d.ln_sucurs
                       and q.jaqm251mda = d.ln_moneda
                       and q.jaqm251pap = d.ln_papel
                       and q.jaqm251cta = d.ln_cuenta
                       and q.jaqm251ope = d.ln_opera
                       and q.jaqm251sbo = d.ln_suboper
                       and q.jaqm251top = d.ln_tipoper
                       and q.jaqm251fec = FchABM;
                  end;
                
                  if HoraDesafilia > HoraABM then
                    flag_desa := 'S';
                  else
                    flag_desa := 'N';
                  end if;
                
                else
                  if d.ld_fchtransac > FchABM then
                    flag_desa := 'S';
                  end if;
                end if;
              
              else
                flag_desa := 'S';
              
              end if;
            
            end if;
          end if;
        
          if flag_desa = 'S' then
          
            begin
              select max(d602fc)
                into ld_fchtransac
                from fsd602 f
               where f.pgcod = d.ln_pgcod
                 and f.ppmod = d.ln_modulo
                 and f.ppsuc = d.ln_sucurs
                 and f.ppmda = d.ln_moneda
                 and f.pppap = d.ln_papel
                 and f.ppcta = d.ln_cuenta
                 and f.ppoper = d.ln_opera
                 and f.ppsbop = d.ln_suboper
                 and f.pptope = d.ln_tipoper
                 and f.ppfpag = d.ld_fchcuot;
            exception
              when others then
                null;
            end;
          
            begin
              select sum(pp1imp11), sum(pp1imp12), sum(pp1imp13)
                into ln_import1, ln_import2, ln_import3
                from fsd612 f
               where f.pgcod = d.ln_pgcod
                 and f.ppmod = d.ln_modulo
                 and f.ppsuc = d.ln_sucurs
                 and f.ppmda = d.ln_moneda
                 and f.pppap = d.ln_papel
                 and f.ppcta = d.ln_cuenta
                 and f.ppoper = d.ln_opera
                 and f.ppsbop = d.ln_suboper
                 and f.pptope = d.ln_tipoper
                 and f.ppfpag = d.ld_fchcuot;
            exception
              when others then
                null;
              
            end;
          
            begin
              select 'S'
                into lc_Existe
                from jaqy145 j
               where j.jaqy145pgcod = d.ln_pgcod
                 and j.jaqy145mod = d.ln_modulo
                 and j.jaqy145suc = d.ln_sucurs
                 and j.jaqy145mda = d.ln_moneda
                 and j.jaqy145pap = d.ln_papel
                 and j.jaqy145cta = d.ln_cuenta
                 and j.jaqy145ope = d.ln_opera
                 and j.jaqy145sbop = d.ln_suboper
                 and j.jaqy145top = d.ln_tipoper
                 and j.jaqy145fchcuo = d.ld_fchcuot;
            exception
              when others then
                lc_Existe := 'N';
              
            end;
          
            if lc_Existe = 'N' then
              PQ_CR_VIDACAJA_REGULA.sp_cr_inserta(ln_pgcod     => d.ln_pgcod,
                                                  ln_modulo    => d.ln_modulo,
                                                  ln_sucursal  => d.ln_sucurs,
                                                  ln_moneda    => d.ln_moneda,
                                                  ln_papel     => d.ln_papel,
                                                  ln_cuenta    => d.ln_cuenta,
                                                  ln_operacion => d.ln_opera,
                                                  ln_suboper   => d.ln_suboper,
                                                  ln_tope      => d.ln_tipoper,
                                                  ld_fechcuo   => d.ld_fchcuot,
                                                  ld_fchpago   => ld_fchtransac,
                                                  ln_imp       => ln_import1,
                                                  ln_imp1      => ln_import1,
                                                  ln_imp2      => ln_import2,
                                                  ln_imp3      => ln_import3,
                                                  ln_imp4      => 0,
                                                  ln_imp5      => 0,
                                                  lc_indicador => 'A');
            
            end if;
          
          end if;
        
        end;
      
      end if;
    end loop;
  
  end sp_cr_Desafiliaciones;

  --------------------------------------------------------------------

  procedure sp_cr_Desafilia60(P_C_DIGITO in varchar2,
                              pd_fecini  in date,
                              pd_fecpro  in date) is
  
    -- ln_mntcalndario number;
    ln_mntpagado number;
    lc_flagExst  varchar2(2);
  
    cursor listado is
      select distinct lpad(trim(to_char(f.ppcta)), 9, '0') ||
                      lpad(trim(to_char(f.ppmod)), 3, '0') ||
                      lpad(trim(to_char(f.ppmda)), 3, '0') ||
                      lpad(trim(to_char(f.ppoper)), 9, '0') ||
                      lpad(trim(to_char(f.pptope)), 3, '0') Nro_Credito,
                      to_char(f.ppfpag, 'yyyymmdd') FchEmsionCuota,
                      to_char(f.d602fc, 'yyyymmdd') FchPagoCuota,
                      f.pgcod ln_pgcod,
                      f.ppmod ln_modulo,
                      f.ppsuc ln_sucursal,
                      f.ppmda ln_moneda,
                      f.pppap ln_papel,
                      f.ppcta ln_cuenta,
                      f.ppoper ln_operacion,
                      f.ppsbop ln_subopera,
                      f.pptope ln_tipopera,
                      f.ppfpag ld_fchcuota,
                      f.d602fc ld_fchpago
        from jaqy701 j, fsd602 f, fsh016 h
       where j.jaqy701cod = f.pgcod
         and j.jaqy701mod = f.ppmod
         and j.jaqy701suc = f.ppsuc
         and j.jaqy701mda = f.ppmda
         and j.jaqy701pap = f.pppap
         and j.jaqy701cta = f.ppcta
         and j.jaqy701oper = f.ppoper
         and j.jaqy701sbop = f.ppsbop
         and j.jaqy701tope = f.pptope
         and f.d602cd = h.pgcod
         and f.d602mo = h.hcmod
         and f.d602su = h.hsucor
         and f.d602tr = h.htran
         and f.d602re = h.hnrel
         and f.d602fc = h.hfcon
         and f.d602co = 'S'
         and f.d602fc between pd_fecini and pd_fecpro
            -- and f.ppcta = 47130
         and h.hrubro in ('2524020000008', '2514020000008')
         and to_char(substr(trim(j.jaqy701cta), -1, 1)) = P_C_DIGITO;
  
  begin
  
    for l in listado loop
    
      /*begin
        select 'S'
          into lc_flagExst
          from jaql099 j
         where j.codproductocobro99 = '0004'
           and j.numcta99 = l.Nro_Credito
           and j.fecemisioncuota99 = l.FchEmsionCuota;
      exception
        when no_data_found then
          lc_flagExst := 'N';
      end;*/
    
      begin
        select 'S'
          into lc_flagExst
          from jaqy145 j
         where j.jaqy145pgcod = l.ln_pgcod
           and j.jaqy145mod = l.ln_modulo
           and j.jaqy145suc = l.ln_sucursal
           and j.jaqy145mda = l.ln_moneda
           and j.jaqy145pap = l.ln_papel
           and j.jaqy145cta = l.ln_cuenta
           and j.jaqy145ope = l.ln_operacion
           and j.jaqy145sbop = l.ln_subopera
           and j.jaqy145top = l.ln_tipopera
           and j.jaqy145fchcuo = l.ld_fchcuota
           and j.jaqy145fchpag = l.ld_fchpago;
      exception
        when no_data_found then
          lc_flagExst := 'N';
      end;
    
      if lc_flagExst = 'N' then
        /*begin
          select max(ppimp11)
            into ln_mntcalndario
            from fsd611 f
           where f.pgcod = l.ln_pgcod
             and f.ppmod = l.ln_modulo
             and f.ppsuc = l.ln_sucursal
             and f.ppmda = l.ln_moneda
             and f.pppap = l.ln_papel
             and f.ppcta = l.ln_cuenta
             and f.ppoper = l.ln_operacion
             and f.ppsbop = l.ln_subopera
             and f.pptope = l.ln_tipopera
             and f.ppfpag = l.ld_fchcuota;
        exception
          when others then
            null;
          
        end;*/
      
        begin
          select sum(pp1imp11)
            into ln_mntpagado
            from fsd612 g
           where g.pgcod = l.ln_pgcod
             and g.ppmod = l.ln_modulo
             and g.ppsuc = l.ln_sucursal
             and g.ppmda = l.ln_moneda
             and g.pppap = l.ln_papel
             and g.ppcta = l.ln_cuenta
             and g.ppoper = l.ln_operacion
             and g.ppsbop = l.ln_subopera
             and g.pptope = l.ln_tipopera
             and g.ppfpag = l.ld_fchcuota;
        end;
      
        if /*ln_mntcalndario =*/
         ln_mntpagado <> 0 then
        
          PQ_CR_VIDACAJA_REGULA.sp_cr_inserta(ln_pgcod     => l.ln_pgcod,
                                              ln_modulo    => l.ln_modulo,
                                              ln_sucursal  => l.ln_sucursal,
                                              ln_moneda    => l.ln_moneda,
                                              ln_papel     => l.ln_papel,
                                              ln_cuenta    => l.ln_cuenta,
                                              ln_operacion => l.ln_operacion,
                                              ln_suboper   => l.ln_subopera,
                                              ln_tope      => l.ln_tipopera,
                                              ld_fechcuo   => l.ld_fchcuota,
                                              ld_fchpago   => l.ld_fchpago,
                                              ln_imp       => ln_mntpagado,
                                              ln_imp1      => ln_mntpagado,
                                              ln_imp2      => 0,
                                              ln_imp3      => 0,
                                              ln_imp4      => 0,
                                              ln_imp5      => 0,
                                              lc_indicador => 'A');
        
          /* PQ_CR_VIDACAJA_REGULA.sp_cr_copiainfo(PGFAPE      => l.ld_fchpago,
          ln_cuenta   => l.ln_cuenta,
          ln_modulo   => l.ln_modulo,
          ln_moneda   => l.ln_moneda,
          ln_operar   => l.ln_operacion,
          ln_tipope   => l.ln_tipopera,
          ln_importe  => ln_mntpagado,
          ld_fchcuota => l.ld_fchcuota,
          ld_fchpago  => l.ld_fchpago);*/
        
        end if;
      end if;
    end loop;
  end sp_cr_Desafilia60;

  -------------------------------------------------------------
  procedure sp_cr_OtrosDesafilia60(P_C_DIGITO in varchar2,
                                   ld_fecini  in date,
                                   ld_fecfin  in date) is
  
    mnt_d612 number;
    mnt_d611 number;
  
    cursor otrodesafilia60 is
    
      select f.pgcod   ln_pgcod,
             f.ppmod   ln_modulo,
             f.ppsuc   ln_sucursal,
             f.ppmda   ln_moneda,
             f.pppap   ln_papel,
             f.ppcta   ln_cuenta,
             f.ppoper  ln_operacion,
             f.ppsbop  ln_subopera,
             f.pptope  ln_tipopera,
             f.ppfpag  ld_fchcuota,
             f.d602fc  ld_fchpago,
             f.pp1nump ld_pp1nump
        from fsd602 f, fsh016 h
       where f.d602cd = h.pgcod
         and f.d602mo = h.hcmod
         and f.d602su = h.hsucor
         and f.d602tr = h.htran
         and f.d602re = h.hnrel
         and f.d602fc = h.hfcon
         and f.d602co = 'S'
         and h.hrubro in ('2524020000008', '2514020000008')
         and f.d602fc between ld_fecini and ld_fecfin
         and (f.pgcod, f.ppmod, f.ppsuc, f.ppmda, f.pppap, f.ppcta, f.ppoper,
              f.ppsbop, f.pptope, f.ppfpag, f.d602fc) not in
             (select j.jaqy145pgcod,
                     j.jaqy145mod,
                     j.jaqy145suc,
                     j.jaqy145mda,
                     j.jaqy145pap,
                     j.jaqy145cta,
                     j.jaqy145ope,
                     j.jaqy145sbop,
                     j.jaqy145top,
                     j.jaqy145fchcuo,
                     j.jaqy145fchpag
                from jaqy145 j
               where j.jaqy145fchpag between ld_fecini and ld_fecfin)
         and to_char(substr(trim(f.ppcta), -1, 1)) = P_C_DIGITO;
  
  begin
  
    for l in otrodesafilia60 loop
    
      begin
      
        select sum(pp1imp11)
          into mnt_d612
          from fsd612
         where pgcod = l.ln_pgcod
           and ppmod = l.ln_modulo
           and ppsuc = l.ln_sucursal
           and ppmda = l.ln_moneda
           and pppap = l.ln_papel
           and ppcta = l.ln_cuenta
           and ppoper = l.ln_operacion
           and ppsbop = l.ln_subopera
           and pptope = l.ln_tipopera
           and ppfpag = l.ld_fchcuota
           and pp1nump <= l.ld_pp1nump;
      exception
        when others then
          mnt_d612 := 0;
        
      end;
    
       begin
        select ppimp11
          into mnt_d611
          from fsd611
         where pgcod = l.ln_pgcod
           and ppmod = l.ln_modulo
           and ppsuc = l.ln_sucursal
           and ppmda = l.ln_moneda
           and pppap = l.ln_papel
           and ppcta = l.ln_cuenta
           and ppoper = l.ln_operacion
           and ppsbop = l.ln_subopera
           and pptope = l.ln_tipopera
           and ppfpag = l.ld_fchcuota;
      exception
        when others then
          mnt_d611 := 0;
      end;
    
      if  mnt_d611 = mnt_d612/* = 2.5) or (mnt_d612 = 5) or (mnt_d612 = 7.5)*/ then
      
        PQ_CR_VIDACAJA_REGULA.sp_cr_inserta(ln_pgcod     => l.ln_pgcod,
                                            ln_modulo    => l.ln_modulo,
                                            ln_sucursal  => l.ln_sucursal,
                                            ln_moneda    => l.ln_moneda,
                                            ln_papel     => l.ln_papel,
                                            ln_cuenta    => l.ln_cuenta,
                                            ln_operacion => l.ln_operacion,
                                            ln_suboper   => l.ln_subopera,
                                            ln_tope      => l.ln_tipopera,
                                            ld_fechcuo   => l.ld_fchcuota,
                                            ld_fchpago   => l.ld_fchpago,
                                            ln_imp       => mnt_d612,
                                            ln_imp1      => mnt_d612,
                                            ln_imp2      => 0,
                                            ln_imp3      => 0,
                                            ln_imp4      => 0,
                                            ln_imp5      => 0,
                                            lc_indicador => 'A');
      
        /* PQ_CR_VIDACAJA_REGULA.sp_cr_copiainfo(PGFAPE      => l.ld_fchpago,
        ln_cuenta   => l.ln_cuenta,
        ln_modulo   => l.ln_modulo,
        ln_moneda   => l.ln_moneda,
        ln_operar   => l.ln_operacion,
        ln_tipope   => l.ln_tipopera,
        ln_importe  => mnt_d612,
        ld_fchcuota => l.ld_fchcuota,
        ld_fchpago  => l.ld_fchpago);*/
      
      end if;
    
    end loop;
  end sp_cr_OtrosDesafilia60;
  ----------------------------------------------------------
  procedure sp_cr_copiainfo(PGFAPE      in date,
                            ln_cuenta   in number,
                            ln_modulo   in number,
                            ln_moneda   in number,
                            ln_operar   in number,
                            ln_tipope   in number,
                            ln_importe  in number,
                            ld_fchcuota in date,
                            ld_fchpago  in date) is
  
    numcertificadocobro99 char(10);
    numcta99              CHAR(27);
  
    montoprimacuota99  CHAR(5);
    FECEMISIONCUOTA99  CHAR(8);
    FECPAGOCUOTA99     CHAR(8);
    DOCDEPOSITO99      CHAR(30);
    FECDEPOSITO99      CHAR(8);
    JAQL99AU01         CHAR(50);
    ln_nrorow          number;
    error              varchar2(1500);
    montoprima         number;
    CODPRODUCTOCOBRO99 CHAR(4);
    NUMCUOTACOBRO99    CHAR(4);
    IDTITULARCTA99     CHAR(11);
    TIPOID99           CHAR(3);
    TIPOCTA99          CHAR(3);
    NUMTARJETA99       CHAR(16);
    CODERROR99         CHAR(4);
    DESCERROR99        CHAR(80);
    JAQL99ITMO         NUMBER(3);
    JAQL99ITTR         NUMBER(3);
    JAQL99ITRE         NUMBER(4);
  
    cursor resp is
      select CODPRODUCTOcobro99,
             NUMCERTIFICADOcobro99,
             NUMCUOTACOBRO99,
             FECPAGOCUOTA99,
             DOCDEPOSITO99,
             FECDEPOSITO99,
             decode(trim(CODERROR99), '00', '', CODERROR99) CODERROR99,
             decode(trim(CODERROR99), 'D6', '', DESCERROR99) DESCERROR99,
             MONTOPRIMACUOTA99
        from jaql099 j
       where JAQL99FEPR = PGFAPE
         and CODPRODUCTOcobro99 = '0004'
         AND j.descerror99 = 'D6';
  
  begin
  
    begin
    
      begin
        select to_number(max(j.numcertificadocobro99))
          into ln_nrorow
          from jaql099 j
         where j.jaql99fepr = PGFAPE
           and j.codproductocobro99 = '0004';
      end;
    
      numcertificadocobro99 := lpad(to_char(ln_nrorow + 1), 10, '0');
    
      numcta99 := lpad(trim(to_char(ln_cuenta)), 9, '0') ||
                  lpad(trim(to_char(ln_modulo)), 3, '0') ||
                  lpad(trim(to_char(ln_moneda)), 3, '0') ||
                  lpad(trim(to_char(ln_operar)), 9, '0') ||
                  lpad(trim(to_char(ln_tipope)), 3, '0');
    
      if ln_moneda = 101 then
        montoprima := ln_importe *
                      fn_tipo_cambio(pgfape + 1, ln_moneda, 0, 2) * 100;
      else
        if ln_moneda = 0 then
          montoprima := ln_importe * 100;
        end if;
      end if;
    
      CODPRODUCTOCOBRO99 := '0004';
      NUMCUOTACOBRO99    := '0000';
      IDTITULARCTA99     := ' ';
      TIPOID99           := '001';
      TIPOCTA99          := 'CRE';
      NUMTARJETA99       := '0000000000000000';
      CODERROR99         := '00';
      DESCERROR99        := '';
      JAQL99ITMO         := 0;
      JAQL99ITTR         := 0;
      JAQL99ITRE         := 0;
    
      montoprimacuota99 := lpad(to_char(montoprima), 5, '0');
    
      fecemisioncuota99 := to_char(ld_fchcuota, 'yyyymmdd');
      fecpagocuota99    := to_char(ld_fchpago, 'yyyymmdd');
      docdeposito99     := lpad(trim(to_char(ln_cuenta)), 9, '0') ||
                           lpad(trim(to_char(ln_modulo)), 3, '0') ||
                           lpad(trim(to_char(ln_moneda)), 3, '0') ||
                           lpad(trim(to_char(ln_operar)), 9, '0') ||
                           lpad(trim(to_char(ln_tipope)), 3, '0');
      fecdeposito99     := to_char(pgfape, 'yyyymmdd');
      jaql99au01        := to_char(ln_moneda);
    
      begin
        insert into jaql099
        values
          (pgfape,
           CODPRODUCTOCOBRO99,
           numcertificadocobro99,
           NUMCUOTACOBRO99,
           IDTITULARCTA99,
           TIPOID99,
           TIPOCTA99,
           numcta99,
           NUMTARJETA99,
           montoprimacuota99,
           fecemisioncuota99,
           fecpagocuota99,
           docdeposito99,
           fecdeposito99,
           CODERROR99,
           DESCERROR99,
           jaql99au01,
           JAQL99ITMO,
           JAQL99ITTR,
           JAQL99ITRE);
        commit;
      exception
        when others then
          error := sqlerrm;
          dbms_output.put_line(error || '-' || docdeposito99);
        
      end;
    
      begin
        insert into jaql361
        values
          (CODPRODUCTOCOBRO99,
           numcertificadocobro99,
           NUMCUOTACOBRO99,
           fecpagocuota99,
           docdeposito99,
           fecdeposito99,
           '',
           '',
           montoprimacuota99);
        commit;
      exception
        when others then
          error := sqlerrm;
        
      end;
    
    end;
  end sp_cr_copiainfo;

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
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD', --BANTPROD
                                    tabname          => 'JAQZ085_AUX',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
  
    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD', --BANTPROD
                                    tabname          => 'JAQY145',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
  
    execute immediate 'truncate table JAQY145';
  
    for job in c_clientes_job loop
    
      lc_variable := ' begin ' || ' PQ_CR_VIDACAJA_REGULA.Sp_carga_VC(''' ||
                     job.digito || ''',''' || pd_fecini || ''',''' ||
                     pd_fecpro || ''');' || ' End; ';
      ln_cont     := ln_cont + 1;
    
      if (ln_cont >= 50) then
        ln_inst := 1;
      end if;
    
      ln_job := ln_job + 1;
    
      --              DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
      /*  
      if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
          DBMS_JOB.SUBMIT(job       => ln_job,
                          what      => lc_variable,
                          next_date => sysdate + 1 / (24 * 60),
                          interval  => null,
                          no_parse  => false,
                          instance  => 2, --ln_inst,
                          --instance => 1,--Solo por hoy 01.07.2015 hmev
                          force => false);
       else
          DBMS_JOB.SUBMIT(job       => ln_job,
                          what      => lc_variable,
                          next_date => sysdate + 1 / (24 * 60),
                          interval  => null,
                          no_parse  => false,
                          --instance => 1,--Solo por hoy 01.07.2015 hmev
                          force => false);
       end if;             
       commit;
       */
    
      --    if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
 --     if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
      
        dbms_scheduler.create_job(job_name   => 'SEG_VIDA' ||
                                                LPAD(TO_CHAR(ln_job),
                                                     5,
                                                     '0'),
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => true,
                                  comments   => 'PAGOS VIDA CAJA');

IF SYS.FN_BD_ISRAC='TRUE' THEN
        begin
          dbms_scheduler.set_attribute('SEG_VIDA' ||
                                       LPAD(TO_CHAR(ln_job), 5, '0'),
                                       'instance_id',
                                       2);
        end;
      else
        dbms_scheduler.create_job(job_name   => 'SEG_VIDA' ||
                                                LPAD(TO_CHAR(ln_job),
                                                     5,
                                                     '0'),
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => true,
                                  comments   => 'PAGOS VIDA CAJA');
      end if;
      commit;
    
    end loop;
  
  end sp_cr_cargaVC_job;

  ---------------
  procedure sp_cr_Desafilia60_job(pd_fecini IN date, pd_fecpro IN date) is
  
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
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD', --BANTPROD
                                    tabname          => 'JAQZ085_AUX',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
  
    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD', --BANTPROD
                                    tabname          => 'JAQY145',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
  
    -- execute immediate 'truncate table JAQY145';
  
    for job in c_clientes_job loop
    
      lc_variable := ' begin ' ||
                     ' PQ_CR_VIDACAJA_REGULA.sp_cr_Desafilia60(''' ||
                     job.digito || ''',''' || pd_fecini || ''',''' ||
                     pd_fecpro || ''');' || ' End; ';
      ln_cont     := ln_cont + 1;
    
      if (ln_cont >= 50) then
        ln_inst := 1;
      end if;
    
      ln_job := ln_job + 1;
    
      --    if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--      if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
      
        dbms_scheduler.create_job(job_name   => 'SEG_VIDA' ||
                                                LPAD(TO_CHAR(ln_job),
                                                     5,
                                                     '0'),
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => true,
                                  comments   => 'PAGOS VIDA CAJA');
IF SYS.FN_BD_ISRAC='TRUE' THEN
        begin
          dbms_scheduler.set_attribute('SEG_VIDA' ||
                                       LPAD(TO_CHAR(ln_job), 5, '0'),
                                       'instance_id',
                                       2);
        end;
      else
        dbms_scheduler.create_job(job_name   => 'SEG_VIDA' ||
                                                LPAD(TO_CHAR(ln_job),
                                                     5,
                                                     '0'),
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => true,
                                  comments   => 'PAGOS VIDA CAJA');
      end if;
      commit;
    
    end loop;
  
  end sp_cr_Desafilia60_job;

  ---------------
  procedure sp_cr_OtrosDesafilia60_job(pd_fecini IN date,
                                       pd_fecpro IN date) is
  
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
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD', --BANTPROD
                                    tabname          => 'JAQZ085_AUX',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
  
    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD', --BANTPROD
                                    tabname          => 'JAQY145',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
  
    -- execute immediate 'truncate table JAQY145';
  
    for job in c_clientes_job loop
    
      lc_variable := ' begin ' ||
                     ' PQ_CR_VIDACAJA_REGULA.sp_cr_OtrosDesafilia60(''' ||
                     job.digito || ''',''' || pd_fecini || ''',''' ||
                     pd_fecpro || ''');' || ' End; ';
      ln_cont     := ln_cont + 1;
    
      if (ln_cont >= 50) then
        ln_inst := 1;
      end if;
    
      ln_job := ln_job + 1;
    
      --    if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--      if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
      
        dbms_scheduler.create_job(job_name   => 'SEG_VIDA' ||
                                                LPAD(TO_CHAR(ln_job),
                                                     5,
                                                     '0'),
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => true,
                                  comments   => 'PAGOS VIDA CAJA');
IF SYS.FN_BD_ISRAC='TRUE' THEN
        begin
          dbms_scheduler.set_attribute('SEG_VIDA' ||
                                       LPAD(TO_CHAR(ln_job), 5, '0'),
                                       'instance_id',
                                       2);
        end;
      else
        dbms_scheduler.create_job(job_name   => 'SEG_VIDA' ||
                                                LPAD(TO_CHAR(ln_job),
                                                     5,
                                                     '0'),
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => true,
                                  comments   => 'PAGOS VIDA CAJA');
      end if;
      commit;
    
    end loop;
  
  end sp_cr_OtrosDesafilia60_job;

  ---------------
  ---------------------------------------------------

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
                          ln_mntseg in number,
                          ln_codvar in number,
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
    if ln_codvar = 1 then
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
           and a.ppimp11 = ln_mntseg
           and a.ppfpag between pd_fecini and pd_fecfin
           and rownum = 1;
      exception
        when others then
          insert into jaqz097_error values (pn_cta, pn_ope, 3, pd_fecpro);
      end;
    
    else
      if ln_codvar = 2 then
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
             and a.ppimp12 = ln_mntseg
             and a.ppfpag between pd_fecini and pd_fecfin
             and rownum = 1;
        exception
          when others then
            insert into jaqz097_error
            values
              (pn_cta, pn_ope, 3, pd_fecpro);
        end;
      
      end if;
    end if;
  
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
    ld_fecnew  date;
    ln_mntseg  number;
    ld_fecfin  date; -- 2016.06.21
    ln_numcuo  number := 0;
  
  begin
  
    ld_fecini := to_date('01' || to_char(pd_fecpro, 'mmyyyy'), 'ddmmyyyy');
    lc_tip    := null;
  
    ln_mtoseg1 := 1.5; --moneda soles y dolares
    ln_mtoseg2 := 2.5; --moneda soles y dolares
    ln_mtoseg3 := 1; --0.58,0.59,0.60,0.90  <1 si moneda es dolares
    --ln_mtoseg4 := 
  
    begin
    
      begin
        --pagos
        begin
          select a.pp001imp
            into ln_mntseg
            from fpp001 a
           where a.pgcod = pn_emp
             and a.aomod = pn_mod
             and a.aosuc = pn_suc
             and a.aomda = pn_mda
             and a.aopap = pn_pap
             and a.aocta = pn_cta
             and a.aooper = pn_ope
             and a.aosbop = pn_sbo
             and a.aotope = pn_top
             and a.sgcod in (116, 117, 118, 119, 120, 121, 122);
        end;
        begin
          PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                              ln_mntseg => ln_mntseg,
                                              ln_codvar => ln_codVar,
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
            PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                ln_mntseg => ln_mntseg,
                                                ln_codvar => ln_codVar,
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
              PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                  ln_mntseg => ln_mntseg,
                                                  ln_codvar => ln_codVar,
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
                PQ_CR_VIDACAJA_REGULA.sp_cronograma(pn_emp    => pn_emp,
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
                                                    ln_mntseg => ln_mntseg,
                                                    ln_codvar => ln_codVar,
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
               (ln_mto11 < ln_mtoseg3 and pn_mda = 101) then
            ln_mtoseg := ln_mto11;
            ln_codVar := 1;
          when ln_mto12 = ln_mtoseg1 or ln_mto12 = ln_mtoseg2 or
               (ln_mto12 < ln_mtoseg3 and pn_mda = 101) then
            ln_mtoseg := ln_mto12;
            ln_codVar := 2;
          when ln_mto13 = ln_mtoseg1 or ln_mto13 = ln_mtoseg2 or
               (ln_mto13 < ln_mtoseg3 and pn_mda = 101) then
            ln_mtoseg := ln_mto13;
            ln_codVar := 3;
          when ln_mto14 = ln_mtoseg1 or ln_mto14 = ln_mtoseg2 or
               (ln_mto14 < ln_mtoseg3 and pn_mda = 101) then
            ln_mtoseg := ln_mto14;
            ln_codVar := 4;
          when ln_mto15 = ln_mtoseg1 or ln_mto15 = ln_mtoseg2 or
               (ln_mto15 < ln_mtoseg3 and pn_mda = 101) then
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
                PQ_CR_VIDACAJA_REGULA.sp_cr_gracia(pn_emp    => pn_emp,
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
                if ln_mtoprima / ln_mtoseg = 2 then
                  --si es el doble y tiene gracia 
                  ln_mtoprima := ln_mtoseg;
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
                PQ_CR_VIDACAJA_REGULA.sp_cr_gracia(pn_emp    => pn_emp,
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
                if ln_mtoprima / ln_mtoseg = 2 then
                  --si es el doble y tiene gracia 
                  ln_mtoprima := ln_mtoseg;
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
                PQ_CR_VIDACAJA_REGULA.sp_cr_gracia(pn_emp    => pn_emp,
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
                if ln_mtoprima / ln_mtoseg = 2 then
                  --si es el doble y tiene gracia 
                  ln_mtoprima := ln_mtoseg;
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
                PQ_CR_VIDACAJA_REGULA.sp_cr_gracia(pn_emp    => pn_emp,
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
                if ln_mtoprima / ln_mtoseg = 2 then
                  --si es el doble y tiene gracia 
                  ln_mtoprima := ln_mtoseg;
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
                PQ_CR_VIDACAJA_REGULA.sp_cr_gracia(pn_emp    => pn_emp,
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
                if ln_mtoprima / ln_mtoseg = 2 then
                  --si es el doble y tiene gracia 
                  ln_mtoprima := ln_mtoseg;
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
          PQ_CR_VIDACAJA_REGULA.sp_cr_validapago(ln_pgcod     => pn_emp,
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
  
  end Sp_monto_calendarioSVC;
  ----------------------

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
end PQ_CR_VIDACAJA_REGULA;
/

