create or replace package PQ_CR_RP_ANALISTA is

  -- Author  : MPOSTIGOC
  -- Created : 09/11/2017 01:08:36 p.m.
  -- Purpose : Verifica si todos los integrantes de la cuenta presentan el mismo analista en todos sus
  --           creditos vigentes o en vuelo

  Procedure sp_inicio(pn_pai          in number,
                      pn_tdo          in number,
                      pc_ndo          in char,
                      ln_NroInstancia in number,
                      lc_Message      out varchar2);
  ------------------------------------------------------------------------------------

  procedure sp_cr_VerificaDPFCTS(ln_pgcod     in number,
                                 ln_modulo    in number,
                                 ln_sucursal  in number,
                                 ln_moneda    in number,
                                 ln_papel     in number,
                                 ln_cuenta    in number,
                                 ln_operac    in number,
                                 ln_suboper   in number,
                                 ln_tipoper   in number,
                                 lc_VerifExcp out Varchar2);
  -------------------------------------------------------------------------------

  procedure sp_cr_VerificaDPFCTSVuelo(ln_Instancia in number,
                                      lc_VerifExcp out varchar2);

  ----------------------------------------------------------------------------------------
  procedure sp_cr_VerificaHipotecario(ln_pgcod     in number,
                                      ln_modulo    in number,
                                      ln_sucursal  in number,
                                      ln_moneda    in number,
                                      ln_papel     in number,
                                      ln_cuenta    in number,
                                      ln_operac    in number,
                                      ln_suboper   in number,
                                      ln_tipoper   in number,
                                      lc_VerifHipo out Varchar2);

end PQ_CR_RP_ANALISTA;
/

