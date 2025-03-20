create or replace package PQ_CR_FAE_TURISMO is

  -- Author  : MPOSTIGOC
  -- Created : 27/05/2021 20:31:21
  -- Purpose : 

  -- Purpose : 

  procedure sp_cr_PizaFaeTur(lc_digito in varchar2);
  -----------------------------------------------------
  Procedure sp_cr_Job_PizaFaeTur;
  --------------------------------------
  -- Carga de PIzarras para PAE PYME
  procedure sp_cr_PizaPaePyme(lc_digito in varchar2);
  ------------------------------------------
  Procedure sp_cr_Job_PizaPaePyme;
 --------------------------------------------------------- 
      procedure SP_CR_DIAS_GRACIA(                         
                          pn_instancia number,                          
                          pn_result out varchar);
  ---------------------------------------------------------
  procedure SP_CR_OBTIENE_FAE_TURISMO
  (pn_instancia IN NUMBER,
   pc_actividad OUT VARCHAR,
   pc_ciiu OUT VARCHAR) ;

end PQ_CR_FAE_TURISMO;
/

create or replace package body PQ_CR_FAE_TURISMO is

  -- Carga de PIzarras para Paralelos
  procedure sp_cr_PizaFaeTur(lc_digito in varchar2) is
  
    cursor listado_027(ld_FchCar456 date) is
      select distinct q.aqpb456pais ln_pais,
                      q.aqpb456tdoc ln_tdoc,
                      q.aqpb456ndoc lc_ndoc,
                      101           Modulo,
                      q.aqpb456cta1 Cuenta,
                      355           TipoOperacion,
                      0             Moneda,
                      0             Papel,
                      9999999999.99 Monto
        from aqpb456 q
       where q.aqpb456fcar = ld_FchCar456
         and substr(trim(q.aqpb456ndoc), -1, 1) = lc_digito
         and q.aqpb456ind <> 'PAEM';
  
    cursor listado_327(ld_FchCar456 date) is
      select distinct q.aqpb456pais ln_pais,
                      q.aqpb456tdoc ln_tdoc,
                      q.aqpb456ndoc lc_ndoc,
                      101           Modulo,
                      q.aqpb456cta1 Cuenta,
                      355           TipoOperacion,
                      0             Moneda,
                      0             Papel
        from aqpb456 q
       where q.aqpb456fcar = ld_FchCar456
         and substr(trim(q.aqpb456ndoc), -1, 1) = lc_digito
         and q.aqpb456ind <> 'PAEM';
  
    cursor listado_r027(ld_FchCar456 date) is
      select distinct q.aqpb456pais ln_pais,
                      q.aqpb456tdoc ln_tdoc,
                      q.aqpb456ndoc lc_ndoc,
                      101           Modulo,
                      q.aqpb456cta1 Cuenta,
                      355           TipoOperacion,
                      0             Moneda,
                      0             Papel,
                      9999999999.99 Monto,
                      99999         Plazo,
                      q.aqpb456tasa Tasa
        from aqpb456 q
       where q.aqpb456fcar = ld_FchCar456
         and substr(trim(q.aqpb456ndoc), -1, 1) = lc_digito
         and q.aqpb456ind <> 'PAEM';
  
    cursor cuentas(ln_pais   number,
                   ln_tdoc   number,
                   lc_ndoc   varchar2,
                   ln_cuenta number) is
      select f.ctnro Cuenta
        from fsr008 f
       where f.pepais = ln_pais
         and f.petdoc = ln_tdoc
         and f.pendoc = lc_ndoc
         and f.ctnro <> ln_cuenta;
  
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
    ld_FchCar456 date;
    vFechahasta  date;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
  
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(a.aqpb456fcar) into ld_FchCar456 from aqpb456 a;
      exception
        when others then
          null;
      end;
    
      --begin
    
      /* SELECT ADD_MONTHS(TRUNC(ld_FchCar456, 'MM'), 1) + 4 --mpostigoc 12.10.2020
      into vFechahasta
      FROM DUAL;*/
    
      -- end;
    
      begin
        select to_char(ld_FchCar456, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_FchCar456, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_FchCar456, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_FchCar456 is not null then
    
      for l in listado_027(ld_FchCar456) loop
      
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
               and f.tpfdes = ld_FchCar456
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
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_FchCar456,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          
          end if;
        end if;
      
        for c in cuentas(l.ln_pais, l.ln_tdoc, l.lc_ndoc, l.cuenta) loop
        
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
                 and f.tpfdes = ld_FchCar456
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
                   ld_FchCar456,
                   l.monto,
                   1,
                   vTpfinv,
                   'S');
              end;
              commit;
            
            end if;
          end if;
        end loop;
      end loop;
    
      for j in listado_327(ld_FchCar456) loop
      
        begin
          select a.aqpb456fmdes
            into vFechahasta
            from aqpb456 a
           where a.aqpb456fcar = ld_FchCar456
             and a.aqpb456pais = j.ln_pais
             and a.aqpb456tdoc = j.ln_tdoc
             and a.aqpb456ndoc = j.lc_ndoc;
        end;
      
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
               and f.vt1tpfd = ld_FchCar456;
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
                 ld_FchCar456,
                 vFechahasta);
            end;
            commit;
          end if;
        end if;
      
        for c in cuentas(j.ln_pais, j.ln_tdoc, j.lc_ndoc, j.cuenta) loop
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
                 and f.vt1tpfd = ld_FchCar456;
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
                   ld_FchCar456,
                   vFechahasta);
              end;
              commit;
            end if;
          end if;
        end loop;
      end loop;
    
      for t in listado_r027(ld_FchCar456) loop
      
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
               and f.tpfdes = ld_FchCar456
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
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_FchCar456,
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
                     t.cuenta,
                     t.moneda,
                     t.papel,
                     ld_FchCar456,
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
                   and f.ctnro = t.cuenta
                   and f.moneda = t.moneda
                   and f.papel = t.papel
                   and f.tpfdes = ld_FchCar456
                   and f.tpmto = t.monto
                   and f.tppzo = 99999;
                -- and f.tppzo = t.plazo;
                commit;
              end;
            end if;
          end if;
        end if;
      
        for c in cuentas(t.ln_pais, t.ln_tdoc, t.lc_ndoc, t.cuenta) loop
        
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
                 and f.tpfdes = ld_FchCar456
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
                   ld_FchCar456,
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
                       ld_FchCar456,
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
                     and f.tpfdes = ld_FchCar456
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
  end sp_cr_PizaFaeTur;
  ---------------------------------------------------
  Procedure sp_cr_Job_PizaFaeTur is
  
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
    
      lc_variable := ' begin ' || 'PQ_CR_FAE_TURISMO.sp_cr_PizaFaeTur(''' || x ||
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
  
  end sp_cr_Job_PizaFaeTur;
  ---------------------------------------
  -- Carga de PIzarras para PAE PYME
  procedure sp_cr_PizaPaePyme(lc_digito in varchar2) is
  
    cursor listado_027(ld_FchCar456 date) is
      select distinct q.aqpb456pais ln_pais,
                      q.aqpb456tdoc ln_tdoc,
                      q.aqpb456ndoc lc_ndoc,
                      101           Modulo,
                      q.aqpb456cta1 Cuenta,
                      356           TipoOperacion,
                      0             Moneda,
                      0             Papel,
                      9999999999.99 Monto
        from aqpb456 q
       where q.aqpb456fcar = ld_FchCar456
         and substr(trim(q.aqpb456ndoc), -1, 1) = lc_digito
         and q.aqpb456ind = 'PAEM';
  
    cursor listado_327(ld_FchCar456 date) is
      select distinct q.aqpb456pais ln_pais,
                      q.aqpb456tdoc ln_tdoc,
                      q.aqpb456ndoc lc_ndoc,
                      101           Modulo,
                      q.aqpb456cta1 Cuenta,
                      356           TipoOperacion,
                      0             Moneda,
                      0             Papel
        from aqpb456 q
       where q.aqpb456fcar = ld_FchCar456
         and substr(trim(q.aqpb456ndoc), -1, 1) = lc_digito
         and q.aqpb456ind = 'PAEM';
  
    cursor listado_r027(ld_FchCar456 date) is
      select distinct q.aqpb456pais ln_pais,
                      q.aqpb456tdoc ln_tdoc,
                      q.aqpb456ndoc lc_ndoc,
                      101           Modulo,
                      q.aqpb456cta1 Cuenta,
                      356           TipoOperacion,
                      0             Moneda,
                      0             Papel,
                      9999999999.99 Monto,
                      99999         Plazo,
                      q.aqpb456tasa Tasa
        from aqpb456 q
       where q.aqpb456fcar = ld_FchCar456
         and substr(trim(q.aqpb456ndoc), -1, 1) = lc_digito
         and q.aqpb456ind = 'PAEM';
  
    cursor cuentas(ln_pais   number,
                   ln_tdoc   number,
                   lc_ndoc   varchar2,
                   ln_cuenta number) is
      select f.ctnro Cuenta
        from fsr008 f
       where f.pepais = ln_pais
         and f.petdoc = ln_tdoc
         and f.pendoc = lc_ndoc
         and f.ctnro <> ln_cuenta;
  
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
    ld_FchCar456 date;
    vFechahasta  date;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
  
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(a.aqpb456fcar)
          into ld_FchCar456
          from aqpb456 a
         where a.aqpb456ind = 'PAEM';
      exception
        when others then
          null;
      end;
    
      --begin
    
      /* SELECT ADD_MONTHS(TRUNC(ld_FchCar456, 'MM'), 1) + 4 --mpostigoc 12.10.2020
      into vFechahasta
      FROM DUAL;*/
    
      -- end;
    
      begin
        select to_char(ld_FchCar456, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_FchCar456, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_FchCar456, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_FchCar456 is not null then
    
      for l in listado_027(ld_FchCar456) loop
      
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
               and f.tpfdes = ld_FchCar456
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
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_FchCar456,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            exception
              when others then
                null;
            end;
            commit;
          
          end if;
        end if;
      
        for c in cuentas(l.ln_pais, l.ln_tdoc, l.lc_ndoc, l.cuenta) loop
        
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
                 and f.tpfdes = ld_FchCar456
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
                   ld_FchCar456,
                   l.monto,
                   1,
                   vTpfinv,
                   'S');
              exception
                when others then
                  null;
              end;
              commit;
            
            end if;
          end if;
        end loop;
      end loop;
    
      for j in listado_327(ld_FchCar456) loop
      
        begin
          select a.aqpb456fmdes
            into vFechahasta
            from aqpb456 a
           where a.aqpb456fcar = ld_FchCar456
             and a.aqpb456pais = j.ln_pais
             and a.aqpb456tdoc = j.ln_tdoc
             and a.aqpb456ndoc = j.lc_ndoc;
        end;
      
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
               and f.vt1tpfd = ld_FchCar456;
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
                 ld_FchCar456,
                 vFechahasta);
                  exception
              when others then
                null;
            end;
            commit;
          end if;
        end if;
      
        for c in cuentas(j.ln_pais, j.ln_tdoc, j.lc_ndoc, j.cuenta) loop
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
                 and f.vt1tpfd = ld_FchCar456;
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
                   ld_FchCar456,
                   vFechahasta);
                    exception
              when others then
                null;
              end;
              commit;
            end if;
          end if;
        end loop;
      end loop;
    
      for t in listado_r027(ld_FchCar456) loop
      
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
               and f.tpfdes = ld_FchCar456
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
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_FchCar456,
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
                     t.cuenta,
                     t.moneda,
                     t.papel,
                     ld_FchCar456,
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
                   and f.ctnro = t.cuenta
                   and f.moneda = t.moneda
                   and f.papel = t.papel
                   and f.tpfdes = ld_FchCar456
                   and f.tpmto = t.monto
                   and f.tppzo = 99999;
                -- and f.tppzo = t.plazo;
                commit;
              end;
            end if;
          end if;
        end if;
      
        for c in cuentas(t.ln_pais, t.ln_tdoc, t.lc_ndoc, t.cuenta) loop
        
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
                 and f.tpfdes = ld_FchCar456
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
                   ld_FchCar456,
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
                       ld_FchCar456,
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
                     and f.tpfdes = ld_FchCar456
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
  end sp_cr_PizaPaePyme;
  ------------------------------------------
  Procedure sp_cr_Job_PizaPaePyme is
  
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
    
      lc_variable := ' begin ' || 'PQ_CR_FAE_TURISMO.sp_cr_PizaPaePyme(''' || x ||
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
  
  end sp_cr_Job_PizaPaePyme;

