create or replace procedure SP_AH_INST_BLOQ(pn_pgcod  number,
                                            pn_scsuc  number,
                                            pn_scmda  number,
                                            pn_scpap  number,
                                            pn_sccta  number,
                                            pn_scoper number,
                                            pn_scsbop number,
                                            pn_sctope number,
                                            pn_scmod  number,
                                            pn_canbat out number,
                                            pc_resul  out varchar2) is

  vn_inspre number(1);
  Pcuenta   number(9);
  Poperac   number(9);
  Psubope   number(3);
  Ptipope   number(3);
  documentos char(12);
  producto   char(200);
  cursor rubro is
    select *
      from fsd014 y, fst198 d
     where y.Rubro = case
             when pn_scmda = 0 then
              d.tp1imp1
             else
              d.tp1imp2
           end
       and d.tp1cod = pn_pgcod
       and d.tp1cod1 = 10816
       and d.tp1corr1 = 10
       and d.tp1corr2 = 3;
   CURSOR SEGUROS (NUMDOC  IN CHAR) IS
     select * from v_certificados
       where DOCUMENTO = NUMDOC;

 cuenta varchar2(9);
begin

  pc_resul := '';

  --------- Instrucciones ----------

  begin
    select 'Instruccion asociada ' || trim(d.tp1desc), d.tp1imp3
      into pc_resul, pn_canbat
      from fsr111 a, fst198 d
     where i1cod = pn_pgcod
       and exists (select 1
              from fsd011 b
             where a.i1cod = b.pgcod
               and a.i1mod = b.scmod
               and a.i1suc = b.scsuc
               and a.i1mda = b.scmda
               and a.i1pap = b.scpap
               and a.i1cta = b.sccta
               and a.i1oper = b.scoper
               and a.i1sbop = b.scsbop
               and a.i1tope = b.sctope
               and b.scstat <> 99
               and b.scsdo > case
                     when scmod = 19 then
                      0
                     else
                      -999999
                   end)
       and exists (select 1
              from fsd011 c
             where a.i2cod = c.pgcod
                  --and a.i2mod = c.scmod
               and a.i2suc = c.scsuc
               and a.i2mda = c.scmda
               and a.i2pap = c.scpap
               and a.i2cta = c.sccta
                  --and a.i2oper = c.scoper
               and a.i2sbop = c.scsbop
                  --and a.i2tope = c.sctope
               and c.pgcod = pn_pgcod
               and c.scsuc = pn_scsuc
               and c.scmda = pn_scmda
               and c.scpap = pn_scpap
               and c.sccta = pn_sccta
               and c.scsbop = pn_scsbop
               and c.scmod = pn_scmod
               and c.sctope = pn_sctope
               and c.scoper = pn_scoper
               and c.scstat <> 99)
       and d.tp1cod = pn_pgcod
       and d.tp1cod1 = 10816
       and d.tp1corr1 = 10
       and d.tp1corr2 = 1
       and a.r111co = 'S'
       and a.inscod = d.tp1nro1;
  exception
    when no_data_found then
      pc_resul := '';
    when too_many_rows then
      pc_resul := 'La cuenta tiene instrucciones asociadas';
  end;

  --------- Cobro de préstamo ----------
  If pc_resul is not null then
    return;
  else
    begin
      select tp1nro1, d.tp1imp3
        into vn_inspre, pn_canbat
        from fst198 d
       where d.tp1cod = pn_pgcod
         and d.tp1cod1 = 10816
         and d.tp1corr1 = 10
         and d.tp1corr2 = 2;
    exception
      when others then
        vn_inspre := 0;
    end;

    if vn_inspre = 1 then
      begin
        select 'Instruccion asociada Cobro de prestamo'
          into pc_resul
          from fsr601 x
         where exists (select 1
                  from fsd011 b
                 where pp3cod = pgcod
                   and pp3mod = scmod
                   and pp3suc = scsuc
                   and pp3mda = scmda
                   and pp3pap = scpap
                   and pp3cta = sccta
                   and pp3oper = scoper
                   and pp3sbop = scsbop
                   and pp3tope = sctope
                   and scstat <> 99)
           and pp4cod = pn_pgcod
           and pp4mod = pn_scmod
           and pp4suc = pn_scsuc
           and pp4mda = pn_scmda
           and pp4pap = pn_scpap
           and pp4cta = pn_sccta
           and pp4oper = pn_scoper
           and pp4sbop = pn_scsbop
           and pp4tope = pn_sctope;
      exception
        when no_data_found then
          pc_resul := '';
        when too_many_rows then
          pc_resul := 'Instruccion asociada Cobro de prestamo';
      end;
    end if;
  end if;

  --------- Rubros ----------
  If pc_resul is not null then
    return;
  else

    for i in rubro loop
      pn_canbat := i.tp1imp3;

      If i.Pccta = 'S' then
        Pcuenta := pn_sccta;
      Else
        Pcuenta := 0;
      End If;

      If i.Pcoper = 'S' then
        Poperac := pn_scoper;
      Else
        Poperac := 0;
      End If;

      If i.Pcsbop = 'S' then
        Psubope := pn_scsbop;
      Else
        Psubope := 0;
      End If;

      Ptipope := 0;

      If i.Pcrdec = 999 then
        Ptipope := pn_sctope;
      Else
        begin
          select Totope
            into Ptipope
            from FST004
           Where Modulo = i.Pcnivc
             and Totope = pn_sctope;
        exception
          when others then
            Ptipope := 0;
        end;
      End If;

      begin
        select 'Pendiente ' || trim(i.tp1desc)
          into pc_resul
          from fsd011 b
         where pgcod = pn_pgcod
           and scrub = i.rubro
           and scsuc = pn_scsuc
           and scmda = pn_scmda
           and scpap = pn_scpap
           and sccta = pn_sccta
           and scoper = Poperac
           and scsbop = Psubope
           and sctope = Ptipope
           and scstat <> 99
           and scsdo <> 0;
      exception
        when no_data_found then
          pc_resul := '';
        when too_many_rows then
          pc_resul := 'La cuenta tiene pendientes';
      end;


      If pc_resul is not null then
        exit;
      end if;


    end loop;

  end if;

end SP_AH_INST_BLOQ;
/

