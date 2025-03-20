CREATE OR REPLACE PACKAGE PQ_CR_PROYECTOS_NEG_A IS

PROCEDURE sp_cuota_cabecera(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pd_fecpro in date,
                           ubuser in varchar,
                           id_aqpb601cod in number);

PROCEDURE sp_consolidado_cuotas(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number,
                           pd_fecpro in date,
                           vo_tcap out number,
                           vo_tic out number,
                           vo_ticv out number,
                           vo_tmor out number,
                           vo_tpen out number,
                           vo_tseg out number,
                           vo_totr out number,
                           vo_ttot out number,
                           vo_datr out number);

PROCEDURE sp_obtener_lista_pna(ve_pais in number, ve_tipodoc in number, ve_numdoc in varchar, ubuser in varchar);

PROCEDURE sp_DetalleCuotaMora(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pd_fecpro in date,
                           ubuser in varchar,
                           id_aqpb601cod in number);

PROCEDURE sp_monto_cuota(pn_emp    in number,
                          pn_mod    in number,
                          pn_suc    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number,
                          pn_ope    in number,
                          pn_sbo    in number,
                          pn_top    in number,
                          pd_fec    in date,
                          pn_cap    in number,
                          pn_int    in number,
                          pd_fecpro in date,
                          ve_cap out number,
                          ve_ic out number,
                          ve_icv out number,
                          ve_mor out number,
                          ve_pen out number,
                          ve_seg out number,
                          ve_otr out number,
                          ve_tot out number);

PROCEDURE sp_cred_castigado(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pn_sta in number,
                          vo_capital out number,
                          vo_interes out number,
                          vo_mora out number,
                          vo_gastos out number,
                          vo_total out number);

PROCEDURE sp_obtener_nro_refin(pn_emp in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               vo_total out number);

PROCEDURE sp_obtener_fec_castigo(pn_emp in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               vo_fecc out date);

PROCEDURE sp_obtener_informacion_rl(pn_emp in number,
                                   pn_mod in number,
                                   pn_suc in number,
                                   pn_mda in number,
                                   pn_pap in number,
                                   pn_cta in number,
                                   pn_ope in number,
                                   pn_sbo in number,
                                   pn_top in number,
                                   vo_fec_rl out date,
                                   vo_fec_aabo out date,
                                   vo_fec_dem out date,
                                   vo_fec_adem out date,
                                   vo_abog out varchar);

END PQ_CR_PROYECTOS_NEG_A;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_PROYECTOS_NEG_A IS

PROCEDURE sp_cuota_cabecera(pn_emp    in number,
                            pn_mod    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_ope    in number,
                            pn_sbo    in number,
                            pn_top    in number,
                            pd_fecpro in date,
                            ubuser    in varchar,
                            id_aqpb601cod in number) IS

  cursor lista_creditos is
    select a.pgcod,
           a.ppint,
           a.ppcap,
           a.ppmod,
           a.ppsuc,
           a.ppmda,
           a.pppap,
           a.ppcta,
           a.ppoper,
           a.ppsbop,
           a.pptope,
           (select count(*)
              from fsd601 aa
             where aa.pgcod = a.pgcod
               and aa.ppmod = a.ppmod
               and aa.ppsuc = a.ppsuc
               and aa.ppmda = a.ppmda
               and aa.pppap = a.pppap
               and aa.ppcta = a.ppcta
               and aa.ppoper = a.ppoper
               and aa.ppsbop = a.ppsbop
               and aa.pptope = a.pptope
               and aa.d601co = 'S') as ncuota,
           a.ppfpag as fecpago
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
       and a.d601co = 'S'
       and a.ppfpag <= pd_fecpro
       and not exists (select b.ppmod,
                   b.ppsuc,
                   b.ppmda,
                   b.pppap,
                   b.ppcta,
                   b.ppoper,
                   b.ppsbop,
                   b.pptope,
                   b.ppfpag
              from fsd602 b
             where b.pgcod = a.pgcod
               and b.ppmod = a.ppmod
               and b.ppsuc = a.ppsuc
               and b.ppmda = a.ppmda
               and b.pppap = a.pppap
               and b.ppcta = a.ppcta
               and b.ppoper = a.ppoper
               and b.ppsbop = a.ppsbop
               and b.pptope = a.pptope
               and b.ppfpag = a.ppfpag
               and b.d602co = 'S'
               and b.pp1stat = 'T'
               and (b.pp1cap + b.pp1int) <> 0)
     order by a.ppfpag;

  vi_scap  number;
  vi_ic    number;
  vi_icv   number;
  vi_mor   number;
  vi_pen   number;
  vi_otr   number;
  vi_seg   number;
  vi_dtot  number;
  vi_datr  number;
  vi_usra  varchar(12);
  vi_agen  fst001.scnom%type;
  vi_cpag  number; -- cuotas pagadas
  vi_tcpa  number; -- total cuotas pagadas
  vi_cpcp  varchar(12);
  vi_cven  number;
  vi_repr  number;
  vi_refi  number;
  vi_estc  varchar(25);
  vi_fecp  date;
  vi_inst  xwf700.xwfprcins%type;
  vi_codst fsd011.scstat%type;

  vi_fcas date;
  vi_fenv date;
  vi_fasi date;
  vi_fdem date;
  vi_fvca date;
  vi_fide date;
  vi_abog varchar(150);

