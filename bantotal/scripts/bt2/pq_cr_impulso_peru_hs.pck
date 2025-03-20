create or replace package pq_cr_impulso_peru_hs is

  -- Author  : HSUAREZ
  -- Created : 23/05/2023 12:09:11
  -- Purpose : Proceso para el panel de carga de impulso peru

  procedure sp_cr_add_credito(ve_pai       in number,
                              ve_tdo       in number,
                              ve_pnd       in varchar,
                              ve_emp       in number,
                              ve_mod       in number,
                              ve_suc       in number,
                              ve_mda       in number,
                              ve_pap       in number,
                              ve_cta       in number,
                              ve_ope       in number,
                              ve_sbo       in number,
                              ve_top       in number,
                              ve_usr       in varchar,
                              ve_fecpro    in date,
                              ve_mora      in number,
                              ve_icv       in number,
                              ve_gasotr    in number,
                              ve_cuoSeg    in number,
                              ve_DeuTot    in number, --hsuarez@13.07.2023
                              ve_IndCovid  in varchar, --hsuarez@13.07.2023
                              ve_Provision in number, --hsuarez@13.07.2023
                              ve_IndExoPrv in varchar, --hsuarez@13.07.2023
                              vo_cod_error out varchar,
                              vo_msg_error out varchar);
  procedure sp_cr_updInteres_credito(ve_pai       in number,
                                     ve_tdo       in number,
                                     ve_pnd       in varchar,
                                     ve_emp       in number,
                                     ve_mod       in number,
                                     ve_suc       in number,
                                     ve_mda       in number,
                                     ve_pap       in number,
                                     ve_cta       in number,
                                     ve_ope       in number,
                                     ve_sbo       in number,
                                     ve_top       in number,
                                     ve_Interes   in number,
                                     ve_Capital   in number,
                                     ve_DeuTFec   in number,
                                     ve_usr       in varchar,
                                     ve_fecpro    in date,
                                     vo_cod_error out varchar,
                                     vo_msg_error out varchar);
  procedure sp_cr_withdraw_credito(ve_pai       in number,
                                   ve_tdo       in number,
                                   ve_pnd       in varchar,
                                   ve_emp       in number,
                                   ve_mod       in number,
                                   ve_suc       in number,
                                   ve_mda       in number,
                                   ve_pap       in number,
                                   ve_cta       in number,
                                   ve_ope       in number,
                                   ve_sbo       in number,
                                   ve_top       in number,
                                   ve_usr       in varchar,
                                   ve_fecpro    in date,
                                   vo_cod_error out varchar,
                                   vo_msg_error out varchar);
  procedure sp_cr_process_crd(ve_fecpro    in date,
                              ve_pai       in number,
                              ve_tdo       in number,
                              ve_pnd       in varchar,
                              ve_usr       in varchar,
                              ve_montoMax  in number,
                              ve_montoMin  in number,
                              vo_cod_error out varchar,
                              vo_msg_error out varchar);
  procedure sp_cr_updCalculo_credito(ve_pai        in number,
                                     ve_tdo        in number,
                                     ve_pnd        in varchar,
                                     ve_emp        in number,
                                     ve_mod        in number,
                                     ve_suc        in number,
                                     ve_mda        in number,
                                     ve_pap        in number,
                                     ve_cta        in number,
                                     ve_ope        in number,
                                     ve_sbo        in number,
                                     ve_top        in number,
                                     ve_porcentaje in number,
                                     ve_Interes    in number,
                                     ve_IntCondo   in number,
                                     ve_IntnoCondo in number,
                                     ve_usr        in varchar,
                                     ve_fecpro     in date,
                                     vo_cod_error  out varchar,
                                     vo_msg_error  out varchar);
  procedure sp_cr_validar_credito(ve_emp       in number,
                                  ve_mod       in number,
                                  ve_suc       in number,
                                  ve_mda       in number,
                                  ve_pap       in number,
                                  ve_cta       in number,
                                  ve_ope       in number,
                                  ve_sbo       in number,
                                  ve_top       in number,
                                  ve_fec       in date,
                                  vo_rpta      out varchar,
                                  vo_cod_error out varchar,
                                  vo_msg_error out varchar);
  procedure sp_desvincular_creditos(ve_pai       in number,
                                    ve_tdo       in number,
                                    ve_pnd       in varchar,
                                    ve_fecpro    in date,
                                    vo_cod_error out varchar,
                                    vo_msg_error out varchar);
  procedure sp_cr_updDeudaTot(ve_pai in number,
                              ve_tdo in number,
                              ve_pnd in varchar,
                              
                              ve_emp in number,
                              ve_mod in number,
                              ve_suc in number,
                              
                              ve_mda in number,
                              ve_pap in number,
                              ve_cta in number,
                              
                              ve_ope in number,
                              ve_sbo in number,
                              ve_top in number,
                              
                              ve_dTotal    in number,
                              ve_indCovid  in varchar,
                              ve_indExoPrv in varchar,
                              ve_fecpro    in date,
                              vo_cod_error out varchar,
                              vo_msg_error out varchar);
  procedure SP_OBTENER_MNT_TOTALDEUDA(ve_fecpro    in date,
                                      ve_pai       in number,
                                      ve_tdo       in number,
                                      ve_pnd       in varchar,
                                      ve_usr       in varchar,
                                      ve_dTotal    out number,
                                      vo_cod_error out varchar,
                                      vo_msg_error out varchar);
