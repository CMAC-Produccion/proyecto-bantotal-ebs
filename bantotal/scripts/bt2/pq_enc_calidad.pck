create or replace package PQ_ENC_CALIDAD is
  -- ***************************************************************************************
  -- Nombre                     : PQ_ENC_CALIDAD
  -- Sistema                    : BANTOTAL
  -- Módulo                     : RECLAMOS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2013.11.28
  -- Autor de Creación          : CHERNANDEZ - RWONG
  -- Uso                        : GENRACION DE REPORTES EXPERIENCIA CLIENTE
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2025.01.17
  -- Modificado                 : CVILLON
  -- Descripción                : Reporte Multiusuario
  -- ***************************************************************************************

  ------------ Declaracion de variables -----------

  ------------ Declaracion de procedimientos ----------
  ---***
  function fn_ah_antiguedad_aho(pd_fecape DATE,
                                pn_pepais number,
                                pn_petdoc number,
                                pc_pendoc char) return date;
  function fn_ah_antiguedad_cre(pd_fecape DATE,
                                pn_pepais number,
                                pn_petdoc number,
                                pc_pendoc char) return date;
  function fn_ah_giro_negocio(pn_pepais number,
                              pn_petdoc number,
                              pc_pendoc char) return VARCHAR;
  function fn_ah_equivalenciadoc(p_tdoc in number) return varchar2;
  function fn_ah_calif_sbs(ld_fecrcc DATE,
                           pn_pepais number,
                           pn_petdoc number,
                           pc_pendoc char) return VARCHAR;

  procedure SP_AH_INSERCION_JAQY255(P_FECHA_APE in DATE,
                                    P_FECHA_DIA in DATE,
                                    P_FECHA_RCC in DATE,
                                    P_CREUSU    IN VARCHAR,
                                    ps_coderr   out char);

  procedure SP_AH_INSERCION_JAQY255_LOOP(DDMMYYYY_FECHA_INICIO in char,
                                         DDMMYYYY_FECHA_FIN    in char,
                                         P_CREUSU              IN VARCHAR,
                                         ps_coderr             out char);
  ---***
  --procedure fn_insercion_JAQY255(ps_coderr out char);
  function fn_descripcion_agencia(P_N_CODSUC in number) return character; --P_C_DESSUC
  function fn_nombre_usuario(P_N_CODUSU in character) return character; --P_C_DESUSU
  --function fn_descripcion_cargo(P_C_CODUSU in char) return char; --P_C_DESCAR
  function fn_nombre_cliente(P_N_CODCTA in character) return character; --P_C_NOMCLI
  function fn_telefono_cliente(P_N_CODCTA in character,
                               P_N_CODDEP in number,
                               P_N_CODPRI in number) return character; --P_C_TELCLI
  function fn_telefono_cliente2(P_N_CODEMP in number,
                                P_N_TIPDOC in number,
                                P_C_NUMDOC in character,
                                P_N_CODDEP in number,
                                P_N_CODPRI in number) return character; --P_C_TELCLI2
  function fn_tipo_cliente(P_N_CODCTA in character) return char; --P_C_TIPPER
  function fn_cargo_usuario(P_C_CODUSU in char) return char; --P_C_CARGO
  function fn_cargo_usuario2(P_C_CODUSU in char) return char; --P_C_CARGO
  function fn_descripcion_operacion(P_N_CODMOD in number,
                                    P_N_CODOPE in number) return char; --P_C_OPERAC
  function fn_sistema_modulos(P_N_CODMOD in number) return char; --P_C_EXITE
  function fn_total_clientes_analista(P_C_CODANA in character,
                                      P_D_FECINI in date,
                                      P_D_FECFIN in date) return number;
  function fn_garantia_inscrita(P_N_MOD    in number,
                                P_N_SUC    in number,
                                P_N_MON    in number,
                                P_N_PAP    in number,
                                P_N_CTA    in number,
                                P_N_OPE    in number,
                                P_N_SUBOPE in number) return character;
  function fn_total_clientes_encuesta(P_N_NUMCLI in number) return number;
  function fn_tipo_cartera(P_N_NUMCLI in number) return varchar;
  function fn_codigo_garantias(P_N_CODINS in number) return varchar;
  function fn_codigo_garantias_2(P_N_MOD    in number,
                                 P_N_SUC    in number,
                                 P_N_MON    in number,
                                 P_N_PAP    in number,
                                 P_N_CTA    in number,
                                 P_N_OPE    in number,
                                 P_N_SUBOPE in number) return varchar;
  function fn_descripcion_garantias(P_N_CODINS in number) return varchar;
  function fn_descripcion_garantias_2(P_N_MOD    in number,
                                      P_N_SUC    in number,
                                      P_N_MON    in number,
                                      P_N_PAP    in number,
                                      P_N_CTA    in number,
                                      P_N_OPE    in number,
                                      P_N_SUBOPE in number) return varchar;
  function fn_fecha_trimestre_inicial return date;
  function fn_fecha_trimestre_final return date;
  function fn_departamento(P_N_CODSUC in number) return number;
  function fn_codigo_persona(P_N_CODPAI in number,
                             P_N_TIPDOC in number,
                             P_C_NUMDOC in character) return character;
  function fn_codigo_referencia(P_N_CODCTA in number,
                                P_N_CODMOD in number,
                                P_N_CODMON in number,
                                P_N_CODSCT in number,
                                P_N_CODOPE in number,
                                P_N_TIPOPE in number) return character;
  function fn_codigo_referencia_credito(P_N_CODCTA in number,
                                        P_N_CODMON in number,
                                        P_N_CODOPE in number)
    return character;
  procedure fn_insercion_JAQY256(P_PERIODO      in character,
                                 P_FECHA_INICIO in character,
                                 P_FECHA_FIN    in character,
                                 P_ANIO         in character,
                                 P_TRIMESTRE    in character);
  function fn_numero_trimestre return number;
  function fn_anio return number;
  procedure fn_insercion_jaqy257;
  function fn_descripcion_departamento(P_N_CODDEP in number) return varchar;
  function fn_codigo_provincia(P_N_CODSUC in number) return number;
  function fn_descripcion_provincia(P_N_CODDEP in number,
                                    P_N_CODPRO in number) return varchar;
  function fn_obtener_departamento(P_PAIS  in number,
                                   P_TDOCU in number,
                                   P_NDOC  in varchar) return number;
  function fn_fecha_cali_credito return date;
  function fn_calificacion_credito(P_CTA in number, P_FECHA in date)
    return varchar;
  procedure fn_insert_anal_tri(P_FECHA_DDMMYYYY in character);
  procedure fn_insercion_JAQY592(DDMMYYYY_FECHA_INICIO in character,
                                 DDMMYYYY_FECHA_FIN    in character,
                                 ps_coderr             out char);
  function fn_obtener_region(P_CAGE in number) return varchar2;
  function fn_obtener_zona(P_CAGE in number) return varchar2;
  function fn_sexo_cliente(P_N_CODCTA in character) return character;
  function fn_fecnac_cliente(P_N_CODCTA in character) return date;
  function fn_docide_codusu(P_C_CODUSU in character) return character;
  function fn_segaho_cliente(P_N_CODCTA in character) return character;
  function fn_DesPro_Pasiva(P_N_CODMOD in number, P_N_TIPOPE in number)
    return character;
  function fn_mondes_cliente(P_N_CODCTA in character,
                             P_N_OPERAC in character) return number;
  function fn_fecdes_cliente(P_N_CODCTA in character,
                             P_N_OPERAC in character) return date;
  function fn_segcre_cliente(P_N_CODCTA in character) return character;
  function fn_DesPro_Activa(P_N_CODMOD in number) return character;
  function fn_segcli(pn_tipdoc number,
                     pn_codpai number,
                     ps_numdoc varchar2) return varchar;
  function fn_fecdes(pn_tipdoc number,
                     pn_codpai number,
                     ps_numdoc varchar2) return date;
  function fn_mondes(pn_tipdoc number,
                     pn_codpai number,
                     ps_numdoc varchar2) return number;
  function fn_prosbs(pn_tipdoc number,
                     pn_codpai number,
                     ps_numdoc varchar2) return varchar;
  function fn_dessbs(ps_codsbs varchar) return varchar;
  --procedure fn_insercion_JAQY255A(ps_coderr out char);
  procedure fn_insercion_JAQY255A(P_CREUSU IN VARCHAR, ps_coderr out char);

end PQ_ENC_CALIDAD;
/

