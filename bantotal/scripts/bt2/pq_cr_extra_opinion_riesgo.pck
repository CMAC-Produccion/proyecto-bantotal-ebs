create or replace package PQ_CR_EXTRA_OPINION_RIESGO is

  -- *****************************************************************
  -- Nombre                     : PAQUETE PARA OPINION DE RIESGOS CRM
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 15/06/2023 08:41:21
  -- Autor de Creación          : APACHECOH
  -- Uso                        : Realiza cálculos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 17/11/2023
  -- Autor de Modificación      : APACHECOH
  -- Descripción de Modificación: Cambios en proceso del reporte
  -- Fecha de Modificación      : 11/12/2023
  -- Autor de Modificación      : RCASTRO
  -- Descripción de Modificación: Se agregaron nuevos Campos en el reporte    
  -- Fecha de Modificación      : 18/12/2023
  -- Autor de Modificación      : RCASTRO
  -- Descripción de Modificación: Se agrega campo año    
  -- Fecha de Modificación      : 20/02/2024
  -- Autor de Modificación      : APACHECOH
  -- Descripción de Modificación: Modificación para considerar solicitudes pendientes
  -- Fecha de Modificación      : 02/04/2024
  -- Autor de Modificación      : APACHECOH
  -- Descripción de Modificación: Modificación para considerar operacion en reporte     
  -- Fecha de Modificación      : 01/10/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se cambia logica para obtener tipo de reprogramacion  
  -- Fecha de Modificación      : 07/11/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se cambia descripcion para tipo de flujo: flujo sin capitalizacion
  -- Fecha de Modificación      : 03/12/2024
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se cambia niveles de aprobacion de opinion 
  -- Fecha de Modificación      : 10/01/2025
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se modifica arbol de aprobacion y autonomias  
  -- *****************************************************************
  -----------------------------------------------------------------------

  procedure sp_cr_grabar_asignacion_usuarios(p_n_region  in number,
                                             p_n_zona    in number,
                                             p_n_sucurs  in number,
                                             p_v_usuAct  in varchar2,
                                             p_v_usuCamb in varchar2,
                                             p_v_usuario in varchar2,
                                             p_v_mensaje in varchar2,
                                             p_v_flag    in varchar2);

  procedure sp_cr_reporte_opinion_riesgo(p_d_fecini  in date,
                                         p_d_fecfin  in date,
                                         p_v_usuario in varchar2,
                                         p_v_flag    out varchar2);

end PQ_CR_EXTRA_OPINION_RIESGO;
/

