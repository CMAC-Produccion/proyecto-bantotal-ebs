create or replace package PQ_CR_NAVIDAD2017_REGULA is

  -- *****************************************************************
  -- Nombre                     :PROCESO DE REGULARIZACION CUPONES - CAMPAÑA NAVIDAD 2017
  -- Sistema                    : BANTOTAL
  -- Módulo                     : 
  -- Versión                    : 1.0
  -- Fecha de Creación          : 
  -- Autor de Creación          : 
  -- Uso                        : GENERACION DE DATA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_Verificacion_Fecha(pc_uing     in varchar2,
                                  pd_fechaIni in date,
                                  pd_fechaFin in date);

  --Procedure sp_cr_buscadesembolso(pc_uing in varchar2, pd_fecha in date);
  Procedure sp_cr_excepcionTrans(ln_tmod       in number,
                                 ln_ttran      in number,
                                 flag_Exptrans out varchar2);
  -------------------------------------------------------------------------                                 
  procedure sp_cr_ChekTrabajador(ln_cta           in number,
                                 lc_flgtrabajador out varchar2);
  -----------------------------------------------------------------------                                 
  procedure sp_cr_buscaPagos(lc_digito in varchar2,
                             pc_uing   IN VARCHAR2,
                             ld_FecIni in date ,
                             ld_FecIFin in date);
  ---------------------------------------------------------------------------
  procedure sp_cr_verificajaql406(ln_pgcod     in number,
                                  ln_modulo    in number,
                                  ln_sucursal  in number,
                                  ln_moneda    in number,
                                  ln_papel     in number,
                                  ln_cuenta    in number,
                                  ln_operacion in number,
                                  ln_subope    in number,
                                  ln_tope      in number,
                                  pd_fecha     in date,
                                  JAQL406tsbor in number,
                                  JAQL406tord  in number,
                                  JAQL406tnrel in number,
                                  JAQL406ttran in number,
                                  JAQL406tmod  in number,
                                  JAQL406tsuc  in number,
                                  flag_exist   out varchar2);
  -----------------------------------------------------------------------
  procedure sp_cr_verificaferiado(ln_diastraso in number,
                                  ln_sucursal  in number,
                                  ld_fecha     in date,
                                  Flag_feri    out varchar2);
  -------------------------------------------------------------------
  procedure sp_cr_feriadoOficial(ln_diaatr   in number,
                                 ld_fchpago  in date,
                                 ld_fchcuota in date,
                                 ln_sucursal in number,
                                 Flag_habil  out varchar2);
  ------------------------------------------------------------------
  procedure sp_cr_inserta(nro_cupon     in number,
                          ln_pgcod      in number,
                          ln_modulo     in number,
                          ln_sucursal   in number,
                          ln_moneda     in number,
                          ln_papel      in number,
                          ln_cuenta     in number,
                          ln_operacion  in number,
                          ln_subope     in number,
                          ln_tope       in number,
                          ln_nrocred    in varchar2,
                          ld_fecha1     in date,
                          pd_fecha      in date,
                          lc_Est        in varchar2,
                          lc_usuario    in varchar2,
                          ln_sucusuario in number,
                          lc_region     in number,
                          lc_Ant        in varchar2,
                          ln_Atr        in varchar2,
                          ln_calific    in number,
                          lc_Tip        in varchar2,
                          lc_EXCUP      in varchar2,
                          JAQL406tsbor  in number,
                          JAQL406tord   in number,
                          JAQL406tnrel  in number,
                          JAQL406ttran  in number,
                          JAQL406tmod   in number,
                          JAQL406tsuc   in number,
                          ld_fecha2     in date,
                          ln_NUMP       in number,
                          ln_CUPNUM     in number,
                          ln_opcion     in number);
  --------------------------------------------------------------
  procedure sp_Excepciones(modulo   in number,
                           ln_suc1  in number,
                           ln_mda1  in number,
                           ln_cta1  in number,
                           ln_oper1 in number,
                           ln_sbop1 in number,
                           ittope   in number,
                           --ln_scrub1  in number,
                           ln_scstat1 in number,
                           FlgIncl    out char);

  -----------------------------------------------------------------------------
  function fn_Tipo_Doc_SBS(ln_tdoc in number, lc_tndoc in char) return char;
  -----------------------------------------------------------------------------
  function fn_Calif_SBS_Cliente(lc_docsbs in char, lc_tndoc in char)
    return number;
  ---------------------------------------------------------------------
  Procedure sp_cr_cargaCuoIm_job(pc_uing     in varchar2,
                                 pd_fechaIni in date,
                                 pd_fechaFin in date);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
