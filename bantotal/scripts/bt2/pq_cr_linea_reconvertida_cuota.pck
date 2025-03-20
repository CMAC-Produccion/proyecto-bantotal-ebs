create or replace package PQ_CR_LINEA_RECONVERTIDA_CUOTA is
  -- **************************************************************************************
  -- NOMBRE                      : SP_CR_VALIDACION_CREDITO
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 19/11/2024
  -- AUTOR DE CREACION           : JAIR IMANOL ALVARO HUAMANI 
  -- USO                         : CAMBIO DE ESTADO DE LA CABECERA /GESTIONADO/ENVIADO TI
  -- PARAMETROS                  : VI_DESTINO  | VARCHAR2
  --                               VI_NDOC407  | VARCHAR2
  --                               VI_NUMINFO  | NUMBER
  --                               VI_MOTIVO   | VARCHAR
  --                               VO_CODERROR | VARCHAR2
  --                               VO_MSGERROR | VARCHAR2
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -----------------------------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 04/12/2024
  -- AUTOR DE LA MODIFICACION    : MPOSTIGOC 
  -- DESCRIPCION DE MODIFICACION : Se agrego validacion de listado impulso
  -- FECHA DE MODIFICACION       : 03/03/2025
  -- AUTOR DE LA MODIFICACION    : MPOSTIGOC 
  -- DESCRIPCION DE MODIFICACION : Se agrego validacion para registros con estado en N, M e I.
  -- FECHA DE MODIFICACION       : 13/03/2025
  -- AUTOR DE LA MODIFICACION    : MPOSTIGOC 
  -- DESCRIPCION DE MODIFICACION : Se agrego Excepcion en el insert  
  -- **************************************************************************************

  PROCEDURE SP_CR_VALIDACION_CREDITO;
  -------------------------------------------------------------------
  PROCEDURE INSERT_AQPB297(ld_fec   in date,
                           ln_cod   in number,
                           ln_suc   in number,
                           ln_mda   in number,
                           ln_pap   in number,
                           ln_cta   in number,
                           ln_oper  in number,
                           ln_sbop  in number,
                           ln_tope  in number,
                           ln_mod   in number,
                           ln_tasa  in number,
                           ln_sdo   in number,
                           lc_est   in varchar2,
                           ln_pais  in number,
                           ln_tdoc  in number,
                           lc_ndoc  in varchar2,
                           lc_aux   in varchar2,
                           ld_fech1 in date,
                           ld_fech2 in date,
                           ld_fech3 in date,
                           lc_var1  in varchar2,
                           lc_var2  in varchar2,
                           lc_var3  in varchar2);
  --------------------------------------------------------------------
  PROCEDURE INSERT_AQPD707(lc_DOC  IN VARCHAR2,
                           lc_TIT  IN VARCHAR2,
                           ln_CTA  IN NUMBER,
                           ln_OPE  IN NUMBER,
                           ln_SAO  IN NUMBER,
                           ln_CUP  IN NUMBER,
                           ln_TAS  IN NUMBER,
                           ln_DIA  IN NUMBER,
                           lc_ANA  IN VARCHAR2,
                           ln_SUC  IN NUMBER,
                           ln_ZCOD IN NUMBER,
                           lc_ZDES IN VARCHAR2,
                           ln_RCOD IN NUMBER,
                           lc_RDES IN VARCHAR2,
                           lc_SNOM IN VARCHAR2);

end PQ_CR_LINEA_RECONVERTIDA_CUOTA;
/