---------------------------------------------------------------------------------------------
  procedure SP_CR_DIAS_GRACIA(                         
                          pn_instancia number,                          
                          pn_result out varchar) is                                              
/*****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.03.16
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna dias de gracia
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_instancia (INSTANCIA)
   
    -- Parámetros de Salida       : pn_result (dias de gracia)

    ******************************************************************/    

ln_pgcod1  number(3);
ln_scsuc1  number(3);
ln_scmda1  number(3);
ln_scpap1  number(3) ;
ln_sccta1  number(9);
ln_scoper1 number(9);
ln_scsbop1 number(3);
ln_sctope1 number(3);
ln_scmod1  number(3);

ln_pgcod2 number(3);
ln_scsuc2 number(3);
ln_scmda2 number(3);
ln_scpap2 number(3) ;
ln_sccta2 number(9);
ln_scoper2 number(9);
ln_scsbop2 number(3);
ln_sctope2 number(3);
ln_scmod2 number(3);

ld_fecA date;
ld_fecN date;
ln_result number(15,2) :=0; 
ln_result_aux1 number(15,2) :=0; 
ln_cont1 number(15) :=0; 
ld_fecN_aux1 date;
lc_valdia char(1) := 'N';
ln_valdia number(15) := 0;


begin 
 
/*obtener creditos xwf700*/

