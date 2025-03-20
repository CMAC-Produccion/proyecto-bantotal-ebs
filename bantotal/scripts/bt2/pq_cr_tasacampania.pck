create or replace package PQ_CR_TASACAMPANIA is

  -- Author  : MPOSTIGOC
  -- Created : 6/12/2018 7:17:04 p. m.
  -- Purpose : 

  procedure sp_cr_inicio(lc_digito       in varchar2,
                         ld_FchCargaData in date,
                         vFechahasta     in date);
  ------------------------------------
  procedure sp_cr_updatetasas(ld_FchCargaData in date);
  ----------------------------------
  Procedure sp_cr_cargaCuoIm_job(pd_fechaIni in date, pd_fechaFin in date);
  ----------------------------------------------
  procedure sp_cr_PizarJAQM80(lc_digito       in varchar2,
                              ld_FchCargaData in date,
                              vFechahasta     in date);
  --------------------------------------------------------------------------------------------
  Procedure sp_cr_cargajaqm80_job(pd_fechaIni in date, pd_fechaFin in date);
  ------------------------------------------------------------
  procedure sp_cr_PizarJAQM80OF(lc_digito       in varchar2,
                                ld_FchCargaData in date,
                                vFechahasta     in date);
  ------------------------------------------------------------------------
  Procedure sp_cr_cargajaqm80of_job(pd_fechaIni in date,
                                    pd_fechaFin in date);
  ---------------------------------------------------------------
  procedure sp_cr_PizarJAQM80B(lc_digito       in varchar2,
                               ld_FchCargaData in date,
                               vFechahasta     in date);
  ------------------------------------------------------------------------
  Procedure sp_cr_cargajaqm80B_job(pd_fechaIni in date,
                                   pd_fechaFin in date);

end PQ_CR_TASACAMPANIA;
/

