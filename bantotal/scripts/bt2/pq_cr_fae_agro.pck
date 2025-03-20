create or replace package PQ_CR_FAE_AGRO is

  -- Author  : MPOSTIGOC
  -- Created : 23/03/2021 7:17:04 p. m.
  -- Purpose : 

  procedure sp_cr_PizaFae(lc_digito in varchar2);
  -----------------------------------------------------
  Procedure sp_cr_Job_PizaFae;

end PQ_CR_FAE_AGRO;
/

create or replace package body PQ_CR_FAE_AGRO is
  --------------------------------------------------------------
  -- Carga de PIzarras para Paralelos
  procedure sp_cr_PizaFae(lc_digito in varchar2) is
  
    cursor listado_027(ln_FchCar091 date) is
      select distinct q.aqpb091pais ln_pais,
                      q.aqpb091tdoc ln_tdoc,
                      q.aqpb091ndoc lc_ndoc,
                      117           Modulo,
                      --q.AQPA372ct Cuenta,
                      20            TipoOperacion,
                      0             Moneda,
                      0             Papel,
                      9999999999.99 Monto
        from aqpb091 q
       where q.aqpb091fcar = ln_FchCar091
         and substr(trim(q.aqpb091ndoc), -1, 1) = lc_digito;
  
    cursor listado_327(ln_FchCar091 date) is
      select distinct q.aqpb091pais ln_pais,
                      q.aqpb091tdoc ln_tdoc,
                      q.aqpb091ndoc lc_ndoc,
                      117           Modulo,
                      -- q.AQPA372ct Cuenta,
                      20 TipoOperacion,
                      0  Moneda,
                      0  Papel
        from aqpb091 q
       where q.aqpb091fcar = ln_FchCar091
         and substr(trim(q.aqpb091ndoc), -1, 1) = lc_digito;
  
    cursor listado_r027(ln_FchCar091 date) is
      select distinct q.aqpb091pais ln_pais,
                      q.aqpb091tdoc ln_tdoc,
                      q.aqpb091ndoc lc_ndoc,
                      117           Modulo,
                      --q.AQPA372ct  Cuenta,
                      20            TipoOperacion,
                      0             Moneda,
                      0             Papel,
                      9999999999.99 Monto,
                      99999         Plazo,
                      q.aqpb091tasa Tasa
        from aqpb091 q
       where q.aqpb091fcar = ln_FchCar091
         and substr(trim(q.aqpb091ndoc), -1, 1) = lc_digito;
  
    cursor cuentas(ln_pais number, ln_tdoc number, lc_ndoc varchar2) is
      select f.ctnro Cuenta
        from fsr008 f
       where f.pepais = ln_pais
         and f.petdoc = ln_tdoc
         and f.pendoc = lc_ndoc;
  
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
    ln_FchCar091 date;
    vFechahasta  date;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
  
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(a.aqpb091fcar) into ln_FchCar091 from aqpb091 a;
      exception
        when others then
          null;
      end;
    
      --begin
    
      /* SELECT ADD_MONTHS(TRUNC(ln_FchCar091, 'MM'), 1) + 4 --mpostigoc 12.10.2020
      into vFechahasta
      FROM DUAL;*/
    
      -- end;
    
      begin
        select to_char(ln_FchCar091, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ln_FchCar091, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ln_FchCar091, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ln_FchCar091 is not null then
    
      for l in listado_027(ln_FchCar091) loop
        for c in cuentas(l.ln_pais, l.ln_tdoc, l.lc_ndoc) loop
        
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
                 and f.ctnro = c.cuenta
                 and f.moneda = l.moneda
                 and f.papel = l.papel
                 and f.tpfdes = ln_FchCar091
                 and f.tpmto = l.monto
                 and f.tpvig = 'S';
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
                   c.cuenta,
                   l.moneda,
                   l.papel,
                   ln_FchCar091,
                   l.monto,
                   1,
                   vTpfinv,
                   'S');
              end;
              commit;
              /*else
              if ln_nroreg027 > 0 then
              
                begin
                  update fsd027 f
                     set f.tpvig = 'N'
                   where f.pgcod = 1
                     and f.modulo = l.modulo
                     and f.tpizar = ln_Pp028DefN
                     and f.ctnro = c.cuenta
                     and f.moneda = l.moneda
                     and f.papel = l.papel
                        --  and f.tpfdes = ln_FchCar091
                     and f.tpmto = l.monto
                     and f.tpvig = 'S';
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
                     l.modulo,
                     ln_Pp028DefN,
                     c.cuenta,
                     l.moneda,
                     l.papel,
                     ln_FchCar091,
                     l.monto,
                     1,
                     vTpfinv,
                     'S');
                end;
                commit;
              end if;*/
            end if;
          end if;
        end loop;
      end loop;
    
      for j in listado_327(ln_FchCar091) loop
      
        begin
          select a.aqpb091fvig
            into vFechahasta
            from aqpb091 a
           where a.aqpb091fcar = ln_FchCar091
             and a.aqpb091pais = j.ln_pais
             and a.aqpb091tdoc = j.ln_tdoc
             and a.aqpb091ndoc = j.lc_ndoc;
        end;
      
        for c in cuentas(j.ln_pais, j.ln_tdoc, j.lc_ndoc) loop
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
                 and f.vt1ctnr = c.cuenta
                 and f.vt1mon = j.moneda
                 and f.vt1pap = j.papel
                 and f.vt1tpfd = ln_FchCar091;
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
                   c.cuenta,
                   j.moneda,
                   j.papel,
                   ln_FchCar091,
                   vFechahasta);
              end;
              commit;
            end if;
          end if;
        end loop;
      end loop;
    
      for t in listado_r027(ln_FchCar091) loop
        for c in cuentas(t.ln_pais, t.ln_tdoc, t.lc_ndoc) loop
        
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
                 and f.ctnro = c.cuenta
                 and f.moneda = t.moneda
                 and f.papel = t.papel
                 and f.tpfdes = ln_FchCar091
                 and f.tpmto = t.monto
                    -- and f.tppzo = t.plazo; -- mpostigoc 10.09.2020
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
                   c.cuenta,
                   t.moneda,
                   t.papel,
                   ln_FchCar091,
                   t.monto,
                   --  t.plazo,
                   99999,
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
                       c.cuenta,
                       t.moneda,
                       t.papel,
                       ln_FchCar091,
                       t.monto,
                       -- t.plazo,
                       99999,
                       t.tasa);
                    commit;
                  end;
              end;
            else
              if ln_nroregr27 = 1 then
                -- mpostigoc 10.09.2020
                begin
                  update fsr027 f
                     set f.tptasa = t.tasa
                   where f.pgcod = 1
                     and f.modulo = t.modulo
                     and f.tpizar = ln_Pp028DefN
                     and f.ctnro = c.cuenta
                     and f.moneda = t.moneda
                     and f.papel = t.papel
                     and f.tpfdes = ln_FchCar091
                     and f.tpmto = t.monto
                     and f.tppzo = 99999;
                  -- and f.tppzo = t.plazo;
                  commit;
                end;
              end if;
            end if;
          end if;
        end loop;
      end loop;
    
    end if;
  end sp_cr_PizaFae;
  ---------------------------------------------------
  Procedure sp_cr_Job_PizaFae is
  
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
    
      lc_variable := ' begin ' || 'PQ_CR_FAE_AGRO.sp_cr_PizaFae(''' || x ||
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
  
  end sp_cr_Job_PizaFae;
  ------------------------------------------------------------------  
end PQ_CR_FAE_AGRO;
/

