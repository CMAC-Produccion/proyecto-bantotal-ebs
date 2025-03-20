create or replace package PQ_CR_ReprogramacionCreditos is

  -- Author  : MPOSTIGOC
  -- Created : 02/12/2015 05:45:20 p.m.
  -- Purpose : 

  procedure sp_cr_cargadatos(fecinicio in date, fecfin in date);

  -------------------------------------------------------
  procedure sp_cr_cargadatosuc(sucursal  in number,
                               fecinicio in date,
                               fecfin    in date);

  -------------------------------------------------------
  procedure sp_cr_datoscliente(cuenta    in number,
                               operacion in number,
                               sucursal  in number);
  -------------------------------------------------------------
  procedure sp_cr_instoriginal(instrepro     in number,
                               cuenta        in number,
                               operacion     in number,
                               sucursal      in number,
                               modulo        in number,
                               suboperacion  in number,
                               tipooperacion in number,
                               instori       out number);
  --------------------------------------------------------------
  procedure sp_cr_clasificacion(P_N_RI105SUC  in number,
                                P_N_RI105MOD  in number,
                                P_N_RI105MDA  in number,
                                P_N_RI105PAP  in number,
                                P_N_RI105CTA  in number,
                                P_N_RI105OPER in number,
                                P_N_RI105SBOP in number,
                                P_N_RI105TOPE in number);

  -----------------------------------------------------------------------
  Procedure sp_cr_DiaAtr_Ultima(pn_emp   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_Sbo   in number,
                                pn_top   in number,
                                pd_fecha in date);

  -------------------------------------------------------------------------

  procedure sp_cr_comentario(INSTANCIA in number);

  ------------------------------------------------------------------------
  procedure sp_cr_categoria(pn_emp    in number,
                            pn_cta    in number,
                            pd_feccat in date);
  ----------------------------------------------------------------------------
  procedure sp_cr_indicador(INSTANCIA in number);
  -------------------------------------------------------------------------------------
  procedure sp_cr_saldocapital(cuenta       in number,
                               operacion    in number,
                               sucursal     in number,
                               moneda       in number,
                               papel        in number,
                               soboperacion in number,
                               modulo       in number);
  -----------------------------------------------------------------------------
  procedure sp_cr_nrocuotas(cuenta       in number,
                            operacion    in number,
                            sucursal     in number,
                            moneda       in number,
                            papel        in number,
                            soboperacion in number,
                            modulo       in number,
                            fechreprog   in date);
  -----------------------------------------------------------------------
  procedure sp_cr_nroreprog(cuenta    in number,
                            operacion in number,
                            sucursal  in number,
                            moneda    in number,
                            papel     in number,
                            modulo    in number);
  -----------------------------------------------------------------------
  procedure sp_cr_plazoreprog(cuenta       in number,
                              operacion    in number,
                              sucursal     in number,
                              moneda       in number,
                              papel        in number,
                              soboperacion in number,
                              modulo       in number);
  -----------------------------------------------------------------------
  procedure sp_cr_credvig(cuenta in number, operacion in number);
  -------------------------------------------------------------------------
  procedure sp_cr_credaprob(cuenta    in number,
                            operacion in number,
                            fecha     in date);
  --------------------------------------------------------------------------------------
  procedure sp_cr_ingnetodesrep(pn_instancia in number);
  --------------------------------------------------------------------------------------
  procedure sp_cr_ingnetoantrep(pn_instancia in number);

  -----------------------------------------------------------------------
  procedure sp_cr_cargatotalsuc(sucursal  in number,
                                fecinicio in date,
                                fecfin    in date);
  ------------------------------------------------------------------------
  --procedure sp_cr_cargasuc(ld_fecfin in date,P_N_INI in NUMBER, P_N_FIN in NUMBER);
  -------------------------------------------------------------------------
  procedure sp_cr_cargatotal(fecinicio in date, fecfin in date);
  -------------------------------------------------------------------------
-- procedure sp_cr_job_cargasuc(ld_fecfin in VARCHAR2);

end PQ_CR_ReprogramacionCreditos;
/