--CREDITO ORIGINAL
begin
    select S.XWFEMPRESA,
           S.XWFSUCURSAL,
           S.XWFMODULO,
           S.XWFMONEDA,
           S.XWFPAPEL,
           S.XWFCUENTA,
           S.XWFOPERACION,
           S.XWFSUBOPE,
           S.XWFTIPOPE
           INTO           
           ln_pgcod1, 
           ln_scsuc1, 
           ln_scmod1,
           ln_scmda1, 
           ln_scpap1, 
           ln_sccta1, 
           ln_scoper1,
           ln_scsbop1,
           ln_sctope1                     
           from xwf700 s           
           where s.xwfprcins =  pn_instancia
           AND S.XWFCAR3 = 'S';  
    
 EXCEPTION WHEN OTHERS THEN
    
           ln_pgcod1 := 0; 
           ln_scsuc1 := 0; 
           ln_scmod1 := 0;
           ln_scmda1 := 0; 
           ln_scpap1 := 0; 
           ln_sccta1 := 0; 
           ln_scoper1 := 0;
           ln_scsbop1 := 0;
           ln_sctope1 := 0;
     
  END;            

--CREDITO NUEVO

begin
    select S.XWFEMPRESA,
           S.XWFSUCURSAL,
           S.XWFMODULO,
           S.XWFMONEDA,
           S.XWFPAPEL,
           S.XWFCUENTA,
           S.XWFOPERACION,
           S.XWFSUBOPE,
           S.XWFTIPOPE
           INTO           
           ln_pgcod2, 
           ln_scsuc2, 
           ln_scmod2,
           ln_scmda2, 
           ln_scpap2, 
           ln_sccta2, 
           ln_scoper2,
           ln_scsbop2,
           ln_sctope2                     
           from xwf700 s           
           where s.xwfprcins =  pn_instancia
           AND S.XWFCAR3 = '1';  
    
 EXCEPTION WHEN OTHERS THEN
    
           ln_pgcod2 := 0; 
           ln_scsuc2 := 0; 
           ln_scmod2 := 0;
           ln_scmda2 := 0; 
           ln_scpap2 := 0; 
           ln_sccta2 := 0; 
           ln_scoper2 := 0;
           ln_scsbop2 := 0;
           ln_sctope2 := 0;
     
  END; 


