create or replace procedure SP_CR_GENTASASADIC is
  --Luis Carpio/Erika Hidalgo
  cursor todas_ctas is
    select distinct j.jaqz697cta ln_cuenta
      from jaqz697 j
     where j.jaqz697fep = TO_DATE('19052020', 'DDMMYYYY')
       and j.jaqz697des = 'ADICIONAL'
    minus
    select distinct a.aqpa372ct ln_cuenta
      from aqpa372 a
     where a.aqpa372fc = TO_DATE('19052020', 'DDMMYYYY')
       AND a.aqpa372ds = 'ADICIONAL';

  cursor ctas_372(ln_cta372 number) is
    select *
      from aqpa372 a
     where a.aqpa372ct = ln_cta372
       and a.aqpa372fc = TO_DATE('19052020', 'DDMMYYYY');
  cursor listado_027 is
    select distinct q.AQPA372mo Modulo,
                    q.AQPA372ct Cuenta,
                    q.AQPA372tp TipoOperacion,
                    q.AQPA372mn Moneda,
                    q.AQPA372pp Papel,
                    q.AQPA372im Monto
      from aqpa372 q
     where q.aqpa372mda in (0, 101)
       and q.aqpa372pap = 0
       and q.aqpa372fc = TO_DATE('19052020', 'DDMMYYYY')
       and q.aqpa372es = 'T';

  cursor listado_327 is

    select distinct q.AQPA372mo Modulo,
                    q.AQPA372ct Cuenta,
                    q.AQPA372tp TipoOperacion,
                    q.AQPA372mn Moneda,
                    q.AQPA372pp Papel
      from aqpa372 q
     where q.aqpa372mda in (0, 101)
       and q.aqpa372pap = 0
       and q.aqpa372fc = TO_DATE('19052020', 'DDMMYYYY')
       and q.aqpa372es = 'T';

  cursor listado_r027 is
    select distinct q.AQPA372mo Modulo,
                    q.AQPA372ct Cuenta,
                    q.AQPA372tp TipoOperacion,
                    q.AQPA372mn Moneda,
                    q.AQPA372pp Papel,
                    q.AQPA372im Monto,
                    q.aqpa372ta Tasa
      from aqpa372 q
     where q.aqpa372mda in (0, 101)
       and q.aqpa372pap = 0
       and q.aqpa372fc = TO_DATE('19052020', 'DDMMYYYY')
       and q.aqpa372es = 'T';

  ln_pais697    number;
  ln_tdoc697    number;
  lc_ndoc697    char(12);
  ln_cta372     number;
  ln_maxcorr372 number;
  ld_Fch372     date := TO_DATE('19052020', 'DDMMYYYY');
  vTpfinv       number;
  ln_Pp028DefN  number;
  ln_Pp028Mod   number;
  ln_Pp028Top   number;
  ln_Pp028Mda   number;
  ln_Pp028Pap   number;
  ln_Pp028Emp   number;
  ln_dia        varchar2(2);
  ln_mes        varchar2(2);
  ln_anio       varchar2(4);
  ld_FchInv     number;
  vFechahasta   date;
  ln_nroreg027  number := 0;
  ln_nroreg327  number := 0;
  ln_nroregr27  number := 0;

begin

  for t in todas_ctas loop

    begin
      select distinct j.jaqz697pai, j.jaqz697tdo, j.jaqz697ndo
        into ln_pais697, ln_tdoc697, lc_ndoc697
        from JAQZ697 j
       where j.jaqz697cta = t.ln_cuenta
         and j.jaqz697fep = TO_DATE('19052020', 'DDMMYYYY');
    exception
      when others then
        null;
    end;

    if ln_pais697 is not null then

      begin
        select distinct a.aqpa372ct
          into ln_cta372
          from aqpa372 a
         where a.aqpa372pa = ln_pais697
           and a.aqpa372td = ln_tdoc697
           and a.aqpa372nd = lc_ndoc697
           and a.aqpa372fc = TO_DATE('19052020', 'DDMMYYYY');
      exception
        when others then
          null;
      end;
    end if;

    for s in ctas_372(ln_cta372) loop

      begin
        select max(a.aqpa372id) into ln_maxcorr372 from aqpa372 a;
      end;

      ln_maxcorr372 := nvl(ln_maxcorr372, 0);

      begin
        insert into aqpa372
          (aqpa372id,
           aqpa372fc,
           aqpa372pa,
           aqpa372td,
           aqpa372nd,
           aqpa372ct,
           aqpa372su,
           aqpa372mo,
           aqpa372tp,
           aqpa372mn,
           aqpa372pp,
           aqpa372pe,
           aqpa372im,
           aqpa372ta,
           aqpa372as,
           aqpa372es,
           aqpa372so,
           aqpa372ds,
           aqpa372pgcod,
           aqpa372mod,
           aqpa372suc,
           aqpa372mda,
           aqpa372pap,
           aqpa372cta,
           aqpa372ope,
           aqpa372sbop,
           aqpa372tope,
           aqpa372ind,
           aqpa372plz)
        values
          (ln_maxcorr372 + 1,
           s. aqpa372fc,
           s.aqpa372pa,
           s.aqpa372td,
           s.aqpa372nd,
           ln_cta372,
           s.aqpa372su,
           s.aqpa372mo,
           s.aqpa372tp,
           s.aqpa372mn,
           s.aqpa372pp,
           s.aqpa372pe,
           s.aqpa372im,
           s.aqpa372ta,
           s.aqpa372as,
           'T',
           s.aqpa372so,
           s.aqpa372ds,
           s.aqpa372pgcod,
           s.aqpa372mod,
           s.aqpa372suc,
           s.aqpa372mda,
           s.aqpa372pap,
           s.aqpa372cta,
           s.aqpa372ope,
           s.aqpa372sbop,
           s.aqpa372tope,
           s.aqpa372ind,
           s.aqpa372plz);
        commit;
      end;

    end loop;

  end loop;

  begin

    begin
      SELECT ADD_MONTHS(TRUNC(ld_Fch372, 'MM'), 1)
        into vFechahasta
        FROM DUAL;
    end;

    begin
      select to_char(ld_Fch372, 'DD') into ln_dia from dual;
    end;
    begin
      select to_char(ld_Fch372, 'MM') into ln_mes from dual;
    end;
    begin
      select to_char(ld_Fch372, 'YYYY') into ln_anio from dual;
    end;

    ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);

    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;

    for l in listado_027 loop

      ln_nroreg027 := 0;

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
             and f.tpfdes = ld_Fch372
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
               ld_Fch372,
               l.monto,
               1,
               vTpfinv,
               'S');
          end;

        else
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
             ld_Fch372,
             l.monto,
             1,
             vTpfinv,
             'S');
        end if;
      end if;
    end loop;

    for j in listado_327 loop

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
             and f.vt1tpfd = ld_Fch372;
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
               ld_Fch372,
               vFechahasta);
          end;
        else
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
             ld_Fch372,
             vFechahasta);

        end if;
      end if;
    end loop;

    for t in listado_r027 loop

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
             and f.tpfdes = ld_Fch372
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
               ld_Fch372,
               t.monto,
               99999,
               t.tasa);
          end;
        else
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
             ld_Fch372,
             t.monto,
             99999,
             t.tasa);
        end if;
      end if;
    end loop;
    commit;
  end;
insert into AQPB876 values (user,sysdate,'SP_CR_GENTASASADIC', '');
commit;

end SP_CR_GENTASASADIC;
/

