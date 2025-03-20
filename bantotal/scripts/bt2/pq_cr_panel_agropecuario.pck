create or replace package PQ_CR_PANEL_AGROPECUARIO is

  -- Author  : ABERNEDO
  -- Created : 16/04/2019 03:10:07 p.m.
  -- Purpose : Panel Agropecurio flujo
  -- Fecha de Modificación      : 15/03/2024
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: Se descomento el monto de cuota potencial en el denominador de la formula  
  -----------------------------------------------------------

  -- Public type declarations
  procedure SP_CR_FECH_PAGO(instance    in number,
                            ld_fech_ini out date,
                            ld_fech_fin out date,
                            ln_meses    out number);

  procedure SP_CR_NUMCUOT(instance in number, ln_numcuot out number);

  procedure SP_CR_CARGA_INICIAL(ln_Instance  in number,
                                ln_NumCuota  in number,
                                lc_Usuario   in char,
                                ld_Fechfin   in date,
                                ld_FechaEval in date,
                                pd_Fecpro    in date,
                                ln_mtoSol    in number,
                                ln_efectivo  in number,
                                ln_cuopoten  in number,
                                ln_cuoconti  in number,
                                ln_contador  out number);

  procedure SP_CR_INSERTA_AQPA410(ln_Instance in number,
                                  ln_eval     in number,
                                  ld_fecpro   in date,
                                  ln_pais     in number,
                                  ln_tdoc     in number,
                                  lv_ndoc     in char,
                                  ld_Fecini   in date,
                                  ld_Fecfin   in date,
                                  ln_mtoSol   in number,
                                  ln_efectivo in number,
                                  ln_cuopoten in number,
                                  ln_cuoconti in number,
                                  ln_contador out number);
  Procedure Sp_calcula(pn_ins in number, pd_fecpro in date);
  procedure SP_CR_VERIFICA_FSD601(ln_Instance in number);
  Procedure Sp_cr_cuoPotencial(pn_ins in number, ln_MntPotncial out number);
  Procedure Sp_lineas(pn_ins    in number,
                      pd_fecpro in date,
                      pn_plazo  out number);
  Function Fn_cr_plazo_vigente117(pn_emp    in number,
                                  pn_mod    in number,
                                  pn_suc    in number,
                                  pn_mda    in number,
                                  pn_pap    in number,
                                  pn_cta    in number,
                                  pn_ope    in number,
                                  pn_sbo    in number,
                                  pn_top    in number,
                                  pd_fecpro in date) return number;
  Function Fn_cr_plazo_otorgada117(pn_emp    in number,
                                   pn_mod    in number,
                                   pn_suc    in number,
                                   pn_mda    in number,
                                   pn_pap    in number,
                                   pn_cta    in number,
                                   pn_ope    in number,
                                   pn_sbo    in number,
                                   pn_top    in number,
                                   pd_fecpro in date) return number;
  Procedure Sp_cr_ValidaFecha(pn_ins in number, pc_flg out char);
  Procedure Sp_valorNumerico(pv_var in varchar2,
                             pv_err out varchar2,
                             pn_num out number);
  Procedure Sp_cobertura(pn_ins  in number,
                         pc_flg  out char,
                         pc_flg2 out char);
  procedure SP_CR_CARGA_1(ln_Instance  in number,
                          ld_Fechfin   in date,
                          ld_FechaEval in date,
                          pd_Fecpro    in date,
                          ln_fin       out number);
  Procedure Sp_anio_mes(ld_fini  in date,
                        ln_anio  out number,
                        lc_conca out char,
                        lc_mes   out char);
end PQ_CR_PANEL_AGROPECUARIO;
/

