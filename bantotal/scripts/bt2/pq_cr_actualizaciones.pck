create or replace package PQ_CR_ACTUALIZACIONES is
  -- *****************************************************************
  -- Nombre                     : Paquete para diversos procesos
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 15/10/2024 09:30:06
  -- Autor de Creación          : MARIA POSTIGO
  -- Uso                        : Paquete para diversos procesos: Amortizacion en Impulso Peru, Tasas para reconversion de Lineas
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 29/11/2024
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación:   Se agrego el procedimiento SP_cR_TASAACTUAL
  -- Fecha de Modificación      : 03/12/2024
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se agrego una validacion de vigencia de tasa para el procedimiento sp_Cr_TasaReconvLinea
  -- *****************************************************************

  procedure sp_cr_UpdImpAmortz(ln_Ndoc in varchar2);
  ---------------------------------------------------
  procedure sp_Cr_TasaReconvLinea;
  ---------------------------------------------------
  procedure sp_cr_TasaActual(ln_pgcod   in number,
                             ln_mod     in number,
                             ln_suc     in number,
                             ln_mda     in number,
                             ln_pap     in number,
                             ln_cta     in number,
                             ln_oper    in number,
                             ln_subop   in number,
                             ln_tope    in number,
                             ln_TasaAct out number);

end PQ_CR_ACTUALIZACIONES;
/

