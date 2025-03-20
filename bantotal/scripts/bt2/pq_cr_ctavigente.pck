create or replace package PQ_CR_CTAVIGENTE is

  -- Author  : MPOSTIGOC
  -- Created : 26/12/2018 4:06:24 p. m.
  -- Purpose : 

  procedure sp_cr_PoseeCredVigente(ln_Instancia      in number,
                                   lc_PoseeCredVignt out varchar2);
  ---------------------------------------------------
  procedure sp_cr_VerfDPFCTS(ln_pgcod      in number,
                             ln_modulo     in number,
                             ln_sucursal   in number,
                             ln_moneda     in number,
                             ln_papel      in number,
                             ln_cuenta     in number,
                             ln_operacion  in number,
                             ln_subopera   in number,
                             ln_tipoper    in number,
                             lc_VerfDPFCTS out varchar2);
  -------------------------------------------------------
  procedure sp_cr_ClienteMicro(ln_Instancia  in number,
                               ln_CTSupMujer out number,
                               ln_AFSupMujer out number);
  ----------------------------------------------------------------                                                                  
  Procedure Sp_ampliados_CK(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            Pc_flag   out varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_RefiReproLinea(ln_pgcod10  in number,
                                 ln_mod10    in number,
                                 ln_suc10    in number,
                                 ln_mda10    in number,
                                 ln_pap10    in number,
                                 ln_cta10    in number,
                                 ln_oper10   in number,
                                 lc_fgRefLin out varchar2);

end PQ_CR_CTAVIGENTE;
/

create or replace package body PQ_CR_CTAVIGENTE is

  procedure sp_cr_PoseeCredVigente(ln_Instancia      in number,
                                   lc_PoseeCredVignt out varchar2) is
  
    cursor lista_credvignt(ln_pais number,
                           ln_tdoc number,
                           ln_ndoc varchar2) is
      select *
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_pais
                              and Petdoc = ln_tdoc
                              and pendoc = ln_ndoc
                           
                           )
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (select tp1nro3
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 600
                                        and a.tp1corr2 = 3
                                        and a.tp1corr3 > 1)) or
             d10.Aomod = 117)
         and d10.Aostat <> 99;
  
    ln_pgcod       number;
    ln_pais        number;
    ln_tdoc        number;
    ln_ndoc        varchar2(12);
    ln_NroCredVig  number := 0;
    lc_FlagExistSM varchar2(2);
    lc_VerfDPFCTS  varchar2(5) := 'N';
  
  begin
  
    lc_PoseeCredVignt := 'N';
  
    begin
      select s.sng001emp, s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pgcod, ln_pais, ln_tdoc, ln_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    for l in lista_credvignt(ln_pais, ln_tdoc, ln_ndoc) loop
    
      lc_FlagExistSM := 'N';
    
      if l.aomod = 103 then
        begin
          select 'S'
            into lc_FlagExistSM
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 600
             and a.tp1corr2 = 2
             and a.tp1corr3 > 0
             and a.tp1nro3 = l.aotope;
        exception
          when others then
            lc_FlagExistSM := 'N';
        end;
        if lc_FlagExistSM = 'N' then
          ln_NroCredVig := 1;
          exit;
        else
          ln_NroCredVig := 0;
        end if;
      
      else
        if l.aomod <> 103 then
        
          pq_cr_ctavigente.sp_cr_verfDPFCTS(ln_pgcod      => l.pgcod,
                                            ln_modulo     => l.aomod,
                                            ln_sucursal   => l.aosuc,
                                            ln_moneda     => l.aomda,
                                            ln_papel      => l.aopap,
                                            ln_cuenta     => l.aocta,
                                            ln_operacion  => l.aooper,
                                            ln_subopera   => l.aosbop,
                                            ln_tipoper    => l.aotope,
                                            lc_VerfDPFCTS => lc_VerfDPFCTS);
        
          if lc_VerfDPFCTS = 'N' then
            ln_NroCredVig := 1;
            exit;
          end if;
        end if;
      end if;
    
    end loop;
  
    if ln_NroCredVig > 0 then
      lc_PoseeCredVignt := 'S';
    else
      lc_PoseeCredVignt := 'N';
    end if;
  
  end sp_cr_PoseeCredVigente;
  ------------------------------------------------
  procedure sp_cr_VerfDPFCTS(ln_pgcod      in number,
                             ln_modulo     in number,
                             ln_sucursal   in number,
                             ln_moneda     in number,
                             ln_papel      in number,
                             ln_cuenta     in number,
                             ln_operacion  in number,
                             ln_subopera   in number,
                             ln_tipoper    in number,
                             lc_VerfDPFCTS out varchar2) is
    ln_mod    number;
    ln_cta    number;
    ln_oper   number;
    ln_sboper number;
    ln_sucur  number;
    ln_mda    number;
    ln_tipoer number;
  
  begin
  
    lc_VerfDPFCTS := 'N';
  
    if ln_modulo = 116 then
    
      begin
      
        select f.r2mod,
               f.r2cta,
               f.r2oper,
               f.r2sbop,
               f.r2suc,
               f.r2mda,
               f.r2tope
          into ln_mod,
               ln_cta,
               ln_oper,
               ln_sboper,
               ln_sucur,
               ln_mda,
               ln_tipoer
          from fsr011 f
         where f.r1cod = ln_pgcod
           and f.r1mod = ln_modulo
           and f.r1suc = ln_sucursal
           and f.r1mda = ln_moneda
           and f.r1pap = ln_papel
           and f.r1cta = ln_cuenta
           and f.r1oper = ln_operacion
           and f.r1sbop = ln_subopera
           and f.r1tope = ln_tipoper
           and f.relcod = 46;
      
      end;
    
      begin
        Select 'S'
          into lc_VerfDPFCTS
          from fsr011 a, fsr011 b
         where a.relcod = 50
           and a.r1cod = 1
           and a.r1mod = ln_mod
           and a.r1suc = ln_sucur
           and a.r1mda = ln_mda
           and a.r1pap = 0
           and a.r1cta = ln_cta
           and a.r1oper = ln_oper
           and a.r1sbop = ln_sboper
           and a.r1tope = ln_tipoer
           and b.r2cta = a.r2cta
           and b.r2oper = a.r2oper
           and b.r2sbop = a.r2sbop
           and b.relcod in (2, 25)
           and a.r011co = 'S'
           and b.r011co = 'S'
           and rownum = 1;
      exception
        when no_data_found then
          lc_VerfDPFCTS := 'N';
        
      end;
    
    else
      if ln_modulo <> 116 then
      
        begin
          --créditos con garantía de plazo fijo o cts
        
          Select 'S'
            into lc_VerfDPFCTS
            from fsr011 a, fsr011 b
           where a.relcod = 50
             and a.r1cod = ln_pgcod
             and a.r1mod = ln_modulo
             and a.r1suc = ln_sucursal
             and a.r1mda = ln_moneda
             and a.r1pap = ln_papel
             and a.r1cta = ln_cuenta
             and a.r1oper = ln_operacion
             and a.r1sbop = ln_subopera
             and a.r1tope = ln_tipoper
             and b.r2cta = a.r2cta
             and b.r2oper = a.r2oper
             and b.r2sbop = a.r2sbop
             and b.relcod in (2, 25)
             and a.r011co = 'S'
             and b.r011co = 'S'
             and rownum = 1;
        exception
          when no_data_found then
            lc_VerfDPFCTS := 'N';
        end;
      End If;
    
    end if;
  
  end sp_cr_VerfDPFCTS;
  ------------------------------------------------

  procedure sp_cr_ClienteMicro(ln_Instancia  in number,
                               ln_CTSupMujer out number,
                               ln_AFSupMujer out number) is
  
    cursor lista_credvig(ln_pais number, ln_tdoc number, lc_doc varchar2) is
    
      select r.pgcod  ln_pgcod,
             r.aomod  ln_modulo,
             r.aosuc  ln_sucursal,
             r.aomda  ln_moneda,
             r.aopap  ln_papel,
             r.aocta  ln_cuenta,
             r.aooper ln_operacion,
             r.aosbop ln_suboperacion,
             r.aotope ln_tipoperacion
        from fsd010 r
       where r.pgcod = 1
         and r.aomod = 103
         and r.aocta in (select ctnro
                           from fsr008 f
                          where f.pepais = ln_pais
                            and f.petdoc = ln_tdoc
                            and f.pendoc = lc_doc)
         and r.aostat <> 99
      union
      select r.pgcod  ln_pgcod,
             r.aomod  ln_modulo,
             r.aosuc  ln_sucursal,
             r.aomda  ln_moneda,
             r.aopap  ln_papel,
             r.aocta  ln_cuenta,
             r.aooper ln_operacion,
             r.aosbop ln_suboperacion,
             r.aotope ln_tipoperacion
        from fsr008 a, fsd010 r, fsr002 c
       where r.pgcod = 1
         and r.aomod = 103
         and c.pepais = ln_pais
         and c.petdoc = ln_tdoc
         and c.pendoc = lc_doc
         and r.aostat <> 99
         and a.ctnro = r.aocta
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    cursor lista_CredVuelo(ln_pais number, ln_tdoc number, lc_doc varchar2) is
    
      select x.xwfempresa   ln_pgcod10,
             x.xwfmodulo    ln_mod10,
             x.xwfsucursal  ln_suc10,
             x.xwfmoneda    ln_mda10,
             x.xwfpapel     ln_pap10,
             x.xwfcuenta    ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope    ln_sbop10,
             x.xwftipope    ln_tope10
        from xwf700 x
       where x.xwfempresa = 1
         and x.xwfcuenta in (select Ctnro
                               from fsr008
                              where pepais = ln_pais
                                and Petdoc = ln_tdoc
                                and pendoc = lc_doc)
            
         and x.xwfmodulo = 103
            
         and (x.XWFPRCINS in
             (select wfinsprcid
                 from wfwrkitems wf
                where wf.wfinsprcid = x.xwfprcins
                  and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                  and wf.wfiteminit =
                      (select max(wfiteminit)
                         from wfwrkitems w
                        where w.wfinsprcid = x.xwfprcins
                          and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                          and w.wfitemstsact = 1
                          and w.wfiteminit >=
                              to_date('2013.07.01', 'yyyy.mm.dd')) --20160519                     
                  and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) /*and
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     x.xwfprcins not in ln_Instancia*/
             ) --20160519
         and x.xwfcar3 = '1'
      
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope
      union
      select x.xwfempresa   ln_pgcod10,
             x.xwfmodulo    ln_mod10,
             x.xwfsucursal  ln_suc10,
             x.xwfmoneda    ln_mda10,
             x.xwfpapel     ln_pap10,
             x.xwfcuenta    ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope    ln_sbop10,
             x.xwftipope    ln_tope10
        from xwf700 x, fsr002 c, fsr008 a
       where x.xwfempresa = 1
         and c.pepais = ln_pais
         and c.petdoc = ln_tdoc
         and c.pendoc = lc_doc
         and a.pgcod = x.xwfempresa
         and a.ctnro = x.xwfcuenta
         and x.xwfmodulo = 103
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and x.XWFPRCINS in
             (select wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                 and wf.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                         and w.wfitemstsact = 1
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
         and x.xwfcar3 = '1'
      
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope;
  
    ln_pais        number;
    ln_tdoc        number;
    lc_doc         varchar2(12);
    lc_FlagAmp     varchar2(2) := 'N';
    lc_FlagRefRepr varchar2(2) := 'N';
    ln_TipSupMujer number;
  
  begin
  
    begin
      -- Datos del Titular
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_doc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    ln_CTSupMujer := 0;
    ln_AFSupMujer := 0;
  
    for cv in lista_credvig(ln_pais, ln_tdoc, lc_doc) loop
    
      pq_cr_resolutor_cantfinan.Sp_ampliados_CK(ln_emp10  => cv.ln_pgcod,
                                                ln_mod10  => cv.ln_modulo,
                                                ln_suc10  => cv.ln_sucursal,
                                                ln_mda10  => cv.ln_moneda,
                                                ln_pap10  => cv.ln_papel,
                                                ln_cta10  => cv.ln_cuenta,
                                                ln_oper10 => cv.ln_operacion,
                                                ln_sbop10 => cv.ln_suboperacion,
                                                ln_tope10 => cv.ln_tipoperacion,
                                                Pc_flag   => lc_FlagAmp);
    
      pq_cr_resolutor_cantfinan.sp_cr_RefiReproLinea(ln_pgcod10  => cv.ln_pgcod,
                                                     ln_mod10    => cv.ln_modulo,
                                                     ln_suc10    => cv.ln_sucursal,
                                                     ln_mda10    => cv.ln_moneda,
                                                     ln_pap10    => cv.ln_papel,
                                                     ln_cta10    => cv.ln_cuenta,
                                                     ln_oper10   => cv.ln_operacion,
                                                     lc_fgRefLin => lc_FlagRefRepr);
    
      if lc_FlagAmp = 'N' and lc_FlagRefRepr = 'N' then
      
        begin
          select a.tp1nro2
            into ln_TipSupMujer
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 600
             and a.tp1corr2 = 2
             and a.tp1corr3 > 0
             and a.tp1nro3 = cv.ln_tipoperacion;
        exception
          when others then
            ln_TipSupMujer := 999;
        end;
      
        if ln_TipSupMujer = 1 then
        
          ln_CTSupMujer := ln_CTSupMujer + 1;
        
        else
          if ln_TipSupMujer = 2 then
          
            ln_AFSupMujer := ln_AFSupMujer + 1;
          
          end if;
        end if;
      
      end if;
    
    end loop;
  
    for cvl in lista_CredVuelo(ln_pais, ln_tdoc, lc_doc) loop
    
      begin
        select a.tp1nro2
          into ln_TipSupMujer
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 600
           and a.tp1corr2 = 2
           and a.tp1corr3 > 0
           and a.tp1nro3 = cvl.ln_tope10;
      exception
        when others then
          ln_TipSupMujer := 999;
      end;
    
      if ln_TipSupMujer = 1 then
      
        ln_CTSupMujer := ln_CTSupMujer + 1;
      
      else
        if ln_TipSupMujer = 2 then
        
          ln_AFSupMujer := ln_AFSupMujer + 1;
        
        end if;
      end if;
    
    end loop;
  
  end sp_cr_ClienteMicro;

  ---------------------------------------------

  Procedure Sp_ampliados_CK(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            Pc_flag   out varchar2) is --mod 2016.04.12
  
  begin
  
    begin
    
      select 'S'
        into Pc_flag
        from xwf700 a, sng001 s /* xwf070 w,*/, wfwrkitems x
       where a.xwfempresa = ln_emp10
         and a.xwfsucursal = ln_suc10
         and a.xwfmodulo = ln_mod10
         and a.xwfmoneda = ln_mda10
         and a.xwfpapel = ln_pap10
         and a.xwfcuenta = ln_cta10
         and a.xwfoperacion = ln_oper10
         and a.xwfsubope = ln_sbop10
         and a.xwftipope = ln_tope10
         and a.xwfprcins = s.sng001inst
         and s.sng001ori in (4, 15) -- Ampliaciones Normales, Ampliaciones Especiales
         and s.sng001inst = x.wfinsprcid
         and x.wfitemstsact = 1
         and rownum = 1;
    exception
      when no_data_found then
        Pc_flag := 'N';
    end;
  
  end Sp_ampliados_CK;
  --------------------------------------------------------- 
  procedure sp_cr_RefiReproLinea(ln_pgcod10  in number,
                                 ln_mod10    in number,
                                 ln_suc10    in number,
                                 ln_mda10    in number,
                                 ln_pap10    in number,
                                 ln_cta10    in number,
                                 ln_oper10   in number,
                                 lc_fgRefLin out varchar2) is
  
  begin
    if ln_mod10 = 117 then
    
      begin
        select 'S'
          into lc_fgRefLin
          from fsr011 f, xwf700 w
         where f.r1cod = w.xwfempresa
           and f.r1mod = w.xwfmodulo
           and f.r1suc = w.xwfsucursal
           and f.r1mda = w.xwfmoneda
           and f.r1pap = w.xwfpapel
           and f.r1cta = w.xwfcuenta
           and w.xwfcar3 = 'R'
           and f.r2cod = ln_pgcod10
           and f.r2mod = ln_mod10
           and f.r2suc = ln_suc10
           and f.R2MDA = ln_mda10
           and f.R2PAP = ln_pap10
           and f.r2cta = ln_cta10
           and f.r2oper = ln_oper10
           and f.relcod = 46
           and rownum = 1; --2017.03.28
      exception
        when no_data_found then
          lc_fgRefLin := 'N';
      end;
    
    else
    
      begin
        select 'S'
          into lc_fgRefLin
          from xwf700 a, sng001 s, wfwrkitems x
         where a.xwfempresa = ln_pgcod10
           and a.xwfsucursal = ln_suc10
           and a.xwfmodulo = ln_mod10
           and a.xwfmoneda = ln_mda10
           and a.xwfpapel = ln_pap10
           and a.xwfcuenta = ln_cta10
           and a.xwfoperacion = ln_oper10
              
           and a.xwfprcins = s.sng001inst
           and s.sng001ori in (3, 13, 14) -- Refinanciaciones, Reprogramaciones
           and s.sng001inst = x.wfinsprcid
           and x.wfitemstsact = 1
           and rownum = 1;
      
      exception
        when no_data_found then
          lc_fgRefLin := 'N';
        
      end;
    end if;
  
  end sp_cr_RefiReproLinea;
  -------------------------------------
end PQ_CR_CTAVIGENTE;
/