create or replace package body PQ_CR_ReprogramacionCreditos is

  procedure sp_cr_cargadatos(fecinicio in date, fecfin in date) is
  
    cursor inserta is
      select f11.r1cod    PGCODREPRO,
             F11.R1MOD    MODREPRO,
             F11.R1SUC    SUCREPRO,
             F11.R1MDA    MDAREPRO,
             F11.R1PAP    PAPREPRO,
             F11.R1CTA    CTAREPRO,
             F11.R1OPER   OPEREPRO,
             F11.R1SBOP   SBOPREPRO,
             F11.R1TOPE   TOPEREPRO,
             F11.R2COD    PGCODORIG,
             F11.R2MOD    MODORIG,
             F11.R2SUC    SUCORIG,
             F11.R2MDA    MDAORIG,
             F11.R2PAP    PAPORIG,
             F11.R2CTA    CTAORIG,
             F11.R2OPER   OPERORIG,
             F11.R2SBOP   SOBORIG,
             F11.R2TOPE   TOPEORIG,
             f10.aofval   FECHREP,
             x70.xwfprcin INSTANCIA
      --s65.sng065com COMENTARIO
        from fsd010 f10
        join xwf700 x on X.XWFEMPRESA = f10.pgcod
                     and x.xwfsucursal = f10.aosuc
                     and x.xwfmodulo = f10.aomod
                     and x.xwfmoneda = f10.aomda
                     and x.xwfpapel = f10.aopap
                     and x.xwfcuenta = f10.aocta
                     and x.xwfoperacion = f10.aooper
                     and x.xwfsubope = f10.aosbop
      /* and x.xwfprcins =
                               (select max(xwfprcins)
                                  from xwf700 xx
                                 where xX.XWFEMPRESA = f10.pgcod
                                   and xx.xwfsucursal = f10.aosuc
                                   and xx.xwfmodulo = f10.aomod
                                   and xx.xwfmoneda = f10.aomda
                                   and xx.xwfpapel = f10.aopap
                                   and xx.xwfcuenta = f10.aocta
                                   and xx.xwfoperacion = f10.aooper
                                   and xx.xwfsubope = f10.aosbop)*/
        join sng001 s1 on s1.sng001inst = x.xwfprcins
                      and s1.sng001emp = x.xwfempresa
                      and s1.sng001cta = x.xwfcuenta
        join fsr011 f11 on f11.r2mod = f10.aomod
                       and f11.r2cta = f10.aocta
                       and f11.r2oper = f10.aooper
                       and f11.r2mda = f10.aomda
                       and f11.r2suc = f10.aosuc
                       and f11.r2pap = f10.aopap
                       and f11.relcod in (860, 870, 890)
        join xwf070 x70 on x70.xwfpgcod = f10.pgcod
                       and x70.xwfprcin = x.xwfprcins
      
       where x.xwfcar3 = '1'
         and x.xwfmodulo in (select MODULO
                               from fst111
                              Where Dscod = 50
                                and Modulo <> 29
                                and Modulo <> 120
                                and Modulo <> 144)
         and s1.sng001ori in (13, 14, 16)
            --and f10.aosuc = sucursal
         and f10.aofval >= fecinicio
         and f10.aofval <= fecfin
         and X.XWFEMPRESA = f10.pgcod
         and x.xwfsucursal = f10.aosuc
         and x.xwfmoneda = f10.aomda
         and x.xwfpapel = f10.aopap
         and x.xwfcuenta = f10.aocta
         and x.xwfoperacion = f10.aooper
         and x.xwfprcins = (select max(xwfprcins)
                              from xwf700 xx
                             where xX.XWFEMPRESA = f10.pgcod
                               and xx.xwfsucursal = f10.aosuc
                               and xx.xwfmodulo = f10.aomod
                               and xx.xwfmoneda = f10.aomda
                               and xx.xwfpapel = f10.aopap
                               and xx.xwfcuenta = f10.aocta
                               and xx.xwfoperacion = f10.aooper
                               and xx.xwfsubope = f10.aosbop);

    --and f10.aostat = 99;
  
    ln_corr number := 1;
  begin
    execute immediate ('truncate table jaqy138');
    COMMIT;
  
    for i in inserta loop
      insert into jaqy138
        (jaqy138corr,
         jaqy138pgcodrep,
         jaqy138modrep,
         jaqy138sucrep,
         jaqy138mdarep,
         jaqy138paprep,
         jaqy138ctarep,
         jaqy138operep,
         jaqy138sboprep,
         jaqy138toprep,
         jaqy138pgcodori,
         jaqy138modori,
         jaqy138sucori,
         jaqy138mdaori,
         jaqy138papori,
         jaqy138ctaori,
         jaqy138operori,
         jaqy138sobori,
         jaqy138topori,
         jaqy138fecrep,
         jaqy138instrep)
      values
        (ln_corr,
         i.pgcodrepro,
         i.modrepro,
         i.sucrepro,
         i.mdarepro,
         i.paprepro,
         i.ctarepro,
         i.operepro,
         i.sboprepro,
         i.toperepro,
         i.pgcodorig,
         i.modorig,
         i.sucorig,
         i.mdaorig,
         i.paporig,
         i.ctaorig,
         i.operorig,
         i.soborig,
         i.topeorig,
         i.FECHREP,
         i.instancia);
    
      ln_corr := ln_corr + 1;
      COMMIT;
    end loop;
  
  end sp_cr_cargadatos;
  -----------------------------------------------------------------------------------
  procedure sp_cr_cargadatosuc(sucursal  in number,
                               fecinicio in date,
                               fecfin    in date) is
  
    cursor inserta is
      select f11.r1cod    PGCODREPRO,
             F11.R1MOD    MODREPRO,
             F11.R1SUC    SUCREPRO,
             F11.R1MDA    MDAREPRO,
             F11.R1PAP    PAPREPRO,
             F11.R1CTA    CTAREPRO,
             F11.R1OPER   OPEREPRO,
             F11.R1SBOP   SBOPREPRO,
             F11.R1TOPE   TOPEREPRO,
             F11.R2COD    PGCODORIG,
             F11.R2MOD    MODORIG,
             F11.R2SUC    SUCORIG,
             F11.R2MDA    MDAORIG,
             F11.R2PAP    PAPORIG,
             F11.R2CTA    CTAORIG,
             F11.R2OPER   OPERORIG,
             F11.R2SBOP   SOBORIG,
             F11.R2TOPE   TOPEORIG,
             f10.aofval   FECHREP,
             x70.xwfprcin INSTANCIA
      --s65.sng065com COMENTARIO
        from fsd010 f10
        join xwf700 x on X.XWFEMPRESA = f10.pgcod
                     and x.xwfsucursal = f10.aosuc
                     and x.xwfmodulo = f10.aomod
                     and x.xwfmoneda = f10.aomda
                     and x.xwfpapel = f10.aopap
                     and x.xwfcuenta = f10.aocta
                     and x.xwfoperacion = f10.aooper
      --and x.xwfsubope = f10.aosbop
        join sng001 s1 on s1.sng001inst = x.xwfprcins
                      and s1.sng001emp = x.xwfempresa
                      and s1.sng001cta = x.xwfcuenta
        join fsr011 f11 on f11.r2mod = f10.aomod
                       and f11.r2cta = f10.aocta
                       and f11.r2oper = f10.aooper
                       and f11.r2mda = f10.aomda
                       and f11.r2suc = f10.aosuc
                       and f11.r2pap = f10.aopap
                       and f11.relcod in (860, 870, 890)
        join xwf070 x70 on x70.xwfpgcod = f10.pgcod
                       and x70.xwfprcin = x.xwfprcins
      
       where x.xwfcar3 = '1'
         and x.xwfmodulo in (select MODULO
                               from fst111
                              Where Dscod = 50
                                and Modulo <> 29
                                and Modulo <> 120
                                and Modulo <> 144)
         and s1.sng001ori in (13, 14, 16)
         and f10.aosuc = sucursal
         and f10.aofval >= fecinicio
         and f10.aofval <= fecfin
         and X.XWFEMPRESA = f10.pgcod
         and x.xwfsucursal = f10.aosuc
         and x.xwfmoneda = f10.aomda
         and x.xwfpapel = f10.aopap
         and x.xwfcuenta = f10.aocta
         and x.xwfoperacion = f10.aooper
          and x.xwfprcins = (select max(xwfprcins)
                              from xwf700 xx
                             where xX.XWFEMPRESA = f10.pgcod
                               and xx.xwfsucursal = f10.aosuc
                               and xx.xwfmodulo = f10.aomod
                               and xx.xwfmoneda = f10.aomda
                               and xx.xwfpapel = f10.aopap
                               and xx.xwfcuenta = f10.aocta
                               and xx.xwfoperacion = f10.aooper
                               and xx.xwfsubope = f10.aosbop);
    --and f10.aostat = 99;
  
    ln_corr number := 1;
  begin
    execute immediate ('truncate table jaqy138');
    COMMIT;
  
    for i in inserta loop
      insert into jaqy138
        (jaqy138corr,
         jaqy138pgcodrep,
         jaqy138modrep,
         jaqy138sucrep,
         jaqy138mdarep,
         jaqy138paprep,
         jaqy138ctarep,
         jaqy138operep,
         jaqy138sboprep,
         jaqy138toprep,
         jaqy138pgcodori,
         jaqy138modori,
         jaqy138sucori,
         jaqy138mdaori,
         jaqy138papori,
         jaqy138ctaori,
         jaqy138operori,
         jaqy138sobori,
         jaqy138topori,
         jaqy138fecrep,
         jaqy138instrep)
      values
        (ln_corr,
         i.pgcodrepro,
         i.modrepro,
         i.sucrepro,
         i.mdarepro,
         i.paprepro,
         i.ctarepro,
         i.operepro,
         i.sboprepro,
         i.toperepro,
         i.pgcodorig,
         i.modorig,
         i.sucorig,
         i.mdaorig,
         i.paporig,
         i.ctaorig,
         i.operorig,
         i.soborig,
         i.topeorig,
         i.FECHREP,
         i.instancia);
    
      ln_corr := ln_corr + 1;
      COMMIT;
    end loop;
  
  end sp_cr_cargadatosuc;
  ----------------------------------------------------------------------------------
  procedure sp_cr_datoscliente(cuenta    in number,
                               operacion in number,
                               sucursal  in number) is
  
    TipoDoc   number(4);
    NroDoc    character(12);
    pais      number(4);
    nombre    varchar2(100);
    documento varchar2(50);
    lc_nomreg varchar2(100);
    ln_codreg number(4);
    nomsuc    character(30);
    --nomzon character(40);
    zona    number(4);
    nomzona character(40);
  
  begin
  
    begin
      select f8.petdoc, f8.pepais, f8.pendoc
        into TipoDoc, pais, NroDoc
        from fsr008 f8
       where f8.ctnro = cuenta
         and f8.ttcod = 1
         and f8.cttfir = 'T';
    exception
      when others then
        NULL;
    end;
  
    BEGIN
      -- nombre del cliente
    
      select ctnom --Nom_Cliente
        into nombre
        from fsd008 d
       where d.pgcod = 1
         and d.ctnro = CUENTA;
    exception
      when others then
        NULL;
    end;
  
    begin
      select f14.tdnom
        into documento
        from fst014 f14
       where f14.tdocum = TipoDoc;
    exception
      when others then
        NULL;
    end;
  
    BEGIN
      select f.scnom into nomsuc from fst001 f where f.sucurs = sucursal;
    end;
  
    begin
    
      select distinct f.tp1desc, f.tp1nro1, t81.regcod, t81.regnom
        into lc_nomreg, ln_codreg, zona, nomzona
        from fst810 t81, fst811 t80, fst198 f
       where t80.pgcod = t81.pgcod
         and t80.regcod = t81.regcod
         and t81.regcod = f.tp1nro2
         and tp1cod = 1
         and tp1cod1 = 10872
         and tp1corr1 = 11
         and t81.regcod < 100
         and t80.regcod < 100
         and t80.oficod = sucursal;
    exception
      when others then
        ln_codreg := 0;
    end;
  
    update jaqy138 j
       set j.jaqy138cliente = nombre,
           j.jaqy138tdoc    = documento,
           j.jaqy138nrodoc  = NroDoc,
           j.jaqy138region  = ln_codreg,
           j.jaqy138nomreg  = lc_nomreg,
           j.jaqy138suc     = nomsuc,
           j.jaqy138zona    = zona,
           j.jaqy138nomzon  = nomzona
     where j.jaqy138ctarep = cuenta
       and j.jaqy138operep = operacion
       and j.jaqy138sucrep = sucursal;
  
  end sp_cr_datoscliente;
  ------------------------------------------------------------------------------------
  procedure sp_cr_instoriginal(instrepro     in number,
                               cuenta        in number,
                               operacion     in number,
                               sucursal      in number,
                               modulo        in number,
                               suboperacion  in number,
                               tipooperacion in number,
                               instori       out number) is
  
  begin
  
    begin
      select x.xwfprcins
        into instori
        from xwf700 x
       where x.xwfempresa = 1
         and x.xwfsucursal = sucursal
         and x.xwfmodulo = modulo
         and x.xwfcuenta = cuenta
         and x.xwfoperacion = operacion
         and x.xwfsubope = suboperacion
         and x.xwftipope = tipooperacion;
    exception
      when others then
        NULL;
    end;
  
    update jaqy138 j
       set j.jaqy138instori = instori
     where j.jaqy138instrep = instrepro;
  
  end sp_cr_instoriginal;

  ------------------------------------------------------------------------------------
  procedure sp_cr_clasificacion(P_N_RI105SUC  in number,
                                P_N_RI105MOD  in number,
                                P_N_RI105MDA  in number,
                                P_N_RI105PAP  in number,
                                P_N_RI105CTA  in number,
                                P_N_RI105OPER in number,
                                P_N_RI105SBOP in number,
                                P_N_RI105TOPE in number) is
  
    P_N_CALF  number(4);
    P_N_DCALF varchar2(25);
  
  begin
    begin
      select f.ri105cat
        into P_N_CALF
        from fri105 f
       Where f.ri105cod = 1
         and f.ri105suc = P_N_RI105SUC
         and f.ri105mod = P_N_RI105MOD
         and f.ri105mda = P_N_RI105MDA
         and f.ri105pap = P_N_RI105PAP
         and f.ri105cta = P_N_RI105CTA
         and f.ri105oper = P_N_RI105OPER
         and f.ri105sbop = P_N_RI105SBOP
         and f.ri105tope = P_N_RI105TOPE;
    exception
      when no_data_found then
        null;
      when others then
        NULL;
    end;
  
    if P_N_CALF = 1 then
      P_N_DCALF := 'Normal';
    elsif P_N_CALF = 2 then
      P_N_DCALF := 'C.P.P';
    elsif P_N_CALF = 3 then
      P_N_DCALF := 'Deficiente';
    elsif P_N_CALF = 4 then
      P_N_DCALF := 'Dudoso';
    elsif P_N_CALF = 5 then
      P_N_DCALF := 'Perdida';
    end if;
  
    update jaqy138 j
       set j.JAQY138CLADREPG = P_N_DCALF
     where j.jaqy138ctarep = P_N_RI105CTA
       and j.jaqy138operep = P_N_RI105OPER
       and j.jaqy138sucrep = P_N_RI105SUC;
  
  end sp_cr_clasificacion;
  --------------------------------------------------------------------------------------

  Procedure sp_cr_DiaAtr_Ultima(pn_emp   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_Sbo   in number,
                                pn_top   in number,
                                pd_fecha in date) is
    --ld_ultfec date;
  
    ln_atrult number;
    fecha601  date;
  
  begin
    begin
      select max(pp1fech) - max(ppfpag)
        into ln_atrult
        from fsd602 d602
       where d602.pgcod = pn_emp
         and d602.ppmod = pn_mod
         and d602.ppsuc = pn_suc
         and d602.ppmda = pn_mda
         and d602.pppap = pn_pap
         and d602.ppcta = pn_cta
         and d602.ppoper = pn_ope
         and d602.ppsbop = pn_Sbo
         and d602.pptope = pn_top
         and d602.pp1fech < pd_fecha;
    exception
      when others then
        NULL;
    end;
  
    if ln_atrult is null then
      begin
        select min(ppfpag)
          into fecha601
          from fsd601 f1
         where f1.pgcod = pn_emp
           and f1.ppmod = pn_mod
           and f1.ppsuc = pn_suc
           and f1.ppmda = pn_mda
           and f1.pppap = pn_pap
           and f1.ppcta = pn_cta
           and f1.ppoper = pn_ope
           and f1.ppsbop = pn_Sbo
           and f1.pptope = pn_top;
      exception
        when others then
          NULL;
      end;
    
      ln_atrult := pd_fecha - fecha601;
    
    end if;
  
    update jaqy138 j
       set j.jaqy138dauc = ln_atrult
     where j.jaqy138ctarep = pn_cta
       and j.jaqy138operep = pn_ope
       and j.jaqy138sucrep = pn_suc;
  
  end sp_cr_DiaAtr_Ultima;

  -------------------------------------------------------------------------------------
  procedure sp_cr_comentario(INSTANCIA in number) is
  
    COMENTARIO varchar2(400);
    USUDESBLOQ CHARACTER(10);
  
  begin
  
    begin
    
      select s65.sng065com, s65.sng065usr
        into COMENTARIO, USUDESBLOQ
        from sng091 s91
       inner join jaqy138 y on y.jaqy138instrep = s91.sng001inst
       inner join sng001 s01 on s91.sng001inst = s01.sng001inst
                            and s91.sng091res in ('A', 'R')
                            and s91.sng091num = 154
                            and s91.sng091tpo = 'P'
       inner join sng065 s65 on s65.sng062aut = s91.sng091aut
       where y.jaqy138instori = INSTANCIA;
    
    exception
      when others then
        NULL;
    end;
    update jaqy138 j
       set j.jaqy138comn = COMENTARIO, j.jaqy138usudesb = USUDESBLOQ
     where j.jaqy138instori = INSTANCIA;
    commit;
  
  end sp_cr_comentario;
  -------------------------------------------------------------------------------------
  procedure sp_cr_categoria(pn_emp    in number,
                            pn_cta    in number,
                            pd_feccat in date) is
    lc_categoria varchar2(20);
  begin
    begin
      select l.catcateg
        into lc_categoria
        from fsd212 l
       where l.pgcod = pn_emp
         and l.catcta = pn_cta
         and l.catcod = 4 ---siempre es 4
         and l.catfchdes = (select max(catfchdes)
                              from fsd212 f
                             where f.catcta = pn_cta
                               and f.catfchdes <= pd_feccat);
    exception
      when no_data_found then
        lc_categoria := null;
      when too_many_rows then
        lc_categoria := null;
    end;
  
    update jaqy138 j
       set j.jaqy138clddrepg = lc_categoria
     where j.jaqy138pgcodrep = pn_emp
       and j.jaqy138ctarep = pn_cta;
  end sp_cr_categoria;

  --------------------------------------------------------------------------------------

  procedure sp_cr_indicador(INSTANCIA in number) is
  
    indicador varchar2(3);
  
    COMENTARIO varchar2(400);
    USUDESBLOQ CHARACTER(10);
  
  begin
  
    begin
    
      select s65.sng065com, s65.sng065usr
        into COMENTARIO, USUDESBLOQ
        from sng091 s91
       inner join jaqy138 y on y.jaqy138instori = s91.sng001inst
       inner join sng001 s01 on s91.sng001inst = s01.sng001inst
                            and s91.sng091res in ('A', 'R')
                            and s91.sng091num = 154
                            and s91.sng091tpo = 'P'
       inner join sng065 s65 on s65.sng062aut = s91.sng091aut
       where y.jaqy138instori = INSTANCIA;
    exception
      when others then
        NULL;
    end;
    if USUDESBLOQ is not null then
      indicador := 'S';
    ELSE
      indicador := 'N';
    end if;
  
    update jaqy138 j
       set j.jaqy138indrepcuo = indicador
     where j.jaqy138instori = INSTANCIA;
    commit;
  
  end sp_cr_indicador;
  -------------------------------------------------------------------------------------
  procedure sp_cr_saldocapital(cuenta       in number,
                               operacion    in number,
                               sucursal     in number,
                               moneda       in number,
                               papel        in number,
                               soboperacion in number,
                               modulo       in number) is
  
    saldo number(10, 2);
  begin
  
    begin
    
      select bcsdmo
        into saldo
        from fsh012
       where bccta = cuenta
         and bcoper = operacion
         and bcsuc = sucursal
         and bcmda = moneda
         and bcpap = papel
         and bcsbop = soboperacion
         and bcfech = (select max(bcfech)
                         from fsh012
                        where bccta = cuenta
                          and bcoper = operacion
                          and bcsuc = sucursal
                          and bcmda = moneda
                          and bcmod = modulo
                          and bcpap = papel
                          and bcsbop = soboperacion)
         and bcrubr in (select rubro
                          from fsd014
                         where pcnivc in (select MODULO
                                            from fst111
                                           Where Dscod = 50
                                             and Modulo <> 29
                                             and Modulo <> 120
                                             and Modulo <> 144));
    exception
      when others then
        NULL;
    end;
  
    update jaqy138 j
       set j.jaqy138salccm = saldo
     where j.jaqy138modrep = modulo
       and j.jaqy138sucrep = sucursal
       and j.jaqy138ctarep = cuenta
       and j.jaqy138operep = operacion;
  
  end sp_cr_saldocapital;
  -------------------------------------------------------------------------------------
  procedure sp_cr_nrocuotas(cuenta       in number,
                            operacion    in number,
                            sucursal     in number,
                            moneda       in number,
                            papel        in number,
                            soboperacion in number,
                            modulo       in number,
                            fechreprog   in date) is
    cuotas  number(4);
    cuocanc number(4);
  begin
  
    begin
      select count(*)
        into cuotas
        from fsd601
       where ppcta = cuenta
         and ppoper = operacion
         and ppsuc = sucursal
         and ppmda = moneda
         and pppap = papel
         and ppsbop = soboperacion
         and ppmod = modulo;
    exception
      when others then
        NULL;
    end;
  
    begin
      select count(*)
        into cuocanc
        from fsd602 f
       where ppcta = cuenta
         and ppoper = operacion
         and ppsuc = sucursal
         and ppmda = moneda
         and pppap = papel
         and ppsbop = soboperacion
         and ppmod = modulo
         and pp1fech < fechreprog
         and d602co = 'S'
         and pp1stat = 'T';
    exception
      when others then
        NULL;
    end;
  
    update jaqy138 j
       set j.jaqy138nrocuo = cuotas, j.jaqy138avacuo = cuocanc
     where j.jaqy138modrep = modulo
       and j.jaqy138sucrep = sucursal
       and j.jaqy138ctarep = cuenta
       and j.jaqy138operep = operacion;
  
  end sp_cr_nrocuotas;
  --------------------------------------------------------------------------------------
  procedure sp_cr_nroreprog(cuenta    in number,
                            operacion in number,
                            sucursal  in number,
                            moneda    in number,
                            papel     in number,
                            modulo    in number) is
  
    nro_reprog number(4);
  begin
    begin
      select count(*)
        into nro_reprog
        from fsd010 f10
        join xwf700 x on X.XWFEMPRESA = f10.pgcod
                     and x.xwfsucursal = f10.aosuc
                     and x.xwfmodulo = f10.aomod
                     and x.xwfmoneda = f10.aomda
                     and x.xwfpapel = f10.aopap
                     and x.xwfcuenta = f10.aocta
                     and x.xwfoperacion = f10.aooper
                     and x.xwfsubope = f10.aosbop
        join sng001 s1 on s1.sng001inst = x.xwfprcins
                      and s1.sng001emp = x.xwfempresa
                      and s1.sng001cta = x.xwfcuenta
        join fsr011 f11 on f11.r2mod = f10.aomod
                       and f11.r2cta = f10.aocta
                       and f11.r2oper = f10.aooper
                       and f11.r2mda = f10.aomda
                       and f11.r2suc = f10.aosuc
                       and f11.r2pap = f10.aopap
                       and f11.relcod in (860, 870, 890)
        join xwf070 x70 on x70.xwfpgcod = f10.pgcod
                       and x70.xwfprcin = x.xwfprcins
      
       where x.xwfcar3 = '1'
         and x.xwfmodulo in (select MODULO
                               from fst111
                              Where Dscod = 50
                                and Modulo <> 29
                                and Modulo <> 120
                                and Modulo <> 144)
         and s1.sng001ori in (13, 14, 16)
         and f10.aosuc = sucursal
         and f10.aomda = moneda
         and f10.aopap = papel
         and f10.aocta = cuenta
         and f10.aooper = operacion
         and f10.aomod = modulo
         and x.xwfsubope > (select min(f.aosbop)
                              from fsd010 f
                             where f.aomod = modulo
                               and f.aosuc = sucursal
                               and f.aomda = moneda
                               and f.aopap = papel
                               and f.aocta = cuenta
                               and f.aooper = operacion)
            and x.xwfprcins = (select max(xwfprcins)
                              from xwf700 xx
                             where xX.XWFEMPRESA = f10.pgcod
                               and xx.xwfsucursal = f10.aosuc
                               and xx.xwfmodulo = f10.aomod
                               and xx.xwfmoneda = f10.aomda
                               and xx.xwfpapel = f10.aopap
                               and xx.xwfcuenta = f10.aocta
                               and xx.xwfoperacion = f10.aooper
                               and xx.xwfsubope = f10.aosbop);
    exception
      when others then
        NULL;
    end;
  
    update jaqy138 j
       set j.jaqy138nrorep = nro_reprog
     where j.jaqy138modrep = modulo
       and j.jaqy138sucrep = sucursal
       and j.jaqy138ctarep = cuenta
       and j.jaqy138operep = operacion;
  
  end sp_cr_nroreprog;

  --------------------------------------------------------------------------------------
  procedure sp_cr_plazoreprog(cuenta       in number,
                              operacion    in number,
                              sucursal     in number,
                              moneda       in number,
                              papel        in number,
                              soboperacion in number,
                              modulo       in number) is
  
    plazo number(6);
  begin
    begin
    
      /*select aopzo
      into plazo
        from fsd010
       where aocta = cuenta
         and aooper = operacion
         and aosbop = soboperacion
         and aomod = modulo
         and aomda = moneda
         and aopap = papel
         and aosuc = sucursal;
            exception
        when others then
          NULL;
      end;*/
    
      select (MONTHS_BETWEEN((max(f.ppfpag)), (min(f.ppfpag)))+1)
        into plazo
        from fsd601 f
       where ppcta = cuenta
         and ppoper = operacion
         and ppsbop = soboperacion
         and ppmod = modulo
         and ppmda = moneda
         and pppap = papel
         and ppsuc = sucursal;
    exception
      when others then
        NULL;
    end;
  
    update jaqy138 j
       set j.jaqy138extrep = plazo
     where j.jaqy138modrep = modulo
       and j.jaqy138sucrep = sucursal
       and j.jaqy138ctarep = cuenta
       and j.jaqy138operep = operacion;
  
  end sp_cr_plazoreprog;

  --------------------------------------------------------------------------------------
  procedure sp_cr_credvig(cuenta in number, operacion in number) is
  
    nrocreditos number(5);
    DOCUMENTO   character(12);
  
  begin
    begin
      select jaqy138nrodoc
        into DOCUMENTO
        from jaqy138 j
       where j.jaqy138ctarep = cuenta
         and j.jaqy138operep = operacion;
    exception
      when others then
        NULL;
    end;
  
    begin
    
      select count(*)
        into nrocreditos
        from fsr008 f8
       inner join fsd010 f10 on f10.aocta = f8.ctnro
       where f10.aostat <> 99
         and f8.pendoc = DOCUMENTO
            --and f10.aocta <> cuenta
         and f10.aooper <> operacion
         and f10.aomod in (select MODULO
                             from fst111
                            Where Dscod = 50
                              and Modulo <> 29
                              and Modulo <> 120
                              and Modulo <> 144);
    exception
      when others then
        NULL;
    end;
  
    update jaqy138 j
       set j.jaqy138nrcrdvig = nrocreditos
     where j.jaqy138ctarep = cuenta
       and j.jaqy138operep = operacion;
  
  end sp_cr_credvig;
  --------------------------------------------------------------------------------------
  procedure sp_cr_credaprob(cuenta    in number,
                            operacion in number,
                            fecha     in date) is
  
    nrocreditos number(5);
    DOCUMENTO   character(12);
    credaprob   varchar2(5);
  
  begin
    begin
      select jaqy138nrodoc
        into DOCUMENTO
        from jaqy138 j
       where j.jaqy138ctarep = cuenta
         and j.jaqy138operep = operacion;
    exception
      when others then
        NULL;
    end;
  
    begin
    
      select count(*)
        into nrocreditos
        from fsr008 f8
       inner join fsd010 f10 on f10.aocta = f8.ctnro
       where f10.aostat <> 99
         and f8.pendoc = TRIM(DOCUMENTO)
         and f10.aocta <> cuenta
         and f10.aooper <> operacion
         and f10.aomod in (select MODULO
                             from fst111
                            Where Dscod = 50
                              and Modulo <> 29
                              and Modulo <> 120
                              and Modulo <> 144)
         and f10.aofval > fecha;
    
    exception
      when others then
        NULL;
    end;
  
    if nrocreditos > 0 then
      credaprob := 'SI';
    
    ELSE
      credaprob := 'NO';
    END IF;
  
    update jaqy138 j
       set j.jaqy138crapydes = credaprob
     where j.jaqy138ctarep = cuenta
       and j.jaqy138operep = operacion;
  
  end sp_cr_credaprob;

  --------------------------------------------------------------------------------------
  procedure sp_cr_ingnetodesrep(pn_instancia in number) is
  
    Ingdesp number;
  begin
  
    begin
      select distinct f.sng023mto
        into Ingdesp
        from sng021 e, sng023 f
       where e.sng021sol = pn_instancia
         and e.sng021tmod in (13, 14)
         and e.sng021eval = f.sng021eval
         and f.sng026cod in (40, 540, 27, 527)
         and rownum = 1;
    exception
      when no_data_found then
        Ingdesp := null;
      when too_many_rows then
        Ingdesp := null;
    end;
  
    update jaqy138 j
       set j.jaqy138indr = Ingdesp
     where j.jaqy138instrep = pn_instancia;
    commit;
  
  end sp_cr_ingnetodesrep;

  --------------------------------------------------------------------------------------
  procedure sp_cr_ingnetoantrep(pn_instancia in number) is
  
    Ingantes number;
  begin
  
    begin
      select distinct f.sng023mto
        into Ingantes
        from sng021 e, sng023 f
       where e.sng021sol = pn_instancia
         and e.sng021tmod in (13, 14)
         and e.sng021eval = f.sng021eval
         and f.sng026cod in (40, 540, 27, 527)
         and rownum = 1;
    exception
      when no_data_found then
        Ingantes := null;
      when too_many_rows then
        Ingantes := null;
    end;
  
    update jaqy138 j
       set j.jaqy138inar = Ingantes
     where j.jaqy138instori = pn_instancia;
    commit;
  
  end sp_cr_ingnetoantrep;

  --------------------------------------------------------------------------------------

  procedure sp_cr_cargatotalsuc(sucursal  in number,
                                fecinicio in date,
                                fecfin    in date) is
  
    -- ld_fecfin varchar2(10);
    ln_instancia number;
  
    cursor reprogramados is
    
      select j.jaqy138pgcodrep,
             j.jaqy138modrep,
             j.jaqy138sucrep,
             j.jaqy138mdarep,
             j.jaqy138paprep,
             j.jaqy138ctarep,
             j.jaqy138operep,
             j.jaqy138sboprep,
             j.jaqy138toprep,
             j.jaqy138pgcodori,
             j.jaqy138modori,
             j.jaqy138sucori,
             j.jaqy138mdaori,
             j.jaqy138papori,
             j.jaqy138ctaori,
             j.jaqy138operori,
             j.jaqy138sobori,
             j.jaqy138topori,
             j.jaqy138fecrep,
             j.jaqy138instrep
        from jaqy138 j;
  
  begin
    PQ_CR_ReprogramacionCreditos.sp_cr_cargadatosuc(sucursal,
                                                    fecinicio,
                                                    fecfin);
  
    begin
      for i in reprogramados loop
      
        /* ld_fecfin := to_char(fecfin,'DDMMYYYY');
        
        pq_cr_reprogramacioncreditos.sp_cr_job_cargasuc(ld_fecfin) ;*/
      
        PQ_CR_ReprogramacionCreditos.sp_cr_datoscliente(cuenta    => i.jaqy138ctarep,
                                                        operacion => i.jaqy138operep,
                                                        sucursal  => i.jaqy138sucrep);
        pq_cr_reprogramacioncreditos.sp_cr_instoriginal(instrepro     => i.jaqy138instrep,
                                                        cuenta        => i.jaqy138ctaori,
                                                        operacion     => i.jaqy138operori,
                                                        sucursal      => i.jaqy138sucori,
                                                        modulo        => i.jaqy138modori,
                                                        suboperacion  => i.jaqy138sobori,
                                                        tipooperacion => i.jaqy138topori,
                                                        instori       => ln_instancia);
      
        PQ_CR_ReprogramacionCreditos.sp_cr_clasificacion(P_N_RI105SUC  => i.jaqy138sucori,
                                                         P_N_RI105MOD  => i.jaqy138modori,
                                                         P_N_RI105MDA  => i.jaqy138mdaori,
                                                         P_N_RI105PAP  => i.jaqy138papori,
                                                         P_N_RI105CTA  => i.jaqy138ctaori,
                                                         P_N_RI105OPER => i.jaqy138operori,
                                                         P_N_RI105SBOP => i.jaqy138sboprep,
                                                         P_N_RI105TOPE => i.jaqy138topori);
        PQ_CR_REPROGRAMACIONCREDITOS.sp_cr_DiaAtr_Ultima(pn_emp   => i.jaqy138pgcodrep,
                                                         pn_mod   => i.jaqy138modori,
                                                         pn_suc   => i.jaqy138sucori,
                                                         pn_mda   => i.jaqy138mdaori,
                                                         pn_pap   => i.jaqy138papori,
                                                         pn_cta   => i.jaqy138ctaori,
                                                         pn_ope   => i.jaqy138operep,
                                                         pn_Sbo   => i.jaqy138sobori,
                                                         pn_top   => i.jaqy138topori,
                                                         pd_fecha => i.jaqy138fecrep);
        PQ_CR_REPROGRAMACIONCREDITOS.sp_cr_comentario(INSTANCIA => ln_instancia); --ojo
      
        PQ_CR_REPROGRAMACIONCREDITOS.sp_cr_categoria(pn_emp    => I.JAQY138PGCODREP,
                                                     pn_cta    => i.jaqy138ctarep,
                                                     pd_feccat => fecfin);
        pq_cr_reprogramacioncreditos.sp_cr_indicador(INSTANCIA => i.jaqy138instrep); --ojo
      
        pq_cr_reprogramacioncreditos.sp_cr_saldocapital(cuenta       => i.jaqy138ctarep,
                                                        operacion    => i.jaqy138operep,
                                                        sucursal     => i.jaqy138sucrep,
                                                        moneda       => i.jaqy138mdarep,
                                                        papel        => i.jaqy138paprep,
                                                        soboperacion => i.jaqy138sboprep,
                                                        modulo       => i.jaqy138modrep);
      
        pq_cr_reprogramacioncreditos.sp_cr_nrocuotas(cuenta       => i.jaqy138ctaori,
                                                     operacion    => i.jaqy138operori,
                                                     sucursal     => i.jaqy138sucori,
                                                     moneda       => i.jaqy138mdaori,
                                                     papel        => i.jaqy138papori,
                                                     soboperacion => i.jaqy138sobori,
                                                     modulo       => i.jaqy138modori,
                                                     fechreprog   => i.jaqy138fecrep);
        pq_cr_reprogramacioncreditos.sp_cr_nroreprog(cuenta    => i.jaqy138ctaori,
                                                     operacion => i.jaqy138operori,
                                                     sucursal  => i.jaqy138sucori,
                                                     moneda    => i.jaqy138mdaori,
                                                     papel     => i.jaqy138papori,
                                                     modulo    => i.jaqy138modori);
        pq_cr_reprogramacioncreditos.sp_cr_plazoreprog(cuenta       => i.jaqy138ctarep,
                                                       operacion    => i.jaqy138operep,
                                                       sucursal     => i.jaqy138sucrep,
                                                       moneda       => i.jaqy138mdarep,
                                                       papel        => i.jaqy138paprep,
                                                       soboperacion => i.jaqy138sboprep,
                                                       modulo       => i.jaqy138modrep);
        pq_cr_reprogramacioncreditos.sp_cr_credvig(cuenta    => i.jaqy138ctarep,
                                                   operacion => i.jaqy138operep);
        pq_cr_reprogramacioncreditos.sp_cr_credaprob(cuenta    => i.jaqy138ctarep,
                                                     operacion => i.jaqy138operep,
                                                     fecha     => i.jaqy138fecrep);
        pq_cr_reprogramacioncreditos.sp_cr_ingnetodesrep(pn_instancia => i.jaqy138instrep);
        pq_cr_reprogramacioncreditos.sp_cr_ingnetoantrep(pn_instancia => ln_instancia);
      
        commit;
      end loop;
    end;
  end sp_cr_cargatotalsuc;

  ------------------------------------------------------------------------------------

  /*procedure sp_cr_cargasuc(ld_fecfin in VARCHAR2,P_N_INI in NUMBER, P_N_FIN in NUMBER) is
  
  ln_instancia number;
  fecfin date;
    cursor reprogramados is
    
      select j.jaqy138pgcodrep,
             j.jaqy138modrep,
             j.jaqy138sucrep,
             j.jaqy138mdarep,
             j.jaqy138paprep,
             j.jaqy138ctarep,
             j.jaqy138operep,
             j.jaqy138sboprep,
             j.jaqy138toprep,j.jaqy138pgcodori,j.jaqy138modori,j.jaqy138sucori,j.jaqy138mdaori,j.jaqy138papori
             ,j.jaqy138ctaori,j.jaqy138operori,j.jaqy138sobori,j.jaqy138topori,j.jaqy138fecrep,j.jaqy138instrep
        from jaqy138 j
        WHERE j.jaqy138corr >= P_N_INI
           and j.jaqy138corr <= P_N_FIN;
  
  begin
    for i in reprogramados loop
    
    
    fecfin :=to_date(ld_fecfin,'DDMMYYYY');
    
       PQ_CR_ReprogramacionCreditos.sp_cr_datoscliente(cuenta    => i.jaqy138ctarep,
                                                operacion => i.jaqy138operep,
                                                sucursal  => i.jaqy138sucrep);
      pq_cr_reprogramacioncreditos.sp_cr_instoriginal(instrepro => i.jaqy138instrep,
                                                      cuenta => i.jaqy138ctaori ,
                                                      operacion => i.jaqy138operori ,
                                                      sucursal => i.jaqy138sucori,
                                                      modulo => i.jaqy138modori ,
                                                      suboperacion => i.jaqy138sobori,
                                                      tipooperacion => i.jaqy138topori,
                                                      instori => ln_instancia );                                              
                                                
      PQ_CR_ReprogramacionCreditos.sp_cr_clasificacion(P_N_RI105SUC =>i.jaqy138sucori ,
                                                       P_N_RI105MOD => i.jaqy138modori,
                                                       P_N_RI105MDA => i.jaqy138mdaori,
                                                       P_N_RI105PAP => i.jaqy138papori,
                                                       P_N_RI105CTA => i.jaqy138ctaori,
                                                       P_N_RI105OPER => i.jaqy138operori,
                                                       P_N_RI105SBOP => i.jaqy138sboprep,
                                                       P_N_RI105TOPE => i.jaqy138topori); 
       PQ_CR_REPROGRAMACIONCREDITOS.sp_cr_DiaAtr_Ultima(pn_emp => i.jaqy138pgcodrep,
                                                         pn_mod => i.jaqy138modori,
                                                         pn_suc => i.jaqy138sucori,
                                                         pn_mda => i.jaqy138mdaori,
                                                         pn_pap => i.jaqy138papori,
                                                         pn_cta => i.jaqy138ctaori,
                                                         pn_ope => i.jaqy138operep,
                                                         pn_Sbo => i.jaqy138sobori,
                                                         pn_top =>i.jaqy138topori,
                                                         pd_fecha => i.jaqy138fecrep
                                                         );  
       PQ_CR_REPROGRAMACIONCREDITOS.sp_cr_comentario(INSTANCIA =>ln_instancia);  --ojo
        
       PQ_CR_REPROGRAMACIONCREDITOS.sp_cr_categoria(pn_emp => I.JAQY138PGCODREP ,
                                                    pn_cta =>i.jaqy138ctarep,
                                                    pd_feccat => fecfin);
       pq_cr_reprogramacioncreditos.sp_cr_indicador(INSTANCIA => i.jaqy138instrep);  --ojo
       
       pq_cr_reprogramacioncreditos.sp_cr_saldocapital(cuenta => i.jaqy138ctarep,
                                                       operacion => i.jaqy138operep,
                                                       sucursal => i.jaqy138sucrep,
                                                       moneda => i.jaqy138mdarep,
                                                       papel => i.jaqy138paprep,
                                                       soboperacion => i.jaqy138sboprep,
                                                       modulo => i.jaqy138modrep);
                                                       
        pq_cr_reprogramacioncreditos.sp_cr_nrocuotas(cuenta => i.jaqy138ctaori,
                                                       operacion => i.jaqy138operori,
                                                       sucursal => i.jaqy138sucori,
                                                       moneda => i.jaqy138mdaori,
                                                       papel => i.jaqy138papori,
                                                       soboperacion => i.jaqy138sobori,
                                                       modulo => i.jaqy138modori,
                                                       fechreprog => i.jaqy138fecrep);
       pq_cr_reprogramacioncreditos.sp_cr_nroreprog( cuenta => i.jaqy138ctaori,
                                                       operacion => i.jaqy138operori,
                                                       sucursal => i.jaqy138sucori,
                                                       moneda => i.jaqy138mdaori,
                                                       papel => i.jaqy138papori,
                                                      modulo => i.jaqy138modori);
       pq_cr_reprogramacioncreditos.sp_cr_plazoreprog(cuenta => i.jaqy138ctarep,
                                                       operacion => i.jaqy138operep,
                                                       sucursal => i.jaqy138sucrep,
                                                       moneda => i.jaqy138mdarep,
                                                       papel => i.jaqy138paprep,
                                                       soboperacion => i.jaqy138sboprep,
                                                       modulo => i.jaqy138modrep);  
       pq_cr_reprogramacioncreditos.sp_cr_credvig(cuenta => i.jaqy138ctarep,
                                                  operacion => i.jaqy138operep);    
       pq_cr_reprogramacioncreditos.sp_cr_credaprob(cuenta =>i.jaqy138ctarep ,
                                                     operacion =>i.jaqy138operep ,
                                                     fecha => i.jaqy138fecrep );
      pq_cr_reprogramacioncreditos.sp_cr_ingnetodesrep(pn_instancia => i.jaqy138instrep);
      pq_cr_reprogramacioncreditos.sp_cr_ingnetoantrep(pn_instancia => ln_instancia);                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                   
                                                       
      commit;
    end loop;
  
  end sp_cr_cargasuc;
  */
  -------------------------------------------------------------------------------------
  procedure sp_cr_cargatotal(fecinicio in date, fecfin in date) is
  
    ln_instancia number;
    cursor reprogramados is
    
      select j.jaqy138pgcodrep,
             j.jaqy138modrep,
             j.jaqy138sucrep,
             j.jaqy138mdarep,
             j.jaqy138paprep,
             j.jaqy138ctarep,
             j.jaqy138operep,
             j.jaqy138sboprep,
             j.jaqy138toprep,
             j.jaqy138pgcodori,
             j.jaqy138modori,
             j.jaqy138sucori,
             j.jaqy138mdaori,
             j.jaqy138papori,
             j.jaqy138ctaori,
             j.jaqy138operori,
             j.jaqy138sobori,
             j.jaqy138topori,
             j.jaqy138fecrep,
             j.jaqy138instrep
        from jaqy138 j;
  
  begin
    PQ_CR_ReprogramacionCreditos.sp_cr_cargadatos(fecinicio, fecfin);
  
    begin
      for i in reprogramados loop
        PQ_CR_ReprogramacionCreditos.sp_cr_datoscliente(cuenta    => i.jaqy138ctarep,
                                                        operacion => i.jaqy138operep,
                                                        sucursal  => i.jaqy138sucrep);
        pq_cr_reprogramacioncreditos.sp_cr_instoriginal(instrepro     => i.jaqy138instrep,
                                                        cuenta        => i.jaqy138ctaori,
                                                        operacion     => i.jaqy138operori,
                                                        sucursal      => i.jaqy138sucori,
                                                        modulo        => i.jaqy138modori,
                                                        suboperacion  => i.jaqy138sobori,
                                                        tipooperacion => i.jaqy138topori,
                                                        instori       => ln_instancia);
      
        PQ_CR_ReprogramacionCreditos.sp_cr_clasificacion(P_N_RI105SUC  => i.jaqy138sucori,
                                                         P_N_RI105MOD  => i.jaqy138modori,
                                                         P_N_RI105MDA  => i.jaqy138mdaori,
                                                         P_N_RI105PAP  => i.jaqy138papori,
                                                         P_N_RI105CTA  => i.jaqy138ctaori,
                                                         P_N_RI105OPER => i.jaqy138operori,
                                                         P_N_RI105SBOP => i.jaqy138sboprep,
                                                         P_N_RI105TOPE => i.jaqy138topori);
        PQ_CR_REPROGRAMACIONCREDITOS.sp_cr_DiaAtr_Ultima(pn_emp   => i.jaqy138pgcodrep,
                                                         pn_mod   => i.jaqy138modori,
                                                         pn_suc   => i.jaqy138sucori,
                                                         pn_mda   => i.jaqy138mdaori,
                                                         pn_pap   => i.jaqy138papori,
                                                         pn_cta   => i.jaqy138ctaori,
                                                         pn_ope   => i.jaqy138operep,
                                                         pn_Sbo   => i.jaqy138sobori,
                                                         pn_top   => i.jaqy138topori,
                                                         pd_fecha => i.jaqy138fecrep);
        PQ_CR_REPROGRAMACIONCREDITOS.sp_cr_comentario(INSTANCIA => i.jaqy138instrep); --ojo 
      
        PQ_CR_REPROGRAMACIONCREDITOS.sp_cr_categoria(pn_emp    => I.JAQY138PGCODREP,
                                                     pn_cta    => i.jaqy138ctarep,
                                                     pd_feccat => fecfin);
        pq_cr_reprogramacioncreditos.sp_cr_indicador(INSTANCIA => i.jaqy138instrep); --ojo
      
        pq_cr_reprogramacioncreditos.sp_cr_saldocapital(cuenta       => i.jaqy138ctarep,
                                                        operacion    => i.jaqy138operep,
                                                        sucursal     => i.jaqy138sucrep,
                                                        moneda       => i.jaqy138mdarep,
                                                        papel        => i.jaqy138paprep,
                                                        soboperacion => i.jaqy138sboprep,
                                                        modulo       => i.jaqy138modrep);
      
        pq_cr_reprogramacioncreditos.sp_cr_nrocuotas(cuenta       => i.jaqy138ctaori,
                                                     operacion    => i.jaqy138operori,
                                                     sucursal     => i.jaqy138sucori,
                                                     moneda       => i.jaqy138mdaori,
                                                     papel        => i.jaqy138papori,
                                                     soboperacion => i.jaqy138sobori,
                                                     modulo       => i.jaqy138modori,
                                                     fechreprog   => i.jaqy138fecrep);
        pq_cr_reprogramacioncreditos.sp_cr_nroreprog(cuenta    => i.jaqy138ctaori,
                                                     operacion => i.jaqy138operori,
                                                     sucursal  => i.jaqy138sucori,
                                                     moneda    => i.jaqy138mdaori,
                                                     papel     => i.jaqy138papori,
                                                     modulo    => i.jaqy138modori);
        pq_cr_reprogramacioncreditos.sp_cr_plazoreprog(cuenta       => i.jaqy138ctarep,
                                                       operacion    => i.jaqy138operep,
                                                       sucursal     => i.jaqy138sucrep,
                                                       moneda       => i.jaqy138mdarep,
                                                       papel        => i.jaqy138paprep,
                                                       soboperacion => i.jaqy138sboprep,
                                                       modulo       => i.jaqy138modrep);
        pq_cr_reprogramacioncreditos.sp_cr_credvig(cuenta    => i.jaqy138ctarep,
                                                   operacion => i.jaqy138operep);
        pq_cr_reprogramacioncreditos.sp_cr_credaprob(cuenta    => i.jaqy138ctarep,
                                                     operacion => i.jaqy138operep,
                                                     fecha     => i.jaqy138fecrep);
        pq_cr_reprogramacioncreditos.sp_cr_ingnetodesrep(pn_instancia => i.jaqy138instrep);
        pq_cr_reprogramacioncreditos.sp_cr_ingnetoantrep(pn_instancia => ln_instancia);
      
        commit;
      end loop;
    end;
  end sp_cr_cargatotal;