create or replace package body PQ_CR_PANEL_AGROPECUARIO is

  procedure SP_CR_FECH_PAGO(instance    in number,
                            ld_fech_ini out date,
                            ld_fech_fin out date,
                            ln_meses    out number) is
  
    ld_feciniAux date;
    ld_fecfinAux date;
    ln_eva       number(10);
    ln_mod       number(4);
    ld_fecEva    date;
  
  begin
    begin
    
      select max(fsd601.ppfpag), min(fsd601.ppfpag)
        into ld_fech_fin, ld_fech_ini
        from xwf700, fsd601
       where fsd601.pgcod = xwf700.xwfempresa
         and fsd601.ppmod = xwf700.xwfmodulo
         and fsd601.ppsuc = xwf700.xwfsucursal
         and fsd601.ppmda = xwf700.xwfmoneda
         and fsd601.pppap = xwf700.xwfpapel
         and fsd601.ppcta = xwf700.xwfcuenta
         and fsd601.ppoper = xwf700.xwfoperacion
         and fsd601.ppsbop = xwf700.xwfsubope
         and fsd601.pptope = xwf700.xwftipope
         and fsd601.d601co = 'X'
         and xwf700.xwfprcins = instance
         and xwf700.xwfcar3 = '1';
    exception
      when no_data_found then
        null;
    end;
  
    begin
      select a.sng021eval, a.sng021tmod
        into ln_eva, ln_mod
        from sng021 a
       where a.sng021sol = instance;
    exception
      when others then
        null;
    end;
  
    if ln_mod = 13 then
    
      begin
        select a.SNG120FPag
          into ld_fecEva
          from sng120 a
         where a.sng120ins = instance
           and a.sng120tsk = 'EVALUACION';
      exception
        when others then
          null;
      end;
    
    else
      begin
        select a.SNG120FVal
          into ld_fecEva
          from sng120 a
         where a.sng120ins = instance
           and a.sng120tsk = 'EVALUACION';
      exception
        when others then
          null;
      end;
    end if;
  
    ld_feciniAux := to_date('01' || to_char(ld_fecEva, 'mmyyyy'),
                            'ddmmyyyy');
    ld_fecfinAux := to_date('01' || to_char(ld_fech_fin, 'mmyyyy'),
                            'ddmmyyyy');
  
    ln_meses := months_between(ld_fecfinAux, ld_feciniAux) + 1;
  
  end SP_CR_FECH_PAGO;

  procedure SP_CR_NUMCUOT(instance in number, ln_numcuot out number) is
  
  begin
    begin
    
      select x054023.xllcantcuo
        into ln_numcuot
        from xwf700, x054023
       where x054023.xllpgcod = xwf700.xwfempresa
         and x054023.xllaomod = xwf700.xwfmodulo
         and x054023.xllaosuc = xwf700.xwfsucursal
         and x054023.xllaomda = xwf700.xwfmoneda
         and x054023.xllaopap = xwf700.xwfpapel
         and x054023.xllaocta = xwf700.xwfcuenta
         and x054023.xllaooper = xwf700.xwfoperacion
         and x054023.xllaosbop = xwf700.xwfsubope
         and x054023.xllaotop = xwf700.xwftipope
         and xwf700.xwfprcins = instance
         and xwf700.xwfcar3 = '1';
    exception
      when no_data_found then
        null;
    end;
  
  end SP_CR_NUMCUOT;

  procedure SP_CR_CARGA_INICIAL(ln_Instance  in number,
                                ln_NumCuota  in number,
                                lc_Usuario   in char,
                                ld_Fechfin   in date,
                                ld_FechaEval in date,
                                pd_Fecpro    in date,
                                ln_mtoSol    in number,
                                ln_efectivo  in number,
                                ln_cuopoten  in number,
                                ln_cuoconti  in number,
                                ln_contador  out number) is
  
    ln_cont       number := 0;
    lc_mes        varchar2(20);
    ln_anio       number;
    ld_fini       date;
    ld_fchfin     date;
    lc_conca      varchar2(6);
    ln_ini        number(5) := 1;
    ln_fin        number(5);
    ln_plazo      number(5);
    ln_emp        number(3);
    ln_mod        number(3);
    ln_suc        number(3);
    ln_mda        number(4);
    ln_pap        number(4);
    ln_cta        number(9);
    ln_ope        number(9);
    ln_sbo        number(3);
    ln_top        number(3);
    ln_pai        number(3);
    ln_tdo        number(2);
    lc_ndo        char(12);
    ln_eval       number(10);
    ld_fech_fin   date;
    ld_fech_ini   date;
    ln_capcmac    number(17, 2);
    ln_capifis    number(17, 2);
    ln_capcontgnt number(17, 2);
    ln_capptncl   number(17, 2);
    ln_resulneto  number(17, 2);
    ln_ratio      number(17, 6);
    --ld_feceva   date;
    --ld_fecmax   date;
  
  begin
  
    begin
      delete from aqpa411 a where a.aqpa411inst = ln_Instance;
      commit;
    end;
  
    --Fechas de calendario
    begin
    
      select max(fsd601.ppfpag), min(fsd601.ppfpag)
        into ld_fech_fin, ld_fech_ini
        from xwf700, fsd601
       where fsd601.pgcod = xwf700.xwfempresa
         and fsd601.ppmod = xwf700.xwfmodulo
         and fsd601.ppsuc = xwf700.xwfsucursal
         and fsd601.ppmda = xwf700.xwfmoneda
         and fsd601.pppap = xwf700.xwfpapel
         and fsd601.ppcta = xwf700.xwfcuenta
         and fsd601.ppoper = xwf700.xwfoperacion
         and fsd601.ppsbop = xwf700.xwfsubope
         and fsd601.pptope = xwf700.xwftipope
         and fsd601.d601co = 'X'
         and xwf700.xwfprcins = ln_Instance
         and xwf700.xwfcar3 = '1';
    exception
      when no_data_found then
        null;
    end;
  
    begin
      ld_fini := last_day(ld_FechaEval);
    end;
  
    begin
      ld_fchfin := last_day(ld_Fechfin);
    end;
  
    ln_fin := months_between(ld_fchfin, ld_fini) + 1;
  
    /*begin
           select a.aqpa411fece
             into ld_feceva
             from aqpa411 a
            where a.aqpa411inst = ln_Instance
              and rownum        = 1;
    exception
            when others then null;
    end;
    
    begin
           select max(a.aqpa411feca)
             into ld_fecmax
             from aqpa411 a
            where a.aqpa411inst = ln_Instance;
    exception
            when others then null;
    end;*/
  
    --Verificar el plazo si es linea
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from xwf700 a
       where a.xwfprcins = ln_Instance
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_mod <> 117 then
      pq_cr_panel_agropecuario.Sp_lineas(pn_ins    => ln_Instance,
                                         pd_fecpro => pd_fecpro,
                                         pn_plazo  => ln_plazo);
      if nvl(ln_plazo, 0) <> 0 then
        if ln_plazo > ln_fin then
          ln_fin := ln_plazo;
        end if;
      
      end if;
    
    else
      ln_fin := pq_cr_panel_agropecuario.Fn_cr_plazo_otorgada117(pn_emp    => ln_emp,
                                                                 pn_mod    => ln_mod,
                                                                 pn_suc    => ln_suc,
                                                                 pn_mda    => ln_mda,
                                                                 pn_pap    => ln_pap,
                                                                 pn_cta    => ln_cta,
                                                                 pn_ope    => ln_ope,
                                                                 pn_sbo    => ln_sbo,
                                                                 pn_top    => ln_top,
                                                                 pd_fecpro => pd_fecpro);
      pq_cr_panel_agropecuario.Sp_lineas(pn_ins    => ln_Instance,
                                         pd_fecpro => pd_fecpro,
                                         pn_plazo  => ln_plazo);
      if nvl(ln_plazo, 0) <> 0 then
        if ln_plazo > ln_fin then
          ln_fin := ln_plazo;
        end if;
      
      end if;
    end if;
  
    while ln_ini <= ln_fin loop
    
      begin
        select max(a.aqpa411corr)
          into ln_cont
          from aqpa411 a
         where a.aqpa411inst = ln_Instance;
      end;
    
      ln_cont := nvl(ln_cont, 0);
    
      begin
        select to_char(ld_fini, 'YYYY'),
               concat(to_char(ld_fini, 'MM'), to_char(ld_fini, 'YYYY'))
          INTO ln_anio, lc_conca
          from dual;
      end;
    
      begin
        select to_char(ld_fini, 'Month', 'NLS_DATE_LANGUAGE=SPANISH')
          into lc_mes
          from dual;
      exception
        when no_data_found then
          null;
      end;
    
      begin
        insert into AQPA411
          (aqpa411corr,
           aqpa411inst,
           aqpa411nump,
           aqpa411fece,
           aqpa411feca,
           aqpa411anio,
           aqpa411mesa,
           aqpa411user,
           aqpa411aux0,
           aqpa411aux2)
        VALUES
          (ln_cont + 1,
           ln_Instance,
           ln_NumCuota,
           ld_FechaEval,
           ld_fini,
           ln_anio,
           lc_mes,
           lc_Usuario,
           lc_conca,
           ln_fin);
        COMMIT;
      end;
    
      ld_fini := add_months(ld_fini, +1);
      ln_ini  := ln_ini + 1;
    end loop;
  
    -- pq_cr_panel_agropecuario.SP_CR_VERIFICA_FSD601(ln_Instance);
  
    begin
      select a.sng021eval
        into ln_eval
        from sng021 a
       where a.sng021sol = ln_Instance;
    exception
      when others then
        null;
    end;
  
    begin
      select a.sng001pais, a.sng001tdoc, a.sng001ndoc
        into ln_pai, ln_tdo, lc_ndo
        from sng001 a
       where a.sng001inst = ln_Instance;
    exception
      when others then
        null;
    end;
  
    pq_cr_panel_agropecuario.SP_CR_INSERTA_AQPA410(ln_Instance => ln_Instance,
                                                   ln_eval     => ln_eval,
                                                   ld_fecpro   => pd_Fecpro,
                                                   ln_pais     => ln_pai,
                                                   ln_tdoc     => ln_tdo,
                                                   lv_ndoc     => lc_ndo,
                                                   ld_Fecini   => ld_fech_ini,
                                                   ld_Fecfin   => ld_fech_fin,
                                                   ln_mtoSol   => ln_mtoSol,
                                                   ln_efectivo => ln_efectivo,
                                                   ln_cuopoten => ln_cuopoten,
                                                   ln_cuoconti => ln_cuoconti,
                                                   ln_contador => ln_contador);
  
    begin
      -- Call the procedure
      pq_cr_ratio_evalflujo.sp_cr_inicioratio(ln_instancia  => ln_Instance, --nro de instancia
                                              lc_prgm       => 'HAQPA411', --'HAQPA411'
                                              lc_usuario    => lc_Usuario, -- usuario login
                                              ld_fecproc    => pd_Fecpro, -- Fecha de Proceso
                                              ln_capcmac    => ln_capcmac, -- variable de salida
                                              ln_capifis    => ln_capifis, -- variable de salida
                                              ln_capcontgnt => ln_capcontgnt, -- variable de salida
                                              ln_capptncl   => ln_capptncl, -- variable de salida
                                              ln_resulneto  => ln_resulneto, -- variable de salida
                                              ln_ratio      => ln_ratio); -- variable de salida
    end;
  
  end SP_CR_CARGA_INICIAL;

  procedure SP_CR_INSERTA_AQPA410(ln_Instance in number,
                                  ln_eval     in number,
                                  ld_fecpro   in date,
                                  ln_pais     in number,
                                  ln_tdoc     in number,
                                  lv_ndoc     in char,
                                  ld_Fecini   in date,
                                  ld_Fecfin   in date,
                                  ln_mtoSol   in number,
                                  ln_efectivo in number,
                                  ln_cuopoten in number,
                                  ln_cuoconti in number,
                                  ln_contador out number) is
  
    ln_cont_aqpa410 number;
    ln_cont_aqpa411 number;
    Flag_exist      varchar2(1);
    ln_corr         number;
    ld_feceva411    date;
    ld_feceva410    date;
    ld_fecmax410    date;
    ld_fecmax411    date;
  
    cursor aqpa411 is
      select *
        from aqpa411
       where aqpa411.aqpa411inst = ln_Instance
       order by aqpa411.aqpa411feca;
  
  begin
  
    begin
      select a.aqpa411fece
        into ld_feceva411
        from aqpa411 a
       where a.aqpa411inst = ln_Instance
         and rownum = 1;
    exception
      when no_data_found then
        null;
    end;
  
    begin
      select a.aqpa410feval
        into ld_feceva410
        from aqpa410 a
       where a.aqpa410inst = ln_Instance
         and a.aqpa410esta = 'S'
         and rownum = 1;
    exception
      when no_data_found then
        null;
    end;
  
    begin
      select max(a.aqpa411feca)
        into ld_fecmax411
        from aqpa411 a
       where a.aqpa411inst = ln_Instance;
    exception
      when no_data_found then
        null;
    end;
  
    begin
      select max(a.aqpa410fcon)
        into ld_fecmax410
        from aqpa410 a
       where a.aqpa410inst = ln_Instance
         and a.aqpa410esta = 'S';
    exception
      when no_data_found then
        null;
    end;
  
    if (ld_feceva411 <> ld_feceva410) or (ld_fecmax411 <> ld_fecmax410) then
      update aqpa410 a
         set a.aqpa410esta = 'N'
       where a.aqpa410inst = ln_Instance;
      commit;
    end if;
  
    begin
      select count(*)
        into ln_cont_aqpa410
        from aqpa410
       where aqpa410.aqpa410inst = ln_Instance
         and aqpa410.aqpa410esta = 'S';
    exception
      when no_data_found then
        null;
    end;
  
    begin
      select count(*)
        into ln_cont_aqpa411
        from aqpa411
       where aqpa411.aqpa411inst = ln_Instance;
    exception
      when no_data_found then
        null;
    end;
  
    /*if ld_feceva410 is null then
      for i in aqpa411 loop
        begin
          select max(aqpa410.aqpa410corr)
            into ln_corr
            from aqpa410
           where aqpa410.aqpa410inst = ln_Instance;
        exception
          when others then
            ln_corr := 0;
        end;
      
        if ln_corr is null then
          ln_corr := 1;
        else
          ln_corr := ln_corr + 1;
        end if;
      
        insert into aqpa410
          (aqpa410corr,
           aqpa410inst,
           aqpa410fecp,
           aqpa410neva,
           aqpa410pais,
           aqpa410tdoc,
           aqpa410ndoc,
           aqpa410ases,
           aqpa410numc,
           aqpa410feval,
           aqpa410fini,
           aqpa410finf,
           aqpa410fcon,
           aqpa410mesc,
           aqpa410anio,
           aqpa410esta,
           aqpa410mso,
           aqpa410efe,
           aqpa410cpo,
           aqpa410cco,
           AQPA410RESN,
           AQPA410IFIS,
           AQPA410CUOC,
           AQPA410FLUJO,
           AQPA410RATIO)
        values
          (i.aqpa411corr,
           ln_Instance,
           ld_fecpro,
           ln_eval,
           ln_pais,
           ln_tdoc,
           lv_ndoc,
           i.aqpa411user,
           i.aqpa411nump,
           i.aqpa411fece,
           ld_Fecini,
           ld_Fecfin,
           i.aqpa411feca,
           i.aqpa411mesa,
           i.aqpa411anio,
           'S',
           ln_mtoSol,
           ln_efectivo,
           ln_cuopoten,
           ln_cuoconti,
           0,
           0,
           0,
           0,
           0);
        commit;
      
      end loop;
    end if;
    
    if ld_feceva410 <> ld_feceva411 or ld_fecmax410 <> ld_fecmax411 then
      update aqpa410 a
         set a.aqpa410esta = 'N'
       where a.aqpa410inst = ln_Instance;
      commit;
    
      for i in aqpa411 loop
      
        begin
          select max(aqpa410.aqpa410corr)
            into ln_corr
            from aqpa410
           where aqpa410.aqpa410inst = ln_Instance;
        exception
          when others then
            ln_corr := 0;
        end;
      
        if ln_corr is null then
          ln_corr := 1;
        else
          ln_corr := ln_corr + 1;
        end if;
      
        insert into aqpa410
          (aqpa410corr,
           aqpa410inst,
           aqpa410fecp,
           aqpa410neva,
           aqpa410pais,
           aqpa410tdoc,
           aqpa410ndoc,
           aqpa410ases,
           aqpa410numc,
           aqpa410feval,
           aqpa410fini,
           aqpa410finf,
           aqpa410fcon,
           aqpa410mesc,
           aqpa410anio,
           aqpa410esta,
           aqpa410mso,
           aqpa410efe,
           aqpa410cpo,
           aqpa410cco,
           AQPA410RESN,
           AQPA410IFIS,
           AQPA410CUOC,
           AQPA410FLUJO,
           AQPA410RATIO)
        values
          (i.aqpa411corr,
           ln_Instance,
           ld_fecpro,
           ln_eval,
           ln_pais,
           ln_tdoc,
           lv_ndoc,
           i.aqpa411user,
           i.aqpa411nump,
           i.aqpa411fece,
           ld_Fecini,
           ld_Fecfin,
           i.aqpa411feca,
           i.aqpa411mesa,
           i.aqpa411anio,
           'S',
           ln_mtoSol,
           ln_efectivo,
           ln_cuopoten,
           ln_cuoconti,
           0,
           0,
           0,
           0,
           0);
        commit;
      
      end loop;
    end if;*/
  
    if ln_cont_aqpa411 > ln_cont_aqpa410 then
    
      for i in aqpa411 loop
      
        Flag_exist := 'N';
      
        begin
          select 'S'
            into Flag_exist
            from aqpa410
           where aqpa410.aqpa410inst = ln_Instance
             and aqpa410.aqpa410esta = 'S'
             and aqpa410.aqpa410fcon = i.aqpa411feca
             and aqpa410.aqpa410mesc = trim(i.aqpa411mesa)
             and aqpa410.aqpa410anio = i.aqpa411anio;
        exception
          when no_data_found then
            Flag_exist := 'N';
        end;
      
        if Flag_exist = 'N' then
        
          begin
            select max(aqpa410.aqpa410corr)
              into ln_corr
              from aqpa410
             where aqpa410.aqpa410inst = ln_Instance
            --aqpa410.aqpa410fecp = ld_fecpro
             ORDER BY aqpa410.aqpa410corr DESC;
          exception
            when others then
              ln_corr := 0;
          end;
        
          if ln_corr is null then
            ln_corr := 1;
          else
            ln_corr := ln_corr + 1;
          end if;
        
          insert into aqpa410
            (aqpa410corr,
             aqpa410inst,
             aqpa410fecp,
             aqpa410neva,
             aqpa410pais,
             aqpa410tdoc,
             aqpa410ndoc,
             aqpa410ases,
             aqpa410numc,
             aqpa410feval,
             aqpa410fini,
             aqpa410finf,
             aqpa410fcon,
             aqpa410mesc,
             aqpa410anio,
             aqpa410esta,
             aqpa410mso,
             aqpa410efe,
             aqpa410cpo,
             aqpa410cco,
             AQPA410RESN,
             AQPA410IFIS,
             AQPA410CUOC,
             AQPA410FLUJO,
             AQPA410RATIO)
          values
            (ln_corr, --i.aqpa411corr,
             ln_Instance,
             ld_fecpro,
             ln_eval,
             ln_pais,
             ln_tdoc,
             lv_ndoc,
             i.aqpa411user,
             i.aqpa411nump,
             i.aqpa411fece,
             ld_Fecini,
             ld_Fecfin,
             i.aqpa411feca,
             i.aqpa411mesa,
             i.aqpa411anio,
             'S',
             ln_mtoSol,
             ln_efectivo,
             ln_cuopoten,
             ln_cuoconti,
             0,
             0,
             0,
             0,
             0);
          commit;
        end if;
      end loop;
    end if;
    ln_contador := ln_cont_aqpa410;
  end SP_CR_INSERTA_AQPA410;

  Procedure Sp_calcula(pn_ins in number, pd_fecpro in date) is
  
    lc_flgAct char(1) := 'N';
  
    cursor registros is
      select *
        from aqpa410 a
       where a.aqpa410inst = pn_ins
         and a.aqpa410esta = 'S'
       order by a.aqpa410fcon;
  
    ln_acum     number(17, 2);
    ln_acum_ant number(17, 2) := 0;
    ln_cuo_ant  number(17, 2) := 0;
    ln_ratio    number(17, 6) := 0;
    ln_ratioD   number /*(17, 6)*/
    := 0;
    ln_agro     number(5);
    ln_pecu     number(5);
    ln_corrMin  number(10);
    ln_tipcam   NUMBER(14, 8);
    ln_mtoSol   NUMBER(17, 2);
    ln_mtoDol   NUMBER(17, 2);
    ln_mtoTot   NUMBER(17, 2);
    ln_cuoPoten NUMBER(17, 2);
    ln_cuoCont1 NUMBER(17, 2);
    ln_cuoCont2 NUMBER(17, 2);
    ln_cuoContT NUMBER(17, 2);
    lc_flg      char(1);
    ln_mod      number(3);
  begin
  
    pq_cr_resolutor_observacion.sp_cr_codactvprecagri(pn_ins,
                                                      ln_agro,
                                                      ln_pecu);
  
    begin
      select a.xwfmodulo
        into ln_mod
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_agro <> 0 or ln_pecu <> 0 or ln_mod = 104 then
      lc_flgAct := 'S';
    
    end if;
  
    if ln_mod = 117 then
      lc_flgAct := 'N';
    end if;
  
    begin
      select min(a.aqpa410corr)
        into ln_corrMin
        from aqpa410 a
       where a.aqpa410inst = pn_ins
         and a.aqpa410esta = 'S';
    exception
      when others then
        null;
    end;
  
    begin
      select a.sng120tcbi
        into ln_tipcam
        from sng120 a
       where a.sng120ins = pn_ins
         and a.sng120tsk = 'EVALUACION';
    exception
      when others then
        null;
    end;
  
    begin
      select b.sng023mto
        into ln_mtoSol
        from sng021 a, sng023 b
       where a.sng021sol = pn_ins
         and a.sng021eval = b.sng021eval
         and b.sng026cod = 41;
    exception
      when others then
        null;
    end;
  
    begin
      select b.sng023mto
        into ln_mtoDol
        from sng021 a, sng023 b
       where a.sng021sol = pn_ins
         and a.sng021eval = b.sng021eval
         and b.sng026cod = 541;
    exception
      when others then
        null;
    end;
  
    ln_mtoTot := nvl(ln_mtoSol, 0) + (nvl(ln_mtoDol, 0) * ln_tipcam);
  
    begin
      select a.xwfmonto1
        into ln_mtoSol
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
    lc_flg := 'N';
  
    pQ_CR_PANEL_AGROPECUARIO.Sp_cr_cuoPotencial(pn_ins, ln_cuoPoten);
    pq_cr_resolutor_cappago.sp_cr_cuotacontincf(pn_ins,
                                                pd_fecpro,
                                                lc_flg,
                                                ln_cuoCont1);
    pq_cr_resolutor_cappago.sp_cr_cuotacontinaval(pn_ins,
                                                  pd_fecpro,
                                                  lc_flg,
                                                  ln_cuoCont2);
  
    ln_cuoContT := nvl(ln_cuoCont1, 0) + nvl(ln_cuoCont2, 0);
  
    if lc_flgAct = 'S' then
      --actividad agro
      for i in registros loop
      
        if i.aqpa410corr = ln_corrMin then
          --primer registro
          ln_acum := nvl(ln_mtoSol, 0) + nvl(ln_mtoTot, 0) +
                     nvl(i.aqpa410flujo, 0);
        else
          ln_acum := nvl(ln_acum_ant, 0) + nvl(i.aqpa410flujo, 0) -
                     nvl(ln_cuo_ant, 0);
        
        end if;
      
        if nvl(i.aqpa410cuoc, 0) <> 0 then
          ln_ratioD := nvl(ln_acum, 0) + nvl(i.aqpa410ifis, 0) +
                       nvl(ln_cuoPoten, 0);
          if ln_ratioD = 0 then
            ln_ratio := 0;
          else
            ln_ratio := (nvl(i.aqpa410cuoc, 0) + nvl(i.aqpa410ifis, 0) +
                        nvl(ln_cuoPoten, 0) + nvl(ln_cuoContT, 0)) /
                        ln_ratioD;
          
          end if;
        
        else
          ln_ratio := 0;
        
        end if; --descomentar cuando se tenga la cuota caja
        /*ln_ratioD := nvl(ln_acum, 0) + nvl(i.aqpa410ifis, 0) +
                     nvl(i.aqpa410cpo, 0);
        
        if ln_ratioD = 0 then
          ln_ratio := 0;
        else
          ln_ratio := (nvl(i.aqpa410cuoc, 0) + nvl(i.aqpa410ifis, 0) +
                      nvl(i.aqpa410cpo, 0) + nvl(i.aqpa410cco, 0)) /
                      ln_ratioD;
        
        end if;*/
      
        update aqpa410 a
           set a.aqpa410resn  = ln_acum,
               a.aqpa410ratio = ln_ratio,
               a.aqpa410cpo   = ln_cuoPoten,
               a.aqpa410mso   = ln_mtoSol,
               a.aqpa410efe   = ln_mtoTot,
               a.aqpa410cco   = ln_cuoContT
         where a.aqpa410inst = pn_ins
           and a.aqpa410corr = i.aqpa410corr;
      
        commit;
      
        ln_acum_ant := ln_acum;
        ln_cuo_ant  := i.aqpa410cuoc;
      
      end loop;
    
    else
    
      for i in registros loop
      
        if i.aqpa410corr = ln_corrMin then
          --primer registro
          ln_acum := nvl(ln_mtoTot, 0) + nvl(i.aqpa410flujo, 0);
        else
          ln_acum := nvl(ln_acum_ant, 0) + nvl(i.aqpa410flujo, 0) -
                     nvl(ln_cuo_ant, 0);
        
        end if;
        if nvl(i.aqpa410cuoc, 0) <> 0 then
          ln_ratioD := nvl(ln_acum, 0) + nvl(i.aqpa410ifis, 0) +
                       nvl(ln_cuoPoten, 0);
          if ln_ratioD = 0 then
            ln_ratio := 0;
          else
            ln_ratio := (nvl(i.aqpa410cuoc, 0) + nvl(i.aqpa410ifis, 0) +
                        nvl(ln_cuoPoten, 0) + nvl(ln_cuoContT, 0)) /
                        ln_ratioD;
          
          end if;
        
        else
          ln_ratio := 0;
        
        end if; --descomentar cuando se tenga la cuota caja
      
        /*ln_ratioD := nvl(ln_acum, 0) + nvl(i.aqpa410ifis, 0) +
                     nvl(i.aqpa410cpo, 0);
        
        if ln_ratioD = 0 then
          ln_ratio := 0;
        else
          ln_ratio := (nvl(i.aqpa410cuoc, 0) + nvl(i.aqpa410ifis, 0) +
                      nvl(i.aqpa410cpo, 0) + nvl(i.aqpa410cco, 0)) /
                      ln_ratioD;
        
        end if;*/
      
        update aqpa410 a
           set a.aqpa410resn  = ln_acum,
               a.aqpa410ratio = ln_ratio,
               a.aqpa410cpo   = ln_cuoPoten,
               a.aqpa410mso   = ln_mtoSol,
               a.aqpa410efe   = ln_mtoTot,
               a.aqpa410cco   = ln_cuoContT
         where a.aqpa410inst = pn_ins
           and a.aqpa410corr = i.aqpa410corr;
      
        commit;
      
        ln_acum_ant := ln_acum;
        ln_cuo_ant  := i.aqpa410cuoc;
      
      end loop;
    
    end if;
  
  end Sp_calcula;

  procedure SP_CR_VERIFICA_FSD601(ln_Instance in number) is
  
    lc_fecha_cap varchar2(6);
    lc_fecha_seg varchar2(6);
  
    cursor flujo is
      select * from AQPA411 where aqpa411.aqpa411inst = ln_Instance;
  
    cursor capital is
      select *
        from xwf700, fsd601
       where fsd601.pgcod = xwf700.xwfempresa
         and fsd601.ppmod = xwf700.xwfmodulo
         and fsd601.ppsuc = xwf700.xwfsucursal
         and fsd601.ppmda = xwf700.xwfmoneda
         and fsd601.pppap = xwf700.xwfpapel
         and fsd601.ppcta = xwf700.xwfcuenta
         and fsd601.ppoper = xwf700.xwfoperacion
         and fsd601.ppsbop = xwf700.xwfsubope
         and fsd601.pptope = xwf700.xwftipope
         and fsd601.d601co = 'X'
         and fsd601.ppcap + fsd601.ppint <> 0.00
         and xwf700.xwfprcins = ln_Instance
         and xwf700.xwfcar3 = '1';
  
    cursor seguros is
    
      select *
        from xwf700, fsd611
       where fsd611.pgcod = xwf700.xwfempresa
         and fsd611.ppmod = xwf700.xwfmodulo
         and fsd611.ppsuc = xwf700.xwfsucursal
         and fsd611.ppmda = xwf700.xwfmoneda
         and fsd611.pppap = xwf700.xwfpapel
         and fsd611.ppcta = xwf700.xwfcuenta
         and fsd611.ppoper = xwf700.xwfoperacion
         and fsd611.ppsbop = xwf700.xwfsubope
         and fsd611.pptope = xwf700.xwftipope
         and fsd611.ppimp10 + fsd611.ppimp11 + fsd611.ppimp12 +
             fsd611.ppimp13 + fsd611.ppimp14 + fsd611.ppimp15 <> 0.00
         and xwf700.xwfprcins = ln_Instance
         and xwf700.xwfcar3 = '1';
  
  begin
    for i in flujo loop
      for j in capital loop
        for k in seguros loop
        
          lc_fecha_cap := concat(to_char(j.ppfpag, 'MM'),
                                 to_char(j.ppfpag, 'YYYY'));
        
          lc_fecha_seg := concat(to_char(k.ppfpag, 'MM'),
                                 to_char(k.ppfpag, 'YYYY'));
        
          if lc_fecha_cap = i.aqpa411aux0 or lc_fecha_seg = i.aqpa411aux0 then
          
            update AQPA411
               set AQPA411.AQPA411AUX1 = '1'
             where aqpa411.aqpa411inst = ln_Instance
               and aqpa411.aqpa411aux0 = i.aqpa411aux0;
            commit;
          
          end if;
        
        end loop;
      end loop;
    end loop;
  
  end SP_CR_VERIFICA_FSD601;

  Procedure Sp_cr_cuoPotencial(pn_ins in number, ln_MntPotncial out number) is
  
    ln_TipoSol      number(4);
    ln_MntPotncial1 number(17, 2) := 0.00;
    ln_MntPotncial2 number(17, 2) := 0.00;
  
  begin
  
    --Obtiene segmento
    begin
      select s.sng021tmod
        into ln_TipoSol
        from sng021 s
       where s.sng021sol = pn_ins;
    exception
      when others then
        null;
    end;
  
    if ln_TipoSol = 13 then
      begin
        select sum(j.jaqy327cptn)
          into ln_MntPotncial1
          from jaqy327 j
         where j.jaqy327inst = pn_ins
           and j.jaqy327esta = 'S'
           and j.jaqy327chek = '1'
           and j.jaqy327flin = 'L';
      exception
        when others then
          ln_MntPotncial1 := 0;
      end;
    
      begin
        --MPOSTIGOC 21.01.22
        select sum(j.jaqy142lcpoten)
          into ln_MntPotncial2
          from jaqy142l j
         where j.jaqy142linst = pn_ins
           and j.jaqy142lest = 'H';
      exception
        when no_data_found then
          begin
            select sum(j.jaqy142lcpoten)
              into ln_MntPotncial2
              from jaqy142l j
             where j.jaqy142linst = pn_ins
               and j.jaqy142lest = 'R';
          exception
            when others then
              null;
          end;
      end;
    
      ln_MntPotncial := nvl(ln_MntPotncial1, 0) + nvl(ln_MntPotncial2, 0);
    
    else
      begin
        select sum(j.jaqz862cptn)
          into ln_MntPotncial1
          from jaqz862 j
         where j.jaqz862inst = pn_ins
           and j.jaqz862esta = 'S'
           and j.jaqz862chek = '1'
           and j.jaqz862flin = 'L';
      exception
        when others then
          ln_MntPotncial1 := 0;
      end;
    
      begin
        --MPOSTIGOC 21.01.22
        select sum(j.jaqy142lcpoten)
          into ln_MntPotncial2
          from jaqy142l j
         where j.jaqy142linst = pn_ins
           and j.jaqy142lest = 'H';
      exception
        when no_data_found then
          begin
            select sum(j.jaqy142lcpoten)
              into ln_MntPotncial2
              from jaqy142l j
             where j.jaqy142linst = pn_ins
               and j.jaqy142lest = 'R';
          exception
            when others then
              null;
          end;
      end;
    
      ln_MntPotncial := nvl(ln_MntPotncial1, 0) + nvl(ln_MntPotncial2, 0);
    
    end if;
  
  end;

  Procedure Sp_lineas(pn_ins    in number,
                      pd_fecpro in date,
                      pn_plazo  out number) is
  
    ln_pai number(3);
    ln_tdo number(2);
    lc_ndo char(12);
  
    cursor lista_cuentas is
    
      select distinct f.ctnro ln_cuenta
        from fsr008 f
       where (f.pepais, f.petdoc, f.pendoc) in
             (select f.pepais, f.petdoc, f.pendoc
                from sng001 s, fsr008 f
               where s.sng001inst = pn_ins
                 and s.sng001cta = f.ctnro
              union
              select g.rppais, g.rptdoc, g.rpndoc
                from fsr008 h, sng001 s, fsr002 g
               where s.sng001inst = pn_ins
                 and s.sng001cta = h.ctnro
                 and h.pepais = g.pepais
                 and h.petdoc = g.petdoc
                 and h.pendoc = g.pendoc
                 and g.rpccyg = 66
              union
              select g.pepais, g.petdoc, g.pendoc
                from fsr008 h, sng001 s, fsr002 g
               where s.sng001inst = pn_ins
                 and s.sng001cta = h.ctnro
                 and h.pepais = g.rppais
                 and h.petdoc = g.rptdoc
                 and h.pendoc = g.rpndoc
                 and g.rpccyg = 66);
  
    cursor lineas_vigentes(ln_cuenta number) is
    
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
         and d10.Aocta = ln_cuenta
         and d10.Aomod = 117
         and d10.Aostat <> 99
         and d10.aofvto >= pd_fecpro;
  
    /* cursor lineas_vigentes is
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
                          where pepais = ln_pai
                            and Petdoc = ln_tdo
                            and pendoc = lc_ndo)
       and d10.Aomod = 117
       and d10.Aostat <> 99
       and d10.aofvto >= pd_fecpro
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
     where c.pepais = ln_pai
       and c.petdoc = ln_tdo
       and c.pendoc = lc_ndo
       and a.pgcod = b.pgcod
       and a.ctnro = b.aocta
       and b.Aomod = 117
       and b.aostat <> 99
       and a.pepais = c.rppais
       and a.petdoc = c.rptdoc
       and a.pendoc = c.rpndoc
       and c.rpccyg = 66
       and b.aofvto >= pd_fecpro;*/
  
    /*Cursor lineas_vencidas is
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
                          where pepais = ln_pai
                            and Petdoc = ln_tdo
                            and pendoc = lc_ndo)
       and d10.Aomod = 117
       and d10.aofvto < pd_fecpro
    
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
     where c.pepais = ln_pai
       and c.petdoc = ln_tdo
       and c.pendoc = lc_ndo
       and a.pgcod = b.pgcod
       and a.ctnro = b.aocta
       and b.aomod = 117
       and b.aofvto < pd_fecpro
       and a.pepais = c.rppais
       and a.petdoc = c.rptdoc
       and a.pendoc = c.rpndoc
       and c.rpccyg = 66;*/
  
    ln_plazo  number(17, 2);
    ln_plazoF number(17, 2) := 0;
    --ln_emp116     number(3);
    --ln_mod116     number(3);
    --ln_suc116     number(3);
    --ln_mda116     number(4);
    --ln_pap116     number(4);
    --ln_cta116     number(9);
    --ln_ope116     number(9);
    --ln_sbo116     number(3);
    --ln_top116     number(3);
    --ln_plazo116   number(5);
    --ln_plazo116F  number(5);
    --ld_fecmax116  date;
    --ld_fecmin116  date;
    --ld_fecmax116F date;
    --ld_fecmin116F date;
    ln_plazoFin number(17, 2);
  
  begin
  
    begin
      select a.sng001pais, a.sng001tdoc, a.sng001ndoc
        into ln_pai, ln_tdo, lc_ndo
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        null;
    end;
    for k in lista_cuentas loop
      for i in lineas_vigentes(k.ln_cuenta) loop
        ln_plazo := pq_cr_panel_agropecuario.Fn_cr_plazo_vigente117(i.ln_pgcod10,
                                                                    i.ln_mod10,
                                                                    i.ln_suc10,
                                                                    i.ln_mda10,
                                                                    i.ln_pap10,
                                                                    i.ln_cta10,
                                                                    i.ln_oper10,
                                                                    i.ln_sbop10,
                                                                    i.ln_tope10,
                                                                    pd_fecpro);
        if ln_plazo > ln_plazoF then
          ln_plazoF := ln_plazo;
        end if;
      
      end loop;
    end loop;
    /*for j in lineas_vencidas loop
    
      begin
        select b.pgcod,
               b.aomod,
               b.aosuc,
               b.aomda,
               b.aopap,
               b.aocta,
               b.aooper,
               b.aosbop,
               b.aotope
          into ln_emp116,
               ln_mod116,
               ln_suc116,
               ln_mda116,
               ln_pap116,
               ln_cta116,
               ln_ope116,
               ln_sbo116,
               ln_top116
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
           and a.relcod = 46
           and a.r1cod = b.pgcod
           and a.r1mod = b.aomod
           and a.r1suc = b.aosuc
           and a.r1mda = b.aomda
           and a.r1pap = b.aopap
           and a.r1cta = b.aocta
           and a.r1oper = b.aooper
           and a.r1sbop = b.aosbop
           and a.r1tope = b.aotope
           and b.aostat <> 99;
      exception
        when others then
          null;
      end;
    
      begin
        select max(a.ppfpag), min(a.ppfpag)
          into ld_fecmax116, ld_fecmin116
          from fsd601 a
         where a.pgcod = ln_emp116
           and a.ppmod = ln_mod116
           and a.ppsuc = ln_suc116
           and a.ppmda = ln_mda116
           and a.pppap = ln_pap116
           and a.ppcta = ln_cta116
           and a.ppoper = ln_ope116
           and a.ppsbop = ln_sbo116
           and a.pptope = ln_top116
           and a.d601co = 'S';
      exception
        when others then
          null;
      end;
      ld_fecmax116F := To_date('01' || to_char(ld_fecmax116, 'mmyyyy'),
                               'ddmmyyyy');
      ld_fecmin116F := To_date('01' || to_char(ld_fecmin116, 'mmyyyy'),
                               'ddmmyyyy');
      ln_plazo116   := months_between(ld_fecmax116F, ld_fecmin116F);
    
      if ln_plazo116 > ln_plazo116F then
        ln_plazo116F := ln_plazo116;
      end if;
    
    end loop;
    
    
    
    if ln_plazo116F > ln_plazoF then
      ln_plazoFin := ln_plazo116F;
    else
      ln_plazoFin := ln_plazoF;
    end if;*/
  
    ln_plazoFin := ln_plazoF;
    pn_plazo    := ln_plazoFin;
  
  end Sp_lineas;

  Function Fn_cr_plazo_vigente117(pn_emp    in number,
                                  pn_mod    in number,
                                  pn_suc    in number,
                                  pn_mda    in number,
                                  pn_pap    in number,
                                  pn_cta    in number,
                                  pn_ope    in number,
                                  pn_sbo    in number,
                                  pn_top    in number,
                                  pd_fecpro in date) return number is
  
    lc_FlagGuia   char(1) := 'N';
    ln_instancia  number(10);
    LN_TIPOCRED   number(5);
    lc_FlagSegmnt char(1) := 'N';
    ln_plazo      number(17, 2);
    --ld_fecmax116  date;
    --ld_fecmin116  date;
    --ld_fecmax116F date;
    --ld_fecmin116F date;
    --ln_emp116     number(3);
    --ln_mod116     number(3);
    --ln_suc116     number(3);
    --ln_mda116     number(4);
    --ln_pap116     number(4);
    --ln_cta116     number(9);
    --ln_ope116     number(9);
    --ln_sbo116     number(3);
    --ln_top116     number(3);
    --ln_plazo116   number(5);
    ln_plazoF    number(17, 2);
    ln_max       number(3);
    ln_Indicador number(2);
    ld_fecvto    date;
    ln_meses     number(10);
  begin
    begin
      select 'S'
        into lc_FlagGuia
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.tp1corr2 = 18
         and a.tp1nro2 = pn_mod
         and a.tp1nro3 = pn_top;
    exception
      when others then
        lc_FlagGuia := 'N';
      
    end;
  
    if lc_FlagGuia = 'S' then
      --Extraemos el plazo de la guia
    
      begin
        select x.xwfprcins
          into ln_instancia
          from xwf700 x
         where x.xwfempresa = pn_emp
           and x.xwfmodulo = pn_mod
           and x.xwfsucursal = pn_suc
           and x.xwfmoneda = pn_mda
           and x.xwfpapel = pn_pap
           and x.xwfcuenta = pn_cta
           and x.xwfoperacion = pn_ope
           and x.xwfsubope = pn_sbo
           and x.xwftipope = pn_top
           and x.xwfcar3 = '1';
      exception
        when others then
          null;
      end;
    
      begin
        -- Tipo de Credito en el flujo
      
        select to_number(REGEXP_REPLACE((UPPER(replace(w.wfattsval, ';', ''))),
                                        '([A-Z])',
                                        ''))
          into LN_TIPOCRED
          from wfattsvalues w
         where w.wfinsprcid = ln_instancia
           and w.wfattsid = 'TIPO_CREDITO';
      exception
        when others then
          null;
      end;
    
      begin
        select 'S'
          into lc_FlagSegmnt
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 13
           and a.tp1corr2 = 17
           and a.tp1nro3 = LN_TIPOCRED;
      exception
        when others then
          lc_FlagSegmnt := 'N';
      end;
    
      if lc_FlagSegmnt = 'S' then
      
        begin
          select f.pp028maxn
            into ln_plazo
            from fpp028 f
           where f.pp017par = 103
             and f.pp028mod = 116
             and f.pp028top = pn_top
             and f.pp028mda = pn_mda; -- plazo
        exception
          when others then
            null;
        end;
      
      else
        if lc_FlagSegmnt = 'N' then
        
          begin
            select a.tp1nro2
              into ln_plazo
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 10899
               and a.tp1corr1 = 13
               and a.tp1corr2 = 17
               and a.tp1corr3 = 4;
          end;
        
        end if;
      end if;
    
    else
    
      if lc_FlagGuia = 'N' then
      
        begin
          select f.pp028maxn
            into ln_plazo
            from fpp028 f
           where f.pp017par = 103
             and f.pp028mod = 116
             and f.pp028top = pn_top
             and f.pp028mda = pn_mda; -- plazo
        exception
          when others then
            null;
        end;
      
      end if;
    
    end if;
    ln_plazo := nvl(ln_plazo, 0) /** 2*/
     ;
  
    begin
      select x.aofvto
        into ld_fecvto
        from fsd010 x
       where x.pgcod = pn_emp
         and x.aomod = pn_mod
         and x.aosuc = pn_suc
         and x.aomda = pn_mda
         and x.aopap = pn_pap
         and x.aocta = pn_cta
         and x.aooper = pn_ope
         and x.aosbop = pn_sbo
         and x.aotope = pn_top;
    exception
      when others then
        null;
    end;
  
    ln_meses := months_between(last_day(ld_fecvto), last_day(pd_fecpro));
  
    begin
      select Tp1nro1
        into ln_max
        from fst198 a
       Where Tp1cod = 1
         and Tp1cod1 = 10899
         and Tp1corr1 = 11
         and Tp1corr2 = 1;
    exception
      when others then
        null;
    end;
  
    ln_Indicador := 0;
  
    begin
      select 1
        into ln_Indicador
        from fst198 a
       Where Tp1cod = 1
         and Tp1cod1 = 10899
         and Tp1corr1 = 14
         and Tp1corr2 = 1
         and Tp1nro1 = pn_top
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    if ln_Indicador = 1 then
      ln_max := ln_plazo;
    
    end if;
  
    if ln_meses < ln_max then
      ln_max := ln_meses;
    end if;
  
    --verifica 116
    /*begin
      select b.pgcod,
             b.aomod,
             b.aosuc,
             b.aomda,
             b.aopap,
             b.aocta,
             b.aooper,
             b.aosbop,
             b.aotope
        into ln_emp116,
             ln_mod116,
             ln_suc116,
             ln_mda116,
             ln_pap116,
             ln_cta116,
             ln_ope116,
             ln_sbo116,
             ln_top116
        from fsr011 a, fsd010 b
       where a.r2cod = pn_emp
         and a.r2mod = pn_mod
         and a.r2suc = pn_suc
         and a.r2mda = pn_mda
         and a.r2pap = pn_pap
         and a.r2cta = pn_cta
         and a.r2oper = pn_ope
         and a.r2sbop = pn_sbo
         and a.r2tope = pn_top
         and a.relcod = 46
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and b.aostat <> 99;
    exception
      when others then
        null;
    end;
    
    if ln_cta116 is not null then
    
      begin
        select max(a.ppfpag), min(a.ppfpag)
          into ld_fecmax116, ld_fecmin116
          from fsd601 a
         where a.pgcod = ln_emp116
           and a.ppmod = ln_mod116
           and a.ppsuc = ln_suc116
           and a.ppmda = ln_mda116
           and a.pppap = ln_pap116
           and a.ppcta = ln_cta116
           and a.ppoper = ln_ope116
           and a.ppsbop = ln_sbo116
           and a.pptope = ln_top116
           and a.d601co = 'S';
      exception
        when others then
          null;
      end;
      ld_fecmax116F := To_date('01' || to_char(ld_fecmax116, 'mmyyyy'),
                               'ddmmyyyy');
      ld_fecmin116F := To_date('01' || to_char(ld_fecmin116, 'mmyyyy'),
                               'ddmmyyyy');
      ln_plazo116   := months_between(ld_fecmax116F, ld_fecmin116F) + 1;
    end if;*/
  
    ln_plazoF := ln_plazo + nvl(ln_max, 0) + 2;
    return ln_plazoF;
  end Fn_cr_plazo_vigente117;

  Function Fn_cr_plazo_otorgada117(pn_emp    in number,
                                   pn_mod    in number,
                                   pn_suc    in number,
                                   pn_mda    in number,
                                   pn_pap    in number,
                                   pn_cta    in number,
                                   pn_ope    in number,
                                   pn_sbo    in number,
                                   pn_top    in number,
                                   pd_fecpro in date) return number is
  
    lc_FlagGuia   char(1) := 'N';
    ln_instancia  number(10);
    LN_TIPOCRED   number(5);
    lc_FlagSegmnt char(1) := 'N';
    ln_plazo      number(17, 2);
    ln_rubro      number(17);
    ld_fecvto     date;
    ln_meses      number(10);
    ln_max        number(3);
    ln_Indicador  number(2);
    ln_plazoF     number(17, 2);
  
  begin
    begin
      select 'S'
        into lc_FlagGuia
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.tp1corr2 = 18
         and a.tp1nro2 = pn_mod
         and a.tp1nro3 = pn_top;
    exception
      when others then
        lc_FlagGuia := 'N';
      
    end;
  
    if lc_FlagGuia = 'S' then
      --Extraemos el plazo de la guia
    
      begin
        select x.xwfprcins
          into ln_instancia
          from xwf700 x
         where x.xwfempresa = pn_emp
           and x.xwfmodulo = pn_mod
           and x.xwfsucursal = pn_suc
           and x.xwfmoneda = pn_mda
           and x.xwfpapel = pn_pap
           and x.xwfcuenta = pn_cta
           and x.xwfoperacion = pn_ope
           and x.xwfsubope = pn_sbo
           and x.xwftipope = pn_top
           and x.xwfcar3 = '1';
      exception
        when others then
          null;
      end;
    
      begin
        -- Tipo de Credito en el flujo
      
        select to_number(REGEXP_REPLACE((UPPER(replace(w.wfattsval, ';', ''))),
                                        '([A-Z])',
                                        ''))
          into LN_TIPOCRED
          from wfattsvalues w
         where w.wfinsprcid = ln_instancia
           and w.wfattsid = 'TIPO_CREDITO';
      exception
        when others then
          null;
      end;
    
      begin
        select to_number(trim(ww.pp028defc))
          into ln_rubro
          from fpp028 ww
         where ww.pp017par = 115
           and ww.pp028mod = pn_mod
           and ww.pp028top = pn_top
           and ww.pp028emp = pn_emp
           and ww.pp028mda = pn_mda
           and ww.pp028pap = pn_pap;
      
      exception
        when others then
          null;
      end;
    
      begin
        select 'S'
          into lc_FlagSegmnt
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 13
           and a.tp1corr2 = 17
           and a.tp1nro3 = substr(ln_rubro, 7, 2);
      exception
        when others then
          lc_FlagSegmnt := 'N';
      end;
    
      if lc_FlagSegmnt = 'S' then
      
        begin
          select f.pp028maxn
            into ln_plazo
            from fpp028 f
           where f.pp017par = 103
             and f.pp028mod = 116
             and f.pp028top = pn_top
             and f.pp028mda = pn_mda; -- plazo
        exception
          when others then
            null;
        end;
      
      else
        if lc_FlagSegmnt = 'N' then
        
          begin
            select a.tp1nro2
              into ln_plazo
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 10899
               and a.tp1corr1 = 13
               and a.tp1corr2 = 17
               and a.tp1corr3 = 4;
          end;
        
        end if;
      end if;
    
    else
    
      if lc_FlagGuia = 'N' then
      
        begin
          select f.pp028maxn
            into ln_plazo
            from fpp028 f
           where f.pp017par = 103
             and f.pp028mod = 116
             and f.pp028top = pn_top
             and f.pp028mda = pn_mda; -- plazo
        exception
          when others then
            null;
        end;
      
      end if;
    
    end if;
    ln_plazo := nvl(ln_plazo, 0) /** 2*/
     ;
  
    begin
      select x.aofvto
        into ld_fecvto
        from fsd010 x
       where x.pgcod = pn_emp
         and x.aomod = pn_mod
         and x.aosuc = pn_suc
         and x.aomda = pn_mda
         and x.aopap = pn_pap
         and x.aocta = pn_cta
         and x.aooper = pn_ope
         and x.aosbop = pn_sbo
         and x.aotope = pn_top;
    exception
      when others then
        null;
    end;
  
    ln_meses := months_between(last_day(ld_fecvto), last_day(pd_fecpro));
  
    begin
      select Tp1nro1
        into ln_max
        from fst198 a
       Where Tp1cod = 1
         and Tp1cod1 = 10899
         and Tp1corr1 = 11
         and Tp1corr2 = 1;
    exception
      when others then
        null;
    end;
  
    ln_Indicador := 0;
  
    begin
      select 1
        into ln_Indicador
        from fst198 a
       Where Tp1cod = 1
         and Tp1cod1 = 10899
         and Tp1corr1 = 14
         and Tp1corr2 = 1
         and Tp1nro1 = pn_top
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    if ln_Indicador = 1 then
      ln_max := ln_plazo;
    
    end if;
  
    if ln_meses < ln_max then
      ln_max := ln_meses;
    end if;
  
    ln_plazoF := ln_plazo + nvl(ln_max, 0) + 2;
  
    return ln_plazoF;
  end Fn_cr_plazo_otorgada117;

  Procedure Sp_cr_ValidaFecha(pn_ins in number, pc_flg out char) is
  
    ln_eva    number(10);
    ln_mod    number(4);
    ld_fecEva date;
    ld_fecsol date;
  begin
  
    begin
      select a.sng021eval, a.sng021tmod
        into ln_eva, ln_mod
        from sng021 a
       where a.sng021sol = pn_ins;
    exception
      when others then
        null;
    end;
  
    if ln_mod = 13 then
    
      begin
        select a.SNG120FPag
          into ld_fecEva
          from sng120 a
         where a.sng120ins = pn_ins
           and a.sng120tsk = 'EVALUACION';
      exception
        when others then
          null;
      end;
    
    else
      begin
        select a.SNG120FVal
          into ld_fecEva
          from sng120 a
         where a.sng120ins = pn_ins
           and a.sng120tsk = 'EVALUACION';
      exception
        when others then
          null;
      end;
    end if;
  
    begin
      select max(trunc(a.wfiteminit))
        into ld_fecsol
        from wfwrkitems a
       where a.wfinsprcid = pn_ins
         and a.wftaskcod = 3;
    exception
      when others then
        null;
    end;
  
    begin
      select a.sng001fin
        into ld_fecsol
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        null;
    end;
  
    if ld_fecEva >= ld_fecsol then
      pc_flg := 'S';
    else
      pc_flg := 'N';
    end if;
  
  end Sp_cr_ValidaFecha;

  Procedure Sp_valorNumerico(pv_var in varchar2,
                             pv_err out varchar2,
                             pn_num out number) is
  begin
    begin
      select to_number(trim(pv_var)) into pn_num from dual;
    exception
      when others then
        pv_err := substr(sqlerrm, 1, 300);
    end;
    /*    insert into prueba_andrea (campo2) values (pn_num);
    commit;*/
  
  end Sp_valorNumerico;

  Procedure Sp_cobertura(pn_ins  in number,
                         pc_flg  out char,
                         pc_flg2 out char) is
  
    cursor aqpa410_cur is
      select *
        from aqpa410 a
       where a.aqpa410inst = pn_ins
         and a.aqpa410esta = 'S'
       order by a.aqpa410fcon;
  
    ln_cta         number(9);
    ln_ori         number(2);
    ln_seg         number(2);
    ln_emp         number(3);
    ln_mod         number(3);
    ln_suc         number(3);
    ln_mda         number(4);
    ln_pap         number(4);
    ln_ope         number(9);
    ln_sbo         number(3);
    ln_top         number(3);
    ln_dig         number(2);
    ln_rubro       number(16);
    ln_ratio       number(17, 6);
    lc_flg         char(1) := 'N';
    ln_plazo1      number(5);
    ln_plazo       number(5);
    lc_flg410      char(1) := 'N';
    ln_cont410     number(10) := 0;
    ln_contAqpa410 number(10) := 0;
  begin
  
    --obtiene cobertura
    begin
      select a.sng001cta, a.sng001ori
        into ln_cta, ln_ori
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        null;
    end;
  
    begin
      select a.ctsegm
        into ln_seg
        from fsd008 a
       where a.pgcod = 1
         and a.ctnro = ln_cta;
    exception
      when others then
        null;
    end;
  
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope,
             a.xwfplazo1
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_ope,
             ln_sbo,
             ln_top,
             ln_plazo1
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      select to_number(trim(ww.pp028defc))
        into ln_rubro
        from fpp028 ww
       where ww.pp017par = 115
         and ww.pp028mod = ln_mod
         and ww.pp028top = ln_top
         and ww.pp028emp = ln_emp
         and ww.pp028mda = ln_mda
         and ww.pp028pap = ln_pap;
    
    exception
      when others then
        null;
    end;
  
    if ln_mod = 117 then
      ln_dig := to_number(substr(ln_rubro, 7, 2));
    else
      ln_dig := to_number(substr(ln_rubro, 5, 2));
    end if;
  
    begin
      select a.xllplazo
        into ln_plazo
        from x054023 a
       where a.xllpgcod = ln_emp
         and a.xllaomod = ln_mod
         and a.xllaosuc = ln_suc
         and a.xllaomda = ln_mda
         and a.xllaopap = ln_pap
         and a.xllaocta = ln_cta
         and a.xllaooper = ln_ope
         and a.xllaosbop = ln_sbo
         and a.xllaotop = ln_top;
    exception
      when others then
        null;
    end;
  
    if ln_plazo is null then
      ln_plazo := ln_plazo1;
    end if;
  
    begin
      select max(a.aqpa410ratio)
        into ln_ratio
        from aqpa410 a
       where a.aqpa410inst = pn_ins
         and a.aqpa410esta = 'S';
    exception
      when others then
        null;
    end;
  
    if ln_mod Not In (105, 112) And ln_seg = 1 And ln_ori <> 3 And
       ln_dig In (10, 11, 12) And ln_ratio > 0.90 then
      lc_flg := 'S';
    end if;
  
    if ln_mod Not In (105, 112) And ln_seg = 1 And ln_ori <> 3 And
       ln_dig not In (10, 11, 12) And ln_ratio > 0.80 then
      lc_flg := 'S';
    end if;
  
    if ln_mod = 112 And ln_seg = 1 And ln_ori <> 3 And ln_ratio > 0.60 then
      lc_flg := 'S';
    end if;
  
    if ln_mod <> 115 And ln_seg = 1 And ln_ori = 3 And ln_ratio > 0.90 then
      lc_flg := 'S';
    end if;
  
    if ln_seg = 1 And ln_ori = 3 And ln_ratio > 0.90 then
      lc_flg := 'S';
    end if;
  
    if ln_dig = 4 and ln_seg = 2 And ln_ori <> 3 And ln_ratio > 0.70 then
      lc_flg := 'S';
    end if;
  
    if ln_ratio > 0.70 and ln_plazo < 2190 And ln_ori <> 3 and ln_seg = 1 and
       ln_dig = 4 then
      lc_flg := 'S';
    end if;
  
    if ln_ratio > 0.60 and ln_plazo >= 2190 And ln_ori <> 3 and ln_seg = 1 and
       ln_dig = 4 then
      lc_flg := 'S';
    end if;
  
    if ln_seg = 2 and ln_ratio > 0.90 And ln_ori = 3 then
      lc_flg := 'S';
    end if;
  
    if ln_mod = 112 and ln_seg = 2 And ln_ori <> 3 and ln_ratio > 0.70 then
      lc_flg := 'S';
    end if;
  
    if ln_seg = 2 and ln_ratio > 0.90 And ln_ori <> 3 and ln_mod <> 112 then
      lc_flg := 'S';
    end if;
  
    ---Validacion ratio 0
    ln_contAqpa410 := 0;
    lc_flg410      := 'N';
    for j in aqpa410_cur loop
      if j.aqpa410ratio = 0 then
        ln_contAqpa410 := ln_contAqpa410 + 1;
      end if;
    end loop;
  
    begin
      select count(a.aqpa410ratio)
        into ln_cont410
        from aqpa410 a
       where a.aqpa410inst = pn_ins
         and a.aqpa410esta = 'S';
    exception
      when others then
        null;
    end;
  
    if ln_cont410 = ln_contAqpa410 then
      lc_flg410 := 'S';
    else
      lc_flg410 := 'N';
    end if;
  
    pc_flg2 := lc_flg410;
    pc_flg  := lc_flg;
  
  end Sp_cobertura;

  procedure SP_CR_CARGA_1(ln_Instance  in number,
                          ld_Fechfin   in date,
                          ld_FechaEval in date,
                          pd_Fecpro    in date,
                          ln_fin       out number) is
  
    ld_fini     date;
    ld_fchfin   date;
    ln_plazo    number(5);
    ln_emp      number(3);
    ln_mod      number(3);
    ln_suc      number(3);
    ln_mda      number(4);
    ln_pap      number(4);
    ln_cta      number(9);
    ln_ope      number(9);
    ln_sbo      number(3);
    ln_top      number(3);
    ld_fech_fin date;
    ld_fech_ini date;
    --ld_feceva   date;
    --ld_fecmax   date;
  
  begin
  
    --Fechas de calendario
    begin
    
      select max(fsd601.ppfpag), min(fsd601.ppfpag)
        into ld_fech_fin, ld_fech_ini
        from xwf700, fsd601
       where fsd601.pgcod = xwf700.xwfempresa
         and fsd601.ppmod = xwf700.xwfmodulo
         and fsd601.ppsuc = xwf700.xwfsucursal
         and fsd601.ppmda = xwf700.xwfmoneda
         and fsd601.pppap = xwf700.xwfpapel
         and fsd601.ppcta = xwf700.xwfcuenta
         and fsd601.ppoper = xwf700.xwfoperacion
         and fsd601.ppsbop = xwf700.xwfsubope
         and fsd601.pptope = xwf700.xwftipope
         and fsd601.d601co = 'X'
         and xwf700.xwfprcins = ln_Instance
         and xwf700.xwfcar3 = '1';
    exception
      when no_data_found then
        null;
    end;
  
    begin
      ld_fini := last_day(ld_FechaEval);
    end;
  
    begin
      ld_fchfin := last_day(ld_Fechfin);
    end;
  
    ln_fin := months_between(ld_fchfin, ld_fini) + 1;
  
    --Verificar el plazo si es linea
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from xwf700 a
       where a.xwfprcins = ln_Instance
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_mod <> 117 then
      pq_cr_panel_agropecuario.Sp_lineas(pn_ins    => ln_Instance,
                                         pd_fecpro => pd_fecpro,
                                         pn_plazo  => ln_plazo);
      if nvl(ln_plazo, 0) <> 0 then
        if ln_plazo > ln_fin then
          ln_fin := ln_plazo;
        end if;
      
      end if;
    
    else
      ln_fin := pq_cr_panel_agropecuario.Fn_cr_plazo_otorgada117(pn_emp    => ln_emp,
                                                                 pn_mod    => ln_mod,
                                                                 pn_suc    => ln_suc,
                                                                 pn_mda    => ln_mda,
                                                                 pn_pap    => ln_pap,
                                                                 pn_cta    => ln_cta,
                                                                 pn_ope    => ln_ope,
                                                                 pn_sbo    => ln_sbo,
                                                                 pn_top    => ln_top,
                                                                 pd_fecpro => pd_fecpro);
      pq_cr_panel_agropecuario.Sp_lineas(pn_ins    => ln_Instance,
                                         pd_fecpro => pd_fecpro,
                                         pn_plazo  => ln_plazo);
      if nvl(ln_plazo, 0) <> 0 then
        if ln_plazo > ln_fin then
          ln_fin := ln_plazo;
        end if;
      
      end if;
    end if;
  
  end SP_CR_CARGA_1;

  Procedure Sp_anio_mes(ld_fini  in date,
                        ln_anio  out number,
                        lc_conca out char,
                        lc_mes   out char) is
  begin
  
    begin
      select to_number(to_char(ld_fini, 'YYYY')),
             concat(to_char(ld_fini, 'MM'), to_char(ld_fini, 'YYYY'))
        INTO ln_anio, lc_conca
        from dual;
    end;
  
    begin
      select to_char(ld_fini, 'Month', 'NLS_DATE_LANGUAGE=SPANISH')
        into lc_mes
        from dual;
    exception
      when no_data_found then
        null;
    end;
  end Sp_anio_mes;

end PQ_CR_PANEL_AGROPECUARIO;
/