create or replace package body PQ_CR_EXTRA_OPINION_RIESGO is

  procedure sp_cr_grabar_asignacion_usuarios(p_n_region  in number,
                                             p_n_zona    in number,
                                             p_n_sucurs  in number,
                                             p_v_usuAct  in varchar2,
                                             p_v_usuCamb in varchar2,
                                             p_v_usuario in varchar2,
                                             p_v_mensaje in varchar2,
                                             p_v_flag    in varchar2) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_grabar_asignacion_usuarios
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.06.06
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Busca datos consulta buro
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : p_n_zona ( Codigo de Zona )
    --                              p_n_sucurs ( Codigo de Sucursal )
    --                              p_v_usuario ( Codigo de Usuario )
    --                              p_v_flag ( Flag Zona o Sucursal )
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 03/12/2024
    -- Autor de la Modificación   : Rcastro
    -- Descripción de Modificación: Se cambia logica para obtener los aprobadores
    -- ***************************************************************** 
    p_v_estado varchar2(10);
    p_v_mssnje varchar2(300);
    p_v_region varchar2(70);
    p_v_zonari varchar2(70);
    p_v_sucurs varchar2(70);
    p_v_usuacZ varchar2(10);
  begin
    --region
    begin
      select trim(tp1desc)
        into p_v_region
        from fst198
       where Tp1cod = 1
         and Tp1cod1 = 10872
         and Tp1corr1 = 11
         and Tp1corr2 > 0
         and Tp1corr3 = 0
         and Tp1nro1 = p_n_region
         and rownum = 1;
      p_v_region := 'REGION ' || p_v_region;
    exception
      when others then
        p_v_region := '';
    end;
    --zona
    begin
      select trim(tp1desc)
        into p_v_zonari
        from fst198
       where Tp1cod = 1
         and Tp1cod1 = 11152
         and Tp1corr1 = 11
         and Tp1corr2 = 8
         and Tp1corr3 > 0
         and Tp1nro3 = p_n_zona;
    exception
      when others then
        p_v_zonari := '';
    end;
    --sucursal
    begin
      select trim(scnom)
        into p_v_sucurs
        from fst001
       where pgcod = 1
         and sucurs = p_n_sucurs;
    exception
      when others then
        null;
    end;
    --Validar si la actualización es por Zona o por Sucursal    
    if p_v_flag = 'S' then
      --Usuario Actual       
      begin
        select trim(tp1desc)
          into p_v_usuacZ
          from fst198
         Where Tp1cod = 1
           and Tp1cod1 = 11152
           and Tp1corr1 = 11
           and Tp1corr2 = 7
           and Tp1corr3 > 0
           and Tp1nro2 = p_n_zona
           and rownum = 1;
      exception
        when others then
          null;
      end;
      begin
        update fst198
           set Tp1desc = p_v_usuCamb
         Where Tp1cod = 1
           and Tp1cod1 = 11152
           and Tp1corr1 = 11
           and Tp1corr2 = 7
           and Tp1corr3 > 0
           and Tp1nro2 = p_n_zona;
        commit;
        p_v_estado := 'OK';
        p_v_mssnje := p_v_mensaje;
      exception
        when others then
          p_v_estado := 'ERR';
          p_v_mssnje := trim(SUBSTR(SQLERRM, 1, 300));
      end;
    else
      p_v_usuacZ := p_v_usuAct;
      begin
        update fst198
           set Tp1desc = p_v_usuCamb
         Where Tp1cod = 1
           and Tp1cod1 = 11152
           and Tp1corr1 = 11
           and Tp1corr2 = 7
           and Tp1corr3 > 0
           and Tp1nro2 = p_n_zona
           and Tp1nro3 = p_n_sucurs;
        commit;
        p_v_estado := 'OK';
        p_v_mssnje := p_v_mensaje;
      exception
        when others then
          p_v_estado := 'ERR';
          p_v_mssnje := trim(SUBSTR(SQLERRM, 1, 300));
      end;
    end if;
    --grabar log
    begin
      insert into AQPB950
        (AQPB950FECC,
         AQPB950HORC,
         AQPB950USRC,
         AQPB950USUA,
         AQPB950USUM,
         AQPB950REGC,
         AQPB950REGD,
         AQPB950ZONC,
         AQPB950ZOND,
         AQPB950SUCC,
         AQPB950SUCD,
         AQPB950EST,
         AQPB950MSG,
         AQPB950AUX2)
        select /*+all rows*/
         TRUNC(SYSDATE) FechaCambio,
         TO_CHAR(SYSDATE, 'HH24:MI:SS') HoraCambio,
         p_v_usuario UsuarioEjecuta,
         p_v_usuacZ UsuarioActual,
         p_v_usuCamb UsuarioCambio,
         p_n_region CodRegion,
         p_v_region DesRegion,
         p_n_zona CodZona,
         p_v_zonari DesZona,
         p_n_sucurs CodAgencia,
         p_v_sucurs DesSucurs,
         p_v_estado EstadoGrabar,
         p_v_mssnje MensajeGrabar,
         p_v_flag Flag
          from dual;
      commit;
    exception
      when others then
        null;
    end;
  
  end sp_cr_grabar_asignacion_usuarios;

  procedure sp_cr_reporte_opinion_riesgo(p_d_fecini  in date,
                                         p_d_fecfin  in date,
                                         p_v_usuario in varchar2,
                                         p_v_flag    out varchar2) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_reporte_opinion_riesgo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.06.23
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Busca datos consulta buro
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : p_d_fecini ( Fecha Inicio )
    --                              p_d_fecfin ( Fecha Fin )
    --                              p_v_usuario ( Codigo de Usuario )
    --                              p_v_flag ( Flag Rpta )
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 2024.02.20
    -- Autor de la Modificación   : APACHECOH
    -- Descripción de Modificación: Modificación para considerar solicitudes pendientes 
    -- ***************************************************************** 
    pv_msgerr varchar(500);
  
    /*cursor reporte_temporal(c_usuario varchar2) is
    select * from AQPB949 
    where AQPB949USRC = c_usuario
      and AQPB949FECC = TRUNC(SYSDATE);*/
  begin
    --Limpiamos la data por usuario
    begin
      delete from AQPB949
       where AQPB949USRC = p_v_usuario
         and AQPB949FECC = TRUNC(SYSDATE);
      commit;
    exception
      when others then
        null;
    end;
    --Grabamos la tabla
    begin
      insert into AQPB949
        (AQPB949FECC,
         AQPB949HORC,
         AQPB949USRC,
         AQPB949FECI,
         AQPB949FECF,
         AQPB949CODOPI,
         AQPB949INST,
         AQPB949BNDJ,
         AQPB949USR,
         AQPB949EST,
         AQPB949ESTD,
         AQPB949FECE,
         AQPB949HORE,
         AQPB949FECS,
         AQPB949HORS,
         AQPB949TSOL,
         AQPB949TSLD,
         AQPB949CTA,
         AQPB949TDOC,
         AQPB949NDOC,
         AQPB949CLIE,
         AQPB949MNTO,
         AQPB949RESP,
         AQPB949ANL,
         AQPB949ANLR,
         AQPB949AGE,
         AQPB949ZON,
         AQPB949REG,
         AQPB949MOD,
         AQPB949MODD,
         AQPB949TOPE,
         AQPB949TOPD,
         AQPB949FLJ,
         AQPB949OBS,
         AQPB949RCONS,
         AQPB949ANIO,
         AQPB949OPER)
        SELECT /*+all rows*/
         TRUNC(SYSDATE) FechaConsulta,
         TO_CHAR(SYSDATE, 'HH24:MI:SS') HoraConsulta,
         p_v_usuario UsuarioConsulta,
         p_d_fecini FechaInicio,
         p_d_fecfin FechaFin,
         CASE
           WHEN A.AQPC156CODOPI > 2023000000  THEN --18/12/2023
            TO_NUMBER(Substr(A.AQPC156CODOPI, 5, 6))
           ELSE
            A.AQPC156CODOPI
         END CodOpi,
         A.AQPC156INSTAN Instancia,
         CASE
           WHEN B.AQPC801USREJ IS NULL THEN
            'ANALISTA SENIOR DE ADMISIÓN Y SEGUIMIENTO'
           ELSE
            B.AQPC801ETAPA
         END Etapa,
         CASE
           WHEN B.AQPC801USREJ IS NULL THEN
            (SELECT E.AQPC156ANSERIG
               FROM AQPC156 E
              WHERE E.AQPC156CODOPI = A.AQPC156CODOPI
                AND E.AQPC156INSTAN = A.AQPC156INSTAN
                AND E.AQPC156ESTAD = 'H')
           ELSE
            B.AQPC801USREJ
         END Usuario,
         CASE
           WHEN B.AQPC801ESTDA IS NULL THEN
            'P'
           ELSE
            B.AQPC801ESTDA
         END Estado,
         CASE
           -- WHEN B.AQPC801CODETA IN (1, 2) THEN 18112024
           -- 'EN TRAMITE'
           WHEN (B.AQPC801CODETA >= 1 AND B.AQPC801ESTDA = 'V') THEN --18112024
            'VIABLE'
           WHEN (B.AQPC801CODETA >= 1 AND B.AQPC801ESTDA = 'NV') THEN
            'NO VIABLE'
           WHEN (B.AQPC801CODETA >= 1 AND B.AQPC801ESTDA = 'O') THEN
            'OBSERVADO'
           WHEN (B.AQPC801CODETA >= 1 AND B.AQPC801ESTDA = 'D') THEN --18112024
            'DEVUELTO'
           WHEN B.AQPC801CODETA IS NULL THEN
            'EN PROCESO'
           WHEN B.AQPC801ESTDA = 'R' THEN
            'RECONSIDERACION'
           WHEN B.AQPC801ESTDA = 'P' THEN
            'EN PROCESO'--'PENDIENTE'
         END EstadoDes,
         CASE
           WHEN B.AQPC801AUX1 IS NULL THEN
            (SELECT E.AQPC156FECPRO
               FROM AQPC156 E
              WHERE E.AQPC156CODOPI = A.AQPC156CODOPI
                AND E.AQPC156INSTAN = A.AQPC156INSTAN
                AND E.AQPC156ESTAD = 'H')
           WHEN (B.AQPC801ESTDA = 'R' OR B.AQPC801ESTDA = 'P') THEN
            B.AQPC801FECH
           WHEN B.AQPC801AUX1 > 1 THEN
            (SELECT Y.AQPC801FECH
               FROM AQPC801 Y
              WHERE Y.AQPC801CODOPI = B.AQPC801CODOPI
                AND Y.AQPC801AUX1 = (B.AQPC801AUX1 - 1))
           WHEN B.AQPC801AUX1 = 1 THEN
            (SELECT Z.AQPC156FECPRO
               FROM AQPC156 Z
              WHERE Z.AQPC156CODOPI = A.AQPC156CODOPI
                AND Z.AQPC156CORR = 1)
         END FechaEntrada,
         CASE
           WHEN AQPC801AUX1 IS NULL THEN
            (SELECT E.AQPC156HORRG
               FROM AQPC156 E
              WHERE E.AQPC156CODOPI = A.AQPC156CODOPI
                AND E.AQPC156INSTAN = A.AQPC156INSTAN
                AND E.AQPC156ESTAD = 'H')
           WHEN (B.AQPC801ESTDA = 'R' OR B.AQPC801ESTDA = 'P') THEN
            B.AQPC801HOR
           WHEN AQPC801AUX1 > 1 THEN
            (SELECT Y.AQPC801HOR
               FROM AQPC801 Y
              WHERE Y.AQPC801CODOPI = B.AQPC801CODOPI
                AND Y.AQPC801AUX1 = (B.AQPC801AUX1 - 1))
           WHEN B.AQPC801AUX1 = 1 THEN
            (SELECT Z.AQPC156HORRG
               FROM AQPC156 Z
              WHERE Z.AQPC156CODOPI = A.AQPC156CODOPI
                AND Z.AQPC156CORR = 1)
         END HoraEntrada,
         CASE
           WHEN B.AQPC801ESTDA NOT IN ('R','P') THEN
            B.AQPC801FECH
           ELSE
            NULL
         END FechaSalida,
         CASE
           WHEN B.AQPC801ESTDA NOT IN ('R','P') THEN
            B.AQPC801HOR
           ELSE
            NULL
         END HoraSalida,
         A.AQPC156TIPSOL TipoSol,
         A.AQPC156DETISOL TipoSolDes,
         A.AQPC156CTNRO Cuenta,
         C.SNG001TDOC TipoDoc,
         TRIM(C.SNG001NDOC) Doc,
         (SELECT F.PENOM
            FROM FSD001 F
           WHERE F.PEPAIS = C.SNG001PAIS
             AND F.PETDOC = C.SNG001TDOC
             AND F.PENDOC = C.SNG001NDOC) Cliente,
         --A.AQPC156CLIEN Cliente,
         A.AQPC156SLDPROP Monto,
         A.AQPC156RESPTOT RespTotal,
         A.AQPC156ANALIS Analista,
         A.AQPC156ANSERIG AnalistaRiesgos,
         A.AQPC156AGENC Agencia,
         A.AQPC156ZONA Zona,
         A.AQPC156REGIO Regionl,
         D.XWFMODULO Modulo,
         (SELECT M.MDNOM FROM FST003 M WHERE M.MODULO = D.XWFMODULO) ModuloDes,
         D.XWFTIPOPE TipOpe,
         (SELECT T.TONOM
            FROM FST004 T
           WHERE T.MODULO = D.XWFMODULO
             AND T.TOTOPE = D.XWFTIPOPE) TipOpeDes,
         'FLUJO BANTOTAL', -- INI 11/12/2023
         CASE
           WHEN (B.AQPC801CODETA >= 1 AND B.AQPC801ESTDA = 'O') THEN --18112024
            (SELECT SUBSTR(K.AQPC171MOTOBSV,1,1200)
               FROM AQPC171 K
              WHERE K.AQPC171CODOPI = A.AQPC156CODOPI
                AND K.AQPC171INST = A.AQPC156INSTAN
                AND K.AQPC171ESTAD = 'H') -- INI 11/12/2023
         END MotivoObservacion,
         CASE
           WHEN A.AQPC156ESRECON = 'S' AND A.AQPC156ESTAD = 'H' THEN
            'SI'
           ELSE
            'NO'
         END EsReconsideracion, -- FIN 11/12/2023                      
         CASE
           WHEN A.AQPC156CODOPI > 2023000000 THEN
            TO_NUMBER(Substr(A.AQPC156CODOPI, 1, 4))
           ELSE
            2023
         END Anio,
         D.XWFOPERACION Operacion
          FROM AQPC156 A
          LEFT JOIN AQPC801 B
            ON B.AQPC801CODOPI = A.AQPC156CODOPI
         INNER JOIN SNG001 C
            ON C.SNG001INST = A.AQPC156INSTAN
         INNER JOIN XWF700 D
            ON D.XWFPRCINS = A.AQPC156INSTAN
         WHERE D.XWFCAR3 = '1'
           AND A.AQPC156FECPRO BETWEEN p_d_fecini AND p_d_fecfin
           AND A.AQPC156ESTAD = 'H'
        
        UNION
        
        SELECT /*+all rows*/
         TRUNC(SYSDATE) FechaConsulta,
         TO_CHAR(SYSDATE, 'HH24:MI:SS') HoraConsulta,
         p_v_usuario UsuarioConsulta,
         p_d_fecini FechaInicio,
         p_d_fecfin FechaFin,
         CASE
           WHEN A.AQPC818CODOPI > 2023000000 THEN --18/12/2023
            TO_NUMBER(Substr(A.AQPC818CODOPI, 5, 6))
           ELSE
            A.AQPC818CODOPI
         END CodOpi,
         A.AQPC818INSTAN Instancia,
         CASE
           WHEN B.AQPC801USREJ IS NULL THEN
            'ANALISTA SENIOR DE ADMISIÓN Y SEGUIMIENTO'
           ELSE
            B.AQPC801ETAPA
         END Etapa,
         CASE
           WHEN B.AQPC801USREJ IS NULL THEN
            (SELECT E.AQPC818ANSERIG
               FROM AQPC818 E
              WHERE E.AQPC818CODOPI = A.AQPC818CODOPI
                AND E.AQPC818INSTAN = A.AQPC818INSTAN
                AND E.AQPC818ESTAD = 'H')
           ELSE
            B.AQPC801USREJ
         END Usuario,
         CASE
           WHEN B.AQPC801ESTDA IS NULL THEN
            'P'
           ELSE
            B.AQPC801ESTDA
         END Estado,
         CASE
           --WHEN B.AQPC801CODETA IN (1, 2) THEN --18112024
           -- 'EN TRAMITE'
           WHEN (B.AQPC801CODETA >= 1 AND B.AQPC801ESTDA = 'V') THEN --18112024
            'VIABLE'
           WHEN (B.AQPC801CODETA >= 1 AND B.AQPC801ESTDA = 'NV') THEN
            'NO VIABLE'
           WHEN (B.AQPC801CODETA >= 1 AND B.AQPC801ESTDA = 'O') THEN
            'OBSERVADO'
           WHEN (B.AQPC801CODETA >= 1 AND B.AQPC801ESTDA = 'D') THEN --18112024
            'DEVUELTO'
           WHEN B.AQPC801CODETA IS NULL THEN
            'EN PROCESO'
           WHEN B.AQPC801ESTDA = 'R' THEN
            'RECONSIDERACION'
           WHEN B.AQPC801ESTDA = 'P' THEN
            'EN PROCESO'--'PENDIENTE'
         END EstadoDes,
         CASE
           WHEN AQPC801AUX1 IS NULL THEN
            (SELECT E.AQPC818FECPRO
               FROM AQPC818 E
              WHERE E.AQPC818CODOPI = A.AQPC818CODOPI
                AND E.AQPC818INSTAN = A.AQPC818INSTAN
                AND E.AQPC818ESTAD = 'H')
           WHEN (B.AQPC801ESTDA = 'R' OR B.AQPC801ESTDA = 'P') THEN
            B.AQPC801FECH
           WHEN AQPC801AUX1 > 1 THEN
            (SELECT Y.AQPC801FECH
               FROM AQPC801 Y
              WHERE Y.AQPC801CODOPI = B.AQPC801CODOPI
                AND Y.AQPC801AUX1 = (B.AQPC801AUX1 - 1))
           WHEN AQPC801AUX1 = 1 THEN
            (SELECT Z.AQPC818FECPRO
               FROM AQPC818 Z
              WHERE Z.AQPC818CODOPI = A.AQPC818CODOPI
                AND Z.AQPC818CORR = 1)
         END FechaEntrada,
         CASE
           WHEN AQPC801AUX1 IS NULL THEN
            (SELECT E.AQPC818HORRG
               FROM AQPC818 E
              WHERE E.AQPC818CODOPI = A.AQPC818CODOPI
                AND E.AQPC818INSTAN = A.AQPC818INSTAN
                AND E.AQPC818ESTAD = 'H')
           WHEN (B.AQPC801ESTDA = 'R' OR B.AQPC801ESTDA = 'P') THEN
            B.AQPC801HOR
           WHEN AQPC801AUX1 > 1 THEN
            (SELECT Y.AQPC801HOR
               FROM AQPC801 Y
              WHERE Y.AQPC801CODOPI = B.AQPC801CODOPI
                AND Y.AQPC801AUX1 = (B.AQPC801AUX1 - 1))
           WHEN AQPC801AUX1 = 1 THEN
            (SELECT Z.AQPC818HORRG
               FROM AQPC818 Z
              WHERE Z.AQPC818CODOPI = A.AQPC818CODOPI
                AND Z.AQPC818CORR = 1)
         END HoraEntrada,
         CASE
           WHEN B.AQPC801ESTDA NOT IN ('R','P') THEN
            B.AQPC801FECH
           ELSE
            NULL
         END FechaSalida,
         CASE
           WHEN B.AQPC801ESTDA NOT IN ('R','P') THEN
            B.AQPC801HOR
           ELSE
            NULL
         END HoraSalida,
         A.AQPC818TIPSOL TipoSol,
         A.AQPC818DETISOL,--'REPROGRAMACIÓN CRM', --A.AQPC818DETISOL TipoSolDes, 30/09/2024
         A.AQPC818CTNRO Cuenta,
         C.SNG001TDOC TipoDoc,
         TRIM(C.SNG001NDOC) Doc,
         (SELECT F.PENOM
            FROM FSD001 F
           WHERE F.PEPAIS = C.SNG001PAIS
             AND F.PETDOC = C.SNG001TDOC
             AND F.PENDOC = C.SNG001NDOC) Cliente,
         --A.AQPC156CLIEN Cliente,
         A.AQPC818SLDPROP Monto,
         A.AQPC818RESPTOT RespTotal,
         A.AQPC818ANALIS Analista,
         A.AQPC818ANSERIG AnalistaRiesgos,
         A.AQPC818AGENC Agencia,
         A.AQPC818ZONA Zona,
         A.AQPC818REGIO Regionl,
         D.XWFMODULO Modulo,
         (SELECT M.MDNOM FROM FST003 M WHERE M.MODULO = D.XWFMODULO) ModuloDes,
         D.XWFTIPOPE TipOpe,
         (SELECT T.TONOM
            FROM FST004 T
           WHERE T.MODULO = D.XWFMODULO
             AND T.TOTOPE = D.XWFTIPOPE) TipOpeDes,
         'FLUJO SIN CAPITALIZACION',--'FLUJO CRM', 07/11/2024
         CASE -- INI 11/12/2023
           WHEN (B.AQPC801CODETA >= 1 AND B.AQPC801ESTDA = 'O') THEN --18112024
            (SELECT SUBSTR(K.AQPC819MOTOBSV,1,1000)
               FROM AQPC819 K
              WHERE K.AQPC819CODOPI = A.AQPC818CODOPI
                AND K.AQPC819INST = A.AQPC818INSTAN
                AND K.AQPC819ESTAD = 'H') -- INI 11/12/2023                
         END MotivoObservacion,
         CASE
           WHEN A.AQPC818ESRECON = 'S' AND
                (A.AQPC818ESTAD = 'H' OR A.AQPC818ESTAD = 'X') THEN
            'SI'
           ELSE
            'NO'
         END EsReconsideracion, -- FIN 11/12/2023          
         CASE
           WHEN A.AQPC818CODOPI > 2023000000 THEN
            TO_NUMBER(Substr(A.AQPC818CODOPI, 1, 4))
           ELSE
            2023
         END Anio,         
         D.XWFOPERACION Operacion
          FROM AQPC818 A
          LEFT JOIN AQPC801 B
            ON B.AQPC801CODOPI = A.AQPC818CODOPI
         INNER JOIN SNG001 C
            ON C.SNG001INST = A.AQPC818INSTAN
         INNER JOIN XWF700 D
            ON D.XWFPRCINS = A.AQPC818INSTAN
         WHERE D.XWFCAR3 = '1'
           AND A.AQPC818FECPRO BETWEEN p_d_fecini AND p_d_fecfin
           AND (A.AQPC818ESTAD = 'H' OR A.AQPC818ESTAD = 'X')
         ORDER BY CodOpi asc, FechaEntrada asc, HoraEntrada asc, FechaSalida desc;
      COMMIT;
    exception
      when others then
        /*pv_msgerr := SQLERRM;
        DBMS_OUTPUT.put_line(pv_msgerr);*/
        p_v_flag := 'E';
    end;
    --Actualizamos los campos restantes  
    p_v_flag := 'S';
  
  end sp_cr_reporte_opinion_riesgo;

end PQ_CR_EXTRA_OPINION_RIESGO;
/

