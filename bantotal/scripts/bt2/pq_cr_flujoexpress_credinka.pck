create or replace package PQ_CR_FLUJOEXPRESS_CREDINKA is

  -- *****************************************************************
  -- Nombre                     : Proceso para ofertas creditos credinka por flujo Express
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 18/12/2024 15:44:43
  -- Autor de Creación          : MARIA POSTIGO
  -- Uso                        : Proceso para ofertas creditos credinka por flujo Express
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 30/12/2024
  -- Autor de la Modificación   :MPOSTIGOC 
  -- Descripción de Modificación: Se agrego procedimiento de avales
  -- Fecha de Modificación      : 30/01/2025
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se agrego el procedimiento para la isnercion de Garantias
  -- *****************************************************************

  procedure sp_Cr_inicio;
  ------------------------------------
  procedure sp_cr_tasasCredinka;
  -----------------------------------
  procedure sp_Cr_RTE_update(ln_pgcodt in number,
                             ln_suct   in number,
                             ln_modt   in number,
                             ln_ttran  in number,
                             ln_relt   in number,
                             ln_ordt   in number);
  -----------------------------------------------
  procedure sp_cr_InsrtAvales;
  --------------------------------------------------  
  procedure sp_cr_GarantiasCdk;
  ---------------------------------------------------------------
  procedure sp_cr_MontosSNG122(ln_instancia in number,
                               ln_pgcod     in number,
                               ln_mod       in number,
                               ln_suc       in number,
                               ln_mda       in number,
                               ln_pap       in number,
                               ln_cta       in number,
                               ln_oper      in number,
                               ln_sbop      in number,
                               ln_tope      in number,
                               ln_poscn     in number,
                               ln_mntgar    out number,
                               ln_mntcober  out number,
                               ln_SaldGar   out number,
                               ln_Porcober  out number);
  --------------------------------------------------
  procedure sp_Cr_InsertFSR011(ln_codcr   in number,
                               ln_modcr   in number,
                               ln_succr   in number,
                               ln_mdacr   in number,
                               ln_papcr   in number,
                               ln_ctacr   in number,
                               ln_opercr  in number,
                               ln_sbopcr  in number,
                               ln_topecr  in number,
                               ln_modgar  in number,
                               ln_ctagar  in number,
                               ln_opergar in number,
                               ln_sbopgar in number,
                               ln_codgar  in number,
                               ln_sucgar  in number,
                               ln_mdagar  in number,
                               ln_papgar  in number,
                               ln_topegar in number,
                               ln_cdtx    in number,
                               ln_modtx   in number,
                               ln_suctx   in number,
                               ln_trtx    in number,
                               ln_retx    in number,
                               ld_fctx    in date,
                               ln_ortx    in number,
                               ln_sbtx    in number);
  --------------------------------------------------------------
  procedure sp_cr_InsertSNG122(ln_inst    in number,
                               ln_122corr in number,
                               ln_122pgc  in number,
                               ln_122mod  in number,
                               ln_122suc  in number,
                               ln_122mda  in number,
                               ln_122pap  in number,
                               ln_122cta  in number,
                               ln_122oper in number,
                               ln_122sbop in number,
                               ln_122tope in number,
                               ln_122pri  in number,
                               ln_122sdog in number,
                               ln_122mtou in number,
                               ld_122fape in date,
                               ln_122mtod in number,
                               ln_122poco in number,
                               ln_122tcbi in number);

end PQ_CR_FLUJOEXPRESS_CREDINKA;
/

