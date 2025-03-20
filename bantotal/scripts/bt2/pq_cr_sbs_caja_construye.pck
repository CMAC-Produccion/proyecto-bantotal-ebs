create or replace package PQ_CR_SBS_CAJA_CONSTRUYE is

  procedure sp_calificacion_tit(pn_ctnro        in number,
                                pn_calificacion out number);

  procedure sp_calificacion_cyg(pn_ctnro        in number,
                                pn_calificacion out number);

  procedure sp_validacion(pn_ctnro in number, pc_indicador out varchar2);

  Procedure Sp_CalculaCuotas_New(pn_emp      in number,
                                 pn_mod      in number,
                                 pn_suc      in number,
                                 pn_mda      in number,
                                 pn_pap      in number,
                                 pn_cta      in number,
                                 pn_ope      in number,
                                 pn_sbo      in number,
                                 pn_top      in number,
                                 pd_fec      in date,
                                 ln_contador out number,
                                 ln_diasTot  out number,
                                 ln_promDia  out number);

  Procedure Sp_Exonerajaqz967(pn_cod    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_ope    in number,
                              pn_sbo    in number,
                              pn_top    in number,
                              pc_prg    in varchar2,
                              lc_existe out varchar2);

  procedure sp_cr_CalMonto_Endeuda_Tit( /*ln_ppais      in number,*/ln_Petdoc     in number,
                                       ln_Pendoc     in varchar2,
                                       ln_deudaTotal out number);

  procedure sp_cr_CalMonto_Endeuda_con(ln_ppais          in number,
                                       ln_Petdoc         in number,
                                       ln_Pendoc         in character,
                                       ln_deudaTotal_con out number);

  procedure sp_cr_Credito_Vuelo(ln_Pepais        in number,
                                ln_Petdoc        in number,
                                ln_Pendoc        in character,
                                ln_tipcambio     in number,
                                ln_saldofinaltit out number);

  procedure sp_cr_Credito_Vuelocon(ln_Pepais        in number,
                                   ln_Petdoc        in number,
                                   ln_Pendoc        in character,
                                   ln_tipcambio     in number,
                                   ln_saldofinalcon out number);

  procedure sp_cr_CalMonto_Tot(ln_Pepais              in number,
                               ln_Petdoc              in number,
                               ln_Pendoc              in character,
                               ln_instancia           in number,
                               ln_total_deudaCalMonto out number,
                               ln_cal_mon_tit         out number,
                               ln_cal_mon_con         out number,
                               ln_vuelo_mon_tit       out number,
                               ln_vuelo_mon_con       out number);

end PQ_CR_SBS_CAJA_CONSTRUYE;
/