begin

  BEGIN
    select a.scsdo, a.scstat
      into vi_scap, vi_codst
      from fsd011 a
     where a.pgcod = pn_emp
       and a.scsuc = pn_suc
       and a.scmda = pn_mda
       and a.scpap = pn_pap
       and a.sccta = pn_cta
       and a.scoper = pn_ope
       and a.scsbop = pn_sbo
       and a.sctope = pn_top
       and a.scmod = pn_mod;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  BEGIN
    select b.xwfprcins
      into vi_inst
      from xwf700 b
     where b.xwfempresa = pn_emp
       and b.xwfsucursal = pn_suc
       and b.xwfmoneda = pn_mda
       and b.xwfpapel = pn_pap
       and b.xwfcuenta = pn_cta
       and b.xwfoperacion = pn_ope
       and b.xwfsubope = pn_sbo
       and b.xwftipope = pn_top
       and b.xwfmodulo = pn_mod
       and b.xwfcar3 = '1'
       and b.xwfprcins = (select max(b.xwfprcins)
                            from xwf700 b
                           where b.xwfempresa = pn_emp
                             and b.xwfsucursal = pn_suc
                             and b.xwfmoneda = pn_mda
                             and b.xwfpapel = pn_pap
                             and b.xwfcuenta = pn_cta
                             and b.xwfoperacion = pn_ope
                             and b.xwfsubope = pn_sbo
                             and b.xwftipope = pn_top
                             and b.xwfmodulo = pn_mod
                             and b.xwfcar3 = '1');
    select b.sng001ase
      into vi_usra
      from sng001 b
     where b.sng001inst = vi_inst;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  BEGIN
    select c.scnom into vi_agen from fst001 c where c.sucurs = pn_suc;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  BEGIN
    select count(*)
      into vi_cpag
      from fsd601 a
     inner join fsd602 b
        on a.pgcod = b.pgcod
       and a.ppmod = b.ppmod
       and a.ppsuc = b.ppsuc
       and a.ppmda = b.ppmda
       and a.pppap = b.pppap
       and a.ppcta = b.ppcta
       and a.ppoper = b.ppoper
       and a.ppsbop = b.ppsbop
       and a.pptope = b.pptope
       and a.ppfpag = b.ppfpag
       and b.pp1stat = 'T'
     where a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  BEGIN
    select count(*)
      into vi_tcpa
      from fsd601
     where ppcta = pn_cta
       and ppoper = pn_ope;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  vi_cpcp := TO_CHAR(vi_cpag) || '/' || TO_CHAR(vi_tcpa);

  BEGIN
    select CENOM into vi_estc from fst026 where CECOD = vi_codst;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  BEGIN
    select a.aofvto
      into vi_fecp
      from fsd010 a
     where a.pgcod = pn_emp
       and a.aosuc = pn_suc
       and a.aomda = pn_mda
       and a.aopap = pn_pap
       and a.aocta = pn_cta
       and a.aooper = pn_ope
       and a.aosbop = pn_sbo
       and a.aotope = pn_top
       and a.aomod = pn_mod;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  BEGIN
    PQ_CR_PROYECTOS_NEG_A.sp_consolidado_cuotas(pn_emp,
                                                pn_mod,
                                                pn_suc,
                                                pn_mda,
                                                pn_pap,
                                                pn_cta,
                                                pn_ope,
                                                pn_sbo,
                                                pn_top,
                                                pd_fecpro,
                                                vi_scap,
                                                vi_ic,
                                                vi_icv,
                                                vi_mor,
                                                vi_pen,
                                                vi_seg,
                                                vi_otr,
                                                vi_dtot,
                                                vi_datr);

  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  /*
    BEGIN
      pq_cr_constas_repro_cobranzas.sp_obtener_nro_repro(pn_cta,
                                                       pn_ope,
                                                       pn_sbo,
                                                       vi_repr);

    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  */
  BEGIN

    PQ_CR_PROYECTOS_NEG_A.sp_obtener_nro_refin(pn_emp,
                                                pn_mod,
                                                pn_suc,
                                                pn_mda,
                                                pn_pap,
                                                pn_cta,
                                                pn_ope,
                                                pn_sbo,
                                                pn_top,
                                                vi_refi);

  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  BEGIN

    PQ_CR_PROYECTOS_NEG_A.sp_obtener_fec_castigo(pn_emp,
                                                 pn_mod,
                                                 pn_suc,
                                                 pn_mda,
                                                 pn_pap,
                                                 pn_cta,
                                                 pn_ope,
                                                 pn_sbo,
                                                 pn_top,
                                                 vi_fcas);

  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  BEGIN

    PQ_CR_PROYECTOS_NEG_A.sp_obtener_informacion_rl(pn_emp,
                                                 pn_mod,
                                                 pn_suc,
                                                 pn_mda,
                                                 pn_pap,
                                                 pn_cta,
                                                 pn_ope,
                                                 pn_sbo,
                                                 pn_top,
                                                 vi_fenv,
                                                 vi_fasi,
                                                 vi_fdem,
                                                 vi_fide,
                                                 vi_abog);

  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  BEGIN
    UPDATE aqpb601 a
       set
           a.aqpb601scap = vi_scap,
           a.aqpb601icon = vi_ic,
           a.aqpb601icv  = vi_icv,
           a.aqpb601mora = vi_mor,a.aqpb601pena= vi_pen,a.aqpb601otro = vi_otr,a.aqpb601segu = vi_seg,
           a.aqpb601dtot = vi_dtot,a.aqpb601datr = 0, a.aqpb601agen = vi_agen,
           a.aqpb601cpcp = vi_cpcp, a.aqpb601cven = vi_cven,a.aqpb601repr = vi_repr,a.aqpb601refi = vi_refi,
           a.aqpb601estc = vi_estc,a.aqpb601fecp = vi_fecp,a.aqpb601usra = vi_usra,
           a.aqpb601fcas = vi_fcas,a.aqpb601fenv = vi_fenv,
           a.aqpb601fasi = vi_fasi,a.aqpb601fdem = vi_fdem,a.aqpb601fvca = vi_fvca,a.aqpb601fide = vi_fide,
           a.aqpb601abog = vi_abog,a.aqpb601datr = vi_datr
           WHERE AQPB601COD = id_aqpb601cod;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.put_line(SQLERRM);
  END;
  COMMIT;
