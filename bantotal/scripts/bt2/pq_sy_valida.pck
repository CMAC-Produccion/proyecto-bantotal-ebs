create or replace package pq_sy_valida is

  -- **************************************************************************************************************************
  -- Nombre                     : PQ_SY_VALIDA
  -- Sistema                    : TRANSFERENCIA ERP
  -- Módulo                     : Sistema
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2014.06.07
  -- Autor de Creación          : José Salas
  -- Uso                        : Validación de cuentas bancaria BANTOTAL y obtención de cuenta cliente BANTOTAL
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2014.08.02
  -- Autor de Modificación      : JSALASV
  -- Descripción de Modificación: Se corrigio exception TOO_MANY_ROWS cuando busca cuenta cliente y devuelve NULL
  -- **************************************************************************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_sy_valida_cuenta(P_C_NUMCTA in varchar2,
                                p_n_ctacli out number,
                                p_c_coderr out varchar2,
                                p_c_msgerr out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_sy_obtener_cuentacliente(P_N_TIPDOC in number,
                                       P_C_NUMDOC in varchar2)
    return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end pq_sy_valida;
/

create or replace package body pq_sy_valida is

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_sy_valida_cuenta(P_C_NUMCTA in varchar2,
                                p_n_ctacli out number,
                                p_c_coderr out varchar2,
                                p_c_msgerr out varchar2) is
    -- *********************************************************************************************************************
    -- Nombre                     : SP_SY_VALIDA_CUENTA
    -- Sistema                    : TRANSFERENCIA ERP
    -- Módulo                     : Cuentas por Pagar
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.06.19
    -- Autor de Creación          : José Salas
    -- Uso                        : Validar cuenta bancaria en BANTOTAL
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_C_NUMCTA (NUMERO DE CUENTA BANCARIA)
    -- Parámetros de Salida       : p_n_ctacli (Cuenta cliente BANTOTAL)
    --                              p_c_coderr (Código de error)
    --                              p_c_msgerr (Mensaje de error)
    -- Fecha de modificación      :
    -- Autor de Modificación      :
    -- Descripción de Modificación:
    -- *********************************************************************************************************************
    ln_sccta  number(10);
    ln_scmod  number(10);
    ln_scmda  number(10);
    ln_scsbop number(10);
    ln_sctope number(10);
    ln_scstat number(10);

  begin

    if length(P_C_NUMCTA) = 20 then

      ln_sccta  := substr(P_C_NUMCTA, 1, 9);
      ln_scmod  := substr(P_C_NUMCTA, 10, 3);
      ln_scmda  := substr(P_C_NUMCTA, 13, 3);
      ln_scsbop := substr(P_C_NUMCTA, 16, 2);
      ln_sctope := substr(P_C_NUMCTA, 18, 3);

      case
        when ln_sctope = 6 then

          p_c_coderr := '01';
          p_c_msgerr := 'CUENTA BANCARIA ES DE REMUNERACIONES.';

        when ln_sctope = 2 then

          p_c_coderr := '02';
          p_c_msgerr := 'CUENTA BANCARIA ES CTS.';

        else

          begin
            select scstat
              into ln_scstat
              from fsd011 a
             where a.pgcod = 1
               and a.sccta = ln_sccta
               and a.scmod = ln_scmod
               and a.scmda = ln_scmda
               and a.scsbop = ln_scsbop
               and a.sctope = ln_sctope;

            if ln_scstat = 81 then

              p_c_coderr := '03';
              p_c_msgerr := 'CUENTA BANCARIA SE CUENTRA INACTIVA.';

            elsif ln_scstat = 6 then

              p_c_coderr := '04';
              p_c_msgerr := 'CUENTA BANCARIA SE ENCUENTRA BLOQUEADA.';

            elsif ln_scstat = 99 then

              p_c_coderr := '05';
              p_c_msgerr := 'CUENTA BANCARIA SE ENCUENTRA CANCELADA.';

            else

              p_n_ctacli := ln_sccta;
              p_c_coderr := null;
              p_c_msgerr := null;

            end if;

          exception
            when no_data_found then

              p_c_coderr := '06';
              p_c_msgerr := 'CUENTA BANCARIA NO EXISTE.';

          end;
      end case;

    else

      p_c_coderr := '07';
      p_c_msgerr := 'CUENTA BANCARIA NO ES DE AHORROS MOVIL.';

    end if;

  end;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_sy_obtener_cuentacliente(P_N_TIPDOC in number,
                                       P_C_NUMDOC in varchar2)
  -- *********************************************************************************************************************
    -- Nombre                     : FN_SY_OBTENER_CUENTACLIENTE
    -- Sistema                    : TRANSFERENCIA ERP
    -- Módulo                     : Cuentas por Pagar
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.06.19
    -- Autor de Creación          : José Salas
    -- Uso                        : Obtner cuenta cliente BANTOTAL
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_TIPDOC (TIPO DE DOCUMENTO 21:DNI 9: RUC)
    --                              P_C_NUMDOC (NUMERO DE DOCUMENTO)
    -- Retorno                    : Cuenta cliente BANTOTAL (0: No existe cuenta cliente)
    -- Fecha de modificación      : 2020.12.17
    -- Autor de Modificación      : DCASTRO
    -- Descripción de Modificación: Se agrego excepcion when others
    -- *********************************************************************************************************************

   return varchar2 is

    ln_Pfpais number(10) := 604;
    ln_ctnro  number(9);
    ln_tipdoc number(10);
    lc_numdoc char(12);

  begin

    lc_numdoc := P_C_NUMDOC;

    if P_N_TIPDOC = 21 then

      begin
        select a.ctnro
          into ln_ctnro
          from fsr008 a, Fsd011 b
         Where a.Pgcod = 1
           and a.Pepais = ln_Pfpais
           and a.Petdoc = P_N_TIPDOC
           and a.Pendoc = lc_numdoc
           and a.Cttfir = 'T'
           and b.Pgcod = 1
           and b.Sccta = a.ctnro
           and b.Scmod = P_N_TIPDOC
           and b.Sctope = 6
           and b.Scstat <> 99;
      exception
        when no_data_found then
              begin
                select ctnro
                  into ln_ctnro
                  from fsr008
                 where ctnro in (select a.ctnro
                                   from Fsr008 a
                                  Where Pgcod = 1
                                    and Pepais = ln_Pfpais
                                    and Petdoc = P_N_TIPDOC
                                    and Pendoc = lc_numdoc
                                    and Cttfir = 'T')
                 group by ctnro
                having count(*) = 1;

              exception
                when no_data_found then
                  ln_ctnro := null;
              end;
        when too_many_rows then

          select a.ctnro
            into ln_ctnro
            from fsr008 a, Fsd011 b
           Where a.Pgcod = 1
             and a.Pepais = ln_Pfpais
             and a.Petdoc = P_N_TIPDOC
             and a.Pendoc = lc_numdoc
             and a.Cttfir = 'T'
             and b.Pgcod = 1
             and b.Sccta = a.ctnro
             and b.Scmod = P_N_TIPDOC
             and b.Sctope = 6
             and b.Scstat <> 99
             and rownum = 1;

      end;

    else

      begin
        /*select ctnro
          into ln_ctnro
          from fsr008
         where ctnro in (select a.ctnro
                           from Fsr008 a
                          Where Pgcod = 1
                            and Pepais = ln_Pfpais
                            and Petdoc = P_N_TIPDOC
                            and Pendoc = lc_numdoc
                            and Cttfir = 'T')
         group by ctnro
        having count(*) = 1;*/
         select  a.ctnro
           into ln_ctnro
           from Fsr008 a
          Where Pgcod = 1
            and Pepais = ln_Pfpais
            and Petdoc = P_N_TIPDOC
            and Pendoc = lc_numdoc
            and Cttfir = 'T';
      exception
        when no_data_found then
          begin
            select DocTdoc, DocNdoc
              into ln_tipdoc, lc_numdoc
              from fsr001
             where DocPais1 = ln_Pfpais
               and Tdocum = P_N_TIPDOC
               and DocNdoc1 = lc_numdoc;
          exception
            when no_data_found then
              ln_ctnro := null;
            when too_many_rows then
              begin            --- 2020.12.17
                select DocTdoc, DocNdoc
                  into ln_tipdoc, lc_numdoc
                  from fsr001
                 where DocPais1 = ln_Pfpais
                   and Tdocum = P_N_TIPDOC
                   and DocNdoc1 = lc_numdoc
                   and rownum = 1;
              exception when others then --- 2020.12.17
                    ln_ctnro := null;
              end; ---
          end;
          begin
            /*select ctnro
              into ln_ctnro
              from fsr008
             where ctnro in (select a.ctnro
                               from Fsr008 a
                              Where Pgcod = 1
                                and Pepais = ln_Pfpais
                                and Petdoc = ln_tipdoc
                                and Pendoc = lc_numdoc
                                and Cttfir = 'T')
             group by ctnro
            having count(*) = 1;*/
             select a.ctnro
               into ln_ctnro
               from Fsr008 a
              Where Pgcod = 1
                and Pepais = ln_Pfpais
                and Petdoc = ln_tipdoc
                and Pendoc = lc_numdoc
                and Cttfir = 'T'
                and rownum = 1;
          exception
            when no_data_found then
              ln_ctnro := null;
          end;

        when too_many_rows then
          begin            --- 2020.12.17
           select a.ctnro
             into ln_ctnro
             from Fsr008 a
            Where Pgcod = 1
              and Pepais = ln_Pfpais
              and Petdoc = P_N_TIPDOC
              and Pendoc = lc_numdoc
              and Cttfir = 'T'
              and rownum = 1;
          exception when others then --- 2020.12.17
                  ln_ctnro := null;
            end; ---
      end;
    end if;

    return(ln_ctnro);

  end;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end pq_sy_valida;
/

