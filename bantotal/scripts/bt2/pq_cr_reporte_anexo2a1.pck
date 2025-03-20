create or replace package PQ_CR_REPORTE_ANEXO2A1 is


  -- *****************************************************************
  -- Nombre                     : PQ_CR_REPORTE_ANEXO2A1
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 22/09/2023 14:57:31
  -- Autor de Creación          : LLATANPVARGAS Paola Vargas
  -- Uso                        : Anexos riesgos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  --
  --
  --
  -- *****************************************************************

  procedure sp_cargar_data_reporte_anexo2a1(p_fecproces in out date,
                                            p_anexo     in varchar2,
                                            p_usuario   in varchar2,
                                            p_respuesta out varchar2);

  procedure sp_copiar_param_period_anexo2a1(p_periodo   in number,
                                            p_anexo     in varchar2,
                                            p_usuario   in varchar2,
                                            p_respuesta out varchar2,
                                            p_resptexto out varchar2);
                                            
  procedure sp_validar_estado_periodo(p_periodo   in number,
                                      p_anexo     in varchar2,
                                      p_estado    out varchar2);

end PQ_CR_REPORTE_ANEXO2A1;
/

create or replace package body PQ_CR_REPORTE_ANEXO2A1 is

  procedure sp_cargar_data_reporte_anexo2a1(p_fecproces in out date,
                                            p_anexo     in varchar2,
                                            p_usuario   in varchar2,
                                            p_respuesta out varchar2) is
    v_error      varchar2(300);
    n_numeracion number(10);
    n_orden      number(10);
    n_sumacol19  number(17, 2);
    n_col19det1  number(17, 2);
    n_col19det2  number(17, 2);
    n_col19det3  number(17, 2);
    n_factajust  number(17, 6);
    n_limitglob  number(17, 6);
    
    v_valorpro   varchar2(2);
  begin
    --Limpieza de tabla temporal
    begin
      delete from aqpd101 a
       where a.aqpd101fec = p_fecproces
         and a.aqpd101usr = p_usuario;
      commit;
    exception
      when others then
        null;
    end;
    --Validamos que el proceso del periodo no este Cerrado
    begin
      pq_cr_reporte_anexo2a1.sp_validar_estado_periodo(to_char(p_fecproces,'rrrrmm'),p_anexo,v_valorpro);
    exception when others then
      v_valorpro := 'C';
    end;
    if v_valorpro = 'A' then
      --Invocamos al procedimiento de carga
      null;
      /*begin      
        dwhouse.pq_ries_anexos_reportes.SP_EJE_REP2A1@DW(p_fecproces);
      exception when others then
          v_error     := substr(SQLERRM, 1, 300);
          p_respuesta := 'N';
      end;*/
    end if;    
    --Cargamos el detalle 1 *****************************************************************************************************
    begin
      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101COD,
         AQPD101TEX,
         AQPD101PRI,
         AQPD101PON,
         AQPD101C01,
         AQPD101C02,
         AQPD101C03,
         AQPD101C04,
         AQPD101C05,
         AQPD101C06,
         AQPD101C07,
         AQPD101C08,
         AQPD101C09,
         AQPD101C10,
         AQPD101C11,
         AQPD101C12,
         AQPD101C13,
         AQPD101C14,
         AQPD101C141,
         AQPD101C15,
         AQPD101C16,
         AQPD101C17,
         AQPD101C18,
         AQPD101C19,
         AQPD101USR,
         AQPD101FECC,
         AQPD101HORC,
         AQPD101DET)
        SELECT orden,
               fecha,
               codigo,
               tipo_exposicion,
               ponderado,
               ponderado_valor,
               sum(nvl(col_1, 0)) col_1,
               sum(nvl(col_2, 0)) col_2,
               sum(nvl(col_3, 0)) col_3,
               sum(nvl(col_1, 0) - nvl(col_2, 0) + nvl(col_3, 0)) col4,
               sum(nvl(col_5, 0)) col_5,
               sum(nvl(col_6, 0)) col_6,
               sum(nvl(col_7, 0)) col_7,
               sum(nvl(col_8, 0)) col_8,
               sum(nvl(col_9, 0)) col_9,
               sum(nvl(col_10, 0)) col_10,
               sum(nvl(col_11, 0)) col_11,
               sum(nvl(col_12, 0)) col_12,
               sum((nvl(col_1, 0) - nvl(col_2, 0) + nvl(col_3, 0)) -
                   nvl(col_5, 0) + nvl(col_6, 0) + nvl(col_7, 0) +
                   nvl(col_8, 0) -
                   (nvl(col_10, 0) - nvl(col_11, 0) - nvl(col_12, 0))) col_13cal,
               sum(nvl(col_14, 0)) col_14,
               sum(nvl(col_14_1, 0)) col_14_1,
               sum(nvl(col_15, 0)) col_15,
               sum(nvl(col_16, 0)) col_16,
               sum(nvl(col_17, 0)) col_17,
               sum(((nvl(col_1, 0) - nvl(col_2, 0) + nvl(col_3, 0)) -
                   nvl(col_5, 0) + nvl(col_6, 0) + nvl(col_7, 0) +
                   nvl(col_8, 0) -
                   (nvl(col_10, 0) - nvl(col_11, 0) - nvl(col_12, 0))) -
                   nvl(col_14, 0) - 0.9 * nvl(col_14_1, 0) -
                   0.8 * nvl(col_15, 0) - 0.5 * nvl(col_16, 0)) col_18,
               sum((((nvl(col_1, 0) - nvl(col_2, 0) + nvl(col_3, 0)) -
                   nvl(col_5, 0) + nvl(col_6, 0) + nvl(col_7, 0) +
                   nvl(col_8, 0) -
                   (nvl(col_10, 0) - nvl(col_11, 0) - nvl(col_12, 0))) -
                   nvl(col_14, 0) - 0.9 * nvl(col_14_1, 0) -
                   0.8 * nvl(col_15, 0) - 0.5 * nvl(col_16, 0)) *
                   d.ponderado_valor * 1) col_19,
               p_usuario,
               trunc(SYSDATE),
               TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               1
          from dwhouse.FACT_RIES_2A1_REP@DW d
         where fecha = p_fecproces
           and codigo is not null
           and ind_seccion = 1
         group by orden,
                  fecha,
                  codigo,
                  tipo_exposicion,
                  ponderado,
                  ponderado_valor
         order by orden;
    
      Commit;
      p_respuesta := 'S';
    exception
      when others then
        v_error     := substr(SQLERRM, 1, 300);
        p_respuesta := 'N';
    end;
    --Cargamos el detalle 9    
    begin
      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101COD,
         AQPD101TEX,
         AQPD101C01,
         AQPD101C02,
         AQPD101USR,
         AQPD101FECC,
         AQPD101HORC,
         AQPD101DET)
        SELECT orden,
               nvl(d.fecha, p_fecproces),
               null,
               trim(tipo_exposicion),
               col_1,
               col_2,
               p_usuario,
               trunc(SYSDATE),
               TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               9
          from dwhouse.FACT_RIES_2A1_REP@DW d
         where fecha = p_fecproces
           and ind_seccion = 0
         Order by 1;
      Commit;
    exception
      when others then
        null;
    end;
    --Totales detalle 1
    begin
      SELECT AQPD101ORD, round(TO_NUMBER(trim(AQPD101COD), '999.99'), 0)
        into n_orden, n_numeracion
        from AQPD101
       where AQPD101FEC = p_fecproces
         --and AQPD101FECC = trunc(SYSDATE)
         and AQPD101USR = p_usuario
         and AQPD101DET = 1
         and AQPD101ORD = (select max(AQPD101ORD)
                             from aqpd101
                            where AQPD101FEC = p_fecproces
                              and AQPD101FECC = trunc(SYSDATE)
                              and AQPD101USR = p_usuario
                              and AQPD101DET = 1);
    exception
      when others then
        n_numeracion := 16;
    end;
    --Suma Columna 19
    begin
      SELECT round(SUM(AQPD101C19), 2)
        into n_sumacol19
        from AQPD101
       where AQPD101FEC = p_fecproces
         and AQPD101FECC = trunc(SYSDATE)
         and AQPD101USR = p_usuario
         and AQPD101DET = 1;
    exception
      when others then
        n_sumacol19 := 0;
    end;
    --Factor de Ajuste y Limite Global 
    begin
      SELECT round(AQPD101C01, 2)
        into n_factajust
        from AQPD101
       where AQPD101FEC = p_fecproces
         --and AQPD101FECC = trunc(SYSDATE)
         and AQPD101USR = p_usuario
         and AQPD101DET = 9
         and AQPD101TEX = 'FACTOR AJUSTE A';
    exception
      when others then
        n_factajust := 1;
    end;
    begin
      SELECT round(AQPD101C02, 2)
        into n_limitglob
        from AQPD101
       where AQPD101FEC = p_fecproces
         --and AQPD101FECC = trunc(SYSDATE)
         and AQPD101USR = p_usuario
         and AQPD101DET = 9
         and AQPD101TEX = 'LÍMITE GLOBAL';
    exception
      when others then
        n_limitglob := 0.09;
    end;
    --Calculos
    begin
       n_col19det1  := round(n_factajust * n_sumacol19, 2); 
       n_col19det2  := round(n_sumacol19 - n_col19det1, 2); 
       n_col19det3  := round(n_col19det2 * n_limitglob, 2);
    exception when others then
      n_col19det1 := 0;
      n_col19det2 := 0;
      n_col19det3 := 0;
    end;
    n_orden      := n_orden + 1;
    n_numeracion := n_numeracion + 1;
    
    begin
      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101COD,
         AQPD101TEX,
         AQPD101C19,
         AQPD101USR,
         AQPD101FECC,
         AQPD101HORC,
         AQPD101DET)
        SELECT n_orden,
               p_fecproces,
               n_numeracion,
               'EXPOSICIONES AJUSTADAS PONDERADAS POR RIESGO DE CRÉDITO SIN DEDUCIR PROVISIONES GENÉRICAS NO CONSIDERADAS EN PATRIMONIO EFECTIVO XVI',
               n_sumacol19,
               p_usuario,
               trunc(SYSDATE),
               TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               1
          from dual d;
      Commit;
    exception
      when others then
        v_error := substr(SQLERRM, 1, 300);
        DBMS_OUTPUT.put_line(v_error);
    end;
    --
    n_orden      := n_orden + 1;
    n_numeracion := n_numeracion + 1;
    begin
      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101COD,
         AQPD101TEX,
         AQPD101C19,
         AQPD101USR,
         AQPD101FECC,
         AQPD101HORC,
         AQPD101DET)
        SELECT n_orden,
               p_fecproces,
               n_numeracion,
               'Provisiones Genéricas no consideradas en el patrimonio efectivo XVII',
               n_col19det1,
               p_usuario,
               trunc(SYSDATE),
               TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               1
          from dual d;
      Commit;
    exception
      when others then
        null;
    end;
    --
    n_orden      := n_orden + 1;
    n_numeracion := n_numeracion + 1;
    begin
      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101COD,
         AQPD101TEX,
         AQPD101C19,
         AQPD101C20,
         AQPD101USR,
         AQPD101FECC,
         AQPD101HORC,
         AQPD101DET)
        SELECT n_orden,
               p_fecproces,
               n_numeracion,
               'TOTALES XVIII',
               n_col19det2,
               n_col19det3,
               p_usuario,
               trunc(SYSDATE),
               TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               1
          from dual d;
      Commit;
    exception
      when others then
        null;
    end;
    --Cargamos el detalle 2 *****************************************************************************************************
    begin
      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101COD,
         AQPD101TEX,
         AQPD101PRI,
         AQPD101PON,
         AQPD101C01,
         AQPD101C02,
         AQPD101C03,
         AQPD101C04,
         AQPD101C05,
         AQPD101C06,
         AQPD101C07,
         AQPD101C08,
         AQPD101C09,
         AQPD101C10,
         AQPD101C11,
         AQPD101C12,
         AQPD101C13,
         AQPD101C14,
         AQPD101C141,
         AQPD101C15,
         AQPD101C16,
         AQPD101C17,
         AQPD101C18,
         AQPD101C19,
         AQPD101USR,
         AQPD101FECC,
         AQPD101HORC,
         AQPD101DET)
        SELECT orden,
               fecha,
               codigo,
               null,
               ponderado,
               null,
               sum(nvl(col_1, 0)) col_1,
               sum(nvl(col_2, 0)) col_2,
               sum(nvl(col_3, 0)) col_3,
               sum(nvl(col_1, 0) - nvl(col_2, 0) + nvl(col_3, 0)) col4,
               sum(nvl(col_5, 0)) col_5,
               sum(nvl(col_6, 0)) col_6,
               sum(nvl(col_7, 0)) col_7,
               sum(nvl(col_8, 0)) col_8,
               sum(nvl(col_9, 0)) col_9,
               sum(nvl(col_10, 0)) col_10,
               sum(nvl(col_11, 0)) col_11,
               sum(nvl(col_12, 0)) col_12,
               sum((nvl(col_1, 0) - nvl(col_2, 0) + nvl(col_3, 0)) -
                   nvl(col_5, 0) + nvl(col_6, 0) + nvl(col_7, 0) +
                   nvl(col_8, 0) -
                   (nvl(col_10, 0) - nvl(col_11, 0) - nvl(col_12, 0))) col_13cal,
               sum(nvl(col_14, 0)) col_14,
               sum(nvl(col_14_1, 0)) col_14_1,
               sum(nvl(col_15, 0)) col_15,
               sum(nvl(col_16, 0)) col_16,
               sum(nvl(col_17, 0)) col_17,
               sum(nvl(col_18, 0)) col_18,
               sum(nvl(col_19, 0)) col_19,
               p_usuario,
               trunc(SYSDATE),
               TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               2
          from dwhouse.FACT_RIES_2A1_REP@DW d
         where fecha = p_fecproces
           and ind_seccion = 2
         group by orden, fecha, codigo, ponderado
         order by orden;
      Commit;
      p_respuesta := 'S';
    exception
      when others then
        v_error     := substr(SQLERRM, 1, 300);
        p_respuesta := 'N';
    end;
    --Totales detalle 2  
    --Suma Columna 18
    begin
      SELECT round(SUM(AQPD101C19), 2)
        into n_sumacol19
        from AQPD101
       where AQPD101FEC = p_fecproces
         and AQPD101USR = p_usuario
         and AQPD101DET = 2;
    exception
      when others then
        n_sumacol19 := 0;
    end;
    --Calculos
    begin
       n_col19det1  := round(n_factajust * n_sumacol19, 2); 
       n_col19det2  := round(n_sumacol19 - n_col19det1, 2); 
       n_col19det3  := round(n_col19det2 * n_limitglob, 2);
    exception when others then
      n_col19det1 := 0;
      n_col19det2 := 0;
      n_col19det3 := 0;
    end;
    --
    begin
      UPDATE AQPD101
         set AQPD101C19 = n_sumacol19
       where AQPD101FEC = p_fecproces
         and AQPD101USR = p_usuario
         and AQPD101DET = 2
         and AQPD101ORD = 37;
      Commit;
    exception
      when others then
        null;
    end;
    --
    begin
      UPDATE AQPD101
         set AQPD101C19 = n_col19det1
       where AQPD101FEC = p_fecproces
         and AQPD101USR = p_usuario
         and AQPD101DET = 2
         and AQPD101ORD = 38;
      Commit;
    exception
      when others then
        null;
    end;
    --
    begin
      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101PRI,
         AQPD101C19,
         AQPD101C20,
         AQPD101USR,
         AQPD101FECC,
         AQPD101HORC,
         AQPD101DET)
        SELECT 39,
               p_fecproces,
               'Totales',
               n_col19det2,
               n_col19det3,
               p_usuario,
               trunc(SYSDATE),
               TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               2
          from dual d;
      Commit;
    exception
      when others then
        v_error := substr(SQLERRM, 1, 300);
        DBMS_OUTPUT.put_line(v_error);
    end;
    --Cargamos el detalle 3 *****************************************************************************************************
    begin
      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101COD,
         AQPD101TEX,
         AQPD101PRI,
         AQPD101PON,
         AQPD101C01,
         AQPD101C02,
         AQPD101C03,
         AQPD101C04,
         AQPD101C05,
         AQPD101C06,
         AQPD101C07,
         AQPD101C08,
         AQPD101C09,
         AQPD101C10,
         AQPD101C11,
         AQPD101C12,
         AQPD101C13,
         AQPD101C14,
         AQPD101C141,
         AQPD101C15,
         AQPD101C16,
         AQPD101C17,
         AQPD101C18,
         AQPD101C19,
         AQPD101USR,
         AQPD101FECC,
         AQPD101HORC,
         AQPD101DET)
        SELECT orden,
               fecha,
               null,
               codigo,
               ponderado,
               null,
               sum(nvl(col_1, 0)) col_1,
               sum(nvl(col_2, 0)) col_2,
               sum(nvl(col_3, 0)) col_3,
               sum(nvl(col_1, 0) - nvl(col_2, 0) + nvl(col_3, 0)) col4,
               sum(nvl(col_5, 0)) col_5,
               sum(nvl(col_6, 0)) col_6,
               sum(nvl(col_7, 0)) col_7,
               sum(nvl(col_8, 0)) col_8,
               sum(nvl(col_9, 0)) col_9,
               sum(nvl(col_10, 0)) col_10,
               sum(nvl(col_11, 0)) col_11,
               sum(nvl(col_12, 0)) col_12,
               sum((nvl(col_1, 0) - nvl(col_2, 0) + nvl(col_3, 0)) -
                   nvl(col_5, 0) + nvl(col_6, 0) + nvl(col_7, 0) +
                   nvl(col_8, 0) -
                   (nvl(col_10, 0) - nvl(col_11, 0) - nvl(col_12, 0))) col_13cal,
               sum(nvl(col_14, 0)) col_14,
               sum(nvl(col_14_1, 0)) col_14_1,
               sum(nvl(col_15, 0)) col_15,
               sum(nvl(col_16, 0)) col_16,
               sum(nvl(col_17, 0)) col_17,
               sum(nvl(col_18, 0)) col_18,
               sum(nvl(col_19, 0)) col_19,
               p_usuario,
               trunc(SYSDATE),
               TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               3
          from dwhouse.FACT_RIES_2A1_REP@DW d
         where fecha = p_fecproces
           and ind_seccion = 3
         group by orden, fecha, codigo, ponderado
         order by orden;
      Commit;
      p_respuesta := 'S';
    exception
      when others then
        v_error     := substr(SQLERRM, 1, 300);
        p_respuesta := 'N';
    end;
    --Totales detalle 3
    --Suma Columna 18
    begin
      SELECT round(SUM(AQPD101C19), 2)
        into n_sumacol19
        from AQPD101
       where AQPD101FEC = p_fecproces
         and AQPD101USR = p_usuario
         and AQPD101DET = 3;
    exception
      when others then
        n_sumacol19 := 0;
    end;
    --Calculos
    begin
       n_col19det1  := round(n_factajust * n_sumacol19, 2); 
       n_col19det2  := round(n_sumacol19 - n_col19det1, 2); 
       n_col19det3  := round(n_col19det2 * n_limitglob, 2);
    exception when others then
      n_col19det1 := 0;
      n_col19det2 := 0;
      n_col19det3 := 0;
    end;
    --
    begin
      UPDATE AQPD101
         set AQPD101C19 = n_sumacol19
       where AQPD101FEC = p_fecproces
         and AQPD101USR = p_usuario
         and AQPD101DET = 3
         and AQPD101ORD = 17;
      Commit;
    exception
      when others then
        null;
    end;
    --
    begin
      UPDATE AQPD101
         set AQPD101C19 = n_col19det1
       where AQPD101FEC = p_fecproces
         and AQPD101USR = p_usuario
         and AQPD101DET = 3
         and AQPD101ORD = 18;
      Commit;
    exception
      when others then
        null;
    end;
    --
    begin
      UPDATE AQPD101
         set AQPD101C19 = n_col19det2,
             AQPD101C20 = n_col19det3  
       where AQPD101FEC = p_fecproces
         and AQPD101USR = p_usuario
         and AQPD101DET = 3
         and AQPD101ORD = 19;
      Commit;
    exception
      when others then
        null;
    end;
    /*begin
      INSERT INTO AQPD101
        (AQPD101ORD,
         AQPD101FEC,
         AQPD101PRI,
         AQPD101C18,
         AQPD101C19,
         AQPD101USR,
         AQPD101FECC,
         AQPD101DET)
        SELECT 19,
               p_fecproces,
               'Totales',
               round(n_sumacol18 - round(n_factajust * n_sumacol18, 2), 2),
               round(round(n_sumacol18 -
                           round(n_factajust * n_sumacol18, 2),
                           2) * n_limitglob,
                     2),
               p_usuario,
               trunc(SYSDATE),
               3
          from dual d;
      Commit;
    exception
      when others then
        v_error := substr(SQLERRM, 1, 300);
        DBMS_OUTPUT.put_line(v_error);
    end;*/
  end sp_cargar_data_reporte_anexo2a1;

  procedure sp_copiar_param_period_anexo2a1(p_periodo   in number,
                                            p_anexo     in varchar2,
                                            p_usuario   in varchar2,
                                            p_respuesta out varchar2,
                                            p_resptexto out varchar2) is
    v_error       varchar2(300);
    n_periodo_ant number(8);
    n_anio        number(4);
    n_mes         number(2);
    n_cant        number(5);
    v_valorpro    varchar2(2);
  begin
    --Limpieza de tabla temporal
    begin
      delete from aqpd102 a
       where a.aqpd102per = p_periodo
         and a.aqpd102anx = p_anexo;
      commit;
    exception
      when others then
        null;
    end;
    --obtener periodo anterior
    begin
      SELECT CASE
               WHEN TO_NUMBER(SUBSTR(TO_CHAR(p_periodo), 5, 2)) = 1 THEN
                TO_NUMBER(SUBSTR(TO_CHAR(p_periodo), 1, 4)) - 1
               ELSE
                TO_NUMBER(SUBSTR(TO_CHAR(p_periodo), 1, 4))
             END AS anio_anterior,
             CASE
               WHEN TO_NUMBER(SUBSTR(TO_CHAR(p_periodo), 5, 2)) = 1 THEN
                12
               ELSE
                TO_NUMBER(SUBSTR(TO_CHAR(p_periodo), 5, 2)) - 1
             END AS mes_anterior
        INTO n_anio, n_mes
        FROM dual;
    exception
      when others then
        p_respuesta := 'N';
        p_resptexto := 'Error al cargar el periodo anterior.';
        return;
    end;
    n_periodo_ant := n_anio * 100 + n_mes;
    begin
      select count(*)
        into n_cant
        from AQPD102
       where AQPD102PER = n_periodo_ant
         AND AQPD102ANX = p_anexo;
    exception
      when others then
        p_respuesta := 'N';
        p_resptexto := 'Error al cargar el periodo anterior.';
        return;
    end;
    if n_cant > 0 then
      begin
        INSERT INTO AQPD102
          (AQPD102PER,
           AQPD102ANX,
           AQPD102CTP,
           AQPD102DTP,
           AQPD102COR,
           AQPD102CVA,
           AQPD102VAL,
           AQPD102VLN,
           AQPD102VLP,
           AQPD102VDE,
           AQPD102DFE,
           AQPD102HOJ,
           AQPD102CA1,
           AQPD102CA2,
           AQPD102CA3,
           AQPD102WH1,
           AQPD102CA4,
           AQPD102CA5,
           AQPD102CA6,
           AQPD102CA7,
           AQPD102CA8,
           AQPD102CA9,
           AQPD102CA10,
           AQPD102CA11,
           AQPD102CA12,
           AQPD102CA13,
           AQPD102CA14,
           AQPD102CA141,
           AQPD102CA15,
           AQPD102CA16,
           AQPD102CA17,
           AQPD102CVL1,
           AQPD102CVL2,
           AQPD102CVL3,
           AQPD102CREP,
           AQPD102RPC1,
           AQPD102RPC2,
           AQPD102CSBS,
           AQPD102USRA,
           AQPD102FECA,
           AQPD102HORA)
          SELECT p_periodo,
                 p_anexo,
                 AQPD102CTP,
                 AQPD102DTP,
                 AQPD102COR,
                 AQPD102CVA,
                 AQPD102VAL,
                 AQPD102VLN,
                 AQPD102VLP,
                 AQPD102VDE,
                 AQPD102DFE,
                 AQPD102HOJ,
                 AQPD102CA1,
                 AQPD102CA2,
                 AQPD102CA3,
                 AQPD102WH1,
                 AQPD102CA4,
                 AQPD102CA5,
                 AQPD102CA6,
                 AQPD102CA7,
                 AQPD102CA8,
                 AQPD102CA9,
                 AQPD102CA10,
                 AQPD102CA11,
                 AQPD102CA12,
                 AQPD102CA13,
                 AQPD102CA14,
                 AQPD102CA141,
                 AQPD102CA15,
                 AQPD102CA16,
                 AQPD102CA17,
                 AQPD102CVL1,
                 AQPD102CVL2,
                 AQPD102CVL3,
                 AQPD102CREP,
                 AQPD102RPC1,
                 AQPD102RPC2,
                 AQPD102CSBS,
                 p_usuario,
                 TRUNC(SYSDATE),
                 TO_CHAR(SYSDATE, 'HH24:MI:SS')
            FROM AQPD102
           WHERE AQPD102PER = n_periodo_ant
             AND AQPD102ANX = p_anexo;
        commit;
        --actualiza el estado como A
        UPDATE AQPD102 SET AQPD102VAL = 'A'
           WHERE AQPD102PER = p_periodo
             AND AQPD102ANX = p_anexo
             AND AQPD102CTP = 0; 
        commit;
        p_respuesta := 'S';
        p_resptexto := 'OK.';
      exception
        when others then
          v_error     := substr(SQLERRM, 1, 300);
          p_respuesta := 'N';
          p_resptexto := 'Error al cargar el periodo anterior.';
      end;
    else
      p_respuesta := 'N';
      p_resptexto := 'El periodo anterior no tiene registros.';
    end if;
  end sp_copiar_param_period_anexo2a1;

  procedure sp_validar_estado_periodo(p_periodo   in number,
                                      p_anexo     in varchar2,
                                      p_estado    out varchar2) is
                                      
  begin
    begin
      select AQPD102VAL into p_estado 
         from AQPD102
         where AQPD102PER = p_periodo
           and AQPD102ANX = p_anexo
           and AQPD102CTP = 0
           and rownum = 1;
      /*select vvalor into v_valorpro from dwhouse.prm_anxrep@DW
         where nperiod = to_number(to_char(p_fecproces,'rrrrmm'))
           and vcodanx = 'ANEXO2A1' 
           and ncodtip = 0
           and rownum = 1;*/
    exception when others then
      p_estado := 'C';
    end;                                  
  end sp_validar_estado_periodo; 
                                     
end PQ_CR_REPORTE_ANEXO2A1;
/

