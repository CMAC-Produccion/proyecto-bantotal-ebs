create or replace procedure sp_cr_AgregaTasaCampania(ln_corr  in number,
                                                     ld_fcorr date) is
  cursor listado is
    select *
      from aqpa372 a
     where a.aqpa372fc = ld_fcorr
       and a.aqpa372cor697 = ln_corr;

  vFechahasta   date;
  ln_dia        varchar2(2);
  ln_mes        varchar2(2);
  ln_anio       varchar2(4);
  ld_FchInv     number;
  vTpfinv       number;
  ln_pizarra    number;
  ln_NroRegD027 number;
  ln_NroRegD327 number;
  ln_NroRegR027 number;

begin

  begin
    -- habilitar aprobacion de gerencia
    update jaqz697 j
       set j.jaqz697apr = 'N'
     where j.jaqz697fep = ld_fcorr
       and j.jaqz697cor = ln_corr
       and j.jaqz697tca = 'P';
    commit;
  exception
    when others then
      null;
  end;

  begin
    begin
      SELECT ADD_MONTHS(TRUNC(ld_fcorr, 'MM'), 1) + 4
        into vFechahasta
        FROM DUAL;
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(ld_fcorr, 'DD') into ln_dia from dual;
    exception
      when others then
        null;
    end;
    begin
      select to_char(ld_fcorr, 'MM') into ln_mes from dual;
    exception
      when others then
        null;
    end;
    begin
      select to_char(ld_fcorr, 'YYYY') into ln_anio from dual;
    exception
      when others then
        null;
    end;
  
    ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
  exception
    when others then
      null;
  end;

  begin
    vTpfinv := 99999999 - ld_FchInv;
  exception
    when others then
      null;
  end;

  for l in listado loop
  
    begin
      select f.pp028defn
        into ln_pizarra
        from fpp028 f
       where f.pp017par = 17
         and f.pp028emp = 1
         and f.pp028mod = l.aqpa372mo
         and f.pp028top = l.aqpa372tp
         and f.pp028mda = l.aqpa372mn
         and f.pp028pap = l.aqpa372pp;
    exception
      when others then
        ln_pizarra := 0;
    end;
  
    if ln_pizarra > 0 then
      --  FSD027
      begin
        select count(*)
          into ln_NroRegD027
          from fsd027 f
         where f.pgcod = 1
           and f.modulo = l.aqpa372mo
           and f.tpizar = ln_pizarra
           and f.ctnro = l.aqpa372ct
           and f.moneda = l.aqpa372mn
           and f.papel = l.aqpa372pp
           and f.tpfdes = l.aqpa372fc
           and f.tpvig = 'N';
      exception
        when others then
          null;
      end;
    
      if ln_NroRegD027 > 0 then
      
        update fsd027 f
           set f.tpvig = 'S'
         where f.pgcod = 1
           and f.modulo = l.aqpa372mo
           and f.tpizar = ln_pizarra
           and f.ctnro = l.aqpa372ct
           and f.moneda = l.aqpa372mn
           and f.papel = l.aqpa372pp
           and f.tpfdes = l.aqpa372fc
              -- and f.tpmto = l.aqpa372im
           and f.tpvig = 'S';
      else
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
             l.aqpa372mo,
             ln_pizarra,
             l.aqpa372ct,
             l.aqpa372mn,
             l.aqpa372pp,
             l.aqpa372fc,
             l.aqpa372im,
             1,
             vTpfinv,
             'S');
        exception
          when others then
            null;
        end;
      
      end if;
    
      -- FSR027
      begin
        select count(*)
          into ln_NroRegR027
          from fsr027 f
         where f.pgcod = 1
           and f.modulo = l.aqpa372mo
           and f.TPIZAR = ln_pizarra
           and f.CTNRO = l.aqpa372ct
           and f.MONEDA = l.aqpa372mn
           and f.PAPEL = l.aqpa372pp
           and f.TPFDES = l.aqpa372fc
              -- and f.TPMTO = l.aqpa372im
           and f.TPPZO = l.aqpa372plz;
      exception
        when others then
          null;
      end;
    
      if ln_NroRegR027 = 0 then
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
             l.aqpa372mo,
             ln_pizarra,
             l.aqpa372ct,
             l.aqpa372mn,
             l.aqpa372pp,
             l.aqpa372fc,
             l.aqpa372im,
             l.aqpa372plz,
             l.aqpa372ta);
        exception
          when others then
            null;
        end;
      
      end if;
    
      ------FSD327
    
      begin
        select count(*)
          into ln_NroRegD327
          from fsd327 f
         where f.VT1PGCOD = 1
           and f.VT1MOD = l.aqpa372mo
           and f.VT1TPIZ = ln_pizarra
           and f.VT1CTNR = l.aqpa372ct
           and f.VT1MON = l.aqpa372mn
           and f.VT1PAP = l.aqpa372pp
           and f.VT1TPFD = l.aqpa372fc;
      exception
        when others then
          null;
      end;
    
      if ln_NroRegD327 > 0 then
        update fsd327 g
           set g.vt1fchven = vFechahasta
         where g.vt1pgcod = 1
           and g.vt1mod = l.aqpa372mo
           and g.vt1tpiz = ln_pizarra
           and g.vt1ctnr = l.aqpa372ct
           and g.vt1mon = l.aqpa372mn
           and g.vt1pap = l.aqpa372pp
           and g.vt1tpfd = l.aqpa372fc;
      else
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
             l.aqpa372mo,
             ln_pizarra,
             l.aqpa372ct,
             l.aqpa372mn,
             l.aqpa372pp,
             l.aqpa372fc,
             vFechahasta);
        exception
          when others then
            null;
        end;
      end if;
      commit;
    end if;
  
  end loop;

end sp_cr_AgregaTasaCampania;
/

