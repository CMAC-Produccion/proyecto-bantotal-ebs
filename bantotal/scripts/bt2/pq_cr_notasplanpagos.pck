create or replace package pq_cr_notasplanpagos is

  -- Author  : GCARRANZAS
  -- Created : 15/03/2021 13:46:04
  -- Purpose : Agregar notas de pie al plan de pagos

  procedure sp_validarcapitalizacion(v_pgcod      in number,
                                     v_Scmod      in number,
                                     v_Scsuc      in number,
                                     v_Scmda      in number,
                                     v_Scpap      in number,
                                     v_Sccta      in number,
                                     v_Scoper     in number,
                                     v_Scsbop     in number,
                                     v_Sctope     in number,
                                     pn_respuesta out number);

  procedure sp_validartasareduccion(v_pgcod      in number,
                                    v_Scmod      in number,
                                    v_Scsuc      in number,
                                    v_Scmda      in number,
                                    v_Scpap      in number,
                                    v_Sccta      in number,
                                    v_Scoper     in number,
                                    v_Scsbop     in number,
                                    v_Sctope     in number,
                                    pn_respuesta out number,
                                    pn_tasa      out number);

  -- Author  : GCARRANZAS
  -- Created : 12/04/2021
  -- Purpose : Validar aprobacion              
  procedure sp_validaraprobacion(v_pgcod      in number,
                                 v_Scmod      in number,
                                 v_Scsuc      in number,
                                 v_Scmda      in number,
                                 v_Scpap      in number,
                                 v_Sccta      in number,
                                 v_Scoper     in number,
                                 v_Scsbop     in number,
                                 v_Sctope     in number,
                                 pn_respuesta out number);

end pq_cr_notasplanpagos;
/

