create or replace package pq_cr_tp_reporte is
  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA OBTENER INFORMACION DE LOS PRENDARIOS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2017.07.04
  -- Autor de Creación          : HSUAREZ
  -- Uso                        : Realiza Calculos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  --
  --
  --
  -- *****************************************************************
  -----------------------------------------------------------------------
  -----------------------------------------------------------------------
  procedure sp_crd_reprog(fecha_ini date,
                          fecha_fin date,
                          pc_ubuser in varchar2);
  -----------------------------------------------------------------------
  Procedure sp_cr_aprobados(PD_FECINI IN DATE,
                            PS_FECFIN IN DATE,
                            pc_ubuser in varchar2);
  -----------------------------------------------------------------------
  procedure sp_cr_consolidado(pd_fecini in date,
                              pd_fecfin in date,
                              pc_ubuser in varchar2);
  -----------------------------------------------------------------------

  function tiempo_aprobacion(instancia in number) return number;
  -----------------------------------------------------------------------
  procedure sp_cr_sig_cuota_credito(pgcod1    in xwf700.xwfempresa%type,
                                    sucursal  in xwf700.xwfsucursal%type,
                                    modulo    in xwf700.xwfmodulo%type,
                                    moneda    in xwf700.xwfmoneda%type,
                                    papel     in xwf700.xwfpapel%type,
                                    cuenta    in xwf700.xwfcuenta%type,
                                    operacion in xwf700.xwfoperacion%type,
                                    subope    in xwf700.xwfsubope%type,
                                    tipope    in xwf700.xwftipope%type,
                                    fecha     out fsd010.aofval%type,
                                    cuota     out fsd010.aoimp%type);
  -----------------------------------------------------------------------
  ------------------------------------------------------------------
  -- OBTENER TL TIPO DE CREDITO ES DECIR SI ES UN CLIENTE CON CREDITO NUEVO O RECURRENTE.
  -- LA LOGICA ES SIMPLE SI TIENE MAS DE UN CREDITO VIGENTE O CANCELADO SE CONSIDERA RRECURRENTE
  -- CASO CONTRARIO ES NUEVO.
  ------------------------------------------------------------------
  PROCEDURE sp_cr_tipo_credito(v_pais    in fsr008.pepais%type,
                               v_petdoc  in fsr008.petdoc%type,
                               v_pendoc  in fsr008.pendoc%type,
                               tipo_cred out varchar);

  ------------------------------------------------------------------
  -- VERIFICAR SI EL CREDITO ACTUAL A TENIDO CAMBIO DE AGENCIA. 
  -- EN CASO DE TENER CAMBIO SE DEVUELVE LA NUEVA SUCURSAL.
  ------------------------------------------------------------------
  procedure sp_cr_validar_cambio_age(ve_pgcod     in xwf700.xwfempresa%type,
                                     ve_sucurs    in xwf700.xwfsucursal%type,
                                     ve_modulo    in xwf700.xwfmodulo%type,
                                     ve_moneda    in xwf700.xwfmoneda%type,
                                     ve_papel     in xwf700.xwfpapel%type,
                                     ve_cuenta    in xwf700.xwfcuenta%type,
                                     ve_operacion in xwf700.xwfoperacion%type,
                                     ve_subope    in xwf700.xwfsubope%type,
                                     ve_tipope    in xwf700.xwftipope%type,
                                     vo_sucurdst  out xwf700.xwfsucursal%type,
                                     vo_sucurori  out xwf700.xwfsucursal%type,
                                     vo_flag_s    out varchar);

  procedure sp_cr_pagos_bms(pn_ctnro  in number,
                            pd_fecini in date,
                            pd_fecfin in date,
                            pn_salbms out number,
                            pn_intbms out number);

end pq_cr_tp_reporte;
/

