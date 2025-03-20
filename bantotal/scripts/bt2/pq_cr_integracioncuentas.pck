create or replace package PQ_CR_INTEGRACIONCUENTAS is

  -- Author  : MPOSTIGOC
  -- Created : 11/07/2018 7:05:39 p. m.
  -- Purpose : 

  procedure sp_cr_Inicio(ln_Pgcod116    in number,
                         ln_ctnro116    in number,
                         ln_Itoper116   in number,
                         ln_Itsubo116   in number,
                         ln_Itsucd116   in number,
                         ln_Ittope116   in number,
                         ln_Modulo116   in number,
                         ln_Moneda116   in number,
                         ln_Papel116    in number,
                         Pcancel        out varchar2,
                         lc_FlagJAQZ849 out number);
  ----------------------------------------------------------                         
  procedure sp_cr_IntegraSolicitud(ln_Pgcod116  in number,
                                   ln_ctnro116  in number,
                                   ln_Itoper116 in number,
                                   ln_Itsubo116 in number,
                                   ln_Itsucd116 in number,
                                   ln_Ittope116 in number,
                                   ln_Modulo116 in number,
                                   ln_Moneda116 in number,
                                   ln_Papel116  in number);
  ----------------------------------------------------------------
  procedure sp_cr_IntegraGarantia(ln_Pgcod116  in number,
                                  ln_ctnro116  in number,
                                  ln_Itoper116 in number,
                                  ln_Itsubo116 in number,
                                  ln_Itsucd116 in number,
                                  ln_Ittope116 in number,
                                  ln_Modulo116 in number,
                                  ln_Moneda116 in number,
                                  ln_Papel116  in number);
  ----------------------------------------------------------------
  procedure sp_cr_InsertaJAQZ850(ln_Pgcod116  in number,
                                 ln_ctnro116  in number,
                                 ln_Itoper116 in number,
                                 ln_Itsubo116 in number,
                                 ln_Itsucd116 in number,
                                 ln_Ittope116 in number,
                                 ln_Modulo116 in number,
                                 ln_Moneda116 in number,
                                 ln_Papel116  in number,
                                 ln_Instancia in number,
                                 ln_NroCuenta in number,
                                 ln_pais      in number,
                                 ln_tdoc      in number,
                                 lc_ndoc      in varchar2,
                                 lc_nombre    in varchar2,
                                 lc_tipcta    in varchar2,
                                 lc_indicad   in varchar2,
                                 ln_parte     in varchar2);
  -------------------------------------------------------------------
  procedure sp_cr_listadofinalSolic(ln_Pgcod116  in number,
                                    ln_ctnro116  in number,
                                    ln_Itoper116 in number,
                                    ln_Itsubo116 in number,
                                    ln_Itsucd116 in number,
                                    ln_Ittope116 in number,
                                    ln_Modulo116 in number,
                                    ln_Moneda116 in number,
                                    ln_Papel116  in number);
  -----------------------------------------------------------------
  procedure sp_cr_listadofinalGarant(ln_Pgcod116  in number,
                                     ln_ctnro116  in number,
                                     ln_Itoper116 in number,
                                     ln_Itsubo116 in number,
                                     ln_Itsucd116 in number,
                                     ln_Ittope116 in number,
                                     ln_Modulo116 in number,
                                     ln_Moneda116 in number,
                                     ln_Papel116  in number);
  ------------------------------------------------------------------
  procedure sp_cr_InsertaJAQZ849(ln_Pgcod116  in number,
                                 ln_ctnro116  in number,
                                 ln_Itoper116 in number,
                                 ln_Itsubo116 in number,
                                 ln_Itsucd116 in number,
                                 ln_Ittope116 in number,
                                 ln_Modulo116 in number,
                                 ln_Moneda116 in number,
                                 ln_Papel116  in number,
                                 ln_Cuenta    in number,
                                 ln_pais      in number,
                                 ln_tdoc      in number,
                                 lc_ndoc      in varchar2,
                                 lc_nomb      in varchar2,
                                 lc_indicad   in varchar2,
                                 lc_TIPCTA    in varchar2,
                                 lc_parte     in varchar2);

end PQ_CR_INTEGRACIONCUENTAS;
/

