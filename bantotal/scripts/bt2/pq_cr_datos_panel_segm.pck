create or replace package "PQ_CR_DATOS_PANEL_SEGM" is

  -- *****************************************************************
  -- Nombre                     : PQ_CR_DATOS_PANEL_SEGM
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2023.06.06
  -- Autor de Creación          : APACHECO
  -- Uso                        : procesa datos reporte de segmentacion
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : 
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 09/01/2025 YYAMPI se ajusto SP_CR_INSERTA_AQPC221   
  -- *****************************************************************
  -------------------------------------------------------------------------  

  procedure sp_cr_busqueda_datos_conformidad(p_n_instan in number,
                                             p_v_fecncf out varchar2,
                                             p_v_ususol out varchar2,
                                             p_v_consd1 out varchar2,
                                             p_v_consd2 out varchar2,
                                             p_n_gaexcp out number);

  procedure sp_cr_obtiene_segmentacion(p_n_instan    in number,
                                       p_v_pai       IN NUMBER,
                                       p_v_tdo       IN NUMBER,
                                       p_v_doc       IN VARCHAR2,
                                       p_v_endeudado OUT VARCHAR2,
                                       p_v_lista     OUT VARCHAR2,
                                       p_v_inst      OUT VARCHAR2);

  procedure sp_DiaAtr_ultima(pn_emp    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_ope    in number,
                             pn_Sbo    in number,
                             pn_top    in number,
                             pd_fecpro in date,
                             pd_fecven in date,
                             ln_atrult out number);

  PROCEDURE SP_CR_INSERTA_AQPC220(V_AQPC220USU IN VARCHAR2,
                                  V_AQPC220FEC IN DATE,
                                  V_AQPC220HOR IN VARCHAR2,
                                  V_AQPC220DOC IN VARCHAR2,
                                  V_AQPC220CRE IN VARCHAR2,
                                  V_AQPC220SAL IN NUMBER,
                                  V_AQPC220MAY IN NUMBER,
                                  V_AQPC220DIE IN NUMBER,
                                  V_AQPC220NUM IN NUMBER,
                                  V_AQPC220FEA IN DATE,
                                  V_AQPC220NUI IN NUMBER,
                                  V_AQPC220SEG IN VARCHAR2,
                                  V_AQPC220FSO IN VARCHAR2,
                                  V_AQPC220USO IN VARCHAR2,
                                  V_AQPC220CO1 IN VARCHAR2,
                                  V_AQPC220CO2 IN VARCHAR2,
                                  V_AQPC220NUE IN NUMBER,
                                  V_AQPC220ULT IN VARCHAR2,
                                  V_AQPC220SOB IN VARCHAR2,
                                  V_AQPC220LIS IN VARCHAR2,
                                  V_AQPC220INC IN VARCHAR2,
                                  V_AQPC220CVG IN VARCHAR2);

  PROCEDURE SP_CR_INSERTA_AQPC221(FECHA_SISTEMA    IN DATE,
                                  HORA_SISTEMA     IN VARCHAR2,
                                  USUARIO_SISTEMA  IN VARCHAR2,
                                  FECHA_INICIO     IN DATE,
                                  FECHA_FIN        IN DATE,
                                  FECHA_PRODUCCION IN DATE,
                                  SEGMENTO         IN VARCHAR2);

  PROCEDURE SP_VARIABLES_SEGMENTACION(INSTANCIA      IN NUMBER,
                                      P_NUM_CAM_SEG  OUT NUMBER,
                                      P_FECH_CAM     OUT DATE,
                                      P_NUM_INST_CAM OUT NUMBER,
                                      P_ULT_SEG      OUT VARCHAR,
                                      CRED_VIG_ATR   OUT VARCHAR);

  PROCEDURE SP_VARIABLE_ULTSEG(PN_INS IN NUMBER, PV_SEG OUT VARCHAR);

end PQ_CR_DATOS_PANEL_SEGM;
 /* GOLDENGATE_DDL_REPLICATION */
/