create or replace package body PQ_CR_TASACAMPANIA is

  procedure sp_cr_inicio(lc_digito       in varchar2,
                         ld_FchCargaData in date,
                         vFechahasta     in date) is
  
    cursor listado(ld_FchCargaData date) is
      select j.jaqm80mo Modulo,
             j.jaqm80ct Cuenta,
             j.jaqm80tp TipoOperacion,
             j.jaqm80mn Moneda,
             j.jaqm80pp Papel,
             j.jaqm80im Monto,
             j.jaqm80ta Tasa
        from jaqm80 j
       where j.jaqm80fc = ld_FchCargaData
         and j.jaqm80ta > 0
         and j.jaqm80es = 'A'
         and to_char(substr(trim(j.jaqm80ct), -1, 1)) = lc_digito;
  
    -- dias_vigencia number;
    --  vFechadesde date;
    --  vFechahasta date;
    --vFechadesde1  number;
    vTpfinv      number;
    ln_Pp028DefN number;
    ln_Pp028Mod  number;
    ln_Pp028Top  number;
    ln_Pp028Mda  number;
    ln_Pp028Pap  number;
    ln_Pp028Emp  number;
    ln_dia       varchar2(2);
    ln_mes       varchar2(2);
    ln_anio      varchar2(4);
    ld_FchInv    number;
  
  begin
  
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select to_char(ld_FchCargaData, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_FchCargaData, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_FchCargaData, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    for l in listado(ld_FchCargaData) loop
    
      begin
        select Pp028DefN, Pp028Mod, Pp028Top, Pp028Mda, Pp028Pap, Pp028Emp
          into ln_Pp028DefN,
               ln_Pp028Mod,
               ln_Pp028Top,
               ln_Pp028Mda,
               ln_Pp028Pap,
               ln_Pp028Emp
          from FPP028
         Where Pp028Emp = 1
           and Pp028Mod = l.modulo
           and Pp028Top = l.tipooperacion
           and Pp028Mda = l.moneda
           and Pp028Pap = l.papel
           and Pp017Par = 17;
      exception
        when others then
          null;
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
           l.modulo,
           ln_Pp028DefN,
           l.cuenta,
           l.moneda,
           l.papel,
           ld_FchCargaData,
           l.monto,
           1,
           vTpfinv,
           'S');
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
           l.modulo,
           ln_Pp028DefN,
           l.cuenta,
           l.moneda,
           l.papel,
           ld_FchCargaData,
           l.monto,
           99999,
           l.tasa);
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
           l.modulo,
           ln_Pp028DefN,
           l.cuenta,
           l.moneda,
           l.papel,
           ld_FchCargaData,
           vFechahasta);
      end;
      commit;
    end loop;
  
  end sp_cr_inicio;
  -------------------------------------
  procedure sp_cr_updatetasas(ld_FchCargaData in date) is
  
    cursor Lista_ActVign is
      select distinct j.jaqm80ct ln_cuenta,
                      j.jaqm80mo ln_modulo,
                      j.jaqm80tp ln_tipooper,
                      j.jaqm80mn ln_moneda,
                      j.jaqm80pp ln_papel
        from jaqm80 j
       where j.jaqm80ta > 0
         and j.jaqm80fc = ld_FchCargaData;
  
    ln_pizarra number;
    ld_MaxFech date;
  
  begin
  
    for l in Lista_ActVign loop
    
      begin
        select f.pp028defn
          into ln_pizarra
          from fpp028 f
         where f.pp017par = 17
           and f.pp028emp = 1
           and f.pp028mod = l.ln_modulo
           and f.pp028top = l.ln_tipooper
           and f.pp028mda = l.ln_moneda
           and f.pp028pap = l.ln_papel;
      exception
        when others then
          null;
      end;
    
      begin
        select max(g.tpfdes)
          into ld_MaxFech
          from fsd027 g
         where g.pgcod = 1
           and g.modulo = l.ln_modulo
           and g.tpizar = ln_pizarra
           and g.ctnro = l.ln_cuenta
           and g.moneda = l.ln_moneda
           and g.papel = l.ln_papel;
      exception
        when others then
          null;
      end;
    
      if ln_pizarra is not null and ld_MaxFech is not null then
      
        begin
          update fsd027 g
             set g.tpvig = 'N'
           where g.pgcod = 1
             and g.modulo = l.ln_modulo
             and g.tpizar = ln_pizarra
             and g.ctnro = l.ln_cuenta
             and g.moneda = l.ln_moneda
             and g.papel = l.ln_papel
             and g.tpfdes < ld_MaxFech;
        end;
      
        begin
          update fsd027 g
             set g.tpvig = 'S'
           where g.pgcod = 1
             and g.modulo = l.ln_modulo
             and g.tpizar = ln_pizarra
             and g.ctnro = l.ln_cuenta
             and g.moneda = l.ln_moneda
             and g.papel = l.ln_papel
             and g.tpfdes = ld_MaxFech;
        end;
      
      end if;
      commit;
    end loop;
  end sp_cr_updatetasas;
  ------------------------------------------------
  Procedure sp_cr_cargaCuoIm_job(pd_fechaIni in date, pd_fechaFin in date) is
  
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
    
      lc_variable := ' begin ' || 'PQ_CR_TASACAMPANIA.sp_cr_inicio(''' || x ||
                     ''',' || '''' || pd_fechaIni || '''' || ',' || '''' ||
                     pd_fechaFin || ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
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
  ------------------------------------------------------------------
  -- Carga de PIzarras para JAQM80
  procedure sp_cr_PizarJAQM80(lc_digito       in varchar2,
                              ld_FchCargaData in date,
                              vFechahasta     in date) is
  
    cursor listado_027 is
    
      select DISTINCT j.jaqm80mo Modulo,
                      j.jaqm80ct Cuenta,
                      j.jaqm80tp TipoOperacion,
                      j.jaqm80mn Moneda,
                      j.jaqm80pp Papel,
                      j.jaqm80im Monto
        from jaqm80 j
       where j.jaqm80fc = ld_FchCargaData
         and j.jaqm80ta > 0
         and j.jaqm80es = 'Z'
         and to_char(substr(trim(j.jaqm80ct), -1, 1)) = lc_digito;
  
    cursor listado_327 is
      select DISTINCT j.jaqm80mo Modulo,
                      j.jaqm80ct Cuenta,
                      j.jaqm80tp TipoOperacion,
                      j.jaqm80mn Moneda,
                      j.jaqm80pp Papel
        from jaqm80 j
       where j.jaqm80fc = ld_FchCargaData
         and j.jaqm80ta > 0
         and j.jaqm80es = 'Z'
         and to_char(substr(trim(j.jaqm80ct), -1, 1)) = lc_digito;
  
    cursor listado_r027 is
      select DISTINCT j.jaqm80mo Modulo,
                      j.jaqm80ct Cuenta,
                      j.jaqm80tp TipoOperacion,
                      j.jaqm80mn Moneda,
                      j.jaqm80pp Papel,
                      j.jaqm80im Monto,
                      J.JAQM80TA tasa
        from jaqm80 j
       where j.jaqm80fc = ld_FchCargaData
         and j.jaqm80ta > 0
         and j.jaqm80es = 'Z'
         and to_char(substr(trim(j.jaqm80ct), -1, 1)) = lc_digito;
  
    vTpfinv      number;
    ln_Pp028DefN number;
    ln_Pp028Mod  number;
    ln_Pp028Top  number;
    ln_Pp028Mda  number;
    ln_Pp028Pap  number;
    ln_Pp028Emp  number;
    ln_dia       varchar2(2);
    ln_mes       varchar2(2);
    ln_anio      varchar2(4);
    ld_FchInv    number;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
  
    begin
    
      begin
        select to_char(ld_FchCargaData, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_FchCargaData, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_FchCargaData, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_FchCargaData is not null then
    
      for l in listado_027 loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = l.modulo
             and Pp028Top = l.tipooperacion
             and Pp028Mda = l.moneda
             and Pp028Pap = l.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg027
              from fsd027 f
             where f.pgcod = 1
               and f.modulo = l.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = l.cuenta
               and f.moneda = l.moneda
               and f.papel = l.papel
               and f.tpfdes = ld_FchCargaData
               and f.tpmto = l.monto;
          exception
            when others then
              ln_nroreg027 := 0;
          end;
        
          if ln_nroreg027 = 0 then
          
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
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_FchCargaData,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          else
            begin
              insert into aqpa373
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
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_FchCargaData,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
          end if;
        end if;
      end loop;
    
      for j in listado_327 loop
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = j.modulo
             and Pp028Top = j.tipooperacion
             and Pp028Mda = j.moneda
             and Pp028Pap = j.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
          begin
            select count(*)
              into ln_nroreg327
              from fsd327 f
             where f.vt1pgcod = 1
               and f.vt1mod = j.modulo
               and f.vt1tpiz = ln_Pp028DefN
               and f.vt1ctnr = j.cuenta
               and f.vt1mon = j.moneda
               and f.vt1pap = j.papel
               and f.vt1tpfd = ld_FchCargaData;
          exception
            when others then
              ln_nroreg327 := 0;
          end;
        
          if ln_nroreg327 = 0 then
          
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
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_FchCargaData,
                 vFechahasta);
            end;
            commit;
          else
            begin
              insert into aqpa374
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
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_FchCargaData,
                 vFechahasta);
            end;
            commit;
          end if;
        end if;
      end loop;
    
      for t in listado_r027 loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = t.modulo
             and Pp028Top = t.tipooperacion
             and Pp028Mda = t.moneda
             and Pp028Pap = t.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroregr27
              from fsr027 f
             where f.pgcod = 1
               and f.modulo = t.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = t.cuenta
               and f.moneda = t.moneda
               and f.papel = t.papel
               and f.tpfdes = ld_FchCargaData
               and f.tpmto = t.monto
               and f.tppzo = 99999;
          exception
            when others then
              ln_nroregr27 := 0;
          end;
        
          if ln_nroregr27 = 0 then
          
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
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_FchCargaData,
                 t.monto,
                 99999,
                 t.tasa);
            end;
            commit;
          else
            begin
              insert into aqpa375
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
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_FchCargaData,
                 t.monto,
                 99999,
                 t.tasa);
            end;
            commit;
          end if;
        end if;
      end loop;
    
    end if;
  end sp_cr_PizarJAQM80;
  ------------------------------------------------
  Procedure sp_cr_cargajaqm80_job(pd_fechaIni in date, pd_fechaFin in date) is
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' || 'PQ_CR_TASACAMPANIA.sp_cr_PizarJAQM80(''' || x ||
                     ''',' || '''' || pd_fechaIni || '''' || ',' || '''' ||
                     pd_fechaFin || ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
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
  
  end sp_cr_cargajaqm80_job;

  --------------------------------------------------------------
  -- Carga de PIzarras para JAQM80
  procedure sp_cr_PizarJAQM80OF(lc_digito       in varchar2,
                                ld_FchCargaData in date,
                                vFechahasta     in date) is
  
    cursor listado_027 is
    
      select DISTINCT j.jaqm80mo Modulo,
                      j.jaqm80ct Cuenta,
                      j.jaqm80tp TipoOperacion,
                      j.jaqm80mn Moneda,
                      j.jaqm80pp Papel,
                      j.jaqm80im Monto
        from jaqm80 j
       where j.jaqm80fc = ld_FchCargaData
         and j.jaqm80ta > 0
         and j.jaqm80es = 'A'
         and to_char(substr(trim(j.jaqm80ct), -1, 1)) = lc_digito;
  
    cursor listado_327 is
      select DISTINCT j.jaqm80mo Modulo,
                      j.jaqm80ct Cuenta,
                      j.jaqm80tp TipoOperacion,
                      j.jaqm80mn Moneda,
                      j.jaqm80pp Papel
        from jaqm80 j
       where j.jaqm80fc = ld_FchCargaData
         and j.jaqm80ta > 0
         and j.jaqm80es = 'A'
         and to_char(substr(trim(j.jaqm80ct), -1, 1)) = lc_digito;
  
    cursor listado_r027 is
      select DISTINCT j.jaqm80mo Modulo,
                      j.jaqm80ct Cuenta,
                      j.jaqm80tp TipoOperacion,
                      j.jaqm80mn Moneda,
                      j.jaqm80pp Papel,
                      j.jaqm80im Monto,
                      J.JAQM80TA tasa
        from jaqm80 j
       where j.jaqm80fc = ld_FchCargaData
         and j.jaqm80ta > 0
         and j.jaqm80es = 'A'
         and to_char(substr(trim(j.jaqm80ct), -1, 1)) = lc_digito;
  
    vTpfinv      number;
    ln_Pp028DefN number;
    ln_Pp028Mod  number;
    ln_Pp028Top  number;
    ln_Pp028Mda  number;
    ln_Pp028Pap  number;
    ln_Pp028Emp  number;
    ln_dia       varchar2(2);
    ln_mes       varchar2(2);
    ln_anio      varchar2(4);
    ld_FchInv    number;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
  
    begin
    
      begin
        select to_char(ld_FchCargaData, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_FchCargaData, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_FchCargaData, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_FchCargaData is not null then
    
      for l in listado_027 loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = l.modulo
             and Pp028Top = l.tipooperacion
             and Pp028Mda = l.moneda
             and Pp028Pap = l.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg027
              from fsd027 f
             where f.pgcod = 1
               and f.modulo = l.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = l.cuenta
               and f.moneda = l.moneda
               and f.papel = l.papel
               and f.tpfdes = ld_FchCargaData
               and f.tpmto = l.monto;
          exception
            when others then
              ln_nroreg027 := 0;
          end;
        
          if ln_nroreg027 = 0 then
          
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
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_FchCargaData,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          else
            begin
              insert into aqpa373
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
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_FchCargaData,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
          end if;
        end if;
      end loop;
    
      for j in listado_327 loop
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = j.modulo
             and Pp028Top = j.tipooperacion
             and Pp028Mda = j.moneda
             and Pp028Pap = j.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
          begin
            select count(*)
              into ln_nroreg327
              from fsd327 f
             where f.vt1pgcod = 1
               and f.vt1mod = j.modulo
               and f.vt1tpiz = ln_Pp028DefN
               and f.vt1ctnr = j.cuenta
               and f.vt1mon = j.moneda
               and f.vt1pap = j.papel
               and f.vt1tpfd = ld_FchCargaData;
          exception
            when others then
              ln_nroreg327 := 0;
          end;
        
          if ln_nroreg327 = 0 then
          
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
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_FchCargaData,
                 vFechahasta);
            end;
            commit;
          else
            begin
              insert into aqpa374
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
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_FchCargaData,
                 vFechahasta);
            end;
            commit;
          end if;
        end if;
      end loop;
    
      for t in listado_r027 loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = t.modulo
             and Pp028Top = t.tipooperacion
             and Pp028Mda = t.moneda
             and Pp028Pap = t.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroregr27
              from fsr027 f
             where f.pgcod = 1
               and f.modulo = t.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = t.cuenta
               and f.moneda = t.moneda
               and f.papel = t.papel
               and f.tpfdes = ld_FchCargaData
               and f.tpmto = t.monto
               and f.tppzo = 99999;
          exception
            when others then
              ln_nroregr27 := 0;
          end;
        
          if ln_nroregr27 = 0 then
          
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
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_FchCargaData,
                 t.monto,
                 99999,
                 t.tasa);
            end;
            commit;
          else
            begin
              insert into aqpa375
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
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_FchCargaData,
                 t.monto,
                 99999,
                 t.tasa);
            end;
            commit;
          end if;
        end if;
      end loop;
    
    end if;
  end sp_cr_PizarJAQM80of;
  ------------------------------------------------
  Procedure sp_cr_cargajaqm80of_job(pd_fechaIni in date,
                                    pd_fechaFin in date) is
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     'PQ_CR_TASACAMPANIA.sp_cr_PizarJAQM80of(''' || x ||
                     ''',' || '''' || pd_fechaIni || '''' || ',' || '''' ||
                     pd_fechaFin || ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
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
  
  end sp_cr_cargajaqm80of_job;
  --------------------------------------------------------------
  -- Carga de PIzarras para JAQM80
  procedure sp_cr_PizarJAQM80B(lc_digito       in varchar2,
                               ld_FchCargaData in date,
                               vFechahasta     in date) is
  
    cursor listado_027 is
    
      select DISTINCT j.jaqm80mo Modulo,
                      j.jaqm80ct Cuenta,
                      j.jaqm80tp TipoOperacion,
                      j.jaqm80mn Moneda,
                      j.jaqm80pp Papel,
                      j.jaqm80im Monto
        from jaqm80 j
       where j.jaqm80fc = ld_FchCargaData
         and j.jaqm80ta > 0
         and j.jaqm80es = 'B'
         and to_char(substr(trim(j.jaqm80ct), -1, 1)) = lc_digito;
  
    cursor listado_327 is
      select DISTINCT j.jaqm80mo Modulo,
                      j.jaqm80ct Cuenta,
                      j.jaqm80tp TipoOperacion,
                      j.jaqm80mn Moneda,
                      j.jaqm80pp Papel
        from jaqm80 j
       where j.jaqm80fc = ld_FchCargaData
         and j.jaqm80ta > 0
         and j.jaqm80es = 'B'
         and to_char(substr(trim(j.jaqm80ct), -1, 1)) = lc_digito;
  
    cursor listado_r027 is
      select DISTINCT j.jaqm80mo Modulo,
                      j.jaqm80ct Cuenta,
                      j.jaqm80tp TipoOperacion,
                      j.jaqm80mn Moneda,
                      j.jaqm80pp Papel,
                      j.jaqm80im Monto,
                      J.JAQM80TA tasa
        from jaqm80 j
       where j.jaqm80fc = ld_FchCargaData
         and j.jaqm80ta > 0
         and j.jaqm80es = 'B'
         and to_char(substr(trim(j.jaqm80ct), -1, 1)) = lc_digito;
  
    vTpfinv      number;
    ln_Pp028DefN number;
    ln_Pp028Mod  number;
    ln_Pp028Top  number;
    ln_Pp028Mda  number;
    ln_Pp028Pap  number;
    ln_Pp028Emp  number;
    ln_dia       varchar2(2);
    ln_mes       varchar2(2);
    ln_anio      varchar2(4);
    ld_FchInv    number;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
  
    begin
    
      begin
        select to_char(ld_FchCargaData, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_FchCargaData, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_FchCargaData, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_FchCargaData is not null then
    
      for l in listado_027 loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = l.modulo
             and Pp028Top = l.tipooperacion
             and Pp028Mda = l.moneda
             and Pp028Pap = l.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg027
              from fsd027 f
             where f.pgcod = 1
               and f.modulo = l.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = l.cuenta
               and f.moneda = l.moneda
               and f.papel = l.papel
               and f.tpfdes = ld_FchCargaData
               and f.tpmto = l.monto;
          exception
            when others then
              ln_nroreg027 := 0;
          end;
        
          if ln_nroreg027 = 0 then
          
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
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_FchCargaData,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          else
            begin
              insert into aqpa373
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
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_FchCargaData,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
          end if;
        end if;
      end loop;
    
      for j in listado_327 loop
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = j.modulo
             and Pp028Top = j.tipooperacion
             and Pp028Mda = j.moneda
             and Pp028Pap = j.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
          begin
            select count(*)
              into ln_nroreg327
              from fsd327 f
             where f.vt1pgcod = 1
               and f.vt1mod = j.modulo
               and f.vt1tpiz = ln_Pp028DefN
               and f.vt1ctnr = j.cuenta
               and f.vt1mon = j.moneda
               and f.vt1pap = j.papel
               and f.vt1tpfd = ld_FchCargaData;
          exception
            when others then
              ln_nroreg327 := 0;
          end;
        
          if ln_nroreg327 = 0 then
          
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
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_FchCargaData,
                 vFechahasta);
            end;
            commit;
          else
            begin
              insert into aqpa374
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
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_FchCargaData,
                 vFechahasta);
            end;
            commit;
          end if;
        end if;
      end loop;
    
      for t in listado_r027 loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = t.modulo
             and Pp028Top = t.tipooperacion
             and Pp028Mda = t.moneda
             and Pp028Pap = t.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroregr27
              from fsr027 f
             where f.pgcod = 1
               and f.modulo = t.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = t.cuenta
               and f.moneda = t.moneda
               and f.papel = t.papel
               and f.tpfdes = ld_FchCargaData
               and f.tpmto = t.monto
               and f.tppzo = 99999;
          exception
            when others then
              ln_nroregr27 := 0;
          end;
        
          if ln_nroregr27 = 0 then
          
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
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_FchCargaData,
                 t.monto,
                 99999,
                 t.tasa);
            end;
            commit;
          else
            begin
              insert into aqpa375
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
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_FchCargaData,
                 t.monto,
                 99999,
                 t.tasa);
            end;
            commit;
          end if;
        end if;
      end loop;
    
    end if;
  end sp_cr_PizarJAQM80B;
  ------------------------------------------------
  Procedure sp_cr_cargajaqm80B_job(pd_fechaIni in date,
                                   pd_fechaFin in date) is
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     'PQ_CR_TASACAMPANIA.sp_cr_PizarJAQM80B(''' || x ||
                     ''',' || '''' || pd_fechaIni || '''' || ',' || '''' ||
                     pd_fechaFin || ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
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
  
  end sp_cr_cargajaqm80B_job;

------------------------------------------------------------------  
end PQ_CR_TASACAMPANIA;
/

