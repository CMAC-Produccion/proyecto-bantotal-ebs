CREATE OR REPLACE PACKAGE PQ_CR_MEMO_17_18 IS
  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA HACER CONTROLES DEL PANEL DE BENEFICIOS PARA CRÉDITOS REFINANCIA CAJA HAQPD155 
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.01.27
  -- Autores de Creación        : HENRY SUAREZ, EDEHILTON NINA, MAYCOL CHAVEZ
  -- Uso                        : Realiza controles
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 2024.01.29
  -- Autor de la Modificación   : ENINAH
  -- Descripción de Modificación: Se modificó el procedimiento sp_cr_insertar_aqpd154 para que se inserte dos campos mas a la tabla AQPD154
  -- Fecha de Modificación      : 2024.01.30
  -- Autor de la Modificación   : HSUAREZ
  -- Descripción de Modificación: Se modificó el procedimiento sp_cr_insertar_aqpd154 para que por parametros
  --                              se guarde el monto capitalizado cambiado por el analista en caso sea el caso.
  -- *****************************************************************
  -----------------------------------------------------------------------
  PROCEDURE SP_CR_VALIDAR_CREDITO_VUELO(P_EMPRESA        IN NUMBER,
                                        P_MODULO         IN NUMBER,
                                        P_SUCURSAL       IN NUMBER,
                                        P_MONEDA         IN NUMBER,
                                        P_PAPEL          IN NUMBER,
                                        P_CUENTA         IN NUMBER,
                                        P_OPERACION      IN NUMBER,
                                        P_SUBOPERACION   IN NUMBER,
                                        P_TIPO_OPERACION IN NUMBER,
                                        P_BLOQUEO        OUT VARCHAR2);

  PROCEDURE SP_CR_EXCEPCION_REGLA_REFI(P_INSTANCIA IN NUMBER,
                                       P_RESPUESTA OUT VARCHAR2);

  procedure sp_cr_obtener_cargo(condicion  in number,
                                situacion  in number,
                                porcentaje in number,
                                instancia  in number,
                                cargo      out varchar2,
                                codcargo   out number);

  procedure sp_cr_insertar_aqpd154(emp        in number, --1
                                   modulo     in number, --2
                                   sucursal   in number, --3
                                   moneda     in number, --4
                                   papel      in number, --5
                                   cuenta     in number, --6
                                   operacion  in number, --7  -- Fecha de Modificación      : 2024.01.29
  -- Autor de la Modificación   : ENINAH
                                   subope     in number, --8
                                   tope       in number, --9
                                   anlreg     in varchar2, --10
                                   tasaori    in number, --11
                                   tasare     in number, --12
                                   pctjredu   in number, --13
                                   desfin     in number, --14
                                   capint     in number, --15
                                   capinana   in number, --16 HASL - 2024.01.30 
                                   cate       in varchar2, --17
                                   usrpa      in varchar2, --18
                                   usap2      in varchar2, --19
                                   estado     in varchar2, --20
                                   cod_cargo  in number, --21
                                   cod_cargo2 in number, --22
                                   por_desc   in number, --23
                                   msgerr     out varchar2); --24

  procedure sp_cr_validar_existencia(emp       in number, --1
                                     modulo    in number, --2
                                     sucursal  in number, --3
                                     moneda    in number, --4
                                     papel     in number, --5
                                     cuenta    in number, --6
                                     operacion in number, -- 7
                                     subope    in number, --8
                                     tope      in number,
                                     bloquear  out varchar2);

