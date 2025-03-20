create or replace package "PQ_CR_SEGUROS_LINEAS_NUEVO" is
  -- *****************************************************************
  -- Nombre                     : pq_cr_seguros_lineas_nuevo
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 02/08/2023
  -- Autor de Creación          : ENINAH
  -- Uso                        : obtencion de datos seguros hoja resumen
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Modificacion               : SMARQUEZ 02/10/2024 Adicion de nuevas tasas
  -- Modificacion               : ENINAH 03/10/2024 Adicion de nueva variable en SP para linea adicional
  -- *****************************************************************

  ---------------------------------------------------------
  procedure obtener_datos_fijos(pn_inst in number,
                                --  pn_monto    in number,
                                pv_tasa      out varchar2,
                                pv_NOMBCOMP  OUT VARCHAR2,
                                pv_poliza    out varchar2,
                                pv_asegurado out varchar2,
                                pv_tasacupo  out varchar2);
  ------------------------------------------------------------

end pq_cr_seguros_lineas_nuevo;
 /* GOLDENGATE_DDL_REPLICATION */
/

create or replace package body pq_cr_seguros_lineas_nuevo is

  --------------------------------------------------------------------

  procedure obtener_datos_fijos(pn_inst in number,
                                --    pn_monto     in number,
                                pv_tasa      out varchar2,
                                pv_NOMBCOMP  OUT VARCHAR2,
                                pv_poliza    out varchar2,
                                pv_asegurado out varchar2,
                                pv_tasacupo  out varchar2) is
    /*****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.08.02
    -- Autor de Creación          : ENINA
    -- Uso                        : Retorna variables de datos hoja resumen lineas
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_inst (instancia)
    -- Parámetros de Salida       : pv_tasa (texto de la tasa)
                                  : pv_NOMBCOMP (nombre compañia )
                                  : pv_poliza (codigo de poliza )
                                  : pv_asegurado (nombre del asegurado)
    -- Modificacion               : SMARQUEZ 02/10/2024 Adicion de nuevas tasas
    -- Modificacion               : ENINAH 03/10/2024 Adicion de nueva variable en SP para linea adicional
    -- Modificacion               : ENINAH 02/12/2024 Adicionó TP1COD = 1 en la busqueda de guías para reducir costos
    ******************************************************************/

    DESCRIP1   varchar2(30);
    DESCRIP2   varchar2(30);
    DESCRIP3   varchar2(30);
    DESCRIP4   varchar2(30);
    DESCRIP11  varchar2(30);
    DESCRIP22  varchar2(30);
    --DESCRIP33  varchar2(30);
    --DESCRIP44  varchar2(30);
    ln_moneda  number(3);
    ln_monto   number(17, 2);
    ln_moneda2 number(3);
    ln_monto2  number(17, 2);
  begin
    /*calculo del asegurado */
    begin
      select p.penom
        into pv_asegurado
        from sng001 i, fsd001 p
       where i.sng001inst = pn_inst
         and p.pepais = i.sng001pais
         and p.petdoc = i.sng001tdoc
         and p.pendoc = i.sng001ndoc;

    exception
      when others then
        pv_asegurado := '';
    end;

    /*obtension de la poliza*/
    begin

      begin
        ---SMA obtencion de monto credito
        select t.xwfmoneda, t.xwfmonto1
          into ln_moneda, ln_monto
          from xwf700 t
         where t.xwfprcins = pn_inst
           and t.xwfcar3 = '1';

      exception
        when others then
          ln_moneda := null;
      end;

      -- ENINAH Moneda y Monto de crédito paralelo
      begin
        select t.xwfmoneda, t.xwfmonto1
          into ln_moneda2, ln_monto2
          from xwf700 t
         where t.xwfprcins = pn_inst
           and t.xwfcar3 = 'A'
           and rownum = 1;
      exception
        when others then
          ln_moneda2 := null;
      end;
