create or replace package PQ_CR_LISTADORELAMPAGO is

  -- Author  : MPOSTIGOC
  -- Created : 28/09/2017 06:44:01 p.m.
  -- Purpose : 
  procedure sp_cr_inicio(lc_digito in varchar2);
  procedure sp_cr_DeudaPyme(ln_Petdoc          in number,
                            ln_Pendoc          in varchar2,
                            ld_FechaDesembolso in date,
                            ln_EndeudDesemb    out number,
                            ln_EndeudActual    out number);
  procedure sp_Tipo_Doc_SBS(ln_tdoc  in number,
                            lc_tndoc in varchar2,
                            C_TDOCID out varchar);
  Procedure sp_cr_cargaCuoIm_job;

end PQ_CR_LISTADORELAMPAGO;
/

create or replace package body PQ_CR_LISTADORELAMPAGO is

  procedure sp_cr_inicio(lc_digito in varchar2) is
  
    cursor listado is
    
      select *
        from jaqz803 j
       where to_char(substr(trim(jaqz803ndoc), -1, 1)) = lc_digito;
    -- where j.jaqz803inst = 1873838;
  
    --ln_instancia          number;
    ld_fchsist      date;
    ln_tipocamb     number;
    LN_CapCaja      number;
    ln_SaldExter    number;
    ln_ResNeto      number;
    ln_Ratio        number(17, 6);
    ln_instancia    number;
    ld_MaxFchDesemb date;
    ln_pgcod        number;
    ln_modulo       number;
    ln_sucursal     number;
    ln_moneda       number;
    ln_papel        number;
    ln_cuenta       number;
    ln_operacion    number;
    ln_suboper      number;
    ln_tipooper     number;
    Divisor         number;
    saldo_extDol    number;
    saldo_extSoles  number;
  
  begin
    for l in listado loop
    
      begin
        -- Fecha de Sistema
        select pgfape into ld_fchsist from fst017 where pgcod = 1;
      end;
    
      begin
      
        begin
          select max(g.aofval)
            into ld_MaxFchDesemb
            from fsd010 g
           where g.pgcod = 1
             and g.aomod in
                 (select modulo
                    from fst111
                   where dscod = 50
                     and modulo not in (33, 200, 108))
             and g.aocta in (select f.ctnro
                               from fsr008 f
                              where f.pepais = l.jaqz803pais
                                and f.petdoc = l.jaqz803petdoc
                                and f.pendoc = l.jaqz803ndoc
                                and f.cttfir = 'T');
        exception
          when others then
            null;
        end;
      
        begin
          select g.pgcod,
                 g.aomod,
                 g.aosuc,
                 g.aomda,
                 g.aopap,
                 g.aocta,
                 g.aooper,
                 g.aosbop,
                 g.aotope
            into ln_pgcod,
                 ln_modulo,
                 ln_sucursal,
                 ln_moneda,
                 ln_papel,
                 ln_cuenta,
                 ln_operacion,
                 ln_suboper,
                 ln_tipooper
          
            from fsd010 g
           where g.pgcod = 1
             and g.aomod in
                 (select modulo
                    from fst111
                   where dscod = 50
                     and modulo not in (33, 200, 108))
             and g.aocta in (select f.ctnro
                               from fsr008 f
                              where f.pepais = l.jaqz803pais
                                and f.petdoc = l.jaqz803petdoc
                                and f.pendoc = l.jaqz803ndoc
                                and f.cttfir = 'T')
             and g.aofval = ld_MaxFchDesemb
             and rownum = 1;
        end;
      
        begin
          ln_instancia := fn_instancia_credito(v_Scmod  => ln_modulo,
                                               v_Scsuc  => ln_sucursal,
                                               v_Scmda  => ln_moneda,
                                               v_Scpap  => ln_papel,
                                               v_Sccta  => ln_cuenta,
                                               v_Scoper => ln_operacion,
                                               v_Scsbop => ln_suboper,
                                               v_Sctope => ln_tipooper);
        end;
      
      end;
    
      begin
        -- Tipo de Cambio
        select s.sng120tcbi
          into ln_tipocamb
          from sng120 s
         where s.sng120ins = ln_instancia
           and s.SNG120Tsk = 'EVALUACION';
      exception
        when others then
          ln_tipocamb := 0;
      end;
    
      begin
        -- Calculo Ratio
        pq_cr_resolutor_cappago.sp_cuentas(ln_Pepais     => l.jaqz803pais,
                                           ln_Petdoc     => l.jaqz803petdoc,
                                           ln_Pendoc     => l.jaqz803ndoc,
                                           tipocambio    => ln_tipocamb,
                                           Instancia     => ln_instancia,
                                           pd_fecpro     => ld_fchsist,
                                           lc_prgm       => 'CAMPANIA',
                                           ln_captotcaja => LN_CapCaja,
                                           saldo_externo => ln_SaldExter,
                                           ResultNeto    => ln_ResNeto,
                                           ln_captotal   => ln_Ratio);
      
        begin
          -- DEUDA EXTERNA
        
          begin
            select sum(j.jaqy327gfin)
              into saldo_extSoles
              from jaqy327 j
             where j.jaqy327inst = ln_instancia
               and j.jaqy327esta = 'S'
               and j.jaqy327chek = '1'
               and j.jaqy327tcre in
                   ('Pymes S/.', 'Consumo S/.', 'Hipotecario S/.');
          exception
            when others then
              saldo_extSoles := 0;
            
          end;
        
          begin
            begin
              select sum(j.jaqy327gfin)
                into saldo_extDol
                from jaqy327 j
               where j.jaqy327inst = ln_instancia
                 and j.jaqy327esta = 'S'
                 and j.jaqy327chek = '1'
                 and j.jaqy327tcre in
                     ('Pymes US$', 'Consumo US$', 'Hipotecario US$');
            exception
              when others then
                saldo_extDol := 0;
            end;
          
            saldo_extDol := nvl(saldo_extDol, 0) * ln_tipocamb;
          
          end;
        
          ln_SaldExter := nvl(saldo_extDol, 0) + nvl(saldo_extSoles, 0);
        end;
      
        begin
        
          Divisor := nvl(ln_ResNeto, 0) + nvl(ln_SaldExter, 0);
        end;
        if Divisor <> 0 then
          --ln_captotal1 := round((nvl(ln_cajaext, 0) / Divisor), 6); --mpostigoc 210218
          ln_Ratio := round(((LN_CapCaja + ln_SaldExter) /
                            (ln_SaldExter + ln_ResNeto)),
                            6);
        else
          ln_Ratio := 0;
        end if;
      
        ln_Ratio := nvl(ln_Ratio, 0);
      
      end;
    
      begin
        update jaqz803 j
           set j.jaqz803fchprc  = ld_fchsist,
               J.JAQZ803INST    = ln_instancia,
               j.jaqz803resneto = ln_ResNeto,
               j.jaqz803ratio   = ln_Ratio,
               J.jaqz803CAPCAJA = LN_CapCaja,
               J.jaqz803SLDEXT  = ln_SaldExter
         where j.jaqz803pais = l.jaqz803pais
           and j.jaqz803petdoc = l.jaqz803petdoc
           and j.jaqz803ndoc = l.jaqz803ndoc;
        commit;
      end;
    
    end loop;
  
  end sp_cr_inicio;
  -----------------------------------------------------------------------------
  -- Deuda Pyme del Mes de Desembolso

  procedure sp_cr_DeudaPyme(ln_Petdoc          in number,
                            ln_Pendoc          in varchar2,
                            ld_FechaDesembolso in date,
                            ln_EndeudDesemb    out number,
                            ln_EndeudActual    out number) is
  
    ln_FchRCC          number;
    D_FECPRE           varchar2(10);
    D_FECPRE1          date;
    ln_dia             number;
    ln_Mes             number;
    ln_Anio            number;
    ld_MesVeriFchDesem date;
    lc_codsbs          varchar2(10);
    ln_capital1        number;
    ln_capital2        number;
    lc_C_TDOCID        varchar2(2);
  
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
  
    pq_cr_listado_campnvdd17.sp_Tipo_Doc_SBS(ln_Petdoc,
                                             ln_Pendoc,
                                             lc_C_TDOCID);
  
    begin
      select C_CODSBS -- para sacar el CodSBS
        into lc_codsbs
        from cldrcci
       where /*D_FECPRE = D_FECPRE1
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             and*/
       c_docide = ln_Pendoc
       and C_TDOCID = lc_C_TDOCID
       and rownum = 1;
    exception
      when others then
        null;
    end;
  
    ld_MesVeriFchDesem := last_day(ld_FechaDesembolso);
  
    begin
      --Calcula la Deuda RCC en el mes del Desembolso
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
         where D_FECPRE = ld_MesVeriFchDesem
           and c_codsbs = lc_codsbs
           and C_CRETIP in (select trim(tp1desc)
                              from FST198
                             Where Tp1cod = 1
                               and Tp1cod1 = 10871
                               and Tp1corr1 = 7
                               and tp1corr2 = 14); --  Micro y Pequeña Empresa
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
         where D_FECPRE = ld_MesVeriFchDesem
           and c_codsbs = lc_codsbs
           and C_TIPREG = 2
           and C_TIPDET = 'Z';
      end;
    
      ln_EndeudDesemb := ln_capital1 - ln_capital2;
    end; -- Fin Calcula la Deuda RCC en el mes del Desembolso
  
    begin
      -- Calcula la Deuda RCC Actual
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
         where D_FECPRE = D_FECPRE1
           and c_codsbs = lc_codsbs
           and C_CRETIP in (select trim(tp1desc)
                              from FST198
                             Where Tp1cod = 1
                               and Tp1cod1 = 10871
                               and Tp1corr1 = 7
                               and tp1corr2 = 14); --  Micro y Pequeña Empresa
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
    
      ln_EndeudActual := ln_capital1 - ln_capital2;
    end; -- Fin Calcula la Deuda RCC Actual
  
  end sp_cr_DeudaPyme;
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

  --------------------------------------------------------
  Procedure sp_cr_cargaCuoIm_job is
  
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
    
      lc_variable := ' begin ' || 'PQ_CR_LISTADORELAMPAGO.sp_cr_inicio(''' || x ||
                     ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
     -- if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
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

end PQ_CR_LISTADORELAMPAGO;
/

