create or replace package pq_cr_rn_seguros is

  -- Author  : RMONTESR
  -- Created : 7/09/2021 14:37:14
  -- Purpose : Paquete con procedimientos para RN RAQPB388
  -- Modificacion  : SMARQUEZ
  -- Created : 21/09/2021
  -- Purpose : Paquete con procedimientos para RN RAQPB664

  procedure sp_cr_obtener_seguro(pn_Instancia in number,
                                 pv_seguro    out varchar2);

  ---------------------------------------------------------------------------
  procedure sp_cr_verif_tiposeguro(pn_Instancia  in number,
                                   pc_TipSeguro1 out varchar2,
                                   pc_TipSeguro2 out varchar2,
                                   pc_TipSeguro3 out varchar2,
                                   pc_TipSeguro4 out varchar2,
                                   pc_TipSeguro5 out varchar2);
  ---------------------------------------------------------------------------
  procedure sp_cr_si_reprog(pn_instancia in number,
                            pv_reprog    in out varchar2);

end pq_cr_rn_seguros;
/

create or replace package body pq_cr_rn_seguros is

  -----------------------------------------------------------------------------------------------
  procedure sp_cr_obtener_seguro(pn_Instancia in number,
                                 pv_seguro    out varchar2) is
  
    ln_modulo  number;
    ln_tipoper number;
    ln_cuenta  number;
    ln_pais    number;
    ln_tdoc    number;
    lc_ndoc    char(12);
    ld_fnac    date;
  
    ln_edad      numeric;
    ln_frecpago  numeric;
    ln_cvuelo    numeric;
    lc_exonerado char(1);
  
  begin
    ln_cvuelo := 0;
    begin
      select x.xwfmodulo, x.xwftipope, y.aoperiod, x.xwfcuenta
        into ln_modulo, ln_tipoper, ln_frecpago, ln_cuenta
        from xwf700 x
       inner join fsd010 y
          on x.xwfempresa = y.pgcod
         and x.xwfsucursal = y.aosuc
         and x.xwfmodulo = y.aomod
         and x.xwfmoneda = y.aomda
         and x.xwfpapel = y.aopap
         and x.xwfcuenta = y.aocta
         and x.xwfoperacion = y.aooper
         and x.xwfsubope = y.aosbop
         and x.xwftipope = y.aotope
      
       where x.xwfprcins = pn_Instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
    begin
      select count(*)
        into ln_cvuelo
        from wfwrkitems c
       where c.wfinsprcid = pn_instancia
         and c.wfitemstsact = 1;
    exception
      when others then
        ln_cvuelo := 0;
    end;
    if ln_cvuelo > 0 then
      begin
        select n.xllperiodo
          into ln_frecpago
          from fsd016 m
         inner join x054023 n
            on n.xllpgcod = m.pgcod
           and n.xllaocta = m.ctnro
           and n.xllaooper = m.itoper
         where m.pgcod = 1
           and m.ctnro = ln_cuenta
           and m.ittran in (50, 60)
           and m.itord = 10
           and m.itnrel = (select max(itnrel)
                             from fsd016
                            where pgcod = 1
                              and ctnro = ln_cuenta
                              and ittran in (50, 60)
                              and itord = 10)
           and rownum <= 1;
      exception
        when others then
          ln_frecpago := 30;
      end;
    else
      begin
        select m.xllperiodo
          into ln_frecpago
          from (select *
                  from fsd016 a
                 inner join fsd015 b
                    on a.pgcod = b.pgcod
                   and a.itsuc = b.itsuc
                   and a.itmod = b.itmod
                   and a.ittran = b.ittran
                   and a.itnrel = b.itnrel
                 inner join x054023 c
                    on a.pgcod = c.xllpgcod
                   and a.modulo = c.xllaomod
                   and a.ittope = c.xllaotop
                   and a.itsucd = c.xllaosuc
                   and a.moneda = c.xllaomda
                   and a.papel = c.xllaopap
                   and a.ctnro = c.xllaocta
                   and a.itoper = c.xllaooper
                   and a.itsubo = c.xllaosbop
                 where a.pgcod = 1
                   and a.itmod = 116
                   and a.ittran in (50, 60)
                   and a.itord = 10
                   and a.ctnro = ln_cuenta
                   and a.moneda in (0, 101)
                   and a.papel = 0
                   and a.itfval =
                       (select pgfape from fst017 where pgcod = 1)
                   and b.itcorr = 0
                 order by b.ithora desc) m
         where rownum = 1;
      exception
        when others then
          ln_frecpago := 30;
      end;
    end if;
    begin
      select x.sng001pais, x.sng001tdoc, x.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 x
       where x.sng001inst = pn_instancia;
    exception
      when others then
        null;
    end;
    begin
      select a.pffnac
        into ld_fnac
        from fsd002 a
       where a.pfpais = ln_pais
         and a.pftdoc = ln_tdoc
         and a.pfndoc = lc_ndoc;
    exception
      when others then
        null;
    end;
    begin
      select floor(months_between(b.pgfape, ld_fnac) / 12)
        into ln_edad
        from fst017 b
       where b.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    lc_Exonerado := 'N';
  
    begin
      select 'S'
        into lc_Exonerado
        from jaqz053
       where JAQZ053PAI = ln_pais
         and JAQZ053TDO = ln_tdoc
         and JAQZ053NDO = lc_ndoc
         and JAQZ053INS = pn_instancia
         and rownum = 1;
    exception
      when others then
        lc_Exonerado := 'N';
    end;
    if lc_Exonerado = 'N' then
      begin
        select 'S'
          into lc_Exonerado
          from jaql984
         where JAQL984PAIS = ln_pais
           and JAQL984TDOC = ln_tdoc
           and JAQL984NDOC = lc_ndoc
           and JAQL984ESTA = 'E'
           and JAQL984INST = pn_instancia
           and rownum = 1;
      exception
        when others then
          lc_Exonerado := 'N';
      end;
    end if;
    if lc_Exonerado = 'N' then
      if ln_modulo = 116 or ln_modulo = 117 then
        if ln_edad > 70 then
          if ln_edad < 80 then
            if ln_tipoper = 10 or ln_tipoper = 13 or ln_tipoper = 15 or
               ln_tipoper = 16 or ln_tipoper = 17 or ln_tipoper = 18 then
              begin
                SELECT tp1nro2
                  into pv_seguro
                  FROM FST198
                 where tp1cod = 1
                   and tp1cod1 = 11164
                   and tp1corr1 = 3
                   and tp1corr2 = 1
                   and tp1nro1 = ln_frecpago;
              exception
                when others then
                  pv_seguro := 0;
              end;
            else
              begin
                SELECT tp1nro2
                  into pv_seguro
                  FROM FST198
                 where tp1cod = 1
                   and tp1cod1 = 11164
                   and tp1corr1 = 3
                   and tp1corr2 = 2
                   and tp1nro1 = ln_frecpago;
              exception
                when others then
                  pv_seguro := 0;
              end;
            end if;
          else
            pv_seguro := 0;
          end if;
        else
          if ln_tipoper = 10 or ln_tipoper = 13 or ln_tipoper = 15 or
             ln_tipoper = 16 or ln_tipoper = 17 or ln_tipoper = 18 then
            begin
              SELECT tp1nro2
                into pv_seguro
                FROM FST198
               where tp1cod = 1
                 and tp1cod1 = 11164
                 and tp1corr1 = 3
                 and tp1corr2 = 3
                 and tp1nro1 = ln_frecpago;
            exception
              when others then
                pv_seguro := 0;
            end;
          else
            begin
              SELECT tp1nro2
                into pv_seguro
                FROM FST198
               where tp1cod = 1
                 and tp1cod1 = 11164
                 and tp1corr1 = 3
                 and tp1corr2 = 4
                 and tp1nro1 = ln_frecpago;
            exception
              when others then
                pv_seguro := 0;
            end;
          end if;
        
        end if;
      else
        pv_seguro := 0;
      end if;
    else
      pv_seguro := 0;
    end if;
  end sp_cr_obtener_seguro;
  -----------------------------------------------------------------
  procedure sp_cr_verif_tiposeguro(pn_Instancia  in number,
                                   pc_TipSeguro1 out varchar2,
                                   pc_TipSeguro2 out varchar2,
                                   pc_TipSeguro3 out varchar2,
                                   pc_TipSeguro4 out varchar2,
                                   pc_TipSeguro5 out varchar2) is
    cursor tipo_seguro(ln_mod  in number,
                       ln_tipo in number,
                       ln_mda  in number) is
      Select distinct sgsn02
        from x054011 a
       inner join fst300 b
          on a.sgcod = b.sgcod
       where a.xpremod = ln_mod
         and a.xpretope = ln_tipo
         and a.xpremoneda = ln_mda;
  
    ln_modulo  number := 0;
    ln_tipoper number := 0;
    ln_moneda  number := 0;
  
    TSeg1 varchar2(1) := 'N';
    TSeg2 varchar2(1) := 'N';
    TSeg3 varchar2(1) := 'N';
    TSeg4 varchar2(1) := 'N';
    TSeg5 varchar2(1) := 'N';
  
  Begin
    Begin
      select x.xwfmodulo, x.xwftipope, x.xwfmoneda
        into ln_modulo, ln_tipoper, ln_moneda
        from xwf700 x
       where x.xwfprcins = pn_Instancia
         and x.xwfcar3 = '1';
      for r in tipo_seguro(ln_modulo, ln_tipoper, ln_moneda) loop
        if r.sgsn02 = 1 then
          TSeg1 := 'S';
        ELSIF r.sgsn02 = 2 then
          TSeg2 := 'S';
        ELSIF r.sgsn02 = 3 then
          TSeg3 := 'S';
        ELSIF r.sgsn02 = 4 then
          TSeg4 := 'S';
        ELSIF r.sgsn02 = 5 then
          TSeg5 := 'S';
        END IF;
      end loop;
      pc_TipSeguro1 := TSeg1; ---1 VC ,
      pc_TipSeguro2 := TSeg2;
      pc_TipSeguro3 := TSeg3; --  3 VEHICULAR,
      pc_TipSeguro4 := TSeg4; --  4 SALUDFAMILIAR,
      pc_TipSeguro5 := TSeg5; --  5 desgra
    
    exception
      when others then
        pc_TipSeguro1 := null; ---1 VC ,
        pc_TipSeguro2 := null;
        pc_TipSeguro3 := null; --  3 VEHICULAR,
        pc_TipSeguro4 := null; --  4 SALUDFAMILIAR,
        pc_TipSeguro5 := null; --  5 desgra
    end;
  
  end sp_cr_verif_tiposeguro;
  -----------------------------------------------------------------
  procedure sp_cr_si_reprog(pn_instancia in number,
                            pv_reprog    in out varchar2) is
    lv_n_si_reprog integer;
  begin
    lv_n_si_reprog := 0;
    begin
      select count(*)
        into lv_n_si_reprog
        from JAQA400
       where JAQA400EST = 'C'
         and JAQA400AI1 = pn_instancia;
    exception
      when others then
        null;
    end;
    if lv_n_si_reprog = 0 then
      pv_reprog := 'N';
    else
      pv_reprog := 'S';
    end if;
  end sp_cr_si_reprog;

end pq_cr_rn_seguros;
/

