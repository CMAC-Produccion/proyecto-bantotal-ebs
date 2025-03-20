CREATE OR REPLACE PROCEDURE "SP_CR_HISTORICO_REPROGRAMACIONES"(p_instancia  IN NUMBER,
                                                              p_usuario    IN VARCHAR2,
                                                              VO_CLASI     OUT NUMBER,
                                                              PO_DNI       OUT VARCHAR2,
                                                              PO_NOMB_AP   OUT VARCHAR2,
                                                              VO_COD_ERROR OUT VARCHAR,
                                                              VO_MSG_ERROR OUT VARCHAR) AS

  -- **********************************************************************************
  -- Nombre                     : sp_cr_historico_reprogramaciones2
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 28/11/2024
  -- Autor de Creación          : MHUAMANIA
  -- Uso                        : Insertar datos de las evalauciones de reprogramaciones
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : p_instancia,p_usuario
  -- Autor de la Modificación   : MHUAMANIA
  -- Descripción de Modificación: Se agregaron parametros de salida para el manejo de errores
  -- Fecha de Modificación      : 26/12/2024
  -- **********************************************************************************

  v_modulo       NUMBER;
  v_fechaHoraLog timestamp;

BEGIN
  VO_COD_ERROR := '0000';
  VO_MSG_ERROR := '';
  PO_DNI       := '';

  SELECT sng021tmod
    INTO v_modulo
    FROM sng021
   WHERE sng021sol = p_instancia;

  v_fechaHoraLog := current_timestamp;

  BEGIN
    SELECT SNG001NDOC, PENOM
      INTO PO_DNI, PO_NOMB_AP
      from sng001 I
     INNER JOIN FSD001 P
        ON P.PEPAIS = I.SNG001PAIS
       AND P.PETDOC = I.SNG001TDOC
       AND P.PENDOC = I.SNG001NDOC
     where I.sng001inst = P_INSTANCIA;
  EXCEPTION
    WHEN OTHERS THEN
      VO_COD_ERROR := '0001';
      VO_MSG_ERROR := SUBSTR(SQLERRM, 1, 150);
      PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(P_INSTANCIA,
                                                 '',
                                                 '',
                                                 'sp_cr_historico_reprogramaciones',
                                                 '',
                                                 VO_COD_ERROR,
                                                 VO_MSG_ERROR);
      VO_MSG_ERROR := 'No se pudo encontrar documento de cliente';
  END;
  BEGIN
    DELETE FROM aqpd752 WHERE AQPD752INSTA = p_instancia;
    DELETE FROM aqpd755 WHERE AQPD755INSTA = p_instancia;
  EXCEPTION
    WHEN OTHERS THEN
      VO_COD_ERROR := '0002';
      VO_MSG_ERROR := SUBSTR(SQLERRM, 1, 150);
      PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(P_INSTANCIA,
                                                 '',
                                                 '',
                                                 'sp_cr_historico_reprogramaciones',
                                                 '',
                                                 VO_COD_ERROR,
                                                 VO_MSG_ERROR);
      VO_MSG_ERROR := 'No se pudo eliminar datos de las tablas aqpd752 o aqpd755';
  END;
  --PYME
  if v_modulo = 13 THEN

    BEGIN

      INSERT INTO AQPD752
        (AQPD752INSTA,
         AQPD752FEPRO,
         AQPD752USUREG,
         AQPD752FECREG,
         AQPD752EVA38,
         AQPD752EVA39,
         AQPD752EVA40,
         AQPD752EVA41,
         AQPD752EVA42,
         AQPD752EVA43,
         AQPD752EVA44,
         AQPD752EVA45,
         AQPD752EVA46,
         AQPD752EVA47,
         AQPD752EVA48,
         AQPD752EVA49,
         AQPD752EVA50,
         AQPD752EVA51,
         AQPD752EVA52,
         AQPD752EVA53,
         AQPD752EVA54,
         AQPD752EVA56,
         AQPD752EVA57,
         AQPD752EVA58,
         AQPD752EVA59,
         AQPD752EVA60,
         AQPD752EVA61,
         AQPD752EVA62,
         AQPD752EVA63,
         AQPD752EVA64,
         AQPD752EVA65,
         AQPD752EVA66,
         AQPD752EVA67,
         AQPD752EVA68,
         AQPD752EVA69,
         AQPD752EVA70,
         AQPD752EVA71,
         AQPD752EVA73,
         AQPD752EVA74,
         AQPD752EVA75,
         AQPD752EVA76,
         AQPD752EVA77,
         AQPD752EVA78,
         AQPD752EVA79,
         AQPD752EVA80,
         AQPD752EVA81,
         AQPD752EVA82,
         AQPD752EVA83,
         AQPD752EVA84,
         AQPD752EVA89,
         AQPD752EVA540,
         AQPD752EVA541,
         AQPD752EVA542,
         AQPD752EVA543,
         AQPD752EVA544,
         AQPD752EVA545,
         AQPD752EVA546,
         AQPD752EVA547,
         AQPD752EVA548,
         AQPD752EVA549,
         AQPD752EVA550,
         AQPD752EVA551,
         AQPD752EVA552,
         AQPD752EVA553,
         AQPD752EVA554,
         AQPD752EVA556,
         AQPD752EVA557,
         AQPD752EVA558,
         AQPD752EVA559,
         AQPD752EVA560,
         AQPD752EVA561,
         AQPD752EVA562,
         AQPD752EVA563,
         AQPD752EVA564,
         AQPD752EVA565,
         AQPD752EVA566,
         AQPD752EVA567,
         AQPD752EVA568,
         AQPD752EVA569,
         AQPD752EVA570,
         AQPD752EVA571,
         AQPD752EVA573,
         AQPD752EVA574,
         AQPD752EVA575,
         AQPD752EVA576,
         AQPD752EVA577,
         AQPD752EVA578,
         AQPD752EVA579,
         AQPD752EVA580,
         AQPD752EVA581,
         AQPD752EVA582,
         AQPD752EVA583,
         AQPD752EVA584,
         AQPD752EVA589)
        SELECT *
          FROM (SELECT SNG021SOL,
                       aqpb613ffeclog,
                       p_usuario,
                       v_fechaHoraLog,
                       aqpb613fcod,
                       aqpb613fmto
                  FROM aqpb613f E
                 INNER JOIN SNG021 S
                    ON S.SNG021EVAL = E.AQPB613FEVAL
                 WHERE s.sng021sol = p_instancia)
        PIVOT(SUM(AQPB613FMTO)
           FOR AQPB613FCOD IN(38 AS AQPD752EVA38,
                              39 AS AQPD752EVA39,
                              40 AS AQPD752EVA40,
                              41 AS AQPD752EVA41,
                              42 AS AQPD752EVA42,
                              43 AS AQPD752EVA43,
                              44 AS AQPD752EVA44,
                              45 AS AQPD752EVA45,
                              46 AS AQPD752EVA46,
                              47 AS AQPD752EVA47,
                              48 AS AQPD752EVA48,
                              49 AS AQPD752EVA49,
                              50 AS AQPD752EVA50,
                              51 AS AQPD752EVA51,
                              52 AS AQPD752EVA52,
                              53 AS AQPD752EVA53,
                              54 AS AQPD752EVA54,
                              56 AS AQPD752EVA56,
                              57 AS AQPD752EVA57,
                              58 AS AQPD752EVA58,
                              59 AS AQPD752EVA59,
                              60 AS AQPD752EVA60,
                              61 AS AQPD752EVA61,
                              62 AS AQPD752EVA62,
                              63 AS AQPD752EVA63,
                              64 AS AQPD752EVA64,
                              65 AS AQPD752EVA65,
                              66 AS AQPD752EVA66,
                              67 AS AQPD752EVA67,
                              68 AS AQPD752EVA68,
                              69 AS AQPD752EVA69,
                              70 AS AQPD752EVA70,
                              71 AS AQPD752EVA71,
                              73 AS AQPD752EVA73,
                              74 AS AQPD752EVA74,
                              75 AS AQPD752EVA75,
                              76 AS AQPD752EVA76,
                              77 AS AQPD752EVA77,
                              78 AS AQPD752EVA78,
                              79 AS AQPD752EVA79,
                              80 AS AQPD752EVA80,
                              81 AS AQPD752EVA81,
                              82 AS AQPD752EVA82,
                              83 AS AQPD752EVA83,
                              84 AS AQPD752EVA84,
                              89 AS AQPD752EVA89,
                              540 AS AQPD752EVA540,
                              541 AS AQPD752EVA541,
                              542 AS AQPD752EVA542,
                              543 AS AQPD752EVA543,
                              544 AS AQPD752EVA544,
                              545 AS AQPD752EVA545,
                              546 AS AQPD752EVA546,
                              547 AS AQPD752EVA547,
                              548 AS AQPD752EVA548,
                              549 AS AQPD752EVA549,
                              550 AS AQPD752EVA550,
                              551 AS AQPD752EVA551,
                              552 AS AQPD752EVA552,
                              553 AS AQPD752EVA553,
                              554 AS AQPD752EVA554,
                              556 AS AQPD752EVA556,
                              557 AS AQPD752EVA557,
                              558 AS AQPD752EVA558,
                              559 AS AQPD752EVA559,
                              560 AS AQPD752EVA560,
                              561 AS AQPD752EVA561,
                              562 AS AQPD752EVA562,
                              563 AS AQPD752EVA563,
                              564 AS AQPD752EVA564,
                              565 AS AQPD752EVA565,
                              566 AS AQPD752EVA566,
                              567 AS AQPD752EVA567,
                              568 AS AQPD752EVA568,
                              569 AS AQPD752EVA569,
                              570 AS AQPD752EVA570,
                              571 AS AQPD752EVA571,
                              573 AS AQPD752EVA573,
                              574 AS AQPD752EVA574,
                              575 AS AQPD752EVA575,
                              576 AS AQPD752EVA576,
                              577 AS AQPD752EVA577,
                              578 AS AQPD752EVA578,
                              579 AS AQPD752EVA579,
                              580 AS AQPD752EVA580,
                              581 AS AQPD752EVA581,
                              582 AS AQPD752EVA582,
                              583 AS AQPD752EVA583,
                              584 AS AQPD752EVA584,
                              589 AS AQPD752EVA589));

      commit;
    END;
    --consumo
  ELSIF v_modulo = 14 then

    insert into aqpd755
      (AQPD755INSTA,
       AQPD755FEPRO,
       AQPD755USUREG,
       AQPD755FECREG,
       AQPD755EVA1,
       AQPD755EVA501,
       AQPD755EVA2,
       AQPD755EVA502,
       AQPD755EVA3,
       AQPD755EVA503,
       AQPD755EVA4,
       AQPD755EVA504,
       AQPD755EVA5,
       AQPD755EVA505,
       AQPD755EVA6,
       AQPD755EVA506,
       AQPD755EVA7,
       AQPD755EVA507,
       AQPD755EVA8,
       AQPD755EVA508,
       AQPD755EVA9,
       AQPD755EVA509,
       AQPD755EVA10,
       AQPD755EVA510,
       AQPD755EVA11,
       AQPD755EVA511,
       AQPD755EVA12,
       AQPD755EVA512,
       AQPD755EVA13,
       AQPD755EVA513,
       AQPD755EVA14,
       AQPD755EVA514,
       AQPD755EVA15,
       AQPD755EVA515,
       AQPD755EVA16,
       AQPD755EVA516,
       AQPD755EVA17,
       AQPD755EVA517,
       AQPD755EVA18,
       AQPD755EVA518,
       AQPD755EVA19,
       AQPD755EVA519,
       AQPD755EVA20,
       AQPD755EVA520,
       AQPD755EVA21,
       AQPD755EVA521,
       AQPD755EVA22,
       AQPD755EVA522,
       AQPD755EVA23,
       AQPD755EVA24,
       AQPD755EVA524,
       AQPD755EVA25,
       AQPD755EVA26,
       AQPD755EVA526,
       AQPD755EVA27,
       AQPD755EVA527,
       AQPD755EVA29,
       AQPD755EVA529,
       AQPD755EVA30)
      SELECT *
        FROM (SELECT jaqm400ins,
                     jaqm400fec,
                     p_usuario,
                     v_fechaHoraLog,
                     jaqm400cod,
                     jaqm400mon
                FROM jaqm400
               WHERE jaqm400ins = p_instancia)
      PIVOT(SUM(jaqm400mon)
         FOR jaqm400cod IN(1 as AQPD755EVA1,
                           501 as AQPD755EVA501,
                           2 as AQPD755EVA2,
                           502 as AQPD755EVA502,
                           3 as AQPD755EVA3,
                           503 as AQPD755EVA503,
                           4 as AQPD755EVA4,
                           504 as AQPD755EVA504,
                           5 as AQPD755EVA5,
                           505 as AQPD755EVA505,
                           6 as AQPD755EVA6,
                           506 as AQPD755EVA506,
                           7 as AQPD755EVA7,
                           507 as AQPD755EVA507,
                           8 as AQPD755EVA8,
                           508 as AQPD755EVA508,
                           9 as AQPD755EVA9,
                           509 as AQPD755EVA509,
                           10 as AQPD755EVA10,
                           510 as AQPD755EVA510,
                           11 as AQPD755EVA11,
                           511 as AQPD755EVA511,
                           12 as AQPD755EVA12,
                           512 as AQPD755EVA512,
                           13 as AQPD755EVA13,
                           513 as AQPD755EVA513,
                           14 as AQPD755EVA14,
                           514 as AQPD755EVA514,
                           15 as AQPD755EVA15,
                           515 as AQPD755EVA515,
                           16 as AQPD755EVA16,
                           516 as AQPD755EVA516,
                           17 as AQPD755EVA17,
                           517 as AQPD755EVA517,
                           18 as AQPD755EVA18,
                           518 as AQPD755EVA518,
                           19 as AQPD755EVA19,
                           519 as AQPD755EVA519,
                           20 as AQPD755EVA20,
                           520 as AQPD755EVA520,
                           21 as AQPD755EVA21,
                           521 as AQPD755EVA521,
                           22 as AQPD755EVA22,
                           522 as AQPD755EVA522,
                           23 as AQPD755EVA23,
                           24 as AQPD755EVA24,
                           524 as AQPD755EVA524,
                           25 as AQPD755EVA25,
                           26 as AQPD755EVA26,
                           526 as AQPD755EVA526,
                           27 as AQPD755EVA27,
                           527 as AQPD755EVA527,
                           29 as AQPD755EVA29,
                           529 as AQPD755EVA529,
                           30 as AQPD755EVA30));
    commit;
  END IF;
  VO_CLASI := v_modulo;

EXCEPTION
  WHEN OTHERS THEN
    VO_COD_ERROR := '0003';
    VO_MSG_ERROR := SUBSTR(SQLERRM, 1, 150);
    PQ_CR_REPROG_SIN_CAP.SP_GRABAR_LOG_ERRORES(P_INSTANCIA,
                                               '',
                                               '',
                                               'sp_cr_historico_reprogramaciones',
                                               '',
                                               VO_COD_ERROR,
                                               VO_MSG_ERROR);
    VO_MSG_ERROR := 'Error al insertar datos en la tablas aqpd755 o aqpd752';
END sp_cr_historico_reprogramaciones;
 /* GOLDENGATE_DDL_REPLICATION */
/