END;

PROCEDURE sp_consolidado_cuotas(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number,
                           pd_fecpro in date,
                           vo_tcap out number,
                           vo_tic out number,
                           vo_ticv out number,
                           vo_tmor out number,
                           vo_tpen out number,
                           vo_tseg out number,
                           vo_totr out number,
                           vo_ttot out number,
                           vo_datr out number) is
    -- *****************************************************************
    -- Nombre                     : sp_consolidado_cuotas
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Moras
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.08.03
    -- Autor de Creación          : gcentenoz
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
   cursor lista_creditos is
   select a.pgcod,
             a.ppint,
             a.ppcap,
             a.ppmod,
             a.ppsuc,
             a.ppmda,
             a.pppap,
             a.ppcta,
             a.ppoper,
             a.ppsbop,
             a.pptope,
             (select count(*)
                from fsd601 aa
               where aa.pgcod = a.pgcod
                 and aa.ppmod = a.ppmod
                 and aa.ppsuc = a.ppsuc
                 and aa.ppmda = a.ppmda
                 and aa.pppap = a.pppap
                 and aa.ppcta = a.ppcta
                 and aa.ppoper = a.ppoper
                 and aa.ppsbop = a.ppsbop
                 and aa.pptope = a.pptope
                 and aa.d601co = 'S'
                 and aa.ppfpag <= a.ppfpag) as ncuota,
             a.ppfpag as fecpago,
             case
               when (pd_fecpro - a.ppfpag) > 0 then
                 pd_fecpro - a.ppfpag
               else 0
               end
                  as datraso
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
         and a.d601co = 'S'
         and a.ppfpag <= pd_fecpro
         and not exists (select b.ppmod,
                     b.ppsuc,
                     b.ppmda,
                     b.pppap,
                     b.ppcta,
                     b.ppoper,
                     b.ppsbop,
                     b.pptope,
                     b.ppfpag
                from fsd602 b
               where b.pgcod = a.pgcod
                 and b.ppmod = a.ppmod
                 and b.ppsuc = a.ppsuc
                 and b.ppmda = a.ppmda
                 and b.pppap = a.pppap
                 and b.ppcta = a.ppcta
                 and b.ppoper = a.ppoper
                 and b.ppsbop = a.ppsbop
                 and b.pptope = a.pptope
                 and b.ppfpag = a.ppfpag
                 and b.d602co = 'S'
                 and b.pp1stat = 'T'
                 and (b.pp1cap + b.pp1int) <> 0)
       order by a.ppfpag;

       vi_fecpro date;
       vi_cap  number;
       vi_ic  number;
       vi_icv  number;
       vi_mor  number;
       vi_pen  number;
       vi_seg  number;
       vi_otr  number;
       vi_tot  number;
  begin

       vo_tcap := 0;
       vo_tic := 0;
       vo_ticv := 0;
       vo_tmor := 0;
       vo_tpen := 0;
       vo_tseg := 0;
       vo_totr := 0;
       vo_ttot := 0;
       vo_datr :=0;

       FOR x in lista_creditos LOOP

           begin
             select pgfape into vi_fecpro from fst017 where pgcod = 1;

           EXCEPTION WHEN OTHERS THEN
              NULL;
           END;

           PQ_CR_PROYECTOS_NEG_A.sp_monto_cuota(x.pgcod,
                                            x.ppmod,
                                            x.ppsuc,
                                            x.ppmda,
                                            x.pppap,
                                            x.ppcta,
                                            x.ppoper,
                                            x.ppsbop,
                                            x.pptope,
                                            x.fecpago,
                                            x.ppcap,
                                            x.ppint,
                                            pd_fecpro, -- POR MOTIVOS DE PRUEBA REGRESAR A VI_fecpro
                                            vi_cap,
                                            vi_ic,
                                            vi_icv,
                                            vi_mor,
                                            vi_pen,
                                            vi_seg,
                                            vi_otr,
                                            vi_tot);
           if vo_datr < x.datraso then
             vo_datr := x.datraso;
           end if;

           vo_tcap := vo_tcap + vi_cap;
           vo_tic := vo_tic + vi_ic;
           vo_ticv := vo_ticv + vi_icv;
           vo_tmor := vo_tmor + vi_mor;
           vo_tpen := vo_tpen + vi_pen;
           vo_tseg := vo_tseg + vi_seg;
           vo_totr := vo_totr + vi_otr;
           vo_ttot := vo_ttot + vi_tot;

       END LOOP;
  end;

