create or replace procedure Fecha_Antig(vpgcod  number,
                        vpepais number,
                        vpetdoc number,
                        vpendoc char,
                        --vtipo   number,
                        vFecAnt out date) is

    vFecAnt_ah date;
    vFecAnt_pf date;

--       Primero busca en la table donde se guarda cada día a los clients nuevos
  begin
    select JAQL106Fhc
      into vFecAnt
      from jaql106
     Where JAQL106Pai = vPepais
       and JAQL106Tdo = vPetdoc
       and JAQL106Doc = vPendoc;
    --       and JAQL106A01 = vtipo;
  exception
    when no_data_found then 
    -- si el proceso falla por aglo entonces busco cual fue la fecha mas Antigua de aperture de sus productos pasivos
      begin
        select min(Scfval)
          into vFecAnt_ah
          from fsd011 x, fsr008 y
         where x.pgcod = vpgcod
           and x.sccta = y.ctnro
           and y.Ttcod = 1
           and x.scmod = 21
           and y.pepais = vpepais
           and y.petdoc = vpetdoc
           and y.pendoc = vpendoc /*
                   and x.scstat <> 99*/
        ;
      exception
        when others then
          vFecAnt_ah := null;
      end;

      begin
        select min(aofval)
          into vFecAnt_pf
          from fsd010 x, fsr008 y
         where x.pgcod = vpgcod
           and x.aocta = y.ctnro
           and y.Ttcod = 1
           and x.aomod = 22
           and y.pepais = vpepais
           and y.petdoc = vpetdoc
           and y.pendoc = vpendoc;
      exception
        when others then
          vFecAnt_pf := null;
      end;

      if vFecAnt_ah is not null then
        if vFecAnt_pf is not null then
          if vFecAnt_ah < vFecAnt_pf then
            vFecAnt := vFecAnt_ah;
          else
            vFecAnt := vFecAnt_pf;
          end if;
        else
          vFecAnt := vFecAnt_ah;
        end if;
      else
        vFecAnt := vFecAnt_pf;
      end if;

      If vFecAnt = to_date('01/01/0001', 'dd/mm/yyyy') or vFecAnt is null then -- en caso extreme de q no encuentre nada recién le pongo como fecha aquella en que se creo al cliente
        begin
          select Pefalt
            into vFecAnt
            from FSD001
           Where Pepais = vPepais
             and Petdoc = vPetdoc
             and Pendoc = vPendoc;
        exception
          when no_data_found then
            vFecAnt := trunc(sysdate);
        end;
      End if;
  End;
/

