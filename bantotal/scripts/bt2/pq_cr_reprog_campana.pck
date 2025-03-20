create or replace package PQ_CR_REPROG_CAMPANA is

  -- Author  : IGS_MCORDOVA
  -- Created : 22/03/2022 17:37:43
  -- Purpose : Valida si credito esta vinculado y existe en tabla BI 
  PROCEDURE SP_CR_VALIDA_EXISTENCIA_CREDITO (P_N_INS IN NUMBER, P_C_FLA OUT VARCHAR2);
  
  -- Author  : IGS_MCORDOVA
  -- Created : 22/03/2022 17:37:43
  -- Purpose : Valida campo de tabla AQPB456
  PROCEDURE SP_CR_OBTIENE_AQPB456IND (P_N_INS IN NUMBER, P_C_FLA OUT VARCHAR2);
  
  -- Author  : IGS_MCORDOVA
  -- Created : 22/03/2022 17:37:43
  -- Purpose : Valida que no tenga créditos vigentes de campaña y este vinculado (Reprogramados II)
  PROCEDURE SP_CR_OBTIENE_AQPC263 (INS IN NUMBER, FLAGX OUT VARCHAR2);
  
  -- Author  : IGS_MCORDOVA
  -- Created : 22/03/2022 17:37:43
  -- Purpose : Valida que no tenga créditos vigente de campaña (Reprogramados II)
  PROCEDURE SP_CR_OBTIENE_AQPC264(INS IN NUMBER, FLAGX OUT VARCHAR2);
 
  -- Author  : HSUAREZ
  -- Created : 22/03/2022 17:37:43
  -- Purpose : Carga de Pizarra para Fondo Crecer (Complemento JOBS)
  procedure sp_cr_PizaFCRECER(lc_digito in varchar2);
   
  -- Author  : HSUAREZ
  -- Created : 22/03/2022 17:37:43
  -- Purpose : Carga de Pizarra para Fondo Crecer (JOBS)
  Procedure sp_cr_Job_PizasFCRECER;
    
  -- Author  : HSUAREZ
  -- Created : 22/03/2022 17:37:43
  -- Purpose : Carga de Pizarra para PAE MYPE  (JOBS)
  procedure sp_cr_PizaPaePyme(lc_digito in varchar2);
  
  -- Author  : HSUAREZ
  -- Created : 22/03/2022 17:37:43
  -- Purpose : Carga de Pizarra para PAE MYPE (Complemento JOBS)
  Procedure sp_cr_Job_PizaPaePyme;
   
end PQ_CR_REPROG_CAMPANA;
/

