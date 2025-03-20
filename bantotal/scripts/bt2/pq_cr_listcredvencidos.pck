create or replace package PQ_CR_LISTCREDVENCIDOS is

  -- Author  : MPOSTIGOC
  -- Created : 31/05/2018 9:37:00 a. m.
  -- Purpose : 

  -- Public type declarations
  procedure Sp_Cr_Inicio;
  ------------------------------------------
  procedure sp_cr_montDeuda2(pn_emp        in number,
                             pn_mod        in number,
                             pn_suc        in number,
                             pn_mda        in number,
                             pn_pap        in number,
                             pn_cta        in number,
                             pn_ope        in number,
                             pn_sbo        in number,
                             pn_top        in number,
                             pd_fecpro     in date,
                             ln_MontDeuda2 out number);
  ------------------------------------------------
  procedure sp_cr_montDeuda1(pn_emp    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_ope    in number,
                             pn_sbo    in number,
                             pn_top    in number,
                             pd_fecpro in date);

end PQ_CR_LISTCREDVENCIDOS;
/

create or replace package body PQ_CR_LISTCREDVENCIDOS is

  procedure Sp_Cr_Inicio is
  
    cursor lista_CredVenc is
    
      select f.PGCOD  pgcod,
             f.SCSUC  Sucursal,
             f.SCRUB  Rubro,
             f.SCMDA  Moneda,
             f.SCPAP  Papel,
             f.SCCTA  Cuenta,
             f.SCOPER Operacion,
             f.SCSBOP SubOperacion,
             f.SCTOPE TipoOperacion,
             f.SCMOD  Modulo,
             f.SCSDO  SaldoCapital,
             f.SCSTAT Estado,
             /*h.pepais Pais,
             h.petdoc TipDoc,
             h.pendoc NroDoc,
             j.penom  Nombre_Cliente,*/
             f.scgru GrupoSBS
        from fsd011 f, fst111 g, regsuc r
       where f.scsuc = r.sucurs
         and f.pgcod = 1
         and f.scmod = g.modulo
         and f.scstat <> 99
         and f.scmod not in (200, 33)
         and g.dscod = 50
         and r.regcod in (6, 1); --Arequipa 1,Andina 6
  
    ln_mntdeud1 number(10, 2);
    --ln_mntdeud2    number(10, 2);
    ln_diaatraso   number;
    ld_FechProc    date;
    nombre_cliente varchar2(150);
    nrodoc         varchar2(12);
    pais           number;
    tipdoc         number;
  
  begin
    begin
      execute immediate 'truncate table JAQZ844';
      commit;
    end;
  
    for l in lista_CredVenc loop
    
      begin
        select j.jaql964mtd,
               j.jaql964dia,
               j.jaql964fec,
               j.jaql964tit,
               j.jaql964doc,
               j.jaql964pai,
               j.jaql964tid
          into ln_mntdeud1,
               ln_diaatraso,
               ld_FechProc,
               nombre_cliente,
               nrodoc,
               pais,
               tipdoc
          from jaql964 j
         where j.jaql964pgcod = l.pgcod
           and j.jaql964mod = l.modulo
           and j.jaql964suc = l.sucursal
           and j.jaql964mda = l.moneda
           and j.jaql964pap = l.papel
           and j.jaql964cta = l.cuenta
           and j.jaql964ope = l.operacion
           and j.jaql964sob = l.suboperacion
           and j.jaql964top = l.tipooperacion
           and rownum = 1;
      exception
        when others then
          null;
      end;
    
      /* begin
        pq_cr_listcredvencidos.sp_cr_montDeuda2(pn_emp        => l.pgcod,
                                                pn_mod        => l.modulo,
                                                pn_suc        => l.sucursal,
                                                pn_mda        => l.moneda,
                                                pn_pap        => l.papel,
                                                pn_cta        => l.cuenta,
                                                pn_ope        => l.operacion,
                                                pn_sbo        => l.suboperacion,
                                                pn_top        => l.tipooperacion,
                                                pd_fecpro     => ld_FechProc,
                                                ln_MontDeuda2 => ln_mntdeud2);
      end;*/
    
      if (l.gruposbs in (2, 3, 5, 6, 7, 8, 9, 10, 12, 13) and
         ln_diaatraso >= 9) or (l.gruposbs = 4 and ln_diaatraso >= 31) then
      
        begin
          insert into jaqz844
            (jaqz844pais,
             jaqz844tdoc,
             jaqz844ndoc,
             jaqz844nomb,
             jaqz844pgcod,
             jaqz844suc,
             jaqz844rub,
             jaqz844mda,
             jaqz844pap,
             jaqz844cta,
             jaqz844ope,
             jaqz844sbop,
             jaqz844tope,
             jaqz844mod,
             jaqz844saldcap,
             jaqz844est,
             jaqz844grup,
             jaqz844mntmor1,
             jaqz844mntmor2,
             jaqz844diatr)
          values
            (pais,
             tipdoc,
             nrodoc,
             nombre_cliente,
             l.pgcod,
             l.sucursal,
             l.rubro,
             l.moneda,
             l.papel,
             l.cuenta,
             l.operacion,
             l.suboperacion,
             l.tipooperacion,
             l.modulo,
             l.saldocapital,
             l.estado,
             l.gruposbs,
             0.0,
             0.0,
             ln_diaatraso);
        exception
          when others then
            DBMS_OUTPUT.PUT_LINE(l.cuenta || '-' || l.operacion || '-' ||
                                 l.suboperacion);
          
        end;
        commit;
      
      end if;
    
    end loop;
  
  end sp_cr_inicio;
  ------------------------------------------------------
  procedure sp_cr_montDeuda2(pn_emp        in number,
                             pn_mod        in number,
                             pn_suc        in number,
                             pn_mda        in number,
                             pn_pap        in number,
                             pn_cta        in number,
                             pn_ope        in number,
                             pn_sbo        in number,
                             pn_top        in number,
                             pd_fecpro     in date,
                             ln_MontDeuda2 out number) is
  
  begin
  
    select sum(r.Mont_Deuda)
      into ln_MontDeuda2
      from (select a.pgcod,
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
                       and aa.ppfpag <= a.ppfpag),
                   a.ppfpag,
                   pq_cr_cuotamora.fn_monto_cuota(a.pgcod,
                                                  a.ppmod,
                                                  a.ppsuc,
                                                  a.ppmda,
                                                  a.pppap,
                                                  a.ppcta,
                                                  a.ppoper,
                                                  a.ppsbop,
                                                  a.pptope,
                                                  a.ppfpag,
                                                  a.ppcap,
                                                  a.ppint,
                                                  pd_fecpro) Mont_Deuda,
                   pd_fecpro - a.ppfpag,
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
                    --and aa.ppfpag <= a.ppfpag mod@abr 20161130
                    ),
                   (select max(o.pp1fech)
                      from fsd602 o
                     where o.pgcod = a.pgcod
                       and o.ppmod = a.ppmod
                       and o.ppsuc = a.ppsuc
                       and o.ppmda = a.ppmda
                       and o.pppap = a.pppap
                       and o.ppcta = a.ppcta
                       and o.ppoper = a.ppoper
                       and o.ppsbop = a.ppsbop
                       and o.pptope = a.pptope
                       and o.pp1stat = 'T'
                       and o.d602co = 'S'
                       and (o.pp1cap + o.pp1int) <> 0
                       and o.pp1fech <= pd_fecpro),
                   (select aofvto
                      from fsd010 h
                     where h.pgcod = a.pgcod
                       and h.aomod = a.ppmod
                       and h.aosuc = a.ppsuc
                       and h.aomda = a.ppmda
                       and h.aopap = a.pppap
                       and h.aocta = a.ppcta
                       and h.aooper = a.ppoper
                       and h.aosbop = a.ppsbop
                       and h.aotope = a.pptope)
            
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
               and not exists
             (select b.ppmod,
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
             order by a.ppfpag) r;
  
  end sp_cr_montdeuda2;
  --------------------------------------------------------------------------
  procedure sp_cr_montDeuda1(pn_emp    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_ope    in number,
                             pn_sbo    in number,
                             pn_top    in number,
                             pd_fecpro in date) is
  
    cursor lista_DetalleCred is
      select a.pgcod ln_pgcod,
             a.ppmod ln_ppmod,
             a.ppsuc ln_ppsuc,
             a.ppmda ln_ppmda,
             a.pppap ln_pppap,
             a.ppcta ln_ppcta,
             a.ppoper ln_ppoper,
             a.ppsbop ln_ppsbop,
             a.pptope ln_pptope,
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
                 and aa.ppfpag <= a.ppfpag) TotalCuotPorPagar,
             a.ppfpag fch_Pago,
             pq_cr_cuotamora.fn_monto_cuota(a.pgcod,
                                            a.ppmod,
                                            a.ppsuc,
                                            a.ppmda,
                                            a.pppap,
                                            a.ppcta,
                                            a.ppoper,
                                            a.ppsbop,
                                            a.pptope,
                                            a.ppfpag,
                                            a.ppcap,
                                            a.ppint,
                                            pd_fecpro) Mont_Cuota,
             pd_fecpro - a.ppfpag DiasAtraso,
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
              --and aa.ppfpag <= a.ppfpag mod@abr 20161130
              ) TotalCuotas,
             (select max(o.pp1fech)
                from fsd602 o
               where o.pgcod = a.pgcod
                 and o.ppmod = a.ppmod
                 and o.ppsuc = a.ppsuc
                 and o.ppmda = a.ppmda
                 and o.pppap = a.pppap
                 and o.ppcta = a.ppcta
                 and o.ppoper = a.ppoper
                 and o.ppsbop = a.ppsbop
                 and o.pptope = a.pptope
                 and o.pp1stat = 'T'
                 and o.d602co = 'S'
                 and (o.pp1cap + o.pp1int) <> 0
                 and o.pp1fech <= pd_fecpro) UltPagoTotal,
             (select aofvto
                from fsd010 h
               where h.pgcod = a.pgcod
                 and h.aomod = a.ppmod
                 and h.aosuc = a.ppsuc
                 and h.aomda = a.ppmda
                 and h.aopap = a.pppap
                 and h.aocta = a.ppcta
                 and h.aooper = a.ppoper
                 and h.aosbop = a.ppsbop
                 and h.aotope = a.pptope) FchVencimiento
      
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
  
  begin
  
/*    for l in lista_DetalleCred loop
    
      insert into JAQZ845
        (JAQZ845PGCOD,
         JAQZ845SUC,
         JAQZ845MDA,
         JAQZ845PAP,
         JAQZ845CTA,
         JAQZ845OPE,
         JAQZ845SBOP,
         JAQZ845TOPE,
         JAQZ845MOD,
         JAQZ845MNTCUO,
         JAQZ845DIATR,
         JAQZ845TOTCUOXPAG,
         JAQZ845FPAG,
         JAQZ845TOTCUOT,
         JAQZ845FULPAG,
         JAQZ845FVENC)
      values
        (l.ln_pgcod,
         l.ln_ppsuc,
         l.ln_ppmda,
         l.ln_pppap,
         l.ln_ppcta,
         l.ln_ppoper,
         l.ln_ppsbop,
         l.ln_ppsbop,
         l.ln_ppmod,
         l.Mont_Cuota,
         l.DiasAtraso,
         l.TotalCuotPorPagar,
         l.fch_Pago,
         l.TotalCuotas,
         l.UltPagoTotal,
         l.FchVencimiento);
    
    end loop;*/
    null;
  
  end sp_cr_montdeuda1;

end PQ_CR_LISTCREDVENCIDOS;
/