create or replace package body PQ_CR_FLUJOEXPRESS_CREDINKA is

  procedure sp_Cr_inicio is
  
    cursor listado(ld_fecha date) is
      select *
        from aqpb178 a
       where a.aqpb178fep = ld_fecha
         and a.aqpb178tflu = 'N'
         and a.aqpb178fprpg >
             (select f.pgfape from fst017 f where f.pgcod = 1)
         and a.aqpb178mseg > '0'
       order by a.aqpb178mto, a.aqpb178cta;
  
    ln_flgProc        number(5) := 0;
    lc_estado         varchar2(1);
    lc_hab            varchar2(1) := 'N';
    ld_Fecaux         date;
    pd_fecprim        date;
    ld_FchSist        date;
    ln_cont           number;
    pn_HisNR          number(1);
    ln_Corr           number(9);
    lc_seg            varchar2(30);
    lc_flgAmpl        varchar2(5) := 'N';
    ld_MaxAqpb185     date;
    ln_Cor751         number(9);
    lc_CodCredinkaAux varchar2(50);
    ln_ContProc       number;
    ln_TipoSol        number;
  
  begin
  
    begin
      -- Call the procedure
      PQ_CR_FLUJOEXPRESS_CREDINKA.sp_cr_tasasCredinka;
    end;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select max(a.aqpb178fep) into ld_MaxAqpb185 from aqpb178 a;
    exception
      when others then
        null;
    end;
  
    for l in listado(ld_MaxAqpb185) loop
    
      lc_CodCredinkaAux := l.aqpb178codcr;
    
      begin
        select count(*)
          into ln_ContProc
          from aqpb178 a
         where a.aqpb178codcr = lc_CodCredinkaAux
           and a.aqpb178tflu = 'D';
      exception
        when others then
          ln_ContProc := 0;
      end;
    
      ln_ContProc := nvl(ln_ContProc, 0);
    
      if ln_ContProc = 0 then
      
        begin
          select a.tp1nro1
            into ln_flgProc
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 77777
             and a.tp1corr2 = 1
             and a.tp1corr3 = 1;
        exception
          when others then
            ln_flgProc := 0;
        end;
      
        if nvl(ln_flgProc, 0) = 0 then
          --flujo express
          begin
            select TRIM(a.tp1desc)
              into lc_estado
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 10899
               and a.tp1corr1 = 77777
               and a.tp1corr2 = 2
               and a.tp1corr3 = 2;
          exception
            when others then
              null;
          end;
        else
          --flujo online
          begin
            select trim(a.tp1desc)
              into lc_estado
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 10899
               and a.tp1corr1 = 77777
               and a.tp1corr2 = 2
               and a.tp1corr3 = 1;
          exception
            when others then
              null;
          end;
        end if;
      
        ---------FECHA PRIMER PAGO--------------
        --ld_Fecaux := pd_fecpro + pn_pzo;
        ld_Fecaux := l.aqpb178fprpg;
        --verificar si es dia habil
        begin
          select a.fhabil
            into lc_hab
            from fst028 a, fst001 b
           where a.calcod = b.calcod
             and a.ffecha = ld_Fecaux
             and b.sucurs = l.aqpb178suc;
        exception
          when others then
            null;
        end;
      
        if nvl(lc_hab, 'N') = 'N' then
          begin
            select min(a.ffecha)
              into pd_fecprim
              from fst028 a, fst001 b
             where a.calcod = b.calcod
               and a.ffecha > ld_Fecaux
               and b.sucurs = l.aqpb178suc
               and a.fhabil = 'S';
          exception
            when others then
              null;
          end;
        else
          pd_fecprim := ld_Fecaux;
        end if;
      
        ---------------------NUEVO/RECURRENTE-----------------
        Pq_Cr_Relcrediticia.Sp_RelCredi_NR(pn_pai      => l.aqpb178pai,
                                           pn_tdo      => l.aqpb178tdo,
                                           pc_ndo      => l.aqpb178ndo,
                                           pd_Fecpro   => ld_FchSist,
                                           ln_contador => ln_cont);
      
        if ln_cont >= 6 then
          pn_HisNR := 2; --Recurrente
        end if;
      
        if ln_cont < 6 then
          pn_HisNR := 1; --Nuevo
        end if;
      
        if nvl(ln_flgProc, 0) = 0 then
          --proceso fintech
          begin
            select nvl(max(jaqm750reg), 0) + 1
              into ln_Corr
              from jaqm750
             where jaqm750fch = ld_FchSist
               and jaqm750reg < 1000000;
          exception
            when others then
              ln_Corr := null;
          end;
        
          if nvl(ln_Corr, 0) = 0 then
            ln_Corr := 1;
          end if;
        
        else
          --proceso flujo online
          begin
            select nvl(max(jaqm750reg), 0) + 1
              into ln_Corr
              from jaqm750
             where jaqm750fch = ld_FchSist
               and jaqm750reg >= 1000000;
          exception
            when others then
              ln_Corr := null;
          end;
        
          if nvl(ln_Corr, 0) = 1 then
            ln_Corr := 1000000;
          end if;
        
        end if;
      
        lc_flgAmpl := nvl(lc_flgAmpl, 'N');
      
        if l.aqpb178mod = 107 then
          ln_TipoSol := 10;
        else
          ln_TipoSol := 0;
        end if;
      
        if lc_flgAmpl = 'N' then
        
          begin
            Insert into JAQM750
            values
              (1,
               ld_FchSist,
               ln_Corr,
               l.aqpb178pai,
               l.aqpb178tdo,
               l.aqpb178ndo,
               0,
               ln_TipoSol,
               pn_HisNR,
               l.aqpb178mod,
               l.aqpb178top,
               l.aqpb178suc,
               l.aqpb178mda,
               0,
               l.aqpb178cta,
               l.aqpb178ase,
               2,
               1,
               l.aqpb178fprpg,
               l.aqpb178mto,
               l.aqpb178cuo,
               l.aqpb178frec,
               lc_estado);
          
            commit;
          end;
          ---INSERTAR JAQM751 SEGUROS
          begin
            -- Desgravamen
            begin
              select f.tp1nro3 || '|' || l.aqpb178mseg
                into lc_seg
                from fst198 f
               where f.tp1cod = 1
                 and f.tp1cod1 = 10899
                 and f.tp1corr1 = 144
                 and f.tp1corr2 = 1
                 and f.tp1corr3 = 1;
            exception
              when others then
                lc_seg := '';
            end;
          
            begin
              select nvl(max(a.jaqm751cor), 0) + 1
                into ln_Cor751
                from jaqm751 a
               where a.jaqm751emp = 1
                 and a.jaqm751fch = ld_FchSist
                 and a.jaqm751att = 'SEGCOD'
                 and a.jaqm751reg = ln_Corr;
            exception
              when others then
                ln_Cor751 := null;
            end;
          
            if nvl(ln_Cor751, 0) = 1 then
              ln_Cor751 := 1;
            end if;
          
            insert into jaqm751
              (jaqm751emp,
               jaqm751fch,
               jaqm751reg,
               jaqm751att,
               jaqm751cor,
               jaqm751val)
            values
              (1, ld_FchSist, ln_Corr, 'SEGCOD', ln_Cor751, lc_seg);
            commit;
          
            -- INDICADOR CREDINKA 
            begin
              select nvl(max(a.jaqm751cor), 0) + 1
                into ln_Cor751
                from jaqm751 a
               where a.jaqm751emp = 1
                 and a.jaqm751fch = ld_FchSist
                 and a.jaqm751att = 'CREDINKA'
                 and a.jaqm751reg = ln_Corr;
            exception
              when others then
                ln_Cor751 := null;
            end;
          
            if nvl(ln_Cor751, 0) = 1 then
              ln_Cor751 := 1;
            end if;
          
            insert into jaqm751
              (jaqm751emp,
               jaqm751fch,
               jaqm751reg,
               jaqm751att,
               jaqm751cor,
               jaqm751val)
            values
              (1, ld_FchSist, ln_Corr, 'CREDINKA', ln_Cor751, 'S');
            commit;
          end;
        
          if l.aqpb178mod = 107 then
            -- CARTERA PARA CONVENIOS 
            begin
              select nvl(max(a.jaqm751cor), 0) + 1
                into ln_Cor751
                from jaqm751 a
               where a.jaqm751emp = 1
                 and a.jaqm751fch = ld_FchSist
                 and a.jaqm751att = 'CONVENIO'
                 and a.jaqm751reg = ln_Corr;
            exception
              when others then
                ln_Cor751 := null;
            end;
          
            if nvl(ln_Cor751, 0) = 1 then
              ln_Cor751 := 1;
            end if;
          
            insert into jaqm751
              (jaqm751emp,
               jaqm751fch,
               jaqm751reg,
               jaqm751att,
               jaqm751cor,
               jaqm751val)
            values
              (1,
               ld_FchSist,
               ln_Corr,
               'CONVENIO',
               ln_Cor751,
               l.aqpb178nroconv);
            commit;
          end if;
        end if;
      
        begin
          update aqpb178 a
             set a.aqpb178tflu = 'P'
           where a.aqpb178fep = l.aqpb178fep
             and a.aqpb178cor = l.aqpb178cor
             and a.aqpb178pai = l.aqpb178pai
             and a.aqpb178tdo = l.aqpb178tdo
             and a.aqpb178ndo = l.aqpb178ndo
             and a.aqpb178mto = l.aqpb178mto
             and a.aqpb178tflu = 'N';
        end;
        commit;
      
      end if;
    end loop;
  
  end sp_cr_inicio;
  ---------------------------------------------------------------
  procedure sp_cr_tasasCredinka is
  
    cursor lista(ld_fecha date) is
      select a.aqpb178mod,
             (select p.pp028defn
                from fpp028 p
               where p.pp017par = 17
                 and p.pp028emp = 1
                 and p.pp028mod = a.aqpb178mod
                 and p.pp028top = a.aqpb178top
                 and p.pp028mda = a.aqpb178mda) pizarra,
             a.aqpb178cta,
             a.aqpb178mda,
             a.aqpb178fep,
             a.aqpb178mto,
             a.aqpb178tasa,
             (a.aqpb178fep + 5) FchVenc
        from aqpb178 a
       where a.aqpb178fep = ld_fecha
         and a.aqpb178tflu = 'N';
  
    ld_fecha    date;
    ln_dia      varchar2(2);
    ln_mes      varchar2(2);
    ln_anio     varchar2(4);
    FchInver    number;
    FchInverAux number;
  
  begin
  
    begin
      select max(a.aqpb178fep) into ld_fecha from aqpb178 a;
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(ld_fecha, 'DD') into ln_dia from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(ld_fecha, 'MM') into ln_mes from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(ld_fecha, 'YYYY') into ln_anio from dual;
    exception
      when others then
        null;
    end;
  
    FchInverAux := to_number(ln_anio || ln_mes || ln_dia);
  
    FchInver := 99999999 - FchInverAux;
  
    for l in lista(ld_fecha) loop
      begin
        insert into fsd027
          (pgcod,
           modulo,
           tpizar,
           ctnro,
           moneda,
           papel,
           tpfdes,
           tpmto,
           tpttas,
           tpfinv,
           tpvig)
        values
          (1,
           l.aqpb178mod,
           l.pizarra,
           l.aqpb178cta,
           l.aqpb178mda,
           0,
           ld_fecha,
           l.aqpb178mto,
           1,
           FchInver,
           'S');
      exception
        when others then
          null;
      end;
    
      begin
        insert into fsd327
          (vt1pgcod,
           vt1mod,
           vt1tpiz,
           vt1ctnr,
           vt1mon,
           vt1pap,
           vt1tpfd,
           vt1fchven)
        values
          (1,
           l.aqpb178mod,
           l.pizarra,
           l.aqpb178cta,
           l.aqpb178mda,
           0,
           ld_fecha,
           l.fchvenc);
      exception
        when others then
          null;
      end;
    
      begin
        insert into fsr027
          (pgcod,
           modulo,
           tpizar,
           ctnro,
           moneda,
           papel,
           tpfdes,
           tpmto,
           tppzo,
           tptasa)
        values
          (1,
           l.aqpb178mod,
           l.pizarra,
           l.aqpb178cta,
           l.aqpb178mda,
           0,
           ld_fecha,
           l.aqpb178mto,
           99999,
           l.aqpb178tasa);
      exception
        when others then
          null;
      end;
      commit;
    
    end loop;
  
  end sp_cr_tasasCredinka;
  ---------------------------------------------------------------
  procedure sp_Cr_RTE_update(ln_pgcodt in number,
                             ln_suct   in number,
                             ln_modt   in number,
                             ln_ttran  in number,
                             ln_relt   in number,
                             ln_ordt   in number) is
  
    ln_pgcod     number;
    ln_mod       number;
    ln_suc       number;
    ln_mda       number;
    ln_pap       number;
    ln_cta       number;
    ln_ope       number;
    ln_sub       number;
    ln_tope      number;
    ln_instancia number;
    ln_pais      number;
    ln_tdoc      number;
    lc_ndoc      varchar2(12);
    ld_FechVal   date;
    ln_MntDesem  number(17, 2) := 0.00;
    ln_tasa      number(10, 6) := 0.000;
    ln_NroCuotas number;
    ln_NroEval   number;
    ld_fch750    date;
    ln_reg750    number;
  
  begin
  
    if ln_modt < 500 then
      begin
        select f.pgcod,
               f.modulo,
               f.itsucd,
               f.moneda,
               f.papel,
               f.ctnro,
               f.itoper,
               f.itsubo,
               f.ittope,
               f.itfval
          into ln_pgcod,
               ln_mod,
               ln_suc,
               ln_mda,
               ln_pap,
               ln_cta,
               ln_ope,
               ln_sub,
               ln_tope,
               ld_FechVal
          from fsd016 f
         where f.pgcod = ln_pgcodt
           and f.itsuc = ln_suct
           and f.itmod = ln_modt
           and f.ittran = ln_ttran
           and f.itnrel = ln_relt
           and f.itord = ln_ordt;
      exception
        when others then
          null;
      end;
    
      ln_instancia := fn_instancia_credito(v_Scmod  => ln_mod,
                                           v_Scsuc  => ln_suc,
                                           v_Scmda  => ln_mda,
                                           v_Scpap  => ln_pap,
                                           v_Sccta  => ln_cta,
                                           v_Scoper => ln_ope,
                                           v_Scsbop => ln_sub,
                                           v_Sctope => ln_tope);
    
      begin
        select f.pepais, f.petdoc, f.pendoc
          into ln_pais, ln_tdoc, lc_ndoc
          from fsr008 f
         where f.pgcod = 1
           and f.ctnro = ln_cta
           and f.cttfir = 'T';
      exception
        when others then
          null;
      end;
    
      --lv_ndoc := trim(lc_ndoc);
    
      begin
        select s.xllcapital, s.xlltasap, s.xllcantcuo
          into ln_MntDesem, ln_tasa, ln_NroCuotas
          from xwf700 x, x054023 s
         where x.xwfempresa = s.xllpgcod
           and x.xwfsucursal = s.xllaosuc
           and x.xwfmodulo = s.xllaomod
           and x.xwfmoneda = s.xllaomda
           and x.xwfpapel = s.xllaopap
           and x.xwfcuenta = s.xllaocta
           and x.xwfoperacion = s.xllaooper
           and x.xwfsubope = s.xllaosbop
           and x.xwftipope = s.xllaotop
           and x.xwfprcins = ln_instancia
           and x.xwfcar3 = '1';
      exception
        when others then
          null;
      end;
    
      begin
        select s.sng021eval
          into ln_NroEval
          from sng021 s
         where s.sng021sol = ln_instancia;
      exception
        when others then
          null;
      end;
    
      begin
        select j.jaqm750fch, j.jaqm750reg
          into ld_fch750, ln_reg750
          from jaqm750 j
         where j.jaqm750ins = ln_instancia;
      exception
        when others then
          null;
      end;
    
      begin
        update aqpb178 a
           set a.aqpb178ins    = ln_instancia,
               a.aqpb178eva    = ln_NroEval,
               a.aqpb178pgtx   = ln_pgcodt,
               a.aqpb178modtx  = ln_modt,
               a.aqpb178suctx  = ln_suct,
               a.aqpb178tran   = ln_ttran,
               a.aqpb178reltx  = ln_relt,
               a.aqpb178fcontx = ld_FechVal,
               a.aqpb178pgcod  = ln_pgcod,
               a.aqpb178modcr  = ln_mod,
               a.aqpb178succr  = ln_suc,
               a.aqpb178mdacr  = ln_mda,
               a.aqpb178papcr  = ln_pap,
               a.aqpb178ctacr  = ln_cta,
               a.aqpb178opecr  = ln_ope,
               a.aqpb178sbopcr = ln_sub,
               a.aqpb178topecr = ln_tope,
               a.aqpb178tflu   = 'D',
               A.AQPB178FCH750 = ld_fch750,
               a.aqpb178reg750 = ln_reg750
         where a.aqpb178pai = ln_pais
           and a.aqpb178tdo = ln_tdoc
           and a.aqpb178cta = ln_cta
           and a.aqpb178mto = ln_MntDesem
           and a.aqpb178tasa = ln_tasa
           and a.aqpb178cuo = ln_NroCuotas
           and a.aqpb178tflu = 'P';
      end;
    
    end if;
  
  end sp_Cr_RTE_update;
  ---------------------------------------------------------------
  procedure sp_cr_InsrtAvales is
  
    cursor avales is
      select a.aqpb178ins,
             a.aqpb178auxn1,
             a.aqpb178auxn2,
             a.aqpb178auxn3,
             a.aqpb178auxn4,
             a.aqpb178auxn5
        from aqpb178 a
       where a.aqpb178tflu = 'D'
         and a.aqpb178ins > 0
         and a.aqpb178fcontx =
             (select f.pgfape from fst017 f where f.pgcod = 1)
         and a.aqpb178auxn1 > 0;
  
    ln_aval1 number;
    ln_aval2 number;
    ln_aval3 number;
    ln_aval4 number;
    ln_aval5 number;
  
  begin
  
    for a in avales loop
    
      ln_aval1 := nvl(a.aqpb178auxn1, 0);
      ln_aval2 := nvl(a.aqpb178auxn2, 0);
      ln_aval3 := nvl(a.aqpb178auxn3, 0);
      ln_aval4 := nvl(a.aqpb178auxn4, 0);
      ln_aval5 := nvl(a.aqpb178auxn5, 0);
    
      if ln_aval1 > 0 then
        begin
          insert into sng003
            (sng001inst, sng003pgc, sng003cta, sng003cor, sng003tpo)
          values
            (a.aqpb178ins, 1, ln_aval1, 0, 1);
        exception
          when others then
            null;
        end;
      end if;
    
      if ln_aval2 > 0 then
        begin
          insert into sng003
            (sng001inst, sng003pgc, sng003cta, sng003cor, sng003tpo)
          values
            (a.aqpb178ins, 1, ln_aval2, 0, 1);
        exception
          when others then
            null;
        end;
      end if;
    
      if ln_aval3 > 0 then
        begin
          insert into sng003
            (sng001inst, sng003pgc, sng003cta, sng003cor, sng003tpo)
          values
            (a.aqpb178ins, 1, ln_aval3, 0, 1);
        exception
          when others then
            null;
        end;
      end if;
    
      if ln_aval4 > 0 then
        begin
          insert into sng003
            (sng001inst, sng003pgc, sng003cta, sng003cor, sng003tpo)
          values
            (a.aqpb178ins, 1, ln_aval4, 0, 1);
        exception
          when others then
            null;
        end;
      end if;
    
      if ln_aval5 > 0 then
        begin
          insert into sng003
            (sng001inst, sng003pgc, sng003cta, sng003cor, sng003tpo)
          values
            (a.aqpb178ins, 1, ln_aval5, 0, 1);
        exception
          when others then
            null;
        end;
      end if;
      commit;
    end loop;
  
  end sp_cr_InsrtAvales;
  ---------------------------------------------------------------
  procedure sp_cr_GarantiasCdk is
  
    cursor lista_gar is
      select a.aqpb178ins,
             a.aqpb178fcontx,
             a.aqpb178pgtx,
             a.aqpb178modtx,
             a.aqpb178suctx,
             a.aqpb178tran,
             a.aqpb178reltx,
             a.aqpb178pgcod,
             a.aqpb178modcr,
             a.aqpb178succr,
             a.aqpb178mdacr,
             a.aqpb178papcr,
             a.aqpb178ctacr,
             a.aqpb178opecr,
             a.aqpb178sbopcr,
             a.aqpb178topecr,
             a.aqpb178pggar1,
             a.aqpb178modgar1,
             a.aqpb178sucgar1,
             a.aqpb178mdagar1,
             a.aqpb178papgar1,
             a.aqpb178ctagar1,
             a.aqpb178opegar1,
             a.aqpb178sbopgar1,
             a.aqpb178topegar1,
             a.aqpb178prcgar1,
             a.aqpb178pggar2,
             a.aqpb178modgar2,
             a.aqpb178sucgar2,
             a.aqpb178mdagar2,
             a.aqpb178papgar2,
             a.aqpb178ctagar2,
             a.aqpb178opegar2,
             a.aqpb178sbopgar2,
             a.aqpb178topegar2,
             a.aqpb178prcgar2,
             a.aqpb178pggar3,
             a.aqpb178modgar3,
             a.aqpb178sucgar3,
             a.aqpb178mdagar3,
             a.aqpb178papgar3,
             a.aqpb178ctagar3,
             a.aqpb178opegar3,
             a.aqpb178sbopgar3,
             a.aqpb178topegar3,
             a.aqpb178prcgar3
        from aqpb178 a
       where a.aqpb178tflu = 'D'
         and a.aqpb178pggar1 > 0
         and a.aqpb178fep = (select max(b.aqpb178fep) from aqpb178 b);
  
    ln_ordtx        number;
    ln_subortx      number;
    ln_MntGarantia  number(17, 2) := 0.00;
    ln_MntUtilGarnt number(17, 2) := 0.00;
    ln_SaldGarnt    number(17, 2) := 0.00;
    ln_PorcGarant   number(10, 6) := 0.000000;
    ln_TipCamb      number(10, 6) := 0.000000;
    ld_FchSist      date;
  
  begin
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    ln_TipCamb := fn_tipo_cambio_fijo(P_FECHA => ld_FchSist);
  
    for l in lista_gar loop
    
      begin
        delete sng122 s where s.sng122inst = l.aqpb178ins;
        delete fsr011 f
         where f.r1cod = l.aqpb178pgcod
           and f.r1mod = l.aqpb178modcr
           and f.r1suc = l.aqpb178succr
           and f.r1mda = l.aqpb178mdacr
           and f.r1pap = l.aqpb178papcr
           and f.r1cta = l.aqpb178ctacr
           and f.r1oper = l.aqpb178opecr
           and f.r1sbop = l.aqpb178sbopcr
           and f.r1tope = l.aqpb178topecr
           and f.relcod = 50;
        commit;
      
      end;
    
      if l.aqpb178pggar1 > 0 then
      
        begin
          select f.itord, f.itsbor
            into ln_ordtx, ln_subortx
            from fsd016 f
           where f.pgcod = l.aqpb178pgtx
             and f.itsuc = l.aqpb178suctx
             and f.itmod = l.aqpb178modtx
             and f.ittran = l.aqpb178tran
             and f.itnrel = l.aqpb178reltx
             and f.modulo = l.aqpb178modcr;
        exception
          when others then
            null;
        end;
      
        pq_cr_flujoexpress_credinka.sp_Cr_InsertFSR011(ln_codcr   => l.aqpb178pgcod,
                                                       ln_modcr   => l.aqpb178modcr,
                                                       ln_succr   => l.aqpb178succr,
                                                       ln_mdacr   => l.aqpb178mdacr,
                                                       ln_papcr   => l.aqpb178papcr,
                                                       ln_ctacr   => l.aqpb178ctacr,
                                                       ln_opercr  => l.aqpb178opecr,
                                                       ln_sbopcr  => l.aqpb178sbopcr,
                                                       ln_topecr  => l.aqpb178topecr,
                                                       ln_modgar  => l.aqpb178modgar1,
                                                       ln_ctagar  => l.aqpb178ctagar1,
                                                       ln_opergar => l.aqpb178opegar1,
                                                       ln_sbopgar => l.aqpb178sbopgar1,
                                                       ln_codgar  => l.aqpb178pggar1,
                                                       ln_sucgar  => l.aqpb178sucgar1,
                                                       ln_mdagar  => l.aqpb178mdagar1,
                                                       ln_papgar  => l.aqpb178papgar1,
                                                       ln_topegar => l.aqpb178topegar1,
                                                       ln_cdtx    => l.aqpb178pgtx,
                                                       ln_modtx   => l.aqpb178modtx,
                                                       ln_suctx   => l.aqpb178suctx,
                                                       ln_trtx    => l.aqpb178tran,
                                                       ln_retx    => l.aqpb178reltx,
                                                       ld_fctx    => l.aqpb178fcontx,
                                                       ln_ortx    => ln_ordtx,
                                                       ln_sbtx    => ln_subortx);
      
        Pq_Cr_Flujoexpress_Credinka.sp_cr_MontosSNG122(ln_instancia => l.aqpb178ins,
                                                       ln_pgcod     => l.aqpb178pggar1,
                                                       ln_mod       => l.aqpb178modgar1,
                                                       ln_suc       => l.aqpb178sucgar1,
                                                       ln_mda       => l.aqpb178mdagar1,
                                                       ln_pap       => l.aqpb178papgar1,
                                                       ln_cta       => l.aqpb178ctagar1,
                                                       ln_oper      => l.aqpb178opegar1,
                                                       ln_sbop      => l.aqpb178sbopgar1,
                                                       ln_tope      => l.aqpb178topegar1,
                                                       ln_poscn     => 1,
                                                       ln_mntgar    => ln_MntGarantia,
                                                       ln_mntcober  => ln_MntUtilGarnt,
                                                       ln_SaldGar   => ln_SaldGarnt,
                                                       ln_Porcober  => ln_PorcGarant);
      
        Pq_Cr_Flujoexpress_Credinka.sp_cr_InsertSNG122(ln_inst    => l.aqpb178ins,
                                                       ln_122corr => 1,
                                                       ln_122pgc  => l.aqpb178pggar1,
                                                       ln_122mod  => l.aqpb178modgar1,
                                                       ln_122suc  => l.aqpb178sucgar1,
                                                       ln_122mda  => l.aqpb178mdagar1,
                                                       ln_122pap  => l.aqpb178papgar1,
                                                       ln_122cta  => l.aqpb178ctagar1,
                                                       ln_122oper => l.aqpb178opegar1,
                                                       ln_122sbop => l.aqpb178sbopgar1,
                                                       ln_122tope => l.aqpb178topegar1,
                                                       ln_122pri  => 1,
                                                       ln_122sdog => ln_MntGarantia,
                                                       ln_122mtou => ln_MntUtilGarnt,
                                                       ld_122fape => l.aqpb178fcontx,
                                                       ln_122mtod => ln_SaldGarnt,
                                                       ln_122poco => ln_PorcGarant,
                                                       ln_122tcbi => ln_TipCamb);
      end if;
    
      if l.aqpb178pggar2 > 0 then
      
        begin
          select f.itord, f.itsbor
            into ln_ordtx, ln_subortx
            from fsd016 f
           where f.pgcod = l.aqpb178pgtx
             and f.itsuc = l.aqpb178suctx
             and f.itmod = l.aqpb178modtx
             and f.ittran = l.aqpb178tran
             and f.itnrel = l.aqpb178reltx
             and f.modulo = l.aqpb178modcr;
        exception
          when others then
            null;
        end;
      
        pq_cr_flujoexpress_credinka.sp_Cr_InsertFSR011(ln_codcr   => l.aqpb178pgcod,
                                                       ln_modcr   => l.aqpb178modcr,
                                                       ln_succr   => l.aqpb178succr,
                                                       ln_mdacr   => l.aqpb178mdacr,
                                                       ln_papcr   => l.aqpb178papcr,
                                                       ln_ctacr   => l.aqpb178ctacr,
                                                       ln_opercr  => l.aqpb178opecr,
                                                       ln_sbopcr  => l.aqpb178sbopcr,
                                                       ln_topecr  => l.aqpb178topecr,
                                                       ln_modgar  => l.aqpb178modgar2,
                                                       ln_ctagar  => l.aqpb178ctagar2,
                                                       ln_opergar => l.aqpb178opegar2,
                                                       ln_sbopgar => l.aqpb178sbopgar2,
                                                       ln_codgar  => l.aqpb178pggar2,
                                                       ln_sucgar  => l.aqpb178sucgar2,
                                                       ln_mdagar  => l.aqpb178mdagar2,
                                                       ln_papgar  => l.aqpb178papgar2,
                                                       ln_topegar => l.aqpb178topegar2,
                                                       ln_cdtx    => l.aqpb178pgtx,
                                                       ln_modtx   => l.aqpb178modtx,
                                                       ln_suctx   => l.aqpb178suctx,
                                                       ln_trtx    => l.aqpb178tran,
                                                       ln_retx    => l.aqpb178reltx,
                                                       ld_fctx    => l.aqpb178fcontx,
                                                       ln_ortx    => ln_ordtx,
                                                       ln_sbtx    => ln_subortx);
      
        Pq_Cr_Flujoexpress_Credinka.sp_cr_MontosSNG122(ln_instancia => l.aqpb178ins,
                                                       ln_pgcod     => l.aqpb178pggar2,
                                                       ln_mod       => l.aqpb178modgar2,
                                                       ln_suc       => l.aqpb178sucgar2,
                                                       ln_mda       => l.aqpb178mdagar2,
                                                       ln_pap       => l.aqpb178papgar2,
                                                       ln_cta       => l.aqpb178ctagar2,
                                                       ln_oper      => l.aqpb178opegar2,
                                                       ln_sbop      => l.aqpb178sbopgar2,
                                                       ln_tope      => l.aqpb178topegar2,
                                                       ln_poscn     => 2,
                                                       ln_mntgar    => ln_MntGarantia,
                                                       ln_mntcober  => ln_MntUtilGarnt,
                                                       ln_SaldGar   => ln_SaldGarnt,
                                                       ln_Porcober  => ln_PorcGarant);
      
        Pq_Cr_Flujoexpress_Credinka.sp_cr_InsertSNG122(ln_inst    => l.aqpb178ins,
                                                       ln_122corr => 2,
                                                       ln_122pgc  => l.aqpb178pggar2,
                                                       ln_122mod  => l.aqpb178modgar2,
                                                       ln_122suc  => l.aqpb178sucgar2,
                                                       ln_122mda  => l.aqpb178mdagar2,
                                                       ln_122pap  => l.aqpb178papgar2,
                                                       ln_122cta  => l.aqpb178ctagar2,
                                                       ln_122oper => l.aqpb178opegar2,
                                                       ln_122sbop => l.aqpb178sbopgar2,
                                                       ln_122tope => l.aqpb178topegar2,
                                                       ln_122pri  => 2,
                                                       ln_122sdog => ln_MntGarantia,
                                                       ln_122mtou => ln_MntUtilGarnt,
                                                       ld_122fape => l.aqpb178fcontx,
                                                       ln_122mtod => ln_SaldGarnt,
                                                       ln_122poco => ln_PorcGarant,
                                                       ln_122tcbi => ln_TipCamb);
      end if;
      if l.aqpb178pggar3 > 0 then
      
        begin
          select f.itord, f.itsbor
            into ln_ordtx, ln_subortx
            from fsd016 f
           where f.pgcod = l.aqpb178pgtx
             and f.itsuc = l.aqpb178suctx
             and f.itmod = l.aqpb178modtx
             and f.ittran = l.aqpb178tran
             and f.itnrel = l.aqpb178reltx
             and f.modulo = l.aqpb178modcr;
        exception
          when others then
            null;
        end;
      
        pq_cr_flujoexpress_credinka.sp_Cr_InsertFSR011(ln_codcr   => l.aqpb178pgcod,
                                                       ln_modcr   => l.aqpb178modcr,
                                                       ln_succr   => l.aqpb178succr,
                                                       ln_mdacr   => l.aqpb178mdacr,
                                                       ln_papcr   => l.aqpb178papcr,
                                                       ln_ctacr   => l.aqpb178ctacr,
                                                       ln_opercr  => l.aqpb178opecr,
                                                       ln_sbopcr  => l.aqpb178sbopcr,
                                                       ln_topecr  => l.aqpb178topecr,
                                                       ln_modgar  => l.aqpb178modgar3,
                                                       ln_ctagar  => l.aqpb178ctagar3,
                                                       ln_opergar => l.aqpb178opegar3,
                                                       ln_sbopgar => l.aqpb178sbopgar3,
                                                       ln_codgar  => l.aqpb178pggar3,
                                                       ln_sucgar  => l.aqpb178sucgar3,
                                                       ln_mdagar  => l.aqpb178mdagar3,
                                                       ln_papgar  => l.aqpb178papgar3,
                                                       ln_topegar => l.aqpb178topegar3,
                                                       ln_cdtx    => l.aqpb178pgtx,
                                                       ln_modtx   => l.aqpb178modtx,
                                                       ln_suctx   => l.aqpb178suctx,
                                                       ln_trtx    => l.aqpb178tran,
                                                       ln_retx    => l.aqpb178reltx,
                                                       ld_fctx    => l.aqpb178fcontx,
                                                       ln_ortx    => ln_ordtx,
                                                       ln_sbtx    => ln_subortx);
      
        Pq_Cr_Flujoexpress_Credinka.sp_cr_MontosSNG122(ln_instancia => l.aqpb178ins,
                                                       ln_pgcod     => l.aqpb178pggar3,
                                                       ln_mod       => l.aqpb178modgar3,
                                                       ln_suc       => l.aqpb178sucgar3,
                                                       ln_mda       => l.aqpb178mdagar3,
                                                       ln_pap       => l.aqpb178papgar3,
                                                       ln_cta       => l.aqpb178ctagar3,
                                                       ln_oper      => l.aqpb178opegar3,
                                                       ln_sbop      => l.aqpb178sbopgar3,
                                                       ln_tope      => l.aqpb178topegar3,
                                                       ln_poscn     => 3,
                                                       ln_mntgar    => ln_MntGarantia,
                                                       ln_mntcober  => ln_MntUtilGarnt,
                                                       ln_SaldGar   => ln_SaldGarnt,
                                                       ln_Porcober  => ln_PorcGarant);
      
        Pq_Cr_Flujoexpress_Credinka.sp_cr_InsertSNG122(ln_inst    => l.aqpb178ins,
                                                       ln_122corr => 3,
                                                       ln_122pgc  => l.aqpb178pggar3,
                                                       ln_122mod  => l.aqpb178modgar3,
                                                       ln_122suc  => l.aqpb178sucgar3,
                                                       ln_122mda  => l.aqpb178mdagar3,
                                                       ln_122pap  => l.aqpb178papgar3,
                                                       ln_122cta  => l.aqpb178ctagar3,
                                                       ln_122oper => l.aqpb178opegar3,
                                                       ln_122sbop => l.aqpb178sbopgar3,
                                                       ln_122tope => l.aqpb178topegar3,
                                                       ln_122pri  => 3,
                                                       ln_122sdog => ln_MntGarantia,
                                                       ln_122mtou => ln_MntUtilGarnt,
                                                       ld_122fape => l.aqpb178fcontx,
                                                       ln_122mtod => ln_SaldGarnt,
                                                       ln_122poco => ln_PorcGarant,
                                                       ln_122tcbi => ln_TipCamb);
      end if;
    
    end loop;
  
  end sp_cr_GarantiasCdk;
  ---------------------------------------------------------------
  procedure sp_cr_MontosSNG122(ln_instancia in number,
                               ln_pgcod     in number,
                               ln_mod       in number,
                               ln_suc       in number,
                               ln_mda       in number,
                               ln_pap       in number,
                               ln_cta       in number,
                               ln_oper      in number,
                               ln_sbop      in number,
                               ln_tope      in number,
                               ln_poscn     in number,
                               ln_mntgar    out number,
                               ln_mntcober  out number,
                               ln_SaldGar   out number,
                               ln_Porcober  out number) is
  
    ln_Coefcnt     number(10, 8) := 0.00000000;
    ln_MntDesem    number(17, 2) := 0.00;
    ln_Porcntg     number(10, 6) := 0.000000;
    ln_mntcoberAux number(17, 2) := 0.00;
    ln_MntGar1     number(17, 2) := 0.00;
    ln_MntGar2     number(17, 2) := 0.00;
    ld_FchSist     date;
    ln_mntgarAux   number(17, 2) := 0.00;
    ln_MdaOferta   number(17, 2) := 0.00;
    ln_TipoCamb    number(14, 6) := 0.00;
  
  begin
  
    begin
      select f.scsdo
        into ln_mntgar
        from fsd011 f
       where f.pgcod = ln_pgcod
         and f.scsuc = ln_suc
         and f.scmda = ln_mda
         and f.scpap = ln_pap
         and f.sccta = ln_cta
         and f.scoper = ln_oper
         and f.scsbop = ln_sbop
         and f.sctope = ln_tope
         and f.scmod = ln_mod;
    exception
      when others then
        ln_mntgar := 0;
    end;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    ln_TipoCamb := fn_tipo_cambio_fijo(P_FECHA => ld_FchSist);
  
    if ln_poscn = 1 then
    
      begin
        select a.aqpb178mto, a.aqpb178prcgar1, a.aqpb178mda
          into ln_MntDesem, ln_Porcntg, ln_MdaOferta
          from aqpb178 a
         where a.aqpb178ins = ln_instancia
           and a.aqpb178tflu = 'D';
      exception
        when others then
          ln_MntDesem := 0.00;
          ln_Porcntg  := 1;
      end;
    
      ln_Coefcnt     := 100 / ln_Porcntg;
      ln_Porcober    := 100 * ln_Coefcnt;
      ln_mntcoberAux := ln_Coefcnt * ln_MntDesem;
    
      if ln_mda = 101 and ln_MdaOferta = 0 then
        ln_mntgarAux := ln_mntgar * ln_TipoCamb;
      else
        if ln_mda = 0 and ln_MdaOferta = 0 then
          ln_mntgarAux := ln_mntgar;
        end if;
      end if;
    
      if ln_mntcoberAux <= ln_mntgarAux then
        ln_mntcober := ln_mntcoberAux;
      else
        if ln_mntcoberAux > ln_mntgarAux then
          ln_mntcober := ln_mntgarAux;
        end if;
      end if;
    
      ln_SaldGar := ln_mntgarAux - ln_mntcober;
      --   ln_mntgar:=ln_mntgarAux;
    
    else
      if ln_poscn = 2 then
      
        begin
          select a.aqpb178mto, a.aqpb178prcgar2, a.aqpb178mda
            into ln_MntDesem, ln_Porcntg, ln_MdaOferta
            from aqpb178 a
           where a.aqpb178ins = ln_instancia
             and a.aqpb178tflu = 'D';
        exception
          when others then
            ln_MntDesem := 0.00;
            ln_Porcntg  := 1;
        end;
      
        ln_Coefcnt     := 100 / ln_Porcntg;
        ln_Porcober    := 100 * ln_Coefcnt;
        ln_mntcoberAux := ln_Coefcnt * ln_MntDesem;
      
        if ln_mda = 101 and ln_MdaOferta = 0 then
          ln_mntgarAux := ln_mntgar * ln_TipoCamb;
        else
          if ln_mda = 0 and ln_MdaOferta = 0 then
            ln_mntgarAux := ln_mntgar;
          end if;
        end if;
      
        begin
          select s.sng122mtou
            into ln_MntGar1
            from sng122 s
           where s.sng122inst = ln_instancia
             and s.sng122corr = 1;
        exception
          when others then
            ln_MntGar1 := 0;
        end;
      
        ln_mntcober := nvl(ln_mntcoberAux, 0) - nvl(ln_MntGar1, 0);
      
        if ln_mntcober <= ln_mntgarAux then
          ln_mntcober := ln_mntcober;
        else
          if ln_mntcoberAux > ln_mntgarAux then
            ln_mntcober := ln_mntgarAux;
          end if;
        end if;
      
        ln_SaldGar := ln_mntgarAux - ln_mntcober;
        --  ln_mntgar:=ln_mntgarAux;
      
      else
        if ln_poscn = 3 then
        
          begin
            select a.aqpb178mto, a.aqpb178prcgar2, a.aqpb178mda
              into ln_MntDesem, ln_Porcntg, ln_MdaOferta
              from aqpb178 a
             where a.aqpb178ins = ln_instancia
               and a.aqpb178tflu = 'D';
          exception
            when others then
              ln_MntDesem := 0.00;
              ln_Porcntg  := 1;
          end;
        
          ln_Coefcnt     := 100 / ln_Porcntg;
          ln_Porcober    := 100 * ln_Coefcnt;
          ln_mntcoberAux := ln_Coefcnt * ln_MntDesem;
        
          if ln_mda = 101 and ln_MdaOferta = 0 then
            ln_mntgarAux := ln_mntgar * ln_TipoCamb;
          else
            if ln_mda = 0 and ln_MdaOferta = 0 then
              ln_mntgarAux := ln_mntgar;
            end if;
          end if;
        
          begin
            select sum(s.sng122mtou)
              into ln_MntGar2
              from sng122 s
             where s.sng122inst = ln_instancia
               and s.sng122corr in (1, 2);
          exception
            when others then
              ln_MntGar2 := 0;
          end;
        
          ln_mntcober := nvl(ln_mntcoberAux, 0) - nvl(ln_MntGar2, 0);
        
          if ln_mntcober <= ln_mntgarAux then
            ln_mntcober := ln_mntcober;
          else
            if ln_mntcoberAux > ln_mntgarAux then
              ln_mntcober := ln_mntgarAux;
            end if;
          end if;
        
          ln_SaldGar := ln_mntgarAux - ln_mntcober;
          --  ln_mntgar:=ln_mntgarAux;
        
        end if;
      end if;
    end if;
  
  end sp_cr_MontosSNG122;
  ---------------------------------------------------------------
  procedure sp_Cr_InsertFSR011(ln_codcr   in number,
                               ln_modcr   in number,
                               ln_succr   in number,
                               ln_mdacr   in number,
                               ln_papcr   in number,
                               ln_ctacr   in number,
                               ln_opercr  in number,
                               ln_sbopcr  in number,
                               ln_topecr  in number,
                               ln_modgar  in number,
                               ln_ctagar  in number,
                               ln_opergar in number,
                               ln_sbopgar in number,
                               ln_codgar  in number,
                               ln_sucgar  in number,
                               ln_mdagar  in number,
                               ln_papgar  in number,
                               ln_topegar in number,
                               ln_cdtx    in number,
                               ln_modtx   in number,
                               ln_suctx   in number,
                               ln_trtx    in number,
                               ln_retx    in number,
                               ld_fctx    in date,
                               ln_ortx    in number,
                               ln_sbtx    in number) is
  begin
  
    begin
      insert into fsr011
        (r1cod,
         r1mod,
         r1suc,
         r1mda,
         r1pap,
         r1cta,
         r1oper,
         r1sbop,
         r1tope,
         relcod,
         r2mod,
         r2cta,
         r2oper,
         r2sbop,
         r1rub,
         r2cod,
         r2suc,
         r2mda,
         r2pap,
         r2tope,
         r2rub,
         r011cd,
         r011mo,
         r011su,
         r011tr,
         r011re,
         r011fc,
         r011or,
         r011sb,
         r011co)
      values
        (ln_codcr,
         ln_modcr,
         ln_succr,
         ln_mdacr,
         ln_papcr,
         ln_ctacr,
         ln_opercr,
         ln_sbopcr,
         ln_topecr,
         50,
         ln_modgar,
         ln_ctagar,
         ln_opergar,
         ln_sbopgar,
         0,
         ln_codgar,
         ln_sucgar,
         ln_mdagar,
         ln_papgar,
         ln_topegar,
         0,
         ln_cdtx,
         ln_modtx,
         ln_suctx,
         ln_trtx,
         ln_retx,
         ld_fctx,
         ln_ortx,
         ln_sbtx,
         'S');
    exception
      when others then
        null;
    end;
    commit;
  end sp_Cr_InsertFSR011;
  ---------------------------------------------------------------
  procedure sp_cr_InsertSNG122(ln_inst    in number,
                               ln_122corr in number,
                               ln_122pgc  in number,
                               ln_122mod  in number,
                               ln_122suc  in number,
                               ln_122mda  in number,
                               ln_122pap  in number,
                               ln_122cta  in number,
                               ln_122oper in number,
                               ln_122sbop in number,
                               ln_122tope in number,
                               ln_122pri  in number,
                               ln_122sdog in number,
                               ln_122mtou in number,
                               ld_122fape in date,
                               ln_122mtod in number,
                               ln_122poco in number,
                               ln_122tcbi in number) is
  
  begin
  
    begin
      insert into sng122
        (sng122inst,
         sng122corr,
         sng122pgc,
         sng122mod,
         sng122suc,
         sng122mda,
         sng122pap,
         sng122cta,
         sng122oper,
         sng122sbop,
         sng122tope,
         sng122pri,
         sng122sdog,
         sng122mtou,
         sng122fape,
         sng122mtod,
         sng122poco,
         sng122tcbi)
      values
        (ln_inst,
         ln_122corr,
         ln_122pgc,
         ln_122mod,
         ln_122suc,
         ln_122mda,
         ln_122pap,
         ln_122cta,
         ln_122oper,
         ln_122sbop,
         ln_122tope,
         ln_122pri,
         ln_122sdog,
         ln_122mtou,
         ld_122fape,
         ln_122mtod,
         ln_122poco,
         ln_122tcbi);
      commit;
    exception
      when others then
        null;
    end;
  
  end sp_cr_InsertSNG122;
  ---------------------------------------------------------------------------------
end PQ_CR_FLUJOEXPRESS_CREDINKA;
/

