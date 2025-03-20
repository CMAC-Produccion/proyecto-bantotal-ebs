create or replace package PQ_CR_RCCLINEAS is

  -- Author  : MCANDIA
  -- Created : 25/07/2018
  -- Purpose : 
  --

  procedure SP_CR_CREDITODEUDA(ln_instancia   in number,
                               ln_PorcAumento out number,
                               ln_DeuAnt      out number,
                               ln_DeuAct      out number);

  function FN_CR_FECHRCCANTES(ld_fecha in date) return date; -- fecha desembolso

  procedure SP_CR_DEUDALINEAS(ln_instancia in number,
                              ld_fechrcc   in date,
                              ln_deuda     out number);

end PQ_CR_RCCLINEAS;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_RCCLINEAS is

  procedure SP_CR_CREDITODEUDA(ln_instancia   in number,
                               ln_PorcAumento out number,
                               ln_DeuAnt      out number,
                               ln_DeuAct      out number) is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_CREDITODEUDA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos
    -- Versión                    : 1
    -- Fecha de Creación          : 25/07/2018
    -- Autor de Creación          : MCANDIA
    -- Uso                        : PORCENTAJE DE INCREMENTO DE SALDO LINEA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : Solicitud del credito
    -- Parámetros de Salida       : porcentaje de incremento, deuda anterior, deuda actual
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación:
    -- *****************************************************************      
  
    cursor credito is
      select xwf700.xwfempresa,
             xwf700.xwfsucursal,
             xwf700.xwfmodulo,
             xwf700.xwfmoneda,
             xwf700.xwfpapel,
             xwf700.xwfcuenta,
             xwf700.xwfoperacion,
             xwf700.xwfsubope,
             xwf700.xwftipope
        from xwf700
       where xwf700.xwfprcins = ln_instancia
         and xwf700.xwfcar3 <> '1';
    cursor credito_Linea is
    
      select j.jaqy800pgcd,
             j.jaqy800mod,
             j.jaqy800suc,
             j.jaqy800mda,
             j.jaqy800pap,
             j.jaqy800cta,
             j.jaqy800ope,
             j.jaqy800sbop,
             j.jaqy800tope
        from jaqy800 j
       where j.jaqy800pgcd = 1
         and j.jaqy800ins = ln_instancia;
  
    cursor fecha_desembolso(ln_xwfempresa   number,
                            ln_xwfsucursal  number,
                            ln_xwfmodulo    number,
                            ln_xwfmoneda    number,
                            ln_xwfpapel     number,
                            ln_xwfcuenta    number,
                            ln_xwfoperacion number,
                            ln_xwfsubope    number,
                            ln_xwftipope    number) is
    
      select fsd010.aofval
        from fsd010
       where fsd010.pgcod = ln_xwfempresa
         and fsd010.aomod = ln_xwfmodulo
         and fsd010.aosuc = ln_xwfsucursal
         and fsd010.aomda = ln_xwfmoneda
         and fsd010.aopap = ln_xwfpapel
         and fsd010.aocta = ln_xwfcuenta
         and fsd010.aooper = ln_xwfoperacion
         and fsd010.aosbop = ln_xwfsubope
         and fsd010.aotope = ln_xwftipope;
    --and fsd010.aostat = 99;
  
    fecharcc         date;
    FechRCCDesem     date;
    FechRCC          date;
    ln_porc          number(17, 2);
    ln_ModCredAmpl   number;
    ln_ExistRegistro number;
  
  begin
  
    begin
      select xwfmodulo
        into ln_ModCredAmpl
        from xwf700
       where xwfprcins = ln_instancia
         and xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_ModCredAmpl = 117 then
      begin
        select count(*)
          into ln_ExistRegistro
          from jaqy800 j
         where j.jaqy800pgcd = 1
           and j.jaqy800ins = ln_instancia;
      exception
        when others then
          null;
      end;
    
      if ln_ExistRegistro > 0 then
        for j in credito_Linea loop
          for c in fecha_desembolso(j.jaqy800pgcd,
                                    j.jaqy800suc,
                                    j.jaqy800mod,
                                    j.jaqy800mda,
                                    j.jaqy800pap,
                                    j.jaqy800cta,
                                    j.jaqy800ope,
                                    j.jaqy800sbop,
                                    j.jaqy800tope) loop
          
            FechRCCDesem := FN_CR_FECHRCCANTES(c.aofval);
          end loop;
        
        end loop;
      
      end if;
    
    else
      for i in credito loop
        for c in fecha_desembolso(i.xwfempresa,
                                  i.xwfsucursal,
                                  i.xwfmodulo,
                                  i.xwfmoneda,
                                  i.xwfpapel,
                                  i.xwfcuenta,
                                  i.xwfoperacion,
                                  i.xwfsubope,
                                  i.xwftipope) loop
        
          FechRCCDesem := FN_CR_FECHRCCANTES(c.aofval);
        end loop;
      
      end loop;
    end if;
  
    FechRCC := FechRCCDesem;
  
    PQ_CR_RCCLINEAS.SP_CR_DEUDALINEAS(ln_instancia, FechRCC, ln_DeuAnt);
  
    begin
      select to_date(a.tpnro, 'dd/mm/YYYY')
        into fecharcc
        from fst098 a
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      When others then
        fecharcc := to_date('01/01/0001', 'dd/mm/YYYY');
    end;
  
    FechRCC := fecharcc;
  
    PQ_CR_RCCLINEAS.SP_CR_DEUDALINEAS(ln_instancia, FechRCC, ln_DeuAct);
  
    if ln_DeuAnt = 0 and ln_DeuAct = 0 then
      ln_porc := 0;
    else
      if ln_DeuAnt = 0 and ln_DeuAct <> 0 then
        ln_porc := 100;
      else
        if ln_DeuAnt <> 0 and ln_DeuAct = 0 then
          ln_porc := 0;
        else
          if ln_DeuAnt <> 0 and ln_DeuAct <> 0 then
            --ln_porc := (((nvl(ln_DeuAct, 0) - nvl(ln_DeuAnt, 0)) * 100) /  --mod@20180726
            --           nvl(ln_DeuAct, 0));
          
            ln_porc := (((nvl(ln_DeuAct, 0) - nvl(ln_DeuAnt, 0)) * 100) /
                       nvl(ln_DeuAnt, 0)); --mod@abr 20180726
          end if;
        end if;
      end if;
    end if;
  
    ln_PorcAumento := ln_porc;
  
  end;

  function FN_CR_FECHRCCANTES(ld_fecha in date) return date is
  
    --ld_fecha  date := '15/06/2014';
    ld_fecrcc date;
    ln_dia    number(2) := 0;
    ld_rccini date;
    ld_rccact date;
  
  begin
  
    --obtener DIA dE CORTE PARA BUSQUEDA RCC de guia de proceso
    begin
      select f.tp1imp1
        into ln_dia
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 99
         and f.tp1corr2 = 1
         and f.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select max(j.jaqz700fecha)
        into ld_fecrcc
        from jaqz700 j
       where j.jaqz700fecha <= ld_fecha;
    exception
      when others then
        ld_fecrcc := null;
    end;
  
    --dbms_output.put_line(ld_fecha || ' ' || ld_fecrcc);
  
    if ld_fecrcc is not null then
      begin
        select to_date(j.jaqz700feini, 'ddmmrrrr'),
               to_date(j.jaqz700feact, 'ddmmrrrr')
          into ld_rccini, ld_rccact
          from jaqz700 j
         where j.jaqz700fecha = ld_fecrcc;
      exception
        when others then
          ld_rccact := null;
      end;
    
    else
      if EXTRACT(day FROM ld_fecha) < ln_dia then
        --considerar rcc de 2 meses atras  
        ld_rccact := add_months(last_day(ld_fecha), -2); --ld_fecha), -2);
      else
        -- rcc de un mes atras
        ld_rccact := add_months(last_day(ld_fecha), -1); --ld_fecha), -1);
      end if;
    end if;
  
    return ld_rccact;
  
  end FN_CR_FECHRCCANTES;

  procedure SP_CR_DEUDALINEAS(ln_instancia in number,
                              ld_fechrcc   in date,
                              ln_deuda     out number) is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_DEUDALINEA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos
    -- Versión                    : 1
    -- Fecha de Creación          : 25/07/2018
    -- Autor de Creación          : MCANDIA
    -- Uso                        : DEUDA EXTERNA (RCC) EXCLUYE CAJA AREQUIPA 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : solicitud del credito, fecha rcc
    -- Parámetros de Salida       : deuda externa
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación:
    -- *****************************************************************      
  
    cursor credito is
      select sng001.sng001pais, sng001.sng001tdoc, sng001.sng001ndoc
        from sng001
       where sng001.sng001inst = ln_instancia;
  
    cursor entidad(lv_codigosbs varchar2, ld_fechrccant date) is
      select cldrccs.c_codemp
        from cldrccs
       where cldrccs.c_codsbs = lv_codigosbs
         and cldrccs.d_fecpre = ld_fechrccant
         and cldrccs.c_codemp <> '00104'
       group by cldrccs.c_codemp;
  
    cursor deuda(lv_empresa   varchar2,
                 lv_codigosbs varchar2,
                 lv_fecharcc  date) is
      select cldrccs.c_cuenta, cldrccs.n_salcap
        from cldrccs
       where cldrccs.c_codsbs = lv_codigosbs
         and cldrccs.d_fecpre = lv_fecharcc
         and cldrccs.c_codemp = lv_empresa;
  
    ln_linea           number(16, 2) := 0.00;
    ln_utilizacion     number(16, 2) := 0.00;
    ln_responsabilidad number(16, 2) := 0.00;
    ln_credito4        number(16, 2) := 0.00;
    ln_credito6        number(16, 2) := 0.00;
    Lv_dni             varchar2(12);
    codigosbs          varchar2(10);
    --ln_deuda           number(16, 2) := 0.00;
    ln_result number(16, 2) := 0.00;
    cont      number;
  
  begin
  
    ln_deuda := 0.00;
  
    for i in credito loop
      Lv_dni := TRIM(i.sng001ndoc);
    
      if i.sng001tdoc <> 9 then
        BEGIN
          select cldrcci.c_codsbs
            INTO codigosbs
            from cldrcci
           where cldrcci.d_fecpre = ld_fechrcc
             and cldrcci.c_docide = Lv_dni;
        exception
          When others then
            codigosbs := '0';
        END;
      else
      
        BEGIN
          select cldrcci.c_codsbs
            INTO codigosbs
            from cldrcci
           where cldrcci.d_fecpre = ld_fechrcc
             and cldrcci.c_doctri = Lv_dni;
        exception
          When others then
            codigosbs := '0';
        END;
      end if;
    
      if codigosbs <> '0' then
      
        for b in entidad(codigosbs, ld_fechrcc) loop
        
          ln_linea           := 0;
          ln_utilizacion     := 0;
          ln_responsabilidad := 0;
          ln_credito4        := 0;
          ln_credito6        := 0;
        
          for c in deuda(b.c_codemp, codigosbs, ld_fechrcc) loop
          
            cont := 0;
            --> rubro linea <--
            begin
              begin
                select count(*)
                  into cont
                  from fst198
                 Where fst198.Tp1cod = 1
                   and fst198.Tp1cod1 = 10899
                   and fst198.Tp1corr1 = 13
                   and fst198.Tp1corr2 = 10
                   and trim(substr(c.c_cuenta, 1, 4)) =
                       trim(fst198.tp1desc)
                   and trim(substr(c.c_cuenta, 5, 2)) not in
                       (select trim(a.tp1desc)
                          from fst198 a
                         Where a.Tp1cod = 1
                           and a.Tp1cod1 = 10899
                           and a.Tp1corr1 = 13
                           and a.Tp1corr2 = 16);
              exception
                when others then
                  null;
              end;
            
              if cont > 0 then
              
                ln_linea := ln_linea + c.n_salcap;
              end if;
            end;
            --> rubro uso <--
          
            begin
              cont := 0;
            
              begin
                select count(*)
                  into cont
                  from fst198
                 Where fst198.Tp1cod = 1
                   and fst198.Tp1cod1 = 10899
                   and fst198.Tp1corr1 = 13
                   and fst198.Tp1corr2 = 8
                   and trim(substr(c.c_cuenta, 1, 4)) =
                       trim(fst198.tp1desc)
                   and trim(substr(c.c_cuenta, 7, 2)) in
                       (select trim(a.tp1desc)
                          from fst198 a
                         Where a.Tp1cod = 1
                           and a.Tp1cod1 = 10899
                           and a.Tp1corr1 = 13
                           and a.Tp1corr2 = 11);
              exception
                when others then
                  null;
              end;
            
              if cont > 0 then
                ln_utilizacion := ln_utilizacion + c.n_salcap;
              end if;
            
            end;
          
            --> rubro responsabilidad <--
            begin
              cont := 0;
              begin
                select count(*)
                  into cont
                  from fst198
                 Where fst198.Tp1cod = 1
                   and fst198.Tp1cod1 = 10899
                   and fst198.Tp1corr1 = 13
                   and fst198.Tp1corr2 = 9
                   and TRIM(substr(c.c_cuenta, 1, 6)) =
                       TRIM(fst198.tp1desc);
              exception
                when others then
                  null;
              end;
            
              if cont > 0 then
                ln_responsabilidad := ln_responsabilidad + c.n_salcap;
              end if;
            end;
          
            --****-DEUDA NO TARJETA-***---
          
            --> rubro de 4 digitos <--
            begin
              cont := 0;
            
              begin
                select count(*)
                  into cont
                  from fst198
                 Where Tp1cod = 1
                   and Tp1cod1 = 10899
                   and Tp1corr1 = 13
                   and Tp1corr2 = 6
                   and TRIM(fst198.tp1desc) =
                       TRIM(substr(c.c_cuenta, 1, 4))
                   and trim(substr(c.c_cuenta, 7, 2)) not in
                       (select trim(a.tp1desc)
                          from fst198 a
                         Where a.Tp1cod = 1
                           and a.Tp1cod1 = 10899
                           and a.Tp1corr1 = 13
                           and a.Tp1corr2 = 11);
              exception
                when others then
                  null;
              end;
            
              if cont > 0 then
                ln_credito4 := ln_credito4 + c.n_salcap;
              end if;
            end;
          
            --> rubro de 6 digitos <--
            begin
              cont := 0;
              begin
                select count(*)
                  into cont
                  from fst198
                 Where Tp1cod = 1
                   and Tp1cod1 = 10899
                   and Tp1corr1 = 13
                   and Tp1corr2 = 7
                   and TRIM(fst198.tp1desc) =
                       TRIM(substr(c.c_cuenta, 1, 6));
              exception
                when others then
                  null;
              end;
            
              if cont > 0 then
                ln_credito6 := ln_credito6 + c.n_salcap;
              end if;
            end;
          
          end loop;
        
          if ln_linea > (ln_responsabilidad + ln_utilizacion) then
            ln_result := ln_linea + ln_credito4 + ln_credito6;
          else
            ln_result := ln_responsabilidad + ln_utilizacion + ln_credito4 +
                         ln_credito6;
          end if;
        
          ln_deuda := ln_deuda + ln_result;
        
        end loop;
      
      end if;
    end loop;
  
  end SP_CR_DEUDALINEAS;

end PQ_CR_RCCLINEAS;
/

