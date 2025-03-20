create or replace function ImporteEnLetras(vmontoaconvertir IN NUMBER) return varchar2 is
  vdigito number;
  vbandera number;
  vfila number;
  vmontoint number;
  vdescripcion varchar2(30);
  vbandmillon number;
  vbandmil number;
  vcentavos varchar(10);
  vdescimporte varchar(500);

begin
    select  floor(vmontoaconvertir)
    into vmontoint
    from dual;

     vdescimporte := '';

     vbandera := 0;
     vdigito := floor(vmontoint / 100000000);
     vbandmillon :=0;

    if  vdigito > 0 then

        vbandmillon :=1;
        vfila := floor(vdigito * 100);
        Select rtrim(descripcionnumero)
            into vdescripcion
            from numeros
            where codnumero = vfila;


        vdescimporte := vdescimporte || vdescripcion;
        vmontoint := vmontoint - (vdigito * 100000000);
        if  vmontoint >= 1000000 and vdigito = 1 then
             vdescimporte := vdescimporte||'to';
        end if;
    end if;--borrar luego



    vdigito := floor(vmontoint / 10000000);

    if  vdigito > 0 then

        vbandmillon:=1;
        if  vdigito = 1 or vdigito = 2 then

            vdigito := floor(vmontoint / 1000000);
            select   rtrim(descripcionnumero)
              into vdescripcion
              from numeros
              where codnumero = vdigito;

             vdescimporte := vdescimporte || ' ' || vdescripcion;
             vmontoint := (vmontoint - (vdigito * 1000000));
        else
             vbandera := 1;
             vfila := (vdigito * 10);
            select   rtrim(descripcionnumero)
              into vdescripcion
              from numeros
              where codnumero = vfila;

            vdescimporte := (vdescimporte || ' ' || vdescripcion);
             vmontoint := (vmontoint - (vdigito * 10000000));
        end if;
    end if;


    if  vmontoint >= 1000000
    then
        vdigito := floor(vmontoint / 1000000);

        if vdigito > 0
        then
            select rtrim(descripcionnumero)
              into vdescripcion
              from numeros
              where codnumero = vdigito;

            if  vbandera = 1
            then
                vdescimporte := vdescimporte || ' y ' || vdescripcion || ' Millones';
                vbandera := 0;
            else
                if  vdigito = 1 then
                    vdescimporte := (vdescimporte || ' ' || vdescripcion || ' Millon');
                else
                    vdescimporte := (vdescimporte || ' ' || vdescripcion || ' Millones');
                end if;
            end if;
            vmontoint := (vmontoint - (vdigito * 1000000));
        end if;
    elsif  vbandmillon=1 then
            vdescimporte := (vdescimporte || ' Millones');
    end if;

    vbandera := 0;
    vdigito := floor(vmontoint / 100000);
    vbandmil := 0;

    if  vdigito > 0
    then
        vbandmil:=1;
        vfila := (vdigito * 100);
        select  rtrim(descripcionnumero)
          into vdescripcion
          from numeros
          where codnumero = vfila;
        vdescimporte := (vdescimporte || ' ' || vdescripcion);
        vmontoint := (vmontoint - (vdigito * 100000));
        if  vmontoint >= 1000 and vdigito = 1 then
            vdescimporte := (vdescimporte || 'to');
        end if;
    end if;

    vdigito := floor(vmontoint / 10000);

    if  vdigito > 0
    then
        vbandmil:=1;
        if  vdigito = 1 or vdigito = 2
        then
            vdigito := floor(vmontoint / 1000);
            select rtrim(descripcionnumero)
              into vdescripcion
              from numeros
              where codnumero = vdigito;

            vdescimporte := (vdescimporte || ' ' || vdescripcion);
            vmontoint := (vmontoint - (vdigito * 1000));
        else
            vbandera := 1;
            vfila := (vdigito * 10);
            select   rtrim(descripcionnumero)
              into vdescripcion
              from numeros
              where codnumero = vfila;

            vdescimporte := (vdescimporte || ' ' || vdescripcion);
            vmontoint := (vmontoint - (vdigito * 10000));
        end if;
    end if;

    if  vmontoint >= 1000
    then
        vdigito := floor(vmontoint / 1000);

        if  vdigito > 0
        then
            select  rtrim(descripcionnumero)
              into vdescripcion
              from numeros
              where codnumero = vdigito;

            if  vbandera = 1
            then
                vdescimporte := (vdescimporte || ' y ' || vdescripcion || ' Mil');
                vbandera := 0;
            else
                vdescimporte := (vdescimporte || ' ' || vdescripcion || ' Mil');
            end if;

            vmontoint := (vmontoint - (vdigito * 1000));
        end if;
    elsif  vbandmil=1 then
         vdescimporte := (vdescimporte || ' Mil');
    end if;

    vbandera := 0;
    vdigito := floor(vmontoint / 100);

    if  vdigito > 0
    then
        vfila := (vdigito * 100);

        select  rtrim(descripcionnumero)
          into vdescripcion
          from numeros
          where codnumero = vfila;

        vdescimporte := (vdescimporte || ' ' || vdescripcion);
        vmontoint := (vmontoint - (vdigito * 100));
        if  vmontoint > 0 and vdigito = 1 then
            vdescimporte := (vdescimporte || 'to');
        end if;
    end if;

    vdigito := floor(vmontoint / 10);

    if vdigito > 0
    then
        if vdigito = 1 or vdigito = 2 then
            vdigito := floor(vmontoint / 1);
            select rtrim(descripcionnumero)
              into vdescripcion
              from numeros
              where codnumero = vdigito;

            vdescimporte := (vdescimporte || ' ' || vdescripcion);
            vmontoint := (vmontoint - (vdigito * 1));
        else
            vbandera := 1;
            vfila := (vdigito * 10);
            select rtrim(descripcionnumero)
              into vdescripcion
              from numeros
              where codnumero = vfila;

            vdescimporte := (vdescimporte || ' ' || vdescripcion);
            vmontoint := (vmontoint - (vdigito * 10));
        end if;
    end if;

    if  vmontoint >= 1
    then
        select rtrim(descripcionnumero)
          into vdescripcion
          from numeros
          where codnumero = vmontoint;

        if  vbandera = 1 then
            vdescimporte := (vdescimporte || ' y ' || vdescripcion);
        else
            vdescimporte := (vdescimporte || ' ' || vdescripcion);
        end if;

        if  vmontoint = 1 then
            vdescimporte := (vdescimporte || 'o');
        end if;
    end if;


    vdigito:=(vmontoaconvertir -  floor(vmontoaconvertir)) * 100;
    vcentavos:=round(vdigito);

    if vcentavos>0 then
      vdescimporte:= vdescimporte || ' con ' || vcentavos || ' Centavos';

    end if;
return(vdescimporte);
/*
*/
/*  select vleyenda='El equivalente en guaranies al cambio ' ||
              convert(varchar(20), vcambio) || ' es ' || convert(varchar(20), vmonto)*/

  return(vdescimporte);
end ImporteEnLetras;
/