create or replace package body PQ_CR_LINEA_RECONVERTIDA_CUOTA is

  -- **************************************************************************************
  -- Nombre                     : PQ_CR_LINEA_RECONVERTIDA_CUOTA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Activas
  -- Descripción                : Línea Reconvertida en Cuotas 
  -- Versión                    : 1.0
  -- Fecha de Creación          : 27/11/2024
  -- Autor de Creación          : JALVAROH
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *************************************************************************************
  PROCEDURE SP_CR_VALIDACION_CREDITO IS
    -- *************************************************************************************
    -- Nombre                     : SP_CR_VALIDACION_CREDITO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Descripción                : Validación de créditos y extracción de registros sin garantía.
    -- Versión                    : 1.1
    -- Fecha de Creación          : 27/11/2024
    -- Autor                      : JALVAROH
    -- *************************************************************************************
  
    -- Cursor implícito para seleccionar todos los registros que cumplan la condición
    CURSOR cur_jaql964 IS
      SELECT /*+ all_rows */
       *
        FROM JAQL964
       WHERE JAQL964MOD = 116
         AND JAQL964DIA BETWEEN 1 AND 30;
  
    -- Variables para datos validados en FSR011
    ln_modulo      NUMBER(3);
    ln_cta         NUMBER(9);
    ln_oper        NUMBER(9);
    ln_sboper      NUMBER(3);
    ln_sucur       NUMBER(3);
    ln_mda         NUMBER(4);
    ln_tipoer      NUMBER(3);
    FlgIncl        CHAR(1);
    FECH_SISTEMA   DATE;
    vi_TasaAct     NUMBER(10, 6);
    vi_cupoP       NUMBER(17, 2);
    vi_zcod        NUMBER(2);
    vi_zdes        VARCHAR2(50);
    vi_rdoc        NUMBER(3);
    vi_rdes        VARCHAR2(40);
    vi_snom        VARCHAR2(30);
    ln_EnListImpls number := 0;
  
    ln_SaldVig number(17, 2) := 0.00;
  
    vi_prueba    varchar2(40);
    ln_MaxFch297 date;
    ln_RegS297   number;
    ln_RegNIM297 number;
    lc_hora      varchar2(10) := '00:00:00';
  
  BEGIN
    -- Obtener la fecha del sistema desde la tabla FST017
    BEGIN
      SELECT PGFAPE INTO FECH_SISTEMA FROM FST017 F WHERE F.PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        -- Manejo de errores: asignar NULL si hay problemas
        FECH_SISTEMA := NULL;
    END;
    ------------------------------------------------
    ------------------------------------------------
    vi_prueba := TO_CHAR(FECH_SISTEMA, 'DD/MM/YYYY');
    ------------------------------------------------
    ------------------------------------------------
    -- Validar que FECH_SISTEMA no sea NULL antes de proceder
    IF FECH_SISTEMA IS NOT NULL THEN
      -- Actualizar el campo TP1DESC con la fecha obtenida
      UPDATE FST198
         SET TP1DESC = TO_CHAR(FECH_SISTEMA, 'DD/MM/YYYY') -- Convertir fecha a texto
       WHERE TP1COD = 1
         AND TP1COD1 = 10847
         AND TP1CORR1 = 905
         AND TP1CORR2 = 1
         AND TP1CORR3 = 1;
      commit;
    END IF;
  
    begin
      select max(q.aqpb297fec) into ln_MaxFch297 from aqpb297 q;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_RegS297
        from aqpb297 a
       where a.aqpb297fec = ln_MaxFch297
         and a.aqpb297est = 'S';
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_RegNIM297
        from aqpb297 a
       where a.aqpb297fec = ln_MaxFch297
         and a.aqpb297est <> 'S';
    exception
      when others then
        null;
    end;
  
    if ln_RegS297 > 0 and ln_RegNIM297 > 0 then
      delete aqpb297 a
       where a.aqpb297fec = ln_MaxFch297
         and a.aqpb297est <> 'S';
      commit;
    end if;
  
    BEGIN
      -- Cambiamos esta estado a N a los registros anteriores 
      UPDATE AQPB297 SET AQPB297EST = 'N' WHERE AQPB297EST = 'S';
    exception
      WHEN OTHERS THEN
        BEGIN
          UPDATE AQPB297 SET AQPB297EST = 'I' WHERE AQPB297EST = 'S';
        exception
          WHEN OTHERS THEN
            UPDATE AQPB297 SET AQPB297EST = 'M' WHERE AQPB297EST = 'S';
        END;
    END;
    COMMIT;
  
    BEGIN
      -- LIMPIAMOS LA TABLA AQPD707, YA QUE ESTA SE ACTUALIZARA DIARIAMENTE
      EXECUTE IMMEDIATE 'TRUNCATE TABLE AQPD707';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    -- Recorremos todos los registros del cursor con un FOR
    FOR reg_jaql964 IN cur_jaql964 LOOP
    
      ln_SaldVig := 0;
    
      BEGIN
        -- clave de credito 117
        begin
          SELECT F.R2MOD,
                 F.R2CTA,
                 F.R2OPER,
                 F.R2SBOP,
                 F.R2SUC,
                 F.R2MDA,
                 F.R2TOPE
            INTO ln_modulo,
                 ln_cta,
                 ln_oper,
                 ln_sboper,
                 ln_sucur,
                 ln_mda,
                 ln_tipoer
            FROM FSR011 F
           WHERE F.R1COD = 1
             AND F.R1MOD = reg_jaql964.JAQL964MOD
             AND F.R1SUC = reg_jaql964.JAQL964SUC
             AND F.R1MDA = reg_jaql964.JAQL964MDA
             AND F.R1PAP = 0
             AND F.R1CTA = reg_jaql964.JAQL964CTA
             AND F.R1OPER = reg_jaql964.JAQL964OPE
             AND F.R1SBOP = reg_jaql964.JAQL964SOB
             AND F.R1TOPE = reg_jaql964.JAQL964TOP
             AND F.RELCOD = 46;
        exception
          when others then
            null;
        end;
      
        -- Validar si el registro ya tiene garantía (CTS o DPF)
        BEGIN
          SELECT 'N'
            INTO FlgIncl
            FROM FSR011 A, FSR011 B
           WHERE A.RELCOD = 50
             AND A.R1COD = 1
             AND A.R1MOD = ln_modulo
             AND A.R1SUC = ln_sucur
             AND A.R1MDA = ln_mda
             AND A.R1PAP = 0
             AND A.R1CTA = ln_cta
             AND A.R1OPER = ln_oper
             AND A.R1SBOP = ln_sboper
             AND A.R1TOPE = ln_tipoer
             AND B.R2CTA = A.R2CTA
             AND B.R2OPER = A.R2OPER
             AND B.R2SBOP = A.R2SBOP
             AND B.RELCOD IN (2, 25)
             AND A.R011CO = 'S'
             AND B.R011CO = 'S'
             AND ROWNUM = 1;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            FlgIncl := 'S'; -- No tiene garantía, se debe procesar
        END;
      
        begin
          -- Verifica Si esta en el listado Impulso Peru
          select count(*)
            into ln_EnListImpls
            from aqpc363 c, aqpc364 a
           where c.aqpc363pais = a.aqpc364pais
             and c.aqpc363tdoc = a.aqpc364tdoc
             and c.aqpc363ndoc = a.aqpc364ndoc
             and c.aqpc363est = 'S'
             and a.aqpc364est = 'S'
             and c.aqpc363fmaxd > FECH_SISTEMA
             and a.aqpc364empcc = 1
             and a.aqpc364modcc = reg_jaql964.jaql964mod
             and a.aqpc364succc = reg_jaql964.JAQL964SUC
             and a.aqpc364mdacc = reg_jaql964.JAQL964MDA
             and a.aqpc364papcc = 0
             and a.aqpc364ctacc = reg_jaql964.JAQL964CTA
             and a.aqpc364opecc = reg_jaql964.JAQL964OPE
             and a.aqpc364sbocc = reg_jaql964.JAQL964SOB
             and a.aqpc364topecc = reg_jaql964.JAQL964TOP;
        exception
          when others then
            null;
        end;
      
        BEGIN
          PQ_CR_ACTUALIZACIONES.sp_cr_TasaActual(ln_pgcod   => 1,
                                                 ln_mod     => reg_jaql964.JAQL964MOD, -- 116
                                                 ln_suc     => reg_jaql964.JAQL964SUC,
                                                 ln_mda     => reg_jaql964.JAQL964MDA,
                                                 ln_pap     => 0,
                                                 ln_cta     => reg_jaql964.JAQL964CTA,
                                                 ln_oper    => reg_jaql964.JAQL964OPE,
                                                 ln_subop   => reg_jaql964.JAQL964SOB,
                                                 ln_tope    => reg_jaql964.JAQL964TOP,
                                                 ln_TasaAct => vi_TasaAct); -- salida de tasa actual 
        END;
      
        -- Insertar registro en AQPB297 si no tiene garantía
        IF FlgIncl = 'S' and ln_EnListImpls = 0 THEN
        
          begin
            select sum(jaql964sac * -1)
              into ln_SaldVig
              from jaql964 j
             where j.jaql964ins = reg_jaql964.jaql964ins;
          exception
            when others then
              null;
          end;
        
          -- INSERCION DE LA TABLA AQPB297
          pq_cr_linea_reconvertida_cuota.INSERT_AQPB297(ld_fec   => FECH_SISTEMA,
                                                        ln_cod   => 1,
                                                        ln_suc   => reg_jaql964.JAQL964SUC,
                                                        ln_mda   => reg_jaql964.JAQL964MDA,
                                                        ln_pap   => 0,
                                                        ln_cta   => reg_jaql964.JAQL964CTA,
                                                        ln_oper  => reg_jaql964.JAQL964OPE,
                                                        ln_sbop  => reg_jaql964.JAQL964SOB,
                                                        ln_tope  => reg_jaql964.JAQL964TOP,
                                                        ln_mod   => reg_jaql964.JAQL964MOD,
                                                        ln_tasa  => vi_TasaAct,
                                                        ln_sdo   => ln_SaldVig,
                                                        lc_est   => 'S',
                                                        ln_pais  => reg_jaql964.jaql964pai,
                                                        ln_tdoc  => reg_jaql964.jaql964tid,
                                                        lc_ndoc  => reg_jaql964.jaql964doc,
                                                        lc_aux   => lc_hora,
                                                        ld_fech1 => null,
                                                        ld_fech2 => null,
                                                        ld_fech3 => null,
                                                        lc_var1  => null,
                                                        lc_var2  => null,
                                                        lc_var3  => null);
          ---------------------------------------------------------------------------------------------
        
          BEGIN
            select XLLCAPITAL
              into vi_cupoP
              from x054023
             where XLLPGCOD = 1
               and XLLAOMOD = ln_modulo
               and XLLAOSUC = ln_sucur
               and XLLAOMDA = ln_mda
               and XLLAOPAP = 0
               and XLLAOCTA = ln_cta
               and XLLAOOPER = ln_oper
               and XLLAOSBOP = ln_sboper
               and XLLAOTOP = ln_tipoer;
          
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          BEGIN
          
            select CODZON, DESZON, REGCOD, REGNOM, SCNOM
              into vi_zcod, vi_zdes, vi_rdoc, vi_rdes, vi_snom
              from regsuc
             where SUCURS = reg_jaql964.JAQL964SUC;
          
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        
          BEGIN
            -- INSERCION PARA EL CONSUPA DEL REPORTE 
            ---
            PQ_CR_LINEA_RECONVERTIDA_CUOTA.INSERT_AQPD707(lc_DOC  => reg_jaql964.jaql964doc,
                                                          lc_TIT  => reg_jaql964.jaql964tit,
                                                          ln_CTA  => reg_jaql964.jaql964cta,
                                                          ln_OPE  => reg_jaql964.jaql964ope,
                                                          ln_SAO  => reg_jaql964.jaql964sao * -1,
                                                          ln_CUP  => vi_cupoP,
                                                          ln_TAS  => vi_TasaAct,
                                                          ln_DIA  => reg_jaql964.jaql964dia,
                                                          lc_ANA  => reg_jaql964.jaql964usu,
                                                          ln_SUC  => reg_jaql964.jaql964suc,
                                                          ln_ZCOD => vi_zcod,
                                                          lc_ZDES => vi_zdes,
                                                          ln_RCOD => vi_rdoc,
                                                          lc_RDES => vi_rdes,
                                                          lc_SNOM => vi_snom);
          
          END;
        
        END IF;
      END;
      ------------------------------------------------------------------------------------  
    
    END LOOP; -- Fin del loop del cursor implícito
    COMMIT;
  
    BEGIN
    
      PQ_CR_ACTUALIZACIONES.sp_Cr_TasaReconvLinea;
    
    END;
  
  END SP_CR_VALIDACION_CREDITO;
  ---------------------------------------------------------------------
  PROCEDURE INSERT_AQPB297(ld_fec   in date,
                           ln_cod   in number,
                           ln_suc   in number,
                           ln_mda   in number,
                           ln_pap   in number,
                           ln_cta   in number,
                           ln_oper  in number,
                           ln_sbop  in number,
                           ln_tope  in number,
                           ln_mod   in number,
                           ln_tasa  in number,
                           ln_sdo   in number,
                           lc_est   in varchar2,
                           ln_pais  in number,
                           ln_tdoc  in number,
                           lc_ndoc  in varchar2,
                           lc_aux   in varchar2,
                           ld_fech1 in date,
                           ld_fech2 in date,
                           ld_fech3 in date,
                           lc_var1  in varchar2,
                           lc_var2  in varchar2,
                           lc_var3  in varchar2) IS
  
  BEGIN
  
    begin
      INSERT /*+ APPEND */
      INTO AQPB297
        (aqpb297fec,
         aqpb297cod,
         aqpb297suc,
         aqpb297mda,
         aqpb297pap,
         aqpb297cta,
         aqpb297oper,
         aqpb297sbop,
         aqpb297tope,
         aqpb297mod,
         aqpb297tasa,
         aqpb297sdo,
         aqpb297est,
         aqpb297pais,
         aqpb297tdoc,
         aqpb297ndoc,
         aqpb297hora,
         aqpb297fech1,
         aqpb297fech2,
         aqpb297fech3,
         aqpb297var1,
         aqpb297var2,
         aqpb297var3)
      VALUES
        (ld_fec,
         ln_cod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_oper,
         ln_sbop,
         ln_tope,
         ln_mod,
         ln_tasa,
         ln_sdo,
         lc_est,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         lc_aux,
         ld_fech1,
         ld_fech2,
         ld_fech3,
         lc_var1,
         lc_var2,
         lc_var3);
    exception
      when others then
        null;
    end;
  
    commit;
  
  END INSERT_AQPB297;

  PROCEDURE INSERT_AQPD707(lc_DOC  IN VARCHAR2,
                           lc_TIT  IN VARCHAR2,
                           ln_CTA  IN NUMBER,
                           ln_OPE  IN NUMBER,
                           ln_SAO  IN NUMBER,
                           ln_CUP  IN NUMBER,
                           ln_TAS  IN NUMBER,
                           ln_DIA  IN NUMBER,
                           lc_ANA  IN VARCHAR2,
                           ln_SUC  IN NUMBER,
                           ln_ZCOD IN NUMBER,
                           lc_ZDES IN VARCHAR2,
                           ln_RCOD IN NUMBER,
                           lc_RDES IN VARCHAR2,
                           lc_SNOM IN VARCHAR2) IS
  
  BEGIN
  
    begin
      INSERT /*+ APPEND */
      INTO AQPD707
        (AQPD707DOC,
         AQPD707TIT,
         AQPD707CTA,
         AQPD707OPE,
         AQPD707SAO,
         AQPD707CUP,
         AQPD707TAS,
         AQPD707DIA,
         AQPD707ANA,
         AQPD707SUC,
         AQPD707ZCOD,
         AQPD707ZDES,
         AQPD707RCOD,
         AQPD707RDES,
         AQPD707SNOM)
      VALUES
        (lc_DOC,
         lc_TIT,
         ln_CTA,
         ln_OPE,
         ln_SAO,
         ln_CUP,
         ln_TAS,
         ln_DIA,
         lc_ANA,
         ln_SUC,
         ln_ZCOD,
         lc_ZDES,
         ln_RCOD,
         lc_RDES,
         lc_SNOM);
    exception
      when others then
        null;
    end;
    commit;
  
  END INSERT_AQPD707;

end PQ_CR_LINEA_RECONVERTIDA_CUOTA;
/