/*obtener la primera cuota no pagada del credito origen*/
begin            
    select /*+index( fsd601 fsd60103)*/ min(ppfpag) into ld_fecA--fecha1    --hint 20230726
       from fsd601 
      where
        pgcod = ln_pgcod1
        and ppmod = ln_scmod1
        and ppcta = ln_sccta1
        and ppoper = ln_scoper1
        and ppsbop = ln_scsbop1
        and pptope = ln_sctope1
        and ppfpag > --   ld_fecpag; --fecha ultima cuota cancelada    
            nvl((select /*+index(fsd602 SYS_C00978743)*/ max(ppfpag)       --hint 20230726
               from fsd602 f
              where 
                pgcod = ln_pgcod1
                and ppmod = ln_scmod1
                and ppcta = ln_sccta1
                and ppoper = ln_scoper1
                and ppsbop = ln_scsbop1
                and pptope = ln_sctope1
                and f.PP1STAT = 'T'
                and f.D602CO = 'S'
                ),to_date('0001.01.01','rrrr.mm.dd') ) ;
exception when others then
  ld_fecA := null;
end;


/*obtener la primera cuota con capital e interes */

begin            
    select min(ppfpag) into ld_fecN--fecha1
       from fsd601 
      where
        pgcod = ln_pgcod2
        and ppmod = ln_scmod2
        and ppcta = ln_sccta2
        and ppoper = ln_scoper2
        and ppsbop = ln_scsbop2
        and pptope = ln_sctope2
        and ppcap > 0  ;
