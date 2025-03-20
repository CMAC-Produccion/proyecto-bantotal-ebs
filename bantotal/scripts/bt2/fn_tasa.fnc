create or replace function FN_tasa(vpgcod  number,
                                   vScsuc  number,
                                   vSccta  number,
                                   vScmda  number,
                                   vScpap  number,
                                   vScoper number,
                                   vScsbop number,
                                   vSctope number,
                                   vScmod  number) return number is

  tasa   fsd010.aotasa%type;
  petipo char(1);
  tipo   number(9);
  ctifin char(1);
  monto  number;

begin

  begin
    select ctifin into ctifin from fsd008 where ctnro = vsccta;
  exception
    when no_data_found then
      ctifin := 'N';
  end;

  begin
    select b.petipo
      into petipo
      from fsr008 a, fsd001 b
     where a.pepais = b.pepais
       and a.petdoc = b.petdoc
       and a.pendoc = b.pendoc
       and a.ctnro = vsccta
       and a.ttcod = 1
       and a.cttfir = 'T';
  exception
    when no_data_found then
      petipo := 'F';
  end;

  if vscmod = 21 then

    select totpiz
      into tipo
      from fst004
     where modulo = 21
       and toeleg = 'S'
       and totope = vsctope;

    if petipo = 'J' then
      If ctifin = 'S' then
        If vsctope = 3 then
          tipo := 97;
        Else
          tipo := 96;
        End if;
      Else
        begin
          select ModCodn
            into tipo
            from FST100 -- ModCodN
           Where ModTcli = 2
             and ModSuc = 0
             and ModCod = tipo;
        exception
          when no_data_found then
            null;
        end;
      end if;
    end if;

    begin
      select tastasa
        into tasa
        from (select tastasa
                from FSR427 t1, fsd427 t2
               where t1.tasemp = t2.tasemp
                 and t1.tasmod = t2.tasmod
                 and t1.taspiz = t2.taspiz
                 and t1.tascta = t2.tascta
                 and t1.tassop = t2.tassop
                 and t1.tasmda = t2.tasmda
                 and t1.taspap = t2.taspap
                 and t1.tasfdes = t2.tasfdes
                 and t1.tasmto = t2.tasmto
                 and t1.tasemp = vpgcod
                 and t1.tasmod = vscmod
                 and t1.taspiz = tipo
                 and t1.tascta = vsccta
                 and t1.tassop = vscsbop
                 and t1.tasmda = vscmda
                 and t2.tasvig = 'S'
               order by t1.tasfdes desc)
       where rownum = 1;
    exception
      when no_data_found then

        select scsdo
          into monto
          from fsd011
         where Pgcod = vpgcod
           and scmod = vscmod
           and scsuc = vscsuc
           and scmda = vscmda
           and scpap = vScpap
           and sccta = vsccta
           and scoper = vscoper
           and scsbop = vscsbop
           and sctope = vsctope
           and rownum = 1;

        select tatasa
          into tasa
          from (select a.tatasa
                  from fsr025 a, fsd025 b
                 Where a.pgcod = b.pgcod
                   and a.tamod = b.tamod
                   and a.tpizar = b.tpizar
                   and a.tamda = b.tamda
                   and a.tapap = b.tapap
                   and a.tafdes = b.tafdes
                   and a.tamto = b.tamto
                   and a.Pgcod = vpgcod
                   and a.Tamod = vscmod
                   and a.Tamda = vscmda -- moneda
                   and a.Tapap = vScpap
                   and a.Tpizar = tipo -- totpiz
                   and a.tamto >= monto
                 order by a.tafdes desc, a.tamto)
         where rownum = 1;
    end;
  else
    begin
      select Evtasa
        into tasa
        from (select Evtasa
                from fsd012 -- Evtasa
               Where Pgcod = vpgcod
                 and Aomod = vscmod
                 and Aosuc = vscsuc
                 and Aomda = vscmda
                 and Aopap = vScpap
                 and Aocta = vsccta
                 and Aooper = vscoper
                 and Aosbop = vscsbop
                 and Aotope = vsctope
                 and Evtipo = 3 --fijo interes
                 and D012co = 'S'
               order by D012fc desc)
       where rownum = 1; --fijo
    exception
      when no_data_found then
        -- si no encontré en fsd012 entonces nunca tuvo cambio tasa y busco en la fsd010

        select Aotasa
          into tasa
          from FSD010 -- Aotasa
         Where Pgcod = vpgcod
           and Aomod = vscmod
           and Aosuc = vscsuc
           and Aomda = vscmda
           and Aopap = vScpap
           and Aocta = vsccta
           and Aooper = vscoper
           and Aosbop = vScsbop
           and Aotope = vSctope;
    end;
  end if;

  Return tasa;
end;
/

