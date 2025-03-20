create or replace procedure SP_CR_SBSAVALADOS(p_documento in varchar2,
                                              p_TipoDoc   in number,
                                              p_usuario   in varchar2,
                                              p_flag      out varchar2) is
-----------------------------------------------------------------------
-- Fecha Modificación : 09/01/2020
-- Modificacion       : Adición de Excepciones por falta de informacion
--                      en las tablas de la RCA
-- Autor              : Silvia Marquez Avendaño

------------------------------------------------------------------------


  cursor dos(secuencia in varchar2, fecha in date) is
    select *
      from criesgos.CLDRCAS ----crdava2 D_FECPRE, N_TIPREG, N_SECUEN
     where d_fecpre = fecha
       and n_tipreg = 2
       and n_secuen = secuencia
       and c_codavd is not null; ---sma.13032020

  nombre     varchar2(120);
  secuenciaN number := 0;
  entidad    varchar(40);
  saldo      number(17, 2);
  calif      char(20);
  flag1      varchar2(1) := 'N';
  fecha      date;
  tipdoc     varchar2(30);
  tipdoc1    varchar2(30);
  persona    varchar2(20);
  --tipo varchar2(12);
  codigo  varchar2(20);
  avalado varchar2(150);
  docaval varchar2(12);
begin

  delete jaqz581 where jaqz581doc = p_documento; -- sma 3/12/2019 and jaqz581usu = p_usuario;
  commit;
  begin
    select to_date(tpnro, 'dd/mm/yyyy')
      into fecha
      from fst098
     where pgcod = 1
       and tpcod = 7647
       and tpcorr = 16;
  exception
    when no_data_found then
      fecha := null;
  end;

  if p_TipoDoc = 21 then
    Begin
      select trim(c_nomavc) aval,
             n_secuen,
             Decode(c_tidoid,
                    '1',
                    'DNI',
                    '2',
                    'Carné Extranjetia',
                    '5',
                    'Pasaporte'),
             c_codava
        into nombre, secuenciaN, tipdoc, codigo
        from CRIESGOS.CLDRCAI --criesgos.crdava1
       where d_fecpre = fecha
         and c_tidoid IN ('1', '2', '5')
         and c_nrodoi = p_documento
         and n_tipreg = 1; ---'29716443';

    exception
      when no_data_found then
        nombre := null;
        codigo := null;
    end;
  else
    Begin
      select trim(c_nomavc) aval, n_secuen, 'RUC', c_codava
        into nombre, secuenciaN, tipdoc, codigo
        from criesgos.CLDRCAI ---D_FECPRE, C_TIDOTR, C_NRORUC
       where d_fecpre = fecha
         and c_tidotr = '3'
         and c_nroruc = p_documento
         and n_tipreg = 1;
    exception
      when no_data_found then
        nombre := null;
        codigo := null;
    end;
  end if;
  if (nombre like '%XXXX%')  or (nombre is null) then
    Begin
      select c_nomdeu
        into nombre
        from criesgos.cldrcci
       where c_codsbs = codigo
         and rownum = 1;
    exception
      when no_data_found then
        nombre := null;
    end;
  end if;

  if nombre is not null then
    for reg in dos(secuenciaN, fecha) loop
      saldo := reg.n_saldo;

      case reg.c_calif
        when 0 then
          calif := 'Normal';
        when 1 then
          calif := 'CPP'; -- con problemas potenciales (cpp)
        when 2 then
          calif := 'Deficiente';
        when 3 then
          calif := 'Dudoso';
        when 4 then
          calif := 'Pérdida';
       else
          calif := 'Sin Calificación';
      end case;

      if reg.c_tidotr is null then
        case reg.c_tidoid
          when 1 then
            tipdoc1 := 'DNI';
          when 2 then
            tipdoc1 := 'Carné Extranjetia';
          when 5 then
            tipdoc1 := 'Pasaporte';
          else
            tipdoc1 := 'Sin Documento';
        end case;
        docaval := reg.c_nrodoi;
      else
        tipdoc1 := 'RUC';
        docaval := reg.c_nroruc;
      end if;

      case reg.c_tipper
        when 1 then
          Persona := 'P.Natural';
        when 2 then
          Persona := 'P.Jurídica';
        when 3 then
          Persona := 'P.Mancomunadas';
        else
          Persona := 'Otro';
      end case;

      avalado := trim(reg.c_nomavd);

      begin
        select tp1desc
          into entidad
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10849
           and tp1corr1 = 10
           and tp1nro1 = reg.c_codemp;
      exception
        when no_data_found then
          entidad := 'Sin Descripcion';
      end;
      if codigo is null then
         codigo := '0000000000';
      end if;
      if docaval is null then --sma 090120
        docaval:= 'Sin Dato';
      end if;
      BEGIN
        INSERT INTO JAQZ581
          (jaqz581doc,
           jaqz581tdoc,
           jaqz581csbs,
           jaqz581docav,
           jaqz581tdocav,
           jaqz581csbsav,
           jaqz581au2, --jaqz581nroe,
           jaqz581nom,
           jaqz581nome,
           jaqz581nomav,
           jaqz581cali,
           jaqz581tipp,
           jaqz581usu,
           jaqz581fecha)
        VALUES
          (p_documento,
           tipdoc,
           codigo,
           docaval,
           tipdoc1,
           reg.c_codavd,
           reg.n_saldo,
           nombre,
           entidad,
           avalado,
           calif,
           persona,
           p_usuario,
           fecha);
        COMMIT;
      EXCEPTION
        when dup_Val_on_index then
          null;
      END;

      flag1 := 'S';

    end loop;
  end if;
  p_flag := flag1;

end sp_cr_sbsavalados;
/