create or replace package body PQ_CR_REPROG_CAMPANA is

  PROCEDURE SP_CR_VALIDA_EXISTENCIA_CREDITO (
  P_N_INS IN NUMBER,
  P_C_FLA OUT VARCHAR2)
  IS
  -- *****************************************************************
  -- Nombre                     : SP_CR_VALIDA_EXISTENCIA_CREDITO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.03.25
  -- Autor de Creación          : Milton Fernando Cordova Herrera
  -- Uso                        : Valida si credito esta vinculado y existe en tabla BI
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_N_INS ( Instancia )
  -- Parámetros de Salida       : P_C_FLA ( Flag )
  -- Fecha de Modificación      : --
  -- Autor de la Modificación   : --
  -- Descripción de Modificación: --
  -- ***************************************************************** 
  P_N_EMP NUMBER(3);
  P_N_MOD NUMBER(3);
  P_N_SUC NUMBER(3);
  P_N_MDA NUMBER(4);
  P_N_PAP NUMBER(4);
  P_N_CTA NUMBER(9);
  P_N_OPE NUMBER(9);
  P_N_SBO NUMBER(3);
  P_N_TOP NUMBER(3);
  BEGIN
    BEGIN
      SELECT jaqy800pgcd, jaqy800mod, jaqy800suc, jaqy800mda, jaqy800pap, 
      jaqy800cta, jaqy800ope, jaqy800sbop, jaqy800tope, 'V' 
      INTO P_N_EMP, P_N_MOD, P_N_SUC, P_N_MDA, P_N_PAP, P_N_CTA, P_N_OPE, P_N_SBO, P_N_TOP, P_C_FLA 
      FROM JAQY800 WHERE  JAQY800INS = P_N_INS AND ROWNUM = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P_C_FLA := 'N';
    END;  
      IF P_C_FLA = 'V' THEN
        BEGIN          
          SELECT 'S' INTO P_C_FLA FROM AQPB456 
          WHERE aqpb456emp = P_N_EMP AND 
          aqpb456mod = P_N_MOD AND 
          aqpb456suc = P_N_SUC AND 
          aqpb456mda = P_N_MDA AND
          aqpb456pap = P_N_PAP AND
          aqpb456cta = P_N_CTA AND
          aqpb456oper = P_N_OPE AND
          aqpb456sbop = P_N_SBO AND 
          aqpb456tope = P_N_TOP AND AQPB456FCAR = (SELECT MAX(AQPB456FCAR) FROM AQPB456 
          WHERE aqpb456emp = P_N_EMP AND 
          aqpb456mod = P_N_MOD AND 
          aqpb456suc = P_N_SUC AND 
          aqpb456mda = P_N_MDA AND
          aqpb456pap = P_N_PAP AND
          aqpb456cta = P_N_CTA AND
          aqpb456oper = P_N_OPE AND
          aqpb456sbop = P_N_SBO AND 
          aqpb456tope = P_N_TOP) AND ROWNUM = 1;        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
        P_C_FLA := 'V';
        END;
      END IF;              
  END SP_CR_VALIDA_EXISTENCIA_CREDITO;
  
  PROCEDURE SP_CR_OBTIENE_AQPB456IND (
  P_N_INS IN NUMBER,
  P_C_FLA OUT VARCHAR2)
  IS
  -- *****************************************************************
  -- Nombre                     : SP_CR_OBTIENE_AQPB456IND
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.03.25
  -- Autor de Creación          : Milton Fernando Cordova Herrera
  -- Uso                        : Valida campo de tabla AQPB456
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_N_INS ( Instancia )
  -- Parámetros de Salida       : P_C_FLA ( Flag )
  -- Fecha de Modificación      : --
  -- Autor de la Modificación   : --
  -- Descripción de Modificación: --
  -- *****************************************************************
  P_C_GUIA VARCHAR2(1);
  P_N_EMP NUMBER(3);
  P_N_MOD NUMBER(3);
  P_N_SUC NUMBER(3);
  P_N_MDA NUMBER(4);
  P_N_PAP NUMBER(4);
  P_N_CTA NUMBER(9);
  P_N_OPE NUMBER(9);
  P_N_SBO NUMBER(3);
  P_N_TOP NUMBER(3);
  BEGIN
    BEGIN
      SELECT jaqy800pgcd, jaqy800mod, jaqy800suc, jaqy800mda, jaqy800pap, 
      jaqy800cta, jaqy800ope, jaqy800sbop, jaqy800tope, 'S' 
      INTO P_N_EMP, P_N_MOD, P_N_SUC, P_N_MDA, P_N_PAP, P_N_CTA, P_N_OPE, P_N_SBO, P_N_TOP, P_C_GUIA 
      FROM JAQY800 WHERE  JAQY800INS = P_N_INS AND ROWNUM = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P_C_GUIA := 'N';
    END; 
      IF P_C_GUIA = 'S' THEN
        BEGIN
          SELECT AQPB456IND INTO P_C_FLA FROM AQPB456 
          WHERE aqpb456emp = P_N_EMP AND 
          aqpb456mod = P_N_MOD AND 
          aqpb456suc = P_N_SUC AND 
          aqpb456mda = P_N_MDA AND
          aqpb456pap = P_N_PAP AND
          aqpb456cta = P_N_CTA AND
          aqpb456oper = P_N_OPE AND
          aqpb456sbop = P_N_SBO AND 
          aqpb456tope = P_N_TOP;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 P_C_FLA := '';
            WHEN OTHERS THEN NULL;
                 P_C_FLA := '';
        END;
        IF P_C_FLA = 'RPAE' OR P_C_FLA = 'PAEM' THEN
           P_C_FLA := 'PAE'; 
        ELSIF P_C_FLA = 'FCRE' THEN
          P_C_FLA := 'FCR';  
        ELSE 
          P_C_FLA := '';
        END IF; 
      END IF;
  END SP_CR_OBTIENE_AQPB456IND;
  
  PROCEDURE SP_CR_OBTIENE_AQPC263(
  INS IN NUMBER,
  FLAGX OUT VARCHAR2
  )
  AS
  -- *****************************************************************
  -- Nombre                     : SP_CR_OBTIENE_AQPC263
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.03.25
  -- Autor de Creación          : Milton Fernando Cordova Herrera
  -- Uso                        : Valida que no tenga créditos vigentes de campaña y este vinculado (Reprogramados II)
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_N_INS ( Instancia )
  -- Parámetros de Salida       : P_C_FLA ( Flag )
  -- Fecha de Modificación      : --
  -- Autor de la Modificación   : --
  -- Descripción de Modificación: --
  -- *****************************************************************
  RES VARCHAR2(1);
  FLAG VARCHAR2(1);
  vCont NUMBER(3);
  vCTA XWF700.XWFCUENTA%TYPE;
  VPAIS FSR008.pepais%TYPE;
  VDOC FSR008.petdoc%TYPE;
  vDNI FSR008.PENDOC%TYPE;
  CURSOR CUENTAS IS 
  select ctnro from fsr008 where pepais = VPAIS and petdoc=VDOC and pendoc=vDNI and cttfir='T'; 
  CURSOR PRODUCTOS IS
  select tp1nro1, tp1nro2 from fst198 where tp1cod = 1 and tp1cod1=11153 and tp1corr1=1 and tp1corr2=0 and tp1corr3>0 and tp1nro3=1; --SE MODIFICO EL CURSOR LA GUIA LE FALTABA MAS CONDICIONES
  CURSOR CRD_VINCULADO IS--28.03.2022 AGREGADO CURSOR, PARA VALIDAR TAMBIEN LOS CREDITOS VINCULADOS, COMO VALIDACION ADICIONAL DE QUE EL CREDITO VINCULADO ESTE CANCELADO.
  select * FROM JAQY800 WHERE JAQY800INS = INS;
  BEGIN
    SP_CR_VALIDA_EXISTENCIA_CREDITO (INS, FLAG);
    IF FLAG = 'S' THEN
      BEGIN
        SELECT XWFCUENTA INTO vCTA FROM XWF700 WHERE XWFPRCINS = INS AND XWFCAR3 = '1';
        BEGIN
          SELECT pepais, petdoc, PENDOC INTO VPAIS, VDOC, vDNI FROM FSR008 WHERE CTNRO = vCTA AND CTTFIR = 'T';
          RES := 'S';
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RES := 'N';
        END;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RES := 'N';
      END;
      IF RES <> 'N' THEN
        vCont := 0;
        FOR X IN CUENTAS LOOP
          FOR Y IN PRODUCTOS LOOP
            BEGIN
              select count(*) into vCont 
              from fsd010
             where PGCOD = 1
               and aocta = x.ctnro
               and aomod = y.tp1nro1
               and aotope = y.tp1nro2
               and aostat <> 99;
            EXCEPTION 
              WHEN NO_DATA_FOUND THEN
                RES := 'N';
                vCont := 0;
            END;
            IF vCont > 0 THEN
              FLAGX := 'S';
              RETURN;
            END IF;
          END LOOP;
        END LOOP;
        IF vCont = 0 then --AGREGADO CONDICION  28.03.2022
          BEGIN --AGREGADO 28.03.2022, VALIDAR TAMBIEN LOS DEL PANEL DE VINCULACION ESTE CANCELADO
              FOR Z IN CRD_VINCULADO LOOP
                   BEGIN
                        select count(*) into vCont 
                        from fsd010
                       where PGCOD = 1
                         and aocta = z.jaqy800cta
                         and aomod = z.jaqy800mod
                         and aotope = z.jaqy800tope
                         and aostat <> 99;
                   EXCEPTION 
                      WHEN NO_DATA_FOUND THEN
                        RES := 'N';
                        vCont := 0;
                  END;
                  IF vCont > 0 THEN
                    FLAGX := 'S';
                    RETURN;
                  END IF;
             END LOOP; 
          END;
        END IF;  
        IF vCont = 0 THEN
          FLAGX := 'N';
        END IF;
      END IF;
    END IF;
  END SP_CR_OBTIENE_AQPC263;
  
  PROCEDURE SP_CR_OBTIENE_AQPC264(
  INS IN NUMBER,
  FLAGX OUT VARCHAR2
  )
  AS
  -- *****************************************************************
  -- Nombre                     : SP_CR_OBTIENE_AQPC264
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.03.25
  -- Autor de Creación          : Milton Fernando Cordova Herrera
  -- Uso                        : Valida que no tenga créditos vigente de campaña (Reprogramados II)
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_N_INS ( Instancia )
  -- Parámetros de Salida       : P_C_FLA ( Flag )
  -- Fecha de Modificación      : --
  -- Autor de la Modificación   : --
  -- Descripción de Modificación: --
  -- *****************************************************************
  RES VARCHAR2(1);
  vCont NUMBER(3);
  vCTA XWF700.XWFCUENTA%TYPE;
  VPAIS FSR008.pepais%TYPE;
  VDOC FSR008.petdoc%TYPE;
  vDNI FSR008.PENDOC%TYPE;
  CURSOR CUENTAS IS 
  select ctnro from fsr008 where pepais = VPAIS and petdoc=VDOC and pendoc=vDNI and cttfir='T'; 
  CURSOR PRODUCTOS IS
  select tp1nro1, tp1nro2 from fst198 where tp1cod = 1 and tp1cod1=11153 and tp1corr1=1 and tp1corr2=0 and tp1corr3>0 and tp1nro3=1; --SE MODIFICO EL CURSOR LA GUIA LE FALTABA MAS CONDICIONES
  CURSOR CRD_VINCULADO IS--28.03.2022 AGREGADO CURSOR, PARA VALIDAR TAMBIEN LOS CREDITOS VINCULADOS, COMO VALIDACION ADICIONAL DE QUE EL CREDITO VINCULADO ESTE CANCELADO.
  select * FROM JAQY800 WHERE JAQY800INS = INS;
  BEGIN
    --SP_CR_VALIDA_EXISTENCIA_CREDITO (INS, FLAG);
    --IF FLAG = 'S' THEN
      BEGIN
        SELECT XWFCUENTA INTO vCTA FROM XWF700 WHERE XWFPRCINS = INS AND XWFCAR3 = '1';
        BEGIN
          SELECT pepais, petdoc, PENDOC INTO VPAIS, VDOC, vDNI FROM FSR008 WHERE CTNRO = vCTA AND CTTFIR = 'T';
          RES := 'S';
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RES := 'N';
        END;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RES := 'N';
      END;
      IF RES <> 'N' THEN
        vCont := 0;
        FOR X IN CUENTAS LOOP
          FOR Y IN PRODUCTOS LOOP
            BEGIN
              select count(*) into vCont 
              from fsd010
             where PGCOD = 1
               and aocta = x.ctnro
               and aomod = y.tp1nro1
               and aotope = y.tp1nro2
               and aostat <> 99;
            EXCEPTION 
              WHEN NO_DATA_FOUND THEN
                RES := 'N';
                vCont := 0;
            END;
            IF vCont > 0 THEN
              FLAGX := 'S';
              RETURN;
            END IF;
          END LOOP;
        END LOOP;
        IF vCont = 0 then --AGREGADO CONDICION  28.03.2022
          BEGIN --AGREGADO 28.03.2022, VALIDAR TAMBIEN LOS DEL PANEL DE VINCULACION ESTE CANCELADO
              FOR Z IN CRD_VINCULADO LOOP
                   BEGIN
                        select count(*) into vCont 
                        from fsd010
                       where PGCOD = 1
                         and aocta = z.jaqy800cta
                         and aomod = z.jaqy800mod
                         and aotope = z.jaqy800tope
                         and aostat <> 99;
                   EXCEPTION 
                      WHEN NO_DATA_FOUND THEN
                        RES := 'N';
                        vCont := 0;
                  END;
                  IF vCont > 0 THEN
                    FLAGX := 'S';
                    RETURN;
                  END IF;
             END LOOP; 
          END;
        END IF;  
        IF vCont = 0 THEN
          FLAGX := 'N';
        END IF;
      --END IF;
    END IF;
  END SP_CR_OBTIENE_AQPC264;

  procedure sp_cr_PizaFCRECER(lc_digito in varchar2) is
 
  -- *****************************************************************
  -- Nombre                     : sp_cr_PizaFCRECER
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.03.28
  -- Autor de Creación          : Henry Suarez
  -- Uso                        : Carga de Pizarra para Fondo Crecer (JOBS)
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : lc_digito
  -- Parámetros de Salida       : --
  -- Fecha de Modificación      : --
  -- Autor de la Modificación   : --
  -- Descripción de Modificación: --
  -- *****************************************************************
 
    cursor listado_027(ld_FchCar456 date) is
      select distinct q.aqpb456pais ln_pais,
                      q.aqpb456tdoc ln_tdoc,
                      q.aqpb456ndoc lc_ndoc,
                      101           Modulo,
                      q.aqpb456cta1 Cuenta,
                      358           TipoOperacion,
                      0             Moneda,
                      0             Papel,
                      9999999999.99 Monto
        from aqpb456 q
       where q.aqpb456fcar = ld_FchCar456
         and substr(trim(q.aqpb456ndoc), -1, 1) = lc_digito
         and q.aqpb456ind = 'FCRE';
  
    cursor listado_327(ld_FchCar456 date) is
      select distinct q.aqpb456pais ln_pais,
                      q.aqpb456tdoc ln_tdoc,
                      q.aqpb456ndoc lc_ndoc,
                      101           Modulo,
                      q.aqpb456cta1 Cuenta,
                      358           TipoOperacion,
                      0             Moneda,
                      0             Papel
        from aqpb456 q
       where q.aqpb456fcar = ld_FchCar456
         and substr(trim(q.aqpb456ndoc), -1, 1) = lc_digito
         and q.aqpb456ind = 'FCRE';
  
    cursor listado_r027(ld_FchCar456 date) is
      select distinct q.aqpb456pais ln_pais,
                      q.aqpb456tdoc ln_tdoc,
                      q.aqpb456ndoc lc_ndoc,
                      101           Modulo,
                      q.aqpb456cta1 Cuenta,
                      358           TipoOperacion,
                      0             Moneda,
                      0             Papel,
                      9999999999.99 Monto,
                      99999         Plazo,
                      q.aqpb456tasa Tasa
        from aqpb456 q
       where q.aqpb456fcar = ld_FchCar456
         and substr(trim(q.aqpb456ndoc), -1, 1) = lc_digito
         and q.aqpb456ind = 'FCRE';
  
    cursor cuentas(ln_pais   number,
                   ln_tdoc   number,
                   lc_ndoc   varchar2,
                   ln_cuenta number) is
      select f.ctnro Cuenta
        from fsr008 f
       where f.pepais = ln_pais
         and f.petdoc = ln_tdoc
         and f.pendoc = lc_ndoc
         and f.ctnro <> ln_cuenta;
  
    vTpfinv      number;
    ln_Pp028DefN number;
    ln_Pp028Mod  number;
    ln_Pp028Top  number;
    ln_Pp028Mda  number;
    ln_Pp028Pap  number;
    ln_Pp028Emp  number;
    ln_dia       varchar2(2);
    ln_mes       varchar2(2);
    ln_anio      varchar2(4);
    ld_FchInv    number;
    ld_FchCar456 date;
    vFechahasta  date;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
  
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(a.aqpb456fcar)
          into ld_FchCar456
          from aqpb456 a
         where a.aqpb456ind = 'FCRE';
      exception
        when others then
          null;
      end;
    
      --begin
    
      /* SELECT ADD_MONTHS(TRUNC(ld_FchCar456, 'MM'), 1) + 4 --mpostigoc 12.10.2020
      into vFechahasta
      FROM DUAL;*/
    
      -- end;
    
      begin
        select to_char(ld_FchCar456, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_FchCar456, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_FchCar456, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_FchCar456 is not null then
    
      for l in listado_027(ld_FchCar456) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = l.modulo
             and Pp028Top = l.tipooperacion
             and Pp028Mda = l.moneda
             and Pp028Pap = l.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg027
              from fsd027 f
             where f.pgcod = 1
               and f.modulo = l.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = l.cuenta
               and f.moneda = l.moneda
               and f.papel = l.papel
               and f.tpfdes = ld_FchCar456
               and f.tpmto = l.monto
               and f.tpvig = 'S';
          exception
            when others then
              ln_nroreg027 := 0;
          end;
        
          if ln_nroreg027 = 0 then
          
            begin
              insert into fsd027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_FchCar456,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            exception
              when others then
                null;
            end;
            commit;
          
          end if;
        end if;
      
        for c in cuentas(l.ln_pais, l.ln_tdoc, l.lc_ndoc, l.cuenta) loop
        
          begin
            select Pp028DefN,
                   Pp028Mod,
                   Pp028Top,
                   Pp028Mda,
                   Pp028Pap,
                   Pp028Emp
              into ln_Pp028DefN,
                   ln_Pp028Mod,
                   ln_Pp028Top,
                   ln_Pp028Mda,
                   ln_Pp028Pap,
                   ln_Pp028Emp
              from FPP028
             Where Pp028Emp = 1
               and Pp028Mod = l.modulo
               and Pp028Top = l.tipooperacion
               and Pp028Mda = l.moneda
               and Pp028Pap = l.papel
               and Pp017Par = 17;
          exception
            when others then
              null;
          end;
        
          if ln_Pp028DefN is not null then
          
            begin
              select count(*)
                into ln_nroreg027
                from fsd027 f
               where f.pgcod = 1
                 and f.modulo = l.modulo
                 and f.tpizar = ln_Pp028DefN
                 and f.ctnro = c.cuenta
                 and f.moneda = l.moneda
                 and f.papel = l.papel
                 and f.tpfdes = ld_FchCar456
                 and f.tpmto = l.monto
                 and f.tpvig = 'S';
            exception
              when others then
                ln_nroreg027 := 0;
            end;
          
            if ln_nroreg027 = 0 then
            
              begin
                insert into fsd027
                  (pgcod,
                   modulo,
                   tpizar,
                   ctnro,
                   moneda,
                   papel,
                   tpfdes,
                   tpmto,
                   tpttas,
                   tpfinv,
                   tpvig)
                values
                  (1,
                   l.modulo,
                   ln_Pp028DefN,
                   c.cuenta,
                   l.moneda,
                   l.papel,
                   ld_FchCar456,
                   l.monto,
                   1,
                   vTpfinv,
                   'S');
              exception
                when others then
                  null;
              end;
              commit;
            
            end if;
          end if;
        end loop;
      end loop;
    
      for j in listado_327(ld_FchCar456) loop
      
        begin
          select max(a.aqpb456fmdes)
            into vFechahasta
            from aqpb456 a
           where a.aqpb456fcar = ld_FchCar456
             and a.aqpb456pais = j.ln_pais
             and a.aqpb456tdoc = j.ln_tdoc
             and a.aqpb456ndoc = j.lc_ndoc;
        end;
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = j.modulo
             and Pp028Top = j.tipooperacion
             and Pp028Mda = j.moneda
             and Pp028Pap = j.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg327
              from fsd327 f
             where f.vt1pgcod = 1
               and f.vt1mod = j.modulo
               and f.vt1tpiz = ln_Pp028DefN
               and f.vt1ctnr = j.cuenta
               and f.vt1mon = j.moneda
               and f.vt1pap = j.papel
               and f.vt1tpfd = ld_FchCar456;
          exception
            when others then
              ln_nroreg327 := 0;
          end;
        
          if ln_nroreg327 = 0 then
          
            begin
              insert into fsd327
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_FchCar456,
                 vFechahasta);
                  exception
              when others then
                null;
            end;
            commit;
          end if;
        end if;
      
        for c in cuentas(j.ln_pais, j.ln_tdoc, j.lc_ndoc, j.cuenta) loop
          begin
            select Pp028DefN,
                   Pp028Mod,
                   Pp028Top,
                   Pp028Mda,
                   Pp028Pap,
                   Pp028Emp
              into ln_Pp028DefN,
                   ln_Pp028Mod,
                   ln_Pp028Top,
                   ln_Pp028Mda,
                   ln_Pp028Pap,
                   ln_Pp028Emp
              from FPP028
             Where Pp028Emp = 1
               and Pp028Mod = j.modulo
               and Pp028Top = j.tipooperacion
               and Pp028Mda = j.moneda
               and Pp028Pap = j.papel
               and Pp017Par = 17;
          exception
            when others then
              null;
          end;
        
          if ln_Pp028DefN is not null then
          
            begin
              select count(*)
                into ln_nroreg327
                from fsd327 f
               where f.vt1pgcod = 1
                 and f.vt1mod = j.modulo
                 and f.vt1tpiz = ln_Pp028DefN
                 and f.vt1ctnr = c.cuenta
                 and f.vt1mon = j.moneda
                 and f.vt1pap = j.papel
                 and f.vt1tpfd = ld_FchCar456;
            exception
              when others then
                ln_nroreg327 := 0;
            end;
          
            if ln_nroreg327 = 0 then
            
              begin
                insert into fsd327
                  (vt1pgcod,
                   vt1mod,
                   vt1tpiz,
                   vt1ctnr,
                   vt1mon,
                   vt1pap,
                   vt1tpfd,
                   vt1fchven)
                values
                  (1,
                   j.modulo,
                   ln_Pp028DefN,
                   c.cuenta,
                   j.moneda,
                   j.papel,
                   ld_FchCar456,
                   vFechahasta);
                    exception
              when others then
                null;
              end;
              commit;
            end if;
          end if;
        end loop;
      end loop;
    
      for t in listado_r027(ld_FchCar456) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = t.modulo
             and Pp028Top = t.tipooperacion
             and Pp028Mda = t.moneda
             and Pp028Pap = t.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroregr27
              from fsr027 f
             where f.pgcod = 1
               and f.modulo = t.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = t.cuenta
               and f.moneda = t.moneda
               and f.papel = t.papel
               and f.tpfdes = ld_FchCar456
               and f.tpmto = t.monto
                  -- and f.tppzo = t.plazo; -- mpostigoc 10.09.2020
               and f.tppzo = 99999;
          exception
            when others then
              ln_nroregr27 := 0;
          end;
        
          if ln_nroregr27 = 0 then
          
            begin
              insert into fsr027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tppzo,
                 tptasa)
              values
                (1,
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_FchCar456,
                 t.monto,
                 --  t.plazo,
                 99999,
                 t.tasa);
              commit;
            exception
              when others then
                begin
                  insert into aqpa375
                    (pgcod,
                     modulo,
                     tpizar,
                     ctnro,
                     moneda,
                     papel,
                     tpfdes,
                     tpmto,
                     tppzo,
                     tptasa)
                  values
                    (1,
                     t.modulo,
                     ln_Pp028DefN,
                     t.cuenta,
                     t.moneda,
                     t.papel,
                     ld_FchCar456,
                     t.monto,
                     -- t.plazo,
                     99999,
                     t.tasa);
                  commit;
                end;
            end;
          else
            if ln_nroregr27 = 1 then
              -- mpostigoc 10.09.2020
              begin
                update fsr027 f
                   set f.tptasa = t.tasa
                 where f.pgcod = 1
                   and f.modulo = t.modulo
                   and f.tpizar = ln_Pp028DefN
                   and f.ctnro = t.cuenta
                   and f.moneda = t.moneda
                   and f.papel = t.papel
                   and f.tpfdes = ld_FchCar456
                   and f.tpmto = t.monto
                   and f.tppzo = 99999;
                -- and f.tppzo = t.plazo;
                commit;
              end;
            end if;
          end if;
        end if;
      
        for c in cuentas(t.ln_pais, t.ln_tdoc, t.lc_ndoc, t.cuenta) loop
        
          begin
            select Pp028DefN,
                   Pp028Mod,
                   Pp028Top,
                   Pp028Mda,
                   Pp028Pap,
                   Pp028Emp
              into ln_Pp028DefN,
                   ln_Pp028Mod,
                   ln_Pp028Top,
                   ln_Pp028Mda,
                   ln_Pp028Pap,
                   ln_Pp028Emp
              from FPP028
             Where Pp028Emp = 1
               and Pp028Mod = t.modulo
               and Pp028Top = t.tipooperacion
               and Pp028Mda = t.moneda
               and Pp028Pap = t.papel
               and Pp017Par = 17;
          exception
            when others then
              null;
          end;
        
          if ln_Pp028DefN is not null then
          
            begin
              select count(*)
                into ln_nroregr27
                from fsr027 f
               where f.pgcod = 1
                 and f.modulo = t.modulo
                 and f.tpizar = ln_Pp028DefN
                 and f.ctnro = c.cuenta
                 and f.moneda = t.moneda
                 and f.papel = t.papel
                 and f.tpfdes = ld_FchCar456
                 and f.tpmto = t.monto
                    -- and f.tppzo = t.plazo; -- mpostigoc 10.09.2020
                 and f.tppzo = 99999;
            exception
              when others then
                ln_nroregr27 := 0;
            end;
          
            if ln_nroregr27 = 0 then
            
              begin
                insert into fsr027
                  (pgcod,
                   modulo,
                   tpizar,
                   ctnro,
                   moneda,
                   papel,
                   tpfdes,
                   tpmto,
                   tppzo,
                   tptasa)
                values
                  (1,
                   t.modulo,
                   ln_Pp028DefN,
                   c.cuenta,
                   t.moneda,
                   t.papel,
                   ld_FchCar456,
                   t.monto,
                   --  t.plazo,
                   99999,
                   t.tasa);
                commit;
              exception
                when others then
                  begin
                    insert into aqpa375
                      (pgcod,
                       modulo,
                       tpizar,
                       ctnro,
                       moneda,
                       papel,
                       tpfdes,
                       tpmto,
                       tppzo,
                       tptasa)
                    values
                      (1,
                       t.modulo,
                       ln_Pp028DefN,
                       c.cuenta,
                       t.moneda,
                       t.papel,
                       ld_FchCar456,
                       t.monto,
                       -- t.plazo,
                       99999,
                       t.tasa);
                    commit;
                  end;
              end;
            else
              if ln_nroregr27 = 1 then
                -- mpostigoc 10.09.2020
                begin
                  update fsr027 f
                     set f.tptasa = t.tasa
                   where f.pgcod = 1
                     and f.modulo = t.modulo
                     and f.tpizar = ln_Pp028DefN
                     and f.ctnro = c.cuenta
                     and f.moneda = t.moneda
                     and f.papel = t.papel
                     and f.tpfdes = ld_FchCar456
                     and f.tpmto = t.monto
                     and f.tppzo = 99999;
                  -- and f.tppzo = t.plazo;
                  commit;
                end;
              end if;
            end if;
          end if;
        end loop;
      end loop;
    
    end if;
  end sp_cr_PizaFCRECER;
  ------------------------------------------
  Procedure sp_cr_Job_PizasFCRECER is
  -- *****************************************************************
  -- Nombre                     : sp_cr_Job_PizasFCRECER
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.03.28
  -- Autor de Creación          : Henry Suarez
  -- Uso                        : Carga de Pizarra para Fondo Crecer (Complemento JOBS)
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : --
  -- Parámetros de Salida       : --
  -- Fecha de Modificación      : --
  -- Autor de la Modificación   : --
  -- Descripción de Modificación: --
  -- *****************************************************************  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' || 'PQ_CR_REPROG_CAMPANA.sp_cr_PizaFCRECER(''' || x ||
                     ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;
    
    end loop;
  
  end sp_cr_Job_PizasFCRECER;

  procedure sp_cr_PizaPaePyme(lc_digito in varchar2) is
  -- *****************************************************************
  -- Nombre                     : sp_cr_PizaPaePyme
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.03.28
  -- Autor de Creación          : Henry Suarez
  -- Uso                        : Carga de Pizarra para PAE MYPE  (JOBS)
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : lc_digito
  -- Parámetros de Salida       : --
  -- Fecha de Modificación      : --
  -- Autor de la Modificación   : --
  -- Descripción de Modificación: --
  -- *****************************************************************  
    cursor listado_027(ld_FchCar456 date) is
      select distinct q.aqpb456pais ln_pais,
                      q.aqpb456tdoc ln_tdoc,
                      q.aqpb456ndoc lc_ndoc,
                      101           Modulo,
                      q.aqpb456cta1 Cuenta,
                      357           TipoOperacion,
                      0             Moneda,
                      0             Papel,
                      9999999999.99 Monto
        from aqpb456 q
       where q.aqpb456fcar = ld_FchCar456
         and substr(trim(q.aqpb456ndoc), -1, 1) = lc_digito
         and q.aqpb456ind = 'PAEM';
  
    cursor listado_327(ld_FchCar456 date) is
      select distinct q.aqpb456pais ln_pais,
                      q.aqpb456tdoc ln_tdoc,
                      q.aqpb456ndoc lc_ndoc,
                      101           Modulo,
                      q.aqpb456cta1 Cuenta,
                      357           TipoOperacion,
                      0             Moneda,
                      0             Papel
        from aqpb456 q
       where q.aqpb456fcar = ld_FchCar456
         and substr(trim(q.aqpb456ndoc), -1, 1) = lc_digito
         and q.aqpb456ind = 'PAEM';
  
    cursor listado_r027(ld_FchCar456 date) is
      select distinct q.aqpb456pais ln_pais,
                      q.aqpb456tdoc ln_tdoc,
                      q.aqpb456ndoc lc_ndoc,
                      101           Modulo,
                      q.aqpb456cta1 Cuenta,
                      357           TipoOperacion,
                      0             Moneda,
                      0             Papel,
                      9999999999.99 Monto,
                      99999         Plazo,
                      q.aqpb456tasa Tasa
        from aqpb456 q
       where q.aqpb456fcar = ld_FchCar456
         and substr(trim(q.aqpb456ndoc), -1, 1) = lc_digito
         and q.aqpb456ind = 'PAEM';
  
    cursor cuentas(ln_pais   number,
                   ln_tdoc   number,
                   lc_ndoc   varchar2,
                   ln_cuenta number) is
      select f.ctnro Cuenta
        from fsr008 f
       where f.pepais = ln_pais
         and f.petdoc = ln_tdoc
         and f.pendoc = lc_ndoc
         and f.ctnro <> ln_cuenta;
  
    vTpfinv      number;
    ln_Pp028DefN number;
    ln_Pp028Mod  number;
    ln_Pp028Top  number;
    ln_Pp028Mda  number;
    ln_Pp028Pap  number;
    ln_Pp028Emp  number;
    ln_dia       varchar2(2);
    ln_mes       varchar2(2);
    ln_anio      varchar2(4);
    ld_FchInv    number;
    ld_FchCar456 date;
    vFechahasta  date;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
  
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(a.aqpb456fcar)
          into ld_FchCar456
          from aqpb456 a
         where a.aqpb456ind = 'PAEM';
      exception
        when others then
          null;
      end;
    
      --begin
    
      /* SELECT ADD_MONTHS(TRUNC(ld_FchCar456, 'MM'), 1) + 4 --mpostigoc 12.10.2020
      into vFechahasta
      FROM DUAL;*/
    
      -- end;
    
      begin
        select to_char(ld_FchCar456, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_FchCar456, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_FchCar456, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_FchCar456 is not null then
    
      for l in listado_027(ld_FchCar456) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = l.modulo
             and Pp028Top = l.tipooperacion
             and Pp028Mda = l.moneda
             and Pp028Pap = l.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg027
              from fsd027 f
             where f.pgcod = 1
               and f.modulo = l.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = l.cuenta
               and f.moneda = l.moneda
               and f.papel = l.papel
               and f.tpfdes = ld_FchCar456
               and f.tpmto = l.monto
               and f.tpvig = 'S';
          exception
            when others then
              ln_nroreg027 := 0;
          end;
        
          if ln_nroreg027 = 0 then
          
            begin
              insert into fsd027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_FchCar456,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            exception
              when others then
                null;
            end;
            commit;
          
          end if;
        end if;
      
        for c in cuentas(l.ln_pais, l.ln_tdoc, l.lc_ndoc, l.cuenta) loop
        
          begin
            select Pp028DefN,
                   Pp028Mod,
                   Pp028Top,
                   Pp028Mda,
                   Pp028Pap,
                   Pp028Emp
              into ln_Pp028DefN,
                   ln_Pp028Mod,
                   ln_Pp028Top,
                   ln_Pp028Mda,
                   ln_Pp028Pap,
                   ln_Pp028Emp
              from FPP028
             Where Pp028Emp = 1
               and Pp028Mod = l.modulo
               and Pp028Top = l.tipooperacion
               and Pp028Mda = l.moneda
               and Pp028Pap = l.papel
               and Pp017Par = 17;
          exception
            when others then
              null;
          end;
        
          if ln_Pp028DefN is not null then
          
            begin
              select count(*)
                into ln_nroreg027
                from fsd027 f
               where f.pgcod = 1
                 and f.modulo = l.modulo
                 and f.tpizar = ln_Pp028DefN
                 and f.ctnro = c.cuenta
                 and f.moneda = l.moneda
                 and f.papel = l.papel
                 and f.tpfdes = ld_FchCar456
                 and f.tpmto = l.monto
                 and f.tpvig = 'S';
            exception
              when others then
                ln_nroreg027 := 0;
            end;
          
            if ln_nroreg027 = 0 then
            
              begin
                insert into fsd027
                  (pgcod,
                   modulo,
                   tpizar,
                   ctnro,
                   moneda,
                   papel,
                   tpfdes,
                   tpmto,
                   tpttas,
                   tpfinv,
                   tpvig)
                values
                  (1,
                   l.modulo,
                   ln_Pp028DefN,
                   c.cuenta,
                   l.moneda,
                   l.papel,
                   ld_FchCar456,
                   l.monto,
                   1,
                   vTpfinv,
                   'S');
              exception
                when others then
                  null;
              end;
              commit;
            
            end if;
          end if;
        end loop;
      end loop;
    
      for j in listado_327(ld_FchCar456) loop
      
        begin
          select max(a.aqpb456fmdes)
            into vFechahasta
            from aqpb456 a
           where a.aqpb456fcar = ld_FchCar456
             and a.aqpb456pais = j.ln_pais
             and a.aqpb456tdoc = j.ln_tdoc
             and a.aqpb456ndoc = j.lc_ndoc;
        end;
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = j.modulo
             and Pp028Top = j.tipooperacion
             and Pp028Mda = j.moneda
             and Pp028Pap = j.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg327
              from fsd327 f
             where f.vt1pgcod = 1
               and f.vt1mod = j.modulo
               and f.vt1tpiz = ln_Pp028DefN
               and f.vt1ctnr = j.cuenta
               and f.vt1mon = j.moneda
               and f.vt1pap = j.papel
               and f.vt1tpfd = ld_FchCar456;
          exception
            when others then
              ln_nroreg327 := 0;
          end;
        
          if ln_nroreg327 = 0 then
          
            begin
              insert into fsd327
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_FchCar456,
                 vFechahasta);
                  exception
              when others then
                null;
            end;
            commit;
          end if;
        end if;
      
        for c in cuentas(j.ln_pais, j.ln_tdoc, j.lc_ndoc, j.cuenta) loop
          begin
            select Pp028DefN,
                   Pp028Mod,
                   Pp028Top,
                   Pp028Mda,
                   Pp028Pap,
                   Pp028Emp
              into ln_Pp028DefN,
                   ln_Pp028Mod,
                   ln_Pp028Top,
                   ln_Pp028Mda,
                   ln_Pp028Pap,
                   ln_Pp028Emp
              from FPP028
             Where Pp028Emp = 1
               and Pp028Mod = j.modulo
               and Pp028Top = j.tipooperacion
               and Pp028Mda = j.moneda
               and Pp028Pap = j.papel
               and Pp017Par = 17;
          exception
            when others then
              null;
          end;
        
          if ln_Pp028DefN is not null then
          
            begin
              select count(*)
                into ln_nroreg327
                from fsd327 f
               where f.vt1pgcod = 1
                 and f.vt1mod = j.modulo
                 and f.vt1tpiz = ln_Pp028DefN
                 and f.vt1ctnr = c.cuenta
                 and f.vt1mon = j.moneda
                 and f.vt1pap = j.papel
                 and f.vt1tpfd = ld_FchCar456;
            exception
              when others then
                ln_nroreg327 := 0;
            end;
          
            if ln_nroreg327 = 0 then
            
              begin
                insert into fsd327
                  (vt1pgcod,
                   vt1mod,
                   vt1tpiz,
                   vt1ctnr,
                   vt1mon,
                   vt1pap,
                   vt1tpfd,
                   vt1fchven)
                values
                  (1,
                   j.modulo,
                   ln_Pp028DefN,
                   c.cuenta,
                   j.moneda,
                   j.papel,
                   ld_FchCar456,
                   vFechahasta);
                    exception
              when others then
                null;
              end;
              commit;
            end if;
          end if;
        end loop;
      end loop;
    
      for t in listado_r027(ld_FchCar456) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = t.modulo
             and Pp028Top = t.tipooperacion
             and Pp028Mda = t.moneda
             and Pp028Pap = t.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroregr27
              from fsr027 f
             where f.pgcod = 1
               and f.modulo = t.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = t.cuenta
               and f.moneda = t.moneda
               and f.papel = t.papel
               and f.tpfdes = ld_FchCar456
               and f.tpmto = t.monto
                  -- and f.tppzo = t.plazo; -- mpostigoc 10.09.2020
               and f.tppzo = 99999;
          exception
            when others then
              ln_nroregr27 := 0;
          end;
        
          if ln_nroregr27 = 0 then
          
            begin
              insert into fsr027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tppzo,
                 tptasa)
              values
                (1,
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_FchCar456,
                 t.monto,
                 --  t.plazo,
                 99999,
                 t.tasa);
              commit;
            exception
              when others then
                begin
                  insert into aqpa375
                    (pgcod,
                     modulo,
                     tpizar,
                     ctnro,
                     moneda,
                     papel,
                     tpfdes,
                     tpmto,
                     tppzo,
                     tptasa)
                  values
                    (1,
                     t.modulo,
                     ln_Pp028DefN,
                     t.cuenta,
                     t.moneda,
                     t.papel,
                     ld_FchCar456,
                     t.monto,
                     -- t.plazo,
                     99999,
                     t.tasa);
                  commit;
                end;
            end;
          else
            if ln_nroregr27 = 1 then
              -- mpostigoc 10.09.2020
              begin
                update fsr027 f
                   set f.tptasa = t.tasa
                 where f.pgcod = 1
                   and f.modulo = t.modulo
                   and f.tpizar = ln_Pp028DefN
                   and f.ctnro = t.cuenta
                   and f.moneda = t.moneda
                   and f.papel = t.papel
                   and f.tpfdes = ld_FchCar456
                   and f.tpmto = t.monto
                   and f.tppzo = 99999;
                -- and f.tppzo = t.plazo;
                commit;
              end;
            end if;
          end if;
        end if;
      
        for c in cuentas(t.ln_pais, t.ln_tdoc, t.lc_ndoc, t.cuenta) loop
        
          begin
            select Pp028DefN,
                   Pp028Mod,
                   Pp028Top,
                   Pp028Mda,
                   Pp028Pap,
                   Pp028Emp
              into ln_Pp028DefN,
                   ln_Pp028Mod,
                   ln_Pp028Top,
                   ln_Pp028Mda,
                   ln_Pp028Pap,
                   ln_Pp028Emp
              from FPP028
             Where Pp028Emp = 1
               and Pp028Mod = t.modulo
               and Pp028Top = t.tipooperacion
               and Pp028Mda = t.moneda
               and Pp028Pap = t.papel
               and Pp017Par = 17;
          exception
            when others then
              null;
          end;
        
          if ln_Pp028DefN is not null then
          
            begin
              select count(*)
                into ln_nroregr27
                from fsr027 f
               where f.pgcod = 1
                 and f.modulo = t.modulo
                 and f.tpizar = ln_Pp028DefN
                 and f.ctnro = c.cuenta
                 and f.moneda = t.moneda
                 and f.papel = t.papel
                 and f.tpfdes = ld_FchCar456
                 and f.tpmto = t.monto
                    -- and f.tppzo = t.plazo; -- mpostigoc 10.09.2020
                 and f.tppzo = 99999;
            exception
              when others then
                ln_nroregr27 := 0;
            end;
          
            if ln_nroregr27 = 0 then
            
              begin
                insert into fsr027
                  (pgcod,
                   modulo,
                   tpizar,
                   ctnro,
                   moneda,
                   papel,
                   tpfdes,
                   tpmto,
                   tppzo,
                   tptasa)
                values
                  (1,
                   t.modulo,
                   ln_Pp028DefN,
                   c.cuenta,
                   t.moneda,
                   t.papel,
                   ld_FchCar456,
                   t.monto,
                   --  t.plazo,
                   99999,
                   t.tasa);
                commit;
              exception
                when others then
                  begin
                    insert into aqpa375
                      (pgcod,
                       modulo,
                       tpizar,
                       ctnro,
                       moneda,
                       papel,
                       tpfdes,
                       tpmto,
                       tppzo,
                       tptasa)
                    values
                      (1,
                       t.modulo,
                       ln_Pp028DefN,
                       c.cuenta,
                       t.moneda,
                       t.papel,
                       ld_FchCar456,
                       t.monto,
                       -- t.plazo,
                       99999,
                       t.tasa);
                    commit;
                  end;
              end;
            else
              if ln_nroregr27 = 1 then
                -- mpostigoc 10.09.2020
                begin
                  update fsr027 f
                     set f.tptasa = t.tasa
                   where f.pgcod = 1
                     and f.modulo = t.modulo
                     and f.tpizar = ln_Pp028DefN
                     and f.ctnro = c.cuenta
                     and f.moneda = t.moneda
                     and f.papel = t.papel
                     and f.tpfdes = ld_FchCar456
                     and f.tpmto = t.monto
                     and f.tppzo = 99999;
                  -- and f.tppzo = t.plazo;
                  commit;
                end;
              end if;
            end if;
          end if;
        end loop;
      end loop;
    
    end if;
  end sp_cr_PizaPaePyme;

  Procedure sp_cr_Job_PizaPaePyme is
   -- *****************************************************************
  -- Nombre                     : sp_cr_Job_PizaPaePyme
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.03.28
  -- Autor de Creación          : Henry Suarez
  -- Uso                        : Carga de Pizarra para PAE MYPE (Complemento JOBS)
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : --
  -- Parámetros de Salida       : --
  -- Fecha de Modificación      : --
  -- Autor de la Modificación   : --
  -- Descripción de Modificación: --
  -- *****************************************************************  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' || 'PQ_CR_REPROG_CAMPANA.sp_cr_PizaPaePyme(''' || x ||
                     ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;
    
    end loop;
  
  end sp_cr_Job_PizaPaePyme;           
end PQ_CR_REPROG_CAMPANA;
/

