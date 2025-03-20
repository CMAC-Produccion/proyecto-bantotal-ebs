CREATE OR REPLACE PROCEDURE "SP_AH_INSERCION_JAQY255_DIARIO"(P_FECHA_DIA    in DATE,
                                                             P_HORAACTUAL   in varchar2,
                                                             P_HORAANTERIOR in varchar2,
                                                             P_FECHA_RCC    in DATE,
                                                             P_PGCOD        in number,
                                                             P_ITSUC        in number,
                                                             P_ITMOD        in number,
                                                             P_ITTRAN       in number,
                                                             P_ITNREL       in number,
                                                             ps_coderr      out char) is

  -- ***************************************************************************************
  -- Nombre                      : SP_AH_INSERCION_JAQY255_DIARIO
  -- Sistema                     : BANTOTAL
  -- Módulo                      : Ahorros - Pasivas
  -- Versión                     : 1.0
  -- Fecha de Creación           : 19/04/2023
  -- Autor de Creación           : Tania Apaza
  -- Uso                         : 
  -- Estado                      : Activo
  -- Acceso                      : Público
  -- Parámetros de Entrada       : 
  -- ***
  -- Fecha de Modificación       : 2025.01.17
  -- Modificado                  : CVILLON
  -- Descripción de Modificación : Reporte Multiusuario
  -- ***************************************************************************************
  -- ***************************************************************************************

  cursor c_insercion is
  --productos activos //TAPAZA - agarra registros no duplicados de fsd015(a) y fsd016(b) 
    select distinct a.itfcon as D_FECCON,
                    a.itsuc || '-' || a.itmod || '-' || a.ittran || '-' ||
                    a.itnrel as N_CODTRA,
                    a.itfcon as D_FECOPE,
                    lpad(a.ITSUC, 3, '0') as n_codage,
                    PQ_ENC_CALIDAD.fn_descripcion_agencia(a.ITSUC) as C_DESAGE,
                    a.ituing as C_CODUSU,
                    PQ_ENC_CALIDAD.fn_nombre_usuario(a.ITUING) as C_NOMUSU,
                    PQ_ENC_CALIDAD.fn_cargo_usuario2(a.ITUING) C_CARGO,
                    PQ_ENC_CALIDAD.fn_descripcion_operacion(a.ITMOD,
                                                            a.ITTRAN) C_DESOPE,
                    a.ithora as d_horope,
                    a.ithora as d_horini,
                    a.ithora as d_horfin,
                    PQ_ENC_CALIDAD.fn_codigo_referencia_credito(b.ctnro,
                                                                b.moneda,
                                                                b.itoper) codigo,
                    PQ_ENC_CALIDAD.fn_nombre_cliente(b.ctnro) c_nomcli,
                    
                    PQ_ENC_CALIDAD.fn_obtener_region(a.ITSUC) c_desreg,
                    PQ_ENC_CALIDAD.fn_obtener_zona(a.ITSUC) c_deszon,
                    PQ_ENC_CALIDAD.fn_docide_codusu(a.ituing) c_dniusu,
                    PQ_ENC_CALIDAD.fn_sexo_cliente(b.ctnro) c_sexcli,
                    PQ_ENC_CALIDAD.fn_fecnac_cliente(b.ctnro) d_fecnac,
                    PQ_ENC_CALIDAD.fn_despro_Activa(b.modulo) c_despro,
                    PQ_ENC_CALIDAD.fn_segcre_cliente(b.ctnro) c_desseg,
                    --PQ_ENC_CALIDAD.fn_mondes_cliente(b.ctnro,b.itoper) n_mondes,
                    b.ITIMP1 AS n_mondes,
                    
                    PQ_ENC_CALIDAD.fn_fecdes_cliente(b.ctnro, b.itoper) d_fecdes,
                    fr.pepais,
                    fr.petdoc,
                    fr.pendoc,
                    PQ_ENC_CALIDAD.fn_prosbs(fr.petdoc,
                                             fr.pepais,
                                             fr.pendoc) cprosbs,
                    ---***
                    (SELECT COALESCE(f005.DOTELFP, '')
                       FROM FSR005 f005
                      WHERE f005.pepais = fr.pepais
                        AND f005.petdoc = fr.petdoc
                        AND f005.pendoc = fr.pendoc
                        AND f005.docod = 1
                        AND f005.doordp = 1) AS c_telcli,
                    ---***
                    (SELECT COALESCE(f005.DOTELFP, '')
                       FROM FSR005 f005
                      WHERE f005.pepais = fr.pepais
                        AND f005.petdoc = fr.petdoc
                        AND f005.pendoc = fr.pendoc
                        AND f005.docod = 1
                        AND f005.doordp = 2) AS c_telcli2,
                    ---***
                    (SELECT COALESCE(f005.DOTELFP, '')
                       FROM FSR005 f005
                      WHERE f005.pepais = fr.pepais
                        AND f005.petdoc = fr.petdoc
                        AND f005.pendoc = fr.pendoc
                        AND f005.docod = 1
                        AND f005.doordp = 3) AS c_telcli3 --TAPAZA tel del cliente 1,2,3 si es nulo traer '' vacio 
    ---***
    
      from fsd015 a
     inner join fsd016 b
        on a.pgcod = b.pgcod
       and a.itsuc = b.itsuc
       and a.itmod = b.itmod
       and a.ittran = b.ittran
       and a.itnrel = b.itnrel
       and
          ---***
           a.itfcon = P_FECHA_DIA --TAPAZA fecha de contabilizacion = al fecha parámetro 
       AND b.ITIMP1 > 3.00
    ---***
     inner join fsr008 fr --join con Fsr008(fr) Integración Cuentas
        on fr.ctnro = b.ctnro
       and fr.cttfir = 'T'
       and fr.ttcod = 1
     where a.PGCOD = P_PGCOD
       AND a.ITSUC = P_ITSUC
       AND a.ITMOD = P_ITMOD
       AND a.ITTRAN = P_ITTRAN
       AND a.ITNREL = P_ITNREL
       AND a.ithora > P_HORAANTERIOR
       and a.ithora <= P_HORAACTUAL
       and a.ituing <> 'USRSWITCH' --TAPAZA : usuario que ingresa <> de USRSWITCH
       and b.ctnro <> 0
       and a.ITSUC not in (901, 902, 903, 904, 905)
       and a.itcorr = 0
       and a.itcont = 'S'
       and PQ_ENC_CALIDAD.fn_tipo_cliente(b.ctnro) <> 'J' --TAPAZA no sea persona juridica
       and PQ_ENC_CALIDAD.fn_telefono_cliente(b.ctnro,
                                              PQ_ENC_CALIDAD.fn_departamento(a.itsuc),
                                              1) is not null --Tapaza tel no sea nulo 
       and (a.itmod, a.ittran) in
           (select tp1nro1 as itmod, tp1nro2 as ittran
              from fst198
             where tp1cod = 1
               and tp1cod1 = 10803
               and tp1corr1 in (2, 3)
               and tp1nro3 = 0)
       and b.modulo in (select modulo from fst111 where dscod = 50) --TAPAZA: Fst111 : Módulos de Sistema, código de sist 50 
    
    UNION
    
    select distinct a.itfcon as D_FECCON,
                    a.itsuc || '-' || a.itmod || '-' || a.ittran || '-' ||
                    a.itnrel as N_CODTRA,
                    a.itfcon as D_FECOPE,
                    lpad(a.ITSUC, 3, '0') as n_codage,
                    PQ_ENC_CALIDAD.fn_descripcion_agencia(a.ITSUC) as C_DESAGE,
                    a.ituing as C_CODUSU,
                    PQ_ENC_CALIDAD.fn_nombre_usuario(a.ITUING) as C_NOMUSU,
                    PQ_ENC_CALIDAD.fn_cargo_usuario2(a.ITUING) C_CARGO,
                    PQ_ENC_CALIDAD.fn_descripcion_operacion(a.ITMOD,
                                                            a.ITTRAN) C_DESOPE,
                    a.ithora as d_horope,
                    a.ithora as d_horini,
                    a.ithora as d_horfin,
                    PQ_ENC_CALIDAD.fn_codigo_referencia_credito(b.ctnro,
                                                                b.moneda,
                                                                b.itoper) codigo,
                    PQ_ENC_CALIDAD.fn_nombre_cliente(b.ctnro) c_nomcli,
                    
                    PQ_ENC_CALIDAD.fn_obtener_region(a.ITSUC) c_desreg,
                    PQ_ENC_CALIDAD.fn_obtener_zona(a.ITSUC) c_deszon,
                    PQ_ENC_CALIDAD.fn_docide_codusu(a.ituing) c_dniusu,
                    PQ_ENC_CALIDAD.fn_sexo_cliente(b.ctnro) c_sexcli,
                    PQ_ENC_CALIDAD.fn_fecnac_cliente(b.ctnro) d_fecnac,
                    PQ_ENC_CALIDAD.fn_despro_Activa(b.modulo) c_despro,
                    PQ_ENC_CALIDAD.fn_segcre_cliente(b.ctnro) c_desseg,
                    --PQ_ENC_CALIDAD.fn_mondes_cliente(b.ctnro,b.itoper) n_mondes,
                    b.ITIMP1 AS n_mondes,
                    
                    PQ_ENC_CALIDAD.fn_fecdes_cliente(b.ctnro, b.itoper) d_fecdes,
                    fr.pepais,
                    fr.petdoc,
                    fr.pendoc,
                    PQ_ENC_CALIDAD.fn_prosbs(fr.petdoc,
                                             fr.pepais,
                                             fr.pendoc) cprosbs,
                    ---***
                    (SELECT COALESCE(f005.DOTELFP, '')
                       FROM FSR005 f005
                      WHERE f005.pepais = fr.pepais
                        AND f005.petdoc = fr.petdoc
                        AND f005.pendoc = fr.pendoc
                        AND f005.docod = 1
                        AND f005.doordp = 1) AS c_telcli,
                    ---***
                    (SELECT COALESCE(f005.DOTELFP, '')
                       FROM FSR005 f005
                      WHERE f005.pepais = fr.pepais
                        AND f005.petdoc = fr.petdoc
                        AND f005.pendoc = fr.pendoc
                        AND f005.docod = 1
                        AND f005.doordp = 2) AS c_telcli2,
                    ---***
                    (SELECT COALESCE(f005.DOTELFP, '')
                       FROM FSR005 f005
                      WHERE f005.pepais = fr.pepais
                        AND f005.petdoc = fr.petdoc
                        AND f005.pendoc = fr.pendoc
                        AND f005.docod = 1
                        AND f005.doordp = 3) AS c_telcli3
    ---***
    
      from fsd015 a
     inner join fsd016 b
        on a.pgcod = b.pgcod
       and a.itsuc = b.itsuc
       and a.itmod = b.itmod
       and a.ittran = b.ittran
       and a.itnrel = b.itnrel
       and
          ---***
           a.itfcon = P_FECHA_DIA --TAPAZA : Parametro ingresado 
       AND b.ITIMP1 > 3.00
    ---***
     inner join fsr008 fr --join con Fsr008(fr) Integración Cuentas
        on fr.ctnro = b.ctnro
       and fr.cttfir = 'T'
       and fr.ttcod = 1
     where a.PGCOD = P_PGCOD
       AND a.ITSUC = P_ITSUC
       AND a.ITMOD = P_ITMOD
       AND a.ITTRAN = P_ITTRAN
       AND a.ITNREL = P_ITNREL
       AND a.ithora > P_HORAANTERIOR
       and a.ithora <= P_HORAACTUAL --TAPAZA: intervalo de horas
       and a.ituing <> 'USRSWITCH' --TAPAZA : usuario que ingresa <> de USRSWITCH
       and b.ctnro <> 0
       and a.ITSUC not in (901, 902, 903, 904, 905)
       and a.itcorr = 0
       and a.itcont = 'S'
       and PQ_ENC_CALIDAD.fn_tipo_cliente(b.ctnro) <> 'J'
       and PQ_ENC_CALIDAD.fn_telefono_cliente(b.ctnro,
                                              PQ_ENC_CALIDAD.fn_departamento(a.itsuc),
                                              1) is not null
       and (a.itmod, a.ittran, b.itord) in
           (select tp1nro1 as itmod, tp1nro2 as ittran, tp1nro3 as itord
              from fst198
             where tp1cod = 1 --TAPAZA: unica diferencia es "tp1nro3 as itord"
               and tp1cod1 = 10803
               and tp1corr1 in (2, 3)
               and tp1nro3 <> 0) --TAPAZA:  diferencia "tp1nro3 = 0" el anterior
       and b.modulo in (select modulo from fst111 where dscod = 50)
    
    --ACTIVOS
    UNION
    --PASIVOS
    
    --productos pasivos
    select distinct a.itfcon as D_FECCON,
                    a.itsuc || '-' || a.itmod || '-' || a.ittran || '-' ||
                    a.itnrel as N_CODTRA,
                    a.itfcon as D_FECOPE,
                    lpad(a.ITSUC, 3, '0') as n_codage,
                    PQ_ENC_CALIDAD.fn_descripcion_agencia(a.ITSUC) as C_DESAGE,
                    a.ituing as C_CODUSU,
                    PQ_ENC_CALIDAD.fn_nombre_usuario(a.ITUING) as C_NOMUSU,
                    PQ_ENC_CALIDAD.fn_cargo_usuario2(a.ITUING) C_CARGO,
                    PQ_ENC_CALIDAD.fn_descripcion_operacion(a.ITMOD,
                                                            a.ITTRAN) C_DESOPE,
                    a.ithora as d_horope,
                    a.ithora as d_horini,
                    a.ithora as d_horfin,
                    PQ_ENC_CALIDAD.fn_codigo_referencia(b.ctnro,
                                                        b.modulo,
                                                        b.moneda,
                                                        b.itsubo,
                                                        b.itoper,
                                                        b.ittope) codigo,
                    PQ_ENC_CALIDAD.fn_nombre_cliente(b.ctnro) c_nomcli,
                    
                    PQ_ENC_CALIDAD.fn_obtener_region(a.ITSUC) c_desreg,
                    PQ_ENC_CALIDAD.fn_obtener_zona(a.ITSUC) c_deszon,
                    PQ_ENC_CALIDAD.fn_docide_codusu(a.ituing) c_dniusu,
                    PQ_ENC_CALIDAD.fn_sexo_cliente(b.ctnro) c_sexcli,
                    PQ_ENC_CALIDAD.fn_fecnac_cliente(b.ctnro) d_fecnac,
                    PQ_ENC_CALIDAD.fn_despro_Pasiva(b.modulo, b.ittope) c_despro,
                    PQ_ENC_CALIDAD.fn_segaho_cliente(b.ctnro) c_desseg,
                    --0 n_mondes,
                    b.ITIMP1  AS n_mondes,
                    null      d_fecdes,
                    fr.pepais,
                    fr.petdoc,
                    fr.pendoc,
                    '0000',
                    ---***
                    (SELECT COALESCE(f005.DOTELFP, '')
                       FROM FSR005 f005
                      WHERE f005.pepais = fr.pepais
                        AND f005.petdoc = fr.petdoc
                        AND f005.pendoc = fr.pendoc
                        AND f005.docod = 1
                        AND f005.doordp = 1) AS c_telcli,
                    ---***
                    (SELECT COALESCE(f005.DOTELFP, '')
                       FROM FSR005 f005
                      WHERE f005.pepais = fr.pepais
                        AND f005.petdoc = fr.petdoc
                        AND f005.pendoc = fr.pendoc
                        AND f005.docod = 1
                        AND f005.doordp = 2) AS c_telcli2,
                    ---***
                    (SELECT COALESCE(f005.DOTELFP, '')
                       FROM FSR005 f005
                      WHERE f005.pepais = fr.pepais
                        AND f005.petdoc = fr.petdoc
                        AND f005.pendoc = fr.pendoc
                        AND f005.docod = 1
                        AND f005.doordp = 3) AS c_telcli3
    ---***
    
      from fsd015 a
     inner join fsd016 b
        on a.pgcod = b.pgcod
       and a.itsuc = b.itsuc
       and a.itmod = b.itmod
       and a.ittran = b.ittran
       and a.itnrel = b.itnrel
       and
          ---***
           a.ITFCON = P_FECHA_DIA -- TAPAZA: PARÁMETROS de entrada
       AND b.ITIMP1 > 3.00
    ---***
     inner join fsr008 fr
        on fr.ctnro = b.ctnro
       and fr.cttfir = 'T'
       and fr.ttcod = 1
     where a.PGCOD = P_PGCOD
       AND a.ITSUC = P_ITSUC
       AND a.ITMOD = P_ITMOD
       AND a.ITTRAN = P_ITTRAN
       AND a.ITNREL = P_ITNREL
       AND a.ithora > P_HORAANTERIOR
       and a.ithora <= P_HORAACTUAL --Tapaza: intervalo de horas
       and a.ituing <> 'USRSWITCH'
       and b.ctnro <> 0
       and a.ITSUC not in (901, 902, 903, 904, 905)
       and a.itcorr = 0
       and a.itcont = 'S'
       and PQ_ENC_CALIDAD.fn_tipo_cliente(b.ctnro) <> 'J'
       and PQ_ENC_CALIDAD.fn_telefono_cliente(b.ctnro,
                                              PQ_ENC_CALIDAD.fn_departamento(a.itsuc),
                                              1) is not null
       and (a.itmod, a.ittran) in
           (select tp1nro1 as itmod, tp1nro2 as ittran
              from fst198
             where tp1cod = 1
               and tp1cod1 = 10803
               and tp1corr1 in (2, 3)
               and tp1nro3 = 0)
       and b.modulo in (21, 22) --TAPAZA : PASIVAS 21 Y 22?
    
    UNION
    
    select distinct a.itfcon as D_FECCON,
                    a.itsuc || '-' || a.itmod || '-' || a.ittran || '-' ||
                    a.itnrel as N_CODTRA,
                    a.itfcon as D_FECOPE,
                    lpad(a.ITSUC, 3, '0') as n_codage,
                    PQ_ENC_CALIDAD.fn_descripcion_agencia(a.ITSUC) as C_DESAGE,
                    a.ituing as C_CODUSU,
                    PQ_ENC_CALIDAD.fn_nombre_usuario(a.ITUING) as C_NOMUSU,
                    PQ_ENC_CALIDAD.fn_cargo_usuario2(a.ITUING) C_CARGO,
                    PQ_ENC_CALIDAD.fn_descripcion_operacion(a.ITMOD,
                                                            a.ITTRAN) C_DESOPE,
                    a.ithora as d_horope,
                    a.ithora as d_horini,
                    a.ithora as d_horfin,
                    PQ_ENC_CALIDAD.fn_codigo_referencia(b.ctnro,
                                                        b.modulo,
                                                        b.moneda,
                                                        b.itsubo,
                                                        b.itoper,
                                                        b.ittope) codigo,
                    PQ_ENC_CALIDAD.fn_nombre_cliente(b.ctnro) c_nomcli,
                    
                    PQ_ENC_CALIDAD.fn_obtener_region(a.ITSUC) c_desreg,
                    PQ_ENC_CALIDAD.fn_obtener_zona(a.ITSUC) c_deszon,
                    PQ_ENC_CALIDAD.fn_docide_codusu(a.ituing) c_dniusu,
                    PQ_ENC_CALIDAD.fn_sexo_cliente(b.ctnro) c_sexcli,
                    PQ_ENC_CALIDAD.fn_fecnac_cliente(b.ctnro) d_fecnac,
                    PQ_ENC_CALIDAD.fn_despro_Pasiva(b.modulo, b.ittope) c_despro,
                    PQ_ENC_CALIDAD.fn_segaho_cliente(b.ctnro) c_desseg,
                    --0 n_mondes,
                    b.ITIMP1 AS n_mondes,
                    
                    null      d_fecdes,
                    fr.pepais,
                    fr.petdoc,
                    fr.pendoc,
                    '0000',
                    ---***
                    (SELECT COALESCE(f005.DOTELFP, '')
                       FROM FSR005 f005
                      WHERE f005.pepais = fr.pepais
                        AND f005.petdoc = fr.petdoc
                        AND f005.pendoc = fr.pendoc
                        AND f005.docod = 1
                        AND f005.doordp = 1) AS c_telcli,
                    ---***
                    (SELECT COALESCE(f005.DOTELFP, '')
                       FROM FSR005 f005
                      WHERE f005.pepais = fr.pepais
                        AND f005.petdoc = fr.petdoc
                        AND f005.pendoc = fr.pendoc
                        AND f005.docod = 1
                        AND f005.doordp = 2) AS c_telcli2,
                    ---***
                    (SELECT COALESCE(f005.DOTELFP, '')
                       FROM FSR005 f005
                      WHERE f005.pepais = fr.pepais
                        AND f005.petdoc = fr.petdoc
                        AND f005.pendoc = fr.pendoc
                        AND f005.docod = 1
                        AND f005.doordp = 3) AS c_telcli3
    ---***
    
      from fsd015 a
     inner join fsd016 b
        on a.pgcod = b.pgcod
       and a.itsuc = b.itsuc
       and a.itmod = b.itmod
       and a.ittran = b.ittran
       and a.itnrel = b.itnrel
       and
          ---***
           a.ITFCON = P_FECHA_DIA --TAPAZA: PARAMETRO de entrada 
       AND b.ITIMP1 > 3.00
    ---***
     inner join fsr008 fr
        on fr.ctnro = b.ctnro
       and fr.cttfir = 'T'
       and fr.ttcod = 1
     where a.PGCOD = P_PGCOD
       AND a.ITSUC = P_ITSUC
       AND a.ITMOD = P_ITMOD
       AND a.ITTRAN = P_ITTRAN
       AND a.ITNREL = P_ITNREL
       AND a.ithora > P_HORAANTERIOR
       and a.ithora <= P_HORAACTUAL --Tapaza: intervalo de horas
       and a.ituing <> 'USRSWITCH'
       and b.ctnro <> 0
       and a.ITSUC not in (901, 902, 903, 904, 905)
       and a.itcorr = 0
       and a.itcont = 'S'
       and PQ_ENC_CALIDAD.fn_tipo_cliente(b.ctnro) <> 'J' --TAPAZA: no personas juridicas 
       and PQ_ENC_CALIDAD.fn_telefono_cliente(b.ctnro,
                                              PQ_ENC_CALIDAD.fn_departamento(a.itsuc),
                                              1) is not null
       and (a.itmod, a.ittran, b.itord) in
           (select tp1nro1 as itmod, tp1nro2 as ittran, tp1nro3 as itord
              from fst198
             where tp1cod = 1
               and tp1cod1 = 10803
               and tp1corr1 in (2, 3)
               and tp1nro3 <> 0)
       and b.modulo in (21, 22);

  -- para el cursor
  ln_codigo varchar2(50) := 0;
  ld_fectra date := null;
  ln_codsuc number := 0;
  lc_dessuc varchar2(1000) := null;
  lc_codusu varchar2(1000) := null;
  lc_nomusu varchar2(1000) := null;
  lc_codcar varchar2(1000) := null;
  lc_desope varchar2(1000) := null;
  lc_codigo varchar2(1000) := null;
  lc_nomcli varchar2(1000) := '';
  lc_telcli varchar2(1000) := '';
  ld_horope character(10) := '';
  ld_horini character(10) := '';
  ld_horfin character(10) := '';
  ln_contad number := 0;
  lc_desreg varchar2(1000) := null;
  lc_deszon varchar2(1000) := null;
  lc_dniusu varchar2(1000) := null;
  lc_segcli varchar2(1000) := null;
  ld_fecnac date := null;
  lc_despro varchar2(1000) := null;
  lc_sexcli char(1) := null;
  ln_mondes number(14, 2) := 0;
  ld_fecdes date := null;
  ln_paicli number(3);
  ln_tipdoc number(2);
  ls_numdoc char(12);
  ls_prosbs varchar(50);
  ---*** MCVILLONZ 2021.05.20
  ld_FECCON  DATE := null;
  lc_GIRNEG  VARCHAR(100) := null;
  ln_EDAD    NUMERIC(3) := null;
  lc_TELCLIR CHAR(20) := null;
  lc_TFPER1  CHAR(20) := null;
  lc_TFPER2  CHAR(20) := null;
  ld_ANTCRE  DATE := null;
  ld_ANTAHO  DATE := null;
  ln_ANTCRE  NUMERIC(9) := null;
  ln_ANTAHO  NUMERIC(9) := null;
  lc_CALIFI  VARCHAR(30) := null;
  ---***
  lv_USRCRM VARCHAR(10);
  ---***