PROCEDURE sp_obtener_lista_pna(ve_pais in number, ve_tipodoc in number, ve_numdoc in varchar, ubuser in varchar) IS
  --20/01/2025 MHUAMANIA Se optimizó la consulta por TRIM  
  cursor lista_pna is
  --select * from fsr008 f where f.pepais=ve_pais and f.petdoc=ve_tipodoc and trim(f.pendoc)=ve_numdoc;
  select * from fsr008 f where f.pepais=ve_pais and f.petdoc=ve_tipodoc and f.pendoc= rpad(ve_numdoc,12,' ');

  vi_cod fsd011.PGCOD%type;
  vi_suc fsd011.SCSUC%type;
  vi_mon fsd011.SCMDA%type;
  vi_pap fsd011.SCPAP%type;
  vi_cta fsd011.SCCTA%type;
  vi_ope fsd011.SCOPER%type;
  vi_subope fsd011.SCSBOP%type;
  vi_tipope fsd011.SCTOPE%type;
  vi_modulo fsd011.SCMOD%type;
  vi_scap fsd011.SCSDO%type;
  vi_estado fsd011.SCSTAT%type;

  modulo fst003.MDNOM%type;
  estado fst026.CENOM%type;
  tipope fst004.tonom%type;

  vi_fecpro date;

  ID_AQPB601COD number;

  begin

  execute immediate 'delete from AQPB601 where aqpb601usrr = :ubuser' using ubuser;
      commit;

      FOR xdata in lista_pna LOOP
          vi_cod := 0;
          vi_suc := 0;
          vi_mon := 0;
          vi_pap := 0;
          vi_cta := 0;
          vi_ope := 0;
          vi_subope := 0;
          vi_tipope := 0;
          vi_modulo := 0;
          vi_scap := 0;
          vi_estado := 0;
           BEGIN
             select d.pgcod,d.scsuc,d.scmda,d.scpap,d.sccta,d.scoper,d.scsbop,d.sctope,d.scmod,d.scsdo,d.scstat
             into vi_cod,vi_suc,vi_mon,vi_pap,vi_cta,vi_ope,vi_subope,vi_tipope,vi_modulo,vi_scap,vi_estado
             from xwf700 x
             inner join fsd011 d
                on d.pgcod = x.xwfempresa
               and d.scmod = x.xwfmodulo
               and d.scsuc = x.xwfsucursal
               and d.scpap = x.xwfpapel
               and d.sccta = x.xwfcuenta
               and d.scoper = x.xwfoperacion
               and d.scsbop = x.xwfsubope
               and d.sctope = x.xwftipope
               and d.scstat <> 99
               where x.xwfcuenta = xdata.CTNRO
               and x.xwfcar3 = '1';
           EXCEPTION
            WHEN OTHERS THEN
              NULL;
           END;

           IF vi_cta <> 0 THEN
               BEGIN
                  select CENOM
                  into estado
                  from fst026
                  where CECOD=vi_estado;
               EXCEPTION
                  WHEN OTHERS THEN
                    NULL;
               END;

               BEGIN
                  select MDNOM
                  into modulo
                  from fst003
                  where modulo=vi_modulo;
               EXCEPTION
                  WHEN OTHERS THEN
                    NULL;
               END;

               BEGIN
                  select tonom
                  into tipope
                  from fst004
                  where modulo=vi_modulo
                  and totope=vi_tipope;
               EXCEPTION
                  WHEN OTHERS THEN
                    NULL;
               END;

                BEGIN
                  select pgfape
                  into vi_fecpro
                  from fst017
                  where pgcod = 1;
               EXCEPTION
                  WHEN OTHERS THEN
                    NULL;
               END;

              BEGIN
                INSERT INTO
                AQPB601 A (A.aqpb601pais,A.aqpb601ptdc,A.aqpb601pnd,A.aqpb601emp,A.AQPB601SUC,A.AQPB601MDA,A.AQPB601PAP,A.AQPB601CTA,A.AQPB601OPER,A.AQPB601SBOP,A.AQPB601TOP,A.AQPB601MOD,
                          A.AQPB601SCAP,A.AQPB601EST,A.AQPB601ESTM,A.AQPB601MODM,A.AQPB601TOPM,A.aqpb601usrr,A.aqpb601fecr)
                          VALUES (ve_pais,ve_tipodoc,ve_numdoc,vi_cod,vi_suc,vi_mon,vi_pap,vi_cta,vi_ope,vi_subope,vi_tipope,vi_modulo,vi_scap,vi_estado,estado,modulo,tipope,ubuser,sysdate)
                          returning AQPB601COD into ID_AQPB601COD;
                          DBMS_OUTPUT.put_line(ID_AQPB601COD);
                           --INVOCAMOS ESTEPROCESO PARA ACTUALIZAR LOS REGISTRO DE LA CABECERA
                          PQ_CR_PROYECTOS_NEG_A.sp_cuota_cabecera(vi_cod,vi_modulo,vi_suc,vi_mon,
                                                                 vi_pap,vi_cta,vi_ope,vi_subope,
                                                                 vi_tipope,vi_fecpro,ubuser,ID_AQPB601COD);
                          --INVOCAMOS ESTE PROCESO PARA INSERTAR EL DETALLE DEL CREDITO
                          PQ_CR_PROYECTOS_NEG_A.sp_DetalleCuotaMora(vi_cod,vi_modulo,vi_suc,vi_mon,
                                                                   vi_pap,vi_cta,vi_ope,vi_subope,
                                                                   vi_tipope,vi_fecpro,ubuser,ID_AQPB601COD);
              EXCEPTION WHEN OTHERS THEN
                 DBMS_OUTPUT.put_line(SQLERRM);
              END;
          END IF;
      END LOOP;
      COMMIT;
  end;

  PROCEDURE sp_DetalleCuotaMora(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pd_fecpro in date,
                           ubuser in varchar,
                           id_aqpb601cod in number) is
    -- *****************************************************************
    -- Nombre                     : sp_DetalleCuotaMora
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Moras
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.08.03
    -- Autor de Creación          : gcentenoz
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
   cursor lista_creditos is
   select a.pgcod,
             a.ppint,
             a.ppcap,
             a.ppmod,
             a.ppsuc,
             a.ppmda,
             a.pppap,
             a.ppcta,
             a.ppoper,
             a.ppsbop,
             a.pptope,
             (select count(*)
                from fsd601 aa
               where aa.pgcod = a.pgcod
                 and aa.ppmod = a.ppmod
                 and aa.ppsuc = a.ppsuc
                 and aa.ppmda = a.ppmda
                 and aa.pppap = a.pppap
                 and aa.ppcta = a.ppcta
                 and aa.ppoper = a.ppoper
                 and aa.ppsbop = a.ppsbop
                 and aa.pptope = a.pptope
                 and aa.d601co = 'S'
                 and aa.ppfpag <= a.ppfpag) as ncuota,
             a.ppfpag as fecpago,
             case
               when (pd_fecpro - a.ppfpag) > 0 then
                 pd_fecpro - a.ppfpag
               else 0
               end
                  as datraso
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
         and a.d601co = 'S'
         and a.ppfpag <= pd_fecpro
         and not exists (select b.ppmod,
                     b.ppsuc,
                     b.ppmda,
                     b.pppap,
                     b.ppcta,
                     b.ppoper,
                     b.ppsbop,
                     b.pptope,
                     b.ppfpag
                from fsd602 b
               where b.pgcod = a.pgcod
                 and b.ppmod = a.ppmod
                 and b.ppsuc = a.ppsuc
                 and b.ppmda = a.ppmda
                 and b.pppap = a.pppap
                 and b.ppcta = a.ppcta
                 and b.ppoper = a.ppoper
                 and b.ppsbop = a.ppsbop
                 and b.pptope = a.pptope
                 and b.ppfpag = a.ppfpag
                 and b.d602co = 'S'
                 and b.pp1stat = 'T'
                 and (b.pp1cap + b.pp1int) <> 0)
       order by a.ppfpag;

       vi_fecpro date;
       vi_cap  number;
       vi_ic  number;
        vi_icv  number;
        vi_mor  number;
        vi_pen  number;
        vi_seg  number;
        vi_otr  number;
        vi_tot  number;
  begin

      execute immediate 'delete from AQPB601D where AQPB601Dusrr = :ubuser' using ubuser;
      commit;

       FOR x in lista_creditos LOOP

           begin
             select pgfape into vi_fecpro from fst017 where pgcod = 1;

           EXCEPTION WHEN OTHERS THEN
              NULL;
           END;

           PQ_CR_PROYECTOS_NEG_A.sp_monto_cuota(x.pgcod,
                                            x.ppmod,
                                            x.ppsuc,
                                            x.ppmda,
                                            x.pppap,
                                            x.ppcta,
                                            x.ppoper,
                                            x.ppsbop,
                                            x.pptope,
                                            x.fecpago,
                                            x.ppcap,
                                            x.ppint,
                                            pd_fecpro, -- POR MOTIVOS DE PRUEBA REGRESAR A VI_fecpro
                                            vi_cap,
                                            vi_ic,
                                            vi_icv,
                                            vi_mor,
                                            vi_pen,
                                            vi_seg,
                                            vi_otr,
                                            vi_tot);
         BEGIN
                INSERT INTO
                AQPB601D (aqpb601dcodp,
                          aqpb601dncuo,
                          aqpb601dfecv,
                          aqpb601ddatr,
                          aqpb601dcapi,
                          aqpb601dic,
                          aqpb601dicv,
                          aqpb601dmora,
                          aqpb601dpena,
                          aqpb601dsegu,
                          aqpb601dotro,
                          aqpb601dtotc,
                          aqpb601dusrr,
                          aqpb601dfecr )
                          VALUES (id_aqpb601cod,x.ncuota,x.fecpago,x.datraso,vi_cap,vi_ic,vi_icv,vi_mor,vi_pen,vi_seg,vi_otr,vi_tot,ubuser,sysdate);
                 COMMIT;
              EXCEPTION WHEN OTHERS THEN
                 DBMS_OUTPUT.put_line(SQLERRM);
              END;
       END LOOP;
  end;


  PROCEDURE sp_monto_cuota(pn_emp    in number,
                          pn_mod    in number,
                          pn_suc    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number,
                          pn_ope    in number,
                          pn_sbo    in number,
                          pn_top    in number,
                          pd_fec    in date,
                          pn_cap    in number,
                          pn_int    in number,
                          pd_fecpro in date,
                          ve_cap out number,
                          ve_ic out number,
                          ve_icv out number,
                          ve_mor out number,
                          ve_pen out number,
                          ve_seg out number,
                          ve_otr out number,
                          ve_tot out number) is
    -- *****************************************************************
    -- Nombre                     : sp_monto_cuota
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Moras
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.08.03
    -- Autor de Creación          : gcentenoz
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_com       number(17, 2);
    ln_mor       number(17, 2);
    ln_tasint    number(10, 5);
    ln_tasmor    number(10, 5);
    ln_mto       number(17, 2);
    ln_seg       number(17, 2);
    ln_dia       number(5);
    ln_capA      number(17, 2);
    ln_intA      number(17, 2);
    ln_segA      number(17, 2);
    ln_capTotal  number(17, 2);
    ln_intTotal  number(17, 2);
    ln_segTotal  number(17, 2);
    ln_morA      number(17, 2);
    ln_icvA      number(17, 2);
    ln_morTotal  number(17, 2); --mod@abr 20171011
    ln_icvTotal  number(17, 2); --mod@abr 20171011
    ld_fecpago   date;
    ln_pen       number(17, 2); --mod@abr20180328
    ln_penA      number(17, 2); --mod@abr20180328
    ln_penTotal  number(17, 2); --mod@abr20180328
    ln_oro       number(17, 2); --mod@abr20180412
    ln_oroA      number(17, 2); --mod@abr20180412
    ln_oroTotal  number(17, 2); --mod@abr20180412
    ln_diaP      number(5); --mod@abr20190416
    ld_fecmaxPag date; --mod@abr20200318
    ld_fecGuia   date; --mod@abr20200318
    lc_flg       char(1); --mod@abr20200318
  begin
    --tasa de interes
    ln_tasint := pq_cr_cuotamora.BT_Tasa_Interes(pn_emp,
                                                 pn_mod,
                                                 pn_suc,
                                                 pn_mda,
                                                 pn_pap,
                                                 pn_cta,
                                                 pn_ope,
                                                 pn_sbo,
                                                 pn_top);
    --tasa de mora
    ln_tasmor := pq_cr_cuotamora.BT_Tasa_Mora(pn_emp,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top);
    --pagos adelantado
    --mod@abr 20190624
    pq_cr_cuotamora.Sp_PagoAdelantado_new(pn_emp,
                                          pn_mod,
                                          pn_suc,
                                          pn_mda,
                                          pn_pap,
                                          pn_cta,
                                          pn_ope,
                                          pn_sbo,
                                          pn_top,
                                          pd_fec,
                                          ln_capA,
                                          ln_intA,
                                          ln_segA,
                                          ln_morA,
                                          ln_icvA,
                                          ld_fecpago,
                                          ln_penA,
                                          ln_oroA);

    --pq_cr_cuotamora.Sp_PagoAdelantado(pn_emp, --mod@abr 20190624
    --                                  pn_mod,  --mod@abr 20190624
    --                                 pn_suc,  --mod@abr 20190624
    --                                  pn_mda,  --mod@abr 20190624
    --                                  pn_pap,  --mod@abr 20190624
    --                                  pn_cta,  --mod@abr 20190624
    --                                  pn_ope,  --mod@abr 20190624
    --                                  pn_sbo,  --mod@abr 20190624
    --                                  pn_top,  --mod@abr 20190624
    --                                  pd_fec,  --mod@abr 20190624
    --                                  ln_tasint, --mod@abr 20190624
    --                                  ln_tasmor, --mod@abr 20190624
    --                                  --pd_fecpro, mod@abr20190328
    --                                  pn_cap,     --mod@abr 20190624
    --                                  pn_int,     --mod@abr 20190624
    --                                  ln_capA,    --mod@abr 20190624
    --                                  ln_intA,    --mod@abr 20190624
    --                                  ln_segA,    --mod@abr 20190624
    --                                  ln_morA,    --mod@abr 20190624
    --                                  ln_icvA,    --mod@abr 20190624
    --                                  ld_fecpago, --mod@abr 20190624
    --                                  ln_penA,    --mod@abr 20190624
    --                                  ln_oroA);   --mod@abr 20190624
    --mod@abr 20190624
    --mod@abr 20200318
    begin
      select max(a.pp1fech)
        into ld_fecmaxPag
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.d602co = 'S';
    exception
      when others then
        null;
    end;
    /* comentado solo para pruebas para no considerar la fehca de cuerentena. O DIAS DE ATRASO PERDONADO.
    begin
      select to_date(tp1desc, 'dd/mm/yyyy')
        into ld_fecGuia
        from fst198
       where TP1COD = 1
         and TP1COD1 = 11105
         and TP1CORR1 = 35
         and TP1CORR2 = 1
         and TP1CORR3 = 1;
    exception
      when others then
        null;
    end;
    */
    lc_flg := 'N';

    begin
      select 'N' --CAMBIANDO DE S A N POR PRUEBA REVERTIR.
        into lc_flg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 44444
         and a.tp1corr2 = 1
         and tp1nro1 = 1;
    exception
      when others then
        null;
    end;

    if ld_fecmaxPag > ld_fecGuia then
      ld_fecGuia := ld_fecmaxPag;
    end if;
    --mod@abr 20200318
    --dias de atraso

    if lc_flg = 'S' then
      --mod@abr 20200318
      if ld_fecpago is not null then
        --mod@abr 20200318
        ln_dia := ld_fecGuia - ld_fecpago; --mod@abr 20200318
      else
        ln_dia := ld_fecGuia - pd_fec; --mod@abr 20200318
      end if;

      ln_diaP := ld_fecGuia - pd_fec; --mod@abr 20200318
    else
      if ld_fecpago is not null then
        ln_dia := pd_fecpro - ld_fecpago;
      else
        ln_dia := pd_fecpro - pd_fec;
      end if;

      ln_diaP := pd_fecpro - pd_fec;
    end if;

    --seguros
    begin
      select a.ppimp11 + a.ppimp12 + a.ppimp13 + a.ppimp14
        into ln_seg
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
         and a.ppfpag = pd_fec;
    exception
      when others then
        null;
    end;

    --mod@abr20190328
    pq_cr_cuotamora.Sp_penalidad(pn_emp => pn_emp,
                                 pn_mod => pn_mod,
                                 pn_suc => pn_suc,
                                 pn_mda => pn_mda,
                                 pn_pap => pn_pap,
                                 pn_cta => pn_cta,
                                 pn_ope => pn_ope,
                                 pn_sbo => pn_sbo,
                                 pn_top => pn_top,
                                 pn_dia => ln_diaP,
                                 pn_pen => ln_pen);
    --mod@abr20190328

    --mod@abr20190412
    pq_cr_cuotamora.Sp_otrosRubrosOblig(pn_emp => pn_emp,
                                        pn_mod => pn_mod,
                                        pn_suc => pn_suc,
                                        pn_mda => pn_mda,
                                        pn_pap => pn_pap,
                                        pn_cta => pn_cta,
                                        pn_ope => pn_ope,
                                        pn_sbo => pn_sbo,
                                        pn_top => pn_top,
                                        pd_fec => pd_Fec,
                                        pn_mto => ln_oro);
    --mod@abr20190412

    ln_capTotal := nvl(pn_cap, 0) - nvl(ln_capA, 0);
    ln_intTotal := nvl(pn_int, 0) - nvl(ln_intA, 0);
    ln_segTotal := nvl(ln_seg, 0) - nvl(ln_segA, 0);
    ln_penTotal := nvl(ln_pen, 0) - nvl(ln_penA, 0); --mod@abr20190328
    if ln_penTotal < 0 then
      ln_penTotal := 0;
    end if;

    ln_oroTotal := nvl(ln_oro, 0) - nvl(ln_oroA, 0); --mod@abr20190412
    --interes compensatorio
    ln_com := round((Power(1 + (ln_tasint / 100), (ln_dia / 360)) - 1) *
                    (ln_capTotal + ln_intTotal),
                    2);
    --interes moratorio
    ln_mor := round((Power(1 + (ln_tasmor / 100), (ln_dia / 360)) - 1) *
                    (ln_capTotal + ln_intTotal),
                    2);

    --ln_morTotal := nvl(ln_mor, 0) + nvl(ln_morA, 0); --mod@abr 20171011 --mod@abr 20190624
    --ln_icvTotal := nvl(ln_com, 0) + nvl(ln_icvA, 0); --mod@abr 20171011 --mod@abr 20190624

    ln_morTotal := nvl(ln_mor, 0) - nvl(ln_morA, 0); --mod@abr 20190624
    ln_icvTotal := nvl(ln_com, 0) - nvl(ln_icvA, 0); --mod@abr 20190624

    ve_cap := ln_capTotal;
    ve_ic := ln_intTotal;
    ve_icv := ln_icvTotal;
    ve_mor := ln_morTotal;
    ve_pen := ln_penTotal;
    ve_seg := ln_segTotal;
    ve_otr := ln_oroTotal;


    ln_mto := nvl(ln_segTotal, 0) + nvl(ln_icvTotal, 0) +
              nvl(ln_morTotal, 0) + nvl(ln_capTotal, 0) + --mod@abr 20171011
              nvl(ln_intTotal, 0) + nvl(ln_penTotal, 0) + --mod@abr20190328
              nvl(ln_oroTotal, 0); --mod@abr20190412
    ve_tot := ln_mto;
  end;