-----------------------------------------------------------------------------------------------------------
      begin
        select g.tpdesc
          into pv_poliza
          from fst098 g
         Where g.tpcorr = decode(ln_moneda, 0, 1, 101, 2, -1)
           and g.Pgcod = 4
           and g.Tpcod = 7665;

      exception
        when others then
          pv_poliza := '';
      end;

    exception
      when others then
        null;
    end;

    /*obtension */

    /* begin
      select TP1DESC
        into DESCRIP1
        from fst198
       Where TP1COD1 = 11169
         and TP1CORR1 = 5
         and TP1CORR2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        null;
    end;*/
    -------------------------------------------------------------SMA 02/10/2024
    if ln_moneda = 0 then
      if ln_monto > 100000 then
        select TP1DESC
          into DESCRIP1
          from fst198
         Where TP1COD = 1 --eninah 02/12/2024
           and TP1COD1 = 11169
           and TP1CORR1 = 5
           and TP1CORR2 = 2
           and tp1corr3 = 4;
      else
        begin
          select TP1DESC
            into DESCRIP1
            from fst198
           Where TP1COD = 1  --eninah 02/12/2024
             and TP1COD1 = 11169
             and TP1CORR1 = 5
             and TP1CORR2 = 2
             and tp1nro1 <= ln_monto
             and tp1nro2 >= ln_monto;
        exception
          when others then
            null;
        end;
      end if;
    else
      --dolares
      if ln_monto > 35000 then
        select TP1DESC
          into DESCRIP1
          from fst198
         Where TP1COD = 1
           and TP1COD1 = 11169
           and TP1CORR1 = 5
           and TP1CORR2 = 2
           and tp1corr3 = 4;
      else
        begin
          select TP1DESC
            into DESCRIP1
            from fst198
           Where TP1COD = 1 --eninah 02/12/2024
             and TP1COD1 = 11169
             and TP1CORR1 = 5
             and TP1CORR2 = 2
             and TP1IMP1 <= ln_monto
             and TP1IMP2 >= ln_monto;
        exception
          when others then
            null;
        end;
      end if;
    end if;
    ---------------------------------------------------------------------------
    begin
      select TP1DESC
        into DESCRIP2
        from fst198
       Where TP1COD = 1 --eninah 02/12/2024
         and TP1COD1 = 11169
         and TP1CORR1 = 5
         and TP1CORR2 = 1
         and tp1corr3 = 2;
    exception
      when others then
        null;
    end;

    --TEXTO PARA LA TASA
    pv_tasa := SUBSTR(TRIM(DESCRIP1) || ' ' || TRIM(DESCRIP2), 1, 40);

    --------------------------------------------------------------------ENINAH 03/10/2024
    if ln_moneda2 = 0 then
      if ln_monto2 > 100000 then
        select TP1DESC
          into DESCRIP11
          from fst198
         Where TP1COD = 1 --eninah 02/12/2024
           and TP1COD1 = 11169
           and TP1CORR1 = 5
           and TP1CORR2 = 2
           and tp1corr3 = 4;
      else
        begin
          select TP1DESC
            into DESCRIP11
            from fst198
           Where TP1COD = 1 --eninah 02/12/2024
             and TP1COD1 = 11169
             and TP1CORR1 = 5
             and TP1CORR2 = 2
             and tp1nro1 <= ln_monto2
             and tp1nro2 >= ln_monto2;
        exception
          when others then
            null;
        end;
      end if;
    else
      --dolares
      if ln_monto2 > 35000 then
        select TP1DESC
          into DESCRIP11
          from fst198
         Where TP1COD = 1 --eninah 02/12/2024
           and TP1COD1 = 11169
           and TP1CORR1 = 5
           and TP1CORR2 = 2
           and tp1corr3 = 4;
      else
        begin
          select TP1DESC
            into DESCRIP11
            from fst198
           Where TP1COD = 1 --eninah 02/12/2024
             and TP1COD1 = 11169
             and TP1CORR1 = 5
             and TP1CORR2 = 2
             and TP1IMP1 <= ln_monto2
             and TP1IMP2 >= ln_monto2;
        exception
          when others then
            null;
        end;
      end if;
    end if;
    ---------------------------------------------------------------------------
    begin
      select TP1DESC
        into DESCRIP22
        from fst198
       Where TP1COD = 1 --eninah 02/12/2024
         and TP1COD1 = 11169
         and TP1CORR1 = 5
         and TP1CORR2 = 1
         and tp1corr3 = 2;
    exception
      when others then
        null;
    end;

    --TEXTO PARA LA TASA
    pv_tasacupo := SUBSTR(TRIM(DESCRIP11) || ' ' || TRIM(DESCRIP22), 1, 40);
    -----------------------------------------------------------------------------------------------------
    begin
      select TP1DESC
        into DESCRIP3
        from fst198
       Where TP1COD = 1 --eninah 02/12/2024
         and TP1COD1 = 11169
         and TP1CORR1 = 5
         and TP1CORR2 = 1
         and tp1corr3 = 3;
    exception
      when others then
        null;
    end;

    begin
      select TP1DESC
        into DESCRIP4
        from fst198
       Where TP1COD = 1 --eninah 02/12/2024
         and TP1COD1 = 11169
         and TP1CORR1 = 5
         and TP1CORR2 = 1
         and tp1corr3 = 4;
    exception
      when others then
        null;
    end;

    pv_NOMBCOMP := SUBSTR(TRIM(DESCRIP3) || ' ' || TRIM(DESCRIP4), 1, 40);

  exception
    when others then
      pv_tasa     := null;
      pv_NOMBCOMP := null;

  end obtener_datos_fijos;
  ----------------------------------------------------------------------------------

end pq_cr_seguros_lineas_nuevo;
/

