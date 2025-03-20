create or replace package PQ_CR_REPROGRAMACIONES is
  /*
     -- Author  : MPOSTIGOC - PESPINOZA
     -- Created : 03/08/2016 09:50:01 a.m.
     -- Purpose : Calculo de resolutores para Tratamiento de Creditos Reprogramados
     -- Usuario de Modificacion: Maria Caridad Postigo Condori
     -- Fecha:   21/09/2017
     -- Modificaciones: Modificacion en procedimiento sp_cr_resolutorA, para que solo haga la busqueda de un pago
     --                 en la tabla FSD602, para casos en los que tengan doble registro con la misma fecha de 
     --                 calendario, ejemplo amortizaciones, utilziacion de Lineas, pago de lineas
    
     -- Usuario de Modificacion: Maria Caridad Postigo Condori
     -- Fecha:   15/11/2017
     -- Modificaciones: Modificacion en procedimiento sp_cr_resolutorG, E, C1, para que considere todas
                        las cuotas de los creditos que tiene el cliente por vencidas, se considera las repro
                        gramaciones contabilizadas en la XWF070 XWFCONT = 'S'
     -- Usuario de Modificacion: Maria Caridad Postigo Condori
     -- Fecha:   03/10/2024
     -- Modificaciones: Se Modifico el procedimiento sp_cr_resolutorD, se obtiene el periodo y nro de cuotas de la tabla x054023.
     
  */

  PROCEDURE sp_cr_resolutorA(ln_Pepais in number,
                             ln_Petdoc in number,
                             ln_Pendoc in char,
                             ld_FchPrc date,
                             Pc_flag   out varchar2);

  procedure sp_cr_resolutorB(ln_Pepais in number,
                             ln_Petdoc in number,
                             ln_Pendoc in char,
                             Pc_flag   out varchar2
                             --pd_fecpro     in date
                             );

  procedure sp_resolutorb1(ln_pgcod10    in number,
                           ln_mod10      in number,
                           ln_suc10      in number,
                           ln_mda10      in number,
                           ln_pap10      in number,
                           ln_cta10      in number,
                           ln_oper10     in number,
                           ln_sbop10     in number,
                           ln_tope10     in number,
                           ln_NRO_CUOTAS out number);
  procedure sp_cr_NroCuotPagRep(ln_Instancia     in number,
                                ln_NroCuoPagRepr out number);

  procedure sp_cr_resolutorC(instancia in number, lc_message out varchar);

  procedure sp_cr_resolutorC1(cuenta        in number,
                              operacion     in number,
                              sucursal      in number,
                              moneda        in number,
                              papel         in number,
                              modulo        in number,
                              suboperacion  in number,
                              tipooperacion in number,
                              nro_reprog    out number);

  procedure sp_cr_resolutorD(instancia in number, lc_flag out varchar);

  procedure sp_cr_resolutorE(ln_Pepais in number,
                             ln_Petdoc in number,
                             ln_Pendoc in char,
                             ld_FchPrc in date,
                             lc_flag   OUT varchar);

  procedure sp_cr_pagos(ln_nromora   in number,
                        ln_registros in number,
                        lc_flag      out varchar2);

  procedure sp_cr_resolutorF(ln_Pepais    in number,
                             ln_Petdoc    in number,
                             ln_Pendoc    in char,
                             ln_instancia in NUMBER,
                             ln_Destino   out VARCHAR2);

  procedure sp_cr_resolutorG(ln_Pepais in number,
                             ln_Petdoc in number,
                             ln_Pendoc in char,
                             ld_FchPrc in date,
                             lc_flag   out varchar);

end PQ_CR_REPROGRAMACIONES;
/