create or replace package body pq_cr_notasplanpagos is

  procedure sp_validarcapitalizacion(v_pgcod      in number,
                                     v_Scmod      in number,
                                     v_Scsuc      in number,
                                     v_Scmda      in number,
                                     v_Scpap      in number,
                                     v_Sccta      in number,
                                     v_Scoper     in number,
                                     v_Scsbop     in number,
                                     v_Sctope     in number,
                                     pn_respuesta out number) is
  begin
    begin
      SELECT 1
        into pn_respuesta
        FROM LEY31050 L --usrwebcrm.LEY31050 L
       INNER JOIN LEY31050_CREDITOSFACILIDAD F
          ON L.IDLEY31050 = F.IDLEY31050
       WHERE L.TIPOFACILIDAD = 'CAJA'
         AND (F.facilidad like 'Exonera%' or F.facilidad like 'Amortiza%')
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             v_Sccta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = v_Scoper
         AND F.EMPRESA = v_pgcod
         AND F.SUCURSAL = v_Scsuc
         AND F.MODULO = v_Scmod
         AND F.MONEDA = v_Scmda
         AND F.PAPEL = v_Scpap
         AND F.SUBOPERACION = v_Scsbop
         AND F.TIPOOPERACION = v_Sctope
         AND EXISTS (SELECT *
                FROM FST198 G
               WHERE G.TP1COD = 1
                 AND G.TP1COD1 = 11138
                 AND G.TP1CORR1 = 16
                 AND G.TP1CORR2 > 0
                 AND G.TP1CORR3 > 0
                 AND G.TP1NRO1 = 1
                 AND TRIM(G.TP1DESC) = TRIM(L.ESTADOSOLICITUD));
    exception
      when no_data_found then
        pn_respuesta := 0;
    end;
  
    If pn_respuesta = 1 then
      begin
        -- Validar reprogramacion bantotal
        pq_cr_notasplanpagos.sp_validaraprobacion(v_pgcod      => v_pgcod,
                                                  v_scmod      => v_scmod,
                                                  v_scsuc      => v_scsuc,
                                                  v_scmda      => v_scmda,
                                                  v_scpap      => v_scpap,
                                                  v_sccta      => v_sccta,
                                                  v_scoper     => v_scoper,
                                                  v_scsbop     => v_scsbop,
                                                  v_sctope     => v_sctope,
                                                  pn_respuesta => pn_respuesta);
      end;
    end if;
  
  end sp_validarcapitalizacion;

  procedure sp_validartasareduccion(v_pgcod      in number,
                                    v_Scmod      in number,
                                    v_Scsuc      in number,
                                    v_Scmda      in number,
                                    v_Scpap      in number,
                                    v_Sccta      in number,
                                    v_Scoper     in number,
                                    v_Scsbop     in number,
                                    v_Sctope     in number,
                                    pn_respuesta out number,
                                    pn_tasa      out number) is
  begin
    pn_respuesta := 0;
    pn_tasa      := 0.00;
    begin
      SELECT 1, F.NUEVATASA
        into pn_respuesta, pn_tasa
        FROM LEY31050 L --usrwebcrm.LEY31050 L
       INNER JOIN LEY31050_CREDITOSFACILIDAD F
          ON L.IDLEY31050 = F.IDLEY31050
       WHERE L.TIPOFACILIDAD = 'CAJA'
         AND (UPPER(F.facilidad) like 'REDUC%' or UPPER(f.facilidad) like '%JUNTOS%') --28.10.2021 Se Agrego Juntos para incluir reduccion de tasa Soluc. Juntos
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             v_Sccta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = v_Scoper
         AND F.EMPRESA = v_pgcod
         AND F.SUCURSAL = v_Scsuc
         AND F.MODULO = v_Scmod
         AND F.MONEDA = v_Scmda
         AND F.PAPEL = v_Scpap
         AND F.SUBOPERACION = v_Scsbop
         AND F.TIPOOPERACION = v_Sctope
         AND EXISTS (SELECT *
                FROM FST198 G
               WHERE G.TP1COD = 1
                 AND G.TP1COD1 = 11138
                 AND G.TP1CORR1 = 16
                 AND G.TP1CORR2 > 0
                 AND G.TP1CORR3 > 0
                 AND G.TP1NRO1 = 1
                 AND TRIM(G.TP1DESC) = TRIM(L.ESTADOSOLICITUD));
    exception
      when no_data_found then
        pn_respuesta := 0;
        pn_tasa      := 0.00;
    end;
  
    If pn_respuesta = 1 then
      begin
        -- Validar reprogramacion bantotal
        pq_cr_notasplanpagos.sp_validaraprobacion(v_pgcod      => v_pgcod,
                                                  v_scmod      => v_scmod,
                                                  v_scsuc      => v_scsuc,
                                                  v_scmda      => v_scmda,
                                                  v_scpap      => v_scpap,
                                                  v_sccta      => v_sccta,
                                                  v_scoper     => v_scoper,
                                                  v_scsbop     => v_scsbop,
                                                  v_sctope     => v_sctope,
                                                  pn_respuesta => pn_respuesta);
      end;
    end if;
  end sp_validartasareduccion;
  procedure sp_validaraprobacion(v_pgcod      in number,
                                 v_Scmod      in number,
                                 v_Scsuc      in number,
                                 v_Scmda      in number,
                                 v_Scpap      in number,
                                 v_Sccta      in number,
                                 v_Scoper     in number,
                                 v_Scsbop     in number,
                                 v_Sctope     in number,
                                 pn_respuesta out number) is
  
    vl_aqpb561 number;
    vl_jaqa400 number;
    vl_aqpb556 number;
  begin
    pn_respuesta := 0;
    begin
      select 1
        into vl_aqpb561
        from aqpb561
       where aqpb561emp = v_pgcod
         and aqpb561mod = v_Scmod
         and aqpb561suc = v_Scsuc
         and aqpb561mda = v_Scmda
         and aqpb561pap = v_Scpap
         and aqpb561cta = v_Sccta
         and aqpb561oper = v_Scoper
         and aqpb561sbop = v_Scsbop
         and aqpb561top = v_Sctope
         and aqpb561est = 'A'
         and aqpb561ehab = 'H'
         and aqpb561fecr = (select max(aqpb561fecr)
                              from aqpb561
                             where aqpb561emp = v_pgcod
                               and aqpb561mod = v_Scmod
                               and aqpb561suc = v_Scsuc
                               and aqpb561mda = v_Scmda
                               and aqpb561pap = v_Scpap
                               and aqpb561cta = v_Sccta
                               and aqpb561oper = v_Scoper
                               and aqpb561sbop = v_Scsbop
                               and aqpb561top = v_Sctope
                               and aqpb561ehab = 'H');
    exception
      when no_data_found then
        vl_aqpb561 := 0;
    end;
  
    begin
      select 1
        into vl_aqpb556
        from aqpb556
       where aqpb556emp = v_pgcod
         and aqpb556mod = v_Scmod
         and aqpb556suc = v_Scsuc
         and aqpb556mda = v_Scmda
         and aqpb556pap = v_Scpap
         and aqpb556cta = v_Sccta
         and aqpb556oper = v_Scoper
         and aqpb556sbop = v_Scsbop
         and aqpb556top = v_Sctope
         and aqpb556est in( 'A', 'P') --SE AGREGO P, PARA LAS PRUEBAS QUITAR 17.08.2021
         and aqpb556ehab = 'H'
         and aqpb556fecr = (select max(aqpb556fecr)
                              from aqpb556
                             where aqpb556emp = v_pgcod
                               and aqpb556mod = v_Scmod
                               and aqpb556suc = v_Scsuc
                               and aqpb556mda = v_Scmda
                               and aqpb556pap = v_Scpap
                               and aqpb556cta = v_Sccta
                               and aqpb556oper = v_Scoper
                               and aqpb556sbop = v_Scsbop
                               and aqpb556top = v_Sctope
                               and aqpb556ehab = 'H');
    exception
      when no_data_found then
        vl_aqpb556 := 0;
    end;
  
    begin
      select 1
        into vl_jaqa400
        from jaqa400
       where jaqa400emp = v_pgcod
         and jaqa400mod = v_Scmod
         and jaqa400suc = v_Scsuc
         and jaqa400mda = v_Scmda
         and jaqa400pap = v_Scpap
         and jaqa400cta = v_Sccta
         and jaqa400ope = v_Scoper
         and jaqa400sbo = v_Scsbop
         and jaqa400top = v_Sctope
         and jaqa400est IN ('C','A') --SE AGREGO A, PARA LAS PRUEBAS QUITAR 17.08.2021
         and jaqa400fec = (select max(jaqa400fec)
                             from jaqa400
                            where jaqa400emp = v_pgcod
                              and jaqa400mod = v_Scmod
                              and jaqa400suc = v_Scsuc
                              and jaqa400mda = v_Scmda
                              and jaqa400pap = v_Scpap
                              and jaqa400cta = v_Sccta
                              and jaqa400ope = v_Scoper
                              and jaqa400sbo = v_Scsbop
                              and jaqa400top = v_Sctope);
    exception
      when no_data_found then
        vl_jaqa400 := 0;
    end;
  
    If vl_aqpb561 = 1 AND vl_aqpb556 = 1 AND vl_jaqa400 = 1 THEN
      pn_respuesta := 1;
    End If;
  
  end sp_validaraprobacion;
end pq_cr_notasplanpagos;
/

