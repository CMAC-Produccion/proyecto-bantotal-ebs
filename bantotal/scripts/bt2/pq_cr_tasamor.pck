create or replace package PQ_CR_TASAMOR is

    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.02.27 15:56:10
    -- Autor de Creación          : ENINAH
    -- Uso                        : Este paquete devuelde la tasa moratoria del credito original no del actual
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : HSUAREZ
    -- Descripción de Modificación: DEVOLVER TASAS
    -- Fecha de Modificación      : 2024.06.13
    -- Autor de la Modificación   : ENINAH
    -- Descripción de Modificación: Se modificó el procedimiento devolver_tasamor que se muestre en el mensaje TMNM en vez de TEA
    -- *****************************************************************
    
  procedure sp_cr_devolver_tasamor(VE_INSTANCIA in number,
                                   VE_TASAMOR   out varchar2,
                                   VE_TEAMOR    out varchar2);

  PROCEDURE sp_cr_devolver_mora(vPEPAIS    in number,
                                vPETDOC    in number,
                                vPENDOC    in varchar,
                                SC_RUB     out varchar,
                                vCod_Error out varchar,
                                vMsg_Error out varchar);

  procedure sp_cr_devolver_tasamor_pren(vPGCOD  in number,
                                        vITSUCD in number,
                                        vMODULO in number,
                                        vMONEDA in number,
                                        vPAPEL  in number,
                                        vCTNRO  in number,
                                        vITOPER in number,
                                        vITSUBO in number,
                                        vITTOPE in number,
                                        TASAMOR out varchar2,
                                        TEAMOR  out varchar2);

  PROCEDURE VALIDAR_TASA_FSD012(VE_EMP     NUMBER,
                                VE_SUC     NUMBER,
                                VE_MOD     NUMBER,
                                VE_MDA     NUMBER,
                                VE_PAP     NUMBER,
                                VE_CTA     NUMBER,
                                VE_OPE     NUMBER,
                                VE_SBO     NUMBER,
                                VE_TOP     NUMBER,
                                VO_TASAMOR out varchar2,
                                VO_TEAMOR  out varchar2);

  PROCEDURE sp_cr_tasa_limite(Ppgcod   in number,
                              Pitsuc   in number,
                              Pitmod   in number,
                              PIttran  in number,
                              Pitnrel  in number,
                              PItfvto  in date,
                              vLote    in number,
                              vMensaje out varchar2);
end PQ_CR_TASAMOR;
/