create or replace package body PQ_CR_RP_ANALISTA is

  Procedure sp_inicio(pn_pai          in number,
                      pn_tdo          in number,
                      pc_ndo          in char,
                      ln_NroInstancia in number,
                      lc_Message      out varchar2) is
  
    cursor clientes is
      select distinct A.CTNRO
        from fsr008 a
        left join fsr002 b
          on a.pepais = b.pepais
         and a.petdoc = b.petdoc
         and a.pendoc = b.pendoc
         and b.rpccyg = 66
      
       where ctnro in (select ctnro
                         from fsr008 a
                        where a.pepais = pn_pai
                          and a.petdoc = pn_tdo
                          and a.pendoc = pc_ndo);
  
    cursor creditos(ln_cta in number) is
      select distinct B.PGCOD,
                      b.aomod,
                      b.aosuc,
                      b.aomda,
                      b.aopap,
                      b.aocta,
                      b.aooper,
                      b.aosbop,
                      b.aotope,
                      b.aofval,
                      b.aofvto,
                      
                      b.aostat,
                      a.pepais,
                      a.petdoc,
                      a.pendoc
        from fsd010 b, fsr008 a
       where b.pgcod = 1
         and b.aocta = ln_cta
         and b.pgcod = a.pgcod
         and b.aocta = a.ctnro
         and a.cttfir = 'T'
         and aomod in (select modulo
                         from fst111
                        where dscod = 50
                          and modulo not in (200, 33, 108, 107))
            
         and aotope <> 550
         and aostat <> 99;
  
    cursor vuelo(ln_cta in number) is
    
      select x.xwfempresa   ln_pgcod10,
             x.xwfmodulo    ln_mod10,
             x.xwfsucursal  ln_suc10,
             x.xwfmoneda    ln_mda10,
             x.xwfpapel     ln_pap10,
             x.xwfcuenta    ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope    ln_sbop10,
             x.xwftipope    ln_tope10,
             s.sng120ins    ln_Instance
        from xwf700 x, sng120 s
       where x.xwfempresa = 1
         and x.xwfcuenta = ln_cta
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (200, 33, 108, 107)) or
             x.xwfmodulo = 117)
            
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
                         and w.wftaskcod >= 11 -- Propuesta
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd'))
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd'))
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
                s.sng120ins;
  
    lc_VerifExcp  varchar2(2);
    lc_VerifHipo  varchar2(2);
    ln_Instancia  number;
    lc_Analista   varchar2(10);
    lc_AnalistAux varchar2(10) := null;
    lc_Flag       varchar2(2) := 'S';
    cont          number := 0;
    ln_modul117   number;
    ln_cta117     number;
    ln_oper117    number;
    ln_sboper117  number;
    ln_sucur117   number;
    ln_mda117     number;
    ln_tipoer117  number;
    ln_pap117     number;
  begin
  
    begin
    
      for j in clientes loop
        for i in creditos(j.ctnro) loop
        
          lc_AnalistAux := lc_Analista;
        
          -- Verifica Garantia DPF/CTS
        
          PQ_CR_RP_ANALISTA.sp_cr_VerificaDPFCTS(ln_pgcod     => I.PGCOD,
                                                 ln_modulo    => I.AOMOD,
                                                 ln_sucursal  => I.AOSUC,
                                                 ln_moneda    => I.AOMDA,
                                                 ln_papel     => I.AOPAP,
                                                 ln_cuenta    => I.AOCTA,
                                                 ln_operac    => I.AOOPER,
                                                 ln_suboper   => I.AOSBOP,
                                                 ln_tipoper   => I.AOTOPE,
                                                 lc_VerifExcp => lc_VerifExcp);
        
          -- Verifica si es Hipotecario
          PQ_CR_RP_ANALISTA.sp_cr_VerificaHipotecario(ln_pgcod     => I.PGCOD,
                                                      ln_modulo    => I.AOMOD,
                                                      ln_sucursal  => I.AOSUC,
                                                      ln_moneda    => I.AOMDA,
                                                      ln_papel     => I.AOPAP,
                                                      ln_cuenta    => I.AOCTA,
                                                      ln_operac    => I.AOOPER,
                                                      ln_suboper   => I.AOSBOP,
                                                      ln_tipoper   => I.AOTOPE,
                                                      lc_VerifHipo => lc_VerifHipo);
        
          if lc_VerifExcp <> 'N' and lc_VerifHipo <> 'S' then
            cont := cont + 1;
          
            /*if i.aomod = 116 then
                -- MPOSTIGOC 120118 Si es 116,  buscamos su Linea Principal
                begin
                
                  select f.r2mod,
                         f.r2cta,
                         f.r2oper,
                         f.r2sbop,
                         f.r2suc,
                         f.r2mda,
                         f.r2tope,
                         f.r2pap
                    into ln_modul117,
                         ln_cta117,
                         ln_oper117,
                         ln_sboper117,
                         ln_sucur117,
                         ln_mda117,
                         ln_tipoer117,
                         ln_pap117
                    from fsr011 f
                   where f.r1cod = i.pgcod
                     and f.r1mod = i.aomod
                     and f.r1suc = i.aosuc
                     and f.r1mda = i.aomda
                     and f.r1pap = i.aopap
                     and f.r1cta = i.aocta
                     and f.r1oper = i.aooper
                     and f.r1sbop = i.aosbop
                     and f.r1tope = i.aotope
                     and f.relcod = 46;
                exception
                  when others then
                    null;
                end;
              
                begin
                  select X.XWFPRCINS
                    into ln_Instancia
                    from xwf700 x
                   where x.xwfempresa = 1
                     and x.xwfsucursal = ln_sucur117
                     and x.xwfmodulo = ln_modul117
                     and x.xwfmoneda = ln_mda117
                     and x.xwfpapel = ln_pap117
                     and x.xwfcuenta = ln_cta117
                     and x.xwfoperacion = ln_oper117 --i.aooper
                     and x.xwfsubope = ln_sboper117 --i.aosbop
                     and x.xwftipope = ln_tipoer117 --i.aotope
                     and x.xwfcar3 = '1';
                exception
                  when others then
                    ln_Instancia := 0;
                end;
              
              else
                if i.aomod <> 116 then
                
                  begin
                    select X.XWFPRCINS
                      into ln_Instancia
                      from xwf700 x
                     where x.xwfempresa = i.pgcod
                       and x.xwfsucursal = i.aosuc
                       and x.xwfmodulo = i.aomod
                       and x.xwfmoneda = i.aomda
                       and x.xwfpapel = i.aopap
                       and x.xwfcuenta = i.aocta
                       and x.xwfoperacion = i.aooper
                       and x.xwfsubope = i.aosbop
                       and x.xwftipope = i.aotope
                       and x.xwfcar3 = '1';
                  exception
                    when others then
                      ln_Instancia := 0;
                  end;
                
                end if;
              end if; -- mpostigoc INC1662 19/03/2019
            */
            ln_Instancia := fn_instancia_credito(v_Scmod  => i.aomod,
                                                 v_Scsuc  => i.aosuc,
                                                 v_Scmda  => i.aomda,
                                                 v_Scpap  => i.aopap,
                                                 v_Sccta  => i.aocta,
                                                 v_Scoper => i.aooper,
                                                 v_Scsbop => i.aosbop,
                                                 v_Sctope => i.aotope);
          
            begin
              select SNG001ASE
                into lc_Analista
                from sng001
               where SNG001INST = ln_Instancia;
            exception
              when others then
                null;
            end;
          
          end if;
        
          if lc_AnalistAux is null then
            lc_AnalistAux := lc_Analista;
          end if;
        
          if lc_AnalistAux <> lc_Analista then
            lc_Flag := 'N';
            exit;
          
          else
            lc_Flag := 'S';
          end if;
        
        end loop;
      
        if lc_AnalistAux <> lc_Analista then
          lc_Flag := 'N';
          exit;
        end if;
      
        if lc_Flag = 'S' then
        
          for v in vuelo(j.ctnro) loop
          
            lc_AnalistAux := lc_Analista;
          
            --Verifica Garantia DPF/CTS Vuelo
          
            pq_cr_rp_analista.sp_cr_VerificaDPFCTSVuelo(ln_Instancia => v.ln_Instance,
                                                        lc_VerifExcp => lc_VerifExcp);
          
            -- Verifica si es Hipotecario
            PQ_CR_RP_ANALISTA.sp_cr_VerificaHipotecario(ln_pgcod     => v.ln_pgcod10,
                                                        ln_modulo    => v.ln_mod10,
                                                        ln_sucursal  => v.ln_suc10,
                                                        ln_moneda    => v.ln_mda10,
                                                        ln_papel     => v.ln_pap10,
                                                        ln_cuenta    => v.ln_cta10,
                                                        ln_operac    => v.ln_oper10,
                                                        ln_suboper   => v.ln_sbop10,
                                                        ln_tipoper   => v.ln_tope10,
                                                        lc_VerifHipo => lc_VerifHipo);
          
            if lc_VerifExcp <> 'N' and lc_VerifHipo <> 'S' then
              cont := cont + 1;
            
              begin
                select SNG001ASE
                  into lc_Analista
                  from sng001
                 where SNG001INST = v.ln_Instance;
              exception
                when others then
                  null;
              end;
            
            end if;
          
            if lc_AnalistAux <> lc_Analista then
              lc_Flag := 'N';
              exit;
            
            else
              lc_Flag := 'S';
            end if;
          
          end loop;
        
          if lc_AnalistAux <> lc_Analista then
            lc_Flag := 'N';
            exit;
          end if;
        
        end if;
      
      end loop;
    
      if cont = 0 then
      
        begin
          select SNG001ASE, 'S'
            into lc_Analista, lc_Flag
            from sng001
           where SNG001INST = ln_NroInstancia;
        exception
          when others then
            null;
          
        end;
      
      end if;
    
      if lc_Flag = 'S' then
        lc_Message := lc_Analista;
      else
        if lc_Flag = 'N' then
        
          lc_Message := 'ERROR';
        
        end if;
      end if;
    
    end;
  
  end sp_inicio;

  ------------------------------------------------------------------------------------

  procedure sp_cr_VerificaDPFCTS(ln_pgcod     in number,
                                 ln_modulo    in number,
                                 ln_sucursal  in number,
                                 ln_moneda    in number,
                                 ln_papel     in number,
                                 ln_cuenta    in number,
                                 ln_operac    in number,
                                 ln_suboper   in number,
                                 ln_tipoper   in number,
                                 lc_VerifExcp out Varchar2) is
  
    FlgIncl      varchar2(2);
    ln_modul117  number;
    ln_cta117    number;
    ln_oper117   number;
    ln_sboper117 number;
    ln_sucur117  number;
    ln_mda117    number;
    ln_tipoer117 number;
  
  begin
  
    begin
    
      if ln_modulo = 116 then
      
        begin
        
          select f.r2mod,
                 f.r2cta,
                 f.r2oper,
                 f.r2sbop,
                 f.r2suc,
                 f.r2mda,
                 f.r2tope
            into ln_modul117,
                 ln_cta117,
                 ln_oper117,
                 ln_sboper117,
                 ln_sucur117,
                 ln_mda117,
                 ln_tipoer117
            from fsr011 f
           where f.r1cod = ln_pgcod
             and f.r1mod = ln_modulo
             and f.r1suc = ln_sucursal
             and f.r1mda = ln_moneda
             and f.r1pap = ln_papel
             and f.r1cta = ln_cuenta
             and f.r1oper = ln_operac
             and f.r1sbop = ln_suboper
             and f.r1tope = ln_tipoper
             and f.relcod = 46;
        
        end;
      
        begin
          Select 'N'
            into FlgIncl
            from fsr011 a, fsr011 b
           where a.relcod = 50
             and a.r1cod = ln_pgcod
             and a.r1mod = ln_modul117
             and a.r1suc = ln_sucur117
             and a.r1mda = ln_mda117
             and a.r1pap = 0
             and a.r1cta = ln_cta117
             and a.r1oper = ln_oper117
             and a.r1sbop = ln_sboper117
             and a.r1tope = ln_tipoer117
             and b.r2cta = a.r2cta
             and b.r2oper = a.r2oper
             and b.r2sbop = a.r2sbop
             and b.relcod in (2, 25)
             and a.r011co = 'S'
             and b.r011co = 'S'
             and rownum = 1;
        exception
          when no_data_found then
            -- ln_rcta := 0;
            FlgIncl := 'S';
          
        end;
      
      else
        if ln_modulo <> 116 then
        
          begin
            --créditos con garantía de plazo fijo o cts
          
            Select 'N'
              into FlgIncl
              from fsr011 a, fsr011 b
             where a.relcod = 50
               and a.r1cod = ln_pgcod
               and a.r1mod = ln_modulo
               and a.r1suc = ln_sucursal
               and a.r1mda = ln_moneda
               and a.r1pap = ln_papel
               and a.r1cta = ln_cuenta
               and a.r1oper = ln_operac
               and a.r1sbop = ln_suboper
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
              -- ln_rcta := 0;
              FlgIncl := 'S';
          end;
        End If;
      
      end if;
    
    end;
  
    if FlgIncl = 'N' then
      lc_VerifExcp := 'N';
    
    else
      lc_VerifExcp := 'S';
    end if;
  
  end sp_cr_VerificaDPFCTS;

  -------------------------------------------------------------------------------

  procedure sp_cr_VerificaDPFCTSVuelo(ln_Instancia in number,
                                      lc_VerifExcp out varchar2) is
  
  begin
  
    begin
    
      select 'N'
        into lc_VerifExcp
        from sng122 s
       where s.sng122inst = ln_Instancia
         and s.sng122mod = 70
         and s.sng122tope in (80, 85)
         and rownum = 1;
    exception
      when others then
        lc_VerifExcp := 'S';
      
    end;
  end sp_cr_VerificaDPFCTSVuelo;
  ---------------------------------------------------------------------------------
  procedure sp_cr_VerificaHipotecario(ln_pgcod     in number,
                                      ln_modulo    in number,
                                      ln_sucursal  in number,
                                      ln_moneda    in number,
                                      ln_papel     in number,
                                      ln_cuenta    in number,
                                      ln_operac    in number,
                                      ln_suboper   in number,
                                      ln_tipoper   in number,
                                      lc_VerifHipo out Varchar2) is
  
    lc_rubro varchar2(2);
  begin
  
    lc_VerifHipo := 'N';
  
    begin
      select SUBSTR(SCRUB, 5, 2)
        into lc_rubro
        from fsd011
       where PGCOD = ln_pgcod
         and scmod = ln_modulo
         and SCSUC = ln_sucursal
         and SCMDA = ln_moneda
         and SCPAP = ln_papel
         and SCCTA = ln_cuenta
         and SCOPER = ln_operac
         and SCSBOP = ln_suboper
         and SCTOPE = ln_tipoper;
    exception
      when others then
        null;
    end;
  
    if lc_rubro is null then
    
      begin
        -- Rubro de la Solicitud en Vuelo
        select SUBSTR(to_char(ww.pp028defc), 5, 2)
          into lc_rubro
          from fpp028 ww
         where ww.pp017par = 115
           and ww.pp028mod = ln_modulo
           and ww.pp028top = ln_tipoper
           and ww.pp028emp = ln_pgcod
           and ww.pp028mda = ln_moneda
           and ww.pp028pap = ln_papel;
      exception
        when others then
          null;
      end;
    
    end if;
  
    if lc_rubro = '04' then
      lc_VerifHipo := 'S';
    
    else
      lc_VerifHipo := 'N';
    end if;
  
  end sp_cr_VerificaHipotecario;
  ---------------------------------------------------------------------------------  

end PQ_CR_RP_ANALISTA;
/