exception when others then
  ld_fecN := null;
end;

/*hacer diferencia en dias */
begin 
  
   ln_result := ld_fecN - ld_fecA;
  -- pn_result := to_char(ln_result);

/*Si la nueva fecha es un dia anterior a un(os) dia(s) feriado(s) y la diferencia en dias es menor al tope proximo (multiplo de 30)*/

/*Si la nueva fecha es un dia anterior a un(os) dia(s) feriado(s)*/
ld_fecN_aux1 := ld_fecN ;--fecha 
ln_cont1 := 0;
lc_valdia := 'S';

while(lc_valdia = 'S') loop   
   ln_cont1 := ln_cont1 +1;
   ld_fecN_aux1 := ld_fecN_aux1 + ln_cont1;   
    
   begin 
       select count(*)
         into ln_valdia
         from fst028 t
        where t.calcod = ln_scsuc2
          and t.ffecha = ld_fecN_aux1
          and t.fhabil = 'N';
   exception when others then 
     ln_valdia :=0;
   end;
    
   if ln_valdia > 0 then
      lc_valdia := 'S';
   else    
     lc_valdia := 'N';
     end if;    
   
end loop; 


ln_result_aux1 := ceil((ln_result)/30 ); --tope multiplo de 30
 
if ln_result <= ln_result_aux1*30 and ln_cont1 > 1 then  -- si  
      if ln_result+(ln_cont1-1) >= ln_result_aux1*30 then
           pn_result := to_char(ln_result_aux1*30); --se asigna el tope
      else
           pn_result := to_char(ln_result);   
      end if;
else
    pn_result := to_char(nvl(ln_result, '-1'));       
end if;

exception when others then
  pn_result  := '-1';
  end;

end SP_CR_DIAS_GRACIA;
-------------------------------------------------------------------------------------
procedure SP_CR_OBTIENE_FAE_TURISMO
  (pn_instancia IN NUMBER,
   pc_actividad OUT VARCHAR,
   pc_ciiu OUT VARCHAR) is
/*****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.03.16
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Retorna actividad economica
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_instancia (INSTANCIA)
    -- Parámetros de Salida       : pc_actividad (retorna actividad)

    ******************************************************************/    

    pn_emp number;
    pn_suc number;
    pn_mod number;
    pn_mda number;
    pn_pap number;
    pn_cta number;
    pn_ope number;
    pn_sbo number;
    pn_top number;
   
BEGIN
   
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
        into pn_emp,
             pn_suc,
             pn_mod,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top
        from xwf700 x
       where x.xwfprcins = pn_instancia
         and x.xwfcar3 = 'S' ---reprogramacion
         and rownum = 1;
    exception
      when others then
        pn_cta := null;
    end;
  

  BEGIN
    SELECT  TRIM(SUBSTR(H.ACT_ECONOMICA_ACTUAL,INSTR(H.ACT_ECONOMICA_ACTUAL,'-')+1,LENGTH(H.ACT_ECONOMICA_ACTUAL))) ACTIVIDAD,
            TRIM(SUBSTR(H.ACT_ECONOMICA_ACTUAL,0,INSTR(H.ACT_ECONOMICA_ACTUAL,'-')-1)) CIIU
              into pc_actividad,pc_ciiu
              FROM TURISMO G, TURISMO_CREDITOSFACILIDAD F, TURISMO_FORM_DATA H
              WHERE F.IDTURISMO = G.IDTURISMO
              AND H.DNICLIENTE = G.DNICLIENTE
              AND G.ESTADOSOLICITUD in ( 'BT', 'AP')
               AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) = pn_cta
               AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION, '-') + 1,99) = pn_ope
               AND F.EMPRESA = pn_emp
               AND F.SUCURSAL = pn_suc
               AND F.MODULO = pn_mod
               AND F.MONEDA = pn_mda
               AND F.PAPEL = pn_pap
               AND F.SUBOPERACION = pn_sbo --- disminuye 1 para obtener suboperacion credito origen
               AND F.TIPOOPERACION in (select f.tp1nro2
                                    from fst198 f 
                                    where f.tp1cod = 1 and f.tp1cod1 = 10899 and f.tp1corr1 = 400000 
                                    and f.tp1corr2 = 26 and f.tp1corr3 >=1);

  EXCEPTION WHEN OTHERS THEN
    pc_actividad := NULL;
  END;                               
END SP_CR_OBTIENE_FAE_TURISMO;


end PQ_CR_FAE_TURISMO;
/