end pq_cr_impulso_peru_hs;
/

create or replace package body pq_cr_impulso_peru_hs is

  -- Author  : HSUAREZ
  -- Created : 23/05/2023 12:09:11
  -- Purpose : Proceso para el panel de carga de impulso peru

  procedure sp_cr_add_credito(ve_pai       in number,
                              ve_tdo       in number,
                              ve_pnd       in varchar,
                              ve_emp       in number,
                              ve_mod       in number,
                              ve_suc       in number,
                              ve_mda       in number,
                              ve_pap       in number,
                              ve_cta       in number,
                              ve_ope       in number,
                              ve_sbo       in number,
                              ve_top       in number,
                              ve_usr       in varchar,
                              ve_fecpro    in date,
                              ve_mora      in number,
                              ve_icv       in number,
                              ve_gasotr    in number,
                              ve_cuoSeg    in number,
                              ve_DeuTot    in number, --hsuarez@13.07.2023
                              ve_IndCovid  in varchar, --hsuarez@13.07.2023
                              ve_Provision in number, --hsuarez@13.07.2023
                              ve_IndExoPrv in varchar, --hsuarez@13.07.2023
                              vo_cod_error out varchar,
                              vo_msg_error out varchar) IS
    VI_EXISTE        number(10);
    VI_EXISTE_LISTA  number(10);
    VI_ESTADO_ACTUAL varchar(1);
    CLIENTE          varchar(50);
    VI_APLICAD       VARCHAR(12);
  begin
    vo_cod_error := '0000';
    vo_msg_error := '';
    --INSERT INTO PRUEBA_LOG(pgcod,aomod,aosuc,aomda,aopap,aocta,aooper,aosbop,aotope,fecha)VALUES(ve_emp,ve_mod,ve_suc,ve_mda,ve_pap,ve_cta,ve_ope,ve_sbo,ve_top,ve_fecpro);
    BEGIN
      SELECT AQPC364NCLI
        INTO CLIENTE
        FROM AQPC364
       WHERE AQPC364PAIS = ve_pai
         AND AQPC364TDOC = ve_tdo
         AND AQPC364NDOC = rpad(ve_pnd, 12, ' ')
         AND AQPC364EST = 'S'
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT AQPC364DESCU
        INTO VI_APLICAD
        FROM AQPC364
       WHERE AQPC364EMPCC = ve_emp
         AND AQPC364MODCC = ve_mod
         AND AQPC364SUCCC = ve_suc
         AND AQPC364MDACC = ve_mda
         AND AQPC364PAPCC = ve_pap
         AND AQPC364CTACC = ve_cta
         AND AQPC364OPECC = ve_ope
         AND AQPC364SBOCC = ve_sbo
         AND AQPC364TOPECC = ve_top
         AND AQPC364EST = 'S'
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      UPDATE AQPC589
         SET AQPC589ESTHAB = 'I'
       WHERE AQPC589FECPRO < ve_fecpro
         AND AQPC589EMP = ve_emp
         AND AQPC589MOD = ve_mod
         AND AQPC589SUC = ve_suc
         AND AQPC589MDA = ve_mda
         AND AQPC589PAP = ve_pap
         AND AQPC589CTA = ve_cta
         AND AQPC589OPER = ve_ope
         AND AQPC589SBOP = ve_sbo
         AND AQPC589TOP = ve_top;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    --VALIDAR SI LA VINCULACION EXISTENTE CON FECHA ACTUAL
    BEGIN
      VI_EXISTE := 0;
      SELECT COUNT(*)
        INTO VI_EXISTE
        FROM AQPC589
       WHERE AQPC589FECPRO = ve_fecpro
         AND AQPC589EMP = ve_emp
         AND AQPC589MOD = ve_mod
         AND AQPC589SUC = ve_suc
         AND AQPC589MDA = ve_mda
         AND AQPC589PAP = ve_pap
         AND AQPC589CTA = ve_cta
         AND AQPC589OPER = ve_ope
         AND AQPC589SBOP = ve_sbo
         AND AQPC589TOP = ve_top
         AND AQPC589ESTHAB = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT AQPC589ESTPRO
        INTO VI_ESTADO_ACTUAL
        FROM AQPC589
       WHERE AQPC589FECPRO = ve_fecpro
         AND AQPC589EMP = ve_emp
         AND AQPC589MOD = ve_mod
         AND AQPC589SUC = ve_suc
         AND AQPC589MDA = ve_mda
         AND AQPC589PAP = ve_pap
         AND AQPC589CTA = ve_cta
         AND AQPC589OPER = ve_ope
         AND AQPC589SBOP = ve_sbo
         AND AQPC589TOP = ve_top
         AND AQPC589ESTHAB = 'H'
         and AQPC589FECREG = (SELECT MAX(AQPC589FECREG)
                                FROM AQPC589
                               WHERE AQPC589FECPRO = ve_fecpro
                                 AND AQPC589EMP = ve_emp
                                 AND AQPC589MOD = ve_mod
                                 AND AQPC589SUC = ve_suc
                                 AND AQPC589MDA = ve_mda
                                 AND AQPC589PAP = ve_pap
                                 AND AQPC589CTA = ve_cta
                                 AND AQPC589OPER = ve_ope
                                 AND AQPC589SBOP = ve_sbo
                                 AND AQPC589TOP = ve_top
                                 AND AQPC589ESTHAB = 'H');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    IF VI_EXISTE > 0 AND (VI_ESTADO_ACTUAL = 'A' OR VI_ESTADO_ACTUAL = 'P') then
      vo_cod_error := '0003';
      vo_msg_error := '0003 - No se puede vincular un credito ya vinculado';
      RETURN;
    END IF;
    IF VI_EXISTE = 0 THEN
      BEGIN
        SELECT COUNT(*)
          INTO VI_EXISTE_LISTA
          FROM AQPC363
         WHERE AQPC363PAIS = ve_pai
           AND AQPC363TDOC = ve_tdo
           AND AQPC363NDOC = rpad(ve_pnd, 12, ' ')
           AND AQPC363EST = 'S';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      IF VI_EXISTE_LISTA = 0 THEN
        vo_cod_error := '0005';
        vo_msg_error := '0005 - No existe en la lista el DNI ingresado';
      END IF;
    END IF;
    IF VI_EXISTE = 0 THEN
      BEGIN
        --CASO NO EXISTIR PROCEDER CON LA VINCULACION
        INSERT INTO AQPC589
          (AQPC589PAIS,
           AQPC589PTDC,
           AQPC589DNI,
           AQPC589CLI,
           AQPC589EMP,
           AQPC589MOD,
           AQPC589SUC,
           AQPC589MDA,
           AQPC589PAP,
           AQPC589CTA,
           AQPC589OPER,
           AQPC589SBOP,
           AQPC589TOP,
           AQPC589ESTPRO,
           AQPC589ESTHAB,
           AQPC589FECREG,
           AQPC589FECPRO,
           AQPC589USREG,
           AQPC589MMORA,
           AQPC589MICV,
           AQPC589MGAS,
           AQPC589MSEG,
           AQPC589DESCU,
           --
           AQPC589MTDEU,
           AQPC589MPRV,
           AQPC589INDC,
           AQPC589EPRV --HSUAREZ@13.07.2023
           )
        VALUES
          (ve_pai,
           ve_tdo,
           ve_pnd,
           CLIENTE,
           ve_emp,
           ve_mod,
           ve_suc,
           ve_mda,
           ve_pap,
           ve_cta,
           ve_ope,
           ve_sbo,
           ve_top,
           'P',
           'H',
           SYSDATE,
           ve_fecpro,
           ve_usr,
           ve_mora,
           ve_icv,
           ve_gasotr,
           ve_cuoSeg,
           VI_APLICAD,
           ve_DeuTot,
           ve_Provision,
           ve_IndCovid,
           ve_IndExoPrv);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          vo_cod_error := '0001';
          vo_msg_error := '0001 - No se pudo vincular el Credito';
      END;
    ELSE
      BEGIN
        UPDATE AQPC589
           SET AQPC589ESTHAB = 'H',
               AQPC589FCHMOD = sysdate,
               AQPC589USMOD  = ve_usr,
               AQPC589MMORA  = ve_mora,
               AQPC589MICV   = ve_icv,
               AQPC589MGAS   = ve_gasotr,
               AQPC589MSEG   = ve_cuoSeg,
               AQPC589MTDEU  = ve_DeuTot,
               AQPC589MPRV   = ve_Provision,
               AQPC589INDC   = ve_IndCovid,
               AQPC589EPRV   = ve_IndExoPrv
         WHERE AQPC589FECPRO = ve_fecpro
           AND AQPC589EMP = ve_emp
           AND AQPC589MOD = ve_mod
           AND AQPC589SUC = ve_suc
           AND AQPC589MDA = ve_mda
           AND AQPC589PAP = ve_pap
           AND AQPC589CTA = ve_cta
           AND AQPC589OPER = ve_ope
           AND AQPC589SBOP = ve_sbo
           AND AQPC589TOP = ve_top
           AND AQPC589ESTHAB = 'I';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
    COMMIT;
  exception
    when others then
      vo_cod_error := '0001';
      vo_msg_error := 'No se pudo vincular el Credito';
  end;

  procedure sp_cr_withdraw_credito(ve_pai       in number,
                                   ve_tdo       in number,
                                   ve_pnd       in varchar,
                                   ve_emp       in number,
                                   ve_mod       in number,
                                   ve_suc       in number,
                                   ve_mda       in number,
                                   ve_pap       in number,
                                   ve_cta       in number,
                                   ve_ope       in number,
                                   ve_sbo       in number,
                                   ve_top       in number,
                                   ve_usr       in varchar,
                                   ve_fecpro    in date,
                                   vo_cod_error out varchar,
                                   vo_msg_error out varchar) IS
    VI_EXISTE number(10);
  
  begin
    vo_cod_error := '0000';
    vo_msg_error := '';
    BEGIN
      UPDATE AQPC589
         SET AQPC589ESTHAB = 'I',
             AQPC589FCHMOD = sysdate,
             AQPC589USMOD  = ve_usr
       WHERE AQPC589FECPRO < ve_fecpro
         AND AQPC589EMP = ve_emp
         AND AQPC589MOD = ve_mod
         AND AQPC589SUC = ve_suc
         AND AQPC589MDA = ve_mda
         AND AQPC589PAP = ve_pap
         AND AQPC589CTA = ve_cta
         AND AQPC589OPER = ve_ope
         AND AQPC589SBOP = ve_sbo
         AND AQPC589TOP = ve_top;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --VALIDAR SI LA VINCULACION EXISTE Y SI YA FUE PROCESADO
    BEGIN
      VI_EXISTE := 0;
      SELECT COUNT(*)
        INTO VI_EXISTE
        FROM AQPC589
       WHERE AQPC589FECPRO = ve_fecpro
         AND AQPC589EMP = ve_emp
         AND AQPC589MOD = ve_mod
         AND AQPC589SUC = ve_suc
         AND AQPC589MDA = ve_mda
         AND AQPC589PAP = ve_pap
         AND AQPC589CTA = ve_cta
         AND AQPC589OPER = ve_ope
         AND AQPC589SBOP = ve_sbo
         AND AQPC589TOP = ve_top;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    IF VI_EXISTE > 0 THEN
      BEGIN
        UPDATE AQPC589
           SET AQPC589ESTHAB = 'I'
         WHERE AQPC589FECPRO = ve_fecpro
           AND AQPC589EMP = ve_emp
           AND AQPC589MOD = ve_mod
           AND AQPC589SUC = ve_suc
           AND AQPC589MDA = ve_mda
           AND AQPC589PAP = ve_pap
           AND AQPC589CTA = ve_cta
           AND AQPC589OPER = ve_ope
           AND AQPC589SBOP = ve_sbo
           AND AQPC589TOP = ve_top
           AND AQPC589ESTHAB = 'H'
           AND AQPC589ESTPRO IN ('P', 'A');
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
    COMMIT;
  exception
    when others then
      vo_cod_error := '0001';
      vo_msg_error := 'No se pudo vincular el Credito';
  end;

  procedure sp_cr_updInteres_credito(ve_pai       in number,
                                     ve_tdo       in number,
                                     ve_pnd       in varchar,
                                     ve_emp       in number,
                                     ve_mod       in number,
                                     ve_suc       in number,
                                     ve_mda       in number,
                                     ve_pap       in number,
                                     ve_cta       in number,
                                     ve_ope       in number,
                                     ve_sbo       in number,
                                     ve_top       in number,
                                     ve_Interes   in number,
                                     ve_Capital   in number,
                                     ve_DeuTFec   in number,
                                     ve_usr       in varchar,
                                     ve_fecpro    in date,
                                     vo_cod_error out varchar,
                                     vo_msg_error out varchar) IS
    VI_EXISTE number(10);
  
  begin
    vo_cod_error := '0000';
    vo_msg_error := '';
    BEGIN
      UPDATE AQPC589
         SET AQPC589SCAP   = ve_Capital,
             AQPC589INANT  = ve_Interes,
             AQPC589FCHMOD = sysdate,
             AQPC589USMOD  = ve_usr
       WHERE AQPC589FECPRO = ve_fecpro
         AND AQPC589EMP = ve_emp
         AND AQPC589MOD = ve_mod
         AND AQPC589SUC = ve_suc
         AND AQPC589MDA = ve_mda
         AND AQPC589PAP = ve_pap
         AND AQPC589CTA = ve_cta
         AND AQPC589OPER = ve_ope
         AND AQPC589SBOP = ve_sbo
         AND AQPC589TOP = ve_top
         AND AQPC589ESTPRO = 'P'
         AND AQPC589ESTHAB = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    COMMIT;
  EXCEPTION
    when others then
      vo_cod_error := '0001';
      vo_msg_error := 'No se pudo cargar los saldos actuales del Credito, para el cálculo';
  END;

  procedure sp_cr_process_crd(ve_fecpro    in date,
                              ve_pai       in number,
                              ve_tdo       in number,
                              ve_pnd       in varchar,
                              ve_usr       in varchar,
                              ve_montoMax  in number,
                              ve_montoMin  in number,
                              vo_cod_error out varchar,
                              vo_msg_error out varchar) is
    VE_EXISTE NUMBER(10);
  BEGIN
    NULL;
    vo_cod_error := '0000';
    vo_msg_error := '';
    --INSERT INTO PRUEBA_LOG(msg)VALUES(to_char(ve_fecpro)||'-'||to_char(ve_pai)||'-'||to_char(ve_tdo)||'-'||ve_pnd);
    BEGIN
      SELECT COUNT(*)
        INTO VE_EXISTE
        FROM AQPC589
       WHERE AQPC589FECPRO = ve_fecpro
         AND AQPC589PAIS = ve_pai
         AND AQPC589PTDC = ve_tdo
         AND AQPC589DNI = RPAD(ve_pnd, 12, ' ')
         AND AQPC589ESTHAB = 'H'
         AND AQPC589ESTPRO in ('P', 'A');
    EXCEPTION
      WHEN OTHERS THEN
        vo_cod_error := '0007';
        vo_msg_error := 'No se realizo la gestion, por favor volver a procesar';
    END;
    IF VE_EXISTE > 0 THEN
      BEGIN
        UPDATE AQPC589
           SET AQPC589ESTPRO = 'A', aqpc589fchmod = SYSDATE()
        --AQPC589MNTMAX=NVL(ve_montoMax,0),
        --AQPC589MNTMIN=NVL(ve_montoMin,0)
         WHERE AQPC589FECPRO = ve_fecpro
           AND AQPC589PAIS = ve_pai
           AND AQPC589PTDC = ve_tdo
           AND AQPC589DNI = RPAD(ve_pnd, 12, ' ')
           AND AQPC589ESTHAB = 'H'
           AND AQPC589ESTPRO IN ('P', 'A');
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    ELSE
      vo_cod_error := '0007';
      vo_msg_error := 'No se realizo la gestion,por favor volver a procesar.';
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  procedure sp_cr_updCalculo_credito(ve_pai        in number,
                                     ve_tdo        in number,
                                     ve_pnd        in varchar,
                                     ve_emp        in number,
                                     ve_mod        in number,
                                     ve_suc        in number,
                                     ve_mda        in number,
                                     ve_pap        in number,
                                     ve_cta        in number,
                                     ve_ope        in number,
                                     ve_sbo        in number,
                                     ve_top        in number,
                                     ve_porcentaje in number,
                                     ve_Interes    in number,
                                     ve_IntCondo   in number,
                                     ve_IntnoCondo in number,
                                     ve_usr        in varchar,
                                     ve_fecpro     in date,
                                     vo_cod_error  out varchar,
                                     vo_msg_error  out varchar) is
  begin
    vo_cod_error := '0000';
    vo_msg_error := '';
    BEGIN
      UPDATE AQPC589
         SET AQPC589INCON  = ve_IntCondo,
             AQPC589INANT  = ve_Interes,
             AQPC589INACT  = ve_IntnoCondo,
             AQPC589PDESC  = ve_porcentaje,
             AQPC589FCHMOD = sysdate,
             AQPC589USMOD  = ve_usr
       WHERE AQPC589FECPRO = ve_fecpro
         AND AQPC589EMP = ve_emp
         AND AQPC589MOD = ve_mod
         AND AQPC589SUC = ve_suc
         AND AQPC589MDA = ve_mda
         AND AQPC589PAP = ve_pap
         AND AQPC589CTA = ve_cta
         AND AQPC589OPER = ve_ope
         AND AQPC589SBOP = ve_sbo
         AND AQPC589TOP = ve_top
         AND AQPC589ESTPRO = 'P'
         AND AQPC589ESTHAB = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        vo_cod_error := '0010';
        vo_msg_error := 'No se pudo realizar el calculo';
    END;
    COMMIT;
  exception
    when others then
      null;
  end;
  procedure sp_cr_validar_credito(ve_emp       in number,
                                  ve_mod       in number,
                                  ve_suc       in number,
                                  ve_mda       in number,
                                  ve_pap       in number,
                                  ve_cta       in number,
                                  ve_ope       in number,
                                  ve_sbo       in number,
                                  ve_top       in number,
                                  ve_fec       in date,
                                  vo_rpta      out varchar,
                                  vo_cod_error out varchar,
                                  vo_msg_error out varchar) is
  
    v_existe           number(10);
    VI_DIAS_TOLERANCIA number(9);
    vi_fec             date;
  
  begin
    vo_rpta            := 'S';
    VI_DIAS_TOLERANCIA := 0;
    vo_cod_error       := '0000';
    vo_msg_error       := '';
  
    BEGIN
      --GUIA ESPECIAL PARA INCREMENTAR LOS DIAS DE VARIACION
      SELECT TP1NRO1
        INTO VI_DIAS_TOLERANCIA
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11161
         AND TP1CORR1 = 50
         AND TP1CORR2 = 3
         AND TP1CORR3 = 1;
      --agregado cambio en la fecha
      vi_fec := (ve_fec - VI_DIAS_TOLERANCIA);
    EXCEPTION
      WHEN OTHERS THEN
        VI_DIAS_TOLERANCIA := 0;
    END;
  
    BEGIN
      SELECT count(*)
        INTO V_EXISTE
        FROM AQPC589 A
       WHERE A.AQPC589EMP = ve_emp
         AND A.AQPC589MOD = ve_mod
         AND A.AQPC589SUC = ve_suc
         AND A.AQPC589MDA = ve_mda
         AND A.AQPC589PAP = ve_pap
         AND A.AQPC589CTA = ve_cta
         AND A.AQPC589OPER = ve_ope
         AND A.AQPC589SBOP = ve_sbo
         AND A.AQPC589TOP = ve_top
         AND A.AQPC589ESTPRO = 'A'
         AND A.AQPC589ESTHAB = 'H'
         AND A.AQPC589FECPRO >= vi_fec;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF v_existe > 0 THEN
      vo_rpta := 'S';
    ELSE
      vo_rpta := 'N';
      UPDATE AQPC589 A
         SET AQPC589ESTHAB = 'I'
       WHERE A.AQPC589EMP = ve_emp
         AND A.AQPC589MOD = ve_mod
         AND A.AQPC589SUC = ve_suc
         AND A.AQPC589MDA = ve_mda
         AND A.AQPC589PAP = ve_pap
         AND A.AQPC589CTA = ve_cta
         AND A.AQPC589OPER = ve_ope
         AND A.AQPC589SBOP = ve_sbo
         AND A.AQPC589TOP = ve_top
         AND A.AQPC589FECPRO < vi_fec;
    END IF;
  exception
    when others then
      null;
  end;
  procedure sp_desvincular_creditos(ve_pai       in number,
                                    ve_tdo       in number,
                                    ve_pnd       in varchar,
                                    ve_fecpro    in date,
                                    vo_cod_error out varchar,
                                    vo_msg_error out varchar) is
  begin
    vo_cod_error := '0000';
    vo_msg_error := '';
    ---insert into prueba_log(msg)values(ve_pai||'-'||ve_tdo||'-'||ve_pnd||'-'||ve_fecpro);
    UPDATE AQPC589 A
       SET AQPC589ESTHAB = 'I'
     WHERE A.AQPC589PAIS = ve_pai
       AND A.AQPC589PTDC = ve_tdo
       AND A.AQPC589DNI = RPAD(ve_pnd, 12, ' ')
       AND A.AQPC589ESTPRO IN ('A', 'P')
       AND A.AQPC589ESTHAB = 'H'
       AND A.aqpc589fecpro <= ve_fecpro;
    COMMIT;
  exception
    when others then
      vo_cod_error := '0011';
      vo_msg_error := 'No se puede desvincular el crédito seleccionado, valide si previamente ya lo vinculo y figura en estado un valor diferente a NO GESTIONADO';
  end;
  procedure sp_cr_updDeudaTot(ve_pai       in number,
                              ve_tdo       in number,
                              ve_pnd       in varchar,
                              ve_emp       in number,
                              ve_mod       in number,
                              ve_suc       in number,
                              ve_mda       in number,
                              ve_pap       in number,
                              ve_cta       in number,
                              ve_ope       in number,
                              ve_sbo       in number,
                              ve_top       in number,
                              ve_dTotal    in number,
                              ve_indCovid  in varchar,
                              ve_indExoPrv in varchar,
                              ve_fecpro    in date,
                              vo_cod_error out varchar,
                              vo_msg_error out varchar) is
    vi_existe number(9);
  begin
    vo_cod_error := '0000';
    vo_msg_error := '';
    vi_existe    := 0;
    BEGIN
      SELECT COUNT(*)
        INTO vi_existe
        FROM AQPC589 A
       WHERE A.AQPC589PAIS = ve_pai
         AND A.AQPC589PTDC = ve_tdo
         AND A.AQPC589DNI = RPAD(ve_pnd, 12, ' ')
         AND A.AQPC589EMP = ve_emp
         AND A.AQPC589MOD = ve_mod
         AND A.AQPC589SUC = ve_suc
         AND A.AQPC589MDA = ve_mda
         AND A.AQPC589PAP = ve_pap
         AND A.AQPC589CTA = ve_cta
         AND A.AQPC589OPER = ve_ope
         AND A.AQPC589SBOP = ve_sbo
         AND A.AQPC589TOP = ve_top
         AND A.AQPC589ESTPRO = 'P'
         AND A.AQPC589ESTHAB = 'H'
         AND A.aqpc589fecpro = ve_fecpro;
    EXCEPTION
      WHEN OTHERS THEN
        vo_cod_error := '0012';
        vo_msg_error := 'No existe gestion, volver a vincular todos los creditos para aplicar el descuento';
    END;
    --SI ESTA VOLVIENDO A GESTIONAR SE DESVINCULAN LAS GESTIONES ANTERIORES.
    BEGIN
      UPDATE AQPC589 A
         SET AQPC589ESTHAB = 'I'
       WHERE A.AQPC589PAIS = ve_pai
         AND A.AQPC589PTDC = ve_tdo
         AND A.AQPC589DNI = RPAD(ve_pnd, 12, ' ')
         AND A.AQPC589EMP = ve_emp
         AND A.AQPC589MOD = ve_mod
         AND A.AQPC589SUC = ve_suc
         AND A.AQPC589MDA = ve_mda
         AND A.AQPC589PAP = ve_pap
         AND A.AQPC589CTA = ve_cta
         AND A.AQPC589OPER = ve_ope
         AND A.AQPC589SBOP = ve_sbo
         AND A.AQPC589TOP = ve_top
         AND A.AQPC589ESTPRO = 'A'
         AND A.AQPC589ESTHAB = 'H'
         AND A.aqpc589fecpro <= ve_fecpro;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --SI ESTA VOLVIENDO A GESTIONAR DEBE HABER UNA GESTION VINCULADA AL DIA DE HOY.
    if vi_existe = 0 then
      vo_cod_error := '0013';
      vo_msg_error := 'No existe gestion, volver a vincular todos los creditos para calcular la condonación';
    end if;
    --SE ACUALIZAN LOS IMPORTES
    BEGIN
      UPDATE AQPC589 A
         SET A.AQPC589MPRV = ve_dTotal,
             A.AQPC589INDC = ve_indCovid,
             A.AQPC589EPRV = ve_indExoPrv
       WHERE A.AQPC589PAIS = ve_pai
         AND A.AQPC589PTDC = ve_tdo
         AND A.AQPC589DNI = RPAD(ve_pnd, 12, ' ')
         AND A.AQPC589EMP = ve_emp
         AND A.AQPC589MOD = ve_mod
         AND A.AQPC589SUC = ve_suc
         AND A.AQPC589MDA = ve_mda
         AND A.AQPC589PAP = ve_pap
         AND A.AQPC589CTA = ve_cta
         AND A.AQPC589OPER = ve_ope
         AND A.AQPC589SBOP = ve_sbo
         AND A.AQPC589TOP = ve_top
         AND A.AQPC589ESTPRO = 'P'
         AND A.AQPC589ESTHAB = 'H'
         AND A.aqpc589fecpro = ve_fecpro;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  exception
    when others then
      null;
  end;

  procedure SP_OBTENER_MNT_TOTALDEUDA(ve_fecpro    in date,
                                      ve_pai       in number,
                                      ve_tdo       in number,
                                      ve_pnd       in varchar,
                                      ve_usr       in varchar,
                                      ve_dTotal    out number,
                                      vo_cod_error out varchar,
                                      vo_msg_error out varchar) IS
  BEGIN
    vo_cod_error := '0000';
    vo_msg_error := '';
    BEGIN
      SELECT SUM(A.AQPC589MTDEU) - SUM(A.AQPC589INCON)
        INTO ve_dTotal
        FROM AQPC589 A
       WHERE AQPC589FECPRO = ve_fecpro
         AND AQPC589PAIS = ve_pai
         AND AQPC589PTDC = ve_tdo
         AND AQPC589DNI = RPAD(ve_pnd, 12, ' ')
         AND AQPC589ESTHAB = 'H'
         AND AQPC589ESTPRO in ('A');
    EXCEPTION
      WHEN OTHERS THEN
        ve_dTotal := 0;
    END;
  END;

end pq_cr_impulso_peru_hs;
/

