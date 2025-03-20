create or replace package PQ_CR_REPRO_LINEACVD is

  -- Author  : MPOSTIGOC
  -- Created : 23/03/2021 7:17:04 p. m.
  -- Purpose : 

  procedure sp_cr_Piza_LineaCvd(lc_digito in varchar2);
  --------------------------------------------
  procedure sp_cr_insert_fsd027(ln_pgcod  in number,
                                ln_modulo in number,
                                ln_tpizar in number,
                                ln_ctnro  in number,
                                ln_moneda in number,
                                ln_papel  in number,
                                ld_tpfdes in date,
                                ln_tpmto  in number,
                                ln_tpttas in number,
                                ln_tpfinv in number,
                                lc_tpvig  in varchar2);
  -------------------------------------------------------
  procedure sp_cr_insert_fsr027(ln_pgcod  in number,
                                ln_modulo in number,
                                ln_tpizar in number,
                                ln_ctnro  in number,
                                ln_moneda in number,
                                ln_papel  in number,
                                ld_tpfdes in date,
                                ln_tpmto  in number,
                                ln_tppzo  in number,
                                ln_tptasa in number);
  -----------------------------------------------------
  procedure sp_cr_insert_fsd327(ln_vt1pgcod  in number,
                                ln_vt1mod    in number,
                                ln_vt1tpiz   in number,
                                ln_vt1ctnr   in number,
                                ln_vt1mon    in number,
                                ln_vt1pap    in number,
                                ld_vt1tpfd   in date,
                                ld_vt1fchven in date);
  -----------------------------------------------------
  Procedure sp_cr_Job_PizaLineaCvd;

end PQ_CR_REPRO_LINEACVD;
/

