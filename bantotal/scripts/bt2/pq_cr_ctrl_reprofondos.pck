create or replace package PQ_CR_CTRL_REPROFONDOS is

  -- Author  : MPOSTIGOC
  -- Created : 22/06/2021 13:47:46
  -- Purpose : 

  procedure sp_cr_nrocuotas(ln_instancia in number, ln_nrocuota out number);
  ------------------------------------------------------

  procedure sp_cr_plazototal(ln_instancia  in number,
                             lc_plazototal out varchar2);
  ---------------------------------------------------------
  procedure sp_cr_periodgracia(ln_instancia in number,
                               lc_prdgracia out varchar2);
  ---------------------------------------------------------
  procedure sp_cR_VerifFeriado(ln_sucursal  in number,
                               ld_fecha     in date,
                               lc_EsFeriado out varchar2);

end PQ_CR_CTRL_REPROFONDOS;
/

create or replace package body PQ_CR_CTRL_REPROFONDOS is

  procedure sp_cr_nrocuotas(ln_instancia in number, ln_nrocuota out number) is
  
    ln_pgcod  number;
    ln_modulo number;
    ln_suc    number;
    ln_mda    number;
    ln_pap    number;
    ln_cta    number;
    ln_ope    number;
    ln_subop  number;
    ln_tope   number;
  
  begin
  
    ln_nrocuota := 0;
    begin
      select x.xwfempresa,
             x.xwfmodulo,
             x.xwfsucursal,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into ln_pgcod,
             ln_modulo,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_subop,
             ln_tope
        from xwf700 x
       where x.xwfprcins = ln_instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_pgcod > 0 then
      begin
        select count(*)
          into ln_nrocuota
          from fsd601 f
         where f.pgcod = ln_pgcod
           and f.ppmod = ln_modulo
           and f.ppsuc = ln_suc
           and f.ppmda = ln_mda
           and f.pppap = ln_pap
           and f.ppcta = ln_cta
           and f.ppoper = ln_ope
           and f.ppsbop = 609
           and f.pptope = ln_tope;
      exception
        when others then
          ln_nrocuota := 0;
      end;
    end if;
  end sp_cr_nrocuotas;
  ----------------------------------------------------------------
  -- Reactiva: Plazo total Se obtiene fecha de alta de la operación inicial 
  -- y se cuentan los días hasta el vencimiento del crédito debe ser <= 5 años (en días 365*5)
  -- FAE1: La fecha a utilizar en el cálculo del plazo para FAE1 corresponde a la "fecha desembolso cofide".
  -- de tal forma que el cálculo para el plazo es: la fecha de vencimiento del crédito reprogramado - la fecha 
  --de desembolso cofide el cual debe ser <= a 48 meses.
  -- FAE2 Para el caso de FAE2 el plazo se calcula desde la fecha de desembolso del crédito original hasta el 
  -- vencimiento del crédito reprogramado el cual debe ser <= 48 meses.

  procedure sp_cr_plazototal(ln_instancia  in number,
                             lc_plazototal out varchar2) is
  
    ln_pgcod         number;
    ln_modulo        number;
    ln_suc           number;
    ln_mda           number;
    ln_pap           number;
    ln_cta           number;
    ln_ope           number;
    ln_subop         number;
    ln_tope          number;
    ld_fechadesm     date;
    ld_MaxFchRep     date;
    ln_plazoAux      number;
    lc_TipoProg      varchar2(20);
    ln_PlazoReactiva number;
    ln_PlazoFAE1     number;
    ln_PlazoFAE2     number;
  
  begin
  
    lc_plazototal    := 'S';
    ln_PlazoReactiva := (365 * 5) + 29;
    ln_PlazoFAE1     := 48;
    ln_PlazoFAE2     := 48;
  
    begin
      select x.xwfempresa,
             x.xwfmodulo,
             x.xwfsucursal,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into ln_pgcod,
             ln_modulo,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_subop,
             ln_tope
        from xwf700 x
       where x.xwfprcins = ln_instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_pgcod > 0 then
    
      begin
        SELECT f.tipoprograma
          into lc_TipoProg
          FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
         WHERE F.IDFONDO = G.IDFONDO
           AND G.ESTADOSOLICITUD = 'BT'
           AND SUBSTR(F.CUENTAOPERACION,
                      0,
                      INSTR(F.CUENTAOPERACION, '-') - 1) = ln_cta
           AND SUBSTR(F.CUENTAOPERACION,
                      INSTR(F.CUENTAOPERACION, '-') + 1,
                      99) = ln_ope
           AND F.EMPRESA = ln_pgcod
           AND F.SUCURSAL = ln_suc
           AND F.MODULO = ln_modulo
           AND F.MONEDA = ln_mda
           AND F.PAPEL = ln_pap
           AND F.SUBOPERACION = ln_subop
           AND F.TIPOOPERACION = ln_tope;
      exception
        when others then
          null;
      end;
    
      if lc_TipoProg = 'REACTIVA' then
      
        begin
          select f.aofval
            into ld_fechadesm
            from fsd010 f
           where f.pgcod = ln_pgcod
             and f.aomod = ln_modulo
             and f.aosuc = ln_suc
             and f.aomda = ln_mda
             and f.aopap = ln_pap
             and f.aocta = ln_cta
             and f.aooper = ln_ope
             and f.aosbop = ln_subop
             and f.aotope = ln_tope;
        exception
          when others then
            null;
        end;
      
        begin
          select max(f.ppfpag)
            into ld_MaxFchRep
            from fsd601 f
           where f.pgcod = ln_pgcod
             and f.ppmod = ln_modulo
             and f.ppsuc = ln_suc
             and f.ppmda = ln_mda
             and f.pppap = ln_pap
             and f.ppcta = ln_cta
             and f.ppoper = ln_ope
             and f.ppsbop = 609
             and f.pptope = ln_tope;
        exception
          when others then
            null;
        end;
      
        if ld_fechadesm is not null and ld_MaxFchRep is not null then
          ln_plazoAux := ld_MaxFchRep - ld_fechadesm;
          if ln_plazoAux > ln_plazoReactiva then
            lc_PlazoTotal := 'N';
          end if;
        end if;
      else
        if lc_TipoProg = 'FAE1' then
        
          begin
            select a.aqpb067bfdes
              into ld_fechadesm
              from aqpb067b a
             where a.aqpb067bcod = ln_pgcod
               and a.aqpb067bmod = ln_modulo
               and a.aqpb067bsuc = ln_suc
               and a.aqpb067bmda = ln_mda
               and a.aqpb067bpap = ln_pap
               and a.aqpb067bcta = ln_cta
               and a.aqpb067bope = ln_ope
               and a.aqpb067bsbo = ln_subop
               and a.aqpb067btop = ln_tope
               and a.aqpb067best <> 'D';
          end;
        
          begin
            select max(f.ppfpag)
              into ld_MaxFchRep
              from fsd601 f
             where f.pgcod = ln_pgcod
               and f.ppmod = ln_modulo
               and f.ppsuc = ln_suc
               and f.ppmda = ln_mda
               and f.pppap = ln_pap
               and f.ppcta = ln_cta
               and f.ppoper = ln_ope
               and f.ppsbop = 609
               and f.pptope = ln_tope;
          exception
            when others then
              null;
          end;
        
          if ld_fechadesm is not null and ld_MaxFchRep is not null then
            ln_plazoAux := months_between(ld_MaxFchRep, ld_fechadesm);
            if ln_plazoAux > ln_PlazoFAE1 then
              lc_PlazoTotal := 'N';
            end if;
          end if;
        
        else
          if lc_TipoProg = 'FAE2' then
          
            begin
              select f.aofval
                into ld_fechadesm
                from fsd010 f
               where f.pgcod = ln_pgcod
                 and f.aomod = ln_modulo
                 and f.aosuc = ln_suc
                 and f.aomda = ln_mda
                 and f.aopap = ln_pap
                 and f.aocta = ln_cta
                 and f.aooper = ln_ope
                 and f.aosbop = ln_subop
                 and f.aotope = ln_tope;
            exception
              when others then
                null;
            end;
          
            begin
              select max(f.ppfpag)
                into ld_MaxFchRep
                from fsd601 f
               where f.pgcod = ln_pgcod
                 and f.ppmod = ln_modulo
                 and f.ppsuc = ln_suc
                 and f.ppmda = ln_mda
                 and f.pppap = ln_pap
                 and f.ppcta = ln_cta
                 and f.ppoper = ln_ope
                 and f.ppsbop = 609
                 and f.pptope = ln_tope;
            exception
              when others then
                null;
            end;
          
            if ld_fechadesm is not null and ld_MaxFchRep is not null then
              ln_plazoAux := months_between(ld_MaxFchRep, ld_fechadesm);
              if ln_plazoAux > ln_PlazoFAE2 then
                lc_PlazoTotal := 'N';
              end if;
            end if;
          
          end if;
        end if;
      end if;
    
    end if;
  
  end sp_cr_plazototal;
  ----------------------------------------------------------------------
  -- Periodo de gracia 6 o 12 meses (180 días o 363 días) adicionales a los otorgados
  -- Mora: 01/07/2021 cuota   10/07/2021 procesar.- Obtener fecha de vencimiento de 
  --la primera cuota sea paga o impaga se suman 180 o 363 días y se controla que no se superen las fechas generadas 

  procedure sp_cr_periodgracia(ln_instancia in number,
                               lc_prdgracia out varchar2) is
  
    ln_pgcod     number;
    ln_modulo    number;
    ln_suc       number;
    ln_mda       number;
    ln_pap       number;
    ln_cta       number;
    ln_ope       number;
    ln_subop     number;
    ln_tope      number;
    ld_MinFchOri date;
    ld_MinFchRep date;
    lc_TipoProg  varchar2(15);
    ln_nroreg    number;
    ln_gracia    number;
    ln_maxgracia number;
    ln_graciamax number;
    ln_resul     number;
    ld_MaxFchPag date;
    lc_EsFeriado varchar2(2) := 'N';
    lc_EsHabil varchar2(2) := 'N';
    ld_DiaAnterior date;
  
  begin
  
    lc_prdgracia := 'S';
  
    begin
      select x.xwfempresa,
             x.xwfmodulo,
             x.xwfsucursal,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into ln_pgcod,
             ln_modulo,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_subop,
             ln_tope
        from xwf700 x
       where x.xwfprcins = ln_instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_pgcod > 0 then
    
      begin
        SELECT f.tipoprograma
          into lc_TipoProg
          FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
         WHERE F.IDFONDO = G.IDFONDO
           AND G.ESTADOSOLICITUD = 'BT'
           AND SUBSTR(F.CUENTAOPERACION,
                      0,
                      INSTR(F.CUENTAOPERACION, '-') - 1) = ln_cta
           AND SUBSTR(F.CUENTAOPERACION,
                      INSTR(F.CUENTAOPERACION, '-') + 1,
                      99) = ln_ope
           AND F.EMPRESA = ln_pgcod
           AND F.SUCURSAL = ln_suc
           AND F.MODULO = ln_modulo
           AND F.MONEDA = ln_mda
           AND F.PAPEL = ln_pap
           AND F.SUBOPERACION = ln_subop
           AND F.TIPOOPERACION = ln_tope;
      exception
        when others then
          null;
      end;
    
      if lc_TipoProg = 'FAE1' then
        lc_TipoProg := 'FAE 1';
      else
        if lc_TipoProg = 'FAE2' then
          lc_TipoProg := 'FAE 2';
        end if;
      end if;
    
      -- if lc_TipoProg = 'REACTIVA' then
    
      begin
        select max(f.ppfpag)
          into ld_MaxFchPag
          from fsd602 f
         where f.pgcod = ln_pgcod
           and f.ppmod = ln_modulo
           and f.ppsuc = ln_suc
           and f.ppmda = ln_mda
           and f.pppap = ln_pap
           and f.ppcta = ln_cta
           and f.ppoper = ln_ope
           and f.ppsbop = ln_subop
           and f.pptope = ln_tope
           and f.pp1stat = 'T'
           and f.d602co = 'S';
      exception
        when others then
          null;
      end;
    
      if ld_MaxFchPag is not null then
      
        begin
          select min(f.ppfpag)
            into ld_MinFchOri
            from fsd601 f
           where f.pgcod = ln_pgcod
             and f.ppmod = ln_modulo
             and f.ppsuc = ln_suc
             and f.ppmda = ln_mda
             and f.pppap = ln_pap
             and f.ppcta = ln_cta
             and f.ppoper = ln_ope
             and f.ppsbop = ln_subop
             and f.pptope = ln_tope
             and f.ppfpag > ld_MaxFchPag
             and f.d601co = 'S';
        exception
          when others then
            null;
        end;
      
      else
        if ld_MaxFchPag is null then
        
          begin
            select min(f.ppfpag)
              into ld_MinFchOri
              from fsd601 f
             where f.pgcod = ln_pgcod
               and f.ppmod = ln_modulo
               and f.ppsuc = ln_suc
               and f.ppmda = ln_mda
               and f.pppap = ln_pap
               and f.ppcta = ln_cta
               and f.ppoper = ln_ope
               and f.ppsbop = ln_subop
               and f.pptope = ln_tope
               and f.d601co = 'S';
          exception
            when others then
              null;
          end;
        
        end if;
      end if;
    
      begin
        select min(f.ppfpag)
          into ld_MinFchRep
          from fsd601 f
         where f.pgcod = ln_pgcod
           and f.ppmod = ln_modulo
           and f.ppsuc = ln_suc
           and f.ppmda = ln_mda
           and f.pppap = ln_pap
           and f.ppcta = ln_cta
           and f.ppoper = ln_ope
           and f.ppsbop = 609
           and f.pptope = ln_tope;
      exception
        when others then
          null;
      end;
    
      if ld_MinFchOri is not null and ld_MinFchRep is not null then
      
        ln_gracia := ld_MinFchRep - ld_MinFchOri;
      
        if lc_TipoProg = 'REACTIVA' then
        
          if ln_gracia >= 180 and ln_gracia <= 182 then
          
            begin
              Select tp1imp1
                into ln_graciamax
                from fst198
               where tp1cod1 = 10899
                 and tp1corr1 = 400000
                 and tp1corr2 = 6
                 and tp1corr3 > 0
                 and tp1desc = rpad(lc_TipoProg, 30, ' ')
                 and tp1corr3 = 1;
            exception
              when others then
                null;
            end;
          
          else
            if ln_gracia >= 363 and ln_gracia <= 365 then
            
              begin
                Select tp1imp1
                  into ln_graciamax
                  from fst198
                 where tp1cod1 = 10899
                   and tp1corr1 = 400000
                   and tp1corr2 = 6
                   and tp1corr3 > 0
                   and tp1desc = rpad(lc_TipoProg, 30, ' ')
                   and tp1corr3 = 2;
              exception
                when others then
                  null;
              end;
            end if;
          end if;
        
          if ln_graciamax > 0 then
          
            if ln_gracia = ln_graciamax then
              lc_prdgracia := 'S';
            
            else
              if ln_gracia = 181 or ln_gracia = 364 then
              
              ld_DiaAnterior:=ld_MinFchRep - 1;
              
                begin
                  SELECT S.FHABIl
                    into lc_EsHabil
                    FROM FST001 F, FST028 S
                   WHERE F.CALCOD = S.CALCOD
                     AND F.SUCURS = ln_suc
                     AND S.FFECHA = ld_DiaAnterior;
                end;
              
                if lc_EsHabil = 'S' then
                  lc_prdgracia := 'N';
                else
                  if lc_EsHabil = 'N' then
                    lc_prdgracia := 'S';
                  end if;
                end if;
              
              else
                if ln_gracia = 182 or ln_gracia = 365 then
                  pq_cR_ctrl_reprofondos.sp_cR_VerifFeriado(ln_sucursal  => ln_suc,
                                                            ld_fecha     => ld_MinFchRep,
                                                            lc_EsFeriado => lc_EsFeriado);
                
                  if lc_EsFeriado = 'S' then
                    lc_prdgracia := 'S';
                  else
                    if lc_esferiado = 'N' then
                      lc_prdgracia := 'N';
                    end if;
                  end if;
                
                end if;
              end if;
            end if;
          else
            lc_prdgracia := 'N';
          end if;
        end if;
      
      else
        if lc_TipoProg = 'FAE 1' or lc_TipoProg = 'FAE 2' then
        
          begin
            Select tp1imp1
              into ln_maxgracia
              from fst198
             where tp1cod1 = 10899
               and tp1corr1 = 400000
               and tp1corr2 = 6
               and tp1corr3 > 0
               and tp1desc = rpad(lc_TipoProg, 30, ' ');
          exception
            when others then
              ln_maxgracia := 0;
          end;
          ln_maxgracia := nvl(ln_maxgracia, 0);
        
          if ln_gracia > ln_maxgracia then
            lc_prdgracia := 'N';
          else
            lc_prdgracia := 'S';
          end if;
        end if;
      
      end if;
    end if;
  
  end sp_cr_periodgracia;
  ------------------------------------
  procedure sp_cR_VerifFeriado(ln_sucursal  in number,
                               ld_fecha     in date,
                               lc_EsFeriado out varchar2) is
  
    cursor lista_feriados(LD_NewFECHAini date, LD_NewFECHAfin date) is
      SELECT S.FHABIl Lc_EsHabil
        FROM FST001 F, FST028 S
       WHERE F.CALCOD = S.CALCOD
         AND F.SUCURS = ln_sucursal
         AND S.FFECHA between LD_NewFECHAini and LD_NewFECHAfin;
  
    -- Lc_EsHabil  varchar2(2) := 'N';
    x              number := 1;
    y              number := 2;
    LD_NewFECHAini date;
    LD_NewFECHAfin date;
  
  begin
  
    LD_NewFECHAini := LD_FECHA - y;
    LD_NewFECHAfin := LD_FECHA - x;
  
    for l in lista_feriados(LD_NewFECHAini, LD_NewFECHAfin) loop
    
      if l.lc_eshabil = 'N' then
        lc_EsFeriado := 'S';
      else
        if l.Lc_EsHabil = 'S' then
          lc_EsFeriado := 'N';
          exit;
        end if;
      end if;
      /* if x = 3 then
        exit;
      end if;*/
    end loop;
  
  end sp_cR_VerifFeriado;

end PQ_CR_CTRL_REPROFONDOS;
/

