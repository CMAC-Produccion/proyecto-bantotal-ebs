create or replace package PQ_CR_INFO_REPROG is

  -- ******************************************************************************************************
  -- Nombre                     : SP_CR_REPROG_CONS
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2020.06.16
  -- Autor de Creaci¿n          : GCARRANZAS
  -- Uso                        : DEVUELVE INFORMACION DE REPROGRAMACIONES PARA CREDITO CONSUMO
  -- Estado                     : Activo
  -- Acceso                     : PÚBLICO
  -- Par¿metros de Entrada      :
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************     
  Procedure SP_CR_REPROG_CONS(PN_INSTANCIA        IN NUMBER,
                              PV_NOMCLIENTE       OUT VARCHAR2,
                              PV_AGENCIA          OUT VARCHAR2,
                              PN_CUENTA           OUT NUMBER,
                              PN_SOLICITUD        OUT NUMBER,
                              PV_ACTECOPRECOVID   OUT VARCHAR2,
                              PV_ACTECONPOSTCOVID OUT VARCHAR2,
                              PV_CALIFSBSFEBRERO  OUT VARCHAR2,
                              PN_SALDOCREDITO     OUT NUMBER,
                              PN_ATRASOCREDITO    OUT NUMBER,
                              --PN_SALDOCREDT1        OUT NUMBER,
                              --PN_ATRASOCREDIT1      OUT NUMBER,
                              --PN_SALDOCREDT2        OUT NUMBER,
                              --PN_SALDOCREDT3        OUT NUMBER,
                              PN_SBSATRASO29FEB     OUT NUMBER,
                              PN_SBSATRASO15MAR     OUT NUMBER,
                              PN_SBSATRASOHOY       OUT NUMBER,
                              PN_SBSMAXIMO          OUT NUMBER,
                              PN_MONTOREPROG        OUT NUMBER,
                              PN_MESESGRACIA        OUT NUMBER,
                              PN_PLAZO              OUT NUMBER,
                              PN_RATIOPRECOVID      OUT NUMBER,
                              PN_ACT_INGRESOBRUTO   OUT NUMBER,
                              PN_ACT_INGRESONETO    OUT NUMBER,
                              PN_ACT_GASTOFAMILIAR  OUT NUMBER,
                              PN_ACT_ENDEUDAMIENTO  OUT NUMBER,
                              PN_ACT_TOTALEGRESOS   OUT NUMBER,
                              PN_ACT_RESULTNETO     OUT NUMBER,
                              PN_ACT_RATIOPOSTCOVID OUT NUMBER,
                              PN_ACT_EFECTIVO       OUT NUMBER,
                              PN_M12_INGRESOBRUTO   OUT NUMBER,
                              PN_M12_INGRESONETO    OUT NUMBER,
                              PN_M12_GASTOFAMILIAR  OUT NUMBER,
                              PN_M12_ENDEUDAMIENTO  OUT NUMBER,
                              PN_M12_TOTALEGRESOS   OUT NUMBER,
                              PN_M12_RESULTNETO     OUT NUMBER,
                              PN_M12_RATIOPOSTCOVID OUT NUMBER,
                              PV_CODERR             OUT VARCHAR2,
                              PV_DESERR             OUT VARCHAR2);

  -- ******************************************************************************************************
  -- Nombre                     : SP_CR_REPROG_CONS
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2020.06.16
  -- Autor de Creaci¿n          : GCARRANZAS
  -- Uso                        : DEVUELVE INFORMACION DE REPROGRAMACIONES PARA CREDITO CONSUMO
  -- Estado                     : Activo
  -- Acceso                     : PÚBLICO
  -- Par¿metros de Entrada      :
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************  
  Procedure SP_CR_REPROG_PYME(PN_INSTANCIA        IN NUMBER,
                              PV_NOMCLIENTE       OUT VARCHAR2,
                              PV_AGENCIA          OUT VARCHAR2,
                              PN_CUENTA           OUT NUMBER,
                              PN_SOLICITUD        OUT NUMBER,
                              PV_ACTECOPRECOVID   OUT VARCHAR2,
                              PV_ACTECONPOSTCOVID OUT VARCHAR2,
                              PV_CALIFSBSFEBRERO  OUT VARCHAR2,
                              PN_SALDOCREDITO     OUT NUMBER,
                              PN_ATRASOCREDITO    OUT NUMBER,
                              --PN_SALDOCREDT1        OUT NUMBER,
                              --PN_ATRASOCREDIT1      OUT NUMBER,
                              --PN_SALDOCREDT2        OUT NUMBER,
                              --PN_SALDOCREDT3        OUT NUMBER,
                              
                              PN_SBSATRASO29FEB OUT NUMBER,
                              PN_SBSATRASO15MAR OUT NUMBER,
                              PN_SBSATRASOHOY   OUT NUMBER,
                              PN_SBSMAXIMO      OUT NUMBER,
                              PN_MONTOREPROG    OUT NUMBER,
                              PN_MESESGRACIA    OUT NUMBER,
                              PN_PLAZO          OUT NUMBER,
                              PN_RATIOPRECOVID  OUT NUMBER,
                              
                              PN_BAL_CAJABANCOS    OUT NUMBER,
                              PN_BAL_INVENTARIO    OUT NUMBER,
                              PN_BAL_MAQEQUI       OUT NUMBER,
                              PN_BAL_INMUEBLES     OUT NUMBER,
                              PN_BAL_OTROS         OUT NUMBER,
                              PN_BAL_TOTALACTIVO   OUT NUMBER,
                              PN_BAL_TOTALPASIVO   OUT NUMBER,
                              PN_BAL_PATRIMONIO    OUT NUMBER,
                              PN_ACT_VENTAS        OUT NUMBER,
                              PN_ACT_COVENTAS      OUT NUMBER,
                              PN_ACT_COOPERATIVO   OUT NUMBER,
                              PN_ACT_GAFINANCIERO  OUT NUMBER,
                              PN_ACT_RESULEMP      OUT NUMBER,
                              PN_ACT_GASTOSFIN     OUT NUMBER,
                              PN_ACT_GASTOSFAM     OUT NUMBER,
                              PN_ACT_RESULTADONETO OUT NUMBER,
                              PN_ACT_RATIOPOSTCOV  OUT NUMBER,
                              PN_M12_VENTAS        OUT NUMBER,
                              PN_M12_COVENTAS      OUT NUMBER,
                              PN_M12_COOPERATIVO   OUT NUMBER,
                              PN_M12_GAFINANCIERO  OUT NUMBER,
                              PN_M12_RESULEMP      OUT NUMBER,
                              PN_M12_GASTOSFIN     OUT NUMBER,
                              PN_M12_GASTOSFAM     OUT NUMBER,
                              PN_M12_RESULTADONETO OUT NUMBER,
                              PN_M12_RATIOPOSTCOV  OUT NUMBER,
                              PV_CODERR            OUT VARCHAR2,
                              PV_DESERR            OUT VARCHAR2);

  -- ******************************************************************************************************
  -- Nombre                     : SP_CR_REPROG_LEY31050
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 18.11.2020
  -- Autor de Creaci¿n          : GCARRANZAS
  -- Uso                        : DEVUELVE INFORMACION DE REPROGRAMACIONES LEY 31050 CONS Y PYME
  -- Estado                     : Activo
  -- Acceso                     : PÚBLICO
  -- Par¿metros de Entrada      :
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************                                                                              
  Procedure SP_CR_REPROG_LEY31050(PN_INSTANCIA  IN NUMBER,
                                  PV_USUARIO    IN VARCHAR2,
                                  PD_FECPRO     IN DATE,
                                  PV_HORA       IN VARCHAR2,
                                  PN_NOGUARDAR  IN NUMBER,
                                  PV_DNI        OUT VARCHAR2,
                                  PV_NOMCLIENTE OUT VARCHAR2,
                                  PV_CREDITOS   OUT VARCHAR2,
                                  --PYME
                                  PN_BAL_CAJABANCOS    OUT NUMBER,
                                  PN_BAL_INVENTARIO    OUT NUMBER,
                                  PN_BAL_MAQEQUI       OUT NUMBER,
                                  PN_BAL_INMUEBLES     OUT NUMBER,
                                  PN_BAL_OTROS         OUT NUMBER,
                                  PN_BAL_TOTALACTIVO   OUT NUMBER,
                                  PN_BAL_TOTALPASIVO   OUT NUMBER,
                                  PN_BAL_PATRIMONIO    OUT NUMBER,
                                  PN_ACT_VENTAS        OUT NUMBER,
                                  PN_ACT_COVENTAS      OUT NUMBER,
                                  PN_ACT_COOPERATIVO   OUT NUMBER,
                                  PN_ACT_GAFINANCIERO  OUT NUMBER,
                                  PN_ACT_RESULEMP      OUT NUMBER,
                                  PN_ACT_GASTOSFIN     OUT NUMBER,
                                  PN_ACT_GASTOSFAM     OUT NUMBER,
                                  PN_ACT_RESULTADONETO OUT NUMBER,
                                  PN_ACT_RATIOPOSTCOV  OUT NUMBER,
                                  PN_M12_VENTAS        OUT NUMBER,
                                  PN_M12_COVENTAS      OUT NUMBER,
                                  PN_M12_COOPERATIVO   OUT NUMBER,
                                  PN_M12_GAFINANCIERO  OUT NUMBER,
                                  PN_M12_RESULEMP      OUT NUMBER,
                                  PN_M12_GASTOSFIN     OUT NUMBER,
                                  PN_M12_GASTOSFAM     OUT NUMBER,
                                  PN_M12_RESULTADONETO OUT NUMBER,
                                  PN_M12_RATIOPOSTCOV  OUT NUMBER,
                                  --CONSUMO
                                  PN_ACT_INGRESOBRUTO   OUT NUMBER,
                                  PN_ACT_INGRESONETO    OUT NUMBER,
                                  PN_ACT_GASTOFAMILIAR  OUT NUMBER,
                                  PN_ACT_ENDEUDAMIENTO  OUT NUMBER,
                                  PN_ACT_TOTALEGRESOS   OUT NUMBER,
                                  PN_ACT_RESULTNETO     OUT NUMBER,
                                  PN_ACT_RATIOPOSTCOVID OUT NUMBER,
                                  PN_ACT_EFECTIVO       OUT NUMBER,
                                  PN_M12_INGRESOBRUTO   OUT NUMBER,
                                  PN_M12_INGRESONETO    OUT NUMBER,
                                  PN_M12_GASTOFAMILIAR  OUT NUMBER,
                                  PN_M12_ENDEUDAMIENTO  OUT NUMBER,
                                  PN_M12_TOTALEGRESOS   OUT NUMBER,
                                  PN_M12_RESULTNETO     OUT NUMBER,
                                  PN_M12_RATIOPOSTCOVID OUT NUMBER,
                                  --RESPUESTAS
                                  PV_CODERR OUT VARCHAR2,
                                  PV_DESERR OUT VARCHAR2);

  -- ******************************************************************************************************
  -- Nombre                     : SP_CR_REPROG_LEY31050
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 08.12.2020
  -- Autor de Creaci¿n          : GCARRANZAS
  -- Uso                        : GRABA LOS CREDITOS CONDONADOS EN TABLA AQPA997
  -- Estado                     : Activo
  -- Acceso                     : PÚBLICO
  -- Par¿metros de Entrada      :
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  -- ********************************************************************************************************                                                                              
  Procedure SP_CR_BUSCAR_CONDONADOS(PV_USUARIO    IN CHAR,
                                    PV_DNI        IN CHAR,
                                    PV_NOMCLIENTE OUT VARCHAR2,
                                    --RESPUESTAS
                                    PV_CODERR OUT VARCHAR2,
                                    PV_DESERR OUT VARCHAR2);