create or replace package body PQ_CR_REPROGRAMACIONES is

  ----------------------------------------------------------------------------------
  /* Estar al día en sus obligaciones en Caja Arequipa,
  Titular principal y cónyuge del titular principal-  K.  FSD010 -FSD601-FSD602*/

  PROCEDURE sp_cr_resolutorA(ln_Pepais in number,
                             ln_Petdoc in number,
                             ln_Pendoc in char,
                             ld_FchPrc date,
                             Pc_flag   out varchar2) is
  
    ld_FchCalnda date;
  
    cursor data is
      select d10.pgcod  ln_pgcod,
             d10.aomod  ln_modulo,
             d10.aosuc  ln_sucursal,
             d10.aomda  ln_moneda,
             d10.aopap  ln_papel,
             d10.aocta  ln_cuenta,
             d10.aooper ln_operacion,
             d10.aosbop ln_sbopera,
             d10.aotope ln_tipopera
        from fsd010 d10 /*, fsd602 f*/
       where d10.pgcod = 1
         and Aocta in (select Ctnro
                         from fsr008
                        where pepais = ln_Pepais
                          and Petdoc = ln_Petdoc
                          and pendoc = ln_Pendoc)
         and (Aomod in (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (107, 108, 141)))
            
         and d10.aostat <> 99
       group by d10.pgcod,
                d10.aomod,
                d10.aosuc,
                d10.aomda,
                d10.aopap,
                d10.aocta,
                d10.aooper,
                d10.aosbop,
                d10.aotope
      union
      select b.pgcod  ln_pgcod,
             b.aomod  ln_modulo,
             b.aosuc  ln_sucursal,
             b.aomda  ln_moneda,
             b.aopap  ln_papel,
             b.aocta  ln_cuenta,
             b.aooper ln_operacion,
             b.aosbop ln_sbopera,
             b.aotope ln_tipopera
        from fsr008 a, fsd010 b, fsr002 c /*, fsd602 f*/
       where a.pgcod = 1
         and b.pgcod = 1
            --  and f.pgcod = 1
         and c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and (b.Aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (107, 108, 141)))
         and c.rpccyg = 66
            
         and b.aostat <> 99 --and f.d602co = 'S'
       group by b.pgcod,
                b.aomod,
                b.aosuc,
                b.aomda,
                b.aopap,
                b.aocta,
                b.aooper,
                b.aosbop,
                b.aotope;
  
    lc_Flag      varchar(2);
    ld_NroCuotas number;
    ld_fchdesm   date;
  
  begin
    for i in data loop
    
      Pc_flag := 'N';
    
      begin
        select count(*)
          into ld_NroCuotas
          from fsd601 f
         where f.pgcod = i.ln_pgcod
           and f.ppmod = i.ln_modulo
           and f.ppsuc = i.ln_sucursal
           and f.ppmda = i.ln_moneda
           and f.pppap = i.ln_papel
           and f.ppcta = i.ln_cuenta
           and f.ppoper = i.ln_operacion
           and f.ppsbop = i.ln_sbopera
           and f.pptope = i.ln_tipopera;
      exception
        when no_data_found then
          ld_NroCuotas := 0;
      end;
    
      if ld_NroCuotas > 1 then
      
        begin
          begin
            select max(f.ppfpag)
              into ld_FchCalnda
              from fsd601 f
             where f.pgcod = i.ln_pgcod
               and f.ppmod = i.ln_modulo
               and f.ppsuc = i.ln_sucursal
               and f.ppmda = i.ln_moneda
               and f.pppap = i.ln_papel
               and f.ppcta = i.ln_cuenta
               and f.ppoper = i.ln_operacion
               and f.ppsbop = i.ln_sbopera
               and f.pptope = i.ln_tipopera
               and f.ppfpag <= ld_FchPrc;
          end;
        
          begin
            select 'S'
              into lc_Flag
              from fsd602 f
             where f.pgcod = i.ln_pgcod
               and f.ppmod = i.ln_modulo
               and f.ppsuc = i.ln_sucursal
               and f.ppmda = i.ln_moneda
               and f.pppap = i.ln_papel
               and f.ppcta = i.ln_cuenta
               and f.ppoper = i.ln_operacion
               and f.ppsbop = i.ln_sbopera
               and f.pptope = i.ln_tipopera
               and f.ppfpag = ld_FchCalnda
               and f.pp1stat = 'T'
               and f.d602co = 'S'
               and rownum = 1; -- mod@mcpc 21/09/2017
          exception
            when no_data_found then
              lc_Flag := 'N';
          end;
        
          if lc_Flag = 'S' then
            Pc_flag := 'N'; -- No Deudor
          else
            if lc_Flag = 'N' then
              Pc_flag := 'S'; -- Si Deudor
              exit;
            end if;
          end if;
        
        end;
      
      else
        if ld_NroCuotas = 1 then
        
          begin
            select d.aofval
              into ld_fchdesm
              from fsd010 d
             where d.pgcod = i.ln_pgcod
               and d.aomod = i.ln_modulo
               and d.aosuc = i.ln_sucursal
               and d.aomda = i.ln_moneda
               and d.aopap = i.ln_papel
               and d.aocta = i.ln_cuenta
               and d.aooper = i.ln_operacion
               and d.aosbop = i.ln_sbopera
               and d.aotope = i.ln_tipopera
               and d.aostat <> 99;
          exception
            when others then
              null;
          end;
        
          begin
            select max(f.ppfpag)
              into ld_FchCalnda
              from fsd601 f
             where f.pgcod = i.ln_pgcod
               and f.ppmod = i.ln_modulo
               and f.ppsuc = i.ln_sucursal
               and f.ppmda = i.ln_moneda
               and f.pppap = i.ln_papel
               and f.ppcta = i.ln_cuenta
               and f.ppoper = i.ln_operacion
               and f.ppsbop = i.ln_sbopera
               and f.pptope = i.ln_tipopera;
          
          exception
            when others then
              null;
          end;
        
          if ld_fchdesm < ld_FchPrc and ld_FchCalnda >= ld_FchPrc then
            Pc_flag := 'N';
          
          else
            if ld_FchPrc > ld_FchCalnda then
            
              begin
                select max(f.ppfpag)
                  into ld_FchCalnda
                  from fsd601 f
                 where f.pgcod = i.ln_pgcod
                   and f.ppmod = i.ln_modulo
                   and f.ppsuc = i.ln_sucursal
                   and f.ppmda = i.ln_moneda
                   and f.pppap = i.ln_papel
                   and f.ppcta = i.ln_cuenta
                   and f.ppoper = i.ln_operacion
                   and f.ppsbop = i.ln_sbopera
                   and f.pptope = i.ln_tipopera
                   and f.ppfpag <= ld_FchPrc;
              end;
            
              begin
                select 'S'
                  into lc_Flag
                  from fsd602 f
                 where f.pgcod = i.ln_pgcod
                   and f.ppmod = i.ln_modulo
                   and f.ppsuc = i.ln_sucursal
                   and f.ppmda = i.ln_moneda
                   and f.pppap = i.ln_papel
                   and f.ppcta = i.ln_cuenta
                   and f.ppoper = i.ln_operacion
                   and f.ppsbop = i.ln_sbopera
                   and f.pptope = i.ln_tipopera
                   and f.ppfpag = ld_FchCalnda
                   and f.pp1stat = 'T'
                   and f.d602co = 'S'
                   and rownum = 1; -- mod@mcpc 21/09/2017
              exception
                when no_data_found then
                  lc_Flag := 'N';
              end;
            
              if lc_Flag = 'S' then
                Pc_flag := 'N'; -- No Deudor
              else
                if lc_Flag = 'N' then
                  Pc_flag := 'S'; -- Si Deudor
                  exit;
                end if;
              end if;
            
            end if;
          end if;
        
        end if;
      end if;
    
    end loop;
  
  end sp_cr_resolutorA;

  ----------------------------------------------------------------------
  /*  
    Haber cancelado por lo menos una cuota en todos los créditos en Caja Arequipa.
     Titular principal y cónyuge del titular principal. FSD601 -FSD602
  */

  procedure sp_cr_resolutorB(ln_Pepais in number,
                             ln_Petdoc in number,
                             ln_Pendoc in char,
                             Pc_flag   out varchar2) is
  
    ln_NRO_CUOTAS number;
    cursor inserta is
      select D10.PGCOD  ln_pgcod10,
             d10.aomod  ln_mod10,
             d10.aosuc  ln_suc10,
             d10.aomda  ln_mda10,
             d10.aopap  ln_pap10,
             d10.aocta  ln_cta10,
             d10.aooper ln_oper10,
             d10.aosbop ln_sbop10,
             d10.aotope ln_tope10
        from fsd010 d10
       where d10.Pgcod = 1
         and Aocta in (select Ctnro
                         from fsr008
                        where pepais = ln_Pepais
                          and Petdoc = ln_Petdoc
                          and pendoc = ln_Pendoc)
         and Aomod in (select modulo
                         from fst111
                        where dscod = 50
                          and modulo not in (107, 108, 141))
         and Aostat <> 99
      
      union
      
      select B.PGCOD  ln_pgcod10,
             b.aomod  ln_mod10,
             b.aosuc  ln_suc10,
             b.aomda  ln_mda10,
             b.aopap  ln_pap10,
             b.aocta  ln_cta10,
             b.aooper ln_oper10,
             b.aosbop ln_sbop10,
             b.aotope ln_tope10
        from fsr008 a, fsd010 b, fsr002 c, fsd602 f
       where a.pgcod = 1
         and c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and b.pgcod = f.pgcod
         and b.aomod = f.ppmod
         and b.aosuc = f.ppsuc
         and b.aomda = f.ppmda
         and b.aopap = f.pppap
         and b.aocta = f.ppcta
         and b.aooper = f.ppoper
         and b.aosbop = f.PPSBOP
         and b.aotope = f.PPTOPE
         and f.pp1stat = 'T'
         and f.d602co = 'S'
         and b.Aomod in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (107, 108, 141)) --Agregar guia de proceso para excluir modulos
         and b.aostat <> 99
         and c.rpccyg = 66;
  
  begin
    for i in inserta loop
    
      PQ_CR_REPROGRAMACIONES.sp_resolutorb1(I.ln_pgcod10,
                                            i.ln_mod10,
                                            i.ln_suc10,
                                            i.ln_mda10,
                                            i.ln_pap10,
                                            i.ln_cta10,
                                            i.ln_oper10,
                                            i.ln_sbop10,
                                            i.ln_tope10,
                                            ln_NRO_CUOTAS);
      begin
        if ln_NRO_CUOTAS >= 1 then
          Pc_flag := 'S';
        
        else
        
          Pc_flag := 'N';
          exit;
        
        end if;
      exception
        when others then
          null;
      end;
    
    end loop;
  
  end sp_cr_resolutorB;

  ---------------------------------------------------------------------------------------
  /* Nro de Cuotas Pagadas del Credito a Reprogramar
     INC1710 MPOSTIGOC 08/04/2019
  */
  procedure sp_cr_NroCuotPagRep(ln_Instancia     in number,
                                ln_NroCuoPagRepr out number) is
  
    lc_EsReprogramado varchar2(2);
    ln_pgcod          number;
    ln_sucursal       number;
    ln_modulo         number;
    ln_moneda         number;
    ln_papel          number;
    ln_cuenta         number;
    ln_operacion      number;
    ln_suboperacion   number;
    ln_tipoperacion   number;
  begin
  
    begin
      select 'S'
        into lc_EsReprogramado
        from sng001
       where sng001inst = ln_Instancia
         and sng001ori in (13, 14, 16);
    exception
      when others then
        lc_EsReprogramado := 'N';
    end;
  
    if lc_EsReprogramado = 'S' then
    
      begin
        select w.xwfempresa,
               w.xwfsucursal,
               w.xwfmodulo,
               w.xwfmoneda,
               w.xwfpapel,
               w.xwfcuenta,
               w.xwfoperacion,
               w.xwfsubope,
               w.xwftipope
          into ln_pgcod,
               ln_sucursal,
               ln_modulo,
               ln_moneda,
               ln_papel,
               ln_cuenta,
               ln_operacion,
               ln_suboperacion,
               ln_tipoperacion
          from xwf700 w
         where w.xwfprcins = ln_Instancia
           and w.xwfcar3 <> '1';
      exception
        when others then
          null;
      end;
    
      begin
        select count(*)
          into ln_NroCuoPagRepr
          from fsd602 f
         where f.pgcod = ln_pgcod
           and f.ppmod = ln_modulo
           and f.ppsuc = ln_sucursal
           and f.ppmda = ln_moneda
           and f.pppap = ln_papel
           and f.ppcta = ln_cuenta
           and f.ppoper = ln_operacion
           and f.ppsbop = ln_suboperacion
           and f.pptope = ln_tipoperacion
           and f.pp1stat = 'T'
           and f.d602co = 'S';
      exception
        when others then
          ln_NroCuoPagRepr := 0;
      end;
    
    else
      ln_NroCuoPagRepr := 0;
    end if;
  
  end sp_cr_NroCuotPagRep;

  ---------------------------------------------------------------------------------------

  procedure sp_resolutorb1(ln_pgcod10    in number,
                           ln_mod10      in number,
                           ln_suc10      in number,
                           ln_mda10      in number,
                           ln_pap10      in number,
                           ln_cta10      in number,
                           ln_oper10     in number,
                           ln_sbop10     in number,
                           ln_tope10     in number,
                           ln_NRO_CUOTAS out number) is
  begin
    BEGIN
      select count(*)
        into ln_NRO_CUOTAS
        from fsd602
       where Pgcod = ln_pgcod10
         and Ppmod = ln_mod10
         and Ppsuc = ln_suc10
         and Ppmda = ln_mda10
         and Pppap = ln_pap10
         and Ppcta = ln_cta10
         and Ppoper = ln_oper10
         and Ppsbop = ln_sbop10
         and Pptope = ln_tope10
         and D602co in ('S')
         and pp1stat = 'T';
    exception
      when others then
        null;
    end;
  end sp_resolutorb1;
  ----------------------------------------------------------------------------------------  

  ---------------------------------------------------------------------------------------  

  /*  Se puede realizar sólo una vez por crédito. 
    Solo se considerara créditos que tengan vínculos identificables en el sistema 
  */
  procedure sp_cr_resolutorC(instancia in number, lc_message out varchar) is
  
    pgcod         number;
    sucursal      number;
    modulo        number;
    moneda        number;
    papel         number;
    cuenta        number;
    operacion     number;
    suboperacion  number;
    tipooperacion number;
    nro_reprog    number;
  
  begin
  
    begin
    
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into pgcod,
             sucursal,
             modulo,
             moneda,
             papel,
             cuenta,
             operacion,
             suboperacion,
             tipooperacion
        from xwf700 x
       where x.xwfprcins = instancia
         and x.xwfcar3 <> '1';
    exception
      when others then
        null;
      
    end;
  
    PQ_CR_REPROGRAMACIONES.sp_cr_resolutorC1(cuenta,
                                             operacion,
                                             sucursal,
                                             moneda,
                                             papel,
                                             modulo,
                                             suboperacion,
                                             tipooperacion,
                                             nro_reprog);
  
    if nro_reprog >= 1 then
      lc_message := 'S';
    else
    
      lc_message := 'N';
    end if;
  
  end sp_cr_resolutorC;
  ----------------------------------------------------------------------------------------

  procedure sp_cr_resolutorC1(cuenta        in number,
                              operacion     in number,
                              sucursal      in number,
                              moneda        in number,
                              papel         in number,
                              modulo        in number,
                              suboperacion  in number,
                              tipooperacion in number,
                              nro_reprog    out number) is
  
    ln_InstUltReprog number(4);
    --lc_message varchar(100);                            
  begin
  
    nro_reprog := 0;
  
    begin
      select max(s.sng001inst)
        into ln_InstUltReprog
        from xwf700 d, sng001 s, wfwrkitems w, xwf070 x70
       where xwfprcins = sng001inst
         and sng001inst = WFINSPRCID
         and WFTASKCOD = 55
         and X70.XWFWRKITE = w.wfitemid
         AND x70.xwfpgcod = xwfempresa
         and x70.xwfprcin = xwfprcins
         and s.sng001ori in (13, 14, 16)
         and d.xwfempresa = 1
         and d.xwfsucursal = sucursal
         and d.xwfmodulo = modulo
         and d.xwfmoneda = moneda
         and d.xwfpapel = papel
         and d.xwfcuenta = cuenta
         and d.xwfoperacion = operacion
         and d.xwfsubope = suboperacion
         and d.xwftipope = tipooperacion
         and xwfcar3 <> '1'
         and x70.xwfcont = 'S';
    exception
      when others then
        ln_InstUltReprog := 0;
    end;
  
    if ln_InstUltReprog <> 0 then
    
      begin
        select count(*)
          into nro_reprog
          from xwf700 x, fsd010 f
         where x.xwfprcins = ln_InstUltReprog
           and x.xwfcar3 = '1'
           and x.xwfempresa = f.PGCOD
           and x.xwfsucursal = f.AOSUC
           and x.xwfmodulo = f.AOMOD
           and x.xwfmoneda = f.AOMDA
           and x.xwfpapel = f.AOPAP
           and x.xwfcuenta = f.AOCTA
           and x.xwfoperacion = f.AOOPER
           and x.xwfsubope = f.AOSBOP
           and x.xwftipope = f.AOTOPE;
      exception
        when others then
          nro_reprog := 0;
      end;
    
    end if;
  
  end sp_cr_resolutorC1;

  -------------------------------------------------------------------------------------------------
  /*Sólo aplica para créditos reprogramados de 6 a más cuotas - solo Pagos Mensuales y Bimensuales, 
  Obtener Número de cuotas pendientes de pago. FSD601-FSD602, validar frecuencia pagos*/

  procedure sp_cr_resolutorD(instancia in number, lc_flag out varchar) is
  
    ln_nrocuotas number;
    PERIODO      number;
    ln_bsnrocuo  number;
    ln_perio30   number;
    ln_perio60   number;
  
  begin
    begin
      --mpostigoc 25/09/2024
      select v.xllperiodo, v.xllcantcuo
        into PERIODO, ln_nrocuotas
        from xwf700 x, x054023 v
       where x.xwfempresa = v.xllpgcod
         and x.xwfsucursal = v.xllaosuc
         and x.xwfmodulo = v.xllaomod
         and x.xwfmoneda = v.xllaomda
         and x.xwfpapel = v.xllaopap
         and x.xwfcuenta = v.xllaocta
         and x.xwfoperacion = v.xllaooper
         and x.xwfsubope = v.xllaosbop
         and x.xwftipope = v.xllaotop
         and x.xwfprcins = instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      select tp1nro1
        into ln_bsnrocuo
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11004
         and tp1corr1 = 2
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select tp1nro1
        into ln_perio30
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11004
         and tp1corr1 = 3
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select tp1nro1
        into ln_perio60
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11004
         and tp1corr1 = 3
         and tp1corr2 = 1
         and tp1corr3 = 2;
    exception
      when others then
        null;
    end;
  
    if ln_nrocuotas >= ln_bsnrocuo and
       (PERIODO = ln_perio30 or PERIODO = ln_perio60) then
      lc_flag := 'S';
    else
      lc_flag := 'N';
    end if;
  
  end sp_cr_resolutorD;

  ----------------------------------------------------------------------------------
  /*  Record de pagos Promedio no mayor a 15 días, (hasta) en las seis últimas cuotas.*/

  procedure sp_cr_resolutorE(ln_Pepais in number,
                             ln_Petdoc in number,
                             ln_Pendoc in char,
                             ld_FchPrc in date,
                             lc_flag   out varchar) is
  
    ln_nromora   number := 0;
    ln_registros number := 0;
    --ln_NroCuotas number;
    ln_diaaux number;
  
    cursor cuotas is
      select *
        from (select f601.*
                from fsd010 d10, fsd601 f601
               where d10.Pgcod = 1
                 and d10.Aocta in (select Ctnro
                                     from fsr008
                                    where pepais = ln_Pepais
                                      and Petdoc = ln_Petdoc
                                      and pendoc = ln_Pendoc
                                      and Ttcod = 1
                                      and Cttfir = 'T')
                 and (d10.Aomod in
                     (select modulo
                         from fst111
                        where dscod = 50
                          and modulo not in
                              ((select tp1nro1
                                 from fst198
                                where tp1cod = 1
                                  and tp1cod1 = 11004
                                  and tp1corr1 = 1
                                  and tp1corr2 = 1))) or Aomod = 117)
                 and d10.Aostat <> 99
                 and f601.pgcod = 1
                 and d10.aomod = f601.ppmod
                 and d10.aosuc = f601.ppsuc
                 and d10.aomda = f601.ppmda
                 and d10.aopap = f601.pppap
                 and d10.aocta = f601.ppcta
                 and d10.aooper = f601.ppoper
                 and d10.aosbop = f601.ppsbop
                 and f601.d601co = 'S'
                 and f601.ppfpag <= ld_FchPrc
               order by f601.ppfpag desc) f
       where ROWNUM <= 6;
  
  begin
  
    for c in cuotas loop
    
      ln_registros := ln_registros + 1;
    
      begin
      
        select (f.d602fc - f.ppfpag)
          into ln_diaaux
          from fsd602 f
         where f.pgcod = c.pgcod
           and f.ppmod = c.ppmod
           and f.ppsuc = c.ppsuc
           and f.ppmda = c.ppmda
           and f.pppap = c.pppap
           and f.ppcta = c.ppcta
           and f.ppoper = c.ppoper
           and f.ppsbop = c.ppsbop
           and f.pptope = c.pptope
           and f.ppfpag = c.ppfpag
           and f.pp1stat = 'T'
           and f.d602co = 'S'
           and rownum = 1;
      exception
        when no_data_found then
          begin
            ln_diaaux := ld_FchPrc - c.ppfpag;
          end;
      end;
    
      ln_nromora := nvl(ln_nromora, 0) + nvl(ln_diaaux, 0);
    
    end loop;
  
    if ln_nromora < 0 then
      ln_nromora := 0;
    end if;
  
    if ln_registros > 0 then
      PQ_CR_REPROGRAMACIONES.sp_cr_pagos(ln_nromora, ln_registros, lc_flag);
    else
      if ln_registros <= 0 then
        lc_flag := 'S';
      
      end if;
    end if;
  
    /*else
    lc_flag := 'N';*/
  
  end sp_cr_resolutorE;
  ----------------------------------------------------------------------------------------------
  procedure sp_cr_pagos(ln_nromora   in number,
                        ln_registros in number,
                        lc_flag      out varchar2) is
  
    resultado number;
    ln_dias   number;
  
  begin
  
    resultado := nvl(ln_nromora, 0) / nvl(ln_registros, 0);
  
    begin
      select TP1NRO1
        INTO ln_dias
        From fst198 J
       where tp1cod = 1
         and tp1cod1 = 11004
         AND J.TP1CORR1 = 4
         AND J.TP1CORR2 = 1
         AND TP1CORR3 = 1;
    
    exception
      when others then
        null;
      
    end;
  
    if resultado <= ln_dias then
      lc_flag := 'N';
    
    else
      lc_flag := 'S';
    end if;
  
  end sp_cr_pagos;

  --------------------------------------------------------------------------------------
  /*  
  Retornar el destino del crédito. */

  procedure sp_cr_resolutorF(ln_Pepais    in number,
                             ln_Petdoc    in number,
                             ln_Pendoc    in char,
                             ln_instancia in NUMBER,
                             ln_Destino   out VARCHAR2) is
    --  lc_flag      varchar2(2);
  begin
    begin
      select k.sng014dsc
        into ln_Destino
        from sng001 h
       inner join SNG014 k
          on h.sng014cod = k.sng014cod
       where h.sng001pais = ln_Pepais
         and h.sng001tdoc = ln_Petdoc
         and h.sng001ndoc = ln_Pendoc
         and h.sng001inst = ln_instancia;
    
    exception
      when others then
        null;
    end;
  
  end sp_cr_resolutorF;

  -------------------------------------------------------------------------
  -- Record de Pagos no mayor a 8 dias hasta en las tres ultimas cuotas 

  procedure sp_cr_resolutorG(ln_Pepais in number,
                             ln_Petdoc in number,
                             ln_Pendoc in char,
                             ld_FchPrc in date,
                             lc_flag   out varchar) is
    ln_nromora   number;
    ln_registros number := 0;
    --ln_NroCuotas number;
    resultado number;
    ln_dias   number;
    ln_diaaux number;
    --ln_dia       number := 0;
  
    cursor cuotas is -- mpostigoc 15/11/17
      select *
      
        from (select f601.*
                from fsd010 d10, fsd601 f601
               where d10.Pgcod = 1
                 and d10.Aocta in (select Ctnro
                                     from fsr008
                                    where pepais = ln_Pepais
                                      and Petdoc = ln_Petdoc
                                      and pendoc = ln_Pendoc
                                      and Ttcod = 1
                                      and Cttfir = 'T')
                 and (d10.Aomod in
                     (select modulo
                         from fst111
                        where dscod = 50
                          and modulo not in
                              ((select tp1nro1
                                 from fst198
                                where tp1cod = 1
                                  and tp1cod1 = 11004
                                  and tp1corr1 = 1
                                  and tp1corr2 = 1))) or Aomod = 117)
                 and d10.Aostat <> 99
                 and f601.pgcod = 1
                 and d10.aomod = f601.ppmod
                 and d10.aosuc = f601.ppsuc
                 and d10.aomda = f601.ppmda
                 and d10.aopap = f601.pppap
                 and d10.aocta = f601.ppcta
                 and d10.aooper = f601.ppoper
                 and d10.aosbop = f601.ppsbop
                 and f601.d601co = 'S'
                 and f601.ppfpag <= ld_FchPrc
               order by f601.ppfpag desc) f
       where ROWNUM <= 3;
  
  begin
  
    for c in cuotas loop
      -- mpostigoc 15/11/17
    
      ln_registros := ln_registros + 1;
    
      begin
      
        select (f.d602fc - f.ppfpag)
          into ln_diaaux
          from fsd602 f
         where f.pgcod = c.pgcod
           and f.ppmod = c.ppmod
           and f.ppsuc = c.ppsuc
           and f.ppmda = c.ppmda
           and f.pppap = c.pppap
           and f.ppcta = c.ppcta
           and f.ppoper = c.ppoper
           and f.ppsbop = c.ppsbop
           and f.pptope = c.pptope
           and f.ppfpag = c.ppfpag
           and f.pp1stat = 'T'
           and f.d602co = 'S'
           and rownum = 1;
      exception
        when no_data_found then
          begin
            ln_diaaux := ld_FchPrc - c.ppfpag;
          end;
      end;
    
      ln_nromora := nvl(ln_nromora, 0) + nvl(ln_diaaux, 0);
    
    end loop;
  
    if ln_nromora < 0 then
      ln_nromora := 0;
    end if;
  
    if ln_registros > 0 then
    
      resultado := nvl(ln_nromora, 0) / nvl(ln_registros, 0);
    
      begin
        select TP1NRO1
          INTO ln_dias
          From fst198 J
         where tp1cod = 1
           and tp1cod1 = 11004
           AND J.TP1CORR1 = 4
           AND J.TP1CORR2 = 1
           AND TP1CORR3 = 2;
      
      exception
        when others then
          null;
        
      end;
    
      if resultado <= ln_dias then
        lc_flag := 'N';
      
      else
        lc_flag := 'S';
      end if;
    
      /*else
      if ln_registros <= 0 then
        lc_flag := 'S';
      end if;*/
    end if;
  
  end sp_cr_resolutorG;

end PQ_CR_REPROGRAMACIONES;
/