create or replace package body PQ_CR_REPRO_LINEACVD is
  --------------------------------------------------------------
  -- Carga de PIzarras para Paralelos
  procedure sp_cr_Piza_LineaCvd(lc_digito in varchar2) is
  
    cursor listado_reprog(ld_FchCarReprog date) is
      select distinct to_number(SUBSTR(L.CUENTAOPERACION,
                                       0,
                                       INSTR(L.CUENTAOPERACION, '-') - 1)) Cuenta,
                      to_number(SUBSTR(L.CUENTAOPERACION,
                                       INSTR(L.CUENTAOPERACION, '-') + 1,
                                       99)) Operacion,
                      101 Modulo,
                      600 TipoOperacion,
                      0 Moneda,
                      0 Papel,
                      9999999999.99 Monto
        from REPROG L
       WHERE trunc(L.FECHACARGA) = ld_FchCarReprog
         and substr(trim(l.dnicliente), -1, 1) = lc_digito;
  
    cursor cuentas(ln_pais   number,
                   ln_tdoc   number,
                   lc_ndoc   varchar2,
                   ln_cuenta number) is
      select g.ctnro cuentaadic, count(*)
        from fsr008 g
       where g.ctnro in (select f.ctnro
                           from fsr008 f
                          where f.pgcod = 1
                            and f.pepais = ln_pais
                            and f.petdoc = ln_tdoc
                            and f.pendoc = lc_ndoc
                            and f.ctnro <> ln_cuenta)
       group by g.ctnro
      having count(*) = 1;
  
    vTpfinv         number;
    ln_Pp028DefN    number;
    ln_dia          varchar2(2);
    ln_mes          varchar2(2);
    ln_anio         varchar2(4);
    ld_FchInv       number;
    ld_FchCarReprog date;
    vFechahasta     date;
    ln_tasa         number(10, 6) := 0.000;
    ln_pais         number;
    ln_tdoc         number;
    lc_ndoc         varchar2(12);
    ln_otrasctas    number;
  
  begin
  
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(trunc(l.fechacarga)) into ld_FchCarReprog from REPROG L;
      exception
        when others then
          null;
      end;
    
      -- ld_FchCarReprog := to_date('05/11/2020', 'DD/MM/YYYY');
    
      begin
      
        /*        SELECT ADD_MONTHS(TRUNC(ld_FchCarReprog, 'MM'),) + 1 --mpostigoc 12.10.2020
                  into vFechahasta
                  FROM DUAL;
        */
        vFechahasta := to_date('01/01/2022', 'DD/MM/YYYY');
      end;
    
      begin
        select to_char(ld_FchCarReprog, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_FchCarReprog, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_FchCarReprog, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_FchCarReprog is not null then
    
      begin
        select Pp028DefN
          into ln_Pp028DefN
          from FPP028
         Where Pp028Emp = 1
           and Pp028Mod = 101 --l.modulo
           and Pp028Top = 600 --l.tipooperacion
           and Pp028Mda = 0 --l.moneda
           and Pp028Pap = 0 --l.papel
           and Pp017Par = 17;
      exception
        when others then
          null;
      end;
    
      for l in listado_reprog(ld_FchCarReprog) loop
      
        begin
          select f.aotasa
            into ln_tasa
            from fsd010 f
           where f.pgcod = 1
             and f.aopap = 0
             and f.aocta = l.cuenta
             and f.aooper = l.operacion
             and f.aomod = 116;
        exception
          when others then
            ln_tasa := 0;
        end;
      
        if ln_tasa > 0 then
          begin
            pq_cr_repro_lineacvd.sp_cr_insert_fsd027(ln_pgcod  => 1,
                                                     ln_modulo => l.modulo,
                                                     ln_tpizar => ln_Pp028DefN,
                                                     ln_ctnro  => l.cuenta,
                                                     ln_moneda => l.moneda,
                                                     ln_papel  => l.papel,
                                                     ld_tpfdes => ld_FchCarReprog,
                                                     ln_tpmto  => 999999999999.99,
                                                     ln_tpttas => 1,
                                                     ln_tpfinv => vTpfinv,
                                                     lc_tpvig  => 'S');
          end;
          begin
            pq_cr_repro_lineacvd.sp_cr_insert_fsr027(ln_pgcod  => 1,
                                                     ln_modulo => l.modulo,
                                                     ln_tpizar => ln_Pp028DefN,
                                                     ln_ctnro  => l.cuenta,
                                                     ln_moneda => l.moneda,
                                                     ln_papel  => l.papel,
                                                     ld_tpfdes => ld_FchCarReprog,
                                                     ln_tpmto  => 999999999999.99,
                                                     ln_tppzo  => 99999,
                                                     ln_tptasa => ln_tasa);
          end;
        
          begin
            pq_Cr_repro_lineacvd.sp_cr_insert_fsd327(ln_vt1pgcod  => 1,
                                                     ln_vt1mod    => l.modulo,
                                                     ln_vt1tpiz   => ln_Pp028DefN,
                                                     ln_vt1ctnr   => l.cuenta,
                                                     ln_vt1mon    => l.moneda,
                                                     ln_vt1pap    => l.papel,
                                                     ld_vt1tpfd   => ld_FchCarReprog,
                                                     ld_vt1fchven => vFechahasta);
          end;
        
          begin
            select f.pepais, f.petdoc, f.pendoc
              into ln_pais, ln_tdoc, lc_ndoc
              from fsr008 f
             where f.ctnro = l.cuenta;
          exception
            when others then
              null;
          end;
        
          begin
            select count(*)
              into ln_otrasctas
              from fsr008 g
             where g.ctnro in (select f.ctnro
                                 from fsr008 f
                                where f.pgcod = 1
                                  and f.pepais = ln_pais
                                  and f.petdoc = ln_tdoc
                                  and f.pendoc = lc_ndoc
                                  and f.ctnro <> l.cuenta);
          exception
            when others then
              ln_otrasctas := 0;
          end;
        
          if ln_otrasctas > 0 then
          
            for c in cuentas(ln_pais, ln_tdoc, lc_ndoc, l.cuenta) loop
            
              begin
                pq_cr_repro_lineacvd.sp_cr_insert_fsd027(ln_pgcod  => 1,
                                                         ln_modulo => l.modulo,
                                                         ln_tpizar => ln_Pp028DefN,
                                                         ln_ctnro  => c.cuentaadic,
                                                         ln_moneda => l.moneda,
                                                         ln_papel  => l.papel,
                                                         ld_tpfdes => ld_FchCarReprog,
                                                         ln_tpmto  => 999999999999.99,
                                                         ln_tpttas => 1,
                                                         ln_tpfinv => vTpfinv,
                                                         lc_tpvig  => 'S');
              end;
            
              begin
                pq_cr_repro_lineacvd.sp_cr_insert_fsr027(ln_pgcod  => 1,
                                                         ln_modulo => l.modulo,
                                                         ln_tpizar => ln_Pp028DefN,
                                                         ln_ctnro  => c.cuentaadic,
                                                         ln_moneda => l.moneda,
                                                         ln_papel  => l.papel,
                                                         ld_tpfdes => ld_FchCarReprog,
                                                         ln_tpmto  => 999999999999.99,
                                                         ln_tppzo  => 99999,
                                                         ln_tptasa => ln_tasa);
              end;
              begin
                pq_Cr_repro_lineacvd.sp_cr_insert_fsd327(ln_vt1pgcod  => 1,
                                                         ln_vt1mod    => l.modulo,
                                                         ln_vt1tpiz   => ln_Pp028DefN,
                                                         ln_vt1ctnr   => c.cuentaadic,
                                                         ln_vt1mon    => l.moneda,
                                                         ln_vt1pap    => l.papel,
                                                         ld_vt1tpfd   => ld_FchCarReprog,
                                                         ld_vt1fchven => vFechahasta);
              end;
            
            end loop;
          end if;
        end if;
      end loop;
    end if;
  
  end sp_cr_Piza_LineaCvd;

  ----------------------------------
  procedure sp_cr_insert_fsd027(ln_pgcod  in number,
                                ln_modulo in number,
                                ln_tpizar in number,
                                ln_ctnro  in number,
                                ln_moneda in number,
                                ln_papel  in number,
                                ld_tpfdes in date,
                                ln_tpmto  in number,
                                ln_tpttas in number,
                                ln_tpfinv in number,
                                lc_tpvig  in varchar2) is
  
  begin
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
        (ln_pgcod,
         ln_modulo,
         ln_tpizar,
         ln_ctnro,
         ln_moneda,
         ln_papel,
         ld_tpfdes,
         ln_tpmto,
         ln_tpttas,
         ln_tpfinv,
         lc_tpvig);
    exception
      when others then
        null;
    end;
  
    commit;
  
  end sp_cr_insert_fsd027;
  -------------------------------------------------
  procedure sp_cr_insert_fsr027(ln_pgcod  in number,
                                ln_modulo in number,
                                ln_tpizar in number,
                                ln_ctnro  in number,
                                ln_moneda in number,
                                ln_papel  in number,
                                ld_tpfdes in date,
                                ln_tpmto  in number,
                                ln_tppzo  in number,
                                ln_tptasa in number) is
  
  begin
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
        (ln_pgcod,
         ln_modulo,
         ln_tpizar,
         ln_ctnro,
         ln_moneda,
         ln_papel,
         ld_tpfdes,
         ln_tpmto,
         ln_tppzo,
         ln_tptasa);
    exception
      when others then
        null;
    end;
  
    commit;
  
  end sp_cr_insert_fsr027;
  -----------------------------------------------------
  procedure sp_cr_insert_fsd327(ln_vt1pgcod  in number,
                                ln_vt1mod    in number,
                                ln_vt1tpiz   in number,
                                ln_vt1ctnr   in number,
                                ln_vt1mon    in number,
                                ln_vt1pap    in number,
                                ld_vt1tpfd   in date,
                                ld_vt1fchven in date) is
  begin
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
        (ln_vt1pgcod,
         ln_vt1mod,
         ln_vt1tpiz,
         ln_vt1ctnr,
         ln_vt1mon,
         ln_vt1pap,
         ld_vt1tpfd,
         ld_vt1fchven);
    exception
      when others then
        null;
    end;
  
    commit;
  
  end sp_cr_insert_fsd327;
  ---------------------------------------------------
  Procedure sp_cr_Job_PizaLineaCvd is
  
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
                     'PQ_CR_REPRO_LINEACVD.sp_cr_Piza_LineaCvd(''' || x ||
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
  
  end sp_cr_Job_PizaLineaCvd;
  ------------------------------------------------------------------  
end PQ_CR_REPRO_LINEACVD;
/