PROCEDURE sp_cred_castigado(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pn_sta in number,
                          vo_capital out number,
                          vo_interes out number,
                          vo_mora out number,
                          vo_gastos out number,
                          vo_total out number) is

  vi_corr2 FST198.Tp1corr2%type;
  vi_corr3 FST198.Tp1corr3%type;
  vi_nrol FST198.Tp1nro1%type;
  RelInt number;
  vi_desc FST198.Tp1desc%type;
  RubMor varchar(100);
  RubGas varchar(100);

  vi_capital FSD011.scsdo%type;
  rubro FSD011.Scrub%type;
  capital number;

  vi_interes FSD011.scsdo%type;
  interes number;

  vi_mora FSD011.scsdo%type;
  mora number;

  RubCon FSR014.Rrrubr%type;

  vi_scsdo FSD011.scsdo%type;
  gastos number;

  total number;

  BEGIN

     BEGIN
        select Tp1corr2,Tp1corr3,Tp1nro1,Tp1desc
        into vi_corr2,vi_corr3,vi_nrol,vi_desc
        from FST198
        where Tp1cod = pn_emp
        and Tp1cod1 = 10850
        and Tp1corr1 = 3;

        case
          when vi_corr2 = 1 and vi_corr3 = 4 then
            RelInt := vi_nrol;
          when vi_corr2 = 2 then
            if vi_corr3 = pn_mda then
               RubMor := trim(vi_desc);
            end if;
          when vi_corr2 = 3 then
            if vi_corr3 = pn_mda then
               RubGas := trim(vi_desc);
            end if;
        end case;

     EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line(SQLERRM);
     END;

     BEGIN
        select scsdo,Scrub
        into vi_capital,rubro
        from FSD011
        where Pgcod  = pn_emp
        and Sccta  = pn_cta
        and Scmda  = pn_mda
        and Scpap  = pn_pap
        and Scoper = pn_ope
        and Scsbop = pn_sbo
        and Scmod  = pn_mod
        and Scstat = pn_sta;

        capital := vi_capital * -1;
        vo_capital := capital;
     EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line(SQLERRM);
     END;

     BEGIN
        select Rrrubr
        into RubCon
        from FSR014
        where Rubro = rubro
        and Rrcod = RelInt;
     EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line(SQLERRM);
     END;

     BEGIN
        select scsdo
        into vi_interes
        from FSD011
        where Pgcod  = pn_emp
        and Scrub  = RubCon
        and Sccta  = pn_cta
        and Scoper = pn_ope
        and Scsbop = pn_sbo;

        interes := vi_interes * -1;
        vo_interes := interes;
     EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line(SQLERRM);
     END;

     BEGIN
        select scsdo
        into vi_mora
        from FSD011
        where Pgcod  = pn_emp
        and Scrub  = RubMor
        and Sccta  = pn_cta
        and Scoper = pn_ope
        and Scsbop = pn_sbo;

        mora := vi_mora * -1;
        vo_mora := mora;
     EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line(SQLERRM);
     END;

     BEGIN
        select scsdo
        into vi_scsdo
        from FSD011
        where Pgcod  = pn_emp
        and Scrub  = RubGas
        and Sccta  = pn_cta
        and Scoper = pn_cta
        and Scsbop = pn_sbo;

        gastos := vi_scsdo * -1;
        vo_gastos := gastos;
     EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line(SQLERRM);
     END;

     total := capital + interes + mora + gastos;
     vo_total := total;

  END;