create or replace package body PQ_CR_INTEGRACIONCUENTAS is

  procedure sp_cr_Inicio(ln_Pgcod116    in number,
                         ln_ctnro116    in number,
                         ln_Itoper116   in number,
                         ln_Itsubo116   in number,
                         ln_Itsucd116   in number,
                         ln_Ittope116   in number,
                         ln_Modulo116   in number,
                         ln_Moneda116   in number,
                         ln_Papel116    in number,
                         Pcancel        out varchar2,
                         lc_FlagJAQZ849 out number) is
  
    --  lc_FlagJAQZ849 number;
  
  begin
  
    begin
      delete from jaqz850 j
       where j.jaqz850pgcod = ln_Pgcod116
         and j.jaqz850ctnro = ln_ctnro116
         and j.jaqz850itoper = ln_Itoper116
         and j.jaqz850itsubo = ln_Itsubo116
         and j.jaqz850itsucd = ln_Itsucd116
         and j.jaqz850ittope = ln_Ittope116
         and j.jaqz850modulo = ln_Modulo116
         and j.jaqz850moneda = ln_Moneda116
         and j.jaqz850papel = ln_Papel116;
      commit;
    
    end;
  
    begin
      delete from jaqz849 j
       where j.jaqz849pgcod = ln_Pgcod116
         and j.jaqz849ctnro = ln_ctnro116
         and j.jaqz849itoper = ln_Itoper116
         and j.jaqz849itsubo = ln_Itsubo116
         and j.jaqz849itsucd = ln_Itsucd116
         and j.jaqz849ittope = ln_Ittope116
         and j.jaqz849modulo = ln_Modulo116
         and j.jaqz849moneda = ln_Moneda116
         and j.jaqz849papel = ln_Papel116;
      commit;
    end;
  
    pq_cr_integracioncuentas.sp_cr_IntegraSolicitud(ln_Pgcod116,
                                                    ln_ctnro116,
                                                    ln_Itoper116,
                                                    ln_Itsubo116,
                                                    ln_Itsucd116,
                                                    ln_Ittope116,
                                                    ln_Modulo116,
                                                    ln_Moneda116,
                                                    ln_Papel116);
  
    pq_cr_integracioncuentas.sp_cr_IntegraGarantia(ln_Pgcod116,
                                                   ln_ctnro116,
                                                   ln_Itoper116,
                                                   ln_Itsubo116,
                                                   ln_Itsucd116,
                                                   ln_Ittope116,
                                                   ln_Modulo116,
                                                   ln_Moneda116,
                                                   ln_Papel116);
  
    pq_cr_integracioncuentas.sp_cr_listadofinalSolic(ln_Pgcod116,
                                                     ln_ctnro116,
                                                     ln_Itoper116,
                                                     ln_Itsubo116,
                                                     ln_Itsucd116,
                                                     ln_Ittope116,
                                                     ln_Modulo116,
                                                     ln_Moneda116,
                                                     ln_Papel116);
  
    pq_cr_integracioncuentas.sp_cr_listadofinalGarant(ln_Pgcod116,
                                                      ln_ctnro116,
                                                      ln_Itoper116,
                                                      ln_Itsubo116,
                                                      ln_Itsucd116,
                                                      ln_Ittope116,
                                                      ln_Modulo116,
                                                      ln_Moneda116,
                                                      ln_Papel116);
  
    begin
    
      begin
        select count(*)
          into lc_FlagJAQZ849
          from jaqz849 j
         where j.jaqz849pgcod = ln_Pgcod116
           and j.jaqz849ctnro = ln_ctnro116
           and j.jaqz849itoper = ln_Itoper116
           and j.jaqz849itsubo = ln_Itsubo116
           and j.jaqz849itsucd = ln_Itsucd116
           and j.jaqz849ittope = ln_Ittope116
           and j.jaqz849modulo = ln_Modulo116
           and j.jaqz849moneda = ln_Moneda116
           and j.jaqz849papel = ln_Papel116
           and j.jaqz849parte = 'GARANTIA';
      end;
      if lc_FlagJAQZ849 > 0 then
        Pcancel := 'S';
      else
        Pcancel := 'N';
      end if;
    end;
  
  end sp_cr_Inicio;
  ---------------------------------------------------------------
  procedure sp_cr_IntegraSolicitud(ln_Pgcod116  in number,
                                   ln_ctnro116  in number,
                                   ln_Itoper116 in number,
                                   ln_Itsubo116 in number,
                                   ln_Itsucd116 in number,
                                   ln_Ittope116 in number,
                                   ln_Modulo116 in number,
                                   ln_Moneda116 in number,
                                   ln_Papel116  in number) is
  
    cursor lista_mancomsolicitud(ln_NroCuenta number) is
      select f.pepais ln_pais,
             f.petdoc ln_tdoc,
             f.pendoc lc_pendoc,
             f.penom lc_penom,
             'MANCOMUNADO' lc_tipcta,
             'OBLIGATORIO' lc_indicad,
             'SOLICITUD' lc_parte
        from fsd001 f, fsr008 r
       where f.pepais = r.pepais
         and f.petdoc = r.petdoc
         and f.pendoc = r.pendoc
         and r.ctnro = ln_NroCuenta;
  
    cursor lista_IndistSolicitud(ln_NroCuenta number) is
      select f.pepais ln_pais,
             f.petdoc ln_tdoc,
             f.pendoc lc_pendoc,
             f.penom lc_penom,
             'INDISTINTA' lc_tipcta,
             'OPCIONAL' lc_indicad,
             'SOLICITUD' lc_parte
        from fsd001 f, fsr008 r
       where f.pepais = r.pepais
         and f.petdoc = r.petdoc
         and f.pendoc = r.pendoc
         and r.ctnro = ln_NroCuenta;
  
    ln_Instancia    number;
    ln_NroCuenta    number;
    ln_PaisDoc      number;
    ln_Tdoc         number;
    lc_Ndoc         varchar2(12);
    ln_NroIntgSoli  number;
    ln_TieneConyuge number;
    lc_Facultad     varchar2(25);
  
  begin
    begin
      ln_Instancia := fn_instancia_credito(v_Scmod  => ln_Modulo116,
                                           v_Scsuc  => ln_Itsucd116,
                                           v_Scmda  => ln_Moneda116,
                                           v_Scpap  => ln_Papel116,
                                           v_Sccta  => ln_ctnro116,
                                           v_Scoper => ln_Itoper116,
                                           v_Scsbop => ln_Itsubo116,
                                           v_Sctope => ln_Ittope116);
    end;
  
    -- ln_Instancia := 3449448;
    begin
      select s.sng001cta, s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_NroCuenta, ln_PaisDoc, ln_Tdoc, lc_Ndoc
        from SNG001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      -- Verifico el nro de Integrantes
      select count(*)
        into ln_NroIntgSoli
        from fsr008 f
       where f.pgcod = 1
         and f.ctnro = ln_NroCuenta;
    end;
  
    if ln_NroIntgSoli = 2 then
      -- Relacion Conyugal
      select count(*)
        into ln_TieneConyuge
        from fsr002 r
       where r.pepais = ln_PaisDoc
         and r.petdoc = ln_Tdoc
         and r.pendoc = lc_Ndoc
         and r.rpccyg = 66;
    end if;
  
    if ln_TieneConyuge = 0 or ln_NroIntgSoli = 1 or ln_NroIntgSoli > 2 then
      --Si es 0, no hay relacion conyugal
      for l in lista_mancomsolicitud(ln_NroCuenta) loop
      
        lc_Facultad := FN_FACULTAD_CTA(vpgcod  => ln_Pgcod116,
                                       vscsuc  => ln_Itsucd116,
                                       vscmda  => ln_Moneda116,
                                       vscpap  => ln_Papel116,
                                       vsccta  => ln_ctnro116,
                                       vscoper => ln_Ittope116,
                                       vscsbop => ln_Itsubo116,
                                       vsctope => ln_Ittope116,
                                       vscmod  => ln_Modulo116);
      
        if lc_Facultad is null then
          -- 23/07/18 mpostigoc
          if ln_NroIntgSoli = 1 then
            lc_Facultad := 'INDIVIDUAL';
          else
            if ln_NroIntgSoli > 1 then
              lc_Facultad := 'MANCOMUNADA';
            end if;
          end if;
        end if;
      
        pq_cr_integracioncuentas.sp_cr_InsertaJAQZ850(ln_Pgcod116  => ln_Pgcod116,
                                                      ln_ctnro116  => ln_ctnro116,
                                                      ln_Itoper116 => ln_Itoper116,
                                                      ln_Itsubo116 => ln_Itsubo116,
                                                      ln_Itsucd116 => ln_Itsucd116,
                                                      ln_Ittope116 => ln_Ittope116,
                                                      ln_Modulo116 => ln_Modulo116,
                                                      ln_Moneda116 => ln_Moneda116,
                                                      ln_Papel116  => ln_Papel116,
                                                      ln_Instancia => ln_Instancia,
                                                      ln_NroCuenta => ln_NroCuenta,
                                                      ln_pais      => l.ln_pais,
                                                      ln_tdoc      => l.ln_tdoc,
                                                      lc_ndoc      => l.lc_pendoc,
                                                      lc_nombre    => l.lc_penom,
                                                      lc_tipcta    => lc_Facultad,
                                                      lc_indicad   => l.lc_indicad,
                                                      ln_parte     => l.lc_parte);
      end loop;
    
    end if;
  
    if ln_TieneConyuge <> 0 then
      -- Si hay relacion conyugal
      for k in lista_IndistSolicitud(ln_NroCuenta) loop
        pq_cr_integracioncuentas.sp_cr_InsertaJAQZ850(ln_Pgcod116  => ln_Pgcod116,
                                                      ln_ctnro116  => ln_ctnro116,
                                                      ln_Itoper116 => ln_Itoper116,
                                                      ln_Itsubo116 => ln_Itsubo116,
                                                      ln_Itsucd116 => ln_Itsucd116,
                                                      ln_Ittope116 => ln_Ittope116,
                                                      ln_Modulo116 => ln_Modulo116,
                                                      ln_Moneda116 => ln_Moneda116,
                                                      ln_Papel116  => ln_Papel116,
                                                      ln_Instancia => ln_Instancia,
                                                      ln_NroCuenta => ln_NroCuenta,
                                                      ln_pais      => k.ln_pais,
                                                      ln_tdoc      => k.ln_tdoc,
                                                      lc_ndoc      => k.lc_pendoc,
                                                      lc_nombre    => k.lc_penom,
                                                      lc_tipcta    => k.lc_tipcta,
                                                      lc_indicad   => k.lc_indicad,
                                                      ln_parte     => k.lc_parte);
      end loop;
    
    end if;
  
  end sp_cr_IntegraSolicitud;
  ---------------------------------------------------
  procedure sp_cr_IntegraGarantia(ln_Pgcod116  in number,
                                  ln_ctnro116  in number,
                                  ln_Itoper116 in number,
                                  ln_Itsubo116 in number,
                                  ln_Itsucd116 in number,
                                  ln_Ittope116 in number,
                                  ln_Modulo116 in number,
                                  ln_Moneda116 in number,
                                  ln_Papel116  in number) is
    cursor lista_CtasGarant(ln_Instancia number) is
      select s.sng122pgc  ln_pgcodGar,
             s.sng122mod  ln_modGar,
             s.sng122suc  ln_sucGar,
             s.sng122mda  ln_mdaGar,
             s.sng122pap  ln_papGar,
             s.sng122cta  ln_ctaGar,
             s.sng122oper ln_operGar,
             s.sng122sbop ln_sbopGar,
             s.sng122tope ln_topeGar
        from sng122 s
       where sng122inst = ln_Instancia
         and s.sng122tope in (80, 85);
  
    cursor lista_GarVig(ln_pgcodGar number,
                        ln_modGar   number,
                        ln_sucGar   number,
                        ln_mdaGar   number,
                        ln_papGar   number,
                        ln_ctaGar   number,
                        ln_operGar  number,
                        ln_sbopGar  number,
                        ln_topeGar  number) is
    
      select r.r1cod,
             r.r1mod,
             r.r1suc,
             r.r1mda,
             r.r1pap,
             r.r1cta,
             r.r1oper,
             r.r1sbop,
             r.r1tope,
             r.relcod
        from fsr011 r, fsd010 f
       where r.r2cod = ln_pgcodGar
         and r.r2mod = ln_modGar
         and r.r2suc = ln_sucGar
         and r.r2mda = ln_mdaGar
         and r.r2pap = ln_papGar
         and r.r2cta = ln_ctaGar
         and r.r2oper = ln_operGar
         and r.r2sbop = ln_sbopGar
         and r.r2tope = ln_topeGar
         and r.relcod = 2
         and r.r1cod = f.pgcod
         and r.r1mod = f.aomod
         and r.r1suc = f.aosuc
         and r.r1mda = f.aomda
         and r.r1pap = f.aopap
         and r.r1cta = f.aocta
         and r.r1oper = f.aooper
         and r.r1sbop = f.aosbop
         and r.r1tope = f.aotope
         and f.aostat <> 99;
  
    cursor lista_mancomGarantia(ln_NroCuenta number) is
      select f.pepais ln_pais,
             f.petdoc ln_tdoc,
             f.pendoc lc_pendoc,
             f.penom lc_penom,
             'MANCOMUNADO' lc_tipcta,
             'OBLIGATORIO' lc_indicad,
             'GARANTIA' lc_parte
        from fsd001 f, fsr008 r
       where f.pepais = r.pepais
         and f.petdoc = r.petdoc
         and f.pendoc = r.pendoc
         and r.ctnro = ln_NroCuenta;
  
    cursor lista_IndistGarantia(ln_NroCuenta number) is
      select f.pepais ln_pais,
             f.petdoc ln_tdoc,
             f.pendoc lc_pendoc,
             f.penom lc_penom,
             'INDISTINTA' lc_tipcta,
             'OPCIONAL' lc_indicad,
             'GARANTIA' lc_parte
        from fsd001 f, fsr008 r
       where f.pepais = r.pepais
         and f.petdoc = r.petdoc
         and f.pendoc = r.pendoc
         and r.ctnro = ln_NroCuenta;
  
    ln_Instancia number;
    lc_Facultad  varchar2(25);
  
  begin
  
    begin
      ln_Instancia := fn_instancia_credito(v_Scmod  => ln_Modulo116,
                                           v_Scsuc  => ln_Itsucd116,
                                           v_Scmda  => ln_Moneda116,
                                           v_Scpap  => ln_Papel116,
                                           v_Sccta  => ln_ctnro116,
                                           v_Scoper => ln_Itoper116,
                                           v_Scsbop => ln_Itsubo116,
                                           v_Sctope => ln_Ittope116);
    end;
  
    ln_Instancia := nvl(ln_Instancia, 0);
    for l in lista_CtasGarant(ln_Instancia) loop
      for g in lista_GarVig(l.ln_pgcodgar,
                            l.ln_modgar,
                            l.ln_sucgar,
                            l.ln_mdagar,
                            l.ln_papgar,
                            l.ln_ctagar,
                            l.ln_opergar,
                            l.ln_sbopgar,
                            l.ln_topegar) loop
      
        lc_Facultad := FN_FACULTAD_CTA(vpgcod  => G.R1COD,
                                       vscsuc  => G.R1SUC,
                                       vscmda  => G.R1MDA,
                                       vscpap  => G.R1PAP,
                                       vsccta  => G.R1CTA,
                                       vscoper => G.R1OPER,
                                       vscsbop => G.R1SBOP,
                                       vsctope => G.R1TOPE,
                                       vscmod  => G.R1MOD);
      
        if lc_Facultad = 'MANCOMUNADA' or lc_Facultad = 'INDIVIDUAL' then
          --Si es 0, no hay relacion conyugal
          for l in lista_mancomGarantia(g.r1cta) loop
          
            pq_cr_integracioncuentas.sp_cr_InsertaJAQZ850(ln_Pgcod116  => ln_Pgcod116,
                                                          ln_ctnro116  => ln_ctnro116,
                                                          ln_Itoper116 => ln_Itoper116,
                                                          ln_Itsubo116 => ln_Itsubo116,
                                                          ln_Itsucd116 => ln_Itsucd116,
                                                          ln_Ittope116 => ln_Ittope116,
                                                          ln_Modulo116 => ln_Modulo116,
                                                          ln_Moneda116 => ln_Moneda116,
                                                          ln_Papel116  => ln_Papel116,
                                                          ln_Instancia => ln_Instancia,
                                                          ln_NroCuenta => G.R1CTA,
                                                          ln_pais      => l.ln_pais,
                                                          ln_tdoc      => l.ln_tdoc,
                                                          lc_ndoc      => l.lc_pendoc,
                                                          lc_nombre    => l.lc_penom,
                                                          lc_tipcta    => lc_Facultad,
                                                          lc_indicad   => l.lc_indicad,
                                                          ln_parte     => l.lc_parte);
          end loop;
        
        end if;
      
        if lc_Facultad = 'INDISTINTA' then
          -- Si hay relacion conyugal
          for k in lista_IndistGarantia(g.r1cta) loop
            pq_cr_integracioncuentas.sp_cr_InsertaJAQZ850(ln_Pgcod116  => ln_Pgcod116,
                                                          ln_ctnro116  => ln_ctnro116,
                                                          ln_Itoper116 => ln_Itoper116,
                                                          ln_Itsubo116 => ln_Itsubo116,
                                                          ln_Itsucd116 => ln_Itsucd116,
                                                          ln_Ittope116 => ln_Ittope116,
                                                          ln_Modulo116 => ln_Modulo116,
                                                          ln_Moneda116 => ln_Moneda116,
                                                          ln_Papel116  => ln_Papel116,
                                                          ln_Instancia => ln_Instancia,
                                                          ln_NroCuenta => g.r1cta,
                                                          ln_pais      => k.ln_pais,
                                                          ln_tdoc      => k.ln_tdoc,
                                                          lc_ndoc      => k.lc_pendoc,
                                                          lc_nombre    => k.lc_penom,
                                                          lc_tipcta    => k.lc_tipcta,
                                                          lc_indicad   => k.lc_indicad,
                                                          ln_parte     => k.lc_parte);
          end loop;
        end if;
      
      end loop;
    end loop;
  end sp_cr_IntegraGarantia;
  -------------------------------------------------
  procedure sp_cr_InsertaJAQZ850(ln_Pgcod116  in number,
                                 ln_ctnro116  in number,
                                 ln_Itoper116 in number,
                                 ln_Itsubo116 in number,
                                 ln_Itsucd116 in number,
                                 ln_Ittope116 in number,
                                 ln_Modulo116 in number,
                                 ln_Moneda116 in number,
                                 ln_Papel116  in number,
                                 ln_Instancia in number,
                                 ln_NroCuenta in number,
                                 ln_pais      in number,
                                 ln_tdoc      in number,
                                 lc_ndoc      in varchar2,
                                 lc_nombre    in varchar2,
                                 lc_tipcta    in varchar2,
                                 lc_indicad   in varchar2,
                                 ln_parte     in varchar2) is
  
    ld_fchsist date;
    lc_hora    char(8);
  begin
  
    begin
      select pgfape into ld_fchsist from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into jaqz850
        (JAQZ850FPROC,
         jaqz850hora,
         JAQZ850Pgcod,
         JAQZ850ctnro,
         JAQZ850Itoper,
         JAQZ850Itsubo,
         JAQZ850Itsucd,
         JAQZ850Ittope,
         JAQZ850Modulo,
         JAQZ850Moneda,
         JAQZ850Papel,
         jaqz850inst,
         jaqz850cta,
         jaqz850pais,
         jaqz850tdoc,
         jaqz850ndoc,
         jaqz850nomb,
         jaqz850tipcta,
         jaqz850indicad,
         jaqz850parte)
      values
        (ld_fchsist,
         lc_hora,
         ln_Pgcod116,
         ln_ctnro116,
         ln_Itoper116,
         ln_Itsubo116,
         ln_Itsucd116,
         ln_Ittope116,
         ln_Modulo116,
         ln_Moneda116,
         ln_Papel116,
         ln_Instancia,
         ln_NroCuenta,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         lc_nombre,
         lc_tipcta,
         lc_indicad,
         ln_parte);
    end sp_cr_InsertaJAQZ850;
    commit;
  
  end sp_cr_InsertaJAQZ850;
  -------------------------------------------------------
  procedure sp_cr_listadofinalSolic(ln_Pgcod116  in number,
                                    ln_ctnro116  in number,
                                    ln_Itoper116 in number,
                                    ln_Itsubo116 in number,
                                    ln_Itsucd116 in number,
                                    ln_Ittope116 in number,
                                    ln_Modulo116 in number,
                                    ln_Moneda116 in number,
                                    ln_Papel116  in number) is
  
    cursor lista_SoliOblig is
      select distinct j.jaqz850pgcod   ln_pgcodtran,
                      j.jaqz850ctnro   ln_ctatran,
                      j.jaqz850itoper  ln_opertran,
                      j.jaqz850itsubo  ln_suboptran,
                      j.jaqz850itsucd  ln_suctran,
                      j.jaqz850ittope  ln_topetran,
                      j.jaqz850modulo  ln_modtran,
                      j.jaqz850moneda  ln_mdatran,
                      j.jaqz850papel   ln_paptran,
                      j.jaqz850cta     ln_ctavinculada,
                      j.jaqz850pais    ln_pais,
                      j.jaqz850tdoc    ln_tdoc,
                      j.jaqz850ndoc    lc_ndoc,
                      j.jaqz850nomb    lc_nomb,
                      j.jaqz850indicad lc_indicad,
                      j.jaqz850tipcta  lc_tipcta,
                      j.jaqz850parte   lc_part
      
        from jaqz850 j
       where j.jaqz850pgcod = ln_Pgcod116
         and j.jaqz850ctnro = ln_ctnro116
         and j.jaqz850itoper = ln_Itoper116
         and j.jaqz850itsubo = ln_Itsubo116
         and j.jaqz850itsucd = ln_Itsucd116
         and j.jaqz850ittope = ln_Ittope116
         and j.jaqz850modulo = ln_Modulo116
         and j.jaqz850moneda = ln_Moneda116
         and j.jaqz850papel = ln_Papel116
         and j.jaqz850parte = 'SOLICITUD'
         and j.jaqz850indicad = 'OBLIGATORIO';
  
    cursor lista_CtasVincSol is
      select distinct j.jaqz850cta ln_ctavinculada
        from jaqz850 j
       where j.jaqz850pgcod = ln_Pgcod116
         and j.jaqz850ctnro = ln_ctnro116
         and j.jaqz850itoper = ln_Itoper116
         and j.jaqz850itsubo = ln_Itsubo116
         and j.jaqz850itsucd = ln_Itsucd116
         and j.jaqz850ittope = ln_Ittope116
         and j.jaqz850modulo = ln_Modulo116
         and j.jaqz850moneda = ln_Moneda116
         and j.jaqz850papel = ln_Papel116
         and j.jaqz850parte = 'SOLICITUD'
         and j.jaqz850indicad = 'OPCIONAL';
  
    cursor Verif_ExistJAQZ849(ln_CtaVinculada number) is
      select count(*) ln_ExisteJAQZ849
        from fsr008 f /*, fsd001 d*/, jaqz849 j
       where f.pepais = j.jaqz849pais
         and f.petdoc = j.jaqz849tdoc
         and f.pendoc = j.jaqz849ndoc
            /*and f.pepais = d.pepais
            and f.petdoc = d.petdoc
            and f.pendoc = d.pendoc*/ -- mpostigoc 170918
         and f.ctnro = j.jaqz849cta
         and f.ctnro = ln_CtaVinculada
         and j.jaqz849ctnro = ln_ctnro116;
  
    cursor lista_SoliOpcional is
      select distinct j.jaqz850pgcod   ln_pgcodtran,
                      j.jaqz850ctnro   ln_ctatran,
                      j.jaqz850itoper  ln_opertran,
                      j.jaqz850itsubo  ln_suboptran,
                      j.jaqz850itsucd  ln_suctran,
                      j.jaqz850ittope  ln_topetran,
                      j.jaqz850modulo  ln_modtran,
                      j.jaqz850moneda  ln_mdatran,
                      j.jaqz850papel   ln_paptran,
                      j.jaqz850cta     ln_ctavinculada,
                      j.jaqz850pais    ln_pais,
                      j.jaqz850tdoc    ln_tdoc,
                      j.jaqz850ndoc    lc_ndoc,
                      j.jaqz850nomb    lc_nomb,
                      j.jaqz850indicad lc_indicad,
                      j.jaqz850tipcta  lc_tipcta,
                      j.jaqz850parte   lc_part
      
        from jaqz850 j
       where j.jaqz850pgcod = ln_Pgcod116
         and j.jaqz850ctnro = ln_ctnro116
         and j.jaqz850itoper = ln_Itoper116
         and j.jaqz850itsubo = ln_Itsubo116
         and j.jaqz850itsucd = ln_Itsucd116
         and j.jaqz850ittope = ln_Ittope116
         and j.jaqz850modulo = ln_Modulo116
         and j.jaqz850moneda = ln_Moneda116
         and j.jaqz850papel = ln_Papel116
         and j.jaqz850parte = 'SOLICITUD'
         and j.jaqz850indicad = 'OPCIONAL';
  
    ln_VerificoJAQZ849 number;
  
  begin
  
    for l in lista_SoliOblig loop
    
      pq_cr_integracioncuentas.sp_cr_InsertaJAQZ849(ln_Pgcod116  => l.ln_pgcodtran,
                                                    ln_ctnro116  => l.ln_ctatran,
                                                    ln_Itoper116 => l.ln_opertran,
                                                    ln_Itsubo116 => l.ln_suboptran,
                                                    ln_Itsucd116 => l.ln_suctran,
                                                    ln_Ittope116 => l.ln_topetran,
                                                    ln_Modulo116 => l.ln_modtran,
                                                    ln_Moneda116 => l.ln_mdatran,
                                                    ln_Papel116  => l.ln_paptran,
                                                    ln_Cuenta    => l.ln_ctavinculada,
                                                    ln_pais      => l.ln_pais,
                                                    ln_tdoc      => l.ln_tdoc,
                                                    lc_ndoc      => l.lc_ndoc,
                                                    lc_nomb      => l.lc_nomb,
                                                    lc_indicad   => l.lc_indicad,
                                                    lc_tipcta    => l.lc_tipcta,
                                                    lc_parte     => l.lc_part);
    
    end loop;
  
    for k in lista_CtasVincSol loop
      for j in Verif_ExistJAQZ849(k.ln_ctavinculada) loop
        if j.ln_existejaqz849 > 0 then
          exit;
        else
          if j.ln_existejaqz849 = 0 then
            for h in lista_SoliOpcional loop
              pq_cr_integracioncuentas.sp_cr_InsertaJAQZ849(ln_Pgcod116  => h.ln_pgcodtran,
                                                            ln_ctnro116  => h.ln_ctatran,
                                                            ln_Itoper116 => h.ln_opertran,
                                                            ln_Itsubo116 => h.ln_suboptran,
                                                            ln_Itsucd116 => h.ln_suctran,
                                                            ln_Ittope116 => h.ln_topetran,
                                                            ln_Modulo116 => h.ln_modtran,
                                                            ln_Moneda116 => h.ln_mdatran,
                                                            ln_Papel116  => h.ln_paptran,
                                                            ln_Cuenta    => h.ln_ctavinculada,
                                                            ln_pais      => h.ln_pais,
                                                            ln_tdoc      => h.ln_tdoc,
                                                            lc_ndoc      => h.lc_ndoc,
                                                            lc_nomb      => h.lc_nomb,
                                                            lc_indicad   => h.lc_indicad,
                                                            lc_tipcta    => h.lc_tipcta,
                                                            lc_parte     => h.lc_part);
              begin
                select count(*)
                  into ln_VerificoJAQZ849
                  from fsr008 f, fsd001 d, jaqz849 j
                 where f.pepais = j.jaqz849pais
                   and f.petdoc = j.jaqz849tdoc
                   and f.pendoc = j.jaqz849ndoc
                   and f.pepais = d.pepais
                   and f.petdoc = d.petdoc
                   and f.pendoc = d.pendoc
                   and f.ctnro = h.ln_ctavinculada;
              end;
            
              if ln_VerificoJAQZ849 > 0 then
                exit;
              end if;
            end loop;
          
          end if;
        end if;
      end loop;
    
    end loop;
  
  end sp_cr_listadofinalSolic;
  --------------------------------------------------------
  procedure sp_cr_listadofinalGarant(ln_Pgcod116  in number,
                                     ln_ctnro116  in number,
                                     ln_Itoper116 in number,
                                     ln_Itsubo116 in number,
                                     ln_Itsucd116 in number,
                                     ln_Ittope116 in number,
                                     ln_Modulo116 in number,
                                     ln_Moneda116 in number,
                                     ln_Papel116  in number) is
  
    cursor lista_SoliOblig is
      select distinct j.jaqz850pgcod   ln_pgcodtran,
                      j.jaqz850ctnro   ln_ctatran,
                      j.jaqz850itoper  ln_opertran,
                      j.jaqz850itsubo  ln_suboptran,
                      j.jaqz850itsucd  ln_suctran,
                      j.jaqz850ittope  ln_topetran,
                      j.jaqz850modulo  ln_modtran,
                      j.jaqz850moneda  ln_mdatran,
                      j.jaqz850papel   ln_paptran,
                      j.jaqz850cta     ln_ctavinculada,
                      j.jaqz850pais    ln_pais,
                      j.jaqz850tdoc    ln_tdoc,
                      j.jaqz850ndoc    lc_ndoc,
                      j.jaqz850nomb    lc_nomb,
                      j.jaqz850indicad lc_indicad,
                      j.JAQZ850TIPCTA  lc_tipcta,
                      j.jaqz850parte   lc_part
      
        from jaqz850 j
       where j.jaqz850pgcod = ln_Pgcod116
         and j.jaqz850ctnro = ln_ctnro116
         and j.jaqz850itoper = ln_Itoper116
         and j.jaqz850itsubo = ln_Itsubo116
         and j.jaqz850itsucd = ln_Itsucd116
         and j.jaqz850ittope = ln_Ittope116
         and j.jaqz850modulo = ln_Modulo116
         and j.jaqz850moneda = ln_Moneda116
         and j.jaqz850papel = ln_Papel116
         and j.jaqz850parte = 'GARANTIA'
         and j.jaqz850indicad = 'OBLIGATORIO';
  
    cursor lista_CtasVincSol is
      select distinct j.jaqz850cta ln_ctavinculada
        from jaqz850 j
       where j.jaqz850pgcod = ln_Pgcod116
         and j.jaqz850ctnro = ln_ctnro116
         and j.jaqz850itoper = ln_Itoper116
         and j.jaqz850itsubo = ln_Itsubo116
         and j.jaqz850itsucd = ln_Itsucd116
         and j.jaqz850ittope = ln_Ittope116
         and j.jaqz850modulo = ln_Modulo116
         and j.jaqz850moneda = ln_Moneda116
         and j.jaqz850papel = ln_Papel116
         and j.jaqz850parte = 'GARANTIA'
         and j.jaqz850indicad = 'OPCIONAL';
  
    cursor Verif_ExistJAQZ849(ln_CtaVinculada number) is
      select count(*) ln_ExisteJAQZ849
        from fsr008 f /*, fsd001 d*/, jaqz849 j
       where f.pepais = j.jaqz849pais
         and f.petdoc = j.jaqz849tdoc
         and f.pendoc = j.jaqz849ndoc
            /*and f.pepais = d.pepais
            and f.petdoc = d.petdoc
            and f.pendoc = d.pendoc*/ -- mpostigoc 140918
         and f.ctnro = j.jaqz849cta
         and f.ctnro = ln_CtaVinculada
         and j.jaqz849ctnro = ln_ctnro116;
  
    cursor lista_SoliOpcional is
      select distinct j.jaqz850pgcod   ln_pgcodtran,
                      j.jaqz850ctnro   ln_ctatran,
                      j.jaqz850itoper  ln_opertran,
                      j.jaqz850itsubo  ln_suboptran,
                      j.jaqz850itsucd  ln_suctran,
                      j.jaqz850ittope  ln_topetran,
                      j.jaqz850modulo  ln_modtran,
                      j.jaqz850moneda  ln_mdatran,
                      j.jaqz850papel   ln_paptran,
                      j.jaqz850cta     ln_ctavinculada,
                      j.jaqz850pais    ln_pais,
                      j.jaqz850tdoc    ln_tdoc,
                      j.jaqz850ndoc    lc_ndoc,
                      j.jaqz850nomb    lc_nomb,
                      j.jaqz850indicad lc_indicad,
                      j.JAQZ850TIPCTA  lc_tipcta,
                      j.jaqz850parte   lc_part
      
        from jaqz850 j
       where j.jaqz850pgcod = ln_Pgcod116
         and j.jaqz850ctnro = ln_ctnro116
         and j.jaqz850itoper = ln_Itoper116
         and j.jaqz850itsubo = ln_Itsubo116
         and j.jaqz850itsucd = ln_Itsucd116
         and j.jaqz850ittope = ln_Ittope116
         and j.jaqz850modulo = ln_Modulo116
         and j.jaqz850moneda = ln_Moneda116
         and j.jaqz850papel = ln_Papel116
         and j.jaqz850parte = 'GARANTIA'
         and j.jaqz850indicad = 'OPCIONAL';
  
    ln_VerificoJAQZ849 number;
  
  begin
  
    for l in lista_SoliOblig loop
    
      pq_cr_integracioncuentas.sp_cr_InsertaJAQZ849(ln_Pgcod116  => l.ln_pgcodtran,
                                                    ln_ctnro116  => l.ln_ctatran,
                                                    ln_Itoper116 => l.ln_opertran,
                                                    ln_Itsubo116 => l.ln_suboptran,
                                                    ln_Itsucd116 => l.ln_suctran,
                                                    ln_Ittope116 => l.ln_topetran,
                                                    ln_Modulo116 => l.ln_modtran,
                                                    ln_Moneda116 => l.ln_mdatran,
                                                    ln_Papel116  => l.ln_paptran,
                                                    ln_Cuenta    => l.ln_ctavinculada,
                                                    ln_pais      => l.ln_pais,
                                                    ln_tdoc      => l.ln_tdoc,
                                                    lc_ndoc      => l.lc_ndoc,
                                                    lc_nomb      => l.lc_nomb,
                                                    lc_indicad   => l.lc_indicad,
                                                    lc_tipcta    => l.lc_tipcta,
                                                    lc_parte     => l.lc_part);
    
    end loop;
  
    for k in lista_CtasVincSol loop
      for j in Verif_ExistJAQZ849(k.ln_ctavinculada) loop
        if j.ln_existejaqz849 > 0 then
          exit;
        else
          if j.ln_existejaqz849 = 0 then
            for h in lista_SoliOpcional loop
              pq_cr_integracioncuentas.sp_cr_InsertaJAQZ849(ln_Pgcod116  => h.ln_pgcodtran,
                                                            ln_ctnro116  => h.ln_ctatran,
                                                            ln_Itoper116 => h.ln_opertran,
                                                            ln_Itsubo116 => h.ln_suboptran,
                                                            ln_Itsucd116 => h.ln_suctran,
                                                            ln_Ittope116 => h.ln_topetran,
                                                            ln_Modulo116 => h.ln_modtran,
                                                            ln_Moneda116 => h.ln_mdatran,
                                                            ln_Papel116  => h.ln_paptran,
                                                            ln_Cuenta    => h.ln_ctavinculada,
                                                            ln_pais      => h.ln_pais,
                                                            ln_tdoc      => h.ln_tdoc,
                                                            lc_ndoc      => h.lc_ndoc,
                                                            lc_nomb      => h.lc_nomb,
                                                            lc_indicad   => h.lc_indicad,
                                                            lc_tipcta    => h.lc_tipcta,
                                                            lc_parte     => h.lc_part);
              begin
                select count(*)
                  into ln_VerificoJAQZ849
                  from fsr008 f, fsd001 d, jaqz849 j
                 where f.pepais = j.jaqz849pais
                   and f.petdoc = j.jaqz849tdoc
                   and f.pendoc = j.jaqz849ndoc
                   and f.pepais = d.pepais
                   and f.petdoc = d.petdoc
                   and f.pendoc = d.pendoc
                   and f.ctnro = h.ln_ctavinculada;
              end;
            
              if ln_VerificoJAQZ849 > 0 then
                exit;
              end if;
            end loop;
          end if;
        end if;
      end loop;
    
    end loop;
  
  end sp_cr_listadofinalGarant;

  --------------------------------------------------------
  procedure sp_cr_InsertaJAQZ849(ln_Pgcod116  in number,
                                 ln_ctnro116  in number,
                                 ln_Itoper116 in number,
                                 ln_Itsubo116 in number,
                                 ln_Itsucd116 in number,
                                 ln_Ittope116 in number,
                                 ln_Modulo116 in number,
                                 ln_Moneda116 in number,
                                 ln_Papel116  in number,
                                 ln_Cuenta    in number,
                                 ln_pais      in number,
                                 ln_tdoc      in number,
                                 lc_ndoc      in varchar2,
                                 lc_nomb      in varchar2,
                                 lc_indicad   in varchar2,
                                 lc_TIPCTA    in varchar2,
                                 lc_parte     in varchar2) is
  
    ld_fchsist date;
    lc_hora    char(8);
  begin
  
    begin
      select pgfape into ld_fchsist from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into jaqz849
        (jaqz849fproc,
         jaqz849hora,
         jaqz849pgcod,
         jaqz849ctnro,
         jaqz849itoper,
         jaqz849itsubo,
         jaqz849itsucd,
         jaqz849ittope,
         jaqz849modulo,
         jaqz849moneda,
         jaqz849papel,
         jaqz849cta,
         jaqz849pais,
         jaqz849tdoc,
         jaqz849ndoc,
         jaqz849nomb,
         jaqz849indicad,
         JAQZ849TIPCTA,
         jaqz849parte)
      values
        (ld_fchsist,
         lc_hora,
         ln_Pgcod116,
         ln_ctnro116,
         ln_Itoper116,
         ln_Itsubo116,
         ln_Itsucd116,
         ln_Ittope116,
         ln_Modulo116,
         ln_Moneda116,
         ln_Papel116,
         ln_Cuenta,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         lc_nomb,
         lc_indicad,
         lc_TIPCTA,
         lc_parte);
      commit;
    end;
  
  end sp_cr_InsertaJAQZ849;

end PQ_CR_INTEGRACIONCUENTAS;
/