create or replace package body pq_cr_tp_reporte is
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  ----------------------------------------------------------------------------------------
  procedure sp_crd_reprog(fecha_ini date,
                          fecha_fin date,
                          pc_ubuser in varchar2) is
    cursor modulos is
      select tp1nro1 modulo, tp1nro2 tipope
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11105
         and t.tp1corr1 = 26
         and t.tp1corr2 = 1
         and t.tp1corr3 > 0
         and t.Tp1nro3 = 2;
  
    cursor refin_reprog_diario is
      select d15.pgcod,
             d15.itsuc,
             d15.itmod,
             d15.ittran,
             d15.itnrel,
             d15.itfcon
        from fsd015 d15
       where d15.pgcod = 1
         and d15.itmod = 30
         and d15.ittran in (353, 354) --Colocar en guia de proceso especial.
         and d15.itcont = 'S'
         and d15.itcorr = 0
         and d15.itfcon >= fecha_ini
         and d15.itfcon <= fecha_fin;
  
    cursor refin_reprog_histor is
      select h15.pgcod,
             h15.hsucor,
             h15.hcmod,
             h15.htran,
             h15.hnrel,
             h15.hfcon
        from fsh015 h15
       where h15.pgcod = 1
         and h15.hcmod = 30 --Colocar en guia de proceso especial.
         and h15.htran in (353, 354)
         and h15.hfcon >= fecha_ini
         and h15.hfcon <= fecha_fin;
  
    v_empresa   xwf700.xwfempresa%type;
    v_sucursal  xwf700.xwfsucursal%type;
    v_modulo    xwf700.xwfmodulo%type;
    v_moneda    xwf700.xwfmoneda%type;
    v_papel     xwf700.xwfpapel%type;
    v_cuenta    xwf700.xwfcuenta%type;
    v_operacion xwf700.xwfoperacion%type;
    v_subope    xwf700.xwfsubope%type;
    v_tipope    xwf700.xwftipope%type;
  
    vt_empresa   xwf700.xwfempresa%type;
    vt_sucursal  xwf700.xwfsucursal%type;
    vt_modulo    xwf700.xwfmodulo%type;
    vt_moneda    xwf700.xwfmoneda%type;
    vt_papel     xwf700.xwfpapel%type;
    vt_cuenta    xwf700.xwfcuenta%type;
    vt_operacion xwf700.xwfoperacion%type;
    vt_subope    xwf700.xwfsubope%type;
    vt_tipope    xwf700.xwftipope%type;
  
    flag_vigente   char(1);
    v_cliente      varchar2(100);
    v_nsucursal    varchar2(50);
    v_credito      varchar2(23);
    v_fdesembolso  date;
    v_frefinancion date;
    v_analista     varchar2(50);
    vdmoneda       varchar2(5);
    vvdcredito     fst004.tonom%type;
    vmntoapr       x054023.xllcapital%type;
    v_saldoref     fsd011.scsdo%type;
    vl_cuota       sng001.sng01icuot%type;
    vl_tip_sol     varchar2(50);
    vi_fecha       date;
    tmp_instancia  xwf700.xwfprcins%type;
  
    vi_pais        fsr008.pepais%type;
    vi_petdoc      fsr008.petdoc%type;
    vi_pendoc      fsr008.pendoc%type;
    vi_corigen     sng001.sng001ori%type;
    v_instancia    sng001.sng001inst%type;
    vi_asesor      sng001.sng001ase%type;
    vi_tipcred     varchar2(20);
    flag_cambio_ag char(1);
    vi_corr_cambio number;
    v_suc_orig     fsd010.aosuc%type;
    n_flagTP       number;
  begin
  
    delete from aqpa058 where TRIM(aqpa058usr) = TRIM(pc_ubuser);
    COMMIT;
    -- RECORRIENDO PAGOS DIARIOS. (DESEMBOLSOS)
    for xx in refin_reprog_diario loop
      n_flagTP := 0;
      begin
        select d16.pgcod,
               d16.itsucd,
               d16.modulo,
               d16.moneda,
               d16.papel,
               d16.ctnro,
               d16.itoper,
               d16.itsubo,
               d16.ittope
          into v_empresa,
               v_sucursal,
               v_modulo,
               v_moneda,
               v_papel,
               v_cuenta,
               v_operacion,
               v_subope,
               v_tipope
          from fsd016 d16
         where d16.pgcod = xx.pgcod
           and d16.itsuc = xx.itsuc
           and d16.itmod = xx.itmod
           and d16.ittran = xx.ittran
           and d16.itnrel = xx.itnrel
           and d16.itord = 10; --ordinal 10 tiene los asientos.
        for xxx in modulos loop
          If v_modulo = xxx.modulo and v_tipope = xxx.tipope then
            n_flagTP := 1;
          end if;
        end loop;
      exception
        when no_data_found then
          n_flagTP := 0;
      end;
      If n_flagTP = 1 then
        --SE VERIFICARA QUE CREDITOS ESTA TODAVIA VIGENTES PARA PROCESAR SOLO LOS VIGENTES.
        --SE VERIFICA SI EXISTE CAMBIO DE AGENCIA.     
        begin
          select 'S', s.sng130cor
            into flag_cambio_ag, vi_corr_cambio
            from sng131 s
           where s.sng131pgc = v_empresa
             and s.sng131mod = v_modulo
                --and   s.sng131suc     = v_sucursal
             and s.sng131mda = v_moneda
             and s.sng131pap = v_papel
             and s.sng131cta = v_cuenta
             and s.sng131ope = v_operacion
             and s.sng131sbo = v_subope
             and s.sng131top = v_tipope
             and s.sng131con = 'S'
             and rownum = 1;
        exception
          when no_data_found then
            flag_cambio_ag := 'N';
        end;
        if flag_cambio_ag = 'S' then
          begin
            select sq.sng130suds, sq.sng130suor
              into v_sucursal, v_suc_orig
              from sng130 sq
             where sq.sng130cor = vi_corr_cambio;
          exception
            when others then
              v_sucursal := NULL;
          end;
        else
          v_suc_orig := v_sucursal;
        end if;
        --CONSULTANDO EN LA FSD010.
        --FECHA DE REFINANACIACION/ REPROGRAMACION.
        --se obtiene de la fsd010 - del campo aofval
        begin
          select 'S', d.aofval
            into flag_vigente, v_frefinancion -- Fecha de Refinanacion/Reprogramacion
            from fsd010 d
           where d.pgcod = v_empresa
             and d.aomod = v_modulo
             and d.aosuc = v_sucursal
             and d.aomda = v_moneda
             and d.aopap = v_papel
             and d.aocta = v_cuenta
             and d.aooper = v_operacion
             and d.aosbop = v_subope
             and d.aotope = v_tipope
             and d.aostat <> 99;
        exception
          WHEN NO_DATA_FOUND then
            flag_vigente   := 'N';
            v_frefinancion := null;
        end;
        --EN CASO DE ESTAR VIGENTE SE CONSULTAN LOS DEMAS DATOS.
        if flag_vigente = 'S' then
          begin
            --AGENCIA
            select f.scnom
              into v_nsucursal
              from fst001 f
             where f.pgcod = 1
               and f.sucurs = v_sucursal;
          exception
            WHEN NO_DATA_FOUND then
              v_nsucursal := '';
          end;
          begin
            --CREDITO
            --CUENTA(9) + MONEDA(4) + OPERACION(9)
            v_credito := lpad(v_cuenta, 9, '0') || lpad(v_moneda, 4, '0') ||
                         lpad(v_operacion, 9, '0');
          end;
          --OBTENER LA INSTANCIA DEL CREDITO.
          begin
            select xwfprcins
              into v_instancia
              from xwf700 xw, xwf070 wf
             where xw.xwfempresa = v_empresa
               and xw.xwfsucursal = v_sucursal
               and xw.xwfmodulo = v_modulo
               and xw.xwfmoneda = v_moneda
               and xw.xwfpapel = v_papel
               and xw.xwfcuenta = v_cuenta
               and xw.xwfoperacion = v_operacion
               and xw.xwfsubope = v_subope
               and xw.xwftipope = v_tipope
               and xw.xwfcar3 = '1'
               and wf.xwfprcin = xw.xwfprcins
               and wf.xwfcont = 'S';
          
          exception
            WHEN NO_DATA_FOUND then
              v_instancia := 0;
          end;
          if v_instancia <> 0 then
            --VERIFICAR SI ES REFINANCIACION/REPROGRAMACION
            begin
              select s.sng001ori, s.sng001ase
                into vi_corigen, vi_asesor
                from sng001 s
                join xwf070 x on s.sng001inst = x.xwfprcin
               where s.sng001ori in (3, 13, 14, 16) --2018.08.31 - REFINANCIADO SE AGREGO CODIGO 3
                 and s.sng001emp = v_empresa
                 and s.sng001inst = v_instancia
                 and x.xwfcont = 'S';
            exception
              when others then
                vi_corigen := NULL;
                vi_asesor  := null;
            end;
          
            --OBTENER LOS DOCUMENTOS DEL CLIENTE
            begin
              select f8.pepais, f8.petdoc, f8.pendoc
                into vi_pais, vi_petdoc, vi_pendoc
                from fsr008 f8
               where f8.ctnro = v_cuenta
                 and f8.cttfir = 'T';
            exception
            
              when others then
                vi_pais   := NULL;
                vi_petdoc := NULL;
                vi_pendoc := NULL;
            end;
            begin
              --CLIENTE               
              select fd.penom
                into v_cliente
                from fsd001 fd
               where fd.pepais = vi_pais
                 and fd.petdoc = vi_petdoc
                 and fd.pendoc = vi_pendoc;
            exception
              WHEN NO_DATA_FOUND then
                v_cliente := '';
            end;
          
            --FECHA DE DESEMBOLSO
          
            if vi_corigen = 3 then
              --verifico refinanciacion origen.
              begin
                select xwfprcins
                  into tmp_instancia
                  from xwf700
                 where xwfprcins = v_instancia
                   and xwfcar3 = '1';
              end;
              --obtengo clave origen                  
              BEGIN
                select xw.xwfempresa,
                       xw.xwfsucursal,
                       xw.xwfmodulo,
                       xw.xwfmoneda,
                       xw.xwfpapel,
                       xw.xwfcuenta,
                       xw.xwfoperacion,
                       xw.xwfsubope,
                       xw.xwftipope
                  into vt_empresa,
                       vt_sucursal,
                       vt_modulo,
                       vt_moneda,
                       vt_papel,
                       vt_cuenta,
                       vt_operacion,
                       vt_subope,
                       vt_tipope
                  from xwf700 xw
                 where xw.xwfprcins = tmp_instancia
                   and xwfcar3 <> '1';
              end;
            
              begin
                --FECHA DE DESEMBOLSO
                select d.aofval
                  into v_fdesembolso
                  from fsd010 d
                 where d.pgcod = vt_empresa
                   and d.aomod = vt_modulo
                   and d.aosuc = vt_sucursal
                   and d.aomda = vt_moneda
                   and d.aopap = vt_papel
                   and d.aocta = vt_cuenta
                   and d.aooper = vt_operacion
                   and d.aosbop = vt_subope
                   and d.aotope = vt_tipope
                   and d.aostat = 99
                   and rownum = 1;
              exception
                WHEN NO_DATA_FOUND then
                  v_fdesembolso := null;
              end;
            else
              begin
                --FECHA DE DESEMBOLSO
                select d.aofval
                  into v_fdesembolso
                  from fsd010 d
                 where d.pgcod = v_empresa
                   and d.aomod = v_modulo
                   and d.aosuc = v_suc_orig --v_sucursal se comento la anterior variable.
                   and d.aomda = v_moneda
                   and d.aopap = v_papel
                   and d.aocta = v_cuenta
                   and d.aooper = v_operacion
                   and d.aosbop = 0 -- que pertenece a la primera suboperacion con la que desembolso el prestamo.
                   and d.aotope = v_tipope
                   and d.aostat = 99
                   and rownum = 1;
              exception
                WHEN NO_DATA_FOUND then
                  v_fdesembolso := null;
              end;
            end if;
            begin
              --MONEDA
              select decode(v_moneda, 0, 'S/.', 'US$')
                into vdmoneda
                from dual;
            end;
          
            begin
              --DESCRIPCION DE CREDITO
              select tonom
                into vvdcredito
                from fst004 t4
               where t4.modulo = v_modulo
                 and t4.totope = v_tipope;
            end;
            begin
              --MONTO APROBADO
              --se obtiene de la tabla x054023 cruce con la xwf700
              select xllcapital
                into vmntoapr
                from x054023
               where xllpgcod = v_empresa
                 and xllaomod = v_modulo
                 and xllaosuc = v_sucursal
                 and xllaomda = v_moneda
                 and xllaopap = v_papel
                 and xllaooper = v_operacion
                 and xllaosbop = v_subope
                 and xllaotop = v_tipope;
            exception
              WHEN NO_DATA_FOUND then
                vmntoapr := 0;
            end;
            begin
              --SALDO REFINANCIADO/REPROGRAMADO (transaccion de la refinanaciacion.)
              --se obtiene la tabla fsd011
              select -scsdo
                into v_saldoref
                from fsd011
               where pgcod = v_empresa
                 and scsuc = v_sucursal
                 and scmda = v_moneda
                 and scpap = v_papel
                 and sccta = v_cuenta
                 and scoper = v_operacion
                 and scsbop = v_subope
                 and sctope = v_tipope
                 and rownum = 1;
            exception
              WHEN NO_DATA_FOUND then
                v_saldoref := 0;
            end;
            begin
              --CUOTA
              select f.sng01icuot,
                     case
                       when f.sng001ori = 0 then
                        'NORMAL'
                       when f.sng001ori = 1 then
                        'CARTA FIANZA'
                       when f.sng001ori = 2 then
                        'NO HABILITADO'
                       when f.sng001ori = 3 then
                        'REFINANCIACION'
                       when f.sng001ori = 4 then
                        'AMPLIACION'
                       when f.sng001ori = 7 then
                        'DESEMBOLSOS PARCIALES'
                       when f.sng001ori = 10 then
                        'CONVENIO'
                       when f.sng001ori = 11 then
                        'LINEA DE CREDITO'
                       when f.sng001ori = 12 then
                        'AMPLIACION LINEAS DE CREDITO'
                       when f.sng001ori = 13 then
                        'REPROGRAMACION CAMBIO FECHA'
                       when f.sng001ori = 14 then
                        'REPROGRAMACION DESASTRE NATURAL'
                       when f.sng001ori = 15 then
                        'AMPLIACION ESPECIAL'
                       when f.sng001ori = 16 then
                        'REPROGRAMACION CAMPAÃ`A'
                       else
                        'NORMAL'
                     end tipo_solicitud
                into vl_cuota, vl_tip_sol
                from sng001 f
               where f.sng001inst = v_instancia;
            exception
              WHEN NO_DATA_FOUND then
                vl_cuota   := 0;
                vl_tip_sol := '';
            end;
            begin
              sp_cr_sig_cuota_credito(v_empresa,
                                      v_sucursal,
                                      v_modulo,
                                      v_moneda,
                                      v_papel,
                                      v_cuenta,
                                      v_operacion,
                                      v_subope,
                                      v_tipope,
                                      vi_fecha,
                                      vl_cuota);
            end; /*
                              --CUOTA CREDITO
                              begin
                              SELECT ((d.ppcap + d.ppint) +
                              (dd.ppimp11 + dd.ppimp12 + dd.ppimp13 + dd.ppimp14 +
                              dd.ppimp15 + dd.ppimp16 + dd.ppimp17 + dd.ppimp18 +
                              dd.ppimp19))
                              INTO vl_cuota
                              from fsd601 d, fsd611 dd
                              where d.pgcod = v_empresa
                              and d.ppmod = v_modulo
                              and d.ppsuc = v_sucursal
                              and d.ppmda = v_moneda
                              and d.pppap = v_papel
                              and d.ppcta = v_cuenta
                              and d.ppoper = v_operacion
                              and d.ppsbop = v_subope
                              and d.pptope = v_tipope
                              and d.ppfpag > v_frefinancion
                              and d.d601co = 'S'
                              and dd.pgcod = d.pgcod
                              and dd.ppmod = d.ppmod
                              and dd.ppsuc = d.ppsuc
                              and dd.ppmda = d.ppmda
                              and dd.pppap = d.pppap
                              and dd.ppcta = d.ppcta
                              and dd.ppoper = d.ppoper
                              and dd.ppsbop = d.ppsbop
                              and dd.pptope = d.pptope
                              and dd.ppfpag = d.ppfpag
                              and rownum = 1;
                              exception
                              WHEN NO_DATA_FOUND then
                              vl_cuota := 0;
                              end;*/
          
            --ANALISTA
            v_analista := vi_asesor;
          
            begin
              sp_cr_tipo_credito(vi_pais, vi_petdoc, vi_pendoc, vi_tipcred);
            end;
            --Insertando registros en la tabla jaqz058
            begin
              insert into aqpa058
                (aqpa058pgc,
                 aqpa058mod,
                 aqpa058suc,
                 aqpa058mda,
                 aqpa058pap,
                 aqpa058cta,
                 aqpa058ope,
                 aqpa058sbo,
                 aqpa058top,
                 aqpa058age,
                 aqpa058crd,
                 aqpa058cli,
                 aqpa058fds,
                 aqpa058frf,
                 aqpa058dcrd,
                 aqpa058mnta,
                 aqpa058sdor,
                 aqpa058pzo,
                 aqpa058cuo,
                 aqpa058ana,
                 aqpa058tcrd,
                 aqpa058est,
                 aqpa058usr)
              --aqpa058bbp,aqpa058ibbp,aqpa058pbp,aqpa058ipbp)--Comentado los bonos hasta que se calculen aqui en el proces.
              values
                (v_empresa,
                 v_modulo,
                 v_sucursal,
                 v_moneda,
                 v_papel,
                 v_cuenta,
                 v_operacion,
                 v_subope,
                 v_tipope,
                 v_nsucursal,
                 v_credito,
                 v_cliente,
                 v_fdesembolso,
                 v_frefinancion,
                 vvdcredito,
                 vmntoapr,
                 v_saldoref,
                 0,
                 vl_cuota,
                 v_analista,
                 vi_tipcred,
                 vl_tip_sol,
                 pc_ubuser);
              commit;
            exception
              WHEN others then
                null;
            end;
          end if;
        end if;
      end if;
    end loop;
    ---
    -- RECORRIENDO PAGOS HISTORICOS. (DESEMBOLSOS)
    for yy in refin_reprog_histor loop
      n_flagTP := 0;
      begin
        select h16.pgcod,
               h16.hsucur,
               h16.hmodul,
               h16.hmda,
               h16.hpap,
               h16.hcta,
               h16.hoper,
               h16.hsubop,
               h16.htoper
          into v_empresa,
               v_sucursal,
               v_modulo,
               v_moneda,
               v_papel,
               v_cuenta,
               v_operacion,
               v_subope,
               v_tipope
          from fsh016 h16
         where h16.pgcod = yy.pgcod
           and h16.hsucor = yy.hsucor
           and h16.hcmod = yy.hcmod
           and h16.htran = yy.htran
           and h16.hnrel = yy.hnrel
           and h16.hcord = 10; --ordinal 10 tiene los asientos.
      
        for xxx in modulos loop
          If v_modulo = xxx.modulo and v_tipope = xxx.tipope then
            n_flagTP := 1;
          end if;
        end loop;
      exception
        when no_data_found then
          n_flagTP := 0;
      end;
      if n_flagTP = 1 then
        --SE VERIFICARA QUE CREDITOS ESTA TODAVIA VIGENTES PARA PROCESAR SOLO LOS VIGENTES.
        --SE VERIFICA SI EXISTE CAMBIO DE AGENCIA.     
        begin
          select 'S', s.sng130cor
            into flag_cambio_ag, vi_corr_cambio
            from sng131 s
           where s.sng131pgc = v_empresa
             and s.sng131mod = v_modulo
                --and   s.sng131suc     = v_sucursal
             and s.sng131mda = v_moneda
             and s.sng131pap = v_papel
             and s.sng131cta = v_cuenta
             and s.sng131ope = v_operacion
             and s.sng131sbo = v_subope
             and s.sng131top = v_tipope
             and s.sng131con = 'S'
             and rownum = 1;
        exception
          when no_data_found then
            flag_cambio_ag := 'N';
        end;
        if flag_cambio_ag = 'S' then
          begin
            select sq.sng130suds, sq.sng130suor
              into v_sucursal, v_suc_orig
              from sng130 sq
             where sq.sng130cor = vi_corr_cambio;
          exception
            when no_data_found then
              null;
          end;
        else
          v_suc_orig := v_sucursal;
        end if;
        --CONSULTANDO EN LA FSD010.
        --FECHA DE REFINANACIACION/ REPROGRAMACION.
        --se obtiene de la fsd010 - del campo aofval
        begin
          select 'S', d.aofval
            into flag_vigente, v_frefinancion -- Fecha de Refinanacion/Reprogramacion
            from fsd010 d
           where d.pgcod = v_empresa
             and d.aomod = v_modulo
             and d.aosuc = v_sucursal
             and d.aomda = v_moneda
             and d.aopap = v_papel
             and d.aocta = v_cuenta
             and d.aooper = v_operacion
             and d.aosbop = v_subope
             and d.aotope = v_tipope
             and d.aostat <> 99;
        exception
          WHEN NO_DATA_FOUND then
            flag_vigente   := 'N';
            v_frefinancion := null;
        end;
        --EN CASO DE ESTAR VIGENTE SE CONSULTAN LOS DEMAS DATOS.
        if flag_vigente = 'S' then
          begin
            --AGENCIA
            select f.scnom
              into v_nsucursal
              from fst001 f
             where f.pgcod = 1
               and f.sucurs = v_sucursal;
          exception
            WHEN NO_DATA_FOUND then
              null;
          end;
          begin
            --CREDITO
            --CUENTA(9) + MONEDA(4) + OPERACION(9)
            v_credito := lpad(v_cuenta, 9, '0') || lpad(v_moneda, 4, '0') ||
                         lpad(v_operacion, 9, '0');
          end;
          --OBTENER LA INSTANCIA DEL CREDITO.
          begin
            select xwfprcins
              into v_instancia
              from xwf700 xw
             where xw.xwfempresa = v_empresa
               and xw.xwfsucursal = v_sucursal
               and xw.xwfmodulo = v_modulo
               and xw.xwfmoneda = v_moneda
               and xw.xwfpapel = v_papel
               and xw.xwfcuenta = v_cuenta
               and xw.xwfoperacion = v_operacion
               and xw.xwfsubope = v_subope
               and xw.xwftipope = v_tipope
               and xw.xwfcar3 = '1';
          exception
            WHEN NO_DATA_FOUND then
              v_instancia := 0;
          end;
          if v_instancia <> 0 then
            --VERIFICAR SI ES REFINANCIACION/REPROGRAMACION
            begin
              select s.sng001ori, s.sng001ase
                into vi_corigen, vi_asesor
                from sng001 s
                join xwf070 x on s.sng001inst = x.xwfprcin
               where s.sng001ori in (3, 13, 14, 16) --2018.08.31 - REFINANCIADO SE AGREGO CODIGO 3
                 and s.sng001emp = v_empresa
                 and s.sng001inst = v_instancia
                 and x.xwfcont = 'S';
            exception
              WHEN NO_DATA_FOUND then
                vi_corigen := 0;
                vi_asesor  := '';
            end;
          
            --OBTENER LOS DOCUMENTOS DEL CLIENTE
            begin
              select f8.pepais, f8.petdoc, f8.pendoc
                into vi_pais, vi_petdoc, vi_pendoc
                from fsr008 f8
               where f8.ctnro = v_cuenta
                 and f8.cttfir = 'T';
            exception
              WHEN NO_DATA_FOUND then
                vi_pais   := 604;
                vi_petdoc := 21;
                vi_pendoc := '';
            end;
            begin
              --CLIENTE               
              select fd.penom
                into v_cliente
                from fsd001 fd
               where fd.pepais = vi_pais
                 and fd.petdoc = vi_petdoc
                 and fd.pendoc = vi_pendoc;
            exception
              WHEN NO_DATA_FOUND then
                v_cliente := '';
            end;
          
            --FECHA DE DESEMBOLSO           
            if vi_corigen = 3 then
              --verifico refinanciacion origen.
              begin
                select xwfprcins
                  into tmp_instancia
                  from xwf700
                 where xwfprcins = v_instancia
                   and xwfcar3 = '1';
              end;
              --obtengo clave origen                  
              BEGIN
                select xw.xwfempresa,
                       xw.xwfsucursal,
                       xw.xwfmodulo,
                       xw.xwfmoneda,
                       xw.xwfpapel,
                       xw.xwfcuenta,
                       xw.xwfoperacion,
                       xw.xwfsubope,
                       xw.xwftipope
                  into vt_empresa,
                       vt_sucursal,
                       vt_modulo,
                       vt_moneda,
                       vt_papel,
                       vt_cuenta,
                       vt_operacion,
                       vt_subope,
                       vt_tipope
                  from xwf700 xw
                 where xw.xwfprcins = tmp_instancia
                   and xwfcar3 <> '1';
              end;
              begin
                --FECHA DE DESEMBOLSO
                select d.aofval
                  into v_fdesembolso
                  from fsd010 d
                 where d.pgcod = vt_empresa
                   and d.aomod = vt_modulo
                   and d.aosuc = vt_sucursal
                   and d.aomda = vt_moneda
                   and d.aopap = vt_papel
                   and d.aocta = vt_cuenta
                   and d.aooper = vt_operacion
                   and d.aosbop = vt_subope
                   and d.aotope = vt_tipope
                   and d.aostat = 99
                   and rownum = 1;
              exception
                WHEN NO_DATA_FOUND then
                  v_fdesembolso := null;
              end;
            else
              begin
                --FECHA DE DESEMBOLSO
                select d.aofval
                  into v_fdesembolso
                  from fsd010 d
                 where d.pgcod = v_empresa
                   and d.aomod = v_modulo
                   and d.aosuc = v_suc_orig --v_sucursal
                   and d.aomda = v_moneda
                   and d.aopap = v_papel
                   and d.aocta = v_cuenta
                   and d.aooper = v_operacion
                   and d.aosbop = 0 -- que pertenece a la primera suboperacion con la que desembolso el prestamo.
                   and d.aotope = v_tipope
                   and d.aostat = 99
                   and rownum = 1;
              exception
                WHEN NO_DATA_FOUND then
                  v_fdesembolso := null;
              end;
            end if;
            begin
              --MONEDA
              select decode(v_moneda, 0, 'S/.', 'US$')
                into vdmoneda
                from dual;
            end;
            --DESCRIPCION DE CREDITO
            begin
              select tonom
                into vvdcredito
                from fst004 t4
               where t4.modulo = v_modulo
                 and t4.totope = v_tipope;
            end;
            --MONTO APROBADO
            begin
              --Se obtiene de la tabla x054023 cruce con la xwf700
              select xllcapital
                into vmntoapr
                from x054023
               where xllpgcod = v_empresa
                 and xllaomod = v_modulo
                 and xllaosuc = v_sucursal
                 and xllaomda = v_moneda
                 and xllaopap = v_papel
                 and xllaooper = v_operacion
                 and xllaosbop = v_subope
                 and xllaotop = v_tipope;
            exception
              WHEN NO_DATA_FOUND then
                vmntoapr := 0;
            end;
            --SALDO REFINANCIADO/REPROGRAMADO (transaccion de la refinanaciacion.)
            --se obtiene la tabla fsd011
            begin
            
              select scsdo
                into v_saldoref
                from fsd011
               where pgcod = v_empresa
                 and scsuc = v_sucursal
                 and scmda = v_moneda
                 and scpap = v_papel
                 and sccta = v_cuenta
                 and scoper = v_operacion
                 and scsbop = v_subope
                 and sctope = v_tipope
                 and rownum = 1;
            exception
              WHEN NO_DATA_FOUND then
                v_saldoref := 0;
            end;
            --CUOTA
            begin
              select f.sng01icuot,
                     case
                       when f.sng001ori = 0 then
                        'NORMAL'
                       when f.sng001ori = 1 then
                        'CARTA FIANZA'
                       when f.sng001ori = 2 then
                        'NO HABILITADO'
                       when f.sng001ori = 3 then
                        'REFINANCIACION'
                       when f.sng001ori = 4 then
                        'AMPLIACION'
                       when f.sng001ori = 7 then
                        'DESEMBOLSOS PARCIALES'
                       when f.sng001ori = 10 then
                        'CONVENIO'
                       when f.sng001ori = 11 then
                        'LINEA DE CREDITO'
                       when f.sng001ori = 12 then
                        'AMPLIACION LINEAS DE CREDITO'
                       when f.sng001ori = 13 then
                        'REPROGRAMACION CAMBIO FECHA'
                       when f.sng001ori = 14 then
                        'REPROGRAMACION DESASTRE NATURAL'
                       when f.sng001ori = 15 then
                        'AMPLIACION ESPECIAL'
                       when f.sng001ori = 16 then
                        'REPROGRAMACION CAMPAÃ`A'
                       else
                        'NORMAL'
                     end tipo_solicitud
                into vl_cuota, vl_tip_sol
                from sng001 f
               where f.sng001inst = v_instancia;
            exception
              WHEN NO_DATA_FOUND then
                vl_cuota   := 0;
                vl_tip_sol := '';
            end;
          
            begin
              sp_cr_sig_cuota_credito(v_empresa,
                                      v_sucursal,
                                      v_modulo,
                                      v_moneda,
                                      v_papel,
                                      v_cuenta,
                                      v_operacion,
                                      v_subope,
                                      v_tipope,
                                      vi_fecha,
                                      vl_cuota);
            end;
            --CUOTA CREDITO
            --CUOTA CREDITO
            begin
              SELECT ((d.ppcap + d.ppint) +
                     (dd.ppimp11 + dd.ppimp12 + dd.ppimp13 + dd.ppimp14 +
                     dd.ppimp15 + dd.ppimp16 + dd.ppimp17 + dd.ppimp18 +
                     dd.ppimp19))
                INTO vl_cuota
                from fsd601 d, fsd611 dd
               where d.pgcod = v_empresa
                 and d.ppmod = v_modulo
                 and d.ppsuc = v_sucursal
                 and d.ppmda = v_moneda
                 and d.pppap = v_papel
                 and d.ppcta = v_cuenta
                 and d.ppoper = v_operacion
                 and d.ppsbop = v_subope
                 and d.pptope = v_tipope
                 and d.ppfpag > v_frefinancion
                 and d.d601co = 'S'
                 and dd.pgcod = d.pgcod
                 and dd.ppmod = d.ppmod
                 and dd.ppsuc = d.ppsuc
                 and dd.ppmda = d.ppmda
                 and dd.pppap = d.pppap
                 and dd.ppcta = d.ppcta
                 and dd.ppoper = d.ppoper
                 and dd.ppsbop = d.ppsbop
                 and dd.pptope = d.pptope
                 and dd.ppfpag = d.ppfpag
                 and rownum = 1;
            exception
              WHEN NO_DATA_FOUND then
                vl_cuota := 0;
            end;
            --verifica si es nuevo o recurrente.
            begin
              sp_cr_tipo_credito(vi_pais, vi_petdoc, vi_pendoc, vi_tipcred);
            end;
            begin
              --ANALISTA
              v_analista := vi_asesor;
            end;
            --Insertando registros en la tabla jaqz058
            begin
              insert into aqpa058
                (aqpa058pgc,
                 aqpa058mod,
                 aqpa058suc,
                 aqpa058mda,
                 aqpa058pap,
                 aqpa058cta,
                 aqpa058ope,
                 aqpa058sbo,
                 aqpa058top,
                 aqpa058age,
                 aqpa058crd,
                 aqpa058cli,
                 aqpa058fds,
                 aqpa058frf,
                 aqpa058dcrd,
                 aqpa058mnta,
                 aqpa058sdor,
                 aqpa058pzo,
                 aqpa058cuo,
                 aqpa058ana,
                 aqpa058tcrd,
                 aqpa058est,
                 aqpa058usr)
              --aqpa058bbp,aqpa058ibbp,aqpa058pbp,aqpa058ipbp)--Comentado los bonos hasta que se calculen aqui en el proces.
              values
                (v_empresa,
                 v_modulo,
                 v_sucursal,
                 v_moneda,
                 v_papel,
                 v_cuenta,
                 v_operacion,
                 v_subope,
                 v_tipope,
                 v_nsucursal,
                 v_credito,
                 v_cliente,
                 v_fdesembolso,
                 v_frefinancion,
                 vvdcredito,
                 vmntoapr,
                 v_saldoref,
                 0,
                 vl_cuota,
                 v_analista,
                 vi_tipcred,
                 vl_tip_sol,
                 pc_ubuser);
              commit;
            exception
              WHEN others then
                null;
            end;
          end if;
        end if;
      end if;
    end loop;
  
    ---
    ---
  
  end;
  ----------------------------------------------------------------------------------------
  Procedure sp_cr_aprobados(PD_FECINI IN DATE,
                            PS_FECFIN IN DATE,
                            pc_ubuser in varchar2) IS
  
  begin
    --execute immediate ('truncate table AQPA060');
    delete from aqpa060 where TRIM(aqpa060usr) = TRIM(pc_ubuser);
    COMMIT;
  
    begin
    
      insert into aqpa060
        (aqpa060INS,
         aqpa060USC,
         aqpa060FDI,
         aqpa060EST,
         aqpa060CRE,
         aqpa060REG,
         aqpa060CSU,
         aqpa060SUC,
         aqpa060crd,
         aqpa060fapr,
         aqpa060tapr,
         aqpa060dcrd,
         aqpa060plz,
         aqpa060cuo,
         aqpa060ANA,
         aqpa060MOD,
         aqpa060MDA,
         aqpa060CTA,
         aqpa060OPE,
         aqpa060SBO,
         aqpa060TOP,
         aqpa060MTO,
         aqpa060PAI,
         aqpa060TDC,
         aqpa060NDC,
         aqpa060NOM,
         aqpa060TEL,
         aqpa060TSO,
         aqpa060USR,
         aqpa060ZON)
      
        select a.wfinsprcid,
               a.wfitemusrcod asignado,
               a.wfiteminit ingdes,
               a.wfstscod || '-' || trim(s.wfstsdsc) estado,
               c.regcod,
               c.regnom region,
               r.sucurs,
               r.scnom sucursal,
               --credito
               lpad(b.xwfcuenta, 9, '0') || lpad(b.xwfmoneda, 4, '0') ||
               lpad(b.xwfoperacion, 9, '0') credito,
               --fecha de aprobacion
               a.wfiteminit fecha_apro,
               --tiempo de aprobacion
               tiempo_aprobacion(b.xwfprcins) tiempo,
               --descripcion credito
               t4.tonom desc_credito,
               --plazo
               x54.xlloaopzo plazo,
               --cuota  
               f.sng01icuot cuota,
               f.sng001ase analista,
               b.xwfmodulo modulo,
               decode(b.xwfmoneda, 0, 'S/.', 'US$') moneda,
               b.xwfcuenta cuenta,
               b.xwfoperacion operacion,
               b.xwfsubope SubOpe,
               b.xwftipope TipOpe,
               f.sng017mto monto,
               trim(f.sng001pais),
               trim(f.sng001tdoc),
               trim(f.sng001ndoc) Numdoc,
               trim(d1.penom) Cliente,
               fn_cl_telefonos(f.sng001pais, f.sng001tdoc, f.sng001ndoc) Telefonos,
               case
                 when f.sng001ori = 0 then
                  'NORMAL'
                 when f.sng001ori = 1 then
                  'CARTA FIANZA'
                 when f.sng001ori = 2 then
                  'NO HABILITADO'
                 when f.sng001ori = 3 then
                  'REFINANCIACION'
                 when f.sng001ori = 4 then
                  'AMPLIACION'
                 when f.sng001ori = 7 then
                  'DESEMBOLSOS PARCIALES'
                 when f.sng001ori = 10 then
                  'CONVENIO'
                 when f.sng001ori = 11 then
                  'LINEA DE CREDITO'
                 when f.sng001ori = 12 then
                  'AMPLIACION LINEAS DE CREDITO'
                 when f.sng001ori = 13 then
                  'REPROGRAMACION CAMBIO FECHA'
                 when f.sng001ori = 14 then
                  'REPROGRAMACION DESASTRE NATURAL'
                 when f.sng001ori = 15 then
                  'AMPLIACION ESPECIAL'
                 when f.sng001ori = 16 then
                  'REPROGRAMACION CAMPAÃ`A'
                 else
                  'NORMAL'
               end "TIPO SOLICITUD",
               pc_ubuser,
               (select tp1nro1
                  from fst198 a
                 where tp1cod = 1
                   and tp1cod1 = 10872
                   and tp1corr1 = 11
                   and tp1nro2 = c.regcod)
          from wfwrkitems a,
               xwf700     b,
               fst810     c,
               fst811     cc,
               fst001     r,
               sng001     f,
               fsd001     d1,
               fst004     t4,
               x054007    x54,
               WFState1   s
         where a.wfinsprcid = b.xwfprcins
           and b.xwfsucursal = cc.oficod
           and cc.regcod < 100
           AND C.REGCOD < 100
           and c.regcod = cc.regcod
           and b.xwfsucursal = r.sucurs
           and a.wftaskcod = 55
           and a.wfstscod not in ('C', 'D')
           and a.wfitemid =
               (select max(m.wfitemid)
                  from wfwrkitems m
                 where m.wfinsprcid = a.wfinsprcid)
           and to_date(a.wfiteminit, 'dd/mm/yy') between
               to_date(PD_FECINI, 'dd/mm/yy') and
               to_date(PS_FECFIN, 'dd/mm/yy')
           and f.sng001inst = a.wfinsprcid
           and b.xwfcar3 = '1'
           and d1.pepais = f.sng001pais
           and d1.petdoc = f.sng001tdoc
           and d1.pendoc = f.sng001ndoc
           and s.wfstscod = a.wfstscod
           and s.wflngid = 'spa'
           and t4.modulo = b.xwfmodulo
           and t4.totope = b.xwftipope
           and x54.pgcod = b.xwfempresa
           and x54.xlloaomod = b.xwfmodulo
           and x54.xlloaosuc = b.xwfsucursal
           and x54.xlloaomda = b.xwfmoneda
           and x54.xlloaopap = b.xwfpapel
           and x54.xlloaocta = b.xwfcuenta
           and x54.xlloaooper = b.xwfoperacion
           and x54.xlloaosbop = b.xwfsubope
           and x54.xlloaotope = b.xwftipope;
    
      commit;
    
    end;
  
  END sp_cr_aprobados;
  ----------------------------------------------------------------------------------------
  procedure sp_cr_consolidado(pd_fecini in date,
                              pd_fecfin in date,
                              pc_ubuser in varchar2) is
  
    ------------------------------------------------
  
    mes      number;
    cantidad number;
    pago     number;
    bono     number;
    premio   number;
    total    number;
    ------------------------------------------------
  begin
  
    delete from aqpa062 where TRIM(aqpa062usr) = TRIM(pc_ubuser);
    COMMIT;
  
    -- 
  
    insert into aqpa062
      (aqpa062mesn,
       aqpa062mes,
       aqpa062year,
       aqpa062ncr,
       aqpa062mct,
       aqpa062bbp,
       aqpa062ibbp,
       aqpa062pbp,
       aqpa062ipbp,
       aqpa062sdo,
       aqpa062mod,
       aqpa062mda,
       aqpa062usr,
       AQPA062CTA)
    
      select b.mes,
             b.mest,
             b.year,
             sum(b.cantidad),
             --(sum(b.pago_cuota)+sum(b.pago_interes)) pago,
             sum(b.pago_total) pago,
             (sum(b.bono) /*+sum(b.bono_interes)*/
             ) bono,
             (sum(b.bono_interes)) ibono,
             (sum(b.premio) /*+sum(b.premio_interes)*/
             ) premio,
             (sum(b.premio_interes)) ipremio,
             --((sum(b.pago_cuota)+sum(b.pago_interes))+(sum(b.bono)+sum(b.bono_interes))+(sum(b.premio)+sum(b.premio_interes))) total,
             ((sum(b.pago_total)) + (sum(b.bono) + sum(b.bono_interes)) +
             (sum(b.premio) + sum(b.premio_interes))) total,
             111,
             0,
             pc_ubuser,
             b.cta
      
        from (
              --Obtengo el monto de la cuota 
              select to_char(depem50fvn, 'MM') mes,
                      to_char(depem50fvn, 'month', 'nls_date_language=spanish') mest,
                      to_char(depem50fvn, 'YYYY') year,
                      count(*) cantidad,
                      sum(depem50pri) pago_cuota,
                      sum(depem50int) pago_interes,
                      sum(depem50mac) pago_total,
                      0 bono, --
                      0 bono_interes, -- 
                      0 premio,
                      0 premio_interes,
                      d50.depem50cta cta --2018.08.08
                from depem50 d50, depem49 d9, fsd010 d10
               where depem50fvn >= pd_fecini --'29/05/2020' 
                 and depem50fvn <= pd_fecfin --'29/05/2026' 
                    --*and depem50mod=111
                    
                 and d9.depem49emp = d50.depem50emp
                 and d9.depem49mod = d50.depem50mod
                 and d9.depem49suc = d50.depem50suc
                 and d9.depem49mon = d50.depem50mon
                 and d9.depem49pap = d50.depem50pap
                 and d9.depem49cta = d50.depem50cta
                 and d9.depem49ope = d50.depem50ope
                 and d9.depem49sbp = d50.depem50sbp
                 and d9.depem49top = d50.depem50top
                 and d9.depem49ins = d50.depem50ins
                 and d9.depem49cor = d50.depem50cr1
                 AND D9.DEPEM49FEC = D50.DEPEM50FEC
                 and d9.depem49hab = 'S'
                 and d9.depem49con = 'S'
                 and d9.depem49anu = 'N'
                 and d50.depem50emp = d10.pgcod
                 and d50.depem50mod = d10.aomod
                    --and d50.depem50suc= d10.aosuc
                 and d50.depem50mon = d10.aomda
                 and d50.depem50pap = d10.aopap
                 and d50.depem50cta = d10.aocta
                 and d50.depem50ope = d10.aooper
                 and d50.depem50sbp = d10.aosbop
                 and d50.depem50top = d10.aotope
                 and (d50.depem50mod, d50.depem50top) in
                     (select tp1nro1, tp1nro2
                        from fst198
                       Where Tp1cod = 1
                         and Tp1cod1 = 11105
                         and Tp1corr1 = 26
                         and Tp1corr2 = 1
                         and Tp1corr3 > 0
                         and Tp1nro3 = 2)
                 and d10.aostat <> 99
              
               group by depem50fvn, d50.depem50cta
              
              union all
              
              select to_char(depem50fvn, 'MM') mes,
                     to_char(depem50fvn, 'month', 'nls_date_language=spanish') mest,
                     to_char(depem50fvn, 'YYYY') year,
                     count(*) cantidad,
                     sum(depem50pri) pago_cuota,
                     sum(depem50int) pago_interes,
                     sum(depem50mac) pago_total,
                     0 bono,
                     0 bono_interes,
                     0 premio,
                     0 premio_interes,
                     d50.depem50cta cta
                from depem50 d50,
                     depem49 d9,
                     fsd010  d10,
                     fsr011  rx,
                     fsd010  dx
               where depem50fvn >= pd_fecini
                 and depem50fvn <= pd_fecfin
                 and d9.depem49emp = d50.depem50emp
                 and d9.depem49mod = d50.depem50mod
                 and d9.depem49suc = d50.depem50suc
                 and d9.depem49mon = d50.depem50mon
                 and d9.depem49pap = d50.depem50pap
                 and d9.depem49cta = d50.depem50cta
                 and d9.depem49ope = d50.depem50ope
                 and d9.depem49sbp = d50.depem50sbp
                 and d9.depem49top = d50.depem50top
                 and d9.depem49ins = d50.depem50ins
                 and d9.depem49cor = d50.depem50cr1
                 AND D9.DEPEM49FEC = D50.DEPEM50FEC
                 and d9.depem49hab = 'S'
                 and d9.depem49con = 'S'
                 and d9.depem49anu = 'N'
                 and d50.depem50emp = d10.pgcod
                 and d50.depem50mod = d10.aomod
                 and d50.depem50mon = d10.aomda
                 and d50.depem50pap = d10.aopap
                 and d50.depem50cta = d10.aocta
                 and d50.depem50ope = d10.aooper
                 and d50.depem50sbp = d10.aosbop
                 and d50.depem50top = d10.aotope
                 and (d50.depem50mod, d50.depem50top) in
                     (select tp1nro1, tp1nro2
                        from fst198
                       Where Tp1cod = 1
                         and Tp1cod1 = 11105
                         and Tp1corr1 = 26
                         and Tp1corr2 = 1
                         and Tp1corr3 > 0
                         and Tp1nro3 = 2)
                 and d10.aostat = 99
                 and rx.r1cod = d10.pgcod
                 and rx.r1mod = d10.aomod
                 and rx.r1suc = d10.aosuc
                 and rx.r1mda = d10.aomda
                 and rx.r1pap = d10.aopap
                 and rx.r1cta = d10.aocta
                 and rx.r1oper = d10.aooper
                 and rx.relcod in (34, 52)
                 and dx.pgcod = rx.r1cod
                 and dx.aomod = rx.r2mod
                 and dx.aosuc = rx.r2suc
                 and dx.aomda = rx.r2mda
                 and dx.aopap = rx.r2pap
                 and dx.aocta = rx.r2cta
                 and dx.aooper = rx.r2oper
                 and dx.aostat in (23, 64)
              
               group by depem50fvn, d50.depem50cta
              
              union all -- obtengo de aqui el monto del bono.
              select to_char(d5.itfcon, 'MM') mes,
                     to_char(d5.itfcon, 'month', 'nls_date_language=spanish') mest,
                     to_char(d5.itfcon, 'YYYY') year,
                     0 cantidad,
                     0 pago_cuota,
                     0 pago_interes,
                     0 pago_total,
                     sum(d.itimp1) bono, --
                     0 bono_interes, --
                     0 premio,
                     0 premio_interes,
                     d.ctnro cta
                from fsd016 d, fsd015 d5
               where d.pgcod = 1
                 and d.itmod = 30
                 and d.ittran = 113
                 and d.itord = 15
                    --and d.rubro = ''
                 and d.pgcod = d5.pgcod
                 and d.itsuc = d5.itsuc
                 and d.itmod = d5.itmod
                 and d.ittran = d5.ittran
                 and d.itnrel = d5.itnrel
                 and d5.itfcon >= pd_fecini --'29/05/2020'  
                 and d5.itfcon <= pd_fecfin --'29/05/2026'
                 and d5.itcorr = 0
                 and d5.itcont = 'S'
                 and 1 = (select count(*)
                            from fsd016 a
                           where a.pgcod = d.pgcod
                             and a.itmod = d.itmod
                             and a.ittran = d.ittran
                             and a.itsuc = d.itsuc
                             and a.itnrel = d.itnrel
                             and a.itord = 10
                             and (a.modulo, a.ittope) in
                                 (select tp1nro1, tp1nro2
                                    from fst198
                                   Where Tp1cod = 1
                                     and Tp1cod1 = 11105
                                     and Tp1corr1 = 26
                                     and Tp1corr2 = 1
                                     and Tp1corr3 > 0
                                     and Tp1nro3 = 2))
              
               group by d5.itfcon, d.ctnro
              union all --Obtengo de aqui el interes del bono.
              select to_char(d5.itfcon, 'MM') mes,
                     to_char(d5.itfcon, 'month', 'nls_date_language=spanish') mest,
                     to_char(d5.itfcon, 'YYYY') year,
                     0 cantidad, --count(*) cantidad,
                     0 pago_cuota,
                     0 pago_interes,
                     0 pago_total,
                     0 bono, --
                     sum(d.itimp1) bono_interes, -- 
                     0 premio,
                     0 premio_interes,
                     d.ctnro cta --2018.08.08
                from fsd016 d, fsd015 d5
               where d.pgcod = 1
                 and d.itmod = 30
                 and d.ittran = 113
                 and d.itord = 16
                 and d.pgcod = d5.pgcod
                 and d.itsuc = d5.itsuc
                 and d.itmod = d5.itmod
                 and d.ittran = d5.ittran
                 and d.itnrel = d5.itnrel
                 and d5.itfcon >= pd_fecini --'29/05/2020'  
                 and d5.itfcon <= pd_fecfin --'29/05/2026'
                 and d5.itcorr = 0
                 and d5.itcont = 'S'
                 and 1 = (select count(*)
                            from fsd016 a
                           where a.pgcod = d.pgcod
                             and a.itmod = d.itmod
                             and a.ittran = d.ittran
                             and a.itsuc = d.itsuc
                             and a.itnrel = d.itnrel
                             and a.itord = 10
                             and (a.modulo, a.ittope) in
                                 (select tp1nro1, tp1nro2
                                    from fst198
                                   Where Tp1cod = 1
                                     and Tp1cod1 = 11105
                                     and Tp1corr1 = 26
                                     and Tp1corr2 = 1
                                     and Tp1corr3 > 0
                                     and Tp1nro3 = 2))
              
               group by d5.itfcon, d.ctnro
              union all
              select to_char(d5.itfcon, 'MM') mes,
                     to_char(d5.itfcon, 'month', 'nls_date_language=spanish') mest,
                     to_char(d5.itfcon, 'YYYY') year,
                     0 cantidad, --count(*) cantidad,
                     0 pago_cuota,
                     0 pago_interes,
                     0 pago_total,
                     0 bono, --
                     0 bono_interes, -- 
                     sum(d.itimp1) premio,
                     0 premio_interes,
                     d.ctnro cta --2018.08.08
                from fsd016 d, fsd015 d5
               where d.pgcod = 1
                 and d.itmod = 30
                 and d.ittran = 113
                 and d.itord = 20
                 and d.pgcod = d5.pgcod
                 and d.itsuc = d5.itsuc
                 and d.itmod = d5.itmod
                 and d.ittran = d5.ittran
                 and d.itnrel = d5.itnrel
                 and d5.itfcon >= pd_fecini --'29/05/2020' 
                 and d5.itfcon <= pd_fecfin --'29/05/2026'
                 and d5.itcorr = 0
                 and d5.itcont = 'S'
                 and 1 = (select count(*)
                            from fsd016 a
                           where a.pgcod = d.pgcod
                             and a.itmod = d.itmod
                             and a.ittran = d.ittran
                             and a.itsuc = d.itsuc
                             and a.itnrel = d.itnrel
                             and a.itord = 10
                             and (a.modulo, a.ittope) in
                                 (select tp1nro1, tp1nro2
                                    from fst198
                                   Where Tp1cod = 1
                                     and Tp1cod1 = 11105
                                     and Tp1corr1 = 26
                                     and Tp1corr2 = 1
                                     and Tp1corr3 > 0
                                     and Tp1nro3 = 2))
               group by d5.itfcon, d.ctnro
              union all
              select to_char(d5.itfcon, 'MM') mes,
                     to_char(d5.itfcon, 'month', 'nls_date_language=spanish') mest,
                     to_char(d5.itfcon, 'YYYY') year,
                     0 cantidad, --count(*) cantidad,
                     0 pago_cuota,
                     0 pago_interes,
                     0 pago_total,
                     0 bono, --
                     0 bono_interes, -- 
                     0 premio,
                     sum(d.itimp1) premio_interes,
                     d.ctnro cta --2018.08.08
                from fsd016 d, fsd015 d5
               where d.pgcod = 1
                 and d.itmod = 30
                 and d.ittran = 113
                 and d.itord = 21
                 and d.pgcod = d5.pgcod
                 and d.itsuc = d5.itsuc
                 and d.itmod = d5.itmod
                 and d.ittran = d5.ittran
                 and d.itnrel = d5.itnrel
                 and d5.itfcon >= pd_fecini --'29/05/2020' 
                 and d5.itfcon <= pd_fecfin --'29/05/2026'
                 and d5.itcorr = 0
                 and d5.itcont = 'S'
                 and 1 = (select count(*)
                            from fsd016 a
                           where a.pgcod = d.pgcod
                             and a.itmod = d.itmod
                             and a.ittran = d.ittran
                             and a.itsuc = d.itsuc
                             and a.itnrel = d.itnrel
                             and a.itord = 10
                             and (a.modulo, a.ittope) in
                                 (select tp1nro1, tp1nro2
                                    from fst198
                                   Where Tp1cod = 1
                                     and Tp1cod1 = 11105
                                     and Tp1corr1 = 26
                                     and Tp1corr2 = 1
                                     and Tp1corr3 > 0
                                     and Tp1nro3 = 2))
               group by d5.itfcon, d.ctnro
              union all -- obtengo de aqui el monto del bono.
              select to_char(d5.hfcon, 'MM') mes,
                     to_char(d5.hfcon, 'month', 'nls_date_language=spanish') mest,
                     to_char(d5.hfcon, 'YYYY') year,
                     0 cantidad,
                     0 pago_cuota,
                     0 pago_interes,
                     0 pago_total,
                     sum(d.hcimp1) bono, --
                     0 bono_interes, --
                     0 premio,
                     0 premio_interes,
                     d.hcta cta
                from fsh016 d, fsh015 d5
               where d.pgcod = 1
                 and d.hcmod = 30
                 and d.htran = 113
                 and d.hcord = 15
                 and d.pgcod = d5.pgcod
                 and d.hsucor = d5.hsucor
                 and d.hcmod = d5.hcmod
                 and d.htran = d5.htran
                 and d.hnrel = d5.hnrel
                 and d.hfcon = d5.hfcon
                 and d5.hccorr = 0
                    --and d5.hccaja='S'                    
                 and d5.hfcon >= pd_fecini --'29/05/2020'  
                 and d5.hfcon <= pd_fecfin --'29/05/2026'                     
                 and 1 = (select count(*)
                            from fsh016 a
                           where a.pgcod = d.pgcod
                             and a.hcmod = d.hcmod
                             and a.htran = d.htran
                             and a.hsucor = d.hsucor
                             and a.hnrel = d.hnrel
                             and a.hfcon = d.hfcon
                             and a.hcord = 10
                             and (a.hmodul, a.htoper) in
                                 (select tp1nro1, tp1nro2
                                    from fst198
                                   Where Tp1cod = 1
                                     and Tp1cod1 = 11105
                                     and Tp1corr1 = 26
                                     and Tp1corr2 = 1
                                     and Tp1corr3 > 0
                                     and Tp1nro3 = 2))
               group by d5.hfcon, d.hcta
              union all --Obtengo de aqui el interes del bono.
              select to_char(d5.hfcon, 'MM') mes,
                     to_char(d5.hfcon, 'month', 'nls_date_language=spanish') mest,
                     to_char(d5.hfcon, 'YYYY') year,
                     0 cantidad, --count(*) cantidad,
                     0 pago_cuota,
                     0 pago_interes,
                     0 pago_total,
                     0 bono, --
                     sum(d.hcimp1) bono_interes, -- 
                     0 premio,
                     0 premio_interes,
                     d.hcta cta --2018.08.08
                from fsh016 d, fsh015 d5
               where d.pgcod = 1
                 and d.hcmod = 30
                 and d.htran = 113
                 and d.hcord = 16
                 and d.pgcod = d5.pgcod
                 and d.hsucor = d5.hsucor
                 and d.hcmod = d5.hcmod
                 and d.htran = d5.htran
                 and d.hnrel = d5.hnrel
                 and d.hfcon = d5.hfcon
                 and d5.hfcon >= pd_fecini --'29/05/2020'  
                 and d5.hfcon <= pd_fecfin --'29/05/2026'
                 and d5.hccorr = 0
                 and 1 = (select count(*)
                            from fsh016 a
                           where a.pgcod = d.pgcod
                             and a.hcmod = d.hcmod
                             and a.htran = d.htran
                             and a.hsucor = d.hsucor
                             and a.hnrel = d.hnrel
                             and a.hfcon = d.hfcon
                             and a.hcord = 10
                             and (a.hmodul, a.htoper) in
                                 (select tp1nro1, tp1nro2
                                    from fst198
                                   Where Tp1cod = 1
                                     and Tp1cod1 = 11105
                                     and Tp1corr1 = 26
                                     and Tp1corr2 = 1
                                     and Tp1corr3 > 0
                                     and Tp1nro3 = 2))
              --and d5.hccaja='S'
               group by d5.hfcon, d.hcta
              union all
              select to_char(d5.hfcon, 'MM') mes,
                     to_char(d5.hfcon, 'month', 'nls_date_language=spanish') mest,
                     to_char(d5.hfcon, 'YYYY') year,
                     0 cantidad, --count(*) cantidad,
                     0 pago_cuota,
                     0 pago_interes,
                     0 pago_total,
                     0 bono, --
                     0 bono_interes, --
                     sum(d.hcimp1) premio,
                     0 premio_interes,
                     d.hcta cta --2018.08.08
                from fsh016 d, fsh015 d5
               where d.pgcod = 1
                 and d.hcmod = 30
                 and d.htran = 113
                 and d.hcord = 20
                 and d.pgcod = d5.pgcod
                 and d.hsucor = d5.hsucor
                 and d.hcmod = d5.hcmod
                 and d.htran = d5.htran
                 and d.hnrel = d5.hnrel
                 and d.hfcon = d5.hfcon
                 and d5.hfcon >= pd_fecini --'29/05/2020'
                 and d5.hfcon <= pd_fecfin --'29/05/2026'
                 and d5.hccorr = 0
                 and 1 = (select count(*)
                            from fsh016 a
                           where a.pgcod = d.pgcod
                             and a.hcmod = d.hcmod
                             and a.htran = d.htran
                             and a.hsucor = d.hsucor
                             and a.hnrel = d.hnrel
                             and a.hfcon = d.hfcon
                             and a.hcord = 10
                             and (a.hmodul, a.htoper) in
                                 (select tp1nro1, tp1nro2
                                    from fst198
                                   Where Tp1cod = 1
                                     and Tp1cod1 = 11105
                                     and Tp1corr1 = 26
                                     and Tp1corr2 = 1
                                     and Tp1corr3 > 0
                                     and Tp1nro3 = 2))
              --and d5.hccaja='S'
               group by d5.hfcon, d.hcta
              union all
              select to_char(d5.hfcon, 'MM') mes,
                     to_char(d5.hfcon, 'month', 'nls_date_language=spanish') mest,
                     to_char(d5.hfcon, 'YYYY') year,
                     0 cantidad, --count(*) cantidad,
                     0 pago_cuota,
                     0 pago_interes,
                     0 pago_total,
                     0 bono, --
                     0 bono_interes, -- 
                     0 premio,
                     sum(d.hcimp1) premio_interes,
                     d.hcta cta --2018.08.08
                from fsh016 d, fsh015 d5
               where d.pgcod = 1
                 and d.hcmod = 30
                 and d.htran = 113
                 and d.hcord = 21
                 and d.pgcod = d5.pgcod
                 and d.hsucor = d5.hsucor
                 and d.hcmod = d5.hcmod
                 and d.htran = d5.htran
                 and d.hnrel = d5.hnrel
                 and d.hfcon = d5.hfcon
                 and d5.hfcon >= pd_fecini --'29/05/2020' 
                 and d5.hfcon <= pd_fecfin --'29/05/2026'
                 and d5.hccorr = 0
                 and 1 = (select count(*)
                            from fsh016 a
                           where a.pgcod = d.pgcod
                             and a.hcmod = d.hcmod
                             and a.htran = d.htran
                             and a.hsucor = d.hsucor
                             and a.hnrel = d.hnrel
                             and a.hfcon = d.hfcon
                             and a.hcord = 10
                             and (a.hmodul, a.htoper) in
                                 (select tp1nro1, tp1nro2
                                    from fst198
                                   Where Tp1cod = 1
                                     and Tp1cod1 = 11105
                                     and Tp1corr1 = 26
                                     and Tp1corr2 = 1
                                     and Tp1corr3 > 0
                                     and Tp1nro3 = 2))
              --and d5.hccaja='S' 
               group by d5.hfcon, d.hcta) b
       group by b.mes, b.mest, b.year, b.cta;
    commit;
  
  end;
  ----------------------------------------------------------------------------------------

  function tiempo_aprobacion(instancia in number) return number as
    dias     number(17);
    min_apro date;
    max_apro date;
  begin
  
    begin
      select min(wfiteminit)
        into min_apro
        from wfwrkitems
       where wftaskcod = 11
         and wfinsprcid = instancia
         and rownum = 1;
    exception
      when no_data_found then
        min_apro := sysdate;
    end;
    begin
      select wfiteminit
        into max_apro
        from wfwrkitems
       where wftaskcod = 11
         and wfinsprcid = instancia
         and wfstscod = 'C'
         and rownum = 1;
    exception
      when no_data_found then
        select pgfape into max_apro from fst017 where pgcod = 1;
    end;
    begin
      dias := To_Date(max_apro, 'dd/mm/yyyy') -
              To_Date(min_apro, 'dd/mm/yyyy');
    end;
    if dias = 0 then
      dias := 1;
    end if;
    return dias;
  end;
  ------------------------------------------------------------------
  -- OBTENER ULTIMA CUOTA O CUOTA INCIAL EN CASO DE NO TENER NINGUN PAGO Y FECHA DEL SIGUIENTE PAGO.
  -- DEL CREDITO SELECCIONADO.
  ------------------------------------------------------------------
  procedure sp_cr_sig_cuota_credito(pgcod1    in xwf700.xwfempresa%type,
                                    sucursal  in xwf700.xwfsucursal%type,
                                    modulo    in xwf700.xwfmodulo%type,
                                    moneda    in xwf700.xwfmoneda%type,
                                    papel     in xwf700.xwfpapel%type,
                                    cuenta    in xwf700.xwfcuenta%type,
                                    operacion in xwf700.xwfoperacion%type,
                                    subope    in xwf700.xwfsubope%type,
                                    tipope    in xwf700.xwftipope%type,
                                    fecha     out fsd010.aofval%type,
                                    cuota     out fsd010.aoimp%type) is
    fec_cuo_pag fsd010.aofval%type;
    vi_cuota    fsd010.aoimp%type;
  
  begin
    --Verificar si pago alguna cuota.
    --Obtener la maxima fecha de pago.
    begin
      select max(ppfpag)
        into fec_cuo_pag
        from fsd602 d
       where d.pgcod = pgcod1
         and d.ppmod = modulo
         and d.ppsuc = sucursal
         and d.ppmda = moneda
         and d.pppap = papel
         and d.ppcta = cuenta
         and d.ppoper = operacion
         and d.ppsbop = subope
         and d.pptope = tipope
         and d.d602co = 'S';
    end;
    --En caso que haya pagado alguna cuota, obtener el monto de la siguiente cuota.
    if fec_cuo_pag is not null then
      begin
        select --(d.ppcap+d.ppint),
         ((d.ppcap + d.ppint) +
         (dd.ppimp11 + dd.ppimp12 + dd.ppimp13 + dd.ppimp14 + dd.ppimp15 +
         dd.ppimp16 + dd.ppimp17 + dd.ppimp18 + dd.ppimp19)),
         d.ppfpag
          into vi_cuota, fecha
          from fsd601 d
          left join fsd611 dd on dd.pgcod = d.pgcod
                             and dd.ppmod = d.ppmod
                             and dd.ppsuc = d.ppsuc
                             and dd.ppmda = d.ppmda
                             and dd.pppap = d.pppap
                             and dd.ppcta = d.ppcta
                             and dd.ppoper = d.ppoper
                             and dd.ppsbop = d.ppsbop
                             and dd.pptope = d.pptope
                             and dd.ppfpag = d.ppfpag
         where d.pgcod = pgcod1
           and d.ppmod = modulo
           and d.ppsuc = sucursal
           and d.ppmda = moneda
           and d.pppap = papel
           and d.ppcta = cuenta
           and d.ppoper = operacion
           and d.ppsbop = subope
           and d.pptope = tipope
           and d.ppfval = fec_cuo_pag --FECHA DEL PAGO OBTENIDO DE LA CONSULTA ANTERIOR.
           and d.d601co = 'S'
           and rownum = 1;
      end;
      --En caso que no haya pagado obtener el pago de la primera cuota.
    else
      begin
        select --(d.ppcap+d.ppint),
         ((d.ppcap + d.ppint) +
         (dd.ppimp11 + dd.ppimp12 + dd.ppimp13 + dd.ppimp14 + dd.ppimp15 +
         dd.ppimp16 + dd.ppimp17 + dd.ppimp18 + dd.ppimp19)),
         d.ppfpag
          into vi_cuota, fecha
          from fsd601 d
          left join fsd611 dd on dd.pgcod = d.pgcod
                             and dd.ppmod = d.ppmod
                             and dd.ppsuc = d.ppsuc
                             and dd.ppmda = d.ppmda
                             and dd.pppap = d.pppap
                             and dd.ppcta = d.ppcta
                             and dd.ppoper = d.ppoper
                             and dd.ppsbop = d.ppsbop
                             and dd.pptope = d.pptope
                             and dd.ppfpag = d.ppfpag
         where d.pgcod = pgcod1
           and d.ppmod = modulo
           and d.ppsuc = sucursal
           and d.ppmda = moneda
           and d.pppap = papel
           and d.ppcta = cuenta
           and d.ppoper = operacion
           and d.ppsbop = subope
           and d.pptope = tipope
           and d.d601co = 'S'
           and rownum = 1
         order by ppfpag asc;
      end;
    end if;
    cuota := vi_cuota;
  exception
    when others then
      cuota := 0;
  end sp_cr_sig_cuota_credito;

  ------------------------------------------------------------------
  -- OBTENER TL TIPO DE CREDITO ES DECIR SI ES UN CLIENTE CON CREDITO NUEVO O RECURRENTE.
  -- LA LOGICA ES SIMPLE SI TIENE MAS DE UN CREDITO VIGENTE O CANCELADO SE CONSIDERA RRECURRENTE
  -- CASO CONTRARIO ES NUEVO.
  ------------------------------------------------------------------
  PROCEDURE sp_cr_tipo_credito(v_pais    in fsr008.pepais%type,
                               v_petdoc  in fsr008.petdoc%type,
                               v_pendoc  in fsr008.pendoc%type,
                               tipo_cred out varchar) is
    vi_creditos number;
    cursor cuentas is
      select ctnro
        from fsr008 f8
       where f8.pgcod = 1
         and f8.pepais = v_pais
         and f8.petdoc = v_petdoc
         and f8.pendoc = v_pendoc
         and f8.cttfir = 'T';
  
  begin
    for x in cuentas loop
      begin
        select count(*)
          into vi_creditos
          from fsd010
         where Pgcod = 1
           and Aocta = x.ctnro
           and (Aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (108, 141)) or Aomod = 117);
      exception
        when no_data_found then
          vi_creditos := 0;
      end;
      begin
        if vi_creditos > 1 then
          tipo_cred := 'RECURRENTE';
        else
          tipo_cred := 'NUEVO';
        end if;
      end;
    
    end loop;
  end;
  ------------------------------------------------------------------
  -- VERIFICAR SI EL CREDITO ACTUAL A TENIDO CAMBIO DE AGENCIA. 
  -- EN CASO DE TENER CAMBIO SE DEVUELVE LA NUEVA SUCURSAL.
  ------------------------------------------------------------------
  procedure sp_cr_validar_cambio_age(ve_pgcod     in xwf700.xwfempresa%type,
                                     ve_sucurs    in xwf700.xwfsucursal%type,
                                     ve_modulo    in xwf700.xwfmodulo%type,
                                     ve_moneda    in xwf700.xwfmoneda%type,
                                     ve_papel     in xwf700.xwfpapel%type,
                                     ve_cuenta    in xwf700.xwfcuenta%type,
                                     ve_operacion in xwf700.xwfoperacion%type,
                                     ve_subope    in xwf700.xwfsubope%type,
                                     ve_tipope    in xwf700.xwftipope%type,
                                     vo_sucurdst  out xwf700.xwfsucursal%type,
                                     vo_sucurori  out xwf700.xwfsucursal%type,
                                     vo_flag_s    out varchar) is
    vi_corr_cambio number(10);
    flag_cambio_ag char(1);
  begin
  
    --SE VERIFICA SI EXISTE CAMBIO DE AGENCIA.     
    begin
      select 'S', s.sng130cor
        into flag_cambio_ag, vi_corr_cambio
        from sng131 s
       where s.sng131pgc = ve_pgcod
         and s.sng131mod = ve_modulo
            --and   s.sng131suc     = v_sucursal
         and s.sng131mda = ve_moneda
         and s.sng131pap = ve_papel
         and s.sng131cta = ve_cuenta
         and s.sng131ope = ve_operacion
         and s.sng131sbo = ve_subope
         and s.sng131top = ve_tipope
         and s.sng131con = 'S'
         and rownum = 1;
    exception
      when no_data_found then
        flag_cambio_ag := 'N';
    end;
  
    if flag_cambio_ag = 'S' then
      begin
        select sq.sng130suds, sq.sng130suor
          into vo_sucurdst, vo_sucurori
          from sng130 sq
         where sq.sng130cor = vi_corr_cambio;
      end;
    else
      vo_sucurori := ve_sucurs;
    end if;
    vo_flag_s := flag_cambio_ag;
  
  end sp_cr_validar_cambio_age;

  procedure sp_cr_pagos_bms(pn_ctnro  in number,
                            pd_fecini in date,
                            pd_fecfin in date,
                            pn_salbms out number,
                            pn_intbms out number) is
    ln_salbms number(17, 2);
    ln_intbms number(17, 2);
  begin
  
    pn_salbms := 0;
    pn_intbms := 0;
  
    begin
      select nvl(sum(d.itimp1), 0)
        into ln_salbms
        from fsd016 d, fsd015 d5
       where d.pgcod = 1
         and d.itmod = 30
         and d.ittran = 113
         and d.itord = 22
         and d.pgcod = d5.pgcod
         and d.itsuc = d5.itsuc
         and d.itmod = d5.itmod
         and d.ittran = d5.ittran
         and d.itnrel = d5.itnrel
         and d5.itfcon >= pd_fecini
         and d5.itfcon <= pd_fecfin
         and d5.itcorr = 0
         and d5.itcont = 'S'
         and d.ctnro = pn_ctnro
         and 1 = (select count(*)
                    from fsd016 a
                   where a.pgcod = d.pgcod
                     and a.itmod = d.itmod
                     and a.ittran = d.ittran
                     and a.itsuc = d.itsuc
                     and a.itnrel = d.itnrel
                     and a.itord = 10
                     and (a.modulo, a.ittope) in
                         (select tp1nro1, tp1nro2
                            from fst198
                           Where Tp1cod = 1
                             and Tp1cod1 = 11105
                             and Tp1corr1 = 26
                             and Tp1corr2 = 1
                             and Tp1corr3 > 0
                             and Tp1nro3 = 2));
      pn_salbms := pn_salbms + ln_salbms;
    exception
      when others then
        ln_salbms := 0;
    end;
  
    begin
      select nvl(sum(d.hcimp1), 0)
        into ln_salbms
        from fsh016 d, fsh015 d5
       where d.pgcod = 1
         and d.hcmod = 30
         and d.htran = 113
         and d.hcord = 22
         and d.pgcod = d5.pgcod
         and d.hsucor = d5.hsucor
         and d.hcmod = d5.hcmod
         and d.htran = d5.htran
         and d.hnrel = d5.hnrel
         and d.hfcon = d5.hfcon
         and d5.hccorr = 0
         and d5.hfcon >= pd_fecini
         and d5.hfcon <= pd_fecfin
         and d.hcta = pn_ctnro
         and 1 = (select count(*)
                    from fsh016 a
                   where a.pgcod = d.pgcod
                     and a.hcmod = d.hcmod
                     and a.htran = d.htran
                     and a.hsucor = d.hsucor
                     and a.hnrel = d.hnrel
                     and a.hfcon = d.hfcon
                     and a.hcord = 10
                     and (a.hmodul, a.htoper) in
                         (select tp1nro1, tp1nro2
                            from fst198
                           Where Tp1cod = 1
                             and Tp1cod1 = 11105
                             and Tp1corr1 = 26
                             and Tp1corr2 = 1
                             and Tp1corr3 > 0
                             and Tp1nro3 = 2));
      pn_salbms := pn_salbms + ln_salbms;
    exception
      when others then
        null;
    end;
  
    begin
      select nvl(sum(d.itimp1), 0)
        into ln_intbms
        from fsd016 d, fsd015 d5
       where d.pgcod = 1
         and d.itmod = 30
         and d.ittran = 113
         and d.itord = 23
         and d.pgcod = d5.pgcod
         and d.itsuc = d5.itsuc
         and d.itmod = d5.itmod
         and d.ittran = d5.ittran
         and d.itnrel = d5.itnrel
         and d5.itfcon >= pd_fecini
         and d5.itfcon <= pd_fecfin
         and d5.itcorr = 0
         and d5.itcont = 'S'
         and d.ctnro = pn_ctnro
         and 1 = (select count(*)
                    from fsd016 a
                   where a.pgcod = d.pgcod
                     and a.itmod = d.itmod
                     and a.ittran = d.ittran
                     and a.itsuc = d.itsuc
                     and a.itnrel = d.itnrel
                     and a.itord = 10
                     and (a.modulo, a.ittope) in
                         (select tp1nro1, tp1nro2
                            from fst198
                           Where Tp1cod = 1
                             and Tp1cod1 = 11105
                             and Tp1corr1 = 26
                             and Tp1corr2 = 1
                             and Tp1corr3 > 0
                             and Tp1nro3 = 2));
      pn_intbms := pn_intbms + ln_intbms;
    exception
      when others then
        ln_intbms := 0;
    end;
  
    begin
      select nvl(sum(d.hcimp1), 0)
        into ln_intbms
        from fsh016 d, fsh015 d5
       where d.pgcod = 1
         and d.hcmod = 30
         and d.htran = 113
         and d.hcord = 23
         and d.pgcod = d5.pgcod
         and d.hsucor = d5.hsucor
         and d.hcmod = d5.hcmod
         and d.htran = d5.htran
         and d.hnrel = d5.hnrel
         and d.hfcon = d5.hfcon
         and d5.hccorr = 0
         and d5.hfcon >= pd_fecini
         and d5.hfcon <= pd_fecfin
         and d.hcta = pn_ctnro
         and 1 = (select count(*)
                    from fsh016 a
                   where a.pgcod = d.pgcod
                     and a.hcmod = d.hcmod
                     and a.htran = d.htran
                     and a.hsucor = d.hsucor
                     and a.hnrel = d.hnrel
                     and a.hfcon = d.hfcon
                     and a.hcord = 10
                     and (a.hmodul, a.htoper) in
                         (select tp1nro1, tp1nro2
                            from fst198
                           Where Tp1cod = 1
                             and Tp1cod1 = 11105
                             and Tp1corr1 = 26
                             and Tp1corr2 = 1
                             and Tp1corr3 > 0
                             and Tp1nro3 = 2));
      pn_intbms := pn_intbms + ln_intbms;
    exception
      when others then
        null;
    end;
  
  exception
    when others then
      pn_salbms := 0;
      pn_intbms := 0;
  end sp_cr_pagos_bms;

end;
/