PROCEDURE sp_obtener_nro_refin(pn_emp in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               vo_total out number) is

    nro_refinan number;
    tot_nro_refif number;
    cursor lista_refinanciados is
    select * from fst198 t where t.tp1cod=1 and t.tp1cod1=10899 and t.tp1corr1=400100 and tp1corr2=1 and tp1corr3>0;
 begin
      tot_nro_refif := 0;
      nro_refinan:= 0;
      for x in lista_refinanciados loop
        nro_refinan := 0;
        select count(*) into nro_refinan from (
        select distinct d602fc from fsd602 where
         pgcod= pn_emp and
         ppmod= pn_mod and
         ppsuc= pn_suc and
         ppmda= pn_mda and
         pppap= pn_pap and
         ppcta= pn_cta and
         ppoper= pn_ope and
         ppsbop= pn_sbo and
         pptope= pn_top and
         d602mo=x.tp1nro1 and d602tr=x.tp1nro2 and d602co='S');
       tot_nro_refif := tot_nro_refif + nro_refinan;
       end loop;
       vo_total := tot_nro_refif;
       dbms_output.put_line(tot_nro_refif);
 end;

PROCEDURE sp_obtener_fec_castigo(pn_emp in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               vo_fecc out date)is
   fec_castigo date;
   num_reg number;
 begin
   begin
        select jaql174nro into num_reg from jaql175
        where jaql175emp = pn_emp
        and jaql175suc = pn_suc
        and jaql175cta = pn_cta
        and jaql175pap = pn_pap
        and jaql175ope = pn_ope
        and jaql175sbo = pn_sbo
        and jaql175mda = pn_mda
        and jaql175mod = pn_mod
        and jaql175top = pn_top;
    end;
    begin
      select jaql174fec
      into fec_castigo
      from jaql174
     where jaql174nro = num_reg;
     vo_fecc := fec_castigo;
     dbms_output.put_line(fec_castigo);
    end;
 end;

