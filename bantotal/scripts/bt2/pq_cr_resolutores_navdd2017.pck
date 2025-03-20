create or replace package PQ_CR_RESOLUTORES_NAVDD2017 is
  -- *****************************************************************
  -- Nombre                     : Resolutores Campaña Navidad 2017
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 26/09/2017 09:24:31 a.m.
  -- Autor de Creación          : MPOSTIGOC 
  -- Uso                        : Resolutores para la campaña Navidad 2017
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   :  
  -- Descripción de Modificación: 
  -- *****************************************************************

  procedure sp_cr_FchRCCFlujo(ln_instancia in number,
                              lc_Grabado   out varchar2);
  -----------------------------------------------------------                              
  procedure sp_cr_Segmento(ln_pais    in number,
                           ln_petdoc  in number,
                           lc_pendoc  in varchar2,
                           lc_Segmnto out varchar2);
  -----------------------------------------------------------------
  procedure sp_cr_NroCredPyme(ln_Pepais      in number,
                              ln_Petdoc      in number,
                              ln_Pendoc      in char,
                              pd_fecpro      in date,
                              ln_NroCreditos out number);
  -----------------------------------------------------------------------

  Procedure Sp_Adicional_CK(pn_mod  in number,
                            pn_top  in number,
                            Pc_flag out varchar2);
  ---------------------------------------------------------------------
  procedure sp_cr_VerificaRubro(ln_pgcod10 in number,
                                ln_mod10   in number,
                                ln_suc10   in number,
                                ln_mda10   in number,
                                ln_pap10   in number,
                                ln_cta10   in number,
                                ln_oper10  in number,
                                ln_sbop    in number,
                                ln_tope10  in number,
                                flag_rubro out varchar2);
  -----------------------------------------------------------------

  procedure sp_cr_IncremntDeudaPyme(ln_Petdoc         in number,
                                    ln_Pendoc         in varchar2,
                                    lc_IncrementoPyme out varchar2);
  --------------------------------------------------------------
  procedure sp_Tipo_Doc_SBS(ln_tdoc  in number,
                            lc_tndoc in varchar2,
                            C_TDOCID out varchar);

end PQ_CR_RESOLUTORES_NAVDD2017;
/

