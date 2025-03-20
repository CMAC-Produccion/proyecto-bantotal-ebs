create or replace package PQ_CR_CAMP_TIMEFIESTA is

  -- Author  : MPOSTIGOC
  -- Created : 2/07/2018 1:17:18 p. m.
  -- Purpose : 
  -----------------------------------------------------------------------
  procedure sp_cr_VerTipVivienda(ln_Instancia   in number,
                                 lc_TipVivienda out number);
  -----------------------------------------------------------------------
  procedure sp_cr_VerFechIniNeg(ln_Instancia in number,
                                ln_DiaDirNeg out number);
  -----------------------------------------------------------------------
  procedure sp_crd_tasa_menor(vi_instancia in number,
                              p_pais       in number,
                              p_tipd       in number,
                              p_docum      in varchar, --2018.08.03 - Agregagado cambio de tipo de dato de numeric a varchar
                              fec_actual   in date,
                              vf_tasa      out fsd010.aotasa%type);
  -----------------------------------------------------------------------
  Procedure sp_cr_cap_trabajo_vig(ve_pais       in number,
                                  ve_tipdoc     in number,
                                  ve_docum      in varchar,
                                  flag_cap_trab out varchar);
  -----------------------------------------------------------------------

end PQ_CR_CAMP_TIMEFIESTA;
/

create or replace package body PQ_CR_CAMP_TIMEFIESTA is

  procedure sp_cr_VerTipVivienda(ln_Instancia   in number,
                                 lc_TipVivienda out number) is
  
    ln_pais   number;
    ln_tipdoc number;
    lc_numdoc varchar2(12);
  
  begin
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tipdoc, lc_numdoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
    
      select c.sngc12vivc -- Tipo de Vivienda Legal
        into lc_TipVivienda
        from sngc13 c
       where c.sngc13pais = ln_pais
         and c.sngc13tdoc = ln_tipdoc
         and c.sngc13ndoc = lc_numdoc
         and c.docod = 1
         and c.sngc13est = 'H';
    exception
      when others then
        null;
      
    end;
  
  end sp_cr_VerTipVivienda;
  ----------------------------------------------------------------------
  procedure sp_cr_VerFechIniNeg(ln_Instancia in number,
                                ln_DiaDirNeg out number) is
  
    ln_pais       number;
    ln_tipdoc     number;
    lc_numdoc     varchar2(12);
    ld_FchSist    date;
    ld_FechIniNeg date;
  
  begin
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tipdoc, lc_numdoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select pgfape into ld_FchSist from fst017 where pgcod = 1;
    end;
  
    begin
    
      select min(c.sngc13rdes) -- Fecha de Inicio del Negocio -- mpostigoc INC1359 270918
        into ld_FechIniNeg
        from sngc13 c
       where c.sngc13pais = ln_pais
         and c.sngc13tdoc = ln_tipdoc
         and c.sngc13ndoc = lc_numdoc
         and c.docod = 3
         and c.sngc13est = 'H';
    exception
      when others then
        null;
    end;
  
    begin
      ln_DiaDirNeg := ld_FchSist - ld_FechIniNeg;
    end;
  
  end sp_cr_VerFechIniNeg;
  ----------------------------------------------------------------------------------------
  procedure sp_crd_tasa_menor(vi_instancia in number,
                              p_pais       in number,
                              p_tipd       in number,
                              p_docum      in varchar, --2018.08.03 - Agregagado cambio de tipo de dato de numeric a varchar
                              fec_actual   in date,
                              vf_tasa      out fsd010.aotasa%type) is
    vo_tasa_act number(17, 6);
    vt_tasa_vig number(17, 6);
    vf_tasa_vig number(17, 6);
    cursor obtener_cuentas(vi_pais number, vi_tipdc number, vi_dni char) is
      select *
        from fsr008 f8
       where f8.pepais = vi_pais
         and f8.petdoc = vi_tipdc
         and f8.pendoc = vi_dni
         and f8.cttfir = 'T';
    cursor obtener_modulo is
      select tp1nro1 modul
        from fst198
       where tp1cod = 1 --2018.08.03 - Agregado un where adicional tp1cod = 1
         and tp1cod1 = 11005
         and tp1corr1 = 5
         and tp1corr2 = 3
         and tp1corr3 > 0;
    cursor obtener_tasa(cv_aocta in number, cv_modul in number) is
      select d10.aotasa, d10.Aocta, d10.aomod, d10.aooper, d10.aostat
        from fsd010 d10
       where pgcod = 1 --2018.08.03 - Agregagado un where adicional pgcod = 1
         and aocta = cv_aocta
         and aomod = cv_modul
         and aostat <> 99;
  begin
    -- Tasa actual.
    vf_tasa_vig := 0;
    vo_tasa_act := 0;
    begin
      pq_cr_tasatarifario.Sp_cr_Inicio(vi_instancia,
                                       fec_actual,
                                       vo_tasa_act);
    end;
    vf_tasa_vig := vo_tasa_act; --se asigna una tasa igual al calculado, y cambia la variable si un credito vigente de capital de trabajo 
    --tiene una tasa menor.
    -- Tasa de los creditos vigentes la menor.
    for j in obtener_modulo loop
      for i in obtener_cuentas(p_pais, p_tipd, p_docum) loop
        for k in obtener_tasa(i.ctnro, j.modul) loop
          begin
            vt_tasa_vig := k.aotasa;
            if vf_tasa_vig > vt_tasa_vig then
              vf_tasa_vig := vt_tasa_vig;
            end if;
          end;
        end loop;
      end loop;
      --caso tenga tasa vigente de otros creditos con capital de trabajo.
      if vf_tasa_vig <= vo_tasa_act then
        vf_tasa := vf_tasa_vig;
      else
        vf_tasa := vo_tasa_act;
      end if;
    end loop;
  end sp_crd_tasa_menor;
  ----------------------------------------------------------------------------------------
  ---
  ----------------------------------------------------------------------------------------
  Procedure sp_cr_cap_trabajo_vig(ve_pais       in number,
                                  ve_tipdoc     in number,
                                  ve_docum      in varchar,
                                  flag_cap_trab out varchar) IS
    vi_docum char(12);
    cursor obtener_cuentas(vi_pais number, vi_tipdc number, vi_dni char) is
      select *
        from fsr008 f8
       where f8.pepais = vi_pais
         and f8.petdoc = vi_tipdc
         and f8.pendoc = vi_dni
         and f8.cttfir = 'T';
  
    cursor obtener_modulo is
      select tp1nro1 modul
        from fst198
       where tp1cod = 1 --2018.09.27 mpostigoc
         and tp1cod1 = 11005
         and tp1corr1 = 5
         and tp1corr2 = 3
         and tp1corr3 > 0;
  
  begin
    vi_docum      := ve_docum;
    flag_cap_trab := 'N';
    for j in obtener_modulo loop
      for i in obtener_cuentas(ve_pais, ve_tipdoc, vi_docum) loop
        begin
          select 'S'
            into flag_cap_trab
            from fsd010 fd
           where fd.pgcod = 1
             and fd.aomod = j.modul
             and fd.aocta = i.ctnro
             and fd.aostat <> 99
             and rownum = 1;
        exception
          when no_data_found then
            null;
            --if flag_cap_trab <> 'S' then
          -- flag_cap_trab:='N';
          --end if
        end;
        if flag_cap_trab = 'S' then
          exit;
        end if;
      end loop;
    end loop;
  end sp_cr_cap_trabajo_vig;
  ----------------------------------------------------------------------------------------
---
----------------------------------------------------------------------------------------
end PQ_CR_CAMP_TIMEFIESTA;
/