begin
  ---***
  SELECT COALESCE(MAX(JAQY255NUMER), 0) INTO ln_contad FROM JAQY255;
  ---***
  for i in c_insercion --TAPAZA: Recorre el cursos por i (fila) 
   loop
    ln_contad := ln_contad + 1; --incremental 
    ln_codigo := i.N_CODTRA;
    ln_codsuc := trim(i.n_codage);
    lc_dessuc := trim(i.c_desage);
    lc_codusu := trim(i.c_codusu);
    lc_nomusu := trim(i.c_nomusu);
    lc_codcar := trim(i.c_cargo);
    lc_desope := trim(i.c_desope);
    lc_codigo := trim(i.codigo);
    lc_nomcli := trim(i.c_nomcli);
    lc_telcli := trim(i.c_telcli);
    ld_horope := i.d_horope;
    ld_horini := i.d_horini;
    ld_horfin := i.d_horfin;
    lc_desreg := trim(i.c_desreg);
    lc_deszon := trim(i.c_deszon);
    lc_dniusu := trim(i.c_dniusu);
    lc_segcli := trim(i.c_desseg);
    ld_fecnac := i.d_fecnac;
    lc_despro := trim(i.c_despro);
    lc_sexcli := trim(i.c_sexcli);
    ln_mondes := i.n_mondes;
    ld_fecdes := i.d_fecdes;
    ln_paicli := i.pepais;
    ln_tipdoc := i.petdoc;
    ls_numdoc := i.pendoc;
    ls_prosbs := i.cprosbs;
    ---*** MCVILLONZ 2021.05.20
    lc_TFPER1 := trim(i.c_telcli2);
    lc_TFPER2 := trim(i.c_telcli3);
  
    lc_TELCLIR := lc_telcli;
    ld_FECCON  := i.D_FECCON;
    lc_GIRNEG  := PQ_ENC_CALIDAD.fn_ah_giro_negocio(ln_paicli,
                                                    ln_tipdoc,
                                                    ls_numdoc);
    --lc_GIRNEG := 'COMERCIANTE';
    --ln_EDAD   := 39;
    ---***
    lv_USRCRM := 'JOBEXPCLI';
    ---***
  
    SELECT ROUND((P_FECHA_DIA - ld_fecnac) / 365.25, 2)
      INTO ln_EDAD
      FROM dual; --encuentra edad
  
    SELECT PQ_ENC_CALIDAD.fn_ah_antiguedad_cre(P_FECHA_DIA,
                                               ln_paicli,
                                               ln_tipdoc,
                                               ls_numdoc)
      INTO ld_ANTCRE
      FROM dual;
    SELECT MONTHS_BETWEEN(P_FECHA_DIA, ld_ANTCRE) INTO ln_ANTCRE FROM dual;
    ---***
    SELECT PQ_ENC_CALIDAD.fn_ah_antiguedad_aho(P_FECHA_DIA,
                                               ln_paicli,
                                               ln_tipdoc,
                                               ls_numdoc)
      INTO ld_ANTAHO
      FROM dual;
    SELECT MONTHS_BETWEEN(P_FECHA_DIA, ld_ANTAHO) INTO ln_ANTAHO FROM dual;
    ---***
    SELECT PQ_ENC_CALIDAD.fn_ah_calif_sbs(P_FECHA_RCC,
                                          ln_paicli,
                                          ln_tipdoc,
                                          ls_numdoc)
      INTO lc_CALIFI
      FROM dual;
    --select fn_ah_calif_sbs('31/07/2020', 604, 21, '40760733') from dual
    --fn_ah_calif_sbs(ld_fecrcc DATE, pn_pepais number, pn_petdoc number, pc_pendoc char)
    ---***
    ---***
    --lc_TFPER1 := '9874598';
    --lc_TFPER2 := '9563219';
    --ln_ANTCRE := 9;
    --ln_ANTAHO := 50;
    --lc_CALIFI := '100% ANORMAL';
    ---***
  
    insert into JAQY255
      (jaqy255numer,
       jaqy255cosuc,
       jaqy255nosuc,
       jaqy255cousu,
       jaqy255nousu,
       jaqy255nocar,
       jaqy255noope,
       jaqy255nroco,
       jaqy255noper,
       jaqy255tfper,
       jaqy255hotra,
       jaqy255hoini,
       jaqy255hofin,
       jaqy255cotra,
       jaqy255dereg,
       jaqy255dezon,
       jaqy255dnius,
       jaqy255gecli,
       jaqy255fenac,
       jaqy255depro,
       jaqy255secli,
       jaqy255modes,
       jaqy255fedes,
       jaqy255paicli,
       jaqy255tipdoc,
       jaqy255numdoc,
       jaqy255prosbs,
       JAQY255FECCON,
       JAQY255GIRNEG,
       JAQY255EDAD,
       JAQY255TFPER1,
       JAQY255TFPER2,
       JAQY255ANTCRE,
       JAQY255ANTAHO,
       JAQY255CALIFI,
       JAQY255CREUSU)
    
    values
      (ln_contad,
       ln_codsuc,
       lc_dessuc,
       lc_codusu,
       lc_nomusu,
       lc_codcar,
       lc_desope,
       lc_codigo,
       lc_nomcli,
       lc_telcli,
       ld_horope,
       ld_horini,
       ld_horfin,
       ln_codigo,
       lc_desreg,
       lc_deszon,
       lc_dniusu,
       lc_sexcli,
       ld_fecnac,
       lc_despro,
       lc_segcli,
       ln_mondes,
       ld_fecdes,
       ln_paicli,
       ln_tipdoc,
       ls_numdoc,
       ls_prosbs,
       ld_FECCON,
       lc_GIRNEG,
       ln_EDAD,
       lc_TFPER1,
       lc_TFPER2,
       ln_ANTCRE,
       ln_ANTAHO,
       lc_CALIFI,
       lv_USRCRM);
  end loop;
  commit;
  ---***    
exception
  when others then
    dbms_output.put_line(sqlerrm);
    ---***       
end SP_AH_INSERCION_JAQY255_DIARIO;
/

