create or replace package PQ_CR_RT_REPROGRAMACION is

  -- Author  : RMONTESR
  -- Created : 3/02/2021 16:22:22
  -- Purpose :

  procedure sp_cr_existe_credito_crm(ln_Instancia     in number,
                                     lc_existecredito out char);

  procedure sp_cr_tiene_seguro(ln_Instancia     in number,
                               lc_tiene_segdes  out char,
                               lc_tiene_segvc   out char,
                               lc_tiene_segveh  out char,
                               lc_tiene_segasis out char,
                               lc_tiene_segmpy  out char,
                               lc_tiene_segmga  out char,
                               lc_verif_seg     out char);

end PQ_CR_RT_REPROGRAMACION;
/

create or replace package body PQ_CR_RT_REPROGRAMACION is
   -- *****************************************************************
    -- Nombre                     : PAQUETES VERIFICACION REPROGRAMACIONES
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 3/02/2021 16:22:22
    -- Autor de Creación          : RMONTESR
    -- Uso                        : Realiza VALIDACIONES
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Modificacion               : ACTUALIZACION CONSULTSAS ADICIOCN DE SUCURSAL
    -- Autor Modificacion         : Silvia MArquez
    -- Fecha Modificación         : 2024.03.06
    -- Modificacion               : ACTUALIZACION ADICIOCN MULTIRIESGO PYME/GARANTIA
    -- Autor Modificacion         : Silvia MArquez
    -- Fecha Modificación         : 2024.03.11
    -- Modificacion               : SMARQUEZ 31/01/2025 MODIFICACION CONTROL DE SEGURO DUPLICADO LINEA 631
    -- *****************************************************************


  procedure sp_cr_existe_credito_crm(ln_Instancia     in number,
                                     lc_existecredito out char) is

    ln_pgcod        number;
    ln_sucursal     number;
    ln_modulo       number;
    ln_moneda       number;
    ln_papel        number;
    ln_cuenta       number;
    ln_operacion    number;
    ln_suboperacion number;
    ln_tipoper      number;
    ln_creditoscrm  number;
    ln_creditoscrm2 number;
    ln_creditoscrmc number;
    ln_creditoscrmF number;
    ln_creditoscrmBI number;

  begin
    begin

      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into ln_pgcod,
             ln_sucursal,
             ln_modulo,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_suboperacion,
             ln_tipoper
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
    begin
      select count(*)
        into ln_creditoscrm2
        from (SELECT F.NUEVATASA, f.*
                FROM LEY31050 L
               INNER JOIN LEY31050_CREDITOSFACILIDAD F
                  ON L.IDLEY31050 = F.IDLEY31050
               WHERE L.ESTADOSOLICITUD = 'BT'
                 AND L.TIPOFACILIDAD = 'GOBIERNO'
                 AND SUBSTR(F.CUENTAOPERACION,
                            0,
                            INSTR(F.CUENTAOPERACION, '-') - 1) = ln_cuenta
                 AND SUBSTR(F.CUENTAOPERACION,
                            INSTR(F.CUENTAOPERACION, '-') + 1,
                            99) = ln_operacion
                 AND F.EMPRESA = ln_pgcod
                 AND F.SUCURSAL = ln_sucursal
                 AND F.MODULO = ln_modulo
                 AND F.MONEDA = ln_moneda
                 AND F.PAPEL = ln_papel
                 AND F.SUBOPERACION = ln_suboperacion
                 AND F.TIPOOPERACION = ln_tipoper) t;
    exception
      when others then
        ln_creditoscrm2 := 0;
    end;

    begin
      select count(*)
        into ln_creditoscrmc
        from (SELECT F.NUEVATASA, f.*
                FROM LEY31050 L
               INNER JOIN LEY31050_CREDITOSFACILIDAD F
                  ON L.IDLEY31050 = F.IDLEY31050
               WHERE L.ESTADOSOLICITUD = 'BT'
                 AND L.TIPOFACILIDAD = 'CAJA'
                 AND SUBSTR(F.CUENTAOPERACION,
                            0,
                            INSTR(F.CUENTAOPERACION, '-') - 1) = ln_cuenta
                 AND SUBSTR(F.CUENTAOPERACION,
                            INSTR(F.CUENTAOPERACION, '-') + 1,
                            99) = ln_operacion
                 AND F.EMPRESA = ln_pgcod
                 AND F.SUCURSAL = ln_sucursal
                 AND F.MODULO = ln_modulo
                 AND F.MONEDA = ln_moneda
                 AND F.PAPEL = ln_papel
                 AND F.SUBOPERACION = ln_suboperacion
                 AND F.TIPOOPERACION = ln_tipoper) t;
    exception
      when others then
        ln_creditoscrmc := 0;
    end;

    begin
      select count(*)
        into ln_creditoscrm
        from (select *
                FROM /*USRWEBCRM.*/ REPROG L
               WHERE L.ESTADOSOLICITUD = 'BT'
                 AND SUBSTR(L.CUENTAOPERACION,
                            0,
                            INSTR(L.CUENTAOPERACION, '-') - 1) = ln_cuenta
                 AND SUBSTR(L.CUENTAOPERACION,
                            INSTR(L.CUENTAOPERACION, '-') + 1,
                            99) = ln_operacion) t;
    exception
      when others then
        ln_creditoscrm := 0;
    end;

    --08/07/2021 DCASTRO
    BEGIN
      SELECT count(*)
        into ln_creditoscrmF
        FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
       WHERE F.IDFONDO = G.IDFONDO
         AND G.ESTADOSOLICITUD = 'BT'
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             ln_cuenta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = ln_operacion
         AND F.EMPRESA = ln_pgcod
         AND F.SUCURSAL = ln_sucursal
         AND F.MODULO = ln_modulo
         AND F.MONEDA = ln_moneda
         AND F.PAPEL = ln_papel
         AND F.SUBOPERACION = ln_suboperacion
         AND F.TIPOOPERACION = ln_tipoper;
    exception
      when others then
        ln_creditoscrmF := 0;
    END;
    --FIN 08/07/2021 DCASTRO

    --apachecoh 2023.09.28
    begin
      SELECT count(*)
        into ln_creditoscrmBI
        FROM AQPC952 B
       WHERE B.AQPC952FECC = (SELECT MAX(AQPC952FECC) FROM AQPC952)
         AND B.AQPC952HORC =
             (SELECT MAX(AQPC952HORC)
                FROM AQPC952
               WHERE AQPC952FECC = (SELECT MAX(AQPC952FECC) FROM AQPC952))
         AND B.AQPC952CTA = ln_cuenta
         AND B.AQPC952OPER = ln_operacion;
      /*SELECT count(*)
             into ln_creditoscrmBI
      FROM USRREPBI.REP_308_REPROGRAMACIONES_VENCIDOS B
     WHERE B.BCCTA = ln_cuenta
       AND B.BCOPER = ln_operacion;   */
    exception
      when others then
        ln_creditoscrmBI := 0;
    END;
    --apachecoh 2023.09.28

    if ln_creditoscrm > 0 or ln_creditoscrm2 > 0 or ln_creditoscrmF > 0 or
       ln_creditoscrmc > 0 or ln_creditoscrmBI > 0 then
      lc_existecredito := 'S';
    else
      lc_existecredito := 'N';
    end if;

  end sp_cr_existe_credito_crm;
  ----------------------------------------------------------------------------------
  procedure sp_cr_tiene_seguro(ln_Instancia     in number,
                               lc_tiene_segdes  out char,
                               lc_tiene_segvc   out char,
                               lc_tiene_segveh  out char,
                               lc_tiene_segasis out char,
                               lc_tiene_segmpy  out char,
                               lc_tiene_segmga  out char,
                               lc_verif_seg     out char) is

    ln_pgcod        number;
    ln_sucursal     number;
    ln_modulo       number;
    ln_moneda       number;
    ln_papel        number;
    ln_cuenta       number;
    ln_operacion    number;
    ln_suboperacion number;
    ln_tipoper      number;
    ln_segdes       number;
    ln_segdes_act   number;
    ln_segvc        number;
    ln_segvc_act    number;
    ln_segveh       number;
    ln_segveh_act   number;
    ln_segasis      number;
    ln_segasis_act  number;
    ln_segmpy      number;
    ln_segmpy_act  number;
    ln_segmga      number;
    ln_segmga_act  number;

    ln_seg_homol number;

  begin
    begin

      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into ln_pgcod,
             ln_sucursal,
             ln_modulo,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_suboperacion,
             ln_tipoper
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;

    begin
      select count(*)
        into ln_segdes
        from (select *
                from fpp001
               where pgcod = ln_pgcod
                 and aomod = ln_modulo
                 and aosuc = ln_sucursal -- SMA 20240306
                 and aomda = ln_moneda
                 and aopap = ln_papel
                 and aocta = ln_cuenta
                 and aooper = ln_operacion
                 and aosbop = ln_suboperacion
                 and aotope = ln_tipoper
                 and sgcod in (select sgcod from fst300 where sgsn02 = 5)) t; --desgravamen
    exception
      when others then
        ln_segdes := 0;
    end;

    -- homologacion seguro desgravamen
    begin
      for i in (select *
                  from fpp001
                 where pgcod = ln_pgcod
                   and aomod = ln_modulo
                   and aosuc = ln_sucursal -- SMA 20240306
                   and aomda = ln_moneda
                   and aopap = ln_papel
                   and aocta = ln_cuenta
                   and aooper = ln_operacion
                   and aotope = ln_tipoper
                   and aosbop = 609
                   and sgcod in (select sgcod from fst300 where sgsn02 = 5)) loop
        ln_seg_homol := 0;
        begin
          select tp1nro2
            into ln_seg_homol
            from fst198
           where tp1cod1 = 10884
             and tp1corr1 = 65
             and tp1nro1 = i.sgcod;
        exception
          when others then
            ln_seg_homol := 0;
        end;
        ln_seg_homol := nvl(ln_seg_homol, 0);
        if ln_seg_homol <> 0 then
          if ln_seg_homol <> i.sgcod then
            update fpp001
               set sgcod = ln_seg_homol
             where pgcod = ln_pgcod
               and aomod = ln_modulo
               and aosuc = ln_sucursal -- SMA 20240306
               and aomda = ln_moneda
               and aopap = ln_papel
               and aocta = ln_cuenta
               and aooper = ln_operacion
               and aotope = ln_tipoper
               and aosbop = 609
               and sgcod = i.sgcod;
            commit;
          end if;
        end if;

      end loop;
    exception
      when others then
        null;
    end;

    begin
      select count(*)
        into ln_segdes_act
        from (select *
                from fpp001
               where pgcod = ln_pgcod
                 and aomod = ln_modulo
                 and aosuc = ln_sucursal -- SMA 20240306
                 and aomda = ln_moneda
                 and aopap = ln_papel
                 and aocta = ln_cuenta
                 and aooper = ln_operacion
                 and aotope = ln_tipoper
                 and aosbop = 609
                 and sgcod in (select sgcod from fst300 where sgsn02 = 5)) t; --desgravamen
    exception
      when others then
        ln_segdes_act := 0;
    end;

    begin
      select count(*)
        into ln_segvc
        from (select *
                from fpp001
               where pgcod = ln_pgcod
                 and aomod = ln_modulo
                 and aosuc = ln_sucursal -- SMA 20240306
                 and aomda = ln_moneda
                 and aopap = ln_papel
                 and aocta = ln_cuenta
                 and aooper = ln_operacion
                 and aotope = ln_tipoper
                 and aosbop = ln_suboperacion
                 and sgcod in (select sgcod
                                 from fst300
                                where sgtxt like '%Vida%'
                                   or sgtxt like '%Micro%')) t;
    exception
      when others then
        ln_segvc := 0;
    end;

    begin
      select count(*)
        into ln_segvc_act
        from (select *
                from fpp001
               where pgcod = ln_pgcod
                 and aomod = ln_modulo
                 and aosuc = ln_sucursal -- SMA 20240306
                 and aomda = ln_moneda
                 and aopap = ln_papel
                 and aocta = ln_cuenta
                 and aooper = ln_operacion
                 and aotope = ln_tipoper
                 and aosbop = 609
                 and sgcod in (select sgcod
                                 from fst300
                                where sgtxt like '%Vida%'
                                   or sgtxt like '%Micro%')) t;
    exception
      when others then
        ln_segvc_act := 0;
    end;

    begin
      select count(*)
        into ln_segveh
        from (select *
                from fpp001
               where pgcod = ln_pgcod
                 and aomod = ln_modulo
                 and aosuc = ln_sucursal -- SMA 20240306
                 and aomda = ln_moneda
                 and aopap = ln_papel
                 and aocta = ln_cuenta
                 and aooper = ln_operacion
                 and aotope = ln_tipoper
                 and aosbop = ln_suboperacion
                 and sgcod in  (select sgcod from fst300 where sgtxt like '%Vehicular%')) t;
                  ---   (select sgcod from fst300 where sgsn02  ='3')) t; ---sgtxt like '%Vehicular%')) t; -- sma 20240306
    exception
      when others then
        ln_segveh := 0;
    end;

    begin
      select count(*)
        into ln_segveh_act
        from (select *
                from fpp001
               where pgcod = ln_pgcod
                 and aomod = ln_modulo
                 and aosuc = ln_sucursal -- SMA 20240306
                 and aomda = ln_moneda
                 and aopap = ln_papel
                 and aocta = ln_cuenta
                 and aooper = ln_operacion
                 and aotope = ln_tipoper
                 and aosbop = 609
                 and sgcod in
                    (select sgcod from fst300 where sgtxt like '%Vehicular%')) t;
                 --    (select sgcod from fst300 where sgsn02  ='3')) t; -- sma 20240306
    exception
      when others then
        ln_segveh_act := 0;
    end;

    begin
      select count(*)
        into ln_segasis
        from (select *
                from fpp001
               where pgcod = ln_pgcod
                 and aomod = ln_modulo
                 and aosuc = ln_sucursal --SMA 20240306
                 and aomda = ln_moneda
                 and aopap = ln_papel
                 and aocta = ln_cuenta
                 and aooper = ln_operacion
                 and aotope = ln_tipoper
                 and aosbop = ln_suboperacion
                 and sgcod in
                     (select sgcod from fst300 where sgtxt like '%Fam%')) t;
    exception
      when others then
        ln_segasis := 0;
    end;

    begin
      select count(*)
        into ln_segasis_act
        from (select *
                from fpp001
               where pgcod = ln_pgcod
                 and aomod = ln_modulo
                 and aosuc = ln_sucursal
                 and aomda = ln_moneda
                 and aopap = ln_papel
                 and aocta = ln_cuenta
                 and aooper = ln_operacion
                 and aotope = ln_tipoper
                 and aosbop = 609
                 and sgcod in
                     (select sgcod from fst300 where sgtxt like '%Fam%')) t;
    exception
      when others then
        ln_segasis_act := 0;
    end;
    --------------------S.M.A. 20240311---------------------------------
    -- multiriesgo pyme
       begin
      select count(*)
        into ln_segmpy
        from (select *
                from fpp001
               where pgcod = ln_pgcod
                 and aomod = ln_modulo
                 and aosuc = ln_sucursal -- SMA 20240306
                 and aomda = ln_moneda
                 and aopap = ln_papel
                 and aocta = ln_cuenta
                 and aooper = ln_operacion
                 and aotope = ln_tipoper
                 and aosbop = ln_suboperacion
                 and sgcod in
                     (select tp1nro1 from fst198 where tp1cod = 1 and TP1COD1 =10875 AND TP1CORR1 = 9)) t; ---sgtxt like '%Vehicular%')) t; -- sma 20240306
    exception
      when others then
        ln_segmpy := 0;
    end;

    begin
      select count(*)
        into ln_segmpy_act
        from (select *
                from fpp001
               where pgcod = ln_pgcod
                 and aomod = ln_modulo
                 and aosuc = ln_sucursal -- SMA 20240306
                 and aomda = ln_moneda
                 and aopap = ln_papel
                 and aocta = ln_cuenta
                 and aooper = ln_operacion
                 and aotope = ln_tipoper
                 and aosbop = 609
                 and sgcod in
                 --    (select sgcod from fst300 where sgtxt like '%Vehicular%')) t;
                     (select tp1nro1 from fst198 where tp1cod = 1 and TP1COD1 =10875 AND TP1CORR1 = 9)) t; -- sma 20240306
    exception
      when others then
        ln_segmpy_act := 0;
    end;
    -- multiriesgo garantía
    begin
      select count(*)
        into ln_segmga
        from (select *
                from fpp001
               where pgcod = ln_pgcod
                 and aomod = ln_modulo
                 and aosuc = ln_sucursal -- SMA 20240306
                 and aomda = ln_moneda
                 and aopap = ln_papel
                 and aocta = ln_cuenta
                 and aooper = ln_operacion
                 and aotope = ln_tipoper
                 and aosbop = ln_suboperacion
                 and sgcod in
                     (select tp1nro1 from fst198 where tp1cod = 1 and TP1COD1 =10875 AND TP1CORR1 = 10)) t; ---sgtxt like '%Vehicular%')) t; -- sma 20240306
    exception
      when others then
        ln_segmga := 0;
    end;

    begin
      select count(*)
        into ln_segmga_act
        from (select *
                from fpp001
               where pgcod = ln_pgcod
                 and aomod = ln_modulo
                 and aosuc = ln_sucursal -- SMA 20240306
                 and aomda = ln_moneda
                 and aopap = ln_papel
                 and aocta = ln_cuenta
                 and aooper = ln_operacion
                 and aotope = ln_tipoper
                 and aosbop = 609
                 and sgcod in
                 --    (select sgcod from fst300 where sgtxt like '%Vehicular%')) t;
                     (select tp1nro1 from fst198 where tp1cod = 1 and TP1COD1 =10875 AND TP1CORR1 = 10)) t; -- sma 20240306
    exception
      when others then
        ln_segmga_act := 0;
    end;
    -------------------------------------------------------------------
    if ln_segdes > 0 then
      if ln_segdes_act > 0 then
        lc_tiene_segdes := 'S';
      else
        lc_tiene_segdes := 'N';
      end if;
    else
      if ln_segdes_act > 0 then
        lc_tiene_segdes := 'N';
      else
        lc_tiene_segdes := 'S';
      end if;
    end if;

    if ln_segvc > 0 then
      if ln_segvc_act > 0 then
        lc_tiene_segvc := 'S';
      else
        lc_tiene_segvc := 'N';
      end if;
    else
      if ln_segvc_act > 0 then
        lc_tiene_segvc := 'N';
      else
        lc_tiene_segvc := 'S';
      end if;
    end if;

    if ln_segveh > 0 then
      if ln_segveh_act > 0 then
        lc_tiene_segveh := 'S';
      else
        lc_tiene_segveh := 'N';
      end if;
    else
      if ln_segveh_act > 0 then
        lc_tiene_segveh := 'N';
      else
        lc_tiene_segveh := 'S';
      end if;
    end if;

    if ln_segasis > 0 then
      if ln_segasis_act > 0 then
        lc_tiene_segasis := 'S';
      else
        lc_tiene_segasis := 'N';
      end if;
    else
      if ln_segasis_act > 0 then
        lc_tiene_segasis := 'N';
      else
        lc_tiene_segasis := 'S';
      end if;
    end if;
    ----------SMA 11032024-------
    ---------multiriesgo Pyme
    if ln_segmpy > 0 then
      if ln_segmpy_act > 0 then
        lc_tiene_segmpy := 'S';
      else
        lc_tiene_segmpy := 'N';
      end if;
    else
      if ln_segmpy_act > 0 then
        lc_tiene_segmpy := 'N';
      else
        lc_tiene_segmpy := 'S';
      end if;
    end if;

  ---------multiriesgo grarantia
    if ln_segmga > 0 then
      if ln_segmga_act > 0 then
        lc_tiene_segmga := 'S';
      else
        lc_tiene_segmga := 'N';
      end if;
    else
      if ln_segmga_act > 0 then
        lc_tiene_segmga := 'N';
      else
        lc_tiene_segmga := 'S';
      end if;
    end if;
 --------------------------------


    if ln_segdes = ln_segdes_act and ln_segvc = ln_segvc_act and
       ln_segveh = ln_segveh_act and ln_segasis = ln_segasis_act
       and ln_segmpy = ln_segmpy_act and ln_segmga = ln_segmga_act then ---SMA 11032024
      lc_verif_seg := 'S';
    else
      lc_verif_seg := 'N';
    end if;

  end sp_cr_tiene_seguro;

end PQ_CR_RT_REPROGRAMACION;
/