create or replace package body "PQ_CR_DATOS_PANEL_SEGM" is

  procedure sp_cr_busqueda_datos_conformidad(p_n_instan in number,
                                             p_v_fecncf out varchar2,
                                             p_v_ususol out varchar2,
                                             p_v_consd1 out varchar2,
                                             p_v_consd2 out varchar2,
                                             p_n_gaexcp out number) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_busqueda_datos_conformidad
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.07.11
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Busca datos consulta buro
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : p_n_instan ( Instancia )
    -- Parámetros de Salida       : p_v_fecncf ( Fecha No Conformidad )
    --                              p_v_ususol ( Usuario Solicitud )
    --                              p_v_consd1 ( Consideracion 1 )
    --                              p_v_consd2 ( Consideracion 2 )
    --                              p_n_gaexcp ( Excepcion GA )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- ***************************************************************** 
    pn_pais   number := 0;
    pn_tdoc   number := 0;
    pn_ndoc   varchar2(12) := '';
    ln_meses  number := 0;
    ld_pgfape date;
  begin
    --Obtener fecha del sistema
    begin
      select pgfape into ld_pgfape from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
    --Obtener documento del cliente
    begin
      select s.sng001pais, s.sng001tdoc, trim(s.sng001ndoc), s.sng001ase
        into pn_pais, pn_tdoc, pn_ndoc, p_v_ususol
        from sng001 s
       where s.sng001inst = p_n_instan
         and rownum = 1;
    exception
      when others then
        p_v_ususol := '';
    end;
    --Guia de Meses    
    begin
      select tpnro
        into ln_meses
        from fst098
       where pgcod = 1
         and tpcod = 7752
         and tpcorr = 12;
    exception
      when others then
        ln_meses := 12;
    end;
    --Fecha de No Conformidad
    begin
      select fn_cum_cat(to_char(T.aqpb947fconf) || ',')
        into p_v_fecncf
        from (select a.aqpb947fconf
                from aqpb947 a, xwf700 b, fsd010 c
               where a.aqpb947pais = pn_pais
                 and a.aqpb947tdoc = pn_tdoc
                 and trim(a.aqpb947ndoc) = pn_ndoc
                 and a.aqpb947estcf = 'NC'
                 and a.aqpb947esta = 'H'
                 and b.xwfprcins = a.aqpb947inst2
                 and b.xwfempresa = c.pgcod
                 and b.xwfmodulo = c.aomod
                 and b.xwfsucursal = c.aosuc
                 and b.xwfmoneda = c.aomda
                 and b.xwfpapel = c.aopap
                 and b.xwfcuenta = c.aocta
                 and b.xwfoperacion = c.aooper
                 and b.xwfsubope = c.aosbop
                 and b.xwftipope = c.aotope
                 and b.xwfcar3 = '1'
                 and a.aqpb947fecp2 >= ADD_MONTHS(ld_pgfape, -12)
               group by a.aqpb947fconf) T;
      p_v_fecncf := SUBSTR(p_v_fecncf, 1, LENGTH(p_v_fecncf) - 1);
    exception
      when others then
        p_v_fecncf := '';
    end;
    --Consideraciones
    begin
      select a.aqpb947cond1, a.aqpb947cond2
        into p_v_consd1, p_v_consd2
        from aqpb947 a
       where a.aqpb947inst1 = p_n_instan
         and a.aqpb947esta = 'P'
         and rownum = 1
       order by a.aqpb947fecp2 desc, a.aqpb947horp2 desc;
    exception
      when others then
        p_v_consd1 := '';
        p_v_consd2 := '';
    end;
    --N° de Excepciones
    begin
      select nvl(sum(T.aqpb947nexcp), 0)
        into p_n_gaexcp
        from (select a.aqpb947inst2,
                     a.aqpb947corr2,
                     a.aqpb947fecp2,
                     a.aqpb947horp2,
                     a.aqpb947nexcp
                from aqpb947 a, xwf700 b, fsd010 c
               where a.aqpb947pais = pn_pais
                 and a.aqpb947tdoc = pn_tdoc
                 and trim(a.aqpb947ndoc) = pn_ndoc
                 and a.aqpb947estcf = 'EG'
                 and a.aqpb947esta = 'H'
                 and b.xwfprcins = a.aqpb947inst2
                 and b.xwfempresa = c.pgcod
                 and b.xwfmodulo = c.aomod
                 and b.xwfsucursal = c.aosuc
                 and b.xwfmoneda = c.aomda
                 and b.xwfpapel = c.aopap
                 and b.xwfcuenta = c.aocta
                 and b.xwfoperacion = c.aooper
                 and b.xwfsubope = c.aosbop
                 and b.xwftipope = c.aotope
                 and b.xwfcar3 = '1'
                 and a.aqpb947fecp2 >= ADD_MONTHS(ld_pgfape, -12)
               group by a.aqpb947inst2,
                        a.aqpb947corr2,
                        a.aqpb947fecp2,
                        a.aqpb947horp2,
                        a.aqpb947nexcp) T;
    exception
      when others then
        p_n_gaexcp := 0;
    end;
  
  end sp_cr_busqueda_datos_conformidad;

  procedure sp_cr_obtiene_segmentacion(p_n_instan    in number,
                                       p_v_pai       IN NUMBER,
                                       p_v_tdo       IN NUMBER,
                                       p_v_doc       IN VARCHAR2,
                                       p_v_endeudado OUT VARCHAR2,
                                       p_v_lista     OUT VARCHAR2,
                                       p_v_inst      OUT VARCHAR2) as
  
    VAR_SOB NUMBER(1);
    pn_pais number := 0;
    pn_tdoc number := 0;
    pn_ndoc varchar2(12) := '';
  begin
    /*BEGIN
      SELECT JAQZ870SEGI, JAQZ870SEGF INTO p_v_segini, p_v_segfin FROM JAQZ870 where 
      jaqz870inst = p_n_instan AND 
      JAQZ870FECP = (SELECT MAX(JAQZ870FECP) FROM JAQZ870 where jaqz870inst = p_n_instan) AND
      JAQZ870HORP = (SELECT MAX(JAQZ870HORP) FROM JAQZ870 where jaqz870inst = p_n_instan AND 
      JAQZ870FECP = (SELECT MAX(JAQZ870FECP) FROM JAQZ870 where jaqz870inst = p_n_instan)); 
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
      p_v_segini := '';
      p_v_segfin := ''; 
    END;*/
  
    --Obtener documento del cliente
    begin
      select s.sng001pais, s.sng001tdoc, trim(s.sng001ndoc)
        into pn_pais, pn_tdoc, pn_ndoc
        from sng001 s
       where s.sng001inst = p_n_instan
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    BEGIN
      SELECT JAQY490SOB
        INTO VAR_SOB
        FROM JAQY490S
       WHERE JAQY490PAI = pn_pais
         AND JAQY490TDO = pn_tdoc
         AND JAQY490NDO = rpad(pn_ndoc, 12, ' ');
      IF VAR_SOB = 0 THEN
        p_v_endeudado := 'NO';
      ELSIF VAR_SOB IS NULL THEN
        p_v_endeudado := 'NO';
      ELSIF VAR_SOB = 1 THEN
        p_v_endeudado := 'SI';
      ELSIF VAR_SOB = 2 THEN
        p_v_endeudado := 'SI';
      END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_v_endeudado := 'NO';
    END;
  
    BEGIN
      SELECT 'SI'
        INTO p_v_lista
        FROM FSD201
       WHERE LNPAIS = pn_pais
         AND LNTDOC = pn_tdoc
         AND LNNDOC = rpad(pn_ndoc, 25, ' ');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_v_lista := 'NO';
    END;
  
    BEGIN
      SELECT 'SI' INTO p_v_inst FROM JAQM750 WHERE JAQM750INS = p_n_instan;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_v_inst := 'NO';
    END;
  end sp_cr_obtiene_segmentacion;

  procedure sp_DiaAtr_ultima(pn_emp    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_ope    in number,
                             pn_Sbo    in number,
                             pn_top    in number,
                             pd_fecpro in date,
                             pd_fecven in date,
                             ln_atrult out number) is
    ld_ultfec    date;
    ld_ultfecpen date;
  begin
    --obtiene ultima fecha de vigente de pago
    begin
      select max(a.ppfpag)
        into ld_ultfec
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_Sbo
         and a.pptope = pn_top
         and a.Pp1stat = 'T'
         and a.D602co = 'S'
         and a.pp1fech <= pd_fecpro;
    exception
      when no_data_found then
        begin
          select /*+ parallel(n,2,1)*/
           min(n.ppfpag)
            into ld_ultfec
            from fsd601 n
           where n.pgcod = pn_emp
             and n.ppcta = pn_cta
             and n.ppmda = pn_mda
             and n.ppsuc = pn_suc
             and n.pppap = pn_pap
             and n.ppoper = pn_ope
             and n.ppsbop = pn_sbo
             and n.pptope = pn_top
             and n.ppmod = pn_mod
             and n.d601co = 'S'
             and (n.ppcap + n.ppint) <> 0
             and n.ppfpag <= pd_fecpro;
        exception
          when no_data_found then
            ld_ultfec := null;
        end;
    end;
    --obtiene la siguiente fecha de pago calendario
    begin
      select min(a.ppfpag)
        into ld_ultfecpen
        from fsd601 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_Sbo
         and a.pptope = pn_top
         and a.ppfpag > ld_ultfec;
    exception
      when no_data_found then
        ld_ultfecpen := ld_ultfec;
    end;
    --calcula los dias de atraso de la ultima cuota  
    If pn_mod in (200, 33, 141) Then
      ln_atrult := pd_fecpro - pd_fecven;
    
    Else
      ln_atrult := pd_fecpro - ld_ultfecpen;
    
      /*
      begin      
        select + parallel(n,2,1)
         (n.pp1fech - pd_fecpro)
          into ln_atrult
          from fsd602 n
         where n.pgcod = pn_emp
           and n.ppcta = pn_cta
           and n.ppmda = pn_mda
           and n.ppsuc = pn_suc
           and n.pppap = pn_pap
           and n.ppoper = pn_ope
           and n.ppsbop = pn_sbo
           and n.pptope = pn_top
           and n.ppmod = pn_mod
           and n.ppfpag = ld_ultfecpen
           and n.d602co = 'S'
           and n.pp1stat = 'T'
           and n.pp1fech <= pd_fecpro
           and rownum < 2;
      exception
        when no_data_found then
          ln_atrult := pd_fecpro - ld_ultfec;
      end;
      */
    End if;
    If ln_atrult < 0 then
      ln_atrult := 0;
    End if;
  end Sp_DiaAtr_Ultima;

  PROCEDURE SP_CR_INSERTA_AQPC220(V_AQPC220USU IN VARCHAR2,
                                  V_AQPC220FEC IN DATE,
                                  V_AQPC220HOR IN VARCHAR2,
                                  V_AQPC220DOC IN VARCHAR2,
                                  V_AQPC220CRE IN VARCHAR2,
                                  V_AQPC220SAL IN NUMBER,
                                  V_AQPC220MAY IN NUMBER,
                                  V_AQPC220DIE IN NUMBER,
                                  V_AQPC220NUM IN NUMBER,
                                  V_AQPC220FEA IN DATE,
                                  V_AQPC220NUI IN NUMBER,
                                  V_AQPC220SEG IN VARCHAR2,
                                  V_AQPC220FSO IN VARCHAR2,
                                  V_AQPC220USO IN VARCHAR2,
                                  V_AQPC220CO1 IN VARCHAR2,
                                  V_AQPC220CO2 IN VARCHAR2,
                                  V_AQPC220NUE IN NUMBER,
                                  V_AQPC220ULT IN VARCHAR2,
                                  V_AQPC220SOB IN VARCHAR2,
                                  V_AQPC220LIS IN VARCHAR2,
                                  V_AQPC220INC IN VARCHAR2,
                                  V_AQPC220CVG IN VARCHAR2) AS
    V_CORRELATIVO NUMBER(17, 0);
  BEGIN
  
    BEGIN
      DELETE FROM AQPC220
       WHERE AQPC220USU = V_AQPC220USU
         AND AQPC220FEC = V_AQPC220FEC
         AND AQPC220DOC = V_AQPC220DOC;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT NVL(MAX(AQPC220COR), 0) + 1
        INTO V_CORRELATIVO
        FROM AQPC220
       WHERE AQPC220USU = V_AQPC220USU
         AND AQPC220FEC = V_AQPC220FEC;
      --AND AQPC220HOR = V_AQPC220HOR
      --AND AQPC220DOC = V_AQPC220DOC
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      INSERT INTO AQPC220
        (AQPC220USU,
         AQPC220FEC,
         AQPC220HOR,
         AQPC220DOC,
         AQPC220CRE,
         AQPC220SAL,
         AQPC220MAY,
         AQPC220DIE,
         AQPC220NUM,
         AQPC220FEA,
         AQPC220NUI,
         AQPC220SEG,
         AQPC220FSO,
         AQPC220USO,
         AQPC220CO1,
         AQPC220CO2,
         AQPC220NUE,
         AQPC220ULT,
         AQPC220SOB,
         AQPC220LIS,
         AQPC220INC,
         AQPC220CVG,
         AQPC220COR)
      VALUES
        (V_AQPC220USU,
         TO_DATE(SYSDATE, 'dd/mm/rrrr'),
         TO_CHAR(SYSDATE, 'HH24:mi:ss'),
         V_AQPC220DOC,
         V_AQPC220CRE,
         V_AQPC220SAL,
         V_AQPC220MAY,
         V_AQPC220DIE,
         V_AQPC220NUM,
         V_AQPC220FEA,
         V_AQPC220NUI,
         V_AQPC220SEG,
         V_AQPC220FSO,
         V_AQPC220USO,
         V_AQPC220CO1,
         V_AQPC220CO2,
         V_AQPC220NUE,
         V_AQPC220ULT,
         V_AQPC220SOB,
         V_AQPC220LIS,
         V_AQPC220INC,
         V_AQPC220CVG,
         V_CORRELATIVO);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END SP_CR_INSERTA_AQPC220;

  PROCEDURE SP_CR_INSERTA_AQPC221(
                                  -- AUTOR: Milton Cordova
                                  -- FECHA: 08/05/2023
                                  FECHA_SISTEMA    IN DATE,
                                  HORA_SISTEMA     IN VARCHAR2,
                                  USUARIO_SISTEMA  IN VARCHAR2,
                                  FECHA_INICIO     IN DATE,
                                  FECHA_FIN        IN DATE,
                                  FECHA_PRODUCCION IN DATE,
                                  SEGMENTO         IN VARCHAR2) AS
    --
    vi_cuenta       xwf700.xwfcuenta%type;
    vi_pepais       fsr008.pepais%type;
    vi_petdoc       fsr008.petdoc%type;
    vi_pendoc       CHAR(12);
    CONTADOR        NUMBER(17, 0);
    DES_REGION      VARCHAR2(30);
    DES_ZONA        CHAR(30);
    DES_AGENCIA     CHAR(30);
    P_SUCURSAL      NUMBER(3, 0);
    P_MODULO        NUMBER(3, 0);
    P_MDNOM         VARCHAR(50);
    P_PGFAPE        DATE;
    P_NOMBRE        VARCHAR(70); -- MCORDOVA 23/10/2023 SE INCREMENTA TAMAÑO DE VARIABLE
    P_SEGMENTO      NUMBER(1);
    P_USEP          VARCHAR(10);
    P_FECP          DATE;
    P_HORP          VARCHAR(8);
    P_SEGI          VARCHAR(50);
    P_SEGF          VARCHAR(50);
    P_SEGMENTO_DESC VARCHAR(50);
    P_MONTO         NUMBER(17, 2);
    P_ASESOR        VARCHAR(10);
    P_SUPLENTE      VARCHAR(10);
    P_DESC_EXC      VARCHAR(2);
    P_CUENTA        NUMBER(9, 0);
  
    CURSOR INSERTA_AQPC221 IS
      SELECT T2.JAQZ870INST  P_INST,
             T1.AQPB947USRP  P_USEP,
             T1.AQPB947FECP1 P_FECP,
             T1.AQPB947HORP1 P_HORP,
             T2.JAQZ870USEP  P_UCA,
             T2.JAQZ870FECP  P_FCA,
             T2.JAQZ870HORP  P_HCA,
             T2.JAQZ870SEGI  P_SEGI,
             T2.JAQZ870SEGF  P_SEGF,
             T1.AQPB947USRCF P_USRCF,
             T1.AQPB947CTA   P_CTA,
             T1.AQPB947COND1 P_CODC1,
             T1.AQPB947COND2 P_CODC2,
             T1.AQPB947RESUL P_RESUL,
             T1.AQPB947SOLIC P_SOLIC,
             T1.AQPB947OPCIO P_OPCIO,
             T1.AQPB947DEUDA P_DEUDA,
             T1.AQPB947GLOSA P_GLOSA,
             T1.AQPB947NEXCP P_NEXCP,
             T1.AQPB947VAR1  P_VAR1,
             T1.AQPB947VAR2  P_VAR2,
             T1.AQPB947VAR3  P_VAR3,
             T1.AQPB947VAR4  P_VAR4,
             T1.AQPB947VAR5  P_VAR5,
             T1.AQPB947VAR6  P_VAR6,
             T1.AQPB947VAR7  P_VAR7,
             T1.AQPB947VAR8  P_VAR8,
             T1.AQPB947VAR9  P_VAR9,
             T1.AQPB947VAR10 P_VAR10,
             T1.AQPB947VAR11 P_VAR11,
             T1.AQPB947VAR12 P_VAR12,
             T1.AQPB947VAR13 P_VAR13,
             T1.AQPB947VAR14 P_VAR14,
             T1.AQPB947VAR15 P_VAR15,
             T1.AQPB947VAR16 P_VAR16,
             T1.AQPB947VAR17 P_VAR17,
             T1.AQPB947VAR18 P_VAR18,
             T1.AQPB947VAR19 P_VAR19,
             T1.AQPB947VAR20 P_VAR20,
             T1.AQPB947VAR21 P_VAR21,
             T1.AQPB947VAR22 P_VAR22,
             T1.AQPB947VAR23 P_VAR23,
             T1.AQPB947VAR24 P_VAR24,
             T1.AQPB947VAR25 P_VAR25,
             T1.AQPB947VAR26 P_VAR26,
             T1.AQPB947VAR27 P_VAR27,
             T1.AQPB947VAR28 P_VAR28,
             T1.AQPB947VAR29 P_VAR29,
             T1.AQPB947VAR30 P_VAR30,
             T1.AQPB947VAR31 P_VAR31,
             T1.AQPB947VAR32 P_VAR32,
             T1.AQPB947VAR33 P_VAR33,
             T1.AQPB947VAR34 P_VAR34,
             T1.AQPB947VAR35 P_VAR35,
             T1.AQPB947VAR36 P_VAR36,
             T1.AQPB947VAR37 P_VAR37,
             T1.AQPB947VAR38 P_VAR38,
             T1.AQPB947VAR39 P_VAR39,
             T1.AQPB947VAR40 P_VAR40,
             T1.AQPB947VAR41 P_VAR41,
             T1.AQPB947VAR42 P_VAR42,
             T1.AQPB947VAR43 P_VAR43,
             T1.AQPB947VAR44 P_VAR44,
             T1.AQPB947VAR45 P_VAR45,
             T1.AQPB947VAR46 P_VAR46,
             T1.AQPB947VAR47 P_VAR47,
             T1.AQPB947VAR48 P_VAR48,
             T1.AQPB947VAR49 P_VAR49,
             T1.AQPB947VAR50 P_VAR50,
             T1.AQPB947VAR51 P_VAR51,
             T1.AQPB947VAR52 P_VAR52,
             T1.AQPB947VAR53 P_VAR53,
             T1.AQPB947VAR54 P_VAR54,
             T1.AQPB947VAR55 P_VAR55,
             T1.AQPB947VAR56 P_VAR56,
             T1.AQPB947VAR57 P_VAR57,
             T1.AQPB947VAR58 P_VAR58,
             T1.AQPB947VAR59 P_VAR59,
             T1.AQPB947VAR60 P_VAR60,
             T1.AQPB947MYSAL P_MAYSAL,
             T1.AQPB947DATRE P_DIAATR,
             T1.AQPB947NCAMS P_NUMCAM,
             T1.AQPB947ULSEG P_ULTSEG
        FROM JAQZ870 T2
        LEFT JOIN AQPB947 T1
          ON (T1.AQPB947CORR2 = T2.JAQZ870CORR AND
             T1.AQPB947INST2 = T2.JAQZ870INST AND
             T1.AQPB947FECP2 = T2.JAQZ870FECP AND
             T1.AQPB947HORP2 = T2.JAQZ870HORP)
       WHERE (T2.JAQZ870FECP >= FECHA_INICIO AND
             T2.JAQZ870FECP <= FECHA_FIN)
         AND JAQZ870TIPC = TRIM(SEGMENTO);
  
  BEGIN
    SELECT NVL(MAX(AQPC221COR), 0) + 1
      INTO CONTADOR
      FROM AQPC221
     WHERE AQPC221FEC = FECHA_SISTEMA
       AND AQPC221HOR = HORA_SISTEMA
       AND AQPC221USU = USUARIO_SISTEMA;
  
    FOR X IN INSERTA_AQPC221 LOOP
      -- FECHA DE APERTURA 
      BEGIN
        SELECT PgFape INTO P_PGFAPE FROM FST017 WHERE PGCOD = 1;
      END;
      -- CLAVE DE CREDITO
      BEGIN
        SELECT XWFSUCURSAL, XWFMODULO, xwfcuenta, XWFMONTO1
          INTO P_SUCURSAL, P_MODULO, vi_cuenta, P_MONTO
          FROM XWF700
         WHERE XWFPRCINS = X.P_INST
           AND XWFCar3 = '1';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          P_SUCURSAL := 0;
          P_MODULO   := 0;
          vi_cuenta  := 0;
          P_MONTO    := 0;
        WHEN OTHERS THEN
          /*09/01/2025 YYAMPI se agrego la exception */
          P_SUCURSAL := 0;
          P_MODULO   := 0;
          vi_cuenta  := 0;
          P_MONTO    := 0;
      END;
    
      -- REGION
      BEGIN
        SELECT T2.Tp1desc
          INTO DES_REGION
          FROM FST811 T1
          JOIN FST198 T2
            ON T1.REGCOD = T2.TP1NRO2
         WHERE T1.OfiCod = P_SUCURSAL
           AND T1.RegCod < 100
           AND T2.Tp1cod1 = 10872
           AND Tp1corr1 = 11;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DES_REGION := '';
        WHEN OTHERS THEN
          /*09/01/2025 YYAMPI se agrego la exception */
          DES_REGION := '';
      END;
    
      -- ZONA
      BEGIN
        SELECT SUBSTR(T2.regnom, 1, 30)
          INTO DES_ZONA
          FROM FST811 T1
          JOIN FST810 T2
            ON T1.REGCOD = T2.REGCOD
         WHERE T1.OfiCod = P_SUCURSAL
           AND T1.RegCod < 100;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DES_ZONA := '';
        WHEN OTHERS THEN
          /*09/01/2025 YYAMPI se agrego la exception */
          DES_ZONA := '';
        
      END;
    
      -- SUCURSAL
      BEGIN
        SELECT Scnom
          INTO DES_AGENCIA
          FROM FST001
         WHERE SUCURS = P_SUCURSAL;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DES_AGENCIA := '';
        WHEN OTHERS THEN
          /*09/01/2025 YYAMPI se agrego la exception */
          DES_AGENCIA := '';
        
      END;
    
      -- MODULO
      BEGIN
        SELECT MDNOM INTO P_MDNOM FROM FST003 WHERE MODULO = P_MODULO;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          P_MDNOM := '';
        WHEN OTHERS THEN
          /*09/01/2025 YYAMPI se agrego la exception */
          P_MDNOM := '';
        
      END;
    
      BEGIN
        select PEPAIS, PETDOC, PENDOC
          INTO vi_pepais, vi_petdoc, vi_pendoc
          FROM FSR008
         WHERE CTNRO = vi_cuenta
           and TTCOD = 1
           AND CTTFIR = 'T';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          vi_pepais := 0;
          vi_petdoc := 0;
          vi_pendoc := '';
        WHEN OTHERS THEN
          /*09/01/2025 YYAMPI se agrego la exception */
          vi_pepais := 0;
          vi_petdoc := 0;
          vi_pendoc := '';
        
      END;
    
      BEGIN
        select SNG001ASE, SNG001CTA
          INTO P_ASESOR, P_CUENTA
          from sng001
         WHERE SNG001INST = X.P_INST;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          P_ASESOR := '';
        WHEN OTHERS THEN
          /*09/01/2025 YYAMPI se agrego la exception */
          P_ASESOR := '';
        
      END;
    
      BEGIN
        select (CASE
                 WHEN TRIM(SNG057SUP) IS NOT NULL THEN
                  SNG057SUP
                 ELSE
                  P_ASESOR
               END)
          INTO P_SUPLENTE
          from sng057
         WHERE SNG055EMP = 1
           AND SNG057USR = P_ASESOR;
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          P_SUPLENTE := P_ASESOR;
        WHEN OTHERS THEN
          /*09/01/2025 YYAMPI se agrego la exception */
          P_SUPLENTE := P_ASESOR;
        
      END;
    
      -- NOMBRE DE CLIENTE
      BEGIN
        IF vi_petdoc <> 9 AND vi_pepais = 604 THEN
          SELECT TRIM(pfape1) || ' ' || TRIM(pfape2) || ' ' || trim(pfnom1) || ' ' ||
                 TRIM(pfnom2)
            INTO P_NOMBRE
            FROM FSD002
           WHERE pfpais = vi_pepais
             and pftdoc = vi_petdoc
             and pfndoc = vi_pendoc;
        ELSIF vi_petdoc = 9 AND vi_pepais = 604 THEN
          SELECT trim(Pjrazs)
            INTO P_NOMBRE
            FROM FSD003
           WHERE Pjpais = vi_pepais
             AND Pjtdoc = vi_petdoc
             AND Pjndoc = vi_pendoc;
        END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          P_NOMBRE := '';
        WHEN OTHERS THEN
          /*09/01/2025 YYAMPI se agrego la exception */
          P_NOMBRE := '';
        
      END;
    
      pQ_CR_VERIFICASEGMENTO.sp_cr_SegmntoActual(X.P_INST, P_SEGMENTO);
      IF P_SEGMENTO = 1 THEN
        P_SEGMENTO_DESC := 'INDEPENDIENTE';
      ELSIF P_SEGMENTO = 2 THEN
        P_SEGMENTO_DESC := 'DEPENDIENTE';
      END IF;
    
      if X.P_NEXCP = 1 then
        P_DESC_EXC := 'SI';
      elsif X.P_NEXCP = 0 then
        P_DESC_EXC := 'NO';
      end if;
    
      -- INSERTA AQPC221  
      INSERT INTO AQPC221
        (AQPC221FEC,
         AQPC221HOR,
         AQPC221USU,
         AQPC221COR,
         AQPC221INS,
         AQPC221UAP,
         AQPC221FRE,
         AQPC221HRE,
         AQPC221UCA,
         AQPC221FCA,
         AQPC221HCA,
         AQPC221REG,
         AQPC221ZON,
         AQPC221AGE,
         AQPC221USS,
         AQPC221ANA,
         AQPC221NOM,
         AQPC221CTA,
         AQPC221MOD,
         AQPC221TIP,
         AQPC221MON,
         AQPC221SEA,
         AQPC221CO1,
         AQPC221CO2,
         AQPC221RES,
         AQPC221SAP,
         AQPC221TOP,
         AQPC221CON,
         AQPC221DEU,
         AQPC221GLO,
         AQPC221TCR,
         AQPC221EXC,
         AQPC221V01,
         AQPC221V02,
         AQPC221V03,
         AQPC221V04,
         AQPC221V05,
         AQPC221V06,
         AQPC221V07,
         AQPC221V08,
         AQPC221V09,
         AQPC221V10,
         AQPC221V11,
         AQPC221V12,
         AQPC221V13,
         AQPC221V14,
         AQPC221V15,
         AQPC221V16,
         AQPC221V17,
         AQPC221V18,
         AQPC221V19,
         AQPC221V20,
         AQPC221V21,
         AQPC221V22,
         AQPC221V23,
         AQPC221V24,
         AQPC221V25,
         AQPC221V26,
         AQPC221V27,
         AQPC221V28,
         AQPC221V29,
         AQPC221V30,
         AQPC221V31,
         AQPC221V32,
         AQPC221V33,
         AQPC221V34,
         AQPC221V35,
         AQPC221V36,
         AQPC221V37,
         AQPC221V38,
         AQPC221V39,
         AQPC221V40,
         AQPC221V41,
         AQPC221V42,
         AQPC221V43,
         AQPC221V44,
         AQPC221V45,
         AQPC221V46,
         AQPC221V47,
         AQPC221V48,
         AQPC221V49,
         AQPC221V50,
         AQPC221V51,
         AQPC221V52,
         AQPC221V53,
         AQPC221V54,
         AQPC221V55,
         AQPC221V56,
         AQPC221V57,
         AQPC221V58,
         AQPC221V59,
         AQPC221V60,
         AQPC221MAY,
         AQPC221DAR,
         AQPC221NUM,
         AQPC221ULT)
      VALUES
        (FECHA_SISTEMA,
         HORA_SISTEMA,
         USUARIO_SISTEMA,
         CONTADOR,
         X.P_INST,
         X.P_USEP,
         X.P_FECP,
         X.P_HORP,
         X.P_UCA,
         X.P_FCA,
         X.P_HCA,
         DES_REGION,
         DES_ZONA,
         DES_AGENCIA,
         P_SUPLENTE,
         P_ASESOR,
         P_NOMBRE,
         P_CUENTA,
         P_MODULO,
         P_MDNOM,
         P_MONTO,
         X.P_SEGI,
         X.P_CODC1,
         X.P_CODC2,
         X.P_RESUL,
         X.P_SEGF,
         X.P_SOLIC,
         X.P_OPCIO,
         X.P_DEUDA,
         X.P_GLOSA,
         P_SEGMENTO_DESC,
         P_DESC_EXC,
         X.P_VAR1,
         X.P_VAR2,
         X.P_VAR3,
         X.P_VAR4,
         X.P_VAR5,
         X.P_VAR6,
         X.P_VAR7,
         X.P_VAR8,
         X.P_VAR9,
         X.P_VAR10,
         X.P_VAR11,
         X.P_VAR12,
         X.P_VAR13,
         X.P_VAR14,
         X.P_VAR15,
         X.P_VAR16,
         X.P_VAR17,
         X.P_VAR18,
         X.P_VAR19,
         X.P_VAR20,
         X.P_VAR21,
         X.P_VAR22,
         X.P_VAR23,
         X.P_VAR24,
         X.P_VAR25,
         X.P_VAR26,
         X.P_VAR27,
         X.P_VAR28,
         X.P_VAR29,
         X.P_VAR30,
         X.P_VAR31,
         X.P_VAR32,
         X.P_VAR33,
         X.P_VAR34,
         X.P_VAR35,
         X.P_VAR36,
         X.P_VAR37,
         X.P_VAR38,
         X.P_VAR39,
         X.P_VAR40,
         X.P_VAR41,
         X.P_VAR42,
         X.P_VAR43,
         X.P_VAR44,
         X.P_VAR45,
         X.P_VAR46,
         X.P_VAR47,
         X.P_VAR48,
         X.P_VAR49,
         X.P_VAR50,
         X.P_VAR51,
         X.P_VAR52,
         X.P_VAR53,
         X.P_VAR54,
         X.P_VAR55,
         X.P_VAR56,
         X.P_VAR57,
         X.P_VAR58,
         X.P_VAR59,
         X.P_VAR60,
         X.P_MAYSAL,
         X.P_DIAATR,
         X.P_NUMCAM,
         X.P_ULTSEG);
      COMMIT;
      CONTADOR := 1 + CONTADOR;
    END LOOP;
  END;

  PROCEDURE SP_VARIABLES_SEGMENTACION(INSTANCIA      IN NUMBER,
                                      P_NUM_CAM_SEG  OUT NUMBER,
                                      P_FECH_CAM     OUT DATE,
                                      P_NUM_INST_CAM OUT NUMBER,
                                      P_ULT_SEG      OUT VARCHAR,
                                      CRED_VIG_ATR   OUT VARCHAR) IS
    P_PAIS            NUMBER(3);
    P_TIPDOC          NUMBER(2);
    P_DOCUMENTO       CHAR(12);
    MES1              NUMBER(17, 0);
    MES2              NUMBER(17, 0);
    P_FECHA_GUIA      DATE;
    P_PGFAPE          DATE;
    vi_fec_final      date;
    vi_contador       number(17, 0);
    P_INSTANCIA_SELEC NUMBER(17, 0);
    vi_corr           number;
    Diaatr            NUMBER(17, 0);
    AUXINSTANCIA2     NUMBER(17, 0);
    AUXINSTANCIA1     NUMBER(17, 9);
    cursor listar_cuentas(vi_pepais number,
                          vi_petdoc number,
                          vi_pendoc char) is
      select *
        from fsr008
       where pepais = vi_pepais
         and petdoc = vi_petdoc
         and pendoc = vi_pendoc;
  
    cursor listar_instancias(vi_cuenta number) is
      select *
        from xwf700
       where xwfcuenta = vi_cuenta
         AND XWfEmpresa = 1
         and xwfcar3 = '1';
  
    cursor listar_gestiones(vi_instancia number) is
      select * from JAQZ870 where JAQZ870INST = vi_instancia;
    --
    CURSOR listar_fsd010(x_empresa       number,
                         x_sucursal      number,
                         x_modulo        number,
                         x_moneda        number,
                         x_papel         number,
                         x_cuenta        number,
                         x_operacion     number,
                         x_suboperacion  number,
                         x_tipooperacion number) is
      select *
        from fsd010
       where Pgcod = x_empresa
         and Aomod = x_modulo
         and Aosuc = x_sucursal
         and Aomda = x_moneda
         and Aopap = x_papel
         and Aocta = x_cuenta
         and Aooper = x_operacion
         and Aosbop = x_suboperacion
         and Aotope = x_tipooperacion;
  
  BEGIN
  
    BEGIN
      PQ_CR_DATOS_PANEL_SEGM.SP_VARIABLE_ULTSEG(INSTANCIA, P_ULT_SEG);
    EXCEPTION
      WHEN OTHERS THEN
        P_ULT_SEG := '';
    END;
  
    BEGIN
      select SNG001Pais, SNG001Tdoc, SNG001NDoc
        INTO P_PAIS, P_TIPDOC, P_DOCUMENTO
        from sng001
       WHERE SNG001INST = INSTANCIA;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P_PAIS      := 0;
        P_TIPDOC    := 0;
        P_DOCUMENTO := '';
    END;
  
    BEGIN
      CRED_VIG_ATR := 'NO';
      SELECT PgFape INTO P_PGFAPE FROM FST017 WHERE PGCOD = 1;
      SELECT TPNRO - (TPNRO + TPNRO)
        INTO MES1
        FROM FST098
       WHERE TPCOD = 7752
         AND TPCORR = 9;
      SELECT TPNRO - (TPNRO + TPNRO)
        INTO MES2
        FROM FST098
       WHERE TPCOD = 7752
         AND TPCORR = 10;
      P_FECHA_GUIA := ADD_MONTHS(P_PGFAPE, MES1);
      vi_fec_final := ADD_MONTHS(P_PGFAPE, MES2);
      vi_contador  := 0;
    
      FOR x IN listar_cuentas(P_PAIS, P_TIPDOC, P_DOCUMENTO) LOOP
        FOR y IN listar_instancias(x.ctnro) LOOP
          P_INSTANCIA_SELEC := y.xwfprcins;
        
          FOR a IN listar_fsd010(y.XWfEmpresa,
                                 y.XWfSucursal,
                                 y.XWfModulo,
                                 y.XWfMoneda,
                                 y.XWfPapel,
                                 y.XWfCuenta,
                                 y.XWfOperacion,
                                 y.XWfSubope,
                                 y.XWfTipOpe) LOOP
            BEGIN
              IF A.Aostat <> 99 THEN
                pQ_CR_DATOS_PANEL_SEGM.sp_diaatr_ultima(y.XWfEmpresa,
                                                        y.XWfModulo,
                                                        y.XWfSucursal,
                                                        y.XWfMoneda,
                                                        y.XWfPapel,
                                                        y.XWfCuenta,
                                                        y.XWfOperacion,
                                                        y.XWfSubope,
                                                        y.XWfTipOpe,
                                                        P_PGFAPE,
                                                        A.aofvto,
                                                        Diaatr);
              
                IF Diaatr > 0 THEN
                  CRED_VIG_ATR := 'SI';
                
                END IF;
              
              END IF;
              vi_corr := 0;
              FOR z IN listar_gestiones(P_INSTANCIA_SELEC) LOOP
                AUXINSTANCIA2 := TRIM(TO_CHAR(Z.jaqz870inst)) +
                                 TRIM(TO_CHAR(Z.jaqz870fecp, 'ddmmyyyy')) +
                                 TRIM(TO_CHAR(Z.jaqz870corr));
                IF P_FECHA_GUIA <= z.jaqz870fecp AND
                   AUXINSTANCIA2 <> AUXINSTANCIA1 THEN
                  vi_contador   := vi_contador + 1;
                  AUXINSTANCIA1 := TRIM(TO_CHAR(Z.jaqz870inst)) +
                                   TRIM(TO_CHAR(Z.jaqz870fecp, 'ddmmyyyy')) +
                                   TRIM(TO_CHAR(Z.jaqz870corr));
                END IF;
              
                IF vi_fec_final <= z.jaqz870fecp THEN
                  if z.jaqz870fecp > vi_fec_final then
                    P_FECH_CAM     := z.jaqz870fecp;
                    vi_corr        := z.jaqz870corr;
                    P_NUM_INST_CAM := y.xwfprcins;
                  end if;
                end if;
              END LOOP;
            END;
          END LOOP;
        END LOOP;
      END LOOP;
      P_NUM_CAM_SEG := vi_contador;
      --P_FECH_CAM    := vi_fec_grab;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P_NUM_CAM_SEG := 0;
        P_FECH_CAM    := null;
        --TO_DATE('01/01/1900', 'dd/mm/yyyy');
    END;
  
  END;

  PROCEDURE SP_VARIABLE_ULTSEG(pn_ins IN NUMBER, pv_seg OUT VARCHAR) IS
    /*****************************************************************
    -- Nombre                     : Sp_ult_seg
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.07.20
    -- Autor de Creación          : YYAMPI
    -- Uso                        : calcular el segmento del ultimo credtito desembolsado
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_ins instancia
                                    
    -- Parámetros de Salida       : pv_seg segmento del cliente
                                    
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************/
  
    ld_fecdes      date;
    ln_instancia   number(10) := 0;
    lv_valseg      varchar2(30) := '';
    lc_segmentoact number(10) := 0;
    ln_segmfinal   number(10) := 0;
    ln_anoseg      number(4);
    ln_messeg      number(2);
    ln_pais        number(3) := 0;
    ln_tdoc        number(2) := 0;
    lv_ndoc        char(12) := '';
    ld_fecdesg     date;
  begin
  
    /*calcular el tipo de segmento*/
    begin
      pq_cr_verificasegmento.sp_cr_segmntoactual(ln_instancia     => pn_ins,
                                                 lc_segmntoactual => lc_segmentoact);
    
      if lc_segmentoact = 1 then
        --pyme                                       
        begin
          select decode(t.xwfmodulo, 103, 3, 1)
            into ln_segmfinal --micro             
            from xwf700 t
           where t.xwfprcins = pn_ins
             and t.xwfcar3 = '1';
        exception
          when others then
            ln_segmfinal := lc_segmentoact;
        end;
      else
        if lc_segmentoact = 2 then
          --consumo
          ln_segmfinal := lc_segmentoact;
        end if;
      end if;
    
    exception
      when others then
        ln_segmfinal := 0;
    end;
  
    /*calcular el ultimo credito desembolsado*/
    begin
      /*ULTIMO CREDITO DESEMBOLSADO*/
      select /*+ all_rows*/
       instancia, AOFVAL, pais, tdoc, ndoc
        into ln_instancia, ld_fecdes, ln_pais, ln_tdoc, lv_ndoc
        from (select /*+ all_rows*/
              /*c.PGCOD,
              c.AOMOD,
              c.AOSUC,
              c.AOMDA,
              c.AOPAP,
              c.AOCTA,
              c.AOOPER,
              c.AOSBOP,
              c.AOTOPE,*/
               i.sng001pais pais,
               i.sng001tdoc tdoc,
               i.sng001ndoc ndoc,
               c.AOFVAL,
               s.xwfprcins  instancia
                from fsr008 r, sng001 i, fsd010 c, fst111 m, xwf700 s
               where i.sng001inst = pn_ins --10406278 --instancia 
                 and r.PEPAIS = i.sng001pais
                 and r.PETDOC = i.sng001tdoc
                 and r.PENDOC = i.sng001ndoc
                 and r.TTCOD = 1
                 and r.CTTFIR = 'T'
                 and c.AOCTA = r.CTNRO
                 and c.PGCOD = 1
                 and (c.AOMOD = m.modulo or c.AOMOD = 117)
                 and m.dscod = 50
                 and c.PGCOD = s.xwfempresa
                 and c.AOMOD = s.xwfmodulo
                 and c.AOSUC = s.xwfsucursal
                 and c.AOMDA = s.xwfmoneda
                 and c.AOPAP = s.xwfpapel
                 and c.AOCTA = s.xwfcuenta
                 and c.AOOPER = s.xwfoperacion
                 and c.AOSBOP = s.xwfsubope
                 and c.AOTOPE = s.xwftipope
                 and s.xwfcar3 = '1'
               order by c.AOFVAL desc)
       where rownum = 1;
    exception
      when others then
        ln_instancia := 0;
        ld_fecdes    := null;
        ln_pais      := 0;
        ln_tdoc      := 0;
        lv_ndoc      := '';
    end;
  
    /*Calcular el ultimo segmento pae */
    begin
      select val
        into lv_valseg
        from (select /*+ all_rows*/
              --p.pae71ite , h.*, p.pae71val  , 
               substr(p.pae71val, 1, instr(p.pae71val, ':') - 1) val,
               h.TP1NRO2 prioridad,
               h.TP1DESC
                from fpae70 r, fpae71 p, fst198 h
               where r.pae51eva = p.pae51eva
                 and r.pae70nro = p.pae70nro
                 and r.pae51eva = 1
                 and r.pae70ins = ln_instancia --10402698 --10406278--9260072
                 and h.tp1cod = 1
                 and h.tp1cod1 = 10823
                 and h.tp1corr1 = 55
                 and h.TP1CORR2 = 1
                 and h.TP1CORR3 > 1
                 and h.TP1NRO3 = ln_segmfinal --1 --parametro        
                 and p.pae71ite = h.TP1NRO1
                    /*and h.TP1NRO2 in (select max(g.TP1NRO2)
                      from fst198 g
                     where g.tp1cod = 1
                       and g.tp1cod1 = 10823
                       and g.tp1corr1 = 55
                       and g.TP1CORR2 = 1
                       and g.TP1CORR3 > 1
                       and g.TP1NRO3 = ln_segmfinal--1 --parametro
                    )*/
                 and r.pae70nro = (select max(d.pae70nro)
                                     from fpae70 d
                                    where d.pae70ins = ln_instancia --10402698 --10406278--9260072
                                      and d.pae51eva = 1)
               order by 2 desc)
       where rownum = 1;
    
      pv_seg := lv_valseg;
    
    exception
      when others then
        lv_valseg := '';
        pv_seg    := lv_valseg;
      
        /*obtener de la segmentacion mensual*/
        ld_fecdesg := last_day(add_months(ld_fecdes, -1)); --cierre del mes anterior 
        ln_anoseg  := to_char(ld_fecdesg, 'RRRR');
        ln_messeg  := to_char(ld_fecdesg, 'MM');
      
        if ln_segmfinal = 1 /*pyme*/
         then
          begin
            select (select t.jaqy067ncal
                      from jaqy067 t
                     where t.jaqy067ccal = s.jaqy066calf) segmento
              into lv_valseg
              from jaqy066 s
             where s.jaqy066pano = ln_anoseg
               and s.jaqy066pmes = ln_messeg
               and s.jaqy066tse = 'N'
               and s.jaqy066paic = ln_pais
               and s.jaqy066tdoc = ln_tdoc
               and s.jaqy066tndoc = lv_ndoc;
          exception
            when others then
            
              begin
                select (select t.jaqy067ncal
                          from jaqy067 t
                         where t.jaqy067ccal = s.jaqy066calf) segmento
                  into lv_valseg
                  from jaqy066 s
                 where s.jaqy066pano = ln_anoseg
                   and s.jaqy066pmes = ln_messeg
                   and s.jaqy066tse = 'S'
                   and s.jaqy066paic = ln_pais
                   and s.jaqy066tdoc = ln_tdoc
                   and s.jaqy066tndoc = lv_ndoc;
              exception
                when others then
                  lv_valseg := '';
              end;
            
          end;
          --pyme
        else
          if ln_segmfinal = 2 /*consumo*/
           then
            begin
              select (select t.jaqz662ncal
                        from jaqz662 t
                       where t.jaqz662ccal = s.jaqz681calf) segmento
                into lv_valseg
                from jaqz681 s
               where s.jaqz681pano = ln_anoseg
                 and s.jaqz681pmes = ln_messeg
                 and s.jaqz681paic = ln_pais
                 and s.jaqz681tdoc = ln_tdoc
                 and s.jaqz681tndoc = lv_ndoc; --consumo
            exception
              when others then
                lv_valseg := '';
            end;
          else
            if ln_segmfinal = 3 /*micro*/
             then
              begin
                select (select t.aqpb916ncal
                          from aqpb916 t
                         where t.aqpb916ccal = s.jaqz674calf) segmento
                  into lv_valseg
                  from jaqz674 s
                 where s.jaqz674pano = ln_anoseg
                   and s.jaqz674pmes = ln_messeg
                   and s.jaqz674paic = ln_pais
                   and s.jaqz674tdoc = ln_tdoc
                   and s.jaqz674tndoc = lv_ndoc; --micro
              exception
                when others then
                  lv_valseg := '';
              end;
            end if;
          end if;
        
        end if;
    end;
  
    pv_seg := lv_valseg;
  
  exception
    when others then
      pv_seg := lv_valseg;
  END SP_VARIABLE_ULTSEG;

end PQ_CR_DATOS_PANEL_SEGM;
 /* GOLDENGATE_DDL_REPLICATION */
/