END PQ_CR_MEMO_17_18;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_MEMO_17_18 IS
  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA HACER CONTROLES DEL PANEL DE BENEFICIOS PARA CRÉDITOS REFINANCIA CAJA HAQPD155 
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.01.27
  -- Autores de Creación        : HENRY SUAREZ, EDEHILTON NINA, MAYCOL CHAVEZ
  -- Uso                        : Realiza controles
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 2024.01.29
  -- Autor de la Modificación   : ENINAH
  -- Descripción de Modificación: Se modificó el procedimiento sp_cr_insertar_aqpd154 para que se inserte dos campos mas a la tabla AQPD154
  --
  --
  -- *****************************************************************
  -----------------------------------------------------------------------

  PROCEDURE SP_CR_VALIDAR_CREDITO_VUELO(P_EMPRESA        IN NUMBER,
                                        P_MODULO         IN NUMBER,
                                        P_SUCURSAL       IN NUMBER,
                                        P_MONEDA         IN NUMBER,
                                        P_PAPEL          IN NUMBER,
                                        P_CUENTA         IN NUMBER,
                                        P_OPERACION      IN NUMBER,
                                        P_SUBOPERACION   IN NUMBER,
                                        P_TIPO_OPERACION IN NUMBER,
                                        P_BLOQUEO        OUT VARCHAR2) IS
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_VALIDAR_CREDITO_VUELO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : Maycol Chavez
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : Clave de Crédito
    --
    -- Retorno                    : Variable de bloqueo
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************
  
    CONTADOR NUMBER(17);
  BEGIN
    BEGIN
      SELECT COUNT(*)
        INTO CONTADOR
        FROM XWF700 A, WFWRKITEMS B
       WHERE A.XWFEMPRESA = P_EMPRESA
         AND A.XWFSUCURSAL = P_SUCURSAL
         AND A.XWFMODULO = P_MODULO
         AND A.XWFMONEDA = P_MONEDA
         AND A.XWFPAPEL = P_PAPEL
         AND A.XWFCUENTA = P_CUENTA
         AND A.XWFOPERACION = P_OPERACION
         AND A.XWFSUBOPE = P_SUBOPERACION
         AND A.XWFTIPOPE = P_TIPO_OPERACION
         AND A.XWFCAR3 <> '1'
         AND B.WFINSPRCID = A.XWFPRCINS
         AND B.WFITEMSTSACT = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    IF CONTADOR > 0 THEN
      P_BLOQUEO := 'S';
    ELSE
      P_BLOQUEO := 'N';
    END IF;
  END SP_CR_VALIDAR_CREDITO_VUELO;

  PROCEDURE SP_CR_EXCEPCION_REGLA_REFI(P_INSTANCIA IN NUMBER,
                                       P_RESPUESTA OUT VARCHAR2) IS
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_EXCEPCION_REGLA_REFI
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : Maycol Chavez
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_INSTANCIA
    --
    -- Retorno                    : P_RESPUESTA
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************
    FECHA_SISTEMA   DATE;
    FECHA_EXCEPCION DATE;
  BEGIN
    BEGIN
      SELECT PGFAPE INTO FECHA_SISTEMA FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        FECHA_SISTEMA := TO_DATE('01/01/0001', 'DD/MM/RRRR');
    END;
    BEGIN
      SELECT TO_DATE(TP1DESC, 'DD/MM/RRRR')
        INTO FECHA_EXCEPCION
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 111154
         AND TP1CORR1 = 1
         AND TP1CORR2 = 23
         AND TP1CORR3 > 0
         AND TP1NRO1 = P_INSTANCIA;
    EXCEPTION
      WHEN OTHERS THEN
        FECHA_EXCEPCION := TO_DATE('01/01/0001', 'DD/MM/RRRR');
    END;
    IF FECHA_EXCEPCION >= FECHA_SISTEMA THEN
      P_RESPUESTA := 'S';
    ELSE
      P_RESPUESTA := 'N';
    END IF;
  
  END SP_CR_EXCEPCION_REGLA_REFI;

  procedure sp_cr_obtener_cargo(condicion  in number,
                                situacion  in number,
                                porcentaje in number,
                                instancia  in number,
                                cargo      out varchar2,
                                codcargo   out number) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_obtener_cargo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : Edehilton Nina
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : condicion,situacion,porcentaje,instancia
    --
    -- Retorno                    : cargo,codcargo
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************
  
    desc_cargo    varchar2(30);
    cod_cargo     number(9);
    SALDOCAP      number(17, 2);
    cod_cargo_sc  number(9);
    desc_cargo_sc varchar2(30);
  begin
    DECLARE
      CURSOR mi_cursor IS
        select *
          from fst198 f
         where tp1cod = 1
           and tp1cod1 = 111154
           and tp1corr1 = 1
           and tp1corr2 = 22
           and tp1nro1 = condicion
           and tp1nro2 = situacion;
    begin
      ---OBTENER SALDO CAPITAL
      BEGIN
        SELECT abs(F.SCSDO)
          INTO SALDOCAP
          FROM FSD011 F, XWF700 X
         WHERE X.XWFPRCINS = instancia
           AND x.XWFCAR3 = '1'
           AND X.XWFEMPRESA = F.PGCOD
           AND X.XWFSUCURSAL = F.SCSUC
           AND X.XWFMODULO = F.SCMOD
           AND X.XWFMONEDA = F.SCMDA
           AND X.XWFPAPEL = F.SCPAP
           AND X.XWFCUENTA = F.SCCTA
           AND X.XWFOPERACION = F.SCOPER
           AND X.XWFSUBOPE = F.SCSBOP
           AND X.XWFTIPOPE = F.SCTOPE;
      EXCEPTION
        WHEN OTHERS THEN
          SALDOCAP := 0;
      END;
      --OBTENER APROBADO SEGUN GUIA.
      BEGIN
        select tp1nro1, tp1desc
          into cod_cargo_sc, desc_cargo_sc
          from fst198 f
         where tp1cod = 1
           and tp1cod1 = 111154
           and tp1corr1 = 1
           and tp1corr2 = 24
           and tp1imp1 <= SALDOCAP
           and tp1imp2 >= SALDOCAP;
      EXCEPTION
        WHEN OTHERS THEN
          cod_cargo_sc := 0;
      END;
      FOR V_FILA in mi_cursor LOOP
        if porcentaje <= V_FILA.TP1IMP1 then
          desc_cargo := V_FILA.TP1DESC;
          cod_cargo  := V_FILA.TP1NRO3;
          exit;
        else
          continue;
        end if;
      END LOOP;
      /*Agregado para validar el mayor rango para los créditos exonerados*/
      if desc_cargo is null and cod_cargo is null then
        desc_cargo := 'GCRE01';
        cod_cargo  := 230;
      end if;
      cargo    := trim(desc_cargo);
      codcargo := cod_cargo;
      IF SALDOCAP > 0 AND cod_cargo_sc > codcargo THEN
        codcargo := cod_cargo_sc;
        cargo    := trim(desc_cargo_sc);
      Else
        IF COD_CARGO_SC = CODCARGO THEN
          IF TRIM(desc_cargo_sc) <> TRIM(desc_cargo) THEN
            IF TRIM(desc_cargo_sc) <> 'GREG01' THEN
              cargo := desc_cargo;
            ELSE
              cargo := desc_cargo_sc;
            END IF;
          END IF;
        END IF;
      End If;
    end;
  end sp_cr_obtener_cargo;

  procedure sp_cr_insertar_aqpd154(emp        in number, --1
                                   modulo     in number, --2
                                   sucursal   in number, --3
                                   moneda     in number, --4
                                   papel      in number, --5
                                   cuenta     in number, --6
                                   operacion  in number, --7  -- Fecha de Modificación      : 2024.01.29
                                   subope     in number, --8
                                   tope       in number, --9
                                   anlreg     in varchar2, --10
                                   tasaori    in number, --11
                                   tasare     in number, --12
                                   pctjredu   in number, --13
                                   desfin     in number, --14
                                   capint     in number, --15
                                   capinana   in number, --16 HASL - 2024.01.30 
                                   cate       in varchar2, --17
                                   usrpa      in varchar2, --18
                                   usap2      in varchar2, --19
                                   estado     in varchar2, --20
                                   cod_cargo  in number, --21
                                   cod_cargo2 in number, --22
                                   por_desc   in number, --23
                                   msgerr     out varchar2)
   is
   
    -- *****************************************************************
    -- Nombre                     : sp_cr_insertar_aqpd154
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : Edehilton Nina
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : Clave de crédito, porcentaje de reduccion y descuento, usuarios aprobadores
    --
    -- Retorno                    : msgerr
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************
    vi_cambio varchar(1) := 'N';
    vi_usrcmb varchar(10):='-';
    contador number := 0;
    vi_msg varchar(250);
  begin
    /*
    begin
      insert into prueba_log
        (msg, pgcod)
      values
        ((emp || '-' || modulo || '-' || sucursal || '-' || moneda || '-' ||
         papel || '-' || cuenta || '-' || operacion || '-' || subope || '-' || tope || '-' ||
         anlreg || '-' || tasaori || '-' || tasare || '-' || pctjredu || '-' ||
         desfin || '-' || capint || '-' || cate || '-' || usrpa || '-' ||
         usap2 || '-' || estado || '-' || capinana ),
         250);
      commit;
    end;
    */
      IF capint <> capinana THEN
         vi_cambio := 'S';
         vi_usrcmb := anlreg;
      ELSE
         vi_cambio := 'N';   
      END IF;
    begin
      select count(cuenta)
        into contador
        from aqpd154 d
       where d.aqpd154emp = emp
         and d.aqpd154mod = modulo
         and d.aqpd154suc = sucursal
         and d.aqpd154mda = moneda
         and d.aqpd154pap = papel
         and d.aqpd154cta = cuenta
         and d.aqpd154ope = operacion
         and d.aqpd154sbop = subope
         and d.aqpd154tope = tope
         and d.aqpd154estreg = 'P';
    
      -- insert into prueba_log(pgcod,msg)
      -- values
      --  (350,'Contador -'||contador);
      --commit;
    
    exception
      when others then
        null;
    end;
  
    If contador > 0 then
      begin
        update AQPD154 d
           set AQPD154PREDU  = pctjredu,
               AQPD154TREDU  = tasare,
               AQPD154USRPA  = usrpa,
               AQPD154PRDESC = por_desc,
               AQPD154DESFIN = desfin,
               AQPD154USAP2  = usap2,
               AQPD154CODUS1 = cod_cargo,
               AQPD154CODUS2 = cod_cargo2,
               aqpd154fecmod = TO_DATE(SYSDATE, 'DD/MM/RRRR'),
               aqpc154hormod = to_char(SYSDATE, 'HH24:MI:SS'),
               aqpc154usrmod = vi_usrcmb,
               aqpd154capint = capinana,
               aqpd154mntcpe = vi_cambio
         where d.aqpd154emp = emp
           and d.aqpd154mod = modulo
           and d.aqpd154suc = sucursal
           and d.aqpd154mda = moneda
           and d.aqpd154pap = papel
           and d.aqpd154cta = cuenta
           and d.aqpd154ope = operacion
           and d.aqpd154sbop = subope
           and d.aqpd154tope = tope
           and d.aqpd154estreg = 'P';
        commit;
        msgerr := 'El crédito fue procesado con éxito.';
      exception
        when others then
          vi_msg := substr(sqlerrm,1,100);
          msgerr :=  vi_msg;
      end;
    else
      begin
        insert into aqpd154 a
          (a.aqpd154emp,
           a.aqpd154mod,
           a.aqpd154suc,
           a.aqpd154mda,
           a.aqpd154pap,
           a.aqpd154cta,
           a.aqpd154ope,
           a.aqpd154sbop,
           a.aqpd154tope,
           a.aqpd154anlreg,
           a.aqpd154tasact,
           a.aqpd154tredu,
           a.aqpd154predu,
           a.aqpd154desfin,
           a.aqpd154capint,
           a.aqpd154prdesc,
           a.aqpd154cate,
           a.aqpd154usrpa,
           a.aqpd154usap2,
           a.aqpd154codus1,
           a.aqpd154codus2,
           a.aqpd154estreg,
           a.aqpd154fec,
           a.aqpc154hor,
           aqpd154mntcpe
           )
        values
          (emp,
           modulo,
           sucursal,
           moneda,
           papel,
           cuenta,
           operacion,
           subope,
           tope,
           anlreg,
           tasaori,
           tasare,
           pctjredu,
           desfin,
           capinana,
           por_desc,
           cate,
           usrpa,
           usap2,
           cod_cargo,
           cod_cargo2,
           estado,
           TO_DATE(SYSDATE, 'DD/MM/RRRR'),
           to_char(SYSDATE, 'HH24:MI:SS'),
           vi_cambio
           );
        commit;
        msgerr := 'El crédito fue procesado con éxito.';
      exception
        when others then
          vi_msg := substr(sqlerrm,1,100);
          /*insert into prueba_log(msg,pgcod)values(vi_msg,250);
          commit;*/
          msgerr :=  vi_msg;
      end;
    End If;  
  end sp_cr_insertar_aqpd154;

  procedure sp_cr_validar_existencia(emp       in number, --1
                                     modulo    in number, --2
                                     sucursal  in number, --3
                                     moneda    in number, --4
                                     papel     in number, --5
                                     cuenta    in number, --6
                                     operacion in number, -- 7
                                     subope    in number, --8
                                     tope      in number,
                                     bloquear  out varchar2) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_validar_existencia
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : Edehilton Nina
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : Clave de crédito
    --
    -- Retorno                    : bloquear
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************
  
    contador number := 0;
  
  begin
    begin
      select count(a.aqpd154ope)
        into contador
        from aqpd154 a
       where a.aqpd154emp = emp
         and a.aqpd154mod = modulo
         and a.aqpd154suc = sucursal
         and a.aqpd154mda = moneda
         and a.aqpd154pap = papel
         and a.aqpd154cta = cuenta
         and a.aqpd154ope = operacion
         and a.aqpd154sbop = subope
         and a.aqpd154tope = tope
         and a.aqpd154estreg = 'C';
    exception
      when others then
        null;
    end;
  
    if contador > 0 then
      bloquear := 'S';
    else
      bloquear := 'N';
    End If;
  end sp_cr_validar_existencia;

END PQ_CR_MEMO_17_18;
/