PROCEDURE sp_obtener_informacion_rl(pn_emp in number,
                                   pn_mod in number,
                                   pn_suc in number,
                                   pn_mda in number,
                                   pn_pap in number,
                                   pn_cta in number,
                                   pn_ope in number,
                                   pn_sbo in number,
                                   pn_top in number,
                                   vo_fec_rl out date,
                                   vo_fec_aabo out date,
                                   vo_fec_dem out date,
                                   vo_fec_adem out date,
                                   vo_abog out varchar) is

  FEC_RL DATE;
  FEC_AABO DATE;
  FEC_DEM DATE;
  FEC_ADEM DATE;
  ABOG VARCHAR(150);
 BEGIN
   SELECT
   JAQL964FIRL, -- FEC. ENVAIDO A RL
   jaql964FAABO,-- FEC. ASIGNACION DE ABOGADO
   JAQL964FDEM,-- FEC. DE DEMANDA
   JAQL964FADEM,  -- FEC. DE ASIGNACION DE DEMANDA
   JAQL964ABO -- ABOGADO EXTERNO
   INTO
   FEC_RL,
   FEC_AABO,
   FEC_DEM,
   FEC_ADEM,
   ABOG
    FROM JAQL964 T
   WHERE T.JAQL964PGCOD=pn_emp
     AND T.JAQL964MOD=pn_mod
     AND T.JAQL964SUC=pn_suc
     AND T.JAQL964CTA=pn_cta
     AND T.JAQL964OPE=pn_ope
     AND T.JAQL964SOB=pn_sbo
     AND T.JAQL964PAP=pn_pap
     AND T.JAQL964MDA=pn_mda
     AND T.JAQL964TOP=pn_top;

    vo_fec_rl := FEC_RL;
    vo_fec_aabo := FEC_AABO;
    vo_fec_dem := FEC_DEM;
    vo_fec_adem := FEC_ADEM;
    vo_abog := ABOG;
 END;

END PQ_CR_PROYECTOS_NEG_A;
/