create or replace package body PQ_CR_RESOLUTORES_NAVDD2017 is

  -- Graba fecha RCC por cada parte del flujo para cada instancia

  procedure sp_cr_FchRCCFlujo(ln_instancia in number,
                              lc_Grabado   out varchar2) is
  
    ln_FchRCC      number;
    D_FECPRE       varchar2(10);
    D_FECPRE1      date;
    ln_dia         number;
    ln_Mes         number;
    ln_Anio        number;
    ln_InstFlujo   number;
    lc_Usuario     varchar2(30);
    lc_Flujo       number;
    ld_fecha       date;
    ln_correlativo number;
    ld_FechaFlujo  date;
    lc_existe      varchar2(2) := 'N';
  
  begin
  
    begin
      -- Datos del Flujo
      select w.wfinsprcid, w.wfitemusrcod, w.wftaskcod, w.wfiteminit
        into ln_InstFlujo, lc_Usuario, lc_Flujo, ld_fecha
        from wfwrkitems w
       where w.wfinsprcid = ln_instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
    end;
  
    begin
      -- Fecha RCC
    
      begin
        select Tpnro
          into ln_FchRCC
          from FST098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      exception
        when others then
          ln_FchRCC := 0;
      end;
    
      ln_dia  := SubStr(ln_FchRCC, 1, 2);
      ln_Mes  := SubStr(ln_FchRCC, 3, 2);
      ln_Anio := SubStr(ln_FchRCC, 5, 4);
    
      D_FECPRE  := ln_dia || '/' || ln_Mes || '/' || ln_Anio;
      D_FECPRE1 := to_date(D_FECPRE, 'dd/mm/rrrr');
    end;
  
    begin
    
      --ld_FechaFlujo := to_date(ld_fecha, 'dd/mm/rrrr');
      ld_FechaFlujo := trunc(ld_fecha);
    
      begin
      
        select 'S'
          into lc_existe
          from jaqz814 j
         where j.jaqz814instancia = ln_InstFlujo
           and j.jaqz814codflujo = lc_Flujo;
      exception
        when no_data_found then
          lc_existe := 'N';
          commit;
        
      end;
    
      if lc_existe = 'S' then
      
        begin
        
          update jaqz814 j
             set j.jaqz814fechaflujo = ld_fecha
           where j.jaqz814instancia = ln_InstFlujo
             and j.jaqz814codflujo = lc_Flujo;
          commit;
        
        end;
      
      else
        if lc_existe = 'N' then
        
          begin
          
            select /*+index(jaqz814 JAQZ8143)*/
             max(jaqz814corr)
              into ln_correlativo
              from jaqz814
             where jaqz814fecha = ld_FechaFlujo;
          exception
            when others then
              ln_correlativo := 0;
          end;
        
          ln_correlativo := nvl(ln_correlativo, 0);
        
          if ln_InstFlujo <> 0 then
            
          if lc_Usuario is null then -- MPOSTIGOC 29042020 INC2510
            lc_Usuario:='USRMOVIL';
          end if; -- MPOSTIGOC 29042020 INC2510
          
            begin
              insert into jaqz814
                (jaqz814corr,
                 jaqz814instancia,
                 jaqz814usuario,
                 jaqz814codflujo,
                 jaqz814fechaflujo,
                 jaqz814fecharcc,
                 jaqz814fecha)
              values
                (ln_correlativo + 1,
                 ln_InstFlujo,
                 lc_Usuario,
                 lc_Flujo,
                 ld_fecha,
                 D_FECPRE1,
                 ld_FechaFlujo);
              commit;
            end;
          
          end if;
        
        end if;
      end if;
    
      lc_Grabado := 'S';
    
    end;
  
  end;

  -----------------------------------------------------------------------
  -- verifica que el cliente tenga el segmento 30(parametrizable) en los ultimos 12 meses

  procedure sp_cr_Segmento(ln_pais    in number,
                           ln_petdoc  in number,
                           lc_pendoc  in varchar2,
                           lc_Segmnto out varchar2) is
  
    ld_fchsist         date;
    ln_meses           number;
    i                  number := 1;
    ld_MesVerifica     date;
    ln_Segmento        number;
    ln_SegmentoCliente number;
    lc_pendoc1         jaqy066.jaqy066tndoc%type; -- character(20);
  
  begin
  
    lc_pendoc1 := lc_pendoc;
  
    begin
      select pgfape into ld_fchsist from fst017 where pgcod = 1;
    end;
  
    begin
      -- Nro de Meses a Verificar
      select tp1nro3
        into ln_meses
        from FST198
       Where Tp1cod = 1
         and Tp1cod1 = 10871
         and Tp1corr1 = 7
         and tp1corr2 = 13
         and tp1corr3 = 1;
    exception
      when others then
        ln_meses := 0;
    end;
  
    begin
      -- Segmento a Verificar
      select tp1nro3
        into ln_Segmento
        from FST198
       Where Tp1cod = 1
         and Tp1cod1 = 10871
         and Tp1corr1 = 7
         and tp1corr2 = 13
         and tp1corr3 = 2;
    exception
      when others then
        ln_Segmento := 0;
    end;
  
    while i <= ln_meses loop
    
      ld_MesVerifica := last_day(ADD_MONTHS(ld_fchsist, - (i)));
    
      begin
        select j.jaqy066calf
          into ln_SegmentoCliente
          from jaqy066 j
         where j.jaqy066paic = ln_pais
           and j.jaqy066tdoc = ln_petdoc
           and j.jaqy066tndoc = lc_pendoc1
           and j.jaqy066fecp = ld_MesVerifica;
      exception
        when others then
          ln_SegmentoCliente := 0;
        
      end;
    
      if ln_SegmentoCliente = ln_Segmento then
        i          := i + 1;
        lc_Segmnto := 'S';
      else
        if ln_SegmentoCliente <> ln_Segmento then
          lc_Segmnto := 'N';
          exit;
        end if;
      end if;
    end loop;
  
  end sp_cr_Segmento;
  -----------------------------------------------------------------------
  --Extrae el nro de Creditos Pyme que tiene el cliente en la caja
  procedure sp_cr_NroCredPyme(ln_Pepais      in number,
                              ln_Petdoc      in number,
                              ln_Pendoc      in char,
                              pd_fecpro      in date,
                              ln_NroCreditos out number) is
  
    cursor inserta is
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
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc)
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 2))) or
             d10.Aomod in (141))
         and d10.Aostat <> 99;
  
    cursor linea is
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
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc)
         and d10.Aomod = 117
         and d10.Aostat <> 99
         and d10.aofvto > pd_fecpro;
  
    cursor lineas_ven is
    
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
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc)
         and d10.Aomod = 117
         and d10.aofvto < pd_fecpro;
  
    lc_fgAdic varchar2(2);
    lc_fgAmpl varchar2(2);
    --lc_fgRefLin varchar2(2);
    -- lc_fgRepro  varchar2(2);
    --  lc_FlgLn    varchar2(2);
    lc_ven     varchar2(2);
    flag_rubro varchar2(2);
  
  begin
  
    ln_NroCreditos := 0;
  
    for i in inserta loop
    
      lc_fgAdic := null;
      lc_fgAmpl := null;
    
      pq_cr_resolutores_navdd2017.sp_cr_VerificaRubro(i.ln_pgcod10,
                                                      i.ln_mod10,
                                                      i.ln_suc10,
                                                      i.ln_mda10,
                                                      i.ln_pap10,
                                                      i.ln_cta10,
                                                      i.ln_oper10,
                                                      i.ln_sbop10,
                                                      i.ln_tope10,
                                                      flag_rubro);
    
      if flag_rubro = 'S' then
      
        ln_NroCreditos := ln_NroCreditos + 1;
      
      end if;
    
    end loop;
  
    for l in linea loop
    
      pq_cr_resolutor_cappago.Sp_Adicional_CK(l.ln_mod10,
                                              l.ln_tope10,
                                              lc_fgAdic);
    
      if lc_fgAdic <> 'S' then
        pq_cr_resolutores_navdd2017.sp_cr_VerificaRubro(l.ln_pgcod10,
                                                        l.ln_mod10,
                                                        l.ln_suc10,
                                                        l.ln_mda10,
                                                        l.ln_pap10,
                                                        l.ln_cta10,
                                                        l.ln_oper10,
                                                        l.ln_sbop10,
                                                        l.ln_tope10,
                                                        flag_rubro);
      
        if flag_rubro = 'S' then
        
          ln_NroCreditos := ln_NroCreditos + 1;
        
        end if;
      end if;
    
    end loop;
  
    for j in lineas_ven loop
    
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
    
      pq_cr_resolutor_cappago.Sp_Adicional_CK(j.ln_mod10,
                                              j.ln_tope10,
                                              lc_fgAdic);
    
      if lc_ven = 'S' and lc_fgAdic <> 'S' then
        pq_cr_resolutores_navdd2017.sp_cr_VerificaRubro(j.ln_pgcod10,
                                                        j.ln_mod10,
                                                        j.ln_suc10,
                                                        j.ln_mda10,
                                                        j.ln_pap10,
                                                        j.ln_cta10,
                                                        j.ln_oper10,
                                                        j.ln_sbop10,
                                                        j.ln_tope10,
                                                        flag_rubro);
      
        if flag_rubro = 'S' then
        
          ln_NroCreditos := ln_NroCreditos + 1;
        
        end if;
      end if;
    
    end loop;
  
    ln_NroCreditos := nvl(ln_NroCreditos, 0);
  
  end sp_cr_NroCredPyme;

  --------------------------------------------------------------------------

  Procedure Sp_Adicional_CK(pn_mod  in number,
                            pn_top  in number,
                            Pc_flag out varchar2) is
  
  begin
    if pn_mod = 117 then
      begin
        select 'S'
          into Pc_flag
          from fst198 a
         where a.tp1cod1 = 20001
           and a.tp1corr1 = 1
           and a.tp1corr2 = 1211
           and a.tp1nro1 = pn_top;
      
      exception
        when no_data_found then
          Pc_flag := 'N';
      end;
    else
      Pc_flag := 'N';
    end if;
  
  end Sp_Adicional_CK;

  -------------------------------------------------------------------------
  procedure sp_cr_VerificaRubro(ln_pgcod10 in number,
                                ln_mod10   in number,
                                ln_suc10   in number,
                                ln_mda10   in number,
                                ln_pap10   in number,
                                ln_cta10   in number,
                                ln_oper10  in number,
                                ln_sbop    in number,
                                ln_tope10  in number,
                                flag_rubro out varchar2) is
  
    ln_rubro  number;
    ln_digito varchar2(4);
    --  flag_rubro varchar2(2);
  begin
    begin
    
      select scrub
        into ln_rubro
        from fsd011
       where PGCOD = ln_pgcod10
         and SCMOD = ln_mod10
         and SCMDA = ln_mda10
         and SCPAP = ln_pap10
         and SCCTA = ln_cta10
         and SCSUC = ln_suc10
         and SCOPER = ln_oper10
         and scsbop = ln_sbop
         and sctope = ln_tope10
         and scstat <> 99;
    exception
      when others then
        null;
    end;
  
    if ln_rubro is null then
    
      begin
        -- Rubro de la Solicitud en Vuelo
        select to_number(ww.pp028defc)
          into ln_rubro
          from fpp028 ww
         where ww.pp017par = 115
           and ww.pp028mod = ln_mod10
           and ww.pp028top = ln_tope10
           and ww.pp028emp = ln_pgcod10
           and ww.pp028mda = ln_mda10
           and ww.pp028pap = ln_pap10;
      exception
        when others then
          null;
      end;
    
    end if;
  
    begin
      -- rubro
      if ln_mod10 <> 117 then
      
        SELECT SUBSTR(to_char(ln_rubro), 5, 2) into ln_digito FROM DUAL;
      
      else
        if ln_mod10 = 117 then
        
          SELECT SUBSTR(to_char(ln_rubro), 7, 2) into ln_digito FROM DUAL;
        
        end if;
      end if;
    
    end;
  
    begin
      select 'S'
        into flag_rubro
        from fst198 a
       where a.tp1cod1 = 10899
         and a.tp1corr1 = 17
         and a.tp1corr2 = 3
         and trim(a.tp1desc) = ln_digito;
    exception
      when no_data_found then
        flag_rubro := 'N';
    end;
  
  end sp_cr_VerificaRubro;

  ------------------------------------------------------------------------
  -- Verifica si el cliente a aumentado su deuda Pyme en los ultimos 4 meses RCC
  procedure sp_cr_IncremntDeudaPyme(ln_Petdoc         in number,
                                    ln_Pendoc         in varchar2,
                                    lc_IncrementoPyme out varchar2) is
  
    ln_FchRCC           number;
    D_FECPRE            varchar2(10);
    D_FECPRE1           date;
    ln_dia              number;
    ln_Mes              number;
    ln_Anio             number;
    ld_MesVerifica      date;
    ln_meses            number;
    lc_codsbs           varchar2(10);
    ln_capital1         number;
    ln_capital2         number;
    lc_C_TDOCID         varchar2(2);
    ln_EndeudamientoAux number := 0;
    ln_Endeudamiento    number := 0;
  
  begin
  
    begin
      -- Fecha RCC
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
    
      -- Nro de Meses a Verificar
      select tp1nro3
        into ln_meses
        from FST198
       Where Tp1cod = 1
         and Tp1cod1 = 10871
         and Tp1corr1 = 7
         and tp1corr2 = 13
         and tp1corr3 = 3;
    exception
      when others then
        ln_meses := 0;
    end;
  
    pq_cr_resolutores_navdd2017.sp_Tipo_Doc_SBS(ln_Petdoc,
                                                ln_Pendoc,
                                                lc_C_TDOCID);
  
    begin
      select C_CODSBS -- para sacar el CodSBS
        into lc_codsbs
        from cldrcci
       where c_docide = ln_Pendoc
         and C_TDOCID = lc_C_TDOCID
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    while ln_meses >= 0 loop
    
      ld_MesVerifica      := last_day(ADD_MONTHS(D_FECPRE1, - (ln_meses)));
      ln_EndeudamientoAux := ln_Endeudamiento;
    
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
         where D_FECPRE = ld_MesVerifica
           and c_codsbs = lc_codsbs
           and C_CRETIP in (select trim(tp1desc)
                              from FST198
                             Where Tp1cod = 1
                               and Tp1cod1 = 10871
                               and Tp1corr1 = 7
                               and tp1corr2 = 14); --  Micro y Pequeña Empresa
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
      exception
        when others then
          null;
      end;
    
      ln_Endeudamiento := nvl(ln_capital1, 0) - nvl(ln_capital2, 0);
    
      if ln_Endeudamiento > 0 and ln_EndeudamientoAux > 0 then
        if ln_Endeudamiento > ln_EndeudamientoAux then
        
          lc_IncrementoPyme := 'S';
          exit;
        else
          lc_IncrementoPyme := 'N';
          ln_meses          := ln_meses - 1;
        end if;
      
      else
      
        lc_IncrementoPyme := 'N';
        ln_meses          := ln_meses - 1;
      
      end if;
    
    end loop;
  
  end sp_cr_IncremntDeudaPyme;
  ------------------------------------------------------------------------
  procedure sp_Tipo_Doc_SBS(ln_tdoc  in number,
                            lc_tndoc in varchar2,
                            C_TDOCID out varchar) is
  
    --  C_TDOCID char(1);
  
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
    
      if C_TDOCID = '0' then
      
        If ln_tdoc = 2 then
          C_TDOCID := '2';
        ELSE
          If ln_tdoc = 4 then
            C_TDOCID := '3';
          else
            If ln_tdoc = 15 then
              C_TDOCID := '4';
            else
              If ln_tdoc = 5 then
                C_TDOCID := '5';
              else
                If ln_tdoc = 6 then
                  C_TDOCID := '8';
                End If;
              End If;
            End If;
          End If;
        End If;
      End If;
    
    End;
  
  end sp_Tipo_Doc_SBS;

-----------------------------------------------------------------------
end PQ_CR_RESOLUTORES_NAVDD2017;
/