---------------------------------------------------------------------------

/*procedure sp_cr_job_cargasuc(ld_fecfin in VARCHAR2) is
  
    ln_ini      number;
    ln_fin      number;
    ln_divisor  number := 25;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    --lc_fecpro   char(10);
    -- ld_finmes   date;
    ln_contador number;
    ln_num      number := 1;
  
  begin
  
    begin
      DBMS_STATS.gather_table_stats(ownname          => 'DESA010615',
                                    tabname          => 'JAQY138',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
  
    begin
      select ceil(count(*) / ln_divisor) into ln_contador from jaqy138;
      /* where jaql964dia >= 1
      and jaql964est in (0, 61, 21, 22);*/
/* end;
  
    ln_ini := 1;
    ln_fin := 25;
    WHILE ln_num <= ln_contador LOOP
    
      lc_variable := 'begin ' ||
                     ' PQ_CR_ReprogramacionCreditos.sp_cr_cargasuc(' ||
                     ld_fecfin || ',' || ln_ini || ',' || ln_fin || ' );' ||
                     ' End;';
      ln_job      := ln_job + 1;
      DBMS_JOB.SUBMIT(job       => ln_job,
                      what      => lc_variable,
                      next_date => sysdate + 1 / (24 * 60),
                      interval  => null,
                      no_parse  => false,
                      instance  => 1,
                      force     => false);
    
      ln_ini := ln_fin + 1;
      ln_fin := ln_ini + ln_divisor - 1;
    
      ln_num := ln_num + 1;
      commit;
    END LOOP;
  
  end sp_cr_job_cargasuc;*/
-------------------------------------------------------------------------------------
end PQ_CR_ReprogramacionCreditos;
/