create or replace package body PQ_ENC_CALIDAD is
  -- ***************************************************************************************
  -- Nombre                     : PQ_ENC_CALIDAD
  -- Sistema                    : BANTOTAL
  -- Módulo                     : RECLAMOS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2013.11.28
  -- Autor de Creación          : CHERNANDEZ - RWONG
  -- Uso                        : GENRACION DE REPORTES EXPERIENCIA CLIENTE
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2025.01.17
  -- Modificado                 : CVILLON
  -- Descripción                : Reporte Multiusuario
  -- ***************************************************************************************

  function fn_ah_antiguedad_aho(pd_fecape DATE,
                                pn_pepais number,
                                pn_petdoc number,
                                pc_pendoc char) return date is
    ld_ant_aho date;
  begin
    begin
      SELECT COALESCE(Min(sd11.SCFVAL), pd_fecape)
        INTO ld_ant_aho
        FROM fsr008 sr8
        JOIN fsd011 sd11
          ON (sr8.CTNRO = sd11.SCCTA AND sd11.PGCOD = 1 AND
             sd11.SCMOD IN (21, 22))
       WHERE sr8.PEPAIS = pn_pepais
         AND sr8.PETDOC = pn_petdoc
         AND sr8.PENDOC = pc_pendoc;
    exception
      when others then
        ld_ant_aho := null;
        dbms_output.put_line(sqlerrm);
    end;
    return ld_ant_aho;
  end fn_ah_antiguedad_aho;

  function fn_ah_antiguedad_cre(pd_fecape DATE,
                                pn_pepais number,
                                pn_petdoc number,
                                pc_pendoc char) return date is
    ld_ant_cre date;
  begin
    begin
      SELECT COALESCE(Min(SD10.AOFVAL), pd_fecape)
        INTO ld_ant_cre
        FROM fsr008 sr8
        JOIN fsd010 sd10
          ON (sr8.CTNRO = sd10.AOCTA AND sd10.PGCOD = 1 AND sd10.AOSBOP = 0)
       WHERE sr8.PEPAIS = pn_pepais
         AND sr8.PETDOC = pn_petdoc
         AND sr8.PENDOC = pc_pendoc;
    exception
      when others then
        ld_ant_cre := null;
        dbms_output.put_line(sqlerrm);
    end;
    return ld_ant_cre;
  end fn_ah_antiguedad_cre;

  function fn_ah_giro_negocio(pn_pepais number,
                              pn_petdoc number,
                              pc_pendoc char) return VARCHAR is
    lc_gironeg VARCHAR(60);
  begin
    begin
      SELECT f750.ACTNOM1
        INTO lc_gironeg
        FROM SNGC60 sn60
        JOIN FST750 f750
          ON (sn60.SNGC60ACTE = f750.ACTCOD1)
       WHERE sn60.SNGC60PAIS = pn_pepais
         AND sn60.SNGC60TDOC = pn_petdoc
         AND sn60.SNGC60NDOC = pc_pendoc;
    exception
      when others then
        lc_gironeg := 'N/A';
        dbms_output.put_line(sqlerrm);
    end;
    return lc_gironeg;
  end fn_ah_giro_negocio;

  function fn_ah_equivalenciadoc(p_tdoc in number) return varchar2 is
    cursor datos is
      select tp1nro2
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11111
         and tp1corr1 = 1
         and tp1corr2 = 5
         and tp1nro1 = p_tdoc;
  
    resp  number(5);
    respc varchar2(2);
  begin
    resp := 1;
    for i in datos loop
      resp := i.tp1nro2;
    end loop;
    respc := to_char(resp);
    return respc;
  end fn_ah_equivalenciadoc;

  function fn_ah_calif_sbs(ld_fecrcc DATE,
                           pn_pepais number,
                           pn_petdoc number,
                           pc_pendoc char) return VARCHAR is
    lc_calif    VARCHAR(30);
    lc_tdocequi VARCHAR(5);
    ln_calif0   NUMBER(6, 2);
    ln_calif1   NUMBER(6, 2);
    ln_calif2   NUMBER(6, 2);
    ln_calif3   NUMBER(6, 2);
    ln_calif4   NUMBER(6, 2);
    ln_califr   NUMBER(6, 2);
  
  begin
    begin
      ---***
      lc_calif := 'NORMAL (NR)';
      ---***
      ---*** Tipo de Documento Equivalente (DNI 21 --> 1)
      SELECT fn_ah_equivalenciadoc(pn_petdoc) INTO lc_tdocequi FROM dual;
      ---***
      --*** n_calif0 hasta n_calif4 son las calificaciones, deben sumar 100 , si no existen se asume que es 100% normal (n_calif0)
    
      IF (lc_tdocequi = '3') THEN
        SELECT COUNT(*)
          INTO ln_califr
          FROM CLDRCCI cld
         WHERE C_TDOCID = lc_tdocequi
           AND C_DOCTRI = TRIM(pc_pendoc)
           AND D_FECPRE = ld_fecrcc
           AND rownum = 1;
      
        IF (ln_califr > 0) THEN
          SELECT cld.N_CALIF0,
                 cld.N_CALIF1,
                 cld.N_CALIF2,
                 cld.N_CALIF3,
                 cld.N_CALIF4
            INTO ln_calif0, ln_calif1, ln_calif2, ln_calif3, ln_calif4
            FROM CLDRCCI cld
           WHERE C_TDOCID = lc_tdocequi
             AND C_DOCTRI = TRIM(pc_pendoc)
             AND D_FECPRE = ld_fecrcc
             AND rownum = 1;
        END IF;
      
      ELSE
        SELECT COUNT(*)
          INTO ln_califr
          FROM CLDRCCI cld
         WHERE C_TDOCID = lc_tdocequi
           AND C_DOCIDE = TRIM(pc_pendoc)
           AND D_FECPRE = ld_fecrcc
           AND rownum = 1;
      
        IF (ln_califr > 0) THEN
          SELECT cld.N_CALIF0,
                 cld.N_CALIF1,
                 cld.N_CALIF2,
                 cld.N_CALIF3,
                 cld.N_CALIF4
            INTO ln_calif0, ln_calif1, ln_calif2, ln_calif3, ln_calif4
            FROM CLDRCCI cld
           WHERE C_TDOCID = lc_tdocequi
             AND C_DOCIDE = TRIM(pc_pendoc)
             AND D_FECPRE = ld_fecrcc
             AND rownum = 1;
        END IF;
      END IF;
    
      IF (ln_calif4 > 0) THEN
        --lc_calif := TO_CHAR(ln_calif4)||'% PERDIDA';
        lc_calif := 'PERDIDA';
      ELSIF (ln_calif3 > 0) THEN
        --lc_calif := TO_CHAR(ln_calif3)||'% DUDOSO';
        lc_calif := 'DUDOSO';
      ELSIF (ln_calif2 > 0) THEN
        --lc_calif := TO_CHAR(ln_calif2)||'% DEFICIENTE';
        lc_calif := 'DEFICIENTE';
      ELSIF (ln_calif1 > 0) THEN
        --lc_calif := TO_CHAR(ln_calif1)||'% CPP';
        lc_calif := 'CPP';
      ELSE
        --lc_calif := '100% NORMAL';
        lc_calif := 'NORMAL';
      END IF;
    
    exception
      when others then
        lc_calif := 'ERROR N/A';
        dbms_output.put_line(sqlerrm);
    end;
    return lc_calif;
  end fn_ah_calif_sbs;

  procedure SP_AH_INSERCION_JAQY255(P_FECHA_APE in DATE,
                                    P_FECHA_DIA in DATE,
                                    P_FECHA_RCC in DATE,
                                    P_CREUSU    IN VARCHAR,
                                    ps_coderr   out char) is
  
    --P_C_CARGO PRFG00.PRFGNOM%type;
  
    cursor c_insercion is
    --productos activos
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
             a.itfcon = P_FECHA_DIA
         AND b.ITIMP1 > 3.00
      ---***
       inner join fsr008 fr
          on fr.ctnro = b.ctnro
         and fr.cttfir = 'T'
         and fr.ttcod = 1
       where a.ituing <> 'USRSWITCH'
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
         and b.modulo in (select modulo from fst111 where dscod = 50)
      
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
             a.itfcon = P_FECHA_DIA
         AND b.ITIMP1 > 3.00
      ---***
       inner join fsr008 fr
          on fr.ctnro = b.ctnro
         and fr.cttfir = 'T'
         and fr.ttcod = 1
       where a.ituing <> 'USRSWITCH'
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
               where tp1cod = 1
                 and tp1cod1 = 10803
                 and tp1corr1 in (2, 3)
                 and tp1nro3 <> 0)
         and b.modulo in (select modulo from fst111 where dscod = 50)
      
      UNION
      ---************ HISTORICO
      select distinct a.hfcon as D_FECCON,
                      a.hsucor || '-' || a.hcmod || '-' || a.htran || '-' ||
                      a.hnrel as N_CODTRA,
                      a.hfcon as D_FECOPE,
                      lpad(a.hsucor, 3, '0') as n_codage,
                      PQ_ENC_CALIDAD.fn_descripcion_agencia(a.hsucor) as C_DESAGE,
                      a.husing as C_CODUSU,
                      PQ_ENC_CALIDAD.fn_nombre_usuario(a.husing) as C_NOMUSU,
                      PQ_ENC_CALIDAD.fn_cargo_usuario2(a.husing) C_CARGO,
                      PQ_ENC_CALIDAD.fn_descripcion_operacion(a.hcmod,
                                                              a.htran) C_DESOPE,
                      a.hhora as d_horope,
                      a.hhora as d_horini,
                      a.hhora as d_horfin,
                      PQ_ENC_CALIDAD.fn_codigo_referencia_credito(b.hcta,
                                                                  b.hmda,
                                                                  b.htoper) codigo,
                      PQ_ENC_CALIDAD.fn_nombre_cliente(b.hcta) c_nomcli,
                      
                      PQ_ENC_CALIDAD.fn_obtener_region(a.hsucor) c_desreg,
                      PQ_ENC_CALIDAD.fn_obtener_zona(a.hsucor) c_deszon,
                      PQ_ENC_CALIDAD.fn_docide_codusu(a.husing) c_dniusu,
                      PQ_ENC_CALIDAD.fn_sexo_cliente(b.hcta) c_sexcli,
                      PQ_ENC_CALIDAD.fn_fecnac_cliente(b.hcta) d_fecnac,
                      PQ_ENC_CALIDAD.fn_despro_Activa(b.hmodul) c_despro,
                      PQ_ENC_CALIDAD.fn_segcre_cliente(b.hcta) c_desseg,
                      --PQ_ENC_CALIDAD.fn_mondes_cliente(b.hcta,b.htoper) n_mondes,
                      b.HCIMP1 AS n_mondes,
                      
                      PQ_ENC_CALIDAD.fn_fecdes_cliente(b.hcta, b.htoper) d_fecdes,
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
      
        from fsh015 a
       inner join fsh016 b
          on (a.PGCOD = b.PGCOD AND a.HCMOD = b.HCMOD AND
             a.HSUCOR = b.HSUCOR AND a.HTRAN = b.HTRAN AND
             a.HNREL = b.HNREL AND a.HFCON = b.HFCON AND
             ---***
             a.HFCON = P_FECHA_DIA AND b.HCIMP1 > 3.00
             ---***
             )
       inner join fsr008 fr
          on b.PGCOD = fr.PGCOD
         and b.HCTA = fr.CTNRO
         and fr.CTTFIR = 'T'
         and fr.TTCOD = 1
       where a.husing <> 'USRSWITCH'
         and b.hcta <> 0
         and a.hsucor not in (901, 902, 903, 904, 905)
         and a.hccorr = 0
         and PQ_ENC_CALIDAD.fn_tipo_cliente(b.hcta) <> 'J'
         and PQ_ENC_CALIDAD.fn_telefono_cliente(b.hcta,
                                                PQ_ENC_CALIDAD.fn_departamento(a.hsucor),
                                                1) is not null
         and (a.hcmod, a.htran) in
             (select tp1nro1 as itmod, tp1nro2 as ittran
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 10803
                 and tp1corr1 in (2, 3)
                 and tp1nro3 = 0)
         and b.hmodul in (select modulo from fst111 where dscod = 50)
      
      UNION
      
      select distinct a.hfcon as D_FECCON,
                      a.hsucor || '-' || a.hcmod || '-' || a.htran || '-' ||
                      a.hnrel as N_CODTRA,
                      a.hfcon as D_FECOPE,
                      lpad(a.hsucor, 3, '0') as n_codage,
                      PQ_ENC_CALIDAD.fn_descripcion_agencia(a.hsucor) as C_DESAGE,
                      a.husing as C_CODUSU,
                      PQ_ENC_CALIDAD.fn_nombre_usuario(a.husing) as C_NOMUSU,
                      PQ_ENC_CALIDAD.fn_cargo_usuario2(a.husing) C_CARGO,
                      PQ_ENC_CALIDAD.fn_descripcion_operacion(a.hcmod,
                                                              a.htran) C_DESOPE,
                      a.hhora as d_horope,
                      a.hhora as d_horini,
                      a.hhora as d_horfin,
                      PQ_ENC_CALIDAD.fn_codigo_referencia_credito(b.hcta,
                                                                  b.hmda,
                                                                  b.htoper) codigo,
                      PQ_ENC_CALIDAD.fn_nombre_cliente(b.hcta) c_nomcli,
                      
                      PQ_ENC_CALIDAD.fn_obtener_region(a.hsucor) c_desreg,
                      PQ_ENC_CALIDAD.fn_obtener_zona(a.hsucor) c_deszon,
                      PQ_ENC_CALIDAD.fn_docide_codusu(a.husing) c_dniusu,
                      PQ_ENC_CALIDAD.fn_sexo_cliente(b.hcta) c_sexcli,
                      PQ_ENC_CALIDAD.fn_fecnac_cliente(b.hcta) d_fecnac,
                      PQ_ENC_CALIDAD.fn_despro_Activa(b.hmodul) c_despro,
                      PQ_ENC_CALIDAD.fn_segcre_cliente(b.hcta) c_desseg,
                      --PQ_ENC_CALIDAD.fn_mondes_cliente(b.hcta,b.htoper) n_mondes,
                      b.HCIMP1 AS n_mondes,
                      
                      PQ_ENC_CALIDAD.fn_fecdes_cliente(b.hcta, b.htoper) d_fecdes,
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
      
        from fsh015 a
       inner join fsh016 b
          on (a.PGCOD = b.PGCOD AND a.HCMOD = b.HCMOD AND
             a.HSUCOR = b.HSUCOR AND a.HTRAN = b.HTRAN AND
             a.HNREL = b.HNREL AND a.HFCON = b.HFCON AND
             ---***
             a.HFCON = P_FECHA_DIA AND b.HCIMP1 > 3.00
             ---***
             )
       inner join fsr008 fr
          on b.PGCOD = fr.PGCOD
         and b.HCTA = fr.CTNRO
         and fr.CTTFIR = 'T'
         and fr.TTCOD = 1
       where a.husing <> 'USRSWITCH'
         and b.hcta <> 0
         and a.hsucor not in (901, 902, 903, 904, 905)
         and a.hccorr = 0
         and PQ_ENC_CALIDAD.fn_tipo_cliente(b.hcta) <> 'J'
         and PQ_ENC_CALIDAD.fn_telefono_cliente(b.hcta,
                                                PQ_ENC_CALIDAD.fn_departamento(a.hsucor),
                                                1) is not null
         and (a.hcmod, a.htran, b.hcord) in
             (select tp1nro1 as itmod, tp1nro2 as ittran, tp1nro3 as itord
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 10803
                 and tp1corr1 in (2, 3)
                 and tp1nro3 <> 0)
         and b.hmodul in (select modulo from fst111 where dscod = 50)
      
      UNION
      
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
             a.ITFCON = P_FECHA_DIA
         AND b.ITIMP1 > 3.00
      ---***
       inner join fsr008 fr
          on fr.ctnro = b.ctnro
         and fr.cttfir = 'T'
         and fr.ttcod = 1
       where a.ituing <> 'USRSWITCH'
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
         and b.modulo in (21, 22)
      
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
             a.ITFCON = P_FECHA_DIA
         AND b.ITIMP1 > 3.00
      ---***
       inner join fsr008 fr
          on fr.ctnro = b.ctnro
         and fr.cttfir = 'T'
         and fr.ttcod = 1
       where a.ituing <> 'USRSWITCH'
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
               where tp1cod = 1
                 and tp1cod1 = 10803
                 and tp1corr1 in (2, 3)
                 and tp1nro3 <> 0)
         and b.modulo in (21, 22)
      
      UNION
      ---*** HISTORICO
      select distinct a.hfcon as D_FECCON,
                      a.hsucor || '-' || a.hcmod || '-' || a.htran || '-' ||
                      a.hnrel as N_CODTRA,
                      a.hfcon as D_FECOPE,
                      lpad(a.hsucor, 3, '0') as n_codage,
                      PQ_ENC_CALIDAD.fn_descripcion_agencia(a.hsucor) as C_DESAGE,
                      a.husing as C_CODUSU,
                      PQ_ENC_CALIDAD.fn_nombre_usuario(a.husing) as C_NOMUSU,
                      PQ_ENC_CALIDAD.fn_cargo_usuario2(a.husing) C_CARGO,
                      PQ_ENC_CALIDAD.fn_descripcion_operacion(a.hcmod,
                                                              a.htran) C_DESOPE,
                      a.hhora as d_horope,
                      a.hhora as d_horini,
                      a.hhora as d_horfin,
                      PQ_ENC_CALIDAD.fn_codigo_referencia(b.hcta,
                                                          b.hmodul,
                                                          b.hmda,
                                                          b.hcsubo,
                                                          b.hoper,
                                                          b.htoper) codigo,
                      PQ_ENC_CALIDAD.fn_nombre_cliente(b.hcta) c_nomcli,
                      
                      PQ_ENC_CALIDAD.fn_obtener_region(a.hsucor) c_desreg,
                      PQ_ENC_CALIDAD.fn_obtener_zona(a.hsucor) c_deszon,
                      PQ_ENC_CALIDAD.fn_docide_codusu(a.husing) c_dniusu,
                      PQ_ENC_CALIDAD.fn_sexo_cliente(b.hcta) c_sexcli,
                      PQ_ENC_CALIDAD.fn_fecnac_cliente(b.hcta) d_fecnac,
                      PQ_ENC_CALIDAD.fn_despro_Pasiva(b.hmodul, b.htoper) c_despro,
                      PQ_ENC_CALIDAD.fn_segaho_cliente(b.hcta) c_desseg,
                      --0 n_mondes,
                      b.HCIMP1 AS n_mondes,
                      
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
      
        from fsh015 a
       inner join fsh016 b
          on (a.PGCOD = b.PGCOD AND a.HCMOD = b.HCMOD AND
             a.HSUCOR = b.HSUCOR AND a.HTRAN = b.HTRAN AND
             a.HNREL = b.HNREL AND a.HFCON = b.HFCON AND
             ---***
             a.HFCON = P_FECHA_DIA AND b.HCIMP1 > 3.00
             ---***
             )
       inner join fsr008 fr
          on b.PGCOD = fr.PGCOD
         and b.HCTA = fr.CTNRO
         and fr.CTTFIR = 'T'
         and fr.TTCOD = 1
       where a.husing <> 'USRSWITCH'
         and b.hcta <> 0
         and a.hsucor not in (901, 902, 903, 904, 905)
         and a.hccorr = 0
         and PQ_ENC_CALIDAD.fn_tipo_cliente(b.hcta) <> 'J'
         and PQ_ENC_CALIDAD.fn_telefono_cliente(b.hcta,
                                                PQ_ENC_CALIDAD.fn_departamento(a.hsucor),
                                                1) is not null
         and (a.hcmod, a.htran) in
             (select tp1nro1 as itmod, tp1nro2 as ittran
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 10803
                 and tp1corr1 in (2, 3)
                 and tp1nro3 = 0)
         and b.hmodul in (21, 22)
      
      UNION
      
      select distinct a.hfcon as D_FECCON,
                      a.hsucor || '-' || a.hcmod || '-' || a.htran || '-' ||
                      a.hnrel as N_CODTRA,
                      a.hfcon as D_FECOPE,
                      lpad(a.hsucor, 3, '0') as n_codage,
                      PQ_ENC_CALIDAD.fn_descripcion_agencia(a.hsucor) as C_DESAGE,
                      a.husing as C_CODUSU,
                      PQ_ENC_CALIDAD.fn_nombre_usuario(a.husing) as C_NOMUSU,
                      PQ_ENC_CALIDAD.fn_cargo_usuario2(a.husing) C_CARGO,
                      PQ_ENC_CALIDAD.fn_descripcion_operacion(a.hcmod,
                                                              a.htran) C_DESOPE,
                      a.hhora as d_horope,
                      a.hhora as d_horini,
                      a.hhora as d_horfin,
                      PQ_ENC_CALIDAD.fn_codigo_referencia(b.hcta,
                                                          b.hmodul,
                                                          b.hmda,
                                                          b.hcsubo,
                                                          b.hoper,
                                                          b.htoper) codigo,
                      PQ_ENC_CALIDAD.fn_nombre_cliente(b.hcta) c_nomcli,
                      
                      PQ_ENC_CALIDAD.fn_obtener_region(a.hsucor) c_desreg,
                      PQ_ENC_CALIDAD.fn_obtener_zona(a.hsucor) c_deszon,
                      PQ_ENC_CALIDAD.fn_docide_codusu(a.husing) c_dniusu,
                      PQ_ENC_CALIDAD.fn_sexo_cliente(b.hcta) c_sexcli,
                      PQ_ENC_CALIDAD.fn_fecnac_cliente(b.hcta) d_fecnac,
                      PQ_ENC_CALIDAD.fn_despro_Pasiva(b.hmodul, b.htoper) c_despro,
                      PQ_ENC_CALIDAD.fn_segaho_cliente(b.hcta) c_desseg,
                      --0 n_mondes,
                      b.HCIMP1 AS n_mondes,
                      
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
      
        from fsh015 a
       inner join fsh016 b
          on (a.PGCOD = b.PGCOD AND a.HCMOD = b.HCMOD AND
             a.HSUCOR = b.HSUCOR AND a.HTRAN = b.HTRAN AND
             a.HNREL = b.HNREL AND a.HFCON = b.HFCON AND
             ---***
             a.HFCON = P_FECHA_DIA AND b.HCIMP1 > 3.00
             ---***
             )
       inner join fsr008 fr
          on b.PGCOD = fr.PGCOD
         and b.HCTA = fr.CTNRO
         and fr.CTTFIR = 'T'
         and fr.TTCOD = 1
       where a.husing <> 'USRSWITCH'
         and b.hcta <> 0
         and a.hsucor not in (901, 902, 903, 904, 905)
         and a.hccorr = 0
         and PQ_ENC_CALIDAD.fn_tipo_cliente(b.hcta) <> 'J'
         and PQ_ENC_CALIDAD.fn_telefono_cliente(b.hcta,
                                                PQ_ENC_CALIDAD.fn_departamento(a.hsucor),
                                                1) is not null
         and (a.hcmod, a.htran, b.hcord) in
             (select tp1nro1 as itmod, tp1nro2 as ittran, tp1nro3 as itord
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 10803
                 and tp1corr1 in (2, 3)
                 and tp1nro3 <> 0)
         and b.hmodul in (21, 22);
  
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
  begin
    ---***
    SELECT COALESCE(MAX(JAQY255NUMER), 0) INTO ln_contad FROM JAQY255;
    ---***
    for i in c_insercion loop
      ln_contad := ln_contad + 1;
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
      lc_GIRNEG  := fn_ah_giro_negocio(ln_paicli, ln_tipdoc, ls_numdoc);
      --lc_GIRNEG := 'COMERCIANTE';
      --ln_EDAD   := 39;
      SELECT ROUND((P_FECHA_APE - ld_fecnac) / 365.25, 2)
        INTO ln_EDAD
        FROM dual;
      ---***
      /*
      lc_TFPER1 := '';
      IF(lc_TELCLIR <> '') THEN
        SELECT COALESCE(f005.DOTELFP, '') INTO lc_TFPER1
        FROM FSR005 f005
        WHERE f005.PEPAIS = ln_paicli
        AND f005.PETDOC = ln_tipdoc
        AND f005.PENDOC = ls_numdoc
        AND f005.DOTELFP NOT IN (lc_TELCLIR);
      END IF;
      */
      ---***
      /*
      SELECT COALESCE(f005.DOTELFP, '')
        FROM FSR005 f005
        WHERE f005.PEPAIS = 604
        AND f005.PETDOC = 21
        AND f005.PENDOC = '09452248'
        AND f005.DOTELFP NOT IN ('952514979');
      */
      /*
      lc_TFPER2 := '';
      IF(lc_TFPER1 <> '') THEN
        SELECT COALESCE(f005.DOTELFP, '') INTO lc_TFPER2
        FROM FSR005 f005
        WHERE f005.PEPAIS = ln_paicli
        AND f005.PETDOC = ln_tipdoc
        AND f005.PENDOC = ls_numdoc
        AND f005.DOTELFP NOT IN (lc_TELCLIR, lc_TFPER1);
      END IF;
      */
      ---***
      SELECT fn_ah_antiguedad_cre(P_FECHA_APE,
                                  ln_paicli,
                                  ln_tipdoc,
                                  ls_numdoc)
        INTO ld_ANTCRE
        FROM dual;
      SELECT MONTHS_BETWEEN(P_FECHA_APE, ld_ANTCRE)
        INTO ln_ANTCRE
        FROM dual;
      ---***
      SELECT fn_ah_antiguedad_aho(P_FECHA_APE,
                                  ln_paicli,
                                  ln_tipdoc,
                                  ls_numdoc)
        INTO ld_ANTAHO
        FROM dual;
      SELECT MONTHS_BETWEEN(P_FECHA_APE, ld_ANTAHO)
        INTO ln_ANTAHO
        FROM dual;
      ---***
      SELECT fn_ah_calif_sbs(P_FECHA_RCC, ln_paicli, ln_tipdoc, ls_numdoc)
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
         P_CREUSU);
    end loop;
    commit;
  exception
    when others then
      dbms_output.put_line(sqlerrm);
  end SP_AH_INSERCION_JAQY255;
  ---***
  procedure SP_AH_INSERCION_JAQY255_LOOP(DDMMYYYY_FECHA_INICIO in char,
                                         DDMMYYYY_FECHA_FIN    in char,
                                         P_CREUSU              IN VARCHAR,
                                         ps_coderr             out char) is
  
    ln_FecIni NUMBER;
    ln_FecFin NUMBER;
    ln_Dia    NUMBER;
    ld_Dia    DATE;
    ld_FecApe DATE;
    ld_FecRCC DATE;
  
  begin
    ln_FecIni := TO_NUMBER(TO_CHAR(TO_DATE(DDMMYYYY_FECHA_INICIO,
                                           'DDMMYYYY'),
                                   'j'));
    ln_FecFin := TO_NUMBER(TO_CHAR(TO_DATE(DDMMYYYY_FECHA_FIN, 'DDMMYYYY'),
                                   'j'));
    ---***
    DELETE FROM JAQY255 WHERE JAQY255CREUSU = P_CREUSU;
    ---***FECAPE
    SELECT PGFAPE INTO ld_FecApe FROM FST017 WHERE PGCOD = 1;
    ---***FECRCC
    SELECT TO_DATE(tpnro, 'DDMMYYYY')
      INTO ld_FecRCC
      FROM Fst098
     WHERE pgcod = 1
       AND Tpcod = 7647
       AND Tpcorr = 12;
    ---***
    FOR ln_Dia IN ln_FecIni .. ln_FecFin LOOP
      ld_Dia := TO_DATE(ln_Dia, 'j');
      SP_AH_INSERCION_JAQY255(ld_FecApe,
                              ld_Dia,
                              ld_FecRCC,
                              P_CREUSU,
                              ps_coderr);
      --dbms_output.put_line(ld_Dia);
    END LOOP;
  end SP_AH_INSERCION_JAQY255_LOOP;

  ---***********************************************************************************************************

  --------------------------------------

  function fn_descripcion_agencia(P_N_CODSUC in number) return character is
    P_C_DESSUC fst001.SCNOM%type;
  begin
  
    begin
      select f.scnom
        into P_C_DESSUC
        from FST001 f
       where f.sucurs = P_N_CODSUC;
    exception
      when no_data_found then
        P_C_DESSUC := null;
      when others then
        P_C_DESSUC := null;
    end;
  
    return(P_C_DESSUC);
  
  end fn_descripcion_agencia;

  ---------------------------------------

  function fn_nombre_usuario(P_N_CODUSU in character) return character is
    P_C_NOMUSU FST746.UBNOM%type;
  begin
  
    begin
      select f.ubnom
        into P_C_NOMUSU
        from FST746 f
       where f.ubuser = P_N_CODUSU;
    exception
      when no_data_found then
        P_C_NOMUSU := null;
      when others then
        P_C_NOMUSU := null;
    end;
  
    return(P_C_NOMUSU);
  
  end fn_nombre_usuario;

  ---------------------------------------
  --function fn_telefono_cliente(P_N_CODEMP in number, P_N_TIPDOC in number, P_C_NUMDOC in character, P_N_CODDEP in number, P_N_CODPRI in number) return character is --P_C_TELCLI
  function fn_telefono_cliente(P_N_CODCTA in character,
                               P_N_CODDEP in number,
                               P_N_CODPRI in number) return character is
    --P_C_TELCLI
    P_C_TELCLI  character(20);
    P_C_TELCLI2 character(25);
    ln_tamanio  number;
  begin
    begin
      SELECT /*+INDEX(FR SYS_C00978537)*/
       FR.DOTELFP
        INTO P_C_TELCLI
        FROM FSR005 FR
       WHERE (FR.PEPAIS, FR.PETDOC, FR.PENDOC) IN
             (SELECT /*+INDEX(F1 SYS_C00982619)*/
               F1.PEPAIS, F1.PETDOC, F1.PENDOC
                FROM FSD001 F1
               WHERE (F1.PEPAIS, F1.PETDOC, F1.PENDOC) IN
                     (SELECT /*+INDEX(FS SYS_C00982110)*/
                       FS.PEPAIS, FS.PETDOC, FS.PENDOC
                        FROM FSR008 FS
                       WHERE FS.PGCOD = 1
                         AND FS.CTNRO = P_N_CODCTA
                         AND CTTFIR = 'T'))
         AND DOCOD = 1
         AND DOORDP = P_N_CODPRI;
      /*select fr.dotelfp
      into P_C_TELCLI
      from fsr005 fr
      where fr.pepais = P_N_CODEMP
      and   fr.petdoc = P_N_TIPDOC
      and   fr.pendoc = P_C_NUMDOC
      and   fr.docod  = 1
      and   fr.doordp = P_N_CODPRI;*/
    
      ln_tamanio := length(trim(P_C_TELCLI));
      if ln_tamanio < 9 then
        case
          when P_N_CODDEP = 1 then
            P_C_TELCLI2 := '(041)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 2 then
            P_C_TELCLI2 := '(043)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 3 then
            P_C_TELCLI2 := '(083)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 4 then
            P_C_TELCLI2 := '(054)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 5 then
            P_C_TELCLI2 := '(066)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 6 then
            P_C_TELCLI2 := '(076)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 7 then
            P_C_TELCLI2 := '(01)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 8 then
            P_C_TELCLI2 := '(084)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 9 then
            P_C_TELCLI2 := '(067)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 10 then
            P_C_TELCLI2 := '(052)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 11 then
            P_C_TELCLI2 := '(056)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 12 then
            P_C_TELCLI2 := '(064)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 13 then
            P_C_TELCLI2 := '(044)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 14 then
            P_C_TELCLI2 := '(074)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 15 then
            P_C_TELCLI2 := '(01)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 16 then
            P_C_TELCLI2 := '(065)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 17 then
            P_C_TELCLI2 := '(082)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 18 then
            P_C_TELCLI2 := '(053)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 19 then
            P_C_TELCLI2 := '(063)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 20 then
            P_C_TELCLI2 := '(073)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 21 then
            P_C_TELCLI2 := '(051)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 22 then
            P_C_TELCLI2 := '(042)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 23 then
            P_C_TELCLI2 := '(052)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 24 then
            P_C_TELCLI2 := '(072)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 25 then
            P_C_TELCLI2 := '(061)' || trim(P_C_TELCLI);
          else
            P_C_TELCLI2 := trim(P_C_TELCLI);
        end case;
      elsif ln_tamanio >= 9 then
        P_C_TELCLI2 := trim(P_C_TELCLI);
      end if;
    end;
  
    return(P_C_TELCLI2);
  
  end fn_telefono_cliente;

  ------------------------------------------

  function fn_telefono_cliente2(P_N_CODEMP in number,
                                P_N_TIPDOC in number,
                                P_C_NUMDOC in character,
                                P_N_CODDEP in number,
                                P_N_CODPRI in number) return character is
    --P_C_TELCLI
    --function fn_telefono_cliente(P_N_CODCTA in character,P_N_CODDEP in number, P_N_CODPRI in number) return character is --P_C_TELCLI
    P_C_TELCLI  character(20);
    P_C_TELCLI2 character(25);
    ln_tamanio  number;
  begin
    begin
      /*select fr.dotelfp
      into P_C_TELCLI
      from fsr005 fr
      where (fr.pepais,fr.petdoc,fr.pendoc)
           in (select f1.pepais,f1.petdoc,f1.pendoc
               from fsd001 f1
               where (f1.pepais,f1.petdoc,f1.pendoc)
                     in (select fs.pepais,fs.petdoc,fs.pendoc
                         from fsr008 fs
                         where fs.ctnro=P_N_CODCTA and cttfir='T'))
                         and docod  = 1
                         and doordp = P_N_CODPRI;    */
      select fr.dotelfp
        into P_C_TELCLI
        from fsr005 fr
       where fr.pepais = P_N_CODEMP
         and fr.petdoc = P_N_TIPDOC
         and fr.pendoc = P_C_NUMDOC
         and fr.docod = 1
         and fr.doordp = P_N_CODPRI;
    
      ln_tamanio := length(trim(P_C_TELCLI));
      if ln_tamanio < 9 then
        case
          when P_N_CODDEP = 1 then
            P_C_TELCLI2 := '(041)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 2 then
            P_C_TELCLI2 := '(043)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 3 then
            P_C_TELCLI2 := '(083)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 4 then
            P_C_TELCLI2 := '(054)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 5 then
            P_C_TELCLI2 := '(066)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 6 then
            P_C_TELCLI2 := '(076)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 7 then
            P_C_TELCLI2 := '(01)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 8 then
            P_C_TELCLI2 := '(084)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 9 then
            P_C_TELCLI2 := '(067)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 10 then
            P_C_TELCLI2 := '(052)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 11 then
            P_C_TELCLI2 := '(056)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 12 then
            P_C_TELCLI2 := '(064)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 13 then
            P_C_TELCLI2 := '(044)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 14 then
            P_C_TELCLI2 := '(074)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 15 then
            P_C_TELCLI2 := '(01)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 16 then
            P_C_TELCLI2 := '(065)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 17 then
            P_C_TELCLI2 := '(082)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 18 then
            P_C_TELCLI2 := '(053)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 19 then
            P_C_TELCLI2 := '(063)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 20 then
            P_C_TELCLI2 := '(073)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 21 then
            P_C_TELCLI2 := '(051)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 22 then
            P_C_TELCLI2 := '(042)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 23 then
            P_C_TELCLI2 := '(052)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 24 then
            P_C_TELCLI2 := '(072)' || trim(P_C_TELCLI);
          when P_N_CODDEP = 25 then
            P_C_TELCLI2 := '(061)' || trim(P_C_TELCLI);
          else
            P_C_TELCLI2 := trim(P_C_TELCLI);
        end case;
      elsif ln_tamanio >= 9 then
        P_C_TELCLI2 := trim(P_C_TELCLI);
      end if;
    end;
  
    return(P_C_TELCLI2);
  
  end fn_telefono_cliente2;
  ------------------------------------------

  function fn_tipo_cliente(P_N_CODCTA in character) return char is
    --P_C_TIPPER
    P_C_TIPPER FSD001.PETIPO%type;
  begin
  
    begin
      select /*+index(FS SYS_C00982619)*/
       fs.petipo
        into P_C_TIPPER
        from fsd001 fs
       where (fs.pepais, fs.petdoc, fs.pendoc) in
             (select /*+index(FR SYS_C00982110)*/
               fr.pepais, fr.petdoc, fr.pendoc
                from fsr008 fr
               where FR.PGCOD = 1
                 and fr.ctnro = P_N_CODCTA
                 and fr.cttfir = 'T'
                 and fr.ttcod = 1);
    exception
      when no_data_found then
        P_C_TIPPER := null;
      when others then
        P_C_TIPPER := null;
    end;
  
    return P_C_TIPPER;
  
  end fn_tipo_cliente;

  ------------------------------------------

  function fn_cargo_usuario(P_C_CODUSU in char) return char is
    --P_C_CARGO
    P_C_CARGO PRFG00.PRFGNOM%type;
  
    cursor c_perfiles is
      select u.prfgcod Perfil from prfu00 u where u.ubuser = P_C_CODUSU;
  
    -- para el cursor
    ld_perfil char(16) := null;
    --
  begin
    for i in c_perfiles loop
      ld_perfil := i.Perfil;
      if ld_perfil is not null and trim(ld_perfil) <> '' then
        exit;
      end if;
    end loop;
  
    begin
      select g.prfgnom
        into P_C_CARGO
        from prfg00 g
       where prfgcod = ld_perfil;
    exception
      when no_data_found then
        P_C_CARGO := null;
      when others then
        P_C_CARGO := null;
    end;
  
    return P_C_CARGO;
  
  end fn_cargo_usuario;

  ------------------------------------------

  function fn_cargo_usuario2(P_C_CODUSU in char) return char is
  
    P_C_CARGO sng055.sng055DSC%type;
    lc_CODUSU CHAR(10);
  
  begin
    ---***
    lc_CODUSU := trim(P_C_CODUSU);
    ---***
    begin
      select sng055DSC
        into P_C_CARGO
        from sng055
       where (sng055emp, sng055car) in
             (select sng055emp, sng055car
                from sng057
               where sng057usr = lc_CODUSU);
    
    exception
      when no_data_found then
        P_C_CARGO := null;
      when others then
        P_C_CARGO := null;
    end;
  
    return P_C_CARGO;
  
  end fn_cargo_usuario2;

  ---------------------------------------------

  function fn_descripcion_operacion(P_N_CODMOD in number,
                                    P_N_CODOPE in number) return char is
    --P_C_OPERAC
    P_C_OPERAC FST034.TRNOM%type;
  begin
  
    begin
      select fs.trnom
        into P_C_OPERAC
        from fst034 fs
       where (fs.trmod, fs.trnro) in
             (select fd.itmod, fd.ittran
                from fsd015 fd
               where fd.itmod = P_N_CODMOD
                 and fd.ittran = P_N_CODOPE);
    exception
      when no_data_found then
        P_C_OPERAC := null;
      when others then
        P_C_OPERAC := null;
    end;
  
    return(P_C_OPERAC);
  
  end fn_descripcion_operacion;

  ---------------------------------------------

  function fn_sistema_modulos(P_N_CODMOD in number) return char is
    --P_C_EXISTE
    P_C_EXISTE char;
  
    cursor c_modulos is
      select fs.modulo Modulo from fst111 fs where fs.dscod = 50;
  
    -- para el cursor
    ld_modulo number(3) := null;
    --
  begin
    for i in c_modulos loop
      ld_modulo := i.Modulo;
      if ld_modulo = P_N_CODMOD then
        P_C_EXISTE := 'Y';
      end if;
    end loop;
    return P_C_EXISTE;
  end fn_sistema_modulos;

  ---------------------------------------

  function fn_nombre_cliente(P_N_CODCTA in character) return character is
    --P_C_NOMCLI
    P_C_NOMCLI FSD001.PENOM%type;
  begin
  
    begin
      select f.penom
        into P_C_NOMCLI
        from fsd001 f
       where (f.pepais, f.petdoc, f.pendoc) IN
             (select fr.pepais, fr.petdoc, fr.pendoc
                from fsr008 fr
               where fr.ctnro = P_N_CODCTA
                 and fr.cttfir = 'T'
                 and fr.ttcod = 1);
    exception
      when no_data_found then
        P_C_NOMCLI := null;
      when others then
        P_C_NOMCLI := null;
    end;
    return P_C_NOMCLI;
  end fn_nombre_cliente;

  --------------------------------------

  function fn_total_clientes_analista(P_C_CODANA in character,
                                      P_D_FECINI in date,
                                      P_D_FECFIN in date) return number is
    --que reciba fecha
    P_N_TOTAL number;
  begin
    begin
      select count(distinct(d.pendoc))
        into P_N_TOTAL
        from sng001 a, xwf700 x, fsd010 b, fsr008 d
       where a.sng001ase = P_C_CODANA
         and a.sng001inst = x.xwfprcins
         and b.pgcod = x.xwfempresa
         and b.aomod = x.xwfmodulo
         and b.aosuc = x.xwfsucursal
         and b.aomda = x.xwfmoneda
         and b.aopap = x.xwfpapel
         and b.aocta = x.xwfcuenta
         and b.aooper = x.xwfoperacion
         and b.aosbop = x.xwfsubope
         and b.aotope = x.xwftipope
         and b.aocta = d.ctnro
         and x.xwfcar3 = '1'
         and b.aostat <> 99
         and x.xwfmodulo in (select modulo from fst111 where dscod = 50)
         and b.aofval between P_D_FECINI and P_D_FECFIN
       group by a.sng001ase
       order by a.sng001ase;
    exception
      when no_data_found then
        P_N_TOTAL := null;
      when others then
        P_N_TOTAL := null;
    end;
    return P_N_TOTAL;
  
    /*cursor c_total is
         select distinct a.sng001pais Pais,a.sng001tdoc TDoc,a.sng001ndoc NDoc
         from sng001 a, sngas2 b, xwf700 c, fsd011 d
         where a.sng001ase = P_C_CODANA and a.sng001fin between P_D_FECINI and P_D_FECFIN
         and a.sng001ase = b.sngas2usr
         and a.sng001inst = c.xwfprcins
         and c.xwfcar3  = '1'
         and c.xwfempresa = d.pgcod
         and c.xwfsucursal = d.scsuc
         and c.xwfmodulo = d.scmod
         and c.xwfmoneda = d.scmda
         and c.xwfpapel = d.scpap
         and c.xwfcuenta = d.sccta
         and c.xwfoperacion = d.scoper
         and c.xwfsubope = d.scsbop
         and c.xwftipope = d.sctope
         and d.scstat <> 99
         and c.xwfmodulo in (select modulo from fst111 where dscod = 50);
    
       -- para el cursor
       ln_pais number(3)  := null;
       ln_tdoc number(2)  := null;
       lc_ndoc character(12) := null;
       l number(9) := 0;
    
       --
    begin
       for i in c_total
       loop
         ln_pais := i.pais;
         ln_tdoc := i.tdoc;
         lc_ndoc := i.ndoc;
         l := l + 1;
       end loop;
       P_N_TOTAL := l;
       return P_N_TOTAL;*/
  
  end fn_total_clientes_analista;

  --------------------------------------

  function fn_garantia_inscrita(P_N_MOD    in number,
                                P_N_SUC    in number,
                                P_N_MON    in number,
                                P_N_PAP    in number,
                                P_N_CTA    in number,
                                P_N_OPE    in number,
                                P_N_SUBOPE in number) return character is
    P_C_NINSCRITO character;
    varaux        int;
  begin
    P_C_NINSCRITO := 'N';
    begin
      select count(rel.r2tope)
        into varaux
        from Fsr011 rel
       where rel.r1cod = 1
         and rel.r1mod = P_N_MOD
         and rel.r1suc = P_N_SUC
         and rel.r1mda = P_N_MON
         and rel.r1pap = P_N_PAP
         and rel.r1cta = P_N_CTA
         and rel.r1oper = P_N_OPE
         and rel.r1sbop = P_N_SUBOPE
            --and rel.r1tope       = tipope
         and rel.relcod = 50 --garantia
         and rel.r011co = 'S'
         and rel.r2tope not in (select tp1nro1 Valor
                                  from fst198
                                 where tp1cod = 1
                                   and tp1cod1 = 10803
                                   and tp1corr1 = 1
                                   and tp1corr2 = 1
                                   and tp1nro1 <> 0);
      if varaux > 0 then
        P_C_NINSCRITO := 'S';
      else
        P_C_NINSCRITO := 'N';
      end if;
      --RETORNA DESCRIPCION DE GARANTIA ----
    exception
      when no_data_found then
        P_C_NINSCRITO := 'N';
      when too_many_rows then
        P_C_NINSCRITO := 'S';
    end;
    return P_C_NINSCRITO;
  
  end fn_garantia_inscrita;

  --------------------------------------

  function fn_total_clientes_encuesta(P_N_NUMCLI in number) return number is
    P_N_ENCUESTA NUMBER;
    cursor c_valores is
      select TP1NRO1 MINIMO, TP1NRO2 MAXIMO, TP1NRO3 TOTAL, TP1DESC CARTERA
        from fst198
       where tp1cod1 = 10803
         and tp1corr2 = 0
         and tp1corr3 <> 0;
    -- para el cursor
    ln_minimo number(4) := null;
    ln_maximo number(4) := null;
    ln_total  number(4) := null;
    --
  begin
    for i in c_valores loop
      ln_minimo := i.minimo;
      ln_maximo := i.maximo;
      ln_total  := i.total;
    
      if ln_minimo = 719 then
        P_N_ENCUESTA := ln_total;
        exit;
      elsif P_N_NUMCLI >= ln_minimo and P_N_NUMCLI <= ln_maximo then
        P_N_ENCUESTA := ln_total;
        exit;
      end if;
    end loop;
  
    return P_N_ENCUESTA;
  
  end fn_total_clientes_encuesta;

  --------------------------------------

  function fn_tipo_cartera(P_N_NUMCLI in number) return varchar is
    P_C_CARTERA varchar(45);
    cursor c_valores is
      select TP1NRO1 MINIMO, TP1NRO2 MAXIMO, TP1NRO3 TOTAL, TP1DESC CARTERA
        from fst198
       where tp1cod1 = 10803
         and tp1corr2 = 0
         and tp1corr3 <> 0;
    -- para el cursor
    ln_minimo  number(4) := null;
    ln_maximo  number(4) := null;
    ln_cartera varchar(45) := null;
    --
  begin
    for i in c_valores loop
      ln_minimo  := i.minimo;
      ln_maximo  := i.maximo;
      ln_cartera := i.cartera;
    
      if ln_minimo = 719 then
        --P_N_NUMCLI <> 0 and
        P_C_CARTERA := ln_cartera;
        exit;
      elsif P_N_NUMCLI >= ln_minimo and P_N_NUMCLI <= ln_maximo then
        --P_N_NUMCLI <> 0 and
        P_C_CARTERA := ln_cartera;
        exit;
      end if;
    end loop;
  
    return P_C_CARTERA;
  
  end fn_tipo_cartera;

  --------------------------------------

  function fn_codigo_garantias(P_N_CODINS in number) return varchar is
    P_C_CODGARANTIAS varchar(50) := null;
    ln_conta         number := 1;
    cursor c_codgarantias is
      select distinct sng122tope TIPOPE
        from sng122
       where sng122inst = P_N_CODINS
         and sng122mod = 70;
    -- para el cursor
    ln_tipope number(4) := null;
    --
  begin
    P_C_CODGARANTIAS := '';
    for i in c_codgarantias loop
      ln_tipope := i.tipope;
      if ln_conta = 1 then
        P_C_CODGARANTIAS := ln_tipope;
      else
        P_C_CODGARANTIAS := P_C_CODGARANTIAS || ' | ' || ln_tipope;
      end if;
      ln_conta := ln_conta + 1;
    end loop;
  
    return P_C_CODGARANTIAS;
  
  end fn_codigo_garantias;

  --------------------------------------

  function fn_codigo_garantias_2(P_N_MOD    in number,
                                 P_N_SUC    in number,
                                 P_N_MON    in number,
                                 P_N_PAP    in number,
                                 P_N_CTA    in number,
                                 P_N_OPE    in number,
                                 P_N_SUBOPE in number) return varchar is
    cursor garantia(mod    in varchar2,
                    suc    in varchar2,
                    mon    in varchar2,
                    pap    varchar2,
                    cta    varchar2,
                    ope    varchar2,
                    subope varchar2) is
      select distinct R2MOD, R2SBOP, r2suc, r2pap, r2tope
        from Fsr011 rel
       where rel.r1cod = 1
         and rel.r1mod = mod
         and rel.r1suc = suc
         and rel.r1mda = mon
         and rel.r1pap = pap
         and rel.r1cta = cta
         and rel.r1oper = ope
         and rel.r1sbop = subope
            --and rel.r1tope       = tipope
         and rel.relcod = 50 --garantia
         and rel.r011co = 'S';
    lc_garantia varchar2(1000);
    lc_tonom    varchar2(40);
  begin
    for y in garantia(P_N_MOD, P_N_SUC, P_N_MON, P_N_PAP, P_N_CTA, P_N_OPE, P_N_SUBOPE) loop
      ---campos de FSD011 CREDITO
      if y.r2tope is not null then
        lc_garantia := lc_garantia || y.r2tope || ' | '; ---concatena descripcion
      end if;
    
    end loop;
    return lc_garantia;
  end fn_codigo_garantias_2;

  --------------------------------------

  function fn_descripcion_garantias(P_N_CODINS in number) return varchar is
    P_C_DESGARANTIAS VARCHAR(255) := null;
    P_C_GARANTIA     FST004.TONOM%TYPE;
    ln_cont          number := 1;
    cursor c_desgarantias is
      select distinct sng122tope TIPOPE
        from sng122
       where sng122inst = P_N_CODINS
         and sng122mod = 70;
    -- para el cursor
    ln_tipope number(4) := null;
    --
  begin
    P_C_DESGARANTIAS := '';
    for i in c_desgarantias loop
      ln_tipope := i.tipope;
      select tonom
        into P_C_GARANTIA
        from fst004
       where modulo = 70
         and totope = ln_tipope;
      --             P_C_DESGARANTIAS := trim(P_C_DESGARANTIAS) ||','|| trim(P_C_GARANTIA);
      If ln_cont = 1 then
        P_C_DESGARANTIAS := trim(P_C_GARANTIA);
      else
        P_C_DESGARANTIAS := trim(P_C_DESGARANTIAS) || ', ' ||
                            trim(P_C_GARANTIA);
      end if;
      ln_cont := ln_cont + 1;
    end loop;
  
    return P_C_DESGARANTIAS;
  end fn_descripcion_garantias;

  --------------------------------------

  function fn_descripcion_garantias_2(P_N_MOD    in number,
                                      P_N_SUC    in number,
                                      P_N_MON    in number,
                                      P_N_PAP    in number,
                                      P_N_CTA    in number,
                                      P_N_OPE    in number,
                                      P_N_SUBOPE in number) return varchar is
    cursor garantia(mod    in varchar2,
                    suc    in varchar2,
                    mon    in varchar2,
                    pap    varchar2,
                    cta    varchar2,
                    ope    varchar2,
                    subope varchar2) is
      select distinct R2MOD, R2SBOP, r2suc, r2pap, r2tope
        from Fsr011 rel
       where rel.r1cod = 1
         and rel.r1mod = mod
         and rel.r1suc = suc
         and rel.r1mda = mon
         and rel.r1pap = pap
         and rel.r1cta = cta
         and rel.r1oper = ope
         and rel.r1sbop = subope
            --and rel.r1tope       = tipope
         and rel.relcod = 50 --garantia
         and rel.r011co = 'S';
    lc_garantia varchar2(1000);
    lc_tonom    varchar2(40);
  begin
    for y in garantia(P_N_MOD, P_N_SUC, P_N_MON, P_N_PAP, P_N_CTA, P_N_OPE, P_N_SUBOPE) loop
      ---campos de FSD011 CREDITO
      if y.r2tope is not null then
        begin
          select trim(tonom)
            into lc_tonom
            from fst004
           where modulo = 70
             and totope = y.r2tope; --RETORNA DESCRIPCION DE GARANTIA ----
        exception
          when no_data_found then
            lc_tonom := null;
        end;
        lc_garantia := lc_garantia || lc_tonom || '|'; ---concatena descripcion
      end if;
    
    end loop;
    return lc_garantia;
  end fn_descripcion_garantias_2;

  --------------------------------------

  function fn_fecha_trimestre_inicial return date is
    P_D_FECINI date := null;
    ld_fecini  date := null;
    ld_fecfin  date := null;
    ln_anio    number := null;
    ln_mes     number := null;
    ld_fecact  date := to_date(trunc(sysdate), 'yyyy.mm.dd');
  begin
    ln_mes  := extract(month FROM ld_fecact);
    ln_anio := extract(year FROM ld_fecact);
    if ln_mes in (1, 2, 3) then
      ld_fecini  := to_date(to_char(ln_anio) || '.01.01', 'yyyy.mm.dd');
      ld_fecfin  := to_date(to_char(ln_anio) || '.03.31', 'yyyy.mm.dd');
      P_D_FECINI := ld_fecini;
    elsif ln_mes in (4, 5, 6) then
      ld_fecini  := to_date(to_char(ln_anio) || '.04.01', 'yyyy.mm.dd');
      ld_fecfin  := to_date(to_char(ln_anio) || '.06.30', 'yyyy.mm.dd');
      P_D_FECINI := ld_fecini;
    
    elsif ln_mes in (7, 8, 9) then
      ld_fecini  := to_date(to_char(ln_anio) || '.07.01', 'yyyy.mm.dd');
      ld_fecfin  := to_date(to_char(ln_anio) || '.09.30', 'yyyy.mm.dd');
      P_D_FECINI := ld_fecini;
    
    elsif ln_mes in (10, 11, 12) then
      ld_fecini  := to_date(to_char(ln_anio) || '.10.01', 'yyyy.mm.dd');
      ld_fecfin  := to_date(to_char(ln_anio) || '.12.31', 'yyyy.mm.dd');
      P_D_FECINI := ld_fecini;
    end if;
  
    return P_D_FECINI;
  end fn_fecha_trimestre_inicial;

  --------------------------------------

  function fn_fecha_trimestre_final return date is
    P_D_FECFIN date := null;
    ld_fecini  date := null;
    ld_fecfin  date := null;
    ln_anio    number := null;
    ln_mes     number := null;
    ld_fecact  date := to_date(trunc(sysdate), 'yyyy.mm.dd'); --'2012.05.25'
  
  begin
    ln_mes  := extract(month FROM ld_fecact);
    ln_anio := extract(year FROM ld_fecact);
    if ln_mes in (1, 2, 3) then
      ld_fecini  := to_date(to_char(ln_anio) || '.01.01', 'yyyy.mm.dd');
      ld_fecfin  := to_date(to_char(ln_anio) || '.03.31', 'yyyy.mm.dd');
      P_D_FECFIN := ld_fecfin;
    elsif ln_mes in (4, 5, 6) then
      ld_fecini  := to_date(to_char(ln_anio) || '.04.01', 'yyyy.mm.dd');
      ld_fecfin  := to_date(to_char(ln_anio) || '.06.30', 'yyyy.mm.dd');
      P_D_FECFIN := ld_fecfin;
    elsif ln_mes in (7, 8, 9) then
      ld_fecini  := to_date(to_char(ln_anio) || '.07.01', 'yyyy.mm.dd');
      ld_fecfin  := to_date(to_char(ln_anio) || '.09.30', 'yyyy.mm.dd');
      P_D_FECFIN := ld_fecfin;
    elsif ln_mes in (10, 11, 12) then
      ld_fecini  := to_date(to_char(ln_anio) || '.10.01', 'yyyy.mm.dd');
      ld_fecfin  := to_date(to_char(ln_anio) || '.12.31', 'yyyy.mm.dd');
      P_D_FECFIN := ld_fecfin;
    end if;
    return P_D_FECFIN;
  end fn_fecha_trimestre_final;

  --------------------------------------

  function fn_departamento(P_N_CODSUC in number) return number is
    P_N_CODDEP fst001.scdept%type;
  begin
    begin
      /*select distinct scdept
      into P_N_CODDEP
      from fst001
      where sucurs = P_N_CODSUC;*/
      select scdept
        into P_N_CODDEP
        from fst001
       where sucurs = P_N_CODSUC
         and rownum < 2; --20231110
    exception
      when no_data_found then
        P_N_CODDEP := null;
      when others then
        P_N_CODDEP := null;
    end;
    return P_N_CODDEP;
  end fn_departamento;

  ----------------------------------------------------------------------------

  function fn_codigo_persona(P_N_CODPAI in number,
                             P_N_TIPDOC in number,
                             P_C_NUMDOC in character) return character is
    P_C_CODPER character(17) := null;
    lc_codpai  character(3) := null;
    lc_tipdoc  character(2) := null;
    lc_numdoc  character(12) := null;
  begin
    lc_codpai := to_char(trim(P_N_CODPAI));
    lc_tipdoc := to_char(trim(P_N_TIPDOC));
    lc_numdoc := trim(P_C_NUMDOC);
  
    P_C_CODPER := lc_codpai || lc_tipdoc || lc_numdoc;
    return P_C_CODPER;
  exception
    when no_data_found then
      P_C_CODPER := 'BEATRIZ';
    when others then
      P_C_CODPER := 'IRENE';
      return P_C_CODPER;
  end fn_codigo_persona;

  --------------------------------------

  procedure fn_insercion_JAQY256(P_PERIODO      in character,
                                 P_FECHA_INICIO in character,
                                 P_FECHA_FIN    in character,
                                 P_ANIO         in character,
                                 P_TRIMESTRE    in character) is
  
    CURSOR U_ANA IS
      SELECT C_codana, num_cli_total, tipo, num_cli_enc
        FROM anal_tri_4
       order by C_codana;
    cursor C_CLI(p_analista    varchar2,
                 P_fecha_ini   character,
                 P_fecha_fin   character,
                 P_fecha_cre   date,
                 p_tipo_cambio number) is
    
      select /*+ PARALLEL(USU, 2) PARALLEL(MON, 2) PARALLEL(PRO, 2) PARALLEL(DEP, 2) PARALLEL(AGE, 2) PARALLEL(CLI, 2) PARALLEL(APE, 2) PARALLEL(SOLI, 2) */
       trim(cli.pfape1) || ' ' || trim(cli.pfape2) || ', ' ||
       trim(cli.pfnom1) || ' ' || trim(cli.pfnom2) as C_NOMCON,
       soli.sng001ndoc as C_CODPER,
       pq_enc_calidad.fn_telefono_cliente2(soli.sng001pais,
                                           soli.sng001tdoc,
                                           soli.sng001ndoc,
                                           pq_enc_calidad.fn_obtener_departamento(soli.sng001pais,
                                                                                  soli.sng001tdoc,
                                                                                  soli.sng001ndoc),
                                           1) as F1,
       pq_enc_calidad.fn_telefono_cliente2(soli.sng001pais,
                                           soli.sng001tdoc,
                                           soli.sng001ndoc,
                                           pq_enc_calidad.fn_obtener_departamento(soli.sng001pais,
                                                                                  soli.sng001tdoc,
                                                                                  soli.sng001ndoc),
                                           2) as F2,
       pq_enc_calidad.fn_telefono_cliente2(soli.sng001pais,
                                           soli.sng001tdoc,
                                           soli.sng001ndoc,
                                           pq_enc_calidad.fn_obtener_departamento(soli.sng001pais,
                                                                                  soli.sng001tdoc,
                                                                                  soli.sng001ndoc),
                                           3) as F3,
       pq_enc_calidad.fn_telefono_cliente2(soli.sng001pais,
                                           soli.sng001tdoc,
                                           soli.sng001ndoc,
                                           pq_enc_calidad.fn_obtener_departamento(soli.sng001pais,
                                                                                  soli.sng001tdoc,
                                                                                  soli.sng001ndoc),
                                           4) as F4,
       pq_enc_calidad.fn_telefono_cliente2(soli.sng001pais,
                                           soli.sng001tdoc,
                                           soli.sng001ndoc,
                                           pq_enc_calidad.fn_obtener_departamento(soli.sng001pais,
                                                                                  soli.sng001tdoc,
                                                                                  soli.sng001ndoc),
                                           4) as F5,
       soli.sng001ase as C_CODANA,
       trim(usu.ubnom) ANALISTA,
       age.scnom as AGENCIA,
       soli.sng001age as C_CODAGE,
       dep.depnom DPT,
       pro.locnom PRO,
       pro.loccod C_UBGDIR,
       trim(mon.monom) MONEDA,
       ape.aoimp N_MTOAPR, --no sirve
       DECODE(est.scmda, 0, ape.aoimp, ape.aoimp * p_tipo_cambio) MTOAPR_SOLES, --no sirve
       'SIN CALIFICACION' CALIF_CLIENTE, --no sirve
       '-' COD_CALIF_CLIENTE, --no sirve
       substr(pq_enc_calidad.fn_calificacion_credito(soli.sng001cta,
                                                     P_fecha_cre),
              3) as CALIF_CREDITO, --no sirve
       substr(pq_enc_calidad.fn_calificacion_credito(soli.sng001cta,
                                                     P_fecha_cre),
              1,
              1) COD_CALIF_CREDITO, --no sirve
       0 N_DIAATR, --no sirve
       substr(PQ_ENC_CALIDAD.fn_descripcion_garantias_2(est.scmod,
                                                        est.scsuc,
                                                        est.scmda,
                                                        est.scpap,
                                                        est.sccta,
                                                        est.scoper,
                                                        est.scsbop),
              1,
              254) GARANTIAS, --no sirve
       substr(PQ_ENC_CALIDAD.fn_codigo_garantias_2(est.scmod,
                                                   est.scsuc,
                                                   est.scmda,
                                                   est.scpap,
                                                   est.sccta,
                                                   est.scoper,
                                                   est.scsbop),
              1,
              254) COD_GARANTIAS, --no sirve
       est.scfval FECDES,
       0 as NUM_CLI_TOTAL, --no sirve
       '' tipo,
       0 as NUM_CLI_ENC,
       --FN_GAR_INSCR(CR.C_NUMCRE) GAR_INS
       pq_enc_calidad.fn_garantia_inscrita(est.scmod,
                                           est.scsuc,
                                           est.scmda,
                                           est.scpap,
                                           est.sccta,
                                           est.scoper,
                                           est.scsbop) GAR_INS,
       soli.sng001inst,
       soli.sng001cta,
       PQ_ENC_CALIDAD.fn_obtener_region(soli.sng001age) c_desreg,
       PQ_ENC_CALIDAD.fn_obtener_zona(soli.sng001age) c_deszon,
       PQ_ENC_CALIDAD.fn_docide_codusu(soli.sng001ase) c_dniusu,
       PQ_ENC_CALIDAD.fn_sexo_cliente(soli.sng001cta) c_sexcli,
       PQ_ENC_CALIDAD.fn_fecnac_cliente(soli.sng001cta) d_fecnac,
       PQ_ENC_CALIDAD.fn_despro_Activa(est.scmod) c_despro,
       PQ_ENC_CALIDAD.fn_segcre_cliente(soli.sng001cta) c_desseg,
       PQ_ENC_CALIDAD.fn_mondes_cliente(est.sccta, est.scoper) n_mondes,
       PQ_ENC_CALIDAD.fn_fecdes_cliente(est.sccta, est.scoper) d_fecdes,
       cli.pfpais ncodpai,
       cli.pftdoc ntipdoc,
       PQ_ENC_CALIDAD.fn_dessbs(substr(est.scrub, 5, 2) ||
                                substr(est.scrub, 12, 2)) cprosbs
        from fsd011 est
       inner join xwf700 cusoli
          on est.PGCOD = cusoli.xwfempresa
         and est.SCMOD = cusoli.xwfmodulo
         and est.SCTOPE = cusoli.xwftipope
         and est.SCMDA = cusoli.xwfmoneda
         and est.SCPAP = cusoli.xwfpapel
         and est.SCCTA = cusoli.xwfcuenta
         and est.SCOPER = cusoli.xwfoperacion
         and est.SCSBOP = cusoli.xwfsubope
       inner join sng001 soli
          on soli.sng001inst = cusoli.xwfprcins
       inner join fsd010 ape
          on est.PGCOD = ape.pgcod
         and est.SCMOD = ape.aomod
         and est.SCTOPE = ape.aotope
         and est.SCMDA = ape.aomda
         and est.SCPAP = ape.aopap
         and est.SCCTA = ape.aocta
         and est.SCOPER = ape.aooper
         and est.SCSBOP = ape.aosbop
       inner join fsd002 cli
          on soli.sng001pais = cli.pfpais
         and soli.sng001tdoc = cli.pftdoc
         and soli.sng001ndoc = cli.pfndoc
       inner join fst001 age
          on age.pgcod = 1
         and soli.sng001age = age.sucurs
       inner join fst068 dep
          on dep.pais = 604
         and age.scdept = dep.depcod
       inner join fst070 pro
          on dep.pais = pro.pais
         and dep.depcod = pro.depcod
         and to_number(age.scciud) = pro.loccod
       inner join fst005 mon
          on est.scmda = mon.moneda
       inner join fst746 usu
          on trim(usu.ubuser) = trim(soli.sng001ase)
       where /*soli.sng001cta = '45685'
                                                                                                                                                                             and */
      
       est.scmod in (select modulo from fst111 where dscod = 50)
       and est.scstat = 0
       and est.scfval BETWEEN TO_DATE(P_fecha_ini, 'DDMMYYYY') AND
       TO_DATE(P_fecha_fin, 'DDMMYYYY')
       and pq_enc_calidad.fn_telefono_cliente2(soli.sng001pais,
                                           soli.sng001tdoc,
                                           soli.sng001ndoc,
                                           pq_enc_calidad.fn_obtener_departamento(soli.sng001pais,
                                                                                  soli.sng001tdoc,
                                                                                  soli.sng001ndoc),
                                           1) is not null
       and soli.sng001ase = p_analista
       order by est.scfval desc;
  
    --
    ln_contad  number := 0;
    ln_index   number := 0;
    EXISTE     NUMBER;
    s_sql      VARCHAR2(500);
    t_cambio   number;
    f_calicred date;
    --
  begin
  
    begin
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ANAL_TRI_4';
      /*       EXCEPTION
      WHEN OTHERS THEN
          dbms_output.put_line(sqlerrm);*/
    end;
  
    begin
      EXECUTE IMMEDIATE 'INSERT INTO ANAL_TRI_4
                                   select anio,trimestre,c_codana,c_nomusu,C_CODAGE,agencia,num_cli_total,
                                         CASE
                                           WHEN NUM_CLI_TOTAL > 719 THEN ' || '''' ||
                        '0. CARTERA MUY GRANDE' || '''' || '
                                           WHEN NUM_CLI_TOTAL BETWEEN 560 AND 719 THEN ' || '''' ||
                        '1. CARTERA GRANDE' || '''' || '
                                           WHEN NUM_CLI_TOTAL BETWEEN 400 AND 559 THEN ' || '''' ||
                        '2. CARTERA MEDIANA' || '''' || '
                                           WHEN NUM_CLI_TOTAL BETWEEN 321 AND 399 THEN ' || '''' ||
                        '3. CARTERA PEQUEÑA' || '''' || '
                                           WHEN NUM_CLI_TOTAL BETWEEN 161 AND 320 THEN ' || '''' ||
                        '4. CARTERA MUY PEQUEÑA' || '''' || '
                                           WHEN NUM_CLI_TOTAL BETWEEN 10  AND 160 THEN ' || '''' ||
                        '5. CARTERA NUEVA' || '''' || '
                                           WHEN NUM_CLI_TOTAL < 10 THEN ' || '''' ||
                        '6. CARTERA VOLANTE' || '''' || '
                                         END TIPO,
                                         CASE
                                           WHEN NUM_CLI_TOTAL > 719 THEN 30
                                           WHEN NUM_CLI_TOTAL BETWEEN 560 AND 719 THEN 25
                                           WHEN NUM_CLI_TOTAL BETWEEN 400 AND 559 THEN 20
                                           WHEN NUM_CLI_TOTAL BETWEEN 321 AND 399 THEN 10
                                           WHEN NUM_CLI_TOTAL BETWEEN 161 AND 320 THEN 15
                                           WHEN NUM_CLI_TOTAL BETWEEN 10  AND 160 THEN 10
                                           WHEN NUM_CLI_TOTAL < 10 THEN 10
                                         END NUM_CLI_ENC
                                  from
                                  (
                                  select /*+ PARALLEL(SUCU, 2) PARALLEL(USUAGE, 2) PARALLEL(USU, 2) PARALLEL(EST, 2) PARALLEL(CUSOLI, 2) PARALLEL(SOLI, 2) */
                                         ' || '''' ||
                        P_ANIO || '''' ||
                        ' ANIO,
                                         ' || '''' ||
                        P_TRIMESTRE || '''' ||
                        ' TRIMESTRE,
                                         soli.sng001ase as c_codana,
                                         usu.ubnom as c_nomusu,
                                         usuage.ubsuc as C_CODAGE,
                                         sucu.scnom as agencia,
                                         COUNT(DISTINCT soli.sng001cta) NUM_CLI_TOTAL

                                    from sng001 soli,xwf700 cusoli, fsd011 est, fst746 usu, fst046 usuage, fst001 sucu
                                   where est.PGCOD = cusoli.xwfempresa
                                         and est.SCMOD = cusoli.xwfmodulo
                                         and est.SCTOPE = cusoli.xwftipope
                                         and est.SCMDA = cusoli.xwfmoneda
                                         and est.SCPAP = cusoli.xwfpapel
                                         and est.SCCTA = cusoli.xwfcuenta
                                         and est.SCOPER = cusoli.xwfoperacion
                                         and est.SCSBOP = cusoli.xwfsubope
                                         and soli.sng001inst = cusoli.xwfprcins
                                         and soli.sng001ase = usu.ubuser
                                         and usuage.ubuser = usu.ubuser
                                         and est.scstat = 0
                                         and usuage.pgcod = sucu.pgcod
                                         and usuage.ubsuc = sucu.sucurs
                                         AND soli.sng001ase = usuage.ubuser
                                   group by sng001ase, ubnom,ubsuc,scnom
                                   )';
      --       EXCEPTION
      --           WHEN OTHERS THEN
      --               dbms_output.put_line(sqlerrm);
      COMMIT;
    
      /* begin
        DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                      tabname          => 'ANAL_TRI_4',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;*/
    
    end;
  
    ln_index := 0;
  
    delete from jaqy256;
    commit;
    f_calicred := fn_fecha_cali_credito;
    FOR C_ANA IN U_ANA LOOP
      ln_contad := 0;
      select tccpa
        into t_cambio
        from (select tccpa, tcfch
                from fsd120
               where tccod = 500
                 and tcmda = 101
               order by tcfch desc)
       where rownum = 1;
    
      for C_CLI1 in C_CLI(C_ANA.C_codana, P_FECHA_INICIO, P_FECHA_FIN,
       --fn_fecha_cali_credito,
       f_calicred, t_cambio) loop
        SELECT COUNT(*)
          INTO EXISTE
          FROM jaqy256 CC
         WHERE CC.JAQY256CODPE = C_CLI1.C_CODPER;
        IF (ln_contad >= C_ANA.NUM_CLI_ENC) then
          EXIT;
        END IF;
        IF (EXISTE = 0) THEN
          ln_contad := ln_contad + 1;
          ln_index  := ln_index + 1;
          INSERT INTO jaqy256 --**
          VALUES
            (ln_index,
             C_CLI1.C_NOMCON,
             C_CLI1.C_CODPER,
             C_CLI1.F1,
             C_CLI1.F2,
             C_CLI1.F3,
             C_CLI1.F4,
             C_CLI1.F5,
             C_CLI1.C_CODANA,
             C_CLI1.ANALISTA,
             C_CLI1.AGENCIA,
             C_CLI1.C_CODAGE,
             C_CLI1.DPT,
             C_CLI1.PRO,
             C_CLI1.C_UBGDIR,
             C_CLI1.MONEDA,
             C_CLI1.N_MTOAPR,
             C_CLI1.MTOAPR_SOLES,
             C_CLI1.CALIF_CLIENTE,
             C_CLI1.COD_CALIF_CLIENTE,
             C_CLI1.CALIF_CREDITO,
             C_CLI1.COD_CALIF_CREDITO,
             C_CLI1.N_DIAATR,
             C_CLI1.GARANTIAS,
             C_CLI1.COD_GARANTIAS,
             C_CLI1.FECDES,
             c_ana.NUM_CLI_TOTAL,
             c_ana.TIPO,
             c_ana.NUM_CLI_ENC,
             c_cli1.GAR_INS,
             c_cli1.c_desreg,
             c_cli1.c_deszon,
             c_cli1.c_dniusu,
             c_cli1.c_sexcli,
             c_cli1.d_fecnac,
             c_cli1.c_despro,
             c_cli1.c_desseg,
             c_cli1.n_mondes,
             c_cli1.d_fecdes,
             c_cli1.ncodpai,
             c_cli1.ntipdoc,
             c_cli1.cprosbs,
             CURRENT_TIMESTAMP,
             '12:00:00',
             0,
             0,
             0,
             '',
             '',
             '');
          COMMIT;
        END IF;
      END LOOP;
    END LOOP;
    --  exception
    --    when others then
    --      dbms_output.put_line(sqlerrm);
  
  end fn_insercion_JAQY256;

  --------------------------------------

  function fn_codigo_referencia(P_N_CODCTA in number,
                                P_N_CODMOD in number,
                                P_N_CODMON in number,
                                P_N_CODSCT in number,
                                P_N_CODOPE in number,
                                P_N_TIPOPE in number) return character is
    lc_cuenta character(9) := null;
    lc_modulo character(3) := null;
    lc_moneda character(3) := null;
    lc_subcta character(3) := null;
    lc_operac character(9) := null;
    lc_tipope character(3) := null;
    lc_codigo character(30) := null;
  
  begin
    if P_N_CODMOD = 21 then
      lc_cuenta := to_char(lpad(P_N_CODCTA, 9, 0));
      lc_modulo := to_char(lpad(P_N_CODMOD, 3, 0));
      lc_moneda := to_char(lpad(P_N_CODMON, 3, 0));
      lc_subcta := to_char(lpad(P_N_CODSCT, 2, 0));
      lc_tipope := to_char(lpad(P_N_TIPOPE, 3, 0));
      lc_codigo := lc_cuenta || lc_modulo || lc_moneda || lc_subcta ||
                   lc_tipope;
    else
      lc_cuenta := to_char(lpad(P_N_CODCTA, 9, 0));
      lc_modulo := to_char(lpad(P_N_CODMOD, 3, 0));
      lc_moneda := to_char(lpad(P_N_CODMON, 3, 0));
      lc_operac := to_char(lpad(P_N_CODOPE, 9, 0));
      lc_tipope := to_char(lpad(P_N_TIPOPE, 3, 0));
      lc_codigo := lc_cuenta || lc_modulo || lc_moneda || lc_operac ||
                   lc_tipope;
    end if;
    return lc_codigo;
  end fn_codigo_referencia;

  --------------------------------------

  function fn_codigo_referencia_credito(P_N_CODCTA in number,
                                        P_N_CODMON in number,
                                        P_N_CODOPE in number)
    return character is
    lc_cuenta character(9) := null;
    lc_moneda character(3) := null;
    lc_operac character(9) := null;
    lc_tipope character(3) := null;
    lc_codigo character(30) := null;
  
  begin
    lc_cuenta := to_char(lpad(P_N_CODCTA, 9, 0));
    lc_moneda := to_char(lpad(P_N_CODMON, 3, 0));
    lc_operac := to_char(lpad(P_N_CODOPE, 9, 0));
    lc_codigo := lc_cuenta || lc_moneda || lc_operac;
    return lc_codigo;
  end fn_codigo_referencia_credito;

  --------------------------------------

  function fn_numero_trimestre return number is
    P_N_NUMTRI   number := null;
    ln_trimestre number := null;
    ln_anio      number := null;
    ln_mes       number := null;
    ld_fecact    date := to_date(trunc(sysdate), 'yyyy.mm.dd');
  
  begin
    ln_mes  := extract(month FROM ld_fecact);
    ln_anio := extract(year FROM ld_fecact);
    if ln_mes in (1, 2, 3) then
      ln_trimestre := 1;
      P_N_NUMTRI   := ln_trimestre;
    elsif ln_mes in (4, 5, 6) then
      ln_trimestre := 2;
      P_N_NUMTRI   := ln_trimestre;
    
    elsif ln_mes in (7, 8, 9) then
      ln_trimestre := 3;
      P_N_NUMTRI   := ln_trimestre;
    
    elsif ln_mes in (10, 11, 12) then
      ln_trimestre := 4;
      P_N_NUMTRI   := ln_trimestre;
    end if;
  
    return P_N_NUMTRI;
  end fn_numero_trimestre;

  --------------------------------------

  function fn_anio return number is
    P_N_ANIO  number := null;
    ln_anio   number := null;
    ld_fecact date := to_date(trunc(sysdate), 'yyyy.mm.dd');
  
  begin
    ln_anio  := extract(year FROM trunc(sysdate));
    P_N_ANIO := ln_anio;
    return P_N_ANIO;
  end fn_anio;

  --------------------------------------

  procedure fn_insercion_JAQY257 is
    cursor c_insercion257 is
      select /*+parallel(a,2,1) parallel(b,2,1) parallel(c,2,1) parallel(d,2,1) choose*/
      distinct PQ_ENC_CALIDAD.fn_anio ANO,
               PQ_ENC_CALIDAD.fn_numero_trimestre TRIMESTRE,
               b.sngas2usr CODIGO_ANALISTA,
               PQ_ENC_CALIDAD.fn_nombre_usuario(b.sngas2usr) ANALISTA,
               d.scsuc AGENCIA,
               PQ_ENC_CALIDAD.fn_descripcion_agencia(d.scsuc) DESCRIPCION_AGENCIA,
               PQ_ENC_CALIDAD.fn_total_clientes_analista(a.sng001ase,
                                                         Pq_Enc_Calidad.fn_fecha_trimestre_inicial,
                                                         Pq_Enc_Calidad.fn_fecha_trimestre_final) TOTAL,
               PQ_ENC_CALIDAD.fn_tipo_cartera(PQ_ENC_CALIDAD.fn_total_clientes_analista(a.sng001ase,
                                                                                        Pq_Enc_Calidad.fn_fecha_trimestre_inicial,
                                                                                        Pq_Enc_Calidad.fn_fecha_trimestre_final)) CARTERA,
               PQ_ENC_CALIDAD.fn_total_clientes_encuesta(PQ_ENC_CALIDAD.fn_total_clientes_analista(a.sng001ase,
                                                                                                   Pq_Enc_Calidad.fn_fecha_trimestre_inicial,
                                                                                                   Pq_Enc_Calidad.fn_fecha_trimestre_final)) TOTAL_ENCUESTA
        from sng001 a, sngas2 b, xwf700 c, fsd011 d
       where a.sng001ase = b.sngas2usr
         and a.sng001inst = c.xwfprcins
         and xwfcar3 = '1'
         and c.xwfempresa = d.pgcod
         and c.xwfsucursal = d.scsuc
         and c.xwfmodulo = d.scmod
         and c.xwfmoneda = d.scmda
         and c.xwfpapel = d.scpap
         and c.xwfcuenta = d.sccta
         and c.xwfoperacion = d.scoper
         and c.xwfsubope = d.scsbop
         and c.xwftipope = d.sctope
         and d.scstat <> 99
         and c.xwfmodulo in (select modulo from fst111 where dscod = 50);
  
    -- para el cursor
    ln_codigo number := 0;
    ln_numani number := null;
    ln_numtri number := null;
    lc_codana varchar2(10) := null;
    lc_nomana varchar2(50) := null;
    ln_codage number := null;
    lc_desage varchar2(30) := null;
    ln_numtot number := null;
    lc_tipcar varchar2(30) := null;
    ln_numenc number := null;
    --
    ln_contad number := 0;
    --
  begin
    ln_contad := 0;
    delete from jaqy257;
  
    for i in c_insercion257 loop
      ln_contad := ln_contad + 1;
    
      ln_codigo := ln_contad;
      ln_numani := trim(i.ANO);
      ln_numtri := trim(i.trimestre);
      lc_codana := trim(i.codigo_analista);
      lc_nomana := trim(i.analista);
      ln_codage := trim(i.agencia);
      lc_desage := trim(i.descripcion_agencia);
      ln_numtot := trim(i.total);
      lc_tipcar := trim(i.cartera);
      ln_numenc := trim(i.total_encuesta);
    
      insert into jaqy257
        (jaqy257numer,
         jaqy257anitr,
         jaqy257nrotr,
         jaqy257codan,
         jaqy257noman,
         jaqy257codag,
         jaqy257desag,
         jaqy257numct,
         jaqy257tipca,
         jaqy257numce)
      
      values
        (ln_codigo,
         ln_numani,
         ln_numtri,
         lc_codana,
         lc_nomana,
         ln_codage,
         lc_desage,
         ln_numtot,
         lc_tipcar,
         ln_numenc);
    end loop;
    commit;
  exception
    when others then
      dbms_output.put_line(sqlerrm);
    
  end fn_insercion_JAQY257;

  function fn_descripcion_departamento(P_N_CODDEP in number) return varchar is
    P_C_DESDEP fst068.depnom%type;
  begin
    begin
      select depnom
        into P_C_DESDEP
        from fst068
       where pais = 604
         and depcod = P_N_CODDEP;
    exception
      when no_data_found then
        P_C_DESDEP := ' ';
      when others then
        P_C_DESDEP := ' ';
    end;
    return P_C_DESDEP;
  end fn_descripcion_departamento;

  function fn_codigo_provincia(P_N_CODSUC in number) return number is
    P_C_CODPRO fst001.scciud%type; --select * from fst001.scciud;
  begin
    begin
      select scciud
        into P_C_CODPRO
        from fst001
       where pgcod = 1
         and sucurs = P_N_CODSUC;
    exception
      when no_data_found then
        P_C_CODPRO := ' ';
      when others then
        P_C_CODPRO := ' ';
    end;
    return to_number(P_C_CODPRO);
  end fn_codigo_provincia;

  function fn_descripcion_provincia(P_N_CODDEP in number,
                                    P_N_CODPRO in number) return varchar is
    P_C_DESPRO fst070.locnom%type;
  begin
    begin
      select locnom
        into P_C_DESPRO
        from fst070 --pais   depcod  loccod
       where Pais = 604
         and Depcod = P_N_CODDEP
         and Loccod = P_N_CODPRO;
    exception
      when no_data_found then
        P_C_DESPRO := ' ';
      when others then
        P_C_DESPRO := ' ';
    end;
    return P_C_DESPRO;
  end fn_descripcion_provincia;

  function fn_obtener_departamento(P_PAIS  in number,
                                   P_TDOCU in number,
                                   P_NDOC  in varchar) return number is
    P_N_CODDEP sngc13.sngc13dpto%type;
  begin
    begin
      select sngc13dpto
        into P_N_CODDEP
        from sngc13
       where sngc13pais = P_PAIS
         and sngc13tdoc = P_TDOCU
         and sngc13ndoc = P_NDOC;
    exception
      when no_data_found then
        P_N_CODDEP := null;
      when others then
        P_N_CODDEP := null;
    end;
    return P_N_CODDEP;
  end fn_obtener_departamento;

  function fn_fecha_cali_credito return date is
    P_FECHA fsd212.catfchdes%type;
  begin
    begin
      select catfchdes
        into P_FECHA
        from (select /*+ PARALLEL(FSD212, 4) */
              distinct (catfchdes)
                from fsd212
               where catcod = 4
               order by catfchdes desc)
       where rownum = 1;
    exception
      when no_data_found then
        P_FECHA := null;
      when others then
        P_FECHA := null;
    end;
    return P_FECHA;
  end fn_fecha_cali_credito;

  function fn_calificacion_credito(P_CTA in number, P_FECHA in date)
    return varchar is
    P_DESCALI fsd212.catcateg%type;
  begin
    begin
      select catcateg
        into P_DESCALI
        from fsd212
       where catfchdes = P_FECHA
         and catcod = 4
         and catcta = P_CTA;
    exception
      when no_data_found then
        P_DESCALI := null;
      when others then
        P_DESCALI := null;
    end;
    return P_DESCALI;
  end fn_calificacion_credito;

  procedure fn_insert_anal_tri(P_FECHA_DDMMYYYY in character) is
    ls_FecFin varchar2(10);
    ls_CmdEje varchar2(4000);
  begin
    ls_FecFin := substr(P_FECHA_DDMMYYYY, 1, 2) || '/' ||
                 substr(P_FECHA_DDMMYYYY, 3, 2) || '/' ||
                 substr(P_FECHA_DDMMYYYY, 5, 4);
    begin
      EXECUTE IMMEDIATE 'truncate table jaqy592A';
    end;
    begin
      --          ls_CmdEje := 'insert into jaqy592A
      --          select /*+parallel(a,2,1) parallel(b,2,1) parallel(r,2,1) parallel(age,2,1) parallel(r2,2,1) parallel(pers,2,1)*/
      ls_CmdEje := 'insert into jaqy592A
                 select fn_analista_credito(a.scmod,a.scsuc,a.scmda,a.scpap,a.sccta,a.scoper,a.scsbop,a.sctope) codana,
                 count(DISTINCT a.scmod||a.scsuc||a.scmda||a.scpap||a.sccta||a.scoper||a.scsbop||a.sctope) NUMCRES_OTOR3
            from fsd011 a , fsd014 f
          where a.pgcod = 1
             and a.scrub = f.rubro
             and a.sccta <> 999999999
             and substr(f.rubro,1,4) in (1411, 1414, 1415, 1416, 1421, 1424, 1425, 1426, 8113, 8123, 8119, 8129)
             and a.scmod in (select modulo from fst111 where dscod = 50)
             and a.scmod not in (33, 141, 200, 108)
             and a.scstat <> 99
             and a.scfval <= TO_DATE(' || '''' ||
                   ls_FecFin || ''', ' || '''' || 'DD/MM/YYYY' || '''' || ')
          GROUP BY
                 fn_analista_credito(a.scmod,a.scsuc,a.scmda,a.scpap,a.sccta,a.scoper,a.scsbop,a.sctope)';
      EXECUTE IMMEDIATE ls_CmdEje;
    end;
    commit;
    begin
      EXECUTE IMMEDIATE 'truncate table jaqy592B';
    end;
    begin
      EXECUTE IMMEDIATE 'insert into jaqy592B
        select PQ_ENC_CALIDAD.fn_anio AÑO,
               PQ_ENC_CALIDAD.fn_numero_trimestre TRIMESTRE,
               a.codana,
               b.ubnom,
               d.scnom,
               c.ubsuc,
               a.NUMCRES_OTOR3,
               CASE
                 WHEN a.NUMCRES_OTOR3 > 719 THEN
                  ' || '''' ||
                        '0. CARTERA MUY GRANDE' || '''' || '
                 WHEN a.NUMCRES_OTOR3 BETWEEN 560 AND 719 THEN
                  ' || '''' || '1. CARTERA GRANDE' || '''' || '
                 WHEN a.NUMCRES_OTOR3 BETWEEN 400 AND 559 THEN
                  ' || '''' || '2. CARTERA MEDIANA' || '''' || '
                 WHEN a.NUMCRES_OTOR3 BETWEEN 321 AND 399 THEN
                  ' || '''' || '3. CARTERA PEQUEÑA' || '''' || '
                 WHEN a.NUMCRES_OTOR3 BETWEEN 161 AND 320 THEN
                  ' || '''' ||
                        '4. CARTERA MUY PEQUEÑA' || '''' || '
                 WHEN a.NUMCRES_OTOR3 BETWEEN 10 AND 160 THEN
                  ' || '''' || '5. CARTERA NUEVA' || '''' || '
                 WHEN a.NUMCRES_OTOR3 < 10 THEN
                  ' || '''' || '6. CARTERA VOLANTE' || '''' || '
               END TIPO,
               CASE
                 WHEN a.NUMCRES_OTOR3 > 719 THEN
                  30
                 WHEN a.NUMCRES_OTOR3 BETWEEN 560 AND 719 THEN
                  25
                 WHEN a.NUMCRES_OTOR3 BETWEEN 400 AND 559 THEN
                  20
                 WHEN a.NUMCRES_OTOR3 BETWEEN 321 AND 399 THEN
                  10
                 WHEN a.NUMCRES_OTOR3 BETWEEN 161 AND 320 THEN
                  15
                 WHEN a.NUMCRES_OTOR3 BETWEEN 10 AND 160 THEN
                  10
                 WHEN a.NUMCRES_OTOR3 < 10 THEN
                  10
               END NUM_CLI_ENC
          from JAQY592A a, fst746 b, fst046 c, fst001 d, sng057 e
         where a.codana = b.ubuser
           and a.codana = c.ubuser
           and c.pgcod = 1
           and c.pgcod = d.pgcod
           and c.ubsuc = d.sucurs
           and c.ubuser not in (select UBUSER from prfu00 where prfgcod = ' || '''' ||
                        'CESADO    ' || '''' || ')
           and e.sng055emp = c.pgcod
           and e.sng057usr = c.ubuser
           and e.sng055car in (200,201)';
    
    end;
    commit;
  end fn_insert_anal_tri;

  procedure fn_insercion_JAQY592(DDMMYYYY_FECHA_INICIO in character,
                                 DDMMYYYY_FECHA_FIN    in character,
                                 ps_coderr             out char) is
    ---***
    P_FECHA_APE DATE;
    P_FECHA_RCC DATE;
    ---***
    ln_data   NUMBER(3);
    w_using   CHAR(10);
    w_pepais  NUMBER(3);
    w_petdoc  NUMBER(2);
    w_pendoc  CHAR(12);
    w_hora    CHAR(8);
    w_fecnac  DATE;
    w_edad    NUMBER(3);
    wn_antcre NUMBER(9);
    wd_antcre DATE;
  
    wn_antaho NUMBER(9);
    wd_antaho DATE;
  
    wc_califi VARCHAR(30);
    wc_codrs  VARCHAR(15);
    wc_nomrs  VARCHAR(100);
    ---***
    ---***
  
    CURSOR U_ANA IS
      SELECT codana        as C_codana,
             numcres_otor3 as num_cli_total,
             tipo,
             num_cli_enc
        FROM jaqy592B
       order by codana;
    cursor C_CLI(p_analista varchar2) is
      select trim(h.pfape1) || ' ' || trim(h.pfape2) || ', ' ||
             trim(h.pfnom1) || ' ' || trim(h.pfnom2) as C_NOMCON,
             g.pendoc C_CODPER,
             pq_enc_calidad.fn_telefono_cliente2(g.pepais,
                                                 g.petdoc,
                                                 g.pendoc,
                                                 pq_enc_calidad.fn_obtener_departamento(g.pepais,
                                                                                        g.petdoc,
                                                                                        g.pendoc),
                                                 1) as F1,
             pq_enc_calidad.fn_telefono_cliente2(g.pepais,
                                                 g.petdoc,
                                                 g.pendoc,
                                                 pq_enc_calidad.fn_obtener_departamento(g.pepais,
                                                                                        g.petdoc,
                                                                                        g.pendoc),
                                                 2) as F2,
             pq_enc_calidad.fn_telefono_cliente2(g.pepais,
                                                 g.petdoc,
                                                 g.pendoc,
                                                 pq_enc_calidad.fn_obtener_departamento(g.pepais,
                                                                                        g.petdoc,
                                                                                        g.pendoc),
                                                 3) as F3,
             pq_enc_calidad.fn_telefono_cliente2(g.pepais,
                                                 g.petdoc,
                                                 g.pendoc,
                                                 pq_enc_calidad.fn_obtener_departamento(g.pepais,
                                                                                        g.petdoc,
                                                                                        g.pendoc),
                                                 4) as F4,
             pq_enc_calidad.fn_telefono_cliente2(g.pepais,
                                                 g.petdoc,
                                                 g.pendoc,
                                                 pq_enc_calidad.fn_obtener_departamento(g.pepais,
                                                                                        g.petdoc,
                                                                                        g.pendoc),
                                                 4) as F5,
             a.codana as C_CODANA,
             b.ubnom ANALISTA,
             d.scnom as AGENCIA,
             d.sucurs as C_CODAGE,
             i.depnom DPT,
             j.locnom PRO,
             j.loccod C_UBGDIR,
             a.scmda MONEDA,
             0 N_MTOAPR, --no sirve
             0 MTOAPR_SOLES, --no sirve
             --'SIN CALIFICACION' CALIF_CLIENTE, --no sirve
             
             a.scmod as CALIF_CLIENTE,
             '-' COD_CALIF_CLIENTE, --no sirve
             '-' as CALIF_CREDITO,
             --substr(pq_enc_calidad.fn_calificacion_credito(a.sccta, a.scfcon), 3) as CALIF_CREDITO, --no sirve
             '-' COD_CALIF_CREDITO,
             /*substr(pq_enc_calidad.fn_calificacion_credito(a.sccta, a.scfcon),
             1,
             1) COD_CALIF_CREDITO, --no sirve*/
             -------
             0       N_DIAATR, --no sirve
             a.scsuc GARANTIAS,
             /*substr(PQ_ENC_CALIDAD.fn_descripcion_garantias_2(a.scmod,
                                                       a.scsuc,
                                                       a.scmda,
                                                       a.scpap,
                                                       a.sccta,
                                                       a.scoper,
                                                       a.scsbop),
             1,
             254) GARANTIAS, --no sirve*/
             a.sccta COD_GARANTIAS,
             /*substr(PQ_ENC_CALIDAD.fn_codigo_garantias_2(a.scmod,
                                                  a.scsuc,
                                                  a.scmda,
                                                  a.scpap,
                                                  a.sccta,
                                                  a.scoper,
                                                  a.scsbop),
             1,
             254) COD_GARANTIAS, --no sirve*/
             a.scfval FECDES,
             0 as NUM_CLI_TOTAL, --no sirve
             '' tipo,
             0 as NUM_CLI_ENC,
             --FN_GAR_INSCR(CR.C_NUMCRE) GAR_INS
             pq_enc_calidad.fn_garantia_inscrita(a.scmod,
                                                 a.scsuc,
                                                 a.scmda,
                                                 a.scpap,
                                                 a.sccta,
                                                 a.scoper,
                                                 a.scsbop) GAR_INS,
             0 sng001inst,
             a.sccta,
             a.scoper,
             a.scstat,
             /*PQ_ENC_CALIDAD.fn_obtener_region(a.scsuc) c_desreg,
             PQ_ENC_CALIDAD.fn_obtener_zona(a.scsuc) c_deszon,
             PQ_ENC_CALIDAD.fn_docide_codusu(a.codana) c_dniusu,
             PQ_ENC_CALIDAD.fn_sexo_cliente(a.sccta) c_sexcli,
             PQ_ENC_CALIDAD.fn_fecnac_cliente(a.sccta) d_fecnac,
             PQ_ENC_CALIDAD.fn_despro_Activa(a.scmod) c_despro,
             PQ_ENC_CALIDAD.FN_AC_SEGCLI(g.pepais,g.petdoc,g.pendoc) c_desseg,
             PQ_ENC_CALIDAD.fn_mondes_cliente(a.sccta,a.sctope) n_mondes,
             PQ_ENC_CALIDAD.fn_fecdes_cliente(a.sccta,a.sctope) d_fecdes*/
             
             '' c_desreg,
             '' c_deszon,
             '' c_dniusu,
             '' c_sexcli,
             '' d_fecnac,
             '' c_despro,
             PQ_ENC_CALIDAD.fn_segcli(g.petdoc, g.pepais, g.pendoc) c_desseg,
             PQ_ENC_CALIDAD.fn_mondes(g.petdoc, g.pepais, g.pendoc) n_mondes,
             PQ_ENC_CALIDAD.fn_fecdes(g.petdoc, g.pepais, g.pendoc) d_fecdes,
             g.pepais ncodpai,
             g.petdoc ntipdoc,
             PQ_ENC_CALIDAD.fn_prosbs(g.petdoc, g.pepais, g.pendoc) cprosbs,
             
             a.pgcod  AS x_pgcod,
             a.scsuc  AS x_scsuc,
             a.scmod  AS x_scmod,
             a.scmda  AS x_scmda,
             a.scpap  AS x_scpap,
             a.sccta  AS x_sccta,
             a.scoper AS x_scoper,
             a.scsbop AS x_scsbop,
             a.sctope AS x_sctope,
             a.scfcon AS x_scfcon
      
        from jaqy592 a,
             fst746  b,
             fst046  c,
             fst001  d,
             sng057  e,
             fsr008  g,
             fsd002  h,
             fst068  i,
             fst070  j
       where a.codana = b.ubuser
         and a.codana = c.ubuser
         and c.pgcod = 1
         and c.pgcod = d.pgcod
         and c.ubsuc = d.sucurs
         and c.ubuser not in
             (select UBUSER from prfu00 where prfgcod = 'CESADO    ')
         and e.sng055emp = c.pgcod
         and e.sng057usr = c.ubuser
         and e.sng055car in (200, 201)
         and a.codana = p_analista
         and a.pgcod = g.pgcod
         and a.sccta = g.ctnro
         and g.cttfir = 'T'
         and g.pepais = h.pfpais
         and g.petdoc = h.pftdoc
         and g.pendoc = h.pfndoc
         and i.pais = 604
         and i.depcod = to_number(d.scdept)
         and j.pais = i.pais
         and j.depcod = i.depcod
         and to_number(d.scciud) = j.loccod
         and rownum < 500;
  
    --
    ln_contad  number := 0;
    ln_index   number := 0;
    EXISTE     NUMBER;
    s_sql      VARCHAR2(500);
    t_cambio   number;
    f_calicred date;
    --
  begin
    fn_insert_anal_tri(DDMMYYYY_FECHA_FIN);
    begin
      EXECUTE IMMEDIATE 'TRUNCATE table jaqy592';
    end;
    begin
      EXECUTE IMMEDIATE 'INSERT INTO jaqy592
             select
             fn_analista_credito(a.scmod,   a.scsuc,       a.scmda,     a.scpap,
                                 a.sccta,   a.scoper,      a.scsbop,    a.sctope) codana,
                                 a.pgcod,
             a.scmod, a.scsuc, a.scmda, a.scpap, a.sccta, a.scoper, a.scsbop, a.sctope, a.scfcon, a.scfval, a.scstat
            from fsd011 a , fsd014 f
          where a.pgcod = 1
             and a.scrub = f.rubro
             and a.sccta <> 999999999
             and substr(f.rubro,1,4) in (1411,1414,1415,1416, 1421,1424,1425,1426,8113,8123,8119,8129)
             and a.scmod in (select modulo from fst111 where dscod = 50)
             and a.scmod not in (33, 141, 200, 108)
             and a.scstat <> 99
             and a.scfval BETWEEN TO_DATE(' || '''' ||
                        DDMMYYYY_FECHA_INICIO || '''' || ', ' || '''' ||
                        'DDMMYYYY' || '''' || ') AND
             TO_DATE(' || '''' || DDMMYYYY_FECHA_FIN || '''' || ', ' || '''' ||
                        'DDMMYYYY' || '''' || ')';
    end;
    COMMIT;
  
    ln_index := 0;
    ---***FECAPE
    SELECT PGFAPE INTO P_FECHA_APE FROM FST017 WHERE PGCOD = 1;
    ---***FECRCC
    SELECT TO_DATE(tpnro, 'DDMMYYYY')
      INTO P_FECHA_RCC
      FROM Fst098
     WHERE pgcod = 1
       AND Tpcod = 7647
       AND Tpcorr = 12;
  
    ---***
    ---***
    ---***
  
    delete from jaqy256;
    commit;
  
    f_calicred := fn_fecha_cali_credito;
    FOR C_ANA IN U_ANA LOOP
      ln_contad := 0;
      select tccpa
        into t_cambio
        from (select tccpa, tcfch
                from fsd120
               where tccod = 500
                 and tcmda = 101
               order by tcfch desc)
       where rownum = 1;
    
      for C_CLI1 in C_CLI(C_ANA.C_codana) loop
      
        ---********************************
        ---***
        --select * from fsd015
        --select * from fsh015
        --select * from fsh016
        ---***
        ln_data := 0;
        ---***
        w_hora := '';
      
        w_using  := '';
        w_pepais := 0;
        w_petdoc := 0;
        w_pendoc := '';
      
        w_fecnac := null;
        w_edad   := 0;
      
        wn_antcre := 0;
        wd_antcre := null;
        wn_antaho := 0;
        wd_antaho := null;
      
        wc_califi := '';
        wc_codrs  := '';
        wc_nomrs  := '';
        ---***
        ---*********************************************************************
        ---***BUSCARRR
        ---select * from jaqy592
        ---select * from fst746
        ---select * from fsd015
        ---select * from fsh015
        --PGCOD, HSUCUR, HMODUL, HMDA, HPAP, HCTA, HOPER, HSUBOP, HTOPER, HFVCO
        --select * from fsh016
        --PGCOD, ITSUC, ITMOD, ITTRAN, ITNREL, ITFCON
        --select * from fst046
        --select * from fst068
        --AQUI
        /*
         dbms_output.put_line('C_CLI1.x_pgcod: ' ||C_CLI1.x_pgcod);
         dbms_output.put_line('C_CLI1.x_scsuc: ' ||C_CLI1.x_scsuc);
         dbms_output.put_line('C_CLI1.x_scmod: ' ||C_CLI1.x_scmod);
         dbms_output.put_line('C_CLI1.x_scmda: ' ||C_CLI1.x_scmda);
         dbms_output.put_line('C_CLI1.x_scpap: ' ||C_CLI1.x_scpap);
         dbms_output.put_line('C_CLI1.x_sccta: ' ||C_CLI1.x_sccta);
         dbms_output.put_line('C_CLI1.x_scoper: ' ||C_CLI1.x_scoper);
         dbms_output.put_line('C_CLI1.x_scsbop: ' ||C_CLI1.x_scsbop);
         dbms_output.put_line('C_CLI1. x_sctope: ' ||C_CLI1. x_sctope);
         dbms_output.put_line('C_CLI1.x_scfcon: ' ||C_CLI1.x_scfcon);
        
        
        C_CLI1.x_pgcod: 1
        C_CLI1.x_scsuc: 114
        C_CLI1.x_scmod: 101
        C_CLI1.x_scmda: 0
        C_CLI1.x_scpap: 0
        C_CLI1.x_sccta: 2599329
        C_CLI1.x_scoper: 9765535
        C_CLI1.x_scsbop: 0
        C_CLI1. x_sctope: 353
        C_CLI1.x_scfcon: 21/07/20
        
         select * from jaqy592
         where pgcod = 1
         and scsuc = 114
         and scmod = 101
         and scmda = 0
         and scpap = 0
         and sccta = 2599329
        
         select * from fsh016
        
           SELECT H15.*, H16.*
           FROM fsh015 H15
           JOIN fsh016 H16 ON
                      (H15.PGCOD = H16.PGCOD  AND
                      H15.HCMOD  = H16.HCMOD  AND
                      H15.HSUCOR = H16.HSUCOR AND
                      H15.HTRAN  = H16.HTRAN  AND
                      H15.HNREL  = H16.HNREL  AND
                      H15.HFCON  = H16.HFCON)
           JOIN fsr008 FR8
                   ON (H16.PGCOD = FR8.PGCOD
                  AND H16.HCTA = FR8.CTNRO
                  AND FR8.CTTFIR = 'T'
                  AND FR8.TTCOD = 1)
            WHERE
            H16.PGCOD = 1
            and H16.HSUCUR = 114
            and H16.HMODUL = 101
            and H16.HMDA = 0
            and H16.HPAP = 0
            and H16.HCTA = 2599329
            and H16.HOPER = 9765535
            and H16.HSUBOP = 0
            and H16.HTOPER = 353
            and H16.HFVCO = '21/07/2020';
        
        
          select * from fsd016
            SELECT D15.*, D16.*
            FROM fsd015 D15
            JOIN fsd016 D16 ON
                      (D15.PGCOD = D16.PGCOD  AND
                      D15.ITMOD  = D16.ITMOD  AND
                      D15.ITSUC  = D16.ITSUC  AND
                      D15.ITTRAN = D16.ITTRAN AND
                      D15.ITNREL = D16.ITNREL)
            JOIN fsr008 FR8
                   ON (D16.PGCOD = FR8.PGCOD
                  AND D16.CTNRO = FR8.CTNRO
                  AND FR8.CTTFIR = 'T'
                  AND FR8.TTCOD = 1)
            WHERE
            D16.PGCOD = 1 and D16.ITSUC = 114
            and D16.MODULO = 101
            and D16.MONEDA = 0
            and D16.PAPEL = 0
            and D16.CTNRO = 2599329
            and D16.ITOPER = 9765535
            and D16.ITSUBO = C_CLI1.x_scsbop
            and D16.ITTOPE = C_CLI1. x_sctope and D16.ITFVAL = C_CLI1.x_scfcon;
         */
      
        ---*********************************************************************
        SELECT COUNT(H15.HUSING)
          INTO ln_data
          FROM fsh015 H15
          JOIN fsh016 H16
            ON (H15.PGCOD = H16.PGCOD AND H15.HCMOD = H16.HCMOD AND
               H15.HSUCOR = H16.HSUCOR AND H15.HTRAN = H16.HTRAN AND
               H15.HNREL = H16.HNREL AND H15.HFCON = H16.HFCON)
          JOIN fsr008 FR8
            ON (H16.PGCOD = FR8.PGCOD AND H16.HCTA = FR8.CTNRO AND
               FR8.CTTFIR = 'T' AND FR8.TTCOD = 1)
         WHERE H16.PGCOD = C_CLI1.x_pgcod
           and H16.HSUCUR = C_CLI1.x_scsuc
           and H16.HMODUL = C_CLI1.x_scmod
           and H16.HMDA = C_CLI1.x_scmda
           and H16.HPAP = C_CLI1.x_scpap
           and H16.HCTA = C_CLI1.x_sccta
           and H16.HOPER = C_CLI1.x_scoper
           and H16.HSUBOP = C_CLI1.x_scsbop
           and H16.HTOPER = C_CLI1.x_sctope
           and H16.HFVCO = C_CLI1.x_scfcon;
        ---***
      
        IF (ln_data > 0) THEN
          SELECT H15.HUSING,
                 H15.HHORA,
                 PQ_ENC_CALIDAD.fn_fecnac_cliente(H16.HCTA),
                 FR8.pepais,
                 FR8.petdoc,
                 FR8.pendoc
            INTO w_using, w_hora, w_fecnac, w_pepais, w_petdoc, w_pendoc
            FROM fsh015 H15
            JOIN fsh016 H16
              ON (H15.PGCOD = H16.PGCOD AND H15.HCMOD = H16.HCMOD AND
                 H15.HSUCOR = H16.HSUCOR AND H15.HTRAN = H16.HTRAN AND
                 H15.HNREL = H16.HNREL AND H15.HFCON = H16.HFCON)
            JOIN fsr008 FR8
              ON (H16.PGCOD = FR8.PGCOD AND H16.HCTA = FR8.CTNRO AND
                 FR8.CTTFIR = 'T' AND FR8.TTCOD = 1)
           WHERE H16.PGCOD = C_CLI1.x_pgcod
             and H16.HSUCUR = C_CLI1.x_scsuc
             and H16.HMODUL = C_CLI1.x_scmod
             and H16.HMDA = C_CLI1.x_scmda
             and H16.HPAP = C_CLI1.x_scpap
             and H16.HCTA = C_CLI1.x_sccta
             and H16.HOPER = C_CLI1.x_scoper
             and H16.HSUBOP = C_CLI1.x_scsbop
             and H16.HTOPER = C_CLI1.x_sctope
             and H16.HFVCO = C_CLI1.x_scfcon
             and ROWNUM = 1;
        
          --select * from fsd015
          --select * from fsd016
        
        ELSE
          SELECT COUNT(D15.ITUING)
            INTO ln_data
            FROM fsd015 D15
            JOIN fsd016 D16
              ON (D15.PGCOD = D16.PGCOD AND D15.ITMOD = D16.ITMOD AND
                 D15.ITSUC = D16.ITSUC AND D15.ITTRAN = D16.ITTRAN AND
                 D15.ITNREL = D16.ITNREL)
            JOIN fsr008 FR8
              ON (D16.PGCOD = FR8.PGCOD AND D16.CTNRO = FR8.CTNRO AND
                 FR8.CTTFIR = 'T' AND FR8.TTCOD = 1)
           WHERE D16.PGCOD = C_CLI1.x_pgcod
             and D16.ITSUC = C_CLI1.x_scsuc
             and D16.MODULO = C_CLI1.x_scmod
             and D16.MONEDA = C_CLI1.x_scmda
             and D16.PAPEL = C_CLI1.x_scpap
             and D16.CTNRO = C_CLI1.x_sccta
             and D16.ITOPER = C_CLI1.x_scoper
             and D16.ITSUBO = C_CLI1.x_scsbop
             and D16.ITTOPE = C_CLI1.
           x_sctope
             and D16.ITFVAL = C_CLI1.x_scfcon;
        
          IF (ln_data > 0) THEN
            SELECT D15.ITUING,
                   D15.ITHORA,
                   PQ_ENC_CALIDAD.fn_fecnac_cliente(D16.CTNRO),
                   FR8.pepais,
                   FR8.petdoc,
                   FR8.pendoc
              INTO w_using, w_hora, w_fecnac, w_pepais, w_petdoc, w_pendoc
              FROM fsd015 D15
              JOIN fsd016 D16
                ON (D15.PGCOD = D16.PGCOD AND D15.ITMOD = D16.ITMOD AND
                   D15.ITSUC = D16.ITSUC AND D15.ITTRAN = D16.ITTRAN AND
                   D15.ITNREL = D16.ITNREL)
              JOIN fsr008 FR8
                ON (D16.PGCOD = FR8.PGCOD AND D16.CTNRO = FR8.CTNRO AND
                   FR8.CTTFIR = 'T' AND FR8.TTCOD = 1)
             WHERE D16.PGCOD = C_CLI1.x_pgcod
               and D16.ITSUC = C_CLI1.x_scsuc
               and D16.MODULO = C_CLI1.x_scmod
               and D16.MONEDA = C_CLI1.x_scmda
               and D16.PAPEL = C_CLI1.x_scpap
               and D16.CTNRO = C_CLI1.x_sccta
               and D16.ITOPER = C_CLI1.x_scoper
               and D16.ITSUBO = C_CLI1.x_scsbop
               and D16.ITTOPE = C_CLI1. x_sctope
               and D16.ITFVAL = C_CLI1.x_scfcon
               and ROWNUM = 1;
          END IF;
        END IF;
      
        ---*********************************************************************
      
        SELECT COUNT(*)
          INTO EXISTE
          FROM jaqy256 CC
         WHERE CC.JAQY256CODPE = C_CLI1.C_CODPER;
        IF (ln_contad >= C_ANA.NUM_CLI_ENC) then
          EXIT;
        END IF;
        IF (EXISTE = 0) THEN
          ln_contad := ln_contad + 1;
          ln_index  := ln_index + 1;
          ---***
          SELECT ROUND((P_FECHA_APE - w_fecnac) / 365.25, 2)
            INTO w_edad
            FROM dual;
          ---***
          SELECT fn_ah_antiguedad_cre(P_FECHA_APE,
                                      w_pepais,
                                      w_petdoc,
                                      w_pendoc)
            INTO wd_antcre
            FROM dual;
          SELECT MONTHS_BETWEEN(P_FECHA_APE, wd_antcre)
            INTO wn_antcre
            FROM dual;
          ---***
          SELECT fn_ah_antiguedad_aho(P_FECHA_APE,
                                      w_pepais,
                                      w_petdoc,
                                      w_pendoc)
            INTO wd_antaho
            FROM dual;
          SELECT MONTHS_BETWEEN(P_FECHA_APE, wd_antaho)
            INTO wn_antaho
            FROM dual;
          ---***
          SELECT fn_ah_calif_sbs(P_FECHA_RCC, w_pepais, w_petdoc, w_pendoc)
            INTO wc_califi
            FROM dual;
          ---***
          wc_codrs := w_using;
          wc_nomrs := PQ_ENC_CALIDAD.fn_nombre_usuario(w_using);
          ---***
          INSERT INTO jaqy256 ---***
          VALUES
            (ln_index,
             C_CLI1.C_NOMCON,
             C_CLI1.C_CODPER,
             C_CLI1.F1,
             C_CLI1.F2,
             C_CLI1.F3,
             C_CLI1.F4,
             C_CLI1.F5,
             C_CLI1.C_CODANA,
             C_CLI1.ANALISTA,
             C_CLI1.AGENCIA,
             C_CLI1.C_CODAGE,
             C_CLI1.DPT,
             C_CLI1.PRO,
             C_CLI1.C_UBGDIR,
             C_CLI1.MONEDA,
             C_CLI1.N_MTOAPR,
             C_CLI1.MTOAPR_SOLES,
             C_CLI1.CALIF_CLIENTE,
             C_CLI1.COD_CALIF_CLIENTE,
             C_CLI1.CALIF_CREDITO,
             C_CLI1.COD_CALIF_CREDITO,
             C_CLI1.N_DIAATR,
             C_CLI1.GARANTIAS,
             C_CLI1.COD_GARANTIAS,
             C_CLI1.FECDES,
             c_ana.NUM_CLI_TOTAL,
             c_ana.TIPO,
             c_ana.NUM_CLI_ENC,
             c_cli1.GAR_INS,
             c_cli1.c_desreg,
             c_cli1.c_deszon,
             c_cli1.c_dniusu,
             c_cli1.c_sexcli,
             --c_cli1.d_fecnac,
             w_fecnac,
             c_cli1.c_despro,
             c_cli1.c_desseg,
             c_cli1.n_mondes,
             c_cli1.d_fecdes,
             c_cli1.ncodpai,
             c_cli1.ntipdoc,
             c_cli1.cprosbs,
             CURRENT_TIMESTAMP,
             w_hora,
             w_edad,
             wn_antcre,
             wn_antaho,
             wc_califi,
             wc_codrs,
             wc_nomrs);
          COMMIT;
        END IF;
      END LOOP;
    END LOOP;
    --  exception
    --    when others then
    --      dbms_output.put_line(sqlerrm);
  
    --- Ejecutar Script
  
    /*update jaqy256 tab
       set tab.JAQY256DEREG =
           (select fr.pepais
              from fsr008 fr
             where fr.ctnro = tab.JAQY256CODGA
               and fr.cttfir = 'T'
               and fr.ttcod = 1
               and fr.pgcod = 1),
           tab.JAQY256DEZON =
           (select fr.petdoc
              from fsr008 fr
             where fr.ctnro = tab.JAQY256CODGA
               and fr.cttfir = 'T'
               and fr.ttcod = 1
               and fr.pgcod = 1),
           tab.JAQY256DNIUS =
           (select fr.pendoc
              from fsr008 fr
             where fr.ctnro = tab.JAQY256CODGA
               and fr.cttfir = 'T'
               and fr.ttcod = 1
               and fr.pgcod = 1);
    
    update jaqy256 tab -- OJO
       set tab.JAQY256DEPRO =
           (select max(jaqy066pano)
              from jaqy066
             where jaqy066paic = tab.JAQY256DEREG
               and jaqy066tdoc = tab.JAQY256DEZON
               and jaqy066tndoc = tab.JAQY256DNIUS);
    
    update jaqy256 tab
       set tab.JAQY256SECLI =
           (select max(jaqy066pmes)
              from jaqy066
             where jaqy066paic = tab.JAQY256DEREG
               and jaqy066tdoc = tab.JAQY256DEZON
               and jaqy066tndoc = tab.JAQY256DNIUS
               and jaqy066pano = tab.JAQY256DEPRO);
    
    update jaqy256 tab
       set tab.JAQY256SECLI =
           (select b.JAQY067NCAL
              from jaqy066 a, jaqy067 b
             where a.jaqy066paic = tab.JAQY256DEREG
               and a.jaqy066tdoc = tab.JAQY256DEZON
               and a.jaqy066tndoc = tab.JAQY256DNIUS
               and a.jaqy066pano = tab.JAQY256DEPRO
               and a.jaqy066pmes = tab.JAQY256SECLI
               and a.jaqy066calf = b.jaqy067ccal
               and rownum = 1);*/
  
    update jaqy256
       set JAQY256DEPRO = null,
           JAQY256DNIUS = null,
           JAQY256DEZON = null,
           JAQY256DEREG = null;
    commit;
  
    update jaqy256 tab
       set tab.JAQY256DEPRO =
           (select f.MDNOM from FST003 f where f.modulo = tab.JAQY256DESCL);
  
    update jaqy256 set JAQY256DESCL = 'SIN CALIFICACION';
    commit;
  
    update jaqy256 tab
       set tab.JAQY256DEREG =
           (select f.tp1desc
              from fst810 t81, fst811 t80, fst198 f
             where t80.pgcod = t81.pgcod
               and t80.regcod = t81.regcod
               and t81.regcod = f.tp1nro2
               and tp1cod = 1
               and tp1cod1 = 10872
               and tp1corr1 = 11
               and t81.regcod < 100
               and t80.regcod < 100
               and t80.oficod = tab.JAQY256GARCR);
  
    commit;
  
    update jaqy256 tab
       set tab.JAQY256DEZON =
           (select t81.regnom
              from fst810 t81, fst811 t80, fst198 f
             where t80.pgcod = 1
               and t80.pgcod = 1
               and t80.regcod = t81.regcod
               and t81.regcod = f.tp1nro2
               and f.tp1cod = 1
               and f.tp1cod1 = 10872
               and f.tp1corr1 = 11
               and t81.regcod < 100
               and t80.regcod < 100
               and t80.oficod = tab.JAQY256GARCR);
  
    commit;
    ---*** Retorna mas de una Fila -- Agregue RowNum, Confirmar ...
    update jaqy256 tab
       set tab.JAQY256DNIUS =
           (select JAQN002NDO
              from JAQN002
             where JAQN002USR = tab.JAQY256CODAN
               and JAQN002PGC = 1
               and rownum = 1);
    ---***
  
    commit;
  
    update jaqy256 tab
       set tab.JAQY256GECLI =
           (select f.pfcant
              from fsd002 f
             inner join fsr008 fr
                on f.pfpais = fr.pepais
               and f.pftdoc = fr.petdoc
               and f.pfndoc = fr.pendoc
               and fr.cttfir = 'T'
               and fr.ttcod = 1
             where fr.ctnro = tab.JAQY256CODGA
            
            );
    commit;
    /*---*** mcvillonz
    update jaqy256 tab
       set tab.JAQY256FENAC =
           (select f.pffnac
              from fsd002 f
             inner join fsr008 fr
                on f.pfpais = fr.pepais
               and f.pftdoc = fr.petdoc
               and f.pfndoc = fr.pendoc
               and fr.cttfir = 'T'
               and fr.ttcod = 1
             where fr.ctnro = tab.JAQY256CODGA
    
            );
    
    commit;
    ---***
    */
    /*update jaqy256 tab
       set tab.JAQY256FEDES =
           (select max(f.AOFVAL)
              from FSD010 f
             where f.aocta = tab.JAQY256CODGA
               and f.aooper = tab.JAQY256MODES
               and f.pgcod = 1
               and f.aosbop = 0
    
            );
    commit;
    
    update jaqy256 tab
       set tab.JAQY256MODES =
           (select max(f.AOIMP)
              from FSD010 f
             where f.aocta = tab.JAQY256CODGA
               and f.aooper = tab.JAQY256MODES
               and f.pgcod = 1
               and f.aosbop = 0
    
            );
    commit;*/
  
    update jaqy256 tab
       set tab.JAQY256GARCR = null, tab.JAQY256CODGA = null;
  
    commit;
  end fn_insercion_JAQY592;

  function fn_obtener_region(P_CAGE in number) return varchar2 is
    P_C_NOMREG fst810.regnom%type;
  begin
    begin
      select f.tp1desc
        into P_C_NOMREG
        from fst810 t81, fst811 t80, fst198 f
       where t80.pgcod = t81.pgcod
         and t80.regcod = t81.regcod
         and t81.regcod = f.tp1nro2
         and f.tp1cod = 1
         and tp1cod1 = 10872
         and tp1corr1 = 11
         and t81.regcod < 100
         and t80.regcod < 100
         and t80.oficod = P_CAGE;
    exception
      when no_data_found then
        P_C_NOMREG := null;
      when others then
        P_C_NOMREG := null;
    end;
    return P_C_NOMREG;
  end fn_obtener_region;

  function fn_obtener_zona(P_CAGE in number) return varchar2 is
    P_C_NOMZON fst810.regnom%type;
  begin
    begin
      select t81.regnom
        into P_C_NOMZON
        from fst810 t81, fst811 t80, fst198 f
       where t80.pgcod = t81.pgcod
         and t80.regcod = t81.regcod
         and t81.regcod = f.tp1nro2
         and f.tp1cod = 1
         and f.tp1cod1 = 10872
         and f.tp1corr1 = 11
         and t81.regcod < 100
         and t80.regcod < 100
         and t80.oficod = P_CAGE;
    exception
      when no_data_found then
        P_C_NOMZON := null;
      when others then
        P_C_NOMZON := null;
    end;
    return P_C_NOMZON;
  end fn_obtener_zona;

  function fn_sexo_cliente(P_N_CODCTA in character) return character is
    P_C_SEXCLI FSD002.PFCANT%type;
  begin
  
    begin
      select f.pfcant
        into P_C_SEXCLI
        from fsd002 f
       inner join fsr008 fr
          on fr.pgcod = 1
         and f.pfpais = fr.pepais
         and f.pftdoc = fr.petdoc
         and f.pfndoc = fr.pendoc
         and fr.cttfir = 'T'
         and fr.ttcod = 1
       where fr.ctnro = P_N_CODCTA;
    exception
      when no_data_found then
        P_C_SEXCLI := null;
      when others then
        P_C_SEXCLI := null;
    end;
    return P_C_SEXCLI;
  end fn_sexo_cliente;

  function fn_fecnac_cliente(P_N_CODCTA in character) return date is
    P_D_FECNAC FSD002.pffnac%type;
  begin
  
    begin
      select f.pffnac
        into P_D_FECNAC
        from fsd002 f
       inner join fsr008 fr
          on fr.pepais = f.pfpais
         and fr.petdoc = f.pftdoc
         and fr.pendoc = f.pfndoc
       where fr.cttfir = 'T'
         and fr.ttcod = 1
         and fr.ctnro = P_N_CODCTA;
    exception
      when no_data_found then
        P_D_FECNAC := null;
      when others then
        P_D_FECNAC := null;
    end;
    return P_D_FECNAC;
  end fn_fecnac_cliente;

  function fn_docide_codusu(P_C_CODUSU in character) return character is
    P_C_DOCIDE JAQL708.JAQL708DOI%type;
  begin
    begin
      select JAQN002NDO
        into P_C_DOCIDE
        from JAQN002
       where JAQN002USR = P_C_CODUSU
         and JAQN002PGC = 1
         and rownum = 1;
    exception
      when no_data_found then
        P_C_DOCIDE := null;
      when others then
        P_C_DOCIDE := null;
    end;
    return P_C_DOCIDE;
  end fn_docide_codusu;

  function fn_segaho_cliente(P_N_CODCTA in character) return character is
    P_C_CALCLI JAQL060.JAQL60CALI%type;
  begin
  
    begin
      select f.JAQL60CALI
        into P_C_CALCLI
        from JAQL060 f
       inner join fsr008 fr
          on fr.pgcod = 1
         and fr.pepais = f.jaql60pais
         and fr.petdoc = f.jaql60tdoc
         and fr.pendoc = f.jaql60ndoc
         and fr.cttfir = 'T'
         and fr.ttcod = 1
       where fr.ctnro = P_N_CODCTA
         and f.jaql60pgco = 1;
    exception
      when no_data_found then
        P_C_CALCLI := null;
      when others then
        P_C_CALCLI := null;
    end;
    return P_C_CALCLI;
  end fn_segaho_cliente;

  function fn_DesPro_Pasiva(P_N_CODMOD in number, P_N_TIPOPE in number)
    return character is
    P_C_DESPRO FST004.TONOM%type;
  begin
  
    begin
      select f.TONOM
        into P_C_DESPRO
        from FST004 f
       where f.modulo = P_N_CODMOD
         and f.totope = P_N_TIPOPE;
    exception
      when no_data_found then
        P_C_DESPRO := null;
      when others then
        P_C_DESPRO := null;
    end;
    return P_C_DESPRO;
  end fn_DesPro_Pasiva;

  function fn_mondes_cliente(P_N_CODCTA in character,
                             P_N_OPERAC in character) return number is
    P_N_MONDES FSD010.AOIMP%type;
  begin
  
    begin
      select f.AOIMP
        into P_N_MONDES
        from FSD010 f
       where f.aocta = P_N_CODCTA
         and f.aooper = P_N_OPERAC
         and f.pgcod = 1
         and f.aosbop = 0;
    exception
      when no_data_found then
        P_N_MONDES := null;
      when others then
        P_N_MONDES := null;
    end;
    return P_N_MONDES;
  end fn_mondes_cliente;

  function fn_fecdes_cliente(P_N_CODCTA in character,
                             P_N_OPERAC in character) return date is
    P_D_FECDES FSD010.AOFVAL%type;
  begin
  
    begin
      select f.AOFVAL
        into P_D_FECDES
        from FSD010 f
       where f.aocta = P_N_CODCTA
         and f.aooper = P_N_OPERAC
         and f.pgcod = 1
         and f.aosbop = 0;
    exception
      when no_data_found then
        P_D_FECDES := null;
      when others then
        P_D_FECDES := null;
    end;
    return P_D_FECDES;
  end fn_fecdes_cliente;

  function fn_segcre_cliente(P_N_CODCTA in character) return character is
    P_C_CALCLI JAQY067.JAQY067NCAL%type;
    P_N_CodPai Number(3);
    P_N_TipDoc Number(2);
    P_C_NumDoc Char(12);
    P_N_AnoPro Number;
    P_N_MesPro Number;
  begin
  
    begin
      select fr.pepais, fr.petdoc, fr.pendoc
        into P_N_CodPai, P_N_TipDoc, P_C_NumDoc
        from fsr008 fr
       where fr.ctnro = P_N_CODCTA
         and fr.cttfir = 'T'
         and fr.ttcod = 1;
    exception
      when no_data_found then
        P_N_CodPai := 0;
        P_N_TipDoc := 0;
        P_C_NumDoc := null;
      when others then
        P_N_CodPai := 0;
        P_N_TipDoc := 0;
        P_C_NumDoc := null;
    end;
    select max(jaqy066pano)
      into P_N_AnoPro
      from jaqy066
     where jaqy066paic = P_N_CodPai
       and jaqy066tdoc = P_N_TipDoc
       and jaqy066tndoc = P_C_NumDoc;
    select max(jaqy066pmes)
      into P_N_MesPro
      from jaqy066
     where jaqy066paic = P_N_CodPai
       and jaqy066tdoc = P_N_TipDoc
       and jaqy066tndoc = P_C_NumDoc
       and jaqy066pano = P_N_AnoPro;
    begin
      select b.JAQY067NCAL
        into P_C_CALCLI
        from jaqy066 a, jaqy067 b
       where a.jaqy066paic = P_N_CodPai
         and a.jaqy066tdoc = P_N_TipDoc
         and a.jaqy066tndoc = P_C_NumDoc
         and a.jaqy066pano = P_N_AnoPro
         and a.jaqy066pmes = P_N_MesPro
         and a.jaqy066calf = b.jaqy067ccal;
    exception
      when no_data_found then
        P_C_CALCLI := null;
      when others then
        P_C_CALCLI := null;
    end;
    return P_C_CALCLI;
  end fn_segcre_cliente;

  function fn_DesPro_Activa(P_N_CODMOD in number) return character is
    P_C_DESPRO FST003.MDNOM%type;
  begin
  
    begin
      select f.MDNOM
        into P_C_DESPRO
        from FST003 f
       where f.modulo = P_N_CODMOD;
    exception
      when no_data_found then
        P_C_DESPRO := null;
      when others then
        P_C_DESPRO := null;
    end;
    return P_C_DESPRO;
  end fn_DesPro_Activa;

  function fn_segcli(pn_tipdoc number,
                     pn_codpai number,
                     ps_numdoc varchar2) return varchar is
    -- *****************************************************************
    -- Nombre                     : FN_AC_SEGCLI
    -- Sistema                    : ENCUESTAS
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/10/2016
    -- Autor de Creación          : WCRW
    -- Uso                        : Segmentación de cliente antes de desembolso
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ls_segcli varchar2(200);
    ls_numdoc char(12);
    pn_aniseg number;
    pn_messeg number;
    --2016.03.30 a partir de noviembre tienes dos segmentos
  begin
    select max(jaqy066pano) into pn_aniseg from jaqy066 cal;
  
    select max(jaqy066pmes)
      into pn_messeg
      from jaqy066 cal
     where cal.jaqy066pano = pn_aniseg;
  
    ls_numdoc := ps_numdoc;
    begin
      select y67.jaqy067ncal
        into ls_segcli
        from jaqy066 y66
       inner join jaqy067 y67
          on y67.jaqy067ccal = y66.jaqy066calf
       where y66.jaqy066pano = pn_aniseg
         and y66.jaqy066pmes = pn_messeg
         and y66.jaqy066paic = pn_codpai
         and y66.jaqy066tdoc = pn_tipdoc
         and y66.jaqy066tndoc = ls_numdoc
         and (case
               when last_day(to_date(pn_aniseg || lpad(pn_messeg, 2, '0') || '01',
                                     'rrrrmmdd')) >=
                    to_date('20151130', 'rrrrmmdd') and y66.jaqy066nse = 'S' then
                1
               when last_day(to_date(pn_aniseg || lpad(pn_messeg, 2, '0') || '01',
                                     'rrrrmmdd')) <
                    to_date('20151130', 'rrrrmmdd') then
                1
             end) = 1;
    exception
      when no_data_found then
        ls_segcli := 'NO EXISTE 999';
      when others then
        begin
          select y67.jaqy067ncal
            into ls_segcli
            from jaqy066 y66
           inner join jaqy067 y67
              on y67.jaqy067ccal = y66.jaqy066calf
           where y66.jaqy066pano = pn_aniseg
             and y66.jaqy066pmes = pn_messeg
             and y66.jaqy066paic = pn_codpai
             and y66.jaqy066tdoc = pn_tipdoc
             and y66.jaqy066tndoc = ls_numdoc
             and (case
                   when last_day(to_date(pn_aniseg ||
                                         lpad(pn_messeg, 2, '0') || '01',
                                         'rrrrmmdd')) >=
                        to_date('20151130', 'rrrrmmdd') and
                        y66.jaqy066nse = 'S' then
                    1
                   when last_day(to_date(pn_aniseg ||
                                         lpad(pn_messeg, 2, '0') || '01',
                                         'rrrrmmdd')) <
                        to_date('20151130', 'rrrrmmdd') then
                    1
                 end) = 1
             and rownum = 1;
        
        exception
        
          when no_data_found then
            ls_segcli := 'NO EXISTE 999';
          when others then
            ls_segcli := 'NO EXISTE 999';
        end;
      
    end;
    return ls_segcli;
  end fn_segcli;

  function fn_fecdes(pn_tipdoc number,
                     pn_codpai number,
                     ps_numdoc varchar2) return date is
    -- *****************************************************************
    -- Nombre                     : fn_fecdes
    -- Sistema                    : ENCUESTAS
    -- Módulo                     :
    -- Versión                    : 1.0
    -- Fecha de Creación          : 27/01/2017
    -- Autor de Creación          : WCRW
    -- Uso                        : Retorna datos del último credito desembolsado sin considerar prendario
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Creación          :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ls_numdoc char(12);
    ld_fecdes date;
  begin
    ls_numdoc := ps_numdoc;
  
    begin
      Select aofval
        into ld_fecdes
        from (select a.pgcod,
                     aomod,
                     aosuc,
                     aomda,
                     aopap,
                     aocta,
                     aooper,
                     aosbop,
                     aotope,
                     aostat,
                     aofval,
                     aofe99,
                     aoimp
                from fsd010 a
                join fsr008 r8
                  on r8.pgcod = a.pgcod
                 and r8.ctnro = a.aocta
                 and r8.pepais = pn_codpai
                 and r8.petdoc = pn_tipdoc
                 and r8.pendoc = ls_numdoc
                 and r8.ttcod = 1
                 and r8.cttfir = 'T'
               where a.aomod in (select modulo
                                   from fst111
                                  where dscod = 50
                                    and modulo not in (29, 120)
                                 union all
                                 select 117
                                   from dual)
                 and a.aomod <> 120
                 and a.aomod <> 108
                 and a.aofval <= trunc(sysdate)
               order by a.aofval desc)
       WHERE rownum = 1;
      return ld_fecdes;
    exception
      when others then
        ld_fecdes := '';
    end;
    return ld_fecdes;
  end fn_fecdes;

  function fn_mondes(pn_tipdoc number,
                     pn_codpai number,
                     ps_numdoc varchar2) return number is
    -- *****************************************************************
    -- Nombre                     : fn_mondes
    -- Sistema                    : ENCUESTAS
    -- Módulo                     :
    -- Versión                    : 1.0
    -- Fecha de Creación          : 27/01/2017
    -- Autor de Creación          : WCRW
    -- Uso                        : Retorna datos del último credito desembolsado sin considerar prendario
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Creación          :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ls_numdoc char(12);
    ld_fecdes date;
    ln_mondes number;
  begin
  
    ls_numdoc := ps_numdoc;
  
    begin
      Select aoimp
        into ln_mondes
        from (select a.pgcod,
                     aomod,
                     aosuc,
                     aomda,
                     aopap,
                     aocta,
                     aooper,
                     aosbop,
                     aotope,
                     aostat,
                     aofval,
                     aofe99,
                     aoimp
                from fsd010 a
                join fsr008 r8
                  on r8.pgcod = a.pgcod
                 and r8.ctnro = a.aocta
                 and r8.pepais = pn_codpai
                 and r8.petdoc = pn_tipdoc
                 and r8.pendoc = ls_numdoc
                 and r8.ttcod = 1
                 and r8.cttfir = 'T'
               where a.aomod in (select modulo
                                   from fst111
                                  where dscod = 50
                                    and modulo not in (29, 120)
                                 union all
                                 select 117
                                   from dual)
                 and a.aomod <> 120
                 and a.aomod <> 108
                 and a.aofval <= trunc(sysdate)
               order by a.aofval desc)
       WHERE rownum = 1;
    exception
      when others then
        ln_mondes := 0;
    end;
    return ln_mondes;
  end fn_mondes;

  function fn_prosbs(pn_tipdoc number,
                     pn_codpai number,
                     ps_numdoc varchar2) return varchar is
    -- *****************************************************************
    -- Nombre                     : fn_prosbs
    -- Sistema                    : ENCUESTAS
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 18/10/2018
    -- Autor de Creación          : WCRW
    -- Uso                        : Retorna producto sbs
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Creación          :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ls_numdoc char(12);
    ls_prosbs char(4);
    ls_despro varchar(50);
  begin
    ls_numdoc := ps_numdoc;
  
    begin
      Select /*+all_rows*/
       cprosbs
        into ls_prosbs
        from (select substr(d11.scrub, 5, 2) || substr(d11.scrub, 12, 2) cprosbs
                from fsd010 a, fsr008 r8, fsd011 d11
               where a.aomod in (select modulo
                                   from fst111
                                  where dscod = 50
                                    and modulo not in (29, 120)
                                 union all
                                 select 117
                                   from dual)
                 and a.aomod <> 120
                 and a.aomod <> 108
                 and a.aofval <= trunc(sysdate)
                 and r8.pgcod = a.pgcod
                 and r8.ctnro = a.aocta
                 and r8.pepais = pn_codpai
                 and r8.petdoc = pn_tipdoc
                 and r8.pendoc = ls_numdoc
                 and r8.ttcod = 1
                 and r8.cttfir = 'T'
                 and d11.pgcod = a.pgcod
                 and d11.scsuc = a.aosuc
                 and d11.scmda = a.aomda
                 and d11.scpap = a.aopap
                 and d11.sccta = a.aocta
                 and d11.scoper = a.aooper
                 and d11.scsbop = a.aosbop
                 and d11.sctope = a.aotope
               order by a.aofval desc)
       WHERE rownum = 1;
      --return  ls_prosbs;
    exception
      when others then
        ls_prosbs := '';
    end;
    ls_despro := PQ_ENC_CALIDAD.fn_dessbs(ls_prosbs);
    return ls_despro;
  end fn_prosbs;

  function fn_dessbs(ps_codsbs varchar) return varchar is
    -- *****************************************************************
    -- Nombre                     : fn_dessbs
    -- Sistema                    : ENCUESTAS
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 18/10/2018
    -- Autor de Creación          : WCRW
    -- Uso                        : Retorna producto sbs
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Creación          :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ln_codgru number;
    ln_codrub number;
    ls_despro varchar2(50);
  begin
    begin
      ln_codgru := to_number(substr(ps_codsbs, 1, 2), '99');
      ln_codrub := to_number(substr(ps_codsbs, 3, 2), '99');
      case
        when ln_codgru = 2 then
          ls_despro := substr(ps_codsbs, 1, 2) || ' - MICROEMPRESAS';
        when ln_codgru = 3 and ln_codrub = 15 then
          ls_despro := substr(ps_codsbs, 1, 2) || ' - CONSUMO REVOLVENTE';
        when ln_codgru = 3 and ln_codrub <> 15 then
          ls_despro := substr(ps_codsbs, 1, 2) ||
                       ' - CONSUMO NO REVOLVENTE';
        when ln_codgru = 4 then
          ls_despro := substr(ps_codsbs, 1, 2) || ' - HIPOTECARIO';
        when ln_codgru = 11 then
          ls_despro := substr(ps_codsbs, 1, 2) || ' - GRANDES EMPRESAS';
        when ln_codgru = 12 then
          ls_despro := substr(ps_codsbs, 1, 2) || ' - MEDIANA EMPRESA';
        when ln_codgru = 13 then
          ls_despro := substr(ps_codsbs, 1, 2) || ' - PEQUEÑA EMPRESA';
        when ln_codgru in (5, 6, 7, 8, 9, 10) then
          ls_despro := substr(ps_codsbs, 1, 2) || ' - CORPORATIVO';
        else
          ls_despro := null;
      end case;
    exception
      when others then
        ls_despro := null;
        dbms_output.put_line(sqlerrm);
    end;
    return ls_despro;
  end fn_dessbs;

  --Fecha Modificación: 31/07/2019
  --Usuario Modificación: rwong
  --Adicion de Reporte
  procedure fn_insercion_JAQY255A(P_CREUSU IN VARCHAR, ps_coderr out char) is
  begin
    --EXECUTE IMMEDIATE 'TRUNCATE table jaqy255A';
    ---***
    DELETE FROM JAQY255A WHERE JAQY255ACREUSU = P_CREUSU;
    ---***
    insert into jaqy255A
      select *
        from jaqy255 t_auxi
       where not exists
       (select 1
                from fsr008 t_rela, fsd002 t_iden
               where t_rela.pgcod = 1
                 and t_rela.ctnro =
                     to_number(trim(substr(t_auxi.jaqy255nroco, 1, 9)))
                 and t_rela.ttcod = 1
                 and t_rela.cttfir = 'T'
                 and t_iden.pfpais = t_rela.pepais
                 and t_iden.pftdoc = t_rela.petdoc
                 and t_iden.pfndoc = t_rela.pendoc
                 and t_iden.pfebco = 'S');
    commit;
  exception
    when others then
      dbms_output.put_line(sqlerrm);
  end fn_insercion_JAQY255A;

END PQ_ENC_CALIDAD;
/

