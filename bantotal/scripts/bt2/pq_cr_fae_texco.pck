create or replace package PQ_CR_FAE_TEXCO is

  -- Author  : RMONTESR
  -- Created : 22/11/2022 14:31:21
  -- Purpose :

  -- Purpose :

  procedure sp_cr_PizaFaeTex(lc_digito in varchar2);
  -----------------------------------------------------
  Procedure sp_cr_Job_PizaFaeTex;
  --------------------------------------

end PQ_CR_FAE_TEXCO;
/

create or replace package body PQ_CR_FAE_TEXCO is

  -- Carga de PIzarras para Paralelos
  procedure sp_cr_PizaFaeTEX(lc_digito in varchar2) is

    cursor listado_027(ld_FchCar456 date) is
      select distinct q.aqpc274pais ln_pais,
                      q.aqpc274tdoc ln_tdoc,
                      q.aqpc274ndoc lc_ndoc,
                      q.aqpc274mod  Modulo,
                      q.aqpc274ctcl Cuenta,
                      359           TipoOperacion,
                      0             Moneda,
                      0             Papel,
                      9999999999.99 Monto
        from aqpc274 q
       where q.aqpc274fcar = ld_FchCar456
         and substr(trim(q.aqpc274ndoc), -1, 1) = lc_digito
         --and q.aqpb456ind <> 'PAEM'
         and q.aqpc274vgnt = '1'
         and q.aqpc274cdap = 1;

    cursor listado_327(ld_FchCar456 date) is
      select distinct q.aqpc274pais ln_pais,
                      q.aqpc274tdoc ln_tdoc,
                      q.aqpc274ndoc lc_ndoc,
                      q.aqpc274mod  Modulo,
                      q.aqpc274ctcl Cuenta,
                      359           TipoOperacion,
                      0             Moneda,
                      0             Papel
        from aqpc274 q
       where q.aqpc274fcar = ld_FchCar456
         and substr(trim(q.aqpc274ndoc), -1, 1) = lc_digito
         --and q.aqpb456ind <> 'PAEM'
         and q.aqpc274vgnt = '1'
         and q.aqpc274cdap = 1;

    cursor listado_r027(ld_FchCar456 date) is
      select distinct q.aqpc274pais ln_pais,
                      q.aqpc274tdoc ln_tdoc,
                      q.aqpc274ndoc lc_ndoc,
                      q.aqpc274mod  Modulo,
                      q.aqpc274ctcl Cuenta,
                      359           TipoOperacion,
                      0             Moneda,
                      0             Papel,
                      9999999999.99 Monto,
                      99999         Plazo,
                      q.aqpc274tasa Tasa
        from aqpc274 q
       where q.aqpc274fcar = ld_FchCar456
         and substr(trim(q.aqpc274ndoc), -1, 1) = lc_digito
         --and q.aqpb456ind <> 'PAEM'
         and q.aqpc274vgnt = '1'
         and q.aqpc274cdap = 1;

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
        select max(a.aqpc274fcar) into ld_FchCar456 from aqpc274 a where a.aqpc274vgnt = '1' and a.aqpc274cdap = 1;
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
      exception
        when others then
          null;
      end;
      begin
        select to_char(ld_FchCar456, 'MM') into ln_mes from dual;
      exception
        when others then
          null;
      end;
      begin
        select to_char(ld_FchCar456, 'YYYY') into ln_anio from dual;
      exception
        when others then
          null;
      end;

      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;

    begin
      vTpfinv := 99999999 - ld_FchInv;
    exception
        when others then
          null;
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
          select a.aqpc274fvig
            into vFechahasta
            from aqpc274 a
           where a.aqpc274fcar = ld_FchCar456
             and a.aqpc274pais = j.ln_pais
             and a.aqpc274tdoc = j.ln_tdoc
             and a.aqpc274ndoc = j.lc_ndoc
             and a.aqpc274vgnt = '1'
             and a.aqpc274cdap = 1;
        exception
          when others then
            null;
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
                exception
                  when others then
                    null;
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
              exception
                when others then
                  null;
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
                  exception
                    when others then
                      null;
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
                exception
                  when others then
                    null;
                end;
              end if;
            end if;
          end if;
        end loop;
      end loop;

    end if;
  end sp_cr_PizaFaeTex;
  ---------------------------------------------------
  Procedure sp_cr_Job_PizaFaeTex is

    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);

  begin

    begin
      select host_name into lc_hostname from v$instance;
    exception
        when others then
          null;
    end;

    for x in 0 .. 9 loop

      lc_variable := ' begin ' || 'PQ_CR_FAE_TEXCO.sp_cr_PizaFaeTex(''' || x ||
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

  end sp_cr_Job_PizaFaeTex;
  

end PQ_CR_FAE_TEXCO;
/