end PQ_CR_NAVIDAD2017_REGULA;
/

create or replace package body PQ_CR_NAVIDAD2017_REGULA is
  -- *****************************************************************
  -- Nombre                     : PROCESO DE REGULARIZACION DIARIA CUPONES - CAMPAÑA NAVIDAD 2016
  -- Sistema                    : BANTOTAL
  -- Módulo                     : 
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2016.10.21
  -- Autor de Creación          : MPOSTIGOC 
  -- Uso                        : GENERACION DE DATA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_Verificacion_Fecha(pc_uing     in varchar2,
                                  pd_fechaIni in date,
                                  pd_fechaFin in date) is
  
    ld_FchI date;
    ld_FchF date;
  
  Begin
    Begin
    
      Begin
        select to_date(Tp1nro1 || '/' || Tp1nro2 || '/' || Tp1nro3,
                       'DD/MM/YYYY'), --fech_inicio,
               to_date(Tp1imp1 || '/' || Tp1imp2 || '/' || Tp1imp3,
                       'DD/MM/YYYY')
          into ld_FchI, ld_FchF
          from FST198
         Where Tp1cod = 1
           and Tp1cod1 = 10871
           and Tp1corr1 = 7
           and Tp1corr2 = 4;
      
      End;
    
      If (pd_fechaIni >= ld_FchI and pd_fechaIni <= ld_FchF) then
        PQ_CR_NAVIDAD2017_REGULA.sp_cr_cargaCuoIm_job(pc_uing,
                                                      pd_fechaIni,
                                                      pd_fechaFin);
      End If;
    End;
  end sp_Verificacion_Fecha;
  ------------------------------------------------------------------------------ 
  procedure sp_cr_buscaPagos(lc_digito in varchar2,
                             pc_uing   IN VARCHAR2,
                             ld_FecIni in date ,
                             ld_FecIFin in date) is
  
    Cursor datapagos(ld_FchI IN DATE, ld_FchF in date) is
    
      select f.Ppmod JAQL406Mod,
             f.ppsuc JAQL406Suc,
             f.ppmda JAQL406Mda,
             f.ppcta JAQL406Cta,
             f.ppoper JAQL406Ope,
             f.ppsbop JAQL406Sbo,
             f.pptope JAQL406Top,
             f.d602tr JAQL406TTRAN,
             f.d602mo JAQL406TMOD,
             f.d602re JAQL406TNREL,
             f.d602or JAQL406TORD,
             f.d602su JAQL406TSUC,
             f.d602sb JAQL406TSBOR,
             f.pgcod JAQL406PGC,
             f.pppap JAQL406PAP,
             lpad(trim(to_char(f.ppcta)), 9, '0') ||
             lpad(trim(to_char(f.ppmda)), 3, '0') ||
             lpad(trim(to_char(f.ppoper)), 9, '0') CREDITO,
             (select r2.regcod
                from fst810 r2, fst811 r
               where r2.pgcod = r.pgcod
                 and r2.regcod = r.regcod
                 and r.pgcod = 1
                 and r.oficod = f.ppsuc
                 and r2.regcod < 100) REGION,
             f.pp1nump NRO_CUOTA,
             f.d602fc FECH_OPE,
             f.pp1fech fch_pp1,
             f.ppfpag FECH_CTA
        from fsd602 f
       where f.pgcod = 1
         and f.pppap = 0
         and f.ppmda in (0, 101)
         and f.d602fc between ld_FecIni and ld_FecIFin
         and f.d602co = 'S'
         and f.ppmod in (select modulo from fst111 where dscod = 50)
         and f.pp1stat = 'T'
         and f.ppfpag between ld_FchI and ld_FchF
         and to_char(substr(trim(f.ppcta), -1, 1)) = lc_digito;
  
    ln_sbop    number(3);
    ln_tope    number(3);
    ln_cta     NUMBER(9);
    ln_mod     NUMBER(4);
    ln_mda     NUMBER(3);
    ln_oper    NUMBER(9);
    ln_suc     number(3);
    ln_ttran   number;
    ln_tmod    number;
    ln_tnrel   number;
    ln_tord    number;
    ln_tsuc    number;
    ln_tsbor   number;
    ln_pgcod   number;
    ln_papel   number;
    ln_nrocred varchar2(21);
    ln_region  number;
  
    lc_Est   char(1);
    lc_Ant   char(1);
    ln_Atr   NUMBER(10);
    lc_Tip   char(1);
    lc_EXCUP char(5);
    ld_fecha date;
  
    FlgInc char(1);
  
    flag_exist VARCHAR2(2);
    ln_tdoc    number(2);
    lc_tndoc   char(12);
    ln_opcion  number(5);
    --ln_scrub      number(16);
    ln_scstat     number(2);
    lc_docsbs     char(1);
    ln_calific    number(10);
    ln_NUMP       NUMBER(9);
    ln_CUPNUM     NUMBER(10);
    i             number := 1;
    flag_Exptrans varchar2(2);
    ld_fcta       date;
    --pd_fecha      date;
    --Flag_feri varchar2(2);
    ld_fopera date;
  
    ld_FchI          date;
    ld_FchF          date;
    lc_flgtrabajador varchar2(2);
    diasatraso       number;
    Flag_habil       varchar2(2);
  
  BEGIN
  
    Begin
      --************************** cambiar formato ******************
      select to_date(Tp1nro1 || '/' || Tp1nro2 || '/' || Tp1nro3,
                     'DD/MM/YYYY'), --fech_inicio,
             to_date(Tp1imp1 || '/' || Tp1imp2 || '/' || Tp1imp3,
                     'DD/MM/YYYY')
        into ld_FchI, ld_FchF
        from FST198
       Where Tp1cod = 1
         and Tp1cod1 = 10871
         and Tp1corr1 = 7
         and Tp1corr2 = 4;
    
    End;
  
    For j in datapagos(ld_FchI, ld_FchF) loop
    
      ln_mod   := j.jaql406mod;
      ln_suc   := j.jaql406suc;
      ln_mda   := j.jaql406mda;
      ln_cta   := j.jaql406cta;
      ln_oper  := j.jaql406ope;
      ln_sbop  := j.jaql406sbo;
      ln_tope  := j.jaql406top;
      ln_ttran := j.JAQL406TTRAN;
      ln_tmod  := j.JAQL406TMOD;
      ln_tnrel := j.JAQL406TNREL;
      ln_tord  := j.JAQL406TORD;
      ln_tsuc  := j.JAQL406TSUC;
      ln_tsbor := j.JAQL406TSBOR;
      ln_pgcod := j.JAQL406PGC;
      ln_papel := j.JAQL406PAP;
      -- ln_nrocred := j.CREDITO;
      ln_region := j.region;
      ld_fcta   := j.fech_cta;
      ld_fopera := j.FECH_OPE;
    
      -- if ld_fcta >= ld_FchI and ld_fcta <= ld_FchF then
    
      if j.FCH_PP1 <= j.fech_ope then
        ld_fopera := j.fch_pp1;
      else
        ld_fopera := j.fech_ope;
      end if;
    
      ln_nrocred := j.credito;
      diasatraso := (ld_fopera - ld_fcta);
    
      PQ_CR_NAVIDAD2017_REGULA.sp_cr_ChekTrabajador(j.jaql406cta,
                                                    lc_flgtrabajador);
    
      if ld_fopera >= ld_FchI and ld_fopera <= ld_FchF then
      
        if lc_flgtrabajador = 'N' then
        
          PQ_CR_NAVIDAD2017_REGULA.sp_cr_excepcionTrans(ln_tmod,
                                                        ln_ttran,
                                                        flag_Exptrans);
        
          if flag_Exptrans = 'S' then
          
            PQ_CR_NAVIDAD2017_REGULA.sp_Excepciones(ln_mod,
                                                    ln_suc,
                                                    ln_mda,
                                                    ln_cta,
                                                    ln_oper,
                                                    ln_sbop,
                                                    ln_tope,
                                                    ln_scstat,
                                                    FlgInc);
          
            If FlgInc <> 'N' then
            
              if diasatraso > 0 then
              
                /* PQ_CR_NAVIDAD2017_REGULA.sp_cr_verificaferiado(diasatraso,
                j.jaql406suc,
                j.fech_cta,
                Flag_habil);*/
              
                PQ_CR_NAVIDAD2017_REGULA.sp_cr_feriadoOficial(diasatraso,
                                                              ld_fopera,
                                                              j.fech_cta,
                                                              j.jaql406suc,
                                                              Flag_habil);
              
                if Flag_habil = 'N' then
                  begin
                    select tp1nro3
                      into ln_opcion
                      from fst198
                     where tp1cod = 1
                       and tp1cod1 = 10871
                       and tp1corr1 = 7
                       and tp1corr2 = 2
                       and tp1corr3 = 1;
                  end;
                
                else
                  if Flag_habil = 'S' then
                  
                    if diasatraso > 0 then
                      begin
                        select tp1nro3
                          into ln_opcion
                          from fst198
                         where tp1cod = 1
                           and tp1cod1 = 10871
                           and tp1corr1 = 7
                           and tp1corr2 = 2
                              --  and tp1corr3 = 2
                           and tp1nro2 = diasatraso;
                      exception
                        when others then
                          ln_opcion := 0;
                      end;
                    end if;
                  end if;
                end if;
              
              else
                if diasatraso <= 0 then
                  begin
                    select tp1nro3
                      into ln_opcion
                      from fst198
                     where tp1cod = 1
                       and tp1cod1 = 10871
                       and tp1corr1 = 7
                       and tp1corr2 = 2
                       and tp1corr3 = 1;
                  end;
                
                end if;
              end if;
            
              begin
                select f.pendoc, f.petdoc
                  into lc_tndoc, ln_tdoc
                  from fsr008 f
                 where f.ctnro = j.jaql406cta
                   and f.cttfir = 'T';
              end;
            
              lc_tndoc := trim(lc_tndoc);
            
              lc_docsbs  := fn_Tipo_Doc_SBS(ln_tdoc, lc_tndoc);
              ln_calific := fn_Calif_SBS_Cliente(lc_docsbs, lc_tndoc);
            
              If FlgInc <> 'N' and ln_calific = 1 then
              
                lc_Est := 'S';
              
                lc_EXCUP  := 'C';
                ln_Atr    := diasatraso;
                ln_NUMP   := J.NRO_CUOTA;
                ln_CUPNUM := 1;
              
                begin
                  select pgfape into ld_fecha from FST017 WHERE pgcod = 1;
                end;
              
                IF ln_Atr = 0 or ln_Atr > 0 then
                  lc_Ant := 'N';
                Else
                  if ln_Atr < 0 THEN
                    lc_Ant := 'S';
                  end if;
                end if;
              
                lc_Tip := 'P';
              
                PQ_CR_NAVIDAD2017_REGULA.sp_cr_verificajaql406(ln_pgcod,
                                                               ln_mod,
                                                               ln_suc,
                                                               ln_mda,
                                                               ln_papel,
                                                               ln_cta,
                                                               ln_oper,
                                                               ln_sbop,
                                                               ln_tope,
                                                               ld_fcta,
                                                               ln_tsbor,
                                                               ln_tord,
                                                               ln_tnrel,
                                                               ln_ttran,
                                                               ln_tmod,
                                                               ln_tsuc,
                                                               flag_exist);
              
                if flag_exist <> 'S' then
                
                  while i <= ln_opcion loop
                  
                    PQ_CR_NAVIDAD2017_REGULA.sp_cr_inserta(SQ_CR_JAQL406_2.NEXTVAL,
                                                           j.JAQL406pgc,
                                                           j.JAQL406Mod,
                                                           j.JAQL406Suc,
                                                           j.JAQL406Mda,
                                                           j.JAQL406pap,
                                                           j.JAQL406Cta,
                                                           j.JAQL406Ope,
                                                           j.JAQL406Sbo,
                                                           j.JAQL406Top,
                                                           j.credito,
                                                           ld_fecha,
                                                           j.FECH_OPE,
                                                           lc_Est,
                                                           UPPER(pc_uing),
                                                           j.JAQL406Suc,
                                                           j.region,
                                                           lc_Ant,
                                                           ln_Atr,
                                                           ln_calific,
                                                           lc_Tip,
                                                           lc_EXCUP,
                                                           j.JAQL406tsbor,
                                                           j.JAQL406tord,
                                                           j.JAQL406tnrel,
                                                           j.JAQL406ttran,
                                                           j.JAQL406tmod,
                                                           j.JAQL406tsuc,
                                                           ld_fcta,
                                                           ln_NUMP,
                                                           ln_CUPNUM,
                                                           ln_opcion);
                  
                    i := i + 1;
                  
                  end loop;
                  commit;
                
                End IF;
              
                i := 1;
              End If;
            End If;
          End If;
        End If;
      
      End If;
    End loop;
  
  end sp_cr_buscaPagos;

  ---------------------------------------------------------------------------
  procedure sp_cr_ChekTrabajador(ln_cta           in number,
                                 lc_flgtrabajador out varchar2) is
  
    -- lc_flgtrabajador :='N';
  
  begin
    lc_flgtrabajador := 'N';
    begin
      select 'S'
        into lc_flgtrabajador
        from fsd002 d, fsr008 s
       where d.pfebco = 'S'
         and d.pfpais = s.pepais
         and d.pftdoc = s.petdoc
         and d.pfndoc = s.pendoc
         and s.ctnro = ln_cta;
    exception
      when others then
        lc_flgtrabajador := 'N';
      
    end;
  
  end sp_cr_ChekTrabajador;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  Procedure sp_cr_excepcionTrans(ln_tmod       in number,
                                 ln_ttran      in number,
                                 flag_Exptrans out varchar2) is
  
  begin
    flag_Exptrans := 'N';
  
    begin
    
      select 'S'
        into flag_Exptrans
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10871
         and tp1corr1 = 7
         and tp1corr2 = 10
         and tp1nro2 = ln_tmod
         and tp1nro3 = ln_ttran;
    exception
      when others then
        flag_Exptrans := 'N';
      
    end;
  
  End sp_cr_excepcionTrans;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_Excepciones(modulo   in number,
                           ln_suc1  in number,
                           ln_mda1  in number,
                           ln_cta1  in number,
                           ln_oper1 in number,
                           ln_sbop1 in number,
                           ittope   in number,
                           --ln_scrub1  in number,
                           ln_scstat1 in number,
                           FlgIncl    out char) is
  
    --ln_rcta number(9);
  
    ln_modulo number;
    ln_cta    number;
    ln_oper   number;
    ln_sboper number;
    ln_sucur  number;
    ln_mda    number;
    ln_tipoer number;
  
  Begin
    Begin
    
      FlgIncl := 'S';
    
      If modulo = 108 And ittope = 1 then
        ---créditos prendarios
        FlgIncl := 'N';
      Else
        If modulo = 200 then
          --créditos judiciales
          FlgIncl := 'N';
          --créditos administrativos
        Else
        
          If modulo = 106 And (ittope = 30 Or ittope = 31) then
            FlgIncl := 'N';
            --consumo para trabajadores -- Tipos de Operacion de Trabajador CMAC Arequipa.
          Else
            If modulo = 106 And (ittope = 10 Or ittope = 11 Or ittope = 32 Or
               ittope = 33 Or ittope = 34) then
              FlgIncl := 'N';
              --créditos hipotecarios para trabajadores c/cts s/cts -- Tipos de Operacion de Trabajador CMAC Arequipa.
            Else
              If modulo = 110 And
                 (ittope = 20 Or ittope = 21 Or ittope = 22 Or ittope = 23 Or
                 ittope = 24 Or ittope = 25 Or ittope = 26 Or ittope = 27 Or
                 ittope = 84 Or ittope = 85 Or ittope = 86 Or ittope = 87 or
                 ittope = 101) then
                FlgIncl := 'N';
              
                --   jaql406mod = 110 and jaql406top in (101)
              
                --créditos consumo convenios
              Else
                If /*Scgru = 3 And*/
                 modulo = 107 then
                  FlgIncl := 'N';
                Else
                  --créditos refinanciados, pj
                  If ln_scstat1 IN (61, 33, 34, 21, 22, 23, 25, 64, 90) then
                    FlgIncl := 'N';
                    --creditos Vehicular Nvo Trabajador c/CTS  ---Tipos de Operacion de Trabajador CMAC Arequipa.
                  Else
                    If modulo = 112 And (ittope = 65 Or ittope = 66 Or
                       ittope = 70 Or ittope = 71) then
                      FlgIncl := 'N';
                    else
                      If modulo = 103 And (ittope = 50 Or ittope = 51) then
                        FlgIncl := 'N';
                      else
                        If modulo = 116 And
                           (ittope = 16 Or ittope = 17 Or ittope = 18) then
                          FlgIncl := 'N';
                        End If;
                      End If;
                    End If;
                  End If;
                End If;
              End If;
            End If;
          End If;
        End If;
      End If;
    
      If FlgIncl = 'S' then
      
        --créditos reprogramados 
        begin
          select 'N' --distinct R2cta
            into FlgIncl
            from FSR011
           Where R1cod = 1
             and R1mod = modulo
             and R1suc = ln_suc1
             and R1mda = ln_mda1
             and R1pap = 0
             and R1cta = ln_cta1
             and R1oper = ln_oper1
             and R1sbop = ln_sbop1
             and R1tope = ittope
             and Relcod in (860, 870, 890) --Reprog. Cambio de Fecha-860 / Reprog. Desastres Naturales-870
             and R2mod = modulo
             and rownum = 1;
          -- FlgIncl := 'N';
        exception
          when no_data_found then
            -- ln_rcta := 0;
            FlgIncl := 'S';
        end;
      
      End If;
    
      If FlgIncl = 'S' then
      
        if modulo = 116 then
        
          begin
          
            select f.r2mod,
                   f.r2cta,
                   f.r2oper,
                   f.r2sbop,
                   f.r2suc,
                   f.r2mda,
                   f.r2tope
              into ln_modulo,
                   ln_cta,
                   ln_oper,
                   ln_sboper,
                   ln_sucur,
                   ln_mda,
                   ln_tipoer
              from fsr011 f
             where f.r1cod = 1
               and f.r1mod = modulo
               and f.r1suc = ln_suc1
               and f.r1mda = ln_mda1
               and f.r1pap = 0
               and f.r1cta = ln_cta1
               and f.r1oper = ln_oper1
               and f.r1sbop = ln_sbop1
               and f.r1tope = ittope
               and f.relcod = 46;
          
          end;
        
          begin
            Select 'N'
              into FlgIncl
              from fsr011 a, fsr011 b
             where a.relcod = 50
               and a.r1cod = 1
               and a.r1mod = ln_modulo
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
              -- ln_rcta := 0;
              FlgIncl := 'S';
            
          end;
        
        else
          if modulo <> 116 then
          
            begin
              --créditos con garantía de plazo fijo o cts
            
              Select 'N'
                into FlgIncl
                from fsr011 a, fsr011 b
               where a.relcod = 50
                 and a.r1cod = 1
                 and a.r1mod = modulo
                 and a.r1suc = ln_suc1
                 and a.r1mda = ln_mda1
                 and a.r1pap = 0
                 and a.r1cta = ln_cta1
                 and a.r1oper = ln_oper1
                 and a.r1sbop = ln_sbop1
                 and a.r1tope = ittope
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
      end if;
    
    End;
  end sp_Excepciones;
  ---------------------------------------------------------------------------------------------
  procedure sp_cr_verificajaql406(ln_pgcod     in number,
                                  ln_modulo    in number,
                                  ln_sucursal  in number,
                                  ln_moneda    in number,
                                  ln_papel     in number,
                                  ln_cuenta    in number,
                                  ln_operacion in number,
                                  ln_subope    in number,
                                  ln_tope      in number,
                                  pd_fecha     in date,
                                  JAQL406tsbor in number,
                                  JAQL406tord  in number,
                                  JAQL406tnrel in number,
                                  JAQL406ttran in number,
                                  JAQL406tmod  in number,
                                  JAQL406tsuc  in number,
                                  flag_exist   out varchar2) is
  
  begin
    begin
      select 'S'
        INTO flag_exist
        from jaql406 j
       where j.JAQL406PGC = ln_pgcod
         and j.JAQL406MOD = ln_modulo
         and j.JAQL406SUC = ln_sucursal
         and j.JAQL406MDA = ln_moneda
         and j.JAQL406PAp = ln_papel
         and j.JAQL406CTA = ln_cuenta
         and j.JAQL406OPE = ln_operacion
         and j.JAQL406SBO = ln_subope
         and j.JAQL406TOP = ln_tope
         and j.JAQL406Fcta = pd_fecha
         and j.jaql406tsbor = JAQL406tsbor
         and j.jaql406tord = JAQL406tord
         and j.jaql406tnrel = JAQL406tnrel
         and j.jaql406ttran = JAQL406ttran
         and j.jaql406tmod = JAQL406tmod
         and j.jaql406tsuc = JAQL406tsuc
         and j.jaql406excup = 'C'
         and rownum = 1;
    
    exception
      when others then
        flag_exist := 'N';
    end;
  
  end sp_cr_verificajaql406;
  -- -- --- --------------------------------------------------------------------------
  procedure sp_cr_verificaferiado(ln_diastraso in number,
                                  ln_sucursal  in number,
                                  ld_fecha     in date,
                                  Flag_feri    out varchar2) is
  
    ln_calcod number;
  
  begin
  
    Flag_feri := 'S';
  
    begin
      select f.calcod
        into ln_calcod
        from fst001 f
       where f.pgcod = 1
         and f.sucurs = ln_sucursal;
    exception
      when others then
        null;
    end;
  
    If ln_diastraso = 1 then
      begin
        select Fhabil
          into Flag_feri
          from FST028
         where calcod = ln_calcod
           and ffecha = ld_fecha;
      exception
        when others then
          Flag_feri := 'S';
      end;
    
    Else
      If ln_diastraso = 2 then
        begin
          select Fhabil
            into Flag_feri
            from FST028
           where calcod = ln_calcod
             and ffecha = ld_fecha;
        exception
          when others then
            Flag_feri := 'S';
          
        end;
        If Flag_feri = 'N' then
          --//DIA FERIADO -verificar si dia anterior tambien fue feriado
          begin
            select Fhabil
              into Flag_feri
              from FST028
             where calcod = ln_calcod
               and ffecha = ld_fecha + 1;
          exception
            when others then
              Flag_feri := 'S';
          end;
        
        end if;
      end if;
    end if;
  
  end sp_cr_verificaferiado;

  ---------------------------------------------------------------------------------------

  procedure sp_cr_feriadoOficial(ln_diaatr   in number,
                                 ld_fchpago  in date,
                                 ld_fchcuota in date,
                                 ln_sucursal in number,
                                 Flag_habil  out varchar2) is
  
    --Flag_habil char(1);
    --ln_diaatr number;
    ld_fecha  date;
    ln_calcod number;
    ln_var    number;
  
  begin
  
    Flag_habil := 'N';
    -- ln_diaatr := ln_diaatr;
    ld_fecha := ld_fchpago; --'24/11/16';
    -- ln_calcod := 30;
    ln_var := 1;
  
    begin
      select f.calcod
        into ln_calcod
        from fst001 f
       where f.pgcod = 1
         and f.sucurs = ln_sucursal;
    exception
      when others then
        null;
    end;
    -- while Flag_habil = 'N' and ld_FEcha <= '01/12/16' and  ln_var <= ln_diaatr loop
    while Flag_habil = 'N' and ld_FEcha > ld_fchcuota and
          ln_var <= ln_diaatr loop
      --//DIA FERIADO -verificar si dia anterior tambien fue feriado
      ld_fecha := ld_fecha - 1;
    
      begin
        select Fhabil
          into Flag_habil
          from FST028
         where calcod = ln_calcod
           and ffecha = ld_fecha;
      end;
      dbms_output.put_line(ld_fecha || ' ' || Flag_habil || ' ' || ln_var || ' ' ||
                           ln_diaatr);
      ln_var := ln_var + 1;
      if flag_habil = 'S' then
        ln_var := 0;
        exit;
      end if;
    
    end loop;
  
  end sp_cr_feriadoOficial;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_inserta(nro_cupon     in number,
                          ln_pgcod      in number,
                          ln_modulo     in number,
                          ln_sucursal   in number,
                          ln_moneda     in number,
                          ln_papel      in number,
                          ln_cuenta     in number,
                          ln_operacion  in number,
                          ln_subope     in number,
                          ln_tope       in number,
                          ln_nrocred    in varchar2,
                          ld_fecha1     in date,
                          pd_fecha      in date,
                          lc_Est        in varchar2,
                          lc_usuario    in varchar2,
                          ln_sucusuario in number,
                          lc_region     in number,
                          lc_Ant        in varchar2,
                          ln_Atr        in varchar2,
                          ln_calific    in number,
                          lc_Tip        in varchar2,
                          lc_EXCUP      in varchar2,
                          JAQL406tsbor  in number,
                          JAQL406tord   in number,
                          JAQL406tnrel  in number,
                          JAQL406ttran  in number,
                          JAQL406tmod   in number,
                          JAQL406tsuc   in number,
                          ld_fecha2     in date,
                          ln_NUMP       in number,
                          ln_CUPNUM     in number,
                          ln_opcion     in number) is
  begin
    begin
      insert into JAQL406
        (JAQL406Cup,
         JAQL406PGC,
         JAQL406Mod,
         JAQL406Suc,
         JAQL406Mda,
         JAQL406PAP,
         JAQL406Cta,
         JAQL406Ope,
         JAQL406Sbo,
         JAQL406Top,
         JAQL406CRE,
         JAQL406FEC,
         JAQL406FOP,
         JAQL406EST,
         JAQL406USR,
         JAQL406AGE,
         JAQL406DPT,
         JAQL406ANT,
         JAQL406ATR,
         JAQL406CAL,
         JAQL406TIP,
         JAQL406EXCUP,
         JAQL406TSBOR,
         JAQL406TORD,
         JAQL406TNREL,
         JAQL406TTRAN,
         JAQL406TMOD,
         JAQL406TSUC,
         JAQL406FCTA,
         JAQL406NUMP,
         JAQL406CUPNUM,
         JAQL406OPC)
      values
        (nro_cupon,
         ln_pgcod,
         ln_modulo,
         ln_sucursal,
         ln_moneda,
         ln_papel,
         ln_cuenta,
         ln_operacion,
         ln_subope,
         ln_tope,
         ln_nrocred,
         ld_fecha1,
         pd_fecha,
         lc_Est,
         lc_usuario,
         ln_sucusuario,
         lc_region,
         lc_Ant,
         ln_Atr,
         ln_calific,
         lc_Tip,
         lc_EXCUP,
         JAQL406tsbor,
         JAQL406tord,
         JAQL406tnrel,
         JAQL406ttran,
         JAQL406tmod,
         JAQL406tsuc,
         ld_fecha2,
         ln_NUMP,
         ln_CUPNUM,
         ln_opcion);
    End;
    COMMIT;
  
  end sp_cr_inserta;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  function fn_Tipo_Doc_SBS(ln_tdoc in number, lc_tndoc in char) return char is
  
    C_TDOCID char(1);
  
  Begin
    Begin
      C_TDOCID := '0';
    
      If ln_tdoc = 21 then
        C_TDOCID := '1';
      End If;
    
      If ln_tdoc = 9 then
        If Length(lc_tndoc) < 11 then
          C_TDOCID := '2';
        End If;
      
        If Length(lc_tndoc) >= 11 then
          C_TDOCID := '3';
        End If;
      End If;
    
      If ln_tdoc = 2 then
        C_TDOCID := '2';
      End If;
    
      If ln_tdoc = 4 then
        C_TDOCID := '3';
      End If;
    
      If ln_tdoc = 15 then
        C_TDOCID := '4';
      End If;
    
      If ln_tdoc = 5 then
        C_TDOCID := '5';
      End If;
    
      If ln_tdoc = 6 then
        C_TDOCID := '8';
      End If;
    End;
    return C_TDOCID;
  end fn_Tipo_Doc_SBS;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_Calif_SBS_Cliente(lc_docsbs in char, lc_tndoc in char)
    return number is
  
    ln_FchSBS  number(8);
    D_FECPRE   varchar2(15);
    ln_dia     number(2);
    ln_Mes     number(2);
    ln_Anio    number(4);
    JAQY774Cal number(10);
    ln_cal0    number(5, 2);
    ln_cal1    number(5, 2);
    ln_cal2    number(5, 2);
    ln_cal3    number(5, 2);
    ln_cal4    number(5, 2);
    D_FECPRE1  date;
    PNDOC      char(12);
  
  Begin
    Begin
      Begin
        select Tpnro
          into ln_FchSBS
          from FST098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      
        ln_dia  := SubStr(ln_FchSBS, 1, 2);
        ln_Mes  := SubStr(ln_FchSBS, 3, 2);
        ln_Anio := SubStr(ln_FchSBS, 5, 4);
      
        D_FECPRE  := ln_dia || '/' || ln_Mes || '/' || ln_Anio;
        D_FECPRE1 := to_date(D_FECPRE, 'dd/mm/rrrr');
        PNDOC     := rpad(lc_tndoc, 12, ' ');
        select N_CALIF0, N_CALIF1, N_CALIF2, N_CALIF3, N_CALIF4
        
          into ln_cal0, ln_cal1, ln_cal2, ln_cal3, ln_cal4
          from CLDRCCI
         where D_FECPRE = D_FECPRE1
           and C_TDOCID = lc_docsbs
           and C_DOCIDE = trim(PNDOC); --lc_tndoc;
      exception
        when too_many_rows then
          begin
            select N_CALIF0, N_CALIF1, N_CALIF2, N_CALIF3, N_CALIF4
              into ln_cal0, ln_cal1, ln_cal2, ln_cal3, ln_cal4
              from CLDRCCI
             where D_FECPRE = D_FECPRE1
               and C_TDOCID = lc_docsbs
               and C_DOCIDE = trim(PNDOC)
               and C_PERSON = 1
               and N_CALIF0 <> 0
               and rownum = 1;
          
          exception
          
            when no_data_found then
              ln_cal0 := 0;
              /* ln_cal1 := 0;
              ln_cal2 := 0;
              ln_cal3 := 0;
              ln_cal4 := 0;*/
          end;
        
        when no_data_found then
          ln_cal0 := 0;
          /*ln_cal1 := 0;
          ln_cal2 := 0;
          ln_cal3 := 0;
          ln_cal4 := 0;*/
      
      end;
    
      If ln_cal0 > 0 then
        JAQY774Cal := 1;
      
      End If;
    
    End;
  
    return JAQY774Cal;
  
  end fn_Calif_SBS_Cliente;

  ---------------------------------------------------------------------
  Procedure sp_cr_cargaCuoIm_job(pc_uing     in varchar2,
                                 pd_fechaIni in date,
                                 pd_fechaFin in date) is
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     ' PQ_CR_NAVIDAD2017_REGULA.sp_cr_buscaPagos(''' || x || '''' || ',' || '''' ||
                     pc_uing || '''' || ',' || '''' || pd_fechaIni || ''''|| ',' || '''' || pd_fechaFin || ''');' ||
                     ' End; ';
    
      ln_job := ln_job + 1;
    
--      if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
IF SYS.FN_BD_ISRAC='TRUE' THEN
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
      commit;
    
    end loop;
  
  end sp_cr_cargaCuoIm_job;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end PQ_CR_NAVIDAD2017_REGULA;
/