create or replace package body PQ_CR_TASAMOR is

    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.02.27 15:56:10
    -- Autor de Creación          : ENINAH
    -- Uso                        : Este paquete devuelde la tasa moratoria del credito original no del actual
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : HSUAREZ
    -- Descripción de Modificación: DEVOLVER TASAS
    -- Fecha de Modificación      : 2024.06.13
    -- Autor de la Modificación   : ENINAH
    -- Descripción de Modificación: Se modificó el procedimiento devolver_tasamor que se muestre en el mensaje TMNM en vez de TEA
    -- *****************************************************************
    
  /*
  FSD012 BUSCAR LA TASA MORATORIA ORIGINA EN LA FSD012 SI HAY EVTTAS 1 Y 2 TOMAS EL MENOR DE LA 2,
  SI NO HAY EVTTAS = 2 TOMAS LA MENOR DE LA 1.  EVTASA 
  SI NO HAY REGISTROS EN LA FSD012 TOMAS DE LA FSD010. AOTMOR
  
  */
  procedure sp_cr_devolver_tasamor(VE_INSTANCIA in number,
                                   VE_TASAMOR   out varchar2,
                                   VE_TEAMOR    out varchar2) is
  
    VI_EMP  XWF700.XWFEMPRESA%TYPE;
    VI_SUC  XWF700.XWFSUCURSAL%TYPE;
    VI_MOD  XWF700.XWFMODULO%TYPE;
    VI_MDA  XWF700.XWFMONEDA%TYPE;
    VI_PAP  XWF700.XWFPAPEL%TYPE;
    VI_CTA  XWF700.XWFCUENTA%TYPE;
    VI_OPE  XWF700.XWFOPERACION%TYPE;
    VI_SBO  XWF700.XWFSUBOPE%TYPE;
    VI_TOP  XWF700.XWFTIPOPE%TYPE;
    VI_MORA X054021.XLLOTEXTO%TYPE;
  
  BEGIN
    --OBTENER CLAVE DEL CRÉDITO.
    BEGIN
      SELECT X.XWFEMPRESA,
             X.XWFSUCURSAL,
             X.XWFMODULO,
             X.XWFMONEDA,
             X.XWFPAPEL,
             X.XWFCUENTA,
             X.XWFOPERACION,
             X.XWFSUBOPE,
             X.XWFTIPOPE
        INTO VI_EMP,
             VI_SUC,
             VI_MOD,
             VI_MDA,
             VI_PAP,
             VI_CTA,
             VI_OPE,
             VI_SBO,
             VI_TOP
        FROM XWF700 X
       WHERE X.XWFPRCINS = VE_INSTANCIA
         AND X.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --VALIDAR SI TIENE MORA.
    BEGIN
      SELECT X.XLLOTEXTO
        INTO VI_MORA
        FROM X054021 X
       WHERE X.PGCOD = VI_EMP
         AND X.XLLOAOMOD = VI_MOD
         AND X.XLLOAOSUC = VI_SUC
         AND X.XLLOAOMDA = VI_MDA
         AND X.XLLOAOPAP = VI_PAP
         AND X.XLLOAOCTA = VI_CTA
         AND X.XLLOAOOPER = VI_OPE
         AND X.XLLOAOSBOP = VI_SBO
         AND X.XLLOAOTOPE = VI_TOP
         AND X.XLLOTXTCOD = 250
         AND X.XLLOTEXTO = 'I';
    EXCEPTION
      WHEN OTHERS THEN
        VI_MORA := '-';
    END;
    IF VI_MORA = 'I' THEN
      --VALIDAR LA MORA QUE TENIA EL CREDITO ORIGINAL, VALIDAR SI EXISTE EN LA FSD012
      --VALIDAR EN LA FSD012, PRIMERO SI EXISTE EL EVTTAS 2 EN CASO EXISTA BUSCAR LA MINIMA SUBOPERACION Y MINIMO CORRELATIVO DE LA SUBOPERACION.
      VE_TASAMOR := 0;
      --VALIDAR EN CASO NO EXISTA EN LA FSD012 CON EVTASS = 2 BUSCAR CON EVTASS = 1, BUSCAR LA MINIMA SUBOPERACION Y MINIMO CORRELATIVO DE LA SUBOPERACION.
      PQ_CR_TASAMOR.VALIDAR_TASA_FSD012(VI_EMP,
                                        VI_SUC,
                                        VI_MOD,
                                        VI_MDA,
                                        VI_PAP,
                                        VI_CTA,
                                        VI_OPE,
                                        VI_SBO,
                                        VI_TOP,
                                        VE_TASAMOR,
                                        VE_TEAMOR);
      --VALIDAR EN CASO NO EXISTA EN LA FSD012 OBTENER DE LA FSD010
      IF VE_TASAMOR = 0 THEN
        BEGIN
          SELECT to_char(FD.AOTMOR),
                 'Tasa Moratoria Nominal Máxima (TMNM) ' || FD.AOTMOR || ' %'
            into VE_TASAMOR, VE_TEAMOR
            FROM FSD010 FD
           WHERE FD.PGCOD = VI_EMP
                --AND FD.AOSUC  = VI_SUC
             AND FD.AOMOD = VI_MOD
             AND FD.AOMDA = VI_MDA
             AND FD.AOPAP = VI_PAP
             AND FD.AOCTA = VI_CTA
             AND FD.AOOPER = VI_OPE
             AND FD.AOSBOP = (SELECT MIN(F.AOSBOP)
                                FROM FSD010 F
                               WHERE F.PGCOD = VI_EMP --AQUI DEFINIMOS QUE SEA LA SUBOPERACION MINIMA
                                    --AND F.AOSUC    = VI_SUC
                                 AND F.AOMOD = VI_MOD
                                 AND F.AOMDA = VI_MDA
                                 AND F.AOPAP = VI_PAP
                                 AND F.AOCTA = VI_CTA
                                 AND F.AOOPER = VI_OPE
                                 AND F.AOTOPE = VI_TOP
                              
                              )
             AND FD.AOTOPE = VI_TOP;
        EXCEPTION
          WHEN OTHERS THEN
            VE_TASAMOR := 0;
        END;
      END IF;
    END IF;
    IF VE_TASAMOR = 0 then
      SELECT '0.00', 'Tasa Moratoria Máxima (*)'
        into VE_TASAMOR, VE_TEAMOR
        FROM DUAL;
    END IF;
  end sp_cr_devolver_tasamor;

  PROCEDURE sp_cr_devolver_mora(vPEPAIS    in number,
                                vPETDOC    in number,
                                vPENDOC    in varchar,
                                SC_RUB     out varchar,
                                vCod_Error out varchar,
                                vMsg_Error out varchar) is
  
    CURSOR list_ctn(viPepais number, viPetdoc number, viPendoc char) IS
      SELECT *
        FROM fsr008
       WHERE PEPAIS = viPepais
         AND PETDOC = viPetdoc
         AND PENDOC = viPendoc
         AND TTCOD = 1
         AND CTTFIR = 'T';
  
    cont     number := 0;
    vvpendoc fsr008.pendoc%type;
  BEGIN
    vvpendoc := vpendoc;
    for x in list_ctn(vpepais, vpetdoc, vvpendoc) loop
      select count(*)
        into cont
        from fsd011 d
       where d.pgcod = 1
         and d.sccta = x.ctnro
         and d.scmod in (select f.modulo
                           from fst111 f
                          where f.dscod = 50
                            and f.modulo > 99
                            and f.modulo < 200)
         and (SUBSTR(d.scrub, 1, 4) IN ('1415'));
    
      if cont > 0 then
        SC_RUB := 'S';
        exit;
      else
        SC_RUB := 'N';
      end if;
    end loop;
  end sp_cr_devolver_mora;

  procedure sp_cr_devolver_tasamor_pren(vPGCOD  in number,
                                        vITSUCD in number,
                                        vMODULO in number,
                                        vMONEDA in number,
                                        vPAPEL  in number,
                                        vCTNRO  in number,
                                        vITOPER in number,
                                        vITSUBO in number,
                                        vITTOPE in number,
                                        TASAMOR out varchar2,
                                        TEAMOR  out varchar2) is
  
  begin
  
    begin
      SELECT to_char(F.AOTMOR),
             'Tasa Moratoria Nominal Máxima (TMNM) ' || F.AOTMOR || '%'
        into TASAMOR, TEAMOR
        FROM FSD010 F, X054021 XX
       WHERE XX.PGCOD = F.PGCOD
         AND XX.XLLOAOSUC = F.AOSUC
         AND XX.XLLOAOMOD = F.AOMOD
         AND XX.XLLOAOMDA = F.AOMDA
         AND XX.XLLOAOPAP = F.AOPAP
         AND XX.XLLOAOCTA = F.AOCTA
         AND XX.XLLOAOOPER = F.AOOPER
         AND XX.XLLOAOSBOP = F.AOSBOP
         AND XX.XLLOAOTOPE = F.AOTOPE
         AND XX.PGCOD = vPGCOD
         AND XX.XLLOAOSUC = vITSUCD
         AND XX.XLLOAOMOD = vMODULO
         AND XX.XLLOAOMDA = vMONEDA
         AND XX.XLLOAOPAP = vPAPEL
         AND XX.XLLOAOCTA = vCTNRO
         AND XX.XLLOAOOPER = vITOPER
         AND XX.XLLOAOSBOP = vITSUBO
         AND XX.XLLOAOTOPE = vITTOPE
         AND XX.XLLOTXTCOD = 250
         AND XX.XLLOTEXTO = 'I';
    exception
      when others then
        TASAMOR := 0;
    end;
    if TASAMOR < 1 then
      begin
        SELECT to_char(F.EVTASA),
               'Tasa Moratoria Nominal Máxima (TEA) ' || F.EVTASA || '%'
          into TASAMOR, TEAMOR
          FROM FSD012 F, X054021 XX
         WHERE XX.PGCOD = F.PGCOD
           AND XX.XLLOAOSUC = F.AOSUC
           AND XX.XLLOAOMOD = F.AOMOD
           AND XX.XLLOAOMDA = F.AOMDA
           AND XX.XLLOAOPAP = F.AOPAP
           AND XX.XLLOAOCTA = F.AOCTA
           AND XX.XLLOAOOPER = F.AOOPER
           AND XX.XLLOAOSBOP = F.AOSBOP
           AND XX.XLLOAOTOPE = F.AOTOPE
           AND XX.PGCOD = vPGCOD
           AND XX.XLLOAOSUC = vITSUCD
           AND XX.XLLOAOMOD = vMODULO
           AND XX.XLLOAOMDA = vMONEDA
           AND XX.XLLOAOPAP = vPAPEL
           AND XX.XLLOAOCTA = vCTNRO
           AND XX.XLLOAOOPER = vITOPER
           AND XX.XLLOAOSBOP = vITSUBO
           AND XX.XLLOAOTOPE = vITTOPE
           AND XX.XLLOTXTCOD = 250
           AND XX.XLLOTEXTO = 'I'
           AND F.Evtipo = 4
           AND F.D012co = 'S'
           AND F.EVCORR = (select min(F.EVCORR)
                             FROM FSD012 F, X054021 XX
                            WHERE XX.PGCOD = F.PGCOD
                              AND XX.XLLOAOSUC = F.AOSUC
                              AND XX.XLLOAOMOD = F.AOMOD
                              AND XX.XLLOAOMDA = F.AOMDA
                              AND XX.XLLOAOPAP = F.AOPAP
                              AND XX.XLLOAOCTA = F.AOCTA
                              AND XX.XLLOAOOPER = F.AOOPER
                              AND XX.XLLOAOSBOP = F.AOSBOP
                              AND XX.XLLOAOTOPE = F.AOTOPE
                              AND XX.PGCOD = vPGCOD
                              AND XX.XLLOAOSUC = vITSUCD
                              AND XX.XLLOAOMOD = vMODULO
                              AND XX.XLLOAOMDA = vMONEDA
                              AND XX.XLLOAOPAP = vPAPEL
                              AND XX.XLLOAOCTA = vCTNRO
                              AND XX.XLLOAOOPER = vITOPER
                              AND XX.XLLOAOSBOP = vITSUBO
                              AND XX.XLLOAOTOPE = vITTOPE
                              AND XX.XLLOTXTCOD = 250
                              AND XX.XLLOTEXTO = 'I'
                              AND F.Evtipo = 4
                              AND F.D012co = 'S');
      exception
        when others then
          TASAMOR := 0;
      end;
    end if;
  
    if TASAMOR = 0 then
      SELECT '0.00', 'Tasa Moratoria Máxima (*)'
        into TASAMOR, TEAMOR
        FROM DUAL;
    end if;
  
  end sp_cr_devolver_tasamor_pren;
  PROCEDURE VALIDAR_TASA_FSD012(VE_EMP     NUMBER,
                                VE_SUC     NUMBER,
                                VE_MOD     NUMBER,
                                VE_MDA     NUMBER,
                                VE_PAP     NUMBER,
                                VE_CTA     NUMBER,
                                VE_OPE     NUMBER,
                                VE_SBO     NUMBER,
                                VE_TOP     NUMBER,
                                VO_TASAMOR out varchar2,
                                VO_TEAMOR  out varchar2) IS
  BEGIN
    VO_TASAMOR := 0;
    BEGIN
      SELECT to_char(FD.Evtasa),
             'Tasa Moratoria Nominal Máxima (TMNM) ' || FD.Evtasa || ' %'
        INTO VO_TASAMOR, VO_TEAMOR
        FROM FSD012 FD
       WHERE FD.PGCOD = VE_EMP
            --AND FD.AOSUC = VE_SUC
         AND FD.AOMOD = VE_MOD
         AND FD.AOMDA = VE_MDA
         AND FD.AOPAP = VE_PAP
         AND FD.AOCTA = VE_CTA
         AND FD.AOOPER = VE_OPE
         AND FD.AOSBOP = (SELECT MIN(F.AOSBOP)
                            FROM FSD012 F
                           WHERE F.PGCOD = VE_EMP --AQUI DEFINIMOS QUE SEA LA SUBOPERACION MINIMA
                                --AND F.AOSUC = VE_SUC
                             AND F.AOMOD = VE_MOD
                             AND F.AOMDA = VE_MDA
                             AND F.AOPAP = VE_PAP
                             AND F.AOCTA = VE_CTA
                             AND F.AOOPER = VE_OPE
                             AND F.AOTOPE = VE_TOP
                             AND F.Evtipo = 4
                             AND F.D012co = 'S'
                             AND F.EVTTAS = 2)
         AND FD.AOTOPE = VE_TOP
         AND FD.EVCORR = (SELECT MIN(F.EVCORR)
                            FROM FSD012 F
                           WHERE F.PGCOD = VE_EMP
                                --AND F.AOSUC = VE_SUC
                             AND F.AOMOD = VE_MOD
                             AND F.AOMDA = VE_MDA
                             AND F.AOPAP = VE_PAP
                             AND F.AOCTA = VE_CTA
                             AND F.AOOPER = VE_OPE
                             AND F.AOSBOP = FD.AOSBOP --AQUI COLOCAMOS LA SUBOPERACION MINIMA
                             AND F.AOTOPE = VE_TOP
                             AND F.Evtipo = 4
                             AND F.D012co = 'S'
                             AND F.EVTTAS = 2
                          
                          )
         AND FD.Evtipo = 4
         AND FD.D012co = 'S'
         AND FD.EVTTAS = 2;
    EXCEPTION
      WHEN OTHERS THEN
        VO_TASAMOR := 0;
    END;
    --VALIDAR EN CASO NO EXISTA EN LA FSD012 CON EVTASS = 2 BUSCAR CON EVTASS = 1, BUSCAR LA MINIMA SUBOPERACION Y MINIMO CORRELATIVO DE LA SUBOPERACION.
    IF VO_TASAMOR = 0 THEN
      BEGIN
        SELECT to_char(FD.Evtasa),
               'Tasa Moratoria Nominal Máxima (TMNM) ' || FD.Evtasa || ' %'
          INTO VO_TASAMOR, VO_TEAMOR
          FROM FSD012 FD
         WHERE FD.PGCOD = VE_EMP
              --AND FD.AOSUC = VE_SUC
           AND FD.AOMOD = VE_MOD
           AND FD.AOMDA = VE_MDA
           AND FD.AOPAP = VE_PAP
           AND FD.AOCTA = VE_CTA
           AND FD.AOOPER = VE_OPE
           AND FD.AOSBOP = (SELECT MIN(F.AOSBOP)
                              FROM FSD012 F
                             WHERE F.PGCOD = VE_EMP --AQUI DEFINIMOS QUE SEA LA SUBOPERACION MINIMA
                                  --AND F.AOSUC = VE_SUC
                               AND F.AOMOD = VE_MOD
                               AND F.AOMDA = VE_MDA
                               AND F.AOPAP = VE_PAP
                               AND F.AOCTA = VE_CTA
                               AND F.AOOPER = VE_OPE
                               AND F.AOTOPE = VE_TOP
                               AND F.Evtipo = 4
                               AND F.D012co = 'S'
                               AND F.EVTTAS = 1)
           AND FD.AOTOPE = VE_TOP
           AND FD.EVCORR = (SELECT MIN(F.EVCORR)
                              FROM FSD012 F
                             WHERE F.PGCOD = VE_EMP
                                  --AND F.AOSUC = VE_SUC
                               AND F.AOMOD = VE_MOD
                               AND F.AOMDA = VE_MDA
                               AND F.AOPAP = VE_PAP
                               AND F.AOCTA = VE_CTA
                               AND F.AOOPER = VE_OPE
                               AND F.AOSBOP = FD.AOSBOP --AQUI COLOCAMOS LA SUBOPERACION MINIMA
                               AND F.AOTOPE = VE_TOP
                               AND F.Evtipo = 4
                               AND F.D012co = 'S'
                               AND F.EVTTAS = 1
                            
                            )
           AND FD.Evtipo = 4
           AND FD.D012co = 'S'
           AND FD.EVTTAS = 1;
      EXCEPTION
        WHEN OTHERS THEN
          VO_TASAMOR := 0;
      END;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE sp_cr_tasa_limite(Ppgcod   in number,
                              Pitsuc   in number,
                              Pitmod   in number,
                              PIttran  in number,
                              Pitnrel  in number,
                              PItfvto  in date,
                              vLote    in number,
                              vMensaje out varchar2) IS
    --tasa_actual varchar;
    tasa_actual fsr025.TATASA%TYPE;
    tasa_guia   fst198.TP1IMP1%TYPE;
    CODIGO      FSD016.PGCOD%TYPE;
    MODULO      FSD016.MODULO%TYPE;
    MONEDA      FSD016.MONEDA%TYPE;
    PAPEL       FSD016.PAPEL%TYPE;
  BEGIN
    BEGIN
      SELECT F.MODULO, F.MONEDA, F.PAPEL
        INTO MODULO, MONEDA, PAPEL
        FROM FSD016 F
       WHERE F.PGCOD = Ppgcod
         AND F.ITSUC = Pitsuc
         and F.ITMOD = Pitmod
         and F.ITTRAN = PIttran
         and F.ITNREL = Pitnrel
         and F.ITORD = 10;
    exception
      when others then
        null;
    END;
    BEGIN
      select distinct F.TATASA
        into tasa_actual
        from fsr025 f --, fpp175 p
       where f.tpizar = 80
            --AND TAMOD = 108 --01/05/2022
         and f.tafdes = (select max(tafdes)
                           from fsr025, fpp175 p
                          where tpizar = 80
                            and f.tamod = MODULO
                            and f.tamda = MONEDA
                            and f.tapap = PAPEL)
         and f.tamod = MODULO
         and f.tamda = MONEDA
         and f.tapap = PAPEL;
      --and p.pp174cod = vLote;
    exception
      when others then
        null;
    END;
    BEGIN
      SELECT DISTINCT FF.TP1IMP1
        into tasa_guia
        FROM FST198 FF --, FPP175 P
       WHERE FF.TP1COD1 = 11156
         AND FF.TP1CORR1 = 11
         AND FF.TP1CORR2 = 1
         AND FF.TP1CORR3 > 0
            --AND P.PP173COD = 1
         AND FF.TP1NRO1 = MONEDA;
    exception
      when others then
        null;
    END;
    --CON LA TASA ACTUAL Y LA TASA MORATORIA LIMTE DE GUIA
    --HACER LO SIGUIENTE: VALIDAR QUE LA TASA ACTUAL SEA MENOR QUE LA TASA MORATORIA POR GUIA
    --SI ES MAYOR BLOQUEAR, CASO CONTRARIO DEBE CONTINUAR EL FLUJO.
    -- Mensaje : La tasa del credito es mayor a la tasa limite del credito segun norma SBS .
    if (tasa_actual < tasa_guia) then
      vMensaje := '';
    else
      vMensaje := 'La tasa del credito es mayor a la tasa límite del crédito según norma SBS.';
    end if;
  
    begin
      insert into AQPC584
        (AQPC584Ppgcod,
         AQPC584Pitsuc,
         AQPC584Pitmod,
         AQPC584PIttran,
         AQPC584Pitnrel,
         AQPC584PItfvto,
         AQPC584Lote,
         AQPC584tasact,
         AQPC584tasguia,
         AQPC584FECH)
      values
        (Ppgcod,
         Pitsuc,
         Pitmod,
         PIttran,
         Pitnrel,
         PItfvto,
         vLote,
         tasa_actual,
         tasa_guia,
         sysdate);
      commit;
    end;
  END sp_cr_tasa_limite;

end PQ_CR_TASAMOR;
/