create or replace package body PQ_CR_SBS_CAJA_CONSTRUYE is

  procedure sp_calificacion_tit(pn_ctnro        in number,
                                pn_calificacion out number) is
  
    ln_pepais   number;
    ln_petdoc   number;
    lc_pendoc   varchar(12);
    ld_fecrcc   date;
    ln_TipoDni  number(2);
    ln_TipoRuc  number(2);
    ln_TipoCex  number(2);
    lc_C_TDOCID char(1);
    ln_calif    number(5, 2);
    ln_calif1   number(5, 2);
    ln_calif2   number(5, 2);
    ln_calif3   number(5, 2);
    ln_calif4   number(5, 2);
  
  begin
  
    ln_TipoDni := 21;
    ln_TipoRuc := 9;
    ln_TipoCex := 2;
  
    begin
      select a.pepais, a.petdoc, a.pendoc --obtengo dni del cliente
        into ln_pepais, ln_petdoc, lc_pendoc
        from fsr008 a
       where a.pgcod = 1
         and a.ctnro = pn_ctnro
         and a.cttfir = 'T'
         and a.ttcod = 1;
    exception
      when others then
        null;
    end;
  
    lc_pendoc := trim(lc_pendoc);
  
    --fecha RCC     
    begin
      select to_date(Tpnro, 'dd.mm.yyyy')
        into ld_fecrcc
        from Fst098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    end;
  
    if ln_petdoc = ln_TipoDni or ln_petdoc <> ln_TipoRuc then
      If ln_petdoc = ln_TipoDni then
        lc_C_TDOCID := '1';
      End If;
      If ln_petdoc = ln_tipocex then
        lc_C_TDOCID := '2';
      End If;
      If ln_petdoc <> ln_tipodni And ln_petdoc <> ln_tiporuc then
        lc_C_TDOCID := to_char(ln_petdoc);
      End If;
    
      begin
      
        select a.n_calif0, a.n_calif1, a.n_calif2, a.n_calif3, a.n_calif4
          into ln_calif, ln_calif1, ln_calif2, ln_calif3, ln_calif4
          from CLDRCCI a
         Where a.C_TDOCID = lc_C_TDOCID
           and a.C_DOCIDE = lc_pendoc
           and a.D_FECPRE = ld_fecrcc
           and rownum = 1;
      exception
        when no_data_found then
          ln_calif  := 0;
          ln_calif1 := 0;
          ln_calif2 := 0;
          ln_calif3 := 0;
          ln_calif4 := 0;
        
      end;
    
    End If;
  
    If ln_petdoc = ln_tiporuc then
    
      begin
        select a.n_calif0, a.n_calif1, a.n_calif2, a.n_calif3, a.n_calif4
          into ln_calif, ln_calif1, ln_calif2, ln_calif3, ln_calif4
          from CLDRCCI a
         Where a.C_DOCTRI = lc_pendoc
           and a.D_FECPRE = ld_fecrcc
           and rownum = 1;
      exception
        when no_data_found then
          ln_calif  := 0;
          ln_calif1 := 0;
          ln_calif2 := 0;
          ln_calif3 := 0;
          ln_calif4 := 0;
      end;
    End If;
  
    --titular
    if nvl(ln_calif, 0) = 0 and nvl(ln_calif1, 0) = 0 and
       nvl(ln_calif2, 0) = 0 and nvl(ln_calif3, 0) = 0 and
       nvl(ln_calif4, 0) = 0 then
    
      pn_calificacion := 100;
    
    else
      pn_calificacion := ln_calif;
    
    end if;
  
  end sp_calificacion_tit;

  procedure sp_calificacion_cyg(pn_ctnro        in number,
                                pn_calificacion out number) is
  
    ln_pepais   number;
    ln_petdoc   number;
    lc_pendoc   varchar(12);
    ld_fecrcc   date;
    ln_TipoDni  number(2);
    ln_TipoRuc  number(2);
    ln_TipoCex  number(2);
    lc_C_TDOCID char(1);
    ln_calif    number(5, 2);
    ln_calif1   number(5, 2);
    ln_calif2   number(5, 2);
    ln_calif3   number(5, 2);
    ln_calif4   number(5, 2);
    --pn_tdo      number;
  
    ln_petdoc_c number;
    lc_pendoc_c varchar(12);
  
    /*pn_emp    number;
    pn_mod    number;
    pn_suc    number;
    pn_mda    number;
    pn_pap    number;
    pn_cta    number;
    pn_ope    number;
    pn_sbo    number;
    pn_top    number;*/
    --ld_fecdes date;
  
  begin
  
    ln_TipoDni := 21;
    ln_TipoRuc := 9;
    ln_TipoCex := 2;
  
    begin
      select a.pepais, a.petdoc, a.pendoc --obtengo dni del cliente
        into ln_pepais, ln_petdoc, lc_pendoc
        from fsr008 a
       where a.pgcod = 1
         and a.ctnro = pn_ctnro
         and a.cttfir = 'T'
         and a.ttcod = 1;
    
    exception
      when others then
        null;
    end;
  
    --obtener conyuge
    begin
    
      select b.rptdoc, b.rpndoc
        into ln_petdoc_c, lc_pendoc_c
        from fsr002 b
       where b.pepais = Ln_pepais
         and b.petdoc = ln_petdoc
         and b.pendoc = lc_pendoc
         and b.rpccyg = 66;
    
    exception
      when others then
        null;
    end;
  
    lc_pendoc_c := trim(lc_pendoc_c);
  
    --fecha RCC     
    begin
      select to_date(Tpnro, 'dd.mm.yyyy')
        into ld_fecrcc
        from Fst098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    end;
  
    if ln_petdoc_c = ln_TipoDni or ln_petdoc_c <> ln_TipoRuc then
      If ln_petdoc_c = ln_TipoDni then
        lc_C_TDOCID := '1';
      End If;
      If ln_petdoc_c = ln_tipocex then
        lc_C_TDOCID := '2';
      End If;
      If ln_petdoc_c <> ln_tipodni And ln_petdoc_c <> ln_tiporuc then
        lc_C_TDOCID := to_char(ln_petdoc_c);
      End If;
    
      begin
      
        select a.n_calif0, a.n_calif1, a.n_calif2, a.n_calif3, a.n_calif4
          into ln_calif, ln_calif1, ln_calif2, ln_calif3, ln_calif4
          from CLDRCCI a
         Where a.C_TDOCID = lc_C_TDOCID
           and a.C_DOCIDE = lc_pendoc_c
           and a.D_FECPRE = ld_fecrcc
           and rownum = 1;
      exception
        when no_data_found then
          ln_calif  := 0;
          ln_calif1 := 0;
          ln_calif2 := 0;
          ln_calif3 := 0;
          ln_calif4 := 0;
        
      end;
    
    End If;
  
    If ln_petdoc_c = ln_tiporuc then
    
      begin
        select a.n_calif0, a.n_calif1, a.n_calif2, a.n_calif3, a.n_calif4
          into ln_calif, ln_calif1, ln_calif2, ln_calif3, ln_calif4
          from CLDRCCI a
         Where a.C_DOCTRI = lc_pendoc_c
           and a.D_FECPRE = ld_fecrcc
           and rownum = 1;
      exception
        when no_data_found then
          ln_calif  := 0;
          ln_calif1 := 0;
          ln_calif2 := 0;
          ln_calif3 := 0;
          ln_calif4 := 0;
      end;
    End If;
  
    --titular
    if nvl(ln_calif, 0) = 0 and nvl(ln_calif1, 0) = 0 and
       nvl(ln_calif2, 0) = 0 and nvl(ln_calif3, 0) = 0 and
       nvl(ln_calif4, 0) = 0 then
    
      pn_calificacion := 100;
    
    else
      pn_calificacion := ln_calif;
    
    end if;
  
  end sp_calificacion_cyg;

  procedure sp_validacion(pn_ctnro in number, pc_indicador out varchar2) is
  
    ln_calificacion_tit  number;
    ln_calificacion_cony number;
    ln_guia_proces       number;
  
  Begin
  
    begin
      pq_cr_sbs_caja_construye.sp_calificacion_tit(pn_ctnro        => pn_ctnro,
                                                   pn_calificacion => ln_calificacion_tit);
    end;
  
    begin
      pq_cr_sbs_caja_construye.sp_calificacion_cyg(pn_ctnro        => pn_ctnro,
                                                   pn_calificacion => ln_calificacion_cony);
    end;
  
    ------guia de proceso
    begin
    
      select tpnro
        into ln_guia_proces
        from fst098 a
       where a.pgcod = 1
         and a.tpcod = 7720
         and a.tpcorr = 1;
    
    exception
      when others then
        null;
      
    end;
  
    -----------
  
    ---titular y conyuge 
    if ln_calificacion_tit = ln_guia_proces and
       ln_calificacion_cony = ln_guia_proces then
      pc_indicador := 'S';
      -- pc_indicador:='N';--para prueba
    elsif ln_calificacion_tit = ln_guia_proces and
          ln_calificacion_cony is null then
      pc_indicador := 'S';
      -- pc_indicador:='N';--para prueba
    else
      pc_indicador := 'N';
      -- pc_indicador:='N';--para prueba
    End if;
  
    ---solo titular      
  
  end sp_validacion;

  /*
  procedure sp_calcular_retraso(v_Pgfape in date, --fecha de proceso
                                                v_Pgcod  in number,
                                                v_Scmod  in number,
                                                v_Scsuc  in number,
                                                v_Scmda  in number,
                                                v_Scpap  in number,
                                                v_Sccta  in number,
                                                v_Scoper in number,
                                                v_Scsbop in number,
                                                v_Sctope in number,
                                                v_Scstat in number,
                                                v_fecven in date,
                                                v_diaatr out number
                                                ) is
   
   ln_diatr number;
                                          
  Begin
    
   If v_Scmod in (200,33) Then 
  
             ln_diatr := v_Pgfape - v_fecven;
           
          Else 
            
         begin
            --vigente y refinanciado
            SELECT (v_Pgfape - min(a.Ppfpag))
                   into ln_diatr 
            FROM FSD601 a left join FSD602 b
            on
                  b.Pgcod  = a.Pgcod
              and b.Ppmod  = a.Ppmod
              and b.Ppsuc  = a.Ppsuc
              and b.Ppmda  = a.Ppmda
              and b.Pppap  = a.Pppap
              and b.Ppcta  = a.Ppcta
              and b.Ppoper = a.Ppoper
              and b.Ppsbop = a.Ppsbop
              and b.Pptope = a.Pptope
              and b.Ppfpag = a.Ppfpag
              and b.Pptipo = a.Pptipo
              and b.Pp1stat = 'T'
              and b.D602co  = 'S'
              and b.pp1fech<= v_Pgfape
            where
                  a.Pgcod  = v_Pgcod
              and a.Ppmod  = v_Scmod
              and a.Ppsuc  = v_Scsuc
              and a.Ppmda  = v_Scmda
              and a.Pppap  = v_Scpap
              and a.Ppcta  = v_Sccta
              and a.Ppoper = v_Scoper
              and a.Ppsbop = v_Scsbop
              and a.Pptope = v_Sctope
              and a.Ppfpag <= v_Pgfape
              and a.D601co = 'S'
              and (a.ppcap + a.ppint ) > 0 --se agrego por cuotas de gracia 2013.09.06
              and b.D602co is null;
              
        exception
          when no_data_found then
   
   
            Begin
               select (v_Pgfape - min(d.Ppfpag))
               into ln_diatr
               from fsd601 d
               where     d.Pgcod  = v_Pgcod
              and d.Ppmod  = v_Scmod
              and d.Ppsuc  = v_Scsuc
              and d.Ppmda  = v_Scmda
              and d.Pppap  = v_Scpap
              and d.Ppcta  = v_Sccta
              and d.Ppoper = v_Scoper
              and d.Ppsbop = v_Scsbop
              and d.Pptope = v_Sctope
              and d.Ppfpag <= v_Pgfape;
         --     and (d.ppcap + d.ppint ) > 0;
              
            exception
                when no_data_found then
                     ln_diatr := null;
            End;
         
        --end;
      end;
      End IF;
     
          v_diaatr:=NVL(ln_diatr,0);
  
  end sp_calcular_retraso;
  
  
  
  procedure sp_calcular_retraso2(v_fechavening in date,
                                                v_Pgcod  in number,
                                                v_Scmod  in number,
                                                v_Scsuc  in number,
                                                v_Scmda  in number,
                                                v_Scpap  in number,
                                                v_Sccta  in number,
                                                v_Scoper in number,
                                                v_Scsbop in number,
                                                v_Sctope in number,
                                                v_diaatr out number
                                                ) is
   
  ln_diatr number;
  ld_fechaven date;
  v_fecpago date;       
                                  
  Begin
   
          Begin
             
                select              
                   into ld_fechaven
                   from FSD601 a
                     where a.pgcod=v_Pgcod
                     and a.ppmod=v_Scmod
                     and a.ppmda=v_Scmda
                     and a.ppcta=v_Sccta
                     and a.ppoper=v_Scoper
                     and a.ppsbop=v_Scsbop
                     and a.pptope =v_Sctope
                     and a.ppfpag =v_fechavening;
             
                 exception
                    when others then
                      null;
            End;
  
               ln_diatr := ld_fechaven - v_fecpago;
            v_diaatr:=ln_diatr;
          
  
   If v_Scmod in (200,33) Then 
  
             ln_diatr := v_Pgfape - v_fecven;
           
          Else 
            
         begin
            --vigente y refinanciado
            SELECT (v_Pgfape - min(a.Ppfpag))
                   into ln_diatr 
            FROM FSD601 a left join FSD602 b
            on
                  b.Pgcod  = a.Pgcod
              and b.Ppmod  = a.Ppmod
              and b.Ppsuc  = a.Ppsuc
              and b.Ppmda  = a.Ppmda
              and b.Pppap  = a.Pppap
              and b.Ppcta  = a.Ppcta
              and b.Ppoper = a.Ppoper
              and b.Ppsbop = a.Ppsbop
              and b.Pptope = a.Pptope
              and b.Ppfpag = a.Ppfpag
              and b.Pptipo = a.Pptipo
              and b.Pp1stat = 'T'
              and b.D602co  = 'S'
              and b.pp1fech<= v_Pgfape
            where
                  a.Pgcod  = v_Pgcod
              and a.Ppmod  = v_Scmod
              and a.Ppsuc  = v_Scsuc
              and a.Ppmda  = v_Scmda
              and a.Pppap  = v_Scpap
              and a.Ppcta  = v_Sccta
              and a.Ppoper = v_Scoper
              and a.Ppsbop = v_Scsbop
              and a.Pptope = v_Sctope
              and a.Ppfpag <= v_Pgfape
              and a.D601co = 'S'
              and (a.ppcap + a.ppint ) > 0 --se agrego por cuotas de gracia 2013.09.06
              and b.D602co is null;
              
        exception
          when no_data_found then
   
   
            Begin
               select (v_Pgfape - min(d.Ppfpag))
               into ln_diatr
               from fsd601 d
               where     d.Pgcod  = v_Pgcod
              and d.Ppmod  = v_Scmod
              and d.Ppsuc  = v_Scsuc
              and d.Ppmda  = v_Scmda
              and d.Pppap  = v_Scpap
              and d.Ppcta  = v_Sccta
              and d.Ppoper = v_Scoper
              and d.Ppsbop = v_Scsbop
              and d.Pptope = v_Sctope
              and d.Ppfpag <= v_Pgfape;
         --     and (d.ppcap + d.ppint ) > 0;
              
            exception
                when no_data_found then
                     ln_diatr := null;
            End;
         
        --end;
      end;
      End IF;
     
          v_diaatr:=NVL(ln_diatr,0);
  
  end sp_calcular_retraso2;
  */

  Procedure Sp_CalculaCuotas_New(pn_emp      in number,
                                 pn_mod      in number,
                                 pn_suc      in number,
                                 pn_mda      in number,
                                 pn_pap      in number,
                                 pn_cta      in number,
                                 pn_ope      in number,
                                 pn_sbo      in number,
                                 pn_top      in number,
                                 pd_fec      in date,
                                 ln_contador out number,
                                 ln_diasTot  out number,
                                 ln_promDia  out number) is
    cursor creditos is
      select a.pgcod,
             a.ppmod,
             a.ppsuc,
             a.ppmda,
             a.pppap,
             a.ppcta,
             a.ppoper,
             a.ppsbop,
             a.pptope,
             a.ppfpag
      
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
         and a.ppfpag <= pd_fec
         and a.d601co = 'S'
         and (a.ppcap + a.ppint) <> 0;
  
    ln_dias number(10);
  
  begin
  
    begin
      ln_diasTot  := 0;
      ln_contador := 0;
      ln_promDia  := 0;
    
      ln_dias := 0;
    
      For i in creditos loop
      
        ln_contador := ln_contador + 1;
      
        ln_dias    := pq_cr_relcrediticia.fn_cuotasPag(i.pgcod,
                                                       i.ppmod,
                                                       i.ppsuc,
                                                       i.ppmda,
                                                       i.pppap,
                                                       i.ppcta,
                                                       i.ppoper,
                                                       i.ppsbop,
                                                       i.pptope,
                                                       i.ppfpag,
                                                       pd_fec);
        ln_diasTot := ln_diasTot + ln_dias;
      
        ln_promDia := round(ln_diasTot / ln_contador, 0);
      
      end loop;
    
    end;
  
  end Sp_CalculaCuotas_New;

  --------------------
  Procedure Sp_Exonerajaqz967(pn_cod    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_ope    in number,
                              pn_sbo    in number,
                              pn_top    in number,
                              pc_prg    in varchar2,
                              lc_existe out varchar2) is
  
    ln_cont number := 0;
  begin
  
    begin
      select count(*)
        into ln_cont
        from jaqz967 a
       where a.jaqz967cod = pn_cod
         and a.jaqz967mod = pn_mod
         and a.jaqz967suc = pn_suc
         and a.jaqz967mda = pn_mda
         and a.jaqz967pap = pn_pap
         and a.jaqz967cta = pn_cta
         and a.jaqz967ope = pn_ope
         and a.jaqz967sbo = pn_sbo
         and a.jaqz967top = pn_top
         and a.jaqz967prg = pc_prg;
    
    exception
      when others then
        ln_cont := 0;
    end;
  
    if nvl(ln_cont, 0) <> 0 then
      lc_existe := 'S';
    else
      lc_existe := 'N';
    end if;
  
  end Sp_Exonerajaqz967;

  -----------------------------------------------------------------------
  --rmogrovejo 
  -- Verifica si el cliente a aumentado su deuda Pyme en los ultimos 4 meses RCC
  procedure sp_cr_CalMonto_Endeuda_Tit( /*ln_ppais      in number,*/ln_Petdoc     in number,
                                       ln_Pendoc     in varchar2,
                                       ln_deudaTotal out number) is
  
    ln_FchRCC number;
    D_FECPRE  varchar2(10);
    D_FECPRE1 date;
    ln_dia    number;
    ln_Mes    number;
    ln_Anio   number;
    -- ld_MesVerifica       date;
    --ln_meses             number;
    lc_codsbs   varchar2(10);
    ln_capital1 number;
    ln_capital2 number;
    lc_C_TDOCID varchar2(2);
    --ln_EndeudamientoAux  number := 0;
    ln_Endeudamiento number := 0;
    -- ln_Endeudamiento_con number := 0;
    --ln_pendoc_c          number;
    --ln_petdoc_c          number;
    --lc_codsbs_cny        number;
    --ln_capital1_con      number;
  
  begin
  
    begin
      -- Fecha RCC  ----31012017
      select Tpnro
        into ln_FchRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    
      ln_dia  := SubStr(ln_FchRCC, 1, 2);
      ln_Mes  := SubStr(ln_FchRCC, 3, 2);
      ln_Anio := SubStr(ln_FchRCC, 5, 4);
    
      D_FECPRE  := ln_dia || '/' || ln_Mes || '/' || ln_Anio;
      D_FECPRE1 := to_date(D_FECPRE, 'dd/mm/rrrr');
    
    end;
  
    pq_cr_resolutores_navdd2017.sp_Tipo_Doc_SBS(ln_Petdoc,
                                                ln_Pendoc,
                                                lc_C_TDOCID);
  
    begin
      select C_CODSBS -- para sacar el CodSBS
        into lc_codsbs
        from cldrcci
       where /*D_FECPRE = D_FECPRE1
                                                                                 and */
       c_docide = ln_Pendoc
       and C_TDOCID = lc_C_TDOCID
      
       and rownum = 1;
    exception
      when others then
        null;
    end;
  
    --ln_EndeudamientoAux := ln_Endeudamiento;
  
    begin
      select nvl(sum(case
                       when substr(C_CUENTA, 1, 4) in
                            (1411,
                             1413,
                             1414,
                             1415,
                             1416,
                             1421,
                             1423,
                             1424,
                             1425,
                             1426,
                             7111,
                             7112,
                             7113,
                             7114,
                             7121,
                             7122,
                             7123,
                             7124) then
                        N_SALCAP
                     end),
                 0)
        into ln_capital1
        from CLDRCCS
       where D_FECPRE = D_FECPRE1 --ld_MesVerifica
         and c_codsbs = lc_codsbs
      /*   and C_CRETIP in (select trim(tp1desc)
       from FST198
      Where Tp1cod = 1
        and Tp1cod1 = 10871
        and Tp1corr1 = 7
        and tp1corr2 = 14)*/
      ; --  Micro y Pequeña Empresa
    
    end;
  
    begin
      select nvl(sum(case
                       when substr(C_CUENTA, 1, 6) in
                            (291101, 291102, 291104, 292101, 292102, 292104) then
                        N_SALCAP
                     end),
                 0)
        into ln_capital2
        from CLDRCCS
       where D_FECPRE = D_FECPRE1
         and c_codsbs = lc_codsbs
         and C_TIPREG = 2
         and C_TIPDET = 'Z';
    end;
  
    ln_Endeudamiento := ln_capital1 - ln_capital2;
    /* 
      -------------------------------conyuge        
      begin
        select b.rptdoc, b.rpndoc ---obtengo dni de conyugue
          into ln_petdoc_c, ln_pendoc_c
          from fsr002 b
         where b.pepais = ln_ppais
           and b.petdoc = ln_petdoc
           and b.pendoc = ln_Pendoc
           and b.rpccyg = 66;
      
      exception
        when others then
          null;
      end;
    
      begin
        select C_CODSBS -- para sacar el CodSBS  conyuge
          into lc_codsbs_cny
          from cldrcci
         where D_FECPRE = D_FECPRE1
           and c_docide = ln_pendoc_c
           and C_TDOCID = ln_petdoc_c
           and rownum = 1;
      exception
        when others then
          null;
      end;
    
      begin
        select nvl(sum(case
                         when substr(C_CUENTA, 1, 4) in
                              (1411,
                               1413,
                               1414,
                               1415,
                               1416,
                               1421,
                               1423,
                               1424,
                               1425,
                               1426,
                               7111,
                               7112,
                               7113,
                               7114,
                               7121,
                               7122,
                               7123,
                               7124) then
                          N_SALCAP
                       end),
                   0)
          into ln_capital1_con
          from CLDRCCS
         where D_FECPRE = D_FECPRE1 --ld_MesVerifica
           and c_codsbs = lc_codsbs_cny; --  Micro y Pequeña Empresa   
      exception
        when others then
          null;
      end;
    
      begin
        select nvl(sum(case
                         when substr(C_CUENTA, 1, 6) in
                              (291101, 291102, 291104, 292101, 292102, 292104) then
                          N_SALCAP
                       end),
                   0)
          into ln_capital2
          from CLDRCCS
         where D_FECPRE = ld_MesVerifica
           and c_codsbs = lc_codsbs
           and C_TIPREG = 2
           and C_TIPDET = 'Z';
      end;
    
      ln_Endeudamiento_con := ln_capital1 - ln_capital2;
    
    */
    ln_deudaTotal := ln_Endeudamiento; --+ ln_Endeudamiento_con;
  
  end sp_cr_CalMonto_Endeuda_Tit;
  ------------------------------------------------------------------

  -----------------------------------------------------------------------
  --rmogrovejo 
  -- Verifica si el cliente a aumentado su deuda Pyme en los ultimos 4 meses RCC
  procedure sp_cr_CalMonto_Endeuda_con(ln_ppais          in number,
                                       ln_Petdoc         in number,
                                       ln_Pendoc         in character,
                                       ln_deudaTotal_con out number) is
  
    ln_FchRCC number;
    D_FECPRE  varchar2(10);
    D_FECPRE1 date;
    ln_dia    number;
    ln_Mes    number;
    ln_Anio   number;
    --ld_MesVerifica       date;
    -- ln_meses             number;
    --lc_codsbs            varchar2(10);
    --ln_capital1          number;
    --ln_capital2          number;
    ln_capital2_con number;
    lc_C_TDOCID     varchar2(2);
    --ln_EndeudamientoAux  number := 0;
    --ln_Endeudamiento     number := 0;
    ln_Endeudamiento_con number := 0;
    ln_pendoc_c          fsd001.pendoc%TYPE;
    ln_petdoc_c          number;
    lc_codsbs_cny        varchar2(12);
    ln_capital1_con      number;
  
  begin
  
    begin
      -- Fecha RCC  ----31012017
      select Tpnro
        into ln_FchRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    
      ln_dia  := SubStr(ln_FchRCC, 1, 2);
      ln_Mes  := SubStr(ln_FchRCC, 3, 2);
      ln_Anio := SubStr(ln_FchRCC, 5, 4);
    
      D_FECPRE  := ln_dia || '/' || ln_Mes || '/' || ln_Anio;
      D_FECPRE1 := to_date(D_FECPRE, 'dd/mm/rrrr');
    
    end;
  
    begin
      select b.rptdoc, b.rpndoc ---obtengo dni de conyugue
        into ln_petdoc_c, ln_pendoc_c
        from fsr002 b 
       where b.pepais = ln_ppais
         and b.petdoc = ln_petdoc
         and b.pendoc = ln_Pendoc
         and b.rpccyg = 66;
    
    exception
      when others then
        null;
    end;
  
    /* begin
      select C_CODSBS -- para sacar el CodSBS  conyuge
        into lc_codsbs_cny
        from cldrcci
       where \*D_FECPRE = D_FECPRE1
         and*\ c_docide = ln_pendoc_c
         and C_TDOCID = ln_petdoc_c
         and rownum = 1;
    exception
      when others then
        null;
    end;*/
  
    pq_cr_resolutores_navdd2017.sp_Tipo_Doc_SBS(ln_petdoc_c,
                                                ln_pendoc_c,
                                                lc_C_TDOCID);
  
    begin
      select C_CODSBS -- para sacar el CodSBS
        into lc_codsbs_cny
        from cldrcci
       where c_docide = trim(ln_pendoc_c)
         and C_TDOCID = lc_C_TDOCID
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select nvl(sum(case
                       when substr(C_CUENTA, 1, 4) in
                            (1411,
                             1413,
                             1414,
                             1415,
                             1416,
                             1421,
                             1423,
                             1424,
                             1425,
                             1426,
                             7111,
                             7112,
                             7113,
                             7114,
                             7121,
                             7122,
                             7123,
                             7124) then
                        N_SALCAP
                     end),
                 0)
        into ln_capital1_con
        from CLDRCCS
       where D_FECPRE = D_FECPRE1 --ld_MesVerifica
         and c_codsbs = lc_codsbs_cny; --  Micro y Pequeña Empresa   
    exception
      when others then
        null;
    end;
  
    begin
      select nvl(sum(case
                       when substr(C_CUENTA, 1, 6) in
                            (291101, 291102, 291104, 292101, 292102, 292104) then
                        N_SALCAP
                     end),
                 0)
        into ln_capital2_con
        from CLDRCCS
       where D_FECPRE = D_FECPRE1
         and c_codsbs = lc_codsbs_cny
         and C_TIPREG = 2
         and C_TIPDET = 'Z';
    end;
  
    ln_Endeudamiento_con := ln_capital1_con - ln_capital2_con;
  
    ln_deudaTotal_con := ln_Endeudamiento_con;
  
  end sp_cr_CalMonto_Endeuda_con;
  ---------------------------------------------------------------------
  procedure sp_cr_Credito_Vuelo(ln_Pepais        in number,
                                ln_Petdoc        in number,
                                ln_Pendoc        in character,
                                ln_tipcambio     in number,
                                ln_saldofinaltit out number) is
  
    cursor vuelo is
    
      select x.xwfempresa ln_pgcod10,
             x.xwfmodulo ln_mod10,
             x.xwfsucursal ln_suc10,
             x.xwfmoneda ln_mda10,
             x.xwfpapel ln_pap10,
             x.xwfcuenta ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope ln_sbop10,
             x.xwftipope ln_tope10,
             x.xwfprcins Instancia,
             max(s.sng120per) ln_peri10
        from xwf700 x, sng120 s
       where x.xwfempresa =1--rms        
       and x.xwfcuenta in (select Ctnro
                             from fsr008
                            where pgcod=1 
                              and pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc)
            
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select a.tp1nro1
                                       from fst198 a
                                      where a.tp1cod=1 --rms
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 2))) or
             x.xwfmodulo in (117, 141))
            
         and X.XWFPRCINS in
             (select wf.wfinsprcid
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
         and s.sng120ins = X.XWFPRCINS
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
  
    ln_saldocap number := 0;
  
  begin
    ln_saldofinaltit := 0;
    for c in vuelo loop
    
      Begin
        select w.xwfmonto1
          into ln_saldocap
          from xwf700 w
         where w.xwfprcins = c.Instancia
           and w.xwfcar3 = '1';
      
      end;
    
      if c.ln_mda10 = 101 then
        ln_saldocap := ln_saldocap * ln_tipcambio;
      end if;
    
      ln_saldofinaltit := ln_saldofinaltit + ln_saldocap;
    
    end loop;
  
  end sp_cr_Credito_Vuelo;
  ---------------------------------------------------------------
  procedure sp_cr_Credito_Vuelocon(ln_Pepais        in number,
                                   ln_Petdoc        in number,
                                   ln_Pendoc        in character,
                                   ln_tipcambio     in number,
                                   ln_saldofinalcon out number) is
  
    cursor vuelo(ln_pepais_c in number,
                 ln_petdoc_c in number,
                 ln_pendoc_c in character) is
    
      select x.xwfempresa ln_pgcod10,
             x.xwfmodulo ln_mod10,
             x.xwfsucursal ln_suc10,
             x.xwfmoneda ln_mda10,
             x.xwfpapel ln_pap10,
             x.xwfcuenta ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope ln_sbop10,
             x.xwftipope ln_tope10,
             x.xwfprcins Instancia,
             max(s.sng120per) ln_peri10
        from xwf700 x, sng120 s
       where x.xwfempresa =1--rms    
       and x.xwfcuenta in (select Ctnro
                             from fsr008
                            where pgcod=1 --rms
                              and pepais = ln_pepais_c
                              and Petdoc = ln_petdoc_c
                              and pendoc = ln_pendoc_c
                              and cttfir = 'T')--rms 14-12-2017
            
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select a.tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1--rms
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 2))) or
             xwfmodulo in (117, 141))
            
         and x.XWFPRCINS in
             (select wf.wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                 and wf.wfiteminit =
                     (select max(w.wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                         and w.wfitemstsact = 1
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
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
  
    ln_saldocap number := 0;
    ln_pepais_c number;
    ln_petdoc_c number;
    ln_pendoc_c varchar2(12);
  
  begin
    ln_saldofinalcon := 0;
  
    begin
      select b.pepais, b.rptdoc, b.rpndoc ---obtengo dni de conyugue
        into ln_pepais_c, ln_petdoc_c, ln_pendoc_c
        from fsr002 b
       where b.pepais = ln_Pepais
         and b.petdoc = ln_Petdoc
         and b.pendoc = ln_Pendoc
         and b.rpccyg = 66;
    
    exception
      when others then
        null;
    end;
  
    for c in vuelo(ln_pepais_c, ln_petdoc_c, ln_pendoc_c) loop
    
      Begin
        select w.xwfmonto1
          into ln_saldocap
          from xwf700 w
         where xwfempresa =1--rms  
           and w.xwfprcins = c.Instancia
           and w.xwfcar3 = '1';
      
      end;
    
      if c.ln_mda10 = 101 then
        ln_saldocap := ln_saldocap * ln_tipcambio;
      end if;
    
      ln_saldofinalcon := ln_saldofinalcon + ln_saldocap;
    
    end loop;
  
  end sp_cr_Credito_Vuelocon;
  -------------------------------------------------------------------------
  procedure sp_cr_CalMonto_Tot(ln_Pepais              in number,
                               ln_Petdoc              in number,
                               ln_Pendoc              in character,
                               ln_instancia           in number,
                               ln_total_deudaCalMonto out number,
                               ln_cal_mon_tit         out number,
                               ln_cal_mon_con         out number,
                               ln_vuelo_mon_tit       out number,
                               ln_vuelo_mon_con       out number) is
  
    --ln_guia_proces_monto number;
    ld_fecha     date;
    ln_tipcambio number;
  
  Begin
  
    ln_cal_mon_tit   := 0;
    ln_cal_mon_con   := 0;
    ln_vuelo_mon_tit := 0;
    ln_vuelo_mon_con := 0;
  
    begin
      begin
        -- fecha del sistema
        select pgfape into ld_fecha from fst017 where pgcod = 1;
      end;
    
      begin
        --tipo de cambio
        select SNG120TCBI
          into ln_tipcambio
          from sng120
         where sng120ins = ln_instancia
           and sng120tsk = 'EVALUACION';
      Exception
        when others then
          ln_tipcambio := 0.000;
      End;
    
      if ln_tipcambio <= 0 then
        begin
          select cotcbi
            into ln_tipcambio
            from (select cotcbi
                    from fsh005
                   where cofdes <= ld_fecha
                     and moneda = 101
                     and cotcbi > 0
                   order by cofdes desc)
           where rownum = 1;
        
        end;
      end if;
    end;
  
    begin
      -- Call the procedure
      pq_cr_sbs_caja_construye.sp_cr_calmonto_endeuda_tit(/*ln_ppais      => ln_Pepais,*/
                                                          ln_petdoc     => ln_petdoc,
                                                          ln_pendoc     => ln_pendoc,
                                                          ln_deudatotal => ln_cal_mon_tit);
    end;
  
    begin
      -- Call the procedure
      pq_cr_sbs_caja_construye.sp_cr_calmonto_endeuda_con(ln_ppais          => ln_Pepais,
                                                          ln_petdoc         => ln_petdoc,
                                                          ln_pendoc         => ln_pendoc,
                                                          ln_deudatotal_con => ln_cal_mon_con);
    end;
  
    begin
      -- Call the procedure
      pq_cr_sbs_caja_construye.sp_cr_credito_vuelo(ln_pepais        => ln_pepais,
                                                   ln_petdoc        => ln_petdoc,
                                                   ln_pendoc        => ln_pendoc,
                                                   ln_tipcambio     => ln_tipcambio,
                                                   ln_saldofinaltit => ln_vuelo_mon_tit);
    end;
  
    begin
      -- Call the procedure
      pq_cr_sbs_caja_construye.sp_cr_credito_vuelocon(ln_pepais        => ln_pepais,
                                                      ln_petdoc        => ln_petdoc,
                                                      ln_pendoc        => ln_pendoc,
                                                      ln_tipcambio     => ln_tipcambio,
                                                      ln_saldofinalcon => ln_vuelo_mon_con);
    end;
  
    ln_total_deudaCalMonto := nvl(ln_cal_mon_tit, 0) +
                              nvl(ln_cal_mon_con, 0) +
                              nvl(ln_vuelo_mon_tit, 0) +
                              nvl(ln_vuelo_mon_con, 0);
  
  end sp_cr_CalMonto_Tot;

end PQ_CR_SBS_CAJA_CONSTRUYE;
/

