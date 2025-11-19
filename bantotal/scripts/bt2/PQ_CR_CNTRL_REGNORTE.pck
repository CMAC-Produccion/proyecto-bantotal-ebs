create or replace package PQ_CR_CNTRL_REGNORTE is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_CNTRL_REGNORTE
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 24/10/2025 19:00:18
  -- Autor de Creación          : MPOSTIGOC MARIA POSTIGO
  -- Uso                        : Controles para la Contencion Region Norte
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- *****************************************************************
  -- Public type declarations

  procedure sp_cr_AmortUltDesb(ln_instancia  in number,
                               ln_PorcAmortz out number);
  --------------------------------------------------------------
  procedure sp_Cr_PorcAumnMntOri(ln_Instancia      in number,
                                 ln_PorcAumnMntOri out number);
  ---------------------------------------------------------------
  procedure sp_Cr_PorcAumnNiVnt(ln_Instancia     in number,
                                ln_PorcAumNivVnt out number);
  --------------------------------------------------------------------------
  procedure sp_cr_NroCredVig(ln_Instancia  in number,
                             ln_NroCredVig out number);

end PQ_CR_CNTRL_REGNORTE;
/
create or replace package body PQ_CR_CNTRL_REGNORTE is

  procedure sp_cr_AmortUltDesb(ln_instancia  in number,
                               ln_PorcAmortz out number) is
  
    cursor creditos(ld_FchMaxDesVig date) is
      select *
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in
             (select s.modulo
                from fst111 s
               where s.dscod = 50
                 and s.modulo not in (29, 33, 108, 116, 120, 142, 144, 200))
         and f.aomda in (0, 101)
         and f.aocta in (select r.ctnro
                           from fsr008 r, sng001 n
                          where r.pepais = n.sng001pais
                            and r.petdoc = n.sng001tdoc
                            and r.pendoc = n.sng001ndoc
                            and r.cttfir = 'T'
                            and n.sng001inst = ln_instancia)
         and f.aostat <> 99
         and f.aofval = ld_FchMaxDesVig;
  
    ln_pais          number;
    ln_tdoc          number;
    lc_ndoc          varchar2(12);
    ln_TipSol        number;
    ln_CredVig       number := 0;
    ln_CapDesmbls    number(17, 2) := 0.00;
    ln_CapPagad      number(17, 2) := 0.00;
    ld_FchSist       date;
    ld_FchMaxDesVig  date;
    ln_CuoPagUDVAux  number := 0;
    ln_porcamortzAux number := 0;
  
  begin
  
    ln_porcamortz := 0;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc, s.sng001ori
        into ln_pais, ln_tdoc, lc_ndoc, ln_TipSol
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_CredVig
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in
             (select s.modulo
                from fst111 s
               where s.dscod = 50
                 and s.modulo not in (29, 33, 108, 116, 120, 142, 144, 200)) -----9
         and f.aomda in (0, 101)
         and f.aocta in (select r.ctnro
                           from fsr008 r
                          where r.pepais = ln_pais
                            and r.petdoc = ln_tdoc
                            and r.pendoc = rpad(lc_ndoc, 12, ' ')
                            and r.cttfir = 'T')
         and f.aostat <> 99;
    exception
      when others then
        ln_CredVig := 0;
    end;
  
    if ln_TipSol = 0 and ln_CredVig = 0 then
      -- Nuevo
      ln_porcamortz := 99999;
    
    else
      if ln_TipSol = 4 then
      
        begin
          select sum(f.pp1cap)
            into ln_CapPagad
            from xwf700 x, fsd602 f
           where x.xwfempresa = f.pgcod
             and x.xwfsucursal = f.ppsuc
             and x.xwfmodulo = f.ppmod
             and x.xwfmoneda = f.ppmda
             and x.xwfpapel = f.pppap
             and x.xwfcuenta = f.ppcta
             and x.xwfoperacion = f.ppoper
             and x.xwfsubope = f.ppsbop
             and x.xwftipope = f.pptope
             and x.xwfprcins = ln_instancia
             and x.xwfcar3 <> '1'
             and f.d602co = 'S';
        exception
          when others then
            null;
        end;
      
        begin
          select f.aoimp
            into ln_CapDesmbls
            from xwf700 x, fsd010 f
           where x.xwfempresa = f.pgcod
             and x.xwfsucursal = f.aosuc
             and x.xwfmodulo = f.aomod
             and x.xwfmoneda = f.aomda
             and x.xwfpapel = f.aopap
             and x.xwfcuenta = f.aocta
             and x.xwfoperacion = f.aooper
             and x.xwfsubope = f.aosbop
             and x.xwftipope = f.aotope
             and x.xwfprcins = ln_instancia
             and x.xwfcar3 <> '1';
        exception
          when others then
            null;
        end;
      
        if ln_CapDesmbls > 0 and ln_CapPagad > 0 then
          begin
            select (ln_CapPagad * 100) / ln_CapDesmbls
              into ln_porcamortz
              from dual;
          exception
            when others then
              ln_porcamortz := 0;
          end;
        else
          ln_porcamortz := 0;
        end if;
      
      else
        if ln_TipSol <> 4 then
          -- Adicional
          begin
            select max(f.aofval)
              into ld_FchMaxDesVig
              from fsd010 f
             where f.pgcod = 1
               and f.aomod in
                   (select s.modulo
                      from fst111 s
                     where s.dscod = 50
                       and s.modulo not in
                           (29, 33, 108, 116, 120, 142, 144, 200)) ----
               and f.aomda in (0, 101)
               and f.aocta in (select r.ctnro
                                 from fsr008 r
                                where r.pepais = ln_pais
                                  and r.petdoc = ln_tdoc
                                  and r.pendoc = rpad(lc_ndoc, 12, ' ')
                                  and r.cttfir = 'T')
               and f.aostat <> 99;
          exception
            when others then
              null;
          end;
        
          for c in creditos(ld_FchMaxDesVig) loop
          
            begin
              select sum(f.pp1cap)
                into ln_CapPagad
                from fsd602 f
               where f.pgcod = c.pgcod
                 and f.ppmod = c.aomod
                 and f.ppsuc = c.aosuc
                 and f.ppmda = c.aomda
                 and f.pppap = c.aopap
                 and f.ppcta = c.aocta
                 and f.ppoper = c.aooper
                 and f.ppsbop = c.aosbop
                 and f.pptope = c.aotope
                 and f.d602co = 'S';
            exception
              when others then
                ln_CuoPagUDVAux := 0;
            end;
          
            if c.aoimp > 0 and ln_CapPagad > 0 then
              begin
                select (ln_CapPagad * 100) / c.aoimp
                  into ln_porcamortzAux
                  from dual;
              exception
                when others then
                  ln_porcamortzAux := 0;
              end;
            else
              ln_porcamortzAux := 0;
            end if;
          
            if ln_porcamortz = 0 and ln_porcamortzAux > 0 then
              ln_porcamortz := ln_porcamortzAux;
            else
              if ln_porcamortzAux < ln_porcamortz then
                ln_porcamortz := ln_porcamortzAux;
              end if;
            end if;
          end loop;
        end if;
      end if;
    end if;
  
    ln_porcamortz := ln_porcamortz / 100;
  end sp_cr_AmortUltDesb;
  ------------------------------------------------------------------------
  procedure sp_Cr_PorcAumnMntOri(ln_Instancia      in number,
                                 ln_PorcAumnMntOri out number) is
  
    cursor creditos(ld_FchMaxDesVig date) is
      select *
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in
             (select s.modulo
                from fst111 s
               where s.dscod = 50
                 and s.modulo not in (29, 33, 108, 116, 120, 142, 144, 200))
         and f.aomda in (0, 101)
         and f.aocta in (select r.ctnro
                           from fsr008 r, sng001 n
                          where r.pepais = n.sng001pais
                            and r.petdoc = n.sng001tdoc
                            and r.pendoc = n.sng001ndoc
                            and r.cttfir = 'T'
                            and n.sng001inst = ln_instancia)
         and f.aostat <> 99
         and f.aofval = ld_FchMaxDesVig;
  
    ln_pais              number;
    ln_tdoc              number;
    lc_ndoc              varchar2(12);
    ln_TipSol            number;
    ln_CredVig           number := 0;
    ln_MntSoli           number(17, 2) := 0;
    ln_MntDesemb         number(17, 2) := 0;
    ld_FchSist           date;
    ld_FchMaxDesVig      date;
    ln_PorcAumnMntOriAux number := 0;
  
  begin
  
    ln_PorcAumnMntOri := 0;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc, s.sng001ori
        into ln_pais, ln_tdoc, lc_ndoc, ln_TipSol
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select f.xllcapital
        into ln_MntSoli
        from xwf700 x, x054023 f
       where x.xwfempresa = f.xllpgcod
         and x.xwfsucursal = f.xllaosuc
         and x.xwfmodulo = f.xllaomod
         and x.xwfmoneda = f.xllaomda
         and x.xwfpapel = f.xllaopap
         and x.xwfcuenta = f.xllaocta
         and x.xwfoperacion = f.xllaooper
         and x.xwfsubope = f.xllaosbop
         and x.xwftipope = f.xllaotop
         and x.xwfprcins = ln_instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_CredVig
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in
             (select s.modulo
                from fst111 s
               where s.dscod = 50
                 and s.modulo not in (29, 33, 108, 116, 120, 142, 144, 200)) -----9
         and f.aomda in (0, 101)
         and f.aocta in (select r.ctnro
                           from fsr008 r
                          where r.pepais = ln_pais
                            and r.petdoc = ln_tdoc
                            and r.pendoc = rpad(lc_ndoc, 12, ' ')
                            and r.cttfir = 'T')
         and f.aostat <> 99;
    exception
      when others then
        ln_CredVig := 0;
    end;
  
    if ln_TipSol = 0 and ln_CredVig = 0 then
      -- Nuevo
      ln_PorcAumnMntOri := 999;
    
    else
      -- Adicional
      begin
        select max(f.aofval)
          into ld_FchMaxDesVig
          from fsd010 f
         where f.pgcod = 1
           and f.aomod in
               (select s.modulo
                  from fst111 s
                 where s.dscod = 50
                   and s.modulo not in
                       (29, 33, 108, 116, 120, 142, 144, 200)) ----
           and f.aomda in (0, 101)
           and f.aocta in (select r.ctnro
                             from fsr008 r
                            where r.pepais = ln_pais
                              and r.petdoc = ln_tdoc
                              and r.pendoc = rpad(lc_ndoc, 12, ' ')
                              and r.cttfir = 'T')
           and f.aostat <> 99;
      exception
        when others then
          null;
      end;
    
      for c in creditos(ld_FchMaxDesVig) loop
      
        begin
          select x.xllcapital
            into ln_MntDesemb
            from x054023 x
           where x.xllpgcod = c.pgcod
             and x.xllaomod = c.aomod
             and x.xllaosuc = c.aosuc
             and x.xllaomda = c.aomda
             and x.xllaopap = c.aopap
             and x.xllaocta = c.aocta
             and x.xllaooper = c.aooper
             and x.xllaosbop = c.aosbop
             and x.xllaotop = c.aotope;
        exception
          when others then
            null;
        end;
      
        if ln_MntDesemb > 0 and ln_MntSoli > 0 then
          begin
            select (ln_MntSoli * 100) / ln_MntDesemb
              into ln_PorcAumnMntOriAux
              from dual;
          exception
            when others then
              ln_PorcAumnMntOriAux := 0;
          end;
        else
          ln_PorcAumnMntOriAux := 0;
        end if;
      
        if ln_PorcAumnMntOri = 0 and ln_PorcAumnMntOriAux > 0 then
          ln_PorcAumnMntOri := ln_PorcAumnMntOriAux - 100;
        else
          if ln_PorcAumnMntOriAux < ln_PorcAumnMntOri then
            ln_PorcAumnMntOri := ln_PorcAumnMntOriAux - 100;
          end if;
        end if;
      end loop;
    end if;
  
    ln_PorcAumnMntOri := ln_PorcAumnMntOri / 100;
  
  end sp_Cr_PorcAumnMntOri;
  --------------------------------------------------------------------------
  procedure sp_Cr_PorcAumnNiVnt(ln_Instancia     in number,
                                ln_PorcAumNivVnt out number) is
  
    cursor creditos(ld_FchMaxDesVig date) is
      select *
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in
             (select s.modulo
                from fst111 s
               where s.dscod = 50
                 and s.modulo not in (29, 33, 108, 116, 120, 142, 144, 200))
         and f.aomda in (0, 101)
         and f.aocta in (select r.ctnro
                           from fsr008 r, sng001 n
                          where r.pepais = n.sng001pais
                            and r.petdoc = n.sng001tdoc
                            and r.pendoc = n.sng001ndoc
                            and r.cttfir = 'T'
                            and n.sng001inst = ln_instancia)
         and f.aostat <> 99
         and f.aofval = ld_FchMaxDesVig;
  
    ln_pais             number;
    ln_tdoc             number;
    lc_ndoc             varchar2(12);
    ln_TipSol           number;
    ln_CredVig          number := 0;
    ld_FchSist          date;
    ld_FchMaxDesVig     date;
    ln_PorcAumNivVntAux number := 0;
    ln_NvlVntSol        number(17, 2) := 0;
    ln_NvlVntDol        number(17, 2) := 0;
    ln_InsCredDesmb     number := 0;
    ln_NvlVntAntSol     number(17, 2) := 0;
    ln_NvlVntAntDol     number(17, 2) := 0;
    ln_NvlVntAntTot     number(17, 2) := 0;
    ln_NvlVntTot        number(17, 2) := 0;
    ln_TipoCamb         number(10, 6) := 0;
  
  begin
  
    ln_PorcAumNivVnt := 0;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc, s.sng001ori
        into ln_pais, ln_tdoc, lc_ndoc, ln_TipSol
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select n.sng023mto
        into ln_NvlVntSol
        from sng023 n
       where n.sng021eval =
             (select s.sng021eval
                from sng021 s
               where s.sng021sol = ln_Instancia)
         and n.sng026cod = 38;
    exception
      when others then
        null;
    end;
  
    begin
      select n.sng023mto
        into ln_NvlVntDol
        from sng023 n
       where n.sng021eval =
             (select s.sng021eval
                from sng021 s
               where s.sng021sol = ln_Instancia)
         and n.sng026cod = 538;
    exception
      when others then
        null;
    end;
  
    ln_NvlVntDol := nvl(ln_NvlVntDol, 0);
  
    ln_TipoCamb := fn_tipo_cambio_fijo(P_FECHA => ld_FchSist);
  
    ln_NvlVntTot := ln_NvlVntSol + (ln_NvlVntDol * ln_TipoCamb);
  
    begin
      select count(*)
        into ln_CredVig
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in
             (select s.modulo
                from fst111 s
               where s.dscod = 50
                 and s.modulo not in (29, 33, 108, 116, 120, 142, 144, 200)) -----9
         and f.aomda in (0, 101)
         and f.aocta in (select r.ctnro
                           from fsr008 r
                          where r.pepais = ln_pais
                            and r.petdoc = ln_tdoc
                            and r.pendoc = rpad(lc_ndoc, 12, ' ')
                            and r.cttfir = 'T')
         and f.aostat <> 99;
    exception
      when others then
        ln_CredVig := 0;
    end;
  
    if ln_TipSol = 0 and ln_CredVig = 0 then
      -- Nuevo
      ln_PorcAumNivVnt := 999;
    
    else
      -- Adicional
      begin
        select max(f.aofval)
          into ld_FchMaxDesVig
          from fsd010 f
         where f.pgcod = 1
           and f.aomod in
               (select s.modulo
                  from fst111 s
                 where s.dscod = 50
                   and s.modulo not in
                       (29, 33, 108, 116, 120, 142, 144, 200)) ----
           and f.aomda in (0, 101)
           and f.aocta in (select r.ctnro
                             from fsr008 r
                            where r.pepais = ln_pais
                              and r.petdoc = ln_tdoc
                              and r.pendoc = rpad(lc_ndoc, 12, ' ')
                              and r.cttfir = 'T')
           and f.aostat <> 99;
      exception
        when others then
          null;
      end;
    
      for c in creditos(ld_FchMaxDesVig) loop
      
        sp_cr_instancia(ln_Scmod     => c.aomod,
                        ln_Scsuc     => c.aosuc,
                        ln_Scmda     => c.aomda,
                        ln_Scpap     => c.aopap,
                        ln_Sccta     => c.aocta,
                        ln_Scoper    => c.aooper,
                        ln_Scsbop    => c.aosbop,
                        ln_Sctope    => c.aotope,
                        ln_instancia => ln_InsCredDesmb);
      
        begin
          select n.sng023mto
            into ln_NvlVntAntSol
            from sng023 n
           where n.sng021eval =
                 (select s.sng021eval
                    from sng021 s
                   where s.sng021sol = ln_InsCredDesmb)
             and n.sng026cod = 38;
        exception
          when others then
            null;
        end;
      
        begin
          select n.sng023mto
            into ln_NvlVntAntDol
            from sng023 n
           where n.sng021eval =
                 (select s.sng021eval
                    from sng021 s
                   where s.sng021sol = ln_InsCredDesmb)
             and n.sng026cod = 538;
        exception
          when others then
            ln_NvlVntAntDol := 0;
        end;
      
        ln_NvlVntAntDol := nvl(ln_NvlVntAntDol, 0);
      
        ln_NvlVntAntTot := ln_NvlVntAntSol +
                           (ln_NvlVntAntDol * ln_TipoCamb);
      
        if ln_NvlVntTot > 0 and ln_NvlVntAntTot > 0 then
          begin
            select (ln_NvlVntTot * 100) / ln_NvlVntAntTot
              into ln_PorcAumNivVntAux
              from dual;
          exception
            when others then
              ln_PorcAumNivVntAux := 0;
          end;
        else
          ln_PorcAumNivVntAux := ln_NvlVntTot;
        end if;
      
        if ln_PorcAumNivVnt = 0 and ln_PorcAumNivVntAux > 0 then
          ln_PorcAumNivVnt := ln_PorcAumNivVntAux - 100;
        else
          if ln_PorcAumNivVntAux < ln_PorcAumNivVnt then
            ln_PorcAumNivVnt := ln_PorcAumNivVntAux - 100;
          end if;
        end if;
      end loop;
    end if;
  
    ln_PorcAumNivVnt := ln_PorcAumNivVnt / 100;
  
  end sp_Cr_PorcAumnNiVnt;
  --------------------------------------------------------------------------
  procedure sp_cr_NroCredVig(ln_Instancia  in number,
                             ln_NroCredVig out number) is
  
    cursor inserta(ln_pepais number,
                   ln_petdoc number,
                   ln_pendoc varchar2,
                   pd_fecpro date) is
      select d10.pgcod  ln_pgcod10,
             d10.aomod  ln_mod10,
             d10.aosuc  ln_suc10,
             d10.aomda  ln_mda10,
             d10.aopap  ln_pap10,
             d10.aocta  ln_cta10,
             d10.aooper ln_oper10,
             d10.aosbop ln_sbop10,
             d10.aotope ln_tope10
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select r.ctnro
                             from fsr008 r, sng001 n
                            where r.pepais = n.sng001pais
                              and r.petdoc = n.sng001tdoc
                              and r.pendoc = n.sng001ndoc
                              and r.cttfir = 'T'
                              and n.sng001inst = ln_instancia)
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 1))) or
             d10.Aomod in (141))
         and d10.Aostat <> 99
      --  and aofvto > pd_fecpro
      union
      select b.pgcod  ln_pgcod10,
             b.aomod  ln_mod10,
             b.aosuc  ln_suc10,
             b.aomda  ln_mda10,
             b.aopap  ln_pap10,
             b.aocta  ln_cta10,
             b.aooper ln_oper10,
             b.aosbop ln_sbop10,
             b.aotope ln_tope10
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = RPAD(ln_Pendoc, 12, ' ')
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and (b.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 1))) or
             b.Aomod in (141))
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    cursor linea(ln_pepais number,
                 ln_petdoc number,
                 ln_pendoc varchar2,
                 pd_fecpro date) is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
      
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select r.ctnro
                             from fsr008 r, sng001 n
                            where r.pepais = n.sng001pais
                              and r.petdoc = n.sng001tdoc
                              and r.pendoc = n.sng001ndoc
                              and r.cttfir = 'T'
                              and n.sng001inst = ln_instancia)
         and d10.Aomod = 117
         and d10.Aostat <> 99
         and d10.aofvto > pd_fecpro
      union
      
      select b.pgcod    ln_pgcod10,
             b.aomod    ln_mod10,
             b.aosuc    ln_suc10,
             b.aomda    ln_mda10,
             b.aopap    ln_pap10,
             b.aocta    ln_cta10,
             b.aooper   ln_oper10,
             b.aosbop   ln_sbop10,
             b.aotope   ln_tope10,
             b.aoperiod ln_peri10
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = RPAD(ln_Pendoc, 12, ' ')
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.Aomod in (117)
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and b.aofvto > pd_fecpro;
  
    cursor vuelo(ln_pepais number,
                 ln_petdoc number,
                 ln_pendoc varchar2,
                 pd_fecpro date) is
    
      select x.xwfempresa ln_pgcod10,
             x.xwfmodulo ln_mod10,
             x.xwfsucursal ln_suc10,
             x.xwfmoneda ln_mda10,
             x.xwfpapel ln_pap10,
             x.xwfcuenta ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope ln_sbop10,
             x.xwftipope ln_tope10,
             x.xwfprcins,
             max(s.sng120per) ln_peri10
        from xwf700 x, sng120 s
       where x.xwfempresa = 1
         and x.xwfcuenta in
             (select r.ctnro
                from fsr008 r, sng001 n
               where r.pepais = n.sng001pais
                 and r.petdoc = n.sng001tdoc
                 and r.pendoc = n.sng001ndoc
                 and r.cttfir = 'T'
                 and n.sng001inst = ln_instancia)
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 1))) or
             xwfmodulo in (117, 141))
            
         and x.XWFPRCINS in (select wfinsprcid
                               from wfwrkitems wf
                              where wf.wfinsprcid = x.xwfprcins
                                and wf.wfitemstsact = 1
                                and s.sng120ins = XWFPRCINS)
         and x.xwfcar3 = '1'
      
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope,
                x.xwfprcins
      union
      select x.xwfempresa ln_pgcod10,
             x.xwfmodulo ln_mod10,
             x.xwfsucursal ln_suc10,
             x.xwfmoneda ln_mda10,
             x.xwfpapel ln_pap10,
             x.xwfcuenta ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope ln_sbop10,
             x.xwftipope ln_tope10,
             x.xwfprcins,
             max(s.sng120per) ln_peri10
        from xwf700 x, sng120 s, fsr002 c, fsr008 a
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = RPAD(ln_Pendoc, 12, ' ')
         and a.pgcod = x.xwfempresa
         and a.ctnro = x.xwfcuenta
         and x.xwfempresa = 1
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 1))) or
             xwfmodulo in (117, 141))
            
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and x.XWFPRCINS in (select wfinsprcid
                               from wfwrkitems wf
                              where wf.wfinsprcid = x.xwfprcins
                                and wf.wfitemstsact = 1)
         and s.sng120ins = x.XWFPRCINS
         and x.xwfcar3 = '1'
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope,
                x.xwfprcins;
  
    cursor lineas_ven(ln_pepais number,
                      ln_petdoc number,
                      ln_pendoc varchar2,
                      pd_fecpro date) is
    
      select d10.pgcod  ln_pgcod10,
             d10.aomod  ln_mod10,
             d10.aosuc  ln_suc10,
             d10.aomda  ln_mda10,
             d10.aopap  ln_pap10,
             d10.aocta  ln_cta10,
             d10.aooper ln_oper10,
             d10.aosbop ln_sbop10,
             d10.aotope ln_tope10
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select r.ctnro
                             from fsr008 r, sng001 n
                            where r.pepais = n.sng001pais
                              and r.petdoc = n.sng001tdoc
                              and r.pendoc = n.sng001ndoc
                              and r.cttfir = 'T'
                              and n.sng001inst = ln_instancia)
         and d10.Aomod = 117
         and d10.aofvto < pd_fecpro
      
      union
      
      select b.pgcod  ln_pgcod10,
             b.aomod  ln_mod10,
             b.aosuc  ln_suc10,
             b.aomda  ln_mda10,
             b.aopap  ln_pap10,
             b.aocta  ln_cta10,
             b.aooper ln_oper10,
             b.aosbop ln_sbop10,
             b.aotope ln_tope10
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_pepais
         and c.petdoc = ln_petdoc
         and c.pendoc = RPAD(ln_Pendoc, 12, ' ')
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.aomod = 117
         and aofvto < pd_fecpro
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    lc_Vinculado varchar2(5) := 'N';
    lc_fgAdic    varchar2(1);
    lc_fgAmpl    varchar2(1);
    lc_ven       char(1);
    ln_indicador number;
    lc_fgRefLin  varchar2(1) := 'N';
    lc_fgRepro   varchar2(2);
    ln_CredVig   number := 0;
    ln_pepais    number;
    ln_petdoc    number;
    ln_pendoc    varchar2(12);
    pd_fecpro    date;
  
  begin
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pepais, ln_petdoc, ln_pendoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into pd_fecpro from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    for i in inserta(ln_pepais, ln_petdoc, ln_pendoc, pd_fecpro) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
    
      PQ_CR_RESOLUTOR_AUTONOMIA.sp_refinanLinea(i.ln_pgcod10,
                                                i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                lc_fgRefLin);
    
      PQ_CR_RESOLUTOR_AUTONOMIA.Sp_ampliados_CK(i.ln_pgcod10,
                                                i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                i.ln_sbop10,
                                                i.ln_tope10,
                                                lc_fgAmpl);
    
      PQ_CR_RESOLUTOR_AUTONOMIA.sp_cr_Reprogramados(i.ln_pgcod10,
                                                    i.ln_mod10,
                                                    i.ln_suc10,
                                                    i.ln_mda10,
                                                    i.ln_pap10,
                                                    i.ln_cta10,
                                                    i.ln_oper10,
                                                    i.ln_sbop10,
                                                    i.ln_tope10,
                                                    lc_fgRepro);
    
      pq_cr_resolutor_cappago.sp_cr_VerVincLinea(ln_mod10  => i.ln_mod10,
                                                 ln_suc10  => i.ln_suc10,
                                                 ln_mda10  => i.ln_mda10,
                                                 ln_pap10  => i.ln_pap10,
                                                 ln_cta10  => i.ln_cta10,
                                                 ln_oper10 => i.ln_oper10,
                                                 ln_sbop10 => i.ln_sbop10,
                                                 ln_tope10 => i.ln_tope10,
                                                 lc_FlgLn  => lc_Vinculado);
    
      if lc_fgRefLin <> 'S' and lc_fgAmpl <> 'S' AND lc_fgRepro <> 'S' and
         lc_Vinculado <> 'S' then
        ln_CredVig := ln_CredVig + 1;
      end if;
    
    end loop;
  
    for l in linea(ln_pepais, ln_petdoc, ln_pendoc, pd_fecpro) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
    
      PQ_CR_RESOLUTOR_AUTONOMIA.sp_refinanLinea(l.ln_pgcod10,
                                                l.ln_mod10,
                                                l.ln_suc10,
                                                l.ln_mda10,
                                                l.ln_pap10,
                                                l.ln_cta10,
                                                l.ln_oper10,
                                                lc_fgRefLin);
    
      pq_cr_resolutor_cappago.sp_cr_VerVincLinea(ln_mod10  => l.ln_mod10,
                                                 ln_suc10  => l.ln_suc10,
                                                 ln_mda10  => l.ln_mda10,
                                                 ln_pap10  => l.ln_pap10,
                                                 ln_cta10  => l.ln_cta10,
                                                 ln_oper10 => l.ln_oper10,
                                                 ln_sbop10 => l.ln_sbop10,
                                                 ln_tope10 => l.ln_tope10,
                                                 lc_FlgLn  => lc_Vinculado);
    
      if lc_fgRefLin <> 'S' and lc_Vinculado <> 'S' then
      
        ln_CredVig := ln_CredVig + 1;
      end if;
    
    end loop;
  
    for c in vuelo(ln_pepais, ln_petdoc, ln_pendoc, pd_fecpro) loop
      ln_CredVig := ln_CredVig + 1;
    end loop;
  
    for j in lineas_ven(ln_pepais, ln_petdoc, ln_pendoc, pd_fecpro) loop
      ln_indicador := 3;
      begin
        select 'S'
          into lc_ven
          from fsr011 a, fsd010 b
         where a.r2cod = j.ln_pgcod10
           and a.r2mod = j.ln_mod10
           and a.r2suc = j.ln_suc10
           and a.r2mda = j.ln_mda10
           and a.r2pap = j.ln_pap10
           and a.r2cta = j.ln_cta10
           and a.r2oper = j.ln_oper10
           and a.r2sbop = j.ln_sbop10
           and a.r2tope = j.ln_tope10
           and a.r1cod = b.pgcod
           and a.r1mod = b.aomod
           and a.r1suc = b.aosuc
           and a.r1mda = b.aomda
           and a.r1pap = b.aopap
           and a.r1cta = b.aocta
           and a.r1oper = b.aooper
           and a.r1sbop = b.aosbop
           and a.r1tope = b.aotope
           and b.aostat <> 99
           and relcod = 46
           and rownum = 1;
      exception
        when no_data_found then
          lc_ven := 'N';
      end;
    
      lc_fgAdic := null;
    
      pq_cr_resolutor_cappago.sp_cr_VerVincLinea(ln_mod10  => j.ln_mod10,
                                                 ln_suc10  => j.ln_suc10,
                                                 ln_mda10  => j.ln_mda10,
                                                 ln_pap10  => j.ln_pap10,
                                                 ln_cta10  => j.ln_cta10,
                                                 ln_oper10 => j.ln_oper10,
                                                 ln_sbop10 => j.ln_sbop10,
                                                 ln_tope10 => j.ln_tope10,
                                                 lc_FlgLn  => lc_Vinculado);
    
      if lc_ven = 'S' and lc_Vinculado <> 'S' then
      
        ln_CredVig := ln_CredVig + 1;
      end if;
    
    end loop;
  
    ln_NroCredVig := nvl(ln_CredVig, 0);
  
  end sp_cr_NroCredVig;
  --------------------------------------------------------------------------
end PQ_CR_CNTRL_REGNORTE;
/