end PQ_CR_INFO_REPROG;
/

create or replace package body PQ_CR_INFO_REPROG is
  Procedure SP_CR_REPROG_CONS(PN_INSTANCIA        IN NUMBER,
                              PV_NOMCLIENTE       OUT VARCHAR2,
                              PV_AGENCIA          OUT VARCHAR2,
                              PN_CUENTA           OUT NUMBER,
                              PN_SOLICITUD        OUT NUMBER,
                              PV_ACTECOPRECOVID   OUT VARCHAR2,
                              PV_ACTECONPOSTCOVID OUT VARCHAR2,
                              PV_CALIFSBSFEBRERO  OUT VARCHAR2,
                              PN_SALDOCREDITO     OUT NUMBER,
                              PN_ATRASOCREDITO    OUT NUMBER,
                              --PN_SALDOCREDT1        OUT NUMBER,
                              --PN_ATRASOCREDIT1      OUT NUMBER,
                              --PN_SALDOCREDT2        OUT NUMBER,
                              --PN_SALDOCREDT3        OUT NUMBER,
                              PN_SBSATRASO29FEB     OUT NUMBER,
                              PN_SBSATRASO15MAR     OUT NUMBER,
                              PN_SBSATRASOHOY       OUT NUMBER,
                              PN_SBSMAXIMO          OUT NUMBER,
                              PN_MONTOREPROG        OUT NUMBER,
                              PN_MESESGRACIA        OUT NUMBER,
                              PN_PLAZO              OUT NUMBER,
                              PN_RATIOPRECOVID      OUT NUMBER,
                              PN_ACT_INGRESOBRUTO   OUT NUMBER,
                              PN_ACT_INGRESONETO    OUT NUMBER,
                              PN_ACT_GASTOFAMILIAR  OUT NUMBER,
                              PN_ACT_ENDEUDAMIENTO  OUT NUMBER,
                              PN_ACT_TOTALEGRESOS   OUT NUMBER,
                              PN_ACT_RESULTNETO     OUT NUMBER,
                              PN_ACT_RATIOPOSTCOVID OUT NUMBER,
                              PN_ACT_EFECTIVO       OUT NUMBER,
                              PN_M12_INGRESOBRUTO   OUT NUMBER,
                              PN_M12_INGRESONETO    OUT NUMBER,
                              PN_M12_GASTOFAMILIAR  OUT NUMBER,
                              PN_M12_ENDEUDAMIENTO  OUT NUMBER,
                              PN_M12_TOTALEGRESOS   OUT NUMBER,
                              PN_M12_RESULTNETO     OUT NUMBER,
                              PN_M12_RATIOPOSTCOVID OUT NUMBER,
                              PV_CODERR             OUT VARCHAR2,
                              PV_DESERR             OUT VARCHAR2) is
  
    LC_FLAG CHAR;
  
  BEGIN
    PV_CODERR := '000';
    PV_DESERR := '';
  
    IF PN_INSTANCIA IS null or PN_INSTANCIA = 0 THEN
      PV_CODERR := '001';
      PV_DESERR := 'INSTANCIA SIN VALOR';
      RETURN;
    END IF;
  
    pq_cr_reprogra_crm.sp_verifica(pn_ins => PN_INSTANCIA, ---ingreso:instancia
                                   pc_flg => LC_FLAG, --retorna:flag
                                   pn_sol => PN_SOLICITUD); --retorna codigo solicitud
  
    IF PN_SOLICITUD IS NULL OR PN_SOLICITUD = 0 THEN
      PV_CODERR := '002';
      PV_DESERR := 'SOLICITUD SIN VALOR';
      RETURN;
    END IF;
  
    BEGIN
      SELECT NOMCLIENTE,
             AGENCIA,
             CUENTA,
             ACTECOPRECOVID,
             CALIFSBSFEBRERO,
             --SALDOCREDT1, ATRASOCREDIT1, SALDOCREDT2, SALDOCREDT2
             SALDOCREDITO,
             ATRASOCREDITO,
             SBSATRASO29FEB,
             SBSATRASO15MAR,
             SBSATRASOHOY,
             SBSMAXIMO,
             MONTOREPROG,
             MESESGRACIA,
             PLAZO,
             RATIOPRECOVID
        INTO PV_NOMCLIENTE,
             PV_AGENCIA,
             PN_CUENTA,
             PV_ACTECOPRECOVID,
             PV_CALIFSBSFEBRERO,
             -- PN_SALDOCREDT1, PN_ATRASOCREDIT1, PN_SALDOCREDT2, PN_SALDOCREDT3
             PN_SALDOCREDITO,
             PN_ATRASOCREDITO,
             PN_SBSATRASO29FEB,
             PN_SBSATRASO15MAR,
             PN_SBSATRASOHOY,
             PN_SBSMAXIMO,
             PN_MONTOREPROG,
             PN_MESESGRACIA,
             PN_PLAZO,
             PN_RATIOPRECOVID
        FROM REPROG_FORM_DATA
       WHERE SOLICITUD = PN_SOLICITUD
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        PV_CODERR := '003';
        PV_DESERR := 'NO HAY DATA EN REPROG_FORM_DATA';
        NULL;
    END;
  
    BEGIN
      SELECT ACTECONPOSTCOVID,
             ACT_INGRESOBRUTO,
             ACT_INGRESONETO,
             ACT_GASTOFAMILIAR,
             ACT_ENDEUDAMIENTO,
             ACT_TOTALEGRESOS,
             ACT_RESULTNETO,
             ACT_RATIOPOSTCOVID,
             ACT_EFECTIVO,
             M12_INGRESOBRUTO,
             M12_INGRESONETO,
             M12_GASTOFAMILIAR,
             M12_ENDEUDAMIENTO,
             M12_TOTALEGRESOS,
             M12_RESULTNETO,
             M12_RATIOPOSTCOVID
        INTO PV_ACTECONPOSTCOVID,
             PN_ACT_INGRESOBRUTO,
             PN_ACT_INGRESONETO,
             PN_ACT_GASTOFAMILIAR,
             PN_ACT_ENDEUDAMIENTO,
             PN_ACT_TOTALEGRESOS,
             PN_ACT_RESULTNETO,
             PN_ACT_RATIOPOSTCOVID,
             PN_ACT_EFECTIVO,
             PN_M12_INGRESOBRUTO,
             PN_M12_INGRESONETO,
             PN_M12_GASTOFAMILIAR,
             PN_M12_ENDEUDAMIENTO,
             PN_M12_TOTALEGRESOS,
             PN_M12_RESULTNETO,
             PN_M12_RATIOPOSTCOVID
        FROM REPROG_FORM_CONS
       WHERE SOLICITUD = PN_SOLICITUD
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        PV_CODERR := '003';
        PV_DESERR := 'NO HAY DATA REPROG_FORM_CONS';
        NULL;
    END;
  
  END SP_CR_REPROG_CONS;

  Procedure SP_CR_REPROG_PYME(PN_INSTANCIA         IN NUMBER,
                              PV_NOMCLIENTE        OUT VARCHAR2,
                              PV_AGENCIA           OUT VARCHAR2,
                              PN_CUENTA            OUT NUMBER,
                              PN_SOLICITUD         OUT NUMBER,
                              PV_ACTECOPRECOVID    OUT VARCHAR2,
                              PV_ACTECONPOSTCOVID  OUT VARCHAR2,
                              PV_CALIFSBSFEBRERO   OUT VARCHAR2,
                              PN_SALDOCREDITO      OUT NUMBER,
                              PN_ATRASOCREDITO     OUT NUMBER,
                              PN_SBSATRASO29FEB    OUT NUMBER,
                              PN_SBSATRASO15MAR    OUT NUMBER,
                              PN_SBSATRASOHOY      OUT NUMBER,
                              PN_SBSMAXIMO         OUT NUMBER,
                              PN_MONTOREPROG       OUT NUMBER,
                              PN_MESESGRACIA       OUT NUMBER,
                              PN_PLAZO             OUT NUMBER,
                              PN_RATIOPRECOVID     OUT NUMBER,
                              PN_BAL_CAJABANCOS    OUT NUMBER,
                              PN_BAL_INVENTARIO    OUT NUMBER,
                              PN_BAL_MAQEQUI       OUT NUMBER,
                              PN_BAL_INMUEBLES     OUT NUMBER,
                              PN_BAL_OTROS         OUT NUMBER,
                              PN_BAL_TOTALACTIVO   OUT NUMBER,
                              PN_BAL_TOTALPASIVO   OUT NUMBER,
                              PN_BAL_PATRIMONIO    OUT NUMBER,
                              PN_ACT_VENTAS        OUT NUMBER,
                              PN_ACT_COVENTAS      OUT NUMBER,
                              PN_ACT_COOPERATIVO   OUT NUMBER,
                              PN_ACT_GAFINANCIERO  OUT NUMBER,
                              PN_ACT_RESULEMP      OUT NUMBER,
                              PN_ACT_GASTOSFIN     OUT NUMBER,
                              PN_ACT_GASTOSFAM     OUT NUMBER,
                              PN_ACT_RESULTADONETO OUT NUMBER,
                              PN_ACT_RATIOPOSTCOV  OUT NUMBER,
                              PN_M12_VENTAS        OUT NUMBER,
                              PN_M12_COVENTAS      OUT NUMBER,
                              PN_M12_COOPERATIVO   OUT NUMBER,
                              PN_M12_GAFINANCIERO  OUT NUMBER,
                              PN_M12_RESULEMP      OUT NUMBER,
                              PN_M12_GASTOSFIN     OUT NUMBER,
                              PN_M12_GASTOSFAM     OUT NUMBER,
                              PN_M12_RESULTADONETO OUT NUMBER,
                              PN_M12_RATIOPOSTCOV  OUT NUMBER,
                              PV_CODERR            OUT VARCHAR2,
                              PV_DESERR            OUT VARCHAR2) IS
    LC_FLAG CHAR;
  
  BEGIN
    PV_CODERR := '003';
    PV_DESERR := '';
  
    IF PN_INSTANCIA IS null or PN_INSTANCIA = 0 THEN
      PV_CODERR := '003';
      PV_DESERR := 'INSTANCIA SIN VALOR';
      RETURN;
    END IF;
  
    pq_cr_reprogra_crm.sp_verifica(pn_ins => PN_INSTANCIA, ---ingreso:instancia
                                   pc_flg => LC_FLAG, --retorna:flag
                                   pn_sol => PN_SOLICITUD); --retorna codigo solicitud
    BEGIN
      SELECT NOMCLIENTE,
             AGENCIA,
             CUENTA,
             ACTECOPRECOVID,
             CALIFSBSFEBRERO,
             --SALDOCREDT1, ATRASOCREDIT1, SALDOCREDT2, SALDOCREDT2
             SALDOCREDITO,
             ATRASOCREDITO,
             SBSATRASO29FEB,
             SBSATRASO15MAR,
             SBSATRASOHOY,
             SBSMAXIMO,
             MONTOREPROG,
             MESESGRACIA,
             PLAZO,
             RATIOPRECOVID
        INTO PV_NOMCLIENTE,
             PV_AGENCIA,
             PN_CUENTA,
             PV_ACTECOPRECOVID,
             PV_CALIFSBSFEBRERO,
             -- PN_SALDOCREDT1, PN_ATRASOCREDIT1, PN_SALDOCREDT2, PN_SALDOCREDT3
             PN_SALDOCREDITO,
             PN_ATRASOCREDITO,
             PN_SBSATRASO29FEB,
             PN_SBSATRASO15MAR,
             PN_SBSATRASOHOY,
             PN_SBSMAXIMO,
             PN_MONTOREPROG,
             PN_MESESGRACIA,
             PN_PLAZO,
             PN_RATIOPRECOVID
        FROM REPROG_FORM_DATA
       WHERE SOLICITUD = PN_SOLICITUD
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        PV_CODERR := '003';
        PV_DESERR := 'NO HAY DATA REPROG_FORM_DATA';
        NULL;
    END;
  
    BEGIN
      SELECT ACTECONPOSTCOVID,
             BAL_CAJABANCOS,
             BAL_INVENTARIO,
             BAL_MAQEQUI,
             BAL_INMUEBLES,
             BAL_OTROS,
             BAL_TOTALACTIVO,
             BAL_TOTALPASIVO,
             BAL_PATRIMONIO,
             ACT_VENTAS,
             ACT_COVENTAS,
             ACT_COOPERATIVO,
             ACT_GAFINANCIERO,
             ACT_RESULEMP,
             ACT_GASTOSFIN,
             ACT_GASTOSFAM,
             ACT_RESULTADONETO,
             ACT_RATIOPOSTCOV,
             M12_VENTAS,
             M12_COVENTAS,
             M12_COOPERATIVO,
             M12_GAFINANCIERO,
             M12_RESULEMP,
             M12_GASTOSFIN,
             M12_GASTOSFAM,
             M12_RESULTADONETO,
             M12_RATIOPOSTCOV
        INTO PV_ACTECONPOSTCOVID,
             PN_BAL_CAJABANCOS,
             PN_BAL_INVENTARIO,
             PN_BAL_MAQEQUI,
             PN_BAL_INMUEBLES,
             PN_BAL_OTROS,
             PN_BAL_TOTALACTIVO,
             PN_BAL_TOTALPASIVO,
             PN_BAL_PATRIMONIO,
             PN_ACT_VENTAS,
             PN_ACT_COVENTAS,
             PN_ACT_COOPERATIVO,
             PN_ACT_GAFINANCIERO,
             PN_ACT_RESULEMP,
             PN_ACT_GASTOSFIN,
             PN_ACT_GASTOSFAM,
             PN_ACT_RESULTADONETO,
             PN_ACT_RATIOPOSTCOV,
             PN_M12_VENTAS,
             PN_M12_COVENTAS,
             PN_M12_COOPERATIVO,
             PN_M12_GAFINANCIERO,
             PN_M12_RESULEMP,
             PN_M12_GASTOSFIN,
             PN_M12_GASTOSFAM,
             PN_M12_RESULTADONETO,
             PN_M12_RATIOPOSTCOV
        FROM REPROG_FORM_MYPE
       WHERE SOLICITUD = PN_SOLICITUD
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        PV_CODERR := '003';
        PV_DESERR := 'NO HAY DATA REPROG_FORM_MYPE';
        NULL;
    END;
  
  END SP_CR_REPROG_PYME;

  Procedure SP_CR_REPROG_LEY31050(PN_INSTANCIA  IN NUMBER,
                                  PV_USUARIO    IN VARCHAR2,
                                  PD_FECPRO     IN DATE,
                                  PV_HORA       IN VARCHAR2,
                                  PN_NOGUARDAR  IN NUMBER,
                                  PV_DNI        OUT VARCHAR2,
                                  PV_NOMCLIENTE OUT VARCHAR2,
                                  PV_CREDITOS   OUT VARCHAR2,
                                  --PYME
                                  PN_BAL_CAJABANCOS    OUT NUMBER,
                                  PN_BAL_INVENTARIO    OUT NUMBER,
                                  PN_BAL_MAQEQUI       OUT NUMBER,
                                  PN_BAL_INMUEBLES     OUT NUMBER,
                                  PN_BAL_OTROS         OUT NUMBER,
                                  PN_BAL_TOTALACTIVO   OUT NUMBER,
                                  PN_BAL_TOTALPASIVO   OUT NUMBER,
                                  PN_BAL_PATRIMONIO    OUT NUMBER,
                                  PN_ACT_VENTAS        OUT NUMBER,
                                  PN_ACT_COVENTAS      OUT NUMBER,
                                  PN_ACT_COOPERATIVO   OUT NUMBER,
                                  PN_ACT_GAFINANCIERO  OUT NUMBER,
                                  PN_ACT_RESULEMP      OUT NUMBER,
                                  PN_ACT_GASTOSFIN     OUT NUMBER,
                                  PN_ACT_GASTOSFAM     OUT NUMBER,
                                  PN_ACT_RESULTADONETO OUT NUMBER,
                                  PN_ACT_RATIOPOSTCOV  OUT NUMBER,
                                  PN_M12_VENTAS        OUT NUMBER,
                                  PN_M12_COVENTAS      OUT NUMBER,
                                  PN_M12_COOPERATIVO   OUT NUMBER,
                                  PN_M12_GAFINANCIERO  OUT NUMBER,
                                  PN_M12_RESULEMP      OUT NUMBER,
                                  PN_M12_GASTOSFIN     OUT NUMBER,
                                  PN_M12_GASTOSFAM     OUT NUMBER,
                                  PN_M12_RESULTADONETO OUT NUMBER,
                                  PN_M12_RATIOPOSTCOV  OUT NUMBER,
                                  --CONSUMO
                                  PN_ACT_INGRESOBRUTO   OUT NUMBER,
                                  PN_ACT_INGRESONETO    OUT NUMBER,
                                  PN_ACT_GASTOFAMILIAR  OUT NUMBER,
                                  PN_ACT_ENDEUDAMIENTO  OUT NUMBER,
                                  PN_ACT_TOTALEGRESOS   OUT NUMBER,
                                  PN_ACT_RESULTNETO     OUT NUMBER,
                                  PN_ACT_RATIOPOSTCOVID OUT NUMBER,
                                  PN_ACT_EFECTIVO       OUT NUMBER,
                                  PN_M12_INGRESOBRUTO   OUT NUMBER,
                                  PN_M12_INGRESONETO    OUT NUMBER,
                                  PN_M12_GASTOFAMILIAR  OUT NUMBER,
                                  PN_M12_ENDEUDAMIENTO  OUT NUMBER,
                                  PN_M12_TOTALEGRESOS   OUT NUMBER,
                                  PN_M12_RESULTNETO     OUT NUMBER,
                                  PN_M12_RATIOPOSTCOVID OUT NUMBER,
                                  --RESPUESTAS
                                  PV_CODERR OUT VARCHAR2,
                                  PV_DESERR OUT VARCHAR2) IS
    LN_emp   NUMBER;
    Ln_mod   NUMBER;
    LN_suc   NUMBER;
    LN_mda   NUMBER;
    LN_pap   NUMBER;
    LN_cta   NUMBER;
    LN_ope   NUMBER;
    LN_sbo   NUMBER;
    LN_top   NUMBER;
    LN_IDLEY NUMBER;
  
  BEGIN
    PV_CODERR := '000';
    PV_DESERR := 'OK';
  
    IF PN_INSTANCIA IS null or PN_INSTANCIA = 0 THEN
      PV_CODERR := '001';
      PV_DESERR := 'INSTANCIA SIN VALOR';
      RETURN;
    END IF;
  
    BEGIN
      SELECT J.JAQY800PGCD,
             J.JAQY800MOD,
             J.JAQY800SUC,
             J.JAQY800MDA,
             J.JAQY800PAP,
             J.JAQY800CTA,
             J.JAQY800OPE,
             J.JAQY800SBOP,
             J.JAQY800TOPE
        INTO LN_emp,
             Ln_mod,
             LN_suc,
             LN_mda,
             LN_pap,
             LN_cta,
             LN_ope,
             LN_sbo,
             LN_top
        FROM JAQY800 J
       WHERE J.JAQY800VINC = 'S'
         AND J.JAQY800INS = PN_INSTANCIA;
    EXCEPTION
      WHEN OTHERS THEN
      
        BEGIN
          SELECT X.XWFEMPRESA,
                 X.XWFMODULO,
                 X.XWFSUCURSAL,
                 X.XWFMONEDA,
                 X.XWFPAPEL,
                 X.XWFCUENTA,
                 X.XWFOPERACION,
                 X.XWFSUBOPE,
                 X.XWFTIPOPE
            INTO LN_emp,
                 Ln_mod,
                 LN_suc,
                 LN_mda,
                 LN_pap,
                 LN_cta,
                 LN_ope,
                 LN_sbo,
                 LN_top
            FROM XWF700 X
           WHERE X.XWFPRCINS = PN_INSTANCIA
             AND X.XWFCAR3 <> '1';
        EXCEPTION
          WHEN OTHERS THEN
            PV_CODERR := '002';
            PV_DESERR := 'NO HAY CLAVE DEL CREDITO';
        END;
      
    END;
  
    BEGIN
      pq_cr_funciones_cho.sp_obtener_idley(pn_emp   => LN_emp,
                                           pn_mod   => Ln_mod,
                                           pn_suc   => Ln_suc,
                                           pn_mda   => Ln_mda,
                                           pn_pap   => Ln_pap,
                                           pn_cta   => Ln_cta,
                                           pn_ope   => Ln_ope,
                                           pn_sbo   => Ln_sbo,
                                           pn_top   => Ln_top,
                                           pn_idley => LN_IDLEY); --retorna el idley
    END;
  
    IF LN_IDLEY > 0 THEN
    
      BEGIN
        SELECT DNICLIENTE
          INTO PV_DNI
          FROM LEY31050
         WHERE IDLEY31050 = LN_IDLEY
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          PV_CODERR := '004';
          PV_DESERR := 'NO HAY DNI CLIENTE';
      END;
    
      BEGIN
        SELECT NOMCLIENTE
          INTO PV_NOMCLIENTE
          FROM LEY31050_FORM_DATA
         WHERE DNICLIENTE = PV_DNI
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          PV_CODERR := '005';
          PV_DESERR := 'NO HAY NOMBRE CLIENTE';
      END;
    
      BEGIN
        SELECT LISTAGG('Cuenta Operación ' || F.CUENTAOPERACION || CASE
                         WHEN F.TIPOCREDITO = 'C' THEN
                          ' (CONSUMO)'
                         ELSE
                          ' (MYPE)'
                       END || CHR(9) || CHR(9) || CHR(9) || CHR(9) ||
                       CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) ||
                       CHR(9) || 'Monto Desembolsado' || CASE
                         WHEN F.MONEDA = 0 THEN
                          ' S/ '
                         ELSE
                          ' $ '
                       END ||
                       TO_CHAR(F.MONTOCREDITO, 'fm999,999,999,999.00') ||
                       CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) ||
                       CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) ||
                       'Tasa actual de ' ||
                       TO_CHAR(C.TASAACTUAL, 'fm999.999999') || ' %' ||
                       CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) ||
                       CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) ||
                       CHR(9) || 'Nueva tasa de ' ||
                       TO_CHAR(F.NUEVATASA, 'fm999.999999') || ' %' ||
                       CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) ||
                       CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) ||
                       CHR(9) || 'Facilidad: ' || F.FACILIDAD || CHR(9) ||
                       CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) ||
                       CHR(9) || CHR(9) || CHR(9) || CHR(9) ||
                       'Situación negocio: ' || CASE
                         WHEN TRIM(F.SITUACIONNEGOCIO) = '' OR
                              F.SITUACIONNEGOCIO IS NULL THEN
                          CHR(9) || CHR(9) || CHR(9)
                         ELSE
                          F.SITUACIONNEGOCIO
                       END || CHR(9) || CHR(9) || CHR(9) || CHR(9) ||
                       CHR(9) || CHR(9) || CHR(9) || CHR(9) ||
                       'Nueva Total ' || CASE
                         WHEN F.MONEDA = 0 THEN
                          ' S/ '
                         ELSE
                          ' $ '
                       END || TO_CHAR(F.MONTOCAPITALIZACION,
                                      'fm999,999,999,990.00') || CHR(9) ||
                       CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) ||
                       CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9),
                       ' ') WITHIN GROUP(ORDER BY F.CUENTAOPERACION) LISTA
          INTO PV_CREDITOS
          FROM LEY31050_CREDITOSFACILIDAD F, LEY31050_CREDITOS C
         WHERE F.CUENTAOPERACION = C.CUENTAOPERACION
           AND F.EMPRESA = C.EMPRESA
           AND F.SUCURSAL = C.SUCURSAL
           AND F.MODULO = C.MODULO
           AND F.MONEDA = C.MONEDA
           AND F.PAPEL = C.PAPEL
           AND F.SUBOPERACION = C.SUBOPERACION
           AND F.TIPOOPERACION = C.TIPOOPERACION
           AND F.IDLEY31050 = LN_IDLEY;
      EXCEPTION
        WHEN OTHERS THEN
          PV_CODERR := '006';
          PV_DESERR := 'NO HAY CREDITOS';
      END;
    
    ELSE
      PV_CODERR := '007';
      PV_DESERR := 'NO HAY IDLEY31050';
      RETURN;
    END IF;
  
    BEGIN
      SELECT BAL_CAJABANCOS,
             BAL_INVENTARIO,
             BAL_MAQEQUI,
             BAL_INMUEBLES,
             BAL_OTROS,
             BAL_TOTALACTIVO,
             BAL_TOTALPASIVO,
             BAL_PATRIMONIO,
             ACT_VENTAS,
             ACT_COVENTAS,
             ACT_COOPERATIVO,
             ACT_GAFINANCIERO,
             ACT_RESULEMP,
             ACT_GASTOSFIN,
             ACT_GASTOSFAM,
             ACT_RESULTADONETO,
             ACT_RATIOPOSTCOV,
             M12_VENTAS,
             M12_COVENTAS,
             M12_COOPERATIVO,
             M12_GAFINANCIERO,
             M12_RESULEMP,
             M12_GASTOSFIN,
             M12_GASTOSFAM,
             M12_RESULTADONETO,
             M12_RATIOPOSTCOV
        INTO PN_BAL_CAJABANCOS,
             PN_BAL_INVENTARIO,
             PN_BAL_MAQEQUI,
             PN_BAL_INMUEBLES,
             PN_BAL_OTROS,
             PN_BAL_TOTALACTIVO,
             PN_BAL_TOTALPASIVO,
             PN_BAL_PATRIMONIO,
             PN_ACT_VENTAS,
             PN_ACT_COVENTAS,
             PN_ACT_COOPERATIVO,
             PN_ACT_GAFINANCIERO,
             PN_ACT_RESULEMP,
             PN_ACT_GASTOSFIN,
             PN_ACT_GASTOSFAM,
             PN_ACT_RESULTADONETO,
             PN_ACT_RATIOPOSTCOV,
             PN_M12_VENTAS,
             PN_M12_COVENTAS,
             PN_M12_COOPERATIVO,
             PN_M12_GAFINANCIERO,
             PN_M12_RESULEMP,
             PN_M12_GASTOSFIN,
             PN_M12_GASTOSFAM,
             PN_M12_RESULTADONETO,
             PN_M12_RATIOPOSTCOV
        FROM LEY31050_FORM_MYPE
       WHERE IDLEY31050 = LN_IDLEY
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        PV_CODERR := '008';
        PV_DESERR := 'NO HAY DATA MYPE';
        NULL;
    END;
  
    BEGIN
      SELECT ACT_INGRESOBRUTO,
             ACT_INGRESONETO,
             ACT_GASTOFAMILIAR,
             ACT_ENDEUDAMIENTO,
             ACT_TOTALEGRESOS,
             ACT_RESULTNETO,
             ACT_RATIOPOSTCOVID,
             ACT_EFECTIVO,
             M12_INGRESOBRUTO,
             M12_INGRESONETO,
             M12_GASTOFAMILIAR,
             M12_ENDEUDAMIENTO,
             M12_TOTALEGRESOS,
             M12_RESULTNETO,
             M12_RATIOPOSTCOVID
        INTO PN_ACT_INGRESOBRUTO,
             PN_ACT_INGRESONETO,
             PN_ACT_GASTOFAMILIAR,
             PN_ACT_ENDEUDAMIENTO,
             PN_ACT_TOTALEGRESOS,
             PN_ACT_RESULTNETO,
             PN_ACT_RATIOPOSTCOVID,
             PN_ACT_EFECTIVO,
             PN_M12_INGRESOBRUTO,
             PN_M12_INGRESONETO,
             PN_M12_GASTOFAMILIAR,
             PN_M12_ENDEUDAMIENTO,
             PN_M12_TOTALEGRESOS,
             PN_M12_RESULTNETO,
             PN_M12_RATIOPOSTCOVID
        FROM LEY31050_FORM_CONS
       WHERE IDLEY31050 = LN_IDLEY
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        PV_CODERR := '009';
        PV_DESERR := 'NO HAY DATA CONSUMO';
        NULL;
    END;
  
    IF PN_NOGUARDAR = 0 THEN
      --desactivar antiguos registros -desactivados C
      UPDATE AQPA994
         SET AQPA994EST = 'C'
       WHERE AQPA994INS = PN_INSTANCIA
         AND AQPA994IDLEY = LN_IDLEY
         AND AQPA994EST = 'G';
      COMMIT;
      --  AGREGAR A LA TABLA AQPA994 - activos G
      INSERT INTO AQPA994
        (aqpa994idley,
         aqpa994ins,
         aqpa994usu,
         aqpa994fecpro,
         aqpa994hora,
         aqpa994est,
         aqpa994dni,
         aqpa994nomc,
         aqpa994credis,
         aqpa994bcajbancs,
         aqpa994binvcs,
         aqpa994bmaqeqcs,
         aqpa994binmucs,
         aqpa994botrocs,
         aqpa994btotaccs,
         aqpa994btotpacs,
         aqpa994bpatrcs,
         aqpa994venacs,
         aqpa994cosvenacs,
         aqpa994cosopeacs,
         aqpa994gfmypeacs,
         aqpa994resempacs,
         aqpa994gfconacs,
         aqpa994gasfamacs,
         aqpa994resnetacs,
         aqpa994rapocoacs,
         aqpa994vendocs,
         aqpa994cosvendocs,
         aqpa994cosopedocs,
         aqpa994gfmypedocs,
         aqpa994resempdocs,
         aqpa994gfcondocs,
         aqpa994gasfamdocs,
         aqpa994resnetdocs,
         aqpa994rapocodocs,
         aqpa994ingbruacmp,
         aqpa994ingnetacmp,
         aqpa994gasfamacmp,
         aqpa994endeuacmp,
         aqpa994totegracmp,
         aqpa994resnetacmp,
         aqpa994ratpocoacmp,
         aqpa994ratefeacmp,
         aqpa994ingbrudomp,
         aqpa994ingnetdomp,
         aqpa994gasfamdomp,
         aqpa994endeudomp,
         aqpa994totegrdomp,
         aqpa994resnetdomp,
         aqpa994ratpocodomp)
      VALUES
        (LN_IDLEY,
         PN_INSTANCIA,
         PV_USUARIO,
         PD_FECPRO,
         PV_HORA,
         'G',
         PV_DNI,
         PV_NOMCLIENTE,
         PV_CREDITOS,
         PN_BAL_CAJABANCOS,
         PN_BAL_INVENTARIO,
         PN_BAL_MAQEQUI,
         PN_BAL_INMUEBLES,
         PN_BAL_OTROS,
         PN_BAL_TOTALACTIVO,
         PN_BAL_TOTALPASIVO,
         PN_BAL_PATRIMONIO,
         PN_ACT_VENTAS,
         PN_ACT_COVENTAS,
         PN_ACT_COOPERATIVO,
         PN_ACT_GAFINANCIERO,
         PN_ACT_RESULEMP,
         PN_ACT_GASTOSFIN,
         PN_ACT_GASTOSFAM,
         PN_ACT_RESULTADONETO,
         PN_ACT_RATIOPOSTCOV,
         PN_M12_VENTAS,
         PN_M12_COVENTAS,
         PN_M12_COOPERATIVO,
         PN_M12_GAFINANCIERO,
         PN_M12_RESULEMP,
         PN_M12_GASTOSFIN,
         PN_M12_GASTOSFAM,
         PN_M12_RESULTADONETO,
         PN_M12_RATIOPOSTCOV,
         PN_ACT_INGRESOBRUTO,
         PN_ACT_INGRESONETO,
         PN_ACT_GASTOFAMILIAR,
         PN_ACT_ENDEUDAMIENTO,
         PN_ACT_TOTALEGRESOS,
         PN_ACT_RESULTNETO,
         PN_ACT_RATIOPOSTCOVID,
         PN_ACT_EFECTIVO,
         PN_M12_INGRESOBRUTO,
         PN_M12_INGRESONETO,
         PN_M12_GASTOFAMILIAR,
         PN_M12_ENDEUDAMIENTO,
         PN_M12_TOTALEGRESOS,
         PN_M12_RESULTNETO,
         PN_M12_RATIOPOSTCOVID);
      COMMIT;
    END IF;
  
  END SP_CR_REPROG_LEY31050;

  Procedure SP_CR_BUSCAR_CONDONADOS(PV_USUARIO    IN CHAR,
                                    PV_DNI        IN CHAR,
                                    PV_NOMCLIENTE OUT VARCHAR2,
                                    --RESPUESTAS
                                    PV_CODERR OUT VARCHAR2,
                                    PV_DESERR OUT VARCHAR2) IS
  BEGIN
  
    PV_CODERR := '000';
    PV_DESERR := 'OK';
  
    BEGIN
      SELECT NOMCLIENTE
        INTO PV_NOMCLIENTE
        FROM LEY31050_FORM_DATA
       WHERE DNICLIENTE = PV_DNI
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        PV_NOMCLIENTE := '';
        PV_CODERR     := '001';
        PV_DESERR     := 'NO HAY NOMBRE CLIENTE.';
    END;
  
    DELETE FROM AQPA997 F
     WHERE F.AQPA997USU = PV_USUARIO
       AND F.AQPA997NDOC = PV_DNI;
    COMMIT;
  
    INSERT INTO AQPA997
      SELECT PV_USUARIO,
             F.EMPRESA,
             F.MODULO,
             F.SUCURSAL,
             F.MONEDA,
             F.PAPEL,
             SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) CUENTA,
             SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) OPERACION,
             F.SUBOPERACION,
             F.TIPOOPERACION,
             PV_DNI,
             PV_NOMCLIENTE
        FROM LEY31050_CREDITOSFACILIDAD F, LEY31050_CREDITOS C, FSD010 S
       WHERE F.CUENTAOPERACION = C.CUENTAOPERACION
         AND F.EMPRESA = C.EMPRESA
         AND F.SUCURSAL = C.SUCURSAL
         AND F.MODULO = C.MODULO
         AND F.MONEDA = C.MONEDA
         AND F.PAPEL = C.PAPEL
         AND F.SUBOPERACION = C.SUBOPERACION
         AND F.TIPOOPERACION = C.TIPOOPERACION
         AND S.PGCOD = F.EMPRESA
         AND S.AOMOD = F.MODULO
         AND S.AOSUC = F.SUCURSAL
         AND S.AOMDA = F.MONEDA
         AND S.AOPAP = F.PAPEL
         AND S.AOCTA =
             SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1)
         AND S.AOOPER = SUBSTR(F.CUENTAOPERACION,
                               INSTR(F.CUENTAOPERACION, '-') + 1,
                               99)
         AND S.AOSBOP = F.SUBOPERACION
         AND S.AOTOPE = F.TIPOOPERACION
         AND F.FACILIDAD like 'Condonac%'
         AND S.AOSTAT <> 99
         AND C.DNICLIENTE = PV_DNI;
    COMMIT;
  
    RETURN;
  END SP_CR_BUSCAR_CONDONADOS;
end PQ_CR_INFO_REPROG;
/

