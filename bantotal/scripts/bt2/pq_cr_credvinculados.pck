create or replace package PQ_CR_CREDVINCULADOS is

  -- Author  : MPOSTIGOC
  -- Created : 16/11/2020 6:47:58 p. m.
  -- Purpose : 

  procedure sp_cr_VerfAvalyCta(ln_instancia     in number,
                               lc_MismaCtayAval out varchar2);
  ----------------------------------------------------
  procedure sp_cr_VerMismaGarantia(ln_instancia     in number,
                                   lc_MismaGarantia out varchar2);
  --------------------------------------------------------
  procedure sp_cr_PizaNovacion(lc_digito in varchar2);
  ----------------------------------------------
  Procedure sp_cr_carga_job_Novacion;

end PQ_CR_CREDVINCULADOS;
/

create or replace package body PQ_CR_CREDVINCULADOS is

  procedure sp_cr_VerfAvalyCta(ln_instancia     in number,
                               lc_MismaCtayAval out varchar2) is
  
    cursor avales(ln_InstVncla number) is
      select s.sng003cta from sng003 s where s.sng001inst = ln_InstVncla;
  
    ln_CtaVuelo  number := 0;
    ln_CtaVncla  number := 0;
    ln_InstVncla number := 0;
    ln_avalproc  number := 0;
    ln_avalvncl  number := 0;
    ln_existe    number := 0;
  
  begin
    lc_MismaCtayAval := 'S';
  
    begin
      select s.sng001cta
        into ln_CtaVuelo
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        ln_CtaVuelo := 0;
    end;
  
    begin
      select j.jaqy800cta, j.jaqy800ins2
        into ln_CtaVncla, ln_InstVncla
        from jaqy800 j
       where j.jaqy800ins = ln_instancia
         and j.jaqy800vinc = 'S';
    exception
      when others then
        ln_CtaVncla  := 0;
        ln_InstVncla := 0;
    end;
  
    if ln_CtaVuelo = ln_CtaVncla then
    
      begin
        select count(*)
          into ln_avalproc
          from sng003 s
         where s.sng001inst = ln_instancia;
      exception
        when others then
          ln_avalproc := 0;
      end;
    
      begin
        select count(*)
          into ln_avalvncl
          from sng003 s
         where s.sng001inst = ln_InstVncla;
      exception
        when others then
          ln_avalvncl := 0;
      end;
    
      if ln_avalvncl > 0 then
        if ln_avalproc = ln_avalvncl then
        
          for a in avales(ln_InstVncla) loop
          
            begin
              select count(*)
                into ln_existe
                from sng003 s
               where s.sng001inst = ln_instancia
                 and s.sng003cta = a.sng003cta;
            exception
              when others then
                ln_existe := 0;
            end;
          
            if ln_existe = 0 then
              lc_MismaCtayAval := 'N';
              exit;
            
            else
              lc_MismaCtayAval := 'S';
            
            end if;
          end loop;
        end if;
      end if;
    
    else
      lc_MismaCtayAval := 'N'; -- INC3033 MPOSTIGOC 25.11.2020
    end if;
  
  end sp_cr_VerfAvalyCta;
  ----------------------------------------------------
  procedure sp_cr_VerMismaGarantia(ln_instancia     in number,
                                   lc_MismaGarantia out varchar2) is
  
    cursor garantias(ln_InstVncla number) is
      select s.sng122pgc,
             s.sng122mod,
             s.sng122suc,
             s.sng122mda,
             s.sng122pap,
             s.sng122cta,
             s.sng122oper,
             s.sng122sbop,
             s.sng122tope
        from sng122 s
       where s.sng122inst = ln_InstVncla
         and s.sng122tope in (select f.tp1nro1
                                from fst198 f
                               where f.tp1cod = 1
                                 and f.tp1cod1 = 10855
                                 and f.tp1corr1 = 13
                                 and f.tp1corr2 = 2); -- garantias reales
  
    ln_InstVncla   number := 0;
    ln_garanproc   number := 0;
    ln_garanvncl   number := 0;
    ln_ExistGarant number := 0;
  
  begin
    lc_MismaGarantia := 'S';
  
    begin
      select j.jaqy800ins2
        into ln_InstVncla
        from jaqy800 j
       where j.jaqy800ins = ln_instancia
         and j.jaqy800vinc = 'S';
    exception
      when others then
        ln_InstVncla := 0;
    end;
  
    if ln_InstVncla > 0 then
    
      begin
        select count(*)
          into ln_garanproc
          from sng122 s
         where s.sng122inst = ln_instancia
           and s.sng122tope in (select f.tp1nro1
                                  from fst198 f
                                 where f.tp1cod = 1
                                   and f.tp1cod1 = 10855
                                   and f.tp1corr1 = 13
                                   and f.tp1corr2 = 2);
      exception
        when others then
          ln_garanproc := 0;
      end;
    
      begin
        select count(*)
          into ln_garanvncl
          from sng122 s
         where s.sng122inst = ln_InstVncla
           and s.sng122tope in (select f.tp1nro1
                                  from fst198 f
                                 where f.tp1cod = 1
                                   and f.tp1cod1 = 10855
                                   and f.tp1corr1 = 13
                                   and f.tp1corr2 = 2);
      exception
        when others then
          ln_garanvncl := 0;
      end;
    
      if ln_garanvncl > 0 then
      
        if ln_garanproc = ln_garanvncl then
        
          for g in garantias(ln_InstVncla) loop
          
            begin
              select count(*)
                into ln_ExistGarant
                from sng122 s
               where s.sng122inst = ln_instancia
                 and s.sng122pgc = g.sng122pgc
                 and s.sng122mod = g.sng122mod
                 and s.sng122suc = g.sng122suc
                 and s.sng122mda = g.sng122mda
                 and s.sng122pap = g.sng122pap
                 and s.sng122cta = g.sng122cta
                 and s.sng122oper = g.sng122oper
                 and s.sng122sbop = g.sng122sbop
                 and s.sng122tope = g.sng122tope;
            exception
              when others then
                ln_ExistGarant := 0;
            end;
          
            if ln_ExistGarant = 0 then
              lc_MismaGarantia := 'N';
              exit;
            
            else
              lc_MismaGarantia := 'S';
            end if;
          end loop;
        
        else
          lc_MismaGarantia := 'N';
        
        end if;
      end if;
    end if;
  
  end sp_cr_VerMismaGarantia;
  ------------------------------------------------------------------
  -- Carga de Pizarras para Reprogramados Novacion
  procedure sp_cr_PizaNovacion(lc_digito in varchar2) is
  
    cursor listado_027(ld_MaxFch842 date) is
      select distinct q.aqpa842mod    Modulo,
                      q.aqpa842cta    Cuenta,
                      q.aqpa842top    TipoOperacion,
                      q.aqpa842mda    Moneda,
                      q.aqpa842pap    Papel,
                      999999999999.99 Monto
        from aqpa842 q
       where q.aqpa842emp = 1
         and q.aqpa842mda in (0, 101)
         and q.aqpa842pap = 0
         and q.aqpa842fecupd = ld_MaxFch842
         and to_char(substr(trim(q.aqpa842cta), -1, 1)) = lc_digito;
  
    cursor listado_327(ld_MaxFch842 date) is
      select distinct q.aqpa842mod Modulo,
                      q.aqpa842cta Cuenta,
                      q.aqpa842top TipoOperacion,
                      q.aqpa842mda Moneda,
                      q.aqpa842pap Papel
        from aqpa842 q
       where q.aqpa842emp = 1
         and q.aqpa842mda in (0, 101)
         and q.aqpa842pap = 0
         and q.aqpa842fecupd = ld_MaxFch842
         and to_char(substr(trim(q.aqpa842cta), -1, 1)) = lc_digito;
  
    cursor listado_r027(ld_MaxFch842 date) is
    
      select distinct q.aqpa842mod    Modulo,
                      q.aqpa842cta    Cuenta,
                      q.aqpa842top    TipoOperacion,
                      q.aqpa842mda    Moneda,
                      q.aqpa842pap    Papel,
                      999999999999.99 Monto,
                      99999           Plazo,
                      q.aqpa842tasa   Tasa
        from aqpa842 q
       where q.aqpa842emp = 1
         and q.aqpa842mda in (0, 101)
         and q.aqpa842pap = 0
         and q.aqpa842fecupd = ld_MaxFch842
         and to_char(substr(trim(q.aqpa842cta), -1, 1)) = lc_digito;
  
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
    ld_MaxFch842 date;
    vFechahasta  date;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
  
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(a.aqpa842fecupd) into ld_MaxFch842 from aqpa842 a;
      exception
        when others then
          null;
      end;
    
      begin
      
        SELECT ADD_MONTHS(TRUNC(ld_MaxFch842, 'MM'), 1)
          into vFechahasta
          FROM DUAL;
      end;
    
      begin
        select to_char(ld_MaxFch842, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_MaxFch842, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_MaxFch842, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_MaxFch842 is not null then
    
      for l in listado_027(ld_MaxFch842) loop
      
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
               and f.tpfdes = ld_MaxFch842
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
                 ld_MaxFch842,
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
                 ld_MaxFch842,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
          end if;
        end if;
      end loop;
    
      for j in listado_327(ld_MaxFch842) loop
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
               and f.vt1tpfd = ld_MaxFch842;
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
                 ld_MaxFch842,
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
                 ld_MaxFch842,
                 vFechahasta);
            end;
            commit;
          end if;
        end if;
      end loop;
    
      for t in listado_r027(ld_MaxFch842) loop
      
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
               and f.tpfdes = ld_MaxFch842
               and f.tpmto = t.monto
               and f.tppzo = t.plazo;
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
                 ld_MaxFch842,
                 t.monto,
                 t.plazo,
                 t.tasa);
              commit;
            exception
              when others then
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
                     ld_MaxFch842,
                     t.monto,
                     t.plazo,
                     t.tasa);
                  commit;
                end;
            end;
          else
            if ln_nroregr27 = 1 then
            
              begin
                update fsr027 f
                   set f.tptasa = t.tasa
                 where f.pgcod = 1
                   and f.modulo = t.modulo
                   and f.tpizar = ln_Pp028DefN
                   and f.ctnro = t.cuenta
                   and f.moneda = t.moneda
                   and f.papel = t.papel
                   and f.tpfdes = ld_MaxFch842
                   and f.tpmto = t.monto
                   and f.tppzo = t.plazo;
                commit;
              end;
            end if;
          end if;
        end if;
      end loop;
    
    end if;
  end sp_cr_PizaNovacion;
  ------------------------------------------------------------------
  Procedure sp_cr_carga_job_Novacion is
  
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
    
      lc_variable := ' begin ' ||
                     'pq_cr_credvinculados.sp_cr_pizanovacion(''' || x ||
                     ''');' || ' End; ';
    
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
  
  end sp_cr_carga_job_Novacion;

end PQ_CR_CREDVINCULADOS;
/