create or replace package body PQ_CR_ACTUALIZACIONES is

  procedure sp_cr_UpdImpAmortz(ln_Ndoc in varchar2) is
    -- Procedimiento que actualiza la marca para clientes con amortizacion
  begin
  
    begin
      update aqpc363 a
         set a.aqpc363mf2020 = 9999
       where a.aqpc363ndoc = rpad(ln_Ndoc, 12, ' ')
         and a.aqpc363est = 'S';
      commit;
    end;
  
  end sp_cr_UpdImpAmortz;
  --------------------------------------------------------------
  procedure sp_Cr_TasaReconvLinea is
  
    cursor lineas(ld_MaxFchAux date) is
      select distinct a.aqpb297cta cuenta
        from aqpb297 a
       where a.aqpb297est = 'S'
         and a.aqpb297fec >= ld_MaxFchAux;
  
    ln_tasa        number(14, 6) := 0.0000;
    pizarra        number := 0;
    ln_cont        number;
    ld_MaxFch      date;
    ln_saldo       number(17, 2) := 0.00;
    ln_modulo      number;
    FchInver       number;
    ln_dia         varchar2(2);
    ln_mes         varchar2(2);
    ln_anio        varchar2(4);
    ld_MaxFchAux   date;
    ld_FechaVenc   date;
    FchInverAux    number;
    ln_diaAtraso   number := 0;
    ln_Tope        number;
    ln_DiasVigTas  number;
    ld_fchvig      date;
    ln_TasaInserta number(10, 6) := 0.000000;
  
  begin
  
    begin
      select f.tp1nro2, f.tp1nro3
        into ln_modulo, ln_Tope
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 142
         and f.tp1corr2 = 1
         and f.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pp028defn
        into pizarra
        from fpp028 f
       where f.pp017par = 17
         and f.pp028emp = 1
         and f.pp028mod = ln_modulo
         and f.pp028top = ln_Tope
         and f.pp028mda = 0;
    exception
      when others then
        null;
    end;
  
    begin
      select max(a.aqpb297fec)
        into ld_MaxFchAux
        from aqpb297 a
       where a.aqpb297est = 'S';
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(ld_MaxFchAux, 'DD') into ln_dia from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(ld_MaxFchAux, 'MM') into ln_mes from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(ld_MaxFchAux, 'YYYY') into ln_anio from dual;
    exception
      when others then
        null;
    end;
  
    FchInverAux := to_number(ln_anio || ln_mes || ln_dia);
  
    FchInver := 99999999 - FchInverAux;
  
    for l in lineas(ld_MaxFchAux) loop
    
      begin
        select max(a.aqpd707dia)
          into ln_diaAtraso
          from aqpd707 a
         where a.aqpd707cta = l.cuenta;
      exception
        when others then
          null;
      end;
    
      ln_DiasVigTas := (30 - ln_diaAtraso) + 1;
    
      begin
        SELECT ld_MaxFchAux + ln_DiasVigTas into ld_FechaVenc FROM DUAL;
      exception
        when others then
          null;
      end;
    
      begin
        select max(a.aqpb297fec)
          into ld_MaxFch
          from aqpb297 a
         where a.aqpb297cta = l.cuenta
           and a.aqpb297est = 'S';
      exception
        when others then
          null;
      end;
    
      begin
        select max(a.aqpb297tasa), sum(a.aqpb297sdo)
          into ln_tasa, ln_saldo
          from aqpb297 a
         where a.aqpb297fec = ld_MaxFch
           and a.aqpb297cta = l.cuenta
           and a.aqpb297est = 'S';
      exception
        when others then
          null;
      end;
    
      ln_cont := 0;
      ---verificando si existe
      begin
        select count(*)
          into ln_cont
          from fsd027 f
         where f.pgcod = 1
           and f.modulo = ln_modulo
           and f.tpizar = pizarra
           and f.ctnro = l.cuenta
           and f.moneda = 0
           and f.TPVIG = 'S';
      exception
        when others then
          null;
      end;
    
      if ln_cont > 0 then
      
        begin
          select f.tpfdes
            into ld_fchvig
            from fsd027 f
           where f.pgcod = 1
             and f.modulo = ln_modulo
             and f.tpizar = pizarra
             and f.ctnro = l.cuenta
             and f.moneda = 0
             and f.TPVIG = 'S';
        exception
          when others then
            null;
        end;
      
        begin
          select f.tptasa
            into ln_TasaInserta
            from fsr027 f
           where f.pgcod = 1
             and f.modulo = ln_modulo
             and f.tpizar = pizarra
             and f.ctnro = l.cuenta
             and f.moneda = 0
             and f.papel = 0
             and f.tpfdes = ld_fchvig;
        exception
          when others then
            null;
        end;
      
        if ln_TasaInserta <> ln_tasa then
          begin
            update fsd027 f
               set f.tpvig = 'N'
             where f.pgcod = 1
               and f.modulo = modulo
               and f.tpizar = pizarra
               and f.ctnro = l.cuenta
               and f.moneda = 0
               and f.TPVIG = 'S';
            commit;
          end;
        
          begin
            insert into fsd027
              (pgcod,
               modulo,
               tpizar,
               ctnro,
               moneda,
               papel,
               tpfdes,
               tpmto,
               tpttas,
               tpfinv,
               tpvig)
            values
              (1,
               ln_modulo,
               pizarra,
               l.cuenta,
               0,
               0,
               ld_MaxFch,
               ln_saldo,
               1,
               FchInver,
               'S');
          exception
            when others then
              null;
          end;
        
          begin
            insert into fsd327
              (vt1pgcod,
               vt1mod,
               vt1tpiz,
               vt1ctnr,
               vt1mon,
               vt1pap,
               vt1tpfd,
               vt1fchven)
            values
              (1,
               ln_modulo,
               pizarra,
               l.cuenta,
               0,
               0,
               ld_MaxFch,
               --l.fecha,
               ld_FechaVenc);
          exception
            when others then
              null;
          end;
        
          begin
            insert into fsr027
              (pgcod,
               modulo,
               tpizar,
               ctnro,
               moneda,
               papel,
               tpfdes,
               tpmto,
               tppzo,
               tptasa)
            values
              (1,
               ln_modulo,
               pizarra,
               l.cuenta,
               0,
               0,
               ld_MaxFch,
               --l.fecha,
               ln_saldo,
               99999,
               ln_tasa);
          exception
            when others then
              null;
          end;
          commit;
        
        end if;
      
      else
        if ln_cont = 0 then
        
          begin
            insert into fsd027
              (pgcod,
               modulo,
               tpizar,
               ctnro,
               moneda,
               papel,
               tpfdes,
               tpmto,
               tpttas,
               tpfinv,
               tpvig)
            values
              (1,
               ln_modulo,
               pizarra,
               l.cuenta,
               0,
               0,
               ld_MaxFch,
               --l.fecha,
               ln_saldo,
               1,
               FchInver,
               'S');
          exception
            when others then
              null;
          end;
        
          begin
            insert into fsd327
              (vt1pgcod,
               vt1mod,
               vt1tpiz,
               vt1ctnr,
               vt1mon,
               vt1pap,
               vt1tpfd,
               vt1fchven)
            values
              (1,
               ln_modulo,
               pizarra,
               l.cuenta,
               0,
               0,
               ld_MaxFch,
               --l.fecha,
               ld_FechaVenc);
          exception
            when others then
              null;
          end;
        
          begin
            insert into fsr027
              (pgcod,
               modulo,
               tpizar,
               ctnro,
               moneda,
               papel,
               tpfdes,
               tpmto,
               tppzo,
               tptasa)
            values
              (1,
               ln_modulo,
               pizarra,
               l.cuenta,
               0,
               0,
               ld_MaxFch,
               --l.fecha,
               ln_saldo,
               99999,
               ln_tasa);
          exception
            when others then
              null;
          end;
          commit;
        end if;
      end if;
    end loop;
  end sp_Cr_TasaReconvLinea;
  --------------------------------------------
  procedure sp_cr_TasaActual(ln_pgcod   in number,
                             ln_mod     in number,
                             ln_suc     in number,
                             ln_mda     in number,
                             ln_pap     in number,
                             ln_cta     in number,
                             ln_oper    in number,
                             ln_subop   in number,
                             ln_tope    in number,
                             ln_TasaAct out number) is
  
    ln_Corr012 number;
  
  begin
  
    ln_TasaAct := 0;
  
    begin
      select max(g.evcorr)
        into ln_Corr012
        from fsd012 g
       where g.pgcod = ln_pgcod
         and g.aomod = ln_mod
         and g.aosuc = ln_suc
         and g.aomda = ln_mda
         and g.aopap = ln_pap
         and g.aocta = ln_cta
         and g.aooper = ln_oper
         and g.aosbop = ln_subop
         and g.aotope = ln_tope
         and g.evtipo = 3
         and g.d012co = 'S';
    exception
      when others then
        null;
    end;
  
    if ln_Corr012 > 0 then
    
      begin
        select f.evtasa
          into ln_TasaAct
          from fsd012 f
         where f.pgcod = ln_pgcod
           and f.aomod = ln_mod
           and f.aosuc = ln_suc
           and f.aomda = ln_mda
           and f.aopap = ln_pap
           and f.aocta = ln_cta
           and f.aooper = ln_oper
           and f.aosbop = ln_subop
           and f.aotope = ln_tope
           and f.evtipo = 3
           and f.d012co = 'S'
           and f.evcorr = ln_Corr012;
      exception
        when others then
          ln_TasaAct := 0;
      end;
    
    end if;
  
    if ln_TasaAct = 0 then
    
      begin
        select f.AOTASA
          into ln_TasaAct
          from fsd010 f
         where f.pgcod = ln_pgcod
           and f.aomod = ln_mod
           and f.aosuc = ln_suc
           and f.aomda = ln_mda
           and f.aopap = ln_pap
           and f.aocta = ln_cta
           and f.aooper = ln_oper
           and f.aosbop = ln_subop
           and f.aotope = ln_tope;
      exception
        when others then
          ln_TasaAct := 0;
      end;
    
    end if;
  
  end sp_cr_TasaActual;
  --------------------------------------------
end PQ_CR_ACTUALIZACIONES;
/

